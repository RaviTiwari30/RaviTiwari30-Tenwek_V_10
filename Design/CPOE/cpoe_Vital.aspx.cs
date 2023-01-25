using System;
using System.Data;
using System.Text;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Web.Services;

public partial class Design_CPOE_cpoe_Vital : System.Web.UI.Page
{
    public void BindDetails()
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("   SELECT cv.*, ");
            sb.Append("   IF(IFNULL(HTType,'CM')='CM',CONCAT(HT,'/',ROUND(Ht*0.393701,2)),CONCAT(ROUND(HT*2.54,2),'/',HT))HHTType, ");
            sb.Append("   IF(IFNULL(WTType,'KG')='KG',CONCAT(WT,'/',ROUND(WT*2.20462,2)),CONCAT(ROUND(WT/2.20462,2),'/',WT))WWTType, ");
            sb.Append("   IF(IFNULL(TType,'C')='C',CONCAT(T,'/',ROUND(((T * 9/5) + 32) ,2)),CONCAT(ROUND(((T-32)* 5/9)),'/',T))TTType, ");
            sb.Append("   IF(cv.`EntryDate`>=DATE_ADD(NOW(),INTERVAL -2 HOUR),1,0)CanViewStatus, ");
            sb.Append("   pm.Pname,em.name Username,ifnull(cv.GCS,'')GCS,ifnull(cv.CIWA,'')CIWA FROM Cpoe_Vital cv");
            sb.Append("   INNER JOIN patient_master pm ON pm.PatientID=cv.PatientID");
            sb.Append("   INNER JOIN employee_master em ON em.EmployeeID=cv.EntryBy");
            sb.Append("   WHERE cv.TransactionID='" + ViewState["TID"] + "' ORDER BY cv.EntryDate DESC;");
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
            if (SaveData() != string.Empty)
            {
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
        try
        {
           
            StringBuilder sb = new StringBuilder();
            sb.Append(" UPDATE cpoe_vital SET BP = '" + txtBp.Text + "',P = '" + txtP.Text + "',R = '" + txtR.Text + "',T = '" + txtT.Text + "',HT = '" + txtHt.Text + "', ");
            sb.Append(" WT = '" + txtWt.Text + "',ArmSpan = '" + txtArmSpan.Text + "',SHight = '" + txtSittingHeight.Text + "',BMI = '" + Util.GetDecimal(txtBMI.Text) + "',BSA = '" + Util.GetDecimal(txtBSA.Text) + "', ");
            sb.Append(" IBWKg = '" + Util.GetDecimal(txtIBW.Text) + "',SPO2 = '" + Util.GetDecimal(txtSPO2.Text) + "',BF = '" + Util.GetDecimal(txtBF.Text) + "', ");
            sb.Append(" MUAC = '" + Util.GetDecimal(txtMuac.Text) + "',FBS = '" + Util.GetDecimal(txtFBS.Text) + "',tw='" + Util.GetDecimal(txtTw.Text) + "', ");
            sb.Append(" vf='" + Util.GetDecimal(txtVf.Text) + "',muscle='" + Util.GetDecimal(txtMuscle.Text) + "',rm='" + Util.GetDecimal(txtRm.Text) + "',CBG='" + txtCBG.Text.Trim() + "',PainScore='" + txtPainScore.Text.Trim() + "',Remarks='" + txtRemark.Text.Trim() + "',WTType='" + ddlWeightType.SelectedItem.Value + "',HTType='" + ddlHeightType.SelectedItem.Value + "',TType='" + ddltemperature.SelectedItem.Value + "',GCS='"+txtGCS.Text.Trim()+"',CIWA='"+txtCIWA.Text.Trim()+"' ");
            sb.Append("  WHERE ID = '" + lblID.Text + "' ");
           
           
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

                lblID.Text = ((Label)grdPhysical.Rows[id].FindControl("lblID")).Text;
                txtBp.Text = ((Label)grdPhysical.Rows[id].FindControl("lblBP")).Text;
                txtArmSpan.Text = ((Label)grdPhysical.Rows[id].FindControl("lblArmSpan")).Text;
                txtP.Text = ((Label)grdPhysical.Rows[id].FindControl("lblP")).Text;
                txtSittingHeight.Text = ((Label)grdPhysical.Rows[id].FindControl("lblSHeight")).Text;
                txtR.Text = ((Label)grdPhysical.Rows[id].FindControl("lblR")).Text;
                txtIBW.Text = ((Label)grdPhysical.Rows[id].FindControl("lblIBWKg")).Text;
                txtT.Text = ((Label)grdPhysical.Rows[id].FindControl("lblT")).Text;
                txtSPO2.Text = ((Label)grdPhysical.Rows[id].FindControl("lblSPO2")).Text;
                txtHt.Text = ((Label)grdPhysical.Rows[id].FindControl("lblHT")).Text;
                txtBF.Text = ((Label)grdPhysical.Rows[id].FindControl("lblBF")).Text;
                txtWt.Text = ((Label)grdPhysical.Rows[id].FindControl("lblWT")).Text;
                txtMuac.Text = ((Label)grdPhysical.Rows[id].FindControl("lblMUAC")).Text;
                txtFBS.Text = ((Label)grdPhysical.Rows[id].FindControl("lblFBS")).Text;
                txtTw.Text = ((Label)grdPhysical.Rows[id].FindControl("lbltw")).Text;
                txtVf.Text = ((Label)grdPhysical.Rows[id].FindControl("lblvf")).Text;
                txtMuscle.Text = ((Label)grdPhysical.Rows[id].FindControl("lblmuscle")).Text;
                txtRm.Text = ((Label)grdPhysical.Rows[id].FindControl("lblrm")).Text;
                txtWFA.Text = ((Label)grdPhysical.Rows[id].FindControl("lblWFA")).Text;
                txtBMIFA.Text = ((Label)grdPhysical.Rows[id].FindControl("lblBMIFA")).Text;
                txtCBG.Text = ((Label)grdPhysical.Rows[id].FindControl("lblCBG")).Text;
                txtPainScore.Text = ((Label)grdPhysical.Rows[id].FindControl("lblPainScore")).Text;
                txtRemark.Text = ((Label)grdPhysical.Rows[id].FindControl("lblRemarks")).Text;
                ddltemperature.SelectedIndex=ddltemperature.Items.IndexOf(ddltemperature.Items.FindByValue(((Label)grdPhysical.Rows[id].FindControl("lblTType")).Text));
                ddlHeightType.SelectedIndex = ddlHeightType.Items.IndexOf(ddlHeightType.Items.FindByValue(((Label)grdPhysical.Rows[id].FindControl("lblHTType")).Text));
                ddlWeightType.SelectedIndex = ddlWeightType.Items.IndexOf(ddlWeightType.Items.FindByValue(((Label)grdPhysical.Rows[id].FindControl("lblWTType")).Text));
                txtGCS.Text = ((Label)grdPhysical.Rows[id].FindControl("lblGCS")).Text;
                txtCIWA.Text = ((Label)grdPhysical.Rows[id].FindControl("lblCIWA")).Text;

               
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
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                if (((Label)e.Row.FindControl("lblUserID")).Text != Session["ID"].ToString() || Util.GetDateTime(((Label)e.Row.FindControl("lblEntryDate")).Text).ToString("dd-MMM-yyyy") != Util.GetDateTime(System.DateTime.Now).ToString("dd-MMM-yyyy"))
                {
                    ((ImageButton)e.Row.FindControl("imgbtnEdit")).Enabled = false;
                }
            }
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
                if (Request.QueryString["App_ID"] != null)
                {
                    ViewState["appointmentID"] = Convert.ToString(Request.QueryString["App_ID"]);
                }
                else
                {
                    ViewState["appointmentID"] = "0";
                }
                if (Request.QueryString["TransactionID"] == null)
                {
                    ViewState["TID"] = Request.QueryString["TID"].ToString();
                    ViewState["PID"] = Request.QueryString["PID"].ToString();
                }
                else
                {
                    ViewState["TID"] = Request.QueryString["TransactionID"].ToString();
                    ViewState["PID"] = Request.QueryString["PatientID"].ToString();
                }
                ViewState["UserID"] = Session["ID"].ToString();
                if (Request.QueryString["IsViewable"] == null)
                {
                    //bool IsDone = Util.GetBoolean(Request.QueryString["IsEdit"]);
                    string IsDone = StockReports.ExecuteScalar(" select flag from Appointment where App_ID='" + Util.GetInt(Request.QueryString["App_ID"]) + "' ");
                    string msg = "File Has Been Closed...";
                    if (IsDone == "1")
                    {
                        Response.Redirect("NotAuthorized.aspx?msg=" + msg, false);
                        Context.ApplicationInstance.CompleteRequest();
                    }
                }
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
            if ((txtBp.Text.Trim() == "") && (txtP.Text.Trim() == "") && (txtR.Text.Trim() == "") && (txtT.Text.Trim() == "") && (txtHt.Text.Trim() == "") && (txtWt.Text.Trim() == "") && (txtArmSpan.Text.Trim() == "") && (txtSittingHeight.Text.Trim() == "") && (txtIBW.Text.Trim() == ""))
            {
                lblMsg.Text = "Please Enter Pulse";
                txtP.Focus();
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
            lblID.Text = "";
            txtBp.Text = "";
            txtArmSpan.Text = "";
            txtFBS.Text = "";
            txtBMIFA.Text = "";
            txtP.Text = "";
            txtSittingHeight.Text = "";
            txtR.Text = "";
            txtTw.Text = "";
            txtIBW.Text = "";
            txtVf.Text = "";
            txtT.Text = "";
            txtSPO2.Text = "";
            txtMuscle.Text = "";
            txtHt.Text = "";
            txtBF.Text = "";
            txtRm.Text = "";
            txtWt.Text = "";
            txtMuac.Text = "";
            txtFBS.Text = "";
            txtWFA.Text = "";
            txtPainScore.Text = "";
            txtRemark.Text = "";
			txtCBG.Text ="";
            btnUpdate.Visible = false;
            btnSave.Visible = true;
            txtGCS.Text = "";
            txtCIWA.Text = "";
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
        try
        {
             if (Request.QueryString["App_ID"]==null)
             {
              Request.QueryString["App_ID"]="0";
             }
            
            StringBuilder sb = new StringBuilder();
            sb.Append(" Insert into cpoe_vital (TransactionID,PatientID,BP,P,R,T,HT,WT,ArmSpan,SHight,BMI,IBWKg,SPO2, ");
            sb.Append(" BF,MUAC,FBS,EntryBy,tw,vf,muscle,rm,WFA,BMIFA,CentreID,Hospital_ID,App_ID,CBG,PainScore,Remarks,WTType,HTType,TType,GCS,CIWA,BSA) values ('" + ViewState["TID"] + "', ");
            sb.Append(" '" + ViewState["PID"] + "','" + txtBp.Text.Trim().ToString() + "','" + txtP.Text.Trim().ToString() + "','" + txtR.Text.Trim().ToString() + "','" + txtT.Text.Trim().ToString() + "','" + txtHt.Text.Trim().ToString() + "','" + txtWt.Text.Trim().ToString() + "','" + txtArmSpan.Text.Trim() + "','" + txtSittingHeight.Text.Trim() + "','" + Util.GetDecimal(txtBMI.Text) + "','" + Util.GetDecimal(txtIBW.Text) + "','" + Util.GetDecimal(txtSPO2.Text) + "', ");
            sb.Append(" '" + Util.GetDecimal(txtBF.Text) + "','" + Util.GetDecimal(txtMuac.Text) + "', ");
            sb.Append(" '" + Util.GetDecimal(txtFBS.Text) + "','" + ViewState["UserID"] + "', '" + Util.GetDecimal(txtTw.Text) + "','" + Util.GetDecimal(txtVf.Text) + "', ");
            sb.Append(" '" + Util.GetDecimal(txtMuscle.Text) + "','" + Util.GetDecimal(txtRm.Text) + "','" + Util.GetDecimal(txtWFA.Text) + "', ");
            sb.Append(" '" + Util.GetDecimal(txtBMIFA.Text) + "','" + Util.GetInt(Session["centreID"].ToString()) + "','" + Session["HOSPID"].ToString() + "'," + Util.GetInt(Request.QueryString["App_ID"]) + ",'" + txtCBG.Text.Trim() + "','" + txtPainScore.Text.Trim() + "','" + txtRemark.Text.Trim() + "','" + ddlWeightType.SelectedItem.Value + "','" + ddlHeightType.SelectedItem.Value + "','" + ddltemperature.SelectedItem.Value + "','" + txtGCS.Text.Trim() + "','" + txtCIWA.Text.Trim() + "'," + Util.GetDecimal(txtBSA.Text) + " )");

            int result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

            //Insert Viewed Tab Info
            AllQuery.UpdateDoctorTab_Information(ViewState["TID"].ToString(), Util.GetInt(Request.QueryString["MenuID"]));

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
    [WebMethod(EnableSession = true)]
    public static string bindMandtoryVitial(string deptid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT c.VitialSiginTextID,IF(IFNULL(d.IsMandtory,0)=0,'0','1')isRequired,IFNULL(c.ErrorMessage,'')ErrorMessage ");
        sb.Append(" FROM cpoe_VitalExaminationMandtoryMaster c ");
        sb.Append(" LEFT JOIN DoctorDepartmentwiseVitialSign d ON c.VitialID=d.VitialID AND d.IsMandtory=1 AND  d.DepartmentID='"+deptid+"'");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        
        
    }
}