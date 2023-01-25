using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OT_OTBooking : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            txtSurgeryDate.Text = txtSearchModelFromDate.Text = txtSerachModelToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            calExdTxtSerachModelToDate.EndDate = calExdTxtSearchModelFromDate.EndDate = calExdTxtSerachModelToDate.EndDate = System.DateTime.Now;
            Calendarextender1.StartDate = System.DateTime.Now;

            var isDoctorLogin = Util.GetString(HttpContext.Current.Session["RoleID"]) == "52" ? 1 : 0;
            string defaultDoctorID = "0";
            ViewState["IsDoctorLogin"] = isDoctorLogin;


            ExcuteCMD excuteCMD = new ExcuteCMD();
            if (isDoctorLogin > 0)
            {
                defaultDoctorID = excuteCMD.ExecuteScalar("select DoctorID from doctor_employee where Employee_id=@doctorID", new
                {
                    doctorID = HttpContext.Current.Session["ID"].ToString()
                });
            }
            ViewState["defaultDoctorID"] = defaultDoctorID;
        }

        txtSearchModelFromDate.Attributes.Add("readOnly", "readOnly");
        txtSurgeryDate.Attributes.Add("readOnly", "readOnly");
        txtSerachModelToDate.Attributes.Add("readOnly", "readOnly");
        ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");
        txtShedulingDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        txtShedulingDate.Attributes.Add("readOnly", "readOnly");
    }



    [WebMethod(EnableSession = true)]
    public static string bindData(string patientID, string IPDNo, string EMGNo)
    {
        try
        {
            string TID = string.Empty;
            if (string.IsNullOrEmpty(patientID) && string.IsNullOrEmpty(IPDNo) && string.IsNullOrEmpty(EMGNo))
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Please Enter Search Criteria" });

            if (IPDNo.Contains("LSHHI"))
                TID = IPDNo;
            else
                TID = "ISHHI" + IPDNo;


            StringBuilder sb = new StringBuilder();

            sb.Append("SELECT 1 IsRegistredPatient,0 bookingID,0 DoctorID,0 SurgeryID,IFNULL(IF(pmh.TransactionID LIKE 'ISHHI%','',IF(pmh.Type='EMG',emg.EmergencyNo,'')),'')EmergencyNo ,pm.PatientID, CONCAT(pm.Title, ' ', pm.PName) PName,(pm.Title)Title,(pm.PName)PatientName, pm.Age, pm.Gender, pm.Country, pm.Mobile ContactNo, CONCAT(pm.House_No, ' ,', pm.City) Address, pmh.TransactionID, pm.HospPatientType, IFNULL(PMH.`PanelID`, '') PanelID, IFNULL(fpm.Company_Name, '') Company_Name, IFNULL(pmh.DoctorID, '') DoctorID, '' PharmacyOSAmt , IF(pmh.TransactionID LIKE 'ISHHI%',pip.Status,IF(emg.IsReleased=0 and pmh.Type='EMG','IN','OUT')) AS Status FROM patient_master pm LEFT JOIN patient_medical_history pmh ON pm.PatientID = pmh.PatientID  AND pmh.Type IN('EMG','IPD') LEFT JOIN f_panel_master fpm ON fpm.PanelID = pm.PanelID LEFT JOIN patient_ipd_profile pip ON pip.PatientID=pm.PatientID AND pip.Status='IN' AND pip.CentreID=@CentreID LEFT JOIN emergency_patient_details emg ON emg.TransactionId=pmh.TransactionID AND pmh.CentreID=@CentreID AND emg.IsReleased=0 WHERE pm.PatientID IS NOT NULL ");

            if (!string.IsNullOrEmpty(patientID))
                sb.Append(" AND pm.PatientID = @patientID");

            if (!string.IsNullOrEmpty(IPDNo))
                sb.Append(" AND pmh.TransactionID=@transactionID");

            if (!string.IsNullOrEmpty(EMGNo))
                sb.Append(" AND emg.EmergencyNo=@emergencyNo");

            sb.Append("  ORDER BY CONCAT(PMH.DateOfVisit,' ',PMH.Time) DESC ");

            ExcuteCMD excuteCMD = new ExcuteCMD();


            //string s = excuteCMD.GetRowQuery(sb.ToString(), new
            //{
            //    patientID =patientID, //Util.GetFullPatientID(patientID),
            //    transactionID = TID,
            //    emergencyNo = EMGNo,
            //    CentreID = HttpContext.Current.Session["CentreID"].ToString()
            //});



            DataTable dataTable = excuteCMD.GetDataTable(sb.ToString(), CommandType.Text, new
            {
                patientID = patientID,
                transactionID = TID,
                emergencyNo = EMGNo,
                CentreID = HttpContext.Current.Session["CentreID"].ToString()
            });



            // Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = dataTable });
            if (dataTable.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = dataTable });
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = dataTable, message = "No Record Found, May be patient already discharged, or may be already released from emergency." });
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Error occurred, Please contact administrator", response = ex.Message });
        }
    }




    [WebMethod]
    public static string GetAllSurgery()
    {
        StringBuilder sb = new StringBuilder();
       // sb.Append(" SELECT sm.Name,sm.Surgery_ID FROM f_surgery_master sm WHERE sm.IsActive=1 order by Name ");
         sb.Append(" SELECT CONCAT('CPT: ',im.ItemCode,' ',im.TypeName)Name,im.itemid Surgery_ID FROM f_itemmaster im INNER JOIN  f_subcategorymaster sm ON sm.SubCategoryID =im.SubCategoryID ");
         sb.Append(" INNER JOIN f_configrelation cf ON sm.categoryid = cf.categoryid AND cf.configID=25 AND cf.categoryid=46 WHERE sm.active=1 AND im.IsActive=1 ORDER BY im.TypeName ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


    [WebMethod(EnableSession = true)]
    public static string GetOtDetils()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT om.Id,om.Name FROM ot_master om WHERE om.IsActive=1  order by om.Id asc ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0 && dt != null)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = dt });
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data = dt });
        }

    }
    [WebMethod(EnableSession = true)]
    public static string GetPatientDetails(string Date, int OtId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT IF(IFNULL(ob.PatientID,'')<>'',ob.PatientID,ob.OutPatientID)PatientID,ob.PatientName, ");
        sb.Append(" CONCAT(TIME_FORMAT(ob.SlotFromTime,'%I:%i %p'),' to ',TIME_FORMAT(ob.SlotToTime,'%I:%i %p'))SlotTime, ");
        sb.Append(" sm.NAME Surgery ,CONCAT(dm.Title,' ',dm.NAME)Doctor ");
        sb.Append(" FROM ot_booking ob ");
        sb.Append(" INNER JOIN f_surgery_master sm ON sm.Surgery_ID=ob.SurgeryID ");
        sb.Append(" INNER JOIN  doctor_master dm ON dm.DoctorID=ob.DoctorID ");
        sb.Append(" WHERE ob.IsActive=1 AND ob.IsCancel=0 AND ob.OTID="+OtId+" AND DATE(ob.SurgeryDate)='"+Util.GetDateTime(Date).ToString("yyyy-MM-dd")+"' ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0 && dt != null)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = dt });
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data = dt });
        }

    }
}