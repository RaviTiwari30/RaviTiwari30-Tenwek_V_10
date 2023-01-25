using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Finance_OpeningBalanceEdit : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {


        if (!IsPostBack)
        {
            txtFromDate.Text = txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ceFromDate.EndDate = ceToDate.EndDate = DateTime.Now;
        }
        txtFromDate.Attributes.Add("readonly", "true");
        txtToDate.Attributes.Add("readonly", "true");
    }

    [WebMethod(EnableSession = true)]
    public static string SearchOpeningPatientBills(string fromDate, string toDate, string searchValue,int searchType)
    {
        StringBuilder sqlCMD = new StringBuilder();
        sqlCMD.Append(" SELECT ifnull((SELECT COUNT(*) FROM `f_paymentallocation` p WHERE p.`IsActive`=1 AND p.`IsVerified`=1 AND p.`TransactionID`=adj.TransactionID),0) as IsDoctorAllocationDone, IFNULL((SELECT COUNT(*) FROM f_LedgerTnxDetail ltd WHERE ltd.`TransactionID`=adj.`TransactionID` AND ltd.`IsVerified`=1 AND ltd.`ItemID`='LSHHI20631'),0) AS IsHospitalChargesApplied, TRIM(pm.`PName`) AS PatientName, adj.`PatientID`,REPLACE(adj.`TransactionID`,'ISHHI','') AS IPNo,ADJ.`TransactionID`,ADJ.`BillNo`,DATE_FORMAT(ADJ.`BillDate`,'%d-%b-%Y') AS BillDate, ");
        sqlCMD.Append(" IFNULL((SELECT SUM(p.`AmountPaid`) FROM `f_reciept` p WHERE p.`IsCancel`=0 AND p.`TransactionID`=adj.TransactionID),0) ReceivedAmt,PNL.`PanelID`,adj.`TotalBilledAmt`,pnl.Company_Name PanelName FROM f_ipdadjustment adj  ");
        sqlCMD.Append(" INNER JOIN patient_master pm ON pm.`PatientID`=adj.`PatientID` ");
        sqlCMD.Append(" INNER JOIN `f_panel_master` pnl ON pnl.`PanelID`=adj.`PanelID` ");
        sqlCMD.Append(" WHERE adj.`isopeningBalance`=1 and adj.CentreID=@centreID ");


        if (string.IsNullOrEmpty(searchValue))
            sqlCMD.Append(" and DATE(ADJ.`BillDate`)>=@fromDate and DATE(ADJ.`BillDate`)<=@toDate   ");
        else if(searchType ==1)
            sqlCMD.Append(" and ADJ.BillNo=@SearchValue  ");
        else if (searchType == 2)
            sqlCMD.Append(" and adj.TransactionID=@SearchValue  ");
        else
            sqlCMD.Append(" and ADJ.PatientID=@SearchValue  ");


        sqlCMD.Append(" ORDER BY PatientName ");
        ExcuteCMD excuteCMD = new ExcuteCMD();
        DataTable dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
        {
            fromDate = Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"),
            toDate = Util.GetDateTime(toDate).ToString("yyyy-MM-dd"),
            SearchValue = searchType == 2 ? "ISHHI" + searchValue.Trim() : searchValue.Trim(),
            centreID = HttpContext.Current.Session["CentreID"].ToString()
        });

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string GetBillDetails(string TID)
    {
        StringBuilder sqlCMD = new StringBuilder(" SELECT ltd.*,lt.DiscountApproveBy,ltd.DiscountReason FROM f_ledgertnxdetail ltd INNER JOIN  f_ledgertransaction lt ON lt.LedgertransactionNo=ltd.LedgerTransactionNo  WHERE LTD.`IsVerified`=1 AND LTD.`IsPackage`=0 AND ltd.TypeOfTnx NOT IN('CR','DR') AND ltd.`TransactionID`=@transactionID AND ltd.CentreID=@centreID ");

        ExcuteCMD excuteCMD = new ExcuteCMD();
        DataTable dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
        {
            transactionID = TID,
            centreID = HttpContext.Current.Session["CentreID"].ToString()
        });
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = dt });
    }

    [WebMethod(EnableSession = true)]
    public static string ChangeBillDetails(object LTD, string DiscountReason, string ApprovedBy)
    {

        List<LedgerTnxDetail> ledgerTransactionDetails = new JavaScriptSerializer().ConvertToType<List<LedgerTnxDetail>>(LTD);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        StringBuilder sqlCMD;

        try
        {


            var dataLTD = ledgerTransactionDetails.Where(i => (string.IsNullOrEmpty(i.LedgerTnxID) && i.IsVerified == 1)).ToList();

            var oldLTD = ledgerTransactionDetails.Where(i => !string.IsNullOrEmpty(i.LedgerTnxID)).ToList();


            string ledgerTransactionNo = oldLTD[0].LedgerTransactionNo;

            sqlCMD = new StringBuilder("UPDATE f_ledgertnxdetail  ltd set ltd.`LastUpdatedBy`=@userID,ltd.`UpdatedDate`=now(),ltd.`DiscUserID`=@discUserID,ltd.`DiscountReason`=@discountReason, ltd.TotalDiscAmt=@totalDiscAmt, ltd.IsVerified=@isVerified,ltd.DoctorID=@doctorID,ltd.DiscountPercentage=@discountPercent,ltd.DiscAmt=@discountAmount, ltd.Rate=@rate,ltd.Quantity=@quantity,ltd.Amount=@amount,ltd.GrossAmount=@grossAmount,ltd.NetItemAmt=@netItemAmount WHERE ltd.LedgerTnxID=@ledgerTnxID ");
            for (int i = 0; i < oldLTD.Count; i++)
            {
                decimal grossAmount = oldLTD[i].Rate * oldLTD[i].Quantity;
                decimal discountAmount = (grossAmount * oldLTD[i].DiscountPercentage / 100);
                decimal netAmount = grossAmount - discountAmount;

                excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
                {
                    rate = oldLTD[i].Rate,
                    quantity = oldLTD[i].Quantity,
                    discountPercent = oldLTD[i].DiscountPercentage,
                    discountAmount = discountAmount,
                    amount = netAmount,
                    grossAmount = grossAmount,
                    netItemAmount = netAmount,
                    ledgerTnxID = oldLTD[i].LedgerTnxID,
                    doctorID = oldLTD[i].DoctorID,
                    isVerified = oldLTD[i].IsVerified,
                    totalDiscAmt = discountAmount,
                    userID= HttpContext.Current.Session["ID"].ToString(),
                    discountReason = discountAmount > 0 ? DiscountReason : "",
                    discUserID = discountAmount>0? HttpContext.Current.Session["ID"].ToString() :""
                    //update by, entry by
                });
                string docstring = All_LoadData.CalcaluteDoctorShare(oldLTD[i].LedgerTnxID, "", "2", "HOSP", tnx, con);
            }


            for (int i = 0; i < dataLTD.Count; i++)
            {


                LedgerTnxDetail ObjLdgTnxDtl = new LedgerTnxDetail(tnx);
                ObjLdgTnxDtl.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
                ObjLdgTnxDtl.LedgerTransactionNo = ledgerTransactionNo;
                ObjLdgTnxDtl.ItemID = Util.GetString(dataLTD[i].ItemID).Trim();
                ObjLdgTnxDtl.Rate = Util.GetDecimal(dataLTD[i].Rate);
                ObjLdgTnxDtl.Quantity = Util.GetDecimal(dataLTD[i].Quantity);
                ObjLdgTnxDtl.StockID = string.Empty;
                ObjLdgTnxDtl.IsTaxable = "NO";



                decimal grossAmount = dataLTD[i].Rate * dataLTD[i].Quantity;
                decimal discountAmount = (grossAmount * dataLTD[i].DiscountPercentage / 100);
                decimal netAmount = grossAmount - discountAmount;

                ObjLdgTnxDtl.IsPackage = 0;
                ObjLdgTnxDtl.DiscAmt = Util.GetDecimal(discountAmount);
                ObjLdgTnxDtl.DiscountPercentage = dataLTD[i].DiscountPercentage;
                ObjLdgTnxDtl.Amount = netAmount;
                ObjLdgTnxDtl.NetItemAmt = ObjLdgTnxDtl.Amount;
                ObjLdgTnxDtl.TotalDiscAmt = discountAmount;

                if (ObjLdgTnxDtl.DiscountPercentage > 0)
                    ObjLdgTnxDtl.DiscUserID = HttpContext.Current.Session["ID"].ToString();

                ObjLdgTnxDtl.PackageID = string.Empty;

                ObjLdgTnxDtl.IsVerified = 1;
                ObjLdgTnxDtl.TransactionID = Util.GetString(dataLTD[i].TransactionID).Trim();
                ObjLdgTnxDtl.SubCategoryID = Util.GetString(dataLTD[i].SubCategoryID).Trim();
                ObjLdgTnxDtl.ItemName = Util.GetString(dataLTD[i].ItemName).Trim();
                ObjLdgTnxDtl.UserID = HttpContext.Current.Session["ID"].ToString();
                ObjLdgTnxDtl.EntryDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                ObjLdgTnxDtl.DiscountReason = Util.GetString(DiscountReason);
                ObjLdgTnxDtl.DoctorID = dataLTD[i].DoctorID.Trim();
                ObjLdgTnxDtl.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(dataLTD[i].SubCategoryID), con));
                ObjLdgTnxDtl.TnxTypeID = Util.GetInt(dataLTD[i].TnxTypeID);

                ObjLdgTnxDtl.pageURL = All_LoadData.getCurrentPageName();
                ObjLdgTnxDtl.RateListID = 1;
                ObjLdgTnxDtl.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                ObjLdgTnxDtl.Type = "I";
                ObjLdgTnxDtl.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                ObjLdgTnxDtl.IpAddress = All_LoadData.IpAddress();
                ObjLdgTnxDtl.rateItemCode = "";
                ObjLdgTnxDtl.VerifiedDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                ObjLdgTnxDtl.VarifiedUserID = HttpContext.Current.Session["ID"].ToString();
                ObjLdgTnxDtl.roundOff = Util.GetDecimal(0 / dataLTD.Count);

                ObjLdgTnxDtl.typeOfTnx = "IPD-Billing";

                ObjLdgTnxDtl.CoPayPercent = 0;
                ObjLdgTnxDtl.IsPayable = 0;
                ObjLdgTnxDtl.isPanelWiseDisc = 0;
                ObjLdgTnxDtl.panelCurrencyCountryID = oldLTD[0].panelCurrencyCountryID;
                ObjLdgTnxDtl.panelCurrencyFactor = oldLTD[0].panelCurrencyFactor;
                ObjLdgTnxDtl.IPDCaseTypeID = oldLTD[0].IPDCaseTypeID;
                ObjLdgTnxDtl.RoomID = oldLTD[0].RoomID;
                ObjLdgTnxDtl.DeptLedgerNo = HttpContext.Current.Session["DeptLedgerNo"].ToString();
                ObjLdgTnxDtl.salesID = dataLTD[i].salesID;

                string LdgTnxDtlID = ObjLdgTnxDtl.Insert().ToString();

            }

            sqlCMD = new StringBuilder("UPDATE f_ledgertransaction lt SET lt.DiscountReason=@discountReason,lt.DiscountApproveBy=@discountApprovedBy WHERE lt.LedgertransactionNo=@ledgerTransactionNo");


            excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
            {
                discountReason = DiscountReason,
                discountApprovedBy = ApprovedBy,
                ledgerTransactionNo = ledgerTransactionNo
            });


            string UpdateQuery = "Call updateEmergencyBillAmounts(" + ledgerTransactionNo + ")";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, UpdateQuery);


            excuteCMD.DML(tnx, " Call UpdateIPDAdmittingBilling(@transactionID) ", CommandType.Text, new
            {
                transactionID = oldLTD[0].TransactionID
            });

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}