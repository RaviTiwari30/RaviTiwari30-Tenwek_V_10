using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Text;
using System.Web.Services;

public partial class Design_Lab_Lab_itemsSet : System.Web.UI.Page
{
    [WebMethod]
    public static string UpdateItem(int ID)
    {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction();
            try
            {
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "DELETE from lab_itemSet_master where ID='" + ID + "'");
                tranX.Commit();
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
    [WebMethod]
    public static string LoadSetItems(int SetID)
    {
        DataTable dt = StockReports.GetDataTable(" SELECT lim.ID,lim.quantity,im.Typename name,im.ItemID investigation_ID,lim.SetID,lis.name setName FROM lab_itemSet_master lim INNER JOIN f_itemmaster im ON im.ItemID=lim.itemID INNER JOIN  lab_itemSet lis ON lim.setID=lis.ID WHERE lim.setID='" + SetID + "' ");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public static string SaveSetItem(List<SetItem> Data)
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

                    int Count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM lab_itemSet_master where SetID='" + Data[i].SetID + "' and ItemID='" + Data[i].ItemID +"'  "));

                    if (Count == 0)
                    {
                        string str = "Insert into lab_itemSet_master(SetID,ItemID,Quantity,CreatedBy) " +
                  " values('" + Data[i].SetID + "','" + Data[i].ItemID + "','" + Data[i].Quantity + "','" + HttpContext.Current.Session["ID"].ToString() + "')";
                        MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str);
                    
                    }
                }
                tranX.Commit();
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
        {
            return "0";
        }

    }
    public class SetItem
    {
        public string ItemID { get; set; }
        public string Quantity { get; set; }
        public string SetID { get; set; }

    }
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindItems();
        }
    }
    [WebMethod]
    public static string loadSets(string Status)
    {
        DataTable dt = StockReports.GetDataTable(" SELECT ID SetID,NAME setName FROM Lab_ItemSet WHERE isActive IN ("+ Status +") ");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    private void BindItems()
    {
        
        DataTable dtInv = LoadCacheQuery.loadOPDDiagnosisItems("1", "0", "0");        
        if (dtInv != null && dtInv.Rows.Count > 0)
        {
            lstitems.DataSource = dtInv;
            lstitems.DataTextField = "Item";
            lstitems.DataValueField = "ItemID";
            lstitems.DataBind();
        }
        else
        {
            lstitems.Items.Clear();
        }
    }
    [WebMethod]
    public static string SaveSet(string SetName, string Description, string SetID, string Status)
    {
        try
        {
            if (SetID == "")
            {
                int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM Lab_ItemSet WHERE Name='" + SetName + "'"));
                if (count > 0)
                {
                    return "2";
                }
                else
                {
                    StockReports.ExecuteDML("INSERT INTO Lab_ItemSet(Name,Description,CreatedBy)VALUES('" + SetName + "','" + Description + "','" + HttpContext.Current.Session["ID"].ToString() + "')");
                    return "1";
                }
            }
            else
            {
                StockReports.ExecuteDML("UPDATE Lab_ItemSet SET Name='" + SetName + "',Description='" + Description + "',UpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdateDate=NOW(),IsActive='"+ Status +"' WHERE ID='"+ SetID +"' ");
                return "1";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }
   
}