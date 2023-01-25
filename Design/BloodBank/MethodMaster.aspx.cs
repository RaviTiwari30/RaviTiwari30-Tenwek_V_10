using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_BloodBank_MethodMaster : System.Web.UI.Page
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
            Method_Master mm = new Method_Master(tranX);
            mm.Method = txtMethod.Text;
            mm.IsActive = Util.GetInt(rblActive.SelectedItem.Value);
            mm.CreatedBy = Session["ID"].ToString();
            mm.Insert();

            tranX.Commit();
           
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmsg.ClientID + "');", true);
            BindData();
            Clear();
        }
        catch (Exception ex)
        {
            if (ex.InnerException.InnerException.Message.Contains("Duplicate entry"))
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM218','" + lblmsg.ClientID + "');", true);
            }
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM07','" + lblmsg.ClientID + "');", true);
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
            if (txtMethod.Text != "")
            {
                string Query = "update bb_Method_master set Method='" + txtMethod.Text.Trim() + "' ,IsActive='" + rblActive.SelectedItem.Value + "'  where Id='" + ViewState["Id"].ToString() + "' ";
                StockReports.ExecuteDML(Query);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM02','" + lblmsg.ClientID + "');", true);
                BindData();
                Clear();
                btnSave.Visible = true; ;
                btnUpdate.Visible = false; ;
                btnCancel.Visible = false;
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM218','" + lblmsg.ClientID + "');", true);
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM07','" + lblmsg.ClientID + "');", true);
        }
    }

    protected void Clear()
    {
        txtMethod.Text = "";
        rblActive.SelectedIndex = 0;
    }

    protected void grdMethod_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        grdMethod.PageIndex = e.NewPageIndex;
        BindData();
    }

    protected void grdMethod_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            e.Row.ToolTip = "Method: " + Convert.ToString(DataBinder.Eval(e.Row.DataItem, "Method"));
            e.Row.Style.Add("Cursor", "Hand");

            e.Row.Attributes["onmouseover"] = "javascript:SetMouseOver(this)";
            e.Row.Attributes["onmouseout"] = "javascript:SetMouseOut(this)";
        }
    }

    protected void grdMethod_SelectedIndexChanged(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        btnSave.Visible = false;
        btnUpdate.Visible = true;
        btnCancel.Visible = true;
        string[] s = ((Label)grdMethod.SelectedRow.FindControl("lblrecord")).Text.Split('#');
        ViewState["Id"] = s[0].ToString();

        txtMethod.Text = s[1].ToString();

        if (Util.GetInt(s[2].ToString()) == 1)
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
            txtMethod.Focus();
            btnSave.Visible = true; ;
            btnUpdate.Visible = false; ;
            btnCancel.Visible = false;
            BindData();
        }
    }

    protected bool ValidateMethod(string Method)
    {
        int i = Util.GetInt(StockReports.ExecuteScalar("select count(*) from bb_Method_master where Method='" + Method + "'"));
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
        DataTable dt = StockReports.GetDataTable("select Id,Method,IsActive from bb_Method_master ");
        if (dt.Rows.Count > 0)
        {
            grdMethod.DataSource = dt;
            grdMethod.DataBind();
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
            grdMethod.DataSource = null;
            grdMethod.DataBind();
        }
    }
}