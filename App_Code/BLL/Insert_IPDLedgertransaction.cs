using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using MySql.Data.MySqlClient;
using System.Data;
using System.Linq;

/// <summary>
/// Summary description for Insert_IPDLedgertransaction
/// </summary>
public class Insert_IPDLedgertransaction
{
    public Insert_IPDLedgertransaction()
    {
        //
        // TODO: Add constructor logic here
        //
    }
    public static string SaveLedgertransaction(object LT, object LTD, object PLI, string PatientTypeID, string MembershipNo, MySqlTransaction tnx, MySqlConnection con)
    {
        try
        {

            List<Ledger_Transaction> dataLT = new JavaScriptSerializer().ConvertToType<List<Ledger_Transaction>>(LT);
            List<LedgerTnxDetail> dataLTD = new JavaScriptSerializer().ConvertToType<List<LedgerTnxDetail>>(LTD);
            List<Patient_Lab_InvestigationOPD> dataPLI = new List<Patient_Lab_InvestigationOPD>();
            if (PLI != "")
            {
                dataPLI = new JavaScriptSerializer().ConvertToType<List<Patient_Lab_InvestigationOPD>>(PLI);

            }
            string PatientLedgerNo = AllQuery.GetLedgerNoByLedgerUserID(dataLT[0].PatientID, con);
            int LedTxnID = 0; string LedgerTransactionNo = string.Empty;
            int sampleCollectCount = 0;
            string BarcodeNo = string.Empty;
            Ledger_Transaction objLedTran = new Ledger_Transaction(tnx);
            objLedTran.LedgerNoCr = PatientLedgerNo;
            objLedTran.LedgerNoDr = "HOSP0001";
            objLedTran.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            objLedTran.TypeOfTnx = dataLT[0].TypeOfTnx;
            objLedTran.Date = Util.GetDateTime(dataLTD[0].EntryDate.ToString("yyyy-MM-dd"));
            objLedTran.Time = Util.GetDateTime(DateTime.Now.ToString("HH:mm:ss"));
            objLedTran.GrossAmount = dataLT[0].GrossAmount;
            objLedTran.NetAmount = dataLT[0].NetAmount;
            objLedTran.DiscountOnTotal = dataLT[0].DiscountOnTotal;
            objLedTran.RoundOff = dataLT[0].RoundOff;
            objLedTran.UserID = Util.GetString(HttpContext.Current.Session["ID"].ToString());
            objLedTran.PatientID = dataLT[0].PatientID;
            objLedTran.TransactionID = dataLT[0].TransactionID;
            objLedTran.PanelID = dataLT[0].PanelID;
            objLedTran.UniqueHash = dataLT[0].UniqueHash;
            objLedTran.IpAddress = All_LoadData.IpAddress();
            objLedTran.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            objLedTran.PatientType = dataLT[0].PatientType;
            objLedTran.DiscountApproveBy = dataLT[0].DiscountApproveBy;
            objLedTran.DiscountReason = dataLT[0].DiscountReason;
            LedgerTransactionNo = objLedTran.Insert().ToString();
            if (LedgerTransactionNo != "")
            {
                string PatientType = StockReports.GetPatient_Type_IPD(dataLT[0].TransactionID);
                //Checking if Patient is prescribed any IPD Packages
                DataTable dtPkg = StockReports.GetIPD_Packages_Prescribed(dataLT[0].TransactionID, con);
                int Is_OldItems_Shifted_To_Pkg = 0;
                // Add new on 14-07-2017 - For GST
                for (int i = 0; i < dataLTD.Count; i++)
                {
                    LedgerTnxDetail objLTDetail = new LedgerTnxDetail(tnx);
                    objLTDetail.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
                    objLTDetail.LedgerTransactionNo = LedgerTransactionNo;
                    objLTDetail.ItemID = Util.GetString(dataLTD[i].ItemID);
                    objLTDetail.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(dataLTD[i].SubCategoryID), con));
                    objLTDetail.Rate = Util.GetDecimal(dataLTD[i].Rate);
                    objLTDetail.Quantity = Util.GetDecimal(dataLTD[i].Quantity);
                    decimal DiscPerc = dataLTD[i].DiscountPercentage;
                    decimal GrossAmt = Util.GetDecimal(dataLTD[i].Rate) * Util.GetDecimal(dataLTD[i].Quantity);
                    string discountReason = Util.GetString(objLedTran.DiscountReason);


                    if (dataLTD[i].IsPayable == 1)
                        objLTDetail.IsPayable = Util.GetInt(dataLTD[i].IsPayable);
                    else
                        objLTDetail.IsPayable = StockReports.GetIsPayableItems(objLTDetail.ItemID, objLedTran.PanelID);

                    if (dtPkg != null && dtPkg.Rows.Count > 0)
                    {
                        int iCtr = 0;
                        foreach (DataRow drPkg in dtPkg.Rows)
                        {
                            if (iCtr == 0)
                            {
                                DataTable dtPkgDetl = StockReports.ShouldSendToIPDPackage(dataLT[0].TransactionID.ToString(), drPkg["PackageID"].ToString(), dataLTD[i].ItemID, (Util.GetDecimal(dataLTD[i].Rate) * Util.GetDecimal(dataLTD[i].Quantity)), Util.GetDecimal(dataLTD[i].Quantity),Util.GetInt(dataLTD[i].IPDCaseTypeID), con);

                                if (dtPkgDetl != null && Util.GetString(dtPkgDetl.Rows[0]["iStatus"]) != "")
                                {
                                    if (Util.GetBoolean(dtPkgDetl.Rows[0]["iStatus"]))
                                    {

                                        decimal NetAmount = GrossAmt - ((GrossAmt * DiscPerc) / 100);
                                        objLTDetail.DiscountPercentage = DiscPerc;
                                        objLTDetail.DiscAmt = GrossAmt - NetAmount;
                                        objLTDetail.TotalDiscAmt = (GrossAmt * DiscPerc) / 100;
                                        objLTDetail.DiscountReason = discountReason;//"Panel Wise Discount";

                                        objLTDetail.IsPackage = 1;
                                        objLTDetail.PackageID = Util.GetString(drPkg["PackageID"]);
                                        objLTDetail.NetItemAmt = 0;
                                        objLTDetail.Amount = 0;

                                        iCtr = 1;
                                    }
                                    else
                                    {
                                        if (DiscPerc > 0)
                                        {

                                            decimal NetAmount = GrossAmt - ((GrossAmt * DiscPerc) / 100);
                                            objLTDetail.DiscountPercentage = DiscPerc;
                                            objLTDetail.DiscAmt = GrossAmt - NetAmount;
                                            objLTDetail.TotalDiscAmt = (GrossAmt * DiscPerc) / 100;
                                            objLTDetail.DiscountReason = discountReason;//"Panel Wise Discount";

                                            objLTDetail.Amount = NetAmount;
                                            objLTDetail.NetItemAmt = NetAmount;

                                            objLTDetail.DiscUserID = HttpContext.Current.Session["ID"].ToString();
                                            if (Util.GetInt(dataLT[0].PanelID) != 1)
                                                objLTDetail.isPanelWiseDisc = 1;
                                        }
                                        else
                                        {
                                            decimal NetAmount = GrossAmt - ((GrossAmt * DiscPerc) / 100);
                                            objLTDetail.DiscountPercentage = DiscPerc;
                                            objLTDetail.DiscAmt = GrossAmt - NetAmount;
                                            objLTDetail.TotalDiscAmt = (GrossAmt * DiscPerc) / 100;
                                            objLTDetail.DiscountReason = discountReason;// "Panel Wise Discount";


                                            objLTDetail.Amount = Util.GetDecimal(dataLTD[i].Rate) * Util.GetDecimal(dataLTD[i].Quantity);
                                            objLTDetail.NetItemAmt = Util.GetDecimal(dataLTD[i].Rate) * Util.GetDecimal(dataLTD[i].Quantity);
                                        }
                                    }
                                }
                                else
                                {
                                    //Check to see if already added items should be shifted to this item if it is a ipd-package
                                    if (Util.GetString(dataLTD[i].ConfigID) == "14")//ipd-package
                                    {
                                        if (Is_OldItems_Shifted_To_Pkg == 0)
                                        {
                                            if (Util.GetBoolean(StockReports.SentToIPDPackage(dataLT[0].TransactionID, Util.GetString(dataLTD[i].ItemID), Util.GetDateTime(dataLTD[i].EntryDate),Util.GetInt((Util.GetDateTime(dataLTD[i].EntryDate) - Util.GetDateTime(dataLTD[i].EntryDate)).Days), con)))
                                                Is_OldItems_Shifted_To_Pkg = 1;
                                        }
                                    }
                                    if (DiscPerc > 0)
                                    {
                                        // decimal GrossAmt = Util.GetDecimal(dataLTD[i].Rate) * Util.GetDecimal(dataLTD[i].Quantity);
                                        decimal NetAmount = GrossAmt - ((GrossAmt * DiscPerc) / 100);

                                        objLTDetail.Amount = NetAmount;
                                        objLTDetail.DiscountPercentage = DiscPerc;
                                        objLTDetail.DiscAmt = GrossAmt - NetAmount;
                                        objLTDetail.TotalDiscAmt = (GrossAmt * DiscPerc) / 100;
                                        objLTDetail.DiscountReason = discountReason;//"Panel Wise Discount";

                                        objLTDetail.NetItemAmt = NetAmount;
                                        objLTDetail.DiscUserID = HttpContext.Current.Session["ID"].ToString();
                                        if (Util.GetInt(dataLT[0].PanelID) != 1)
                                            objLTDetail.isPanelWiseDisc = 1;

                                    }
                                    else
                                    {
                                        decimal NetAmount = GrossAmt - ((GrossAmt * DiscPerc) / 100);
                                        objLTDetail.DiscountPercentage = DiscPerc;
                                        objLTDetail.DiscAmt = GrossAmt - NetAmount;
                                        objLTDetail.TotalDiscAmt = (GrossAmt * DiscPerc) / 100;
                                        objLTDetail.DiscountReason = discountReason;// "Panel Wise Discount";


                                        objLTDetail.Amount = Util.GetDecimal(dataLTD[i].Rate) * Util.GetDecimal(dataLTD[i].Quantity);
                                        objLTDetail.NetItemAmt = Util.GetDecimal(dataLTD[i].Rate) * Util.GetDecimal(dataLTD[i].Quantity);

                                    }
                                }
                            }
                        }
                    }
                    else
                    {
                        //Check to see if already added items should be shifted to this item if it is a ipd-package
                        //if (Items.Columns.Contains("ConfigID") == false) Items.Columns.Add("ConfigID");
                        // Items.Rows[j]["ConfigID"] = objLTDetail.ConfigID;


                        if (Util.GetString(dataLTD[i].ConfigID) == "14")//ipd-package
                        {
                            if (Is_OldItems_Shifted_To_Pkg == 0)
                            {
                                string str = "Select ItemID from packagemasteripd_details where ItemID='" + Util.GetString(dataLTD[i].ItemID) + "' and IsActive=1";
                                string PackageID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, str));

                                if (PackageID != "")
                                {
                                    if (Util.GetBoolean(StockReports.SentToIPDPackage(dataLT[0].TransactionID, Util.GetString(dataLTD[i].ItemID), Util.GetDateTime(dataLTD[i].EntryDate),Util.GetInt((Util.GetDateTime(dataLTD[i].EntryDate) - Util.GetDateTime(dataLTD[i].EntryDate)).Days), con)))
                                        Is_OldItems_Shifted_To_Pkg = 1;
                                }
                            }
                        }
                        if (DiscPerc > 0)
                        {
                            //decimal GrossAmt = Util.GetDecimal(dataLTD[i].Rate) * Util.GetDecimal(dataLTD[i].Quantity);
                            decimal NetAmount = GrossAmt - ((GrossAmt * DiscPerc) / 100);

                            objLTDetail.Amount = NetAmount;
                            objLTDetail.DiscountPercentage = DiscPerc;
                            objLTDetail.DiscAmt = GrossAmt - NetAmount;
                            objLTDetail.TotalDiscAmt = (GrossAmt * DiscPerc) / 100;
                            objLTDetail.DiscountReason = discountReason;// "Panel Wise Discount";

                            objLTDetail.NetItemAmt = NetAmount;
                            objLTDetail.DiscUserID = HttpContext.Current.Session["ID"].ToString();
                            if (Util.GetInt(dataLT[0].PanelID) != 1)
                                objLTDetail.isPanelWiseDisc = 1;
                        }
                        else
                        {
                            objLTDetail.DiscountPercentage = 0;
                            objLTDetail.DiscAmt = 0;
                            objLTDetail.Amount = Util.GetDecimal(dataLTD[i].Rate) * Util.GetDecimal(dataLTD[i].Quantity);
                            objLTDetail.TotalDiscAmt = 0;
                            objLTDetail.NetItemAmt = Util.GetDecimal(dataLTD[i].Rate) * Util.GetDecimal(dataLTD[i].Quantity);
                        }
                    }
                    objLTDetail.IsPayable = Util.GetInt(dataLTD[i].IsPayable);
                    objLTDetail.CoPayPercent = Util.GetDecimal(dataLTD[i].CoPayPercent);
                    objLTDetail.EntryDate = Util.GetDateTime(dataLTD[i].EntryDate.ToString("yyyy-MM-dd") + " " + DateTime.Now.ToString("HH:mm:ss"));
                    objLTDetail.TransactionID = dataLT[0].TransactionID;
                    objLTDetail.UserID = HttpContext.Current.Session["ID"].ToString();
                    objLTDetail.IsVerified = 1;
                    objLTDetail.ItemName = Util.GetString(dataLTD[i].ItemName);
                    objLTDetail.SubCategoryID = Util.GetString(dataLTD[i].SubCategoryID);
                    objLTDetail.DoctorID = dataLTD[i].DoctorID;
                    objLTDetail.IPDCaseTypeID = dataLTD[i].IPDCaseTypeID;
                    objLTDetail.RateListID = Util.GetInt(dataLTD[i].RateListID);
                    objLTDetail.pageURL = All_LoadData.getCurrentPageName();
                    objLTDetail.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    objLTDetail.Type = "I";
                    objLTDetail.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                    objLTDetail.IpAddress = All_LoadData.IpAddress();
                    objLTDetail.MACAddress = All_LoadData.macAddress();
                    objLTDetail.rateItemCode = Util.GetString(dataLTD[i].rateItemCode);
                    objLTDetail.VarifiedUserID = HttpContext.Current.Session["ID"].ToString();
                    objLTDetail.VerifiedDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                    objLTDetail.RoomID = dataLTD[i].RoomID;
                    objLTDetail.typeOfTnx = dataLTD[i].typeOfTnx;

