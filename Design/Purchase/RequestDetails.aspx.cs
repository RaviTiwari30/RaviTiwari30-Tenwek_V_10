using System;
using System.Data;
using System.Web.UI;
using System.Text;

public partial class Design_Purchase_RequestDetails : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            EntryDate1.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
            EntryDate2.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
        }
        EntryDate1.Attributes.Add("readOnly","true");
        EntryDate2.Attributes.Add("readOnly", "true");
    }

    private void SearchData()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select t1.*,t2.inhand from (select pd.PurchaseRequisitionNo,pd.ItemID,pd.RequestedQty,pd.ApprovedQty,(pd.ApprovedQty-pd.OrderedQty) RemQty,pd.ApproxRate,");
        sb.Append(" pm.RaisedDate,pm.Subject,im.typename,sm.name,(case when PM.Status = 0 then 'Pending' when PM.Status = 1 then 'Reject' when PM.Status = 2 then 'Open' when PM.Status = 3 then 'Close' end )Ptype");
        sb.Append(" from f_purchaserequestdetails pd inner join f_purchaserequestmaster pm on pd.PurchaseRequisitionNo = pm.PurchaseRequestNo inner join f_itemmaster im on pd.itemid = im.itemid inner join f_subcategorymaster sm on sm.SubCategoryID = im.SubCategoryID where PM.StoreID = '"+ddlStore.SelectedValue+"'");
        
        if(ddlStatus.SelectedIndex > 0)        
        sb.Append(" and pm.status = "+ddlStatus.SelectedValue);

        if (EntryDate1.Text.Trim() != string.Empty)
            sb.Append(" and date(RaisedDate)>='" + Util.GetDateTime(EntryDate1.Text).ToString("yyyy-MM-dd") + "'");

        if (EntryDate2.Text.Trim() != string.Empty)
            sb.Append(" and date(RaisedDate)<='"+Util.GetDateTime(EntryDate2.Text).ToString("yyyy-MM-dd")+"'");

        sb.Append(" order by im.typename,pd.PuschaseRequistionDetailID)t1 left join (select st.ItemID,sum(st.InitialCount-st.ReleasedCount) inhand from ");
        if (ddlStore.SelectedValue != "STO00002")
            sb.Append(" f_stock");
        else
            sb.Append(" f_stock");
        sb.Append(" st where IsPost = 1 group by st.ItemID)t2 on t1.itemid = t2.itemid");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt != null && dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "Period";
            string str = "";
            if (ddlStore.SelectedValue != "STO00002")
                str = "Medical Store ";
            else
                str = "General Store ";

            if (EntryDate1.Text.Trim() != string.Empty && EntryDate2.Text.Trim() != string.Empty)
                dc.DefaultValue = "( " + str + " ) From : " + Util.GetDateTime(EntryDate1.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(EntryDate2.Text).ToString("dd-MMM-yyyy");
            else
                dc.DefaultValue = "( " + str + " ) As On : " + DateTime.Now.ToString("dd-MMM-yyyy");

            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = Convert.ToString(Session["LoginName"]);
            dt.Columns.Add(dc);

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
               
            Session["ds"] = ds;
            Session["ReportName"] = "PDetailReport";

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/common/Commonreport.aspx');", true);
        }
        else
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        SearchData();
    }
}
