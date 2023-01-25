using System;

public partial class Design_CPOE_voice_record : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblUser_ID.Text = Session["ID"].ToString();
            if (Request.QueryString["TransactionID"] == null)
            {
                lblTransactionID.Text = Request.QueryString["TID"].ToString();
                lblPatientID.Text = Request.QueryString["PID"].ToString();
            }
            else
            {
                lblTransactionID.Text = Request.QueryString["TransactionID"].ToString();
                lblPatientID.Text = Request.QueryString["PatientID"].ToString();
            }
        }
    }
}
