using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Text;

public partial class Design_Purchase_PRAnalysis : System.Web.UI.Page
{  

   
    #region Search Data
    private void GetStores()
    { 
        StringBuilder sb = new StringBuilder();
        sb.Append(" select StoreID,LedgerName,sum(Request)TotalRequest,sum(Open)OpenRequest from");
        sb.Append(" (select pr.StoreID,lm.LedgerName,1 Request,if(pr.Status = 2,1,0) Open ");
        sb.Append(" from f_purchaserequestmaster pr inner join f_ledgermaster lm on lm.LedgerNumber = pr.StoreID");
        string str = string.Empty;
        str = SearchCritaria();
        if(str != string.Empty)
            sb.Append(str);

        sb.Append(" ) t1 group by StoreID order by StoreID");

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            rpStore.DataSource = dt;
            rpStore.DataBind();
            lblMsg.Text = "";
        }
        else
        {
            rpStore.DataSource = null;
            rpStore.DataBind();
            //lblMsg.Text = "No Record Found...";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }
    }
    private DataTable GetRequest(string storeID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select pr.PurchaseRequestNo,date_format(pr.RaisedDate,'%d-%b-%y')RequestDate,pr.Subject,pr.Type,");
        sb.Append(" (case when Pr.Status = 0 then 'Pending' when Pr.Status = 1 then 'Reject' when Pr.Status = 2 then 'Open' when Pr.Status = 3 then 'Close' end )PRStatus,");
        sb.Append(" em.Name from f_purchaserequestmaster pr inner join employee_master em on pr.RaisedByID = em.EmployeeID ");
        sb.Append(" where pr.StoreID = '"+storeID+"'");

        if (txtPRNo.Text != string.Empty)
            sb.Append(" and pr.PurchaseRequestNo='" + txtPRNo.Text.Trim() + "'");

        if (cmbStatus.SelectedIndex > 0)
            sb.Append(" and Pr.Status='" + cmbStatus.SelectedItem.Value + "'");

        if (cmbRequestType.SelectedIndex > 0)
            sb.Append(" and pr.Type='" + cmbRequestType.SelectedItem.Text + "'");

        if (ucFromDate.Text.Trim() != string.Empty)
            sb.Append(" and date(Pr.RaisedDate) >= '" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "'");

        if (ucToDate.Text.Trim() != string.Empty)
            sb.Append(" and date(Pr.RaisedDate) <= '" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'");

        DataTable dtRequest = new DataTable();
        dtRequest = StockReports.GetDataTable(sb.ToString());

        return dtRequest;
    }
    private DataTable GetItems(string PRNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT CONCAT(PurchaseRequisitionNo,'#',ItemID)PRID,CONCAT(ItemName,' / ',Specification)Item, ApprovedQty,OrderedQty, ");
        sb.Append("  Purpose, ApproxRate,InHandQty,STATUS FROM f_purchaserequestdetails ");
        sb.Append("  WHERE PurchaseRequisitionNo = '" + PRNo + "'");

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());

        return dt;
    }
    private DataTable GetOrderDetails(string PRID)
    {
        string PRNo = PRID.Substring(0, PRID.IndexOf('#'));
        string ItemID = PRID.Substring(PRID.IndexOf('#') + 1);

        StringBuilder sb = new StringBuilder();
        sb.Append("select pr.PONumber,pr.OrderedQty,po.VendorName,date_format(po.RaisedDate,'%d-%b-%y') PODate");
        sb.Append(" from f_purchaseorderpurchaserequest pr inner join f_purchaseorder po on pr.PONumber = po.PurchaseOrderNo");
        sb.Append(" where pr.PRNumber = '" + PRNo + "' and pr.ITemID = '" + ItemID + "'");

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }    
    #endregion
    #region Search Critaria
    private string SearchCritaria()
    { 
        string str = string.Empty;
        str = " WHERE PR.CentreID=" + Session["CentreID"].ToString() + " ";
        if (txtPRNo.Text.Trim() != string.Empty)
            str = str + " AND PR.PurchaseRequestNo = '" + txtPRNo.Text.Trim() + "'";

        if (cmbRequestType.SelectedIndex > 0)
        {
            if (str != string.Empty)
                str = str + " and PR.Type = '" + cmbRequestType.SelectedItem + "'";
            else
                str = " where PR.Type = '" + cmbRequestType.SelectedItem + "'";
        }
        
        if (ucFromDate.Text.Trim() != string.Empty)
        {
            if (str != string.Empty)
                str = str + " and date(PR.RaisedDate) >= '" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "'";
            else
                str = " where date(PR.RaisedDate) >= '" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "'";
        }
        if (ucToDate.Text.Trim() != string.Empty)
        {
            if (str != string.Empty)
                str = str + " and date(PR.RaisedDate) <='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'";
            else
                str = " where date(PR.RaisedDate) <='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'";
        }
        if (cmbStatus.SelectedIndex > 0)
        {
            if (str != string.Empty)
                str = str + " and PR.status = '" + cmbStatus.SelectedItem.Value + "'";
            else
                str = " where PR.status = '" + cmbStatus.SelectedItem.Value + "'";

        }        
        if (lstStore.SelectedIndex > 0)
        {
            if (str != string.Empty)
                str = str + " and PR.StoreID = '" + lstStore.SelectedValue + "'";
            else
                str = " where PR.StoreID = '" + lstStore.SelectedValue + "'";

        }
        return str;
    }
    #endregion

