using System;
using System.Data;
using System.Web;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for SchedulerClass
/// </summary>
public class SchedulerClass
{
	public SchedulerClass()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    private DataTable GetSchedulerDetail(string CategoryConfigId)
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "";

            strQuery = "SELECT t.*,im.ItemID,im.BufferTime,im.EndTime, " +
            "sc.SubCategoryID,sc.Name SubCategoryName,IFNULL(rt.ItemCode,'')ItemCode," +
            "IF(IFNULL(rt.ItemDisplayName,'')='',im.typename,rt.ItemDisplayName)ItemDisplayName," +
            "Max(rt.Rate)Rate,im.ItemID FROM ( " +
            "       SELECT pmh.TransactionID,pmh.ScheduleChargeID,pmh.PanelID,pmh.PatientID," +
            "       PIP.IPDCaseType_ID,pip.IPDCaseType_ID_Bill,pip.IsTempAllocated,pip.StartDate,pip.StartTime, " +
            "       pmh.DoctorID FROM patient_ipd_profile pip INNER JOIN patient_medical_history pmh " +
            "       ON pip.TransactionID = pmh.TransactionID INNER JOIN ipd_case_history ich " +
            "       ON ich.TransactionID = pmh.TransactionID WHERE ich.Status='IN' AND pip.tobebill=1 " +
            "       AND ich.DateOfAdmit!=CURDATE() " +
            ")t INNER JOIN f_itemmaster im ";

            if (CategoryConfigId != "1" && CategoryConfigId != "2" && CategoryConfigId !="24")
                strQuery += "On im.Type_ID = t.IPDCaseType_ID_Bill ";

            if (CategoryConfigId == "2")
                strQuery += "On im.Type_ID = t.IPDCaseType_ID ";

            strQuery += "INNER JOIN f_subcategorymaster sc ON " +
            "im.SubCategoryID = sc.SubCategoryID INNER JOIN f_configrelation cf " +
            "ON sc.CategoryID = cf.CategoryID INNER JOIN f_ratelist_ipd rt ON im.ItemID = rt.ItemID " +            
            "AND rt.ScheduleChargeID = t.ScheduleChargeID ";

            if (CategoryConfigId == "1")
            {
                strQuery += "AND rt.IPDCaseType_ID = t.IPDCaseType_ID_Bill ";
                strQuery += "INNER JOIN f_scheduledconsultant sch ON sch.SubCategoryID = sc.SubCategoryID ";
                strQuery += "and sch.DoctorID = im.Type_ID and sch.DoctorID = t.DoctorID ";
            }
            else if (CategoryConfigId == "2")
            {
                strQuery += "and rt.IPDCaseType_ID = t.IPDCaseType_ID ";
            }
            else
            {
                strQuery += "and rt.IPDCaseType_ID = t.IPDCaseType_ID_Bill ";
            }
            
            strQuery += "WHERE im.IsActive=1 AND cf.ConfigID=" + CategoryConfigId + " and rt.IsCurrent=1 ";            

            if (CategoryConfigId == "1")
                strQuery += "and sch.IsActive=1 ";

            strQuery += " Group By t.TransactionID,im.ItemID ";

