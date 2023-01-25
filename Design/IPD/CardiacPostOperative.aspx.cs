
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


public partial class Design_IPD_CardiacPostOperative : System.Web.UI.Page
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

            sb.Append("		SELECT 8 TypeID,'Country' TypeName,NAME AS TextField,CountryID AS ValueField"+
		", '' Department,CountryID,0 StateID,0 DistrictID,0 CityID ,STD_CODE, '' referDoctorID,'' defaultDoctor"+
		" FROM country_master WHERE IsActive=1");


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
            //txtSONO.Text = entryby; 
            ddlSONO.SelectedValue = Session["ID"].ToString();
            BindDetails(ViewState["PID"].ToString(), ViewState["TID"].ToString());
            string height = StockReports.ExecuteScalar(" SELECT Height  FROM IPD_Patient_ObservationChart cv   WHERE transactionid='" + ViewState["TID"].ToString() + "' order by ID desc LIMIT  1");
            if (height != "0")
            {
                lblHeight.Text = height;
            }
            string weight = StockReports.ExecuteScalar(" SELECT  Weight  FROM IPD_Patient_ObservationChart cv   WHERE transactionid='" + ViewState["TID"].ToString() + "' order by ID desc LIMIT  1");
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
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", " window.open('./CardiacPostOperative_PDF.aspx?TestID=O23&LabType=&LabreportType=11&ID=" + ID1 + "&TID=" + ViewState["TID"].ToString() + "');", true);

            
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
               ddlSONO.SelectedValue = rows[0]["SONO"].ToString();
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

               txtAV1.Text = rows[0]["AV1"].ToString();
               txtAV2.Text = rows[0]["AV2"].ToString();
               txtAV3.Text = rows[0]["AV3"].ToString();
               txtAV4.Text = rows[0]["AV4"].ToString();
               txtAV5.Text = rows[0]["AV5"].ToString();
               txtAV6.Text = rows[0]["AV6"].ToString();
               txtAV7.Text = rows[0]["AV7"].ToString();
               txtAV8.Text = rows[0]["AV8"].ToString();
               txtAV9.Text = rows[0]["AV9"].ToString();
               txtAV10.Text = rows[0]["AV10"].ToString();

               txtMV1.Text = rows[0]["MV1"].ToString();
               txtMV2.Text = rows[0]["MV2"].ToString();
               txtMV3.Text = rows[0]["MV3"].ToString();
               txtMV4.Text = rows[0]["MV4"].ToString();
               txtMV5.Text = rows[0]["MV5"].ToString();
               txtMV6.Text = rows[0]["MV6"].ToString();
               txtMV7.Text = rows[0]["MV7"].ToString();
               txtMV8.Text = rows[0]["MV8"].ToString();
               txtMV9.Text = rows[0]["MV9"].ToString();
               txtMV10.Text = rows[0]["MV10"].ToString();

               txtPV1.Text = rows[0]["PV1"].ToString();
               txtPV2.Text = rows[0]["PV2"].ToString();
               txtPV3.Text = rows[0]["PV3"].ToString();
               txtPV4.Text = rows[0]["PV4"].ToString();
               txtPV5.Text = rows[0]["PV5"].ToString();
               txtPV6.Text = rows[0]["PV6"].ToString();
               txtPV7.Text = rows[0]["PV7"].ToString();
               txtPV8.Text = rows[0]["PV8"].ToString();
               txtPV9.Text = rows[0]["PV9"].ToString();
               txtPV10.Text = rows[0]["PV10"].ToString();

               txtTV1.Text = rows[0]["TV1"].ToString();
               txtTV2.Text = rows[0]["TV2"].ToString();
               txtTV3.Text = rows[0]["TV3"].ToString();
               txtTV4.Text = rows[0]["TV4"].ToString();
               txtTV5.Text = rows[0]["TV5"].ToString();
               txtTV6.Text = rows[0]["TV6"].ToString();
               txtTV7.Text = rows[0]["TV7"].ToString();
               txtTV8.Text = rows[0]["TV8"].ToString();
               txtTV9.Text = rows[0]["TV9"].ToString();
               txtTV10.Text = rows[0]["TV10"].ToString();
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
            sb.Append(" Select *,pmh.Type,pmh.transNo,lt.EncounterNo,IF(pmh.Type='IPD',pmh.TransNo,lt.EncounterNo)EncounterNo1,(SELECT CONCAT(title,' ',NAME) FROM Employee_master WHERE EmployeeID=iu.CreatedBy)EmpName,DATE_FORMAT(LAST, '%d %b %Y') AS Last1," +
"DATE_FORMAT(iu.Date, '%d %b %Y') AS Date1,TIME_FORMAT(iu.Time, '%h:%i %p') AS Time1 FROM  CardiacPostOperative iu INNER JOIN" +
" patient_medical_history pmh ON pmh.TransactionID=iu.TransactionID INNER JOIN f_ledgertransaction lt ON lt.LedgertransactionNo=iu.TransactionID  where iu.PatientID='" + PID + "'  ");
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
            
            var sqlCMD = "INSERT INTO CardiacPostOperative ("+
  
  "Date,  Time,  History,  NYHA,Medications,  Durabiotic,  Last,  Drug,  PMHx,  FHx,  SH,  ROS,  HR,  RR,  BP,  SAT,  Temp,  General,  Heart,  Lungs,  Abdomen,  Extremities,  Chest,  Laboratory,"+
