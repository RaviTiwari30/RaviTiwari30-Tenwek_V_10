<%@ WebService Language="C#" Class="CardRegistration" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script;
using System.Data;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Text;
using MySql.Data.MySqlClient;
using System.Collections.Generic;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.ComponentModel.ToolboxItem(false)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
 [System.Web.Script.Services.ScriptService]
public class CardRegistration : System.Web.Services.WebService
{
    GetEncounterNo Encounter = new GetEncounterNo();
    int EncounterNo = 0;
    
    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string OPDCardRegistration(List<OPDCard> Data)
    {
        int len = Data.Count;
        if (len > 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction();
            try
            {
              string  HospitalID = HttpContext.Current.Session["HOSPID"].ToString();
                string PatientID = "";

                Patient_Master pm = new Patient_Master(tranX);
                pm.Title = Data[0].Title;
                pm.PFirstName = Data[0].PFName;
                pm.PLastName = Data[0].PLName;
                pm.PName = Data[0].PFName + " " + Data[0].PLName;
                if (Data[0].Age != "")
                    pm.Age = Util.GetString(Data[0].Age);
                else
                {
                    pm.DOB = Util.GetDateTime(Data[0].DOB);
                    pm.Age = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT Get_Age('" + Data[0].DOB.ToString("yyyy-MM-dd") + "')"));
                }
                pm.MaritalStatus = Util.GetString(Data[0].MaritalStatus);
                pm.House_No = Data[0].Address;
                pm.Email = Util.GetString(Data[0].Email);
                pm.ResidentialAddress = Data[0].Address;
                pm.Mobile = Data[0].Mobile;
                pm.Gender = Data[0].Gender;
                pm.Country = Data[0].Country;
                pm.City = Data[0].City;
                pm.DateEnrolled = Util.GetDateTime(DateTime.Now);
                pm.RegisterBy = HttpContext.Current.Session["ID"].ToString();
                pm.Card_ID = Data[0].Card_ID;
                pm.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                pm.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                pm.IPAddress = All_LoadData.IpAddress();
                PatientID = pm.Insert();
                if (PatientID == "")
                {
                    tranX.Rollback();
                    return "";
                }
                Patient_Medical_History newpmh = new Patient_Medical_History(tranX);
                newpmh.PatientID = PatientID;
                newpmh.DoctorID = Data[0].DoctorID;
                newpmh.Hospital_ID = HospitalID;
                newpmh.Time = Util.GetDateTime(DateTime.Now.ToString("hh:mm:ss"));
                newpmh.DateOfVisit = Util.GetDateTime(DateTime.Now);
                newpmh.Type = "OPD";
                newpmh.PanelID = Data[0].PanelID;
                newpmh.HashCode = Data[0].HashCode;
                newpmh.Source = "Card Registration";
                newpmh.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                newpmh.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                string TID = newpmh.Insert();
                if (TID == "")
                {
                    tranX.Rollback();
                    return "";
                }
                EncounterNo = Encounter.FindEncounterNo(PatientID);
                if (EncounterNo == 0)
                {
                    tranX.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Encounter No." });

                }
                
                Ledger_Transaction ObjLdgTnx = new Ledger_Transaction(tranX);
               
                ObjLdgTnx.Hospital_ID = HospitalID;
                string a = AllQuery.GetLedgerNoByLedgerUserID(PatientID, "PTNT", con);
                if (a == null)
                {
                    ObjLdgTnx.LedgerNoCr = "";
                }
                ObjLdgTnx.LedgerNoDr = AllQuery.GetLedgerNoByLedgerUserID(HospitalID, "HOSP", con);
                ObjLdgTnx.TypeOfTnx = "OPD-OTHERS";
                ObjLdgTnx.Date = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                ObjLdgTnx.Time = Util.GetDateTime(DateTime.Now.ToString("HH:mm:ss"));
                ObjLdgTnx.NetAmount = Data[0].NetAmount;
                ObjLdgTnx.GrossAmount = Data[0].TotalGrossAmt;
                ObjLdgTnx.Adjustment = Data[0].AmountPaid;
                ObjLdgTnx.PatientID = PatientID;
                ObjLdgTnx.PanelID = Data[0].PanelID;
                ObjLdgTnx.TransactionID = TID;
                ObjLdgTnx.UserID = HttpContext.Current.Session["ID"].ToString();
                ObjLdgTnx.DiscountReason = Data[0].DiscountReason;
                ObjLdgTnx.DiscountApproveBy = Data[0].DiscountApproveBy;
                ObjLdgTnx.DiscountOnTotal = Data[0].DisAmount;
                ObjLdgTnx.BillNo = SalesEntry.genBillNo(tranX, Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()),con);
                ObjLdgTnx.BillDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                ObjLdgTnx.RoundOff = Data[0].RoundOff;
                ObjLdgTnx.PaymentModeID = Data[0].PaymentModeID;
                ObjLdgTnx.UniqueHash = Util.getHash();
                ObjLdgTnx.IpAddress = All_LoadData.IpAddress();
                ObjLdgTnx.GovTaxPer = Util.GetDecimal("0.00");
                ObjLdgTnx.GovTaxAmount = Data[0].GovTaxAmt;
                if (Data[0].PaymentMode != "Credit")
                    ObjLdgTnx.IsPaid = 1;
                else
                    ObjLdgTnx.IsPaid = 0;
                ObjLdgTnx.IsCancel = 0;
                ObjLdgTnx.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                ObjLdgTnx.CurrentAge = pm.Age;
                ObjLdgTnx.EncounterNo = Util.GetInt(EncounterNo);             
           
                string LedgerTransactionNo = ObjLdgTnx.Insert();

                if (LedgerTransactionNo == "")
                    {
                    tranX.Rollback();
                    return "";
                    }
                LedgerTnxDetail ObjLdgTnxDtl = new LedgerTnxDetail(tranX);
                ObjLdgTnxDtl.Hospital_Id = HospitalID;
                ObjLdgTnxDtl.LedgerTransactionNo = LedgerTransactionNo;
                ObjLdgTnxDtl.ItemID = Data[0].ItemID;
                ObjLdgTnxDtl.Rate = Data[0].TotalGrossAmt;
                ObjLdgTnxDtl.Quantity = 1;
                ObjLdgTnxDtl.StockID = "";
                ObjLdgTnxDtl.IsTaxable = "NO";
                ObjLdgTnxDtl.Amount = Data[0].NetAmount;
                ObjLdgTnxDtl.DiscountPercentage = Data[0].DisPercent;
                ObjLdgTnxDtl.DiscAmt = Data[0].DisAmount;
                ObjLdgTnxDtl.IsPackage = 0;
                ObjLdgTnxDtl.PackageID = "";
                ObjLdgTnxDtl.IsVerified = 1;
                ObjLdgTnxDtl.TransactionID = TID;
                ObjLdgTnxDtl.SubCategoryID = Data[0].subcategoryid;
                ObjLdgTnxDtl.ItemName = Data[0].ItemName;
                ObjLdgTnxDtl.UserID = HttpContext.Current.Session["ID"].ToString();
                ObjLdgTnxDtl.EntryDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                ObjLdgTnxDtl.DiscountReason = Data[0].DiscountReason;

                ObjLdgTnxDtl.DoctorID = Data[0].DoctorID;
                ObjLdgTnxDtl.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(Data[0].subcategoryid),con));
                ObjLdgTnxDtl.NetItemAmt = ObjLdgTnxDtl.Amount;
                ObjLdgTnxDtl.TotalDiscAmt = Util.GetDecimal(Data[0].DisAmount);
                ObjLdgTnxDtl.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                ObjLdgTnxDtl.pageURL = All_LoadData.getCurrentPageName();
                ObjLdgTnxDtl.Type = "O";
                ObjLdgTnxDtl.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                ObjLdgTnxDtl.IpAddress = All_LoadData.IpAddress();
                string LdgTnxDtlID = ObjLdgTnxDtl.Insert().ToString();

