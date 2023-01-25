using System;
using System.Data;

public partial class Design_HelpDesk_OPDAppointmentDetail : System.Web.UI.Page
{
    protected void LoadDoc()
    {
        DataTable dtDoc = All_LoadData.bindDoctor();
        ddlDoctor.DataSource = dtDoc;
        ddlDoctor.DataTextField = "Name";
        ddlDoctor.DataValueField = "DoctorID";
        ddlDoctor.DataBind();
        ddlDoctor.Items.Insert(0, "All");
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtfromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            LoadDoc();
        }
        txtfromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }
}