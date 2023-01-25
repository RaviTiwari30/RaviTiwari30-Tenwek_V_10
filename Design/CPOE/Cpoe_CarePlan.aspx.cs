using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_CPOE_Cpoe_CarePlan : System.Web.UI.Page
{
    protected void BindData(string TnxID)
    {
        try
        {
            DataTable dtdetail = StockReports.GetDataTable("SELECT ID,CarePlan,EntryBy,DATE_FORMAT(EntryDate,'%d-%b-%y %l:%i %p')Date,(Select CONCAT(Title,'',Name)Name from employee_master where employeeID=Entryby)Name FROM Cpoe_careplan WHERE PatientID='" + ViewState["PID"].ToString() + "' order by ID Desc");
            if (dtdetail.Rows.Count > 0)
            {
                grid.DataSource = dtdetail;
                grid.DataBind();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (btnSave.Text == "Update")
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE Cpoe_careplan SET CarePlan='" + txtFamilyHistory.Text.Replace("'", "@") + "',EntryBy='" + ViewState["UserID"].ToString() + "',EntryDate='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "' WHERE TransactionID='" + ViewState["TID"].ToString() + "' AND ID='" + lblID.Text + "'");
                lblMsg.Text = "Record Update Successfully";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
                btnCancel_Click(sender, e);
            }
            else
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO Cpoe_careplan(TransactionID,PatientID,CarePlan,EntryBy,EntryDate)VALUE('" + ViewState["TID"].ToString() + "','" + ViewState["PID"].ToString() + "','" + txtFamilyHistory.Text.Replace("'", "@") + "','" + ViewState["UserID"].ToString() + "','" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "')");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
            }
            tnx.Commit();
            BindData(ViewState["TID"].ToString());
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!IsPostBack)
            {
                txtFamilyHistory.Focus();
                ViewState["UserID"] = Session["ID"].ToString();
                if (Request.QueryString["TransactionID"] == null)
                {
                    ViewState["TID"] = Request.QueryString["TID"].ToString();
                    ViewState["PID"] = Request.QueryString["PID"].ToString();
                }
                else
                {
                    ViewState["TID"] = Request.QueryString["TransactionID"].ToString();
                    ViewState["PID"] = Request.QueryString["PatientID"].ToString();
                }
                BindData(ViewState["TID"].ToString());
                if (Request.QueryString["IsViewable"] == null)
                {
                    //bool IsDone = Util.GetBoolean(Request.QueryString["IsEdit"]);
                    string IsDone = StockReports.ExecuteScalar(" select flag from Appointment where App_ID='" + Util.GetInt(Request.QueryString["App_ID"]) + "' ");
                    string msg = "File Has Been Closed...";
                    if (IsDone == "1")
                    {
                        Response.Redirect("NotAuthorized.aspx?msg=" + msg);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void grid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            if (e.CommandName == "Change")
            {
                lblMsg.Text = "";

                int id = Convert.ToInt16(e.CommandArgument.ToString());
                if (((Label)grid.Rows[id].FindControl("lblUserID")).Text == Session["ID"].ToString())
                {
                    lblID.Text = ((Label)grid.Rows[id].FindControl("lblID")).Text;
                    txtFamilyHistory.Text = ((Label)grid.Rows[id].FindControl("lblpro")).Text;
                    btnSave.Text = "Update";
                    btnCancel.Visible = true;
                }
                else
                {
                   // ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "Alert!!! You are not Authorized to Change Other Doctor's Progress Note", true);
                    lblMsg.Text = "Alert!!! You are not Authorized to Change Other Doctor's Progress Note";
                }
            }
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        txtFamilyHistory.Text = "";
        btnSave.Text = "Save";
        btnCancel.Visible = false;
        lblID.Text = "";
    }

    protected void grid_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        try
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                ((Label)e.Row.FindControl("lblpro")).Text = ((Label)e.Row.FindControl("lblpro")).Text.Replace("@", "'");
            }
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
}