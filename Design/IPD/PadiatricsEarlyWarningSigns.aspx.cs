
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.Services;
using System.Linq;
using MySql.Data.MySqlClient;
using System.Text;

using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Script;


public partial class Design_IPD_PadiatricsEarlyWarningSigns : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtTime.Text = DateTime.Now.ToString("hh:mm tt");
            
            //txtEndDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            //txtEndTime.Text = DateTime.Now.ToString("hh:mm tt");
            ViewState["PID"] = Request.QueryString["PID"].ToString();
            ViewState["TID"] = Request.QueryString["TID"].ToString();

            BindDetails(ViewState["PID"].ToString(), ViewState["TID"].ToString());
        }
        string entryby = StockReports.ExecuteScalar("SELECT Name 	FROM 	employee_master  WHERE  EmployeeId='"+Session["ID"].ToString()+"' LIMIT 0, 1");
        txtDate.Enabled = false;
        txtTime.Enabled = false;
        txtTotalScore.Attributes.Add("readonly", "readonly");
        //txtTotal.Enabled = false;
        //txtCreatedBy.Text = entryby;

        //txtCreatedBy.Enabled = false;
    }
    
    protected void grdPhysical_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
                  }
    }
    
    protected void grdPhysical_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Print")
        {
            lblMsg.Text = "";
            int id = Convert.ToInt16(e.CommandArgument.ToString());
                string ID1 = ((Label)grdPhysical.Rows[id].FindControl("lblID1")).Text;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", " window.open('./PadiatricsEarlyWarningSigns_PDF.aspx?TestID=O23&LabType=&LabreportType=11&ID=" + ID1 + "&TID=" + ViewState["TID"].ToString() + "');", true);

            
        }
        if (e.CommandName == "Change")
        {
            lblMsg.Text = "";
            int id = Convert.ToInt16(e.CommandArgument.ToString());
            decimal createdDateDiff = Util.GetDecimal(((Label)grdPhysical.Rows[id].FindControl("lblTimeDiff")).Text);
            if (((Label)grdPhysical.Rows[id].FindControl("lblUserID")).Text == Session["ID"].ToString() && createdDateDiff < Util.GetDecimal(Resources.Resource.EditTimePeriod))
            {
                lblID.Text = ((Label)grdPhysical.Rows[id].FindControl("lblID")).Text;
                txtDate.Text = ((Label)grdPhysical.Rows[id].FindControl("lblDate")).Text;
                txtTime.Text = ((Label)grdPhysical.Rows[id].FindControl("lblTime")).Text;
                txtBehaviour.Text = ((Label)grdPhysical.Rows[id].FindControl("lblBehaviour")).Text;
                txtCardiovascular.Text = ((Label)grdPhysical.Rows[id].FindControl("lblCardiovascular")).Text;
                txtRespiratory.Text = ((Label)grdPhysical.Rows[id].FindControl("lblRespiratory")).Text;
                txtOutput.Text = ((Label)grdPhysical.Rows[id].FindControl("lblOutput")).Text;
                txtTotalScore.Text = ((Label)grdPhysical.Rows[id].FindControl("lblTotalScore1")).Text;
                txtAction.Text = ((Label)grdPhysical.Rows[id].FindControl("lblAction")).Text;
                btnUpdate.Visible = true;
                btnSave.Visible = false;
                btnCancel.Visible = true;
            }
            else
            {
                ((ImageButton)grdPhysical.Rows[id].FindControl("imgbtnEdit")).Enabled = false;
                lblMsg.Text = "You are not able to Edit this Detail after 12 hrs";
            }

        }
        
    }
    
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindData(string PID, string TID)
    {
        string retn = "";
        StringBuilder sb = new StringBuilder();
        sb.Append("Select *,DATE_FORMAT(FPDate, '%d %b %Y') as Date1,TIME_FORMAT(FPTime, '%h:%i %p') as FPTime1,DATE_FORMAT(Date, '%d %b %Y') as Date1,TIME_FORMAT(Time, '%h:%i %p') as Time1,TIMESTAMPDIFF(MINUTE,CreatedDate,NOW()) Enabled from inpatientfallsassessmentandprecautiontool,IF( SuperVision1='1','Yes','No') SuperVision11," +
"  IF( SuperVision2='1','Yes','No') SuperVision21 , IF( SuperVision3='1','Yes','No') SuperVision31,  IF( PatientRoom1='1','Yes','No') PatientRoom11 ,  IF( PatientRoom2='1','Yes','No') PatientRoom21,  IF( PatientRoom3='1','Yes','No') PatientRoom31,  IF( PatientRoom4='1','Yes','No') PatientRoom41,  IF( PatientRoom5='1','Yes','No') PatientRoom51,  IF( PatientRoom6='1','Yes','No') PatientRoom61,  IF( HRPS1='1','Yes','No') HRPS11,  IF( HRPS2='1','Yes','No') HRPS21,  IF( HRPS3='1','Yes','No') HRPS31,  IF( PatientAndFamily1='1','Yes','No') PatientAndFamily11,  IF( PatientAndFamily2='1','Yes','No') PatientAndFamily21,  IF( PatientAndFamily3='1','Yes','No') PatientAndFamily31, where PatientID='" + PID + "' and TransactionID='" + TID + "' order by ID desc limit 1");
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            retn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            return retn;
        }
        else
        {
            return retn;
        }
    }
    public void BindDetails(string PID,string TID)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" Select *,(Select concat(title,' ',name) from Employee_master where EmployeeID=CreatedBy)EmpName,DATE_FORMAT(Date, '%d %b %Y') as Date1,TIME_FORMAT(Time, '%h:%i %p') as Time1,TIMESTAMPDIFF(MINUTE,CreatedDate,NOW()) createdDateDiff  from padiatricsearlywarningsigns where PatientID='" + PID + "' and TransactionID='" + TID + "' order by ID desc ");
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



    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var message = "";
            string date = Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd");
            string time = Util.GetDateTime(txtTime.Text).ToString("HH:mm");
            var sqlCMD = "INSERT INTO `padiatricsearlywarningsigns` ("+
  
 " `Date`,  `Behaviour`,  `Cardiovascular`,  `Respiratory`,  `Output`,  `TotalScore`,  `Action`,  `CreatedBy`,  `CreatedDate`,  `PatientID`,  `TransactionID`,  `Time`)"+
