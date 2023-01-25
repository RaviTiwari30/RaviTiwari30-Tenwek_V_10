using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class Design_EDP_PanelDiscMaster : System.Web.UI.Page
{



    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            All_LoadData.bindPanel(ddlPanel, "Select");

            bindCategory();

        }
    }

    private void bindCategory()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" Select cat.CategoryID,cat.Name from f_configrelation con INNER JOIN  f_categorymaster cat ");
        sb.Append(" ON con.CategoryID=cat.CategoryID where cat.Active=1 AND con.IsActive=1 AND ConfigID IN(1,2,3,7,24,25) ORDER BY cat.Name ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            ddlCategory.DataTextField = "Name";
            ddlCategory.DataValueField = "CategoryID";
            ddlCategory.DataSource = dt;
            ddlCategory.DataBind();
            ddlCategory.Items.Insert(0, "Select");
        }
    }
    [WebMethod(EnableSession = true)]
    public static string bindPanelDisc(string PanelID, string Category)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" Select sub.subCategoryID,sub.Name,ifnull(dds.percentage,0)percentage from  f_subcategorymaster sub ");
        sb.Append(" LEFT JOIN f_panelDisc dds on dds.subCategoryID=sub.subCategoryID AND dds.IsActive=1  ");
        sb.Append(" AND PanelID=" + PanelID + " AND dds.CategoryID='" + Category + "' where sub.CategoryID='" + Category + "' AND sub.Active=1 ");
        sb.Append(" GROUP BY sub.subCategoryID  Order by sub.Name");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public static string bindDiscItemWise(string subCategoryID, string PanelID, string CategoryID)
    {
        StringBuilder sb = new StringBuilder();
        DataTable dt = new DataTable();
        if (PanelID.ToString() != "0")
        {
            sb.Append(" SELECT im.ItemID,im.subCategoryID,im.TypeName Name,IFNULL(fpd.percentage,0)percentage,IFNULL(fpd.IsActive,'0')IsActive from f_itemmaster ");
            sb.Append(" im  LEFT JOIN f_panelDisc fpd on im.ItemID=fpd.ItemID ");
            sb.Append(" AND fpd.IsActive=1  AND fpd.PanelID=" + PanelID + " ");
            sb.Append("  WHERE im.subCategoryID='" + subCategoryID + "' AND im.IsActive=1  Order by im.ItemID ");

            dt = StockReports.GetDataTable(sb.ToString());
        }
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public static string savePanelDisc(object item, string CategoryID, string PanelID)
    {
        List<PanelWiseDisc> dataItem = new JavaScriptSerializer().ConvertToType<List<PanelWiseDisc>>(item);

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            int exit = Util.GetInt(StockReports.ExecuteScalar(" Select count(*) from f_panelDisc where CategoryID='" + CategoryID + "' AND PanelID=" + PanelID + " "));
            if (exit > 0)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" Insert into f_panelDisc_backup(ItemID,CategoryID,SubCategoryID,PanelID,Percentage,CreatedBy,CreatedDate,DeactivatedBy) ");
                sb.Append("  SELECT ItemID,CategoryID,SubCategoryID,PanelID,Percentage,CreatedBy,CreatedDate,'" + HttpContext.Current.Session["ID"].ToString() + "' ");
                sb.Append(" from f_panelDisc WHERE CategoryID='" + Util.GetString(CategoryID) + "' AND PanelID=" + PanelID + " And IsActive=1 ");
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());

                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "DELETE FROM  f_panelDisc where CategoryID='" + CategoryID + "' AND PanelID=" + PanelID + " ");
            }

            for (int i = 0; i < dataItem.Count; i++)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" Insert into f_panelDisc(ItemID,CategoryID,SubCategoryID,PanelID,Percentage,CreatedBy) ");
                sb.Append("  SELECT ItemID,'" + CategoryID + "','" + Util.GetString(dataItem[i].SubCategoryID) + "'," + PanelID + ", ");
                sb.Append(" '" + Util.GetDecimal(dataItem[i].Percentage) + "','" + HttpContext.Current.Session["ID"].ToString() + "' ");
                sb.Append(" from f_itemmaster WHERE SubCategoryID='" + Util.GetString(dataItem[i].SubCategoryID) + "' And IsActive=1 ");
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());
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
}