using System;
using System.Data;
using System.Web.UI;
using System.Text;

public partial class Design_IPD_SurgeryAnalysisReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            BindSubGroups();
            BindDoctor();
            BindPanel();
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnSearch);
            chkSubGroups_CheckedChanged(sender, e);
            chkItems.Visible = false;
        }
    }
    private void BindDoctor()
    {
        DataTable dtDoctor = All_LoadData.bindDoctor();
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
    private void BindSubGroups()
    {
        string str = "select distinct Department from f_Surgery_Master  order by name ";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            chlSubGroups.DataSource = dt;
            chlSubGroups.DataTextField = "Department";
            chlSubGroups.DataValueField = "Department";
            chlSubGroups.DataBind();            
            lblMsg.Text = "";
        }
        else
        {
            chlSubGroups.Items.Clear();
            lblMsg.Text = "No Sub-Groups Found";
        }   
    }
    private void BindItems()
    {
        string Items = StockReports.GetSelection(chlSubGroups);
        if (Items != string.Empty)
        {
            string str = "select CONCAT(sm.Name,'(',gm.GroupName,')')name,Surgery_ID FROM f_surgery_master sm INNER JOIN f_surgery_groupmaster gm ON gm.GroupID=sm.GroupID where trim(Department) in (" + Items + ") order by sm.Name ";

            DataTable dt = new DataTable();
            dt = StockReports.GetDataTable(str);

            if (dt.Rows.Count > 0)
            {
                chkItems.Visible = true;                
                chlItems.DataSource = dt;
                chlItems.DataTextField = "name";
                chlItems.DataValueField = "Surgery_ID";
                chlItems.DataBind();
                lblMsg.Text = "";
            }
            else
            {
                chkItems.Visible = false;
                chlItems.Items.Clear();
                lblMsg.Text = "No Surgery Found";
            }
        }
        else
        {
            chkItems.Visible = false;
            chlItems.Items.Clear();
            lblMsg.Text = "Select Department";
        }
    }
    protected void chkSubGroups_CheckedChanged(object sender, EventArgs e)
    {
        for (int i = 0; i < chlSubGroups.Items.Count; i++)
            chlSubGroups.Items[i].Selected = chkSubGroups.Checked;
    }
    protected void btnItems_Click(object sender, EventArgs e)
    {
        BindItems();
        chkItems_CheckedChanged(sender, e);
    }
    protected void chkItems_CheckedChanged(object sender, EventArgs e)
    {
        for (int i = 0; i < chlItems.Items.Count; i++)
            chlItems.Items[i].Selected = chkItems.Checked;
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }

        string Items = StockReports.GetSelection(chlItems);
        string Department = StockReports.GetSelection(chlSubGroups);
        string doctors = StockReports.GetSelection(chkDoctors);
        string Panels = StockReports.GetSelection(chlPanel);
        lblMsg.Text = "";

        if (Items != string.Empty)
        {
            if (rdoReportType.Text == "1")
            {
                StringBuilder sb = new StringBuilder();
                if (chkIsBillDate.Checked == false)
                {
                    sb.Append("SELECT cmt.`CentreID`,cmt.`CentreName`,t.DoctorID,(SELECT CONCAT(title,' ',NAME) FROM doctor_master WHERE DoctorID=t.DoctorID)DoctorName,t.ItemName,REPLACE(sm.Surgery_ID,'LSHHI','')Surgery_ID,sm.Department,sm.Name SurgeryName,");
                    sb.Append("ROUND(SUM(GrossAmt))GrossAmt,1 Quantity,ROUND(SUM(Disc))Disc,");
                    sb.Append("ROUND(SUM(Amount))Amount,DATE_FORMAT(t.EntryDate,'%d-%b-%Y')EntryDate,");
                    sb.Append("t.PatientID PatientID,REPLACE(t.TransactionID,'ISHHI','')TransactionID,");
                    sb.Append("t.BillNo,DATE_FORMAT(t.BillDate,'%d-%b-%y')BillDate,");
                    sb.Append("IF(t.IsPackage=1,'Yes','No')isPackage,Pm.PName,pm.Mobile,");
                    sb.Append("(SELECT Company_Name FROM f_panel_master WHERE PanelID=(SELECT ");
                    sb.Append("PanelID FROM patient_medical_history WHERE TransactionID=t.TransactionID ");
                    sb.Append("LIMIT 1)LIMIT 1)Company_Name, ");
                    sb.Append("(SELECT Concat(Title,'',NAME) FROM doctor_master WHERE DoctorID=(SELECT ");
                    sb.Append("DoctorID FROM patient_medical_history WHERE TransactionID=t.TransactionID ");
                    sb.Append("LIMIT 1)LIMIT 1)AdmitingDoctor ");
                    sb.Append(" FROM (");
                    sb.Append("     SELECT lt.CentreID,ltd.ItemName,ltd.LedgertnxID,ltd.DoctorID, ltd.SurgeryName,(ltd.Rate*ltd.Quantity)GrossAmt,ltd.Amount,");
                    sb.Append("     IF(ltd.discountpercentage >0,((ltd.Rate*ltd.Quantity)-ltd.Amount),0)Disc,ltd.EntryDate,");
                    sb.Append("     ltd.LedgerTransactionNo,ltd.SurgeryID,lt.PatientID,lt.TransactionID,");
                    sb.Append("     lt.BillNo,lt.BillDate,ltd.IsPackage ");
                    sb.Append("     FROM f_ledgertnxdetail ltd INNER JOIN patient_medical_history lt ON lt.TransactionID = ltd.TransactionID ");
                    sb.Append("     WHERE ISSurgery=1 AND IsVerified=1  ");
                    sb.Append("	    AND ltd.EntryDate >= '" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + " 00:00:00' ");
                    sb.Append("		AND ltd.EntryDate <= '" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + " 00:00:00' ");
                    sb.Append(")T INNER JOIN f_surgery_master sm ON t.SurgerysID = sm.Surgery_ID ");
                    sb.Append("INNER JOIN patient_master pm ON pm.PatientID = t.PatientID INNER JOIN center_master cmt ON cmt.`CentreID`=t.`CentreID`");
                    sb.Append(" INNER JOIN patient_medical_history adj ON adj.TransactionID=t.TransactionID ");
                    if (Items != "")
                        sb.Append("     Where sm.Surgery_ID IN (" + Items + ") ");
                    if(doctors!="")
                        sb.Append(" and t.DoctorID in (" + doctors + ") ");
                    if(Panels !="")
                        sb.Append(" and adj.Panelid in (" + Panels + ") ");
                    sb.Append(" GROUP BY t.LedgerTnxID  ");
                    sb.Append("ORDER BY sm.Name,sm.Department ");
                }
                else
                {
                    sb.Append("SELECT cmt.`CentreID`,cmt.`CentreName`,t.DoctorID,(SELECT CONCAT(title,' ',NAME) FROM doctor_master WHERE DoctorID=t.DoctorID)DoctorName,t.ItemName,REPLACE(sm.Surgery_ID,'LSHHI','')Surgery_ID,sm.Department,sm.Name SurgeryName,");
                    sb.Append("ROUND(SUM(GrossAmt))GrossAmt,1 Quantity,ROUND(SUM(Disc))Disc,");
                    sb.Append("ROUND(SUM(Amount))Amount,DATE_FORMAT(EntryDate,'%d-%b-%Y')EntryDate,");
                    sb.Append("t.PatientID PatientID,REPLACE(t.TransactionID,'ISHHI','')TransactionID,");
                    sb.Append("t.BillNo,DATE_FORMAT(t.BillDate,'%d-%b-%y')BillDate,");
                    sb.Append("IF(t.IsPackage=1,'Yes','No')isPackage,Pm.PName,pm.Mobile,");
                    sb.Append("(SELECT Company_Name FROM f_panel_master WHERE PanelID=t.PanelID LIMIT 1)Company_Name, ");
                    sb.Append("(SELECT Concat(Title,'',NAME) FROM doctor_master WHERE DoctorID=AdmitDoctorID LIMIT 1)AdmitingDoctor ");
                    sb.Append(" FROM (");
                    sb.Append("     SELECT  adj.CentreID,ltd.ItemName,ltd.DoctorID,ltd.SurgeryName,(ltd.Rate*ltd.Quantity)GrossAmt,ltd.Amount,");
                    sb.Append("     IF(ltd.discountpercentage >0,((ltd.Rate*ltd.Quantity)-ltd.Amount),0)Disc,ltd.EntryDate,");
                    sb.Append("     ltd.LedgerTransactionNo,ltd.SurgeryID,adj.PatientID,adj.TransactionID,ltd.LedgertnxID,");
                    sb.Append("     adj.BillNo,adj.BillDate,ltd.IsPackage,adj.PanelID,adj.DoctorID AdmitDoctorID ");
                    sb.Append("     FROM f_ledgertnxdetail ltd INNER JOIN ");
                    sb.Append("     INNER JOIN Patient_Medical_History adj ON adj.TransactionID=ltd.TransactionID ");
                    sb.Append("     WHERE ISSurgery=1 AND IsVerified=1 AND (adj.BillNo IS NOT NULL AND adj.billNo <> '') ");
                    sb.Append("     AND DATE(adj.BillDate) >= '" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' AND DATE(adj.BillDate) <= '" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "' ");
                    sb.Append(")T INNER JOIN f_surgery_master sm ON t.SurgeryID = sm.Surgery_ID ");
                    sb.Append("INNER JOIN patient_master pm ON pm.PatientID = t.PatientID INNER JOIN center_master cmt ON cmt.`CentreID`=t.`CentreID` ");
                    if (Items != "")
                        sb.Append("     Where sm.Surgery_ID IN (" + Items + ") ");
                    if (doctors != "")
                        sb.Append(" and t.DoctorID in (" + doctors + ") ");
                    if(Panels !="")
                        sb.Append(" AND t.PanelID IN (" + Panels + ") ");
                    sb.Append("GROUP BY t.LedgertnxID ");
                    sb.Append("ORDER BY sm.Name,sm.Department ");
                }
                DataTable dt = new DataTable();
                dt = StockReports.GetDataTable(sb.ToString());

                if (dt.Rows.Count > 0)
                {
                    DataColumn dc = new DataColumn();
                    dc.ColumnName = "User";
                    dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
                    dt.Columns.Add(dc);

                    dc = new DataColumn();
                    dc.ColumnName = "Period";
                    dc.DefaultValue = "Period From : " + txtFromDate.Text.Trim() + " To : " + txtToDate.Text.Trim();
                    dt.Columns.Add(dc);

                    DataSet ds = new DataSet();
                    ds.Tables.Add(dt.Copy());

                   // ds.WriteXmlSchema(@"E:\anandSurDetail.xml");
                    Session["ds"] = ds;
                    Session["ReportName"] = "SurgeryAnalysis"; 
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);

                }
                else
                    lblMsg.Text = "No Records Found..";
            }
            else if (rdoReportType.Text == "2")
            {
                StringBuilder sb = new StringBuilder();

                if (chkIsBillDate.Checked == false)
                {
                    sb.Append("SELECT t.CentreID,t.CentreName,t.DoctorID,(SELECT CONCAT(title,' ',NAME) FROM doctor_master WHERE DoctorID=t.DoctorID)DoctorName,t.ItemName, REPLACE(sm.Surgery_ID,'LSHHI','')Surgery_ID,sm.Department,sm.Name SurgeryName,");
                    sb.Append("ROUND(SUM(GrossAmt))GrossAmt,sum(Quantity)Quantity,ROUND(SUM(Disc))Disc,");
                    sb.Append("ROUND(SUM(Amount))Amount ");                    
                    sb.Append("FROM (");
                    sb.Append("     SELECT cmt.`CentreID`,cmt.`CentreName`,ltd.ItemName,ltd.LedgerTnxID,ltd.DoctorID,1 Quantity,ltd.SurgeryName,ROUND(SUM((ltd.Rate*ltd.Quantity)))GrossAmt,ROUND(SUM(ltd.Amount))Amount,");
                    sb.Append("     IF(ltd.discountpercentage >0,ROUND(SUM(((ltd.Rate*ltd.Quantity)-ltd.Amount))),0)Disc,ltd.EntryDate,");
                    sb.Append("     ltd.LedgerTransactionNo,ltd.SurgeryID,lt.PatientID,lt.TransactionID,");
                    sb.Append("     lt.BillNo,lt.BillDate,ltd.IsPackage ");
                    sb.Append("     FROM f_ledgertnxdetail ltd INNER JOIN  patient_medical_history lt ON lt.TransactionID = ltd.TransactionID INNER JOIN center_master cmt ON cmt.`CentreID`=lt.`CentreID`   ");
                     sb.Append("     WHERE ISSurgery=1 AND IsVerified=1  ");
                    sb.Append("		AND ltd.EntryDate >= '" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + " 00:00:00'  ");
                    sb.Append("		AND ltd.EntryDate <= '" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + " 00:00:00'  ");
                    sb.Append("     GROUP BY ltd.LedgerTnxID ");
                    sb.Append(")T INNER JOIN f_surgery_master sm ON t.SurgeryID = sm.Surgery_ID ");
                    
                    if (Items != "")
                        sb.Append("     AND sm.Surgery_ID IN (" + Items + ") ");
                    if(doctors!="")
                        sb.Append(" and T.DoctorID in ("+doctors+") ");

                    sb.Append("GROUP BY t.DoctorID ");
                    sb.Append("ORDER BY sm.Name,sm.Department ");
                }
                else
                {
                    sb.Append("SELECT t.CentreID,t.CentreName,t.DoctorID,(SELECT CONCAT(title,' ',NAME) FROM doctor_master WHERE DoctorID=t.DoctorID)DoctorName,t.ItemName,REPLACE(sm.Surgery_ID,'LSHHI','')Surgery_ID,sm.Department,sm.Name SurgeryName,");
                    sb.Append("ROUND(SUM(GrossAmt))GrossAmt,sum(Quantity)Quantity,ROUND(SUM(Disc))Disc,");
                    sb.Append("ROUND(SUM(Amount))Amount ");
                    sb.Append("FROM (");
                    sb.Append("     SELECT 1 Quantity,cmt.`CentreID`,cmt.`CentreName`,ltd.LedgerTnxID,ltd.SurgeryName,ROUND(SUM((ltd.Rate*ltd.Quantity)))GrossAmt,ROUND(SUM(ltd.Amount))Amount,");
                    sb.Append("     IF(ltd.discountpercentage >0,ROUND(SUM(((ltd.Rate*ltd.Quantity)-ltd.Amount))),0)Disc,ltd.EntryDate,");
                    sb.Append("     ltd.LedgerTransactionNo,ltd.SurgeryID,lt.PatientID,lt.TransactionID,ltd.DoctorID,");
                    sb.Append("     lt.BillNo,lt.BillDate,ltd.IsPackage,ltd.ItemName ");
                    sb.Append("     FROM f_ledgertnxdetail ltd INNER JOIN patient_medical_history lt ON lt.TransactionID = ltd.TransactionID ");
                    sb.Append("     INNER JOIN center_master cmt ON cmt.`CentreID`=lt.`CentreID`");
                    sb.Append("     WHERE ISSurgery=1 AND IsVerified=1 AND (lt.BillNo IS NOT NULL AND lt.billNo <> '')  ");
                    sb.Append("     AND DATE(LT.BillDate) >=  '" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' ");
                    sb.Append("     AND DATE(LT.BillDate) <=  '" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "' ");
                    sb.Append("     GROUP BY ltd.LedgerTnxID ");
                    sb.Append(")T INNER JOIN f_surgery_master sm ON t.SurgeryID = sm.Surgery_ID ");
                    if (Items != "")
                        sb.Append("     AND sm.Surgery_ID IN (" + Items + ") ");
                    if (doctors != "")
                        sb.Append(" and T.DoctorID in (" + doctors + ") ");
                    sb.Append("GROUP BY t.DoctorID ");
                    sb.Append("ORDER BY sm.Name,sm.Department ");                    
                }

                DataTable dt = new DataTable();
                dt = StockReports.GetDataTable(sb.ToString());

                if (dt.Rows.Count > 0)
                {
                    DataColumn dc = new DataColumn();
                    dc.ColumnName = "User";
                    dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
                    dt.Columns.Add(dc);

                    dc = new DataColumn();
                    dc.ColumnName = "Period";
                    dc.DefaultValue = "Period From : " + txtFromDate.Text.Trim() + " To : " + txtToDate.Text.Trim();
                    dt.Columns.Add(dc);

                    DataSet ds = new DataSet();
                    ds.Tables.Add(dt.Copy());

                  //  ds.WriteXmlSchema(@"E:\anandSurSummary.xml");
                    Session["ds"] = ds;
                    Session["ReportName"] = "SurgeryAnalysisSummary";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);

                }
                else
                    lblMsg.Text = "No Records Found..";
            }


            if (rdoReportType.Text == "3")
            {
                StringBuilder sb = new StringBuilder();
                if (chkIsBillDate.Checked == false)
                {
                    sb.Append("SELECT t.CentreID,t.CentreName,sm.Department,");
                    sb.Append("ROUND(SUM(GrossAmt))GrossAmt,sum(Quantity)Quantity,ROUND(SUM(Disc))Disc,");
                    sb.Append("ROUND(SUM(Amount))Amount ");
                    sb.Append("FROM (");
                    sb.Append("     SELECT cmt.`CentreID`,cmt.`CentreName`,ltd.ItemName,ltd.LedgerTnxID,ltd.DoctorID,1 Quantity,ltd.SurgeryName,ROUND(SUM((ltd.Rate*ltd.Quantity)))GrossAmt,ROUND(SUM(ltd.Amount))Amount,");
                    sb.Append("     IF(ltd.discountpercentage >0,ROUND(SUM(((ltd.Rate*ltd.Quantity)-ltd.Amount))),0)Disc,ltd.EntryDate,");
                    sb.Append("     ltd.LedgerTransactionNo,ltd.SurgeryID,lt.PatientID,lt.TransactionID,");
                    sb.Append("     lt.BillNo,lt.BillDate,ltd.IsPackage ");
                    sb.Append("     FROM f_ledgertnxdetail ltd INNER JOIN  patient_medical_history lt ON lt.TransactionID = ltd.TransactionID ");
                    sb.Append("     INNER JOIN center_master cmt ON cmt.`CentreID`=lt.`CentreID` ");
                    sb.Append("     WHERE ISSurgery=1 AND IsVerified=1  ");
                    sb.Append("		AND ltd.EntryDate >= '" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + " 00:00:00'  ");
                    sb.Append("		AND ltd.EntryDate <= '" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + " 00:00:00'  ");
                    sb.Append("     GROUP BY ltd.LedgerTnxID ");
                    sb.Append(")T INNER JOIN f_surgery_master sm ON t.SurgeryID = sm.Surgery_ID ");
                    
                    if (Items != "")
                        sb.Append("     AND sm.Surgery_ID IN (" + Items + ") ");
                    if (doctors != "")
                        sb.Append(" and T.DoctorID in (" + doctors + ") ");

                    sb.Append("GROUP BY sm.Department ");
                    sb.Append("ORDER BY sm.Department ");
                }
                else
                {
                    sb.Append("SELECT t.CentreID,t.CentreName,sm.Department,");
                    sb.Append("ROUND(SUM(GrossAmt))GrossAmt,sum(Quantity)Quantity,ROUND(SUM(Disc))Disc,");
                    sb.Append("ROUND(SUM(Amount))Amount ");
                    sb.Append("FROM (");
                    sb.Append("     SELECT cmt.`CentreID`,cmt.`CentreName`,ltd.ItemName,ltd.LedgerTnxID,ltd.DoctorID,1 Quantity,ltd.SurgeryName,ROUND(SUM((ltd.Rate*ltd.Quantity)))GrossAmt,ROUND(SUM(ltd.Amount))Amount,");
                    sb.Append("     IF(ltd.discountpercentage >0,ROUND(SUM(((ltd.Rate*ltd.Quantity)-ltd.Amount))),0)Disc,ltd.EntryDate,");
                    sb.Append("     ltd.LedgerTransactionNo,ltd.SurgeryID,lt.PatientID,lt.TransactionID,");
                    sb.Append("     lt.BillNo,lt.BillDate,ltd.IsPackage ");
                    sb.Append("     FROM f_ledgertnxdetail ltd INNER JOIN  patient_medical_history lt ON lt.TransactionID = ltd.TransactionID ");
                    sb.Append("     INNER JOIN center_master cmt ON cmt.`CentreID`=lt.`CentreID`  ");
                     sb.Append("     WHERE ISSurgery=1 AND IsVerified=1  AND (lt.BillNo IS NOT NULL AND lt.billNo <> '')  ");
                    sb.Append("     AND DATE(LT.BillDate) >=  '" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' ");
                    sb.Append("     AND DATE(LT.BillDate) <=  '" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "' ");
                    sb.Append("     GROUP BY ltd.LedgerTnxID ");
                    sb.Append(")T INNER JOIN f_surgery_master sm ON t.SurgeryID = sm.Surgery_ID ");
                    
                    if (Items != "")
                        sb.Append("     AND sm.Surgery_ID IN (" + Items + ") ");
                    if (doctors != "")
                        sb.Append(" and T.DoctorID in (" + doctors + ") ");

                    sb.Append("GROUP BY sm.Department ");
                    sb.Append("ORDER BY sm.Department ");
                }
                DataTable dt = new DataTable();
                dt = StockReports.GetDataTable(sb.ToString());

                if (dt.Rows.Count > 0)
                {
                    DataColumn dc = new DataColumn();
                    dc.ColumnName = "User";
                    dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
                    dt.Columns.Add(dc);

                    dc = new DataColumn();
                    dc.ColumnName = "Period";
                    dc.DefaultValue = "Period From : " + txtFromDate.Text.Trim() + " To : " + txtToDate.Text.Trim();
                    dt.Columns.Add(dc);

                    DataSet ds = new DataSet();
                    ds.Tables.Add(dt.Copy());

                   // ds.WriteXmlSchema(@"E:\AmitInves.xml");
                    Session["ds"] = ds;
                    Session["ReportName"] = "SurgeryAnalysisSummaryDeptWise";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);

                }
                else
                    lblMsg.Text = "No Records Found..";

            }
        }
        else
            lblMsg.Text = "Select Items";
        
    }
    
}
