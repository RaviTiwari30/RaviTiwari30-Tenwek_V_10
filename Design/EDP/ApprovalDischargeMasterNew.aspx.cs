using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_EDP_ApprovalDischargeMasterNew : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindEmployee();
        }
    }

    private void bindEmployee()
    {
        DataTable dt = StockReports.GetDataTable("SELECT CONCAT(em.EmployeeID,'#',de.DoctorID) AS EmployeeID, em.Name FROM Employee_master em INNER JOIN `doctor_employee` de ON de.`EmployeeID`=em.`EmployeeID` WHERE em.IsActive=1 GROUP BY em.`EmployeeID` ORDER BY em.Name; ");
        if (dt != null && dt.Rows.Count > 0)
        {
            chkEmployee.DataSource = dt;
            chkEmployee.DataValueField = "EmployeeID";
            chkEmployee.DataTextField = "Name";
            chkEmployee.DataBind();

            DataTable dt1 = StockReports.GetDataTable("SELECT CONCAT(de.EmployeeID,'#',de.DoctorID) AS EmployeeID FROM d_ApprovalAuthorization de WHERE IsActive=1 and de.IsApprove=1 ");
            if (dt1 != null && dt1.Rows.Count > 0)
            {
                foreach (DataRow dr in dt1.Rows)
                {
                    foreach (ListItem li in chkEmployee.Items)
                    {
                        if (li.Value == dr["EmployeeID"].ToString())
                            li.Selected = true;
                    }
                }
   
            }
        }
        else
        {
            chkEmployee.Items.Clear();
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        string str = string.Empty;
        string deptQuery= string.Empty;
        int departmentID= 0;
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "UPDATE d_ApprovalAuthorization da SET da.`IsActive`=0,da.`UpdatedBy`='" + Session["ID"].ToString() + "',da.`UpdatedOn`=NOW() WHERE da.`IsActive`=1 ");
            foreach (ListItem li in chkEmployee.Items)
            {
                if (li.Selected == true)
                {
                     deptQuery ="SELECT tm.`ID` FROM doctor_hospital dh INNER JOIN type_master tm ON tm.`Name`=dh.`Department` AND tm.`TypeID`=5 WHERE DoctorID='" + li.Value.Split('#')[1].ToString() + "' LIMIT 1 ";
                     departmentID = Util.GetInt( MySqlHelper.ExecuteScalar(Tnx, CommandType.Text,deptQuery ));
                    str = "INSERT INTO d_ApprovalAuthorization(Department,DoctorID,EmployeeID,IsApprove,CreatedBy)VALUES( " +
                          " '" + departmentID + "','" + li.Value.Split('#')[1].ToString() + "','" + li.Value.Split('#')[0].ToString() + "',1,'" + Session["ID"].ToString() + "')";
                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str.ToString());
                }
            }
            Tnx.Commit();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Rights Updated Successfully');", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "location.href='ApprovalDischargeMasterNew.aspx';", true);
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            lblMsg.Text = "Error";
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void chkAllEmployee_CheckedChanged(object sender, EventArgs e)
    {
        foreach (ListItem li in chkEmployee.Items)
        {
            if (chkAllEmployee.Checked)
                li.Selected = true;
            else
                li.Selected = false;
        }
    }

}