    #region Event Handling
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoadData_Store.bindStore(lstStore, "STO");
            lstStore.Items.Insert(0, new ListItem("-select-", ""));
            AllLoadData_Store.bindTypeMaster(cmbRequestType);
            ucFromDate.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
            ucToDate.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");

        }
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");
    }
    protected void BindItemsForRequest(object sender, EventArgs e)
    {
        Repeater rpt = (Repeater)((ImageButton)sender).Parent.FindControl("rpItems");

        if (((ImageButton)sender).AlternateText.ToUpper() == "SHOW")
        {
            string PRNo = ((Label)((ImageButton)sender).Parent.FindControl("lblRequestNo")).Text;
            DataTable dtItems = GetItems(PRNo);

            ((ImageButton)sender).AlternateText = "Hide";
            ((ImageButton)sender).ImageUrl = "~/Images/minus.png";

            if (dtItems.Rows.Count > 0)
            {
                rpt.DataSource = dtItems;
                rpt.DataBind();

                

                lblMsg.Text = string.Empty;
            }
            else
            {
                rpt.DataSource = null;
                rpt.DataBind();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            }
        }
        else
        {
            ((ImageButton)sender).AlternateText = "Show";
            ((ImageButton)sender).ImageUrl = "~/Images/plus.png";
            rpt.DataSource = null;
            rpt.DataBind();
        }
    }
    protected void BindOrderForItems(object sender, EventArgs e)
    {
        Repeater rpt = (Repeater)((ImageButton)sender).Parent.FindControl("rpOrder");

        if (((ImageButton)sender).AlternateText.ToUpper() == "SHOW")
        {
            string PRNo = ((Label)((ImageButton)sender).Parent.FindControl("lblRequestItem")).Text;
            DataTable dtItems = GetOrderDetails(PRNo);

            ((ImageButton)sender).AlternateText = "Hide";
            ((ImageButton)sender).ImageUrl = "~/Images/minus.png";

            if (dtItems.Rows.Count > 0)
            {
                rpt.DataSource = dtItems;
                rpt.DataBind();
                lblMsg.Text = string.Empty;
            }
            else
            {
                rpt.DataSource = null;
                rpt.DataBind();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            }
        }
        else
        {
            ((ImageButton)sender).AlternateText = "Show";
            ((ImageButton)sender).ImageUrl = "~/Images/plus.png";
            rpt.DataSource = null;
            rpt.DataBind();
        }
    }
    protected void rpStore_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "PStore")
        {
            string opType = ((ImageButton)e.CommandSource).AlternateText.ToUpper();
            Repeater rpt = (Repeater)e.Item.FindControl("rpRequest");
            
            if (opType == "SHOW")
            {
                string StoreID = Convert.ToString(e.CommandArgument);

                ((ImageButton)e.CommandSource).AlternateText = "Hide";
                ((ImageButton)e.CommandSource).ImageUrl = "~/Images/minus.png";
                DataTable dt = GetRequest(StoreID);

                if (dt.Rows.Count > 0)
                {
                    rpt.DataSource = dt;
                    rpt.DataBind();
                    lblMsg.Text = string.Empty;
                }
                else
                {
                    rpt.DataSource = null;
                    rpt.DataBind();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
                }
            }
            else
            {
                ((ImageButton)e.CommandSource).AlternateText = "Show";
                ((ImageButton)e.CommandSource).ImageUrl = "~/Images/plus.png";

                rpt.DataSource = null;
                rpt.DataBind();
                lblMsg.Text = string.Empty;
            }
        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        GetStores();
    }
    protected void rpItems_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
         if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            Label status = (Label)e.Item.FindControl("lblStatus");
            RepeaterItem ri = e.Item;
            HtmlTableRow tr = ri.FindControl("tmp") as HtmlTableRow;
            if (tr != null)
            {
                if (status.Text == "0")
                {
                    tr.BgColor = "#FFFFE0";
                }
                if (status.Text == "1")
                {
                    tr.BgColor = "#9ACD32";
                }
                if (status.Text == "2")
                {
                    tr.BgColor = "#FFB6C1";
                }
                if (status.Text == "3")
                {
                    tr.BgColor = "#FFFF00";
                }
            }
        }
    }
    #endregion
    
}
