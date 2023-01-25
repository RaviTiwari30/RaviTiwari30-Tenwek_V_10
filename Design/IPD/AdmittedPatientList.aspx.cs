using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.IO;
using System.Web;

public partial class Design_IPD_AdmittedPatientList : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //lstItems.Visible = false;
            BindPanelGroup();
            ViewState["UserID"] = Session["ID"].ToString();
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnSearch);
            LoadData(ddlReportType.SelectedValue, ddlPanelGroup.SelectedItem.Value);
        }
        lblMsg.Text = "";
    }

    private void BindPanelGroup()
    {
        DataTable dt = StockReports.GetDataTable("Select * from f_panelgroup where active=1 order by PanelGroup");

        ddlPanelGroup.DataSource = dt;
        ddlPanelGroup.DataTextField = "PanelGroup";
        ddlPanelGroup.DataValueField = "PanelGroup";
        ddlPanelGroup.DataBind();
        ddlPanelGroup.Items.Insert(0, new ListItem("ALL", "ALL"));
    }

    protected void ddlReportType_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadData(ddlReportType.SelectedValue,ddlPanelGroup.SelectedItem.Value);
        grdPatient.DataSource = null;
        grdPatient.DataBind();
        btnAdvaListReport.Visible = false;
        btnExportExcel.Visible = false;
    }

    private void LoadData(string ReportType,string PanelGroup)
    {
        DataTable dt = new DataTable();
        
        switch (ReportType)
        {
            case "1":               
                break;
            case "2":
                dt = EDPReports.GetBedCategory();                
                break;
            case "3":
                dt = EDPReports.GetConsultants();                
                break;
            case "4":                
                break;
            case "5":
                dt = EDPReports.GetDepartments();               
                break;
            case "6":
                dt = EDPReports.GetFloors();                
                break;
            case "7":
                if(PanelGroup.ToUpper() !="ALL")
                    dt = EDPReports.GetPanels(PanelGroup);
                else
                    dt = EDPReports.GetPanels();
                break;
        }

        if (dt.Rows.Count > 0)
        {
            //lstItems.Visible = true;
            lstItems.DataSource = dt;
            lstItems.DataTextField = "text";
            lstItems.DataValueField = "value";
            lstItems.DataBind();
        }
        else
        {
            lstItems.Items.Clear();
            //lstItems.Visible = false;
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        string ItemIDs = string.Empty;
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
            if (lstItems.Items != null && lstItems.Items.Count > 0)
                ItemIDs = StockReports.GetListSelection(lstItems);
            
                DataTable dtPatients = new DataTable();
                dtPatients = GetAdmittedPatients(ddlReportType.SelectedValue, ItemIDs);

                DataTable dtUser = new DataTable();
                dtUser = StockReports.GetUserName(Convert.ToString(Session["ID"]));

                DataColumn dc = new DataColumn();
                dc.ColumnName = "Period";
                dc.DefaultValue = "As On " + DateTime.Now.ToString("dd-MMM-yyyy");
                dtUser.Columns.Add(dc);

                dc = new DataColumn();
                dc.ColumnName = "ReportType";
                dc.DefaultValue = "1";
                dtUser.Columns.Add(dc);

                DataTable dtPatientCount = new DataTable();
                dtPatientCount = StockReports.GetDataTable("Select TotalCount,AdmitCount,(TotalCount-AdmitCount)Vacant from (Select count(*)TotalCount from room_master where IsActive=1 AND CentreID IN (" + Centre + "))t,(Select count(*)AdmitCount from patient_ipd_profile where status='IN' AND CentreID IN (" + Centre + "))t2");

                if (dtPatients.Rows.Count > 0)
                {
                    lblMsg.Text = "";
                    DataSet ds = new DataSet();
                    ds.Tables.Add(dtPatients.Copy());
                    ds.Tables[0].TableName = "Patients";
                    ds.Tables.Add(dtUser.Copy());
                    ds.Tables[1].TableName = "User";
                    ds.Tables.Add(dtPatientCount.Copy());
                    ds.Tables[2].TableName = "PatientCount";
                    DataTable dtImg = All_LoadData.CrystalReportLogo();
                    ds.Tables.Add(dtImg.Copy());

                    Session["EDPReport"] = ds;
                  //  ds.WriteXmlSchema(@"E:\anandOccupancy.xml");
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Reports/Forms/EDPReport.aspx?ReportType=AA" + ddlReportType.SelectedValue + "');", true);



                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);

                }
    }

    private DataTable GetAdmittedPatients(string ReportType, string ItemIDs)
    {
       
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return null;
        }
        lblMsg.Text = "";
        StringBuilder sb = new StringBuilder();
        sb.Append(" Select MRNo as PatientID,TransactionID,DateOfAdmit,TimeOfAdmit,DateOfDischarge,TimeOfDischarge,BedNo,Room_No,Floor,BedCategory,ConsultantName,AdmittedBy,TransNo,RoomName, ");
        if (ReportType == "5")
            sb.Append(" temp1.`CentreID`,temp1.`CentreName`,");
        else
            sb.Append(" t.`CentreID`,t.`CentreName`,");
        sb.Append(" PatientName,Age,Gender,Phone,Mobile,Company_Name,Source,Dept,DischargeStatus,Diagnosis,Remarks,  ");
        sb.Append(" BillAmt,Deposit,if(BillAmt-Deposit>0,(BillAmt-Deposit) + (1000-RIGHT((BillAmt-Deposit),3)),0)Balance,   ");
        sb.Append(" DoctorID,Approval,ActivityPlanned,TreatmentRemarks,(BillAmt-Deposit)BanlaneAmt from ( SELECT ip.PatientID MRNo,Replace(ip.TransactionID,'ISHHI','')TransactionID,");
        sb.Append(" date_format(PMH.DateOfAdmit,'%d-%b-%Y')DateOfAdmit,TIME_FORMAT(PMH.TimeOfAdmit,'%h:%i %p')TimeOfAdmit,cm.`CentreID`,cm.`CentreName`,date_format(PMH.DateOfDischarge,'%d-%b-%Y')DateOfDischarge,");
        sb.Append(" TIME_FORMAT(PMH.TimeOfDischarge,'%h:%i %p')TimeOfDischarge,rm.Bed_No AS BedNo,rm.Room_No,rm.Floor,ctm.Name AS BedCategory,CONCAT(dm.Title,' ',dm.Name)ConsultantName,");
        sb.Append(" CONCAT(pm.Title,' ',pm.PName)PatientName,pm.Age,pm.Gender,pm.Phone,pm.Mobile,pnl.Company_Name,PMH.Source,pmh.DoctorID,");
        sb.Append(" (select distinct(Department) from doctor_hospital where DoctorID = PMH.DoctorID)AS Dept,'' As DischargeStatus,");
        sb.Append(" (SELECT ProvisionalDiagnosis FROM cpoe_PatientDiagnosis where TransactionID=ip.TransactionID)Diagnosis,pmh.Remarks,");
        sb.Append(" (Round((select sum(ltd.NetItemAmt)  from f_ledgertnxdetail ltd where ");
        sb.Append(" TransactionID = ip.TransactionID and IsPackage = 0 and IsVerified = 1)) - IFNULL(pmh.DiscountOnBill,0)) AS BillAmt,");
        sb.Append(" Round((select IFNULL(sum(AmountPaid),0) from f_reciept where TransactionID = ip.TransactionID and IsCancel = 0))AS Deposit, ");
        sb.Append(" ROUND((SELECT IFNULL(SUM(Amount),0) FROM panel_amountallocation pa WHERE pa.TransactionID = ip.TransactionID ))AS Approval ");
        sb.Append(" ,pmh.ActivityPlanned,pmh.TreatmentRemarks ");
        sb.Append(" ,(SELECT CONCAT(em.Title,'',em.Name) AdmittedBy FROM employee_master em WHERE em.EmployeeID=pmh.UserID LIMIT 1)AdmittedBy,pmh.TransNo,rm.`NAME` AS RoomName ");
        sb.Append(" FROM patient_ipd_profile ip INNER JOIN patient_medical_history PMH ON IP.TransactionID = PMH.TransactionID INNER JOIN center_master cm ON cm.`CentreID`=pmh.`CentreID` ");//INNER JOIN ipd_case_history ich ON ip.TransactionID = ich.TransactionID
        sb.Append(" INNER JOIN room_master rm ON rm.RoomId = ip.RoomID INNER join floor_master fm on fm.Name=rm.Floor INNER JOIN ipd_case_type_master ctm ON ctm.IPDCaseTypeID = rm.IPDCaseTypeID ");
        sb.Append(" INNER JOIN doctor_master dm ON dm.DoctorID = PMH.DoctorID INNER JOIN patient_master pm ON pm.PatientID = ip.PatientID");
        sb.Append(" INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID  WHERE ip.Status = 'IN' AND pmh.CentreID IN (" + Centre + ")  ");//INNER JOIN f_ipdadjustment adj on adj.TransactionID=ich.TransactionID

        if (ddlPanelGroup.SelectedValue != "ALL")
            sb.Append(" and pnl.PanelGroup='" + ddlPanelGroup.SelectedItem.Text + "'");

        string str = string.Empty;

        switch (ReportType)
        {
            case "1":
                str = sb.ToString();
                break;
            case "2":
                if (ItemIDs != string.Empty)
                    str = sb.ToString() + " AND rm.IPDCaseTypeID IN (" + ItemIDs + ")";
                else
                    str = sb.ToString();
                break;
            case "3":
                if (ItemIDs != string.Empty)
                    str = sb.ToString() + " AND pmh.DoctorID IN (" + ItemIDs + ")";//
                else
                    str = sb.ToString();
                break;
            case "4":
                str = sb.ToString();
                break;
            case "5":
                if (ItemIDs != string.Empty)
                    str = " SELECT * FROM ( " + sb.ToString() + " )temp1 WHERE Dept IN (" + ItemIDs + ")";
                else
                    str = sb.ToString();
                break;
            case "6":
                if (ItemIDs != string.Empty)
                    str = sb.ToString() + " AND rm.Floor IN (" + ItemIDs + ")";
                else
                    str = sb.ToString();
                break;
            case "7":
                if (ItemIDs != string.Empty)
                    str = sb.ToString() + " AND pmh.PanelID IN (" + ItemIDs + ")";
                else
                    str = sb.ToString();
                break;
        }

      
        str += " Order by fm.SequenceNo ";

        str += ")t";

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);
        return dt;
    }
    
    protected void ddlPanelGroup_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlReportType.SelectedValue == "7")
        {
            DataTable dt = new DataTable();
            if (ddlPanelGroup.SelectedItem.Value.ToUpper() != "ALL")
                dt = EDPReports.GetPanels(ddlPanelGroup.SelectedItem.Value);
            else
                dt = EDPReports.GetPanels();


            if (dt.Rows.Count > 0)
            {
               // lstItems.Visible = true;
                lstItems.DataSource = dt;
                lstItems.DataTextField = "text";
                lstItems.DataValueField = "value";
                lstItems.DataBind();
            }
            else
            {
                lstItems.Items.Clear();
               // lstItems.Visible = false;
            }

            grdPatient.DataSource = null;
            grdPatient.DataBind();
            btnAdvaListReport.Visible = false;
            btnExportExcel.Visible = false;
        }
    }
    
    protected void btnShow_Click(object sender, EventArgs e)
    {
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        else
        {
            grdPatient.DataSource = null;
            grdPatient.DataBind();
            btnAdvaListReport.Visible = false;
            btnExportExcel.Visible = false;
            string ItemIDs = string.Empty;
            if (lstItems.Visible)
                ItemIDs = StockReports.GetListSelection(lstItems);

            DataTable dtPatients = new DataTable();
            if (ItemIDs != "")
            {
                dtPatients = GetAdmittedPatients(ddlReportType.SelectedValue, ItemIDs);
                if (dtPatients.Rows.Count > 0 || dtPatients != null)
                {
                    grdPatient.DataSource = dtPatients;
                    grdPatient.DataBind();
                    btnAdvaListReport.Visible = true;
                    btnExportExcel.Visible = true;
                }
                btnSendSMS.Visible = false;
                ViewState["dtPatients"] = dtPatients;
            }
            else
            {
                lblMsg.Text = "Please Select Item";
            }
        }
    }
    protected void btnAdvaListReport_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            if (grdPatient != null && grdPatient.Rows.Count > 0)
            {
                DataTable dtPatients = ((DataTable)ViewState["dtPatients"]);

                foreach (GridViewRow grow in grdPatient.Rows)
                {
                    string str = "Update Patient_medical_history Set FeesPaid=" + Util.GetDecimal(((TextBox)grow.FindControl("txtBal")).Text) + ",";
                    str += "Remarks='" + Util.GetString(((TextBox)grow.FindControl("txtRemarks")).Text) + "' ";
                    str += "Where TransactionID='" + Util.GetString(((Label)grow.FindControl("lblTransactionID")).Text) + "' "; //ISHHI
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str);

                    str = "Insert into f_IPDAdvanceListDetails(TransactionID,AdvAmount,Remarks,UserID) ";
                    str += "values('" + Util.GetString(((Label)grow.FindControl("lblTransactionID")).Text) + "',";//ISHHI
                    str += "AdvAmount=" + Util.GetDecimal(((TextBox)grow.FindControl("txtBal")).Text) + ", ";
                    str += "Remarks='" + Util.GetString(((TextBox)grow.FindControl("txtRemarks")).Text) + "', ";
                    str += "UserID='" + ViewState["UserID"].ToString() + "') ";
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str);

                    DataRow[] dr = dtPatients.Select("TransactionID='" + Util.GetString(((Label)grow.FindControl("lblTransactionID")).Text) + "'");

                    if (dr.Length > 0)
                    {
                        dr[0]["Balance"] = Util.GetDecimal(((TextBox)grow.FindControl("txtBal")).Text).ToString();
                        dr[0]["Remarks"] = Util.GetString(((TextBox)grow.FindControl("txtRemarks")).Text);
                    }
                }

                dtPatients.AcceptChanges();
                tranX.Commit();


                //===================== REPORTING PART ===================================================

                DataTable dtUser = new DataTable();
                dtUser = StockReports.GetUserName(Convert.ToString(Session["ID"]));

                DataColumn dc = new DataColumn();
                dc.ColumnName = "Period";
                dc.DefaultValue = "As On " + DateTime.Now.ToString("dd-MMM-yyyy");
                dtUser.Columns.Add(dc);

                dc = new DataColumn();
                dc.ColumnName = "ReportType";
                dc.DefaultValue = "1";
                dtUser.Columns.Add(dc);

                DataTable dtPatientCount = new DataTable();
                dtPatientCount = StockReports.GetDataTable("Select TotalCount,AdmitCount,(TotalCount-AdmitCount)Vacant from (Select count(*)TotalCount from room_master where IsActive=1)t,(Select count(*)AdmitCount from patient_ipd_profile where status='IN')t2");

                DataSet ds = new DataSet();
                ds.Tables.Add(dtPatients.Copy());
                ds.Tables[0].TableName = "Patients";
                ds.Tables.Add(dtUser.Copy());
                ds.Tables[1].TableName = "User";
                ds.Tables.Add(dtPatientCount.Copy());
                ds.Tables[2].TableName = "PatientCount";

                Session["EDPReport"] = ds;
                //ds.WriteXmlSchema(@"e:\anandOccupancy.xml");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Reports/Forms/EDPReport.aspx?ReportType=AA8');", true);

                //========================================================================================
            }
        }
        catch (Exception ex)
        {
            tranX.Rollback();

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnPatList_Click(object sender, EventArgs e)
    {


        string ItemIDs = string.Empty;

        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        if (lstItems.Items != null && lstItems.Items.Count > 0)
            ItemIDs = StockReports.GetListSelection(lstItems);

        DataTable dtPatients = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append(" Select MRNo as PatientID,IPDNo as TransactionID,DateOfAdmit,TimeOfAdmit,DateOfDischarge,TimeOfDischarge,BedNo,Floor,BedCategory,DoctorName as ConsultantName,");
        sb.Append(" PatientName,Age,Gender,Mobile,Company_Name,Source,Dept,DischargeStatus,Diagnosis,Remarks,  ");


        sb.Append(" Approval,ActivityPlanned,TreatmentRemarks,CentreID,CentreName from ( SELECT pmh.PatientID MRNo,Replace(ip.TransactionID,'ISHHI','')IPDNo,");
        sb.Append(" DATE_FORMAT(pmh.DateOfAdmit,'%d-%b-%Y')DateOfAdmit,TIME_FORMAT(pmh.TimeOfAdmit,'%h:%i %p')TimeOfAdmit,DATE_FORMAT(pmh.DateOfDischarge,'%d-%b-%Y')DateOfDischarge,");
        sb.Append(" TIME_FORMAT(pmh.TimeOfDischarge,'%h:%i %p')TimeOfDischarge,rm.Bed_No AS BedNo,rm.Floor,ctm.Name AS BedCategory,CONCAT(dm.Title,' ',dm.Name)DoctorName,");
        sb.Append(" CONCAT(pm.Title,' ',pm.PName)PatientName,pm.Age,pm.Gender,pm.Mobile,pnl.Company_Name,PMH.Source,");
        sb.Append(" (select distinct(Department) from doctor_hospital where DoctorID = pmh.DoctorID)AS Dept,'' As DischargeStatus,");
        sb.Append(" (SELECT ProvisionalDiagnosis FROM cpoe_PatientDiagnosis where TransactionID=ip.TransactionID)Diagnosis,pmh.Remarks,");
        sb.Append(" (Round((select sum(ltd.NetItemAmt)  from f_ledgertnxdetail ltd where ");
        sb.Append(" TransactionID = ip.TransactionID and IsPackage = 0 and IsVerified = 1)) - IFNULL(pmh.DiscountOnBill,0)) AS BillAmt,");
        sb.Append(" Round((select IFNULL(sum(AmountPaid),0) from f_reciept where TransactionID = ip.TransactionID and IsCancel = 0))AS Deposit, ");
        sb.Append(" ROUND((SELECT IFNULL(SUM(Amount),0) FROM panel_amountallocation pa WHERE pa.TransactionID = ip.TransactionID ))AS Approval ");
        sb.Append(" ,pmh.ActivityPlanned,pmh.TreatmentRemarks,cm.`CentreID`,cm.`CentreName` ");
        sb.Append(" FROM patient_ipd_profile ip INNER JOIN patient_medical_history PMH ON IP.TransactionID = PMH.TransactionID INNER JOIN center_master cm ON cm.`CentreID`=pmh.`CentreID` ");//INNER JOIN ipd_case_history ich ON ip.TransactionID = ich.TransactionID
        sb.Append(" INNER JOIN room_master rm ON rm.RoomId = ip.RoomID INNER JOIN ipd_case_type_master ctm ON ctm.IPDCaseTypeID = rm.IPDCaseTypeID ");
        sb.Append(" INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID INNER JOIN patient_master pm ON pm.PatientID = ip.PatientID");
        sb.Append(" INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID   WHERE ip.Status = 'IN' AND pmh.CentreID IN (" + Centre + ") "); //INNER JOIN f_ipdadjustment adj ON adj.TransactionID=ich.TransactionID

        if (ddlPanelGroup.SelectedValue != "ALL")
            sb.Append(" and pnl.PanelGroup='" + ddlPanelGroup.SelectedItem.Text + "'");

        string str = string.Empty;

        switch (ddlReportType.SelectedValue)
        {
            case "1":
                str = sb.ToString();
                break;
            case "2":
                if (ItemIDs != string.Empty)
                    str = sb.ToString() + " AND rm.IPDCaseTypeID IN (" + ItemIDs + ")";
                else
                    str = sb.ToString();
                break;
            case "3":
                if (ItemIDs != string.Empty)
                    str = sb.ToString() + " AND pmh.DoctorID IN (" + ItemIDs + ")";//
                else
                    str = sb.ToString();
                break;
            case "4":
                str = sb.ToString();
                break;
            case "5":
                if (ItemIDs != string.Empty)
                    str = " SELECT * FROM ( " + sb.ToString() + " )temp1 WHERE Dept IN (" + ItemIDs + ")";
                else
                    str = sb.ToString();
                break;
            case "6":
                if (ItemIDs != string.Empty)
                    str = sb.ToString() + " AND rm.Floor IN (" + ItemIDs + ")";
                else
                    str = sb.ToString();
                break;
            case "7":
                if (ItemIDs != string.Empty)
                    str = sb.ToString() + " AND pmh.PanelID IN (" + ItemIDs + ")";
                else
                    str = sb.ToString();
                break;
        }

       
            str += " Order by BedCategory,BedNo";

        str += ")t";

        dtPatients = StockReports.GetDataTable(str);

        DataTable dtUser = new DataTable();
        dtUser = StockReports.GetUserName(Convert.ToString(Session["ID"]));

        DataColumn dc = new DataColumn();
        dc.ColumnName = "Period";
        dc.DefaultValue = "As On " + DateTime.Now.ToString("dd-MMM-yyyy");
        dtUser.Columns.Add(dc);

        dc = new DataColumn();
        dc.ColumnName = "ReportType";
        dc.DefaultValue = "1";
        dtUser.Columns.Add(dc);

        DataTable dtPatientCount = new DataTable();
        dtPatientCount = StockReports.GetDataTable("Select TotalCount,AdmitCount,(TotalCount-AdmitCount)Vacant from (Select count(*)TotalCount from room_master where IsActive=1)t,(Select count(*)AdmitCount from patient_ipd_profile where status='IN')t2");

        if (dtPatients.Rows.Count > 0)
        {

            DataSet ds = new DataSet();
            ds.Tables.Add(dtPatients.Copy());
            ds.Tables[0].TableName = "Patients";
            ds.Tables.Add(dtUser.Copy());
            ds.Tables[1].TableName = "User";
            ds.Tables.Add(dtPatientCount.Copy());
            ds.Tables[2].TableName = "PatientCount";
            DataTable dtImg = All_LoadData.CrystalReportLogo();
            ds.Tables.Add(dtImg.Copy());

            Session["EDPReport"] = ds;
//            ds.WriteXmlSchema(@"e:\anandPatList.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Reports/Forms/EDPReport.aspx?ReportType=PAA" + ddlReportType.SelectedValue + "');", true);

        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);

        }
            
    }
    protected void grdPatient_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "SendSMS")
        {
            string Detail = Util.GetString(e.CommandArgument);
            string[] Values = Detail.Split('#');

            string TID = Util.GetString(Values[0]);
            string PatientName = Util.GetString(Values[1]);
            string KinPhone = Util.GetString(Values[2]);
            string Gender = Util.GetString(Values[3]);
            string Age = Util.GetString(Values[4]);
            string PatientID = Util.GetString(Values[5]);
            string DoctorID = Util.GetString(Values[6]);

           
        }
    }

    private int SendSms(string TID,string Mobile,string Age,string Gender,string PatientName,string PID,string DID)
    {
        string Msg = "";
        int IsSend = 0;

        if (Mobile != string.Empty)
        {

            if (Mobile.Contains("/") == true)
            {
                string[] MobNos = Mobile.Split('/');

                foreach (string Nos in MobNos)
                {
                    Msg = "Dear Attendant,The bill of your Patient " + PatientName + " ( " + Gender + " ) - " + Age + " has crossed permissible limits Please contact Billing Desk urgently";

                    bool Send = StockReports.ExecuteDML("INSERT INTO sms(MOBILE_NO,SMS_TEXT,UserID,DoctorID,TransactionID,PatientID)values('" + Nos + "','" + Msg + "','" + Session["ID"].ToString() + "','" + DID + "','" + TID + "','" + PID + "')");

                    if (Send)
                        IsSend = 1;
                }
            }
            else
            {
                if (Mobile.Length >= 10 && Mobile.Length <= 11)
                {
                    Msg = "Dear Attendant,The bill of your Patient " + PatientName + " ( " + Gender + " ) - " + Age + " has crossed permissible limits Please contact Billing Desk urgently";

                    bool Send = StockReports.ExecuteDML("INSERT INTO sms(MOBILE_NO,SMS_TEXT,UserID,DoctorID,TransactionID,PatientID)values('" + Mobile + "','" + Msg + "','" + Session["ID"].ToString() + "','" + DID + "','" + TID + "','" + PID + "')");

                    if (Send)
                        IsSend = 1;
                }
            }
        }

        return IsSend;
    }

    protected void btnSendSMS_Click(object sender, EventArgs e)
    {
        int IsSelected = 0;
        int IsSend = 0;
        foreach (GridViewRow grv in grdPatient.Rows)
        {
            CheckBox chk = ((CheckBox)grv.FindControl("chkSelect"));

            if (chk.Checked)
            {
                IsSelected = 1;
                string TID = "ISHHI"+((Label)grv.FindControl("lblTransactionID")).Text;
                string PatientName = ((Label)grv.FindControl("lblPName1")).Text;
                string KinPhone = ((Label)grv.FindControl("lblKinPhone")).Text;
                string Gender = ((Label)grv.FindControl("lblGender")).Text;
                string Age = ((Label)grv.FindControl("lblAge1")).Text;
                string PatientID = "LSHHI"+((Label)grv.FindControl("lblMRNo")).Text;
                string DoctorID = ((Label)grv.FindControl("lblDoctorID")).Text;

                if (KinPhone != "")
                    IsSend = SendSms(TID, KinPhone, Age, Gender, PatientName, PatientID, DoctorID);

                if (IsSend == 1)
                {
                    lblMsg.Text = "Msg Sent....";
                    chk.Checked = false;
                }
            }
        }

        if (IsSelected == 0)
        {
            lblMsg.Text = "Please select patient to send sms";
        }

    }
    protected void btnExportExcel_Click(object sender, EventArgs e)
    {
        Response.Clear();
        Response.Buffer = true;
        Response.ClearContent();
        Response.ClearHeaders();
        Response.Charset = "";
        string FileName = DateTime.Now.ToString("dd-MM-yyyy") + ".xls";
        StringWriter strwritter = new StringWriter();
        HtmlTextWriter htmltextwrtter = new HtmlTextWriter(strwritter);
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        Response.ContentType = "application/vnd.ms-excel";
        Response.AddHeader("Content-Disposition", "attachment;filename=" + FileName);
        grdPatient.GridLines = GridLines.Both;
        grdPatient.HeaderStyle.Font.Bold = true;

        foreach (GridViewRow row in grdPatient.Rows)
        {
           // grdPatient.Columns[13].Visible = false;
            grdPatient.Columns[14].Visible = false;
        }
        grdPatient.RenderControl(htmltextwrtter);
        Response.Write(strwritter.ToString());
        Response.End();


    }
        
    

    public override void VerifyRenderingInServerForm(Control control)
    {

    }
    
}
