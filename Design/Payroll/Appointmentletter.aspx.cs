using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Payroll_Appointmentletter : System.Web.UI.Page
{
    protected void BindRecord()
    {
        string select = " select ID,EmployeeID,Name,Designation,JoiningLocation,AppointmentLetterType, AppointmentDate ,Date_Format(DOJ,'%d-%b-%Y')DOJ,Basic,HRA,ConvenenceAllowence,TotalRemuneration,Amountinwords,AuthorityName,AuthorityDesignation,AuthorityDepartment,JobTiming,JobExpectations,InstructionfromDept,workingHrs,ProbationPeriod,TerminateApp from pay_appointmentletter Where ID='" + Request.QueryString["id"] + "'";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(select);
        ViewState["id"] = dt.Rows[0]["ID"];

        lblName.Text = dt.Rows[0]["Name"].ToString();
        lblEmployeeID.Text = dt.Rows[0]["EmployeeID"].ToString();
        lblDepartment.Text = StockReports.ExecuteScalar("Select Dept_Name from pay_employee_master where EmployeeID='" + lblEmployeeID.Text + "'");
        lblDesignation.Text = dt.Rows[0]["Designation"].ToString();
        //lblDepartment.Text = dt.Rows[0]["Department"].ToString();
        txtAddress.Text = dt.Rows[0]["JoiningLocation"].ToString();
        txtTotalRemuneration.Text = dt.Rows[0]["TotalRemuneration"].ToString();
        txtJobTiming.Text = (dt.Rows[0]["JobTiming"]).ToString();
        //lblDOJ.Text = dt.Rows[0]["DOJ"].ToString();
        txtDOJ.Text = Util.GetDateTime(dt.Rows[0]["DOJ"]).ToString("dd-MMM-yyyy");
        if (dt.Rows[0]["AppointmentLetterType"].ToString() == "Staff")
        {
            RadioButtonList1.SelectedIndex = 0;
        }
        else if (dt.Rows[0]["AppointmentLetterType"].ToString() == "Doctor")
        {
            RadioButtonList1.SelectedIndex = 1;
        }
        txtAppointmentDate.Text = Util.GetString(Convert.ToDateTime(dt.Rows[0]["AppointmentDate"]).ToString("dd-MMM-yyyy"));

        //txtJoinTime.Text = dt.Rows[0]["JoinTime"].ToString();
        //txtTiming.Text = dt.Rows[0]["Timing"].ToString();
        txtAuthorityDesignation.Text = dt.Rows[0]["AuthorityDesignation"].ToString();
        txtAuthorityName.Text = dt.Rows[0]["AuthorityName"].ToString();
        txtAuthorityDepartment.Text = dt.Rows[0]["AuthorityDepartment"].ToString();
        txtExpectations.Text = dt.Rows[0]["JobExpectations"].ToString();
        txtInstruction.Text = dt.Rows[0]["InstructionfromDept"].ToString();
        txtWorkHrs.Text = Util.GetString(dt.Rows[0]["workingHrs"]);
        txtProbation.Text = Util.GetString(dt.Rows[0]["ProbationPeriod"]);
        txtTeminate.Text = Util.GetString(dt.Rows[0]["TerminateApp"]);
        pnlhide.Visible = true;
        AllLoadDate_Payroll pay = new AllLoadDate_Payroll();
        DateTime DOLDate = Util.GetDateTime(pay.getDateOfJoining(lblEmployeeID.Text));
        CalendarExtender1.StartDate = Util.GetDateTime(DOLDate.ToString("dd-MMM-yyyy"));
        lblGrade.Text = StockReports.ExecuteScalar("Select Grade from pay_designation_master pds inner join pay_employee_master pem on pds.Des_ID=pem.Desi_ID where pem.EmployeeID='" + lblEmployeeID.Text + "'");

        BindData();
    }

    protected void btncancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("ViewAppointmentLetter.aspx");
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            lblmsg.Text = "";
            if (((Button)sender).Text == "Add New")
            //if(((Button)e).Text=="Add New")
            {
                lblDesignation.Text = "";
                lblDepartment.Text = "";
                lblName.Text = "";
                txtAppointmentDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                txtTotalRemuneration.Text = "";
                lblEmployeeID.Text = "";
                txtAddress.Text = "";
                RadioButtonList1.SelectedIndex = 0;
                btnSave.Text = "Save";
                txtJobTiming.Text = "";
                txtAppointmentDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                txtExpectations.Text = "";
                pnlhide.Visible = false;
                return;
            }
            if (txtAppointmentDate.Text == "")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM198','" + lblmsg.ClientID + "');", true);
                return;
            }
            if (txtDOJ.Text == "")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM099','" + lblmsg.ClientID + "');", true);
                return;
            }
            if (lblEmployeeID.Text.Trim() == "")
            {
                return;
            }
            if (lblName.Text.Trim() == "")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM199','" + lblmsg.ClientID + "');", true);
                return;
            }
            decimal basic = Util.GetDecimal(((TextBox)EarningGrid.Rows[0].FindControl("txtAmount")).Text);

            txtTotalRemuneration.Text = basic.ToString();

            int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM pay_appointmentletter WHERE EmployeeID='" + lblEmployeeID.Text.Trim() + "'"));
            if (count > 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM200','" + lblmsg.ClientID + "');", true);
                return;
            }
            string insert = "INSERT INTO pay_appointmentletter (NAME,EmployeeID,Designation,DOJ,JoiningLocation,AppointmentDate,Basic,TotalRemuneration,AuthorityName,AuthorityDesignation,AuthorityDepartment,UserID,AppointmentLetterType,JobTiming,Grade,JobExpectations,InstructionfromDept,workingHrs,ProbationPeriod,TerminateApp)";
            insert += " VALUES ('" + lblName.Text.Trim() + "','" + lblEmployeeID.Text.Trim() + "','" + lblDesignation.Text.Trim() + "','" + Util.GetDateTime(txtDOJ.Text).ToString("yyyy-MM-dd") + "','" + txtAddress.Text.Trim().Replace("'", "''") + "','" + Util.GetDateTime(txtAppointmentDate.Text).ToString("yyyy-MM-dd") + "','" + basic.ToString() + "','" + txtTotalRemuneration.Text.Trim() + "','" + txtAuthorityName.Text.Trim().Replace("'", "''") + "','" + txtAuthorityDesignation.Text.Trim().Replace("'", "''") + "','" + txtAuthorityDepartment.Text.Trim().Replace("'", "''") + "','" + ViewState["ID"].ToString() + "','" + RadioButtonList1.SelectedItem.Value + "','" + txtJobTiming.Text.Trim() + "','" + lblGrade.Text + "','" + txtExpectations.Text.Trim() + "','" + txtInstruction.Text.Trim() + "','" + Util.GetInt(txtWorkHrs.Text) + "','" + Util.GetInt(txtProbation.Text) + "','" + Util.GetInt(txtTeminate.Text) + "') ";

            StockReports.ExecuteDML(insert);
            // btnSave.Text = "Add New";
            pnlhide.Visible = false;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmsg.ClientID + "');", true);
            string id = StockReports.ExecuteScalar("SELECT MAX(ID) FROM pay_appointmentletter").ToString();
            string sql = "select ID,NAME,EmployeeID,Designation,Date_Format(DOJ,'%d %b %Y') DOJ,JoiningLocation,DocumentNo,Date_Format(AppointmentDate,'%d %b %Y')AppointmentDate,Basic,HRA,ConvenenceAllowence,TotalRemuneration,Amountinwords,AuthorityName,AuthorityDesignation,AuthorityDepartment,JobTiming,UserID,pm.PHouse_No,workingHrs,ProbationPeriod,TerminateApp,em.LIC_NO from pay_appointmentletter app inner join pay_employee_master em em.EmployeeID=app.EmployeeID where ID=" + id + "";
            DataTable dt = StockReports.GetDataTable(sql);
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            //ds.WriteXmlSchema("D:/AppointmentLetter.xml");
            Session["ds"] = ds;
            if (RadioButtonList1.SelectedIndex == 0)
            {
                Session["ReportName"] = "AppointmentLetter";
            }
            else if (RadioButtonList1.SelectedIndex == 1)
            {
                Session["ReportName"] = "AppointmentLetter2";
            }
            //else if (RadioButtonList1.SelectedIndex == 2)
            //{
            //    Session["ReportName"] = "AppointmentLetter4";
            //}
            //else if (RadioButtonList1.SelectedIndex == 3)
            //{
            //    Session["ReportName"] = "AppointmentLetter3";
            //}
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../Payroll/Report/Commonreport.aspx');", true);
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        StringBuilder sb = new StringBuilder();

        sb.Append(" select EmployeeID,Name,date_format(DOJ,'%d-%b-%Y')DOJ,FatherName,Gender,dept_Name,desi_Name from pay_employee_master  WHERE IsActive=1 ");
        if (txtEmployeeID.Text.Trim() != "" && txtEmployeeName.Text.Trim() != "")
        {
            sb.Append(" and EmployeeID='" + txtEmployeeID.Text.Trim() + "' and Name like '" + txtEmployeeName.Text.Trim() + "%' ");
        }
        else if (txtEmployeeID.Text.Trim() == "" && txtEmployeeName.Text.Trim() != "")
        {
            sb.Append(" and Name like '" + txtEmployeeName.Text.Trim() + "%' ");
        }
        else if (txtEmployeeID.Text.Trim() != "" && txtEmployeeName.Text.Trim() == "")
        {
            sb.Append(" and EmployeeID='" + txtEmployeeID.Text.Trim() + "'");
        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            EmpGrid.DataSource = dt;
            EmpGrid.DataBind();
        }
        else
        {
            EmpGrid.DataSource = null;
            EmpGrid.DataBind();
            lblmsg.Text = "Record not Found";
        }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        if (txtAppointmentDate.Text == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM198','" + lblmsg.ClientID + "');", true);

            return;
        }

        if (txtDOJ.Text == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM099','" + lblmsg.ClientID + "');", true);

            return;
        }
        if (lblEmployeeID.Text.Trim() == "")
        {
            lblEmployeeID.Text = "0";
        }
        if (lblName.Text.Trim() == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM199','" + lblmsg.ClientID + "');", true);
            return;
        }

        decimal basic = Util.GetDecimal(((TextBox)EarningGrid.Rows[0].FindControl("txtAmount")).Text);
        txtTotalRemuneration.Text = basic.ToString();
        string update = "UPDATE pay_appointmentletter SET NAME = '" + lblName.Text.Trim() + "' ,Designation = '" + lblDesignation.Text.Trim() + "' ,DOJ = '" + Util.GetDateTime(txtDOJ.Text).ToString("yyyy-MM-dd") + "' ,	JoiningLocation = '" + txtAddress.Text.Trim() + "'  ,AppointmentDate = '" + Util.GetDateTime(txtAppointmentDate.Text).ToString("yyyy-MM-dd") + "' ,Basic = '" + basic.ToString() + "'  ,TotalRemuneration = '" + txtTotalRemuneration.Text.Trim() + "', AuthorityName = '" + txtAuthorityName.Text.Trim() + "' ,AuthorityDesignation = '" + txtAuthorityDesignation.Text.Trim() + "' ,AuthorityDepartment = '" + txtAuthorityDepartment.Text.Trim() + "' ,UserID = '" + ViewState["ID"].ToString() + "',AppointmentLetterType='" + RadioButtonList1.SelectedItem.Value + "',JobTiming='" + txtJobTiming.Text.Trim() + "',JobExpectations='" + txtExpectations.Text.Trim() + "',InstructionfromDept='" + txtInstruction.Text.Trim() + "',workingHrs='" + Util.GetInt(txtWorkHrs.Text) + "',ProbationPeriod='" + Util.GetInt(txtProbation.Text) + "',TerminateApp='" + Util.GetInt(txtTeminate.Text) + "'  where ID='" + Request.QueryString["id"] + "'";
        StockReports.ExecuteDML(update);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Record Updated Successfully');location.href='ViewAppointmentLetter.aspx';", true);

    }

    protected void EmpGrid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            string Query = "Select EmployeeID,title,Concat(title,' ',Name)Name,Date_Format(DOJ,'%d %b %Y')DOJ,Desi_Name,Dept_Name from pay_Employee_master where EmployeeID='" + e.CommandArgument.ToString() + "'";
            DataTable dt = StockReports.GetDataTable(Query);
            if (dt.Rows.Count > 0)
            {
                pnlhide.Visible = true;
                lblEmployeeID.Text = dt.Rows[0]["EmployeeID"].ToString();
                lblName.Text = dt.Rows[0]["Name"].ToString();
                lblDesignation.Text = dt.Rows[0]["Desi_Name"].ToString();
                lblDepartment.Text = dt.Rows[0]["Dept_Name"].ToString();

                if (dt.Rows[0]["title"].ToString() == "Mr.")
                {
                    RadioButtonList1.SelectedIndex = 0;
                }
                else if (dt.Rows[0]["title"].ToString() == "Mrs.")
                {
                    RadioButtonList1.SelectedIndex = 0;
                }
                else if (dt.Rows[0]["title"].ToString() == "Miss.")
                {
                    RadioButtonList1.SelectedIndex = 0;
                }
                else if (dt.Rows[0]["title"].ToString() == "Dr.")
                {
                    RadioButtonList1.SelectedIndex = 1;
                }

                txtJobTiming.Text = StockReports.ExecuteScalar("SELECT CONCAT(DATE_FORMAT(JobTimeFrom,'%h %p'),' To ',DATE_FORMAT(JobTimeTo,'%h %p'))JobTime FROM pay_employee_master WHERE EmployeeID='" + lblEmployeeID.Text + "'");
                // txtDOJ.SetDate(Util.GetString(Util.GetDateTime(dt.Rows[0]["DOJ"].ToString()).Day), Util.GetString(Util.GetDateTime(dt.Rows[0]["DOJ"].ToString()).Month), Util.GetString(Util.GetDateTime(dt.Rows[0]["DOJ"].ToString()).Year));
                txtDOJ.Text = Util.GetString(Util.GetDateTime(dt.Rows[0]["DOJ"]).ToString("dd-MMM-yyyy"));
                string Address = "Popular Hospital," + System.Environment.NewLine + "N-10/60,A-2,D.L.W. ROAD,KAKARMATTA," + System.Environment.NewLine + "VARANASI-221004,UTTAR PRADESH-INDIA";


                txtAddress.Text = Address;
                txtAppointmentDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                AllLoadDate_Payroll pay = new AllLoadDate_Payroll();
                DateTime DOLDate = Util.GetDateTime(pay.getDateOfJoining(lblEmployeeID.Text));
                CalendarExtender1.StartDate = Util.GetDateTime(DOLDate.ToString("dd-MMM-yyyy"));
                lblGrade.Text = StockReports.ExecuteScalar("Select Grade from pay_designation_master pds inner join pay_employee_master pem on pds.Des_ID=pem.Desi_ID where pem.EmployeeID='" + lblEmployeeID.Text + "'");
                txtExpectations.Text = "";
                BindData();
            }
            else
            {
                pnlhide.Visible = false;
                clear();
            }
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtEmployeeID.Focus();
            txtAppointmentDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ViewState["ID"] = Session["ID"].ToString();
            btncancel.Visible = false;
            btnUpdate.Visible = false;
            btnSave.Visible = true;

            if (Request.QueryString["id"] != null)
            {
                txtAppointmentDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                lblDepartment.Visible = true;
                btncancel.Visible = true;
                btnUpdate.Visible = true;
                btnSave.Visible = false;
                tbl1.Visible = false;
                BindRecord();
            }
            CalendarExtender1.EndDate = DateTime.Now;
        }
        txtAppointmentDate.Attributes.Add("readonly", "readonly");
    }

    private void BindData()
    {
        EarningGrid.DataSource = StockReports.GetDataTable(" select rem.ID,Name,rem.CalType,rem.RemunerationType,ifnull(Amount,0)Amount,IF(Per_Cal_on<>'Basic',IFNULL(Per_Cal_Amt,0),0)Per_Cal_Amt,Per_Cal_on from (select ID,Name,CalType,RemunerationType,Sequence_No  from pay_Remuneration_master  where IsActive=1 and IsLoan=0  and IsInitial=0)rem left join pay_employeeremuneration emprem on rem.ID=emprem.TypeID and EmployeeID='" + lblEmployeeID.Text.Trim() + "' ORDER BY Sequence_No");
        EarningGrid.DataBind();
        txtTotalRemuneration.Text = ((TextBox)EarningGrid.Rows[0].FindControl("txtAmount")).Text;
    }

    private void clear()
    {
        lblDesignation.Text = "";
        lblDepartment.Text = "";
        lblName.Text = "";
        lblName.Text = "";
        txtTotalRemuneration.Text = "";
    }
}