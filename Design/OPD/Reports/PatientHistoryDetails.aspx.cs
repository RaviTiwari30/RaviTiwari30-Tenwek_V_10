using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using MySql.Data.MySqlClient;
using System.Web.Services;
using System.Web.Script.Serialization;
using System.Web;
using System.Web.Script.Services;
using System.Collections.Generic;

public partial class Design_OPD_PatientHistoryDetails : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtToDate.Text = txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
        txtFromDate.Attributes.Add("readonly", "true");
        txtToDate.Attributes.Add("readonly", "true");
    }
    [WebMethod]
    public static string GetPatientHistory(string PID, string fromDate, string toDate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT pm.`PatientID` 'MRNo',CONCAT(pm.`Title`,' ',pm.`PName`,IF(pm.`RelationName`='','',CONCAT(' ',pm.`Relation`,' ',pm.`RelationName`))) 'PatientName', ");
        sb.Append(" CONCAT(Get_Current_Age(pm.`PatientID`),'/',pm.`Gender`) 'AgeGender',pm.`Mobile` 'ContactNo', ");
        sb.Append(" CONCAT(pm.`House_No`,IF(pm.`City`='','',CONCAT(',',pm.`City`)),IF(pm.`District`='','',CONCAT(',',pm.`District`)),IF(pm.`State`='','',CONCAT(',',pm.`State`))) 'Adderss' ");
        sb.Append(" ,DATE_FORMAT(pmh.`DateOfVisit`,'%d-%b-%Y')'InDate',IFNULL(DATE_FORMAT(IF(pmh.`DateOfDischarge` IS NULL,pmh.`DateOfVisit`,IF(pmh.`DateOfDischarge`='0001-01-01','',pmh.`DateOfDischarge`)),'%d-%b-%Y'),'Still Admitted')'OutDate', ");
        sb.Append(" pmh.`Type`,IF(pmh.`Type`='IPD','IPD ADMISSION',(SELECT lt.`TypeOfTnx` FROM `f_ledgertransaction` lt WHERE lt.`TransactionID`=pmh.`TransactionID` LIMIT 1))'TnxType' ");
        sb.Append(" ,REPLACE(IFNULL(pmh.`TransactionID`,''),'ISHHI','')'IPDNo',pmh.`TransactionID`,CONCAT(dm.`Title`,' ',dm.`Name`)'Doctor' ");
        sb.Append(" ,IFNULL(IF(pmh.`Type`='OPD',(SELECT lt.`BillNo` FROM `f_ledgertransaction` lt WHERE lt.`TransactionID`=pmh.`TransactionID`),(SELECT adj.`BillNo` FROM `patient_medical_history` adj WHERE adj.`TransactionID`=pmh.`TransactionID`)),'Not Generated Yet')'BillNo' ");
        sb.Append(" ,(IF(pmh.`Type`<>'IPD',(SELECT lt.`LedgerTransactionNo` FROM `f_ledgertransaction` lt WHERE lt.`TransactionID`=pmh.`TransactionID` LIMIT 1),''))LTnxNo ");
        sb.Append(" FROM patient_medical_history pmh  ");
        sb.Append(" INNER JOIN patient_master pm ON pm.`PatientID`=pmh.`PatientID` and pm.`PatientID`='" + Util.GetFullPatientID(PID) + "' ");
        //sb.Append(" LEFT JOIN ipd_case_history ich ON ich.`TransactionID`=pmh.`TransactionID` ");
        sb.Append(" INNER JOIN doctor_master dm ON dm.`DoctorID`=pmh.`DoctorID` ");
        if (!String.IsNullOrEmpty(fromDate))
            sb.Append(" AND pmh.`DateOfVisit`>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND pmh.`DateOfVisit`<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ");
        sb.Append(" ORDER BY CONCAT(pmh.`DateOfVisit`,' ',pmh.`Time`) ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
        return "";
    }
    [WebMethod]
    public static string GetPatientVisitDetails(string TnxId, string TnxType, string LTnxNo)
    {
        if (TnxType.Trim().ToUpper() == "OPD-LAB")
            return Util.GetString(StockReports.ExecuteScalar(" SELECT IFNULL(GROUP_CONCAT(pli.`Test_ID`),'') FROM `patient_labinvestigation_opd` pli WHERE pli.`LedgerTransactionNo`='" + LTnxNo + "' AND pli.`Result_Flag`=1 "));
        else if (TnxType.Trim().ToUpper() == "IPD ADMISSION")
            return Util.GetString(StockReports.ExecuteScalar(" SELECT TransactionID FROM emr_DRDetail WHERE TransactionID='" + TnxId + "' "));

        return "";
    }
}