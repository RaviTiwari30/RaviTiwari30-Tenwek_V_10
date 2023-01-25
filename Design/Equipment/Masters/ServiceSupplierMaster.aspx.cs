using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Data;

public partial class Design_Equipment_Masters_ServiceSupplierMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindSupplierType();
            //LastUpdatedby,UpdateDate,IPAddress
            ViewState["LastUpdatedby"] = Session["ID"].ToString();
            ViewState["IPAddress"] = All_LoadData.IpAddress().ToString();
            ViewState["IsUpdate"] = "S";
            LoadData();
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
            ddlSupplierType.Items.Insert(0, new ListItem("SELECT", "SELECT"));

        }
        else
        {
            ddlSupplierType.DataSource = null;
            ddlSupplierType.DataBind();
        }
    }   

    private void LoadData()
    {
        grdSupplier.DataSource = null;
        grdSupplier.DataBind();

        string str = "SELECT rm.Vendor_ID,rm.VendorName,rm.ContactPerson,rm.Address1,rm.Address2,rm.Address3,rm.Country,rm.City,";
        str += "rm.Area,rm.Pin,rm.Telephone,rm.Mobile,rm.DrugLicence,rm.VATNo,rm.TinNo,rm.Email,";
        str += "(SELECT SupplierTypeName FROM eq_SupplierType_master WHERE SupplierTypeID=rm.SupplierTypeID)SupplierTypeName,";        
        str += "IF(rm.IsActive=1,'Yes','No')IsActive,(SELECT NAME FROM employee_master WHERE rm.LastUpdatedby=employee_ID)LastUpdatedby,";
        str += "CONCAT(DATE_FORMAT(rm.UpdateDate,'%d-%b-%y'),' ',TIME_FORMAT(rm.UpdateDate,'%T'))UpdateDate,";
        str += "rm.IPAddress FROM f_vendormaster rm order by rm.Vendorname ";

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
                string str = "";
                int IsActive = 0;

                if (chkActive.Checked)
                    IsActive = 1;

                if (ViewState["IsUpdate"].ToString() == "S")
                {
                   
                }
                else
                {
                    str = "Update f_vendormaster Set VendorName='" + txtname.Text.Trim() + "',ContactPerson='" + txtContact.Text.Trim() + "',IsActive = " + IsActive + ",";
                    str += "SupplierTypeID='" + ddlSupplierType.SelectedValue + "',Address1='" + txtAdd1.Text.Trim() + "',Address2='" + txtAdd2.Text.Trim() + "', ";
                    str += "Country='" + txtCountry.Text.Trim() + "',City='" + txtCity1.Text.Trim() + "',";
                    str += "Pin='" + txtPinCode.Text.Trim() + "',Telephone='" + txtTel1.Text.Trim() + "',Mobile='" + txtMob1.Text.Trim() + "',DrugLicence='" + txtDLNo.Text.Trim() + "',";
                    str += "VATNo='" + txtVatNo.Text.Trim() + "',TinNo='" + txtTinNo.Text.Trim() + "',Email='" + txtEmail.Text.Trim() + "',";
                    str += "LastUpdatedby='" + ViewState["LastUpdatedby"].ToString() + "',UpdateDate=Now(),IPAddress='" + ViewState["IPAddress"].ToString() + "' ";
                    str += "Where Vendor_ID='" + ViewState["Vendor_ID"].ToString() + "' ";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
                }

              

                tnx.Commit();
                conn.Close();
                conn.Dispose();

                lblMsg.Text = "Record Saved";
                ViewState["Vendor_ID"] = "";
                ViewState["IsUpdate"] = "S";
                btnsave.Text = "Save";
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

    private void Commit()
    {
        throw new NotImplementedException();
    }    

    private bool CheckValidation()
    {
        if (ddlSupplierType.SelectedValue.ToUpper() == "SELECT")
        {
            lblMsg.Text = "Select SupplierType";
            ddlSupplierType.Focus();
            return false;
        }
        

        if (txtname.Text.Trim() == "")
        {
            lblMsg.Text = "Provide Supplier Name";
            return false;
        }        

        //if (ViewState["IsUpdate"].ToString() == "S")
        //{
        //    string isExist = StockReports.ExecuteScalar("SElECT VendorName from f_vendormaster Where VendorName ='" + txtname.Text.Trim() + "' and SupplierTypeID=" + ddlSupplierType.SelectedValue + "");

        //    if (isExist != string.Empty)
        //    {
        //        lblMsg.Text = "Duplicate Record Exist";
        //        return false;
        //    }

        //}
        return true;
    }

    private void ClearFields()
    {
        ddlSupplierType.SelectedIndex = 0;       
        txtname.Text = "";
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
                
                txtname.Text = dt.Rows[0]["VendorName"].ToString();
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

                if (dt.Rows[0]["IsActive"].ToString() == "1")
                    chkActive.Checked = true;
                else
                    chkActive.Checked = false;

                ViewState["Vendor_ID"] = Vendor_ID;
                ViewState["IsUpdate"] = "U";
                btnsave.Text = "Update";
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
                    "FROM tg_f_vendormaster vm WHERE vm.Vendor_ID='" + Vendor_ID + "'  GROUP BY Vendor_ID ");

            lblLog.Text = DataLog;
            mdpLog.Show();
        }
    }
    
}