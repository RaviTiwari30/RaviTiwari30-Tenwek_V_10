using System;
using System.Data;
using System.Web.UI;
using System.Text;

public partial class Design_Purchase_POAmendmentReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindSubCategory();
            ucFromDate.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
            ucToDate.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
        }
        ucFromDate.Attributes.Add("readonly","true");
        ucToDate.Attributes.Add("readonly","true");
    }

   
    private void BindSubCategory()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT Name,SubCategoryID from f_Subcategorymaster where CategoryID in (");
        sb.Append(" SELECT CategoryID from f_categorymaster where categoryID in (select categoryID from ");
        sb.Append(" f_configrelation where ConfigID =11)) order by Name");

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            ChkSubcategory.DataSource = dt;
            ChkSubcategory.DataTextField = "Name";
            ChkSubcategory.DataValueField = "SubCategoryID";
            ChkSubcategory.DataBind();
        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        string Groups = string.Empty;
        Groups = StockReports.GetSelection(ChkSubcategory);
        
        StringBuilder sb = new StringBuilder();
        sb.Append(" select st.ItemID,st.BatchNumber,st.UnitPrice,st.InitialCount,date(pm.AmendDate)AmdDate,st.Naration,pm.Comment,");
        sb.Append(" (st.UnitPrice*st.InitialCount) Amount,im.typename,sm.Name from f_stock st inner join f_itemmaster im on st.itemid = im.itemid ");
        sb.Append(" inner join f_subcategorymaster sm on im.SubCategoryID = sm.SubCategoryID inner join f_po_store ps on ps.StockID = st.StockID");
        sb.Append(" inner join f_poamendment pm on ps.PODetailID = pm.PODetailID where st.IsFree = 0 and st.IsPost = 1 and st.IsReturn = 0 and date(pm.AmendDate) between ");
        sb.Append("'" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' AND '" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'");

        if (Groups != string.Empty)
            sb.Append(" and sm.SubCategoryID in (" + Groups + ")");

        sb.Append(" order by pm.AmendDate,im.typename");

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "Period From : " + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + " To : " +Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd");
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
            dt.Columns.Add(dc);


            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());

           //ds.WriteXmlSchema(@"C:\AmitPurchaseSummary.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "PurchaseAmendementReport";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/CommonCrystalReport.aspx');", true);
            lblMsg.Text = "";
        }
        else
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);

    }
}
