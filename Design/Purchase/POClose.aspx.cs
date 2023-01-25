using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Web;
using MySql.Data.MySqlClient;


public partial class Design_Purchase_POClose : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        int CentreID = Util.GetInt(Session["CentreID"].ToString());

        if (All_LoadData.checkPageAuthorisation(Session["RoleID"].ToString(), Session["ID"].ToString(), HttpContext.Current.Request.Url.AbsolutePath.Remove(0, VirtualPathUtility.ToAbsolute("~/").Length - 1), CentreID) == 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.location ='../Common/UserAuthorization.aspx?msg=For This Page';", true);
            return;
        }
        else
        {
            string EmpID = Convert.ToString(Session["ID"]);
        }

    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        GetOrderDetails();
    }
    private void BindOrderDetails()
    {
        if (ViewState["dsItems"] != null)
        {
            DataSet dsItems = (DataSet)ViewState["dsItems"];
            if (dsItems.Tables.Contains("ItemsDetail"))
            {
                gvOrderDetail.DataSource = dsItems.Tables["ItemsDetail"];
                gvOrderDetail.DataBind();
                lblMsg.Text = "";

            }
            else
            {
                gvOrderDetail.DataSource = null;
                gvOrderDetail.DataBind();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            }
        }
        else
        {
            gvOrderDetail.DataSource = null;
            gvOrderDetail.DataBind();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }
    }

    private void GetOrderDetails()
    {
        lblMsg.Text = "";
        StringBuilder sb = new StringBuilder();
        sb.Append("select pd.PurchaseOrderDetailID,po.Narration,pd.PurchaseOrderNo,pd.ItemName,pd.ApprovedQty,pd.RecievedQty,");
        sb.Append(" po.VendorID,pd.ItemID,pd.Rate,pd.Discount_p,pd.ItemID,if(pd.IsFree = 1,'true','false')Free,po.VendorName from f_purchaseorderdetails pd inner join f_purchaseorder po");
        sb.Append(" on pd.PurchaseOrderNo = po.PurchaseOrderNo where po.Approved = 2  and po.status not in(0,1,3) and pd.PurchaseOrderNo = '" + txtPONo.Text.Trim() + "'");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            gvOrderDetail.DataSource = dt;
            gvOrderDetail.DataBind();
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }

       
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string Query = "update f_purchaseorder set Status=3 where PurchaseOrderNo='" + txtPONo.Text.Trim() + "'";
            int a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
            if (a == 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM07','" + lblMsg.ClientID + "');", true);
                Tranx.Rollback();
                Tranx.Dispose();
                con.Close();
                con.Dispose();
                return;
            }


            foreach (GridViewRow row in gvOrderDetail.Rows)
            {

                if (Util.GetDecimal(((Label)row.FindControl("lblAppQty")).Text) > Util.GetDecimal(((Label)row.FindControl("lblRecQty")).Text))
                {
                    Query = "insert into f_poclose_detail (OrderNo,ItemID,ItemName,App_Qty,Rate,Discount,VendorName,VendorLedgerNo,Rec_Qty,Narration,UserID)values('" + ((Label)row.FindControl("lblOrderNo")).Text + "','" + ((Label)row.FindControl("lblItemID")).Text + "','" + ((Label)row.FindControl("lblItemName")).Text + "','" + ((Label)row.FindControl("lblAppQty")).Text.Trim() + "','" + ((Label)row.FindControl("lblRate")).Text + "','" + ((Label)row.FindControl("lblDiscount")).Text + "','" + ((Label)row.FindControl("lblVendorName")).Text + "','" + ((Label)row.FindControl("lblVendorID")).Text + "','" + ((Label)row.FindControl("lblRecQty")).Text.Trim() + "','" + txtNarration.Text.Trim().Replace("'", "''") + "','" + Session["ID"].ToString() + "')";
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
                }
            }
            txtNarration.Text = string.Empty;
            txtPONo.Text = string.Empty;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
            Tranx.Commit();           
            gvOrderDetail.DataSource = null;
            gvOrderDetail.DataBind();

        }

        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM07','" + lblMsg.ClientID + "');", true);
            Tranx.Rollback();          
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
}
   
