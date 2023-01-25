using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

/// <summary>
/// Summary description for Designation
/// </summary>
public static  class Designation
{
    public static DataTable dtDesignation()
    {
        string qstr = "SELECT Designation_Id,name FROM bb_designation_master WHERE IsActive=1 order by Designation_Id";
        return StockReports.GetDataTable(qstr);


    }
    public static void bindDesignation(DropDownList ddlObject)
    {
        DataTable dtData = dtDesignation();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "name";
            ddlObject.DataValueField = "Designation_Id";
            ddlObject.DataBind();

        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }

    }
}
