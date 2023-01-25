using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;

public partial class Design_BloodBank_PatientGroupingApproval : System.Web.UI.Page
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
            
            string BloodGroup = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT BloodTested FROM bb_Grouping WHERE Grouping_Id='" + lblhidden.Text + "' "));
            //string BloodInvestigationId = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT Bloodcollection_Id FROM bb_collection_details WHERE BloodCollection_ID = '" + CollectionID + "' "));
            //MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE bb_visitors_history Set IsGrouped =3 where BloodCollection_ID='" + BloodInvestigationId + "'");
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE bb_Grouping SET IsApproved=3 ,ApprovedBy='" + Session["ID"].ToString() + "',status= 1,Remark='" + txtRemark.Text + "',ScreenedBG='" + BloodGroup + "'  WHERE Grouping_Id='" + lblhidden.Text + "' ");
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE bb_grouping_history SET IsApproved=3,Remarks='" + txtRemark.Text + "' WHERE Grouping_Id='" + lblhidden.Text + "' ");
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE Patient_master SET BloodGroup='" + BloodGroup + "' WHERE PatientID='" + lblPatientID1.Text + "'");
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
        if (lblHdn2.Text == "2")  // reject
        {
            StringBuilder sb = new StringBuilder();
            string gp = "Update bb_grouping Set IsApproved=2, Remark='" + txtRemark.Text + "' where Grouping_Id='" + lblhidden.Text + "'";   // IsApproved : 2 : Reject
            string qry = "Update bb_grouping_history SET IsApproved=2, RejectedBy='" + Session["ID"].ToString() + "', Remarks='" + txtRemark.Text + "' where Grouping_Id='" + lblhidden.Text + "'";
            StockReports.ExecuteDML(qry.ToString());
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
        else if (lblHdn2.Text == "1")  // approved
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
            Control ctrl = e.CommandSource as Control;
            if (ctrl != null)
            {
                GridViewRow row = ctrl.Parent.NamingContainer as GridViewRow;
                //LinkButton fullname = (LinkButton)row.FindControl("lbName");
                Label lblAssaignedto = (Label)row.FindControl("lblPatientID");
                lblPatientID1.Text = lblAssaignedto.Text;
            }
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
            txtIPDNo.Text = string.Empty;
            txtIPDNo.Focus();
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

    //private void search()
    //{
    //    try
    //    {
    //        StringBuilder sb = new StringBuilder();
    //        sb.Append("SELECT bv.Visitor_ID,cd.Bloodcollection_id,bv.Name,bm.BloodGroup,bv.dtBirth,bv.Gender,DATE_FORMAT(cd.CollectedDate,'%d-%b-%Y')CollectedDate,GP.Grouping_Id, ");
    //        sb.Append("GP.ScreenedBG,CASE WHEN (gp.AntiA=1) THEN 'N' ELSE 'P' END AS AntiA,CASE WHEN (gp.AntiB=1) THEN 'N' ELSE 'P' END AS AntiB,   ");
    //        sb.Append("  CASE WHEN (gp.AntiAB=1) THEN 'N' ELSE 'P' END AntiAB,CASE WHEN (gp.RH=1) THEN 'N' ELSE 'P' END AS RH, ");
    //        sb.Append("  gp.BloodTested,CASE WHEN (gp.IsSame=0) THEN 'No' ELSE 'Yes' END AS IsSame,");
    //        sb.Append("   DATE_FORMAT(GP.createdDate,'%d-%b-%Y')DATE FROM bb_visitors_history vh INNER JOIN bb_visitors bv ON vh.Visitor_ID=bv.Visitor_ID");
    //        sb.Append("     INNER JOIN bb_collection_details cd ON cd.Visitor_Id=bv.Visitor_ID  AND cd.visit_id=vh.visit_id ");
    //        sb.Append("  INNER JOIN bb_grouping gp ON gp.BloodCollection_Id =cd.BloodCollection_Id        INNER JOIN bb_bloodgroup_master bm ON bm.Id=bv.BloodGroup_ID ");
    //        sb.Append("   WHERE (vh.IsGrouped=1 AND GP.IsApproved=1 AND GP.IsSame=0) ");
    //        if (txtDonationId.Text.Trim() != "")
    //        {
    //            sb.Append("AND cd.BloodCollection_Id ='" + txtDonationId.Text + "'");
    //        }
    //        if (txtName.Text != "")
    //        {
    //            sb.Append(" AND bv.Name like '%" + txtName.Text + "%'");
    //        }
    //        if (ddlBloodgroup.SelectedIndex != 0)
    //        {
    //            sb.Append(" AND bm.BloodGroup='" + ddlBloodgroup.SelectedItem.Text + "'");
    //        }
    //        if (txtDonorId.Text.Trim() != "")
    //        {
    //            sb.Append(" AND bv.Visitor_ID ='" + txtDonorId.Text + "'");
    //        }
    //        if (txtDonationId.Text == "" && txtName.Text == "" && txtDonorId.Text == "" && ddlBloodgroup.SelectedIndex == 0)
    //        {
    //            if (txtcollectedfrom.Text != "")
    //            {
    //                sb.Append(" AND DATE(cd.CollectedDate) >='" + Util.GetDateTime(txtcollectedfrom.Text).ToString("yyyy-MM-dd") + "'");
    //            }
    //            if (txtcollectedTo.Text != "")
    //            {
    //                sb.Append(" and DATE(cd.CollectedDate) <='" + Util.GetDateTime(txtcollectedTo.Text).ToString("yyyy-MM-dd") + "'");
    //            }
    //        }
    //        DataTable dt = StockReports.GetDataTable(sb.ToString());
    //        if (dt.Rows.Count > 0)
    //        {
    //            //lblMsg.Text = "Total " + dt.Rows.Count + "Record Found";
    //            grdBloodMatch.DataSource = dt;
    //            grdBloodMatch.DataBind();
    //            pnlHide.Visible = true;
    //        }
    //        else
    //        {
    //            grdBloodMatch.DataSource = dt;
    //            grdBloodMatch.DataBind();

    //            pnlHide.Visible = false;
    //            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
    //        }
    //    }
    //    catch (Exception ex)
    //    {
    //        ClassLog ca = new ClassLog();
    //        ca.errLog(ex);
    //        grdBloodMatch.DataSource = null;
    //        grdBloodMatch.DataBind();
    //        pnlHide.Visible = false;
    //    }
    //}


    private void search()
    {
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("SELECT gp.Grouping_Id Grouping_Id,bcd.Visitor_Id,CONCAT(pm.Title,'',pm.PName) Name,DATE_FORMAT(bcd.CollectedDate,'%d-%b-%Y')CollectedDate,CONCAT(pm.Age,pm.Gender)AgeSex, ");
            sb.Append(" CASE WHEN (gp.AntiA=1) THEN 'N' ELSE 'P' END AS AntiA, CASE WHEN (gp.AntiB=1) THEN 'N' ELSE 'P' END AS AntiB,CASE WHEN (gp.AntiAB=1) THEN 'N' ELSE 'P' END AS AntiAB,CASE WHEN (gp.RH=1) THEN 'N' ELSE 'P' END AS RH, ");
            sb.Append(" gp.BloodTested,CASE WHEN (gp.IsSame=0) THEN 'No' ELSE 'Yes' END AS IsSame, DATE_FORMAT(GP.createdDate,'%d-%b-%Y')DATE, IF(pmh.type='IPD',REPLACE(pmh.TransactionID,'ISHHI',''),'') AS IPDNo,pm.PatientID ");
            sb.Append(" FROM patient_master pm ");
            sb.Append(" INNER JOIN patient_medical_history pmh ON pm.PatientID=pmh.PatientID  INNER JOIN bb_grouping gp ON gp.`TransactionID`=pmh.`TransactionID` ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.ledgertransactionNo=gp.ledgertransactionNo INNER JOIN bb_collection_details bcd ON bcd.Visitor_Id=gp.PatientID AND bcd.IsPatient=1  INNER JOIN bb_grouping_history gph ON gph.Grouping_Id=gp.Grouping_Id WHERE gp.IsApproved=1 AND gp.IsSame=0 AND gph.IsActive=1 AND gph.CentreID=" + Util.GetInt(ViewState["CenterID"]) + " ");

            if (txtIPDNo.Text == string.Empty && txtName.Text == string.Empty && txtUHID.Text == string.Empty)
            {
                if (txtcollectedfrom.Text != "")
                    sb.Append(" AND DATE(bcd.CollectedDate) >='" + Util.GetDateTime(txtcollectedfrom.Text).ToString("yyyy-MM-dd") + "'");
                if (txtcollectedTo.Text != "")
                    sb.Append(" AND DATE(bcd.CollectedDate) <='" + Util.GetDateTime(txtcollectedTo.Text).ToString("yyyy-MM-dd") + "'");
            }

            if (rbtType.SelectedValue != "All")
            {
                if (rbtType.SelectedValue == "OPD")
                {
                    sb.Append(" AND IF(lt.TypeOfTnx IN ('opd-others','casualty-billing','opd-procedure','OPD-BILLING'),'OPD','IPD')='OPD' AND pmh.TYPE='OPD' ");
                }
                else if (rbtType.SelectedValue == "IPD")
                {
                    sb.Append(" AND IF(lt.TypeOfTnx IN ('opd-others','casualty-billing','opd-procedure','OPD-BILLING'),'OPD','IPD')='IPD' AND pmh.TYPE='IPD' ");
                }
                else if (rbtType.SelectedValue == "EMG")
                {
                    sb.Append(" AND lt.TypeOfTnx IN ('Emergency') AND pmh.TYPE='EMG' ");
                }
            }

            if (txtIPDNo.Text != "")
            {
             //   sb.Append(" AND IF(pmh.type='IPD',REPLACE(pmh.TransactionID,'ISHHI',''),'')='" + txtIPDNo.Text + "'");
                sb.Append(" AND pmh.TransNo=" + txtIPDNo.Text.Trim() + " AND pmh.TYPE='IPD' ");
            }

            if (txtName.Text != "")
                sb.Append(" AND CONCAT(pm.`PFirstName`,' ',pm.`PLastName`) LIKE '" + txtName.Text.Trim() + "%' ");

            if (txtUHID.Text != "")
                sb.Append(" AND pm.PatientID='" + txtUHID.Text + "' ");

            if (ddlBloodgroup.SelectedIndex != 0)
                sb.Append(" AND gp.BloodTested='" + ddlBloodgroup.SelectedItem.Text + "' ");

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
