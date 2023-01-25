using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Equipment_Transactions_RequestAcceptance : System.Web.UI.Page
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


        }
    }


    void bindlocation()
    {
        DataTable dt = StockReports.GetDataTable("SELECT locationid,locationname FROM eq_location_master WHERE isactive=1");

        ddlloc.DataSource = dt;
        ddlloc.DataTextField = "locationname";
        ddlloc.DataValueField = "locationid";
        ddlloc.DataBind();
        ddlloc.Items.Insert(0, new ListItem("Select","Select"));
        ddlloc.SelectedIndex = 0;
    }
    protected void grddetail_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        lblMsg.Text = "";
        string id = Util.GetString(e.CommandArgument);

        if (e.CommandName == "EditData")
        {
            DataTable dt = StockReports.GetDataTable(@"SELECT al.id,am.serialno,al.Asset_code,al.Log_request_date,al.Complaint,al.Required_date,al.remark,lm.locationname,pm.problemtypename,em.name,flm.ledgername
 FROM eq_asset_log al INNER JOIN eq_asset_master am ON al.Asset_id=am.id INNER JOIN eq_problemtype_master pm ON pm.ProblemtypeID=al.PROBLEMID
 INNER JOIN eq_location_master lm ON al.locid=lm.locationid INNER JOIN employee_master em ON em.employee_id=al.Requestby INNER JOIN eq_asset_location_master
 alm ON alm.assetid=al.asset_id INNER JOIN f_ledgermaster flm ON flm.ledgernumber=alm.departmentid WHERE al.id='"+id+"'");
            if (dt != null && dt.Rows.Count > 0)
            {
              txtreq.Text=dt.Rows[0][0].ToString();
              txtserial.Text = dt.Rows[0][1].ToString();
              txtasset.Text = dt.Rows[0][2].ToString();
              ucreqdate.FillDatabaseDate(dt.Rows[0][3].ToString());
              txtcou.Text =dt.Rows[0][4].ToString();
              ucrequireddate.FillDatabaseDate(dt.Rows[0][5].ToString());
              txtremark.Text = dt.Rows[0][6].ToString();
              txtlocation.Text = dt.Rows[0][7].ToString();
              txtnop.Text =dt.Rows[0][8].ToString();
              txtreqby.Text =dt.Rows[0][9].ToString();
              txtdept.Text =dt.Rows[0][10].ToString();

              pnl.Visible = true;

            }
        }
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        search();
    }

    private void search()
    {
        string str = "SELECT al.id, problemtypename,itemname,DATE_FORMAT(al.Required_date,'%d-%m-%Y') requireddate,DATE_FORMAT(al.Log_request_date,'%d-%m-%Y') requestdate,priority FROM eq_asset_log al INNER JOIN eq_asset_master am ON al.Asset_id=am.id INNER JOIN eq_problemtype_master pm ON al.PROBLEMID=pm.problemtypeid where Log_request_date >= '" + ucfromdate.GetDateForDataBase() + "' and Log_request_date <='" + uctodate.GetDateForDataBase() + "' AND REQUISTATION_STATUS='Pending'";


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
    protected void btn_save_Click(object sender, EventArgs e)
    {
        savedata();
        //search();
        //tabcon.ActiveTabIndex = 1;
    }


    void savedata()
    {
        MySqlConnection conn = Util.GetMySqlCon();
        conn.Open();

        try
        {
            
            string str = "";

            if(txtreq.Text =="")
            {
                lblMsg0.Text = "Please Select Any Request";
                return;
            }
            if (ddlregstatus .SelectedValue =="Select")
            {
                lblMsg0.Text = "Please Select Requisition Status";
                return;
            }

            if (ddlmainttype.SelectedValue == "Select")
            {
                lblMsg0.Text = "Please Select Maintenance Status";
                return;
            }
            if (ddlregstatus.SelectedValue == "Accepted")
            {
                str = @"update eq_asset_log set REQUISTATION_STATUS='" + ddlregstatus.SelectedValue + "',MAINTENANCE_STATUS='" + ddlmainttype.SelectedValue + "',ASSIGMENT='" + txtassig.Text + "',ISRENDERED_TO_MAINT='1', Acceptedby='" + ViewState["ID"].ToString() + "' ,AcceptedDate=Now() where id='" + txtreq.Text+ "'";
            }
            else
            {
                str = @"update eq_asset_log set REQUISTATION_STATUS='" + ddlregstatus.SelectedValue + "', rejectedby='" + ViewState["ID"].ToString() + "', rejectedDate=Now(), rejection_reason='"+txtre.Text+"' where id='" + ViewState["uid"].ToString() + "'";
            }

            StockReports.ExecuteDML(str);
            conn.Close();
            conn.Dispose();

            lblMsg.Text = "Record Saved";
           

        }
        catch (Exception ex)
        {

            conn.Close();
            conn.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg0.Text = ex.Message;
        }
    }
    protected void btn_clear_Click(object sender, EventArgs e)
    {
        pnl.Visible = false;
        lblMsg.Text = "";

    }
    protected void ddlregstatus_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlregstatus.SelectedValue == "Rejected")
        {
            lbre.Visible = true;
            txtre.Visible = true;
        }
        else
        {
            lbre.Visible = false;
            txtre.Visible = false;
        }
    }
}