"  ECG,  Indication,  SONO,  LA,  LV,  LVd,  LVs,  SF,  EF,  RA,  RV,  AV,  MV,  TV,  PV,  Pevicardium,  Aorta,  PAs,  PDA,  ASept,  VSept,  Sys,  Pulm,  Mitral,  Aortic,  Tricuspid,"+
"  Impression, Plan,  CreatedBy,  CreatedDate,   PatientID,  TransactionID,Ordering,County,Primary1,   AV1,    AV2,   AV3,    AV4,    AV5,    AV6,    AV7,    AV8,    AV9,    AV10,    MV1,"+
"    MV2,    MV3,    MV4,    MV5,    MV6,    MV7,    MV8,    MV9,    MV10,    PV1,    PV2,    PV3,    PV4,    PV5,    PV6,    PV7,    PV8,    PV9,    PV10,    TV1,    TV2,    TV3,    TV4,"+
"    TV5,    TV6,   TV7,    TV8,    TV9,    TV10,Pager,Weight,Height)"+
" VALUES (       @Date,    @Time,    @History,    @NYHA, @Medications,   @Durabiotic,    @Last,    @Drug,    @PMHx,    @FHx,    @SH,    @ROS,    @HR,    @RR,    @BP,    @SAT,    @Temp,    @General," +
"    @Heart,    @Lungs,    @Abdomen,    @Extremities,    @Chest,    @Laboratory,    @ECG,    @Indication,    @SONO,    @LA,    @LV,    @LVd,    @LVs,    @SF,    @EF,    @RA,    @RV,"+
"    @AV,   @MV,    @TV,    @PV,    @Pevicardium,    @Aorta,    @PAs,    @PDA,    @ASept,    @VSept,    @Sys,    @Pulm,    @Mitral,    @Aortic,    @Tricuspid,   @Impression,"+
"    @Plan,    @CreatedBy,    NOW(),     @PatientID,    @TransactionID ,@Ordering,@County,@Primary,   @AV1,    @AV2,    @AV3,    @AV4,    @AV5,    @AV6,    @AV7,    @AV8,    @AV9,    @AV10,"+
"    @MV1,    @MV2,    @MV3,    @MV4,    @MV5,    @MV6,    @MV7,    @MV8,    @MV9,    @MV10,    @PV1,    @PV2,    @PV3,    @PV4,    @PV5,    @PV6,    @PV7,    @PV8,    @PV9,    @PV10,    @TV1,"+
"    @TV2,    @TV3,    @TV4,    @TV5,    @TV6,    @TV7,    @TV8,    @TV9,    @TV10,@Pager,@Weight,@Height );";       
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    Weight=lblWeight.Text,
                    Height=lblHeight.Text,
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
                       AV1=txtAV1.Text,
                AV2=txtAV2.Text,
                AV3=txtAV3.Text,
                AV4=txtAV4.Text,
                AV5=txtAV5.Text,
                AV6=txtAV6.Text,
                AV7=txtAV7.Text,
                AV8=txtAV8.Text,
                AV9=txtAV9.Text,
                AV10=txtAV10.Text,
                MV1=txtMV1.Text,
                MV2=txtMV2.Text,
                MV3=txtMV3.Text,
                MV4=txtMV4.Text,
                MV5=txtMV5.Text,
                MV6=txtMV6.Text,
                MV7=txtMV7.Text,
                MV8=txtMV8.Text,
                MV9=txtMV9.Text,
                MV10=txtMV10.Text,
                PV1=txtPV1.Text,
                PV2=txtPV2.Text,
                PV3=txtPV3.Text,
                PV4=txtPV4.Text,
                PV5=txtPV5.Text,
                PV6=txtPV6.Text,
                PV7=txtPV7.Text,
                PV8=txtPV8.Text,
                PV9=txtPV9.Text,
                PV10=txtPV10.Text,
                TV1=txtTV1.Text,
                TV2=txtTV2.Text,
                TV3=txtTV3.Text,
                TV4=txtTV4.Text,
                TV5=txtTV5.Text,
                TV6=txtTV6.Text,
                TV7=txtTV7.Text,
                TV8=txtTV8.Text,
                TV9=txtTV9.Text,
                    TV10=txtTV10.Text,
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

                    txtAV1.Text = "";
                    txtAV2.Text = "";
                    txtAV3.Text = "";
                    txtAV4.Text = "";
                    txtAV5.Text = "";
                    txtAV6.Text = "";
                    txtAV7.Text = "";
                    txtAV8.Text = "";
                    txtAV9.Text = "";
                    txtAV10.Text = "";

                    txtPV1.Text = "";
                    txtPV2.Text = "";
                    txtPV3.Text = "";
                    txtPV4.Text = "";
                    txtPV5.Text = "";
                    txtPV6.Text = "";
                    txtPV7.Text = "";
                    txtPV8.Text = "";
                    txtPV9.Text = "";
                    txtPV10.Text = "";

                    txtMV1.Text = "";
                    txtMV2.Text = "";
                    txtMV3.Text = "";
                    txtMV4.Text = "";
                    txtMV5.Text = "";
                    txtMV6.Text = "";
                    txtMV7.Text = "";
                    txtMV8.Text = "";
                    txtMV9.Text = "";
                    txtMV10.Text = "";

                    txtTV1.Text = "";
                    txtTV2.Text = "";
                    txtTV3.Text = "";
                    txtTV4.Text = "";
                    txtTV5.Text = "";
                    txtTV6.Text = "";
                    txtTV7.Text = "";
                    txtTV8.Text = "";
                    txtTV9.Text = "";
                    txtTV10.Text = "";

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
            var sqlCMD = "UPDATE CardiacPostOperative  set " +

 " Date=@Date,  Time=@Time, UpdatedBy=@UpdatedBy,UpdateDate=NOW(),  History=@History,  NYHA=@NYHA,Medications=@Medications,  Durabiotic=@Durabiotic,  Last=@Last,  Drug=@Drug,"+
 "PMHx=@PMHx,  FHx=@FHx,  SH=@SH,  ROS=@ROS,  HR=@HR,  RR=@RR,  BP=@BP,  SAT=@SAT,  Temp=@Temp,  General=@General,  Heart=@Heart,  Lungs=@Lungs,  Abdomen=@Abdomen, "+
 " Extremities=@Extremities,  Chest=@Chest,  Laboratory=@Laboratory," +
