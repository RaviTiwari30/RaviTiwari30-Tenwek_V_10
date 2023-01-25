using System;
using System.Data;
using System.Text;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_ip_Cardiac_BloodGasChart : System.Web.UI.Page
{

    public void BindDetails()
    {
        try
        {

            caldate.EndDate = DateTime.Now;
            StringBuilder sb = new StringBuilder();
            sb.Append("   SELECT *,(SELECT Name 	FROM 	employee_master  WHERE  EmployeeId=EntryBy LIMIT 0, 1) AS EntryBy1 FROM cardiac_bloodgaschart where PatientId='"+ViewState["PID"]+"'");
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
            string result = SaveData();
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
            sb.Append(" UPDATE  `cardiac_bloodgaschart` SET   `Date` = '" + Util.GetDateTime(txtDate.Text.Trim()).ToString("yyyy-MM-dd") + "',  `Time` = '" + Util.GetDateTime(((TextBox)StartTime.FindControl("txtTime")).Text).ToString("HH:mm:ss") + 
                "',  `pH` = '"+txtpH.Text+"',  `PCO2` = '"+txtPCO2.Text+"',  `PO2` = '"+txtPO2.Text+"',  `BEecf` = '"+txtBEecf.Text+"',  `HCO3` = '"+txtHCO3.Text+"'," +
  "`TCO2` = '"+txtTCO2.Text+"',  `sO2` = '"+txtsO2.Text+"',  `Na` = '"+txtNa.Text+"',  `K` = '"+txtK.Text+"',  `iCa` = '"+txtiCa.Text+"',  `Glumgdl` = '"+txtGlumgdl.Text+"',  `Hct` = '"+txtHct.Text+"',  `Hbgdl` = '"+txtHbgdl.Text+"'");
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
                lblPID.Text = ((Label)grdPhysical.Rows[id].FindControl("lblID")).Text;
                txtpH.Text = ((Label)grdPhysical.Rows[id].FindControl("lblpH")).Text;
                //txtDate.Text = ((Label)grdPhysical.Rows[id].FindControl("lblDate")).Text;
                txtPCO2.Text = ((Label)grdPhysical.Rows[id].FindControl("lblPCO2")).Text;
                txtPO2.Text = ((Label)grdPhysical.Rows[id].FindControl("lblPO2")).Text;
                txtBEecf.Text = ((Label)grdPhysical.Rows[id].FindControl("lblBEecf")).Text;
                txtHCO3.Text = ((Label)grdPhysical.Rows[id].FindControl("lblHCO3")).Text;
                txtTCO2.Text = ((Label)grdPhysical.Rows[id].FindControl("lblTCO2")).Text;
                txtsO2.Text = ((Label)grdPhysical.Rows[id].FindControl("lblsO2")).Text;
                txtNa.Text = ((Label)grdPhysical.Rows[id].FindControl("lblNa")).Text;
                txtK.Text = ((Label)grdPhysical.Rows[id].FindControl("lblK")).Text;
                txtiCa.Text = ((Label)grdPhysical.Rows[id].FindControl("lbliCa")).Text;
                txtGlumgdl.Text = ((Label)grdPhysical.Rows[id].FindControl("lblGlumgdl")).Text;
                txtHct.Text = ((Label)grdPhysical.Rows[id].FindControl("lblHct")).Text;
                txtHbgdl.Text = ((Label)grdPhysical.Rows[id].FindControl("lblHbgdl")).Text;
                txtDate.Text = ((Label)grdPhysical.Rows[id].FindControl("lblDate")).Text;
                ((TextBox)StartTime.FindControl("txtTime")).Text = Util.GetDateTime(((Label)grdPhysical.Rows[id].FindControl("lblTime")).Text).ToString("hh:mm tt"); 
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

            txtDate.Attributes.Add("readOnly", "true");
            if (!IsPostBack)
            {
                txtDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");

                //txtTime.Text = DateTime.Now.ToString("hh:mm tt"); ;

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

                BindDetails();
            }
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
            //if ((txtPUOILSLR.Text.Trim() == "") && (txtReactionLR.Text.Trim() == ""))
            //{
            //    lblMsg.Text = "Please Fill Mandatory fields";
            //    txtPUOILSLR.Focus();
            //    return false;
            //}
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
            //txtTime.Text = DateTime.Now.ToString("hh:mm tt"); 

            ((TextBox)StartTime.FindControl("txtTime")).Text = Util.GetDateTime(DateTime.Now).ToString("hh:mm tt");
            txtpH.Text = "";
            txtPCO2.Text = "";
            txtPO2.Text = "";
            txtBEecf.Text = "";
            txtHCO3.Text = "";
            txtTCO2.Text = "";
            txtsO2.Text = "";
            txtNa.Text = "";
            txtK.Text = "";
            txtiCa.Text = "";
            txtGlumgdl.Text = "";
            txtHct.Text = "";
            txtHbgdl.Text = "";
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
            sb.Append(" INSERT INTO `cardiac_bloodgaschart` (    `Date`,  `Time`,  `pH`,  `PCO2`,  `PO2`,  `BEecf`,  `HCO3`,  `TCO2`,  `sO2`,  `Na`,  `K`,  `iCa`,  `Glumgdl`,  `Hct`,  `Hbgdl`,`EntryBy`,`PatientId`)" +
" VALUES  (   '" + Util.GetDateTime(txtDate.Text.Trim()).ToString("yyyy-MM-dd") + "',    '" + Util.GetDateTime(((TextBox)StartTime.FindControl("txtTime")).Text).ToString("HH:mm:ss") + "',    '" + txtpH.Text + "',    '" + txtPCO2.Text +
"',    '" + txtPO2.Text + "',    '" + txtBEecf.Text + "',    '" + txtHCO3.Text + "',    '" + txtTCO2.Text + "',    '" + txtsO2.Text + "',    '" + txtNa.Text + "',    '" + txtK.Text + "',    '" + txtiCa.Text + "',    '" + txtGlumgdl.Text + "',    '" + txtHct.Text + "',    '" + txtHbgdl.Text + "' ,'" + Session["ID"].ToString() + "','" + ViewState["PID"] + "'  );");
            int result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

           
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