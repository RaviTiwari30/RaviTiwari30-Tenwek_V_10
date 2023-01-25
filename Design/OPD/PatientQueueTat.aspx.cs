using System;
using System.Data;
using System.IO;
using System.Text;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;


public partial class Design_OPD_PatientQueueTat : System.Web.UI.Page
{    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            try
            {                
                All_LoadData.bindDocTypeList(ddlDept, 5, "Select");                
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
            }
        }        
  }
   

  [WebMethod(EnableSession = true)]
    public static string FillTable(string clinic)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT CONCAT(pm.Title,' ',pm.Pname)Pname,fpm.Company_Name AS PanelName, ");
        sb.Append(" CASE  ");
        sb.Append(" WHEN Triage = 1 THEN 'Triage'  ");
        sb.Append(" WHEN Doc_Recon = 1 THEN 'Doctor'  ");
        sb.Append(" WHEN Lab = 1 THEN  'LAB'  ");
        sb.Append(" WHEN Pharm = 1 THEN 'Pharmacy' ");  
        sb.Append(" ELSE 'Unassigned'   ");
        sb.Append(" END AS 'WaitingLocation', ");
        sb.Append(" t1.* FROM  ");
        sb.Append(" ( ");
        sb.Append(" SELECT t.PanelID,t.EncounterNo,t.PatientID,t.LabStatus,t.WaitingTime,t.Status, ");
        sb.Append(" IF(t.Una=1,0,IF(t.Triage=1 AND t.Doc_Recon=1,0,1))Triage, ");
        sb.Append(" IF(t.Una=1,0,IF(t.Doc_Recon=1 AND t.Lab=1,0,1))Doc_Recon, ");
        sb.Append(" IF(t.Una=1,0,IF(t.Lab=1 AND t.Pharm=1,0,1))Lab, ");
        sb.Append(" IF(t.Una=1,0,IF(t.Lab=1 AND t.Pharm=1,1,0))Pharm, ");
        sb.Append(" IF(t.Una=1,1,0)Una FROM  ");
        sb.Append(" ( ");
        sb.Append(" SELECT lt.PanelID,lt.EncounterNo,app.PatientID,'' LabStatus, ");
        sb.Append(" IF(app.TemperatureRoom=0,TIME_FORMAT(TIMEDIFF(CURTIME(),app.TIME),'%H:%i:%s'),'')WaitingTime, ");
        sb.Append(" 'WAIT' STATUS,IF(TemperatureRoom=1,1,0)Triage,IF(app.P_IN=1,1,0)Doc_Recon, ");
        sb.Append(" IF((SELECT COUNT(IsSampleCollected) FROM patient_labinvestigation_opd WHERE TransactionID = ");
        sb.Append(" (SELECT OPDTransactionID FROM patient_test pt WHERE pt.App_ID=app.App_ID LIMIT 1) AND IsSampleCollected = 'S')>0,1,0)Lab, ");
        sb.Append(" IF((SELECT COUNT(IsIssued) FROM patient_medicine WHERE App_ID=app.App_ID AND IsIssued = '1')>0,1,0)Pharm, ");
        sb.Append(" IF(TemperatureRoom=0,1,0)Una ");
        sb.Append(" FROM patient_encounter pe ");
        sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.EncounterNo = pe.EncounterNo ");
        sb.Append(" INNER JOIN appointment app ON app.TransactionID = lt.TransactionID ");
        sb.Append(" INNER JOIN doctor_master dm ON dm.DoctorID = app.DoctorID  ");
        sb.Append(" WHERE app.PatientID<>'' AND app.IsConform=1 AND app.IsCancel=0 AND app.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' ");
        sb.Append(" AND DATE(pe.DATETIME) BETWEEN '" + Util.GetDateTime(DateTime.Now.Date).ToString("yyyy-MM-dd") + "' ");
        sb.Append(" AND '" + Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd") + "'  AND dm.DocDepartmentID='" + clinic + "'  ");
        sb.Append(" )t  ");
        sb.Append(" )t1  ");
        sb.Append(" INNER JOIN patient_master pm ON pm.PatientID = t1.PatientID ");
        sb.Append(" INNER JOIN f_panel_master fpm ON fpm.PanelID = t1.PanelID ");
        sb.Append(" ORDER BY EncounterNo  ");
             
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
}