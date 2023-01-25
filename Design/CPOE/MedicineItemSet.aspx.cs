using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_CPOE_MedicineItemSet : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindMedicine();
            ddlRoute.DataSource = AllGlobalFunction.Route;
            ddlRoute.DataBind();
            All_LoadData.bindMedicineQuan(ddlTime, "Time");
            All_LoadData.bindMedicineQuan(ddlDuration, "Duration");
        }
    }

    [WebMethod(EnableSession = true)]
    public static string loadSets()
    {
        DataTable dt = All_LoadData.BindMedicineSet();
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public static string SaveSet(string SetName, string Description)
    {
        try
        {
            int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM MedicineSetmaster WHERE SetName='" + SetName + "'"));
            if (count > 0)
            {
                return "2";
            }
            else
            {
                StockReports.ExecuteDML("INSERT INTO MedicineSetmaster(SetName,Description,EntryBy)VALUES('" + SetName + "','" + Description + "','" + HttpContext.Current.Session["ID"].ToString() + "')");
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

    [WebMethod]
    public static string UpdateSet(string SetName, string Description, string ID)
    {
        try
        {
            int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM MedicineSetmaster WHERE SetName='" + SetName + "'"));
            if (count > 0)
            {
                return "2";
            }
            else
            {
                StockReports.ExecuteDML("Update MedicineSetmaster set SetName='" + SetName + "',Description='" + Description + "',LastUpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdateDateTime=now() where id='" + ID + "' ");
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



    private void BindMedicine()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT IFNULL(IM.Typename, '')ItemName,CONCAT(IM.ItemID,'#',IM.Dose,'#',IM.MedicineType,'#',IM.Route,'#',cr.categoryid)ItemID  from f_itemmaster IM inner join f_subcategorymaster SM on IM.SubCategoryID = SM.SubCategoryID inner join f_configrelation CR on SM.CategoryID = CR.CategoryID  LEFT JOIN (SELECT IF(sum(InitialCount-ReleasedCount)>0,sum(InitialCount-ReleasedCount),0)  Qty,ItemID FROM f_stock WHERE ispost=1 and DeptLedgerNo='LSHHI57' AND MedExpiryDate > CURDATE() GROUP BY ITemID)st ON st.itemID = im.ItemID  WHERE CR.ConfigID = 11 AND im.IsActive=1  order by IM.Typename ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            lstitems.DataSource = dt;
            lstitems.DataTextField = "ItemName";
            lstitems.DataValueField = "ItemID";
            lstitems.DataBind();
        }
        else
        {
            lblmsg.Text = "No Medicine Found";
            lstitems.Items.Clear();
        }

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
                    int Count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM MedicineSetItemMaster where SetID='" + Data[i].SetID + "' and ItemID='" + Data[i].ItemID + "'  "));
                    if (Count == 0)
                    {
                        string str = "Insert into MedicineSetItemMaster(SetID,ItemID,Quantity,Dose,Route,Meal,Times,Duration,EntryBy) " +
                                 " values('" + Data[i].SetID + "','" + Data[i].ItemID + "','" + Data[i].Quantity + "','" + Data[i].Dose + "','" + Data[i].Route + "','" + Data[i].Meal + "','" + Data[i].Time + "','" + Data[i].Duration + "','" + HttpContext.Current.Session["ID"].ToString() + "')";
                        MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str);
                    }
                }
                LoadCacheQuery.DropCentreWiseCache();//
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
        public string Dose { get; set; }
        public string Route { get; set; }
        public string Meal { get; set; }
        public string Time { get; set; }
        public string Duration { get; set; }
    }
    [WebMethod]
    public static string LoadSetItems(int SetID)
    {
        try
        {            
         DataTable dt = StockReports.GetDataTable(" SELECT med.ID,med.quantity,med.dose,med.route,med.meal,med.times,med.duration,im.Typename NAME,im.ItemID,med.SetID,msm.Setname setName FROM MedicineSetItemMaster med INNER JOIN f_itemmaster im ON im.ItemID=med.itemID INNER JOIN  MedicineSetmaster msm ON med.setID=msm.ID WHERE med.setID='"+ SetID +"' ORDER BY im.Typename ");
         if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
                return "";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
    }
    [WebMethod]
    public static string UpdateItem(int ID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "DELETE from MedicineSetItemMaster where ID='" + ID + "'");
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
}