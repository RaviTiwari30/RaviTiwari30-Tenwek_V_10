using System;
using System.Data;

public partial class Design_DocAccount_SetDocShareDate : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindDocShareDate();
        }
        txtShareToDate.Attributes.Add("readonly", "readonly");
        txtShareFromDate.Attributes.Add("readonly", "readonly");
    }

    private void bindDocShareDate()
    {
        DataTable doc = StockReports.GetDataTable(" Select DATE_FORMAT(share_from,'%d-%b-%Y')share_from,DATE_FORMAT(share_To,'%d-%b-%Y')share_To from da_share_date ORDER BY id DESC LIMIT 1 ");

        if (doc.Rows.Count > 0)
        {
            lblShareFromDate.Text = doc.Rows[0]["share_To"].ToString();
            if (doc.Rows[0]["share_To"].ToString() == "")
            {
                txtShareToDate.Text = Util.GetDateTime(lblShareFromDate.Text).AddDays(1).ToString("dd-MMM-yyyy");
            }
            else
            {
                txtShareToDate.Text = doc.Rows[0]["share_To"].ToString();
            }
            DateTime FromDate = Util.GetDateTime(lblShareFromDate.Text);
            calucDate.StartDate = Util.GetDateTime(FromDate.ToString("dd-MMM-yyyy"));
            txtShareFromDate.Attributes.Add("style", "display:none");
            lblShareFromDate.Attributes.Add("style", "display:inline");
        }
        else
        {
            DateTime ShareTo = Util.GetDateTime(StockReports.ExecuteScalar("SELECT Share_To FROM da_share_date ORDER BY Share_To DESC  LIMIT 1 "));
            lblShareFromDate.Text = ShareTo.AddDays(1).ToString("dd-MMM-yyyy");
            DateTime FromDate = Util.GetDateTime(lblShareFromDate.Text);
            calucDate.StartDate = Util.GetDateTime(FromDate.ToString("dd-MMM-yyyy"));
            txtShareToDate.Text = FromDate.AddDays(1).ToString("dd-MMM-yyyy");
            lblShareFromDate.Attributes.Add("style", "display:none");
            txtShareFromDate.Text = System.DateTime.Now.AddDays(-30).ToString("dd-MMM-yyyy");
            txtShareToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtShareFromDate.Attributes.Add("style", "display:inline");
        }
    }
}