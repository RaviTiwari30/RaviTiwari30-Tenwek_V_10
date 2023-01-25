using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Web.UI.HtmlControls;

public partial class Design_Purchase_POAnalysis : System.Web.UI.Page
{
    #region Search Data
    private void BindLedger()
    {
        string str = "SELECT LedgerName,LedgerNumber from f_ledgermaster Where GroupID='STO'";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {
            chkStore.DataSource = dt;
            chkStore.DataTextField = "LedgerName";
            chkStore.DataValueField = "LedgerNumber";
            chkStore.DataBind();
            chkStore.Items.Insert(0, new ListItem("All"));
            chkStore.Items[0].Selected = true;
        }
    }
    private void GetVendors()
    {
        StringBuilder sb = new StringBuilder();
      

        sb.Append("Select VendorID,VendorName,sum(Orders) TotalOrder,sum(open)OpenOrder from  ( ");
        sb.Append("    select po.VendorID,po.VendorName,1 Orders ,if(po.Status = 2,1,0) Open ");
        sb.Append("    from f_purchaseorder po ");

        if (chkStore.SelectedValue != "All")
        {
            sb.Append("    inner join f_purchaseorderpurchaserequest ppr ");
            sb.Append("    on po.PurchaseOrderNo = ppr.PONumber inner join f_purchaserequestmaster pm ");
            sb.Append("    on pm.PurchaseRequestNo = ppr.PRNumber ");
        }

        string str = GetCritaria();
        if (str != string.Empty)
            sb.Append(str);

        if (chkStore.SelectedValue != "All")
        {
            sb.Append("    and pm.StoreID ='" + chkStore.SelectedValue + "' ");
            sb.Append("    group by po.PurchaseOrderNo ");
        }

        sb.Append(")t1 group by VendorID order by VendorName ");



        DataTable dtVendor = new DataTable();
        dtVendor = StockReports.GetDataTable(sb.ToString());

        if (dtVendor.Rows.Count > 0)
        {
            rpVendor.DataSource = dtVendor;
            rpVendor.DataBind();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "hidelabel();", true);
            lblMsg.Text = "";
        }
        else
        {
            rpVendor.DataSource = null;
            rpVendor.DataBind();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }
    }
    private DataTable GetOrders(string VendorID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select PurchaseOrderNo,Subject,GrossTotal,Type,date_format(PO.RaisedDate,'%d-%b-%y')PoDate,if(validDate <> '0001-01-01 00:00:00',date_format(validDate,'%d-%b-%y'),'---') VDate ,");
        sb.Append(" (case when Po.Status = 0 then 'Pending' when Po.Status = 1 then 'Reject' when Po.Status = 2 then 'Open' ");
        sb.Append(" when Po.Status = 3 then 'Close' end )PoStatus from  f_purchaseorder PO where po.VendorID = '" + VendorID + "'");

        if (txtPONo.Text != string.Empty)
            sb.Append(" and PO.PurchaseOrderNo='" + txtPONo.Text.Trim() + "'");

        if (cmbStatus.SelectedIndex > 0)
            sb.Append(" and PO.Status='" + cmbStatus.SelectedItem.Value + "'");

        if (cmbRequestType.SelectedIndex > 0)
            sb.Append(" and Type='" + cmbRequestType.SelectedItem.Text + "'");

        if (ucFromDate.Text.Trim() != string.Empty)
            sb.Append(" and date(PO.RaisedDate) >= '" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "'");

        if (ucToDate.Text.Trim() != string.Empty)
            sb.Append(" and date(PO.RaisedDate) <='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'");

        DataTable dtOrder = new DataTable();
        dtOrder = StockReports.GetDataTable(sb.ToString());

        return dtOrder;
    }
    private DataTable GetItems(string PONumber)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" select pd.PurchaseOrderDetailID,concat(pd.ItemName,' / ',pd.Specification)Item,");
        sb.Append(" pd.ApprovedQty,pd.RecievedQty,pd.BuyPrice,pop.PRNumber,if(pd.IsFree = 1,'Yes','No')Free,");
        sb.Append(" pd.Discount_p,pd.Rate,pd.Amount,pd.STATUS,ifnull(pd.CancelReason,'')CancelReason from f_purchaseorderdetails pd left join f_purchaseorderpurchaserequest pop");
        sb.Append(" on pd.PurchaseOrderDetailID = pop.PODetailID where pd.PurchaseOrderNo = '" + PONumber + "'");

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }
    private DataTable GetGRN(string PDID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" select lt.BillNo LedgerTransactionNo,st.unitprice,ps.Qty,st.MRP,st.BatchNumber,date_format(st.StockDate,'%d-%b-%y')RDate");
        sb.Append(" from f_po_store ps inner join f_stock st on ps.stockid = st.stockid INNER JOIN f_ledgertransaction lt ON lt.LedgertransactionNo=ps.LedgertransactionNo  where ps.PODetailID = " + PDID + "");
       // sb.Append(" union all select ps.LedgerTransactionNo,ps.Qty,st.MRP,st.BatchNumber,date_format(st.StockDate,'%d-%b-%y')RDate");
        //sb.Append(" from f_po_store ps inner join f_stock st on ps.stockid = st.stockid where ps.PODetailID = "+PDID);

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }
    #endregion
    
   

    #region Event Handling
    protected void rpVendor_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "PVendor")
        {
            string opType = ((ImageButton)e.CommandSource).AlternateText.ToUpper();
            Repeater rpt = (Repeater)e.Item.FindControl("rpOrder");

            if (opType == "SHOW")
            {
                string VendorID = Convert.ToString(e.CommandArgument);

                ((ImageButton)e.CommandSource).AlternateText = "Hide";
                ((ImageButton)e.CommandSource).ImageUrl = "~/Images/minus.png";
                DataTable dt = GetOrders(VendorID);

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
                    //lblMsg.Text = "No Details Found";
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
    protected void BindItemsForPO(object sender, EventArgs e)
    {        
        Repeater rpt = (Repeater)((ImageButton)sender).Parent.FindControl("rpItems");

        if (((ImageButton)sender).AlternateText.ToUpper() == "SHOW")
        {
            string PoNo = ((Label)((ImageButton)sender).Parent.FindControl("lblOrderNo")).Text;
            DataTable dtItems = GetItems(PoNo);

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
    protected void BindGRNForItems(object sender, EventArgs e)
    {
        Repeater rpt = (Repeater)((ImageButton)sender).Parent.FindControl("rpReceive");

        if (((ImageButton)sender).AlternateText.ToUpper() == "SHOW")
        {
            string PDID = ((Label)((ImageButton)sender).Parent.FindControl("lblRequestItem")).Text;
            DataTable dtItems = GetGRN(PDID);

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
                //lblMsg.Text = "No Details Found";
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
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoadData_Store.bindTypeMaster(cmbRequestType);
            
            BindLedger();
            AllLoadData_Store.bindStore(lstVendor, "VEN", "----------");
            ucFromDate.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
            ucToDate.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
        }
        ucFromDate.Attributes.Add("readonly", "true");
        ucToDate.Attributes.Add("readonly", "true");
       
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        GetVendors();
    }
    #endregion

    #region Search Critaria
    private string GetCritaria()
    {
        string str = string.Empty;
        str = " where PO.CentreID='" + Session["CentreID"].ToString() + "'";
        if (txtPONo.Text != string.Empty)
            str = str + " AND PO.PurchaseOrderNo='" + txtPONo.Text.Trim() + "'";
        
        if (cmbStatus.SelectedIndex > 0)
        {
            if (str != string.Empty)
                str = str + " and PO.Status='" + cmbStatus.SelectedItem.Value + "'";
            else
                str = " where PO.Status='" + cmbStatus.SelectedItem.Value + "'";
        }
        if (cmbRequestType.SelectedIndex > 0)
        {
            if (str != string.Empty)
                str = str + " and Type='" + cmbRequestType.SelectedItem.Text + "'";
            else
                str = " where Type='" + cmbRequestType.SelectedItem.Text + "'";
        }

        if (lstVendor.SelectedIndex > 0)
        {
            if (str != string.Empty)
                str = str + " and PO.VendorID = '" + lstVendor.SelectedValue + "'";
            else
                str = " where PO.VendorID = '" + lstVendor.SelectedValue + "'";

        }
        if (ucFromDate.Text.Trim() != string.Empty)
        {
            if (str != string.Empty)
                str = str + " and date(PO.RaisedDate) >='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "'";
            else
                str = " where date(PO.RaisedDate) >='" +  Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "'";
        }
        if (ucToDate.Text.Trim() != string.Empty)
        {
            if (str != string.Empty)
                str = str + " and date(PO.RaisedDate) <='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'";
            else
                str = " where date(PO.RaisedDate) <='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'";
        }
        return str;
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
