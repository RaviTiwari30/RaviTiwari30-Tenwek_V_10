using System;
using System.Data;
using System.Drawing;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_BloodBank_TTDApproval : System.Web.UI.Page
{
    private MySqlConnection con;

    protected void btnFinalReject_Click(object sender, EventArgs e)
    {
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tran = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb1 = new StringBuilder();

            ////Approval Cases:: 1:Pending, 2:Reject, 3:Approve, 4:Retest

            string up = "UPDATE bb_blood_screening SET IsApproved=2, RejectedBy='" + Session["ID"].ToString() + "',RejectedDate=NOW() where BloodCollection_Id='" + lblDonationId.Text + "'";
            MySqlHelper.ExecuteNonQuery(Tran, CommandType.Text, up);
            string up1 = "UPDATE bb_visitors_history SET IsScreened=2 WHERE BloodCollection_Id = '" + lblDonationId.Text + "'";
            MySqlHelper.ExecuteNonQuery(Tran, CommandType.Text, up1);
            BloodScreening_History bsh = new BloodScreening_History(Tran);
            bsh.Screening_Id = lblScreeningId.Text;
            bsh.BloodCollection_Id = lblDonationId.Text;
            bsh.RejectrdBy = Session["ID"].ToString();
            bsh.CentreID = Util.GetInt(Session["Centre"].ToString());
            bsh.IsApproved = 2;
            bsh.Remarks = txtReason.Text;
            string RejectScreeningId = bsh.Insert();
            Tran.Commit();
           
            pnlComponent.Visible = false;
            search();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "DisplayMsg('MM233','" + lblMsg.ClientID + "');", true);
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            Tran.Rollback();
           
        }
        finally
        {
            Tran.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnReject_Click(object sender, EventArgs e)
    {
        mpeCreateGroup.Show();
    }

    protected void btnRepeate_Click(object sender, EventArgs e)
    {
        string BloodInvestigationID = "";
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            BloodInvestigationID = lblDonationId.Text;

            int count = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT MAX(ResultStep) FROM bb_blood_screening  WHERE BloodCollection_Id='" + BloodInvestigationID + "'"));
            if (count < 2)
            {
                for (int i = 0; i < grvListForm.Rows.Count; i++)
                {
                    String ResultID = "";
                    if (count == 0)
                        ResultID = ((Label)grvListForm.Rows[i].FindControl("lblResultID")).Text;
                    if (count == 1)
                        ResultID = ((Label)grvListForm.Rows[i].FindControl("lblResultID1")).Text;
                    if (count == 2)
                        ResultID = ((Label)grvListForm.Rows[i].FindControl("lblResult2")).Text;

                    if (ResultID == "3" || ResultID == "5")
                    {
                        BloodInvestigationID = ((Label)grvListForm.Rows[i].FindControl("lblBloodCollection_ID")).Text;

                        string ID = ((Label)grvListForm.Rows[i].FindControl("lblGrdScreeningId")).Text;

                        string up1 = "UPDATE bb_blood_screening SET ISApproved=4,RejectedBy='" + Session["ID"].ToString() + "',RejectedDate=NOW() WHERE BloodCollection_Id='" + BloodInvestigationID + "' and ID='" + ID + "' ";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, up1);
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE bb_visitors_history SET isScreened=4 WHERE BloodCollection_Id = '" + BloodInvestigationID + "' ");
                    }
                    else
                    {
                        BloodInvestigationID = ((Label)grvListForm.Rows[i].FindControl("lblBloodCollection_ID")).Text;

                        string ID = ((Label)grvListForm.Rows[i].FindControl("lblGrdScreeningId")).Text;
                        string up1 = "UPDATE bb_blood_screening SET ISApproved=3,ApprovedBy='" + Session["ID"].ToString() + "',ApprovedDate=NOW() WHERE BloodCollection_Id='" + BloodInvestigationID + "' and ID='" + ID + "' ";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, up1);
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE bb_visitors_history SET isScreened=4 WHERE BloodCollection_Id = '" + BloodInvestigationID + "' ");
                    }
                }

                Tranx.Commit();
                Tranx.Dispose();
                con.Close();
                pnlComponent.Visible = false;
                search();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM230','" + lblMsg.ClientID + "');", true);
                //Response.Write("<Script Language=JavaScript>alert('TTDApproval Repeated Successfully!!! ')</Script>");
            }
            else
            {
                string up = "UPDATE bb_blood_screening SET IsApproved=2, RejectedBy='" + Session["ID"].ToString() + "',RejectedDate=NOW() where BloodCollection_Id='" + lblDonationId.Text + "'";
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, up);
                string up1 = "UPDATE bb_visitors_history SET IsScreened=2 WHERE BloodCollection_Id = '" + lblDonationId.Text + "'";
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, up1);
                BloodScreening_History bsh = new BloodScreening_History(Tranx);
                bsh.Screening_Id = lblScreeningId.Text;
                bsh.BloodCollection_Id = lblDonationId.Text;
                bsh.RejectrdBy = Session["ID"].ToString();
                bsh.CentreID = Util.GetInt(Session["Centre"].ToString());
                bsh.IsApproved = 2;
                bsh.Remarks = txtReason.Text;
                string RejectScreeningId = bsh.Insert();
                Tranx.Commit();
               
                pnlComponent.Visible = false;
                search();
            }
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            Tranx.Rollback();       
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
        }

        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        string BloodInvestigationID = "";
      
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

       
            for (int i = 0; i < grvListForm.Rows.Count; i++)
            {
                BloodInvestigationID = ((Label)grvListForm.Rows[i].FindControl("lblBloodCollection_ID")).Text;

                string ID = ((Label)grvListForm.Rows[i].FindControl("lblGrdScreeningId")).Text;
                string up1 = "UPDATE bb_blood_screening SET ISApproved=3,ApprovedBy='" + Session["ID"].ToString() + "',ApprovedDate=NOW() WHERE BloodCollection_Id='" + BloodInvestigationID + "' and ID='" + ID + "' ";
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, up1);

               
            }
            string i2 = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT COUNT(*) FROM bb_bloodtests_master WHERE IsActive=1 "));
            string i1 = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT COUNT(*) FROM bb_blood_screening WHERE IsApproved=3 and BloodCollection_Id='" + lblDonationId.Text + "' and IsActive=1 "));
            if (i2 == i1)
            {
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE bb_visitors_history SET isScreened=3 WHERE BloodCollection_Id = '" + BloodInvestigationID + "' ");
            }
            else
            {
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE bb_visitors_history SET isScreened=4 WHERE BloodCollection_Id = '" + BloodInvestigationID + "' ");
            }

            Tranx.Commit();
           // Status = "Yes";
            pnlComponent.Visible = false;

            search();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key123", "DisplayMsg('MM229','" + lblMsg.ClientID + "');", true);
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            Tranx.Rollback();
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            return;
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        search();
        dvHistory.Visible = false;
        pnlComponent.Visible = false;
    }

    protected void grdDonor_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "AResult")
        {
            for (int i = 0; i < grdDonor.Rows.Count; i++)
            {
                GridViewRow row1 = grdDonor.Rows[i];
                row1.BackColor = Color.Transparent;
            }
            btnSave.Visible = true;
            btnRepeate.Visible = false;
            int index = Convert.ToInt32(e.CommandArgument);
            GridViewRow row = grdDonor.Rows[index];
            row.BackColor = Color.Gray;
            lblDonationId.Text = ((Label)grdDonor.Rows[index].FindControl("lblDonationID")).Text;
            lblScreeningId.Text = ((Label)grdDonor.Rows[index].FindControl("lblScreeningId")).Text;

            pnlComponent.Visible = true;
            dvHistory.Visible = false;
            pnlHide1.Visible = false;
            BindGrid();

           
        }
        if (e.CommandName == "AHistory")
        {
            string DonationId = Util.GetString(e.CommandArgument);
            lblDonationId.Text = DonationId;

            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT DATE_FORMAT(bc.CreatedDate,'%d-%b-%y')DATE,DATE_FORMAT(bc.CreatedDate,'%h:%m:%s')TIME,Replace(bc.Screening_Id,'SCR','')Screening_Id,bm.TestName,bc.Value, ");
            sb.Append(" bc.Method,bc.Result,bc.Result_Approval FROM bb_blood_screening bc INNER JOIN bb_BloodTests_master bm ON ");
            sb.Append(" bc.TestName=bm.Id WHERE BloodCollection_Id='" + DonationId + "' ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                grdHistory.DataSource = dt;
                grdHistory.DataBind();
                dvHistory.Visible = true;
                pnlComponent.Visible = false;
                pnlHide1.Visible = true;
            }
        }
    }

    protected void grdHistory_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            e.Row.Attributes["onmouseover"] = "javascript:SetMouseOver(this)";
            e.Row.Attributes["onmouseout"] = "javascript:SetMouseOut(this)";
        }
    }

    protected void grvListForm_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            String ResultID = "";
            if (((Label)e.Row.FindControl("lblResultID2")).Text != "")
                ResultID = ((Label)e.Row.FindControl("lblResultID2")).Text;
            else if (((Label)e.Row.FindControl("lblResult1")).Text != "")
                ResultID = ((Label)e.Row.FindControl("lblResultID1")).Text;
            else
                ResultID = ((Label)e.Row.FindControl("lblResultID")).Text;

            if (ResultID == "3" || ResultID == "5")
            {
               
                e.Row.Attributes.Add("style", "background-color:red");
                btnSave.Visible = false;
                btnRepeate.Visible = true;
                
            }

           
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BloodBank.bindBloodGroup(ddlBloodgroup);
            ddlBloodgroup.Items.Insert(0, new ListItem("Select", "0"));
            txtcollectfrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtcollectTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            
            txtCollectionId.Text = string.Empty;
            txtCollectionId.Focus();
            lblSessionCenter.Text = Session["Centre"].ToString();
            btnSearch.Attributes.Add("onclick", String.Format("this.value='Please Wait...';this.disabled = true; {0};", this.ClientScript.GetPostBackEventReference(btnSearch, String.Empty)));
            calcollectfrom.EndDate = DateTime.Now;
            calcollectTo.EndDate = DateTime.Now;

            ViewState["CenterID"] = Util.GetString(Session["CentreID"].ToString());//
        }
        txtcollectfrom.Attributes.Add("readOnly", "true");
        txtcollectTo.Attributes.Add("readOnly", "true");
    }

    private void BindGrid()
    {
        StringBuilder sb = new StringBuilder();
               sb.Append(" SELECT (CASE WHEN r3.ResultStep IS NOT NULL THEN r3.ID  WHEN r2.ResultStep IS NOT NULL THEN r2.ID ELSE  r1.ID END)ID,");
        sb.Append(" r1.BloodCollection_ID,r1.screening_ID,BM.TestName,r1.Value,r1.Method,r1.Result Result,r2.result result1,r3.Result result2 ");
        sb.Append("   ,r1.ResultID ResultID,r2.ResultID ResultID1,r3.ResultID ResultID2");
        sb.Append("    FROM  bb_bloodtests_master bm LEFT JOIN ( 	SELECT bs.Id,rm.id ResultID,BloodCollection_Id,screening_ID,TestName,bs.Result,VALUE,Method,bs.CreatedBy, ResultStep ");
        sb.Append("      	FROM bb_blood_screening bs INNER JOIN bb_result_master rm ON bs.ResultID=rm.ID WHERE ResultStep=0 AND BloodCollection_Id='" + lblDonationId.Text + "'  ");
        sb.Append(" )r1 ON bm.id=r1.testname LEFT JOIN (      SELECT bs.Id,rm.id ResultID,BloodCollection_Id,screening_ID,TestName,bs.Result,VALUE,Method,bs.CreatedBy  ,ResultStep");
        sb.Append("      FROM bb_blood_screening bs INNER JOIN bb_result_master rm ON bs.ResultID=rm.ID WHERE ResultStep=1  AND BloodCollection_Id='" + lblDonationId.Text + "' )r2 ON bm.id=r2.testname LEFT JOIN (");
        sb.Append("      SELECT bs.Id,rm.id ResultID,BloodCollection_Id,screening_ID,TestName,bs.Result,VALUE,Method,bs.CreatedBy  ,ResultStep");
        sb.Append("      FROM bb_blood_screening bs INNER JOIN bb_result_master rm ON bs.ResultID=rm.ID WHERE ResultStep=2 AND BloodCollection_Id='" + lblDonationId.Text + "'  ");
        sb.Append(" )r3 ON bm.id=r3.testname   ORDER BY bm.Id ");

        DataTable dt1 = StockReports.GetDataTable(sb.ToString());
        if (dt1.Rows.Count > 0)
        {
            grvListForm.DataSource = dt1;
            grvListForm.DataBind();
            int count = Util.GetInt(StockReports.ExecuteScalar("SELECT MAX(ResultStep) FROM bb_blood_screening  WHERE BloodCollection_Id='" + lblDonationId.Text + "'"));

            for (int i = 0; i < grvListForm.Rows.Count; i++)
            {

                if (count == 0)
                {
                    if (((Label)grvListForm.Rows[i].FindControl("lblResultID")).Text == "3" || ((Label)grvListForm.Rows[i].FindControl("lblResultID")).Text == "5")
                    {
                        //ResultID = ((Label)grvListForm.Rows[i].FindControl("lblResultID")).Text;
                        btnSave.Visible = false;
                    }
                }
                else if (count == 1)
                {
                    if (((Label)grvListForm.Rows[i].FindControl("lblResultID1")).Text == "3" || ((Label)grvListForm.Rows[i].FindControl("lblResultID1")).Text == "5")
                    {
                        //ResultID = ((Label)grvListForm.Rows[i].FindControl("lblResultID1")).Text;
                        btnSave.Visible = false;
                    }
                }
                else if (count == 2)
                {
                    //ResultID = ((Label)grvListForm.Rows[i].FindControl("lblResultID2")).Text;
                    if (((Label)grvListForm.Rows[i].FindControl("lblResultID2")).Text == "3" || ((Label)grvListForm.Rows[i].FindControl("lblResultID2")).Text == "5")
                    {
                        btnRepeate.Visible = false;
                        btnSave.Visible = false;
                    }
                }
            }
        }
    }

    private void search()
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT DISTINCT(bs.Screening_Id),bv.Visitor_ID,bv.Name,bv.dtBirth,bm.BloodGroup,bvh.BBTubeNo,DATE_FORMAT(cd.collecteddate,'%d-%b-%Y')collecteddate,cd.Bloodcollection_id ");
            sb.Append(" FROM bb_visitors bv  INNER JOIN bb_visitors_history bvh ON bv.Visitor_ID=bvh.Visitor_ID INNER JOIN bb_collection_details cd  ");
            sb.Append(" ON cd.Visitor_ID=bvh.Visitor_ID and cd.visit_id=bvh.visit_id INNER JOIN bb_bloodgroup_master bm ON bm.Id=bv.BloodGroup_ID  ");
            sb.Append(" INNER JOIN bb_blood_screening bs ON bs.BloodCollection_Id=cd.BloodCollection_Id ");
            sb.Append(" WHERE  bvh.Isscreened=1 AND bs.IsApproved=1 AND bvh.CentreID=" + Util.GetInt(ViewState["CenterID"]) + "  ");
            if (txtDonorId.Text != "")
            {
                sb.Append("and bv.Visitor_ID = '" + txtDonorId.Text + "'");
            }
            if (txtCollectionId.Text != "")
            {
                sb.Append(" and cd.BloodCollection_ID='" + txtCollectionId.Text + "'");
            }
            if (txtName.Text != "")
            {
                sb.Append(" and bv.Name Like '" + txtName.Text + "'");
            }
            if (ddlBloodgroup.SelectedIndex != 0)
            {
                sb.Append(" and bm.BloodGroup='" + ddlBloodgroup.SelectedItem.Text + "'");
            }
            if (txtDonorId.Text == "" && txtCollectionId.Text == "" && txtName.Text == "" && ddlBloodgroup.SelectedIndex == 0)
            {
                if (txtcollectfrom.Text != "")
                {
                    sb.Append("AND DATE(cd.collecteddate) >='" + Util.GetDateTime(txtcollectfrom.Text).ToString("yyyy-MM-dd") + "'");
                }
                if (txtcollectTo.Text != "")
                {
                    sb.Append(" and DATE(cd.collecteddate) <='" + Util.GetDateTime(txtcollectTo.Text).ToString("yyyy-MM-dd") + "'");
                }
            }
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                lblMsg.Text = "";
                grdDonor.DataSource = dt;
                grdDonor.DataBind();
                pnlHide.Visible = true;
                pnlHide1.Visible = false;
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
                //lblMsg.Text = "No Record Found";
                grdDonor.DataSource = null;
                grdDonor.DataBind();
                pnlHide.Visible = false;
                pnlHide1.Visible = false;
            }
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            grdDonor.DataSource = null;
            grdDonor.DataBind();
            pnlHide.Visible = false;
            pnlHide1.Visible = false;
        }
    }
}