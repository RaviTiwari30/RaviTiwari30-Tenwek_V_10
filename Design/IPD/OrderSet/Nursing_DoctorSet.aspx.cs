using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using MySql.Data.MySqlClient;
using System.Text;
public partial class Design_IPD_OrderSet_Nursing_DoctorSet : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["ID"] != null)
            {
                string OrderSetID = Request.QueryString["ID"].ToString();
                ViewState["ID"] = OrderSetID;
                string TID = Request.QueryString["TID"].ToString();
                ViewState["TransID"] = TID;
                string Groupid = Request.QueryString["GroupID"].ToString();
                ViewState["GroupID"] = Groupid;
                ViewState["Relational_ID"] = Request.QueryString["RelationalID"].ToString();
                BindDoctorDetail();
            }
            All_LoadData.bindDoctor(ddlDoctor);
        }
    }
    private void BindDoctorDetail()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select DoctorID,DoctorName Doctor from nursing_ordersetDoctor where TransactionID='" + ViewState["TransID"].ToString() + "' and GroupID=" + ViewState["GroupID"].ToString() + " and RelationalID=" + ViewState["Relational_ID"] + "");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            grdDoctor.DataSource = dt;
            grdDoctor.DataBind();
            ViewState.Add("dtDoctor", dt);
            pnlHide.Visible = true;
        }
        else
        {
            grdDoctor.DataSource = null;
            grdDoctor.DataBind();
            ViewState.Add("dtDoctor", dt);
            pnlHide.Visible = false;
        }
    }
    protected void btnAdd_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (ddlDoctor.SelectedIndex != 0)
        {
            pnlHide.Visible = true;
            lblMsg.Text = "";
            DataTable dtDoctor = new DataTable();
            if (ViewState["dtDoctor"] != null)
                dtDoctor = (DataTable)ViewState["dtDoctor"];
            else
                dtDoctor = GetDoctor();
            for (int i = 0; i < dtDoctor.Rows.Count; i++)
            {
                if (dtDoctor.Rows[i]["DoctorID"].ToString() == ddlDoctor.SelectedItem.Value)
                {
                    lblMsg.Text = "Doctor Already Added";
                    return;
                }
            }

            DataRow dr = dtDoctor.NewRow();
            dr["Doctor"] = ddlDoctor.SelectedItem.Text;
            dr["DoctorID"] = ddlDoctor.SelectedItem.Value;

            dtDoctor.Rows.Add(dr);
            ViewState.Add("dtDoctor", dtDoctor);
            grdDoctor.DataSource = dtDoctor;
            grdDoctor.DataBind();
        }
        else
        {
            lblMsg.Text = "Please Select Doctor";
            return;
        }
    }
    private DataTable GetDoctor()
    {
        if (ViewState["dtDoctor"] != null)
        {
            return (DataTable)ViewState["dtDoctor"];
        }
        else
        {
            DataTable dtDoctor = new DataTable();
            dtDoctor = new DataTable();
            dtDoctor.Columns.Add("DoctorID");
            dtDoctor.Columns.Add("Doctor");
            return dtDoctor;
        }
    }
    protected void grdDoctor_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "imbRemove")
        {
            lblMsg.Text = "";
            int args = Util.GetInt(e.CommandArgument);
            DataTable dtItem = (DataTable)ViewState["dtDoctor"];
            dtItem.Rows[args].Delete();
            dtItem.AcceptChanges();
            grdDoctor.DataSource = dtItem;
            grdDoctor.DataBind();

            ViewState["dtDoctor"] = dtItem;
        }
       

    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        string TransactionId = Convert.ToString(Request.QueryString["TID"]);
        if (SaveData() != string.Empty)
        {
            grdDoctor.DataSource = null;

            grdDoctor.DataBind();
            ViewState.Remove("dtDoctor");
            BindDoctorDetail();
        }

        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);

        }
    }
    private string SaveData()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        if (ViewState["dtDoctor"] != null)
        {
            try
            {

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM nursing_ordersetDoctor WHERE TransactionID ='" + ViewState["TransID"].ToString() + "'and GroupID='" + ViewState["GroupID"].ToString() + "' and RelationalID=" + ViewState["Relational_ID"].ToString() + "");
                DataTable dt1 = ViewState["dtDoctor"] as DataTable;
                for (int i = 0; i < dt1.Rows.Count; i++)
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO nursing_ordersetDoctor (TransactionID,GroupID,Doctorid,Doctorname,OrderSetID,RelationalID) VALUES('" + ViewState["TransID"].ToString() + "','" + ViewState["GroupID"].ToString() + "','" + dt1.Rows[i]["Doctorid"] + "','" + dt1.Rows[i]["Doctor"] + "','" + ViewState["ID"].ToString() + "'," + ViewState["Relational_ID"].ToString() + ")");
                }
                tnx.Commit();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
                return "1";
            }
            catch (Exception ex)
            {
                tnx.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return string.Empty;
            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        else
        {
            try
            {
                int numberOfRecords = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "delete from nursing_ordersetDoctor where TransactionID = '" + ViewState["TransID"] + "' and GroupID = '" + ViewState["GroupID"] + "' and RelationalID=" + ViewState["Relational_ID"].ToString() + "");
                tnx.Commit();

                if (numberOfRecords > 1)
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM03','" + lblMsg.ClientID + "');", true);
                else
                    lblMsg.Text = "Please Select Doctor";
                return "2";
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
                tnx.Rollback();

                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return string.Empty;
            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }
        }


    }
}