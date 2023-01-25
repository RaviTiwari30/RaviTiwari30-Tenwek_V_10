using System;
using System.Data;
using System.Text;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
public partial class Design_CPOE_Cardiac_Vital_Examination : System.Web.UI.Page
{

    public void BindDetails()
    {
        try
        {
            caldate.EndDate = DateTime.Now;
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT *,(SELECT Name 	FROM 	employee_master  WHERE  EmployeeId=CVE.EntryBy LIMIT 0, 1) AS EntryBy1 FROM cardiac_vital_examination CVE where CVE.PatientId='" + ViewState["PID"]+"'");
            //sb.Append("   INNER JOIN patient_master pm ON pm.PatientID=cv.PatientID");
            //sb.Append("   INNER JOIN employee_master em ON em.EmployeeID=cv.EntryBy");
            //sb.Append("    WHERE cv.TransactionID='" + ViewState["TID"] + "' ORDER BY cv.EntryDate DESC;");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                grdPhysical.DataSource = dt;
                grdPhysical.DataBind();
            }
            else
            {
                grdPhysical.DataSource = null;
                grdPhysical.DataBind();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        try
        {
            Clear();
            lblMsg.Text = "";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            if (!Validation())
            {
                return;
            }
         string result=   SaveData();
         if (result != string.Empty)
            {
                if (result == "0")
                {
                    return;
                }

                lblMsg.Text = "Record Saved Successfully";
                BindDetails();
                Clear();
            }
            else
            {
                lblMsg.Text = "Record not Saved";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        if (!Validation())
        {
            return;
        }

        MySqlConnection con = new MySqlConnection(Util.GetConString());
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        if (DateTime.Parse(txtDate.Text.Trim()) > (DateTime.Now))
        {
            lblMsg.Text = "Only Past  dates alllowed";
            return;
        }
        
        try
        {

            StringBuilder sb = new StringBuilder();
            sb.Append(" UPDATE   `cardiac_vital_examination` SET    `PUOILSLR` = '"+txtPUOILSLR.Text+"',  `ReactionLR` = '"+txtReactionLR.Text+"',  `Temp` = '"+txtTemp.Text+"',  `HR` = '"+txtHR.Text+
                "',  `Rhythm` = '"+txtRhythm.Text+"',  `ABP` = '"+txtABP.Text+"',"+
 " `MAP` = '"+txtMAP.Text+"',  `CVP` = '"+txtCVP.Text+"',  `Pulses` = '"+txtPulses.Text+"',  `RadialLR` = '"+txtRadialLR.Text+"',  `DPLR` = '"+txtDPLR.Text+"',  `PTLR` = '"+txtPTLR.Text+"',  `NBP` = '"+
 txtNBP.Text+"',  `INTEXT` = '"+txtINTEXT.Text+"',  `RR` = '"+txtRR.Text+"',  `SaO2` = '"+txtSaO2.Text+"',"+
"  `FiO2` = '"+txtFiO2.Text+"',  `BreathSoundL` = '"+txtBreathSoundL.Text+"',  `BreathSoundR` = '"+txtBreathSoundR.Text+"',  `RBS` = '"+txtRBS.Text+"',  `IVAssessmentweight` = '"+txtIVAssessmentweight.Text+"',  `DripDoses` = '"+
txtDripDoses.Text+"',"+
"  `Remark` = '" + txtRemark.Text + "',  `Date` = '" + Util.GetDateTime(txtDate.Text.Trim()).ToString("yyyy-MM-dd") + "',   `Time` = '" + Util.GetDateTime(((TextBox)StartTime.FindControl("txtTime")).Text).ToString("HH:mm:ss") +
"',OperationMode='"+ddlOperationMode.SelectedValue+"',Trigger1='"+ddlTrigger.SelectedValue+"',Support='"+ddlSupport.SelectedValue+"' ");
            sb.Append("  WHERE ID = '" + lblPID.Text + "' ");


            int result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            if (result == 1)
                lblMsg.Text = "Record Updated Successfully";
            tnx.Commit();
            BindDetails();
            Clear();
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

    protected void grdPhysical_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            if (e.CommandName == "Change")
            {
                lblMsg.Text = "";

                int id = Convert.ToInt16(e.CommandArgument.ToString());
                txtPUOILSLR.Text = ((Label)grdPhysical.Rows[id].FindControl("lblPUPLISLR")).Text;
                lblPID.Text = ((Label)grdPhysical.Rows[id].FindControl("lblID")).Text;
                txtReactionLR.Text = ((Label)grdPhysical.Rows[id].FindControl("lblReactionLR")).Text;
                txtTemp.Text = ((Label)grdPhysical.Rows[id].FindControl("lblTemp")).Text;
                txtHR.Text = ((Label)grdPhysical.Rows[id].FindControl("lblHR")).Text;
                txtRhythm.Text = ((Label)grdPhysical.Rows[id].FindControl("lblRhythm")).Text;
                txtABP.Text = ((Label)grdPhysical.Rows[id].FindControl("lblABP")).Text;
                txtMAP.Text = ((Label)grdPhysical.Rows[id].FindControl("lblMAP")).Text;
                txtCVP.Text = ((Label)grdPhysical.Rows[id].FindControl("lblCVP")).Text;
                txtPulses.Text = ((Label)grdPhysical.Rows[id].FindControl("lblPulses")).Text;
                txtRadialLR.Text = ((Label)grdPhysical.Rows[id].FindControl("lblRadialLR")).Text;
                txtDPLR.Text = ((Label)grdPhysical.Rows[id].FindControl("lblDPLR")).Text;
                txtPTLR.Text = ((Label)grdPhysical.Rows[id].FindControl("lblPTLR")).Text;
                txtNBP.Text = ((Label)grdPhysical.Rows[id].FindControl("lblNBP")).Text;
                txtINTEXT.Text = ((Label)grdPhysical.Rows[id].FindControl("lblINTEXT")).Text;
                txtRR.Text = ((Label)grdPhysical.Rows[id].FindControl("lblRR")).Text;
                txtSaO2.Text = ((Label)grdPhysical.Rows[id].FindControl("lblSaO2")).Text;
                txtFiO2.Text = ((Label)grdPhysical.Rows[id].FindControl("lblFiO2")).Text;
                txtBreathSoundL.Text = ((Label)grdPhysical.Rows[id].FindControl("lblBreathSoundL")).Text;
                txtBreathSoundR.Text = ((Label)grdPhysical.Rows[id].FindControl("lblBreathSoundR")).Text;
                txtRBS.Text = ((Label)grdPhysical.Rows[id].FindControl("lblRBS")).Text;
                txtIVAssessmentweight.Text = ((Label)grdPhysical.Rows[id].FindControl("lblIVAssessmentweight")).Text;
                txtDripDoses.Text = ((Label)grdPhysical.Rows[id].FindControl("lblDripDoses")).Text;
                txtRBS.Text = ((Label)grdPhysical.Rows[id].FindControl("lblRBS")).Text;
                txtRemark.Text = ((Label)grdPhysical.Rows[id].FindControl("lblRemark")).Text;
                if (((Label)grdPhysical.Rows[id].FindControl("lblOperationMode")).Text != "")
                {
                    ddlOperationMode.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblOperationMode")).Text;
                }
                if (((Label)grdPhysical.Rows[id].FindControl("lblTrigger1")).Text != "")
                {
                    ddlTrigger.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblTrigger1")).Text;
                }
                if (((Label)grdPhysical.Rows[id].FindControl("lblSupport")).Text != "")
                {
                    ddlSupport.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblSupport")).Text;
                }
                txtDate.Text = ((Label)grdPhysical.Rows[id].FindControl("lblDate")).Text;
                ((TextBox)StartTime.FindControl("txtTime")).Text = Util.GetDateTime(((Label)grdPhysical.Rows[id].FindControl("lblTime")).Text).ToString("hh:mm tt"); ;
                btnUpdate.Visible = true;
                btnSave.Visible = false;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void grdPhysical_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        try
        {
            //if (e.Row.RowType == DataControlRowType.DataRow)
            //{
            //    if (((Label)e.Row.FindControl("lblUserID")).Text != Session["ID"].ToString() || Util.GetDateTime(((Label)e.Row.FindControl("lblEntryDate")).Text).ToString("dd-MMM-yyyy") != Util.GetDateTime(System.DateTime.Now).ToString("dd-MMM-yyyy"))
            //    {
            //        ((ImageButton)e.Row.FindControl("imgbtnEdit")).Enabled = false;
            //    }
            //}
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!IsPostBack)
            {
                txtDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                //txtTime.Text = DateTime.Now.ToString("hh:mm tt"); 

                ((TextBox)StartTime.FindControl("txtTime")).Text = Util.GetDateTime(DateTime.Now).ToString("hh:mm tt");
                ViewState["PID"] = Request.QueryString["PatientID"].ToString();
                
                //if (Request.QueryString["App_ID"] != null)
                //{
                //    ViewState["appointmentID"] = Convert.ToString(Request.QueryString["App_ID"]);
                //}
                //else
                //{
                //    ViewState["appointmentID"] = "0";
                //}
                //if (Request.QueryString["TransactionID"] == null)
                //{
                //    ViewState["TID"] = Request.QueryString["TID"].ToString();
                //    ViewState["PID"] = Request.QueryString["PID"].ToString();
                //}
                //else
                //{
                //    ViewState["TID"] = Request.QueryString["TransactionID"].ToString();
                //    ViewState["PID"] = Request.QueryString["PatientID"].ToString();
                //}
                //ViewState["UserID"] = Session["ID"].ToString();
                //if (Request.QueryString["IsViewable"] == null)
                //{
                //    //bool IsDone = Util.GetBoolean(Request.QueryString["IsEdit"]);
                //    string IsDone = StockReports.ExecuteScalar(" select flag from Appointment where App_ID='" + Util.GetInt(Request.QueryString["App_ID"]) + "' ");
                //    string msg = "File Has Been Closed...";
                //    if (IsDone == "1")
                //    {
                //        Response.Redirect("NotAuthorized.aspx?msg=" + msg, false);
                //        Context.ApplicationInstance.CompleteRequest();
                //    }
                //}
                //caldate.EndDate = DateTime.Now;

                BindDetails();
            }

            txtDate.Attributes.Add("readOnly", "true");
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected bool Validation()
    {
        try
        {
            if ((txtPUOILSLR.Text.Trim() == "") && (txtReactionLR.Text.Trim() == "") )
            {
                lblMsg.Text = "Please Fill Mandatory fields";
                txtPUOILSLR.Focus();
                return false;
            }
            return true;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return false;
        }
    }

    private void Clear()
    {
        try
        {
            txtDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");

            ((TextBox)StartTime.FindControl("txtTime")).Text = Util.GetDateTime(DateTime.Now).ToString("hh:mm tt");
                
            txtPUOILSLR.Text = "";
            lblPID.Text = "";
            txtReactionLR.Text = "";
            txtTemp.Text = "";
            txtHR.Text = "";
            txtRhythm.Text = "";
            txtABP.Text = "";
            txtMAP.Text = "";
            txtCVP.Text = "";
            txtPulses.Text = "";
            txtRadialLR.Text = "";
            txtDPLR.Text = "";
            txtPTLR.Text = "";
            txtNBP.Text = "";
            txtINTEXT.Text = "";
            txtRR.Text = "";
            txtSaO2.Text = "";
            txtFiO2.Text = "";
            txtBreathSoundL.Text = "";
            txtBreathSoundR.Text = "";
            txtRBS.Text = "";
            txtIVAssessmentweight.Text = "";
            txtDripDoses.Text = "";
            txtRBS.Text = "";
            txtRemark.Text = "";
            ddlOperationMode.SelectedIndex = -1;
            ddlTrigger.SelectedIndex = -1;
            ddlSupport.SelectedIndex = -1;
            btnUpdate.Visible = false;
            btnSave.Visible = true;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    private string SaveData()
    {
        MySqlConnection con = new MySqlConnection(Util.GetConString());
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        if (DateTime.Parse(txtDate.Text.Trim()) > (DateTime.Now))
        {
            lblMsg.Text = "Only Past  dates allowed"; 
            return "0";
        }
        
        try
        {
            
            StringBuilder sb = new StringBuilder();
            sb.Append(" INSERT INTO `cardiac_vital_examination` (    `PUOILSLR`,  `ReactionLR`,`Temp`,  `HR`,  `Rhythm`,  `ABP`,  `MAP`,  `CVP`,  `Pulses`,  `RadialLR`,  `DPLR`,  `PTLR`,"+
  "`NBP`,  `INTEXT`,  `RR`,  `SaO2`,  `FiO2`,  `BreathSoundL`,  `BreathSoundR`,  `RBS`,  `IVAssessmentweight`,  `DripDoses`,  `Remark`,`Date`,`Time`,`EntryBy`,`PatientId`,OperationMode,Trigger1,Support)"+
" VALUES  (    '" + txtPUOILSLR.Text + "',    '" + txtReactionLR.Text + "',    '" + txtTemp.Text + "',    '" + txtHR.Text + "',    '" + txtRhythm.Text + "',    '" + txtABP.Text + "',    '" + txtMAP.Text + "',    '" + txtCVP.Text +
"',    '" + txtPulses.Text + "',    '" + txtRadialLR.Text + "',    '" + txtDPLR.Text + "',    '" + txtPTLR.Text + "',    '" + txtNBP.Text + "',    '" + txtINTEXT.Text + "',    '" + txtRR.Text + "',    '" + txtSaO2.Text + "'," +
"    '" + txtFiO2.Text + "',    '" + txtBreathSoundL.Text + "',    '" + txtBreathSoundR.Text + "',    '" + txtRBS.Text + "',    '" + txtIVAssessmentweight.Text + "',    '" + txtDripDoses.Text + "',    '" + txtRemark.Text + "','"
+ Util.GetDateTime(txtDate.Text.Trim()).ToString("yyyy-MM-dd") + "',   '" + Util.GetDateTime(((TextBox)StartTime.FindControl("txtTime")).Text).ToString("HH:mm:ss") + "','" + Session["ID"].ToString() + "','"+ViewState["PID"]+"','"+
ddlOperationMode.SelectedValue+"','"+ddlTrigger.SelectedValue+"','"+ddlSupport.SelectedValue+"'  );");

            int result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

            //Insert Viewed Tab Info
            //AllQuery.UpdateDoctorTab_Information(ViewState["TID"].ToString(), Util.GetInt(Request.QueryString["MenuID"]));

            tnx.Commit();
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
}