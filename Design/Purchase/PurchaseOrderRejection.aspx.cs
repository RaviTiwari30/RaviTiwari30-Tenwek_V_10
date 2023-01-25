using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

public partial class Design_Purchase_PurchaseOrderRejection : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
       
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        BindOrders();
    }
    private void BindOrders()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select po.PurchaseOrderNo,po.Subject,po.GrossTotal,po.VendorName,em.Name,");
        sb.Append(" date_format(po.RaisedDate,'%d-%b-%y')RDate from f_purchaseorder po inner join employee_master em on po.RaisedUserID = em.Employee_ID");
       sb.Append(" left join (select distinct(PONumber) from f_po_store)T1");
        sb.Append(" on po.PurchaseOrderNo = t1.PONumber where po.Approved = 2 and po.Status = 2 and t1.PONumber is null ");
        if (txtPONo.Text.Trim() != string.Empty)
            sb.Append(" and po.PurchaseOrderNo = '" + txtPONo.Text.Trim() + "'");

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            gvOrders.DataSource = dt;
            gvOrders.DataBind();            
            lblMsg.Text = "";
        }
        else
        {
            gvOrders.DataSource = null;
            gvOrders.DataBind();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }
        gvItems.DataSource = null;
        gvItems.DataBind();
    }
    
    protected void gvOrders_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Reject")
        {
            string PONO = Util.GetString(e.CommandArgument);             
            bool Result = StockReports.ExecuteDML("call usp_RejectPO('" + PONO + "','" + Convert.ToString(Session["ID"]) + "','" + Convert.ToString(Session["UserName"]) + "','"+  "');");
            if (Result)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM03','" + lblMsg.ClientID + "');", true);
                BindOrders();
            }
            else
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }
        if (e.CommandName == "AView")
        {            
         ViewState["PONo"] = Util.GetString(e.CommandArgument);
         GetOrderItems();
        }
    }
    private void GetOrderItems()
    {
        if (ViewState["PONo"] != null)
        {
            string PONO = Convert.ToString(ViewState["PONo"]);
            StringBuilder sb = new StringBuilder();
            sb.Append("select PurchaseOrderDetailID,PurchaseOrderNo,ItemName,OrderedQty,ApprovedQty,Rate,if(IsFree = 1,'true','false')IsFree, Specification,Discount_p from ");
            sb.Append(" f_purchaseorderdetails where PurchaseOrderNo = '" + PONO + "' and Status=0 and Approved = 1 ORDER BY ItemName");
            
            DataTable dtitem = new DataTable();
            dtitem = StockReports.GetDataTable(sb.ToString());
            if (dtitem.Rows.Count > 0)
            {
                StringBuilder sbTax = new StringBuilder();
                sbTax.Append("select po.TaxID,po.TaxPer,tm.TaxName,po.PODetailID from f_purchaseordertax po inner join f_taxmaster tm");
                sbTax.Append(" on po.TaxID = tm.TaxID where po.PONumber = '" + PONO + "'");
                
                ViewState["dtTax"] = StockReports.GetDataTable(sbTax.ToString());
                
                gvItems.DataSource = dtitem;
                gvItems.DataBind();
                lblMsg.Text = "";
            }
            else
            {
                gvItems.DataSource = null;
                gvItems.DataBind();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            }
        }
    }
    private DataTable BindTax(string PODetailID)
    {
        if (ViewState["dtTax"] != null)
        {
            DataTable dt = (DataTable)ViewState["dtTax"];
            DataRow[] dr = dt.Select("PODetailID = "+PODetailID);

            DataTable dtTax = dt.Clone();

            if (dr.Length > 0)
                foreach (DataRow row in dr)
                    dtTax.ImportRow(row);

            return dtTax;
        }
        return null;
    }

    protected void gvItems_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row != null)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string PODetailID = ((Label)e.Row.FindControl("lblPDID")).Text.Trim();

                DataTable dtTax = new DataTable();
                dtTax = BindTax(PODetailID);

                if (dtTax != null && dtTax.Rows.Count > 0)
                {
                    Repeater rpTax = (Repeater)e.Row.FindControl("rpTax");
                    rpTax.DataSource = dtTax;
                    rpTax.DataBind();
                }
            }
        }
    }
}
