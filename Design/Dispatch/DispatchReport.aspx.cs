using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_EDP_DispatchReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            bindPanel();

            lblMsg.Text = "";
        }
        txtFromDate.Attributes.Add("readOnly", "readOnly");
        txtToDate.Attributes.Add("readOnly", "readOnly");
    }
    private void bindPanel()
    {
        DataTable dt = StockReports.GetDataTable("SELECT PanelID as Panel_ID,Company_Name FROM f_panel_master WHERE IsActive=1");
        if (dt.Rows.Count > 0)
        {
            ddlPanelCompany.DataSource = dt;
            ddlPanelCompany.DataTextField = "Company_Name";
            ddlPanelCompany.DataValueField = "Panel_ID";
            ddlPanelCompany.DataBind();
            ddlPanelCompany.Items.Insert(0, new ListItem("Select", "0"));
        }
    }
    [WebMethod]
    public static string dispatchReportSummary(string PanelID, string DispatchNo, string InvoiceNo, string UHID, string fromDate, string toDate, string Format, string Diagnosis, string Policy, string type,string CurrencyId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT IF(dis.Type='IPD','IPD',lt.TypeOfTnx)TypeOfTnx,dis.PatientID as Patient_ID,dis.panelid as panel_id,pam.Company_name,ConvertCurrencyNew_base(" + CurrencyId + ",dis.BillAmount,dis.BillDate) AS BillAmount,ConvertCurrencyNew_base(" + CurrencyId + ",dis.panelAmount,dis.BillDate) AS panelAmount,    ");
        sb.Append("  CONCAT(ltd.ItemName,IF(lt.typeoftnx='OPD-appointment',IFNULL((SELECT CONCAT(' (',NAME,' )') FROM f_subcategorymaster sub INNER JOIN appointment app ON sub.SubCategoryID=app.SubCategoryID ");
        sb.Append("  WHERE app.patientid=pm.PatientID LIMIT 1),''),''))ItemName, ");
        if (Diagnosis == "1")
        {
            sb.Append(" IFNULL((SELECT GROUP_CONCAT(icd.WHO_Full_Desc)ProvisionalDiagnosis FROM cpoe_10cm_patient icdp ");
            sb.Append(" INNER JOIN icd_10_new icd ON icdp.icd_id=icd.ID WHERE icdp.PatientID = pm.PatientID AND icdp.TransactionID = dis.`TransactionID`), ");
            sb.Append(" (SELECT GROUP_CONCAT(icd.WHO_Full_Desc)ProvisionalDiagnosis FROM cpoe_10cm_patient icdp ");
            sb.Append(" INNER JOIN icd_10_new icd ON icdp.icd_id=icd.ID WHERE icdp.PatientID = pm.PatientID AND icdp.TransactionId < dis.`TransactionID` ");
            sb.Append(" GROUP BY icdp.`TransactionID` ORDER BY icdp.TransactionId DESC LIMIT 1) )Diagnosis, ");
        }
        else
        {
            sb.Append(" ''Diagnosis, ");
        }
        sb.Append("  ltd.Quantity, DATE_FORMAT(dis.BillDate,'%d-%b-%Y')BillDate,dis.BillNo,dis.PanelInvoiceNo, ");
        sb.Append(" CONCAT('PName: ',pm.Title,' ',pm.PName,' (DOB: ',IF(pm.DOB='0001-01-01','',DATE_FORMAT(pm.DOB,'%d-%b-%Y')),')',' (Gender: ',pm.`Gender`,')',' (Mobile: ',pm.`Mobile`,')',' (UHID: ',pm.PatientID,')')PName, ");
        sb.Append(" CONCAT(em.title,' ',em.Name)NAME,  ");
        sb.Append("    ");
        sb.Append("  DATE_FORMAT(dis.DispatchDate,'%d-%b-%Y')DispatchDate,pam.`PanelGroup` as Dispatch_No,pmh.`CardNo` AS EmployerName,pmh.`CardHolderName` AS BenefitOption, ");
        if (Policy == "1")
        {
            //sb.Append(" IF(pmh.PolicyNo!='Select',pmh.PolicyNo,'')PolicyNo ");
            // sb.Append(" IFNULL((SELECT PolicyNo FROM patient_policy_Detail WHERE Patient_ID=pm.Patient_ID AND isactive=1 ORDER BY id DESC LIMIT 1),'')PolicyNo");
            sb.Append(" IF(dis.PolicyNo IS NOT NULL AND dis.PolicyNo<>'',dis.PolicyNo, IFNULL((SELECT PolicyNo FROM `patient_policy_detail` WHERE Patient_ID=dis.`PatientID` ");
            sb.Append(" AND IsActive=1 AND Panel_ID=dis.`PanelID` ORDER BY ID DESC LIMIT 1),''))PolicyNo ");
        }
        else
        {
            sb.Append(" '' PolicyNo ");
        }
        sb.Append(" FROM f_dispatch dis INNER JOIN patient_medical_history pmh ON pmh.transactionID=dis.TransactionID ");
        sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.transactionid=pmh.transactionid INNER JOIN ");
        sb.Append(" f_ledgertnxdetail ltd ON lt.LedgerTransactionNo=ltd.LedgerTransactionNo INNER JOIN employee_master em ON Lt.UserID=EM.EmployeeID ");
        sb.Append(" INNER JOIN Patient_master pm ON pm.PatientID=pmh.PatientID ");
        sb.Append(" INNER JOIN f_panel_master pam ON dis.panelid=pam.panelid");
        sb.Append(" WHERE lt.IsCancel=0 AND ltd.isrefund=0  AND ltd.isPackage=0 AND dis.IsDispatched=1 AND dis.isCancel=0 ");
        if (PanelID != "0")
        {
            sb.Append(" AND dis.panelID='" + PanelID + "'");
        }
        if (DispatchNo != "")
            sb.Append(" AND dis.Dispatch_No='" + DispatchNo.Trim() + "' ");
        
        if (InvoiceNo != "")
            sb.Append(" AND dis.PanelInvoiceNo='" + InvoiceNo.Trim() + "' ");

        if (UHID != "")
            sb.Append(" AND dis.PatientID='" + UHID.Trim() + "' ");

        if (type != "All")
        {
            sb.Append(" AND dis.type='" + type + "'");
        }
        sb.Append(" GROUP BY dis.TransactionID ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = StockReports.GetUserName(Convert.ToString(HttpContext.Current.Session["ID"])).Rows[0][0];
            dt.Columns.Add(dc);
            DataSet ds = new DataSet();

            if (Format == "1")
            {
                ds.Tables.Add(dt.Copy());
                DataTable dtImg = All_LoadData.CrystalReportLogo();
                ds.Tables.Add(dtImg.Copy());
                ds.Tables[1].TableName = "logo";
                DataColumn Dc = new DataColumn();
                Dc.ColumnName = "CurrencyId";
                Dc.DefaultValue = CurrencyId;
                ds.Tables[0].Columns.Add(Dc);
               // ds.WriteXmlSchema("F:\\dispatchReportSummary.xml");
                HttpContext.Current.Session["ds"] = ds;
                HttpContext.Current.Session["ReportName"] = "dispatchReportSummaryOPD";
            }
            else
            {

	 	        dt.Columns.Remove("ItemName");
                dt.Columns.Remove("Quantity");

                DataRow dtRow = dt.NewRow();
                dtRow["TypeOfTnx"] = "Total";
                dtRow["BillAmount"] = dt.Compute("sum(BillAmount)", "");
                dtRow["panelAmount"] = dt.Compute("sum(panelAmount)", "");
                dt.Rows.Add(dtRow);

                HttpContext.Current.Session["dtExport2Excel"] = dt;
                HttpContext.Current.Session["ReportName"] = "Dispatch Report(Summary)";
            }
            return "1";
        }
        else
        {
            return "0";
        }
    }
    [WebMethod]
    public static string dispatchReport(string PanelID, string DispatchNo, string InvoiceNo, string UHID, string fromDate, string toDate, string Format, string Diagnosis, string Policy, string type, string CurrencyId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT dis.Type,dis.PatientID as Patient_ID,dis.panelid as panel_id,pam.Company_name,ConvertCurrencyNew_base(" + CurrencyId + ",dis.BillAmount,dis.BillDate) AS BillAmount,ConvertCurrencyNew_base(" + CurrencyId + ",dis.panelAmount,dis.BillDate) AS panelAmount, ");
        sb.Append("  CONCAT(ltd.ItemName,IF(lt.typeoftnx='OPD-appointment',IFNULL((SELECT CONCAT(' (',NAME,' )') FROM f_subcategorymaster sub INNER JOIN appointment app ON sub.SubCategoryID=app.SubCategoryID ");
        //sb.Append("  WHERE app.patient_id=pm.Patient_ID LIMIT 1),''),''))ItemName, ");
        sb.Append("  WHERE app.LedgerTnxNo=lt.LedgerTransactionNo LIMIT 1),''),''),'(',IF(ltd.EntryDate='0001-01-01','',DATE_FORMAT(ltd.EntryDate,'%d-%b-%Y')),')')ItemName, ");
        if (Diagnosis == "1")
        { 
             sb.Append(" IFNULL((SELECT GROUP_CONCAT(icd.WHO_Full_Desc)ProvisionalDiagnosis FROM cpoe_10cm_patient icdp ");
             sb.Append(" INNER JOIN icd_10_new icd ON icdp.icd_id=icd.ID WHERE icdp.PatientID = pm.PatientID AND icdp.TransactionID = dis.`TransactionID`), ");
             sb.Append(" (SELECT GROUP_CONCAT(icd.WHO_Full_Desc)ProvisionalDiagnosis FROM cpoe_10cm_patient icdp ");
             sb.Append(" INNER JOIN icd_10_new icd ON icdp.icd_id=icd.ID WHERE icdp.PatientID = pm.PatientID AND icdp.TransactionId < dis.`TransactionID` ");
             sb.Append(" GROUP BY icdp.`TransactionID` ORDER BY icdp.TransactionId DESC LIMIT 1) )Diagnosis, ");
        }
        else
        {
            sb.Append(" ''Diagnosis, ");
        }
        sb.Append("  ltd.Quantity,ConvertCurrencyNew_base(" + CurrencyId + ",ltd.Rate,dis.BillDate) AS Rate,ConvertCurrencyNew_base(" + CurrencyId + ",ROUND((ltd.Rate*ltd.Quantity),2),dis.BillDate) AS Gross,ConvertCurrencyNew_base(" + CurrencyId + ",ltd.DiscAmt,dis.BillDate) AS DiscAmt,ConvertCurrencyNew_base(" + CurrencyId + ",ROUND(ltd.Amount,2),dis.BillDate) AS Amount,DATE_FORMAT(dis.BillDate,'%d-%b-%Y')BillDate,dis.BillNo,dis.PanelInvoiceNo, ");
        sb.Append(" CONCAT('PName: ',pm.Title,' ',pm.PName,'   (DOB: ',IF(pm.DOB='0001-01-01','',DATE_FORMAT(pm.DOB,'%d-%b-%Y')),')','   (Gender: ',pm.`Gender`,')','   (Mobile: ',pm.`Mobile`,')','   (UHID: ',pm.PatientID,')')PName, ");
        sb.Append(" CONCAT(em.title,' ',em.Name)NAME,  DATE_FORMAT(dis.DispatchDate,'%d-%b-%Y')DispatchDate,pam.`PanelGroup` AS Dispatch_No, pmh.`CardNo` AS EmployerName,pmh.`CardHolderName` AS BenefitOption, ");       
        if (Policy == "1")
        {
            //sb.Append(" IF(pmh.PolicyNo!='Select',pmh.PolicyNo,'')PolicyNo ");
           // sb.Append(" IFNULL((SELECT PolicyNo FROM patient_policy_Detail WHERE Patient_ID=pm.Patient_ID AND isactive=1 ORDER BY id DESC LIMIT 1),'')PolicyNo");
           sb.Append(" IF(dis.PolicyNo IS NOT NULL AND dis.PolicyNo<>'',dis.PolicyNo, IFNULL((SELECT PolicyNo FROM `patient_policy_detail` WHERE Patient_ID=dis.`PatientID` ");
           sb.Append(" AND IsActive=1 AND Panel_ID=dis.`PanelID` ORDER BY ID DESC LIMIT 1),''))PolicyNo ");
        }
        else
        {
            sb.Append(" '' PolicyNo ");
        }
        sb.Append(" FROM f_dispatch dis INNER JOIN patient_medical_history pmh ON pmh.transactionID=dis.TransactionID ");
        sb.Append("  INNER JOIN f_ledgertransaction lt ON lt.transactionid=pmh.transactionid INNER JOIN ");
        sb.Append("  f_ledgertnxdetail ltd ON lt.LedgerTransactionNo=ltd.LedgerTransactionNo INNER JOIN employee_master em ON Lt.UserID=EM.EmployeeID ");
        sb.Append("  INNER JOIN Patient_master pm ON pm.PatientID=pmh.PatientID ");
        sb.Append("  INNER JOIN f_panel_master pam ON dis.panelid=pam.panelid  ");
        sb.Append("  WHERE lt.IsCancel=0 AND ltd.isrefund=0  AND ltd.isPackage=0 AND dis.IsDispatched=1 AND dis.isCancel=0 AND IF((SELECT SUM(Amount) FROM panel_amountallocation WHERE TransactionID=dis.TransactionID )<>ConvertCurrencyNew_base(227,dis.panelAmount,dis.BillDate), ltd.`IsPayable`=1,ltd.`IsPayable`IN(1,0))  ");
        if (PanelID != "0")
        {
            sb.Append(" AND dis.panelID='" + PanelID + "'");
        }

        if (DispatchNo != "")
            sb.Append(" AND dis.Dispatch_No='" + DispatchNo.Trim() + "' ");

        if (InvoiceNo != "")
            sb.Append(" AND dis.PanelInvoiceNo='" + InvoiceNo.Trim() + "' ");

        if (UHID != "")
            sb.Append(" AND dis.PatientID='" + UHID.Trim() + "' ");

        if (type != "All")
        {
            sb.Append(" AND dis.type='" + type + "'");
        }

        sb.Append(" UNION ALL ");

        sb.Append(" SELECT dis.Type,dis.PatientID as Patient_ID,dis.panelid as panel_id,pam.Company_name,0 AS BillAmount,0 AS panelAmount,ltd.ItemName,'' Diagnosis,ltd.Quantity,ltd.Rate,Round((ltd.Rate*ltd.Quantity),2)Gross,ltd.DiscAmt,round(ltd.Amount,2)Amount, ");
        sb.Append(" '' BillDate,lt.BillNo,dis.PanelInvoiceNo, CONCAT('PName: ',pm.Title,' ',pm.PName,' (DOB: ',IF(pm.DOB='0001-01-01','',DATE_FORMAT(pm.DOB,'%d-%b-%Y')),')', ");
        sb.Append(" ' (Gender: ',pm.`Gender`,')',' (Mobile: ',pm.`Mobile`,')',' (UHID: ',pm.PatientID,')')PName,CONCAT(em.title,' ',em.Name)NAME,");
        sb.Append(" DATE_FORMAT(dis.DispatchDate,'%d-%b-%Y')DispatchDate,pam.`PanelGroup` as Dispatch_No,pmh.`CardNo` AS Company_Name,pmh.`CardHolderName` AS BenefitOption,'' PolicyNo FROM f_dispatch dis INNER JOIN patient_medical_history pmh ON pmh.transactionID=dis.TransactionID ");
        sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.transactionid=pmh.transactionid INNER JOIN ");
        sb.Append(" f_ledgertnxdetail ltd ON lt.LedgerTransactionNo=ltd.LedgerTransactionNo INNER JOIN employee_master em ON Lt.UserID=EM.EmployeeID ");
        sb.Append(" INNER JOIN Patient_master pm ON pm.PatientID=pmh.PatientID INNER JOIN f_panel_master pam ON dis.panelid=pam.panelid  ");
        sb.Append(" WHERE lt.IsCancel=0 AND ltd.isrefund=0  AND ltd.isPackage=1 AND IF((SELECT SUM(Amount) FROM panel_amountallocation WHERE TransactionID=dis.TransactionID )<>ConvertCurrencyNew_base(227,dis.panelAmount,dis.BillDate), ltd.`IsPayable`=1,ltd.`IsPayable`IN(1,0))  ");
        if (PanelID != "0")
        {
            sb.Append(" AND dis.panelID='" + PanelID + "'");
        }
        if (DispatchNo != "")
            sb.Append(" AND dis.Dispatch_No='" + DispatchNo.Trim() + "' ");

        if (InvoiceNo != "")
            sb.Append(" AND dis.PanelInvoiceNo='" + InvoiceNo.Trim() + "' ");

        if (UHID != "")
            sb.Append(" AND dis.PatientID='" + UHID.Trim() + "' ");

        if (type != "All")
        {
            sb.Append(" AND dis.type='" + type + "'");
        }

        sb.Append(" AND dis.IsDispatched=1 AND dis.isCancel=0 ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = StockReports.GetUserName(Convert.ToString(HttpContext.Current.Session["ID"])).Rows[0][0];
            dt.Columns.Add(dc);
            DataSet ds = new DataSet();

            if (Format == "1")
            {
                ds.Tables.Add(dt.Copy());
                DataTable dtImg = All_LoadData.CrystalReportLogo();
                ds.Tables.Add(dtImg.Copy());
                ds.Tables[1].TableName = "logo";
                DataColumn Dc = new DataColumn();
                Dc.ColumnName = "CurrencyId";
                Dc.DefaultValue = CurrencyId;
                ds.Tables[0].Columns.Add(Dc);
              //  ds.WriteXmlSchema("F:\\dispatchReport.xml");
                HttpContext.Current.Session["ds"] = ds;
                HttpContext.Current.Session["ReportName"] = "dispatchReport";
            }
            else
            {
                //DataRow dtRow = dt.NewRow();
                //dtRow["Patient_ID"] = "Total:";
                //dtRow["Gross"] = dt.Compute("sum(Gross)", "");
                //dtRow["DiscAmt"] = dt.Compute("sum(DiscAmt)", "");
                //dtRow["Amount"] = dt.Compute("sum(Amount)", "");
                //dt.Rows.Add(dtRow);
                HttpContext.Current.Session["dtExport2Excel"] = dt;
                HttpContext.Current.Session["ReportName"] = "Dispatch Report(Detailed)";
            }

            return "1";
        }
        else
        {
            return "0";
        }
    }
}