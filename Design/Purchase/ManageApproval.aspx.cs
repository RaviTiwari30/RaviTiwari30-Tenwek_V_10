using System;
using System.Data;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Purchase_ManageApproval : System.Web.UI.Page
{
    protected void Button1_Click(object sender, EventArgs e)
    {
        try
        {
            if (ddlEmployee.SelectedIndex == 0)
            {
                lblMsg.Text = " Please select the Employee Name";
                return;
            }
            string strr = " SELECT EmployeeID AS Employee_ID FROM f_Purchase_approval WHERE employeeID='" + ddlEmployee.SelectedValue + "'  AND ApprovalFor = '" + ddlAppFor.SelectedValue + "'";
            DataTable dt = StockReports.GetDataTable(strr);
            if (dt != null && dt.Rows.Count > 0)
            {
                lblMsg.Text = " This Employee is Already Exist ";
                return;
            }
            else
            {
                SaveSign();
                string str = " INSERT INTO f_Purchase_approval(EmployeeID,Approval,EntryDate,ApprovalFor) VALUES ('" + ddlEmployee.SelectedValue + "','1','" + DateTime.Now.ToString("yyyy-MM-dd") + "','" + ddlAppFor.SelectedValue + "') ";
                StockReports.ExecuteDML(str);
                bindgrid();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
            }
        }
        catch (Exception ex)
        { lblMsg.Text = ex.Message; }
    }

    protected void ddlAppFor_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlAppFor.SelectedValue == "PO")
        {
           lblSig.Visible = true;
            fuSign.Visible = true;
            
        }
        else
        {
            lblSig.Visible = false;
            fuSign.Visible = false;
        }
    }

    protected void grdObs_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        try
        {
            int id = Convert.ToInt32(((Label)grdObs.Rows[e.RowIndex].FindControl("Label1")).Text);
            string str = "DELETE  FROM f_Purchase_approval WHERE ID=" + id + "";
            StockReports.ExecuteDML(str);
            bindgrid();
        }
        catch
        {
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["ID"] = Session["ID"].ToString();
            BindEmployee();
            bindgrid();
        }
    }

    private void BindEmployee()
    {
        try
        {
            string str = "SELECT em.EmployeeID AS Employee_ID,NAME FROM employee_master em INNER JOIN f_login fl ON fl.EmployeeID=em.EmployeeID WHERE em.IsActive=1 group by fl.EmployeeID ORDER BY NAME";
            DataTable dt = StockReports.GetDataTable(str);
            if (dt != null && dt.Rows.Count > 0)
            {
                ddlEmployee.DataSource = dt;
                ddlEmployee.DataTextField = "Name";
                ddlEmployee.DataValueField = "Employee_ID";
                ddlEmployee.DataBind();
                ddlEmployee.Items.Insert(0, "");
            }
            else
            {
                ddlEmployee.Items.Clear();
            }
        }
        catch (Exception ex)
        { lblMsg.Text = ex.Message; }
    }

    private void bindgrid()
    {
        try
        {
            string str = " SELECT Ap.Id AS ID,Ap.EmployeeID AS EmployeeID,em.NAME AS EmpName,Ap.ApprovalFor   "
                + " FROM f_Purchase_approval Ap "
                + " INNER JOIN employee_master em ON em.Employeeid = Ap.EmployeeId ";
            DataTable dt = StockReports.GetDataTable(str);
            if (dt != null && dt.Rows.Count > 0)
            {
                grdObs.DataSource = dt;
                grdObs.DataBind();
            }
            else
            {
                grdObs.DataSource = null;
                grdObs.DataBind();
            }
        }
        catch (Exception ex)
        { lblMsg.Text = ex.Message; }
    }

   

    private void SaveSign()
    {
        if (fuSign.HasFile)
        {
        string directoryPath = Server.MapPath("~/Design/Store/Signature");
        if (!Directory.Exists(directoryPath))
            {
            Directory.CreateDirectory(directoryPath);
            }


            fuSign.SaveAs(Server.MapPath("~/Design/Store/Signature/" + ddlEmployee.SelectedValue + ".jpg"));
        }
    }
}