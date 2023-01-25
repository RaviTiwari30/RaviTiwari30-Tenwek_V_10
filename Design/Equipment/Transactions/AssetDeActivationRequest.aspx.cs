using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Equipment_Transactions_AssetDeActivationRequest : System.Web.UI.Page
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
            BindSupplierList();
            bindemp();
            binddeactivelist();


        }
    }
    private void bindemp()
    {
        DataTable dt = StockReports.GetDataTable(@"SELECT employee_id,NAME FROM employee_master WHERE isactive=1");

        ddlemp .DataSource = dt;
        ddlemp.DataTextField = "NAME";
        ddlemp.DataValueField = "employee_id";
        ddlemp.DataBind();
        ddlemp.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        ddlemp.SelectedIndex = 0;
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
            lb.Text = dt.Rows[0]["assetcode"].ToString();
          


        }
    }


    private void BindSupplierList()
    {


        string str = "Select VendorName,VenLedgerNo from f_vendormaster where isActive=1";



        str += " order by VendorName";

        DataTable dt = StockReports.GetDataTable(str);
        ddlSupplier.DataSource = dt;
        ddlSupplier.DataTextField = "VendorName";
        ddlSupplier.DataValueField = "VenLedgerNo";
        ddlSupplier.DataBind();

        ddlSupplier.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        ddlSupplier.SelectedIndex = 0;
    }
    protected void btnadd_Click(object sender, EventArgs e)
    {
        DataTable dt;
        if (ViewState["empdt"] != null)
        {
            dt = (DataTable)ViewState["empdt"];
        }
        else
        {
            dt = createdatatable();
        }

        DataRow dw = dt.NewRow();
        dw["Empid"] = ddlemp.SelectedValue;
        dw["Empname"] = ddlemp.SelectedItem.Text;

        dt.Rows.Add(dw);

        gridacc.DataSource = dt;
        gridacc.DataBind();
        ViewState["empdt"] = dt;
    }

    DataTable createdatatable()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("Empid");
        dt.Columns.Add("Empname");
        return dt;
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
        binddeactivelist();
    }


    protected void btnclear_Click(object sender, EventArgs e)
    {
        gridacc.DataSource = null;
        gridacc.DataBind();

        ddlasset.SelectedIndex = 0;
        ddlSupplier.SelectedIndex = 0;
        txtaddess.Text = "";
        txtamt.Text = "";
        txtcontact.Text = "";
        txtcontactph.Text = "";
        txtdeact.Text = "";
        txtmodel.Text = "";
        txtremark.Text = "";
        txtserial.Text = "";
        btnsave.Text = "Save";

    }
    protected void grddetail_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        lblMsg.Text = "";
        string id = Util.GetString(e.CommandArgument);

        if (e.CommandName == "EditData")
        {
          DataTable dt = StockReports.GetDataTable(@"select * from eq_asset_deactivation_master where id='"+id+"'");
        if (dt.Rows.Count > 0)
        {
            bindasset();
            ddlasset.SelectedValue=dt.Rows[0][1].ToString();
            ddlasset_SelectedIndexChanged(sender,e);
            txtdeact .Text =dt.Rows[0][2].ToString();
            BindSupplierList();
            ddlSupplier.SelectedValue =dt.Rows[0][3].ToString();
            txtaddess.Text =dt.Rows[0][4].ToString();
            txtcontact.Text = dt.Rows[0][5].ToString();
            txtcontactph.Text =dt.Rows[0][6].ToString();
            txtremark.Text = dt.Rows[0][7].ToString();
            txtamt.Text =dt.Rows[0][8].ToString();
            ViewState["uid"] = dt.Rows[0][0].ToString();

            DataTable dtt = StockReports.GetDataTable("SELECT dd.approved_by empid,NAME empname FROM eq_asset_deactivation_detail dd INNER JOIN employee_master em ON em.employee_id=dd.approved_by WHERE ASSET_DEACTIVATION_ID='" + dt.Rows[0][0].ToString() + "'");

            gridacc.DataSource = dtt;
            gridacc.DataBind();
            ViewState["empdt"] = dtt;
            btnsave.Text = "Update";
        }
        }
    }

  
    protected void gridacc_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "imbRemove")
        {
            int index = Util.GetInt(e.CommandArgument);
            DataTable dtItem = (DataTable)ViewState["empdt"];
            dtItem.Rows[index].Delete();
            dtItem.AcceptChanges();
            ViewState["empdt"] = dtItem;

            gridacc.DataSource = dtItem;
            gridacc.DataBind();
            lblMsg.Text = "";
        }
    }
    protected void ddlSupplier_SelectedIndexChanged(object sender, EventArgs e)
    {
        DataTable dt = StockReports.GetDataTable("SELECT CONCAT(address1,' ',address2,' ',address3) address FROM f_vendormaster WHERE venledgerno='"+ddlSupplier.SelectedValue+"'");

        if (dt.Rows.Count > 0)
        {
            txtaddess.Text = dt.Rows[0][0].ToString();
        }
    }


    void updatedata()
    {
        MySqlConnection conn = Util.GetMySqlCon();
        conn.Open();
        try
        {

            string str = "";

            str = @"update eq_asset_deactivation_master set Assetid='" + ddlasset.SelectedValue + "', Deactive_cause='" + txtdeact.Text + "',supplierid='" + ddlSupplier.SelectedValue + "',address='" + txtaddess.Text + "',CONTACT_PERSON='" + txtcontact.Text + "',CONTACT_PERSON_Ph='"+txtcontactph.Text+"',remark='"+txtremark.Text+"' where id='"+ViewState["uid"].ToString()+"'";

         
            StockReports.ExecuteDML(str);

            StockReports.ExecuteDML("delete from eq_asset_deactivation_detail where ASSET_DEACTIVATION_ID='"+ViewState["uid"].ToString()+"'");

           
            foreach (GridViewRow dw in gridacc.Rows)
            {
                Label lb = (Label)dw.FindControl("lb1");

                string query = "insert into eq_asset_deactivation_detail(APPROVED_BY,ASSET_DEACTIVATION_ID) values ('" + lb.Text + "','" + ViewState["uid"].ToString() + "')";
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

    void savedata()
    {
        MySqlConnection conn = Util.GetMySqlCon();
        conn.Open();
        try
        {

            string str = "";



            str = @" INSERT INTO eq_asset_deactivation_master
            (Assetid,Deactive_cause,supplierid,address,CONTACT_PERSON,CONTACT_PERSON_Ph,Amount,Log_date,insertby,insertdate,ISAPPROVED,remark)
VALUES ('" + ddlasset.SelectedValue + "','" + txtdeact.Text + "','" +ddlSupplier.SelectedValue + "','"+txtaddess.Text+"','"+txtcontact.Text+"','" + txtcontactph.Text + "','"+txtamt.Text+"',Now(),'" + ViewState["ID"].ToString() + "',Now(),'0','"+txtremark.Text+"')";


            StockReports.ExecuteDML(str);

            string insid = StockReports.ExecuteScalar("Select max(id) from eq_asset_deactivation_master");
            foreach (GridViewRow dw in gridacc.Rows)
            {
                Label lb = (Label)dw.FindControl("lb1");
              
                string query = "insert into eq_asset_deactivation_detail(APPROVED_BY,ASSET_DEACTIVATION_ID) values ('" + lb.Text + "','" + insid + "')";
                StockReports.ExecuteDML(query);
            }

          
          
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

    void binddeactivelist()
    {
        DataTable dt = StockReports.GetDataTable(@"SELECT adm.*,itemname,vendorname FROM eq_asset_deactivation_master adm INNER JOIN eq_asset_master am ON am.id=adm.assetid INNER JOIN f_vendormaster vm ON vm.venledgerNo=adm.supplierid");

        if (dt.Rows.Count > 0)
        {
            grddetail.DataSource = dt;
            grddetail.DataBind();
        }
    }
}