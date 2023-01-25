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

public partial class Design_Emergency_EmgPatientEducation : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod(EnableSession = true)]
    public static string SearchEducationData(string TID) 
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT ID,PatientBenifits,Ability,EducationLevel,Language,Barrier,Physical, ");
        sb.Append("Willingness,Edu_NexttoKin,Edu_Parent,Edu_Patient,SafeUSeofMedicine,SafeUSeofEquip,Potential,Nutrition,Pain,Rehabilitation, ");
        sb.Append("OtherInformation,CreateBy,CreateDate FROM emg_patienteducation WHERE TransactionID='"+TID+"' and Isactive=1 ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string SaveEducationRecord(object Data, string TID, string PID, string EMGNo)
    {
        List<EducationData> EducationData = new JavaScriptSerializer().ConvertToType<List<EducationData>>(Data);
        if (EducationData.Count > 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < EducationData.Count; i++)
                {
                    sb.Append("INSERT INTO emg_patienteducation (TransactionID,PatientID,EmergencyNo,PatientBenifits,Ability,EducationLevel, ");
                    sb.Append("LANGUAGE,Barrier,Physical,Willingness,Edu_NexttoKin,Edu_Parent,Edu_Patient,SafeUSeofMedicine,SafeUSeofEquip,Potential,Nutrition,Pain, ");
                    sb.Append("Rehabilitation,OtherInformation,CreateBy,CreateDate) ");
                    sb.Append("VALUES( '" + TID + "','" + PID + "','" + EMGNo + "'," + EducationData[i].PatientBenifits + "," + EducationData[i].Ability + "," + EducationData[i].EducationLevel + "");
                    sb.Append(" ," + EducationData[i].Language + "," + EducationData[i].Barrier + "," + EducationData[i].Physical + "," + EducationData[i].Willingness + ",'" + EducationData[i].Edu_NexttoKin + "' ");
                    sb.Append(" ,'" + EducationData[i].Edu_Parent + "','" + EducationData[i].Edu_Patient + "'," + EducationData[i].SafeUSeofMedicine + "," + EducationData[i].SafeUSeofEquip + "," + EducationData[i].Potential + "," + EducationData[i].Nutrition + "," + EducationData[i].Pain + " ");
                    sb.Append(" ," + EducationData[i].Rehabilitation + ",'" + EducationData[i].OtherInformation + "','"+HttpContext.Current.Session["ID"].ToString()+"',NOW() ) ");
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

    [WebMethod(EnableSession=true)]
    public static string UpdateEducationRecord(object Data , string TID, string PID, string EMGNo)
    {
        List<EducationData> EducationData = new JavaScriptSerializer().ConvertToType<List<EducationData>>(Data);
        if (EducationData.Count > 0)
        {
            MySqlConnection con= new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < EducationData.Count; i++)
                {
                    string str = "Update emg_patienteducation set IsActive=0,UpdateBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdateDate=Now() where ID= '" + EducationData[i].ID + "' ";
                    int result = MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, str);
                    if (result == 1)
                    {
                        sb.Append("INSERT INTO emg_patienteducation (TransactionID,PatientID,EmergencyNo,PatientBenifits,Ability,EducationLevel, ");
                        sb.Append("LANGUAGE,Barrier,Physical,Willingness,Edu_NexttoKin,Edu_Parent,Edu_Patient,SafeUSeofMedicine,SafeUSeofEquip,Potential,Nutrition,Pain, ");
                        sb.Append("Rehabilitation,OtherInformation,CreateBy,CreateDate) ");
                        sb.Append("VALUES( '" + TID + "','" + PID + "','" + EMGNo + "'," + EducationData[i].PatientBenifits + "," + EducationData[i].Ability + "," + EducationData[i].EducationLevel + "");
                        sb.Append(" ," + EducationData[i].Language + "," + EducationData[i].Barrier + "," + EducationData[i].Physical + "," + EducationData[i].Willingness + ",'" + EducationData[i].Edu_NexttoKin + "' ");
                        sb.Append(" ,'" + EducationData[i].Edu_Parent + "','" + EducationData[i].Edu_Patient + "'," + EducationData[i].SafeUSeofMedicine + "," + EducationData[i].SafeUSeofEquip + "," + EducationData[i].Potential + "," + EducationData[i].Nutrition + "," + EducationData[i].Pain + " ");
                        sb.Append(" ," + EducationData[i].Rehabilitation + ",'" + EducationData[i].OtherInformation + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + Util.GetDateTime(EducationData[i].CreatedDate).ToString("yyyy-MM-dd HH:mm:ss") + "' ) ");
                        MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, sb.ToString());
                    }
                }
                tranx.Commit();
                return "1";
            }
            catch (Exception ex)
            {
                tranx.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return "0";
            }
            finally 
            {
                tranx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        else
        {
            return "0";
        }
    }

    public class EducationData
    {
        public int PatientBenifits { get; set; }
        public int Ability { get; set; }
        public int FamilySupport { get; set; }
        public int EducationLevel { get; set; }
        public int Language { get; set; }
        public int Barrier { get; set; }
        public int Physical { get; set; }
        public int Willingness { get; set; }
        public string Edu_NexttoKin { get; set; }
        public string Edu_Parent { get; set; }
        public string Edu_Patient { get; set; }
        public int SafeUSeofMedicine { get; set; }
        public int SafeUSeofEquip { get; set; }
        public int Potential { get; set; }
        public int Nutrition { get; set; }
        public int Pain { get; set; }
        public int Rehabilitation { get; set; }
        public string OtherInformation { get; set; }

        public string CreatedBy { get; set; }
        public string CreatedDate { get; set; }
        public string ID { get; set; }
    }
}