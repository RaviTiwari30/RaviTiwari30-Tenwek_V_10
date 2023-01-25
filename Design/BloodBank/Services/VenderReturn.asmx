<%@ WebService Language="C#" Class="VenderReturn" %>

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
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.ComponentModel.ToolboxItem(false)]
[System.Web.Script.Services.ScriptService]
public class VenderReturn : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string BloodHistory(string ComponentID)
    {

        StringBuilder sb = new StringBuilder();

        sb.Append("  SELECT sm.id,sm.stock_ID,cm.componentname,sm.componentid,(sm.InitialCount-sm.ReleaseCount)InitialCount, ");
        sb.Append("  sm.bagtype,sm.BloodCollection_Id,sm.BBTubeNo,DATE_FORMAT(sm.ExpiryDate,'%d-%b-%Y')ExpiryDate,");
        sb.Append("  sm.BloodGroup,DATE_FORMAT(sm.EntryDate,'%d-%b-%Y')EntryDate FROM bb_stock_master sm ");
        sb.Append("  INNER JOIN  bb_component_master cm ON cm.Id=sm.componentid ");
        sb.Append("  WHERE sm.IsActive=1   AND sm.InitialCount>sm.ReleaseCount  ");
        sb.Append("  AND sm.status=1 AND sm.IsDispatch=0 AND sm.IsDiscarded=0 AND sm.IsHold=0 AND sm.IsVenderReturn=0 AND sm.BloodCollection_Id<>'' and sm.CentreID = " + Util.GetInt(Session["CentreID"].ToString()) + " ");
        if (ComponentID != "0")
        {
            sb.Append(" AND sm.componentid='" + ComponentID + "'");
        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);


        }
        else
        {
            return "";
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SaveVenderReturn(List<Marker> Data)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            BloodVenderReturn Bvr = new BloodVenderReturn();
            Bvr.StockID = Data[0].StockID;
            Bvr.BloodCollection_ID = Data[0].BloodCollectionId;
            Bvr.ComponentID = Data[0].ComponentID;
            Bvr.ComponentName = Data[0].ComponentName;
            Bvr.BBTubeNo = Data[0].TubeNo;
            Bvr.EntryBy = HttpContext.Current.Session["ID"].ToString();
            Bvr.Reason = Data[0].Reason;
            Bvr.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            string ReturnID = Bvr.Insert();
            if (ReturnID == "")
            {
                tnx.Rollback();

            }
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update bb_stock_master SET ISVenderReturn=1,ReleaseCount=InitialCount where Stock_Id='" + Data[0].StockID + "'");

            if (Resources.Resource.AllowFiananceIntegration == "1")
            {
                string IsIntegrated = Util.GetString(EbizFrame.InsertBloodBankPurchase(Util.GetString(ReturnID), 2, tnx));
                if (IsIntegrated == "0")
                {
                    tnx.Rollback();
                }
            }

            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }


    }

    public class Marker
    {

        public string StockID { get; set; }
        public int ComponentID { get; set; }
        public string BloodCollectionId { get; set; }
        public string ComponentName { get; set; }
        public string TubeNo { get; set; }
        public string Reason { get; set; }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string BloodReturnSearch(string IPDNo, String RegNo, String PName, String FromDate, String ToDate, string PatientType)//
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT pm.PName,issue_id,Issuevolumn,bbi.PatientID MRNo,REPLACE(IF(pmh.TYPE='IPD',pmh.TransNo,''),'ISHHI','')IPDNo,pmh.TYPE,bbi.TransactionID,LedgerTransactionNo,Stock_ID,bbi.BBTubeNo, ");
        sb.Append("   (SELECT ComponentName FROM bb_component_master WHERE ID=bbi.ComponentId AND  active=1)Component, ");
        sb.Append(" ComponentId,(SELECT TypeNAme FROM f_itemmaster WHERE itemid=bbi.itemid AND isactive=1)ItemName ");
        sb.Append(" ,itemid,bbi.LedgerTnxID,DATE_FORMAT(bbi.Expiry,'%d-%b-%Y')Expiry FROM  ");
        sb.Append(" bb_issue_blood bbi INNER JOIN patient_master pm ON pm.PatientID=bbi.PatientID  INNER JOIN patient_medical_history pmh ON pmh.PatientID=pm.PatientID    ");
        sb.Append(" WHERE bbi.isreturn=0 AND bbi.isactive=1   AND bbi.Expiry >=CURDATE() AND bbi.isHold=0 and bbi.centreId='" + HttpContext.Current.Session["CentreID"].ToString() + "'");
        if (IPDNo != "")
        {
           // sb.Append(" AND TransactionID='" + IPDNo + "' ");//ISHHI
            sb.Append(" AND pmh.TransNo=" + IPDNo + " AND pmh.TYPE='IPD' ");
        }
        if (RegNo != "")
        {
            sb.Append(" AND pm.PatientID='" + RegNo + "' ");
        }
        if (PName != "")
        {
            sb.Append(" AND pm.pname like '" + PName + "%' ");
        }
        if (PatientType != "All")
        {
            sb.Append(" AND bbi.Type='" + PatientType + "'");
        }
        if (IPDNo == "" && RegNo == "" && PName == "")
        {
            if (FromDate != "")
            {
                sb.Append(" AND DATE(IssuedDate) >='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' ");
            }
            if (ToDate != "")
            {
                sb.Append(" and DATE(IssuedDate) <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' ");
            }
        }

        sb.Append(" GROUP BY pmh.`PatientID` ");
        
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);


        }
        else
        {
            return "";
        }




    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SaveBloodReturn(List<Return> Data)
    {
        //if (AllLoadData_IPD.CheckBillGenerate(Data[0].TransactionID, "IPD") > 0 && Data[0].TransactionID.Contains("ISHHI"))
        //{
        //    return "3";
        //}
        //else {
        //    //if (AllLoadData_IPD.CheckBillGenerate(Data[0].TransactionID, "EMG") > 0)
        //     //   return "3";
        //}
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            string up1 = "UPDATE bb_issue_blood SET Isreturn=1 where issue_id='" + Data[0].IssueID + "' ";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, up1);

            string up2 = "UPDATE bb_stock_master SET ReleaseCount=ReleaseCount-'" + Data[0].Issuevolumn + "' where Stock_Id='" + Data[0].StockID + "' ";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, up2);

            //string up3 = "UPDATE f_ledgertnxdetail SET BloodIssue=1,IsVerified=2  WHERE itemid='" + ((Label)gr.FindControl("lblitemid")).Text.ToString() + "' AND LedgerTransactionNo='" + ((Label)gr.FindControl("lblLedgerTransactionNo")).Text.ToString() + "' ";
            //MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, up3);

           // string str = "select ltd.*,lt.PanelID from f_ledgertnxdetail ltd inner join f_ledgertransaction lt on ltd.ledgertransactionno=lt.ledgertransactionno where LedgerTnxID='" + Data[0].LedgerTnxID + "' ";
          //  DataTable dt = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, str).Tables[0];

            string PatientType = StockReports.ExecuteScalar("Select PMH.TYPE from patient_medical_history pmh where pmh.TransactionID='" + Data[0].TransactionID + "'");//Patient_Type

           //  var isBillGenereted = AllLoadData_IPD.CheckBillGenerate(Data[0].TransactionID, PatientType);

            //if (isBillGenereted > 0)
            //{
            //    Tranx.Rollback();
            //    return "5";
            //}

            string str = "select ltd.*,lt.PanelID from f_ledgertnxdetail ltd inner join f_ledgertransaction lt on ltd.ledgertransactionno=lt.ledgertransactionno where ltd.LedgerTransactionNo='" + Data[0].LedgerTnxID + "' AND ltd.ItemID='" + Data[0].ItemID + "' ";
            DataTable dt = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, str).Tables[0];

            string TypeOfTnx = "";
            if (PatientType == "OPD")
            {
                TypeOfTnx = "OPD-BILLING";
            }
            else if (PatientType=="IPD") 
            {
                TypeOfTnx = "IPD-Billing";
            }
            

            decimal rate = Util.GetDecimal(dt.Rows[0]["Rate"]);
            decimal discountAmount = 0;
            decimal discountPercent = Util.GetDecimal(dt.Rows[0]["DiscountPercentage"]);
            decimal grossAmount = (rate * 1);

            if (discountPercent > 0)
                discountAmount = (grossAmount * discountPercent) / 100;


            decimal netAmount = Util.round(grossAmount - discountAmount);



            string LedTxnID = string.Empty;
            if (Data[0].Type != "EMG")
            {
                string Chk1 = "SELECT COUNT(*) AS jj FROM f_ledgermaster WHERE LedgerUserID = '" + Data[0].PatientId + "' ";
                string Chk2 = "SELECT COUNT(*) AS jj FROM f_ledgermaster WHERE LedgerUserID = '" + HttpContext.Current.Session["HOSPID"].ToString() + "'";
                int chkledgernocr = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, Chk1));
                int chkledgernodr = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, Chk2));
                string ledgernocr = "", ledgernodr = "";
                if (chkledgernocr > 0)
                {
                    ledgernocr = AllQuery.GetLedgerNoByLedgerUserID(Data[0].PatientId, con); 
                }
                if (chkledgernodr > 0)
                {
                    ledgernodr = AllQuery.GetLedgerNoByLedgerUserID(HttpContext.Current.Session["HOSPID"].ToString(), con);
                }
                Ledger_Transaction objLedTran = new Ledger_Transaction(Tranx);
                objLedTran.LedgerNoCr = ledgernocr;// AllQuery.GetLedgerNoByLedgerUserID(Data[0].PatientId, con);
                objLedTran.LedgerNoDr = ledgernodr;//AllQuery.GetLedgerNoByLedgerUserID(HttpContext.Current.Session["HOSPID"].ToString(), con);
                objLedTran.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                objLedTran.TypeOfTnx = TypeOfTnx;
                objLedTran.Date = Util.GetDateTime(System.DateTime.Now);
                objLedTran.Time = Util.GetDateTime(System.DateTime.Now);
                objLedTran.AgainstPONo = "";
                objLedTran.BillNo = "";
                objLedTran.DiscountOnTotal = Util.GetDecimal(discountAmount);
                objLedTran.GrossAmount = Util.GetDecimal(grossAmount);
                objLedTran.NetAmount = Util.GetDecimal(netAmount);
                objLedTran.IsCancel = 0;
                objLedTran.CancelReason = "";
                objLedTran.CancelAgainstLedgerNo = "";
                objLedTran.CancelDate = Util.GetDateTime(DateTime.Now.ToShortDateString());
                objLedTran.UserID = HttpContext.Current.Session["ID"].ToString();
                objLedTran.PatientID = Data[0].PatientId;
                objLedTran.TransactionID = Data[0].TransactionID;
                objLedTran.PanelID = Util.GetInt(dt.Rows[0]["PanelID"]);
                objLedTran.UniqueHash = Util.getHash();
                objLedTran.IpAddress = HttpContext.Current.Request.UserHostAddress;
                objLedTran.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                objLedTran.PatientType = PatientType;
                LedTxnID = objLedTran.Insert().ToString();
            }
            LedgerTnxDetail tnxdtl = new LedgerTnxDetail(Tranx);


            tnxdtl.Location = Util.GetString(dt.Rows[0]["Location"]);
            tnxdtl.HospCode = Util.GetString(dt.Rows[0]["HospCode"]);
            tnxdtl.Hospital_Id = Util.GetString(dt.Rows[0]["Hospital_Id"]);
            if (Data[0].Type != "EMG")
            {
                tnxdtl.LedgerTransactionNo = LedTxnID;
            }
            else
            {
                tnxdtl.LedgerTransactionNo = Util.GetString(dt.Rows[0]["LedgerTransactionNo"]);
            }
            tnxdtl.Amount = Util.GetDecimal(netAmount) * -1;
            tnxdtl.ItemID = Util.GetString(dt.Rows[0]["ItemID"]);
            tnxdtl.Rate = Util.GetDecimal(dt.Rows[0]["Rate"]) * 1;
            tnxdtl.Quantity = -1;
            tnxdtl.StockID = Util.GetString(dt.Rows[0]["StockID"]);
            tnxdtl.IsTaxable = Util.GetString(dt.Rows[0]["IsTaxable"]);
            tnxdtl.DiscountPercentage = Util.GetDecimal(dt.Rows[0]["DiscountPercentage"]);
            tnxdtl.IsPackage = Util.GetInt(dt.Rows[0]["IsPackage"]);
            tnxdtl.PackageID = Util.GetString(dt.Rows[0]["PackageID"]);
            tnxdtl.IsVerified = Util.GetInt(dt.Rows[0]["IsVerified"]);
            tnxdtl.SubCategoryID = Util.GetString(dt.Rows[0]["SubCategoryID"]);
            tnxdtl.VarifiedUserID = Util.GetString(dt.Rows[0]["VarifiedUserID"]);
            tnxdtl.ItemName = Util.GetString(dt.Rows[0]["ItemName"]);
            tnxdtl.TransactionID = Util.GetString(dt.Rows[0]["TransactionID"]);
            tnxdtl.VerifiedDate = Util.GetDateTime(dt.Rows[0]["VerifiedDate"]);
            tnxdtl.UserID = Util.GetString(Session["ID"]);
            tnxdtl.EntryDate = Util.GetDateTime(dt.Rows[0]["EntryDate"]);
            tnxdtl.IsFree = Util.GetInt(dt.Rows[0]["IsFree"]);
            tnxdtl.IsSurgery = Util.GetInt(dt.Rows[0]["IsSurgery"]);
            tnxdtl.SurgeryID = Util.GetString(dt.Rows[0]["SurgeryID"]);
            tnxdtl.SurgeryName = Util.GetString(dt.Rows[0]["SurgeryName"]);
            tnxdtl.DoctorID = Util.GetString(dt.Rows[0]["DiscountReason"]);
            //tnxdtl.DoctorCharges = Util.GetDecimal(dt.Rows[0]["DiscAmt"]);
            tnxdtl.TnxTypeID = Util.GetInt(dt.Rows[0]["TnxTypeID"]);
            tnxdtl.DiscAmt = Util.GetDecimal(discountAmount);
            tnxdtl.DiscountPercentage = Util.GetDecimal(discountPercent);
            tnxdtl.IsMedService = Util.GetInt(dt.Rows[0]["IsMedService"]);
            tnxdtl.LastUpdatedBy = Util.GetString(dt.Rows[0]["LastUpdatedBy"]);
            tnxdtl.UpdatedDate = Util.GetDateTime(dt.Rows[0]["Updatedate"]);
            //tnxdtl.IpAddress = Util.GetString(dt.Rows[0]["IpAddress"]);
            tnxdtl.ToBeBilled = Util.GetInt(dt.Rows[0]["ToBeBilled"]);
            tnxdtl.IsReusable = Util.GetString(dt.Rows[0]["IsReusable"]);
            tnxdtl.Type_ID = Util.GetString(dt.Rows[0]["Type_ID"]);
            tnxdtl.ConfigID = Util.GetInt(dt.Rows[0]["ConfigID"]);
            tnxdtl.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
            tnxdtl.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            tnxdtl.DoctorID = Util.GetString(dt.Rows[0]["DoctorID"]);
            tnxdtl.NetItemAmt = Util.GetDecimal(netAmount) * -1;
            tnxdtl.IpAddress = All_LoadData.IpAddress();
            tnxdtl.pageURL = All_LoadData.getCurrentPageName();
            tnxdtl.RateListID = Util.GetInt(dt.Rows[0]["RateListID"]);
            tnxdtl.Type = Util.GetString(dt.Rows[0]["Type"]);
            tnxdtl.typeOfTnx = Util.GetString(dt.Rows[0]["TypeOfTnx"]);

            int newLedgerTnxID = tnxdtl.Insert();

            BloodReturn Br = new BloodReturn(Tranx);
            Br.IssueId = Data[0].IssueID;
            Br.ComponentID = Util.GetInt(Data[0].ComponentID);
            Br.ComponentName = Data[0].ComponentName;
            Br.Stock_ID = Data[0].StockID;
            Br.PatientID = Data[0].PatientId;
            Br.TransactionID = Data[0].TransactionID;
            Br.CentreId = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            Br.ItemID = Data[0].ItemID;
            Br.ReturnVolumn = Util.GetDecimal(Data[0].Issuevolumn);
            Br.ReturnBy = HttpContext.Current.Session["ID"].ToString();
            Br.BBTubeNo = Data[0].BBTubeNo;
            if (Data[0].Type != "EMG")
            {
                Br.LedgerTransactionNo = LedTxnID;
            }
            else
            {
                Br.LedgerTransactionNo = Util.GetString(dt.Rows[0]["LedgerTransactionNo"]);
            }
            Br.LedgerTnxID = "LSHHI" + newLedgerTnxID;
            string Bloodreturn = Br.Insert();



            if (newLedgerTnxID != 0 && Bloodreturn != "")
            {
                if (Data[0].Type == "EMG")
                {
                    if (Resources.Resource.AllowFiananceIntegration == "1")
                    {
                        string IsIntegrated = Util.GetString(EbizFrame.InsertEmergencyTransaction(Util.GetInt(dt.Rows[0]["LedgerTransactionNo"]), "", "R", Util.GetString(newLedgerTnxID), Tranx));
                        if (IsIntegrated == "0")
                        {
                            Tranx.Rollback();
                            return "2";
                        }
                        IsIntegrated = Util.GetString(EbizFrame.InsertInventoryTransaction(newLedgerTnxID, 0, 21, 0, Tranx));
                        if (IsIntegrated == "0")
                        {
                            Tranx.Rollback();
                            return "2";
                        }
                    }
                }
                else if (Data[0].Type == "IPD")
                {
                    if (Resources.Resource.AllowFiananceIntegration == "1")
                    {
                        string IsIntegrated = Util.GetString(EbizFrame.InsertIPDTransaction(Util.GetInt(LedTxnID), "", "R", Tranx));
                        if (IsIntegrated == "0")
                        {
                            Tranx.Rollback();
                            return "2";
                        }
                        IsIntegrated = Util.GetString(EbizFrame.InsertInventoryTransaction(Util.GetInt(LedTxnID), 0, 23, 0, Tranx));
                        if (IsIntegrated == "0")
                        {
                            Tranx.Rollback();
                            return "2";
                        }
                    }
                }
                else if (Data[0].Type == "OPD")
                {
                    if (Resources.Resource.AllowFiananceIntegration == "1")
                    {
                        string IsIntegrated = Util.GetString(EbizFrame.InsertOPDTransaction(Util.GetInt(LedTxnID), "", "R", Tranx));
                        if (IsIntegrated == "0")
                        {
                            Tranx.Rollback();
                            return "2";
                        }
                        IsIntegrated = Util.GetString(EbizFrame.InsertInventoryTransaction(Util.GetInt(LedTxnID), 0, 25, 0, Tranx));
                        if (IsIntegrated == "0")
                        {
                            Tranx.Rollback();
                            return "2";
                        }
                    }
                }
                Tranx.Commit();
                return "1";

            }
            else
            {
                return "0";
            }

        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";

        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }


    }

    public class Return
    {

        public string IssueID { get; set; }
        public string Issuevolumn { get; set; }
        public string LedgerTnxID { get; set; }
        public string StockID { get; set; }
        public int ComponentID { get; set; }
        public string ComponentName { get; set; }
        public string PatientId { get; set; }
        public string TransactionID { get; set; }
        public string ItemID { get; set; }
        public string BBTubeNo { get; set; }
        public string LedgerTransactionNo { get; set; }
        public string Type { get; set; }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SaveBloodHold(List<HoldBlood> Data)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string up1 = "UPDATE bb_issue_blood SET IsHold=1 ,HoldBy='" + HttpContext.Current.Session["ID"].ToString() + "',HoldDate=now() where issue_id='" + Data[0].IssueID + "' ";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, up1);

            string up2 = "UPDATE bb_stock_master SET IsHold=1 ,HoldBy='" + HttpContext.Current.Session["ID"].ToString() + "',HoldDate=now() where Stock_Id='" + Data[0].StockID + "' ";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, up2);
            Tranx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
            ;
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    public class HoldBlood
    {

        public string IssueID { get; set; }
        public string StockID { get; set; }
    }
}