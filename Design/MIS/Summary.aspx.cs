using System;

public partial class Design_MIS_Summary : System.Web.UI.Page
{
   

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
            lblUserID.Text = Session["ID"].ToString();
            lblUserSettingAvail.Text = StockReports.ExecuteScalar("SELECT COUNT(*) FROM mis_user_setting WHERE UserID='" + Session["ID"].ToString() + "'");
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }
}