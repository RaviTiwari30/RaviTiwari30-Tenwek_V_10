using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Web;

/// <summary>
/// Summary description for IpdAdjustment
/// </summary>
public class IpdBillAdjustment
{
	public IpdBillAdjustment()
	{
		//
		// TODO: Add constructor logic here
		//
	}
    public static void AddIpdAdjustment(string PatientID, string TransID)
    {
        AllQuery AQ = new AllQuery();
        string ledgerNumber = AQ.GetLedgerNoByPatientID(PatientID);
        ipdadjustment ipd = new ipdadjustment();
        ipd.PatientID = PatientID;
        ipd.TransactionID = TransID;
        ipd.PatientLedgerNo = ledgerNumber;
        ipd.Insert();
    }
    public static void UpdateBillingInfo(string BillNo, decimal BilledAmt, string PTransID, string UserID)
    {
        ipdadjustment ipd = new ipdadjustment();
        ipd.UpdateBillingInfo(BillNo, BilledAmt, PTransID, UserID);        
    }
    public static string UpdateBillingInfo(string BillNo, string BillDate, decimal BillAmount, string PTransID, string UserID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

 	 string PreviousBillNo = Util.GetString(StockReports.ExecuteScalar("SELECT IFNULL(BillNo,'') FROM f_ipdadjustment adj WHERE adj.TransactionID='" + Util.GetString(PTransID) + "' "));
            if(PreviousBillNo != string.Empty)
            {
                tnx.Rollback();
                tnx.Dispose();
                con.Close();
                con.Dispose();
                return "";
            }


            ExcuteCMD excuteCMD = new ExcuteCMD();
            excuteCMD.DML(tnx, " CALL PostBillWiseDoctorShare(@TransactionID,@UserID,0) ", CommandType.Text, new
            {
                TransactionID = PTransID,
                UserID = HttpContext.Current.Session["ID"].ToString()

            });
			

            AllQuery objAllQuery = new AllQuery(tnx);
            BillNo = objAllQuery.GetNewBillNoIPD(Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()));
            BillDate = DateTime.Now.ToString("yyyy-MM-dd");
            ipdadjustment ipd = new ipdadjustment(tnx);
            int str = ipd.UpdateBillingInfo(BillNo, PTransID, UserID, BillAmount);
            if (str > 0)
            {
                AllUpdate au = new AllUpdate(tnx);
                au.UpdateLedgerTransactionBillNoByTranID(PTransID, BillNo, BillDate);
            }
            tnx.Commit();
            return BillNo;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return "";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    public static bool updateAdjustment(decimal Discount, string DiscountReason, decimal Adjustment, string AdjusReason, string PTransID, string ApprovalBy, string BillAmount)
    {
        ipdadjustment ipd = new ipdadjustment();
        bool result = ipd.updateAdjustment(Discount, DiscountReason, Adjustment, AdjusReason, PTransID, ApprovalBy, BillAmount);
        return result;
    }

    public static bool updateAdjustmentDisc(decimal Discount, string DiscountReason, decimal Adjustment, string AdjusReason, string PTransID, string ApprovalBy, string BillAmount, string DiscUserID,decimal DiscPer)
    {
        ipdadjustment ipd = new ipdadjustment();
        bool result = ipd.updateAdjustmentDisc(Discount, DiscountReason, Adjustment, AdjusReason, PTransID, ApprovalBy, BillAmount, DiscUserID, DiscPer);
        return result;
    }

    public static bool d_updateAdjustment(decimal Discount, string DiscountReason, decimal Adjustment, string AdjusReason, string PTransID, string ApprovalBy, string BillAmount)
    {
        ipdadjustment ipd = new ipdadjustment();
        bool result = ipd.d_updateAdjustment(Discount, DiscountReason, Adjustment, AdjusReason, PTransID, ApprovalBy, BillAmount);
        return result;
    }
    public static bool updateAdjustment(decimal Discount, string DiscountReason, string PTransID, MySqlTransaction TranConnection)
    {
        ipdadjustment ipd = new ipdadjustment(TranConnection);
        bool result = ipd.updateAdjustment(Discount, DiscountReason, PTransID);
        return result;
    }   
    public static bool ClosePatientFile(string PTransID)
    {
        bool result;
        ipdadjustment ipd = new ipdadjustment();
        result = ipd.ClosePatientFile(PTransID);
        return result; 
    }
   
