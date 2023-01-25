using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.IO;
using System.Web.Services;
using System.Web.Script.Services;
using System.Web.UI.HtmlControls;

public partial class Design_Store_VendorDetail : System.Web.UI.Page
{
    protected void btnReportPopup_Click(object sender, EventArgs e)
    {
        DataTable dt = SearchVendorForEReport();
        DataTable dtExcel = SearchVendorForExcelEReport();

        if (dt.Rows.Count > 0)
        {
            lblMsg.Text = "Total " + dt.Rows.Count + " Vendor(s) Found";
            DataSet ds = new DataSet();

            DataColumn dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
            dt.Columns.Add(dc);

            ds.Tables.Add(dt.Copy());

            //  ds.WriteXmlSchema(@"D:\VendorSearch.xml");
            if (rdoReportFormat.SelectedValue == "1")
            {
                Session["ds"] = ds;
                Session["ReportName"] = "StoreVendorReport";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
            }
            else
            {
                Session["dtExport2Excel"] = dtExcel;
                Session["ReportName"] = "Supplier Master Listing";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
            }
        }
        else
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM270','" + lblMsg.ClientID + "');", true);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    protected void btnSave_Click(object sender, EventArgs e)
    {
        int TVendor = 0;
        TVendor = Util.GetInt(StockReports.ExecuteScalar("SELECT count(*) FROM f_vendormaster WHERE VendorName ='" + txtVen1.Text.Trim() + "' "));
        if (TVendor > 0)
        {
            lblVMsg.Text = "Supplier Already Exist";
           // mdpSave.Show();

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key101", "showSaveSupplierModel();", true);

            return;
        }
        TVendor = Util.GetInt(StockReports.ExecuteScalar("SELECT count(*) FROM f_vendormaster WHERE Mobile ='" + txtMob1.Text.Trim() + "' "));
        if (TVendor > 0)
        {
            lblVMsg.Text = "Supplier Contact No. Already Exist";
          //  mdpSave.Show();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key102", "showSaveSupplierModel();", true);
            return;
        }
        if (ddlstate1.SelectedIndex == 0)
        {
            lblVMsg.Text = "Please Select State";
          //  mdpSave.Show();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key103", "showSaveSupplierModel();", true);
            ddlstate1.Focus();
            return;
        }

        if (txtGstTinNo.Text.Trim() == string.Empty)
        {
            if (Resources.Resource.IsGSTApplicable == "1")
            {
                lblVMsg.Text = "Please Enter GSTIN No.";
            }
            else
            {
                lblVMsg.Text = "Please Enter VAT No.";
            }
            //  mdpSave.Show();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key104", "showSaveSupplierModel();", true);
            txtGstTinNo.Focus();
            return;
        }


        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        string VendorID = "";
        MySqlTransaction objTran = con.BeginTransaction(IsolationLevel.Serializable);

        vendor objVendor = new vendor(objTran);
        objVendor.VendorName = Util.GetString(txtVen1.Text.Trim());
        objVendor.VendorCode = Util.GetString(txtvenCode.Text.Trim());
        objVendor.VendorType = Util.GetString(ddlType.SelectedItem.Text);
        objVendor.VendorCategory = Util.GetString(ddlvCat.SelectedItem.Text);
        objVendor.Bank = Util.GetString(txtvenbank.Text.Trim());
        objVendor.AccountNo = Util.GetString(txtvenAcc.Text.Trim());
        objVendor.PaymentMode = Util.GetString(ddlVenPayment.SelectedItem.Text);
        objVendor.ShipmentDetail = Util.GetString(txtvenShipDetail.Text.Trim());
        objVendor.VATNo = Util.GetString(txtVAT.Text.Trim());
        objVendor.Address1 = Util.GetString(txtAdd1.Text.Trim());
        objVendor.Address2 = Util.GetString(txtAdd2.Text.Trim());
        objVendor.Address3 = Util.GetString(txtAdd3.Text.Trim());
        objVendor.ContactPerson = Util.GetString(txtContact.Text.Trim());
        objVendor.City = Util.GetString(txtCity1.Text.Trim());
        objVendor.Country = Util.GetString(txtCountry.Text.Trim());
        objVendor.Pin = Util.GetString(txtPinCode.Text.Trim());
        objVendor.Telephone = Util.GetString(txtTel1.Text);
        objVendor.Email = txtEmail.Text.Trim();
        objVendor.Area = "";
        objVendor.Fax = "";
        objVendor.Mobile = Util.GetString(txtMob1.Text.Trim());
        objVendor.StoreID = "";
        objVendor.DrugLicence = txtDLNo.Text.Trim();
        objVendor.CreditDays = txtCreditDays.Text.Trim();
        objVendor.TinNo = Util.GetString(txtVAT.Text.Trim());
        objVendor.GSTINNo = Util.GetString(txtGstTinNo.Text.Trim());
        //objVendor.DeptLedgerNo = Util.GetString(ddlDeptName.SelectedValue);
        string ledgerno = "";
        for (int i = 0; i < ddlDeptName.Items.Count; i++) 
        {
            if (ddlDeptName.Items[i].Selected)
            {
                ledgerno += ddlDeptName.Items[i].Value + ",";
            }
        }
        ledgerno = ledgerno.TrimEnd(',');

        objVendor.DeptLedgerNo = ledgerno;
        objVendor.StateID = Util.GetInt(HFStateID1.Value);
        objVendor.CountryID = Util.GetInt(HFCountryID1.Value);
        int chkCheck = 0;
        if (chkIsAsset.Checked == false)
        {
            chkCheck = 0;
        }
        else { chkCheck = 1; }
        objVendor.IsAsset = chkCheck;
        objVendor.Currency = ddlSupplierCurrency.SelectedItem.Text;
        objVendor.IsActive = "1";
		int chkinsurance = 0;
        if (chkInsuranceProvider.Checked == false)
        {
            chkinsurance = 0;
        }
        else
        {
            chkinsurance = 1;
        }
        objVendor.IsInsuranceProvider = chkinsurance;
        VendorID = objVendor.Insert();
        if (VendorID != string.Empty)
        {
            Ledger_Master objLM = new Ledger_Master(objTran);
            objLM.GroupID = "VEN";
            objLM.LegderName = Util.GetString(txtVen1.Text.Trim());
            objLM.LedgerUserID = VendorID;
            objLM.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            objLM.OpeningBalance = Util.GetDecimal(0);
            objLM.ClosingBalance = Util.GetDecimal(0);
            objLM.CurrentBalance = Util.GetDecimal(0);
            string i = objLM.Insert().ToString();
            if (i == "0")
            {
                objTran.Rollback();
                con.Close();
                con.Dispose();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM07','" + lblMsg.ClientID + "');", true);
                return;
            }
        }
        else
        {
            objTran.Rollback();
            con.Close();
            con.Dispose();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM07','" + lblMsg.ClientID + "');", true);
            return;
        }

        foreach (GridViewRow gr in grdTerms.Rows)
        {
            if (((CheckBox)gr.FindControl("chkSelect")).Checked)
            {
                string SqlTerms = "INSERT INTO f_vendor_terms(Vendor_Id,Terms_Id,Terms,CreatedBy) VALUES('" + VendorID + "','" + ((Label)gr.FindControl("lblTermsId")).Text + "','" + ((Label)gr.FindControl("lblTerms")).Text + "','" + Session["ID"].ToString() + "')";
                MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, SqlTerms);
            }
        }
      
       

        objTran.Commit();
        ClearData();
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
        if (con.State == ConnectionState.Open)
        {
            con.Close();
            con.Dispose();
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        BindVendor();
    }
    protected void btnupdate_Click(object sender, EventArgs e)
    {
        string VendorID = string.Empty;
        if (ViewState["VendorID"] != null)
        {
            VendorID = Util.GetString(ViewState["VendorID"]);
        }

        int TVendorUpdate = 0;
        TVendorUpdate = Util.GetInt(StockReports.ExecuteScalar("SELECT count(*) FROM f_vendormaster WHERE VendorName ='" + txtVendor.Text.Trim() + "' AND Vendor_ID<>'" + VendorID + "' "));
        if (TVendorUpdate > 0)
        {
            lblVUpMsg.Text = "Vendor Already Exist";
            //mpeCreateGroup.Show();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key3", "showUpdateSupplierModel();", true);
            return;
        }
        TVendorUpdate = Util.GetInt(StockReports.ExecuteScalar("SELECT count(*) FROM f_vendormaster WHERE Mobile ='" + txtMobile.Text.Trim() + "' AND Vendor_ID<>'" + VendorID + "' "));
        if (TVendorUpdate > 0)
        {
            lblVUpMsg.Text = "Vendor Contact No. Already Exist";
          //  mpeCreateGroup.Show();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key4", "showUpdateSupplierModel();", true);
            return;
        }

        if (txtGstInNoUpdate.Text.Trim() == string.Empty)
        {
            if (Resources.Resource.IsGSTApplicable == "1")
            {
                lblVUpMsg.Text = "Please Enter GSTIN No.";
            }
            else
            {
                lblVUpMsg.Text = "Please Enter VAT No.";
            }
            //  mdpSave.Show();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key104", "showSaveSupplierModel();", true);
            txtGstInNoUpdate.Focus();
            return;
        }

        string str = string.Empty;

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        string SqlUpdateTerms = "";
        int chkIsasset = 0;
        if (chkUpdateIsAsset.Checked == false)
        {
            chkIsasset = 0;
        }
        else { chkIsasset = 1; }
        int chkIsInsurance = 0;
        if (chkUpdateIsInsurance.Checked == false)
        {
            chkIsInsurance = 0;
        }
        else {
            chkIsInsurance = 1;
        }

        string ledger = "";
        for (int i = 0; i < ddldeptupdate.Items.Count; i++)
        {
            if (ddldeptupdate.Items[i].Selected)
            {
                ledger += ddldeptupdate.Items[i].Value + ",";
            }
        }
        ledger = ledger.TrimEnd(',');
            try
            {

                string DelTerms = "DELETE FROM f_vendor_terms where vendor_id= '" + ViewState["VendorID"].ToString() + "'";
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, DelTerms);
                str = "UPDATE f_vendormaster SET VendorName='" + txtVendor.Text.Trim() + "',VendorCode='" + txtvenCode2.Text.Trim() + "',VendorType='" + ddlType2.SelectedItem.Text + "',VendorCategory='" + ddlvCat2.SelectedItem.Text + "',Bank='" + txtvenbank2.Text.Trim() + "',AccountNo='" + txtvenAcc2.Text.Trim() + "',PaymentMode='" + ddlVenPayment2.SelectedItem.Text + "',ShipmentDetail='" + txtvenShipDetail2.Text.Trim() + "',VATNo='" + txtVATNo2.Text.Trim() + "',Address1='" + txtAddress1.Text.Trim() + "',Address2='" + txtAddress2.Text.Trim() + "',Address3='" + txtAddress3.Text.Trim() + "',City='" + txtCity2.Text.Trim() + "',Country='" + txtCountry2.Text.Trim() + "',Telephone='" + txtPhone.Text + "',Mobile='" + txtMobile.Text + "',Email='" + txtEmail2.Text.Trim() + "',ContactPerson='" + txtContactPerson2.Text.Trim() + "',Pin='" + txtPinCode2.Text.Trim() + "',DrugLicence='" + txtDLNo2.Text.Trim() + "' , CreditDays='" + txtCreditDays1.Text + "',TinNo='" + Util.GetString(txtVATNo2.Text.Trim()) + "',Ven_GSTINNo='" + Util.GetString(txtGstInNoUpdate.Text.Trim()) + "',DeptledgerNo='" + ledger + "',CountryID='" + Util.GetInt(HFCountryID.Value) + "',StateID='" + Util.GetInt(HFStateID.Value) + "',IsAsset='" + chkIsasset + "',IsInsurance='" + chkIsInsurance + "',Currency='"+ ddlSupplierCurrency2.SelectedItem.Text +"' WHERE Vendor_ID='" + VendorID + "';";

                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);

                str = "UPDATE f_ledgermaster SET LedgerName='" + txtVendor.Text.Trim() + "' WHERE LedgerUserID='" + VendorID + "'";

                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);

