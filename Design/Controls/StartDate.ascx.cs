using System;

public partial class Design_Controls_StartDate : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtStartDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
           // calStartDate.StartDate = DateTime.Now;
            calStartDate.EndDate = DateTime.Now;
        }
        txtStartDate.Attributes.Add("readOnly", "true");
    }
}