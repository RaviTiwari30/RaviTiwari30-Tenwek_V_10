using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Dispatch_DispatchMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindPanel();

            ucFromDate.Text = //DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ucDispatchDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
           // txtMRNo.Text="C0000110";
        }
        txtDisptachDate.Attributes.Add("readOnly", "readOnly");
        ucFromDate.Attributes.Add("readOnly", "readOnly");
        ucToDate.Attributes.Add("readOnly", "readOnly");
    }
    private void bindPanel()
    {

        DataTable dt = All_LoadData.loadPanelRoleWisePanelGroupWise(2);

      //  DataTable dt = StockReports.GetDataTable("SELECT  RTRIM(LTRIM(Company_Name)) AS Company_Name,CONCAT(PanelID,'$',CoverNote)PanelID FROM f_panel_master WHERE  IsActive=1 order by Company_Name ");
        if (dt.Rows.Count > 0)
        {
            ddlPanelCompany.DataSource = dt;
            ddlPanelCompany.DataValueField = "PanelID";
            ddlPanelCompany.DataTextField = "Company_Name";
            ddlPanelCompany.DataBind();
            ddlPanelCompany.Items.Insert(0, new ListItem("Select", "0"));
        }
    }
    [WebMethod]
    [System.Web.Script.Services.ScriptMethod(ResponseFormat = System.Web.Script.Services.ResponseFormat.Json)]
    public static string GetMessages(string BillFromDate, string BillToDate, string PatientID, string ClaimNo, string PolicyNo, string IPDNo, string DocketNo, string DispatchNo, string DispatchDate, int PanelID, string Type, string Status, string CashCredit, string chkDispatchDate, int IsCoverNote)
    {
        PanelInvoice PI = new PanelInvoice();

        DataTable dt = PI.bindDispatchData(BillFromDate, BillToDate, PatientID, ClaimNo, PolicyNo, IPDNo, DocketNo, DispatchNo, DispatchDate, PanelID, Type, Status, CashCredit, chkDispatchDate, Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()), IsCoverNote);
        DataColumn dc = new DataColumn("maxBillDate");

        dc.DefaultValue = dt.Compute("MAX(BillDate)", null);
        dt.Columns.Add(dc);

        if ((dt.Rows.Count > 0) && (dt != null))
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }


    [WebMethod(EnableSession = true)]
    public string bindDispatchDatas(string BillFromDate, string BillToDate, string PatientID, string ClaimNo, string PolicyNo, string IPDNo, string DocketNo, string DispatchNo, string DispatchDate, int PanelID, string Type, string Status, string CashCredit, string chkDispatchDate, int IsCoverNote)
    {
        PanelInvoice PI = new PanelInvoice();

        DataTable dt = PI.bindDispatchData(BillFromDate, BillToDate, PatientID, ClaimNo, PolicyNo, IPDNo, DocketNo, DispatchNo, DispatchDate, PanelID, Type, Status, CashCredit, chkDispatchDate, Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()), IsCoverNote);
        DataColumn dc = new DataColumn("maxBillDate");

        dc.DefaultValue = dt.Compute("MAX(BillDate)", null);
        dt.Columns.Add(dc);

        //if ((dt.Rows.Count > 0) && (dt != null))
        //    return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        //else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public static string IPDInvoice(string InvoiceNo)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT REPLACE(TransactionID,'ISHHI','')AS IPDNo,DATE_FORMAT(DateofAdmission,'%d-%b-%Y')AdmissionDate, ");
            sb.Append(" DATE_FORMAT(dateofadmission,'%l:%i %p')AdmissionTime,Pname,dis.PanelName,dis.BillAmount, (dis.DispatchDate,'%d-%b-%Y')DispatchDate,dis.DocketNo,dis.PatientID,dis.type, ");
            sb.Append(" CONCAT(em.Title,'',em.Name)employeename,DATE_FORMAT(EntryDate,'%d-%b-%Y %l:%i %p')EntryDate,IFNULL(dis.CourierComp,'')CourierComp, ");
            sb.Append(" IFNULL(dis.Ref1,'')Ref1,dis.Dispatch_No,dis.panelInvoiceNo,dis.PanelAmount,DATE_FORMAT(dis.BillDate,'%d-%b-%Y')BillDate,dis.BillNo ");
            sb.Append(" FROM f_dispatch dis ");
            sb.Append(" INNER JOIN employee_master em ON em.Employee_ID=dis.UserID ");
            sb.Append(" WHERE dis.isCancel=0 AND dis.TYPE='IPD' ");
            if (InvoiceNo != "")
                sb.Append(" AND dis.panelInvoiceNo='" + InvoiceNo + "' ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                DataColumn dc = new DataColumn();
                dc = new DataColumn();
                dc.ColumnName = "UserName";
                dc.DefaultValue = StockReports.GetUserName(Convert.ToString(HttpContext.Current.Session["ID"])).Rows[0][0];
                dt.Columns.Add(dc);
                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());
                DataTable dtImg = All_LoadData.CrystalReportLogo();
                ds.Tables.Add(dtImg.Copy());
                ds.Tables[1].TableName = "logo";
                //  ds.WriteXmlSchema("E:\\PanelInvoiceIPD.xml");
                HttpContext.Current.Session["ds"] = ds;
                HttpContext.Current.Session["ReportName"] = "PanelInvoiceIPD";
            }
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog objErr = new ClassLog();
            objErr.errLog(ex);
            return "0";
        }
    }
}