                if (LdgTnxDtlID == "")
                    {
                    tranX.Rollback();
                    return "";
                    }
               

                ////////////////////////////// Insert in Receipt ///////////////////
                string ReceiptNo = "";
                if (Data[0].PaymentMode != "Credit")
                {
                    Receipt ObjReceipt = new Receipt(tranX);
                    ObjReceipt.Hospital_ID = HospitalID;
                    ObjReceipt.AmountPaid = Data[0].AmountPaid;
                    ObjReceipt.AsainstLedgerTnxNo = LedgerTransactionNo;
                    ObjReceipt.Date = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                    ObjReceipt.Time = Util.GetDateTime(DateTime.Now.ToString("hh:mm:ss"));
                    ObjReceipt.Discount = 0;
                    ObjReceipt.PanelID = Data[0].PanelID;
                    ObjReceipt.Reciever = HttpContext.Current.Session["ID"].ToString();
                    ObjReceipt.Depositor = PatientID;
                    ObjReceipt.TransactionID = TID;
                    ObjReceipt.Naration = Data[0].Narration;
                    ObjReceipt.RoundOff = Data[0].RoundOff;
                    ObjReceipt.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    ObjReceipt.IpAddress = All_LoadData.IpAddress();
                    ReceiptNo = ObjReceipt.Insert();
                    if (ReceiptNo == "")
                        {
                        tranX.Rollback();
                        return "";
                        }
                    Receipt_PaymentDetail ObjReceiptPayment = new Receipt_PaymentDetail(tranX);
                    for (int i = 0; i < Data.Count; i++)
                    {
                        ObjReceiptPayment.PaymentModeID = Data[i].PaymentModeID;
                        ObjReceiptPayment.PaymentMode = Data[i].PaymentMode;
                        ObjReceiptPayment.Amount = Data[i].BaseCurrency; 
                        ObjReceiptPayment.ReceiptNo = ReceiptNo;
                        ObjReceiptPayment.PaymentRemarks = Data[i].Narration;
                        ObjReceiptPayment.RefDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                        ObjReceiptPayment.RefNo = Data[i].RefNo;
                        ObjReceiptPayment.BankName = Data[i].BankName;
                        ObjReceiptPayment.C_Factor = Data[i].CFactor;
                        ObjReceiptPayment.S_Amount = Data[i].PaidAmount;
                        ObjReceiptPayment.S_CountryID = Data[i].CountryID;
                        ObjReceiptPayment.S_Currency = Data[i].Currency;
                        ObjReceiptPayment.S_Notation = Data[i].Notation;
                        ObjReceiptPayment.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                        ObjReceiptPayment.Hospital_ID = Util.GetString(HttpContext.Current.Session["HOSPID"].ToString());
                        string PaymentID = ObjReceiptPayment.Insert().ToString();
                        if (PaymentID == "")
                            {
                            tranX.Rollback();
                            return "";
                            }
                    }
                }
                                           
