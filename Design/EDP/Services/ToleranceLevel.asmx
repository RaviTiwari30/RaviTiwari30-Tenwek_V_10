<%@ WebService Language="C#" Class="ToleranceLevel" %>

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

/// <summary>
/// Summary description for CentrewiseToleranceLevel
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class ToleranceLevel : System.Web.Services.WebService
{

    //public CentrewiseToleranceLevel()
    //{

    //    //Uncomment the following line if using designed components 
    //    //InitializeComponent(); 
    //}
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
   public string BindGridItems(string CategoryID, string SubCategoryID, string ItemName, string IsSet, string CentreID)
   {
       StringBuilder sb = new StringBuilder();
       sb.Append(" SELECT " + CentreID + " as CentreID,im.ItemID,sc.SubCategoryID,sc.CategoryID,im.TypeName,sc.Name AS SubCategoryName,cm.Name AS CategoryName,IFNULL(ctl.Maximum_Tolerance_Qty,0)Maximum_Tolerance_Qty,IFNULL(ctl.Minimum_Tolerance_Qty,0)Minimum_Tolerance_Qty,ROUND(IFNULL(ctl.Maximum_Tolerance_Rate,0),4)Maximum_Tolerance_Rate,ROUND(IFNULL(ctl.Minimum_Tolerance_Rate,0),4)Minimum_Tolerance_Rate,IFNULL(ctl.type,'P')type FROM f_itemmaster im INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=im.SubCategoryID INNER JOIN f_categorymaster cm ON sc.CategoryID=cm.CategoryID LEFT JOIN f_tolerancelevel ctl ON IM.ItemID=ctl.ItemID and ctl.IsActive=1  AND ctl.CentreID=" + CentreID + "  ");
      
       sb.Append(" WHERE im.IsActive=1 ");

       if (SubCategoryID != "0")
           sb.Append(" and im.SubCategoryID='" + SubCategoryID + "' ");
       if (CategoryID != "0")
           sb.Append(" and sc.CategoryID='" + CategoryID + "' ");
       if (ItemName != "")
           sb.Append(" and im.TypeName like '" + ItemName + "%' ");
    
       if (IsSet == "1")
           sb.Append(" AND ctl.ID IS NOT NULL ");
       else if (IsSet == "0")
           sb.Append(" AND ctl.ID IS NULL ");

       sb.Append(" ORDER BY cm.Name,sc.Name,im.TypeName ");
       DataTable dt = StockReports.GetDataTable(sb.ToString());

       return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
   }

   [WebMethod(EnableSession = true)]
   public string saveToleranceItems(System.Collections.Generic.List<PerformingCostItems> ItemList, int IsSet)
   {
       MySqlConnection con = Util.GetMySqlCon();
       con.Open();
       MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
       ExcuteCMD excuteCMD = new ExcuteCMD();
       try
       {
           if (ItemList.Count <= 0)
               return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Please Select Atleast One Item" });

           if (Util.GetString(ItemList[0].SubCategoryID) == "0")
               return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Please Select Sub Category" });


           if (IsSet > 0)
           {

               excuteCMD.DML(tnx, " Update f_tolerancelevel tl INNER JOIN `f_itemmaster` im ON im.`ItemID`=tl.`ItemID` set tl.IsActive=0,tl.UpdatedBy=@EntryBy,tl.UpdatedDatetime=NOW() WHERE IFNULL(tl.ItemID,'')<>'' AND tl.IsActive=1 and tl.CentreID=@CentreID and im.SubCategoryID=@SubCategoryID ", CommandType.Text, new
               {
                   EntryBy = HttpContext.Current.Session["ID"].ToString(),
                   CentreID = Util.GetInt(ItemList[0].CentreID),
                   SubCategoryID = ItemList[0].SubCategoryID
               });
           }
           for (int i = 0; i < ItemList.Count; i++)
           {
               StringBuilder sb = new StringBuilder();
               var item = ItemList[i];
               item.EntryBy = HttpContext.Current.Session["ID"].ToString();
               item.Ipaddress = All_LoadData.IpAddress();
              
               //sb.Append(" Select * from f_tolerancelevel where ItemID='" + item.ItemID + "'  and Maximum_Tolerance_Qty=" + item.Maximum_Tolerance_Qty + " and Minimum_Tolerance_Qty=" + item.Minimum_Tolerance_Qty + " and Maximum_Tolerance_Rate=" + item.Maximum_Tolerance_Rate + " and Minimum_Tolerance_Rate=" + item.Minimum_Tolerance_Rate + " AND type='" + item.type + "' and CentreID=" + item.CentreID + " and IsActive=1 ");
               //DataTable dt = StockReports.GetDataTable(sb.ToString());
               //if (dt.Rows.Count == 0)
               //{

               var sqlCmd = new StringBuilder(" INSERT INTO f_tolerancelevel(ItemID,Maximum_Tolerance_Qty,Minimum_Tolerance_Qty,Maximum_Tolerance_Rate,Minimum_Tolerance_Rate,type,IsActive,EntryBy,EntryDatetime,Ipaddress,CentreID ) ");
               sqlCmd.Append(" VALUES (@ItemID,@Maximum_Tolerance_Qty,@Minimum_Tolerance_Qty,@Maximum_Tolerance_Rate,@Minimum_Tolerance_Rate,@type,1,@EntryBy,NOW(),@Ipaddress,@CentreID ) ");
               excuteCMD.DML(tnx, sqlCmd.ToString(), CommandType.Text, item);
               //}
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
       public string Maximum_Tolerance_Qty { get; set; }
       public string Minimum_Tolerance_Qty { get; set; }
       public decimal Maximum_Tolerance_Rate { get; set; }
       public decimal Minimum_Tolerance_Rate { get; set; }
       public string IsSet { get; set; }
       public string EntryBy { get; set; }
       public string Ipaddress { get; set; }
       public string type { get; set; }
       public string CentreID { get; set; }
   }

}