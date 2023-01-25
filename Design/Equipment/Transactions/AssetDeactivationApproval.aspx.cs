using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Equipment_Transactions_AssetDeactivationApproval : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["ID"] == null)
        {
            Response.Redirect("~/Design/Default.aspx");
        }
        if (!IsPostBack)
        {
            ViewState["ID"] = Session["ID"].ToString();
            ViewState["IPAddress"] = All_LoadData.IpAddress().ToString();

            ucfromdate.FillDatabaseDate(DateTime.Now.ToString());
            uctodate.FillDatabaseDate(DateTime.Now.ToString());



        }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        string str = @"SELECT adm.*,itemname,vendorname FROM eq_asset_deactivation_master adm INNER JOIN eq_asset_master am ON am.id=adm.assetid INNER JOIN f_vendormaster vm ON vm.venledgerNo=adm.supplierid WHERE log_date >='" + ucfromdate.GetDateForDataBase() + "' AND isapproved=0";
        DataTable dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {
            gridsaledetail.DataSource = dt;
            gridsaledetail.DataBind();
        }
        else
        {
            lblMsg.Text = "No Record Found";
            gridsaledetail.DataSource = null;
            gridsaledetail.DataBind();
        }
    }
    protected void gridsaledetail_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        lblMsg.Text = "";
        string id = Util.GetString(e.CommandArgument);

        DataTable dt = StockReports.GetDataTable(@"SELECT adm.*,itemname,vendorname,serialno,modelno FROM eq_asset_deactivation_master adm INNER JOIN eq_asset_master am ON am.id=adm.assetid INNER JOIN f_vendormaster vm ON vm.venledgerNo=adm.supplierid where adm.id='" + id + "'");

        if (dt.Rows.Count > 0)
        {
            txtasset.Text = dt.Rows[0]["itemname"].ToString();
            txtamount.Text = dt.Rows[0]["amount"].ToString();
            txtserial.Text = dt.Rows[0]["serialno"].ToString();
            txtmodel.Text = dt.Rows[0]["modelno"].ToString();
            txtconper.Text = dt.Rows[0]["contact_person"].ToString();
            txtsupplier.Text = dt.Rows[0]["vendorname"].ToString();
            pnl.Visible = true;
        }
    }
}