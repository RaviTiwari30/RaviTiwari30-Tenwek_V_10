using System;
using System.Data;
using System.Web;
using MySql.Data.MySqlClient;
using System.Text;

/// <summary>
/// Summary description for RoomBilling
/// </summary>
public class RoomBilling
{
    public RoomBilling()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    // Get Vacant Rooms ....

    public static DataTable GetAvailRooms(string IPDCaseTypeID)
    {
        AllSelectQuery ASQ = new AllSelectQuery();
        DataTable dtAvailRooms = ASQ.GetAvailRooms(IPDCaseTypeID);
        return dtAvailRooms;
    }
    public static DataTable GetAdmittedPatient()
    {
        AllSelectQuery ASQ = new AllSelectQuery();
        DataTable dtPatient = ASQ.GetAdmittedPatient();
        return dtPatient;
    }
    public static bool ShiftPatient(string TransactionID, string PatientID, string NewRoomID, string OldRoomID, string NewIPDCaseTypeID, int PanelID, string HospID, string NewRoom, string UserID, string ShiftingDate)
    {
        int flag = 0;
        MySqlConnection conn = Util.GetMySqlCon();
        conn.Open();
        MySqlTransaction Tnx = conn.BeginTransaction(IsolationLevel.ReadCommitted);
        try
        {
            AllUpdate AU = new AllUpdate(Tnx);
            flag = AU.UpdateToBeBilled(TransactionID, OldRoomID);

            int ScheduleChargeID = Util.GetInt(StockReports.GetCurrentRateScheduleID(PanelID));
            if (flag == 1)
            {
                flag = 0;
                flag = AU.UpdateRoomStatus(OldRoomID, NewRoomID, TransactionID);
                if (flag == 1)
                {
                    RoomBilling ObjRoomBl = new RoomBilling();
                    string ItemDetail = ObjRoomBl.GetRoomItemDetails(PanelID, NewIPDCaseTypeID, ScheduleChargeID);
                    string ItemID = Util.GetString(ItemDetail.Split('#')[0]);
                    decimal Rate = Util.GetDecimal(ItemDetail.Split('#')[1]);
                    string SubCategoryID = Util.GetString(ItemDetail.Split('#')[2]);

                    decimal TotalAmt = 0;
                    Patient_IPD_Profile ObjPIP = new Patient_IPD_Profile(Tnx);

                    ObjPIP.TransactionID = TransactionID;
                    ObjPIP.IPDCaseTypeID = NewIPDCaseTypeID;
                    ObjPIP.RoomID = NewRoomID;
                    ObjPIP.StartDate = Util.GetDateTime(ShiftingDate);
                    ObjPIP.StartTime = DateTime.Now;
                    ObjPIP.Status = "IN";
                    ObjPIP.IsTempAllocated = 0;
                    ObjPIP.PanelID = PanelID;
                    ObjPIP.PatientID = PatientID;
                    ObjPIP.TobeBill = 1;
                    ObjPIP.Insert();

                    Ledger_Transaction ObjLdgTnx = new Ledger_Transaction(Tnx);
                    ObjLdgTnx.Hospital_ID = HospID;
                    ObjLdgTnx.LedgerNoCr = AllQuery.GetLedgerNoByLedgerUserID(PatientID, conn);
                    ObjLdgTnx.LedgerNoDr = AllQuery.GetLedgerNoByLedgerUserID(HospID, conn);
                    ObjLdgTnx.TypeOfTnx = "IPD-Shift";
                    ObjLdgTnx.Date = DateTime.Now;
                    ObjLdgTnx.Time = DateTime.Now;
                    ObjLdgTnx.BillNo = "";
                    ObjLdgTnx.NetAmount = Util.GetDecimal(TotalAmt);
                    ObjLdgTnx.GrossAmount = Util.GetDecimal(TotalAmt);
                    ObjLdgTnx.PatientID = PatientID;
                    ObjLdgTnx.PanelID = PanelID;
                    ObjLdgTnx.TransactionID = TransactionID;
                    ObjLdgTnx.UserID = UserID;
                    ObjLdgTnx.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    ObjLdgTnx.IpAddress = HttpContext.Current.Request.UserHostAddress;

                    string LedgerTransactionNo = ObjLdgTnx.Insert();

                    if (Util.GetString(LedgerTransactionNo) != "")
                    {
                        LedgerTnxDetail ObjLdgTnxDtl = new LedgerTnxDetail(Tnx);
                        ObjLdgTnxDtl.Hospital_Id = HospID;
                        ObjLdgTnxDtl.LedgerTransactionNo = LedgerTransactionNo;
                        ObjLdgTnxDtl.Amount = Util.GetDecimal(TotalAmt);
                        ObjLdgTnxDtl.ItemID = ItemID;
                        ObjLdgTnxDtl.Rate = Util.GetDecimal(Rate);
                        ObjLdgTnxDtl.Quantity = 1;
                        ObjLdgTnxDtl.StockID = "";
                        ObjLdgTnxDtl.IsTaxable = "";
                        ObjLdgTnxDtl.DiscountPercentage = Util.GetDecimal(0.00);
                        ObjLdgTnxDtl.IsPackage = 0;
                        ObjLdgTnxDtl.PackageID = "NO";
                        ObjLdgTnxDtl.TransactionID = TransactionID;
                        ObjLdgTnxDtl.SubCategoryID = SubCategoryID;
                        ObjLdgTnxDtl.ItemName = NewRoom;
                        ObjLdgTnxDtl.UserID = UserID;
                        ObjLdgTnxDtl.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(SubCategoryID), conn));
                        ObjLdgTnxDtl.NetItemAmt = Util.GetDecimal(TotalAmt);
                        ObjLdgTnxDtl.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                        ObjLdgTnxDtl.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                        ObjLdgTnxDtl.Type = "I";
                        ObjLdgTnxDtl.IpAddress = HttpContext.Current.Request.UserHostAddress;

                        int LdgTnxDtlID = ObjLdgTnxDtl.Insert();

                        if (Util.GetInt(LdgTnxDtlID) == 0)
                        {
                            Tnx.Rollback();
                            conn.Close();
                            conn.Dispose();
                            Tnx.Dispose();
                            return false;
                        }
                    }
                    else
                    {
                        Tnx.Rollback();
                        conn.Close();
                        conn.Dispose();
                        Tnx.Dispose();
                        return false;
                    }
                }
                else
                {
                    Tnx.Rollback();
                    conn.Close();
                    conn.Dispose();
                    Tnx.Dispose();
                    return false;
                }
            }
            else
            {
                Tnx.Rollback();
                conn.Close();
                conn.Dispose();
                Tnx.Dispose();
                return false;
            }

