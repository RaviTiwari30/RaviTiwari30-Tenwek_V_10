using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_Payroll_PayrollBankMaster : System.Web.UI.Page
{
    protected void btncancel_Click(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        btnSave.Visible = true; ;
        btnUpdate.Visible = false;
        btnCancel.Visible = false;
        Clear();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (ddlBankName.SelectedIndex != 0)
        {
            if (ValidateBranchName(txtBranchName.Text.Trim(), ddlBankName.SelectedItem.Text))
            {
                if (ValidateBranchCode(txtBranchCode.Text.Trim()))
                {
                    MySqlConnection con = new MySqlConnection();
                    con = Util.GetMySqlCon();
                    con.Open();
                    MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
                    try
                    {
                        string BankCode = Util.GetString(StockReports.ExecuteScalar("Select BankCode from pay_bankmaster where BankName='" + ddlBankName.SelectedItem.Text + "' and Bank_ID='" + ddlBankName.SelectedItem.Value + "'"));
                        if (Util.GetString(BankCode).ToString() != "")
                        {
                            string Query = "INSERT INTO Pay_BranchMaster(Bank_ID,BankName,BankCode,BranchName,BranchCode,IsActive,createdBy)VALUES('" + ddlBankName.SelectedItem.Value + "','" + ddlBankName.SelectedItem.Text + "','" + BankCode.ToString() + "','" + txtBranchName.Text.Trim() + "','" + txtBranchCode.Text.Trim() + "','" + rblActive.SelectedItem.Value + "','" + ViewState["ID"].ToString() + "') ";
                            StockReports.ExecuteDML(Query);
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmsg.ClientID + "');", true);
                            BindData();
                            Clear();
                        }
                    }
                    catch (Exception ex)
                    {
                        if (ex.InnerException.InnerException.Message.Contains("Duplicate entry"))
                        {
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM024','" + lblmsg.ClientID + "');", true);
                        }
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM07','" + lblmsg.ClientID + "');", true);
                        tranX.Rollback();
                        tranX.Dispose();
                        con.Close();
                        con.Dispose();
                    }
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM102','" + lblmsg.ClientID + "');", true);
                    //lblmsg.Text = "Branch Code Already Exists";
                }
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM103','" + lblmsg.ClientID + "');", true);
                //lblmsg.Text = "Branch Name Already Exists";
            }
        }
    }

    protected void btnSaveBank_Click(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        if (ValidateBankName(txtNewBankName.Text.Trim()))
        {
            if (ValidateBankCode(txtNewBankCode.Text.Trim()))
            {
                MySqlConnection con = new MySqlConnection();
                con = Util.GetMySqlCon();
                con.Open();
                MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
                try
                {
                    string Query = "INSERT INTO Pay_BankMaster(BankName,BankCode,createdBy)VALUES('" + txtNewBankName.Text.Trim() + "','" + txtNewBankCode.Text.Trim() + "','" + ViewState["ID"].ToString() + "') ";
                    StockReports.ExecuteDML(Query);
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmsg.ClientID + "');", true);
                    AllLoadDate_Payroll.BindBankNamePayroll(ddlBankName);
                    txtNewBankCode.Text = "";
                    txtNewBankName.Text = "";
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                }
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM179','" + lblmsg.ClientID + "');", true);
                //lblmsg.Text = "Bank Code Already Exists";
            }
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM180','" + lblmsg.ClientID + "');", true);
            //lblmsg.Text = "Bank Name Already Exists";
        }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        try
        {
            if (ddlBankName.SelectedIndex != 0)
            {
                //if (ValidateBranchNameUpdate(txtBranchName.Text.Trim(), ddlBankName.SelectedItem.Text))
                //{
                string BankCode = Util.GetString(StockReports.ExecuteScalar("Select BankCode from pay_bankmaster where BankName='" + ddlBankName.SelectedItem.Text + "' and Bank_ID='" + ddlBankName.SelectedItem.Value + "'"));
                string Query = "update Pay_BranchMaster set BankName='" + ddlBankName.SelectedItem.Text + "' ,Bank_ID='" + ddlBankName.SelectedItem.Value + "',BankCode='" + BankCode.ToString() + "',BranchName='" + txtBranchName.Text.Trim() + "',BranchCode='" + txtBranchCode.Text.Trim() + "',IsActive='" + rblActive.SelectedItem.Value + "'  where Branch_Id='" + ViewState["Id"].ToString() + "' ";
                StockReports.ExecuteDML(Query);
                string query1 = "update pay_bankmaster set IsActive='" + rblActive.SelectedItem.Value + "'  where BankName='" + ddlBankName.SelectedItem.Text + "'";
                StockReports.ExecuteDML(query1);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM02','" + lblmsg.ClientID + "');", true);
                BindData();
                Clear();
                btnSave.Visible = true; ;
                btnUpdate.Visible = false; ;
                btnCancel.Visible = false;
                //}
                //else
                //{
                //    lblmsg.Text = "Branch Name Already Exists";
                //}
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM104','" + lblmsg.ClientID + "');", true);
                //lblmsg.Text = "Select Bank Name";
            }
            //else
            //{
            //    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM024','" + lblmsg.ClientID + "');", true);
            //}
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM102','" + lblmsg.ClientID + "');", true);
            //lblmsg.Text = "Branch Code Already Exists";
            // ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM07','" + lblmsg.ClientID + "');", true);
        }
    }

    protected void Clear()
    {
        txtBranchName.Text = "";
        txtBranchCode.Text = "";
        rblActive.SelectedIndex = 0;
        ddlBankName.SelectedIndex = 0;
    }

    protected void grdBank_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        grdBank.PageIndex = e.NewPageIndex;
        BindData();
    }

    protected void grdBank_SelectedIndexChanged(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        btnSave.Visible = false;
        btnUpdate.Visible = true;
        btnCancel.Visible = true;
        string[] s = ((Label)grdBank.SelectedRow.FindControl("lblrecord")).Text.Split('#');
        ViewState["Id"] = s[0].ToString();

        ddlBankName.SelectedIndex = ddlBankName.Items.IndexOf(ddlBankName.Items.FindByText(s[1].ToString()));
        ViewState["BranchName"] = s[3].ToString();
        ViewState["BankName"] = s[1].ToString();
        txtBranchName.Text = s[3].ToString();
        txtBranchCode.Text = s[4].ToString();
        if (Util.GetInt(s[5].ToString()) == 1)
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
            AllLoadDate_Payroll.BindBankNamePayroll(ddlBankName);
            btnSave.Visible = true; ;
            btnUpdate.Visible = false; ;
            btnCancel.Visible = false;
            BindData();
            ViewState["ID"] = Session["ID"].ToString();
        }
    }

    protected bool ValidateBankCode(string BankCode)
    {
        int i = Util.GetInt(StockReports.ExecuteScalar("select count(*) from Pay_BankMaster where BankCode='" + BankCode + "'"));
        if (i > 0)
        {
            return false;
        }
        else
        {
            return true;
        }
    }

    protected bool ValidateBankName(string BankName)
    {
        int i = Util.GetInt(StockReports.ExecuteScalar("select count(*) from Pay_BankMaster where BankName='" + BankName + "'"));
        if (i > 0)
        {
            return false;
        }
        else
        {
            return true;
        }
    }

    protected bool ValidateBranchCode(string BranchCode)
    {
        int i = Util.GetInt(StockReports.ExecuteScalar("select count(*) from Pay_BranchMaster where BranchCode='" + BranchCode + "' "));
        if (i > 0)
        {
            return false;
        }
        else
        {
            return true;
        }
    }

    protected bool ValidateBranchName(string BranchName, string BankName)
    {
        int i = Util.GetInt(StockReports.ExecuteScalar("select count(*) from Pay_BranchMaster where BranchName='" + BranchName + "' and BankName='" + BankName + "'"));
        if (i > 0)
        {
            return false;
        }
        else
        {
            return true;
        }
    }

    protected bool ValidateBranchNameUpdate(string BranchName, string BankName)
    {
        //if (BranchName == ViewState["BranchName"].ToString())
        //{
        //    return true;
        //}
        int i = Util.GetInt(StockReports.ExecuteScalar("select count(*) from Pay_BranchMaster where BranchName ='" + BranchName + "' and BankName='" + BankName + "'"));
        if (i > 0)
        {
            return false;
        }
        else
        {
            return true;
        }
    }

    private void BindData()
    {
        DataTable dt = StockReports.GetDataTable("select Bank_Id,Branch_ID,BankName,BankCode,BranchName,BranchCode,IsActive from Pay_BranchMaster ");
        if (dt.Rows.Count > 0)
        {
            lblmsg.Text = "";
            grdBank.DataSource = dt;
            grdBank.DataBind();
            //  lblmsg.Text = "Total " + dt.Rows.Count + " Records Founds";
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
            grdBank.DataSource = null;
            grdBank.DataBind();
        }
    }
}