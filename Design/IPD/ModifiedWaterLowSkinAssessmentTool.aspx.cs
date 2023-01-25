
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


public partial class Design_IPD_ModifiedWaterLowSkinAssessmentTool : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtTime.Text = DateTime.Now.ToString("hh:mm tt");
            ViewState["PID"] = Request.QueryString["PID"].ToString();
            ViewState["TID"] = Request.QueryString["TID"].ToString();
            string gender = StockReports.ExecuteScalar("SELECT Gender FROM `patient_master` WHERE PatientID='" + ViewState["PID"].ToString() + "' order by ID desc limit 1");
            if (gender == "Male")
            {
                rdbSex.SelectedIndex = 0;
            }
            else
            {
                rdbSex.SelectedIndex = 1;
            }
            BindDetails(ViewState["PID"].ToString(), ViewState["TID"].ToString());
        }
        string entryby = StockReports.ExecuteScalar("SELECT Name 	FROM 	employee_master  WHERE  EmployeeId='"+Session["ID"].ToString()+"' LIMIT 0, 1");
        txtDate.Enabled = false;
        txtTime.Enabled = false;
        //txtTotal.Enabled = false;
       // txtCreatedBy.Text = entryby;

       // txtCreatedBy.Enabled = false;
    }
    protected void Radio1_Changed(object sender, EventArgs e)
    {
        lblBWFH.Text = rdbBuildWeightForHeight.SelectedItem.Text.Substring(rdbBuildWeightForHeight.SelectedItem.Text.Length - 2, 1);
        CalculateTotal();
    }
    protected void Radio2_Changed(object sender, EventArgs e)
    {
        lblSkinType.Text = rdbSkinType.SelectedItem.Text.Substring(rdbSkinType.SelectedItem.Text.Length - 2, 1);
        CalculateTotal();
    }
    protected void Radio3_Changed(object sender, EventArgs e)
    {
        lblSex.Text = rdbSex.SelectedItem.Text.Substring(rdbSex.SelectedItem.Text.Length - 2, 1);
        CalculateTotal();
    }
    protected void Radio4_Changed(object sender, EventArgs e)
    {
        lblAge.Text = rdbAge.SelectedItem.Text.Substring(rdbAge.SelectedItem.Text.Length - 2, 1);
        CalculateTotal();
    }
    protected void Radio5_Changed(object sender, EventArgs e)
    {
        lblContinence.Text = rdbContinence.SelectedItem.Text.Substring(rdbContinence.SelectedItem.Text.Length - 2, 1);
        CalculateTotal();
    }
    protected void Radio6_Changed(object sender, EventArgs e)
    {
        lblMobility.Text = rdbMobility.SelectedItem.Text.Substring(rdbMobility.SelectedItem.Text.Length - 2, 1);
        CalculateTotal();
    }
    protected void Radio7_Changed(object sender, EventArgs e)
    {
        lblTissueMalnutrition.Text = rdbTissueMalNutrition.SelectedItem.Text.Substring(rdbTissueMalNutrition.SelectedItem.Text.Length - 2, 1);
        CalculateTotal();
    }
    protected void Radio8_Changed(object sender, EventArgs e)
    {
        lblNeurologicalDeficit.Text = rdbNeurologicalDeficit.SelectedItem.Text.Substring(rdbNeurologicalDeficit.SelectedItem.Text.Length - 2, 1);
        CalculateTotal();
    }
    protected void Radio9_Changed(object sender, EventArgs e)
    {
        lblMajorSurgeryOrTrauma.Text = rdbMajorSurgeryOrTrauma.SelectedItem.Text.Substring(rdbMajorSurgeryOrTrauma.SelectedItem.Text.Length - 2, 1);
        CalculateTotal();
    }
    protected void Radio10_Changed(object sender, EventArgs e)
    {

        lblWeightLossScore.Text = rdbWeightLossScore.SelectedItem.Text.Substring(rdbWeightLossScore.SelectedItem.Text.Length - 2, 1);
        CalculateTotal();
    }
    protected void Radio11_Changed(object sender, EventArgs e)
    {

        lblEatingPoorly.Text = rdbEatingPoorly.SelectedItem.Text.Substring(rdbEatingPoorly.SelectedItem.Text.Length - 2, 1);
        CalculateTotal();
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
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", " window.open('./ModifiedWaterLowSkinAssessmentTool_PDF.aspx?TestID=O23&LabType=&LabreportType=11&ID=" + ID1 + "&TID=" + ViewState["TID"].ToString() + "');", true);

            
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
                string bwfh = ((Label)grdPhysical.Rows[id].FindControl("lbBWFH")).Text;
                if (bwfh != "")
                {
                    rdbBuildWeightForHeight.SelectedValue = bwfh;
                }
                else
                {
                    rdbBuildWeightForHeight.SelectedIndex = -1;
                }
                string SkinType = ((Label)grdPhysical.Rows[id].FindControl("lblSkinType")).Text;
                if (SkinType != "")
                {
                    rdbSkinType.SelectedValue = SkinType;
                }
                else
                {
                    rdbSkinType.SelectedIndex = -1;
                }

                string Sex2 = ((Label)grdPhysical.Rows[id].FindControl("lblSex2")).Text;
                if (Sex2 != "")
                {
                    rdbSex.SelectedValue = Sex2;
                }
                else
                {
                    rdbSex.SelectedIndex = -1;
                }
                string Age = ((Label)grdPhysical.Rows[id].FindControl("lblAge")).Text;
                if (Age != "")
                {
                    rdbAge.SelectedValue = Age;
                }
                else
                {
                    rdbAge.SelectedIndex = -1;
                }
                string LostWeight = ((Label)grdPhysical.Rows[id].FindControl("lblLostWeight")).Text;
                if (LostWeight != "")
                {
                    rdbLostWeight.SelectedValue = LostWeight;
                }
                else
                {
                    rdbLostWeight.SelectedIndex = -1;
                }

                string WeightLossScore = ((Label)grdPhysical.Rows[id].FindControl("lblWeightLossScore")).Text;
                if (WeightLossScore != "")
                {
                    rdbWeightLossScore.SelectedValue = WeightLossScore;
                }
                else
                {
                    rdbWeightLossScore.SelectedIndex = -1;
                }
                string EatingPoorly = ((Label)grdPhysical.Rows[id].FindControl("lblEatingPoorly")).Text;
                if (EatingPoorly != "")
                {
                    rdbEatingPoorly.SelectedValue = EatingPoorly;
                }
                else
                {
                    rdbEatingPoorly.SelectedIndex = -1;
                }
                string Continence = ((Label)grdPhysical.Rows[id].FindControl("lblContinence")).Text;
                if (Continence != "")
                {
                    rdbContinence.SelectedValue = Continence;
                }
                else
                {
                    rdbContinence.SelectedIndex = -1;
                }

                string Mobility = ((Label)grdPhysical.Rows[id].FindControl("lblMobility")).Text;
                if (Mobility != "")
                {
                    rdbMobility.SelectedValue = Mobility;
                }
                else
                {
                    rdbMobility.SelectedIndex = -1;
                }

                string TissueMalNutrition = ((Label)grdPhysical.Rows[id].FindControl("lblTissueMalNutrition")).Text;
                if (TissueMalNutrition != "")
                {
                    rdbTissueMalNutrition.SelectedValue = TissueMalNutrition;
                }
                else
                {
                    rdbTissueMalNutrition.SelectedIndex = -1;
                }

                string NeurologicalDeficit = ((Label)grdPhysical.Rows[id].FindControl("lblNeurologicalDeficit")).Text;
                if (NeurologicalDeficit != "")
                {
                    rdbNeurologicalDeficit.SelectedValue = NeurologicalDeficit;
                }
                else
                {
                    rdbNeurologicalDeficit.SelectedIndex = -1;
                }

                string MajorSurgeryTrauma = ((Label)grdPhysical.Rows[id].FindControl("lblMajorSurgeryTrauma")).Text;
                if (MajorSurgeryTrauma != "")
                {
                    rdbMajorSurgeryOrTrauma.SelectedValue = MajorSurgeryTrauma;
                }
                else
                {
                    rdbMajorSurgeryOrTrauma.SelectedIndex = -1;
                }
             lblTotalScore.Text = ((Label)grdPhysical.Rows[id].FindControl("lblTotalScore1")).Text;
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
            sb.Append(" Select *,(Select concat(title,' ',name) from Employee_master where EmployeeID=us.CreatedBy)EmpName,DATE_FORMAT(Date, '%d %b %Y') as Date1,TIME_FORMAT(Time, '%h:%i %p') as Time1,TIMESTAMPDIFF(MINUTE,CreatedDate,NOW()) createdDateDiff,"+
"  CASE    WHEN BWFH ='0' THEN 'Average BMI=20-24.9'    WHEN BWFH ='1' THEN 'Above Average BMI=25-25.9'    WHEN BWFH ='2' THEN 'Obese BMI>30'    WHEN BWFH ='3' THEN 'Below Average BMI<20'    ELSE ''END AS BWFH1,"+
" CASE    WHEN SkinType ='0' THEN 'Health'    WHEN SkinType ='1' THEN 'Tissue Paper'    WHEN SkinType ='2' THEN 'Dry'    WHEN SkinType ='3' THEN 'Odemetous'    WHEN SkinType ='4' THEN 'Clammy Pyraxia'    WHEN SkinType ='5' THEN 'Discoloured grade 1'    WHEN SkinType ='6' THEN 'Broken Spots grade 2-4'   ELSE ''END    AS SkinType1,"+
"     CASE    WHEN Sex ='0' THEN 'Male'    WHEN Sex ='1' THEN 'Female'    ELSE ''END AS Sex1,"+
" CASE    WHEN Age ='0' THEN '14-49'    WHEN Age ='1' THEN '50-64'    WHEN Age ='2' THEN '65-74'    WHEN Age ='3' THEN '75-80'    WHEN Age ='4' THEN 'Above 80'    ELSE ''END AS Age1,"+
" CASE    WHEN LostWeight ='0' THEN 'Yes Go to B'    WHEN LostWeight ='1' THEN 'No Go to C'    WHEN LostWeight ='2' THEN 'UnSure Go to C'    ELSE ''END AS LostWeight1  from modifiedwaterlowskinassessmenttool us where PatientID='" + PID + "' and TransactionID='" + TID + "' order by ID desc ");
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

            var sqlCMD = "INSERT INTO `modifiedwaterlowskinassessmenttool` (" +

"  `Date`,  `Time`,  `BWFH`,  `SkinType`,  `Sex`,  `Age`,  `LostWeight`,  `WeightLossScore`,  `EatingPoorly`,  `Continence`,  `Mobility`,  `TissueMalNutrition`,  `NeurologicalDeficit`," +
"  `MajorSurgeryTrauma`,  `CreatedBy`,  `CreatedDate`,  `PatientID`,  `TransactionID`,`TotalScore`)" +
" VALUES  (       @Date,   @Time,   @BWFH,   @SkinType,   @Sex,   @Age,   @LostWeight,   @WeightLossScore,   @EatingPoorly,   @Continence,   @Mobility,   @TissueMalNutrition," +
"   @NeurologicalDeficit,   @MajorSurgeryTrauma,   @CreatedBy,   NOW(),  @PatientID,   @TransactionID ,@TotalScore );";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    Date = date,
                    Time = time,
                    BWFH = rdbBuildWeightForHeight.SelectedValue,
                    SkinType = rdbSkinType.SelectedValue,
                    Sex = rdbSex.SelectedValue,
                    Age = rdbAge.SelectedValue,
                    LostWeight = rdbLostWeight.SelectedValue,
                    WeightLossScore = rdbWeightLossScore.SelectedValue,
                    EatingPoorly = rdbEatingPoorly.SelectedValue,
                    Continence = rdbContinence.SelectedValue,
                    Mobility = rdbMobility.SelectedValue,
                    TissueMalNutrition = rdbTissueMalNutrition.SelectedValue,
                    NeurologicalDeficit = rdbNeurologicalDeficit.SelectedValue,
                    MajorSurgeryTrauma = rdbMajorSurgeryOrTrauma.SelectedValue,
                    TotalScore=lblTotalScore.Text,
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
    private void CalculateTotal()
    {
        int total = 0;
        if (rdbBuildWeightForHeight.SelectedValue != null && rdbBuildWeightForHeight.SelectedValue != "")
        {
            total += Int32.Parse(rdbBuildWeightForHeight.SelectedItem.Text.Substring(rdbBuildWeightForHeight.SelectedItem.Text.Length-2,1));
        }
        if (rdbSkinType.SelectedValue != null && rdbSkinType.SelectedValue != "")
        {
            total += Int32.Parse(rdbSkinType.SelectedItem.Text.Substring(rdbSkinType.SelectedItem.Text.Length - 2, 1));
        }
        if (rdbSex.SelectedValue != null && rdbSex.SelectedValue != "")
        {
            total += Int32.Parse(rdbSex.SelectedItem.Text.Substring(rdbSex.SelectedItem.Text.Length - 2, 1));
        }

        if (rdbAge.SelectedValue != null && rdbAge.SelectedValue != "")
        {
            total += Int32.Parse(rdbAge.SelectedItem.Text.Substring(rdbAge.SelectedItem.Text.Length - 2, 1));
        }
        if (rdbLostWeight.SelectedValue != null && rdbLostWeight.SelectedValue != "")
        {
            //total += Int32.Parse(rdbLostWeight.SelectedItem.Text.Substring(rdbLostWeight.SelectedItem.Text.Length - 2, 1));
        }
        if (rdbEatingPoorly.SelectedValue != null && rdbEatingPoorly.SelectedValue != "")
        {
            total += Int32.Parse(rdbEatingPoorly.SelectedItem.Text.Substring(rdbEatingPoorly.SelectedItem.Text.Length - 2, 1));
        }
        if (rdbWeightLossScore.SelectedValue != null && rdbWeightLossScore.SelectedValue != "")
        {
            total += Int32.Parse(rdbWeightLossScore.SelectedItem.Text.Substring(rdbWeightLossScore.SelectedItem.Text.Length - 2, 1));
        }
        if (rdbContinence.SelectedValue != null && rdbContinence.SelectedValue != "")
        {
            total += Int32.Parse(rdbContinence.SelectedItem.Text.Substring(rdbContinence.SelectedItem.Text.Length - 2, 1));
        }
        if (rdbMobility.SelectedValue != null && rdbMobility.SelectedValue != "")
        {
            total += Int32.Parse(rdbMobility.SelectedItem.Text.Substring(rdbMobility.SelectedItem.Text.Length - 2, 1));
        }
        if (rdbTissueMalNutrition.SelectedValue != null && rdbTissueMalNutrition.SelectedValue != "")
        {
            total += Int32.Parse(rdbTissueMalNutrition.SelectedItem.Text.Substring(rdbTissueMalNutrition.SelectedItem.Text.Length - 2, 1));
        }
        if (rdbNeurologicalDeficit.SelectedValue != null && rdbNeurologicalDeficit.SelectedValue != "")
        {
            total += Int32.Parse(rdbNeurologicalDeficit.SelectedItem.Text.Substring(rdbNeurologicalDeficit.SelectedItem.Text.Length - 2, 1));
        }
        if (rdbMajorSurgeryOrTrauma.SelectedValue != null && rdbMajorSurgeryOrTrauma.SelectedValue != "")
        {
            total += Int32.Parse(rdbMajorSurgeryOrTrauma.SelectedItem.Text.Substring(rdbMajorSurgeryOrTrauma.SelectedItem.Text.Length - 2, 1));
        }
        lblTotalScore.Text = total + "";
    }
    private void Clear()
    {

                    txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
                    txtTime.Text = DateTime.Now.ToString("hh:mm tt");
                    rdbBuildWeightForHeight.SelectedIndex = -1;
                    rdbSkinType.SelectedIndex = -1;
                    rdbSex.SelectedIndex = -1;
                    rdbAge.SelectedIndex = -1;
                    rdbLostWeight.SelectedIndex = -1;
                    rdbWeightLossScore.SelectedIndex = -1;
                    rdbEatingPoorly.SelectedIndex = -1;
                    rdbContinence.SelectedIndex = -1;
                    rdbMobility.SelectedIndex = -1;
                    rdbTissueMalNutrition.SelectedIndex =-1;
                    rdbNeurologicalDeficit.SelectedIndex = -1;
                    rdbMajorSurgeryOrTrauma.SelectedIndex = -1;
                
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

            var sqlCMD = "UPDATE modifiedwaterlowskinassessmenttool SET UpdateDate=NOW(),UpdatedBy=@UpdatedBy," +
                "BWFH=@BWFH,SkinType=@SkinType,Sex=@Sex,Age=@Age," +
                "LostWeight=@LostWeight,WeightLossScore=@WeightLossScore,EatingPoorly=@EatingPoorly,Continence=@Continence," +

                    "Mobility=@Mobility,TissueMalNutrition=@TissueMalNutrition,NeurologicalDeficit=@NeurologicalDeficit,MajorSurgeryTrauma=@MajorSurgeryTrauma,TotalScore=@TotalScore" +
                " WHERE ID=@ID;";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {

                    
                    UpdatedBy = HttpContext.Current.Session["ID"].ToString(),
                    BWFH = rdbBuildWeightForHeight.SelectedValue,
                    SkinType = rdbSkinType.SelectedValue,
                    Sex = rdbSex.SelectedValue,
                    Age = rdbAge.SelectedValue,
                    LostWeight = rdbLostWeight.SelectedValue,
                    WeightLossScore = rdbWeightLossScore.SelectedValue,
                    EatingPoorly = rdbEatingPoorly.SelectedValue,
                    Continence = rdbContinence.SelectedValue,
                    Mobility = rdbMobility.SelectedValue,
                    TissueMalNutrition = rdbTissueMalNutrition.SelectedValue,
                    NeurologicalDeficit = rdbNeurologicalDeficit.SelectedValue,
                    MajorSurgeryTrauma = rdbMajorSurgeryOrTrauma.SelectedValue,
                    TotalScore=lblTotalScore.Text,
                    PatientID = ViewState["PID"].ToString(),
                    TransactionID = ViewState["TID"].ToString(),
                    ID=Util.GetString(lblID.Text)
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