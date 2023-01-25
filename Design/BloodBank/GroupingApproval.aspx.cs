using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_Bloodbank_GroupingApproval : System.Web.UI.Page
{
    public int data;

    public void patientapprove()
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            
            string CollectionID = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT BloodCollection_ID FROM bb_Grouping WHERE Grouping_Id='" + lblhidden.Text + "' "));
            string BloodInvestigationId = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT Bloodcollection_Id FROM bb_collection_details WHERE BloodCollection_ID = '" + CollectionID + "' "));
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE bb_visitors_history Set IsGrouped =3 where BloodCollection_ID='" + BloodInvestigationId + "'");
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE bb_Grouping SET IsApproved=3 ,ApprovedBy='" + Session["ID"].ToString() + "',status= 1  WHERE Grouping_Id='" + lblhidden.Text + "' ");
            Tranx.Commit();
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return;
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnRemark_Click(object sender, EventArgs e)
    {
        if (lblHdn2.Text == "2")
        {
            StringBuilder sb = new StringBuilder();
            string gp = "Update bb_Grouping Set ApprovedBy='" + Session["ID"].ToString() + "', Remark='" + txtRemark.Text + "' where Grouping_Id='" + lblhidden.Text + "'";
            StockReports.ExecuteDML(gp.ToString());
            Bind();
            txtRemark.Text = string.Empty;
            lblRemark.Visible = false;
            txtRemark.Visible = false;
            btnRemark.Visible = false;
            btnCancel.Visible = false;
            grdBloodMatch.Enabled = true;
            search();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "DisplayMsg('MM233','" + lblMsg.ClientID + "');", true);
        }
        else if (lblHdn2.Text == "1")
        {
            patientapprove();
            txtRemark.Text = string.Empty;
            lblRemark.Visible = false;
            txtRemark.Visible = false;
            btnRemark.Visible = false;
            btnCancel.Visible = false;
            grdBloodMatch.Enabled = true;
            search();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "DisplayMsg('MM232','" + lblMsg.ClientID + "');", true);
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        
        search();
    }

    protected void grdBloodMatch_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "AApprove")
        {
            lblRemark.Visible = true;
            txtRemark.Visible = true;
            btnRemark.Visible = true;
            btnCancel.Visible = true;
            grdBloodMatch.Enabled = false;
            string index1 = Util.GetString((e.CommandArgument));
            lblhidden.Text = index1.ToString();
            data = 1;
            lblHdn2.Text = data.ToString();
        }
        if (e.CommandName == "AReject")
        {
            lblRemark.Visible = true;
            txtRemark.Visible = true;
            btnRemark.Visible = true;
            btnCancel.Visible = true;
            grdBloodMatch.Enabled = false;
            string index1 = Util.GetString((e.CommandArgument));
            lblhidden.Text = index1.ToString();
            data = 2;
            lblHdn2.Text = data.ToString();
        }
        txtRemark.Focus();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        grdBloodMatch.Enabled = true;

        lblRemark.Visible = false;
        txtRemark.Visible = false;
        btnRemark.Visible = false;
        btnCancel.Visible = false;
        grdBloodMatch.Enabled = true;
        if (!IsPostBack)
        {
            BloodBank.bindBloodGroup(ddlBloodgroup);
            ddlBloodgroup.Items.Insert(0, new ListItem("Select", "0"));
            txtcollectedfrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtcollectedTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtDonationId.Text = string.Empty;
            txtDonationId.Focus();
            btnSearch.Attributes.Add("onclick", String.Format("this.value='Please Wait...';this.disabled = true; {0};", this.ClientScript.GetPostBackEventReference(btnSearch, String.Empty)));
            ViewState["CenterID"] = Util.GetString(Session["CentreID"].ToString());
        }
        txtcollectedfrom.Attributes.Add("readOnly", "true");
        txtcollectedTo.Attributes.Add("readOnly", "true");
    }

    private void Bind()
    {
        //Cases:: 1:Pending,2:Retest,3:Approved,4:Reject(Not used)
        //Status:: 1:Same as screened BG,0: Not Same Go For Approval
        ////Approval Cases:: 1:Pending, 2:Reject, 3:Approve, 4:Retest

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tran = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string CollectionID = Util.GetString(MySqlHelper.ExecuteScalar(Tran, CommandType.Text, "SELECT BloodCollection_ID FROM bb_Grouping WHERE Grouping_Id='" + lblhidden.Text + "' "));
            string BloodInvestigationId = Util.GetString(MySqlHelper.ExecuteScalar(Tran, CommandType.Text, "SELECT Bloodcollection_Id FROM bb_collection_details WHERE BloodCollection_ID = '" + CollectionID + "' "));
            MySqlHelper.ExecuteNonQuery(Tran, CommandType.Text, "UPDATE bb_visitors_history Set IsGrouped =0 and IsScreened=1 where BloodCollection_ID='" + BloodInvestigationId + "'");
            MySqlHelper.ExecuteNonQuery(Tran, CommandType.Text, "UPDATE bb_Grouping SET IsApproved=2 ,ApprovedBy='" + Session["ID"].ToString() + "',status= 0  WHERE Grouping_Id='" + lblhidden.Text + "' ");

            BloodGrouping_History bgh = new BloodGrouping_History(Tran);
            bgh.BloodCollection_Id = CollectionID;
            bgh.Grouping_Id = lblhidden.Text;
            bgh.CentreID = Util.GetInt(Session["Centre"].ToString());
            bgh.RejectedBy = Session["ID"].ToString();
            bgh.Remarks = txtRemark.Text;
            bgh.IsApproved = 2;

            string RejectedgroupingID = bgh.Insert();

            Tran.Commit();
           
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            Tran.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return;
        }
        finally
        {
            Tran.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    private void search()
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT bv.Visitor_ID,cd.Bloodcollection_id,bv.Name,bm.BloodGroup,bv.dtBirth,bv.Gender,DATE_FORMAT(cd.CollectedDate,'%d-%b-%Y')CollectedDate,GP.Grouping_Id, ");
            sb.Append("GP.ScreenedBG,CASE WHEN (gp.AntiA=1) THEN 'N' ELSE 'P' END AS AntiA,CASE WHEN (gp.AntiB=1) THEN 'N' ELSE 'P' END AS AntiB,   ");
            sb.Append("  CASE WHEN (gp.AntiAB=1) THEN 'N' ELSE 'P' END AntiAB,CASE WHEN (gp.RH=1) THEN 'N' ELSE 'P' END AS RH, ");
            sb.Append("  gp.BloodTested,CASE WHEN (gp.IsSame=0) THEN 'No' ELSE 'Yes' END AS IsSame,");
            sb.Append("   DATE_FORMAT(GP.createdDate,'%d-%b-%Y')DATE FROM bb_visitors_history vh INNER JOIN bb_visitors bv ON vh.Visitor_ID=bv.Visitor_ID");
            sb.Append("     INNER JOIN bb_collection_details cd ON cd.Visitor_Id=bv.Visitor_ID  AND cd.visit_id=vh.visit_id ");
            sb.Append("  INNER JOIN bb_grouping gp ON gp.BloodCollection_Id =cd.BloodCollection_Id        INNER JOIN bb_bloodgroup_master bm ON bm.Id=bv.BloodGroup_ID ");
            sb.Append("   WHERE (vh.IsGrouped=1 AND GP.IsApproved=1 AND GP.IsSame=0) AND bv.CentreID=" + Util.GetInt(ViewState["CenterID"]) + " ");
            if (txtDonationId.Text.Trim() != "")
            {
                sb.Append("AND cd.BloodCollection_Id ='" + txtDonationId.Text + "'");
            }
            if (txtName.Text != "")
            {
                sb.Append(" AND bv.Name like '%" + txtName.Text + "%'");
            }
            if (ddlBloodgroup.SelectedIndex != 0)
            {
                sb.Append(" AND bm.BloodGroup='" + ddlBloodgroup.SelectedItem.Text + "'");
            }
            if (txtDonorId.Text.Trim() != "")
            {
                sb.Append(" AND bv.Visitor_ID ='" + txtDonorId.Text + "'");
            }
            if (txtDonationId.Text == "" && txtName.Text == "" && txtDonorId.Text == "" && ddlBloodgroup.SelectedIndex == 0)
            {
                if (txtcollectedfrom.Text != "")
                {
                    sb.Append(" AND DATE(cd.CollectedDate) >='" + Util.GetDateTime(txtcollectedfrom.Text).ToString("yyyy-MM-dd") + "'");
                }
                if (txtcollectedTo.Text != "")
                {
                    sb.Append(" and DATE(cd.CollectedDate) <='" + Util.GetDateTime(txtcollectedTo.Text).ToString("yyyy-MM-dd") + "'");
                }
            }
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                //lblMsg.Text = "Total " + dt.Rows.Count + "Record Found";
                grdBloodMatch.DataSource = dt;
                grdBloodMatch.DataBind();
                pnlHide.Visible = true;
            }
            else
            {
                grdBloodMatch.DataSource = dt;
                grdBloodMatch.DataBind();

                pnlHide.Visible = false;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            }
        }
        catch (Exception ex)
        {
            ClassLog ca = new ClassLog();
            ca.errLog(ex);
            grdBloodMatch.DataSource = null;
            grdBloodMatch.DataBind();
            pnlHide.Visible = false;
        }
    }
}