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

public partial class Design_IPD_IntakeOutPutChart : System.Web.UI.Page
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
        sb.Append("SELECT TIME_FORMAT(tm.Time,'%h:%i %p')Time_Label,tm.Shift,IFNULL(em.Name,'')Name,IFNULL(nin.Date,'')DATE,IFNULL(nin.Solution,'')Solution,IFNULL(nin.NGTOraSpDiet,'')NGTOraSpDiet,IFNULL(nin.VolNgt,'')VolNgt,IFNULL(nin.OraSpDiet,'')OraSpDiet,IFNULL(nin.NGT_Aspiration,'')NGT_Aspiration, ");
        sb.Append(" IFNULL(nin.Medication,'')Medication,IFNULL(more_drains,'')  More_drains,IFNULL(More_infusion_pumps,'') More_infusion_pumps ,IFNULL(nin.VolMedication,'')VolMedication,IFNULL(nin.UrineVolumn,'')UrineVolumn,IFNULL(nin.Other,'')Other,IFNULL(nin.RunningOutPut,'')RunningOutPut,IFNULL(nin.SolVol,'')SolVol, ");
        sb.Append(" (SELECT SUM(IFNULL(VolNgt,0)) FROM   nursing_IntakeOutPut  WHERE DATE(DATE)='" + Convert.ToDateTime(Util.GetDateTime(Date)).ToString("yyyy-MM-dd") + "' AND TransactionID='" + TransID + "'  AND shift=1  GROUP BY shift,DATE )MorningVolNgt, ");
        sb.Append(" (SELECT SUM(IFNULL(VolNgt,0)) FROM nursing_IntakeOutPut  WHERE  DATE(DATE)='" + Convert.ToDateTime(Util.GetDateTime(Date)).ToString("yyyy-MM-dd") + "' AND TransactionID='" + TransID + "'   AND shift=2 GROUP BY shift,DATE )EveningVolNgt, ");





        sb.Append(" (SELECT SUM(IFNULL(SolVol,0)) FROM   nursing_IntakeOutPut  WHERE DATE(DATE)='" + Convert.ToDateTime(Util.GetDateTime(Date)).ToString("yyyy-MM-dd") + "' AND TransactionID='" + TransID + "'  AND shift=1  GROUP BY shift,DATE )MorningSolVol, ");
        sb.Append(" (SELECT SUM(IFNULL(SolVol,0)) FROM nursing_IntakeOutPut  WHERE  DATE(DATE)='" + Convert.ToDateTime(Util.GetDateTime(Date)).ToString("yyyy-MM-dd") + "' AND TransactionID='" + TransID + "'   AND shift=2 GROUP BY shift,DATE )EveningSolVol, ");
        sb.Append(" (SELECT SUM(IFNULL(VolMedication,0)) FROM nursing_IntakeOutPut  WHERE  DATE(DATE)='" + Convert.ToDateTime(Util.GetDateTime(Date)).ToString("yyyy-MM-dd") + "' AND TransactionID='" + TransID + "'   AND shift=1 GROUP BY shift,DATE )MorningVolMedication, ");
        sb.Append(" (SELECT SUM(IFNULL(UrineVolumn,0)) FROM nursing_IntakeOutPut  WHERE  DATE(DATE)='" + Convert.ToDateTime(Util.GetDateTime(Date)).ToString("yyyy-MM-dd") + "' AND TransactionID='" + TransID + "'   AND shift=1 GROUP BY shift,DATE )MorningUrineVolumn, ");
        sb.Append(" (SELECT SUM(IFNULL(VolMedication,0)) FROM nursing_IntakeOutPut  WHERE  DATE(DATE)='" + Convert.ToDateTime(Util.GetDateTime(Date)).ToString("yyyy-MM-dd") + "' AND TransactionID='" + TransID + "'   AND shift=2 GROUP BY shift,DATE )EveningVolMedication, ");
        sb.Append(" (SELECT SUM(IFNULL(UrineVolumn,0)) FROM nursing_IntakeOutPut  WHERE  DATE(DATE)='" + Convert.ToDateTime(Util.GetDateTime(Date)).ToString("yyyy-MM-dd") + "' AND TransactionID='" + TransID + "'   AND shift=2 GROUP BY shift,DATE )EveningUrineVolumn, ");
        sb.Append(" (SELECT SUM(IFNULL(SolVol,0)) FROM nursing_IntakeOutPut  WHERE  DATE(DATE)='" + Convert.ToDateTime(Util.GetDateTime(Date)).ToString("yyyy-MM-dd") + "' AND TransactionID='" + TransID + "'    GROUP BY DATE )TotalSolVol, ");
        sb.Append(" (SELECT SUM(IFNULL(VolNgt,0)) FROM nursing_IntakeOutPut  WHERE  DATE(DATE)='" + Convert.ToDateTime(Util.GetDateTime(Date)).ToString("yyyy-MM-dd") + "' AND TransactionID='" + TransID + "'    GROUP BY DATE )TotalVolNgt, ");
        sb.Append(" (SELECT SUM(IFNULL(VolMedication,0)) FROM nursing_IntakeOutPut  WHERE  DATE(DATE)='" + Convert.ToDateTime(Util.GetDateTime(Date)).ToString("yyyy-MM-dd") + "' AND TransactionID='" + TransID + "'    GROUP BY DATE )TotalVolMedication,  ");
        sb.Append(" (SELECT SUM(IFNULL(UrineVolumn,0)) FROM nursing_IntakeOutPut  WHERE  DATE(DATE)='" + Convert.ToDateTime(Util.GetDateTime(Date)).ToString("yyyy-MM-dd") + "' AND TransactionID='" + TransID + "'    GROUP BY DATE )TotalUrineVol, ");



        sb.Append(" (SELECT SUM(IFNULL(More_infusion_pumps, 0)) FROM nursing_IntakeOutPut WHERE Shift=1 AND  DATE(DATE) = '" + Convert.ToDateTime(Util.GetDateTime(Date)).ToString("yyyy-MM-dd") + "' AND TransactionID = '" + TransID + "' GROUP BY DATE) TotalMorningMore_infusion_pumps, ");
        sb.Append(" (SELECT SUM(IFNULL(More_drains, 0)) FROM nursing_IntakeOutPut WHERE Shift=1 AND  DATE(DATE) = '" + Convert.ToDateTime(Util.GetDateTime(Date)).ToString("yyyy-MM-dd") + "' AND TransactionID = '" + TransID + "' GROUP BY DATE) TotalMorningMore_drains, ");
        sb.Append(" (SELECT SUM(IFNULL(More_infusion_pumps, 0)) FROM nursing_IntakeOutPut WHERE Shift=2 AND  DATE(DATE) = '" + Convert.ToDateTime(Util.GetDateTime(Date)).ToString("yyyy-MM-dd") + "' AND TransactionID = '" + TransID + "' GROUP BY DATE) TotalEveningMore_infusion_pumps, ");
        sb.Append(" (SELECT SUM(IFNULL(More_drains, 0)) FROM nursing_IntakeOutPut WHERE Shift=2 AND  DATE(DATE) = '" + Convert.ToDateTime(Util.GetDateTime(Date)).ToString("yyyy-MM-dd") + "' AND TransactionID = '" + TransID + "' GROUP BY DATE) TotalEveningMore_drains, ");




        sb.Append(" (SELECT SUM(IFNULL(More_infusion_pumps,0)) FROM nursing_IntakeOutPut  WHERE  DATE(DATE)='" + Convert.ToDateTime(Util.GetDateTime(Date)).ToString("yyyy-MM-dd") + "' AND TransactionID='" + TransID + "'    GROUP BY DATE )TotalMore_infusion_pumps, ");
        sb.Append(" (SELECT SUM(IFNULL(More_drains,0)) FROM nursing_IntakeOutPut  WHERE  DATE(DATE)='" + Convert.ToDateTime(Util.GetDateTime(Date)).ToString("yyyy-MM-dd") + "' AND TransactionID='" + TransID + "'    GROUP BY DATE )TotalMore_drains, ");

        sb.Append(" (SELECT SUM(IFNULL(VolMedication,0)+IFNULL(SolVol,0)+IFNULL(VolNgt,0)) FROM nursing_IntakeOutPut  WHERE  DATE(DATE)='" + Convert.ToDateTime(Util.GetDateTime(Date)).ToString("yyyy-MM-dd") + "' AND TransactionID='" + TransID + "'    GROUP BY DATE )TotalIntake , ");

        sb.Append(" ( (SELECT SUM(IFNULL(VolMedication,0)+IFNULL(SolVol,0)+IFNULL(VolNgt,0))  ");
        sb.Append("    FROM nursing_IntakeOutPut  WHERE  DATE(DATE)='" + Convert.ToDateTime(Util.GetDateTime(Date)).ToString("yyyy-MM-dd") + "' AND TransactionID='" + TransID + "'    GROUP BY DATE )-(SELECT SUM(IFNULL(VolMedication,0)) FROM nursing_IntakeOutPut   ");
        sb.Append("  WHERE  DATE(DATE)='" + Convert.ToDateTime(Util.GetDateTime(Date)).ToString("yyyy-MM-dd") + "' AND TransactionID='" + TransID + "'     GROUP BY DATE )) DailyBalance, ");

        sb.Append("   ( (SELECT SUM(IFNULL(VolMedication,0)+IFNULL(SolVol,0)+IFNULL(VolNgt,0))  ");
        sb.Append("          FROM nursing_IntakeOutPut  WHERE  DATE(DATE)<='" + Convert.ToDateTime(Util.GetDateTime(Date)).ToString("yyyy-MM-dd") + "' AND TransactionID='" + TransID + "' )-(SELECT SUM(IFNULL(VolMedication,0)) FROM nursing_IntakeOutPut   ");
        sb.Append("   WHERE  DATE(DATE)<='" + Convert.ToDateTime(Util.GetDateTime(Date)).ToString("yyyy-MM-dd") + "' AND TransactionID='" + TransID + "' )) QumulativeBalance ");



        sb.Append("   FROM time_master tm LEFT JOIN nursing_IntakeOutPut nin ON tm.Time=nin.Time AND nin.Date='" + Convert.ToDateTime(Util.GetDateTime(Date)).ToString("yyyy-MM-dd") + "'and TransactionID='" + TransID + "' left JOIN employee_master em ON em.EmployeeID=nin.CreatedBy ORDER BY tm.ID ");
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
                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO nursing_IntakeOutPut(TransactionID,PatientID,Date,Time,Solution,SolVol,NGTOraSpDiet,VolNgt,Medication,VolMedication,UrineVolumn,Other,RunningOutPut,more_infusion_pumps,more_drains,CreatedBy,Shift,OraSpDiet,NGT_Aspiration  " +
                            " )VALUE('" + TID + "','" + PID + "','" + Util.GetDateTime(intake[i].Date).ToString("yyyy-MM-dd") + "', " +
                            " '" + Util.GetDateTime(intake[i].Time).ToString("HH:mm:ss") + "','" + intake[i].Solution + "','" + intake[i].SolVol + "','" + intake[i].NGTOraSpDiet + "','" + intake[i].VolNgt + "','" + intake[i].Medication + "' " +
                        " ,'" + intake[i].VolMedication + "','" + intake[i].UrineVolumn + "','" + intake[i].Other + "','" + intake[i].RunningOutPut + "','" + intake[i].More_infusion_pumps + "','" + intake[i].more_drains + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + intake[i].Shift + "','" + intake[i].OraSpDiet + "','" + intake[i].NGTAspiration + "' )");
                    }
                    else if (intake[i].CreatedBy != null || intake[i].CreatedBy != "")
                    {
                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "update nursing_IntakeOutPut set PatientID='" + PID + "' WHERE TransactionID='" + TID + "' ");
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
        public string Solution { get; set; }

        public string NGTOraSpDiet { get; set; }
        public string VolNgt { get; set; }
        public string Medication { get; set; }
        public string VolMedication { get; set; }
        public string UrineVolumn { get; set; }
        public string Other { get; set; }
        public string RunningOutPut { get; set; }
        public string Time { get; set; }
        public string Date { get; set; }
        public string Shift { get; set; }
        public string CreatedBy { get; set; }
        public string SolVol { get; set; }
        public string More_infusion_pumps { get; set; }
        public string more_drains { get; set; }
        public string OraSpDiet { get; set; }
        public string NGTAspiration { get; set; }

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