    public static DataTable GetIPDAdjustment(string PTransID)
    {
        ipdadjustment ipd = new ipdadjustment();
        DataTable dt = ipd.GetIPDAdjustment(PTransID);
        return dt;
    }
    public static DataTable d_GetIPDAdjustment(string PTransID)
    {
        ipdadjustment ipd = new ipdadjustment();
        DataTable dt = ipd.d_GetIPDAdjustment(PTransID);
        return dt;
    }
    public static string UpdateBillingInfo(string BillNo, string BillDate, decimal BillAmount, string PTransID, string UserID, decimal ServiceTaxAmt, decimal ServiceTaxPer, decimal ServiceTaxSurChgAmt, decimal SerTaxSurChgPer, decimal SerTaxBillAmt, int BillingType, string Narration, int S_CountryID, decimal S_Amount, string S_Notation, decimal C_Factor, decimal RoundOff, int CentreID,int PanelID,MySqlConnection con,MySqlTransaction tnx,int BillCountryID,string BillNotation,decimal BillFactor)
    {
       
        try
        {
            AllQuery objAllQuery = new AllQuery(tnx);
            BillNo = SalesEntry.getBillNoIPD(CentreID, tnx, con);
            BillDate = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");

            ipdadjustment ipd = new ipdadjustment(tnx);
            int str = ipd.UpdateBillingInfo(BillNo, BillDate, PTransID, UserID, BillAmount, ServiceTaxAmt, ServiceTaxPer, ServiceTaxSurChgAmt, SerTaxSurChgPer, SerTaxBillAmt, BillingType, Narration, S_CountryID, S_Amount, S_Notation, C_Factor, RoundOff, PanelID,tnx, BillCountryID, BillNotation, BillFactor);

            //if (str > 0)
            //{
            //    AllUpdate au = new AllUpdate(tnx);
            //    au.UpdateLedgerTransactionBillNoByTranID(PTransID, BillNo, BillDate);
            //}

            string PreviousBillNo = Util.GetString(StockReports.ExecuteScalar("SELECT IFNULL(BillNo,'') FROM patient_medical_history adj WHERE adj.TransactionID='" + Util.GetString(PTransID) + "' "));//f_ipdadjustment
            if (PreviousBillNo != string.Empty)
            {
                tnx.Rollback();
                tnx.Dispose();
                con.Close();
                con.Dispose();
                return PreviousBillNo;
            }



			ExcuteCMD excuteCMD = new ExcuteCMD();
            excuteCMD.DML(tnx, " CALL PostBillWiseDoctorShare(@TransactionID,@UserID,0) ", CommandType.Text, new
            {
                TransactionID = PTransID,
                UserID = HttpContext.Current.Session["ID"].ToString()

            });

            //Devendra Singh 2018-11-12 Insert Finance Integarion 
            if (Resources.Resource.AllowFiananceIntegration == "1")
            {
              //  string IsIntegrated = Util.GetString(EbizFrame.InsertIPDRevenue(Util.GetString(PTransID),  "R", tnx));

                string IsIntegrated = Util.GetString(EbizFrame.InsertBillGenerate(Util.GetString(PTransID), "I", tnx));
                    if (IsIntegrated == "0")
                    {
                        tnx.Rollback();
                        tnx.Dispose();
                        con.Close();
                        con.Dispose();
                    }
            }

            //===============Post of Billing==========

            bool isTrue = false;

            isTrue = Dummy.PostBillForDummy(PTransID, tnx);        
            // Update skipped steps in discharge process
            //string skipStepIDs = "'" + (int)AllGlobalFunction.DischargeProcessStep.PatientClearance + "'," +
            //                     "'" + (int)AllGlobalFunction.DischargeProcessStep.NursingClearance + "'," +
            //                     "'" + (int)AllGlobalFunction.DischargeProcessStep.RoomClearance + "'";
            string skipStepIDs = IPDBilling.getDischargeSkipSteps(tnx, (int)AllGlobalFunction.DischargeProcessStep.BillGenerate);



            if (!String.IsNullOrEmpty(skipStepIDs))
            {
                AllUpdate objUpdate = new AllUpdate(tnx);
                isTrue = objUpdate.UpdateDischargeProcessStep(PTransID, UserID, skipStepIDs);
                //
                if (isTrue)
                {
                    tnx.Commit();
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();
                    return BillNo;
                }
                else
                {

                    tnx.Rollback();
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();
                    return "";
                }
            }
            else
            {
                tnx.Commit();
                tnx.Dispose();
                con.Close();
                con.Dispose();
                return BillNo;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            return "";
        }
    }
}
