using System;
using System.Data;
using System.Text;
using System.Web.UI.WebControls;

public partial class Design_CPOE_OPDSearch : System.Web.UI.Page
{


    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            All_LoadData.bindDoctor(ddlDoctor, "ALL");
            All_LoadData.bindDocTypeList(ddlDepartmentlist, 5, "ALL");
            GetDoctor();
            fromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            if (!string.IsNullOrEmpty(Request.QueryString["PatientId"]))
            {
                txtRegNo.Text = Util.GetString(Request.QueryString["PatientId"].ToString());
            }

            txtRegNo.Focus();
        }
        fromDate.Attributes.Add("readOnly", "readOnly");
        ToDate.Attributes.Add("readOnly", "readOnly");
    }
    private void GetDoctor()
    {
        if (Convert.ToString(Session["LoginType"]).ToUpper() == "DOCTOR" || Convert.ToString(Session["LoginType"]).ToUpper() == "DOCTOR SPECIALIST")
        {
            string str = StockReports.ExecuteScalar("SELECT doctorID from doctor_employee where EmployeeID='" + Convert.ToString(Session["ID"]) + "' and EmployeeID NOT IN('LSHHI1240')");

            if (str != null)
            {
                ddlDoctor.SelectedValue = Util.GetString(str);
                ddlDoctor.Enabled = true;
            }
            else
            {
                ddlDoctor.Enabled = true;
            }
        }
        else
        {
            lblMsg.Text = "You are not a doctor. Kindly contact to IT Department.";
        }
    }
}
