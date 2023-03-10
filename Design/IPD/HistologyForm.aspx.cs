
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


public partial class Design_IPD_HistologyForm : System.Web.UI.Page
{
    private void FillClientDetails(string PID, string TID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" Select *,DATE_FORMAT(DOB, '%d %b %Y') as DOB1 from patient_master where PatientID='" + PID + "'");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {

            if (dt.Rows[0]["PName"].ToString() != "")
            {
                lblPatientName.Text = dt.Rows[0]["PName"].ToString();
            }
            if (PID != "")
            {
                lblUHID.Text = PID;
            }
            
            if (dt.Rows[0]["Age"].ToString() != "")
            {
                lblAge.Text = dt.Rows[0]["Age"].ToString();
            }
            if (dt.Rows[0]["Gender"].ToString() != "")
            {
                lblSex.Text = dt.Rows[0]["Gender"].ToString();
            }

            if (dt.Rows[0]["DOB1"].ToString() != "")
            {
                lblDOB.Text = dt.Rows[0]["DOB1"].ToString();
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
        FillClientDetails(ViewState["PID"].ToString(), ViewState["TID"].ToString());
        FillHeight();
       txtRequesting.Text = entryby;
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
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", " window.open('./HistologyForm_PDF.aspx?TestID=O23&LabType=&LabreportType=11&ID=" + ID1 + "&TID=" + ViewState["TID"].ToString() + "');", true);

            
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
                txtSpecimenDate.Text = ((Label)grdPhysical.Rows[id].FindControl("lblSpecimen")).Text;
                txtAnatomical.Text = ((Label)grdPhysical.Rows[id].FindControl("lblSite")).Text;
               txtLocation.Text = ((Label)grdPhysical.Rows[id].FindControl("lblLocation")).Text;
               txtMore.Text = ((Label)grdPhysical.Rows[id].FindControl("lblMore")).Text;
               txtOther.Text = ((Label)grdPhysical.Rows[id].FindControl("lblOther")).Text;
             txtSummary.Text = ((Label)grdPhysical.Rows[id].FindControl("lblSummary")).Text;
             txtImpression.Text = ((Label)grdPhysical.Rows[id].FindControl("lblImpression")).Text;
             txtSpecial.Text = ((Label)grdPhysical.Rows[id].FindControl("lblSpecial")).Text;
                if (((Label)grdPhysical.Rows[id].FindControl("lblSpecimenType")).Text != "")
                {
                    rdbSpecimenType.SelectedValue = ((Label)grdPhysical.Rows[id].FindControl("lblSpecimenType")).Text;
                }


                //txtTribe.Text = ((Label)grdPhysical.Rows[id].FindControl("lblTribe")).Text;
               // txtChief.Text = ((Label)grdPhysical.Rows[id].FindControl("lblChief")).Text;
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
            sb.Append(" Select *,(Select concat(title,' ',name) from Employee_master where EmployeeID=CreatedBy)EmpName,DATE_FORMAT(Specimen, '%d %b %Y') as Specimen1,DATE_FORMAT(Date, '%d %b %Y') as Date1,TIME_FORMAT(Time, '%h:%i %p') as Time1,TIMESTAMPDIFF(MINUTE,CreatedDate,NOW()) createdDateDiff from histologyform where PatientID='" + PID + "' and TransactionID='" + TID + "' order by ID desc ");
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

    public static string SaveData(string TransactionID, string PatientID, string Date, string Time, string InsertedBy, string Location, string LeftCatheterGauge, string Reason, string CleanedWith, string InsertionEase, string ComplianceLevel, string Appearence, string FlushedWith, string CheckedBy, string SaveType, string ID)
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

                var sqlCMD = "INSERT INTO `peripheralvenouscatheterinsertionchecklist` ( CreatedBy,CreatedDate, `Date`,  `Time`,  `InsertedBy`,  `Location`,  `LeftCatheterGauge`,  `Reason`,  `CatheterSiteCleanedWith`,  `InsertionEase`,  `ComplianceLevel`,  `Appearence`,  `FlushedWith`,  `CheckedBy`,PatientID,TransactionID) " +
" VALUES  (     @CreatedBy,NOW(),    @Date,   @Time,    @InsertedBy,    @Location,    @LeftCatheterGauge,    @Reason,    @CatheterSiteCleanedWith,    @InsertionEase,    @ComplianceLevel,    @Appearence,    @FlushedWith,    @CheckedBy ,@PatientID,@TransactionID );";       
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
                    TransactionID=TransactionID
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
            string specimendate = Util.GetDateTime(txtSpecimenDate.Text).ToString("yyyy-MM-dd");
            
            
                var sqlCMD = "INSERT INTO histologyform ("+
  
"  Date,  Time,  Specimen,  Location,  Site,  More,  SpecimenType,  Other,  Summary,  Impression,  Special,  CreatedBy, CreatedDate,  PatientID,  TransactionID)"+
" VALUES  (        @Date,    @Time,    @Specimen,    @Location,    @Site,    @More,    @SpecimenType,    @Other,    @Summary,    @Impression,    @Special,    @CreatedBy,    NOW(),"+
"    @PatientID,    @TransactionID  );";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    Date = date,
                    Time = time,
                    Specimen=specimendate,
                    Location=txtLocation.Text,
                    Site=txtAnatomical.Text,
                    More=txtMore.Text,
                    SpecimenType=rdbSpecimenType.SelectedValue,
                    Other=txtOther.Text,
                    Summary=txtSummary.Text,
                    Impression=txtImpression.Text,
                    Special=txtSpecial.Text,
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
        txtSpecimenDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
                    txtTime.Text = DateTime.Now.ToString("hh:mm tt");
                    txtAnatomical.Text = "";
                    txtLocation.Text = "";
                    txtMore.Text = "";
                    txtOther.Text = "";
                    txtSummary.Text = "";
                    txtImpression.Text ="";
                    txtSpecial.Text = "";
                        rdbSpecimenType.SelectedIndex = -1;
                    

                    
        //txtCheckedBy.Text = HttpContext.Current.Session["ID"].ToString();
    }
    protected void Radio1_Changed(object sender, EventArgs e)
    {
        
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
            string specimendate = Util.GetDateTime(txtSpecimenDate.Text).ToString("yyyy-MM-dd");

            var sqlCMD = "UPDATE histologyform SET Date=@Date,Time=@Time,UpdateDate=NOW(),UpdatedBy=@UpdatedBy,Specimen=@Specimen," +
                "Location=@Location,Site=@Site,More=@More,SpecimenType=@SpecimenType,Other=@Other,Summary=@Summary,Impression=@Impression,Special=@Special" +
                   
                    " WHERE ID=@ID;";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {

                    
                    UpdatedBy = HttpContext.Current.Session["ID"].ToString(),
                    Date = date,
                    Time = time,
                    Specimen = specimendate,
                    Location = txtLocation.Text,
                    Site = txtAnatomical.Text,
                    More = txtMore.Text,
                    SpecimenType = rdbSpecimenType.SelectedValue,
                    Other = txtOther.Text,
                    Summary = txtSummary.Text,
                    Impression = txtImpression.Text,
                    Special = txtSpecial.Text,
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