            Items = StockReports.GetDataTable(strQuery) ;

            
            if (Items.Rows.Count > 0)
            {
                return Items;
            }
            else
            {

                return null;
            }
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return null;
        }
    }
    

    public int SaveIPDDataFromScheduler(string Type, string CategoryConfigId,string TranTypeID)
    {
        try
        {          
            DataTable dtPatient = GetSchedulerDetail(CategoryConfigId);
            if (dtPatient.Rows.Count > 0)
            {
                MySqlConnection con = new MySqlConnection();
                con = Util.GetMySqlCon();
                con.Open();
                MySqlTransaction MySqltrans = con.BeginTransaction();

             

                Ledger_Transaction ObjLdgTnx = new Ledger_Transaction(MySqltrans);
               LedgerTnxDetail objLTDetail = new LedgerTnxDetail(MySqltrans);
               
                try
                {

                    foreach (DataRow dr in dtPatient.Rows)
                    {

                        DateTime start = Util.GetDateTime(dr["StartTime"].ToString());
                        DateTime sdate = Util.GetDateTime(dr["StartDate"].ToString());
                        sdate = Util.GetDateTime(sdate.ToShortDateString() + " " + start.ToShortTimeString());
                        int BTime = Util.GetInt(dr["BufferTime"].ToString());
                        string UniqueHash = Util.getHash();
                        TimeSpan TimeSpent = (DateTime.Now - sdate);

                        int IPDCaseTypeID = Util.GetInt(StockReports.ExecuteScalar("Select IPDCaseTypeID From Patient_IPD_Profile where TransactionID= '" + Util.GetString(dr["TransactionID"].ToString()) + "'  ORDER BY PatientIPDProfile_ID DESC LIMIT 1"));

                        if (TimeSpent.TotalHours >= BTime)
                        {
                            //Ledger Transaction
                            ObjLdgTnx.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                            ObjLdgTnx.LedgerNoCr = AllQuery.GetLedgerNoByLedgerUserID(dr["PatientID"].ToString(), con);
                            ObjLdgTnx.LedgerNoDr = AllQuery.GetLedgerNoByLedgerUserID(HttpContext.Current.Session["HOSPID"].ToString(), con);
                            ObjLdgTnx.TypeOfTnx = Type;
                            ObjLdgTnx.Date = DateTime.Now;
                            ObjLdgTnx.Time = DateTime.Now;
                            ObjLdgTnx.BillNo = "";
                            ObjLdgTnx.NetAmount = Util.GetDecimal(dr["Rate"]);
                            ObjLdgTnx.GrossAmount = Util.GetDecimal(dr["Rate"]);
                            ObjLdgTnx.PatientID = dr["PatientID"].ToString();
                            ObjLdgTnx.PanelID =Util.GetInt( dr["PanelID"]);
                            ObjLdgTnx.TransactionID = dr["TransactionID"].ToString();
                            ObjLdgTnx.UserID = "EMP002";
                            ObjLdgTnx.UniqueHash = UniqueHash;
                            string LedgerTransactionNo = ObjLdgTnx.Insert();

                            string PatientType = StockReports.GetPatient_Type_IPD(dr["TransactionID"].ToString());

                            //Checking if Patient is prescribed any IPD Packages
                            DataTable dtPkg = StockReports.GetIPD_Packages_Prescribed(dr["TransactionID"].ToString(),con);

                            //Ledger Transaction Details

                            objLTDetail.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
                            objLTDetail.LedgerTransactionNo = LedgerTransactionNo;
                            objLTDetail.ItemID = dr["ItemID"].ToString();
                            objLTDetail.Rate = Util.GetDecimal(dr["Rate"].ToString());
                            objLTDetail.Quantity = Util.GetDecimal(1);
                            objLTDetail.EntryDate = Util.GetDateTime(DateTime.Now.ToShortDateString());
                            objLTDetail.IsVerified = 1;
                            objLTDetail.VerifiedDate = Util.GetDateTime(DateTime.Now);
                            objLTDetail.TransactionID = Util.GetString(dr["TransactionID"].ToString());
                            objLTDetail.UserID = "EMP002";
                            objLTDetail.StockID = "";
                            objLTDetail.IsTaxable = "NO";
                            objLTDetail.ItemName = dr["ItemDisplayName"].ToString() + "   " + dr["ItemCode"].ToString();
                            //objLTDetail.ItemName = dr["SubCategoryName"].ToString();
                            objLTDetail.SubCategoryID = dr["SubCategoryID"].ToString();
                            objLTDetail.TnxTypeID = Util.GetInt(TranTypeID);
                            objLTDetail.ConfigID = Util.GetInt(CategoryConfigId);
                            objLTDetail.IsPayable = StockReports.GetIsPayableItems(objLTDetail.ItemID, ObjLdgTnx.PanelID);
                            objLTDetail.Type = "I";

                            if (dtPkg != null && dtPkg.Rows.Count > 0)
                            {
                                int iCtr = 0;
                                foreach (DataRow drPkg in dtPkg.Rows)
                                {
                                    if (iCtr == 0)
                                    {
                                        DataTable dtPkgDetl = StockReports.ShouldSendToIPDPackage(dr["TransactionID"].ToString(), drPkg["PackageID"].ToString(), dr["ItemID"].ToString(), Util.GetDecimal(dr["Rate"]), 1, IPDCaseTypeID, con);

                                        if (dtPkgDetl != null && Util.GetString(dtPkgDetl.Rows[0]["iStatus"]) != "")
                                        {
                                            if (Util.GetBoolean(dtPkgDetl.Rows[0]["iStatus"]))
                                            {
                                                objLTDetail.Amount = 0;
                                                objLTDetail.DiscountPercentage = 0;
                                                objLTDetail.DiscAmt = 0;
                                                objLTDetail.IsPackage = 1;
                                                objLTDetail.PackageID = Util.GetString(drPkg["PackageID"]);
                                                iCtr = 1;
                                            }
                                            else
                                            {
                                                GetDiscount ds = new GetDiscount();
                                                decimal DiscPerc = ds.GetDefaultDiscount(dr["SubCategoryID"].ToString(), Util.GetInt(dr["PanelID"]), Util.GetDateTime(DateTime.Now.ToString()), PatientType, "IPD");

                                                if (DiscPerc > 0)
                                                {
                                                    decimal GrossAmt = Util.GetDecimal(dr["Rate"]);
                                                    decimal NetAmount = GrossAmt - ((GrossAmt * DiscPerc) / 100);

                                                    objLTDetail.Amount = NetAmount;
                                                    objLTDetail.DiscountPercentage = DiscPerc;
                                                    objLTDetail.DiscAmt = GrossAmt - NetAmount;
                                                    //iCtr = 1;
                                                }
                                                else
                                                {
                                                    objLTDetail.DiscountPercentage = DiscPerc;
                                                    objLTDetail.DiscAmt = 0;
                                                    objLTDetail.Amount = Util.GetDecimal(dr["Rate"]);
                                                    //iCtr = 1;
                                                }
                                            }
                                        }
                                        else
                                        {
                                            GetDiscount ds = new GetDiscount();
                                            decimal DiscPerc = ds.GetDefaultDiscount(dr["SubCategoryID"].ToString(), Util.GetInt(dr["PanelID"]), Util.GetDateTime(DateTime.Now.ToString()), PatientType, "IPD");

                                            if (DiscPerc > 0)
                                            {
                                                decimal GrossAmt = Util.GetDecimal(dr["Rate"]);
                                                decimal NetAmount = GrossAmt - ((GrossAmt * DiscPerc) / 100);

                                                objLTDetail.Amount = NetAmount;
                                                objLTDetail.DiscountPercentage = DiscPerc;
                                                objLTDetail.DiscAmt = GrossAmt - NetAmount;
                                                //iCtr = 1;
                                            }
                                            else
                                            {
                                                objLTDetail.DiscountPercentage = DiscPerc;
                                                objLTDetail.DiscAmt = 0;
                                                objLTDetail.Amount = Util.GetDecimal(dr["Rate"]);
                                                //iCtr = 1;
                                            }

                                            //objLTDetail.Amount = 0;
                                            //objLTDetail.DiscountPercentage = 0;
                                            //objLTDetail.DiscAmt = 0;
                                            //objLTDetail.IsPackage = 1;
                                            //objLTDetail.PackageID = Util.GetString(drPkg["PackageID"]);
                                            //iCtr = 1;
                                        }
                                    }
                                }
                            }
                            else
                            {
                                GetDiscount ds = new GetDiscount();
                                decimal DiscPerc = ds.GetDefaultDiscount(dr["SubCategoryID"].ToString(), Util.GetInt(dr["PanelID"]), Util.GetDateTime(DateTime.Now.ToString()), PatientType, "IPD");

                                if (DiscPerc > 0)
                                {
                                    decimal GrossAmt = Util.GetDecimal(dr["Rate"]) * Util.GetDecimal(objLTDetail.Quantity);
                                    decimal NetAmount = GrossAmt - ((GrossAmt * DiscPerc) / 100);

                                    objLTDetail.Amount = NetAmount;
                                    objLTDetail.DiscountPercentage = DiscPerc;
                                    objLTDetail.DiscAmt = GrossAmt - NetAmount;
                                }
                                else
                                {
                                    objLTDetail.DiscountPercentage = DiscPerc;
                                    objLTDetail.DiscAmt = 0;
                                    objLTDetail.Amount = Util.GetDecimal(dr["Rate"]);
                                }
                            }

                            objLTDetail.Insert();


                        }
                    }

                    MySqltrans.Commit();


                    return dtPatient.Rows.Count;
                }
                catch (Exception ex)
                {
                    MySqltrans.Rollback();

                    ClassLog objClass = new ClassLog();
                    objClass.errLog(ex);
                    return 0;
                }
                finally
                {
                    MySqltrans.Dispose();
                    con.Close();
                    con.Dispose();
                }
            }
            else
            {
                return 0;
            }
        }
        catch (Exception ex)
        {
            ClassLog objClass = new ClassLog();
            objClass.errLog(ex);
            return 0;
        }
    }

    public int SaveIPDDataRmoChargesFromScheduler(string Type, string CategoryConfigId, string TranTypeID)
    {
        try
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            //con.ConnectionTimeout = 5000;
            con.Open();
            MySqlTransaction MySqltrans = con.BeginTransaction();

            DataTable dtPatient = GetSchedulerDetail(CategoryConfigId);
          

            Ledger_Transaction ObjLdgTnx = new Ledger_Transaction(MySqltrans);
            LedgerTnxDetail objLTDetail = new LedgerTnxDetail(MySqltrans);
            try
            {
                foreach (DataRow dr in dtPatient.Rows)
                {
                    if (dr["PanelID"].ToString() == "1" && CategoryConfigId == "27")
                    {
                        DateTime start = Util.GetDateTime(dr["StartTime"].ToString());
                        DateTime sdate = Util.GetDateTime(dr["StartDate"].ToString());
                        sdate = Util.GetDateTime(sdate.ToShortDateString() + " " + start.ToShortTimeString());
                        int BTime = Util.GetInt(dr["BufferTime"].ToString());
                        string UniqueHash = Util.getHash();
                        int IPDCaseTypeID = Util.GetInt(StockReports.ExecuteScalar("Select IPDCaseTypeID From Patient_IPD_Profile where TransactionID= '" + Util.GetString(dr["TransactionID"].ToString()) + "'  ORDER BY PatientIPDProfile_ID DESC LIMIT 1"));

                        TimeSpan TimeSpent = (DateTime.Now - sdate);

                        if (TimeSpent.TotalHours >= BTime)
                        {
                            //Ledger Transaction
                            ObjLdgTnx.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                            ObjLdgTnx.LedgerNoCr = AllQuery.GetLedgerNoByLedgerUserID(dr["PatientID"].ToString(), con);
                            ObjLdgTnx.LedgerNoDr = AllQuery.GetLedgerNoByLedgerUserID(HttpContext.Current.Session["HOSPID"].ToString(), con); 
                            ObjLdgTnx.TypeOfTnx = Type;
                            ObjLdgTnx.Date = DateTime.Now;
                            ObjLdgTnx.Time = DateTime.Now;
                            ObjLdgTnx.BillNo = "";
                            ObjLdgTnx.NetAmount = Util.GetDecimal(dr["Rate"]);
                            ObjLdgTnx.GrossAmount = Util.GetDecimal(dr["Rate"]);
                            ObjLdgTnx.PatientID = dr["PatientID"].ToString();
                            ObjLdgTnx.PanelID = Util.GetInt(dr["PanelID"].ToString());
                            ObjLdgTnx.TransactionID = dr["TransactionID"].ToString();
                            ObjLdgTnx.UserID = "EMP002";
                            ObjLdgTnx.UniqueHash = UniqueHash;
                            string LedgerTransactionNo = ObjLdgTnx.Insert();

                            string PatientType = StockReports.GetPatient_Type_IPD(dr["TransactionID"].ToString());

                            //Checking if Patient is prescribed any IPD Packages
                            DataTable dtPkg = StockReports.GetIPD_Packages_Prescribed(dr["TransactionID"].ToString(), con);

                            //Ledger Transaction Details

                            objLTDetail.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
                            objLTDetail.LedgerTransactionNo = LedgerTransactionNo;
                            objLTDetail.ItemID = dr["ItemID"].ToString();
                            objLTDetail.Rate = Util.GetDecimal(dr["Rate"].ToString());
                            objLTDetail.Quantity = Util.GetDecimal(1);
                            objLTDetail.EntryDate = Util.GetDateTime(DateTime.Now.ToShortDateString());
                            objLTDetail.IsVerified = 1;
                            objLTDetail.VerifiedDate = Util.GetDateTime(DateTime.Now);
                            objLTDetail.TransactionID = Util.GetString(dr["TransactionID"].ToString());
                            objLTDetail.UserID = "EMP002";
                            objLTDetail.StockID = "";
                            objLTDetail.IsTaxable = "NO";
                            objLTDetail.ItemName = dr["SubCategoryName"].ToString() + "   " + dr["ItemCode"].ToString();
                            //objLTDetail.ItemName = dr["SubCategoryName"].ToString();
                            objLTDetail.SubCategoryID = dr["SubCategoryID"].ToString();
                            objLTDetail.TnxTypeID = Util.GetInt(TranTypeID);
			                objLTDetail.ConfigID = Util.GetInt(CategoryConfigId);
                            objLTDetail.IsPayable = StockReports.GetIsPayableItems(objLTDetail.ItemID, ObjLdgTnx.PanelID);

                            if (dtPkg != null && dtPkg.Rows.Count > 0)
                            {
                                int iCtr = 0;
                                foreach (DataRow drPkg in dtPkg.Rows)
                                {
                                    if (iCtr == 0)
                                    {
                                        DataTable dtPkgDetl = StockReports.ShouldSendToIPDPackage(dr["TransactionID"].ToString(), drPkg["PackageID"].ToString(), dr["ItemID"].ToString(), Util.GetDecimal(dr["Rate"]), 1,IPDCaseTypeID, con);

                                        if (dtPkgDetl != null && Util.GetString(dtPkgDetl.Rows[0]["iStatus"]) != "")
                                        {
                                            if (Util.GetBoolean(dtPkgDetl.Rows[0]["iStatus"]))
                                            {
                                                objLTDetail.Amount = 0;
                                                objLTDetail.DiscountPercentage = 0;
                                                objLTDetail.DiscAmt = 0;
                                                objLTDetail.IsPackage = 1;
                                                objLTDetail.PackageID = Util.GetString(drPkg["PackageID"]);
                                                iCtr = 1;
                                            }
                                            else
                                            {
                                                GetDiscount ds = new GetDiscount();
                                                decimal DiscPerc = ds.GetDefaultDiscount(dr["SubCategoryID"].ToString(), Util.GetInt(dr["PanelID"].ToString()), Util.GetDateTime(DateTime.Now.ToString()), PatientType, "IPD");

                                                if (DiscPerc > 0)
                                                {
                                                    decimal GrossAmt = Util.GetDecimal(dr["Rate"]);
                                                    decimal NetAmount = GrossAmt - ((GrossAmt * DiscPerc) / 100);

                                                    objLTDetail.Amount = NetAmount;
                                                    objLTDetail.DiscountPercentage = DiscPerc;
                                                    objLTDetail.DiscAmt = GrossAmt - NetAmount;
                                                    //iCtr = 1;
                                                }
                                                else
                                                {
                                                    objLTDetail.DiscountPercentage = DiscPerc;
                                                    objLTDetail.DiscAmt = 0;
                                                    objLTDetail.Amount = Util.GetDecimal(dr["Rate"]);
                                                    //iCtr = 1;
                                                }
                                            }
                                        }
                                        else
                                        {
                                            GetDiscount ds = new GetDiscount();
                                            decimal DiscPerc = ds.GetDefaultDiscount(dr["SubCategoryID"].ToString(), Util.GetInt(dr["PanelID"].ToString()), Util.GetDateTime(DateTime.Now.ToString()), PatientType, "IPD");

                                            if (DiscPerc > 0)
                                            {
                                                decimal GrossAmt = Util.GetDecimal(dr["Rate"]);
                                                decimal NetAmount = GrossAmt - ((GrossAmt * DiscPerc) / 100);

                                                objLTDetail.Amount = NetAmount;
                                                objLTDetail.DiscountPercentage = DiscPerc;
                                                objLTDetail.DiscAmt = GrossAmt - NetAmount;
                                                //iCtr = 1;
                                            }
                                            else
                                            {
                                                objLTDetail.DiscountPercentage = DiscPerc;
                                                objLTDetail.DiscAmt = 0;
                                                objLTDetail.Amount = Util.GetDecimal(dr["Rate"]);
                                                //iCtr = 1;
                                            }

                                            //objLTDetail.Amount = 0;
                                            //objLTDetail.DiscountPercentage = 0;
                                            //objLTDetail.DiscAmt = 0;
                                            //objLTDetail.IsPackage = 1;
                                            //objLTDetail.PackageID = Util.GetString(drPkg["PackageID"]);
                                            //iCtr = 1;
                                        }
                                    }
                                }
                            }
                            else
                            {
                                GetDiscount ds = new GetDiscount();
                                decimal DiscPerc = ds.GetDefaultDiscount(dr["SubCategoryID"].ToString(), Util.GetInt(dr["PanelID"].ToString()), Util.GetDateTime(DateTime.Now.ToString()), PatientType, "IPD");

                                if (DiscPerc > 0)
                                {
                                    decimal GrossAmt = Util.GetDecimal(dr["Rate"]) * Util.GetDecimal(objLTDetail.Quantity);
                                    decimal NetAmount = GrossAmt - ((GrossAmt * DiscPerc) / 100);

                                    objLTDetail.Amount = NetAmount;
                                    objLTDetail.DiscountPercentage = DiscPerc;
                                    objLTDetail.DiscAmt = GrossAmt - NetAmount;
                                }
                                else
                                {
                                    objLTDetail.DiscountPercentage = DiscPerc;
                                    objLTDetail.DiscAmt = 0;
                                    objLTDetail.Amount = Util.GetDecimal(dr["Rate"]);
                                }
                            }
                            objLTDetail.Insert();
                        }
                    }
                }
                MySqltrans.Commit();
                con.Close();
                con.Dispose();

                return dtPatient.Rows.Count;
            }
            catch (Exception ex)
            {
                MySqltrans.Rollback();
                con.Close();
                con.Dispose();
                ClassLog objClass = new ClassLog();
                objClass.errLog(ex);
                return 0;
            }
        }
        catch (Exception ex)
        {
            ClassLog objClass = new ClassLog();
            objClass.errLog(ex);
            return 0;
        }
    }

}
