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

public partial class Design_Mortuary_PostMortemRequest : System.Web.UI.Page
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
            ViewState["CentreID"] = Session["CentreID"].ToString();
            //ViewState["HospCentreID"] = Session["HospCentreID"].ToString();

            AllQuery AQ = new AllQuery();
            DataTable dtDischarge = AQ.GetCorpseReleasedStatus(ViewState["TransactionID"].ToString());
            if (dtDischarge != null && dtDischarge.Rows.Count > 0)
            {
                if (dtDischarge.Rows[0]["IsReleased"].ToString() == "1")
                {
                    string Msg = "Corpse is Already Released on " + dtDischarge.Rows[0]["ReleasedDateTime"].ToString() + " . No Post-mortem can be possible...";
                    Response.Redirect("../Mortuary/CorpseBillMsg.aspx?msg=" + Msg);
                }
            }

            txtPostDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            calPostDate.StartDate = DateTime.Now;
            GetOldRecord();
        }
        txtPostDate.Attributes.Add("readonly", "readonly");

    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if ((txtName.Text.Trim() == string.Empty) || (txtName.Text.Trim() == ".") || (txtName.Text.Trim() == ".") || (txtName.Text.Trim() == ",") || (txtName.Text.Trim() == "_"))
        {
            lblMsg.Text = "Please Enter Doctor Name..";
            return;
        }
        if ((txtLocation.Text.Trim() == string.Empty) || (txtLocation.Text.Trim() == ".") || (txtLocation.Text.Trim() == ".") || (txtLocation.Text.Trim() == ",") || (txtLocation.Text.Trim() == "_"))
        {
            lblMsg.Text = "Please Enter Location..";
            return;
        }
        if ((txtPostDate.Text.Trim() == string.Empty) || (txtPostDate.Text.Trim() == ".") || (txtPostDate.Text.Trim() == ".") || (txtPostDate.Text.Trim() == ",") || (txtPostDate.Text.Trim() == "_"))
        {
            lblMsg.Text = "Please Enter Date..";
            return;
        }
        DateTime PostDateTime = Util.GetDateTime(Util.GetDateTime(txtPostDate.Text).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(((TextBox)txtPostTime.FindControl("txtTime")).Text).ToString("hh:mm:ss tt"));
        DateTime CurrDateTime = System.DateTime.Now;
        if (CurrDateTime > PostDateTime)
        {
            lblMsg.Text = "Post-Mortem Date Time should be greater than Current Date Time..";
            return;
        }
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
            string sql = "INSERT INTO mortuary_postmortem(CorpseID,TransactionID,PostmortemDate,PostmortemTime,DoctorName,Location,CreatedBy,IsApproved,CentreID) values('" + ViewState["CorpseID"].ToString() + "','" + ViewState["TransactionID"].ToString() + "','" + Util.GetDateTime(txtPostDate.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(((TextBox)txtPostTime.FindControl("txtTime")).Text).ToString("HH:mm:ss") + "','" + txtName.Text + "','" + txtLocation.Text + "','" + ViewState["ID"].ToString() + "','1'," + ViewState["CentreID"] + ")";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
            tnx.Commit();
            lblMsg.Text = "Record Saved Successfully..";
            btnSave.Visible = false;
            btnUpdate.Visible = true;
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            lblMsg.Text = "Error occurred, Please contact administrator..";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    protected void GetOldRecord()
    {
        //  string Test = "";
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT TransactionID,CorpseID,DoctorName,Location,DATE_FORMAT(PostmortemDate,'%d-%b-%Y')PostmortemDate,TIME_FORMAT(PostmortemTime,'%I:%m %p')PostmortemTime,IsSend ");
        sb.Append(" FROM mortuary_postmortem WHERE TransactionID='" + ViewState["TransactionID"].ToString() + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            btnSave.Visible = false;
            if (dt.Rows[0]["IsSend"].ToString() == "0")
                btnUpdate.Visible = true;
            else
                btnUpdate.Visible = false;
            txtName.Text = dt.Rows[0]["DoctorName"].ToString();
            txtLocation.Text = dt.Rows[0]["Location"].ToString();
            txtPostDate.Text = dt.Rows[0]["PostmortemDate"].ToString();
            ((TextBox)txtPostTime.FindControl("txtTime")).Text = dt.Rows[0]["PostmortemTime"].ToString();

        }
        else
        {
            btnSave.Visible = true;
            btnUpdate.Visible = false;
            txtName.Text = "";
            txtLocation.Text = "";
            txtPostDate.Text = "";
        }

    }
    protected void btnUpdate_Click(object sender, System.EventArgs e)
    {
        if ((txtName.Text.Trim() == string.Empty) || (txtName.Text.Trim() == ".") || (txtName.Text.Trim() == ".") || (txtName.Text.Trim() == ",") || (txtName.Text.Trim() == "_"))
        {
            lblMsg.Text = "Please Enter Doctor Name..";
            return;
        }
        if ((txtLocation.Text.Trim() == string.Empty) || (txtLocation.Text.Trim() == ".") || (txtLocation.Text.Trim() == ".") || (txtLocation.Text.Trim() == ",") || (txtLocation.Text.Trim() == "_"))
        {
            lblMsg.Text = "Please Enter Location..";
            return;
        }
        if ((txtPostDate.Text.Trim() == string.Empty) || (txtPostDate.Text.Trim() == ".") || (txtPostDate.Text.Trim() == ".") || (txtPostDate.Text.Trim() == ",") || (txtPostDate.Text.Trim() == "_"))
        {
            lblMsg.Text = "Please Enter Date..";
            return;
        }
        DateTime PostDateTime = Util.GetDateTime(Util.GetDateTime(txtPostDate.Text).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(((TextBox)txtPostTime.FindControl("txtTime")).Text).ToString("hh:mm:ss tt"));
        DateTime CurrDateTime = System.DateTime.Now;
        if (CurrDateTime > PostDateTime)
        {
            lblMsg.Text = "Post-Mortem Date Time should be greater than Current Date Time..";
            return;
        }
        UpdateData();
    }
    protected void UpdateData()
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.ReadCommitted);

        try
        {
            string sql = "UPDATE mortuary_postmortem SET PostmortemDate='" + Util.GetDateTime(txtPostDate.Text).ToString("yyyy-MM-dd") + "',PostmortemTime='" + Util.GetDateTime(((TextBox)txtPostTime.FindControl("txtTime")).Text).ToString("HH:mm:ss") + "',DoctorName='" + txtName.Text + "',Location='" + txtLocation.Text + "',UpdatedBy='" + ViewState["ID"].ToString() + "',UpdatedDate='" + Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd") + "' Where TransactionID='" + ViewState["TransactionID"].ToString() + "'";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
            tnx.Commit();
            lblMsg.Text = "Record Updated Successfully..";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            lblMsg.Text = "Error occurred, Please contact administrator..";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }    
}