                tranX.Commit();
                return LedgerTransactionNo+"#"+PatientID;
            }

            catch (Exception ex)
            {

                tranX.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return "";
            }
            finally
            {
                tranX.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        else
        {
            return "0";
        }
    }

    public class OPDCard
    {
        public string Title { get; set; }
        public string PFName { get; set; }
        public string PLName { get; set; }
        public string PName { get; set; }
        public DateTime DOB { get; set; }
        public string Age { get; set; }
        public string MaritalStatus { get; set; }
        public string Email { get; set; }
        public string Address { get; set; }
        public string Mobile { get; set; }
        public string Gender { get; set; }
        public string Country { get; set; }
        public string City { get; set; }
        public int Card_ID { get; set; }
        public string DoctorID { get; set; }
        public int PanelID { get; set; }
        public string ItemID { get; set; }
        public string ItemName { get; set; }
        public string HashCode { get; set; }
        public decimal TotalGrossAmt { get; set; }
        public decimal NetAmount { get; set; }
        public decimal AmountPaid { get; set; }
        public decimal DisAmount { get; set; }
        public decimal DisPercent { get; set; }
        public decimal RoundOff { get; set; }
        public string DiscountReason { get; set; }
        public string DiscountApproveBy { get; set; }
        public string Narration { get; set; }
        public string subcategoryid { get; set; }
        public decimal GovTaxPer  { get; set; }
        public decimal GovTaxAmt { get; set; }
        public string PaymentMode { get; set; }
        public int PaymentModeID { get; set; }
        public decimal PaidAmount { get; set; }
        public string Currency { get; set; }
        public int CountryID { get; set; }
        public string BankName { get; set; }
        public string RefNo { get; set; }
        public string BaceCurrency { get; set; }
        public decimal CFactor { get; set; }
        public decimal BaseCurrency { get; set; }
        public string Notation { get; set; }
        public virtual decimal currencyRoundOff { get; set; }
        public virtual string swipeMachine { get; set; }

    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string CardSubCategoryID(string ItemID)
    {
        string rtrn = "";
        StringBuilder sb=new StringBuilder();
        sb.Append("SELECT sc.SubCategoryID FROM f_itemmaster im INNER JOIN f_subcategorymaster sc ON ");
         sb.Append(" sc.SubCategoryID=im.SubCategoryID  INNER JOIN f_categorymaster cm ON sc.CategoryID=cm.CategoryID ");
        sb.Append(" INNER JOIN f_configrelation cr   ON cr.`CategoryID`=cm.CategoryID WHERE im.`ItemID`='"+ItemID+"' ");
        string str=StockReports.ExecuteScalar(sb.ToString());
        rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(str);
        return rtrn;
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string Registered(string PFirstName, string PlastName,string Mobile)
    {        
        int str = Util.GetInt( StockReports.ExecuteScalar("SELECT count(*) from patient_master where PFirstName='" + PFirstName + "'  and PLastName = '" + PlastName + "'  and Mobile='" + Mobile + "'"));
        return Newtonsoft.Json.JsonConvert.SerializeObject(str);
        
    }
    
    
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string Cash()
    {
        string retn = "";
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT cnm.S_CountryID,cnm.S_Currency,cnm.S_Notation,cnm.B_Currency,Selling_Specific ");
        sb.Append(" FROM country_master cm INNER JOIN converson_master cnm ON cm.CountryID = cnm.S_CountryID ");
        sb.Append("  WHERE cm.IsActive=1 AND cm.IsBaseCurrency=1 AND cnm.DATE=(SELECT ");
        sb.Append(" MAX(cnm.DATE) FROM converson_master cm WHERE cnm.S_CountryID=cm.CountryID) ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            retn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            return retn;
        }
        else
        {
            return retn;
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string Credit()
    {
        string retn = "";
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT cnm.S_CountryID,cnm.S_Currency,cnm.S_Notation,cnm.B_Currency,Selling_Specific ");
        sb.Append(" FROM country_master cm INNER JOIN converson_master cnm ON cm.CountryID = cnm.S_CountryID ");
        sb.Append("  WHERE cm.IsActive=1 AND cm.IsBaseCurrency=1 AND cnm.DATE=(SELECT ");
        sb.Append(" MAX(cnm.DATE) FROM converson_master cm WHERE cnm.S_CountryID=cm.CountryID) ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            retn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            return retn;
        }
        else
        {
            return retn;
        }
    }
    public string CardPrintOut(string LedgerTransactionNo)
    {
        string rtrn = "";
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT LTD.ItemID,LTD.SubCategoryID,LTD.ItemName AS Item,LTD.Rate,'' SubCategory,LTD.Quantity,LTD.DiscountPercentage,LT.DiscountOnTotal,LT.LedgerTransactionNo,");
        sb.Append(" EM.Name AS PreparedBy,IF(RC.ReceiptNo IS NULL, LT.BillNo,RC.ReceiptNo) ReceiptNo,RC.AmountPaid,Lt.Remarks,LT.PatientID AS PatientID,LT.NetAmount AS TotalRate,LT.PaymentModeID, ");
        sb.Append(" LT.DiscountReason,LT.Date,Lt.Time,Lt.PanelID,Lt.TransactionID ,");
        sb.Append(" LT.TypeOfTnx AS TransactionType,lt.RoundOff,CONCAT(PM.title,'',PM.PName)PatientName,FPM.Company_Name AS PanelName,");
        sb.Append(" PMH.ReferedBy,PMH.Source,(SELECT NAME FROM doctor_master WHERE DoctorID=PMH.DoctorID)HospDoctorName ,");
        sb.Append(" (SELECT ConfigID FROM f_configrelation WHERE categoryid=(SELECT categoryid  FROM f_subcategorymaster WHERE subcategoryid=ltd.subcategoryid ))configId ");
        sb.Append(" FROM f_ledgertransaction LT  INNER JOIN f_ledgertnxdetail LTD ON LT.LedgerTransactionNo=LTD.LedgerTransactionNo LEFT JOIN f_reciept  RC ON LT.LedgerTransactionNo=RC.AsainstLedgerTnxNo INNER JOIN");
        sb.Append(" patient_master PM ON Lt.PatientID=PM.PatientID INNER JOIN Patient_Medical_History PMH ON LTD.TransactionID=PMH.TransactionID INNER JOIN f_panel_master FPM ON Lt.PanelID=FPM.PanelID INNER JOIN employee_master EM");
        sb.Append(" ON Lt.UserID=EM.Employee_ID ");
        sb.Append(" WHERE Lt.TypeOfTnx IN('OPD-OTHERS') AND ");
        sb.Append(" LT.LedgerTransactionNo='" + LedgerTransactionNo + "'");
        DataTable dt = new DataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            return rtrn;
        }
        else
        {
            return rtrn;
        }
    }
    [WebMethod]
    public string DefaultCountry()
    {
        string rtrn = "";
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT Countryid FROM country_master WHERE IsActive=1 AND IsBaseCurrency=1  ORDER By Name");
        string  str = StockReports.ExecuteScalar(sb.ToString());
        rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(str);
        return rtrn;
    }
    [WebMethod]
    public string SetDefaultCity(string Country)
    {
        string rtrn = "";
        StringBuilder sb = new StringBuilder();
        sb.Append("select distinct City from city_master where Country='" + Country + "' and city !='' order by City asc");
        string str = StockReports.ExecuteScalar(sb.ToString());
        rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(str);
        return rtrn;
    }
}