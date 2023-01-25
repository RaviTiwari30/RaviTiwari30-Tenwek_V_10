using System;
using System.Web.UI;
using System.Data;
using System.Text;

public partial class Design_IPD_IPDConsultationVisitReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            BindDoctor();
            BindPanel();
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnSearch);
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }
    private void BindDoctor()
    {
        DataTable dtDoctor = StockReports.GetDataTable("SELECT dm.DoctorID,UPPER(CONCAT(dm.Title,'',dm.Name))Name FROM doctor_master dm   ORDER BY dm.Name");
        if (dtDoctor.Rows.Count > 0)
        {
            chkDoctors.DataSource = dtDoctor;
            chkDoctors.DataTextField = "Name";
            chkDoctors.DataValueField = "DoctorID";
            chkDoctors.DataBind();
            lblMsg.Text = "";
        }
        else
        {
            chkDoctors.Items.Clear();
            lblMsg.Text = "No Doctor Found";
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
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        //string Doctors = StockReports.GetSelection(chkDoctors);
        //string Panels = StockReports.GetSelection(chlPanel);
        StringBuilder sb = new StringBuilder();
        //sb.Append("SELECT REPLACE(adj.TransactionID,'ISHHI','')IPDNo,adj.PatientID,CONCAT(pm.Title,'',pm.PName)PatientName,CONCAT(adj.CurrentAge,'/',pm.Gender)Age, ");
        //sb.Append("''Diagnosis,ROUND(SUM(ltd.Rate*ltd.Quantity),2)GrossAmount,ROUND(SUM(((ltd.Rate*ltd.Quantity)*ltd.DiscountPercentage)/100),2) AS DisAmt, ROUND(SUM(ltd.Amount),2)NetAmount, ");
        //sb.Append("(SELECT CONCAT(dm.Title,'',dm.Name) FROM doctor_master WHERE DoctorID=adj.DoctorID)AdmitingDoctor,pnl.Company_Name,ltd.DoctorID, ");
        //sb.Append("CONCAT(dm.Title,'',dm.Name)VisitDoctor,DATE_FORMAT(adj.BillDate,'%d-%b-%y')BillDate ");
        //sb.Append("FROM f_ledgertnxdetail ltd INNER JOIN f_ipdadjustment adj ON adj.TransactionID=ltd.TransactionID  ");
        //sb.Append("INNER JOIN doctor_master dm ON dm.DoctorID=ltd.DoctorID ");
        //sb.Append("INNER JOIN patient_master pm ON pm.PatientID=adj.PatientID  ");
        //sb.Append("INNER JOIN f_panel_master pnl ON pnl.PanelID=adj.panelID ");
        //sb.Append("WHERE ltd.isVerified=1 ");
        //if (Doctors !="")
        //sb.Append("AND ltd.DoctorID IN (" + Doctors + ") ");
        //if (Panels != "")
        //    sb.Append(" And adj.PanelID IN (" + Panels + ") ");
        //sb.Append(" And  ltd.ConfigID='1' AND  (adj.BillNo IS NOT NULL) AND adj.billNo <> '' AND adj.CentreID IN (" + Centre + ") ");
        //sb.Append(" AND Date(adj.BillDate)>='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' AND Date(adj.BillDate)<='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "' ");
        //sb.Append(" GROUP BY adj.TransactionID,ltd.DoctorID ORDER BY adj.BillDate ");
        //DataTable dt = StockReports.GetDataTable(sb.ToString());
        //if (dt.Rows.Count > 0)
        //{
        //    DataColumn dc = new DataColumn();
        //    dc.ColumnName = "User";
        //    dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
        //    dt.Columns.Add(dc);

        //    dc = new DataColumn();
        //    dc.ColumnName = "Period";
        //    dc.DefaultValue = "Period From : " + txtFromDate.Text.Trim() + " To : " + txtToDate.Text.Trim();
        //    dt.Columns.Add(dc);

        //    DataSet ds = new DataSet();
        //    ds.Tables.Add(dt.Copy());
        //    //ds.WriteXmlSchema(@"E:\InvestigationAnalysis1.xml");
        //    Session["ds"] = ds;
        //    Session["ReportName"] = "IPDConsultationVisitReport";
        //    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
        //}
        //else
        //    lblMsg.Text = "No Record Found";


        sb.Append("SELECT t.* FROM  ( ");
        sb.Append("SELECT cm.CentreName, pm.PatientID,REPLACE(pmh.TransactionID,'ISHHI','')IPDNo,Concat(pm.Title,'',pm.PName)PatientName,DATE_FORMAT(pmh.DateOfAdmit,'%d-%b-%y')AdmissionDate, ");
        sb.Append("IF(IFNULL(pmh.DoctorID1,'')='',CONCAT(dm.title,'',dm.Name),(SELECT REPLACE(GROUP_CONCAT(CONCAT(doctorname,'')),',','/') FROM f_multipledoctor_ipd WHERE transactionID= pmh.TransactionID AND STATUS='IN'))AdmitingDoctor ");
        sb.Append(",DM.Name AS DoctorVisited,sc.Name AS IPDVisitName ,DATE_FORMAT(LTD.EntryDate,'%d-%b-%y')VisitDate,ltd.NetItemAmt as Amount,IF(ltd.IsPackage=1,'Yes','NO')IsPackageVisit ");
        sb.Append("FROM  patient_medical_history pmh ");//f_ipdadjustment adj
       // sb.Append("INNER JOIN ipd_case_history ich ON ich.TransactionID=adj.TransactionID  ");
       // sb.Append("INNER JOIN patient_medical_history pmh ON pmh.TransactionID=adj.TransactionID ");
        sb.Append("INNER JOIN f_multipledoctor_ipd mdi ON mdi.TransactionID=pmh.TransactionID ");
        sb.Append("INNER JOIN Patient_master pm ON pm.PatientID=pmh.PatientID ");
        sb.Append("INNER JOIN doctor_master dm ON dm.DoctorID=mdi.DoctorID ");
        sb.Append("INNER JOIN f_Panel_master pnl ON pnl.PanelID=pmh.PanelID ");
        sb.Append("INNER JOIN center_master cm ON cm.CentreID=pmh.CentreID ");
        sb.Append("LEFT JOIN f_ledgertnxdetail ltd ON ltd.TransactionID=pmh.TransactionID AND LTD.ConfigID=1 AND MDI.DoctorID=ltd.DoctorID  ");
        sb.Append("LEFT JOIN f_subcategorymaster sc ON sc.SubCategoryID=ltd.SubCategoryID ");
        sb.Append("WHERE pmh.Status='IN' AND cm.centreID in (" + Centre + ") AND ltd.DoctorID IS NOT NULL ");
        sb.Append("UNION ALL ");
        sb.Append("SELECT cm.CentreName, pm.PatientID,REPLACE(pmh.TransactionID,'ISHHI','')IPDNo,Concat(pm.Title,'',pm.PName)PatientName,DATE_FORMAT(pmh.DateOfAdmit,'%d-%b-%y')AdmissionDate ");
        sb.Append(",IF(IFNULL(pmh.DoctorID1,'')='',CONCAT(dm.title,'',dm.Name),(SELECT REPLACE(GROUP_CONCAT(CONCAT(doctorname,'')),',','/') FROM f_multipledoctor_ipd WHERE transactionID= pmh.TransactionID AND STATUS='IN'))AdmitingDoctor ");
        sb.Append(",ltd.ItemName AS DoctorVisited,sc.Name AS IPDVisitName ,DATE_FORMAT(LTD.EntryDate,'%d-%b-%y')VisitDate,ltd.NetItemAmt as Amount,IF(ltd.IsPackage=1,'Yes','NO')IsPackageVisit ");
        sb.Append("FROM patient_medical_history pmh  ");//f_ipdadjustment adj
       // sb.Append("INNER JOIN ipd_case_history ich ON ich.TransactionID=adj.TransactionID ");
      //  sb.Append("INNER JOIN patient_medical_history pmh ON pmh.TransactionID=adj.TransactionID ");
        sb.Append("INNER JOIN Patient_master pm ON pm.PatientID=pmh.PatientID ");
        sb.Append("INNER JOIN doctor_master dm ON dm.DoctorID=pmh.DoctorID ");
        sb.Append("INNER JOIN f_Panel_master pnl ON pnl.PanelID=pmh.PanelID ");
        sb.Append("INNER JOIN center_master cm ON cm.CentreID=pmh.CentreID ");
        sb.Append("LEFT JOIN f_ledgertnxdetail ltd ON ltd.TransactionID=pmh.TransactionID AND LTD.ConfigID=1 AND pmh.DoctorID<>ltd.DoctorID  ");
        sb.Append("LEFT JOIN f_subcategorymaster sc ON sc.SubCategoryID=ltd.SubCategoryID ");
        sb.Append("WHERE pmh.Status='IN' AND cm.centreID in (" + Centre + ") ");
        sb.Append(")t ORDER BY t.IPDNo,VisitDate ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            Session["dtExport2Excel"] = dt;
            Session["ReportName"] = "IPD Consultation Report (Currently Admitted Patient)";
            Session["Period"] = "As On Date " + System.DateTime.Now;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
        }
    }
}