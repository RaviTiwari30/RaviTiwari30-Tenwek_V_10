<%@ WebService Language="C#" Class="BloodBank" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Text;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Data;
using MySql.Data.MySqlClient;
using System.Collections.Generic;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.ComponentModel.ToolboxItem(false)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
 [System.Web.Script.Services.ScriptService]
public class BloodBank  : System.Web.Services.WebService {


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindBloodBankItem()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT im.ItemID,Im.TypeName,bc.ComponentID FROM f_itemmaster im INNER JOIN f_subcategorymaster scm ");
        sb.Append(" ON im.subcategoryid=scm.subcategoryid  LEFT JOIN bb_item_component bc ON bc.ItemID=im.ItemID  WHERE scm.CategoryID='18' AND im.IsActive=1");
 
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
           

        else
            return "";
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindComponentName()
    {

        DataTable dt = StockReports.GetDataTable("SELECT ID,ComponentName from bb_component_master WHERE Active=1");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);


        else
            return "";
    } 
     [WebMethod(EnableSession = true, Description = "Save ItemComponent")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string saveItemComponent(object Bloodbank)
    {
        List<ItemComponent> dataBloodbank = new JavaScriptSerializer().ConvertToType<List<ItemComponent>>(Bloodbank);
         MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM bb_item_component");
            for (int i = 0; i < dataBloodbank.Count; i++)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO bb_item_component(ItemID,ComponentID)VALUES('" + dataBloodbank[i].ItemID + "','" + dataBloodbank[i].ComponentID + "')");
            }
        
          tnx.Commit();
            return "1";

        }


        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
     public class ItemComponent
     {
         public string ItemID { get; set; }
         public string ComponentID { get; set; }
     }

     [WebMethod]
     [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
     public string LoadBloodGroup()
     {
         var str = "SELECT ID,BloodGroup FROM bb_bloodgroup_master WHERE isactive=1";
         DataTable dt = StockReports.GetDataTable(str);
         return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
     }
}