" VALUES  ( "+  
  "  @Date,    @Behaviour,    @Cardiovascular,    @Respiratory,    @Output,    @TotalScore,    @Action,    @CreatedBy,    NOW(),    @PatientID,    @TransactionID,    @Time  );";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    Date = date,
                    Time = time,
                    Behaviour = txtBehaviour.Text,
                    Cardiovascular = txtCardiovascular.Text,
                    Respiratory = txtRespiratory.Text,
                    Output = txtOutput.Text,
                    TotalScore = txtTotalScore.Text,
                    Action = txtAction.Text,
                    CreatedBy = HttpContext.Current.Session["ID"].ToString(),
                    PatientID = ViewState["PID"].ToString(),
                    TransactionID = ViewState["TID"].ToString()
                });
            message = "Record Save Sucessfully";
            Clear();

            tnx.Commit();
            BindDetails(ViewState["PID"].ToString(), ViewState["TID"].ToString());
            lblMsg.Text = message;
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", " modelAlert('"+message+"',function(){});", true);

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);

            lblMsg.Text = "Error occurred, Please contact Administrator";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
    private void Clear()
    {

                    txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
                    txtTime.Text = DateTime.Now.ToString("hh:mm tt");
                    txtBehaviour.Text = "";
                    txtCardiovascular.Text = "";
                    txtRespiratory.Text = "";
                    txtOutput.Text = "";
                    txtTotalScore.Text = "";
                    txtAction.Text = "";
                              
    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var message = "";

            string date = Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd");
            string time = Util.GetDateTime(txtTime.Text).ToString("HH:mm");
            var sqlCMD = "UPDATE padiatricsearlywarningsigns SET UpdateDate=NOW(),UpdatedBy=@UpdatedBy," +
                "Behaviour=@Behaviour,Cardiovascular=@Cardiovascular,Respiratory=@Respiratory,Output=@Output,TotalScore=@TotalScore,Action=@Action" +
                " WHERE ID=@ID;";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {

                    
                    UpdatedBy = HttpContext.Current.Session["ID"].ToString(),
                    Behaviour = txtBehaviour.Text,
                    Cardiovascular = txtCardiovascular.Text,
                    Respiratory = txtRespiratory.Text,
                    Output = txtOutput.Text,
                    TotalScore = txtTotalScore.Text,
                    Action = txtAction.Text,
                    ID = Util.GetString(lblID.Text)
                     });
                message = "Record Update Successfully";
                Clear();
                btnUpdate.Visible = false;
                btnSave.Visible = true;    
                tnx.Commit();

                BindDetails(ViewState["PID"].ToString(), ViewState["TID"].ToString());
            lblMsg.Text = message;
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            lblMsg.Text = "Error occurred, Please contact Administrator";
           }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
    }
}