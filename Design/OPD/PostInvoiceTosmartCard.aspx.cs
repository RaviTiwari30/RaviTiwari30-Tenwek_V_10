using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OPD_PostInvoiceTosmartCard : System.Web.UI.Page
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
    public static string GetMessages(string BillFromDate, string BillToDate, string PatientID, string ClaimNo, string PolicyNo, string IPDNo, string DocketNo, string DispatchNo, string DispatchDate, int PanelID, string Type, string Status, string CashCredit, string chkDispatchDate, int IsCoverNote, int EncounterNo)
    {
        PanelInvoice PI = new PanelInvoice();

        DataTable dt = PI.bindDispatchData(BillFromDate, BillToDate, PatientID, ClaimNo, PolicyNo, IPDNo, DocketNo, DispatchNo, DispatchDate, PanelID, Type, Status, CashCredit, chkDispatchDate, Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()), IsCoverNote);
        DataColumn dc = new DataColumn("maxBillDate");

        dc.DefaultValue = dt.Compute("MAX(BillDate)", null);
        dt.Columns.Add(dc); 

        if (dt.Rows.Count > 0 && dt != null)
        {
            DataView dv = new DataView(dt);
            if (Util.GetInt(EncounterNo)!=0)
            {
                dv.RowFilter = "EncounterNo=" + Util.GetInt(EncounterNo) + "";
                dt = dv.ToTable();
            }
            else
            {
                dt = new DataTable();
            }
           
        }
          
        if ((dt.Rows.Count > 0) && (dt != null))
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
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

    protected void btnPostedInvoice_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT t.Type,t.Patient_ID, PanelGroup,t.Pname,t.DispatchDate, t.panelAmount as BillAmount,t.billno,t.PanelInvoiceNo,t.PolicyNo,t.IsClaimPosted FROM  ");
        sb.Append(" ( ");
	    sb.Append(" SELECT dis.Type,dis.PatientID AS Patient_ID,dis.panelid AS panel_id,pam.`PanelGroup`, ");
	    sb.Append(" ConvertCurrencyNew_base(227,dis.BillAmount,dis.BillDate) AS BillAmount,ConvertCurrencyNew_base(227,dis.panelAmount,dis.BillDate)  ");
	    sb.Append(" AS panelAmount,   CONCAT(ltd.ItemName,IF(lt.typeoftnx='OPD-appointment', ");
	    sb.Append(" IFNULL((SELECT CONCAT(' (',NAME,' )')  ");
	    sb.Append(" FROM f_subcategorymaster sub INNER JOIN appointment app ON sub.SubCategoryID=app.SubCategoryID    ");
	    sb.Append(" WHERE app.LedgerTnxNo=lt.LedgerTransactionNo LIMIT 1),''),''),'(',IF(ltd.EntryDate='0001-01-01','', ");
	    sb.Append(" DATE_FORMAT(ltd.EntryDate,'%d-%b-%Y')),')')ItemName,  ''Diagnosis,   ltd.Quantity, ");
	    sb.Append(" ConvertCurrencyNew_base(227,ltd.Rate,dis.BillDate) AS Rate, ");
	    sb.Append(" ConvertCurrencyNew_base(227,ROUND((ltd.Rate*ltd.Quantity),2),dis.BillDate) AS Gross, ");
	    sb.Append(" ConvertCurrencyNew_base(227,ltd.DiscAmt,dis.BillDate) AS DiscAmt,ConvertCurrencyNew_base(227,ROUND(ltd.Amount,2),dis.BillDate) AS Amount, ");
	    sb.Append(" DATE_FORMAT(dis.BillDate,'%d-%b-%Y')BillDate,dis.BillNo,dis.PanelInvoiceNo, ");
	    sb.Append(" CONCAT('PName: ',pm.Title,' ',pm.PName,'   (DOB: ',IF(pm.DOB='0001-01-01','',DATE_FORMAT(pm.DOB,'%d-%b-%Y')),')','    ");
	    sb.Append(" (Gender: ',pm.`Gender`,')','   (Mobile: ',pm.`Mobile`,')','   (UHID: ',pm.PatientID,')')PName,  CONCAT(em.title,' ',em.Name)NAME,  ");
	    sb.Append(" DATE_FORMAT(dis.DispatchDate,'%d-%b-%Y')DispatchDate,pam.`PanelGroup` AS Dispatch_No, pmh.`CardNo` AS EmployerName,pmh.`CardHolderName` AS ");
	    sb.Append(" BenefitOption,  IF(dis.PolicyNo IS NOT NULL AND dis.PolicyNo<>'',dis.PolicyNo,  ");
	    sb.Append(" IFNULL((SELECT PolicyNo FROM `patient_policy_detail` WHERE Patient_ID=dis.`PatientID` ");  
	    sb.Append(" AND IsActive=1 AND Panel_ID=dis.`PanelID` ORDER BY ID DESC LIMIT 1),''))PolicyNo, ");
	    sb.Append(" IFNULL(( SELECT IF(IFNULL(pds.IsClaimPosted,0)=1,1,0) FROM paneldetails_description pds ");
	    sb.Append(" INNER JOIN paneldetails pd ON pd.Id=pds.PanelDetailsId AND pd.IsActive=1 ");
	    sb.Append(" INNER JOIN patient_encounter pe ON pe.SessionId=pd.SessionId  ");
	    sb.Append(" WHERE pds.pool_nr=lt.PoolNr AND pd.PanelID=lt.PanelID AND pe.EncounterNo=lt.EncounterNo),'0')IsClaimPosted  ");
	    sb.Append(" FROM f_dispatch dis ");
	    sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.transactionID=dis.TransactionID   ");
	    sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.transactionid=pmh.transactionid ");
	    sb.Append(" INNER JOIN   f_ledgertnxdetail ltd ON lt.LedgerTransactionNo=ltd.LedgerTransactionNo");
	    sb.Append(" INNER JOIN employee_master em ON Lt.UserID=EM.EmployeeID   ");
	    sb.Append(" INNER JOIN Patient_master pm ON pm.PatientID=pmh.PatientID  ");
	    sb.Append(" INNER JOIN f_panel_master pam ON dis.panelid=pam.panelid   "); 
	    sb.Append(" WHERE lt.IsCancel=0 AND ltd.isrefund=0  AND ltd.isPackage=0 AND dis.IsDispatched=1 ");
	    sb.Append(" AND dis.isCancel=0 AND IF((SELECT SUM(Amount) FROM panel_amountallocation WHERE TransactionID=dis.TransactionID )");
	    sb.Append(" <>ConvertCurrencyNew_base(227,dis.panelAmount,dis.BillDate), ltd.`IsPayable`=1,ltd.`IsPayable`IN(1,0)) ");
	    sb.Append(" AND dis.`EntryDate`>=CONCAT('"+Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd")+"',' 00:00:00') AND dis.`EntryDate`<=CONCAT('"+Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd")+"',' 23:59:59') ");
        sb.Append(" )t ");
       sb.Append(" WHERE  t.IsClaimPosted=1  GROUP BY t.billno ");

        DataTable dt=new DataTable();
        dt=StockReports.GetDataTable(sb.ToString());
        if(dt.Rows.Count>0  && dt!=null)
        {
             Session["dtExport2Excel"] = dt;
             Session["Period"] = "From " + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yyyy");
             Session["ReportName"] = "Posted Invoice Smart Card";

             ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
               
        }
         else
            {
                //lblMsg.Text = "No Record Found";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert(' Record Not Found ', function(){});", true);
            }
       
       
      
    }
}