using System;
using System.Data;
using System.Web.UI;
using System.Text;


public partial class Design_IPD_BillNotFinalisedList : System.Web.UI.Page
{
    public override void VerifyRenderingInServerForm(Control control)
    {
        return;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            grdPatient.DataSource = GetBillNotFinalised();
            grdPatient.DataBind();

            if (grdPatient.Rows.Count > 0)
            {
                btnExport.Visible = true;                
            }
            else
            {
                btnExport.Visible = false;
            }

        }
        lblMsg.Text = "";
    }

    private DataTable GetBillNotFinalised()
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT ip.PatientID MRNo,TransNo IPDNo, ");
        sb.Append(" rm.Bed_No AS BedNo,rm.Floor,ctm.Name AS RoomType,AdmitDateTime,DischargeDateTime,DischargedBy DischargBy,ConsultantName as DoctorName,PatientName,  ");
        sb.Append(" Age,Gender as Sex,ContactNo,panel,Source,Dept,DischargeStatus,Diagnosis,Remarks,BillAmt,Deposit,(BillAmt-(Deposit+TDS+Deduction+Writeoff+RoundOff+DiscountOnBill))Balance,t.Status FROM ( ");
	    sb.Append("     SELECT PMH.TransactionID,PMH.TransNo,MAX(ip.PatientIPDProfile_ID)PatientIPDProfile_ID, ");
	    sb.Append("     CONCAT(dm.Title,' ',dm.Name)ConsultantName, CONCAT(pm.Title,' ',pm.PName)PatientName,pm.Age,pm.Gender,pm.Mobile ContactNo, ");
        sb.Append("     pnl.Company_Name as panel,PMH.Source, (SELECT DISTINCT(Department) FROM doctor_hospital WHERE DoctorID = PMH.DoctorID)AS Dept,'' AS DischargeStatus, "); 
	    sb.Append("     (SELECT Diagnosis FROM diagnosis_master WHERE ID=pmh.DiagnosisID)Diagnosis,pmh.Remarks, ");
        sb.Append("     IFNULL(pmh.Deduction_Acceptable,'0')Deduction,IFNULL(pmh.TDS,'0')TDS,IFNULL(pmh.WriteOff,'0')Writeoff,IFNULL(PMH.RoundOff,0)RoundOff,IFNULL(PMH.DiscountOnBill,0)DiscountOnBill,       ");    
	    sb.Append("     ROUND((SELECT SUM(ltd.Amount)  FROM f_ledgertnxdetail ltd WHERE  TransactionID = pmh.TransactionID AND IsPackage = 0 AND IsVerified = 1)) ");
	    sb.Append("     AS BillAmt, ROUND((SELECT IFNULL(SUM(AmountPaid),0) FROM f_reciept WHERE TransactionID = pmh.TransactionID AND IsCancel = 0))AS Deposit, ");  
	    sb.Append("     PMH.BillNo,(SELECT DATE_FORMAT(BillDate,'%d-%b-%Y') FROM f_ledgertransaction WHERE TransactionID=pmh.TransactionID LIMIT 1)BillDate, ");
        sb.Append("     (case when IFNULL(PMH.BillNo,'')<>'' then 'Bill Pending Approval' else case when IFNULL(PMH.BillNo,'')='' then 'Bill Not Generated' else 'Both' end end )Status, ");
        sb.Append("     (Select Name from employee_master where EmployeeID=PMH.DischargedBy)DischargedBy, ");
        sb.Append("     CONCAT(Date_Format(PMH.DateOfAdmit,'%d-%b-%Y'),' ',Date_Format(PMH.TimeOfAdmit,'%h:%i %p'))AdmitDateTime, ");
        sb.Append("     if(PMH.DateOfDischarge='0001-01-01','-',CONCAT(Date_Format(PMH.DateOfDischarge,'%d-%b-%Y'),' ',Date_Format(PMH.TimeofDischarge,'%h:%i %p')))DischargeDateTime ");
        sb.Append("     FROM patient_ipd_profile ip INNER JOIN patient_medical_history PMH ON IP.TransactionID = PMH.TransactionID ");
        sb.Append("     INNER JOIN doctor_master dm ON dm.DoctorID = PMH.DoctorID INNER JOIN patient_master pm ON pm.PatientID = PMH.PatientID "); 
	    sb.Append("     INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID   "); 
	    sb.Append("     WHERE PMH.Status = 'OUT' and PMH.Type='IPD'  AND PMH.IsBilledClosed=0  ");

        if(rbtFilter.SelectedItem.Value=="0")
            sb.Append("     and (IFNULL(PMH.BillNo,'')<>'') ");
        else if (rbtFilter.SelectedItem.Value == "1")
            sb.Append("     and (IFNULL(PMH.BillNo,'')='') ");
                
        sb.Append("     GROUP BY PMH.TransactionID ");
        sb.Append(" )t INNER JOIN patient_ipd_profile ip ON  ip.PatientIPDProfile_ID = t.PatientIPDProfile_ID ");
        sb.Append(" INNER JOIN room_master rm ON rm.RoomId = ip.RoomID INNER JOIN ipd_case_type_master ctm ON ctm.IPDCaseTypeID = rm.IPDCaseTypeID ");
        sb.Append(" ORDER BY IPDNo,AdmitDateTime ");

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());
        ViewState["dt"] = dt;
        return dt;
    }


    protected void rbtFilter_SelectedIndexChanged(object sender, EventArgs e)
    {
        grdPatient.DataSource = GetBillNotFinalised();
        grdPatient.DataBind();

        if (grdPatient.Rows.Count > 0)
        {
            btnExport.Visible = true;            
        }
        else
        {
            btnExport.Visible = false;            
        }
    }

    protected void btnExport_Click(object sender, EventArgs e)
    {
        if (grdPatient.Rows.Count > 0)
        {
            Session["dtExport2Excel"] = ((DataTable)ViewState["dt"]);
            if(rbtFilter.SelectedItem.Value != "2")
            {
                Session["ReportName"] = rbtFilter.SelectedItem.Text;
            }
            else
            {
                Session["ReportName"] = "Patient Discharged But Bills Either Not Generated OR Not Finalised";
            }

            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);

        }
    
    }
    
}
