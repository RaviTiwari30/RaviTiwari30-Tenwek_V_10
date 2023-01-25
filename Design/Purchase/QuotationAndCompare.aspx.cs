using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Purchase_QuotationAndCompare : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            txtFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
        calEntryDate1.EndDate = DateTime.Now;
        calEntryDate2.StartDate = DateTime.Now;
    }

    public class Quotation
    {
        public string ItemId { get; set; }
        public string fromDate { get; set; }
        public string toDate { get; set; }
        public string subcategoryID { get; set; }
        public string vendorID { get; set; }
        public string vendorName { get; set; }
        public string ItemName { get; set; }
        public decimal rate { get; set; }
        public int taxGroupID { get; set; }
        public string taxGroupName { get; set; }
        public decimal discountPercent { get; set; }
        public decimal discountAmount { get; set; }
        public int deal1 { get; set; }
        public int deal2 { get; set; }
        public string taxCalculatedOn { get; set; }
        public int IsActive { get; set; }
        public decimal MRP { get; set; }
        public string HSNCode { get; set; }
        public string remarks { get; set; }
        public string manufacturerID { get; set; }
        public string manufacturer { get; set; }
        public string categoryID { get; set; }
        public decimal unitPrice { get; set; }
        public string GSTType { get; set; }
        public decimal IGSTPercent { get; set; }
        public decimal CGSTPercent { get; set; }
        public decimal SGSTPercent { get; set; }
        public decimal taxAmount { get; set; }
        public decimal profit { get; set; }
        public decimal netAmount { get; set; }
        public decimal grossAmount { get; set; }
        public decimal totalTaxPercent { get; set; }
        public string userID { get; set; }
        public string userName { get; set; }
        public string storeType { get; set; }
        public string departmentLedgerNo { get; set; }
        public string IPAddress { get; set; }
        public string centreID { get; set; }
        public string deals { get; set; }
        public string hospitalID { get; set; }
        public string unit { get; set; }
        public decimal minimum_Tolerance_Qty { get; set; }
        public decimal maximum_Tolerance_Qty { get; set; }
        public decimal minimum_Tolerance_Rate { get; set; }
        public decimal maximum_Tolerance_Rate { get; set; }
        public string currencyNotation { get; set; }
        public decimal currencyFactor { get; set; }
        public decimal currencyCountryID { get; set; }

    }

    //[WebMethod(EnableSession = true)]
    //public static string GetVendors()
    //{
    //    DataTable dtVendor = AllLoadData_Store.bindVendor();
    //    return Newtonsoft.Json.JsonConvert.SerializeObject(dtVendor);
    //}


    [WebMethod(EnableSession = true)]
    public static string GetSubCategories(string categoryID)
    {
        DataView dv = LoadCacheQuery.loadSubCategory().DefaultView;
        dv.RowFilter = "categoryid='" + categoryID.ToString() + "'";
        return Newtonsoft.Json.JsonConvert.SerializeObject(dv.ToTable());
    }





    [WebMethod(EnableSession = true)]
    public static string GetCategories()
    {
        string RoleId = HttpContext.Current.Session["RoleID"].ToString();
        string str = "SELECT IsGeneral,IsMedical FROM f_rolemaster WHERE id='" + RoleId + "' and active=1 and IsStore=1 ";
        //string str = "SELECT IsGeneral,IsMedical FROM f_rolemaster WHERE  active=1 and IsStore=1 ";
        DataTable dt = StockReports.GetDataTable(str.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            DataView dv = LoadCacheQuery.loadCategory().DefaultView;
            if (dt.Rows[0]["IsMedical"].ToString() == "1" && dt.Rows[0]["IsGeneral"].ToString() == "1")
                dv.RowFilter = "ConfigID IN (11,28)";
            else if (dt.Rows[0]["IsMedical"].ToString() == "1" || dt.Rows[0]["IsGeneral"].ToString() == "1")
            {
                if (dt.Rows[0]["IsMedical"].ToString() == "1")
                    dv.RowFilter = "ConfigID=11";
                else if (dt.Rows[0]["IsGeneral"].ToString() == "1")
                    dv.RowFilter = "ConfigID=28";
            }
            else if (dt.Rows[0]["IsMedical"].ToString() == "0" && dt.Rows[0]["IsGeneral"].ToString() == "0")
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "You do not have rights to Create Items." });

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, dt = dv.ToTable() });
        }
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "You do not have rights to Create Items." });

    }





    [WebMethod]
    public static string GetManufacturers()
    {
        string sqlCmd = "select Name,ManufactureID from f_manufacture_master where IsActive = 1 order by Name";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sqlCmd);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }



    [WebMethod(EnableSession = true)]
    public static string GetItems(string categoryID, string subCategoryID, string prefix)
    {
        StringBuilder sb = new StringBuilder();
        var departmentLedgerNo = HttpContext.Current.Session["DeptLedgerNo"].ToString();
        var centreID = HttpContext.Current.Session["CentreID"].ToString();

       // string str = "select TypeName ,im.ItemId ItemId,IF(IFNULL(idp.majorUnit,'')='',im.majorUnit,idp.majorUnit)majorUnit,im.GSTType 'VatType',im.SubCategoryID from f_itemmaster im INNER JOIN `f_itemmaster_centerwise` itc ON itc.`ItemID`=im.`ItemID`  LEFT JOIN f_itemmaster_deptwise idp ON idp.ItemID=im.ItemID  AND idp.DeptLedgerNo='" + departmentLedgerNo + "' AND idp.CentreID= " + centreID + "  INNER JOIN f_subcategorymaster SM ON IM.SubCategoryID = SM.SubCategoryID INNER JOIN f_configrelation CR ON SM.CategoryID = CR.CategoryID WHERE CR.ConfigID IN (11,28) AND im.IsActive=1 AND itc.`IsActive`=1 AND itc.CentreID=" + centreID + "  ";
        sb.Append(" select TypeName ,im.ItemId ItemId,IF(IFNULL(idp.majorUnit,'')='',im.majorUnit,idp.majorUnit)majorUnit, ");
        if (Resources.Resource.IsGSTApplicable == "1")
        {
            sb.Append(" im.GSTType 'VatType', ");
        }
        else
        {
            sb.Append(" im.VatType, ");
        }
        sb.Append(" im.SubCategoryID, im.ManuFacturer from f_itemmaster im INNER JOIN `f_itemmaster_centerwise` itc ON itc.`ItemID`=im.`ItemID`  LEFT JOIN f_itemmaster_deptwise idp ON idp.ItemID=im.ItemID  AND idp.DeptLedgerNo='" + departmentLedgerNo + "' AND idp.CentreID= " + centreID + "  INNER JOIN f_subcategorymaster SM ON IM.SubCategoryID = SM.SubCategoryID INNER JOIN f_configrelation CR ON SM.CategoryID = CR.CategoryID WHERE CR.ConfigID IN (11,28) AND im.IsActive=1 AND itc.`IsActive`=1 AND itc.CentreID=" + centreID + " ");

        if (subCategoryID != "0" && subCategoryID != "All")
        {
           // str = str + " AND IM.subcategoryid='" + subCategoryID.ToString() + "' ";
            sb.Append(" AND IM.subcategoryid='" + subCategoryID.ToString() + "' ");
        }
        if (categoryID != "0")
        {
           // str = str + " AND SM.CategoryID='" + categoryID.ToString() + "' ";
            sb.Append(" AND SM.CategoryID='" + categoryID.ToString() + "' ");
        }

        //str = str + "   order by typename ";
        sb.Append(" order by typename ");
        DataTable dtItem = StockReports.GetDataTable(sb.ToString());

        var dt = dtItem;
        DataView DvInvestigation = dt.AsDataView();
        string filter = string.Empty;
        if (!string.IsNullOrEmpty(prefix))
        {
            filter = "Typename LIKE '%" + prefix + "%'";
            DvInvestigation.RowFilter = filter;
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(DvInvestigation.ToTable());

    }







    [WebMethod]
    public static string addItems(Quotation quotation)
    {

        var departmentLedgerNo = HttpContext.Current.Session["DeptLedgerNo"].ToString();
        var centreID = HttpContext.Current.Session["CentreID"].ToString();
        //StringBuilder sb = new StringBuilder();
        //sb.Append(" SELECT lm.LedgerName VendorName,lm.LedgerNumber VendorID,sir.ItemID,sir.ID,im.`TypeName` AS ItemName,IF(sir.IsActive=1,'True','False')IsActive, ");
        //sb.Append(" sir.`GrossAmt`AS Rate,sir.`DiscAmt`,sir.`NetAmt`,DATE_FORMAT(sir.`FromDate`, '%d-%b-%Y')FromDate,DATE_FORMAT(sir.`ToDate`,'%d-%b-%Y')ToDate,");
        //sb.Append(" sir.`TaxAmt`,DATE_FORMAT( sir.`EntryDate`,'%d-%b-%Y')EntryDate,sir.UserName, fmm.name,sir.Manufacturer_ID, ");
        //// GST Changes
        //sb.Append("  IFNULL(sir.GSTType,'')GSTType,IFNULL(sir.HSNCode,'')HSNCode,sir.IGSTPercent,sir.CGSTPercent,sir.SGSTPercent,sir.minimum_Tolerance_Qty,sir.maximum_Tolerance_Qty,sir.Minimum_Tolerance_Rate,sir.Maximum_Tolerance_Rate,IFNULL(im.`MajorUnit`,'') 'unit' ");
        //sb.Append(" FROM f_storeitem_rate sir INNER JOIN f_itemmaster im  ON im.ItemID=sir.ItemID INNER JOIN f_manufacture_master fmm  ON sir.Manufacturer_ID=fmm.ManufactureID  INNER JOIN f_ledgermaster lm ON lm.LedgerNumber=sir.Vendor_ID ");
        //sb.Append(" WHERE  sir.`ItemID`=@itemID AND DATE(ToDate)>= CURRENT_DATE AND DeptLedgerNo =@departmentLedgerNo AND sir.CentreID=@centreID ");
        //ExcuteCMD excuteCMD = new ExcuteCMD();
        //DataTable dtItemRate = excuteCMD.GetDataTable(sb.ToString(), CommandType.Text, new
        //{
        //    itemID = quotation.ItemId,
        //    departmentLedgerNo = departmentLedgerNo,
        //    centreID = centreID
        //});


        //if (dtItemRate.Rows.Count > 0)
        //{
        //    for (int i = 0; i < dtItemRate.Rows.Count; i++)
        //    {
        //        //string status = dtItemRate.Rows[i]["IsActive"].ToString();
        //        //if (status == "True")
        //        //{
        //        //    DateTime toDate = Util.GetDateTime(dtItemRate.Rows[i]["ToDate"].ToString());
        //        //    DateTime entDate = Util.GetDateTime(quotation.fromDate);
        //        //    string OldVendorID = Util.GetString(dtItemRate.Rows[i]["VendorID"].ToString());
        //        //    string ddlVendorID = Util.GetString(quotation.vendorID);
        //        //    string ManufacturerID_Old = Util.GetString(dtItemRate.Rows[i]["Manufacturer_ID"].ToString());
        //        //    string ddlManufacturerID = Util.GetString(quotation.manufacturerID);
        //        //    if (OldVendorID == ddlVendorID && ManufacturerID_Old == ddlManufacturerID)
        //        //        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Vendor is Already Active for this Item" });
        //        //}
        //        //else
        //        //    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Vendor is Already Added for this item" });
        //    }
        //}

        //DataTable dt = excuteCMD.GetDataTable("SELECT cc.id,cc.TaxGroup,cc.CGSTPer,cc.SGSTPer,cc.IGSTPer FROM store_taxgroup_category cc WHERE cc.id=@id AND cc.IsActive=1", CommandType.Text, new
        //{
        //    id = quotation.taxGroupID
        //});
        //if (dt.Rows.Count > 0)
        //{
        //    quotation.IGSTPercent = Util.GetDecimal(dt.Rows[0]["IGSTPer"]);
        //    quotation.CGSTPercent = Util.GetDecimal(dt.Rows[0]["CGSTPer"]);
        //    quotation.SGSTPercent = Util.GetDecimal(dt.Rows[0]["SGSTPer"]);
        //}
        //else
        //    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Not A Valid Tax Group." });



        TaxCalculationDetails taxCalculationDetails = AllLoadData_Store.CalculateTax(new TaxCalculationOn
         {
             ActualRate = quotation.rate,
             MRP = quotation.MRP,
             Rate = quotation.rate,
             Quantity = 1,
             deal = quotation.deal1,
             deal2 = quotation.deal2,
             DiscAmt = quotation.discountAmount,
             DiscPer = quotation.discountPercent,
             Type = quotation.taxCalculatedOn,
             ExcisePer = 0,
             IGSTPrecent = quotation.IGSTPercent,
             CGSTPercent = quotation.CGSTPercent,
             SGSTPercent = quotation.SGSTPercent,
             SpecialDiscAmt = 0,
             SpecialDiscPer = 0,
             TaxPer = quotation.totalTaxPercent,
             UnitPrice = 0,
         });

        quotation.taxAmount = taxCalculationDetails.taxAmount;
        quotation.discountAmount = taxCalculationDetails.discountAmount;
        quotation.taxAmount = taxCalculationDetails.taxAmount;
        quotation.totalTaxPercent = quotation.totalTaxPercent; //quotation.IGSTPercent + quotation.CGSTPercent + quotation.SGSTPercent;
        quotation.netAmount = taxCalculationDetails.netAmount;
        quotation.profit = quotation.MRP - quotation.netAmount;
        quotation.currencyNotation = quotation.currencyNotation;
        quotation.currencyCountryID = quotation.currencyCountryID;
        quotation.remarks = quotation.remarks;

        //if (quotation.profit < 0)
        //    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Not A Valid MRP And Tax Calculated On." });

        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, quotation = quotation });
    }



    [WebMethod(EnableSession = true)]
    public static string SaveQuotation(List<Quotation> quotationList)
    {


        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        string userID = HttpContext.Current.Session["ID"].ToString();
        string departmentLedgerNo = HttpContext.Current.Session["DeptLedgerNo"].ToString();
        string userName = HttpContext.Current.Session["UserName"].ToString();
        string centreID = HttpContext.Current.Session["CentreID"].ToString();
        string hospitalID = HttpContext.Current.Session["HOSPID"].ToString();

        try
        {
            StringBuilder sqlCmd =
                new StringBuilder("INSERT INTO f_storeitem_rate (Rate,ItemID, Vendor_ID, GrossAmt, DiscAmt, TaxAmt,TotalTaxPercent, NetAmt, FromDate, ToDate, Remarks, UserID, UserName, IsActive, StoreType, TaxCalulatedOn, DeptLedgerNo, CentreID, Hospital_ID, Manufacturer_ID, MRP, IsDeal, GSTType, HSNCode, IGSTPercent, CGSTPercent, SGSTPercent,IPAddress, Profit,GSTGroupID,Minimum_Tolerance_Qty,Maximum_Tolerance_Qty,Minimum_Tolerance_Rate,Maximum_Tolerance_Rate,Currency,Currency_Factor,CurrencyCountryID,DiscountPercent )  ");
            sqlCmd.Append("                              VALUES (@rate,@ItemID,@vendorID, @rate, @discountAmount,@taxAmount,@totalTaxPercent, @netAmount, @fromDate, @toDate, @remarks, @userID, @userName, @IsActive, @storeType, @taxCalculatedOn, @departmentLedgerNo, @centreID, @hospitalID, @manufacturerID, @MRP, @deals, @GSTType, @HSNCode, @IGSTPercent, @CGSTPercent, @SGSTPercent,@IPAddress, @profit,@taxGroupID,@minimum_Tolerance_Qty,@maximum_Tolerance_Qty,@minimum_Tolerance_Rate,@maximum_Tolerance_Rate,@currencyNotation,@currencyFactor,@currencyCountryID,@discountPercent )");

            for (int i = 0; i < quotationList.Count; i++)
            {
                Quotation quotation = quotationList[i];
                quotation.fromDate = Util.GetDateTime(quotation.fromDate).ToString("yyyy-MM-dd");
                quotation.toDate = Util.GetDateTime(quotation.toDate).ToString("yyyy-MM-dd");
                quotation.userID = userID;
                quotation.userName = userName;
                quotation.departmentLedgerNo = departmentLedgerNo;
                quotation.centreID = centreID;
                quotation.deals = quotation.deal1 + " + " + quotation.deal2;
                quotation.maximum_Tolerance_Qty = quotation.maximum_Tolerance_Qty;
                quotation.minimum_Tolerance_Qty = quotation.minimum_Tolerance_Qty;
                quotation.minimum_Tolerance_Rate = quotation.minimum_Tolerance_Rate;
                quotation.maximum_Tolerance_Rate = quotation.maximum_Tolerance_Rate;
                quotation.hospitalID = hospitalID;

                if (quotation.IsActive == 1)
                {
                    excuteCMD.DML(tnx, "UPDATE f_storeitem_rate s SET  s.IsActive=0 WHERE s.ItemID=@itemID AND s.CentreID=@centreID AND s.DeptLedgerNo=@departmentLedgerNo", CommandType.Text, new
                    {
                        itemID = quotation.ItemId,
                        centreID = quotation.centreID,
                        departmentLedgerNo = quotation.departmentLedgerNo
                    });
                }
                excuteCMD.DML(tnx, sqlCmd.ToString(), CommandType.Text, quotation);
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

    [WebMethod(EnableSession=true)]
    public static string SearchQuotation(string vendorID, string[] itemIDs)
    {


        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT DISTINCT sir.`Vendor_ID` VendorLedgerNo,sir.Profit, lm.LedgerName VendorName,sir.ItemID,im.TypeName AS ItemName,IF(sir.IsActive=1,'True','False')AppStatus,sir.GrossAmt  Rate,sir.DiscAmt,sir.TaxAmt,IF(sir.`IsDeal`='0 + 0',sir.`NetAmt`,ROUND(((sir.`NetAmt`)/(SUBSTRING_INDEX(sir.`IsDeal`, '+', 1)+SUBSTRING_INDEX(sir.`IsDeal`, '+', -1))),2))NetAmt,sir.ID StoreRateID,  DATE_FORMAT(sir.FromDate,'%d-%b-%Y')FromDate,DATE_FORMAT(sir.ToDate,'%d-%b-%Y')ToDate,DATE_FORMAT( sir.`EntryDate`,'%d-%b-%Y')EntryDate, ");
        sb.Append(" MRP,IsDeal,fmm.Name, ");

        // GST Changes
        sb.Append("  IFNULL(sir.GSTType,'')GSTType,IFNULL(sir.HSNCode,'')HSNCode,sir.IGSTPercent,sir.CGSTPercent,sir.SGSTPercent,sir.Minimum_Tolerance_Qty,sir.Maximum_Tolerance_Qty,sir.Minimum_Tolerance_Rate,sir.Maximum_Tolerance_Rate ");

        sb.Append(" FROM f_storeitem_rate sir  ");
        sb.Append(" INNER JOIN f_itemmaster im  ON im.ItemID=sir.ItemID  ");
        sb.Append(" left JOIN f_manufacture_master fmm  ON sir.Manufacturer_ID=fmm.ManufactureID  ");
        sb.Append(" INNER JOIN f_ledgermaster lm ON lm.LedgerNumber=sir.Vendor_ID  WHERE  DeptLedgerNo ='" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "' AND sir.CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " ");
        if (vendorID != "0")
            sb.Append(" and sir.Vendor_ID='" + vendorID + "' ");
        if (itemIDs.Length > 0)
            sb.Append(" AND im.ItemID in ('" + string.Join("','", itemIDs) + "' ) ");
        sb.Append("     ORDER BY sir.ItemID DESC ");
        dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }

    [WebMethod]
    public static string SetDefault(string ItemID, string rateID, string Remarks)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            string userID = HttpContext.Current.Session["ID"].ToString();
            string departmentLedgerNo = HttpContext.Current.Session["DeptLedgerNo"].ToString();
            string userName = HttpContext.Current.Session["UserName"].ToString();
            string centreID = HttpContext.Current.Session["CentreID"].ToString();
            string hospitalID = HttpContext.Current.Session["HOSPID"].ToString();
            excuteCMD.DML(tnx, "UPDATE f_storeitem_rate s SET  s.IsActive=0,s.UpdatedBy=@updatedBy,s.UpdatedDate=now() WHERE s.ItemID=@itemID AND s.CentreID=@centreID AND s.DeptLedgerNo=@departmentLedgerNo", CommandType.Text, new
             {
                 itemID = ItemID,
                 centreID = centreID,
                 departmentLedgerNo = departmentLedgerNo,
                 updatedBy = userID,
             });


            excuteCMD.DML(tnx, "UPDATE f_storeitem_rate s SET  s.IsActive=1, s.UpdatedBy=@updatedBy,s.UpdatedDate=now(),s.Setdefaultremarks=@Setdefaultremarks WHERE s.ID=@ID", CommandType.Text, new
            {
                ID = rateID,
                updatedBy = userID,
                Setdefaultremarks=Remarks
            });

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = "Default Set Successfully." });

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



    [WebMethod]
    public static string ValidateImportData(List<Quotation> excelData, string vendorID)
    {

        try
        {
            List<Quotation> quotationList = new List<Quotation>();
            for (int i = 0; i < excelData.Count; i++)
            {
                DataTable dtVendorDetails = GetVendorDetails(vendorID);
                DataTable dtItemDetails = GetItemDetails(excelData[i].ItemId);

                if (dtVendorDetails.Rows.Count > 0 && dtItemDetails.Rows.Count > 0)
                {
                    DataTable dtTaxDetails = GetTaxPercent(Util.GetString(dtVendorDetails.Rows[0]["VatType"]), Util.GetString(dtItemDetails.Rows[0]["VATType"]));
                    excelData[i].subcategoryID = Util.GetString(dtItemDetails.Rows[0]["SubCategoryID"]);
                    excelData[i].taxGroupID = 0;
                    excelData[i].manufacturerID = Util.GetString(dtItemDetails.Rows[0]["ManufactureID"]);
                    excelData[i].manufacturer = Util.GetString(dtItemDetails.Rows[0]["ManuFacturer"]);
                    excelData[i].categoryID = Util.GetString(dtItemDetails.Rows[0]["CategoryID"]);

                    excelData[i].fromDate = Util.GetDateTime(excelData[i].fromDate).ToString("dd-MMM-yyyy");
                    excelData[i].toDate = Util.GetDateTime(excelData[i].toDate).ToString("dd-MMM-yyyy");




                    if (dtTaxDetails.Rows.Count > 0)
                        excelData[i].totalTaxPercent = Util.GetDecimal(dtTaxDetails.Rows[0]["VatPercentage"]);
                    else
                        excelData[i].totalTaxPercent = 0;




                    excelData[i].grossAmount = excelData[i].rate * 1;
                    if (excelData[i].discountAmount > 0)
                        excelData[i].discountPercent = (excelData[i].discountAmount * 100) / excelData[i].rate;
                    else
                        excelData[i].discountAmount = (excelData[i].rate * excelData[i].discountPercent) / 100;

                   
                    excelData[i].taxCalculatedOn = "RateAD";
                    excelData[i].taxAmount = (excelData[i].rate - excelData[i].discountAmount) * excelData[i].totalTaxPercent / 100;
                    excelData[i].netAmount = (excelData[i].rate + excelData[i].taxAmount) - excelData[i].discountAmount;
                    excelData[i].IsActive = excelData[i].IsActive;
                    excelData[i].unit = string.Empty;
                    excelData[i].currencyCountryID = Util.GetDecimal(getCurrencyCountryID(excelData[i].currencyNotation));
                    excelData[i].profit = 0;
                   
                    excelData[i].unitPrice = 0;
                    excelData[i].MRP = 0;

                    quotationList.Add(excelData[i]);

                }

            }




            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = quotationList });
        }
        catch (Exception ex)
        {

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = AllGlobalFunction.errorMessage });
        }






    }


    public static string getCurrencyCountryID(string currencyNotation)
    {



        DataTable dtDetail = All_LoadData.LoadCurrencyFactor(string.Empty);
        DataRow[] dr;
        if (String.IsNullOrEmpty(currencyNotation))
            dr = dtDetail.Select("IsBaseCurrency=1");
        else
            dr = dtDetail.Select("S_Currency='" + currencyNotation + "'");
        var Selling_Specific = dr[0]["Selling_Specific"].ToString();
        var S_Currency = dr[0]["S_Currency"].ToString();
        var S_CountryID = dr[0]["S_CountryID"].ToString();


        return Selling_Specific;
    
    
    }






    public static DataTable GetItemDetails(string itemID)
    {
        ExcuteCMD excuteCMD = new ExcuteCMD();
        StringBuilder sqlCmd = new StringBuilder("SELECT im.ItemID,im.VatType,im.SubCategoryID,sm.CategoryID,im.ManuFacturer,im.ManufactureID FROM f_itemmaster im  ");
        sqlCmd.Append("  INNER JOIN f_subcategorymaster sm ON im.SubCategoryID=sm.SubCategoryID ");
        sqlCmd.Append(" WHERE im.ItemID=@itemID ");


        var dataTable = excuteCMD.GetDataTable(sqlCmd.ToString(), CommandType.Text, new
        {

            itemID = itemID

        });

        return dataTable;
    }




    public static DataTable GetVendorDetails(string vendorID)
    {
        ExcuteCMD excuteCMD = new ExcuteCMD();
        StringBuilder sqlCmd = new StringBuilder("SELECT v.VATType FROM  f_ledgermaster l ");
        sqlCmd.Append(" INNER  JOIN f_vendormaster v ON l.ledgerUserID=v.Vendor_ID  ");
        sqlCmd.Append(" WHERE l.LedgerNumber=@vendorID");


        var dataTable = excuteCMD.GetDataTable(sqlCmd.ToString(), CommandType.Text, new
        {
            vendorID = vendorID
        });

        return dataTable;
    }




    public static DataTable GetTaxPercent(string vendorVatType, string itemVatType)
    {


        ExcuteCMD excuteCMD = new ExcuteCMD();
        System.Text.StringBuilder sqlCMD = new System.Text.StringBuilder("  SELECT v.VatType SupplierVatType,i.VatType ItemVatType,pvm.VatPercentage,l.VatLine,IF(pvm.IsVatRecoverable=1,'Yes','No')VatRecoverable  ");
        sqlCMD.Append(" FROM f_Purchase_VAT_Master pvm  ");
        sqlCMD.Append(" INNER JOIN f_Vendor_VAT_Type_Master v ON v.Id=pvm.VendorVatTypeId ");
        sqlCMD.Append(" INNER JOIN f_Purchase_Item_VAT_Type_Master i ON i.Id=pvm.ItemVatTypeId ");
        sqlCMD.Append(" INNER JOIN f_Purchase_VAT_Line_Master l ON l.Id=pvm.VatLineId ");
        sqlCMD.Append(" WHERE pvm.IsActive=1  AND v.VatType=@vendorVatType AND  i.VatType=@itemVatType ");

        var dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
        {
            itemVatType = itemVatType,
            vendorVatType = vendorVatType
        });


        return dt;

    }


}