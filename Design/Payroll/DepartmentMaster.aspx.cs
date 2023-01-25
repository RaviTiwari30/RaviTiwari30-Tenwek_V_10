using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;

public partial class Design_Payroll_DepartmentMaster : System.Web.UI.Page
{
    protected void btncancel_Click(object sender, EventArgs e)
    {
        btnSave.Visible = true; ;
        btnUpdate.Visible = false;
        btnCancel.Visible = false;
        lblmsg.Text = "";
        txtDept.Text = "";
        txtempreq.Text = "";
        lblDeptHead.Visible = ddlDeptHeadName.Visible = false;
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (ValidateName(txtDept.Text))
        {
            string Query = "insert into pay_deptartment_master(Dept_Name,EmployeeRequired,IsActive)values('" + txtDept.Text.Replace("'", "''") + "','" + txtempreq.Text.Replace("'", "''") + "','" + rblActive.SelectedItem.Value + "')";
            StockReports.ExecuteDML(Query);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmsg.ClientID + "');", true);

            BindData();
            txtDept.Text = "";
            txtempreq.Text = "";
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM060','" + lblmsg.ClientID + "');", true);
        }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        if (ValidateNameUpdate(txtDept.Text))
        {
            //string str = string.Empty;
            string Query = "update pay_deptartment_master set Dept_Name ='" + txtDept.Text.Replace("'", "''") + "' , EmployeeRequired ='" + txtempreq.Text.Replace("'", "''") + "' ,IsActive=" + rblActive.SelectedItem.Value.ToString() + ",DeptHeadID= '" + ddlDeptHeadName.SelectedItem.Value + "'where Dept_ID=" + ViewState["Dept_ID"].ToString() + "";
            StockReports.ExecuteDML(Query);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM02','" + lblmsg.ClientID + "');", true);
            
            //string[] s = ((Label)EmpGrid.SelectedRow.FindControl("lblrecord")).Text.Split('#');
            //DataTable dt = StockReports.GetDataTable("SELECT pem.`Name`,pem.Dept_ID ,pem.`Employee_ID`FROM pay_employee_master pem INNER JOIN pay_deptartment_master pdm ON pem.`Dept_ID`=pdm.`Dept_ID` WHERE pem.`Dept_ID`=" + s[0].ToString() + "");
            //for (int i = 0; i < dt.Rows.Count; i++)
            //{
            //     str = "delete from pay_leaveapprovalmaster where EmployeeID='"+ dt.Rows[i]["Employee_ID"].ToString()+ "'";
            //}
            BindData();
            txtDept.Text = "";
            txtempreq.Text = "";
            btnSave.Visible = true; ;
            btnUpdate.Visible = false;
            btnCancel.Visible = false;
            lblDeptHead.Visible = ddlDeptHeadName.Visible = false;
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM060','" + lblmsg.ClientID + "');", true);
        }
    }

    protected void EmpGrid_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        EmpGrid.PageIndex = e.NewPageIndex;
        EmpGrid.DataBind();
        BindData();
    }

    protected void EmpGrid_SelectedIndexChanged(object sender, EventArgs e)
    {
        btnSave.Visible = false;
        btnUpdate.Visible = true;
        btnCancel.Visible = true;
        
        string[] s = ((Label)EmpGrid.SelectedRow.FindControl("lblrecord")).Text.Split('#');
        DataTable dt = StockReports.GetDataTable("SELECT pem.`Name`,pem.Dept_ID ,pem.`Employee_ID` FROM pay_employee_master pem INNER JOIN pay_deptartment_master pdm ON pem.`Dept_ID`=pdm.`Dept_ID` WHERE pem.`Dept_ID`=" + s[0].ToString() + "");
        ViewState["DeptHead"] = dt;
        if (dt.Rows.Count > 0)
        {
            ddlDeptHeadName.Visible = true;
            lblDeptHead.Visible = true;
            ddlDeptHeadName.DataSource = dt;
            ddlDeptHeadName.DataTextField = "Name";
            ddlDeptHeadName.DataValueField = "Employee_ID";
            ddlDeptHeadName.DataBind();
        }
        ViewState["Dept_ID"] = s[0].ToString();
        ViewState["Name"] = s[1].ToString();
        ViewState["EmployeeRequired"] = s[2].ToString();
        txtDept.Text = s[1].ToString();
        txtempreq.Text = s[3].ToString();
        ddlDeptHeadName.SelectedIndex = ddlDeptHeadName.Items.IndexOf(ddlDeptHeadName.Items.FindByValue(s[4].ToString()));
        int IsActive = Util.GetInt(rblActive.SelectedItem.Value);

        if (Util.GetString(s[2].ToString()) == "Yes")
        {
            rblActive.SelectedIndex = 0;
        }
        else
        {
            rblActive.SelectedIndex = 1;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindData();
            btnSave.Visible = true; ;
            btnUpdate.Visible = false;
            btnCancel.Visible = false;
            txtempreq.Text = "0";
        }
    }

    protected bool ValidateName(string Name)
    {
        int i = Util.GetInt(StockReports.ExecuteScalar("select count(*) from pay_deptartment_master where Dept_Name='" + Name + "'"));
        if (i > 0)
        { return false; }
        else
        { return true; }
    }

    protected bool ValidateNameUpdate(string Name)
    {
        if (Name == ViewState["Name"].ToString())
        {
            return true;
        }
        int i = Util.GetInt(StockReports.ExecuteScalar("select count(*) from pay_deptartment_master where Dept_Name='" + Name + "'"));
        if (i > 0)
        { return false; }
        else
        { return true; }
    }

    private void BindData()
    {
        EmpGrid.DataSource = StockReports.GetDataTable("select Dept_ID,Dept_Name ,EmployeeRequired,if(IsActive=1,'Yes','No')IsActive,(SELECT em.Name FROM `pay_employee_master` em WHERE em.`Employee_ID`=pdm.DeptHeadID)Name,pdm.DeptHeadID from pay_deptartment_master pdm ");
        EmpGrid.DataBind();
    }
}