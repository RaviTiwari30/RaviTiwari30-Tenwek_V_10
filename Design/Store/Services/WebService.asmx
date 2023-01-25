<%@ WebService Language="C#" Class="WebService" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using MySql.Data.MySqlClient;
using System.Text;
using System.Web.Script.Services;
using System.Web.Script.Serialization;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.ComponentModel;

using System.IO;
using System.Drawing;
using System.Drawing.Drawing2D;
using MW6BarcodeASPNet;


[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.ComponentModel.ToolboxItem(false)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class WebService : System.Web.Services.WebService
{

    GetEncounterNo Encounter = new GetEncounterNo();
    int EncounterNo = 0;
    int PoolNr = 0;
    string PoolDesc = "";
    
    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }
    [WebMethod(EnableSession = true)]
    public string addItemByItemID(string ItemID, decimal Qty, string DeptLedgerNo)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append("Select ST.stockid,IM.TypeName ItemName,ST.ItemID,ST.BatchNumber,IFNULL(get_New_PriceByRange(" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + ",IM.SubcategoryID,ST.UnitPrice) ,0)MRP,ST.UnitPrice,");
        sb.Append("(ST.InitialCount - ST.ReleasedCount)AvlQty,IM.SubCategoryID,im.isexpirable,");
        sb.Append("date_format(ST.MedExpiryDate,'%d-%b-%Y')MedExpiryDate,ST.UnitType,im.ToBeBilled,");
        sb.Append("im.Type_ID,im.IsUsable,im.ServiceItemID,'' MedID,0 isItemWiseDisc,");

        sb.Append(" st.HSNCode,st.IGSTPercent,st.IGSTAmtPerUnit,st.SGSTPercent,st.SGSTAmtPerUnit,st.CGSTPercent,st.CGSTAmtPerUnit,st.GSTType, ");
        //
        sb.Append(" st.PurTaxPer,st.SaleTaxPer VAT FROM f_stock ST ");
        sb.Append(" INNER JOIN f_itemmaster IM on ST.ItemID=IM.ItemID INNER JOIN f_subcategorymaster sub ON sub.SubcategoryID=IM.SubcategoryID ");
        sb.Append(" INNER JOIN f_configrelation CR on sub.CategoryID = CR.CategoryID WHERE (ST.InitialCount - ST.ReleasedCount) > 0 and ST.IsPost = 1 ");
        sb.Append(" AND CR.ConfigID = 11 AND IM.ItemID ='" + ItemID + "' AND st.CentreID = " + HttpContext.Current.Session["CentreID"].ToString() + " ");
        sb.Append(" AND st.DeptLedgerNo='" + DeptLedgerNo + "'   ");
        sb.Append(" AND (IF(im.IsExpirable = 'NO','2050-01-01',st.MedExpiryDate) >= CURDATE())  order by st.MedExpiryDate ASC");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "TotalQty";
            dc.DefaultValue = Util.round(Util.GetDecimal(dt.Compute("sum(AvlQty)", "")));
            dt.Columns.Add(dc);
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }
    [WebMethod]
    public string BindMedicine(string PatientId, string FromDate, string ToDate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT fi.Typename,if(pm.outsource=1,'Yes','No')outsource  FROM f_itemmaster fi INNER JOIN patient_medicine pm ON SUBSTRING_INDEX(pm.Medicine_ID,'#',1)=fi.itemid where pm.PatientID ='" + PatientId + "' ");
        if (FromDate != "" && ToDate != "")
        {
            sb.Append(" AND DATE(pm.Date)>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND DATE(pm.Date)<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'");
        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);


    }

    [WebMethod(EnableSession = true)]
    public string updateInvoiceDetails(int ledgerTransactionNo, string challanNo, string challanDate, string invoiceNumber, string invoiceDate, string grnNumber)
    {
        //dev

        string InvoiceDate = Util.GetDateTime(invoiceDate).ToString("yyyy-MM-dd");
        if (InvoiceDate == string.Empty)
        {
            InvoiceDate = "0001-01-01";
        }
        string ChalanDate = Util.GetDateTime(challanDate).ToString("yyyy-MM-dd"); ;
        if (ChalanDate == string.Empty)
        {
            ChalanDate = "0001-01-01";
        }

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction objTran = con.BeginTransaction(IsolationLevel.ReadCommitted);
        try
        {
            int InvoicePosted = Util.GetInt(MySqlHelper.ExecuteScalar(objTran, CommandType.Text, "SELECT COUNT(*) FROM f_stock st INNER JOIN  f_ledgertransaction lt ON lt.LedgertransactionNo=st.LedgertransactionNo INNER JOIN ess.trans$grn g ON g.GRN_NO=lt.BillNo WHERE st.LedgertransactionNo=" + ledgerTransactionNo + " AND g.INVOICE_NO<>'' "));
            if (InvoicePosted > 0)
            {
                objTran.Rollback();
                objTran.Dispose();
                con.Close();
                con.Dispose();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Data Already Posted To Finance..", message = "Data Already Posted To Finance.." });
            }
            int IsInvoiceNumberExist = Util.GetInt(MySqlHelper.ExecuteScalar(objTran, CommandType.Text, "SELECT COUNT(*) FROM f_stock st WHERE st.LedgertransactionNo<>" + ledgerTransactionNo + " AND st.InvoiceNo='" + invoiceNumber + "' AND st.VenLedgerNo=(SELECT s.VenLedgerNo FROM f_stock s WHERE s.LedgertransactionNo=" + ledgerTransactionNo + " LIMIT 1) "));
            if (IsInvoiceNumberExist > 0)
            {
                objTran.Rollback();
                objTran.Dispose();
                con.Close();
                con.Dispose();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Invoice Number Already Exist.." });
            }
            string str = "update f_stock set Updatedate=now(), InvoiceNo = '" + invoiceNumber + "',InvoiceDate = '" + InvoiceDate + "',ChalanNo = '" + challanNo + "',ChalanDate = '" + ChalanDate + "' where LedgerTransactionNo=" + ledgerTransactionNo + " ";
            MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, str);

            str = "update f_ledgertransaction SET EditDateTime=now(),EditUserID='" + HttpContext.Current.Session["ID"].ToString() + "', InvoiceNo = '" + invoiceNumber + "',ChalanNo = '" + challanNo + "' where LedgerTransactionNo =" + ledgerTransactionNo + " ";
            MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, str);

            str = "update f_invoicemaster set Updatedate=now(),InvoiceNo = '" + invoiceNumber + "',InvoiceDate = '" + InvoiceDate + "',ChalanNo = '" + challanNo + "',ChalanDate = '" + ChalanDate + "' where LedgerTnxNo=" + ledgerTransactionNo + " ";
            MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, str);

            //if (Resources.Resource.AllowFiananceIntegration == "1")
            //{

            //int IsTransfer = Util.GetInt(MySqlHelper.ExecuteScalar(objTran, CommandType.Text, "select count(*) from `ess`.`TRANS$GRN` WHERE GRN_NO='" + grnNumber + "' and TRANS_TYPE=18 AND INVOICE_NO = ''; "));
            //if (IsTransfer > 0)
            //{
            //    string sqlCMD = "INSERT INTO ess.trans$grn (PO_NO,GRN_NO,INVOICE_NO,SUPPLIER_NAME,TRANS_DATE,ITEM_NAME,ITEM_ID,ITEM_CLASS,ITM_SR_NO,TRANS_TYPE_FA, " +
            //    " QTY,PER_UNIT_PUR_PRICE,TOT_PUR_PRICE,IMP_FLG,PB_VOU_ID,CURRENCY,CURR_CONV,BRANCH_ID,DEST_BRANCH_ID,REF_DATE,TAX_AMT,TAX_PER,INV_FLG,  " +
            //    " TRANS_TYPE,REF_PO_NUMBER,LedgertnxID,IsInvoiceUpdate) SELECT   " +
            //    " PO_NO,GRN_NO,'" + invoiceNumber + "',SUPPLIER_NAME,CURRENT_DATE(),ITEM_NAME,ITEM_ID,ITEM_CLASS,ITM_SR_NO,TRANS_TYPE_FA,  " +
            //    " QTY,PER_UNIT_PUR_PRICE,TOT_PUR_PRICE,IMP_FLG,PB_VOU_ID,CURRENCY,CURR_CONV,BRANCH_ID,DEST_BRANCH_ID,'" + InvoiceDate + "',TAX_AMT,TAX_PER,'Y',  " +
            //    " TRANS_TYPE,REF_PO_NUMBER,LedgertnxID,1 " +
            //    " FROM ess.trans$grn g WHERE g.GRN_NO='" + grnNumber + "' AND g.INVOICE_NO='' ";
            //    int IsIntegrate = Util.GetInt(MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, sqlCMD));

            //    if (IsIntegrate == 0)
            //    {
            //        objTran.Rollback();
            //        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Finance Integration" });
            //    }
            //}
            // }

            objTran.Commit();
            objTran.Dispose();
            con.Close();
            con.Dispose();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.errorMessage, message = "Invoice Detail updated Successfully" });
        }
        catch (Exception ex)
        {
            objTran.Rollback();
            objTran.Dispose();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error Occured !" });
        }
    }

    [WebMethod(EnableSession = true)]
    public string ShowStock(string ItemId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT st.InitialCount Qty,st.BatchNumber,st.UnitPrice,IFNULL(get_New_PriceByRange(" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + ",ST.SubcategoryID,ST.UnitPrice) ,0)MRP,st.PurTaxPer,st.DiscPer,st.SaleTaxPer,  ");
        sb.Append(" DATE_FORMAT(st.MedExpiryDate,'%d-%b-%Y')MedExpiryDate,St.ItemName,St.GSTType,St.SGSTPercent,St.CGSTPercent,St.IGSTPercent   FROM f_stock st ");
        // sb.Append(" INNER JOIN f_ledgertransaction lt ON st.LedgerTransactionNo=lt.LedgerTransactionNo WHERE  st.ItemID='" + ItemId.Split('#')[0].ToString() + "' AND lt.TypeOfTnx='StockUpdate' ");
        sb.Append("  WHERE  st.ItemID='" + ItemId.Split('#')[0].ToString() + "' AND st.TypeOfTnx='StockUpdate' ORDER BY stockid DESC  ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public string bindItem()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CONCAT(ItemID,'#',LowStock)ItemID,CONCAT(TypeName,' # (',NAME,')',' # ',AvailableQty)ItemName ");
        sb.Append(" FROM ( ");
        sb.Append(" SELECT im.ItemID,im.typename,sm.name,AvailableQty,IF(AvailableQty<ls.MinLevel,1,0) LowStock  ");
        sb.Append(" FROM (  ");
        sb.Append(" SELECT ItemID,(SUM(InitialCount) - SUM(ReleasedCount))AvailableQty ");
        sb.Append(" FROM f_stock  ");
        sb.Append(" WHERE (InitialCount - ReleasedCount) > 0  AND IsPost = 1 AND  DeptLedgerNo='LSHHI57'   ");
        sb.Append(" AND MedExpiryDate>CURDATE()  GROUP BY ItemID  )t1 INNER JOIN f_itemmaster im ON t1.itemid = im.ItemID   ");
        sb.Append(" INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID = im.SubCategoryID");
        sb.Append(" LEFT JOIN f_LowStock ls ON ls.itemid=im.itemid AND ls.DeptLedgerNo='LSHHI57' ");

        sb.Append(" ORDER BY im.typename ");
        sb.Append(" )t2  ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public string bindGenericItem()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" select im.ItemID, CONCAT(fsm.Name,' # ',im.typename,' # (',sm.name,')',' # ',AvailableQty)ItemName from ( ");
        sb.Append(" select ItemID,(SUM(InitialCount) - SUM(ReleasedCount))AvailableQty from f_stock where (InitialCount - ReleasedCount) > 0 ");
        sb.Append(" and IsPost = 1 and  DeptLedgerNo='" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "'  and MedExpiryDate>CURDATE() ");
        sb.Append(" group by ItemID ");
        sb.Append(" ) t1 inner join f_itemmaster im on t1.itemid = im.ItemID ");
        sb.Append(" inner join f_subcategorymaster sm on sm.SubCategoryID = im.SubCategoryID ");
        sb.Append(" INNER JOIN f_item_salt fis ON fis.ItemID=im.ItemID LEFT JOIN f_salt_master fsm ON fis.saltID = fsm.SaltID WHERE fsm.IsActive=1 ");



        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public string addItem(string ItemID, decimal tranferQty, string StockID, string patientMedicine, string DeptLedgerNo)
    {

        StringBuilder sb = new StringBuilder();
        if (ItemID == Resources.Resource.PharmacyCharges_ItemId)
        {

            sb = new StringBuilder();
            sb.Append("Select ST.stockid,IM.TypeName ItemName,ST.ItemID,ST.BatchNumber,IFNULL(get_New_PriceByRange(" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + ",IM.SubcategoryID,ST.UnitPrice) ,0)MRP,ST.UnitPrice,");
            sb.Append("(ST.InitialCount - ST.ReleasedCount)AvlQty,IM.SubCategoryID,im.isexpirable,");
            sb.Append("date_format(ST.MedExpiryDate,'%d-%b-%Y')MedExpiryDate,ST.UnitType,im.ToBeBilled,");
            sb.Append("im.Type_ID,im.IsUsable,im.ServiceItemID,'" + patientMedicine + "' MedID,0 isItemWiseDisc,");
            // Add new on 29-06-2017 - For GST
            sb.Append(" st.HSNCode,st.IGSTPercent,st.IGSTAmtPerUnit,st.SGSTPercent,st.SGSTAmtPerUnit,st.CGSTPercent,st.CGSTAmtPerUnit,st.GSTType, ");
            //
            sb.Append(" st.PurTaxPer,st.SaleTaxPer VAT FROM f_stock ST ");
            sb.Append(" INNER JOIN f_itemmaster IM on ST.ItemID=IM.ItemID INNER JOIN f_subcategorymaster sub ON sub.SubcategoryID=IM.SubcategoryID ");
            sb.Append(" INNER JOIN f_configrelation CR on sub.CategoryID = CR.CategoryID WHERE (ST.InitialCount - ST.ReleasedCount) > 0 and ST.IsPost = 1 ");
            sb.Append(" AND CR.ConfigID = 11 AND IM.ItemID ='" + ItemID + "' AND st.CentreID = " + HttpContext.Current.Session["CentreID"].ToString() + " ");
            sb.Append(" AND st.DeptLedgerNo='" + DeptLedgerNo + "' ");
            sb.Append(" AND (IF(im.IsExpirable = 'NO','2050-01-01',st.MedExpiryDate) >= CURDATE())  order by IM.TypeName,st.MedExpiryDate limit 1");

        }
        else
        {
            sb = new StringBuilder();
            sb.Append("Select ST.stockid,IM.TypeName ItemName,ST.ItemID,ST.BatchNumber,IFNULL(get_New_PriceByRange(" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + ",IM.SubcategoryID,ST.UnitPrice) ,0)MRP,ST.UnitPrice,");
            sb.Append("(ST.InitialCount - ST.ReleasedCount)AvlQty,IM.SubCategoryID,im.isexpirable,");
            sb.Append("date_format(ST.MedExpiryDate,'%d-%b-%Y')MedExpiryDate,ST.UnitType,im.ToBeBilled,");
            sb.Append("im.Type_ID,im.IsUsable,im.ServiceItemID,'" + patientMedicine + "' MedID,0 isItemWiseDisc,");
            // Add new on 29-06-2017 - For GST
            sb.Append(" st.HSNCode,st.IGSTPercent,st.IGSTAmtPerUnit,st.SGSTPercent,st.SGSTAmtPerUnit,st.CGSTPercent,st.CGSTAmtPerUnit,st.GSTType, ");
            //
            sb.Append(" st.PurTaxPer,st.SaleTaxPer VAT FROM f_stock ST ");
            sb.Append(" INNER JOIN f_itemmaster IM on ST.ItemID=IM.ItemID INNER JOIN f_subcategorymaster sub ON sub.SubcategoryID=IM.SubcategoryID ");
            sb.Append(" INNER JOIN f_configrelation CR on sub.CategoryID = CR.CategoryID WHERE (ST.InitialCount - ST.ReleasedCount) > 0 and ST.IsPost = 1 ");
            sb.Append(" AND CR.ConfigID = 11 AND IM.ItemID ='" + ItemID + "' AND st.CentreID = " + HttpContext.Current.Session["CentreID"].ToString() + " ");
            sb.Append(" AND st.DeptLedgerNo='" + DeptLedgerNo + "'   AND st.StockID=" + StockID);
            sb.Append(" AND (IF(im.IsExpirable = 'NO','2050-01-01',st.MedExpiryDate) >= CURDATE())  order by IM.TypeName,st.MedExpiryDate");

        }

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if ((tranferQty < Util.GetDecimal(dt.Rows[0]["AvlQty"])) && (StockID != "0"))
        {
            dt = dt.AsEnumerable().Where(r => r.Field<string>("stockid") == StockID).AsDataView().ToTable();

        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }


    [WebMethod(EnableSession = true)]
    public string BindItemForLabelPrint(string LedgerTnxID)
    {
        StringBuilder sb = new StringBuilder();
        //sb.Append(" SELECT im.ItemID,SUBSTRING(im.TypeName,1,40) AS TypeName,pmh.PatientID,");
        //sb.Append(" IF(pmh.PatientID <> 'CASH002',(SELECT CONCAT(pm.Title, ' ', pm.PName) FROM patient_master pm WHERE pm.PatientID=pmh.PatientID), ");
        //sb.Append(" (SELECT CONCAT(pgm.Title,'',' ',pgm.Name) FROM patient_general_master pgm WHERE pgm.AgainstLedgerTnxNo=ld.LedgerTransactionNo )) AS PName,");
        //sb.Append(" DATE_FORMAT(ld.MedExpiryDate,'%d-%b-%y') AS MedExpiryDate,'' Side_Effect,'' Meal FROM f_ledgertnxdetail ld ");
        //sb.Append(" INNER JOIN f_itemmaster im ON im.ItemID=ld.ItemID ");
        //sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID=ld.TransactionID ");
        //sb.Append(" WHERE ld.LedgerTransactionNo='" + LedgerTnxID + "' ");


        sb.Append(" SELECT  ld.LedgerTransactionNo, im.ItemID,SUBSTRING(im.TypeName,1,40) AS TypeName,pmh.PatientID, ");
        sb.Append(" CONCAT(DATE_FORMAT(VerifiedDate,'%d-%b-%Y'),' ',TIME_FORMAT(VerifiedDate,'%h:%i %p'))IssueDateTime, ");
        sb.Append(" IF(pmh.PatientID <> 'CASH002', ");
        sb.Append(" (SELECT CONCAT(pm.Title, ' ', pm.PName) FROM patient_master pm WHERE pm.PatientID=pmh.PatientID),   ");
        sb.Append(" (SELECT CONCAT(pgm.Title,'',' ',pgm.Name)  ");
        sb.Append(" FROM patient_general_master pgm WHERE pgm.AgainstLedgerTnxNo=ld.LedgerTransactionNo )) AS PName,  ");
        sb.Append(" DATE_FORMAT(ld.MedExpiryDate,'%d-%b-%y') AS MedExpiryDate,'' Side_Effect,'' Meal , ");
        sb.Append("  IFNULL(DATEDIFF(om.`Duration`,DATE(om.`EntryDate`))+1,0)Duration,IFNULL(om.`Route`,0)Route,IFNULL(om.`Timing` ,0)Timing,ld.Quantity,IFNULL(CONCAT(pmm.Dose,IFNULL( pmm.Unit,'')),'0') Dose,pmm.DurationVal,pmm.IntervalId,Concat(Ifnull(pmm.Remarks,''),if(Ifnull(cpd.Remarks,'')='','',IF(IFNULL(pmm.Remarks,'')='','','/')),Ifnull(cpd.Remarks,''))Remarks ");
        sb.Append(" FROM f_ledgertnxdetail ld   ");
        sb.Append(" INNER JOIN f_salesdetails sd ON sd.`LedgerTnxNo`=ld.`ID` ");
        sb.Append(" INNER JOIN f_itemmaster im ON im.ItemID=ld.ItemID   ");
        sb.Append(" LEFT JOIN orderset_medication om ON om.`IndentNo`=sd.`IndentNo` AND sd.`ItemID`=om.`MedicineID` AND sd.`TransactionID`=om.`TransactionID` ");
        sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID=ld.TransactionID   ");
        sb.Append(" LEFT JOIN patient_medicine pmm ON pmm.OPDLedgertansactionNO=ld.LedgerTransactionNo AND pmm.Medicine_ID=ld.ItemID ");
        sb.Append(" LEFT JOIN f_clinical_Patient_details cpd ON cpd.LedgerTransactionNo=ld.LedgerTransactionNo AND cpd.ItemID=ld.ItemID ");
        sb.Append(" WHERE ld.LedgerTransactionNo='" + LedgerTnxID + "' and ld.ItemID not in (" + Resources.Resource.PharmacyCharges_ItemId + ") ORDER BY im.TypeName  ");

        DataTable oDT = StockReports.GetDataTable(sb.ToString());
        if (oDT.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(oDT);
        else
            return "";
    }

    public class draftMedicine
    {
        public string draftDetailID { get; set; }
        public decimal ReceiveQty { get; set; }
    }
    public class ClinicalTrialMedicine
    {
        public string ItemID { get; set; }
        public string Remarks { get; set; }
    }



    [WebMethod(EnableSession = true)]
    public string SaveOPDPharmacy(object PMH, object LT, object LTD, object SalesDetails, object generalPatient, object PaymentDetail, string patientType, object PatientMedicineData, string DeptLedgerNo, string contactNo, string PName, int isOtPatient, bool isIPDInCash, int IsDischargeMedicine, object draftMedicineData, string VerifiedUserID, object ClinicalTrial)
    {
        List<Patient_Medical_History> dataPMH = new JavaScriptSerializer().ConvertToType<List<Patient_Medical_History>>(PMH);
        List<Ledger_Transaction> dataLT = new JavaScriptSerializer().ConvertToType<List<Ledger_Transaction>>(LT);
        List<LedgerTnxDetail> dataLTD = new JavaScriptSerializer().ConvertToType<List<LedgerTnxDetail>>(LTD);
        List<Sales_Details> dataSalesDetails = new JavaScriptSerializer().ConvertToType<List<Sales_Details>>(SalesDetails);
        List<Ledger_Transaction_PaymentDetail> dataPaymentDetail = new JavaScriptSerializer().ConvertToType<List<Ledger_Transaction_PaymentDetail>>(PaymentDetail);
        List<Patient_General_Master> dataGeneral = new JavaScriptSerializer().ConvertToType<List<Patient_General_Master>>(generalPatient);
        List<Patient_Medicine> dataPatientMedicine = new JavaScriptSerializer().ConvertToType<List<Patient_Medicine>>(PatientMedicineData);
        List<draftMedicine> datadraftMedicine = new JavaScriptSerializer().ConvertToType<List<draftMedicine>>(draftMedicineData);
        List<ClinicalTrialMedicine> dataClinicalTrialMedicine = new JavaScriptSerializer().ConvertToType<List<ClinicalTrialMedicine>>(ClinicalTrial);

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCM = new ExcuteCMD();
        try
        {


            //if (Resources.Resource.IsGSTApplicable == "0")
            //{
            //string sqlCMD = "SELECT COUNT(*) FROM demo_his_mapping_master dim WHERE dim.HIS_ItemID=@itemID AND dim.IsActive=1";
            //for (int i = 0; i < dataLTD.Count; i++)
            //{

            //int isMappingExits = Util.GetInt(excuteCM.ExecuteScalar(sqlCMD, new
            //{
            //  itemID = dataLTD[i].ItemID.Trim()
            //}));

            //if (isMappingExits == 0)
            //{
            //    tnx.Rollback();
            //      return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Please Map With Finance.</br> <p class='patientInfo'>:- " + dataLTD[i].ItemName + "<p>" });
            //    }
            //  }
            //}


            var zeroMRPItems = dataSalesDetails.Where(i => i.PerUnitSellingPrice <= 0).ToList();

            if (zeroMRPItems.Count > 0)
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Some Item's have 0 MRP !!", message = zeroMRPItems });
            }



            string TransactionId = string.Empty, ledTxnID = string.Empty, ReceiptNo = string.Empty;
            //string TypeOfTnx = "Pharmacy-Issue";
            //int TransactionType_ID = 16;

            var isIPDBilling = false;
            var isEMGBilling = false;
            if (!isIPDInCash && !string.IsNullOrEmpty(dataLT[0].IPNo))
            {
                string patientBillingType = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "Select Type From patient_medical_history where TransactionID =" + dataLT[0].IPNo + " "));
                if (patientBillingType.ToUpper() == "IPD")
                {
                    isIPDBilling = true;
                }
                else if (patientBillingType.ToUpper() == "EMG")
                {
                    isEMGBilling = true;
                }
            }

            if (isIPDBilling == true)
            {

                if (AllLoadData_IPD.CheckBillGenerate(dataLT[0].IPNo, "IPD") > 0)
                {
                    string Msga = "Patient Final Bill Already Generated. Please contact to billing department.";
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = Msga });
                }
                if (Resources.Resource.AllowFiananceIntegration == "1")
                {
                    if (AllLoadData_IPD.CheckDataPostToFinance(dataLT[0].IPNo) > 0)
                    {
                        string Msga = "Patient Final Bill Already Posted To Finance, You can not Issue any item. Please contact to billing department.";
                        tnx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = Msga });
                    }
                }
            }
            if (isEMGBilling == true)
            {
                if (AllLoadData_IPD.CheckBillGenerate(dataLT[0].IPNo, "OPD") > 0)
                {
                    string Msga = "Patient Final Bill Already Generated. Please contact to billing department.";
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = Msga });
                }
                ledTxnID = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT L.LedgertransactionNo FROM f_LedgerTransaction L WHERE L.TransactionID='" + TransactionId + "' LIMIT 1"));
                if (AllLoadData_IPD.CheckDataPostToFinance(ledTxnID) > 0)
                {
                    string Msga = "Patient Final Bill Already Posted To Finance, You can not Issue any item. Please contact to billing department.";
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = Msga });
                }
            }

            var indent = dataSalesDetails.Where(i => !string.IsNullOrEmpty(i.IndentNo)).Select(x => new { IndentNo = x.IndentNo }).FirstOrDefault();
            if (indent != null)
            {
                for (var i = 0; i < dataLTD.Count; i++)
                {
                    var IndentItemStatus = StockReports.ExecuteScalar("SELECT (CASE WHEN t.reqQty=t.RejectQty THEN 'REJECT' WHEN  t.reqQty-t.ReceiveQty-t.RejectQty=0 THEN 'CLOSE'    WHEN   t.reqQty+t.ReceiveQty+t.RejectQty=t.reqQty THEN 'OPEN' ELSE 'PARTIAL'  END)StatusNew  FROM (	SELECT SUM(ReqQty)ReqQty,SUM(ReceiveQty)ReceiveQty, 	SUM(RejectQty)RejectQty  FROM f_indent_detail_patient id WHERE id.IndentNo='" + indent.IndentNo + "' AND id.ItemId='" + dataLTD[i].ItemID + "' )t");
                    if (IndentItemStatus == "REJECT" || IndentItemStatus == "CLOSE")
                    {
                        tnx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Item " + dataLTD[i].ItemName + " Already Issued in Indent No. " + indent.IndentNo + "", message = "Item Already Issued in selected Indent" });
                    }
                }
            }
            string creditBillNO = string.Empty;
            if (!isIPDBilling && !isEMGBilling)
            {
                creditBillNO = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select get_billno_store('" + DeptLedgerNo + "','" + HttpContext.Current.Session["CentreID"].ToString() + "')"));
                if (creditBillNO == string.Empty)
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In BillNo Generate" });
                }
                Patient_Medical_History objPmh = new Patient_Medical_History(tnx);
                objPmh.PatientID = dataPMH[0].PatientID;
                objPmh.DoctorID = dataPMH[0].DoctorID;
                objPmh.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                objPmh.Time = Util.GetDateTime(DateTime.Now);
                objPmh.DateOfVisit = Util.GetDateTime(DateTime.Now);
                objPmh.Type = "OPD";
                objPmh.PanelID = dataPMH[0].PanelID;
                objPmh.ParentID = dataPMH[0].PanelID;
                objPmh.ReferedBy = dataPMH[0].ReferedBy;
                objPmh.Source = "PHARMACY";
                objPmh.patient_type = dataPMH[0].patient_type;
                objPmh.UserID = Util.GetString(VerifiedUserID);
                objPmh.HashCode = dataPMH[0].HashCode;
                objPmh.ScheduleChargeID = Util.GetInt(StockReports.GetCurrentRateScheduleID(dataPMH[0].PanelID));
                objPmh.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                objPmh.EntryDate = Util.GetDateTime(DateTime.Now);
                objPmh.IsNewPatient = 0;

                int Co_PaymentOn = Util.GetInt(StockReports.ExecuteScalar("select ifnull(Co_PaymentOn,0) from f_panel_master where PanelID=" + dataPMH[0].PanelID + ""));
                objPmh.PanelPaybleAmt = dataPMH[0].PanelPaybleAmt;
                objPmh.PatientPaybleAmt = dataPMH[0].PatientPaybleAmt;
                objPmh.PanelPaidAmt = dataPMH[0].PanelPaidAmt;
                objPmh.PatientPaidAmt = dataPMH[0].PatientPaidAmt;
                objPmh.Co_PaymentOn = Co_PaymentOn;
                objPmh.BillNo = creditBillNO;
                objPmh.BillDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                objPmh.BillGeneratedBy = HttpContext.Current.Session["ID"].ToString();
                objPmh.IsVisitClose = 1;
                objPmh.NetBillAmount = Util.GetDecimal(dataLT[0].NetAmount);
                objPmh.TotalBilledAmt = Util.GetDecimal(dataLT[0].GrossAmount);
                objPmh.ItemDiscount = dataLT[0].DiscountOnTotal;

                TransactionId = objPmh.Insert();
                if (TransactionId == string.Empty)
                {
                    tnx.Rollback();
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Patient Medical History" });
                }
            }
            else
                TransactionId = dataLT[0].IPNo;

            if (!isIPDBilling && !isEMGBilling)
            {

                EncounterNo = Encounter.FindEncounterNo(dataPMH[0].PatientID);

                if (EncounterNo == 0)
                {
                    tnx.Rollback();
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Encounter No." });

                }

                 PoolNr = Encounter.GetPoolNrByEncounterNo(EncounterNo);
                 PoolDesc = Encounter.GetPoolDescByEncounterNo(EncounterNo, PoolNr);
                DateTime Nowdt = Util.GetDateTime(DateTime.Now);
                if (!Encounter.IsApprovalAmountExit(Util.GetString(dataPMH[0].PanelID), Util.GetString(dataPMH[0].PatientID), Nowdt))
                {

                    if (Encounter.IsLimitOnAmountInPanel(Util.GetString(dataPMH[0].PanelID)))
                    {
                        decimal CanPayUpto = Encounter.getEncounterLimit(Util.GetString(dataPMH[0].PatientID), Util.GetString(dataPMH[0].PanelID), EncounterNo, tnx, con);


                        if (CanPayUpto > 0)
                        {

                            if (Util.GetDecimal(CanPayUpto) >= Util.GetDecimal(dataPMH[0].PanelPaybleAmt))
                            {
                                int issave = Encounter.UpdateEncounterLimit(Util.GetString(dataPMH[0].PatientID), EncounterNo, Util.GetDecimal(dataPMH[0].PanelPaybleAmt), tnx, con);
                            }
                            else
                            {
                                tnx.Rollback();
                                tnx.Dispose();
                                con.Close();
                                con.Dispose();
                                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "You can pay using this panel upto " + CanPayUpto + " ", message = "Panel Payable Amount Is More then Remaing Panel Amount Limit" });

                            }

                        }
                        else
                        {

                            tnx.Rollback();
                            tnx.Dispose();
                            con.Close();
                            con.Dispose();
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Limit Exhausted", message = "limit exhausted" });

                        }

                    }

                }
                else
                {
                    decimal CanPayUpto = Encounter.getApprovalAmountLimit(Util.GetString(dataPMH[0].PatientID), Util.GetString(dataPMH[0].PanelID),PoolNr, Nowdt);

                    if (CanPayUpto > 0)
                    {

                        if (Util.GetDecimal(CanPayUpto) >= Util.GetDecimal(dataPMH[0].PanelPaybleAmt))
                        {
                            int issave = Encounter.UpdateApprovalAmt(Util.GetString(dataPMH[0].PanelID), Util.GetString(dataPMH[0].PatientID), Util.GetDecimal(dataPMH[0].PanelPaybleAmt), Nowdt, tnx, con);
                        }
                        else
                        {
                            tnx.Rollback();
                            tnx.Dispose();
                            con.Close();
                            con.Dispose();
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "You can pay using this panel upto " + CanPayUpto + " ", message = "Panel Payable Amount Is More then Remaing Panel Amount Limit" });

                        }

                    }
                    else
                    {

                        tnx.Rollback();
                        tnx.Dispose();
                        con.Close();
                        con.Dispose();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Limit Exhausted", message = "limit exhausted" });

                    }

                }




            }


            if (!isEMGBilling)
            {
                Ledger_Transaction objLedTran = new Ledger_Transaction(tnx);
                if ((patientType == "1") || (patientType == "3"))
                {
                    if (isIPDBilling)
                        objLedTran.LedgerNoCr = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select LedgerNumber from f_ledgermaster where LedgerUserID='" + dataPMH[0].PatientID + "' and GroupID='PTNT' "));
                    else
                        objLedTran.LedgerNoCr = "CASH001";

                    objLedTran.PatientID = dataPMH[0].PatientID;
                }
                else
                {
                    objLedTran.LedgerNoCr = "CASH002";
                    objLedTran.PatientID = "CASH002";
                }
                objLedTran.LedgerNoDr = "STO00001";
                objLedTran.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                objLedTran.TransactionID = TransactionId;

                if (isIPDBilling)
                {
                    objLedTran.TypeOfTnx = "Sales";
                    objLedTran.TransactionType_ID = 3;
                    objLedTran.isOTCollection = isOtPatient;
                }
                else
                {
                    objLedTran.IPNo = dataLT[0].IPNo;
                    objLedTran.TransactionType_ID = 16;
                    objLedTran.TypeOfTnx = "Pharmacy-Issue";
                }

                objLedTran.PanelID = dataPMH[0].PanelID;
                objLedTran.Date = Util.GetDateTime(DateTime.Now.ToShortDateString());
                objLedTran.Time = Util.GetDateTime(DateTime.Now.ToShortTimeString());
                objLedTran.NetAmount = dataLT[0].NetAmount;
                objLedTran.GrossAmount = dataLT[0].GrossAmount;
                objLedTran.DiscountOnTotal = dataLT[0].DiscountOnTotal;
                objLedTran.DiscountReason = dataLT[0].DiscountReason.Trim();
                objLedTran.DiscountApproveBy = dataLT[0].DiscountApproveBy.Trim();

                if (indent != null)
                {
                    int notification = All_LoadData.updateNotification(indent.IndentNo, "", "", 28, tnx);
                    objLedTran.IndentNo = indent.IndentNo;
                }

                if (!isIPDBilling)
                {
                    objLedTran.Adjustment = dataLT[0].Adjustment;
                    if (dataPaymentDetail[0].PaymentMode.ToString() != "Credit" && (dataLT[0].Adjustment > 0))
                        objLedTran.IsPaid = 1;
                    else
                        objLedTran.IsPaid = 0;
                }
                objLedTran.IsCancel = Util.GetInt(0);
                objLedTran.RoundOff = Util.GetDecimal(dataLT[0].RoundOff);
                objLedTran.PaymentModeID = Util.GetInt(dataPaymentDetail[0].PaymentModeID);



                objLedTran.DeptLedgerNo = DeptLedgerNo;
                //objLedTran.UserID = HttpContext.Current.Session["ID"].ToString();

                objLedTran.UserID = Util.GetString(VerifiedUserID);

                objLedTran.UniqueHash = dataPMH[0].HashCode;
                objLedTran.Remarks = dataLT[0].Remarks;
                objLedTran.BillDate = Util.GetDateTime(DateTime.Now);
                objLedTran.GovTaxPer = 0;
                objLedTran.IpAddress = HttpContext.Current.Request.UserHostAddress;
                objLedTran.PatientType = dataPMH[0].patient_type;
                 
                objLedTran.BillNo = creditBillNO;
                objLedTran.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                objLedTran.CurrentAge = dataLT[0].CurrentAge;
                objLedTran.EncounterNo = EncounterNo;
                objLedTran.PoolNr = PoolNr;
                objLedTran.PoolDesc = PoolDesc;
                
                ledTxnID = objLedTran.Insert();

            }
            else
            {
                ledTxnID = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT L.LedgertransactionNo FROM f_LedgerTransaction L WHERE L.TransactionID='" + TransactionId + "' LIMIT 1"));

            }
            if (ledTxnID == string.Empty)
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In LT" });
            }

            string customerID = "";
            if (patientType == "2")
            {
                Patient_General_Master objPGMaster = new Patient_General_Master(tnx);
                objPGMaster.Title = dataGeneral[0].Title;
                objPGMaster.Name = dataGeneral[0].Name;
                objPGMaster.Age = dataGeneral[0].Age;
                objPGMaster.Address = dataGeneral[0].Address;
                objPGMaster.Gender = dataGeneral[0].Gender;
                objPGMaster.ContactNo = dataGeneral[0].ContactNo;
                objPGMaster.Ledgertrnxno = ledTxnID;
                objPGMaster.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                objPGMaster.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                customerID = objPGMaster.Insert();
                if (customerID == "")
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Patient General Master" });
                }
            }
            // if (customerID != "")
            //     MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "UPDATE patient_general_master SET AgainstLedgerTnxNo='" + ledTxnID + "' where CustomerID='" + customerID + "' ");
            int SalesNo = 0;
            if (isIPDBilling || isEMGBilling)
                SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select Get_SalesNo('3','" + AllGlobalFunction.MedicalStoreID + "','" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + "') "));
            else
                SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select Get_SalesNo('16','" + AllGlobalFunction.MedicalStoreID + "','" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + "') "));
            //============= For IPD Package Purpose

            //Checking if Patient is prescribed any IPD Packages
            DataTable dtPkg = StockReports.GetIPD_Packages_Prescribed(TransactionId, con);
            string EntryID = "";
            string IndentNoPat = "";
            if (indent == null && isIPDBilling)
            {
                EntryID = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "Select ifnull(Max(EntryID),0)+1 ID from orderset_medication"));
                IndentNoPat = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select get_indent_no_patient('" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "','" + HttpContext.Current.Session["CentreID"].ToString() + "')").ToString();
            }
            for (int i = 0; i < dataLTD.Count; i++)
            {
                LedgerTnxDetail objLTDetail = new LedgerTnxDetail(tnx);
                objLTDetail.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
                objLTDetail.LedgerTransactionNo = ledTxnID;
                objLTDetail.ItemID = Util.GetString(dataLTD[i].ItemID);
                objLTDetail.StockID = Util.GetString(dataLTD[i].StockID);
                objLTDetail.SubCategoryID = Util.GetString(dataLTD[i].SubCategoryID);
                objLTDetail.TransactionID = TransactionId;
                objLTDetail.Rate = Util.GetDecimal(dataLTD[i].Rate);
                objLTDetail.Quantity = Util.GetDecimal(dataLTD[i].Quantity);
                objLTDetail.IsVerified = 1;
                objLTDetail.ItemName = Util.GetString(dataLTD[i].ItemName);
                objLTDetail.EntryDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));

                objLTDetail.DiscAmt = Util.GetDecimal(dataLTD[i].DiscAmt);
                objLTDetail.DiscountPercentage = Util.GetDecimal(dataLTD[i].DiscountPercentage);
                objLTDetail.DiscountReason = Util.GetString(dataLTD[i].DiscountReason);
                objLTDetail.DoctorID = dataPMH[0].DoctorID;

                objLTDetail.IsPayable = dataLTD[i].IsPayable;
                objLTDetail.CoPayPercent = dataLTD[i].CoPayPercent;


                //objLTDetail.Amount = Util.GetDecimal(dataLTD[i].Amount);
                objLTDetail.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(dataLTD[i].SubCategoryID), con));

                // objLTDetail.UserID = HttpContext.Current.Session["ID"].ToString();
                objLTDetail.UserID = Util.GetString(VerifiedUserID);

                if (isIPDBilling)
                {
                    objLTDetail.TransactionType_ID = 3;
                    objLTDetail.ToBeBilled = 1;
                    objLTDetail.Type = "I";
                    string IPDDetails = StockReports.ExecuteScalar("SELECT CONCAT(pip.IPDCaseTypeID,'#',pip.RoomID) FROM patient_ipd_profile pip WHERE pip.TransactionID='" + dataLT[0].IPNo + "'");
                    objLTDetail.IPDCaseTypeID = IPDDetails.Split('#')[0];
                    objLTDetail.RoomID = IPDDetails.Split('#')[1];
                    if (dtPkg != null && dtPkg.Rows.Count > 0)
                    {
                        int iCtr = 0;
                        foreach (DataRow drPkg in dtPkg.Rows)
                        {
                            if (iCtr == 0)
                            {
                                DataTable dtPkgDetl = StockReports.ShouldSendToIPDPackage(TransactionId, drPkg["PackageID"].ToString(), dataLTD[i].ItemID.ToString(), (Util.GetDecimal(dataLTD[i].Rate) * Util.GetDecimal(dataLTD[i].Quantity)), Util.GetDecimal(dataLTD[i].Quantity), Util.GetInt(IPDDetails.Split('#')[0]), con);

                                if (dtPkgDetl != null && Util.GetString(dtPkgDetl.Rows[0]["iStatus"]) != "")
                                {
                                    if (Util.GetBoolean(dtPkgDetl.Rows[0]["iStatus"]))
                                    {
                                        objLTDetail.Amount = 0;
                                        objLTDetail.IsPackage = 1;
                                        objLTDetail.PackageID = Util.GetString(drPkg["PackageID"]);
                                        objLTDetail.NetItemAmt = 0;

                                        iCtr = 1;
                                    }
                                }
                                else
                                {
                                    objLTDetail.Amount = Util.GetDecimal(dataLTD[i].Amount);
                                    objLTDetail.NetItemAmt = Util.GetDecimal(dataLTD[i].Amount);
                                    iCtr = 1;
                                }
                            }
                        }
                    }
                    else
                    {
                        objLTDetail.Amount = Util.GetDecimal(dataLTD[i].Amount);
                        objLTDetail.NetItemAmt = Util.GetDecimal(dataLTD[i].NetItemAmt);
                    }
                }
                else
                {
                    if (isEMGBilling)
                    {
                        objLTDetail.TransactionType_ID = 3;
                        objLTDetail.ToBeBilled = 1;
                        objLTDetail.Type = "E";
                    }
                    else
                    {
                        objLTDetail.TransactionType_ID = 16;
                        objLTDetail.ToBeBilled = Util.GetInt(dataLTD[i].ToBeBilled);
                        objLTDetail.Type = "O";
                    }
                    objLTDetail.Amount = Util.GetDecimal(dataLTD[i].Amount);
                    objLTDetail.NetItemAmt = Util.GetDecimal(dataLTD[i].Amount);
                }


                objLTDetail.IsReusable = Util.GetString(dataLTD[i].IsReusable);
                objLTDetail.NetItemAmt = objLTDetail.Amount;
                objLTDetail.TotalDiscAmt = Util.GetDecimal(objLTDetail.DiscAmt);
                objLTDetail.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                objLTDetail.pageURL = All_LoadData.getCurrentPageName();
                objLTDetail.medExpiryDate = Util.GetDateTime(dataLTD[i].medExpiryDate);
                objLTDetail.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                objLTDetail.IpAddress = HttpContext.Current.Request.UserHostAddress;


                if (Util.GetDateTime(dataLTD[i].medExpiryDate) != Util.GetDateTime("01-Jan-01"))
                    objLTDetail.IsExpirable = 1;
                else
                    objLTDetail.IsExpirable = 0;
                // objLTDetail.TransactionType_ID = TransactionType_ID;
                objLTDetail.BatchNumber = dataLTD[i].BatchNumber;
                objLTDetail.VerifiedDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                //  objLTDetail.VarifiedUserID = HttpContext.Current.Session["ID"].ToString();


                objLTDetail.PurTaxPer = dataLTD[i].PurTaxPer;
                if (Util.GetDecimal(dataLTD[i].PurTaxPer) > 0)
                    objLTDetail.PurTaxAmt = Util.GetDecimal(dataLTD[i].PurTaxAmt);   //Util.GetDecimal(Util.GetDecimal(dataLTD[i].Amount) * Util.GetDecimal(dataLTD[i].PurTaxPer)) / 100;
                else
                    objLTDetail.PurTaxAmt = 0;
                objLTDetail.unitPrice = Util.GetDecimal(dataLTD[i].unitPrice);
                objLTDetail.DeptLedgerNo = DeptLedgerNo;

                if (Util.GetDecimal(dataLTD[i].DiscAmt) > 0)
                    objLTDetail.DiscUserID = Util.GetString(VerifiedUserID);
                //  objLTDetail.DiscUserID = HttpContext.Current.Session["ID"].ToString();

                objLTDetail.StoreLedgerNo = "STO00001";
                //GST Changes
                decimal igstPercent = Util.GetDecimal(dataLTD[i].IGSTPercent);
                decimal csgtPercent = Util.GetDecimal(dataLTD[i].CGSTPercent);
                decimal sgstPercent = Util.GetDecimal(dataLTD[i].SGSTPercent);

                decimal nonTaxableRate = (objLTDetail.Rate * 100) / (100 + igstPercent + csgtPercent + sgstPercent);
                decimal discount = objLTDetail.Rate * objLTDetail.DiscountPercentage / 100;
                decimal taxableAmt = ((objLTDetail.Rate - discount) * 100 * objLTDetail.Quantity) / (100 + igstPercent + csgtPercent + sgstPercent);

                decimal IGSTTaxAmount = Math.Round(taxableAmt * igstPercent / 100, 4, MidpointRounding.AwayFromZero);
                decimal CGSTTaxAmount = Math.Round(taxableAmt * csgtPercent / 100, 4, MidpointRounding.AwayFromZero);
                decimal SGSTTaxAmount = Math.Round(taxableAmt * sgstPercent / 100, 4, MidpointRounding.AwayFromZero);
                objLTDetail.HSNCode = Util.GetString(dataLTD[i].HSNCode);
                objLTDetail.IGSTPercent = igstPercent;
                objLTDetail.IGSTAmt = IGSTTaxAmount;
                objLTDetail.CGSTPercent = csgtPercent;
                objLTDetail.CGSTAmt = CGSTTaxAmount;
                objLTDetail.SGSTPercent = sgstPercent;
                objLTDetail.SGSTAmt = SGSTTaxAmount;
                objLTDetail.roundOff = Util.GetDecimal(Util.GetDecimal(dataLT[0].RoundOff) / dataLTD.Count);

                if (isIPDBilling || isEMGBilling)
                    objLTDetail.typeOfTnx = "Sales";
                else
                    objLTDetail.typeOfTnx = "Pharmacy-Issue";

                //    objLTDetail.typeOfTnx = objLedTran.TypeOfTnx;
                objLTDetail.IsDischargeMedicine = IsDischargeMedicine;
                //

                if (objLTDetail.IsPackage == 0)
                {
                    objLTDetail.NetItemAmt = ((objLTDetail.Rate * objLTDetail.Quantity) - objLTDetail.DiscAmt);
                    objLTDetail.Amount = ((objLTDetail.Rate * objLTDetail.Quantity) - objLTDetail.DiscAmt);
                }
                else
                {
                    objLTDetail.NetItemAmt = 0;
                    objLTDetail.Amount = 0;
                }
                int LedgerTnxNo = objLTDetail.Insert();


                if (LedgerTnxNo == 0)
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In LdgTnx Detail" });

                }


                //max Discount Validation
                var maxEligibleDiscountPercent = Util.round(All_LoadData.GetEligiableDiscountPercent(objLTDetail.UserID));

                var maxDiscountItems = dataLTD.Where(d => d.DiscountPercentage > maxEligibleDiscountPercent).ToList();


                if (maxDiscountItems.Count > 0)
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.maxDiscountValidationErrorMessage + maxEligibleDiscountPercent + "</b>" });
                }

                //  ---------------- Update into Patient_medicine Table-----------

                Patient_Medicine objPati_medicine = new Patient_Medicine(tnx);
                objPati_medicine.PatientMedicine_ID = dataPatientMedicine[i].PatientMedicine_ID;
                if (Util.GetString(dataLTD[i].ItemID) != "" && (dataPatientMedicine[i].PatientMedicine_ID != 0) && (patientType == "1"))
                {
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE Patient_Medicine SET IsIssued=1,IssueQuantity=IssueQuantity +'" + Util.GetDecimal(dataLTD[i].Quantity) + "',OPDTransactionID='" + TransactionId + "',OPDLedgertansactionNO='" + ledTxnID + "',IssueBy='" + Util.GetString(VerifiedUserID) + "' WHERE PatientMedicine_ID='" + objPati_medicine.PatientMedicine_ID + "'  ");
                }

                Sales_Details objSales = new Sales_Details(tnx);
                objSales.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                //if ((patientType == "1") || (patientType == "3"))
                //    objSales.LedgerNumber = objLedTran.LedgerNoCr;
                //else
                //    objSales.LedgerNumber = "CASH002";

                if ((patientType == "1") || (patientType == "3"))
                {
                    if (isIPDBilling || isEMGBilling)
                        objSales.LedgerNumber = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select LedgerNumber from f_ledgermaster where LedgerUserID='" + dataPMH[0].PatientID + "' and GroupID='PTNT' "));
                    else
                        objSales.LedgerNumber = "CASH001";
                }
                else
                {
                    objSales.LedgerNumber = "CASH002";
                }

                objSales.DepartmentID = "STO00001";
                objSales.StockID = Util.GetString(dataLTD[i].StockID);
                objSales.SoldUnits = Util.GetDecimal(dataLTD[i].Quantity);
                objSales.PerUnitBuyPrice = Util.GetDecimal(dataLTD[i].unitPrice);
                objSales.PerUnitSellingPrice = Util.GetDecimal(dataLTD[i].Rate);
                objSales.Date = System.DateTime.Now;
                objSales.Time = System.DateTime.Now;
                objSales.IsReturn = 0;
                //objSales.TrasactionTypeID = TransactionType_ID;

                if (isIPDBilling || isEMGBilling)
                {
                    objSales.TrasactionTypeID = 3;
                    objSales.ToBeBilled = 1;
                }
                else
                {
                    objSales.TrasactionTypeID = 16;
                    objSales.ToBeBilled = Util.GetInt(dataLTD[i].ToBeBilled);

                }


                objSales.ItemID = Util.GetString(dataLTD[i].ItemID);
                objSales.IsService = "NO";

                if (indent == null && isIPDBilling)
                    objSales.IndentNo = IndentNoPat;
                else
                    objSales.IndentNo = dataSalesDetails[i].IndentNo;
                objSales.Naration = "";
                objSales.SalesNo = SalesNo;
                // objSales.UserID = HttpContext.Current.Session["ID"].ToString();
                objSales.UserID = Util.GetString(VerifiedUserID);


                objSales.DeptLedgerNo = DeptLedgerNo;
                if ((patientType == "1") || (patientType == "3"))
                    objSales.PatientID = dataPMH[0].PatientID;
                else
                    objSales.PatientID = customerID;

                objSales.LedgerTransactionNo = ledTxnID;
                objSales.BillNoforGP = creditBillNO;



                objSales.IsReusable = Util.GetString(dataLTD[i].IsReusable);
                objSales.Type_ID = dataLTD[i].Type_ID;
                objSales.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                objSales.IpAddress = HttpContext.Current.Request.UserHostAddress;
                objSales.medExpiryDate = Util.GetDateTime(dataLTD[i].medExpiryDate);
                objSales.BatchNo = dataLTD[i].BatchNumber;
                objSales.LedgerTnxNo = LedgerTnxNo;

                objSales.TransactionID = TransactionId;
                objSales.DiscAmt = Util.GetDecimal(dataLTD[i].DiscAmt);
                objSales.DisPercent = Util.GetDecimal(dataLTD[i].DiscountPercentage);
                // Add new 29-06-2017 - For GST                
                objSales.IGSTPercent = igstPercent;
                objSales.IGSTAmt = IGSTTaxAmount;
                objSales.CGSTPercent = csgtPercent;
                objSales.CGSTAmt = CGSTTaxAmount;
                objSales.SGSTPercent = sgstPercent;
                objSales.SGSTAmt = SGSTTaxAmount;
                objSales.HSNCode = Util.GetString(dataLTD[i].HSNCode);
                objSales.GSTType = Util.GetString(dataSalesDetails[i].GSTType);

                //objSales.TaxPercent = dataLTD[i].PurTaxPer;
                //objSales.TaxAmt = objLTDetail.PurTaxAmt;
                decimal MRP = objSales.PerUnitSellingPrice;
                if (MRP <= 0)
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = dataLTD[i].ItemName + "Item Price Is Zero" });
                }
                decimal SaleTaxPer = Util.GetDecimal(dataSalesDetails[i].TaxPercent);
                decimal SaleTaxAmtPerUnit = Math.Round(((((MRP * 100) / (100 + SaleTaxPer)) * SaleTaxPer) / 100), 6);

                objSales.TaxPercent = SaleTaxPer;
                objSales.TaxAmt = SaleTaxAmtPerUnit * Util.GetDecimal(dataLTD[i].Quantity);

                decimal TaxablePurVATAmt = (Util.GetDecimal(dataLTD[i].unitPrice) * Util.GetDecimal(dataLTD[i].Quantity)) * (100 / (100 + Util.GetDecimal(dataLTD[i].PurTaxPer)));
                decimal vatPuramt = TaxablePurVATAmt * Util.GetDecimal(dataLTD[i].PurTaxPer) / 100;
                objSales.PurTaxPer = Util.GetDecimal(dataLTD[i].PurTaxPer);
                objSales.PurTaxAmt = vatPuramt;

                objSales.draftDetailID = Util.GetString(dataSalesDetails[i].draftDetailID);
                //           
                string salesID = objSales.Insert();
                if (string.IsNullOrEmpty(salesID))
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Sales Details" });
                }

                string strStock = "";


                strStock = "update f_stock set ReleasedCount = ReleasedCount +" + objSales.SoldUnits + " where StockID = '" + objSales.StockID + "' and ReleasedCount + " + objSales.SoldUnits + "<=InitialCount";

                if (MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strStock) == 0)
                {
                    decimal avStock = Util.GetDecimal(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT (InitialCount-ReleasedCount)avStock FROM  f_stock WHERE StockID = '" + objSales.StockID + "'"));
                    tnx.Rollback();
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();
                    //return string.Concat(Util.GetInt(i + 1), "$", avStock).ToString();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Stock already issued, Available Stock " + avStock, stockID = objSales.StockID });

                }

                if (indent == null && isIPDBilling)
                {
                    string indentpatient = "insert into f_indent_detail_patient(IndentNo,ItemId,ItemName,ReqQty,ReceiveQty,UnitType,DeptFrom,DeptTo,StoreId,UserId,TransactionID,IndentType,CentreID,Hospital_Id,PatientID,DoctorID,IPDCaseTypeID,RoomID,isDischargeMedicine)  " +
                    " values('" + IndentNoPat + "','" + dataLTD[i].ItemID + "','" + dataLTD[i].ItemName + "'," + Util.GetFloat(dataLTD[i].Quantity) + "," + Util.GetFloat(dataLTD[i].Quantity) + " " +
                    " ,'NOS','" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "','" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "','STO00001', " +
                    " '" + HttpContext.Current.Session["ID"].ToString() + "','" + objSales.TransactionID + "','','" + HttpContext.Current.Session["CentreID"].ToString() + "', " +
                    " '" + HttpContext.Current.Session["HOSPID"].ToString() + "','" + objSales.PatientID + "','" + Util.GetInt(dataLTD[i].DoctorID) + "','" + Util.GetInt(dataLTD[i].IPDCaseTypeID) + "','" + Util.GetInt(dataLTD[i].RoomID) + "'," + dataLTD[i].IsDischargeMedicine + ") ";
                    if (MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, indentpatient) == 0)
                    {
                        tnx.Rollback();
                        return "0";
                    }
                    string orderset = " Insert into orderset_medication(EntryID,TransactionID,PatientID,MedicineID,MedicineName,ReqQty,EntryBy,IndentNo)values( " +
                                     " " + Util.GetInt(EntryID) + ",'" + objSales.TransactionID + "','" + objSales.PatientID + "','" + dataLTD[i].ItemID + "','" + dataLTD[i].ItemName + "','" + Util.GetFloat(dataLTD[i].Quantity) + "', " +
                                     " '" + HttpContext.Current.Session["ID"].ToString() + "','" + IndentNoPat + "')";
                    if (MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, orderset) == 0)
                    {
                        tnx.Rollback();
                        return "0";
                    }
                }

            }



            int IsBill = 1;
            if (!isIPDBilling && !isEMGBilling)
            {
                if ((dataPaymentDetail[0].PaymentMode.ToString() != "Credit") && (dataLT[0].Adjustment > 0))
                {
                    Receipt ObjReceipt = new Receipt(tnx);
                    ObjReceipt.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                    ObjReceipt.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    ObjReceipt.AmountPaid = dataLT[0].Adjustment;
                    ObjReceipt.AsainstLedgerTnxNo = ledTxnID.Trim();
                    ObjReceipt.Date = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                    ObjReceipt.Time = Util.GetDateTime(DateTime.Now.ToString("HH:mm:ss"));
                    if ((patientType == "1") || (patientType == "3"))
                    {
                        ObjReceipt.Depositor = dataPMH[0].PatientID;
                        ObjReceipt.LedgerNoCr = "CASH001";
                    }
                    else
                    {
                        ObjReceipt.Depositor = "CASH002";
                        ObjReceipt.LedgerNoCr = "CASH002";
                    }
                    ObjReceipt.Discount = 0;
                    ObjReceipt.PanelID = dataPMH[0].PanelID;
                    // ObjReceipt.Reciever = HttpContext.Current.Session["ID"].ToString();
                    ObjReceipt.Reciever = Util.GetString(VerifiedUserID);


                    ObjReceipt.TransactionID = TransactionId;
                    ObjReceipt.RoundOff = dataLT[0].RoundOff;
                    ObjReceipt.LedgerNoDr = "STO00001";
                    ObjReceipt.PaidBy = "PAT";
                    ObjReceipt.deptLedgerNo = DeptLedgerNo;
                    ObjReceipt.IpAddress = All_LoadData.IpAddress();
                    if (patientType == "3")
                        ObjReceipt.isOTCollection = isOtPatient;
                    IsBill = 0;
                    ReceiptNo = ObjReceipt.Insert();

                    Receipt_PaymentDetail ObjReceiptPayment = new Receipt_PaymentDetail(tnx);
                    for (int i = 0; i < dataPaymentDetail.Count; i++)
                    {
                        ObjReceiptPayment.PaymentModeID = Util.GetInt(dataPaymentDetail[i].PaymentModeID);
                        ObjReceiptPayment.PaymentMode = Util.GetString(dataPaymentDetail[i].PaymentMode);
                        ObjReceiptPayment.Amount = Util.GetDecimal(dataPaymentDetail[i].Amount);
                        ObjReceiptPayment.ReceiptNo = ReceiptNo;
                        ObjReceiptPayment.PaymentRemarks = Util.GetString(dataPaymentDetail[i].PaymentRemarks);
                        ObjReceiptPayment.RefDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                        ObjReceiptPayment.RefNo = Util.GetString(dataPaymentDetail[i].RefNo);
                        ObjReceiptPayment.BankName = Util.GetString(dataPaymentDetail[i].BankName);
                        ObjReceiptPayment.C_Factor = Util.GetDecimal(dataPaymentDetail[i].C_Factor);
                        ObjReceiptPayment.S_Amount = Util.GetDecimal(dataPaymentDetail[i].S_Amount);
                        ObjReceiptPayment.S_CountryID = Util.GetInt(dataPaymentDetail[i].S_CountryID);
                        ObjReceiptPayment.S_Currency = Util.GetString(dataPaymentDetail[i].S_Currency);
                        ObjReceiptPayment.S_Notation = Util.GetString(dataPaymentDetail[i].S_Notation);
                        ObjReceiptPayment.currencyRoundOff = Util.GetDecimal(dataPaymentDetail[i].currencyRoundOff);
                        ObjReceiptPayment.swipeMachine = Util.GetString(dataPaymentDetail[i].swipeMachine);
                        ObjReceiptPayment.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                        ObjReceiptPayment.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                        string PaymentID = ObjReceiptPayment.Insert().ToString();
                    }
                    if (ReceiptNo == "")
                    {
                        tnx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In  Receipt Payment" });
                    }
                }

            }


            if (indent != null)
            {
                var medicineItems = dataLTD.GroupBy(x => x.ItemID).ToDictionary(y => y.Key, y => y.Sum(z => z.Quantity));
                foreach (var i in medicineItems)
                {
                    string itemID = i.Key;
                    decimal Quantity = i.Value;
                    StringBuilder sb = new StringBuilder();
                    sb.Append(" UPDATE f_indent_detail_patient SET ReceiveQty=ReceiveQty +" + Util.GetDecimal(Quantity) + " ");

                    if (Resources.Resource.IndentRestItemsAutoReject == "1")
                    {
                        sb.Append(" ,RejectQty=ReqQty-" + Util.GetDecimal(Quantity) + ",RejectBy=IF(RejectQty>0,'" + Util.GetString(VerifiedUserID) + "',''),dtReject=IF(RejectQty>0,NOW(),''),RejectReason=IF(RejectQty>0,'Auto Reject','') ");
                    }
                    sb.Append("  WHERE IndentNo='" + indent.IndentNo + "' AND ItemId='" + itemID + "' ");
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString());
                }
            }

            for (int i = 0; i < datadraftMedicine.Count; i++)
            {
                ExcuteCMD excuteCMD = new ExcuteCMD();

                var sqlCmd = new StringBuilder("update store_demand_draft_details SET ReceiveQty=ReceiveQty+@ReceiveQty,LastUpdatedBy=@LastUpdatedBy,LastUpdatedDateTime=@LastUpdatedDateTime where ID=@draftDetailID ");
                excuteCMD.DML(tnx, sqlCmd.ToString(), CommandType.Text, new
                {
                    draftDetailID = Util.GetInt(datadraftMedicine[i].draftDetailID),
                    ReceiveQty = Util.GetDecimal(datadraftMedicine[i].ReceiveQty),
                    LastUpdatedBy = Util.GetString(VerifiedUserID),
                    LastUpdatedDateTime = System.DateTime.Now
                });
            }

            for (int i = 0; i < dataClinicalTrialMedicine.Count; i++)
            {
                ExcuteCMD excuteCMD = new ExcuteCMD();

                var sqlCmd = new StringBuilder(" INSERT INTO f_clinical_Patient_details(PatientID,LedgerTransactionNo,ItemID,CentreID,Remarks,EntryBy) VALUES(@PatientID,@LedgerTransactionNo,@ItemID,@CentreID,@Remarks,@EntryBy)");
                excuteCMD.DML(tnx, sqlCmd.ToString(), CommandType.Text, new
                {
                    PatientID = dataPMH[0].PatientID,
                    LedgerTransactionNo = ledTxnID.Trim(),
                    ItemID = Util.GetString(dataClinicalTrialMedicine[i].ItemID),
                    CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()),
                    Remarks = Util.GetString(dataClinicalTrialMedicine[i].Remarks),
                    EntryBy = Util.GetString(VerifiedUserID)
                });
            }


            if (isEMGBilling)
            {
                int IsUpdate = updateEmergencyBillAmounts(tnx, ledTxnID.Trim());
                if (IsUpdate != 1)
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Emergency LT Update" });
                }
            }


            if (!isIPDBilling && !isEMGBilling && Util.GetDecimal(dataPMH[0].PanelPaybleAmt) != 0)
            {
                ExcuteCMD excuteCMD = new ExcuteCMD();
                StringBuilder sqlCMD = new StringBuilder("INSERT INTO panelapproval_emaildetails (Email,TransactionID,SendEmailID,ApprovalAmount,PolicyCardNumber,PolicyExpiryDate,PolicyNumber,NICNumber,EntryBy ,ApprovalRemark,PanelID) ");
                sqlCMD.Append(" VALUES ( @Email,@TransactionID,@SendEmailID,@ApprovalAmount,@PolicyCardNumber,@PolicyExpiryDate,@PolicyNumber,@NICNumber,@EntryBy,@ApprovalRemark,@panelID) ");


                var response = excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
                {

                    Email = "",
                    TransactionID = TransactionId,
                    SendEmailID = 0,
                    ApprovalAmount = Util.GetDecimal(dataPMH[0].PanelPaybleAmt),
                    PolicyCardNumber = dataPMH[0].CardNo,
                    PolicyExpiryDate = Util.GetDateTime(dataPMH[0].ExpiryDate).ToString("yyyy-MM-dd"),
                    PolicyNumber = dataPMH[0].PolicyNo,
                    NICNumber = "",
                    EntryBy = HttpContext.Current.Session["ID"].ToString(),
                    ApprovalRemark = "",
                    panelID = dataPMH[0].PanelID
                });


                sqlCMD = new StringBuilder(" Insert Into f_opdpanelapproval (isActive,PanelAppUserID,TransactionID,UserID,PanelApprovedAmt,PanelApprovalDate,PanelAppRemarks,PanelAppRemarksHistory,ApprovalFileName,ApprovalURL,PanelApprovalType,AmountApprovalType,ApprovalExpiryDate,ClaimNo,PanelID) ");
                sqlCMD.Append(" VALUES(1,@EntryBy,@TransactionID, @EntryBy, @ApprovalAmount, now(), @ApprovalRemark, @PanelAppRemarksHistory, '', '', 'A', 'Open', @PolicyExpiryDate, @PolicyNumber, @panelID) ");

                response = excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
                {

                    TransactionID = TransactionId,
                    ApprovalAmount = Util.GetDecimal(dataPMH[0].PanelPaybleAmt),
                    PolicyExpiryDate = Util.GetDateTime(dataPMH[0].ExpiryDate).ToString("yyyy-MM-dd"),
                    PolicyNumber = dataPMH[0].PolicyNo,
                    EntryBy = HttpContext.Current.Session["ID"].ToString(),
                    ApprovalRemark = "",
                    PanelAppRemarksHistory = " Date : " + Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd") + "  User : " + HttpContext.Current.Session["LoginName"].ToString() + "  UserID : " + HttpContext.Current.Session["ID"].ToString() + ",  Remarks :'' ",
                    panelID = dataPMH[0].PanelID
                });


                sqlCMD = new StringBuilder("INSERT INTO panel_amountallocation (PanelID, TransactionID, Amount, EntryBy, EntryType ) VALUES (@panelID,@transactionID,@ApprovalAmount,@EntryBy,'CR') ");

                response = excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
                {
                    transactionID = TransactionId,
                    ApprovalAmount = Util.GetDecimal(dataPMH[0].PanelPaybleAmt),
                    EntryBy = HttpContext.Current.Session["ID"].ToString(),
                    panelID = dataPMH[0].PanelID
                });

            }


            //Devendra Singh 2018-12-28 Insert Finance Integarion 
            if (Resources.Resource.AllowFiananceIntegration == "1")
            {
                string IsIntegrated = string.Empty;
                int TransactionTypeID = 0;
                if (isIPDBilling)
                {
                    TransactionTypeID = 3;
                    IsIntegrated = Util.GetString(EbizFrame.InsertIPDTransaction(Util.GetInt(ledTxnID), ReceiptNo, "R", tnx));
                    if (IsIntegrated == "0")
                    {
                        tnx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Finance Integration Details IPD" });
                    }
                }
                else if (!isEMGBilling)
                {
                    TransactionTypeID = 16;
                    IsIntegrated = Util.GetString(EbizFrame.InsertOPDTransaction(Util.GetInt(ledTxnID), ReceiptNo, "R", tnx));
                    if (IsIntegrated == "0")
                    {
                        tnx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Finance Integration Details OPD" });
                    }
                }
                if (isEMGBilling)
                    TransactionTypeID = 3;
                IsIntegrated = Util.GetString(EbizFrame.InsertInventoryTransaction(Util.GetInt(ledTxnID), 0, TransactionTypeID, SalesNo, tnx));
                if (IsIntegrated == "0")
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Finance Integration Details Stock Transfer" });
                }
            }

            if (creditBillNO != "")
            {
                int countBillno = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM `patient_medical_history` pmh WHERE pmh.`CentreID`='" + HttpContext.Current.Session["CentreID"].ToString() + "' AND pmh.`BillNo`='" + creditBillNO + "'  "));
                if (countBillno != 0)
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Please refresh the page", message = "Error In same billno generate." });
                }
            }
            
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully", ledTxnID = ledTxnID, customerID = customerID, DeptLedgerNo = DeptLedgerNo, IsBill = IsBill, ReceiptNo = ReceiptNo });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public int updateEmergencyBillAmounts(MySqlTransaction tnx, string LedgerTnxNo)
    {
        try
        {
            string UpdateQuery = "Call updateEmergencyBillAmounts(" + LedgerTnxNo + ")";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, UpdateQuery);
            return 1;
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    [WebMethod]
    public string BindMedicineDetail(string ItemID, string DeptLedgerNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT ST.stockid,ST.ItemID,DATE_FORMAT(st.MedExpiryDate,'%d-%b-%y')Expiry,ST.BatchNumber, ");
        sb.Append(" ST.MRP,round((ST.MRP*IM.ConversionFactor),2)MajorMRP,ST.UnitPrice,IM.ConversionFactor, ");
        sb.Append("(ST.InitialCount - ST.ReleasedCount)AvlQty ");
        sb.Append("  ");
        sb.Append("  FROM f_stock ST ");
        sb.Append(" INNER JOIN f_itemmaster IM ON ST.ItemID=IM.ItemID ");
        sb.Append(" WHERE (ST.InitialCount - ST.ReleasedCount) > 0 AND ST.IsPost = 1  ");
        sb.Append("  AND IM.ItemID ='" + ItemID + "'  AND st.DeptLedgerNo='" + DeptLedgerNo + "'  ");
        sb.Append(" AND (IF(im.IsExpirable = 'NO','2050-01-01',st.MedExpiryDate) > CURDATE()) ORDER BY st.MedExpiryDate ");
        DataTable oDT = StockReports.GetDataTable(sb.ToString());
        if (oDT.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(oDT);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string BindIPDItemForLabelPrint(string IndentNo)
    {
        bool IsContainHas = IndentNo.Contains('#');     

        StringBuilder sb = new StringBuilder();
        /* sb.Append(" SELECT ipp.ReceiveQty Quantity,ipp.ItemID,ipp.ItemName AS TypeName,ipp.IndentNo, DATE_FORMAT(ltd.MedExpiryDate,'%d-%b-%y') AS MedExpiryDate,  ");
         sb.Append("CONCAT(pm.Title,' ', pm.PName) AS PName, ");
         sb.Append(" '' Side_Effect,'' Meal ");
         sb.Append("  ,IFNULL(om.`Dose`,0) Dose,IFNULL(DATEDIFF(om.`Duration`,DATE(om.`EntryDate`))+1,0)Duration,IFNULL(om.`Route`,0)Route,IFNULL(om.`Timing` ,0)Timing ");
         sb.Append(" FROM f_ledgertnxdetail ltd INNER JOIN f_indent_detail_patient ipp ON ipp.ItemId=ltd.ItemID ");
         sb.Append("INNER JOIN patient_medical_history pmh ON pmh.TransactionID = ipp.TransactionID ");
         sb.Append(" LEFT JOIN orderset_medication om ON om.`IndentNo`=ipp.`IndentNo` AND ipp.`ItemID`=om.`MedicineID` AND ipp.`TransactionID`=om.`TransactionID` ");
         sb.Append("INNER JOIN patient_master pm ON pm.PatientID = pmh.PatientID ");
         sb.Append("WHERE ipp.IndentNo='" + IndentNo + "' GROUP BY ipp.ItemID "); */

        if (IsContainHas)
        {
            if (IndentNo.Split('#')[1].ToString()!="")
            {

              /* sb.Append(" SELECT ipp.ItemID,ipp.ItemName AS TypeName,ipp.IndentNo,pmh.PatientID, CONCAT(pm.Title,' ', pm.PName) AS PName, ");
                sb.Append(" DATE_FORMAT(ltd.MedExpiryDate,'%d-%b-%y') AS MedExpiryDate,  '' Side_Effect, '' Meal , '' Duration, '' Route,'' Timing, ");
                sb.Append(" ipp.ReceiveQty Quantity,IFNULL(CONCAT(om.Dose,IFNULL( om.DoseUnit,'')),'0')Dose,om.DurationVal,om.IntervalId,'' Remarks  ");
                sb.Append(" FROM f_ledgertnxdetail ltd ");
                sb.Append(" INNER JOIN f_indent_detail_patient ipp ON ipp.ItemId=ltd.ItemID  ");
                sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID = ipp.TransactionID  ");
                sb.Append(" left JOIN tenwek_docotor_medicine_order om ON om.`IndentNo`=ipp.`IndentNo` ");
                sb.Append(" AND ipp.`ItemID`=om.`ItemID` AND ipp.`TransactionID`=om.`TransactionID` ");
                sb.Append(" INNER JOIN patient_master pm ON pm.PatientID = pmh.PatientID WHERE ipp.IndentNo='" + IndentNo.Split('#')[1].ToString() + "'  and om.`IsActive`=1  om.GROUP BY ipp.ItemID  ");*/ 

                //sb.Append(" SELECT sd.ItemID,st.ItemName AS TypeName,tmo.IndentNo,sd.PatientID, CONCAT(pm.Title,' ', pm.PName) AS PName, ");
                //sb.Append(" CONCAT(DATE_FORMAT(Sd.Date,'%d-%b-%Y'),' ',TIME_FORMAT(sd.Time,'%h:%i %p'))IssueDateTime, ");
                //sb.Append(" '' MedExpiryDate,  '' Side_Effect, '' Meal , '' Duration, '' Route,'' Timing, ");
                //sb.Append(" sd.SoldUnits Quantity,IFNULL(CONCAT(tmo.Dose,IFNULL( tmo.DoseUnit,'')),'0')Dose,tmo.DurationVal,tmo.IntervalId,'' Remarks ");
                //sb.Append("  FROM  tenwek_docotor_medicine_order tmo ");
                //sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID = tmo.TransactionID   ");
                //sb.Append(" INNER JOIN patient_master pm ON pm.PatientID = pmh.PatientID ");
                //sb.Append(" INNER JOIN f_salesdetails sd ON sd.IndentNo = tmo.IndentNo ");
                //sb.Append(" INNER  JOIN f_stock st ON st.StockID=sd.StockID   ");
                //sb.Append(" WHERE  sd.IndentNo='" + IndentNo.Split('#')[1].ToString() + "'  GROUP BY sd.ID Order by tmo.ItemName ");

                sb.Append(" SELECT sd.ItemID,st.ItemName AS TypeName,IFNULL(tmo.IndentNo,''),sd.PatientID, CONCAT(pm.Title,' ', pm.PName) AS PName, ");
                sb.Append(" CONCAT(DATE_FORMAT(Sd.Date,'%d-%b-%Y'),' ',TIME_FORMAT(sd.Time,'%h:%i %p'))IssueDateTime, ");
                sb.Append(" '' MedExpiryDate,  '' Side_Effect, '' Meal , '' Duration, '' Route,'' Timing, ");
                sb.Append(" sum(sd.SoldUnits) Quantity,IFNULL(CONCAT(tmo.Dose,IFNULL( tmo.DoseUnit,'')),'0')Dose,IFNULL(tmo.DurationVal,'')DurationVal,IFNULL(tmo.IntervalId,'')IntervalId,'' Remarks ");
                sb.Append("  FROM  f_salesdetails sd   ");
                sb.Append(" LEFT JOIN tenwek_docotor_medicine_order tmo ON sd.IndentNo = tmo.IndentNo  AND sd.ItemID=tmo.ItemId AND sd.TransactionID=tmo.TransactionId ");
                sb.Append(" left JOIN patient_medical_history pmh ON pmh.TransactionID = tmo.TransactionID   ");
                sb.Append(" left JOIN patient_master pm ON pm.PatientID = sd.PatientID ");
                sb.Append(" INNER  JOIN f_stock st ON st.StockID=sd.StockID   ");
                sb.Append(" WHERE  (sd.LedgertransactionNo='" + IndentNo.Split('#')[0].ToString() + "' OR sd.IndentNo='" + IndentNo.Split('#')[1].ToString() + "')  GROUP BY sd.ItemID Order by st.ItemName ");
            }
            else
            {
               /* sb.Append("  SELECT ltd.ItemID,ltd.ItemName AS TypeName,'' IndentNo,pmh.PatientID, CONCAT(pm.Title,' ', pm.PName) AS PName, ");
                sb.Append(" DATE_FORMAT(ltd.MedExpiryDate,'%d-%b-%y') AS MedExpiryDate,  '' Side_Effect, '' Meal , '' Duration, '' Route,'' Timing, ");
                sb.Append(" ltd.Quantity Quantity,'0' Dose,'0' DurationVal,'0' IntervalId,'' Remarks ");
                sb.Append("     FROM f_ledgertnxdetail ltd   ");
                sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID = ltd.TransactionID ");
                sb.Append(" INNER JOIN patient_master pm ON pm.PatientID = pmh.PatientID ");
                sb.Append(" INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID=ltd.SubcategoryID AND sm.CategoryID IN(5,38) ");              
                sb.Append(" WHERE ltd.LedgerTransactionNo='" + IndentNo.Split('#')[0].ToString() + "' GROUP BY ltd.ItemID  ; "); */
                
                sb.Append(" SELECT sd.ItemID,im.TypeName,sd.IndentNo,pmh.PatientID, CONCAT(pm.Title,' ', pm.PName) AS PName, ");
                sb.Append(" CONCAT(DATE_FORMAT(Sd.Date,'%d-%b-%Y'),' ',TIME_FORMAT(sd.Time,'%h:%i %p'))IssueDateTime, ");
                sb.Append(" '' MedExpiryDate,  '' Side_Effect, '' Meal , '' Duration, '' Route,'' Timing,  ");
                sb.Append(" sd.SoldUnits Quantity,'' Dose,'' DurationVal,'' IntervalId,'' Remarks ");
                sb.Append(" FROM f_salesdetails sd ");
                sb.Append(" INNER JOIN f_itemmaster im ON im.itemid = sd.ItemID ");
                sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID = sd.TransactionID  ");
                sb.Append(" INNER JOIN patient_master pm ON pm.PatientID = pmh.PatientID ");
                sb.Append(" WHERE sd.LedgertransactionNo='" + IndentNo.Split('#')[0].ToString() + "'  ORDER BY sd.ID DESC ");
                //AND sd.IndentNo='" + IndentNo.Split('#')[1].ToString() + "'
    
            }
        }
        else
        {
            sb.Append(" SELECT ipp.ItemID,ipp.ItemName AS TypeName,ipp.IndentNo,pmh.PatientID, CONCAT(pm.Title,' ', pm.PName) AS PName, ");
            sb.Append(" DATE_FORMAT(ltd.MedExpiryDate,'%d-%b-%y') AS MedExpiryDate,  '' Side_Effect, '' Meal , '' Duration, '' Route,'' Timing, ");
            sb.Append(" ipp.ReceiveQty Quantity,IFNULL(CONCAT(om.Dose,IFNULL( om.DoseUnit,'')),'0')Dose,om.DurationVal,om.IntervalId,'' Remarks  ");
            sb.Append(" FROM f_ledgertnxdetail ltd ");
            sb.Append(" INNER JOIN f_indent_detail_patient ipp ON ipp.ItemId=ltd.ItemID  ");
            sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID = ipp.TransactionID  ");
            sb.Append(" left JOIN tenwek_docotor_medicine_order om ON om.`IndentNo`=ipp.`IndentNo` ");
            sb.Append(" AND ipp.`ItemID`=om.`ItemID` AND ipp.`TransactionID`=om.`TransactionID` ");
            sb.Append(" INNER JOIN patient_master pm ON pm.PatientID = pmh.PatientID WHERE ipp.IndentNo='" + IndentNo + "' GROUP BY ipp.ItemID  ");

        }
        
        
        DataTable ipdLab = StockReports.GetDataTable(sb.ToString());
        if (ipdLab.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(ipdLab);
        else
            return "";
    }

    [WebMethod(EnableSession = true, Description = "Get Tax Amount")]
    public string GetTaxAmount(object Data)
    {
        return AllLoadData_Store.taxCalulation(Data);
    }

    [WebMethod(EnableSession = true, Description = "Update GRN")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string AddGRNItem(object ItemDetail)
    {
        List<GRNDetail> dataGRN = new JavaScriptSerializer().ConvertToType<List<GRNDetail>>(ItemDetail);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string LedTxnID = string.Empty; string StockID = string.Empty;
            for (int i = 0; i < dataGRN.Count; i++)
            {
                decimal Rate1 = dataGRN[i].Rate;
                decimal Deal = Util.GetDecimal(dataGRN[i].Deal1) + Util.GetDecimal(dataGRN[i].Deal2);
                string DealTotal = string.Empty;
                if (Deal > 0)
                {
                    Rate1 = (dataGRN[i].Quantity * dataGRN[i].Rate) / Deal;
                    DealTotal = Util.GetString(dataGRN[i].Deal1) + "+" + Util.GetString(dataGRN[i].Deal2);
                }

                decimal discountPer = 0; decimal discountAmt = 0;
                if (dataGRN[i].DiscAmt > 0)
                {
                    discountPer = Math.Round((dataGRN[i].DiscAmt * 100) / dataGRN[i].Rate, 2);
                    discountAmt = Util.GetDecimal(dataGRN[i].DiscAmt);
                }
                else
                {
                    discountPer = dataGRN[i].DiscPer;
                    discountAmt = dataGRN[i].DiscAmt;
                }

                List<TaxCalculation_DirectGRN> taxCalculate = new List<TaxCalculation_DirectGRN>()
                    {
                        new TaxCalculation_DirectGRN
                        {
                            DiscAmt=Util.GetDecimal(dataGRN[i].DiscAmt),
                            DiscPer=Util.GetDecimal(dataGRN[i].DiscPer),
                            MRP=Util.GetDecimal(dataGRN[i].MRP),
                            Quantity = Util.GetDecimal(dataGRN[i].Quantity),
                            Rate=Util.GetDecimal(Rate1),
                            TaxPer = Util.GetDecimal(dataGRN[i].IGSTPer+dataGRN[i].CGSTPer+dataGRN[i].SGSTPer),
                            Type = Util.GetString(dataGRN[i].TaxCalOn),
                            deal =Util.GetDecimal(dataGRN[i].Deal1),
                            deal2= Util.GetDecimal(dataGRN[i].Deal2),
                            ActualRate=Util.GetDecimal(dataGRN[i].Rate),
                            IGSTPrecent=Util.GetDecimal(dataGRN[i].IGSTPer),
                            CGSTPercent=Util.GetDecimal(dataGRN[i].CGSTPer),
                            SGSTPercent=Util.GetDecimal(dataGRN[i].SGSTPer),
                        }
                    };

                string taxCalculation = AllLoadData_Store.taxCalulation(taxCalculate);

                Stock objStock = new Stock(tnx);
                float MRP = Util.GetFloat(dataGRN[i].MRP);
                objStock.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                objStock.ItemID = Util.GetString(dataGRN[i].ItemID);
                objStock.ItemName = Util.GetString(dataGRN[i].ItemName);
                objStock.LedgerTransactionNo = Util.GetString(dataGRN[i].LedgerTnxNo);
                objStock.LedgerTnxNo = Util.GetString(dataGRN[i].LedgerTnxNo);
                objStock.BatchNumber = Util.GetString(dataGRN[i].BatchNumber);



                objStock.MRP = Util.GetDecimal(Util.GetFloat(MRP)) / Util.GetDecimal(dataGRN[i].ConversionFactor);
                objStock.MajorMRP = Util.GetDecimal(Util.GetFloat(MRP));
                objStock.IsCountable = 1;
                objStock.InitialCount = Util.GetDecimal(Util.GetFloat(dataGRN[i].Quantity) * Util.GetFloat(dataGRN[i].ConversionFactor));
                objStock.ReleasedCount = 0;
                objStock.IsReturn = 0;
                objStock.LedgerNo = string.Empty;
                if (Util.GetString(dataGRN[i].ExpiryDate).Length > 0)
                {
                    objStock.MedExpiryDate = Util.GetDateTime(dataGRN[i].ExpiryDate);
                }
                else
                {
                    objStock.MedExpiryDate = DateTime.Now.AddYears(5);
                }
                objStock.StockDate = DateTime.Now;
                if (Util.GetString(dataGRN[i].StoreLedgerNo) == "STO00001")
                {
                    objStock.TypeOfTnx = "Purchase";
                    objStock.StoreLedgerNo = "STO00001";
                }
                else if (Util.GetString(dataGRN[i].StoreLedgerNo) == "STO00002")
                {
                    objStock.TypeOfTnx = "NMPURCHASE";
                    objStock.StoreLedgerNo = "STO00002";
                }
                objStock.IsPost = 0;
                objStock.Naration = "";

                int IsFree = 0;
                if (Util.GetString(dataGRN[i].IsFree) == "No")
                {
                    if (Util.GetDecimal(dataGRN[i].ConversionFactor) > 0)
                        objStock.UnitPrice = Util.GetDecimal(Util.GetDecimal(taxCalculation.Split('#')[4].ToString()) / Util.GetDecimal(dataGRN[i].ConversionFactor));
                    else
                        objStock.UnitPrice = Util.GetDecimal(dataGRN[i].ConversionFactor);

                    objStock.PurTaxPer = Util.GetDecimal(dataGRN[i].IGSTPer + dataGRN[i].CGSTPer + dataGRN[i].SGSTPer);
                    objStock.PurTaxAmt = Util.GetDecimal(taxCalculation.Split('#')[1].ToString());
                    objStock.DiscPer = Util.GetDecimal(dataGRN[i].DiscPer);
                    objStock.DiscAmt = Util.GetDecimal(taxCalculation.Split('#')[2].ToString());
                    objStock.Rate = Util.GetDecimal(dataGRN[i].Rate);
                    objStock.IGSTPercent = Util.GetDecimal(dataGRN[i].IGSTPer);
                    objStock.IGSTAmtPerUnit = Math.Round(Util.GetDecimal(taxCalculation.Split('#')[8].ToString()) / (Util.GetDecimal(objStock.InitialCount)), 4, MidpointRounding.AwayFromZero);
                    objStock.CGSTPercent = Util.GetDecimal(dataGRN[i].CGSTPer);
                    objStock.CGSTAmtPerUnit = Math.Round(Util.GetDecimal(taxCalculation.Split('#')[9].ToString()) / (Util.GetDecimal(objStock.InitialCount)), 4, MidpointRounding.AwayFromZero);
                    objStock.SGSTPercent = Util.GetDecimal(dataGRN[i].SGSTPer);
                    objStock.SGSTAmtPerUnit = Math.Round(Util.GetDecimal(taxCalculation.Split('#')[10].ToString()) / (Util.GetDecimal(objStock.InitialCount)), 4, MidpointRounding.AwayFromZero);
                }
                else
                {
                    IsFree = 1;
                    objStock.UnitPrice = Util.GetDecimal(0);
                    objStock.PurTaxPer = Util.GetDecimal(dataGRN[i].IGSTPer + dataGRN[i].CGSTPer + dataGRN[i].SGSTPer);
                    objStock.PurTaxAmt = Util.GetDecimal(0);
                    objStock.DiscPer = Util.GetDecimal(0);
                    objStock.DiscAmt = Util.GetDecimal(0);
                    objStock.Rate = Util.GetDecimal(0);
                    objStock.IGSTPercent = Util.GetDecimal(dataGRN[i].IGSTPer);
                    objStock.IGSTAmtPerUnit = Util.GetDecimal(0);
                    objStock.CGSTPercent = Util.GetDecimal(dataGRN[i].CGSTPer);
                    objStock.CGSTAmtPerUnit = Util.GetDecimal(0);
                    objStock.SGSTPercent = Util.GetDecimal(dataGRN[i].SGSTPer);
                    objStock.SGSTAmtPerUnit = Util.GetDecimal(0);
                }

                objStock.IsFree = IsFree;
                objStock.SubCategoryID = Util.GetString(dataGRN[i].SubCategoryID);
                objStock.Unit = Util.GetString(dataGRN[i].SaleUnit);
                objStock.DeptLedgerNo = HttpContext.Current.Session["DeptLedgerNo"].ToString();
                objStock.UserID = HttpContext.Current.Session["ID"].ToString();
                objStock.IsBilled = 1;
                objStock.VenLedgerNo = Util.GetString(dataGRN[i].VenLedgerNo);
                objStock.TYPE = Util.GetString(dataGRN[i].Type_ID);
                objStock.Reusable = dataGRN[i].IsUsable;
                objStock.ConversionFactor = Util.GetDecimal(dataGRN[i].ConversionFactor);
                objStock.MajorUnit = Util.GetString(dataGRN[i].PurchaseUnit);
                objStock.MinorUnit = Util.GetString(dataGRN[i].SaleUnit);
                objStock.InvoiceNo = dataGRN[i].InvoiceNo;
                objStock.InvoiceDate = Util.GetDateTime(dataGRN[i].InvoiceDate);
                objStock.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                objStock.IpAddress = All_LoadData.IpAddress();
                objStock.IsExpirable = Util.GetInt((dataGRN[i].IsExpirable.ToUpper() == "YES" || dataGRN[i].IsExpirable.ToUpper() == string.Empty) ? 1 : 0);
                objStock.SaleTaxPer = Util.GetDecimal(0);

                objStock.ExciseAmt = Util.GetDecimal(0);
                objStock.ExcisePer = Util.GetDecimal(0);
                objStock.taxCalculateOn = Util.GetString(dataGRN[i].TaxCalOn);
                objStock.isDeal = Util.GetString(DealTotal);
                objStock.HSNCode = Util.GetString(dataGRN[i].HSNCode);
                objStock.GSTType = Util.GetString(dataGRN[i].GST_Type);
                objStock.SpecialDiscPer = Util.GetDecimal(0);
                objStock.SpecialDiscAmt = Util.GetDecimal(0);

                StockID = objStock.Insert().ToString();

                if (StockID == string.Empty)
                {

                    tnx.Rollback();
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();

                    return string.Empty;
                }

                LedgerTnxDetail objLTDetail = new LedgerTnxDetail(tnx);
                objLTDetail.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
                objLTDetail.LedgerTransactionNo = dataGRN[i].LedgerTnxNo;
                objLTDetail.ItemID = Util.GetString(dataGRN[i].ItemID).Trim();
                objLTDetail.SubCategoryID = Util.GetString(dataGRN[i].SubCategoryID).Trim();

                objLTDetail.Quantity = Util.GetDecimal(dataGRN[i].Quantity);
                objLTDetail.StockID = StockID;
                objLTDetail.ItemName = Util.GetString(dataGRN[i].ItemName).Trim();
                objLTDetail.EntryDate = DateTime.Now;
                objLTDetail.UserID = HttpContext.Current.Session["ID"].ToString();
                objLTDetail.UpdatedDate = DateTime.Now;
                if (Util.GetString(dataGRN[i].IGSTPer + dataGRN[i].CGSTPer + dataGRN[i].SGSTPer) != string.Empty && Util.GetDecimal(dataGRN[i].IGSTPer + dataGRN[i].CGSTPer + dataGRN[i].SGSTPer) > 0)
                    objLTDetail.IsTaxable = "YES";
                else
                    objLTDetail.IsTaxable = "NO";

                IsFree = 0;
                if (Util.GetString(dataGRN[i].IsFree) == "No")
                {
                    objLTDetail.Rate = Util.GetDecimal(dataGRN[i].Rate);
                    objLTDetail.DiscountPercentage = Util.GetDecimal(dataGRN[i].DiscPer);
                    objLTDetail.DiscAmt = Util.GetDecimal(taxCalculation.Split('#')[2].ToString());
                    objLTDetail.Amount = Util.GetDecimal(taxCalculation.Split('#')[3].ToString());
                    objLTDetail.NetItemAmt = Util.GetDecimal(objLTDetail.Amount);
                    objLTDetail.TotalDiscAmt = Util.GetDecimal(objLTDetail.DiscAmt);
                    objLTDetail.PurTaxAmt = Util.GetDecimal(taxCalculation.Split('#')[1].ToString());
                    objLTDetail.PurTaxPer = Util.GetDecimal(dataGRN[i].IGSTPer + dataGRN[i].CGSTPer + dataGRN[i].SGSTPer);
                    objLTDetail.IGSTPercent = Util.GetDecimal(dataGRN[i].IGSTPer);
                    objLTDetail.IGSTAmt = Util.GetDecimal(taxCalculation.Split('#')[8].ToString());
                    objLTDetail.CGSTPercent = Util.GetDecimal(dataGRN[i].CGSTPer);
                    objLTDetail.CGSTAmt = Util.GetDecimal(taxCalculation.Split('#')[9].ToString());
                    objLTDetail.SGSTPercent = Util.GetDecimal(dataGRN[i].SGSTPer);
                    objLTDetail.SGSTAmt = Util.GetDecimal(taxCalculation.Split('#')[10].ToString());
                    objLTDetail.SpecialDiscPer = Util.GetDecimal(0);
                    objLTDetail.SpecialDiscAmt = Util.GetDecimal(0);
                    if (Util.GetFloat(dataGRN[i].ConversionFactor) > 0)
                        objLTDetail.unitPrice = Util.GetDecimal(Util.GetDecimal(taxCalculation.Split('#')[4].ToString())) / Util.GetDecimal(dataGRN[i].ConversionFactor);
                    else
                        objLTDetail.unitPrice = Util.GetDecimal(0);
                }
                else
                {
                    IsFree = 1;
                    objLTDetail.Rate = Util.GetDecimal(0);
                    objLTDetail.DiscountPercentage = Util.GetDecimal(0);
                    objLTDetail.DiscAmt = Util.GetDecimal(0);
                    objLTDetail.Amount = Util.GetDecimal(0);
                    objLTDetail.NetItemAmt = Util.GetDecimal(0);
                    objLTDetail.TotalDiscAmt = Util.GetDecimal(0);
                    objLTDetail.PurTaxAmt = Util.GetDecimal(0);
                    objLTDetail.PurTaxPer = Util.GetDecimal(0);
                    objLTDetail.IGSTPercent = Util.GetDecimal(0);
                    objLTDetail.IGSTAmt = Util.GetDecimal(0);
                    objLTDetail.CGSTPercent = Util.GetDecimal(0);
                    objLTDetail.CGSTAmt = Util.GetDecimal(0);
                    objLTDetail.SGSTPercent = Util.GetDecimal(0);
                    objLTDetail.SGSTAmt = Util.GetDecimal(0);
                    objLTDetail.SpecialDiscPer = Util.GetDecimal(0);
                    objLTDetail.SpecialDiscAmt = Util.GetDecimal(0);
                    objLTDetail.unitPrice = Util.GetDecimal(0);
                }

                objLTDetail.IsFree = IsFree;
                objLTDetail.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                objLTDetail.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                objLTDetail.medExpiryDate = Util.GetDateTime(dataGRN[i].ExpiryDate);
                objLTDetail.IsExpirable = Util.GetInt((dataGRN[i].IsExpirable.ToUpper() == "YES" || dataGRN[i].IsExpirable.ToUpper() == string.Empty) ? 1 : 0);
                objLTDetail.pageURL = All_LoadData.getCurrentPageName();
                objLTDetail.IpAddress = HttpContext.Current.Request.UserHostAddress;
                objLTDetail.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(dataGRN[i].SubCategoryID), con));
                objLTDetail.Type = "S";
                objLTDetail.BatchNumber = Util.GetString(dataGRN[i].BatchNumber);
                objLTDetail.StoreLedgerNo = Util.GetString(dataGRN[i].StoreLedgerNo);
                objLTDetail.DeptLedgerNo = HttpContext.Current.Session["DeptLedgerNo"].ToString();
                objLTDetail.HSNCode = Util.GetString(dataGRN[i].HSNCode);
                string LdgTrnxDtlID = objLTDetail.Insert().ToString();

                if (LdgTrnxDtlID == string.Empty)
                {
                    tnx.Rollback();
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();
                    return string.Empty;
                }

            }

            StringBuilder sb = new StringBuilder();
            sb.Append(" UPDATE f_ledgertransaction lt  ");
            sb.Append(" INNER JOIN ( ");
            sb.Append(" SELECT ROUND(SUM((ltd.Rate*ltd.Quantity)-ltd.Discamt+ltd.purtaxamt))NewNetAmt,SUM((ltd.Rate*ltd.Quantity)-ltd.Discamt+ltd.purtaxamt)NewGrossAmt, ");
            sb.Append(" SUM(DiscAmt+SpecialDiscAmt)DiscAmt ,(ROUND(SUM((ltd.Rate*ltd.Quantity)-ltd.Discamt+ltd.purtaxamt))-SUM((ltd.Rate*ltd.Quantity)-ltd.Discamt+ltd.purtaxamt))RoundOff, ");
            sb.Append(" lt.`LedgerTransactionNo` ");
            sb.Append(" FROM  f_ledgertransaction lt ");
            sb.Append(" INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo=ltd.LedgerTransactionNo  ");
            sb.Append(" WHERE lt.LedgerTransactionNo='" + dataGRN[0].LedgerTnxNo + "')t ON lt.`LedgerTransactionNo`=t.LedgerTransactionNo ");
            sb.Append(" SET lt.`NetAmount`=t.NewNetAmt,lt.`GrossAmount`=t.NewGrossAmt,lt.`DiscountOnTotal`=t.DiscAmt,lt.`RoundOff`=t.RoundOff ");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

            tnx.Commit();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            return dataGRN[0].LedgerTnxNo;

        }


        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    //Chalan Work Starts
    [WebMethod(EnableSession = true, Description = "Get GRN List")]
    public string EditGRN(string VendorId, string GRNNo)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT t.LedgerTransactionNo,REPLACE(t.LedgerTransactionNo,'/','_')LedTnxNo,t.LedgerNoCr,IFNULL(im.`InvoiceNo`,'')InvoiceNo,IF(im.`InvoiceNo`='','',DATE_FORMAT(im.`InvoiceDate`,'%d-%b-%Y'))InvoiceDate,IFNULL(im.`ChalanNo`,'')ChalanNo,IF(im.`ChalanNo`='','',DATE_FORMAT(im.`ChalanDate`,'%d-%b-%Y'))ChalanDate,IF(SUM(isPost)='0','false','true')IsPost FROM ( ");
        sb.Append(" SELECT lt.`LedgerTransactionNo`,lt.`LedgerNoCr`,IF(st.`IsPost`='1','1','0')isPost FROM f_ledgertransaction lt ");
        sb.Append(" INNER JOIN f_stock st ON lt.`LedgerTransactionNo`=st.`LedgerTransactionNo` ");
        sb.Append(" WHERE  lt.LedgerNoCr='" + VendorId + "' AND lt.`InvoiceNo`='' AND lt.`IsCancel`='0' ");
        sb.Append(" UNION ALL ");
        sb.Append(" SELECT lt.`LedgerTransactionNo`,lt.`LedgerNoCr`,IF(st.`IsPost`='1','1','0')isPost FROM f_ledgertransaction lt ");
        sb.Append(" INNER JOIN f_stock st ON lt.`LedgerTransactionNo`=st.`LedgerTransactionNo` ");
        sb.Append(" WHERE  lt.`LedgerTransactionNo`='" + GRNNo + "' AND lt.`IsCancel`='0' ");
        sb.Append(" )t INNER JOIN f_invoicemaster im ON im.`LedgerTnxNo`=t.LedgerTransactionNo ");
        sb.Append(" GROUP BY t.LedgerTransactionNo ORDER BY t.LedgerTransactionNo ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";

    }
    [WebMethod(EnableSession = true, Description = "Load GRN Items")]
    public string LoadGRNItems(string GRNNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT st.`StockID`,st.`ItemID`,st.`ItemName`,st.`ConversionFactor`,st.`MinorUnit`,st.`MajorUnit`,st.`HSNCode`,st.`BatchNumber`,st.`Rate`,st.`MajorMRP` MRP,(st.`InitialCount`/st.`ConversionFactor`)QTY,  ");
        sb.Append(" DATE_FORMAT(st.`MedExpiryDate`,'%d-%b-%Y')ExpDate,st.`DiscPer`,st.`SpecialDiscPer`,st.`GSTType`,st.`CGSTPercent`,st.`SGSTPercent`,st.`IGSTPercent`,IF(st.`IsPost`=1,'True','false')Post,st.`LedgerTransactionNo` GRNNO,IF(st.`IsFree`=1,'True','False')IsFree,IF(st.`InvoiceNo`='',IF(st.`ChalanNo`='','False','True'),'False')IsOnChalan,IF(st.`IsExpirable`='1','YES','NO')IsExpirable,IFNULL(st.`isDeal`,'')isDeal,st.`SubCategoryID`  ");
        sb.Append(" FROM f_stock st WHERE st.`LedgerTransactionNo`='" + GRNNo + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";

    }

    [WebMethod(EnableSession = true, Description = "Bind GST Types")]
    public string bindGSTType()
    {

        DataTable dt = StockReports.GetDataTable("select TaxName,TaxID from f_taxmaster where TaxID IN('T4','T6','T7') order by TaxName");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true, Description = "Update GRN")]
    public string UpdateGRNInfo(object InvMaster, object StockDetails)
    {
        List<InvoiceMaster> dataInvoice = new JavaScriptSerializer().ConvertToType<List<InvoiceMaster>>(InvMaster);
        List<Stock> dataStock = new JavaScriptSerializer().ConvertToType<List<Stock>>(StockDetails);

        MySqlConnection conn;
        MySqlTransaction tnx;
        conn = Util.GetMySqlCon();
        if (conn.State == ConnectionState.Closed)
        {
            conn.Open();
        }
        tnx = conn.BeginTransaction();

        try
        {
            string str = string.Empty;
            string chalanNo, chalanDate, invoiceNo, InvoiceDate, VenLedgerNo, LedgerTnxNo;

            for (int i = 0; i < dataStock.Count; i++)
            {
                DateTime ExpiryDate; decimal DealRate = 0; decimal perUnitPrice = 0; decimal NetAmount = 0; decimal Amount = 0; decimal Deal1 = 0; decimal Deal2 = 0;
                int isFree = 0; decimal totalTaxAmt = 0; decimal discAmt = 0; decimal LTDigstTaxAmt = 0; decimal LTDcgstTaxAmt = 0; decimal LTDsgstTaxAmt = 0;
                decimal STigstTaxAmt = 0; decimal STcgstTaxAmt = 0; decimal STsgstTaxAmt = 0; decimal SpecialDiscAmt = 0; decimal rate1 = 0;

                string Deal = Util.GetString(dataStock[i].isDeal);
                decimal totalTaxper = Math.Round(Util.GetDecimal(dataStock[i].IGSTPercent) + Util.GetDecimal(dataStock[i].CGSTPercent) + Util.GetDecimal(dataStock[i].SGSTPercent), 2);
                isFree = Util.GetInt(dataStock[i].IsFree);
                decimal ConversionFactor = Util.GetDecimal(dataStock[i].ConversionFactor);
                string ItemID = Util.GetString(dataStock[i].ItemID);
                string Itemname = Util.GetString(dataStock[i].ItemName);
                string SubcategoryID = Util.GetString(dataStock[i].SubCategoryID);
                int isExpirable = Util.GetInt(dataStock[i].IsExpirable);
                if (isExpirable == 1)
                    ExpiryDate = Util.GetDateTime(dataStock[i].MedExpiryDate);
                else
                    ExpiryDate = DateTime.Now.AddYears(5);
                string SaleUnit = Util.GetString(dataStock[i].MinorUnit);
                string MajorUnit = Util.GetString(dataStock[i].MajorUnit);
                string Batchnumber = Util.GetString(dataStock[i].BatchNumber);
                decimal excise1 = Util.GetDecimal(0);
                decimal Discper = Util.GetDecimal(dataStock[i].DiscPer);
                decimal MajorMRP = Util.GetDecimal(dataStock[i].MRP);
                decimal MRP = Util.GetDecimal(MajorMRP / ConversionFactor);
                decimal RecvQty = Util.GetDecimal(dataStock[i].InitialCount) * Util.GetDecimal(ConversionFactor);
                decimal igstPer = Util.GetDecimal(dataStock[i].IGSTPercent);
                decimal cgstPer = Util.GetDecimal(dataStock[i].CGSTPercent);
                decimal sgstPer = Util.GetDecimal(dataStock[i].SGSTPercent);
                string GSTType = Util.GetString(dataStock[i].GSTType);
                decimal SpecialDiscPer = Util.GetDecimal(dataStock[i].SpecialDiscPer);
                string stockId = Util.GetString(dataStock[i].StockID);
                string GRNNo = Util.GetString(dataStock[i].LedgerTransactionNo);
                string HSNCode = Util.GetString(dataStock[i].HSNCode);
                decimal QTY = Util.GetDecimal(dataStock[i].InitialCount);
                if (isFree != 1)
                {
                    string Amt = "";
                    DealRate = Util.GetDecimal(dataStock[i].Rate);
                    if (Deal != "")
                    {
                        Deal1 = Util.GetDecimal(Deal.Split('+')[0]);
                        Deal2 = Util.GetDecimal(Deal.Split('+')[1]);
                        decimal totalDeal = Deal1 + Deal2;
                        DealRate = Math.Round(Util.GetDecimal(Util.GetDecimal(Util.GetDecimal(dataStock[i].InitialCount) * Util.GetDecimal(dataStock[i].Rate)) / totalDeal), 4);
                    }

                    List<TaxCalculation_DirectGRN> taxCalculate = new List<TaxCalculation_DirectGRN>()
                    {
                        new TaxCalculation_DirectGRN
                        {
                            DiscAmt=Util.GetDecimal(0),
                            DiscPer=Util.GetDecimal(dataStock[i].DiscPer),
                            MRP=Util.GetDecimal(dataStock[i].MRP),
                            Quantity = QTY,
                            Rate=DealRate,
                            TaxPer=totalTaxper,
                            Type =  Util.GetString("RateAD"),
                            deal =Deal1,
                            deal2= Deal2,
                            ActualRate=Util.GetDecimal(dataStock[i].Rate),
                            IGSTPrecent=Util.GetDecimal(dataStock[i].IGSTPercent),
                            CGSTPercent=Util.GetDecimal(dataStock[i].CGSTPercent),
                            SGSTPercent=Util.GetDecimal(dataStock[i].SGSTPercent),
                            SpecialDiscPer=Util.GetDecimal(dataStock[i].SpecialDiscPer)
                         }
                   };
                    Amt = AllLoadData_Store.taxCalulation(taxCalculate);
                    rate1 = Util.GetDecimal(dataStock[i].Rate);
                    perUnitPrice = Util.GetDecimal(Amt.Split('#')[4].ToString()) / ConversionFactor;
                    NetAmount = Util.GetDecimal(Amt.Split('#')[0].ToString());
                    Amount = Util.GetDecimal(Amt.Split('#')[3].ToString());
                    totalTaxAmt = Util.GetDecimal(Amt.Split('#')[1].ToString());
                    discAmt = Util.GetDecimal(Amt.Split('#')[2].ToString());
                    LTDigstTaxAmt = Util.GetDecimal(Amt.Split('#')[8].ToString());
                    LTDcgstTaxAmt = Util.GetDecimal(Amt.Split('#')[9].ToString());
                    LTDsgstTaxAmt = Util.GetDecimal(Amt.Split('#')[10].ToString());
                    STigstTaxAmt = Math.Round(LTDigstTaxAmt / (Util.GetDecimal(RecvQty)), 4, MidpointRounding.AwayFromZero);
                    STcgstTaxAmt = Math.Round(LTDcgstTaxAmt / (Util.GetDecimal(RecvQty)), 4, MidpointRounding.AwayFromZero);
                    STsgstTaxAmt = Math.Round(LTDsgstTaxAmt / (Util.GetDecimal(RecvQty)), 4, MidpointRounding.AwayFromZero);
                    SpecialDiscAmt = Util.GetDecimal(Amt.Split('#')[11].ToString());

                }
                if (stockId != "")
                {
                    str = "UPDATE f_stock SET ItemID='" + ItemID + "',Itemname='" + Itemname + "',BatchNumber = '" + Batchnumber.ToString() + "',UnitPrice='" + perUnitPrice + "',MRP = '" + MRP + "', majorMRP='" + MajorMRP + "',InitialCount = '" + RecvQty + "',MedExpiryDate='" + ExpiryDate.ToString("yyyy-MM-dd") + "',SubcategoryID='" + SubcategoryID + "',UnitType='" + MajorUnit + "',Rate='" + rate1 + "',DiscAmt='" + discAmt + "',DiscPer='" + Discper + "',PurTaxAmt='" + totalTaxAmt + "',PurTaxPer='" + totalTaxper + "',ConversionFactor='" + ConversionFactor + "',MajorUnit='" + MajorUnit + "',MinorUnit='" + SaleUnit + "',MajorMRP='" + MajorMRP + "',IsExpirable='" + isExpirable + "',isDeal='" + Deal + "',ExciseAmt='" + excise1 + "',IGSTPercent='" + igstPer + "',IGSTAmtPerUnit='" + STigstTaxAmt + "',CGSTPercent='" + cgstPer + "',CGSTAmtPerUnit='" + STcgstTaxAmt + "',SGSTPercent='" + sgstPer + "',SGSTAmtPerUnit='" + STsgstTaxAmt + "',GSTType='" + GSTType + "',SpecialDiscPer='" + SpecialDiscPer + "',specialDiscAmt='" + SpecialDiscAmt + "',HSNCode='" + HSNCode + "',IsFree='" + isFree + "',LastUpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "',Updatedate=NOW() WHERE stockid = '" + stockId + "' AND  LedgerTransactionNo='" + GRNNo + "'";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

                    str = " UPDATE f_ledgertnxdetail SET ItemID='" + ItemID + "',Itemname='" + Itemname + "',BatchNumber = '" + Batchnumber.ToString() + "', Quantity = '" + QTY + "',Rate='" + rate1 + "',Amount = '" + Amount + "',DiscAmt='" + discAmt + "',DiscountPercentage='" + Discper + "',medExpiryDate='" + ExpiryDate.ToString("yyyy-MM-dd") + "',IsExpirable='" + isExpirable + "',NetItemAmt='" + Amount + "',TotalDiscAmt='" + discAmt + "',PurTaxPer='" + totalTaxper + "',PurTaxAmt='" + totalTaxAmt + "',unitPrice='" + perUnitPrice + "',IGSTPercent='" + igstPer + "',IGSTAmt='" + LTDigstTaxAmt + "',CGSTPercent='" + cgstPer + "',CGSTAmt='" + LTDcgstTaxAmt + "',SGSTPercent='" + sgstPer + "',SGSTAmt='" + LTDsgstTaxAmt + "',SpecialDiscPer='" + SpecialDiscPer + "',specialDiscAmt='" + SpecialDiscAmt + "',HSNCode='" + HSNCode + "',IsFree='" + isFree + "',LastUpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdatedDate=NOW() WHERE stockid = '" + stockId + "' AND LedgerTransactionNo='" + GRNNo + "'";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
                    UpdateItem(tnx, igstPer, cgstPer, sgstPer, GSTType, stockId, perUnitPrice, STigstTaxAmt, STcgstTaxAmt, STsgstTaxAmt, HSNCode);
                }
                else
                {
                    LedgerTnxDetail objLTDetail = new LedgerTnxDetail(tnx);
                    objLTDetail.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
                    objLTDetail.LedgerTransactionNo = GRNNo;
                    objLTDetail.ItemID = ItemID;
                    objLTDetail.SubCategoryID = SubcategoryID;
                    objLTDetail.Rate = rate1;
                    objLTDetail.Quantity = QTY;
                    objLTDetail.StockID = stockId;
                    objLTDetail.ItemName = Itemname;
                    objLTDetail.EntryDate = DateTime.Now;
                    objLTDetail.UserID = HttpContext.Current.Session["ID"].ToString();
                    objLTDetail.UpdatedDate = DateTime.Now;
                    if (Util.GetString(totalTaxper) != string.Empty && Util.GetFloat(totalTaxper) > 0)
                        objLTDetail.IsTaxable = "YES";
                    else
                        objLTDetail.IsTaxable = "NO";

                    objLTDetail.DiscountPercentage = Discper;
                    objLTDetail.DiscAmt = discAmt;
                    objLTDetail.Amount = Amount;
                    objLTDetail.IsFree = isFree;
                    objLTDetail.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    objLTDetail.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                    objLTDetail.medExpiryDate = ExpiryDate;
                    objLTDetail.IsExpirable = isExpirable;
                    objLTDetail.pageURL = All_LoadData.getCurrentPageName();
                    objLTDetail.NetItemAmt = Util.GetDecimal(objLTDetail.Amount);
                    objLTDetail.TotalDiscAmt = Util.GetDecimal(objLTDetail.DiscAmt);
                    objLTDetail.IpAddress = HttpContext.Current.Request.UserHostAddress;
                    objLTDetail.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(SubcategoryID), conn));
                    objLTDetail.Type = "S";
                    objLTDetail.BatchNumber = Batchnumber;
                    objLTDetail.StoreLedgerNo = Util.GetString(StockReports.ExecuteScalar("SELECT StoreLedgerNo FROM f_stock st WHERE st.`LedgerTransactionNo`='" + GRNNo + "' LIMIT 1"));
                    objLTDetail.DeptLedgerNo = HttpContext.Current.Session["DeptLedgerNo"].ToString();
                    objLTDetail.PurTaxAmt = totalTaxAmt;
                    objLTDetail.PurTaxPer = totalTaxper;
                    objLTDetail.HSNCode = HSNCode;
                    objLTDetail.IGSTPercent = igstPer;
                    objLTDetail.IGSTAmt = LTDigstTaxAmt;
                    objLTDetail.CGSTPercent = cgstPer;
                    objLTDetail.CGSTAmt = LTDcgstTaxAmt;
                    objLTDetail.SGSTPercent = sgstPer;
                    objLTDetail.SGSTAmt = LTDsgstTaxAmt;
                    objLTDetail.SpecialDiscPer = SpecialDiscPer;
                    objLTDetail.SpecialDiscAmt = SpecialDiscAmt;
                    objLTDetail.unitPrice = perUnitPrice;
                    string LdgTrnxDtlID = objLTDetail.Insert().ToString();

                    if (LdgTrnxDtlID == string.Empty)
                    {
                        tnx.Rollback();
                        tnx.Dispose();
                        conn.Close();
                        conn.Dispose();
                        return string.Empty;
                    }
                    Stock objStock = new Stock(tnx);
                    objStock.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                    objStock.ItemID = ItemID;
                    objStock.ItemName = Itemname;
                    objStock.LedgerTransactionNo = GRNNo;
                    objStock.LedgerTnxNo = LdgTrnxDtlID;
                    objStock.BatchNumber = Batchnumber;
                    objStock.UnitPrice = Util.GetDecimal(perUnitPrice);
                    objStock.MRP = Util.GetDecimal(MRP);
                    objStock.MajorMRP = MajorMRP;
                    objStock.IsCountable = 1;
                    objStock.InitialCount = RecvQty;
                    objStock.ReleasedCount = 0;
                    objStock.IsReturn = 0;
                    objStock.LedgerNo = string.Empty;
                    objStock.MedExpiryDate = ExpiryDate;
                    objStock.StockDate = DateTime.Now;
                    if (Util.GetString(objLTDetail.StoreLedgerNo) == "STO00001")
                    {
                        objStock.TypeOfTnx = "Purchase";
                        objStock.StoreLedgerNo = "STO00001";
                    }
                    else if (Util.GetString(objLTDetail.StoreLedgerNo) == "STO00002")
                    {
                        objStock.TypeOfTnx = "NMPURCHASE";
                        objStock.StoreLedgerNo = "STO00002";
                    }
                    objStock.IsPost = 0;
                    objStock.Naration = "";
                    objStock.IsFree = isFree;
                    objStock.SubCategoryID = SubcategoryID;
                    objStock.Unit = SaleUnit;
                    objStock.DeptLedgerNo = HttpContext.Current.Session["DeptLedgerNo"].ToString();
                    objStock.UserID = HttpContext.Current.Session["ID"].ToString();
                    objStock.IsBilled = 1;
                    objStock.Rate = Util.GetDecimal(rate1);
                    objStock.DiscPer = Util.GetDecimal(Discper);
                    objStock.VenLedgerNo = Util.GetString(dataStock[i].VenLedgerNo);
                    objStock.DiscAmt = Util.GetDecimal(discAmt);
                    objStock.TYPE = Util.GetString(StockReports.ExecuteScalar("SELECT im.`Type_ID` FROM f_itemmaster im WHERE im.`ItemID`='" + ItemID + "'"));
                    //objStock.Reusable = Util.GetInt(rowItem["IsUsable"]);
                    objStock.ConversionFactor = ConversionFactor;
                    objStock.MajorUnit = MajorUnit;
                    objStock.MinorUnit = SaleUnit;
                    objStock.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    objStock.IpAddress = All_LoadData.IpAddress();
                    objStock.IsExpirable = isExpirable;
                    objStock.PurTaxPer = Util.GetDecimal(totalTaxper);
                    objStock.PurTaxAmt = Util.GetDecimal(totalTaxAmt);
                    objStock.ExciseAmt = Util.GetDecimal(0);
                    objStock.ExcisePer = Util.GetDecimal(0);
                    objStock.taxCalculateOn = Util.GetString("RateAD");
                    objStock.isDeal = Deal;
                    objStock.HSNCode = HSNCode;
                    objStock.GSTType = GSTType;
                    objStock.IGSTPercent = igstPer;
                    objStock.IGSTAmtPerUnit = STigstTaxAmt;
                    objStock.CGSTPercent = cgstPer;
                    objStock.CGSTAmtPerUnit = STcgstTaxAmt;
                    objStock.SGSTPercent = sgstPer;
                    objStock.SGSTAmtPerUnit = STsgstTaxAmt;
                    objStock.SpecialDiscPer = SpecialDiscPer;
                    objStock.SpecialDiscAmt = SpecialDiscAmt;

                    string StockIDNew = objStock.Insert().ToString();

                    if (StockIDNew == string.Empty)
                    {

                        tnx.Rollback();
                        tnx.Dispose();
                        conn.Close();
                        conn.Dispose();
                        return string.Empty;
                    }
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_ledgertnxdetail SET StockID='" + StockIDNew + "' WHERE ID=" + LdgTrnxDtlID + "");

                }


            }

            for (int i = 0; i < dataInvoice.Count; i++)
            {
                if (dataInvoice[i].ChalanNo == "")
                {
                    chalanNo = "";
                    chalanDate = "01-01-0001";
                }
                else
                {
                    chalanNo = Util.GetString(dataInvoice[i].ChalanNo);
                    chalanDate = Util.GetDateTime(dataInvoice[i].ChalanDate).ToString("yyyy-MM-dd");
                }
                if (dataInvoice[i].InvoiceNo == "")
                {
                    invoiceNo = "";
                    InvoiceDate = "01-01-0001";
                }
                else
                {
                    invoiceNo = Util.GetString(dataInvoice[i].InvoiceNo);
                    InvoiceDate = Util.GetDateTime(dataInvoice[i].InvoiceDate).ToString("yyyy-MM-dd");
                }
                VenLedgerNo = Util.GetString(dataInvoice[i].VenLedgerNo);
                LedgerTnxNo = Util.GetString(dataInvoice[i].LedgerTnxNo);
                StringBuilder sb = new StringBuilder();
                sb.Append(" UPDATE f_stock st INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionNo`=st.`LedgerTransactionNo` INNER JOIN f_invoicemaster im ON im.`LedgerTnxNo`=lt.`LedgerTransactionNo`  ");
                sb.Append(" SET st.`ChalanNo`='" + chalanNo + "',lt.`ChalanNo`='" + chalanNo + "',im.`ChalanNo`='" + chalanNo + "',st.`ChalanDate`='" + chalanDate + "',im.`ChalanDate`='" + chalanDate + "',  ");
                sb.Append(" st.`InvoiceNo`='" + invoiceNo + "',lt.`InvoiceNo`='" + invoiceNo + "',im.`InvoiceNo`='" + invoiceNo + "',st.`InvoiceDate`='" + InvoiceDate + "',im.`InvoiceDate`='" + InvoiceDate + "',  ");
                sb.Append(" st.`VenLedgerNo`='" + VenLedgerNo + "',lt.`LedgerNoCr`='" + VenLedgerNo + "',im.`VenLedgerNo`='" + VenLedgerNo + "'  ");
                sb.Append(" WHERE st.`LedgerTransactionNo`='" + LedgerTnxNo + "' ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                DataSet dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "SELECT SUM(ltd.amount)netamt,SUM(purtaxamt)purtaxamt,SUM(ltd.DiscAmt)DisAmt,sum(ltd.amount) grossAmt,Freight,Octori,lt.RoundOff,SUM(ltd.specialDiscAmt)SpecialDiscAmt FROM f_ledgertnxdetail  ltd INNER JOIN f_ledgertransaction lt ON ltd.`LedgerTransactionNo`=lt.`LedgerTransactionNo` WHERE lt.LedgerTransactionNo='" + LedgerTnxNo + "'");

                Decimal TotalAmt = Util.GetDecimal(dt.Tables[0].Rows[0]["netamt"].ToString()) + Util.GetDecimal(dt.Tables[0].Rows[0]["purtaxamt"].ToString()) - Util.GetDecimal(dt.Tables[0].Rows[0]["DisAmt"].ToString()) + Util.GetDecimal(dt.Tables[0].Rows[0]["Octori"].ToString()) + Util.GetDecimal(dt.Tables[0].Rows[0]["Freight"].ToString()) - Util.GetDecimal(dt.Tables[0].Rows[0]["SpecialDiscAmt"].ToString());
                decimal tmpAmt = Math.Round(TotalAmt, 0);
                decimal roundOff = tmpAmt - TotalAmt;
                decimal totaldiscount = Util.GetDecimal(dt.Tables[0].Rows[0]["DisAmt"].ToString()) + Util.GetDecimal(dt.Tables[0].Rows[0]["SpecialDiscAmt"].ToString());
                str = "UPDATE f_ledgertransaction lt SET lt.netamount='" + tmpAmt + "' ,lt.grossamount='" + TotalAmt + "',DiscountOnTotal='" + totaldiscount + "',RoundOff='" + roundOff + "'   WHERE lt.LedgerTransactionNo='" + LedgerTnxNo + "' ";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
                str = " UPDATE f_stock im SET InvoiceAmount='" + tmpAmt + "' WHERE im.LedgerTransactionNO='" + LedgerTnxNo + "' ";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
                str = " UPDATE f_invoicemaster  SET InvoiceAmount='" + tmpAmt + "' WHERE LedgerTnxNo='" + LedgerTnxNo + "' ";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
            }
            tnx.Commit();
            tnx.Dispose();
            conn.Close();
            conn.Dispose();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            tnx.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            conn.Close();
            conn.Dispose();
            return string.Empty;
        }


    }

    protected void UpdateItem(MySqlTransaction tnx, decimal igstPer, decimal cgstPer, decimal sgstPer, string GSTType, string stockId, decimal perUnitPrice, decimal igstAmtPerUnit, decimal cgstAmtPerUnit, decimal sgstAmtPerUnit, string HSNCode)
    {
        string str = string.Empty;
        decimal totalTaxper = Math.Round((igstPer + cgstPer + sgstPer), 4);
        DataTable dtSales = StockReports.GetDataTable("SELECT sd.`SalesID`,sd.`SoldUnits`,sd.`LedgerTnxNo`,sd.`PerUnitSellingPrice`,sd.`DiscAmt` FROM f_salesdetails sd WHERE sd.`StockID`='" + stockId + "'");
        foreach (DataRow dr in dtSales.Rows)
        {
            decimal perUnitMRP = Util.GetDecimal(dr["PerUnitSellingPrice"]);
            decimal soldQty = Util.GetDecimal(dr["SoldUnits"]);
            decimal discAmt = Util.GetDecimal(dr["DiscAmt"]);
            string salesId = Util.GetString(dr["SalesID"]);
            string LedgerTnxNo = Util.GetString(dr["LedgerTnxNo"]);

            decimal taxableAmt = ((perUnitMRP - discAmt) * 100 * soldQty) / (100 + igstPer + cgstPer + sgstPer);
            decimal IGSTTaxAmount = Math.Round(taxableAmt * igstPer / 100, 4, MidpointRounding.AwayFromZero);
            decimal CGSTTaxAmount = Math.Round(taxableAmt * cgstPer / 100, 4, MidpointRounding.AwayFromZero);
            decimal SGSTTaxAmount = Math.Round(taxableAmt * sgstPer / 100, 4, MidpointRounding.AwayFromZero);
            decimal purTaxAmt = Math.Round(((perUnitMRP * soldQty) * totalTaxper / 100), 4);

            str = "UPDATE f_salesdetails sd SET sd.`PerUnitBuyPrice`='" + perUnitPrice + "',sd.`TaxAmt`='" + purTaxAmt + "',sd.`TaxPercent`='" + totalTaxper + "',sd.`IGSTAmt`='" + IGSTTaxAmount + "',sd.`IGSTPercent`='" + igstPer + "',sd.`CGSTAmt`='" + CGSTTaxAmount + "',sd.`CGSTPercent`='" + cgstPer + "',sd.`SGSTAmt`='" + SGSTTaxAmount + "',sd.`SGSTPercent`='" + sgstPer + "',sd.`HSNCode`='" + HSNCode + "',sd.`GSTType`='" + GSTType + "' WHERE sd.`SalesID`='" + salesId + "'";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
            str = "UPDATE f_ledgertnxdetail ltd SET ltd.`unitPrice`='" + perUnitPrice + "',ltd.`PurTaxAmt`='" + purTaxAmt + "',ltd.`PurTaxPer`='" + totalTaxper + "',ltd.`HSNCode`='" + HSNCode + "',ltd.`IGSTPercent`='" + igstPer + "',ltd.`IGSTAmt`='" + IGSTTaxAmount + "',ltd.`CGSTPercent`='" + cgstPer + "',ltd.`CGSTAmt`='" + CGSTTaxAmount + "',ltd.`SGSTPercent`='" + sgstPer + "',ltd.`SGSTAmt`='" + SGSTTaxAmount + "' WHERE ltd.`StockID`='" + stockId + "' AND ltd.`ID`='" + LedgerTnxNo + "'";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

        }

        DataTable dtStock = StockReports.GetDataTable("SELECT st.`StockID` FROM f_stock st  WHERE st.`FromStockID`='" + stockId + "'");
        foreach (DataRow dr in dtStock.Rows)
        {
            string stockIDNew = Util.GetString(dr["StockID"]);
            str = "UPDATE f_stock st SET st.`unitPrice`='" + perUnitPrice + "',st.`PurTaxPer`='" + totalTaxper + "',st.`HSNCode`='" + HSNCode + "',st.`IGSTPercent`='" + igstPer + "',st.`IGSTAmtPerUnit`='" + igstAmtPerUnit + "',st.`CGSTPercent`='" + cgstPer + "',st.`CGSTAmtPerUnit`='" + cgstAmtPerUnit + "',st.`SGSTPercent`='" + sgstPer + "',st.`SGSTAmtPerUnit`='" + sgstAmtPerUnit + "',st.`GSTType`='" + GSTType + "' WHERE st.`StockID`='" + stockIDNew + "'";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
            UpdateItem(tnx, igstPer, cgstPer, sgstPer, GSTType, stockIDNew, perUnitPrice, igstAmtPerUnit, cgstAmtPerUnit, sgstAmtPerUnit, HSNCode);
        }


    }


    [WebMethod(EnableSession = true)]
    public string GetItemList(string itemName, string storeLedgerNo, string isConsignment)
    {
        List<object> Emp = new List<object>();
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT IM.Typename ItemName, IM.ItemID, IF(IFNULL(UPPER(im.IsExpirable),'')='YES',1,0) IsExpirable, IF(IFNULL(IM.minorUnit,'')='','NO',IM.minorUnit)minorUnit, IF(IFNULL(IM.ConversionFactor,'')='',1,IM.ConversionFactor) ConversionFactor, IF(IFNULL(IM.MajorUnit,'')='',IFNULL(im.MajorUnit,''),IM.MajorUnit) majorUnit, IFNULL(im.HSNCode,'')HSNCode, im.SubCategoryID, im.GSTType,CONCAT(UPPER(im.GSTType),'(',ROUND((im.IGSTPercent+im.SGSTPercent+im.CGSTPercent),2),')') AS GSTTypeNew,ROUND((im.IGSTPercent+im.SGSTPercent+im.CGSTPercent),2) as TotalGSTPer, im.VatType,IFNULL(im.DefaultSaleVatPercentage,0)DefaultSaleVatPercentage,im.`CGSTPercent`,im.`SGSTPercent`,im.`IGSTPercent`   ");// VatType
        sb.Append(" FROM f_itemmaster IM INNER JOIN f_subcategorymaster SM ON IM.SubCategoryID = SM.SubCategoryID ");
        sb.Append(" left JOIN `f_itemmaster_centerwise` itc ON itc.`ItemID`=im.`ItemID` ");
        sb.Append(" INNER JOIN f_configrelation c ON c.CategoryID =SM.CategoryID  ");
        sb.Append(" WHERE IM.IsActive=1 AND IM.IsStockable=1  ");
        if (isConsignment == "1")
            sb.Append(" AND c.ConfigID ='11' and IM.`IsStent`=1 ");
        else
        {
            if (storeLedgerNo == "STO00001")
                sb.Append(" AND c.ConfigID ='11' ");
            else
                sb.Append(" AND c.ConfigID ='28' ");

            sb.Append("  and IM.`IsStent`=0 ");
        }

        sb.Append(" AND TypeName LIKE '%" + itemName + "%' AND  IM.TypeName<>''");
        sb.Append(" ORDER BY IM.Typename limit 10 ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true, Description = "Remove GRN Item")]
    public string RemoveItem(string StockID, string GRNNo)
    {
        try
        {
            StockReports.ExecuteDML("CALL Cancel_DirectGRNItem_Med('" + StockID.Trim() + "','" + GRNNo.Trim() + "','','" + HttpContext.Current.Session["ID"].ToString() + "')");
            return "1";
        }
        catch (Exception ex)
        {
            return string.Empty;

        }
    }
    [WebMethod(EnableSession = true, Description = "Check Authority")]
    public string checkAuthority(string GRNNo)
    {
        string canEdit = "1";
        string isPost = Util.GetString(StockReports.ExecuteScalar("SELECT IF(st.`IsPost`=1,IF(st.`InvoiceNo`='',IF(st.`ChalanNo`='','1','0'),'1'),'0') FROM f_stock st WHERE st.`LedgerTransactionNo`='" + GRNNo + "' LIMIT 1"));
        if (isPost == "1")
        {
            canEdit = "0";
            DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(HttpContext.Current.Session["RoleID"]), Util.GetString(HttpContext.Current.Session["ID"]));
            if (dtAuthority.Rows.Count > 0)
            {
                if (Util.GetInt(dtAuthority.Rows[0]["IsEditAfterPost"]) == 1)
                {
                    canEdit = "1";
                }

            }

        }

        return canEdit;

    }
    // Chalan Work Ends
    //New Direct GRN Work
    [WebMethod(EnableSession = true, Description = "Check Authority")]
    public string TaxCalculation(string BillDiscPer, string BillDiscAmt, string BillGrossAmt, string DiscPer, string DiscAmt, string Rate, string MRP, string QTY, string Deal1, string Deal2, string spclDiscPer, string spclDiscAmt, string CGSTPer, string SGSTPer, string IGSTPer, string Type)
    {
        decimal DealRate = Util.GetDecimal(Rate);
        decimal TotalTax = Math.Round(Util.GetDecimal(CGSTPer) + Util.GetDecimal(SGSTPer) + Util.GetDecimal(IGSTPer), 4);
        if (Util.GetDecimal(Deal1) > 0)
        {
            decimal deal = Util.GetDecimal(Deal1) + Util.GetDecimal(Deal2);
            DealRate = Util.GetDecimal(Util.GetDouble(Util.GetDecimal(QTY) * Util.GetDecimal(Rate) / deal));
        }
        decimal discountPer = 0; decimal discountAmt = 0;
        decimal SpecialDiscPer = 0; decimal SpecialDiscAmt = 0;
        if (Util.GetDecimal(BillDiscPer) > 0 || Util.GetDecimal(BillDiscAmt) > 0)
        {
            if (Util.GetDecimal(BillDiscAmt) > 0)
            {
                discountPer = (Util.GetDecimal(BillDiscAmt) * 100) / Util.GetDecimal(BillGrossAmt);
            }
            else
            {
                discountPer = Util.GetDecimal(BillDiscPer);
            }
        }
        else if (Util.GetDecimal(DiscPer) > 0)
        {
            discountPer = Util.GetDecimal(DiscPer);
        }
        else if (Util.GetDecimal(DiscAmt) > 0)
        {

            discountAmt = Util.GetDecimal(DiscAmt);
        }

        if (Util.GetDecimal(spclDiscPer) > 0)
        {
            SpecialDiscPer = Math.Round(Util.GetDecimal(spclDiscPer), 2);
        }
        else if (Util.GetDecimal(spclDiscAmt) > 0)
        {
            SpecialDiscAmt = Util.GetDecimal(spclDiscAmt);

        }

        List<TaxCalculation_DirectGRN> taxCalculate = new List<TaxCalculation_DirectGRN>()
        {
         new TaxCalculation_DirectGRN
         {
             DiscAmt=discountAmt,
             DiscPer=discountPer,
             MRP=Util.GetDecimal(MRP),
             Quantity = Util.GetDecimal(QTY),
             Rate=DealRate,
             TaxPer = TotalTax,
             Type = Type,
             ExcisePer= Util.GetDecimal(0),
             deal =Util.GetDecimal(Deal1),
             deal2= Util.GetDecimal(Deal2),
             ActualRate=Util.GetDecimal(Rate), 
			//GST Changes
			 IGSTPrecent=Util.GetDecimal(IGSTPer),
             CGSTPercent=Util.GetDecimal(CGSTPer),
             SGSTPercent=Util.GetDecimal(SGSTPer),
			// To pass Special Discount
			 SpecialDiscPer=Util.GetDecimal(SpecialDiscPer),
             SpecialDiscAmt=Util.GetDecimal(SpecialDiscAmt)
         }
         };
        if (Util.GetDecimal(DiscAmt) > 0 && Util.GetDecimal(Rate) > 0)
        {
            discountPer = Math.Round((Util.GetDecimal(DiscAmt) * 100) / (Util.GetDecimal(Rate) * Util.GetDecimal(QTY)), 2);
        }
        if (Util.GetDecimal(spclDiscAmt) > 0 && Util.GetDecimal(Rate) > 0)
        {
            SpecialDiscPer = Math.Round(((SpecialDiscAmt * 100) / ((Util.GetDecimal(Rate) * Util.GetDecimal(QTY)) - ((Util.GetDecimal(Rate) * Util.GetDecimal(QTY)) * Util.GetDecimal(discountPer) / 100))), 2);
        }
        string taxCalculation = AllLoadData_Store.taxCalulation(taxCalculate);
        // return taxCalculation + "#" + discountPer + "#" + SpecialDiscPer;
        string result = taxCalculation + "#" + discountPer + "#" + SpecialDiscPer;
        return result;
    }
    [WebMethod(EnableSession = true, Description = "Check Authority")]
    public string getReturnItems(string StoreType, string VendorLedgerNo, string DeptLedgerNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ST.`StockID`,CONCAT(ST.ItemName,'(Batch :',st.`BatchNumber`,' Exp :',DATE_FORMAT(st.`MedExpiryDate`,'%d-%b-%Y'),' AvlQty:',(ST.InitialCount-st.ReleasedCount ),')')Item FROM f_stock  ST INNER JOIN f_ledgertransaction LT");
        sb.Append(" on LT.LedgerTransactionNo=ST.LedgerTransactionNo WHERE ST.DeptLedgerNo = '" + DeptLedgerNo + "' AND  ");
        if (StoreType == "STO00001") // Medical Store
            sb.Append(" LT.TypeOfTnx='PURCHASE' AND  ");
        else if (StoreType == "STO00002")  // General Store
            sb.Append(" LT.TypeOfTnx='NMPURCHASE' AND  ");
        sb.Append(" (ST.InitialCount-st.ReleasedCount )>0 and ST.IsPost=1 and LT.LedgerNoCr='" + VendorLedgerNo + "' AND st.StoreLedgerNo='" + StoreType + "'");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true, Description = "Check Authority")]
    public string bindGRNReturnItem(string StockId, string ReturnQTY)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT st.`StockID`,st.`ItemID`,st.`ItemName`,st.`BatchNumber`,st.`ConversionFactor` 'CF',st.`SubCategoryID` ,st.`unitPrice`,st.`MinorUnit` 'SalesUnit',st.`MinorUnit` 'PurUnit', ");
        sb.Append(" ROUND((st.`Rate`/st.`ConversionFactor`),2)'PurRate', st.`MRP`,IF(st.`IsExpirable`=0,'',DATE_FORMAT(st.`MedExpiryDate`,'%c/%y'))ExpDate, ");
        sb.Append(" st.`IsExpirable`,st.`IGSTPercent`,st.`IGSTAmtPerUnit`,st.`CGSTPercent`,st.`CGSTAmtPerUnit`,st.`SGSTPercent`,st.`SGSTAmtPerUnit`,st.`GSTType`, ");
        sb.Append(" st.`HSNCode`,st.`InvoiceNo`,st.`LedgerTransactionNo` FROM f_stock st  WHERE st.`StockID`='" + StockId + "' AND (st.`InitialCount`-st.`ReleasedCount`)>='" + ReturnQTY + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true, Description = "Validate Invoice or Challan")]
    public string checkDuplicateInvoice(string VendorLedgerNo, string InvoiceNo, string ChallanNo, string Type)
    {
        string InvNo = string.Empty;
        if (Type.Trim() == "Invoice" || Type.Trim() == "Challan with Invoice")
        {
            InvNo = StockReports.ExecuteScalar("SELECT count(*) FROM f_ledgermaster lm INNER JOIN f_invoicemaster im ON lm.LedgerNumber = im.VenLedgerNo inner join f_ledgertransaction lt on lt.LedgerTransactionNo=im.LedgerTnxNo WHERE im.VenLedgerNo='" + VendorLedgerNo.Trim() + "' AND im.InvoiceNo='" + InvoiceNo.Trim() + "' and lt.IsCancel=0 ");
            if (Util.GetInt(InvNo) > 0)
                return "1";
        }
        if (Type.Trim() == "Challan" || Type.Trim() == "Challan with Invoice")
        {
            InvNo = StockReports.ExecuteScalar("SELECT count(*) FROM f_ledgermaster lm INNER JOIN f_invoicemaster im ON lm.LedgerNumber = im.VenLedgerNo inner join f_ledgertransaction lt on lt.LedgerTransactionNo=im.LedgerTnxNo WHERE im.VenLedgerNo='" + VendorLedgerNo + "' AND im.ChalanNo='" + ChallanNo.Trim() + "' and lt.IsCancel=0 ");
            if (Util.GetInt(InvNo) > 0)
                return "2";
        }
        return "0";
    }

    [WebMethod(EnableSession = true)]
    public string UpdateGRN(List<DirectGRNInvoiceDetails> dataInvoice, List<DirectGRNItemDetails> dataItemDetails, int isConsignment, int consignmentNumber, string ledgerTransationNo, string EditGRNNo)
    {

        string GRNNo = string.Empty;
        string LedgerTnxNo = string.Empty;
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction objTran = con.BeginTransaction(IsolationLevel.ReadCommitted);
        ExcuteCMD excuteCMD = new ExcuteCMD();

        try
        {
            if (isConsignment == 1)
            {
                decimal CurrencyFactor = Util.GetDecimal(dataInvoice[0].CurrencyFactor);
                if (dataInvoice[0].PONumber != "")
                    CurrencyFactor = 1;

                LedgerTnxNo = Util.GetString(consignmentNumber);
                //string str = "INSERT INTO consignmentdetail(ConsignmentNo,VendorLedgerNo,ChallanNo,ChallanDate,BillNo,BillDate,ItemID,ItemName,BatchNumber,Rate,UnitPrice,TaxPer,PurTaxAmt,DiscAmt,SaleTaxPer,SaleTaxAmt,TYPE,Reusable,IsBilled,TaxID,DiscountPer,MRP,Unit,InititalCount,StockDate,IsPost,IsFree,Naration,DeptLedgerNo,GateEntryNo,UserID,Freight,Octroi,RoundOff,GRNAmount,MedExpiryDate,HSNCode,IGSTPercent,CGSTPercent,SGSTPercent,GSTType,SpecialDiscPer,isDeal,ConversionFactor,OtherCharges, MarkUpPercent, LandingCost, CurrencyCountryID,Currency,CurrencyFactor,CentreID,IGSTAmt,CGSTAmt,SGSTAmt,Quantity) VALUES(@ConsignmentNo,@VendorLedgerNo,@ChallanNo,@ChallanDate,@BillNo,@BillDate,@ItemID,@ItemName,@BatchNumber,@Rate,@UnitPrice,@TaxPer,@PurTaxAmt,@DiscAmt,@SaleTaxPer,@SaleTaxAmt,@TYPE,@Reusable,@IsBilled,@TaxID,@DiscountPer,@MRP,@Unit,@InititalCount,@StockDate,@IsPost,@IsFree,@Naration,@DeptLedgerNo,@GateEntryNo,@UserID,@Freight,@Octroi,@RoundOff,@GRNAmount,@MedExpiryDate,@HSNCode,@IGSTPercent,@CGSTPercent,@SGSTPercent,@GSTType,@SpecialDiscPer,@isDeal,@ConversionFactor,@OtherCharges, @MarkUpPercent, @LandingCost, @CurrencyCountryID,@Currency,@CurrencyFactor,@CentreID,@IGSTAmt,@CGSTAmt,@SGSTAmt,@Quantity ) ";


                var itemDetailsToUpdate = dataItemDetails.Where(i => Util.GetInt(i.LedgerTnxNo) > 0).ToList();

                for (int i = 0; i < itemDetailsToUpdate.Count; i++)
                {
                    // var itemDetail = itemDetailsToUpdate[i];

                    string str = "UPDATE consignmentdetail SET VendorLedgerNo=@VendorLedgerNo, ChallanNo=@ChallanNo,ChallanDate=@ChallanDate,BillNo=@BillNo,BillDate=@BillDate,ItemID=@ItemID,ItemName=@ItemName,BatchNumber=@BatchNumber,Rate=@Rate,UnitPrice=@UnitPrice,TaxPer=@TaxPer,PurTaxAmt=@PurTaxAmt,DiscAmt=@DiscAmt,SaleTaxPer=@SaleTaxPer,SaleTaxAmt=@SaleTaxAmt,TYPE=@TYPE, Reusable=@Reusable, IsBilled=@IsBilled, TaxID=@TaxID, DiscountPer=@DiscountPer,MRP=@MRP,Unit=@Unit,InititalCount=@InititalCount,StockDate=@StockDate,IsPost=@IsPost,IsFree=@IsFree,Naration=@Naration, DeptLedgerNo=@DeptLedgerNo,GateEntryNo=@GateEntryNo,UserID=@UserID,Freight=@Freight,Octroi=@Octroi,RoundOff=@RoundOff,GRNAmount=@GRNAmount,MedExpiryDate=@MedExpiryDate,HSNCode=@HSNCode,IGSTPercent=@IGSTPercent,CGSTPercent=@CGSTPercent,SGSTPercent=@SGSTPercent,GSTType=@GSTType,SpecialDiscPer=@SpecialDiscPer,isDeal=@isDeal,ConversionFactor=@ConversionFactor,OtherCharges=@OtherCharges,MarkUpPercent=@MarkUpPercent,LandingCost=@LandingCost,CurrencyCountryID=@CurrencyCountryID,Currency=@Currency, CurrencyFactor=@CurrencyFactor, CentreID=@CentreID,IGSTAmt=@IGSTAmt,CGSTAmt=@CGSTAmt,SGSTAmt=@SGSTAmt,Quantity=@Quantity,ItemNetAmount=@ItemNetAmount WHERE ConsignmentNo=@ConsignmentNo AND ID=@ID";
                    int ReusableValue = 0;
                    decimal PurchasePrice = 0, saleTaxAmt = 0;
                    DateTime ExpityDate = Util.GetDateTime(StockReports.ExecuteScalar("SELECT LAST_DAY( DATE_ADD('" + Util.GetDateTime(dataItemDetails[i].MedExpiryDate).ToString("yyyy-MM-dd") + "', INTERVAL 0 MONTH)) "));
                    DateTime MedicineExpiryDate = DateTime.Now;

                    if (dataItemDetails[i].MedExpiryDate.ToString().Length > 0)
                        MedicineExpiryDate = Util.GetDateTime(ExpityDate);
                    else
                        MedicineExpiryDate = DateTime.Now.AddYears(5);

                    if (Util.GetFloat(dataItemDetails[i].ConversionFactor) > 0)
                        PurchasePrice = Util.GetDecimal(Util.GetDecimal(dataItemDetails[i].UnitPrice) * CurrencyFactor) / Util.GetDecimal(dataItemDetails[i].ConversionFactor);
                    else
                        PurchasePrice = Util.GetDecimal(dataItemDetails[i].UnitPrice) * CurrencyFactor;

                    if (Util.GetDecimal(dataItemDetails[i].SaleTaxPer) > 0)
                        saleTaxAmt = Math.Round((Util.GetDecimal((dataItemDetails[i].MRP * 100) / (100 + Util.GetDecimal(dataItemDetails[i].SaleTaxPer))) * Util.GetDecimal(dataItemDetails[i].SaleTaxPer) / 100) * Util.GetDecimal(dataItemDetails[i].Quantity), 4);
                    else
                        saleTaxAmt = 0;

                    string Reusable = Util.GetString(StockReports.ExecuteScalar("SELECT im.IsUsable FROM f_itemmaster im WHERE im.ItemID='" + Util.GetString(dataItemDetails[i].ItemID) + "'"));
                    if (Reusable == "R")
                        ReusableValue = Util.GetInt("1");
                    else
                        ReusableValue = Util.GetInt("0");

                    var ValidEntry = excuteCMD.DML(objTran, str.ToString(), CommandType.Text, new
                    {
                        ID = Util.GetInt(dataItemDetails[i].ID),
                        ConsignmentNo = consignmentNumber,
                        LedgerTnxNo = Util.GetString(dataItemDetails[i].LedgerTnxNo),
                        VendorLedgerNo = Util.GetString(dataInvoice[0].VenLedgerNo),
                        ChallanNo = Util.GetString(dataInvoice[0].ChalanNo),
                        ChallanDate = Util.GetDateTime(dataInvoice[0].ChalanDate).ToString("yyyy-MM-dd"),
                        BillNo = Util.GetString(dataInvoice[0].InvoiceNo),
                        BillDate = Util.GetDateTime(dataInvoice[0].InvoiceDate).ToString("yyyy-MM-dd"),
                        ItemID = Util.GetString(dataItemDetails[i].ItemID),
                        ItemName = Util.GetString(dataItemDetails[i].ItemName),
                        BatchNumber = Util.GetString(dataItemDetails[i].BatchNumber),

                        Rate = Util.GetDecimal(dataItemDetails[i].Rate) * CurrencyFactor,
                        UnitPrice = PurchasePrice,
                        TaxPer = Util.GetDecimal(dataItemDetails[i].PurTaxPer),
                        PurTaxAmt = Util.GetDecimal(dataItemDetails[i].PurTaxPer),
                        DiscAmt = Util.GetDecimal(dataItemDetails[i].DiscAmt) * CurrencyFactor,

                        SaleTaxPer = Util.GetDecimal(dataItemDetails[i].SaleTaxPer),
                        SaleTaxAmt = saleTaxAmt,
                        TYPE = Util.GetString(StockReports.ExecuteScalar("SELECT im.Type_ID FROM f_itemmaster im WHERE im.ItemID='" + Util.GetString(dataItemDetails[i].ItemID) + "'")),
                        Reusable = ReusableValue,
                        IsBilled = 1,
                        TaxID = 0,
                        DiscountPer = Util.GetDecimal(dataItemDetails[i].DiscPer),
                        MRP = (Util.GetDecimal(dataItemDetails[i].MRP) * CurrencyFactor) / Util.GetDecimal(dataItemDetails[i].ConversionFactor),
                        Unit = dataItemDetails[i].MinorUnit,
                        InititalCount = Util.GetDecimal(dataItemDetails[i].Quantity) * Util.GetDecimal(dataItemDetails[i].ConversionFactor),
                        StockDate = DateTime.Now,
                        IsPost = 0,
                        IsFree = Util.GetInt(dataItemDetails[i].IsFree),
                        Naration = dataItemDetails[i].Naration,
                        DeptLedgerNo = dataItemDetails[i].DeptLedgerNo,
                        GateEntryNo = Util.GetString(dataInvoice[0].GatePassIn),
                        UserID = HttpContext.Current.Session["ID"].ToString(),
                        Freight = Util.GetDecimal("0"),
                        Octroi = Util.GetDecimal("0"),
                        RoundOff = 0,
                        GRNAmount = Util.GetDecimal(dataInvoice[0].NetAmount) * CurrencyFactor,
                        MedExpiryDate = MedicineExpiryDate,
                        HSNCode = dataItemDetails[i].HSNCode,
                        IGSTPercent = Util.GetDecimal(dataItemDetails[i].IGSTPercent),
                        CGSTPercent = Util.GetDecimal(dataItemDetails[i].CGSTPercent),
                        SGSTPercent = Util.GetDecimal(dataItemDetails[i].SGSTPercent),
                        GSTType = dataItemDetails[i].GSTType,
                        SpecialDiscPer = Util.GetDecimal(dataItemDetails[i].SpecialDiscPer),
                        isDeal = Util.GetString(dataItemDetails[i].isDeal),
                        ConversionFactor = Util.GetDecimal(dataItemDetails[i].ConversionFactor),
                        OtherCharges = Util.GetDecimal(dataItemDetails[i].otherCharges) * CurrencyFactor,
                        MarkUpPercent = Util.GetDecimal(dataItemDetails[i].markUpPercent),
                        LandingCost = PurchasePrice,
                        CurrencyCountryID = Util.GetInt(dataInvoice[0].currencyCountryID),
                        Currency = Util.GetString(dataInvoice[0].currency),
                        CurrencyFactor = Util.GetDecimal(dataInvoice[0].CurrencyFactor),
                        CentreID = Util.GetInt(Session["CentreID"].ToString()),
                        IGSTAmt = Util.GetDecimal(dataItemDetails[i].IGSTAmt) * CurrencyFactor,
                        CGSTAmt = Util.GetDecimal(dataItemDetails[i].CGSTAmt) * CurrencyFactor,
                        SGSTAmt = Util.GetDecimal(dataItemDetails[i].SGSTAmt) * CurrencyFactor,
                        Quantity = dataItemDetails[i].Quantity,
                        ItemNetAmount = dataItemDetails[i].ItemNetAmount
                    });

                    if (Util.GetInt(ValidEntry) < 1)
                    {
                        objTran.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Consignment Entry" });
                    }
                }

                dataItemDetails = dataItemDetails.Where(i => Util.GetInt(i.LedgerTnxNo) < 1).ToList();

                if (dataItemDetails.Count > 0)
                {
                    for (int i = 0; i < dataItemDetails.Count; i++)
                    {
                        string str = "INSERT INTO consignmentdetail(ConsignmentNo,VendorLedgerNo,ChallanNo,ChallanDate,BillNo,BillDate,ItemID,ItemName,BatchNumber,Rate,UnitPrice,TaxPer,PurTaxAmt,DiscAmt,SaleTaxPer,SaleTaxAmt,TYPE,Reusable,IsBilled,TaxID,DiscountPer,MRP,Unit,InititalCount,StockDate,IsPost,IsFree,Naration,DeptLedgerNo,GateEntryNo,UserID,Freight,Octroi,RoundOff,GRNAmount,MedExpiryDate,HSNCode,IGSTPercent,CGSTPercent,SGSTPercent,GSTType,SpecialDiscPer,isDeal,ConversionFactor,OtherCharges, MarkUpPercent, LandingCost, CurrencyCountryID,Currency,CurrencyFactor,CentreID,IGSTAmt,CGSTAmt,SGSTAmt,Quantity,ItemNetAmount) VALUES(@ConsignmentNo,@VendorLedgerNo,@ChallanNo,@ChallanDate,@BillNo,@BillDate,@ItemID,@ItemName,@BatchNumber,@Rate,@UnitPrice,@TaxPer,@PurTaxAmt,@DiscAmt,@SaleTaxPer,@SaleTaxAmt,@TYPE,@Reusable,@IsBilled,@TaxID,@DiscountPer,@MRP,@Unit,@InititalCount,@StockDate,@IsPost,@IsFree,@Naration,@DeptLedgerNo,@GateEntryNo,@UserID,@Freight,@Octroi,@RoundOff,@GRNAmount,@MedExpiryDate,@HSNCode,@IGSTPercent,@CGSTPercent,@SGSTPercent,@GSTType,@SpecialDiscPer,@isDeal,@ConversionFactor,@OtherCharges, @MarkUpPercent, @LandingCost, @CurrencyCountryID,@Currency,@CurrencyFactor,@CentreID,@IGSTAmt,@CGSTAmt,@SGSTAmt,@Quantity,@ItemNetAmount ) ";
                        int ReusableValue = 0;
                        decimal PurchasePrice = 0, saleTaxAmt = 0;
                        DateTime ExpityDate = Util.GetDateTime(StockReports.ExecuteScalar("SELECT LAST_DAY( DATE_ADD('" + Util.GetDateTime(dataItemDetails[i].MedExpiryDate).ToString("yyyy-MM-dd") + "', INTERVAL 0 MONTH)) "));
                        DateTime MedicineExpiryDate = DateTime.Now;

                        if (dataItemDetails[i].MedExpiryDate.ToString().Length > 0)
                            MedicineExpiryDate = Util.GetDateTime(ExpityDate);
                        else
                            MedicineExpiryDate = DateTime.Now.AddYears(5);

                        if (Util.GetFloat(dataItemDetails[i].ConversionFactor) > 0)
                            PurchasePrice = Util.GetDecimal(Util.GetDecimal(dataItemDetails[i].UnitPrice) * CurrencyFactor) / Util.GetDecimal(dataItemDetails[i].ConversionFactor);
                        else
                            PurchasePrice = Util.GetDecimal(dataItemDetails[i].UnitPrice) * CurrencyFactor;

                        if (Util.GetDecimal(dataItemDetails[i].SaleTaxPer) > 0)
                            saleTaxAmt = Math.Round((Util.GetDecimal((dataItemDetails[i].MRP * 100) / (100 + Util.GetDecimal(dataItemDetails[i].SaleTaxPer))) * Util.GetDecimal(dataItemDetails[i].SaleTaxPer) / 100) * Util.GetDecimal(dataItemDetails[i].Quantity), 4);
                        else
                            saleTaxAmt = 0;

                        string Reusable = Util.GetString(StockReports.ExecuteScalar("SELECT im.IsUsable FROM f_itemmaster im WHERE im.ItemID='" + Util.GetString(dataItemDetails[i].ItemID) + "'"));
                        if (Reusable == "R")
                            ReusableValue = Util.GetInt("1");
                        else
                            ReusableValue = Util.GetInt("0");

                        var ValidEntry = excuteCMD.DML(objTran, str.ToString(), CommandType.Text, new
                        {
                            ConsignmentNo = consignmentNumber,
                            VendorLedgerNo = Util.GetString(dataInvoice[0].VenLedgerNo),
                            ChallanNo = Util.GetString(dataInvoice[0].ChalanNo),
                            ChallanDate = Util.GetDateTime(dataInvoice[0].ChalanDate).ToString("yyyy-MM-dd"),
                            BillNo = Util.GetString(dataInvoice[0].InvoiceNo),
                            BillDate = Util.GetDateTime(dataInvoice[0].InvoiceDate).ToString("yyyy-MM-dd"),
                            ItemID = Util.GetString(dataItemDetails[i].ItemID),
                            ItemName = Util.GetString(dataItemDetails[i].ItemName),
                            BatchNumber = Util.GetString(dataItemDetails[i].BatchNumber),

                            Rate = Util.GetDecimal(dataItemDetails[i].Rate) * CurrencyFactor,
                            UnitPrice = PurchasePrice,
                            TaxPer = Util.GetDecimal(dataItemDetails[i].PurTaxPer),
                            PurTaxAmt = Util.GetDecimal(dataItemDetails[i].PurTaxPer),
                            DiscAmt = Util.GetDecimal(dataItemDetails[i].DiscAmt) * CurrencyFactor,

                            SaleTaxPer = Util.GetDecimal(dataItemDetails[i].SaleTaxPer),
                            SaleTaxAmt = saleTaxAmt,
                            TYPE = Util.GetString(StockReports.ExecuteScalar("SELECT im.Type_ID FROM f_itemmaster im WHERE im.ItemID='" + Util.GetString(dataItemDetails[i].ItemID) + "'")),
                            Reusable = ReusableValue,
                            IsBilled = 1,
                            TaxID = 0,
                            DiscountPer = Util.GetDecimal(dataItemDetails[i].DiscPer),
                            MRP = (Util.GetDecimal(dataItemDetails[i].MRP) * CurrencyFactor) / Util.GetDecimal(dataItemDetails[i].ConversionFactor),
                            Unit = dataItemDetails[i].MinorUnit,
                            InititalCount = Util.GetDecimal(dataItemDetails[i].Quantity) * Util.GetDecimal(dataItemDetails[i].ConversionFactor),
                            StockDate = DateTime.Now,
                            IsPost = 0,
                            IsFree = Util.GetInt(dataItemDetails[i].IsFree),
                            Naration = dataItemDetails[i].Naration,
                            DeptLedgerNo = dataItemDetails[i].DeptLedgerNo,
                            GateEntryNo = Util.GetString(dataInvoice[0].GatePassIn),
                            UserID = HttpContext.Current.Session["ID"].ToString(),
                            Freight = Util.GetDecimal("0"),
                            Octroi = Util.GetDecimal("0"),
                            RoundOff = 0,
                            GRNAmount = Util.GetDecimal(dataInvoice[0].NetAmount) * CurrencyFactor,
                            MedExpiryDate = MedicineExpiryDate,
                            HSNCode = dataItemDetails[i].HSNCode,
                            IGSTPercent = Util.GetDecimal(dataItemDetails[i].IGSTPercent),
                            CGSTPercent = Util.GetDecimal(dataItemDetails[i].CGSTPercent),
                            SGSTPercent = Util.GetDecimal(dataItemDetails[i].SGSTPercent),
                            GSTType = dataItemDetails[i].GSTType,
                            SpecialDiscPer = Util.GetDecimal(dataItemDetails[i].SpecialDiscPer),
                            isDeal = Util.GetString(dataItemDetails[i].isDeal),
                            ConversionFactor = Util.GetDecimal(dataItemDetails[i].ConversionFactor),
                            OtherCharges = Util.GetDecimal(dataItemDetails[i].otherCharges) * CurrencyFactor,
                            MarkUpPercent = Util.GetDecimal(dataItemDetails[i].markUpPercent),
                            LandingCost = PurchasePrice,
                            CurrencyCountryID = Util.GetInt(dataInvoice[0].currencyCountryID),
                            Currency = Util.GetString(dataInvoice[0].currency),
                            CurrencyFactor = Util.GetDecimal(dataInvoice[0].CurrencyFactor),
                            CentreID = Util.GetInt(Session["CentreID"].ToString()),
                            IGSTAmt = dataItemDetails[i].IGSTAmt,
                            CGSTAmt = dataItemDetails[i].CGSTAmt,
                            SGSTAmt = dataItemDetails[i].SGSTAmt,
                            Quantity = dataItemDetails[i].Quantity,
                            ItemNetAmount = dataItemDetails[i].ItemNetAmount
                        });

                        if (Util.GetInt(ValidEntry) < 1)
                        {
                            objTran.Rollback();
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Consignment Entry" });
                        }
                    }
                }
            }
            else
            {
                GRNNo = EditGRNNo;
                LedgerTnxNo = ledgerTransationNo;
                decimal CurrencyFactor = Util.GetDecimal(dataInvoice[0].CurrencyFactor);
                var itemDetailsToUpdate = dataItemDetails.Where(i => Util.GetInt(i.LedgerTnxNo) > 0).ToList();

                for (int i = 0; i < itemDetailsToUpdate.Count; i++)
                {

                    var itemDetail = itemDetailsToUpdate[i];

                    itemDetail.UnitPrice = Util.GetDecimal(Util.GetDecimal(itemDetail.UnitPrice) * CurrencyFactor) / Util.GetDecimal(itemDetail.ConversionFactor);

                    itemDetail.MajorMRP = Util.GetDecimal(Util.GetFloat(itemDetail.MRP)) * CurrencyFactor;


                    decimal saletaxamount = 0;
                    if (itemDetail.SaleTaxPer > 0)
                        saletaxamount = Math.Round((Util.GetDecimal((itemDetail.MRP * 100) / (100 + itemDetail.SaleTaxPer)) * itemDetail.SaleTaxPer / 100) * Util.GetDecimal(itemDetail.Quantity), 4);

                    itemDetail.MRP = Util.GetDecimal(Util.GetFloat(itemDetail.MRP)) * CurrencyFactor / Util.GetDecimal(itemDetail.ConversionFactor);
                    itemDetail.otherCharges = (itemDetail.otherCharges * CurrencyFactor);
                    itemDetail.Rate = (itemDetail.Rate * CurrencyFactor);
                    itemDetail.DiscAmt = (itemDetail.DiscAmt * CurrencyFactor);
                    itemDetail.PurTaxAmt = (itemDetail.PurTaxAmt * CurrencyFactor);
                    itemDetail.SpecialDiscAmt = (itemDetail.SpecialDiscAmt * CurrencyFactor);
                    itemDetail.ItemGrossAmount = (itemDetail.ItemGrossAmount * CurrencyFactor);
                    if (Resources.Resource.IsGSTApplicable == "1")
                    {
                        itemDetail.IGSTAmt = Util.GetDecimal(itemDetail.IGSTAmt);
                        itemDetail.SGSTAmt = Util.GetDecimal(itemDetail.SGSTAmt);
                        itemDetail.CGSTAmt = Util.GetDecimal(itemDetail.CGSTAmt);
                        itemDetail.IGSTPercent = Util.GetDecimal(itemDetail.IGSTPercent);
                        itemDetail.CGSTPercent = Util.GetDecimal(itemDetail.CGSTPercent);
                        itemDetail.SGSTPercent = Util.GetDecimal(itemDetail.SGSTPercent);
                        itemDetail.GSTType = itemDetail.GSTType;
                    }

                    string str = string.Empty;
                    if (Util.GetInt(itemDetail.IsFree) == 1)
                    {
                        itemDetail.ItemGrossAmount = 0;
                        itemDetail.ItemNetAmount = 0;
                        itemDetail.Rate = 0;
                    }

                    if (Resources.Resource.IsGSTApplicable == "0")
                    {
                        str = "UPDATE f_stock SET CurrencyFactor=" + dataInvoice[0].CurrencyFactor + " ,Currency='" + dataInvoice[0].currency + "',CurrencyCountryID=" + dataInvoice[0].currencyCountryID + ", MarkUpPercent=" + itemDetail.markUpPercent + ", OtherCharges='" + (itemDetail.otherCharges) + "',  ItemID='" + itemDetail.ItemID + "',Itemname='" + itemDetail.ItemName + "',BatchNumber = '" + itemDetail.BatchNumber + "',UnitPrice='" + (itemDetail.UnitPrice) + "',MRP = '" + (itemDetail.MRP) + "', majorMRP='" + itemDetail.MajorMRP + "',InitialCount = '" + (itemDetail.Quantity * Util.GetDecimal(itemDetail.ConversionFactor)) + "',MedExpiryDate='" + itemDetail.MedExpiryDate.ToString("yyyy-MM-dd") + "',SubcategoryID='" + itemDetail.SubCategoryID + "',UnitType='" + itemDetail.MajorUnit + "',Rate='" + (itemDetail.Rate) + "',DiscAmt='" + (itemDetail.DiscAmt) + "',DiscPer='" + itemDetail.DiscPer + "',PurTaxAmt='" + (itemDetail.PurTaxAmt) + "',PurTaxPer='" + itemDetail.PurTaxPer + "',ConversionFactor='" + itemDetail.ConversionFactor + "',MajorUnit='" + itemDetail.MajorUnit + "',MinorUnit='" + itemDetail.MinorUnit + "',MajorMRP='" + itemDetail.MajorMRP + "',IsExpirable='" + itemDetail.IsExpirable + "',isDeal='" + itemDetail.isDeal + "',ExciseAmt='0',IGSTPercent='0',IGSTAmtPerUnit='0',CGSTPercent='0',CGSTAmtPerUnit='0',SGSTPercent='0',SGSTAmtPerUnit='0',GSTType='',SpecialDiscPer='" + itemDetail.SpecialDiscPer + "',specialDiscAmt='" + (itemDetail.SpecialDiscAmt) + "',HSNCode='" + itemDetail.HSNCode + "',IsFree='" + itemDetail.IsFree + "',isDeal='" + itemDetail.isDeal + "',LastUpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "',Updatedate=NOW() WHERE id = '" + itemDetail.StockID + "' AND  LedgerTransactionNo='" + LedgerTnxNo + "'";
                        MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, str);


                        str = " UPDATE f_ledgertnxdetail SET MarkUpPercent=" + itemDetail.markUpPercent + ", OtherCharges=" + itemDetail.otherCharges + ", ItemID='" + itemDetail.ItemID + "',Itemname='" + itemDetail.ItemName + "',BatchNumber = '" + itemDetail.BatchNumber.ToString() + "', Quantity = '" + itemDetail.Quantity + "',Rate='" + (itemDetail.Rate) + "',Amount = '" + (itemDetail.ItemGrossAmount) + "',DiscAmt='" + (itemDetail.DiscAmt) + "',DiscountPercentage='" + itemDetail.DiscPer + "',medExpiryDate='" + itemDetail.MedExpiryDate.ToString("yyyy-MM-dd") + "',IsExpirable='" + itemDetail.IsExpirable + "',NetItemAmt='" + (itemDetail.ItemGrossAmount) + "',TotalDiscAmt='" + (itemDetail.DiscAmt) + "',PurTaxPer='" + itemDetail.PurTaxPer + "',PurTaxAmt='" + (itemDetail.PurTaxAmt) + "',unitPrice='" + itemDetail.UnitPrice + "',IGSTPercent='0',IGSTAmt='0',CGSTPercent='0',CGSTAmt='0',SGSTPercent='0',SGSTAmt='0',SpecialDiscPer='" + itemDetail.SpecialDiscPer + "',specialDiscAmt='" + itemDetail.SpecialDiscAmt + "',HSNCode='" + itemDetail.HSNCode + "',IsFree='" + itemDetail.IsFree + "',LastUpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdatedDate=NOW() WHERE id = '" + itemDetail.LedgerTnxNo + "' AND LedgerTransactionNo='" + LedgerTnxNo + "'";
                        MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, str);
                    }
                    else if (Resources.Resource.IsGSTApplicable == "1")
                    {
                        str = "UPDATE f_stock SET CurrencyFactor=" + dataInvoice[0].CurrencyFactor + " ,Currency='" + dataInvoice[0].currency + "',CurrencyCountryID=" + dataInvoice[0].currencyCountryID + ", MarkUpPercent=" + itemDetail.markUpPercent + ", OtherCharges='" + (itemDetail.otherCharges) + "',  ItemID='" + itemDetail.ItemID + "',Itemname='" + itemDetail.ItemName + "',BatchNumber = '" + itemDetail.BatchNumber + "',UnitPrice='" + (itemDetail.UnitPrice) + "',MRP = '" + (itemDetail.MRP) + "', majorMRP='" + itemDetail.MajorMRP + "',InitialCount = '" + (itemDetail.Quantity * Util.GetDecimal(itemDetail.ConversionFactor)) + "',MedExpiryDate='" + itemDetail.MedExpiryDate.ToString("yyyy-MM-dd") + "',SubcategoryID='" + itemDetail.SubCategoryID + "',UnitType='" + itemDetail.MajorUnit + "',Rate='" + (itemDetail.Rate) + "',DiscAmt='" + (itemDetail.DiscAmt) + "',DiscPer='" + itemDetail.DiscPer + "',PurTaxAmt='" + (itemDetail.PurTaxAmt) + "',PurTaxPer='" + itemDetail.PurTaxPer + "',ConversionFactor='" + itemDetail.ConversionFactor + "',MajorUnit='" + itemDetail.MajorUnit + "',MinorUnit='" + itemDetail.MinorUnit + "',MajorMRP='" + itemDetail.MajorMRP + "',IsExpirable='" + itemDetail.IsExpirable + "',isDeal='" + itemDetail.isDeal + "',ExciseAmt='0',IGSTPercent='" + itemDetail.IGSTPercent + "',IGSTAmtPerUnit='" + (itemDetail.IGSTAmt / (itemDetail.Quantity * Util.GetDecimal(itemDetail.ConversionFactor))) + "',CGSTPercent='" + itemDetail.CGSTPercent + "',CGSTAmtPerUnit='" + (itemDetail.CGSTAmt / (itemDetail.Quantity * Util.GetDecimal(itemDetail.ConversionFactor))) + "',SGSTPercent='" + itemDetail.SGSTPercent + "',SGSTAmtPerUnit='" + (itemDetail.SGSTAmt / (itemDetail.Quantity * Util.GetDecimal(itemDetail.ConversionFactor))) + "',GSTType='" + itemDetail.GSTType + "',SpecialDiscPer='" + itemDetail.SpecialDiscPer + "',specialDiscAmt='" + (itemDetail.SpecialDiscAmt) + "',HSNCode='" + itemDetail.HSNCode + "',IsFree='" + itemDetail.IsFree + "',isDeal='" + itemDetail.isDeal + "',LastUpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "',Updatedate=NOW() WHERE id = '" + itemDetail.StockID + "' AND  LedgerTransactionNo='" + LedgerTnxNo + "'";
                        MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, str);


                        str = " UPDATE f_ledgertnxdetail SET GSTType='" + itemDetail.GSTType + "', MarkUpPercent=" + itemDetail.markUpPercent + ", OtherCharges=" + itemDetail.otherCharges + ", ItemID='" + itemDetail.ItemID + "',Itemname='" + itemDetail.ItemName + "',BatchNumber = '" + itemDetail.BatchNumber.ToString() + "', Quantity = '" + itemDetail.Quantity + "',Rate='" + (itemDetail.Rate) + "',Amount = '" + (itemDetail.ItemGrossAmount) + "',DiscAmt='" + (itemDetail.DiscAmt) + "',DiscountPercentage='" + itemDetail.DiscPer + "',medExpiryDate='" + itemDetail.MedExpiryDate.ToString("yyyy-MM-dd") + "',IsExpirable='" + itemDetail.IsExpirable + "',NetItemAmt='" + (itemDetail.ItemNetAmount) + "',TotalDiscAmt='" + (itemDetail.DiscAmt) + "',PurTaxPer='" + itemDetail.PurTaxPer + "',PurTaxAmt='" + (itemDetail.PurTaxAmt) + "',unitPrice='" + itemDetail.UnitPrice + "',IGSTPercent='" + itemDetail.IGSTPercent + "',IGSTAmt='" + itemDetail.IGSTAmt + "',CGSTPercent='" + itemDetail.CGSTPercent + "',CGSTAmt='" + itemDetail.CGSTAmt + "',SGSTPercent='" + itemDetail.SGSTPercent + "',SGSTAmt='" + itemDetail.SGSTAmt + "',SpecialDiscPer='" + itemDetail.SpecialDiscPer + "',specialDiscAmt='" + itemDetail.SpecialDiscAmt + "',HSNCode='" + itemDetail.HSNCode + "',IsFree='" + itemDetail.IsFree + "',LastUpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdatedDate=NOW() WHERE id = '" + itemDetail.LedgerTnxNo + "' AND LedgerTransactionNo='" + LedgerTnxNo + "'";
                        MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, str);
                    }


                }




                dataItemDetails = dataItemDetails.Where(i => Util.GetInt(i.LedgerTnxNo) < 1).ToList();
                if (dataItemDetails.Count > 0)
                {

                    for (int i = 0; i < dataItemDetails.Count; i++)
                    {
                        DateTime ExpityDate = Util.GetDateTime(StockReports.ExecuteScalar("SELECT LAST_DAY( DATE_ADD('" + Util.GetDateTime(dataItemDetails[i].MedExpiryDate).ToString("yyyy-MM-dd") + "', INTERVAL 0 MONTH)) "));
                        LedgerTnxDetail objLTDetail = new LedgerTnxDetail(objTran);
                        objLTDetail.Hospital_Id = Session["HOSPID"].ToString();
                        objLTDetail.LedgerTransactionNo = LedgerTnxNo;
                        objLTDetail.ItemID = Util.GetString(dataItemDetails[i].ItemID);
                        objLTDetail.SubCategoryID = Util.GetString(dataItemDetails[i].SubCategoryID);
                        objLTDetail.Rate = Util.GetDecimal(dataItemDetails[i].Rate) * CurrencyFactor;
                        objLTDetail.Quantity = Util.GetDecimal(dataItemDetails[i].Quantity);
                        objLTDetail.StockID = string.Empty;
                        objLTDetail.ItemName = Util.GetString(dataItemDetails[i].ItemName);
                        objLTDetail.EntryDate = DateTime.Now;
                        objLTDetail.UserID = Session["ID"].ToString();
                        objLTDetail.UpdatedDate = DateTime.Now;
                        if (Util.GetString(dataItemDetails[i].PurTaxPer) != string.Empty && Util.GetFloat(dataItemDetails[i].PurTaxPer) > 0)
                            objLTDetail.IsTaxable = "YES";
                        else
                            objLTDetail.IsTaxable = "NO";
                        objLTDetail.DiscountPercentage = Util.GetDecimal(dataItemDetails[i].DiscPer);
                        objLTDetail.DiscAmt = Util.GetDecimal(dataItemDetails[i].DiscAmt) * CurrencyFactor;
                        objLTDetail.Amount = Util.GetDecimal(dataItemDetails[i].ItemGrossAmount) * CurrencyFactor;
                        objLTDetail.IsFree = Util.GetInt(dataItemDetails[i].IsFree);
                        objLTDetail.CentreID = Util.GetInt(Session["CentreID"].ToString());
                        objLTDetail.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                        objLTDetail.medExpiryDate = Util.GetDateTime(ExpityDate);
                        objLTDetail.IsExpirable = Util.GetInt(dataItemDetails[i].IsExpirable);
                        objLTDetail.pageURL = All_LoadData.getCurrentPageName();
                        objLTDetail.NetItemAmt = Util.GetDecimal(objLTDetail.Amount) * CurrencyFactor;
                        objLTDetail.TotalDiscAmt = Util.GetDecimal(objLTDetail.DiscAmt) * CurrencyFactor;
                        objLTDetail.IpAddress = HttpContext.Current.Request.UserHostAddress;
                        objLTDetail.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(dataItemDetails[i].SubCategoryID), con));
                        objLTDetail.Type = "S";
                        objLTDetail.BatchNumber = Util.GetString(dataItemDetails[i].BatchNumber);
                        objLTDetail.StoreLedgerNo = Util.GetString(dataInvoice[0].StoreLedgerNo);
                        objLTDetail.DeptLedgerNo = Util.GetString(dataItemDetails[i].DeptLedgerNo);
                        objLTDetail.PurTaxAmt = Util.GetDecimal(dataItemDetails[i].PurTaxAmt) * CurrencyFactor;
                        objLTDetail.PurTaxPer = Util.GetDecimal(dataItemDetails[i].PurTaxPer);
                        objLTDetail.HSNCode = Util.GetString(dataItemDetails[i].HSNCode);
                        objLTDetail.IGSTPercent = Util.GetDecimal(dataItemDetails[i].IGSTPercent);
                        objLTDetail.IGSTAmt = Util.GetDecimal(dataItemDetails[i].IGSTAmt) * CurrencyFactor;
                        objLTDetail.CGSTPercent = Util.GetDecimal(dataItemDetails[i].CGSTPercent);
                        objLTDetail.CGSTAmt = Util.GetDecimal(dataItemDetails[i].CGSTAmt) * CurrencyFactor;
                        objLTDetail.SGSTPercent = Util.GetDecimal(dataItemDetails[i].SGSTPercent);
                        objLTDetail.SGSTAmt = Util.GetDecimal(dataItemDetails[i].SGSTAmt) * CurrencyFactor;
                        objLTDetail.SpecialDiscPer = Util.GetDecimal(dataItemDetails[i].SpecialDiscPer);
                        objLTDetail.SpecialDiscAmt = Util.GetDecimal(dataItemDetails[i].SpecialDiscAmt) * CurrencyFactor;
                        objLTDetail.GSTType = Util.GetString(dataItemDetails[i].GSTType);
                        if (Util.GetFloat(dataItemDetails[i].ConversionFactor) > 0)
                            objLTDetail.unitPrice = Util.GetDecimal(Util.GetDecimal(dataItemDetails[i].UnitPrice) * CurrencyFactor) / Util.GetDecimal(dataItemDetails[i].ConversionFactor);
                        else
                            objLTDetail.unitPrice = Util.GetDecimal(dataItemDetails[i].UnitPrice) * CurrencyFactor;

                        objLTDetail.OtherCharges = Util.GetDecimal(dataItemDetails[i].otherCharges) * CurrencyFactor;
                        objLTDetail.MarkUpPercent = Util.GetDecimal(dataItemDetails[i].markUpPercent);

                        string LdgTrnxDtlID = objLTDetail.Insert().ToString();

                        if (LdgTrnxDtlID == string.Empty)
                        {
                            objTran.Rollback();
                            objTran.Dispose();
                            con.Close();
                            con.Dispose();
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error occurred, Please contact administrator" });
                        }
                        Stock objStock = new Stock(objTran);
                        float MRP = Util.GetFloat(dataItemDetails[i].MRP);
                        objStock.Hospital_ID = Session["HOSPID"].ToString();
                        objStock.ItemID = Util.GetString(dataItemDetails[i].ItemID);
                        objStock.ItemName = Util.GetString(dataItemDetails[i].ItemName);
                        objStock.LedgerTransactionNo = LedgerTnxNo;
                        objStock.LedgerTnxNo = LdgTrnxDtlID;
                        objStock.BatchNumber = Util.GetString(dataItemDetails[i].BatchNumber);
                        if (Util.GetFloat(dataItemDetails[i].ConversionFactor) > 0)
                            objStock.UnitPrice = Util.GetDecimal(Util.GetDecimal(dataItemDetails[i].UnitPrice) * CurrencyFactor) / Util.GetDecimal(dataItemDetails[i].ConversionFactor);
                        else
                            objStock.UnitPrice = Util.GetDecimal(Util.GetDecimal(dataItemDetails[i].UnitPrice) * CurrencyFactor);
                        objStock.MRP = Util.GetDecimal(Util.GetFloat(MRP)) * CurrencyFactor / Util.GetDecimal(dataItemDetails[i].ConversionFactor);
                        if (objStock.MRP <= 0)
                        {
                            objTran.Rollback();
                            objTran.Dispose();
                            con.Close();
                            con.Dispose();
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Selling Price Can Not Be Zero." });
                        }
                        objStock.MajorMRP = Util.GetDecimal(Util.GetFloat(MRP)) * CurrencyFactor;
                        objStock.IsCountable = 1;
                        objStock.InitialCount = Util.GetDecimal(dataItemDetails[i].Quantity) * Util.GetDecimal(dataItemDetails[i].ConversionFactor);
                        objStock.ReleasedCount = 0;
                        objStock.IsReturn = 0;
                        objStock.LedgerNo = string.Empty;
                        if (dataItemDetails[i].MedExpiryDate.ToString().Length > 0)
                        {
                            objStock.MedExpiryDate = Util.GetDateTime(ExpityDate);
                        }
                        else
                        {
                            objStock.MedExpiryDate = DateTime.Now.AddYears(5);
                        }
                        objStock.StockDate = DateTime.Now;
                        if (Util.GetString(dataInvoice[0].StoreLedgerNo) == "STO00001")
                        {
                            objStock.TypeOfTnx = "Purchase";
                            objStock.StoreLedgerNo = "STO00001";
                        }
                        else if (Util.GetString(dataInvoice[0].StoreLedgerNo) == "STO00002")
                        {
                            objStock.TypeOfTnx = "NMPURCHASE";
                            objStock.StoreLedgerNo = "STO00002";
                        }
                        objStock.IsPost = 0;
                        objStock.Naration = Util.GetString(dataItemDetails[i].Naration);
                        objStock.IsFree = Util.GetInt(dataItemDetails[i].IsFree);
                        objStock.SubCategoryID = Util.GetString(dataItemDetails[i].SubCategoryID);
                        objStock.Unit = Util.GetString(dataItemDetails[i].MinorUnit);
                        objStock.DeptLedgerNo = Util.GetString(dataItemDetails[i].DeptLedgerNo);
                        objStock.UserID = Session["ID"].ToString();
                        objStock.IsBilled = 1;
                        objStock.Rate = Util.GetDecimal(dataItemDetails[i].Rate) * CurrencyFactor;
                        objStock.DiscPer = Util.GetDecimal(dataItemDetails[i].DiscPer);
                        objStock.VenLedgerNo = Util.GetString(dataItemDetails[i].VenLedgerNo);
                        objStock.DiscAmt = Util.GetDecimal(dataItemDetails[i].DiscAmt) * CurrencyFactor;
                        objStock.TYPE = Util.GetString(StockReports.ExecuteScalar("SELECT im.Type_ID FROM f_itemmaster im WHERE im.ItemID='" + Util.GetString(dataItemDetails[i].ItemID) + "'"));
                        string Reusable = Util.GetString(StockReports.ExecuteScalar("SELECT im.IsUsable FROM f_itemmaster im WHERE im.ItemID='" + Util.GetString(dataItemDetails[i].ItemID) + "'"));
                        if (Reusable == "R")
                            objStock.Reusable = Util.GetInt("1");
                        else
                            objStock.Reusable = Util.GetInt("0");
                        objStock.ConversionFactor = Util.GetDecimal(dataItemDetails[i].ConversionFactor);
                        objStock.MajorUnit = Util.GetString(dataItemDetails[i].MajorUnit);
                        objStock.MinorUnit = Util.GetString(dataItemDetails[i].MinorUnit);
                        objStock.InvoiceNo = Util.GetString(dataItemDetails[i].InvoiceNo);
                        objStock.InvoiceDate = Util.GetDateTime(dataItemDetails[i].InvoiceDate);
                        objStock.CentreID = Util.GetInt(Session["CentreID"].ToString());
                        objStock.IpAddress = All_LoadData.IpAddress();
                        objStock.IsExpirable = Util.GetInt(dataItemDetails[i].IsExpirable);
                        objStock.PurTaxPer = Util.GetDecimal(dataItemDetails[i].PurTaxPer);
                        objStock.PurTaxAmt = Util.GetDecimal(dataItemDetails[i].PurTaxAmt) * CurrencyFactor;
                        objStock.ExciseAmt = Util.GetDecimal("0");
                        objStock.ExcisePer = Util.GetDecimal("0");
                        objStock.taxCalculateOn = "RateAD";
                        objStock.isDeal = Util.GetString(dataItemDetails[i].isDeal);
                        objStock.HSNCode = Util.GetString(dataItemDetails[i].HSNCode);
                        objStock.GSTType = Util.GetString(dataItemDetails[i].GSTType);
                        objStock.IGSTPercent = Util.GetDecimal(dataItemDetails[i].IGSTPercent);
                        objStock.IGSTAmtPerUnit = Math.Round(objLTDetail.IGSTAmt / (Util.GetDecimal(objStock.InitialCount)), 4, MidpointRounding.AwayFromZero) * CurrencyFactor;
                        objStock.CGSTPercent = Util.GetDecimal(dataItemDetails[i].CGSTPercent);
                        objStock.CGSTAmtPerUnit = Math.Round(objLTDetail.CGSTAmt / (Util.GetDecimal(objStock.InitialCount)), 4, MidpointRounding.AwayFromZero) * CurrencyFactor;
                        objStock.SGSTPercent = Util.GetDecimal(dataItemDetails[i].SGSTPercent);
                        objStock.SGSTAmtPerUnit = Math.Round(objLTDetail.SGSTAmt / (Util.GetDecimal(objStock.InitialCount)), 4, MidpointRounding.AwayFromZero) * CurrencyFactor;
                        objStock.SpecialDiscPer = Util.GetDecimal(dataItemDetails[i].SpecialDiscPer);
                        objStock.SpecialDiscAmt = Util.GetDecimal(dataItemDetails[i].SpecialDiscAmt) * CurrencyFactor;
                        objStock.ChalanNo = Util.GetString(dataItemDetails[i].ChalanNo);
                        objStock.ChalanDate = Util.GetDateTime(dataItemDetails[i].ChalanDate);
                        objStock.InvoiceAmount = dataInvoice[0].NetAmount;
                        objStock.OtherCharges = Util.GetDecimal(dataItemDetails[i].otherCharges) * CurrencyFactor;
                        objStock.MarkUpPercent = Util.GetDecimal(dataItemDetails[i].markUpPercent);
                        objStock.LandingCost = 0;
                        objStock.PONumber = Util.GetString(dataInvoice[0].PONumber);
                        objStock.CurrencyCountryID = Util.GetInt(dataInvoice[0].currencyCountryID);
                        objStock.Currency = Util.GetString(dataInvoice[0].currency);
                        objStock.CurrencyFactor = Util.GetDecimal(dataInvoice[0].CurrencyFactor);
                        objStock.SaleTaxPer = Util.GetDecimal(dataItemDetails[i].SaleTaxPer);
                        if (objStock.SaleTaxPer > 0)
                            objStock.SaleTaxAmt = Math.Round((Util.GetDecimal((dataItemDetails[i].MRP * 100) / (100 + objStock.SaleTaxPer)) * objStock.SaleTaxPer / 100) * Util.GetDecimal(dataItemDetails[i].Quantity), 4);
                        else
                            objStock.SaleTaxAmt = 0;

                        objStock.ReferenceNo = EditGRNNo;
                        string StockID = objStock.Insert().ToString();



                        if (!string.IsNullOrEmpty(dataInvoice[0].PONumber))
                        {

                            string sqlCMD = "UPDATE f_purchaseorderdetails SET RecievedQty=RecievedQty+@quantity  WHERE PurchaseOrderDetailID=@purchaseOrderDetailID ";

                            var res = excuteCMD.DML(objTran, sqlCMD.ToString(), CommandType.Text, new
                            {
                                quantity = dataItemDetails[i].Quantity,
                                purchaseOrderDetailID = dataItemDetails[i].PODID,

                            });


                            sqlCMD = "CALL PO_StoreRecieve(@purchaseOrderNumber,@purchaseOrderDetailID,@quantity,@ledgerTransactionNo,@ledgerTransactionDetailID,@stockID,@centerID,@hospitalID,@itemID)";
                            res = excuteCMD.DML(objTran, sqlCMD.ToString(), CommandType.Text, new
                            {
                                purchaseOrderNumber = dataInvoice[0].PONumber,
                                purchaseOrderDetailID = dataItemDetails[i].PODID,
                                quantity = dataItemDetails[i].Quantity,
                                ledgerTransactionNo = LedgerTnxNo,
                                ledgerTransactionDetailID = LdgTrnxDtlID,
                                stockID = StockID,
                                centerID = objStock.CentreID,
                                hospitalID = objLTDetail.Hospital_Id,
                                itemID = dataItemDetails[i].ItemID,
                            });


                            if (Util.GetInt(res) < 1)
                            {
                                objTran.Rollback();
                                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error occurred, Please contact administrator" });
                            }

                        }




                        //strPOUpdate = "CALL PO_StoreRecieve('" + Util.GetString(rowItem["PurchaseOrderNo"]) + "'," + Util.GetString(rowItem["PurchaseOrderDetailID"]) + "," + Util.GetFloat(rowItem["RecvQty"]) + ",'" + LedgerTnxNo + "','" + LdgTrnxDtlID + "','" + StockID + "','" + Util.GetInt(Session["CentreID"].ToString()) + "','" + HospID + "','" + Util.GetString(rowItem["ItemID"]) + "');";
                        //MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, strPOUpdate);


                        if (StockID == string.Empty)
                        {
                            objTran.Rollback();
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error occurred, Please contact administrator" });
                        }

                        // MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, "UPDATE f_ledgertnxdetail SET StockID='" + StockID + "' WHERE ID=" + LdgTrnxDtlID + "");


                        if (!string.IsNullOrEmpty(dataInvoice[0].PONumber))
                        {
                            decimal isPendigQty = Util.GetDecimal(MySqlHelper.ExecuteScalar(objTran, CommandType.Text, "SELECT SUM(pod.`ApprovedQty`-pod.`RecievedQty`) FROM f_purchaseorderdetails pod WHERE pod.`PurchaseOrderNo`='" + Util.GetString(dataInvoice[0].PONumber) + "'"));
                            if (isPendigQty < 1)
                                MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, "UPDATE `f_purchaseorder` po SET po.`Status`='3' WHERE po.`PurchaseOrderNo`='" + Util.GetString(dataInvoice[0].PONumber) + "'");
                        }
                    }
                }





                for (int i = 0; i < dataInvoice.Count; i++)
                {
                    string chalanNo, chalanDate, invoiceNo, InvoiceDate, VenLedgerNo = string.Empty;
                    if (dataInvoice[i].ChalanNo == "")
                    {
                        chalanNo = "";
                        chalanDate = "01-01-0001";
                    }
                    else
                    {
                        chalanNo = Util.GetString(dataInvoice[i].ChalanNo);
                        chalanDate = Util.GetDateTime(dataInvoice[i].ChalanDate).ToString("yyyy-MM-dd");
                    }
                    if (dataInvoice[i].InvoiceNo == "")
                    {
                        invoiceNo = "";
                        InvoiceDate = "01-01-0001";
                    }
                    else
                    {
                        invoiceNo = Util.GetString(dataInvoice[i].InvoiceNo);
                        InvoiceDate = Util.GetDateTime(dataInvoice[i].InvoiceDate).ToString("yyyy-MM-dd");
                    }
                    VenLedgerNo = Util.GetString(dataInvoice[i].VenLedgerNo);
                    LedgerTnxNo = Util.GetString(LedgerTnxNo);
                    StringBuilder sb = new StringBuilder();
                    sb.Append(" UPDATE f_stock st INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionNo`=st.`LedgerTransactionNo` INNER JOIN f_invoicemaster im ON im.`LedgerTnxNo`=lt.`LedgerTransactionNo`  ");
                    sb.Append(" SET st.`ChalanNo`='" + chalanNo + "',lt.`ChalanNo`='" + chalanNo + "',im.`ChalanNo`='" + chalanNo + "',st.`ChalanDate`='" + chalanDate + "',im.`ChalanDate`='" + chalanDate + "',  ");
                    sb.Append(" st.`InvoiceNo`='" + invoiceNo + "',lt.`InvoiceNo`='" + invoiceNo + "',im.`InvoiceNo`='" + invoiceNo + "',st.`InvoiceDate`='" + InvoiceDate + "',im.`InvoiceDate`='" + InvoiceDate + "',  ");
                    sb.Append(" st.`VenLedgerNo`='" + VenLedgerNo + "',lt.`LedgerNoCr`='" + VenLedgerNo + "',im.`VenLedgerNo`='" + VenLedgerNo + "'  ");
                    sb.Append(" WHERE st.ReferenceNo='" + EditGRNNo + "' ");
                    MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, sb.ToString());

                    DataSet dt = new DataSet();
                    if (Resources.Resource.IsGSTApplicable == "0")
                    {
                        dt = MySqlHelper.ExecuteDataset(objTran, CommandType.Text, "SELECT SUM(ltd.amount)netamt,SUM(purtaxamt)purtaxamt,SUM(ltd.DiscAmt)DisAmt,sum(ltd.amount) grossAmt,Freight,Octori,lt.RoundOff,SUM(ltd.specialDiscAmt)SpecialDiscAmt FROM f_ledgertnxdetail  ltd INNER JOIN f_ledgertransaction lt ON ltd.`LedgerTransactionNo`=lt.`LedgerTransactionNo` WHERE ltd.IsVerified<=1 and ltd.IsFree=0 and  lt.LedgerTransactionNo='" + LedgerTnxNo + "'");
                    }
                    else if (Resources.Resource.IsGSTApplicable == "1")
                    {
                        dt = MySqlHelper.ExecuteDataset(objTran, CommandType.Text, "SELECT SUM(ltd.amount)netamt,SUM(IGSTAmt+CGSTAmt+SGSTAmt)purtaxamt,SUM(ltd.DiscAmt)DisAmt,sum(ltd.amount) grossAmt,Freight,Octori,lt.RoundOff,SUM(ltd.specialDiscAmt)SpecialDiscAmt FROM f_ledgertnxdetail  ltd INNER JOIN f_ledgertransaction lt ON ltd.`LedgerTransactionNo`=lt.`LedgerTransactionNo` WHERE ltd.IsVerified<=1 and ltd.IsFree=0 and lt.LedgerTransactionNo='" + LedgerTnxNo + "'");
                    }



                    Decimal TotalAmt = Util.GetDecimal(dt.Tables[0].Rows[0]["netamt"].ToString()) + Util.GetDecimal(dt.Tables[0].Rows[0]["purtaxamt"].ToString()) - Util.GetDecimal(dt.Tables[0].Rows[0]["DisAmt"].ToString()) + Util.GetDecimal(dt.Tables[0].Rows[0]["Octori"].ToString()) + Util.GetDecimal(dt.Tables[0].Rows[0]["Freight"].ToString()) - Util.GetDecimal(dt.Tables[0].Rows[0]["SpecialDiscAmt"].ToString());

                    decimal tmpAmt = Math.Round(TotalAmt, 0);
                    decimal roundOff = tmpAmt - TotalAmt;
                    decimal totaldiscount = Util.GetDecimal(dt.Tables[0].Rows[0]["DisAmt"].ToString()) + Util.GetDecimal(dt.Tables[0].Rows[0]["SpecialDiscAmt"].ToString());
                    string str = "UPDATE f_ledgertransaction lt SET lt.netamount='" + tmpAmt + "' ,lt.grossamount='" + TotalAmt + "',DiscountOnTotal='" + totaldiscount + "',RoundOff='" + roundOff + "'   WHERE lt.LedgerTransactionNo='" + LedgerTnxNo + "' ";
                    MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, str);
                    str = " UPDATE f_stock im SET InvoiceAmount='" + tmpAmt + "' WHERE im.LedgerTransactionNO='" + LedgerTnxNo + "' ";
                    MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, str);
                    str = " UPDATE f_invoicemaster  SET InvoiceAmount='" + tmpAmt + "' WHERE LedgerTnxNo='" + LedgerTnxNo + "' ";
                    MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, str);
                }
            }
            objTran.Commit();
            string l = "";
            if (isConsignment == 1)
            {
                l = LedgerTnxNo;
            }
            else { l = GRNNo; }
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = l, message = AllGlobalFunction.saveMessage });

        }
        catch (Exception ex)
        {
            objTran.Rollback();
            objTran.Dispose();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = AllGlobalFunction.errorMessage });
        }
        finally
        {
            objTran.Dispose();
            con.Dispose();
        }



    }


    [WebMethod(EnableSession = true)]
    public string SaveGRN(List<DirectGRNInvoiceDetails> dataInvoice, List<DirectGRNItemDetails> dataItemDetails, int isConsignment)
    {
        string GRNNo = string.Empty;

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction objTran = con.BeginTransaction(IsolationLevel.ReadCommitted);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            string LedgerTnxNo = string.Empty;

            decimal CurrencyFactor = Util.GetDecimal(dataInvoice[0].CurrencyFactor);
            if (dataInvoice[0].PONumber != "")
                CurrencyFactor = 1;

            if (isConsignment == 1)
            {
                int ConsignmentNo = Util.GetInt(MySqlHelper.ExecuteScalar(objTran, CommandType.Text, "SELECT IFNULL(MAX(ConsignmentNo),0)+1 FROM consignmentdetail"));

                LedgerTnxNo = Util.GetString(ConsignmentNo);
                string str = "INSERT INTO consignmentdetail(ConsignmentNo,VendorLedgerNo,ChallanNo,ChallanDate,BillNo,BillDate,ItemID,ItemName,BatchNumber,Rate,UnitPrice,TaxPer,PurTaxAmt,DiscAmt,SaleTaxPer,SaleTaxAmt,TYPE,Reusable,IsBilled,TaxID,DiscountPer,MRP,Unit,InititalCount,StockDate,IsPost,IsFree,Naration,DeptLedgerNo,GateEntryNo,UserID,Freight,Octroi,RoundOff,GRNAmount,MedExpiryDate,HSNCode,IGSTPercent,CGSTPercent,SGSTPercent,GSTType,SpecialDiscPer,isDeal,ConversionFactor,OtherCharges, MarkUpPercent, LandingCost, CurrencyCountryID,Currency,CurrencyFactor,CentreID,IGSTAmt,CGSTAmt,SGSTAmt,Quantity,ItemNetAmount) VALUES(@ConsignmentNo,@VendorLedgerNo,@ChallanNo,@ChallanDate,@BillNo,@BillDate,@ItemID,@ItemName,@BatchNumber,@Rate,@UnitPrice,@TaxPer,@PurTaxAmt,@DiscAmt,@SaleTaxPer,@SaleTaxAmt,@TYPE,@Reusable,@IsBilled,@TaxID,@DiscountPer,@MRP,@Unit,@InititalCount,@StockDate,@IsPost,@IsFree,@Naration,@DeptLedgerNo,@GateEntryNo,@UserID,@Freight,@Octroi,@RoundOff,@GRNAmount,@MedExpiryDate,@HSNCode,@IGSTPercent,@CGSTPercent,@SGSTPercent,@GSTType,@SpecialDiscPer,@isDeal,@ConversionFactor,@OtherCharges, @MarkUpPercent, @LandingCost, @CurrencyCountryID,@Currency,@CurrencyFactor,@CentreID,@IGSTAmt,@CGSTAmt,@SGSTAmt,@Quantity,@ItemNetAmount ) ";

                for (int i = 0; i < dataItemDetails.Count; i++)
                {

                    int ReusableValue = 0;
                    decimal PurchasePrice = 0, saleTaxAmt = 0;
                    DateTime ExpityDate = Util.GetDateTime(StockReports.ExecuteScalar("SELECT LAST_DAY( DATE_ADD('" + Util.GetDateTime(dataItemDetails[i].MedExpiryDate).ToString("yyyy-MM-dd") + "', INTERVAL 0 MONTH)) "));
                    DateTime MedicineExpiryDate = DateTime.Now;

                    if (dataItemDetails[i].MedExpiryDate.ToString().Length > 0)
                        MedicineExpiryDate = Util.GetDateTime(ExpityDate);
                    else
                        MedicineExpiryDate = DateTime.Now.AddYears(5);


                    if (Util.GetFloat(dataItemDetails[i].ConversionFactor) > 0)
                        PurchasePrice = Util.GetDecimal(Util.GetDecimal(dataItemDetails[i].UnitPrice) * CurrencyFactor) / Util.GetDecimal(dataItemDetails[i].ConversionFactor);
                    else
                        PurchasePrice = Util.GetDecimal(dataItemDetails[i].UnitPrice) * CurrencyFactor;

                    if (Util.GetDecimal(dataItemDetails[i].SaleTaxPer) > 0)
                        saleTaxAmt = Math.Round((Util.GetDecimal((dataItemDetails[i].MRP * 100) / (100 + Util.GetDecimal(dataItemDetails[i].SaleTaxPer))) * Util.GetDecimal(dataItemDetails[i].SaleTaxPer) / 100) * Util.GetDecimal(dataItemDetails[i].Quantity), 4);
                    else
                        saleTaxAmt = 0;

                    string Reusable = Util.GetString(StockReports.ExecuteScalar("SELECT im.IsUsable FROM f_itemmaster im WHERE im.ItemID='" + Util.GetString(dataItemDetails[i].ItemID) + "'"));
                    if (Reusable == "R")
                        ReusableValue = Util.GetInt("1");
                    else
                        ReusableValue = Util.GetInt("0");

                    var ValidEntry = excuteCMD.DML(objTran, str.ToString(), CommandType.Text, new
                    {
                        ConsignmentNo = ConsignmentNo,
                        VendorLedgerNo = Util.GetString(dataInvoice[0].VenLedgerNo),
                        ChallanNo = Util.GetString(dataInvoice[0].ChalanNo),
                        ChallanDate = Util.GetDateTime(dataInvoice[0].ChalanDate).ToString("yyyy-MM-dd"),
                        BillNo = Util.GetString(dataInvoice[0].InvoiceNo),
                        BillDate = Util.GetDateTime(dataInvoice[0].InvoiceDate).ToString("yyyy-MM-dd"),
                        ItemID = Util.GetString(dataItemDetails[i].ItemID),
                        ItemName = Util.GetString(dataItemDetails[i].ItemName),
                        BatchNumber = Util.GetString(dataItemDetails[i].BatchNumber),

                        Rate = Util.GetDecimal(dataItemDetails[i].Rate) * CurrencyFactor,
                        UnitPrice = PurchasePrice,
                        TaxPer = Util.GetDecimal(dataItemDetails[i].PurTaxPer),
                        PurTaxAmt = Util.GetDecimal(dataItemDetails[i].PurTaxAmt),
                        DiscAmt = Util.GetDecimal(dataItemDetails[i].DiscAmt) * CurrencyFactor,

                        SaleTaxPer = Util.GetDecimal(dataItemDetails[i].SaleTaxPer),
                        SaleTaxAmt = saleTaxAmt,
                        TYPE = Util.GetString(StockReports.ExecuteScalar("SELECT im.Type_ID FROM f_itemmaster im WHERE im.ItemID='" + Util.GetString(dataItemDetails[i].ItemID) + "'")),
                        Reusable = ReusableValue,
                        IsBilled = 1,
                        TaxID = 0,
                        DiscountPer = Util.GetDecimal(dataItemDetails[i].DiscPer),
                        MRP = (Util.GetDecimal(dataItemDetails[i].MRP) * CurrencyFactor) / Util.GetDecimal(dataItemDetails[i].ConversionFactor),
                        Unit = dataItemDetails[i].MinorUnit,
                        InititalCount = Util.GetDecimal(dataItemDetails[i].Quantity) * Util.GetDecimal(dataItemDetails[i].ConversionFactor),
                        StockDate = DateTime.Now,
                        IsPost = 0,
                        IsFree = Util.GetInt(dataItemDetails[i].IsFree),
                        Naration = dataItemDetails[i].Naration,
                        DeptLedgerNo = dataItemDetails[i].DeptLedgerNo,
                        GateEntryNo = Util.GetString(dataInvoice[0].GatePassIn),
                        UserID = HttpContext.Current.Session["ID"].ToString(),
                        Freight = Util.GetDecimal("0"),
                        Octroi = Util.GetDecimal("0"),
                        RoundOff = 0,
                        GRNAmount = Util.GetDecimal(dataInvoice[0].NetAmount) * CurrencyFactor,
                        MedExpiryDate = MedicineExpiryDate,
                        HSNCode = dataItemDetails[i].HSNCode,
                        IGSTPercent = Util.GetDecimal(dataItemDetails[i].IGSTPercent),
                        CGSTPercent = Util.GetDecimal(dataItemDetails[i].CGSTPercent),
                        SGSTPercent = Util.GetDecimal(dataItemDetails[i].SGSTPercent),
                        GSTType = dataItemDetails[i].GSTType,
                        SpecialDiscPer = Util.GetDecimal(dataItemDetails[i].SpecialDiscPer),
                        isDeal = Util.GetString(dataItemDetails[i].isDeal),
                        ConversionFactor = Util.GetDecimal(dataItemDetails[i].ConversionFactor),
                        OtherCharges = Util.GetDecimal(dataItemDetails[i].otherCharges) * CurrencyFactor,
                        MarkUpPercent = Util.GetDecimal(dataItemDetails[i].markUpPercent),
                        LandingCost = PurchasePrice,
                        CurrencyCountryID = Util.GetInt(dataInvoice[0].currencyCountryID),
                        Currency = Util.GetString(dataInvoice[0].currency),
                        CurrencyFactor = Util.GetDecimal(dataInvoice[0].CurrencyFactor),
                        CentreID = Util.GetInt(Session["CentreID"].ToString()),
                        IGSTAmt = Util.GetDecimal(dataItemDetails[i].IGSTAmt) * CurrencyFactor,
                        CGSTAmt = Util.GetDecimal(dataItemDetails[i].CGSTAmt) * CurrencyFactor,
                        SGSTAmt = Util.GetDecimal(dataItemDetails[i].SGSTAmt) * CurrencyFactor,
                        Quantity = dataItemDetails[i].Quantity,
                        ItemNetAmount = dataItemDetails[i].ItemNetAmount
                    });

                    if (Util.GetInt(ValidEntry) < 1)
                    {
                        objTran.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Consignment Entry" });

                    }
                }
            }
            else
            {
                string TransactionType = string.Empty;
                if (Util.GetString(dataInvoice[0].StoreLedgerNo).ToUpper() == "STO00001")
                    TransactionType = "PURCHASE";
                else if (Util.GetString(dataInvoice[0].StoreLedgerNo).ToUpper() == "STO00002")
                    TransactionType = "NMPURCHASE";

                if (TransactionType == string.Empty)
                {
                    objTran.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error occurred, Please contact administrator" });
                }
                if (HttpContext.Current.Session["DeptledgerNo"].ToString() == "LSHHI18" && TransactionType == "PURCHASE")
                {
                    objTran.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Wrong Store Ledger No" + TransactionType, message = "Error occurred, Please contact administrator" });
                }

                if (dataInvoice[0].VenLedgerNo == "0")
                {
                    objTran.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Please Select The Supplier Name", message = "Error occurred, Please contact administrator" });
                }
                GRNNo = Util.GetString(MySqlHelper.ExecuteScalar(objTran, CommandType.Text, "SELECT get_Tran_idPh('" + TransactionType + "','" + Util.GetString(dataItemDetails[0].DeptLedgerNo) + "'," + Util.GetInt(Session["CentreID"].ToString()) + ")"));

                if (GRNNo == string.Empty)
                {
                    objTran.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error occurred, Please contact administrator" });
                }

                InvoiceMaster objInvMas = new InvoiceMaster(objTran);
                objInvMas.InvoiceNo = Util.GetString(dataInvoice[0].InvoiceNo);
                objInvMas.InvoiceDate = Util.GetDateTime(dataInvoice[0].InvoiceDate);
                objInvMas.ChalanNo = Util.GetString(dataInvoice[0].ChalanNo);
                objInvMas.ChalanDate = Util.GetDateTime(dataInvoice[0].ChalanDate);

                if (Util.GetString(dataInvoice[0].InvoiceNo) != string.Empty)
                    objInvMas.IsCompleteInvoice = "YES";
                else
                    objInvMas.IsCompleteInvoice = "NO";
                objInvMas.PONumber = Util.GetString(dataInvoice[0].PONumber);
                objInvMas.VenLedgerNo = Util.GetString(dataInvoice[0].VenLedgerNo);
                objInvMas.DiffBillAmt = 0;
                objInvMas.WayBillNo = Util.GetString(dataInvoice[0].WayBillNo);
                objInvMas.WayBillDate = Util.GetDateTime(dataInvoice[0].WayBillDate);

                objInvMas.ReferenceNo = GRNNo;
                objInvMas.GrossAmount = Util.GetDecimal(dataInvoice[0].GrossBillAmount) * CurrencyFactor;
                objInvMas.InvoiceAmount = Util.GetDecimal(dataInvoice[0].NetAmount) * CurrencyFactor;
                objInvMas.DiscountOnTotal = Util.GetDecimal(dataInvoice[0].DiscAmount) * CurrencyFactor;
                objInvMas.DeptLedgerNo = Util.GetString(dataItemDetails[0].DeptLedgerNo);
                objInvMas.CentreID = Util.GetInt(Session["CentreID"].ToString());
                objInvMas.Freight = Util.GetDecimal(dataInvoice[0].FreightCharge);
                objInvMas.Octori = 0;
                objInvMas.OtherCharges = Util.GetDecimal(dataInvoice[0].otherCharges) * CurrencyFactor;
                objInvMas.GatePassInWard = Util.GetString(dataInvoice[0].GatePassIn);
                objInvMas.RoundOff = Util.GetDecimal(dataInvoice[0].RoundOff) * CurrencyFactor;
                objInvMas.PaymentModeID = Util.GetInt(dataInvoice[0].PaymentModeID);
                objInvMas.LedgerTnxNo = "0";
                string InvMID = objInvMas.Insert().ToString();
                if (InvMID == string.Empty)
                {
                    objTran.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Invoice No. Not Generated" });
                }

                for (int i = 0; i < dataItemDetails.Count; i++)
                {
                    DateTime ExpityDate = Util.GetDateTime(StockReports.ExecuteScalar("SELECT LAST_DAY( DATE_ADD('" + Util.GetDateTime(dataItemDetails[i].MedExpiryDate).ToString("yyyy-MM-dd") + "', INTERVAL 0 MONTH)) "));
                    Stock objStock = new Stock(objTran);
                    decimal MRP = Util.GetDecimal(dataItemDetails[i].MRP);
                    objStock.Hospital_ID = Session["HOSPID"].ToString();
                    objStock.ItemID = Util.GetString(dataItemDetails[i].ItemID);
                    objStock.ItemName = Util.GetString(dataItemDetails[i].ItemName);
                    objStock.LedgerTransactionNo = "0";
                    objStock.LedgerTnxNo = "0";
                    objStock.BatchNumber = Util.GetString(dataItemDetails[i].BatchNumber);
                    if (Util.GetFloat(dataItemDetails[i].ConversionFactor) > 0)
                        objStock.UnitPrice = Util.GetDecimal(Util.GetDecimal(dataItemDetails[i].UnitPrice) * CurrencyFactor) / Util.GetDecimal(dataItemDetails[i].ConversionFactor);
                    else
                        objStock.UnitPrice = Util.GetDecimal(Util.GetDecimal(dataItemDetails[i].UnitPrice) * CurrencyFactor);
                    objStock.MRP = Util.GetDecimal(Util.GetFloat(MRP)) * CurrencyFactor / Util.GetDecimal(dataItemDetails[i].ConversionFactor);
                    if (objStock.MRP <= 0)
                    {
                        objTran.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Selling Price Can Not Be Zero.", message = "Selling Price Can Not Be Zero." });
                    }
                    objStock.MajorMRP = Util.GetDecimal(Util.GetFloat(MRP)) * CurrencyFactor;
                    objStock.IsCountable = 1;
                    objStock.InitialCount = Util.GetDecimal(dataItemDetails[i].Quantity) * Util.GetDecimal(dataItemDetails[i].ConversionFactor);
                    objStock.ReleasedCount = 0;
                    objStock.IsReturn = 0;
                    objStock.LedgerNo = string.Empty;
                    if (dataItemDetails[i].MedExpiryDate.ToString().Length > 0)
                    {
                        objStock.MedExpiryDate = Util.GetDateTime(ExpityDate);
                    }
                    else
                    {
                        objStock.MedExpiryDate = DateTime.Now.AddYears(5);
                    }
                    objStock.StockDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                    if (Util.GetString(dataInvoice[0].StoreLedgerNo) == "STO00001")
                    {
                        objStock.TypeOfTnx = "Purchase";
                        objStock.StoreLedgerNo = "STO00001";
                    }
                    else if (Util.GetString(dataInvoice[0].StoreLedgerNo) == "STO00002")
                    {
                        objStock.TypeOfTnx = "NMPURCHASE";
                        objStock.StoreLedgerNo = "STO00002";
                    }
                    objStock.IsPost = 0;
                    objStock.Naration = Util.GetString(dataItemDetails[i].Naration);
                    objStock.IsFree = Util.GetInt(dataItemDetails[i].IsFree);
                    objStock.SubCategoryID = Util.GetString(dataItemDetails[i].SubCategoryID);
                    objStock.Unit = Util.GetString(dataItemDetails[i].MinorUnit);
                    objStock.DeptLedgerNo = Util.GetString(dataItemDetails[i].DeptLedgerNo);
                    objStock.UserID = Session["ID"].ToString();
                    objStock.IsBilled = 1;
                    objStock.Rate = Util.GetDecimal(dataItemDetails[i].Rate) * CurrencyFactor;
                    objStock.DiscPer = Util.GetDecimal(dataItemDetails[i].DiscPer);
                    objStock.VenLedgerNo = Util.GetString(dataItemDetails[i].VenLedgerNo);
                    objStock.DiscAmt = Util.GetDecimal(dataItemDetails[i].DiscAmt) * CurrencyFactor;
                    objStock.TYPE = Util.GetString(StockReports.ExecuteScalar("SELECT im.Type_ID FROM f_itemmaster im WHERE im.ItemID='" + Util.GetString(dataItemDetails[i].ItemID) + "'"));
                    string Reusable = Util.GetString(StockReports.ExecuteScalar("SELECT im.IsUsable FROM f_itemmaster im WHERE im.ItemID='" + Util.GetString(dataItemDetails[i].ItemID) + "'"));
                    if (Reusable == "R")
                        objStock.Reusable = Util.GetInt("1");
                    else
                        objStock.Reusable = Util.GetInt("0");
                    objStock.ConversionFactor = Util.GetDecimal(dataItemDetails[i].ConversionFactor);
                    objStock.MajorUnit = Util.GetString(dataItemDetails[i].MajorUnit);
                    objStock.MinorUnit = Util.GetString(dataItemDetails[i].MinorUnit);
                    objStock.InvoiceNo = Util.GetString(dataItemDetails[i].InvoiceNo);
                    objStock.InvoiceDate = Util.GetDateTime(dataItemDetails[i].InvoiceDate);
                    objStock.CentreID = Util.GetInt(Session["CentreID"].ToString());
                    objStock.IpAddress = All_LoadData.IpAddress();
                    objStock.IsExpirable = Util.GetInt(dataItemDetails[i].IsExpirable);
                    objStock.PurTaxPer = Util.GetDecimal(dataItemDetails[i].PurTaxPer);
                    objStock.PurTaxAmt = Util.GetDecimal(dataItemDetails[i].PurTaxAmt) * CurrencyFactor;
                    objStock.ExciseAmt = Util.GetDecimal("0");
                    objStock.ExcisePer = Util.GetDecimal("0");
                    objStock.taxCalculateOn = "RateAD";
                    objStock.isDeal = Util.GetString(dataItemDetails[i].isDeal);
                    objStock.HSNCode = Util.GetString(dataItemDetails[i].HSNCode);
                    objStock.GSTType = Util.GetString(dataItemDetails[i].GSTType);
                    objStock.IGSTPercent = Util.GetDecimal(dataItemDetails[i].IGSTPercent);
                    objStock.IGSTAmtPerUnit = Math.Round(Util.GetDecimal(dataItemDetails[i].IGSTAmt) / (Util.GetDecimal(objStock.InitialCount)), 4, MidpointRounding.AwayFromZero) * CurrencyFactor;
                    objStock.CGSTPercent = Util.GetDecimal(dataItemDetails[i].CGSTPercent);
                    objStock.CGSTAmtPerUnit = Math.Round(Util.GetDecimal(dataItemDetails[i].CGSTAmt) / (Util.GetDecimal(objStock.InitialCount)), 4, MidpointRounding.AwayFromZero) * CurrencyFactor;
                    objStock.SGSTPercent = Util.GetDecimal(dataItemDetails[i].SGSTPercent);
                    objStock.SGSTAmtPerUnit = Math.Round(Util.GetDecimal(dataItemDetails[i].SGSTAmt) / (Util.GetDecimal(objStock.InitialCount)), 4, MidpointRounding.AwayFromZero) * CurrencyFactor;
                    objStock.SpecialDiscPer = Util.GetDecimal(dataItemDetails[i].SpecialDiscPer);
                    objStock.SpecialDiscAmt = Util.GetDecimal(dataItemDetails[i].SpecialDiscAmt) * CurrencyFactor;
                    objStock.ChalanNo = Util.GetString(dataItemDetails[i].ChalanNo);
                    objStock.ChalanDate = Util.GetDateTime(dataItemDetails[i].ChalanDate);
                    objStock.InvoiceAmount = objInvMas.InvoiceAmount;
                    objStock.OtherCharges = Util.GetDecimal(dataItemDetails[i].otherCharges) * CurrencyFactor;
                    objStock.MarkUpPercent = Util.GetDecimal(dataItemDetails[i].markUpPercent);
                    objStock.LandingCost = 0;
                    objStock.PONumber = Util.GetString(dataInvoice[0].PONumber);
                    objStock.CurrencyCountryID = Util.GetInt(dataInvoice[0].currencyCountryID);
                    objStock.Currency = Util.GetString(dataInvoice[0].currency);
                    objStock.CurrencyFactor = Util.GetDecimal(dataInvoice[0].CurrencyFactor);
                    objStock.SaleTaxPer = Util.GetDecimal(dataItemDetails[i].SaleTaxPer);
                    if (objStock.SaleTaxPer > 0)
                        objStock.SaleTaxAmt = Math.Round((Util.GetDecimal((dataItemDetails[i].MRP * 100) / (100 + objStock.SaleTaxPer)) * objStock.SaleTaxPer / 100) * Util.GetDecimal(dataItemDetails[i].Quantity), 4);
                    else
                        objStock.SaleTaxAmt = 0;
                    objStock.ReferenceNo = GRNNo;

                    string StockID = objStock.Insert().ToString();
                    if (!string.IsNullOrEmpty(dataInvoice[0].PONumber))
                    {
                        string sqlCMD = "UPDATE f_purchaseorderdetails pod SET pod.RecievedQty = (SELECT SUM(st.InitialCount) FROM f_stock st WHERE st.IsPost IN (0,1) AND st.ItemID = pod.ItemID AND pod.PurchaseOrderNo = st.PONumber GROUP BY st.ItemID,st.PONumber) WHERE pod.PurchaseOrderNo=@PONumber ";
                        var res = excuteCMD.DML(objTran, sqlCMD.ToString(), CommandType.Text, new
                        {
                            PONumber = dataInvoice[0].PONumber,
                        });
                        if (Util.GetInt(res) < 1)
                        {
                            objTran.Rollback();
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error occurred, Please contact administrator" });
                        }
                        decimal isPendigQty = Util.GetDecimal(MySqlHelper.ExecuteScalar(objTran, CommandType.Text, "SELECT SUM(pod.`ApprovedQty`-pod.`RecievedQty`) FROM f_purchaseorderdetails pod WHERE pod.`PurchaseOrderNo`='" + Util.GetString(dataInvoice[0].PONumber) + "'"));
                        if (isPendigQty < 1)
                            MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, "UPDATE `f_purchaseorder` po SET po.`Status`='3' WHERE po.`PurchaseOrderNo`='" + Util.GetString(dataInvoice[0].PONumber) + "'");
                        else
                            MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, "UPDATE `f_purchaseorder` po SET po.`Status`='2' WHERE po.`PurchaseOrderNo`='" + Util.GetString(dataInvoice[0].PONumber) + "'");
                    }

                    if (StockID == string.Empty)
                    {
                        objTran.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error occurred, Please contact administrator" });
                    }

                    string updatestr = string.Empty;
                    if (Util.GetInt(dataItemDetails[i].IsUpdateCF) == 1)
                    {
                        updatestr += "im.ConversionFactor=" + Util.GetDouble(dataItemDetails[i].ConversionFactor);
                    }
                    if (Util.GetInt(dataItemDetails[i].IsUpdateHSNCode) == 1)
                    {
                        updatestr += "im.HSNCode=" + Util.GetString(dataItemDetails[i].HSNCode);
                    }
                    if (Util.GetInt(dataItemDetails[i].IsUpdateGST) == 1)
                    {
                        updatestr += "im.CGSTPercent=" + Util.GetDecimal(dataItemDetails[i].CGSTPercent) + ",im.SGSTPercent=" + Util.GetDecimal(dataItemDetails[i].SGSTPercent) + ",im.IGSTPercent=" + Util.GetDecimal(dataItemDetails[i].IGSTPercent) + ",im.GSTType=" + Util.GetString(dataItemDetails[i].GSTType);
                    }
                    if (!string.IsNullOrEmpty(updatestr))
                    {
                        MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, "UPDATE f_itemmaster im SET " + updatestr + " WHERE im.ItemID='" + Util.GetString(dataItemDetails[i].ItemID) + "'");
                    }
                }
            }

            objTran.Commit();

            if (isConsignment == 1)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = LedgerTnxNo, message = AllGlobalFunction.saveMessage });
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = GRNNo, message = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {
            objTran.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error occurred, Please contact administrator" });
        }
        finally
        {
            objTran.Dispose();
            con.Close();
            con.Dispose();
        }
    }


    [WebMethod(EnableSession = true, Description = "Save and Print Lable")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string LabelToPrint(object data)
    {
        List<LablePrintInsert> dataPrint = new JavaScriptSerializer().ConvertToType<List<LablePrintInsert>>(data);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            StockReports.ExecuteDML("Drop table if exists Temp_Tenwek_LablePrint");
            string str = "CREATE TABLE  Temp_Tenwek_LablePrint (id int auto_increment Primary key,PName varchar(500),MRNo varchar(500),SideEffect varchar(500) DEFAULT NULL,Duration varchar(500) DEFAULT NULL,Times varchar(500),Dose varchar(500),ItemName varchar(500),ItemDispance varchar(500),ItemID varchar(500),ClientName varchar(500),ClientAddress varchar(500),ClientTelophone varchar(500) DEFAULT NULL,Caution varchar(500) DEFAULT NULL,Remarks varchar(500) DEFAULT NULL,  Date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)";
            StockReports.ExecuteDML(str);

            foreach (var item in dataPrint)
            {
                StringBuilder sb = new StringBuilder();

                sb.Append(" INSERT INTO  Temp_Tenwek_LablePrint ");
                sb.Append(" (PName,MRNo,SideEffect,Duration,Times,Dose,ItemName,ItemDispance,ItemID,ClientName,ClientAddress,ClientTelophone,Caution,Remarks) ");
                sb.Append(" VALUES (@PName,@MRNo,@SideEffect,@Duration,@Times,@Dose,@ItemName,@ItemDispance,@ItemID,@ClientName,@ClientAddress,@ClientTelophone,@Caution,@Remarks)");
                int T = excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
                {
                    PName = item.PName,
                    MRNo = item.MRNo,
                    SideEffect = item.SideEffect,
                    Duration = item.Duration,
                    Times = item.Times,
                    Dose = item.Dose,
                    ItemName = item.ItemName,
                    ItemDispance = item.ItemDispance,
                    ItemID = item.ItemID,
                    ClientName = Resources.Resource.ClientName,
                    ClientAddress = Resources.Resource.ClientAddress,
                    ClientTelophone = Resources.Resource.ClientTelophone,
                    Caution = item.SideEffect,
                    Remarks = item.Remarks
                });
            }


            StringBuilder sbUpd = new StringBuilder();

            sbUpd.Append("update f_ledgertransaction set IsLablePrint=1 where LedgerTransactionNo=@LedgerTransactionNo");

            int IsUpdate = excuteCMD.DML(tnx, sbUpd.ToString(), CommandType.Text, new
            {
                LedgerTransactionNo = dataPrint[0].LedgerTransactionNo,

            });

            tnx.Commit();
            StringBuilder sb1 = new StringBuilder();
            sb1.Append("SELECT * FROM Temp_Tenwek_LablePrint");
            DataTable dt = StockReports.GetDataTable(sb1.ToString());

            DataSet ds = new DataSet();
            DataColumn dc = new DataColumn();
            dc.ColumnName = "PrintBy";
            dc.DefaultValue = StockReports.GetUserName(Convert.ToString(HttpContext.Current.Session["ID"])).Rows[0][0];
            dt.Columns.Add(dc);
            // asset barcode----
            dt.Columns.Add("BarCode", System.Type.GetType("System.Byte[]"));
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                var aa = OutputImg(dt.Rows[i]["ItemID"].ToString());

                dt.Rows[i]["BarCode"] = GetBitmapBytes(objBitmap);
            }
            ds.Tables.Add(dt.Copy());
            //ds.WriteXmlSchema(@"E:\LabelToPrints.xml");
            HttpContext.Current.Session["ds"] = ds;
            HttpContext.Current.Session["ReportName"] = "LabelToPrint";
            return "1";

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    private Bitmap objBitmap;


    public string OutputImg(string PatientID)
    {
        string FontName = "";
        Graphics objGraphics;
        Point p;

        //Response.ContentType = "image/Jpeg";
        Barcode MyBarcode = new Barcode();
        MyBarcode.BackColor = System.Drawing.ColorTranslator.FromHtml("#FFF");
        MyBarcode.BarColor = Color.Black;
        MyBarcode.CheckDigit = true;
        MyBarcode.CheckDigitToText = true;
        MyBarcode.Data = PatientID;
        MyBarcode.BarHeight = 1.0F;
        MyBarcode.NarrowBarWidth = 0.04F;
        MyBarcode.Orientation = MW6BarcodeASPNet.enumOrientation.or0;
        MyBarcode.SymbologyType = MW6BarcodeASPNet.enumSymbologyType.syCode128;
        MyBarcode.ShowText = false;
        MyBarcode.Wide2NarrowRatio = 0.5F;
        FontName = "Verdana, Arial, sans-serif";
        MyBarcode.TextFont = new Font(FontName, 8.0F);
        MyBarcode.SetSize(160, 30);
        objBitmap = new Bitmap(160, 30);
        objGraphics = Graphics.FromImage(objBitmap);
        p = new Point(0, 0);
        MyBarcode.Render(objGraphics, p);
        objGraphics.Flush();

        if (System.IO.File.Exists(Server.MapPath(@"~\Design\2.jpeg")))
        {
            System.IO.File.Delete(Server.MapPath(@"~\Design\2.jpeg"));
        }
        return "";
    }

    private static byte[] GetBitmapBytes(Bitmap Bitmap1)    //  getting Stream of Bar Code image
    {
        MemoryStream memStream = new MemoryStream();
        byte[] bytes;

        try
        {
            // Save the bitmap to the MemoryStream.
            Bitmap1.Save(memStream, System.Drawing.Imaging.ImageFormat.Jpeg);

            // Create the byte array.
            bytes = new byte[memStream.Length];

            // Rewind.
            memStream.Seek(0, SeekOrigin.Begin);

            // Read the MemoryStream to get the bitmap's bytes.
            memStream.Read(bytes, 0, bytes.Length);

            // Return the byte array.
            return bytes;
        }
        finally
        {
            // Cleanup.
            memStream.Close();
            memStream.Dispose();
        }
    }







    [WebMethod(EnableSession = true)]
    public string GetLastTenGrnList(string ItemID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT DATE_FORMAT(st.`StockDate`,'%d-%b-%y')GRNDate,st.ItemName,st.Rate,st.ReferenceNo AS LedgerTransactionNo ,st.Mrp,(SELECT lm.LedgerName FROM f_ledgermaster lm INNER JOIN `f_vendormaster` vm ON lm.`LedgerUserID`=vm.`Vendor_ID`  WHERE groupID='VEN' AND IsCurrent=1 AND lm.LedgerNumber=st.`VenLedgerNo`) VendorName ,st.`DiscAmt`,st.`DiscPer` ");
        sb.Append(" FROM  f_stock st  ");
        sb.Append(" WHERE st.`IsPost`=1 AND st.`ItemID`='" + ItemID + "'  AND st.`MedExpiryDate`>=CURDATE() AND st.`TypeOfTnx`='PURCHASE' ORDER BY st.ReferenceNo desc LIMIT 5  ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
}
