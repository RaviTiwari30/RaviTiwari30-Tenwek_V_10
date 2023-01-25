using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Store_IpdSearchSales : System.Web.UI.Page
{

    protected void btnReportDetail_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        if (rdoReportType.SelectedValue == "2")
        {
            sb.Append(" SELECT LT.NetAmount,LTD.ItemName,LTD.Rate,pnl.Company_Name,LTD.Quantity,LTD.Amount,IF(LT.TypeOfTnx='Sales','Issue','Return')TypeOfTnx,LT.TransactionID,PM.PatientID,PM.Pname,PM.Age,CONCAT(PM.House_No,' ',PM.Street_Name,' ',PM.Locality,' ',PM.City)Address,ST.BatchNumber,DATE_FORMAT(ST.MedExpiryDate,'%d-%b-%y')MedExpiry FROM f_ledgertransaction LT ");
            sb.Append(" INNER JOIN f_ledgertnxdetail LTD ON LT.LedgerTransactionNo=LTD.LedgerTransactionNo INNER JOIN f_stock ST ON LTD.StockID=ST.StockID INNER JOIN patient_master PM ON LT.PatientID=PM.PatientID INNER JOIN patient_medical_history pmh ON lt.TransactionID = pmh.TransactionID INNER JOIN f_panel_master pnl ON pmh.PanelID = pnl.PanelID WHERE LT.TypeOfTnx IN ('Sales','Patient-Return') ");
            sb.Append(Criteria());
            if (txtRegNo.Text.Trim() != string.Empty)
                sb.Append(" and PM.PatientID = '" + txtRegNo.Text.Trim() + "' ");
        }
        else if (rdoReportType.SelectedValue == "1")
        {
            sb.Append(" SELECT LT.LedgerTransactionNo,LT.BillNo,DATE_FORMAT(LT.Date,'%d-%b-%y')IssueDate ,ROUND(LT.NetAmount,2)NetAmount ");
            sb.Append(" ,LTD.ItemName,LTD.Rate,SUM(LTD.Amount)Amount ,SUM(LTD.Quantity)Quantity,LT.TypeOfTnx FROM ");
            sb.Append(" f_ledgertransaction LT INNER JOIN f_ledgertnxdetail LTD  ON LT.LedgerTransactionNo=LTD.LedgerTransactionNo ");
            sb.Append(" WHERE LT.TypeOfTnx IN ('Sales','Patient-Return') AND  LT.IsCancel = 0 ");
            sb.Append(Criteria());
            if (txtRegNo.Text.Trim() != string.Empty)
                sb.Append(" and PM.PatientID = '" + Util.GetFullPatientID(txtRegNo.Text.Trim()) + "' ");
            sb.Append("GROUP BY LTd.ItemName");

        }

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            string Type = string.Empty;
            if (rdoReportType.SelectedValue == "2")
            {
                if (ddlType.SelectedValue == "Sales")
                    Type = "Ipd Patient Issue Report";
                else if (ddlType.SelectedValue == "Patient-Return")
                    Type = "Ipd Patient Return Report";
                else
                    Type = "Ipd Patient Issue / Return Report";
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
            if (Util.GetString(row["TypeOfTnx"]) != "Patient-Issue")
            {
                if (Util.GetString(row["TypeOfTnx"]) != "Emergency")
                {
                    e.Row.Attributes.Add("Style", "cursor:hand;background-color:#fafad2;");
                    e.Row.Attributes.Add("ondblclick", "ShowPO('../Common/CommonPrinterOPDThermal.aspx?LedgerTransactionNo=" + Util.GetString(row["LedgerTransactionNo"]) + "&DeptLedgerNo=" + Util.GetString(row["DeptLedgerNo"]) + "&IsBill=1&Duplicate=0&Type=PHY');");

                }
            }
            else
            {
                e.Row.Attributes.Add("Style", "cursor:hand;background-color:#afeeee;");
                // e.Row.Attributes.Add("ondblclick", "ShowPO('../Store/InternalStockTransferPatientRecipt.aspx?billno=" + Util.GetString(row["BillNo"]) + "&typeOftnx=Patient-Return&TID=" + "ISHHI" + Util.GetString(row["TransactionID"]) + "');");

                e.Row.Attributes.Add("ondblclick", "ShowPO('../Common/CommonPrinterOPDThermal.aspx?LedgerTransactionNo=" + Util.GetString(row["LedgerTransactionNo"]) + "&DeptLedgerNo=" + Util.GetString(row["DeptLedgerNo"]) + "&IsBill=1&Duplicate=0&Type=PHY');");
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindItem();
            BindPanel();
            BindUser();
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }

    private void BindItem()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT DISTINCT(SD.ItemID),IM.Typename ItemName  FROM f_salesdetails SD INNER JOIN f_itemmaster IM");
        sb.Append(" on IM.ItemID=Sd.ItemID  ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlItem.DataSource = dt;
            ddlItem.DataTextField = "ItemName";
            ddlItem.DataValueField = "ItemID";
            ddlItem.DataBind();
            ddlItem.Items.Insert(0, new ListItem("-------"));
        }
        else
        {
            ddlItem.Items.Clear();
            lblMsg.Text = "No Item Found";
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
            // ddlPanel.SelectedIndex = ddlPanel.Items.IndexOf(ddlPanel.Items.FindByValue("1"));
            ddlPanel.Items.Insert(0, new ListItem("All"));
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
            ddlUser.Items.Insert(0, new ListItem("--------", "0"));
        }
        else
        {
            ddlUser.Items.Clear();
            lblMsg.Text = "NO user Found";
        }
    }

    private string Criteria()
    {
        string str = string.Empty;

        str = str + " AND lt.CentreID=" + Session["CentreID"].ToString() + " AND lt.Date>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND lt.Date<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ";

        if (ddlItem.SelectedIndex > 0)
            str = str + " and  LTD.ItemId='" + ddlItem.SelectedValue + "'";

        if (ddlType.SelectedIndex > 0)
            str = str + " and LT.TypeOfTnx='" + ddlType.SelectedValue + "'";

        if (txtIPDNo.Text.Trim() != string.Empty)
            str = str + " and lt.TransactionID = '" + StockReports.getTransactionIDbyTransNo(txtIPDNo.Text.Trim()) + "'";

        if (ddlUser.SelectedIndex > 0)
            str = str + " and LT.UserID = '" + ddlUser.SelectedValue + "'";

        return str;
    }

    private void SearcSales()
    {
        StringBuilder sb = new StringBuilder();
        //sb.Append("select IF(lt.PanelID<>1,1,IF(IFNULL(rec.ReceiptNo,'')='',0,1))CanPrintLable, ");
        sb.Append("select ( SELECT CONCAT(title,' ', NAME) FROM Employee_master em WHERE em.employeeid=ltd.userid) Dispenser,1 CanPrintLable,IFNULL(lt.IndentNo,'')IndentNo,LT.DeptLedgerNo, LT.LedgerTransactionNo,pmh.TransNo as TransactionID, round(LT.NetAmount,2)Netamount,lt.GrossAmount,date_format(LT.Date,'%d-%b-%y')Date,(case when LT.TypeOfTnx='Sales' then 'Patient-Issue' when LT.TypeOfTnx='Patient-Return' then 'Patient Return' end)TypeOfTnx,PM.Pname,PM.Age,concat(PM.House_No,' ',PM.Street_Name,' ',PM.Locality,' ',PM.City)Address,'' CustomerID,pm.PatientID,LT.BillNo from f_ledgertransaction LT");
        sb.Append(" LEFT OUTER JOIN f_reciept rec ON rec.AsainstLedgerTnxNo=lt.LedgerTransactionNo   ");
        sb.Append(" inner join f_ledgertnxdetail LTD on LT.LedgerTransactionNo=LTD.LedgerTransactionNo inner join f_stock ST on LTD.StockID=ST.StockID INNER JOIN f_salesdetails sd ON sd.LedgerTransactionNo=ltd.LedgerTransactionNo AND ltd.`ID`=sd.ledgertnxno  inner join patient_master PM on LT.PatientID=PM.PatientID inner join patient_medical_history pmh on lt.TransactionID = pmh.TransactionID where LT.TypeOfTnx IN ('Sales','Patient-Return') AND lt.DeptLedgerNo='" + Session["DeptLedgerNo"].ToString() + "'  ");
        sb.Append(Criteria());
        if (txtRegNo.Text.Trim() != string.Empty)
            sb.Append(" and PM.PatientID = '" + txtRegNo.Text.Trim() + "' ");
        if (ddlPanel.SelectedIndex > 0)
            sb.Append(" and pmh.PanelID =" + ddlPanel.SelectedValue + " ");
        if (txtName.Text.Trim() != string.Empty)
            sb.Append(" and PM.PName LIKE '" + txtName.Text.Trim() + "%' ");
        sb.Append(" group by LT.LedgerTransactionNo");
        sb.Append(" union All SELECT ( SELECT CONCAT(title,' ', NAME) FROM Employee_master em WHERE em.employeeid=ltd.userid) Dispenser,1 CanPrintLable,IFNULL(sd.IndentNo,'')IndentNo,LTD.DeptLedgerNo, LT.LedgerTransactionNo,pmh.TransNo AS TransactionID,   ");
        sb.Append(" ROUND(SUM(LTD.Amount),2)Netamount,ROUND(SUM(ltd.GrossAmount),2) GrossAmount,DATE_FORMAT(LTD.EntryDate,'%d-%b-%y')DATE,  ");
        sb.Append(" LT.TypeOfTnx TypeOfTnx,PM.Pname,PM.Age,  ");
        sb.Append(" CONCAT(PM.House_No,' ',PM.Street_Name,' ',PM.Locality,' ',PM.City)Address,'' CustomerID,pm.PatientID,lt.BillNo   ");
        sb.Append(" FROM f_ledgertransaction LT   ");
        sb.Append(" LEFT OUTER JOIN f_reciept rec ON rec.AsainstLedgerTnxNo=lt.LedgerTransactionNo      ");
        sb.Append(" INNER JOIN f_ledgertnxdetail LTD ON LT.LedgerTransactionNo=LTD.LedgerTransactionNo AND ltd.stockid<>''  ");
        sb.Append(" INNER JOIN f_stock ST ON LTD.StockID=ST.StockID INNER JOIN patient_master PM ON LT.PatientID=PM.PatientID  INNER JOIN f_salesdetails sd ON sd.LedgerTransactionNo=ltd.LedgerTransactionNo AND ltd.`ID`=sd.ledgertnxno ");
        sb.Append(" INNER JOIN patient_medical_history pmh ON lt.TransactionID = pmh.TransactionID WHERE LT.TypeOfTnx IN ('Emergency')  ");
       // sb.Append(" AND lt.CentreID=1 AND ltd.EntryDate>='2022-03-07 00:00:00'  AND ltd.EntryDate<='2022-03-10 23:59:59'  ");
        sb.Append(" AND ltd.DeptLedgerNo='" + Session["DeptLedgerNo"].ToString() + "' AND lt.CentreID=" + Session["CentreID"].ToString() + " AND  ltd.EntryDate>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' AND  ltd.EntryDate<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");

        if (ddlItem.SelectedIndex > 0)
            sb.Append(" and  LTD.ItemId='" + ddlItem.SelectedValue + "'");

        if (ddlType.SelectedIndex > 0)
            sb.Append(" and LTD.TypeOfTnx='" + ddlType.SelectedValue + "'");

        if (txtIPDNo.Text.Trim() != string.Empty)
            sb.Append(" and lt.TransactionID = '" + StockReports.getTransactionIDbyTransNo(txtIPDNo.Text.Trim()) + "'");

        if (ddlUser.SelectedIndex > 0)
            sb.Append(" and LT.UserID = '" + ddlUser.SelectedValue + "'");
        
        if (txtRegNo.Text.Trim() != string.Empty)
            sb.Append(" and PM.PatientID = '" + txtRegNo.Text.Trim() + "' ");
        if (ddlPanel.SelectedIndex > 0)
            sb.Append(" and pmh.PanelID =" + ddlPanel.SelectedValue + " ");
        if (txtName.Text.Trim() != string.Empty)
            sb.Append(" and PM.PName LIKE '" + txtName.Text.Trim() + "%' ");
        sb.Append(" GROUP BY lt.ledgertransactionno,sd.indentno ");

       
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

   
}