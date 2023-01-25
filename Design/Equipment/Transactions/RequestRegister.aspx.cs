using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Equipment_Transactions_RequestRegiste : System.Web.UI.Page
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
            bindproblem();
            bindmain();
            ucrequestdate.FillDatabaseDate(DateTime.Now.ToString());
            ucrequireddate.FillDatabaseDate(DateTime.Now.ToString());


        }
    }


    private void bindmain()
    {
        DataTable dt = StockReports.GetDataTable(@"SELECT al.REQUISTATION_STATUS,al.id, problemtypename,itemname,DATE_FORMAT(al.Required_date,'%d-%m-%Y') 
requireddate,DATE_FORMAT(al.Log_request_date,'%d-%m-%Y') requestdate,priority,(CASE WHEN iscompleted='1'  THEN 'Complete' ELSE 'Incomplete' END) com FROM eq_asset_log al
 INNER JOIN eq_asset_master am ON al.Asset_id=am.id INNER JOIN eq_problemtype_master pm ON al.PROBLEMID=pm.problemtypeid WHERE ISCLOSED=0");

        grddetail.DataSource = dt;
        grddetail.DataBind();

    }
    private void bindproblem()
    {
        DataTable dt = StockReports.GetDataTable(@"SELECT problemtypeid,problemtypename FROM eq_problemtype_master WHERE isactive=1");

        ddlproblem.DataSource = dt;
        ddlproblem.DataTextField = "problemtypename";
        ddlproblem.DataValueField = "problemtypeid";
        ddlproblem.DataBind();
        ddlproblem.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        ddlproblem.SelectedIndex = 0;
    }

    private void bindasset()
    {
        DataTable dt = StockReports.GetDataTable(@"SELECT id,itemname from eq_asset_master");

        ddlasset.DataSource = dt;
        ddlasset.DataTextField = "itemname";
        ddlasset.DataValueField = "id";
        ddlasset.DataBind();
        ddlasset.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        ddlasset.SelectedIndex = 0;

    }
    protected void ddlasset_SelectedIndexChanged(object sender, EventArgs e)
    {
        DataTable dt = StockReports.GetDataTable(@"SELECT itemname,locationname,floorname,roomname,am.serialno,am.modelno,ledgername,am.assetcode,lm.locationid
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
            lb.Text=dt.Rows[0]["assetcode"].ToString();
            lb0.Text = dt.Rows[0][8].ToString();
            

        }
    }
    protected void btnsave_Click(object sender, EventArgs e)
    {
        if (btnsave.Text == "Save")
        {
            savedata();
        }
        else
        {
            updatedata();
        }

    }

    void savedata()
    {
        MySqlConnection conn = Util.GetMySqlCon();
        conn.Open();

        try
        {
            string priority = "";
            string str = "";
            if (rbregular.Checked)
            {
                priority = "Regular";
            }
            else
            {
                priority = "Emergency";
            }

            str = @"INSERT INTO eq_asset_log (asset_id,asset_code,Log_request_date,complaint,required_date,requestby,problemid,remark,priority,locid,REQUISTATION_STATUS,iscompleted,isclosed) VALUES
('" + ddlasset.SelectedValue + "','"+lb.Text+"','" + (Util.GetDateTime(ucrequestdate.GetDateForDisplay())).ToString("yyyy-MM-dd") + "','" + txtcomentry.Text + "','" + (Util.GetDateTime(ucrequireddate.GetDateForDisplay())).ToString("yyyy-MM-dd") + "','"+ViewState["ID"].ToString()+"','"+ddlproblem.SelectedValue+"','"+txtremark.Text+"','"+priority+"','"+lb0.Text+"','Pending','0','0')";
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
    void updatedata()
    {
        MySqlConnection conn = Util.GetMySqlCon();
        conn.Open();

        try
        {
            string priority = "";
            string str = "";
            if (rbregular.Checked)
            {
                priority = "Regular";
            }
            else
            {
                priority = "Emergency";
            }
            str = @"update eq_asset_log set asset_id='" + ddlasset.SelectedValue + "',asset_code='" + lb.Text + "',complaint='" + txtcomentry.Text + "',required_date='" + (Util.GetDateTime(ucrequireddate.GetDateForDisplay())).ToString("yyyy-MM-dd") + "',problemid='"+ddlproblem .SelectedValue+"',remark='"+txtremark.Text+"',priority='"+priority+"' where id='"+ViewState["uid"].ToString()+"'";
           
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
        ucrequestdate.FillDatabaseDate(DateTime.Now.ToString());
        ucrequireddate.FillDatabaseDate(DateTime.Now.ToString());

        ddlasset.SelectedIndex = 0;
        ddlproblem.SelectedIndex = 0;

        txtserial.Text = "";
        txtmodel.Text = "";
        txtdept.Text = "";
        txtlocation.Text = "";

        txtprobdesc.Text = "";
        txtcalltypedesc.Text = "";
        txtcalltype.Text = "";

        rbemer.Checked = false;
        rbregular.Checked = true;
        btnsave.Text = "Save";

        txtremark.Text = "";
        txtcomentry.Text = "";
        lb.Text = "";
        lblMsg.Text = "";

        btnsave.Enabled = true;
    }
    protected void ddlproblem_SelectedIndexChanged(object sender, EventArgs e)
    {
        DataTable dt = StockReports.GetDataTable(@"SELECT calltypename,pm.description pdes,cm.description cdesc  FROM eq_problemtype_master pm INNER JOIN eq_calltype_master cm ON pm.calltypeid=cm.calltypeid WHERE problemtypeid='" + ddlproblem.SelectedValue + "'");


        if (dt.Rows.Count > 0)
        {
            txtprobdesc.Text = dt.Rows[0][1].ToString();
            txtcalltypedesc .Text = dt.Rows[0][2].ToString();
            txtcalltype.Text =dt.Rows[0][0].ToString();
           


        }
    }
    protected void grddetail_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        lblMsg.Text = "";
        string id = Util.GetString(e.CommandArgument);

        if (e.CommandName == "EditData")
        {
            DataTable dt = StockReports.GetDataTable("SELECT * FROM eq_asset_log WHERE id='" + id + "'");
            if (dt != null && dt.Rows.Count > 0)
            {
                ddlasset.SelectedValue = dt.Rows[0][1].ToString();
                ddlasset_SelectedIndexChanged(sender, e);

                ucrequestdate.FillDatabaseDate(dt.Rows[0][3].ToString());
                txtcomentry.Text=dt.Rows[0][4].ToString();
                ucrequireddate.FillDatabaseDate(dt.Rows[0][5].ToString());

                ddlproblem.SelectedValue =dt.Rows[0][11].ToString();
                ddlproblem_SelectedIndexChanged(sender,e);

                txtremark.Text = dt.Rows[0][12].ToString();

               if(dt.Rows[0]["priority"].ToString()=="Regular")
               {
                    rbregular.Checked=true;
               }
               else if(dt.Rows[0]["priority"].ToString()=="Emergency")
               {
                   rbemer.Checked=true;
               }
               else
               {
                    rbregular.Checked=false;
                    rbregular.Checked=false;
               }
               if (dt.Rows[0]["REQUISTATION_STATUS"].ToString() == "Accepted")
                {
                    btnsave.Enabled = false;
                    lblMsg.Text = "You can not Edit. This Request is Accepted.";
                }
                btnsave.Text = "Update";
                ViewState["uid"] = id;

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