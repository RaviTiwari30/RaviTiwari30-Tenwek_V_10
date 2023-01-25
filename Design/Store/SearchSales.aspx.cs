using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Drawing;
using System.Web;

public partial class Design_Store_SearchSales : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindItem();
            BindPanel();
            BindUser();
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }
    private void BindItem()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT DISTINCT(SD.ItemID),IM.Typename ItemName  FROM f_salesdetails SD INNER JOIN f_itemmaster IM");
        sb.Append(" on IM.ItemID=Sd.ItemID where SD.DeptLedgerNo='" + Session["DeptLedgerNo"].ToString() + "' ORDER BY IM.Typename ");
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
            lblMsg.Text = "No Item Found";
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
            ddlUser.Items.Insert(0, new ListItem("All", "0"));
        }
        else
        {
            ddlUser.Items.Clear();
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
    private string Criteria(int rec)
    {
        string str = string.Empty;
        str = str + "and lt.CentreID>=" + Session["CentreID"].ToString() + " ";
        if (txtRegNo.Text.Trim() == string.Empty )
        {
            if(txtBillNo.Text != "")
            str = str + "and lt.Date>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND lt.Date<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ";
            else
                str = str + "and lt.Date>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND lt.Date<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ";

        }
        if (ddlItem.SelectedIndex > 0)
            str = str + " and  LTD.ItemId='" + ddlItem.SelectedValue + "'";

        if (ddlType.SelectedIndex > 0)
            str = str + " and LT.TypeOfTnx='" + ddlType.SelectedValue + "'";

        if (ddlUser.SelectedIndex > 0)
        {
            if (rec == 0)
                str = str + " and LT.UserID = '" + ddlUser.SelectedValue + "'";
            else
                str = str + " and rec.Reciever = '" + ddlUser.SelectedValue + "'";
        }
        if ((rblCon.SelectedValue == "2") && (txtReceiptNo.Text.Trim() != ""))
        {
             str = str + "AND rec.ReceiptNo='" + txtReceiptNo.Text.Trim() + "' ";
        }
        else if ((rblCon.SelectedValue == "1") && (txtBillNo.Text.Trim() != ""))
        {
             str = str + " AND lt.BillNo='" + txtBillNo.Text.Trim() + "' ";
        }

        return str;
    }
    private void SearcSales()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT * FROM ( ");
        sb.Append(" select pmh.CentreID,lt.IsLablePrint, ");

        sb.Append(" IF(lt.PanelID <> 1,IF(ROUND((lt.NetAmount-IFNULL((SELECT SUM(r.AmountPaid)    ");
        sb.Append("    FROM f_reciept r WHERE r.IsCancel=0 AND r.PaidBy='PAT' AND r.AsainstLedgerTnxNo=lt.LedgerTransactionNo),0)-IFNULL((SELECT SUM(Amount)   ");
        sb.Append("  FROM panel_amountallocation pa WHERE pa.TransactionID=lt.TransactionID),0)),0)=0,1,(SELECT IF( COUNT(ltdc.`ID`)>0,0,1) ");
        sb.Append(" FROM f_ledgertnxdetail ltdc WHERE ltdc.IsPaymentApproval=0 ");
        sb.Append(" AND ltdc.`LedgerTransactionNo`=lt.LedgerTransactionNo)), ");
        sb.Append(" IF(lt.NetAmount<=lt.Adjustment,1,(SELECT IF( COUNT(ltdc.`ID`)>0,0,1) ");
        sb.Append(" FROM f_ledgertnxdetail ltdc WHERE ltdc.IsPaymentApproval=0 ");
        sb.Append(" AND ltdc.`LedgerTransactionNo`=lt.LedgerTransactionNo)))  CanPrintLable, ");


        sb.Append(" IF(IFNULL(rec.ReceiptNo,'')='','Not Paid','Paid')PaymentStatus, (SELECT fpm.Company_Name FROM f_panel_master fpm WHERE fpm.Panelid=lt.PanelID)Panel, LT.LedgerTransactionNo,LT.TransactionID, round(LT.NetAmount,2)NetAmount,lt.GrossAmount,round(lt.Adjustment,2)Adjustment,");
        sb.Append("  date_format(LT.Date,'%d-%b-%Y')Date,IF(rec.ledgerNoDr='HOSP0005','Settlement', IF(LT.TypeOfTnx='Pharmacy-Issue','Issue','Return'))TypeOfTnx,'' AS TypeOfTnxCon, ");
        if (rblCon.SelectedValue == "2")
            sb.Append(" IF(lt.PaymentModeID=4,'',rec.ReceiptNo) ReceiptNo, ");
        else
            sb.Append(" IF(rec.ReceiptNo IS NULL,'',rec.ReceiptNo)ReceiptNo, ");
        sb.Append(" IF(pm.PatientID<>'CASH002',pm.Pname,(SELECT NAME FROM patient_general_master ");
        sb.Append(" WHERE AgainstLedgerTnxNo=lt.LedgerTransactionNo))PName, IF(pm.PatientID<>'CASH002',pm.age,(SELECT age FROM patient_general_master ");
        sb.Append(" WHERE AgainstLedgerTnxNo=lt.LedgerTransactionNo))age,CONCAT(PM.House_No,' ',PM.Street_Name,' ',PM.Locality,' ',PM.City)Address,'' CustomerID,pmh.PatientID,LT.BillNo");
        sb.Append(",IF(pm.PatientID<>'CASH002',pm.`Mobile`,(SELECT ContactNo FROM patient_general_master  WHERE AgainstLedgerTnxNo=lt.LedgerTransactionNo))Mobile ");
        sb.Append("from f_ledgertransaction LT");
        if (rblCon.SelectedValue == "2")
        {
            sb.Append(" INNER JOIN f_reciept rec ON rec.AsainstLedgerTnxNo=lt.LedgerTransactionNo  AND rec.ledgerNoDr<>'HOSP0005' ");
        }
        if (rblCon.SelectedValue == "1")
        {
            sb.Append(" LEFT JOIN f_reciept rec ON rec.AsainstLedgerTnxNo=lt.LedgerTransactionNo   ");
        }
        sb.Append(" INNER JOIN f_ledgertnxdetail LTD on LT.LedgerTransactionNo=LTD.LedgerTransactionNo ");


        sb.Append(" LEFT JOIN patient_master PM on LT.PatientID=PM.PatientID ");
        sb.Append(" INNER JOIN patient_medical_history pmh on lt.TransactionID = pmh.TransactionID   where LT.TypeOfTnx IN ('Pharmacy-Issue','Pharmacy-Return')");
        sb.Append(Criteria(0));
        if (txtRegNo.Text.Trim() != string.Empty)
            sb.Append(" and PM.PatientID = '" +txtRegNo.Text.Trim() + "' ");
        if (ddlPanel.SelectedIndex > 0)
            sb.Append(" and pmh.PanelID =" + ddlPanel.SelectedValue + " ");
        if (txtName.Text.Trim() != string.Empty)
            sb.Append(" and pm.PName LIKE '" + txtName.Text.Trim() + "%' ");
        if (rblCon.SelectedValue == "2")
            sb.Append(" and lt.PaymentModeID<>4");
        sb.Append(" AND IFNULL(lt.`AsainstLedgerTnxNo`,'')='' AND lt.isCancel=0 AND lt.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "'  and lt.isOTCollection=0 ");
        sb.Append(" GROUP BY lt.LedgerTransactionNo ,rec.ReceiptNo");
        if (rblCon.SelectedValue == "2")
        {
            sb.Append(" UNION ALL  ");
            sb.Append("  SELECT pmh.CentreID,lt.IsLablePrint,");

            sb.Append(" IF(lt.PanelID <> 1,IF(ROUND((lt.NetAmount-IFNULL((SELECT SUM(r.AmountPaid)    ");
            sb.Append("    FROM f_reciept r WHERE r.IsCancel=0 AND r.PaidBy='PAT' AND r.AsainstLedgerTnxNo=lt.LedgerTransactionNo),0)-IFNULL((SELECT SUM(Amount)   ");
            sb.Append("  FROM panel_amountallocation pa WHERE pa.TransactionID=lt.TransactionID),0)),0)=0,1,(SELECT IF( COUNT(ltdc.`ID`)>0,0,1) ");
            sb.Append(" FROM f_ledgertnxdetail ltdc WHERE ltdc.IsPaymentApproval=0 ");
            sb.Append(" AND ltdc.`LedgerTransactionNo`=lt.LedgerTransactionNo)), ");
            sb.Append(" IF(lt.NetAmount=lt.Adjustment,1,(SELECT IF( COUNT(ltdc.`ID`)>0,0,1) ");
            sb.Append(" FROM f_ledgertnxdetail ltdc WHERE ltdc.IsPaymentApproval=0 ");
            sb.Append(" AND ltdc.`LedgerTransactionNo`=lt.LedgerTransactionNo)))  CanPrintLable, ");

            sb.Append(" IF(IFNULL(rec.ReceiptNo,'')='','Not Paid','Paid')PaymentStatus, (SELECT fpm.Company_Name FROM f_panel_master fpm WHERE fpm.Panelid=lt.PanelID)Panel, LT.LedgerTransactionNo,LT.TransactionID, ROUND(LT.NetAmount,2)NetAmount,lt.GrossAmount,ROUND(lt.Adjustment,2)Adjustment,  ");
            sb.Append("  DATE_FORMAT(rec.Date,'%d-%b-%y')DATE,'Settlement' TypeOfTnx,CASE WHEN (rec.ReceiptNo<>'' AND PaymentModeID=4) THEN 'Settlement'  ELSE lt.TypeOfTnx END AS TypeOfTnxCon,rec.ReceiptNo,  ");
            sb.Append("  IF(pm.PatientID<>'CASH002',pm.Pname,(SELECT NAME FROM patient_general_master   WHERE AgainstLedgerTnxNo=lt.LedgerTransactionNo))PName, IF(pm.PatientID<>'CASH002',");
            sb.Append("  pm.age,(SELECT age FROM patient_general_master  WHERE AgainstLedgerTnxNo=lt.LedgerTransactionNo))age,");
            sb.Append("  CONCAT(PM.House_No,' ',PM.Street_Name,' ',PM.Locality,' ',PM.City)Address,'' CustomerID,pm.PatientID, ");
            sb.Append("  lt.BillNo");
            sb.Append(",IF(pm.PatientID<>'CASH002',pm.`Mobile`,(SELECT ContactNo FROM patient_general_master  WHERE AgainstLedgerTnxNo=lt.LedgerTransactionNo))Mobile FROM f_ledgertransaction LT ");
           // sb.Append("  INNER JOIN f_patientaccount acc ON acc.LedgerTransactionNo=lt.LedgerTransactionNo     ");
           // sb.Append("  INNER JOIN f_reciept rec ON acc.ReceiptNo=rec.ReceiptNo   ");
            sb.Append("  INNER JOIN f_reciept rec ON rec.AsainstLedgerTnxNo = lt.LedgertransactionNo  ");
            sb.Append(" INNER JOIN f_ledgertnxdetail LTD ON LT.LedgerTransactionNo=LTD.LedgerTransactionNo  LEFT JOIN patient_master PM ON LT.PatientID=PM.PatientID  ");
            sb.Append("  INNER JOIN patient_medical_history pmh ON lt.TransactionID = pmh.TransactionID   ");
            sb.Append("  WHERE LT.TypeOfTnx IN ('Pharmacy-Issue','Pharmacy-Return') AND lt.isCancel=0  AND rec.isCancel=0 ");
            // sb.Append("  AND acc.IsAdvanceAmt=1 ");
            sb.Append("  AND rec.ledgerNoDr='HOSP0005' and lt.isOTCollection=0 and rec.isOTCollection=0 ");
            sb.Append(Criteria(1));
            if (txtRegNo.Text.Trim() != string.Empty)
                sb.Append(" and PM.PatientID = '" +txtRegNo.Text.Trim() + "' ");
            if (ddlPanel.SelectedIndex > 0)
                sb.Append(" and pmh.PanelID =" + ddlPanel.SelectedValue + " ");
            if (txtName.Text.Trim() != string.Empty)
                sb.Append(" and pm.PName LIKE '" + txtName.Text.Trim() + "%' ");



            sb.Append(" AND IFNULL(lt.`AsainstLedgerTnxNo`,'')='' AND lt.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "'  GROUP BY lt.LedgerTransactionNo,rec.ReceiptNo ");
        }
        sb.Append(" )t where t.CentreID = " + HttpContext.Current.Session["CentreID"].ToString() + " ");
        if (rblSearch.SelectedItem.Value == "Walk")
        {
            sb.Append(" And t.PatientID='CASH002' ");
            if (txtMobile.Text.Trim() != string.Empty)
            {
                sb.Append(" AND t.Mobile='" + txtMobile.Text.Trim() + "'");
            }
        }
        if (rblSearch.SelectedItem.Value == "OPD")
        {
            sb.Append(" And  t.PatientID<>'CASH002' ");
            if (txtMobile.Text.Trim() != string.Empty)
            {
                sb.Append(" AND t.Mobile='" + txtMobile.Text.Trim() + "'");
            }
        }
        if (rblSearch.SelectedItem.Value == "ALL")
        {
            if (txtMobile.Text.Trim() != string.Empty)
            {
                sb.Append(" And t.Mobile='" + txtMobile.Text.Trim() + "' ");
            }
        }
        sb.Append(" ORDER BY t.BillNo DESC ");
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
           
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
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
            e.Row.Attributes.Add("ondblclick", "ShowPO('" + Util.GetString(row["LedgerTransactionNo"]) + "'); ");
            if (Util.GetInt(row["IsLablePrint"]) == 1)
            {
                e.Row.BackColor = Color.FromName("rgb(14 184 66 / 53%)");
                           
            }
           
            
            //if (Util.GetString(row["TypeOfTnx"]) == "Return")
            //{
            //    e.Row.Attributes.Add("Style", "cursor:hand;background-color:#fafad2;");
            //    if (Util.GetDateTime(row["Date"]) >= Util.GetDateTime("7/1/2017 12:00:00 AM"))
            //        e.Row.Attributes.Add("ondblclick", "ShowPO('../Common/GSTPharmacyReturnReceipt.aspx?LedTnxNo=" + Util.GetString(row["LedgerTransactionNo"]) + "&DeptLedgerNo=" + Session["DeptLedgerNo"].ToString() + "&Dublicate=1&OutID=" + StockReports.ExecuteScalar("SELECT sd.PatientID FROM f_salesdetails sd INNER JOIN patient_general_master pgm ON pgm.`CustomerID`= sd.`PatientID` WHERE  sd.LedgerTransactionNo='" + Util.GetString(row["LedgerTransactionNo"]) + "' ") + "'); ");
            //    else
            //        e.Row.Attributes.Add("ondblclick", "ShowPO('../Common/PharmacyReturnReceipt.aspx?LedTnxNo=" + Util.GetString(row["LedgerTransactionNo"]) + "&DeptLedgerNo=" + Session["DeptLedgerNo"].ToString() + "&Dublicate=1&OutID=" + StockReports.ExecuteScalar("SELECT sd.PatientID FROM f_salesdetails sd INNER JOIN patient_general_master pgm ON pgm.`CustomerID`= sd.`PatientID` WHERE  sd.LedgerTransactionNo='" + Util.GetString(row["LedgerTransactionNo"]) + "' ") + "'); ");

            //}
            //else if (Util.GetString(row["TypeOfTnx"]) == "Issue")
            //{
            //    e.Row.Attributes.Add("Style", "cursor:hand;background-color:#afeeee;");
            //    if (rblCon.SelectedValue == "1")
            //    {
            //        if (Util.GetDateTime(row["Date"]) >= Util.GetDateTime("7/1/2017 12:00:00 AM"))
            //            e.Row.Attributes.Add("ondblclick", "ShowPO('../Common/GSTPharmacyReceipt.aspx?LedTnxNo=" + Util.GetString(row["LedgerTransactionNo"]) + "&ReceiptNo=" + row["ReceiptNo"] + "&DeptLedgerNo=" + ViewState["DeptLedgerNo"].ToString() + "&Duplicate=1&OutID=" + StockReports.ExecuteScalar("SELECT CustomerID FROM patient_general_master WHERE AgainstLedgerTnxNo='" + Util.GetString(row["LedgerTransactionNo"]) + "' ") + "&IsBill=" + 1 + "');");
            //        else
            //            e.Row.Attributes.Add("ondblclick", "ShowPO('../Common/PharmacyReceipt.aspx?LedTnxNo=" + Util.GetString(row["LedgerTransactionNo"]) + "&ReceiptNo=" + row["ReceiptNo"] + "&DeptLedgerNo=" + ViewState["DeptLedgerNo"].ToString() + "&Duplicate=1&OutID=" + StockReports.ExecuteScalar("SELECT CustomerID FROM patient_general_master WHERE AgainstLedgerTnxNo='" + Util.GetString(row["LedgerTransactionNo"]) + "' ") + "&IsBill=" + 1 + "');");

            //    }
            //    else
            //    {
            //        if (Util.GetDateTime(row["Date"]) >= Util.GetDateTime("7/1/2017 12:00:00 AM"))
            //            e.Row.Attributes.Add("ondblclick", "ShowPO('../Common/GSTPharmacyReceipt.aspx?LedTnxNo=" + Util.GetString(row["LedgerTransactionNo"]) + "&ReceiptNo=" + row["ReceiptNo"] + "&DeptLedgerNo=" + ViewState["DeptLedgerNo"].ToString() + "&Duplicate=1&OutID=" + StockReports.ExecuteScalar("SELECT CustomerID FROM patient_general_master WHERE AgainstLedgerTnxNo='" + Util.GetString(row["LedgerTransactionNo"]) + "' ") + "&IsBill=" + 0 + "');");
            //        else
            //            e.Row.Attributes.Add("ondblclick", "ShowPO('../Common/PharmacyReceipt.aspx?LedTnxNo=" + Util.GetString(row["LedgerTransactionNo"]) + "&ReceiptNo=" + row["ReceiptNo"] + "&DeptLedgerNo=" + ViewState["DeptLedgerNo"].ToString() + "&Duplicate=1&OutID=" + StockReports.ExecuteScalar("SELECT CustomerID FROM patient_general_master WHERE AgainstLedgerTnxNo='" + Util.GetString(row["LedgerTransactionNo"]) + "' ") + "&IsBill=" + 0 + "');");
            //    }
            //}
            //else if (Util.GetString(row["TypeOfTnx"]) == "Settlement")
            //{
            //    e.Row.Attributes.Add("Style", "cursor:hand;background-color:pink");
            //    e.Row.Attributes.Add("ondblclick", "ShowPO('../Common/ReceiptOPD.aspx?ReceiptNo=" + row["ReceiptNo"] + "&TransactionID=" + Util.GetString(row["TransactionID"]) + "&DeptLedgerNo=" + ViewState["DeptLedgerNo"].ToString() + "&Duplicate=1&OutID=" + StockReports.ExecuteScalar("SELECT CustomerID FROM patient_general_master WHERE AgainstLedgerTnxNo='" + Util.GetString(row["LedgerTransactionNo"]) + "' ") + " &Type=Pharmacy');");

            //}
            //else
            //{
            //    e.Row.Attributes.Add("Style", "cursor:hand;background-color:pink");
            //    //e.Row.Attributes.Add("ondblclick", "ShowPO('../Common/CreditBillReceipt.aspx?LedgerTransactionNo=" + Util.GetString(row["LedgerTransactionNo"]) + "&DeptLedgerNo=" + ViewState["DeptLedgerNo"].ToString() + "&Duplicate=1&OutID=" + StockReports.ExecuteScalar("SELECT CustomerID FROM patient_general_master WHERE AgainstLedgerTnxNo='" + Util.GetString(row["LedgerTransactionNo"]) + "' ") + " &Type=Pharmacy');");
            //    if (Util.GetDateTime(row["Date"]) >= Util.GetDateTime("7/1/2017 12:00:00 AM"))
            //        e.Row.Attributes.Add("ondblclick", "ShowPO('../Common/GSTPharmacyReceipt.aspx?LedTnxNo=" + Util.GetString(row["LedgerTransactionNo"]) + "&DeptLedgerNo=" + ViewState["DeptLedgerNo"].ToString() + "&Duplicate=1&OutID=" + StockReports.ExecuteScalar("SELECT CustomerID FROM patient_general_master WHERE AgainstLedgerTnxNo='" + Util.GetString(row["LedgerTransactionNo"]) + "' ") + "&IsBill=" + 0 + "');");
            //    else
            //        e.Row.Attributes.Add("ondblclick", "ShowPO('../Common/PharmacyReceipt.aspx?LedTnxNo=" + Util.GetString(row["LedgerTransactionNo"]) + "&DeptLedgerNo=" + ViewState["DeptLedgerNo"].ToString() + "&Duplicate=1&OutID=" + StockReports.ExecuteScalar("SELECT CustomerID FROM patient_general_master WHERE AgainstLedgerTnxNo='" + Util.GetString(row["LedgerTransactionNo"]) + "' ") + "&IsBill=" + 0 + "');");

            //}
        }
    }

    protected void btnReportDetail_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        if (rdoReportType.SelectedValue == "2")
        {
            //sb.Append("select (if((round((LT.NetAmount),2)-FLOOR((LT.NetAmount)))=0.5,ceil((LT.NetAmount)),round(LT.NetAmount))) NetAmount,LTD.ItemName,LTD.Rate,pnl.Company_Name,LTD.Quantity,if((round((LTD.Amount),2)-FLOOR((LTD.Amount)))=0.5,ceil((LTD.Amount)),round(LTD.Amount))Amount,if(LT.TypeOfTnx='Sales','Issue','Return')TypeOfTnx,LT.TransactionID,PM.Pname,PM.Age,concat(PM.House_No,' ',PM.Street_Name,' ',PM.Locality,' ',PM.City)Address,ST.BatchNumber,date_format(ST.MedExpiryDate,'%d-%b-%y')MedExpiry,LT.Narration from ph_ledgertransaction LT");
            sb.Append(" SELECT LT.NetAmount,LTD.ItemName,LTD.Rate,pnl.Company_Name,LTD.Quantity,LTD.Amount,IF(LT.TypeOfTnx='Pharmacy-Issue','Issue','Return')TypeOfTnx,LT.TransactionID,PM.PatientID,PM.Pname,PM.Age,CONCAT(PM.House_No,' ',PM.Street_Name,' ',PM.Locality,' ',PM.City)Address,ST.BatchNumber,DATE_FORMAT(ST.MedExpiryDate,'%d-%b-%y')MedExpiry FROM f_ledgertransaction LT ");
            sb.Append(" INNER JOIN f_ledgertnxdetail LTD ON LT.LedgerTransactionNo=LTD.LedgerTransactionNo INNER JOIN f_stock ST ON LTD.StockID=ST.StockID INNER JOIN patient_master PM ON LT.PatientID=PM.PatientID INNER JOIN patient_medical_history pmh ON lt.TransactionID = pmh.TransactionID INNER JOIN f_panel_master pnl ON pmh.PanelID = pnl.PanelID WHERE LT.TypeOfTnx IN ('Pharmacy-Issue','Pharmacy-Return') AND lt.PatientID<>'CASH002'");
            sb.Append(Criteria(1));
            if (txtRegNo.Text.Trim() != string.Empty)
                sb.Append(" and PM.PatientID = '" + txtRegNo.Text.Trim() + "' ");
            sb.Append(" UNION ALL ");
            sb.Append("SELECT LT.NetAmount,LTD.ItemName,LTD.Rate,pnl.Company_Name,LTD.Quantity,LTD.Amount,IF(LT.TypeOfTnx='Pharmacy-Issue','Issue','Return')TypeOfTnx, ");
            sb.Append("LT.TransactionID,pm.CustomerID,PM.Name,PM.Age,PM.Address,ST.BatchNumber, ");
            sb.Append("DATE_FORMAT(ST.MedExpiryDate,'%d-%b-%y')MedExpiry FROM f_ledgertransaction LT  ");
            sb.Append("INNER JOIN f_ledgertnxdetail LTD ON LT.LedgerTransactionNo=LTD.LedgerTransactionNo INNER JOIN f_stock ST  ");
            sb.Append("ON LTD.StockID=ST.StockID INNER JOIN patient_general_master PM ON LT.LedgerTransactionNo=pm.AgainstLedgerTnxNo  ");
            sb.Append("INNER JOIN f_panel_master pnl ON lt.PanelID = pnl.PanelID ");
            sb.Append("WHERE LT.TypeOfTnx IN ('Pharmacy-Issue') ");
            sb.Append(Criteria(1));
            if (txtRegNo.Text.Trim() != string.Empty)
                sb.Append(" and PM.CustomerID = '" + txtRegNo.Text.Trim() + "' ");

            sb.Append("UNION ALL  ");
            sb.Append("SELECT LT.NetAmount,LTD.ItemName,LTD.Rate,pnl.Company_Name,LTD.Quantity,LTD.Amount,IF(LT.TypeOfTnx='Pharmacy-Issue','Issue','Return')TypeOfTnx, ");
            sb.Append("LT.TransactionID,pm.CustomerID,PM.Name,PM.Age,PM.Address,ST.BatchNumber, ");
            sb.Append("DATE_FORMAT(ST.MedExpiryDate,'%d-%b-%y')MedExpiry FROM f_ledgertransaction LT  ");
            sb.Append("INNER JOIN f_ledgertnxdetail LTD ON LT.LedgerTransactionNo=LTD.LedgerTransactionNo INNER JOIN f_stock ST  ");
            sb.Append("ON LTD.StockID=ST.StockID INNER JOIN f_salesdetails sd ON lt.LedgerTransactionNo = sd.LedgerTransactionNo AND ST.StockID = sd.StockID ");
            sb.Append("INNER JOIN patient_general_master PM ON sd.AgainstLedgerTnxNo=pm.AgainstLedgerTnxNo  ");
            sb.Append("INNER JOIN f_panel_master pnl ON lt.PanelID = pnl.PanelID  ");
            sb.Append("WHERE LT.TypeOfTnx IN ('Pharmacy-Return') ");
            sb.Append(Criteria(1));
            if (txtRegNo.Text.Trim() != string.Empty)
                sb.Append(" and PM.CustomerID = '" + txtRegNo.Text.Trim() + "' ");
        }
        else if (rdoReportType.SelectedValue == "1")
        {
            sb.Append(" SELECT  ");
            sb.Append(" LTD.ItemName,LTD.Rate,SUM(LTD.Amount)Amount ,SUM(LTD.Quantity)Quantity,LT. TypeOfTnx FROM ");
            sb.Append(" f_ledgertransaction LT INNER JOIN f_ledgertnxdetail LTD  ON LT.LedgerTransactionNo=LTD.LedgerTransactionNo ");
            sb.Append(" WHERE LT.TypeOfTnx IN ('Pharmacy-Issue','Pharmacy-Return')  ");
            sb.Append(Criteria(0));
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
                if (ddlType.SelectedValue == "Pharmacy-Issue")
                    Type = "Patient Wise Issue Report";
                else if (ddlType.SelectedValue == "Pharmacy-Return")
                    Type = "Patient Wise Return Report";
                else
                    Type = "Patient Wise Issue / Return Report";
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
                Session["ReportName"] = "Sales";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../Common/Commonreport.aspx');", true);
            }
            else if (rdoReportType.SelectedValue == "1")
            {
                Session["ReportName"] = "Itemwise";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../Common/Commonreport.aspx');", true);
            }


        }
        else
            lblMsg.Text = "No Record Found";
    }

}
