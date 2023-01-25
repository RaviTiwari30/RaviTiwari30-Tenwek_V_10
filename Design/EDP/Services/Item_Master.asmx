<%@ WebService Language="C#" Class="Item_Master" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Script;
using System.Collections.Generic;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
 [System.Web.Script.Services.ScriptService]
public class Item_Master  : System.Web.Services.WebService {

   
    [WebMethod]
    public string getCategory()
    {
        DataTable dtCategory = All_LoadData.LoadCategory();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtCategory);
    }
    [WebMethod]
    public string getSubCategory(string CategoryID)
    {
        DataTable dtSubCategory = All_LoadData.BindSubCategoryByCategory(CategoryID);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtSubCategory);
    }
    [WebMethod]
    public string getDepartment()
    {
        DataTable dtDepartment = StockReports.GetDataTable("SELECT ID,Name from type_master where TypeID =5 order by Name");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtDepartment);
    } 
    [WebMethod]
    public string LoadItems(string CategoryID, string SubCategoryID, string ItemName, string CPTCode, string Type, string RateEditable, string DepartmentID, string IsDiscountable)
    {
        StringBuilder str = new StringBuilder();
        str.Append("Select im.TypeName,im.ItemCode,im.ItemID,(cm.name)Category,im.SubCategoryID,cm.CategoryID,sc.Name SubCategory, ");
        str.Append(" im.IsActive,im.RateEditable,im.DeptID,IFNULL(tm.Name,'')Department,im.IsDiscountable,im.TypeofmeasurmentUnit,im.TypeofmeasurmentQty,Isshareward ");
        str.Append(" FROM f_categorymaster cm INNER JOIN  f_subcategorymaster sc on cm.CategoryID = sc.CategoryID ");
        str.Append(" INNER JOIN f_itemmaster im on im.SubCategoryID = sc.SubCategoryID ");
        str.Append(" LEFT JOIN type_master tm ON tm.ID=im.DeptID AND tm.TypeID=5 ");        
        str.Append(" Where im.ItemID >0 ");

        if (CategoryID !="0")
            str.Append(" AND cm.CategoryID ='" + CategoryID + "' ");
        if (SubCategoryID !="0")
            str.Append(" AND sc.SubCategoryID ='" + SubCategoryID + "' ");
        if (ItemName != "")
            str.Append(" AND im.TypeName  LIKE'%" + ItemName + "%' ");
        if (DepartmentID != "0")
            str.Append(" AND im.DeptID ='" + DepartmentID + "' ");        
        if (CPTCode !="")
            str.Append(" AND im.ItemCode = '" + CPTCode + "' ");
        if (Type != "2")
            str.Append(" AND im.IsActive =" + Type + " ");
        if (RateEditable != "2")
            str.Append(" AND im.rateEditable =" + RateEditable + " ");
        if (IsDiscountable != "")
            str.Append(" AND im.IsDiscountable =" + IsDiscountable + " ");
        str.Append("order by sc.Name,im.TypeName");
        DataTable dt = StockReports.GetDataTable(str.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true, Description = "Save Item")]
    public string SaveItem(object Data)
    {
        List<ItemMaster> dataItem = new JavaScriptSerializer().ConvertToType<List<ItemMaster>>(Data);
        int len = dataItem.Count;
       
        if (len > 0)
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

            int ChkItemName = Util.GetInt( MySqlHelper.ExecuteScalar(con, CommandType.Text, "Select COUNT(*) from f_itemmaster where TypeName='" + HttpUtility.UrlDecode(Util.GetString(dataItem[0].TypeName.Trim())) + "'"));
            if (ChkItemName >0)
                return "2";
            int ChkICPTCode = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "Select COUNT(*) from f_itemmaster where ItemCode='" + HttpUtility.UrlDecode(Util.GetString(dataItem[0].ItemCode.Trim())) + "' AND ItemCode<>''"));
            if (ChkICPTCode>0)
                return "3";
            
            try
            {
                ItemMaster objIMaster = new ItemMaster(tnx);
                objIMaster.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                objIMaster.Type_ID = 0;
                objIMaster.TypeName = HttpUtility.UrlDecode( Util.GetString(dataItem[0].TypeName.Trim()));
                objIMaster.Description = "";
                objIMaster.SubCategoryID = Util.GetString(dataItem[0].SubCategoryID.Trim());
                objIMaster.IsEffectingInventory = "NO";
                objIMaster.IsExpirable = "No";
                objIMaster.BillingUnit = "";
                objIMaster.Pulse = "";
                objIMaster.IsTrigger = "YES";
                objIMaster.StartTime = DateTime.Now;
                objIMaster.EndTime = DateTime.Now;
                objIMaster.BufferTime = "0";
                objIMaster.IsActive = 1;
                objIMaster.QtyInHand = 0;
                objIMaster.IsAuthorised = 1;
                objIMaster.ItemCode = HttpUtility.UrlDecode(Util.GetString(dataItem[0].ItemCode.Trim()));
                objIMaster.CreaterID = HttpContext.Current.Session["ID"].ToString();
                objIMaster.IPAddress = All_LoadData.IpAddress();
                objIMaster.RateEditable = dataItem[0].RateEditable;
                objIMaster.DepartmentID = dataItem[0].DepartmentID;
                objIMaster.IsDiscountable = dataItem[0].IsDiscountable;
                objIMaster.ManufactureName = dataItem[0].ManufactureName;
                objIMaster.TypeofmeasurmentQty = dataItem[0].TypeofmeasurmentQty;
                objIMaster.TypeofmeasurmentUnit = dataItem[0].TypeofmeasurmentUnit;
                objIMaster.Isshareward = dataItem[0].Isshareward;
                objIMaster.Insert().ToString();
                
                tnx.Commit();
                LoadCacheQuery.dropCache("OPDDiagnosisItems");
                return "1";
            }

            catch (Exception ex)
            {
                tnx.Rollback();
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
                return "";

            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        else
        {
            return "";
        }
    }

    [WebMethod(EnableSession = true, Description = "Update Item")]
    public string UpdateItem(object Data)
    {
         List<ItemMaster> dataItem = new JavaScriptSerializer().ConvertToType<List<ItemMaster>>(Data);
        int len = dataItem.Count;

        if (len > 0)
        {
            string str = "";
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                for (int i = 0; i < len; i++)
                {
                    
                    str = "UPDATE f_itemmaster set TypeName='" + HttpUtility.UrlDecode(dataItem[i].TypeName) + "',ItemCode='" + HttpUtility.UrlDecode(dataItem[i].ItemCode) + "',IsActive='" + dataItem[i].IsActive + "', " +
                        " IpAddress='" + All_LoadData.IpAddress() + "',UpdateDate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',LastUpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "',RateEditable='" + dataItem[i].RateEditable + "',DeptID='" + dataItem[i].DepartmentID + "',IsDiscountable='" + dataItem[i].IsDiscountable + "' ,TypeofmeasurmentUnit='" + dataItem[i].TypeofmeasurmentUnit + "',TypeofmeasurmentQty=" + dataItem[i].TypeofmeasurmentQty + " ,Isshareward =" + dataItem[i].Isshareward + " Where ItemID = '" + dataItem[i].ItemID + "'";
                       
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
                }
                    tnx.Commit();
                    LoadCacheQuery.dropCache("OPDDiagnosisItems");
                return "1";
            }

            catch (Exception ex)
            {
                tnx.Rollback();
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
                return "";

            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }

        }
        else
            return "";
    }
}