                    decimal igstPercent = Util.GetDecimal(dataLTD[i].IGSTPercent);
                    decimal csgtPercent = Util.GetDecimal(dataLTD[i].CGSTPercent);
                    decimal sgstPercent = Util.GetDecimal(dataLTD[i].SGSTPercent);

                    decimal nonTaxableRate = (objLTDetail.Rate * 100) / (100 + igstPercent + csgtPercent + sgstPercent);
                    decimal discount = objLTDetail.Rate * objLTDetail.DiscountPercentage / 100;
                    decimal taxableAmt = ((objLTDetail.Rate - discount) * 100 * objLTDetail.Quantity) / (100 + igstPercent + csgtPercent + sgstPercent);

                    decimal IGSTTaxAmount = Math.Round(taxableAmt * igstPercent / 100, 4, MidpointRounding.AwayFromZero);
                    decimal CGSTTaxAmount = Math.Round(taxableAmt * csgtPercent / 100, 4, MidpointRounding.AwayFromZero);
                    decimal SGSTTaxAmount = Math.Round(taxableAmt * sgstPercent / 100, 4, MidpointRounding.AwayFromZero);
                    objLTDetail.HSNCode = Util.GetString(dataLTD[i].HSNCode);
                    objLTDetail.IGSTPercent = igstPercent;
                    objLTDetail.IGSTAmt = IGSTTaxAmount;
                    objLTDetail.CGSTPercent = csgtPercent;
                    objLTDetail.CGSTAmt = CGSTTaxAmount;
                    objLTDetail.SGSTPercent = sgstPercent;
                    objLTDetail.SGSTAmt = SGSTTaxAmount;
                    objLTDetail.roundOff = Util.GetDecimal(objLedTran.RoundOff / dataLTD.Count);
                    objLTDetail.GSTType = Util.GetString(dataLTD[i].GSTType);
                    LedTxnID = objLTDetail.Insert();
                    if (dataPLI.Count > 0)
                    {
                        if (LedTxnID != 0)
                        {
                            Patient_Lab_InvestigationOPD objPLI = new Patient_Lab_InvestigationOPD(tnx);
                            objPLI.Investigation_ID = Util.GetString(dataPLI[i].Investigation_ID);
                            objPLI.Date = Util.GetDateTime(dataLTD[i].EntryDate.ToString("yyyy-MM-dd"));
                            objPLI.Time = Util.GetDateTime(DateTime.Now.ToString("HH:mm:ss"));
                            objPLI.TransactionID = dataLT[0].TransactionID;
                            objPLI.IsSampleCollected = dataPLI[i].IsSampleCollected;
                            if (BarcodeNo == "")
                                BarcodeNo = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select get_barcode(" + Util.GetInt(HttpContext.Current.Session["CentreID"]) + ")").ToString();
                            objPLI.BarcodeNo = BarcodeNo;
                            if (BarcodeNo == "0")
                                objPLI.PrePrintedBarcode = 1;
                            if (dataPLI[i].IsSampleCollected.ToUpper() == "N")
                            {
                                objPLI.IsSampleCollected = "N";
                                sampleCollectCount += 1;
                            }
                            else
                            {
                                objPLI.IsSampleCollected = "S";
                                objPLI.SampleDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                                objPLI.sampleCollectCentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                                objPLI.SampleCollectionBy = HttpContext.Current.Session["ID"].ToString();
                                objPLI.SampleCollectionDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                                objPLI.SampleCollector = HttpContext.Current.Session["LoginName"].ToString();
                                //objPLI.SampleReceiveDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                                //objPLI.SampleReceivedBy = HttpContext.Current.Session["ID"].ToString();
                                //objPLI.SampleReceiver = HttpContext.Current.Session["LoginName"].ToString();
                            }
                            string[] stringList = Resources.Resource.HistoCytoSubcategoryID.Split(",".ToCharArray(), StringSplitOptions.RemoveEmptyEntries);
                            if (stringList.Contains(dataLTD[i].SubCategoryID))
                            {
                                objPLI.HistoCytoSampleDetail = 1;
                            }
                            objPLI.Special_Flag = 0;
                            //objPLI.Round_No = 0;
                            objPLI.Result_Flag = 0;
                            objPLI.LedgerTransactionNo = LedgerTransactionNo;
                            objPLI.LedgerTnxID = Util.GetInt(LedTxnID);
                            objPLI.PatientID = dataLT[0].PatientID;
                            objPLI.Remarks = dataPLI[i].Remarks;
                            objPLI.DoctorID = dataLTD[i].DoctorID;
                            objPLI.IsUrgent = Util.GetInt(dataPLI[i].IsUrgent);
                            objPLI.IsPortable = Util.GetInt(dataPLI[i].IsPortable);
                            objPLI.CurrentAge = Util.GetString(dataPLI[i].CurrentAge);
                            if (Util.GetInt(dataPLI[i].IsOutSource) == 1)
                            {
                                objPLI.IsOutSource = Util.GetInt(dataPLI[i].IsOutSource);
                                objPLI.OutSourceBy = HttpContext.Current.Session["ID"].ToString();
                                objPLI.OutsourceDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                                objPLI.OutSourceLabID = dataPLI[i].OutSourceLabID;
                            }
                            else
                                objPLI.OutSourceLabID = 0;
                            objPLI.ReportDispatchModeID = 4;
                            objPLI.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                            objPLI.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                            //NewParamerter
                            objPLI.Type = 2;
                            objPLI.BookingCentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                            objPLI.IPDCaseTypeID = dataLTD[i].IPDCaseTypeID;
                            objPLI.RoomID = dataLTD[i].RoomID;
                            DateTime ScRequestdatetime = Util.GetDateTime(Util.GetDateTime(dataPLI[i].SCRequestdatetime).ToString("yyyy-MM-dd HH:mm:ss"));
                           // if (Util.GetString(ScRequestdatetime) == "01-01-0001 00:00:00")
                            if (Util.GetString(ScRequestdatetime) == "1/1/0001 12:00:00 AM")
                                objPLI.SCRequestdatetime = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                            else
                                objPLI.SCRequestdatetime = Util.GetDateTime(Util.GetDateTime(dataPLI[i].SCRequestdatetime).ToString("yyyy-MM-dd HH:mm:ss"));

                            //End
                            objPLI.Insert();
                        }
                        else
                            return "";
                    }
                    if (sampleCollectCount > 0)
                    {
                        string notification = Notification_Insert.notificationInsert(15, Util.GetString(LedTxnID), tnx, "", Util.GetString(dataLTD[i].IPDCaseTypeID), 0, "");
                        if (notification == "")
                        {
                            return "";
                        }
                    }
                }


                //Devendra Singh 2018-10-10 Insert Finance Integarion 
                if (Resources.Resource.AllowFiananceIntegration == "1")
                {
                    string IsIntegrated = Util.GetString(EbizFrame.InsertIPDTransaction(Util.GetInt(LedgerTransactionNo), "", "R", tnx));
                    if (IsIntegrated == "0")
                    {
                        tnx.Rollback();
                        return "";
                    }
                }
            }



            if (LedgerTransactionNo != "" || LedTxnID != 0)
                return LedgerTransactionNo + "#" + LedTxnID + "#" + BarcodeNo;
            else
                return "";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
    }
}