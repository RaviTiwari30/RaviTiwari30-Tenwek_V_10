
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


public partial class Design_IPD_ColonoscopyForm : System.Web.UI.Page
{
    protected void Radio1_Changed(object sender, EventArgs e)
    {
        if (rdbEyeOpening.SelectedIndex > 0)
        {
            lblEyeOpening1.Text = rdbEyeOpening.SelectedItem.Value;
        }
    }
    protected void Radio2_Changed(object sender, EventArgs e)
    {

        if (rdbVerbalAdult.SelectedIndex > 0)
        {
            lblVerbalAdult1.Text = rdbVerbalAdult.SelectedItem.Value;
        }
    }
    protected void Radio3_Changed(object sender, EventArgs e)
    {

        if (rdbBestMotorResponse.SelectedIndex > 0)
        {
            lblBestMotorResponse1.Text = rdbBestMotorResponse.SelectedItem.Value;
        }
    }
    private void FillClientDetails(string PID, string TID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" Select *,DATE_FORMAT(DOB, '%d %b %Y') as DOB1 from patient_master where PatientID='" + PID + "'");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {

            if (dt.Rows[0]["PFirstName"].ToString() != "")
            {
                lblFirstName.Text = dt.Rows[0]["PFirstName"].ToString();
            }
            if (dt.Rows[0]["PLastName"].ToString() != "")
            {
               lblSurName.Text = dt.Rows[0]["PLastName"].ToString();
            }

            if (dt.Rows[0]["Age"].ToString() != "")
            {
                lblAge.Text = dt.Rows[0]["Age"].ToString();
            }
            if (dt.Rows[0]["Gender"].ToString() != "")
            {
                lblSex.Text = dt.Rows[0]["Gender"].ToString();
            }
            
            if (dt.Rows[0]["Mobile"].ToString() != "")
            {
                lblPhone.Text = dt.Rows[0]["Mobile"].ToString();
            }
            if (dt.Rows[0]["SecondMobileNo"].ToString() != "")
            {
                lblAlternative.Text = dt.Rows[0]["SecondMobileNo"].ToString();
            }
            if (dt.Rows[0]["state"].ToString() != "")
            {
                lblCounty.Text = dt.Rows[0]["state"].ToString();
                //+" " + dt.Rows[0]["Locality"].ToString() + " " + dt.Rows[0]["City"].ToString() + " " + dt.Rows[0]["Pincode"].ToString() + " ";
            }
            if (dt.Rows[0]["Taluka"].ToString() != "")
            {
                lblVillage.Text = dt.Rows[0]["Taluka"].ToString();
                //+" " + dt.Rows[0]["Locality"].ToString() + " " + dt.Rows[0]["City"].ToString() + " " + dt.Rows[0]["Pincode"].ToString() + " ";
            }
            if (dt.Rows[0]["Locality"].ToString() != "")
            {
                lblLocation.Text = dt.Rows[0]["Locality"].ToString();
                //+" " + dt.Rows[0]["Locality"].ToString() + " " + dt.Rows[0]["City"].ToString() + " " + dt.Rows[0]["Pincode"].ToString() + " ";
            }
        }
       


    }
    private void FillHeight()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("   SELECT cv.*, ");
        sb.Append("   IF(IFNULL(HTType,'CM')='CM',CONCAT(HT,'/',ROUND(Ht*0.393701,2)),CONCAT(ROUND(HT*2.54,2),'/',HT))HHTType, ");
        sb.Append("   IF(IFNULL(WTType,'KG')='KG',CONCAT(WT,'/',ROUND(WT*2.20462,2)),CONCAT(ROUND(WT/2.20462,2),'/',WT))WWTType, ");
        sb.Append("   IF(IFNULL(TType,'C')='C',CONCAT(T,'/',ROUND(((T * 9/5) + 32) ,2)),CONCAT(ROUND(((T-32)* 5/9)),'/',T))TTType, ");

        sb.Append("   pm.Pname,em.name Username FROM Cpoe_Vital cv");
        sb.Append("   INNER JOIN patient_master pm ON pm.PatientID=cv.PatientID");
        sb.Append("   INNER JOIN employee_master em ON em.EmployeeID=cv.EntryBy");
        sb.Append("   WHERE cv.TransactionID='" + ViewState["TID"] + "' ORDER BY cv.EntryDate DESC;");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            txtHeight.Text = dt.Rows[0]["HHTType"].ToString();
            txtWeight.Text = dt.Rows[0]["WWTType"].ToString();
            lblBMI.Text = dt.Rows[0]["BMI"].ToString();
        }
            
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtTime.Text = DateTime.Now.ToString("hh:mm tt");
            ViewState["PID"] = Request.QueryString["PID"].ToString();
            ViewState["TID"] = Request.QueryString["TID"].ToString();

            BindDetails(ViewState["PID"].ToString(), ViewState["TID"].ToString());
        }
        string entryby = StockReports.ExecuteScalar("SELECT Name 	FROM 	employee_master  WHERE  EmployeeId='"+Session["ID"].ToString()+"' LIMIT 0, 1");
        txtDate.Enabled = false;
        txtTime.Enabled = false;
        txtReportBy.Text = entryby;
        FillClientDetails(ViewState["PID"].ToString(), ViewState["TID"].ToString());
        FillHeight();
        //txtPersonInserting.Text = entryby;
        //txtTotal.Enabled = false;
        //txtAssessmentBy.Text = entryby;
    }
    protected void grdPhysical_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        //if (e.Row.RowType == DataControlRowType.DataRow)
        //{
        //    decimal createdDateDiff = Util.GetDecimal(((Label)e.Row.FindControl("lblTimeDiff")).Text);
        //    if (((Label)e.Row.FindControl("lblCreatedID")).Text != Session["ID"].ToString())
        //    {
        //        ((ImageButton)e.Row.FindControl("imgbtnEdit")).Enabled = false;
        //    }
        //    else
        //    {
        //        ((ImageButton)e.Row.FindControl("imgbtnEdit")).Enabled = true;
        //    }
        //}
    }
    
    protected void grdPhysical_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Print")
        {
            lblMsg.Text = "";
            int id = Convert.ToInt16(e.CommandArgument.ToString());
                string ID1 = ((Label)grdPhysical.Rows[id].FindControl("lblID1")).Text;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", " window.open('./ColonoscopyForm_PDF.aspx?TestID=O23&LabType=&LabreportType=11&ID=" + ID1 + "&TID=" + ViewState["TID"].ToString() + "');", true);

            
        }
        if (e.CommandName == "Change")
        {
            lblMsg.Text = "";
            int id = Convert.ToInt16(e.CommandArgument.ToString());
            decimal createdDateDiff = Util.GetDecimal(((Label)grdPhysical.Rows[id].FindControl("lblTimeDiff")).Text);
            if ( createdDateDiff < Util.GetDecimal(Resources.Resource.EditTimePeriod))
            {
                lblID.Text = ((Label)grdPhysical.Rows[id].FindControl("lblID")).Text;
                txtDate.Text = ((Label)grdPhysical.Rows[id].FindControl("lblDate")).Text;
                txtTime.Text = ((Label)grdPhysical.Rows[id].FindControl("lblTime")).Text;
                //rdbBestMotorResponse.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblBestMotorResponse")).Text;


                txtTribe.Text = ((Label)grdPhysical.Rows[id].FindControl("lblTribe")).Text;
                txtChief.Text = ((Label)grdPhysical.Rows[id].FindControl("lblChief")).Text;
                txtSymptoms.Text = ((Label)grdPhysical.Rows[id].FindControl("lblSymptoms")).Text;
                txtHeight.Text = ((Label)grdPhysical.Rows[id].FindControl("lblHeight")).Text;
                txtWeight.Text = ((Label)grdPhysical.Rows[id].FindControl("lblWeight")).Text;
                lblBMI.Text = ((Label)grdPhysical.Rows[id].FindControl("lblBMI")).Text;
                txtHematochezia.Text = ((Label)grdPhysical.Rows[id].FindControl("lblHematochezia")).Text;
                txtAnemia.Text = ((Label)grdPhysical.Rows[id].FindControl("lblAnemia")).Text;
                txtConstipation.Text = ((Label)grdPhysical.Rows[id].FindControl("lblConstipation")).Text;
                txtAbdPain.Text = ((Label)grdPhysical.Rows[id].FindControl("lblAbdPain")).Text;
                txtWeightLoss.Text = ((Label)grdPhysical.Rows[id].FindControl("lblWeightLoss")).Text;
                txtOther.Text = ((Label)grdPhysical.Rows[id].FindControl("lblOther")).Text;
                txtDuration.Text = ((Label)grdPhysical.Rows[id].FindControl("lblDuration")).Text;
                txtWHO.Text = ((Label)grdPhysical.Rows[id].FindControl("lblWHO")).Text;
                ddlOtherCancer.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblOtherCancer")).Text;
                txtPersonAge2.Text = ((Label)grdPhysical.Rows[id].FindControl("lblPersonAge")).Text;
                ddlSmoking.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblSmoking")).Text;
                txtSmokingHistory.Text = ((Label)grdPhysical.Rows[id].FindControl("lblSmokingDetail")).Text;
                ddlAlcohol.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblAlcohol")).Text;
                txtAlcohol.Text = ((Label)grdPhysical.Rows[id].FindControl("lblAlcoholDetail")).Text;
                txtAdditionalHistory.Text = ((Label)grdPhysical.Rows[id].FindControl("lblAdditional")).Text;
                txtPreparationQuality.Text = ((Label)grdPhysical.Rows[id].FindControl("lblPreparation")).Text;
                txtExtent.Text = ((Label)grdPhysical.Rows[id].FindControl("lblExtent")).Text;
                txtAnus.Text = ((Label)grdPhysical.Rows[id].FindControl("lblAnus")).Text;
                txtSigmoid.Text = ((Label)grdPhysical.Rows[id].FindControl("lblSigmoid")).Text;
                txtDescending.Text = ((Label)grdPhysical.Rows[id].FindControl("lblDescending")).Text;
                txtTraverse.Text = ((Label)grdPhysical.Rows[id].FindControl("lblTraverse")).Text;
                txtAscending.Text = ((Label)grdPhysical.Rows[id].FindControl("lblAscending")).Text;
                txtIleum.Text = ((Label)grdPhysical.Rows[id].FindControl("lblIleum")).Text;
                ddlSedation.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblSedation")).Text;
                txtVersed.Text = ((Label)grdPhysical.Rows[id].FindControl("lblVersed")).Text;
                txtFentany.Text = ((Label)grdPhysical.Rows[id].FindControl("lblFentany")).Text;
                txtKatamine.Text = ((Label)grdPhysical.Rows[id].FindControl("lblKetamine")).Text;
                txtOxygen.Text = ((Label)grdPhysical.Rows[id].FindControl("lblOxygen")).Text;
                txtOther.Text = ((Label)grdPhysical.Rows[id].FindControl("lblOther2")).Text;
                txtImages.Text = ((Label)grdPhysical.Rows[id].FindControl("lblImages")).Text;
                txtEndoscopyIntervention.Text = ((Label)grdPhysical.Rows[id].FindControl("lblEndoscopy")).Text;
                txtRecommendations.Text = ((Label)grdPhysical.Rows[id].FindControl("lblRecommendations")).Text;
                txtFollowUpDate.Text = ((Label)grdPhysical.Rows[id].FindControl("lblFollowUpDate")).Text;
                txtReportBy.Text = ((Label)grdPhysical.Rows[id].FindControl("lblReportBy")).Text;
                txtProcedure.Text = ((Label)grdPhysical.Rows[id].FindControl("lblProcedure")).Text;
                txtImpression.Text = ((Label)grdPhysical.Rows[id].FindControl("lblImpression")).Text;
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
        sb.Append("Select *,DATE_FORMAT(Date, '%d %b %Y') as Date1,TIME_FORMAT(Time, '%h:%i %p') as Time1,TIMESTAMPDIFF(MINUTE,CreatedDate,NOW()) Enabled from painmanagementtoolneonatal where PatientID='" + PID + "' and TransactionID='" + TID + "' order by ID desc limit 1");
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
            sb.Append(" Select *,(Select concat(title,' ',name) from Employee_master where EmployeeID=CreatedBy)EmpName,(Select concat(title,' ',name) from Employee_master where EmployeeID=ReportBy)ReportBy1,DATE_FORMAT(FollowUpDate, '%d %b %Y') as FollowUpDate1,DATE_FORMAT(Date, '%d %b %Y') as Date1,TIME_FORMAT(Time, '%h:%i %p') as Time1,TIMESTAMPDIFF(MINUTE,CreatedDate,NOW()) createdDateDiff from colonoscopyform where PatientID='" + PID + "' and TransactionID='" + TID + "' order by ID desc ");
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


    [WebMethod(EnableSession = true)]

    public static string SaveData(string TransactionID, string PatientID, string Date, string Time, string InsertedBy, string Location, string LeftCatheterGauge, string Reason, string CleanedWith, string InsertionEase, string ComplianceLevel, string Appearence, string FlushedWith, string CheckedBy, string SaveType, string ID,string Impression)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var message = "";
            string date = Util.GetDateTime(Date).ToString("yyyy-MM-dd");
            string time = Util.GetDateTime(Time).ToString("HH:mm");
            if (SaveType == "Save")
            {

                var sqlCMD = "INSERT INTO `peripheralvenouscatheterinsertionchecklist` ( CreatedBy,CreatedDate, `Date`,  `Time`,  `InsertedBy`,  `Location`,  `LeftCatheterGauge`,  `Reason`,  `CatheterSiteCleanedWith`,  `InsertionEase`,  `ComplianceLevel`,  `Appearence`,  `FlushedWith`,  `CheckedBy`,PatientID,TransactionID,Impression) " +
" VALUES  (     @CreatedBy,NOW(),    @Date,   @Time,    @InsertedBy,    @Location,    @LeftCatheterGauge,    @Reason,    @CatheterSiteCleanedWith,    @InsertionEase,    @ComplianceLevel,    @Appearence,    @FlushedWith,    @CheckedBy ,@PatientID,@TransactionID,@Impression );";       
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    CreatedBy = HttpContext.Current.Session["ID"].ToString(),
                    Date = date,
                    Time = time,
                    InsertedBy = InsertedBy,
                    Location = Location,
                    LeftCatheterGauge = LeftCatheterGauge,
                    Reason=Reason,
                    CatheterSiteCleanedWith = CleanedWith,
                    InsertionEase = InsertionEase,
                    ComplianceLevel=ComplianceLevel,
                    Appearence=Appearence,
                    FlushedWith=FlushedWith,
                    CheckedBy = HttpContext.Current.Session["ID"].ToString(),
                    PatientID=PatientID,
                    TransactionID=TransactionID,
                    Impression = Impression

                });
                message = "Record Save Sucessfully";
            }
            else
            {
                var sqlCMD = "UPDATE peripheralvenouscatheterinsertionchecklist SET Date=@Date,Time=@Time,UpdatedDate=NOW(),UpdatedBy=@UpdatedBy,Location=@Location,LeftCatheterGauge=@LeftCatheterGauge,Reason=@Reason,CatheterSiteCleanedWith=@CatheterSiteCleanedWith,InsertionEase=@InsertionEase,ComplianceLevel=@ComplianceLevel,Appearence=@Appearence,FlushedWith=@FlushedWith,CheckedBy=@CheckedBy WHERE ID=@ID;";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                   UpdatedBy = HttpContext.Current.Session["ID"].ToString(),
                    Date = date,
                    Time = time,
                    InsertedBy = InsertedBy,
                    Location = Location,
                    LeftCatheterGauge = LeftCatheterGauge,
                    Reason=Reason,
                    CatheterSiteCleanedWith = CleanedWith,
                    InsertionEase = InsertionEase,
                    ComplianceLevel=ComplianceLevel,
                    Appearence=Appearence,
                    FlushedWith=FlushedWith,
                    CheckedBy=CheckedBy,
                   //ID = Util.GetInt(lblID.Text)
                    

                });
                message = "Record Update Successfully";
            }

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
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
         MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var message = "";
            string date = Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd");
            string time = Util.GetDateTime(txtTime.Text).ToString("HH:mm");
            //string LastEGDDate = Util.GetDateTime(txtLastEGDDate.Text).ToString("yyyy-MM-dd");
            string FollowUpDate = Util.GetDateTime(txtFollowUpDate.Text).ToString("yyyy-MM-dd");
           
            
                var sqlCMD = "INSERT INTO colonoscopyform ("+
  
 " Date,  Time,  Tribe,  Chief,  Symptoms,  Height,  Weight,  BMI,  Hematochezia,  Anemia,  Constipation,  AbdPain,  WeightLoss,  Other,  Duration,  WHO,  OtherCancer,  PersonAge,  Smoking,"+
