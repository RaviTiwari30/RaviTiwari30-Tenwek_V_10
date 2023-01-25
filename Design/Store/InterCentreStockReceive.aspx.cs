using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using MySql.Data.MySqlClient;
using System.Collections.Generic;
using System.IO;
using System.Web;
using System.Globalization;
using System.Web.Services;
using System.Web.Script.Serialization;
using System.Web.Script.Services;

public partial class Design_Store_InterCentreStockReceive : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtSalesNo.Focus();
            ViewState["ID"] = Session["ID"].ToString();
            ViewState["HOSPID"] = Session["HOSPID"].ToString();
            ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
            ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            //}
        }
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");

    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        Bind_DeptIssue();
    }
    protected void gvGRN_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvGRN.PageIndex = e.NewPageIndex;
        Bind_DeptIssue();
    }
    protected void gvGRN_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "APost")
        {
            string str = "update f_stock set ispost = 1,PostDate = current_timeStamp() where StockID = '" + Util.GetString(e.CommandArgument) + "' and IsPost=4  ";
            StockReports.ExecuteDML(str);
            Bind_DeptIssue();
        }
    }
    #region Data Binding

    private void Bind_DeptIssue()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select f.ItemName,F.StockID,f.salesno,lm.LedgerName FromDept,date_format(f.StockDate,'%d-%b-%y')StockDate,if(f.IsPost=4,'Not-Receive','Receive')IsPost,if(f.IsPost=4,'true','false')Post,f.ItemID ,f.InitialCount,IFNULL((SELECT cm.CentreName FROM f_stock st INNER JOIN center_master cm ON cm.CentreID=st.CentreID WHERE st.StockID=f.FromStockID),'')FromCentre from f_stock f inner join f_ledgermaster lm on lm.LedgerNumber=f.FromDept where f.IsAsset=0 and f.salesno <>'' and f.FromDept<>'' and f.FromStockID<>'' and f.IsPost in(1,4) ");
        if (txtSalesNo.Text.Trim() != string.Empty)
            sb.Append(" and f.Salesno = '" + txtSalesNo.Text.Trim() + "'");
        if (ucFromDate.Text != string.Empty)
            sb.Append(" and f.Stockdate >= '" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'");
        if (ucToDate.Text != string.Empty)
            sb.Append(" and f.Stockdate <= '" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'");
        sb.Append(" and f.IsPost = " + rbtStatus.SelectedItem.Value);

        sb.Append(" and f.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' ");
        sb.Append("  and f.CentreID=" + Session["CentreID"].ToString() + " ");
        sb.Append(" order by f.StockDate,f.salesno,f.ItemName desc ");
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {

            gvGRN.DataSource = dt;
            gvGRN.DataBind();
            lblMsg.Text = "";
            if (rbtStatus.SelectedItem.Value == "4")
                btnSave.Visible = true;
            else
                btnSave.Visible = false;
        }
        else
        {
            gvGRN.DataSource = null;
            gvGRN.DataBind();
            btnSave.Visible = false;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }

    }
    #endregion
    protected void btnSave_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        string str = string.Empty;
        string IsIntegrated = string.Empty,stockID= string.Empty;
        int IsReceive = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            foreach (GridViewRow gr in gvGRN.Rows)
            {
                if (((CheckBox)gr.FindControl("chkSelect")).Checked)
                {
                    stockID = Util.GetString(((Label)gr.FindControl("lblStockID")).Text);
                    str = "update f_stock set ispost = 1,PostDate = now(),PostUserID='"+ Session["ID"].ToString() +"' where StockID = '" + stockID + "' and IsPost=4  ";
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);

                    if (Resources.Resource.AllowFiananceIntegration == "1")
                    {
                        IsIntegrated = Util.GetString(EbizFrame.InsertInventoryTransaction(0, 0, 28, Util.GetInt(stockID), Tranx));
                        if (IsIntegrated == "0")
                        {
                            Tranx.Rollback();
                            return;
                        }
                    }

                    IsReceive = IsReceive + 1;
                }
            }
            Tranx.Commit();
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = "Error Occured. Please contact to administrator";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
        if (IsReceive > 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key121", "modelAlert('Stock Received Successfully');", true);
            Bind_DeptIssue();
        }
        else
        {
            lblMsg.Text = "Please Select Atleast One Item";
        }
    }
}