            Tnx.Commit();
            conn.Close();
            conn.Dispose();
            Tnx.Dispose();
            return true;
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            conn.Close();
            conn.Dispose();
            Tnx.Dispose();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return false;
        }

    }

    public static bool ShiftRoom(string TransactionID, string PatientID, string CurrentIPDCaseTypeID, string OldRoomID, string NewIPDCaseTypeID, string NewRoomID, string IsTemp)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();

        DataTable dtOldCaseType = MySqlHelper.ExecuteDataset(con, CommandType.Text, "select TransactionID,IPDCaseTypeID,Room_ID,StartDate,StartTime,PanelID,PatientID,TOBEBILL,PanelID from patient_ipd_profile where status='IN' and TransactionID='" + TransactionID + "' and IPDCaseTypeID='" + CurrentIPDCaseTypeID + "'").Tables[0];

        AllQuery AQ2 = new AllQuery(tnx);
        try
        {
            Patient_IPD_Profile newIPDCaseAllocation = new Patient_IPD_Profile(tnx);
            newIPDCaseAllocation.PatientIPDProfile_ID = Util.GetInt(NewIPDCaseTypeID);
            newIPDCaseAllocation.RoomID = NewRoomID;
            newIPDCaseAllocation.StartDate = DateTime.Now;
            newIPDCaseAllocation.StartTime = DateTime.Now;
            if (IsTemp != "1")
            {
                newIPDCaseAllocation.Status = "IN";
                AQ2.UpdateAfterRoomShift(TransactionID, CurrentIPDCaseTypeID, con, tnx);
                AQ2.UpdateTempAllocatedRoom(CurrentIPDCaseTypeID, OldRoomID, con, tnx);
            }
            else
            {
                newIPDCaseAllocation.IsTempAllocated = 1;
            }
            newIPDCaseAllocation.TransactionID = TransactionID;
            newIPDCaseAllocation.TransactionID = TransactionID;
            newIPDCaseAllocation.Insert();

            tnx.Commit();
            return false;
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return false;
        }
        finally
        {
            tnx.Rollback();
            con.Close();
            con.Dispose();
        }
    }
    public string GetRoomItemDetails(int PanelID, string OLDIPDCaseTypeID, int ScheduleChargeID)
    {
        AllSelectQuery ASQ = new AllSelectQuery();
        string Data = ASQ.GetRoomDetails(PanelID, OLDIPDCaseTypeID, ScheduleChargeID);
        return Data;
    }
    public string GetRoomItemDetails(int PanelID, string NewIPDCaseTypeID, string NewRoomID)
    {
        AllSelectQuery ASQ_1 = new AllSelectQuery();
        string NewItemID = "", Rate = "";
        NewItemID = ASQ_1.GetItemID(NewRoomID);
        AllSelectQuery ASQ_2 = new AllSelectQuery();
        Rate = ASQ_2.GetRoomRate2(NewItemID, PanelID, NewIPDCaseTypeID);
        return (NewItemID + '#' + Rate);
    }
    public string UpdatePatientIPDProfile(string TransactionID, string IPDCaseType_ID, string IPDCaseType_ID_Bill, int IsTempAllocated, string OldRoom_ID, string NewRoom_ID, int PanelID, string PatientID, string StartDate, string StartTime, int PermanentFlag, MySqlTransaction Tnx)
    {
        try
        {
            AllUpdatesQuery updatestr = new AllUpdatesQuery(Tnx);
            Patient_IPD_Profile objIPD = new Patient_IPD_Profile(Tnx);
            string update = updatestr.UpdatePatientProfile(TransactionID, OldRoom_ID, PermanentFlag, StartDate, StartTime);

            if (update == "1" && PermanentFlag == 0)
            {
                objIPD.TransactionID = TransactionID;
                objIPD.TobeBill = 1;
                objIPD.StartDate = Util.GetDateTime(StartDate);
                objIPD.StartTime = Util.GetDateTime(StartTime);
                objIPD.IPDCaseTypeID = IPDCaseType_ID;
                objIPD.IPDCaseTypeID_Bill = IPDCaseType_ID_Bill;
                objIPD.RoomID = NewRoom_ID;
                objIPD.IsTempAllocated = IsTempAllocated;
                objIPD.PanelID = PanelID;
                objIPD.PatientID = PatientID;
                update = objIPD.Insert().ToString();
            }
            else if (update == "1" && PermanentFlag == 1)
            {

                objIPD.TransactionID = TransactionID;
                objIPD.TobeBill = 1;
                objIPD.Status = "IN";
                objIPD.StartDate = Util.GetDateTime(StartDate);
                objIPD.StartTime = Util.GetDateTime(StartTime);
                objIPD.IPDCaseTypeID = IPDCaseType_ID;
                objIPD.IPDCaseTypeID_Bill = IPDCaseType_ID_Bill;
                objIPD.RoomID = NewRoom_ID;
                objIPD.IsTempAllocated = 0;
                objIPD.PanelID = PanelID;
                objIPD.PatientID = PatientID;
                update = objIPD.Insert().ToString();
            }
            string strGetOldPatient = "select * from patient_ipd_profile where Room_ID='" + OldRoom_ID + "' and IsTempAllocated=1  and ToBeBill=1";
            DataSet dsOld = MySqlHelper.ExecuteDataset(Tnx, CommandType.Text, strGetOldPatient);
            if (dsOld.Tables[0].Rows.Count > 0)
            {
                string strUpd1 = "update patient_ipd_profile set Status='OUT',EndDate='" + DateTime.Now.ToString("yyyy-MM-dd") + "',EndTime='" + DateTime.Now.ToString("HH:mm:ss") + "' where TransactionID='" + dsOld.Tables[0].Rows[0]["TransactionID"] + "' and status ='IN'";
                string strUpd2 = "update patient_ipd_profile set Status='IN',IsTempAllocated=0 where TransactionID='" + dsOld.Tables[0].Rows[0]["TransactionID"] + "' and IsTempAllocated=1";
                int i = MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, strUpd1);
                i = MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, strUpd2);
            }

            if (update == "0")
            {
                return "0";
            }
            else
            {
                return "1";
            }

        }
        catch (Exception ex)
        {
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return "0";
        }

    }

    public static DataTable GetAdmittedPatient(string IPDCaseTypeID)
    {
        AllSelectQuery ASQ = new AllSelectQuery();
        DataTable dtPatient = ASQ.GetAdmittedPatient(IPDCaseTypeID);
        return dtPatient;
    }
    public string RoomBill(string Hospital_ID, string TransactionID, string PatientID, string SubCategory_ID, string User_ID, int PanelID, string Item_ID, string ItemName, string BillingRoomName, decimal TotalBillAmount, string StartDate, string StartTime, string BufferTime, string SiftDate, MySqlTransaction Tnx, string IPDCaseType_ID, int rateListID, string PatientType, MySqlConnection con, string DoctorID,string Room_ID)
    {
        try
        {


            Ledger_Transaction ObjLdgTnx = new Ledger_Transaction(Tnx);
            ObjLdgTnx.Hospital_ID = Hospital_ID;
            ObjLdgTnx.LedgerNoCr = AllQuery.GetLedgerNoByLedgerUserID(PatientID, "PTNT", con);
            ObjLdgTnx.LedgerNoDr = AllQuery.GetLedgerNoByLedgerUserID(Hospital_ID, "HOSP", con);
            ObjLdgTnx.TypeOfTnx = "IPD-Room-Shift";
            ObjLdgTnx.Date = Util.GetDateTime(Util.GetDateTime(SiftDate).ToString("yyyy-MM-dd"));
            ObjLdgTnx.Time = Util.GetDateTime(Util.GetDateTime(SiftDate).ToString("HH:mm:ss"));
            ObjLdgTnx.BillNo = "";
            ObjLdgTnx.NetAmount = Util.GetDecimal(TotalBillAmount);
            ObjLdgTnx.GrossAmount = Util.GetDecimal(TotalBillAmount);
            ObjLdgTnx.PatientID = PatientID;
            ObjLdgTnx.PanelID = PanelID;
            ObjLdgTnx.TransactionID = TransactionID;
            ObjLdgTnx.UserID = User_ID;
            ObjLdgTnx.IpAddress = HttpContext.Current.Request.UserHostAddress;
            ObjLdgTnx.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            ObjLdgTnx.PatientType = PatientType;
            string LedgerTransactionNo = ObjLdgTnx.Insert();

            if (LedgerTransactionNo != "")
            {

                LedgerTnxDetail ObjLdgTnxDtl = new LedgerTnxDetail(Tnx);
                ObjLdgTnxDtl.Hospital_Id = Hospital_ID;
                ObjLdgTnxDtl.LedgerTransactionNo = LedgerTransactionNo;
                ObjLdgTnxDtl.ItemID = Item_ID;
                ObjLdgTnxDtl.Rate = Util.GetDecimal(TotalBillAmount);
                ObjLdgTnxDtl.Quantity = 1;
                ObjLdgTnxDtl.StockID = "";
                ObjLdgTnxDtl.IsTaxable = "NO";
                decimal DiscPerc = 0;// Util.GetDecimal(AllLoadData_IPD.getIPDPanelDiscPer(Util.GetInt(PanelID), Util.GetString(Item_ID),"I",con));

                if (DiscPerc > 0)
                {
                    decimal GrossAmt = Util.GetDecimal(TotalBillAmount) * Util.GetDecimal(1);
                    decimal NetAmount = GrossAmt - ((GrossAmt * DiscPerc) / 100);

                    ObjLdgTnxDtl.Amount = Util.GetDecimal(NetAmount);
                    ObjLdgTnxDtl.DiscountPercentage = Util.GetDecimal(DiscPerc);
                    ObjLdgTnxDtl.DiscAmt = Util.GetDecimal(GrossAmt - NetAmount);
                    ObjLdgTnxDtl.NetItemAmt = Util.GetDecimal(NetAmount);
                    ObjLdgTnxDtl.TotalDiscAmt = Util.GetDecimal(GrossAmt - NetAmount);
                    ObjLdgTnxDtl.DiscountReason = "Panel Wise Discount";
                    ObjLdgTnxDtl.DiscUserID = User_ID;
                }
                else
                {
                    ObjLdgTnxDtl.Amount = Util.GetDecimal(TotalBillAmount);
                    ObjLdgTnxDtl.DiscountPercentage = Util.GetDecimal(0.00);
                    ObjLdgTnxDtl.NetItemAmt = Util.GetDecimal(TotalBillAmount);
                    ObjLdgTnxDtl.TotalDiscAmt = 0;
                }

               
                ObjLdgTnxDtl.IsPackage = 0;
                ObjLdgTnxDtl.PackageID = "";
                ObjLdgTnxDtl.IsVerified = 1;
                ObjLdgTnxDtl.TransactionID = TransactionID;
                ObjLdgTnxDtl.SubCategoryID = SubCategory_ID;
                ObjLdgTnxDtl.ItemName = ItemName;
                ObjLdgTnxDtl.UserID = User_ID;
                ObjLdgTnxDtl.EntryDate = Util.GetDateTime(Util.GetDateTime(SiftDate).ToString("yyyy-MM-dd HH:mm:ss"));
                ObjLdgTnxDtl.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(ObjLdgTnxDtl.SubCategoryID), con));
                ObjLdgTnxDtl.pageURL = All_LoadData.getCurrentPageName();
                ObjLdgTnxDtl.IPDCaseTypeID = IPDCaseType_ID;
                ObjLdgTnxDtl.RateListID = rateListID;
                ObjLdgTnxDtl.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
               
                ObjLdgTnxDtl.Type = "I";
                ObjLdgTnxDtl.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                ObjLdgTnxDtl.IpAddress = HttpContext.Current.Request.UserHostAddress;
                ObjLdgTnxDtl.DoctorID = DoctorID;
                ObjLdgTnxDtl.RoomID = Room_ID;
                string LdgTnxDtlID = ObjLdgTnxDtl.Insert().ToString();

                if (LdgTnxDtlID == "")
                {
                    return "0";
                }
            }
            else
            {
                return "0";
            }

            return "1";
        }
        catch (Exception ex)
        {
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return "0";
        }
    }
    public string GetItemRateDetails(string PanelID, string IPDCaseTypeID, string ScheduleChargeID, string ItemID, string ConfigID, MySqlConnection con)
    {
        string NewItemID = "", Rate = "", SubCategoryID = "", BufferTime = "", ItemCode = "", rateListID = "";
        StringBuilder sb = new StringBuilder();
        sb.Append(" Select im.SubCategoryID,im.ItemID,rt.rate,im.BufferTime,IF(IFNULL(rt.ItemDisplayName,'')='',im.`TypeName`,rt.ItemDisplayName) TypeName,");
        sb.Append(" rt.ItemCode,rt.IPDCaseTypeID,rt.ScheduleChargeID,im.Type_ID,rt.ID rateListID ");
        sb.Append(" FROM f_itemmaster im  INNER join f_subcategorymaster sc on sc.SubCategoryID = im.SubCategoryID ");
        sb.Append(" INNER JOIN f_configrelation cr on cr.CategoryID = sc.CategoryID ");
        sb.Append(" INNER JOIN f_ratelist_ipd rt on rt.ItemID = im.ItemID WHERE sc.Active=1 and im.IsActive=1 ");
        sb.Append(" AND rt.IsCurrent=1 AND rt.PanelID =" + PanelID + " AND rt.IPDCaseTypeID ='" + IPDCaseTypeID + "' ");
        sb.Append(" AND rt.ScheduleChargeID='" + ScheduleChargeID + "' AND cr.ConfigID='" + ConfigID + "' ");
        if (ItemID != string.Empty)
            sb.Append(" and im.ItemID='" + ItemID + "'");

        DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];
        if (dt != null && dt.Rows.Count > 0)
        {
            SubCategoryID = dt.Rows[0]["SubCategoryID"].ToString();

            NewItemID = dt.Rows[0]["ItemID"].ToString() + "#" + dt.Rows[0]["TypeName"].ToString();
            Rate = dt.Rows[0]["Rate"].ToString();
            BufferTime = dt.Rows[0]["BufferTime"].ToString();
            ItemCode = dt.Rows[0]["ItemCode"].ToString();
            rateListID = dt.Rows[0]["rateListID"].ToString();
        }
        return (NewItemID + '#' + Rate + '#' + SubCategoryID + '#' + BufferTime + '#' + ItemCode + '#' + rateListID);
    }

}
