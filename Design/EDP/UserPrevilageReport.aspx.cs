using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_EDP_UserPrevilageReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindCentre();
            BindDepartment();
        }

    }

    public void BindCentre()
    {

        string sql = "select CentreID,CentreName from center_master Where IsActive=1 order by CentreName ";
        DataTable dt = StockReports.GetDataTable(sql);

        if (dt.Rows.Count > 0)
        {
            ddlCentre.DataSource = dt;
            ddlCentre.DataTextField = "CentreName";
            ddlCentre.DataValueField = "CentreID";
            ddlCentre.DataBind();
            ddlCentre.Items.Insert(0, "Select");
        }
        else
        {
            ddlCentre.Items.Clear();
            ddlCentre.DataSource = null;
            ddlCentre.DataBind();
        }

    }

    public void BindDepartment()
    {
        DataTable dt = All_LoadData.LoadRole();

        if (dt.Rows.Count > 0)
        {
            ddlDept.DataSource = dt;
            ddlDept.DataTextField = "RoleName";
            ddlDept.DataValueField = "ID";
            ddlDept.DataBind();
            ddlDept.Items.Insert(0, "Select");
        }
        else
        {
            ddlDept.Items.Clear();
            ddlDept.DataSource = null;
            ddlDept.DataBind();
        }

    }

    protected void btnReport_Click(object sender, EventArgs e)
    {
        if (Util.GetInt(ddlType.SelectedValue) == 0)
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT fm.`DispName` PageName,GROUP_CONCAT(DISTINCT CONCAT(' ',em.`Title`,' ',em.`NAME`,' (',rm.`RoleName`,') '))EmployeeName   ");
            sb.Append(" FROM user_pageaccess up  ");
            sb.Append(" INNER JOIN f_filemaster fm ON fm.`ID`=up.`UrlID`  ");
            sb.Append(" INNER JOIN employee_master em ON em.`EmployeeID`=up.`EmployeeID`  ");
            sb.Append(" INNER JOIN f_rolemaster rm ON rm.`ID`=up.`RoleId`  ");
            sb.Append(" WHERE up.`IsActive`=1 ");

            if (ddlDept.SelectedValue != "Select")
            {
                sb.Append("  AND up.RoleId='" + ddlDept.SelectedValue + "' ");

            }
            if (ddlCentre.SelectedValue != "Select")
            {
                sb.Append("   AND up.`CentreID`='" + ddlCentre.SelectedValue + "' ");

            }
            sb.Append(" GROUP BY fm.`ID`;  ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt != null && dt.Rows.Count > 0)
            {
                Session["dtExport2Excel"] = dt;
                Session["ReportName"] = "Page Access Report";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);

            }
            else
            {
                lblMessage.Text = "No Record Found";
            }

        }

        if (Util.GetInt(ddlType.SelectedValue) == 1)
        {

            StringBuilder sb = new StringBuilder();

            sb.Append("  SELECT  aum.`ColDescription` Name,GROUP_CONCAT(DISTINCT CONCAT(' ',em.`Title`,' ',em.`NAME`,' (',rm.`RoleName`,') '))EmployeeName   ");
            sb.Append("   FROM userauthorization au ");
            sb.Append("  INNER JOIN  userauthorizationmaster aum ON aum.`ColName`=au.`ColName`  ");
            sb.Append("  INNER JOIN employee_master em ON em.`EmployeeID`=au.`EmployeeID` ");
            sb.Append("  INNER JOIN f_rolemaster rm ON rm.`ID`=au.`RoleId` ");
            sb.Append("   WHERE au.`ColValue`=1  AND au.`ColName`<>''  ");

            if (ddlDept.SelectedValue != "Select")
            {
                sb.Append("  AND au.RoleId='" + ddlDept.SelectedValue + "' ");

            }
            if (ddlCentre.SelectedValue != "Select")
            {
                sb.Append("   AND au.`CentreID`='" + ddlCentre.SelectedValue + "' ");

            }

            sb.Append("   GROUP BY aum.`ColName` ");

            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt != null && dt.Rows.Count > 0)
            {
                Session["dtExport2Excel"] = dt;
                Session["ReportName"] = "User Authorization Report";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);

            }
            else
            {
                lblMessage.Text = "No Record Found";
            }

        }



    }
}