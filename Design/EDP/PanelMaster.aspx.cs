using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_EDP_PanelMaster : System.Web.UI.Page
{

    public void BindServices()
    {
        DataTable dtItem = (DataTable)ViewState["ITEM"];
       // grdItem.DataSource = dtItem;
       // grdItem.DataBind();
    }

    public void ClearFields()
    {
        txtpnlname.Text = "";
        txtCompanyName.Text = "";
        txtAddress1.Text = "";
        txtAddress2.Text = "";
        txtPhone.Text = "";
        txtMobile.Text = "";
        txtContact.Text = "";
        txtEmail.Text = "";
        txtFax.Text = "";
        txtCoPaymentValue.Text = "";
        ddlPanelCompany.SelectedIndex = ddlPanelCompany.Items.IndexOf(ddlPanelCompany.Items.FindByText(AllGlobalFunction.Panel));
        ddlPanelIPD.SelectedIndex = ddlPanelIPD.Items.IndexOf(ddlPanelIPD.Items.FindByText(AllGlobalFunction.Panel));
        ddlPanelGroup.SelectedIndex = 0;
        ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        txtCreditLimit.Text = "";
        chkIsServiceTax.Checked = false;
        txtConversion.Text = "";
        foreach (System.Web.UI.WebControls.ListItem item in ddlPaymentMode.Items)
        {
            item.Selected = false;
        }
        rblHideRate.SelectedValue = "0";
        rblShowPrintOut.SelectedValue = "1";
        ddlPanelRateCurrency.SelectedIndex = 0;
        ddlPannelBillCurrency.SelectedIndex = 0;
        rblDietType.SelectedValue = "0";
        rblIsSmartCard.SelectedValue = "0";
    }

    public DataTable getItemDT()
    {
        DataTable dtItem = new DataTable();
        if (ViewState["ITEM"] == null)
        {
            dtItem.Columns.Add("Catagory");
            dtItem.Columns.Add("CatagoryID");
            dtItem.Columns.Add("SubCatagoryID");
            dtItem.Columns.Add("SubCatagory");
        }
        else
        {
            dtItem = (DataTable)ViewState["ITEM"];
        }
        return dtItem;
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        ViewState["ITEM"] = null;
        BindServices();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (txtCompanyName.Text.Trim() == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM164','" + lblMsg.ClientID + "');", true);
            return;
        }

        if (Util.GetDateTime(ucToDate.Text) <= Util.GetDateTime(ucFromDate.Text))
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM165','" + lblMsg.ClientID + "');", true);
            return;
        }
        if (txtMobile.Text != "" && txtMobile.Text.Length < 8)
        {
            lblMsg.Text = "Please Enter Valid Contact No.";
            txtMobile.Focus();
            return;
        }
        if (txtPhone.Text != "" && txtPhone.Text.Length < 8)
        {
            lblMsg.Text = "Please Enter Valid Phone No.";
            txtPhone.Focus();
            return;
        }
        if (txtEmail.Text != "")
        {
            Regex mailIDPattern = new Regex("(?<user>[^@]+)@(?<host>.+)");
            if (!mailIDPattern.IsMatch(txtEmail.Text))
            {
                lblMsg.Text = "Please Enter Valid Email ID";
                txtEmail.Focus();
                return;
            }
        }
        int count = 1;
        foreach (System.Web.UI.WebControls.ListItem item in ddlPaymentMode.Items)
        {
            if (item.Selected)
            {
                count += count;
            }
        }
        if (count == 1)
        {
            lblMsg.Text = "Please Select Payment Mode";
            ddlPaymentMode.Focus();
            return;
        }

        int panelCount = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM f_panel_master WHERE Company_Name='" + txtCompanyName.Text.Trim() + "'"));
        if (panelCount > 0)
        {
            lblMsg.Text = "Panel Name Already Exist";
            txtCompanyName.Focus();
            return;
        }

        SaveData();
    }

    protected void btnsearch_Click(object sender, EventArgs e)
    {
        BindGrid();
    }

    protected void btnselect_Click(object sender, EventArgs e)
    {
        //string subCat = StockReports.GetSelection(chksubcategory);
        //foreach (GridViewRow gr in grdItem.Rows)
        //{
        //    string sid = ((Label)gr.FindControl("lblsubcatagoryID")).Text;
        //    foreach (ListItem li in chksubcategory.Items)
        //    {
        //        if (li.Selected)
        //        {
        //            string sid1 = li.Value.Split('#')[0].ToString();
        //            if (sid == sid1)
        //            {
        //                ScriptManager.RegisterStartupScript(this, this.GetType(), "key3", "DisplayMsg('MM166','" + lblMsg.ClientID + "');", true);
        //                return;
        //            }
        //        }
        //    }
        //}

        //DataTable dtItem = getItemDT();

        //foreach (ListItem li in chksubcategory.Items)
        //{
        //    if (li.Selected)
        //    {
        //        DataRow dr = dtItem.NewRow();
        //        dr["SubCatagory"] = li.Text;
        //        dr["SubCatagoryID"] = li.Value.Split('#')[0].ToString();
        //        dr["CatagoryID"] = li.Value.Split('#')[1].ToString();
        //        dr["Catagory"] = li.Value.Split('#')[2].ToString();
        //        dtItem.Rows.Add(dr);
        //    }
        //}

       // ViewState["ITEM"] = dtItem;
       // BindServices();
       // chksubcategory.ClearSelection();
       // chkSelectItem.Checked = false;
    }

    protected void btnSubItem_Click(object sender, EventArgs e)
    {
        bindsubcatagory();
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        if (txtCompanyName.Text.Trim() == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM164','" + lblMsg.ClientID + "');", true);
            return;
        }

        if (Util.GetDateTime(ucToDate.Text) <= Util.GetDateTime(ucFromDate.Text))
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM165','" + lblMsg.ClientID + "');", true);
            return;
        }
        if (txtMobile.Text != "" && txtMobile.Text.Length < 10)
        {
            lblMsg.Text = "Please Enter Valid Contact No.";
            txtMobile.Focus();
            return;
        }
        if (txtPhone.Text != "" && txtPhone.Text.Length < 10)
        {
            lblMsg.Text = "Please Enter Valid Phone No.";
            txtPhone.Focus();
            return;
        }
        if (txtEmail.Text != "")
        {
            Regex mailIDPattern = new Regex("(?<user>[^@]+)@(?<host>.+)");

            if (!mailIDPattern.IsMatch(txtEmail.Text))
            {
                lblMsg.Text = "Please Enter Valid Email ID";
                txtEmail.Focus();
                return;
            }
        }
        int count = 1;
        foreach (System.Web.UI.WebControls.ListItem item in ddlPaymentMode.Items)
        {
            if (item.Selected)
            {
                count += count;
            }
        }
        if (count == 1)
        {
            lblMsg.Text = "Please Select Payment Mode";
            ddlPaymentMode.Focus();
            return;
        }
        int panelCount = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM f_panel_master WHERE Company_Name='" + txtCompanyName.Text.Trim() + "' AND PanelID<>" + lblPanelID.Text + " "));
        if (panelCount > 0)
        {
            lblMsg.Text = "Panel Name Already Exist";
            txtCompanyName.Focus();
            return;
        }
        string IsServiceTax = "0";
        if (chkIsServiceTax.Checked)
            IsServiceTax = "1";

        string PaymentMode = "";
        foreach (System.Web.UI.WebControls.ListItem item in ddlPaymentMode.Items)
        {
            if (item.Selected)
            {
                if (PaymentMode != string.Empty)
                {
                    PaymentMode += "," + item.Value + "";
                }
                else
                {
                    PaymentMode = "" + item.Value + "";
                }
            }
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            AllUpdate AUP = new AllUpdate();
            var coPaymentOn = Util.GetInt(rdoCoPaymentType.SelectedValue);
            var coPaymentPercent = 0.00;
            if (coPaymentOn == 1)
                coPaymentPercent = Util.GetDouble(txtCoPaymentValue.Text);
            string panelUpdate = AUP.UpdatePanelMaster(lblPanelID.Text, Util.GetString(txtCompanyName.Text.Trim()), Util.GetString(txtAddress1.Text.Trim()), Util.GetString(txtAddress2.Text.Trim()), "", "", Util.GetString(txtEmail.Text.Trim()), Util.GetString(txtPhone.Text.Trim()), Util.GetString(txtMobile.Text.Trim()), Util.GetString(txtContact.Text.Trim()), Util.GetString(txtFax.Text.Trim()), Util.GetString(ddlPanelCompany.SelectedItem.Value), Util.GetString(ddlPanelIPD.SelectedItem.Value), IsServiceTax, txtAgreement.Text.Trim(), Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd"), Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd"), txtCreditLimit.Text.Trim(), PaymentMode, ddlPanelGroup.SelectedItem.Text, tnx, Util.GetInt(ddlPanelGroup.SelectedItem.Value), Util.GetInt(rblHideRate.SelectedValue), Util.GetInt(rblShowPrintOut.SelectedValue), coPaymentOn, coPaymentPercent, Util.GetInt(ddlPanelRateCurrency.SelectedItem.Value), Util.GetInt(ddlPannelBillCurrency.SelectedItem.Value), Util.GetString(ddlPannelBillCurrency.SelectedItem.Text), Util.GetDecimal(txtConversion.Text), Util.GetInt(rbtBillingType.SelectedItem.Value), Util.GetInt(rbtCoverNote.SelectedItem.Value), Util.GetDecimal(txtPanelAmountLimit.Text), Util.GetInt(rblDietType.SelectedItem.Value), Util.GetInt(rblIsSmartCard.SelectedItem.Value));

            if (panelUpdate != null)
            {
                string upd = "UPDATE f_panel_services SET Active=0,EditUserID='" + Session["ID"].ToString() + "',EditDate='" + DateTime.Now.ToString("yyyy-MM-dd") + "' WHERE PanelID=" + lblPanelID.Text + " ";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, upd);

                if (ViewState["ITEM"] != null)
                {
                    DataTable dtItem = (DataTable)ViewState["ITEM"];
                    DataTable DistinctTable = dtItem.DefaultView.ToTable(true, "SubCatagoryID");

                    for (int x = 0; x < DistinctTable.Rows.Count; x++)
                    {
                        DataRow[] drTemp = dtItem.Select("SubCatagoryID = '" + DistinctTable.Rows[x]["SubCatagoryID"].ToString() + "'");

                        for (int j = 0; j < drTemp.Length; j++)
                        {
                            DataRow rowItem = drTemp[j];
                            string SubcatagoryID = Util.GetString(rowItem["SubcatagoryID"]);
                            string str = "INSERT INTO f_panel_services(PanelID,SubCatagoryID,UserID,EntryDate) VALUES(" + lblPanelID.Text + ",'" + SubcatagoryID + "','" + Session["ID"].ToString() + "','" + DateTime.Now.ToString("yyyy-MM-dd") + "')";
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
                        }
                    }
                }
                if (chkself.Checked == true)
                {

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_master SET ReferenceCodeOPD='" + lblPanelID.Text + "' WHERE PanelID=" + lblPanelID.Text + " ");
                }
                else
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_master SET ReferenceCodeOPD='" + ddlPanelCompany.SelectedItem.Value + "' WHERE PanelID=" + lblPanelID.Text + " ");
                }
                if (chkselfIPD.Checked == true)
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_master SET ReferenceCode='" + lblPanelID.Text + "' WHERE PanelID=" + lblPanelID.Text + " ");

                }
                else
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_master SET ReferenceCode='" + ddlPanelIPD.SelectedItem.Value + "' WHERE PanelID=" + lblPanelID.Text + " ");

                }
                if (Resources.Resource.ApplicationRunCentreWise == "0")
                {

                }
                tnx.Commit();
                ViewState["ITEM"] = null;
                BindServices();
                ClearFields();

                BindGrid();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM02','" + lblMsg.ClientID + "');", true);

                btnUpdate.Visible = false;
                btnSave.Visible = true;

                chkself.Visible = true; ;
                chkselfIPD.Visible = true;
                DropCache();
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
                tnx.Rollback();
                return;
            }
        }
        catch (Exception ex)
        {
            lblMsg.Text = "Error occurred, Please contact administrator";
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void chkAll_CheckedChanged(object sender, EventArgs e)
    {
        //if (chkAll.Checked)
        //{
        //    for (int i = 0; i < chkcategory.Items.Count; i++)
        //    {
        //        chkcategory.Items[i].Selected = true;
        //    }
        //}
        //else
        //{
        //    for (int i = 0; i < chkcategory.Items.Count; i++)
        //    {
        //        chkcategory.Items[i].Selected = false;
        //    }
        //}
    }

    protected void chkSelectItem_CheckedChanged(object sender, EventArgs e)
    {
        //for (int i = 0; i < chksubcategory.Items.Count; i++)
        //    chksubcategory.Items[i].Selected = chkSelectItem.Checked;
    }

    protected void chkself_CheckedChanged(object sender, EventArgs e)
    {
        if (chkself.Checked == true)
        {
            ddlPanelCompany.Enabled = false;
        }
        else
        {
            ddlPanelCompany.Enabled = true;
        }

        if (!chkselfIPD.Checked && !chkself.Checked)
        {
            ddlPanelRateCurrency.SelectedIndex = ddlPanelRateCurrency.Items.IndexOf(ddlPanelRateCurrency.Items.FindByValue(Resources.Resource.BaseCurrencyID));
            ddlPanelRateCurrency.Enabled = false;
        }
        else
        {
            ddlPanelRateCurrency.Enabled = true;
        
        }
    }

    protected void chkselfIPD_CheckedChanged(object sender, EventArgs e)
    {
        if (chkselfIPD.Checked == true)
        {
            ddlPanelIPD.Enabled = false;
        }
        else
        {
            ddlPanelIPD.Enabled = true;
        }

        if (!chkselfIPD.Checked && !chkself.Checked)
        {
            ddlPanelRateCurrency.SelectedIndex = ddlPanelRateCurrency.Items.IndexOf(ddlPanelRateCurrency.Items.FindByValue(Resources.Resource.BaseCurrencyID));
            ddlPanelRateCurrency.Enabled = false;
        }
        else
        {
            ddlPanelRateCurrency.Enabled = true;
        }


    }

    protected void grdItem_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        DataTable DtItem = ((DataTable)ViewState["ITEM"]);
        DtItem.Rows[e.RowIndex].Delete();
        ViewState["ITEM"] = DtItem;
        BindServices();
    }

    protected void grdPanel_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        grdPanel.PageIndex = e.NewPageIndex;
        BindGrid();
        lblMsg.Text = "";
    }

    protected void grdPanel_SelectedIndexChanged(object sender, EventArgs e)
    {
        lblPanelID.Text = ((Label)grdPanel.SelectedRow.FindControl("lblPanelId")).Text;
        DataTable dt = StockReports.GetDataTable("Select pm.IsSmartCard,pm.IsPrivateDiet,pm.CoverNote,pm.PanelAmountLimit,pm.IsCash, pm.Company_Name,pm.Add1,pm.Add2,pm.PanelID,pmIPD.Company_Name as Ref_Company,pm.ReferenceCode,pm.Panel_Code,pm.IsTPA,pm.EmailID,pm.Phone,pm.Mobile,pm.Contact_Person,pm.Fax_No,pmOPD.Company_Name as Ref_CompanyOPD,pm.ReferenceCodeOPD,pm.Agreement,if(pm.IsServiceTax='1','Yes','No')IsServiceTax,DATE_FORMAT(pm.DateFrom,'%d-%b-%Y')DateFrom,DATE_FORMAT(pm.DateTo,'%d-%b-%Y')DateTo,pm.CreditLimit,pm.PaymentMode,pm.PanelGroup,pm.PanelGroupID,pm.HideRate,pm.ShowPrintOut,pm.Co_PaymentOn,pm.Co_PaymentPercent,pm.RateCurrencyCountryID,pm.BillCurrencyCountryID,pm.BillCurrencyNotation,pm.BillCurrencyConversion from f_panel_master pm inner join f_panel_master pmIPD on pmIPD.PanelID = pm.ReferenceCode inner join f_panel_master pmOPD on pmOPD.PanelID = pm.ReferenceCodeOPD Where Pm.PanelID=" + lblPanelID.Text + " ");

        txtCompanyName.Text = dt.Rows[0]["Company_Name"].ToString();
        txtAddress1.Text = dt.Rows[0]["Add1"].ToString();
        txtAddress2.Text = dt.Rows[0]["Add2"].ToString();
        txtMobile.Text = dt.Rows[0]["Mobile"].ToString();
        txtContact.Text = dt.Rows[0]["Contact_Person"].ToString();
        txtAgreement.Text = dt.Rows[0]["Agreement"].ToString();
        txtPanelAmountLimit.Text = dt.Rows[0]["PanelAmountLimit"].ToString(); 
        int len = Util.GetInt(dt.Rows[0]["PaymentMode"].ToString().Split(',').Length);
        string[] Item = new string[len];
        Item = dt.Rows[0]["PaymentMode"].ToString().Split(',');
        for (int i = 0; i < len; i++)
        {
            for (int k = 0; k <= ddlPaymentMode.Items.Count - 1; k++)
            {
                if (Item[i] == ddlPaymentMode.Items[k].Value)
                {
                    ddlPaymentMode.Items[k].Selected = true;
                }
            }
        }
        txtEmail.Text = dt.Rows[0]["EmailID"].ToString();
        ddlPanelGroup.SelectedIndex = ddlPanelGroup.Items.IndexOf(ddlPanelGroup.Items.FindByValue(dt.Rows[0]["PanelGroupID"].ToString()));

        string IsServiceTax = dt.Rows[0]["IsServiceTax"].ToString();
        string FromDate = dt.Rows[0]["DateFrom"].ToString();
        string DateTo = dt.Rows[0]["DateTo"].ToString();
        txtCreditLimit.Text = dt.Rows[0]["CreditLimit"].ToString();

        ucFromDate.Text = FromDate;
        ucToDate.Text = DateTo;

        if (IsServiceTax.Trim().ToUpper() == "YES")
            IsServiceTax = "true";
        else
            IsServiceTax = "false";

        chkIsServiceTax.Checked = Util.GetBoolean(IsServiceTax);

        ddlPanelCompany.SelectedIndex = ddlPanelCompany.Items.IndexOf(ddlPanelCompany.Items.FindByValue(dt.Rows[0]["ReferenceCodeOPD"].ToString()));
        ddlPanelIPD.SelectedIndex = ddlPanelIPD.Items.IndexOf(ddlPanelIPD.Items.FindByValue(dt.Rows[0]["ReferenceCode"].ToString()));
        //chkself.Visible = false;
        //chkselfIPD.Visible = false;
        rblHideRate.SelectedIndex = rblHideRate.Items.IndexOf(rblHideRate.Items.FindByValue(dt.Rows[0]["HideRate"].ToString()));
        rblShowPrintOut.SelectedIndex = rblShowPrintOut.Items.IndexOf(rblShowPrintOut.Items.FindByValue(dt.Rows[0]["ShowPrintOut"].ToString()));
        txtCoPaymentValue.Text = dt.Rows[0]["Co_PaymentPercent"].ToString();
        int copaymentOn=Util.GetInt(dt.Rows[0]["Co_PaymentOn"].ToString());
        rdoCoPaymentType.SelectedIndex = rdoCoPaymentType.Items.IndexOf(rdoCoPaymentType.Items.FindByValue(copaymentOn.ToString()));  //copaymentOn;
        if (copaymentOn == 0)
            txtCoPaymentValue.Enabled = false;
        else
            txtCoPaymentValue.Enabled = true;


        //int rateCurrencyCountryID = Util.GetInt(dt.Rows[0]["RateCurrencyCountryID"].ToString());
        ddlPanelRateCurrency.SelectedIndex = ddlPanelRateCurrency.Items.IndexOf(ddlPanelRateCurrency.Items.FindByValue(dt.Rows[0]["RateCurrencyCountryID"].ToString())); 

        //int rateCurrencyCountryID = Util.GetInt(dt.Rows[0]["RateCurrencyCountryID"].ToString());

        if (dt.Rows[0]["PanelID"].ToString() == dt.Rows[0]["ReferenceCode"].ToString())
        {
            chkselfIPD.Checked = true;
            ddlPanelCompany.Enabled = false;
        }

        if (dt.Rows[0]["PanelID"].ToString() == dt.Rows[0]["ReferenceCodeOPD"].ToString())
        {
            chkself.Checked = true;
            ddlPanelIPD.Enabled = false;
        }



        if (!chkselfIPD.Checked && !chkself.Checked)
        {
            ddlPanelRateCurrency.SelectedIndex = ddlPanelRateCurrency.Items.IndexOf(ddlPanelRateCurrency.Items.FindByValue(Resources.Resource.BaseCurrencyID));
            ddlPanelRateCurrency.Enabled = false;
        }
        ddlPannelBillCurrency.SelectedIndex = ddlPannelBillCurrency.Items.IndexOf(ddlPannelBillCurrency.Items.FindByValue(dt.Rows[0]["BillCurrencyCountryID"].ToString()));
      //  ddlPannelBillCurrency.SelectedIndex = ddlPannelBillCurrency.Items.IndexOf(ddlPannelBillCurrency.Items.FindByText(dt.Rows[0]["BillCurrencyNotation"].ToString()));
        txtConversion.Text = dt.Rows[0]["BillCurrencyConversion"].ToString();

        rbtBillingType.SelectedIndex = rbtBillingType.Items.IndexOf(rbtBillingType.Items.FindByValue(dt.Rows[0]["IsCash"].ToString()));
        rbtCoverNote.SelectedIndex = rbtCoverNote.Items.IndexOf(rbtCoverNote.Items.FindByValue(dt.Rows[0]["CoverNote"].ToString()));
        rblDietType.SelectedIndex = rblDietType.Items.IndexOf(rblDietType.Items.FindByValue(dt.Rows[0]["IsPrivateDiet"].ToString()));
        rblIsSmartCard.SelectedIndex = rblIsSmartCard.Items.IndexOf(rblIsSmartCard.Items.FindByValue(dt.Rows[0]["IsSmartCard"].ToString()));
        
        btnUpdate.Visible = true;
        btnSave.Visible = false;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindPanels();
            All_LoadData.BindPanelGroup(ddlPanelGroup, "");
            BindGrid();
            btnUpdate.Visible = false;

            ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            bindcatagory();
            BindPaymentMode();
            BindPanelCurrency();
			LoadCacheQuery.dropCache("Currency");
        }
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");
        lblMsg.Text = "";
    }

    private void bindcatagory()
    {
        DataTable dt = All_LoadData.LoadAllCategory();

        if (dt.Rows.Count > 0)
        {
            //chkcategory.DataSource = dt;
            //chkcategory.DataTextField = "name";
            //chkcategory.DataValueField = "CategoryID";
            //chkcategory.DataBind();
        }
        else
        {
            //chkcategory.DataSource = null;
            //chkcategory.DataBind();
        }
    }

    private void BindGrid()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" Select Concat(if(pm.IsCash=0,'Credit','Cash'),'/',if(pm.CoverNote=0,'No','Yes') ) as BillingType, pm.Company_Name,pm.Add1,pm.Add2,pm.PanelID,pmIPD.Company_Name as Ref_Company,pm.ReferenceCode,pm.Panel_Code,pm.IsTPA,pm.EmailID,pm.Phone, ");
        sb.Append(" pm.Mobile,pm.Contact_Person,pm.Fax_No,pmOPD.Company_Name as Ref_CompanyOPD,pm.ReferenceCodeOPD,pm.Agreement,if(pm.IsServiceTax='1','Yes','No')IsServiceTax,DATE_FORMAT(pm.DateFrom,'%d-%b-%y')DateFrom, ");
        sb.Append(" DATE_FORMAT(pm.DateTo,'%d-%b-%y')DateTo,pm.CreditLimit,pm.PaymentMode,pm.PanelGroup,pm.PanelGroupID,pm.BillCurrencyNotation,pm.BillCurrencyConversion,pm.PanelAmountLimit from f_panel_master pm inner join f_panel_master pmIPD on pmIPD.PanelID = pm.ReferenceCode  ");
        sb.Append(" inner join f_panel_master pmOPD on pmOPD.PanelID = pm.ReferenceCodeOPD  where pm.PanelID<>0 ");

        if (txtpnlname.Text != "")
        {
            sb.Append(" and pm.Company_Name like '" + txtpnlname.Text + "%'");
        }
        sb.Append(" order by pm.Company_Name ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        grdPanel.DataSource = dt;
        grdPanel.DataBind();
        txtpnlname.Text = "";
    }

   

    private void BindPanels()
    {
        DataTable dtPanel = CreateStockMaster.LoadPanelCompanyRef();
        if (dtPanel != null && dtPanel.Rows.Count > 0)
        {
            foreach (DataRow dr in dtPanel.Rows)
            {
                ListItem li1 = new ListItem(dr[0].ToString(), dr[1].ToString());
                ddlPanelCompany.Items.Add(li1);

                ListItem li2 = new ListItem(dr[0].ToString(), dr[1].ToString());
                ddlPanelIPD.Items.Add(li2);
            }

            ddlPanelCompany.SelectedIndex = ddlPanelCompany.Items.IndexOf(ddlPanelCompany.Items.FindByText(AllGlobalFunction.Panel));
            ddlPanelIPD.SelectedIndex = ddlPanelIPD.Items.IndexOf(ddlPanelIPD.Items.FindByText(AllGlobalFunction.Panel));
        }
    }

    private void BindPaymentMode()
    {
        ddlPaymentMode.DataSource = All_LoadData.BindPaymentMode();
        ddlPaymentMode.DataTextField = "PaymentMode";
        ddlPaymentMode.DataValueField = "PaymentModeID";
        ddlPaymentMode.DataBind();
    }

    private void bindsubcatagory()
    {
        try
        {
            string subCat = "";// StockReports.GetSelection(chkcategory);
            string sql = " SELECT CONCAT(fs.SubCategoryID,'#',fs.CategoryID,'#',fc.Name)SubCategoryID,fs.NAME Subcategory  " +
                        " FROM f_subcategorymaster fs INNER JOIN f_categorymaster fc ON fc.CategoryID=fs.CategoryID where fs.CategoryID in (" + subCat + ") AND fs.active=1 order by fs.name ";
            DataTable dt = StockReports.GetDataTable(sql);

            if (dt.Rows.Count > 0)
            {
                //chksubcategory.DataSource = dt;
                //chksubcategory.DataTextField = "Subcategory";
                //chksubcategory.DataValueField = "SubCategoryID";
                //chksubcategory.DataBind();
            }
            else
            {
                //chksubcategory.DataSource = null;
                //chksubcategory.DataBind();
            }
        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.Message;
        }
    }

    private void DropCache()
    {
        LoadCacheQuery.dropCache("Panel");
       

        DataTable dt = All_LoadData.dtbind_Center();
        if (dt.Rows.Count > 0)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
               
                if (File.Exists(HttpContext.Current.Server.MapPath("~/CacheDependency/PanelOPD_" + dt.Rows[i]["CentreID"].ToString() + ".txt")))
                {
                    File.Delete(HttpContext.Current.Server.MapPath("~/CacheDependency/PanelOPD_" + dt.Rows[i]["CentreID"].ToString() + ".txt"));
                }
                if (File.Exists(HttpContext.Current.Server.MapPath("~/CacheDependency/PanelIPD_" + dt.Rows[i]["CentreID"].ToString() + ".txt")))
                {
                    File.Delete(HttpContext.Current.Server.MapPath("~/CacheDependency/PanelIPD_" + dt.Rows[i]["CentreID"].ToString() + ".txt"));
                }
            }
        }       
    }

    private void SaveData()
    {
        string PaymentMode = "";
        foreach (System.Web.UI.WebControls.ListItem item in ddlPaymentMode.Items)
        {
            if (item.Selected)
            {
                if (PaymentMode != string.Empty)
                {
                    PaymentMode += "," + item.Value + "";
                }
                else
                {
                    PaymentMode = "" + item.Value + "";
                }
            }
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            var coPaymentOn = Util.GetInt(rdoCoPaymentType.SelectedValue);
            var coPaymentPercent = 0.00;
            if (coPaymentOn == 1)
                coPaymentPercent = Util.GetDouble(txtCoPaymentValue.Text);    

            string panelId = AllInsert.SavePanelMaster(Util.GetString(txtCompanyName.Text.Trim()),
            Util.GetString(txtAddress1.Text.Trim()), Util.GetString(txtAddress2.Text.Trim()), HttpContext.Current.Session["HOSPID"].ToString(), "", "",
            Util.GetString(txtEmail.Text.Trim()), Util.GetString(txtPhone.Text.Trim()),
            Util.GetString(txtMobile.Text.Trim()), Util.GetString(txtContact.Text.Trim()),
            Util.GetString(txtFax.Text.Trim()), ddlPanelCompany.SelectedItem.Value,
            ddlPanelIPD.SelectedItem.Value, "", "0", Convert.ToDateTime(ucFromDate.Text).ToString("yyyy-MM-dd"),
            Convert.ToDateTime(ucToDate.Text).ToString("yyyy-MM-dd"), txtCreditLimit.Text.Trim(), PaymentMode,
            ddlPanelGroup.SelectedItem.Text, tnx, Util.GetInt(ddlPanelGroup.SelectedItem.Value), 
            Util.GetInt(rblHideRate.SelectedValue), Util.GetInt(rblShowPrintOut.SelectedValue), coPaymentOn, coPaymentPercent,
            Util.GetInt(ddlPanelRateCurrency.SelectedItem.Value), Util.GetInt(ddlPannelBillCurrency.SelectedItem.Value),
            Util.GetString(ddlPannelBillCurrency.SelectedItem.Text), Util.GetDecimal(txtConversion.Text), Util.GetInt(rbtBillingType.SelectedItem.Value), Util.GetInt(rbtCoverNote.SelectedItem.Value), Util.GetDecimal(txtPanelAmountLimit.Text), Util.GetInt(rblDietType.SelectedItem.Value), Util.GetInt(rblIsSmartCard.SelectedItem.Value));

            if (panelId != string.Empty)
            {

                if (chkIsServiceTax.Checked)
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update f_panel_master Set IsServiceTax = 1 where PanelID =" + panelId + " ");
                }
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisaplayMsg('MM05','" + lblMsg.ClientID + "');", true);
                tnx.Rollback();
                return;
            }

            if (ViewState["ITEM"] != null)
            {
                DataTable dtItem = (DataTable)ViewState["ITEM"];
                DataTable DistinctTable = dtItem.DefaultView.ToTable(true, "SubCatagoryID");

                for (int x = 0; x < DistinctTable.Rows.Count; x++)
                {
                    DataRow[] drTemp = dtItem.Select("SubCatagoryID = '" + DistinctTable.Rows[x]["SubCatagoryID"].ToString() + "'");

                    for (int j = 0; j < drTemp.Length; j++)
                    {
                        DataRow rowItem = drTemp[j];
                        string SubcatagoryID = Util.GetString(rowItem["SubcatagoryID"]);
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO f_panel_services(PanelID,SubCatagoryID,UserID,EntryDate) VALUES(" + panelId + ",'" + SubcatagoryID + "','" + Session["ID"].ToString() + "','" + DateTime.Now.ToString("yyyy-MM-dd") + "')");

                    }
                }
            }

            ViewState["ITEM"] = null;
            BindServices();
            if (chkself.Checked == true)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_master SET ReferenceCodeOPD='" + panelId + "' WHERE PanelID=" + panelId + " ");
            }
            if (chkselfIPD.Checked == true)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_master SET ReferenceCode='" + panelId + "' WHERE PanelID=" + panelId + " ");
            }
            if (Resources.Resource.ApplicationRunCentreWise == "0")
            {
                string SqlPanel = "INSERT INTO f_center_panel(PanelID,CentreID,createdBy) values(" + panelId + ",'" + Session["CentreID"].ToString() + "','" + Session["ID"].ToString() + "')";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, SqlPanel);
            }
            tnx.Commit();
            ClearFields();
            lblMsg.Text = "Record Save Successfully";
            BindGrid();
            DropCache();
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    protected void btnReport_Click(object sender, EventArgs e)
    {
       StringBuilder sb = new StringBuilder();
       sb.Append("  SELECT pm.PanelID,pm.PanelGroup,pm.Company_Name,pm.Add1,pm.Add2,pmIPD.Company_Name AS Ref_CompanyIPD,pmOPD.Company_Name AS Ref_CompanyOPD,pm.Panel_Code,");
       sb.Append(" pm.EmailID,pm.Phone, pm.Mobile,pm.Contact_Person ,DATE_FORMAT(pm.DateFrom,'%d-%b-%y')DateFrom, DATE_FORMAT(pm.DateTo,'%d-%b-%y')DateTo,pm.BillCurrencyNotation,pm.BillCurrencyConversion,pm.PaymentMode  ");
       sb.Append(" FROM f_panel_master pm INNER JOIN f_panel_master pmIPD ON pmIPD.PanelID = pm.ReferenceCode  INNER JOIN f_panel_master pmOPD ON pmOPD.PanelID = pm.ReferenceCodeOPD  WHERE pm.PanelID<>''  ");
       sb.Append("  ORDER BY pm.PanelGroup, pm.Company_Name");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            Session["dtExport2Excel"] = dt;
            Session["ReportName"] = " Panelmaster";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/ExportToExcel.aspx');", true);
        }

    }





    private void BindPanelCurrency()
    {
   //     DataTable dt = StockReports.GetDataTable("SELECT CountryID,Currency ,IsBaseCurrency ,(SELECT  COUNT(*) FROM  converson_master c WHERE c.S_CountryID=CountryID) ConversonFactorCount FROM Country_master WHERE IsActive=1 AND Currency IS NOT NULL  HAVING  ConversonFactorCount>0 ORDER BY IsBaseCurrency DESC");
        DataTable dt = All_LoadData.LoadCurrencyFactor("");
        
        ddlPanelRateCurrency.DataSource = dt;
        ddlPanelRateCurrency.DataTextField = "Currency";
        ddlPanelRateCurrency.DataValueField = "CountryID";
        ddlPanelRateCurrency.DataBind();
        ddlPannelBillCurrency.DataSource = dt;
        ddlPannelBillCurrency.DataTextField = "Currency";
        ddlPannelBillCurrency.DataValueField = "CountryID";
        ddlPannelBillCurrency.DataBind();

        DataRow[] dr = dt.Select("IsBaseCurrency=1");
        ddlPanelRateCurrency.SelectedIndex = ddlPanelRateCurrency.Items.IndexOf(ddlPanelRateCurrency.Items.FindByValue(dr[0]["CountryID"].ToString()));
        ddlPannelBillCurrency.SelectedIndex = ddlPannelBillCurrency.Items.IndexOf(ddlPannelBillCurrency.Items.FindByValue(dr[0]["CountryID"].ToString()));
        txtConversion.Text = "1";
    }

    [WebMethod]
    public static string BindCurrencyDetails(string countryID)
    {
        DataTable BillCurrencyDetails = StockReports.GetDataTable("SELECT cm.Selling_Specific,cm.S_Currency,cm.S_Notation,cm.S_CountryID FROM converson_master cm where cm.S_CountryID=" + countryID + " ORDER BY id DESC LIMIT 1");
        return Newtonsoft.Json.JsonConvert.SerializeObject(BillCurrencyDetails);
    }

}