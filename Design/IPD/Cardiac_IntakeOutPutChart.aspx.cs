using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;

public partial class Design_ip_Cardiac_IntakeOutPutChart : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();
        if (!IsPostBack)
        {

            ViewState["ID"] = Session["ID"].ToString();
            ViewState["UserID"] = Session["ID"].ToString(); ;
            string a = ViewState["ID"].ToString();
            string TID = Request.QueryString["TransactionID"].ToString();

            ViewState["TransID"] = TID;
            dt = AllLoadData_IPD.getAdmitDischargeData(TID);
            caldate.StartDate = Util.GetDateTime(dt.Rows[0]["DateofAdmit"]);
            if (dt.Rows[0]["Status"].ToString() == "OUT")
            {
                caldate.EndDate = Util.GetDateTime(dt.Rows[0]["DateofDischarge"]);
            }
            else
            {
                caldate.EndDate = DateTime.Now;
            }
            txtDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            caldate.EndDate = DateTime.Now;
        }
        txtDate.Attributes.Add("readOnly", "true");
    }

    [WebMethod]
    public static string bindData(string TransID, string Date)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT *,TIME_FORMAT(tm.Time,'%h:%i %p') Time1,'' as Name,CIN.Id as CId,(SELECT Name 	FROM 	employee_master  WHERE  EmployeeId=CIN.CreatedBy LIMIT 0, 1) AS CreatedBy1 FROM  time_master tm LEFT JOIN  cardiac_intakeoutput CIN ON tm.Time=CIN.Time AND CIN.Date='" + Convert.ToDateTime(Util.GetDateTime(Date)).ToString("yyyy-MM-dd") + "' and CIN.TransactionId='" + TransID + "'  ORDER BY tm.Id");
        DataTable dtDetails = StockReports.GetDataTable(sb.ToString());
        if (dtDetails.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtDetails);
        }
        return "";
    }

    [WebMethod(EnableSession = true, Description = "Save Intake")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string saveIntake(object Intake, string PID, string TID)
    {
        List<Intake> intake = new JavaScriptSerializer().ConvertToType<List<Intake>>(Intake);
        if (intake.Count > 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                for (int i = 0; i < intake.Count; i++)
                {
                    if (intake[i].CreatedBy == "")
                    {
                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO `cardiac_intakeoutput` ("+
"  `MIVF`,  `Hourlydrips`,  `BloodBolus`,  `POintake`,  `POintake1`,  `HourTotal`,  `Cimulative`,  `CT1Level`,  `CT2Level`,  `CToutput`,  `Urine`,  `Stool`,  `Vomiting`,  `Hourstotal`,  `Cumulative`,  `CreatedBy`, `Date`,  `Time`,  `TransactionId`,  `PatientId`)" +
" VALUES  (      '" + intake[i].MIVF + "',    '" + intake[i].Hourlydrips + "',    '" + intake[i].BloodBolus + "',    '" + intake[i].POintake + "',    '" + intake[i].POintake1 + "',    '" + intake[i].HourTotal + "',    '" + intake[i].Cimulative +
"',    '"+intake[i].CT1Level+"',    '"+intake[i].CT2Level+"',    '"+intake[i].CToutput+"',    '"+intake[i].Urine+"',    '"+intake[i].Stool+"',    '"+intake[i].Vomiting+"',"+
"    '" + intake[i].Hourstotal + "',    '" + intake[i].Cumulative + "',    '" + HttpContext.Current.Session["ID"].ToString() + "',    '" + Util.GetDateTime(intake[i].Date).ToString("yyyy-MM-dd") + "',   '" + Util.GetDateTime(intake[i].Time).ToString("HH:mm:ss") + "',    '" + TID + "',    '" + intake[i].PatientId + "'  );");
                    }
                    else if (intake[i].CreatedBy != null || intake[i].CreatedBy != "")
                    {
                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "update cardiac_intakeoutput set "+
                            "  `MIVF` = '" + intake[i].MIVF + "',  `Hourlydrips` = '" + intake[i].Hourlydrips + "',  `BloodBolus` = '" + intake[i].BloodBolus + "',  `POintake` = '"+intake[i].POintake+
                        "',  `POintake1` = '"+intake[i].POintake1+"',  `HourTotal` = '"+intake[i].HourTotal+"'," +
"  `Cimulative` = '"+intake[i].Cimulative+"',  `CT1Level` = '"+intake[i].CT1Level+"',  `CT2Level` = '"+intake[i].CT2Level+"',  `CToutput` = '"+intake[i].CToutput+"',  `Urine` = '"+intake[i].Urine+
"',  `Stool` = '"+intake[i].Stool+"',"+
"  `Vomiting` = '"+intake[i].Vomiting+"',  `Hourstotal` = '"+intake[i].Hourstotal+"',  `Cumulative` = '"+intake[i].Cumulative+"'  WHERE Id='" +intake[i].Id + "' ");
                    }
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

    public class Intake
    {
        public string Id {get;set;}
      public string MIVF {get;set;}
      public string Hourlydrips {get;set;}
      public string BloodBolus {get;set;}
      public string POintake {get;set;}
      public string POintake1 { get; set; }
      public string HourTotal {get;set;}
      public string Cimulative {get;set;}
      public string CT1Level {get;set;}
      public string CT2Level {get;set;}
      public string CToutput {get;set;}
      public string Urine {get;set;}
      public string Stool {get;set;}
      public string Vomiting {get;set;}
      public string Hourstotal {get;set;}
      public string Cumulative {get;set;}
      public string CreatedBy {get;set;}
      public string Date {get;set;}
      public string Time { get; set; }
      public string TransactionId { get; set; }
      public string PatientId { get; set; } 


    }
    protected void btnPrint_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT TIME_FORMAT(tm.Time,'%h:%i %p')Time_Label,if(tm.Shift=1,'Morning','Evening')Shift,IFNULL(em.Name,'')Name,IFNULL(nin.Date,'')DATE,IFNULL(nin.Solution,'')Solution,IFNULL(nin.NGTOraSpDiet,'')NGTOraSpDiet,IFNULL(nin.NGT_Aspiration,'')NGT_Aspiration,IFNULL(nin.VolNgt,'')VolNgt, ");
        sb.Append(" IFNULL(nin.Medication,'')Medication,IFNULL(nin.VolMedication,'')VolMedication,IFNULL(nin.UrineVolumn,'')UrineVolumn,IFNULL(nin.Other,'')Other,IFNULL(nin.RunningOutPut,'')RunningOutPut,IFNULL(nin.SolVol,'')SolVol, ");
        sb.Append(" (SELECT SUM(IFNULL(VolNgt,0)) FROM   nursing_IntakeOutPut  WHERE DATE(DATE)='" + Convert.ToDateTime(Util.GetDateTime(txtDate.Text)).ToString("yyyy-MM-dd") + "' AND TransactionID='" + ViewState["TransID"].ToString() + "'  AND shift=1  GROUP BY shift,DATE )MorningVolNgt, ");
        sb.Append(" (SELECT SUM(IFNULL(VolNgt,0)) FROM nursing_IntakeOutPut  WHERE  DATE(DATE)='" + Convert.ToDateTime(Util.GetDateTime(txtDate.Text)).ToString("yyyy-MM-dd") + "' AND TransactionID='" + ViewState["TransID"].ToString() + "'   AND shift=2 GROUP BY shift,DATE )EveningVolNgt, ");
        sb.Append(" (SELECT SUM(IFNULL(SolVol,0)) FROM   nursing_IntakeOutPut  WHERE DATE(DATE)='" + Convert.ToDateTime(Util.GetDateTime(txtDate.Text)).ToString("yyyy-MM-dd") + "' AND TransactionID='" + ViewState["TransID"].ToString() + "'  AND shift=1  GROUP BY shift,DATE )MorningSolVol, ");
        sb.Append(" (SELECT SUM(IFNULL(SolVol,0)) FROM nursing_IntakeOutPut  WHERE  DATE(DATE)='" + Convert.ToDateTime(Util.GetDateTime(txtDate.Text)).ToString("yyyy-MM-dd") + "' AND TransactionID='" + ViewState["TransID"].ToString() + "'   AND shift=2 GROUP BY shift,DATE )EveningSolVol, ");
        sb.Append(" (SELECT SUM(IFNULL(VolMedication,0)) FROM nursing_IntakeOutPut  WHERE  DATE(DATE)='" + Convert.ToDateTime(Util.GetDateTime(txtDate.Text)).ToString("yyyy-MM-dd") + "' AND TransactionID='" + ViewState["TransID"].ToString() + "'   AND shift=1 GROUP BY shift,DATE )MorningVolMedication, ");
        sb.Append(" (SELECT SUM(IFNULL(UrineVolumn,0)) FROM nursing_IntakeOutPut  WHERE  DATE(DATE)='" + Convert.ToDateTime(Util.GetDateTime(txtDate.Text)).ToString("yyyy-MM-dd") + "' AND TransactionID='" + ViewState["TransID"].ToString() + "'   AND shift=1 GROUP BY shift,DATE )MorningUrineVolumn, ");
        sb.Append(" (SELECT SUM(IFNULL(VolMedication,0)) FROM nursing_IntakeOutPut  WHERE  DATE(DATE)='" + Convert.ToDateTime(Util.GetDateTime(txtDate.Text)).ToString("yyyy-MM-dd") + "' AND TransactionID='" + ViewState["TransID"].ToString() + "'   AND shift=2 GROUP BY shift,DATE )EveningVolMedication, ");
        sb.Append(" (SELECT SUM(IFNULL(UrineVolumn,0)) FROM nursing_IntakeOutPut  WHERE  DATE(DATE)='" + Convert.ToDateTime(Util.GetDateTime(txtDate.Text)).ToString("yyyy-MM-dd") + "' AND TransactionID='" + ViewState["TransID"].ToString() + "'   AND shift=2 GROUP BY shift,DATE )EveningUrineVolumn, ");
        sb.Append(" (SELECT SUM(IFNULL(SolVol,0)) FROM nursing_IntakeOutPut  WHERE  DATE(DATE)='" + Convert.ToDateTime(Util.GetDateTime(txtDate.Text)).ToString("yyyy-MM-dd") + "' AND TransactionID='" + ViewState["TransID"].ToString() + "'    GROUP BY DATE )TotalSolVol, ");
        sb.Append(" (SELECT SUM(IFNULL(VolNgt,0)) FROM nursing_IntakeOutPut  WHERE  DATE(DATE)='" + Convert.ToDateTime(Util.GetDateTime(txtDate.Text)).ToString("yyyy-MM-dd") + "' AND TransactionID='" + ViewState["TransID"].ToString() + "'    GROUP BY DATE )TotalVolNgt, ");
        sb.Append(" (SELECT SUM(IFNULL(VolMedication,0)) FROM nursing_IntakeOutPut  WHERE  DATE(DATE)='" + Convert.ToDateTime(Util.GetDateTime(txtDate.Text)).ToString("yyyy-MM-dd") + "' AND TransactionID='" + ViewState["TransID"].ToString() + "'    GROUP BY DATE )TotalVolMedication,  ");
        sb.Append(" (SELECT SUM(IFNULL(UrineVolumn,0)) FROM nursing_IntakeOutPut  WHERE  DATE(DATE)='" + Convert.ToDateTime(Util.GetDateTime(txtDate.Text)).ToString("yyyy-MM-dd") + "' AND TransactionID='" + ViewState["TransID"].ToString() + "'    GROUP BY DATE )TotalUrineVol, ");
        sb.Append(" (SELECT SUM(IFNULL(VolMedication,0)+IFNULL(SolVol,0)+IFNULL(VolNgt,0)) FROM nursing_IntakeOutPut  WHERE  DATE(DATE)='" + Convert.ToDateTime(Util.GetDateTime(txtDate.Text)).ToString("yyyy-MM-dd") + "' AND TransactionID='" + ViewState["TransID"].ToString() + "'    GROUP BY DATE )TotalIntake ");
        sb.Append("   FROM time_master tm LEFT JOIN nursing_IntakeOutPut nin ON tm.Time=nin.Time AND nin.Date='" + Convert.ToDateTime(Util.GetDateTime(txtDate.Text)).ToString("yyyy-MM-dd") + "'and TransactionID='" + ViewState["TransID"].ToString() + "' Left JOIN employee_master em ON em.EmployeeID=nin.CreatedBy  ORDER BY tm.ID ");
        DataTable dtDetails = StockReports.GetDataTable(sb.ToString());
        if (dtDetails.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dtDetails.Copy());
            ds.Tables[0].TableName = "InTakeOutPut";
            AllQuery AQ = new AllQuery();
            DataTable dtStatus = AQ.GetPatientDischargeStatus(ViewState["TransID"].ToString());
            string Status = dtStatus.Rows[0]["Status"].ToString();
            DataTable dtInfo = AQ.GetPatientIPDInformation("", ViewState["TransID"].ToString(), Status);
            ds.Tables.Add(dtInfo.Copy());
            ds.Tables[1].TableName = "PatientInfo";
            DataTable dtImg = All_LoadData.CrystalReportLogo();
            ds.Tables.Add(dtImg.Copy());
            ds.Tables[2].TableName = "logo";
            Session["ReportName"] = "InTakeOutPutChart";
            Session["ds"] = ds;
            //  ds.WriteXmlSchema(@"E:\InTakeOutPutChart.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
        }
        else
        {
            lblMsg.Text = "No Record Found";
        }
    }
}