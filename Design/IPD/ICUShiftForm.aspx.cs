
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


public partial class Design_IPD_ICUShiftForm : System.Web.UI.Page
{
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
        //txtTotal.Enabled = false;
        txtCreatedBy.Text = entryby;

        txtCreatedBy.Enabled = false;
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
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", " window.open('./ICUShiftFormPDF.aspx?TestID=O23&LabType=&LabreportType=11&ID=" + ID1 + "&TID=" + ViewState["TID"].ToString() + "');", true);

            
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
            sb.Append(" Select *,(Select concat(title,' ',name) from Employee_master where EmployeeID=CreatedBy)EmpName,DATE_FORMAT(Date, '%d %b %Y') as Date1,TIME_FORMAT(Time, '%h:%i %p') as Time1,TIMESTAMPDIFF(MINUTE,CreatedDate,NOW()) createdDateDiff,IF(Code='1','Yes','No') Code1,IF(Isolation='1','Yes','No') Isolation1  from icushiftform where PatientID='" + PID + "' and TransactionID='" + TID + "' order by ID desc ");
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
            
                var sqlCMD = "INSERT INTO icushiftform("+
  
 "  Date ,   Time ,   DX ,   HX ,   Allergies ,   Code ,   Isolation ,   IsolationDetails ,   LOC ,   Pupils ,   MS ,   GCS ,   Activity ,   Sleep ,   Pain ,   Sedetion ,   FollowUp ,   ECG ,"+
"   SIS2 ,   BP ,   NHP ,   ArtLine ,   Support ,   PYN ,   AntiCog ,   KPlus ,   CVP ,   PPulse ,   CapRefill ,   Skin ,   Edema ,   CVCSite ,   Pros ,   Due ,   Med ,   Due1 ,   Dist ,"+
"   Due2 ,   Perish ,   Rate ,   Soln ,   Rate1 ,   DingsDrain ,   FollowUp1 ,   RR ,   BreathSed ,   O2TX ,   O2Nat ,   TypeAirway ,   CuffPress ,   LipMark ,   VentMode ,   RR1 ,"+
"   TV ,   FIO2 ,   PEEP ,   PS ,   MV ,   AirwayPress ,   ABGS ,   Secreation ,   Suction ,   DingsDrain1 ,   FollowUp2 ,   Diet ,   NG ,   ABD ,   BS ,   LastBM ,   BSugar ,   Insulin ,"+
"   DingsDrain2 ,  AntiUlcer ,   FollowUp3 ,   Foley ,   UOUp ,   Urine ,   BUNCR ,   HRBal ,   Shift ,   Bal ,   Dialysis ,   FollowUp4 ,   Temp ,   WBC ,   Intact ,   DingChanges ,   Other ,"+
"   CreatedBy ,   CreatedDate ,   PatientID ,   TransactionID )"+
"            VALUES(        @Date,    @Time,    @DX,   @HX,    @Allergies,    @Code,    @Isolation,    @IsolationDetails,    @LOC,    @Pupils,    @MS,    @GCS,    @Activity,"+
"    @Sleep,    @Pain,    @Sedetion,    @FollowUp,    @ECG,    @SIS2,    @BP,    @NHP,    @ArtLine,    @Support,    @PYN,    @AntiCog,    @KPlus,    @CVP,    @PPulse,    @CapRefill,"+
"    @Skin,    @Edema,    @CVCSite,    @Pros,    @Due,    @Med,    @Due1,    @Dist,    @Due2,    @Perish,    @Rate,    @Soln,    @Rate1,    @DingsDrain,    @FollowUp1,    @RR,    @BreathSed,"+
"    @O2TX,    @O2Nat,    @TypeAirway,    @CuffPress,    @LipMark,    @VentMode,    @RR1,    @TV,    @FIO2,    @PEEP,    @PS,    @MV,    @AirwayPress,    @ABGS,    @Secreation,"+
"    @Suction,    @DingsDrain1,    @FollowUp2,    @Diet,    @NG,    @ABD,    @BS,    @LastBM,    @BSugar,    @Insulin,    @DingsDrain2,    @AntiUlcer,    @FollowUp3,    @Foley,"+
"    @UOUp,    @Urine,    @BUNCR,    @HRBal,    @Shift,    @Bal,    @Dialysis,    @FollowUp4,    @Temp,    @WBC,    @Intact,    @DingChanges,    @Other,    @CreatedBy,    NOW(),"+
"       @PatientID,    @TransactionID  );";       
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    Date = date,
                    Time = time,
                    DX = txtDX.Text,
                    HX = txtHX.Text,
                    Allergies = txtAllergies.Text,
                    Code = ddlCode.SelectedValue,
                    Isolation = ddlIsolation.SelectedValue,
                    IsolationDetails = txtIsolationDetails.Text,
                    LOC = txtLOC.Text,
                    Pupils = txtPupils.Text,
                    MS = txtMS.Text,
                    GCS = txtGCS.Text,
                    Activity = txtActivity.Text,
                    Sleep = txtSleep.Text,
                    Pain = txtPain.Text,
                    Sedetion = txtSedation.Text,
                    FollowUp = txtFollowUp1.Text,
                    ECG = txtECGRhythm.Text,
                    SIS2 = txtSIS2.Text,
                    BP = txtBPCuff.Text,
                    NHP = txtNHP.Text,
                    ArtLine = txtArtLine.Text,
                    Support = txtSupport.Text,
                    PYN = txtPYN.Text,
                    Anticog = txtAntiCog.Text,
                    KPlus = txtKPlus.Text,
                    CVP = txtCVP.Text,
                    PPulse = txtPPulse.Text,
                    CapRefill = txtCapRefill.Text,
                    Skin = txtSkin.Text,
                    Edema = txtEdema.Text,
                    CVCSite = txtCVCSite.Text,
                    Pros = txtPros.Text,
                    Due = txtDue.Text,
                    Med = txtMed.Text,
                    Due1 = txtDue1.Text,
                    Dist = txtDist.Text,
                    Due2 = txtDue2.Text,
                    Perish = txtPerishIVSoln.Text,
                    Rate = txtRate.Text,
                    Soln = txtSoln.Text,
                    Rate1 = txtRate.Text,
                    DingsDrain = txtDingsDrain.Text,
                    FollowUp1 = txtFollowUp1.Text,
                    RR = txtRR.Text,
                    BreathSed = txtBreathSed.Text,
                    O2TX = txtO2TX.Text,
                    O2Nat = txtO2Nat.Text,
                    TypeAirway = txtTypeAirway.Text,
                    CuffPress = txtCuffPress.Text,
                    LipMark = txtLipMark.Text,
                    VentMode = txtVentMode.Text,
                    RR1 = txtRR1.Text,
                    TV = txtTV.Text,
                    FIO2 = txtFIO2.Text,
                    PEEP = txtPEEP.Text,
                    PS = txtPS.Text,
                    MV = txtMV.Text,
                    AirwayPress = txtAirwayPress.Text,
                    ABGS = txtABGS.Text,
                    Secreation = txtSecreation.Text,
                    Suction = txtSedation.Text,
                    DingsDrain1 = txtDingsDrain1.Text,
                    FollowUp2 = txtFollowUp2.Text,
                    Diet = txtDiet.Text,
                    NG = txtNG.Text,
                    ABD = txtAbd.Text,
                    BS = txtBS.Text,
                    LastBM = txtLastBM.Text,
                    BSugar = txtBSugar.Text,
                    Insulin = txtInsulin.Text,
                    DingsDrain2 = txtDingsDrains1.Text,
                    AntiUlcer = txtAntiUlcerRx.Text,
                    FollowUp3 = txtFollowUp3.Text,
                    Foley = txtFoleyYNHrly.Text,
                    UOUp = txtUO.Text,
                    Urine = txtUrine.Text,
                    BUNCR = txtBUNCR.Text,
                    HRBal = txtBal.Text,
                    Shift = txtShift.Text,
                    Bal = txtBal.Text,
                    Dialysis = txtDialysis.Text,
                    FollowUp4 = txtFollowUp4.Text,
                    Temp = txtTemp.Text,
                    WBC = txtWBC.Text,
                    Intact = txtIntactYN.Text,
                    DingChanges = txtDingChanges.Text,
                    Other = txtOther.Text,
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
                    txtDX.Text="";
                    txtHX.Text="";
                    txtAllergies.Text="";
                    ddlCode.SelectedIndex=0;
                     ddlIsolation.SelectedIndex=0;
                     txtIsolationDetails.Text="";
                     txtPupils.Text="";
                    txtMS.Text="";
                     txtGCS.Text="";
                     txtActivity.Text="";
                     txtSleep.Text="";
                     txtPain.Text="";
                     txtSedation.Text="";
                     txtFollowUp1.Text="";
                     txtECGRhythm.Text="";
                     txtSIS2.Text="";
                     txtBPCuff.Text="";
                     txtNHP.Text="";
                     txtArtLine.Text="";
                     txtSupport.Text="";
                     txtPYN.Text="";
                     txtAntiCog.Text="";
                     txtKPlus.Text="";
                     txtCVP.Text="";
                     txtPPulse.Text="";
                     txtCapRefill.Text="";
                    txtSkin.Text="";
                     txtEdema.Text="";
                    txtCVCSite.Text="";
                    txtPros.Text="";
                     txtDue.Text="";
                     txtMed.Text="";
                     txtDue1.Text="";
                     txtDist.Text="";
                  txtDue2.Text="";
                     txtPerishIVSoln.Text="";
                     txtRate.Text="";
                     txtSoln.Text="";
                     txtRate.Text="";
                     txtDingsDrain.Text="";
                     txtFollowUp1.Text="";
                    txtRR.Text="";
                    txtBreathSed.Text="";
                     txtO2TX.Text="";
                     txtO2Nat.Text="";
                     txtTypeAirway.Text="";
                    txtCuffPress.Text="";
                   txtLipMark.Text="";
                    txtVentMode.Text="";
                     txtRR1.Text="";
                    txtTV.Text="";
                     txtFIO2.Text="";
                     txtPEEP.Text="";
                    txtPS.Text="";
                     txtMV.Text="";
                     txtAirwayPress.Text="";
                    txtABGS.Text="";
                     txtSecreation.Text="";
                    txtSedation.Text="";
                     txtDingsDrain1.Text="";
                    txtFollowUp2.Text="";
                    txtDiet.Text="";
                   txtNG.Text="";
                     txtAbd.Text="";
                     txtBS.Text="";
                     txtLastBM.Text="";
                     txtBSugar.Text="";
                     txtInsulin.Text="";
                    txtDingsDrains1.Text="";
                    txtAntiUlcerRx.Text="";
                     txtFollowUp3.Text="";
                   txtFoleyYNHrly.Text="";
                     txtUO.Text="";
                     txtUrine.Text="";
                     txtBUNCR.Text="";
                     txtBal.Text="";
                     txtShift.Text="";
                    txtBal.Text="";
                    txtDialysis.Text="";
                    txtFollowUp4.Text="";
                    txtTemp.Text="";
                    txtWBC.Text="";
                    txtIntactYN.Text="";
                    txtDingChanges.Text="";
                    txtOther.Text = "";
                   
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
           
