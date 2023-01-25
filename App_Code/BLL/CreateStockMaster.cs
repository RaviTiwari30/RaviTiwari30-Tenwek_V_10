using System;
using System.Data;
using System.Text;
using System.Web;
using MySql.Data.MySqlClient;

public class CreateStockMaster
{
    public static DataTable GetDoctorDetail(string DName, string Specialization, string Deptartment)
    {       
       return AllLoadData_OPD.getDoctorDetail(DName, Specialization, Deptartment);    
    }
    public static string[,] LoadLedgerAccount(string Code)
    {
        AllQuery AQ = new AllQuery();
        string[,] Items = AQ.GetLedgerAccount("", Code);
        return Items;
    }
    public static DataTable LoadSubCategoryByCategory(string Category)
    {
        AllQuery AQ = new AllQuery();
        DataTable Items = AQ.GetSubCategoryByCategory(Category);
        return Items;
    }

    public static string UpdateRatelist(string Type, Decimal Rate, string RateID, string ItemID, string PanelID, string ScheduleChargeID,string CentreID)
    {
        AllQuery AQ = new AllQuery();
        string dt = AQ.UpdateRatelist(Type, Rate, RateID, ItemID, PanelID, ScheduleChargeID,CentreID);
        return dt;
    }
    public static string InsertIntoRateList(string CaseType, string Panel, string ItemId, decimal Rate, string Type, string RateID, string displayname, string ItemCode, string ScheduleChargeID,string CentreID)
    {
        AllQuery AQ = new AllQuery();
        string dt = AQ.InsertIntoRateList(CaseType, Panel, ItemId, Rate, Type, RateID, displayname, ItemCode, ScheduleChargeID,CentreID);
        return dt;
    }
    public static DataTable LoadSubCategoryByConfigID(string ConfigID)
    {
        AllQuery AQ = new AllQuery();
        DataTable Items = AQ.GetSubCategoryByConfigID(ConfigID);
        return Items;
    }
    public static DataTable LoadSubCategoryType()
    {
        AllQuery AQ = new AllQuery();
        DataTable dt = AQ.LoadSubCategoryType();
        return dt;
    }
    
