using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;
public partial class Design_MIS_BedOccupancyReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //EntryDate1.SetCurrentDate();
            txtFromDate.Text=DateTime.Now.Date.ToString("dd-MMM-yyyy");
            //EntryDate2.SetCurrentDate();
            txtToDate.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");   
            txtTime.Text = "15:00:00";
            Session["LoginName"] = Session["LoginName"].ToString();
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
         StringBuilder sql = new StringBuilder();


        if (rbtType.SelectedValue == "1")
        {
            sql.Append("select ictm.Name, count(*) 'COUNT',DT,monthname(dt)  from ");
            sql.Append("( ");
            sql.Append("select * from patient_ipd_profile pip inner join  ");
            sql.Append("(select * from temp_for_date where dt>='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' and dt<= '" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "') tfd ");
            sql.Append("where CONCAT(pip.StartDate,' ',pip.StartTime )  <= COnCAT(tfd.dt,' ','" + txtTime.Text.Trim() + "') and  ");
            sql.Append("IF(STATUS='IN',CONCAt(CURDATE(),' ','" + txtTime.Text.Trim() + "'), CONCAT(PIP.EndDate,' ',pip.EndTime)) >= concat(tfd.dt,' ','" + txtTime.Text.Trim() + "')  ");
            sql.Append(") a ");
            sql.Append("inner join ipd_case_type_master ictm on a.IPDCaseTypeID = ictm.IPDCaseTypeID ");
            sql.Append("inner join room_master rm on a.RoomId = rm.RoomId  ");
            sql.Append("group by (a.dt),ictm.IPDCaseTypeID  ");
            sql.Append("ORDEr BY DT,ictm.Name ");

            DataTable dt = new DataTable();
            dt = StockReports.GetDataTable(sql.ToString());

            if (dt.Rows.Count > 0)
            {
                DataColumn DC = new DataColumn("DATE");
                DC.DefaultValue = "From : " + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + " To : " + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd");
                dt.Columns.Add(DC);

                DataColumn DC2 = new DataColumn("TIME");
                DC2.DefaultValue = txtTime.Text.Trim();
                dt.Columns.Add(DC2);

                DataColumn DC3 = new DataColumn("USER");
                DC3.DefaultValue = Session["LoginName"].ToString();
                dt.Columns.Add(DC3);

                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());
                Session["ReportName"] = "BedOccupancyReport";
                Session["ds"] = ds;
                //ds.WriteXml(@"c:\aaa.xml");
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open(@'~Design/Finanace/Commonreport.aspx');", true);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
                // Finanace\Commonreport.aspx
                //Session["ds"] = ds;
            }
        }
        else if (rbtType.SelectedValue == "2")
        {
            if (rbtPDF.SelectedValue.ToUpper() == "EXCEL" && rbtReportType.SelectedValue.ToUpper() != "ALL")
            {
                sql.Append("Select  ");

                if(rbtReportType.SelectedIndex ==1)
                    sql.Append("Specialization,BedCategory,");
                else if (rbtReportType.SelectedIndex == 2)
                    sql.Append("PanelGroup,Company_Name,Specialization,  ");
                else if (rbtReportType.SelectedIndex == 3)
                    sql.Append("Specialization,ConsultantName,");

                sql.Append("COUNT(IP_No)Total from (  ");
            }

            sql.Append(" Select PatientID Mr_No,TransactionID IP_No,PatientName,Age,Gender,Phone,Mobile,DateOfAdmit,TimeOfAdmit,");
            sql.Append(" IF(DateOfDischarge='0001-01-01','-',DATE_FORMAT(DateOfDischarge,'%d-%b-%y'))DateOfDischarge,");
            sql.Append(" IF(TimeOfDischarge='00:00:00','',TIME_FORMAT(TimeOfDischarge,'%l: %i %p'))TimeOfDischarge,");
            sql.Append(" Diagnosis,BedCategory,BedNo,Floor,ConsultantName,Specialization,Dept,PanelGroup,Company_Name,Remarks,");
            sql.Append(" BillAmt from (  ");
            sql.Append("        SELECT ip.PatientID,Replace(ip.TransactionID,'ISHHI','')TransactionID,");
            sql.Append("        Date_Format(PMH.DateOfAdmit,'%d-%b-%y')DateOfAdmit,Time_Format(PMH.TimeOfAdmit,'%l: %i %p')TimeOfAdmit,PMH.DateOfDischarge,");
            sql.Append("        PMH.TimeOfDischarge,rm.Bed_No AS BedNo,rm.Floor,ctm.Name AS BedCategory,concat(dm.Title,' ',dm.Name)ConsultantName,");
            sql.Append("        concat(pm.Title,' ',pm.PName)PatientName,pm.Age,pm.Gender,pm.Phone,pm.Mobile,pnl.Company_Name,PMH.Source,CONCAT(pmh.KinRelation,' ',pmh.KinName,' ','Phone',pmh.KinPhone)KinDetail,");
            sql.Append("        (select distinct(Department) from doctor_hospital where DoctorID = PMH.DoctorID)AS Dept,dm.Specialization,");
            sql.Append("        (Select Diagnosis from diagnosis_master where id=pmh.DiagnosisID)Diagnosis,pmh.Remarks,");
            sql.Append("        Round((select sum(ltd.Amount)  from f_ledgertnxdetail ltd where ");
            sql.Append("        TransactionID = ip.TransactionID and IsPackage = 0 and IsVerified = 1)) AS BillAmt,");
            sql.Append("        Round((select ifnull(sum(AmountPaid),0) from f_reciept where TransactionID = ip.TransactionID and IsCancel = 0))AS Deposit, ");
            sql.Append("        Round((select ifnull(sum(PanelApprovedAmt),0) from patient_medical_history where TransactionID = ip.TransactionID ))AS Approval, ");//f_ipdAdjustment
            sql.Append("        pnl.PanelGroup From (");
            sql.Append("               SELECT * FROM patient_ipd_profile pip INNER JOIN (  ");
            sql.Append("                       SELECT * FROM temp_for_date WHERE dt>='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' AND dt<= '" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "' ");
            sql.Append("               ) tfd WHERE  CONCAT(pip.StartDate,' ',pip.StartTime )  <= CONCAT(tfd.dt,' ','" + txtTime.Text.Trim() + "')  ");
            sql.Append("               AND IF(STATUS='IN',CONCAT(CURDATE(),' ','" + txtTime.Text.Trim() + "'), CONCAT(PIP.EndDate,' ',pip.EndTime)) >=   ");
            sql.Append("               CONCAT(tfd.dt,' ','" + txtTime.Text.Trim() + "')   ");
            sql.Append("        ) IP  ");

            sql.Append("        INNER JOIN patient_medical_history PMH ON IP.TransactionID = PMH.TransactionID ");//INNER JOIN ipd_case_history ich ON ip.TransactionID = ich.TransactionID
            sql.Append("        INNER JOIN room_master rm ON rm.RoomId = ip.RoomID INNER JOIN ipd_case_type_master ctm ON ctm.IPDCaseTypeID = rm.IPDCaseTypeID ");
            sql.Append("        INNER JOIN doctor_master dm ON dm.DoctorID = PMH.DoctorID INNER JOIN patient_master pm ON pm.PatientID = ip.PatientID");
            sql.Append("        INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID ");
            sql.Append("        Order by BedCategory,BedNo ");
            sql.Append(" )t ");

            if (rbtPDF.SelectedValue.ToUpper() == "EXCEL" && rbtReportType.SelectedValue.ToUpper() != "ALL")
            {
                sql.Append(")t Group by   ");

                if (rbtReportType.SelectedIndex == 1)
                    sql.Append("Specialization,BedCategory ");
                else if (rbtReportType.SelectedIndex == 2)
                    sql.Append("PanelGroup,Company_Name,Specialization   ");
                else if (rbtReportType.SelectedIndex == 3)
                    sql.Append("Specialization,ConsultantName ");

                sql.Append(" Order by   ");

                if (rbtReportType.SelectedIndex == 1)
                    sql.Append("Specialization,BedCategory ");
                else if (rbtReportType.SelectedIndex == 2)
                    sql.Append("PanelGroup,Company_Name,Specialization   ");
                else if (rbtReportType.SelectedIndex == 3)
                    sql.Append("Specialization,ConsultantName ");    
            }


            DataTable dt = new DataTable();
            dt = StockReports.GetDataTable(sql.ToString());

            if (dt.Rows.Count > 0)
            {
                if (rbtPDF.SelectedValue.ToUpper() == "PDF")
                {
                    DataColumn DC = new DataColumn("DATE");
                    DC.DefaultValue = "As On : " + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + " at " + txtTime.Text;
                    dt.Columns.Add(DC);

                    DataColumn DC2 = new DataColumn("TIME");
                    DC2.DefaultValue = txtTime.Text.Trim();
                    dt.Columns.Add(DC2);

                    DataColumn DC3 = new DataColumn("USER");
                    DC3.DefaultValue = Session["LoginName"].ToString();
                    dt.Columns.Add(DC3);

                    DataSet ds = new DataSet();
                    ds.Tables.Add(dt.Copy());
                    Session["ReportName"] = "BedOccupancyReportPatient";
                    Session["ds"] = ds;
                    //ds.WriteXml(@"c:\anandBedOccupanacy.xml");
                    //ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open(@'~Design/Finanace/Commonreport.aspx');", true);
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
                }
                else
                {
                    if (rbtPDF.SelectedValue.ToUpper() == "EXCEL" && rbtReportType.SelectedValue.ToUpper() != "ALL")
                    {
                        DataRow dr = dt.NewRow();
                        dr[0] = "Total : ";
                        dr["Total"] = dt.Compute("sum(Total)", "");
                        dt.Rows.Add(dr);
                    }

                    Session["dtExport2Excel"] = dt;
                    Session["ReportName"] = "Bed Occupancy -Detailed - " + rbtReportType.SelectedItem.Text ;
                    Session["Period"] = "As On : " + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + " at " + txtTime.Text;
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);



                }
            }

        }
        else 
        {
            if (rbtPDF.SelectedValue.ToUpper() == "EXCEL" && rbtReportType.SelectedValue.ToUpper() != "ALL")
            {
                sql.Append("Select Date_Format(dt,'%d-%b-%y')dt,");

                if (rbtReportType.SelectedIndex == 1)
                    sql.Append("Specialization,BedCategory,");
                else if (rbtReportType.SelectedIndex == 2)
                    sql.Append("PanelGroup,Company_Name,Specialization,  ");
                else if (rbtReportType.SelectedIndex == 3)
                    sql.Append("Specialization,ConsultantName,");

                sql.Append("COUNT(IP_No)Total from (  ");
            }

            sql.Append(" Select TransactionID IP_No,dt,");
            sql.Append(" BedCategory,BedNo,Floor,ConsultantName,Trim(Specialization)Specialization,Dept,PanelGroup,Company_Name ");
            sql.Append(" from (  ");
            sql.Append("        SELECT dt,Replace(ip.TransactionID,'ISHHI','')TransactionID,");
            sql.Append("        rm.Bed_No AS BedNo,rm.Floor,ctm.Name AS BedCategory,concat(dm.Title,' ',dm.Name)ConsultantName,");
            sql.Append("        pnl.Company_Name,");
            sql.Append("        (select distinct(Department) from doctor_hospital where DoctorID = PMH.DoctorID)AS Dept,dm.Specialization,");
            sql.Append("        pnl.PanelGroup From (");
            sql.Append("               SELECT * FROM patient_ipd_profile pip INNER JOIN (  ");
            sql.Append("                       SELECT * FROM temp_for_date WHERE dt>='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' AND dt<= '" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "' ");
            sql.Append("               ) tfd WHERE  CONCAT(pip.StartDate,' ',pip.StartTime )  <= CONCAT(tfd.dt,' ','" + txtTime.Text.Trim() + "')  ");
            sql.Append("               AND IF(STATUS='IN',CONCAT(CURDATE(),' ','" + txtTime.Text.Trim() + "'), CONCAT(PIP.EndDate,' ',pip.EndTime)) >=   ");
            sql.Append("               CONCAT(tfd.dt,' ','" + txtTime.Text.Trim() + "')   ");
            sql.Append("        ) IP  ");

            sql.Append("        INNER JOIN patient_medical_history PMH ON IP.TransactionID = PMH.TransactionID ");//INNER JOIN ipd_case_history ich ON ip.TransactionID = ich.TransactionID
            sql.Append("        INNER JOIN room_master rm ON rm.RoomId = ip.RoomID INNER JOIN ipd_case_type_master ctm ON ctm.IPDCaseTypeID = rm.IPDCaseTypeID ");
            sql.Append("        INNER JOIN doctor_master dm ON dm.DoctorID = PMH.DoctorID  ");
            sql.Append("        INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID ");
            sql.Append("        Order by BedCategory,BedNo ");
            sql.Append(" )t ");

            if (rbtPDF.SelectedValue.ToUpper() == "EXCEL" && rbtReportType.SelectedValue.ToUpper() != "ALL")
            {
                sql.Append(")t Group by   ");

                if (rbtReportType.SelectedIndex == 1)
                    sql.Append("dt,Specialization,BedCategory ");
                else if (rbtReportType.SelectedIndex == 2)
                    sql.Append("dt,PanelGroup,Company_Name,Specialization   ");
                else if (rbtReportType.SelectedIndex == 3)
                    sql.Append("dt,Specialization,ConsultantName ");

                sql.Append(" Order by   ");

                if (rbtReportType.SelectedIndex == 1)
                    sql.Append("dt,Specialization,BedCategory ");
                else if (rbtReportType.SelectedIndex == 2)
                    sql.Append("dt,PanelGroup,Company_Name,Specialization ");
                else if (rbtReportType.SelectedIndex == 3)
                    sql.Append("dt,Specialization,ConsultantName ");
            }


            DataTable dt = new DataTable();
            dt = StockReports.GetDataTable(sql.ToString());

            if (dt.Rows.Count > 0)
            {
                dt=CreateCrossTabDatewise(dt);

                Session["dtExport2Excel"] = dt;
                Session["ReportName"] = "Bed Occupancy -Administrative - " + rbtReportType.SelectedItem.Text;
                Session["Period"] = "From : " + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + " To " + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + " at " + txtTime.Text;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
               
            }

        }
    }
    protected void rbtType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rbtType.SelectedValue == "1")
        {
            rbtPDF.Visible = false;
            rbtPDF.SelectedIndex = 0;
            rbtPDF.Items[0].Enabled = true;

            rbtReportType.Visible = false;
            rbtReportType.Items[0].Enabled = true;
            rbtReportType.SelectedIndex = 0;

            lblFromDate.Visible = true;
            txtFromDate.Visible = true;
            lblFromDate.Text = "From Date :&nbsp;";
            lblToDate.Visible = true;
            txtToDate.Visible = true;
            lblToDate.Text = "To Date :&nbsp;";
        }
        else if (rbtType.SelectedValue == "2")
        {
            rbtPDF.Visible = true;
            rbtPDF.SelectedIndex = 0;
            rbtPDF.Items[0].Enabled = true;

            rbtReportType.Visible = false;
            rbtReportType.Items[0].Enabled = true;
            rbtReportType.SelectedIndex = 0;

            lblFromDate.Visible = true;
            txtFromDate.Visible = true;
            lblFromDate.Text = "As On :&nbsp;";

            lblToDate.Visible = false;
            txtToDate.Visible = false;
        }
        else 
        {
            rbtPDF.Visible = true;
            rbtPDF.SelectedIndex = 1;
            rbtPDF.Items[0].Enabled = false;

            rbtReportType.Visible = true;
            rbtReportType.Items[0].Enabled = false;
            rbtReportType.SelectedIndex = 1;

            lblFromDate.Visible = true;
            txtFromDate.Visible = true;
            lblFromDate.Text = "From Date :&nbsp;";
            lblToDate.Visible = true;
            txtToDate.Visible = true;
            lblToDate.Text = "To Date :&nbsp;";          

        }
    }
    protected void rbtPDF_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rbtPDF.SelectedValue.ToUpper() == "EXCEL")
            rbtReportType.Visible = true;
        else
            rbtReportType.Visible = false;
    }

    private DataTable CreateCrossTabDatewise(DataTable dt)
    {
        DataTable dtTemp = dt.Clone();
        foreach (DataRow dr in dt.Rows)
        {
            if (dtTemp.Columns.Contains(dr["dt"].ToString()) == false)
            {
                DataColumn dcNew = new DataColumn();
                dcNew.ColumnName = dr["dt"].ToString();
                dcNew.DataType = typeof(Int16);
                dcNew.DefaultValue = "0";
                dtTemp.Columns.Add(dcNew);
            }  
        }

        foreach (DataRow row in dt.Rows)
        {
            DataRow drNew = dtTemp.NewRow();

            if (rbtReportType.SelectedIndex == 1 )
            {
                DataRow[] dr = dt.Select("Specialization='" + row["Specialization"].ToString() + "' and BedCategory='" + row["BedCategory"].ToString() + "'");

                if (dr.Length >0)
                {
                    DataRow[] drTemp = dtTemp.Select("Specialization='" + row["Specialization"].ToString() + "' and BedCategory='" + row["BedCategory"].ToString() + "'");

                    if (drTemp.Length == 0) // if not inserted already in temp table
                    {
                        drNew["Specialization"] = row["Specialization"].ToString();
                        drNew["BedCategory"] = row["BedCategory"].ToString();

                        foreach (DataRow dr1 in dr)
                        {
                            foreach (DataColumn dc in dtTemp.Columns)
                            {
                                if (dc.ColumnName == dr1["dt"].ToString())
                                {
                                    drNew[dc.ColumnName] = dr1["Total"].ToString();
                                    drNew["Total"] = Util.GetString(Util.GetInt(drNew["Total"]) + Util.GetInt(dr1["Total"]));
                                }                                
                            }
                        }

                        dtTemp.Rows.Add(drNew);
                    }
                }
            }
            else if (rbtReportType.SelectedIndex == 2) //PanelGroup,Company_Name
            {
                DataRow[] dr = dt.Select("PanelGroup='" + row["PanelGroup"].ToString() + "' and Company_Name='" + row["Company_Name"].ToString() + "' and Specialization='" + row["Specialization"].ToString() + "'");

                if (dr.Length > 0)
                {
                    DataRow[] drTemp = dtTemp.Select("PanelGroup='" + row["PanelGroup"].ToString() + "' and Company_Name='" + row["Company_Name"].ToString() + "' and Specialization='" + row["Specialization"].ToString() + "'");

                    if (drTemp.Length == 0) // if not inserted already in temp table
                    {
                        drNew["PanelGroup"] = row["PanelGroup"].ToString();
                        drNew["Company_Name"] = row["Company_Name"].ToString();
                        drNew["Specialization"] = row["Specialization"].ToString();

                        foreach (DataRow dr1 in dr)
                        {
                            foreach (DataColumn dc in dtTemp.Columns)
                            {
                                if (dc.ColumnName == dr1["dt"].ToString())
                                {
                                    drNew[dc.ColumnName] = dr1["Total"].ToString();
                                    drNew["Total"] = Util.GetString(Util.GetInt(drNew["Total"]) + Util.GetInt(dr1["Total"]));
                                }

                                
                            }                           
                        }

                        dtTemp.Rows.Add(drNew);
                    }
                }
            }
            else if (rbtReportType.SelectedIndex == 3)
            {
                DataRow[] dr = dt.Select("Specialization='" + row["Specialization"].ToString() + "' and ConsultantName='" + row["ConsultantName"].ToString() + "'");

                if (dr.Length > 0)
                {
                    DataRow[] drTemp = dtTemp.Select("Specialization='" + row["Specialization"].ToString() + "' and ConsultantName='" + row["ConsultantName"].ToString() + "'");

                    if (drTemp.Length == 0) // if not inserted already in temp table
                    {
                        drNew["Specialization"] = row["Specialization"].ToString();
                        drNew["ConsultantName"] = row["ConsultantName"].ToString();

                        foreach (DataRow dr1 in dr)
                        {
                            foreach (DataColumn dc in dtTemp.Columns)
                            {
                                if (dc.ColumnName == dr1["dt"].ToString())
                                {
                                    drNew[dc.ColumnName] = dr1["Total"].ToString();
                                    drNew["Total"] = Util.GetString(Util.GetInt(drNew["Total"]) + Util.GetInt(dr1["Total"]));
                                }                                
                            }
                        }

                        dtTemp.Rows.Add(drNew);
                    }
                }
            }
        }

        DataView dv = dtTemp.DefaultView;
        if (rbtReportType.SelectedIndex == 1)
            dv.Sort = "Specialization,BedCategory";
        else if (rbtReportType.SelectedIndex == 2)
            dv.Sort = "PanelGroup,Company_Name,Specialization";
        else if (rbtReportType.SelectedIndex == 3)
            dv.Sort = "Specialization,ConsultantName";
        dtTemp = dv.ToTable();
        

        //PUTTING TOTAL FOR EACH GROUP'S BY CREATING NEW ROW FOR EACH GROUP AND INSERTING AT THE END OF EACH GROUP
        for (int j = 0; j < dtTemp.Rows.Count; j++)
        {
            if (rbtReportType.SelectedIndex == 1 || rbtReportType.SelectedIndex == 3)
            {
                if (j < dtTemp.Rows.Count - 1 && dtTemp.Rows[j]["Specialization"].ToString() != dtTemp.Rows[j + 1]["Specialization"].ToString())
                {
                    DataRow drGroupTotal = dtTemp.NewRow();
                    drGroupTotal["Specialization"] = dtTemp.Rows[j]["Specialization"].ToString() + " TOTAL :";

                    for(int k=3;k<dtTemp.Columns.Count;k++)
                    {
                        drGroupTotal[k] = dtTemp.Compute("sum([" + dtTemp.Columns[k] + "])", "Specialization='" + dtTemp.Rows[j]["Specialization"].ToString() + "' ");
                    }

                    dtTemp.Rows.InsertAt(drGroupTotal, j + 1);
                    j++;
                }
                else if (j == dtTemp.Rows.Count - 1)
                {
                    DataRow drGroupTotal = dtTemp.NewRow();
                    drGroupTotal["Specialization"] = dtTemp.Rows[j]["Specialization"].ToString() + " TOTAL :";

                    for (int k = 3; k < dtTemp.Columns.Count; k++)
                    {
                        drGroupTotal[k] = dtTemp.Compute("sum([" + dtTemp.Columns[k] + "])", "Specialization='" + dtTemp.Rows[j]["Specialization"].ToString() + "' ");
                    }

                    dtTemp.Rows.InsertAt(drGroupTotal, j + 1);
                    j++;
                }

            }
            else if (rbtReportType.SelectedIndex == 2)
            {
                if (j < dtTemp.Rows.Count - 1 && dtTemp.Rows[j]["PanelGroup"].ToString() != dtTemp.Rows[j + 1]["PanelGroup"].ToString())
                {
                    DataRow drGroupTotal = dtTemp.NewRow();
                    drGroupTotal["PanelGroup"] = dtTemp.Rows[j]["PanelGroup"].ToString() + " TOTAL :";

                    for (int k = 4; k < dtTemp.Columns.Count; k++)
                    {
                        drGroupTotal[dtTemp.Columns[k]] = dtTemp.Compute("sum([" + dtTemp.Columns[k] + "])", "PanelGroup='" + dtTemp.Rows[j]["PanelGroup"].ToString() + "' ");
                    }

                    dtTemp.Rows.InsertAt(drGroupTotal, j + 1);
                    j++;
                }
                else if (j == dtTemp.Rows.Count - 1)
                {
                    DataRow drGroupTotal = dtTemp.NewRow();
                    drGroupTotal["PanelGroup"] = dtTemp.Rows[j]["PanelGroup"].ToString() + " TOTAL :";

                    for (int k = 4; k < dtTemp.Columns.Count; k++)
                    {
                        drGroupTotal[dtTemp.Columns[k]] = dtTemp.Compute("sum([" + dtTemp.Columns[k] + "])", "PanelGroup='" + dtTemp.Rows[j]["PanelGroup"].ToString() + "' ");
                    }

                    dtTemp.Rows.InsertAt(drGroupTotal, j + 1);
                    j++;
                }
            }

        }

        //REMOVING GROUP NAME FROM EACH ROW ON SUBSEQUENT APPEARANCE OF GROUP NAME SO THAT GROUPNAME WILL APPEAR ONCE

        string Specialization = "", PanelGroup = "", Company_Name = "";
        for (int j = 0; j < dtTemp.Rows.Count; j++)
        {
            if (rbtReportType.SelectedIndex == 1 || rbtReportType.SelectedIndex == 3)
            {
                //Specialization,BedCategory,dt 
                if (Specialization != dtTemp.Rows[j]["Specialization"].ToString())
                {                    
                    Specialization = dtTemp.Rows[j]["Specialization"].ToString();
                }
                else
                    dtTemp.Rows[j]["Specialization"] = "";                

            }
            else if (rbtReportType.SelectedIndex == 2)
            {
                //PanelGroup,Company_Name
                if (PanelGroup != dtTemp.Rows[j]["PanelGroup"].ToString())
                {
                    PanelGroup = dtTemp.Rows[j]["PanelGroup"].ToString();

                    if (Company_Name != dtTemp.Rows[j]["Company_Name"].ToString())
                        Company_Name = dtTemp.Rows[j]["Company_Name"].ToString();
                    else
                        dtTemp.Rows[j]["Company_Name"] = "";
                }
                else
                {
                    if (Company_Name != dtTemp.Rows[j]["Company_Name"].ToString())
                    {
                        Company_Name = dtTemp.Rows[j]["Company_Name"].ToString();

                        if (PanelGroup == dtTemp.Rows[j]["PanelGroup"].ToString())
                            dtTemp.Rows[j]["PanelGroup"] = "";
                        else
                            PanelGroup = dtTemp.Rows[j]["PanelGroup"].ToString();
                    }
                    else
                    {
                        dtTemp.Rows[j]["PanelGroup"] = "";
                        dtTemp.Rows[j]["Company_Name"] = "";
                    }
                }
            }            
            
        }

        DataRow drGrandTotal = dtTemp.NewRow();
        for (int j = 3; j <= dtTemp.Columns.Count - 1; j++)
        {
            drGrandTotal[1] = "Grand Total :";

            if (rbtReportType.SelectedIndex == 1 || rbtReportType.SelectedIndex == 3)
            {
                drGrandTotal[dtTemp.Columns[j]] = dtTemp.Compute("sum([" + dtTemp.Columns[j] + "])", "Specialization like '%Total%' ");
            }
            else
            {
                if (j == 3) j++;
                drGrandTotal[dtTemp.Columns[j]] = dtTemp.Compute("sum([" + dtTemp.Columns[j] + "])", "PanelGroup like '%Total%'  ");
            }
        }


        dtTemp.Rows.Add(drGrandTotal);
        dtTemp.AcceptChanges();

        return dtTemp;
    }
}
