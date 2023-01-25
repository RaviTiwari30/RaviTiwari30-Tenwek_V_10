using AjaxControlToolkit;
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_IPD_AdvanceRoomBooking : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblUserID.Text = Session["ID"].ToString();
            txtSearchModelFromDate.Text = txtSerachModelToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");

        }
        txtSearchModelFromDate.Attributes.Add("readOnly", "readOnly");
        txtSerachModelToDate.Attributes.Add("readOnly", "readOnly");
    }
}