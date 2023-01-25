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

public partial class Design_IPD_BabyFeedingAndObservation : System.Web.UI.Page
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

            string motherTID = StockReports.ExecuteScalar("SELECT motherTID FROM patient_medical_history WHERE TransactionID='" + TID + "' LIMIT 1");
            if (motherTID == "")
            {
                lblMotherID.Text = motherTID;
            }           
        }
        txtDate.Attributes.Add("readOnly", "true");
    }

    [WebMethod]
    public static string bindData(string TransID, string Date)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT IFNULL(nbf.ID,'')ID,TIME_FORMAT(tm.Time,'%h:%i %p')Time_Label,tm.Shift,IFNULL(em.Name,'')Name,IFNULL(nbf.Date,'')DATE,IFNULL(nbf.Infusion,'')Infusion, ");
        sb.Append(" IFNULL(nbf.NGTOral,'')NGTOral,IFNULL(nbf.NGTOnly,'')NGTOnly, IFNULL(nbf.Drugs,'')Drugs,IFNULL(nbf.Urine,'')Urine,IFNULL(nbf.Bowel,'')Bowel,IFNULL(nbf.Temp,'')Temp,IFNULL(nbf.Remarks,'')Remarks, ");
        sb.Append(" IF(IFNULL(Infusion,'')<>'',IF(IFNULL(nbf.CreatedBy,'')='" + HttpContext.Current.Session["ID"].ToString() + "',IF(IFNULL(TIMESTAMPDIFF(MINUTE,CreatedDate,NOW()),0)<" + Util.GetInt(Resources.Resource.EditTimePeriod) + ",'1','0'),'0'),'1')IsInfusionEdit, ");
        sb.Append(" IF(IFNULL(NGTOral,'')<>'',IF(IFNULL(nbf.CreatedBy,'')='" + HttpContext.Current.Session["ID"].ToString() + "',IF(IFNULL(TIMESTAMPDIFF(MINUTE,CreatedDate,NOW()),0)<" + Util.GetInt(Resources.Resource.EditTimePeriod) + ",'1','0'),'0'),'1')IsNgtOralEdit, ");
        sb.Append(" IF(IFNULL(NGTOnly,'')<>'',IF(IFNULL(nbf.CreatedBy,'')='" + HttpContext.Current.Session["ID"].ToString() + "',IF(IFNULL(TIMESTAMPDIFF(MINUTE,CreatedDate,NOW()),0)<" + Util.GetInt(Resources.Resource.EditTimePeriod) + ",'1','0'),'0'),'1')IsNGTOnlyEdit, ");
        sb.Append(" IF(IFNULL(Drugs,'')<>'',IF(IFNULL(nbf.CreatedBy,'')='" + HttpContext.Current.Session["ID"].ToString() + "',IF(IFNULL(TIMESTAMPDIFF(MINUTE,CreatedDate,NOW()),0)<" + Util.GetInt(Resources.Resource.EditTimePeriod) + ",'1','0'),'0'),'1')IsDrugsEdit, ");
        sb.Append(" IF(IFNULL(Urine,'')<>'',IF(IFNULL(nbf.CreatedBy,'')='" + HttpContext.Current.Session["ID"].ToString() + "',IF(IFNULL(TIMESTAMPDIFF(MINUTE,CreatedDate,NOW()),0)<" + Util.GetInt(Resources.Resource.EditTimePeriod) + ",'1','0'),'0'),'1')IsUrineEdit, ");
        sb.Append(" IF(IFNULL(Bowel,'')<>'',IF(IFNULL(nbf.CreatedBy,'')='" + HttpContext.Current.Session["ID"].ToString() + "',IF(IFNULL(TIMESTAMPDIFF(MINUTE,CreatedDate,NOW()),0)<" + Util.GetInt(Resources.Resource.EditTimePeriod) + ",'1','0'),'0'),'1')IsBowelEdit, ");
        sb.Append(" IF(IFNULL(Temp,'')<>'',IF(IFNULL(nbf.CreatedBy,'')='" + HttpContext.Current.Session["ID"].ToString() + "',IF(IFNULL(TIMESTAMPDIFF(MINUTE,CreatedDate,NOW()),0)<" + Util.GetInt(Resources.Resource.EditTimePeriod) + ",'1','0'),'0'),'1')IsTempEdit, ");
        sb.Append(" IF(IFNULL(Remarks,'')<>'',IF(IFNULL(nbf.CreatedBy,'')='" + HttpContext.Current.Session["ID"].ToString() + "',IF(IFNULL(TIMESTAMPDIFF(MINUTE,CreatedDate,NOW()),0)<" + Util.GetInt(Resources.Resource.EditTimePeriod) + ",'1','0'),'0'),'1')IsRemarksEdit, ");
        sb.Append(" IF(IFNULL(nbf.CreatedBy,'')='" + HttpContext.Current.Session["ID"].ToString() + "',IF(IFNULL(TIMESTAMPDIFF(MINUTE,CreatedDate,NOW()),0)<" + Util.GetInt(Resources.Resource.EditTimePeriod) + ",'1','0'),'1')IsSelect,nbf.CreatedDate ");
        sb.Append(" FROM time_master tm LEFT JOIN nursing_BabyFeedingandObservation nbf ON tm.Time=nbf.Time AND nbf.Date='" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "'and nbf.IsActive=1 AND TransactionID='" + TransID + "'  ");
        sb.Append(" LEFT JOIN employee_master em ON em.EmployeeID=nbf.CreatedBy ORDER BY tm.Time ");
        
        DataTable dtDetails = StockReports.GetDataTable(sb.ToString());
        
        if (dtDetails.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtDetails);
        }
        
        return "";
    }

    [WebMethod(EnableSession = true, Description = "Save Intake")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string saveBabyFeeding(object babyfeeding, string PID, string TID)
    {
        List<BabyFeeding> BabyFeeding = new JavaScriptSerializer().ConvertToType<List<BabyFeeding>>(babyfeeding);
        if (BabyFeeding.Count > 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                for (int i = 0; i < BabyFeeding.Count; i++)
                {
                    if (BabyFeeding[i].CreatedBy == "")
                    {
                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO nursing_BabyFeedingandObservation(TransactionID,PatientID,Date,Time,Infusion,NGTOral,NGTOnly,Drugs,Urine,Bowel,Temp,Remarks,CreatedBy,Shift,CreatedDate  " +
                            " )VALUE('" + TID + "','" + PID + "','" + Util.GetDateTime(BabyFeeding[i].Date).ToString("yyyy-MM-dd") + "', " +
                            " '" + Util.GetDateTime(BabyFeeding[i].Time).ToString("HH:mm:ss") + "','" + BabyFeeding[i].Infusion + "','" + BabyFeeding[i].NGTOral + "','" + BabyFeeding[i].NGTOnly + "','" + BabyFeeding[i].Drugs + "','" + BabyFeeding[i].Urine + "' " +
                            " ,'" + BabyFeeding[i].Bowel + "','" + BabyFeeding[i].Temp + "','" + BabyFeeding[i].Remarks + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + BabyFeeding[i].Shift + "',Now() )");
                    }
                    else
                    {
                        string str = "UPDATE nursing_babyfeedingandobservation SET IsActive=0,UpdateDate=Now(),UpdateBy='" + HttpContext.Current.Session["ID"].ToString() + "' WHERE ID = '" + BabyFeeding[i].ID + "' ";
                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str);

                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO nursing_BabyFeedingandObservation(TransactionID,PatientID,Date,Time,Infusion,NGTOral,NGTOnly,Drugs,Urine,Bowel,Temp,Remarks,CreatedBy,Shift,CreatedDate  " +
                            " )VALUE('" + TID + "','" + PID + "','" + Util.GetDateTime(BabyFeeding[i].Date).ToString("yyyy-MM-dd") + "', " +
                            " '" + Util.GetDateTime(BabyFeeding[i].Time).ToString("HH:mm:ss") + "','" + BabyFeeding[i].Infusion + "','" + BabyFeeding[i].NGTOral + "','" + BabyFeeding[i].NGTOnly + "','" + BabyFeeding[i].Drugs + "','" + BabyFeeding[i].Urine + "' " +
                            " ,'" + BabyFeeding[i].Bowel + "','" + BabyFeeding[i].Temp + "','" + BabyFeeding[i].Remarks + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + BabyFeeding[i].Shift + "','" + Util.GetDateTime(BabyFeeding[i].CreatedDate).ToString("yyyy-MM-dd HH:mm:ss") + "' )");
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

    public class BabyFeeding
    {
        public string Infusion { get; set; }
        public string NGTOral { get; set; }
        public string NGTOnly { get; set; }
        public string Drugs { get; set; }
        public string Urine { get; set; }
        public string Bowel { get; set; }
        public string Temp { get; set; }
        public string Remarks { get; set; }
        public string Time { get; set; }
        public string Date { get; set; }
        public string Shift { get; set; }
        public string CreatedBy { get; set; }
        public string CreatedDate { get; set; }
        public string ID { get; set; }
    }
    
    protected void btnPrint_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT IFNULL(nbf.ID,'')ID,TIME_FORMAT(tm.Time,'%h:%i %p')Time_Label,tm.Shift,IFNULL(em.Name,'')Name,IFNULL(nbf.Date,'')DATE,IFNULL(nbf.Infusion,'')Infusion, ");
        sb.Append(" IFNULL(nbf.NGTOral,'')NGTOral,IFNULL(nbf.NGTOnly,'')NGTOnly, IFNULL(nbf.Drugs,'')Drugs,IFNULL(nbf.Urine,'')Urine,IFNULL(nbf.Bowel,'')Bowel,IFNULL(nbf.Temp,'')Temp,IFNULL(nbf.Remarks,'')Remarks ");
        sb.Append(" FROM time_master tm LEFT JOIN nursing_BabyFeedingandObservation nbf ON tm.Time=nbf.Time AND nbf.Date='" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "' AND TransactionID='" + ViewState["TransID"].ToString() + "' and nbf.isactive=1 ");
        sb.Append(" LEFT JOIN employee_master em ON em.EmployeeID=nbf.CreatedBy ORDER BY tm.Time ");
        
        DataTable dtDetails = StockReports.GetDataTable(sb.ToString());
        
        if (dtDetails.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dtDetails.Copy());
            ds.Tables[0].TableName = "BabyFeedingandOnservation";
            AllQuery AQ = new AllQuery();
            DataTable dtStatus = AQ.GetPatientDischargeStatus(ViewState["TransID"].ToString());
            string Status = dtStatus.Rows[0]["Status"].ToString();
            DataTable dtInfo = AQ.GetPatientIPDInformation("", ViewState["TransID"].ToString(), Status);
            ds.Tables.Add(dtInfo.Copy());
            ds.Tables[1].TableName = "PatientInfo";
            DataTable dtImg = All_LoadData.CrystalReportLogo();
            ds.Tables.Add(dtImg.Copy());
            ds.Tables[2].TableName = "logo";
            Session["ReportName"] = "BabyFeedingandOnservationChart";
            Session["ds"] = ds;
            //ds.WriteXmlSchema(@"E:\BabyFeedingandOnservation.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
        }
        else
        {
            lblMsg.Text = "No Record Found";
        }
    }
}