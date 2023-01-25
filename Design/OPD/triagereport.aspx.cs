using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OPD_TriageReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }
    protected void btnReport_Click(object sender, EventArgs e)
    {
        if (ddlReportType.SelectedValue == "0")
        {
            lblMsg.Text = "Select Report Type";
            return;
        }

        string FromDate = Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd");
        string ToDate = Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd");
        StringBuilder sb = new StringBuilder();

        if (ddlReportType.SelectedValue == "1")
        {
            sb = new StringBuilder();

            sb.Append("   SELECT CONCAT(pm.`Title`,'',pm.`PName`)'Name',pm.`Age`,pm.`Gender`    ");
            sb.Append("   Sex,cv.`BP`,cv.`P` 'Pulse',cv.`R` 'Respiratory Rate',cv.`SPO2` 'Spo2(Oxygen Saturation)',cv.`PainScore`,     ");
            sb.Append("    DATE_FORMAT( cv.`EntryDate`,'%d-%b-%Y %I:%i %p')'Date',cv.`Remarks`     ");
            sb.Append("   FROM cpoe_vital cv    ");
            sb.Append("   INNER JOIN patient_master pm ON pm.`PatientID`=cv.`PatientID`    ");
            sb.Append("   WHERE DATE(cv.`EntryDate`)>='" + FromDate + "' AND  DATE(cv.`EntryDate`)<='" + ToDate + "'    ");
            sb.Append("   ORDER BY cv.`EntryDate` DESC     ");

            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0 && dt != null)
            {

                Session["dtExport2Excel"] = dt;
                Session["Period"] = "From " + Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");
                Session["ReportName"] = "Appointments Outpatient Report(Triage)";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
                lblMsg.Text = "";
            }
            else
            {
                lblMsg.Text = "No Record Found";
            }
        }

        if (ddlReportType.SelectedValue == "2")
        {
            sb = new StringBuilder();


            sb.Append("    SELECT CONCAT(pm.`Title`,'',pm.`PName`)'Name',pm.`Age`,pm.`Gender` Sex,cv.`BP`,cv.`P` 'Pulse',cv.`R` 'Respiratory Rate',cv.`SPO2` 'Spo2(Oxygen Saturation)',cv.`PainScore`,   ");
            sb.Append("    DATE_FORMAT( cv.`EntryDate`,'%d-%b-%Y %I:%i %p')'Date',cv.`Remarks`,pmh.`TransNo` 'Encounter' ,  ");
            sb.Append("    (SELECT IF(COUNT(cpmh.`TransactionID`)>0,'Yes','No') FROM  patient_medical_history cpmh   ");
            sb.Append("   WHERE cpmh.`EmergencyTransactionId`=cv.`TransactionID` AND cpmh.`EmergencyTransactionId`<>'') 'Admission If Any','' Icu_Care,  ");

            sb.Append("   (SELECT IF( TIMESTAMPDIFF(HOUR,CONCAT( DATE(mh.`DateOfAdmit`),' ',TIME(mh.`TimeOfAdmit`)),CONCAT( DATE(mh.`DateOfDischarge`),' ',TIME(mh.`TimeOfDischarge`)))<24,'Death Within 24Hour',   ");
            sb.Append("    IF(TIMESTAMPDIFF(HOUR,CONCAT( DATE(mh.`DateOfAdmit`),' ',TIME(mh.`TimeOfAdmit`)),CONCAT( DATE(mh.`DateOfDischarge`),' ',TIME(mh.`TimeOfDischarge`)))<48,'Death within 48Hour','Death Above 48Hours') )   ");
            sb.Append("    FROM  patient_medical_history mh   ");
            sb.Append("   WHERE (mh.`TransactionID`='1179' OR mh.`EmergencyTransactionId`='1179')  AND  mh.`DischargeType`='Death'   ");
            sb.Append("   AND IFNULL(mh.`DateOfDischarge`,'0001-01-01')<>'0001-01-01')'Death Within 24,48 Hrs'  ");

            sb.Append("   FROM cpoe_vital cv  ");
            sb.Append("   INNER JOIN patient_master pm ON pm.`PatientID`=cv.`PatientID`  ");
            sb.Append("   INNER JOIN patient_medical_history pmh ON pmh.`TransactionID`=cv.`TransactionID` AND pmh.`PatientID`=pm.`PatientID` AND pmh.`TYPE`='EMG'  ");
            sb.Append("   WHERE DATE(cv.`EntryDate`)>='" + FromDate + "' AND  DATE(cv.`EntryDate`)<='" + ToDate + "'    ");
            sb.Append("   ORDER BY cv.`EntryDate` DESC  ");

            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0 && dt != null)
            {

                Session["dtExport2Excel"] = dt;
                Session["Period"] = "From " + Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");
                Session["ReportName"] = "Casulty Reports";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
                lblMsg.Text = "";
            }
            else
            {
                lblMsg.Text = "No Record Found";
            }
        }



    }
}