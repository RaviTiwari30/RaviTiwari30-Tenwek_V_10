using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Equipment_Transactions_AssetSchedulingTrans : System.Web.UI.Page
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
            bindasset();
            bindmaintenanc();
            bindscedule();
            bindmain();
            ucDateTo.FillDatabaseDate(DateTime.Now.ToString());


        }
    }

    private void bindmain()
    {
        DataTable dt = StockReports.GetDataTable(@"SELECT sm.id,itemname,maintenancetypename mt,DATE_FORMAT(schedule_date,'%d-%m-%Y') sdate,scheduletype FROM  eq_asset_schedule_master sm  
INNER JOIN eq_asset_master am ON sm.assetid=am.id INNER JOIN eq_maintenancetype_master mm ON mm.maintenancetypeid=sm.maintenanncetype");

        grddetail.DataSource = dt;
        grddetail.DataBind();
    }
    private void bindmaintenanc()
    {
        DataTable dt = StockReports.GetDataTable(@" SELECT maintenancetypeid,maintenancetypename FROM eq_maintenancetype_master WHERE isactive=1");

        ddlmain.DataSource = dt;
        ddlmain.DataTextField = "maintenancetypename";
        ddlmain.DataValueField = "maintenancetypeid";
        ddlmain.DataBind();
        ddlmain.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        ddlmain.SelectedIndex = 0;
    }
    private void bindasset()
    {
        DataTable dt = StockReports.GetDataTable(@"SELECT am.id,itemname,locationname,floorname,roomname,am.serialno,am.modelno,ledgername
FROM eq_asset_location_master aim INNER JOIN eq_asset_master am ON aim.assetid=am.id 
  INNER JOIN eq_location_master lm ON lm.locationid=aim.LOcid
 INNER JOIN eq_floor_master fm ON fm.floorid=aim.floorid INNER JOIN eq_room_master rm  
 ON rm.roomid=aim.roomid INNER JOIN f_ledgermaster fl ON fl.LedgerNumber=aim.DEPARTMENTID");

        ddlasset.DataSource = dt;
        ddlasset.DataTextField = "itemname";
        ddlasset.DataValueField = "id";
        ddlasset.DataBind();
        ddlasset.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        ddlasset.SelectedIndex = 0;

    }
    protected void ddlasset_SelectedIndexChanged(object sender, EventArgs e)
    {
        DataTable dt = StockReports.GetDataTable(@"SELECT itemname,locationname,floorname,roomname,am.serialno,am.modelno,ledgername
FROM eq_asset_location_master aim INNER JOIN eq_asset_master am ON aim.assetid=am.id 
  INNER JOIN eq_location_master lm ON lm.locationid=aim.LOcid
 INNER JOIN eq_floor_master fm ON fm.floorid=aim.floorid INNER JOIN eq_room_master rm  
 ON rm.roomid=aim.roomid INNER JOIN f_ledgermaster fl ON fl.LedgerNumber=aim.DEPARTMENTID  WHERE am.id='" + ddlasset.SelectedValue + "' ");


        if (dt.Rows.Count > 0)
        {
            txtserial.Text = dt.Rows[0][4].ToString();
            txtmodel.Text = dt.Rows[0][5].ToString();
            txtdept.Text = dt.Rows[0][6].ToString();
            txtlocation.Text = dt.Rows[0][1].ToString();
            txtfloor.Text = dt.Rows[0][2].ToString();
            txtroom.Text = dt.Rows[0][3].ToString();

        }
    }

    private void bindscedule()
    {
        ddlschedule.Items.Insert(0, new ListItem("Select", "Select"));
    }
    protected void btnsave_Click(object sender, EventArgs e)
    {
        if (btnsave.Text == "Save")
        {
            savedata();
        }
        else
        {
            updatedate();
        }
    }

    void savedata()
    {
        MySqlConnection conn = Util.GetMySqlCon();
        conn.Open();

        try
        {
            string str = "";


            str = @"INSERT INTO eq_asset_schedule_master(AssetID,Schedule_date,Remark,TO_DO,SCHEDULETYPE,insertby,insertdate,ipnumber,maintenanncetype)
VALUES ('" + ddlasset.SelectedValue + "','" + (Util.GetDateTime(ucDateTo.GetDateForDisplay())).ToString("yyyy-MM-dd") + "','" + txtrem.Text + "','" + txtnot.Text + "','" + ddlschedule.SelectedValue + "','" + ViewState["ID"].ToString() + "',Now(),'" + ViewState["IPAddress"].ToString() + "','" + ddlmain.SelectedValue + "')";
            StockReports.ExecuteDML(str);
            conn.Close();
            conn.Dispose();

            lblMsg.Text = "Record Saved";
            btnsave.Text = "Save";
            bindmain();

        }
        catch (Exception ex)
        {

            conn.Close();
            conn.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = ex.Message;
        }
    }
    void updatedate()
    {

        MySqlConnection conn = Util.GetMySqlCon();
        conn.Open();

        try
        {
            string str = "";


            str = @"update eq_asset_schedule_master set AssetID='" + ddlasset.SelectedValue + "',Schedule_date='" + (Util.GetDateTime(ucDateTo.GetDateForDisplay())).ToString("yyyy-MM-dd") + "',Remark='" + txtrem.Text + "',TO_DO='" + txtnot.Text + "',SCHEDULETYPE='" + ddlschedule.SelectedValue + "',maintenanncetype='" + ddlmain.SelectedValue + "',updateby='" + ViewState["ID"].ToString() + "',updatedate=Now() where id='" + ViewState["uid"].ToString() + "'";
            StockReports.ExecuteDML(str);
            conn.Close();
            conn.Dispose();

            lblMsg.Text = "Record Updated";
            btnsave.Text = "Save";
            bindmain();


        }
        catch (Exception ex)
        {

            conn.Close();
            conn.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = ex.Message;
        }
    }
    protected void btnclear_Click(object sender, EventArgs e)
    {
        ddlasset.SelectedIndex = 0;
        txtdept.Text = "";
        txtfloor.Text = "";
        txtlocation.Text = "";
        txtmodel.Text = "";
        txtnot.Text = "";
        txtrem.Text = "";
        txtroom.Text = "";
        txtserial.Text = "";
        ddlmain.SelectedIndex = 0;
        ucDateTo.FillDatabaseDate(DateTime.Now.ToString());
        ddlschedule.SelectedIndex = 0;
        btnsave.Text = "Save";
    }
    protected void grddetail_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        lblMsg.Text = "";
        string id = Util.GetString(e.CommandArgument);

        if (e.CommandName == "EditData")
        {
            DataTable dt = StockReports.GetDataTable("SELECT * FROM eq_asset_schedule_master WHERE id='" + id + "'");
            if (dt != null && dt.Rows.Count > 0)
            {
                ddlasset.SelectedValue = dt.Rows[0][2].ToString();
                ddlasset_SelectedIndexChanged(sender, e);

                ddlmain.SelectedValue = dt.Rows[0][1].ToString();
                ucDateTo.FillDatabaseDate(dt.Rows[0][3].ToString());
                txtrem.Text = dt.Rows[0][4].ToString();
                ddlschedule.SelectedValue = dt.Rows[0][6].ToString();
                ViewState["uid"] = dt.Rows[0][0].ToString();
                txtnot.Text = dt.Rows[0][5].ToString();

                btnsave.Text = "Update";

            }
        }
        else if (e.CommandName == "ViewLog")
        {
            lblLog.Text = StockReports.ExecuteScalar(@"SELECT CONCAT('Insert By-',em.Name,' Insert Date- ',DATE_FORMAT(insertdate,'%d-%m-%Y')) insertBy  FROM eq_asset_master ps 
INNER JOIN employee_master em ON em.employee_id=ps.insertby WHERE ps.id=" + id);

            mdpLog.Show();

        }
    }
}