                lblVUpMsg.Text = "";
                foreach (GridViewRow gr in grdTermsUpdate.Rows)
                {
                    if (((CheckBox)gr.FindControl("chkSelect")).Checked)
                    {
                        SqlUpdateTerms = "INSERT INTO f_vendor_terms(Vendor_Id,Terms_Id,Terms,CreatedBy) VALUES('" + VendorID + "','" + ((Label)gr.FindControl("lblTermsId")).Text + "','" + ((Label)gr.FindControl("lblTerms")).Text + "','" + Session["ID"].ToString() + "')";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, SqlUpdateTerms);
                    }

                }

                Tranx.Commit();
                btnSearch_Click(sender, e);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM02','" + lblMsg.ClientID + "');", true);
            }
            catch (Exception ex)
            {
                lblMsg.Text = ex.Message;
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
                Tranx.Rollback();
            }
            finally
            {
                Tranx.Dispose();
                con.Close();
                con.Dispose();
            }
      
       
    }
    protected void grdVendor_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        if (ViewState["vendor"] != null)
        {
            DataTable dt = (DataTable)ViewState["vendor"];
            grdVendor.PageIndex = e.NewPageIndex;
            grdVendor.DataSource = dt;
            grdVendor.DataBind();
        }
    }
    protected void grdVendor_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "AEdit")
        {
            DataTable dt = new DataTable();
            if (ViewState["vendor"] != null)
            {
                dt = (DataTable)ViewState["vendor"];
            }

            string VendorID = Util.GetString(e.CommandArgument);
            ViewState["VendorID"] = VendorID;
            BindUpdateTerms();
            DataRow[] dr = dt.Select("Vendor_ID='" + VendorID + "'");
            if (dr.Length > 0)
            {
                txtVendor.Text = Util.GetString(dr[0]["VendorName"]);
                txtvenCode2.Text = Util.GetString(dr[0]["VendorCode"]);
                ddlType2.SelectedIndex = ddlType2.Items.IndexOf(ddlType2.Items.FindByText(Util.GetString(dr[0]["VendorType"])));
                ddlvCat2.SelectedIndex = ddlvCat2.Items.IndexOf(ddlvCat2.Items.FindByText(Util.GetString(dr[0]["VendorCategory"])));
                txtvenbank2.Text = Util.GetString(dr[0]["Bank"]);
                txtvenAcc2.Text = Util.GetString(dr[0]["AccountNo"]);
                ddlVenPayment2.SelectedIndex = ddlVenPayment2.Items.IndexOf(ddlVenPayment2.Items.FindByText(Util.GetString(dr[0]["PaymentMode"])));
                txtvenShipDetail2.Text = Util.GetString(dr[0]["ShipmentDetail"]);
                txtVATNo2.Text = Util.GetString(dr[0]["VATNo"]);
                txtAddress1.Text = Util.GetString(dr[0]["Address1"]);
                txtAddress2.Text = Util.GetString(dr[0]["Address2"]);
                txtAddress3.Text = Util.GetString(dr[0]["Address3"]);
                txtCity2.Text = Util.GetString(dr[0]["City"]);
                txtCountry2.Text = Util.GetString(dr[0]["Country"]);
                txtDLNo2.Text = Util.GetString(dr[0]["DrugLicence"]);
                txtEmail2.Text = Util.GetString(dr[0]["Email"]);
                txtContactPerson2.Text = Util.GetString(dr[0]["ContactPerson"]);
                txtMobile.Text = Util.GetString(dr[0]["Mobile"]);
                txtPhone.Text = Util.GetString(dr[0]["Telephone"]);
                txtPinCode2.Text = Util.GetString(dr[0]["Pin"]);
                txtCreditDays1.Text = Util.GetString(dr[0]["CreditDays"]);
                txtGstInNoUpdate.Text = Util.GetString(dr[0]["Ven_GSTINNo"]);
                //ddldeptupdate.SelectedIndex =ddldeptupdate.Items.IndexOf(ddldeptupdate.Items.FindByValue(Util.GetString(dr[0]["DeptledgerNo"])));
                string ledger = Util.GetString(dr[0]["DeptledgerNo"]);
                string[] strarray = ledger.Split(',');
                for (int i = 0; i < strarray.Length; i++)
                {
                    for (int k = 0; k < ddldeptupdate.Items.Count; k++)
                    {
                        if (strarray[i] == ddldeptupdate.Items[k].Value)
                        {
                            ddldeptupdate.Items[k].Selected = true;
                        }
                    }
                }
                ddlcountry.SelectedIndex = ddlcountry.Items.IndexOf(ddlcountry.Items.FindByValue(Util.GetString(dr[0]["CountryID"])));

                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "getStateonUpdate(" + ddlcountry.SelectedValue + ");", true);
                ddlstate.SelectedIndex = ddlstate.Items.IndexOf(ddlstate.Items.FindByValue(Util.GetString(dr[0]["StateID"])));
                HFStateID.Value = Util.GetString(dr[0]["StateID"]);
                int isasset = Convert.ToInt32(dr[0]["IsAsset"]);
                if (isasset == 0)
                {
                    chkUpdateIsAsset.Checked = false;
                }
                else { chkUpdateIsAsset.Checked = true; }
                int IsInsurance=Convert.ToInt32(dr[0]["IsInsurance"]);
                if(IsInsurance==0)
                {
                    chkUpdateIsInsurance.Checked = false;
                }
                else
                {
                    chkUpdateIsInsurance.Checked = true;
                }
                

               // mpeCreateGroup.Show();

                ScriptManager.RegisterStartupScript(this, this.GetType(), "key5", "showUpdateSupplierModel();", true);
            }
        }
    }
    private void BindUpdateTerms()
    {


        string str = "SELECT IF(fvt.`Id` IS NULL,'false','true')IsCheck,ftc.Id,ftc.Terms FROM f_term_condition ftc LEFT JOIN f_vendor_terms fvt ON fvt.`Terms_Id`=ftc.`Id` and vendor_id='" + ViewState["VendorID"].ToString() + "' where ftc.Active=1 order by ftc.Terms";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            grdTermsUpdate.DataSource = dt;
            grdTermsUpdate.DataBind();
        }

        else
        {
            grdTermsUpdate.DataSource = null;
            grdTermsUpdate.DataBind();

        }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            BindPaymentMode();
            BindTerms();
            BindDeptNmae();
            loadCountry();
            if (Request.QueryString["Mode"] != null)
            {
                string mode = Request.QueryString["Mode"].ToString();
                if (mode == "1")
                {
                   // Master.FindControl("mnuHIS").Visible = false;
                    //Master.FindControl("ddlUserName").Visible = false;
                   // Master.FindControl("lnkSignOut").Visible = false;
                    var divNav = (HtmlControl)Master.FindControl("divMasterNav");
                    divNav.Attributes.CssStyle.Add("display", "none");
                }
            }
        }
        string DeptLedgerNo = Session["DeptLedgerNo"].ToString();
        if (DeptLedgerNo.ToString() == AllGlobalFunction.MedicalDeptLedgerNo)//medical store items
        {
            ddlvCat.SelectedIndex = ddlvCat.Items.IndexOf(ddlvCat.Items.FindByText(Util.GetString("MEDICAL ITEMS")));
        }
        else
        {
            ddlvCat.SelectedIndex = ddlvCat.Items.IndexOf(ddlvCat.Items.FindByText(Util.GetString("GENERAL ITEMS")));
        }
    }


    private void BindPaymentMode()
    {
        DataTable dt = All_LoadData.LoadCurrencyFactor("");
        if (dt.Rows.Count > 0)
        {
            ddlSupplierCurrency.DataTextField = "Currency";
            ddlSupplierCurrency.DataValueField = "CountryID";
            ddlSupplierCurrency.DataSource = dt;
            ddlSupplierCurrency.DataBind();

            ddlSupplierCurrency2.DataTextField = "Currency";
            ddlSupplierCurrency2.DataValueField = "CountryID";
            ddlSupplierCurrency2.DataSource = dt;
            ddlSupplierCurrency2.DataBind();

            DataRow[] dr = dt.Select("IsBaseCurrency=1");
            ddlVenPayment.SelectedIndex = ddlVenPayment.Items.IndexOf(ddlVenPayment.Items.FindByValue(dr[0]["CountryID"].ToString()));
        }
    }
    private void BindVendor()
    {
        DataTable dt = Search();
        ViewState["vendor"] = dt;

        if (dt != null && dt.Rows.Count > 0)
        {
            grdVendor.DataSource = dt;
            grdVendor.DataBind();
        }
        else
        {
            grdVendor.DataSource = null;
            grdVendor.DataBind();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }
    }
    private void BindTerms()
    {
        string str = "SELECT Id,Terms FROM f_term_condition";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            grdTerms.DataSource = dt;
            grdTerms.DataBind();

        }

        else
        {
            grdTerms.DataSource = null;
            grdTerms.DataBind();

        }

    }
    public void BindDeptNmae()
    {
        string sql = "SELECT DeptName,DeptLedgerNo FROM f_rolemaster WHERE IsStore=1";
        DataTable dt = StockReports.GetDataTable(sql);

        if (dt.Rows.Count > 0)
        {
            ddlDeptName.DataSource = dt;
            ddlDeptName.DataTextField = "DeptName";
            ddlDeptName.DataValueField = "DeptLedgerNo";
            ddlDeptName.DataBind();
            //ddlDeptName.Items.Insert(0, new ListItem("Select", "0"));

            ddldeptupdate.DataSource = dt;
            ddldeptupdate.DataTextField = "DeptName";
            ddldeptupdate.DataValueField = "DeptLedgerNo";
            ddldeptupdate.DataBind();
            //ddldeptupdate.Items.Insert(0, new ListItem("Select", "0"));
        }
        else
        {
            ddlDeptName.DataSource = null;
            ddlDeptName.DataBind();
            ddldeptupdate.DataSource = null;
            ddldeptupdate.DataBind();
        }
    }
    private void ClearData()
    {
        txtEmail.Text = string.Empty;
        txtVAT.Text = string.Empty;
        txtVen1.Text = "";
        txtVAT.Text = "";
        txtTel1.Text = "";
        txtMob1.Text = "";
        txtCity1.Text = "";
        txtAdd1.Text = "";
        txtAdd2.Text = "";
        txtAdd3.Text = "";
        txtContact.Text = "";
        txtCountry.Text = "";
        txtPinCode.Text = "";
        txtVendor.Text = string.Empty;
        txtVendorName.Text = string.Empty;
        txtVATNo2.Text = string.Empty;
        txtDLNo.Text = string.Empty;
        txtDLNo2.Text = string.Empty;
        txtvenAcc.Text = "";
        txtvenAcc2.Text = "";
        txtvenbank.Text = "";
        txtvenbank2.Text = "";
        txtvenCode.Text = "";
        txtvenCode2.Text = "";
        txtvenShipDetail.Text = "";
        txtvenShipDetail2.Text = "";
        lblVMsg.Text = "";
        lblVUpMsg.Text = "";
        txtGstInNoUpdate.Text = "";
        txtGstTinNo.Text = "";
        txtCreditDays.Text = "";
        txtCreditDays1.Text = "";
    }
    private DataTable Search()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select creditdays,Vendor_ID,VendorName,VendorCode,VendorType,VendorCategory,Bank,AccountNo,PaymentMode,ShipmentDetail,VATNo,if(Address1 = 'Null','',address1)As Address1,DrugLicence,Pin,");
        sb.Append(" if(Address2 ='NULL','',Address2)as Address2,if(Address3 ='NULL','',Address3)as Address3,if(ContactPerson ='NULL','',ContactPerson) as ContactPerson,Email,");
        sb.Append(" if(Telephone = 'NULL','',Telephone)as Telephone,if(Mobile='NULL','',Mobile) as Mobile,");
        sb.Append(" if(City = 'NULL','',City)as City,if(Area = 'NULL','',Area)as Area,IsAsset,IsInsurance, ");
        sb.Append(" (SELECT NAME FROM country_master WHERE CountryID=vm.CountryID) AS Country, ");
        sb.Append(" (SELECT StateName FROM master_state WHERE StateID=vm.StateID) AS State, ");
        sb.Append(" (SELECT NAME FROM f_categorymaster WHERE CategoryID=vsg.CategoryID)CategoryName,(SELECT NAME FROM f_subcategorymaster WHERE SubcategoryID=vsg.SubCategoryID)SubCategoryName,IFNULL(vm.Ven_GSTINNo,'') Ven_GSTINNo,IFNULL(vm.DeptledgerNo,'')DeptledgerNo,vm.StateID,vm.CountryID,vm.Currency  from f_vendormaster vm LEFT JOIN f_Vendor_SubCategory vsg ON vsg.VendorID=vm.Vendor_ID ");

        if (txtVendorName.Text.Trim() != string.Empty)
            sb.Append(" where VendorName like '" + txtVendorName.Text.Trim() + "%'");
       
        sb.Append(" order by VendorName");

        return StockReports.GetDataTable(sb.ToString());
    }
    private DataTable SearchVendorForEReport()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select CreditDays,VendorName,VendorCode,VendorType,VendorCategory,Bank,AccountNo,PaymentMode,ShipmentDetail,TinNo VATNo,if(Address1 = 'Null','',address1)As Address1,DrugLicence,Pin,");
        sb.Append(" if(Address2 ='NULL','',Address2)as Address2,if(Address3 ='NULL','',Address3)as Address3,if(ContactPerson ='NULL','',ContactPerson) as ContactPerson,Email,");
        sb.Append(" if(Telephone = 'NULL','',Telephone)as Telephone,if(Mobile='NULL','',Mobile) as Mobile,");
        sb.Append(" if(City = 'NULL','',City)as City,if(Area = 'NULL','',Area)as Area, ");
        sb.Append(" IF(IsInsurance=1,'Yes','No')IsInsuranceProvider, ");
        sb.Append(" (SELECT NAME FROM country_master WHERE CountryID=vm.CountryID) AS Country, ");
        sb.Append(" (SELECT StateName FROM master_state WHERE StateID=vm.StateID) AS State, ");
        sb.Append(" (SELECT NAME FROM f_categorymaster WHERE CategoryID=vsg.CategoryID)CategoryName,(SELECT NAME FROM f_subcategorymaster WHERE SubcategoryID=vsg.SubCategoryID)SubCategoryName from f_vendormaster vm LEFT JOIN f_Vendor_SubCategory vsg ON vsg.VendorID=vm.Vendor_ID ");

        if (txtVendorName.Text.Trim() != string.Empty)
            sb.Append(" where VendorName like '" + txtVendorName.Text.Trim() + "%'");
       

        sb.Append(" order by VendorName");

        return StockReports.GetDataTable(sb.ToString());
    }
    private DataTable SearchVendorForExcelEReport()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select VendorName 'Supplier Name',VendorCode 'Supplier Code',VendorType 'Supplier Type',VendorCategory 'Supplier Category',Bank,AccountNo 'Account No.',PaymentMode 'Payment Mode',ShipmentDetail 'Shipment Detail',Pin 'Postal Code',");
        sb.Append(" if(Address1 = 'Null','',address1)As Address1,if(Address2 ='NULL','',Address2)as Address2,if(Address3 ='NULL','',Address3)as Address3,if(ContactPerson ='NULL','',ContactPerson) as 'Contact Person',Email,CreditDays,");
        sb.Append(" if(Mobile='NULL','',Mobile) as 'Contact No.',");
        sb.Append(" if(City = 'NULL','',City)as City,IF(IsInsurance=1,'Yes','No')IsInsuranceProvider, ");
        sb.Append(" (SELECT NAME FROM country_master WHERE CountryID=vm.CountryID) AS Country, ");
        sb.Append(" (SELECT StateName FROM master_state WHERE StateID=vm.StateID) AS State ");
        sb.Append(" from f_vendormaster vm LEFT JOIN f_Vendor_SubCategory vsg ON vsg.VendorID=vm.Vendor_ID ");

        if (txtVendorName.Text.Trim() != string.Empty)
            sb.Append(" where VendorName like '" + txtVendorName.Text.Trim() + "%'");
      

        sb.Append(" order by VendorName");

        return StockReports.GetDataTable(sb.ToString());
    }
    protected void ddlcountry_SelectedIndexChanged(object sender, EventArgs e)
    {
        loadState(Util.GetInt(ddlcountry.SelectedItem.Value));
       // mpeCreateGroup.Show();
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "showUpdateSupplierModel();", true);
    }
  
    public void loadCountry()
    {
        DataTable dt = new DataTable();
        string CacheName = "Country";
        if (HttpContext.Current.Cache[CacheName] != null)
            dt = HttpContext.Current.Cache[CacheName] as DataTable;
        else
        {
            string qstr = "SELECT CountryID,Name,IsBaseCurrency FROM country_master WHERE IsActive=1 ORDER By SeqNo,Name";
            dt = StockReports.GetDataTable(qstr);

            File.Create(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")).Close();
            File.WriteAllText(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt"), DateTime.Now.ToString());
            HttpContext.Current.Cache.Insert(CacheName, dt, new System.Web.Caching.CacheDependency(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")), DateTime.Now.AddMinutes(Util.GetInt(Resources.Resource.CountryCacheTimeOut)), System.Web.Caching.Cache.NoSlidingExpiration);
        }
        if (dt.Rows.Count > 0)
        {
            ddlcountry.DataSource = dt;
            ddlcountry.DataTextField = "Name";
            ddlcountry.DataValueField = "CountryID";
            ddlcountry.DataBind();         
            loadState(Util.GetInt(ddlcountry.SelectedValue));

            ddlcountry1.DataSource = dt;
            ddlcountry1.DataTextField = "Name";
            ddlcountry1.DataValueField = "CountryID";
            ddlcountry1.DataBind();
          //  loadState1(Util.GetInt(ddlcountry1.SelectedValue));
        }
    }
    public void loadState(int countryID)
    {
        try
        {
            DataTable dt;
            string str = "SELECT StateID,StateName,IsCurrent,CountryID FROM master_State WHERE IsActive=1 AND StateName<>'' and CountryID='" + countryID + "' ORDER BY StateName";
            dt = StockReports.GetDataTable(str);

            if (dt.Rows.Count > 0)
            {
                ddlstate.DataSource = dt;
                ddlstate.DataTextField = "StateName";
                ddlstate.DataValueField = "StateID";
                ddlstate.DataBind();
                ddlstate.Items.Insert(0, "-Select-");
            }
            else
            {
                ddlstate.DataSource = null;
                ddlstate.DataBind();
            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
      
        }
    }
    //public void loadState1(int countryID)
    //{
    //    try
    //    {
    //        DataTable dt;

    //        string str = "SELECT StateID,StateName,IsCurrent,CountryID FROM master_State WHERE IsActive=1 AND StateName<>'' and CountryID='" + countryID + "' ORDER BY StateName";
    //        dt = StockReports.GetDataTable(str);
    //        if (dt.Rows.Count > 0)
    //        {
    //            ddlstate1.DataSource = dt;
    //            ddlstate1.DataTextField = "StateName";
    //            ddlstate1.DataValueField = "StateID";
    //            ddlstate1.DataBind();
    //            ddlstate1.Items.Insert(0, "-Select-");
    //        }
    //        else
    //        {
    //            ddlstate1.DataSource = null;
    //            ddlstate1.DataBind();
    //        }

    //    }
    //    catch (Exception ex)
    //    {
    //        ClassLog cl = new ClassLog();
    //        cl.errLog(ex);

    //    }
    //}

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string getState(string CountryID)
    {
        DataTable dtPanel = new DataTable();
        dtPanel = StockReports.GetDataTable("SELECT StateID,StateName FROM master_State WHERE IsActive=1 AND StateName<>''  and CountryID='" + CountryID + "' ORDER BY StateName");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtPanel);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string getCountry()
    {
        DataTable dtPanelGroup = StockReports.GetDataTable("SELECT CountryID,Name FROM country_master WHERE IsActive=1 ORDER By Name");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtPanelGroup);
    }

}