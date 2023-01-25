using System;
using System.Data;
using System.Web.UI;
using System.Text;

public partial class PR_NotApproved : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["DeptLedgerNo"] != null)
                ViewState["CurDeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
            else
                ViewState["CurDeptLedgerNo"] = "";

            string sd = ViewState["CurDeptLedgerNo"].ToString();
            AllLoadData_Store.checkStoreRight(rblStoreType);
            FromDate.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
            ToDate.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnSearch);


        }
        FromDate.Attributes.Add("ReadOnly", "ReadOnly");
        ToDate.Attributes.Add("ReadOnly", "ReadOnly");
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (rblStoreType.SelectedIndex < 0)
        {
            lblMsg.Text = "Please Select Store Type";
            return;
        }
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT  Distinct(PRM.PurchaseRequestNo)'Purchase Request No.',cm.CentreName 'Centre Name',(CASE WHEN PRM.Status = 0 THEN 'Pending' WHEN PRD.Status = 2 THEN 'Reject' WHEN PRD.Status = 1 THEN 'Open' WHEN PRD.Status = 3 THEN 'Close' END )Status, ");
        sb.Append("  ItemID,PRD.ItemName 'Item Name',PRD.RequestedQty 'Requested Quantity',EM.Name 'Raised User', ");
        sb.Append("  DATE_FORMAT(PRM.RaisedDate,'%d-%b-%Y')'Raised Date'  FROM f_purchaserequestmaster PRM  INNER JOIN f_purchaserequestdetails PRD ");
        sb.Append("  ON PRM.PurchaseRequestNo = PRD.PurchaseRequisitionNo  INNER JOIN employee_master EM  ");
        sb.Append("  ON PRM.RaisedByID = EM.EmployeeID INNER JOIN f_ledgermaster LM ON LM.LedgerNumber = PRM.StoreID INNER JOIN center_master cm ON cm.CentreID = PRM.CentreID  ");
        sb.Append("  WHERE  PRM.CentreID  IN (" + Centre + ") ");
        if (FromDate.Text.Trim() != string.Empty)
            sb.Append(" and DATE(PRM.RaisedDate) >= '" + Util.GetDateTime(FromDate.Text).ToString("yyyy-MM-dd") + "'");
        if (ToDate.Text.Trim() != string.Empty)
            sb.Append(" AND DATE(PRM.RaisedDate) <= '" + Util.GetDateTime(ToDate.Text).ToString("yyyy-MM-dd") + "'");
        sb.Append(" AND storeID = '" + rblStoreType.SelectedValue + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            Session["dtExport2Excel"] = dt;
            Session["ReportName"] = "Purchase Request Not Approved";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/ExportToExcel.aspx');", true);
        }
        else
        {
            lblMsg.Visible = true;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }
    }
}
