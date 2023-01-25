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
public partial class Design_Emergency_EOPCAPS : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod(EnableSession = true)]
    public static string SearchEOPData(string TID)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("SELECT eop.ID,Age,LanguageBarier,FamilySupport,International,HighRiskDrugs,Drugs,BloodTransfusion, ");
        sb.Append("Ventilator,Syringe,Airway,HighRiskDesease,HighRiskSurgery,HistoryofFall,MobidityAid,Gait,MentalStatus,TotalScore,CreateBy,CreateDate ");
        sb.Append("FROM emg_eopcaps eop INNER JOIN employee_master emp ON eop.CreateBy=emp.EmployeeID  ");
        sb.Append("WHERE eop.TransactionID='"+TID+"' AND eop.isactive=1 ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string SaveEOPRecord(object Data, string TID, string PID, string EMGNo)
    {
        List<EOPData> EOPData = new JavaScriptSerializer().ConvertToType<List<EOPData>>(Data);
        if (EOPData.Count > 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < EOPData.Count; i++)
                {
                    sb.Append("INSERT INTO emg_eopcaps (TransactionID,EmergencyNo,PatientID,Age,LanguageBarier,FamilySupport, ");
                    sb.Append("International,HighRiskDrugs,Drugs,BloodTransfusion,Ventilator,Syringe,Airway,HighRiskDesease, ");
                    sb.Append("HighRiskSurgery,HistoryofFall,MobidityAid,Gait,MentalStatus,TotalScore,CreateBy,CreateDate) ");
                    sb.Append("VALUES('" + TID + "','" + EMGNo + "','" + PID + "'," + EOPData[i].Age + "," + EOPData[i].LanguageBarier + "," + EOPData[i].FamilySupport + " ");
                    sb.Append(" ," + EOPData[i].International + "," + EOPData[i].HighRiskDrugs + "," + EOPData[i].Drugs + "," + EOPData[i].BloodTransfusion + "," + EOPData[i].Ventilator + "," + EOPData[i].Syringe + "," + EOPData[i].Airway + "," + EOPData[i].HighRiskDesease + "  ");
                    sb.Append(" ," + EOPData[i].HighRiskSurgery + "," + EOPData[i].HistoryofFall + "," + EOPData[i].MobidityAid + "," + EOPData[i].Gait + "," + EOPData[i].MentalStatus + "," + EOPData[i].TotalScore + ",'"+HttpContext.Current.Session["ID"].ToString()+"',NOW()  ); ");
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
    public static string UpdateEOPRecord(object Data, string TID, string PID, string EMGNo)
    {
        List<EOPData> EOPData = new JavaScriptSerializer().ConvertToType<List<EOPData>>(Data);
        if (EOPData.Count > 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < EOPData.Count; i++)
                {
                    string str = "Update emg_eopcaps set IsActive=0,UpdateBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdateDate=Now() where ID= '" + EOPData[i].ID + "' ";
                    int result = MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str);
                    if (result == 1)
                    {
                        sb.Append("INSERT INTO emg_eopcaps (TransactionID,EmergencyNo,PatientID,Age,LanguageBarier,FamilySupport, ");
                        sb.Append("International,HighRiskDrugs,Drugs,BloodTransfusion,Ventilator,Syringe,Airway,HighRiskDesease, ");
                        sb.Append("HighRiskSurgery,HistoryofFall,MobidityAid,Gait,MentalStatus,TotalScore,CreateBy,CreateDate) ");
                        sb.Append("VALUES('" + TID + "','" + EMGNo + "','" + PID + "'," + EOPData[i].Age + "," + EOPData[i].LanguageBarier + "," + EOPData[i].FamilySupport + " ");
                        sb.Append(" ," + EOPData[i].International + "," + EOPData[i].HighRiskDrugs + "," + EOPData[i].Drugs + "," + EOPData[i].BloodTransfusion + "," + EOPData[i].Ventilator + "," + EOPData[i].Syringe + "," + EOPData[i].Airway + "," + EOPData[i].HighRiskDesease + "  ");
                        sb.Append(" ," + EOPData[i].HighRiskSurgery + "," + EOPData[i].HistoryofFall + "," + EOPData[i].MobidityAid + "," + EOPData[i].Gait + "," + EOPData[i].MentalStatus + "," + EOPData[i].TotalScore + ",'" + HttpContext.Current.Session["ID"].ToString() + "','" + Util.GetDateTime(EOPData[i].CreatedDate).ToString("yyyy-MM-dd HH:mm:ss") + "' ) ");
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


    public class EOPData
    {
        public int Age { get; set; }
        public int LanguageBarier { get; set; }
        public int FamilySupport { get; set; }
        public int International { get; set; }
        public int HighRiskDrugs { get; set; }
        public int Drugs { get; set; }
        public int BloodTransfusion { get; set; }
        public int Ventilator { get; set; }
        public int Syringe { get; set; }
        public int Airway { get; set; }
        public int HighRiskDesease { get; set; }
        public int HighRiskSurgery { get; set; }
        public int HistoryofFall { get; set; }
        public int MobidityAid { get; set; }
        public int Gait { get; set; }
        public int MentalStatus { get; set; }
        public int TotalScore { get; set; }

        public string CreatedBy { get; set; }
        public string CreatedDate { get; set; }
        public string ID { get; set; }
    }
}