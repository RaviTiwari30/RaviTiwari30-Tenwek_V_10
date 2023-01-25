using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using MySql.Data.MySqlClient;
using System.Linq;
/// <summary>
/// Summary description for OPD
/// </summary>
public class OPD
{
    GetEncounterNo Encounter = new GetEncounterNo();
    int EncounterNo = 0;
    
    public OPD()
    {
        //
        // TODO: Add constructor logic here
        //
    }
    public string SavePreSurgeryBooking(DataTable dtSurgeryBooking, string Hospital_ID, string PatientID, DateTime Date, DateTime Time, string PanelID, string User_ID, string DoctorID, string BillingCategoryID, string Pname, int PreSurgeryID, MySqlTransaction tranX)
    {
        try
        {
            PreSurgeryBooking SurgeryBooking = new PreSurgeryBooking(tranX);
            foreach (DataRow row in dtSurgeryBooking.Rows)
            {
                SurgeryBooking.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString(); ;
                SurgeryBooking.BillingCategoryID = BillingCategoryID;
                SurgeryBooking.PanelID = PanelID;
                SurgeryBooking.PatientID = PatientID;
                SurgeryBooking.Pname = Pname;
                SurgeryBooking.Date = Date;
                SurgeryBooking.Time = Time;
                SurgeryBooking.CreatedBy = User_ID;
                SurgeryBooking.DoctorID = DoctorID;
                SurgeryBooking.TypeOfTnx = "PreSurgeryBooking";
                SurgeryBooking.SurgeryID = Util.GetString(row["SurgeryID"]);
                SurgeryBooking.SurgeryName = Util.GetString(row["SurgeryName"]);
                SurgeryBooking.Quantity = Util.GetInt(row["Qty"]);
                SurgeryBooking.Amount = Util.GetDecimal(row["Amount"]);
                SurgeryBooking.PreSurgeryID = Util.GetInt(PreSurgeryID).ToString();
                SurgeryBooking.Insert();
            }

            return "1";


        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }

    }
    public string SaveCreditReceipt(DataTable dtPaymentDetail, int PanelID, decimal amount, string LedgerTranNo, string PatientID, string TransactionID, string PaidBy, string hashCode, decimal AmountPaid, decimal RoundOff, MySqlTransaction tranX, string AmountPaidBy, MySqlConnection con, decimal OPDAdvanceAmt, string DeptLedgerNo,int IsOTCollection=0)
    {
        string Receipt_No = "";
        try
        {
            Receipt objRecipt = new Receipt(tranX);
            
            objRecipt.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            string LedgerNoCr =  AllQuery.GetLedgerNoByLedgerUserID(PatientID, "PTNT", con);
            if (LedgerNoCr == null)
                objRecipt.LedgerNoCr = "";
            else
                objRecipt.LedgerNoCr = LedgerNoCr;
            objRecipt.LedgerNoDr = "HOSP0005";
            objRecipt.AmountPaid = AmountPaid;
            objRecipt.AsainstLedgerTnxNo = LedgerTranNo;
            objRecipt.PanelID = PanelID;
            objRecipt.Date = Util.GetDateTime(System.DateTime.Now.ToString("yyyy-MM-dd"));
            objRecipt.Time = Util.GetDateTime(System.DateTime.Now.ToString("HH:mm:ss"));

            objRecipt.Reciever = HttpContext.Current.Session["ID"].ToString();
            objRecipt.Depositor = PatientID;
            objRecipt.TransactionID = TransactionID;
            objRecipt.IsPayementByInsurance = PaidBy;
            objRecipt.RoundOff = RoundOff;
            objRecipt.PanelID = PanelID;
            objRecipt.UniqueHash = hashCode;

            if (AmountPaidBy == "Patient")
                objRecipt.PaidBy = "PAT";
            else
                objRecipt.PaidBy = "PAN";
            objRecipt.IpAddress = HttpContext.Current.Request.UserHostAddress;
            objRecipt.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            objRecipt.deptLedgerNo = DeptLedgerNo.ToString();
            objRecipt.isOTCollection = IsOTCollection;
            Receipt_No = objRecipt.Insert();
            if (Receipt_No == "")
            {
                tranX.Rollback();
                return "";
            }
            int isAdvance = 0;
            Receipt_PaymentDetail ObjReceiptPayment = new Receipt_PaymentDetail(tranX);
            foreach (DataRow row in dtPaymentDetail.Rows)
            {
                ObjReceiptPayment.PaymentModeID = Util.GetInt(row["PaymentModeID"]);
                ObjReceiptPayment.PaymentMode = Util.GetString(row["PaymentMode"]);
                ObjReceiptPayment.Amount = Util.GetDecimal(row["BaseCurrency"]);
                ObjReceiptPayment.ReceiptNo = Receipt_No;
                ObjReceiptPayment.PaymentRemarks = Util.GetString(row["PaymentRemarks"]);
                ObjReceiptPayment.RefDate = Util.GetDateTime(row["RefDate"]);
                ObjReceiptPayment.RefNo = Util.GetString(row["RefNo"]);
                ObjReceiptPayment.BankName = Util.GetString(row["BankName"]);
                ObjReceiptPayment.C_Factor = Util.GetDecimal(row["C_Factor"]);
                ObjReceiptPayment.S_Amount = Util.GetDecimal(row["PaidAmount"]);
                ObjReceiptPayment.S_CountryID = Util.GetInt(row["CountryID"]);
                ObjReceiptPayment.S_Currency = Util.GetString(row["Currency"]);
                ObjReceiptPayment.S_Notation = Util.GetString(row["Notation"]);
                ObjReceiptPayment.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                ObjReceiptPayment.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                string PaymentID = ObjReceiptPayment.Insert().ToString();
                if (PaymentID == "")
                {
                    tranX.Rollback();
                    return "";
                }
                 if ((Util.GetInt(row["PaymentModeID"]) == 5) && (Util.GetDecimal(OPDAdvanceAmt) > 0))
                 {
                     isAdvance += 1;
                     DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,(AdvanceAmount-IFNULL(BalanceAmt,0))RemAmt,ReceiptNo FROM OPD_Advance WHERE PatientID ='" + PatientID + "'  AND IsCancel=0 AND (AdvanceAmount-IFNULL(BalanceAmt,0))>0 ORDER BY ID+0").Tables[0];
                     if (dt.Rows.Count > 0)
                     {
                         decimal advanceAmount = Util.GetDecimal(row["BaseCurrency"]);
                         for (int s = 0; s < dt.Rows.Count; s++)
                         {
                             decimal paidAmt = 0;

                             if (Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString()) >= Util.GetDecimal(advanceAmount))
                             {
                                 MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "Update OPD_Advance SET BalanceAmt =BalanceAmt+" + Util.GetDecimal(advanceAmount) + " WHERE ID ='" + dt.Rows[s]["ID"].ToString() + "' ");
                                 paidAmt = advanceAmount;

                                 advanceAmount = 0;
                             }
                             else if (Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString()) < Util.GetDecimal(advanceAmount))
                             {
                                 MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "Update OPD_Advance SET BalanceAmt =BalanceAmt+" + Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString()) + " WHERE ID ='" + dt.Rows[s]["ID"].ToString() + "' ");

                                 advanceAmount = advanceAmount - Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString());
                                 paidAmt = Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString());
                             }

                             OPD_Advance_Detail advd = new OPD_Advance_Detail(tranX);
                             advd.PaidAmount = Util.GetDecimal(paidAmt);
                             advd.PatientID = PatientID;
                             advd.TransactionID = TransactionID;
                             advd.LedgerTransactionNo = LedgerTranNo;
                             advd.ReceiptNo = Receipt_No;

                             advd.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                             advd.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                             advd.CreatedBy = HttpContext.Current.Session["ID"].ToString();
                             advd.AdvanceID = Util.GetInt(dt.Rows[s]["ID"].ToString());
                             advd.ReceiptNoAgainst = dt.Rows[s]["ReceiptNo"].ToString();
                             advd.Insert();

                             if (advanceAmount == 0)
                                 break;
                         }
                     }
                 }
            }

            


            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "update f_ledgertransaction set Adjustment=Adjustment+" + Util.GetString(AmountPaid) + ",AdjustmentDate=now()  where TransactionID='" + TransactionID + "'");
            return Receipt_No;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
    }
    public string SavePendingReceipt(DataTable dtPaymentDetail, int PanelID, decimal Amount, string LedgerTranNo, string PatientID, string TransactionID, string PaidBy, string Naration, string Type, string hashCode, decimal AmountPaid, decimal RoundOff, MySqlTransaction tranX, string AmountPaidBy, MySqlConnection con, decimal OPDAdvanceAmt, string DeptLedgerNo, int IsOTCollection=0)
    {
        string Receipt_No = "";

        try
        {
            string OldReceiptNo =Util.GetString( MySqlHelper.ExecuteScalar(con,CommandType.Text,"select ReceiptNo from f_reciept where TransactionID='" + TransactionID + "' limit 1"));

            Receipt objRecipt = new Receipt(tranX);           
            objRecipt.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            string LedgerNoCr = AllQuery.GetLedgerNoByLedgerUserID(PatientID, "PTNT", con);
            if (LedgerNoCr == null)
                objRecipt.LedgerNoCr = "";
            else
                objRecipt.LedgerNoCr = LedgerNoCr;
            objRecipt.LedgerNoDr = "HOSP0005";
            objRecipt.AmountPaid = AmountPaid;
            objRecipt.Date = Util.GetDateTime(System.DateTime.Now.ToString("yyyy-MM-dd"));
            objRecipt.Time = Util.GetDateTime(System.DateTime.Now.ToString("HH:mm:ss"));
            objRecipt.Reciever = HttpContext.Current.Session["ID"].ToString();
            objRecipt.Depositor = PatientID;
            objRecipt.Naration = Naration;
            objRecipt.UniqueHash = hashCode;
            objRecipt.RoundOff = RoundOff;
            objRecipt.TransactionID = TransactionID;
            objRecipt.PanelID = PanelID;
            if (AmountPaidBy == "Patient")
                objRecipt.PaidBy = "PAT";
            else
                objRecipt.PaidBy = "PAN";
            objRecipt.IpAddress = All_LoadData.IpAddress();
            objRecipt.AsainstLedgerTnxNo = LedgerTranNo;
            objRecipt.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            objRecipt.deptLedgerNo = DeptLedgerNo.ToString();
            objRecipt.isOTCollection = IsOTCollection;
            Receipt_No = objRecipt.Insert();
            if (Receipt_No == "")
            {
                tranX.Rollback();
                return "";
            }
            // ObjReceipt.Naration = Narration; 
            int isAdvance = 0;
            Receipt_PaymentDetail ObjReceiptPayment = new Receipt_PaymentDetail(tranX);
            foreach (DataRow row in dtPaymentDetail.Rows)
            {
                ObjReceiptPayment.PaymentModeID = Util.GetInt(row["PaymentModeID"]);
                ObjReceiptPayment.PaymentMode = Util.GetString(row["PaymentMode"]);
                ObjReceiptPayment.Amount = Util.GetDecimal(row["BaseCurrency"]);
                ObjReceiptPayment.ReceiptNo = Receipt_No;
                ObjReceiptPayment.PaymentRemarks = Util.GetString(row["PaymentRemarks"]);
                ObjReceiptPayment.RefDate = Util.GetDateTime(row["RefDate"]);
                ObjReceiptPayment.RefNo = Util.GetString(row["RefNo"]);
                ObjReceiptPayment.BankName = Util.GetString(row["BankName"]);
                ObjReceiptPayment.C_Factor = Util.GetDecimal(row["C_Factor"]);
                ObjReceiptPayment.S_Amount = Util.GetDecimal(row["PaidAmount"]);
                ObjReceiptPayment.S_CountryID = Util.GetInt(row["CountryID"]);
                ObjReceiptPayment.S_Currency = Util.GetString(row["Currency"]);
                ObjReceiptPayment.S_Notation = Util.GetString(row["Notation"]);
                ObjReceiptPayment.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                ObjReceiptPayment.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                string PaymentID = ObjReceiptPayment.Insert().ToString();
                if (PaymentID == "")
                {
                    tranX.Rollback();
                    return "";
                }
                if ((Util.GetInt(row["PaymentModeID"]) == 5) && (Util.GetDecimal(OPDAdvanceAmt) > 0))
                {
                    isAdvance += 1;
                    DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,(AdvanceAmount-IFNULL(BalanceAmt,0))RemAmt,ReceiptNo FROM OPD_Advance WHERE PatientID ='" + PatientID + "'  AND IsCancel=0 AND (AdvanceAmount-IFNULL(BalanceAmt,0))>0 ORDER BY ID+0").Tables[0];
                    if (dt.Rows.Count > 0)
                    {
                        decimal advanceAmount = Util.GetDecimal(row["BaseCurrency"]);
                        for (int s = 0; s < dt.Rows.Count; s++)
                        {
                            decimal paidAmt = 0;

                            if (Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString()) >= Util.GetDecimal(advanceAmount))
                            {
                                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "Update OPD_Advance SET BalanceAmt =BalanceAmt+" + Util.GetDecimal(advanceAmount) + " WHERE ID ='" + dt.Rows[s]["ID"].ToString() + "' ");
                                paidAmt = advanceAmount;

                                advanceAmount = 0;
                            }
                            else if (Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString()) < Util.GetDecimal(advanceAmount))
                            {
                                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "Update OPD_Advance SET BalanceAmt =BalanceAmt+" + Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString()) + " WHERE ID ='" + dt.Rows[s]["ID"].ToString() + "' ");

                                advanceAmount = advanceAmount - Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString());
                                paidAmt = Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString());
                            }

                            OPD_Advance_Detail advd = new OPD_Advance_Detail(tranX);
                            advd.PaidAmount = Util.GetDecimal(paidAmt);
                            advd.PatientID = PatientID;
                            advd.TransactionID = TransactionID;
                            advd.LedgerTransactionNo = LedgerTranNo;
                            advd.ReceiptNo = Receipt_No;

                            advd.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                            advd.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                            advd.CreatedBy = HttpContext.Current.Session["ID"].ToString();
                            advd.AdvanceID = Util.GetInt(dt.Rows[s]["ID"].ToString());
                            advd.ReceiptNoAgainst = dt.Rows[s]["ReceiptNo"].ToString();
                            advd.Insert();

                            if (advanceAmount == 0)
                                break;
                        }
                    }
                }
            }
            //return Receipt_No;

           
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "update f_ledgertransaction set Adjustment=Adjustment+" + Util.GetString(AmountPaid) + ",AdjustmentDate=now() where TransactionID='" + TransactionID + "'");

            return Receipt_No;


        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";

        }
    }
    public static DataTable SearchOPDFinalSettlement(string MRNo, string PanelID, string dtFrom, string dtTo,string dptlno)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT t.* FROM (");
        sb.Append(" SELECT lt.BillNo,DATE_FORMAT(lt.Date,'%d-%b-%Y') BillDate,lt.PatientID PatientID,lt.TransactionID TransactionID, ROUND(lt.NetAmount,2) NetAmount,  ");
        sb.Append(" lt.Adjustment PaidAmt,lt.NetAmount-lt.Adjustment PendingAmt,lt.GrossAmount,  ");
        sb.Append(" UPPER(pm.PName) PatientName,lt.LedgerTransactionNo,fpm.Company_Name CompanyName,lt.PanelID, ");
        sb.Append(" ROUND(lt.NetAmount,2) Amount ,if((lt.NetAmount-lt.Adjustment)!=0,'#FFC0CB','#90EE90')rowColor,lt.paymentmodeid,   ");
        sb.Append(" IF(lt.paymentmodeid<>4,'Partial','Credit')PaidType,lt.Roundoff,lt.GovtaxAmount,ROUND((lt.NetAmount-lt.GovtaxAmount-lt.roundoff),2)NetAmtBeforeTax,lt.TypeOfTnx,IF(LT.`TypeOfTnx` IN ('Pharmacy-Issue','Pharmacy-Return'),lt.DeptLedgerNo,'')DeptLedgerNo ");
        sb.Append(" FROM f_ledgertransaction lt   INNER JOIN f_ledgertransaction_paymentdetail flp ON flp.LedgerTransactionNo=lt.LedgerTransactionNo   ");
        sb.Append("  ");
        sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID");
        sb.Append(" INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID ");
        sb.Append(" INNER JOIN f_panel_master fpm ON fpm.PanelID=pmh.PanelID   ");
        sb.Append("   where lt.IsCancel=0 AND lt.CentreID='" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + "'");
        if (MRNo != "")
            sb.Append("     AND lt.PatientID='" + MRNo + "' ");
        if (PanelID != "Select")
            sb.Append("and pmh.PanelID=" + PanelID + " ");
        if (dtFrom != string.Empty)
            sb.Append(" and date(lt.Date) >='" + Util.GetDateTime(dtFrom).ToString("yyyy-MM-dd") + "'");

        if (dtTo != string.Empty)
            sb.Append(" and date(lt.Date) <='" + Util.GetDateTime(dtTo).ToString("yyyy-MM-dd") + "' AND lt.NetAmount<>lt.Adjustment   ");
       // if (dptlno=="LSHHI57")
       //     sb.Append(" and LT.`TypeOfTnx` IN ('Pharmacy-Issue','Pharmacy-Return')   ");
       // else
       //     sb.Append(" and   LT.`TypeOfTnx` not IN ('Pharmacy-Issue','Pharmacy-Return')  ");
        
        
            sb.Append(" and LT.`TypeOfTnx` NOT IN ('Pharmacy-Issue','Pharmacy-Return') AND PMH.Type='OPD'");

            sb.Append("  GROUP BY flp.LedgerTransactionNo )t where t.PendingAmt >0 ");
        sb.Append(" Order by t.PatientID");
        DataTable dtSearch = StockReports.GetDataTable(sb.ToString());
        return dtSearch;
    }
    public string OPDBillRegistration(string PatientID, int PanelID, MySqlTransaction tranX, int rateListID, string DoctorID, string HospPatientType, string ChargesApp, string CurrentAge, MySqlConnection con, string PatientType_ID, int ParentID)
    {
        try
        {

            string RefCodeopd = Util.GetString(MySqlHelper.ExecuteScalar(con,CommandType.Text,"SELECT ReferenceCodeOPD FROM f_panel_master where PanelID=" + PanelID + " "));
            decimal netAmount = 0;
            int count = 0; string returnType = "0";

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT SubCategoryID,TypeName,im.ItemID,IFNULL(rt.Rate,0)Rate,IFNULL(rt.ID,0)rateListID FROM f_itemmaster im ");
            sb.Append(" INNER JOIN f_ratelist rt ON im.itemid=rt.ItemID INNER JOIN f_rate_schedulecharges rsc ON rsc.PanelID =rt.PanelID ");
            sb.Append(" AND rsc.IsDefault=1 AND rsc.ScheduleChargeID=rt.ScheduleChargeID WHERE rt.PanelID=" + RefCodeopd + " AND IsCurrent=1  ");
            
            sb.Append(" AND im.itemID IN ( ");
            if (ChargesApp.Split('#')[0] == "1" && ChargesApp.Split('#')[1] == "1")
                {
                sb.Append(" '" + Resources.Resource.RegistrationItemID + "','" + Resources.Resource.HospitalChargeItemID + "' ");
                count = 2; returnType = "1";
                }
            else if (ChargesApp.Split('#')[0] == "1")
                {
                sb.Append(" '" + Resources.Resource.RegistrationItemID + "' ");
                count = 1; returnType = "2";
                }
            else if (ChargesApp.Split('#')[1] == "1")
                {
                sb.Append(" '" + Resources.Resource.HospitalChargeItemID + "' ");
                count = 1; returnType = "3";                
                }
            sb.Append(" ) ");
           DataTable rateInfo = MySqlHelper.ExecuteDataset(con,CommandType.Text, sb.ToString()).Tables[0];


            sb.Clear();

            if (count != rateInfo.Rows.Count)
                {
                return returnType;               
                }
          

            netAmount = Util.GetDecimal(rateInfo.AsEnumerable().Sum(x=>x.Field<decimal>("Rate")));
            string LedgerTransactionNo = string.Empty;
            string TransactionId = string.Empty;
            string doctorID = string.Empty;
            if (DoctorID == "")
                doctorID = Util.GetString(Resources.Resource.DoctorID_Self);
            else
                doctorID = DoctorID;
            string UniqueHash = Util.getHash();
            Patient_Medical_History objPMH = new Patient_Medical_History(tranX);
            objPMH.PatientID = Util.GetString(PatientID);
            objPMH.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            objPMH.Time = Util.GetDateTime(DateTime.Now.ToString("HH:mm:ss"));
            objPMH.DateOfVisit = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
            objPMH.Type = "OPD";
            objPMH.PanelID =PanelID;
            objPMH.ParentID = ParentID;
            objPMH.DoctorID = Util.GetString(doctorID);
            objPMH.ScheduleChargeID = Util.GetInt(MySqlHelper.ExecuteScalar(con,CommandType.Text,"SELECT SchedulechargeID from f_rate_schedulecharges where PanelID=" + PanelID + "  AND IsDefault=1"));
            objPMH.HashCode = UniqueHash;
            objPMH.IsNewPatient = 1;
            objPMH.patient_type = HospPatientType;
            objPMH.Source = "Registration";
            objPMH.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            objPMH.UserID = HttpContext.Current.Session["ID"].ToString();
            objPMH.EntryDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
            TransactionId = objPMH.Insert();
            if (TransactionId == string.Empty)
                {
                tranX.Rollback();
                return "";
                }

            int PaymentModeID = 0;
            string PaymentMode = "";
            PaymentModeID = Util.GetInt(MySqlHelper.ExecuteScalar(con,CommandType.Text,"Select COUNT(*) FROM f_panel_master WHERE PanelID=" + PanelID + " AND PaymentMode=4 AND IsActive=1"));
            if (PaymentModeID > 0)
            {
                PaymentModeID = 4;
                PaymentMode = "Credit";
            }
            else
            {
                PaymentModeID = 1;
                PaymentMode = "Cash";
            }

            EncounterNo = Encounter.FindEncounterNo(PatientID);
            if (EncounterNo == 0)
            {
                tranX.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Encounter No." });

            }
            Ledger_Transaction ObjLdgTnx = new Ledger_Transaction(tranX);
            AllQuery AQ = new AllQuery(tranX);
            ObjLdgTnx.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();


            string LedgerNoCr = AllQuery.GetLedgerNoByLedgerUserID(PatientID, "PTNT", con);

            if (LedgerNoCr == null)
                ObjLdgTnx.LedgerNoCr = "";
            else
                ObjLdgTnx.LedgerNoCr = LedgerNoCr;
            ObjLdgTnx.LedgerNoDr = AllQuery.GetLedgerNoByLedgerUserID(ObjLdgTnx.Hospital_ID, "HOSP", con);



            ObjLdgTnx.TypeOfTnx = "OPD-OTHERS";
            ObjLdgTnx.Date = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
            ObjLdgTnx.Time = Util.GetDateTime(DateTime.Now.ToString("HH:mm:ss"));
            ObjLdgTnx.NetAmount = Util.GetDecimal(netAmount);
            ObjLdgTnx.GrossAmount = Util.GetDecimal(netAmount);
            ObjLdgTnx.PatientID = PatientID;
            ObjLdgTnx.PanelID = PanelID;
            ObjLdgTnx.TransactionID = TransactionId;
            ObjLdgTnx.UserID = HttpContext.Current.Session["ID"].ToString();
            ObjLdgTnx.DiscountReason = "";
            ObjLdgTnx.DiscountApproveBy = "";
            ObjLdgTnx.DiscountOnTotal = 0;
            ObjLdgTnx.BillNo = SalesEntry.genBillNo_opd(tranX, Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()), con);
            if (ObjLdgTnx.BillNo == "")
            {
                tranX.Rollback();
                return "";
            }
            ObjLdgTnx.BillDate = Util.GetDateTime(DateTime.Now);
            ObjLdgTnx.RoundOff = 0;
            ObjLdgTnx.PaymentModeID = Util.GetInt(PaymentModeID);
            ObjLdgTnx.UniqueHash = UniqueHash;
            ObjLdgTnx.IpAddress = All_LoadData.IpAddress();
            ObjLdgTnx.Adjustment = 0;
            ObjLdgTnx.GovTaxAmount = Util.GetDecimal(0);
            ObjLdgTnx.IsPaid = 0;
            ObjLdgTnx.IsCancel = 0;
            ObjLdgTnx.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            ObjLdgTnx.PatientType = HospPatientType;
            ObjLdgTnx.CurrentAge = Util.GetString(CurrentAge);
            ObjLdgTnx.PatientType_ID = Util.GetInt(PatientType_ID);
            ObjLdgTnx.EncounterNo = Util.GetInt(EncounterNo);
            
            LedgerTransactionNo = ObjLdgTnx.Insert();

            if (LedgerTransactionNo == "")
                {
                tranX.Rollback();
                return "";
                }
            for (int i = 0; i < rateInfo.Rows.Count; i++)
            {
                LedgerTnxDetail ObjLdgTnxDtl = new LedgerTnxDetail(tranX);
                ObjLdgTnxDtl.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
                ObjLdgTnxDtl.LedgerTransactionNo = LedgerTransactionNo;

                ObjLdgTnxDtl.ItemID = Util.GetString(rateInfo.Rows[i]["ItemID"].ToString());
                ObjLdgTnxDtl.ItemName = Util.GetString(rateInfo.Rows[i]["TypeName"].ToString());
                ObjLdgTnxDtl.Rate = Util.GetDecimal(rateInfo.Rows[i]["Rate"].ToString());
                ObjLdgTnxDtl.Amount = Util.GetDecimal(rateInfo.Rows[i]["Rate"].ToString());
                ObjLdgTnxDtl.SubCategoryID = Util.GetString(rateInfo.Rows[i]["SubCategoryID"].ToString());
                ObjLdgTnxDtl.NetItemAmt = Util.GetDecimal(rateInfo.Rows[i]["Rate"].ToString());

                ObjLdgTnxDtl.TotalDiscAmt = Util.GetDecimal(0);
                ObjLdgTnxDtl.Quantity = Util.GetDecimal(1);
                ObjLdgTnxDtl.StockID = "";
                ObjLdgTnxDtl.IsTaxable = "NO";               
                ObjLdgTnxDtl.DiscAmt = Util.GetDecimal(0);
                ObjLdgTnxDtl.DiscountPercentage = Util.GetDecimal(0);
                ObjLdgTnxDtl.IsPackage = 0;
                ObjLdgTnxDtl.PackageID = "";
                ObjLdgTnxDtl.IsVerified = 1;
                ObjLdgTnxDtl.TransactionID = TransactionId;
                
                ObjLdgTnxDtl.UserID = HttpContext.Current.Session["ID"].ToString();
                ObjLdgTnxDtl.EntryDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                ObjLdgTnxDtl.DiscountReason = "";
                ObjLdgTnxDtl.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(ObjLdgTnxDtl.SubCategoryID),con));
                ObjLdgTnxDtl.DoctorID = Util.GetString(doctorID);
                ObjLdgTnxDtl.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                ObjLdgTnxDtl.pageURL = All_LoadData.getCurrentPageName();
                if (rateListID == 0)
                    rateListID = Util.GetInt(rateInfo.Rows[i]["rateListID"].ToString());

                ObjLdgTnxDtl.RateListID = Util.GetInt(rateListID);
                rateListID = 0;
                ObjLdgTnxDtl.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                ObjLdgTnxDtl.Type = "O";
                ObjLdgTnxDtl.IpAddress = All_LoadData.IpAddress();
                string LdgTnxDtlID = ObjLdgTnxDtl.Insert().ToString();
                if (LdgTnxDtlID == "")
                    {
                    tranX.Rollback();
                    return "";
                    }
            }
            return LedgerTransactionNo;
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "";
        }
    }

    public string OPDRegistration(string transactionID, string doctorID, string ledgerTransactionNo, int PanelID, MySqlConnection con, MySqlTransaction tranX, decimal discountPercent = 0, decimal panelCurrencyFactor = 1)//
    {
        try
        {
            var RefCodeopd = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT ReferenceCodeOPD FROM f_panel_master where PanelID=" + PanelID + " "));
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT SubCategoryID,TypeName,im.ItemID,IFNULL(rt.Rate,0)Rate,IFNULL(rt.ID,0)rateListID FROM f_itemmaster im ");
            sb.Append(" INNER JOIN f_ratelist rt ON im.itemid=rt.ItemID INNER JOIN f_rate_schedulecharges rsc ON rsc.PanelID =rt.PanelID ");
            sb.Append(" AND rsc.IsDefault=1 AND rsc.ScheduleChargeID=rt.ScheduleChargeID WHERE rt.PanelID=" + RefCodeopd + " AND IsCurrent=1  ");
            sb.Append(" AND im.itemID='" + Resources.Resource.RegistrationItemID + "'");
            var rateInfo = StockReports.GetDataTable(sb.ToString());

            var rate = Util.GetDecimal(rateInfo.Rows[0]["Rate"].ToString()) * panelCurrencyFactor;
            var DiscountAmount = rate * discountPercent / 100;

            var Amount = rate - DiscountAmount;

          
            LedgerTnxDetail ObjLdgTnxDtl = new LedgerTnxDetail(tranX);
            ObjLdgTnxDtl.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
            ObjLdgTnxDtl.LedgerTransactionNo = ledgerTransactionNo;

            ObjLdgTnxDtl.ItemID = Util.GetString(rateInfo.Rows[0]["ItemID"].ToString());
            ObjLdgTnxDtl.ItemName = Util.GetString(rateInfo.Rows[0]["TypeName"].ToString());
            ObjLdgTnxDtl.Rate = rate;//Util.GetDecimal(rateInfo.Rows[0]["Rate"].ToString());
            ObjLdgTnxDtl.Amount = Amount; //Util.GetDecimal(rateInfo.Rows[0]["Rate"].ToString());
            ObjLdgTnxDtl.SubCategoryID = Util.GetString(rateInfo.Rows[0]["SubCategoryID"].ToString());
            ObjLdgTnxDtl.NetItemAmt = Util.GetDecimal(rateInfo.Rows[0]["Rate"].ToString());

            ObjLdgTnxDtl.TotalDiscAmt = Util.GetDecimal(0);
            ObjLdgTnxDtl.Quantity = Util.GetDecimal(1);
            ObjLdgTnxDtl.StockID = "";
            ObjLdgTnxDtl.IsTaxable = "NO";
            ObjLdgTnxDtl.DiscAmt = Util.GetDecimal(DiscountAmount);
            ObjLdgTnxDtl.DiscountPercentage = Util.GetDecimal(discountPercent);
            ObjLdgTnxDtl.IsPackage = 0;
            ObjLdgTnxDtl.PackageID = "";
            ObjLdgTnxDtl.IsVerified = 1;
            ObjLdgTnxDtl.TransactionID = transactionID;

            ObjLdgTnxDtl.UserID = HttpContext.Current.Session["ID"].ToString();
            ObjLdgTnxDtl.EntryDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
            ObjLdgTnxDtl.DiscountReason = "";
            ObjLdgTnxDtl.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(ObjLdgTnxDtl.SubCategoryID), con));
            ObjLdgTnxDtl.DoctorID = Util.GetString(doctorID);
            ObjLdgTnxDtl.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            ObjLdgTnxDtl.pageURL = All_LoadData.getCurrentPageName();
            ObjLdgTnxDtl.RateListID = Util.GetInt(rateInfo.Rows[0]["rateListID"].ToString());
            //rateListID = 0;
            ObjLdgTnxDtl.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
            ObjLdgTnxDtl.Type = "O";
            ObjLdgTnxDtl.IpAddress = All_LoadData.IpAddress();
            ObjLdgTnxDtl.typeOfTnx = "OPD-OTHERS";
            return ObjLdgTnxDtl.Insert().ToString();

        }
        catch (Exception ex)
        {
            throw ex;
        }
    }


}