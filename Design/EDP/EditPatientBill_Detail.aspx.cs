using System;
using System.Data;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using MySql.Data.MySqlClient;
using System.Web.Script.Serialization;
using System.Collections.Generic;

public partial class Design_EDP_EditPatientBill_Detail : System.Web.UI.Page
{
    string TID;
    [WebMethod(EnableSession = true)]
    public static string UpdateMedicalBill(List<LTD> LTDData)
    {
        try
        {
            int LTDlen = LTDData.Count;
            int ResultLT;
            if (LTDlen > 0)
            {
                MySqlConnection con = new MySqlConnection();
                con = Util.GetMySqlCon();
                con.Open();
                MySqlTransaction tranX = con.BeginTransaction();
                
                for (int i = 0; i < LTDData.Count; i++)
                {
                    string LTDStr = " UPDATE f_ledgertnxdetail ltd INNER JOIN f_ledgertransaction lt SET ltd.itemID='" + LTDData[i].ItemID + "',ltd.Rate='" + LTDData[i].Rate + "', " +
                                 "ltd.Quantity='" + LTDData[i].Quantity + "',ltd.Amount='" + LTDData[i].Amount + "',ltd.StockID='" + LTDData[i].StockID + "', " +
                                 " ltd.DiscountPercentage='" + LTDData[i].DiscountPrecentage + "',ltd.DiscAmt='" + LTDData[i].DisAmount + "',ltd.SubCategoryID='" + LTDData[i].SubCategoryID + "', " +
                                 " ltd.itemname='" + LTDData[i].ItemName + "',ltd.LastUpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "',ltd.updatedDate=Now(),ltd.afterbill='" + LTDData[i].afterbill + "',isEdit=1,pageURL='" + All_LoadData.getCurrentPageName() + "' " +
                                 " WHERE ltd.LedgerTransactionNO='" + LTDData[i].LedgertransactionNo + "' AND ltd.ITEMID='" + LTDData[i].OldItemID + "' and ltd.StockID='" + LTDData[i].OldStockID + "' AND ltd.LedgerTnxId='" + LTDData[i].LedgerTnxId + "' ";
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, LTDStr);
                     ResultLT = MySqlHelperNEw.ExecuteNonQuery(tranX, CommandType.Text, "CALL UpdateMedicineDetail('" + LTDData[i].LedgertransactionNo + "')");
                     if (ResultLT == 0)
                     {
                         tranX.Rollback();
                         tranX.Dispose();
                         con.Close();
                         con.Dispose();
                         return "0";
                     }
                }
                
                tranX.Commit();

            }
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "";
        }

    }
    [WebMethod(EnableSession = true)]
    public static string SaveMedical(List<saveLgrtnx> SMedicine, string tid, string pid, string PanelID)
    {
        int SMLTD = SMedicine.Count;
        //int ResultLTD;
        string LedTxnID = string.Empty;
        if (SMLTD > 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranx = con.BeginTransaction();
            try
            {
                for (int i = 0; i < SMedicine.Count; i++)
                {

                    Ledger_Transaction objLedTran = new Ledger_Transaction(tranx);
                    objLedTran.LedgerNoDr = "STO00001";
                    objLedTran.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                    objLedTran.TypeOfTnx = "Sales";
                    objLedTran.Time = DateTime.Now;
                    objLedTran.Date = Util.GetDateTime(SMedicine[i].PDate);
                    objLedTran.GrossAmount = Util.GetDecimal(SMedicine[i].Amount);
                    objLedTran.NetAmount = Util.GetDecimal(SMedicine[i].Amount);
                    objLedTran.PanelID = Util.GetInt(PanelID) ;
                    objLedTran.TransactionID = tid;
                    objLedTran.PatientID = pid;
                    objLedTran.TransactionType_ID = Util.GetInt("3");
                    objLedTran.IndentNo = "-";
                    objLedTran.IpAddress = HttpContext.Current.Request.UserHostAddress;
                    objLedTran.UniqueHash = Util.getHash();
                    objLedTran.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    objLedTran.UserID = HttpContext.Current.Session["ID"].ToString();
                    LedTxnID = objLedTran.Insert().ToString();
                    if (LedTxnID == string.Empty)
                    {
                        tranx.Rollback();
                        tranx.Dispose();
                        con.Close();
                        con.Dispose();
                        return string.Empty;
                    }


                    LedgerTnxDetail objLTDetail = new LedgerTnxDetail(tranx);
                    objLTDetail.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
                    objLTDetail.LedgerTransactionNo = LedTxnID;
                    objLTDetail.ItemID = SMedicine[i].ItemID;
                    objLTDetail.ConfigID = 11;
                    objLTDetail.Rate = Util.GetDecimal(SMedicine[i].MRP);
                    objLTDetail.Quantity = Util.GetDecimal(SMedicine[i].AddQty);
                    objLTDetail.Amount = Util.GetDecimal(SMedicine[i].Amount);
                    objLTDetail.DiscAmt = 0;
                    objLTDetail.DiscountPercentage = 0;
                    objLTDetail.IsVerified = 1;
                    objLTDetail.ItemName = SMedicine[i].ItemName;
                    objLTDetail.TransactionID = tid;
                    objLTDetail.EntryDate = Util.GetDateTime(SMedicine[i].PDate);
                    objLTDetail.Type_ID = "HS";
                    objLTDetail.AfterBill = 1;
                    objLTDetail.SubCategoryID = SMedicine[i].SubCategoryID;
                    objLTDetail.StockID = SMedicine[i].StockId;
                    objLTDetail.UserID = HttpContext.Current.Session["ID"].ToString();
                    objLTDetail.isEdit = 1;
                    objLTDetail.pageURL = All_LoadData.getCurrentPageName();
                    objLTDetail.Type = "I";
                    objLTDetail.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    objLTDetail.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                    objLTDetail.IpAddress = All_LoadData.IpAddress();
                    objLTDetail.VerifiedDate = Util.GetDateTime(SMedicine[i].PDate);
                    objLTDetail.VarifiedUserID = HttpContext.Current.Session["ID"].ToString();
                    objLTDetail.StoreLedgerNo = "STO00001";
                    int ID = objLTDetail.Insert();

                    if (ID == 0)
                    {
                        tranx.Rollback();
                        tranx.Dispose();
                        con.Close();
                        con.Dispose();
                        return string.Empty;
                    }
                    
                }
            }
            catch (Exception ex)
            {
                ClassLog c1 = new ClassLog();
                c1.errLog(ex);
                tranx.Rollback();
                tranx.Dispose();
                con.Close();
                con.Dispose();
                return string.Empty;
            }
            tranx.Commit();
        }

        return "1";
    }
    public class LTD
    {
        public string OldItemID { get; set; }
        public string ItemID { get; set; }
        public string ItemName { get; set; }
        public string Rate { get; set; }
        public int Quantity { get; set; }
        public string Amount { get; set; }
        public string StockID { get; set; }
        public string SubCategoryID { get; set; }
        public string LedgertransactionNo { get; set; }
        public string DiscountPrecentage { get; set; }
        public string DisAmount { get; set; }
        public string afterbill { get; set; }
        public string OldStockID { get; set;}
        public string LedgerTnxId { get; set; } 

    }

    public class saveLgrtnx
    {
        public string ItemID { get; set; }
        public string ItemName { get; set; }
        public string PDate { get; set; }
        public string BatchNumber { get; set; }
        public string AddQty { get; set; }
        public string MRP { get; set; }
        public string Unit { get; set; }
        public string Amount { get; set; }
        public string StockId { get; set; }
        public string SubCategoryID { get; set; }
    }

    [WebMethod]
    public static string ShowStock(string itemID)
    {
        try
        {
            DataTable dt = StockReports.GetDataTable(" SELECT ItemName,CONCAT(ItemID,'#',StockID)StockID FROM f_stock WHERE itemID='" + itemID + "' AND (initialCount-ReleasedCount)>0 AND MedExpiryDate>NOW() AND DeptLedgerNo='LSHHI57'");
            if (dt.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            else
                return "";
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            return "";
        }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            TID = Request.QueryString["TransactionID"].ToString();
           
            AllQuery AQ = new AllQuery();
            DataTable dt = AQ.d_GetPatientAdjustmentDetails(TID);
            DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(Session["RoleID"]), Util.GetString(Session["ID"]));

            if (dt != null && dt.Rows.Count > 0)
            {

                if (dt.Rows[0]["BillNo"].ToString().Trim() != "")
                {

                    if (dt.Rows[0]["BillNo"].ToString().Trim() != "" && (dtAuthority != null && dtAuthority.Rows.Count > 0))
                    {
                        string Msg = "";

                        if (dtAuthority.Rows[0]["BillChange"].ToString() == "0")
                        {
                            Msg = "You Are Not Authorised To AMEND IPD Bills...";
                            Response.Redirect("~/Design/IPD/PatientBillMsg.aspx?msg=" + Msg);
                        }
                        else if (dtAuthority.Rows[0]["BillChange"].ToString() == "1" && dt.Rows[0]["IsBilledClosed"].ToString().Trim() == "1")
                        {
                            Msg = "Patient's Final Bill has been Closed for Further Updating...";
                            Response.Redirect("~/Design/IPD/PatientBillMsg.aspx?msg=" + Msg);
                        }
                    }
                    else if (dt.Rows[0]["BillNo"].ToString().Trim() != "" && (dtAuthority != null && dtAuthority.Rows.Count == 0))
                    {
                        string Msg = "";
                        Msg = "You Are Not Authorised To AMEND This IPD Bills...";
                        Response.Redirect("~/Design/IPD/PatientBillMsg.aspx?msg=" + Msg);

                    }
                }
            }
        }
        txtpreFromDate.Attributes.Add("readOnly", "readOnly");
        txtpreToDate.Attributes.Add("readOnly","readOnly");
        All_LoadData.fromDatetoDate(TID, txtpreFromDate, txtpreToDate, calFromDate, calToDate);
    }
    [WebMethod]
    public static string bindPatientData(string TID)
    {
        string IsDischarge = StockReports.ExecuteScalar("SELECT STATUS FROM ipd_case_history where TransactionID='ISHHI" + TID + "'");
        if (IsDischarge == "IN")
            return "1";
        if (IsDischarge == "OUT")
            return "2";
        if (IsDischarge == "Cancel")
            return "3";
        else
            return "";            
    }
    
    [WebMethod]
    public static string bindPatientDetail(string IPDNo)
    {
        StringBuilder sb = new StringBuilder();
        try
        {
            sb.Append("Select lt.LedgerTransactionNo,DATE_FORMAT(LT.DATE,'%d-%b-%Y')Date,ROUND(SUM(LT.NETAMOUNT),2)Amount, lt.BillNo, PM.Title,PM.PName,PMH.PatientID,CONCAT(RM.Floor,'/',RM.Name)RoomNo, ");
            sb.Append(" FPM.Company_Name,PMH.TransactionID,REPLACE(PMH.TransactionID,'ISHHI','') IPDNo,FPM.ReferenceCode,PIP.IPDCaseType_ID,FPM.PanelID,lt.UniqueHash,PIP.Room_ID from (Select TransactionID,Room_ID,IPDCaseType_ID_Bill IPDCaseType_ID from patient_ipd_profile");
            if (IPDNo != "")
                sb.Append(" Where TransactionID = 'ISHHI" + IPDNo.Trim() + "'");
            sb.Append("   ) PIP,(Select PatientID,TransactionID,PanelID from patient_medical_history ");
            sb.Append(" Where ");
            if (IPDNo != "")
                sb.Append(" TransactionID = 'ISHHI" + IPDNo + "' and ");
            sb.Append(" Type='IPD' )PMH,(Select Title,PName,PatientID from patient_master ");
            sb.Append(" ) PM ,room_master RM, f_panel_master FPM ");
            sb.Append(" ,(SELECT lt.TransactionID,sal.billNo,lt.Date,lt.netAmount,lt.LedgerTransactionNo ,lt.UniqueHash  FROM f_salesdetails sal INNER JOIN f_ledgertransaction ");
            sb.Append("  lt ON lt.LedgerTransactionNo=sal.LedgerTransactionNo WHERE   lt.typeofTnx	='SALES' AND lt.IpNo='' ");
            if (IPDNo != "")
                sb.Append(" and lt.TransactionID='ISHHI" + IPDNo.Trim() + "' ");
            sb.Append(" GROUP BY sal.billNo  )lt ");
            sb.Append(" Where PM.PatientID = PMH.PatientID and PMH.TransactionID = PIP.TransactionID and PIP.Room_ID = RM.Room_ID and PMH.PanelID = FPM.PanelID AND lt.TransactionID=pmh.TransactionID GROUP BY lt.billno ORDER BY LT.BillNo ");
            
            DataTable dt = StockReports.GetDataTable(sb.ToString());
                if(dt.Rows.Count<=0)

            {
                StringBuilder sbn = new StringBuilder();
                sbn.Append("   SELECT pm.PName,(pm.PatientID)PatientID,pmh.TransactionID AS IPDNo, ");
                sbn.Append(" (SELECT Company_Name FROM f_panel_master WHERE PanelID=pmh.PanelID)PanelName ");
                sbn.Append(" FROM patient_master pm INNER JOIN patient_medical_history pmh ");
                sbn.Append(" ON pm.PatientID=pmh.PatientID where pmh.TransactionID='ISHHI" + IPDNo + "' ");
                DataTable dt1 = StockReports.GetDataTable(sbn.ToString());
                if (dt1.Rows.Count > 0)
                    return Newtonsoft.Json.JsonConvert.SerializeObject(dt1);
            }

            if (dt.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            else
                return "";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
    }
    [WebMethod]
    public static string bindPrescribedItem(string IPDNo)
    {
        try
        {
            DataTable dt = StockReports.GetDataTable("SELECT CONCAT(itemID,'#',LedgerTransactionNo)itemID,itemName FROM f_ledgertnxdetail WHERE TransactionID='" + IPDNo + "' AND configID='11' GROUP By ItemID ORDER BY ItemName ");
            if (dt.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            else
                return "";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
    }
    [WebMethod]
    public static string bindMedicalItem()
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT DISTINCT(im.TypeName),CONCAT(im.ItemID,'#',im.SubCategoryID)ItemID FROM f_itemmaster im INNER JOIN f_subcategorymaster scm ON  scm.SubCategoryID=im.SubCategoryID ");
            sb.Append(" INNER JOIN f_configrelation cr ON cr.CategoryID=scm.CategoryID inner join f_stock st on st.itemID=im.itemID ");
            sb.Append(" WHERE ConfigID='11'  AND (st.initialCount-st.ReleasedCount)>0 AND MedExpiryDate>NOW() ORDER BY im.TypeName ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            else
                return "";
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            return "";
        }
    }

    [WebMethod]
    public static string bindGetItemDetail(string IPDNo, string From, string To, string ItemID)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT ltd.LedgerTnxID,ltd.itemID,ltd.itemname,scm.Name,ltd.Rate,ltd.Quantity,ltd.Amount,REPLACE(ltd.`EntryDate`,'00:00:00','')PDate,DATE_FORMAT(lt.Date,'%d-%b-%y')BillDate,ltd.StockID, ");
            sb.Append("ltd.LedgerTransactionNo,ltd.TransactionID FROM f_ledgertnxdetail ltd ");
            sb.Append("INNER JOIN f_ledgertransaction lt ON ltd.LedgerTransactionNo=lt.LedgerTransactionNo ");
            sb.Append("INNER JOIN f_SubCategoryMaster scm ON scm.SubCategoryID = ltd.SubCategoryID ");
            sb.Append(" where ltd.TransactionID='" + IPDNo + "' AND DATE(ltd.EntryDate)>='" + Util.GetDateTime(From).ToString("yyyy-MM-dd") + "' AND DATE(ltd.EntryDate)<='" + Util.GetDateTime(To).ToString("yyyy-MM-dd") + "' AND ltd.itemID='" + ItemID + "' ORDER By DATE(ltd.EntryDate)");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            else
                return "";
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            return "";
        }
    }
    [WebMethod]
    public static string bindAddMedicineDetail(string ItemID, string From, string To, int Qty)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT st.StockID,st.ItemID,st.ItemName,st.BatchNumber,st.UnitPrice,st.MRP,DATE_FORMAT(st.MedExpiryDate,'%d-%b-%y')MedExpiryDate, ");
        sb.Append(" (st.InitialCount-st.ReleasedCount)AvailQty,st.SubCategoryID, im.Type_ID,im.IsUsable, im.ToBeBilled, st.UnitType,''PDate, ");
        sb.Append(" im.ServiceItemID,im.isexpirable FROM f_stock st INNER JOIN f_itemmaster im ON st.ItemID=im.ItemID ");
        sb.Append(" WHERE st.ItemID='" + ItemID + "'  ");
        sb.Append(" AND (st.InitialCount-st.ReleasedCount)>0 AND st.Ispost=1  ");
        sb.Append(" AND st.MedExpiryDate>CURDATE() ORDER BY st.stockid limit 1 ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataTable dtMedicine;
            dtMedicine = dtAddMedicine();
            DateTime start = DateTime.Parse(From);
            DateTime end = DateTime.Parse(To);
            for (DateTime count = start; count <= end; count = count.AddDays(1))
            {
                DataRow dr = dtMedicine.NewRow();
                dr["ItemName"] = dt.Rows[0]["ItemName"].ToString();
                dr["AITEMID"]=dt.Rows[0]["ItemID"].ToString();
                dr["PDate"] = Util.GetDateTime(count).ToString("yyyy-MM-dd");
                dr["BatchNumber"] = dt.Rows[0]["BatchNumber"].ToString();
                dr["AvailQty"] = Qty;
                dr["MRP"] = dt.Rows[0]["MRP"].ToString();
                dr["UnitPrice"] = dt.Rows[0]["UnitPrice"].ToString();
                dr["UnitType"] = dt.Rows[0]["UnitType"].ToString();
                dr["SubCategoryID"] = dt.Rows[0]["SubCategoryID"].ToString();
                dr["StockID"] = dt.Rows[0]["StockID"].ToString();
                dtMedicine.Rows.Add(dr);
            }

            if (dtMedicine.Rows.Count > 0)
            {

                return Newtonsoft.Json.JsonConvert.SerializeObject(dtMedicine);
            }
            else
                return "";
        }

        else
        {
            return "";
        }



    }

    private static DataTable dtAddMedicine()
    {
        DataTable dtAMed = new DataTable();
        dtAMed.Columns.Add("ItemName");
        dtAMed.Columns.Add("AITEMID");
        dtAMed.Columns.Add("PDate");
        dtAMed.Columns.Add("BatchNumber");
        dtAMed.Columns.Add("AvailQty", typeof(float));
        dtAMed.Columns.Add("MRP", typeof(float));
        dtAMed.Columns.Add("UnitPrice", typeof(float));
        dtAMed.Columns.Add("UnitType");
        dtAMed.Columns.Add("SubCategoryID");
        dtAMed.Columns.Add("StockID");
        return dtAMed;
    }

    [WebMethod]
    public static string CheckRate(string StockID, string ItemID)
    {
        try
        {
            DataTable dt = StockReports.GetDataTable(" SELECT Mrp FROM f_stock WHERE StockID='" + StockID + "' and ItemID='" + ItemID + "' ");
            if (dt.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            else
                return "";
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            return "";
        }
    }

    [WebMethod(EnableSession = true)]
    public static string saveAddWithReplaceMedicine(string PItemID, string replaceItemName, string replaceItemID, string FromDate, string ToDate, int Qty, string stockID, string TID, string LedgerTransactionNo)
    {
         StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT st.StockID,st.ItemID,st.ItemName,st.BatchNumber,st.UnitPrice,st.MRP, ");
        sb.Append(" st.SubCategoryID, st.UnitType FROM f_stock st  WHERE st.stockID='" + stockID + "'");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranx = con.BeginTransaction();
            try
            {
                MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, "UPDATE f_ledgertnxdetail SET Quantity='" + Util.GetDecimal(Qty) + "',Rate='"+Util.GetDecimal(dt.Rows[0]["MRP"].ToString())+"', "+
                    " Amount='"+Util.GetDecimal(Util.GetDecimal(dt.Rows[0]["MRP"].ToString()) * Util.GetDecimal(Qty))+"', "+
                    " ItemName='" + replaceItemName + "',SubCategoryID='" + dt.Rows[0]["SubCategoryID"].ToString() + "', "+
                    " LastUpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "',updatedDate=Now(), "+
                    " StockID='" + stockID + "',ItemID='" + replaceItemID + "',isEdit=1,pageURL='" + All_LoadData.getCurrentPageName() + "' " +
                    " WHERE TransactionID='" + TID + "' AND itemID='" + PItemID + "' " +
                    " AND DATE(EntryDate)>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' "+
                    " AND DATE(EntryDate)<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'");

                    

                DateTime start = DateTime.Parse(FromDate);
                DateTime end = DateTime.Parse(ToDate);
                TimeSpan difference = end.Subtract(start);
                for (DateTime counter = start; counter <= end; counter = counter.AddDays(1))
                {

                    int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_ledgertnxdetail WHERE TransactionID='" + TID + "' AND itemID='" + PItemID + "' AND DATE(EntryDate)='" + Util.GetDateTime(counter).ToString("yyyy-MM-dd") + "'"));
                    if (count == 0)
                    {
                        LedgerTnxDetail objLTDetail = new LedgerTnxDetail(tranx);
                        objLTDetail.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
                        objLTDetail.LedgerTransactionNo = LedgerTransactionNo;
                        objLTDetail.ItemID = replaceItemID;
                        objLTDetail.ConfigID = 11;
                        objLTDetail.Rate = Util.GetDecimal(dt.Rows[0]["MRP"].ToString());
                        objLTDetail.Quantity = Util.GetDecimal(Qty);
                        objLTDetail.Amount = Util.GetDecimal(Util.GetDecimal(dt.Rows[0]["MRP"].ToString()) * Util.GetDecimal(Qty));
                        objLTDetail.DiscAmt = 0;
                        objLTDetail.DiscountPercentage = 0;
                        objLTDetail.IsVerified = 1;
                        objLTDetail.ItemName = replaceItemName;
                        objLTDetail.TransactionID = TID;
                        objLTDetail.EntryDate = Util.GetDateTime(counter);
                        objLTDetail.Type_ID = "HS";
                        objLTDetail.AfterBill = 1;
                        objLTDetail.SubCategoryID = dt.Rows[0]["SubCategoryID"].ToString();
                        objLTDetail.StockID = stockID;
                        objLTDetail.UserID = HttpContext.Current.Session["ID"].ToString();
                        objLTDetail.isEdit = 1;
                        objLTDetail.pageURL = All_LoadData.getCurrentPageName();
                        objLTDetail.Type = "I";
                        objLTDetail.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                        objLTDetail.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                        objLTDetail.IpAddress = All_LoadData.IpAddress();
                        objLTDetail.VerifiedDate = Util.GetDateTime(counter);
                        objLTDetail.VarifiedUserID = HttpContext.Current.Session["ID"].ToString();
                        objLTDetail.StoreLedgerNo = "STO00001";
                        int ID = objLTDetail.Insert();

                        if (ID == 0)
                        {
                            tranx.Rollback();
                            tranx.Dispose();
                            con.Close();
                            con.Dispose();
                            return "0";
                        }
                    }


                   
                }
              int  ResultLT = MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, "CALL UpdateMedicineDetail('" + LedgerTransactionNo + "')");
              if (ResultLT == 0)
              {
                  tranx.Rollback();
                  tranx.Dispose();
                  con.Close();
                  con.Dispose();
                  return "0";
              }
                tranx.Commit();
                return "1";
            }
            catch (Exception ex)
            {
                tranx.Rollback();
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
                return "0";
            }

            finally
            {
                tranx.Dispose();
                con.Close();
                con.Dispose();
            }
        }

        else
            return "0";
    }
}