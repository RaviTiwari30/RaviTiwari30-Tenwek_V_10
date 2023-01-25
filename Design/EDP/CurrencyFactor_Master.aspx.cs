using System;
using System.Data;
using System.Web.UI;
using MySql.Data.MySqlClient;

public partial class Design_EDP_CurrencyFactor_Master : System.Web.UI.Page
{
    protected void BindCurrencyDetail()
    {
        DataTable dtCurrencyDetail = StockReports.GetDataTable(" SELECT S_Currency,S_Notation,Selling_Base,Selling_Specific,Buying_Base,Buying_Specific,DATE_FORMAT(DATE,'%d %b %Y %l:%i %p')DATE,Round,MinCurrency FROM converson_master WHERE S_CountryID=" + ddlSpecificCurrency.SelectedItem.Value + " order by ID Desc");
        grdCurrencyDetails.DataSource = dtCurrencyDetail;
        grdCurrencyDetails.DataBind();
    }

    protected void BindData()
    {
        DataTable dtSearch = StockReports.GetDataTable("SELECT Selling_Base,Selling_Specific,Buying_Base,Buying_Specific,Round,MinCurrency FROM converson_master WHERE S_CountryID='" + ddlSpecificCurrency.SelectedValue + "'  ORDER BY ID DESC  LIMIT 1");
        if (dtSearch.Rows.Count > 0)
        {
            txtSaleBase.Text = dtSearch.Rows[0]["Selling_Base"].ToString();
            txtsaleSpecific.Text = dtSearch.Rows[0]["Selling_Specific"].ToString();
            txtBuyBase.Text = dtSearch.Rows[0]["Buying_Base"].ToString();
            txtBuySpecific.Text = dtSearch.Rows[0]["Buying_Specific"].ToString();
            txtRound.Text = dtSearch.Rows[0]["Round"].ToString();
            txtminCurrency.Text = dtSearch.Rows[0]["MinCurrency"].ToString();
        }
        else
        {
            txtSaleBase.Text = "";
            txtsaleSpecific.Text = "";
            txtBuyBase.Text = "";
            txtBuySpecific.Text = "";
            txtRound.Text = "";
            txtminCurrency.Text = "";
            btnSave.Visible = true;
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (ValidatePage())
        {
                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
                try
                {
                    Converson_Master ObjConverson = new Converson_Master();
                    ObjConverson.Date = Util.GetDateTime(Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + " " + DateTime.Now.ToString("HH:mm:ss"));
                    ObjConverson.B_CountryID = Util.GetInt(ddlBaseCurrency.SelectedValue);
                    ObjConverson.B_Currency = ddlBaseCurrency.SelectedItem.Text.Split('$')[0];
                    ObjConverson.B_Notation = ddlBaseCurrency.SelectedItem.Text.Split('$')[1];
                    ObjConverson.S_CountryID = Util.GetInt(ddlSpecificCurrency.SelectedValue);
                    ObjConverson.S_Currency = ddlSpecificCurrency.SelectedItem.Text.Split('$')[0];
                    ObjConverson.S_Notation = ddlSpecificCurrency.SelectedItem.Text.Split('$')[1];
                    ObjConverson.Selling_Base = Util.GetDecimal(txtSaleBase.Text);
                    ObjConverson.Selling_Specific = Util.GetDecimal(txtsaleSpecific.Text);
                    ObjConverson.Buying_Base = Util.GetDecimal(txtBuyBase.Text);
                    ObjConverson.Buying_Specific = Util.GetDecimal(txtBuySpecific.Text);
                    ObjConverson.UserID = ViewState["UserID"].ToString();
                    ObjConverson.Round = Util.GetDecimal(txtRound.Text);
                    ObjConverson.MinCurrency = Util.GetDecimal(txtminCurrency.Text);
                    string EntryID = ObjConverson.Insert();

                    if (EntryID == "")
                    {
                        tnx.Rollback();
                        tnx.Dispose();
                        con.Close();
                        con.Dispose();
                    }
                    //Drop Cache
                    LoadCacheQuery.dropCache("Currency");
                    tnx.Commit();

                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "modelAlert('Record Save Successfully',function(){ location.href='CurrencyFactor_Master.aspx'; });", true);
                    //ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "';", true);
                }
                catch (Exception Ex)
                {
                    tnx.Rollback();
                
                    lblMsg.Text = Ex.Message;
                }
                finally
                {
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();
                }
        }
    }

    protected void ddlSpecificCurrency_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlSpecificCurrency.SelectedValue != "Select")
        {
            lblNotation.Text = ddlSpecificCurrency.SelectedItem.Text.ToString().Split('$')[1];
            BindData();
            BindCurrencyDetail();
           
        }
        else
        {
            lblNotation.Text = "";
        }
    }

    protected void LoadCurrency()
    {
        DataTable dtCurrency = All_LoadData.LoadCurrency();
        ddlSpecificCurrency.DataSource = dtCurrency;
        ddlSpecificCurrency.DataTextField = "CurrencyName";
        ddlSpecificCurrency.DataValueField = "CountryID";
        ddlSpecificCurrency.DataBind();
        ddlSpecificCurrency.Items.Insert(0, "Select");

        ddlBaseCurrency.DataSource = All_LoadData.LoadBaseCurrency();
        ddlBaseCurrency.DataTextField = "CurrencyName";
        ddlBaseCurrency.DataValueField = "CountryID";
        ddlBaseCurrency.DataBind();

        //select base currency
        DataRow[] row = dtCurrency.Select("IsBaseCurrency=1");
        if (row.Length > 0)
        {
            ddlBaseCurrency.SelectedIndex = ddlBaseCurrency.Items.IndexOf(ddlBaseCurrency.Items.FindByValue(row[0]["CountryID"].ToString()));
            ViewState["BaseCountryID"] = row[0]["CountryID"].ToString();
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["UserID"] = Session["ID"].ToString();
            LoadCurrency();
            txtDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            Fromdatecal.StartDate = DateTime.Now;
        }
        txtDate.Attributes.Add("readOnly", "true");
    }

    protected bool ValidatePage()
    {
        if (txtSaleBase.Text == "")
        {
            lblMsg.Text = "Enter Sale Base Amount";
            return false;
        }
        if (txtsaleSpecific.Text == "")
        {
            lblMsg.Text = "Enter Sale Specific Amount";
            return false;
        }
        if (txtBuyBase.Text == "")
        {
            lblMsg.Text = "Enter Buy Base Amount";
            return false;
        }
        if (txtBuySpecific.Text == "")
        {
            lblMsg.Text = "Enter Buy Specific Amount";
            return false;
        }
        if (ddlBaseCurrency.SelectedValue == "")
        {
            lblMsg.Text = "No Base Currency Selected";
            return false;
        }
        if (ddlSpecificCurrency.SelectedValue == "Select")
        {
            lblMsg.Text = "No Specific Currency Selected";
            return false;
        }
        if (lblNotation.Text == "")
        {
            lblMsg.Text = "Please Set Notation of selected Specific Currency in Master";
            return false;
        }

        return true;
    }
}