<%@ WebService Language="C#" Class="CommonService" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Script;
using System.Collections.Generic;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.Web.Script.Services.ScriptService]
public class CommonService  : System.Web.Services.WebService {

    [WebMethod]
    public bool CompareDate(string DateFrom, string DateTo)
    {
        return Util.CompareDate(DateFrom, DateTo);
    }

    [WebMethod]
    public string SearchBill(string InvoiceNo, string IPNo, string FromDate, string ToDate,string IsTPAInvActive)
    {
        string result = "0";

        StringBuilder Query = new StringBuilder();

        Query.Append(" SELECT adj.PanelID,REPLACE(adj.PatientID,'LSHHI','') AS MRNo,REPLACE(adj.TransactionID,'ISHHI','') AS IPNo,pm.PName,pnl.Company_Name AS Panel,adj.ClaimNo,adj.BillNo,  ");
        Query.Append(" adj.TotalBilledAmt BillAmt,tid.DocketNo,tid.DispatchedBy,IF(adj.IsTPAInvActive=1,'Yes','No')IsTPAInvActive, ");
        Query.Append(" adj.TPAInvNo,DATE_FORMAT(ich.DateOfAdmit,'%d-%b-%Y')DateOfAdmit,DATE_FORMAT(ich.DateOfDischarge,'%d-%b-%Y')DateOfDischarge, ");
        Query.Append(" DATE_FORMAT(adj.BillDate,'%d-%b-%Y')BillDate,DATE_FORMAT( STR_TO_DATE(tid.DispatchDate, '%d-%b-%Y'),'%d-%b-%Y')DispatchDate, ");
        Query.Append(" DATE_FORMAT(adj.TPAInvDate,'%d-%b-%Y')TPAInvoiceDate, DATE_FORMAT(tdd.ReceivingDate,'%d-%b-%Y')ReceivingDate, ");
        Query.Append(" IFNULL(DATE_FORMAT(tdd.UpdateDate,'%d-%b-%Y'),'')UploadedDate,IFNULL(DATE_FORMAT(adj.TPAInvClosedDate,'%d-%b-%Y'),'')TPAInvClosedDate ");        
        Query.Append(" FROM f_ipdadjustment adj ");
        Query.Append(" INNER JOIN ipd_case_history ich ON adj.TransactionID=ich.TransactionID ");
        Query.Append(" INNER JOIN f_panel_master pnl ON adj.PanelID=pnl.PanelID ");
        Query.Append(" INNER JOIN Patient_Master pm ON adj.PatientID=pm.PatientID ");
        Query.Append(" LEFT JOIN tpa_invoice_detail tid ON adj.TransactionID=tid.TransactionID  ");
        Query.Append(" LEFT JOIN f_tpadocument_detail tdd ON adj.TPAInvNo=tdd.TPAInvNo ");
        Query.Append(" WHERE adj.IsBilledClosed=1 AND adj.PanelID<>1 AND adj.IsTPAInvActive='" + IsTPAInvActive + "' ");                                      
        
        if (InvoiceNo != "")
        {
            Query.Append("AND tid.TPAInvNo='" + InvoiceNo + "' ");
        }
        if (IPNo != "")
        {
            Query.Append("AND tid.TransactionID='ISHHI" + IPNo + "' ");
        }
        if (InvoiceNo == "" && IPNo == "")
        {
            if(IsTPAInvActive=="0")                
            Query.Append("And adj.BillDate>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND adj.BillDate<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' ");
            else if (IsTPAInvActive == "1")    
            Query.Append("And tid.TPAInvoiceDate>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND tid.TPAInvoiceDate<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' ");
        }

        Query.Append("order by tid.TPAInvNo,tid.TransactionID");

        DataTable dt = StockReports.GetDataTable(Query.ToString());

        if (dt.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

        return result;

    }


    [WebMethod]
    public string getBillsPendingforDispatchInvoiceSummary(string FromDate, string ToDate)
    {
        string result = "0";
        StringBuilder Query = new StringBuilder();
        Query.Append(" SELECT PanelID,Panel,COUNT(*)TotalBills FROM ( ");
        Query.Append(" SELECT adj.PanelID,REPLACE(adj.PatientID,'LSHHI','') AS MRNo,REPLACE(adj.TransactionID,'ISHHI','') AS IPNo,pm.PName,pnl.Company_Name AS Panel,adj.ClaimNo,adj.BillNo,  ");
        Query.Append(" adj.TotalBilledAmt BillAmt,tid.DocketNo,tid.DispatchedBy,IF(adj.IsTPAInvActive=1,'Yes','No')IsTPAInvActive, ");
        Query.Append(" adj.TPAInvNo,DATE_FORMAT(ich.DateOfAdmit,'%d-%b-%Y')DateOfAdmit,DATE_FORMAT(ich.DateOfDischarge,'%d-%b-%Y')DateOfDischarge, ");
        Query.Append(" DATE_FORMAT(adj.BillDate,'%d-%b-%Y')BillDate,DATE_FORMAT( STR_TO_DATE(tid.DispatchDate, '%d-%b-%Y'),'%d-%b-%Y')DispatchDate, ");
        Query.Append(" DATE_FORMAT(adj.TPAInvDate,'%d-%b-%Y')TPAInvoiceDate, DATE_FORMAT(tdd.ReceivingDate,'%d-%b-%Y')ReceivingDate, ");
        Query.Append(" IFNULL(DATE_FORMAT(tdd.UpdateDate,'%d-%b-%Y'),'')UploadedDate,IFNULL(DATE_FORMAT(adj.TPAInvClosedDate,'%d-%b-%Y'),'')TPAInvClosedDate ");
        Query.Append(" FROM f_ipdadjustment adj ");
        Query.Append(" INNER JOIN ipd_case_history ich ON adj.TransactionID=ich.TransactionID ");
        Query.Append(" INNER JOIN f_panel_master pnl ON adj.PanelID=pnl.PanelID ");
        Query.Append(" INNER JOIN Patient_Master pm ON adj.PatientID=pm.PatientID ");
        Query.Append(" LEFT JOIN tpa_invoice_detail tid ON adj.TransactionID=tid.TransactionID  ");
        Query.Append(" LEFT JOIN f_tpadocument_detail tdd ON adj.TPAInvNo=tdd.TPAInvNo ");
        Query.Append(" WHERE adj.IsBilledClosed=1 AND adj.PanelID<>1 AND adj.TPAInvNo IS NULL  ");
        Query.Append(" And adj.BillDate>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND adj.BillDate<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' ");
        Query.Append(" order by tid.TPAInvNo,tid.TransactionID");
        Query.Append(" )t GROUP BY PanelID ");
        DataTable dt = StockReports.GetDataTable(Query.ToString());
        if (dt.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        return result;
    }

    [WebMethod]
    public string BillsPendingforDispatchInvoiceDetail(string FromDate, string ToDate, string PanelID)
    {
        string result = "0";
        StringBuilder Query = new StringBuilder();
        Query.Append(" SELECT adj.PanelID,REPLACE(adj.PatientID,'LSHHI','') AS MRNo,REPLACE(adj.TransactionID,'ISHHI','') AS IPNo,pm.PName,pnl.Company_Name AS Panel,adj.ClaimNo,adj.BillNo,  ");
        Query.Append(" adj.TotalBilledAmt BillAmt,tid.DocketNo,tid.DispatchedBy,IF(adj.IsTPAInvActive=1,'Yes','No')IsTPAInvActive, ");
        Query.Append(" adj.TPAInvNo,DATE_FORMAT(ich.DateOfAdmit,'%d-%b-%Y')DateOfAdmit,DATE_FORMAT(ich.DateOfDischarge,'%d-%b-%Y')DateOfDischarge, ");
        Query.Append(" DATE_FORMAT(adj.BillDate,'%d-%b-%Y')BillDate,DATE_FORMAT( STR_TO_DATE(tid.DispatchDate, '%d-%b-%Y'),'%d-%b-%Y')DispatchDate, ");
        Query.Append(" DATE_FORMAT(adj.TPAInvDate,'%d-%b-%Y')TPAInvoiceDate, DATE_FORMAT(tdd.ReceivingDate,'%d-%b-%Y')ReceivingDate, ");
        Query.Append(" IFNULL(DATE_FORMAT(tdd.UpdateDate,'%d-%b-%Y'),'')UploadedDate,IFNULL(DATE_FORMAT(adj.TPAInvClosedDate,'%d-%b-%Y'),'')TPAInvClosedDate ");
        Query.Append(" FROM f_ipdadjustment adj ");
        Query.Append(" INNER JOIN ipd_case_history ich ON adj.TransactionID=ich.TransactionID ");
        Query.Append(" INNER JOIN f_panel_master pnl ON adj.PanelID=pnl.PanelID ");
        Query.Append(" INNER JOIN Patient_Master pm ON adj.PatientID=pm.PatientID ");
        Query.Append(" LEFT JOIN tpa_invoice_detail tid ON adj.TransactionID=tid.TransactionID  ");
        Query.Append(" LEFT JOIN f_tpadocument_detail tdd ON adj.TPAInvNo=tdd.TPAInvNo ");
        Query.Append(" WHERE adj.IsBilledClosed=1 AND adj.PanelID<>1 AND adj.TPAInvNo IS NULL  ");
        Query.Append("And adj.BillDate>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND adj.BillDate<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' AND adj.PanelID=" + PanelID + " ");
        Query.Append("order by tid.TPAInvNo,tid.TransactionID");

        DataTable dt = StockReports.GetDataTable(Query.ToString());
        if (dt.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        return result;
    }
    
       [WebMethod]
    public string getInvoiceAckNotReceivedSummary(string FromDate, string ToDate)
    {
        string result = "0";
        StringBuilder Query = new StringBuilder();           
        Query.Append("     SELECT PanelID,Panel,COUNT(*)TotalBills FROM ( ");
        Query.Append("     SELECT ti.PanelID,pm.Company_Name Panel,ti.TPAInvNo,DATE_FORMAT(ti.TPAInvDate,'%d-%b-%Y %h:%i %p')TPAInvDate,DATE_FORMAT(tdd.ReceivingDate,'%d-%b-%Y')ReceivingDate FROM f_generate_tpa_invoice ti ");
        Query.Append("     LEFT JOIN f_tpadocument_detail tdd ON ti.TPAInvNo=tdd.TPAInvNo  ");
        Query.Append("     INNER JOIN f_panel_master pm ON ti.PanelID=pm.PanelID ");
        Query.Append("     WHERE ti.TPAInvDate>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND ti.TPAInvDate<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' AND tdd.ReceivingDate IS NULL ");
        Query.Append("     order by ti.TPAInvNo ");
        Query.Append("     )t GROUP BY PanelID ");                                 
        DataTable dt = StockReports.GetDataTable(Query.ToString());
        if (dt.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        return result;
    }

    [WebMethod]
    public string getInvoiceAckNotReceivedDetail(string FromDate, string ToDate, string PanelID)
    {
        string result = "0";
        StringBuilder Query = new StringBuilder();
        Query.Append("     SELECT ti.PanelID,pm.Company_Name Panel,ti.TPAInvNo,DATE_FORMAT(ti.TPAInvDate,'%d-%b-%Y %h:%i %p')TPAInvDate,DATE_FORMAT(tdd.ReceivingDate,'%d-%b-%Y')ReceivingDate FROM f_generate_tpa_invoice ti ");
        Query.Append("     LEFT JOIN f_tpadocument_detail tdd ON ti.TPAInvNo=tdd.TPAInvNo  ");
        Query.Append("     INNER JOIN f_panel_master pm ON ti.PanelID=pm.PanelID ");
        Query.Append("     WHERE ti.TPAInvDate>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND ti.TPAInvDate<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' AND tdd.ReceivingDate IS NULL AND ti.PanelID="+PanelID+" ");
        Query.Append("     order by ti.TPAInvNo ");
        DataTable dt = StockReports.GetDataTable(Query.ToString());
        if (dt.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        return result;
    }
    
      [WebMethod]
    public string getInvoiceAckNotReceivedBillDetail(string FromDate, string ToDate, string TPAInvNo)
    {
        string result = "0";
        StringBuilder Query = new StringBuilder();                 
        Query.Append("   SELECT PanelID,REPLACE(PatientID,'LSHHI','') AS MRNo,REPLACE(TransactionID,'ISHHI','') AS IPNo,PName,TPA AS Panel,ClaimNo,BillNo, "); 
        Query.Append("   BillAmt,DocketNo,DispatchedBy,TPAInvNo,DATE_FORMAT(DateOfAdmit,'%d-%b-%Y')DateOfAdmit,DATE_FORMAT(DateOfDischarge,'%d-%b-%Y')DateOfDischarge, ");
        Query.Append("   DATE_FORMAT( STR_TO_DATE(BillDate, '%d-%b-%Y'),'%d-%b-%Y')BillDate,DATE_FORMAT( STR_TO_DATE(DispatchDate, '%d-%b-%Y'),'%d-%b-%Y')DispatchDate, ");
        Query.Append("   DATE_FORMAT(TPAInvoiceDate,'%d-%b-%Y')TPAInvoiceDate,TPAInvNo FROM tpa_invoice_detail ");
        Query.Append("   WHERE TPAInvoiceDate>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND TPAInvoiceDate<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' AND TPAInvNo='" + TPAInvNo + "' ");
        Query.Append("   ORDER BY BillNo  ");
        DataTable dt = StockReports.GetDataTable(Query.ToString());
        if (dt.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        return result;
    }

    [WebMethod]
    public string getInvoiceAckReceivedSummary(string ToDate)
    {
        string result = "0";
        StringBuilder Query = new StringBuilder();
        Query.Append("  SELECT PanelID,Panel,COUNT(*)TotalBills FROM ( ");
        Query.Append("      SELECT ti.PanelID,pm.Company_Name Panel,REPLACE(tid.PatientID,'LSHHI','')MRNo,REPLACE(tid.TransactionID,'ISHHI','')IPNo,tid.BillNo,ti.TPAInvNo, ");
	    Query.Append("      DATE_FORMAT(ti.TPAInvDate,'%d-%b-%Y %h:%i %p')TPAInvDate,DATE_FORMAT(tdd.ReceivingDate,'%d-%b-%Y')ReceivingDate FROM f_generate_tpa_invoice ti ");
	    Query.Append("      INNER JOIN f_tpadocument_detail tdd ON ti.TPAInvNo=tdd.TPAInvNo  ");
	    Query.Append("      INNER JOIN tpa_invoice_detail tid ON ti.TPAInvNo=tid.TPAInvNo ");
        Query.Append("      INNER JOIN f_panel_master pm ON ti.PanelID=pm.PanelID ");
        Query.Append("      WHERE ti.TPAInvDate<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' AND tdd.ReceivingDate IS NOT NULL ");
        Query.Append("      order by ti.TPAInvNo ");
        Query.Append("  )t GROUP BY PanelID ");                                     
        
        DataTable dt = StockReports.GetDataTable(Query.ToString());
        if (dt.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        return result;
    }

    [WebMethod]
    public string getPanelWiseProcessList(string PanelID)
    {
        string result = "0";
        StringBuilder Query = new StringBuilder();        
        Query.Append("  SELECT tpm.PanelID,pm.ProcessID,pm.Name,IF(pm.IsActive=1,'Yes','No')Active FROM TPA_Process_Master tpm ");
        Query.Append("  INNER JOIN Process_Master pm ON tpm.ProcessID=pm.ProcessID ");
        Query.Append("  WHERE tpm.PanelID=" + PanelID + " ");                
        DataTable dt = StockReports.GetDataTable(Query.ToString());
        if (dt.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        return result;
    }

    [WebMethod]
    public string getPanelWiseProcessBillDetail(string PanelID,string ProcessID)
    {
        string result = "0";
        StringBuilder Query = new StringBuilder();
        Query.Append("  SELECT tpm.PanelID,pnl.Company_Name Panel,rad.TPAInvNo,pm.ProcessID,pm.Name,REPLACE(rad.TransactionID,'ISHHI','')IPNo,rad.BillNo, ");
        Query.Append("  (SELECT CONCAT(Title,' ',PName) FROM patient_master WHERE PatientID=pmh.`PatientID`)PName,");
        Query.Append("  DATE_FORMAT(rad.TargetDate,'%d-%b-%Y %h:%i %p')TargetDate,DATE_FORMAT(rad.ExpectedDate,'%d-%b-%Y')ExpectedDate,rad.UserRemark, ");
        Query.Append("  (SELECT CONCAT(Title,' ',NAME) FROM Employee_Master WHERE Employee_ID=rad.CreatedBy)CreatedBy,DATE_FORMAT(rad.CreatedDate,'%d-%b-%Y %h:%i %p')CreatedDate ");
        Query.Append("  FROM tpa_process_master tpm ");
        Query.Append("  INNER JOIN Process_Master pm ON tpm.ProcessID=pm.ProcessID ");
        Query.Append("  INNER JOIN recovery_action_detail rad ON tpm.ProcessID=rad.ProcessID ");
        Query.Append("  INNER JOIN f_panel_master pnl ON tpm.PanelID=pnl.PanelID ");
        Query.Append("  INNER JOIN tpa_process_close tpc ON rad.TransactionID=tpc.TransactionID AND rad.ProcessID=tpc.ProcessID ");
        Query.Append("  INNER JOIN patient_medical_history pmh ON rad.TransactionID=pmh.TransactionID ");
        Query.Append("  WHERE tpm.PanelID= " + PanelID + " AND rad.ProcessID='" + ProcessID + "' AND rad.IsTPAQuery=0 AND tpc.IsClosed=0 ");
        Query.Append("  ORDER BY rad.TransactionID ");        
        
        DataTable dt = StockReports.GetDataTable(Query.ToString());
        if (dt.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        return result;
    }

    [WebMethod]
    public string getTPAQuery(string ToDate)
    {
        string result = "0";
        StringBuilder Query = new StringBuilder();
        Query.Append("  SELECT QueryID,Name,COUNT(*)TotalBills FROM ( ");
        Query.Append("  SELECT tid.PanelID,tid.TPA Panel,REPLACE(tid.PatientID,'LSHHI','')MRNo,REPLACE(tid.TransactionID,'ISHHI','')IPNo,tid.BillNo, ");
        Query.Append("  DATE_FORMAT(tid.TPAInvoiceDate,'%d-%b-%Y %h:%i %p')TPAInvDate,rad.QueryID,qm.Name");
        Query.Append("  FROM tpa_invoice_detail tid ");
        Query.Append("  INNER JOIN recovery_action_detail rad ON tid.TPAInvNo=rad.TPAInvNo ");
        Query.Append("  INNER JOIN tpa_query_master qm ON rad.QueryID=qm.QueryID ");
        Query.Append("  WHERE tid.TPAInvoiceDate<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' AND rad.IsTPAQuery=1 AND rad.IsQueryResolved=0 ");
        Query.Append("  )t GROUP BY QueryID ");
        DataTable dt = StockReports.GetDataTable(Query.ToString());
        if (dt.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        return result;
    }
  
    [WebMethod]
    public string getTPAQueryDetail(string QueryID)
    {
        string result = "0";
        StringBuilder Query = new StringBuilder();
        Query.Append("  SELECT tid.PanelID,tid.TPA Panel,REPLACE(tid.PatientID,'LSHHI','')MRNo,tid.PName,REPLACE(tid.TransactionID,'ISHHI','')IPNo,tid.BillNo, ");
        Query.Append("  DATE_FORMAT(tid.TPAInvoiceDate,'%d-%b-%Y %h:%i %p')TPAInvDate,rad.QueryID,qm.Name,");
        Query.Append("  DATE_FORMAT(rad.TargetDate,'%d-%b-%Y %h:%i %p')TargetDate,DATE_FORMAT(rad.ExpectedDate,'%d-%b-%Y')ExpectedDate,rad.UserRemark, ");
        Query.Append("  CONCAT(em.Title,' ',em.Name)CreatedBy,DATE_FORMAT(rad.CreatedDate,'%d-%b-%Y %h:%i %p')CreatedDate ");
        Query.Append("  FROM tpa_invoice_detail tid ");
        Query.Append("  INNER JOIN recovery_action_detail rad ON tid.TPAInvNo=rad.TPAInvNo ");
        Query.Append("  INNER JOIN employee_master em ON rad.CreatedBy=em.Employee_ID ");
        Query.Append("  INNER JOIN tpa_query_master qm ON rad.QueryID=qm.QueryID ");
        Query.Append("  WHERE rad.QueryID='" + QueryID + "' AND rad.IsTPAQuery=1 AND rad.IsQueryResolved=0 ");
        DataTable dt = StockReports.GetDataTable(Query.ToString());
        if (dt.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        return result;
    }

    
}

