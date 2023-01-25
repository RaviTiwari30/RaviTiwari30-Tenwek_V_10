<%@ WebService Language="C#" Class="Pharmacy" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Text;
using System.Data;
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.None)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class Pharmacy : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }

    [WebMethod(MessageName = "abc")]
    public void medicineItemSearch(string cmd, string type, string deptLedgerNo, string page, string rows)
    {
        HttpContext.Current.Response.Write("[]");
    }


    [WebMethod(EnableSession=true)]
    public void DemandMedicineItemSearch(string cmd, string type, string deptLedgerNo, string q, string page, string rows, string sort, string order, bool isWithAlternate, bool isBarCodeScan)
    {
        var dt = new System.Data.DataTable();
        try
        {
            //var deptLedgerNo = "LSHHI17";
            if (q != "")
            {
                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                if (type == "1")
                {
                    sb.Append("SELECT t.* FROM ( Select 0 'alterNate', ST.stockid,REPLACE(ST.ItemName,'\"','\\\\\"') ItemName,CONCAT(ST.ItemID,'#',ST.StockID)ItemID ");
                    sb.Append(" ,DATE_FORMAT(st.MedExpiryDate,'%d-%b-%y')Expiry,ST.BatchNumber,");
                    sb.Append(" IFNULL(get_New_PriceByRange(" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + ",IM.SubcategoryID,max(ST.UnitPrice)) ,0)MRP,ST.UnitPrice,Sum(ST.InitialCount - ST.ReleasedCount)AvlQty,IF(IFNULL(fid.Rack,'')='',im.Rack,fid.Rack)Rack, ");
                    sb.Append(" IF(IFNULL(fid.Shelf,'')='',im.Shelf,fid.Shelf)Shelf ");
                    sb.Append(" ,IFNULL((SELECT SM.Name FROM f_salt_master SM INNER JOIN f_item_salt fis ON fis.saltID=sm.SaltID WHERE fis.ItemID=im.ItemID GROUP BY im.ItemID),'') AS Generic ");
                    sb.Append(" FROM f_stock ST INNER JOIN f_itemmaster IM on ST.ItemID=IM.ItemID INNER JOIN f_subcategorymaster sub ON sub.SubcategoryID=IM.SubcategoryID ");
                    sb.Append(" INNER JOIN f_configrelation CR on sub.CategoryID = CR.CategoryID ");
                    sb.Append(" LEFT JOIN f_itemmaster_deptwise fid ON fid.ItemID=IM.ItemID AND fid.DeptLedgerNo='" + deptLedgerNo + "' ");
                 //   sb.Append(" WHERE (ST.InitialCount - ST.ReleasedCount) > 0 AND ST.IsPost = 1 ");
                    sb.Append(" WHERE ST.IsPost = 1 ");
                    if (isBarCodeScan)
                        sb.Append(" AND st.BarCodeID =" + q);
                    else
                        sb.Append(" AND TRIM(ST.ItemName) LIKE '" + q + "%' ");

                    sb.Append(" AND st.DeptLedgerNo='" + deptLedgerNo + "' ");
                    sb.Append(" AND IF(IM.IsExpirable<>'NO',DATE(st.MedExpiryDate) >= CURDATE(),'01-Jan-01') AND CR.ConfigID = 11 AND st.CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " group by ST.ItemID ");


                    //Alternative Brands 
                    if (isWithAlternate && isBarCodeScan)
                    {
                        sb.Append(" UNION ALL");
                        sb.Append(" SELECT 1 'alterNate', ST.stockid,REPLACE(ST.ItemName,'\"','\\\\\"') ItemName,CONCAT(ST.ItemID, '#', ST.StockID) ItemID,DATE_FORMAT(st.MedExpiryDate, '%d-%b-%y') Expiry, ");
                        sb.Append(" ST.BatchNumber IFNULL(get_New_PriceByRange(" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + ",IM.SubcategoryID,max(ST.UnitPrice)) ,0)MRP,ST.UnitPrice,Sum(ST.InitialCount - ST.ReleasedCount) AvlQty, ");
                        sb.Append(" IF(IFNULL(fid.Rack, '') = '',im.Rack,fid.Rack) Rack,IF(IFNULL(fid.Shelf, '') = '',im.Shelf,fid.Shelf ) Shelf, ");
                        sb.Append(" IFNULL((SELECT SM.Name FROM f_salt_master SM INNER JOIN f_item_salt fis ON fis.saltID = sm.SaltID ");
                        sb.Append(" WHERE fis.ItemID = im.ItemID GROUP BY im.ItemID),'') AS Generic ");
                        sb.Append(" FROM f_stock ST ");
                        sb.Append(" INNER JOIN f_itemmaster IM ON ST.ItemID = IM.ItemID INNER JOIN f_subcategorymaster sub ON sub.SubcategoryID = IM.SubcategoryID ");
                        sb.Append(" INNER JOIN f_configrelation CR ON sub.CategoryID = CR.CategoryID LEFT JOIN f_itemmaster_deptwise fid ON fid.ItemID = IM.ItemID ");
                        sb.Append(" AND fid.DeptLedgerNo='" + deptLedgerNo + "'  WHERE (   ST.InitialCount - ST.ReleasedCount) > 0 ");
                        sb.Append(" AND ST.IsPost = 1 AND ");
                        sb.Append(" st.ItemID IN( ");
                        sb.Append("     SELECT DISTINCT s.ItemID FROM f_item_salt s WHERE s.saltID IN( ");
                        sb.Append("        SELECT DISTINCT fis.saltID ");
                        sb.Append("         FROM f_item_salt fis ");
                        sb.Append("         INNER JOIN f_itemmaster im ON im.ItemID=fis.ItemID ");
                        sb.Append("     WHERE TRIM(im.TypeName) LIKE '" + q + "%' ");
                        sb.Append(" ) ) AND st.DeptLedgerNo = '" + deptLedgerNo + "' AND TRIM(st.ItemName) NOT LIKE '" + q + "%' ");
                        sb.Append(" AND IF(IM.IsExpirable <> 'NO',DATE(st.MedExpiryDate) >= CURDATE(),'01-Jan-01') ");
                        sb.Append(" AND CR.ConfigID = 11  AND st.CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " group by ST.ItemID ");
                    }

                    sb.Append("   ) t");
                   	sb.Append("   ORDER BY t." + sort + " " + order + " LIMIT " + Util.GetString(20) + " ");

                }
                else if (type == "2")
                {
                    sb.Append("SELECT t.* FROM (  Select 0 'alterNate', ST.stockid,REPLACE(ST.ItemName,'\"','\\\\\"') ItemName,CONCAT(ST.ItemID,'#',ST.StockID)ItemID ");
                    sb.Append(" ,DATE_FORMAT(st.MedExpiryDate,'%d-%b-%y')Expiry,ST.BatchNumber,");
                    sb.Append("  IFNULL(get_New_PriceByRange(" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + ",IM.SubcategoryID,max(ST.UnitPrice)) ,0)MRP,ST.UnitPrice,Sum(ST.InitialCount - ST.ReleasedCount)AvlQty ,IF(IFNULL(fid.Rack,'')='',im.Rack,fid.Rack)Rack, ");
                    sb.Append(" IF(IFNULL(fid.Shelf,'')='',im.Shelf,fid.Shelf)Shelf,fsm.Name AS Generic ");
                    sb.Append(" FROM f_stock ST INNER JOIN f_itemmaster IM on ST.ItemID=IM.ItemID INNER JOIN f_subcategorymaster sub ON sub.SubcategoryID=IM.SubcategoryID");
                    sb.Append(" INNER JOIN f_configrelation CR on sub.CategoryID = CR.CategoryID ");
                    sb.Append(" INNER JOIN f_item_salt fis ON fis.ItemID=ST.ItemID Inner JOIN f_salt_master ");
                    sb.Append(" fsm ON fis.saltID = fsm.SaltID AND fsm.IsActive=1 ");
                    sb.Append(" LEFT JOIN f_itemmaster_deptwise fid ON fid.ItemID=IM.ItemID AND fid.DeptLedgerNo='" + deptLedgerNo + "' ");
                    sb.Append(" WHERE (ST.InitialCount - ST.ReleasedCount) > 0 AND ST.IsPost = 1 ");

                    if (isBarCodeScan)
                        sb.Append(" AND st.BarCodeID =" + q);
                    else
                        sb.Append(" AND TRIM(fsm.Name)  LIKE '" + q + "%' ");

                    sb.Append(" AND st.DeptLedgerNo='" + deptLedgerNo + "'  AND st.CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " AND IF(IM.IsExpirable<>'NO',DATE(st.MedExpiryDate) >= CURDATE(),'01-Jan-01') AND CR.ConfigID = 11 group by ST.ItemID  ) t");
                    sb.Append(" ORDER BY t." + sort + " " + order + " LIMIT " + Util.GetString(20) + " ");
                }
                else if (type == "3")
                {

                }

                dt = StockReports.GetDataTable(sb.ToString());
            }
            HttpContext.Current.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(dt));
        }
        catch (Exception)
        {

            throw;
        }
    }








    [WebMethod(EnableSession=true)]
    public void medicineItemSearch(string cmd, string type, string deptLedgerNo, string q, string page, string rows, string sort, string order, bool isWithAlternate, bool isBarCodeScan)
    {
        var dt = new System.Data.DataTable();
        try
        {
            //var deptLedgerNo = "LSHHI17";
            if (q != "")
            {
                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                if (type == "1")
                {
                    //--- To Show Stock Only Items-----------
                    //sb.Append("SELECT t.* FROM ( Select 0 'alterNate',ST.UnitType,sub.SubCategoryID,sub.Name SubCategoryName,IM.ConversionFactor, ST.stockid,REPLACE(ST.ItemName,'\"','\\\\\"') ItemName,CONCAT(ST.ItemID,'#',ST.StockID)ItemID ");
                    //sb.Append(" ,DATE_FORMAT(st.MedExpiryDate,'%d-%b-%y')Expiry,st.MedExpiryDate,ST.BatchNumber,");
                    //sb.Append(" ST.MRP,ST.UnitPrice,(ST.InitialCount - ST.ReleasedCount)AvlQty,IF(IFNULL(fid.Rack,'')='',im.Rack,fid.Rack)Rack, ");
                    //sb.Append(" IF(IFNULL(fid.Shelf,'')='',im.Shelf,fid.Shelf)Shelf ");
                    //sb.Append(" ,IFNULL((SELECT SM.Name FROM f_salt_master SM INNER JOIN f_item_salt fis ON fis.saltID=sm.SaltID WHERE fis.ItemID=im.ItemID GROUP BY im.ItemID),'') AS Generic ");
                    //sb.Append(" ,IFNULL((SELECT DISTINCT(mm.Name) from f_itemmaster im inner join f_manufacture_master mm on im.ManufactureID=mm.ManufactureID limit 1),'') AS ManufactureName ");
                    //sb.Append(" FROM f_stock ST INNER JOIN f_itemmaster IM on ST.ItemID=IM.ItemID INNER JOIN f_subcategorymaster sub ON sub.SubcategoryID=IM.SubcategoryID ");
                    //sb.Append(" INNER JOIN f_configrelation CR on sub.CategoryID = CR.CategoryID ");
                    //sb.Append(" LEFT JOIN f_itemmaster_deptwise fid ON fid.ItemID=IM.ItemID AND fid.DeptLedgerNo='" + deptLedgerNo + "' ");
                    //sb.Append(" WHERE (ST.InitialCount - ST.ReleasedCount) > 0 AND ST.IsPost = 1 ");
                    //if (isBarCodeScan)
                    //    sb.Append(" AND st.BarCodeID =" + q);
                    //else
                    //    sb.Append(" AND TRIM(ST.ItemName) LIKE '" + q + "%' ");
                    //sb.Append(" AND st.DeptLedgerNo='" + deptLedgerNo + "' AND st.CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " ");
                    //sb.Append(" AND IF(IM.IsExpirable<>'NO',DATE(st.MedExpiryDate) >= CURDATE(),'01-Jan-01') AND CR.ConfigID = 11 ");
                    //--- To Show All Items with or Without stock-----------
                    sb.Append("SELECT t.* FROM ( SELECT  IFNULL(ST.InitialCount,0) , IFNULL(ST.ReleasedCount,0),sub.NAME,im.ItemCode ,0 'alterNate',IFNULL(IFNULL(ST.UnitType,im.UnitType),'')UnitType,sub.SubCategoryID,sub.Name SubCategoryName,IFNULL(IM.ConversionFactor,1)ConversionFactor, IFNULL(ST.stockid,0)stockid,REPLACE(IFNULL(st.ItemName,im.TypeName),'\"','\\\\\"') ItemName, ");
                    sb.Append("CONCAT(IFNULL(ST.ItemID,im.ItemID),'#',IFNULL(ST.StockID,0))ItemID  ,DATE_FORMAT(IFNULL(st.MedExpiryDate,'3001-01-01'),'%d-%b-%y')Expiry,IFNULL(st.MedExpiryDate,'3001-01-01')MedExpiryDate,IFNULL(ST.BatchNumber,'')BatchNumber, IFNULL(get_New_PriceByRange(" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + ",IM.SubcategoryID,ST.UnitPrice) ,0)MRP,IFNULL(ST.UnitPrice,0)UnitPrice, ");
                    sb.Append("IFNULL((ST.InitialCount - ST.ReleasedCount),0)AvlQty,IF(IFNULL(fid.Rack,'')='',im.Rack,fid.Rack)Rack,  IF(IFNULL(fid.Shelf,'')='',im.Shelf,fid.Shelf)Shelf  , ");
                    sb.Append("IFNULL((SELECT SM.Name FROM f_salt_master SM INNER JOIN f_item_salt fis ON fis.saltID=sm.SaltID WHERE fis.ItemID=im.ItemID GROUP BY im.ItemID),'') AS Generic  , ");
                    sb.Append("IFNULL((SELECT DISTINCT(mm.Name) FROM f_itemmaster im INNER JOIN f_manufacture_master mm ON im.ManufactureID=mm.ManufactureID LIMIT 1),'') AS ManufactureName   ");
                    sb.Append("FROM  f_itemmaster IM  ");
                    sb.Append("LEFT JOIN f_stock ST ON ST.ItemID=IM.ItemID AND st.DeptLedgerNo='" + deptLedgerNo + "' AND IFNULL((ST.InitialCount - ST.ReleasedCount),0)<>'0' ");
                    sb.Append("AND st.CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " AND  (ST.InitialCount - ST.ReleasedCount) > 0 AND ST.IsPost = 1 ");
                    sb.Append("AND IF(IM.IsExpirable<>'NO',DATE(st.MedExpiryDate) >= CURDATE(),'01-Jan-01') ");
                    sb.Append("INNER JOIN f_subcategorymaster sub ON sub.SubcategoryID=IM.SubcategoryID  ");
                    sb.Append(" INNER JOIN f_configrelation CR on sub.CategoryID = CR.CategoryID ");
                    sb.Append(" LEFT JOIN f_itemmaster_deptwise fid ON fid.ItemID=IM.ItemID AND fid.DeptLedgerNo='" + deptLedgerNo + "' ");
                     

                    sb.Append("WHERE cr.ConfigID=11 ");
                    if (isBarCodeScan)
                        sb.Append(" AND st.BarCodeID =" + q);
                    else
                        sb.Append(" AND TRIM(ifnull(ST.ItemName,im.TypeName)) LIKE '%" + q + "%' ");

                    


                    //Alternative Brands 
                    if (isWithAlternate && !isBarCodeScan)
                    {
                        sb.Append(" UNION ALL");
                        sb.Append(" SELECT sub.NAME, im.ItemCode ,1 'alterNate',ST.UnitType,sub.SubCategoryID,sub.Name SubCategoryName,IM.ConversionFactor, ST.stockid,REPLACE(ST.ItemName,'\"','\\\\\"') ItemName,CONCAT(ST.ItemID, '#', ST.StockID) ItemID,DATE_FORMAT(st.MedExpiryDate, '%d-%b-%y') Expiry,st.MedExpiryDate, ");
                        sb.Append(" ST.BatchNumber,IFNULL(get_New_PriceByRange(" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + ",IM.SubcategoryID,ST.UnitPrice) ,0)MRP,ST.UnitPrice,(ST.InitialCount - ST.ReleasedCount) AvlQty, ");
                        sb.Append(" IF(IFNULL(fid.Rack, '') = '',im.Rack,fid.Rack) Rack,IF(IFNULL(fid.Shelf, '') = '',im.Shelf,fid.Shelf ) Shelf, ");
                        sb.Append(" IFNULL((SELECT SM.Name FROM f_salt_master SM INNER JOIN f_item_salt fis ON fis.saltID = sm.SaltID ");
                        sb.Append(" WHERE fis.ItemID = im.ItemID GROUP BY im.ItemID),'') AS Generic ");
                        sb.Append(" ,IFNULL((SELECT DISTINCT(mm.Name) from f_itemmaster im inner join f_manufacture_master mm on im.ManufactureID=mm.ManufactureID limit 1),'') AS ManufactureName ");
                        sb.Append(" FROM f_stock ST ");
                        sb.Append(" INNER JOIN f_itemmaster IM ON ST.ItemID = IM.ItemID INNER JOIN f_subcategorymaster sub ON sub.SubcategoryID = IM.SubcategoryID ");
                        sb.Append(" INNER JOIN f_configrelation CR ON sub.CategoryID = CR.CategoryID LEFT JOIN f_itemmaster_deptwise fid ON fid.ItemID = IM.ItemID ");
                        sb.Append(" AND fid.DeptLedgerNo='" + deptLedgerNo + "'  WHERE (   ST.InitialCount - ST.ReleasedCount) > 0  AND IFNULL((ST.InitialCount - ST.ReleasedCount),0)<>'0' ");
                        sb.Append(" AND ST.IsPost = 1 AND ");
                        sb.Append(" st.ItemID IN( ");
                        sb.Append("     SELECT DISTINCT s.ItemID FROM f_item_salt s WHERE s.saltID IN( ");
                        sb.Append("        SELECT DISTINCT fis.saltID ");
                        sb.Append("         FROM f_item_salt fis ");
                        sb.Append("         INNER JOIN f_itemmaster im ON im.ItemID=fis.ItemID ");
                        sb.Append("     WHERE TRIM(im.TypeName) LIKE '%" + q + "%' ");
                        sb.Append(" ) ) AND st.DeptLedgerNo = '" + deptLedgerNo + "' AND TRIM(st.ItemName) NOT LIKE '%" + q + "%' ");
                        sb.Append(" AND IF(IM.IsExpirable <> 'NO',DATE(st.MedExpiryDate) >= CURDATE(),'01-Jan-01') ");
                        sb.Append(" AND CR.ConfigID = 11 AND st.CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " ");
                    }

                    sb.Append("   ) t");
                    if (sort == "ItemName" && order == "asc")
                        sb.Append("  ORDER BY t.ItemName,t.MedExpiryDate  LIMIT " + rows + " ");
                    else
                        sb.Append("  ORDER BY t." + sort + " " + order + " LIMIT " + Util.GetString(20) + " ");

                }
                else if (type == "2")
                {
                    sb.Append("SELECT t.* FROM (  Select  sub.NAME,im.ItemCode ,0 'alterNate',ST.UnitType,sub.SubCategoryID,sub.Name SubCategoryName, ST.stockid,IM.ConversionFactor,REPLACE(ST.ItemName,'\"','\\\\\"') ItemName,CONCAT(ST.ItemID,'#',ST.StockID)ItemID ");
                    sb.Append(" ,DATE_FORMAT(st.MedExpiryDate,'%d-%b-%y')Expiry,ST.BatchNumber,st.MedExpiryDate, ");
                    sb.Append(" IFNULL(get_New_PriceByRange(" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + ",IM.SubcategoryID,ST.UnitPrice) ,0)MRP,ST.UnitPrice,(ST.InitialCount - ST.ReleasedCount)AvlQty ,IF(IFNULL(fid.Rack,'')='',im.Rack,fid.Rack)Rack, ");
                    sb.Append(" IF(IFNULL(fid.Shelf,'')='',im.Shelf,fid.Shelf)Shelf,fsm.Name AS Generic ");
                    sb.Append(" ,IFNULL((SELECT DISTINCT(mm.Name) from f_itemmaster im inner join f_manufacture_master mm on im.ManufactureID=mm.ManufactureID limit 1),'') AS ManufactureName ");
                    sb.Append(" FROM f_stock ST INNER JOIN f_itemmaster IM on ST.ItemID=IM.ItemID INNER JOIN f_subcategorymaster sub ON sub.SubcategoryID=IM.SubcategoryID");
                    sb.Append(" INNER JOIN f_configrelation CR on sub.CategoryID = CR.CategoryID ");
                    sb.Append(" INNER JOIN f_item_salt fis ON fis.ItemID=ST.ItemID Inner JOIN f_salt_master ");
                    sb.Append(" fsm ON fis.saltID = fsm.SaltID AND fsm.IsActive=1 ");
                    sb.Append(" LEFT JOIN f_itemmaster_deptwise fid ON fid.ItemID=IM.ItemID AND fid.DeptLedgerNo='" + deptLedgerNo + "' ");
                    sb.Append(" WHERE (ST.InitialCount - ST.ReleasedCount) > 0 AND ST.IsPost = 1 ");

                    if (isBarCodeScan)
                        sb.Append(" AND st.BarCodeID =" + q);
                    else
                        sb.Append(" AND TRIM(fsm.Name)  LIKE '%" + q + "%' ");

                    sb.Append(" AND st.DeptLedgerNo='" + deptLedgerNo + "' AND st.CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " AND IF(IM.IsExpirable<>'NO',DATE(st.MedExpiryDate) >= CURDATE(),'01-Jan-01') AND CR.ConfigID = 11 ) t");
                    if (sort == "ItemName" && order == "asc")
                        sb.Append("  ORDER BY t.ItemName,t.MedExpiryDate  LIMIT " + rows + " ");
                    else
                        sb.Append("  ORDER BY t." + sort + " " + order + " LIMIT " + rows + " ");
                }
                else if (type == "3")
                {
                 sb.Append("SELECT t.* FROM ( SELECT  sub.NAME,im.ItemCode ,0 'alterNate',IFNULL(IFNULL(ST.UnitType,im.UnitType),'')UnitType,sub.SubCategoryID,sub.Name SubCategoryName,IFNULL(IM.ConversionFactor,1)ConversionFactor, IFNULL(ST.stockid,0)stockid,REPLACE(IFNULL(st.ItemName,im.TypeName),'\"','\\\\\"') ItemName, ");
                 sb.Append("CONCAT(IFNULL(ST.ItemID,im.ItemID),'#',IFNULL(ST.StockID,0))ItemID  ,DATE_FORMAT(IFNULL(st.MedExpiryDate,'3001-01-01'),'%d-%b-%y')Expiry,IFNULL(st.MedExpiryDate,'3001-01-01')MedExpiryDate,IFNULL(ST.BatchNumber,'')BatchNumber,IFNULL(get_New_PriceByRange(" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + ",IM.SubcategoryID,ST.UnitPrice) ,0)MRP,IFNULL(ST.UnitPrice,0)UnitPrice, ");
                    sb.Append("IFNULL((ST.InitialCount - ST.ReleasedCount),0)AvlQty,IF(IFNULL(fid.Rack,'')='',im.Rack,fid.Rack)Rack,  IF(IFNULL(fid.Shelf,'')='',im.Shelf,fid.Shelf)Shelf  , ");
                    sb.Append("IFNULL((SELECT SM.Name FROM f_salt_master SM INNER JOIN f_item_salt fis ON fis.saltID=sm.SaltID WHERE fis.ItemID=im.ItemID GROUP BY im.ItemID),'') AS Generic  , ");
                    sb.Append("IFNULL((SELECT DISTINCT(mm.Name) FROM f_itemmaster im INNER JOIN f_manufacture_master mm ON im.ManufactureID=mm.ManufactureID LIMIT 1),'') AS ManufactureName   ");
                    sb.Append("FROM  f_itemmaster IM  ");
                    sb.Append("LEFT JOIN f_stock ST ON ST.ItemID=IM.ItemID AND st.DeptLedgerNo='" + deptLedgerNo + "'  ");
                    sb.Append("AND st.CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " AND  (ST.InitialCount - ST.ReleasedCount) > 0 AND ST.IsPost = 1 ");
                    sb.Append("AND IF(IM.IsExpirable<>'NO',DATE(st.MedExpiryDate) >= CURDATE(),'01-Jan-01') ");
                    sb.Append("INNER JOIN f_subcategorymaster sub ON sub.SubcategoryID=IM.SubcategoryID  ");
                    sb.Append(" INNER JOIN f_configrelation CR on sub.CategoryID = CR.CategoryID ");
                    sb.Append(" LEFT JOIN f_itemmaster_deptwise fid ON fid.ItemID=IM.ItemID AND fid.DeptLedgerNo='" + deptLedgerNo + "' ");
                     

                    sb.Append("WHERE cr.ConfigID=11 ");
                    if (isBarCodeScan)
                        sb.Append(" AND st.BarCodeID =" + q);
                    else
                        sb.Append(" AND TRIM(ifnull(IM.ItemCode,im.TypeName)) LIKE '%" + q + "%' ");

                    


                    //Alternative Brands 
                    if (isWithAlternate && !isBarCodeScan)
                    {
                        sb.Append(" UNION ALL");
                        sb.Append(" SELECT  sub.NAME,im.ItemCode ,1 'alterNate',ST.UnitType,sub.SubCategoryID,sub.Name SubCategoryName,IM.ConversionFactor, ST.stockid,REPLACE(ST.ItemName,'\"','\\\\\"') ItemName,CONCAT(ST.ItemID, '#', ST.StockID) ItemID,DATE_FORMAT(st.MedExpiryDate, '%d-%b-%y') Expiry,st.MedExpiryDate, ");
                        sb.Append(" ST.BatchNumber,IFNULL(get_New_PriceByRange(" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + ",IM.SubcategoryID,ST.UnitPrice) ,0)MRP,ST.UnitPrice,(ST.InitialCount - ST.ReleasedCount) AvlQty, ");
                        sb.Append(" IF(IFNULL(fid.Rack, '') = '',im.Rack,fid.Rack) Rack,IF(IFNULL(fid.Shelf, '') = '',im.Shelf,fid.Shelf ) Shelf, ");
                        sb.Append(" IFNULL((SELECT SM.Name FROM f_salt_master SM INNER JOIN f_item_salt fis ON fis.saltID = sm.SaltID ");
                        sb.Append(" WHERE fis.ItemID = im.ItemID GROUP BY im.ItemID),'') AS Generic ");
                        sb.Append(" ,IFNULL((SELECT DISTINCT(mm.Name) from f_itemmaster im inner join f_manufacture_master mm on im.ManufactureID=mm.ManufactureID limit 1),'') AS ManufactureName ");
                        sb.Append(" FROM f_stock ST ");
                        sb.Append(" INNER JOIN f_itemmaster IM ON ST.ItemID = IM.ItemID INNER JOIN f_subcategorymaster sub ON sub.SubcategoryID = IM.SubcategoryID ");
                        sb.Append(" INNER JOIN f_configrelation CR ON sub.CategoryID = CR.CategoryID LEFT JOIN f_itemmaster_deptwise fid ON fid.ItemID = IM.ItemID ");
                        sb.Append(" AND fid.DeptLedgerNo='" + deptLedgerNo + "'  WHERE (   ST.InitialCount - ST.ReleasedCount) > 0 ");
                        sb.Append(" AND ST.IsPost = 1 AND ");
                        sb.Append(" st.ItemID IN( ");
                        sb.Append("     SELECT DISTINCT s.ItemID FROM f_item_salt s WHERE s.saltID IN( ");
                        sb.Append("        SELECT DISTINCT fis.saltID ");
                        sb.Append("         FROM f_item_salt fis ");
                        sb.Append("         INNER JOIN f_itemmaster im ON im.ItemID=fis.ItemID ");
                        sb.Append("     WHERE TRIM(im.TypeName) LIKE '%" + q + "%' ");
                        sb.Append(" ) ) AND st.DeptLedgerNo = '" + deptLedgerNo + "' AND TRIM(im.ItemCode) NOT LIKE '%" + q + "%' ");
                        sb.Append(" AND IF(IM.IsExpirable <> 'NO',DATE(st.MedExpiryDate) >= CURDATE(),'01-Jan-01') ");
                        sb.Append(" AND CR.ConfigID = 11 AND st.CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " ");
                    }

                    sb.Append("   ) t");
                    if (sort == "ItemName" && order == "asc")
                        sb.Append("  ORDER BY t.ItemName,t.MedExpiryDate  LIMIT " + rows + " ");
                    else
                        sb.Append("  ORDER BY t." + sort + " " + order + " LIMIT " + Util.GetString(20) + " ");

                }
               else if (type == "4")
                {
                 sb.Append("SELECT t.* FROM ( SELECT  sub.NAME,im.ItemCode ,0 'alterNate',IFNULL(IFNULL(ST.UnitType,im.UnitType),'')UnitType,sub.SubCategoryID,sub.Name SubCategoryName,IFNULL(IM.ConversionFactor,1)ConversionFactor, IFNULL(ST.stockid,0)stockid,REPLACE(IFNULL(st.ItemName,im.TypeName),'\"','\\\\\"') ItemName, ");
                 sb.Append("CONCAT(IFNULL(ST.ItemID,im.ItemID),'#',IFNULL(ST.StockID,0))ItemID  ,DATE_FORMAT(IFNULL(st.MedExpiryDate,'3001-01-01'),'%d-%b-%y')Expiry,IFNULL(st.MedExpiryDate,'3001-01-01')MedExpiryDate,IFNULL(ST.BatchNumber,'')BatchNumber,IFNULL(get_New_PriceByRange(" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + ",IM.SubcategoryID,ST.UnitPrice) ,0)MRP,IFNULL(ST.UnitPrice,0)UnitPrice, ");
                    sb.Append("IFNULL((ST.InitialCount - ST.ReleasedCount),0)AvlQty,IF(IFNULL(fid.Rack,'')='',im.Rack,fid.Rack)Rack,  IF(IFNULL(fid.Shelf,'')='',im.Shelf,fid.Shelf)Shelf  , ");
                    sb.Append("IFNULL((SELECT SM.Name FROM f_salt_master SM INNER JOIN f_item_salt fis ON fis.saltID=sm.SaltID WHERE fis.ItemID=im.ItemID GROUP BY im.ItemID),'') AS Generic  , ");
                    sb.Append("IFNULL((SELECT DISTINCT(mm.Name) FROM f_itemmaster im INNER JOIN f_manufacture_master mm ON im.ManufactureID=mm.ManufactureID LIMIT 1),'') AS ManufactureName   ");
                    sb.Append("FROM  f_itemmaster IM  ");
                    sb.Append("LEFT JOIN f_stock ST ON ST.ItemID=IM.ItemID AND st.DeptLedgerNo='" + deptLedgerNo + "'  ");
                    sb.Append("AND st.CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " AND  (ST.InitialCount - ST.ReleasedCount) > 0 AND ST.IsPost = 1 ");
                    sb.Append("AND IF(IM.IsExpirable<>'NO',DATE(st.MedExpiryDate) >= CURDATE(),'01-Jan-01') ");
                    sb.Append("INNER JOIN f_subcategorymaster sub ON sub.SubcategoryID=IM.SubcategoryID  ");
                    sb.Append(" INNER JOIN f_configrelation CR on sub.CategoryID = CR.CategoryID ");
                    sb.Append(" LEFT JOIN f_itemmaster_deptwise fid ON fid.ItemID=IM.ItemID AND fid.DeptLedgerNo='" + deptLedgerNo + "' ");
                     

                    sb.Append("WHERE cr.ConfigID=11 ");
                    if (isBarCodeScan)
                        sb.Append(" AND st.BarCodeID =" + q);
                    else
                        sb.Append(" AND TRIM(ifnull(sub.NAME,im.TypeName)) LIKE '%" + q + "%' ");

                    


                    //Alternative Brands 
                    if (isWithAlternate && !isBarCodeScan)
                    {
                        sb.Append(" UNION ALL");
                        sb.Append(" SELECT  sub.NAME,im.ItemCode ,1 'alterNate',ST.UnitType,sub.SubCategoryID,sub.Name SubCategoryName,IM.ConversionFactor, ST.stockid,REPLACE(ST.ItemName,'\"','\\\\\"') ItemName,CONCAT(ST.ItemID, '#', ST.StockID) ItemID,DATE_FORMAT(st.MedExpiryDate, '%d-%b-%y') Expiry,st.MedExpiryDate, ");
                        sb.Append(" ST.BatchNumber,IFNULL(get_New_PriceByRange(" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + ",IM.SubcategoryID,ST.UnitPrice) ,0)MRP,ST.UnitPrice,(ST.InitialCount - ST.ReleasedCount) AvlQty, ");
                        sb.Append(" IF(IFNULL(fid.Rack, '') = '',im.Rack,fid.Rack) Rack,IF(IFNULL(fid.Shelf, '') = '',im.Shelf,fid.Shelf ) Shelf, ");
                        sb.Append(" IFNULL((SELECT SM.Name FROM f_salt_master SM INNER JOIN f_item_salt fis ON fis.saltID = sm.SaltID ");
                        sb.Append(" WHERE fis.ItemID = im.ItemID GROUP BY im.ItemID),'') AS Generic ");
                        sb.Append(" ,IFNULL((SELECT DISTINCT(mm.Name) from f_itemmaster im inner join f_manufacture_master mm on im.ManufactureID=mm.ManufactureID limit 1),'') AS ManufactureName ");
                        sb.Append(" FROM f_stock ST ");
                        sb.Append(" INNER JOIN f_itemmaster IM ON ST.ItemID = IM.ItemID INNER JOIN f_subcategorymaster sub ON sub.SubcategoryID = IM.SubcategoryID ");
                        sb.Append(" INNER JOIN f_configrelation CR ON sub.CategoryID = CR.CategoryID LEFT JOIN f_itemmaster_deptwise fid ON fid.ItemID = IM.ItemID ");
                        sb.Append(" AND fid.DeptLedgerNo='" + deptLedgerNo + "'  WHERE (   ST.InitialCount - ST.ReleasedCount) > 0 ");
                        sb.Append(" AND ST.IsPost = 1 AND ");
                        sb.Append(" st.ItemID IN( ");
                        sb.Append("     SELECT DISTINCT s.ItemID FROM f_item_salt s WHERE s.saltID IN( ");
                        sb.Append("        SELECT DISTINCT fis.saltID ");
                        sb.Append("         FROM f_item_salt fis ");
                        sb.Append("         INNER JOIN f_itemmaster im ON im.ItemID=fis.ItemID ");
                        sb.Append("     WHERE TRIM(im.TypeName) LIKE '%" + q + "%' ");
                        sb.Append(" ) ) AND st.DeptLedgerNo = '" + deptLedgerNo + "' AND TRIM(sub.NAME) NOT LIKE '%" + q + "%' ");
                        sb.Append(" AND IF(IM.IsExpirable <> 'NO',DATE(st.MedExpiryDate) >= CURDATE(),'01-Jan-01') ");
                        sb.Append(" AND CR.ConfigID = 11 AND st.CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " ");
                    }

                    sb.Append("   ) t");
                    if (sort == "ItemName" && order == "asc")
                        sb.Append("  ORDER BY t.ItemName,t.MedExpiryDate  LIMIT " + rows + " ");
                    else
                        sb.Append("  ORDER BY t." + sort + " " + order + " LIMIT " + Util.GetString(20) + " ");

                }


                dt = StockReports.GetDataTable(sb.ToString());
            }
            HttpContext.Current.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(dt));
        }
        catch (Exception)
        {

            throw;
        }
    }



    [WebMethod]
    public string GetPatientIndent(string deptLedgerNo, string IPDNO, string MRNO, string fromDate, string toDate, string indentID, string searchType, int demandDraftID)
    {

        if (demandDraftID > 0)
        {

            var sqlCMD = new StringBuilder("SELECT DATE_FORMAT(dm.CreatedOn,'%d-%b-%Y')CreatedOn, CONCAT(em.Title,' ',em.Name) EmployeeName ,COUNT(*) MedicineCount,dm.ID   ");
            sqlCMD.Append(" FROM store_demand_draft dm ");
            sqlCMD.Append(" INNER JOIN store_demand_draft_details sdd on sdd.DraftID=dm.ID ");
            sqlCMD.Append(" INNER JOIN employee_master em ON em.EmployeeID=dm.CreatedBy  ");
            sqlCMD.Append(" WHERE dm.ID=@demandDraftID AND (sdd.Quantity-sdd.ReceiveQty)>0 ");

            ExcuteCMD excuteCMD = new ExcuteCMD();
            DataTable dataTable = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
            {
                demandDraftID = demandDraftID
            });


            return Newtonsoft.Json.JsonConvert.SerializeObject(dataTable);
        }





        if (searchType == "Indend")
        {
            var sqlCmd = new StringBuilder(" SELECT *,IF(StatusNew='OPEN' OR StatusNew='PARTIAL','true','false')VIEW FROM (  ");
            sqlCmd.Append("     SELECT t.*,(CASE WHEN t.reqQty=t.RejectQty THEN 'REJECT' WHEN  t.reqQty-t.ReceiveQty-t.RejectQty=0 THEN 'CLOSE'  ");
            sqlCmd.Append("     WHEN   t.reqQty+t.ReceiveQty+t.RejectQty=t.reqQty THEN 'OPEN' ELSE 'PARTIAL'  END)StatusNew  ");
            sqlCmd.Append("     FROM ( ");
            sqlCmd.Append("     SELECT id.indentno,ifnull(rqt.TypeName,'') as IndentType,DATE_FORMAT(id.dtentry,'%d-%b-%y')dtEntry, ");
            sqlCmd.Append("     (SELECT ledgername FROM f_ledgermaster WHERE LedgerNumber = id.Deptfrom)DeptFrom ,id.Status, ");
            sqlCmd.Append("     pmh.TransNo as IPDNo,id.TransactionID,pm.PatientID,pm.PName,id.DoctorID, ");
            sqlCmd.Append("     IFNULL(id.IPDCaseTypeID,'')IPDCaseTypeID,IFNULL(id.RoomID,'')RoomID, ");
            sqlCmd.Append("     (SELECT NAME FROM employee_master WHERE EmployeeID=id.userid)UserName, ");
            sqlCmd.Append("     SUM(ReqQty)ReqQty,SUM(ReceiveQty)ReceiveQty,SUM(RejectQty)RejectQty ");
            sqlCmd.Append("     FROM f_indent_detail_patient id INNER JOIN patient_medical_history pmh on pmh.TransactionID=id.TransactionID LEFT JOIN f_typemaster Rqt on rqt.TypeID=id.IndentType INNER JOIN patient_master pm ON id.PatientID = pm.PatientID ");
            sqlCmd.Append("     WHERE ");

            if (indentID != string.Empty)
                sqlCmd.Append("  id.indentno='" + indentID + "' ");
            else
                sqlCmd.Append("  DATE(id.dtEntry) >=@fromDate AND DATE(id.dtEntry) <=@toDate ");
            
            sqlCmd.Append("     AND id.TransactionID=@transactionID ");
            sqlCmd.Append("     AND id.storeid='STO00001' ");
            sqlCmd.Append("     and id.deptto = @deptLedgerNo ");
            sqlCmd.Append("     GROUP BY IndentNo ");
            sqlCmd.Append(" )t ");
            sqlCmd.Append(" )t1");

            ExcuteCMD excuteCMD = new ExcuteCMD();
            DataTable dataTable = excuteCMD.GetDataTable(sqlCmd.ToString(), CommandType.Text, new
            {
                fromDate = Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"),
                toDate = Util.GetDateTime(toDate).ToString("yyyy-MM-dd"),
                transactionID = IPDNO,
                deptLedgerNo = deptLedgerNo
            });
            return Newtonsoft.Json.JsonConvert.SerializeObject(dataTable);
        }
        else
        {
            var sqlCmd = new StringBuilder();
            sqlCmd.Append(" SELECT * FROM ( "); 
              
            sqlCmd.Append(" SELECT * FROM ( ");
            sqlCmd.Append(" SELECT DATE_FORMAT(pm.Date,'%d-%b-%Y')`Date`,pm.DoctorID,@patientID patientID,(SELECT CONCAT(dm.Title,'' ,dm.Name) FROM doctor_master dm WHERE dm.DoctorID=pm.DoctorID)DName,COUNT(pm.Medicine_ID) NoOfMedicine,(SELECT (rm.RoleName)RoleName FROM f_rolemaster rm  WHERE rm.ID=pm.DocRoleId  GROUP BY  rm.ID) ToDepartment,'Orange' as status FROM patient_medicine pm ");
            sqlCmd.Append(" WHERE  pm.PatientID = @patientID  AND IFNULL(pm.RefealVal,0)=0 AND DATE(pm.Date) >= @fromDate   AND DATE(pm.Date) <= @toDate and pm.IsActive=1");
            sqlCmd.Append(" GROUP BY pm.Date,pm.DoctorID,pm.PatientID");
            sqlCmd.Append(" ) t ");
            
            sqlCmd.Append("  UNION ALL ");
            // 
            sqlCmd.Append(" SELECT *,'White' as status FROM ( ");
            sqlCmd.Append(" SELECT DATE_FORMAT(pm.Date,'%d-%b-%Y')`Date`,pm.DoctorID,@patientID patientID,(SELECT CONCAT(dm.Title,'' ,dm.Name) FROM doctor_master dm WHERE dm.DoctorID=pm.DoctorID)DName,COUNT(pm.Medicine_ID) NoOfMedicine,(SELECT (rm.RoleName)RoleName FROM f_rolemaster rm  WHERE rm.ID=pm.DocRoleId  GROUP BY  rm.ID) ToDepartment FROM patient_medicine pm ");
            sqlCmd.Append(" WHERE  pm.PatientID = @patientID AND IFNULL(pm.RefealVal,0)>0  AND date(pm.RefealTillDate)>=date(NOW()) and pm.IsActive=1 ");
            sqlCmd.Append(" GROUP BY pm.Date,pm.DoctorID,pm.PatientID");
            sqlCmd.Append(" ) tt ");

            sqlCmd.Append(" )ttt  GROUP BY ttt.Date,ttt.DoctorID,ttt.PatientID ");
            ExcuteCMD excuteCMD = new ExcuteCMD();
            DataTable dataTable = excuteCMD.GetDataTable(sqlCmd.ToString(), CommandType.Text, new
            {
                fromDate = Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"),
                toDate = Util.GetDateTime(toDate).ToString("yyyy-MM-dd"),
                patientID = MRNO,
            });
            return Newtonsoft.Json.JsonConvert.SerializeObject(dataTable);
        }



    }


    [WebMethod(EnableSession=true)]
    public string GetIndentItemsStockDetails(string indentNo, string deptLedgerNo)
    {
        var sqlCmd = new StringBuilder("SELECT 'IPD' SearchType,0 CanRefil,'' RefealVal,IFNULL( tdm.DurationName,'') DurationName,IFNULL(tdm.IntervalName,'')IntervalName,IFNULL(tdm.DoseTime,'')TimetoGive,CONCAT( IFNULL(tdm.Dose,''),'',IFNULL(tdm.DoseUnit,''))Dose ,0 draftID, ST.stockid,IM.TypeName ItemName,fid.ItemID,fid.IndentNo,'' patientMedicine, fid.ReqQty TotalReqQty,(fid.ReqQty-fid.ReceiveQty) ReqQty,fid.RejectQty,fid.ReceiveQty,ST.BatchNumber,IFNULL(get_New_PriceByRange(" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + ",IM.SubcategoryID,ST.UnitPrice) ,0)MRP,ST.UnitPrice,(ST.InitialCount - ST.ReleasedCount) AvlQty,IM.SubCategoryID,im.isexpirable,DATE_FORMAT(ST.MedExpiryDate, '%d-%b-%Y') MedExpiryDate,");
        sqlCmd.Append("ST.UnitType,im.ToBeBilled,ST.HSNCode,ST.IGSTPercent,ST.IGSTAmtPerUnit,ST.SGSTPercent,ST.SGSTAmtPerUnit,ST.CGSTPercent,ST.CGSTAmtPerUnit,ST.GSTType,im.Type_ID,im.IsUsable,im.ServiceItemID,'0' NewAvlQty,'' IssueQty,0 IssueChecked,st.PurTaxPer ");
        sqlCmd.Append("FROM f_indent_detail_patient fid ");
        sqlCmd.Append("INNER JOIN f_itemmaster IM  ON im.ItemID=fid.ItemId ");
        sqlCmd.Append("INNER JOIN f_subcategorymaster sub  ");
        sqlCmd.Append("ON sub.SubcategoryID = IM.SubcategoryID ");
        sqlCmd.Append("INNER JOIN f_configrelation CR  ");
        sqlCmd.Append("ON sub.CategoryID = CR.CategoryID  ");
        sqlCmd.Append("LEFT JOIN f_stock ST ON st.ItemID=im.ItemID AND (ST.InitialCount - ST.ReleasedCount) > 0 AND ST.IsPost = 1 AND st.DeptLedgerNo = @deptLedgerNo   AND (IF(im.IsExpirable = 'NO','2050-01-01',st.MedExpiryDate) > CURDATE())  AND st.CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " ");

        sqlCmd.Append(" LEFT JOIN tenwek_docotor_medicine_order tdm on tdm.IndentNo=fid.IndentNo AND fid.ItemID=tdm.ItemId AND fid.TransactionID=tdm.TransactionId");
        sqlCmd.Append(" WHERE  CR.ConfigID = 11 AND IM.ItemID = fid.ItemId ");
        sqlCmd.Append(" AND fid.IndentNo=@indentNo AND fid.ReqQty>(fid.RejectQty+fid.ReceiveQty)");
        sqlCmd.Append(" ORDER BY  IM.TypeName,st.MedExpiryDate  ");
        ExcuteCMD excuteCMD = new ExcuteCMD();


        DataTable dataTable = excuteCMD.GetDataTable(sqlCmd.ToString(), CommandType.Text, new
        {
            indentNo = indentNo,
            deptLedgerNo = deptLedgerNo
        });

        string s = excuteCMD.GetRowQuery(sqlCmd.ToString(), new
               {
                   indentNo = indentNo,
                   deptLedgerNo = deptLedgerNo
               });

      //  return Newtonsoft.Json.JsonConvert.SerializeObject(s);

        return Newtonsoft.Json.JsonConvert.SerializeObject(dataTable);
    }


    [WebMethod(EnableSession=true)]
    public string GetPrescribedItemStockDetails(string date, string patientID, string doctorID, string deptLedgerNo)
    {

        var sqlCmd = new StringBuilder();


        sqlCmd.Append(" SELECT * FROM ( ");
        sqlCmd.Append(" SELECT 'OPD' SearchType,   IF(IFNULL(fid.RefealVal,0)=0,0,IF(IFNULL(fid.RefealTillDate,'')='',0, IF( DATE( fid.RefealTillDate)>=DATE(NOW()),1,0)))CanRefil,fid.RefealVal,fid.DurationName,fid.IntervalName,fid.TimetoGive,concat(fid.Dose,'',fid.Unit)Dose,0 draftID,ST.stockid, IM.TypeName ItemName, im.ItemID, fid.PatientMedicine_ID IndentNo, fid.PatientMedicine_ID  patientMedicine, fid.OrderQuantity TotalReqQty, fid.OrderQuantity ReqQty, 0 RejectQty, fid.IssueQuantity ReceiveQty, ST.BatchNumber, IFNULL(get_New_PriceByRange(" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + ",IM.SubcategoryID,ST.UnitPrice) ,0)MRP, ST.UnitPrice, ( ST.InitialCount - ST.ReleasedCount ) AvlQty, IM.SubCategoryID, im.isexpirable, DATE_FORMAT(ST.MedExpiryDate, '%d-%b-%Y') MedExpiryDate, ST.UnitType, im.ToBeBilled, ST.HSNCode, ST.IGSTPercent, ST.IGSTAmtPerUnit, ST.SGSTPercent, ST.SGSTAmtPerUnit, ST.CGSTPercent, ST.CGSTAmtPerUnit, ST.GSTType, im.Type_ID, im.IsUsable, im.ServiceItemID, '0' NewAvlQty, '' IssueQty, 0 IssueChecked, st.PurTaxPer,IFNULL(fid.Remarks,'')DrRemarks FROM patient_medicine fid INNER JOIN f_itemmaster IM ON im.ItemID = fid.Medicine_ID INNER JOIN f_subcategorymaster sub ON sub.SubcategoryID = IM.SubcategoryID INNER JOIN f_configrelation CR ON sub.CategoryID = CR.CategoryID LEFT JOIN f_stock ST ON st.ItemID = im.ItemID AND ( ST.InitialCount - ST.ReleasedCount ) > 0 AND ST.IsPost = 1 AND st.DeptLedgerNo = @deptLedgerNo   AND st.CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " AND ( IF( im.IsExpirable = 'NO', '2050-01-01', st.MedExpiryDate ) > CURDATE() ) ");
        sqlCmd.Append(" WHERE CR.ConfigID = 11 AND IFNULL(fid.RefealVal,0)=0 AND fid.DoctorID=@doctorID AND fid.PatientID=@patientID and fid.IsActive=1 AND Date(fid.Date)=@date     GROUP BY fid.PatientMedicine_ID ORDER BY  IM.TypeName, st.MedExpiryDate ");
        sqlCmd.Append(" )t ");

        sqlCmd.Append("  UNION ALL ");
        sqlCmd.Append(" SELECT  * FROM ( ");
        sqlCmd.Append(" SELECT  'OPD' SearchType, IF(IFNULL(fid.RefealVal,0)=0,0,IF(IFNULL(fid.RefealTillDate,'')='',0, IF( DATE( fid.RefealTillDate)>=DATE(NOW()),1,0)))CanRefil,fid.RefealVal,fid.DurationName,fid.IntervalName,fid.TimetoGive,concat(fid.Dose,'',fid.Unit)Dose,0 draftID,ST.stockid, IM.TypeName ItemName, im.ItemID, fid.PatientMedicine_ID IndentNo, fid.PatientMedicine_ID  patientMedicine, fid.OrderQuantity TotalReqQty, fid.OrderQuantity ReqQty, 0 RejectQty, fid.IssueQuantity ReceiveQty, ST.BatchNumber, IFNULL(get_New_PriceByRange(" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + ",IM.SubcategoryID,ST.UnitPrice) ,0)MRP, ST.UnitPrice, ( ST.InitialCount - ST.ReleasedCount ) AvlQty, IM.SubCategoryID, im.isexpirable, DATE_FORMAT(ST.MedExpiryDate, '%d-%b-%Y') MedExpiryDate, ST.UnitType, im.ToBeBilled, ST.HSNCode, ST.IGSTPercent, ST.IGSTAmtPerUnit, ST.SGSTPercent, ST.SGSTAmtPerUnit, ST.CGSTPercent, ST.CGSTAmtPerUnit, ST.GSTType, im.Type_ID, im.IsUsable, im.ServiceItemID, '0' NewAvlQty, '' IssueQty, 0 IssueChecked, st.PurTaxPer,IFNULL(fid.Remarks,'')DrRemarks FROM patient_medicine fid INNER JOIN f_itemmaster IM ON im.ItemID = fid.Medicine_ID INNER JOIN f_subcategorymaster sub ON sub.SubcategoryID = IM.SubcategoryID INNER JOIN f_configrelation CR ON sub.CategoryID = CR.CategoryID LEFT JOIN f_stock ST ON st.ItemID = im.ItemID AND ( ST.InitialCount - ST.ReleasedCount ) > 0 AND ST.IsPost = 1 AND st.DeptLedgerNo = @deptLedgerNo  AND st.CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " AND ( IF( im.IsExpirable = 'NO', '2050-01-01', st.MedExpiryDate ) > CURDATE() ) ");
        sqlCmd.Append(" WHERE CR.ConfigID = 11 AND IFNULL(fid.RefealVal,0)>0 AND fid.DoctorID=@doctorID AND fid.PatientID=@patientID and fid.IsActive=1 AND date(fid.RefealTillDate)>=date(NOW())  GROUP BY fid.PatientMedicine_ID ORDER BY  IM.TypeName, st.MedExpiryDate ");
        sqlCmd.Append(" )tt ");
        
        
        ExcuteCMD excuteCMD = new ExcuteCMD();
        DataTable dataTable = excuteCMD.GetDataTable(sqlCmd.ToString(), CommandType.Text, new
        {
            doctorID = doctorID,
            patientID = patientID,
            date = Util.GetDateTime(date).ToString("yyyy-MM-dd"),
            deptLedgerNo = deptLedgerNo,
            
        });
        return Newtonsoft.Json.JsonConvert.SerializeObject(dataTable);

    }


    [WebMethod(EnableSession = true)]
    public string RejectIndentItem(string indentID, string itemID, string rejectReason)
    {
        try
        {
            var sqlCmd = new StringBuilder("UPDATE f_indent_detail_patient fid SET fid.RejectQty= (fid.ReqQty-fid.ReceiveQty),fid.RejectReason=@rejectReason,fid.RejectBy=@rejectBy,fid.dtReject=@rejectOn  ");
            if (string.IsNullOrEmpty(itemID))
                sqlCmd.Append(" WHERE  fid.IndentNo=@indentID ");
            else
                sqlCmd.Append(" WHERE fid.IndentNo=@indentID  AND fid.ItemId=@itemID ");

            ExcuteCMD excuteCMD = new ExcuteCMD();
            excuteCMD.DML(sqlCmd.ToString(), CommandType.Text, new
            {
                rejectReason = rejectReason,
                rejectBy = HttpContext.Current.Session["id"].ToString(),
                rejectOn = System.DateTime.Now.ToString("yyyy-MM-dd"),
                indentID = indentID,
                itemID = itemID
            });
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = "" });
        }
        catch (Exception ex)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Error occurred, Please contact administrator", response = ex.Message });
        }
    }

    [WebMethod(EnableSession=true)]
    public string GetItemByBarCode(string deptLedgerNo, string barcodeNumber)
    {
        var sqlCmd = new StringBuilder(" SELECT ST.stockid,IM.TypeName ItemName,ST.ItemID,ST.BatchNumber,IFNULL(get_New_PriceByRange(" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + ",IM.SubcategoryID,ST.UnitPrice) ,0)MRP,ST.UnitPrice,(ST.InitialCount - ST.ReleasedCount) AvlQty, ");
        sqlCmd.Append(" IM.SubCategoryID,im.isexpirable,DATE_FORMAT(ST.MedExpiryDate, '%d-%b-%Y') MedExpiryDate,ST.UnitType,im.ToBeBilled,ST.HSNCode,ST.IGSTPercent,ST.IGSTAmtPerUnit, ");
        sqlCmd.Append("ST.SGSTPercent,ST.SGSTAmtPerUnit,ST.CGSTPercent,ST.CGSTAmtPerUnit,ST.GSTType,im.Type_ID,im.IsUsable,im.ServiceItemID,'0' NewAvlQty,'' IssueQty,0 IssueChecked,st.PurTaxPer ");
        sqlCmd.Append("FROM f_stock ST ");
        sqlCmd.Append("INNER JOIN f_itemmaster IM  ");
        sqlCmd.Append("ON ST.ItemID = IM.ItemID ");
        sqlCmd.Append("INNER JOIN f_subcategorymaster sub  ");
        sqlCmd.Append("ON sub.SubcategoryID = IM.SubcategoryID ");
        sqlCmd.Append("INNER JOIN f_configrelation CR  ");
        sqlCmd.Append("ON sub.CategoryID = CR.CategoryID  ");
        sqlCmd.Append("WHERE (ST.InitialCount - ST.ReleasedCount) > 0 ");
        sqlCmd.Append("AND ST.IsPost = 1  ");
        sqlCmd.Append("AND CR.ConfigID = 11  ");
        sqlCmd.Append("AND st.BarcodeID=@barcode ");
        sqlCmd.Append("AND st.DeptLedgerNo = @deptLedgerNo  AND st.CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " ");
        sqlCmd.Append("AND (IF(im.IsExpirable = 'NO','2050-01-01',st.MedExpiryDate) > CURDATE())  ");
        sqlCmd.Append("ORDER BY st.MedExpiryDate ");

        ExcuteCMD excuteCMD = new ExcuteCMD();
        DataTable dataTable = excuteCMD.GetDataTable(sqlCmd.ToString(), CommandType.Text, new
        {
            deptLedgerNo = deptLedgerNo,
            barcode = barcodeNumber
        });
        return Newtonsoft.Json.JsonConvert.SerializeObject(dataTable);
    }


    [WebMethod(EnableSession=true)]
    public string GetDemandItemDetails(string deptLedgerNo, int demandDraftID)
    {

        var sqlCmd = new StringBuilder(" SELECT 'IPD' SearchType, 0 CanRefil,'' RefealVal,'' DurationName,'' IntervalName,'' TimetoGive,'' Dose,fid.ID AS draftDetailID,ST.stockid,IM.TypeName ItemName,fid.ItemID,fid.DraftID IndentNo,'' patientMedicine, fid.Quantity TotalReqQty,(fid.Quantity-fid.ReceiveQty) ReqQty, ");
        sqlCmd.Append("  0 RejectQty,fid.ReceiveQty,ST.BatchNumber,IFNULL(get_New_PriceByRange(" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + ",IM.SubcategoryID,ST.UnitPrice) ,0)MRP,ST.UnitPrice,(ST.InitialCount - ST.ReleasedCount) AvlQty,IM.SubCategoryID, ");
        sqlCmd.Append(" im.isexpirable,DATE_FORMAT(ST.MedExpiryDate, '%d-%b-%Y') MedExpiryDate,ST.UnitType,im.ToBeBilled,ST.HSNCode,ST.IGSTPercent, ");
        sqlCmd.Append(" ST.IGSTAmtPerUnit,ST.SGSTPercent,ST.SGSTAmtPerUnit,ST.CGSTPercent,ST.CGSTAmtPerUnit,ST.GSTType,im.Type_ID,im.IsUsable, ");
        sqlCmd.Append(" im.ServiceItemID,'0' NewAvlQty,'' IssueQty,0 IssueChecked,st.PurTaxPer  ");
        sqlCmd.Append(" FROM store_demand_draft_details fid INNER JOIN f_itemmaster IM  ON im.ItemID=fid.ItemId ");
        sqlCmd.Append(" INNER JOIN f_subcategorymaster sub  ON sub.SubcategoryID = IM.SubcategoryID ");
        sqlCmd.Append(" INNER JOIN f_configrelation CR  ON sub.CategoryID = CR.CategoryID ");
        sqlCmd.Append(" LEFT JOIN f_stock ST ON st.ItemID=im.ItemID AND (ST.InitialCount - ST.ReleasedCount) > 0 AND ST.IsPost = 1 AND st.DeptLedgerNo = @departmentLedgerNo  AND st.CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " ");
        sqlCmd.Append(" AND (IF(im.IsExpirable = 'NO','2050-01-01',st.MedExpiryDate) > CURDATE())  ");
        sqlCmd.Append(" WHERE  CR.ConfigID = 11 AND IM.ItemID = fid.ItemId AND fid.DraftID=@draftID and (fid.Quantity-fid.ReceiveQty)>0 ");
        sqlCmd.Append(" ORDER BY  ST.ItemID,st.MedExpiryDate   ");

        ExcuteCMD excuteCMD = new ExcuteCMD();
        DataTable dataTable = excuteCMD.GetDataTable(sqlCmd.ToString(), CommandType.Text, new
        {
            departmentLedgerNo = deptLedgerNo,
            draftID = demandDraftID
        });
        return Newtonsoft.Json.JsonConvert.SerializeObject(dataTable);


    }


    [WebMethod(EnableSession = true)]
    public string IssuedMedicineForcefully(string itemID, string MedcineNo)
    {
        try
        {
            var sqlCmd = new StringBuilder("UPDATE patient_medicine pd SET pd.IsIssued=1 , pd.IssueQuantity=pd.OrderQuantity ");
            sqlCmd.Append(" , pd.IssueBy=@rejectBy , pd.Remarks=CONCAT(pd.Remarks,'#', 'substitute medicine is issued on behalf of this medicine'), pd.IssueDate=@rejectOn ");
            sqlCmd.Append("  WHERE pd.PatientMedicine_ID=@indentID ");
            ExcuteCMD excuteCMD = new ExcuteCMD();
            excuteCMD.DML(sqlCmd.ToString(), CommandType.Text, new
            {               
                rejectBy = HttpContext.Current.Session["id"].ToString(),
                rejectOn = System.DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                indentID = MedcineNo,
                 
            });
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = "" });
        }
        catch (Exception ex)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Error occurred, Please contact administrator", response = ex.Message });
        }
    }
}