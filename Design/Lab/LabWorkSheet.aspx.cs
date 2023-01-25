using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using MW6BarcodeASPNet;

public partial class Design_Lab_LabWorkSheet : System.Web.UI.Page
{
    private System.Drawing.Bitmap objBitmap;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            calEntryDate1.EndDate = DateTime.Now;
            CalendarExtender1.EndDate = DateTime.Now;
            FrmDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            BindDepartment();
            All_LoadData.bindPanel(ddlPanel, "All");
            txtFromTime.Text = "00:00:00 AM";
            txtToTime.Text = "11:59:59 PM";
        }
    }
    protected void BindDepartment()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT DISTINCT ot.Name,ot.ObservationType_ID FROM investigation_master im INNER JOIN investigation_observationtype io  ");
        sb.Append(" ON im.Investigation_Id = io.Investigation_ID INNER JOIN observationtype_master ot ON ot.ObservationType_ID = io.ObservationType_Id ");
        sb.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = ot.ObservationType_ID ");
        sb.Append(" order by ot.Name");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            ddlDepartment.DataSource = dt;
            ddlDepartment.DataValueField = "ObservationType_ID";
            ddlDepartment.DataTextField = "Name";
            ddlDepartment.DataBind();
            ddlDepartment.Items.Insert(0, "All");
        }
    }
    
    protected void grdLabSearch_RowDataBound(object sender, GridViewRowEventArgs e)
    {




        if (e.Row.RowType == DataControlRowType.Header)
        {
            e.Row.TableSection = TableRowSection.TableHeader;

            if (Resources.Resource.Packsbutton == "1")
            {
                e.Row.Cells[3].Text = "Pacs&nbsp;No.";
                grdLabSearch.Columns[3].Visible = true;
            }
            else
            {
                grdLabSearch.Columns[3].Visible = false;
            }
        }

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblReportType")).Text != "5")
            {
                e.Row.Cells[3].Text = "";
            }
            if (((Label)e.Row.FindControl("lblMacStatus")).Text == "1")
            {
                e.Row.BackColor = System.Drawing.Color.YellowGreen;
            }
            if (((Label)e.Row.FindControl("lblResult")).Text == "true")
            {
                e.Row.BackColor = System.Drawing.Color.Coral;
            }
            if (((Label)e.Row.FindControl("lblapprove")).Text == "1")
            {
                e.Row.BackColor = System.Drawing.Color.LightGreen;
                if (Session["LoginType"].ToString().ToLower() == "mri")
                {
                    e.Row.Cells[9].Enabled = false;
                    e.Row.Cells[15].Enabled = false;
                }
            }

            if (((Label)e.Row.FindControl("lblapprove")).Text != "1" && (((Label)e.Row.FindControl("lblResult")).Text != "true"))
            {
                if (((Label)e.Row.FindControl("lblUrgent")).Text.ToUpper() == "URGENT")
                {
                    ((Label)e.Row.FindControl("lblUrgent")).ForeColor = System.Drawing.Color.Red;
                    e.Row.BackColor = System.Drawing.Color.Pink;
                }
                else
                {
                    ((Label)e.Row.FindControl("lblUrgent")).ForeColor = System.Drawing.Color.Green;
                }
            }
            if (((Label)e.Row.FindControl("lblapprove")).Text != "1" && (((Label)e.Row.FindControl("lblResult")).Text != "true"))
            {
                if (((Label)e.Row.FindControl("lblIs_Outsource")).Text == "1")
                {
                    e.Row.BackColor = System.Drawing.Color.Aqua;
                }
            }
            if (((Label)e.Row.FindControl("lblPendingAmount")).Text != "1" && (((Label)e.Row.FindControl("lblReportType")).Text == "1" || ((Label)e.Row.FindControl("lblReportType")).Text == "3" || ((Label)e.Row.FindControl("lblReportType")).Text == "5"))
            {
                e.Row.BackColor = System.Drawing.Color.DarkGray;
            }
            if (((Label)e.Row.FindControl("lblIsDelay")).Text == "1")
            {
                ((Image)e.Row.FindControl("imgDelay")).Visible = true;
            }
            string LedgerTransactionNO = ((Label)e.Row.FindControl("lblLedgerTnx")).Text;
            string Type = ((Label)e.Row.FindControl("lblType")).Text;

            if (e.Row.RowIndex >= 1)
            {
                string PreviousLedgerTransactionNO = ((Label)grdLabSearch.Rows[e.Row.RowIndex - 1].FindControl("lblLedgerTnx")).Text;
                if (LedgerTransactionNO == PreviousLedgerTransactionNO)
                {
                    ((Label)e.Row.FindControl("lblAge")).Text = "";
                    ((Label)e.Row.FindControl("lblPatientID")).Text = "";
                    ((Label)e.Row.FindControl("lblPName")).Text = "";
                    ((Label)e.Row.FindControl("lblIPDNo")).Text = "";


                }
                string PreviousType = ((Label)grdLabSearch.Rows[e.Row.RowIndex - 1].FindControl("lblType")).Text;
                if (Type == PreviousType)
                {
                    ((Label)e.Row.FindControl("lblPatientType")).Text = "";

                }

            }
        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        DataTable dtInvest = Search();
        if (dtInvest != null && dtInvest.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "LabType";
            dc.DefaultValue = rdbLabType.SelectedValue;
            dtInvest.Columns.Add(dc);
            // ViewState["dtInvest"] = dtInvest;

            grdLabSearch.DataSource = dtInvest;
            grdLabSearch.DataBind();


            lblMsg.Text = "Total Patient :" + dtInvest.AsEnumerable().Select(r => r.Field<string>("PatientID")).Distinct().Count() + " Total Test :" + dtInvest.Rows.Count;
            btnWorkSheet.Visible = true;
           
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            grdLabSearch.DataSource = null;
            grdLabSearch.DataBind();
           // btnWorkSheet.Visible = false;
        }
    }

    #region Search
    private DataTable Search()
    {
        StringBuilder sb = new StringBuilder();
        string TypeofTnx = string.Empty;

        if (rdbLabType.SelectedValue == "OPD")
            TypeofTnx = "OPD-Lab";
        else
            TypeofTnx = "IPD-Lab";
        //string LoginType = Session["LoginType"].ToString().ToUpper();
        // if (Convert.ToString(Session["LoginType"]).ToUpper() == "RADIOLOGY")
        //    strReportType = "=5";
        //  else
        //    strReportType = "<>5";
        string ListOf = "";

        if (ddlStatus.SelectedIndex > 0)
        {
            ListOf = "List of " + ddlStatus.SelectedItem.Text;
        }
        if (rdbLabType.SelectedValue.ToUpper() != "ALL")
        {
            if (rdbLabType.SelectedValue == "OPD")
            {
                sb.Append("select '" + ListOf + " From " + FrmDate.Text + " To " + ToDate.Text + "' as ReportDate,'OPD' Type,im.Name ObservationName,io.ObservationType_Id, im.Investigation_Id,PM.PatientID,PM.PatientID PID,CONCAT(PM.Title,' ',Pm.PName)pname,pm.age,pm.gender,concat(pm.House_No,pm.Street_Name,pm.Locality,pm.City)Address,pli.TransactionID,pli.Test_ID,pli.LedgerTransactionNo,REPLACE(REPLACE(pli.LedgerTransactionNo,'LOSHHI','1'),'LSHHI',2)LTD,im.Name,pli.ID,pli.IsOutSource,pli.OutSourceName,if(pli.IsUrgent=1,'Urgent','Routine')IsUrgent");
                sb.Append(" ,if(PLI.Result_Flag = 0,'false','true')IsResult,date_format(pli.date,'%d-%b-%Y')InDate,pli.Approved,if(pli.Approved='1','True','False') chkWork,TIME_FORMAT(pli.Time,'%l:%i %p')TIME,if(PLI.IsSampleCollected = 'Y','YES','NO')IsSample,DATE_FORMAT(pli.SampleDate,'%d-%b-%y %l:%i %p')SampleDate,obm.Name as Dept,IM.ReportType,'' TransactionID,''room, ");
                sb.Append("(SELECT CONCAT(Title,' ',NAME)NAME FROM doctor_master WHERE doctorID =pli.doctorID)DName, ");
                sb.Append(" (SELECT IF(IFNULL(reading,'')='',FALSE,TRUE) FROM mac_data mac WHERE mac.Test_ID = pli.Test_ID  AND mac.LedgerTransactionNo=pli.LedgerTransactionNo AND Reading<>'' LIMIT 1)MacStatus, ");
                sb.Append(" IF(lt.NetAmount=lt.Adjustment,TRUE,FALSE)PendingAmount, ");
                sb.Append(" IF(PLI.TestTAT<>0,IF(HOUR(TIMEDIFF(IFNULL(pli.ApprovedDate,NOW()),pli.SampleReceiveDate))>pli.TestTAT,'1','0'),'')IsDelay,fpm.Company_Name Panel,pli.isPrint,IFNULL(pli.BarcodeNo,'')BarcodeNo ");
                sb.Append(" FROM patient_labinvestigation_opd pli  ");
                sb.Append(" INNER JOIN  f_ledgertransaction lt on lt.LedgerTransactionNo=pli.LedgerTransactionNo ");
                sb.Append(" INNER JOIN Patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID ");
                sb.Append(" INNER JOIN f_panel_master fpm ON fpm.PanelID=pmh.PanelID ");
                sb.Append(" INNER JOIN patient_master PM on pli.PatientID = PM.PatientID  ");
                sb.Append(" INNER JOIN investigation_master im on pli.Investigation_ID = im.Investigation_Id INNER JOIN investigation_observationtype io ON im.Investigation_Id = io.Investigation_ID	INNER JOIN observationtype_master obm ON obm.ObservationType_ID=io.ObservationType_Id ");
                sb.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = obm.ObservationType_ID ");
                sb.Append(" where (lt.TypeOfTnx='opd-lab' or lt.TypeOfTnx='opd-package' or lt.TypeofTnx='OPD-BILLING' or lt.TypeofTnx='Emergency' ) and lt.IsCancel=0   AND lt.CentreID='" + Session["CentreID"].ToString() + "' ");
            }
            else
            {
                sb.Append("select  '" + ListOf + " From " + FrmDate.Text + " To " + ToDate.Text + "' as ReportDate,'IPD' Type, im.Name ObservationName,io.ObservationType_Id, im.Investigation_Id,PM.PatientID, PM.PatientID PID,CONCAT(PM.Title,' ',Pm.PName)pname,pm.age,pm.gender,concat(pm.House_No,pm.Street_Name,pm.Locality,pm.City)Address,Replace(pli.TransactionID,'ISHHI','')TransactionID,pli.Test_ID,pli.ID,pli.IsOutSource,pli.OutSourceName,if(pli.IsUrgent=1,'Urgent','Routine')IsUrgent, ");
                sb.Append(" pli.LedgerTransactionNo,REPLACE(pli.LedgerTransactionNo,'LISHHI','3')LTD,IM.Name,if(PLI.Result_Flag=0,'false','true')IsResult,date_format(pli.date,'%d-%b-%Y')InDate,pli.Approved,if(pli.Approved='1','True','False') chkWork,TIME_FORMAT(pli.Time,'%l:%i %p')TIME,if(PLI.IsSampleCollected = 'Y','YES','NO')IsSample,DATE_FORMAT(pli.SampleDate,'%d-%b-%y %l:%i %p')SampleDate,obm.Name as Dept,IM.ReportType,pli.TransactionID as TransactionID, ");
                sb.Append(" ( SELECT CONCAT(NAME,'/',bed_no)room FROM patient_ipd_profile pif INNER JOIN room_master rm ON pif.Room_ID=rm.Room_Id WHERE patientid=pm.`PatientID` AND STATUS ='IN')room, ");
                sb.Append("(SELECT CONCAT(Title,' ',NAME)NAME FROM doctor_master WHERE doctorID =pli.doctorID)DName, ");
                sb.Append(" (SELECT IF(IFNULL(reading,'')='',FALSE,TRUE) FROM mac_data mac WHERE mac.Test_ID = pli.Test_ID  AND mac.LedgerTransactionNo=pli.LedgerTransactionNo AND Reading<>'' LIMIT 1)MacStatus, ");
                sb.Append(" '1'PendingAmount, ");
                sb.Append(" IF(PLI.TestTAT<>0,IF(HOUR(TIMEDIFF(IFNULL(pli.ApprovedDate,NOW()),pli.SampleReceiveDate))>pli.TestTAT,'1','0'),'')IsDelay,fpm.Company_Name Panel,pli.isPrint,IFNULL(pli.BarcodeNo,'')BarcodeNo ");
                sb.Append(" FROM patient_labinvestigation_opd pli ");
                sb.Append(" INNER JOIN f_ledgertransaction lt ON pli.LedgerTransactionNo=lt.LedgerTransactionNo INNER JOIN investigation_master IM on PLI.Investigation_ID=IM.Investigation_Id ");
                sb.Append(" INNER JOIN patient_medical_history pmh on PLI.TransactionID =pmh.TransactionID ");
                sb.Append(" INNER JOIN f_panel_master fpm ON fpm.PanelID=pmh.PanelID ");
                sb.Append(" INNER JOIN  patient_master PM on pmh.PatientID=PM.PatientID INNER JOIN investigation_observationtype io ON im.Investigation_Id = io.Investigation_ID INNER JOIN observationtype_master obm ON obm.ObservationType_ID=io.ObservationType_Id  ");
                sb.Append(" INNER JOIN f_ledgertnxDetail ltd on ltd.LedgerTransactionNo = lt.LedgertransactionNo ");
                sb.Append(" INNER JOIN f_ItemMaster imas on imas.ItemID = Ltd.ItemID and imas.Type_ID=im.Investigation_ID ");
                sb.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = obm.ObservationType_ID");
                sb.Append(" where ltd.IsVerified=1  AND lt.CentreID='" + Session["CentreID"].ToString() + "' ");
            }

            if (!String.IsNullOrEmpty(txtBarCodeNo.Text))
            {

               if (ddlStatus.SelectedItem.Text == "Not Approved")
                {

                    sb.Append(" and pli.Result_Flag=1 and IFNULL(pli.Approved,0)=0 ");
                }
               else if (ddlStatus.SelectedItem.Text == "Result Not Done")
               {

                   sb.Append(" and pli.Result_Flag=0");

               }
               else {
                   sb.Append(" and IFNULL(pli.Approved,0)=0 ");
               }

                if (ddlDepartment.SelectedIndex > 0)
                {
                    sb.Append(" and io.ObservationType_ID='" + ddlDepartment.SelectedItem.Value + "'");
                }

                sb.Append(" and pli.BarcodeNo='" + txtBarCodeNo.Text.Trim() + "' ");
            }
            else
            {

                if (txtMRNo.Text != string.Empty)
                    if (rdbLabType.SelectedValue == "OPD")
                        sb.Append(" AND PM.PatientID='" + txtMRNo.Text.Trim() + "' ");
                    else
                        sb.Append(" AND PM.PatientID='" + txtMRNo.Text.Trim() + "'");

                if (ddlPanel.SelectedIndex > 0)
                    sb.Append(" AND fpm.PanelID='" + ddlPanel.SelectedValue + "' ");

                if (txtPName.Text != string.Empty)
                    sb.Append(" AND PM.PName like '" + txtPName.Text.Trim() + "%'");

             if (ddlStatus.SelectedItem.Text == "Not Approved")
                {
                    if (FrmDate.Text != string.Empty)
                        sb.Append(" and PLI.Date >='" + Util.GetDateTime(FrmDate.Text).ToString("yyyy-MM-dd") + "'");

                    if (ToDate.Text != string.Empty)
                        sb.Append(" and PLI.Date <='" + Util.GetDateTime(ToDate.Text).ToString("yyyy-MM-dd") + "'");
                    sb.Append(" and pli.Result_Flag=1 and IFNULL(pli.Approved,0)=0 ");
                }
                else if (ddlStatus.SelectedItem.Text == "Result Not Done")
                {
                  
                        if (FrmDate.Text != string.Empty)
                            sb.Append(" and PLI.Date >='" + Util.GetDateTime(FrmDate.Text).ToString("yyyy-MM-dd") + "'");

                        if (ToDate.Text != string.Empty)
                            sb.Append(" and PLI.Date <='" + Util.GetDateTime(ToDate.Text).ToString("yyyy-MM-dd") + "'");
                        sb.Append(" and pli.Result_Flag=0");
                    

                }
                else
                {
                    if (FrmDate.Text != string.Empty)
                        sb.Append(" and PLI.Date >='" + Util.GetDateTime(FrmDate.Text).ToString("yyyy-MM-dd") + "'");

                    if (ToDate.Text != string.Empty)
                        sb.Append(" and PLI.Date <='" + Util.GetDateTime(ToDate.Text).ToString("yyyy-MM-dd") + "'");
                   
                   sb.Append(" and IFNULL(pli.Approved,0)=0 ");
              
                }

                if (txtLabNo.Text != string.Empty)
                {
                    if (rdbLabType.SelectedValue == "ALL")
                        sb.Append(" and ( PLI.LedgerTransactionNo=CONCAT(REPLACE(SUBSTRING('" + txtLabNo.Text.Trim() + "', 1, 1),'1','LOSHHI'),SUBSTRING('" + txtLabNo.Text.Trim() + "' FROM 2) ) OR PLI.LedgerTransactionNo=CONCAT(REPLACE(SUBSTRING('" + txtLabNo.Text.Trim() + "', 1, 1),'2','LSHHI'),SUBSTRING('" + txtLabNo.Text.Trim() + "' FROM 2) ) ) ");
                    else if (rdbLabType.SelectedValue == "IPD")
                        sb.Append(" and PLI.LedgerTransactionNo=CONCAT(REPLACE(SUBSTRING('" + txtLabNo.Text.Trim() + "', 1, 1),'3','LISHHI'),SUBSTRING('" + txtLabNo.Text.Trim() + "' FROM 2) )");
                    else
                        sb.Append(" and ( PLI.LedgerTransactionNo=CONCAT(REPLACE(SUBSTRING('" + txtLabNo.Text.Trim() + "', 1, 1),'1','LOSHHI'),SUBSTRING('" + txtLabNo.Text.Trim() + "' FROM 2) ) OR PLI.LedgerTransactionNo=CONCAT(REPLACE(SUBSTRING('" + txtLabNo.Text.Trim() + "', 1, 1),'2','LSHHI'),SUBSTRING('" + txtLabNo.Text.Trim() + "' FROM 2) ) ) ");
                }

                if (ddlDepartment.SelectedIndex > 0)
                {
                    sb.Append(" and io.ObservationType_ID='" + ddlDepartment.SelectedItem.Value + "'");
                }

                //For Urgent (Start)
                if (ddlUrgent.SelectedValue != "2")
                {
                    sb.Append(" and pli.IsUrgent='" + ddlUrgent.SelectedValue + "'");
                }
                //For Urgent (End)
                if (txtCptcode.Text != string.Empty)
                    sb.Append(" and imas.ItemCode='" + txtCptcode.Text.Trim() + "'");

                if (txtCRNo.Text != string.Empty)
                {
                    if (rdbLabType.SelectedValue == "IPD")
                    {
                        sb.Append(" and  pli.TransactionID='ISHHI" + txtCRNo.Text.Trim() + "'");
                    }
                    else
                        sb.Append(" and  pli.TransactionID like '%" + txtCRNo.Text.Trim() + "'");
                }
            }
            if (ddlPrintStatus.SelectedItem.Value != "2")
                sb.Append(" and pli.IsWorkSheetPrint=" + Util.GetInt(ddlPrintStatus.SelectedItem.Value) + " ");

            sb.Append(" group by pli.ID order by PLI.ID ");
        }
        /////////////////shatrughan 23.07.13
        else // ALL CASES
        {
            sb.Append(" Select t.* from (");
            sb.Append("select '" + ListOf + " From " + Util.GetDateTime(FrmDate.Text).ToString("yyyy-MM-dd") + " To " + Util.GetDateTime(ToDate.Text).ToString("yyyy-MM-dd") + "' as ReportDate,'OPD' Type,im.Name ObservationName,io.ObservationType_Id, im.Investigation_Id,PM.PatientID, Replace(PM.PatientID,'LSHHI','')PID,CONCAT(PM.Title,' ',Pm.PName)pname,pm.age,pm.gender,concat(pm.House_No,pm.Street_Name,pm.Locality,pm.City,pm.Pincode)Address,pli.TransactionID,pli.Test_ID,pli.LedgerTransactionNo,REPLACE(REPLACE(pli.LedgerTransactionNo,'LOSHHI','1'),'LSHHI',2)LTD,im.Name,pli.IsOutSource,pli.OutSourceName,if(pli.IsUrgent=1,'Urgent','Routine')IsUrgent");
            sb.Append(" ,if(PLI.Result_Flag = 0,'false','true')IsResult,date_format(pli.date,'%d-%b-%y')InDate,pli.Approved,if(pli.Approved='1','True','False') chkWork,TIME_FORMAT(pli.Time,'%l:%i %p')TIME,if(PLI.IsSampleCollected = 'Y','YES','NO')IsSample,DATE_FORMAT(pli.SampleDate,'%d-%b-%y %l:%i %p')SampleDate,obm.Name as Dept,IM.ReportType, ");
            sb.Append("(Select CONCAT(Title,' ',NAME)name from doctor_master where doctorID =pli.doctorID )DName,pli.ID , (SELECT TransactionID FROM f_ipdadjustment WHERE PatientID=pm.`PatientID` ORDER BY CONVERT(REPLACE(TransactionID,'ISHHI',''),UNSIGNED INTEGER)  DESC LIMIT 1)TransactionID,	( SELECT CONCAT(NAME,'/',bed_no)room FROM patient_ipd_profile pif INNER JOIN room_master rm ON pif.Room_ID=rm.Room_Id WHERE patientid=pm.`PatientID` AND STATUS ='IN')room ");

            if (ddlStatus.SelectedItem.Text == "Not Approved")
            {
                sb.Append(" ,lt.Date BookingDate,TIME_FORMAT(TIMEDIFF(NOW(),pli.SampleDate),'%H Hour %i min')PendingTime  ");

            }
            sb.Append(" ,IF(lt.NetAmount=lt.Adjustment,TRUE,FALSE)PendingAmount, ");
            sb.Append(" IF(PLI.TestTAT<>0,IF(HOUR(TIMEDIFF(IFNULL(pli.ApprovedDate,NOW()),pli.SampleReceiveDate))>pli.TestTAT,'1','0'),'')IsDelay, ");
            sb.Append(" (SELECT IF(IFNULL(reading,'')='',FALSE,TRUE) FROM mac_data mac WHERE mac.Test_ID = pli.Test_ID  AND mac.LedgerTransactionNo=pli.LedgerTransactionNo AND Reading<>'' LIMIT 1)MacStatus,fpm.Company_Name Panel,pli.isPrint,IFNULL(pli.BarcodeNo,'')BarcodeNo ");
            sb.Append(" from patient_labinvestigation_opd pli inner join f_ledgertransaction lt on lt.LedgerTransactionNo=pli.LedgerTransactionNo");
            sb.Append(" INNER JOIN Patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID ");
            sb.Append(" INNER JOIN f_panel_master fpm ON fpm.PanelID=pmh.PanelID ");
            sb.Append(" INNER JOIN patient_master PM on pli.PatientID = PM.PatientID  ");
            sb.Append(" INNER JOIN investigation_master im on pli.Investigation_ID = im.Investigation_Id INNER JOIN investigation_observationtype io ON im.Investigation_Id = io.Investigation_ID	INNER JOIN observationtype_master obm ON obm.ObservationType_ID=io.ObservationType_Id INNER JOIN f_ledgertnxDetail ltd ON ltd.LedgerTransactionNo = lt.LedgertransactionNo INNER JOIN f_ItemMaster imas ON imas.ItemID = Ltd.ItemID AND imas.Type_ID=im.Investigation_ID");
            sb.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = obm.ObservationType_ID  ");
            sb.Append(" where (lt.TypeOfTnx='opd-lab' or lt.TypeOfTnx='opd-package' or lt.TypeOfTnx='OPD-BILLING') and lt.IsCancel=0  ");

            if (!String.IsNullOrEmpty(txtBarCodeNo.Text))
            {

                if (ddlStatus.SelectedItem.Text == "Not Approved")
                {
                    sb.Append(" and pli.Result_Flag=1 and IFNULL(pli.Approved,0)=0 ");
                }
                else if (ddlStatus.SelectedItem.Text == "Result Not Done")
                {
                    sb.Append(" and pli.Result_Flag=0");

                }
                else {

                    sb.Append("  and IFNULL(pli.Approved,0)=0 ");
                }


                if (ddlDepartment.SelectedIndex > 0)
                {
                    sb.Append(" and io.ObservationType_ID='" + ddlDepartment.SelectedItem.Value + "'");
                }
                sb.Append(" and pli.BarcodeNo='" + txtBarCodeNo.Text.Trim() + "' ");
            }
            else
            {
                if (txtMRNo.Text != string.Empty)
                    sb.Append(" and PM.PatientID='" + txtMRNo.Text.Trim() + "'");

            

                if (ddlPanel.SelectedIndex > 0)
                    sb.Append(" AND fpm.PanelID='" + ddlPanel.SelectedValue + "' ");

                if (txtPName.Text != string.Empty)
                    sb.Append(" and PM.PName like '%" + txtPName.Text.Trim() + "%'");
               
                if (ddlStatus.SelectedItem.Text == "Not Approved")
                {
                    if (FrmDate.Text != string.Empty)
                        sb.Append(" and PLI.Date >='" + Util.GetDateTime(FrmDate.Text).ToString("yyyy-MM-dd") + "'");

                    if (ToDate.Text != string.Empty)
                        sb.Append(" and PLI.Date <='" + Util.GetDateTime(ToDate.Text).ToString("yyyy-MM-dd") + "'");
                    sb.Append(" and pli.Result_Flag=1 and IFNULL(pli.Approved,0)=0 ");
                }
                else if (ddlStatus.SelectedItem.Text == "Result Not Done")
                {
                        if (FrmDate.Text != string.Empty)
                            sb.Append(" and PLI.Date >='" + Util.GetDateTime(FrmDate.Text).ToString("yyyy-MM-dd") + "'");

                        if (ToDate.Text != string.Empty)
                            sb.Append(" and PLI.Date <='" + Util.GetDateTime(ToDate.Text).ToString("yyyy-MM-dd") + "'");
                        sb.Append(" and pli.Result_Flag=0");
                    

                }
                else
                {
                    if (FrmDate.Text != string.Empty)
                        sb.Append(" and PLI.Date >='" + Util.GetDateTime(FrmDate.Text).ToString("yyyy-MM-dd") + "'");

                    if (ToDate.Text != string.Empty)
                        sb.Append(" and PLI.Date <='" + Util.GetDateTime(ToDate.Text).ToString("yyyy-MM-dd") + "'");

                    sb.Append("  and IFNULL(pli.Approved,0)=0 ");
                }
                if (txtCptcode.Text != string.Empty)
                    sb.Append(" and imas.ItemCode='" + txtCptcode.Text.Trim() + "'");

                if (txtLabNo.Text != string.Empty)
                {
                    if (rdbLabType.SelectedValue == "ALL")
                        sb.Append(" ( and PLI.LedgerTransactionNo=CONCAT(REPLACE(SUBSTRING('" + txtLabNo.Text.Trim() + "', 1, 1),'1','LOSHHI'),SUBSTRING('" + txtLabNo.Text.Trim() + "' FROM 2) ) OR PLI.LedgerTransactionNo=CONCAT(REPLACE(SUBSTRING('" + txtLabNo.Text.Trim() + "', 1, 1),'2','LSHHI'),SUBSTRING('" + txtLabNo.Text.Trim() + "' FROM 2) ) ) ");
                    else if (rdbLabType.SelectedValue == "IPD")
                        sb.Append(" and PLI.LedgerTransactionNo=CONCAT(REPLACE(SUBSTRING('" + txtLabNo.Text.Trim() + "', 1, 1),'3','LISHHI'),SUBSTRING('" + txtLabNo.Text.Trim() + "' FROM 2) )");
                    else
                        sb.Append(" and PLI.LedgerTransactionNo=CONCAT(REPLACE(SUBSTRING('" + txtLabNo.Text.Trim() + "', 1, 1),'1','LOSHHI'),SUBSTRING('" + txtLabNo.Text.Trim() + "' FROM 2) )");
                }

                //For Urgent (Start)
                if (ddlUrgent.SelectedValue != "2")
                {
                    sb.Append(" and pli.IsUrgent='" + ddlUrgent.SelectedValue + "'");
                }


                if (txtCRNo.Text != string.Empty)
                {
                    sb.Append(" and  pli.TransactionID like '%" + txtCRNo.Text.Trim() + "'");
                }

                if (ddlDepartment.SelectedIndex > 0)
                {
                    sb.Append(" and io.ObservationType_ID='" + ddlDepartment.SelectedItem.Value + "'");
                }
            }
            if (ddlPrintStatus.SelectedItem.Value != "2")
                sb.Append(" and pli.IsWorkSheetPrint=" + Util.GetInt(ddlPrintStatus.SelectedItem.Value) + " ");

            sb.Append(" Union ALL ");

            sb.Append("select  '" + ListOf + " From " + Util.GetDateTime(FrmDate.Text).ToString("yyyy-MM-dd") + " To " + Util.GetDateTime(ToDate.Text).ToString("yyyy-MM-dd") + "' as ReportDate,'IPD' Type, im.Name ObservationName,io.ObservationType_Id, im.Investigation_Id,PM.PatientID, Replace(PM.PatientID,'LSHHI','')PID,CONCAT(PM.Title,' ',Pm.PName)pname,pm.age,pm.gender,concat(pm.House_No,pm.Street_Name,pm.Locality,pm.City,pm.Pincode)Address,Replace(pli.TransactionID,'ISHHI','')TransactionID,pli.Test_ID, ");
            sb.Append(" pli.LedgerTransactionNo,REPLACE(pli.LedgerTransactionNo,'LISHHI','3')LTD,IM.Name,pli.IsOutSource,pli.OutSourceName,if(pli.IsUrgent=1,'Urgent','Routine')IsUrgent,if(PLI.Result_Flag=0,'false','true')IsResult,date_format(pli.date,'%d-%b-%y')InDate,pli.Approved,if(pli.Approved='1','True','False') chkWork,TIME_FORMAT(pli.Time,'%l:%i %p')TIME,if(PLI.IsSampleCollected = 'Y','YES','NO')IsSample,DATE_FORMAT(pli.SampleDate,'%d-%b-%y %l:%i %p')SampleDate,obm.Name as Dept,IM.ReportType,");
            sb.Append("(Select CONCAT(Title,' ',NAME)name from doctor_master where doctorID =pli.doctorID )DName,pli.ID , (SELECT TransactionID FROM f_ipdadjustment WHERE PatientID=pm.`PatientID` ORDER BY CONVERT(REPLACE(TransactionID,'ISHHI',''),UNSIGNED INTEGER)  DESC LIMIT 1)TransactionID,	( SELECT CONCAT(NAME,'/',bed_no)room FROM patient_ipd_profile pif INNER JOIN room_master rm ON pif.Room_ID=rm.Room_Id WHERE patientid=pm.`PatientID` AND STATUS ='IN')room ");
            if (ddlStatus.SelectedItem.Text == "Not Approved")
            {
                sb.Append(" ,lt.Date BookingDate,TIME_FORMAT(TIMEDIFF(NOW(),pli.SampleDate),'%H Hour %i min')PendingTime  ");

            }
            sb.Append(" ,'1' PendingAmount,");
            sb.Append(" IF(PLI.TestTAT<>0,IF(HOUR(TIMEDIFF(IFNULL(pli.ApprovedDate,NOW()),pli.SampleReceiveDate))>pli.TestTAT,'1','0'),'')IsDelay, ");
            sb.Append(" (SELECT IF(IFNULL(reading,'')='',FALSE,TRUE) FROM mac_data mac WHERE mac.Test_ID = pli.Test_ID  AND mac.LedgerTransactionNo=pli.LedgerTransactionNo AND Reading<>'' LIMIT 1)MacStatus,fpm.Company_Name Panel,pli.isPrint,IFNULL(pli.BarcodeNo,'')BarcodeNo ");
            sb.Append(" from patient_labinvestigation_opd PLI INNER JOIN f_ledgertransaction lt ON pli.LedgerTransactionNo=lt.LedgerTransactionNo inner join investigation_master IM on PLI.Investigation_ID=IM.Investigation_Id ");
            sb.Append(" INNER JOIN patient_medical_history pmh on PLI.TransactionID =pmh.TransactionID ");
            sb.Append(" INNER JOIN f_panel_master fpm ON fpm.PanelID=pmh.PanelID ");
            sb.Append(" INNER JOIN  patient_master PM on pmh.PatientID=PM.PatientID INNER JOIN investigation_observationtype io ON im.Investigation_Id = io.Investigation_ID INNER JOIN observationtype_master obm ON obm.ObservationType_ID=io.ObservationType_Id  ");
            sb.Append(" INNER JOIN f_ledgertnxDetail ltd on ltd.LedgerTransactionNo = lt.LedgertransactionNo ");
            sb.Append(" INNER JOIN f_ItemMaster imas on imas.ItemID = Ltd.ItemID and imas.Type_ID=im.Investigation_ID ");
            sb.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = obm.ObservationType_ID ");
            sb.Append(" where   ltd.IsVerified=1  ");



            if (!String.IsNullOrEmpty(txtBarCodeNo.Text))
            {

                if (ddlStatus.SelectedItem.Text == "Not Approved")
                {
                    sb.Append(" and pli.Result_Flag=1 and IFNULL(pli.Approved,0)=0 ");
                }
                else if (ddlStatus.SelectedItem.Text == "Result Not Done")
                {

                    sb.Append(" and pli.Result_Flag=0");

                }
                else {
                    sb.Append("  and IFNULL(pli.Approved,0)=0 ");
                }

              

                if (ddlDepartment.SelectedIndex > 0)
                {
                    sb.Append(" and io.ObservationType_ID='" + ddlDepartment.SelectedItem.Value + "'");
                }

                sb.Append(" and pli.BarcodeNo='" + txtBarCodeNo.Text.Trim() + "' ");
            }
            else
            {

                if (txtMRNo.Text != string.Empty)
                    sb.Append(" and PM.PatientID='" + txtMRNo.Text.Trim() + "'");
               
                if (ddlPanel.SelectedIndex > 0)
                    sb.Append(" AND fpm.PanelID='" + ddlPanel.SelectedValue + "' ");
                if (txtPName.Text != string.Empty)
                    sb.Append(" and PM.PName like '" + txtPName.Text.Trim() + "%'");
                if (ddlStatus.SelectedItem.Text == "Not Approved")
                {
                    if (FrmDate.Text != string.Empty)
                        sb.Append(" and PLI.Date >='" + Util.GetDateTime(FrmDate.Text).ToString("yyyy-MM-dd") + "'");

                    if (ToDate.Text != string.Empty)
                        sb.Append(" and PLI.Date <='" + Util.GetDateTime(ToDate.Text).ToString("yyyy-MM-dd") + "'");

                    sb.Append(" and pli.Result_Flag=1 and IFNULL(pli.Approved,0)=0 ");
                }
                else if (ddlStatus.SelectedItem.Text == "Result Not Done")
                {

                     if (FrmDate.Text != string.Empty)
                            sb.Append(" and PLI.Date >='" + Util.GetDateTime(FrmDate.Text).ToString("yyyy-MM-dd") + "'");

                        if (ToDate.Text != string.Empty)
                            sb.Append(" and PLI.Date <='" + Util.GetDateTime(ToDate.Text).ToString("yyyy-MM-dd") + "'");
                        sb.Append(" and pli.Result_Flag=0");

                }
                else
                {
                    if (FrmDate.Text != string.Empty)
                        sb.Append(" and PLI.Date >='" + Util.GetDateTime(FrmDate.Text).ToString("yyyy-MM-dd") + "'");

                    if (ToDate.Text != string.Empty)
                        sb.Append(" and PLI.Date <='" + Util.GetDateTime(ToDate.Text).ToString("yyyy-MM-dd") + "'");

                    sb.Append(" AND IFNULL(pli.Approved,0)=0 ");
                }
                if (txtLabNo.Text != string.Empty)
                {
                    if (rdbLabType.SelectedValue == "ALL")
                        sb.Append(" and ( PLI.LedgerTransactionNo=CONCAT(REPLACE(SUBSTRING('" + txtLabNo.Text.Trim() + "', 1, 1),'1','LOSHHI'),SUBSTRING('" + txtLabNo.Text.Trim() + "' FROM 2) ) OR PLI.LedgerTransactionNo=CONCAT(REPLACE(SUBSTRING('" + txtLabNo.Text.Trim() + "', 1, 1),'3','LISHHI'),SUBSTRING('" + txtLabNo.Text.Trim() + "' FROM 2) ) )  ");
                    else if (rdbLabType.SelectedValue == "IPD")
                        sb.Append(" and PLI.LedgerTransactionNo=CONCAT(REPLACE(SUBSTRING('" + txtLabNo.Text.Trim() + "', 1, 1),'3','LISHHI'),SUBSTRING('" + txtLabNo.Text.Trim() + "' FROM 2) )");
                    else
                        sb.Append(" and PLI.LedgerTransactionNo=CONCAT(REPLACE(SUBSTRING('" + txtLabNo.Text.Trim() + "', 1, 1),'1','LOSHHI'),SUBSTRING('" + txtLabNo.Text.Trim() + "' FROM 2) )");
                }
                if (txtCptcode.Text != string.Empty)
                    sb.Append(" and imas.ItemCode='" + txtCptcode.Text.Trim() + "'");

                //For Urgent (Start)
                if (ddlUrgent.SelectedValue != "2")
                {
                    sb.Append(" and pli.IsUrgent='" + ddlUrgent.SelectedValue + "'");
                }
                if (txtCRNo.Text != string.Empty)
                {
                    sb.Append(" and  pli.TransactionID like '%" + txtCRNo.Text.Trim() + "'");
                }

                if (ddlDepartment.SelectedIndex > 0)
                {
                    sb.Append(" and io.ObservationType_ID='" + ddlDepartment.SelectedItem.Value + "'");
                }
            }
            if (ddlPrintStatus.SelectedItem.Value != "2")
                sb.Append(" and pli.IsWorkSheetPrint=" + Util.GetInt(ddlPrintStatus.SelectedItem.Value) + " ");

            sb.Append(" )t group by t.ID order by t.ID ");
        }
        DataTable dtInvest = StockReports.GetDataTable(sb.ToString());
        return dtInvest;
    }
    #endregion
    protected void btnWorkSheet_Click(object sender, EventArgs e)
    {
        if (rdbLabType.SelectedIndex == 2)
        {
            lblMsg.Text = "Please Select OPD or IPD";
            return;
        }
        ViewState["Worksheet"] = null;
        int count = 0;
        string TestIdList = string.Empty;
        foreach (GridViewRow gr in grdLabSearch.Rows)
        {
            if ((((CheckBox)gr.FindControl("chkPrintWorksheet")) != null) && (((CheckBox)gr.FindControl("chkPrintWorksheet")).Checked))
            {
                string LabNo = ((ImageButton)gr.FindControl("imbPrint")).CommandArgument.ToString();
                if (String.IsNullOrEmpty(TestIdList))
                    TestIdList = "'" + LabNo.Split('#')[1].ToString().Trim() + "'";
                else
                    TestIdList += ",'" + LabNo.Split('#')[1].ToString().Trim() + "'";

                getWorksheet(LabNo.Split('#')[0], LabNo.Split('#')[1], LabNo.Split('#')[3]);
                count = 1;
            }
        }
        DataTable dtWorksheet = (DataTable)ViewState["Worksheet"];
        if (dtWorksheet != null)
        {
            do
            {
                getChildTest(dtWorksheet);
            }
            while (dtWorksheet.Select("isParent='1'", "").Length != 0);
        }

        dtWorksheet = (DataTable)ViewState["Worksheet"];


        if (dtWorksheet != null)
        {

            //  string PatientId = "";
            //  int ColumnLoc = 1;
            //for (int i = 0; i < dtWorksheet.Rows.Count; i++)
            //{
            //    string tempPatientId = Util.GetString(dtWorksheet.Rows[i]["LabNo"]);


                //if (tempPatientId != PatientId)
                //{
                //    PatientId = tempPatientId;
                //    ColumnLoc = 1;
                //    //i++;
                //}
                //else
                //{
                //    if (ColumnLoc == 1)
                //    {
                //        dtWorksheet.Rows[i - 1]["TestName3"] = Util.GetString(dtWorksheet.Rows[i]["TestName1"]);
                //        dtWorksheet.Rows[i - 1]["TestName4"] = Util.GetString(dtWorksheet.Rows[i]["TestName2"]);
                //        dtWorksheet.Rows[i].Delete();
                //        dtWorksheet.AcceptChanges();
                //        ColumnLoc = 2;
                //    }
                //    else
                //    {
                //        dtWorksheet.Rows[i - 1]["TestName3"] = Util.GetString(dtWorksheet.Rows[i]["TestName1"]);
                //        dtWorksheet.Rows[i - 1]["TestName4"] = Util.GetString(dtWorksheet.Rows[i]["TestName2"]);
                //        dtWorksheet.Rows[i].Delete();
                //        dtWorksheet.AcceptChanges();
                //        ColumnLoc = 1;
                //    }
                //}
           // }


            DataView view = dtWorksheet.DefaultView;
            view.Sort = "BarCodeNo,Department,PrintOrder ASC";
            dtWorksheet = view.ToTable();


            DataSet ds = new DataSet();
            ds.Tables.Add(dtWorksheet.Copy());
            ds.Tables[0].TableName = "Worksheet";
            //ds.WriteXmlSchema(@"E:\LabWorkSheet2.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "LabWorksheet2";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);

            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction();
            try
            {

                if (rdbLabType.SelectedItem.Value.ToUpper() == "OPD")
                {

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET IsWorkSheetPrint=1 WHERE Test_ID IN (" + TestIdList + ")");
                }
                else if (rdbLabType.SelectedItem.Value.ToUpper() == "IPD")
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET IsWorkSheetPrint=1 WHERE Test_ID IN (" + TestIdList + ")");

                }
                else
                {

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET IsWorkSheetPrint=1 WHERE Test_ID IN (" + TestIdList + ")");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET IsWorkSheetPrint=1 WHERE Test_ID IN (" + TestIdList + ")");

                }
                tnx.Commit();
                object s =new object();
                EventArgs eve=new EventArgs();
                btnSearch_Click(s,eve);
            }
            catch (Exception ex)
            {
                tnx.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);

            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }



            lblMsg.Text = "";
        }
        else
        {
            if (count == 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM046','" + lblMsg.ClientID + "');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM054','" + lblMsg.ClientID + "');", true);
            }

        }

    }

    private void getChildTest(DataTable dtWorksheet)
    {

        for (int i = 0; i < dtWorksheet.Rows.Count; i++)
        {

            DataRow dr = dtWorksheet.Rows[i];
            if (dr["isParent"].ToString() == "1")
            {
                DataTable dtTemp = new DataTable();
                StringBuilder sb = new StringBuilder();
                sb.Append(" SELECT * FROM labobservation_master WHERE Parentid='" + dr["InvestigationId"].ToString() + "'");
                dtTemp = StockReports.GetDataTable(sb.ToString());


                foreach (DataRow drChild in dtTemp.Rows)
                {
                    DataRow drWork = dtWorksheet.NewRow();
                    drWork["PatientID"] = dr["PatientID"].ToString();
                    drWork["PatientName"] = dr["PatientName"].ToString();
                    drWork["Age"] = dr["Age"].ToString();
                    drWork["Gender"] = dr["Gender"].ToString();
                    drWork["LabNo"] = dr["LabNo"].ToString();
                    drWork["Department"] = ddlDepartment.SelectedItem.Text;
                    drWork["ReportType"] = "1";
                    drWork["TestName1"] = drChild["Name"].ToString() + "(" + dr["TestName1"].ToString() + ")";
                    drWork["TestName2"] = drChild["ReadingFormat"].ToString();
                    drWork["isParent"] = "0";
                    drWork["InvestigationId"] = drChild["LabObservation_ID"].ToString();
                    dtWorksheet.Rows.Add(drWork);


                }
                dtWorksheet.Rows[i].Delete();
                dtWorksheet.AcceptChanges();
            }



        }
        ViewState["Worksheet"] = dtWorksheet;

    }

    private void getWorksheet(string LabNo, string TestId, string ReportType)
    {
        DataTable dtWorksheet = vs_getWorksheet();


        DataTable dtTest = getTest(LabNo, TestId, ReportType);

        if (dtTest != null)
        {
            if (ReportType == "3" || ReportType == "2")
            {
                DataRow drTest = dtTest.Rows[0];
                DataRow drWork = dtWorksheet.NewRow();
                drWork["PatientID"] = drTest["PatientID"].ToString();
                drWork["PatientName"] = drTest["PatientName"].ToString();
                drWork["Age"] = drTest["Age"].ToString();
                drWork["Gender"] = drTest["Gender"].ToString();
                drWork["LabNo"] = drTest["LabNo"].ToString();
                // drWork["Department"] = ddlDepartment.SelectedItem.Text;
                drWork["Department"] = drTest["Department"].ToString();
                drWork["PrintOrder"] = Util.GetInt(drTest["PrintOrder"].ToString());
                drWork["BarCodeNo"] = drTest["BarCodeNo"].ToString();
                drWork["ReportType"] = "2";
                drWork["TestName1"] = drTest["IName"].ToString();
                drWork["TestName2"] = "";
                drWork["isParent"] = "0";
                //drWork["InvestigationId"] = "";
                ////drWork["SampleDate"] = drTest["SampleDate"].ToString();
                //drWork["SampleDate"] = Util.GetDateTime(drTest["SampleDate"]).ToString("dd-MMM-yyyy hh:mm tt");
                //dtWorksheet.Rows.Add(drWork);
                //ViewState["Worksheet"] = dtWorksheet;
                drWork["InvestigationId"] = drTest["Investigation_ID"].ToString();
                //drWork["SampleDate"] = drTest["SampleDate"].ToString();
                drWork["SampleDate"] = Util.GetDateTime(drTest["SampleDate"]).ToString("dd-MMM-yyyy hh:mm tt");
                drWork["Investigation"] = drTest["Name"].ToString();
                drWork["Minimum"] = drTest["Minimum"].ToString();
                drWork["Maximum"] = drTest["Maximum"].ToString();
                OutputImg(drTest["BarCodeNo"].ToString());
                drWork["BarCode"] = GetBitmapBytes(objBitmap);
                dtWorksheet.Rows.Add(drWork);
                ViewState["Worksheet"] = dtWorksheet;
            }
            else if (ReportType == "5") {

                DataRow drTest = dtTest.Rows[0];
                DataRow drWork = dtWorksheet.NewRow();
                drWork["PatientID"] = drTest["PatientID"].ToString();
                drWork["PatientName"] = drTest["PatientName"].ToString();
                drWork["Age"] = drTest["Age"].ToString();
                drWork["Gender"] = drTest["Gender"].ToString();
                drWork["LabNo"] = drTest["LabNo"].ToString();
                // drWork["Department"] = ddlDepartment.SelectedItem.Text;
                drWork["Department"] = drTest["Department"].ToString();
                drWork["PrintOrder"] = Util.GetInt(drTest["PrintOrder"].ToString());
                drWork["BarCodeNo"] = drTest["BarCodeNo"].ToString();
                drWork["ReportType"] = "2";
                drWork["TestName1"] = drTest["IName"].ToString();
                drWork["TestName2"] = "";
                drWork["isParent"] = "0";
                drWork["InvestigationId"] = "";
                //drWork["SampleDate"] = drTest["SampleDate"].ToString();
                drWork["SampleDate"] = Util.GetDateTime(drTest["SampleDate"]).ToString("dd-MMM-yyyy hh:mm tt");
                dtWorksheet.Rows.Add(drWork);
                ViewState["Worksheet"] = dtWorksheet;
            


            }
            else if ((ReportType == "1" && (dtTest.Rows.Count > 0)))
            {

                for (int k = 0; k < dtTest.Rows.Count; k++)
                {
                    DataRow drTest = dtTest.Rows[k];
                    DataRow drWork = dtWorksheet.NewRow();
                    drWork["PatientID"] = drTest["PatientID"].ToString();
                    drWork["PatientName"] = drTest["PatientName"].ToString();
                    drWork["Age"] = drTest["Age"].ToString();
                    drWork["Gender"] = drTest["Gender"].ToString();
                    drWork["LabNo"] = drTest["LabNo"].ToString();
                    // drWork["Department"] = ddlDepartment.SelectedItem.Text;
                    drWork["Department"] = drTest["Department"].ToString();
                    drWork["PrintOrder"] = Util.GetInt(drTest["PrintOrder"].ToString());
                    drWork["BarCodeNo"] = drTest["BarCodeNo"].ToString();
                    drWork["ReportType"] = "1";
                    drWork["TestName1"] = drTest["obName"].ToString();
                    drWork["TestName2"] = drTest["ReadingFormat"].ToString();
                    drWork["isParent"] = drTest["Child_Flag"].ToString();
                    drWork["InvestigationId"] = drTest["Investigation_ID"].ToString();
                    //drWork["SampleDate"] = drTest["SampleDate"].ToString();
                    drWork["SampleDate"] = Util.GetDateTime(drTest["SampleDate"]).ToString("dd-MMM-yyyy hh:mm tt");
                    drWork["Investigation"] = drTest["Name"].ToString();
                    drWork["Minimum"] = drTest["Minimum"].ToString();
                    drWork["Maximum"] = drTest["Maximum"].ToString();
                    OutputImg(drTest["BarCodeNo"].ToString());
                    drWork["BarCode"] = GetBitmapBytes(objBitmap);
                    dtWorksheet.Rows.Add(drWork);
                    ViewState["Worksheet"] = dtWorksheet;
                }
            }

        }



    }

    private DataTable getTest(string LabNo, string TestId, string ReportType)
    {
        DataTable dtTest = new DataTable();


        if (rdbLabType.SelectedIndex == 0)
        {

            if (ReportType == "1")
            {

                StringBuilder sb = new StringBuilder();
                sb.Append("    SELECT pli.LabInvestigationOPD_ID AS LabInvestigation_ID,im.Name,pli.Investigation_ID,pli.ID PLIID,pli.Test_ID, ");
                sb.Append("    pli.Result_Flag,plo.Value,plo.ID,CASE WHEN pli.Approved IS NOT NULL THEN 'True' ELSE 'False' END AS Approved,  ");
                sb.Append("    pli.Investigation_ID,LOM.Name AS obName,LOM.LabObservation_ID, CASE WHEN 'MALE' = 'CHILD'  ");
                sb.Append("    THEN lom.MinChild WHEN 'MALE' = 'MALE' THEN lom.Minimum WHEN 'MALE' = 'FEMALE'  ");
                sb.Append("    THEN lom.MinFemale ELSE 0 END Minimum , CASE WHEN 'MALE' = 'CHILD' THEN lom.MaxChild  ");
                sb.Append("    WHEN 'MALE' = 'MALE' THEN lom.Maximum WHEN 'MALE' = 'FEMALE' THEN lom.MaxFemale ELSE 0 END  ");
                sb.Append("    Maximum ,lom.ReadingFormat,loi.Priorty ,Im.ReportType,lom.ParentID,lom.Child_Flag,");
                sb.Append("    CONCAT(pm.Title,' ',pm.PName) AS PatientName,pm.Age,pm.Gender,pli.LedgerTransactionNo AS LabNo,PM.PatientID,Date_Format(pli.SampleDate,'%d-%b-%y %l:%i %p')SampleDate ");
                sb.Append("     ,sb.Name 'Department',loi.printOrder 'PrintOrder',IFNULL(pli.Barcodeno,'') 'BarCodeNo' ");
                sb.Append("    FROM patient_labinvestigation_opd pli INNER JOIN investigation_master im  ");
                sb.Append("    ON pli.Investigation_ID=im.Investigation_Id  INNER JOIN labobservation_investigation loi  ");
                sb.Append("    ON im.Investigation_Id=loi.Investigation_Id  INNER JOIN  labobservation_master lom  ");
                sb.Append("    ON loi.labObservation_ID=lom.LabObservation_ID INNER JOIN patient_medical_history pmh ON pli.TransactionID=pmh.TransactionID INNER JOIN patient_master pm ON PM.PatientID=pmh.PatientID LEFT JOIN patient_labobservation_opd plo  ");
                sb.Append("    ON pli.Test_ID=plo.Test_ID AND plo.LabObservation_ID=LOM.LabObservation_ID  ");
                sb.Append("    INNER JOIN f_itemmaster imm ON imm.type_id=im.Investigation_ID ");
                sb.Append("    INNER JOIN f_subcategorymaster sb ON sb.Subcategoryid=imm.subcategoryid ");
                sb.Append("    INNER JOIN `f_configrelation` cf ON cf.categoryid=sb.categoryid AND cf.ConfigID=3 ");
                sb.Append("    WHERE pli.LedgerTransactionNo='" + LabNo + "' AND pli.Test_id='" + TestId + "'  AND im.ReportType=1 ORDER BY loi.printOrder  ");
                dtTest = StockReports.GetDataTable(sb.ToString());

            }
            else if (ReportType == "3" || ReportType == "2" || ReportType =="5")
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("     SELECT IF(pli.Approved=1,'false','true')Approved,ApprovedBy,pli.LabInvestigationOPD_ID AS LabInvestigation_ID,pli.ID,DATE_FORMAT(pli.Date,'%d-%b-%y')DATE,pli.Test_ID,pli.Result_Flag,  ");
                sb.Append("        pli.Investigation_ID,Im.Name AS IName,Im.ReportType,CONCAT(pm.Title,' ',pm.PName) AS PatientName,pm.Age,pm.Gender,pli.LedgerTransactionNo AS LabNo,PM.PatientID,DATE_FORMAT(pli.SampleDate,'%d-%b-%y %l:%i %p')SampleDate ");
                sb.Append(" ,sb.Name 'Department',1 'PrintOrder',IFNULL(pli.Barcodeno,'') 'BarCodeNo'   ");
                sb.Append("      FROM patient_labinvestigation_opd pli   ");
                sb.Append("        INNER JOIN investigation_master im ON pli.Investigation_ID=im.Investigation_Id INNER JOIN patient_medical_history pmh ON pli.TransactionID=pmh.TransactionID   ");
                sb.Append("        INNER JOIN patient_master pm ON PM.PatientID=pmh.PatientID    ");
                sb.Append("        INNER JOIN f_itemmaster imm ON imm.type_id=im.Investigation_ID ");
                sb.Append("        INNER JOIN f_subcategorymaster sb ON sb.Subcategoryid=imm.subcategoryid ");
                sb.Append("        INNER JOIN `f_configrelation` cf ON cf.categoryid=sb.categoryid AND cf.ConfigID=3 ");
                sb.Append("        WHERE pli.LedgerTransactionNo='" + LabNo + "' AND pli.Test_id='" + TestId + "' AND im.ReportType IN(2,3,5)  ");

                dtTest = StockReports.GetDataTable(sb.ToString());

            }

        }
        else if (rdbLabType.SelectedIndex == 1)
        {
            if (ReportType == "1")
            {

                StringBuilder sb = new StringBuilder();
                sb.Append("   SELECT pli.LabInvestigationIPD_ID AS LabInvestigation_ID,im.Name,pli.Investigation_ID,pli.ID PLIID,pli.Test_ID, ");
                sb.Append("   pli.Result_Flag,plo.Value,plo.ID,CASE WHEN pli.Approved IS NOT NULL THEN 'True' ELSE 'False' END AS Approved,  ");
                sb.Append("    pli.Investigation_ID,LOM.Name AS obName,LOM.LabObservation_ID, CASE WHEN 'MALE' = 'CHILD'  ");
                sb.Append("    THEN lom.MinChild WHEN 'MALE' = 'MALE' THEN lom.Minimum WHEN 'MALE' = 'FEMALE'  ");
                sb.Append("    THEN lom.MinFemale ELSE 0 END Minimum , CASE WHEN 'MALE' = 'CHILD' THEN lom.MaxChild  ");
                sb.Append("    WHEN 'MALE' = 'MALE' THEN lom.Maximum WHEN 'MALE' = 'FEMALE' THEN lom.MaxFemale ELSE 0 END  ");
                sb.Append("    Maximum ,lom.ReadingFormat,loi.Priorty ,Im.ReportType,lom.ParentID,lom.Child_Flag,CONCAT(pm.Title,' ',pm.PName) AS PatientName,pm.Age,pm.Gender,pli.LedgerTransactionNo AS LabNo,PM.PatientID,DATE_FORMAT(pli.SampleDate,'%d-%b-%y %l:%i %p')SampleDate ");
                sb.Append("     ,sb.Name 'Department',loi.printOrder 'PrintOrder',IFNULL(pli.Barcodeno,'') 'BarCodeNo' ");
                sb.Append("     FROM patient_labinvestigation_opd pli INNER JOIN investigation_master im  ");
                sb.Append("    ON pli.Investigation_ID=im.Investigation_Id  INNER JOIN labobservation_investigation loi  ");
                sb.Append("    ON im.Investigation_Id=loi.Investigation_Id  INNER JOIN  labobservation_master lom  ");
                sb.Append("    ON loi.labObservation_ID=lom.LabObservation_ID INNER JOIN patient_medical_history pmh ON pli.TransactionID=pmh.TransactionID INNER JOIN patient_master pm ON PM.PatientID=pmh.PatientID LEFT JOIN patient_labobservation_opd plo  ");
                sb.Append("    ON pli.Test_ID=plo.Test_ID AND plo.LabObservation_ID=LOM.LabObservation_ID  ");
                sb.Append("    INNER JOIN f_itemmaster imm ON imm.type_id=im.Investigation_ID ");
                sb.Append("    INNER JOIN f_subcategorymaster sb ON sb.Subcategoryid=imm.subcategoryid ");
                sb.Append("    INNER JOIN `f_configrelation` cf ON cf.categoryid=sb.categoryid AND cf.ConfigID=3 ");
                sb.Append("    WHERE pli.LedgerTransactionNo='" + LabNo + "' AND pli.Test_id='" + TestId + "'  AND im.ReportType=1 ORDER BY loi.printOrder  ");
                dtTest = StockReports.GetDataTable(sb.ToString());

            }
            else if (ReportType == "3" || ReportType == "2" || ReportType == "5")
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("     SELECT IF(pli.Approved=1,'false','true')Approved,ApprovedBy,pli.LabInvestigationIPD_ID AS LabInvestigation_ID,pli.ID,DATE_FORMAT(pli.Date,'%d-%b-%y')DATE,pli.Test_ID,pli.Result_Flag,  ");
                sb.Append("        pli.Investigation_ID,Im.Name AS IName,Im.ReportType,CONCAT(pm.Title,' ',pm.PName) AS PatientName,pm.Age,pm.Gender,pli.LedgerTransactionNo AS LabNo,PM.PatientID,DATE_FORMAT(pli.SampleDate,'%d-%b-%y %l:%i %p')SampleDate ");
                sb.Append(" ,sb.Name 'Department',1 'PrintOrder',IFNULL(pli.Barcodeno,'') 'BarCodeNo'   ");
                sb.Append("    FROM patient_labinvestigation_opd pli   ");
                sb.Append("        INNER JOIN investigation_master im ON pli.Investigation_ID=im.Investigation_Id INNER JOIN patient_medical_history pmh ON pli.TransactionID=pmh.TransactionID   ");
                sb.Append("        INNER JOIN patient_master pm ON PM.PatientID=pmh.PatientID    ");
               // sb.Append("        INNER JOIN patient_master pm ON PM.PatientID=pmh.PatientID    ");
                sb.Append("        INNER JOIN f_itemmaster imm ON imm.type_id=im.Investigation_ID ");
                sb.Append("        INNER JOIN f_subcategorymaster sb ON sb.Subcategoryid=imm.subcategoryid ");
                sb.Append("        INNER JOIN `f_configrelation` cf ON cf.categoryid=sb.categoryid AND cf.ConfigID=3 ");
                sb.Append("        WHERE pli.LedgerTransactionNo='" + LabNo + "' AND pli.Test_id='" + TestId + "' AND im.ReportType IN(2,3,5)  ");

                dtTest = StockReports.GetDataTable(sb.ToString());

            }
        }



        return dtTest;
    }
    private DataTable vs_getWorksheet()
    {
        DataTable dtWorksheet = (DataTable)ViewState["Worksheet"];
        if (dtWorksheet != null)
        {
            return dtWorksheet;
        }
        else
        {
            dtWorksheet = new DataTable();
            dtWorksheet.Columns.Add("PatientID");
            dtWorksheet.Columns.Add("PatientName");
            dtWorksheet.Columns.Add("Age");
            dtWorksheet.Columns.Add("Gender");
            dtWorksheet.Columns.Add("LabNo");
            dtWorksheet.Columns.Add("Department");
            dtWorksheet.Columns.Add("ReportType");
            dtWorksheet.Columns.Add("TestName1");
            dtWorksheet.Columns.Add("TestName2");
            dtWorksheet.Columns.Add("TestName3");
            dtWorksheet.Columns.Add("TestName4");
            dtWorksheet.Columns.Add("isParent");
            dtWorksheet.Columns.Add("InvestigationId");
            dtWorksheet.Columns.Add("SampleDate");
            dtWorksheet.Columns.Add("PrintOrder", typeof(int));
            dtWorksheet.Columns.Add("Investigation");
            dtWorksheet.Columns.Add("BarCodeNo");
            dtWorksheet.Columns.Add("Minimum");
            dtWorksheet.Columns.Add("Maximum");
            DataColumn BarCode = new DataColumn("BarCode");
            BarCode.DataType = System.Type.GetType("System.Byte[]");
            dtWorksheet.Columns.Add(BarCode);
            dtWorksheet.AcceptChanges();
            return dtWorksheet;

        }
    }


    private void OutputImg(string PatientID)
    {
        string FontName = "";
        System.Drawing.Graphics objGraphics;
        System.Drawing.Point p;

        //Response.ContentType = "image/Jpeg";
        Barcode MyBarcode = new Barcode();
        MyBarcode.BackColor = System.Drawing.ColorTranslator.FromHtml("#FFF");
        //     MyBarcode.BarColor = Color.Black;
        MyBarcode.CheckDigit = true;
        MyBarcode.CheckDigitToText = true;
        MyBarcode.Data = PatientID;
        MyBarcode.BarHeight = 1.0F;
        MyBarcode.NarrowBarWidth = 0.02F;
        MyBarcode.Orientation = MW6BarcodeASPNet.enumOrientation.or0;
        MyBarcode.SymbologyType = MW6BarcodeASPNet.enumSymbologyType.syCode128;
        MyBarcode.ShowText = false;
        MyBarcode.Wide2NarrowRatio = 0.5F;
        FontName = "Verdana, Arial, sans-serif";
        MyBarcode.TextFont = new System.Drawing.Font(FontName, 8.0F);
        MyBarcode.SetSize(200, 30);
        objBitmap = new System.Drawing.Bitmap(200, 30);
        objGraphics = System.Drawing.Graphics.FromImage(objBitmap);
        p = new System.Drawing.Point(0, 0);
        MyBarcode.Render(objGraphics, p);
        objGraphics.Flush();

        if (System.IO.File.Exists(Server.MapPath(@"~\Design\2.jpeg")))
        {
            System.IO.File.Delete(Server.MapPath(@"~\Design\2.jpeg"));
        }
    }
    private static byte[] GetBitmapBytes(System.Drawing.Bitmap Bitmap1)    //  getting Stream of Bar Code image
    {
        MemoryStream memStream = new MemoryStream();
        byte[] bytes;

        try
        {
            // Save the bitmap to the MemoryStream.
            Bitmap1.Save(memStream, System.Drawing.Imaging.ImageFormat.Jpeg);

            // Create the byte array.
            bytes = new byte[memStream.Length];

            // Rewind.
            memStream.Seek(0, SeekOrigin.Begin);

            // Read the MemoryStream to get the bitmap's bytes.
            memStream.Read(bytes, 0, bytes.Length);

            // Return the byte array.
            return bytes;
        }
        finally
        {
            // Cleanup.
            memStream.Close();
            memStream.Dispose();
        }
    }
}