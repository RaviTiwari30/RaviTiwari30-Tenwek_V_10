

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


public partial class Design_IPD_CardiacEvaluation : System.Web.UI.Page
{
    private void BindEmployee()
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            //sb.Append("SELECT ID,DATE_FORMAT(DATE,'%d-%M-%Y') AS Date1,FirstDegreeTear,SecondDegreeTear,ThirdDegreeTear,FourthDegreeTear,Episiotomy,NewBornResuscitated,PatientID,TransactionID  FROM delivery_master where TransactionID='" + Util.GetString(ViewState["TID"]) + "'");

            sb.Append("SELECT Distinct em.EmployeeID,em.NAME FROM `employee_master`  em  INNER JOIN f_login fl ON fl.EmployeeID=em.EmployeeID where  em.IsActive = 1  AND fl.`CentreID`='" + Session["CentreID"].ToString() + "' ORDER BY NAME ");


            DataTable dt = StockReports.GetDataTable(sb.ToString());
            ddlOrdering.DataSource = dt;
            ddlOrdering.DataValueField = "EmployeeID";
            ddlOrdering.DataTextField = "NAME";
            ddlOrdering.DataBind();

            ddlOrdering.Items.Insert(0, new ListItem("--Select--", "0"));
            ddlSONO.DataSource = dt;
            ddlSONO.DataValueField = "EmployeeID";
            ddlSONO.DataTextField = "NAME";
            ddlSONO.DataBind();

