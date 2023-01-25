using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.IO;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_EDP_UserManager : System.Web.UI.Page
{
    #region Data Binding

    private void BindEmployee()
    {
        StringBuilder sb = new StringBuilder();

        if (ddlRole.SelectedValue == "0")
        {
            sb.Append(" select EM.Employee_ID,em.Name,l.UserName,'false' ltype,'true' ptype from employee_master em left join f_login l on");
            sb.Append(" em.Employee_ID=l.EmployeeID where l.EmployeeID is null order by em.Name");
        }
        else
        {
            sb.Append(" select EM.Employee_ID,em.Name,l.UserName,if(l.username is null,'true','false')ltype,if(l.username is null,'true','false')ptype from employee_master em inner join f_login l on");
            sb.Append(" em.Employee_ID=l.EmployeeID where l.RoleID=" + ddlRole.SelectedValue + " order by em.Name");
        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            grdRole.DataSource = dt;
            grdRole.DataBind();
            ViewState.Add("Role", dt);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            //lblMsg.Text = "No Record Found";
            grdRole.DataSource = null;
            grdRole.DataBind();
        }
    }

    private void BindRole()
    {
        string str = "select ID,RoleName from f_rolemaster order by RoleName";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlRole.DataSource = dt;
            ddlRole.DataTextField = "RoleName";
            ddlRole.DataValueField = "ID";
            ddlRole.DataBind();
            ddlRole.Items.Insert(0, new ListItem("NoRole", "0"));

            ddlRoleRight.DataSource = dt;
            ddlRoleRight.DataTextField = "RoleName";
            ddlRoleRight.DataValueField = "ID";
            ddlRoleRight.DataBind();
        }
    }

    #endregion Data Binding

    #region Events Handling

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (ViewState["EmpId"] != null)
        {
            string EmpId = Convert.ToString(ViewState["EmpId"]);

            if (StockReports.ExecuteDML("call InsertRole('" + EmpId + "'," + ddlRoleRight.SelectedValue + ")"))
            {
                lblMsg.Text = "Record Saved Successfully";
                ViewState.Remove("EmpId");
                BindEmployee();
            }
            else
                lblMsg.Text = "Error...";
        }
        else
            lblMsg.Text = "Error...";
    }

    protected void btnSavePassword_Click(object sender, EventArgs e)
    {
        string str = "select * from f_login where username='" + txtUser.Text.Trim() + "'";
        DataTable dt = new DataTable();

        dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM159','" + lblMsg.ClientID + "');", true);
        //lblMsg.Text = "Sorry!!! User Name Already Exist";
        else
        {
            if (ViewState["EmpId"] != null)
            {
                string EmpId = Convert.ToString(ViewState["EmpId"]);
                string Insert = "update f_login set username='" + txtUser.Text.Trim() + "',Password='" + txtPassword.Text.Trim() + "' where EmployeeID='" + EmpId + "'";

                if (StockReports.ExecuteDML(Insert))
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
                    //lblMsg.Text = "Record Saved Successfully";
                    ViewState.Remove("EmpId");
                    ViewState.Remove("Role");
                    BindEmployee();
                }
                else
                    lblMsg.Text = "Error...";
            }
            else
                lblMsg.Text = "Error...";
        }
    }

    protected void btnSavePwd_Click(object sender, EventArgs e)
    {
        if (ViewState["EmpId"] != null)
        {
            string str = "update f_login set password='" + txtpwd.Text.Trim() + "' where EmployeeID='" + Convert.ToString(ViewState["EmpId"]) + "'";
            if (StockReports.ExecuteDML(str))
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM160','" + lblMsg.ClientID + "');", true);
            //lblMsg.Text = "Password Changed successfully";
            else
                lblMsg.Text = "Error...";
        }
    }

    protected void btnUser_Click(object sender, EventArgs e)
    {
        BindEmployee();
    }

    protected void grdRole_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "AEdit")
        {
            if (ViewState["Role"] != null)
            {
                DataTable dt = new DataTable();
                dt = (DataTable)ViewState["Role"];

                string EmpID = Util.GetString(e.CommandArgument);
                ViewState.Add("EmpId", EmpID);

                DataRow[] dr = dt.Select("Employee_ID='" + EmpID + "'");
                if (dr.Length > 0)
                    lblEmpName.Text = Util.GetString(dr[0]["Name"]);

                mpeCreateGroup.Show();
            }
            else
                lblMsg.Text = "Error...";
        }
        if (e.CommandName == "login")
        {
            if (ViewState["Role"] != null)
            {
                DataTable dt = new DataTable();
                dt = (DataTable)ViewState["Role"];

                string EmpID = Util.GetString(e.CommandArgument);
                ViewState.Add("EmpId", EmpID);

                DataRow[] dr = dt.Select("Employee_ID='" + EmpID + "'");
                if (dr.Length > 0)
                {
                    lblEmp.Text = Util.GetString(dr[0]["Name"]);
                    txtUser.Text = Util.GetString(dr[0]["UserName"]);
                }
                ModalPopupExtender1.Show();
            }
            else
                lblMsg.Text = "Error...";
        }
        if (e.CommandName == "Password")
        {
            if (ViewState["Role"] != null)
            {
                DataTable dt = new DataTable();
                dt = (DataTable)ViewState["Role"];

                string EmpID = Util.GetString(e.CommandArgument);
                ViewState.Add("EmpId", EmpID);

                DataRow[] dr = dt.Select("Employee_ID='" + EmpID + "'");
                if (dr.Length > 0)
                    lblemp1.Text = Util.GetString(dr[0]["Name"]);

                ModalPopupExtender2.Show();
            }
            else
                lblMsg.Text = "Error...";
        }
    }

    private void RoleBind()
    {
        // string str = "  SELECT rm.ID,rm.RoleName FROM f_rolemaster rm INNER JOIN f_login l ON l.RoleID=rm.ID AND rm.Active=1 AND l.Active=1 AND l.EmployeeID='" + EmpID + "'  GROUP BY rm.ID ORDER BY rm.RoleName  ";
        string str = "  SELECT rm.ID,rm.RoleName FROM f_rolemaster rm where rm.Active=1  GROUP BY rm.ID ORDER BY rm.RoleName  ";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0 && dt != null)
        {
            ddlRole1.DataSource = dt;
            ddlRole1.DataTextField = "RoleName";
            ddlRole1.DataValueField = "ID";
            ddlRole1.DataBind();
            ddlRole1.Items.Insert(0, "Select");

            ddldeptformenu.DataSource = dt;
            ddldeptformenu.DataTextField = "RoleName";
            ddldeptformenu.DataValueField = "ID";
            ddldeptformenu.DataBind();
            ddldeptformenu.Items.Insert(0, "Select");
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindRole();
            RoleBind();
        }
    }

    #endregion Events Handling

    protected void btnSaveRole_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            int Med = 0, Gen = 0;
            if (rbtMed.Checked == true)
                Med = 1;
            if (rbtGen.Checked == true)
                Gen = 1;

            if (Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select count(*) from f_rolemaster where upper(RoleName)='" + txtRole.Text.Trim().ToUpper() + "' and Active=1")) == 0)
            {
                Ledger_Master objLedMas = new Ledger_Master();
                objLedMas.LegderName = txtRole.Text.Trim();
                objLedMas.GroupID = "DPT";
                //string LedgerNo = objLedMas.Insert();
                string LedgerNo = objLedMas.Insert();
                if (rbtrolldeptlsit.SelectedIndex == 1)
                    LedgerNo = "";
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "insert into f_rolemaster(RoleName,Active,IsStore,IsGeneral,IsMedical,DeptLedgerNo) values('" + txtRole.Text.Trim() + "',1," + rbtnStore.SelectedValue + "," + Gen + "," + Med + ",'" + LedgerNo + "')");

                DataSet ds = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, "SELECT max(ID)roleid from f_rolemaster");

                int roleid = Util.GetInt(ds.Tables[0].Rows[0]["roleid"]);
                if (ddldeptformenu.SelectedItem.Text != "Select")
                {
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "INSERT INTO f_file_role(urlID,roleid,EmployeeID,Active,Sno) SELECT urlID," + roleid + ",EmployeeID,Active,Sno FROM f_file_role WHERE roleid=" + ddldeptformenu.SelectedItem.Value + "  ");
                    if (Directory.Exists(HttpContext.Current.Server.MapPath("~/Design/MenuData")))
                    {
                        System.IO.File.Copy(HttpContext.Current.Server.MapPath("~/Design/MenuData/" + ddldeptformenu.SelectedItem.Text + ".xml"), HttpContext.Current.Server.MapPath("~/Design/MenuData/" + txtRole.Text + ".xml"));
                    }
                }
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM161','" + lblMsg.ClientID + "');", true);
            }
            lblMsg.Text = "Record Save Successfully";
            Tranx.Commit();
          
            LoadCacheQuery.dropCache("Currency");
        }
        catch (Exception ex)
        {
            lblMsg.Text = "Error";
            Tranx.Rollback();
           
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();

        }
        BindRole();
    }

    protected void btnUpdateRole_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        string LedgerNo = "";
        try
        {
            int Med = 0, Gen = 0;
            if (rbtMed.Checked == true)
                Med = 1;
            if (rbtGen.Checked == true)
                Gen = 1;

            if (Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select count(*) from f_rolemaster where id='" + ddlRole1.SelectedValue + "' and Active=1")) > 0)
            {
                string DeptLedNo = StockReports.ExecuteScalar(" select DeptLedgerNo from f_rolemaster where id=" + ddlRole1.SelectedValue + " ");
                if (DeptLedNo == "")
                {
                    if (rbtrolldeptlsit.SelectedIndex == 0)
                    {
                        Ledger_Master objLedMas = new Ledger_Master();
                        objLedMas.LegderName = txtRole.Text.Trim();
                        objLedMas.GroupID = "DPT";
                        LedgerNo = objLedMas.Insert();
                    }
                }
                else
                    LedgerNo = DeptLedNo;

                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Update f_rolemaster set Active=1,IsStore=" + rbtnStore.SelectedValue + ",IsGeneral=" + Gen + ",IsMedical=" + Med + ",DeptLedgerNo='" + LedgerNo + "' where id=" + ddlRole1.SelectedValue + "");
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM161','" + lblMsg.ClientID + "');", true);
            }
            lblMsg.Text = "Updated";
            Tranx.Commit();
          
            ClearData();
            lblMsg.Text = "Updated";
            LoadCacheQuery.dropCache("Currency");
        }
        catch (Exception ex)
        {
            lblMsg.Text = "Error";
            Tranx.Rollback();
          
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
        BindRole();
    }

    private void ClearData()
    {
        ddlRole1.SelectedIndex = 0;
        ddldeptformenu.SelectedIndex = 0;
        rbtrolldeptlsit.SelectedIndex = 0;
        rbtnStore.SelectedIndex = 0;
        rbtMed.Checked = false;
        rbtGen.Checked = false;
    }

    protected void btnRole_Click(object sender, EventArgs e)
    {
        txtRole.Text = "";
        txtRole.Visible = true;
        ddlRole1.Visible = false;
        btnUpdateRole.Visible = false;
        btnSaveRole.Visible = true;
        MdpRole.Show();
    }

    protected void ddlRole1_SelectedIndexChanged(object sender, EventArgs e)
    {
        ddldeptformenu.SelectedIndex = ddlRole1.SelectedIndex;
        string str = "SELECT * FROM f_rolemaster where id=" + ddlRole1.SelectedValue + " ";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {
            if (dt.Rows[0]["DeptLedgerNo"].ToString() != "")
                rbtrolldeptlsit.SelectedIndex = 0;
            else
                rbtrolldeptlsit.SelectedIndex = 1;

            if (dt.Rows[0]["IsStore"].ToString() == "1")
            {
                rbtnStore.SelectedIndex = 0;
                rbtGen.Visible = true;
                rbtMed.Visible = true;
                lblRightsFor.Visible = true;
            }
            else
            {
                rbtnStore.SelectedIndex = 1;
                rbtGen.Visible = false;
                rbtMed.Visible = false;
                lblRightsFor.Visible = false;
            }

            if (dt.Rows[0]["IsGeneral"].ToString() == "1")
                rbtGen.Checked = true;
            else
                rbtGen.Checked = false;

            if (dt.Rows[0]["IsMedical"].ToString() == "1")
                rbtMed.Checked = true;
            else
                rbtMed.Checked = false;

            MdpRole.Show();
        }
    }

    protected void btnEditRole_Click(object sender, EventArgs e)
    {
        txtRole.Visible = false;
        ddlRole1.Visible = true;
        btnUpdateRole.Visible = true;
        btnSaveRole.Visible = false;
        RoleBind();
        MdpRole.Show();
    }

    protected void rbtnStore_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rbtnStore.SelectedValue == "1")
        {
            rbtMed.Visible = true;
            rbtGen.Visible = true;
            lblRightsFor.Visible = true;
            MdpRole.Show();
        }
        else
        {
            rbtMed.Visible = false;
            rbtGen.Visible = false;
            lblRightsFor.Visible = false;
            rbtMed.Checked = false;
            rbtGen.Checked = false;
            MdpRole.Show();
        }
    }
}