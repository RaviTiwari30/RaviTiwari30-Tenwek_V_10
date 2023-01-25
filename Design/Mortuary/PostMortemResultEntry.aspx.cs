using System;
using System.Data;
using System.Data.Odbc;
using System.Configuration;
using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

public partial class Design_Mortuary_PostMortemResultEntry : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString.Count == 0 && Util.GetString(Request.QueryString["access"]) == "")
        {
            Response.Redirect(Request.RawUrl + "?access=" + Util.getHash());
        }
        else if (Request.QueryString.Count > 0 && Util.GetString(Request.QueryString["access"]) == "")
        {
            Response.Redirect(Request.RawUrl + "&access=" + Util.getHash());
        }

        lblMsg.Text = "";

        if (!IsPostBack)
        {
            ViewState["ID"] = Session["ID"].ToString();
            ViewState["CorpseID"] = Request.QueryString["CorpseID"].ToString();
            ViewState["TransactionID"] = Request.QueryString["TransactionID"].ToString();
            FillGrid();
        }

    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        SaveData();

    }
    protected void SaveData()
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.ReadCommitted);

        try
        {
            foreach (GridViewRow row in gvResultEnter.Rows)
            {
                int ID = Util.GetInt(((Label)row.FindControl("lblID")).Text);
                string Result = ((TextBox)row.FindControl("txtResultEntry")).Text;
                string sql = "Update mortuary_postmortem_test Set ResultEntry='" + Result + "',IsDone=1,UpdatedBy='" + ViewState["ID"].ToString() + "',UpdatedDate='" + Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd") + "' where ID=" + ID + "";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
            }
            tnx.Commit();
            lblMsg.Text = "Record Save Successfully..";
        }

        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            lblMsg.Text = "Error..";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
    protected void FillGrid()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ID,TestName,SubCategory,ResultEntry FROM mortuary_postmortem_test WHERE Transaction_ID='" + ViewState["TransactionID"].ToString() + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            gvResultEnter.DataSource = dt;
            gvResultEnter.DataBind();

        }
        else
        {
            gvResultEnter.DataSource = null;
            gvResultEnter.DataBind();
            lblMsg.Text = "No Post-Mortem Request..";
        }
    }
}