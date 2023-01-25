using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;

public partial class Design_EDP_PatientEditBillDetail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtIPDNo.Focus();
        }

        txtFromDate.Attributes.Add("readOnly", "readOnly");
        txtToDate.Attributes.Add("readOnly", "readOnly");
    }

    [WebMethod]
    public static string bindPatientData(string IPDNo)
    {
        string IsBilledClosed = StockReports.ExecuteScalar("SELECT CONCAT(IsBilledClosed,'#',IFNULL(BillNo,''))IsBilledClosed FROM f_ipdadjustment Where TransactionID = 'ISHHI" + IPDNo + "' ");
        if (IsBilledClosed.Split('#')[1] == "")
            return "3";
        if (IsBilledClosed.Split('#')[0] == "1")
            return "2";
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
            sb.Append(" FPM.Company_Name,PMH.TransactionID,REPLACE(PMH.TransactionID,'ISHHI','') IPDNo,FPM.ReferenceCode,PIP.IPDCaseType_ID,FPM.PanelID,PIP.Room_ID from (Select TransactionID,Room_ID,IPDCaseType_ID_Bill IPDCaseType_ID from patient_ipd_profile");
            if (IPDNo != "")
                sb.Append(" Where TransactionID = 'ISHHI" + IPDNo.Trim() + "'");
            sb.Append("   ) PIP,(Select PatientID,TransactionID,PanelID from patient_medical_history ");
            sb.Append(" Where ");
            if (IPDNo != "")
                sb.Append(" TransactionID = 'ISHHI" + IPDNo + "' and ");
            sb.Append(" Type='IPD' )PMH,(Select Title,PName,PatientID from patient_master ");
            sb.Append(" ) PM ,room_master RM, f_panel_master FPM ");
            sb.Append(" ,(SELECT lt.TransactionID,sal.billNo,lt.Date,lt.netAmount,lt.LedgerTransactionNo  FROM f_salesdetails sal INNER JOIN f_ledgertransaction ");
            sb.Append("  lt ON lt.LedgerTransactionNo=sal.LedgerTransactionNo WHERE   lt.typeofTnx	='SALES' AND lt.IpNo='' ");
            if (IPDNo != "")
                sb.Append(" and lt.TransactionID='ISHHI" + IPDNo.Trim() + "' ");
            sb.Append(" GROUP BY sal.billNo  )lt ");
            sb.Append(" Where PM.PatientID = PMH.PatientID and PMH.TransactionID = PIP.TransactionID and PIP.Room_ID = RM.Room_ID and PMH.PanelID = FPM.PanelID AND lt.TransactionID=pmh.TransactionID GROUP BY lt.billno ORDER BY LT.BillNo ");

            DataTable dt = StockReports.GetDataTable(sb.ToString());
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
    public static string PatientIPDInformation(string IPDNo)
    {
        DataTable dt = StockReports.GetDataTable("Select DM.DoctorName,Date_Format(ICH.DateOfAdmit,'%m-%d-%Y')DateOfAdmit,Date_Format(ICH.DateOfAdmit,'%d-%b-%Y')DateOfAdmit1,Time_format(ICH.TimeOfAdmit,'%h:%i %p')TimeOfAdmit,CONCAT(Date_Format(ICH.DateOfDischarge,'%d-%b-%Y'),' ',Time_format(ICH.TimeOfDischarge,'%H:%i:%s'))DateOfDischarge,DoctorID from (Select Consultant_ID,DateOfAdmit,TimeOfAdmit,DateOfDischarge,TimeOfDischarge  from ipd_case_history Where TransactionID = 'ISHHI" + IPDNo + "' )ICH,(Select CONCAT(Title,' ',Name)DoctorName,DoctorID from  doctor_master Where DoctorID =(Select Consultant_ID from ipd_case_history Where TransactionID = 'ISHHI" + IPDNo + "'))DM Where DM.DoctorID = ICH.Consultant_ID");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod]
    public static string bindItemDetail(string IPDNo, string LedgerTransactionNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" select t3.*,'0' IsNewItem,'0' isAlreadyExist from (select t1.ItemName,t1.SubCategoryID,(t1.IssueQuantity-if(t2.RetQty is null,0,t2.RetQty))availQty,t1.IssueQuantity,date_format(t1.Date,'%d-%b-%Y')Date,DATE_FORMAT(t1.Time,'%h:%i %p')TIME,t1.ID, ");
        sb.Append(" round(t1.IssueAmt/t1.IssueQuantity,2) Rate,t1.LRate,t1.DiscountPercentage,t1.BatchNumber,t1.MRP,t1.UnitPrice,t1.StockID,");
        sb.Append(" t1.ItemID,t1.MedExpiryDate,t1.Patient,t1.BillNo,t1.Type_ID,t1.IsUsable,t1.ServiceItemID,dtEntry from ( select LTD.ID,LT.Date,LT.Time, St.BatchNumber,St.MRP,St.UnitPrice,CONCAT(Lt.LedgerNoCR,'#',LT.TransactionID,'#',PatientID)Patient,");
        sb.Append(" date_format(ST.MedExpiryDate,'%d-%b-%y')MedExpiryDate, LTD.ItemId,Lt.BillNo,sum(LTD.Amount) IssueAmt, sum(LTD.Quantity) IssueQuantity,");
        sb.Append(" LTD.StockID,LTD.Rate LRate,ltd.DiscountPercentage,LTD.ItemName,LTD.SubCategoryID,im.Type_ID,im.IsUsable,im.ServiceItemID,DATE_FORMAT(EntryDate,'%d-%b-%Y')dtEntry from f_ledgertransaction LT INNER JOIN f_ledgertnxdetail LTD on LT.LedgerTransactionNo=LTD.LedgerTransactionNo");
        sb.Append(" INNER JOIN f_stock ST on LTD.StockID=St.StockID INNER JOIN f_itemmaster IM ON ST.ItemID=IM.ItemID  where LT.TypeOfTnx='Sales' AND LT.TransactionID='" + IPDNo + "' AND LT.LedgerTransactionNo='" + LedgerTransactionNo + "' AND ltd.IsVerified=1 GROUP BY LTD.StockID )t1 LEFT JOIN ");
        sb.Append(" (select LTD.StockID,sum(LTD.Quantity) RetQty from f_ledgertransaction LT INNER JOIN f_ledgertnxdetail LTD on LT.LedgerTransactionNo=LTD.LedgerTransactionNo");
        sb.Append(" WHERE LT.TypeOfTnx='Patient-Return'   AND LT.TransactionID='" + IPDNo + "' group by LTD.StockID)t2 on t1.stockId=t2.stockid)t3 order by itemName ");

        DataTable dtItemDetails = StockReports.GetDataTable(sb.ToString());
        if (dtItemDetails.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtItemDetails);
        else
            return "";
    }

    [WebMethod]
    public static string bindItem()
    {
        DataTable item = StockReports.GetDataTable("select itemID,CONCAT(ItemName,'#',sum(InitialCount-ReleasedCount))itemName from f_stock where  IsPost=1 and (InitialCount-ReleasedCount)>0  group by itemID order by itemName");
        //and MedExpiryDate>CURDATE()
        if (item.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(item);
        else
            return "";
    }

    [WebMethod]
    public static string addNewItem(string ItemID, string BillNo, string BillDate)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("  SELECT t1.*,t2.tax FROM(SELECT ST.StockID,ST.ItemID ,ST.ItemName,ST.BatchNumber,ST.SubCategoryID,ST.UnitPrice,ST.MRP LRate,DATE_FORMAT(ST.MedExpiryDate,'%d-%b-%y')MedExpiryDate, ");
        sb.Append(" (ST.InitialCount-ST.ReleasedCount)availQty,'1' IsNewItem,'1' isAlreadyExist,'" + BillNo + "' BillNo,'" + BillDate + "' Date,im.Type_ID,im.IsUsable,im.ServiceItemID  FROM f_stock ST INNER JOIN f_itemmaster IM ON ST.ItemID=IM.ItemID  WHERE ST.ItemID='" + ItemID + "' AND (InitialCount-ReleasedCount)>0 AND ");
        sb.Append(" IsPost=1 ORDER BY DATE(MedExpiryDate)+0)t1 LEFT JOIN (SELECT SUM(tc.perCentage)Tax,tc.StockID ");
        sb.Append(" FROM f_taxchargedlist tc WHERE tc.ItemID = '" + ItemID + "'  GROUP BY tc.stockid)T2 ");
        sb.Append(" ON t1.stockid = t2.stockid");
        //AND MedExpiryDate>CURDATE()
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    public static string editBill(object detail, string LedgertransactionNo, string TransactionID, string BillDate, string BillTime)
    {
        List<patientEditBill> billDetail = new JavaScriptSerializer().ConvertToType<List<patientEditBill>>(detail);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string selectedLTDID = ""; string ID = "";

            for (int i = 0; i < billDetail.Count; i++)
            {
                if ((billDetail[i].LTDID != "") && (billDetail[i].IsNewItem == "0"))
                {
                    if (selectedLTDID != "")
                    {
                        selectedLTDID += ",'" + billDetail[i].LTDID + "'";
                    }
                    else
                    {
                        selectedLTDID = "'" + billDetail[i].LTDID + "'";
                    }
                }

                if ((billDetail[i].IsNewItem == "0") && (Util.GetDecimal(billDetail[i].ActualQty) != Util.GetDecimal(billDetail[i].Quantity)))
                {
                    string strLTD = " update f_ledgertnxdetail set Quantity= " + Util.GetDecimal(billDetail[i].Quantity) + ", Rate=" + Util.GetDecimal(billDetail[i].Rate) + ", " +
                 " Amount=" + (Util.GetDecimal(billDetail[i].Quantity)) * (Util.GetDecimal(billDetail[i].Rate)) + ",UpdateDate=now() " +
                 " where LedgertransactionNo='" + LedgertransactionNo + "' and stockId='" + billDetail[i].StockID + "' ";
                    int ResultLTD = MySqlHelperNEw.ExecuteNonQuery(tnx, CommandType.Text, strLTD);
                    if (ResultLTD < 1)
                    {
                        tnx.Rollback();
                        tnx.Dispose();
                        con.Close();
                        con.Dispose();
                        return "0";
                    }
                }
                else if (billDetail[i].IsNewItem == "1")
                {
                    LedgerTnxDetail objLTDetail = new LedgerTnxDetail(tnx);
                    objLTDetail.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
                    objLTDetail.LedgerTransactionNo = LedgertransactionNo;
                    objLTDetail.ItemID = Util.GetString(billDetail[i].ItemID);
                    objLTDetail.DiscountPercentage = 0;

                    objLTDetail.TransactionID = TransactionID.Trim();
                    objLTDetail.Rate = Util.GetDecimal(billDetail[i].Rate);
                    objLTDetail.Quantity = Util.GetDecimal(billDetail[i].Quantity);
                    objLTDetail.StockID = Util.GetString(billDetail[i].StockID);
                    objLTDetail.Amount = (Util.GetDecimal(billDetail[i].Rate)) * (Util.GetDecimal(billDetail[i].Quantity));
                    objLTDetail.ItemName = Util.GetString(billDetail[i].ItemName);
                    objLTDetail.UserID = HttpContext.Current.Session["ID"].ToString();
                    objLTDetail.SubCategoryID = Util.GetString(billDetail[i].SubCategoryID);
                    objLTDetail.IsVerified = 1;
                    objLTDetail.ToBeBilled = 1;
                    objLTDetail.TnxTypeID = 3;
                    objLTDetail.Type_ID = Util.GetString(billDetail[i].Type_ID);
                    objLTDetail.IsReusable = Util.GetString(billDetail[i].IsUsable);
                    objLTDetail.ServiceItemID = Util.GetString(billDetail[i].ServiceItemID);
                    objLTDetail.DoctorID = Util.GetString(billDetail[i].DoctorID);
                    objLTDetail.DiscountPercentage = 0;
                    objLTDetail.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(billDetail[i].SubCategoryID),con));
                    objLTDetail.AfterBill = Util.GetInt(1);
                    objLTDetail.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                    objLTDetail.pageURL = All_LoadData.getCurrentPageName();
                    objLTDetail.IpAddress = All_LoadData.IpAddress();
                    //////////////////////
                    objLTDetail.EntryDate = Util.GetDateTime(Util.GetDateTime(billDetail[i].EntryDate).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(BillTime).ToString("HH:mm:ss"));
                    //////////////////////
                    ID = Util.GetString(objLTDetail.Insert());

                    if (Util.GetInt(ID) < 1)
                    {
                        tnx.Rollback();
                        tnx.Dispose();
                        con.Close();
                        con.Dispose();
                        return string.Empty;
                    }
                }

                if (selectedLTDID != "")
                {
                    selectedLTDID += ",'" + ID + "'";
                }
                else
                {
                    selectedLTDID = "'" + ID + "'";
                }
            }
            if (selectedLTDID != "")
                MySqlHelperNEw.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_ledgertnxdetail SET IsVerified=2 WHERE LedgertransactionNo='" + LedgertransactionNo + "' AND ID Not IN (" + selectedLTDID + ") ");

            int ResultLT = MySqlHelperNEw.ExecuteNonQuery(tnx, CommandType.Text, "CALL updatePharmacyBillDetail('" + LedgertransactionNo + "','" + Util.GetDateTime(BillDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(BillTime).ToString("HH:mm:ss") + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + HttpContext.Current.Request.UserHostAddress + "')");
            if (ResultLT < 1)
            {
                tnx.Rollback();
                tnx.Dispose();
                con.Close();
                con.Dispose();
                return "0";
            }
            // if (billDetail[0].nonSelectedLTDID != "")
            // MySqlHelperNEw.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_ledgertnxdetail SET IsVerified=2 WHERE LedgertransactionNo='" + LedgertransactionNo + "' AND ID IN (" + billDetail[0].nonSelectedLTDID + ") ");

            tnx.Commit();
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

    public class patientEditBill
    {
        public string ItemID { get; set; }
        public string StockID { get; set; }
        public string SubCategoryID { get; set; }
        public string ItemName { get; set; }
        public string Quantity { get; set; }
        public string Rate { get; set; }
        public string ActualQty { get; set; }
        public string IsNewItem { get; set; }
        public string IsAlreadyExist { get; set; }
        public string MedExpiryDate { get; set; }
        public string BillNo { get; set; }
        public string BillDate { get; set; }
        public string BatchNo { get; set; }
        public string LedgertransactionNo { get; set; }
        public string Type_ID { get; set; }
        public string IsUsable { get; set; }
        public string ServiceItemID { get; set; }
        public string DoctorID { get; set; }
        public string LTDID { get; set; }
        public string nonSelectedLTDID { get; set; }

        //////////////////////
        public string EntryDate { get; set; }

        //////////////////////
    }

    [WebMethod(EnableSession = true)]
    public static string replaceMedicine(string LedgertransactionNo, string TransactionID, string BillNo, string BillDate, string From, string To, string BillItem, string ReplaceItem)
    {
        DataTable dt;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT t1.*,t2.tax FROM(SELECT ST.StockID,ST.ItemID ,ST.ItemName,ST.BatchNumber,ST.SubCategoryID,ST.UnitPrice,ST.MRP LRate,DATE_FORMAT(ST.MedExpiryDate,'%d-%b-%y')MedExpiryDate, ");
            sb.Append(" (ST.InitialCount-ST.ReleasedCount)availQty,'1' IsNewItem,'1' isAlreadyExist,'" + BillNo + "' BillNo,'" + BillDate + "' Date,im.Type_ID,im.IsUsable,im.ServiceItemID  FROM f_stock ST INNER JOIN f_itemmaster IM ON ST.ItemID=IM.ItemID  WHERE ST.ItemID='" + ReplaceItem + "' AND (InitialCount-ReleasedCount)>0 AND ");
            sb.Append(" IsPost=1 ORDER BY DATE(MedExpiryDate)+0)t1 LEFT JOIN (SELECT SUM(tc.perCentage)Tax,tc.StockID ");
            sb.Append(" FROM f_taxchargedlist tc WHERE tc.ItemID = '" + ReplaceItem + "'  GROUP BY tc.stockid)T2 ");
            sb.Append(" ON t1.stockid = t2.stockid");
            //AND MedExpiryDate>CURDATE()
            dt = StockReports.GetDataTable(sb.ToString());

            string strLTD = " update f_ledgertnxdetail set ItemID='" + Util.GetString(dt.Rows[0]["ItemID"]) + "',ItemName='" + Util.GetString(dt.Rows[0]["ItemName"]) + "', Rate=" + Util.GetDecimal(dt.Rows[0]["LRate"].ToString()) + ", " +
                 " Amount=(Quantity*" + Util.GetDecimal(dt.Rows[0]["LRate"].ToString()) + "),UpdateDate=now() " + ",StockID=" + Util.GetInt(dt.Rows[0]["StockID"].ToString()) + ",SubCategoryID='" + Util.GetString(dt.Rows[0]["SubCategoryID"].ToString()) + "'" +
                 " where LedgertransactionNo='" + LedgertransactionNo + "' and ItemID='" + BillItem + "' and Date(EntryDate)>='" + Util.GetDateTime(From).ToString("yyyy-MM-dd") + "' and Date(EntryDate)<='" + Util.GetDateTime(To).ToString("yyyy-MM-dd") + "'";
            int ResultLTD = MySqlHelperNEw.ExecuteNonQuery(tnx, CommandType.Text, strLTD);
            if (ResultLTD < 1)
            {
                tnx.Rollback();
                tnx.Dispose();
                con.Close();
                con.Dispose();
                return "0";
            }
            else
            {
                int ResultLT = MySqlHelperNEw.ExecuteNonQuery(tnx, CommandType.Text, "CALL updatePharmacyBillDetail('" + LedgertransactionNo + "','" + Util.GetDateTime(BillDate).ToString("yyyy-MM-dd") + "','" + DateTime.Now.ToString("HH:mm:ss") + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + HttpContext.Current.Request.UserHostAddress + "')");
                if (ResultLT < 1)
                {
                    tnx.Rollback();
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();
                    return "0";
                }
            }

            tnx.Commit();
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
}