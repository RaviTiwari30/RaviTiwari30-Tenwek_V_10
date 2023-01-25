using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Payroll_Manpower : System.Web.UI.Page
{
    //protected void btnSave_Click(object sender, EventArgs e)
    //{
    //    Save();
    //}



    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucReqDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txturgdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ucLeavingdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            AllLoadDate_Payroll.BindDepartmentPayroll(ddlDept);
            AllLoadDate_Payroll.BindDesignationPayroll(ddlDesig);
            AllLoadDate_Payroll.BindDesignationPayroll(ddlDesig_Requester);
            AllLoadDate_Payroll.BindJobType(ddlJobType);
            BindReportingPurpose();
            BindEducationQualification();
        }
    }

    private void BindReportingPurpose()
    {
        DataTable dt = StockReports.GetDataTable("Select ID,Name from pay_ReportingPurpose_Master where IsActive =1 order by Name");
        ddlReportingPurpose.DataSource = dt;
        ddlReportingPurpose.DataValueField = "ID";
        ddlReportingPurpose.DataTextField = "Name";
        ddlReportingPurpose.DataBind();
        ddlReportingPurpose.Items.Insert(0, new ListItem("Select", "0"));
    }
    private void BindEducationQualification()
    {
        DataTable dt = StockReports.GetDataTable("Select ID,Qualification from pay_qualification_master where ISActive=1 order by Qualification ");
        ddlEduQual.DataSource = dt;
        ddlEduQual.DataValueField = "ID";
        ddlEduQual.DataTextField = "Qualification";
        ddlEduQual.DataBind();
        ddlEduQual.Items.Insert(0, new ListItem("Select", "0"));

    }


    protected void Validation()
    {
        if (rdblist.SelectedIndex == 1 && ucLeavingdate.Text == "")
        {
            lblMsg.Text = "Select Leaving Date";
            return;
        }
        if (rdblist.SelectedIndex == 1 && txtReason.Text.Trim() == "")
        {
            lblMsg.Text = "Justify Increase needed";
            return;
        }
    }

    private void clear()
    {
        txtAreas.Text = "";
        ddlDept.SelectedIndex = 0;
        ddlDesig.SelectedIndex = 0;
        ddlDesig_Requester.SelectedIndex = 0;
        txtEmp.Text = "";
        // txtminedu.Text = "";
        txtReason.Text = "";
        // txtReporting.Text = "";
        txturgdate.Text = "";
        txtVac.Text = "";
        txtrequired.Text = "";
        //rdblist.ClearSelection();
        txturgdate.Visible = false;
        chkurg.Checked = false;
        ddlmin.ClearSelection();
        ddlmax.ClearSelection();
        // txtPurpose.Text = "";
        txtPositionInformation.Text = "";
        rdPosition.SelectedIndex = 0;
        txtDeptHead.Text = "";
        txtChiefOfficer.Text = "";
        txtComment.Text = "";
        txtExecutiveOfficer.Text = "";
    }

    //private void Save()
    //{
    //    lblMsg.Text = "";
    //    try
    //    {
    //        DateTime UrgentDate = Util.GetDateTime("0001-01-01");
    //        DateTime Leavingdate = Util.GetDateTime("0001-01-01");
    //        if (chkurg.Checked)
    //        {
    //            UrgentDate = Convert.ToDateTime(txturgdate.Text);
    //        }
    //        if (rdblist.SelectedIndex == 1)
    //        {
    //            Leavingdate = Convert.ToDateTime(ucLeavingdate.Text);
    //        }

    //        string Query = "INSERT INTO pay_manpower(RequestDate,TYPE,Department,Reason,VacNo,UrgentDate,Designation,ExistEmp,ReportingTo,MinEduQual,ResAreas,MinExp,MaxExp,Required,UserID,PurposeOfReporting,RequesterDesignation,EmployementType,PositionBudgeted,PositionInformation,DeptHead,CheafAdmin,CheafExecutive,COMMENT,Livingdate) " +
    //                   " VALUES('" + Util.GetDateTime(ucReqDate.Text).ToString("yyyy-MM-dd") + "','" + rdblist.SelectedItem.Text + "','" + ddlDept.SelectedItem.Text + "','" + txtReason.Text + "','" + Util.GetInt(txtVac.Text) + "' " +
    //                   " ,'" + Util.GetDateTime(UrgentDate).ToString("yyyy-MM-dd") + "','" + ddlDesig.SelectedItem.Text + "','" + txtEmp.Text + "','" + ddlReportingToEmp.SelectedItem.Text + "','" + ddlEduQual.SelectedItem.Text + "','" + txtAreas.Text + "', " +
    //        " Concat('" + ddlmin.SelectedValue + "','#','" + ddlexp1.SelectedValue + "'),Concat('" + ddlmax.SelectedValue + "','#','" + ddlexp2.SelectedValue + "'),'" + txtrequired.Text + "','" + Session["ID"].ToString() + "','" + ddlReportingPurpose.SelectedItem.Text + "','" + ddlDesig_Requester.SelectedItem.Text + "','" + ddlJobType.SelectedItem.Text + "', " +
    //        " '" + rdPosition.SelectedItem.Text + "','" + txtPositionInformation.Text.Trim() + "','" + txtDeptHead.Text.Trim() + "','" + txtChiefOfficer.Text.Trim() + "','" + txtExecutiveOfficer.Text.Trim() + "','" + txtComment.Text.Trim() + "','" + Util.GetDateTime(Leavingdate).ToString("yyyy-MM-dd") + "')";

    //        StockReports.ExecuteDML(Query);
    //        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);

    //        clear();
    //    }
    //    catch (Exception ex)
    //    {
    //        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
    //        ClassLog cl = new ClassLog();
    //        cl.errLog(ex);
    //        return;
    //    }
    //}

    [WebMethod]
    public static string getDeptTotalEmployee(string DeptID)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT COUNT(*)TotalEmployee FROM employee_master WHERE Dept_ID ='" + DeptID + "' AND IsActive=1"));
    }

    [WebMethod]
    public static string getDeptEmployeeList(string DeptID)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT EmployeeID,CONCAT(Title,'',NAME)NAME,(SELECT CONCAT(title,NAME) FROM employee_master em INNER JOIN pay_deptartment_master dm ON em.Dept_ID=dm.dept_ID AND em.EmployeeID=dm.deptheadid WHERE em.Dept_ID=" + DeptID + ")deptheadname FROM employee_master WHERE Dept_ID ='" + DeptID + "' AND IsActive=1"));
    }

    [WebMethod(EnableSession = true)]
    public static string SaveNewReportingPurpose(string Purpose)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM pay_ReportingPurpose_Master WHERE Name ='" + Purpose + "' "));
            if (count > 0)
                return "0";
            else
            {
                string s = "INSERT INTO pay_ReportingPurpose_Master(Name,CreatedBy) VALUES(@Name,@CreatedBy)";
                excuteCMD.DML(tnx, s, CommandType.Text, new
                {
                    Name = Purpose,
                    CreatedBy = HttpContext.Current.Session["ID"].ToString(),
                });
                tnx.Commit();
                return Util.GetString(StockReports.ExecuteScalar("SELECT MAX(ID) FROM pay_ReportingPurpose_Master"));
            }
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string SavePersonnelForm(reqdetail ReqDetail)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            string Query = "INSERT INTO pay_manpower(RequestDate,TYPE,Department,Reason,VacNo,UrgentDate,Designation,ExistEmp,ReportingTo,MinEduQual,ResAreas,MinExp,MaxExp,Required,UserID,PurposeOfReporting,RequesterDesignation,EmployementType,PositionBudgeted,PositionInformation,DeptHead,CheafAdmin,CheafExecutive,COMMENT,Livingdate,ForwardtoEmpID,MonthlyCTC,ReqforDeptID,ReqForDesigID,CentreID) ";
            Query += " Values(@RequestDate,@TYPE,@Department,@Reason,@VacNo,@UrgentDate,@Designation,@ExistEmp,@ReportingTo,@MinEduQual,@ResAreas,@MinExp,@MaxExp,@Required,@UserID,@PurposeOfReporting,@RequesterDesignation,@EmployementType,@PositionBudgeted,@PositionInformation,@DeptHead,@CheafAdmin,@CheafExecutive,@COMMENT,@Livingdate,@ForwardtoEmpID,@MonthlyCTC,@ReqforDeptID,@ReqForDesigID,@CentreID);SELECT @@identity;";
            var ID = excuteCMD.ExecuteScalar(tnx, Query, CommandType.Text, new
            {
                RequestDate = Util.GetDateTime(ReqDetail.ReqDate).ToString("yyyy-MM-dd"),
                TYPE = ReqDetail.ReqType,
                Department = ReqDetail.ReqDept,
                Reason = ReqDetail.AdditionReason,
                VacNo = ReqDetail.Vacancy,
                UrgentDate = Util.GetDateTime(ReqDetail.UrgentDate),
                Designation = ReqDetail.PositiontobeFilled,
                ExistEmp = ReqDetail.TotalEmp,
                ReportingTo = ReqDetail.ReportingTo,
                MinEduQual = ReqDetail.Qualif,
                ResAreas = ReqDetail.Area,
                MinExp = ReqDetail.MinExp,
                MaxExp = ReqDetail.MaxExp,
                Required = ReqDetail.Require,
                UserID = HttpContext.Current.Session["ID"].ToString(),
                PurposeOfReporting = ReqDetail.ReportingPurpose,
                RequesterDesignation = ReqDetail.ReqByDesig,
                EmployementType = ReqDetail.JobType,
                PositionBudgeted = ReqDetail.PosBudget,
                PositionInformation = ReqDetail.PosInfo,
                DeptHead = ReqDetail.DeptHead,
                CheafAdmin = ReqDetail.ChiefAdOfficer,
                CheafExecutive = ReqDetail.ChiefExcOficer,
                COMMENT = ReqDetail.Comment,
                Livingdate = ReqDetail.LeaveDate,
                ForwardtoEmpID = ReqDetail.Forwardto,
                MonthlyCTC = ReqDetail.MonthlyCTC,
                ReqforDeptID=ReqDetail.ReqDeptID,
                ReqForDesigID =ReqDetail.PositiontobeFilledID,
                CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"])
            });
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, reqID = ID,response = "Record Saved Successfully" });

        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public class reqdetail
    {
        public string ReqDate { get; set; }
        public string ReqType { get; set; }
        public string AdditionReason { get; set; }
        public string LeaveDate { get; set; }
        public string ReqDept { get; set; }
        public string ReqDeptID { get; set; }
        public string PositiontobeFilled { get; set; }
        public string PositiontobeFilledID { get; set; }
        public string ReqByDesig { get; set; }
        public string PosBudget { get; set; }
        public string PosInfo { get; set; }
        public string Vacancy { get; set; }
        public string TotalEmp { get; set; }
        public string UrgentDate { get; set; }
        public string ReportingTo { get; set; }
        public string ReportingPurpose { get; set; }
        public string DeptHead { get; set; }
        public string ChiefAdOfficer { get; set; }
        public string ChiefExcOficer { get; set; }
        public string Qualif { get; set; }
        public string QualifID { get; set; }
        public string Area { get; set; }
        public string Require { get; set; }
        public string MinExp { get; set; }
        public string JobType { get; set; }
        public string MaxExp { get; set; }
        public string Comment { get; set; }
        public string Forwardto { get; set; }
        public string MonthlyCTC { get; set; }
    }
}