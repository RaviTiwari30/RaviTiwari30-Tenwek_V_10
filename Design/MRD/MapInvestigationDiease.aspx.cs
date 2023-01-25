using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_MRD_MapInvestigationDiease : System.Web.UI.Page
    {
    private string TransactionID;
    private string LabType;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            TransactionID = Request.QueryString["TID"];
            ViewState["TransactionID"] = TransactionID;
            
            LabType = Request.QueryString["Type"];
            ViewState["LabType"] = LabType;

            //if (TransactionID.Contains("SHHI") == false)
            //    TransactionID = "ISHHI" + TransactionID;

            //if (Request.QueryString["PID"].ToString().Contains("LSHHI") == false)
            //    ViewState["PID"] = "LSHHI" + Request.QueryString["PID"].ToString();
            //else
            ViewState["PID"] = Request.QueryString["PID"];

            ViewState["TID"] = TransactionID.ToString();
            
            BindGrid(TransactionID, LabType);
            }
        }

    private void BindGrid(string TransactionID, string LabType)
    {
        StringBuilder sb = new StringBuilder();
        //if (LabType.ToUpper() == "IPD")
        //{
            sb.Append(" SELECT  inv.Investigation_Id,inv.Name,pli.Test_ID,pli.Result_Flag,ltd.LedgerTransactionNo,inv.ReportType FROM f_ledgertnxdetail ltd ");
            sb.Append(" INNER JOIN f_itemmaster im ON ltd.itemid=im.itemid INNER JOIN  f_subcategorymaster sc ON ");
            sb.Append(" im.SubCategoryID=sc.SubCategoryID INNER JOIN    f_configrelation con ON con.CategoryID=sc.CategoryID  ");
            sb.Append(" INNER JOIN patient_labinvestigation_opd pli ON pli.LedgerTransactionNo = ltd.LedgerTransactionNo and pli.Investigation_ID = im.Type_ID  ");
            sb.Append(" INNER JOIN investigation_master inv ON im.Type_ID=inv.Investigation_Id WHERE con.ConfigID=3 ");
            sb.Append(" AND ltd.TransactionID='" + TransactionID + "' AND ltd.IsVerified=1  GROUP BY inv.Investigation_ID ORDER BY inv.Name ");
        //}
        //else
        //{
        //    sb.Append(" SELECT  inv.Investigation_Id,inv.Name,plo.Test_ID,plo.Result_Flag,ltd.LedgerTransactionNo,inv.ReportType FROM f_ledgertnxdetail ltd ");
        //    sb.Append(" INNER JOIN f_itemmaster im ON ltd.itemid=im.itemid INNER JOIN  f_subcategorymaster sc ON ");
        //    sb.Append(" im.SubCategoryID=sc.SubCategoryID INNER JOIN    f_configrelation con ON con.CategoryID=sc.CategoryID  ");
        //    sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON  pli.LedgerTransactionNo = ltd.LedgerTransactionNo and pli.Investigation_ID = im.Type_ID  ");
        //    sb.Append(" INNER JOIN f_ledgertransaction lt on lt.LedgerTransactionNo = ltd.LedgerTransactionNo ");
        //    sb.Append(" INNER JOIN investigation_master inv ON im.Type_ID=inv.Investigation_Id WHERE con.ConfigRelationID=3 ");
        //    sb.Append(" AND ltd.TransactionID='" + TransactionID + "' AND lt.IsCancel=0 GROUP BY inv.Investigation_ID ORDER BY inv.Name ");
        //}


        DataTable dtgrdMap = StockReports.GetDataTable(sb.ToString());
        if (dtgrdMap.Rows.Count > 0)
        {
            btnSave.Visible = true;
            grdMap.DataSource = dtgrdMap;
            grdMap.DataBind();

            string str = "select  mdm.DiseaseId,mdm.DiseaseName FROM mrd_disease_master mdm WHERE IsActive=1 order by DiseaseName";
            DataTable dt = StockReports.GetDataTable(str);

            if (grdMap.Rows.Count > 0)
            {
                //int i = 0;
                foreach (GridViewRow rows in grdMap.Rows)
                {
                    if (dt != null && dt.Rows.Count > 0)
                        {
                        string sql = " select mdm.DiseaseId,mdm.DiseaseName  from mrd_map_investigation_disease mid inner join  mrd_disease_master mdm on mid.DiseaseId=mdm.DiseaseId WHERE  mid.TransactionID='" + TransactionID + "' AND mid.Investigation_ID='" + ((Label)rows.FindControl("lblInvestigationID")).Text + "' ";
                        // ,if(mid.DiseaseId,'')MapDiseaseId 
                        DataTable dtnew = StockReports.GetDataTable(sql);
                        if (dtnew.Rows.Count <= 0)
                        {
                            ((DropDownList)rows.FindControl("ddlDisease")).DataSource = dt;
                            ((DropDownList)rows.FindControl("ddlDisease")).DataTextField = "DiseaseName";
                            ((DropDownList)rows.FindControl("ddlDisease")).DataValueField = "DiseaseId";
                            ((DropDownList)rows.FindControl("ddlDisease")).DataBind();
                            ((DropDownList)rows.FindControl("ddlDisease")).Items.Insert(0, "SELECT");
                        }
                        else
                            {
                            ((DropDownList)rows.FindControl("ddlDisease")).DataSource = dt;
                            ((DropDownList)rows.FindControl("ddlDisease")).DataTextField = "DiseaseName";
                            ((DropDownList)rows.FindControl("ddlDisease")).DataValueField = "DiseaseId";
                            ((DropDownList)rows.FindControl("ddlDisease")).DataBind();
                            //((DropDownList)rows.FindControl("ddlDisease")).Items.Insert(0, "SELECT");
                            ((DropDownList)rows.FindControl("ddlDisease")).SelectedIndex = ((DropDownList)rows.FindControl("ddlDisease")).Items.IndexOf(((DropDownList)rows.FindControl("ddlDisease")).Items.FindByValue(Util.GetString(dtnew.Rows[0]["DiseaseId"])));
                            rows.BackColor = System.Drawing.Color.CadetBlue;
                            
                        }
                    }
                    else
                    {
                        ((DropDownList)rows.FindControl("ddlDisease")).DataSource = null;
                        ((DropDownList)rows.FindControl("ddlDisease")).DataBind();
                    }


                    //   i++;
                }
                foreach (GridViewRow row in grdMap.Rows)
                {
                    if (((Label)row.FindControl("lblrsltflg")).Text == "0")
                    {
                        ((ImageButton)row.FindControl("imbView")).Visible = false;
                    }
                    else
                    {
                        ((ImageButton)row.FindControl("imbView")).Visible = true;
                    }
                }

            }
        }
        else
        {
            btnSave.Visible = false;
            grdMap.DataSource = null;
            grdMap.DataBind();
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
       string TID= ViewState["TID"].ToString();
       MySqlConnection con = Util.GetMySqlCon();
       con.Open();
       MySqlTransaction tnx = con.BeginTransaction();
       try
       {
           string sql = "delete  from mrd_map_investigation_disease where TransactionID='" + TID + "' ";
           int update = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
           if (grdMap.Rows.Count > 0)
           {
               foreach (GridViewRow rows in grdMap.Rows)
               {
                   if (((DropDownList)rows.FindControl("ddlDisease")).SelectedItem.Text.Trim().ToString() != "SELECT")
                   {
                     //Util.GetString(((Label)rows.FindControl("lblInvestigationID")).Text)
                       string sqlMap = "insert into mrd_map_investigation_disease(TransactionID,Investigation_ID,NAME,DiseaseID,EntryDate,CentreID) values " +
                           "('" + TID + "','" + Util.GetString(((Label)rows.FindControl("lblInvestigationID")).Text) + "','" + Util.GetString(((Label)rows.FindControl("lblInvestigationname")).Text) + "','" + ((DropDownList)rows.FindControl("ddlDisease")).SelectedItem.Value.Trim().ToString() + "',NOW(),"+Session["CentreID"]+")";
                       int updateMap = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sqlMap);
                   }
               }
               tnx.Commit();
               tnx.Dispose();
               con.Close();
               con.Dispose();
           }
           if( ViewState["TransactionID"] !=null && ViewState["LabType"] !=null)
           {
               BindGrid(ViewState["TransactionID"].ToString(), ViewState["LabType"].ToString());
           }
       }
       catch (Exception ex)
       {
           tnx.Rollback();
           tnx.Dispose();
           con.Close();
           con.Dispose();
           ClassLog objClassLog = new ClassLog();
           objClassLog.errLog(ex);
          
       }
    }

    protected void btnSave1_Click(object sender, EventArgs e)
    {
      
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        string disease = "select count(*) from mrd_disease_master where DiseaseName='" + txtDisease.Text.Trim() + "' and IsActive=1 ";
        int count = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, disease));
        if (count > 0)
        {
            //Label1.Text = "Disease Already Exist";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Disease Already Exit',function(){});", true);
            return;
        }
        try
        {

            string sql = "insert into mrd_disease_master(DiseaseName,Description,IsActive,CentreID,EntryDate) values ('" + txtDisease.Text.ToString() + "','" + txtDisc.Text.ToString() + "',1," + Session["CentreID"] + ",NOW())";
            int result = MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sql);
            if (result > 0)
            {
               // lblMSG.Text = "Record saved Successfully";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Disease Save Sucessfully',function(){});", true);
               string TransactionID= ViewState["TID"].ToString();
               string labtypes = ViewState["LabType"].ToString();
               BindGrid(TransactionID, labtypes);
               txtDisease.Text = "";
               txtDisc.Text = "";
                
            }
            con.Close();
            con.Dispose();
            Label1.Text = "";

        }
        catch (Exception ex)
        {
            con.Close();
            con.Dispose();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);

        }
    }
    protected void grdMap_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "View")
        {
            string IsReport ="";
            foreach (ListItem item in rdviewrpt.Items)
            {
                item.Selected = false;
            }
            ViewState["Test_ID"] = e.CommandArgument.ToString().Split('#')[0];
            ViewState["LedgerTransactionNo"] = e.CommandArgument.ToString().Split('#')[1];
            ViewState["ReporrtType"] = e.CommandArgument.ToString().Split('#')[2];
            if (ViewState["Test_ID"] != null && ViewState["ReporrtType"] != null )
            {
                string ReportType = ViewState["ReporrtType"].ToString();


               
                    IsReport = Util.GetString(StockReports.ExecuteScalar("select Result_Flag from patient_labinvestigation_opd where  Test_ID='" + ViewState["Test_ID"].ToString() + "'"));
                    if (IsReport == "True")
                    { ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Lab/printLabReport_pdf.aspx?IsPrev=0&TestID=" + ViewState["Test_ID"].ToString() + " &LabType=" + ViewState["LabType"].ToString() + "'&,&Phead=0);", true); }
                    else
                    { ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert(' Report Not Found ',function(){});", true); }

           

                //if (ReportType == "3" || ReportType == "5")
                //    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Lab/printLabReport_pdf.aspx?IsPrev=0&TestID=" + ViewState["Test_ID"].ToString() + " &LabType=" + ViewState["LabType"].ToString() + "'&,&Phead=0);", true);
            }
            // mpe2.Show();
        }
    }
    protected void btnShow_Click(object sender, EventArgs e)
    {

    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {

    }
    protected void ViewReport(string TestID, string PID, string LabType)
    {
        
        DataTable dtObservationType;
      

        string Investigations = string.Empty;
      
        DataTable dtMethod = new DataTable();
        if (TestID != string.Empty)
        {
            StringBuilder sb = new StringBuilder();
            if (LabType == "OPD")
            {
                ////sb.Append("select pl.LabObservation_ID,pl.Test_ID,date_format(pl.Result_Date,'%d-%b-%y')AS ResultDate ,pl.Value,pl.MinValue,pl.MaxValue, pl.LabObservationName,pli.Investigation_ID,'' TransactionID");
                ////sb.Append(" ,date_format(pli.SampleDate,'%d-%b-%y %I:%i%p')SampleDate,pli.SerialNo,date_format(pli.Date,'%d-%b-%y')Date,Time_format(pli.Time,' %h:%i %p')Time,IM.ReportType,IM.Name AS TestName,");
                ////sb.Append(" pli.ID As Print_Sequence_Investigation,lm.ReadingFormat AS Unit,Priorty,concat(dm.Title,' ',dm.Name) As RefDoctor,CONCAT((Select concat(Title,' ',Name) from doctor_referal where DoctorID =pmh.ReferedBy),' ',pmh.Source)ReferDoctor,");
                ////sb.Append(" if(Approved=1,1,0)Approved,DATE_FORMAT(pli.ApprovedDate,'%d-%b-%Y %I:%i%p')ApprovedDate,ApprovedBy,DATE_FORMAT(pli.ResultEnteredDate,'%d-%b-%Y %I:%i%p')ResultEnteredDate,ResultEnteredName,pli.comments,IM.Description");
                ////sb.Append(" from patient_labobservation_opd pl inner join patient_labinvestigation_opd pli on pli.Test_ID = pl.Test_ID inner join investigation_master IM on IM.Investigation_Id = pli.Investigation_ID");
                ////sb.Append(" inner join patient_medical_history pmh on pmh.TransactionID = pli.TransactionID inner join doctor_master dm on dm.DoctorID = pmh.DoctorID inner join labobservation_master lm on lm.LabObservation_ID = pl.LabObservation_ID");
                ////sb.Append(" inner join labobservation_investigation lai on lai.Investigation_Id=pli.Investigation_Id and lai.labObservation_ID=pl.labObservation_ID where pl.Test_ID in (" + TestID + ") and pli.Result_Flag = 1");


                sb.Append(" SELECT t.*,IM.Interpretation,IM.ReportType,TRIM(TRAILING ',' FROM CONCAT( IM.Name,',',im.SampleTypeName)) AS TestName,CONCAT(dm.Title,' ',dm.Name) AS RefDoctor,IM.Print_sequence AS Print_Sequence_Investigation,im.SampleTypeName,ifnull(lai.MethodName,'')MethodName,");
                sb.Append(" (SELECT if(Name !='WALKIN',CONCAT(Title,' ',NAME),Name)Name FROM doctor_referal WHERE DoctorID =pmh.ReferedBy)ReferDoctor,");
                sb.Append(" IM.Description,lai.Priorty FROM (");
                sb.Append("     SELECT pl.Description,pl.LabObservation_ID,pl.Test_ID,DATE_FORMAT(pl.Result_Date,'%d-%b-%y')AS ResultDate ,");
                sb.Append("     pl.Value,pl.MinValue,pl.MaxValue, pl.LabObservationName,pli.Investigation_ID,pli.TransactionID ,");
                sb.Append("     DATE_FORMAT(pli.SampleDate,'%d-%b-%y %I:%i%p')SampleDate,DATE_FORMAT(pli.SampleReceiveDate,'%d-%b-%y %I:%i%p')ReceiveDate,pli.SerialNo,DATE_FORMAT(pli.Date,'%d-%b-%y')DATE,");
                sb.Append("     TIME_FORMAT(pli.Time,' %h:%i %p')TIME,");
                sb.Append("     IF(pli.Approved=1,1,0)Approved,pli.comments,");
                sb.Append("     DATE_FORMAT(pli.ApprovedDate,'%d-%b-%Y %I:%i%p')ApprovedDate,pli.ApprovedBy,");
                sb.Append("     DATE_FORMAT(pli.ResultEnteredDate,'%d-%b-%Y %I:%i%p')ResultEnteredDate,pli.ResultEnteredName,");
                sb.Append("     IFNULL(pl.ReadingFormat,lm.ReadingFormat)Unit,lm.ParentID,lm.Child_Flag,'N' IsParent,pl.Priorty labPriorty,pli.LedgerTransactionNo,lm.ToBePrinted ");
                sb.Append("     FROM patient_labobservation_opd pl ");
                sb.Append("     INNER JOIN patient_labinvestigation_opd pli ON pli.Test_ID = pl.Test_ID ");
                sb.Append("     INNER JOIN labobservation_master lm ON lm.LabObservation_ID = pl.LabObservation_ID	");
                sb.Append("     WHERE pl.Test_ID IN ('" + TestID + "') AND pli.Result_Flag = 1  and lm.ToBePrinted=1 ");
                sb.Append(" )t INNER JOIN patient_medical_history pmh ON pmh.TransactionID = t.TransactionID ");
                sb.Append(" INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID ");
                sb.Append(" INNER JOIN investigation_master IM ON IM.Investigation_Id = t.Investigation_ID ");
                sb.Append(" LEFT JOIN labobservation_investigation lai ON lai.Investigation_Id=t.Investigation_Id ");
                sb.Append(" AND lai.labObservation_ID=t.labObservation_ID order by IM.Print_sequence,IM.Name,Priorty,lai.printOrder");

            }
            else if (LabType == "IPD")
            {
                //sb.Append("select pl.LabObservation_ID,pl.Test_ID,date_format(pl.Result_Date,'%d-%b-%y')AS ResultDate ,pl.Value,pl.MinValue,pl.MaxValue, pl.LabObservationName,pli.Investigation_ID,");
                //sb.Append(" pli.TransactionID ,date_format(pli.SampleDate,'%d-%b-%y %I:%i%p')SampleDate,pli.SerialNo,date_format(pli.Date,'%d-%b-%y')Date,Time_format(pli.Time,' %h:%i %p')Time,IM.ReportType,IM.Name AS TestName,pli.ID As Print_Sequence_Investigation,");
                //sb.Append(" lm.ReadingFormat AS Unit,lai.Priorty,concat(dm.Title,' ',dm.Name)As RefDoctor,CONCAT((Select concat(Title,' ',Name) from doctor_referal where DoctorID =pmh.ReferedBy),' ',pmh.Source)ReferDoctor,if(Approved=1,1,0)Approved,DATE_FORMAT(pli.ApprovedDate,'%d-%b-%Y %I:%i%p')ApprovedDate,pli.ApprovedBy,DATE_FORMAT(pli.ResultEnteredDate,'%d-%b-%Y %I:%i%p')ResultEnteredDate,pli.ResultEnteredName,pli.comments,IM.Description from patient_labobservation_ipd pl inner join patient_labinvestigation_ipd ");
                //sb.Append(" pli  on pli.Test_ID = pl.Test_ID inner join investigation_master IM on IM.Investigation_Id = pli.Investigation_ID inner join patient_medical_history pmh on pmh.TransactionID = pli.TransactionID");
                //sb.Append(" inner join doctor_master dm on dm.DoctorID = pmh.DoctorID inner join labobservation_master lm on lm.LabObservation_ID  = pl.LabObservation_ID inner join labobservation_investigation lai on ");
                //sb.Append(" lai.Investigation_Id=pli.Investigation_Id and lai.labObservation_ID=pl.labObservation_ID where pl.Test_ID in (" + TestID + ") and pli.Result_Flag = 1");

                sb.Append(" SELECT t.*,IM.Interpretation,IM.ReportType,TRIM(TRAILING ',' FROM CONCAT( IM.Name,',',im.SampleTypeName)) AS TestName,CONCAT(dm.Title,' ',dm.Name) AS RefDoctor,IM.Print_sequence AS Print_Sequence_Investigation,im.SampleTypeName,ifnull(lai.MethodName,'')MethodName,");
                sb.Append(" (SELECT if(Name !='WALKIN',CONCAT(Title,' ',NAME),Name)Name FROM doctor_referal WHERE DoctorID =pmh.ReferedBy)ReferDoctor,");
                sb.Append(" IM.Description,lai.Priorty FROM (");
                sb.Append("     SELECT pl.Description, pl.LabObservation_ID,pl.Test_ID,DATE_FORMAT(pl.Result_Date,'%d-%b-%y')AS ResultDate ,");
                sb.Append("     pl.Value,pl.MinValue,pl.MaxValue, pl.LabObservationName,pli.Investigation_ID,pli.TransactionID ,");
                sb.Append("     DATE_FORMAT(pli.SampleDate,'%d-%b-%y %I:%i%p')SampleDate, DATE_FORMAT(pli.SampleReceiveDate,'%d-%b-%y %I:%i%p')ReceiveDate,pli.SerialNo,DATE_FORMAT(pli.Date,'%d-%b-%y')DATE,");
                sb.Append("     TIME_FORMAT(pli.Time,' %h:%i %p')TIME,");
                sb.Append("     IF(pli.Approved=1,1,0)Approved,pli.comments,");
                sb.Append("     DATE_FORMAT(pli.ApprovedDate,'%d-%b-%Y %I:%i%p')ApprovedDate,pli.ApprovedBy,");
                sb.Append("     DATE_FORMAT(pli.ResultEnteredDate,'%d-%b-%Y %I:%i%p')ResultEnteredDate,pli.ResultEnteredName,");
                sb.Append("     IFNULL(pl.DisplayReading,lm.ReadingFormat)Unit,lm.ParentID,lm.Child_Flag,'N' IsParent,pl.Priorty labPriorty,pli.LedgerTransactionNo ");
                sb.Append("     FROM patient_labobservation_ipd pl ");
                sb.Append("     INNER JOIN patient_labinvestigation_ipd pli ON pli.Test_ID = pl.Test_ID ");
                sb.Append("     INNER JOIN labobservation_master lm ON lm.LabObservation_ID = pl.LabObservation_ID	");
                sb.Append("     WHERE pl.Test_ID IN ('" + TestID + "') AND pli.Result_Flag = 1 and lm.ToBePrinted=1 ");
                sb.Append(" )t INNER JOIN patient_medical_history pmh ON pmh.TransactionID = t.TransactionID ");
                sb.Append(" INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID ");
                sb.Append(" INNER JOIN investigation_master IM ON IM.Investigation_Id = t.Investigation_ID ");
                sb.Append(" LEFT JOIN labobservation_investigation lai ON lai.Investigation_Id=t.Investigation_Id ");
                sb.Append(" AND lai.labObservation_ID=t.labObservation_ID order by IM.Print_sequence,IM.Name,Priorty,lai.printOrder");
            }
            DataTable dtLabOb = new DataTable();
            dtLabOb = StockReports.GetDataTable(sb.ToString());

                for (int i = 0; i < dtLabOb.Rows.Count; i++)
                {
                    if (dtLabOb.Rows[i]["Investigation_ID"].ToString().Length > 2)
                        Investigations = Investigations + "'" + dtLabOb.Rows[i]["Investigation_ID"].ToString() + "',";



                    if (dtLabOb.Rows[i]["ParentID"].ToString() != "")
                    {
                        DataRow[] PrExist = dtLabOb.Select("LabObservation_ID='" + dtLabOb.Rows[i]["ParentID"].ToString() + "'");


                        if (PrExist.Length <= 0)
                        {
                            DataRow row = dtLabOb.NewRow();
                            row.ItemArray = dtLabOb.Rows[i].ItemArray;

                            DataTable dtlb = StockReports.GetDataTable("SELECT lm.*,li.Priorty FROM labobservation_master lm INNER JOIN labobservation_investigation li ON lm.LabObservation_ID = li.labObservation_ID WHERE li.labObservation_ID='" + dtLabOb.Rows[i]["ParentID"].ToString() + "' limit 1");
                            row["LabObservation_ID"] = dtlb.Rows[0]["LabObservation_ID"].ToString();
                            row["LabObservationName"] = dtlb.Rows[0]["NAME"].ToString();
                            row["Child_Flag"] = dtlb.Rows[0]["Child_Flag"].ToString();
                            row["ParentID"] = dtlb.Rows[0]["ParentID"].ToString();
                            row["Priorty"] = dtlb.Rows[0]["Priorty"].ToString();

                            row["IsParent"] = "Y";
                            row["Investigation_ID"] = dtLabOb.Rows[i]["Investigation_ID"].ToString();
                            row["Test_ID"] = dtLabOb.Rows[i]["Test_ID"].ToString();
                            row["TransactionID"] = dtLabOb.Rows[i]["TransactionID"].ToString();

                            DataRow[] PrChild = dtLabOb.Select("ParentID='" + dtLabOb.Rows[i]["ParentID"].ToString() + "'");
                            if (PrChild.Length > 0)
                            {
                                foreach (DataRow dr1 in PrChild)
                                {
                                    dr1["Priorty"] = dtlb.Rows[0]["Priorty"].ToString();
                                }
                            }

                            dtLabOb.Rows.InsertAt(row, i);
                            dtLabOb.AcceptChanges();

                        }
                    }
                }


                if (Investigations.Length > 2)
                    Investigations = Investigations.Substring(0, Investigations.Length - 1);
                if (Investigations == string.Empty)
                    Investigations = " ";
                if (Investigations==" " )
                {
                    string getObservationType = "select Name,otm.ObservationType_ID,Investigation_ID,Print_Sequence Print_Sequence_ObservationType from observationtype_master otm inner join investigation_observationtype iot on iot.ObservationType_Id=otm.ObservationType_Id where iot.Investigation_ID in ('" + Investigations + "')";
                    dtObservationType = StockReports.GetDataTable(getObservationType);
                }
                else
                {
                    string getObservationType = "select Name,otm.ObservationType_ID,Investigation_ID,Print_Sequence Print_Sequence_ObservationType from observationtype_master otm inner join investigation_observationtype iot on iot.ObservationType_Id=otm.ObservationType_Id where iot.Investigation_ID in (" + Investigations + ")";
                     dtObservationType = StockReports.GetDataTable(getObservationType);
                }


                string sb1 = "select PatientID,concat(Title,' ',PName)AS PatientName,concat(House_No,' ',Street_Name,' ',Locality,' ',City) AS Address, Age,Gender from patient_master where PatientID = '" + PID + "'";

                DataTable dtPatientInfo = new DataTable();
                dtPatientInfo = StockReports.GetDataTable(sb1).Copy();
                dtPatientInfo.Columns.Add("LedgerTransactionNo");
                if(dtLabOb.Rows.Count>0)
                dtPatientInfo.Rows[0]["LedgerTransactionNo"] = dtLabOb.Rows[0]["LedgerTransactionNo"];
                if (dtPatientInfo.Columns.Contains("BedNo") == false) dtPatientInfo.Columns.Add("BedNo");
                if (Investigations==" ")
                {
                    string strGetMethod = "  SELECT GROUP_CONCAT(str SEPARATOR '<BR>') as  Method " +
                                     "FROM( SELECT  IF(str='-','',CONCAT(t1.Name,str))str FROM (SELECT im.Name, " +
                                     " CONCAT(TRIM(TRAILING ',' FROM IFNULL(CONCAT(',',im.SampleTypeName),'')),'-', TRIM( BOTH  '/' FROM REPLACE(GROUP_CONCAT(DISTINCT (li.MethodName)SEPARATOR '/'),'//','/')))str FROM investigation_master im " +
                                   " INNER JOIN  labobservation_investigation li ON li.Investigation_Id=im.Investigation_Id and im.Investigation_Id in('" + Investigations + "') " +
                                   " GROUP BY im.Investigation_Id   ORDER BY Print_Sequence,NAME )t1)T GROUP BY 'all'";
                     dtMethod = StockReports.GetDataTable(strGetMethod);
                }
                else
                {
                    string strGetMethod = "  SELECT GROUP_CONCAT(str SEPARATOR '<BR>') as  Method " +
                                     "FROM( SELECT  IF(str='-','',CONCAT(t1.Name,str))str FROM (SELECT im.Name, " +
                                     " CONCAT(TRIM(TRAILING ',' FROM IFNULL(CONCAT(',',im.SampleTypeName),'')),'-', TRIM( BOTH  '/' FROM REPLACE(GROUP_CONCAT(DISTINCT (li.MethodName)SEPARATOR '/'),'//','/')))str FROM investigation_master im " +
                                   " INNER JOIN  labobservation_investigation li ON li.Investigation_Id=im.Investigation_Id and im.Investigation_Id in(" + Investigations + ") " +
                                   " GROUP BY im.Investigation_Id   ORDER BY Print_Sequence,NAME )t1)T GROUP BY 'all'";
                     dtMethod = StockReports.GetDataTable(strGetMethod);
                }



                AllQuery AQ = new AllQuery();
                DataTable dtBedNo = AQ.GetPatientBedNoByTID(TransactionID);

                if (dtBedNo != null && dtBedNo.Rows.Count > 0)
                    dtPatientInfo.Rows[0]["BedNo"] = dtBedNo.Rows[0]["Name"].ToString();


                dtPatientInfo.TableName = "ObservationType";
                DataSet ds = new DataSet();

                dtLabOb.AcceptChanges();


                ds.Tables.Add(dtLabOb.Copy());
                ds.Tables[0].TableName = "LabObservations";


                PatientProfile objPatientProfile = new PatientProfile();

                DataColumn dc = new DataColumn();
                dc.ColumnName = "BalanceAmount";
                dc.DefaultValue = objPatientProfile.showBalanceAmount(dtPatientInfo.Rows[0]["PatientID"].ToString());
                dtPatientInfo.Columns.Add(dc);

                ds.Tables.Add(dtPatientInfo.Copy());
                ds.Tables[1].TableName = "PatientInfo";

                DataColumn dcMethod = new DataColumn("Method");
                if(dtMethod.Rows.Count>0)
                dcMethod.DefaultValue = dtMethod.Rows[0]["Method"].ToString();
                ds.Tables[1].Columns.Add(dcMethod);

                ds.Tables.Add(dtObservationType.Copy());

                ds.Tables[2].TableName = "ObservationType";



                int IsRoomPrint = 0;


                dc = new DataColumn("IsRoomPrint", typeof(int));
                dc.DefaultValue = IsRoomPrint;
                ds.Tables[1].Columns.Add(dc);



               // ds.WriteXmlSchema(@"C:\PathLabReport.xml");
                Session["ObservationData"] = ds;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Reports/Forms/LabObservationReport.aspx');", true);

        }
        
    }
    //protected void ViewTextReport(string TestID, string PID, string LabType)
    //{
    //    //DataTable dtSearch = LabOPD.getLabToPrint(ViewState["LedgerTransactionNo"].ToString(), LabType, "");
    //    //DataSet ds = new DataSet();


    //    //dtSearch.TableName = "InvestigationToPrint";
    //    //ds = LabOPD.getDataSetForReport(TestID, PID, dtSearch, LabType, "");
    //    //Session["ds"] = ds;
    //    //Session["EndOfReport"] = "0";


    //    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Lab/printLabReport.aspx?TestID=" + TestID + " &LabType=" + LabType + "');", true);
       
    //}

    private DataTable getLabToPrintNew(string LedgerTransactionNo, string LabType, string TransactionID, string ReportType)
    {
        string str = "";
        str += "SELECT TIME_FORMAT(TIME,'%h:%i:%p') AS TIME,DATE_FORMAT(DATE,'%d-%b-%y') AS DATE,SampleDate,";
        str += "plo.Investigation_ID AS InvestigationID,plo.TransactionID,plo.Test_ID,plo.ID,";

        if (LabType.ToUpper() == "OPD")
            str += "ifnull((Select LabInves_Description from patient_labinvestigation_opd_text where PLO_ID=plo.ID ORDER BY PLO_ID DESC LIMIT 1),'')LabInves_Description,";
        else
            str += "ifnull((Select LabInves_Description from patient_labinvestigation_ipd_text where PLI_ID=plo.ID ORDER BY PLI_ID DESC LIMIT 1),'')LabInves_Description,";

        if (LabType.ToUpper() == "OPD")
            str += "plo.LabInvestigationOPD_ID LabInvestigationIPD_ID,";
        else
            str += "plo.LabInvestigationIPD_ID ,";

        str += "IF(plo.Approved=1,'APPROVED','NOT-APPROVED')Approved,IF(plo.Approved=1,'true','false')Print,";
        str += "IM.Investigation_ID,im.Name,im.ReportType,im.FileLimitationName,";
        str += "OM.Name Department,om.Print_Sequence,ifnull(emi.Remarks,'')Findings,IF(im.ReportType in (3,5),'true','false')IsFindings ";

        if (LabType.ToUpper() == "OPD")
            str += "FROM patient_labinvestigation_opd plo ";
        else
            str += "FROM patient_labinvestigation_ipd plo ";

        str += "INNER JOIN investigation_master im ON im.Investigation_ID=plo.Investigation_Id ";
        str += "INNER JOIN investigation_observationtype IO ON IM.Investigation_Id = IO.Investigation_ID ";
        str += "INNER JOIN observationtype_master OM ON OM.ObservationType_ID = IO.ObservationType_Id ";

        if (LabType.ToUpper() == "OPD")
            str += "LEFT JOIN emr_patient_investigation_opd emi ON (emi.TransactionID=plo.TransactionID and emi.Investigation_ID=plo.Investigation_ID  and emi.Test_ID=plo.Test_ID ) ";
        else
            str += "LEFT JOIN emr_patient_investigation emi ON (emi.TransactionID=plo.TransactionID and emi.Investigation_ID=plo.Investigation_ID  and emi.Test_ID=plo.Test_ID ) ";

        str += "WHERE result_flag=1 ";

        if (LedgerTransactionNo != "")
            str += " AND plo.LedgerTransactionNo='" + LedgerTransactionNo + "' ";
        if (ReportType != "")
            str += " AND im.ReportType =" + ReportType + "";
        if (TransactionID != null )
        {
            str += " AND plo.TransactionID ='" + TransactionID + "'";
        }

        DataTable dt = new DataTable("InvestigationToPrint");
        dt = StockReports.GetDataTable(str);
        return dt;

    }

   
    protected void rdviewrpt_SelectedIndexChanged2(object sender, EventArgs e)
    {
        if (rdviewrpt.SelectedValue == "0")
        {
            //if (ViewState["Test_ID"] != null && ViewState["PID"] != null && ViewState["ReporrtType"] != null && ViewState["LedgerTransactionNo"] != null)
            //{
            //    string ReportType = ViewState["ReporrtType"].ToString();
               
              
            //    if (ReportType == "1")
            //        ViewReport(ViewState["Test_ID"].ToString(), ViewState["PID"].ToString(), ViewState["LabType"].ToString());
                    
            //    if (ReportType == "3" || ReportType == "5")
            //        ViewTextReport("'" + ViewState["Test_ID"].ToString() + "'", ViewState["PID"].ToString(), ViewState["LabType"].ToString());                
            //}
        }
        else if (rdviewrpt.SelectedValue == "1")
        { 
            
        }
    }
    protected void grdMap_RowDataBound(object sender, GridViewRowEventArgs e)
    {
       
       
    }
    protected void grdMap_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
}
