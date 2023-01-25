using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using MySql.Data.MySqlClient;
using System.Text;


/// <summary>
/// Summary description for Set
/// </summary>
public class LaundrySet
{
    public LaundrySet()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public static string SaveSet(string SetName, string Description)
    {

        int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) from Laundry_set_master  WHERE Name='" + SetName + "' "));
        if (count > 0)
            return "2";
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            LaundrySet_master sm = new LaundrySet_master(Tnx);
            sm.SetName = SetName;
            sm.Description = Description;
            sm.UserID = HttpContext.Current.Session["ID"].ToString();

            string SetID = sm.Insert();
            Tnx.Commit();

            return "1";
        }
        catch (Exception ex)
        {
            Tnx.Rollback();

            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public static DataTable loadLaundarySets()
    {
        return StockReports.GetDataTable("SELECT sm.SetID,sm.NAME FROM Laundry_set_master sm LEFT JOIN Laundry_set_itemdetail sd ON sm.SetID=sd.SetID AND sd.IsActive=1  WHERE sd.SetID IS NULL AND sm.IsActive=1 GROUP BY sm.SetID ");

    }
    public static void bindLaundarySets(DropDownList ddlObject)
    {
        DataTable dtData = loadLaundarySets();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "NAME";
            ddlObject.DataValueField = "SetID";
            ddlObject.DataBind();
            ddlObject.Items.Insert(0, new ListItem("Select", "0"));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }
    public static DataTable LoadSetHavingItem()
    {
        return StockReports.GetDataTable("SELECT sm.SetID SetID,sm.NAME FROM Laundry_set_master sm inner JOIN Laundry_set_itemdetail sd ON sm.SetID=sd.SetID LEFT JOIN Laundry_batch_tnxdetails cbt ON cbt.setid=sd.setid   WHERE  sm.IsActive=1 AND sd.IsActive=1 AND IFNULL(isProcess,0)<>1 and sm.Isset=0 GROUP BY sm.SetID order by sm.NAME");


    }
    public static void bindItems(string ItemName, ListBox lb)
    {
        //StringBuilder sb = new StringBuilder();
        //sb.Append(" SELECT IM.Typename ItemName,CONCAT(IFNULL(IM.ItemID,''), '#', IFNULL(IM.ItemCatalog,'')) AS ItemID ");
        //sb.Append(" FROM f_itemmaster IM INNER JOIN f_subcategorymaster SM ON IM.SubCategoryID = SM.SubCategoryID ");
        //sb.Append(" INNER JOIN f_configrelation CR ON SM.CategoryID = CR.CategoryID  ");
        //sb.Append(" WHERE CR.ConfigID IN (28) AND im.IsActive=1  and sm.subcategoryID in ('" + Resources.Resource.LaundrySubCategoryID + "')");
        //if (ItemName != string.Empty)
        //    sb.Append(" AND im.TypeName LIKE '%" + ItemName + "%'  ");
        //sb.Append(" ORDER BY im.TypeName ");
        //DataTable dtData = StockReports.GetDataTable(sb.ToString());
        //if (dtData != null && dtData.Rows.Count > 0)
        //{

        //    lb.DataSource = dtData;
        //    lb.DataTextField = "ItemName";
        //    lb.DataValueField = "ItemID";
        //    lb.DataBind();
        //}
        //else
        //{
        //    lb.DataSource = null;
        //    lb.DataBind();
        //}

    }
    
    public static string saveSetDetails(string ItemData)
    {

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            string Id;
            ItemData = ItemData.TrimEnd('^');

            string str = "";
            int len = Util.GetInt(ItemData.Split('^').Length);
            string[] Item = new string[len];
            Item = ItemData.Split('^');
            str = "update Laundry_set_itemdetail set Isactive=0 WHERE SetID ='" + Item[0].Split('|')[1].ToString() + "' ";
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);

            for (int i = 0; i < len; i++)
            {
                Set_Item_Details obj = new Set_Item_Details(Tnx);
                obj.SetID = Util.GetString(Item[i].Split('|')[1].Trim());
                obj.SetName = Util.GetString(Item[i].Split('|')[2].Trim());
                obj.ItemID = Util.GetString(Item[i].Split('|')[4].Split('#')[0].Trim());
                obj.ItemName = Util.GetString(Item[i].Split('|')[3].Trim());
                obj.Quantity = Util.GetInt(Item[i].Split('|')[5].Trim());
                obj.UserID = HttpContext.Current.Session["ID"].ToString();
                obj.IsActive = 1;

                Id = obj.Insert();


            }

            Tnx.Commit();

            return "1";
        }
        catch (Exception ex)
        {
            Tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    public static string EditSetItemsDetails(string ItemData)
    {

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            string Id;
            ItemData = ItemData.TrimEnd('^');

            string str = "";
            int len = Util.GetInt(ItemData.Split('^').Length);
            string[] Item = new string[len];
            Item = ItemData.Split('^');
            str = "update Laundry_set_itemdetail set Isactive=0 WHERE  SetID ='" + Item[0].Split('|')[1].ToString() + "' ";
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);

            for (int i = 0; i < len; i++)
            {
                Set_Item_Details obj = new Set_Item_Details(Tnx);
                obj.SetID = Util.GetString(Item[i].Split('|')[1].Trim());
                obj.SetName = Util.GetString(Item[i].Split('|')[2].Trim());
                obj.ItemID = Util.GetString(Item[i].Split('|')[3].Split('#')[0].Trim());
                obj.ItemName = Util.GetString(Item[i].Split('|')[4].Trim());
                obj.Quantity = Util.GetInt(Item[i].Split('|')[6].Trim());
                obj.UserID = HttpContext.Current.Session["ID"].ToString();
                obj.IsActive = 1;

                Id = obj.Insert();


            }

            Tnx.Commit();

            return "1";
        }
        catch (Exception ex)
        {
            Tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

}
