using System;
using System.Data;
using System.Text;
using System.Web.UI;

public partial class Design_IPD_IPDOutStandingReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnReport);
            BindPanel();
        }
        ucFromDate.Attributes.Add("readOnly", "true");
    }

    protected void btnReport_Click(object sender, EventArgs e)
    {
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        string Panels = StockReports.GetSelection(chlPanel);
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT CentreID,CentreName,MRNo AS PatientID,TransactionID,STATUS,DateOfAdmit,TimeOfAdmit,DateOfDischarge,TimeOfDischarge,BillDate,DispatchDate,BedNo,Room_No,Days,FLOOR,BedCategory,ConsultantName, ");
        sb.Append("   PatientName,Age,Gender,Phone,Mobile,Company_Name,Source,Dept,DischargeStatus,Diagnosis,Remarks,   Round(BillAmt-(DiscountOnBill+ItemDiscAmt)) AS BillAmt,Deposit, ");
        sb.Append("  IF(BillAmt-(Deposit+DiscountOnBill+ItemDiscAmt)>0,(BillAmt-(Deposit+DiscountOnBill+ItemDiscAmt)) + (1000-RIGHT((BillAmt-(Deposit+DiscountOnBill+ItemDiscAmt)),3)),0)Balance,    DoctorID,Approval,ActivityPlanned,TreatmentRemarks, ");
        sb.Append("  Round((BillAmt-(Deposit+DiscountOnBill+ItemDiscAmt-Roundoff)))BanlaneAmt,ClaimNo FROM ( SELECT ip.PatientID MRNo,REPLACE(ip.TransactionID,'ISHHI','')TransactionID, ip.Status, ");
        sb.Append("  DATE_FORMAT(pmh.DateOfAdmit,'%d-%b-%Y')DateOfAdmit,pmh.TimeOfAdmit,DATE_FORMAT(pmh.DateOfDischarge,'%d-%b-%Y')DateOfDischarge, pmh.TimeOfDischarge,rm.Bed_No AS BedNo,DATE_FORMAT(pmh.BillDate,'%d-%b-%Y')BillDate,DATE_FORMAT(dis.DispatchDate,'%d-%b-%Y')DispatchDate, ");
        if (rdbType.SelectedValue == "0")
            sb.Append("  DATEDIFF(NOW(),pmh.BillDate)AS Days, ");
        if (rdbType.SelectedValue == "1" || rdbType.SelectedValue == "2")
            sb.Append("  DATEDIFF(NOW(),pmh.DateOfAdmit)AS Days, ");
        sb.Append("  rm.Room_No,rm.Floor,ctm.Name AS BedCategory,CONCAT(dm.Title,' ',dm.Name)ConsultantName, CONCAT(pm.Title,' ',pm.PName)PatientName, ");
        sb.Append("  pm.Age,pm.Gender,pm.Phone,pm.Mobile,pnl.Company_Name,PMH.Source,pmh.DoctorID,cm.`CentreID`,cm.`CentreName`, (SELECT DISTINCT(Department) ");
        sb.Append("  FROM doctor_hospital WHERE DoctorID = pmh.doctorid)AS Dept,'' AS DischargeStatus, ");
        sb.Append("  (SELECT Diagnosis FROM diagnosis_master WHERE ID=pmh.DiagnosisID)Diagnosis,pmh.Remarks,pmh.Roundoff, ");
        sb.Append("  ROUND((SELECT Round(SUM(((ltd.Rate*ltd.Quantity)*DiscountPercentage)/100),2)  FROM f_ledgertnxdetail ltd ");
        sb.Append("  WHERE  TransactionID = ip.TransactionID AND IsPackage = 0 AND IsVerified = 1)) AS ItemDiscAmt , ");
        if (rdbType.SelectedValue == "0")
        {
            sb.Append("  (pmh.TotalBilledAmt+pmh.Roundoff) AS BillAmt, ");
        }
        if (rdbType.SelectedValue == "1" || rdbType.SelectedValue == "2")
        {
            sb.Append(" ROUND((SELECT ROUND((SUM(ltda.Rate*ltda.Quantity))-((SUM(((ltda.Rate*ltda.Quantity)*ltda.DiscountPercentage)/100))+IFNULL(pmh.DiscountOnBill,0)),2)  FROM f_ledgertnxdetail  ");
            sb.Append(" ltda WHERE  ltda.TransactionID = ip.TransactionID AND ltda.IsPackage = 0 AND ltda.IsVerified = 1))AS BillAmt,  ");
        }
        sb.Append("  ROUND((SELECT IFNULL(SUM(IFNULL(AmountPaid ,0)+IFNULL(TDS,0)+IFNULL(Writeoff,0)+IFNULL(Deductions ,0)),0) FROM f_reciept  ");
        sb.Append("  WHERE TransactionID = ip.TransactionID AND IsCancel = 0))AS Deposit,  ");
        sb.Append("  ROUND((SELECT IFNULL(SUM(PanelApprovedAmt),0) FROM patient_medical_history  WHERE TransactionID = ip.TransactionID ))AS Approval  , ");
        sb.Append("  pmh.ActivityPlanned,pmh.TreatmentRemarks,Round(IFNULL(pmh.DiscountOnBill,0),2)DiscountOnBill,pmh.ClaimNo   FROM patient_ipd_profile ip  ");
        sb.Append("  INNER JOIN patient_medical_history PMH ON IP.TransactionID = PMH.TransactionID INNER JOIN center_master cm ON cm.`CentreID`=pmh.`CentreID` ");
        sb.Append("  INNER JOIN room_master rm ON rm.RoomId = ip.RoomID ");
        sb.Append("  INNER JOIN ipd_case_type_master ctm ON ctm.IPDCaseTypeID = rm.IPDCaseTypeID  ");
        sb.Append("  INNER JOIN doctor_master dm ON dm.DoctorID = pmh.doctorid ");
        sb.Append("  INNER JOIN patient_master pm ON pm.PatientID = ip.PatientID ");
        sb.Append("  INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID ");
        sb.Append("  LEFT JOIN f_dispatch dis ON dis.TransactionID=pmh.TransactionID And dis.IsCancel=0 ");
        sb.Append("  WHERE  pmh.`CentreID` in (" + Centre + ") ");
        if(rdbType.SelectedValue == "0")
            sb.Append(" AND Date(pmh.BillDate) <='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' AND pmh.Status ='OUT' ");
        if(rdbType.SelectedValue == "1")
            sb.Append(" AND Date(pmh.DateofAdmit) <='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' AND pmh.Status IN ('IN','OUT') ");
        if(rdbType.SelectedValue == "2")
            sb.Append(" AND pmh.Status = 'IN' ");
        if (txtDays.Text.Trim() != "")
        {
            if (rdbType.SelectedValue == "0")
                sb.Append(" AND DATEDIFF(NOW(),pmh.BillDate) >='"+ txtDays.Text.Trim() +"' ");
            if (rdbType.SelectedValue == "1" || rdbType.SelectedValue == "2")
                sb.Append(" AND DATEDIFF(NOW(),pmh.DateOfAdmit) >='" + txtDays.Text.Trim() + "' ");
        }
        if (Panels != string.Empty)
            sb.Append(" AND pmh.PanelID IN (" + Panels + ") ");
        sb.Append(" group by pmh.TransactionID ORDER BY BedCategory,BedNo  )t HAVING BanlaneAmt>0 ORDER BY Days DESC  ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = Convert.ToString(Session["LoginName"]);
            DataColumn dc1 = new DataColumn();
            dc1.ColumnName = "Period";
            dc1.DefaultValue = Util.GetDateTime(ucFromDate.Text).ToString("dd-MM-yyyy");
            dt.Columns.Add(dc);
            dt.Columns.Add(dc1);
            DataTable dtImg = All_LoadData.CrystalReportLogo();
            lblMsg.Text = dt.Rows.Count + " " + "Record Found";
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            ds.Tables.Add(dtImg.Copy());
            Session["ReportName"] = "IPDOutStanding";
            Session["ds"] = ds;
           // ds.WriteXmlSchema(@"E:\IPDOutStanding.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
        }
        else
        {
            lblMsg.Text = "Record Not Found";
        }
    }
    private void BindPanel()
    {
        DataTable dtPanel = All_LoadData.LoadPanelOPD();
        if (dtPanel.Rows.Count > 0)
        {
            chlPanel.DataSource = dtPanel;
            chlPanel.DataTextField = "Company_Name";
            chlPanel.DataValueField = "PanelID";
            chlPanel.DataBind();
            lblMsg.Text = "";
        }
        else
        {
            chlPanel.Items.Clear();
            lblMsg.Text = "No Panel Found";
        }

    }
}