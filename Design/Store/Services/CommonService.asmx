<%@ WebService Language="C#" Class="CommonService" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Linq;
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class CommonService : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }

    [WebMethod]
    public string GetVendors()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT LedgerNumber ID,LedgerName,v.VATType,v.Currency,v.CountryID FROM f_ledgermaster lm  INNER JOIN f_vendormaster v ON v.Vendor_ID=lm.LedgerUserID WHERE groupID='VEN' AND IsCurrent=1 ORDER BY LedgerName"));
    }


    [WebMethod]
    public string GetTaxGroups()
    {
        DataTable dt = StockReports.GetDataTable(" SELECT cc.id,CONCAT(cc.`TaxGroup`, '(',ROUND((IFNULL(cc.`CGSTPer`,0)+IFNULL(cc.`SGSTPer`,0)+IFNULL(cc.`IGSTPer`,0)),2),')') AS TaxGroupLabel, cc.`TaxGroup`,cc.`IGSTPer`,cc.`CGSTPer`, IF(cc.`TaxGroup` LIKE '%UTGST%',cc.`SGSTPer`,0.00) AS UTGSTPer , IF(cc.`TaxGroup` LIKE '%SGST%',cc.`SGSTPer`,0.00) AS SGSTPer,ROUND((IFNULL(cc.`CGSTPer`,0)+IFNULL(cc.`SGSTPer`,0)+IFNULL(cc.`IGSTPer`,0)),2) as TotalGST  FROM store_taxgroup_category cc WHERE cc.IsActive=1 ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public string GetTaxGroupsName()
    {
        DataTable dt = StockReports.GetDataTable(" SELECT DISTINCT cc.`TaxGroup` FROM store_taxgroup_category cc WHERE cc.IsActive=1 ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public string GetManufactures()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT  f.ManufactureID,f.NAME  FROM f_manufacture_master f WHERE f.IsActive=1"));
    }

    [WebMethod]
    public string GetLoyalityCatogerys()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT f.ID, f.Name,f.Amount,f.Point  FROM loyality_category_master f  where f.IsActive=1"));
    }



    [WebMethod]
    public string GetRacks()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT sm.ID,sm.Name FROM store_rack_master sm WHERE sm.IsActive=1"));
    }

    [WebMethod]
    public string GetShelf()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT s.RackID,s.ShelfName FROM  store_rack_shelfdetails s WHERE s.IsActive=1"));
    }


    [WebMethod(EnableSession = true)]
    public string GetCentre()
    {
        int centreID = Util.GetInt(Session["CentreID"]);
        System.Data.DataView dv = All_LoadData.dtbind_Center().DefaultView;
        dv.RowFilter = "CentreID NOT IN (" + centreID + ")";
        return JsonConvert.SerializeObject(dv.ToTable());
    }


    [WebMethod(EnableSession = true)]
    public string GetAllCentre()
    {
        int centreID = Util.GetInt(Session["CentreID"]);
        //System.Data.DataView dv = All_LoadData.dtbind_Center().DefaultView;
        //dv.RowFilter = "CentreID NOT IN (" + centreID + ")";
        return JsonConvert.SerializeObject(All_LoadData.dtbind_Center());
    }





    [WebMethod]
    public string GetCategorys()
    {
        System.Data.DataView dv = LoadCacheQuery.loadCategory().DefaultView;
        dv.RowFilter = "ConfigID IN (28,11)";
        DataTable cat = dv.ToTable();
        return JsonConvert.SerializeObject(cat);

    }


    [WebMethod]
    public string GetAllCategorys()
    {
        System.Data.DataView dv = LoadCacheQuery.loadCategory().DefaultView;       
        DataTable cat = dv.ToTable();
        return JsonConvert.SerializeObject(cat);
    }

    [WebMethod]
    public string GetCategorysByStoreType(string storeID)
    {


        var configID = 28;
        if (storeID == "STO00001")
            configID = 11;
        
        
        System.Data.DataView dv = LoadCacheQuery.loadCategory().DefaultView;
        dv.RowFilter = "ConfigID IN (" + configID + ")";
        DataTable cat = dv.ToTable();
        return JsonConvert.SerializeObject(cat);

    
    }


    [WebMethod]
    public string GetSubCategoryByCategory(string categoryID)
    {
        var subCategorys = CreateStockMaster.LoadSubCategoryByCategory(categoryID);
        return JsonConvert.SerializeObject(subCategorys);
    }

    [WebMethod]
    public string GetDepartMent()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT f.DeptLedgerNo,f.RoleName FROM f_rolemaster f WHERE f.Active=1 AND  f.IsMedical=1 AND  f.IsStore=1"));

    }


    [WebMethod]
    public string GetStoreReturnType()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT m.ID,m.TypeName `ReturnType` FROM store_stockposttype_master m WHERE m.IsActive=1 AND m.IsReturnType=1 "));
    }


    [WebMethod]
    public string GetMedicineGroup()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT si.ID,si.ItemGroup FROM store_itemsgroup si WHERE si.IsActive=1"));
    }
    [WebMethod]
    public string GetStoreByCenter(int centerId)
    {
        string sqlCmd = "SELECT rm.`DeptLedgerNo`,rm.`RoleName` FROM `f_rolemaster` rm  ";
        sqlCmd += " Where rm.`Active`=1   AND rm.`IsStore`=1 ORDER BY rm.`RoleName` ";
        ExcuteCMD excuteCMD = new ExcuteCMD();
        DataTable dt = excuteCMD.GetDataTable(sqlCmd, CommandType.Text, new
        {
            centerId = centerId
        });
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public string GetTaxCalOn()
    {
        List<String> listTaxCalOn = new List<String>();
        listTaxCalOn.Add("RateAD");
        listTaxCalOn.Add("MRP");
        listTaxCalOn.Add("Rate");
        listTaxCalOn.Add("RateRev");
        listTaxCalOn.Add("RateExcl");
        listTaxCalOn.Add("MRPExcl");
        listTaxCalOn.Add("ExciseAmt");
        return Newtonsoft.Json.JsonConvert.SerializeObject(listTaxCalOn);
    }

    [WebMethod]
    public string GetPurchaseDepartMent(int centerId)
    {
        string sqlCmd = "SELECT f.DeptLedgerNo,f.RoleName FROM f_rolemaster f INNER JOIN centre_role_map_master cr ON cr.`Role_ID`=f.`ID` AND cr.`IsActive`=1 WHERE f.Active=1 AND  f.IsMedical=1 AND f.`IsGeneral`=1 AND cr.`Centre_ID`=@centerId";
        ExcuteCMD excuteCMD = new ExcuteCMD();
        DataTable dt = excuteCMD.GetDataTable(sqlCmd, CommandType.Text, new
        {
            centerId = centerId
        });
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }



    [WebMethod]
    public string CalculateTaxAmount(TaxCalculationOn taxCalculationOn, int taxGroupID)
    {

        //ExcuteCMD excuteCMD = new ExcuteCMD();
        //DataTable dt = excuteCMD.GetDataTable("SELECT cc.id,cc.TaxGroup,cc.CGSTPer,cc.SGSTPer,cc.IGSTPer FROM store_taxgroup_category cc WHERE cc.id=@id AND cc.IsActive=1", CommandType.Text, new
        //{
        //    id = taxGroupID
        //});
        //if (dt.Rows.Count > 0)
        //{
        //    taxCalculationOn.IGSTPrecent = Util.GetDecimal(dt.Rows[0]["IGSTPer"]);
        //    taxCalculationOn.CGSTPercent = Util.GetDecimal(dt.Rows[0]["CGSTPer"]);
        //    taxCalculationOn.SGSTPercent = Util.GetDecimal(dt.Rows[0]["SGSTPer"]);
        //    taxCalculationOn.TaxPer = Util.GetDecimal(Util.GetDecimal(dt.Rows[0]["IGSTPer"]) + Util.GetDecimal(dt.Rows[0]["CGSTPer"]) + Util.GetDecimal(dt.Rows[0]["SGSTPer"]));
        //}
        //else
        //    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Not A Valid Tax Group." });









        TaxCalculationDetails taxCalculationDetails = AllLoadData_Store.CalculateTax(taxCalculationOn);
        taxCalculationDetails.taxPercent = taxCalculationOn.TaxPer;

        //taxCalculationDetails.IGSTPrecent = taxCalculationOn.IGSTPrecent;
        //taxCalculationDetails.CGSTPercent = taxCalculationOn.CGSTPercent;
        //taxCalculationDetails.SGSTPercent = taxCalculationOn.SGSTPercent;

        // taxCalculationDetails.taxAmount = Math.Round(taxCalculationDetails.sgstTaxAmount + taxCalculationDetails.igstTaxAmount + taxCalculationDetails.cgstTaxAmount, 2);


        return Newtonsoft.Json.JsonConvert.SerializeObject(taxCalculationDetails);
    }

     [WebMethod]
    public string GetLastPurchaseRate(string itemID, string StoreType)
    {
        ExcuteCMD excuteCMD = new ExcuteCMD();

        System.Text.StringBuilder sqlCMD = new System.Text.StringBuilder("  SELECT f.Rate FROM f_stock f WHERE f.TypeOfTnx IN('Purchase','NMPURCHASE') AND f.StoreLedgerNo=@storeType AND f.ItemID=@itemId AND f.IsPost=1 ORDER BY f.StockID DESC LIMIT 1 ");

        var dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
        {
            itemId = itemID,
            storeType = StoreType
        });

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }

    [WebMethod]
     public string GetTaxAmount(string itemID)
     {
         ExcuteCMD excuteCMD = new ExcuteCMD();

         StringBuilder sb = new StringBuilder();
         sb.Append("SELECT CONCAT(UPPER(GSTType),'(',ROUND((IGSTPercent+SGSTPercent+CGSTPercent),2),')') AS GSTType, ROUND((IGSTPercent+SGSTPercent+CGSTPercent),2) 'Taxpercent' FROM f_itemmaster WHERE ItemID=@ItemID ");

         var dt = excuteCMD.GetDataTable(sb.ToString(), CommandType.Text, new
         {
             ItemID = itemID
         });

         return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
     }
        

    [WebMethod]
    public string GetVatTaxPercent(string itemID, string vendorID, string vendorVatType, string itemVatType)
    {
        ExcuteCMD excuteCMD = new ExcuteCMD();

        System.Text.StringBuilder sqlCMD = new System.Text.StringBuilder(" SELECT im.`DefaultPurchaseVatPercentage` AS VatPercentage,im.`VatType` AS ItemVatType FROM f_itemmaster im WHERE im.`IsActive`='1' AND im.`ItemID`=@itemID   ");
        

        var dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
        {
            itemID = itemID
            
            
        });

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }



    [WebMethod]
    public string GetTaxCalculateTaxOn()
    {

        return Newtonsoft.Json.JsonConvert.SerializeObject(AllGlobalFunction.taxCalculateOn);
    }


    [WebMethod(EnableSession = true)]
    public string GetPurchaseMarkUpPercent()
    {
        int centerID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
       // var dt = StockReports.GetDataTable("SELECT c.CategoryID,c.CentreID,c.SubCategoryID,c.ToRate,c.FromRate,c.MarkUpPercentage FROM  f_centrewise_markup c WHERE c.CentreID=" + centerID + " AND c.IsActive=1 ");
      //  var dt = StockReports.GetDataTable("SELECT c.CategoryID,c.CentreID,c.SubCategoryID,c.ToRate,c.FromRate,c.MarkUpPercentage,c.ItemID FROM  f_centrewise_markup c WHERE c.CentreID=" + centerID + " AND c.IsActive=1 AND IFNULL(c.ItemID,'')<>'' AND c.`MarkUpPercentage`>0  UNION ALL SELECT cs.CategoryID,cs.CentreID,cs.SubCategoryID,cs.ToRate,cs.FromRate,cs.MarkUpPercentage,cs.ItemID FROM  f_centrewise_markup cs WHERE cs.CentreID=" + centerID + " AND cs.IsActive=1  AND IFNULL(cs.ItemID,'')='' AND cs.`MarkUpPercentage`>0  UNION ALL SELECT cd.CategoryID,cd.CentreID,cd.SubCategoryID,cd.ToRate,cd.FromRate,cd.MarkUpPercentage,cd.ItemID FROM f_centrewise_markup cd WHERE IFNULL(cd.`ItemID`,'')='' AND IFNULL(cd.`CategoryID`,'')='' AND IFNULL(cd.`SubCategoryID`,'')='' AND cd.`IsActive`=1  AND cd.`CentreID`=0  AND cd.`MarkUpPercentage`>0 ");

         var isCentreWiseSubCategoryWise = Util.GetInt(Resources.Resource.IsCentrewiseSubCategoryWiseMarkup);
        
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT IF(c.CentreID=1,'CentreWiseItemWise','UniversalItemWise') AS MarkUpType,c.CategoryID,c.CentreID,c.SubCategoryID,c.ToRate,c.FromRate,c.MarkUpPercentage,c.ItemID  ");
        sb.Append("FROM  f_centrewise_markup c  ");
        sb.Append("WHERE c.CentreID IN(" + centerID + ",0) AND c.IsActive=1 AND IFNULL(c.ItemID,'')<>'' AND c.`MarkUpPercentage`>0   ");
        sb.Append("UNION ALL  ");
        sb.Append("SELECT  'UniversalSubCategoryWise' AS MarkUpType, cs.CategoryID,cs.CentreID,cs.SubCategoryID,cs.ToRate,cs.FromRate,cs.MarkUpPercentage,cs.ItemID  ");
        sb.Append("FROM  f_centrewise_markup cs  ");
        sb.Append("WHERE cs.IsActive=1 AND IFNULL(cs.ItemID,'')='' AND IFNULL(cs.`SubCategoryID`,'')<>'' AND cs.`MarkUpPercentage`>0   ");
        
       if(isCentreWiseSubCategoryWise==0)
        sb.Append("AND cs.CentreID=0 ");
       else
           sb.Append("AND cs.CentreID=" + centerID + " ");  
        
            
        var dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    
    [WebMethod(EnableSession = true)]
    public string getCurrencyFactor(string currencyNotation)
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


        return Newtonsoft.Json.JsonConvert.SerializeObject(new { currencyFactor = Selling_Specific, currency = S_Currency, currencyCountryID = S_CountryID });
    }
    [WebMethod]
    public string BindCenter(string EmployeeID)
    {
        DataTable dtData = All_LoadData.dtbind_Centre(EmployeeID);
        if (dtData.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtData);
        }
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public string BindDepartment(string DeptID, string CentreID)
    {
        DataTable dtdept = LoadCacheQuery.bindStoreDepartment();
        DataView dv = dtdept.DefaultView;
        if (CentreID == "")
            CentreID = HttpContext.Current.Session["CentreID"].ToString();
        string ledgerNumber = StockReports.ExecuteScalar("SELECT DISTINCT GROUP_CONCAT(CONCAT('''',rm.DeptLedgerNo,'''')) FROM f_rolemaster rm INNER JOIN f_centre_role cr ON cr.RoleID=rm.id AND cr.isActive=1 WHERE cr.CentreID IN (" + CentreID + ") AND cr.isActive=1 AND rm.IsStore=1");
        dv.RowFilter = "ledgerNumber in (" + ledgerNumber + ") ";
        dtdept = dv.ToTable();
        string rolelist = "LSHHI111,";
        string[] ExceptionDeptList = rolelist.Split(",".ToCharArray(), StringSplitOptions.RemoveEmptyEntries);
        if (ExceptionDeptList.Contains(HttpContext.Current.Session["DeptLedgerNo"].ToString()))
            dtdept = dtdept.AsEnumerable().Where(r => r.Field<int>("IsStore") == 1 || r.Field<int>("IsMedical") == 1 || r.Field<int>("IsGeneral") == 1).AsDataView().ToTable();
        else if (DeptID != "0" && DeptID != "LSHHI3558" )
            dtdept = dtdept.AsEnumerable().Where(r => (r.Field<int>("IsStore") == 1 || r.Field<int>("IsMedical") == 1 || r.Field<int>("IsGeneral") == 1) && r.Field<string>("ledgerNumber") == DeptID).AsDataView().ToTable();
        else
            dtdept = dtdept.AsEnumerable().Where(r => r.Field<int>("IsStore") == 1 || r.Field<int>("IsMedical") == 1 || r.Field<int>("IsGeneral") == 1).AsDataView().ToTable();
        if (dtdept.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtdept);
        }
        else
            return "";
    }
    [WebMethod]
    public string BindSupplier()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" select LedgerNumber,LedgerName from f_ledgermaster led INNER JOIN f_vendormaster ven ");
        sb.Append(" ON led.LedgerUserID=ven.Vendor_ID where GroupID = 'VEN' ");
        sb.Append(" order by LedgerName");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
            return "";
    }
    [WebMethod]
    public string BindCategory(string Cat)
    {
        if (String.IsNullOrEmpty(Cat))
        {
            DataTable dtcategory = StockReports.GetDataTable("SELECT cm.Name,cm.CategoryID FROM f_categorymaster cm INNER JOIN f_configrelation cf ON cf.CategoryID = cm.CategoryID WHERE cf.ConfigID IN (11,28)");
            if (dtcategory.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(dtcategory);
            else
                return "";
        }
        else
        {
            string IsStoreType = "SELECT GROUP_CONCAT(IsGeneral)IsGeneral,GROUP_CONCAT(IsMedical)IsMedical FROM f_rolemaster rm WHERE rm.DeptLedgerNo IN (" + Cat + ")";
            DataTable dtstoretype = StockReports.GetDataTable(IsStoreType);
            if (dtstoretype.Rows.Count > 0)
            {
                string configID = "";
                if (dtstoretype.Rows[0]["IsGeneral"].ToString() != "0" && dtstoretype.Rows[0]["IsMedical"].ToString() != "0")
                    configID = "28,11";
                else if (dtstoretype.Rows[0]["IsGeneral"].ToString() != "0")
                    configID = "28";
                else if (dtstoretype.Rows[0]["IsMedical"].ToString() != "0")
                    configID = "11";
                else
                    configID = "";
                if (configID == "")
                    return "";
                else
                {
                    DataTable dtcategory = StockReports.GetDataTable("SELECT cm.Name,cm.CategoryID FROM f_categorymaster cm INNER JOIN f_configrelation cf ON cf.CategoryID = cm.CategoryID WHERE cf.ConfigID IN (" + configID + ")");
                    if (dtcategory.Rows.Count > 0)
                        return Newtonsoft.Json.JsonConvert.SerializeObject(dtcategory);
                    else
                        return "";
                }
            }
            else
                return "";
        }
    }
    [WebMethod]
    public string BindSubCategory(string CategoryID)
    {
        string sqlGroup = string.Empty;
        if (String.IsNullOrEmpty(CategoryID))
            sqlGroup = "SELECT sc.Name,sc.SubCategoryID FROM f_subcategorymaster sc WHERE sc.Active=1 ORDER BY sc.Name ";
        else
            sqlGroup = "SELECT sc.Name,sc.SubCategoryID FROM f_subcategorymaster sc WHERE sc.Active=1 AND sc.CategoryID IN (" + CategoryID + ") ORDER BY sc.Name ";

        DataTable dt = StockReports.GetDataTable(sqlGroup);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public string BindItems(string subcategory)
    {
        string sql = string.Empty;
        if (String.IsNullOrEmpty(subcategory))
        {
            sql = "Select TypeName,ItemID FROM f_Itemmaster WHERE IsActive=1 ORDER BY TypeName";
        }
        else
        {
            sql = "Select TypeName,ItemID FROM f_Itemmaster WHERE IsActive=1 AND SubcategoryID IN (" + subcategory + ") ";
            sql = sql + " ORDER BY TypeName";
        }
        DataTable dt = StockReports.GetDataTable(sql);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public string BindDepartmentFrom(string DeptID, string CentreID)
    {
        DataTable dtdept = LoadCacheQuery.bindStoreDepartment();
        DataView dv = dtdept.DefaultView;
        if (CentreID == "")
            CentreID = HttpContext.Current.Session["CentreID"].ToString();
        string ledgerNumber = StockReports.ExecuteScalar("SELECT DISTINCT GROUP_CONCAT(CONCAT('''',rm.DeptLedgerNo,'''')) FROM f_rolemaster rm INNER JOIN f_centre_role cr ON cr.RoleID=rm.id WHERE cr.CentreID IN (" + CentreID + ") AND cr.isActive=1 and  rm.IsStore=1");
        dv.RowFilter = "ledgerNumber in (" + ledgerNumber + ") ";
        dtdept = dv.ToTable();
        if (dtdept.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtdept);
        }
        else
            return "";
    }
}