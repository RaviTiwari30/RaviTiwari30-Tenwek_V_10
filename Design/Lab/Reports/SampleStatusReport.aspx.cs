using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;

public partial class Design_Lab_Reports_SampleStatusReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtfromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnSearch);
        }
        txtfromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }
    private void BindReport()
    {
        string Centre = "";
        Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Select Centre";
            return;
        }
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT plo.BarcodeNo,plo.PatientID As UHID,CONCAT(pm.Title,'',pm.PName)PatientName,pm.Age,pm.Gender,im.Name TestName, ");
        //sb.Append("IF(plo.Type=2,REPLACE(plo.TransactionID,'ISHHI',''),'')'IPD No.', ");
        sb.Append("IF(plo.Type=2,pmh.TransNo,'')'IPD No.', ");
        //sb.Append("CASE WHEN plo.Type=1 THEN 'OPD' WHEN plo.Type=2 THEN 'IPD' ELSE 'Emergency' END SampleType, ");
		sb.Append("pmh.type SampleType, ");
        sb.Append("CASE   WHEN plo.IsDispatch='1' THEN 'Report Dispatched'   ");
        sb.Append("WHEN plo.IsSampleCollected='R' THEN 'Sample Rejected'  ");
        sb.Append("WHEN plo.Approved='1' AND plo.isPrint='1' THEN 'Report Dispatched'   ");
        sb.Append("WHEN plo.Approved='1'  THEN 'Report Approved'   ");
        sb.Append("WHEN plo.Result_Flag='1' AND  plo.IsSampleCollected<>'R'  THEN 'Test Result Done'   ");
        sb.Append("WHEN plo.IsSampleCollected='N' THEN 'Sample Not Collected'   ");
        sb.Append("WHEN plo.IsSampleCollected='S' THEN 'Sample Collected'   ");
        sb.Append("WHEN plo.IsSampleCollected='Y' THEN 'Sample Received'  ");
        sb.Append("ELSE sl.Status END SampleStatus,CONCAT((DATE_FORMAT(plo.Date,'%d-%b-%y')),' ',(DATE_FORMAT(plo.Time,'%h:%m:%s %p'))) PrescribeDate, ");
        sb.Append("IF(plo.SampleCollectionDate <> '01-01-0001 00:00:00',DATE_FORMAT(plo.SampleCollectionDate,'%d-%b-%y %h:%m:%s %p'),'')SampleCollectionDate, ");
        sb.Append("IFNULL(plo.SampleCollector,'')SampleCollector, ");
        sb.Append("IF(plo.SampleReceiveDate <> '01-01-0001 00:00:00',DATE_FORMAT(plo.SampleReceiveDate,'%d-%b-%y %h:%m:%s %p'),'')SampleReceiveDate, ");
        sb.Append("IFNULL(plo.SampleReceiver,'')SampleReceiver, ");
        sb.Append("IF(plo.ResultEnteredDate <> '01-01-0001 00:00:00',DATE_FORMAT(plo.ResultEnteredDate,'%d-%b-%y %h:%m:%s %p'),'')ResultEnteredDate, ");
        sb.Append("IFNULL(plo.ResultEnteredName,'')ResultEnteredName, ");
        sb.Append("IF(plo.ApprovedDate <> '01-01-0001 00:00:00',DATE_FORMAT(plo.ApprovedDate,'%d-%b-%y %h:%m:%s %p'),'')ApprovedDate, ");
        sb.Append("IFNULL(plo.ApprovedName,'') ApprovedName,cm.CentreName 'Performing Center',cm1.CentreName 'Booking Center', ");
        sb.Append("IF(sl.EntryBy IS NULL,'',(SELECT em.Name FROM employee_master em WHERE em.EmployeeID=sl.EntryBy)) 'Transfer By', ");
        sb.Append("IFNULL(DATE_FORMAT(IFNULL(sl.EntryDate,''),'%d-%b-%y %h:%m:%s %p'),'') 'Transfered Date', ");
        sb.Append("IF(sl.DispatchBy IS NULL,'',(SELECT em.Name FROM employee_master em WHERE em.EmployeeID=sl.DispatchBy)) 'Dispatch By', ");
        sb.Append("IFNULL(DATE_FORMAT(IFNULL(sl.DispatchDate,''),'%d-%b-%y %h:%m:%s %p'),'') 'Dispatch Date', ");
        sb.Append("IF(sl.LogisticReceiveBy IS NULL,'',(SELECT em.Name FROM employee_master em WHERE em.EmployeeID=sl.LogisticReceiveBy)) 'Logistic Receice By', ");
        sb.Append("IFNULL(DATE_FORMAT(IFNULL(sl.LogisticReceiveDate,''),'%d-%b-%y %h:%m:%s %p'),'') 'Logistic Receive Date' ");
        sb.Append("FROM patient_labinvestigation_opd plo  ");
        sb.Append("INNER JOIN f_ledgertransaction lt ON lt.LedgertransactionNo=plo.LedgerTransactionNo ");
        sb.Append("INNER JOIN patient_master pm ON pm.PatientID=lt.PatientID ");
        sb.Append("INNER JOIN investigation_master im ON im.Investigation_Id=plo.Investigation_ID ");
        sb.Append("INNER JOIN investigation_observationtype io ON io.Investigation_ID=plo.Investigation_ID ");
		sb.Append("INNER JOIN patient_medical_history pmh ON pmh.TransactionID=plo.TransactionID ");
        sb.Append("INNER JOIN observationtype_master ot ON ot.ObservationType_ID=io.ObservationType_Id ");
        sb.Append("INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = ot.ObservationType_ID and cr.RoleID='" + HttpContext.Current.Session["RoleID"].ToString() + "' ");
        sb.Append("INNER JOIN center_master cm ON cm.CentreID=plo.sampleTransferCentreID ");
        sb.Append("INNER JOIN center_master cm1 ON cm1.CentreID=plo.CentreID ");
        sb.Append("LEFT JOIN sample_logistic sl ON sl.Test_ID=plo.Test_ID AND sl.isActive=1  ");
		
		
		
        sb.Append(" Where  plo.Date >= '" + Util.GetDateTime(txtfromDate.Text).ToString("yyyy-MM-dd") + "' ");

        sb.Append(" and plo.Date <= '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ");

        if (!String.IsNullOrEmpty(txtBarcodeNo.Text.Trim()))
            sb.Append("and plo.BarcodeNo='" + txtBarcodeNo.Text.Trim() + "' ");
		
		
        if (!String.IsNullOrEmpty(txtUHIDNo.Text.Trim()))
            sb.Append("AND pm.PatientID='" + Util.GetFullPatientID(txtUHIDNo.Text.Trim()) + "' ");
        if (!String.IsNullOrEmpty(Centre))
            sb.Append("AND plo.CentreID IN (" + Centre + ") ");
       // if (rdbitem.SelectedValue != "-1")
        //    sb.Append("AND plo.Type='" + rdbitem.SelectedValue + "' ");
	
	 if (rdbitem.SelectedValue == "1")
            sb.Append("AND pmh.type='OPD' ");

        if (rdbitem.SelectedValue == "2")
            sb.Append("AND pmh.type='IPD' ");


        if (rdbitem.SelectedValue == "3")
            sb.Append("AND pmh.type='EMG' ");
	
	
        sb.Append("GROUP BY plo.Test_ID ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            Session["dtExport2Excel"] = dt;
            Session["ReportName"] = "Sample Status Report";
            Session["Period"] = "Period From : " + Util.GetDateTime(txtfromDate.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy") + " ";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../../Design/common/CreateExcel.aspx');", true);
        }

    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        BindReport();
    }
}