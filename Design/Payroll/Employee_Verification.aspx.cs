using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Payroll_employee_verification : System.Web.UI.Page
{
    protected void BindData()
    {
        lblmsg.Text = "";
        StringBuilder sb = new StringBuilder();

        sb.Append(" select EmployeeID,Name,date_format(DOJ,'%d-%b-%Y')DOJ,FatherName,Gender,dept_Name,desi_Name from pay_employee_master  WHERE IsActive=1 ");
        if (txtEmployeeID.Text.Trim() != "" && txtEmployeeName.Text.Trim() != "")
        {
            sb.Append(" and EmployeeID='" + txtEmployeeID.Text.Trim() + "' and Name like '" + txtEmployeeName.Text.Trim() + "%' ");
        }
        else if (txtEmployeeID.Text.Trim() == "" && txtEmployeeName.Text.Trim() != "")
        {
            sb.Append(" and Name like '" + txtEmployeeName.Text.Trim() + "%' ");
        }
        else if (txtEmployeeID.Text.Trim() != "" && txtEmployeeName.Text.Trim() == "")
        {
            sb.Append(" and EmployeeID='" + txtEmployeeID.Text.Trim() + "'");
        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            EmpGrid.DataSource = dt;
            EmpGrid.DataBind();
            BtnSave.Visible = true;
        }
        else
        {
            EmpGrid.DataSource = null;
            EmpGrid.DataBind();
            BtnSave.Visible = false;
            lblmsg.Text = "No Record Found";
        }
    }

    protected void BtnSave_Click(object sender, EventArgs e)
    {
        for (int i = 0; i < EmpGrid.Rows.Count; i++)
        {
            GridViewRow row = EmpGrid.Rows[i];
            int chk_count = ((CheckBoxList)row.FindControl("chk1")).Items.Count;

            string delselectQuery = "select * from pay_employee_verification where EmployeeID='" + EmpGrid.Rows[i].Cells[1].Text + "'";

            DataTable dt11 = StockReports.GetDataTable(delselectQuery);
            if (dt11.Rows.Count > 0)
            {
                string delquery = "delete from pay_employee_verification where EmployeeID='" + EmpGrid.Rows[i].Cells[1].Text + "'";

                StockReports.ExecuteScalar(delquery);
            }

            for (int j = 0; j < chk_count; j++)
            {
                
                bool ischecked = ((CheckBoxList)row.FindControl("chk1")).Items[j].Selected;
                if (ischecked)
                {
                    string insert_query = "insert into pay_employee_verification(EmployeeID,VID,UserID,EntDate) values('" + EmpGrid.Rows[i].Cells[1].Text + "','" + ((CheckBoxList)row.FindControl("chk1")).Items[j].Value + "','" + Session["ID"].ToString() + "',now())";
                    StockReports.ExecuteDML(insert_query);
                }
            }
        }
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmsg.ClientID + "');", true);
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        BindData();
    }

    protected void EmpGrid_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        EmpGrid.PageIndex = e.NewPageIndex;
        BindData();
    }

    protected void EmpGrid_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex >= 0)
        {
            ((CheckBoxList)e.Row.FindControl("Chk1")).DataSource = (DataTable)ViewState["DtVerification"];
            ((CheckBoxList)e.Row.FindControl("Chk1")).DataValueField = "ID";
            ((CheckBoxList)e.Row.FindControl("Chk1")).DataTextField = "Name";
            ((CheckBoxList)e.Row.FindControl("Chk1")).DataBind();

            string strQuery = "SELECT VID from pay_employee_verification pev inner join pay_VerificationTypeMaster pvm on pev.VID=pvm.id where employeeID='" + ((Label)e.Row.FindControl("lblEmployeeID")).Text + "' and pvm.IsActive=1";
            DataTable dtVerification = StockReports.GetDataTable(strQuery);
            if (dtVerification.Rows.Count > 0)
            {
                for (int i = 0; i < dtVerification.Rows.Count; i++)
                {
                    ((CheckBoxList)e.Row.FindControl("Chk1")).Items[((CheckBoxList)e.Row.FindControl("Chk1")).Items.IndexOf(((CheckBoxList)e.Row.FindControl("Chk1")).Items.FindByValue(dtVerification.Rows[i]["VID"].ToString()))].Selected = true;
                }
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
        {
            txtEmployeeID.Focus();
            DataTable dt_Emp_verification = new DataTable();
            string strQuery = "SELECT ID,NAME FROM pay_VerificationTypeMaster WHERE IsActive=1";
            dt_Emp_verification = StockReports.GetDataTable(strQuery);
            ViewState["DtVerification"] = dt_Emp_verification;
        }
    }
}