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
using MySql.Data.MySqlClient;
using System.Web.UI.HtmlControls;

public partial class Design_Store_PharmacyEditBill : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ((HtmlTable)PaymentControl.FindControl("tblPaymentDetail")).Attributes.Add("style", "display:none");
        ((HtmlTableRow)PaymentControl.FindControl("trAddAmount")).Attributes.Add("style", "display:none");
        ((HtmlTableRow)PaymentControl.FindControl("trPaymentMode")).Attributes.Add("style", "display:none");
        ((HtmlTableRow)PaymentControl.FindControl("trPaymentModeCon")).Attributes.Add("style", "display:none");
    }
    [WebMethod(Description = "Search OPD Pharmacy Return")]
    public static string pharmacyReturnSearch(string BillNo)
    {

        //int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_ledgertransaction WHERE BillNo='" + BillNo + "' AND DATE_ADD(CONCAT(DATE,' ',TIME), INTERVAL 2 HOUR) > NOW()"));
        //if (count > 0)
        //    return "2";

        if (Resources.Resource.AllowFiananceIntegration == "2")//
        {
            string TransactionID = StockReports.ExecuteScalar("Select pmh.TransactionID from patient_medical_history pmh where pmh.Billno='" + BillNo + "'");
            if (TransactionID != "")
            {
                if (AllLoadData_IPD.CheckDataPostToFinance(TransactionID) > 0)
                {
                    string Msga = "Patient's Final Bill Already Posted To Finance...";

                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message =  Msga });


                }
            }
        }
      

            StringBuilder sb = new StringBuilder();

            sb.Append("SELECT tt.* FROM ");
            sb.Append(" ( SELECT t.LedgerTransactionNo,t.TransactionID,t.ReceiptNo,t.NetAmount,t.DiscountOnTotal,t.GrossAmount,t.Adjustment,t.DATE, ");
            sb.Append("   t.TypeOfTnx,t.CustomerID,t.PName,t.Age,t.ContactNo,t.Address,t.PatientID,t.PanelID,t.DoctorID,t.Type_ID,t.IsUsable,t.ServiceItemID,t.ToBeBilled,t.BillNo,t.IsExpirable, ");
            sb.Append("   t.BatchNumber,t.MedExpiryDate,(t.AvlQty-IFNULL(rt.ReturnQty,0))AvlQty,t.UnitType,t.StockID,t.ItemID,t.ItemName,t.SubCategoryID,t.PerUnitBuyPrice,t.MRP,t.DiscountApproveBy,t.DiscountReason,t.GovTaxPer,t.GovTaxAmount,t.PaymentMode,ROUND(t.NetAmount+t.GovTaxAmount-t.Adjustment)Balance,t.IsPaid,t.ID,t.sdID,t.DeptLedgerNo FROM ");
            sb.Append("   ( SELECT DISTINCT(LT.LedgerTransactionNo),LT.TransactionID,r.ReceiptNo, ROUND(LT.NetAmount,2)NetAmount,ROUND(LT.DiscountOnTotal,2)DiscountOnTotal,ROUND(LT.GrossAmount,2)GrossAmount,Round(LT.Adjustment,2)Adjustment,DATE_FORMAT(LT.Date,'%d-%b-%y %T')DATE,   ");
            sb.Append("     IF(PM.PatientID<>'CASH002',CONCAT(PM.Title,' ',PM.Pname),(SELECT CONCAT(Title,' ',NAME)NAME FROM patient_general_master WHERE AgainstLedgerTnxNo=lt.LedgerTransactionNo))PName, ");
            sb.Append("     IF(PM.PatientID<>'CASH002','',(SELECT CustomerID FROM patient_general_master WHERE AgainstLedgerTnxNo=lt.LedgerTransactionNo))CustomerID, ");
            sb.Append("     IF(PM.PatientID<>'CASH002',PM.Age,(SELECT Age FROM patient_general_master WHERE AgainstLedgerTnxNo=lt.LedgerTransactionNo))Age, ");
            sb.Append("     IF(PM.PatientID<>'CASH002',IF(IFNULL(pm.Mobile,'')='',pm.Phone,pm.Mobile),(SELECT ContactNo FROM patient_general_master WHERE AgainstLedgerTnxNo=lt.LedgerTransactionNo))ContactNo, ");
            sb.Append("     IF(PM.PatientID<>'CASH002',CONCAT(IFNULL(PM.House_No,''),' ',IFNULL(PM.Street_Name,''),' ',IFNULL(PM.Locality,''),' ',IFNULL(PM.City,'')),(SELECT Address FROM patient_general_master WHERE AgainstLedgerTnxNo=lt.LedgerTransactionNo))Address, ");
            sb.Append("    LT.TypeOfTnx,' ',   ");
            sb.Append("    pm.PatientID,pmh.PanelID,pmh.DoctorID,im.Type_ID,im.IsUsable,im.ServiceItemID,im.ToBeBilled,im.IsExpirable,   ");
            sb.Append("    LT.BillNo,st.BatchNumber, DATE_FORMAT(st.MedExpiryDate,'%d-%b-%Y') AS MedExpiryDate,   ");
            sb.Append("    sd.SoldUnits AS AvlQty,st.UnitType,st.StockID,st.ItemID,st.ItemName,st.SubCategoryID,sd.PerUnitBuyPrice,sd.PerUnitSellingPrice AS MRP,lt.DiscountApproveBy,lt.DiscountReason,lt.GovTaxPer,lt.GovTaxAmount,IF(LT.PaymentModeID=4,'Credit','Cash')PaymentMode,LT.IsPaid,LTD.ID,sd.ID sdID,fpm.applyCreditLimit,lt.DeptLedgerNo FROM f_ledgertransaction LT    ");
            sb.Append("    INNER JOIN f_ledgertnxdetail LTD ON LT.LedgerTransactionNo=LTD.LedgerTransactionNo    ");
            sb.Append("    left JOIN f_reciept r ON lt.LedgerTransactionNo = r.AsainstLedgerTnxNo   ");
            sb.Append("    INNER JOIN f_stock ST ON LTD.StockID=ST.StockID INNER JOIN f_itemmaster IM ON ST.ItemID=IM.ItemID   ");
            sb.Append("    INNER JOIN f_salesdetails sd ON sd.LedgerTransactionNo=lt.LedgerTransactionNo  AND st.StockID=sd.StockID   ");
            sb.Append("    INNER JOIN  patient_master PM ON LT.PatientID=PM.PatientID    ");
            sb.Append("    INNER JOIN patient_medical_history pmh ON lt.TransactionID = pmh.TransactionID  INNER JOIN f_panel_master fpm ON fpm.PanelID=pmh.PanelID ");
            sb.Append("    WHERE LT.TypeOfTnx IN ('Pharmacy-Issue')  AND lt.Adjustment=0  AND IFNULL(lt.panelInvoiceNo,'')='' AND LT.IsCancel=0  ");

            if (BillNo.Trim() != "")
            {
                sb.Append("AND lt.BillNo='" + BillNo.Trim() + "' ");
            }
            sb.Append("  AND ltd.IsVerified=1) t ");
            sb.Append("LEFT OUTER JOIN (SELECT LedgerTransactionNo,AgainstLedgerTnxNo,StockID,ItemID,SUM(SoldUnits) ReturnQty,SUM(PerUnitSellingPrice) AS MRP FROM f_salesdetails WHERE ");

            sb.Append(" AgainstLedgerTnxNo=(SELECT LedgerTransactionNo FROM f_ledgertransaction WHERE BillNo='" + BillNo.Trim() + "') ");
            sb.Append("AND IsReturn=1 GROUP BY StockID) AS rt ON t.LedgerTransactionNo = rt.AgainstLedgerTnxNo AND t.StockID = rt.StockID  ");
            sb.Append(" )tt WHERE tt.AvlQty>0  ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if ((dt.Rows.Count > 0) && (dt != null))
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            else
                return "";
        
    }
    [WebMethod(EnableSession = true)]
    public static string editPharmacyBillBill(object detail, string LedgertransactionNo, string TransactionID, string PatientID, string BillAmt, int type, string cancelReason)
    {
        List<patientEditBill> billDetail = new JavaScriptSerializer().ConvertToType<List<patientEditBill>>(detail);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int IsMultiPanel=1;
            if (type == 1)
            {

                PanelAllocation Pa = new PanelAllocation();

                IsMultiPanel = Pa.IsMultipanel(TransactionID);

                if (IsMultiPanel == 0)
                {
                    Pa.InserDrNotesEntry(TransactionID, Util.GetDecimal(BillAmt), tnx);
                }
                


                string sqlCopay = "SELECT IFNULL((IFNULL(pmh.PatientPaybleAmt,0)*100/lt.NetAmount),0) AS PatientPayblePer FROM patient_medical_history pmh INNER JOIN f_ledgertransaction lt ON lt.TransactionID=pmh.TransactionID WHERE lt.LedgertransactionNo='" + LedgertransactionNo + "'";

                decimal PatientPayblePer = Util.GetDecimal(MySqlHelperNEw.ExecuteScalar(tnx, CommandType.Text, sqlCopay));

                string selectedLTDID = ""; string selectedSDID = "";
                for (int i = 0; i < billDetail.Count; i++)
                {

                    if (billDetail[i].LTDID != "")
                    {
                        if (selectedLTDID != "")
                        {
                            selectedLTDID += ",'" + billDetail[i].LTDID + "'";
                        }
                        else
                        {
                            selectedLTDID = "'" + billDetail[i].LTDID + "'";
                        }
                    }
                    if (billDetail[i].SDID != "")
                    {
                        if (selectedSDID != "")
                        {
                            selectedSDID += ",'" + billDetail[i].SDID + "'";
                        }
                        else
                        {
                            selectedSDID = "'" + billDetail[i].SDID + "'";
                        }
                    }

                    string updateltd = "UPDATE f_ledgertnxdetail ltd SET ltd.Quantity=ltd.Quantity-'" + Util.GetDecimal(billDetail[i].Quantity) + "' WHERE ltd.ID=" + billDetail[i].LTDID + " ";
                    int ResultLTDQty = MySqlHelperNEw.ExecuteNonQuery(tnx, CommandType.Text, updateltd);
                    if (ResultLTDQty < 1)
                    {
                        tnx.Rollback();
                        return "0";
                    }
                    string strLTD = "UPDATE f_ledgertnxdetail ltd SET ltd.DiscAmt=(((ltd.Rate*ltd.Quantity)*ltd.DiscountPercentage)*100),  " +
                        "ltd.Amount = ((ltd.Quantity * ltd.Rate) - (((ltd.Rate*ltd.Quantity)*ltd.DiscountPercentage)*100)),ltd.TotalDiscAmt=ltd.DiscAmt,ltd.NetItemAmt = ltd.Amount,ltd.GrossAmount = (ltd.Rate * ltd.Quantity),  " +
                        "ltd.UpdateDate = NOW(),ltd.LastUpdatedBy = '" + HttpContext.Current.Session["ID"].ToString() + "',ltd.IsVerified = IF(ltd.Quantity=0,2,1)  WHERE ID = " + billDetail[i].LTDID + "";
                    
                    int ResultLTD = MySqlHelperNEw.ExecuteNonQuery(tnx, CommandType.Text, strLTD);

                    if (ResultLTD < 1)
                    {
                        tnx.Rollback();
                        return "0";
                    }
                    int sdstring = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " update f_salesdetails SET SoldUnits=SoldUnits -'" + Util.GetDecimal(billDetail[i].Quantity) + "' WHERE  LedgerTransactionNo='" + LedgertransactionNo + "' AND  StockID='" + Util.GetString(billDetail[i].StockID) + "' AND ID="+ billDetail[i].SDID + " ");
                    if (sdstring < 1)
                    {
                        tnx.Rollback();
                        return "0";
                    }
                    float soldstock = Util.GetFloat(StockReports.ExecuteScalar("SELECT SUM(sd.SoldUnits) FROM  f_salesdetails sd WHERE sd.LedgerTransactionNo='" + LedgertransactionNo + "' AND  StockID='" + Util.GetString(billDetail[i].StockID) + "' AND PatientID='" + PatientID + "'"));
                    float returnstock = Util.GetFloat(StockReports.ExecuteScalar("SELECT SUM(sd.SoldUnits) FROM  f_salesdetails sd WHERE sd.AgainstLedgerTnxNo='" + LedgertransactionNo + "' AND  StockID='" + Util.GetString(billDetail[i].StockID) + "' AND PatientID='" + PatientID + "'"));
                    if (soldstock <= returnstock && soldstock != 0.00 && returnstock != 0.00)
                    {
                        tnx.Rollback();
                        return "2";
                    }
                    string strStock = "";
                    strStock = "update f_stock set ReleasedCount = ReleasedCount -  " + Util.GetDecimal(billDetail[i].Quantity) + " where StockID = '" + Util.GetString(billDetail[i].StockID) + "' and ReleasedCount - " + billDetail[i].Quantity + "<=InitialCount";
                    if (MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strStock) == 0)
                    {
                        tnx.Rollback();
                        return "2";
                    }
                }


                int ResultLT = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "CALL updatePharmacyBillNew('" + TransactionID + "','" + PatientID + "','" + LedgertransactionNo + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + HttpContext.Current.Request.UserHostAddress + "'," + PatientPayblePer + ")");
                if (ResultLT < 1)
                {
                    tnx.Rollback();
                    return "0";
                }
            }
            tnx.Commit();
            if (IsMultiPanel == 0 || IsMultiPanel == 2)
            {
                return "1";
            }
            else
            {
                return "3";
            }
        }

        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public class patientEditBill
    {
        public string ItemID { get; set; }
        public string StockID { get; set; }
        public string ItemName { get; set; }
        public string Quantity { get; set; }
        public string Rate { get; set; }
        public string ActualQty { get; set; }
        public string Type_ID { get; set; }
        public string LTDID { get; set; }
        public string SDID { get; set; }
    }
    [WebMethod(EnableSession = true)]
    public static string cancelPharmacyBill(string LedgertransactionNo, string TransactionID, string PatientID, string BillAmt, int type, string cancelReason)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            DataTable dt = StockReports.GetDataTable("SELECT SoldUnits,StockID FROM f_salesdetails WHERE LedgerTransactionNo='" + LedgertransactionNo + "'");
            if (dt.Rows.Count > 0)
            {
                string strStock = "";
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " update f_salesdetails SET SoldUnits=0 WHERE  LedgerTransactionNo='" + LedgertransactionNo + "' AND  StockID='" + Util.GetString(dt.Rows[i]["StockID"]) + "'");


                    float soldstock = Util.GetFloat(StockReports.ExecuteScalar("SELECT SUM(sd.SoldUnits) FROM  f_salesdetails sd WHERE sd.LedgerTransactionNo='" + LedgertransactionNo + "' AND  StockID='" + Util.GetString(dt.Rows[i]["StockID"]) + "' AND PatientID='" + PatientID + "'"));
                    float returnstock = Util.GetFloat(StockReports.ExecuteScalar("SELECT SUM(sd.SoldUnits) FROM  f_salesdetails sd WHERE sd.AgainstLedgerTnxNo='" + LedgertransactionNo + "' AND  StockID='" + Util.GetString(dt.Rows[i]["StockID"]) + "' AND PatientID='" + PatientID + "'"));
                    if (soldstock <= returnstock && soldstock != 0.00 && returnstock != 0.00)
                    {
                        tnx.Rollback();
                        tnx.Dispose();
                        con.Close();
                        con.Dispose();

                        return "2";
                    }

                    strStock = "update f_stock set ReleasedCount =ReleasedCount -" + Util.GetDecimal(dt.Rows[i]["SoldUnits"]) + " where StockID = '" + Util.GetString(dt.Rows[i]["StockID"]) + "' and ReleasedCount - " + dt.Rows[i]["SoldUnits"] + "<=InitialCount";

                    if (MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strStock) == 0)
                    {
                        tnx.Rollback();
                        tnx.Dispose();
                        con.Close();
                        con.Dispose();

                        return "2";
                    }
                }
            }
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update f_ledgertransaction lt INNER JOIN f_salesdetails sal ON lt.LedgerTransactionNo=sal.LedgerTransactionNo Set sal.IsReturn=1,lt.IsCancel = 1,lt.IsPaid = 0, lt.Adjustment=0, lt.Cancel_UserID = '" + HttpContext.Current.Session["ID"].ToString() + "',lt.CancelDate = '" + DateTime.Now.ToString("yyyy-MM-dd") + "',lt.CancelReason = '" + cancelReason + "' Where lt.LedgerTransactionNo = '" + LedgertransactionNo + "'");

            // MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_salesdetails SET IsReturn=1 WHERE LedgertransactionNo='" + LedgertransactionNo + "'  ");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_patientaccount SET Active=0 WHERE LedgertransactionNo='" + LedgertransactionNo + "' ");




            tnx.Commit();
            return "1";
        }

        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}