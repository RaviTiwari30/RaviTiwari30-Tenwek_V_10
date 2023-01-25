using System;
using System.Data;
using System.Text;
using System.Web.UI;

public partial class Design_CSSD1_SetItemDetail : System.Web.UI.Page
{
    public void loadSets()
    {
        Set st = new Set();
        DataTable dt = st.LoadSets();
        if (dt.Rows.Count > 0)
        {
            ddlSetItem.DataSource = dt;
            ddlSetItem.DataTextField = "NAME";
            ddlSetItem.DataValueField = "SetID";
            ddlSetItem.DataBind();
            ddlSetItem.Items.Insert(0, "Select");
        }
        else
        {
            ddlSetItem.DataSource = null;
            ddlSetItem.DataBind();
            ddlSetItem.Items.Insert(0, "Select");
        }
    }

    protected void BindItems(string ItemName)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CONCAT(IM.Typename,'#',IFNULL(im.itemcode,'')) ItemName,im.itemID ");
        sb.Append(" FROM f_itemmaster IM INNER JOIN f_subcategorymaster SM ON IM.SubCategoryID = SM.SubCategoryID ");
        sb.Append(" INNER JOIN f_configrelation CR ON SM.CategoryID = CR.CategoryID  ");
     //   sb.Append(" WHERE CR.ConfigRelationID IN (11) AND im.IsActive=1  and sm.subcategoryID in (" + GetGlobalResourceObject("Resource", "CSSDSubCategoryID").ToString() + ")");
        sb.Append(" WHERE CR.ConfigRelationID IN (11) AND im.IsActive=1 ");
        if (ItemName != string.Empty)
            sb.Append(" AND im.TypeName LIKE '%" + ItemName + "%'  ");
        sb.Append(" ORDER BY im.TypeName ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            lstitems.DataSource = dt;
            lstitems.DataTextField = "ItemName";
            lstitems.DataValueField = "ItemID";
            lstitems.DataBind();
        }
        else
        {
            lstitems.DataSource = null;
            lstitems.DataBind();
        }
    }

    protected void btnRefresh_Click(object sender, EventArgs e)
    {
        BindItems("");
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            loadSets();
            BindItems("");
        }
    }
}