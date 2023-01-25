using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_BloodBank_BloodBankStockIssue : System.Web.UI.Page
{
    protected void bindBloodGroup()
    {
        string str = "SELECT id,bloodgroup FROM bb_BloodGroup_master WHERE IsActive=1 AND bloodgroup<>' NA'  order by bloodgroup";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);
        ddlBloodGroup.DataSource = dt;
        ddlBloodGroup.DataTextField = "bloodgroup";
        ddlBloodGroup.DataValueField = "id";
        ddlBloodGroup.DataBind();
        ddlBloodGroup.Items.Insert(0, new ListItem("Select", "0"));
    }

    protected void BindComponent()
    {
        string str = "SELECT ComponentName ComponentName,id FROM bb_component_master  WHERE active='1'";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);
        ddlComponent.DataSource = dt;
        ddlComponent.DataTextField = "ComponentName";
        ddlComponent.DataValueField = "id";
        ddlComponent.DataBind();
        ddlComponent.Items.Insert(0, new ListItem("Select", "0"));
    }

    protected void bindOrganisation()
    {
        string str = "SELECT organisaction,id FROM bb_organisation_master WHERE IsActive=1  order by Id";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);
        ddlOrg.DataSource = dt;
        ddlOrg.DataTextField = "organisaction";
        ddlOrg.DataValueField = "id";
        ddlOrg.DataBind();
        ddlOrg.Items.Insert(0, new ListItem("Select", "0"));
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (ddlComponent.SelectedItem.Text != "Select")
        {
            DataTable dtItem = new DataTable();
            if (ViewState["dtItems"] != null)
                dtItem = (DataTable)ViewState["dtItems"];
            else
                dtItem = GetItem();

           
            for (int i = 0; i < dtItem.Rows.Count; i++)
            {
                if (dtItem.Rows[i]["TubeNo"].ToString() == txtTube.Text.Trim())
                {
                    lblMsg.Text = "Tube No. Already Used";
                    txtTube.Focus();
                    return;
                }
            }
            DataTable TubeNo = StockReports.GetDataTable("Select BBTubeNo from bb_stock_master");
            for (int i = 0; i < TubeNo.Rows.Count; i++)
            {
                if (TubeNo.Rows[i]["BBTubeNo"].ToString() == txtTube.Text.Trim())
                {
                    lblMsg.Text = "Tube No. Already Used";
                    txtTube.Focus();
                    return;
                }
            }
            DataRow dr = dtItem.NewRow();
            dr["Componentname"] = ddlComponent.SelectedItem.Text.ToString();
            dr["Componentid"] = ddlComponent.SelectedValue.ToString();
            dr["BloodGroup"] = ddlBloodGroup.SelectedItem.Text;
            dr["BagType"] = ddlBagtype.SelectedItem.Text;
            dr["TubeNo"] = txtTube.Text.Trim();
            dr["Quantity"] = txtQty.Text.Trim();
            dr["Date"] = Util.GetDateTime(txtExpiryDate.Text).ToString("dd-MMM-yyyy");

            dtItem.Rows.Add(dr);

            ViewState.Add("dtItems", dtItem);
            grdBloodItem.DataSource = dtItem;
            grdBloodItem.DataBind();
            pnlsave.Visible = true;
            lblMsg.Text = "";
            Visible();
        }
        else
            lblMsg.Text = "";
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int Status = 1;
            string StockID = "";
            string centerid = Session["Centre"].ToString();
            string id = Util.GetString(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, "Call bb_stock_post('" + centerid + "')"));
            string str = "Insert into bb_stockpost(bb_directstockID,bill_no,billdate,Organisation,CreatedBy,Status,WayBillDate,WayBillNo) values('" + id + "','" + txtBillno.Text.Trim() + "','" + Util.GetDateTime(txtBillDate.Text).ToString("yyyy-MM-dd") + "','" + ddlOrg.SelectedItem.Text + "','" + ViewState["ID"] + "','" + Status + "','" + Util.GetDateTime(txtWayBillDate.Text).ToString("yyyy-MM-dd") + "','" + txtwaybillno.Text.Trim() + "')  ";
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str);
            StockInsert si = new StockInsert(tranX);
            for (int i = 0; i < grdBloodItem.Rows.Count; i++)
            {
                si.BloodCollection_Id = id;
                si.BagType = Util.GetString(((Label)grdBloodItem.Rows[i].FindControl("lblBagType")).Text);
                si.BBTubeNo = Util.GetString(((Label)grdBloodItem.Rows[i].FindControl("lblTubeNo")).Text);
                si.BloodGroup = Util.GetString(((Label)grdBloodItem.Rows[i].FindControl("lblBloodGroup")).Text);
                si.ComponentName = Util.GetString(((Label)grdBloodItem.Rows[i].FindControl("lblComponentname")).Text);
                si.ComponentID = Util.GetInt(((Label)grdBloodItem.Rows[i].FindControl("lblComponentid")).Text);
                si.ExpiryDate = Util.GetDateTime(((Label)grdBloodItem.Rows[i].FindControl("lblExpiry")).Text);
                si.InitialCount = Util.GetDecimal(((Label)grdBloodItem.Rows[i].FindControl("lblQuantity")).Text);
                si.CentreId = Util.GetInt((Session["CentreID"]).ToString());
                si.CreatedBy = Session["ID"].ToString();
                si.IsComponent = 1;
                si.status = 1;
                si.IsDiscarded = 0;
                si.EntryDate = Util.GetDateTime(System.DateTime.Now.ToString());

                StockID = si.Insert();
            }
            tranX.Commit();
            
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Stock Created Successfully...Bloodcollection ID: " + id + "');location.href='BloodBankStockIssue.aspx';", true);
        }
        catch (Exception ex)
        {
            if (ex.InnerException.InnerException.Message.Contains("Duplicate entry"))
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM203','" + Label1.ClientID + "');", true);
            }
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            tranX.Rollback();
            
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void grdBloodItem_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "imbRemove")
        {
            int args = Util.GetInt(e.CommandArgument);
            DataTable dtItem = (DataTable)ViewState["dtItems"];
            dtItem.Rows[args].Delete();
            dtItem.AcceptChanges();
            grdBloodItem.DataSource = dtItem;
            grdBloodItem.DataBind();

            ViewState["dtItems"] = dtItem;
            lblMsg.Text = "Blood Details Removed Successfully";
            Visible();
            if (dtItem.Rows.Count > 0)
            {
                pnlsave.Visible = true;
            }
            else
            {
                pnlsave.Visible = false;
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["ID"] = Session["ID"].ToString();
            txtWayBillDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtExpiryDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            bindOrganisation();
            bindBloodGroup();
            BindComponent();
            BloodBank.bindBagType(ddlBagtype);
            pnlsave.Visible = false;
            callandate.StartDate = Util.GetDateTime(System.DateTime.Now.ToString("dd-MMM-yyyy"));
            Billdatecal.EndDate = DateTime.Now;
        }
        txtBillDate.Attributes.Add("readOnly", "true");
        txtWayBillDate.Attributes.Add("readOnly", "true");
        txtExpiryDate.Attributes.Add("readOnly", "true");
    }

    protected void Visible()
    {
        if (grdBloodItem.Rows.Count > 0)
        {
            txtBillno.Attributes.Add("readOnly", "true");
            txtBillDate.Enabled = false;
            ddlOrg.Enabled = false;
            txtWayBillDate.Attributes.Add("readOnly", "true");
            txtwaybillno.Enabled = false;
        }
        else
        {
            txtBillno.Attributes.Add("readOnly", "false");
            txtBillDate.Enabled = true;
            ddlOrg.Enabled = true;
            txtWayBillDate.Attributes.Add("readOnly", "false");
            txtwaybillno.Enabled = true;
        }
        // txtQty.Text = "";
        txtTube.Text = "";
        bindBloodGroup();
        BindComponent();
        BloodBank.bindBagType(ddlBagtype);
        txtExpiryDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
    }

    private DataTable GetItem()
    {
        if (ViewState["dtItems"] != null)
        {
            return (DataTable)ViewState["dtItems"];
        }
        else
        {
            DataTable dtItem = new DataTable();
            dtItem = new DataTable();
            dtItem.Columns.Add("Componentname");
            dtItem.Columns.Add("Componentid");
            dtItem.Columns.Add("BloodGroup");
            dtItem.Columns.Add("BagType");
            dtItem.Columns.Add("TubeNo");
            dtItem.Columns.Add("Quantity");
            dtItem.Columns.Add("Date");
            return dtItem;
        }
    }
    protected void ddlComponent_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindRate();
    }
   
    private void BindRate()
    {
        string str = "";
        str = "SELECT dtExpiry FROM bb_component_master WHERE id ='" + ddlComponent.SelectedValue + "' ";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            int ExpDays = Util.GetInt(dt.Rows[0]["dtExpiry"].ToString());
            callandate.EndDate = Util.GetDateTime(txtExpiryDate.Text).AddDays(ExpDays);
        }
    }
}