using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web;
using System.Text;
using System.IO;
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;


public partial class Design_OPD_InvestigationAnalysisReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            BindGroups();
            BindDoctor();
            BindPanel();
            ddlGroups_SelectedIndexChanged(sender, e);
            chkSubGroups_CheckedChanged(sender, e);
            chkItems.Visible = false;
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
    private void BindGroups()
    {
        string str = "select CategoryID,Name from f_categorymaster where CategoryID IN (Select CategoryID  from f_ConfigRelation where ConfigID in  (1,2,3,4,5,6,7,9,10,11,14,20,22,24,25,27,28,23) ) order by Name ";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            ddlGroups.DataSource = dt;
            ddlGroups.DataTextField = "Name";
            ddlGroups.DataValueField = "CategoryID";
            ddlGroups.DataBind();
            //ListItem li = new ListItem("ALL", "ALL");
            //ddlGroups.Items.Add(li);
            //ddlGroups.SelectedIndex = ddlGroups.Items.IndexOf(ddlGroups.Items.FindByText("ALL"));
            lblMsg.Text = "";
        }
        else
        {
            ddlGroups.Items.Clear();
            lblMsg.Text = "No Groups Found";
        }
    }
    private void BindSubGroups()
    {
        string Cat = StockReports.GetSelection(ddlGroups);

        if (Cat != "")
        {
            string str = "select SubCategoryID,Name from f_subcategorymaster where CategoryID in (" + Cat + ") order by name";
            DataTable dt = StockReports.GetDataTable(str);
            if (dt.Rows.Count > 0)
            {
                chlSubGroups.DataSource = dt;
                chlSubGroups.DataTextField = "Name";
                chlSubGroups.DataValueField = "SubCategoryID";
                chlSubGroups.DataBind();
                lblMsg.Text = "";
            }
            else
            {
                chlSubGroups.Items.Clear();
                lblMsg.Text = "No Sub-Groups Found";
            }
        }

    }
    private void BindItems()
    {
        string Items = StockReports.GetSelection(chlSubGroups);
        if (Items != string.Empty)
        {
            string str = "select ItemID,TypeName from f_itemmaster where SubCategoryID in (" + Items + ") order by TypeName ";
            DataTable dt = StockReports.GetDataTable(str);
            if (dt.Rows.Count > 0)
            {
                chkItems.Visible = true;
                chlItems.DataSource = dt;
                chlItems.DataTextField = "TypeName";
                chlItems.DataValueField = "ItemID";
                chlItems.DataBind();
                lblMsg.Text = "";
            }
            else
            {
                chkItems.Visible = false;
                chlItems.Items.Clear();
                lblMsg.Text = "No Items Found";
            }
        }
        else
        {
            chkItems.Visible = false;
            chlItems.Items.Clear();
            lblMsg.Text = "Please Select Sub-Groups";
        }

    }
    protected void ddlGroups_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindSubGroups();
        chkSubGroups_CheckedChanged(sender, e);
        chkItems.Visible = false;
        chlItems.Items.Clear();
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
        string Centre =SelectCentreInInt(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }

        string Items = ReturnSelectedWithBrackets(chlItems);
        string SubCategoryID = ReturnSelectedWithBrackets(chlSubGroups);
        string Doctors = ReturnSelectedWithBrackets(chkDoctors);
        string Panels = ReturnSelectedWithBrackets(chlPanel);

        CreateTempTable(Items, "tmpItem"+Session["ID"].ToString(), "ItemID"); // Creating Temporary table of Items if selected
        CreateTempTableWithIntDataType(SubCategoryID, "tmpSubCat" + Session["ID"].ToString(), "SubCategoryID"); // Creating Temporary table of SubCategoryID if selected
        CreateTempTable(Doctors, "tmpDoc" + Session["ID"].ToString(), "DoctorID"); // Creating Temporary table of DoctorID if selected
        CreateTempTableWithIntDataType(Panels, "tmpPanel" + Session["ID"].ToString(), "PanelID"); // Creating Temporary table of PanelID if selected
        

        lblMsg.Text = "";
        StringBuilder sb = new StringBuilder();

        if (rdbReport.SelectedItem.Value == "S")
        {
            sb.Append(" SELECT (SELECT centreName FROM center_master WHERE centreID= t.CentreID)centreName,t.SubGroupname,t.CategoryID, ");

            if (rdoReportType.SelectedValue == "1")//Groupwise --  Columnname should be same as in  Select query above
                sb.Append(" (SELECT cm.Name FROM f_categorymaster cm WHERE cm.categoryID = t.CategoryID) ");
            else if (rdoReportType.SelectedValue == "2")//Doctorwise --  Columnname should be same as in  Select query above
                sb.Append(" (SELECT CONCAT(title,' ',NAME) FROM doctor_master WHERE DoctorID=t.DoctorID) ");
            else if (rdoReportType.SelectedValue == "3")//Panelwise --  Columnname should be same as in  Select query above
                sb.Append(" (SELECT company_name FROM f_panel_master WHERE PanelID = t.PanelID)");

            sb.Append(" GroupingBy,Package,TnxType,ItemName,LedgerTransactionNo,PanelID,SubCategoryID,centreID,ItemID,DoctorID, ");
            sb.Append(" sum(OPDRate)OPDRate,sum(OPDQty)OPDQty,sum(OPDGrossAmt)OPDGrossAmt,sum(OPDDiscPer)OPDDiscPer,sum(OPDDisAmt)OPDDisAmt,sum(OPDAmount)OPDAmount, ");
            sb.Append(" sum(IPDRate)IPDRate,sum(IPDQty)IPDQty,sum(IPDGrossAmt)IPDGrossAmt,sum(IPDDiscPer)IPDDiscPer,sum(IPDDisAmt)IPDDisAmt,sum(IPDAmount)IPDAmount,");
            sb.Append(" sum(OPDQty+IPDQty)TotalQty,sum(OPDAmount+IPDAmount)TotalAmt FROM ( ");
            sb.Append("     SELECT IF(ltd.IsPackage = 0,'No','Yes')Package,pmh.Type TnxType,ltd.ItemName,sc.name SubGroupname,sc.CategoryID, ");
            sb.Append("     IF(IFNULL(ltd.DoctorID,'') <>'',ltd.DoctorID,pmh.DoctorID) as DoctorID,ltd.LedgerTransactionNo,lt.PanelID,ltd.SubCategoryID,lt.centreID,ltd.ItemID, ");
            sb.Append("     ltd.Rate OPDRate, ltd.Quantity OPDQty,(ltd.GrossAmount)OPDGrossAmt, ltd.DiscountPercentage OPDDiscPer, ");
            sb.Append("     (ltd.TotalDiscAmt) OPDDisAmt,	ltd.NetItemAmt OPDAmount, ");
            sb.Append("     0 IPDRate,0 IPDQty,0 IPDGrossAmt,0 IPDDiscPer,0 IPDDisAmt,0 IPDAmount ");
            sb.Append("     FROM f_ledgertransaction lt  INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo AND ltd.IsVerified<>2 AND ltd.itemid<>'" + Resources.Resource.OPDAdvanceItemID + "' ");
            sb.Append(" 	INNER JOIN `patient_medical_history` pmh ON pmh.`TransactionID`=ltd.`TransactionID` ");
            sb.Append("     INNER JOIN f_subcategorymaster sc on sc.SubCategoryID = ltd.SubCategoryID ");

            if (Items != string.Empty)
                sb.Append(" INNER JOIN tmpItem" + Session["ID"].ToString() + " tim on tim.ItemID = ltd.ItemID ");

            if (SubCategoryID != string.Empty)
                sb.Append(" INNER JOIN tmpSubCat" + Session["ID"].ToString() + " tsc on tsc.SubCategoryID = ltd.SubCategoryID ");

            if (Doctors != string.Empty)
                sb.Append(" INNER JOIN tmpDoc" + Session["ID"].ToString() + " tdc on tdc.DoctorID =  IF(IFNULL(ltd.DoctorID,'') <>'',ltd.DoctorID,pmh.DoctorID) ");

            if (Panels != string.Empty)
                sb.Append(" INNER JOIN tmpPanel" + Session["ID"].ToString() + " tpn on tpn.PanelID = lt.PanelID ");

            // Below line commented because mysql is giving error incorrect DATe Time format if we are passing time like 23:59:59.
            // sb.Append("     WHERE ltd.EntryDate >= '" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + " 00:00:00' AND ltd.EntryDate <= '" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + " 25:59:59'  ");
            sb.Append("     WHERE date(ltd.EntryDate) >= '" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' AND DATE(ltd.EntryDate) <= '" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'  ");

            sb.Append(" 	AND lt.IsCancel=0  AND pmh.`Type` IN('OPD','EMG')  ");
            sb.Append(" 	AND pmh.CentreID IN (" + Centre + ") ");
            if (txtUHID.Text.Trim() != string.Empty)
                sb.Append(" 	AND pmh.PatientID ='" + txtUHID.Text.Trim() + "' ");
            sb.Append("     UNION ALL ");
            sb.Append("     SELECT IF(ltd.IsPackage = 0,'No','Yes')Package,'IPD' TnxType,ltd.ItemName,sc.name SubGroupname,sc.CategoryID, ");
            sb.Append("     IF(IFNULL(ltd.DoctorID,'') <>'',ltd.DoctorID,pmh.DoctorID) as DoctorID,ltd.LedgerTransactionNo,pmh.PanelID PanelID, ltd.SubCategoryID,pmh.centreID,ltd.ItemID, ");
            sb.Append("     0 OPDRate,0 OPDQty,0 OPDGrossAmt,0 OPDDiscPer,0 OPDDisAmt,0 OPDAmount, ");
            sb.Append("     ltd.Rate IPDRate,ltd.Quantity IPDQty,(ltd.GrossAmount)IPDGrossAmt,ltd.DiscountPercentage IPDDiscPer, ");

            if (rdoBillDate.SelectedValue == "1" || rdoBillDate.SelectedValue == "0")
                sb.Append("(ltd.TotalDiscAmt) IPDDisAmt,ltd.NetItemAmt AS IPDAmount ");

            else if (rdoBillDate.SelectedValue == "2")
            {
                sb.Append("((ltd.TotalDiscAmt)+ (ltd.NetItemAmt * ROUND(IFNULL(adj.DiscountOnBill,0)*100/IFNULL((SELECT SUM(Amount) FROM f_ledgertnxdetail  WHERE TransactionID=ltd.TransactionID AND isverified=1),0),4)*.01))IPDDisAmt,");
                sb.Append("(ltd.NetItemAmt-(ltd.NetItemAmt * ROUND(IFNULL(adj.DiscountOnBill,0)*100/IFNULL((SELECT SUM(Amount) FROM f_ledgertnxdetail  WHERE TransactionID=ltd.TransactionID AND isverified<>2),0),4)*.01))IPDAmount ");
            }

            sb.Append("     FROM f_ledgertnxdetail ltd   ");//INNER JOIN f_ipdadjustment adj ON adj.TransactionID = ltd.TransactionID
            sb.Append(" 	INNER JOIN `patient_medical_history` pmh ON pmh.`TransactionID`=ltd.TransactionID and pmh.Type='IPD' ");//adj.`TransactionID`
            sb.Append("     INNER JOIN f_subcategorymaster sc on sc.SubCategoryID = ltd.SubCategoryID ");

            if (Items != string.Empty)
                sb.Append(" INNER JOIN tmpItem" + Session["ID"].ToString() + " tim on tim.ItemID = ltd.ItemID ");

            if (SubCategoryID != string.Empty)
                sb.Append(" INNER JOIN tmpSubCat" + Session["ID"].ToString() + " tsc on tsc.SubCategoryID = ltd.SubCategoryID ");

            if (Doctors != string.Empty)
                sb.Append(" INNER JOIN tmpDoc" + Session["ID"].ToString() + " tdc on tdc.DoctorID =  IF(IFNULL(ltd.DoctorID,'') <>'',ltd.DoctorID,pmh.DoctorID) ");

            if (Panels != string.Empty)
                sb.Append(" INNER JOIN tmpPanel" + Session["ID"].ToString() + " tpn on tpn.PanelID = pmh.PanelID ");

            sb.Append(" 	WHERE  ltd.IsVerified<>2 AND ltd.itemid<>'" + Resources.Resource.OPDAdvanceItemID + "' ");
            sb.Append(" 	AND pmh.CentreID IN (" + Centre + ")  ");
            if (txtUHID.Text.Trim() != string.Empty)
                sb.Append(" 	AND pmh.PatientID ='" + txtUHID.Text.Trim() + "' ");

            if (rdoBillDate.SelectedValue == "0")
                // Below line commented because mysql is giving error incorrect DATe Time format if we are passing time like 23:59:59.
               // sb.Append(" AND ltd.EntryDate  >= '" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + " 00:00:00' AND ltd.EntryDate  <= '" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + " 23:59:59'  ");
                sb.Append(" AND date(ltd.EntryDate)  >= '" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' AND date(ltd.EntryDate)  <= '" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'  ");
            else
                sb.Append(" AND pmh.billDate  >= '" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + " 00:00:00' AND pmh.BillDate  <= '" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + " 23:59:59'  ");


            sb.Append(" )t ");

            if (rdoReportType.SelectedValue == "1")//Groupwise --  Columnname should be same as in  Select query above
                sb.Append(" GROUP BY centreID,CategoryID,SubCategoryID ");
            else if (rdoReportType.SelectedValue == "2")//Doctorwise --  Columnname should be same as in  Select query above
                sb.Append(" GROUP BY centreID,DoctorID,SubCategoryID ");
            else if (rdoReportType.SelectedValue == "3")//Panelwise --  Columnname should be same as in  Select query above
                sb.Append(" GROUP BY centreID,PanelID,SubCategoryID ");

            sb.Append(" ORDER BY centreID,SubGroupname ");

        }
        else if (rdbReport.SelectedItem.Value == "SI")
        {
            sb.Append(" SELECT (SELECT centreName FROM center_master WHERE centreID= t.CentreID)centreName,t.SubGroupname,t.CategoryID, ");   
            
            if (rdoReportType.SelectedValue == "1")//Groupwise --  Columnname should be same as in  Select query above
                sb.Append(" (SELECT cm.Name FROM f_categorymaster cm WHERE cm.categoryID = t.CategoryID) ");   
            else if (rdoReportType.SelectedValue == "2")//Doctorwise --  Columnname should be same as in  Select query above
                sb.Append(" (SELECT CONCAT(title,' ',NAME) FROM doctor_master WHERE DoctorID=t.DoctorID) ");
            else if (rdoReportType.SelectedValue == "3")//Panelwise --  Columnname should be same as in  Select query above
                sb.Append(" (SELECT company_name FROM f_panel_master WHERE PanelID = t.PanelID)");

            sb.Append(" GroupingBy,Package,TnxType,ItemName,LedgerTransactionNo,PanelID,SubCategoryID,centreID,ItemID,DoctorID, ");
            sb.Append(" sum(OPDRate)OPDRate,sum(OPDQty)OPDQty,sum(OPDGrossAmt)OPDGrossAmt,sum(OPDDiscPer)OPDDiscPer,sum(OPDDisAmt)OPDDisAmt,sum(OPDAmount)OPDAmount, ");
            sb.Append(" sum(IPDRate)IPDRate,sum(IPDQty)IPDQty,sum(IPDGrossAmt)IPDGrossAmt,sum(IPDDiscPer)IPDDiscPer,sum(IPDDisAmt)IPDDisAmt,sum(IPDAmount)IPDAmount,");
            sb.Append(" sum(OPDQty+IPDQty)TotalQty,sum(OPDAmount+IPDAmount)TotalAmt FROM ( ");
            sb.Append("     SELECT IF(ltd.IsPackage = 0,'No','Yes')Package,pmh.Type TnxType,ltd.ItemName,sc.name SubGroupname,sc.CategoryID, ");
            sb.Append("     IF(IFNULL(ltd.DoctorID,'') <>'',ltd.DoctorID,pmh.DoctorID) as DoctorID,ltd.LedgerTransactionNo,lt.PanelID,ltd.SubCategoryID,lt.centreID,ltd.ItemID, ");
            sb.Append("     ltd.Rate OPDRate, ltd.Quantity OPDQty,(ltd.GrossAmount)OPDGrossAmt, ltd.DiscountPercentage OPDDiscPer, ");
            sb.Append("     ltd.TotalDiscAmt OPDDisAmt,	ltd.NetItemAmt OPDAmount, ");
	        sb.Append("     0 IPDRate,0 IPDQty,0 IPDGrossAmt,0 IPDDiscPer,0 IPDDisAmt,0 IPDAmount ");
            sb.Append("     FROM f_ledgertransaction lt  INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo AND ltd.IsVerified<>2 AND ltd.itemid<>'" + Resources.Resource.OPDAdvanceItemID + "' ");
            sb.Append(" 	INNER JOIN `patient_medical_history` pmh ON pmh.`TransactionID`=ltd.`TransactionID` ");
            sb.Append("     INNER JOIN f_subcategorymaster sc on sc.SubCategoryID = ltd.SubCategoryID ");

            if (Items != string.Empty)
                sb.Append(" INNER JOIN tmpItem" + Session["ID"].ToString() + " tim on tim.ItemID = ltd.ItemID ");

            if (SubCategoryID != string.Empty)
                sb.Append(" INNER JOIN tmpSubCat" + Session["ID"].ToString() + " tsc on tsc.SubCategoryID = ltd.SubCategoryID ");

            if (Doctors != string.Empty)
                sb.Append(" INNER JOIN tmpDoc" + Session["ID"].ToString() + " tdc on tdc.DoctorID =  IF(IFNULL(ltd.DoctorID,'') <>'',ltd.DoctorID,pmh.DoctorID) ");

            if (Panels != string.Empty)
                sb.Append(" INNER JOIN tmpPanel" + Session["ID"].ToString() + " tpn on tpn.PanelID = lt.PanelID ");

            // Below line commented because mysql is giving error incorrect DATe Time format if we are passing time like 23:59:59.
            // sb.Append("     WHERE ltd.EntryDate >= '" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + " 00:00:00' AND ltd.EntryDate <= '" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + " 25:59:59'  ");
            sb.Append("     WHERE DATE(ltd.EntryDate) >= '" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' AND DATE(ltd.EntryDate) <= '" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'  ");

            sb.Append(" 	AND lt.IsCancel=0  AND pmh.`Type` IN('OPD','EMG')  ");
            sb.Append(" 	AND pmh.CentreID IN (" + Centre + ") ");
            if (txtUHID.Text.Trim() != string.Empty)
                sb.Append(" 	AND pmh.PatientID ='" + txtUHID.Text.Trim() + "' ");
	        sb.Append("     UNION ALL ");
            sb.Append("     SELECT IF(ltd.IsPackage = 0,'No','Yes')Package,'IPD' TnxType,ltd.ItemName,sc.name SubGroupname,sc.CategoryID, ");
            sb.Append("     IF(IFNULL(ltd.DoctorID,'') <>'',ltd.DoctorID,pmh.DoctorID) as DoctorID,ltd.LedgerTransactionNo,pmh.PanelID PanelID, ltd.SubCategoryID,pmh.centreID,ltd.ItemID, ");
	        sb.Append("     0 OPDRate,0 OPDQty,0 OPDGrossAmt,0 OPDDiscPer,0 OPDDisAmt,0 OPDAmount, ");
            sb.Append("     ltd.Rate IPDRate,ltd.Quantity IPDQty,(ltd.GrossAmount)IPDGrossAmt,ltd.DiscountPercentage IPDDiscPer, ");

            if (rdoBillDate.SelectedValue == "1" || rdoBillDate.SelectedValue == "0")
                sb.Append(" ltd.TotalDiscAmt IPDDisAmt,ltd.NetItemAmt IPDAmount ");

            else if (rdoBillDate.SelectedValue == "2")
            {
                sb.Append("(ltd.TotalDiscAmt+ (ltd.NetItemAmt * ROUND(IFNULL(adj.DiscountOnBill,0)*100/IFNULL((SELECT SUM(Amount) FROM f_ledgertnxdetail  WHERE TransactionID=ltd.TransactionID AND isverified<>2),0),4)*.01))IPDDisAmt,");
                sb.Append("(ltd.NetItemAmt-(ltd.NetItemAmt * ROUND(IFNULL(adj.DiscountOnBill,0)*100/IFNULL((SELECT SUM(Amount) FROM f_ledgertnxdetail  WHERE TransactionID=ltd.TransactionID AND isverified<>2),0),4)*.01))IPDAmount ");
            }

            sb.Append("     FROM f_ledgertnxdetail ltd   ");//INNER JOIN f_ipdadjustment adj ON adj.TransactionID = ltd.TransactionID
            sb.Append(" 	INNER JOIN `patient_medical_history` pmh ON pmh.`TransactionID`=ltd.`TransactionID`and pmh.Type='IPD'  ");//adj.`TransactionID`
            sb.Append("     INNER JOIN f_subcategorymaster sc on sc.SubCategoryID = ltd.SubCategoryID ");

            if (Items != string.Empty)
                sb.Append(" INNER JOIN tmpItem" + Session["ID"].ToString() + " tim on tim.ItemID = ltd.ItemID ");

            if (SubCategoryID != string.Empty)
                sb.Append(" INNER JOIN tmpSubCat" + Session["ID"].ToString() + " tsc on tsc.SubCategoryID = ltd.SubCategoryID ");

            if (Doctors != string.Empty)
                sb.Append(" INNER JOIN tmpDoc" + Session["ID"].ToString() + " tdc on tdc.DoctorID =  IF(IFNULL(ltd.DoctorID,'') <>'',ltd.DoctorID,pmh.DoctorID) ");

            if (Panels != string.Empty)
                sb.Append(" INNER JOIN tmpPanel" + Session["ID"].ToString() + " tpn on tpn.PanelID = pmh.PanelID ");

            sb.Append(" 	WHERE ltd.IsVerified<>2 AND ltd.itemid<>'" + Resources.Resource.OPDAdvanceItemID + "' ");
            sb.Append(" 	AND pmh.CentreID IN (" + Centre + ")  ");
            if (txtUHID.Text.Trim() != string.Empty)
                sb.Append(" 	AND pmh.PatientID ='" + txtUHID.Text.Trim() + "' ");

            if (rdoBillDate.SelectedValue == "0")
                // Below line commented because mysql is giving error incorrect DATe Time format if we are passing time like 23:59:59.
                // sb.Append(" AND ltd.EntryDate  >= '" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + " 00:00:00' AND ltd.EntryDate  <= '" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + " 23:59:59'  ");
                sb.Append(" AND DATE(ltd.EntryDate)  >= '" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' AND DATE(ltd.EntryDate)  <= '" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'  ");
            else
                sb.Append(" AND pmh.billDate  >= '" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + " 00:00:00' AND pmh.BillDate  <= '" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + " 23:59:59'  ");


            sb.Append(" )t ");

            if (rdoReportType.SelectedValue == "1")//Groupwise --  Columnname should be same as in  Select query above
                sb.Append(" GROUP BY centreID,CategoryID,ItemID ");
            else if (rdoReportType.SelectedValue == "2")//Doctorwise --  Columnname should be same as in  Select query above
                sb.Append(" GROUP BY centreID,DoctorID,ItemID ");
            else if (rdoReportType.SelectedValue == "3")//Panelwise --  Columnname should be same as in  Select query above
                sb.Append(" GROUP BY centreID,PanelID,ItemID ");

            sb.Append(" ORDER BY centreID,SubGroupname,ItemName ");

        }
        else
        {
            if (chkOPDIPD.Items[0].Selected == false && chkOPDIPD.Items[1].Selected == false)
            {
                lblMsg.Text = "Please Select View Type (OPD or IPD or Both)";
                return;
            }
            sb.Append(" SELECT t.*,DATE_FORMAT(t.EntryDate,'%d-%b-%y')DATE, ");
            sb.Append(" (SELECT CONCAT(title,' ',NAME) FROM doctor_master WHERE DoctorID=t.DoctorID)Doctor,  ");
            sb.Append(" (SELECT Designation FROM doctor_master WHERE DoctorID=t.DoctorID)Designation,  ");
            sb.Append(" (SELECT sc.name FROM f_subcategorymaster sc WHERE sc.subcategoryID = t.SubCategoryID)SubGroupname,  ");
            sb.Append(" (SELECT cm.Name FROM f_categorymaster cm INNER JOIN f_subcategorymaster sc ON cm.CategoryID = sc.CategoryID WHERE sc.SubcategoryID = t.SubCategoryID)Groupname,  ");
            sb.Append(" (SELECT company_name FROM f_panel_master WHERE PanelID = t.PanelID)company_name, ");
            sb.Append(" (SELECT centreName FROM center_master WHERE centreID= t.CentreID)centreName FROM (  ");
            if (chkOPDIPD.Items[1].Selected) // OPD
            {
                sb.Append(" 	SELECT ltd.LedgerTnxID LedgerID,IF(IFNULL(ltd.DoctorID,'') <>'',ltd.DoctorID,pmh.DoctorID) as DoctorID,ltd.LedgerTransactionNo,lt.PanelID,lt.PatientID, ltd.SubCategoryID,lt.centreID,ltd.ItemID,ltd.Amount, ");
                sb.Append(" 	ROUND(ltd.TotalDiscAmt,2) DisAmt, ltd.Quantity, (ltd.GrossAmount)GrossAmt,ltd.Rate,ltd.DiscountPercentage,  ");
                sb.Append(" 	IF(ltd.IsPackage = 0,'No','Yes')Package,pmh.TransNo TransactionID, ltd.EntryDate EntryDate,lt.BillNo,pmh.Type TnxType,lt.GrossAmount BillAmt,Pm.PName,pm.Mobile,pm.Age,pm.City,(SELECT IFNULL(StateName,'') StateName FROM master_state WHERE StateID=pm.StateID) StateName, ");
                sb.Append(" 	0 TotalBilledAmt,ltd.ItemName AS ItemName,  ");
                sb.Append("     ltd.CrDrNo ReceiptNo,  ");
                sb.Append("   IF(ltd.isPackage=1,(SELECT im.TypeName FROM f_itemmaster im WHERE im.ItemID=ltd.PackageID),'')PackageName  ");
                sb.Append(" 	FROM f_ledgertransaction lt  INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo  AND ltd.IsVerified<>2 AND ltd.itemid<>'" + Resources.Resource.OPDAdvanceItemID + "' ");
                sb.Append(" 	INNER JOIN `patient_medical_history` pmh ON pmh.`TransactionID`=ltd.`TransactionID` ");
                sb.Append(" 	INNER JOIN patient_master PM ON pm.PatientID = lt.PatientID ");

            if (Items != string.Empty)
                sb.Append(" INNER JOIN tmpItem" + Session["ID"].ToString() + " tim on tim.ItemID = ltd.ItemID ");

            if (SubCategoryID != string.Empty)
                sb.Append(" INNER JOIN tmpSubCat" + Session["ID"].ToString() + " tsc on tsc.SubCategoryID = ltd.SubCategoryID ");

            if (Doctors != string.Empty)
                sb.Append(" INNER JOIN tmpDoc" + Session["ID"].ToString() + " tdc on tdc.DoctorID = IF(IFNULL(ltd.DoctorID,'') <>'',ltd.DoctorID,pmh.DoctorID) ");

            if (Panels != string.Empty)
                sb.Append(" INNER JOIN tmpPanel" + Session["ID"].ToString() + " tpn on tpn.PanelID = lt.PanelID ");

            // Below line commented because mysql is giving error incorrect DATe Time format if we are passing time like 23:59:59.
             sb.Append("  WHERE ltd.EntryDate >= '" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + " 00:00:00' AND ltd.EntryDate <= '" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + " 23:59:59'  ");
            //sb.Append("     WHERE DATE(ltd.EntryDate) >= '" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' AND DATE(ltd.EntryDate) <= '" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'  ");

            //    sb.Append(" 	AND lt.IsCancel=0 AND ltd.Type IN ('O','E')  ");
                sb.Append(" 	AND lt.IsCancel=0  AND pmh.`Type` IN('OPD','EMG')   ");
                // sb.Append(" 	AND lt.CentreID IN (" + Centre + ") ");    


                sb.Append(" 	AND pmh.CentreID IN (" + Centre + ") ");
                if (txtUHID.Text.Trim() != string.Empty)
                    sb.Append(" 	AND pmh.PatientID ='" + txtUHID.Text.Trim() + "' ");
            }
            if (chkOPDIPD.Items[0].Selected) // IPD
            {
                if (chkOPDIPD.Items[1].Selected)  // checking if OPD is selected
                {
                    sb.Append(" 	UNION ALL  ");
                }


                sb.Append(" 	SELECT ltd.LedgerTnxID LedgerID, IF(IFNULL(ltd.DoctorID,'') <>'',ltd.DoctorID,pmh.DoctorID) as DoctorID,ltd.LedgerTransactionNo,pmh.PanelID PanelID, pmh.PatientID,ltd.SubCategoryID,pmh.centreID,ltd.ItemID,  ");

            if (rdoBillDate.SelectedValue == "1" || rdoBillDate.SelectedValue == "0")
                sb.Append("ltd.Amount,ROUND(ltd.TotalDiscAmt,2) DisAmt,");

            else if (rdoBillDate.SelectedValue == "2")
            {
                sb.Append("(ltd.Amount-(ltd.Amount * ROUND(IFNULL(adj.DiscountOnBill,0)*100/IFNULL((SELECT SUM(Amount) FROM f_ledgertnxdetail  WHERE TransactionID=ltd.TransactionID AND isverified<>2),0),4)*.01))Amount,");
                sb.Append("(ltd.TotalDiscAmt + (ltd.NetItemAmt * ROUND(IFNULL(adj.DiscountOnBill,0)*100/IFNULL((SELECT SUM(Amount) FROM f_ledgertnxdetail  WHERE TransactionID=ltd.TransactionID AND isverified<>2),0),4)*.01))DisAmt,");
            }

            sb.Append(" 	ltd.Quantity, (ltd.GrossAmount)GrossAmt,ltd.Rate, ");
            sb.Append(" 	ltd.DiscountPercentage, IF(ltd.IsPackage = 0,'No','Yes')Package,pmh.TransNo TransactionID, ");

            if (rdoBillDate.SelectedValue == "0")
                sb.Append("ltd.EntryDate EntryDate, ");
            else
                sb.Append("ltd.EntryDate EntryDate, ");

            sb.Append(" 	pmh.BillNo,'IPD' TnxType,'0' BillAmt, ");
            sb.Append(" 	Pm.PName,pm.Mobile,pm.Age,pm.City,(SELECT IFNULL(StateName,'') StateName FROM master_state WHERE StateID=pm.StateID) StateName,pmh.TotalBilledAmt,ltd.ItemName AS ItemName,ltd.CrDrNo ReceiptNo,  ");
            sb.Append("   IF(ltd.isPackage=1,(SELECT im.TypeName FROM f_itemmaster im WHERE im.ItemID=ltd.PackageID),'')PackageName  ");
            sb.Append(" 	FROM f_ledgertnxdetail ltd   ");//INNER JOIN f_ipdadjustment adj ON adj.TransactionID = ltd.TransactionID AND adj.isopeningBalance=0
            sb.Append(" 	INNER JOIN `patient_medical_history` pmh ON pmh.`TransactionID`=ltd.TransactionID  AND pmh.isopeningBalance=0 AND pmh.Type='IPD'   ");//adj.`TransactionID`
            sb.Append(" 	INNER JOIN patient_master PM ON pm.PatientID = pmh.PatientID	  ");

                if (Items != string.Empty)
                    sb.Append(" INNER JOIN tmpItem" + Session["ID"].ToString() + " tim on tim.ItemID = ltd.ItemID ");

                if (SubCategoryID != string.Empty)
                    sb.Append(" INNER JOIN tmpSubCat" + Session["ID"].ToString() + " tsc on tsc.SubCategoryID = ltd.SubCategoryID ");

                if (Doctors != string.Empty)
                    sb.Append(" INNER JOIN tmpDoc" + Session["ID"].ToString() + " tdc on tdc.DoctorID = IF(IFNULL(ltd.DoctorID,'') <>'',ltd.DoctorID,pmh.DoctorID) ");

                if (Panels != string.Empty)
                    sb.Append(" INNER JOIN tmpPanel" + Session["ID"].ToString() + " tpn on tpn.PanelID = pmh.PanelID ");

             //   sb.Append(" 	WHERE  ltd.IsVerified=1 ");
                sb.Append(" 	WHERE  ltd.IsVerified<>2 AND ltd.itemid<>'" + Resources.Resource.OPDAdvanceItemID + "' ");
                sb.Append(" 	AND pmh.CentreID IN (" + Centre + ")  ");

                if (txtUHID.Text.Trim() != string.Empty)
                    sb.Append(" 	AND pmh.PatientID ='" + txtUHID.Text.Trim() + "' ");
                if (rdoBillDate.SelectedValue == "0")
                    // Below line commented because mysql is giving error incorrect DATe Time format if we are passing time like 23:59:59.
                     sb.Append(" AND ltd.EntryDate  >= '" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + " 00:00:00' AND ltd.EntryDate  <= '" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + " 23:59:59'  ");
                    //sb.Append(" AND ltd.EntryDate  >= '" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' AND DATE(ltd.EntryDate)  <= '" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'  ");
                else
                    sb.Append(" AND pmh.billDate  >= '" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + " 00:00:00' AND pmh.BillDate  <= '" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + " 23:59:59'  ");
            }
            sb.Append("  )t ORDER BY t.EntryDate ASC ");
        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());
	    //System.IO.File.WriteAllText (@"F:\Niraj.txt", sb.ToString());
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

            dc = new DataColumn();
            dc.ColumnName = "ReportHead";
            dc.DefaultValue = rdoReportType.SelectedItem.Text+ " " + rdbReport.SelectedItem.Text + " Report";
            dt.Columns.Add(dc);
                      
            
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
           // Session["ds"] = ds;
          //  ds.WriteXmlSchema(@"D:\InvestigationAnalysis1.xml");
            string ReportName = string.Empty;
             //ReportDocument obj1 = new ReportDocument();
             if (rblReportFormatType.SelectedValue == "PDF")
             {
                 string CacheName = Session["ID"].ToString();
                 Common.CreateCache(CacheName, ds);
                 if (rdbReport.SelectedItem.Value == "D")
                 {
                     ReportName = "InvestigationAnalysis";
                     ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/commonReports/Commonreport.aspx?ReportName=InvestigationAnalysisDetail&Type=P');", true);
                 }
                 else if (rdbReport.SelectedItem.Value == "SI")
                 {
                     ReportName = "InvestigationAnalysisSummaryItemwise";
                     ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/commonReports/Commonreport.aspx?ReportName=InvestigationAnalysisSummaryItemwise&Type=P');", true);
                 }
                 else
                 {
                     ReportName = "InvestigationAnalysisSummary";
                     ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/commonReports/Commonreport.aspx?ReportName=" + ReportName + "&Type=P');", true);
                 }
             }
             else
             {
                 ReportName = "InvestigationAnalysis ( " + rdoReportType.SelectedItem.Text + " " + rdbReport.SelectedItem.Text + " )";
             
                 if (rdbReport.SelectedItem.Value == "D")
                 {
                     dt.Columns.Remove("DoctorID");
                     dt.Columns.Remove("LedgerTransactionNo");
                     dt.Columns.Remove("SubCategoryID");
                     dt.Columns.Remove("PanelID");
                     dt.Columns.Remove("centreID");
                     dt.Columns.Remove("Period");
                     dt.Columns.Remove("ReportHead");
                     dt.Columns.Remove("ItemID");
                     dt.Columns.Remove("TransactionID");
                     dt.Columns.Remove("GrossAmt");
                     dt.Columns.Remove("TotalBilledAmt");
                     dt.Columns.Remove("StateName");
                     dt.Columns.Remove("City");
                     dt.Columns.Remove("EntryDate");
                     dt.Columns.Remove("BillAmt");
                     dt.Columns.Remove("DiscountPercentage");

                     dt.Columns["Date"].SetOrdinal(0);
                     dt.Columns["PatientID"].SetOrdinal(1);
                     dt.Columns["PName"].SetOrdinal(2);
                     dt.Columns["Mobile"].SetOrdinal(3);
                     dt.Columns["Age"].SetOrdinal(4);
                     dt.Columns["BillNo"].SetOrdinal(5);
                     dt.Columns["Rate"].SetOrdinal(6);
                     dt.Columns["Quantity"].SetOrdinal(7);
                     dt.Columns["DisAmt"].SetOrdinal(8);
                     dt.Columns["Amount"].SetOrdinal(9);
                     dt.Columns["TnxType"].SetOrdinal(10);
                     dt.Columns["ItemName"].SetOrdinal(11);
                     dt.Columns["Doctor"].SetOrdinal(12);
                     dt.Columns["SubGroupname"].SetOrdinal(13);
                     dt.Columns["Groupname"].SetOrdinal(14);
                     dt.Columns["company_name"].SetOrdinal(15);
                     dt.Columns["centreName"].SetOrdinal(16);
                     dt.Columns["User"].SetOrdinal(17);
                     dt.Columns["ReceiptNo"].SetOrdinal(18);

                     dt.Columns["TnxType"].ColumnName = "Type";
                     dt.Columns["PatientID"].ColumnName = "UHID";
                     dt.Columns["ReceiptNo"].ColumnName = "CreditDebitNote";
                     dt.Columns["PName"].ColumnName = "PatientName";
                     dt.Columns["company_name"].ColumnName = "PanelName";
                     dt.Columns["centreName"].ColumnName = "CenterName";

                 }
                 else if (rdbReport.SelectedItem.Value == "S")
                 {
                     dt.Columns.Remove("DoctorID");
                     dt.Columns.Remove("LedgerTransactionNo");
                     dt.Columns.Remove("SubCategoryID");
                     dt.Columns.Remove("PanelID");
                     dt.Columns.Remove("centreID");
                     dt.Columns.Remove("Period");
                     dt.Columns.Remove("ReportHead");
                     dt.Columns.Remove("ItemID");
                     dt.Columns.Remove("CategoryID");
                     dt.Columns.Remove("User");

                     dt.Columns["TnxType"].ColumnName = "Type";
                     dt.Columns["centreName"].ColumnName = "CenterName";
                    
                 }
                 else if (rdbReport.SelectedItem.Value == "SI")
                 {
                     dt.Columns.Remove("DoctorID");
                     dt.Columns.Remove("LedgerTransactionNo");
                     dt.Columns.Remove("SubCategoryID");
                     dt.Columns.Remove("PanelID");
                     dt.Columns.Remove("centreID");
                     dt.Columns.Remove("Period");
                     dt.Columns.Remove("ReportHead");
                     dt.Columns.Remove("ItemID");
                     dt.Columns.Remove("CategoryID");
                     dt.Columns.Remove("User");
                     dt.Columns["TnxType"].ColumnName = "Type";
                     dt.Columns["centreName"].ColumnName = "CenterName";
                 }
                 
                 dt = Util.GetDataTableRowSum(dt);

                 string CacheName = Session["ID"].ToString();
                 Common.CreateCachedt(CacheName, dt);
                 ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/commonReports/Commonreport.aspx?ReportName=" + ReportName + "&Type=E');", true);
             }



             DropTableIfExists("tmpItem" + Session["ID"].ToString());
             DropTableIfExists("tmpSubCat" + Session["ID"].ToString());
             DropTableIfExists("tmpDoc" + Session["ID"].ToString());
             DropTableIfExists("tmpPanel" + Session["ID"].ToString());        
        }
        else
            lblMsg.Text = "Record Not Found";

    }

   
    private void CreateTempTable(string Data, string tableName,string ColName)
    {
        try
        {
            if (Data != string.Empty)
            {
                StockReports.ExecuteDML("Drop table if exists " + tableName);

                string str = "CREATE TABLE " + tableName + " (" + ColName + " VARCHAR(20), INDEX(" + ColName + "))";
                StockReports.ExecuteDML(str);

                str = "Insert into " + tableName + " values " + Data ;
                StockReports.ExecuteDML(str);
            }
        }
        catch (Exception ex)
        {
            
        }
        
    }


    private void CreateTempTableWithIntDataType(string Data, string tableName, string ColName)
    {
        try
        {
            if (Data != string.Empty)
            {
                StockReports.ExecuteDML("Drop table if exists " + tableName);

                string str = "CREATE TABLE " + tableName + " (" + ColName + " int(11), INDEX(" + ColName + "))";
                StockReports.ExecuteDML(str);

                str = "Insert into " + tableName + " values " + Data;
                StockReports.ExecuteDML(str);
            }
        }
        catch (Exception ex)
        {

        }

    }
    private string ReturnSelectedWithBrackets(CheckBoxList cbl)
    {
        string str = string.Empty;
        foreach (ListItem li in cbl.Items)
        {
            if (li.Selected)
            {
                if (str != string.Empty)
                    str += ",('" + li.Value + "')";
                else
                    str = "('" + li.Value + "')";
            }
        }
        return str;
    }

    private void DropTableIfExists(string TableName)
    {
        StockReports.ExecuteDML("Drop table if exists " + TableName);
    }
    protected void chkItemGroups_CheckedChanged(object sender, EventArgs e)
    {
        for (int i = 0; i < ddlGroups.Items.Count; i++)
            ddlGroups.Items[i].Selected = chkItemGroups.Checked;

        BindSubGroups();
    }
    public static string SelectCentreInInt(CheckBoxList chkCentre)
    {
        string str = string.Empty;
        foreach (ListItem li in chkCentre.Items)
        {
            if (li.Selected)
            {
                if (str != string.Empty)
                    str += "," + li.Value + "";
                else
                    str = "" + li.Value + "";
            }
        }
        return str;
    }
}
