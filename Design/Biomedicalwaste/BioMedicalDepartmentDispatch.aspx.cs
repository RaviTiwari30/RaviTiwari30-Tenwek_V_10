using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Biomedicalwaste_BioMedicalDepartmentDispatch : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToTime.Text = DateTime.Now.ToString("hh:mm tt");
            txtFromdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txttodate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            //tx.Text =  = DateTime.Now.ToString("dd-MMM-yyyy");
            calPurDate.EndDate = DateTime.Now;
            //ucToDate_CalendarExtender.EndDate = DateTime.Now;
        }
    }
}