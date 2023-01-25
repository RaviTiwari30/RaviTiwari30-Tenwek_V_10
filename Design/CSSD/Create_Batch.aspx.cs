using System;
using System.Data;
using System.Web.UI;

public partial class Design_CSSD_Create_Batch : System.Web.UI.Page
{
    public void LoadStock()
    {
        SetItemStockDetail st = new SetItemStockDetail();
        DataTable dt = st.LoadSetItemStock();
        if (dt.Rows.Count > 0)
        {
            lstBatchItems.DataSource = dt;
            lstBatchItems.DataTextField = "ItemName";
            lstBatchItems.DataValueField = "ItemID";
            lstBatchItems.DataBind();
        }
        else
        {
            lstBatchItems.DataSource = null;

            lstBatchItems.DataBind();
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            txtSearch.Focus();
            FrmDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");

           
            txtFromTime.Text = System.DateTime.Now.ToString("hh:mm tt");
            txtToTime.Text = System.DateTime.Now.ToString("hh:mm tt");
            LoadStock();
            calFrmDate.StartDate = DateTime.Now;
            calToDate.StartDate = DateTime.Now;
        }
        FrmDate.Attributes.Add("readonly", "readonly");
        ToDate.Attributes.Add("readonly", "readonly");
    }
}