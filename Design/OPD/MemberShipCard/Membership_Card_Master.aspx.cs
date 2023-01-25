using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using MySql.Data.MySqlClient;

public partial class Design_OPD_MemberShipCard_Membership_Card_Master : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindData();
            lblItemID.Text = "";
        }

    }
    protected void BindData()
    {
        DataTable dt = StockReports.GetDataTable("SELECT mcm.ID, mcm.NAME, mcm.Description, mcm.No_of_dependant, mcm.CardValid, mcm.Amount FROM membership_card_master  mcm INNER JOIN f_itemmaster im ON im.ItemID=mcm.ItemID WHERE mcm.IsActive = 1  AND im.IsActive=1");
        if (dt.Rows.Count > 0)
        {
            MembershipCardGrid.DataSource = dt;
            MembershipCardGrid.DataBind();
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {

        if (!validate())
            return;

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            ItemMaster objIMaster = new ItemMaster(tnx);
            objIMaster.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            objIMaster.Type_ID = 0;
            objIMaster.TypeName = HttpUtility.UrlDecode(Util.GetString(txtCardName.Text.Trim()));
            objIMaster.Description = "";
            objIMaster.SubCategoryID = Util.GetString(Resources.Resource.OtherChargesSubCategoryID);
            objIMaster.IsEffectingInventory = "NO";
            objIMaster.IsExpirable = "No";
            objIMaster.BillingUnit = "";
            objIMaster.Pulse = "";
            objIMaster.IsTrigger = "YES";
            objIMaster.StartTime = DateTime.Now;
            objIMaster.EndTime = DateTime.Now;
            objIMaster.BufferTime = "0";
            objIMaster.IsActive = 1;
            objIMaster.QtyInHand = 0;
            objIMaster.IsAuthorised = 1;
            objIMaster.ItemCode = string.Empty;
            objIMaster.CreaterID = HttpContext.Current.Session["ID"].ToString();
            objIMaster.IPAddress = All_LoadData.IpAddress();
            objIMaster.RateEditable = 0;
            string itemID= objIMaster.Insert().ToString();

         
            ExcuteCMD excuteCMD = new ExcuteCMD();
            string sqlCmd = "INSERT INTO membership_card_master(NAME,Description,No_of_dependant,CardValid,UserID,ItemID)VALUES(@name,@description,@dependent,@cardValid,@userId,@itemId)";
            excuteCMD.DML(tnx,sqlCmd.ToString(),CommandType.Text,new{
                 name=txtCardName.Text.Trim(),
                 description=txtDescription.Text.Trim(),
                 dependent = ddlDependant.SelectedItem.Value,
                 cardValid = ddlValidYrs.SelectedItem.Value,
                 userId = 0,
                 itemId = itemID
            });
            tnx.Commit();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "modelAlert('Membership Card Create Successfully');", true);
            LoadCacheQuery.dropCache("OPDDiagnosisItems");
            txtDescription.Text = "";
            txtCardName.Text = "";
            ddlDependant.SelectedIndex = 0;
            BindData();
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            lblmsg.Text = ex.Message;
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
    protected void EmpGrid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        DataTable dt = StockReports.GetDataTable("SELECT mcm.ID, mcm.NAME, mcm.Description, mcm.No_of_dependant, mcm.CardValid, im.ItemID FROM membership_card_master mcm INNER JOIN f_itemmaster im ON im.ItemID=mcm.ItemID WHERE mcm.IsActive = 1 AND mcm.ID = "+e.CommandArgument.ToString());
        if (dt.Rows.Count > 0)
        {
           // txtCardAmount.Text = dt.Rows[0]["Amount"].ToString();
            txtCardName.Text = dt.Rows[0]["Name"].ToString();
            txtDescription.Text = dt.Rows[0]["Description"].ToString();
            lblItemID.Text = dt.Rows[0]["ItemID"].ToString();
            ddlDependant.SelectedIndex = ddlDependant.Items.IndexOf(ddlDependant.Items.FindByValue(dt.Rows[0]["No_of_dependant"].ToString()));
            ddlValidYrs.SelectedIndex = ddlValidYrs.Items.IndexOf(ddlValidYrs.Items.FindByValue(dt.Rows[0]["CardValid"].ToString()));
            ViewState["ID"] = e.CommandArgument.ToString();
            btnSave.Visible = false;
            btnUpdate.Visible = true;
            btnCancel.Visible = true;
        }
    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        txtDescription.Text = "";
        txtCardName.Text = "";
       // txtCardAmount.Text = "";
        ddlDependant.SelectedIndex = 0;
        ddlValidYrs.SelectedIndex = 0;
        btnSave.Visible = true;
        btnUpdate.Visible = false;
        btnCancel.Visible = false;
        ViewState["ID"] = "";
    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            ExcuteCMD excuteCMD = new ExcuteCMD();
            var sqlCmd="UPDATE membership_card_master SET NAME=@name,Description=@description,No_of_dependant=@noOfDepended,CardValid=@CardValid,Amount=0 WHERE ID=@ID";
            excuteCMD.DML(tnx,sqlCmd,CommandType.Text,new{
                      name=txtCardName.Text.Trim(),
                      description=txtDescription.Text.Trim(),
                      noOfDepended=ddlDependant.SelectedItem.Value,
                      cardValid=ddlValidYrs.SelectedValue,
                      ID=ViewState["ID"].ToString()
            });


            excuteCMD.DML(tnx, "UPDATE f_itemmaster Set TypeName=@typeName,LastUpdatedBy=@updateBy,Updatedate=Now()  WHERE ItemID=@itemID", CommandType.Text, new
            {
                updateBy = ViewState["ID"].ToString(),
                typeName = txtCardName.Text.Trim(),
                itemID=lblItemID.Text.Trim()
            });

            tnx.Commit();
            BindData();
            btnCancel_Click(sender, e);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "modelAlert('Record Update Successfully');", true);
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "modelAlert('Error occurred, Please contact administrator');", true);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }       

    }



    public bool validate() {
        if (string.IsNullOrEmpty(txtCardName.Text))
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "modelAlert('Please Enter Card Name');", true);
            return false;
        }
        if (string.IsNullOrEmpty(txtDescription.Text))
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "modelAlert('Please Enter Card Description');", true);
            return false;
        }
        return true;
    }
}
