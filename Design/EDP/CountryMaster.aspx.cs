using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web.UI;
using System.Xml;

public partial class Design_EDP_CountryMaster : System.Web.UI.Page
{
    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (ValidatePage())
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                if (ChkIsBaseCurrency.Checked == true)
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update country_master set IsBasecurrency=0 ");
                }
                CountryMaster ObjConMaster = new CountryMaster(tnx);
                ObjConMaster.NAME = Util.GetString(txtCountryName.Text);
                ObjConMaster.Currency = Util.GetString(txtCurrency.Text);
                ObjConMaster.Address = Util.GetString(txtCounsellorAddress.Text);
                ObjConMaster.FaxNo = Util.GetString(txtFaxNoCounsellor.Text);
                ObjConMaster.PhoneNo = Util.GetString(txtPhoneNoCounsellor.Text);
                ObjConMaster.Notation = Util.GetString(txtNotation.Text);
                ObjConMaster.EmbassyAddress = Util.GetString(txtAddressEmbassy.Text);
                ObjConMaster.EmbassyPhoneNo = Util.GetString(txtPhoneNoEmbassy.Text);
                ObjConMaster.EmbessyFaxNo = Util.GetString(txtFaxNoEmbassy.Text);
                ObjConMaster.EntryUserID = Util.GetString(ViewState["UserID"].ToString());
                if (ChkIsBaseCurrency.Checked == true)
                    ObjConMaster.IsBaseCurrency = 1;
                else
                    ObjConMaster.IsBaseCurrency = 0;
                string CountryID = ObjConMaster.Insert();
                if (CountryID == "")
                {
                    tnx.Rollback();
                    return;
                }

                tnx.Commit();

                if (ChkIsBaseCurrency.Checked == true)
                {
                    XmlDocument loResource = new XmlDocument();
                    loResource.Load(Server.MapPath("~/App_GlobalResources/Resource.resx"));
                    XmlNode xDefaultCountry = loResource.SelectSingleNode("root/data[@name='DefaultCountry']/value");
                    xDefaultCountry.InnerText = txtCountryName.Text;
                    XmlNode xBaseCurrencyID = loResource.SelectSingleNode("root/data[@name='BaseCurrencyID']/value");
                    xBaseCurrencyID.InnerText = ddlCountry.SelectedValue;

                    loResource.Save(Server.MapPath("~/App_GlobalResources/Resource.resx"));
                }

                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
                Clear();
                DropCache();
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                tnx.Rollback();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        if (ValidatePage())
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                if (ChkIsBaseCurrency.Checked == true)
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update country_master set IsBasecurrency=0 ");
                }
                CountryMaster ObjConMaster = new CountryMaster(tnx);
                ObjConMaster.NAME = Util.GetString(txtCountryName.Text);
                ObjConMaster.Currency = Util.GetString(txtCurrency.Text);
                ObjConMaster.Address = Util.GetString(txtCounsellorAddress.Text);
                ObjConMaster.FaxNo = Util.GetString(txtFaxNoCounsellor.Text);
                ObjConMaster.PhoneNo = Util.GetString(txtPhoneNoCounsellor.Text);
                ObjConMaster.Notation = Util.GetString(txtNotation.Text);
                ObjConMaster.EmbassyAddress = Util.GetString(txtAddressEmbassy.Text);
                ObjConMaster.EmbassyPhoneNo = Util.GetString(txtPhoneNoEmbassy.Text);
                ObjConMaster.EmbessyFaxNo = Util.GetString(txtFaxNoEmbassy.Text);
                ObjConMaster.UpdateByID = Util.GetString(ViewState["UserID"].ToString());
                ObjConMaster.Updatedate = DateTime.Now;
                ObjConMaster.Isactive = Util.GetInt(rdoIsActive.SelectedValue);
                ObjConMaster.CountryID = Util.GetString(ddlCountry.SelectedValue);
                if (ChkIsBaseCurrency.Checked == true)
                    ObjConMaster.IsBaseCurrency = 1;
                else
                    ObjConMaster.IsBaseCurrency = 0;

                ObjConMaster.Update();
                tnx.Commit();

                if (ChkIsBaseCurrency.Checked == true)
                {
                    XmlDocument loResource = new XmlDocument();
                    loResource.Load(Server.MapPath("~/App_GlobalResources/Resource.resx"));
                    XmlNode xDefaultCountry = loResource.SelectSingleNode("root/data[@name='DefaultCountry']/value");
                    xDefaultCountry.InnerText = txtCountryName.Text;
                    XmlNode xBaseCurrencyID = loResource.SelectSingleNode("root/data[@name='BaseCurrencyID']/value");
                    xBaseCurrencyID.InnerText = ddlCountry.SelectedValue;

                    loResource.Save(Server.MapPath("~/App_GlobalResources/Resource.resx"));
                }
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM02','" + lblMsg.ClientID + "');", true);

                Clear();
                DropCache();
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                tnx.Rollback();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
    }

    protected void ddlCountry_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlCountry.SelectedItem.Text != "Select")
        {
            DataTable dtCountryDetail = All_LoadData.LoadCountryByID(ddlCountry.SelectedValue);
            txtCountryName.Text = dtCountryDetail.Rows[0]["NAME"].ToString();
            txtCurrency.Text = dtCountryDetail.Rows[0]["Currency"].ToString();
            txtNotation.Text = dtCountryDetail.Rows[0]["Notation"].ToString();
            txtCounsellorAddress.Text = dtCountryDetail.Rows[0]["Address"].ToString();
            txtPhoneNoCounsellor.Text = dtCountryDetail.Rows[0]["PhoneNo"].ToString();
            txtFaxNoCounsellor.Text = dtCountryDetail.Rows[0]["FaxNo"].ToString();
            txtAddressEmbassy.Text = dtCountryDetail.Rows[0]["EmbassyAddress"].ToString();
            txtPhoneNoEmbassy.Text = dtCountryDetail.Rows[0]["EmbassyPhoneNo"].ToString();
            txtFaxNoEmbassy.Text = dtCountryDetail.Rows[0]["EmbessyFaxNo"].ToString();
            rdoIsActive.SelectedIndex = rdoIsActive.Items.IndexOf(rdoIsActive.Items.FindByValue(dtCountryDetail.Rows[0]["Isactive"].ToString()));
            if (dtCountryDetail.Rows[0]["IsBaseCurrency"].ToString() == "1")
                ChkIsBaseCurrency.Checked = true;
            else
                ChkIsBaseCurrency.Checked = false;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindCountry();
            ViewState["UserID"] = Session["ID"].ToString();
        }
    }

    protected void rdoEdit_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rdoEdit.SelectedValue == "2")
        {
            ddlCountry.Visible = true;
            btnUpdate.Visible = true;
            txtCountryName.Visible = false;
            btnSave.Visible = false;
            BindCountry();
            Label3.Visible = false;
        }
        else
        {
            ddlCountry.Visible = false;
            btnUpdate.Visible = false;
            txtCountryName.Visible = true;
            btnSave.Visible = true;
            Label3.Visible = true;
        }
        Clear();
    }

    private void BindCountry()
    {
        ddlCountry.DataSource = All_LoadData.LoadCountry();
        ddlCountry.DataTextField = "NAME";
        ddlCountry.DataValueField = "CountryID";
        ddlCountry.DataBind();
        ddlCountry.Items.Insert(0, "Select");
    }

    private void Clear()
    {
        txtCountryName.Text = "";
        txtCurrency.Text = "";
        txtNotation.Text = "";
        txtCounsellorAddress.Text = "";
        txtAddressEmbassy.Text = "";
        txtPhoneNoCounsellor.Text = "";
        txtPhoneNoEmbassy.Text = "";
        txtFaxNoCounsellor.Text = "";
        txtFaxNoEmbassy.Text = "";
        rdoIsActive.SelectedIndex = 0;
        ddlCountry.SelectedIndex = 0;
        ChkIsBaseCurrency.Checked = false;
    }

    private void DropCache()
    {
        LoadCacheQuery.dropCache("Country");
        LoadCacheQuery.dropCache("Currency");
    }

    private bool ValidatePage()
    {
        if (txtCountryName.Text == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM154','" + lblMsg.ClientID + "');", true);

            return false;
        }
        if (txtCurrency.Text == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM155','" + lblMsg.ClientID + "');", true);
            return false;
        }
        if (txtNotation.Text == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM158','" + lblMsg.ClientID + "');", true);
            return false;
        }
        if (txtCounsellorAddress.Text == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM156','" + lblMsg.ClientID + "');", true);
            return false;
        }
        if (txtAddressEmbassy.Text == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM157','" + lblMsg.ClientID + "');", true);
            return false;
        }

        return true;
    }
}