"  ECG=@ECG,  Indication=@Indication,  SONO=@SONO,  LA=@LA,  LV=@LV,  LVd=@LVd,  LVs=@LVs,  SF=@SF,  EF=@EF,  RA=@RA,  RV=@RV,  AV=@AV,  MV=@MV,  TV=@TV,  PV=@PV,  Pevicardium=@Pevicardium"+
",  Aorta=@Aorta,  PAs=@PAs,  PDA=@PDA,  ASept=@ASept,  VSept=@VSept,  Sys=@Sys,  Pulm=@Pulm,  Mitral=@Mitral,  Aortic=@Aortic,  Tricuspid=@Tricuspid," +
"  Impression=@Impression, Plan=@Plan,Ordering=@Ordering,County=@County,Primary1=@Primary," +
"  AV1=@AV1,    AV2=@AV2,   AV3=@AV3,    AV4=@AV4,    AV5=@AV5,    AV6=@AV6,    AV7=@AV7,    AV8=@AV8,    AV9=@AV9,    AV10=@AV10,    MV1=@MV1," +
"    MV2=@MV2,    MV3=@MV3,    MV4=@MV4,    MV5=@MV5,    MV6=@MV6,    MV7=@MV7,    MV8=@MV8,    MV9=@MV9,    MV10=@MV10, "+
"PV1=@PV1,    PV2=@PV2,    PV3=@PV3,    PV4=@PV4,    PV5=@PV5,    PV6=@PV6,    PV7=@PV7,    PV8=@PV8,    PV9=@PV9,    PV10=@PV10,    TV1=@TV1,    TV2=@TV2,    TV3=@TV3,    TV4=@TV4," +
"    TV5=@TV5,    TV6=@TV6,   TV7=@TV7,    TV8=@TV8,    TV9=@TV9,    TV10=@TV10,Pager=@Pager" +
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

                    AV1 = txtAV1.Text,
                    AV2 = txtAV2.Text,
                    AV3 = txtAV3.Text,
                    AV4 = txtAV4.Text,
                    AV5 = txtAV5.Text,
                    AV6 = txtAV6.Text,
                    AV7 = txtAV7.Text,
                    AV8 = txtAV8.Text,
                    AV9 = txtAV9.Text,
                    AV10 = txtAV10.Text,
                    MV1 = txtMV1.Text,
                    MV2 = txtMV2.Text,
                    MV3 = txtMV3.Text,
                    MV4 = txtMV4.Text,
                    MV5 = txtMV5.Text,
                    MV6 = txtMV6.Text,
                    MV7 = txtMV7.Text,
                    MV8 = txtMV8.Text,
                    MV9 = txtMV9.Text,
                    MV10 = txtMV10.Text,
                    PV1 = txtPV1.Text,
                    PV2 = txtPV2.Text,
                    PV3 = txtPV3.Text,
                    PV4 = txtPV4.Text,
                    PV5 = txtPV5.Text,
                    PV6 = txtPV6.Text,
                    PV7 = txtPV7.Text,
                    PV8 = txtPV8.Text,
                    PV9 = txtPV9.Text,
                    PV10 = txtPV10.Text,
                    TV1 = txtTV1.Text,
                    TV2 = txtTV2.Text,
                    TV3 = txtTV3.Text,
                    TV4 = txtTV4.Text,
                    TV5 = txtTV5.Text,
                    TV6 = txtTV6.Text,
                    TV7 = txtTV7.Text,
                    TV8 = txtTV8.Text,
                    TV9 = txtTV9.Text,
                    TV10 = txtTV10.Text,
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