            ddlSONO.Items.Insert(0, new ListItem("--Select--", "0"));
            
            

        }
        catch (Exception exc)
        {
            ddlOrdering.DataSource = null;
            ddlOrdering.DataSource = null;
        }

    }

    private void BindCounty()
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            //sb.Append("SELECT ID,DATE_FORMAT(DATE,'%d-%M-%Y') AS Date1,FirstDegreeTear,SecondDegreeTear,ThirdDegreeTear,FourthDegreeTear,Episiotomy,NewBornResuscitated,PatientID,TransactionID  FROM delivery_master where TransactionID='" + Util.GetString(ViewState["TID"]) + "'");

            sb.Append("	SELECT 8 TypeID,'State' TypeName,StateName AS TextField,StateID AS ValueField"+
		", '' Department,CountryID,StateID,0 DistrictID,0 CityID  ,'' AS STD_CODE, '' referDoctorID,'' defaultDoctor"+
		" FROM master_State WHERE IsActive=1 AND StateName<>''");


            DataTable dt = StockReports.GetDataTable(sb.ToString());
            ddlCounty.DataSource = dt;
            ddlCounty.DataValueField = "ValueField";
            ddlCounty.DataTextField = "TextField";
            ddlCounty.DataBind();

            ddlCounty.Items.Insert(0, new ListItem("--Select--", "0"));


        }
        catch (Exception exc)
        {
            ddlCounty.DataSource = null;
            ddlCounty.DataSource = null;
        }

    }
   
    protected void Radio1_Changed(object sender, EventArgs e)
    {
       
    }
    protected void Radio11_Changed(object sender, EventArgs e)
    {

    }
    
    protected void Radio2_Changed(object sender, EventArgs e)
    {

       
    }
    protected void Radio3_Changed(object sender, EventArgs e)
    {

       
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindEmployee();
            BindCounty();
            txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtLast.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtTime.Text = DateTime.Now.ToString("hh:mm tt");
            ViewState["PID"] = Request.QueryString["PID"].ToString();
            ViewState["TID"] = Request.QueryString["TID"].ToString();
            string entryby = StockReports.ExecuteScalar("SELECT Name 	FROM 	employee_master  WHERE  EmployeeId='" + Session["ID"].ToString() + "' LIMIT 0, 1");
            ddlSONO.SelectedValue = Session["ID"].ToString();
            BindDetails(ViewState["PID"].ToString(), ViewState["TID"].ToString());
            string height = StockReports.ExecuteScalar(" SELECT Height  FROM IPD_Patient_ObservationChart cv  WHERE transactionid='" + ViewState["TID"].ToString() + "'  ORDER BY ID DESC LIMIT  1");
            if (height != "0")
            {
                lblHeight.Text = height;
            }
            string weight = StockReports.ExecuteScalar(" SELECT Weight  FROM IPD_Patient_ObservationChart cv  WHERE transactionid='" + ViewState["TID"].ToString() + "' ORDER BY ID DESC LIMIT  1");
            if (weight != "0")
            {
                lblWeight.Text = weight;
            }
            string telephone = StockReports.ExecuteScalar("SELECT Mobile FROM `patient_master` WHERE PatientID='" + ViewState["PID"].ToString() + "' LIMIT 0, 1");
            lblTelephone.Text = telephone;
         
        }
        txtDate.Enabled = false;
        txtTime.Enabled = false;
        
        //txtPersonInserting.Text = entryby;
        //txtTotal.Enabled = false;
        //txtAssessmentBy.Text = entryby;
    }
    protected void grdPhysical_RowDataBound(object sender, GridViewRowEventArgs e)
    {
       
    }
    
    protected void grdPhysical_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Print")
        {
            lblMsg.Text = "";
            int id = Convert.ToInt16(e.CommandArgument.ToString());
                string ID1 = ((Label)grdPhysical.Rows[id].FindControl("lblID1")).Text;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", " window.open('./CardiacEvaluation_PDF.aspx?TestID=O23&LabType=&LabreportType=11&ID=" + ID1 + "&TID=" + ViewState["TID"].ToString() + "');", true);

            
        }
        if (e.CommandName == "Change")
        {
            lblMsg.Text = "";
            int id = Convert.ToInt16(e.CommandArgument.ToString());
                lblID.Text = ((Label)grdPhysical.Rows[id].FindControl("lblID")).Text;
            DataTable dt = (DataTable)ViewState["dt"];
            DataRow[] rows = dt.Select("Id = '" + lblID.Text + "'");
            if (rows.Length > 0)
            {
                if (rows[0]["Ordering"].ToString() != "")
                {
                    ddlOrdering.SelectedValue = rows[0]["Ordering"].ToString();
                }

                if (rows[0]["County"].ToString() != "")
                {
                    ddlCounty.SelectedValue = rows[0]["County"].ToString();
                }
                txtPrimary.Text = rows[0]["Primary1"].ToString();
                txtPhone.Text = rows[0]["Pager"].ToString();

                txtDate.Text = rows[0]["Date1"].ToString();
                txtTime.Text = rows[0]["Time1"].ToString();
                txtHistory.Text = rows[0]["History"].ToString();
                rdbNYHA.SelectedValue = rows[0]["NYHA"].ToString();
                txtDrugs.Text = rows[0]["Medications"].ToString();
                rdbDurabiotic.SelectedValue = rows[0]["Durabiotic"].ToString();
               txtLast.Text = rows[0]["Last1"].ToString();
               txtDrug.Text = rows[0]["Drug"].ToString();
               txtPMHx.Text = rows[0]["PMHx"].ToString();
               txtFHx.Text = rows[0]["FHx"].ToString();
               txtSH.Text = rows[0]["SH"].ToString();
               txtROS.Text = rows[0]["ROS"].ToString();
               txtHR.Text = rows[0]["HR"].ToString();
               txtRR.Text = rows[0]["RR"].ToString();
               txtBP.Text = rows[0]["BP"].ToString();
               txtSAT.Text = rows[0]["SAT"].ToString();
               txtTemp.Text = rows[0]["Temp"].ToString();
               txtGeneral.Text = rows[0]["General"].ToString();
               txtHeart.Text = rows[0]["Heart"].ToString();
               txtLungs.Text = rows[0]["Lungs"].ToString();
               txtAbdomen.Text = rows[0]["Abdomen"].ToString();
               txtExtremities.Text = rows[0]["Extremities"].ToString();
               txtChest.Text = rows[0]["Chest"].ToString();
               txtLaboratory.Text = rows[0]["Laboratory"].ToString();
               txtECG.Text = rows[0]["ECG"].ToString();
               txtIndication.Text = rows[0]["Indication"].ToString();
               ddlSONO.SelectedValue= rows[0]["SONO"].ToString();
               txtLA.Text = rows[0]["LA"].ToString();
               txtLV.Text = rows[0]["LV"].ToString();
               txtLVd.Text = rows[0]["LVd"].ToString();
               txtLVs.Text = rows[0]["LVs"].ToString();
               txtSF.Text = rows[0]["SF"].ToString();
               txtEF.Text = rows[0]["EF"].ToString();
               txtRA.Text = rows[0]["RA"].ToString();
               txtRV.Text = rows[0]["RV"].ToString();
               txtAV.Text = rows[0]["AV"].ToString();
               txtMV.Text = rows[0]["MV"].ToString();
               txtTV.Text = rows[0]["TV"].ToString();
               txtPV.Text = rows[0]["PV"].ToString();
               txtPevicardium.Text = rows[0]["Pevicardium"].ToString();
               txtAorta.Text = rows[0]["Aorta"].ToString();
               txtPAs.Text = rows[0]["PAs"].ToString();
               txtPDA.Text = rows[0]["PDA"].ToString();
               txtASept.Text = rows[0]["ASept"].ToString();
               txtVSept.Text = rows[0]["VSept"].ToString();
               txtSysvv.Text = rows[0]["Sys"].ToString();
               txtPulmvv.Text = rows[0]["Pulm"].ToString();
               txtMitral.Text = rows[0]["Mitral"].ToString();
               txtAortic.Text = rows[0]["Aortic"].ToString();
               txtTricuspid.Text = rows[0]["Tricuspid"].ToString();
               txtImpression.Text = rows[0]["Impression"].ToString();
               txtPlan.Text = rows[0]["Plan"].ToString();
                btnUpdate.Visible = true;
                btnSave.Visible = false;
                btnCancel.Visible = true;
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
            sb.Append("SELECT *,pmh.Type,pmh.transNo,lt.EncounterNo,IF(pmh.Type='IPD',pmh.TransNo,lt.EncounterNo)EncounterNo1,(SELECT CONCAT(title,' ',NAME) FROM Employee_master WHERE EmployeeID=iu.CreatedBy)EmpName,DATE_FORMAT(LAST, '%d %b %Y') AS Last1,"+
"DATE_FORMAT(iu.Date, '%d %b %Y') AS Date1,TIME_FORMAT(iu.Time, '%h:%i %p') AS Time1 FROM cardiacevaluation iu INNER JOIN"+
" patient_medical_history pmh ON pmh.TransactionID=iu.TransactionID INNER JOIN f_ledgertransaction lt ON lt.LedgertransactionNo=iu.TransactionID where iu.PatientID='" + PID + "'  ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                ViewState["dt"] = dt;
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
    [WebMethod]
    public static string BindSearch(string key)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT im.TypeName AS NAME FROM f_itemmaster im INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID = im.SubcategoryID ");
        sb.Append(" INNER JOIN f_categorymaster cm ON cm.CategoryID = sm.CategoryID WHERE cm.CategoryID='5' AND im.TypeName like '%" + key + "%' ");

        DataTable dtDetails = StockReports.GetDataTable(sb.ToString());

        if (dtDetails.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtDetails);
        }
        return "";
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
            string last = Util.GetDateTime(txtLast.Text).ToString("yyyy-MM-dd");
            string time = Util.GetDateTime(txtTime.Text).ToString("HH:mm");
            
            var sqlCMD = "INSERT INTO cardiacevaluation ("+
  
  "Date,  Time,  History,  NYHA,Medications,  Durabiotic,  Last,  Drug,  PMHx,  FHx,  SH,  ROS,  HR,  RR,  BP,  SAT,  Temp,  General,  Heart,  Lungs,  Abdomen,  Extremities,  Chest,  Laboratory,"+
"  ECG,  Indication,  SONO,  LA,  LV,  LVd,  LVs,  SF,  EF,  RA,  RV,  AV,  MV,  TV,  PV,  Pevicardium,  Aorta,  PAs,  PDA,  ASept,  VSept,  Sys,  Pulm,  Mitral,  Aortic,  Tricuspid,"+
"  Impression, Plan,  CreatedBy,  CreatedDate,   PatientID,  TransactionID,Ordering,County,Primary1,Pager,Weight,Height)" +
" VALUES (       @Date,    @Time,    @History,    @NYHA, @Medications,   @Durabiotic,    @Last,    @Drug,    @PMHx,    @FHx,    @SH,    @ROS,    @HR,    @RR,    @BP,    @SAT,    @Temp,    @General," +
"    @Heart,    @Lungs,    @Abdomen,    @Extremities,    @Chest,    @Laboratory,    @ECG,    @Indication,    @SONO,    @LA,    @LV,    @LVd,    @LVs,    @SF,    @EF,    @RA,    @RV,"+
"    @AV,   @MV,    @TV,    @PV,    @Pevicardium,    @Aorta,    @PAs,    @PDA,    @ASept,    @VSept,    @Sys,    @Pulm,    @Mitral,    @Aortic,    @Tricuspid,   @Impression,"+
"    @Plan,    @CreatedBy,    NOW(),     @PatientID,    @TransactionID ,@Ordering,@County,@Primary ,@Pager,@Weight,@Height);";       
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    Weight=lblWeight.Text,
                    height=lblHeight.Text,
                    Pager=txtPhone.Text,
                    Ordering=ddlOrdering.SelectedValue,
                    County=ddlCounty.SelectedValue,
                    Primary=txtPrimary.Text,
                    Date = date,
                    Time = time,
                    History = txtHistory.Text,
                    NYHA = rdbNYHA.SelectedValue,
                    Medications=txtDrugs.Text,
                    Durabiotic = rdbDurabiotic.SelectedValue,
                    Last = last,
                    Drug = txtDrug.Text,
                    PMHx = txtPMHx.Text,
                    FHx = txtFHx.Text,
                    SH = txtSH.Text,
                    ROS = txtROS.Text,
                    HR = txtHR.Text,
                    RR = txtRR.Text,
                    BP = txtBP.Text,
                    SAT = txtSAT.Text,
                    Temp = txtTemp.Text,
                    General = txtGeneral.Text,
                    Heart = txtHeart.Text,
                    Lungs = txtLungs.Text,
                    Abdomen = txtAbdomen.Text,
                    Extremities = txtExtremities.Text,
                    Chest = txtChest.Text,
                    Laboratory = txtLaboratory.Text,
                    ECG = txtECG.Text,
                    Indication = txtIndication.Text,
                    SONO = ddlSONO.SelectedValue,
                    LA =txtLA.Text,
                    LV = txtLV.Text,
                    LVd = txtLVd.Text,
                    LVs = txtLVs.Text,

                    SF = txtSF.Text,
                    EF = txtEF.Text,
                    RA = txtRA.Text,
                    RV = txtRV.Text,
                    AV = txtAV.Text,
                    MV = txtMV.Text,
                    TV =txtTV.Text,
                    PV = txtPV.Text,
                     Pevicardium=txtPevicardium.Text,
                     Aorta=txtAorta.Text,
                     PAs=txtPAs.Text, 
                     PDA=txtPDA.Text, 
                     ASept=txtASept.Text,
                     VSept=txtVSept.Text, 
                     Sys=txtSysvv.Text,  
                     Pulm=txtPulmvv.Text, 
                     Mitral=txtMitral.Text,
                     Aortic=txtAortic.Text,
                     Tricuspid=txtTricuspid.Text,
                     Impression=txtImpression.Text,
                     Plan=txtPlan.Text,
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
                    txtPrimary.Text = "";
                    ddlCounty.SelectedIndex = 0;
                    ddlOrdering.SelectedIndex = 0;
                    txtPhone.Text = "";
                    txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
                    txtTime.Text = DateTime.Now.ToString("hh:mm tt");
                    txtHistory.Text ="";
                    rdbNYHA.SelectedIndex = -1;
                    txtDrugs.Text = "";
                    rdbDurabiotic.SelectedIndex =-1;
                    txtLast.Text = DateTime.Now.ToString("dd-MMM-yyyy");
                    txtDrug.Text = "";
                    txtPMHx.Text = "";
                    txtFHx.Text = "";
                    txtSH.Text = "";
                    txtROS.Text = "";
                    txtHR.Text = "";
                    txtRR.Text = "";
                    txtBP.Text ="";
                    txtSAT.Text = "";
                    txtTemp.Text = "";
                    txtGeneral.Text = "";
                    txtHeart.Text ="";
                    txtLungs.Text ="";
                    txtAbdomen.Text = "";
                    txtExtremities.Text = "";
                    txtChest.Text = "";
                    txtLaboratory.Text ="";
                    txtECG.Text = "";
                    txtIndication.Text = "";
                    ddlSONO.SelectedValue = Session["ID"].ToString();
                    txtLA.Text = "";
                    txtLV.Text = "";
                    txtLVd.Text = "";
                    txtLVs.Text = "";
                    txtSF.Text = "";
                    txtEF.Text = "";
                    txtRA.Text ="";
                    txtRV.Text = "";
                    txtAV.Text = "";
                    txtMV.Text ="";
                    txtTV.Text = "";
                    txtPV.Text = "";
                    txtPevicardium.Text = "";
                    txtAorta.Text ="";
                    txtPAs.Text = "";
                    txtPDA.Text = "";
                    txtASept.Text = "";
                    txtVSept.Text = "";
                    txtSysvv.Text ="";
                    txtPulmvv.Text ="";
                    txtMitral.Text = "";
                    txtAortic.Text = "";
                    txtTricuspid.Text = "";
                    txtImpression.Text = "";
                    txtPlan.Text = "";
                

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
            string last = Util.GetDateTime(txtLast.Text).ToString("yyyy-MM-dd");
            string time = Util.GetDateTime(txtTime.Text).ToString("HH:mm");
            var sqlCMD = "UPDATE CardiacEvaluation  set " +

 " Date=@Date,  Time=@Time, UpdatedBy=@UpdatedBy,UpdateDate=NOW(),  History=@History,  NYHA=@NYHA,Medications=@Medications,  Durabiotic=@Durabiotic,  Last=@Last,  Drug=@Drug,"+
 "PMHx=@PMHx,  FHx=@FHx,  SH=@SH,  ROS=@ROS,  HR=@HR,  RR=@RR,  BP=@BP,  SAT=@SAT,  Temp=@Temp,  General=@General,  Heart=@Heart,  Lungs=@Lungs,  Abdomen=@Abdomen, "+
 " Extremities=@Extremities,  Chest=@Chest,  Laboratory=@Laboratory," +
"  ECG=@ECG,  Indication=@Indication,  SONO=@SONO,  LA=@LA,  LV=@LV,  LVd=@LVd,  LVs=@LVs,  SF=@SF,  EF=@EF,  RA=@RA,  RV=@RV,  AV=@AV,  MV=@MV,  TV=@TV,  PV=@PV,  Pevicardium=@Pevicardium"+
",  Aorta=@Aorta,  PAs=@PAs,  PDA=@PDA,  ASept=@ASept,  VSept=@VSept,  Sys=@Sys,  Pulm=@Pulm,  Mitral=@Mitral,  Aortic=@Aortic,  Tricuspid=@Tricuspid," +
"  Impression=@Impression, Plan=@Plan,Ordering=@Ordering,County=@County,Primary1=@Primary,Pager=@Pager" +
                    " WHERE ID=@ID;";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    Ordering=ddlOrdering.SelectedValue,
                    County=ddlCounty.SelectedValue,
                    Primary=txtPrimary.Text,
                    Pager=txtPhone.Text,
                    UpdatedBy = HttpContext.Current.Session["ID"].ToString(),
                    History = txtHistory.Text,
                    NYHA = rdbNYHA.SelectedValue,
                    Medications = txtDrugs.Text,
                    Durabiotic = rdbDurabiotic.SelectedValue,
                    Last = last,
                    Drug = txtDrug.Text,
                    PMHx = txtPMHx.Text,
                    FHx = txtFHx.Text,
                    SH = txtSH.Text,
                    ROS = txtROS.Text,
                    HR = txtHR.Text,
                    RR = txtRR.Text,
                    BP = txtBP.Text,
                    SAT = txtSAT.Text,
                    Temp = txtTemp.Text,
                    General = txtGeneral.Text,
                    Heart = txtHeart.Text,
                    Lungs = txtLungs.Text,
                    Abdomen = txtAbdomen.Text,
                    Extremities = txtExtremities.Text,
                    Chest = txtChest.Text,
                    Laboratory = txtLaboratory.Text,
                    ECG = txtECG.Text,
                    Indication = txtIndication.Text,
                    SONO = ddlSONO.SelectedValue,
                    LA = txtLA.Text,
                    LV = txtLV.Text,
                    LVd = txtLVd.Text,
                    LVs = txtLVs.Text,

                    SF = txtSF.Text,
                    EF = txtEF.Text,
                    RA = txtRA.Text,
                    RV = txtRV.Text,
                    AV = txtAV.Text,
                    MV = txtMV.Text,
                    TV = txtTV.Text,
                    PV = txtPV.Text,
                    Pevicardium = txtPevicardium.Text,
                    Aorta = txtAorta.Text,
                    PAs = txtPAs.Text,
                    PDA = txtPDA.Text,
                    ASept = txtASept.Text,
                    VSept = txtVSept.Text,
                    Sys = txtSysvv.Text,
                    Pulm = txtPulmvv.Text,
                    Mitral = txtMitral.Text,
                    Aortic = txtAortic.Text,
                    Tricuspid = txtTricuspid.Text,
                    Impression = txtImpression.Text,
                    Plan = txtPlan.Text,
                   
                    Date = date,
                    Time = time,
                    
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