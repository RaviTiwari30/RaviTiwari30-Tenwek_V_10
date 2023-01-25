using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_IPD_DischargeSlip : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["TransactionID"] != null)
        {
            ViewState["TID"] = Request.QueryString["TransactionID"].ToString(); ;
            string IsBillGenerate = "";

            IsBillGenerate = StockReports.ExecuteScalar(" SELECT IFNULL(BillNo,'')BillNo FROM patient_medical_history WHERE TransactionID='" + ViewState["TID"].ToString() + "'  ");
            if (IsBillGenerate == "")
            {
                string Msg = "Please Generate The Patient Bill!!!";
                Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
            }
            
        }
    }
    protected void btnDischargeSlip_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT ROUND(t2.GrossAmt,2)GrossAmt,ROUND(GrossAmt-TotalDiscount,2)NetAmt, ");
 sb.Append(" (ROUND(GrossAmt-TotalDiscount,2) -ROUND(IFNULL(t3.RecAmt,0.00),2)) OutStanding, ");
 sb.Append(" ROUND(IFNULL(t3.RecAmt,0.00),2)RecAmt,t2.PatientName,t2.PatientID ,t2.BedNo,t2.IPNo,t2.AdmitDate,t2.DischargeDate, ");
 sb.Append("   NOW() AS PrintDateTime,'" + Util.GetString(Session["EmployeeName"].ToString())+ "' PrintedBy  FROM (   ");
    sb.Append("  SELECT ltd.TransactionID,SUM(ltd.GrossAmount)GrossAmt,0 NetAmount,   ");    
    sb.Append("  IFNULL(ROUND(SUM(ltd.TotalDiscAmt)+IFNULL(pmh.DiscountOnBill,0),2),0)TotalDiscount , ");
    sb.Append("  IFNULL(ROUND(SUM(ltd.TotalDiscAmt),2),0)TotalItemWiseDiscount,im.Type_ID,im.ServiceItemID,  ");
    sb.Append("  IFNULL(pmh.PanelApprovedAmt,0)PanelApprovedAmt, ");
     sb.Append(" (IFNULL(pmh.Deduction_Acceptable,'0')+IFNULL(pmh.TDS,'0')+IFNULL(pmh.WriteOff,'0'))TotalDeduction , ");
    sb.Append("  CONCAT( pm.Title,'',pm.PName)PatientName,pm.PatientID, ");
    sb.Append("   CONCAT(rm.Name,'/',rm.Bed_No)BedNo, pmh.TransNo IPNo, ");
   sb.Append("  DATE_FORMAT( CONCAT( IF(DATE(PMH.DateOfAdmit)='0001-01-01',DATE(pmh.DateOfVisit),DATE(PMH.DateOfAdmit)),' ',IF( TIME(pmh.TimeOfAdmit)='00:00:00',TIME(pmh.TIME),TIME(pmh.TimeOfAdmit)) ),'%d-%b-%y %r')AdmitDate, ");
   sb.Append("   DATE_FORMAT(PMH.DateOfDischarge,'%d-%b-%y')DischargeDate "); 
   sb.Append("   FROM f_ledgertnxdetail ltd       ");
  sb.Append("    INNER JOIN f_ledgertransaction LT ON ltd.LedgerTransactionNo = LT.LedgerTransactionNo  ");    
   sb.Append("   INNER JOIN f_itemmaster im ON ltd.ItemID = im.ItemID    ");
   sb.Append("   INNER JOIN Patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID  AND pmh.DischargedBy<>'' "); 
   sb.Append("   INNER JOIN patient_master pm ON pm.PatientID =pmh.PatientID ");
    sb.Append("  INNER JOIN ");
    sb.Append("   ((SELECT pip.TransactionID,pip.PatientID,pip.RoomID FROM  patient_ipd_profile pip WHERE pip.TransactionID='" + ViewState["TID"].ToString() + "' ORDER BY pip.PatientIPDProfile_ID DESC LIMIT 1 ) ");
     sb.Append("         UNION ALL ");
     sb.Append("    SELECT pip.TransactionID,pip.PatientID,pip.RoomID FROM emergency_patient_details pip WHERE pip.TransactionID='" + ViewState["TID"].ToString() + "') t ");
      sb.Append("   ON t.TransactionID=pmh.TransactionID ");
    sb.Append("  INNER JOIN room_master rm ON rm.RoomId=t.RoomID  ");
    sb.Append("  WHERE Lt.IsCancel = 0 AND ltd.IsFree = 0 AND ltd.IsVerified = 1     ");  
    sb.Append("  AND ltd.IsPackage = 0  ");
    sb.Append("  AND lt.TransactionID = '" + ViewState["TID"].ToString() + "'");
   sb.Append("   GROUP BY lt.TransactionID ");
    sb.Append("   )T2 ");
    sb.Append("   LEFT JOIN ( "); 
     sb.Append("  SELECT TransactionID,ROUND(SUM(AmountPaid))RecAmt FROM f_reciept WHERE IsCancel = 0     ");
     sb.Append("   AND TransactionID = '" + ViewState["TID"].ToString() + "' GROUP BY TransactionID  ");
    sb.Append(" )T3 ON T2.TransactionID = T3.TransactionID ");
         
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            ds.Tables[0].TableName = "DischargeSlip";
            Session["ReportName"] = "DischargeSlip";
            Session["ds"] = ds;
          //  ds.WriteXmlSchema(@"E:\DischargeSlip.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
        }
        else
        {
            lblMsg.Text = "Patient Not Discharged.";
        }
    }
}