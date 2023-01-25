using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Web.UI.HtmlControls;

public partial class Design_Pharma_ManufactureMaster : System.Web.UI.Page
{
    public DataTable BindManufacture()
    {
        string str = "";

        str = "SELECT if(fmm.IsAsset=1,'Yes','No')IsAsset,fmm.ManufactureID,fmm.Name CompanyName,fmm.Contact_Person ContactPerson,fmm.Address Address1,fmm.Address2,fmm.Address3,fmm.Phone,fmm.Mobile,fmm.Fax,fmm.Email,IFNULL(fmm.Man_GSTINNo,'')Man_GSTINNo,fmm.Country,fmm.City,fmm.PinCode,fmm.DLNo,fmm.TinNo,IF(fmm.IsActive='1','Active','InActive')IsActive,DATE_FORMAT(fmm.EntryDate,'%d-%b-%Y /%h:%i%p')EntryDate,(em.Name)UserName,fmm.manufactureCode FROM f_manufacture_master fmm INNER JOIN employee_master em ON fmm.UserID=EmployeeID";
        if (txtManuName.Text.Trim() != string.Empty)
            str = str + " and fmm.Name like '" + txtManuName.Text.Trim().Replace("'", "''") + "%'";
        str = str + " order by fmm.Name";
        return StockReports.GetDataTable(str);
    }

    protected void BindManufactureGrd()
    {
        DataTable dt = BindManufacture();
        ViewState["dt"] = dt;
        if (dt.Rows.Count > 0)
        {
            grdManu.DataSource = dt;
            grdManu.DataBind();
            lblMsg.Visible = true;
        }
        else
        {
            lblMsg.Visible = true;
            lblMsg.Text = "Record Not Found";
            grdManu.DataSource = null;
            grdManu.DataBind();
        }
    }