            var sqlCMD = "UPDATE icushiftform SET UpdateDate=NOW(),UpdatedBy=@UpdatedBy,DX=@DX," +
                "HX=@HX,Allergies=@Allergies,Code=@Code,Isolation=@Isolation," +
                "IsolationDetails=@IsolationDetails,Pupils=@Pupils,MS=@MS,GCS=@GCS," +
                
                    "Activity=@Activity,Sleep=@Sleep,Pain=@Pain,Sedetion=@Sedetion,FollowUp=@FollowUp,ECG=@ECG,SIS2=@SIS2,BP=@BP,NHP=@NHP,ArtLine=@ArtLine,Support=@Support," +
                "PYN=@PYN,Anticog=@Anticog,KPlus=@KPlus,CVP=@CVP,PPulse=@PPulse,CapRefill=@CapRefill,Skin=@Skin," +
               "Edema=@Edema,CVCSite=@CVCSite,Pros=@Pros,Due=@Due,Med=@Med,Due1=@Due1,Dist=@Dist," +
               "Due2=@Due2,Perish=@Perish,Rate=@Rate,Soln=@Soln,Rate1=@Rate1,DingsDrain=@DingsDrain,FollowUp1=@FollowUp1,RR=@RR,BreathSed=@BreathSed," +
               "O2TX=@O2TX,O2Nat=@O2Nat,TypeAirway=@TypeAirway,CuffPress=@CuffPress,LipMark=@LipMark,VentMode=@VentMode,RR1=@RR1,TV=@TV,FIO2=@FIO2,PEEP=@PEEP,PS=@PS," +
               "MV=@MV,AirwayPress=@AirwayPress,ABGS=@ABGS,Secreation=@Secreation,Suction=@Suction,DingsDrain1=@DingsDrain1,FollowUp2=@FollowUp2,Diet=@Diet,NG=@NG,ABD=@ABD," +
                "BS=@BS,LastBM=@LastBM,BSugar=@BSugar,Insulin=@Insulin,DingsDrain2=@DingsDrain2,AntiUlcer=@AntiUlcer,FollowUp3=@FollowUp3,Foley=@Foley,UOUp=@UOUp," +
                "Urine=@Urine,BUNCR=@BUNCR,HRBal=@HRBal,Shift=@Shift,Bal=@Bal,Dialysis=@Dialysis,FollowUp4=@FollowUp4,Temp=@Temp,WBC=@WBC,Intact=@Intact," +
                "DingChanges=@DingChanges,Other=@Other " +
                " WHERE ID=@ID;";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {

                    
                    UpdatedBy = HttpContext.Current.Session["ID"].ToString(),
                    DX = txtDX.Text,
                    HX = txtHX.Text,
                    Allergies = txtAllergies.Text,
                    Code = ddlCode.SelectedValue,
                    Isolation = ddlIsolation.SelectedValue,
                    IsolationDetails = txtIsolationDetails.Text,
                    Pupils = txtPupils.Text,
                    MS = txtMS.Text,
                    GCS = txtGCS.Text,
                    Activity = txtActivity.Text,
                    Sleep = txtSleep.Text,
                    Pain = txtPain.Text,
                    Sedetion = txtSedation.Text,
                    FollowUp = txtFollowUp1.Text,
                    ECG = txtECGRhythm.Text,
                    SIS2 = txtSIS2.Text,
                    BP = txtBPCuff.Text,
                    NHP = txtNHP.Text,
                    ArtLine = txtArtLine.Text,
                    Support = txtSupport.Text,
                    PYN = txtPYN.Text,
                    Anticog = txtAntiCog.Text,
                    KPlus = txtKPlus.Text,
                    CVP = txtCVP.Text,
                    PPulse = txtPPulse.Text,
                    CapRefill = txtCapRefill.Text,
                    Skin = txtSkin.Text,
                    Edema = txtEdema.Text,
                    CVCSite = txtCVCSite.Text,
                    Pros = txtPros.Text,
                    Due = txtDue.Text,
                    Med = txtMed.Text,
                    Due1 = txtDue1.Text,
                    Dist = txtDist.Text,
                    Due2 = txtDue2.Text,

                    Perish = txtPerishIVSoln.Text,
                    Rate = txtRate.Text,
                    Soln = txtSoln.Text,
                    Rate1 = txtRate.Text,
                    DingsDrain = txtDingsDrain.Text,
                    FollowUp1 = txtFollowUp1.Text,
                    RR = txtRR.Text,
                    BreathSed = txtBreathSed.Text,
                    O2TX = txtO2TX.Text,
                    O2Nat = txtO2Nat.Text,
                    TypeAirway = txtTypeAirway.Text,
                    CuffPress = txtCuffPress.Text,
                    LipMark = txtLipMark.Text,
                    VentMode = txtVentMode.Text,
                    RR1 = txtRR1.Text,
                    TV = txtTV.Text,
                    FIO2 = txtFIO2.Text,
                    PEEP = txtPEEP.Text,
                    PS = txtPS.Text,
                    MV = txtMV.Text,
                    AirwayPress = txtAirwayPress.Text,
                    ABGS = txtABGS.Text,
                    Secreation = txtSecreation.Text,
                    Suction = txtSedation.Text,
                    DingsDrain1 = txtDingsDrain1.Text,
                    FollowUp2 = txtFollowUp2.Text,
                    Diet = txtDiet.Text,
                    NG = txtNG.Text,
                    ABD = txtAbd.Text,
                    BS = txtBS.Text,
                    LastBM = txtLastBM.Text,
                    BSugar = txtBSugar.Text,
                    Insulin = txtInsulin.Text,
                    DingsDrain2 = txtDingsDrains1.Text,
                    AntiUlcer = txtAntiUlcerRx.Text,
                    FollowUp3 = txtFollowUp3.Text,
                    Foley = txtFoleyYNHrly.Text,
                    UOUp = txtUO.Text,
                    Urine = txtUrine.Text,
                    BUNCR = txtBUNCR.Text,
                    HRBal = txtBal.Text,
                    Shift = txtShift.Text,
                    Bal = txtBal.Text,
                    Dialysis = txtDialysis.Text,
                    FollowUp4 = txtFollowUp4.Text,
                    Temp = txtTemp.Text,
                    WBC = txtWBC.Text,
                    Intact = txtIntactYN.Text,
                    DingChanges = txtDingChanges.Text,
                    Other = txtOther.Text,
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