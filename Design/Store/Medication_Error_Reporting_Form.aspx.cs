
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


public partial class Design_Store_Medication_Error_Reporting_Form : System.Web.UI.Page
{
    public static string patientid{get;set;}
    protected void Page_Load(object sender, EventArgs e)
    {
        
        ViewState["PID"] = Util.GetString(Request.QueryString["PID"]);
       
        if (!IsPostBack)
        {
            txtDateOnEvent.Text = Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy");
            txtDateOfReport.Text = Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy");
            string empname = StockReports.ExecuteScalar("SELECT NAME FROM  `employee_master` where EmployeeID='" + Session["ID"].ToString() + "'");
            txtNameofInitialreporter.Text = empname;

        }
        //calExtenderToDate.EndDate = DateTime.Now;
        //calExtenderFromDate.EndDate = DateTime.Now;
        
        


    }
    [WebMethod]
    public static string BindGrid1(string pid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT *,DATE_FORMAT(Date,'%d-%b-%Y') AS Date1,DATE_FORMAT(Dateofreport,'%d-%b-%Y') AS Dateofreport1,DATE_FORMAT(DateofSubmission,'%d-%b-%Y') AS DateofSubmission1  FROM medicationerrorreport where UHID='" + pid + "'");
        DataTable dtDetails = StockReports.GetDataTable(sb.ToString());
        if (dtDetails.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtDetails);
        }
        return "";
    }
  
    [WebMethod]
    public static string BindGrid2(string id)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT *,DATE_FORMAT(Date,'%d-%b-%Y') AS Date1,DATE_FORMAT(Dateofreport,'%d-%b-%Y') AS Dateofreport1,DATE_FORMAT(DateofSubmission,'%d-%b-%Y') AS DateofSubmission1 FROM medicationerrorreport where ID='" + id + "'");
        DataTable dtDetails = StockReports.GetDataTable(sb.ToString());
        if (dtDetails.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtDetails);
        }
        return "";
    }
  

    [WebMethod]
    public static string BindGrid()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT *,DATE_FORMAT(Date,'%d-%b-%Y') AS Date1,DATE_FORMAT(Dateofreport,'%d-%b-%Y') AS Dateofreport1,DATE_FORMAT(DateofSubmission,'%d-%b-%Y') AS DateofSubmission1  FROM medicationerrorreport order by ID desc");
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
    public static string SaveData(object data)
    {
        List<MedicationErrorReport> datalist = new JavaScriptSerializer().ConvertToType<List<MedicationErrorReport>>(data);
        if (datalist.Count > 0 && datalist.Count == 1)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                string refid = "";
                if ((datalist[0].ID == null) || (datalist[0].ID == ""))
                {
                    string date = Util.GetDateTime(datalist[0].Date).ToString("yyyy-MM-dd");
                    string time = Util.GetDateTime(datalist[0].Time).ToString("hh:mm tt");
                    
                    string dateofreport = Util.GetDateTime(datalist[0].Dateofreport).ToString("yyyy-MM-dd");
                    
                    string dateofsubmission = Util.GetDateTime(datalist[0].DateofSubmission).ToString("yyyy-MM-dd");
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO `medicationerrorreport` ("+
  "  `Date`,  `Time`,  `InstitutionName`,  `Contact`,  `FacilityCode`,  `County`,  `UHID`,  `PatientInitials`,  `DOBAge`,  `Gender`,  `LocationOfEvent`,  `LocationSpecify`,  `ErrorDesc`,"+
 " `ProcessErrorOccured`,  `ErrorReachPatient`,  `IsCorrectMedicineTaken`,  `DirectResultOnPatient`,  `ErrorOutcomeCategory`,  `Inexperiencedpersonnel`,  `Inadequateknowledge`,  `Distraction`,"+
"  `Heavyworkload`,  `Peakhour`,  `Stockarrangementsstorageproblem`,  `Failuretoadheretoworkprocedure`,  `Useofabbreviations`,  `Illegibleprescriptions`,"+
"`Patientinformationrecordunavailableinaccurate`,  `Wronglabelling`,  `Incorrectcomputerentry`,  `Others`,  `OthersSpecify`,  `GenericName1`,  `GenrnicName2`,  `BrandName1`,"+
"  `BrandName2`,  `DosageFrom1`,  `DosageFrom2`,  `DoseFrequency1`,  `DoseFrequency2`,  `Manufacturer1`,  `Manufacturer2`,  `Strengthconcentration1`,  `Strengthconcentration2`,"+
"  `Typeandsizeofcontainer1`,  `Typeandsizeofcontainer2`,  `recommendations`,  `NameofInitialreporter`,  `Cadredesignation1`,  `Mobileno1`,  `Email1`,  `Dateofreport`,  `Name2`,"+
"  `Cadredesignation2`,  `Mobileno2`,  `Email2`,  `DateofSubmission`) "+
" VALUES  (      '"+date+"',   ' "+time+"',    '"+datalist[0].InstitutionName+"',    '"+datalist[0].Contact+"',  '"+datalist[0].FacilityCode+"',    '"+datalist[0].County+"',"+
"    '"+datalist[0].UHID+"',    '"+datalist[0].PatientInitials+"',    '"+datalist[0].DOBAge+"',    '"+datalist[0].Gender+"',    '"+datalist[0].LocationOfEvent+"',    '"+datalist[0].LocationSpecify+"',"+
"    '"+datalist[0].ErrorDesc+"',    '"+datalist[0].ProcessErrorOccured+"',    '"+datalist[0].ErrorReachPatient+"',    '"+datalist[0].IsCorrectMedicineTaken+"',    '"+datalist[0].DirectResultOnPatient+"',"+
"    '"+datalist[0].ErrorOutcomeCategory+"',    '"+datalist[0].Inexperiencedpersonnel+"',    '"+datalist[0].Inadequateknowledge+"',    '"+datalist[0].Distraction+"',    '"+datalist[0].Heavyworkload+"',"+
    "'"+datalist[0].Peakhour+"',    '"+datalist[0].Stockarrangementsstorageproblem+"',    '"+datalist[0].Failuretoadheretoworkprocedure+"',    '"+datalist[0].Useofabbreviations+"',"+
"    '"+datalist[0].Illegibleprescriptions+"',  '"+datalist[0].Patientinformationrecordunavailableinaccurate+"',    '"+datalist[0].Wronglabelling+"',    '"+datalist[0].Incorrectcomputerentry+"',"+
"    '"+datalist[0].Others+"',    '"+datalist[0].OthersSpecify+"',    '"+datalist[0].GenericName1+"',    '"+datalist[0].GenrnicName2+"',    '"+datalist[0].BrandName1+"',    '"+datalist[0].BrandName2+"',"+
"    '"+datalist[0].DosageFrom1+"',    '"+datalist[0].DosageFrom2+"',    '"+datalist[0].DoseFrequency1+"',    '"+datalist[0].DoseFrequency2+"',    '"+datalist[0].Manufacturer1+"',    '"+datalist[0].Manufacturer2+"',"+
  " '"+datalist[0].Strengthconcentration1+"',    '"+datalist[0].Strengthconcentration2+"',    '"+datalist[0].Typeandsizeofcontainer1+"',    '"+datalist[0].Typeandsizeofcontainer2+"',    '"+datalist[0].recommendations+"',"+
"    '"+datalist[0].NameofInitialreporter+"',    '"+datalist[0].Cadredesignation1+"',    '"+datalist[0].Mobileno1+"',    '"+datalist[0].Email1+"',    '"+dateofreport+"',    '"+datalist[0].Name2+"',"+
"    '"+datalist[0].Cadredesignation2+"',    '"+datalist[0].Mobileno2+"',    '"+datalist[0].Email2+"',    '"+dateofsubmission+"'  );");

                }
                else
                {
                    string date = Util.GetDateTime(datalist[0].Date).ToString("yyyy-MM-dd");
                    string time = Util.GetDateTime(datalist[0].Time).ToString("hh:mm tt");

                    string dateofreport = Util.GetDateTime(datalist[0].Dateofreport).ToString("yyyy-MM-dd");

                    string dateofsubmission = Util.GetDateTime(datalist[0].DateofSubmission).ToString("yyyy-MM-dd");
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE  `medicationerrorreport` set " +
  "  `Date`= '" + date + "',  `Time`= ' " + time + "',  `InstitutionName`='" + datalist[0].InstitutionName + "',  `Contact`='" + datalist[0].Contact + "',  `FacilityCode`='" + datalist[0].FacilityCode + "'"+
                    ",  `County`='" + datalist[0].County + "',  `UHID`=  '" + datalist[0].UHID + "',  `PatientInitials`=  '" + datalist[0].PatientInitials + "',  `DOBAge`='" + datalist[0].DOBAge + "'"+
                    ",  `Gender`='" + datalist[0].Gender + "',  `LocationOfEvent`= '" + datalist[0].LocationOfEvent + "',  `LocationSpecify`='" + datalist[0].LocationSpecify + "'"+
                    ",  `ErrorDesc`='" + datalist[0].ErrorDesc + "'," +
 " `ProcessErrorOccured`='" + datalist[0].ProcessErrorOccured + "',  `ErrorReachPatient`= '" + datalist[0].ErrorReachPatient + "',  `IsCorrectMedicineTaken`='" + datalist[0].IsCorrectMedicineTaken + "'"+
                    ",  `DirectResultOnPatient`='" + datalist[0].DirectResultOnPatient + "',  `ErrorOutcomeCategory`= '" + datalist[0].ErrorOutcomeCategory + "'"+
                    ",  `Inexperiencedpersonnel`=  '" + datalist[0].Inexperiencedpersonnel + "',  `Inadequateknowledge`= '" + datalist[0].Inadequateknowledge + "',  `Distraction`=   '" + datalist[0].Distraction + "'," +
"  `Heavyworkload`= '" + datalist[0].Heavyworkload + "',  `Peakhour`='" + datalist[0].Peakhour + "',  `Stockarrangementsstorageproblem`= '" + datalist[0].Stockarrangementsstorageproblem + "'"+
                    ",  `Failuretoadheretoworkprocedure`=  '" + datalist[0].Failuretoadheretoworkprocedure + "',  `Useofabbreviations`= '" + datalist[0].Useofabbreviations + "'"+
                    ",  `Illegibleprescriptions`= '" + datalist[0].Illegibleprescriptions + "'," +
"`Patientinformationrecordunavailableinaccurate`= '" + datalist[0].Patientinformationrecordunavailableinaccurate + "',  `Wronglabelling`=   '" + datalist[0].Wronglabelling + "'"+
                    ",  `Incorrectcomputerentry`=   '" + datalist[0].Incorrectcomputerentry + "',  `Others`= '" + datalist[0].Others + "',  `OthersSpecify`= '" + datalist[0].OthersSpecify + "'"+
                    ",  `GenericName1`=   '" + datalist[0].GenericName1 + "',  `GenrnicName2`=  '" + datalist[0].GenrnicName2 + "',  `BrandName1`= '" + datalist[0].BrandName1 + "'," +
"  `BrandName2`=   '" + datalist[0].BrandName2 + "',  `DosageFrom1`='" + datalist[0].DosageFrom1 + "',  `DosageFrom2`=  '" + datalist[0].DosageFrom2 + "',  `DoseFrequency1`= '" + datalist[0].DoseFrequency1 + "'"+
                    ",  `DoseFrequency2`= '" + datalist[0].DoseFrequency2 + "',  `Manufacturer1`= '" + datalist[0].Manufacturer1 + "',  `Manufacturer2`=  '" + datalist[0].Manufacturer2 + "'"+
                    ",  `Strengthconcentration1`= '" + datalist[0].Strengthconcentration1 + "',  `Strengthconcentration2`= '" + datalist[0].Strengthconcentration2 + "'," +
"  `Typeandsizeofcontainer1`=  '" + datalist[0].Typeandsizeofcontainer1 + "',  `Typeandsizeofcontainer2`=   '" + datalist[0].Typeandsizeofcontainer2 + "',  `recommendations`=    '" + datalist[0].recommendations + "'"+
                    ",  `NameofInitialreporter`=  '" + datalist[0].NameofInitialreporter + "',  `Cadredesignation1`= '" + datalist[0].Cadredesignation1 + "',  `Mobileno1`=   '" + datalist[0].Mobileno1 + "'"+
                    ",  `Email1`= '" + datalist[0].Email1 + "',  `Dateofreport`=  '" + dateofreport + "',  `Name2`= '" + datalist[0].Name2 + "'," +
"  `Cadredesignation2`= '" + datalist[0].Cadredesignation2 + "',  `Mobileno2`='" + datalist[0].Mobileno2 + "',  `Email2`=  '" + datalist[0].Email2 + "',  `DateofSubmission`='" + dateofsubmission + "'  " +
" where ID='"+datalist[0].ID+"'    ;");

                }
                tranX.Commit();
        
                return "1";
            }
            catch (Exception ex)
            {
                tranX.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return "0";
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
            return "";
        }
    }
    class MedicationErrorReport
    {
        
  public string ID{get;set;}
  public string Date{get;set;}
  public string Time{get;set;}
  public string InstitutionName{get;set;}
  public string Contact{get;set;}
  public string FacilityCode{get;set;}
  public string County{get;set;}
  public string UHID{get;set;}
  public string PatientInitials{get;set;}
  public string DOBAge{get;set;}
  public string Gender{get;set;}
  public string LocationOfEvent{get;set;}
  public string LocationSpecify{get;set;}
  public string ErrorDesc{get;set;}
  public string ProcessErrorOccured{get;set;}
  public string ErrorReachPatient{get;set;}
  public string IsCorrectMedicineTaken{get;set;}
  public string DirectResultOnPatient{get;set;}
  public string ErrorOutcomeCategory{get;set;}
  public string Inexperiencedpersonnel{get;set;}
  public string Inadequateknowledge{get;set;}
  public string Distraction{get;set;}
  public string Heavyworkload{get;set;}
  public string Peakhour{get;set;}
  public string Stockarrangementsstorageproblem{get;set;}
  public string Failuretoadheretoworkprocedure{get;set;}
  public string Useofabbreviations{get;set;}
  public string Illegibleprescriptions{get;set;}
  public string Patientinformationrecordunavailableinaccurate{get;set;}
  public string Wronglabelling{get;set;}
  public string Incorrectcomputerentry{get;set;}
  public string Others{get;set;}
  public string OthersSpecify{get;set;}
  public string GenericName1{get;set;}
  public string GenrnicName2{get;set;}
  public string BrandName1{get;set;}
  public string BrandName2{get;set;}
  public string DosageFrom1{get;set;}
  public string DosageFrom2{get;set;}
  public string DoseFrequency1{get;set;}
  public string DoseFrequency2{get;set;}
  public string Manufacturer1{get;set;}
  public string Manufacturer2{get;set;}
  public string Strengthconcentration1{get;set;}
  public string Strengthconcentration2{get;set;}
  public string Typeandsizeofcontainer1{get;set;}
  public string Typeandsizeofcontainer2{get;set;}
  public string recommendations{get;set;}
  public string NameofInitialreporter{get;set;}
  public string Cadredesignation1{get;set;}
  public string Mobileno1{get;set;}
  public string Email1{get;set;}
  public string Dateofreport{get;set;}
  public string Name2{get;set;}
  public string Cadredesignation2{get;set;}
  public string Mobileno2{get;set;}
  public string Email2{get;set;}
  public string DateofSubmission{ get; set; } 
    }
}