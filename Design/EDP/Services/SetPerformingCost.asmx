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
    
    [WebMethod]
    public string BindCentre()
    {
        DataTable dt = All_LoadData.dtbind_Center();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public string BindGridItems(string centreID, string CategoryID, string SubCategoryID, string ItemName, string IsSet)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT im.ItemID,sc.SubCategoryID,sc.CategoryID,im.TypeName,sc.Name AS SubCategoryName,cm.Name AS CategoryName,ROUND(IFNULL(cpm.PerformingCost,0),4)PerformingCost,IF(cpm.PerformingCost IS NULL,0,1)IsSet FROM f_itemmaster im INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=im.SubCategoryID INNER JOIN f_categorymaster cm ON sc.CategoryID=cm.CategoryID LEFT JOIN master_CenterwisePerformingCosting cpm ON IM.ItemID=cpm.ItemID AND cpm.CentreID=1 WHERE im.IsActive=1 ");
       
        if(SubCategoryID !="0")
            sb.Append(" and im.SubCategoryID='" + SubCategoryID + "' ");
        if (CategoryID != "0")
            sb.Append(" and sc.CategoryID='" + CategoryID + "' ");
        if (ItemName != "")
        sb.Append(" and im.TypeName like '"+ ItemName +"%' ");

        if (IsSet == "1")
            sb.Append(" AND cpm.ID IS NOT NULL ");
        else if (IsSet == "0")
            sb.Append(" AND cpm.ID IS NULL ");
        
        sb.Append(" ORDER BY cm.Name,sc.Name,im.TypeName ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public string savePerformingCosting(string centreID, System.Collections.Generic.List<PerformingCostItems> ItemList)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            for (int i = 0; i < ItemList.Count; i++)
            {
                var item = ItemList[i];
                item.EntryBy = HttpContext.Current.Session["ID"].ToString();
                item.Ipaddress = All_LoadData.IpAddress();
                item.CentreID = centreID;
                
                excuteCMD.DML(tnx, "DELETE from master_CenterwisePerformingCosting WHERE ItemID=@ItemID AND  CentreID=@CentreID", CommandType.Text, item);
                var sqlCmd = new StringBuilder("INSERT INTO master_CenterwisePerformingCosting(ItemID,CentreID,PerformingCost,EntryBy,Ipaddress )");
                sqlCmd.Append("VALUES (@ItemID,@CentreID,@PerformingCost,@EntryBy,@Ipaddress)");
                excuteCMD.DML(tnx, sqlCmd.ToString(), CommandType.Text, item);
            }
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Save Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error Occured. Please contact to Administrator", message = ex.Message });

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public class PerformingCostItems
    {
        public string ItemID { get; set; }
        public string SubCategoryID { get; set; }
        public string CategoryID { get; set; }
        public string TypeName { get; set; }
        public string SubCategoryName { get; set; }
        public string CategoryName { get; set; }
        public decimal PerformingCost { get; set; }
        public string IsSet { get; set; }
        public string EntryBy { get; set; }
        public string Ipaddress { get; set; }
        public string CentreID { get; set; }
    }
}