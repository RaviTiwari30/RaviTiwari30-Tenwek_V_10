using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

public partial class Design_Kitchen_CanteenSearchSales : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
            BindItem();
            BindPanel();
            BindUser();
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtFromTime.Text = "00:00 AM";
            txtToTime.Text = "11:59 PM";
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }

    private void BindItem()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT DISTINCT(SD.ItemID),IM.Typename ItemName  FROM f_salesdetails SD INNER JOIN f_itemmaster IM ON IM.ItemID=Sd.ItemID WHERE DeptLedgerNo='" + Util.GetString(ViewState["DeptLedgerNo"]) + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlItem.DataSource = dt;
            ddlItem.DataTextField = "ItemName";
            ddlItem.DataValueField = "ItemID";
            ddlItem.DataBind();
            ddlItem.Items.Insert(0, new ListItem("Select"));
        }
        else
        {
            ddlItem.Items.Clear();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key8", "modelAlert('No Item Found');", true);
          //  lblMsg.Text = "No Item Found";
        }
    }

    private void BindUser()
    {
        string str = "SELECT CONCAT(em.Title,' ',em.Name)ename,em.EmployeeID FROM employee_master em";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlUser.DataSource = dt;
            ddlUser.DataTextField = "ename";
            ddlUser.DataValueField = "EmployeeID";
            ddlUser.DataBind();
            ddlUser.Items.Insert(0, new ListItem("Select", "0"));
        }
        else
        {
            ddlUser.Items.Clear();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key8", "modelAlert('NO user Found');", true);
            lblMsg.Text = "NO user Found";

        }
    }
    private void BindPanel()
    {
        DataTable dtPanel = LoadCacheQuery.loadAllPanel();
        if (dtPanel.Rows.Count > 0)
        {
            ddlPanel.DataSource = dtPanel;
            ddlPanel.DataTextField = "Company_Name";
            ddlPanel.DataValueField = "PanelID";
            ddlPanel.DataBind();
            ddlPanel.Items.Insert(0, new ListItem("All", "0"));
            ddlPanel.SelectedIndex = ddlPanel.Items.IndexOf(ddlPanel.Items.FindByValue("0"));
        }
    }

    private string Criteria()
    {
        string str = string.Empty;

        if (txtRegNo.Text.Trim() == string.Empty)
        {
            // Modify on 14-10-2019 - To correct the query
            // str = str + "and DATE(lt.Date)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(lt.Date)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ";
            // str = str + "and TIME(lt.Time)>='" + Util.GetDateTime(txtFromTime.Text).ToString("HH:mm:ss") + "' AND TIME(lt.Time)<='" + Util.GetDateTime(txtToTime.Text).ToString("HH:mm:ss") + "' ";
            str = str + "and lt.Date>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND lt.Date<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ";
            str = str + "and lt.Time>='" + Util.GetDateTime(txtFromTime.Text).ToString("HH:mm:ss") + "' AND lt.Time<='" + Util.GetDateTime(txtToTime.Text).ToString("HH:mm:ss") + "' ";
            //
        }
        if (ddlItem.SelectedIndex > 0)
            str = str + " and  LTD.ItemId='" + ddlItem.SelectedValue + "'";

        if (ddlType.SelectedIndex > 0)
            str = str + " and LT.TypeOfTnx='" + ddlType.SelectedValue + "'";

        if (ddlUser.SelectedIndex > 0)
            str = str + " and LT.UserID = '" + ddlUser.SelectedValue + "'";

        if ((rblCon.SelectedValue == "2") && (txtReceiptNo.Text.Trim() != ""))
            str = str + "AND rec.ReceiptNo='" + txtReceiptNo.Text.Trim() + "' ";
        else if ((rblCon.SelectedValue == "1") && (txtBillNo.Text.Trim() != ""))
            str = str + " AND lt.BillNo='" + txtBillNo.Text.Trim() + "' ";
        
        return str;
    }
    private void SearcSales()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT * FROM ( ");
        sb.Append("select LT.LedgerTransactionNo,LT.TransactionID Transaction_ID, round(LT.NetAmount,2)NetAmount,lt.GrossAmount,round(lt.Adjustment,2)Adjustment,");
        sb.Append("  date_format(LT.Date,'%d-%b-%Y')Date,IF(LT.TypeOfTnx='Canteen-Issue','Issue','Return')TypeOfTnx,'' AS TypeOfTnxCon,GROUP_CONCAT(ltd.itemname SEPARATOR '#')itemname, ");
        if (rblCon.SelectedValue == "2")
            sb.Append(" IF(lt.PaymentModeID=4,'',rec.ReceiptNo) ReceiptNo, ");
        else
            sb.Append(" IF(rec.ReceiptNo IS NULL,'',rec.ReceiptNo)ReceiptNo, ");
        sb.Append(" IF(pm.patientID<>'CASH003',pm.Pname,(SELECT NAME FROM patient_general_master ");
        sb.Append(" WHERE AgainstLedgerTnxNo=lt.LedgerTransactionNo))PName, IF(pm.patientID<>'CASH003',pm.age,(SELECT age FROM patient_general_master ");
        sb.Append(" WHERE AgainstLedgerTnxNo=lt.LedgerTransactionNo))age,CONCAT(PM.House_No,' ',PM.Street_Name,' ',PM.Locality,' ',PM.City)Address,'' CustomerID,pm.PatientID Patient_ID,LT.BillNo from f_ledgertransaction LT");
        if (rblCon.SelectedValue == "2")
        {
            sb.Append(" INNER JOIN f_reciept rec ON rec.AsainstLedgerTnxNo=lt.LedgerTransactionNo   ");
        }
        if (rblCon.SelectedValue == "1")
        {
            sb.Append(" LEFT JOIN f_reciept rec ON rec.AsainstLedgerTnxNo=lt.LedgerTransactionNo   ");
        }
        sb.Append(" INNER JOIN f_ledgertnxdetail LTD on LT.LedgerTransactionNo=LTD.LedgerTransactionNo ");
        sb.Append(" LEFT JOIN patient_master PM on LT.PatientID=PM.PatientID ");
        sb.Append(" INNER JOIN patient_medical_history pmh on LT.TransactionID = pmh.TransactionID   where LT.TypeOfTnx IN ('Canteen-Issue','Canteen-Return')");
        sb.Append(Criteria());
        if (txtRegNo.Text.Trim() != string.Empty)
            sb.Append(" and PM.PatientID = '" + txtRegNo.Text.Trim() + "' ");
        if (ddlPanel.SelectedIndex > 0)
            sb.Append(" and pmh.PanelID ='" + ddlPanel.SelectedValue + "' ");
        if (txtName.Text.Trim() != string.Empty)
            sb.Append(" and pm.PName LIKE '" + txtName.Text.Trim() + "%' ");
        if (rblCon.SelectedValue == "2")
            sb.Append(" and lt.PaymentModeID<>4");
        sb.Append(" AND lt.isCancel=0 AND lt.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' group by LT.LedgerTransactionNo ");

        if (rblCon.SelectedValue == "2")
        {
            sb.Append(" UNION ALL  ");
            sb.Append("  SELECT LT.LedgerTransactionNo,LT.TransactionID Transaction_ID, ROUND(LT.NetAmount,2)NetAmount,lt.GrossAmount,ROUND(lt.Adjustment,2)Adjustment,  ");
            sb.Append("  DATE_FORMAT(LT.Date,'%d-%b-%y')DATE,'Settlement' TypeOfTnx,CASE WHEN (ReceiptNo<>'' AND PaymentModeID=4) THEN 'Settlement'  ELSE lt.TypeOfTnx END AS TypeOfTnxCon,GROUP_CONCAT(ltd.itemname SEPARATOR '#')itemname,rec.ReceiptNo,  ");
            sb.Append("  IF(pm.patientID<>'CASH003',pm.Pname,(SELECT NAME FROM patient_general_master WHERE AgainstLedgerTnxNo=lt.LedgerTransactionNo))PName, IF(pm.patientID<>'CASH003',");
            sb.Append("  pm.age,(SELECT age FROM patient_general_master  WHERE AgainstLedgerTnxNo=lt.LedgerTransactionNo))age,");
            sb.Append("  CONCAT(PM.House_No,' ',PM.Street_Name,' ',PM.Locality,' ',PM.City)Address,'' CustomerID,pm.PatientID Patient_ID, ");
            sb.Append("  lt.BillNo FROM f_ledgertransaction LT INNER JOIN f_reciept rec  ON rec.AsainstLedgerTnxNo=lt.LedgerTransactionNo    INNER JOIN f_ledgertnxdetail LTD ");
            sb.Append("  ON LT.LedgerTransactionNo=LTD.LedgerTransactionNo  LEFT JOIN patient_master PM ON LT.PatientID=PM.PatientID  ");
            sb.Append("  INNER JOIN patient_medical_history pmh ON LT.TransactionID = pmh.TransactionID   ");
            sb.Append("  WHERE LT.TypeOfTnx IN ('Canteen-Issue','Canteen-Return') AND lt.isCancel=0 AND lt.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' ");
            sb.Append(Criteria());
            if (txtRegNo.Text.Trim() != string.Empty)
                sb.Append(" and PM.PatientID = '" + txtRegNo.Text.Trim() + "' ");
            if (ddlPanel.SelectedIndex > 0)
                sb.Append(" and pmh.PanelID ='" + ddlPanel.SelectedValue + "' ");
            if (txtName.Text.Trim() != string.Empty)
                sb.Append(" and pm.PName LIKE '" + txtName.Text.Trim() + "%' ");

            sb.Append("  AND ReceiptNo<>''  AND lt.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "'  GROUP BY lt.LedgerTransactionNo");//  AND (ReceiptNo<>'' AND PaymentModeID=4)
        }
        sb.Append(" )t");
        if (rblSearch.SelectedItem.Value == "Walk")
        {
            sb.Append(" where t.Patient_ID='CASH003' ");
        }
        if (rblSearch.SelectedItem.Value == "OPD")
        {
            sb.Append(" where t.Patient_ID<>'CASH003' ");
        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            grdCash.DataSource = dt;
            grdCash.DataBind();
        }
        else
        {
            grdCash.DataSource = null;
            grdCash.DataBind();

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('No record Found');", true);
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        SearcSales();
    }

    protected void grdCash_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        DataRowView row;
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            row = (DataRowView)e.Row.DataItem;
            e.Row.Attributes.Add("onMouseOver", "SetNewColor(this);");
            e.Row.Attributes.Add("onMouseOut", "SetOldColor(this);");

            // Add new on 29-06-2017 - For GST
            string isGSTStatus = Util.IsAfterGSTApply(Util.GetString(row["Date"]));

            if (Util.GetString(row["TypeOfTnx"]) == "Return")
            {
                e.Row.Attributes.Add("Style", "cursor:hand;background-color:#fafad2;");
                if (isGSTStatus == "1")
                    e.Row.Attributes.Add("ondblclick", "ShowPO('../Common/GSTCanteenReturnReceipt.aspx?LedTnxNo=" + Util.GetString(row["LedgerTransactionNo"]) + "&DeptLedgerNo=" + Session["DeptLedgerNo"].ToString() + "&Dublicate=1&OutID=" + StockReports.ExecuteScalar("SELECT sd.PatientID Patient_ID  FROM f_salesdetails sd INNER JOIN patient_general_master pgm ON pgm.`CustomerID`= sd.`PatientID` WHERE  sd.LedgerTransactionNo='" + Util.GetString(row["LedgerTransactionNo"]) + "' ") + "'); ");
					else
                    e.Row.Attributes.Add("ondblclick", "ShowPO('../Common/CanteenReturnReceipt.aspx?LedTnxNo=" + Util.GetString(row["LedgerTransactionNo"]) + "&DeptLedgerNo=" + Session["DeptLedgerNo"].ToString() + "&Dublicate=1&OutID=" + StockReports.ExecuteScalar("SELECT sd.PatientID Patient_ID FROM f_salesdetails sd INNER JOIN patient_general_master pgm ON pgm.`CustomerID`= sd.`PatientID` WHERE  sd.LedgerTransactionNo='" + Util.GetString(row["LedgerTransactionNo"]) + "' ") + "'); ");
			}
            else if (Util.GetString(row["TypeOfTnx"]) == "Issue")
            {
                e.Row.Attributes.Add("Style", "cursor:hand;background-color:#afeeee;");
                if (rblCon.SelectedValue == "1")
                    if (isGSTStatus == "1")
                          e.Row.Attributes.Add("ondblclick", "ShowPO('../Common/GSTCanteenReceipt.aspx?LedTnxNo=" + Util.GetString(row["LedgerTransactionNo"]) + "&DeptLedgerNo=" + Session["DeptLedgerNo"].ToString() + "&Duplicate=1&OutID=" + StockReports.ExecuteScalar("SELECT CustomerID FROM patient_general_master WHERE AgainstLedgerTnxNo='" + Util.GetString(row["LedgerTransactionNo"]) + "' ") + "&IsBill=" + 1 + "');");
                    else
                          e.Row.Attributes.Add("ondblclick", "ShowPO('../Common/CanteenReceipt.aspx?LedTnxNo=" + Util.GetString(row["LedgerTransactionNo"]) + "&DeptLedgerNo=" + Session["DeptLedgerNo"].ToString() + "&Duplicate=1&OutID=" + StockReports.ExecuteScalar("SELECT CustomerID FROM patient_general_master WHERE AgainstLedgerTnxNo='" + Util.GetString(row["LedgerTransactionNo"]) + "' ") + "&IsBill=" + 1 + "');");
                else
                    if (isGSTStatus == "1")
                        e.Row.Attributes.Add("ondblclick", "ShowPO('../Common/GSTCanteenReceipt.aspx?LedTnxNo=" + Util.GetString(row["LedgerTransactionNo"]) + "&DeptLedgerNo=" + Session["DeptLedgerNo"].ToString() + "&Duplicate=1&OutID=" + StockReports.ExecuteScalar("SELECT CustomerID FROM patient_general_master WHERE AgainstLedgerTnxNo='" + Util.GetString(row["LedgerTransactionNo"]) + "' ") + "&IsBill=" + 0 + "');");
                    else
                         e.Row.Attributes.Add("ondblclick", "ShowPO('../Common/CanteenReceipt.aspx?LedTnxNo=" + Util.GetString(row["LedgerTransactionNo"]) + "&DeptLedgerNo=" + Session["DeptLedgerNo"].ToString() + "&Duplicate=1&OutID=" + StockReports.ExecuteScalar("SELECT CustomerID FROM patient_general_master WHERE AgainstLedgerTnxNo='" + Util.GetString(row["LedgerTransactionNo"]) + "' ") + "&IsBill=" + 0 + "');");
            }
            else
            {
                e.Row.Attributes.Add("Style", "cursor:hand;background-color:pink");
                if (isGSTStatus == "1")
                    e.Row.Attributes.Add("ondblclick"," ");
			      // e.Row.Attributes.Add("ondblclick", "ShowPO('../Common/GSTCreditBillReceipt.aspx?LedgerTransactionNo=" + Util.GetString(row["LedgerTransactionNo"]) + "&DeptLedgerNo=" + Session["DeptLedgerNo"].ToString() + "&Duplicate=1&OutID=" + StockReports.ExecuteScalar("SELECT CustomerID FROM patient_general_master WHERE AgainstLedgerTnxNo='" + Util.GetString(row["LedgerTransactionNo"]) + "' ") + " &Type=Pharmacy');");
                else
                    e.Row.Attributes.Add("ondblclick", "ShowPO('../Common/CreditBillReceipt.aspx?LedgerTransactionNo=" + Util.GetString(row["LedgerTransactionNo"]) + "&DeptLedgerNo=" + Session["DeptLedgerNo"].ToString() + "&Duplicate=1&OutID=" + StockReports.ExecuteScalar("SELECT CustomerID FROM patient_general_master WHERE AgainstLedgerTnxNo='" + Util.GetString(row["LedgerTransactionNo"]) + "' ") + " &Type=Pharmacy');");
            }
        }
    }

    protected void btnReportDetail_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        if (rdoReportType.SelectedValue == "2")
        {
            sb.Append(" SELECT LT.NetAmount,LTD.ItemName,LTD.Rate,pnl.Company_Name,LTD.Quantity,LTD.Amount,IF(LT.TypeOfTnx='Canteen-Issue','Issue','Return')TypeOfTnx,LT.TransactionID Transaction_ID,PM.PatientID Patient_ID,PM.Pname,PM.Age,CONCAT(PM.House_No,' ',PM.Street_Name,' ',PM.Locality,' ',PM.City)Address,ST.BatchNumber,DATE_FORMAT(ST.MedExpiryDate,'%d-%b-%y')MedExpiry FROM f_ledgertransaction LT ");
            sb.Append(" INNER JOIN f_ledgertnxdetail LTD ON LT.LedgerTransactionNo=LTD.LedgerTransactionNo INNER JOIN f_stock ST ON LTD.StockID=ST.StockID INNER JOIN patient_master PM ON LT.PatientID=PM.PatientID INNER JOIN patient_medical_history pmh ON LT.TransactionID = pmh.TransactionID INNER JOIN f_panel_master pnl ON pmh.PanelID = pnl.PanelID WHERE LT.TypeOfTnx IN ('Canteen-Issue','Canteen-Return') AND lt.PatientID<>'CASH003'");
            sb.Append(Criteria());
            if (txtRegNo.Text.Trim() != string.Empty)
                sb.Append(" and PM.PatientID = '" + txtRegNo.Text.Trim() + "' ");
            sb.Append(" UNION ALL ");
            sb.Append("SELECT LT.NetAmount,LTD.ItemName,LTD.Rate,pnl.Company_Name,LTD.Quantity,LTD.Amount,IF(LT.TypeOfTnx='Canteen-Issue','Issue','Return')TypeOfTnx, ");
            sb.Append("LT.TransactionID Transaction_ID,pm.CustomerID,PM.Name,PM.Age,PM.Address,ST.BatchNumber, ");
            sb.Append("DATE_FORMAT(ST.MedExpiryDate,'%d-%b-%y')MedExpiry FROM f_ledgertransaction LT  ");
            sb.Append("INNER JOIN f_ledgertnxdetail LTD ON LT.LedgerTransactionNo=LTD.LedgerTransactionNo INNER JOIN f_stock ST  ");
            sb.Append("ON LTD.StockID=ST.StockID INNER JOIN patient_general_master PM ON LT.LedgerTransactionNo=pm.AgainstLedgerTnxNo  ");
            sb.Append("INNER JOIN f_panel_master pnl ON lt.PanelID = pnl.PanelID ");
            sb.Append("WHERE LT.TypeOfTnx IN ('Canteen-Issue') AND Lt.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' ");
            sb.Append(Criteria());
            if (txtRegNo.Text.Trim() != string.Empty)
                sb.Append(" and PM.CustomerID = '" + txtRegNo.Text.Trim() + "' ");

            sb.Append("UNION ALL  ");
            sb.Append("SELECT LT.NetAmount,LTD.ItemName,LTD.Rate,pnl.Company_Name,LTD.Quantity,LTD.Amount,IF(LT.TypeOfTnx='Canteen-Issue','Issue','Return')TypeOfTnx, ");
            sb.Append("LT.TransactionID Transaction_ID,pm.CustomerID,PM.Name,PM.Age,PM.Address,ST.BatchNumber, ");
            sb.Append("DATE_FORMAT(ST.MedExpiryDate,'%d-%b-%y')MedExpiry FROM f_ledgertransaction LT  ");
            sb.Append("INNER JOIN f_ledgertnxdetail LTD ON LT.LedgerTransactionNo=LTD.LedgerTransactionNo INNER JOIN f_stock ST  ");
            sb.Append("ON LTD.StockID=ST.StockID INNER JOIN f_salesdetails sd ON lt.LedgerTransactionNo = sd.LedgerTransactionNo AND ST.StockID = sd.StockID ");
            sb.Append("INNER JOIN patient_general_master PM ON sd.AgainstLedgerTnxNo=pm.AgainstLedgerTnxNo  ");
            sb.Append("INNER JOIN f_panel_master pnl ON lt.PanelID = pnl.PanelID  ");
            sb.Append("WHERE LT.TypeOfTnx IN ('Canteen-Return') AND Lt.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' ");
            sb.Append(Criteria());
            if (txtRegNo.Text.Trim() != string.Empty)
                sb.Append(" and PM.CustomerID = '" + txtRegNo.Text.Trim() + "' ");
        }
        else if (rdoReportType.SelectedValue == "1")
        {
            sb.Append(" SELECT  ");
            sb.Append(" LTD.ItemName,LTD.Rate,SUM(LTD.Amount)Amount ,SUM(LTD.Quantity)Quantity,LT. TypeOfTnx FROM ");
            sb.Append(" f_ledgertransaction LT INNER JOIN f_ledgertnxdetail LTD  ON LT.LedgerTransactionNo=LTD.LedgerTransactionNo ");
            sb.Append(" WHERE LT.TypeOfTnx IN ('Canteen-Issue','Canteen-Return')  AND Lt.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' ");
            sb.Append(Criteria());
            if (txtRegNo.Text.Trim() != string.Empty)
                sb.Append(" and LT.PatientID = '" + txtRegNo.Text.Trim() + "' ");
            sb.Append("GROUP BY LTd.ItemName");
        }

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            string Type = string.Empty;
            if (rdoReportType.SelectedValue == "2")
            {
                if (ddlType.SelectedValue == "Canteen-Issue")
                    Type = "Issue Report";
                else if (ddlType.SelectedValue == "Canteen-Return")
                    Type = "Return Report";
                else
                    Type = "Issue / Return Report";
            }

            DataColumn dc1 = new DataColumn();
            dc1.DefaultValue = Type;
            dc1.ColumnName = "Type";
            dt.Columns.Add(dc1);

            DataColumn dc = new DataColumn();
            dc.ColumnName = "SearchDate";
            dc.DefaultValue = "From : " + Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = Convert.ToString(Session["LoginName"]);
            dt.Columns.Add(dc);

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());

            Session["ds"] = ds;
            //ds.WriteXmlSchema(@"C:\amitdemo.xml");
            if (rdoReportType.SelectedValue == "2")
            {
                Session["ReportName"] = "CanteenSales";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../Common/Commonreport.aspx');", true);
            }
            else if (rdoReportType.SelectedValue == "1")
            {
                Session["ReportName"] = "CanteenItemwise";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../Common/Commonreport.aspx');", true);
            }
        }
        else
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key8", "modelAlert('No Record Found');", true);
       // lblMsg.Text = "No Record Found";

    }

}
