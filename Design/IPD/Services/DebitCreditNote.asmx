<%@ WebService Language="C#" Class="DebitCreditNote" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Text;
using System.Data;
using System.Linq;

using System.Collections.Generic;
using MySql.Data.MySqlClient;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class DebitCreditNote : System.Web.Services.WebService
{
    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }
    [WebMethod(EnableSession=true)]
    public string SearchPatient(string patientID, string transactionID, string patientName, string billNo)
    {
        if (transactionID != "")
            transactionID = StockReports.getTransactionIDbyTransNo(transactionID.Trim());//"ISHHI" +
        
        StringBuilder sqlCMD = new StringBuilder();
        sqlCMD.Append(" SELECT 'IPD' Type,'' LedgertransactionNo,pmh.TransNo IPDNo,pmh.TransactionID,IF(IFNULL(pmh.BillNo,'')='','false','true')BillStatus, IFNULL(pmh.BillNo,'')BillNo,date_format(pmh.BillDate,'%d-%b-%Y')BillDate,pmh.Type,pip.roomid AS room_id,pip.ipdCaseTypeid AS ipdCaseType_id,pip.status,pip.startDate, ");
        sqlCMD.Append(" pip.IsTempAllocated,CONCAT(pm.title,' ',pm.pname)pname,Replace(pm.PatientID,'LSHHI','')PatientID,CONCAT(rm.Room_No,' / ',rm.Floor)roomno,(select Name from ipd_case_type_master where IPDCaseType_ID =pip.IPDCaseTypeID  limit 1)RoomType, ");
        sqlCMD.Append(" RTRIM(LTRIM(pnl.Company_Name))company_name,pnl.ReferenceCode,pmh.PanelID PanelID, ");
        sqlCMD.Append(" CONCAT(pm.House_No,' ',pm.Locality,' ',pm.City)Address  ");
        sqlCMD.Append(" FROM patient_ipd_profile pip INNER JOIN patient_medical_history pmh ON pip.TransactionID=pmh.TransactionID ");
        sqlCMD.Append("  INNER JOIN patient_master pm  ");//INNER JOIN f_ipdadjustment ipd ON pmh.TransactionID=ipd.TransactionID
        sqlCMD.Append(" ON pm.PatientID = pip.PatientID INNER JOIN room_master rm  ");
        sqlCMD.Append(" ON rm.RoomId  = pip.RoomID INNER JOIN f_panel_master pnl   ");
        sqlCMD.Append(" ON pnl.PanelID  = pip.PanelID INNER JOIN  ");
        sqlCMD.Append(" (SELECT MAX(PatientIPDProfile_ID)PatientIPDProfile_ID  ");
        sqlCMD.Append(" FROM patient_ipd_profile   WHERE STATUS<>'Cancel'  ");
        if (!string.IsNullOrEmpty(patientID))
            sqlCMD.Append(" and PatientID=@vpatientID ");
        if (!string.IsNullOrEmpty(transactionID))
            sqlCMD.Append(" and TransactionID=@vtransactionID");
        sqlCMD.Append(" group by TransactionID) pip1 ");
        sqlCMD.Append(" on pip1.PatientIPDProfile_ID = pip.PatientIPDProfile_ID ");
        sqlCMD.Append(" Where IFNULL(pmh.TransactionID,'')<>'' AND IFNULL(pmh.BillNo,'')<>'' AND pmh.centreID=@vcentreid ");
        if (!string.IsNullOrEmpty(patientID))
            sqlCMD.Append(" AND pip.PatientID=@vpatientID ");
        if (!string.IsNullOrEmpty(patientName))
            sqlCMD.Append(" AND pm.PName like @vpatientName ");
        if (!string.IsNullOrEmpty(billNo))
            sqlCMD.Append(" AND pmh.BillNo=@vbillNo ");
        if (string.IsNullOrEmpty(transactionID.Replace("ISHHI","")))
        {
            sqlCMD.Append("UNION ALL ");
            sqlCMD.Append("SELECT 'OPD' Type,lt.LedgertransactionNo,''IPDNo,lt.TransactionID,IF(IFNULL(lt.BillNo,'')='','false','true')BillStatus,  ");
            sqlCMD.Append("IFNULL(lt.BillNo,'')BillNo,date_format(pmh.BillDate,'%d-%b-%Y')BillDate,pmh.Type,'' room_id,'' ipdCaseType_id,'' STATUS,'' startDate,  '' IsTempAllocated, ");
            sqlCMD.Append("CONCAT(pm.title,' ',pm.pname)pname,REPLACE(pm.PatientID,'LSHHI','')PatientID,'' roomno, ");
            sqlCMD.Append("''RoomType,   ");
            sqlCMD.Append("RTRIM(LTRIM(pnl.Company_Name))company_name,pnl.ReferenceCode,pmh.PanelID PanelID,   ");
            sqlCMD.Append("CONCAT(pm.House_No,' ',pm.Locality,' ',pm.City)Address    ");
            sqlCMD.Append("FROM f_ledgertransaction lt  ");
            sqlCMD.Append("INNER JOIN patient_medical_history pmh ON lt.TransactionID=pmh.TransactionID   ");
            sqlCMD.Append("INNER JOIN patient_master pm  ON pm.PatientID = lt.PatientID  ");
            sqlCMD.Append("INNER JOIN f_panel_master pnl ON pnl.PanelID  = lt.PanelID ");
            sqlCMD.Append("WHERE lt.iscancel=0 AND pmh.centreID=@vcentreid AND lt.Refund_Against_BillNo=''AND IFNULL(lt.BillNo,'')<>'' AND lt.TypeofTnx IN ('OPD-LAB','OPD-APPOINTMENT','OPD-PROCEDURE','OPD-OTHERS','OPD-Billing','EMERGENCY') ");
            if (!string.IsNullOrEmpty(patientID))
                sqlCMD.Append("AND pm.PatientID=@vpatientID ");
            if (!string.IsNullOrEmpty(patientName))
                sqlCMD.Append(" AND pm.PName like @vpatientName ");
            if (!string.IsNullOrEmpty(billNo))
                sqlCMD.Append("AND lt.BillNo=@vbillNo ");
        }
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
        {
            vpatientID = Util.GetFullPatientID(patientID),
            vpatientName = patientName,
            vtransactionID = transactionID,
            vbillNo = billNo,
            vcentreid = HttpContext.Current.Session["CentreID"].ToString()
        });
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public string GetDepartmentWiseDetails(string transactionID, string Type, string LedgertransactionNo)
    {

        var IsInvoiceGenerated = StockReports.ExecuteScalar("SELECT COUNT(*)IsInvoiceGenerated FROM  f_dispatch f WHERE f.TransactionID='" + transactionID + "'");
        if (Util.GetInt(IsInvoiceGenerated) > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Sorry Panel Invoice Generated." });

        var isShareAllocationDone = StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_paymentallocation p WHERE p.TransactionID='" + transactionID + "' AND p.IsActive=1");

        if (Util.GetInt(isShareAllocationDone) > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Sorry Doctor Allocation Done." });


        var dt = new DataTable();
        if (Type == "OPD")
        {
            StringBuilder sqlCMD = new StringBuilder(" SELECT t1.LedgerTransactionNo,'OPD' Type,DisplayName,IF(t1.ConfigID='14','true','false')IsPackage, ");
            sqlCMD.Append(" SUM(t1.Amount) NetAmt, ");
            sqlCMD.Append(" SUM(t1.Quantity) Qty,CONCAT(t1.CategoryID,'#',t1.ConfigID)Category FROM (  ");
            sqlCMD.Append("SELECT lt.LedgerTransactionNo LedgerTransactionNo,ltd.Amount,ltd.Quantity,ltd.SubcategoryID ,ltd.ConfigID,cm.CategoryID, ");
            sqlCMD.Append("cm.Name DisplayName   ");
            sqlCMD.Append("FROM f_ledgertnxdetail ltd INNER JOIN f_ledgertransaction LT ON ltd.LedgerTransactionNo = LT.LedgerTransactionNo   ");
            sqlCMD.Append("INNER JOIN f_subcategorymaster scm ON ltd.SubCategoryID = scm.SubCategoryID   ");
            sqlCMD.Append("INNER JOIN f_categorymaster cm ON scm.CategoryID = cm.CategoryID  ");
            sqlCMD.Append("WHERE Lt.IsCancel = 0 AND ltd.IsVerified = 1 AND ltd.IsPackage = 0 AND lt.LedgertransactionNo=@LedgertransactionNo AND ltd.ConfigID NOT IN (11,7) ");
            sqlCMD.Append("   )t1 GROUP BY t1.ConfigID,t1.DisplayName  ");
            ExcuteCMD excuteCMD = new ExcuteCMD();
            dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
            {
                LedgertransactionNo = LedgertransactionNo
            });
        }
        if (Type == "IPD")
        {
            StringBuilder sqlCMD = new StringBuilder(" SELECT t1.LedgerTransactionNo,'IPD' Type,DisplayName,IF(t1.ConfigID='14','true','false')IsPackage, ");
            sqlCMD.Append(" SUM(t1.Amount) NetAmt, ");
            sqlCMD.Append(" SUM(t1.Quantity) Qty,CONCAT(t1.CategoryID,'#',t1.ConfigID)Category FROM (  ");
            sqlCMD.Append("   SELECT lt.LedgerTransactionNo,ltd.Amount,ltd.Quantity,ltd.subcategoryID ,ltd.ConfigID,cm.CategoryID, ");
            sqlCMD.Append("   IF(ltd.isAttendentRoom=1,'ATTENDENT ROOM',cm.Name)DisplayName ");
            sqlCMD.Append("   FROM f_ledgertnxdetail ltd INNER JOIN f_ledgertransaction LT  ON ltd.LedgerTransactionNo = LT.LedgerTransactionNo  ");
            sqlCMD.Append("   INNER JOIN f_subcategorymaster SM ON ltd.SubCategoryID = SM.SubCategoryID  INNER JOIN f_categorymaster cm ON sm.CategoryID = cm.CategoryID");
            sqlCMD.Append("   WHERE Lt.IsCancel = 0 AND  ltd.IsVerified = 1 AND ltd.IsPackage = 0 AND ltd.IsSurgery = 0  AND ltd.ConfigID NOT IN (11,7) ");
            sqlCMD.Append("   AND lt.TransactionID =@transactionID ");
            sqlCMD.Append("   UNION ALL");
            sqlCMD.Append("   SELECT DISTINCT(lt.LedgerTransactionNo),lt.NetAmount,1 Quantity,ltd.SubcategoryID ,ltd.ConfigID,cm.CategoryID,");
            sqlCMD.Append("   IF(ltd.isAttendentRoom=1,'AttendentRoom Room',cm.Name)DisplayName  ");
            sqlCMD.Append("   FROM f_ledgertnxdetail ltd INNER JOIN f_ledgertransaction LT ON ltd.LedgerTransactionNo = LT.LedgerTransactionNo  ");
            sqlCMD.Append("   INNER JOIN f_subcategorymaster SM ON ltd.SubCategoryID = SM.SubCategoryID  ");
            sqlCMD.Append("   INNER JOIN f_categorymaster cm ON sm.CategoryID = cm.CategoryID ");
            sqlCMD.Append("   WHERE Lt.IsCancel = 0 AND ltd.IsVerified = 1 AND ltd.IsPackage = 0 AND ltd.IsSurgery = 1 AND ltd.ConfigID NOT IN (11,7) AND lt.TransactionID =@transactionID");
            sqlCMD.Append("   )t1 GROUP BY t1.ConfigID,t1.DisplayName  ");

            ExcuteCMD excuteCMD = new ExcuteCMD();
            dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
            {
                transactionID = transactionID
            });
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = dt });
    }

    [WebMethod]
    public string GetPanelList(string Type, string LedgerTransactionNo, string TransactionID)
    {
        var dt = new DataTable();
        if (Type == "OPD")
            dt = StockReports.GetDataTable("SELECT pm.PanelID AS PanelID,pm.Company_Name FROM f_ledgertransaction lt INNER JOIN f_panel_master pm ON pm.PanelID=lt.PanelID WHERE lt.LedgertransactionNo=" + LedgerTransactionNo + "");
        else if (Type == "IPD")
        {
            dt = StockReports.GetDataTable("SELECT pa.PanelID,pm.Company_Name FROM panel_amountallocation pa INNER JOIN f_panel_master pm ON pm.PanelID=pa.PanelID WHERE TransactionID='" + TransactionID + "' GROUP BY PanelID");
            if (dt.Rows.Count == 0)
            {
                dt = StockReports.GetDataTable("SELECT pnl.PanelID AS PanelID,pnl.Company_Name FROM patient_medical_history pmh INNER JOIN f_panel_master pnl ON pnl.PanelID=pmh.PanelID WHERE pmh.TransactionID='" + TransactionID + "'");
            }
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public string GetDepartmentItemDetails(string transactionID, string configID, string categoryID, string displayName, string Type, string LedgerTransactionNo)
    {
        string TransID = Convert.ToString(transactionID);
        string DispName = Convert.ToString(categoryID);
        string ConfigID = Convert.ToString(configID);
        StringBuilder sb = new StringBuilder();





        if (Type == "OPD")
        {
            sb.Append("Select 'OPD' Type,t.* FROM (SELECT IF(ltd.ConfigID=5,CONCAT('DR. ',im.TypeName),concat(dm.Title,' ',dm.Name))CashCollectedDoctor, ltd.ID,lt.LedgerTransactionNo,ltd.ItemID,ltd.ItemName,''IPDNo,lt.TransactionID, ");
            sb.Append("SUM(ltd.Quantity)Quantity,SUM(ltd.DiscountPercentage)DiscPer,SUM(ltd.DiscAmt)DiscAmt,(SUM(ltd.Rate)*SUM(ltd.Quantity))Amount,SUM(ltd.Amount)NetAmount,ltd.SubcategoryID ,ltd.ConfigID,cm.CategoryID,  ");
            sb.Append("IF(IFNULL(scm.DisplayName,'') = '',scm.Name,scm.DisplayName) DisplayName, ");
            sb.Append("(SELECT  ROUND(IFNULL(SUM(ltdc.Amount),0),0) * -1 FROM `f_ledgertnxdetail` ltdc WHERE ltdc.LedgerTnxRefID != -1 AND ltdc.LedgerTnxRefID=ltd.ID ");
            sb.Append("AND ltdc.`IsVerified`=1 AND ltdc.Typeoftnx='CR') CreditAmount, ");
            sb.Append("(SELECT  ROUND(IFNULL(SUM(ltdd.Amount),0),0) FROM `f_ledgertnxdetail` ltdd WHERE ltdd.LedgerTnxRefID != -1 AND ltdd.LedgerTnxRefID=ltd.ID ");
            sb.Append("AND ltdd.`IsVerified`=1 AND ltdd.Typeoftnx='DR') DebitAmount,DATE_FORMAT(ltd.EntryDate,'%d-%b-%Y') EntryDate  ");
            sb.Append("FROM f_ledgertnxdetail ltd  ");
            sb.Append("INNER JOIN f_ItemMaster im ON ltd.ItemID = im.ItemID   ");
            sb.Append("LEFT JOIN Doctor_Master dm ON dm.DoctorID = ltd.DoctorID  ");
            sb.Append("INNER JOIN f_ledgertransaction LT ON ltd.LedgerTransactionNo = LT.LedgerTransactionNo    ");
            sb.Append("INNER JOIN f_subcategorymaster scm ON ltd.SubCategoryID = scm.SubCategoryID    ");
            sb.Append("INNER JOIN f_categorymaster cm ON scm.CategoryID = cm.CategoryID  WHERE Lt.IsCancel = 0  ");
            sb.Append("AND ltd.IsVerified = 1 AND ltd.IsPackage = 0  ");
            sb.Append("AND lt.LedgertransactionNo=" + LedgerTransactionNo + " AND ltd.ConfigID=" + configID + " And cm.CategoryID='" + categoryID + "'  GROUP BY ltd.LedgerTransactionNo,ltd.ItemID) t ");
        }
        if (Type == "IPD")
        {
            switch (ConfigID)
            {
                case "22": // Surgery Case
                    sb.Append("Select 'IPD' Type,t.* FROM (SELECT '' CashCollectedDoctor,ltd.ID,lt.LedgerTransactionNo,ltd.ItemID,ltd.ItemName,Replace(lt.TransactionID,'ISHHI','') IPDNo,lt.TransactionID, ");
                    sb.Append("SUM(ltd.Quantity)Quantity,SUM(ltd.DiscountPercentage)DiscPer,SUM(ltd.DiscAmt)DiscAmt,(SUM(ltd.Rate)*SUM(ltd.Quantity))Amount,SUM(ltd.Amount)NetAmount,ltd.SubcategoryID ,ltd.ConfigID,cm.CategoryID,  ");
                    sb.Append("IF(IFNULL(scm.DisplayName,'') = '',scm.Name,scm.DisplayName) DisplayName, ");
                    sb.Append("(SELECT  ROUND(IFNULL(SUM(ltdc.Amount),0),0) * -1 FROM `f_ledgertnxdetail` ltdc WHERE ltdc.LedgerTnxRefID != -1 AND ltdc.LedgerTnxRefID=ltd.ID ");
                    sb.Append("AND ltdc.`IsVerified`=1 AND ltdc.Typeoftnx='CR') CreditAmount, ");
                    sb.Append("(SELECT  ROUND(IFNULL(SUM(ltdd.Amount),0),0) FROM `f_ledgertnxdetail` ltdd WHERE ltdd.LedgerTnxRefID != -1 AND ltdd.LedgerTnxRefID=ltd.ID ");
                    sb.Append("AND ltdd.`IsVerified`=1 AND ltdd.Typeoftnx='DR') DebitAmount,DATE_FORMAT(ltd.EntryDate,'%d-%b-%Y') EntryDate  ");
                    sb.Append("FROM f_ledgertnxdetail ltd  ");
                    sb.Append("INNER JOIN f_ledgertransaction LT ON ltd.LedgerTransactionNo = LT.LedgerTransactionNo    ");
                    sb.Append("INNER JOIN f_subcategorymaster scm ON ltd.SubCategoryID = scm.SubCategoryID    ");
                    sb.Append("INNER JOIN f_categorymaster cm ON scm.CategoryID = cm.CategoryID  WHERE Lt.IsCancel = 0  ");
                    sb.Append("AND ltd.IsVerified = 1 AND ltd.IsPackage = 0 AND IsSurgery=1  ");
                    sb.Append("AND ltd.TransactionID='" + TransID + "' AND ltd.ConfigID=" + configID + " And cm.CategoryID='" + categoryID + "' GROUP BY ltd.LedgerTransactionNo,ltd.ItemID) t ");
                    break;
                default:
                    sb.Append("Select 'IPD' Type,t.* FROM (SELECT ltd.ID,lt.LedgerTransactionNo,ltd.ItemID,ltd.ItemName,Replace(lt.TransactionID,'ISHHI','') IPDNo,lt.TransactionID, ");
                    sb.Append("SUM(ltd.Quantity)Quantity,SUM(ltd.DiscountPercentage)DiscPer,SUM(ltd.DiscAmt)DiscAmt,(SUM(ltd.Rate)*SUM(ltd.Quantity))Amount,SUM(ltd.Amount)NetAmount,ltd.SubcategoryID ,ltd.ConfigID,cm.CategoryID,  ");
                    sb.Append("IF(IFNULL(scm.DisplayName,'') = '',scm.Name,scm.DisplayName) DisplayName, ");
                    sb.Append("(SELECT  ROUND(IFNULL(SUM(ltdc.Amount),0),0) * -1 FROM `f_ledgertnxdetail` ltdc WHERE ltdc.LedgerTnxRefID != -1 AND ltdc.LedgerTnxRefID=ltd.ID ");
                    sb.Append("AND ltdc.`IsVerified`=1 AND ltdc.Typeoftnx='CR') CreditAmount, ");
                    sb.Append("(SELECT  ROUND(IFNULL(SUM(ltdd.Amount),0),0) FROM `f_ledgertnxdetail` ltdd WHERE ltdd.LedgerTnxRefID != -1 AND ltdd.LedgerTnxRefID=ltd.ID ");
                    sb.Append("AND ltdd.`IsVerified`=1 AND ltdd.Typeoftnx='DR') DebitAmount,DATE_FORMAT(ltd.EntryDate,'%d-%b-%Y') EntryDate  ");
                    sb.Append("FROM f_ledgertnxdetail ltd  ");
                    sb.Append("INNER JOIN f_ledgertransaction LT ON ltd.LedgerTransactionNo = LT.LedgerTransactionNo    ");
                    sb.Append("INNER JOIN f_subcategorymaster scm ON ltd.SubCategoryID = scm.SubCategoryID    ");
                    sb.Append("INNER JOIN f_categorymaster cm ON scm.CategoryID = cm.CategoryID  WHERE Lt.IsCancel = 0  ");
                    sb.Append("AND ltd.IsVerified = 1 AND ltd.IsPackage = 0  ");
                    sb.Append("AND ltd.TransactionID='" + TransID + "' AND ltd.ConfigID=" + configID + " And cm.CategoryID='" + categoryID + "' GROUP BY ltd.LedgerTransactionNo,ltd.ItemID) t ");
                    break;
            }
        }
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = dt ,q = sb.ToString()});
    }

    [WebMethod(EnableSession = true)]
    public string SaveCreditDebitDetails(List<drcrnote> creditDebitDetails, string patientID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        DataTable dtDocCollect = new DataTable();

        decimal GrossAmt = 0;
        decimal discountAmount = 0;
        decimal netAmount = 0;
        decimal cashCollectedDocShare = 0;

        int IsMultiPanel = 1;
        decimal DebitAmount = 0;
        string cashCollectedDoctorID = string.Empty;
        string sqlDocCollect = string.Empty;

        try
        {
            var billNo = Util.GetString(excuteCMD.ExecuteScalar("Select BillNo from f_Ledgertransaction where TransactionID=@transactionID and (BillNo is not null or BillNo <>'') Limit 1", new
            {
                transactionID = creditDebitDetails[0].TransactionID

            }));

            var patientLedgerNumber = Util.GetString(excuteCMD.ExecuteScalar("SELECT lm.LedgerNumber FROM f_ledgermaster lm WHERE lm.LedgerUserID=@patientID", new
            {
                patientID = patientID

            }));
            var patientType = "";
            if (creditDebitDetails[0].CRDRNoteType == 1)
                patientType = "CR";
            else if (creditDebitDetails[0].CRDRNoteType == 2)
                patientType = "CD";
            else if (creditDebitDetails[0].CRDRNoteType == 3)
                patientType = "DR";
            else if (creditDebitDetails[0].CRDRNoteType == 4)
                patientType = "DD";
            string creditDebitNumber = Util.GetString(excuteCMD.ExecuteScalar(tnx, "select get_CrDrNo(CURRENT_DATE(),@patientType,@unit)", CommandType.Text, new
            {
                patientType = patientType,
                unit = Session["CentreID"].ToString()
            }));
            if (creditDebitNumber == "0")
            {
                tnx.Rollback();
                tnx.Dispose();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Credit & Debit No Error." });
            }
            for (int i = 0; i < creditDebitDetails.Count; i++)
            {
                 
                DebitAmount = DebitAmount + creditDebitDetails[i].Amount;
                 
                
                drcrnote _drcrnote = new drcrnote(tnx);
                _drcrnote.CRDR = creditDebitDetails[i].CRDR;
                _drcrnote.CrDrNo = creditDebitNumber;
                _drcrnote.TransactionID = creditDebitDetails[i].TransactionID;
                _drcrnote.Amount = creditDebitDetails[i].Amount;
                _drcrnote.EntryDateTime = System.DateTime.Now;
                _drcrnote.PtTYPE = creditDebitDetails[i].PtTYPE;
                _drcrnote.BillNo = billNo;
                _drcrnote.LedgerName = patientLedgerNumber;
                _drcrnote.Narration = creditDebitDetails[i].Narration;
                _drcrnote.ItemID = creditDebitDetails[i].ItemID;
                _drcrnote.UserID = Session["ID"].ToString();
                _drcrnote.ItemName = creditDebitDetails[i].ItemName;
                _drcrnote.LedgerTnxID = creditDebitDetails[i].LedgerTnxID;
                _drcrnote.LedgerTransactionNo = creditDebitDetails[i].LedgerTransactionNo;
                _drcrnote.CentreID = Util.GetInt(Session["CentreID"].ToString());
                _drcrnote.PanelID = creditDebitDetails[i].PanelID;
                _drcrnote.CRDRNoteType = creditDebitDetails[i].CRDRNoteType;
                _drcrnote.Insert();

                decimal Rate = 0;
                decimal DiscountAmount = 0;
                decimal DiscountPercentage = 0;
                decimal Amount = 0;

                if (creditDebitDetails[i].CRDRNoteType == 1)
                {
                    Rate = creditDebitDetails[i].Amount * -1;
                    Amount = creditDebitDetails[i].Amount * -1;
                }
                else if (creditDebitDetails[i].CRDRNoteType == 2)
                {
                    Rate = 0;
                    DiscountAmount = creditDebitDetails[i].Amount;
                    DiscountPercentage = Math.Round(((100 * DiscountAmount) / creditDebitDetails[i].Rate), 2);
                    Amount = creditDebitDetails[i].Amount * -1;
                }
                if (creditDebitDetails[i].CRDRNoteType == 3)
                {
                    Rate = creditDebitDetails[i].Amount;
                    Amount = creditDebitDetails[i].Amount;
                }
                else if (creditDebitDetails[i].CRDRNoteType == 4)
                {
                    Rate = 0;
                    DiscountAmount = creditDebitDetails[i].Amount * -1;
                    DiscountPercentage = Math.Round(((100 * DiscountAmount) / creditDebitDetails[i].Rate), 2);
                    Amount = creditDebitDetails[i].Amount;
                }
                var Ledgertnxdetail = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "CALL Insert_CRDR_ledgertnxdetail(@vTypeofTnx,@vLedgerTnxID,@vAmount,@vUserID,@vpageURL, " +
                    "@vCentreID,@vRoleID,@vIpAddress,@vcreditDebitNumber,@vRate,@vDiscountPercentage,@vDiscAmt)", CommandType.Text, new
                {
                    vTypeofTnx = creditDebitDetails[i].CRDR,
                    vLedgerTnxID = creditDebitDetails[i].LedgerTnxID,
                    vAmount = Amount,
                    vUserID = Session["ID"].ToString(),
                    vpageURL = All_LoadData.getCurrentPageName(),
                    vCentreID = Session["CentreID"].ToString(),
                    vRoleID = Session["RoleID"].ToString(),
                    vIpAddress = All_LoadData.IpAddress(),
                    vcreditDebitNumber = creditDebitNumber,
                    vRate = Rate,
                    vDiscountPercentage = DiscountPercentage,
                    vDiscAmt = DiscountAmount
                }));
                var LedgerTransacionUpdate = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "CALL Insert_CRDR_f_ledgertransaction(@vLedgerTransactionNo)", CommandType.Text, new
                {
                    vLedgerTransactionNo = creditDebitDetails[i].LedgerTransactionNo
                }));
                if (creditDebitDetails[i].Type == "OPD")
                {
                    if (creditDebitDetails[i].PtTYPE == "PTNT")
                    {
                        var pmh = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "UPDATE patient_medical_history pmh SET pmh.PatientPaybleAmt= (pmh.PatientPaybleAmt + (@vnewAmount)) WHERE pmh.TransactionID=@vTransactionID", CommandType.Text, new
                        {
                            vTransactionID = creditDebitDetails[i].TransactionID,
                            vnewAmount = Amount
                        }));
                    }
                    if (creditDebitDetails[i].PtTYPE == "PAN")
                    {
                        var pmh = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "UPDATE patient_medical_history pmh SET pmh.PanelPaybleAmt= (pmh.PanelPaybleAmt + (@vnewAmount)) WHERE pmh.TransactionID=@vTransactionID", CommandType.Text, new
                        {
                            vTransactionID = creditDebitDetails[i].TransactionID,
                            vnewAmount = Amount
                        }));
                    }
                }
                //else if (creditDebitDetails[i].Type == "IPD" && Util.GetInt(creditDebitDetails[i].PanelID) != Util.GetInt(Resources.Resource.DefaultPanelID))
                //{
                //    var sqlCMD = "INSERT INTO panel_amountallocation (PanelID, TransactionID, Amount, EntryBy, EntryType ) VALUES (@panelID,@transactionID,@amount,@userID,@allocationType)";
                //    var amtall = Util.GetInt(excuteCMD.ExecuteScalar(tnx, sqlCMD, CommandType.Text, new
                //    {
                //        panelID = creditDebitDetails[i].PanelID,
                //        transactionID = creditDebitDetails[i].TransactionID,
                //        amount = Amount,
                //        userID = Session["ID"].ToString(),
                //        allocationType = creditDebitDetails[i].CRDR
                //    }));
                //}


                if (creditDebitDetails[i].isDocCollect == 1)
                {
                    dtDocCollect = StockReports.GetDataTable("SELECT ltd.DoctorShareAmt,ltd.GrossAmt,ltd.DiscAmt,ltd.NetAmt,ltd.DoctorID FROM f_DocShare_TransactionDetail ltd WHERE ltd.LedgerTnxID='" + creditDebitDetails[i].LedgerTnxID + "' UNION ALL SELECT ltd.DoctorShareAmt,ltd.GrossAmt,ltd.DiscAmt,ltd.NetAmt,ltd.DoctorID FROM f_DocShare_TransactionDetail_lab ltd WHERE ltd.LedgerTnxID='" + creditDebitDetails[i].LedgerTnxID + "' UNION ALL SELECT 0 DoctorShareAmt,ltd.GrossAmount AS GrossAmt,ltd.DiscAmt,ltd.NetItemAmt AS NetAmt ,IF(ltd.ConfigID=5,im.Type_ID,ltd.DoctorID)  AS DoctorID FROM f_LedgerTnxDetail ltd  INNER JOIN f_ItemMaster im ON im.ItemID=ltd.ItemID WHERE ltd.ID='" + creditDebitDetails[i].LedgerTnxID + "' LIMIT 1 ");

                    GrossAmt = Util.GetDecimal(dtDocCollect.Rows[0]["GrossAmt"].ToString());
                    discountAmount = Util.GetDecimal(dtDocCollect.Rows[0]["DiscAmt"].ToString());
                    netAmount = Util.GetDecimal(dtDocCollect.Rows[0]["NetAmt"].ToString());
                    cashCollectedDocShare = Util.GetDecimal(dtDocCollect.Rows[0]["DoctorShareAmt"].ToString());
                    cashCollectedDoctorID = Util.GetString(dtDocCollect.Rows[0]["DoctorID"].ToString());

                    sqlDocCollect = "INSERT INTO f_Doctor_Self_Collection(PatientID,TransactionID,ItemID,DoctorID,GrossAmt,DiscAmt,NetAmt,DocCollection,DocShare,HospShare,EntryDate,EntryBy,PageURL,CentreID) VALUES(@PatientID, @TransactionID, @ItemID, @DoctorID, @GrossAmt, @DiscAmt, @NetAmt, @DocCollection, @DocShare, @HospShare,NOW(), @EntryBy,@PageURL,@CentreID)";
                    excuteCMD.DML(tnx, sqlDocCollect, CommandType.Text, new
                    {
                        PatientID = patientID,
                        TransactionID = Util.GetString(creditDebitDetails[i].TransactionID).Trim(),
                        ItemID = Util.GetString(creditDebitDetails[i].ItemID).Trim(),
                        DoctorID = cashCollectedDoctorID,
                        GrossAmt = GrossAmt,
                        DiscAmt = discountAmount,
                        NetAmt = netAmount,
                        DocCollection = Util.GetDecimal(creditDebitDetails[i].docCollectAmt),
                        DocShare = cashCollectedDocShare,
                        HospShare = netAmount - cashCollectedDocShare,
                        EntryBy = HttpContext.Current.Session["ID"].ToString(),
                        PageURL = All_LoadData.getCurrentPageName(),
                        CentreID = HttpContext.Current.Session["CentreID"].ToString()
                    });
                }

            }
            if (Resources.Resource.AllowFiananceIntegration == "1")
            {
                string IsIntegrated = Util.GetString(EbizFrame.TransferToEss_DebitCreditNote(creditDebitDetails[0].TransactionID, creditDebitNumber, tnx));
                if (IsIntegrated == "0")
                {
                    tnx.Rollback();
                    tnx.Dispose();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Integration Error." });
                }
            }

            PanelAllocation Pa = new PanelAllocation();

            IsMultiPanel = Pa.IsMultipanel(creditDebitDetails[0].TransactionID);

            bool IsmulPanels = true;
            
            if (IsMultiPanel == 0)
            {
                Pa.InserDrNotesEntry(creditDebitDetails[0].TransactionID, Util.GetDecimal(DebitAmount), tnx);
                IsmulPanels = false;
            
            }
            else if (IsMultiPanel == 2)
            {
                IsmulPanels = false;
            }      
            
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { IsMultiPanel = IsmulPanels, PatientId = patientID, TransactionId = creditDebitDetails[0].TransactionID,Amount=DebitAmount, status = true, response = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { IsMultiPanel = false, PatientId = "", TransactionId = "", Amount = 0, status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}