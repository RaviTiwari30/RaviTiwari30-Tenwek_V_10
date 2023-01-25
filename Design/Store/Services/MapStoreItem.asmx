<%@ WebService Language="C#" Class="MapStoreItem" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using Newtonsoft.Json;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;
using System.Collections.Generic;
using System.Text.RegularExpressions;


[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class MapStoreItem : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }


    [WebMethod(EnableSession = true)]
    public string ConvertToExcel(string fileName, object data)
    {
        try
        {
            var s = Newtonsoft.Json.JsonConvert.SerializeObject(data);
            DataTable dt = JsonStringToDataTable(s);
            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = fileName;
            return Newtonsoft.Json.JsonConvert.SerializeObject(new
            {
                status = true,
            });
        }
        catch (Exception ex)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = ex.Message });
        }




    }



    public static DataTable JsonStringToDataTable(string jsonString)
    {
        DataTable dt = new DataTable();
        string[] jsonStringArray = Regex.Split(jsonString.Replace("[", "").Replace("]", ""), "},{");
        List<string> ColumnsName = new List<string>();
        foreach (string jSA in jsonStringArray)
        {
            string[] jsonStringData = Regex.Split(jSA.Replace("{", "").Replace("}", ""), ",");
            foreach (string ColumnsNameData in jsonStringData)
            {
                try
                {
                    int idx = ColumnsNameData.IndexOf(":");
                    string ColumnsNameString = ColumnsNameData.Substring(0, idx - 1).Replace("\"", "");
                    if (!ColumnsName.Contains(ColumnsNameString))
                    {
                        ColumnsName.Add(ColumnsNameString);
                    }
                }
                catch (Exception ex)
                {
                    throw new Exception(string.Format("Error Parsing Column Name : {0}", ColumnsNameData));
                }
            }
            break;
        }
        foreach (string AddColumnName in ColumnsName)
        {
            dt.Columns.Add(AddColumnName);
        }
        foreach (string jSA in jsonStringArray)
        {
            string[] RowData = Regex.Split(jSA.Replace("{", "").Replace("}", ""), ",");
            DataRow nr = dt.NewRow();
            foreach (string rowData in RowData)
            {
                try
                {
                    int idx = rowData.IndexOf(":");
                    string RowColumns = rowData.Substring(0, idx - 1).Replace("\"", "");
                    string RowDataString = rowData.Substring(idx + 1).Replace("\"", "");
                    nr[RowColumns] = RowDataString;
                }
                catch (Exception ex)
                {
                    continue;
                }
            }
            dt.Rows.Add(nr);
        }
        return dt;
    }



    //[WebMethod]
    //public string GetItems(string centerID, string departMentLedgerNo, string categoryID, string subCategoryID, string itemName, int manufactureID)
    //{
    //    StringBuilder sqlCmd = new StringBuilder("SELECT IF(C.ConfigID=11,'Medical','General') ItemStoreType, im.TypeName,im.ItemID ,im.SubCategoryID,IFNULL(dp.MaxLevel,0)MaxLevel,IFNULL(dp.MinLevel,0)MinLevel,IFNULL(dp.ReorderLevel,0)ReorderLevel,IFNULL(dp.ReorderQty,0)ReorderQty,IFNULL(dp.MaxReorderQty,0)MaxReorderQty,IFNULL(dp.MinReorderQty,0)MinReorderQty,if(IFNULL(dp.IsActive,0)=1,'Y','N') IsActive,IFNULL(dp.IsActive, 0) IsExits,IFNULL(im.MajorUnit,'')MajorUnit,IFNULL(im.MinorUnit,'') MinorUnit,IFNULL(im.ConversionFactor,1)ConversionFactor,IFNULL(dp.Discount, 0) Discount,IFNULL((SELECT `Name` FROM   loyality_category_master f WHERE f.ID=dp.LoyalityCategoryID),'') LoyalityCategoryID," + centerID + " centerID,'" + departMentLedgerNo + "' departMentLedgerNo,IFNULL(dp.Rack,'')Rack,IFNULL(dp.Shelf,'')Shelf  FROM f_itemmaster im   INNER JOIN f_subcategorymaster sm ON im.SubCategoryID=sm.SubCategoryID   INNER JOIN f_configrelation c ON  SM.CategoryID=C.CategoryID AND C.ConfigID IN(11,28) LEFT  JOIN f_itemmaster_deptwise dp ON im.ItemID=dp.ItemID AND dp.CentreID = " + centerID + " AND dp.DeptLedgerNo = " + departMentLedgerNo + "  WHERE im.IsActive=1");

    //    if (manufactureID != 0)
    //        sqlCmd.Append(" AND im.ManufactureID=" + manufactureID);

    //    if (categoryID != "0")
    //        sqlCmd.Append(" AND sm.CategoryID='" + categoryID + "'");

    //    if (subCategoryID != "0" && !string.IsNullOrEmpty(subCategoryID))
    //        sqlCmd.Append(" AND sm.SubCategoryID='" + subCategoryID + "'");

    //    if (!string.IsNullOrEmpty(itemName))
    //        sqlCmd.Append(" AND im.TypeName LIKE '%" + itemName + "%'");

    //    return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sqlCmd.ToString()));

    //}

    [WebMethod]
    public string GetItems(string centerID, string departMentLedgerNo, string categoryID, string subCategoryID, string itemName, int[] manufactureID, string groupid, string date, string itemtype, string centreName)
    {
        string str = string.Empty;
      //  StringBuilder sqlCmd = new StringBuilder("SELECT IF(C.ConfigID=11,'Medical','General') ItemStoreType, im.TypeName,im.ItemID ,im.SubCategoryID,IFNULL(dp.MaxLevel,0)MaxLevel,IFNULL(dp.MinLevel,0)MinLevel,IFNULL(dp.ReorderLevel,0)ReorderLevel,IFNULL(dp.ReorderQty,0)ReorderQty,IFNULL(dp.MaxReorderQty,0)MaxReorderQty,IFNULL(dp.MinReorderQty,0)MinReorderQty,if(IFNULL(dp.IsActive,0)=1,'Y','N') IsActive,IFNULL(dp.IsActive, 0) IsExits,IFNULL(im.MajorUnit,'')MajorUnit,IFNULL(im.MinorUnit,'') MinorUnit,IFNULL(im.ConversionFactor,1)ConversionFactor,IFNULL(dp.Discount, 0) Discount,IFNULL((SELECT `Name` FROM   loyality_category_master f WHERE f.ID=dp.LoyalityCategoryID),'') LoyalityCategoryID," + centerID + " centerID,'" + departMentLedgerNo + "' departMentLedgerNo,IFNULL(dp.Rack,'')Rack,IFNULL(dp.Shelf,'')Shelf  FROM f_itemmaster im   INNER JOIN f_subcategorymaster sm ON im.SubCategoryID=sm.SubCategoryID   INNER JOIN f_configrelation c ON  SM.CategoryID=C.CategoryID AND C.ConfigID IN(11,28) LEFT  JOIN f_itemmaster_deptwise dp ON im.ItemID=dp.ItemID AND dp.CentreID = " + centerID + " AND dp.DeptLedgerNo = '" + departMentLedgerNo + "'  WHERE im.IsActive=1");
        StringBuilder sqlCmd = new StringBuilder(" SELECT  '" + centreName + "' as CentreName,c.`Name` AS Category,c.`CategoryID`,sm.`Name` AS SubCategory,im.TypeName,im.ItemID ,im.SubCategoryID,IFNULL(dp.MaxLevel,0)MaxLevel,IFNULL(dp.MinLevel,0)MinLevel,IFNULL(dp.ReorderLevel,0)ReorderLevel,IFNULL(dp.ReorderQty,0)ReorderQty,IFNULL(dp.MaxReorderQty,0)MaxReorderQty,IFNULL(dp.MinReorderQty,0)MinReorderQty,if(IFNULL(dp.IsActive,0)=1,'Y','N') IsActive,IFNULL(dp.IsActive, 0) IsExits,IFNULL(im.MajorUnit,'')MajorUnit,IFNULL(im.MinorUnit,'') MinorUnit,IFNULL(im.ConversionFactor,1)ConversionFactor,IFNULL(dp.Discount, 0) Discount,IFNULL((SELECT `Name` FROM   loyality_category_master f WHERE f.ID=dp.LoyalityCategoryID),'') LoyalityCategoryID," + centerID + " centerID,'" + departMentLedgerNo + "' departMentLedgerNo,IFNULL(dp.Rack,'')Rack,IFNULL(dp.Shelf,'')Shelf  FROM f_itemmaster im   INNER JOIN f_subcategorymaster sm ON im.SubCategoryID=sm.SubCategoryID   INNER JOIN f_configrelation c ON  SM.CategoryID=C.CategoryID LEFT JOIN f_itemmaster_centerwise dp ON im.ItemID=dp.ItemID AND dp.CentreID = " + centerID + " AND dp.`IsActive`=1  WHERE im.IsActive=1");
        
        if (date != "")
            sqlCmd.Append(" And Date(im.CreaterDateTime) >= '" + Util.GetDateTime(date).ToString("yyyy-MM-dd") + "' ");      
            
        for (int i = 0; i <= manufactureID.Length - 1; i++)
        {
            str = str + manufactureID[i] + ",";
        }
        
        str = str.TrimEnd(',');
        if (manufactureID.Length > 0)
            sqlCmd.Append(" AND im.ManufactureID in (" + str + ")");

        if (groupid != "0")
        {
            sqlCmd.Append(" AND ItemGroupMasterID='" + groupid + "'");
        }

        if (categoryID != "0")
            sqlCmd.Append(" AND sm.CategoryID='" + categoryID + "'");

        if (subCategoryID != "0" && !string.IsNullOrEmpty(subCategoryID))
            sqlCmd.Append(" AND sm.SubCategoryID='" + subCategoryID + "'");

        if (!string.IsNullOrEmpty(itemName))
            sqlCmd.Append(" AND im.TypeName LIKE '%" + itemName + "%'");
        
        if(itemtype=="mapped")
            sqlCmd.Append("  AND dp.`ID` IS NOT NULL ");
        if (itemtype == "unmapped")
            sqlCmd.Append("  AND dp.`ID` IS NULL ");    
            

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sqlCmd.ToString()));

    }
    [WebMethod]
    public string GetAllCategory()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(" SELECT cm.Name,cm.CategoryID,ConfigID FROM f_categorymaster cm INNER JOIN f_configrelation cf ON cm.categoryid = cf.categoryid  Where Active=1 ORDER BY cm.Name "));
    }

    [WebMethod]
    public string GetSubCategoryByCategory(string categoryID)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(" SELECT SubCategoryID,sm.CategoryID,sm.Name,DisplayName,ConfigID,DisplayPriority FROM f_subcategorymaster sm INNER JOIN f_configrelation cf ON sm.categoryid = cf.categoryid  WHERE sm.active=1 and sm.categoryid='" + categoryID + "' ORDER BY sm.DisplayPriority "));
    }

    [WebMethod(EnableSession = true)]
    public string SaveItems(System.Collections.Generic.List<DepartmentWiseItem> listItems)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            for (int i = 0; i < listItems.Count; i++)
            {
                var item = listItems[i];
                item.Createdby = HttpContext.Current.Session["ID"].ToString();
                item.Ipaddress = All_LoadData.IpAddress();
                if (item.Isactive.ToUpper() == "Y" || item.Isactive.ToUpper() == "1")
                    item.Isactive = "1";
                else
                    item.Isactive = "0";

                //  excuteCMD.DML(tnx, "DELETE from f_itemmaster_centerwise  WHERE ItemID=@Itemid AND DeptLedgerNo=@Deptledgerno AND  CentreID=@Centreid", CommandType.Text, item);


                excuteCMD.DML(tnx, "UPDATE f_itemmaster_centerwise SET IsActive=0,UpdatedBy=@Createdby,UpdatedDate=NOW() WHERE ItemID=@Itemid  AND  CentreID=@Centreid", CommandType.Text, item);
                if (item.Isactive == "1")
                {
                    var sqlCmd = new StringBuilder("INSERT INTO f_itemmaster_centerwise (ItemID, DeptLedgerNo, MaxLevel, MinLevel, ReorderLevel, ReorderQty, MaxReorderQty, MinReorderQty, majorUnit, minorUnit, conversionFactor, SubCategoryID, IsActive, CreatedBy, IPAddress,Rack, Shelf, CentreID,Discount,LoyalityCategoryID )");
                    sqlCmd.Append("VALUES (@Itemid,@Deptledgerno,@Maxlevel,@Minlevel,@Reorderlevel,@Reorderqty,@Maxreorderqty,@Minreorderqty,@Majorunit,@Minorunit,@Conversionfactor,@Subcategoryid,@Isactive,@Createdby,@IPAddress,@Rack,@Shelf,@Centreid,@Discount,@LoyalityCategoryID)");
                    excuteCMD.DML(tnx, sqlCmd.ToString(), CommandType.Text, item);
                }
            }

            var CacheName = "OPDDiagnosisItems_" + listItems[0].Centreid;
            LoadCacheQuery.dropCache(CacheName);
            CacheName = "OPD_Investigation_" + listItems[0].Centreid;
            LoadCacheQuery.dropCache(CacheName);

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





    [WebMethod(EnableSession = true)]
    public string CopyItemMappingItems(System.Collections.Generic.List<DepartmentWiseItem> listItems, List<centre> centreList)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            for (int k = 0; k < centreList.Count; k++)
            {
                for (int i = 0; i < listItems.Count; i++)
                {
                    var item = listItems[i];
                    item.Centreid = centreList[k].centreId;
                    item.Createdby = HttpContext.Current.Session["ID"].ToString();
                    item.Ipaddress = All_LoadData.IpAddress();
                    if (item.Isactive.ToUpper() == "Y" || item.Isactive.ToUpper() == "1")
                        item.Isactive = "1";
                    else
                        item.Isactive = "0";

                  //  excuteCMD.DML(tnx, "DELETE from f_itemmaster_centerwise  WHERE ItemID=@Itemid AND DeptLedgerNo=@Deptledgerno AND  CentreID=@Centreid", CommandType.Text, item);

                    
                    excuteCMD.DML(tnx, "UPDATE f_itemmaster_centerwise SET IsActive=0,UpdatedBy=@Createdby,UpdatedDate=NOW() WHERE ItemID=@Itemid AND DeptLedgerNo=@Deptledgerno AND  CentreID=@Centreid", CommandType.Text, item);
                    if (item.Isactive == "1")
                    {
                        var sqlCmd = new StringBuilder("INSERT INTO f_itemmaster_centerwise (ItemID, DeptLedgerNo, MaxLevel, MinLevel, ReorderLevel, ReorderQty, MaxReorderQty, MinReorderQty, majorUnit, minorUnit, conversionFactor, SubCategoryID, IsActive, CreatedBy, IPAddress,Rack, Shelf, CentreID,Discount,LoyalityCategoryID )");
                        sqlCmd.Append("VALUES (@Itemid,@Deptledgerno,@Maxlevel,@Minlevel,@Reorderlevel,@Reorderqty,@Maxreorderqty,@Minreorderqty,@Majorunit,@Minorunit,@Conversionfactor,@Subcategoryid,@Isactive,@Createdby,@IPAddress,@Rack,@Shelf,@Centreid,@Discount,@LoyalityCategoryID)");
                        excuteCMD.DML(tnx, sqlCmd.ToString(), CommandType.Text, item);
                    }
                }

                var CacheName = "OPDDiagnosisItems_" + listItems[0].Centreid;
                LoadCacheQuery.dropCache(CacheName);
                CacheName = "OPD_Investigation_" + listItems[0].Centreid;
                LoadCacheQuery.dropCache(CacheName);
                
            }

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






    public class centre
    {
        public int centreId { get; set; }
    }
    public class DepartmentWiseItem
    {
        public int Id { get; set; }
        public string Itemid { get; set; }
        public string Deptledgerno { get; set; }
        public decimal Maxlevel { get; set; }
        public decimal Minlevel { get; set; }
        public decimal Reorderlevel { get; set; }
        public decimal Reorderqty { get; set; }
        public decimal Maxreorderqty { get; set; }
        public decimal Minreorderqty { get; set; }
        public string Majorunit { get; set; }
        public string Minorunit { get; set; }
        public decimal Conversionfactor { get; set; }
        public decimal Discount { get; set; }
        public string Subcategoryid { get; set; }
        public string Isactive { get; set; }
        public string Createdby { get; set; }
        public string Ipaddress { get; set; }
        public string Updatedby { get; set; }
        public string Updateddate { get; set; }
        public string Rack { get; set; }
        public string LoyalityCategoryID { get; set; }
        public string Shelf { get; set; }
        public int Centreid { get; set; }
        public string Createddate { get; set; }
        public string CentreName { get; set; }
    }

}