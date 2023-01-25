
using System;
using System.Collections.Generic;
using System.Linq;

using System.Data;
using System.Text;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;


public partial class Design_Store_DrugReactionReportingForm : System.Web.UI.Page
{
    public static string patientid{get;set;}
    protected void Page_Load(object sender, EventArgs e)
    {
        
        ViewState["PID"] = Util.GetString(Request.QueryString["PID"]);
       
        if (!IsPostBack)
        {
            
            patientid = "0";
            BindDetails(ViewState["PID"].ToString());     
           
        }
        
        calExtenderToDate.EndDate = DateTime.Now;
        calExtenderFromDate.EndDate = DateTime.Now;
        
        txtDate.Attributes.Add("readOnly", "true");
        txtDateOfReaction.Attributes.Add("readOnly", "true");
        txtStartDate.Attributes.Add("readOnly", "true");
        txtStoppedDate.Attributes.Add("readOnly", "true");
        
        string hasrows = StockReports.ExecuteScalar("SELECT count(*) FROM  `patientdrugreactionform` where ID='" + patientid + "'");
        if (Session["UserName"] != null)
        {
            txtPersonReporting.Text = Session["UserName"].ToString();
        }
        string designation = StockReports.ExecuteScalar("SELECT Desi_Name FROM  `employee_master` where EmployeeID='" + Session["ID"].ToString() + "'");
        txtDesignation.Text = designation;
        string empname = StockReports.ExecuteScalar("SELECT NAME FROM  `employee_master` where EmployeeID='" + Session["ID"].ToString() + "'");
        txtPersonReporting.Text = empname;

        txtDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");

        ((TextBox)StartTime.FindControl("txtTime")).Text = Util.GetDateTime(DateTime.Now).ToString("hh:mm tt");

        string gender = StockReports.ExecuteScalar("SELECT Gender FROM  `patient_master` where PatientID='" + ViewState["PID"].ToString()+ "'");
        if (gender.ToLower() == "female")
        {

            rdbPregnancyStatus.Enabled = true;
        }
        else
        {

            rdbPregnancyStatus.Enabled = false;
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
    protected void grdPhysical_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {
             patientid=e.CommandName;
             string hasrows = StockReports.ExecuteScalar("SELECT count(*) FROM  `patientdrugreactionform` where PatientID='" + patientid + "'");
             if (hasrows != "0")
             {
                // btnPrint.Enabled = true;
             }
        
             int id = Convert.ToInt16(e.CommandArgument.ToString());
             spanPatInfoID.InnerText = ((Label)grdPhysical.Rows[id].FindControl("lblID")).Text;

             string patid = StockReports.ExecuteScalar("SELECT PatientID FROM  `patientdrugreactionform` where ID='" + spanPatInfoID.InnerText + "' ");

             if (e.CommandName == "Print")
             {
                 //Response.Redirect("/printDrugReactionReport_pdf.aspx?TestID=O23&LabType=&LabreportType=11&PID=" + patientid + "");
                 ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", " window.open('../../Design/Store/printDrugReactionReport_pdf.aspx?TestID=O23&LabType=&LabreportType=11&PID=" + spanPatInfoID.InnerText + "');", true);
        
             }
             if (e.CommandName == "Del")
             {
                 MySqlConnection con = new MySqlConnection();
                 con = Util.GetMySqlCon();
                 con.Open();
                 MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
                 try
                 {

                     MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "Delete  from `patientdrugreactionmedicine`   where RefID='" + spanPatInfoID.InnerText + "' ");
                     MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "Delete  from `patientdrugreactionform`   where ID='" + spanPatInfoID.InnerText + "' ");
                     tranX.Commit();
                     ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", " alert('Record deleted successfully');", true);
        
                 }
                 catch (Exception ex)
                 {
                     tranX.Rollback();
                     ClassLog cl = new ClassLog();
                     cl.errLog(ex);

                 }
                 finally
                 {
                     tranX.Dispose();
                     con.Close();
                     con.Dispose();
                 }

                 BindDetails(patid);
             }
            
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
    public void BindDetails(string pid)
    {
        try
        {

            StringBuilder sb = new StringBuilder();
            sb.Append("Select *,DATE_FORMAT(Date,'%d-%b-%Y') AS Date1,(Select pm.PName from Patient_master pm where pm.PatientID=pdf.PatientID order by pm.ID desc LIMIT 1) as Name  from  patientdrugreactionform pdf");
            if (pid != "")
            {
                sb.Append(" where PatientId='" + pid + "' ");
            }
            sb.Append(" order by ID desc");
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

    [WebMethod]
    public static string BindPatientInfo(string PID)
    {
        StringBuilder sb = new StringBuilder();
        //sb.Append("SELECT *,TIME_FORMAT(tm.Time,'%h:%i %p') Time1,'' as Name,CIN.Id as CId,(SELECT Name 	FROM 	employee_master  WHERE  EmployeeId=CIN.CreatedBy LIMIT 0, 1) AS CreatedBy1 FROM  time_master tm LEFT JOIN  cardiac_intakeoutput CIN ON tm.Time=CIN.Time AND CIN.Date='" + Convert.ToDateTime(Util.GetDateTime(Date)).ToString("yyyy-MM-dd") + "' and CIN.TransactionId='" + TransID + "'  ORDER BY tm.Id");
        sb.Append("SELECT *,DATE_FORMAT(Date,'%d-%b-%Y') AS Date1,DATE_FORMAT(OnSetReactionDate,'%d-%b-%Y') AS OnSetReactionDate1 FROM  `patientdrugreactionform` where ID='" + PID + "'");
        DataTable dtDetails = StockReports.GetDataTable(sb.ToString());
        if (dtDetails.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtDetails);
        }
        return "";
    }

    [WebMethod]
    public static string BindDrugList(string PID)
    {
        StringBuilder sb = new StringBuilder();
        //sb.Append("SELECT *,TIME_FORMAT(tm.Time,'%h:%i %p') Time1,'' as Name,CIN.Id as CId,(SELECT Name 	FROM 	employee_master  WHERE  EmployeeId=CIN.CreatedBy LIMIT 0, 1) AS CreatedBy1 FROM  time_master tm LEFT JOIN  cardiac_intakeoutput CIN ON tm.Time=CIN.Time AND CIN.Date='" + Convert.ToDateTime(Util.GetDateTime(Date)).ToString("yyyy-MM-dd") + "' and CIN.TransactionId='" + TransID + "'  ORDER BY tm.Id");
        sb.Append("SELECT *,DATE_FORMAT(DateStarted,'%d-%b-%Y') AS DateStarted1,DATE_FORMAT(DateStopped,'%d-%b-%Y') AS DateStopped1 FROM  `patientdrugreactionmedicine` where RefID='" + PID + "'");
        DataTable dtDetails = StockReports.GetDataTable(sb.ToString());
        if (dtDetails.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtDetails);
        }
        return "";
    }
    protected void btnPrint_Click(object sender, EventArgs e)
    {
        string pid = ViewState["PID"].ToString();
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", " window.open('../../Design/Store/printDrugReactionReport_pdf.aspx?TestID=O23&LabType=&LabreportType=11&PID="+  patientid+"');", true);
        
    }
    [WebMethod(EnableSession = true, Description = "Save Data")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveData(object DrugList, string PID, string TID,string DID,object PatientInfo)
    {
        List<PatientDrugReactionMedicine> drugs = new JavaScriptSerializer().ConvertToType<List<PatientDrugReactionMedicine>>(DrugList);
        List<PatientDrugReactionForm> patinfo = new JavaScriptSerializer().ConvertToType<List<PatientDrugReactionForm>>(PatientInfo);
        if (drugs.Count > 0 && patinfo.Count==1)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                string refid = "";
                if ((patinfo[0].ID == null) || (patinfo[0].ID == ""))
                {
                    refid = StockReports.ExecuteScalar("SELECT AUTO_INCREMENT FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'tenwek' AND TABLE_NAME = 'patientdrugreactionform'");
                    string dt = Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd");
                    string dt1 = Util.GetDateTime(DateTime.Now).ToString("hh:mm tt");
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO `patientdrugreactionform` (  `ReportType`,  `AnyKnownAllergy`,  `AnyKnownAllerySpecify`,  `PregnancyStatus`," +
                    "  `Weight`,  `Height`,  `Diagnosis`,  `OnSetReactionDate`,  `Description`,  `SeverityOfReaction`,  `ActionTaken`,  `Outcome`,  `CausalityOfReaction`,  `Comment`,  `ReportingPersonName`," +
                 " `Date`,  `EmailAddress`,  `PhoneNo`,  `Designation`,  `PatientID`,`TransactionID`,`DoctorID`,`Time`) VALUES  (        '" + patinfo[0].ReportType + "',    '" + patinfo[0].AnyKnownAllergy + "', " +
                 "'" + patinfo[0].AnyKnownAllerySpecify + "',    '" + patinfo[0].PregnancyStatus + "'," +
                "    '" + patinfo[0].Weight + "',    '" + patinfo[0].Height + "',    '" + patinfo[0].Diagnosis + "',    '" + Util.GetDateTime(patinfo[0].OnSetReactionDate).ToString("yyyy-MM-dd") + "',    '" + patinfo[0].Description + "',  " +
                "'" + patinfo[0].SeverityOfReaction + "',    '" + patinfo[0].ActionTaken + "',    '" + patinfo[0].Outcome + "'," +
                "    '" + patinfo[0].CausalityOfReaction + "',    '" + patinfo[0].Comment + "',    '" + patinfo[0].ReportingPersonName + "',    '" +dt + "',  " +
                "'" + patinfo[0].EmailAddress + "',    '" + patinfo[0].PhoneNo + "',    '" + patinfo[0].Designation + "',    '" + PID + "','"+TID+"','"+DID+"'" +
                ",   '" + dt1 + "'  );");

                }
                else
                {
                    if (refid == "")
                    {
                        refid = patinfo[0].ID;
                    }
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE  `patientdrugreactionform` SET  `ReportType`='" + patinfo[0].ReportType + "',  `AnyKnownAllergy`='" + patinfo[0].AnyKnownAllergy + "'" +
                    ",  `AnyKnownAllerySpecify`='" + patinfo[0].AnyKnownAllerySpecify + "',  `PregnancyStatus`='" + patinfo[0].PregnancyStatus + "'," +
                       "  `Weight`= '" + patinfo[0].Weight + "',  `Height`='" + patinfo[0].Height + "',  `Diagnosis`=  '" + patinfo[0].Diagnosis + "', " +
                       "`OnSetReactionDate`=   '" + Util.GetDateTime(patinfo[0].OnSetReactionDate).ToString("yyyy-MM-dd") + "',  `Description`= '" + patinfo[0].Description + "'," +
                       "`SeverityOfReaction`='" + patinfo[0].SeverityOfReaction + "',  `ActionTaken`= '" + patinfo[0].ActionTaken + "',  `Outcome`= '" + patinfo[0].Outcome + "'," +
                       "`CausalityOfReaction`= '" + patinfo[0].CausalityOfReaction + "',  `Comment`=   '" + patinfo[0].Comment + "',  `ReportingPersonName`=  '" + patinfo[0].ReportingPersonName + "'," +
                    " `Date`= '" + Util.GetDateTime(patinfo[0].Date).ToString("yyyy-MM-dd") + "',  `EmailAddress`='" + patinfo[0].EmailAddress + "',  `PhoneNo`='" + patinfo[0].PhoneNo + "'" +
                    ",  `Designation`= '" + patinfo[0].Designation + "',  `PatientID`= '" + PID + "' where ID='"+patinfo[0].ID+"'");

                }
                for (int i = 0; i < drugs.Count; i++)
                {
                    if ((drugs[i].ID==null )||(drugs[i].ID== ""))
                    {
                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO `patientdrugreactionmedicine` (  `DrugName`,  `BrandName`,  `Dose`,  `RouteAndFrequency`,  `DateStarted`," +
            "`DateStopped`,  `Indication`,  `PatientID`,`SuspectedDrug` , `Date`,  `TransactionID`,`RefID`) VALUES  (    '"+drugs[i].DrugName+"',    '"+drugs[i].BrandName+"',    '"+drugs[i].Dose+"',    "+
            "'" + drugs[i].RouteAndFrequency + "',    '" + Util.GetDateTime(drugs[i].DateStarted).ToString("yyyy-MM-dd") + "',    '" + Util.GetDateTime(drugs[i].DateStopped).ToString("yyyy-MM-dd") + "'," +
            "'" + drugs[i].Indication + "',    '" + PID + "', '" + drugs[i].SuspectedDrug + "',   '" + Util.GetDateTime(drugs[i].Date).ToString("yyyy-MM-dd") + "',    '" + TID + "' ,'"+refid+"' );");

                       
                    }
                    else if ((drugs[i].ID !=null) && (drugs[i].ID!=""))
                    {
                        if (drugs[i].IsDeleted == "1")
                        {
                            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "Delete  from `patientdrugreactionmedicine`   where ID='" + drugs[i].ID + "' ");

                        }
                        else
                        {
                            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE  `patientdrugreactionmedicine` SET  `DrugName`= '" + drugs[i].DrugName + "'" +
                            ",  `BrandName`='" + drugs[i].BrandName + "',  `Dose`= '" + drugs[i].Dose + "',  `RouteAndFrequency`='" + drugs[i].RouteAndFrequency + "'" +
                            ",  `DateStarted`='" + Util.GetDateTime(drugs[i].DateStarted).ToString("yyyy-MM-dd") + "'," +
                "`DateStopped`='" + Util.GetDateTime(drugs[i].DateStopped).ToString("yyyy-MM-dd") + "',  `Indication`='" + drugs[i].Indication + "',  `PatientID`='" + PID + "',  `Date`= '" + Util.GetDateTime(drugs[i].Date).ToString("yyyy-MM-dd") + "'  " +
                  ",  `TransactionID`=   '" + TID + "'  where ID='" + drugs[i].ID + "' ");
                        }
                    }
                }
                tranX.Commit();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully" });
 
            }
            catch (Exception ex)
            {
                tranX.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator" });
 
            }
            finally
            {
                tranX.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator" });

        }
    }
    class PatientDrugReactionForm
    {
        public string ID { get; set; }
        public string ReportType { get; set; }
        public string AnyKnownAllergy { get; set; }
        public string AnyKnownAllerySpecify { get; set; }
        public string PregnancyStatus { get; set; }
        public string Weight { get; set; }
        public string Height { get; set; }
        public string Diagnosis { get; set; }
        public string OnSetReactionDate { get; set; }
        public string Description { get; set; }
        public string SeverityOfReaction { get; set; }
        public string ActionTaken { get; set; }
        public string Outcome { get; set; }
        public string CausalityOfReaction { get; set; }
        public string Comment { get; set; }
        public string ReportingPersonName { get; set; }
        public string Date { get; set; }
        public string Time { get; set; }
        public string EmailAddress { get; set; }
        public string PhoneNo { get; set; }
        public string Designation { get; set; }
        public string PatientID { get; set; }
    }
    class PatientDrugReactionMedicine
    {
        public string ID { get; set; }
        public string DrugName { get; set; }
        public string BrandName { get; set; }
        public string Dose { get; set; }
        public string RouteAndFrequency { get; set; }
        public string DateStarted { get; set; }
        public string DateStopped { get; set; }
        public string Indication { get; set; }
        public string PatientID { get; set; }
        public string Date { get; set; }
        public string SuspectedDrug { get; set; }
        public string IsDeleted { get; set; }
        
    }
}