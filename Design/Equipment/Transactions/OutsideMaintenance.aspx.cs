using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Equipment_Transactions_OutsideMaintenance : System.Web.UI.Page
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
            outsidedetail();
            ucfromdate.FillDatabaseDate(DateTime.Now.ToString());
            uctodate.FillDatabaseDate(DateTime.Now.ToString());
            ucsfrom.FillDatabaseDate(DateTime.Now.ToString());
            ucsto.FillDatabaseDate(DateTime.Now.ToString());


        }
    }
    void outsidedetail()
    {
        string str = @"SELECT itemname,aom.id,MATERIAL_COST,manpower_cost,EXTERNAL_ORDER_COST,DATE_FORMAT(SCHEDULED_FR_DATE,'%d-%m-%Y')sfrmdate,
DATE_FORMAT(SCHEDULED_To_DATE,'%d-%m-%Y')stodate FROM eq_asset_outside_maintenance aom INNER JOIN eq_asset_log al ON al.id=aom.requisitionid
 INNER JOIN eq_asset_master am ON al.asset_id=am.id ";

        
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            gridviewoutdetail.DataSource = dt;
            gridviewoutdetail.DataBind();
        }
        else
        {
            gridviewoutdetail.DataSource = null;
            gridviewoutdetail.DataBind();
            //lblMsg.Text = "No Record Found";
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
        string str = "SELECT al.id, problemtypename,itemname,DATE_FORMAT(al.Required_date,'%d-%m-%Y') requireddate,DATE_FORMAT(al.Log_request_date,'%d-%m-%Y') requestdate,priority FROM eq_asset_log al INNER JOIN eq_asset_master am ON al.Asset_id=am.id INNER JOIN eq_problemtype_master pm ON al.PROBLEMID=pm.problemtypeid where Log_request_date >= '" + ucfromdate.GetDateForDataBase() + "' and Log_request_date <='" + uctodate.GetDateForDataBase() + "' AND REQUISTATION_STATUS='Accepted' and maintenance_status='Out House' and iscompleted='0'";


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
            pnl.Visible = false;
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
            bindrequision(id);
        }
    }

    private void bindrequision(string id)
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
            pnl.Visible = true;


        }
    }

    DataTable createdatatable()
    {
        DataTable dt=new DataTable ();
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
            if (CheckBox1.Checked == true)
            {
                transfer();
            }
            else
            {
                savedata();
            }
        }
        else
        {
            updatedata();
        }
    }
    void updatedata()
    {
        MySqlConnection conn = Util.GetMySqlCon();
        conn.Open();
        try
        {

            string str = "";


            int insclaim = 0;

            if (rb1.Checked)
                insclaim = 1;


            str = @"update eq_asset_outside_maintenance set MATERIAL_COST='"+txtmaterialcost.Text+"',MANPOWER_COST='"+txtmanpowercost.Text+"',EXTERNAL_ORDER_COST='"+txtothercost.Text+"',INSURANCE_CLAIM='"+insclaim+"',SCHEDULED_FR_DATE='"+ (Util.GetDateTime(ucsfrom.GetDateForDisplay())).ToString("yyyy-MM-dd")+"',SCHEDULED_TO_DATE='"+(Util.GetDateTime(ucsto.GetDateForDisplay())).ToString("yyyy-MM-dd") +"',remark='"+txtcostremark.Text+"' where id='"+ViewState["uid"].ToString()+"'";


            StockReports.ExecuteDML(str);
            str = @"delete from eq_spare_parts_outhouse_utilid where OUTHOUSEID='"+ViewState["uid"].ToString()+"'";
            StockReports.ExecuteDML(str);
           
            foreach (GridViewRow dw in gridacc.Rows)
            {
                Label lb = (Label)dw.FindControl("lb1");
                Label lb1 = (Label)dw.FindControl("lb2");
                string query = "insert into eq_spare_parts_outhouse_utilid(ITEMID,OUTHOUSEID,QTY) values ('" + lb.Text + "','" + ViewState["uid"].ToString() + "','" + lb1.Text + "')";
                StockReports.ExecuteDML(query);
            }

            str = "update eq_asset_log set completeddate=Now(),iscompleted='1' where id='" + txtreq.Text + "'";
            StockReports.ExecuteDML(str);
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
    
    protected void btnclear_Click(object sender, EventArgs e)
    {
        CheckBox1.Enabled = true;
        pnl.Visible = false;
        btnsave.Text = "Save";
        lblMsg.Text = "";
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
           
           
            int insclaim = 0;

            if (rb1.Checked)
                insclaim = 1;


            str = @"INSERT INTO eq_asset_outside_maintenance(RequisitionId,MATERIAL_COST,MANPOWER_COST,EXTERNAL_ORDER_COST,APPPROVED_BY,INSURANCE_CLAIM,
SCHEDULED_FR_DATE,SCHEDULED_TO_DATE,JOB_DESCRIPTION,insertby,insertdate,ipaddress,remark) VALUES
                      ('" + txtreq.Text + "','" + txtmaterialcost.Text + "','" + txtmanpowercost.Text + "','" + txtothercost.Text + "','" + ViewState["ID"].ToString() + "','" + insclaim + "','" + (Util.GetDateTime(ucsfrom.GetDateForDisplay())).ToString("yyyy-MM-dd") + "','" + (Util.GetDateTime(ucsto.GetDateForDisplay())).ToString("yyyy-MM-dd") + "','" + txtassig.Text + "','" + ViewState["ID"].ToString() + "',Now(),'" + ViewState["IPAddress"].ToString() + "','"+txtcostremark.Text+"')";


            StockReports.ExecuteDML(str);

            string insid = StockReports.ExecuteScalar("Select max(id) from eq_asset_outside_maintenance");
            foreach (GridViewRow dw in gridacc.Rows)
            {
                Label lb = (Label)dw.FindControl("lb1");
                Label lb1 = (Label)dw.FindControl("lb2");
                string query = "insert into eq_spare_parts_outhouse_utilid(ITEMID,OUTHOUSEID,QTY) values ('" + lb.Text + "','" + insid + "','" + lb1.Text+ "')";
                StockReports.ExecuteDML(query);
            }

            str = "update eq_asset_log set completeddate=Now(),iscompleted='1' where id='"+txtreq.Text+"'";
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

    void transfer()
    {
        MySqlConnection conn = Util.GetMySqlCon();
        conn.Open();
        string str = "";
        try
        {
            DataTable dt = StockReports.GetDataTable("select asset_id,asset_code,Log_request_date,complaint,required_date,requestby,problemid,remark,priority,locid,assigment,acceptedby,accepteddate from eq_asset_log where id='" + txtreq.Text + "'");
            if (dt.Rows.Count > 0)
            {

                str = @"INSERT INTO eq_asset_log (asset_id,asset_code,Log_request_date,complaint,required_date,requestby,problemid,remark,priority,locid,REQUISTATION_STATUS,iscompleted,assigment,maintenance_status,acceptedby,accepteddate,isclosed) VALUES
('" + dt.Rows[0][0].ToString() + "','" + dt.Rows[0][1].ToString() + "','" + (Util.GetDateTime(dt.Rows[0][2].ToString())).ToString("yyyy-MM-dd") + "','" + dt.Rows[0][3].ToString() + "','" + (Util.GetDateTime(dt.Rows[0][4].ToString())).ToString("yyyy-MM-dd") + "','" + dt.Rows[0][5].ToString() + "','" + dt.Rows[0][6].ToString() + "','" + dt.Rows[0][7].ToString() + "','" + dt.Rows[0][8].ToString() + "','" + dt.Rows[0][9].ToString() + "','Accepted','0','" + dt.Rows[0][10].ToString() + "','In House','" + dt.Rows[0][11].ToString() + "','" + (Util.GetDateTime(dt.Rows[0][12].ToString())).ToString("yyyy-MM-dd") + "','0')";
                StockReports.ExecuteDML(str);


            }

            str = "UPDATE eq_asset_log SET ISCLOSED=1, CLOSING_REASON='"+textreason.Text+"', CLOSING_DATE=NOW(), ISCOMPLETED='1'  WHERE id='"+txtreq.Text+"'";
            StockReports.ExecuteDML(str);

            conn.Close();
            conn.Dispose();

            lblMsg.Text = "Request Transferd";

            btnsave.Text = "Save";
        }
        catch(Exception ex)
        {
            conn.Close();
            conn.Dispose();
            lblMsg0.Text=ex.Message;
        }
    }
    protected void CheckBox1_CheckedChanged(object sender, EventArgs e)
    {
        if (CheckBox1.Checked == true)
        {
            lbr.Visible = true;
            textreason.Visible = true;
            divcost.Visible = false;
          
        }
        else
        {
            lbr.Visible = false;
            textreason.Visible = false;
            divcost.Visible = true;
          
        }
    }
    protected void gridviewoutdetail_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        lblMsg.Text = "";
        string id = Util.GetString(e.CommandArgument);
        DataTable dt = StockReports.GetDataTable(@"SELECT om.*,em.Name FROM eq_asset_outside_maintenance om INNER JOIN employee_master em ON om.APPPROVED_BY=em.Employee_ID where om.id='" + id + "'");

        if (dt.Rows.Count > 0)
        {
            txtmaterialcost.Text = dt.Rows[0]["MATERIAL_COST"].ToString();
            txtmanpowercost.Text = dt.Rows[0]["MANPOWER_COST"].ToString();
            txtothercost.Text = dt.Rows[0]["EXTERNAL_ORDER_COST"].ToString();
            if (dt.Rows[0]["INSURANCE_CLAIM"].ToString() == "1")
            {
                rb1.Checked = true;
            }
            else
            {
                rb2.Checked = true;
            }
            ViewState["uid"]=dt.Rows[0]["id"].ToString();
            ucsfrom.FillDatabaseDate(dt.Rows[0]["SCHEDULED_FR_DATE"].ToString());
            ucsto.FillDatabaseDate(dt.Rows[0]["SCHEDULED_TO_DATE"].ToString());
            txtcostremark.Text = dt.Rows[0]["remark"].ToString();
            txtapprovedby.Text = dt.Rows[0]["name"].ToString();
            bindrequision(dt.Rows[0]["RequisitionId"].ToString());

            DataTable dtt = StockReports.GetDataTable("SELECT sp.itemid,sp.qty,im.typename itemname FROM eq_spare_parts_outhouse_utilid sp INNER JOIN f_itemmaster im ON im.itemid=sp.itemid WHERE sp.outhouseid='"+dt.Rows[0]["id"]+"' ");

            gridacc.DataSource = dtt;
            gridacc.DataBind();
            ViewState["itemgrid"] = dtt;

            CheckBox1.Enabled = false;

            btnsave.Text = "Update";

        }
    }
}