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
using System.Web.UI.HtmlControls;

public partial class Design_IPD_AdultFallAssessmenttool : System.Web.UI.Page
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
            txtTime.Text = DateTime.Now.ToString("hh:mm tt");
            caldate.EndDate = DateTime.Now;
            ucToDate.Text = (DateTime.Now.AddDays(12)).ToString("dd-MMM-yyyy");
            ucFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
        txtDate.Attributes.Add("readOnly", "true");
    }

    [WebMethod(EnableSession = true)]
    public static string SearchAssessmentData(string TID, string Date)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT afa.ID,DATE_FORMAT(DATE,'%d-%b-%Y')Date,TIME_FORMAT(TIME,'%l:%i %p')Time,Age_Text,Age_Value,MentalStatus_Text,MentalStatus_Value,Lengthofstay_Text,Lengthofstay_Value,Elimination_Text, ");
        sb.Append("Elimination_Value,Impairment_Text,Impairment_Value,BloodPressure_Text,BloodPressure_Value,G_Diagnosis_Text,G_Diagnosis_Value,G_History_Text, ");
        sb.Append("G_History_Value,G_LosswithoutHold_Text,G_LosswithoutHold_Value,G_LossStraight_Text,G_LossStraight_Value,G_Decreased_Text,G_Decreased_Value, ");
        sb.Append("G_Lurching_Text,G_Lurching_Value,G_UsesCane_Text,G_UsesCane_Value,G_Holds_Text,G_Holds_Value,G_Widebase_Text,G_Widebase_Value,M_Alcohol_Text, ");
        sb.Append("M_Alcohol_Value,M_Pos_Text,M_Pos_Value,M_Cardio_Text,M_Cardio_Value,M_Diuretics_Text,M_Diuretics_Value,M_Cath_Text,M_Cath_Value,M_Sedatives_Text, ");
        sb.Append("M_Sedatives_Value,M_Histamine_Text,M_Histamine_Value,M_Chemo_Text,M_Chemo_Value,M_Narco_Text,M_Narco_Value,M_HighRisk_Text,M_HishRisk_Value,CreateBy, ");
        sb.Append("CreateDate,TIMESTAMPDIFF(MINUTE,CreateDate,NOW())createdDateDiff  ,CONCAT(em.Title,'',em.Name )entryby,  ");
        sb.Append(" IF(IFNULL(CreateBy,'')='" + HttpContext.Current.Session["ID"].ToString() + "',IF(IFNULL(TIMESTAMPDIFF(MINUTE,CreateDate,NOW()),0)<" + Util.GetInt(Resources.Resource.EditTimePeriod) + ",'1','0'),'1')IsEdit ");
        sb.Append("FROM ipd_adultfallassessmenttool afa INNER JOIN employee_master em ON afa.createby = em.employeeid  ");
        sb.Append("WHERE transactionID='" + TID + "' AND afa.isactive=1 ");
      //  sb.Append(" AND DATE='" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + " 00:00:00'  ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true)]
    public static string SaveAssessMentRecord(object Data, string TID, string PID)
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
                    sb.Append(" INSERT INTO ipd_adultfallassessmenttool (DATE,TIME,TransactionID,PatientID,Age_Text,Age_Value,MentalStatus_Text,MentalStatus_Value,Lengthofstay_Text, ");
                    sb.Append(" Lengthofstay_Value,Elimination_Text,Elimination_Value,Impairment_Text,Impairment_Value,BloodPressure_Text,BloodPressure_Value, ");
                    sb.Append(" G_Diagnosis_Text,G_Diagnosis_Value,G_History_Text,G_History_Value,G_LosswithoutHold_Text,G_LosswithoutHold_Value,G_LossStraight_Text,G_LossStraight_Value, ");
                    sb.Append(" G_Decreased_Text,G_Decreased_Value,G_Lurching_Text,G_Lurching_Value,G_UsesCane_Text,G_UsesCane_Value,G_Holds_Text,G_Holds_Value, ");
                    sb.Append(" G_Widebase_Text,G_Widebase_Value,M_Alcohol_Text,M_Alcohol_Value,M_Pos_Text,M_Pos_Value,M_Cardio_Text,M_Cardio_Value,M_Diuretics_Text, ");
                    sb.Append(" M_Diuretics_Value,M_Cath_Text,M_Cath_Value,M_Sedatives_Text,M_Sedatives_Value,M_Histamine_Text,M_Histamine_Value,M_Chemo_Text,M_Chemo_Value, ");
                    sb.Append(" M_Narco_Text,M_Narco_Value,M_HighRisk_Text,M_HishRisk_Value,CreateBy,CreateDate) ");
                    sb.Append(" VALUES('" + Util.GetDateTime(AssessData[i].Date).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(AssessData[i].Time).ToString("HH:mm:ss") + "','" + TID + "','" + PID + "','" + AssessData[i].AgeText + "','" + AssessData[i].AgeValue + "','" + AssessData[i].MentalStatusText + "','" + AssessData[i].MentalStatusValue + "','" + AssessData[i].LengthodStayText + "' ");
                    sb.Append(" ,'" + AssessData[i].LengthofStayValue + "','" + AssessData[i].EliminationText + "','" + AssessData[i].EliminationValue + "','" + AssessData[i].ImpairmentText + "','" + AssessData[i].ImpairmentValue + "','" + AssessData[i].BloodPressueText + "','" + AssessData[i].BloodPressueValue + "' ");
                    sb.Append(" ,'" + AssessData[i].G_Diagnosis_Text + "','" + AssessData[i].G_Diagnosis_Value + "','" + AssessData[i].G_History_Text + "','" + AssessData[i].G_History_Value + "','" + AssessData[i].G_LossWithoutHold_Text + "','" + AssessData[i].G_LossWithoutHold_Value + "','" + AssessData[i].G_LossStraight_Text + "','" + AssessData[i].G_LossStraight_Value + "' ");
                    sb.Append(" ,'" + AssessData[i].G_Decreased_Text + "','" + AssessData[i].G_Decreased_Value + "','" + AssessData[i].G_Lurching_Text + "','" + AssessData[i].G_Lurching_Value + "','" + AssessData[i].G_UsesCane_Text + "','" + AssessData[i].G_UsesCane_Value + "','" + AssessData[i].G_Holds_Text + "','" + AssessData[i].G_Holds_Value + "' ");
                    sb.Append(" ,'" + AssessData[i].G_WideBase_Text + "','" + AssessData[i].G_WideBase_Value + "','" + AssessData[i].M_Alcohol_Text + "','" + AssessData[i].M_Alcohol_Value + "','" + AssessData[i].M_Post_Text + "','" + AssessData[i].M_Post_Value + "','" + AssessData[i].M_Cardiovascular_Text + "','" + AssessData[i].M_Cardiovascular_Value + "','" + AssessData[i].M_Diuretics_Text + "' ");
                    sb.Append(" ,'" + AssessData[i].M_Diuretics_Value + "','" + AssessData[i].M_Cathartics_Text + "','" + AssessData[i].M_Cathartics_Value + "','" + AssessData[i].M_Sedatives_Text + "','" + AssessData[i].M_Sedatives_Value + "','" + AssessData[i].M_Histamine_Text + "','" + AssessData[i].M_Histamine_Value + "','" + AssessData[i].M_Chemotherapy_Text + "','" + AssessData[i].M_Chemotherapy_Value + "' ");
                    sb.Append(" ,'" + AssessData[i].M_Narcotics_Text + "','" + AssessData[i].M_Narcotics_Value + "','" + AssessData[i].TotalRisk_Text + "','" + AssessData[i].TotalRisk_Value + "','" + HttpContext.Current.Session["ID"].ToString() + "',NOW() ");
                    sb.Append(" ) ");
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
    public static string UpdateAssessMentRecord(object Data, string TID, string PID)
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
                    string str = "Update ipd_adultfallassessmenttool set IsActive=0,UpdateBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdateDate=Now() where ID= '"+AssessData[i].ID+"' ";
                    int result = MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str);
                    if (result == 1)
                    {
                        sb.Append(" INSERT INTO ipd_adultfallassessmenttool (DATE,TIME,TransactionID,PatientID,Age_Text,Age_Value,MentalStatus_Text,MentalStatus_Value,Lengthofstay_Text, ");
                        sb.Append(" Lengthofstay_Value,Elimination_Text,Elimination_Value,Impairment_Text,Impairment_Value,BloodPressure_Text,BloodPressure_Value, ");
                        sb.Append(" G_Diagnosis_Text,G_Diagnosis_Value,G_History_Text,G_History_Value,G_LosswithoutHold_Text,G_LosswithoutHold_Value,G_LossStraight_Text,G_LossStraight_Value, ");
                        sb.Append(" G_Decreased_Text,G_Decreased_Value,G_Lurching_Text,G_Lurching_Value,G_UsesCane_Text,G_UsesCane_Value,G_Holds_Text,G_Holds_Value, ");
                        sb.Append(" G_Widebase_Text,G_Widebase_Value,M_Alcohol_Text,M_Alcohol_Value,M_Pos_Text,M_Pos_Value,M_Cardio_Text,M_Cardio_Value,M_Diuretics_Text, ");
                        sb.Append(" M_Diuretics_Value,M_Cath_Text,M_Cath_Value,M_Sedatives_Text,M_Sedatives_Value,M_Histamine_Text,M_Histamine_Value,M_Chemo_Text,M_Chemo_Value, ");
                        sb.Append(" M_Narco_Text,M_Narco_Value,M_HighRisk_Text,M_HishRisk_Value,CreateBy,CreateDate) ");
                        sb.Append(" VALUES('" + Util.GetDateTime(AssessData[i].Date).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(AssessData[i].Time).ToString("HH:mm:ss") + "','" + TID + "','" + PID + "','" + AssessData[i].AgeText + "','" + AssessData[i].AgeValue + "','" + AssessData[i].MentalStatusText + "','" + AssessData[i].MentalStatusValue + "','" + AssessData[i].LengthodStayText + "' ");
                        sb.Append(" ,'" + AssessData[i].LengthofStayValue + "','" + AssessData[i].EliminationText + "','" + AssessData[i].EliminationValue + "','" + AssessData[i].ImpairmentText + "','" + AssessData[i].ImpairmentValue + "','" + AssessData[i].BloodPressueText + "','" + AssessData[i].BloodPressueValue + "' ");
                        sb.Append(" ,'" + AssessData[i].G_Diagnosis_Text + "','" + AssessData[i].G_Diagnosis_Value + "','" + AssessData[i].G_History_Text + "','" + AssessData[i].G_History_Value + "','" + AssessData[i].G_LossWithoutHold_Text + "','" + AssessData[i].G_LossWithoutHold_Value + "','" + AssessData[i].G_LossStraight_Text + "','" + AssessData[i].G_LossStraight_Value + "' ");
                        sb.Append(" ,'" + AssessData[i].G_Decreased_Text + "','" + AssessData[i].G_Decreased_Value + "','" + AssessData[i].G_Lurching_Text + "','" + AssessData[i].G_Lurching_Value + "','" + AssessData[i].G_UsesCane_Text + "','" + AssessData[i].G_UsesCane_Value + "','" + AssessData[i].G_Holds_Text + "','" + AssessData[i].G_Holds_Value + "' ");
                        sb.Append(" ,'" + AssessData[i].G_WideBase_Text + "','" + AssessData[i].G_WideBase_Value + "','" + AssessData[i].M_Alcohol_Text + "','" + AssessData[i].M_Alcohol_Value + "','" + AssessData[i].M_Post_Text + "','" + AssessData[i].M_Post_Value + "','" + AssessData[i].M_Cardiovascular_Text + "','" + AssessData[i].M_Cardiovascular_Value + "','" + AssessData[i].M_Diuretics_Text + "' ");
                        sb.Append(" ,'" + AssessData[i].M_Diuretics_Value + "','" + AssessData[i].M_Cathartics_Text + "','" + AssessData[i].M_Cathartics_Value + "','" + AssessData[i].M_Sedatives_Text + "','" + AssessData[i].M_Sedatives_Value + "','" + AssessData[i].M_Histamine_Text + "','" + AssessData[i].M_Histamine_Value + "','" + AssessData[i].M_Chemotherapy_Text + "','" + AssessData[i].M_Chemotherapy_Value + "' ");
                        sb.Append(" ,'" + AssessData[i].M_Narcotics_Text + "','" + AssessData[i].M_Narcotics_Value + "','" + AssessData[i].TotalRisk_Text + "','" + AssessData[i].TotalRisk_Value + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + Util.GetDateTime(AssessData[i].CreatedDate).ToString("yyyy-MM-dd HH:mm:ss") + "' ");
                        sb.Append(" ) ");
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
        public string AgeValue { get; set; }
        public string AgeText { get; set; }
        public string MentalStatusValue { get; set; }
        public string MentalStatusText { get; set; }
        public string LengthofStayValue { get; set; }
        public string LengthodStayText { get; set; }
        public string EliminationValue { get; set; }
        public string EliminationText { get; set; }
        public string ImpairmentValue { get; set; }
        public string ImpairmentText { get; set; }
        public string BloodPressueValue { get; set; }
        public string BloodPressueText { get; set; }
        public string G_Diagnosis_Value { get; set; }
        public string G_Diagnosis_Text { get; set; }
        public string G_History_Value { get; set; }
        public string G_History_Text { get; set; }
        public string G_LossWithoutHold_Value { get; set; }
        public string G_LossWithoutHold_Text { get; set; }
        public string G_LossStraight_Value { get; set; }
        public string G_LossStraight_Text { get; set; }
        public string G_Decreased_Value { get; set; }
        public string G_Decreased_Text { get; set; }
        public string G_Lurching_Value { get; set; }
        public string G_Lurching_Text { get; set; }
        public string G_UsesCane_Value { get; set; }
        public string G_UsesCane_Text { get; set; }
        public string G_Holds_Value { get; set; }
        public string G_Holds_Text { get; set; }
        public string G_WideBase_Value { get; set; }
        public string G_WideBase_Text { get; set; }
        public string M_Alcohol_Value { get; set; }
        public string M_Alcohol_Text { get; set; }
        public string M_Post_Value { get; set; }
        public string M_Post_Text { get; set; }
        public string M_Cardiovascular_Value { get; set; }
        public string M_Cardiovascular_Text { get; set; }
        public string M_Diuretics_Value { get; set; }
        public string M_Diuretics_Text { get; set; }
        public string M_Cathartics_Value { get; set; }
        public string M_Cathartics_Text { get; set; }
        public string M_Sedatives_Value { get; set; }
        public string M_Sedatives_Text { get; set; }
        public string M_Histamine_Value { get; set; }
        public string M_Histamine_Text { get; set; }
        public string M_Narcotics_Value { get; set; }
        public string M_Narcotics_Text { get; set; }
        public string M_Chemotherapy_Value { get; set; }
        public string M_Chemotherapy_Text { get; set; }
        public string TotalRisk_Value { get; set; }
        public string TotalRisk_Text { get; set; }
        public string CreatedBy { get; set; }
        public string CreatedDate { get; set; }
        public string ID { get; set; }
    }

    protected void btnPrint_Click(object sender, EventArgs e)
    {
        string TransactionID = Request.QueryString["TransactionID"].ToString();
        if (TransactionID != "")
        {
           // int count = Util.GetInt(StockReports.ExecuteScalar("Select COUNT(*) From ipd_adultfallassessmenttool where TransactionID='" + TransactionID + "'  "));
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT DATE_FORMAT(DATE,'%d-%b-%Y')DATE,TIME_FORMAT(TIME,'%H:%i %p')TIME,ads.TransactionID,ads.PatientID,Age_Text,Age_Value,MentalStatus_Text,MentalStatus_Value,Lengthofstay_Text,Lengthofstay_Value,Elimination_Text, ");
            sb.Append("Elimination_Value,Impairment_Text,Impairment_Value,BloodPressure_Text,BloodPressure_Value,G_Diagnosis_Text,G_Diagnosis_Value,G_History_Text,G_History_Value, ");
            sb.Append("G_LosswithoutHold_Text,G_LosswithoutHold_Value,G_LossStraight_Text,G_LossStraight_Value,G_Decreased_Text,G_Decreased_Value,G_Lurching_Text,G_Lurching_Value, ");
            sb.Append("G_UsesCane_Text,G_UsesCane_Value,G_Holds_Text,G_Holds_Value,G_Widebase_Text,G_Widebase_Value,M_Alcohol_Text,M_Alcohol_Value,M_Pos_Text,M_Pos_Value,M_Cardio_Text, ");
            sb.Append("M_Cardio_Value,M_Diuretics_Text,M_Diuretics_Value,M_Cath_Text,M_Cath_Value,M_Sedatives_Text,M_Sedatives_Value,M_Histamine_Text,M_Histamine_Value,M_Chemo_Text, ");
            sb.Append("M_Chemo_Value,M_Narco_Text,M_Narco_Value,M_HighRisk_Text,M_HishRisk_Value,CONCAT(rm.Room_No,'/',rm.Bed_No)BedNo,icm.name unit,DATE_FORMAT(pip.StartDate,'%d-%b-%Y')DOA,CONCAT(pm.Title,' ',pm.PName) NAME,pm.Age,pm.Gender, ");
            sb.Append("(IF(Age_Value='',0,Age_Value)+IF(MentalStatus_Value='',0,MentalStatus_Value)+IF(Lengthofstay_Value='','0',Lengthofstay_Value)+ ");
            sb.Append("IF(Elimination_Value='','0',Elimination_Value)+IF(Impairment_Value='','0',Impairment_Value)+IF(BloodPressure_Value='','0',BloodPressure_Value)+ ");
            sb.Append("IF(G_Diagnosis_Value='','0',G_Diagnosis_Value)+IF(G_History_Value='','0',G_History_Value)+IF(G_LosswithoutHold_Value='','0',G_LosswithoutHold_Value)+ ");
            sb.Append("IF(G_LossStraight_Value='','0',G_LossStraight_Value)+IF(G_Decreased_Value='','0',G_Decreased_Value)+IF(G_Lurching_Value='','0',G_Lurching_Value)+ ");
            sb.Append("IF(G_UsesCane_Value='','0',G_UsesCane_Value)+IF(G_Holds_Value='','0',G_Holds_Value)+IF(G_Widebase_Value='','0',G_Widebase_Value)+ ");
            sb.Append("IF(M_Alcohol_Value='','0',M_Alcohol_Value)+IF(M_Pos_Value='','0',M_Pos_Value)+IF(M_Cardio_Value='','0',M_Cardio_Value)+ ");
            sb.Append("IF(M_Diuretics_Value='','0',M_Diuretics_Value)+IF(M_Cath_Value='','0',M_Cath_Value)+IF(M_Sedatives_Value='','0',M_Sedatives_Value)+ ");
            sb.Append("IF(M_Histamine_Value='','0',M_Histamine_Value)+IF(M_Chemo_Value='','0',M_Chemo_Value)+IF(M_Narco_Value='','0',M_Narco_Value)+IF(M_HishRisk_Value='','0',M_HishRisk_Value)) TotalScore ");
            sb.Append("FROM ipd_adultfallassessmenttool ads ");
            sb.Append("INNER JOIN (SELECT MAX(p.PatientIPDProfile_ID)PatientIPDProfile_ID,p.TransactionID FROM patient_ipd_profile p WHERE p.TransactionID='" + TransactionID + "')p ");
            sb.Append("ON p.TransactionID=ads.TransactionID INNER JOIN patient_ipd_profile pip ON pip.PatientIPDProfile_ID=p.PatientIPDProfile_ID ");
            sb.Append("INNER JOIN ipd_case_type_master icm ON icm.IPDCaseTypeID=pip.IPDCaseTypeID INNER JOIN room_master rm ON rm.RoomId=pip.RoomID ");
            sb.Append("INNER JOIN patient_master pm ON pm.PatientID=ads.PatientID WHERE ads.TransactionID='" + TransactionID + "' ");
            if (Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") != string.Empty)
                sb.Append(" and DATE(ads.DATE) >= '" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "'  ");
            if (Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") != string.Empty)
                sb.Append(" AND DATE(ads.DATE) <= '" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'  ");
            sb.Append("Order by DATE,TIME desc LIMIT 0,12 ");
            DataTable dtReport = StockReports.GetDataTable(sb.ToString());
            if (dtReport.Rows.Count > 0)
            {
                Session["DataTable"] = dtReport;
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow1", "window.open('AdultFallAssessmenttoolReport.aspx');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Data Not Available For Print.');", true);
            }
        }
    }
}