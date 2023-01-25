using System;
using System.Data;
using System.IO;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_MRD_NotifiableDiseaseReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
        {
        if (!Page.IsPostBack)
        {
            ucDateFrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucDateTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        }
        ucDateFrom.Attributes.Add("readonly", "readonly");
        ucDateTo.Attributes.Add("readonly", "readonly");
    }
   
    protected void btnissue_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("  SELECT  mdm.DiseaseName,COUNT(*)Qty,YEAR(mmid.EntryDate)YrOfDis,DATE_FORMAT(mmid.EntryDate,'%b')MthOfDis,mmid.DiseaseID  ");
        sb.Append("  FROM mrd_map_investigation_disease mmid  ");
        sb.Append("  INNER JOIN mrd_disease_master mdm ON mmid.DiseaseID=mdm.DiseaseId ");
        sb.Append("  INNER JOIN patient_medical_history ich ON mmid.TransactionID=ich.TransactionID  ");
        sb.Append("  WHERE  DATE(mmid.EntryDate)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND  DATE(mmid.EntryDate)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' and  ich.CentreID="+Session["CentreID"]+"");
        sb.Append("  GROUP BY mmid.DiseaseID "); //DATE(ich.DateOfDischarge),

        DataTable dtNotifiable = StockReports.GetDataTable(sb.ToString());
        dtNotifiable.TableName = "dtNotifiable";

        if (dtNotifiable != null && dtNotifiable.Rows.Count > 0)
        {
          
            DataRow TotalRow = dtNotifiable.NewRow();
            TotalRow[0] = "Total";
            TotalRow["Qty"] = dtNotifiable.Compute("sum(Qty)", "");
            dtNotifiable.Rows.Add(TotalRow);
           
            lbldetail.Text = "Notifiable Diseases";
            grddetail.DataSource = dtNotifiable;
            grddetail.DataBind();                
        }
        else
        {
            lbldetail.Text = "";

            grddetail.DataSource = null;
            grddetail.DataBind();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert(' No Record Found ',function(){});", true);
            
        }

    }

    protected void btnexcel_Click(object sender, EventArgs e)
    {  
        StringBuilder sb = new StringBuilder();

        sb.Append("  SELECT  mdm.DiseaseName 'Disease Name',COUNT(*)Quantity,YEAR(mmid.EntryDate)'Year',DATE_FORMAT(mmid.EntryDate,'%b') 'Month',mmid.DiseaseID ");
        sb.Append("  FROM mrd_map_investigation_disease mmid  ");
        sb.Append("  INNER JOIN mrd_disease_master mdm ON mmid.DiseaseID=mdm.DiseaseId ");
        sb.Append("  INNER JOIN patient_medical_history ich ON mmid.TransactionID=ich.TransactionID  ");
        sb.Append("  WHERE  DATE(mmid.EntryDate)>='" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "' AND  DATE(mmid.EntryDate)<='" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' ");
        sb.Append("  and ich.CentreID="+Session["CentreID"]+" GROUP BY mmid.DiseaseID ");//DATE(mmid.EntryDate),MONTH(mmid.EntryDate),

        DataTable dtNotifiable = StockReports.GetDataTable(sb.ToString());
        dtNotifiable.TableName = "dtNotifiable";

        if (dtNotifiable != null && dtNotifiable.Rows.Count > 0)
        {
            DataRow TotalRow = dtNotifiable.NewRow();
            TotalRow[0] = "Total";
            TotalRow["Quantity"] = dtNotifiable.Compute("sum(Quantity)", "");
            dtNotifiable.Rows.Add(TotalRow);
            Session["dtExport2Excel"] = dtNotifiable;
            Session["ReportName"] = "Notifiable Diseases";
            Session["Period"] = "From" + ucDateFrom.Text + " To " + ucDateTo.Text;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
        }
        else
        {

           // lblMsg.Visible = true;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert(' No Record Found ',function(){});", true);
        }
        
    }

    protected void grddetail_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "View")
        {
            ViewState["DiseaseID"] = e.CommandArgument.ToString().Split('#')[0];
            ViewState["YrOfDis"] = e.CommandArgument.ToString().Split('#')[1];
            ViewState["MthOfDis"] = e.CommandArgument.ToString().Split('#')[2];
            LoadInvDetail(ViewState["DiseaseID"].ToString(), ViewState["YrOfDis"].ToString(), ViewState["MthOfDis"].ToString());
            //mpe2.Show();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "$('#divInvestigationDetail').showModel();", true);
        }
    }

    private void LoadInvDetail(string DiseaseID, string YrOfDis, string MthOfDis)
    {
        string str = "SELECT im.Name ,pli.Investigation_ID,Date_Format(pli.Date,'%d-%b-%Y')Date,mid.DiseaseID,pli.TransactionID," +
        "pli.Test_ID,pli.LedgerTransactionNo,'OPD' LabType,im.ReportType,pli.Result_Flag FROM mrd_map_investigation_disease MID " +
        "INNER JOIN  patient_labinvestigation_opd pli ON pli.TransactionID = mid.TransactionID " +
        "INNER JOIN investigation_master im ON im.Investigation_Id = pli.Investigation_ID " +
        "WHERE pli.Investigation_ID = mid.Investigation_ID  AND mid.DiseaseID='" + DiseaseID + "' AND  YEAR(DATE)='"+YrOfDis+"' " +
        "AND DATE_FORMAT(pli.Date,'%b')='" + MthOfDis + "'  AND PLI.centreID="+Session["CentreID"]+"";

        DataTable dt = StockReports.GetDataTable(str);

        if (dt != null && dt.Rows.Count > 0)
        {
            grdDiseaseDetail.DataSource = dt;
            grdDiseaseDetail.DataBind();
        }
        else
        {

            grdDiseaseDetail.DataSource = null;
            grdDiseaseDetail.DataBind();
        }

    }


    protected void grdDiseaseDetail_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string IsReport = "";
        if (e.CommandName == "ViewRpt")
        {
            ViewState["Test_ID"] = e.CommandArgument.ToString().Split('#')[0];
            ViewState["LedgerTransactionNo"] = e.CommandArgument.ToString().Split('#')[1];
            ViewState["ReportType"] = e.CommandArgument.ToString().Split('#')[2];
            ViewState["Result_Flag"] = e.CommandArgument.ToString().Split('#')[3];
            ViewState["TransactionID"] = e.CommandArgument.ToString().Split('#')[4];
            ViewState["LabType"] = e.CommandArgument.ToString().Split('#')[5];
            
            ViewState["PID"] = StockReports.ExecuteScalar("Select PatientID from f_ledgerTransaction where LedgertransactionNo='" + ViewState["LedgerTransactionNo"].ToString() + "' limit 1");

            //if (ViewState["ReportType"].ToString() == "1")
            //    ViewReport(ViewState["Test_ID"].ToString(), ViewState["PID"].ToString(), ViewState["LabType"].ToString());
            IsReport = Util.GetString(StockReports.ExecuteScalar("select Result_Flag from patient_labinvestigation_opd where  Test_ID='" + ViewState["Test_ID"].ToString() + "'"));
            if (IsReport == "True")
            { ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Lab/printLabReport_pdf.aspx?IsPrev=0&TestID=" + ViewState["Test_ID"].ToString() + " &LabType=" + ViewState["LabType"].ToString() + " &LabreportType=" + Util.GetString(Session["roleid"]) + " &isConversion=1');", true); }
            else
            { ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert(' Report Not Found ',function(){});", true); }

            //if (ViewState["ReportType"].ToString() == "3" || ViewState["ReportType"].ToString() == "5")
            //    ViewTextReport("'" + ViewState["Test_ID"].ToString() + "'", ViewState["PID"].ToString(), ViewState["LabType"].ToString());  
        }

        if (e.CommandName == "ViewPt")
        {
            ViewState["TransactionID"] = e.CommandArgument.ToString().Split('#')[0];
            ViewPatientData(ViewState["TransactionID"].ToString());
        }

       // mpe2.Show();
    }
    private void ViewPatientData(string TransactionID)
    {
        string str = "SELECT CONCAT(pm.title,' ',pm.PName)'Patient Name', " +
        "REPLACE(pm.PatientID,'LSHHI','')'UHID', " +
        "pm.Age,pm.Gender, " +
        "IF(pmh.TransactionID LIKE 'ishhi%',REPLACE(pmh.TransactionID,'ISHHI',''),'')'IPD No.', " +
        "(SELECT CONCAT(Title,' ',NAME) FROM doctor_master WHERE DoctorID=pmh.DoctorID)Doctor , " +
        "(SELECT company_name FROM f_panel_master WHERE PanelID=pmh.PanelID)Panel " +
        "FROM patient_medical_history pmh INNER JOIN patient_master pm ON pmh.PatientID = pm.PatientID " +
        "WHERE pmh.TransactionID ='" + TransactionID + "'";

        DataTable dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {
            Session["dtExport2Excel"] = dt;
            Session["ReportName"] = "Patient Detail";
            Session["Period"] = "";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);                
        }
      

    }

    protected void ViewReport(string TestID, string PID, string LabType)
    {

        DataTable dtObservationType;


        string Investigations = string.Empty;

        DataTable dtMethod = new DataTable();
        if (TestID != string.Empty)
        {
            StringBuilder sb = new StringBuilder();
            //if (LabType == "OPD")
            //{
               
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
                sb.Append("     lm.ReadingFormat Unit,lm.ParentID,lm.Child_Flag,'N' IsParent,pl.Priorty labPriorty,lm.ToBePrinted,pli.LedgerTransactionNo ");
                sb.Append("     FROM patient_labobservation_opd pl ");
                sb.Append("     INNER JOIN patient_labinvestigation_opd pli ON pli.Test_ID = pl.Test_ID ");
                sb.Append("     INNER JOIN labobservation_master lm ON lm.LabObservation_ID = pl.LabObservation_ID	");
                sb.Append("     WHERE pl.Test_ID IN ('" + TestID + "') AND pli.Result_Flag = 1  and lm.ToBePrinted=1 ");
                sb.Append(" )t INNER JOIN patient_medical_history pmh ON pmh.TransactionID = t.TransactionID ");
                sb.Append(" INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID ");
                sb.Append(" INNER JOIN investigation_master IM ON IM.Investigation_Id = t.Investigation_ID ");
                sb.Append(" LEFT JOIN labobservation_investigation lai ON lai.Investigation_Id=t.Investigation_Id ");
                sb.Append(" AND lai.labObservation_ID=t.labObservation_ID order by IM.Print_sequence,IM.Name,Priorty,lai.printOrder");

           // }
            //else if (LabType == "IPD")
            //{
               
            //    sb.Append(" SELECT t.*,IM.Interpretation,IM.ReportType,TRIM(TRAILING ',' FROM CONCAT( IM.Name,',',im.SampleTypeName)) AS TestName,CONCAT(dm.Title,' ',dm.Name) AS RefDoctor,IM.Print_sequence AS Print_Sequence_Investigation,im.SampleTypeName,ifnull(lai.MethodName,'')MethodName,");
            //    sb.Append(" (SELECT if(Name !='WALKIN',CONCAT(Title,' ',NAME),Name)Name FROM doctor_referal WHERE DoctorID =pmh.ReferedBy)ReferDoctor,");
            //    sb.Append(" IM.Description,lai.Priorty FROM (");
            //    sb.Append("     SELECT pl.Description, pl.LabObservation_ID,pl.Test_ID,DATE_FORMAT(pl.Result_Date,'%d-%b-%y')AS ResultDate ,");
            //    sb.Append("     pl.Value,pl.MinValue,pl.MaxValue, pl.LabObservationName,pli.Investigation_ID,pli.TransactionID ,");
            //    sb.Append("     DATE_FORMAT(pli.SampleDate,'%d-%b-%y %I:%i%p')SampleDate, DATE_FORMAT(pli.SampleReceiveDate,'%d-%b-%y %I:%i%p')ReceiveDate,pli.SerialNo,DATE_FORMAT(pli.Date,'%d-%b-%y')DATE,");
            //    sb.Append("     TIME_FORMAT(pli.Time,' %h:%i %p')TIME,");
            //    sb.Append("     IF(pli.Approved=1,1,0)Approved,pli.comments,");
            //    sb.Append("     DATE_FORMAT(pli.ApprovedDate,'%d-%b-%Y %I:%i%p')ApprovedDate,pli.ApprovedBy,");
            //    sb.Append("     DATE_FORMAT(pli.ResultEnteredDate,'%d-%b-%Y %I:%i%p')ResultEnteredDate,pli.ResultEnteredName,");
            //    sb.Append("     lm.ReadingFormat Unit,lm.ParentID,lm.Child_Flag,'N' IsParent,pl.Priorty labPriorty,lm.ToBePrinted,pli.LedgerTransactionNo ");
            //    sb.Append("     FROM patient_labobservation_ipd pl ");
            //    sb.Append("     INNER JOIN patient_labinvestigation_ipd pli ON pli.Test_ID = pl.Test_ID ");
            //    sb.Append("     INNER JOIN labobservation_master lm ON lm.LabObservation_ID = pl.LabObservation_ID	");
            //    sb.Append("     WHERE pl.Test_ID IN ('" + TestID + "') AND pli.Result_Flag = 1 and lm.ToBePrinted=1 ");
            //    sb.Append(" )t INNER JOIN patient_medical_history pmh ON pmh.TransactionID = t.TransactionID ");
            //    sb.Append(" INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID ");
            //    sb.Append(" INNER JOIN investigation_master IM ON IM.Investigation_Id = t.Investigation_ID ");
            //    sb.Append(" LEFT JOIN labobservation_investigation lai ON lai.Investigation_Id=t.Investigation_Id ");
            //    sb.Append(" AND lai.labObservation_ID=t.labObservation_ID order by IM.Print_sequence,IM.Name,Priorty,lai.printOrder");
            //}
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
            if (Investigations == " ")
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
            if (dtLabOb.Rows.Count > 0)
                dtPatientInfo.Rows[0]["LedgerTransactionNo"] = dtLabOb.Rows[0]["LedgerTransactionNo"];
            if (dtPatientInfo.Columns.Contains("BedNo") == false) dtPatientInfo.Columns.Add("BedNo");
            if (Investigations == " ")
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
            DataTable dtBedNo = AQ.GetPatientBedNoByTID(ViewState["TransactionID"].ToString());

            if (dtBedNo != null && dtBedNo.Rows.Count > 0)
                dtPatientInfo.Rows[0]["BedNo"] = dtBedNo.Rows[0]["Name"].ToString();


            dtPatientInfo.TableName = "ObservationType";
            DataSet ds = new DataSet();

            dtLabOb.Columns.Add("image", System.Type.GetType("System.Byte[]"));
            dtLabOb.Columns.Add("isSign");
            dtLabOb.AcceptChanges();
            if (dtLabOb.Rows.Count > 0)
            {
                DataRow[] dr = dtLabOb.Select("Approved=1");
                if (dr.Length > 0)
                {
                    string path = Server.MapPath("~/Design/OPD/Signature/" + dr[0]["ApprovedBy"].ToString() + ".jpg");
                    if (File.Exists(path))
                    {
                        FileStream fs = new FileStream(path, FileMode.Open, System.IO.FileAccess.Read);
                        byte[] imgbyte = new byte[fs.Length + 1];
                        fs.Read(imgbyte, 0, (int)fs.Length);
                        fs.Close();
                        for (int i = 0; i < dtLabOb.Rows.Count; i++)
                        {
                            dtLabOb.Rows[i]["image"] = imgbyte;
                            dtLabOb.Rows[i]["isSign"] = "1";
                        }
                        dtLabOb.AcceptChanges();
                    }
                }
            }

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
            if (dtMethod.Rows.Count > 0)
                dcMethod.DefaultValue = dtMethod.Rows[0]["Method"].ToString();
            ds.Tables[1].Columns.Add(dcMethod);

            ds.Tables.Add(dtObservationType.Copy());

            ds.Tables[2].TableName = "ObservationType";

            int IsRoomPrint = 0;

            dc = new DataColumn("IsRoomPrint", typeof(int));
            dc.DefaultValue = IsRoomPrint;
            ds.Tables[1].Columns.Add(dc);

            dc = new DataColumn("EndOfReport");
            dc.DefaultValue = "1";
            ds.Tables[1].Columns.Add(dc);

            //ds.WriteXmlSchema(@"C:\PathLabReport.xml");
            Session["ObservationData"] = ds;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Reports/Forms/LabObservationReport.aspx');", true);
            }
        }

    protected void ViewTextReport(string TestID, string PID, string LabType)
    {
        DataTable dtSearch = LabOPD.getLabToPrint(ViewState["LedgerTransactionNo"].ToString(), LabType, "");
        DataSet ds = new DataSet();

        dtSearch.TableName = "InvestigationToPrint";
        ds = LabOPD.getDataSetForReport(TestID, PID, dtSearch, LabType, "");
        Session["ds"] = ds;
        Session["EndOfReport"] = "0";

        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Finanace/ShowOPDLabReports.aspx');", true);
        }

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
        if (TransactionID != null)
        {
            str += " AND plo.TransactionID ='" + TransactionID + "'";
        }

        DataTable dt = new DataTable("InvestigationToPrint");
        dt = StockReports.GetDataTable(str);
        return dt;
        }
    }