using System;
using System.Data;
using System.Web.Services;

public partial class Design_CPOE_Cpoe_PreviousVisit : System.Web.UI.Page
{
    public string App_ID;
    public string IsDone;
    public string LnxNo;
    public string PatientID;
    public string TID;

    [WebMethod]
    public static string bindPreviousVisit(string TID, string PID)
    {
        try
        {
            DataTable visit = StockReports.GetDataTable("Select DATE_FORMAT(DateOfVisit,'%d-%b-%Y')DateVisit,CONCAT(dm.Title,' ',dm.Name)DName,pmh.DoctorID,lt.TransactionID,lt.LedgerTransactionNo " +
                " from patient_medical_history pmh INNER JOIN Doctor_master dm on pmh.DoctorID=dm.DoctorID INNER JOIN f_ledgertransaction lt ON lt.`TransactionID`=pmh.`TransactionID`  AND lt.`TypeOfTnx`='OPD-APPOINTMENT' where pmh.TransactionID !='" + TID + "' AND pmh.PatientID='" + PID + "' ORDER BY DateOfVisit DESC");

            if (visit.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(visit);
            else
                return "";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
    }

    [WebMethod]
    public static string bindReferralConsultation(string TID, string PID, string App_ID)
    {
        try
        {
            DataTable ReferralConsultation = StockReports.GetDataTable("select CONCAT(em.title,' ',em.Name)UserName,DATE_FORMAT(ref.DATE,'%d-%b-%Y')Date,DATE_FORMAT(ref.TIME,'%h:%i %p')Time,ref.ReferralType,ref.ConsultationType,ref.FromDrID,ref.Regarding,ref.Consultation," +
                " ref.Impression,ref.Treatment,ref.EntryBy,ref.EntryDate from cpoe_referralConsultation ref inner join employee_master em ON ref.FromDrID=em.Employee_ID where TransactionID='" + TID + "' ");
            if (ReferralConsultation.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(ReferralConsultation);
            else
                return "";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
    }

    [WebMethod]
    public static string bindVitalSign(string TID)
    {
        try
        {
            DataTable dtVitalSign = StockReports.GetDataTable("SELECT DATE_FORMAT(EntryDate,'%d-%b-%y')Date,BP,P,R,T,HT,WT,BMI,ArmSpan,SHight,IBWKg FROM cpoe_vital WHERE TransactionID='" + TID + "'");
            if (dtVitalSign.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(dtVitalSign);
            else
                return "";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!IsPostBack)
            {

                TID = Convert.ToString(Request.QueryString["TID"]);
                if (string.IsNullOrEmpty(TID)) {
                    TID = Util.GetString(Request.QueryString["TransactionID"]);
                }

                PatientID = Convert.ToString(Request.QueryString["PID"]);

                if (string.IsNullOrEmpty(PatientID))
                    PatientID = Convert.ToString(Request.QueryString["PatientID"]);
                if (string.IsNullOrEmpty(PatientID))
                    PatientID = Util.GetString(Request.QueryString["PatientId"]);
                


                App_ID = Convert.ToString(Request.QueryString["App_ID"]);
                LnxNo = Convert.ToString(Request.QueryString["LnxNo"]);
                IsDone = Convert.ToString(Request.QueryString["IsDone"]);
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
}