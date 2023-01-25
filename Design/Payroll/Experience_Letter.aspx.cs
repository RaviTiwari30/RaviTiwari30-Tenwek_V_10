using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Payroll_Experience_Letter : System.Web.UI.Page
{
    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (lblEmpID.Text.Trim() != "")
        {
            StockReports.ExecuteDML("Delete from pay_refrence where EmployeeID='" + lblEmpID.Text + "'");
            StockReports.ExecuteDML("Insert into pay_refrence(EmployeeID,Authority_Name,first_att,second_att,third_att,forth_att,fifth_att,EmpID)values('" + lblEmpID.Text + "','" + txtAuthority.Text.Trim() + "','" + txtEmp_attributes.Text.Trim() + "','" + txtEmp_attributes1.Text.Trim() + "','" + txtEmpAttributes2.Text.Trim() + "','" + txtEmp_Attributes3.Text.Trim() + "','" + txtEmp_Attribtes4.Text.Trim() + "','" + Session["ID"].ToString() + "')");
        }
        lblmsg.Text = "Record Save";
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        EmployeeSearch();
    }

    protected void Clear()
    {
        txtEmp_attributes.Text = "";
        txtEmp_attributes1.Text = "";
        txtEmpAttributes2.Text = "";
        txtEmp_Attributes3.Text = "";
        txtEmp_Attribtes4.Text = "";
        txtAuthority.Text = "";
    }

    protected void EmpGrid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName.ToString() == "Print")
        {
            string EmployeeID = e.CommandArgument.ToString();
            StringBuilder sb1 = new StringBuilder();
            sb1.Append(" select EmployeeID Employee_ID,Concat(Title,' ',Name)Name,FatherName,Dept_Name,Desi_Name,Gender,Date_format(DOL,'%d %b %y')DOL,Date_format(DOB,'%d %b %y')DOB,Date_format(DOJ,'%d %b %y')DOJ,concat(House_No,' ',Street_Name,' ',Locality)Address,City from employee_master where EmployeeID='" + EmployeeID + "'");

            DataTable dtPrint = StockReports.GetDataTable(sb1.ToString());
            if (dtPrint.Rows.Count > 0)
            {
                DataTable dtAttributes = StockReports.GetDataTable("Select * from pay_refrence where EmployeeID='" + EmployeeID + "'");
                DataSet ds = new DataSet();

                ds.Tables.Add(dtPrint.Copy());
                ds.Tables[0].TableName = "table";
                ds.Tables.Add(dtAttributes.Copy());
                ds.Tables[1].TableName = "dtAttributes";
                //ds.WriteXmlSchema("C:/Experience_LetterNew.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "Experience_LetterNew";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Payroll/Report/Commonreport.aspx');", true);
            }
            else
            {
            }
        }
        if (e.CommandName.ToString() == "editemp")
        {
            Clear();
            lblEmpID.Text = e.CommandArgument.ToString();
            DataTable dt = StockReports.GetDataTable(" SELECT * FROM pay_refrence where EmployeeID='" + lblEmpID.Text + "'");
            if (dt.Rows.Count > 0)
            {
                txtEmp_attributes.Text = dt.Rows[0]["first_att"].ToString();
                txtEmp_attributes1.Text = dt.Rows[0]["second_att"].ToString();
                txtEmpAttributes2.Text = dt.Rows[0]["third_att"].ToString();
                txtEmp_Attributes3.Text = dt.Rows[0]["forth_att"].ToString();
                txtEmp_Attribtes4.Text = dt.Rows[0]["fifth_att"].ToString();
                txtAuthority.Text = dt.Rows[0]["Authority_Name"].ToString();
            }
            mpeAttributes.Show();
        }
    }

    protected void EmployeeSearch()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" select EmployeeID Employee_ID,Concat(Title,' ',Name)Name,FatherName,Dept_Name,Desi_Name,Gender,Date_format(DOL,'%d-%b-%Y')DOL,Date_format(DOB,'%d-%b-%Y')DOB,Date_format(DOJ,'%d-%b-%Y')DOJ,concat(House_No,' ',Street_Name,' ',Locality)Address,City from Pay_employee_master where DOL!='0000-00-00 00-00' AND DOL!='0001-01-01 00:00:00'");
        if (txtEmp_ID.Text != "")
        {
            sb.Append(" and EmployeeID='" + txtEmp_ID.Text + "' ");
        }
        if (txtEmpName.Text.Trim() != "")
        {
            sb.Append(" and Name like'" + txtEmpName.Text.Trim() + "%'");
        }
        sb.Append(" order by EmployeeID");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            EmpGrid.DataSource = dt;
            EmpGrid.DataBind();
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
            // lblmsg.Text = "Record Not Found";
            EmpGrid.DataSource = null;
            EmpGrid.DataBind();
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtEmp_ID.Focus();
            EmployeeSearch();
        }
    }
}