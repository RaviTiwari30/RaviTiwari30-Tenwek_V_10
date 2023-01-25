using System;
using System.Data;

public partial class Design_EMR_DRHeader : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            string TID = string.Empty;
            if (Request.QueryString["TransactionID"] == null)
                TID = Request.QueryString["TID"].ToString();
            else
                TID = Request.QueryString["TransactionID"].ToString();



            ViewState["TID"] = TID;

            BindDetails(TID);
        }

        lblMsg.Text = "";
    }

    private void BindDetails(string TransactionID)
    {

        DataTable dtDetail = StockReports.GetDataTable("Select header from emr_ipd_details  Where TransactionID='" + TransactionID + "'");
        if (dtDetail.Rows.Count > 0)
        {
            ddlheader.SelectedIndex = ddlheader.Items.IndexOf(ddlheader.Items.FindByText(dtDetail.Rows[0]["header"].ToString()));
        }
    }
}