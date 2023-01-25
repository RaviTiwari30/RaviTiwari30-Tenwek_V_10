using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
public partial class Design_OPD_ReSearch : System.Web.UI.Page
{
    
    string FormId = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtConfirmDateFrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtConfirmdateTo.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ViewState["UserID"] = Session["ID"].ToString();

        }
        txtConfirmDateFrom.Attributes.Add("readOnly", "true");
        txtConfirmdateTo.Attributes.Add("readOnly", "true");
    }
    protected void Search()
    {
        DataTable dtSearch = AllLoadData_OPD.SearchConfirm(Util.GetDateTime(txtConfirmDateFrom.Text), Util.GetDateTime(txtConfirmdateTo.Text));
        if (dtSearch != null && dtSearch.Rows.Count > 0)
        {
            lblMsg.Text = "";
            grdAppointment.DataSource = dtSearch;
            grdAppointment.DataBind();
        }
        else
        {
            grdAppointment.DataSource = "";
            grdAppointment.DataBind();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }
    }
    protected void grdAppointment_RowCommand(object sender, GridViewCommandEventArgs e)
    {


        if (e.CommandName.ToString() == "btnPrint")
        {
            lblPatientID.Text = e.CommandArgument.ToString().Split('#')[0];
            lblTnxID.Text = e.CommandArgument.ToString().Split('#')[1];
            lblAppID.Text = e.CommandArgument.ToString().Split('#')[2];
            lblTID.Text = e.CommandArgument.ToString().Split('#')[3];
            lblPopupMsg.Text = "";
            string str = "SELECT rm.Formid,formname,rmd.Name,rmd.ID,rmd.IsLink,rmd.Url FROM research_master rm INNER JOIN research_master_detail rmd ON rmd.formid=rm.FormID    WHERE isresearch=0  AND rm.isactive=1 AND rmd.isactive=1" +
                " UNION ALL " +
                " SELECT rm.Formid, Rm.FormName,rmd.name,rmd.ID,rmd.IsLink,rmd.Url  FROM appointment  app  INNER JOIN patient_researchdetail pr ON app.App_id=pr.AppID" +
                "  LEFT JOIN research_master RM ON pr.ResearchID=rm.FormID   INNER JOIN research_master_detail rmd ON rmd.formid=rm.FormID       WHERE app.App_ID='" + lblAppID.Text + "' AND rm.isactive=1 AND rmd.isactive=1";
            DataTable dt = StockReports.GetDataTable(str);
            if (dt.Rows.Count > 0)
            {
                repResearch.DataSource = dt;
                repResearch.DataBind();
                if (dt.Rows.Count <= 5)
                {
                    pnlPrint.ScrollBars = ScrollBars.None;
                    pnlPrint.Height = 200;
                }
                else if (dt.Rows.Count >= 9)
                {
                    pnlPrint.ScrollBars = ScrollBars.Vertical;
                    pnlPrint.Height = 400;
                }
                else
                {
                    pnlPrint.ScrollBars = ScrollBars.None;
                    pnlPrint.Height = 320;
                }
            }
            mpClose.Show();

        }
        if (e.CommandName.ToString() == "btnResearch")
        {

            lblapp_id.Text = e.CommandArgument.ToString().Split('#')[0];
            DataTable dt = new DataTable();
            string str = "SELECT ResearchID,ResearchName FROM patient_researchdetail WHERE AppID='" + lblapp_id.Text + "'";
            dt = StockReports.GetDataTable(str);
            if (dt != null && dt.Rows.Count > 0)
            {
                //chklstRe.DataSource = dt;
                //chklstRe.DataTextField = "ResearchName";
                //chklstRe.DataValueField = "ResearchId";
                //chklstRe.DataBind();
                //for (int i = 0; i < chklstRe.Items.Count; i++)
                //{
                //    chklstRe.Items[i].Selected = true;
                //}
            }
            else
            {
                //chklstRe.DataSource = "";
                //chklstRe.DataBind();
                //lblmsgs.Text = "No Research";
                //btnPrint2.Enabled = false;


            }
            mpResearch.Show();
        }
    }
    protected void repResearch_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            int rowindex = e.Item.ItemIndex;
            if ((rowindex % 2) == 0)
            {
                //repResearch.Items[rowindex].
            }
        }
    }
    protected void btnConfirmSearch_Click(object sender, EventArgs e)
    {
        Search();
    }
    protected void grdAppointment_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex > -1)
        {
            if (((Label)e.Row.FindControl("lblPatientID")).Text != "")
            {
                //((Button)e.Row.FindControl("btnRegistration")).Enabled = false;
                //((Button)e.Row.FindControl("btnPayment")).Enabled = true;
                e.Row.BackColor = System.Drawing.Color.LimeGreen;
            }
            if (((Label)e.Row.FindControl("lblLedgerTnxNo")).Text == "")
            {
                ((Button)e.Row.FindControl("btnPrint")).Enabled = false;


            }
        }

    }
    protected void btnPrint_Click(object sender, EventArgs e)
    {

    }

    private void BindRegForm()
    {

        string str = "SELECT CONCAT(pm.Title,' ',pm.Pname)Pname,pm.Occupation,pm.Age,IF(pm.DOB ='0001-01-01','',DATE_FORMAT(pm.DOB,'%d-%b-%Y'))DOB,pm.SpouseName,pm.PlaceOfBirth,pm.House_No,pm.Email,pm.ResidentialAddress " +
                    " ,pm.Phone,pm.mobile,pm.Country,pm.Gender,IFNULL(pm.MaritalStatus,'')MaritalStatus,IFNULL(pm.ReligiousAffiliation,'')ReligiousAffiliation,IFNULL(pm.LanguageSpoken,'')LanguageSpoken,IFNULL(pm.Employer,'')Employer, " +
                    " pm.EmergencyNotify,pm.EmergencyAddress,pm.EmergencyRelationShip,pm.EmergencyPhoneNo,pmh.Purpose,(SELECT CONCAT(Title,' ',NAME)NAME FROM doctor_master WHERE DoctorID=pmh.DoctorID)DoctorID,if(pmh.workrelatedinjury=0,'NO','Yes')workrelatedinjury, " +
                    " IF(pmh.workrelatedinjury=0,'',pmh.Dateworkrelatedinjury)Dateworkrelatedinjury,if(pmh.autorelatedinjury=0,'NO','Yes')autorelatedinjury, " +
                    " IF(pmh.autorelatedinjury=0,'',Dateautorelatedinjury)Dateautorelatedinjury,IFNULL(pmh.companyMedicalRepresentive,'')companyMedicalRepresentive, " +
                    " if(pmh.MedicalInsuranceCoveredEmployer=0,'No','Yes')MedicalInsuranceCoveredEmployer, " +
                    "    IF(DateLegalRepresenativeSignature='0001-01-01','',DATE_FORMAT(DateLegalRepresenativeSignature,'%d-%b-%Y'))DateLegalRepresenativeSignature, " +
                    " IFNULL(pmh.LegalRepresenativeSignature,'')LegalRepresenativeSignature FROM patient_master pm  " +
                    " INNER JOIN f_ledgertransaction lt ON lt.PatientID = pm.PatientID " +
                    " INNER JOIN patient_medical_history pmh ON lt.TransactionID = pmh.TransactionID WHERE pm.PatientID='" + lblPatientID.Text + "' AND lt.LedgerTransactionNo='" + lblTnxID.Text + "'  " +
                    " ORDER BY pmh.EntryDate LIMIT 1 ";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            dt.TableName = "PrintRegFrm";
            DataColumn dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
            dt.Columns.Add(dc);
            DataSet ds = new DataSet();
            DataTable dtImg = All_LoadData.CrystalReportLogo();
            ds.Tables.Add(dtImg.Copy());
            ds.Tables.Add(dt.Copy());
          //  ds.WriteXmlSchema("d:\\PrintRegForm.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "PatientRegistrationForm";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "DisplayMsg('MM04','" + lblPopupMsg.ClientID + "');", true);
        }
    }
    private void bindPatientConsentForm()
    {
        string str1 = "SELECT CONCAT(Title,' ',Pname)pname,PatientID  FROM patient_master WHERE PatientID='" + lblPatientID.Text + "'";
        DataTable dt1 = StockReports.GetDataTable(str1);
        if (dt1.Rows.Count > 0)
        {
            dt1.TableName = "GenralPcf";
            DataColumn dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
            dt1.Columns.Add(dc);
            DataSet ds = new DataSet();
            DataTable dtImg = All_LoadData.CrystalReportLogo();
            ds.Tables.Add(dtImg.Copy());
            ds.Tables.Add(dt1.Copy());
          //  ds.WriteXmlSchema("d:\\GenralPcf.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "GeneralConsentForm";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key3", "window.open('../../Design/common/Commonreport.aspx');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key4", "DisplayMsg('MM04','" + lblPopupMsg.ClientID + "');", true);
        }
    }
    private void bindPhysicalConsentForm()
    {
        string str1 = "SELECT CONCAT(Title,' ',Pname)pname,PatientID  FROM patient_master WHERE PatientID='" + lblPatientID.Text + "'";
        DataTable dt1 = StockReports.GetDataTable(str1);
        if (dt1.Rows.Count > 0)
        {
            dt1.TableName = "GenralPcf";
            DataColumn dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
            dt1.Columns.Add(dc);
            DataSet ds = new DataSet();
            DataTable dtImg = All_LoadData.CrystalReportLogo();
            ds.Tables.Add(dtImg.Copy());
            ds.Tables.Add(dt1.Copy());
            ds.WriteXmlSchema("d:\\PhysicalTherapy.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "PhysicalTherapy";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key15", "window.open('../../Design/common/Commonreport.aspx');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key4", "DisplayMsg('MM04','" + lblPopupMsg.ClientID + "');", true);
        }
    }
    private void bindGeneralConsent()
    {
        string str2 = "SELECT PName,PatientID,EmergencyRelationShip FROM patient_master WHERE PatientID='" + lblPatientID.Text + "'";
        DataTable dt2 = StockReports.GetDataTable(str2);
        if (dt2.Rows.Count > 0)
        {
            dt2.TableName = "GenralCPFT";
            DataColumn dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
            dt2.Columns.Add(dc);
            DataSet ds = new DataSet();
            DataTable dtImg = All_LoadData.CrystalReportLogo();
            ds.Tables.Add(dtImg.Copy());
            ds.Tables.Add(dt2.Copy());
           // ds.WriteXmlSchema("d:\\GenralCPFT.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "GeneralConsentForm_1";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key5", "window.open('../../Design/common/Commonreport.aspx');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key6", "DisplayMsg('MM04','" + lblPopupMsg.ClientID + "');", true);
        }
    }
    private void bindFinancialAgreement()
    {
        string str3 = "SELECT PName,PatientID,EmergencyRelationShip FROM patient_master WHERE PatientID='" + lblPatientID.Text + "'";
        DataTable dt3 = StockReports.GetDataTable(str3);
        if (dt3.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            lblPopupMsg.Text = "";
            ds.Tables.Add(dt3.Copy());
            ds.Tables[0].TableName = "FinancialAgree";

            DataColumn dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];

            ds.Tables[0].Columns.Add(dc);




            DataTable dtImg = All_LoadData.CrystalReportLogo();
            ds.Tables.Add(dtImg.Copy());
            // ds.WriteXmlSchema("d:\\FinalcialAgree.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "FinancialAgreementForm";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key7", "window.open('../../Design/common/Commonreport.aspx');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key8", "DisplayMsg('MM04','" + lblPopupMsg.ClientID + "');", true);
        }

    }

    private void bindODI()
    {
        string str3 = "SELECT CONCAT(pm.Title,' ',pm.Pname)pname,pm.PatientID,Get_Current_Age(PM.PatientID)Age,IF(pm.DOB ='0001-01-01','',DATE_FORMAT(pm.DOB,'%d-%b-%Y'))DOB,(SELECT CONCAT(Title,' ',NAME)NAME FROM doctor_master WHERE DoctorID=pmh.DoctorID)DoctorName FROM patient_master pm " +
           " inner join patient_medical_history pmh on pm.PatientID=pmh.PatientID WHERE pm.PatientID='" + lblPatientID.Text + "'";
        DataTable dt3 = StockReports.GetDataTable(str3);
        if (dt3.Rows.Count > 0)
        {
            lblPopupMsg.Text = "";
            dt3.TableName = "ResearchODI";
            DataColumn dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
            dt3.Columns.Add(dc);
            DataSet ds = new DataSet();
            DataTable dtImg = All_LoadData.CrystalReportLogo();
            ds.Tables.Add(dtImg.Copy());
            ds.Tables.Add(dt3.Copy());
            ds.WriteXmlSchema("E:\\ResearchODI.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "ResearchODI";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key9", "window.open('../../Design/common/Commonreport.aspx');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key10", "DisplayMsg('MM04','" + lblPopupMsg.ClientID + "');", true);
        }
    }
    private void bindSCTR()
    {
        string str3 = "SELECT CONCAT(pm.Title,' ',pm.Pname)pname,pm.PatientID,pm.Gender,Get_Current_Age(PM.PatientID)Age,IF(pm.DOB ='0001-01-01','',DATE_FORMAT(pm.DOB,'%d-%b-%Y'))DOB,(SELECT CONCAT(Title,' ',NAME)NAME FROM doctor_master WHERE DoctorID=pmh.DoctorID)DoctorName FROM patient_master pm " +
           " inner join patient_medical_history pmh on pm.PatientID=pmh.PatientID WHERE pm.PatientID='" + lblPatientID.Text + "'";
        DataTable dt3 = StockReports.GetDataTable(str3);
        if (dt3.Rows.Count > 0)
        {
            lblPopupMsg.Text = "";
            dt3.TableName = "ResearchSCTR";
            DataColumn dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
            dt3.Columns.Add(dc);
            DataSet ds = new DataSet();
            DataTable dtImg = All_LoadData.CrystalReportLogo();
            ds.Tables.Add(dtImg.Copy());

            ds.Tables.Add(dt3.Copy());
            ds.WriteXmlSchema("E:\\ResearchSCTR.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "ResearchSCTR";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key11", "window.open('../../Design/common/Commonreport.aspx');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key12", "DisplayMsg('MM04','" + lblPopupMsg.ClientID + "');", true);
        }
    }
    private void bindSF36()
    {
        string str3 = "SELECT CONCAT(pm.Title,' ',pm.Pname)pname,pm.PatientID,Get_Current_Age(PM.PatientID)Age,IF(pm.DOB ='0001-01-01','',DATE_FORMAT(pm.DOB,'%d-%b-%Y'))DOB,(SELECT CONCAT(Title,' ',NAME)NAME FROM doctor_master WHERE DoctorID=pmh.DoctorID)DoctorName FROM patient_master pm " +
           " inner join patient_medical_history pmh on pm.PatientID=pmh.PatientID WHERE pm.PatientID='" + lblPatientID.Text + "'";
        DataTable dt3 = StockReports.GetDataTable(str3);
        if (dt3.Rows.Count > 0)
        {
            lblPopupMsg.Text = "";
            dt3.TableName = "ResearchSF36";
            DataColumn dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
            dt3.Columns.Add(dc);
            DataSet ds = new DataSet();
            DataTable dtImg = All_LoadData.CrystalReportLogo();
            ds.Tables.Add(dtImg.Copy());
            ds.Tables.Add(dt3.Copy());
             ds.WriteXmlSchema("E:\\ResearchSF36.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "ResearchSF36";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key13", "window.open('../../Design/common/Commonreport.aspx');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key14", "DisplayMsg('MM04','" + lblPopupMsg.ClientID + "');", true);
        }
    }
    private void bindSRS()
    {
        string str3 = "SELECT CONCAT(pm.Title,' ',pm.Pname)pname,pm.PatientID,Get_Current_Age(PM.PatientID)Age,IF(pm.DOB ='0001-01-01','',DATE_FORMAT(pm.DOB,'%d-%b-%Y'))DOB,(SELECT CONCAT(Title,' ',NAME)NAME FROM doctor_master WHERE DoctorID=pmh.DoctorID)DoctorName FROM patient_master pm " +
           " inner join patient_medical_history pmh on pm.PatientID=pmh.PatientID WHERE pm.PatientID='" + lblPatientID.Text + "'";
        DataTable dt3 = StockReports.GetDataTable(str3);
        if (dt3.Rows.Count > 0)
        {
            lblPopupMsg.Text = "";
            dt3.TableName = "ResearchSRS";
            DataColumn dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
            dt3.Columns.Add(dc);
            DataSet ds = new DataSet();
            DataTable dtImg = All_LoadData.CrystalReportLogo();
            ds.Tables.Add(dtImg.Copy());
            ds.Tables.Add(dt3.Copy());
             ds.WriteXmlSchema("E:\\ResearchSRS.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "ResearchSRS";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key15", "window.open('../../Design/common/Commonreport.aspx');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key16", "DisplayMsg('MM04','" + lblPopupMsg.ClientID + "');", true);
        }
    }
    private void bindVAS()
    {
        string str3 = "SELECT CONCAT(pm.Title,' ',pm.Pname)pname,pm.PatientID,(SELECT CONCAT(Title,' ',NAME)NAME FROM doctor_master WHERE DoctorID=pmh.DoctorID)DoctorName FROM patient_master pm " +
            " inner join patient_medical_history pmh on pm.PatientID=pmh.PatientID WHERE pm.PatientID='" + lblPatientID.Text + "'";
        DataTable dt3 = StockReports.GetDataTable(str3);
        if (dt3.Rows.Count > 0)
        {
            lblPopupMsg.Text = "";
            dt3.TableName = "ResearchVAS";
            DataColumn dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
            dt3.Columns.Add(dc);
            DataSet ds = new DataSet();
            DataTable dtImg = All_LoadData.CrystalReportLogo();
            ds.Tables.Add(dtImg.Copy());
            ds.Tables.Add(dt3.Copy());
             ds.WriteXmlSchema("E:\\ResearchVAS.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "ResearchVAS";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key17", "window.open('../../Design/common/Commonreport.aspx');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key18", "DisplayMsg('MM04','" + lblPopupMsg.ClientID + "');", true);
        }
    }
    private void bindHIP()
    {
        string str3 = "SELECT CONCAT(pm.Title,' ',pm.Pname)pname,pm.PatientID,(SELECT CONCAT(Title,' ',NAME)NAME FROM doctor_master WHERE DoctorID=pmh.DoctorID)DoctorName FROM patient_master pm " +
           " inner join patient_medical_history pmh on pm.PatientID=pmh.PatientID WHERE pm.PatientID='" + lblPatientID.Text + "'";
        DataTable dt3 = StockReports.GetDataTable(str3);
        if (dt3.Rows.Count > 0)
        {
            lblPopupMsg.Text = "";
            dt3.TableName = "ResearchHIP";
            DataColumn dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
            dt3.Columns.Add(dc);
            DataSet ds = new DataSet();
            DataTable dtImg = All_LoadData.CrystalReportLogo();
            ds.Tables.Add(dtImg.Copy());
            ds.Tables.Add(dt3.Copy());
              ds.WriteXmlSchema("E:\\ResearchHIP.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "ResearchHIP";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key19", "window.open('../../Design/common/Commonreport.aspx');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key20", "DisplayMsg('MM04','" + lblPopupMsg.ClientID + "');", true);
        }
    }
    private void bindKnee()
    {
        string str3 = "SELECT CONCAT(pm.Title,' ',pm.Pname)pname,pm.PatientID,(SELECT CONCAT(Title,' ',NAME)NAME FROM doctor_master WHERE DoctorID=pmh.DoctorID)DoctorName FROM patient_master pm " +
           " inner join patient_medical_history pmh on pm.PatientID=pmh.PatientID WHERE pm.PatientID='" + lblPatientID.Text + "'";
        DataTable dt3 = StockReports.GetDataTable(str3);
        if (dt3.Rows.Count > 0)
        {
            lblPopupMsg.Text = "";
            dt3.TableName = "ResearchKnee";
            DataColumn dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
            dt3.Columns.Add(dc);
            DataSet ds = new DataSet();
            DataTable dtImg = All_LoadData.CrystalReportLogo();
            ds.Tables.Add(dtImg.Copy());
            ds.Tables.Add(dt3.Copy());
             ds.WriteXmlSchema("E:\\ResearchKnee.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "ResearchKnee";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key21", "window.open('../../Design/common/Commonreport.aspx');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key22", "DisplayMsg('MM04','" + lblPopupMsg.ClientID + "');", true);

        }
    }


    protected void repResearch_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Print")
        {

            string link = Util.GetString(e.CommandArgument).Split('#')[0];
            if (link == "1")
            {

                string url = Util.GetString(e.CommandArgument).Split('#')[1];

                string ResearchID = Util.GetString(e.CommandArgument).Split('#')[2];
                FormId = Util.GetString(e.CommandArgument).Split('#')[3];
                string ID = Util.GetString(e.CommandArgument).Split('#')[2];
                if (ID == "1")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key10", "window.open('../../Design/CPOE/Research/ResearchFormAPI_SRS.aspx?TID=" + lblTID.Text + " &Url=" + url + " &ID=" + ResearchID + "');", true);

                }
                else if (ID == "2")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key10", "window.open('../../Design/CPOE/Research/ResearchFormAPI_LumbarSpineBack.aspx?TID=" + lblTID.Text + " &Url=" + url + " &ID=" + ResearchID + "');", true);

                }
                else if (ID == "11")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key10", "window.open('../../Design/CPOE/Research/ResearchForm_VAS.aspx?TID=" + lblTID.Text + " &Url=" + url + " &ID=" + ResearchID + "');", true);

                }
                else if (ID == "12")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key10", "window.open('../../Design/CPOE/Research/SF36.aspx?TID=" + lblTID.Text + " &Url=" + url + " &ID=" + ResearchID + "');", true);

                }
                else if (ID == "41")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key10", "window.open('../../Design/CPOE/Research/ResearchFormAPI_CervicalSpine.aspx?TID=" + lblTID.Text + " &Url=" + url + " &ID=" + ResearchID + "');", true);

                }
                else if (ID == "4" || ID == "7" || ID == "18")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key10", "window.open('../../Design/CPOE/Research/ResearchFormAPIHOOS.aspx?TID=" + lblTID.Text + " &Url=" + url + " &ID=" + ResearchID + "');", true);

                }
                else if (ID == "9")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key10", "window.open('../../Design/CPOE/Research/ResearchFormAPI_IKDC.aspx?TID=" + lblTID.Text + " &Url=" + url + " &ID=" + ResearchID + "');", true);

                }
                else if (ID == "17")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key10", "window.open('../../Design/CPOE/Research/ResearchFormAPI_Foot.aspx?TID=" + lblTID.Text + " &Url=" + url + " &ID=" + ResearchID + "');", true);

                }
                else if (ID == "5" || ID == "8")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key10", "window.open('../../Design/CPOE/Research/ResearchFormAPI_WOMAC.aspx?TID=" + lblTID.Text + " &Url=" + url + " &ID=" + ResearchID + "');", true);

                }
                else if (ID == "3" || ID == "6" || ID == "22" || ID == "26")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key15", "window.open('../../Design/CPOE/Research/ResearchFormAPI.aspx?TID=" + lblTID.Text + " &Url=" + url + " &ID=" + ResearchID + "');", true);

                }
                else if (ID == "27")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key15", "window.open('../../Design/CPOE/Research/ResearchFormAPI_shoulderWOSI.aspx?TID=" + lblTID.Text + " &Url=" + url + " &ID=" + ResearchID + "');", true);

                }
                else if (ID == "23")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key15", "window.open('../../Design/CPOE/Research/ResearchFormAPI_ShoulderASES.aspx?TID=" + lblTID.Text + " &Url=" + url + " &ID=" + ResearchID + "');", true);

                }
                else if (ID == "35")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key10", "window.open('../../Design/CPOE/Research/ResearchFormAPI_HandMichigan.aspx?TID=" + lblTID.Text + " &Url=" + url + " &ID=" + ResearchID + "');", true);

                }
                else if (ID == "37" || ID == "39")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key10", "window.open('../../Design/CPOE/Research/ResearchFormAPI_CervicalSpine.aspx?TID=" + lblTID.Text + " &Url=" + url + " &ID=" + ResearchID + "');", true);

                }
                else if (ID == "36" || ID == "38")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key10", "window.open('../../Design/CPOE/Research/ResearchFormAPI_LumbarSpineBack.aspx?TID=" + lblTID.Text + " &Url=" + url + " &ID=" + ResearchID + "');", true);

                }
                else if (ID == "24" || ID == "25" || ID == "29" || ID == "30" || ID == "31" || ID == "32" || ID == "33" || ID == "34")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key10", "window.open('../../Design/CPOE/Research/ResearchFormAPI_Hand.aspx?TID=" + lblTID.Text + " &Url=" + url + " &ID=" + ResearchID + "');", true);

                }
                else if (ID == "19" || ID == "20")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key10", "window.open('../../Design/CPOE/Research/ResearchFormAPI_KneeModified.aspx?TID=" + lblTID.Text + " &Url=" + url + " &ID=" + ResearchID + "');", true);

                }
                else if (ID == "40")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key10", "window.open('../../Design/CPOE/Research/ResearchFormAPI_Psychological.aspx?TID=" + lblTID.Text + " &Url=" + url + " &ID=" + ResearchID + "');", true);

                }
                else if (ID == "28")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key10", "window.open('../../Design/CPOE/Research/ResearchFormAPI_Elbow.aspx?TID=" + lblTID.Text + " &Url=" + url + " &ID=" + ResearchID + "');", true);

                }
                else if (ID == "36")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key10", "window.open('../../Design/CPOE/Research/ResearchFormAPI_Lumbar.aspx?TID=" + lblTID.Text + " &Url=" + url + " &ID=" + ResearchID + "');", true);

                }
                else if (ID == "43")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key20", "window.open('../../Design/CPOE/Research/ResearchFormBergBalanceScale.aspx?TID=" + lblTID.Text + " &Url=" + url + " &ID=" + ResearchID + "');", true);

                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key15", "window.open('../../Design/CPOE/Research/ResearchFormAPI.aspx?TID=" + lblTID.Text + " &Url=" + url + " &ID=" + ResearchID + "');", true);
                }
                mpClose.Show();
            }
            else
            {
                FormId = Util.GetString(e.CommandArgument).Split('#')[3];
                if (FormId == "8")
                {
                    BindRegForm();
                }
                else if (FormId == "9")
                {
                    bindPatientConsentForm();
                }
                else if (FormId == "22")
                {
                    bindPhysicalConsentForm();
                }
                else if (FormId == "10")
                {
                    bindGeneralConsent();
                }
                else if (FormId == "11")
                {
                    bindFinancialAgreement();
                }
                else if (FormId == "6")
                {
                    bindVAS();
                }
                else if (FormId == "7")
                {
                    bindSF36();
                }
                else if (FormId == "1")
                {
                    bindSRS();
                }
                else if (FormId == "2")
                {
                    bindODI();
                }
                else
                {
                }
                mpClose.Show();
            }
        }
    }
    protected void repResearch_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex >= 0)
        {
            Label FormId = ((Label)e.Row.FindControl("lblFormID"));
            string Id = Util.GetString(FormId.Text);
            int index = e.Row.RowIndex;
            string PreviousFormID = string.Empty;
            System.Drawing.Color BackColor;
            BackColor = System.Drawing.Color.Red;
            if (index % 2 == 0)
            {

                if (e.Row.RowIndex > 0)
                {
                    PreviousFormID = ((Label)repResearch.Rows[index - 1].FindControl("lblFormID")).Text.Trim();
                    BackColor = repResearch.Rows[index - 1].BackColor;
                }
                if (FormId.Text.Trim() == PreviousFormID)
                {
                    e.Row.BackColor = repResearch.Rows[index - 1].BackColor;

                }
                else
                {

                    if (BackColor == System.Drawing.Color.Beige)
                    {
                        e.Row.BackColor = System.Drawing.Color.Azure;
                    }
                    else
                    {
                        e.Row.BackColor = System.Drawing.Color.Beige;
                    }
                }
            }
            else
            {

                if (e.Row.RowIndex > 0)
                {
                    PreviousFormID = ((Label)repResearch.Rows[index - 1].FindControl("lblFormID")).Text.Trim();
                    BackColor = repResearch.Rows[index - 1].BackColor;
                }
                if (FormId.Text.Trim() == PreviousFormID)
                {
                    e.Row.BackColor = repResearch.Rows[index - 1].BackColor;

                }
                else
                {
                    if (BackColor == System.Drawing.Color.Azure)
                    {
                        e.Row.BackColor = System.Drawing.Color.Beige;
                    }
                    else
                    {
                        e.Row.BackColor = System.Drawing.Color.Azure;
                    }
                }

            }

        }

    }
}


