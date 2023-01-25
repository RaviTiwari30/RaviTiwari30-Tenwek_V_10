using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Web;
using System.Web.Services;
using System.Xml.Serialization;

public partial class Design_EDP_UserPageAuthorization : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindLoginType();
            BindUser();
        }
    }
    private void BindLoginType()
    {
        string str = "select ID,RoleName from f_rolemaster where active=1 order by RoleName";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlLoginType.DataSource = dt;
            ddlLoginType.DataTextField = "RoleName";
            ddlLoginType.DataValueField = "ID";
            ddlLoginType.DataBind();
        }
    }
    private void BindUser()
    {
        string str = "SELECT EmployeeID,Name FROM employee_master WHERE isactive='1' order by name ";
        DataTable dtuser = StockReports.GetDataTable(str);
        if (dtuser != null && dtuser.Rows.Count > 0)
        {
            ddlUser.DataSource = dtuser;
            ddlUser.DataTextField = "Name";
            ddlUser.DataValueField = "EmployeeID";
            ddlUser.DataBind();
        }
    }

   


    
}