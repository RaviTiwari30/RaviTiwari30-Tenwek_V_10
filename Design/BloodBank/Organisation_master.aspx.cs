using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_BloodBank_Organisation_master : System.Web.UI.Page
{
    protected void btncancel_Click(object sender, EventArgs e)
    {
        btnSave.Visible = true; ;
        btnUpdate.Visible = false;
        btnCancel.Visible = false;
        Clear();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            Organisation_master om = new Organisation_master();
            om.Organisation = txtOrganisation.Text.Trim().ToUpper();
            om.Address = txtAddress.Text.Trim();
            om.City = txtCity.Text.Trim();
            om.State = ddlState.SelectedItem.Text;
            om.Pincode = txtPinCode.Text.Trim();
            om.PhoneNo = txtPinCode.Text.Trim();
            om.MobileNo = txtMobileNo.Text.Trim();
            om.FaxNo = txtFaxNo.Text.Trim();
            om.EmailID = txtEmail.Text.Trim();
            om.IsActive = Util.GetInt(rblActive.SelectedItem.Value);
            om.CreatedBy = Session["ID"].ToString();
            om.Insert();

            tranX.Commit();

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmsg.ClientID + "');", true);
            BindData();
            Clear();
        }
        catch (Exception ex)
        {
            if (ex.InnerException.InnerException.Message.Contains("Duplicate entry"))
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM219','" + lblmsg.ClientID + "');", true);
            }
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        try
        {
            if (txtOrganisation.Text != "")
            {
                string Query = "update bb_Organisation_master set Organisaction='" + txtOrganisation.Text.Trim() + "',Address='" + txtAddress.Text.Trim() + "',City='" + txtCity.Text.Trim() + "',state='" + ddlState.SelectedItem.Text + "' " +
                    ",PinCode='" + txtPinCode.Text.Trim() + "',PhoneNo='" + txtPhoneNo.Text.Trim() + "',MobileNo='" + txtMobileNo.Text.Trim() + "',FaxNo='" + txtFaxNo.Text.Trim() + "',EmailID='" + txtEmail.Text.Trim() + "',IsActive='" + rblActive.SelectedItem.Value + "'  where Id='" + ViewState["Id"].ToString() + "' ";
                StockReports.ExecuteDML(Query);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Organisation Updated Sucessfully...');", true);
                BindData();
                Clear();
                btnSave.Visible = true; ;
                btnUpdate.Visible = false; ;
                btnCancel.Visible = false;
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM219','" + lblmsg.ClientID + "');", true);
            }
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM07','" + lblmsg.ClientID + "');", true);
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void Clear()
    {
        txtOrganisation.Text = "";
        rblActive.SelectedIndex = 0;
        txtAddress.Text = "";
        txtCity.Text = "";
        ddlState.SelectedIndex = 0;
        txtEmail.Text = "";
        txtPhoneNo.Text = "";
        txtMobileNo.Text = "";
        txtPinCode.Text = "";
        txtFaxNo.Text = "";
    }

    protected void grdOrganisation_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        grdOrganisation.PageIndex = e.NewPageIndex;
        BindData();
    }

    protected void grdOrganisation_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            e.Row.ToolTip = "Organisaction: " + Convert.ToString(DataBinder.Eval(e.Row.DataItem, "Organisaction"));
            e.Row.Style.Add("Cursor", "Hand");

            e.Row.Attributes["onmouseover"] = "javascript:SetMouseOver(this)";
            e.Row.Attributes["onmouseout"] = "javascript:SetMouseOut(this)";
        }
    }

    protected void grdOrganisation_SelectedIndexChanged(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        btnSave.Visible = false;
        btnUpdate.Visible = true;
        btnCancel.Visible = true;
        string[] s = ((Label)grdOrganisation.SelectedRow.FindControl("lblrecord")).Text.Split('#');
        ViewState["Id"] = s[0].ToString();

        txtOrganisation.Text = s[1].ToString();
        txtAddress.Text = s[2].ToString();
        txtCity.Text = s[3].ToString();

        ddlState.SelectedIndex = ddlState.Items.IndexOf(ddlState.Items.FindByText(s[4].ToString()));

        txtPinCode.Text = s[5].ToString();
        txtPhoneNo.Text = s[6].ToString();
        txtMobileNo.Text = s[7].ToString();
        txtFaxNo.Text = s[8].ToString();
        txtEmail.Text = s[9].ToString();

        if (s[10].ToString() == "YES")
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
            txtOrganisation.Focus();
            btnSave.Visible = true; ;
            btnUpdate.Visible = false; ;
            btnCancel.Visible = false;
            BindData();
            BloodBank.bindState(ddlState);
            ddlState.Items.Insert(0, new ListItem("Select", "0"));
        }
        btnUpdate.Attributes.Add("OnClick", "return up()");
    }

    protected bool ValidateOrganisation(string Organisation)
    {
        int i = Util.GetInt(StockReports.ExecuteScalar("select count(*) from bb_Organisation_master where Organisation='" + Organisation + "'"));
        if (i > 0)
            return false;
        else
            return true;
    }

    private void BindData()
    {
        DataTable dt = StockReports.GetDataTable("select Id,Organisaction,Address,City,State,PinCode,PhoneNo,MobileNo,FaxNo,EmailID,if(IsActive=1,'YES','NO')IsActive from bb_Organisation_master ");
        if (dt.Rows.Count > 0)
        {
            grdOrganisation.DataSource = dt;
            grdOrganisation.DataBind();
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
            grdOrganisation.DataSource = null;
            grdOrganisation.DataBind();
        }
    }
}