using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI.WebControls;

/// <summary>
/// Summary description for AllLoadData_Store
/// </summary>
public class AllLoadData_Diet
    {
    public AllLoadData_Diet()
        {
        //
        // TODO: Add constructor logic here
        //
        }
    public static DataTable dtDietTime()
        {
        return StockReports.GetDataTable("SELECT ID,NAME FROM diet_timing WHERE IsActive=1 ");
        }


    public static void bindDietTime(DropDownList ddlObj, string type)
        {
        DataTable dt = dtDietTime();
        if (dt != null && dt.Rows.Count > 0)
            {
            ddlObj.DataSource = dt;
            ddlObj.DataTextField = "NAME";
            ddlObj.DataValueField = "ID";
            ddlObj.DataBind();
            ddlObj.Items.Insert(0, new ListItem(type, "0"));

            }
        else
            {
            ddlObj.DataSource = null;
            ddlObj.DataBind();
            }
        }

    public static DataTable dtDietType()
        {
        return StockReports.GetDataTable("Select DietID,Name From diet_DietType_master where IsActive=1 order By Name ");
        }


    public static void bindDietType(DropDownList ddlObj, string type)
        {
        DataTable dt = dtDietType();
        if (dt != null && dt.Rows.Count > 0)
            {
            ddlObj.DataSource = dt;
            ddlObj.DataTextField = "Name";
            ddlObj.DataValueField = "DietID";
            ddlObj.DataBind();
            ddlObj.Items.Insert(0, new ListItem(type, "0"));

            }
        else
            {
            ddlObj.DataSource = null;
            ddlObj.DataBind();
            }
        }

    public static DataTable dtDietMenu()
        {
        return StockReports.GetDataTable("Select DietMenuID,Name From diet_Menu_master where IsActive=1 order By Name ");
        }


    public static void bindDietMenu(DropDownList ddlObj, string type)
        {
        DataTable dt = dtDietMenu();
        if (dt != null && dt.Rows.Count > 0)
            {
            ddlObj.DataSource = dt;
            ddlObj.DataTextField = "Name";
            ddlObj.DataValueField = "DietMenuID";
            ddlObj.DataBind();
            ddlObj.Items.Insert(0, new ListItem(type, "0"));

            }
        else
            {
            ddlObj.DataSource = null;
            ddlObj.DataBind();
            }
        }

    }