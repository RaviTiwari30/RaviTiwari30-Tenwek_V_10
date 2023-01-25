using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

/// <summary>
/// Summary description for BloodBank
/// </summary>
public static class BloodBank
{


    public static DataTable dtBloodGroup()
    {
       return StockReports.GetDataTable("SELECT id,bloodgroup FROM bb_BloodGroup_master WHERE IsActive=1 order by bloodgroup");


       
    }
    public static void bindBloodGroup(DropDownList ddlObject)
    {
        DataTable dtData = dtBloodGroup();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "bloodgroup";
            ddlObject.DataValueField = "id";
            ddlObject.DataBind();
            //ddlPanel.SelectedIndex = ddlPanel.Items.IndexOf(ddlPanel.Items.FindByValue("78#78"));

        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }

    }

    public static DataTable dtState()
    {
        return StockReports.GetDataTable("SELECT id,state FROM bb_state_master WHERE IsActive=1 ORDER By id");
    }

    public static void bindState(DropDownList ddlObject)
    {
        DataTable dtData = dtState();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "State";
            ddlObject.DataValueField = "id";
            ddlObject.DataBind();
            //ddlPanel.SelectedIndex = ddlPanel.Items.IndexOf(ddlPanel.Items.FindByValue("78#78"));

        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }

    }

    public static DataTable type()
    {
        return StockReports.GetDataTable("SELECT id,typename FROM bb_DonationType_master WHERE IsActive=1 ");
    }
    public static void bindType(DropDownList ddlObject)
    {
        DataTable dtData = type();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "typename";
            ddlObject.DataValueField = "id";
            ddlObject.DataBind();
            //ddlPanel.SelectedIndex = ddlPanel.Items.IndexOf(ddlPanel.Items.FindByValue("78#78"));

        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }

    }
    public static DataTable dtRelation()
    {
       return StockReports.GetDataTable("SELECT id,Relation FROM bb_Relation_master WHERE IsActive=1 ORDER By id");
    }
    public static void bindRelation(DropDownList ddlObject)
    {
        DataTable dtData = dtRelation();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Relation";
            ddlObject.DataValueField = "id";
            ddlObject.DataBind();
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }

    }
    public static DataTable dtBagType()
    {
       return StockReports.GetDataTable("SELECT id,BagType FROM bb_BagType_master WHERE IsActive=1 ORDER By id");
    }
    public static void bindBagType(DropDownList ddlObject)
    {
        DataTable dtData = dtBagType();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "BagType";
            ddlObject.DataValueField = "id";
            ddlObject.DataBind();
            ddlObject.Items.Insert(0, new ListItem("Select", "0"));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }

    }
    public static DataTable dtResult()
    {
        return StockReports.GetDataTable("SELECT id,Result FROM bb_Result_master WHERE IsActive=1 ORDER By id");
    }
    public static void bindResult(DropDownList ddlObject)
    {
        DataTable dtData = dtResult();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Result";
            ddlObject.DataValueField = "id";
            ddlObject.DataBind();

        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }

    }
    public static DataTable dtMethod()
    {
        return StockReports.GetDataTable("SELECT id,Method FROM bb_Method_master WHERE IsActive=1 ORDER By id");

    }
    public static void bindMethod(DropDownList ddlObject)
    {
        DataTable dtData = dtMethod();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Method";
            ddlObject.DataValueField = "id";
            ddlObject.DataBind();

        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }

    }
    public static DataTable dtOrganisation()
    {
        return StockReports.GetDataTable("SELECT id,organisaction FROM bb_Organisation_master WHERE IsActive=1 ORDER By id");
    }
    public static void bindOrganisation(DropDownList ddlObject)
    {
        DataTable dtData = dtOrganisation();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Organisaction";
            ddlObject.DataValueField = "id";
            ddlObject.DataBind();

        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }

    }
    public static DataTable dtTitle()
    {
        return StockReports.GetDataTable("SELECT id,Title FROM bb_title_master WHERE IsActive=1 ORDER By id");
    }
    public static void bindtitle(DropDownList ddlObject)
    {
        DataTable dtData = dtTitle();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Title";
            ddlObject.DataValueField = "id";
            ddlObject.DataBind();

        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }

    }
    public static DataTable dtComponent()
    {
        return StockReports.GetDataTable("SELECT ID,ComponentName FROM bb_component_master  WHERE active= 1 Order BY ID");
    }
    public static void bindComponent(DropDownList ddlObject)
    {
        DataTable dtData = dtComponent();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "ComponentName";
            ddlObject.DataValueField = "id";
            ddlObject.DataBind();
           // ddlObject.Items.Insert(0, new ListItem("ALL", "0"));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }

    }
}
