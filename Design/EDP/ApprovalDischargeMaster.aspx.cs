using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_EDP_ApprovalTypeMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            All_LoadData.bindEmployee(ddlEmployee,"Select");
            All_LoadData.bindDocTypeList(ddlDepartment, 5, "Select");
        }
    }    
    protected void btnSave_Click(object sender, EventArgs e)
    {
        string str = "", DoctorID = "";
        int IsApproved = 0;
       
        if (ddlDepartment.SelectedIndex == 0)
        {
            lblMsg.Text = "Kindly select Department";
            return;
        }
        if (ddlEmployee.SelectedIndex == 0)
        {
            lblMsg.Text = "Kindly select Employee";
            return;
        }
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (chkAprove.Checked)
                IsApproved = 1;
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "Delete From d_ApprovalAuthorization WHERE Department='" + ddlDepartment.SelectedValue + "' AND Employee_Id='" + ddlEmployee.SelectedValue + "' ");
            foreach (ListItem li in chkDoctor.Items)
            {
                DoctorID = li.Value;
                if (li.Selected==true)
                {
                    str = "INSERT INTO d_ApprovalAuthorization(Department,DoctorID,Employee_Id,IsApprove,CreatedBy)VALUES( " +
                          " '" + ddlDepartment.SelectedValue + "','" + DoctorID + "','" + ddlEmployee.SelectedValue + "'," + IsApproved + ",'" + Session["Id"].ToString() + "')";
                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str.ToString());
                }
            }
            Tnx.Commit();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Record Saved');", true);
            btnSave.Enabled = false;     
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "location.href='ApprovalDischargeMaster.aspx';", true);                 
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

    protected void ddlDepartment_SelectedIndexChanged(object sender, EventArgs e)
    {
        DataTable dt = StockReports.GetDataTable("SELECT * FROM (SELECT  DM.Name,DM.DoctorID AS DID, IFNULL((SELECT Department FROM doctor_hospital WHERE DoctorID=dm.DoctorID LIMIT 1),'')Department FROM doctor_master DM WHERE Dm.DoctorID<>'' AND DM.`IsActive`=1 )t WHERE t.Department = '" + ddlDepartment.SelectedItem.Text + "' ORDER BY NAME ");
        if (dt != null && dt.Rows.Count > 0)
        {
            chkDoctor.DataSource = dt;
            chkDoctor.DataValueField = "DID";
            chkDoctor.DataTextField = "Name";
            chkDoctor.DataBind();

                DataTable dt1 = StockReports.GetDataTable("SELECT DoctorID,IsApprove FROM d_ApprovalAuthorization WHERE employee_id='" + ddlEmployee.SelectedValue + "' AND department='" + ddlDepartment.SelectedValue + "'");
                if (dt1 != null && dt1.Rows.Count > 0)
                {
                    foreach (DataRow dr in dt1.Rows)
                    {
                        foreach (ListItem li in chkDoctor.Items)
                        {
                            if (li.Value == dr["DoctorID"].ToString())
                                li.Selected = true;
                        }
                    }
                    if (dt1.Rows[0]["IsApprove"].ToString() == "1")
                        chkAprove.Checked = true;
                }
        }
        else
        {
            chkDoctor.Items.Clear();
        }
    }
    protected void chkAllDoctor_CheckedChanged(object sender, EventArgs e)
    {
        foreach (ListItem li in chkDoctor.Items)
        {
            if (chkAllDoctor.Checked)
                li.Selected = true;
            else
                li.Selected = false;
        }
    }

    protected void rbtnChange_SelectedIndexChanged(object sender, EventArgs e)
    {
        if(rbtnChange.SelectedValue=="1")
        btnSave.Text = "Save";
        else
            btnSave.Text = "Update";
        ddlDepartment.SelectedIndex = 0;
        ddlEmployee.SelectedIndex = 0;
        ddlDepartment_SelectedIndexChanged(sender, e);
    }
}