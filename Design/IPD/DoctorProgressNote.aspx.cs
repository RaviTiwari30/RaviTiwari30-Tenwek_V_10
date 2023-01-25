using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class Design_IPD_DoctorProgressNote : System.Web.UI.Page
{
    DataTable dtDetails;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["UserID"] = Session["ID"].ToString();
            string TID = "";
            //if (Request.QueryString["TransactionID"] != null && Request.QueryString["TransactionID"].ToString() != "")
            //    TID = Util.GetString(StockReports.ExecuteScalar("select mcm.TransactionID from mortuary_corpse_master mcm inner join mortuary_corpse_deposite mcd on mcd.CorpseID=mcm.Corpse_ID where mcd.TransactionID='" + Request.QueryString["TransactionID"].ToString() + "' limit 1"));
            //else
            TID = Request.QueryString["TransactionID"].ToString();

            if (TID == "")
            {
                return;
            }

            ViewState["TransactionID"] = TID;
            txtdate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ViewState["dtDetails"] = dtDetails;
            BindDetails();
            AllQuery AQ = new AllQuery();
            DateTime AdmitDate = Util.GetDateTime(AQ.getAdmitDate(TID));

            calucDate.StartDate = Util.GetDateTime(AdmitDate.ToString("dd-MMM-yyyy"));
            txtdate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            calucDate.EndDate = DateTime.Now;
        }
        txtdate.Attributes.Add("readOnly", "true");
        string logintype = Session["RoleID"].ToString();
        if (logintype != "52" && logintype != "323" && logintype != "111" && logintype != "213")
        {
            btnSave.Visible = false;
        }
        btnSave.Visible = true;
        txtdate.Attributes.Add("readOnly", "readOnly");
    }
    protected void BindDetails()
    {
        string str = "Select Careplan,ID,TransactionId,DATE_FORMAT(EntryDate,'%d-%b-%Y %l:%i %p') as Date,(Select Concat(title,' ',Name) from Employee_master where EmployeeID=UserID)EntryBy,ProgressNote,UserID,TIMESTAMPDIFF(MINUTE,EntryDate,NOW())createdDateDiff from nursing_doctorprogressnote where TransactionId='" + ViewState["TransactionID"] + "' AND isActive=1 order by EntryDate desc";
        //  DataTable dtDetails = StockReports.GetDataTable("Select ID,TransactionId,DATE_FORMAT(EntryDate,'%d-%b-%Y %l:%i %p') as Date,(Select Concat(title,' ',Name) from Employee_master where Employee_ID=UserID)EntryBy,Replace(ProgressNote)ProgressNote from nursing_doctorprogressnote where TransactionId='" + ViewState["TransactionID"] + "' order by EntryDate desc");
        //  str = str.Replace("@", "'");
        DataTable dtDetails = StockReports.GetDataTable(str.ToString());
        if (dtDetails.Rows.Count > 0)
        {
            pnlhide.Visible = true;
            grid.DataSource = dtDetails;
            grid.DataBind();
            ViewState["dtDetails"] = dtDetails;
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (txtnote.Text == "")
        {
            lblMsg.Text = "Pelase Enter the pregress note.";
            txtnote.Focus();
            return;
        }
        if (txtCareplan.Text == "")
        {
            lblMsg.Text = "Please Enter the Care Plan";
            txtCareplan.Focus();
            return;
        }

        var Specialty = "";
        var SpecialtyID = "";
        if (Session["RoleID"].ToString() == "52")
        {
            string DoctorID = StockReports.ExecuteScalar("SELECT DoctorID FROM doctor_employee de WHERE de.EmployeeID='" + Session["ID"] + "'");
            if (DoctorID != "")
            {
                string Specialtydetail = StockReports.ExecuteScalar("SELECT CONCAT(tm.ID,'#',tm.NAME)Specialty FROM doctor_master dm  INNER JOIN type_master tm ON tm.NAME=dm.Specialization  WHERE dm.DoctorID='" + DoctorID + "' AND tm.type='Doctor-Specialization'");
                Specialty = Specialtydetail.Split('#')[1];
                SpecialtyID = Specialtydetail.Split('#')[0];
            }

            else
            {
                Specialty = "Other";
                SpecialtyID = "8";
            }
        }
        else
        {
            Specialty = "Other";
            SpecialtyID = "8";
        }

        string Cadretiertype = StockReports.ExecuteScalar("SELECT CONCAT(ecm.CadreName,'#',etm.tiername,'#',em.cadreID,'#',em.TierID)Cadretier FROM employee_master em INNER JOIN Employee_Cadre_Master ecm ON em.Cadreid=ecm.ID  INNER JOIN Employee_Tier_Master etm ON etm.ID=em.TierID WHERE em.EmployeeID='" + Session["ID"].ToString() + "'");
        lblMsg.Text = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string entrydate = DateTime.Now.ToString("dd-MMM-yyyy");
            string sql = "insert into nursing_doctorprogressnote(TransactionId,NoteDate,ProgressNote,UserID,Careplan,Cadre,Tier,CadreID,TierID,Specialty,SpecialtyID)values('" + Util.GetInt(ViewState["TransactionID"]) + "','" + Util.GetDateTime(txtdate.Text).ToString("yyyy-MM-dd") + "','" + Util.GetString(txtnote.Text).Replace("'", "@") + "','" + Util.GetString(ViewState["UserID"]) + "','" + txtCareplan.Text.Replace("'", "@") + "','" + Cadretiertype.Split('#')[0] + "','" + Cadretiertype.Split('#')[1] + "','" + Cadretiertype.Split('#')[2] + "','" + Cadretiertype.Split('#')[3] + "','"+Specialty+"','"+SpecialtyID+"')";
            StockReports.ExecuteDML(sql);
            tnx.Commit();
            con.Close();
            con.Dispose();
            BindDetails();
            lblMsg.Text = "Record Saved Successfully.";
            clear();
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            lblMsg.Text = ex.Message;
        }
    }


    protected void grid_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        if (ViewState["dtDetails"] != null)
        {
            dtDetails = ((DataTable)ViewState["dtDetails"]);
            decimal createdDateDiff = Util.GetDecimal(dtDetails.Rows[e.RowIndex]["createdDateDiff"].ToString());
            string UserID = dtDetails.Rows[e.RowIndex]["UserID"].ToString();
            int id = Int32.Parse(dtDetails.Rows[e.RowIndex]["ID"].ToString());
            if (UserID == Session["ID"].ToString() && createdDateDiff < Util.GetDecimal(Resources.Resource.EditTimePeriod))
            {
                dtDetails.Rows.RemoveAt(e.RowIndex);
                ViewState["dtDetails"] = dtDetails as DataTable;
                string sql = "UPDATE nursing_doctorprogressnote SET isActive=0 WHERE ID=" + id + "";
                StockReports.ExecuteDML(sql);
                BindDetails();
            }
            else
            {
                lblMsg.Text = "You are not able to Delete the Note Or Delete Time Period Expired";
            }
        }
    }
    protected void grid_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            string pro = ((Label)e.Row.FindControl("lblpro")).Text.Replace("@", "'");
            ((Label)e.Row.FindControl("lblpro")).Text = pro;
            ((Label)e.Row.FindControl("lblCareplan")).Text = ((Label)e.Row.FindControl("lblCareplan")).Text.Replace("@", "'");
        }
    }

    protected void grid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Change")
        {
            lblMsg.Text = "";
            int id = Convert.ToInt16(e.CommandArgument.ToString());
            //lblTimeDiff
            decimal createdDateDiff = Util.GetDecimal(((Label)grid.Rows[id].FindControl("lblTimeDiff")).Text);
            if (((Label)grid.Rows[id].FindControl("lblUserID")).Text == Session["ID"].ToString() && createdDateDiff < Util.GetDecimal(Resources.Resource.EditTimePeriod))
            {
                ((ImageButton)grid.Rows[id].FindControl("imgbtnEdit")).Enabled = true;
                lblID.Text = ((Label)grid.Rows[id].FindControl("lbluID")).Text;
                txtdate.Text = Util.GetDateTime(((Label)grid.Rows[id].FindControl("lblDate")).Text).ToString("dd-MMM-yyyy");
                txtnote.Text = ((Label)grid.Rows[id].FindControl("lblpro")).Text;
                txtCareplan.Text = ((Label)grid.Rows[id].FindControl("lblCareplan")).Text;
                btnSave.Visible = false;
                btnUpdate.Visible = true;
                bynCancel.Visible = true;
                txtnote.Focus();
            }
            else
            {
                ((ImageButton)grid.Rows[id].FindControl("imgbtnEdit")).Enabled = false;
                lblMsg.Text = "You are not able to Edit this Note";
            }
        }
    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        if (txtnote.Text == "")
        {
            lblMsg.Text = "Pelase Enter the pregress note.";
            txtnote.Focus();
            return;
        }
        if (txtCareplan.Text == "")
        {
            lblMsg.Text = "Please Enter the Care Plan.";
            txtCareplan.Focus();
            return;
        }
        string sql = "UPDATE nursing_doctorprogressnote n SET n.Careplan='" + Util.GetString(txtCareplan.Text).Replace("'", "@") + "',n.ProgressNote='" + Util.GetString(txtnote.Text).Replace("'", "@") + "',n.NoteDate='" + Util.GetDateTime(txtdate.Text).ToString("yyyy-MM-dd") + "',n.UpdateBy='" + Session["ID"].ToString() + "',n.UpdateDate=NOW() WHERE n.ID=" + lblID.Text + " ";
        StockReports.ExecuteDML(sql);
        btnSave.Visible = false;
        btnUpdate.Visible = false;
        bynCancel.Visible = false;
        BindDetails();
        clear();
        lblMsg.Text = "Record Updated Successfully.";
    }
    private void clear()
    {
        txtnote.Text = "";
        txtdate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        lblID.Text = "";
        txtCareplan.Text = "";
    }
    protected void bynCancel_Click(object sender, EventArgs e)
    {
        clear();
        btnSave.Visible = true;
        btnUpdate.Visible = false;
        bynCancel.Visible = false;
    }
}