"  SmokingDetail,  Alcohol,  AlcoholDetail,  Additional,  Preparation,  Extent,  Anus,  Sigmoid,  Descending,  Traverse,  Ascending,  Ileum,  Sedation,  Versed,  Fentany,  Katamine,  Oxygen,"+
"  Other2,  Images,  Endoscopy, Recommendations,  FollowUpDate,  ReportBy,  Procedure1,  CreatedBy, CreatedDate,  PatientID,  TransactionID,Impression)"+
" VALUES  (        @Date,    @Time,    @Tribe,    @Chief,    @Symptoms,    @Height,    @Weight,    @BMI,    @Hematochezia,    @Anemia,    @Constipation,    @AbdPain,    @WeightLoss,"+
"    @Other,    @Duration,    @WHO,    @OtherCancer,    @PersonAge,    @Smoking,    @SmokingDetail,    @Alcohol,    @AlcoholDetail,    @Additional,    @Preparation,    @Extent,"+
"    @Anus,   @Sigmoid,    @Descending,    @Traverse,    @Ascending,   @Ileum,    @Sedation,    @Versed,    @Fentany,    @Katamine,    @Oxygen,    @Other2,    @Images,    @Endoscopy,"+
"    @Recommendations,    @FollowUpDate,    @ReportBy,    @Procedure1,    @CreatedBy,    NOW(),      @PatientID,    @TransactionID,@Impression  );";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    Date = date,
                    Time = time,
                    Tribe = txtTribe.Text,
                    Chief = txtChief.Text,
                    Symptoms = txtSymptoms.Text,
                    Height = txtHeight.Text,
                    Weight = txtWeight.Text,
                    BMI = lblBMI.Text,
                    Hematochezia = txtHematochezia.Text,
                    Anemia = txtAnemia.Text,
                    Constipation = txtConstipation.Text,
                    AbdPain = txtAbdPain.Text,
                    WeightLoss = txtWeightLoss.Text,
                    Other = txtOther.Text,
                    Duration = txtDuration.Text,
                    WHO = txtWHO.Text,
                    OtherCancer = ddlOtherCancer.SelectedValue,
                    PersonAge = txtPersonAge2.Text,
                    Smoking = ddlSmoking.SelectedValue,
                    SmokingDetail = txtSmokingHistory.Text,
                    Alcohol = ddlAlcohol.SelectedValue,
                    AlcoholDetail = txtAlcohol.Text,
                    Additional = txtAdditionalHistory.Text,
                    Preparation = txtPreparationQuality.Text,
                    Extent = txtExtent.Text,

                    Anus = txtAnus.Text,
                    Sigmoid = txtSigmoid.Text,
                    Descending = txtDescending.Text,
                    Traverse = txtTraverse.Text,
                    Ascending = txtAscending.Text,
                    Ileum = txtIleum.Text,
                    Sedation = ddlSedation.SelectedValue,
                    Versed = txtVersed.Text,
                    Fentany = txtFentany.Text,
                    Katamine = txtKatamine.Text,
                    Oxygen = txtOxygen.Text,
                    Other2 = txtOther.Text,
                    Images = txtImages.Text,
                    Endoscopy = txtEndoscopyIntervention.Text,
                    Recommendations = txtRecommendations.Text,
                    FollowUpDate = FollowUpDate,
                    ReportBy = HttpContext.Current.Session["ID"].ToString(),
                    Procedure1 = txtProcedure.Text,
                    CreatedBy = HttpContext.Current.Session["ID"].ToString(),
                    PatientID = ViewState["PID"].ToString(),
                    TransactionID = ViewState["TID"].ToString(),
                    Impression=txtImpression.Text
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
                    txtTribe.Text = "";
                    txtChief.Text = "";
                    txtSymptoms.Text = "";
                    txtHeight.Text = "";
                    txtWeight.Text = "";
                    lblBMI.Text = "";
                    txtHematochezia.Text = "";
                    txtAnemia.Text = "";
                    txtConstipation.Text = "";
                    txtAbdPain.Text = "";
                    txtWeightLoss.Text = "";
                    txtOther.Text = "";
                    txtDuration.Text ="";
                    txtWHO.Text = "";
                    ddlOtherCancer.SelectedIndex = -1;
                    txtPersonAge2.Text = "";
                    ddlSmoking.SelectedIndex =-1;
                    txtSmokingHistory.Text = "";
                    ddlAlcohol.SelectedIndex = -1;
                    txtAlcohol.Text ="";
                    txtAdditionalHistory.Text = "";
                    txtPreparationQuality.Text = "";
                    txtExtent.Text = "";
                    txtAnus.Text ="";
                    txtSigmoid.Text = "";
                    txtDescending.Text ="";
                    txtTraverse.Text = "";
                    txtAscending.Text = "";
                    txtIleum.Text = "";
                    ddlSedation.SelectedIndex = -1;
                    txtVersed.Text = "";
                    txtFentany.Text = "";
                    txtKatamine.Text = "";
                    txtOxygen.Text = "";
                    txtOther.Text = "";
                    txtImages.Text ="";
                    txtEndoscopyIntervention.Text = "";
                    txtRecommendations.Text = "";
                    txtFollowUpDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
                    //txtReportBy.Text = ((Label)grdPhysical.Rows[id].FindControl("lblReportBy")).Text;
                    txtProcedure.Text = "";
                    txtImpression.Text = "";
          
        //txtCheckedBy.Text = HttpContext.Current.Session["ID"].ToString();
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
            //string LastEGDDate = Util.GetDateTime(txtLastEGDDate.Text).ToString("yyyy-MM-dd");
            string FollowUpDate = Util.GetDateTime(txtFollowUpDate.Text).ToString("yyyy-MM-dd");

            var sqlCMD = "UPDATE colonoscopyform SET Date=@Date,Time=@Time,UpdateDate=NOW(),UpdatedBy=@UpdatedBy,Tribe=@Tribe," +
                "Chief=@Chief,Symptoms=@Symptoms,Height=@Height,Weight=@Weight,BMI=@BMI,Hematochezia=@Hematochezia,Anemia=@Anemia,Constipation=@Constipation," +
                "AbdPain=@AbdPain,WeightLoss=@WeightLoss,Other=@Other,Duration=@Duration,WHO=@WHO,OtherCancer=@OtherCancer,PersonAge=@PersonAge,Smoking=@Smoking,SmokingDetail=@SmokingDetail,Alcohol=@Alcohol," +
                 "Additional=@Additional,Preparation=@Preparation,Extent=@Extent,Anus=@Anus,Sigmoid=@Sigmoid,Descending=@Descending,Traverse=@Traverse,Ascending=@Ascending," +
                     "Ileum=@Ileum,Sedation=@Sedation,Versed=@Versed,Fentany=@Fentany,Katamine=@Katamine,Oxygen=@Oxygen,Other2=@Other2,Images=@Images,Endoscopy=@Endoscopy,Recommendations=@Recommendations,Ileum=@Ileum,Ileum=@Ileum," +
                   "FollowUpDate=@FollowUpDate,ReportBy=@ReportBy,Procedure1=@Procedure1,Impression=@Impression" +
                   
                    " WHERE ID=@ID;";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {

                    
                    UpdatedBy = HttpContext.Current.Session["ID"].ToString(),
                    Date = date,
                    Time = time,
                    Tribe = txtTribe.Text,
                    Chief = txtChief.Text,
                    Symptoms = txtSymptoms.Text,
                    Height = txtHeight.Text,
                    Weight = txtWeight.Text,
                    BMI = lblBMI.Text,
                    Hematochezia = txtHematochezia.Text,
                    Anemia = txtAnemia.Text,
                    Constipation = txtConstipation.Text,
                    AbdPain = txtAbdPain.Text,
                    WeightLoss = txtWeightLoss.Text,
                    Other = txtOther.Text,
                    Duration = txtDuration.Text,
                    WHO = txtWHO.Text,
                    OtherCancer = ddlOtherCancer.SelectedValue,
                    PersonAge = txtPersonAge2.Text,
                    Smoking = ddlSmoking.SelectedValue,
                    SmokingDetail = txtSmokingHistory.Text,
                    Alcohol = ddlAlcohol.SelectedValue,
                    AlcoholDetail = txtAlcohol.Text,
                   
                    Additional = txtAdditionalHistory.Text,
                    Preparation = txtPreparationQuality.Text,
                    Extent = txtExtent.Text,

                    Anus = txtAnus.Text,
                    Sigmoid = txtSigmoid.Text,
                    Descending = txtDescending.Text,
                    Traverse = txtTraverse.Text,
                    Ascending = txtAscending.Text,
                    Ileum = txtIleum.Text,
                    Sedation = ddlSedation.SelectedValue,
                    Versed = txtVersed.Text,
                    Fentany = txtFentany.Text,
                    Katamine = txtKatamine.Text,
                    Oxygen = txtOxygen.Text,
                    Other2 = txtOther.Text,
                    Images = txtImages.Text,
                    Endoscopy = txtEndoscopyIntervention.Text,
                    Recommendations = txtRecommendations.Text,
                    FollowUpDate = FollowUpDate,
                    ReportBy = HttpContext.Current.Session["ID"].ToString(),
                    Procedure1 = txtProcedure.Text,
                    Impression=txtImpression.Text,
                    ID = Util.GetInt(lblID.Text)
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