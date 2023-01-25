using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Net.Mail;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Employee_EmployeeRegistration : System.Web.UI.Page
{
    private static int EmpHosp_ID, EmpUser_ID;

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!IsPostBack)
            {
                txName.Focus();

                EnableTrue();
             //   All_LoadData.bindUserType(cmbUserType, "Employee");
             //   All_LoadData.BindBloodgroup(cmgBloodGroup);
                All_LoadData.bindTitle(cmdTitle);
                AllLoadDate_Payroll.BindDepartmentPayroll(ddlDepartment);
                AllLoadDate_Payroll.BindDesignationPayroll(ddlDesignation);
                HospitalByBind();
                BindUserType();
                BindUserGroup();
                txName.Focus();
                txtStartTime.Text = Util.GetDateTime(System.DateTime.Now).ToString("dd-MMM-yyyy");
                txtDOB.Text = Util.GetDateTime(System.DateTime.Now).ToString("dd-MMM-yyyy");
                LoadBloodBankBloodGroup();
                BindEmployeeDetail();
                bindCentre();
                calStartdate.EndDate = DateTime.Now;
                calDob.EndDate = DateTime.Now;
            }
            lblErrmsg.Text = "";
            txtDOB.Attributes.Add("readOnly", "true");
            txtStartTime.Attributes.Add("readOnly", "true");
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
    }

    private void LoadBloodBankBloodGroup()
    {
        cmgBloodGroup.DataSource = StockReports.GetDataTable("SELECT ID, BloodGroup Name FROM bb_bloodgroup_master WHERE isactive=1 ORDER BY bloodgroup");
        cmgBloodGroup.DataValueField = "ID";
        cmgBloodGroup.DataTextField = "Name";
        cmgBloodGroup.DataBind();
    }
    private void BindUserType()
    {
        DataTable dt = StockReports.GetDataTable(" select Name,ID from Employee_Type_master where IsActive=1  order by Name");
        cmbUserType.DataSource = dt;
        cmbUserType.DataTextField = "Name";
        cmbUserType.DataValueField = "ID";
        cmbUserType.DataBind();
        cmbUserType.Items.Insert(0, new ListItem("Select"));
    }
    private void BindUserGroup()
    {
        DataTable dt = StockReports.GetDataTable("select Name,ID from Employee_Group_master where IsActive=1 order by Name");
        ddlUserGroup.DataSource = dt;
        ddlUserGroup.DataTextField = "Name";
        ddlUserGroup.DataValueField = "ID";
        ddlUserGroup.DataBind();
        ddlUserGroup.Items.Insert(0, new ListItem("Select","0"));
    }
    public static void bindCentreDefault(GridView grvCentre)
    {
        grvCentre.DataSource = StockReports.GetDataTable("SELECT CentreID,CentreName FROM center_master WHERE isActive=1 ORDER BY IF(isDefault='0','2',isDefault),CentreName");
        grvCentre.DataBind();
    }

    private void bindCentre()
    {
        DataTable dt = StockReports.GetDataTable("Select RoleId,CentreID,PASSWORD,UserName from f_login where EmployeeID='" + Util.GetString(Request.QueryString["EmployeeID"]) + "'");
        bindCentreDefault(grlLoginRoles);
        DataTable dt1 = new DataTable();// StockReports.GetDataTable("select id,upper(roleName) roleName  from f_rolemaster where active=1 order By RoleName ");
        foreach (GridViewRow gr in grlLoginRoles.Rows)
        {
            CheckBoxList chk_prev = ((CheckBoxList)gr.FindControl("chk_prev"));
            string centre = ((Label)gr.FindControl("lblCentreId")).Text;
            dt1 = StockReports.GetDataTable("SELECT r.id,UPPER(r.roleName) roleName FROM f_rolemaster r INNER JOIN f_centre_role c ON c.RoleID=r.ID AND c.CentreID=" + centre + " AND c.isActive=1 WHERE active=1 ORDER BY RoleName  ");
            chk_prev.DataSource = dt1;
            chk_prev.DataTextField = "roleName";
            chk_prev.DataValueField = "id";
            chk_prev.DataBind();
            foreach (ListItem li in chk_prev.Items)
            {
                if (dt.Select("RoleID='" + li.Value + "' and CentreID='" + centre + "'").Length > 0)
                {
                    li.Selected = true;
                }
            }
        }
        if (dt.Rows.Count == 0)
        {
            cbUpdatePassword.Checked = true;
            cbUpdatePassword.Enabled = false;
            lblOldPassword.Text = string.Empty;
            lblOldUserName.Text = string.Empty;
        }
        else
        {
            lblOldUserName.Text = Util.GetString(dt.Rows[0]["UserName"]);
            lblOldPassword.Text = Util.GetString(dt.Rows[0]["PASSWORD"]);
        }
    }

    protected void BindEmployeeDetail()
    {
        DataTable dt = StockReports.GetDataTable("SELECT EmployeeID EmployeeID,Title,Name,House_No,Street_Name,City,Locality,PinCode,Email,Phone,Mobile,PHouse_No,PStreet_Name,PCity,PLocality,PPinCode,FatherName,MotherName,qualification,DOB,ESI_No,EPF_No,PAN_No,PassportNO,BloodGroup,UserType_ID,Gender,Dept_ID,Desi_ID,Employee_Group_ID,Eligible_DiscountPercent FROM employee_master where EmployeeID='" + Request.QueryString["EmployeeID"] + "'");
        if (dt.Rows.Count > 0)
        {
            cmdTitle.SelectedIndex = cmdTitle.Items.IndexOf(cmdTitle.Items.FindByText(dt.Rows[0]["Title"].ToString()));
            txName.Text = dt.Rows[0]["Name"].ToString();
            txtHouseNo.Text = dt.Rows[0]["House_No"].ToString();
            txtStreet.Text = dt.Rows[0]["Street_Name"].ToString();
            txtCity.Text = dt.Rows[0]["City"].ToString();
            txtLocality.Text = dt.Rows[0]["Locality"].ToString();
            txtPinCode.Text = dt.Rows[0]["PinCode"].ToString();

            txtEmail.Text = dt.Rows[0]["Email"].ToString();
            txtPhone.Text = dt.Rows[0]["Phone"].ToString();
            txtMobile.Text = dt.Rows[0]["Mobile"].ToString();

            txtOhouseNo.Text = dt.Rows[0]["PHouse_No"].ToString();
            txtOStreet.Text = dt.Rows[0]["PStreet_Name"].ToString();
            txtOCity.Text = dt.Rows[0]["PCity"].ToString();
            txtOlocality.Text = dt.Rows[0]["PLocality"].ToString();
            txtOPinCode.Text = dt.Rows[0]["PPinCode"].ToString();

            txtFather.Text = dt.Rows[0]["FatherName"].ToString();
            txtMother.Text = dt.Rows[0]["MotherName"].ToString();
            txtqualification.Text = dt.Rows[0]["qualification"].ToString();
            if (Util.GetDateTime(dt.Rows[0]["DOB"]).ToString("yyyy-MM-dd") == "0001-01-01")
                txtDOB.Text = "";
            else
                txtDOB.Text = Util.GetDateTime(dt.Rows[0]["DOB"]).ToString("dd-MMM-yyyy");
            txtESI.Text = dt.Rows[0]["ESI_No"].ToString();
            txtEPF.Text = dt.Rows[0]["EPF_No"].ToString();
            txtPAN.Text = dt.Rows[0]["PAN_No"].ToString();
            txtPassport.Text = dt.Rows[0]["PassportNO"].ToString();

            cmgBloodGroup.SelectedIndex = cmgBloodGroup.Items.IndexOf(cmgBloodGroup.Items.FindByText(dt.Rows[0]["BloodGroup"].ToString()));

            rbtnGender.SelectedIndex = rbtnGender.Items.IndexOf(rbtnGender.Items.FindByText(dt.Rows[0]["Gender"].ToString()));
            ddlDepartment.SelectedIndex = ddlDepartment.Items.IndexOf(ddlDepartment.Items.FindByValue(dt.Rows[0]["Dept_ID"].ToString()));
            cmbUserType.SelectedIndex = cmbUserType.Items.IndexOf(cmbUserType.Items.FindByValue(dt.Rows[0]["UserType_ID"].ToString()));
            ddlDesignation.SelectedIndex = ddlDesignation.Items.IndexOf(ddlDesignation.Items.FindByValue(dt.Rows[0]["Desi_ID"].ToString()));
            ddlUserGroup.SelectedIndex = ddlUserGroup.Items.IndexOf(ddlUserGroup.Items.FindByValue(dt.Rows[0]["Employee_Group_ID"].ToString()));
            txtuid.Text = StockReports.ExecuteScalar("select UserName from f_login where EmployeeID='" + Request.QueryString["EmployeeID"] + "'");
            txtDiscountPercent.Text = dt.Rows[0]["Eligible_DiscountPercent"].ToString();
        }
    }

    private void CheckAddNewPatient()
    {
        if (Request.QueryString["EID"].ToString() == "00000")
        {
            btnSave.Text = "Save";
        }
        else
        {
            ShowEmployeeInfo();
            btnSave.Text = "Update";
            btnClear.Visible = false;
        }
    }

    private void ShowEmployeeInfo()
    {
        MySqlConnection con = new MySqlConnection();
        try
        {
            con = Util.GetMySqlCon();
            con.Open();
            MySqlDataReader dr;
            string str = "select eh.EmployeeHospital_ID,eu.Employee_UserType_ID, em.Title, em.name EName,em.House_No,em.Street_Name,em.Locality,em.City,em.PinCode,em.PHouse_No,em.PStreet_Name,em.PLocality,em.PCity,em.PPinCode,em.Email Email,em.Phone Phone,em.StartDate StartDate,hm.Name HName,em.FatherName,em.MotherName,em.ESI_No,em.EPF_No,em.PAN_No,em.PassportNo,em.DOB,em.Qualification,em.BloodGroup,um.Name UName from employee_master em,hospital_master hm,employee_usertype eu,user_type_master um,employee_hospital eh where hm.Hospital_ID = eh.Hospital_ID and eh.EmployeeID=em.EmployeeID and  um.User_Type_ID=eu.UserType_ID and eu.EmployeeID=em.EmployeeID and em.EmployeeID='" + Request.QueryString["EID"].ToString() + "' ";
            dr = MySqlHelper.ExecuteReader(con, CommandType.Text, str);
            while (dr.Read())
            {
                cmbHospital.SelectedIndex = cmbHospital.Items.IndexOf(cmbHospital.Items.FindByText(dr["HName"].ToString()));
                cmbUserType.SelectedIndex = cmbUserType.Items.IndexOf(cmbUserType.Items.FindByText(dr["UName"].ToString()));
                cmdTitle.SelectedIndex = cmdTitle.Items.IndexOf(cmdTitle.Items.FindByValue(dr["Title"].ToString()));
                txName.Text = dr["EName"].ToString();
                txtHouseNo.Text = dr["House_No"].ToString();
                txtStreet.Text = dr["Street_Name"].ToString();
                txtLocality.Text = dr["Locality"].ToString();
                txtCity.Text = dr["City"].ToString();
                txtPinCode.Text = dr["PinCode"].ToString();
                txtOhouseNo.Text = dr["PHouse_No"].ToString();
                txtOStreet.Text = dr["PStreet_Name"].ToString();
                txtOlocality.Text = dr["PLocality"].ToString();
                txtOCity.Text = dr["PCity"].ToString();
                txtOPinCode.Text = dr["PPinCode"].ToString();
                txtFather.Text = dr["FatherName"].ToString();
                txtMother.Text = dr["MotherName"].ToString();
                txtESI.Text = dr["ESI_No"].ToString();
                txtEPF.Text = dr["EPF_No"].ToString();
                txtPAN.Text = dr["PAN_No"].ToString();
                txtPassport.Text = dr["PassportNo"].ToString();
                if (Util.GetDateTime(dr["DOB"].ToString()).ToString("dd-MMM-yyyy") == "01-Jan-0001")
                    txtDOB.Text = "";
                else
                    txtDOB.Text = Util.GetDateTime(dr["DOB"].ToString()).ToString("dd-MMM-yyyy");

                txtqualification.Text = dr["Qualification"].ToString();
                cmgBloodGroup.SelectedIndex = cmgBloodGroup.Items.IndexOf(cmgBloodGroup.Items.FindByText(dr["BloodGroup"].ToString()));

                string strr = Util.GetString(dr["Phone"].ToString());
                if (strr.IndexOf("-") != -1)
                {
                    string[] s = strr.Split('-');

                    txtSTD.Text = s[0].ToString();
                    txtPhone.Text = s[1].ToString();
                }
                else
                {
                    txtPhone.Text = dr["Phone"].ToString();
                }
                txtEmail.Text = dr["Email"].ToString();

                if (Util.GetDateTime(dr["StartDate"].ToString()).ToString("dd-MMM-yyyy") == "01-Jan-0001")
                {
                    txtStartTime.Text = "";
                }
                else
                {
                    txtStartTime.Text = Util.GetDateTime(dr["StartDate"].ToString()).ToString("dd-MMM-yyyy");
                }

                EmpHosp_ID = int.Parse(dr["EmployeeHospital_ID"].ToString());
                EmpUser_ID = int.Parse(dr["Employee_UserType_ID"].ToString());

                // we can't change the hospital of employee
                cmbHospital.Enabled = false;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    private void checkRights()
    {
        MySqlConnection con = new MySqlConnection();

        try
        {
            con = Util.GetMySqlCon();
            con.Open();

            string CountStr = "";
            if (Session["LoginType"].ToString() == "Employee")
                CountStr = " SELECT count(*) from employee_usertype EU, usertype_right UR, right_master RM where  EU.UserType_ID = UR.User_Type_ID and UR.Right_Master_ID = RM.Right_Master_ID and  EU.EmployeeID='" + Session["ID"].ToString() + "' and RM.FormName = 'EmployeeRegistration'";
            else if (Session["LoginType"].ToString() == "Doctor")
                CountStr = "SELECT count(*) from doctor_usertype DU, usertype_right UR, right_master RM where UR.Right_Master_ID = RM.Right_Master_ID and   UR.User_Type_ID = DU.UserType_ID  and  DU.DoctorID='" + Session["ID"].ToString() + "' and RM.FormName = 'EmployeeRegistration'";

            int CountNo = Int32.Parse(MySqlHelper.ExecuteScalar(con, CommandType.Text, CountStr).ToString());

            if (CountNo == 0)
                Response.Redirect("../../NotAuthorized.aspx");
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (txtpwd.Text.ToString() != txtcpwd.Text.ToString())
        {
            txtpwd.Focus();
            lblErrmsg.Text = "Password does not Match..";
            return;
        }

        if (txName.Text.Trim() == "")
        {
            txName.Focus();
            lblErrmsg.Text = "Please Enter Name";
            return;
        }

        if (Request.QueryString.Count > 0)
        {
            int a = 0;

            if (a > 0)
            {
                if (txtuid.Text.Length > 0 && txtcpwd.Text.Length <= 0)
                {
                    lblErrmsg.Text = "Password Required";
                    return;
                }
            }
        int countusername = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(userName) FROM f_login fl WHERE fl.UserName='" + txtuid.Text.Trim() + "' AND fl.EmployeeID<>'"+ Request.QueryString["EmployeeID"] +"' "));
        if (countusername > 0)
        {
            txtuid.Focus();
            lblErrmsg.Text = "User name already exist..";
            return;
        }

            Update();
        }
        else
        {
        int countusername = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(userName) FROM f_login fl WHERE fl.UserName='" + txtuid.Text.Trim() + "' "));
        if (countusername > 0)
        {
            txtuid.Focus();
            lblErrmsg.Text = "User name already exist..";
            return;
        }

            SaveData();
        }
    }

    private bool IsConnectionAvailable()
    {
        //Call url
        System.Uri url = new System.Uri("http://www.google.com/");
        //Request for request
        System.Net.WebRequest req;
        req = System.Net.WebRequest.Create(url);
        System.Net.WebResponse resp;
        try
        {
            resp = req.GetResponse();
            resp.Close();
            req = null;
            return true;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            req = null;
            return false;
        }
    }
    protected void btnClear_Click1(object sender, EventArgs e)
    {
        if (btnClear.Text == "Clear")
        {
            Clear();
        }
        else if (btnClear.Text == "AddNew")
        {
            EnableTrue();
            Clear();
            btnSave.Enabled = true;
            btnClear.Text = "Clear";
            txName.Focus();
        }
    }

    public void DateFormat()
    {
        try
        {
            DateTime dateFormat;
            dateFormat = DateTime.Parse(txtStartTime.Text);
            txtStartTime.Text = dateFormat.ToString("dd-MMM-yyyy");
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
    }

    public void Clear()
    {
        txtSTD.Text = "";
        lblID.Text = "";
        txName.Text = "";
        txtHouseNo.Text = "";
        txtStreet.Text = "";
        txtLocality.Text = "";
        txtCity.Text = "";
        txtPinCode.Text = "";
        txtOhouseNo.Text = "";
        txtOStreet.Text = "";
        txtOlocality.Text = "";
        txtOCity.Text = "";
        txtOPinCode.Text = "";
        txtFather.Text = "";
        txtMother.Text = "";
        txtESI.Text = "";
        txtEPF.Text = "";
        txtPAN.Text = "";
        txtPassport.Text = "";
        txtDOB.Text = "";
        txtqualification.Text = "";

        txtEmail.Text = "";
        txtPhone.Text = "";
        txtMobile.Text = "";
        txtStartTime.Text = Util.GetDateTime(System.DateTime.Now).ToString("dd/MMM/yyyy");
        lblErrmsg.Text = "";
    }

    public void EnableTrue()
    {
        txName.Enabled = true;

        txtHouseNo.Enabled = true;
        txtStreet.Enabled = true;
        txtLocality.Enabled = true;
        txtCity.Enabled = true;
        txtPinCode.Enabled = true;
        txtOhouseNo.Enabled = true;
        txtOStreet.Enabled = true;
        txtOlocality.Enabled = true;
        txtOCity.Enabled = true;
        txtOPinCode.Enabled = true;
        txtDOB.Enabled = true;
        txtqualification.Enabled = true;

        txtFather.Enabled = true;
        txtMother.Enabled = true;
        txtESI.Enabled = true;
        txtEPF.Enabled = true;
        txtPAN.Enabled = true;
        txtPassport.Enabled = true;

        txtEmail.Enabled = true;
        txtPhone.Enabled = true;
        txtMobile.Enabled = true;
    }

    private void EnableFalse()
    {
        txName.Enabled = false;

        txtHouseNo.Enabled = false;
        txtStreet.Enabled = false;
        txtLocality.Enabled = false;
        txtCity.Enabled = false;
        txtPinCode.Enabled = false;
        txtOhouseNo.Enabled = false;
        txtOStreet.Enabled = false;
        txtOlocality.Enabled = false;
        txtOCity.Enabled = false;
        txtOPinCode.Enabled = false;
        txtDOB.Enabled = false;
        txtqualification.Enabled = false;
        txtFather.Enabled = false;
        txtMother.Enabled = false;
        txtESI.Enabled = false;
        txtEPF.Enabled = false;
        txtPAN.Enabled = false;
        txtPassport.Enabled = false;
        txtEmail.Enabled = false;
        txtPhone.Enabled = false;
        txtMobile.Enabled = false;
    }

    private void SaveData()
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        MySqlTransaction MySqltrans = con.BeginTransaction();
        string EmployeeID = "";
        ///  Table Employee Master-----------
        try
        {
            MSTEmployee objMSTEmployee = new MSTEmployee(MySqltrans);
            objMSTEmployee.Title = cmdTitle.SelectedItem.Text.Trim();
            objMSTEmployee.Name = txName.Text.Trim();
            objMSTEmployee.House_No = txtHouseNo.Text.Trim();
            objMSTEmployee.Street_Name = txtStreet.Text.Trim();
            objMSTEmployee.Locality = txtLocality.Text.Trim();
            objMSTEmployee.City = txtCity.Text.Trim();
            objMSTEmployee.PinCode = Util.GetInt(txtPinCode.Text.Trim());
            objMSTEmployee.PHouse_No = txtOhouseNo.Text.Trim();
            objMSTEmployee.PStreet_Name = txtOStreet.Text.Trim();
            objMSTEmployee.PLocality = txtOlocality.Text.Trim();
            objMSTEmployee.PCity = txtOCity.Text.Trim();
            objMSTEmployee.PPinCode = Util.GetInt(txtOPinCode.Text.Trim());
            objMSTEmployee.FatherName = txtFather.Text.Trim();
            objMSTEmployee.MotherName = txtMother.Text.Trim();
            objMSTEmployee.ESI_No = txtESI.Text.Trim();
            objMSTEmployee.EPF_No = txtEPF.Text.Trim();
            objMSTEmployee.PAN_No = txtPAN.Text.Trim();
            objMSTEmployee.Passport_No = txtPassport.Text.Trim();
            objMSTEmployee.DOB = Util.GetDateTime(txtDOB.Text.Trim());
            objMSTEmployee.Qualification = txtqualification.Text.Trim();
            objMSTEmployee.Email = txtEmail.Text.Trim();
            objMSTEmployee.Dept_ID = ddlDepartment.SelectedItem.Value.ToString();
            objMSTEmployee.Dept_Name = ddlDepartment.SelectedItem.Text.ToString();
            objMSTEmployee.Desi_Name = ddlDesignation.SelectedItem.Text.ToString();
            objMSTEmployee.Desi_ID = ddlDesignation.SelectedItem.Value.ToString();
            objMSTEmployee.Gender = txtGender.Text.Trim();
            objMSTEmployee.UserType_ID = cmbUserType.SelectedItem.Value.ToString();
            objMSTEmployee.Employee_Group_ID = Util.GetInt(ddlUserGroup.SelectedItem.Value);
            if (txtSTD.Text != "" || txtPhone.Text != "")
            {
                objMSTEmployee.Phone = Util.GetString(txtSTD.Text.Trim()) + "-" + Util.GetString(txtPhone.Text.Trim());
            }

            objMSTEmployee.Mobile = txtMobile.Text.Trim();
            objMSTEmployee.Blood_Group = cmgBloodGroup.SelectedItem.Text.Trim();

            if (txtStartTime.Text != "")
                objMSTEmployee.StartDate = Util.GetDateTime(txtStartTime.Text.Trim());
            else
                objMSTEmployee.StartDate = Util.GetDateTime(txtStartTime.Text.Trim());

            objMSTEmployee.DiscountPercent = Util.GetDecimal(txtDiscountPercent.Text);
            EmployeeID = objMSTEmployee.Insert();
            btnClear.Visible = true;

            //---Table Employee Hospital--------------
            foreach (GridViewRow gr in grlLoginRoles.Rows)
            {
                CheckBoxList chk_prev = ((CheckBoxList)gr.FindControl("chk_prev"));
                string centre = ((Label)gr.FindControl("lblCentreId")).Text;
                foreach (ListItem li in chk_prev.Items)
                {
                    if (li.Selected)
                    {
                        EmployeeHospital EmHsp = new EmployeeHospital(MySqltrans);
                        EmHsp.EmployeeID = EmployeeID;
                        EmHsp.CentreID = Util.GetInt(centre);
                        EmHsp.Hospital_ID = Util.GetString(HttpContext.Current.Session["HOSPID"].ToString());
                        if (cmbUserType.SelectedIndex > 0)
                            EmHsp.Designation = cmbUserType.SelectedItem.Text;
                        else
                            EmHsp.Designation = "";
                        EmHsp.Insert();
                        btnClear.Visible = true;
                    }
                }
            }
            //-------------Table Employee UserType------
            MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, "DELETE FROM f_login WHERE EmployeeID='" + EmployeeID + "'");
            string str1 = "";
            foreach (GridViewRow gr in grlLoginRoles.Rows)
            {
                CheckBoxList chk_prev = ((CheckBoxList)gr.FindControl("chk_prev"));
                string centre = ((Label)gr.FindControl("lblCentreId")).Text;
                string Password = lblOldPassword.Text;
                string userName = lblOldUserName.Text;
                if (cbUpdatePassword.Checked)
                {
                    userName = txtuid.Text.Trim();
                    Password = EncryptPassword(txtpwd.Text.Trim());
                }
                foreach (ListItem li in chk_prev.Items)
                {
                    if (li.Selected == true)
                    {
                        str1 = "INSERT INTO f_login(RoleID,EmployeeID,UserName,Password,CentreID,LastUpdatedBy,IPAddress)" +
                         "values(" + li.Value + ",'" + EmployeeID + "','" + userName + "','" + Password + "','" + centre + "','"+ Session["ID"].ToString() +"','"+ All_LoadData.IpAddress() +"')";
                        MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, str1);
                    }
                }
            }
            MySqltrans.Commit();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Record Saved Successfully...');", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "location.href='EmployeeRegistration.aspx';", true);

            //if (EmployeeID != "")
            //{
            //    ScriptManager.RegisterStartupScript(this, this.GetType(), "CurencyMaster", "window.open('../EDP/PaymentModeCurrencyMapping.aspx?EmployeeID=" + EmployeeID + "', 'popUpWindow', 'height=400,width=800,left=10,top=10,,scrollbars=yes,menubar=no')", true);
            //}
        }
        catch (Exception ex)
        {
            MySqltrans.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblErrmsg.Text = "Record Not Saved....";
            return;
        }
        finally
        {
            MySqltrans.Dispose();
            con.Close();
            con.Dispose();
        }
        EnableFalse();
        btnSave.Enabled = false;
    }
    

    private void Update()
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction MySqltrans = con.BeginTransaction();
        try
        {
            MSTEmployee objMSTEmployee = new MSTEmployee(MySqltrans);
            objMSTEmployee.Title = cmdTitle.SelectedItem.Text.Trim();
            objMSTEmployee.Name = txName.Text.Trim();
            objMSTEmployee.House_No = txtHouseNo.Text.Trim();
            objMSTEmployee.Street_Name = txtStreet.Text.Trim();
            objMSTEmployee.Locality = txtLocality.Text.Trim();
            objMSTEmployee.City = txtCity.Text.Trim();
            objMSTEmployee.PinCode = Util.GetInt(txtPinCode.Text.Trim());
            objMSTEmployee.PHouse_No = txtOhouseNo.Text.Trim();
            objMSTEmployee.PStreet_Name = txtOStreet.Text.Trim();
            objMSTEmployee.PLocality = txtOlocality.Text.Trim();
            objMSTEmployee.PCity = txtOCity.Text.Trim();
            objMSTEmployee.PPinCode = Util.GetInt(txtOPinCode.Text.Trim());
            objMSTEmployee.FatherName = txtFather.Text.Trim();
            objMSTEmployee.MotherName = txtMother.Text.Trim();
            objMSTEmployee.ESI_No = txtESI.Text.Trim();
            objMSTEmployee.EPF_No = txtEPF.Text.Trim();
            objMSTEmployee.PAN_No = txtPAN.Text.Trim();
            objMSTEmployee.Passport_No = txtPassport.Text.Trim();
            objMSTEmployee.DOB = Util.GetDateTime(txtDOB.Text.Trim());
            objMSTEmployee.Qualification = txtqualification.Text.Trim();
            objMSTEmployee.Email = txtEmail.Text.Trim();
            objMSTEmployee.Dept_ID = ddlDepartment.SelectedItem.Value.ToString();
            objMSTEmployee.Dept_Name = ddlDepartment.SelectedItem.Text.ToString();
            objMSTEmployee.Desi_Name = ddlDesignation.SelectedItem.Text.ToString();
            objMSTEmployee.Desi_ID = ddlDesignation.SelectedItem.Value.ToString();
            objMSTEmployee.Gender = txtGender.Text.Trim();
            objMSTEmployee.UserType_ID = cmbUserType.SelectedItem.Value.ToString();
            objMSTEmployee.Employee_Group_ID = Util.GetInt(ddlUserGroup.SelectedItem.Value);

            if (txtSTD.Text != "" || txtPhone.Text != "")
            {
                objMSTEmployee.Phone = Util.GetString(txtSTD.Text.Trim()) + "-" + Util.GetString(txtPhone.Text.Trim());
            }

            objMSTEmployee.Mobile = txtMobile.Text.Trim();
            objMSTEmployee.Blood_Group = cmgBloodGroup.SelectedItem.Text.Trim();

            if (txtStartTime.Text != "")
                objMSTEmployee.StartDate = Util.GetDateTime(txtStartTime.Text.Trim());
            else
                objMSTEmployee.StartDate = Util.GetDateTime(txtStartTime.Text.Trim());
            objMSTEmployee.EmployeeID = Request.QueryString["EmployeeID"];
            //if (cmbUserType.SelectedIndex > 0)
            //    objMSTEmployee.Designation = cmbUserType.SelectedItem.Text;
            //else
            //    objMSTEmployee.Designation = "";
            // objMSTEmployee.Update(Request.QueryString["EmployeeID"]);
            objMSTEmployee.DiscountPercent = Util.GetDecimal(txtDiscountPercent.Text);
            objMSTEmployee.Update();
            btnClear.Visible = true;

            btnClear.Visible = true;
            foreach (GridViewRow gr in grlLoginRoles.Rows)
            {
                CheckBoxList chk_prev = ((CheckBoxList)gr.FindControl("chk_prev"));
                string centre = ((Label)gr.FindControl("lblCentreId")).Text;
                foreach (ListItem li in chk_prev.Items)
                {
                    if (li.Selected)
                    {
                        EmployeeHospital EmHsp = new EmployeeHospital(MySqltrans);
                        EmHsp.EmployeeID = Request.QueryString["EmployeeID"];
                        EmHsp.CentreID = Util.GetInt(centre);
                        EmHsp.Hospital_ID = Util.GetString(Session["HOSPID"].ToString());
                        if (cmbUserType.SelectedIndex > 0)
                            EmHsp.Designation = cmbUserType.SelectedItem.Text;
                        else
                            EmHsp.Designation = "";
                        EmHsp.Insert();
                        btnClear.Visible = true;
                        break;
                    }
                }
            }
            //-------------Table Employee UserType------
            MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, "delete from f_login WHERE EmployeeID='" + Request.QueryString["EmployeeID"] + "'");

            string str1 = "";
            foreach (GridViewRow gr in grlLoginRoles.Rows)
            {
                CheckBoxList chk_prev = ((CheckBoxList)gr.FindControl("chk_prev"));
                string centre = ((Label)gr.FindControl("lblCentreId")).Text;
                string userName = lblOldUserName.Text;
                string Password = lblOldPassword.Text;
                if (cbUpdatePassword.Checked)
                {
                    userName = txtuid.Text.Trim();
                    Password = EncryptPassword(txtpwd.Text.Trim());
                }
                foreach (ListItem li in chk_prev.Items)
                {
                    if (li.Selected == true)
                    {
                        str1 = "insert into f_login(RoleID,EmployeeID,UserName,Password,CentreID,LastUpdatedBy,IPAddress)" +
                         "values(" + li.Value + ",'" + Request.QueryString["EmployeeID"] + "','" + userName + "','" + Password + "','" + centre + "','"+ Session["ID"].ToString() +"','"+ All_LoadData.IpAddress() +"')";
                        MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, str1);
                    }
                }
            }
            if (Resources.Resource.EmailApplicable == "1")
            {
                sendEmail(txtEmail.Text.Trim(), txtuid.Text.Trim(), txtpwd.Text.Trim());
            }
            MySqltrans.Commit();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Record Saved Successfully...');", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "location.href='EmployeeRegistration.aspx';", true);
        }
        catch (Exception ex)
        {
            MySqltrans.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblErrmsg.Text = "Record Not Saved....";
            return;
        }
        finally
        {
            MySqltrans.Dispose();
            con.Close();
            con.Dispose();
        }
        EnableFalse();
        btnSave.Enabled = false;
    }

    public static string EncryptPassword(string text)
    {
        MD5 md5 = new MD5CryptoServiceProvider();
        md5.ComputeHash(ASCIIEncoding.ASCII.GetBytes(text));
        byte[] result = md5.Hash;
        StringBuilder strBuilder = new StringBuilder();
        for (int i = 0; i < result.Length; i++)
        {
            strBuilder.Append(result[i].ToString("x2"));
        }
        return strBuilder.ToString();
    }
    public void HospitalByBind()
    {
        try
        {
            string sql = "SELECT Name,Hospital_ID from hospital_master";
            cmbHospital.DataSource = StockReports.GetDataTable(sql);
            cmbHospital.DataTextField = "Name";
            cmbHospital.DataValueField = "Hospital_ID";
            cmbHospital.DataBind();
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
    }
    private void sendEmail(string emailto, string username, string password)
    {
        try
        {
            var columninfo = Email_Master.getemailColumnInfo("UserName#Password#EmailTo");
            if (columninfo.Count > 0)
            {
                columninfo[0].UserName = username;
                columninfo[0].Password = password;
                columninfo[0].EmailTo = emailto;
               // string email = Email_Master.SaveEmailTemplate(6, Util.GetInt(Session["RoleID"].ToString()), "1", columninfo, null);
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
}