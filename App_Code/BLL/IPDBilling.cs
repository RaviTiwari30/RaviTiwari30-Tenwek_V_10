using System;
using System.Data;
using System.Web;
using MySql.Data.MySqlClient;
using System.Collections.Generic;


public class IPDBilling
{

    public static DataTable GetBilledPatientDetail(string TrnxID)
    {
        try
        {
            AllSelectQuery ASQ = new AllSelectQuery();
            DataTable PTDetail = ASQ.GetBilledPatientDetail(TrnxID);
            return PTDetail;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }

    public static DataTable GetBilledPatientDetailNew(string TrnxID,int IsBaseBill,int IsDummyBill)
    {
        try
        {
            AllSelectQuery ASQ = new AllSelectQuery();
            DataTable PTDetail = ASQ.GetBilledPatientDetailNew(TrnxID,IsBaseBill,IsDummyBill);
            return PTDetail;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }

    public static DataTable GetBilledPatientItemDetail(string TrnxID)
    {
        try
        {
            AllSelectQuery ASQ = new AllSelectQuery();
            DataTable PTDetail = ASQ.GetBilledPatientItemDetail(TrnxID);
            return PTDetail;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }

    public static DataTable GetBilledPatientItemDetailNew(string TrnxID, int IsBaseBill, int IsDummyBill)
    {
        try
        {
            AllSelectQuery ASQ = new AllSelectQuery();
            DataTable PTDetail = ASQ.GetBilledPatientItemDetailNew(TrnxID, IsBaseBill, IsDummyBill);
            return PTDetail;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }

    public static DataTable GetBilledPatientItemDetailDiscount(string TrnxID)
    {
        try
        {
            AllSelectQuery ASQ = new AllSelectQuery();
            DataTable PTDetail = ASQ.GetBilledPatientItemDetailDiscount(TrnxID);
            return PTDetail;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public static DataTable GetPatientPackageDetail(string TrnxID)
    {
        try
        {
            AllSelectQuery ASQ = new AllSelectQuery();
            DataTable PTDetail = ASQ.GetPatientPackageDetail(TrnxID);
            return PTDetail;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public static DataTable GetPatientPackageDetailNew(string TrnxID, int IsBaseBill, int IsDummyBill)
    {
        try
        {
            AllSelectQuery ASQ = new AllSelectQuery();
            DataTable PTDetail = ASQ.GetPatientPackageDetailNew(TrnxID, IsBaseBill, IsDummyBill);
            return PTDetail;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public static DataTable LoadItemsHavingRateFixed(string ItemID, string PanelID, string CaseTypeID, string ScheduleChargeID,string CentreID)
    {
        try
        {
            AllQuery AQ = new AllQuery();
            DataTable Items = AQ.GetItemRate(ItemID, PanelID, CaseTypeID, ScheduleChargeID, CentreID);
            return Items;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public static DataTable UpdateLedgerForIPDBilling(DataTable Items, string PatientID, string TypeOfTransaction, int PanelId, string UserID, string TransactionID, string HospitalID, string IsService, string IsVerified, MySqlTransaction TranConnection, string IPDCaseType_ID, string PatientType, MySqlConnection con, string Room_ID,int patientTypeID=1)
    {
        try
        {
            decimal TotalRate = 0;
            string MembershipNo = StockReports.ExecuteScalar("SELECT IF(DATE(pm.MemberShipDate)>=CURDATE(),IFNULL(pm.MemberShip,''),'')MemberShipCardNo from patient_master pm where PatientID='" + PatientID + "'");
                                   

            for (int i = 0; i < Items.Rows.Count; i++)
            {
                TotalRate = TotalRate + (Util.GetDecimal(Items.Rows[i]["Rate"]) * Util.GetDecimal(Items.Rows[i]["Quantity"]));
            }



            string LedTxnID = "";
            Ledger_Transaction objLedTran = new Ledger_Transaction(TranConnection);
            objLedTran.LedgerNoCr = AllQuery.GetLedgerNoByLedgerUserID(PatientID, con);
            objLedTran.LedgerNoDr = AllQuery.GetLedgerNoByLedgerUserID(HospitalID, con);
            objLedTran.Hospital_ID = HospitalID;
            objLedTran.TypeOfTnx = TypeOfTransaction;
            objLedTran.Date = Util.GetDateTime(Items.Rows[0]["Date"].ToString());
            objLedTran.Time = Util.GetDateTime(Items.Rows[0]["Date"].ToString());
            objLedTran.AgainstPONo = "";
            objLedTran.BillNo = "";
            objLedTran.DiscountOnTotal = Util.GetDecimal("0.0");
            objLedTran.GrossAmount = Util.GetDecimal(TotalRate);
            objLedTran.NetAmount = Util.GetDecimal(TotalRate);
            objLedTran.IsCancel = 0;
            objLedTran.CancelReason = "";
            objLedTran.CancelAgainstLedgerNo = "";
            objLedTran.CancelDate = Util.GetDateTime(DateTime.Now.ToShortDateString());
            objLedTran.UserID = UserID;
            objLedTran.PatientID = PatientID;
            objLedTran.TransactionID = TransactionID;
            objLedTran.PanelID = PanelId;
            objLedTran.UniqueHash = Util.getHash();
            objLedTran.IpAddress = HttpContext.Current.Request.UserHostAddress;
            objLedTran.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            objLedTran.PatientType = PatientType;
            LedTxnID = objLedTran.Insert().ToString();

            //***************** insert into Ledger transaction details and Sales Details *************            

            if (Items.Columns.Contains("LedgerTransactionNo") == false) Items.Columns.Add("LedgerTransactionNo");

            // string PatientType = StockReports.GetPatient_Type_IPD(TransactionID);

            //Checking if Patient is prescribed any IPD Packages
            DataTable dtPkg = StockReports.GetIPD_Packages_Prescribed(TransactionID, con);

            int Is_OldItems_Shifted_To_Pkg = 0;

            for (int j = 0; j < Items.Rows.Count; j++)
            {
                LedgerTnxDetail objLTDetail = new LedgerTnxDetail(TranConnection);

                objLTDetail.Hospital_Id = HospitalID;
                objLTDetail.LedgerTransactionNo = LedTxnID;
                objLTDetail.ItemID = Items.Rows[j]["ItemID"].ToString();
                objLTDetail.Rate = Util.GetDecimal(Items.Rows[j]["Rate"]);
                objLTDetail.Quantity = Util.GetDecimal(Items.Rows[j]["Quantity"]);
                objLTDetail.TnxTypeID = Util.GetInt(Items.Rows[j]["TnxTypeID"]);

                //Park Hospital shatrughan 21.10.15
                // objLTDetail.IsPayable = StockReports.GetIsPayableItems(objLTDetail.ItemID, PanelId);
                objLTDetail.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(Items.Rows[j]["SubCategoryID"]), con));

                //if (Items.Columns.Contains("NonPayable"))
                //    objLTDetail.IsPayable = Util.GetInt(Items.Rows[j]["NonPayable"]);
                //else
                //    objLTDetail.IsPayable = StockReports.GetIsPayableItems(objLTDetail.ItemID, PanelId);


                var dataTableCoPayDiscont = AllLoadData_IPD.getIPDPanelDiscPer(Util.GetInt(PanelId), Util.GetString(Items.Rows[j]["ItemID"]), patientTypeID);

                if (dtPkg != null && dtPkg.Rows.Count > 0)
                {
                    int iCtr = 0;
                    foreach (DataRow drPkg in dtPkg.Rows)
                    {
                        if (iCtr == 0)
                        {
                            DataTable dtPkgDetl = StockReports.ShouldSendToIPDPackage(TransactionID, drPkg["PackageID"].ToString(), Items.Rows[j]["ItemID"].ToString(), (Util.GetDecimal(Items.Rows[j]["Rate"]) * Util.GetDecimal(Items.Rows[j]["Quantity"])), Util.GetInt(Items.Rows[j]["Quantity"]),Util.GetInt(IPDCaseType_ID), con);

                            if (dtPkgDetl != null && Util.GetString(dtPkgDetl.Rows[0]["iStatus"]) != "")
                            {
                                if (Util.GetBoolean(dtPkgDetl.Rows[0]["iStatus"]))
                                {
                                    objLTDetail.Amount = 0;
                                    objLTDetail.DiscountPercentage = 0;
                                    objLTDetail.DiscAmt = 0;
                                    objLTDetail.IsPackage = 1;
                                    objLTDetail.PackageID = Util.GetString(drPkg["PackageID"]);
                                    objLTDetail.NetItemAmt = 0;
                                    objLTDetail.TotalDiscAmt = 0;
                                }
                                else
                                {
                                   // decimal DiscPerc = Util.GetDecimal(AllLoadData_IPD.getIPDPanelDiscPer(Util.GetInt(PanelId), Util.GetString(Items.Rows[j]["ItemID"]),"I",con));
                                    decimal DiscPerc = 0;
                                   if (Resources.Resource.IsmembershipInIPD == "1")
                                    {
                                        if (PanelId == 1)
                                        {
                                            if (MembershipNo != "")
                                            {
                                                GetDiscount ds = new GetDiscount();
                                                DiscPerc = Util.GetDecimal(ds.GetDefaultDiscount_Membership(Util.GetString(Items.Rows[j]["ItemID"]), MembershipNo, "IPD").Split('#')[0].ToString());
                                            }
                                            else
                                                DiscPerc = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);
                                        }
                                        else
                                            DiscPerc = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);
                                    }
                                    else
                                       DiscPerc = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);

                                    if (DiscPerc > 0)
                                    {
                                        decimal GrossAmt = Util.GetDecimal(Items.Rows[j]["Rate"]) * Util.GetDecimal(Items.Rows[j]["Quantity"]);
                                        decimal NetAmount = GrossAmt - ((GrossAmt * DiscPerc) / 100);

                                        objLTDetail.Amount = Util.GetDecimal(NetAmount);
                                        objLTDetail.DiscountPercentage = Util.GetDecimal(DiscPerc);
                                        objLTDetail.DiscAmt = Util.GetDecimal(GrossAmt - NetAmount);
                                        objLTDetail.NetItemAmt = Util.GetDecimal(NetAmount);
                                        objLTDetail.TotalDiscAmt = Util.GetDecimal(GrossAmt - NetAmount);
                                        objLTDetail.DiscountReason = "Panel Wise Discount";
                                        objLTDetail.DiscUserID = UserID;
                                        if (PanelId != 1)
                                        objLTDetail.isPanelWiseDisc = 1;
                                    }
                                    else
                                    {
                                        objLTDetail.DiscountPercentage = Util.GetDecimal(0);
                                        objLTDetail.DiscAmt = 0;
                                        objLTDetail.Amount = Util.GetDecimal(Items.Rows[j]["Rate"]) * Util.GetDecimal(Items.Rows[j]["Quantity"]);
                                        objLTDetail.NetItemAmt = Util.GetDecimal(Items.Rows[j]["Rate"]) * Util.GetDecimal(Items.Rows[j]["Quantity"]);
                                        objLTDetail.TotalDiscAmt = 0;
                                    }
                                }
                            }
                            else
                            {
                                //Check to see if already added items should be shifted to this item if it is a ipd-package
                                if (Util.GetString(Items.Rows[j]["ConfigID"]) == "14")//ipd-package
                                {
                                    if (Is_OldItems_Shifted_To_Pkg == 0)
                                    {
                                        if (Util.GetBoolean(StockReports.SentToIPDPackage(TransactionID, Util.GetString(Items.Rows[j]["ItemID"]),Util.GetDateTime(Items.Rows[j]["Date"]),Util.GetInt((Util.GetDateTime(Items.Rows[j]["ToDate"]) - Util.GetDateTime(Items.Rows[j]["FromDate"])).Days), con)))
                                            Is_OldItems_Shifted_To_Pkg = 1;
                                    }
                                }

                               // decimal DiscPerc = Util.GetDecimal(AllLoadData_IPD.getIPDPanelDiscPer(Util.GetInt(PanelId), Util.GetString(Items.Rows[j]["ItemID"]),"I",con));
                                decimal DiscPerc = 0;
                                if (Resources.Resource.IsmembershipInIPD == "1")
                                {
                                    if (PanelId == 1)
                                    {
                                        if (MembershipNo != "")
                                        {
                                            GetDiscount ds = new GetDiscount();
                                            DiscPerc = Util.GetDecimal(ds.GetDefaultDiscount_Membership(Util.GetString(Items.Rows[j]["ItemID"]), MembershipNo, "IPD").Split('#')[0].ToString());
                                        }
                                        else
                                            DiscPerc = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);
                                    }
                                    else
                                        DiscPerc = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);
                                }
                                else
                                    DiscPerc = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);

                                if (DiscPerc > 0)
                                {
                                    decimal GrossAmt = Util.GetDecimal(Items.Rows[j]["Rate"]) * Util.GetDecimal(Items.Rows[j]["Quantity"]);
                                    decimal NetAmount = GrossAmt - ((GrossAmt * DiscPerc) / 100);

                                    objLTDetail.Amount = Util.GetDecimal(NetAmount);
                                    objLTDetail.DiscountPercentage = Util.GetDecimal(DiscPerc);
                                    objLTDetail.DiscAmt = Util.GetDecimal(GrossAmt - NetAmount);
                                    objLTDetail.NetItemAmt = Util.GetDecimal(NetAmount);
                                    objLTDetail.TotalDiscAmt = Util.GetDecimal(GrossAmt - NetAmount);
                                    objLTDetail.DiscountReason = "Panel Wise Discount";
                                    objLTDetail.DiscUserID = UserID;
                                    if(PanelId != 1)
                                    objLTDetail.isPanelWiseDisc = 1;
                                }
                                else
                                {
                                    objLTDetail.DiscountPercentage = Util.GetDecimal(0);
                                    objLTDetail.DiscAmt = 0;
                                    objLTDetail.Amount = Util.GetDecimal(Items.Rows[j]["Rate"]) * Util.GetDecimal(Items.Rows[j]["Quantity"]);
                                    objLTDetail.NetItemAmt = Util.GetDecimal(Items.Rows[j]["Rate"]) * Util.GetDecimal(Items.Rows[j]["Quantity"]);
                                    objLTDetail.TotalDiscAmt = 0;
                                }
                            }
                        }
                    }
                }
                else
                {
                    //Check to see if already added items should be shifted to this item if it is a ipd-package
                    if (Items.Columns.Contains("ConfigID") == false) Items.Columns.Add("ConfigID");
                    Items.Rows[j]["ConfigID"] = objLTDetail.ConfigID;


                    if (Util.GetString(Items.Rows[j]["ConfigID"]) == "14")//ipd-package
                    {
                        if (Is_OldItems_Shifted_To_Pkg == 0)
                        {
                            string str = "Select ItemID from packagemasteripd_details where ItemID='" + Util.GetString(Items.Rows[j]["ItemID"]) + "' and IsActive=1";
                            string PackageID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, str));

                            if (PackageID != "")
                            {
                                if (Util.GetBoolean(StockReports.SentToIPDPackage(TransactionID, Util.GetString(Items.Rows[j]["ItemID"]), Util.GetDateTime(Items.Rows[j]["Date"]), Util.GetInt((Util.GetDateTime(Items.Rows[j]["ToDate"]) - Util.GetDateTime(Items.Rows[j]["FromDate"])).Days), con)))
                                    Is_OldItems_Shifted_To_Pkg = 1;
                            }
                        }
                    }

                 //   decimal ipdPanelDisc = Util.GetDecimal(AllLoadData_IPD.getIPDPanelDiscPer(Util.GetInt(PanelId), Util.GetString(Items.Rows[j]["ItemID"]),"I",con));

                    decimal ipdPanelDisc = 0;
                    
                    if (Resources.Resource.IsmembershipInIPD == "1")
                    {
                        if (PanelId == 1)
                        {
                            if (MembershipNo != "")
                            {
                                GetDiscount ds = new GetDiscount();
                                ipdPanelDisc = Util.GetDecimal(ds.GetDefaultDiscount_Membership(Util.GetString(Items.Rows[j]["ItemID"]), MembershipNo, "IPD").Split('#')[0].ToString());
                            }
                            else
                                ipdPanelDisc = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);
                            
                        }
                        else
                            ipdPanelDisc = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);
                    }
                    else
                        ipdPanelDisc = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);

                    if (ipdPanelDisc > 0)
                    {
                        decimal GrossAmt = Util.GetDecimal(Items.Rows[j]["Rate"]) * Util.GetDecimal(Items.Rows[j]["Quantity"]);
                        decimal NetAmount = GrossAmt - ((GrossAmt * ipdPanelDisc) / 100);

                        objLTDetail.Amount = Util.GetDecimal(NetAmount);
                        objLTDetail.DiscountPercentage = Util.GetDecimal(ipdPanelDisc);
                        objLTDetail.DiscAmt = Util.GetDecimal(GrossAmt - NetAmount);
                        objLTDetail.TotalDiscAmt = Util.GetDecimal(GrossAmt - NetAmount);
                        objLTDetail.NetItemAmt = NetAmount;
                        objLTDetail.DiscountReason = "Panel Wise Discount";
                        objLTDetail.DiscUserID = UserID;
                        if(PanelId != 1)
                        objLTDetail.isPanelWiseDisc = 1;
                    }
                    else
                    {
                        objLTDetail.DiscountPercentage = Util.GetDecimal(0);
                        objLTDetail.DiscAmt = 0;
                        if (Items.Rows[j]["ItemID"].ToString() == "LSHHI29401")
                        {
                            objLTDetail.Amount = Util.GetDecimal(Items.Rows[j]["Rate"]) * Util.GetDecimal(Items.Rows[j]["Quantity"]) * Util.GetDecimal(-1);
                            objLTDetail.NetItemAmt = objLTDetail.Amount;
                        }
                        else
                        {
                            objLTDetail.Amount = Util.GetDecimal(Items.Rows[j]["Rate"]) * Util.GetDecimal(Items.Rows[j]["Quantity"]);
                            objLTDetail.NetItemAmt = objLTDetail.Amount;
                        }

                        objLTDetail.TotalDiscAmt = 0;

                    }
                }


                objLTDetail.IsPayable = Util.GetInt(dataTableCoPayDiscont.Rows[0]["IsPayble"]);
                objLTDetail.CoPayPercent = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDCoPayPercent"]);
                objLTDetail.StockID = "";
                objLTDetail.IsTaxable = "NO";
                objLTDetail.EntryDate = Util.GetDateTime(Items.Rows[j]["Date"].ToString());
                objLTDetail.TransactionID = TransactionID;
                objLTDetail.UserID = UserID;
                objLTDetail.IsVerified = Util.GetInt(IsVerified);
                objLTDetail.ItemName = Items.Rows[j]["ItemDisplayName"].ToString() + "   " + Items.Rows[j]["ItemCode"].ToString();
                objLTDetail.SubCategoryID = Items.Rows[j]["SubCategoryID"].ToString();
                objLTDetail.DoctorID = Items.Rows[j]["DoctorID"].ToString();
                objLTDetail.DoctorCharges = Util.GetDecimal(Items.Rows[j]["DocCharges"].ToString());

                objLTDetail.pageURL = All_LoadData.getCurrentPageName();
                objLTDetail.IPDCaseTypeID = IPDCaseType_ID;
                objLTDetail.RateListID = Util.GetInt(Items.Rows[j]["RateListID"].ToString());
                objLTDetail.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                objLTDetail.Type = "I";
                objLTDetail.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                objLTDetail.IpAddress = HttpContext.Current.Request.UserHostAddress;

                objLTDetail.VarifiedUserID = UserID;
                objLTDetail.VerifiedDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                objLTDetail.rateItemCode = Items.Rows[j]["ItemCode"].ToString();
                objLTDetail.RoomID = Room_ID;
                objLTDetail.typeOfTnx = TypeOfTransaction;
                objLTDetail.Insert();

                Items.Rows[j]["LedgerTransactionNo"] = LedTxnID;
            }

            return Items;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.Equals(ex);
            return null;
        }
    }
    public static Boolean UpdateVerifiedItems(DataTable Items, string DiscountReason, string UserID, string ApprovalBy)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.ReadCommitted);
        try
        {
            AllUpdate AU = new AllUpdate(tnx);

            for (int j = 0; j < Items.Rows.Count; j++)
            {
                AU.UpdateLedgerTranDetailWithDiscountAmount(Items.Rows[j]["LTDetailID"].ToString(), Util.GetDecimal(Items.Rows[j]["DiscountPercentage"].ToString()), Util.GetDecimal(Items.Rows[j]["Amount"].ToString()), DiscountReason, UserID, ApprovalBy, Util.GetDecimal(Items.Rows[j]["DiscountAmount"].ToString()));

            }

            tnx.Commit();
            con.Close();
            con.Dispose();
            return true;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            con.Close();
            con.Dispose();
            return false;
        }
    }
    public int updateICH(int IPDCaseHistory_ID, DateTime DateOfDischarge, DateTime TimeOfDischarge, MySqlTransaction objtnx, String UserID)
    {
        int RowUpdated = 0;

        try
        {
            AllUpdate AU = new AllUpdate(objtnx);
            RowUpdated = AU.UpdateIPDCaseTypeHistoryOnDischarge(IPDCaseHistory_ID, DateOfDischarge, TimeOfDischarge, UserID);

            if (RowUpdated == 0)
            {
                return 0;
            }
            return RowUpdated;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return 0;
        }
    }
    public int updatePIP(int PatientIPDProfile_ID, DateTime Enddate, DateTime EndTime, MySqlTransaction objtnx)
    {
        int RowUpdated = 0;

        try
        {
            AllUpdate AU = new AllUpdate(objtnx);
            RowUpdated = AU.UpdatePIPOnDischarge(PatientIPDProfile_ID, Enddate, EndTime);

            if (RowUpdated == 0)
            {
                return 0;
            }
            return RowUpdated;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return 0;
        }

    }
    public static DataTable getPatientHeaderForReport(string PatientID, string TransactionID)
    {
        //PatientName,PatientID,TansactionID,Address,Age,Sex,Sponsor Company,AdmitDate,DischargeDate,Admit Bed,Discharge Bed,Status(Admited/Discharged),DocsultantID1/2 and consultant Names
        AllQuery AQ = new AllQuery();
        DataTable dtPatientInfo = AQ.GetPatientDetail(PatientID);
        DataTable dtAdmitDischarge = AQ.getPatientAdmitDischarge(TransactionID);
        DataTable dtBedShift = AQ.getAdmitPatientBedShiftingDetails(TransactionID);
        DataTable dtPanelCompany = AQ.GetPanelByID(dtBedShift.Rows[0]["PanelID"].ToString());
        string DischargeType = AQ.GetDischargetypeByTransactionID(TransactionID);
        string BillDate = AQ.GetBillDateByTransactionID(TransactionID);

        DataTable dtResultant = new DataTable();
        dtResultant.Columns.Add("PatientName");
        dtResultant.Columns.Add("PatientID");
        dtResultant.Columns.Add("HouseNo");
        //dtResultant.Columns.Add("Locality");
        dtResultant.Columns.Add("Street_Name");
        dtResultant.Columns.Add("City");
        dtResultant.Columns.Add("State");
        dtResultant.Columns.Add("Country");
        //dtResultant.Columns.Add("Pincode");
        dtResultant.Columns.Add("Age");
        dtResultant.Columns.Add("Sex");
        dtResultant.Columns.Add("TransactionID");
        dtResultant.Columns.Add("Sponsor");
        dtResultant.Columns.Add("AdmitDate");
        dtResultant.Columns.Add("AdmitTime");
        dtResultant.Columns.Add("AdmitBed");
        dtResultant.Columns.Add("DischargeDate");
        dtResultant.Columns.Add("DischargeTime");
        dtResultant.Columns.Add("DischargeBed");
        dtResultant.Columns.Add("Status");
        dtResultant.Columns.Add("Cunsultant1");
        dtResultant.Columns.Add("Cunsultant2");
        dtResultant.Columns.Add("BillNo");
        dtResultant.Columns.Add("Dischargetype");
        dtResultant.Columns.Add("BillDate");
        dtResultant.Columns.Add("Mobile");
        DataRow drResult = dtResultant.NewRow();
        DataTable dtBill = AQ.GetBillDetail("", "", TransactionID);

        if (dtBill != null && dtBill.Rows.Count > 0)
        {
            drResult["BillNo"] = dtBill.Rows[0]["BillNo"].ToString();
        }
        else
        {
            drResult["BillNo"] = "";
        }
        //drResult["BillNo"] = AQ.GetBillDetail("", "", TransactionID).Rows[0]["BillNo"].ToString();


        drResult["PatientName"] = dtPatientInfo.Rows[0]["Pname"].ToString();
        drResult["PatientID"] = dtPatientInfo.Rows[0]["PatientID"].ToString();
        drResult["HouseNo"] = dtPatientInfo.Rows[0]["House_No"].ToString();
        //drResult["Locality"] = dtPatientInfo.Rows[0]["Locality"].ToString();
        drResult["Street_Name"] = dtPatientInfo.Rows[0]["Street_Name"].ToString();
        drResult["City"] = dtPatientInfo.Rows[0]["City"].ToString();
        drResult["State"] = dtPatientInfo.Rows[0]["State"].ToString();
        drResult["Country"] = dtPatientInfo.Rows[0]["Country"].ToString();
        //drResult["Pincode"] = dtPatientInfo.Rows[0]["Pincode"].ToString();
        drResult["Age"] = dtPatientInfo.Rows[0]["Age"].ToString();
        drResult["Sex"] = dtPatientInfo.Rows[0]["Gender"].ToString();
        drResult["Sponsor"] = dtPanelCompany.Rows[0]["Name"];
        drResult["TransactionID"] = TransactionID;
        drResult["AdmitDate"] = dtAdmitDischarge.Rows[0]["AdmitDate"].ToString();
        drResult["AdmitTime"] = dtAdmitDischarge.Rows[0]["TimeOfAdmit"].ToString();
        drResult["DischargeDate"] = dtAdmitDischarge.Rows[0]["DischargeDate"].ToString();
        drResult["DischargeTime"] = dtAdmitDischarge.Rows[0]["TimeOfDischarge"].ToString();
        drResult["Status"] = dtAdmitDischarge.Rows[0]["Status"].ToString();
        drResult["Cunsultant1"] = dtAdmitDischarge.Rows[0]["name"].ToString();
        if (dtAdmitDischarge.Rows.Count > 1)
        {
            drResult["Cunsultant2"] = dtAdmitDischarge.Rows[1]["name"].ToString();
        }
        else
        {
            drResult["Cunsultant2"] = "";
        }
        string AdmitDate = "StartDate = '" + dtAdmitDischarge.Rows[0]["AdmitDate"].ToString() + "'";
        string AdmitTime = "StartTime='" + dtAdmitDischarge.Rows[0]["TimeOfAdmit"].ToString() + "'";
        drResult["AdmitBed"] = dtBedShift.Rows[0]["BedCategory"].ToString() + "--" + dtBedShift.Rows[0]["Room"].ToString();
        drResult["DischargeBed"] = dtBedShift.Rows[(dtBedShift.Rows.Count - 1)]["BedCategory"].ToString() + "--" + dtBedShift.Rows[(dtBedShift.Rows.Count - 1)]["Room"].ToString();
        drResult["Dischargetype"] = DischargeType;
        drResult["BillDate"] = BillDate;
        drResult["Mobile"] = dtPatientInfo.Rows[0]["Mobile"].ToString();
        dtResultant.Rows.Add(drResult);
        return dtResultant;

    }
    public static DataTable getPatientHeaderForReport1(string PatientID, string TransactionID)
    {
        AllQuery AQ = new AllQuery();
        DataTable dtPatientInfo = AQ.GetPatientDetail(PatientID);
        DataTable dtAdmitDischarge = AQ.getPatientAdmitDischarge(TransactionID);
        DataTable dtBedShift = AQ.getAdmitPatientBedShiftingDetails(TransactionID);
        DataTable DischargeType = AQ.GetDischargetypeKinNameByTransactionID(TransactionID);
        DataTable dtPanelCompany = AQ.GetPanelByID(DischargeType.Rows[0]["PanelID"].ToString());
        string BillDate = AQ.GetBillDateByTransactionID(TransactionID);

        DataTable dtResultant = new DataTable();
        dtResultant.Columns.Add("PatientName");
        dtResultant.Columns.Add("PatientID");
        dtResultant.Columns.Add("KinRelation");
        dtResultant.Columns.Add("KinName");
        dtResultant.Columns.Add("HouseNo");
        //dtResultant.Columns.Add("Locality");
        dtResultant.Columns.Add("Street_Name");
        dtResultant.Columns.Add("City");
        dtResultant.Columns.Add("State");
        dtResultant.Columns.Add("Country");
        //dtResultant.Columns.Add("Pincode");
        dtResultant.Columns.Add("Age");
        dtResultant.Columns.Add("Sex");
        dtResultant.Columns.Add("TransactionID");
        dtResultant.Columns.Add("Sponsor");
        dtResultant.Columns.Add("AdmitDate");
        dtResultant.Columns.Add("AdmitTime");
        dtResultant.Columns.Add("AdmitBed");
        dtResultant.Columns.Add("DischargeDate");
        dtResultant.Columns.Add("DischargeTime");
        dtResultant.Columns.Add("DischargeBed");
        dtResultant.Columns.Add("Status");
        dtResultant.Columns.Add("Cunsultant1");
        dtResultant.Columns.Add("Cunsultant2");
        dtResultant.Columns.Add("BillNo");
        dtResultant.Columns.Add("Dischargetype");
        dtResultant.Columns.Add("BillDate");
        dtResultant.Columns.Add("Mobile");
        dtResultant.Columns.Add("Relation");
        dtResultant.Columns.Add("RelationName");


        dtResultant.Columns.Add("Employeeid");
        dtResultant.Columns.Add("EmployeeDependentName");
        dtResultant.Columns.Add("DependentRelation");
        dtResultant.Columns.Add("PolicyNo");
        dtResultant.Columns.Add("CardNo");
        dtResultant.Columns.Add("ClaimNo");
        dtResultant.Columns.Add("CardHolderName");
        dtResultant.Columns.Add("RelationWith_holder");
        dtResultant.Columns.Add("FileNo");

        DataRow drResult = dtResultant.NewRow();
        drResult["PatientName"] = dtPatientInfo.Rows[0]["Pname"].ToString();
        drResult["PatientID"] = dtPatientInfo.Rows[0]["PatientID"].ToString();
        drResult["HouseNo"] = dtPatientInfo.Rows[0]["House_No"].ToString();
        //drResult["Locality"] = dtPatientInfo.Rows[0]["Locality"].ToString();
        drResult["Street_Name"] = dtPatientInfo.Rows[0]["Street_Name"].ToString();
        drResult["City"] = dtPatientInfo.Rows[0]["City"].ToString();
        drResult["State"] = dtPatientInfo.Rows[0]["State"].ToString();
        drResult["Country"] = dtPatientInfo.Rows[0]["Country"].ToString();
        //drResult["Pincode"] = dtPatientInfo.Rows[0]["Pincode"].ToString();
        drResult["Age"] = dtPatientInfo.Rows[0]["Age"].ToString();
        drResult["Sex"] = dtPatientInfo.Rows[0]["Gender"].ToString();
        drResult["Sponsor"] = dtPanelCompany.Rows[0]["Name"];
        drResult["TransactionID"] = StockReports.getTransNobyTransactionID(TransactionID);
        drResult["AdmitDate"] = dtAdmitDischarge.Rows[0]["AdmitDate"].ToString();
        drResult["AdmitTime"] = dtAdmitDischarge.Rows[0]["TimeOfAdmit"].ToString();
        drResult["DischargeDate"] = dtAdmitDischarge.Rows[0]["DischargeDate"].ToString();
        drResult["DischargeTime"] = dtAdmitDischarge.Rows[0]["TimeOfDischarge"].ToString();
        drResult["Status"] = dtAdmitDischarge.Rows[0]["Status"].ToString();
        drResult["Cunsultant1"] = dtAdmitDischarge.Rows[0]["name"].ToString();
        drResult["Mobile"] = dtPatientInfo.Rows[0]["Mobile"].ToString();
        drResult["Relation"] = dtPatientInfo.Rows[0]["Relation"].ToString();
        drResult["RelationName"] = dtPatientInfo.Rows[0]["RelationName"].ToString();
        drResult["Employeeid"] = DischargeType.Rows[0]["Employeeid"].ToString();
        drResult["EmployeeDependentName"] = DischargeType.Rows[0]["EmployeeDependentName"].ToString();
        drResult["DependentRelation"] = DischargeType.Rows[0]["DependentRelation"].ToString();
        drResult["PolicyNo"] = DischargeType.Rows[0]["PolicyNo"].ToString();
        drResult["CardNo"] = DischargeType.Rows[0]["CardNo"].ToString();
        drResult["CardHolderName"] = DischargeType.Rows[0]["CardHolderName"].ToString();
        drResult["RelationWith_holder"] = DischargeType.Rows[0]["RelationWith_holder"].ToString();
        drResult["FileNo"] = DischargeType.Rows[0]["FileNo"].ToString();

        if (dtAdmitDischarge.Rows.Count > 1)
        {
            drResult["Cunsultant2"] = dtAdmitDischarge.Rows[1]["name"].ToString();
        }
        else
        {
            drResult["Cunsultant2"] = "";
        }
        string AdmitDate = "StartDate = '" + dtAdmitDischarge.Rows[0]["AdmitDate"].ToString() + "'";
        string AdmitTime = "StartTime='" + dtAdmitDischarge.Rows[0]["TimeOfAdmit"].ToString() + "'";
     //   drResult["AdmitBed"] = dtBedShift.Rows[0]["BedCategory"].ToString() + "--" + dtBedShift.Rows[0]["Room"].ToString();
        drResult["AdmitBed"] =dtBedShift.Rows[0]["Room"].ToString();
        //drResult["DischargeBed"] = dtBedShift.Rows[(dtBedShift.Rows.Count - 1)]["BedCategory"].ToString() + "--" + dtBedShift.Rows[(dtBedShift.Rows.Count - 1)]["Room"].ToString();

        drResult["DischargeBed"] =  dtBedShift.Rows[(dtBedShift.Rows.Count - 1)]["Room"].ToString();

        if (DischargeType != null || DischargeType.Rows.Count > 0)
        {
            drResult["Dischargetype"] = DischargeType.Rows[0]["DischargeType"].ToString();
            drResult["KinRelation"] = dtPatientInfo.Rows[0]["Relation"].ToString();
            drResult["KinName"] = dtPatientInfo.Rows[0]["RelationName"].ToString();

        }
        drResult["BillDate"] = BillDate;

        dtResultant.Rows.Add(drResult);
        return dtResultant;

    }
    public static DataTable GetCopayAmount(string TrnxID, int IsBaseBill, int IsDummy)
    {
        try
        {
            DataTable dtCopayDetail = new DataTable();

            //if (IsDummy == 1)
            //{
            //    dtCopayDetail = StockReports.GetDataTable("CALL GetDummyIPDPatientPanel_Copay_Payble('" + TrnxID + "')");
            //}
            //else
            //{
            //    dtCopayDetail = StockReports.GetDataTable("CALL GetIPDPatientPanel_Copay_Payble('" + TrnxID + "'," +IsDummy + ")");
            //}

            dtCopayDetail = StockReports.GetDataTable("CALL GetIPDPatientPanel_Copay_Payble('" + TrnxID + "'," + IsDummy + "," +  IsBaseBill + ")");

   
            return dtCopayDetail;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }



    //Discharge Process Work has been modified by Manesh unsed the Supervision of Sunil Sir....
    public static string ValidateDischargeSteps(int CurrentStepId, string TID)
    {

        int validateStepId = Util.GetInt(StockReports.ExecuteScalar(" SELECT id FROM `discharge_process_master` WHERE IsActive=1 AND sequenceNo<(SELECT sequenceNo FROM discharge_process_master WHERE id=" + CurrentStepId + ") ORDER BY sequenceNo DESC LIMIT 1"));
        if (validateStepId == (int)AllGlobalFunction.DischargeProcessStep.PatientAdmission)
        {
            return string.Empty;
        }
        else if (validateStepId == (int)AllGlobalFunction.DischargeProcessStep.FinalDoctorVisit)
        {
            int IsDoctorVisit = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM `f_ledgertnxdetail` ltd WHERE ltd.`ConfigID`='1' AND ltd.`IsVerified`=1 AND ltd.`TransactionID`='" + TID + "' "));
            if (IsDoctorVisit > 0)
                return string.Empty;
            else
                return "Please Add at least One IPD Consultation Visit In Patinet Bill First.";
        }
        else if (validateStepId == (int)AllGlobalFunction.DischargeProcessStep.DischargeSummaryPrepared)
        {
            int IsExist = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM emr_ipd_details WHERE TransactionID='" + TID + "' "));
            if (IsExist > 0)
                return string.Empty;
            else
                return "Please Prepare Discharge Summary First.";
        }
        else if (validateStepId == (int)AllGlobalFunction.DischargeProcessStep.DischargeSummaryApproved)
        {
            int IsApproved = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM emr_ipd_details WHERE TransactionID='" + TID + "' AND Approved=1 "));
            if (IsApproved > 0)
                return string.Empty;
            else
                return "Please Approve Discharge Summary First.";
        }
        else if (validateStepId == (int)AllGlobalFunction.DischargeProcessStep.DischargeIntimation)
        {
            int IsDischargeIntimate = Util.GetInt(StockReports.ExecuteScalar("SELECT IsDischargeIntimate FROM patient_medical_history WHERE TransactionID='" + TID + "' "));//ipd_case_history
            if (IsDischargeIntimate > 0)
                return string.Empty;
            else
                return "Please Discharge Intimate First.";
        }
        else if (validateStepId == (int)AllGlobalFunction.DischargeProcessStep.MedicalClearance)
        {
            int IsMedCleared = Util.GetInt(StockReports.ExecuteScalar(" SELECT IsMedCleared FROM patient_medical_history WHERE TransactionID='" + TID + "'  "));//f_ipdadjustment
            if (IsMedCleared > 0)
                return string.Empty;
            else
                return "Please Medicine Clearance First.";
        }
        else if (validateStepId == (int)AllGlobalFunction.DischargeProcessStep.BillFreeze)
        {
            int IsBillFreezed = Util.GetInt(StockReports.ExecuteScalar(" SELECT ifnull(IsBillFreezed,0) FROM patient_medical_history WHERE  TransactionID='" + TID + "' "));//f_ipdadjustment
            if (IsBillFreezed > 0)
                return string.Empty;
            else
                return "Please Bill Freezed First.";
        }
        else if (validateStepId == (int)AllGlobalFunction.DischargeProcessStep.Discharge)
        {
            string Status = Util.GetString(StockReports.ExecuteScalar(" select  Status from patient_medical_history where TransactionID='" + TID + "' "));//ipd_case_history
            if (Status.ToUpper() == "OUT")
                return string.Empty;
            else
                return "Please Discharge the Patient First.";
        }
        else if (validateStepId == (int)AllGlobalFunction.DischargeProcessStep.BillGenerate)
        {
            string BillNo = Util.GetString(StockReports.ExecuteScalar(" SELECT IFNULL(adj.`BillNo`,'') FROM `patient_medical_history` adj WHERE adj.`TransactionID`='" + TID + "' "));//f_ipdadjustment
            if (!String.IsNullOrEmpty(BillNo))
                return string.Empty;
            else
                return "Please Generate Bill First.";
        }
        else if (validateStepId == (int)AllGlobalFunction.DischargeProcessStep.PatientClearance)
        {
            int IsClear = Util.GetInt(StockReports.ExecuteScalar(" SELECT IsClearance FROM patient_medical_history  WHERE TransactionID='" + TID + "'  "));//f_ipdadjustment
            if (IsClear > 0)
                return string.Empty;
            else
                return "Please Patient Clearance First.";
        }
        else if (validateStepId == (int)AllGlobalFunction.DischargeProcessStep.NursingClearance)
        {
            int IsNurseClear = Util.GetInt(StockReports.ExecuteScalar(" SELECT IsNurseClean FROM patient_medical_history WHERE TransactionID='" + TID + "'  "));//f_ipdadjustment
            if (IsNurseClear > 0)
                return string.Empty;
            else
                return "Please Nursing Clearance First.";
        }
        else if (validateStepId == (int)AllGlobalFunction.DischargeProcessStep.RoomClearance)
        {
            int IsRoomClear = Util.GetInt(StockReports.ExecuteScalar(" SELECT IsRoomClean FROM patient_medical_history WHERE TransactionID='" + TID + "'  "));//f_ipdadjustment
            if (IsRoomClear > 0)
                return string.Empty;
            else
                return "Please Room Clearance First.";
        }
        else
            return string.Empty;
    }
    public static string getDischargeSkipSteps(MySqlTransaction tnx, int CurrentStepId)
    {
        int sequenceNo =Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, " SELECT sequenceNo FROM discharge_process_master WHERE ID="+CurrentStepId+" "));

        int lastSequenceNo = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT MAX(sequenceNo) FROM discharge_process_master "));

        if (sequenceNo == lastSequenceNo)
            return Util.GetString(CurrentStepId);
        
        string skipStepIDs = string.Empty;
        for (int i = sequenceNo; i < 20; i++)
        {
            sequenceNo++;
            DataTable dtNextStepDetails = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, " SELECT ID,IsActive FROM discharge_process_master WHERE sequenceNo=" + sequenceNo + " ").Tables[0];
            if (dtNextStepDetails.Rows.Count == 0)
                break;
            else if (Util.GetInt(dtNextStepDetails.Rows[0]["IsActive"]) == 1)
                break;
            else
                if (String.IsNullOrEmpty(skipStepIDs))
                    skipStepIDs = dtNextStepDetails.Rows[0]["ID"].ToString();
                else
                    skipStepIDs += "," + dtNextStepDetails.Rows[0]["ID"].ToString();
        }
        return skipStepIDs;
    }

}
