using System;
using System.Data;
using System.Text;
using System.Web.UI;
using MySql.Data.MySqlClient;

public partial class Design_Kitchen_DietWise_Report : System.Web.UI.Page
{
   

    protected void btnDiet_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT dt.NAME DietTime ,dmm.name DietMenu,dsm.Name SubDietName,(SELECT GROUP_CONCAT(CONCAT(dmap.COmponentName,'(Qty: ',Qty,')')) FROM diet_map_diet_component dmap WHERE dmap.DietMenuID=dmm.DietMenuID)ComponentName  FROM diet_patient_diet_request dpdr INNER JOIN diet_subdiettype_master dsm ON dsm.SubDietID = dpdr.SubDietID INNER JOIN diet_menu_master dmm  ON dmm.DietMenuID = dpdr.DietMenuID INNER JOIN diet_timing dt ON dt.ID=dpdr.DietTimeID");
        sb.Append("  WHERE DATE(dpdr.RequestDate)>='" + Util.GetDateTime(txtFromdate.Text).ToString("yyyy-MM-dd") + "'  AND DATE(dpdr.RequestDate) <='" + Util.GetDateTime(txtTodate.Text).ToString("yyyy-MM-dd") + "'");
        if (ddltiming.SelectedItem.Text != "Select")
        {
            sb.Append(" and dt.ID='" + ddltiming.SelectedValue + "'  ");
        }
        if (ddlmenu.SelectedItem.Text != "Select")
        {
            sb.Append(" AND dmm.DietMenuID='" + ddlmenu.SelectedValue + "' ");
        }

        if (ddlDietType.SelectedItem.Text != "Select")
        {
            if (ddlSubDietType.SelectedItem.Text != "Select")
            {
                sb.Append(" AND  dsm.SubDietID='" + ddlSubDietType.SelectedValue + "' ");
            }
        }

        sb.Append("  AND dpdr.IsFreeze ='1'");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            Session["dtExport2Excel"] = dt;
            Session["ReportName"] = "Diet Wise Report";
            Session["Period"] = "As On Date " + txtFromdate.Text;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
        }
        else
        {
            lblMsg.Text = "Record Not found";
        }
    }

    protected void ddlDietType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlDietType.SelectedIndex > 0)
        {
            DataTable dtDetail = StockReports.GetDataTable("select dsm.SubDietID,dsm.Name FROM diet_subdiettype_master dsm inner join diet_Map_Type_SubType dmts ON dsm.SubDietID=dmts.SubDietID AND  dmts.DietID='" + ddlDietType.SelectedItem.Value + "'  where  dsm.IsActive=1 order by dsm.name ");
            if (dtDetail.Rows.Count > 0)
            {
                ddlSubDietType.DataSource = dtDetail;
                ddlSubDietType.DataTextField = "Name";
                ddlSubDietType.DataValueField = "SubDietID";
                ddlSubDietType.DataBind();
                ddlSubDietType.Items.Insert(0, "Select");
            }
        }
        else
        {
            lblMsg.Text = "Select Diet Type";
            ddlSubDietType.DataSource = null;
            ddlSubDietType.DataBind();
            ddlSubDietType.Items.Insert(0, "Select");
        }
    }

    protected void ddlSubDietType_SelectedIndexChanged(object sender, EventArgs e)
    {
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
        AllLoadData_Diet.bindDietType(ddlDietType, "Select");
        AllLoadData_Diet.bindDietTime(ddltiming, "Select");
        AllLoadData_Diet.bindDietMenu(ddlmenu, "Select");
            lblMsg.Text = "";
            txtFromdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtTodate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
    }

  

    

   
}