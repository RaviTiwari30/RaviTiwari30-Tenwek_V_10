using System;
using System.Data;
using System.Web.UI;
using System.Text;

public partial class Design_Purchase_ItemComparativeReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindSubCategory();            
        }
    }
  
    protected void btnBinSearch_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT ST.ItemID,IM.typename ItemName,ST.LedgerTransactionNo,ST.UnitPrice,ST.MRP,");
        sb.Append(" ST.LedgerNo,ST.StockDate,ST.SubCategoryID,SM.Name,VM.VendorName,VM.Address1,VM.Address2");
        sb.Append(" FROM f_stock ST INNER JOIN f_itemmaster im on im.itemid = st.itemid inner join f_subcategorymaster SM ON IM.SubCategoryID = SM.SubCategoryID");
        sb.Append(" INNER JOIN f_ledgertransaction LT ON LT.LedgerTransactionNo = ST.LedgerTransactionNo");
        sb.Append(" INNER JOIN f_ledgermaster LM ON LT.LedgerNoCr = LM.LedgerNumber INNER JOIN f_vendormaster VM ON LM.LedgerUserID = VM.Vendor_ID");
        sb.Append(" WHERE ST.IsPost = 1 AND ST.IsReturn = 0 AND LM.GroupID = 'VEN' ");

       string GroupID = StockReports.GetSelection(ChkSubcategory);
	if(GroupID != string.Empty)
            sb.Append(" And im.SubCategoryID in ("+GroupID+")");

        if (rdoReportType.Text == "1")
            sb.Append(" group by ST.ItemID,VM.VendorName ORDER BY VM.VendorName ");
        else
            sb.Append(" ORDER BY ST.LedgerTransactionNo ");
        
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "User";
            dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];

            dt.Columns.Add(dc);

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());

            if (rdoReportType.Text == "1")
                Session["ReportName"] = "ItemWiseSupplierList";            
            else
                Session["ReportName"] = "ItemWiseComparative";
            
            Session["ds"] = ds;            
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
                    
        }
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
}
