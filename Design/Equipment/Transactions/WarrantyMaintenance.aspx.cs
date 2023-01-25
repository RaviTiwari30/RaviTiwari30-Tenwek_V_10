using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Equipment_Transactions_WarrantyMaintenance : System.Web.UI.Page
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
            bindlocation();
            binditem();
            bindmaintennance();
            bindwarrenty();
            ucfromdate.FillDatabaseDate(DateTime.Now.ToString());
            uctodate.FillDatabaseDate(DateTime.Now.ToString());
            ucsfrom.FillDatabaseDate(DateTime.Now.ToString());


        }
    }

    void bindmaintennance()
    {
        string str = @"SELECT maintenanceid,maintenancename FROM eq_maintenance_master WHERE isactive=1";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            ddlmain.DataSource = dt;
            ddlmain.DataTextField = "maintenancename";
            ddlmain.DataValueField = "maintenanceid";
            ddlmain .DataBind();
            ddlmain.Items.Insert(0,new ListItem("Select","Select"));
            ddlmain.SelectedIndex=0;
        }
    }
    void bindwarrenty()
    {
        string str = @"SELECT itemname,aim.id,days,aim.DOWNTIME,DATE_FORMAT(MAINTENANCE_DATE,'%d-%m-%Y')mdate,MAINTENANCE_COST,MAINTENANCE_CATEGORY
 FROM eq_asset_warranty_maintenance aim INNER JOIN eq_asset_log al ON al.id=aim.requitionid INNER JOIN eq_asset_master am ON al.asset_id=am.id";
        DataTable dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {
            gridviewoutdetail.DataSource = dt;
            gridviewoutdetail.DataBind();
        }
        else
        {
            gridviewoutdetail.DataSource = dt;
            gridviewoutdetail.DataBind();
        }
    }
    void binditem()
    {
        string str = "SELECT im.TypeName ItemName,im.ItemID from f_Itemmaster im inner join f_subcategorymaster sc on im.subcategoryid = sc.subcategoryid " +
           " inner join f_configrelation cf on cf.CategoryID = sc.CategoryID Where im.isActive=1 and sc.Active=1 and cf.IsActive=1 and cf.ConfigID in (11,28) ";


        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {

            ddlitem.DataSource = dt;
            ddlitem.DataTextField = "ItemName";
            ddlitem.DataValueField = "ItemID";
            ddlitem.DataBind();
            ddlitem.Items.Insert(0, new ListItem("SELECT", "SELECT"));

        }
    }
    void bindlocation()
    {
        DataTable dt = StockReports.GetDataTable("SELECT locationid,locationname FROM eq_location_master WHERE isactive=1");

        ddlloc.DataSource = dt;
        ddlloc.DataTextField = "locationname";
        ddlloc.DataValueField = "locationid";
        ddlloc.DataBind();
        ddlloc.Items.Insert(0, new ListItem("Select", "Select"));
        ddlloc.SelectedIndex = 0;
    }


    private void search()
    {
        string str = "SELECT al.id, problemtypename,itemname,DATE_FORMAT(al.Required_date,'%d-%m-%Y') requireddate,DATE_FORMAT(al.Log_request_date,'%d-%m-%Y') requestdate,priority FROM eq_asset_log al INNER JOIN eq_asset_master am ON al.Asset_id=am.id INNER JOIN eq_problemtype_master pm ON al.PROBLEMID=pm.problemtypeid where Log_request_date >= '" + ucfromdate.GetDateForDataBase() + "' and Log_request_date <='" + uctodate.GetDateForDataBase() + "' AND REQUISTATION_STATUS='Accepted' and maintenance_status='Warrenty' and iscompleted='0'";


        if (ddlpriority.SelectedValue != "Select")
        {
            str += " and priority='" + ddlpriority.SelectedValue + "'";
        }

        if (ddlloc.SelectedValue != "Select")
        {
            str += " and locid='" + ddlloc.SelectedValue + "'";
        }
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            grddetail.DataSource = dt;
            grddetail.DataBind();
        }
        else
        {
            grddetail.DataSource = null;
            grddetail.DataBind();
            lblMsg.Text = "No Record Found";
        }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        search();
    }


   
    protected void grddetail_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        lblMsg.Text = "";
        string id = Util.GetString(e.CommandArgument);

        if (e.CommandName == "EditData")
        {
            bindassetdetail(id);
        }
    }

    private void bindassetdetail(string id)
    {
        DataTable dt = StockReports.GetDataTable(@"SELECT al.id,am.serialno,al.Asset_code,al.Log_request_date,al.Complaint,al.Required_date,al.remark,lm.locationname,pm.problemtypename,em.name,flm.ledgername,al.assigment
 FROM eq_asset_log al INNER JOIN eq_asset_master am ON al.Asset_id=am.id INNER JOIN eq_problemtype_master pm ON pm.ProblemtypeID=al.PROBLEMID
 INNER JOIN eq_location_master lm ON al.locid=lm.locationid INNER JOIN employee_master em ON em.employee_id=al.Requestby INNER JOIN eq_asset_location_master
 alm ON alm.assetid=al.asset_id INNER JOIN f_ledgermaster flm ON flm.ledgernumber=alm.departmentid WHERE al.id='" + id + "'");
        if (dt != null && dt.Rows.Count > 0)
        {
            txtreq.Text = dt.Rows[0][0].ToString();
            txtserial.Text = dt.Rows[0][1].ToString();
            txtasset.Text = dt.Rows[0][2].ToString();
            ucreqdate.FillDatabaseDate(dt.Rows[0][3].ToString());
            txtcou.Text = dt.Rows[0][4].ToString();
            ucrequireddate.FillDatabaseDate(dt.Rows[0][5].ToString());
            txtremark.Text = dt.Rows[0][6].ToString();
            txtlocation.Text = dt.Rows[0][7].ToString();
            txtnop.Text = dt.Rows[0][8].ToString();
            txtreqby.Text = dt.Rows[0][9].ToString();
            txtdept.Text = dt.Rows[0][10].ToString();
            txtassig.Text = dt.Rows[0]["assigment"].ToString();
            //tabcon.ActiveTabIndex = 1;

            pnl.Visible = true;
        }
    }

    DataTable createdatatable()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("itemid");
        dt.Columns.Add("Itemname");
        dt.Columns.Add("Qty");
        return dt;
    }
    protected void btnadd_Click(object sender, EventArgs e)
    {
        DataTable dt;
        if (ViewState["itemgrid"] == null)
        {
            dt = createdatatable();
        }
        else
        {
            dt = (DataTable)ViewState["itemgrid"];
        }

        DataRow dw = dt.NewRow();

        dw["itemid"] = ddlitem.SelectedValue;
        dw["itemname"] = ddlitem.SelectedItem.Text;
        dw["Qty"] = txtqty.Text;

        dt.Rows.Add(dw);

        ViewState["itemgrid"] = dt;
        gridacc.DataSource = dt;
        gridacc.DataBind();
    }
    protected void btnsave_Click(object sender, EventArgs e)
    {
        if (btnsave.Text == "Save")
        {
            savedata();
            bindwarrenty();
        }
        else
        {
            updatedata();
            bindwarrenty();
        }
        
    }


    protected void btnclear_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        btnsave.Text = "Save";
        pnl.Visible = false;
    }
    protected void gridacc_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "imbRemove")
        {
            int index = Util.GetInt(e.CommandArgument);
            DataTable dtItem = (DataTable)ViewState["itemgrid"];
            dtItem.Rows[index].Delete();
            dtItem.AcceptChanges();
            ViewState["itemgrid"] = dtItem;

            gridacc.DataSource = dtItem;
            gridacc.DataBind();
            lblMsg.Text = "";
        }
    }


    void savedata()
    {
        MySqlConnection conn = Util.GetMySqlCon();
        conn.Open();
        try
        {

            string str = "";


            str = @"INSERT INTO eq_asset_warranty_maintenance(REQUITIONID,MAINTENANCE_DATE,DOWNTIME,DAYS,MAINTENANCE_COST,ACTUAL_FAULT,DONE_BY,MAINTENANCE_CATEGORY
,LOG_DATE,insertby,insertdate,ipnumber) VALUES
                      ('" + txtreq.Text + "','" + (Util.GetDateTime(ucsfrom.GetDateForDisplay())).ToString("yyyy-MM-dd") + "','" + txtdownperiod.Text + "','" + txtdays.Text + "','" + txtmaincost.Text + "','" + txtactualcost.Text + "','','" + ddlmain.SelectedItem.Text + "',Now(),'" + ViewState["ID"].ToString() + "',Now(),'" + ViewState["IPAddress"].ToString() + "')";


            StockReports.ExecuteDML(str);

            string insid = StockReports.ExecuteScalar("Select max(id) from eq_asset_outside_maintenance");
            foreach (GridViewRow dw in gridacc.Rows)
            {
                Label lb = (Label)dw.FindControl("lb1");
                Label lb1 = (Label)dw.FindControl("lb2");
                string query = "INSERT INTO eq_spare_parts_utilization_war (ITEMID,QTY,WARRANTYID) VALUES ('"+lb.Text+"','"+lb1.Text +"','"+insid+"')";
                StockReports.ExecuteDML(query);
            }

            str = "update eq_asset_log set completeddate=Now(),iscompleted='1' where id='" + txtreq.Text + "'";
            StockReports.ExecuteDML(str);
            conn.Close();
            conn.Dispose();

            lblMsg.Text = "Record Saved";

            btnsave.Text = "Save";




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


    protected void gridviewoutdetail_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string id = Util.GetString(e.CommandArgument);
        DataTable dt = StockReports.GetDataTable(@"SELECT * FROM eq_asset_warranty_maintenance WHERE id='"+id+"'");

        if (dt.Rows.Count > 0)
        {
            bindassetdetail(dt.Rows[0][1].ToString());
            ucfromdate.FillDatabaseDate(dt.Rows[0][2].ToString());
            txtdownperiod.Text = dt.Rows[0][3].ToString();
            txtdays.Text = dt.Rows[0][4].ToString();
            txtmaincost.Text = dt.Rows[0][5].ToString();
            txtactualcost.Text = dt.Rows[0][6].ToString();
            bindmaintennance();
            ddlmain.SelectedItem.Text = dt.Rows[0][8].ToString();
            ViewState["uid"] = dt.Rows[0]["id"].ToString();
            btnsave.Text = "Update";

            DataTable dtt = StockReports.GetDataTable("SELECT wa.*,im.typename itemname FROM eq_spare_parts_utilization_war wa INNER JOIN f_itemmaster im ON im.itemid=wa.itemid  WHERE warrantyid='"+id+"'");
            gridacc.DataSource = dtt;
            gridacc.DataBind();
            ViewState["itemgrid"] = dtt;

        }

    }

    void updatedata()
    {
        MySqlConnection conn = Util.GetMySqlCon();
        conn.Open();
        try
        {

            string str = "";

            str = @"update eq_asset_warranty_maintenance set MAINTENANCE_DATE='" + (Util.GetDateTime(ucsfrom.GetDateForDisplay())).ToString("yyyy-MM-dd") + "',DOWNTIME='" + txtdownperiod.Text + "',days='"+txtdays.Text +"',MAINTENANCE_COST='"+txtmaincost.Text+"',ACTUAL_FAULT='"+txtactualcost.Text+"',MAINTENANCE_CATEGORY='"+ddlmain.SelectedItem.Text+"' where id='" + ViewState["uid"].ToString() + "' ";
           


            StockReports.ExecuteDML(str);

            StockReports.ExecuteDML("delete from eq_spare_parts_utilization_war where WARRANTYID='"+ViewState["uid"].ToString()+"'");
            foreach (GridViewRow dw in gridacc.Rows)
            {
                Label lb = (Label)dw.FindControl("lb1");
                Label lb1 = (Label)dw.FindControl("lb2");
                string query = "INSERT INTO eq_spare_parts_utilization_war (ITEMID,QTY,WARRANTYID) VALUES ('" + lb.Text + "','" + lb1.Text + "','" + ViewState["uid"].ToString() + "')";
                StockReports.ExecuteDML(query);
            }

           
            conn.Close();
            conn.Dispose();

            lblMsg.Text = "Record Updated";

            btnsave.Text = "Save";




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

}