    protected void btnReport_Click(object sender, EventArgs e)
    {
        string strqry = "SELECT fmm.Name `Name`,fmm.Address Address1,fmm.Address2,fmm.Address3,fmm.PinCode `Postal Code`,fmm.City,fmm.Country,fmm.Contact_Person `Contact Person`,fmm.Mobile 'Telephone No.',fmm.Fax,fmm.Email,IF(fmm.IsActive='1','Active','InActive')Status,DATE_FORMAT(fmm.EntryDate,'%d-%b-%Y')`Entry Date`,(em.Name)`User Name` FROM f_manufacture_master fmm INNER JOIN employee_master em ON fmm.UserID=EmployeeID ";
        if (txtManuName.Text.Trim() != string.Empty)
        {
            strqry = strqry + " and fmm.Name like '" + txtManuName.Text.Trim() + "%'";
        }
        strqry = strqry + " order by fmm.Name ";

        DataTable dt = StockReports.GetDataTable(strqry);
        if (dt.Rows.Count > 0)
        {
            Session["dtExport2Excel"] = dt;
            Session["ReportName"] = " Manufacturer Master  Listing ";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/ExportToExcel.aspx');", true);
        }
        else
        {
            lblMsg.Visible = true;
            lblMsg.Text = "No records Found";
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (txtName1.Text.Trim() == "")
        {
            mdpSave.Show();
            txtName1.Text = "";
            txtName1.Focus();
            Label2.Text = "Enter Name";
            return;
        }
        if (txtName1.Text.Trim().Length <= 2)
        {
            mdpSave.Show();
            txtName1.Text = "";
            txtName1.Focus();
            Label2.Text = "Please Enter Atleast 3 Characters";
            return;
        }
        //if (txtTITNO1.Text == "")
        //{
        //    Label2.Visible = true; ;
        //    Label2.Text = "Enter TIN NO";
        //    mdpSave.Show();
        //    txtTITNO1.Focus();
        //    return;
        //}
        //if (txtDLNo.Text == "")
        //{
        //    Label2.Visible = true; ;
        //    Label2.Text = "Enter DL NO";
        //    mdpSave.Show();
        //    txtDLNo.Focus();
        //    return;
        //}
        ////if (txtContact.Text == "")
        ////{
        ////    Label2.Visible = true;
        ////    Label2.Text = "Enter Contact Person";
        ////    mdpSave.Show();
        ////    txtContact.Focus();
        ////    return;
        ////}
        //if (txtAdd.Text == "")
        //{
        //    Label2.Visible = true;
        //    Label2.Text = "Enter Address";
        //    mdpSave.Show();
        //    txtAdd.Focus();
        //    return;
        //}
        //if (txtCountry.Text == "")
        //{
        //    Label2.Visible = true;
        //    Label2.Text = "Enter Country";
        //    mdpSave.Show();
        //    txtCountry.Focus();
        //    return;
        //}
        //if (txtCity1.Text == "")
        //{
        //    Label2.Visible = true;
        //    Label2.Text = "Enter City";
        //    mdpSave.Show();
        //    txtCity1.Focus();
        //    return;
        //}
        //if (txtPinCode.Text == "")
        //{
        //    Label2.Visible = true;
        //    Label2.Text = "Enter PinCOde";
        //    mdpSave.Show();
        //    txtPinCode.Focus();
        //    return;
        //}
        //if (txtTel1.Text == "" && txtMob1.Text == "")
        //{
        //    Label2.Visible = true;
        //    Label2.Text = "Enter Mobile/Phone No";
        //    mdpSave.Show();
        //    txtMob1.Focus();
        //    return;
        //}

        try
        {
            string sql = "select count(*) from f_manufacture_master where Name ='" + txtName1.Text.Replace('-', ' ').Trim().Replace("'", "''") + "'";
            int count = Util.GetInt(StockReports.ExecuteScalar(sql));
            if (count > 0)
            {
                lblMsg.Text = "Company Already Exist..";
                return;
            }
            int IsAsset = 0;
            if (chkIsAsset.Checked)
                IsAsset = 1;
            string query = "insert into f_manufacture_master(NAME,Contact_Person,ADDRESS,Address2,Address3,PHONE,Mobile,FAX,EMAIL,Man_GSTINNo,Country,City,PinCode,DLNO,TINNO,IsActive,UserID,manufactureCode,IPAddress,IsAsset)values('" + txtName1.Text.Replace('-', ' ').Trim().Replace("'", "''") + "','" + txtContact.Text + "','" + txtAdd.Text + "','" + txtAdd2.Text + "','" + txtAdd3.Text + "','" + txtTel1.Text + "','" + txtMob1.Text + "','" + txtFax1.Text + "','" + txtEmail.Text + "','" + txtGSTINNo.Text + "','" + txtCountry.Text + "','" + txtCity1.Text + "','" + txtPinCode.Text + "','" + txtDLNo.Text + "','" + txtTITNO1.Text + "',1,'" + Session["ID"].ToString() + "','" + txtCode1.Text.Trim() + "','" + All_LoadData.IpAddress() + "'," + Util.GetInt(IsAsset) + ")";
            StockReports.ExecuteDML(query);
            lblMsg.Text = "Record Saved Successfully.";
            ClearData();
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            lblMsg.Text = ex.Message;
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        if (txtManuName.Text.Trim() == "")
        {
            lblMsg.Visible = true;
            lblMsg.Text = "Enter Company Name";
            txtManuName.Focus();
            grdManu.DataSource = null;
            grdManu.DataBind();
            return;
        }
        if (txtManuName.Text.Trim().Length <= 2)
        {
            lblMsg.Visible = true;
            lblMsg.Text = "Please Enter Atleast 3 Characters";
            grdManu.DataSource = null;
            grdManu.DataBind();
            return;
        }
        lblMsg.Text = "";
        Button btn = sender as Button;
        ViewState["btn"] = btn.Text;
        BindManufactureGrd();
    }

    protected void btnupdate_Click(object sender, EventArgs e)
    {
        if (txtName2.Text.Trim() == "")
        {
            mpeCreateGroup.Show();
            txtName2.Text = "";
            txtName2.Focus();
            Label3.Text = "Enter Name";
            return;
        }
        if (txtName2.Text.Trim().Length <= 2)
        {
            mpeCreateGroup.Show();
            txtName2.Text = "";
            txtName2.Focus();
            Label3.Text = "Please Enter Atleast 3 Characters";
            return;
        }
        //if (txtTITNO2.Text == "")
        //{
        //    Label3.Visible = true; ;
        //    Label3.Text = "Enter TIN NO";
        //    mpeCreateGroup.Show();
        //    txtTITNO2.Focus();
        //    return;
        //}
        //if (txtDLNo2.Text == "")
        //{
        //    Label3.Visible = true; ;
        //    Label3.Text = "Enter DL NO";
        //    mpeCreateGroup.Show();
        //    txtDLNo2.Focus();
        //    return;
        //}
        ////if (txtContact.Text == "")
        ////{
        ////    Label3.Visible = true;
        ////    Label3.Text = "Enter Contact Person";
        ////    mdpSave.Show();
        ////    txtContact.Focus();
        ////    return;
        ////}
        //if (txtAddress1.Text == "")
        //{
        //    Label3.Visible = true;
        //    Label3.Text = "Enter Address";
        //    mpeCreateGroup.Show();
        //    txtAddress1.Focus();
        //    return;
        //}
        //if (txtCountry2.Text == "")
        //{
        //    Label3.Visible = true;
        //    Label3.Text = "Enter Country";
        //    mpeCreateGroup.Show();
        //    txtCountry2.Focus();
        //    return;
        //}
        //if (txtCity2.Text == "")
        //{
        //    Label3.Visible = true;
        //    Label3.Text = "Enter City";
        //    mpeCreateGroup.Show();
        //    txtCity2.Focus();
        //    return;
        //}
        //if (txtPinCode2.Text == "")
        //{
        //    Label3.Visible = true;
        //    Label3.Text = "Enter PinCOde";
        //    mpeCreateGroup.Show();
        //    txtPinCode2.Focus();
        //    return;
        //}
        //if (txtPhone.Text == "" && txtMobile.Text == "")
        //{
        //    Label3.Visible = true;
        //    Label3.Text = "Enter Mobile/Phone No";
        //    mpeCreateGroup.Show();
        //    txtMob1.Focus();
        //    return;
        //}
        if (rbtnActive.SelectedIndex != 0 && rbtnActive.SelectedIndex != 1)
        {
            Label3.Visible = true;
            Label3.Text = "Please Check Active/InActive field";
            mpeCreateGroup.Show();

            return;
        }
        string ManufactureID = string.Empty;
        if (ViewState["ManufactureID"] != null)
        {
            ManufactureID = Util.GetString(ViewState["ManufactureID"]);
        }
        string str = string.Empty;

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {

            str = "UPDATE f_manufacture_master SET Name='" + txtName2.Text.Trim().Replace("'", "''") + "',TINNO='" + txtTITNO2.Text.Trim() + "',Contact_Person='" + txtContactPerson2.Text.Trim() + "',Address='" + txtAddress1.Text.Trim() + "',Address2='" + txtAddress2.Text.Trim() + "',Address3='" + txtAddress3.Text.Trim() + "',City='" + txtCity2.Text.Trim() + "',PinCode='" + txtPinCode2.Text + "',Country='" + txtCountry2.Text.Trim() + "',phone='" + txtPhone.Text + "',Mobile='" + txtMobile.Text + "',Email='" + txtEmail2.Text.Trim() + "',Man_GSTINNo='" + txtGSTINUpdate.Text.Trim() + "',FAX='" + txtfax2.Text.Trim() + "',DLNO='" + txtDLNo2.Text.Trim() + "',manufactureCode='" + txtCode2.Text.Trim() + "' ";

            if (rbtnActive.SelectedIndex == 0)
            {
                str = str + " ,IsActive=1";
            }
            else { str = str + " ,IsActive=0"; }

            if (chkIsAssetUpdate.Checked)
            {
                str = str + " ,IsAsset=1 ";
            }
            else { str = str + " ,IsAsset=0 "; }

            str = str + " WHERE ManufactureID='" + ManufactureID + "' ";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            grdManu.DataSource = null;
            grdManu.DataBind();
        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.Message;
            Tranx.Rollback();
            con.Close();
            con.Dispose();
            lblMsg.Text = ex.Message;
            return;
        }
        Tranx.Commit();
        Tranx.Dispose();
        con.Close();
        con.Dispose();
        btnSearch_Click(sender, e);
        lblMsg.Text = "Record Updated Successfully.";
        Label3.Text = "";
        ClearData();
    }

    protected void grdManu_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        if (ViewState["dt"] != null)
        {
            DataTable dt = (DataTable)ViewState["dt"];
            grdManu.PageIndex = e.NewPageIndex;
            grdManu.DataSource = dt;
            grdManu.DataBind();
        }
    }

    protected void grdManu_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "AEdit")
        {
            DataTable dt = new DataTable();
            if (ViewState["dt"] != null)
            {
                dt = (DataTable)ViewState["dt"];
            }

            string ManufactureID = Util.GetString(e.CommandArgument);
            ViewState["ManufactureID"] = ManufactureID;

            DataRow[] dr = dt.Select("ManufactureID='" + ManufactureID + "'");
            if (dr.Length > 0)
            {

                txtName2.Text = Util.GetString(dr[0]["CompanyName"]);
                txtTITNO2.Text = Util.GetString(dr[0]["TINNO"]);
                txtAddress1.Text = Util.GetString(dr[0]["Address1"]);
                txtAddress2.Text = Util.GetString(dr[0]["Address2"]);
                txtAddress3.Text = Util.GetString(dr[0]["Address3"]);
                txtCity2.Text = Util.GetString(dr[0]["City"]);
                txtCountry2.Text = Util.GetString(dr[0]["Country"]);
                txtDLNo2.Text = Util.GetString(dr[0]["DLNO"]);
                txtEmail2.Text = Util.GetString(dr[0]["EMAIL"]);
                txtGSTINUpdate.Text = Util.GetString(dr[0]["Man_GSTINNo"]);
                txtfax2.Text = Util.GetString(dr[0]["FAX"]);
                txtContactPerson2.Text = Util.GetString(dr[0]["ContactPerson"]);
                txtMobile.Text = Util.GetString(dr[0]["Mobile"]);
                txtPhone.Text = Util.GetString(dr[0]["PHONE"]);
                txtPinCode2.Text = Util.GetString(dr[0]["PinCode"]);
                rbtnActive.SelectedIndex = rbtnActive.Items.IndexOf(rbtnActive.Items.FindByText(dr[0]["IsActive"].ToString()));
                txtCode2.Text = Util.GetString(dr[0]["manufactureCode"]);
                if (dr[0]["IsAsset"].ToString() == "Yes")
                    chkIsAssetUpdate.Checked = true;
                else
                    chkIsAssetUpdate.Checked = false;
                mpeCreateGroup.Show();
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["Mode"] != null)
        {
            string mode = Request.QueryString["Mode"].ToString();
            if (mode == "1")
            {

                //Master.FindControl("mnuHIS").Visible = false;
                // Master.FindControl("ddlUserName").Visible = false;
                // Master.FindControl("lnkSignOut").Visible = false;
                var divNav = (HtmlControl)Master.FindControl("divMasterNav");
                divNav.Attributes.CssStyle.Add("display", "none");
            }
        }
        if (!IsPostBack)
            txtManuName.Focus();
    }

    private void ClearData()
    {
        Label2.Text = "";
        txtEmail.Text = string.Empty;
        txtGSTINUpdate.Text = "";
        txtGSTINNo.Text = "";
        txtTITNO1.Text = string.Empty;
        txtManuName.Text = "";
        txtTITNO1.Text = "";
        txtTel1.Text = "";
        txtMob1.Text = "";
        txtCity1.Text = "";
        txtAdd.Text = "";
        txtAdd2.Text = "";
        txtAdd3.Text = "";
        txtContact.Text = "";
        txtCountry.Text = "";
        txtPinCode.Text = "";
        txtName1.Text = string.Empty;
        txtName2.Text = string.Empty;
        txtTITNO2.Text = string.Empty;
        txtDLNo.Text = string.Empty;
        txtDLNo2.Text = string.Empty;
        txtCode1.Text = "";
        txtCode2.Text = "";
    }
}