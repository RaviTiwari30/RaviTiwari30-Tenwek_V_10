using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Purchase_SearchPurchaseRequest : System.Web.UI.Page
{
    #region Event Handling

    protected void btnReportDetail_Click(object sender, EventArgs e)
    {
        SearchPRDetails();
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        SearchPRSummary();
    }

    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        DataRowView row;
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            row = (DataRowView)e.Row.DataItem;
            e.Row.Attributes.Add("onMouseOver", "SetNewColor(this);");
            e.Row.Attributes.Add("onMouseOut", "SetOldColor(this);");
            e.Row.Attributes.Add("ondblclick", "ShowPR('" + Util.GetString(row["PurchaseRequestNo"]) + "');");
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["DeptLedgerNo"] != null)
                ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();

            if (Session["IsStore"] != null)
                ViewState["IsStore"] = Session["IsStore"].ToString();
            else
                ViewState["IsStore"] = "0";

            AllLoadData_Store.bindTypeMaster(cmbRequestType);


            BindEmployee();
            BindLedger();
            EntryDate1.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
            EntryDate2.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
            txtPRNo.Focus();
        }
        EntryDate1.Attributes.Add("readonly", "true");
        EntryDate2.Attributes.Add("readonly", "true");
    }
    #endregion Event Handling

    #region Data Binding

    private void BindEmployee()
    {
        string str = "select distinct(EmployeeID),EM.Name from employee_master EM inner join f_purchaserequestmaster PRM on EM.EmployeeID = PRM.RaisedByID";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {
            cmbEmployee.DataSource = dt;
            cmbEmployee.DataTextField = "Name";
            cmbEmployee.DataValueField = "EmployeeID";
            cmbEmployee.DataBind();
            cmbEmployee.Items.Insert(0, new ListItem("All"));
        }
    }

    private void BindItem()
    {
        DataTable dtItem = new DataTable();
        if (Convert.ToString(Session["LoginType"]).ToUpper() == "NONMEDICAL")
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT concat(IM.Typename,' # ','(',SM.name,')')ItemName,concat(IM.ItemID,'#',IM.SubCategoryID)ItemID");
            sb.Append(" from f_itemmaster IM inner join f_subcategorymaster SM on IM.SubCategoryID = SM.SubCategoryID INNER JOIN f_configrelation cr ON cr.CategoryID=sm.CategoryID ");
            sb.Append(" where cr.ConfigID IN (11,28) order by IM.Typename ");
            dtItem = StockReports.GetDataTable(sb.ToString());
        }
        else
            dtItem = CreateStockMaster.LoadAllStoreItems();
        if (dtItem != null && dtItem.Rows.Count > 0)
        {
            lstItem.DataSource = dtItem;
            lstItem.DataTextField = "ItemName";
            lstItem.DataValueField = "ItemID";
            lstItem.DataBind();
            lstItem.Items.Insert(0, (new ListItem("All", "0")));
        }
        else
        {
            lstItem.Items.Clear();
            lstItem.Items.Add("No Item Found");
        }
    }

    private void BindLedger()
    {
        string str = "SELECT LedgerName,LedgerNumber from f_ledgermaster Where GroupID='STO'";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {
            cmbPurchase.DataSource = dt;
            cmbPurchase.DataTextField = "LedgerName";
            cmbPurchase.DataValueField = "LedgerNumber";
            cmbPurchase.DataBind();

            DataTable dtrights = StockReports.GetRights(Session["RoleID"].ToString());
            if (dtrights.Rows.Count > 0)
            {
                if (Util.GetBoolean(dtrights.Rows[0]["IsGeneral"]) == true && Util.GetBoolean(dtrights.Rows[0]["IsMedical"]) == true)
                    cmbPurchase.SelectedIndex = cmbPurchase.Items.IndexOf(cmbPurchase.Items.FindByValue("STO00001"));
                else if (Util.GetBoolean(dtrights.Rows[0]["IsMedical"]) == true)
                {
                    cmbPurchase.SelectedIndex = cmbPurchase.Items.IndexOf(cmbPurchase.Items.FindByValue("STO00001"));
                    cmbPurchase.Enabled = false;
                }
                else if (Util.GetBoolean(dtrights.Rows[0]["IsGeneral"]) == true)
                {
                    cmbPurchase.SelectedIndex = cmbPurchase.Items.IndexOf(cmbPurchase.Items.FindByValue("STO00002"));
                    cmbPurchase.Enabled = false;
                }
            }
        }
    }



    #endregion Data Binding

    #region Search Request

    private void SearchPRDetails()
    {
        string ReportType = "";
        DataTable dt = new DataTable(); ;
        if (rdoReportFormat.SelectedValue == "1")
        {
            if (rdoReportType.SelectedValue == "1")
            {
                try
                {
                    string str = "";
                    StringBuilder Query = new StringBuilder();

                    Query.Append("  SELECT * FROM ( ");
                    Query.Append("  SELECT DISTINCT(PRM.PurchaseRequestNo),PRM.Type,(CASE WHEN PRM.Status = 0 THEN 'Pending Approval' WHEN PRM.Status = 1 THEN 'Rejected' ");
                    Query.Append("  WHEN PRM.Status = 2 THEN 'Approved' WHEN PRM.Status = 3 THEN 'Grn Done' END )STATUS, ");
                    Query.Append("  (CASE WHEN prd.Status=2 AND PRM.Approved <>3 THEN 'Partial' END)PartialSTATUS,PRM.Subject, ");
                    Query.Append("  DATE_FORMAT(PRM.RaisedDate,'%d-%b-%Y')RaisedDate,EM.Name,LM.LedgerName FROM f_purchaserequestmaster PRM  ");
                    Query.Append("  INNER JOIN f_purchaserequestdetails PRD ON PRM.PurchaseRequestNo=PRD.PurchaseRequisitionNo  ");
                    Query.Append("  INNER JOIN employee_master EM ON PRM.RaisedByID=EM.EmployeeID ");
                    Query.Append("  INNER JOIN f_ledgermaster LM ON LM.LedgerNumber = PRM.StoreID ");

                    str = GetCritarianew();

                    if (str != string.Empty)
                        Query.Append(str);

                    Query.Append(" UNION ALL ");
                    Query.Append(" SELECT DISTINCT(PRM.PurchaseRequestNo),PRM.Type,(CASE WHEN PRM.Status = 0 THEN 'Pending Approval' WHEN PRM.Status = 1 THEN 'Rejected'  ");
                    Query.Append(" WHEN PRM.Status = 2 THEN 'Approved' WHEN PRM.Status = 3 THEN 'Grn Done' END )STATUS,''PartialSTATUS,PRM.Subject, ");
                    Query.Append(" DATE_FORMAT(PRM.RaisedDate,'%d-%b-%Y')RaisedDate,EM.Name,LM.LedgerName FROM f_purchaserequestmaster PRM  ");
                    Query.Append(" INNER JOIN f_purchaserequestdetails PRD ON PRM.PurchaseRequestNo=PRD.PurchaseRequisitionNo  ");
                    Query.Append(" INNER JOIN employee_master EM ON PRM.RaisedByID=EM.EmployeeID  ");
                    Query.Append(" INNER JOIN f_ledgermaster LM ON LM.LedgerNumber = PRM.StoreID  ");
                    str = GetCritaria2();

                    if (str != string.Empty)
                        Query.Append(str);
                    Query.Append(" )t ");

                    if (chkPartial.Checked == true)
                    {
                        Query.Append(" WHERE t.PartialSTATUS='Partial' ");
                    }
                    Query.Append(" GROUP BY PurchaseRequestNo ");

                    dt = StockReports.GetDataTable(Query.ToString());
                }
                catch (Exception ex)
                {
                    ClassLog c1 = new ClassLog();
                    c1.errLog(ex);
                }
            }
            else
            {
                try
                {
                    string str = "";
                    string Query = "";
                    StringBuilder sb = new StringBuilder();

                    sb.Append(" SELECT PurchaseRequestNo,TYPE,STATUS,Status1,InHandQty,PartialSTATUS,SUBJECT,RaisedDate,NAME,ItemName,");
                    sb.Append(" LedgerName,RequestedQty,ApproxRate,ApprovedQty,RemainQty,Specification,ROUND((Issue-ReturnUnit)/2)AvgConsumption,ReorderLevel,CurrentStock,Replace(ItemID,'LSHHI','')ItemID");
                    sb.Append(" FROM");
                    sb.Append(" (SELECT PurchaseRequestNo,TYPE,STATUS,Status1,InHandQty,PartialSTATUS,SUBJECT,RaisedDate,NAME,ItemName,");
                    sb.Append(" LedgerName,RequestedQty,ApproxRate,ApprovedQty,RemainQty,Specification,IFNULL(Issue,0)Issue,IFNULL(ReturnUnit,0)ReturnUnit,ReorderLevel,CurrentStock,ItemID");
                    sb.Append(" FROM (");
                    sb.Append(" SELECT PRM.PurchaseRequestNo,PRM.Type,(");
                    sb.Append(" CASE WHEN PRD.Status = 0 THEN 'Pending Approval'");
                    sb.Append(" WHEN PRD.Status = 2 THEN 'Approved' ");
                    sb.Append(" WHEN PRD.Status = 1 THEN 'Rejected' ");
                    sb.Append(" WHEN PRD.Status = 3 THEN 'Grn Done' END )Status, ");

                    sb.Append(" (CASE WHEN PRM.Status = 0 THEN 'Pending Approval'");
                    sb.Append(" WHEN PRM.Status = 1 THEN 'Rejected' ");
                    sb.Append(" WHEN PRM.Status = 2 THEN 'Approved' ");
                    sb.Append(" WHEN PRM.Status = 3 THEN 'Grn Done' END )Status1, ");
                    sb.Append(" IFNULL(");
                    sb.Append(" (CASE WHEN prd.Status=2 AND PRM.Approved <>3 THEN 'ITEM' END),'')PartialSTATUS, ");
                    sb.Append(" PRM.Subject,DATE_FORMAT(PRM.RaisedDate,'%d-%b-%y')RaisedDate ,EM.Name,PRD.ItemName,prd.ItemID,");
                    sb.Append(" LM.LedgerName,PRD.RequestedQty,PRD.ApproxRate,PRD.ApprovedQty,(PRD.ApprovedQty-PRD.OrderedQty)RemainQty ,");
                    sb.Append(" PRD.Specification,");
                    sb.Append(" (SELECT SUM(SoldUnits) FROM f_salesdetails ");
                    sb.Append(" WHERE itemID=prd.itemID AND DATE<=CURRENT_DATE AND DATE>=ADDDATE(CURRENT_DATE,-60) AND TrasactionTypeID IN(3,13,1))Issue");
                    sb.Append(" ,(SELECT SUM(SoldUnits) FROM f_salesdetails ");
                    sb.Append(" WHERE itemID=prd.itemID AND DATE<=CURRENT_DATE AND DATE>=ADDDATE(CURRENT_DATE,-60) AND TrasactionTypeID IN(5,15,14))ReturnUnit  ");

                    sb.Append(" ,(SELECT sum(InitialCount-ReleasedCount) FROM f_stock st WHERE st.itemid=prd.ItemID and Date(MedExpiryDate)>=CURRENT_DATE GROUP BY st.itemid)CurrentStock");
                    sb.Append(" ,(SELECT sum(InitialCount-ReleasedCount) FROM f_stock st WHERE st.itemid=prd.ItemID and Date(MedExpiryDate)>=CURRENT_DATE and StoreLedgerNo='" + cmbPurchase.SelectedItem.Value + "' GROUP BY st.itemid)InHandQty ");

                    sb.Append(" ,ROUND(im.ReorderLevel)ReorderLevel FROM f_purchaserequestmaster PRM INNER JOIN f_purchaserequestdetails PRD ON ");
                    sb.Append(" PRM.PurchaseRequestNo=PRD.PurchaseRequisitionNo INNER JOIN employee_master EM ON ");
                    sb.Append(" PRM.RaisedByID=EM.EmployeeID ");
                    sb.Append(" INNER JOIN f_ledgermaster LM ");
                    sb.Append(" ON LM.LedgerNumber = PRM.StoreID INNER JOIN f_itemmaster im ON im.ItemID=prd.ItemID ");
                    str = GetCritaria();

                    if (str != string.Empty)
                        Query = sb.ToString() + str + ")t2";
                    dt = StockReports.GetDataTable(Query);
                }
                catch (Exception ex)
                {
                    ClassLog c1 = new ClassLog();
                    c1.errLog(ex);
                }
            }
            if (dt != null && dt.Rows.Count > 0)
            {
                if (rdoReportType.SelectedValue == "1")
                    ReportType = "SummaryPR";
                else
                    ReportType = "DetailPR";

                DataColumn dc = new DataColumn();
                dc.ColumnName = "PRDate";
                if (EntryDate1.Text.Trim() != string.Empty && EntryDate2.Text.Trim() != string.Empty)
                    dc.DefaultValue = "From : " + Util.GetDateTime(EntryDate1.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(EntryDate2.Text).ToString("dd-MMM-yyyy");
                else
                    dc.DefaultValue = "As On : " + DateTime.Now.ToString("dd-MMM-yyyy");

                dt.Columns.Add(dc);

                dc = new DataColumn();
                dc.ColumnName = "UserName";
                dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
                dt.Columns.Add(dc);

                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());

                Session["ds"] = ds;
                Session["ReportName"] = ReportType;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/common/Commonreport.aspx');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
                GridView1.DataSource = null;
                GridView1.DataBind();
            }
        }
        else
        {
            if (rdoReportType.SelectedValue == "1")
            {
                try
                {
                    string str = "";
                    StringBuilder Query = new StringBuilder();

                    Query.Append("  SELECT * FROM ( ");
                    Query.Append("  SELECT DISTINCT(PRM.PurchaseRequestNo),PRM.Type,(CASE WHEN PRM.Status = 0 THEN 'Pending Approval' WHEN PRM.Status = 1 THEN 'Rejected' ");
                    Query.Append("  WHEN PRM.Status = 2 THEN 'Approved' WHEN PRM.Status = 3 THEN 'Grn Done' END )Status, ");
                    Query.Append("  (CASE WHEN prd.Status=2 AND PRM.Approved <>3 THEN 'Partial' END)'Partial Status',PRM.Subject, ");
                    Query.Append("  DATE_FORMAT(PRM.RaisedDate,'%d-%b-%Y')'Raised Date',EM.Name,LM.LedgerName 'Department Name' FROM f_purchaserequestmaster PRM  ");
                    Query.Append("  INNER JOIN f_purchaserequestdetails PRD ON PRM.PurchaseRequestNo=PRD.PurchaseRequisitionNo  ");
                    Query.Append("  INNER JOIN employee_master EM ON PRM.RaisedByID=EM.EmployeeID ");
                    Query.Append("  INNER JOIN f_ledgermaster LM ON LM.LedgerNumber = PRM.StoreID ");

                    str = GetCritarianew();

                    if (str != string.Empty)
                        Query.Append(str);

                    Query.Append(" UNION ALL ");
                    Query.Append(" SELECT DISTINCT(PRM.PurchaseRequestNo),PRM.Type,(CASE WHEN PRM.Status = 0 THEN 'Pending Approval' WHEN PRM.Status = 1 THEN 'Rejected'  ");
                    Query.Append(" WHEN PRM.Status = 2 THEN 'Approved' WHEN PRM.Status = 3 THEN 'Grn Done' END )Status,'' `Partial Status`,PRM.Subject, ");
                    Query.Append(" DATE_FORMAT(PRM.RaisedDate,'%d-%b-%Y')'Raised Date',EM.Name,LM.LedgerName 'Department Name' FROM f_purchaserequestmaster PRM  ");
                    Query.Append(" INNER JOIN f_purchaserequestdetails PRD ON PRM.PurchaseRequestNo=PRD.PurchaseRequisitionNo  ");
                    Query.Append(" INNER JOIN employee_master EM ON PRM.RaisedByID=EM.EmployeeID  ");
                    Query.Append(" INNER JOIN f_ledgermaster LM ON LM.LedgerNumber = PRM.StoreID  ");
                    str = GetCritaria2();

                    if (str != string.Empty)
                        Query.Append(str);
                    Query.Append(" )t ");

                    if (chkPartial.Checked == true)
                    {
                        Query.Append(" WHERE t.PartialStatus='Partial' ");
                    }
                    Query.Append(" GROUP BY PurchaseRequestNo ");

                    dt = StockReports.GetDataTable(Query.ToString());
                }
                catch (Exception ex)
                {
                    ClassLog c1 = new ClassLog();
                    c1.errLog(ex);
                }
            }
            else
            {
                try
                {
                    string str = "";
                    string Query = "";
                    StringBuilder sb = new StringBuilder();

                    sb.Append(" SELECT PurchaseRequestNo 'Purchase Request No',Type,Status,Status1,InHandQty 'In Hand Quantity',PartialStatus,Subject,RaisedDate 'Raised Date',Name,ItemName 'Item Name',");
                    sb.Append(" LedgerName 'Ledger Name',RequestedQty 'Requested Qty',ApproxRate 'Approx Rate',ApprovedQty 'Approved Qty',RemainQty 'Remain Qty',Specification,ROUND((Issue-ReturnUnit)/2)'Average Consumption',ReorderLevel 'Reorder Level',CurrentStock 'Current Stock',Replace(ItemID,'LSHHI','')ItemID");
                    sb.Append(" FROM");
                    sb.Append(" (SELECT PurchaseRequestNo,TYPE,STATUS,Status1,InHandQty,PartialSTATUS,SUBJECT,RaisedDate,NAME,ItemName,");
                    sb.Append(" LedgerName,RequestedQty,ApproxRate,ApprovedQty,RemainQty,Specification,IFNULL(Issue,0)Issue,IFNULL(ReturnUnit,0)ReturnUnit,ReorderLevel,CurrentStock,ItemID");
                    sb.Append(" FROM (");
                    sb.Append(" SELECT PRM.PurchaseRequestNo,PRM.Type,(");
                    sb.Append(" CASE WHEN PRD.Status = 0 THEN 'Pending Approval'");
                    sb.Append(" WHEN PRD.Status = 2 THEN 'Approved' ");
                    sb.Append(" WHEN PRD.Status = 1 THEN 'Rejected' ");
                    sb.Append(" WHEN PRD.Status = 3 THEN 'Grn Done' END )Status, ");

                    sb.Append(" (CASE WHEN PRM.Status = 0 THEN 'Pending Approval'");
                    sb.Append(" WHEN PRM.Status = 1 THEN 'Approved' ");
                    sb.Append(" WHEN PRM.Status = 2 THEN 'Rejected' ");
                    sb.Append(" WHEN PRM.Status = 3 THEN 'Grn Done' END )Status1, ");
                    sb.Append(" IFNULL(");
                    sb.Append(" (CASE WHEN prd.Status=2 AND PRM.Approved <>3 THEN 'ITEM' END),'')PartialSTATUS, ");
                    sb.Append(" PRM.Subject,DATE_FORMAT(PRM.RaisedDate,'%d-%b-%y')RaisedDate ,EM.Name,PRD.ItemName,prd.ItemID,");
                    sb.Append(" LM.LedgerName,PRD.RequestedQty,PRD.ApproxRate,PRD.ApprovedQty,(PRD.ApprovedQty-PRD.OrderedQty)RemainQty ,");
                    sb.Append(" PRD.Specification,");
                    sb.Append(" (SELECT SUM(SoldUnits) FROM f_salesdetails ");
                    sb.Append(" WHERE itemID=prd.itemID AND DATE<=CURRENT_DATE AND DATE>=ADDDATE(CURRENT_DATE,-60) AND TrasactionTypeID IN(3,13,1))Issue");
                    sb.Append(" ,(SELECT SUM(SoldUnits) FROM f_salesdetails ");
                    sb.Append(" WHERE itemID=prd.itemID AND DATE<=CURRENT_DATE AND DATE>=ADDDATE(CURRENT_DATE,-60) AND TrasactionTypeID IN(5,15,14))ReturnUnit  ");

                    sb.Append(" ,(SELECT sum(InitialCount-ReleasedCount) FROM f_stock st WHERE st.itemid=prd.ItemID and Date(MedExpiryDate)>=CURRENT_DATE GROUP BY st.itemid)CurrentStock");
                    sb.Append(" ,(SELECT sum(InitialCount-ReleasedCount) FROM f_stock st WHERE st.itemid=prd.ItemID and Date(MedExpiryDate)>=CURRENT_DATE and StoreLedgerNo='" + cmbPurchase.SelectedItem.Value + "' GROUP BY st.itemid)InHandQty ");

                    sb.Append(" ,ROUND(im.ReorderLevel)ReorderLevel FROM f_purchaserequestmaster PRM INNER JOIN f_purchaserequestdetails PRD ON ");
                    sb.Append(" PRM.PurchaseRequestNo=PRD.PurchaseRequisitionNo INNER JOIN employee_master EM ON ");
                    sb.Append(" PRM.RaisedByID=EM.EmployeeID ");
                    sb.Append(" INNER JOIN f_ledgermaster LM ");
                    sb.Append(" ON LM.LedgerNumber = PRM.StoreID INNER JOIN f_itemmaster im ON im.ItemID=prd.ItemID ");
                    str = GetCritaria();

                    if (str != string.Empty)
                        Query = sb.ToString() + str + ")t2";
                    dt = StockReports.GetDataTable(Query);
                }
                catch (Exception ex)
                {
                    ClassLog c1 = new ClassLog();
                    c1.errLog(ex);
                }
            }
            if (dt != null && dt.Rows.Count > 0)
            {
                if (rdoReportType.SelectedValue == "1")
                    ReportType = "Purchase Request Summary Report";
                else
                    ReportType = "Purchase Request Detail Report";

                DataColumn dc = new DataColumn();
                dc.ColumnName = "PR Date";
                if (EntryDate1.Text.Trim() != string.Empty && EntryDate2.Text.Trim() != string.Empty)
                    dc.DefaultValue = "From : " + Util.GetDateTime(EntryDate1.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(EntryDate2.Text).ToString("dd-MMM-yyyy");
                else
                    dc.DefaultValue = "As On : " + DateTime.Now.ToString("dd-MMM-yyyy");

                dt.Columns.Add(dc);

                dc = new DataColumn();
                dc.ColumnName = "User Name";
                dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
                dt.Columns.Add(dc);

                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());
                dt.Columns[2].ColumnName = "Item Status";
                dt.Columns[3].ColumnName = "PR Status";
                dt.Columns[9].ColumnName = "Raised By";
                Session["dtExport2Excel"] = dt;
                Session["ReportName"] = ReportType;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
                GridView1.DataSource = null;
                GridView1.DataBind();
            }
        }
    }

    private void SearchPRSummary()
    {
        string str = string.Empty;

        try
        {
            StringBuilder Query = new StringBuilder();

            Query.Append("  SELECT * FROM ( ");
            Query.Append("  SELECT DISTINCT(PRM.PurchaseRequestNo),PRM.Type,(CASE WHEN PRM.Status = 0 THEN 'Pending Approval' WHEN PRM.Status = 1 THEN 'Rejected' ");
            Query.Append("  WHEN PRM.Status = 2 THEN 'Approved' WHEN PRM.Status = 3 THEN 'Grn Done' END )STATUS, ");
            Query.Append("  (CASE WHEN prd.Status=2 AND PRM.Approved <>3 THEN 'Partial' END)PartialSTATUS,PRM.Subject, ");
            Query.Append("  DATE_FORMAT(PRM.RaisedDate,'%d-%b-%Y')RaisedDate,EM.Name,LM.LedgerName,PRM.CentreID FROM f_purchaserequestmaster PRM  ");
            Query.Append("  INNER JOIN f_purchaserequestdetails PRD ON PRM.PurchaseRequestNo=PRD.PurchaseRequisitionNo  ");
            Query.Append("  INNER JOIN employee_master EM ON PRM.RaisedByID=EM.EmployeeID ");
            Query.Append("  INNER JOIN f_ledgermaster LM ON LM.LedgerNumber = PRM.StoreID ");

            str = GetCritarianew();

            if (str != string.Empty)
                Query.Append(str);

            Query.Append(" UNION ALL ");
            Query.Append(" SELECT DISTINCT(PRM.PurchaseRequestNo),PRM.Type,(CASE WHEN PRM.Status = 0 THEN 'Pending Approval' WHEN PRM.Status = 1 THEN 'Rejected'  ");
            Query.Append(" WHEN PRM.Status = 2 THEN 'Approved' WHEN PRM.Status = 3 THEN 'Grn Done' END )STATUS,''PartialSTATUS,PRM.Subject, ");
            Query.Append(" DATE_FORMAT(PRM.RaisedDate,'%d-%b-%Y')RaisedDate,EM.Name,LM.LedgerName,PRM.CentreID FROM f_purchaserequestmaster PRM  ");
            Query.Append(" INNER JOIN f_purchaserequestdetails PRD ON PRM.PurchaseRequestNo=PRD.PurchaseRequisitionNo  ");
            Query.Append(" INNER JOIN employee_master EM ON PRM.RaisedByID=EM.EmployeeID  ");
            Query.Append(" INNER JOIN f_ledgermaster LM ON LM.LedgerNumber = PRM.StoreID  ");
            str = GetCritaria2();

            if (str != string.Empty)
                Query.Append(str);

            Query.Append(" )t ");

            if (chkPartial.Checked == true)
                Query.Append(" WHERE t.PartialSTATUS='Partial' AND t.CentreID='" + Session["CentreID"].ToString() + "'");
            else
                Query.Append(" WHERE  t.CentreID='" + Session["CentreID"].ToString() + "' ");
            Query.Append(" GROUP BY PurchaseRequestNo ");

            DataTable dt = StockReports.GetDataTable(Query.ToString());
            if (dt != null && dt.Rows.Count > 0)
            {
                GridView1.DataSource = dt;
                GridView1.DataBind();
                for (int i = 0; i < GridView1.Rows.Count; i++)
                {
                    if (GridView1.Rows[i].Cells[5].Text == "Pending Approval")
                    {
                        GridView1.Rows[i].BackColor = System.Drawing.Color.LightBlue;
                    }
                    if (GridView1.Rows[i].Cells[5].Text == "Approved")
                    {
                        GridView1.Rows[i].BackColor = System.Drawing.Color.YellowGreen; ;
                    }
                    if (GridView1.Rows[i].Cells[5].Text == "Rejected")
                    {
                        GridView1.Rows[i].BackColor = System.Drawing.Color.LightPink;
                    }
                    if (GridView1.Rows[i].Cells[5].Text == "Grn Done")
                    {
                        GridView1.Rows[i].BackColor = System.Drawing.Color.Yellow;
                    }
                }
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
                GridView1.DataSource = null;
                GridView1.DataBind();
            }
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
        }
    }

    #endregion Search Request

    protected void btnA_Click(object sender, EventArgs e)
    {
        searchPRbtn("Grn Done");
    }

    protected void btnNA_Click(object sender, EventArgs e)
    {
        searchPRbtn("Rejected");
    }

    protected void btnRN_Click(object sender, EventArgs e)
    {
        searchPRbtn("Approved");
    }

    protected void btnSN_Click(object sender, EventArgs e)
    {
        searchPRbtn("Pending Approval");
    }

    protected void grdItem_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblStatus")).Text == "2")
            {
                e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#FF99CC");
            }
            else
            {
                e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#99FFCC");
            }
        }
    }

    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "AView")
        {
            string PurchaseRequestNo = e.CommandArgument.ToString();
            StringBuilder sb = new StringBuilder();
            sb.Append("select pr.PurchaseRequestNo,prd.Purpose,prd.PuschaseRequistionDetailID,pr.RaisedDate,pr.Subject,pr.Type,pr.Approved Status, prd.ItemName,prd.RequestedQty,prd.ApprovedQty,");
            sb.Append(" prd.OrderedQty,prd.Specification,prd.ApproxRate,prd.discount ,prd.RequiredInDays,prd.Status PRDStatus,prd.InHandQty,if(lm.LedgerName is null,'No-Vendor',lm.LedgerName)LedgerName,");
            sb.Append(" CONCAT(em.Title,' ',em.Name) RaisedUser,prd.ItemID from f_purchaserequestmaster pr inner join f_purchaserequestdetails prd");
            sb.Append(" on pr.PurchaseRequestNo = prd.PurchaseRequisitionNo inner join employee_master em on em.EmployeeID = pr.RaisedByID");
            sb.Append(" left join f_ledgermaster lm on lm.LedgerNumber = prd.ProbableVendorID where PurchaseRequestNo = '" + PurchaseRequestNo + "' and prd.ApprovedQty > 0  order by prd.ItemName ");

            DataTable dt = new DataTable();
            dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                grdItem.DataSource = dt;
                grdItem.DataBind();
                mdlView.Show();
            }
            else
            {
                grdItem.DataSource = null;
                grdItem.DataBind();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            }
        }
    }

    private void searchPRbtn(string status)
    {
        string str = string.Empty;
        StringBuilder Query = new StringBuilder();

        Query.Append("  SELECT * FROM ( ");
        Query.Append("  SELECT t1.* FROM ( ");
        Query.Append("  SELECT DISTINCT(PRM.PurchaseRequestNo),PRM.Type,(CASE WHEN PRM.Status = 0 THEN 'Pending Approval' WHEN PRM.Status = 1 THEN 'Rejected' ");
        Query.Append("  WHEN PRM.Status = 2 THEN 'Approved' WHEN PRM.Status = 3 THEN 'Grn Done' END )STATUS, ");
        Query.Append("  (CASE WHEN prd.Status=2 AND PRM.Approved <>3 THEN 'Partial' END)PartialSTATUS,PRM.Subject, ");
        Query.Append("  DATE_FORMAT(PRM.RaisedDate,'%d-%b-%y')RaisedDate,EM.Name,LM.LedgerName FROM f_purchaserequestmaster PRM  ");
        Query.Append("  INNER JOIN f_purchaserequestdetails PRD ON PRM.PurchaseRequestNo=PRD.PurchaseRequisitionNo  ");
        Query.Append("  INNER JOIN employee_master EM ON PRM.RaisedByID=EM.EmployeeID ");
        Query.Append("  INNER JOIN f_ledgermaster LM ON LM.LedgerNumber = PRM.StoreID ");
        str = GetCritarianew();
        if (str != string.Empty)
            Query.Append(str);
        Query.Append("  )t1 ");
        Query.Append(" where t1.STATUS='" + status + "' ");

        Query.Append(" UNION ALL ");
        Query.Append(" SELECT t2.* FROM ( ");
        Query.Append(" SELECT DISTINCT(PRM.PurchaseRequestNo),PRM.Type,(CASE WHEN PRM.Status = 0 THEN 'Pending Approval' WHEN PRM.Status = 1 THEN 'Rejected'  ");
        Query.Append(" WHEN PRM.Status = 2 THEN 'Approved' WHEN PRM.Status = 3 THEN 'Grn Done' END )STATUS,''PartialSTATUS,PRM.Subject, ");
        Query.Append(" DATE_FORMAT(PRM.RaisedDate,'%d-%b-%y')RaisedDate,EM.Name,LM.LedgerName FROM f_purchaserequestmaster PRM  ");
        Query.Append(" INNER JOIN f_purchaserequestdetails PRD ON PRM.PurchaseRequestNo=PRD.PurchaseRequisitionNo  ");
        Query.Append(" INNER JOIN employee_master EM ON PRM.RaisedByID=EM.EmployeeID  ");
        Query.Append(" INNER JOIN f_ledgermaster LM ON LM.LedgerNumber = PRM.StoreID  ");
        str = GetCritaria2();
        if (str != string.Empty)
            Query.Append(str);

        Query.Append("  )t2 ");
        Query.Append(" where t2.STATUS='" + status + "' ");

        Query.Append(" )t ");

        if (chkPartial.Checked == true)
        {
            Query.Append(" WHERE t.PartialSTATUS='Partial' ");
        }
        Query.Append(" GROUP BY PurchaseRequestNo ");

        DataTable dt = StockReports.GetDataTable(Query.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            GridView1.DataSource = dt;
            GridView1.DataBind();
            for (int i = 0; i < GridView1.Rows.Count; i++)
            {
                if (GridView1.Rows[i].Cells[5].Text == "Pending Approval")
                {
                    GridView1.Rows[i].BackColor = System.Drawing.Color.LightBlue;
                }
                if (GridView1.Rows[i].Cells[5].Text == "Approved")
                {
                    GridView1.Rows[i].BackColor = System.Drawing.Color.YellowGreen; ;
                }
                if (GridView1.Rows[i].Cells[5].Text == "Rejected")
                {
                    GridView1.Rows[i].BackColor = System.Drawing.Color.LightPink;
                }
                if (GridView1.Rows[i].Cells[5].Text == "Grn Done")
                {
                    GridView1.Rows[i].BackColor = System.Drawing.Color.Yellow;
                }
            }
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            GridView1.DataSource = null;
            GridView1.DataBind();
        }
    }

    #region Search Critaria

    private string GetCritaria()
    {
        string str = string.Empty;
        str = " WHERE PRM.CentreID=" + Session["CentreID"].ToString() + " ";
        if (txtPRNo.Text.Trim() != string.Empty)
            str = str + " AND PRM.PurchaseRequestNo = '" + txtPRNo.Text.Trim() + "'";
        
        if (cmbRequestType.SelectedIndex > 0)
        {
            if (str != string.Empty)
                str = str + " and PRM.Type = '" + cmbRequestType.SelectedItem + "'";
            else
                str = " where PRM.Type = '" + cmbRequestType.SelectedItem + "'";
        }

        if (txtSubject.Text.Trim() != string.Empty)
        {
            if (str != string.Empty)
                str = str + " and PRM.Subject like '" + txtSubject.Text.Trim() + "%'";
            else
                str = " where PRM.Subject like '" + txtSubject.Text.Trim() + "%'";
        }
        if (EntryDate1.Text.Trim() != string.Empty)
        {
            if (str != string.Empty)
                str = str + " and date(PRM.RaisedDate) >= '" + Util.GetDateTime(EntryDate1.Text).ToString("yyyy-MM-dd") + "'";
            else
                str = " where date(PRM.RaisedDate) >= '" + Util.GetDateTime(EntryDate1.Text).ToString("yyyy-MM-dd") + "'";
        }
        if (EntryDate2.Text.Trim() != string.Empty)
        {
            if (str != string.Empty)
                str = str + " and date(PRM.RaisedDate) <='" + Util.GetDateTime(EntryDate2.Text).ToString("yyyy-MM-dd") + "'";
            else
                str = " where date(PRM.RaisedDate) <='" + Util.GetDateTime(EntryDate2.Text).ToString("yyyy-MM-dd") + "'";
        }
        if (cmbStatus.SelectedIndex > 0)
        {
            if (str != string.Empty)
                str = str + " and PRM.status = '" + cmbStatus.SelectedItem.Value + "'";
            else
                str = " where PRM.status = '" + cmbStatus.SelectedItem.Value + "'";
        }
        if (cmbEmployee.SelectedIndex > 0)
        {
            if (str != string.Empty)
                str = str + " and PRM.RaisedByID = '" + cmbEmployee.SelectedItem.Value + "'";
            else
                str = " where PRM.RaisedByID = '" + cmbEmployee.SelectedItem.Value + "'";
        }
        if (lstItem.SelectedIndex > 0)
        {
            if (str != string.Empty)
                str = str + " and PRD.ItemID = '" + lstItem.SelectedItem.Value.Split('#')[0].ToString() + "'";
            else
                str = " where PRD.ItemID = '" + lstItem.SelectedItem.Value.Split('#')[0].ToString() + "'";
        }
        if (cmbPurchase.SelectedIndex >= 0)
        {
            if (str != string.Empty)
                str = str + " and PRM.StoreID = '" + cmbPurchase.SelectedItem.Value + "'";
            else
                str = " where PRM.StoreID = '" + cmbPurchase.SelectedItem.Value + "'";
        }
        if (Util.GetString(ViewState["DeptLedgerNo"]) != Resources.Resource.PurchaseDeptLedgerNo)
         str = str + " AND  PRD.Indent_Department='" + ViewState["DeptLedgerNo"].ToString() + "' ";
        
        str = str + " )t";

        if (chkPartial.Checked == true)
        {
            str = str + "  WHERE t.PartialSTATUS='Partial' ";
        }

        return str;
    }

    private string GetCritaria2()
    {
        string str = string.Empty;
        str = " WHERE PRM.CentreID=" + Session["CentreID"].ToString() + " ";
        if (txtPRNo.Text.Trim() != string.Empty)
            str = str + " AND PRM.PurchaseRequestNo = '" + txtPRNo.Text.Trim() + "'";

        if (cmbRequestType.SelectedIndex > 0)
        {
            if (str != string.Empty)
                str = str + " and PRM.Type = '" + cmbRequestType.SelectedItem + "'";
            else
                str = " where PRM.Type = '" + cmbRequestType.SelectedItem + "'";
        }

        if (txtSubject.Text.Trim() != string.Empty)
        {
            if (str != string.Empty)
                str = str + " and PRM.Subject like '" + txtSubject.Text.Trim() + "%'";
            else
                str = " where PRM.Subject like '" + txtSubject.Text.Trim() + "%'";
        }
        if (txtPRNo.Text.Trim() == string.Empty)
        {
            if (EntryDate1.Text.Trim() != string.Empty)
            {
                if (str != string.Empty)
                    str = str + " and date(PRM.RaisedDate) >= '" + Util.GetDateTime(EntryDate1.Text).ToString("yyyy-MM-dd") + "'";
                else
                    str = " where date(PRM.RaisedDate) >= '" + Util.GetDateTime(EntryDate1.Text).ToString("yyyy-MM-dd") + "'";
            }
            if (EntryDate2.Text.Trim() != string.Empty)
            {
                if (str != string.Empty)
                    str = str + " and date(PRM.RaisedDate) <='" + Util.GetDateTime(EntryDate2.Text).ToString("yyyy-MM-dd") + "'";
                else
                    str = " where date(PRM.RaisedDate) <='" + Util.GetDateTime(EntryDate2.Text).ToString("yyyy-MM-dd") + "'";
            }
        }
        if (cmbStatus.SelectedIndex > 0)
        {
            if (str != string.Empty)
                str = str + " and PRM.status = '" + cmbStatus.SelectedItem.Value + "'";
            else
                str = " where PRM.status = '" + cmbStatus.SelectedItem.Value + "'";
        }
        if (cmbEmployee.SelectedIndex > 0)
        {
            if (str != string.Empty)
                str = str + " and PRM.RaisedByID = '" + cmbEmployee.SelectedItem.Value + "'";
            else
                str = " where PRM.RaisedByID = '" + cmbEmployee.SelectedItem.Value + "'";
        }
        if (lstItem.SelectedIndex > 0)
        {
            if (str != string.Empty)
                str = str + " and PRD.ItemID = '" + lstItem.SelectedItem.Value.Split('#')[0].ToString() + "'";
            else
                str = " where PRD.ItemID = '" + lstItem.SelectedItem.Value.Split('#')[0].ToString() + "'";
        }
        if (cmbPurchase.SelectedIndex >= 0)
        {
            if (str != string.Empty)
                str = str + " and PRM.StoreID = '" + cmbPurchase.SelectedItem.Value + "'";
            else
                str = " where PRM.StoreID = '" + cmbPurchase.SelectedItem.Value + "'";
        }
        if (Util.GetString(ViewState["DeptLedgerNo"]) != Resources.Resource.PurchaseDeptLedgerNo)
            str = str + " AND  PRD.Indent_Department='" + ViewState["DeptLedgerNo"].ToString() + "' ";

        return str;
    }

    private string GetCritarianew()
    {
        string str = string.Empty;

        str = " WHERE PRM.CentreID=" + Session["CentreID"].ToString() + " ";
        if (txtPRNo.Text.Trim() != string.Empty)
            str = str + " AND PRM.PurchaseRequestNo = '" + txtPRNo.Text.Trim() + "'";

        if (cmbRequestType.SelectedIndex > 0)
        {
            if (str != string.Empty)
                str = str + " and PRM.Type = '" + cmbRequestType.SelectedItem + "'";
            else
                str = " where PRM.Type = '" + cmbRequestType.SelectedItem + "'";
        }

        if (txtSubject.Text.Trim() != string.Empty)
        {
            if (str != string.Empty)
                str = str + " and PRM.Subject like '" + txtSubject.Text.Trim() + "%'";
            else
                str = " where PRM.Subject like '" + txtSubject.Text.Trim() + "%'";
        }
        if (txtPRNo.Text.Trim() == string.Empty)
        {
            if (EntryDate1.Text.Trim() != string.Empty)
            {
                if (str != string.Empty)
                    str = str + " and date(PRM.RaisedDate) >= '" + Util.GetDateTime(EntryDate1.Text).ToString("yyyy-MM-dd") + "'";
                else
                    str = " where date(PRM.RaisedDate) >= '" + Util.GetDateTime(EntryDate1.Text).ToString("yyyy-MM-dd") + "'";
            }
            if (EntryDate2.Text.Trim() != string.Empty)
            {
                if (str != string.Empty)
                    str = str + " and date(PRM.RaisedDate) <='" + Util.GetDateTime(EntryDate2.Text).ToString("yyyy-MM-dd") + "'";
                else
                    str = " where date(PRM.RaisedDate) <='" + Util.GetDateTime(EntryDate2.Text).ToString("yyyy-MM-dd") + "'";
            }
        }
        if (cmbStatus.SelectedIndex > 0)
        {
            if (str != string.Empty)
                str = str + " and PRM.status = '" + cmbStatus.SelectedItem.Value + "'";
            else
                str = " where PRM.status = '" + cmbStatus.SelectedItem.Value + "'";
        }
        if (cmbEmployee.SelectedIndex > 0)
        {
            if (str != string.Empty)
                str = str + " and PRM.RaisedByID = '" + cmbEmployee.SelectedItem.Value + "'";
            else
                str = " where PRM.RaisedByID = '" + cmbEmployee.SelectedItem.Value + "'";
        }
        if (lstItem.SelectedIndex > 0)
        {
            if (str != string.Empty)
                str = str + " and PRD.ItemID = '" + lstItem.SelectedItem.Value.Split('#')[0].ToString() + "'";
            else
                str = " where PRD.ItemID = '" + lstItem.SelectedItem.Value.Split('#')[0].ToString() + "'";
        }
        if (cmbPurchase.SelectedIndex >= 0)
        {
            if (str != string.Empty)
                str = str + " and PRM.StoreID = '" + cmbPurchase.SelectedItem.Value + "'";
            else
                str = " where PRM.StoreID = '" + cmbPurchase.SelectedItem.Value + "'";
        }
        str = str + " AND prd.Status=2 AND PRM.Approved <>3 ";

        if (Util.GetString(ViewState["DeptLedgerNo"]) != Resources.Resource.PurchaseDeptLedgerNo)
            str = str + " AND  prd.Indent_Department='" + ViewState["DeptLedgerNo"].ToString() + "' ";

        return str;
    }

    #endregion Search Critaria
    protected void chkitem_CheckedChanged(object sender, EventArgs e)
    {
        if (chkitem.Checked)
            BindItem();
        else
        {
            lstItem.Items.Clear();
            lstItem.Items.Add("No Item Found");
        }
    }
}