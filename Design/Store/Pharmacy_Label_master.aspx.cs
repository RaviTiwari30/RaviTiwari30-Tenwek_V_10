using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;
using System.Web.Services;

public partial class Design_Store_Pharmacy_Label_master : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod(EnableSession = true)]
    public static string Insert(string Name, string Type, string Quantity)
    {
        int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM phar_Label_master WHERE Name='" + Name + "' and Type='"+ Type +"' "));
            if (count > 0)
            {
                return "2";
            }
            else
            {
                StockReports.ExecuteDML("INSERT INTO phar_Label_master (Name,Type,Quantity,CreatedBY,Isactive) VALUES('" + Name + "','" + Type + "','" + Quantity + "','" + HttpContext.Current.Session["ID"].ToString() + "','1')");
                LoadCacheQuery.dropCache("LoadMedicineQuantity");
                return "1";
            }
        }
      [WebMethod]
    public static string bindLabelMaster(string Name)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ID,NAME,TYPE,Quantity,IF(isactive=1,'Yes','No')isactive,SequenceNo FROM phar_Label_master ");
        if (Name != "")
            sb.Append(" Where TYPE ='" + Name + "' ");
        sb.Append("  ORDER BY TYPE,SequenceNo");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if(dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
      [WebMethod]
      public static string Update(string Name, string Type, string Active, string ID, string Quantity)
      {
          StockReports.ExecuteDML("Update phar_Label_master set Name='" + Name + "',Type='" + Type + "',Quantity='" + Quantity + "',IsActive='" + Active + "',UpdateBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdateDate=Now() where ID='" + ID + "' ");
          LoadCacheQuery.dropCache("LoadMedicineQuantity");
          return "1";
      }
      [WebMethod]
      public static string UpdateSequenceNo(List<LabelMaster> Data)
      {
           int len = Data.Count;
           if (len > 0)
           {
               MySqlConnection con = new MySqlConnection();
               con = Util.GetMySqlCon();
               con.Open();
               MySqlTransaction tranX = con.BeginTransaction();
               try
               {
                   for (int i = 0; i < Data.Count; i++)
                   {
                       StockReports.ExecuteDML("Update phar_Label_master set SequenceNo='" + (Util.GetInt(i) + 1) + "' where ID='" + Data[i].ID + "' ");
                   }
                   LoadCacheQuery.dropCache("LoadMedicineQuantity");
                   return "1";
               }
               catch (Exception ex)
               {
                   tranX.Rollback();
                   ClassLog cl = new ClassLog();
                   cl.errLog(ex);
                   return "0";
               }
               finally
               {
                   tranX.Dispose();
                   con.Close();
                   con.Dispose();
               }
           }
           else
               return "0";
          
      }
      public class LabelMaster
      {
          public string SequenceNo { get; set; }
          public string ID { get; set; }
      }
}

