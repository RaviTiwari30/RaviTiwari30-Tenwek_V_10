using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_EDP_ManagePackage : System.Web.UI.Page
{
  

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadAppVisitType();
            LoadDepartment();
            
            FromDateCal.StartDate = DateTime.Now;
            ToDateCal.StartDate = DateTime.Now;

            txtFrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        }
    }

    protected void rbtNewEdit_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rbtNewEdit.SelectedValue == "1")
        {
            ddlPackage.Visible = false;
            txtPkg.Visible = true;
        }
        else
        {
            ddlPackage.Visible = true;
            txtPkg.Visible = false;       
        }
    }
    protected void LoadAppVisitType()
    {
        ddlAppointmentType.DataSource = CreateStockMaster.LoadSubCategoryByCategory(CreateStockMaster.LoadCategoryByConfigID("5"));
        ddlAppointmentType.DataTextField = "Name";
        ddlAppointmentType.DataValueField = "SubCategoryID";
        ddlAppointmentType.DataBind();
        ddlAppointmentType.Items.Insert(0, "Select");
    }
    protected void LoadDepartment()
    {
        string str = "SELECT TRIM(dh.Name)Department,dm.DocDepartmentID "+
                    "FROM doctor_master dm INNER JOIN type_master dh ON dh.ID=dm.DocDepartmentID WHERE dm.IsActive=1 GROUP BY Department";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);
        ddlDepartment.DataSource = dt;
        ddlDepartment.DataTextField = "Department";
        ddlDepartment.DataValueField = "DocDepartmentID";
        ddlDepartment.DataBind();
        ddlDepartment.Items.Insert(0, "Select");
    }
}