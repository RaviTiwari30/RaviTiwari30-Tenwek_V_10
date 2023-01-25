using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class Design_Token_OPDTokenSearch : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtRegNo.Focus();
            BindDoctor();
            GetDoctor();
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
           // txtFromDate.Enabled = false;
        }
        txtFromDate.Attributes.Add("readonly", "readonly");
        txtToDate.Attributes.Add("readonly", "readonly");
    }

    private void BindDoctor()
    {
        DataTable dt = EDPReports.GetConsultants();
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlDoctor.DataSource = dt;
            ddlDoctor.DataTextField = "text";
            ddlDoctor.DataValueField = "value";
            ddlDoctor.DataBind();
            ddlDoctor.Items.Insert(0, new ListItem("--------", "0"));

        }
    }

    private void GetDoctor()
    {
        if (Convert.ToString(Session["LoginType"]).ToUpper() == "DOCTOR")
        {
            string str = "select DoctorID from doctor_employee where Employee_id='" + Convert.ToString(Session["ID"]) + "'";
            DataTable dt = StockReports.GetDataTable(str);
            if (dt != null && dt.Rows.Count > 0)
            {
                ddlDoctor.Text = Util.GetString(dt.Rows[0][0]);

                ddlDoctor.Enabled = false;
            }
        }
    }
}