    public static DataTable GetRateList(string Type, string DoctorID, string Panel, string SubCategory, string CaseType, string ScheduleChargeID,string CentreID)
    {
        AllQuery AQ = new AllQuery();
        DataTable dt = AQ.GetRateList(Type, DoctorID, Panel, SubCategory, CaseType, ScheduleChargeID, CentreID);
        return dt;
    }
    public static DataTable SearchPatientEMR(string PatientId, string PatientName, string TransactionId, string RoomID, string DoctorID, string Company, string FromAdmitDate, string ToAdmitDate, string DischargeDateFrom, string DischargeDateTo, string VisitDateFrom, string VisitDateTo, string status, int isEmergencyPatient)
    {
        AllQuery AQ = new AllQuery();
        DataTable Items = AQ.SearchPatientEMR(PatientId, PatientName, TransactionId, RoomID, DoctorID, Company, FromAdmitDate, ToAdmitDate, DischargeDateFrom, DischargeDateTo, VisitDateFrom, VisitDateTo, status, isEmergencyPatient);
        return Items;
    } 
    public static DataTable GetDocuementNo(string fromDate, string Todate, string Type, string LedTranNo)
    {
       return AllLoadData_Store.GetDocuementNo(fromDate, Todate, Type, LedTranNo);      
    }
    public static DataTable SearchAdjustmentItem(string LedTranNo)
    {       
        return AllLoadData_Store.SearchAdjustmentItem(LedTranNo);        
    }
    public static DataTable SearchStockUpdate(string LedTranNo)
    {
        return AllLoadData_Store.SearchStockUpdate(LedTranNo);
    }
    public static DataTable LoadCategoryByConfigID(string ConfigID)
    {
        AllQuery AQ = new AllQuery();
        return AQ.GetCategoryByConfigID(ConfigID);
    }
    public static DataTable LoadPanelCompanyRefOPD()
    {
        AllQuery AQ = new AllQuery();
        return AQ.GetPanelCompanyRefOPDDoc();
    }
    public static DataTable LoadDoctorInformationByDoctorID(string DoctorID)
    {
        AllQuery AQ = new AllQuery();
        DataTable Items = AQ.GetDoctorInformationByDoctorID(DoctorID);       
        return Items;
    }        
    public static DataTable PatientDetail(string PatientID, string CRNo, string PName, string Type)
    {
        AllQuery AQ = new AllQuery();
        DataTable dt = AQ.PatientDetail(PatientID, CRNo, PName, Type);
        return dt;
    }
    public static string UpdateIPDCase(string PatientID, string TransactionID, string Status, string PatientIPDPrfile, string Type, MySqlTransaction Tranx, string UserID, string DischargeReason)
    {
        AllUpdate AU = new AllUpdate();
        string dt = AU.UpdateIPDCase(PatientID, TransactionID, Status, PatientIPDPrfile, Type, Tranx, UserID, DischargeReason);
        return dt;
    }   
    public static DataTable GetBillDetail(string PatientID, string PatientName, string CRNO)
    {
        AllQuery Aq = new AllQuery();
        DataTable dt = Aq.GetBillDetail(PatientID, PatientName, CRNO);
        return dt;
    }
    public static DataTable LoadSubCategoryByCategory(DataTable Category)
    {
        string CatID = "";
        if (Category != null && Category.Rows.Count > 0)
        {
            for (int i = 0; i < Category.Rows.Count; i++)
            {
                if (Category.Rows.Count == 1)
                    CatID = CatID + Category.Rows[i]["CategoryID"].ToString();
                else if (i == Category.Rows.Count - 1)
                    CatID = CatID + Category.Rows[i]["CategoryID"].ToString();
                else
                    CatID = CatID + Category.Rows[i]["CategoryID"].ToString() + "','";
            }
        }

        AllQuery AQ = new AllQuery();
        DataTable Items = AQ.GetSubCategoryByCategory(CatID);
        return Items;
    }   
    public static Boolean SaveItemDetails(DataTable dtSubCategoryID, string TypeID, string Name, string IsEffectingInventory, string Description, string IsExpirable, string BillingUnit, string Pulse, string IsTrigger, string StartTime, string EndTime, string BufferTime, string IsActive, string QtyInHand, string IsAuthorised, MySqlTransaction tranX, DataTable dtdocgrouprate, DataTable dtpanel, string DocTypeId, string userid,string ValidityPeriod,int DepartmentID,int IsDiscountable)
    {
        string HospID = "LAP0001";
        try
        {
            ItemMaster objIMaster = new ItemMaster(tranX);

            if (dtSubCategoryID.Rows.Count > 0)
            {
                for (int i = 0; i < dtSubCategoryID.Rows.Count; i++)
                {
                    objIMaster.Hospital_ID = HospID;
                    objIMaster.Type_ID = Util.GetInt(TypeID);
                    objIMaster.TypeName = Util.GetString(Name);
                    objIMaster.Description = Util.GetString(Description);
                    objIMaster.SubCategoryID = Util.GetString(dtSubCategoryID.Rows[i]["SubCategoryID"].ToString());
                    objIMaster.IsEffectingInventory = Util.GetString(IsEffectingInventory);
                    objIMaster.IsExpirable = Util.GetString(IsExpirable);
                    objIMaster.BillingUnit = Util.GetString(BillingUnit);
                    objIMaster.Pulse = Util.GetString(Pulse);
                    objIMaster.IsTrigger = Util.GetString(IsTrigger);
                    objIMaster.StartTime = Util.GetDateTime(StartTime);
                    objIMaster.EndTime = Util.GetDateTime(EndTime);
                    objIMaster.BufferTime = Util.GetString(BufferTime);
                    objIMaster.IsActive = Util.GetInt(1);
                    objIMaster.QtyInHand = Util.GetDecimal(QtyInHand);
                    objIMaster.IsAuthorised = Util.GetInt(IsAuthorised);
                    objIMaster.CreaterID = HttpContext.Current.Session["ID"].ToString();
                    objIMaster.IPAddress = All_LoadData.IpAddress();
                    objIMaster.ValidityPeriod = Util.GetInt(ValidityPeriod);
                    objIMaster.DepartmentID = Util.GetInt(DepartmentID);
                    objIMaster.IsDiscountable = Util.GetInt(IsDiscountable);
                    objIMaster.Insert().ToString();
                }
                //for (int j = 0; j < dtpanel.Rows.Count; j++)
                //{
                //    StringBuilder sb=new StringBuilder();
                //    sb.Append(" INSERT INTO f_ratelist(Location,Hospcode,Rate,ItemID,PanelID,IsCurrent,UserID,ScheduleChargeID) ");
                //    sb.Append(" SELECT 'L','SHHI',Rate,ItemID," + dtpanel.Rows[j]["PanelID"] + ",1,'" + userid.ToString() + "','" + dtpanel.Rows[j]["ScheduleChargeID"] + "' FROM ( ");
                //    sb.Append(" SELECT im.ItemID,im.isActive,im.SubCategoryID FROM f_itemmaster im INNER JOIN f_subcategorymaster sm ON im.subCategoryID=sm.SubCategoryID ");
                //    sb.Append(" INNER JOIN f_configrelation cf ON cf.categoryID=sm.CategoryID AND ConfigID=5  ");
                //    sb.Append(" WHERE Type_ID='"+Util.GetString(TypeID)+"')a ");
                //    sb.Append(" INNER JOIN docgrouprate dr ON dr.SubCategoryID=a.SubCategoryID ");
                //    sb.Append(" WHERE TYPE='OPD' AND DocTypeId='" + DocTypeId + "' AND panel=" + dtpanel.Rows[j]["PanelID"] + " AND a.IsActive=1 AND dr.IsActive=1 ");
                //    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());
                //}
                //string STR = " UPDATE f_ratelist SET RateListID=CONCAT(LOCATION,HospCode,ID) WHERE ifnull(RateListID,'')='' ";
                //MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, STR);
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE id_master SET MaxID=(Select max(ID) FROM f_ratelist) WHERE groupname='f_ratelist' ");

            
            }
            return true;
        }
        catch (Exception ex)
        {
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return false;
        }
    }
    public static Boolean SaveItemDetailsIPD(DataTable dtSubCategoryID, string TypeID, string Name, string IsEffectingInventory, string Description, string IsExpirable, string BillingUnit, string Pulse, string IsTrigger, string StartTime, string EndTime, string BufferTime, string IsActive, string QtyInHand, string IsAuthorised, MySqlTransaction tranX, DataTable dtdocgrouprate, DataTable dtpanel, string DocTypeId, DataTable dtRoomType, string userid, int DepartmentID, int IsDiscountable)
    {
        string HospID = "LAP0001";
        try
        {
            ItemMaster objIMaster = new ItemMaster(tranX);

            if (dtSubCategoryID.Rows.Count > 0)
            {
                for (int i = 0; i < dtSubCategoryID.Rows.Count; i++)
                {
                    objIMaster.Hospital_ID = HospID;
                    objIMaster.Type_ID = Util.GetInt(TypeID);
                    objIMaster.TypeName = Util.GetString(Name);
                    objIMaster.Description = Util.GetString(Description);
                    objIMaster.SubCategoryID = Util.GetString(dtSubCategoryID.Rows[i]["SubCategoryID"].ToString());
                    objIMaster.IsEffectingInventory = Util.GetString(IsEffectingInventory);
                    objIMaster.IsExpirable = Util.GetString(IsExpirable);
                    objIMaster.BillingUnit = Util.GetString(BillingUnit);
                    objIMaster.Pulse = Util.GetString(Pulse);
                    objIMaster.IsTrigger = Util.GetString(IsTrigger);
                    objIMaster.StartTime = Util.GetDateTime(StartTime);
                    objIMaster.EndTime = Util.GetDateTime(EndTime);
                    objIMaster.BufferTime = Util.GetString(BufferTime);
                    objIMaster.IsActive = Util.GetInt(1);
                    objIMaster.QtyInHand = Util.GetDecimal(QtyInHand);
                    objIMaster.IsAuthorised = Util.GetInt(IsAuthorised);
                    objIMaster.CreaterID = HttpContext.Current.Session["ID"].ToString();
                    objIMaster.IPAddress = All_LoadData.IpAddress();
                    objIMaster.DepartmentID = Util.GetInt(DepartmentID);
                    objIMaster.IsDiscountable = Util.GetInt(IsDiscountable);
                    objIMaster.Insert().ToString();
                    

                }
                for (int j = 0; j < dtpanel.Rows.Count; j++)
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append(" INSERT INTO f_ratelist_ipd(Location,Hospcode,Rate,ItemID,IPDCaseTypeID,PanelID,IsCurrent,userid,ScheduleChargeID) ");
                    sb.Append(" SELECT 'L','SHHI',Rate,ItemID,RoomTypeID," + dtpanel.Rows[j]["PanelID"] + ",1,'" + userid.ToString() + "','" + dtpanel.Rows[j]["ScheduleChargeID"] + "' FROM ( ");
                    sb.Append(" SELECT im.ItemID,im.isActive,im.SubCategoryID FROM f_itemmaster im INNER JOIN f_subcategorymaster sm ON im.subCategoryID=sm.SubCategoryID ");
                    sb.Append(" INNER JOIN f_configrelation cf ON cf.categoryID=sm.CategoryID AND ConfigID=1  ");
                    sb.Append(" WHERE Type_ID='" + Util.GetString(TypeID) + "')a ");
                    sb.Append(" INNER JOIN docgrouprate dr ON dr.SubCategoryID=a.SubCategoryID ");
                    sb.Append(" WHERE TYPE='IPD' AND DocTypeId='" + DocTypeId + "' AND panel=" + dtpanel.Rows[j]["PanelID"] + " AND a.IsActive=1 AND dr.IsActive=1 ");
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());
                }
                string STR = " UPDATE f_ratelist_ipd SET RateListID=CONCAT(LOCATION,HospCode,ID) WHERE IFNULL(RateListID,'')='' ";
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, STR);
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE id_master SET MaxID=(Select max(ID) FROM f_ratelist_ipd) WHERE groupname='f_ratelist_ipd' ");

            }
            return true;
        }
        catch (Exception ex)
        {
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return false;
        }
    }

    public static Boolean SaveItemDetails1(string SubCategoryID, string TypeID, string Name, string IsEffectingInventory, string Description, string IsExpirable, string BillingUnit, string Pulse, string IsTrigger, string StartTime, string EndTime, string BufferTime, string IsActive, string QtyInHand, string IsAuthorised, string Unit, int DepartmentID, int IsDiscountable, MySqlTransaction txn)
    {
        try
        {
            ItemMaster objIMaster = new ItemMaster(txn);
            objIMaster.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            objIMaster.Type_ID = Util.GetInt(TypeID);
            objIMaster.TypeName = Util.GetString(Name);
            objIMaster.Description = Util.GetString(Description);
            objIMaster.SubCategoryID = Util.GetString(SubCategoryID);
            objIMaster.IsEffectingInventory = Util.GetString(IsEffectingInventory);
            objIMaster.IsExpirable = Util.GetString(IsExpirable);
            objIMaster.BillingUnit = Util.GetString(BillingUnit);
            objIMaster.Pulse = Util.GetString(Pulse);
            objIMaster.IsTrigger = Util.GetString(IsTrigger);
            objIMaster.StartTime = Util.GetDateTime(StartTime);
            objIMaster.EndTime = Util.GetDateTime(EndTime);
            objIMaster.BufferTime = Util.GetString(BufferTime);
            objIMaster.IsActive = Util.GetInt(IsActive);
            objIMaster.QtyInHand = Util.GetDecimal(QtyInHand);
            objIMaster.IsAuthorised = Util.GetInt(IsAuthorised);
            objIMaster.UnitType = Util.GetString(Unit);
            objIMaster.IPAddress = All_LoadData.IpAddress();
            objIMaster.CreaterID = HttpContext.Current.Session["ID"].ToString();
            objIMaster.DepartmentID = Util.GetInt(DepartmentID);
            objIMaster.IsDiscountable = Util.GetInt(IsDiscountable);
            objIMaster.Insert().ToString();

            return true;
        }
        catch (Exception ex)
        {
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return false;
        }
    }
    public static DataTable LoadPanelCompanyRef()
    {
        AllQuery AQ = new AllQuery();
        DataTable Items = AQ.GetPanelCompanyRef();
        return Items;

    }
    public static string CancelBillNo(string BillNo, string CRNo, string IPDProfile, MySqlTransaction Tranx)
    {
        AllUpdate AU = new AllUpdate();
        string dt = AU.CancelBillNo(BillNo, CRNo, IPDProfile, Tranx);
        return dt;
    }
    
    public static DataTable LoadPanelCompanyRefOPDDoc()
    {
        AllQuery AQ = new AllQuery();
        DataTable Items = AQ.GetPanelCompanyRefOPD();
        return Items;
    }
    public static DataTable LoadPanelCompanyRefIPDDoc()
    {
        AllQuery AQ = new AllQuery();
        DataTable Items = AQ.GetPanelCompanyRefIPD();
        return Items;
    }
    public string UpdateReceiptForOPDBillingModified(string LedgerTranNo, string Date, string Time, string IsCheque_Draft, string ledgerNoCr, string AmountPaid, string BillNo, string PaymentMode, string UserID, string Depositor, string TransactionID, MySqlTransaction Tnx, double AmtCash, double AmtCreditCard, double AmtCheque, double AmtCredit, string CreditCardNo, string ChequeNo, string CreditCardBankName, string ChequeBankName, float ReceiptAmt, float ReceiveAmt, string hashCode)
    {
        string UpdateFlag = "";
        string ReceiptNo = "";       
        try
        {
            AllUpdate objallupdate = new AllUpdate(Tnx);
            UpdateFlag = objallupdate.UpdateLedgertnx(LedgerTranNo);

            if (UpdateFlag != "0")
            {
                Receipt objReceipt = new Receipt(Tnx);
                objReceipt.Date = Util.GetDateTime(Date);
                objReceipt.Time = Util.GetDateTime(Time);
                objReceipt.AsainstLedgerTnxNo = LedgerTranNo;               
                objReceipt.LedgerNoCr = ledgerNoCr;              
                objReceipt.UniqueHash = hashCode;
                objReceipt.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                objReceipt.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                objReceipt.IpAddress = All_LoadData.IpAddress();
                ReceiptNo = objReceipt.Insert().ToString();

            }
            return ReceiptNo.ToString();
        }
        catch (Exception ex)
        {
            return null;
            throw (ex);
        }
    }
    public string SaveReceiptBill(string PatientLedger, string HospitalLedger, decimal amount, DateTime PaidDate, int PanelId, string TransactionId, string HospitalID, DateTime PaidTime, string PaymentMode,int PaymentModeID, string Receiver, string Depositor, string BankName,string RefNo,DateTime RefDate,string PaymentRemarks,decimal S_Amount  ,int S_CountryID,string S_Currency,string S_Notation,decimal C_Factor, string hashCode)
    {
        string Receipt_No = "";
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            
            Receipt objRecipt = new Receipt(tranX);
            objRecipt.LedgerNoCr = HospitalLedger;
            objRecipt.LedgerNoDr = PatientLedger;
            objRecipt.AmountPaid = amount;
            objRecipt.PanelID = PanelId;
            objRecipt.TransactionID = TransactionId;
            objRecipt.Date = PaidDate;
            objRecipt.Time = PaidTime;            
            objRecipt.Hospital_ID = HospitalID;
            objRecipt.Reciever = Receiver;
            objRecipt.Depositor = Depositor;
            objRecipt.Naration = PaymentRemarks; ;
            objRecipt.UniqueHash = hashCode;
            objRecipt.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            objRecipt.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            objRecipt.PaidBy = "PAT";
            objRecipt.IpAddress = All_LoadData.IpAddress();
            Receipt_No = objRecipt.Insert();

            Receipt_PaymentDetail objReceiptpayment = new Receipt_PaymentDetail(tranX);
            objReceiptpayment.Amount = amount;
            objReceiptpayment.PaymentMode = PaymentMode;
            objReceiptpayment.PaymentModeID = PaymentModeID;
            objReceiptpayment.PaymentRemarks = PaymentRemarks;
            objReceiptpayment.ReceiptNo = Receipt_No;
            objReceiptpayment.RefDate = Util.GetDateTime(RefDate);
            objReceiptpayment.RefNo = RefNo;
            objReceiptpayment.S_Amount = S_Amount;
            objReceiptpayment.S_CountryID = S_CountryID;
            objReceiptpayment.S_Currency = S_Currency;
            objReceiptpayment.S_Notation = S_Notation;
            objReceiptpayment.C_Factor = C_Factor;
            objReceiptpayment.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            objReceiptpayment.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            objReceiptpayment.Insert();
            
            tranX.Commit();
            con.Close();
            con.Dispose();
            return Receipt_No;           
        }
        catch (Exception ex)
        {
            tranX.Rollback();
            con.Close();
            con.Dispose();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return null;
        }
    }
    public static bool CheckLedgerNoByPatientID(string PatientID, string GroupID)
    {
        AllQuery AQ = new AllQuery();
        string Items = AQ.GetLedgerNoByPatientID(PatientID, GroupID);

        if (Items != null && Items != "")
            return true;
        else
            return false;
    }

    public static DataTable GetAdmitDetail(string transactionId, string Type)
    {
        AllQuery AQ = new AllQuery();
        DataTable dt = AQ.GetAdmitDetail(transactionId, Type);
        return dt;
    }
    public string SaveReceiptBillNew(DataTable dtPaymentDetail, string PatientLedger, string HospitalLedger, string Hospital_ID, DateTime Date, DateTime Time, string Receiver, string Depositor, int Panel, string TransactionID, string TDS, string hashCode, decimal AmountPaid, MySqlTransaction tnx, string Naration, string ReceivedFrom)
    {
       
        try
        {
            if (PatientLedger != "")
            {
                AllUpdate Au = new AllUpdate(tnx);
                string UpdateLedgerMaster = Au.UpdateLedgerMsWithLedgerNumber(AmountPaid, PatientLedger, HospitalLedger, tnx);
                UpdateLedgerMaster = Au.UpdateIPDAdjustment(Util.GetDecimal(TDS), TransactionID, tnx);
            }
            Receipt ObjReceipt = new Receipt(tnx);
            ObjReceipt.LedgerNoCr = HospitalLedger;
            ObjReceipt.LedgerNoDr = PatientLedger;            
            ObjReceipt.AmountPaid = AmountPaid;
            ObjReceipt.PanelID = Panel;
            ObjReceipt.TransactionID = TransactionID;
            ObjReceipt.Date = Date;
            ObjReceipt.Time = Time;
            ObjReceipt.Hospital_ID = Hospital_ID;
            ObjReceipt.Depositor = Depositor;
            ObjReceipt.Reciever = Receiver;
            ObjReceipt.Discount = 0;                    
            ObjReceipt.UniqueHash = hashCode;
            ObjReceipt.IpAddress =All_LoadData.IpAddress();
            ObjReceipt.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            ObjReceipt.PaidBy = "PAT";
            ObjReceipt.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            ObjReceipt.Naration = Naration;
            ObjReceipt.ReceivedFrom = ReceivedFrom;
            string ReceiptNo = ObjReceipt.Insert();

            Receipt_PaymentDetail ObjReceiptPayment = new Receipt_PaymentDetail(tnx);
            foreach (DataRow row in dtPaymentDetail.Rows)
            {
                ObjReceiptPayment.PaymentModeID = Util.GetInt(row["PaymentModeID"]);
                ObjReceiptPayment.PaymentMode = Util.GetString(row["PaymentMode"]);
                ObjReceiptPayment.Amount = Util.GetDecimal(row["BaseCurrency"]);
                ObjReceiptPayment.ReceiptNo = ReceiptNo;
                ObjReceiptPayment.RefDate = Util.GetDateTime(row["RefDate"]);
                ObjReceiptPayment.RefNo = Util.GetString(row["RefNo"]);
                ObjReceiptPayment.BankName = Util.GetString(row["BankName"]);
                ObjReceiptPayment.C_Factor = Util.GetDecimal(row["C_Factor"]);
                ObjReceiptPayment.S_Amount = Util.GetDecimal(row["PaidAmount"]);
                ObjReceiptPayment.S_CountryID = Util.GetInt(row["CountryID"]);
                ObjReceiptPayment.S_Currency = Util.GetString(row["Currency"]);
                ObjReceiptPayment.S_Notation = Util.GetString(row["Notation"]);
                ObjReceiptPayment.currencyRoundOff = Util.GetDecimal(row["CurrencyRoundOff"]);
                ObjReceiptPayment.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                ObjReceiptPayment.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
 		ObjReceiptPayment.swipeMachine = Util.GetString(row["swipeMachine"]);

                string PaymentID = ObjReceiptPayment.Insert().ToString();
            }
            if (ReceiptNo == "")
                return "";
            else
                return ReceiptNo;

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);           
            return "";
        }
    }
    public string SaveReceiptBillNewRefund(DataTable dtPaymentDetail, string PatientLedger, string HospitalLedger, string Hospital_ID, DateTime Date, DateTime Time, string Receiver, string Depositor, int Panel, string TransactionID, string TDS, string hashCode, decimal Amount, MySqlTransaction tnx, string Naration, string ReceivedFrom)
    {
       
        try
        {
            if (PatientLedger != "")
            {
                AllUpdate Au = new AllUpdate(tnx);
                string UpdateLedgerMaster = Au.UpdateLedgerMsWithLedgerNumber(Amount, PatientLedger, HospitalLedger, tnx);
                UpdateLedgerMaster = Au.UpdateIPDAdjustment(Util.GetDecimal(TDS), TransactionID, tnx);
            }
            Receipt ObjReceipt = new Receipt(tnx);
            ObjReceipt.LedgerNoCr = HospitalLedger;
            ObjReceipt.LedgerNoDr = PatientLedger;
            ObjReceipt.PanelID = Panel;
            ObjReceipt.TransactionID = TransactionID;
            ObjReceipt.AmountPaid = Amount;
            ObjReceipt.Date = Date;
            ObjReceipt.Time = Time;
            ObjReceipt.Hospital_ID = Hospital_ID;
            ObjReceipt.Depositor = Depositor;
            ObjReceipt.Discount = 0;
            ObjReceipt.Reciever = Receiver;
            ObjReceipt.UniqueHash = hashCode;
            ObjReceipt.IpAddress = All_LoadData.IpAddress();
            ObjReceipt.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            ObjReceipt.PaidBy = "PAT";
            ObjReceipt.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            ObjReceipt.Naration = Naration;
            ObjReceipt.ReceivedFrom = ReceivedFrom;
            string ReceiptNo = ObjReceipt.Insert();

            Receipt_PaymentDetail ObjReceiptPayment = new Receipt_PaymentDetail(tnx);
            foreach (DataRow row in dtPaymentDetail.Rows)
            {
                ObjReceiptPayment.PaymentModeID = Util.GetInt(row["PaymentModeID"]);
                ObjReceiptPayment.PaymentMode = Util.GetString(row["PaymentMode"]);
                ObjReceiptPayment.Amount = Util.GetDecimal(row["BaseCurrency"]);
                ObjReceiptPayment.ReceiptNo = ReceiptNo;
                ObjReceiptPayment.RefDate = Util.GetDateTime(row["RefDate"]);
                ObjReceiptPayment.RefNo = Util.GetString(row["RefNo"]);
                ObjReceiptPayment.BankName = Util.GetString(row["BankName"]);
                ObjReceiptPayment.C_Factor = Util.GetDecimal(row["C_Factor"]);
                ObjReceiptPayment.S_Amount = Util.GetDecimal(row["PaidAmount"]);
                ObjReceiptPayment.S_CountryID = Util.GetInt(row["CountryID"]);
                ObjReceiptPayment.S_Currency = Util.GetString(row["Currency"]);
                ObjReceiptPayment.S_Notation = Util.GetString(row["Notation"]);
                ObjReceiptPayment.currencyRoundOff = Util.GetDecimal(row["CurrencyRoundOff"]);
                ObjReceiptPayment.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                ObjReceiptPayment.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                string PaymentID = ObjReceiptPayment.Insert().ToString();
            }
            if (ReceiptNo == "")
                return "";
            else
                return ReceiptNo;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
        
    }

    public static DataTable GetItemByBillNo(string BillNo)
    {
        AllQuery AQ = new AllQuery();
        DataTable dt = AQ.GetItemByBillNo(BillNo);
        return dt;
    }
    public static DataTable LoadReceiptCancelDetails(string BillNo, string ReceiptNo)
    {
        AllQuery AQ = new AllQuery();
        DataTable dt = AQ.GetReceiptCancelDetails(ReceiptNo, BillNo);

        if (dt == null || dt.Rows.Count == 0)
        {
            if (BillNo != "")
            {
                dt = AQ.GetBillCancelDetails(BillNo);
            }
        }


        for (int i = 0; i < dt.Rows.Count; i++)
        {
            if (dt.Columns.Contains("Pname") == false) dt.Columns.Add("Pname");
            dt.Rows[i]["Pname"] = AQ.GetPatientNameByID(dt.Rows[i]["PatientID"].ToString());
        }
        return dt;
    }

    public static DataTable LoadReceipIPDtCancelDetails(string ReceiptNo)
    {
        AllQuery AQ = new AllQuery();
        DataTable dt = AQ.LoadReceipIPDtCancelDetails(ReceiptNo);
        return dt;
    }

    public static Boolean CancelReceipt(string LedgerTranNo, string TransactionID, string UserID, string CancelReason)
    {
       
        AllUpdate AU = new AllUpdate();
        bool IsExist = AU.CancelReceipt(LedgerTranNo, CancelReason, UserID, TransactionID);
        if (IsExist == true)
            return true;
        else
        {
            IsExist = AU.CancelBill(LedgerTranNo, CancelReason, UserID);
            if (IsExist == true)
                return true;
            else
                return false;
        }
       
    }
    public static string CancelIPDReceipt(string TransactionID, string UserID, string CancelReason, string ReceiptNo, decimal Amount, string PatientID)
    {
        string IsExist = "";
        AllUpdate AU = new AllUpdate();
        AllQuery AQ = new AllQuery();
        string PatientUserID = StockReports.ExecuteScalar("Select LedgerNumber from f_ledgermaster Where LedgerUserID = '" + PatientID + "'");      
        string UpdateLedgerMaster = AU.UpdateLedgerMaster(PatientUserID, Amount);
        if (UpdateLedgerMaster == "1")
        {
            IsExist = AU.CancelIPDReceipt(TransactionID, UserID, CancelReason, ReceiptNo);
            return IsExist;
        }

        else
            return "0";
    }
    public static DataTable LoadAllStoreItems()
    {
        AllQuery AQ = new AllQuery();
        DataTable ds = AQ.LoadAllStoreItems();
        return ds;
    }
    public static DataTable AddItemDetails(DataTable dtItem, string ItemID, string ItemName, string BatchNo, string Quantity, float Rate, float MRP, string ExpiryDate, string SubCategory, string Narration, float SaleTax, string PurTax, float Disc, string TYPE, string UnitType, string MajorUnit, string MinorUnit, string ConversionFactor, string TaxID, decimal TaxPer, decimal MRPValue, decimal NetAmount, decimal taxAmount, decimal discountAmount, decimal amount, decimal unitPrice, decimal IGSTper, decimal IGSTAmt, decimal CGSTPer, decimal CGSTAmt, decimal SGSTPer, decimal SGSTAmt, string HSNCode, string GSTType)
    {
        try
        {
            if (dtItem == null)
            {
                dtItem = new DataTable();
                dtItem.Columns.Add("ItemID");
                dtItem.Columns.Add("ItemName");
                dtItem.Columns.Add("BatchNo");
                dtItem.Columns.Add("Quantity");
                dtItem.Columns.Add("Rate");
                dtItem.Columns.Add("MRP");
                dtItem.Columns.Add("ExpiryDate");
                dtItem.Columns.Add("SubCategoryID");
                dtItem.Columns.Add("Narration");
                dtItem.Columns.Add("UnitType");
                dtItem.Columns.Add("SaleTax");
                dtItem.Columns.Add("PurTax");
                dtItem.Columns.Add("Disc");
                dtItem.Columns.Add("TYPE");
                dtItem.Columns.Add("MajorUnit");
                dtItem.Columns.Add("MinorUnit");
                dtItem.Columns.Add("ConversionFactor");
                dtItem.Columns.Add("TaxID");
                dtItem.Columns.Add("TaxPer");
                dtItem.Columns.Add("MRPValue");
                dtItem.Columns.Add("NetAmount");
                dtItem.Columns.Add("taxAmount");
                dtItem.Columns.Add("discountAmount");
                dtItem.Columns.Add("Amount");
                dtItem.Columns.Add("unitPrice");
                //GST Changes
                dtItem.Columns.Add("igstTaxPer");
                dtItem.Columns.Add("igstTaxAmt", typeof(decimal));
                dtItem.Columns.Add("cgstTaxPer");
                dtItem.Columns.Add("cgstTaxAmt", typeof(decimal));
                dtItem.Columns.Add("sgstTaxPer");
                dtItem.Columns.Add("sgstTaxAmt", typeof(decimal));
                dtItem.Columns.Add("HSNCode");
                dtItem.Columns.Add("GSTType");
            }

            if (dtItem != null)
            {
                DataRow dr = dtItem.NewRow();
                dr["ItemID"] = ItemID;
                dr["ItemName"] = ItemName;
                dr["BatchNo"] = BatchNo;
                dr["Quantity"] = Quantity;
                dr["Rate"] = Rate;
                dr["MRP"] = MRP;
                dr["ExpiryDate"] = ExpiryDate;
                dr["SubCategoryID"] = SubCategory;
                dr["Narration"] = Narration;
                dr["UnitType"] = UnitType;
                dr["SaleTax"] = SaleTax;
                dr["PurTax"] = PurTax;
                dr["Disc"] = Disc;
                dr["TYPE"] = TYPE;
                dr["MajorUnit"] = MajorUnit;
                dr["MinorUnit"] = MinorUnit;
                dr["ConversionFactor"] = ConversionFactor;
                dr["TaxID"] = TaxID;
                dr["TaxPer"] = TaxPer;
                dr["MRPValue"] = MRPValue;
                dr["NetAmount"] = NetAmount;
                dr["taxAmount"] = taxAmount;
                dr["discountAmount"] = discountAmount;
                dr["Amount"] = amount;
                dr["unitPrice"] = unitPrice;
                //GST Changes
                dr["igstTaxPer"] = IGSTper;
                dr["igstTaxAmt"] = IGSTAmt;
                dr["cgstTaxPer"] = CGSTPer;
                dr["cgstTaxAmt"] = CGSTAmt;
                dr["sgstTaxPer"] = SGSTPer;
                dr["sgstTaxAmt"] = SGSTAmt;
                dr["HSNCode"] = HSNCode;
                dr["GSTType"] = GSTType;
                dtItem.Rows.Add(dr);

            }

            return dtItem;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }

    public static string SaveStockAdjustment(DataTable dt, string HospID, string UserID, string TranType, string LedgerNumber, string approvedBy, string DeptLedgerNo, string StoreLedgerNo, string taxCalculateOn)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        string StockID = "";
        try
        {
            string ReferenceNo = Util.GetString(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, "SELECT get_Tran_idPh('Stock Adjustment','" + Util.GetString(DeptLedgerNo) + "'," + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + ")"));
            if (ReferenceNo == string.Empty)
            {
                return "";
            }
            

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                string ItemID = dt.Rows[i]["ItemID"].ToString();
                string SubCatID = dt.Rows[i]["SubCategoryID"].ToString();
                string Quantity = dt.Rows[i]["Quantity"].ToString();
                string ItemName = dt.Rows[i]["ItemName"].ToString();
                decimal disAmt = 0;

                decimal perUnitPrice = 0;

                perUnitPrice = Math.Round(Util.GetDecimal(dt.Rows[i]["unitPrice"]), 2, MidpointRounding.AwayFromZero);

                Stock objStock = new Stock(tranX);
                string postime = DateTime.Now.ToString("HH:mm:ss");
                objStock.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                objStock.ItemID = ItemID;
                objStock.ItemName = ItemName;
                objStock.LedgerTransactionNo = Util.GetString(0);
                objStock.BatchNumber = Util.GetString(dt.Rows[i]["BatchNo"].ToString());

               // perUnitPrice = Math.Round(Util.GetDecimal(dt.Rows[i]["unitPrice"]), 2, MidpointRounding.AwayFromZero);

                if (Util.GetDecimal(dt.Rows[i]["ConversionFactor"].ToString()) > 0)
                    objStock.UnitPrice = Util.GetDecimal(Util.GetDecimal(perUnitPrice)) / Util.GetDecimal(dt.Rows[i]["ConversionFactor"].ToString());
                    //objStock.UnitPrice = Util.GetDecimal(Util.GetDecimal(perUnitPrice));
                else
                    objStock.UnitPrice = Util.GetDecimal(Util.GetDecimal(perUnitPrice));

                objStock.MRP = Util.GetDecimal(dt.Rows[i]["MRP"].ToString()) / Util.GetDecimal(dt.Rows[i]["ConversionFactor"].ToString());
                objStock.IsCountable = Util.GetInt("1");
                objStock.InitialCount = Util.GetDecimal(Util.GetDecimal(Quantity) * Util.GetDecimal(dt.Rows[i]["ConversionFactor"].ToString()));
                objStock.ReleasedCount = Util.GetDecimal(0);
                objStock.IsReturn = Util.GetInt(2);
                objStock.LedgerNo = LedgerNumber;
                objStock.StoreLedgerNo = StoreLedgerNo;
                if ((Util.GetString(dt.Rows[i]["ExpiryDate"]) == "0000-00-00") || (Util.GetString(dt.Rows[i]["ExpiryDate"]) == ""))
                   objStock.MedExpiryDate = Util.GetDateTime("0001-01-01");                    
                else
                   objStock.MedExpiryDate = Util.GetDateTime(dt.Rows[i]["ExpiryDate"]);
                objStock.StockDate = DateTime.Now;
                objStock.IsPost = 1;
                objStock.PostUserID = UserID;
                objStock.DeptLedgerNo = DeptLedgerNo; 
                objStock.Naration = Util.GetString(dt.Rows[i]["Narration"].ToString());
                objStock.SubCategoryID = SubCatID;
                objStock.PostDate = DateTime.Now;
                objStock.Unit = Util.GetString(dt.Rows[i]["MinorUnit"].ToString());
                objStock.IsBilled = 1;
                objStock.Reusable = 0;
                objStock.Rate = Util.GetDecimal(dt.Rows[i]["Rate"].ToString());
                objStock.DiscPer = Util.GetDecimal(dt.Rows[i]["Disc"].ToString());
               
                //objStock.SaleTaxPer = Util.GetDecimal(dt.Rows[i]["SaleTax"].ToString());
                //objStock.SaleTaxAmt = Math.Round((Util.GetDecimal((Util.GetDecimal(dt.Rows[i]["MRP"]) * 100) / (100 + objStock.SaleTaxPer)) * objStock.SaleTaxPer / 100) * Util.GetDecimal(Quantity), 4);
                objStock.PurTaxPer = Util.GetDecimal(dt.Rows[i]["TaxPer"].ToString());
                objStock.PurTaxAmt = Util.GetDecimal(Util.GetDecimal(dt.Rows[i]["taxAmount"].ToString()));
                objStock.TYPE = Util.GetString(dt.Rows[i]["TYPE"].ToString());
                
                objStock.DiscAmt = Util.GetDecimal(disAmt);
                objStock.UserID = UserID;
                objStock.ConversionFactor = Util.GetDecimal(dt.Rows[i]["ConversionFactor"].ToString());
                objStock.MajorUnit = Util.GetString(dt.Rows[i]["MajorUnit"].ToString());
                objStock.MinorUnit = Util.GetString(dt.Rows[i]["MinorUnit"].ToString());
                objStock.MajorMRP = Util.GetDecimal(Util.GetDecimal(dt.Rows[i]["MRP"]));
                objStock.taxCalculateOn = Util.GetString(taxCalculateOn);
                objStock.IpAddress = All_LoadData.IpAddress();
                // For GST
               // objStock.HSNCode = Util.GetString(dt.Rows[i]["HSNCode"]);
               // objStock.GSTType = Util.GetString(dt.Rows[i]["GSTType"]);
               // objStock.IGSTPercent = Util.GetDecimal(dt.Rows[i]["igstTaxPer"]);
                //objStock.IGSTAmtPerUnit = Math.Round(Util.GetDecimal(dt.Rows[i]["igstTaxAmt"]) / (Util.GetDecimal(objStock.InitialCount)), 4, MidpointRounding.AwayFromZero);
                //objStock.CGSTPercent = Util.GetDecimal(dt.Rows[i]["cgstTaxPer"]);
                //objStock.CGSTAmtPerUnit = Math.Round(Util.GetDecimal(dt.Rows[i]["cgstTaxAmt"]) / (Util.GetDecimal(objStock.InitialCount)), 4, MidpointRounding.AwayFromZero);
                //objStock.SGSTPercent = Util.GetDecimal(dt.Rows[i]["sgstTaxPer"]);
                //objStock.SGSTAmtPerUnit = Math.Round(Util.GetDecimal(dt.Rows[i]["sgstTaxAmt"]) / (Util.GetDecimal(objStock.InitialCount)), 4, MidpointRounding.AwayFromZero);
                //
                objStock.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                if ((Util.GetString(dt.Rows[i]["ExpiryDate"]) == "0000-00-00") || (Util.GetString(dt.Rows[i]["ExpiryDate"]) == ""))
                    objStock.IsExpirable = 0;
                else
                    objStock.IsExpirable = 1;
                if (StoreLedgerNo == "STO00001")
                    objStock.TypeOfTnx = "StockUpdate";
                else
                    objStock.TypeOfTnx = "NONMEDICALADJUSTMENT";

                objStock.LedgerTnxNo = "0";
                objStock.ReferenceNo = ReferenceNo;

                try
                {
                    StockID = objStock.Insert().ToString();
                }
                catch (Exception ex)
                {                    
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    tranX.Rollback();
                    return "";
                }
                if (StockID.Length == 0)
                {
                    tranX.Rollback();
                    return "";
                }
            }
            tranX.Commit();
          
            return ReferenceNo;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tranX.Rollback();
            return "";
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }

    }
   
    public static string[,] LoadStoreName()
    {
        AllQuery AQ = new AllQuery();
        string[,] Items = AQ.GetStoreName();
        return Items;
    }
    public static string[,] LoadDeptName()
    {
        AllQuery AQ = new AllQuery();
        string[,] Items = AQ.GetDeptName();
        return Items;
    }
    public static DataTable GetMedExpDate(string StockID)
    {
        AllQuery AQ = new AllQuery();
        DataTable Items = AQ.GetMedExpDate(StockID);
        return Items;
    }
    public static int InsertIntoStockExpiry(string stockID, string ItemId, DateTime oldExpDate, DateTime ExpDate, string UserID, DateTime ChangeDate, MySqlTransaction Tranx)
    {
        try
        {
            StockExpiry objExp = new StockExpiry(Tranx);
            objExp.StockID = stockID;
            objExp.ItemID = ItemId;
            objExp.OldExpiryDate = Util.GetDateTime(oldExpDate);
            objExp.NewExpiryDate = Util.GetDateTime(ExpDate);
            objExp.UserID = UserID;
            objExp.UpdateDate = Util.GetDateTime(ChangeDate);
            objExp.Insert();
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "update f_stock set  MedExpiryDate='" + ExpDate.ToString("yyyy-MM-dd") + "' where StockID = '" + stockID + "' ");
            return 1;
        }
        catch(Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return 0;
        }
    }
    public static DataTable GetPatientReturnDetails(string CRNo, string DocumentNo, string IndentNo, string FromDate, string ToDate,string CentreID)
    {
        AllQuery AQ = new AllQuery();
        DataTable dt = AQ.GetPatientReturnDetails(CRNo, DocumentNo, IndentNo, FromDate, ToDate, CentreID);

        if (dt != null && dt.Rows.Count > 0)
        {
            if (dt.Columns.Contains("Name") == false) dt.Columns.Add("Name");
            if (dt.Columns.Contains("DocumentNo") == false) dt.Columns.Add("DocumentNo");

            foreach (DataRow dr in dt.Rows)
            {
                dr["Name"] = AQ.GetPatientDetail(dr["PatientID"].ToString()).Rows[0]["PName"].ToString();
                dr["DocumentNo"] = dr["LedgerTransactionNo"].ToString();
                dr["Date"] = Convert.ToDateTime(dr["Date"].ToString()).ToString("dd-MMM-yyyy");
            }
        }

        return dt;
    }
    public static DataTable GetDeptReturnDetails(string FrmDate, string ToDate, string DocumentNo, string IndentNo, string ItemID, string Dept,string CentreID)
    {
        AllQuery AQ = new AllQuery();
        DataTable dt = AQ.GetDeptReturnDetails(FrmDate, ToDate, DocumentNo, IndentNo, ItemID, Dept, CentreID);

        if (dt != null && dt.Rows.Count > 0)
        {
            if (dt.Columns.Contains("Name") == false) dt.Columns.Add("Name");
            if (dt.Columns.Contains("DocumentNo") == false) dt.Columns.Add("DocumentNo");
            if (dt.Columns.Contains("TransactionID") == false) dt.Columns.Add("TransactionID");

            foreach (DataRow dr in dt.Rows)
            {
                dr["Name"] = AQ.GetDeptDetails(dr["LedgerNumber"].ToString()).Rows[0]["LedgerName"].ToString();
                dr["DocumentNo"] = dr["SalesNo"].ToString();
                dr["TransactionID"] = "-";
                dr["Date"] = Util.GetDateTime(dr["Date"].ToString()).ToString("dd-MMM-yyyy");
            }
        }
        return dt;
    }
    public static DataTable GetItemReturnDetails(string DocumentNo, string Type)
    {
        AllQuery AQ = new AllQuery();
        DataTable dt = AQ.GetItemReturnDetails(DocumentNo, Type);
        return dt;
    }
    public static DataTable LoadCategoryByCategoryID(DataTable CategoryID)
    {
        string CatID = "";
        if (CategoryID != null && CategoryID.Rows.Count > 0)
        {
            for (int i = 0; i < CategoryID.Rows.Count; i++)
            {
                if (CategoryID.Rows.Count == 1)
                {
                    CatID = CatID + CategoryID.Rows[i]["CategoryID"].ToString();
                }
                else if (i == CategoryID.Rows.Count - 1)
                {
                    CatID = CatID + CategoryID.Rows[i]["CategoryID"].ToString();
                }
                else
                {
                    CatID = CatID + CategoryID.Rows[i]["CategoryID"].ToString() + "','";
                }
            }
        }

        AllQuery AQ = new AllQuery();
        DataTable Items = AQ.GetCategoryByCategoryID(CatID);
        return Items;
    }
    public static DataTable LoadItemSubCategoryByCategoryConfigID(string CategoryID,string PanelId="")
    {
        AllQuery AQ = new AllQuery();
        DataTable Items = AQ.GetItemSubCategoryByCategoryConfigID(CategoryID,PanelId);
        return Items;
    }
    public static DataTable LoadItemsSubCategoryByCategoryID(string CategoryID)
    {
        AllQuery AQ = new AllQuery();
        DataTable Items = AQ.GetItemsSubCategoryByCategoryID(CategoryID);
        return Items;
    }
    public static string UpdateNarration(string Narration, string TransactionID)
    {
        AllUpdate AU = new AllUpdate();
        string dt = AU.UpdateNarration(Narration, TransactionID);
        return dt;
    }
    public static DataTable GetDischargeType(string CRNO)
    {
        AllQuery AQ = new AllQuery();
        DataTable Items = AQ.GetDischargeType(CRNO);
        return Items;
    }
    
    public static DataSet GoodsReceiptNoteReport(string LTNo)
    {
        AllQuery AQ = new AllQuery();
        return AQ.GoodsReceiptNoteReport(LTNo);       
    }
    public static DataSet GoodsReceiptNoteReport1(string LTNo, string storeledgerno)
    {
        AllQuery AQ = new AllQuery();
        return AQ.GoodsReceiptNoteReport1(LTNo, storeledgerno);
    }   
    public static DataSet GoodsReceiptNoteReport3(string LTNo, string storeledgerno)
    {
        AllQuery AQ = new AllQuery();
        return AQ.GoodsReceiptNoteReport3(LTNo, storeledgerno);
    }
    public static DataSet GoodsReceiptNoteReport(string LTNo, string storeledgerno)
    {
        AllQuery AQ = new AllQuery();
        return AQ.GoodsReceiptNoteReport(LTNo, storeledgerno);
    }
    public static string SaveSubCategoryDetails(string Name, string Desc, string CategoryID, MySqlTransaction Tnx)
    {
        try
        {
            SubCategoryMaster objSubCatMas = new SubCategoryMaster();
            objSubCatMas.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            objSubCatMas.Name = Util.GetString(Name);
            objSubCatMas.Description = Util.GetString(Desc);
            objSubCatMas.CategoryID = Util.GetString(CategoryID);
            objSubCatMas.Active = 1;
            objSubCatMas.IPAddress = All_LoadData.IpAddress();
            string subcateid = objSubCatMas.Insert().ToString();

            return subcateid;
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "";
        }
    }    

}
    
    

