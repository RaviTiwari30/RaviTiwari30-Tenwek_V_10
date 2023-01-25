using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Equipment_Transactions_InHouseMaintenace : System.Web.UI.Page
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
            ucfromdate.FillDatabaseDate(DateTime.Now.ToString());
            uctodate.FillDatabaseDate(DateTime.Now.ToString());
            uccomplete .FillDatabaseDate(DateTime.Now.ToString());
            ucworked.FillDatabaseDate(DateTime.Now.ToString());
            insidedetail();

            bindtechnician();
            binditem();

        }
    }

    void insidedetail()
    {
        string str = @"SELECT itemname,aim.id,time_spent,DATE_FORMAT(completed_date,'%d-%m-%Y')cdate,feedback FROM eq_asset_inside_maintenance aim 
INNER JOIN eq_asset_log al ON al.id=aim.requitionid
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
        string str = "SELECT distinct im.TypeName ItemName,im.ItemID from f_Itemmaster im inner join f_subcategorymaster sc on im.subcategoryid = sc.subcategoryid " +
           " inner join f_configrelation cf on cf.CategoryID = sc.CategoryID Where im.isActive=1 and sc.Active=1 and cf.IsActive=1 and cf.ConfigID in (11,28) AND sc.categoryid='LSHHI24'";


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


    void bindtechnician()
    {
        DataTable dt = StockReports.GetDataTable("select technicianname,technicianid from eq_technician_master where isactive=1");

        ddltech.DataSource = dt;
        ddltech.DataTextField = "technicianname";
        ddltech.DataValueField = "technicianid";
        ddltech.DataBind();

        ddltech.Items.Insert(0, new ListItem("Select","Select"));
        ddltech.SelectedIndex = 0;
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
        string str = "SELECT al.id, problemtypename,itemname,DATE_FORMAT(al.Required_date,'%d-%m-%Y') requireddate,DATE_FORMAT(al.Log_request_date,'%d-%m-%Y') requestdate,priority FROM eq_asset_log al INNER JOIN eq_asset_master am ON al.Asset_id=am.id INNER JOIN eq_problemtype_master pm ON al.PROBLEMID=pm.problemtypeid where Log_request_date >= '" + ucfromdate.GetDateForDataBase() + "' and Log_request_date <='" + uctodate.GetDateForDataBase() + "' AND REQUISTATION_STATUS='Accepted' and maintenance_status='In House' and iscompleted='0'";


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
            if (ch1.Checked)
            {
                savedata();
            }
            else if (ch2.Checked)
            {
                transfer();
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



            str = @" update eq_asset_inside_maintenance  set Completed_date='"+(Util.GetDateTime(uccomplete.GetDateForDisplay())).ToString("yyyy-MM-dd")+"',FEEDBACK='"+txtfeedback.Text+"' where id='"+ViewState["uid"].ToString()+"'";



            StockReports.ExecuteDML(str);

            str = "delete from eq_spare_parts_utilization where INHOUSEID='"+ViewState["uid"].ToString()+"'";
            StockReports.ExecuteDML(str);

            str = "delete from eq_technician_entry where INHOUSEID='" + ViewState["uid"].ToString() + "'";
            StockReports.ExecuteDML(str);
            foreach (GridViewRow dw in gridacc.Rows)
            {
                Label lb = (Label)dw.FindControl("lb1");
                Label lb1 = (Label)dw.FindControl("lb2");
                string query = "insert into eq_spare_parts_utilization(ITEMID,INHOUSEID,QTY) values ('" + lb.Text + "','" + ViewState["uid"].ToString() + "','" + lb1.Text + "')";
                StockReports.ExecuteDML(query);
            }

            foreach (GridViewRow dw in grdtech.Rows)
            {
                Label lb = (Label)dw.FindControl("lb1");
                Label lb1 = (Label)dw.FindControl("lb2");
                Label lb2 = (Label)dw.FindControl("lb3");
                Label lb3 = (Label)dw.FindControl("lb4");
                string query = "insert into eq_technician_entry(TECHNICAINID,TIME_SPENT,INHOUSEID,WORKEDDATE,REMARK) values ('" + lb.Text + "','" + lb2.Text + "','" +ViewState["uid"].ToString() + "','" + (Util.GetDateTime(lb1.Text)).ToString("yyyy-MM-dd") + "','" + lb3.Text + "')";
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
    protected void btnclear_Click(object sender, EventArgs e)
    {
        pnl.Visible = false;
        btnsave.Text = "Save";
        ch1.Enabled = true;
        ch2.Enabled = true;
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


          




            str = @" INSERT INTO eq_asset_inside_maintenance
            (REQUITIONID,Completed_date,FEEDBACK,LOG_DATE,ISCOMPLETD,insertby,insertdate,ipaddress)
VALUES ('" + txtreq.Text + "','" + (Util.GetDateTime(uccomplete.GetDateForDisplay())).ToString("yyyy-MM-dd") + "','" + txtfeedback.Text + "',Now(),'1','" + ViewState["ID"].ToString() + "',Now(),'" + ViewState["IPAddress"].ToString() + "')";


            StockReports.ExecuteDML(str);

            string insid = StockReports.ExecuteScalar("Select max(id) from eq_asset_inside_maintenance");
            foreach (GridViewRow dw in gridacc.Rows)
            {
                Label lb = (Label)dw.FindControl("lb1");
                Label lb1 = (Label)dw.FindControl("lb2");
                string query = "insert into eq_spare_parts_utilization(ITEMID,INHOUSEID,QTY) values ('" + lb.Text + "','" + insid + "','" + lb1.Text + "')";
                StockReports.ExecuteDML(query);
            }

            foreach (GridViewRow dw in grdtech.Rows)
            {
                Label lb = (Label)dw.FindControl("lb1");
                Label lb1 = (Label)dw.FindControl("lb2");
                Label lb2 = (Label)dw.FindControl("lb3");
                Label lb3 = (Label)dw.FindControl("lb4");
                string query = "insert into eq_technician_entry(TECHNICAINID,TIME_SPENT,INHOUSEID,WORKEDDATE,REMARK) values ('" + lb.Text + "','" + lb2.Text + "','" + insid + "','" + (Util.GetDateTime(lb1.Text)).ToString("yyyy-MM-dd") + "','" + lb3.Text + "')";
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
('" + dt.Rows[0][0].ToString() + "','" + dt.Rows[0][1].ToString() + "','" + (Util.GetDateTime(dt.Rows[0][2].ToString())).ToString("yyyy-MM-dd") + "','" + dt.Rows[0][3].ToString() + "','" + (Util.GetDateTime(dt.Rows[0][4].ToString())).ToString("yyyy-MM-dd") + "','" + dt.Rows[0][5].ToString() + "','" + dt.Rows[0][6].ToString() + "','" + dt.Rows[0][7].ToString() + "','" + dt.Rows[0][8].ToString() + "','" + dt.Rows[0][9].ToString() + "','Accepted','0','" + dt.Rows[0][10].ToString() + "','Out House','" + dt.Rows[0][11].ToString() + "','" + (Util.GetDateTime(dt.Rows[0][12].ToString())).ToString("yyyy-MM-dd") + "','0')";
                StockReports.ExecuteDML(str);


            }

            str = "UPDATE eq_asset_log SET ISCLOSED=1, CLOSING_REASON='" + txtresonoftr.Text + "', CLOSING_DATE=NOW(), ISCOMPLETED='1'  WHERE id='" + txtreq.Text + "'";
            StockReports.ExecuteDML(str);
            lblMsg.Text = "Request Transferd";

            btnsave.Text = "Save";

            conn.Close();
            conn.Dispose();
        }
        catch (Exception ex)
        {
            conn.Close();
            conn.Dispose();
            lblMsg.Text = ex.Message;
        }
    }
   
  
   

    protected void ch1_CheckedChanged(object sender, EventArgs e)
    {
        if (ch1.Checked == true)
        {
            pnl2.Visible = false;
            pnl1.Visible = true;
           
        }
        else
        {
            pnl2.Visible = true;
            pnl1.Visible = false;
           
        }
    }
    protected void ch2_CheckedChanged(object sender, EventArgs e)
    {
        if (ch2.Checked == true)
        {
            pnl2.Visible = true;
            pnl1.Visible = false;
        }
        else
        {
            pnl2.Visible = false;
            pnl1.Visible = true;
        }
    }



    DataTable createdatatabletech()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("techid");
        dt.Columns.Add("techname");
        dt.Columns.Add("remark");
        dt.Columns.Add("time");
        dt.Columns.Add("wdate");
        return dt;
    }
    protected void btnaddtech_Click(object sender, EventArgs e)
    {
        DataTable dt;
        if (ViewState["techgrid"] == null)
        {
            dt = createdatatabletech();
        }
        else
        {
            dt = (DataTable)ViewState["techgrid"];
        }

        DataRow dw = dt.NewRow();

        dw["techid"] = ddltech.SelectedValue;
        dw["techname"] = ddltech.SelectedItem.Text;
        dw["time"] = txttimespent.Text;
        dw["remark"] = txtremarkbytech.Text;
        dw["wdate"] = ucworked.GetDateForDataBase(); 


        dt.Rows.Add(dw);

        ViewState["techgrid"] = dt;

        grdtech.DataSource = dt;
        grdtech.DataBind();
    }
    protected void grdtech_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "imbRemove")
        {
            int index = Util.GetInt(e.CommandArgument);
            DataTable dtItem = (DataTable)ViewState["techgrid"];
            dtItem.Rows[index].Delete();
            dtItem.AcceptChanges();
            ViewState["techgrid"] = dtItem;

            grdtech.DataSource = dtItem;
            grdtech.DataBind();
            lblMsg.Text = "";
        }
    }
    protected void gridviewoutdetail_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        lblMsg.Text = "";
        string id = Util.GetString(e.CommandArgument);
        DataTable dt = StockReports.GetDataTable(@" SELECT id,completed_date,feedback FROM eq_asset_inside_maintenance WHERE id=1");
        if (dt.Rows.Count > 0)
        {
            bindrequision(dt.Rows[0]["id"].ToString());
            txtfeedback.Text = dt.Rows[0]["feedback"].ToString();
            uccomplete.FillDatabaseDate(dt.Rows[0]["completed_date"].ToString());
            ViewState["uid"] = dt.Rows[0]["id"].ToString();

            DataTable dtt = StockReports.GetDataTable(@"SELECT sp.*,typename itemname FROM eq_spare_parts_utilization sp INNER JOIN f_itemmaster im ON im.itemid=sp.itemid WHERE inhouseid='"+dt.Rows[0]["id"].ToString()+"' ");

            gridacc.DataSource = dtt;
            gridacc.DataBind();
            ViewState["itemgrid"] = dtt;



            DataTable dtt1 = StockReports.GetDataTable(@"SELECT tm.technicianname techname,te.technicainid techid,time_spent time,DATE_FORMAT(workeddate,'%d-%m-%Y') wdate,remark FROM eq_technician_entry te INNER JOIN eq_technician_master tm ON tm.technicianid=te.technicainid WHERE inhouseid=" + dt.Rows[0]["id"].ToString() + "");
            ViewState["techgrid"]=dtt1;
            grdtech.DataSource = dtt1;
            grdtech.DataBind();
            btnsave.Text = "Update";
            ch1.Enabled = false;
            ch2.Enabled = false;
        }

    }
}