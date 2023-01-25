using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Store_PharmacyMarkupMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
     
 [WebMethod]
    public static string BindSubCategory()
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT sm.SubCategoryID,sm.NAME  FROM  f_subcategorymaster sm ");
        sb.Append(" INNER JOIN f_configrelation cr ON cr.CategoryID=sm.CategoryID	");
        sb.Append(" WHERE cr.ConfigID=11");
         
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }



 [WebMethod(EnableSession = true, Description = "Insert pharmacy markup Master")]
  
 [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
 public static string InsertPharmacyMarkupMaster(PharmacyMarkupMaster Data)
 {

     MySqlConnection con = Util.GetMySqlCon();
     con.Open();
     MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
     try
     {
         if (!CheckRange(Data.FromRange,Data.SubCategory))
         {
             return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "From Range Is lies between Previously Added Range,Enter Valid From Range." });

         }

         if (!CheckRange(Data.ToRange, Data.SubCategory))
         {
             return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "To Range Is lies between Previously Added Range,Enter Valid To Range." });
 
         }

         if (!CheckInBetweenRange(Data.FromRange,Data.ToRange,Data.SubCategory))
         {
              return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Range Is Alrerady Added in Between "+Data.FromRange+" and "+Data.ToRange+"  " });
 
         }

         StringBuilder sb = new StringBuilder();

         sb.Append(" insert  into pharmacy_markup ");
         sb.Append(" (SubcategoryId,FromRange,ToRange,TypeOfFormula,Formula,EntryBy,Centre) ");
         sb.Append("values(" + Util.GetInt(Data.SubCategory) + "," + Util.GetDecimal(Data.FromRange) + "," + Util.GetDecimal(Data.ToRange) + ",  ");
         sb.Append(" '" + Util.GetString(Data.Type) + "' ," + Util.GetDecimal(Data.Formula) + " ,");
         sb.Append(" '" + Util.GetString(HttpContext.Current.Session["ID"].ToString()) + "'," + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + "   )");
          
         if (MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString()) == 0)
         {
             Tranx.Rollback();
             con.Close();
             con.Dispose();

             return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error In Saving Master. Contact To Administrator." });

         }
          
         Tranx.Commit();
         return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Markup Set Successfully" });

     }
     catch (Exception ex)
     {
         Tranx.Rollback();
         ClassLog cl = new ClassLog();
         cl.errLog(ex);
         return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error In Saving Master. Contact To Administrator." });

     }
     finally
     {
         Tranx.Dispose();
         con.Close();
         con.Dispose();
     }


      
 }


 public static bool CheckRange(decimal Range,int SubCategoryID )
 {


     int Count = Util.GetInt(StockReports.ExecuteScalar("SELECT IF(IFNULL(COUNT(pm.id),0)=0,0,1)IsValid FROM pharmacy_markup pm WHERE pm.IsActive=1 AND pm.Centre=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " AND pm.SubcategoryId=" + Util.GetInt(SubCategoryID) + "  AND " + Util.GetDecimal(Range) + " BETWEEN pm.FromRange AND pm.ToRange  "));

     if (Count==0)
     {
         return true;
     }
     else
     {
         return false;
     }

     
 }


 public static bool CheckInBetweenRange(decimal FRange, decimal TRange, int SubCategoryID)
 {
      
     int Count = Util.GetInt(StockReports.ExecuteScalar("SELECT IF(IFNULL(COUNT(pm.id),0)=0,0,1)IsValid FROM pharmacy_markup pm WHERE pm.IsActive=1 AND pm.Centre=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " AND pm.SubcategoryId=" + Util.GetInt(SubCategoryID) + " AND( pm.FromRange BETWEEN " + Util.GetDecimal(FRange) + " AND " + Util.GetDecimal(TRange) + "  OR pm.ToRange BETWEEN " + Util.GetDecimal(FRange) + " AND " + Util.GetDecimal(TRange) + " )    "));

     if (Count == 0)
     {
         return true;
     }
     else
     {
         return false;
     }


 }




 [WebMethod(EnableSession = true)]
 public static string GetDataToFill(string Id)
 {

     try
     {
         StringBuilder sbnew = new StringBuilder();

         sbnew.Append(" SELECT pm.Id,pm.SubcategoryId,pm.FromRange,pm.ToRange,pm.TypeOfFormula,pm.Formula,sm.NAME SubCategory FROM pharmacy_markup pm ");
         sbnew.Append(" INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID=pm.SubcategoryId ");
         sbnew.Append(" WHERE pm.IsActive=1 ");
         if (!string.IsNullOrEmpty(Id) &&  Id!="0" )
         {
             sbnew.Append(" and pm.SubcategoryId="+Util.GetInt(Id)+" ");
         }
         DataTable dt = StockReports.GetDataTable(sbnew.ToString());
         if (dt.Rows.Count > 0)
         {
             return Newtonsoft.Json.JsonConvert.SerializeObject(new
             {
                 status = true,
                 data = dt
             });

         }
         else
         {
             return Newtonsoft.Json.JsonConvert.SerializeObject(new
             {
                 status = false,
                 data = "No data found."
             });
         }

     }
     catch (Exception ex)
     {
         ClassLog objClassLog = new ClassLog();
         objClassLog.errLog(ex);
         return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data = ex.ToString() });

     }
 }


 [WebMethod(EnableSession = true, Description = "Remove Range")]
 [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
 public static string RemoveRange(int Id)
 {


     MySqlConnection con = new MySqlConnection();
     con = Util.GetMySqlCon();
     con.Open();
     MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

     try
     {

         string str = "update pharmacy_markup  set IsActive=0,UpdateBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdateDate=NOW()  WHERE Id=" + Util.GetInt(Id) + " ";
         int i = MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);
         if (i > 0)
         {
             Tnx.Commit();

             return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Remove Successfully" });

         }
         else
         {
             Tnx.Rollback();

             return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
         }
     }
     catch (Exception ex)
     {
         Tnx.Rollback();

         return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });

     }
     finally
     {
         Tnx.Dispose();
         con.Close();
         con.Dispose();
     }






 }



















    public class PharmacyMarkupMaster 
    {
        public int Id { get; set; } 

        public int   SubCategory { get; set; }  

        public decimal FromRange { get; set; }

        public decimal ToRange { get; set; }

        public string Type { get; set; }

        public decimal Formula { get; set; }

        public string  EntryBy { get; set; }

    }



}