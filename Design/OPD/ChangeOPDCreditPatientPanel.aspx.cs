using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;
using MySql.Data.MySqlClient;

public partial class Design_OPD_ChangeOPDCreditPatientPanel : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            All_LoadData.BindRelation(ddlHolderRelation);
            lblUserID.Text = Session["ID"].ToString();
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            //txtExpiryDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            calExpiryDate.StartDate = DateTime.Now;
            txtBillNo.Focus();
        }
        txtFromDate.Attributes.Add("readOnly", "readOnly");
        txtToDate.Attributes.Add("readOnly", "readOnly");
        txtExpiryDate.Attributes.Add("readOnly", "readOnly");
    }

    [WebMethod]
    public static string Search(string Barcode, string billNo, string mrNo, string fromDate, string toDate)
    {
        string result = "0";
        StringBuilder query = new StringBuilder();
        query.Append(" SELECT pm.PatientID,(lt.NetAmount-lt.`Adjustment`)BalanceAmt,CONCAT(pm.Title,' ',pm.PName)PName,CONCAT(pm.Age,'/',pm.Gender)AgeGender,lt.TypeOfTnx,lt.LedgerTransactionNo,lt.BillNo, ");
        query.Append(" DATE_FORMAT(lt.Date,'%d-%b-%Y')`BillDate`,DATE_FORMAT(lt.Time,'%h:%i %p')`BillTime`,NetAmount,fpm.Company_Name,fpm.PanelID,pmh.TransactionID, ");
        query.Append(" PolicyNo,DATE_FORMAT(ExpiryDate,'%d-%b-%Y')ExpiryDate,CardNo,CardHolderName,RelationWith_holder ");
        query.Append(" FROM f_ledgertransaction lt INNER JOIN patient_medical_history pmh ON lt.TransactionID=pmh.TransactionID ");
        query.Append(" INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID INNER JOIN f_panel_master fpm ON pmh.PanelID=fpm.PanelID ");
        query.Append(" WHERE lt.IsCancel=0 AND pmh.Type='OPD' ");
        query.Append(" AND lt.TypeOfTnx in('OPD-APPOINTMENT','OPD-BILLING','OPD-LAB','OPD-OTHERS','OPD-Package','OPD-PROCEDURE') ");

        if (billNo != "")
        {
            query.Append(" AND lt.BillNo='" + billNo + "' ");
        }
        if (Barcode != "")
        {
            query.Append(" AND pm.PatientID='" + Barcode + "' ");
        }

        if (mrNo != "")
        {
            query.Append(" AND pm.PatientID='" + mrNo + "' ");
        }

        if (billNo == "" && mrNo == "" && Barcode == "")
        {
            query.Append(" AND DATE(lt.Date)>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND DATE(lt.Date)<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ");
        }

        query.Append(" AND lt.NetAmount>0 ");
        query.Append(" ORDER BY DATE(lt.Date) LIMIT 100 ");

        DataTable dt = StockReports.GetDataTable(query.ToString());

        if (dt.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

        return result;
    }

    [WebMethod]
    public static string SearchBillDetails(string ledgerTnxNo, string panelID, string referenceCodeOPD, string typeOfTnx)
    {
        string result = "0";

        StringBuilder query = new StringBuilder();

        query.Append(" SELECT lt.ledgertransactionno,LedgerTnxID,ltd.ItemID,ltd.ItemName,ltd.Quantity,ltd.Rate ExistingRate,ROUND(((ltd.Rate *ltd.Quantity*ltd.DiscountPercentage)/100),4) ExistingDiscAmt,ltd.Amount ExistingAmount, ");
        query.Append(" IFNULL(rt.Rate,0)ProposedRate,ROUND((( IFNULL(rt.Rate,0) * ltd.Quantity)*ltd.DiscountPercentage)/100,4)ProposedDiscAmt,ROUND((IFNULL(rt.Rate,0) * ltd.Quantity)-((( IFNULL(rt.Rate,0) * ltd.Quantity)*ltd.DiscountPercentage)/100),4)ProposedAmount, ");
        query.Append(" ((IFNULL(rt.Rate,0) * ltd.Quantity)-(( IFNULL(rt.Rate,0) * ltd.Quantity)*ltd.DiscountPercentage)/100)-ltd.Amount AmtDiff,sch.ScheduleChargeID,rt.PanelID ProposedPanelID,lt.Adjustment ");
        query.Append(" FROM f_LedgerTransaction lt INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo=ltd.LedgerTransactionNo LEFT JOIN f_ratelist rt ON ltd.itemid = rt.itemid AND rt.PanelID=" + referenceCodeOPD + " AND rt.IsCurrent=1 ");
        query.Append(" LEFT JOIN f_rate_schedulecharges sch ON sch.panelID = rt.PanelID AND sch.IsDefault=1 WHERE ltd.LedgerTransactionNo='" + ledgerTnxNo + "' AND lt.IsCancel=0 ");

        DataTable dt = StockReports.GetDataTable(query.ToString());

        if (dt.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

        return result;
    }

    [WebMethod(EnableSession = true)]
    public static string UpdatePanel(object dataBill, string userID, object PaymentData, decimal ReceiptAmt, decimal RecRoundOff)
    {
        bool result = false;
        string ReceiptNo = "";

        string IsBill = "1";
        List<BillDetail> objBill = new JavaScriptSerializer().ConvertToType<List<BillDetail>>(dataBill);
        List<Ledger_Transaction_PaymentDetail> dataPaymentDetail = new JavaScriptSerializer().ConvertToType<List<Ledger_Transaction_PaymentDetail>>(PaymentData);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.ReadCommitted);

        try
        {
            decimal netAmount = 0;
            decimal grossAmount = 0;
            decimal amount = 0;
            decimal discount = 0;
            decimal roundOff = 0;

            for (int i = 0; i < objBill.Count; i++)
            {
                grossAmount += (objBill[i].Rate * objBill[i].Quantity);
                amount += (objBill[i].Rate * objBill[i].Quantity) - objBill[i].DiscAmt;
                discount += objBill[i].DiscAmt;
            }

            netAmount = Math.Round(amount, MidpointRounding.AwayFromZero);

            roundOff = netAmount - amount;
            string query = "UPDATE Patient_Medical_History Set PanelPaybleAmt='" + netAmount + "', PanelPaidAmt=0,PatientPaybleAmt=0, PatientPaidAmt=0 , PanelID=" + objBill[0].PanelID + ",ScheduleChargeID='" + objBill[0].ScheduleChargeID + "', " +
                           "PolicyNo='" + objBill[0].PolicyNo + "',ExpiryDate='" + Util.GetDateTime(objBill[0].ExpiryDate).ToString("yyyy-MM-dd") + "',CardNo='" + objBill[0].CardNo + "', " +
                           "Employee_ID='" + objBill[0].StaffID + "',CardHolderName='" + objBill[0].CardHolder + "',RelationWith_holder='" + objBill[0].CardHolderRelation + "',LastUpdatedBy = '" + userID + "', " +
                           "Updatedate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "' Where TransactionID='" + objBill[0].TransactionID + "'";
            MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, query);

            query = "UPDATE f_ledgertransaction SET Adjustment=0,NetAmount='" + netAmount + "',GrossAmount='" + grossAmount + "',DiscountOnTotal='" + discount + "',PanelID=" + objBill[0].PanelID + ", " +
                    "RoundOff='" + roundOff + "',EditUserID='" + userID + "',EditDateTime=NOW() WHERE LedgertransactionNo='" + objBill[0].LedgerTnxNo + "' ";
            MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, query);

            query = "UPDATE f_reciept r SET r.PanelID=" + objBill[0].PanelID + " WHERE r.AsainstLedgerTnxNo='" + objBill[0].LedgerTnxNo + "' ";
            MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, query);

            for (int i = 0; i < objBill.Count; i++)
            {
                amount = (objBill[i].Rate * objBill[i].Quantity) - objBill[i].DiscAmt;
                query = "UPDATE f_ledgertnxdetail SET Rate='" + objBill[i].Rate + "',Amount='" + amount + "',NetItemAmt='" + amount + "',DiscAmt='" + objBill[i].DiscAmt + "', " +
                    //"LastUpdatedBy='" + userID + "',UpdatedDate=NOW() WHERE LedgertransactionNo='" + objBill[i].LedgerTnxNo + "' AND ItemID='" + objBill[i].ItemID + "'  ";
                        "LastUpdatedBy='" + userID + "',UpdatedDate=NOW() WHERE LedgerTnxID='" + objBill[i].LedgerTnxID + "' ";
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, query);
            }

            query = "INSERT INTO f_opdpanelchange(PatientID,BillNo,OldPanelID,NewPanelID,OldAmount,NewAmount,AmtDiff,EntryDate,EntryBy,IpAddress) " +
                    "VALUES('" + objBill[0].PatientID + "','" + objBill[0].BillNo + "','" + objBill[0].OldPanelID + "'," + objBill[0].PanelID + ", " +
                    "'" + objBill[0].OldAmount + "','" + objBill[0].NewAmount + "','" + objBill[0].AmtDiff + "',NOW(),'" + userID + "','" + Util.GetString(HttpContext.Current.Session["ClientIP"]) + "')";
            MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, query);

            if ((dataPaymentDetail[0].PaymentMode.ToString() != "Credit") && (Util.GetDecimal(ReceiptAmt) > 0))
            {

                Receipt ObjReceipt = new Receipt(tranx);
                ObjReceipt.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                ObjReceipt.AmountPaid = -1* Util.GetDecimal(ReceiptAmt);
                ObjReceipt.LedgerNoDr = "HOSP0001";
                ObjReceipt.AsainstLedgerTnxNo = objBill[0].LedgerTnxNo;
                ObjReceipt.Date = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                ObjReceipt.Time = Util.GetDateTime(DateTime.Now.ToString("HH:mm:ss"));
                ObjReceipt.Depositor = objBill[0].PatientID;
                ObjReceipt.Discount = 0;
                ObjReceipt.PanelID = Util.GetInt(objBill[0].PanelID);
                ObjReceipt.Reciever = HttpContext.Current.Session["ID"].ToString();
                ObjReceipt.Depositor = objBill[0].PatientID;
                ObjReceipt.TransactionID = objBill[0].TransactionID;
                ObjReceipt.RoundOff = Util.GetDecimal(RecRoundOff);
                ObjReceipt.LedgerNoCr = "OPD003";

                ObjReceipt.PaidBy = "PAT";
                ObjReceipt.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                ObjReceipt.IpAddress = All_LoadData.IpAddress();
                ObjReceipt.isBloodBankItem = "0";
                ReceiptNo = ObjReceipt.Insert();
                if (ReceiptNo == "")
                {
                    tranx.Rollback();
                    result = false;
                }
                Receipt_PaymentDetail ObjReceiptPayment = new Receipt_PaymentDetail(tranx);
                for (int i = 0; i < dataPaymentDetail.Count; i++)
                {
                    ObjReceiptPayment.PaymentModeID = Util.GetInt(dataPaymentDetail[i].PaymentModeID);
                    ObjReceiptPayment.PaymentMode = Util.GetString(dataPaymentDetail[i].PaymentMode);
                    ObjReceiptPayment.Amount = -1 * Util.GetDecimal(dataPaymentDetail[i].Amount);
                    ObjReceiptPayment.ReceiptNo = ReceiptNo;
                    ObjReceiptPayment.PaymentRemarks = Util.GetString(dataPaymentDetail[i].PaymentRemarks);
                    ObjReceiptPayment.RefDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                    ObjReceiptPayment.RefNo = Util.GetString(dataPaymentDetail[i].RefNo);
                    ObjReceiptPayment.BankName = Util.GetString(dataPaymentDetail[i].BankName);
                    ObjReceiptPayment.C_Factor = Util.GetDecimal(dataPaymentDetail[i].C_Factor);
                    ObjReceiptPayment.S_Amount = Util.GetDecimal(dataPaymentDetail[i].S_Amount);
                    ObjReceiptPayment.S_CountryID = Util.GetInt(dataPaymentDetail[i].S_CountryID);
                    ObjReceiptPayment.S_Currency = Util.GetString(dataPaymentDetail[i].S_Currency);
                    ObjReceiptPayment.S_Notation = Util.GetString(dataPaymentDetail[i].S_Notation);
                    ObjReceiptPayment.currencyRoundOff = Util.GetDecimal(dataPaymentDetail[i].currencyRoundOff);
                    ObjReceiptPayment.swipeMachine = Util.GetString(dataPaymentDetail[i].swipeMachine);
                    ObjReceiptPayment.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    ObjReceiptPayment.Hospital_ID = Util.GetString(HttpContext.Current.Session["HOSPID"].ToString());

                    string PaymentID = ObjReceiptPayment.Insert().ToString();
                    if (PaymentID == "")
                    {
                        tranx.Rollback();
                        result = false;
                    }
                }
                IsBill = "0";
            }


         
            tranx.Commit();
            result = true;

        }
        catch (Exception ex)
        {
            tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            tranx.Dispose();
            con.Close();
            con.Dispose();
        }

       
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = result, response = "Panel Updated Successfully", IsBillGenerate = IsBill, LedgerTransacTionNo = objBill[0].LedgerTnxNo, RecNo = ReceiptNo });
    }
}

class BillDetail
{
    public string PatientID { get; set; }
    public string TransactionID { get; set; }
    public string OldPanelID { get; set; }
    public string PolicyNo { get; set; }
    public string ExpiryDate { get; set; }
    public string StaffID { get; set; }
    public string CardNo { get; set; }
    public string CardHolder { get; set; }
    public string CardHolderRelation { get; set; }
    public decimal OldAmount { get; set; }
    public decimal NewAmount { get; set; }
    public decimal AmtDiff { get; set; }

    public string BillNo { get; set; }
    public string LedgerTnxNo { get; set; }
    public string PanelID { get; set; }
    public string ScheduleChargeID { get; set; }
    public string ItemID { get; set; }
    public decimal Quantity { get; set; }
    public decimal Rate { get; set; }
    public decimal DiscAmt { get; set; }
    public string TypeOfTnx { get; set; }
    public string LedgerTnxID { get; set; }
}

