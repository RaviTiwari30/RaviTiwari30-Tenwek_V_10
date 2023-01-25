using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.IO;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Serialization;
using System.Security.Cryptography;
using System.Web.Services;


public partial class Design_Payroll_Employee_Registration : System.Web.UI.Page
{
    public static string EmpID;

    public void Clear()
    {
        //txtSTD.Text = "";

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
        txtHusbandName.Text = "";
        txtESI.Text = "";

        txtPAN.Text = "";
        txtPassport.Text = "";

        txtDOJ.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        txtEmail.Text = "";
        txtPhone.Text = "";
        txtMobile.Text = "";
        txtEDLI_No.Text = "";
        txtLIC.Text = "";
        txtGRID_No.Text = "";
        lblmsg.Text = "";
        txtRegNo.Text = "";
        txtDisNo.Text = "";
        txtKinName.Text = "";
        txtKinAddress.Text = "";
        txtKinPhoneNo.Text = "";
        txtcpwd.Text = txtpwd.Text="";
        chkLogin.Checked = false;
        ddlExistEmp.SelectedIndex = 0;
        chkIsInvolveinInterViewProcess.Checked = false;
    }

    protected void BindBranch()
    {
        string str = "SELECT Branch_ID,BranchName FROM pay_BranchMaster WHERE Bank_id='" + ddlBankName.SelectedItem.Value + "' And IsActive=1 order by BranchName asc";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);
        ddlBranch.DataSource = dt;
        ddlBranch.DataTextField = "BranchName";
        ddlBranch.DataValueField = "Branch_ID";
        ddlBranch.DataBind();
    }
    private void bindCentre()
    {
        DataTable dt = StockReports.GetDataTable("Select RoleId,CentreID from f_login where EmployeeID='" + Util.GetString(Request.QueryString["EmployeeID"]) + "'");
        bindCentreDefault(grlLoginRoles);
        DataTable dt1 = StockReports.GetDataTable("select id,upper(roleName) roleName  from f_rolemaster where active=1 order By RoleName ");
        foreach (GridViewRow gr in grlLoginRoles.Rows)
        {
            CheckBoxList chk_prev = ((CheckBoxList)gr.FindControl("chk_prev"));
            string centre = ((Label)gr.FindControl("lblCentreId")).Text;
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
    }
    public static void bindCentreDefault(GridView grvCentre)
    {
        grvCentre.DataSource = StockReports.GetDataTable("SELECT CentreID,CentreName FROM center_master WHERE isActive=1 ORDER BY IF(isDefault='0','2',isDefault),CentreName");
        grvCentre.DataBind();
    }

    protected void btnEdit_Click(object sender, EventArgs e)
    {
        try
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction();
            string DOL = txtDOL.Text;
            int IsActive = 1;
            if (DOL == "")
            {
                DOL = "0001:01:01";
            }
            else if (DOL.Length > 0)
            {
                IsActive = 0;
            }
            string dept = string.Empty;
            string desi = string.Empty;

            dept = ddlDepartment.SelectedItem.Value;

            desi = ddlDesignation.SelectedItem.Value.Split('#')[0];
            int IsInvolveinInterViewProcess = chkIsInvolveinInterViewProcess.Checked ? 1 : 0;

            //string Query = "UPDATE employee_master SET Name='" + txName.Text + "',IsActive='" + IsActive.ToString() + "' where PayrollEmployeeID='" + lblEmpID.Text + "'";
          //  StockReports.ExecuteDML(Query);
            StringBuilder sb = new StringBuilder();
            sb.Append("update Employee_Master set Title='" + cmdTitle.SelectedItem.Text + "', Name='" + txName.Text + "',");
            sb.Append(" House_No = '" + txtHouseNo.Text + "' ,	Street_Name = '" + txtStreet.Text + "' , Locality = '" + txtLocality.Text + "' ,City = '" + txtCity.Text + "' , Pincode = '" + txtPinCode.Text + "' ,PHouse_No = '" + txtOhouseNo.Text + "' ,PStreet_Name = '" + txtOStreet.Text + "' ,PLocality = '" + txtOlocality.Text + "' ,PCity = '" + txtOCity.Text + "' ,PPincode = '" + txtOPinCode.Text + "' , ");
            sb.Append(" DOB = '" + Util.GetDateTime(txtDOB.Text).ToString("yyyy-MM-dd") + "' ,BloodGroup = '" + ddlBloodGroup.SelectedItem.Text + "' ,FatherName = '" + txtFather.Text + "' ,MotherName = '" + txtMother.Text + "',HusbandName='" + txtHusbandName.Text.Trim() + "' ,ESI_No = '" + txtESI.Text + "' ,EPF_No = '" + txtPFNo.Text + "' ,PAN_No = '" + txtPAN.Text + "' ,PassportNo = '" + txtPassport.Text + "' ,Email = '" + txtEmail.Text + "' ,Phone = '" + txtPhone.Text + "' ,Mobile = '" + txtMobile.Text + "' , ");
            sb.Append(" DOJ = '" + Util.GetDateTime(txtDOJ.Text).ToString("yyyy-MM-dd") + "' ,Gender = '" + txtGender.Text.Trim() + "' ,Dept_ID = " + dept + " ,Dept_Name = '" + ddlDepartment.SelectedItem.Text.Trim().Replace("'", "''") + "' ,Desi_ID = " + desi + " ,Desi_Name = '" + ddlDesignation.SelectedItem.Text + "' ,PF_No = '" + txtPFNo.Text.Trim() + "',PF_NOMINEE1 = '" + txtPF_Nominee1.Text.Trim() + " ' ");
            sb.Append(" ,BankAccountNo = '" + txtBankAccNo.Text.Trim() + "',IsActive=" + IsActive + ",RegNo='" + txtRegNo.Text + "',LetterNo=" + Util.GetInt(txtLetterNO.Text) + ",IsAccomodation='" + ddlAccomodation.SelectedItem.Value + "',Branch='" + ddlHospital.SelectedItem.Text + "' ");
            sb.Append("  , BankID='" + ddlBankName.SelectedItem.Value + "',BranchID='" + txtBranch.Text.Trim() + "',KinName='" + txtKinName.Text.Trim() + "',KinAddress='" + txtKinAddress.Text.Trim() + "',kinPhoneNo='" + txtKinPhoneNo.Text.Trim() + "',No_Name='" + txtNomineeName.Text.Trim() + "',No_Relation='" + ddlNomineeRelation.SelectedItem.Text+ "',No_Address='" + txtNomineeAdres.Text.Trim() + "',No_ContactNo='" + txtNomineeContactNo.Text.Trim() + "',No_AddharCard='" + txtNomineeAdharCard.Text.Trim() + "',Emp_Category='" + ddlCategory.SelectedItem.Value + "',Emr_Relation='" + ddlEmrRelation.SelectedItem.Text + "' ");
            sb.Append(" ,Emr_Name='" + txtEmrRelName.Text.Trim() + "',Emr_Contact='" + txtEmrRelContact.Text.Trim() + "',IFSCCode='" + txtIFSCCode.Text.Trim() + "',ACC_HolderName='" + txtAccHolderName.Text.Trim() + "',UANNO='" + txtUAN.Text.Trim() + "',NO_ofDepdent='" + txtDependent.Text.Trim() + "',MedFitness='"+ddlMedicalFit.SelectedItem.Text+"' ");
            sb.Append(" ,Emp_AdharCard='" + txtEmpAadharCard.Text.Trim() + "',Emp_InsuranceNo='" + txtEmpInsurance.Text.Trim() + "' ");
            if (txtDOL.Text != "")
            {
                sb.Append(" ,DOL='" + Util.GetDateTime(DOL).ToString("yyyy-MM-dd") + "'");
            }
            sb.Append(" ,VoterCardNo='"+txtVoterCardNo.Text.Trim()+"',PassportExpiryDate='"+Util.GetDateTime(txtPassportExpiryDate.Text).ToString("yyyy-MM-dd")+"',DLNo='"+txtDLNo.Text.Trim()+"',DrivingLiscenceTypeID="+ddlDrivingLiscenceType.SelectedValue+",DLExpiry='"+Util.GetDateTime(txtDLExpiry.Text).ToString("yyyy-MM-dd")+"' ");
            sb.Append(", UserType_ID = '" + cmbUserType.SelectedItem.Value.ToString() + "', Employee_Group_ID='" + Util.GetInt(ddlUserGroup.SelectedItem.Value) + "',IsInvolveinInterViewProcess ='"+ Util.GetInt(IsInvolveinInterViewProcess)+"'");
            sb.Append(" where EmployeeID='" + lblEmpID.Text + "'");
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());
         //   StockReports.ExecuteDML(sb.ToString());


            int exit = Util.GetInt(StockReports.ExecuteScalar(" Select count(*) from pay_empdepd_details  where EmployeeID ='" + lblEmpID.Text.Trim() + "'  AND Isactive=1"));

            if (exit > 0)
            {
                string Empquli = "update pay_empdepd_details set IsActive=0  where EmployeeID ='" + lblEmpID.Text.Trim() + "' ";
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, Empquli);
            }

            DataTable dt = new DataTable();
            if (ViewState["Emp_DepDetail"] !=null)
            {
                 dt = (DataTable)ViewState["Emp_DepDetail"];
            }
            
            if (dt.Rows.Count > 0)
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    sb.Clear();
                    sb.Append(" Insert into pay_empdepd_details (EmployeeID,Name,DOB,Age,Address,Relation,Occupation,MedicalFit,Createdby)");
                    sb.Append(" Values('" + lblEmpID.Text + "','" + Util.GetString(dt.Rows[i]["Name"]) + "','" + Util.GetDateTime(dt.Rows[i]["DOB"]).ToString("yyyy-MM-dd") + "','" + Util.GetString(dt.Rows[i]["Age"]) + "','" + Util.GetString(dt.Rows[i]["Address"]) + "','" + Util.GetString(dt.Rows[i]["Relation"]) + "'");
                    sb.Append(" ,'" + Util.GetString(dt.Rows[i]["Occupation"]) + "','" + Util.GetString(dt.Rows[i]["MedicalFitness"]) + "','" + Session["ID"].ToString() + "') ");
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());

                }
               
            }
            tranX.Commit();
            lblmsg.Text = "Record Updated Successfully";
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM02','" + lblmsg.ClientID + "');", true);
            BindDetail();
        }
        catch (Exception ex)
        {
            lblmsg.Text = "Error Occured Contact Adminstator";
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);

            //  lblmsg.Text = ex.Message;
        }
    }

    protected void btnNext_Click(object sender, EventArgs e)
    {
        int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM Employee_Master WHERE EmployeeID='" + Util.GetInt(lblEmpID.Text.Trim()) + "+1'"));
        if (count > 0)
        {
            int NextID = Util.GetInt(lblEmpID.Text.Trim()) + Util.GetInt(1);
            Response.Redirect("~/Design/Payroll/Employee_Registration.aspx?EmpID=" + NextID.ToString() + "");
        }
    }

    protected void btnPrevious_Click(object sender, EventArgs e)
    {
        int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM Employee_Master WHERE EmployeeID='" + Util.GetInt(lblEmpID.Text.Trim()) + "-1'"));
        if (count > 0)
        {
            int PreviousID = Util.GetInt(lblEmpID.Text.Trim()) - Util.GetInt(1);
            Response.Redirect("~/Design/Payroll/Employee_Registration.aspx?EmpID=" + PreviousID.ToString() + "");
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (ddlDepartment.SelectedIndex == -1)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM014','" + lblmsg.ClientID + "');", true);
            return;
        }
        if (ddlDesignation.SelectedIndex == -1)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM056','" + lblmsg.ClientID + "');", true);
            return;
        }
        //if (txtFather.Text.Trim().Length <= 0 && txtMother.Text.Trim().Length <= 0)
        //{
        //    lblmsg.Text = "Mother or Father Name Required!";
        //    return;
        //}
        //if (txtPhone.Text.Trim().Length <= 0 && txtMobile.Text.Trim().Length <= 0)
        //{
        //    lblmsg.Text = "Phone or Mobile No. Name Required!";
        //    return;
        //}
        //if (cmdTitle.SelectedItem.Text == "DR.")
        //{
        //    if (txtRegNo.Text.Length <= 0)
        //    {
        //        lblmsg.Text = "Dr. Registration No Required";
        //        return;
        //    }
        //}
        try
        {
            string EmployeeID = Save();
            
            if (!String.IsNullOrEmpty(EmployeeID)) 
            {
                saveEmployeeDependent(EmployeeID);
                if(chkLogin.Checked)
                    SaveHisEmployee(EmployeeID);
                Clear();
                Response.Redirect("~/Design/Payroll/Employee_ProfessionalDetail_New.aspx?EmpID=" + EmployeeID);
            }
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            //lblmsg.Text = ex.Message;
        }

    }

    private void saveEmployeeDependent(string EmployeeID)
    {
        StringBuilder sb = new StringBuilder();

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        DataTable dt = (DataTable)ViewState["Emp_DepDetail"];
        try
        {
            if (dt != null)
            {
                if (dt.Rows.Count > 0)
                {
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        sb.Clear();
                        sb.Append(" Insert into pay_empdepd_details (EmployeeID,Name,DOB,Age,Address,Relation,Occupation,MedicalFit,Createdby)");
                        sb.Append(" Values('" + EmployeeID + "','" + Util.GetString(dt.Rows[i]["Name"]) + "','" + Util.GetDateTime(dt.Rows[i]["DOB"]).ToString("yyyy-MM-dd") + "','" + Util.GetString(dt.Rows[i]["Age"]) + "','" + Util.GetString(dt.Rows[i]["Address"]) + "','" + Util.GetString(dt.Rows[i]["Relation"]) + "'");
                        sb.Append(" ,'" + Util.GetString(dt.Rows[i]["Occupation"]) + "','" + Util.GetString(dt.Rows[i]["MedicalFitness"]) + "','" + Session["ID"].ToString() + "') ");

                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());

                    }
                }
            }

            if (!String.IsNullOrEmpty(lblConductCandidateID.Text)) 
            {
                string str = "Update pay_interviewcandidate set EmployeeID='" + EmployeeID + "' where ID='" + lblConductCandidateID.Text.Trim() + "'";
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text,str);
            }

            //-------------Insert into Centre Access to give default login centre access--------

            string str1 = "INSERT INTO centre_access (EmployeeID,CentreAccess,CreatedBy,CreatedDate) VALUES('" + EmployeeID + "','" + Session["CentreID"].ToString() + "','" + Session["ID"].ToString() + "',NOW())";
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str1);

            // End

            //------------Increment in Employee Registration No------------

            string str2 = "Update pay_id_master set MAxID= maxID+1 where GroupName = 'Emp_Reg_No' and CentreID=" + Util.GetInt(Session["CentreID"]) + "";
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str2);
            //-------------------
            tranX.Commit();
        }
        catch (Exception ex)
        {
            tranX.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblName.Text = "Error";
            throw (ex);

        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }


    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtDOJ.Text = txtInterviewFromDate.Text=txtInterviewToDate.Text =   System.DateTime.Now.ToString("dd-MMM-yyyy");

            AllLoadDate_Payroll.BindDepartmentPayroll(ddlDepartment);
            AllLoadDate_Payroll.BindDesignationPayroll(ddlDesignation);
         //   AllLoadDate_Payroll.BindBloodgroupPayroll(ddlBloodGroup);
          //  AllLoadDate_Payroll.BindTitlePayroll(cmdTitle);
            All_LoadData.bindTitle(cmdTitle);
            AllLoadDate_Payroll.BindBankNamePayroll1(ddlBankName);

            txtDOB.Text = System.DateTime.Now.AddYears(-18).ToString("dd-MMM-yyyy");
            bindCentre();
            BindExistEmployee();
            LoadCentre();
            LoadBloodBankBloodGroup();
            LoadDrivingLiscenceType();
            BindUserType();
            BindUserGroup();
            if (Request.QueryString.Count > 0)
            {
                btnSave.Visible = false;
                btnEdit.Visible = true;
                btnNext.Visible = true;
                //btnSearch.Visible = true;
                btnPrevious.Visible = true;
                //  divHeader.Visible = true;

                BindDetail();
                EmpID = Request.QueryString["EmpID"].ToString();
                d1.Visible = true;
                lblEmpID.Text = EmpID.ToString();
                DataTable EmpDetail = StockReports.GetDataTable("select Name,Fathername,desi_name from Employee_Master where EmployeeID='" + lblEmpID.Text.Trim() + "'");
                if (EmpDetail.Rows.Count > 0)
                {
                    lblName.Text = EmpDetail.Rows[0]["Name"].ToString();
                    // lblFatherName.Text = EmpDetail.Rows[0]["Fathername"].ToString();
                    // lblDesignation.Text = EmpDetail.Rows[0]["desi_name"].ToString();
                }


            }
            string isAutoRegNogenerate = Resources.Resource.Employee_RegistrationNo_Generate;
            if (isAutoRegNogenerate == "0") {
                txtRegNo.Attributes.Add("readonly", "readonly");
            }
         //   ddlHospital.Items.Insert(0, new ListItem(Resources.Resource.ClientName, "0"));
            CalendarExtender1.EndDate = ccDLExpiry.StartDate= ccPassportExpiry.StartDate=calucDate.EndDate= DateTime.Now;
            txtPassportExpiryDate.Text=txtDLExpiry.Text = DateTime.Now.ToString("dd-MM-yyyy");
            calDOB.EndDate = DateTime.Now.AddYears(-18);
            //string strJSScript = "this.value='Assigning...';this.disabled=true;";
            // btnEdit.Attributes.Add("onclick", strJSScript + ClientScript.GetPostBackEventReference(btnEdit, "").ToString());
        }
        //   txtDOL.Attributes.Add("readonly", "readonly");
        txtDOJ.Attributes.Add("readonly", "readonly");
        txtDOB.Attributes.Add("readonly", "readonly");
        txtPassportExpiryDate.Attributes.Add("readonly", "readonly");
        txtDLExpiry.Attributes.Add("readonly", "readonly");
        txtInterviewFromDate.Attributes.Add("readonly", "readonly");
        txtInterviewToDate.Attributes.Add("readonly", "readonly");
        if (Request.QueryString.Count > 0)
        {
         //   ((LinkButton)Master.FindControl("lnkSignOut")).Visible = false;
          //  ((Menu)Master.FindControl("mnuHIS")).Visible = false;
          //  ((DropDownList)Master.FindControl("ddlUserName")).Visible = false;
            //((Label)Master.FindControl("lblLogin")).Visible = false;
            pnlHide.Visible = true;
        }
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
        ddlUserGroup.Items.Insert(0, new ListItem("Select"));
    }
    private void LoadCentre()
    {
        ddlHospital.DataSource = StockReports.GetDataTable("SELECT CentreID, CentreName FROM center_master WHERE isactive=1 ORDER BY CentreName");
        ddlHospital.DataValueField = "CentreID";
        ddlHospital.DataTextField = "CentreName";
        ddlHospital.DataBind();
    }
    private void LoadBloodBankBloodGroup()
    {
        ddlBloodGroup.DataSource = StockReports.GetDataTable("SELECT ID, BloodGroup Name FROM bb_bloodgroup_master WHERE isactive=1 ORDER BY bloodgroup");
        ddlBloodGroup.DataValueField= "ID";
        ddlBloodGroup.DataTextField = "Name";
        ddlBloodGroup.DataBind();
    }

    private void LoadDrivingLiscenceType()
    {
       ddlDrivingLiscenceType.DataSource= StockReports.GetDataTable("SELECT ID, Name FROM t_drivingLiscenceType_master WHERE isactive=1 ORDER BY Name");
       ddlDrivingLiscenceType.DataValueField = "ID";
       ddlDrivingLiscenceType.DataTextField = "Name";
       ddlDrivingLiscenceType.DataBind();
       ddlDrivingLiscenceType.Items.Insert(0, new ListItem("Select", "0"));
    }

    private void BindDetail()
    {
        try
        {
            BindEmpDependentDetails(Request.QueryString["EmpID"].ToString());

            StringBuilder sb = new StringBuilder();
            sb.Append(" select  RegNo, EmployeeID,Title,Name,no_relation,House_No,Street_Name,Locality,City,Pincode,PHouse_No,PStreet_Name, ");
            sb.Append("    PLocality,PCity,PPincode,DATE_FORMAT(DOB,'%d-%b-%Y')DOB,if(DOL='0001-01-01 00:00:00','',if(DOL='0000-00-00 00:00:00','',DOL))DOL,BloodGroup,FatherName,MotherName,HusbandName,ESI_No,EPF_No,Desi_Name, ");
            sb.Append(" PAN_No,PassportNo,Email,Phone,Mobile,DATE_FORMAT(DOJ,'%d-%b-%Y')DOJ,Gender,Dept_ID,Desi_ID,");
            sb.Append(" PF_No,PF_NOMINEE1,BankAccountNo,LetterNo,Category ,RegNo,IsAccomodation,Branch,BankID,BranchID,KinName,KinAddress,kinPhoneNo,No_Name,No_Address,No_ContactNo,No_AddharCard,Emp_Category,Emr_Relation,Emr_Name,Emr_Contact ");
            sb.Append(" ,IFSCCode,ACC_HolderName,UANNO,NO_ofDepdent,MedFitness,Emp_AdharCard,Emp_InsuranceNo,VoterCardNo,DATE_FORMAT(PassportExpiryDate,'%d-%b-%Y')PassportExpiryDate,DLNo,DrivingLiscenceTypeID,DATE_FORMAT(DLExpiry,'%d-%b-%Y')DLExpiry,IsInvolveinInterViewProcess ");
            sb.Append(" from Employee_Master where EmployeeID='" + Request.QueryString["EmpID"].ToString() + "'");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                lblEmpID.Text = dt.Rows[0]["EmployeeID"].ToString();
                lblEmpRegNo.Text = dt.Rows[0]["RegNo"].ToString();
                txName.Text = dt.Rows[0]["Name"].ToString();
                txtHouseNo.Text = dt.Rows[0]["House_No"].ToString();
                txtStreet.Text = dt.Rows[0]["Street_Name"].ToString();
                txtLocality.Text = dt.Rows[0]["Locality"].ToString();
                txtCity.Text = dt.Rows[0]["City"].ToString();
                txtPinCode.Text = dt.Rows[0]["Pincode"].ToString();
                txtOhouseNo.Text = dt.Rows[0]["PHouse_No"].ToString();
                txtOStreet.Text = dt.Rows[0]["PStreet_Name"].ToString();
                txtOlocality.Text = dt.Rows[0]["PLocality"].ToString();
                txtOCity.Text = dt.Rows[0]["PCity"].ToString();
                txtOPinCode.Text = dt.Rows[0]["PPincode"].ToString();
                rbtnGender.SelectedIndex = rbtnGender.Items.IndexOf(rbtnGender.Items.FindByText(dt.Rows[0]["gender"].ToString()));
                txtFather.Text = dt.Rows[0]["FatherName"].ToString();
                txtMother.Text = dt.Rows[0]["MotherName"].ToString();
                txtHusbandName.Text = dt.Rows[0]["HusbandName"].ToString();
                txtMobile.Text = dt.Rows[0]["Mobile"].ToString();
                txtPhone.Text = dt.Rows[0]["Phone"].ToString();
                //// txtDOB.SetDate(Util.GetString(Util.GetDateTime(dt.Rows[0]["DOB"].ToString()).Day), Util.GetString(Util.GetDateTime(dt.Rows[0]["DOB"].ToString()).Month), Util.GetString(Util.GetDateTime(dt.Rows[0]["DOB"].ToString()).Year));
                //// txtDOJ.SetDate(Util.GetString(Util.GetDateTime(dt.Rows[0]["DOJ"].ToString()).Day), Util.GetString(Util.GetDateTime(dt.Rows[0]["DOJ"].ToString()).Month), Util.GetString(Util.GetDateTime(dt.Rows[0]["DOJ"].ToString()).Year));
                txtDOB.Text = dt.Rows[0]["DOB"].ToString();
                txtDOJ.Text = dt.Rows[0]["DOJ"].ToString();
                txtPAN.Text = dt.Rows[0]["PAN_No"].ToString();
                txtESI.Text = dt.Rows[0]["ESI_No"].ToString();
                txtPFNo.Text = dt.Rows[0]["PF_No"].ToString();
                txtPassport.Text = dt.Rows[0]["PassportNo"].ToString();
                txtPF_Nominee1.Text = dt.Rows[0]["PF_NOMINEE1"].ToString();
                txtBankAccNo.Text = dt.Rows[0]["BankAccountNo"].ToString();
                txtLetterNO.Text = dt.Rows[0]["LetterNo"].ToString();
                txtRegNo.Text = dt.Rows[0]["RegNo"].ToString();
                // txtBankName.Text = dt.Rows[0]["BankName"].ToString();
                ddlBankName.SelectedIndex = ddlBankName.Items.IndexOf(ddlBankName.Items.FindByValue(dt.Rows[0]["BankID"].ToString()));
                txtEmail.Text = dt.Rows[0]["Email"].ToString();
                txtBranch.Text = dt.Rows[0]["BranchID"].ToString();
                ddlBranch.Items.Clear();
                BindBranch();
                //Payroll_AllLoadDate.BindBranchBankPayroll(ddlBankName.SelectedItem.Value);
                ddlBranch.SelectedIndex = ddlBranch.Items.IndexOf(ddlBranch.Items.FindByValue(txtBranch.Text));

                ddlBloodGroup.SelectedIndex = ddlBloodGroup.Items.IndexOf(ddlBloodGroup.Items.FindByText(dt.Rows[0]["BloodGroup"].ToString()));
                ddlDepartment.SelectedIndex = ddlDepartment.Items.IndexOf(ddlDepartment.Items.FindByValue(dt.Rows[0]["Dept_ID"].ToString()));
                ddlDesignation.SelectedIndex = ddlDesignation.Items.IndexOf(ddlDesignation.Items.FindByText(dt.Rows[0]["Desi_Name"].ToString().Split('#')[0]));
                ddlHospital.SelectedIndex = ddlHospital.Items.IndexOf(ddlHospital.Items.FindByText(dt.Rows[0]["Branch"].ToString().Split('#')[0]));

                ddlCategory.SelectedIndex = ddlCategory.Items.IndexOf(ddlCategory.Items.FindByText(dt.Rows[0]["Emp_Category"].ToString()));
                cmdTitle.SelectedItem.Text = dt.Rows[0]["Title"].ToString();
                txtKinName.Text = dt.Rows[0]["KinName"].ToString();
                txtKinAddress.Text = dt.Rows[0]["KinAddress"].ToString();
                txtKinPhoneNo.Text = dt.Rows[0]["kinPhoneNo"].ToString();
                txtNomineeName.Text = dt.Rows[0]["No_Name"].ToString();
                txtNomineeAdres.Text = dt.Rows[0]["No_Address"].ToString();
                txtNomineeContactNo.Text = dt.Rows[0]["No_ContactNo"].ToString();
                txtNomineeAdharCard.Text = dt.Rows[0]["No_AddharCard"].ToString();

                ddlNomineeRelation.SelectedIndex = ddlNomineeRelation.Items.IndexOf(ddlNomineeRelation.Items.FindByText(dt.Rows[0]["no_relation"].ToString()));
                ddlEmrRelation.SelectedIndex = ddlEmrRelation.Items.IndexOf(ddlEmrRelation.Items.FindByText(dt.Rows[0]["Emr_Relation"].ToString()));
                txtEmrRelName.Text = dt.Rows[0]["Emr_Name"].ToString();
                txtEmrRelContact.Text = dt.Rows[0]["Emr_Contact"].ToString();
                txtIFSCCode.Text = dt.Rows[0]["IFSCCode"].ToString();
                txtAccHolderName.Text = dt.Rows[0]["ACC_HolderName"].ToString();
                txtUAN.Text = dt.Rows[0]["UANNO"].ToString();
                txtDependent.Text = dt.Rows[0]["NO_ofDepdent"].ToString();
                ddlMedicalFit.SelectedIndex = ddlMedicalFit.Items.IndexOf(ddlMedicalFit.Items.FindByText(dt.Rows[0]["MedFitness"].ToString()));
                txtEmpAadharCard.Text = dt.Rows[0]["Emp_AdharCard"].ToString();
                txtEmpInsurance.Text = dt.Rows[0]["Emp_InsuranceNo"].ToString();
                // lblDOL.Visible = true;
                // txtDOL.Visible = true;
                if (dt.Rows[0]["DOL"].ToString() != "")
                {
                    if (!dt.Rows[0]["DOL"].ToString().Contains("0001-01-01 00:00:00"))
                    {
                        txtDOL.Text = Util.GetDateTime(dt.Rows[0]["DOL"].ToString()).ToString("dd-MMM-yyyy");
                        ////  txtDOL.SetDate(Util.GetString(Util.GetDateTime(dt.Rows[0]["DOL"].ToString()).Day), Util.GetString(Util.GetDateTime(dt.Rows[0]["DOL"].ToString()).Month), Util.GetString(Util.GetDateTime(dt.Rows[0]["DOL"].ToString()).Year));
                    }
                }
                ddlAccomodation.SelectedIndex = ddlAccomodation.Items.IndexOf(ddlAccomodation.Items.FindByValue(dt.Rows[0]["IsAccomodation"].ToString()));

                ////  txtDOB.SetDate(Util.GetString(Util.GetDateTime(dt.Rows[0]["DOB"].ToString()).Day), Util.GetString(Util.GetDateTime(dt.Rows[0]["DOB"].ToString()).Month), Util.GetString(Util.GetDateTime(dt.Rows[0]["DOB"].ToString()).Year));
                ////  txtDOJ.SetDate(Util.GetString(Util.GetDateTime(dt.Rows[0]["DOJ"].ToString()).Day), Util.GetString(Util.GetDateTime(dt.Rows[0]["DOJ"].ToString()).Month), Util.GetString(Util.GetDateTime(dt.Rows[0]["DOJ"].ToString()).Year));

                txtPassportExpiryDate.Text = Util.GetDateTime(dt.Rows[0]["PassportExpiryDate"].ToString()).ToString("dd-MMM-yyyy");
                txtVoterCardNo.Text = dt.Rows[0]["VoterCardNo"].ToString();
                txtDLNo.Text = dt.Rows[0]["DLNo"].ToString();
                txtDLExpiry.Text = Util.GetDateTime(dt.Rows[0]["DLExpiry"].ToString()).ToString("dd-MMM-yyyy");
                ddlDrivingLiscenceType.SelectedIndex = ddlDrivingLiscenceType.Items.IndexOf(ddlDrivingLiscenceType.Items.FindByValue(dt.Rows[0]["DrivingLiscenceTypeID"].ToString()));
                if(Util.GetInt(dt.Rows[0]["IsInvolveinInterViewProcess"]) == 1) 
                {
                    chkIsInvolveinInterViewProcess.Checked = true;
                }
                else
                {
                    chkIsInvolveinInterViewProcess.Checked = false;
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    private void BindEmpDependentDetails(string Empid)
    {
        DataTable dt=new DataTable();
        dt = StockReports.GetDataTable(" SELECT NAME,DATE_FORMAT(DOB,'%d-%b-%Y')DOB,AGE,Address,Relation,Occupation,MedicalFit AS MedicalFitness FROM pay_empdepd_details WHERE EmployeeID='" + Empid + "' AND Isactive=1 ");
        if (dt.Rows.Count > 0)
        {
            ViewState["Emp_DepDetail"] = dt;
            grdEmployeDepndet.DataSource = dt;
            grdEmployeDepndet.DataBind();
        }
    }
    private void BindExistEmployee()
    {
        DataTable dtEmployee = StockReports.GetDataTable("SELECT EmployeeID,NAME FROM Employee_master WHERE PayrollEmployeeID IS NULL OR PayrollEmployeeID=''");
        if (dtEmployee.Rows.Count > 0)
        {
            ddlExistEmp.DataSource = dtEmployee;
            ddlExistEmp.DataTextField = "NAME";
            ddlExistEmp.DataValueField = "EmployeeID";
            ddlExistEmp.DataBind();
        }
        else
        {
            ddlExistEmp.Items.Clear();
        }
        ddlExistEmp.Items.Insert(0, new ListItem("--Select--", "0"));
        ddlExistEmp.SelectedIndex = 0;
    }

    private void bindTitle()
    {
        cmdTitle.DataSource = AllGlobalFunction.NameTitle;
        cmdTitle.DataBind();
        cmdTitle.Items.Insert(0, "");
    }

    private string Save()
    {
        var EmpRegno = getEmployeeMaxRegistrationNo();
       // Payroll_EmployeeRegistration objEmp = new Payroll_EmployeeRegistration();
        MSTEmployee objEmp = new MSTEmployee();
        objEmp.HospCode = HttpContext.Current.Session["HOSPID"].ToString();
        objEmp.Title = cmdTitle.SelectedItem.Text.Trim();
        objEmp.Name = txName.Text.Trim();
        objEmp.House_No = txtHouseNo.Text.Trim();
        objEmp.Street_Name = txtStreet.Text.Trim();
        objEmp.Locality = txtLocality.Text.Trim();
        objEmp.City = txtCity.Text.Trim();
        objEmp.PinCode = Util.GetInt(txtPinCode.Text.Trim());
        objEmp.PHouse_No = txtOhouseNo.Text.Trim();
        objEmp.PStreet_Name = txtOStreet.Text.Trim();
        objEmp.PLocality = txtOlocality.Text.Trim();
        objEmp.PCity = txtOCity.Text.Trim();
        objEmp.PPinCode = Util.GetInt(txtOPinCode.Text.Trim());
        objEmp.FatherName = txtFather.Text.Trim();
        objEmp.MotherName = txtMother.Text.Trim();
        objEmp.HusbandName = txtHusbandName.Text.Trim();
        objEmp.ESI_No = txtESI.Text.Trim();
        //objEmp.LIC_ID_NO = txtLIC.Text.Trim();
        objEmp.LIC_ID_NO = Util.GetString(ddlEmployeeType.SelectedValue);
        objEmp.PAN_No = txtPAN.Text.Trim();
        objEmp.Passport_No = txtPassport.Text.Trim();
        objEmp.DOB = Util.GetDateTime(txtDOB.Text);
        objEmp.Mobile = txtMobile.Text.Trim();
        objEmp.Phone = txtPhone.Text.Trim();

        objEmp.Email = txtEmail.Text.Trim();
        // objEmp.Gender = rbtnGender.SelectedItem.Text.Trim();
        objEmp.Gender = txtGender.Text.Trim();
        objEmp.DOJ = Util.GetDateTime(txtDOJ.Text);
        objEmp.Dept_ID = Util.GetString(ddlDepartment.SelectedItem.Value);
        objEmp.Dept_Name = Util.GetString(ddlDepartment.SelectedItem.Text);
        objEmp.Desi_ID = Util.GetString(ddlDesignation.SelectedItem.Value.Split('#')[0]);
        objEmp.Desi_Name = Util.GetString(ddlDesignation.SelectedItem.Text);

        objEmp.LetterNo = Util.GetInt(txtLetterNO.Text);

        objEmp.Blood_Group = ddlBloodGroup.SelectedItem.Text;
        objEmp.HospCode = ddlHospital.SelectedValue;
        objEmp.PF_No = txtPFNo.Text;

        objEmp.PF_NOMINEE1 = txtPF_Nominee1.Text;
        objEmp.PF_NOMINEE2 = txtPF_Nominee2.Text;
        objEmp.BankAccountNo = txtBankAccNo.Text;
        objEmp.DisNo = txtDisNo.Text;
        objEmp.RegNo = EmpRegno;
        objEmp.Branch = ddlHospital.SelectedItem.Text.Trim();
        objEmp.BankID = ddlBankName.SelectedItem.Value;
        objEmp.BranchID = txtBranch.Text.Trim();
        objEmp.KinName = txtKinName.Text;
        objEmp.KinAddress = txtKinAddress.Text;
        objEmp.kinPhoneNo = txtKinPhoneNo.Text;
        objEmp.IsAccomodation = Util.GetInt(ddlAccomodation.SelectedValue);
        objEmp.No_Name = txtNomineeName.Text;
        objEmp.No_Relation = ddlNomineeRelation.SelectedItem.Text;
        objEmp.No_Address = txtNomineeAdres.Text;
        objEmp.No_ContactNo = txtNomineeContactNo.Text;
        objEmp.No_AddharCard = txtNomineeAdharCard.Text;
        objEmp.Emp_Category = ddlCategory.SelectedItem.Value;
        objEmp.Emr_Relation = ddlEmrRelation.SelectedItem.Text;
        objEmp.Emr_Name = txtEmrRelName.Text;
        objEmp.Emr_Contact = txtEmrRelContact.Text;
        objEmp.IFSCCode = txtIFSCCode.Text;
        objEmp.UANNO = txtUAN.Text;
        objEmp.NO_ofDepdent = txtDependent.Text;
        objEmp.MedFitness = ddlMedicalFit.SelectedItem.Text;
        objEmp.Emp_AdharCard = txtEmpAadharCard.Text;
        objEmp.Emp_InsuranceNo = txtEmpInsurance.Text;
        objEmp.ACC_HolderName = txtAccHolderName.Text;
        objEmp.VoterCardNo = txtVoterCardNo.Text.Trim();
        objEmp.PassportExpiryDate = Util.GetDateTime(txtPassportExpiryDate.Text);
        objEmp.DLNo = txtDLNo.Text.Trim();
        objEmp.DLExpiry = Util.GetDateTime(txtDLExpiry.Text);
        objEmp.DrivingLiscenceTypeID = Util.GetInt(ddlDrivingLiscenceType.SelectedValue);
        objEmp.UserType_ID = cmbUserType.SelectedItem.Value.ToString();
        objEmp.Employee_Group_ID = Util.GetInt(ddlUserGroup.SelectedItem.Value);
        objEmp.IsInvolveinInterViewProcess = chkIsInvolveinInterViewProcess.Checked ? 1 : 0;
        string EmployeeID = objEmp.Insert();

        return EmployeeID;
        
    }
    private string getEmployeeMaxRegistrationNo()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD exc = new ExcuteCMD();
        try
        {
            var EmpRegNo="";
            string isAutoRegNo = Resources.Resource.Employee_RegistrationNo_Generate;
            if (isAutoRegNo == "0")
            {
                string str = "SELECT get_Employee_Reg_No(@Emp_Reg_No,@CentreID)";
                EmpRegNo = Util.GetString(exc.ExecuteScalar(tnx, str, CommandType.Text, new
                {
                    Emp_Reg_No = "Emp_Reg_No",
                    CentreID = Util.GetInt(Session["CentreID"]),
                }));
            }
            else {
               EmpRegNo= txtRegNo.Text;
            }
            tnx.Commit();
            return EmpRegNo;
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
}
    private string SaveHisEmployee(string EmployeeID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        MySqlTransaction MySqltrans = con.BeginTransaction();

        try
        {
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
                        EmHsp.Insert();
                    }
                }
            }
            //-------------Table Employee UserType------
            MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, "DELETE FROM f_login WHERE EmployeeID='" + EmployeeID + "'");
            string str1 = "";
            string Password = EncryptPassword(txtpwd.Text.Trim());
            foreach (GridViewRow gr in grlLoginRoles.Rows)
            {
                CheckBoxList chk_prev = ((CheckBoxList)gr.FindControl("chk_prev"));
                string centre = ((Label)gr.FindControl("lblCentreId")).Text;

                foreach (ListItem li in chk_prev.Items)
                {
                    if (li.Selected == true)
                    {
                        str1 = "INSERT INTO f_login(RoleID,EmployeeID,UserName,Password,CentreID)" +
                         "values(" + li.Value + ",'" + EmployeeID + "','" + txtuid.Text.Trim() + "','" + Password + "','" + centre + "')";
                        MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, str1);
                    }
                }
            }

            MySqltrans.Commit();
            return EmployeeID;
        }
        catch (Exception ex)
        {
            MySqltrans.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblName.Text = "Error";
            throw (ex);

        }
        finally
        {
            MySqltrans.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    private string SerializeObject(object myObject)
    {
        var stream = new MemoryStream();
        var xmldoc = new XmlDocument();
        var serializer = new XmlSerializer(myObject.GetType());
        using (stream)
        {
            serializer.Serialize(stream, myObject);
            stream.Seek(0, SeekOrigin.Begin);
            xmldoc.Load(stream);
        }

        return xmldoc.InnerXml;
    }
    public static string EncryptPassword(string text)
    {
        MD5 md5 = new MD5CryptoServiceProvider();
        md5.ComputeHash(ASCIIEncoding.ASCII.GetBytes(text));
        byte[] result = md5.Hash;
        StringBuilder strBuilder = new StringBuilder();
        for (int i = 0; i < result.Length; i++)
        {
            strBuilder.Append(result[i].ToString("x2").ToLower());
        }
        return strBuilder.ToString();
    }
    [WebMethod(EnableSession = true)]
    public static string hrCityMaster(string City)
    {
        return AllInsert.hrCity_master(City);

    }
    [WebMethod(EnableSession = true)]
    public static string bindhrcityMaster()
    {
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable("SELECT ID,City FROM pay_city_master WHERE IsActive=1");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    protected void btnDepDetails_Click(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();

        if (ViewState["Emp_DepDetail"] == null)
        {
            dt.Columns.Add("Name");
            dt.Columns.Add("DOB");
            dt.Columns.Add("AGE");
            dt.Columns.Add("Address");
            dt.Columns.Add("Relation");
            dt.Columns.Add("MedicalFitness");
            dt.Columns.Add("Occupation");
        }
        else
        {
            dt = (DataTable)ViewState["Emp_Qli"];
        }

        DataRow dr = null;
        if (ViewState["Emp_DepDetail"] != null)
       {
            dt = (DataTable)ViewState["Emp_DepDetail"];
            if (dt.Rows.Count > 0)
            {
                dr = dt.NewRow();
                dr["Name"] = txtDName.Text;
                dr["DOB"] = Util.GetDateTime(txtDdob.Text).ToString("dd-MMM-yyyy");
                dr["AGE"] = txtDage.Text + ddlDAge.SelectedItem.Text;
                dr["Address"] = txtDAddress.Text;
                dr["Relation"] = ddlDRelation.SelectedItem.Text;
                dr["MedicalFitness"] = ddlDMedicalFit.SelectedItem.Text;
                dr["Occupation"] = txtDOccupation.Text;
                dt.Rows.Add(dr);
                grdEmployeDepndet.DataSource = dt;
                grdEmployeDepndet.DataBind();

            }
        }
            else
            {
                dr = dt.NewRow();
                dr["Name"] = txtDName.Text;
                dr["DOB"] = Util.GetDateTime(txtDdob.Text).ToString("dd-MMM-yyyy");
                dr["AGE"] = txtDage.Text + ddlDAge.SelectedItem.Text;
                dr["Address"] = txtDAddress.Text;
                dr["Relation"] = ddlDRelation.SelectedItem.Text;
                dr["MedicalFitness"] = ddlDMedicalFit.SelectedItem.Text;
                dr["Occupation"] = txtDOccupation.Text;
                dt.Rows.Add(dr);
                grdEmployeDepndet.DataSource = dt;
                grdEmployeDepndet.DataBind();
            }
            ViewState["Emp_DepDetail"] = dt;

        }


    protected void grdEmployeDepndet_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        DataTable dtdlete = (DataTable)ViewState["Emp_DepDetail"];
        dtdlete.Rows[e.RowIndex].Delete();
        ViewState["Emp_DepDetail"] = dtdlete;
        BindgrdEmployeDepndet();
    }

    private void BindgrdEmployeDepndet()
    {
        DataTable dt = (DataTable)ViewState["Emp_DepDetail"];
        grdEmployeDepndet.DataSource = dt;
        grdEmployeDepndet.DataBind();

    }
    [WebMethod(EnableSession = true)]
    public static string getEmployeeRegistrationNo()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD exc = new ExcuteCMD();
        try
        {
            string str = "SELECT CONCAT(Prefix,MaxID)a from pay_id_master where GroupName=@Emp_Reg_No and CentreID=@CentreID";
            var EmpRegNo = Util.GetString(exc.ExecuteScalar(tnx, str, CommandType.Text, new
            {
                Emp_Reg_No = "Emp_Reg_No",
                CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"]),
            }));
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = EmpRegNo });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Some Error Occurred in Generate Employee Registration No" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string ValidateDuplicateRegNo(string regNo) {
        ExcuteCMD exc = new ExcuteCMD();
        var str = "SELECT CONCAT(Title,NAME)EmpName FROM employee_master WHERE regno = @regno limit 1";
        var EmpName= Util.GetString(exc.ExecuteScalar(str, new
        {
            regno=regNo,
        }));
        if (!String.IsNullOrEmpty(EmpName))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = regNo + " already linked with <br/>" + EmpName });
        }
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true });
    }
}