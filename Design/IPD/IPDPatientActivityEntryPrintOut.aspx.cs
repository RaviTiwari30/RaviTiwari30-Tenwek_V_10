using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_IPD_IPDPatientActivityEntryPrintOut : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            if (Request.QueryString["TransactionID"] != null && Request.QueryString["TransactionID"] != "")
            {
                ViewState["TID"] = Request.QueryString["TransactionID"].ToString();
            }
            else
            {
                ViewState["TID"] = Request.QueryString["TID"].ToString();
            }
            AllLoadData_IPD.fromDatetoDate(Util.GetString(ViewState["TID"]), txtFromDate, txtToDate, calFromDate, calToDate);
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        StringBuilder sql = new StringBuilder();
        //sql.Append(" SELECT (CASE WHEN im.type_ID='S' THEN CONCAT(ItemName,'(', IFNULL((SELECT dm.`Name` FROM f_surgery_discription sdr ");
        //sql.Append(" INNER JOIN `f_itemmaster` itm ON sdr.ItemID=itm.ItemID AND itm.Type_ID IN ('S')  ");
        //sql.Append(" INNER JOIN f_surgery_DOctor sd ON sd.SurgeryTransactionID=sdr.SurgeryTransactionID   ");
        //sql.Append(" INNER JOIN `doctor_master` dm ON dm.`DoctorID`=sd.`DoctorID`  ");
        //sql.Append(" WHERE sdr.LedgerTransactionNo=t1.LedgerTransactionNo AND sdr.`ItemID`=t1.itemid),''), ')')  ");
        //sql.Append(" WHEN im.type_ID='D' THEN CONCAT(ItemName,'(', IFNULL((SELECT dm.`Name` FROM f_surgery_discription sdr  ");
        //sql.Append(" INNER JOIN `f_itemmaster` itm ON sdr.ItemID=itm.ItemID AND itm.Type_ID IN ('D') ");
        //sql.Append(" INNER JOIN f_surgery_DOctor sd ON sd.SurgeryTransactionID=sdr.SurgeryTransactionID   ");
        //sql.Append(" INNER JOIN `doctor_master` dm ON dm.`DoctorID`=sd.`DoctorID`  ");
        //sql.Append(" WHERE sdr.LedgerTransactionNo=t1.LedgerTransactionNo AND sdr.`ItemID`=t1.itemid),''), ')')  ");
        //sql.Append(" ELSE CONCAT(itemname,IF(IFNULL(t1.itemcode,'')<>'',CONCAT('(',t1.itemcode,')'),'')) ");
        //sql.Append(" END )itemname, LedgerTransactionNo,Amount,T1.ItemID,Rate,Quantity,StockID,DiscountPercentage,IsPackage,PackageID,IsVerified,t1.SubCategoryID,VarifiedUserID, ");

        //sql.Append("   TransactionID,VerifiedDate,UserID,EntryDate,EntryTime,DiscountAmount,LTDetailID,SubCategory, ");
        //sql.Append("  DisplayName,DisplayPriority,DisplayPriority,t1.IsSurgery,t1.surgeryID,t1.SurgeryName,t1.DiscountReason,t1.UserName,IF(t1.Type_ID='',im.Type_ID,t1.Type_ID)Type_ID,im.ServiceItemID,(Rate*Quantity)GrossAmt, ");
        //sql.Append("  IFNULL(dm.Specialization,'')Specialization,IFNULL(CONCAT(dm.Title,' ',dm.Name),'')Doctor,t1.IsPayable,t1.ConfigID,t1.Itemcode,t1.PatientID FROM ( ");
        //sql.Append("  SELECT LTD.LedgerTransactionNo,LTD.Amount,LTD.ItemID,LTD.Rate,LTD.Quantity,LTD.StockID,");
        //sql.Append("  LTD.DiscountPercentage,LTD.IsPackage,LTD.PackageID,LTD.IsVerified,LTD.SubCategoryID, ");
        //sql.Append("  LTD.VarifiedUserID,LTD.ItemName,LTD.TransactionID,");
        //sql.Append("  DATE_FORMAT(LTD.VerifiedDate,'%d-%b-%Y')VerifiedDate,LTD.LedgerTnxID AS LTDetailID,");
        //sql.Append("  LTD.UserID,DATE_FORMAT(LTD.EntryDate,'%d-%b-%Y')EntryDate,TIME_FORMAT(LTD.EntryDate,'%h:%i %p')EntryTime,");
        //sql.Append("  (((Rate * Quantity)*DiscountPercentage)/100) DiscountAmount,IFNULL(ltd.Type_ID,'')Type_ID, ");
        //sql.Append("  SC.Name AS SubCategory,SC.DisplayName,SC.DisplayPriority,LTD.IsSurgery,");
        //sql.Append("  LTD.surgeryID,LTD.SurgeryName,LTD.DiscountReason,EM.Name AS UserName,LTD.IsPayable,LTD.`ConfigID`,   ");
        //sql.Append("  ltd.`rateItemCode` itemcode,lt.`PatientID`,ltd.DoctorID  ");
        //sql.Append("  FROM f_ledgertnxdetail LTD INNER JOIN f_ledgertransaction LT ON ");
        //sql.Append("  LT.LedgerTransactionNo = LTD.LedgerTransactionNo INNER JOIN ");
        //sql.Append("  f_subcategorymaster SC ON SC.SubcategoryID = LTD.SubcategoryID ");
        //sql.Append("  INNER JOIN employee_master EM ON EM.EmployeeID = LTD.UserID ");
        //sql.Append("  WHERE LT.TransactionID = '" + Request.QueryString["TransactionID"].ToString() + "' AND LTD.Isverified =1    ");
        //sql.Append("  )t1 LEFT JOIN f_itemmaster im ON im.itemid = t1.ItemID ");
        //sql.Append("  LEFT JOIN doctor_master dm ON dm.DoctorID=t1.DoctorID ");
        //sql.Append("  where t1.VerifiedDate>='" + Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + "' AND t1.VerifiedDate<='" + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy") + "'");
        //if (Util.GetInt(Session["RoleID"]) != 3)
        //    sql.Append("  AND t1.USERID ='" + Util.GetString(Session["ID"]) + "' ");
        //sql.Append(" GROUP BY LTDetailID ORDER BY t1.DisplayName, t1.SubCategoryID,t1.ItemID, ");
        //sql.Append("  DATE(t1.EntryDate) ");
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT (CASE WHEN im.type_ID='S' THEN CONCAT(ItemName,'(', IFNULL((SELECT dm.`Name` FROM f_surgery_discription sdr  INNER JOIN `f_itemmaster` itm ON sdr.ItemID=itm.ItemID AND itm.Type_ID IN ('S')   INNER JOIN f_surgery_DOctor sd ON sd.SurgeryTransactionID=sdr.SurgeryTransactionID    INNER JOIN `doctor_master` dm ON dm.`DoctorID`=sd.`DoctorID`   WHERE sdr.LedgerTransactionNo=t1.LedgerTransactionNo AND sdr.`ItemID`=t1.itemid),''), ')')    ");
        sb.Append("WHEN im.type_ID='D' THEN CONCAT(ItemName,'(', IFNULL((SELECT dm.`Name` FROM f_surgery_discription sdr   INNER JOIN `f_itemmaster` itm ON sdr.ItemID=itm.ItemID AND itm.Type_ID IN ('D')  INNER JOIN f_surgery_DOctor sd ON sd.SurgeryTransactionID=sdr.SurgeryTransactionID    INNER JOIN `doctor_master` dm ON dm.`DoctorID`=sd.`DoctorID`   WHERE sdr.LedgerTransactionNo=t1.LedgerTransactionNo AND sdr.`ItemID`=t1.itemid),''), ')')    ");
        sb.Append("ELSE itemname  END )itemname,Amount,T1.ItemID,Rate,Quantity, TransactionID,DATE_FORMAT(EntryDate,'%d-%b-%Y %h:%i %p')EntryDate,DiscountAmount,LTDetailID,   DisplayName, ");
        sb.Append("DisplayPriority,t1.IsSurgery,t1.surgeryID,t1.SurgeryName,t1.DiscountReason,t1.UserName,(Rate*Quantity)GrossAmt, IFNULL(dm.Specialization,'')Specialization, ");
        sb.Append("IFNULL(CONCAT(dm.Title,' ',dm.Name),'')Doctor,t1.ConfigID FROM ( ");
        sb.Append("SELECT lt.LedgerTransactionNo,LTD.ItemID,LTD.Rate,LTD.Quantity,(((Rate * Quantity)*DiscountPercentage)/100) DiscountAmount,LTD.Amount,LTD.ItemName,LTD.TransactionID,LTD.LedgerTnxID AS LTDetailID, ");
        sb.Append("LTD.EntryDate, SC.Name AS SubCategory,SC.DisplayName,SC.DisplayPriority,LTD.IsSurgery,  ");
        sb.Append("LTD.surgeryID,LTD.SurgeryName, LTD.DiscountReason,EM.Name AS UserName,LTD.`ConfigID`,ltd.DoctorID  ");
        sb.Append("FROM f_ledgertnxdetail LTD   INNER JOIN f_ledgertransaction LT ON   LT.LedgerTransactionNo = LTD.LedgerTransactionNo ");
        sb.Append("INNER JOIN   f_subcategorymaster SC ON SC.SubcategoryID = LTD.SubcategoryID INNER JOIN employee_master EM ON EM.EmployeeID = LTD.UserID ");
        sb.Append("WHERE LT.TransactionID = '" + ViewState["TID"].ToString() + "' AND LTD.Isverified <>2       ");
        sb.Append(")t1 LEFT JOIN f_itemmaster im ON im.itemid = t1.ItemID   LEFT JOIN doctor_master dm ON dm.DoctorID=t1.DoctorID    ");
        sb.Append("WHERE  t1.entrydate>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' AND t1.entrydate<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'  ");
        sb.Append("GROUP BY LTDetailID ORDER BY t1.DisplayName,t1.EntryDate ");
        DataTable Activity = StockReports.GetDataTable(sb.ToString());
        var ActivityRow = 0;
        var ActivityRemarks = 0;
        if (Activity.Rows.Count > 0)
            ActivityRow = 1;
        StringBuilder query = new StringBuilder();
        query.Append(" SELECT DATE_FORMAT(EntryDateTime,'%d-%b-%Y')EntryDate,TIME_FORMAT(EntryDateTime,'%h:%i %p')EntryTime,BillingRemarks as ActivityRemarks,EnteryUserName ");
        query.Append(" FROM f_IPD_BillingRemarks WHERE TransactionID='" + ViewState["TID"].ToString() + "' AND billingType='Remark' ");
        query.Append(" AND EntryDateTime >='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' AND EntryDateTime <='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
        DataTable dtActivityRemarks = StockReports.GetDataTable(query.ToString());
        if (dtActivityRemarks.Rows.Count > 0)
            ActivityRemarks = 1;

        if (ActivityRow == 1 || ActivityRemarks == 1)
        {
            StringBuilder sql1 = new StringBuilder();

            sql1.Append(" SELECT MRNo AS PatientID,IPDNo AS TransactionID,DateOfAdmit,TimeOfAdmit,DateOfDischarge,TimeOfDischarge,Room_No,BedNo,FLOOR,BedCategory,DoctorName ");
            sql1.Append(" AS ConsultantName, PatientName,Age,Gender,Mobile,Company_Name,Source,Dept,DischargeStatus,Diagnosis,Remarks, ");
            sql1.Append(" Approval,ActivityPlanned,TreatmentRemarks,CentreID,CentreName,Deposit FROM ( SELECT pm.PatientID MRNo,pmh.TransNo IPDNo, ");
            sql1.Append(" DATE_FORMAT(pmh.DateOfAdmit,'%d-%b-%Y')DateOfAdmit,TIME_FORMAT(pmh.TimeOfAdmit,'%h:%i %p')TimeOfAdmit, ");
            sql1.Append(" DATE_FORMAT(pmh.DateOfDischarge,'%d-%b-%Y')DateOfDischarge, TIME_FORMAT(pmh.TimeOfDischarge,'%h:%i %p')TimeOfDischarge,rm.Bed_No ");
            sql1.Append(" AS BedNo,rm.Floor,rm.Room_No,ctm.Name AS BedCategory,  IF(IFNULL(pmh.DoctorID1,'')=CONCAT(dm.title,'',dm.Name),'', ");
            sql1.Append(" (SELECT REPLACE(GROUP_CONCAT(CONCAT(doctorname,'')),',',' / ') FROM f_multipledoctor_ipd WHERE transactionID= pmh.TransactionID))DoctorName, ");
            sql1.Append(" UPPER(CONCAT(pm.Title,' ',pm.PName))PatientName,pm.Age,pm.Gender,pm.Mobile,pnl.Company_Name,PMH.Source, ");
            sql1.Append(" (SELECT DISTINCT(Department) FROM doctor_hospital WHERE DoctorID = pmh.DoctorID)AS Dept,'' AS DischargeStatus,  ");
            sql1.Append(" (SELECT ProvisionalDiagnosis FROM cpoe_PatientDiagnosis WHERE TransactionID=ip.TransactionID)Diagnosis,pmh.Remarks, ROUND((SELECT SUM(ltd.Amount)  ");
            sql1.Append(" FROM f_ledgertnxdetail ltd WHERE  TransactionID = ip.TransactionID AND IsPackage = 0 AND IsVerified = 1)) AS BillAmt, ");
            sql1.Append(" ROUND((SELECT IFNULL(SUM(AmountPaid),0) FROM f_reciept WHERE TransactionID = ip.TransactionID AND IsCancel = 0))AS Deposit, ");
            sql1.Append(" ROUND(IFNULL(SUM(pmh.PanelApprovedAmt),0))AS Approval  , ");
            sql1.Append(" pmh.ActivityPlanned,pmh.TreatmentRemarks,cm.`CentreID`,cm.`CentreName`  FROM patient_ipd_profile ip ");
            sql1.Append(" INNER JOIN patient_medical_history PMH ON IP.TransactionID = PMH.TransactionID ");
            sql1.Append(" INNER JOIN center_master cm ON cm.`CentreID`=pmh.`CentreID` ");
            sql1.Append(" INNER JOIN room_master rm ON rm.RoomId = ip.RoomId INNER JOIN ipd_case_type_master ctm ON ctm.IPDCaseTypeID = rm.IPDCaseTypeID ");
            sql1.Append(" INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID INNER JOIN patient_master pm ON pm.PatientID = ip.PatientID ");
            sql1.Append(" INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID WHERE pmh.CentreID IN ('" + Util.GetInt(Session["CentreID"].ToString()) + "')  AND ip.TransactionID='" + ViewState["TID"].ToString() + "' ");
            sql1.Append(" ORDER BY ip.PatientIPDProfile_ID DESC )t group by TransactionID ");

            DataTable dtHeader = StockReports.GetDataTable(sql1.ToString());

            DataColumn dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");
            dtHeader.Columns.Add(dc);

            DataSet ds = new DataSet();
            ds.Tables.Add(Activity.Copy());
            ds.Tables[0].TableName = "Activity";
            ds.Tables.Add(dtActivityRemarks.Copy());
            ds.Tables[1].TableName = "Remarks";
            ds.Tables.Add(dtHeader.Copy());
            ds.Tables[2].TableName = "PHeader";

            Session["ReportName"] = "NwardActivityReport";
            Session["ds"] = ds;
            lblMsg.Text = "";
            // ds.WriteXml(@"E:\NwardActivityReport.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
        }
        else
        {
            lblMsg.Text = "No Record Found...!!!";
        }
    }



}