using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Data;

public partial class Design_Equipment_Masters_SupplierMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindSupplierType();
            BindPaymentMode();            
            ViewState["LastUpdatedby"] = Session["ID"].ToString();
            ViewState["IPAddress"] = All_LoadData.IpAddress().ToString();
            ViewState["IsUpdate"] = "S";
            LoadData();
            chkActive.Checked = true;
            chkActive.Enabled = false;
        }
        lblMsg.Text = "";
    }

    private void BindSupplierType()
    {
        string str = "SELECT SupplierTypeName,SupplierTypeID from eq_SupplierType_master Where IsActive=1";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {
            ddlSupplierType.DataSource = dt;
            ddlSupplierType.DataTextField = "SupplierTypeName";
            ddlSupplierType.DataValueField = "SupplierTypeID";
            ddlSupplierType.DataBind();
            ddlSupplierType.Items.Insert(0, new ListItem("SELECT", ""));
        }
        else
        {
            ddlSupplierType.DataSource = null;
            ddlSupplierType.DataBind();
            ddlSupplierType.Items.Insert(0, new ListItem("SELECT", ""));
        }
    }

    private void BindPaymentMode()
    {
        DataTable dt = All_LoadData.LoadCurrencyFactor("");
        if (dt.Rows.Count > 0)
        {
            ddlPaymentType.DataTextField = "Currency";
            ddlPaymentType.DataValueField = "CountryID";
            ddlPaymentType.DataSource = dt;
            ddlPaymentType.DataBind();          

            DataRow[] dr = dt.Select("IsBaseCurrency=1");
            ddlPaymentType.SelectedIndex = ddlPaymentType.Items.IndexOf(ddlPaymentType.Items.FindByValue(dr[0]["CountryID"].ToString()));
        }
    }

    private void LoadData()
    {
        grdSupplier.DataSource = null;
        grdSupplier.DataBind();

        string str = "SELECT rm.Vendor_ID,rm.VendorName,rm.ContactPerson,rm.Address1,rm.Address2,rm.Address3,rm.Country,rm.City,";
        str += "rm.Area,rm.Pin,rm.Telephone,rm.Mobile,rm.DrugLicence,rm.VATNo,rm.TinNo,rm.Email,";
        str += "(SELECT SupplierTypeName FROM eq_SupplierType_master WHERE SupplierTypeID=rm.SupplierTypeID)SupplierTypeName,";        
        str += "IF(rm.IsActive=1,'Yes','No')IsActive,(SELECT NAME FROM employee_master WHERE rm.LastUpdatedby=employee_ID LIMIT 1)LastUpdatedby,";
        str += "CONCAT(DATE_FORMAT(rm.UpdateDate,'%d-%b-%y'),' ',TIME_FORMAT(rm.UpdateDate,'%T'))UpdateDate,";
        str += "rm.IPAddress FROM f_vendormaster rm where rm.IsActive=1  order by rm.Vendorname ";

        DataTable dt = StockReports.GetDataTable(str);

        grdSupplier.DataSource = dt;
        grdSupplier.DataBind();
    }

    protected void btnsave_Click(object sender, EventArgs e)
    {
        if (CheckValidation())
        {   
            MySqlConnection conn = Util.GetMySqlCon();
            conn.Open();
            MySqlTransaction tnx = conn.BeginTransaction();
            
            try
            {                
                string VendorID = "";
                int IsActive = 0;
                
                if (chkActive.Checked)
                    IsActive = 1;

                if (ViewState["IsUpdate"].ToString() == "S")
                {

                    vendor objVendor = new vendor(tnx);
                    objVendor.VendorName = Util.GetString(txtName.Text.Trim());
                    objVendor.VendorCode = "";
                    objVendor.VendorType = "";
                    objVendor.VendorCategory = "";
                    objVendor.Bank = Util.GetString(txtBankName.Text.Trim());
                    objVendor.AccountNo = Util.GetString(txtAccountNo.Text.Trim());
                    objVendor.PaymentMode = Util.GetString(ddlPaymentType.SelectedItem.Text);
                    objVendor.ShipmentDetail = Util.GetString(txtShipDetail.Text.Trim());
                    objVendor.VATNo = Util.GetString(txtVatNo.Text.Trim());
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
                    objVendor.TinNo = Util.GetString(txtTinNo.Text.Trim());
                    objVendor.SupplierTypeID = Util.GetString(ddlSupplierType.SelectedValue);
                    objVendor.IsActive = Util.GetString(IsActive);
                    
                    VendorID = objVendor.Insert();
                    if (VendorID != string.Empty)
                    {
                        Ledger_Master objLM = new Ledger_Master(tnx);
                        objLM.GroupID = "VEN";
                        objLM.LegderName = Util.GetString(txtName.Text.Trim());
                        objLM.LedgerUserID = VendorID;
                        objLM.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                        objLM.OpeningBalance = Util.GetDecimal(0);
                        objLM.ClosingBalance = Util.GetDecimal(0);
                        objLM.CurrentBalance = Util.GetDecimal(0);                        
                        string i=  objLM.Insert().ToString();
                        if (i == "0")
                        {
                            tnx.Rollback();
                            conn.Close();
                            conn.Dispose();
                            lblMsg.Text = "Record Not Saved";
                            return;
                        }
                        else
                        {
                            lblMsg.Text = "Record Saved Successfully";
                        }
                    }                    
                }
                else
                {

                    string str = "";
                    str = "UPDATE f_vendormaster SET SupplierTypeID='" + Util.GetString(ddlSupplierType.SelectedValue) + "',VendorName='" + Util.GetString(txtName.Text.Trim()) + "',Bank='" + Util.GetString(txtBankName.Text.Trim()) + "',AccountNo='" + Util.GetString(txtAccountNo.Text.Trim()) + "', ";
                    str += "PaymentMode='" + Util.GetString(ddlPaymentType.SelectedValue) + "',ShipmentDetail='" + Util.GetString(txtShipDetail.Text.Trim()) + "',TinNo='" + Util.GetString(txtTinNo.Text.Trim()) + "',DrugLicence='" + Util.GetString(txtDLNo.Text.Trim()) + "', ";
                    str += "VATNo='" + Util.GetString(txtVatNo.Text.Trim()) + "',ContactPerson='" + Util.GetString(txtContact.Text.Trim()) + "',Mobile='" + Util.GetString(txtMob1.Text.Trim()) + "',Telephone='" + Util.GetString(txtTel1.Text.Trim()) + "',Address1='" + Util.GetString(txtAdd1.Text.Trim()) + "', ";
                    str += "Address2='" + Util.GetString(txtAdd2.Text.Trim()) + "',Address3='" + Util.GetString(txtAdd3.Text.Trim()) + "',City='" + Util.GetString(txtCity1.Text.Trim()) + "',Country='" + Util.GetString(txtCountry.Text.Trim()) + "',Pin='" + Util.GetString(txtPinCode.Text.Trim()) + "',IsActive="+Util.GetInt(IsActive)+", ";
                    str += "LastUpdatedby='" + ViewState["LastUpdatedby"].ToString() + "',UpdateDate=Now(),IPAddress='" + ViewState["IPAddress"].ToString() + "',CreditDays='"+Util.GetString(txtCreditDays.Text.Trim())+"' ";
                    str += "Where Vendor_ID='" + ViewState["Vendor_ID"].ToString() + "' ";
                    
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
                    lblMsg.Text = "Record Update Successfully";
                    //string str="";
                    //str = "Update f_vendormaster Set VendorName='" + txtName.Text.Trim() + "',ContactPerson='" + txtContact.Text.Trim() + "',IsActive = " + IsActive + ",";
                    //str += "SupplierTypeID='" + ddlSupplierType.SelectedValue + "',Address1='" + txtAdd1.Text.Trim() + "',Address2='" + txtAdd2.Text.Trim() + "',Address3='" + txtAdd3.Text.Trim() + "',";
                    //str += "Country='" + txtCountry.Text.Trim() + "',City='" + txtCity1.Text.Trim() + "',";
                    //str += "Pin='" + txtPinCode.Text.Trim() + "',Telephone='" + txtTel1.Text.Trim() + "',Mobile='" + txtMob1.Text.Trim() + "',DrugLicence='" + txtDLNo.Text.Trim() + "',";
                    //str += "VATNo='" + txtVatNo.Text.Trim() + "',TinNo='" + txtTinNo.Text.Trim() + "',Email='" + txtEmail.Text.Trim() + "',";
                    //
                    //str += "Where Vendor_ID='" + ViewState["Vendor_ID"].ToString() + "' ";
                    //MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
                }

              

                tnx.Commit();
                conn.Close();
                conn.Dispose();
                ViewState["Vendor_ID"] = "";
                ViewState["IsUpdate"] = "S";
                btnsave.Text = "Save";
                chkActive.Checked = true;
                chkActive.Enabled = false;
                ClearFields();
                LoadData();
            }
            catch (Exception ex)
            {

                tnx.Rollback();
                conn.Close();
                conn.Dispose();

                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                lblMsg.Text = ex.Message;
            }
        }
    }

    private bool CheckValidation()
    {
        int Vendor = 0;
        
        if (ddlSupplierType.SelectedItem.Text.ToUpper() == "SELECT")
        {
            lblMsg.Text = "Select SupplierType";
            ddlSupplierType.Focus();
            return false;
        } 

        if (txtName.Text.Trim() == "")
        {
            lblMsg.Text = "Enter Supplier Name";
            txtName.Focus();
            return false;
        }

        if (txtMob1.Text.Trim() == "")
        {
            lblMsg.Text = "Enter Mobile Number";
            txtMob1.Focus();
            return false;
        }

        if (txtCreditDays.Text.Trim() == "")
        {
            lblMsg.Text = "Enter Credit Days";
            txtCreditDays.Focus();
            return false;
        }

        if (ViewState["IsUpdate"].ToString() == "S")
        {
            Vendor = Util.GetInt(StockReports.ExecuteScalar("SELECT count(*) FROM f_vendormaster WHERE VendorName ='" + txtName.Text.Trim() + "' "));
            if (Vendor > 0)
            {
                lblMsg.Text = "Vendor Already Exist";
                txtName.Focus();
                return false;
            }

            Vendor = Util.GetInt(StockReports.ExecuteScalar("SELECT count(*) FROM f_vendormaster WHERE Mobile ='" + txtMob1.Text.Trim() + "' "));
            if (Vendor > 0)
            {
                lblMsg.Text = "Vendor Contact No. Already Exist";
                txtMob1.Focus();
                return false;
            }
        }
     
        return true;
    }

    private void ClearFields()
    {
        ddlSupplierType.SelectedIndex = 0;       
        txtName.Text = "";
        txtBankName.Text = "";
        txtAccountNo.Text = "";
        ddlPaymentType.SelectedIndex = 0;
        txtShipDetail.Text = "";
        txtContact.Text = "";
        txtAdd1.Text = "";
        txtAdd2.Text = "";
        txtAdd3.Text = "";
        txtCountry.Text = "";
        txtCity1.Text = "";
        txtTel1.Text = "";
        txtMob1.Text = "";
        txtEmail.Text = "";
        txtTinNo.Text = "";
        txtVatNo.Text = "";
        txtDLNo.Text = "";
        txtPinCode.Text = "";
        txtCreditDays.Text = "";
    }

    protected void grdSupplier_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string Vendor_ID = Util.GetString(e.CommandArgument);

        if (e.CommandName == "EditAT")
        {
            DataTable dt = StockReports.GetDataTable("SELECT * FROM f_vendormaster WHERE Vendor_ID='" + Vendor_ID + "' ");
            if (dt != null && dt.Rows.Count > 0)
            {
                ddlSupplierType.SelectedIndex = ddlSupplierType.Items.IndexOf(ddlSupplierType.Items.FindByValue(dt.Rows[0]["SupplierTypeID"].ToString()));               
                txtName.Text = dt.Rows[0]["VendorName"].ToString();
                txtBankName.Text = dt.Rows[0]["Bank"].ToString();
                txtAccountNo.Text = dt.Rows[0]["AccountNo"].ToString();
                txtShipDetail.Text = dt.Rows[0]["ShipmentDetail"].ToString();
                ddlPaymentType.SelectedIndex=ddlPaymentType.Items.IndexOf(ddlPaymentType.Items.FindByValue(dt.Rows[0]["PaymentMode"].ToString()));
                txtContact.Text = dt.Rows[0]["ContactPerson"].ToString();
                txtAdd1.Text = dt.Rows[0]["Address1"].ToString();
                txtAdd2.Text = dt.Rows[0]["Address2"].ToString();
                txtAdd3.Text = dt.Rows[0]["Address3"].ToString();
                txtCountry.Text = dt.Rows[0]["Country"].ToString();
                txtCity1.Text = dt.Rows[0]["City"].ToString();
                txtTel1.Text = dt.Rows[0]["Telephone"].ToString();
                txtPinCode.Text = dt.Rows[0]["Pin"].ToString();
                txtMob1.Text = dt.Rows[0]["Mobile"].ToString();
                txtEmail.Text = dt.Rows[0]["Email"].ToString();
                txtTinNo.Text = dt.Rows[0]["TinNo"].ToString();
                txtVatNo.Text = dt.Rows[0]["VATNo"].ToString();
                txtDLNo.Text = dt.Rows[0]["DrugLicence"].ToString();
                txtCreditDays.Text = dt.Rows[0]["CreditDays"].ToString();

                if (dt.Rows[0]["IsActive"].ToString() == "1")
                    chkActive.Checked = true;
                else
                    chkActive.Checked = false;

                ViewState["Vendor_ID"] = Vendor_ID;
                ViewState["IsUpdate"] = "U";
                btnsave.Text = "Update";
                chkActive.Enabled=true;
            }
        }
        else if (e.CommandName == "ViewLog")
        {
            string DataLog = StockReports.ExecuteScalar("SELECT GROUP_CONCAT(CONCAT('LastUpdatedBy :',IFNULL((SELECT NAME FROM employee_master WHERE Employee_ID=vm.LastUpdatedBy),''),'  Updatedate : ', " +
                    "IFNULL(CONCAT(DATE_FORMAT(vm.Updatedate,'%d-%b-%y'),' ',TIME_FORMAT(vm.Updatedate,'%T')),''),'  IP Address : ',IFNULL(vm.IPAddress,''), " +
                    "'</BR>Supplier : ',IFNULL(vm.VendorName,''),'  SupplierType : ',IFNULL((SELECT SupplierTypeName FROM eq_SupplierType_master WHERE SupplierTypeID=vm.SupplierTypeID LIMIT 1),''),'  IsActive : ',IF(vm.IsActive=1,'Yes','No'), " +
                    "'</BR>Address - 1 : ',IFNULL(vm.Address1,''), " +
                    "'</BR>Address - 2 : ',IFNULL(vm.Address2,''), " +
                    "'</BR>Address - 3 : ',IFNULL(vm.Address3,''), " +
                    "'</BR>City : ',IFNULL(vm.City,''),'  Country : ',IFNULL(vm.Country,''),'  Pin : ',IFNULL(vm.Pin,''), " +
                    "'</BR>Mobile : ',IFNULL(vm.Mobile,''),'  Telephone : ',IFNULL(vm.Telephone,''),'  Email : ',IFNULL(vm.Email,''), " +
                    "'</BR>DrugLicence : ',IFNULL(vm.DrugLicence,''),'  VATNo : ',IFNULL(vm.VATNo,''),'  TinNo : ',IFNULL(vm.TinNo,'')) SEPARATOR '</BR></BR></BR>')VenLog  " +
                    "FROM tg_f_servicetypemaster vm WHERE vm.Vendor_ID='" + Vendor_ID + "'  GROUP BY Vendor_ID ");

            lblLog.Text = DataLog;
            mdpLog.Show();
        }
    }

    //private void DisableControls()
    //{
    //    ddlSupplierType.Enabled = false;
    //    txtName.Enabled = false;
    //    txtBankName.Enabled = false;
    //    txtAccountNo.Enabled = false;
    //    ddlPaymentType.Enabled = false;
    //    txtShipDetail.Enabled = false;
    //    txtContact.Enabled = false;
    //    txtAdd1.Enabled = false;
    //    txtAdd2.Enabled = false;
    //    txtAdd3.Enabled = false;
    //    txtCountry.Enabled = false;
    //    txtCity1.Enabled = false;
    //    txtTel1.Enabled = false;
    //    txtMob1.Enabled = false;
    //    txtEmail.Enabled = false;
    //    txtTinNo.Enabled = false;
    //    txtVatNo.Enabled = false;
    //    txtDLNo.Enabled = false;
    //    txtPinCode.Enabled = false;
    //    txtCreditDays.Enabled = false;
    //}

    //private void EnableControls()
    //{
    //    ddlSupplierType.Enabled = true;
    //    txtName.Enabled = true;
    //    txtBankName.Enabled = true;
    //    txtAccountNo.Enabled = true;
    //    ddlPaymentType.Enabled = true;
    //    txtShipDetail.Enabled = true;
    //    txtContact.Enabled = true;
    //    txtAdd1.Enabled = true;
    //    txtAdd2.Enabled = true;
    //    txtAdd3.Enabled = true;
    //    txtCountry.Enabled = true;
    //    txtCity1.Enabled = true;
    //    txtTel1.Enabled = true;
    //    txtMob1.Enabled = true;
    //    txtEmail.Enabled = true;
    //    txtTinNo.Enabled = true;
    //    txtVatNo.Enabled = true;
    //    txtDLNo.Enabled = true;
    //    txtPinCode.Enabled = true;
    //    txtCreditDays.Enabled = true;
    //}
    
}



