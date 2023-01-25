using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_CPOE_TemperatureRoomSearch : System.Web.UI.Page
{
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindPanel();            
            BindOPDType();
            BindGroup();
            fromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            All_LoadData.bindDoctor(ddlDoctor, "ALL");
            txtRegNo.Focus();
        }
        fromDate.Attributes.Add("readonly", "readonly");
        ToDate.Attributes.Add("readonly", "readonly");
    }
    private void BindOPDType()
    {
        string str = "select name,SubCategoryID from f_subcategorymaster where CategoryID=1 order by name ";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlOPDType.DataSource = dt;
            ddlOPDType.DataTextField = "name";
            ddlOPDType.DataValueField = "SubCategoryID";
            ddlOPDType.DataBind();
            ddlOPDType.Items.Insert(0, new ListItem("Select","0"));
        }
    }

    private void BindPanel()
    {
        DataTable dt = EDPReports.GetPanels();
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlPanel.DataSource = dt;
            ddlPanel.DataTextField = "text";
            ddlPanel.DataValueField = "value";
            ddlPanel.DataBind();
            ddlPanel.Items.Insert(0, new ListItem("All","0"));
        }
    }

    //private void BindPanel()
    //{
    //    DataTable dt = EDPReports.GetPanels();
    //    if (dt != null && dt.Rows.Count > 0)
    //    {
    //        ddlPanel.DataSource = dt;
    //        ddlPanel.DataTextField = "text";
    //        ddlPanel.DataValueField = "value";
    //        ddlPanel.DataBind();
    //        ddlPanel.Items.Insert(0, new ListItem("All", "0"));
    //    }
    //}



    private void BindGroup()
    {
        DataTable dt = StockReports.GetDataTable("SELECT DocType,ID FROM DoctorGroup WHERE isActive=1");
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlDoctorGroup.DataSource = dt;
            ddlDoctorGroup.DataTextField = "DocType";
            ddlDoctorGroup.DataValueField = "ID";
            ddlDoctorGroup.DataBind();
            ddlDoctorGroup.Items.Insert(0, new ListItem("ALL"));
        }
    }

    [WebMethod(EnableSession = true)]
    public static string TemperatureRoomSearch(string MRNo, string PName, string AppNo, string DoctorID, string status, string fromDate, string toDate,string DrGroup,int panelID,string appointmentType)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT if( lt.DiscountOnTotal>0,lt.discountApprovalStatus,2) as 'SelectFlag', CASE WHEN (app.IsCall=1 AND app.P_OUT = 0) THEN 'Call'  WHEN (app.P_IN = 0 AND app.P_OUT = 0) THEN 'Pending' WHEN (app.P_IN = 1 AND app.P_OUT = 1) THEN 'Out' WHEN (app.P_IN = 1 AND app.P_OUT = 0) THEN 'IN' ELSE 'Pending' END AS 'Status',IFNULL(ref.AppID,' ')AppID,pm.PatientID,LedgerTnxNo,pm.PatientID MRNo,app.App_ID,app.AppNo,CONCAT(pm.Title,' ',pm.Pname)Pname,CONCAT(dm.Title,' ',dm.Name)DName,sub.Name SubName, ");
        sb.Append(" pm.Mobile ContactNo,pm.Gender Sex,DATE_FORMAT(app.date,'%d-%b-%Y')AppointmentDate,pm.Age,pm.Mobile ContactNo,app.VisitType,TypeOfApp,app.TransactionID,IF(app.TemperatureRoom = 1,'true','false')Isdone,IF(app.TemperatureRoom = 1,'Closed','Pending')IsCompleated, ");
        sb.Append(" IF(app.subcategoryID='" + HttpContext.GetGlobalResourceObject("Resource", "EmergencySubcategoryID").ToString() + "','1','0')IsEmergency,app.PanelID ");
        sb.Append(" ,(SELECT p.company_name FROM  `f_panel_master` p WHERE p.`PanelID`=app.PanelID)PanelName,(SELECT CONCAT(dm.Title,'',dm.Name) FROM doctor_master dm WHERE dm.DoctorID=app.DoctorID)DName,  IF((lt.Adjustment < lt.NetAmount AND  lt.PanelID = 1),FALSE,TRUE) `IsPaid`,f.Company_Name ,");
        sb.Append(" IFNULL((SELECT COUNT(*) FROM patient_labinvestigation_opd plo INNER JOIN patient_test pt ON pt.test_ID = plo.test_ID WHERE  pt.TransactionID=app.TransactionID AND plo.Result_Flag=1 GROUP BY pt.TransactionID ),0) labResultCount,ifnull(pm.PurposeOfVisit,'')PurposeOfVisit,IFNULL(tr.ColorCode,'')ColorCode,IFNULL(tr.CodeType,'')CodeType ,DocDepartmentID,IFNULL(app.PatientType,'')PatientType, "); 
       
        sb.Append(" IF(IFNULL(lt.PanelID,app.PanelID)=1,IF(IFNULL(ltd.IsPaymentApproval,0)=1,1, ");
        sb.Append(" IF(IFNULL(lt.Adjustment,0) < IFNULL(lt.NetAmount,0),0,1)),ltd.IsPaymentApproval)IsPaymentApproval,IFNULL(cte.IsPatientAdmitted,0)IsPatientAdmitted  ");
        
        sb.Append(" FROM appointment app INNER JOIN patient_master pm ON pm.PatientID=app.PatientID ");
        sb.Append(" INNER JOIN doctor_master dm ON dm.DoctorID=app.DoctorID ");
        sb.Append(" INNER JOIN f_subcategorymaster sub on sub.subcategoryID=app.subcategoryID ");
        sb.Append(" INNER JOIN f_panel_master f ON f.PanelID=app.PanelID");
        sb.Append(" LEFT JOIN cpoe_referralConsultation ref ON ref.AppID=app.App_ID ");
        sb.Append(" LEFT JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=LedgerTnxNo "); 

        sb.Append(" LEFT JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=LedgerTnxNo AND ltd.SubcategoryID=app.subcategoryID ");


        sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.transactionid=app.TransactionID   ");
        sb.Append(" LEFT JOIN emr_triagingcodes tr ON tr.ID=pmh.TriagingCode  ");
        sb.Append(" LEFT JOIN cpoe_transfertoemergency cte ON cte.TransactionID=app.TransactionID   ");
        sb.Append(" WHERE app.PatientID<>''  AND app.IsConform=1 AND app.IsCancel=0 AND app.CentreID='"+ HttpContext.Current.Session["CentreID"].ToString() +"'    ");

        //and LedgerTnxNo<>''

        if (PName.Trim() != string.Empty)
            sb.Append(" and app.Pname like '" + PName.Trim() + "%'");
        if (MRNo.Trim() != string.Empty)
            sb.Append(" and app.PatientID='" + MRNo.Trim() + "'");
        if (DoctorID != "0")
            sb.Append(" and app.DoctorID='" + DoctorID + "'");

        if (fromDate != string.Empty)
            sb.Append(" and app.date>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "'");
        if (toDate != string.Empty)
            sb.Append(" and app.date<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "'");

        if (status != "2")
            sb.Append(" and app.TemperatureRoom='" + status + "'");
        if (AppNo.Trim() != string.Empty)
            sb.Append(" and app.AppNo=" + AppNo.Trim() + "");
        if (DrGroup != "ALL")
            sb.Append(" AND dm.DocGroupID ='"+ DrGroup +"' ");

        if (appointmentType != "0")
            sb.Append(" And app.subcategoryID='" + appointmentType+"' ");

        if (panelID > 0)
            sb.Append(" AND f.PanelID=" + panelID);

        sb.Append(" Order by app.date desc, app.App_ID");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        
    }

}