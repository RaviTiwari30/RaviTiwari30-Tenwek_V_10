using System;

public partial class Design_Controls_StartDateTime : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {

    txtStartDate.Attributes.Add("readyOnly", "readyOnly");
    }
    protected void Page_Init(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtStartDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            calStartDate.StartDate = DateTime.Now;
            txtTime.Text = System.DateTime.Now.ToString("hh:mm tt");
        }

    }
}