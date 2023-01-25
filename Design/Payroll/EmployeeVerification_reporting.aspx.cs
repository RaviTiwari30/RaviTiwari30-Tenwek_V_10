using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Payroll_EmployeeVerification_reporting : System.Web.UI.Page
{
    protected void BtnViewByDept_Click(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        bool check = false;
        int count = 0;
        for (int i = 0; i < Chk1.Items.Count; i++)
        {
            if (Chk1.Items[i].Selected == true)
            {
                check = true;
                lblmsg.Text = "";
            }
        }
        if (check == false)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM192','" + lblmsg.ClientID + "');", true);
            return;
        }

        string strQuery = "";
        string deptname = "";
        string deptnamestring = "";
        for (int i = 0; i < Chk1.Items.Count; i++)
        {
            if (Chk1.Items[i].Selected == true)
            {
                if (deptname == "" & deptnamestring == "")
                {
                    deptname = "'" + Chk1.Items[i].Value + "'";
                    deptnamestring = "" + Chk1.Items[i].Text + "";

                    count++;
                }
                else
                {
                    deptname += ",'" + Chk1.Items[i].Value + "'";
                    deptnamestring += ", " + Chk1.Items[i].Text + "";
                    count++;
                }
            }
        }
        string DeptID = string.Empty;
        for (int i = 0; i < chkDepartment.Items.Count; i++)
        {
            if (chkDepartment.Items[i].Selected)
            {
                DeptID += chkDepartment.Items[i].Value;
                DeptID += ",";
            }
        }
        int index = DeptID.Length;
        if (index > 0)
        {
            DeptID = DeptID.Substring(0, index - 1);
        }
        if (rb1.SelectedItem.Value.ToString() == "1")
        {
            strQuery = " SELECT EmployeeID,VID,ee.Name,pv.Name'VName',DOJ 'D.O.J.',DOB,Desi_Name,Dept_name FROM pay_employee_verification ev INNER JOIN pay_employee_master ee ON ee.EmployeeID=ev.EmployeeID INNER JOIN pay_verificationtypemaster pv ON ev.VID=pv.ID WHERE vid IN (" + deptname + ") and ee.IsActive=1 ";
        }
        else
        {
            strQuery = " SELECT EmployeeID EmployeeID,emp.Name,vm.Name'VName',DOJ 'D.O.J.',DOB,Desi_Name,Dept_name FROM pay_employee_master emp INNER JOIN pay_verificationtypemaster vm ON vm.ID IN (" + deptname + ") AND emp.IsActive=1 LEFT JOIN pay_employee_verification empv ON emp.EmployeeID=empv.EmployeeID AND empv.VID=vm.ID WHERE empv.VID  IS NULL ";
        }
        if (DeptID.Length > 0)
        {
            strQuery += " and Dept_ID in (" + DeptID + ") ";
        }
        strQuery += " order by EmployeeID ";

        DataTable dt_EMP_Verify = new DataTable();
        dt_EMP_Verify = StockReports.GetDataTable(strQuery);

        //Label1.Text = deptnamestring;

        DataColumn dc = new DataColumn("vp", typeof(System.String));
        dc.DefaultValue = rb1.SelectedValue;
        dt_EMP_Verify.Columns.Add(dc);

        dc = new DataColumn("Veri_Name", typeof(System.String));
        dc.DefaultValue = deptnamestring;
        dt_EMP_Verify.Columns.Add(dc);
        if (dt_EMP_Verify.Rows.Count > 0)
        {
            DataSet ds_EMP_Verify = new DataSet();
            ds_EMP_Verify.Tables.Add(dt_EMP_Verify.Copy());
            Session["ReportName"] = "DeptVerify";
            Session["ds"] = ds_EMP_Verify;

            //ds_EMP_Verify.WriteXmlSchema("C:\\Dept_EMP_Verify.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('../../Design/Payroll/Report/Commonreport.aspx');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
            //lblmsg.Text = "No Record Found";
        }
    }

    protected void cb1_CheckedChanged(object sender, EventArgs e)
    {
        if (cb1.Checked == false)
        {
            foreach (ListItem listItem in Chk1.Items)
            {
                listItem.Selected = false;
            }
        }

        if (cb1.Checked == true)
        {
            foreach (ListItem listItem in Chk1.Items)
            {
                listItem.Selected = true;
            }
        }
    }

    protected void chkSelectALLDepartment_CheckedChanged(object sender, EventArgs e)
    {
        if (chkSelectALLDepartment.Checked)
        {
            foreach (ListItem listItem in chkDepartment.Items)
            {
                listItem.Selected = true;
            }
        }
        else
        {
            foreach (ListItem listItem in chkDepartment.Items)
            {
                listItem.Selected = false;
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindDepartment();

            DataTable dt_Verification_Name = new DataTable();
            string strQuery = "SELECT ID,Name FROM pay_verificationtypemaster WHERE IsActive=1";
            dt_Verification_Name = StockReports.GetDataTable(strQuery);
            Chk1.DataSource = dt_Verification_Name;
            Chk1.DataValueField = "ID";
            Chk1.DataTextField = "Name";
            Chk1.DataBind();
        }
    }

    private void BindDepartment()
    {
        DataTable dt = StockReports.GetDataTable("select Dept_ID,Dept_Name from Pay_deptartment_master where IsActive=1");
        chkDepartment.DataSource = dt;
        chkDepartment.DataValueField = "Dept_ID";
        chkDepartment.DataTextField = "Dept_Name";

        chkDepartment.DataBind();
    }
}