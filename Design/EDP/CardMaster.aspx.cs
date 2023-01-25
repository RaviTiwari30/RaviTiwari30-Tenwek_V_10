using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_EDP_CardMaster : System.Web.UI.Page
{
    protected void btnEditCard_Click(object sender, EventArgs e)
    {
        if (txtEditCardName.Text.Trim() == "")
        {
            lblmsg.Text = "Please Specify Card Name..";
            return;
        }
        try
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                string str = "Update f_itemmaster SET TypeName ='" + txtEditCardName.Text + "' WHERE ItemID ='" + lblItemID.Text + "'";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

                string sql = "Update card_type_master SET CardName ='" + txtEditCardName.Text + "',CardExpiryDays ='" + txtEditExpDays.Text + "' WHERE ItemID ='" + lblItemID.Text + "'";
                int i = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);

                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM02','" + lblmsg.ClientID + "');", true);

                tnx.Commit();
                BindCard();
                BindGrid();
            }
            catch (Exception ex)
            {
                tnx.Rollback();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
            }
            finally
            {
                tnx.Dispose();
                con.Dispose();
                con.Close();
            }
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM07','" + lblmsg.ClientID + "');", true);
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (txtCardName.Text.Trim() == "")
        {
            lblmsg.Text = "Please Specify Card Name..";
            return;
        }
        try
        {
            if (ValidateName(txtCardName.Text.Trim()))
            {
                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
                try
                {
                    string subCategoryID =Util.GetString(MySqlHelper.ExecuteScalar( con,CommandType.Text,"SELECT SubCategoryID FROM f_SubCategorymaster WHERE DisplayName='Other Charges'"));
                    ItemMaster objIM = new ItemMaster(tnx);
                    objIM.TypeName = txtCardName.Text;
                    objIM.CreaterID = Session["ID"].ToString();
                    objIM.SubCategoryID = subCategoryID;
                    objIM.IsActive = 1;
                    objIM.IPAddress = All_LoadData.IpAddress();
                    objIM.CreaterID = Session["ID"].ToString();
                    string ItemId = objIM.Insert();

                    string sql = "Insert into card_type_master (CardName,CardExpiryDays,ItemID) values('" + txtCardName.Text.Trim() + "','" + txtExpDays.Text + "','" + ItemId + "')";
                    int i = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);

                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmsg.ClientID + "');", true);

                    tnx.Commit();
                    BindCard();
                    BindGrid();
                    Clear();
                }
                catch (Exception ex)
                {
                    tnx.Rollback();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                }
                finally
                {
                    tnx.Dispose();
                    con.Dispose();
                    con.Close();
                }
            }
            else
            {
                lblmsg.Text = "Card Already Exist";
            }
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM07','" + lblmsg.ClientID + "');", true);
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
    }

    protected void btnSavePanel_Click(object sender, EventArgs e)
    {
        if (ddlCardType.SelectedIndex > 0 && ddlPanelType.SelectedIndex > 0)
        {
            if (ValidatePanel())
            {
                string str = "UPDATE card_type_master SET PanelId = " + ddlPanelType.SelectedValue + " where ItemID='" + ddlCardType.SelectedValue + "'";
                bool execFlag = StockReports.ExecuteDML(str);
                if (execFlag)
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmsg.ClientID + "');", true);
                else
                    lblmsg.Text = "Please Retry";
                ddlCardType.SelectedIndex = 0;
                ddlPanelType.SelectedIndex = 0;
                BindGrid();
            }
        }
    }

    protected void grdResult_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditCard")
        {
            lblItemID.Text = e.CommandArgument.ToString().Split('#')[0];
            txtEditCardName.Text = e.CommandArgument.ToString().Split('#')[1];
            txtEditExpDays.Text = e.CommandArgument.ToString().Split('#')[2];
            mpEditCard.Show();
        }
    }

    protected void grdResult_SelectedIndexChanged(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        ddlCardType.SelectedValue = ((Label)grdResult.SelectedRow.FindControl("lblItemId")).Text;
        ddlPanelType.SelectedValue = ((Label)grdResult.SelectedRow.FindControl("lblPanelID")).Text;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindPanel();
            BindCard();
            BindGrid();
        }
    }

    protected bool ValidateName(string Name)
    {
        int i = Util.GetInt(StockReports.ExecuteScalar("select count(*) from card_type_master where CardName='" + Name + "'"));
        if (i > 0)
        { return false; }
        else
        { return true; }
    }

    private void BindCard()
    {
        string str = "SELECT CardName,ItemID FROM card_type_master ORDER BY CardName";
        DataTable oDT = StockReports.GetDataTable(str);
        ddlCardType.DataSource = oDT;
        ddlCardType.DataValueField = "ItemID";
        ddlCardType.DataTextField = "CardName";
        ddlCardType.DataBind();
        ddlCardType.Items.Insert(0, new ListItem("Select", "0"));
    }

    private void BindGrid()
    {
        string str = "SELECT tm.CardName,tm.ItemID,IFNULL(tm.PanelId,0) AS PanelId,tm.CardExpiryDays,pm.Company_Name AS 'Panel Name' FROM card_type_master tm LEFT JOIN f_panel_master pm ON pm.PanelID = tm.PanelId ORDER BY tm.CardName";
        DataTable oDT = StockReports.GetDataTable(str);
        grdResult.DataSource = oDT;
        grdResult.DataBind();
    }

    private void BindPanel()
    {
        string str = "SELECT Company_Name AS 'Panel Name',PanelID FROM f_panel_master";
        DataTable oDT = StockReports.GetDataTable(str);
        ddlPanelType.DataSource = oDT;
        ddlPanelType.DataValueField = "PanelID";
        ddlPanelType.DataTextField = "Panel Name";
        ddlPanelType.DataBind();
        ddlPanelType.Items.Insert(0, new ListItem("Select", "0"));
    }

    private void Clear()
    {
        txtCardName.Text = "";
        txtExpDays.Text = "";
    }

    private bool ValidatePanel()
    {
        string str = "SELECT * FROM card_type_master WHERE PanelID=" + ddlPanelType.SelectedValue + " ";
        DataTable oDT = StockReports.GetDataTable(str);
        if (oDT.Rows.Count > 0)
        {
            lblmsg.Text = "This Panel is olready assigned to " + oDT.Rows[0]["CardName"].ToString();
            return false;
        }
        else
            return true;
    }
}