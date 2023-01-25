<%@ WebService Language="C#" Class="WebService" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using MySql.Data.MySqlClient;
using System.Text;
using System.Web.Script.Services;
using System.Web.Script.Serialization;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.ComponentModel;
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.ComponentModel.ToolboxItem(false)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class WebService : System.Web.Services.WebService
{
    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }
       
    [WebMethod]
    public string bindItem()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CONCAT(ItemID,'#',LowStock)ItemID,CONCAT(TypeName,' # (',NAME,')',' # ',AvailableQty)ItemName ");
        sb.Append(" FROM ( ");
        sb.Append(" SELECT im.ItemID,im.typename,sm.name,AvailableQty,IF(AvailableQty<ls.MinLevel,1,0) LowStock  ");
        sb.Append(" FROM (  ");
        sb.Append(" SELECT ItemID,(SUM(InitialCount) - SUM(ReleasedCount))AvailableQty ");
        sb.Append(" FROM f_stock  ");
        sb.Append(" WHERE (InitialCount - ReleasedCount) > 0  AND IsPost = 1 AND  DeptLedgerNo='LSHHI57'   ");
        sb.Append(" AND MedExpiryDate>CURDATE()  GROUP BY ItemID  )t1 INNER JOIN f_itemmaster im ON t1.itemid = im.ItemID   ");
        sb.Append(" INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID = im.SubCategoryID");
        sb.Append(" LEFT JOIN f_LowStock ls ON ls.itemid=im.itemid AND ls.DeptLedgerNo='LSHHI57' ");

        sb.Append(" ORDER BY im.typename ");
        sb.Append(" )t2  ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }   
    
    [WebMethod(EnableSession = true)]
    public string addItem(string ItemID, decimal tranferQty, string StockID, string MedID, string DeptLedgerNo, string AvlQty)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("Select ST.stockid,IM.TypeName ItemName,ST.ItemID,ST.BatchNumber,ST.MRP,ST.UnitPrice,");
        sb.Append("(ST.InitialCount - ST.ReleasedCount)AvlQty,IM.SubCategoryID,im.isexpirable,");
        sb.Append("date_format(ST.MedExpiryDate,'%d-%b-%Y')MedExpiryDate,ST.UnitType,im.ToBeBilled,");
        
        // Modify on 29-06-2017 - For GST
        // sb.Append("im.Type_ID,im.IsUsable,im.ServiceItemID,'" + MedID + "' MedID from f_stock ST ");
        sb.Append("im.Type_ID,im.IsUsable,im.ServiceItemID,'" + MedID + "' MedID,ST.HSNCode,ST.IGSTPercent,ST.CGSTPercent,ST.SGSTPercent,st.GSTType from f_stock ST ");
        
        sb.Append("inner join f_itemmaster IM on ST.ItemID=IM.ItemID ");
        sb.Append("where (ST.InitialCount - ST.ReleasedCount) > 0 and ST.IsPost = 1 ");
        sb.Append(" and IM.ItemID ='" + ItemID + "' ");
        sb.Append(" and st.DeptLedgerNo='" + DeptLedgerNo + "' ");
        sb.Append(" AND (IF(im.IsExpirable = 'NO','2050-01-01',st.MedExpiryDate) > CURDATE()) order by st.MedExpiryDate");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (tranferQty < Util.GetDecimal(dt.Rows[0]["AvlQty"]))
        {
            dt = dt.AsEnumerable().Where(r => r.Field<string>("StockID") == StockID).AsDataView().ToTable();
        }
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
        
    [WebMethod(EnableSession = true)]
    public string SaveCanteen(object PMH, object LT, object LTD, object SalesDetails, object generalPatient, object PaymentDetail, string patientType, string DeptLedgerNo, string contactNo, string PName)
    {
        List<Patient_Medical_History> dataPMH = new JavaScriptSerializer().ConvertToType<List<Patient_Medical_History>>(PMH);
        List<Ledger_Transaction> dataLT = new JavaScriptSerializer().ConvertToType<List<Ledger_Transaction>>(LT);
        List<LedgerTnxDetail> dataLTD = new JavaScriptSerializer().ConvertToType<List<LedgerTnxDetail>>(LTD);
        List<Sales_Details> dataSalesDetails = new JavaScriptSerializer().ConvertToType<List<Sales_Details>>(SalesDetails);
        List<Ledger_Transaction_PaymentDetail> dataPaymentDetail = new JavaScriptSerializer().ConvertToType<List<Ledger_Transaction_PaymentDetail>>(PaymentDetail);
        List<Patient_General_Master> dataGeneral = new JavaScriptSerializer().ConvertToType<List<Patient_General_Master>>(generalPatient);
        
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string TransactionId = string.Empty, ledTxnID = string.Empty, ReceiptNo = string.Empty;
            Patient_Medical_History objPmh = new Patient_Medical_History(tnx);

            objPmh.PatientID = dataPMH[0].PatientID;
            objPmh.DoctorID = Resources.Resource.DoctorID_Self; ;//dataPMH[0].DoctorID;
            objPmh.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            objPmh.Time = Util.GetDateTime(DateTime.Now);
            objPmh.DateOfVisit = Util.GetDateTime(DateTime.Now);
            objPmh.Type = "OPD";
            objPmh.PanelID = dataPMH[0].PanelID;
            objPmh.ReferedBy = dataPMH[0].ReferedBy;
            objPmh.Source = "CANTEEN";
            objPmh.patient_type = dataPMH[0].patient_type;
            objPmh.UserID = HttpContext.Current.Session["ID"].ToString();
            objPmh.HashCode = dataPMH[0].HashCode;
            objPmh.ScheduleChargeID = Util.GetInt(StockReports.GetCurrentRateScheduleID(dataPMH[0].PanelID));
            objPmh.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            objPmh.EntryDate = Util.GetDateTime(DateTime.Now);
            objPmh.IsNewPatient = 0;
            TransactionId = objPmh.Insert();
            if (TransactionId == string.Empty)
            {
                tnx.Rollback();
                tnx.Dispose();
                con.Close();
                con.Dispose();
                return "0";
            }
            string customerID = "";
            if (patientType == "2")
            {
                Patient_General_Master objPGMaster = new Patient_General_Master(tnx);
                objPGMaster.Title = dataGeneral[0].Title;
                objPGMaster.Name = dataGeneral[0].Name;
                objPGMaster.Age = dataGeneral[0].Age;
                objPGMaster.Address = dataGeneral[0].Address;
                objPGMaster.Gender = dataGeneral[0].Gender;
                objPGMaster.ContactNo = dataGeneral[0].ContactNo;
                objPGMaster.Ledgertrnxno = ledTxnID;
                objPGMaster.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                objPGMaster.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                customerID = objPGMaster.Insert();
                if (customerID == "")
                {
                    tnx.Rollback();
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();
                    return "0";
                }
            }
            Ledger_Transaction objLedTran = new Ledger_Transaction(tnx); 
            if ((patientType == "1") || (patientType == "3"))
            {
                objLedTran.LedgerNoCr = "CASH003";
                objLedTran.PatientID = dataPMH[0].PatientID;
            }
            else
            {
                objLedTran.LedgerNoCr = "CASH003";                
                objLedTran.PatientID = "CASH003";
            }
            objLedTran.LedgerNoDr = "STO00002";
            objLedTran.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            objLedTran.TransactionID = TransactionId;
            objLedTran.TypeOfTnx = "Canteen-Issue";
            objLedTran.PanelID = dataLT[0].PanelID;

            objLedTran.Date = Util.GetDateTime(DateTime.Now.ToShortDateString());
            objLedTran.Time = Util.GetDateTime(DateTime.Now.ToShortTimeString());
            objLedTran.NetAmount = dataLT[0].NetAmount;
            objLedTran.GrossAmount = dataLT[0].GrossAmount;
            objLedTran.DiscountOnTotal = dataLT[0].DiscountOnTotal;
            objLedTran.DiscountReason = dataLT[0].DiscountReason.Trim();
            objLedTran.DiscountApproveBy = dataLT[0].DiscountApproveBy.Trim();

            objLedTran.IndentNo = "";
            objLedTran.Adjustment = dataLT[0].Adjustment;
            if (dataPaymentDetail[0].PaymentMode.ToString() != "Credit" && (dataLT[0].Adjustment > 0))
                objLedTran.IsPaid = 1;
            else
                objLedTran.IsPaid = 0;

            objLedTran.IsCancel = Util.GetInt(0);
            objLedTran.RoundOff = Util.GetDecimal(dataLT[0].RoundOff);
            objLedTran.PaymentModeID = Util.GetInt(dataPaymentDetail[0].PaymentModeID);
            objLedTran.TransactionType_ID = 16;
            objLedTran.DeptLedgerNo = DeptLedgerNo;
            objLedTran.UserID = HttpContext.Current.Session["ID"].ToString();
            objLedTran.UniqueHash = dataPMH[0].HashCode;
            objLedTran.Remarks = dataLT[0].Remarks;
            objLedTran.BillDate = Util.GetDateTime(DateTime.Now);
            objLedTran.GovTaxPer = 0;
            objLedTran.IpAddress = HttpContext.Current.Request.UserHostAddress;
            objLedTran.PatientType = dataPMH[0].patient_type;
            if (patientType == "3")
                objLedTran.IPNo = dataLT[0].IPNo;
            string creditBillNO = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select Get_Canteen_BillNo('"+ HttpContext.Current.Session["CentreID"].ToString() + "')"));
            if (creditBillNO == string.Empty)
            {
                tnx.Rollback();
                tnx.Dispose();
                con.Close();
                con.Dispose();
                return "0";
            }

            objLedTran.BillNo = creditBillNO;
            objLedTran.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            objLedTran.CurrentAge = dataLT[0].CurrentAge;
            ledTxnID = objLedTran.Insert();

            if (ledTxnID == string.Empty)
            {
                tnx.Rollback();
                tnx.Dispose();
                con.Close();
                con.Dispose();
                return "0";
            }
            if (customerID != "")
                MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "UPDATE patient_general_master SET AgainstLedgerTnxNo='" + ledTxnID + "' where CustomerID='" + customerID + "' ");
            int SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select Get_SalesNo('16','" + AllGlobalFunction.GeneralStoreID + "','" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + "') "));

            // Add new on 29-06-2017 - For GST
            decimal igstTaxPercent = 0, cgstTaxPercent = 0, sgstTaxPercent = 0;
            decimal igstTaxAmt = 0, cgstTaxAmt = 0, sgstTaxAmt = 0;
            //

            for (int i = 0; i < dataLTD.Count; i++)
            {
                LedgerTnxDetail objLTDetail = new LedgerTnxDetail(tnx);
                objLTDetail.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
                objLTDetail.LedgerTransactionNo = ledTxnID;
                objLTDetail.ItemID = Util.GetString(dataLTD[i].ItemID);
                objLTDetail.StockID = Util.GetString(dataLTD[i].StockID);
                objLTDetail.SubCategoryID = Util.GetString(dataLTD[i].SubCategoryID);
                objLTDetail.TransactionID = TransactionId;
                objLTDetail.Rate = Util.GetDecimal(dataLTD[i].Rate);
                objLTDetail.Quantity = Util.GetDecimal(dataLTD[i].Quantity);
                objLTDetail.IsVerified = 1;
                objLTDetail.ItemName = Util.GetString(dataLTD[i].ItemName);
                objLTDetail.EntryDate = DateTime.Now;

                objLTDetail.DiscAmt = Util.GetDecimal(dataLTD[i].DiscAmt);
                objLTDetail.DiscountPercentage = Util.GetDecimal(dataLTD[i].DiscountPercentage);
                objLTDetail.DiscountReason = Util.GetString(dataLTD[i].DiscountReason);
                objLTDetail.DoctorID = Resources.Resource.DoctorID_Self; ;//dataPMH[0].DoctorID;
                objLTDetail.Amount = Util.GetDecimal(dataLTD[i].Amount);
                objLTDetail.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(dataLTD[i].SubCategoryID), con));

                objLTDetail.UserID = HttpContext.Current.Session["ID"].ToString();
                objLTDetail.TnxTypeID = Util.GetInt("16");
                objLTDetail.ToBeBilled = Util.GetInt(dataLTD[i].ToBeBilled);
                objLTDetail.IsReusable = Util.GetString(dataLTD[i].IsReusable);
                objLTDetail.NetItemAmt = objLTDetail.Amount;
                objLTDetail.TotalDiscAmt = Util.GetDecimal(objLTDetail.DiscAmt);
                objLTDetail.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                objLTDetail.pageURL = All_LoadData.getCurrentPageName();
                objLTDetail.medExpiryDate = Util.GetDateTime(dataLTD[i].medExpiryDate);
                objLTDetail.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                objLTDetail.IpAddress = HttpContext.Current.Request.UserHostAddress;
                objLTDetail.Type = "O";
                if (Util.GetDateTime(dataLTD[i].medExpiryDate) != Util.GetDateTime("01-Jan-01"))
                    objLTDetail.IsExpirable = 1;
                else
                    objLTDetail.IsExpirable = 0;
                objLTDetail.TransactionType_ID = 16;

                // Add new on 29-06-2017 - For GST
                igstTaxPercent = Util.GetDecimal(dataLTD[i].IGSTPercent);
                cgstTaxPercent = Util.GetDecimal(dataLTD[i].CGSTPercent);
                sgstTaxPercent = Util.GetDecimal(dataLTD[i].SGSTPercent);

                All_LoadData.CalculateGSTTax(objLTDetail.Rate, objLTDetail.Quantity, objLTDetail.DiscountPercentage, objLTDetail.DiscAmt, igstTaxPercent, cgstTaxPercent, sgstTaxPercent, out igstTaxAmt, out cgstTaxAmt, out sgstTaxAmt);

                objLTDetail.HSNCode = Util.GetString(dataLTD[i].HSNCode);
                objLTDetail.IGSTPercent = igstTaxPercent;
                objLTDetail.CGSTPercent = cgstTaxPercent;
                objLTDetail.SGSTPercent = sgstTaxPercent;
                objLTDetail.IGSTAmt = igstTaxAmt;
                objLTDetail.CGSTAmt = cgstTaxAmt;
                objLTDetail.SGSTAmt = sgstTaxAmt;
                objLTDetail.GSTType = Util.GetString(dataLTD[i].GSTType);
                //
                
                int LedgerTnxNo = objLTDetail.Insert();


                if (LedgerTnxNo == 0)
                {
                    tnx.Rollback();
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();
                    return "0";
                }
                               
                Sales_Details objSales = new Sales_Details(tnx);
                objSales.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                if ((patientType == "1") || (patientType == "3"))
                    objSales.LedgerNumber = "CASH003";
                else
                    objSales.LedgerNumber = "CASH003";

                objSales.DepartmentID = "STO00002";
                objSales.StockID = Util.GetString(dataSalesDetails[i].StockID);
                objSales.SoldUnits = Util.GetDecimal(dataSalesDetails[i].SoldUnits);
                objSales.PerUnitBuyPrice = Util.GetDecimal(dataSalesDetails[i].PerUnitBuyPrice);
                objSales.PerUnitSellingPrice = Util.GetDecimal(dataSalesDetails[i].PerUnitSellingPrice);
                objSales.Date = System.DateTime.Now;
                objSales.Time = System.DateTime.Now;
                objSales.IsReturn = 0;
                objSales.TrasactionTypeID = 16;
                objSales.ItemID = Util.GetString(dataSalesDetails[i].ItemID);
                objSales.IsService = "NO";
                objSales.IndentNo = "";
                objSales.Naration = "";
                objSales.SalesNo = SalesNo;
                objSales.UserID = HttpContext.Current.Session["ID"].ToString();
                objSales.DeptLedgerNo = DeptLedgerNo;
                if ((patientType == "1") || (patientType == "3"))
                    objSales.PatientID = dataPMH[0].PatientID;
                else
                    objSales.PatientID = customerID;

                objSales.LedgerTransactionNo = ledTxnID;
                objSales.BillNoforGP = creditBillNO;
                objSales.ToBeBilled = Util.GetInt(dataSalesDetails[i].ToBeBilled);
                objSales.IsReusable = Util.GetString(dataSalesDetails[i].IsReusable);
                objSales.Type_ID = dataSalesDetails[i].Type_ID;
                objSales.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                objSales.IpAddress = HttpContext.Current.Request.UserHostAddress;
                objSales.medExpiryDate = Util.GetDateTime(dataLTD[i].medExpiryDate);
                objSales.LedgerTnxNo = LedgerTnxNo;

                // Add new 29-06-2017 - For GST                
                objSales.IGSTPercent = igstTaxPercent;
                objSales.CGSTPercent = cgstTaxPercent;
                objSales.SGSTPercent = sgstTaxPercent;
                objSales.IGSTAmt = igstTaxAmt;
                objSales.CGSTAmt = cgstTaxAmt;
                objSales.SGSTAmt = sgstTaxAmt;
                //     
                
                string salesID = objSales.Insert();
                if (salesID == "")
                {
                    tnx.Rollback();
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();
                    return "0";
                }

                string strStock = "";

                if (dataSalesDetails[i].IsReusable.ToString() == "0" || dataSalesDetails[i].IsReusable.ToString() == "NR")
                {
                    strStock = "update f_stock set ReleasedCount = ReleasedCount +" + objSales.SoldUnits + " where StockID = '" + objSales.StockID + "' and ReleasedCount + " + objSales.SoldUnits + "<=InitialCount";

                    if (MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strStock) == 0)
                    {
                        decimal avStock = Util.GetDecimal(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT (InitialCount-ReleasedCount)avStock FROM  f_stock WHERE StockID = '" + objSales.StockID + "'"));
                        tnx.Rollback();
                        tnx.Dispose();
                        con.Close();
                        con.Dispose();
                        return string.Concat(Util.GetInt(i + 1), "$", avStock).ToString();
                    }
                }
            }
            
           
            
            if ((dataPaymentDetail[0].PaymentMode.ToString() != "Credit") && (dataLT[0].Adjustment > 0))
            {
                Receipt ObjReceipt = new Receipt(tnx);
                ObjReceipt.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                ObjReceipt.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                ObjReceipt.AmountPaid = dataLT[0].Adjustment;
                ObjReceipt.AsainstLedgerTnxNo = ledTxnID.Trim();
                ObjReceipt.Date = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                ObjReceipt.Time = Util.GetDateTime(DateTime.Now.ToString("HH:mm:ss"));
                if ((patientType == "1") || (patientType == "3"))
                {
                    ObjReceipt.Depositor = dataPMH[0].PatientID;
                    ObjReceipt.LedgerNoCr = "CASH003";
                }
                else
                {
                    ObjReceipt.Depositor = "CASH003";
                    ObjReceipt.LedgerNoCr = "CASH003";
                }
                ObjReceipt.Discount = 0;
                ObjReceipt.PanelID = dataPMH[0].PanelID;
                ObjReceipt.Reciever = HttpContext.Current.Session["ID"].ToString();
                ObjReceipt.TransactionID = TransactionId;
                ObjReceipt.RoundOff = dataLT[0].RoundOff;
                ObjReceipt.LedgerNoDr = "STO00002";
                ObjReceipt.PaidBy = "PAT";
                ObjReceipt.deptLedgerNo = DeptLedgerNo;
                ObjReceipt.IpAddress = All_LoadData.IpAddress();

                ReceiptNo = ObjReceipt.Insert();

                Receipt_PaymentDetail ObjReceiptPayment = new Receipt_PaymentDetail(tnx);
                for (int i = 0; i < dataPaymentDetail.Count; i++)
                {
                    ObjReceiptPayment.PaymentModeID = Util.GetInt(dataPaymentDetail[i].PaymentModeID);
                    ObjReceiptPayment.PaymentMode = Util.GetString(dataPaymentDetail[i].PaymentMode);
                    ObjReceiptPayment.Amount = Util.GetDecimal(dataPaymentDetail[i].Amount);
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
                    ObjReceiptPayment.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                    ObjReceiptPayment.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    string PaymentID = ObjReceiptPayment.Insert().ToString();
                }
                if (ReceiptNo == "")
                {
                    tnx.Rollback();
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();
                    return "0";
                }
            }
            tnx.Commit();            
            return ledTxnID + "#" + customerID + "#" + DeptLedgerNo;
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

    [WebMethod]
    public string BindMedicineDetail(string ItemID, string DeptLedgerNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT ST.stockid,ST.ItemID,DATE_FORMAT(st.MedExpiryDate,'%d-%b-%y')Expiry,ST.BatchNumber, ");
        sb.Append(" ST.MRP,round((ST.MRP*IM.ConversionFactor),2)MajorMRP,ST.UnitPrice,IM.ConversionFactor, ");
        sb.Append("(ST.InitialCount - ST.ReleasedCount)AvlQty ");
        sb.Append("  ");
        sb.Append("  FROM f_stock ST ");
        sb.Append(" INNER JOIN f_itemmaster IM ON ST.ItemID=IM.ItemID ");
        sb.Append(" WHERE (ST.InitialCount - ST.ReleasedCount) > 0 AND ST.IsPost = 1  ");
        sb.Append("  AND IM.ItemID ='" + ItemID + "'  AND st.DeptLedgerNo='" + DeptLedgerNo + "'  ");
        sb.Append(" AND (IF(im.IsExpirable = 'NO','2050-01-01',st.MedExpiryDate) > CURDATE()) ORDER BY st.MedExpiryDate ");
        DataTable oDT = StockReports.GetDataTable(sb.ToString());
        if (oDT.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(oDT);
        else
            return "";
    }    

    [WebMethod(EnableSession = true, Description = "Get Tax Amount")]
    public string GetTaxAmount(object Data)
    {
        return AllLoadData_Store.taxCalulation(Data);
    }
}
