using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Equipment_Masters_EquipmentLocation : System.Web.UI.Page
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
            bindassettype();
            bindlocation();
            binddepartment();
            bindasset();
            bindacc();
            bindmaingrid();
            ucwarfrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ucwarto.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ucfreefrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ucfreeto.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ucinsdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");

        }

        ucwarfrom.Attributes.Add("readonly","readonly");
        ucwarto.Attributes.Add("readonly", "readonly");
        ucfreefrom.Attributes.Add("readonly", "readonly");
        ucfreeto.Attributes.Add("readonly", "readonly");
        ucinsdate.Attributes.Add("readonly", "readonly");
    }

    private void bindmaingrid()
    {
        DataTable dt = StockReports.GetDataTable(@"SELECT aim.id,(CASE WHEN aim.status='1' THEN 'True' ELSE 'False' END) STATUS,itemname,assettypename,assetsubtypename,locationname,floorname,roomname
FROM eq_asset_location_master aim INNER JOIN eq_asset_master am ON aim.assetid=am.id 
INNER JOIN eq_assettype_master eam ON eam.assettypeid=aim.asset_typeid INNER JOIN eq_assetsubtype_master asm
 ON asm.assetsubtypeid=aim.asset_subtypeid  INNER JOIN eq_location_master lm ON lm.locationid=aim.LOcid
 INNER JOIN eq_floor_master fm ON fm.floorid=aim.floorid INNER JOIN eq_room_master rm ON rm.roomid=aim.roomid ");

        grddetail.DataSource = dt;
        grddetail.DataBind();

    }

    private void bindacc()
    {
        DataTable dt = StockReports.GetDataTable("SELECT CONCAT (accessoryid,'#',accessorycode) id,accessoryname FROM eq_accessory_master WHERE isactive=1");

        ddlacc.DataSource = dt;
        ddlacc.DataTextField = "accessoryname";
        ddlacc.DataValueField = "id";
        ddlacc.DataBind();
        ddlacc.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        ddlacc.SelectedIndex = 0;
    }

    private void bindasset()
    {
        DataTable dt = StockReports.GetDataTable("SELECT id,itemname FROM eq_asset_master where isactive=1");

        ddlasset.DataSource = dt;
        ddlasset.DataTextField = "itemname";
        ddlasset.DataValueField = "id";
        ddlasset.DataBind();
        ddlasset.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        ddlasset.SelectedIndex = 0;

    }
    private void bindassettype()
    {
        DataTable dt = StockReports.GetDataTable("SELECT assettypeid,assettypename FROM eq_AssetType_master WHERE isactive=1 ORDER BY assettypename ASC");
        ddlassettype.DataSource = dt;
        ddlassettype.DataTextField = "assettypename";
        ddlassettype.DataValueField = "assettypeid";
        ddlassettype.DataBind();
        ddlassettype.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        ddlassettype.SelectedIndex = 0;
        bindassetsubtype(ddlassettype.SelectedValue);

    }
    private void bindassetsubtype(string assettype)
    {
        DataTable dt = StockReports.GetDataTable("SELECT assetsubtypename,assetsubtypeid FROM eq_AssetsubType_master WHERE isactive=1 AND assettypeid='" + assettype + "' ORDER BY assetsubtypename ASC");
        ddlassetsubtype.DataSource = dt;
        ddlassetsubtype.DataTextField = "assetsubtypename";
        ddlassetsubtype.DataValueField = "assetsubtypeid";
        ddlassetsubtype.DataBind();
        ddlassetsubtype.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        ddlassetsubtype.SelectedIndex = 0;
    }

    private void bindlocation()
    {
        DataTable dt = StockReports.GetDataTable("SELECT locationid,locationname FROM eq_location_master WHERE isactive=1 ORDER BY locationname ASC");
        ddlloc.DataSource = dt;
        ddlloc.DataTextField = "locationname";
        ddlloc.DataValueField = "locationid";
        ddlloc.DataBind();
        ddlloc.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        ddlloc.SelectedIndex = 0;
        bindfloor(ddlloc.SelectedValue);

    }

    private void bindfloor(string loction)
    {
        DataTable dt = StockReports.GetDataTable("SELECT floorid,floorname FROM eq_floor_master WHERE isactive=1 AND locationid='" + loction + "' ORDER BY floorname ASC");
        ddlfloor.DataSource = dt;
        ddlfloor.DataTextField = "floorname";
        ddlfloor.DataValueField = "floorid";
        ddlfloor.DataBind();
        ddlfloor.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        ddlfloor.SelectedIndex = 0;
        bindroom(ddlfloor.SelectedValue, ddlloc.SelectedValue);
    }

    private void bindroom(string floor, string location)
    {
        DataTable dt = StockReports.GetDataTable("SELECT roomid,roomname FROM eq_room_master WHERE floorid='" + floor + "' AND locationid='" + location + "' AND isactive=1 ORDER BY roomname ASC ");
        ddlroom.DataSource = dt;
        ddlroom.DataTextField = "roomname";
        ddlroom.DataValueField = "roomid";
        ddlroom.DataBind();

        ddlroom.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        ddlroom.SelectedIndex = 0;
    }

    private void binddepartment()
    {
        string str = "SELECT LedgerName,LedgerNumber FROM f_ledgermaster WHERE GroupID='DPT'  and IsCurrent=1 ORDER BY LedgerName";
        DataTable dt = new DataTable();

        dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {

            ddldept.DataSource = dt;
            ddldept.DataTextField = "LedgerName";
            ddldept.DataValueField = "LedgerNumber";
            ddldept.DataBind();
            ddldept.Items.Insert(0, new ListItem("Select", "Select"));
            ddldept.SelectedIndex = 0;

        }
    }
    protected void ddlassettype_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindassetsubtype(ddlassettype.SelectedValue);
    }
    protected void ddlloc_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindfloor(ddlloc.SelectedValue);
    }
    protected void ddlfloor_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindroom(ddlfloor.SelectedValue, ddlloc.SelectedValue);
    }
    protected void ddlasset_SelectedIndexChanged(object sender, EventArgs e)
    {
        DataTable dt = StockReports.GetDataTable(@"SELECT vm.vendorname,em.serialno,im.policyno,im.insval,epi.name,im.ins_startdate,im.ins_enddate,CONCAT(TIMESTAMPDIFF(YEAR,im.ins_startdate,im.ins_enddate) ,' year') duration
FROM eq_asset_master em INNER JOIN f_vendormaster vm ON em.suppierid=vm.venledgerno
INNER JOIN eq_insurance_detail id ON em.id=id.assetid INNER JOIN eq_insurance_master im ON id.insurenceid=im.id INNER JOIN 
eq_providerinsurance epi ON epi.id=im.insproid WHERE em.id='" + ddlasset.SelectedValue + "'");


        if (dt.Rows.Count > 0)
        {
            txtsupplier.Text = dt.Rows[0]["vendorname"].ToString();
            txtpolicyno.Text = dt.Rows[0]["policyno"].ToString();
            txtpolicyamt.Text = dt.Rows[0]["insval"].ToString();
            txtpolicydur.Text = dt.Rows[0]["duration"].ToString();
            txtserial.Text = dt.Rows[0]["serialno"].ToString();
            txtprovider.Text = dt.Rows[0]["name"].ToString();
            ucformins.Text = Convert.ToDateTime(dt.Rows[0]["ins_startdate"].ToString()).ToString("dd-MMM-yyyy");
            uninsto.Text = Convert.ToDateTime(dt.Rows[0]["ins_enddate"].ToString()).ToString("dd-MMM-yyyy");

        }

    }


    DataTable createtable()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("AccId");
        dt.Columns.Add("AccCode");
        dt.Columns.Add("AccName");
        dt.Columns.Add("Qty");
        return dt;

    }

    bool checkduplicate()
    {
        foreach (GridViewRow dw in gridacc.Rows)
        {
            Label lb = (Label)dw.FindControl("lbid");

            if (lb.Text == ddlacc.SelectedValue.Split('#')[0].ToString())
            {
                return true;
            }
            else
            {
                return false;
            }

        }
        return false;
    }
    protected void btnadd_Click(object sender, EventArgs e)
    {
        if (checkduplicate())
        {
            lblMsg.Text = "Accessory Alredy Added";
            return;
        }

        DataTable dt;
        if (ViewState["dtasset"] != null)
        {
            dt = (DataTable)ViewState["dtasset"];
        }
        else
        {
            dt = createtable();
        }

        DataRow dw = dt.NewRow();

        dw["AccId"] = ddlacc.SelectedValue.Split('#')[0].ToString();
        dw["AccCode"] = ddlacc.SelectedValue.Split('#')[1].ToString();
        dw["AccName"] = ddlacc.SelectedItem.Text;
        dw["Qty"] = txtqty.Text;
        dt.Rows.Add(dw);

        gridacc.DataSource = dt;
        gridacc.DataBind();
        ViewState["dtasset"] = dt;
        txtqty.Text = "";
        ddlacc.SelectedIndex = 0;
    }
    protected void gridacc_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "imbRemove")
        {
            int index = Util.GetInt(e.CommandArgument);
            DataTable dtItem = (DataTable)ViewState["dtasset"];
            dtItem.Rows[index].Delete();
            dtItem.AcceptChanges();
            ViewState["dtasset"] = dtItem;

            gridacc.DataSource = dtItem;
            gridacc.DataBind();
            lblMsg.Text = "";
        }
    }
    protected void btnsave_Click(object sender, EventArgs e)
    {
        if (gridacc.Rows.Count == 0)
        {
            lblMsg.Text = "Select Accessory";
            return;
        }

        if (btnsave.Text == "Save")
        {
            savedata();
        }
        else
        {
            updatedata();
        }

        bindmaingrid();
    }

    void savedata()
    {
        MySqlConnection conn = Util.GetMySqlCon();
        conn.Open();
        try
        {

            string str = "";
            string filename = "";
            if (FileUpload1.HasFile)
            {
                filename = FileUpload1.PostedFile.FileName;
                FileUpload1.SaveAs(Server.MapPath("~/Design/Equipment/Attachment/" + FileUpload1.FileName));
            }
            int IsActive = 0;

            if (chk.Checked)
                IsActive = 1;


            str = @"INSERT INTO eq_asset_location_master
                      (ASSETID,ASSET_TYPEID,ASSET_SubTYPEID,DESCRIPTION,DEPARTMENTID,LOCID,floorid,roomid,LIFETIME,warrenty_start,warrenty_end,ATTACTMENT,
                     STATUS,freeservide_start,freeservice_end,Installation_date,
                      insertby,insertdate) VALUES
                      ('" + ddlasset.SelectedValue + "','" + ddlassettype.SelectedValue + "','" + ddlassetsubtype.SelectedValue + "','" + txtdes.Text + "','" + ddldept.SelectedValue + "','" + ddlloc.SelectedValue + "','" + ddlfloor.SelectedValue + "','" + ddlroom.SelectedValue + "','" + txtlife.Text + "','" + (Util.GetDateTime(ucwarfrom.Text)).ToString("yyyy-MM-dd") + "','" + (Util.GetDateTime(ucwarto.Text)).ToString("yyyy-MM-dd") + "','" + filename + "','" + IsActive + "','" + (Util.GetDateTime(ucfreefrom.Text)).ToString("yyyy-MM-dd") + "','" + (Util.GetDateTime(ucfreeto.Text)).ToString("yyyy-MM-dd") + "','" + (Util.GetDateTime(ucinsdate.Text)).ToString("yyyy-MM-dd") + "','" + ViewState["ID"].ToString() + "',Now())";


            StockReports.ExecuteDML(str);

            string insid = StockReports.ExecuteScalar("Select max(id) from eq_asset_location_master");
            foreach (GridViewRow dw in gridacc.Rows)
            {
                Label lb = (Label)dw.FindControl("lbid");
                Label lb1 = (Label)dw.FindControl("lbdes");
                string query = "insert into eq_asset_location_detail(ACCESSORYID,qty,ASSETLOCID) values ('" + lb.Text + "','" + lb1.Text + "','" + insid + "')";
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

    void updatedata()
    {
        MySqlConnection conn = Util.GetMySqlCon();
        conn.Open();
        try
        {

            string str = "";
            string filename = "";
            if (FileUpload1.HasFile)
            {
                filename = FileUpload1.PostedFile.FileName;
                FileUpload1.SaveAs(Server.MapPath("~/Design/Equipment/Attachment/" + FileUpload1.FileName));
            }
            int IsActive = 0;

            if (chk.Checked)
                IsActive = 1;


            str = @"update eq_asset_location_master set ASSETID='" + ddlasset.SelectedValue + "',ASSET_TYPEID='" + ddlassettype.SelectedValue + "',ASSET_SubTYPEID='" + ddlassetsubtype.SelectedValue + "',DESCRIPTION='" + txtdes.Text + "',DEPARTMENTID='" + ddldept.SelectedValue + "',LOCID='" + ddlloc.SelectedValue + "',floorid='" + ddlfloor.SelectedValue + "',roomid='" + ddlroom.SelectedValue + "',LIFETIME='" + txtlife.Text + "',warrenty_start='" + (Util.GetDateTime(ucwarfrom.Text)).ToString("yyyy-MM-dd") + "',warrenty_end='" + (Util.GetDateTime(ucwarto.Text)).ToString("yyyy-MM-dd") + "',STATUS='" + IsActive + "',freeservide_start='" + (Util.GetDateTime(ucfreefrom.Text)).ToString("yyyy-MM-dd") + "',freeservice_end='" + (Util.GetDateTime(ucfreeto.Text)).ToString("yyyy-MM-dd") + "',Installation_date='" + (Util.GetDateTime(ucinsdate.Text)).ToString("yyyy-MM-dd") + "',updateby='" + ViewState["ID"].ToString() + "',updatedate=Now() where id='" + ViewState["uid"].ToString() + "'";


            StockReports.ExecuteDML(str);

            if (filename != "")
            {
                str = "update table eq_asset_location_master set ATTACTMENT='" + filename + "' where id=" + ViewState["uid"].ToString() + "'";
                StockReports.ExecuteDML(str);
            }

            str = "delete from eq_asset_location_detail where assetlocid='" + ViewState["uid"].ToString() + "'";
            StockReports.ExecuteDML(str);
            foreach (GridViewRow dw in gridacc.Rows)
            {
                Label lb = (Label)dw.FindControl("lbid");
                Label lb1 = (Label)dw.FindControl("lbdes");
                string query = "insert into eq_asset_location_detail(ACCESSORYID,qty,ASSETLOCID) values ('" + lb.Text + "','" + lb1.Text + "','" + ViewState["uid"].ToString() + "')";
                StockReports.ExecuteDML(query);
            }


            conn.Close();
            conn.Dispose();

            lblMsg.Text = "Record Update";

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
        clearcontrol();
        btnsave.Text = "Save";
    }

    void clearcontrol()
    {
        txtsupplier.Text = "";
        txtpolicyno.Text = "";
        txtpolicyamt.Text = "";
        txtpolicydur.Text = "";
        txtserial.Text = "";
        txtprovider.Text = "";
        ucformins.Text = "";

        ucwarfrom.Text=DateTime.Now.ToString("dd-MMM-yyyy");
        ucwarto.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        ucfreefrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        ucfreeto.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        ucinsdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        uninsto.Text = "";

        txtdes.Text = "";

        ddlasset.SelectedIndex = 0;
        ddldept.SelectedIndex = 0;
        ddlloc.SelectedIndex = 0;
        ddlroom.SelectedIndex = 0;
        ddlfloor.SelectedIndex = 0;
        ddlassettype.SelectedIndex = 0;
        ddlassetsubtype.SelectedIndex = 0;

        ddlacc.SelectedIndex = 0;
        txtqty.Text = "";

        lblMsg.Text = "";
        gridacc.DataSource = null;
        gridacc.DataBind();








    }
    protected void grddetail_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        lblMsg.Text = "";
        string id = Util.GetString(e.CommandArgument);

        if (e.CommandName == "EditData")
        {
            DataTable dt = StockReports.GetDataTable("SELECT * FROM eq_asset_location_master WHERE id='" + id + "'");
            if (dt != null && dt.Rows.Count > 0)
            {
                ViewState["uid"] = dt.Rows[0][0].ToString();
                ddlasset.SelectedValue = dt.Rows[0][1].ToString();

                ddlasset_SelectedIndexChanged(sender, e);
                ddlassettype.SelectedValue = dt.Rows[0][2].ToString();

                bindassetsubtype(ddlassettype.SelectedValue);
                ddlassetsubtype.SelectedValue = dt.Rows[0][3].ToString();
                ddlloc.SelectedValue = dt.Rows[0][6].ToString();
                bindfloor(ddlloc.SelectedValue);
                ddlfloor.SelectedValue = dt.Rows[0][7].ToString();
                bindroom(ddlfloor.SelectedValue, ddlloc.SelectedValue);
                ddlroom.SelectedValue = dt.Rows[0][8].ToString();
                txtdes.Text = dt.Rows[0][3].ToString();
                ucinsdate.Text=Util.GetDateTime(dt.Rows[0][21].ToString()).ToString("dd-MMM-yyyy");

                ucfreefrom.Text = Util.GetDateTime(dt.Rows[0][19].ToString()).ToString("dd-MMM-yyyy");
                ucfreeto.Text = Util.GetDateTime(dt.Rows[0][20].ToString()).ToString("dd-MMM-yyyy");
                ddldept.SelectedValue = dt.Rows[0][5].ToString();
                ucwarfrom.Text = Util.GetDateTime(dt.Rows[0][10].ToString()).ToString("dd-MMM-yyyy");
                ucwarto.Text = Util.GetDateTime(dt.Rows[0][11].ToString()).ToString("dd-MMM-yyyy");
                if (dt.Rows[0]["status"].ToString() == "1")
                {
                    chk.Checked = true;
                }
                else
                {
                    chk.Checked = false;
                }

                DataTable dtt = StockReports.GetDataTable(@" SELECT eq_accessory_master.accessoryid accid, accessorycode acccode,accessoryname accname,qty FROM eq_asset_location_detail INNER JOIN eq_accessory_master
 ON eq_accessory_master.AccessoryID=eq_asset_location_detail.ACCESSORYID WHERE assetlocid='" + id + "'");
                ViewState["dtasset"] = dtt;
                gridacc.DataSource = dtt;
                gridacc.DataBind();
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