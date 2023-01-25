using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Emergency_FalseAssessment : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtTime.Text = DateTime.Now.ToString("hh:mm tt");
            ViewState["ID"] = Session["ID"].ToString();
        }
        txtDate.Attributes.Add("readOnly", "true");
    }

    [WebMethod(EnableSession = true)]
    public static string SearchAssessmentData(string TID, string Date)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT efa.ID,DATE_FORMAT(DATE,'%d-%b-%Y')DATE,TIME_FORMAT(TIME,'%l:%i %p')TIME,TransactionID,EmergencyNo,PatientID,Confusion,Disorientation,Dizziness,Hearing, ");
        sb.Append(" Hemiparesis,HistoryofFall,MemoryImpairment,SightImpairment,UnsteadyGait,WalkingAid,NeedBedSide,TotalScore,CONCAT(emp.Title,'',emp.Name)CreateBy,CreateDateTime ");
        sb.Append(" FROM emg_falseassessment efa INNER JOIN employee_master emp ON efa.CreateBy=emp.EmployeeID ");
        sb.Append(" WHERE efa.TransactionID='"+TID+"' AND efa.IsActive=1 ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string SaveAssessMentRecord(object Data, string TID, string PID,string EMGNo)
    {
        List<AssessMentData> AssessData = new JavaScriptSerializer().ConvertToType<List<AssessMentData>>(Data);
        if (AssessData.Count > 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < AssessData.Count; i++)
                {
                    sb.Append(" INSERT INTO emg_falseassessment (DATE,TIME,TransactionID,EmergencyNo,PatientID,Confusion,Disorientation, ");
                    sb.Append(" Dizziness,Hearing,Hemiparesis,HistoryofFall,MemoryImpairment,SightImpairment,UnsteadyGait,WalkingAid, ");
                    sb.Append(" NeedBedSide,TotalScore,CreateBy,CreateDateTime) ");
                    sb.Append(" VALUES('" + Util.GetDateTime(AssessData[i].Date).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(AssessData[i].Time).ToString("HH:mm:ss") + "','" + TID + "','" + EMGNo + "','" + PID + "','" + AssessData[i].Confusion + "','" + AssessData[i].Disorientation + "'  ");
                    sb.Append(" ,'" + AssessData[i].Dizziness + "','" + AssessData[i].Hearing + "','" + AssessData[i].Hemiparesis + "','" + AssessData[i].HistoryofFall + "','" + AssessData[i].MemoryImpairment + "','" + AssessData[i].SightImpairment + "','" + AssessData[i].UnsteadyGait + "','" + AssessData[i].WalkingAid + "' ");
                    sb.Append("," + AssessData[i].NeedBedSide + "," + AssessData[i].TotalScore + ",'" + HttpContext.Current.Session["ID"].ToString() + "',NOW() ) ");
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());
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
            return "0";
        }
    }

    [WebMethod(EnableSession = true)]
    public static string UpdateAssessMentRecord(object Data, string TID, string PID,string EMGNo)
    {
        List<AssessMentData> AssessData = new JavaScriptSerializer().ConvertToType<List<AssessMentData>>(Data);
        if (AssessData.Count > 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < AssessData.Count; i++)
                {
                    string str = "Update emg_falseassessment set IsActive=0,UpdateBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdateDate=Now() where ID= '" + AssessData[i].ID + "' ";
                    int result = MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str);
                    if (result == 1)
                    {

                        sb.Append(" INSERT INTO emg_falseassessment (DATE,TIME,TransactionID,EmergencyNo,PatientID,Confusion,Disorientation, ");
                        sb.Append(" Dizziness,Hearing,Hemiparesis,HistoryofFall,MemoryImpairment,SightImpairment,UnsteadyGait,WalkingAid, ");
                        sb.Append(" NeedBedSide,TotalScore,CreateBy,CreateDateTime) ");
                        sb.Append(" VALUES('" + Util.GetDateTime(AssessData[i].Date).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(AssessData[i].Time).ToString("HH:mm:ss") + "','" + TID + "','" + EMGNo + "','" + PID + "','" + AssessData[i].Confusion + "','" + AssessData[i].Disorientation + "'  ");
                        sb.Append(" ,'" + AssessData[i].Dizziness + "','" + AssessData[i].Hearing + "','" + AssessData[i].Hemiparesis + "','" + AssessData[i].HistoryofFall + "','" + AssessData[i].MemoryImpairment + "','" + AssessData[i].SightImpairment + "','" + AssessData[i].UnsteadyGait + "','" + AssessData[i].WalkingAid + "' ");
                        sb.Append("," + AssessData[i].NeedBedSide + "," + AssessData[i].TotalScore + ",'" + HttpContext.Current.Session["ID"].ToString() + "','" + Util.GetDateTime(AssessData[i].CreatedDate).ToString("yyyy-MM-dd HH:mm:ss") + "' ) ");
                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());
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
            return "0";
        }
    }


    public class AssessMentData
    {
                              
        public string Date { get; set; }
        public string Time { get; set; }

        public string Confusion { get; set; }
        public string Disorientation { get; set; }
        public string Dizziness { get; set; }
        public string Hearing { get; set; }
        public string Hemiparesis { get; set; }
        public string HistoryofFall { get; set; }
        public string MemoryImpairment { get; set; }
        public string SightImpairment { get; set; }
        public string UnsteadyGait { get; set; }
        public string WalkingAid { get; set; }
        public int NeedBedSide { get; set; }
        public int TotalScore { get; set; }

        public string CreatedBy { get; set; }
        public string CreatedDate { get; set; }
        public string ID { get; set; }
    }


    protected void btnPrint_Click(object sender, EventArgs e)
    {
        string TransactionID = Request.QueryString["TID"].ToString();
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT CONCAT(pm.title,'',pm.PName)Pname, efa.ID,DATE_FORMAT(DATE,'%d-%b-%Y')DATE,TIME_FORMAT(TIME,'%l:%i %p')TIME,TransactionID,EmergencyNo,pm.PatientID,Confusion,Disorientation,Dizziness,Hearing, ");
        sb.Append("Hemiparesis,HistoryofFall,MemoryImpairment,SightImpairment,UnsteadyGait,WalkingAid,NeedBedSide,TotalScore,CONCAT(emp.Title,'',emp.Name)CreateBy,CreateDateTime ");
        sb.Append("FROM emg_falseassessment efa INNER JOIN patient_master pm ON efa.PatientID=pm.PatientID INNER JOIN employee_master emp ON efa.CreateBy=emp.EmployeeID ");
        sb.Append("WHERE efa.TransactionID='"+TransactionID+"' AND efa.IsActive=1 ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            ds.Tables[0].TableName = "EMGFalseAssessment";
            DataTable dtImg = All_LoadData.CrystalReportLogo();
            ds.Tables.Add(dtImg.Copy());
            ds.Tables[1].TableName = "logo";
            Session["ReportName"] = "EMGFalseAssessment";
            Session["ds"] = ds;
            //ds.WriteXmlSchema(@"E:\EMGFalseAssessment.xml");

            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
        }
    }
}