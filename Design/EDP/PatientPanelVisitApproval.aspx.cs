using System;
using System.Data;
using System.Text;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_EDP_PatientPanelVisitApproval : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            fillPanel("", "");
        }

    }
    private void fillGrid(string pid)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT *,TIMESTAMPDIFF(MINUTE,pd.EntryDate,NOW())createdDateDiff,(SELECT Name 	FROM 	employee_master  WHERE  EmployeeId=EntryBy LIMIT 0, 1) AS EntryBy1,IF(pd.IsActive='1','Active','DeActive') as Status,pd.ID as ID1, DATE_FORMAT(FromValid, '%d %b %Y %r') as FromValid1, DATE_FORMAT(ToValid, '%d %b %Y %r') as ToValid1, DATE_FORMAT(EntryDate, '%d %b %Y %r') as EntryDate1 FROM `patient_master` pm INNER JOIN PanelDetails pd ON pm.PatientID=pd.PatientID " +
" INNER JOIN f_panel_master fpm ON fpm.PanelID=pd.PanelID where pm.PatientID='" + pid + "' order by pd.ID desc");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                grdPanel.DataSource = dt;
                grdPanel.DataBind();
                fillPanel(pid, "");
            }
            else
            {

                lblMsg.Text = "No Rows Found.";

            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    private void fillPanel(string PatientId, string SelectedPanel)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  select PanelID,Company_Name from f_panel_master fpm where IsActive='1'");
            sb.Append("   AND fpm.PanelID IN(SELECT pp.`Panel_ID` FROM patient_policy_detail pp WHERE pp.`Patient_ID`='" + PatientId + "' and pp.Panel_ID not in('1')) ");
            sb.Append("     order by Company_Name ");


            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                ddlPanel.DataSource = dt;
                ddlPanel.DataBind(); 
                ddlPanel.Items.Insert(0, new ListItem("Select", "")); 
                ddlPanel.Items.FindByValue(SelectedPanel).Selected = true;
            }
            else
            {

                lblMsg.Text = "No Panel Found.";

            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
    private void Clear()
    {
        ddlPanel.SelectedIndex = 0;
        txtFromDate.Text = "";
        txtToDate.Text = "";
        txtCardNo.Text = "";
        txtApproveAmount.Text = "";
        txtLOUNo.Text = "";
    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {

        MySqlConnection con = new MySqlConnection(Util.GetConString());
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {

            string fromdate = Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(((TextBox)StartTime.FindControl("txtTime")).Text).ToString("HH:mm:ss");
            string todate = Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(((TextBox)StartTime1.FindControl("txtTime")).Text).ToString("HH:mm:ss");

            StringBuilder sb = new StringBuilder();

            sb.Append(" UPDATE  `paneldetails` set  `PatientID`='" + lblPatientID.Text + "',LOUNo='"+txtLOUNo.Text+"',  `PanelID`='" + ddlPanel.SelectedValue + "'," +
            "  `CardNumber`='" + txtCardNo.Text + "',  `FromValid`= '" + fromdate + "',  `ToValid`= '" + todate + "',  `ApproveAmount`='" + txtApproveAmount.Text + "'" +
         " ,UpdatedBy='"+Session["ID"].ToString()+"',UpdatedDate=NOW() where ID='" + ViewState["RowID"].ToString() + "'");
            int result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());



            StringBuilder sb1 = new StringBuilder();


            sb1.Append(" UPDATE  `paneldetails_description` set amount=" + Util.GetDecimal(txtApproveAmount.Text) + "   where paneldetails='" + ViewState["RowID"].ToString() + "'");
            int result1 = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

            tnx.Commit();

            lblMsg.Text = "Update Successfully.";
            fillGrid(lblPatientID.Text);
            fillPanel(lblPatientID.Text, "");
            Clear();
            btnSave.Visible = true;
            btnUpdate.Visible = false;
        }
        catch (Exception ex)
        {
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

    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection(Util.GetConString());
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {

            string count = StockReports.ExecuteScalar("SELECT count(*) FROM paneldetails  WHERE LOUNo='" + txtLOUNo.Text + "'");
            if (count == "0")
            {

                int result1 = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update paneldetails set IsActive='0' where PatientID='" + lblPatientID.Text + "' and PanelID='" + ddlPanel.SelectedValue + "' ");

                string entrydate = Util.GetDateTime(DateTime.Now.ToString().Trim()).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(DateTime.Now.ToString()).ToString("HH:mm:ss");
                string fromdate = Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(((TextBox)StartTime.FindControl("txtTime")).Text).ToString("HH:mm:ss");
                string todate = Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(((TextBox)StartTime1.FindControl("txtTime")).Text).ToString("HH:mm:ss");

                StringBuilder sb = new StringBuilder();

                sb.Append(" INSERT INTO `paneldetails` (   `PatientID`,  `PanelID`,  `CardNumber`,`LOUNo`,  `FromValid`,  `ToValid`,  `ApproveAmount`,  `EntryBy`,  `EntryDate`,  `IsActive`)" +
    " VALUES  ( '" + lblPatientID.Text + "','" + ddlPanel.SelectedValue + "','" + txtCardNo.Text + "','" + txtLOUNo.Text + "',  '" + fromdate + "',  '" + todate + "',    '" + txtApproveAmount.Text + "',    '" + Session["ID"].ToString() + "','" + entrydate + "','1'  );");
                int result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());



                int PanelDetailsID = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT MAX(id)FROM paneldetails"));

                StringBuilder sb1 = new StringBuilder();
                sb1.Append(" INSERT INTO `paneldetails_description` (PanelDetailsId,pool_nr,pool_desc,");
                sb1.Append("  amount,claimable,location_id , sp_id,location_name , BenefitID,SessionID )");
                sb1.Append(" VALUES  ( ");
                sb1.Append(" " + PanelDetailsID + ",'0' ,'Lu',");
                sb1.Append(" " + Util.GetDecimal(txtApproveAmount.Text) + ",'0' ,'0',");
                sb1.Append(" '0','Hospital','0' ,'0' ");

                sb1.Append(" )");

                int DesRes = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb1.ToString());





                tnx.Commit();

                lblMsg.Text = "Saved Successfully.";
            }
            else
            {

                lblMsg.Text = "LOU No already exists.";
            }

            fillGrid(lblPatientID.Text);
            fillPanel(lblPatientID.Text, "");
            Clear();
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            lblMsg.Text = ex.ToString();
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    protected void grdPhysical_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        int id = Convert.ToInt16(e.CommandArgument.ToString());
        ViewState["RowID"] = ((Label)grdPanel.Rows[id].FindControl("lblID")).Text;


        sb.Append("SELECT pd.PatientID,pd.PanelID,pm.Pname,pm.Mobile,pd.CardNumber,pd.LOUNo,pd.ApproveAmount,DATE_FORMAT(pd.`FromValid`,'%d-%b-%Y')FromValid,DATE_FORMAT(pd.ToValid,'%d-%b-%Y')ToValid,(SELECT Name 	FROM 	employee_master  WHERE  EmployeeId=EntryBy LIMIT 0, 1) AS EntryBy1,IF(pd.IsActive='1','Active','DeActive') as Status,pd.PanelID as PanelID1,TIME_FORMAT(pd.`FromValid`,'%h:%m %p')TimeFromValid,TIME_FORMAT(pd.`ToValid`,'%h:%m %p')TimeToValid FROM `patient_master` pm INNER JOIN PanelDetails pd ON pm.PatientID=pd.PatientID " +
" INNER JOIN f_panel_master fpm ON fpm.PanelID=pd.PanelID where pd.ID='" + ViewState["RowID"].ToString() + "'");


        DataTable dt = StockReports.GetDataTable(sb.ToString());

        fillPanel(dt.Rows[0]["PatientID"].ToString(),dt.Rows[0]["PanelID1"].ToString());
        
        lblPatientName.Text = dt.Rows[0]["Pname"].ToString();
        lblMobileNo.Text = dt.Rows[0]["Mobile"].ToString();
        ddlPanel.SelectedValue = dt.Rows[0]["PanelID1"].ToString();
        txtCardNo.Text = dt.Rows[0]["CardNumber"].ToString();
        txtLOUNo.Text = dt.Rows[0]["LOUNo"].ToString();
        txtFromDate.Text = dt.Rows[0]["FromValid"].ToString();

        ((TextBox)StartTime.FindControl("txtTime")).Text = dt.Rows[0]["TimeFromValid"].ToString();
        txtToDate.Text = dt.Rows[0]["ToValid"].ToString();
        ((TextBox)StartTime1.FindControl("txtTime")).Text = dt.Rows[0]["TimeToValid"].ToString();
        txtApproveAmount.Text = dt.Rows[0]["ApproveAmount"].ToString();
        btnSave.Visible = false;
        btnUpdate.Visible = true;

    }
    protected void grdPhysical_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            decimal createdDateDiff = Util.GetDecimal(((Label)e.Row.FindControl("lblTimeDiff")).Text);
            string status = Util.GetString(((Label)e.Row.FindControl("lblStatus1")).Text);
            if (createdDateDiff < Util.GetDecimal(Resources.Resource.EditTimePeriod))
            {
                ((ImageButton)e.Row.FindControl("imgbtnEdit")).Enabled = true;
            }
            else
            {
                ((ImageButton)e.Row.FindControl("imgbtnEdit")).Enabled = false;
            }
            if (status == "Active")
            {
                ((ImageButton)e.Row.FindControl("imgbtnEdit")).Visible = true;
            }
            else
            {
                ((ImageButton)e.Row.FindControl("imgbtnEdit")).Visible = false;
            }
        }

        int CanEditPanelApproval = 0;
        DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(Session["RoleID"]), Util.GetString(Session["ID"]));
        if (dtAuthority.Rows.Count > 0)
        {
            if (Util.GetInt(dtAuthority.Rows[0]["CanEditPanelApproval"]) == 1)
            {
                CanEditPanelApproval = 1;//"You Are Not Authorised for it";
            }
        }
        if (e.Row.RowType == DataControlRowType.DataRow)
        {

            if (CanEditPanelApproval == 0)
            {
                ((ImageButton)e.Row.FindControl("imgbtnEdit")).Visible = false;
            }
            else if (CanEditPanelApproval == 1 && Util.GetString(((Label)e.Row.FindControl("lblStatus1")).Text)=="Active")
            {
                ((ImageButton)e.Row.FindControl("imgbtnEdit")).Visible = true;
            }
        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        try
        {
            if (txtPatientID.Text != "")
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("  select * from patient_master  where PatientId='" + txtPatientID.Text + "'");
                DataTable dt = StockReports.GetDataTable(sb.ToString());
                if (dt.Rows.Count > 0)
                {
                    lblPatientID.Text = dt.Rows[0]["PatientID"].ToString();
                    lblPatientName.Text = dt.Rows[0]["PName"].ToString();
                    lblMobileNo.Text = dt.Rows[0]["Mobile"].ToString();
                    fillGrid(txtPatientID.Text);
                    fillPanel(lblPatientID.Text, "");

                    lblMsg.Text = "";
                }
                else
                {

                    lblMsg.Text = "No Record Found.";

                }
            }
            else
            {
                lblMsg.Text = "Please fill patient ID.";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
}