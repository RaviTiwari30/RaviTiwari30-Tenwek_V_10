<%@ WebService Language="C#" Class="CreatePO" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Text;
using System.Data;
using MySql.Data.MySqlClient;
using System.Collections.Generic;
using System.Linq;
using System.Web.Script.Serialization;


[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class CreatePO : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }


    [WebMethod(EnableSession = true)]
    public string GetItems(string centreID, string departmentLedgerNo, string vendorId, string storeType, int purchaseOrderType)
    {
        ExcuteCMD excuteCMD = new ExcuteCMD();
        StringBuilder sqlCmd = new StringBuilder("SELECT im.ManufactureID,im.ManuFacturer,im.HSNCode,im.VatType, im.SubCategoryID,im.TypeName `ItemName`,imdpt.MinLevel,imdpt.MaxLevel,im.ItemID,IFNULL(im.MajorUnit,'')MajorUnit,");
        sqlCmd.Append(" IFNULL((SELECT SUM(f.InitialCount)-SUM(f.ReleasedCount)  FROM f_stock  f  WHERE  f.`IsPost`=1 AND f.`MedExpiryDate`>CURDATE() AND  f.CentreID=@centreID  AND f.ItemID=im.ItemID),0) Stock,im.ConversionFactor ");
        sqlCmd.Append(" FROM f_itemmaster im INNER JOIN `f_itemmaster_centerwise` itc ON itc.`ItemID`=im.`ItemID` INNER JOIN  `f_subcategorymaster` sb ON im.`SubCategoryID`=sb.`SubCategoryID` ");

        sqlCmd.Append("   AND sb.`CategoryID`='" + storeType + "' ");

        if (vendorId != "0")
            sqlCmd.Append(" INNER JOIN f_storeitem_rate r ON r.`ItemID`=im.ItemID AND r.`Vendor_ID`=@vendorID AND r.`IsActive`=1 AND r.CentreID=@centreID AND r.`DeptLedgerNo`=@departmentLedgerNO ");

        sqlCmd.Append(" left JOIN f_itemmaster_deptwise imdpt ");
        sqlCmd.Append(" ON im.ItemID = imdpt.ItemID  And imdpt.CentreID=@centerID  AND imdpt.DeptLedgerNo =@departmentLedgerNO WHERE im.IsActive = 1 AND itc.`IsActive`=1 AND itc.`CentreID`= '" + HttpContext.Current.Session["CentreID"].ToString() + "'  ");

        if (purchaseOrderType == 1)
        {
            sqlCmd.Append(" AND im.IsStockable=@isStockable  ");
            purchaseOrderType = 0;
        }



        DataTable dt = excuteCMD.GetDataTable(sqlCmd.ToString(), CommandType.Text, new
         {
             centreID = centreID,
             departmentLedgerNO = departmentLedgerNo,
             vendorID = vendorId,
             isStockable = purchaseOrderType,
             centerID = HttpContext.Current.Session["CentreID"].ToString()
         });
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }



    [WebMethod]
    public string GetItemQuotationDetails(string itemID, int centreID, string departmentLedgerNo)
    {

        StringBuilder sqlCmd = new StringBuilder();
        sqlCmd.Append(" SELECT rt.Minimum_Tolerance_Qty,rt.Maximum_Tolerance_Qty,rt.Maximum_Tolerance_Rate,rt.Minimum_Tolerance_Rate,rt.CurrencyCountryID,rt.Currency,rt.Currency_Factor,rt.Rate rate, '' IsDeal, rt.GSTType as TaxGroup, 'RateAD' TaxCalulatedOn, rt.MRP MRP, rt.Vendor_ID Vendor_ID, IFNULL(im.HSNCode, '') HSNCode, rt.TotalTaxPercent VAT, IFNULL(rt.DiscountPercent,0) DiscountPercent,im.ConversionFactor,rt.IGSTPercent,rt.CGSTPercent,rt.SGSTPercent,rt.GSTType,rt.TaxAmt  FROM f_itemmaster im INNER JOIN f_storeitem_rate rt ON rt.ItemID=im.ItemID   AND rt.IsActive=1 WHERE im.ItemID=@itemID AND im.IsActive=1 ");
        ExcuteCMD excuteCMD = new ExcuteCMD();

        string s = excuteCMD.GetRowQuery(sqlCmd.ToString(), new
        {
            itemID = itemID,
            centreID = centreID,
            departmentLedgerNo = departmentLedgerNo
        });


        DataTable dt = excuteCMD.GetDataTable(sqlCmd.ToString(), CommandType.Text, new
        {
            itemID = itemID,
            centreID = centreID,
            departmentLedgerNo = departmentLedgerNo
        });

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }





    [WebMethod]
    public string GetPurchaseOrderItemsByReoderLevel(string departmentLedgerNo, int centreID, string categoryID, string subcategoryid, int groupId)
    {
        StringBuilder sqlCmd = new StringBuilder();
        sqlCmd.Append(" SELECT t.ItemName,t.ItemID,t.Rate,t.MRP,t.Discount,t.Deal,t.GSTGroup,t.TaxOn,t.PUnit,t.Stock,t.Free,t.HSNCode,t.Supplier,t.supplierID,(t.MaxLevel-t.Stock)'Quantity',t.`ReorderLevel`,t.`MaxLevel`,t.MinLevel FROM ( ");
        sqlCmd.Append(" SELECT im.`TypeName` 'ItemName',im.`ItemID` 'ItemID',IFNULL(r.`GrossAmt`,0) 'Rate',IFNULL(r.`MRP`,0)'MRP',IFNULL(r.`DiscountPercent`,0)'Discount', ");
        sqlCmd.Append(" IFNULL(r.`IsDeal`,'')'Deal',IFNULL((SELECT s.`TaxGroup` FROM store_taxgroup_category s WHERE s.`id`=r.`GSTGroupID` AND s.`IsActive`=1),'GST5%')'GSTGroup', ");
        sqlCmd.Append(" IFNULL(r.`TaxCalulatedOn`,'RateAD')'TaxOn',IFNULL(imdp.`majorUnit`,im.`MajorUnit`)'PUnit', ");
        sqlCmd.Append(" IFNULL((SELECT SUM(st.InitialCount)-SUM(st.ReleasedCount)  FROM f_stock st  WHERE st.DeptLedgerNo=@departmentLedgerNo AND st.CentreID=@centreID ");
        sqlCmd.Append(" AND st.ItemID=im.ItemID AND st.IsPost=1 AND IF(st.`IsExpirable` = 0,1 = 1,st.`MedExpiryDate` > CURDATE()) ),0) 'Stock','No' AS 'Free',IFNULL(r.`HSNCode`,im.`HSNCode`)'HSNCode', ");
        sqlCmd.Append(" IFNULL((SELECT lm.`LedgerName` FROM `f_ledgermaster` lm WHERE lm.`GroupID`='VEN' AND lm.`LedgerNumber`=r.`Vendor_ID`),'')'Supplier',imdp.`ReorderLevel`,imdp.`MaxLevel`,imdp.MinLevel,r.`Vendor_ID` 'supplierID' ");
        sqlCmd.Append(" FROM `f_itemmaster_deptwise` imdp  ");
        sqlCmd.Append(" INNER JOIN `f_itemmaster` im ON im.`ItemID`=imdp.`ItemID` INNER JOIN f_subcategorymaster fcm ON fcm.`SubCategoryID`=im.`SubCategoryID` ");
        sqlCmd.Append("AND  imdp.`CentreID`=@centreID AND imdp.`DeptLedgerNo`=@departmentLedgerNo AND im.`IsActive`=1 ");

        if (groupId != 0)
        {
            sqlCmd.Append("AND im.`ItemGroupMasterID`=@groupId ");
        }
        sqlCmd.Append("AND fcm.`CategoryID`=@categoryID AND imdp.`IsActive`=1 ");
        if (subcategoryid != "0")
        {
            sqlCmd.Append(" AND im.SubCategoryID=@subcategoryid ");
        }
        sqlCmd.Append(" LEFT JOIN  f_storeitem_rate r ON r.`ItemID`=im.`ItemID`  AND r.`CentreID`=@centreID AND r.`IsActive`=1  ");
        sqlCmd.Append(" )t where  (t.ReorderLevel-t.Stock)>0  ");

        ExcuteCMD excuteCMD = new ExcuteCMD();
        var obj = new
        {
            departmentLedgerNo = departmentLedgerNo,
            centreID = centreID,
            categoryID = categoryID,
            groupId = groupId,
            subcategoryid = subcategoryid
        };

        DataTable dt = excuteCMD.GetDataTable(sqlCmd.ToString(), CommandType.Text, obj);
        var s = excuteCMD.GetRowQuery(sqlCmd.ToString(), obj);
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
    }



    public class POItemDetail
    {
        public string ID { get; set; }
        public string PUnit { get; set; }
        public int Stock { get; set; }
        public string ItemName { get; set; }
        public string Deal { get; set; }
        public decimal Rate { get; set; }
        public decimal Discount { get; set; }
        public string GSTGroup { get; set; }
        public decimal MRP { get; set; }
        public decimal Quantity { get; set; }
        public string TaxOn { get; set; }
        public decimal IGSTPercent { get; set; }
        public decimal IGSTAmt { get; set; }
        public decimal CGSTPercent { get; set; }
        public decimal CGSTAmt { get; set; }
        public decimal SGSTPercent { get; set; }
        public decimal SGSTAmt { get; set; }
        public decimal TaxAmt { get; set; }
        public string Supplier { get; set; }
        public string supplierID { get; set; }
        public decimal NetAmount { get; set; }
        public string ItemID { get; set; }
        public string Free { get; set; }
        public string HSNCode { get; set; }
        public string PurchaseRequestsNo { get; set; }
        public string CentreID { get; set; }
        public string ManuFacturer { get; set; }
        public string ManufactureID { get; set; }
        public string SubCategoryID { get; set; }
        public decimal VAT { get; set; }
        public string Currency { get; set; }
        public decimal CurrencyFactor { get; set; }
        public decimal CurrencyCountryID { get; set; }
        public decimal Minimum_Tolerance_Qty { get; set; }
        public decimal Maximum_Tolerance_Qty { get; set; }
        public decimal Minimum_Tolerance_Rate { get; set; }
        public decimal Maximum_Tolerance_Rate { get; set; }
        public string GSTType { get; set; }

    }

    public class SupplierAdvanceDetail
    {
        public string supplierID { get; set; }
        public decimal advanceAmount { get; set; }
        public decimal paymentModeID { get; set; }
    }

    public class supplierAdvanceTermsDetails
    {
        public string PONumber { get; set; }
        public int DetailsID { get; set; }
        public string Details { get; set; }
        public string supplierID { get; set; }
    }

    public class _purchaseOrder
    {

        public string vendorID { get; set; }
        public string purchaseOrder { get; set; }


    }



    [WebMethod(EnableSession = true)]
    public string Save(List<POItemDetail> data, decimal POAmount, decimal RoundOff, decimal FreightCharges, string PODate, string validDate, string DeliveryDate, string POType, string Remarks, string StoreType, string purchaseOrderNumber, bool isConsolidated, string draftID, decimal otherCharges, int IsService, string documentBase64, List<SupplierAdvanceDetail> supplierAdvanceDetails, List<supplierAdvanceTermsDetails> supplierAdvanceTermsDetails)
    {

        List<_purchaseOrder> purchaseOrderList = new List<_purchaseOrder>();
        MySqlConnection con = new MySqlConnection();
        ExcuteCMD excuteCMD = new ExcuteCMD();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.ReadCommitted);

        try
        {

            //var purchaseOrderCurrencyDetails = excuteCMD.GetDataTable("SELECT s.S_CountryID,s.S_Notation,s.Selling_Specific FROM converson_master s WHERE s.S_CountryID=@countryID  ORDER BY DATE DESC LIMIT 1", CommandType.Text, new
            //{
            //    countryID = currencyCountryID
            //});



            //if (purchaseOrderCurrencyDetails.Rows.Count < 1)
            //    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = "PO Currency Details Not Found.", purchaseOrderList = purchaseOrderList });


            //purchaseOrderCurrencyDetails.Rows[0]["Selling_Specific"] = CurrencyFactor;

            if (isConsolidated)
            {
                List<string> distinctCentreIDs = data.Select(p => p.CentreID).Distinct().ToList();
                foreach (var centre in distinctCentreIDs)
                {
                    var centerData = data.Where(i => i.CentreID == centre).ToList();
                    CreatePurchaseOrder(centerData, FreightCharges, PODate, validDate, DeliveryDate, POType, Remarks, StoreType, purchaseOrderNumber, purchaseOrderList, excuteCMD, tnx, otherCharges, IsService, documentBase64, supplierAdvanceDetails);
                }
            }
            else
                CreatePurchaseOrder(data, FreightCharges, PODate, validDate, DeliveryDate, POType, Remarks, StoreType, purchaseOrderNumber, purchaseOrderList, excuteCMD, tnx, otherCharges, IsService, documentBase64, supplierAdvanceDetails);

            if (!string.IsNullOrWhiteSpace(draftID))
            {
                excuteCMD.DML(tnx, "UPDATE store_purchaseOrder_draft SET IsActive=0 WHERE Id=" + draftID + "", CommandType.Text, new
                {
                    id = data[0].ID
                });
            }



            for (int j = 0; j < purchaseOrderList.Count; j++)
            {
                excuteCMD.DML(tnx, "UPDATE f_purchaseorderterms SET IsActive=0 WHERE PONumber='" + purchaseOrderNumber + "'", CommandType.Text, new
                    {
                        purchaseOrderNumber = purchaseOrderList[j].purchaseOrder
                    });

                ///update to deactivate terms
                //, po number 

                var _supplierAdvanceTermsDetails = supplierAdvanceTermsDetails.Where(v => v.supplierID == purchaseOrderList[j].vendorID).ToList();
                for (int i = 0; i < _supplierAdvanceTermsDetails.Count; i++)
                {
                    string sqlCMD = "INSERT INTO f_purchaseorderterms(PONumber,DetailsID,Details,Createdby,Createdate)"
                                 + " VALUES (@PONumber,@DetailsID,@Details,@Createdby,Now());SELECT @@identity; ";


                    var PoTermsID = excuteCMD.ExecuteScalar(tnx, sqlCMD, CommandType.Text, new
                    {
                        PONumber = purchaseOrderList[j].purchaseOrder,
                        DetailsID = _supplierAdvanceTermsDetails[i].DetailsID,
                        Details = _supplierAdvanceTermsDetails[i].Details,
                        Createdby = HttpContext.Current.Session["ID"].ToString()
                    });
                }
            }

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = AllGlobalFunction.saveMessage, purchaseOrderList = purchaseOrderList });

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = AllGlobalFunction.errorMessage, response = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Dispose();
            con.Close();
        }
    }

    private void CreatePurchaseOrder(List<POItemDetail> data, decimal FreightCharges, string PODate, string validDate, string DeliveryDate, string POType, string Remarks, string StoreType, string purchaseOrderNumber, List<_purchaseOrder> purchaseOrderList, ExcuteCMD excuteCMD, MySqlTransaction tnx, decimal otherCharges, int IsService, string documentBase64, List<SupplierAdvanceDetail> supplierAdvanceDetails)
    {
        List<string> distinctVendors = data.Select(p => p.supplierID).Distinct().ToList();

        for (int j = 0; j < distinctVendors.Count; j++)
        {
            if (distinctVendors[j] != "0")
            {
            var vendorItems = data.Where(i => i.supplierID == distinctVendors[j]).ToList();
            List<POItemDetails> dataPOItem = new List<POItemDetails>();

            SupplierAdvanceDetail supplierAdvanceDetail = supplierAdvanceDetails.Where(i => i.supplierID == distinctVendors[j]).FirstOrDefault();

            PODetails purchaseOrderDetails = new PODetails
            {
                VendorId = distinctVendors[j],
                Narration = Remarks,
                VendorName = vendorItems[0].Supplier,
                TypeId = "HS",
                Remarks = Remarks,
                PODate = PODate,
                ValidDate = Util.GetDateTime(validDate),
                DeliveryDate = Util.GetDateTime(DeliveryDate),
                Freight = FreightCharges,
                Scheme = 0,
                ExciseOnBill = 0,
                POType = POType,
                StoreLedgerNo = StoreType,
                DeptLedgerNo = HttpContext.Current.Session["DeptLedgerNo"].ToString(),
                PO_S_CountryID = Util.GetInt(vendorItems[0].CurrencyCountryID),
                PO_S_Notation = Util.GetString(vendorItems[0].Currency),
                PO_Selling_Specific = Util.GetDecimal(vendorItems[0].CurrencyFactor),
                otherCharges = otherCharges,
                IsService = IsService,
                advanceAmount = Math.Round((Util.GetDecimal(supplierAdvanceDetail.advanceAmount) * Util.GetDecimal(vendorItems[0].CurrencyFactor)), 4, MidpointRounding.AwayFromZero),
                paymentModeID = supplierAdvanceDetail.paymentModeID
            };



            decimal purchaseOrderTotalAmount = 0;
            for (int i = 0; i < vendorItems.Count; i++)
            {

                vendorItems[i].IGSTAmt = Math.Round(((Util.GetDecimal(vendorItems[i].Rate) - (Util.GetDecimal(vendorItems[i].Rate) * Util.GetDecimal(vendorItems[i].Discount) * Util.GetDecimal("0.01"))) * Util.GetDecimal(vendorItems[i].IGSTPercent) * Util.GetDecimal("0.01"))*Util.GetDecimal(vendorItems[i].Quantity), 4);
                vendorItems[i].CGSTAmt = Math.Round(((Util.GetDecimal(vendorItems[i].Rate) - (Util.GetDecimal(vendorItems[i].Rate) * Util.GetDecimal(vendorItems[i].Discount) * Util.GetDecimal("0.01"))) * Util.GetDecimal(vendorItems[i].CGSTPercent) * Util.GetDecimal("0.01"))*Util.GetDecimal(vendorItems[i].Quantity), 4);
                vendorItems[i].SGSTAmt = Math.Round(((Util.GetDecimal(vendorItems[i].Rate) - (Util.GetDecimal(vendorItems[i].Rate) * Util.GetDecimal(vendorItems[i].Discount) * Util.GetDecimal("0.01"))) * Util.GetDecimal(vendorItems[i].SGSTPercent) * Util.GetDecimal("0.01"))*Util.GetDecimal(vendorItems[i].Quantity), 4);
               
                
                POItemDetails purchaseOrderItemDetails = new POItemDetails
                {
                    VendorID = distinctVendors[j],
                    VendorName = vendorItems[0].Supplier,
                    ItemID = vendorItems[i].ItemID,
                    ItemName = vendorItems[i].ItemName,
                    SubCategoryID = vendorItems[i].SubCategoryID, //Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT SubCategoryID FROM f_itemmaster WHERE ItemID='" + vendorItems[i].ItemID + "'")),
                    Rate = vendorItems[i].Rate * purchaseOrderDetails.PO_Selling_Specific,
                    BuyPrice = (vendorItems[i].NetAmount * purchaseOrderDetails.PO_Selling_Specific / vendorItems[i].Quantity),
                    Unit = vendorItems[i].PUnit,
                    OrderQty = vendorItems[i].Quantity,
                    DiscPer = vendorItems[i].Discount,
                    InHandQty = vendorItems[i].Stock,
                    TaxPer = Resources.Resource.IsGSTApplicable == "1" ? (vendorItems[i].IGSTPercent + vendorItems[i].CGSTPercent + vendorItems[i].SGSTPercent) : vendorItems[i].VAT,
                    SaleTaxPer = 0,
                    NetAmt = vendorItems[i].NetAmount * purchaseOrderDetails.PO_Selling_Specific,
                    ManufactureID = vendorItems[i].ManufactureID, //Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT ManufactureID FROM f_itemmaster WHERE ItemID='" + vendorItems[i].ItemID + "'")),
                    Manufacturer = vendorItems[i].ManuFacturer,//Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT ManuFacturer FROM f_itemmaster WHERE ItemID='" + vendorItems[i].ItemID + "'")),
                    Type_ID = "HS",
                    Free = (vendorItems[i].Free.ToUpper().Equals("YES")) ? 1 : 0,
                    GSTPer = Resources.Resource.IsGSTApplicable == "1" ? (vendorItems[i].IGSTPercent + vendorItems[i].CGSTPercent + vendorItems[i].SGSTPercent) : vendorItems[i].VAT,
                    GSTAmt = Util.GetDecimal(vendorItems[i].TaxAmt * purchaseOrderDetails.PO_Selling_Specific),
                    TaxCalulatedOn = vendorItems[i].TaxOn,
                    GSTType = vendorItems[i].GSTType,   //GSTGroup,
                    HSNCode = vendorItems[i].HSNCode,
                    IGSTPercent = vendorItems[i].IGSTPercent,
                    IGSTAmt = Util.GetDecimal(vendorItems[i].IGSTAmt * purchaseOrderDetails.PO_Selling_Specific),
                    CGSTPercent = vendorItems[i].CGSTPercent,
                    CGSTAmt = Util.GetDecimal(vendorItems[i].CGSTAmt * purchaseOrderDetails.PO_Selling_Specific),
                    SGSTPercent = vendorItems[i].SGSTPercent,
                    SGSTAmt = Util.GetDecimal(vendorItems[i].SGSTAmt * purchaseOrderDetails.PO_Selling_Specific),
                    IsDeal = vendorItems[i].Deal,
                    MRP = vendorItems[i].MRP * purchaseOrderDetails.PO_Selling_Specific,
                    PurchaseRequestsNo = vendorItems[i].PurchaseRequestsNo,
                    ID = vendorItems[i].ID,
                    Currency = purchaseOrderDetails.PO_S_Notation,
                    CurrencyFactor = purchaseOrderDetails.PO_Selling_Specific,
                    CurrencyCountryID = purchaseOrderDetails.PO_S_CountryID,
                    Minimum_Tolerance_Qty = vendorItems[i].Minimum_Tolerance_Qty,
                    Maximum_Tolerance_Qty = vendorItems[i].Maximum_Tolerance_Qty,
                    Minimum_Tolerance_Rate = vendorItems[i].Minimum_Tolerance_Rate,
                    Maximum_Tolerance_Rate = vendorItems[i].Maximum_Tolerance_Rate
                };
                purchaseOrderTotalAmount += vendorItems[i].NetAmount * purchaseOrderDetails.PO_Selling_Specific;
                dataPOItem.Add(purchaseOrderItemDetails);
            }

            purchaseOrderDetails.GrossAmount = purchaseOrderTotalAmount;
            purchaseOrderDetails.NetAmount = Math.Round(purchaseOrderTotalAmount, 0, MidpointRounding.AwayFromZero);
            purchaseOrderDetails.RoundOff = Math.Round((purchaseOrderDetails.NetAmount - purchaseOrderTotalAmount), 2, MidpointRounding.AwayFromZero);

            string purchaseOrderNo = SavePurchaseOrder(tnx, purchaseOrderDetails, dataPOItem, excuteCMD, purchaseOrderNumber, documentBase64);

            purchaseOrderList.Add(new _purchaseOrder
            {
                purchaseOrder = purchaseOrderNo,
                vendorID = purchaseOrderDetails.VendorId
            });
            }
        }
    }



    private string SavePurchaseOrder(MySqlTransaction tnx, PODetails purchaseOrderDetails, List<POItemDetails> purchaseOrderItemDetails, ExcuteCMD excuteCMD, string purchaseOrderNumber, string documentBase64)
    {
        string purchaseOrderNo = string.Empty;
        if (!string.IsNullOrEmpty(purchaseOrderNumber))
        {
            purchaseOrderNo = purchaseOrderNumber;
            excuteCMD.DML(tnx, "UPDATE f_purchaseorderdetails p SET p.IsActive=0 WHERE p.PurchaseOrderNo=@purchaseOrderNo", CommandType.Text, new
            {
                purchaseOrderNo = purchaseOrderNo
            });
        }
        else
            purchaseOrderNo = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "Select get_po_number('" + purchaseOrderDetails.TypeId + "','" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "','" + HttpContext.Current.Session["CentreID"].ToString() + "')"));


        if (string.IsNullOrEmpty(purchaseOrderNo))
            throw new Exception("Error While Creating Purchase Order Number.");


        string filePath = string.Empty;
        if (!string.IsNullOrEmpty(documentBase64))
        {

            if (All_LoadData.chkDocumentDrive() == 0)
                throw new Exception("Please Create " + Resources.Resource.DocumentDriveName + " Drive");

            var directoryPath = All_LoadData.createDocumentFolder("PurchaseOrders", purchaseOrderNo.ToString().Replace("/", "_"));
            filePath = System.IO.Path.Combine(directoryPath.ToString(), purchaseOrderNo.ToString().Replace("/", "_"));
            filePath = PatientDocument.SaveFile(filePath, documentBase64);

        }

        DateTime ByDate = Util.GetDateTime("01-Jan-0001");
        PurchaseOrderMaster purchaseOrderMaster = new PurchaseOrderMaster(tnx);
        purchaseOrderMaster.Subject = purchaseOrderDetails.Narration;
        purchaseOrderMaster.Remarks = purchaseOrderDetails.Remarks;
        purchaseOrderMaster.VendorID = purchaseOrderDetails.VendorId;
        purchaseOrderMaster.VendorName = purchaseOrderDetails.VendorName;
        if (!String.IsNullOrEmpty(purchaseOrderDetails.PODate))
            purchaseOrderMaster.RaisedDate = Util.GetDateTime(purchaseOrderDetails.PODate);
        else
            purchaseOrderMaster.RaisedDate = DateTime.Now;
        purchaseOrderMaster.RaisedUserID = Convert.ToString(HttpContext.Current.Session["ID"]);
        purchaseOrderMaster.RaisedUserName = Convert.ToString(HttpContext.Current.Session["UserName"]);
        purchaseOrderMaster.ValidDate = Util.GetDateTime(purchaseOrderDetails.ValidDate);
        purchaseOrderMaster.DeliveryDate = Util.GetDateTime(purchaseOrderDetails.DeliveryDate);
        purchaseOrderMaster.NetTotal = Util.GetDecimal(purchaseOrderDetails.NetAmount) + Util.GetDecimal(purchaseOrderDetails.Freight) - Util.GetDecimal(purchaseOrderDetails.Scheme) - Util.GetDecimal(purchaseOrderDetails.ExciseOnBill);
        purchaseOrderMaster.GrossTotal = purchaseOrderDetails.GrossAmount;
        purchaseOrderMaster.Freight = purchaseOrderDetails.Freight;
        purchaseOrderMaster.RoundOff = purchaseOrderDetails.RoundOff;
        purchaseOrderMaster.Scheme = purchaseOrderDetails.Scheme;
        purchaseOrderMaster.Type = purchaseOrderDetails.POType;
        purchaseOrderMaster.ByDate = ByDate;

        purchaseOrderMaster.StoreLedgerNo = Util.GetString(purchaseOrderDetails.StoreLedgerNo);
        purchaseOrderMaster.DeptLedgerNo = purchaseOrderDetails.DeptLedgerNo;

        purchaseOrderMaster.S_Amount = Util.GetDecimal(0);
        purchaseOrderMaster.S_CountryID = Util.GetInt(purchaseOrderDetails.PO_S_CountryID);
        purchaseOrderMaster.S_Currency = Util.GetString(purchaseOrderDetails.PO_S_Notation);
        purchaseOrderMaster.C_Factor = Util.GetDecimal(purchaseOrderDetails.PO_Selling_Specific);

       // AllSelectQuery ASQ = new AllSelectQuery();
        //purchaseOrderMaster.C_Factor = ASQ.GetConversionFactor(Util.GetInt(Resources.Resource.BaseCurrencyID));
        purchaseOrderMaster.PoNumber = purchaseOrderNo;
        purchaseOrderMaster.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
        purchaseOrderMaster.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
        purchaseOrderMaster.IPAddress = All_LoadData.IpAddress();
        purchaseOrderMaster.OtherCharges = purchaseOrderDetails.otherCharges;
        purchaseOrderMaster.IsService = purchaseOrderDetails.IsService;
        purchaseOrderMaster.DocumentPath = filePath;
        purchaseOrderMaster.AmountAdvance = purchaseOrderDetails.advanceAmount;
        purchaseOrderMaster.paymentModeID = Util.GetInt(purchaseOrderDetails.paymentModeID);
        //purchaseOrderMaster

        if (string.IsNullOrEmpty(purchaseOrderNumber))
            purchaseOrderNo = purchaseOrderMaster.Insert();
        else
        {
            string sqlUpdateCMD = "UPDATE f_purchaseorder SET SUBJECT =@Subject, VendorID =@VendorID, VendorName =@VendorName, ValidDate =@ValidDate, GrossTotal =@GrossTotal, NetTotal =@NetTotal, AmountAdvance =@AmountAdvance, LastUpdatedDate =NOW(), LastUpdatedUserID =@LastUpdatedUserID, LastUpdatedUserName =@LastUpdatedUserName, Freight =@Freight, TYPE =@Type,Remarks =@Remarks, ExciseOnBill =@ExciseOnBill, Roundoff =@RoundOff, Scheme =@Scheme, IpAddress =@IPAddress, S_Amount =@S_Amount, S_CountryID =@S_CountryID, S_Currency =@S_Currency, C_Factor =@C_Factor, DeliveryDate =@DeliveryDate,DeptLedgerNo =@DeptLedgerNo, StoreLedgerNo =@StoreLedgerNo, CentreID =@CentreID,OtherCharges=@OtherCharges,DocumentPath=@DocumentPath,AmountAdvance=@AmountAdvance WHERE PurchaseOrderNo =@PurchaseOrderNo";
            purchaseOrderMaster.PurchaseOrderNo = purchaseOrderNumber;
            purchaseOrderMaster.LastUpdatedUserID = purchaseOrderMaster.RaisedUserID;
            purchaseOrderMaster.LastUpdatedUserName = purchaseOrderMaster.RaisedUserName;
            var s = excuteCMD.GetRowQuery(sqlUpdateCMD, purchaseOrderMaster);
            excuteCMD.DML(tnx, sqlUpdateCMD, CommandType.Text, purchaseOrderMaster);

        }



        for (int i = 0; i < purchaseOrderItemDetails.Count; i++)
        {
            int PODDetail = 0;
            PurchaseOrderDetail purchaseOrderDetail = new PurchaseOrderDetail(tnx);
            purchaseOrderDetail.ItemID = purchaseOrderItemDetails[i].ItemID;
            purchaseOrderDetail.ItemName = purchaseOrderItemDetails[i].ItemName;
            purchaseOrderDetail.PurchaseOrderNo = purchaseOrderNo;
            purchaseOrderDetail.OrderedQty = purchaseOrderItemDetails[i].OrderQty;
            purchaseOrderDetail.Rate = purchaseOrderItemDetails[i].Rate;
            purchaseOrderDetail.QoutationNo = string.Empty;
            purchaseOrderDetail.SubCategoryID = purchaseOrderItemDetails[i].SubCategoryID;
            purchaseOrderDetail.Status = 0;
            purchaseOrderDetail.ApprovedQty = purchaseOrderItemDetails[i].OrderQty;
            purchaseOrderDetail.BuyPrice = purchaseOrderItemDetails[i].BuyPrice;
            purchaseOrderDetail.Amount = purchaseOrderDetail.ApprovedQty * purchaseOrderDetail.BuyPrice;
            purchaseOrderDetail.Discount_p = purchaseOrderItemDetails[i].DiscPer;
            purchaseOrderDetail.Discount_a = (purchaseOrderItemDetails[i].Rate * purchaseOrderItemDetails[i].OrderQty * purchaseOrderItemDetails[i].DiscPer) / 100;
            purchaseOrderDetail.RecievedQty = 0;
         //   purchaseOrderDetail.Status = 0;
            purchaseOrderDetail.Specification = purchaseOrderDetails.Narration;
            purchaseOrderDetail.Unit = purchaseOrderItemDetails[i].Unit;
            purchaseOrderDetail.IsFree = purchaseOrderItemDetails[i].Free;
            purchaseOrderDetail.DeptLedgerNo = purchaseOrderDetails.DeptLedgerNo;
            purchaseOrderDetail.ExcisePercent = Util.GetDecimal(0);
            purchaseOrderDetail.ExciseAmt = Util.GetDecimal(0);
            purchaseOrderDetail.VATPercent = purchaseOrderItemDetails[i].GSTPer;
            purchaseOrderDetail.VATAmt = purchaseOrderItemDetails[i].GSTAmt;
            purchaseOrderDetail.StoreLedgerNo = Util.GetString(purchaseOrderDetails.StoreLedgerNo);
            purchaseOrderDetail.TaxCalulatedOn = purchaseOrderItemDetails[i].TaxCalulatedOn;
            purchaseOrderDetail.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            purchaseOrderDetail.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            purchaseOrderDetail.GSTType = purchaseOrderItemDetails[i].GSTType;
            purchaseOrderDetail.HSNCode = purchaseOrderItemDetails[i].HSNCode;
            purchaseOrderDetail.IGSTPercent = purchaseOrderItemDetails[i].IGSTPercent;
            purchaseOrderDetail.IGSTAmt = purchaseOrderItemDetails[i].IGSTAmt;
            purchaseOrderDetail.CGSTPercent = purchaseOrderItemDetails[i].CGSTPercent;
            purchaseOrderDetail.CGSTAmt = purchaseOrderItemDetails[i].CGSTAmt;
            purchaseOrderDetail.SGSTPercent = purchaseOrderItemDetails[i].SGSTPercent;
            purchaseOrderDetail.SGSTAmt = purchaseOrderItemDetails[i].SGSTAmt;
            purchaseOrderDetail.isDeal = purchaseOrderItemDetails[i].IsDeal;
            purchaseOrderDetail.MRP = purchaseOrderItemDetails[i].MRP;
            purchaseOrderDetail.S_CountryID = purchaseOrderItemDetails[i].CurrencyCountryID;
            purchaseOrderDetail.S_Currency = purchaseOrderItemDetails[i].Currency;
            purchaseOrderDetail.C_Factor = purchaseOrderItemDetails[i].CurrencyFactor;
            purchaseOrderDetail.Minimum_Tolerance_Qty = purchaseOrderItemDetails[i].Minimum_Tolerance_Qty;
            purchaseOrderDetail.Maximum_Tolerance_Qty = purchaseOrderItemDetails[i].Maximum_Tolerance_Qty;
            purchaseOrderDetail.Minimum_Tolerance_Rate = purchaseOrderItemDetails[i].Minimum_Tolerance_Rate;
            purchaseOrderDetail.Maximum_Tolerance_Rate = purchaseOrderItemDetails[i].Maximum_Tolerance_Rate;
            
            
            purchaseOrderDetail.PurchaseOrderDetailID = Util.GetInt(purchaseOrderItemDetails[i].ID);
            if (string.IsNullOrEmpty(purchaseOrderItemDetails[i].ID))
            {
                PODDetail = purchaseOrderDetail.Insert();
            }
            else
            {
                string sqlUpdateCMD = "UPDATE f_purchaseorderdetails SET IsActive=1, ItemID =@ItemID, ItemName =@ItemName, SubCategoryID =@SubCategoryID, OrderedQty =@OrderedQty, ApprovedQty =@ApprovedQty, RecievedQty =@RecievedQty, QoutationNo =@QoutationNo, Rate =@Rate, Discount_a =@Discount_a, Discount_p =@Discount_p, BuyPrice =@BuyPrice, Amount =@Amount, MRP =@MRP, IsFree =@IsFree, Specification =@Specification, Unit =@Unit, StoreLedgerNo =@StoreLedgerNo, LastUpdatedBy =@LastUpdatedBy, Updatedate =NOW(), DeptLedgerNo =@DeptLedgerNo, PurchaseRequestNo =@PurchaseRequestNo, VATAmt =@VATAmt, ExcisePer =@ExcisePercent, ExciseAmt =@ExciseAmt, TaxCalulatedOn =@TaxCalulatedOn, GSTType =@GSTType, HSNCode =@HSNCode, IGSTPercent =@IGSTPercent, IGSTAmt =@IGSTAmt, CGSTPercent =@CGSTPercent, CGSTAmt =@CGSTAmt, SGSTPercent =@SGSTPercent, SGSTAmt =@SGSTAmt, IsDeal =@isDeal,C_Factor=@C_Factor,S_CountryID=@S_CountryID,S_Currency=@S_Currency  WHERE PurchaseOrderDetailID =@PurchaseOrderDetailID";
                purchaseOrderDetail.LastUpdatedBy = purchaseOrderMaster.RaisedUserID;
                var s = excuteCMD.GetRowQuery(sqlUpdateCMD, purchaseOrderDetail);
                excuteCMD.DML(tnx, sqlUpdateCMD, CommandType.Text, purchaseOrderDetail);
                PODDetail = purchaseOrderDetail.PurchaseOrderDetailID;
            }




            int roleID = 5;// Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT ID FROM f_rolemaster WHERE DeptLedgerNo='" + PO.DeptLedgerNo + "'"));
            string notification = Notification_Insert.notificationInsert(31, PODDetail.ToString(), tnx, "", "", roleID);
            if (PODDetail == 0)
                throw new Exception("Error While Purchase Order Items.");


            if (!string.IsNullOrEmpty(purchaseOrderItemDetails[i].PurchaseRequestsNo))
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_purchaserequestdetails SET orderedQty=orderedQty+" + Util.GetDecimal(purchaseOrderItemDetails[i].OrderQty) + " WHERE PurchaseRequisitionNo='" + purchaseOrderItemDetails[i].PurchaseRequestsNo + "' AND ItemID='" + purchaseOrderItemDetails[i].ItemID + "' ");

                PurchaseOrderPurchaseRequest purchaseOrderPurchaseRequest = new PurchaseOrderPurchaseRequest(tnx);
                purchaseOrderPurchaseRequest.PONumber = purchaseOrderNo;
                purchaseOrderPurchaseRequest.PRNumber = purchaseOrderItemDetails[i].PurchaseRequestsNo;
                purchaseOrderPurchaseRequest.ITemID = purchaseOrderItemDetails[i].ItemID;
                purchaseOrderPurchaseRequest.OrderedQty = Util.GetDecimal(purchaseOrderItemDetails[i].OrderQty);
                purchaseOrderPurchaseRequest.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                purchaseOrderPurchaseRequest.Hospital_ID = Util.GetString(Session["HOSPID"]).ToString();
                purchaseOrderPurchaseRequest.PODetailID = PODDetail;
                purchaseOrderPurchaseRequest.InsertPoPr();
            }

        }
        return purchaseOrderNo;

    }
    public class PODetails
    {
        public string VendorId { get; set; }
        public string VendorName { get; set; }
        public string TypeId { get; set; }
        public string Narration { get; set; }
        public string Remarks { get; set; }
        public string PODate { get; set; }
        public DateTime ValidDate { get; set; }
        public DateTime DeliveryDate { get; set; }
        public decimal Freight { get; set; }
        public decimal RoundOff { get; set; }
        public decimal Scheme { get; set; }
        public decimal ExciseOnBill { get; set; }
        public decimal NetAmount { get; set; }
        public decimal GrossAmount { get; set; }
        public string POType { get; set; }
        public string StoreLedgerNo { get; set; }
        public string DeptLedgerNo { get; set; }
        public int PO_S_CountryID { get; set; }
        public string PO_S_Notation { get; set; }
        public decimal PO_Selling_Specific { get; set; }
        public decimal otherCharges { get; set; }
        public int IsService { get; set; }
        public decimal advanceAmount { get; set; }
        public decimal paymentModeID { get; set; }
    }
    public class POItemDetails
    {
        public string ID { get; set; }
        public string VendorID { get; set; }
        public string VendorName { get; set; }
        public string ItemID { get; set; }
        public string ItemName { get; set; }
        public string SubCategoryID { get; set; }
        public decimal Rate { get; set; }
        public decimal BuyPrice { get; set; }
        public string Unit { get; set; }
        public decimal OrderQty { get; set; }
        public decimal DiscPer { get; set; }
        public decimal InHandQty { get; set; }
        public decimal TaxPer { get; set; }
        public decimal SaleTaxPer { get; set; }
        public decimal NetAmt { get; set; }
        public string Manufacturer { get; set; }
        public string ManufactureID { get; set; }
        public string Type_ID { get; set; }
        public int Free { get; set; }
        public decimal GSTPer { get; set; }
        public decimal GSTAmt { get; set; }
        public string TaxCalulatedOn { get; set; }
        public string GSTType { get; set; }
        public string HSNCode { get; set; }
        public decimal IGSTPercent { get; set; }
        public decimal IGSTAmt { get; set; }
        public decimal CGSTPercent { get; set; }
        public decimal CGSTAmt { get; set; }
        public decimal SGSTPercent { get; set; }
        public decimal SGSTAmt { get; set; }
        public string IsDeal { get; set; }
        public decimal MRP { get; set; }
        public string PurchaseRequestsNo { get; set; }
        public string CentreID { get; set; }
        public string Currency { get; set; }
        public decimal CurrencyFactor { get; set; }
        public int CurrencyCountryID { get; set; }
        public decimal Minimum_Tolerance_Qty { get; set; }
        public decimal Maximum_Tolerance_Qty { get; set; }
        public decimal Minimum_Tolerance_Rate { get; set; }
        public decimal Maximum_Tolerance_Rate { get; set; }

    }

    [WebMethod(EnableSession = true)]
    public string GetPOList(string PONo, string fromDate, string toDate, bool searchType, int centerId, string deptLedgerNo)
    {
        ExcuteCMD excuteCMD = new ExcuteCMD();
        StringBuilder sqlCmd = new StringBuilder();
        var roleID = Util.GetInt(Session["RoleID"]);
        var employeeID = Util.GetString(HttpContext.Current.Session["ID"]);

        var CanEditPO = Util.GetInt(All_LoadData.GetAuthorization(roleID, employeeID, "CanEditPurchaseOrder"));


        sqlCmd.Append(" SELECT DISTINCT(PO.PurchaseOrderNo)PONo,PO.NetTotal,PO.GrossTotal,PO.Subject,PO.VendorName,DATE_FORMAT(PO.RaisedDate,'%d-%b-%Y')RaisedDate,PO.Type,Po.Status,  ");
        sqlCmd.Append(" (CASE WHEN Po.Status = 0 THEN 'Pending' WHEN Po.Status = 1 THEN 'Reject' WHEN Po.Status = 2 THEN 'Open' WHEN Po.Status = 3 THEN 'Close' END )StatusDisplay,(SELECT COUNT(*) FROM  f_stock s WHERE s.PONumber=PO.PurchaseOrderNo)IsStock, (CASE WHEN Po.Status = 0 THEN "+CanEditPO+" WHEN Po.Status = 1 THEN '0' WHEN Po.Status = 2 THEN '0' ");
        sqlCmd.Append(" WHEN Po.Status = 3 THEN '0' END ) CanEditPurchaseOrder  ");
        sqlCmd.Append(" FROM f_purchaseorder PO INNER JOIN f_purchaseorderdetails POD ON PO.PurchaseOrderNo=POD.PurchaseOrderNo  AND PO.DeptLedgerNo=@deptLedgerNo  AND po.`CentreID`=@centerId  ");
        sqlCmd.Append(" ");

        if (searchType)
            sqlCmd.Append("  ORDER BY po.`PurchaseOrderNo` DESC LIMIT 10  ");
        else
        {
            if (!string.IsNullOrEmpty(PONo))
                sqlCmd.Append("where  po.`PurchaseOrderNo`=@PONo ");
            else
                sqlCmd.Append("WHERE PO.RaisedDate >=@fromDate AND PO.RaisedDate <=@toDate ORDER BY po.`PurchaseOrderNo` DESC ");

        }

        DataTable dt = excuteCMD.GetDataTable(sqlCmd.ToString(), CommandType.Text, new
        {
            PONo = PONo,
            deptLedgerNo = deptLedgerNo,
            centerId = centerId,
            fromDate = Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + " 00:00:00",
            toDate = Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + " 23:59:59"
        });


        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }


    [WebMethod(EnableSession = true)]
    public string GetPurchaseRequests(string fromDate, string toDate,string storetype)
    {

        var centerID = HttpContext.Current.Session["CentreID"].ToString();
        var DeptLedgerno = HttpContext.Current.Session["DeptLedgerNo"].ToString();
        ExcuteCMD excuteCMD = new ExcuteCMD();
        string sqlCMD = "SELECT pm.PurchaseRequestNo, em.Name, pm.Subject, DATE_FORMAT(PM.RaisedDate, '%d-%b-%Y %h:%i %p') RaisedDate,COUNT(prd.itemID)Quantity, IFNULL(SUM(popr.OrderedQty),0)Orderqty,IFNULL(SUM(prd.ApprovedQty),0)Approvedqty, CONCAT(cm.CentreName,'(',IFNULL(lm.LedgerName, ''),')') DepartMentName FROM f_purchaserequestmaster pm INNER JOIN f_purchaserequestdetails prd ON prd.PurchaseRequisitionNo=pm.PurchaseRequestNo INNER JOIN employee_master em ON pm.RaisedByID = em.EmployeeID INNER JOIN  center_master cm ON cm.CentreID=pm.CentreID LEFT JOIN f_ledgermaster lm ON lm.LedgerNumber = pm.IssuedTo LEFT JOIN f_purchaseorderpurchaserequest popr ON popr.PRNumber=pm.PurchaseRequestNo AND popr.ITemID=prd.ItemID WHERE pm.Status=2  AND pm.Approved=2 AND pm.CentreID = @centerID AND pm.StoreID=@storetype AND pm.IssuedTo=@todeptledgerno AND pm.RaisedDate  >=@fromDate AND pm.RaisedDate <= @toDate GROUP BY pm.PurchaseRequestNo HAVING  Approvedqty>Orderqty "; //HAVING Orderqty =0 ";
        DataTable dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
        {
            fromDate = Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + " 00:00:00",
            toDate = Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + " 23:59:59",
            centerID = centerID,
            storetype = storetype,
	    todeptledgerno = DeptLedgerno
        });
        var s = excuteCMD.GetRowQuery(sqlCMD.ToString(), new
        {
            fromDate = Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + " 00:00:00",
            toDate = Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + " 23:59:59",
            centerID = centerID,
            storetype = storetype,
            todeptledgerno = DeptLedgerno
        });
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


    [WebMethod]
    public string GetPurchaseRequestItems(List<string> purchaseRequests, string departmentLedgerNo, string centreID)
    {



        StringBuilder sqlCmd = new StringBuilder();

        if (Resources.Resource.IsGSTApplicable == "0")
        {
            sqlCmd.Append("  SELECT ");
            sqlCmd.Append("  im.MajorUnit PUnit, ");
            sqlCmd.Append("  0 Stock, ");
            sqlCmd.Append(" prd.ItemID, ");
            sqlCmd.Append("  im.SubCategoryID, ");
            sqlCmd.Append(" IFNULL(im.ManufactureID,'')ManufactureID, ");
            sqlCmd.Append(" IFNULL(im.ManuFacturer,'')ManuFacturer, ");
            sqlCmd.Append("  '' HSNCode, ");
            sqlCmd.Append(" im.VatType, ");
            sqlCmd.Append("  im.TypeName  ItemName, ");
            sqlCmd.Append(" IFNULL(rt.Rate,'0')Rate, ");
            sqlCmd.Append(" rt.MRP, ");
            sqlCmd.Append(" IFNULL(rt.DiscountPercent,'')DiscountPercent, ");
            sqlCmd.Append(" IFNULL(rt.DiscountPercent,'') Discount, ");
            sqlCmd.Append(" rt.TaxCalulatedOn TaxOn, ");
            sqlCmd.Append(" rt.TaxCalulatedOn ,");
            sqlCmd.Append(" rt.Currency ,");
            sqlCmd.Append(" rt.Currency_Factor CurrencyFactor,");
            sqlCmd.Append(" rt.CurrencyCountryID ,");


            sqlCmd.Append(" 'No' TaxOn, ");
            sqlCmd.Append(" rt.TotalTaxPercent VAT, ");
            sqlCmd.Append(" IFNULL(rt.Vendor_ID,0) supplierID, ");
            sqlCmd.Append(" vm.LedgerName Supplier, ");
            sqlCmd.Append(" prd.ApprovedQty Quantity, ");
            sqlCmd.Append(" rt.TotalTaxPercent, ");
            sqlCmd.Append(" 0 IGSTPercent, ");
            sqlCmd.Append(" 0 IGSTAmt, ");
            sqlCmd.Append(" 0 CGSTPercent,");
            sqlCmd.Append(" 0 CGSTAmt, ");
            sqlCmd.Append(" 0 SGSTPercent, ");
            sqlCmd.Append(" 0 SGSTAmt, ");
            sqlCmd.Append(" 0 netAmountWithOutTax, ");
            sqlCmd.Append(" 0 TaxAmt, ");
            sqlCmd.Append(" 0 NetAmount, ");
            sqlCmd.Append(" prd.RequestedQty, ");
            sqlCmd.Append(" pr.PurchaseRequestNo as PurchaseRequestsNo, ");
            sqlCmd.Append(" IFNULL(prd.CentreID,'') CentreID, ");
            sqlCmd.Append(" 'No' Free,");
            sqlCmd.Append(" im.ConversionFactor ");

            sqlCmd.Append(" FROM f_purchaserequestmaster pr ");
            sqlCmd.Append(" INNER JOIN f_purchaserequestdetails prd ON pr.PurchaseRequestNo = prd.PurchaseRequisitionNo ");
            sqlCmd.Append(" INNER JOIN f_itemmaster im ON im.ItemID=prd.ItemID ");
            sqlCmd.Append(" LEFT JOIN f_storeitem_rate rt ON rt.ItemID=im.ItemID AND rt.IsActive=1 ");
            sqlCmd.Append(" LEFT JOIN f_ledgermaster vm ON vm.LedgerNumber=rt.Vendor_ID ");
           // sqlCmd.Append(" LEFT JOIN f_indent_detail ind ON prd.PurchaseRequisitionNo = ind.PRNO AND prd.ItemID = ind.ItemId  ");
            sqlCmd.Append(" LEFT JOIN f_purchaseorderpurchaserequest popr ON popr.PRNumber=prd.PurchaseRequisitionNo AND popr.ITemID=prd.ItemID ");
            sqlCmd.Append(" WHERE pr.PurchaseRequestNo IN ('" + string.Join("','", purchaseRequests) + "') AND popr.ITemID IS NULL ");
        }
        else if (Resources.Resource.IsGSTApplicable == "1")
        {
            sqlCmd.Append("  SELECT  ");
            sqlCmd.Append("  im.MajorUnit PUnit,  ");
            sqlCmd.Append("  0 Stock,  ");
            sqlCmd.Append(" prd.ItemID,  ");
            sqlCmd.Append("  im.SubCategoryID,  ");
            sqlCmd.Append(" IFNULL(im.ManufactureID,'')ManufactureID,  ");
            sqlCmd.Append(" IFNULL(im.ManuFacturer,'')ManuFacturer,  ");
            sqlCmd.Append("  im.HSNCode,  ");
            sqlCmd.Append(" im.VatType,  ");
            sqlCmd.Append("  im.TypeName  ItemName,  ");
            sqlCmd.Append(" IFNULL(if(ifnull(rt.Rate,'0')<>0,rt.Rate,(SELECT Rate FROM f_stock WHERE itemid=prd.ItemID AND ledgertransactionNo<>0 ORDER BY ID DESC LIMIT 1)),'0')Rate,  ");
            sqlCmd.Append(" IFNULL(if(ifnull(rt.MRP,'0')<>0,rt.MRP,(SELECT MRP FROM f_stock WHERE itemid=prd.ItemID AND ledgertransactionNo<>0 ORDER BY ID DESC LIMIT 1)),'0')MRP,  ");
            sqlCmd.Append(" IFNULL(rt.DiscountPercent,'0')DiscountPercent,  ");
            sqlCmd.Append(" IFNULL(rt.DiscountPercent,'0') Discount,  ");
            sqlCmd.Append(" IFNULL(rt.TaxCalulatedOn,'RateAD') TaxOn,  ");
            sqlCmd.Append(" IFNULL(rt.TaxCalulatedOn,'RateAD')TaxCalulatedOn , ");
            sqlCmd.Append(" IFNULL(rt.Currency,'INR')Currency , ");
            sqlCmd.Append(" IFNULL(rt.Currency_Factor,1.00) CurrencyFactor, ");
            sqlCmd.Append(" IFNULL(rt.CurrencyCountryID ,14)CurrencyCountryID , ");
            sqlCmd.Append(" ");
            sqlCmd.Append(" ");
            sqlCmd.Append(" 'No' TaxOn,  ");
            sqlCmd.Append(" IFNULL((rt.IGSTPercent+rt.CGSTPercent+rt.SGSTPercent),(im.IGSTPercent+im.CGSTPercent+im.SGSTPercent)) VAT,  ");
            sqlCmd.Append(" IFNULL(rt.Vendor_ID,0) supplierID,  ");
            sqlCmd.Append(" IFNULL(vm.LedgerName,'') Supplier,  ");
            sqlCmd.Append(" prd.ApprovedQty Quantity,  ");
            sqlCmd.Append(" IFNULL(rt.TotalTaxPercent,(im.IGSTPercent+im.CGSTPercent+im.SGSTPercent))TotalTaxPercent,  ");
            sqlCmd.Append(" IFNULL(rt.IGSTPercent ,im.IGSTPercent)AS IGST,  ");
            sqlCmd.Append(" IF(IFNULL(rt.GSTType,im.GSTType)='IGST',IFNULL((((ApprovedQty*Rate)*IFNULL(rt.IGSTPercent,im.IGSTPercent))/100),0),'0')'IGSTAmt',  ");
            sqlCmd.Append(" IFNULL(rt.CGSTPercent ,im.CGSTPercent) AS CGST, ");
            sqlCmd.Append("  IF(IFNULL(rt.GSTType,im.GSTType)='CGST&UTGST' ||IFNULL(rt.GSTType,im.GSTType)='CGST&SGST',IFNULL((((ApprovedQty*Rate)* IFNULL(rt.CGSTPercent ,im.CGSTPercent))/100),0),0)'CGSTAmt',  ");
            sqlCmd.Append("  ");
            sqlCmd.Append("IFNULL(rt.SGSTPercent ,im.SGSTPercent) AS 'SGST',  ");
            sqlCmd.Append(" IF(IFNULL(rt.GSTType,im.GSTType)='CGST&UTGST' || IFNULL(rt.GSTType,im.GSTType)='CGST&SGST',IFNULL((((ApprovedQty*Rate)*IFNULL(rt.SGSTPercent ,im.SGSTPercent))/100),0),0)'SGSTAmt',  ");
            sqlCmd.Append(" 0 netAmountWithOutTax,  ");
            sqlCmd.Append(" 0 TaxAmt,  ");
            sqlCmd.Append(" 0 NetAmount,  ");
            sqlCmd.Append(" prd.RequestedQty,  ");
            sqlCmd.Append(" pr.PurchaseRequestNo AS PurchaseRequestsNo,  ");
            sqlCmd.Append(" IFNULL(prd.CentreID,'') CentreID,  ");
            sqlCmd.Append(" 'No' Free, ");
            sqlCmd.Append(" im.ConversionFactor  ");
            sqlCmd.Append(" ,IFNULL(rt.IGSTPercent ,im.IGSTPercent)IGSTPercent, IFNULL(rt.CGSTPercent ,im.CGSTPercent)CGSTPercent, IFNULL(rt.SGSTPercent ,im.SGSTPercent)SGSTPercent, IFNULL(rt.GSTType,im.GSTType)GSTType, IFNULL(rt.GSTType,im.GSTType)AS GSTGroup  ");

            sqlCmd.Append(" FROM f_purchaserequestmaster pr ");
            sqlCmd.Append(" INNER JOIN f_purchaserequestdetails prd ON pr.PurchaseRequestNo = prd.PurchaseRequisitionNo ");
            sqlCmd.Append(" INNER JOIN f_itemmaster im ON im.ItemID=prd.ItemID ");
            sqlCmd.Append(" LEFT JOIN f_storeitem_rate rt ON rt.ItemID=im.ItemID AND rt.IsActive=1 ");
            sqlCmd.Append(" LEFT JOIN f_ledgermaster vm ON vm.LedgerNumber=rt.Vendor_ID ");
            //sqlCmd.Append(" LEFT JOIN f_indent_detail ind ON prd.PurchaseRequisitionNo = ind.PRNO AND prd.ItemID = ind.ItemId  ");
            sqlCmd.Append(" LEFT JOIN f_purchaseorderpurchaserequest popr ON popr.PRNumber=prd.PurchaseRequisitionNo AND popr.ITemID=prd.ItemID ");
            sqlCmd.Append(" WHERE pr.PurchaseRequestNo IN ('" + string.Join("','", purchaseRequests) + "') AND popr.ITemID IS NULL ");
        }



        //StringBuilder sqlCmd = new StringBuilder();
        //sqlCmd.Append(" SELECT t.ItemName,t.ItemID,t.Rate,t.MRP,t.Discount,t.Deal,t.GSTGroup,t.TaxOn,t.PUnit,t.Stock,t.Free,t.HSNCode,t.Supplier,t.supplierID,(r.ApprovedQty) 'Quantity', (r.PurchaseRequestNo) PurchaseRequestsNo,IFNULL (r.CentreID,'') CentreID FROM ( ");
        //sqlCmd.Append(" SELECT  im.`TypeName` 'ItemName',im.`ItemID` 'ItemID',0 'Rate',0 'MRP', 0 'Discount',  '' Deal, IFNULL((SELECT s.`TaxGroup` FROM store_taxgroup_category s WHERE s.`id`=im.`TaxGroupId` AND s.`IsActive`=1),'GST5%')'GSTGroup', 'RateAD' TaxOn ,IFNULL(imdp.`majorUnit`,im.`MajorUnit`)'PUnit',");
        //sqlCmd.Append(" IFNULL((SELECT SUM(st.InitialCount)-SUM(st.ReleasedCount)  FROM f_stock st  WHERE st.DeptLedgerNo=@departmentLedgerNo AND st.CentreID=@centreID ");
        //sqlCmd.Append(" AND st.ItemID=im.ItemID AND st.IsPost=1 AND IF(st.IsExpirable=0,1=1,st.`MedExpiryDate`>CURDATE()) ),0) 'Stock','No' AS 'Free',IFNULL(im.`HSNCode`,'')'HSNCode', ");
        //sqlCmd.Append(" '' Supplier,imdp.`ReorderLevel`,imdp.`MaxLevel`,0 supplierID ");
        //sqlCmd.Append(" FROM f_itemmaster im   ");
        //sqlCmd.Append(" left JOIN  `f_itemmaster_deptwise` imdp   ON im.`ItemID`=imdp.`ItemID` AND  imdp.`CentreID`=@centreID AND imdp.`DeptLedgerNo`=@departmentLedgerNo AND im.`IsActive`=1 AND imdp.`IsActive`=1 ");
        //sqlCmd.Append(" )t ");

        //sqlCmd.Append(" INNER JOIN ");
        //sqlCmd.Append(" ( SELECT prd.ItemID,prd.RequestedQty,pr.PurchaseRequestNo,ind.CentreID,prd.ApprovedQty  FROM  f_purchaserequestmaster pr ");
        //sqlCmd.Append(" INNER JOIN  f_purchaserequestdetails prd ON pr.PurchaseRequestNo=prd.PurchaseRequisitionNo   LEFT JOIN f_indent_detail ind ON prd.PurchaseRequisitionNo = ind.PRNO AND prd.ItemID=ind.ItemId WHERE pr.PurchaseRequestNo  ");
        //sqlCmd.Append(" IN ('" + string.Join("','", purchaseRequests) + "')) r ");

        //sqlCmd.Append(" ON t.ItemID=r.ItemID");


        ExcuteCMD excuteCMD = new ExcuteCMD();
        var obj = new
        {
            departmentLedgerNo = departmentLedgerNo,
            centreID = centreID,
        };

        DataTable dt = excuteCMD.GetDataTable(sqlCmd.ToString(), CommandType.Text, obj);
        var s = excuteCMD.GetRowQuery(sqlCmd.ToString(), obj);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);



    }


    [WebMethod]
    public string GetPurchaseRequestItemDetails(string purchaseRequestNo)
    {
        ExcuteCMD excuteCMD = new ExcuteCMD();
       // string sqlCMD = "SELECT f.ItemName,f.RequestedQty,f.ApprovedQty,f.Unit,f.Purpose FROM f_purchaserequestdetails f WHERE  F.PurchaseRequisitionNo=@purchaseRequestNo";
        string sqlCMD = "SELECT f.ItemName,f.RequestedQty,f.ApprovedQty,f.Unit,f.Purpose,popr.PONumber FROM f_purchaserequestdetails f LEFT JOIN f_purchaseorderpurchaserequest popr ON popr.PRNumber=f.PurchaseRequisitionNo AND popr.ITemID=f.ItemID    WHERE  F.PurchaseRequisitionNo=@purchaseRequestNo";

        DataTable dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
        {
            purchaseRequestNo = purchaseRequestNo
        });
        var s = excuteCMD.GetRowQuery(sqlCMD.ToString(), new
        {
            purchaseRequestNo = purchaseRequestNo
        });
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


    [WebMethod]
    public string GetPurchaseOrderItemDetails(string purchaseOrderNo, string centreID, string departmentLedgerNo)
    {

        StringBuilder sqlCMD = new StringBuilder();

        sqlCMD.Append(" SELECT im.TypeName ItemName, ");
        sqlCMD.Append(" pod.PurchaseOrderDetailID ID, ");
        sqlCMD.Append(" im.ItemID, ");
        sqlCMD.Append(" ROUND(pod.Rate/IFNULL(po.C_Factor,1),4)Rate, ");
        sqlCMD.Append(" ROUND(pod.MRP/IFNULL(po.C_Factor,1),4)MRP, ");
        sqlCMD.Append(" pod.Discount_p Discount, ");
        sqlCMD.Append(" pod.IsDeal Deal, ");
        sqlCMD.Append(" pod.GSTType GSTGroup, ");
        sqlCMD.Append(" pod.TaxCalulatedOn TaxOn, ");
        sqlCMD.Append(" pod.Unit PUnit, ");
        sqlCMD.Append(" IFNULL((SELECT SUM(st.InitialCount)-SUM(st.ReleasedCount)  FROM f_stock st  WHERE st.DeptLedgerNo=@departmentLedgerNo AND st.CentreID=@centreID  AND st.ItemID=im.ItemID AND st.IsPost=1 AND st.MedExpiryDate>CURDATE() ),0) 'Stock', ");
        sqlCMD.Append(" IF(pod.IsFree=0,'No','Yes') Free, ");
        sqlCMD.Append(" pod.HSNCode, ");
        sqlCMD.Append(" pod.SubCategoryID, ");
        sqlCMD.Append(" po.VendorName Supplier, ");
        sqlCMD.Append(" po.VendorID supplierID ,");
        sqlCMD.Append(" pod.ApprovedQty  Quantity,");
        sqlCMD.Append(" pod.S_Currency  Currency,");
        sqlCMD.Append(" pod.C_Factor  CurrencyFactor,");
        sqlCMD.Append(" pod.S_CountryID  CurrencyCountryID,");
        sqlCMD.Append(" IFNULL(po.AmountAdvance,0)/IFNULL(po.C_Factor,1) AdvanceAmount, ");




        sqlCMD.Append(" pod.IGSTPercent,ROUND(pod.IGSTAmt/IFNULL(po.C_Factor,1),4)IGSTAmt,pod.CGSTPercent,ROUND(pod.CGSTAmt/IFNULL(po.C_Factor,1),4)CGSTAmt,pod.SGSTPercent,pod.SGSTAmt/IFNULL(po.C_Factor,1)SGSTAmt,ROUND(pod.Amount/IFNULL(po.C_Factor,1),4) NetAmount, ");
        sqlCMD.Append(" po.NetTotal NetTotal,po.Roundoff Roundoff,po.Remarks,po.VendorID,ROUND((pod.Rate*pod.OrderedQty)*IFNULL(po.C_Factor,1),4) netAmountWithOutTax,pod.VATPer VAT,ROUND(pod.VATAmt/IFNULL(po.C_Factor,1),4) TaxAmt,im.ManufactureID,im.ManuFacturer,im.VatType,po.S_CountryID,po.OtherCharges/IFNULL(po.C_Factor,1)OtherCharges ");
        sqlCMD.Append(" ,IFNULL(po.C_Factor,1)C_Factor,po.S_CountryID,(SELECT COUNT(*) FROM  f_purchaseorderpurchaserequest p WHERE p.PONumber=@purchaseOrderNo) isPOByPR FROM f_purchaseorder po ");
        sqlCMD.Append(" INNER JOIN f_purchaseorderdetails  pod ON po.PurchaseOrderNo=pod.PurchaseOrderNo ");
        sqlCMD.Append(" INNER JOIN f_itemmaster im ON im.ItemID=pod.ItemID ");
        sqlCMD.Append(" LEFT JOIN f_purchaseorderpurchaserequest popr ON popr.PODetailID=pod.PurchaseOrderDetailID ");
        sqlCMD.Append(" WHERE pod.IsActive=1 and po.PurchaseOrderNo=@purchaseOrderNo ");
        ExcuteCMD excuteCMD = new ExcuteCMD();
        string s = excuteCMD.GetRowQuery(sqlCMD.ToString(), new
        {
            departmentLedgerNo = departmentLedgerNo,
            purchaseOrderNo = purchaseOrderNo,
            centreID = centreID
        });



        DataTable dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
        {
            departmentLedgerNo = departmentLedgerNo,
            purchaseOrderNo = purchaseOrderNo,
            centreID = centreID
        });

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public string GetPurchaseOrderItemDetailsTerms(string purchaseOrderNo)
    {
        DataTable dt = new DataTable();
        StringBuilder sqlCMD = new StringBuilder();
        sqlCMD.Append(" SELECT * FROM f_purchaseorderterms  WHERE PONumber='" + purchaseOrderNo + "' and isactive=1 ");
        dt = StockReports.GetDataTable(sqlCMD.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public string GetBestLastVendor(List<string> itemIDs, int vendorType)
    {

        StringBuilder sqlCMD = new StringBuilder();
        if (vendorType == 0)
        {
            sqlCMD.Append("SELECT * FROM (SELECT st.Rate,lm.LedgerName VendorName ,lm.LedgerNumber VendorID,st.ItemID,st.ItemName,st.StockDate  FROM f_stock st INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=st.LedgerTransactionNo INNER JOIN f_ledgermaster lm ON st.VenLedgerNo=lm.LedgerNumber  AND lm.GroupID='VEN' WHERE lt.TypeOfTnx='PURCHASE' AND st.IsPost IN(0,1) AND st.ItemID  IN ('" + string.Join("','", itemIDs) + "') ORDER BY  st.id DESC) t  GROUP BY t.ItemID  ");
        }
        else
        {
            sqlCMD.Append("SELECT * FROM (SELECT st.Rate,lm.LedgerName VendorName ,lm.LedgerNumber VendorID,st.ItemID,st.ItemName,st.StockDate  FROM f_stock st INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=st.LedgerTransactionNo INNER JOIN f_ledgermaster lm ON st.VenLedgerNo=lm.LedgerNumber  AND lm.GroupID='VEN' WHERE lt.TypeOfTnx='PURCHASE' AND st.IsPost IN(0,1) AND st.ItemID  IN ('" + string.Join("','", itemIDs) + "') ORDER BY  st.unitPrice ASC) t  GROUP BY t.ItemID  ");
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sqlCMD.ToString()));

    }

    [WebMethod]
    public string getPurchaseHistory(string ItemId)
    {
        StringBuilder sqlCMD = new StringBuilder();
        sqlCMD.Append(" SELECT lm.`LedgerName`'Supplier',lt.`BillNo` 'GRNNo',DATE_FORMAT(lt.`Date`,'%d-%b-%Y')'GRNDate',st.`Rate`,st.`DiscPer`,st.`MajorMRP` 'MRP',st.`isDeal`,st.`taxCalculateon` 'TaxOn',st.`GSTType`,im.`TypeName` 'ItemName',im.`MajorUnit` 'PUnit',lm.`LedgerNumber` 'VendorId' FROM `f_ledgertransaction` lt  ");
        sqlCMD.Append(" INNER JOIN f_stock st ON st.`LedgerTransactionNo`=lt.`LedgerTransactionNo` AND lt.`BillNo`<>'' AND lt.`TypeOfTnx` IN ('PURCHASE','NMPURCHASE') ");
        sqlCMD.Append(" INNER JOIN f_itemmaster im ON im.`ItemID`=st.`ItemID` AND im.`ItemID`=@itemId ");
        sqlCMD.Append(" INNER JOIN `f_ledgermaster` lm  ON lm.`LedgerNumber`=lt.`LedgerNoCr` AND lm.`GroupID`='VEN' ORDER BY lt.`ID` DESC ");
        ExcuteCMD cmd = new ExcuteCMD();
        DataTable dt = cmd.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
        {
            itemId = ItemId
        });
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";

    }





    [WebMethod]
    public string GetMedicineGroup()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT si.ID,si.ItemGroup FROM store_itemsgroup si WHERE si.IsActive=1"));
    }
    [WebMethod]
    public string GetCategorys()
    {
        System.Data.DataView dv = LoadCacheQuery.loadCategory().DefaultView;
        dv.RowFilter = "ConfigID IN (28,11)";
        DataTable cat = dv.ToTable();
        return Newtonsoft.Json.JsonConvert.SerializeObject(cat);

    }

    [WebMethod]
    public string GetSubCategoryByCategory(string categoryID)
    {
        var subCategorys = CreateStockMaster.LoadSubCategoryByCategory(categoryID);
        return Newtonsoft.Json.JsonConvert.SerializeObject(subCategorys);
    }

    public class PODraftItemDetail
    {
        public string ID { get; set; }
        public string DraftID { get; set; }
        public string PUnit { get; set; }
        public string Stock { get; set; }
        public string ItemName { get; set; }
        public string Deal { get; set; }
        public string Rate { get; set; }
        public string Discount { get; set; }
        public string GSTGroup { get; set; }
        public string MRP { get; set; }
        public string Quantity { get; set; }
        public string TaxOn { get; set; }
        public string IGSTPercent { get; set; }
        public string IGSTAmt { get; set; }
        public string CGSTPercent { get; set; }
        public string CGSTAmt { get; set; }
        public string SGSTPercent { get; set; }
        public string SGSTAmt { get; set; }
        public string TaxAmt { get; set; }
        public string Supplier { get; set; }
        public string supplierID { get; set; }
        public string NetAmount { get; set; }
        public string ItemID { get; set; }
        public string Free { get; set; }
        public string HSNCode { get; set; }
        public string TaxCalulatedOn { get; set; }
    }

    [WebMethod(EnableSession = true)]
    public string SaveDraftDetails(string draftName)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            StringBuilder sqlCmd = new StringBuilder();
            sqlCmd.Append("Insert Into store_purchaseOrder_draft (DraftName,CreatedBy) values ('" + draftName + "','" + HttpContext.Current.Session["ID"].ToString() + "')");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, Util.GetString(sqlCmd));
            tnx.Commit();

            string DraftID = Util.GetString(StockReports.ExecuteScalar("SELECT MAX(ID) FROM store_purchaseOrder_draft"));
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, draftID = DraftID });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = AllGlobalFunction.errorMessage, response = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }


    [WebMethod(EnableSession = true)]
    public string SavePODraftDetails(object draftItems, string draftID)
    {
        List<PODraftItemDetail> POItemsDetails = new JavaScriptSerializer().ConvertToType<List<PODraftItemDetail>>(draftItems);
        POItemsDetails = POItemsDetails.Where(i => !string.IsNullOrEmpty(i.ItemID)).ToList();

        if (POItemsDetails.Count < 1)
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Please Select Items." });

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            for (int i = 0; i < POItemsDetails.Count; i++)
            {

                var item = POItemsDetails[i];
                StringBuilder sqlCmd = new StringBuilder();

                sqlCmd.Append("insert into store_purchaseOrder_draftDetails (DraftID,ItemID,ItemName,PUnit,Stock,Deal,Rate,Discount,GSTGroup,");
                sqlCmd.Append(" MRP,Quantity,TaxOn,IGSTPercent,IGSTAmt,CGSTPercent,CGSTAmt,SGSTPercent,SGSTAmt,TaxAmt,Supplier,");
                sqlCmd.Append(" supplierID,NetAmount,Free,HSNCode,TaxCalulatedOn) values");
                sqlCmd.Append(" (" + draftID + ",'" + item.ItemID + "','" + item.ItemName + "','" + item.PUnit + "'," + item.Stock + ",'" + item.Deal + "'," + item.Rate + "," + item.Discount + ",'" + item.GSTGroup + "',");
                sqlCmd.Append(" " + item.MRP + "," + item.Quantity + ",'" + item.TaxOn + "'," + item.IGSTPercent + "," + item.IGSTAmt + "," + item.CGSTPercent + "," + item.CGSTAmt + ",");
                sqlCmd.Append(" " + item.SGSTPercent + "," + item.SGSTAmt + "," + item.TaxAmt + ",'" + item.Supplier + "','" + item.supplierID + "',");
                sqlCmd.Append(" " + item.NetAmount + ",'" + item.Free + "','" + item.HSNCode + "','" + item.TaxCalulatedOn + "')");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, Util.GetString(sqlCmd));
            }
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = AllGlobalFunction.errorMessage, response = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public string ReturnPODraftDetails()
    {
        StringBuilder sqlCmd = new StringBuilder();

        sqlCmd.Append("SELECT em.`Name` EntryBy ,sb.`ID`,sb.`DraftName`,DATE_FORMAT(sb.`EntryDate`,'%d-%b-%Y')EntryDate");
        sqlCmd.Append(" FROM store_purchaseOrder_draft sb INNER JOIN `employee_master` em ON em.`EmployeeID`=sb.`CreatedBy`WHERE sb.`IsActive`=1");

        DataTable dtab = StockReports.GetDataTable(Util.GetString(sqlCmd));

        if (dtab == null || dtab.Rows.Count < 1)
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "No Draft Found." });

        return Newtonsoft.Json.JsonConvert.SerializeObject(dtab);

    }

    [WebMethod(EnableSession = true)]
    public string getDraftDetails(string DraftID)
    {
        StringBuilder sqlCmd = new StringBuilder();
        sqlCmd.Append("SELECT pod.`ItemID`,pod.`ItemName`,pod.`PUnit`,pod.`Stock`,pod.`Deal`,pod.`Rate`,pod.`Discount`,pod.`GSTGroup`,pod.`MRP`,pod.`Quantity`, ");
        sqlCmd.Append("pod.`TaxOn`,pod.`IGSTPercent`,pod.`IGSTAmt`,pod.`CGSTPercent`,pod.`CGSTAmt`,pod.`SGSTPercent`,pod.`SGSTAmt`,pod.`TaxAmt`,pod.`Supplier`, ");
        sqlCmd.Append("pod.`supplierID`,pod.`NetAmount`,pod.`Free`,pod.`HSNCode`,pod.`TaxCalulatedOn` ");
        sqlCmd.Append("FROM store_purchaseOrder_draftDetails pod INNER JOIN store_purchaseOrder_draft sd ");
        sqlCmd.Append("ON pod.`DraftID`=sd.`ID` WHERE sd.`ID` = " + DraftID + "");

        DataTable dtab = StockReports.GetDataTable(Util.GetString(sqlCmd));
        if (dtab == null || dtab.Rows.Count < 1)
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "No Draft Found." });

        return Newtonsoft.Json.JsonConvert.SerializeObject(dtab);
    }

    [WebMethod(EnableSession = true)]
    public string getCurrencyFactor(string CountryID)
    {
        DataTable dtDetail = All_LoadData.LoadCurrencyFactor("");
        DataRow[] dr;
        if (CountryID == "")
            dr = dtDetail.Select("IsBaseCurrency=1");
        else
            dr = dtDetail.Select("CountryID='" + CountryID + "'");
        var Selling_Specific = dr[0]["Selling_Specific"].ToString();
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { Selling_Specific = Selling_Specific });
    }


    public class BudgetDetail
    {
        public string itemID { get; set; }
        public decimal amount { get; set; }
    }



    [WebMethod(EnableSession = true)]
    public string GetItemBudget(List<BudgetDetail> budgetDetails)
    {
        var centerID = HttpContext.Current.Session["CentreID"].ToString();
        for (int i = 0; i < budgetDetails.Count; i++)
        {
          //  var amount = EbizFrame.GetItemBudget(centerID, budgetDetails[i].itemID);
            var amount = 1000000000;
            budgetDetails[i].amount = amount;
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(budgetDetails);

    }


    [WebMethod]
    public string GetTermAndConditions()
    {

        var dataTable = StockReports.GetDataTable("SELECT t.Id,t.Terms FROM f_term_condition t WHERE t.Active=1");

        return Newtonsoft.Json.JsonConvert.SerializeObject(dataTable);

    }

    [WebMethod]
    public string CalculateTaxAmount(TaxCalculationOn taxCalculationOn, int taxGroupID)
    {

        ExcuteCMD excuteCMD = new ExcuteCMD();
        DataTable dt = excuteCMD.GetDataTable("SELECT cc.id,cc.TaxGroup,cc.CGSTPer,cc.SGSTPer,cc.IGSTPer FROM store_taxgroup_category cc WHERE cc.id=@id AND cc.IsActive=1", CommandType.Text, new
        {
            id = taxGroupID
        });
        if (dt.Rows.Count > 0)
        {
            taxCalculationOn.IGSTPrecent = Util.GetDecimal(dt.Rows[0]["IGSTPer"]);
            taxCalculationOn.CGSTPercent = Util.GetDecimal(dt.Rows[0]["CGSTPer"]);
            taxCalculationOn.SGSTPercent = Util.GetDecimal(dt.Rows[0]["SGSTPer"]);
        }
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Not A Valid Tax Group." });



        TaxCalculationDetails taxCalculationDetails = AllLoadData_Store.CalculateTax(taxCalculationOn);
        taxCalculationDetails.IGSTPrecent = taxCalculationOn.IGSTPrecent;
        taxCalculationDetails.CGSTPercent = taxCalculationOn.CGSTPercent;
        taxCalculationDetails.SGSTPercent = taxCalculationOn.SGSTPercent;

        taxCalculationDetails.taxAmount = Math.Round(taxCalculationDetails.sgstTaxAmount + taxCalculationDetails.igstTaxAmount + taxCalculationDetails.cgstTaxAmount, 2);


        return Newtonsoft.Json.JsonConvert.SerializeObject(taxCalculationDetails);
    }

}