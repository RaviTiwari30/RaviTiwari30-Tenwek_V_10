using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OPD_PaymentByAccnt : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            All_LoadData.bindApprovalType(ddlApprovedBy);
            bindExpenceType();
            BindMenu();
        }
    }
    protected void btnFileSave_Click(object sender, EventArgs e)
    {
        string str = "insert into f_expencesubhead(subhead_name,expns_type) values('" + txtdispName.Text.Trim() + "','" + ddlNfile.SelectedItem.Text.Trim() + "')";
        txtdispName.Text = "";
        if (StockReports.ExecuteDML(str))
        {
            lblMsg.Text = "Record Saved Successfully";
        }
        else
            lblMsg.Text = "Error occurred, Please contact administrator";
    }
    private void BindMenu()
    {
        DataTable dt = StockReports.GetDataTable("SELECT id,ExpenceHead FROM f_expencehead WHERE active=1");
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlNfile.DataSource = dt;
            ddlNfile.DataTextField = "ExpenceHead";
            ddlNfile.DataValueField = "id";
            ddlNfile.DataBind();
        }
    }
    private void bindExpenceType()
    {
        ddlExpenceType.DataSource = StockReports.GetDataTable("SELECT id,ExpenceHead FROM f_expencehead WHERE active=1");
        ddlExpenceType.DataTextField = "ExpenceHead";
        ddlExpenceType.DataValueField = "id";
        ddlExpenceType.DataBind();
        ddlExpenceType.Items.Insert(0, new ListItem("Select"));
    }

    protected void ddlExpenceType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlExpenceType.SelectedIndex == 0)
        {
            btnsave.Enabled = false;
            ddlExpenceTo.Visible = false;
            txtExpenceType.Visible = false;
        }
        //else if (ddlExpenceType.SelectedIndex == ddlExpenceType.Items.Count - 1)
        //{
        //    btnsave.Enabled = true;
        //    ddlExpenceTo.Visible = false;
        //    txtExpenceType.Visible = true;
        //}
        else if (ddlExpenceType.SelectedIndex == 1)
        {
            // bindDoctors();
            bindOverhead();
            ddlExpenceTo.Visible = true;
            btnsave.Enabled = true;
            txtExpenceType.Visible = false;
        }
        else if (ddlExpenceType.SelectedIndex == 2)
        {
            //bindVendors();
            bindDepartmental();
            ddlExpenceTo.Visible = true;
            btnsave.Enabled = true;
            txtExpenceType.Visible = false;
        }
        //else if (ddlExpenceType.SelectedIndex == 3)
        //{
        //    bindEmployee();
        //    ddlExpenceTo.Visible = true;
        //    btnsave.Enabled = true;
        //    txtExpenceType.Visible = false;
        //}
    }

    //private void bindDoctors()
    //{
    //    ddlExpenceTo.DataSource = StockReports.GetDataTable("SELECT DoctorID,CONCAT('Dr. ',NAME) NAME FROM doctor_master WHERE isActive=1 ORDER BY NAME asc");
    //    ddlExpenceTo.DataValueField = "DoctorID";
    //    ddlExpenceTo.DataTextField = "name";
    //    ddlExpenceTo.DataBind();
    //    ddlExpenceTo.Items.Insert(0, new ListItem("Select", "0"));
    //}

    private void bindOverhead()
    {
        ddlExpenceTo.DataSource = StockReports.GetDataTable("SELECT subhead_ID,subhead_name FROM f_expencesubhead WHERE expns_type='Overhead Expenses' and isActive=1 ORDER BY subhead_name asc");
        ddlExpenceTo.DataValueField = "subhead_ID";
        ddlExpenceTo.DataTextField = "subhead_name";
        ddlExpenceTo.DataBind();
        ddlExpenceTo.Items.Insert(0, new ListItem("Select", "0"));
    }

    //private void bindVendors()
    //{
    //    ddlExpenceTo.DataSource = StockReports.GetDataTable("SELECT Vendor_ID,VendorName FROM f_vendormaster order by VendorName asc ");
    //    ddlExpenceTo.DataValueField = "Vendor_ID";
    //    ddlExpenceTo.DataTextField = "VendorName";
    //    ddlExpenceTo.DataBind();
    //    ddlExpenceTo.Items.Insert(0, new ListItem("Select", "0"));
    //}

    private void bindDepartmental()
    {
        ddlExpenceTo.DataSource = StockReports.GetDataTable("SELECT subhead_ID,subhead_name FROM f_expencesubhead WHERE expns_type='Direct Expenses' and isActive=1 ORDER BY subhead_name asc");
        ddlExpenceTo.DataValueField = "subhead_ID";
        ddlExpenceTo.DataTextField = "subhead_name";
        ddlExpenceTo.DataBind();
        ddlExpenceTo.Items.Insert(0, new ListItem("Select", "0"));
    }

    private void bindEmployee()
    {
        ddlExpenceTo.DataSource = StockReports.GetDataTable("SELECT Employee_ID,CONCAT(Title,' ',NAME)NAME FROM employee_master WHERE isactive=1 ORDER BY NAME asc");
        ddlExpenceTo.DataValueField = "Employee_ID";
        ddlExpenceTo.DataTextField = "NAME";
        ddlExpenceTo.DataBind();
        ddlExpenceTo.Items.Insert(0, new ListItem("Select", "0"));
    }

    protected void btnsave_Click(object sender, EventArgs e)
    {
        string type = "";
        ExpenceAccntReceipt objRec = new ExpenceAccntReceipt();
        objRec.Location = AllGlobalFunction.Location;
        objRec.HospCode = AllGlobalFunction.HospCode;
        objRec.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
        objRec.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
        if (chkreceived.Checked == true)
        {
            objRec.AmountPaid = -Util.GetDecimal(txtAmount.Text);
            type = "RECEIVED";
        }
        else
        {
            objRec.AmountPaid = Util.GetDecimal(txtAmount.Text);
            type = "PAID";
        }

        objRec.AmtCash = Util.GetDecimal(txtAmount.Text);
        objRec.Date = DateTime.Now;
        objRec.Time = DateTime.Now;
        objRec.ExpenceTypeId = ddlExpenceType.SelectedValue;
        objRec.ExpenceType = ddlExpenceType.SelectedItem.Text;
        objRec.Depositor = Session["id"].ToString();
        if (ddlExpenceTo.Visible)
        {
            objRec.ExpenceToId = ddlExpenceTo.SelectedValue;
            objRec.ExpenceTo = ddlExpenceTo.SelectedItem.Text;
        }
        else if (txtExpenceType.Visible)
        {
            objRec.ExpenceTo = txtExpenceType.Text;
        }

        objRec.Naration = txtRemarks.Text;
        string str = objRec.Insert();
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Common/PrintAccntExpense.aspx?id=" + str.ToString() + "&type=" + type + " ');", true);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.location='" + Request.RawUrl + "';", true);
    }
}