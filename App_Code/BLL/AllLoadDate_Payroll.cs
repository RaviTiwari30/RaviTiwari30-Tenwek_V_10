using System.Data;
using System.Web.UI.WebControls;

/// <summary>
/// Summary description for Payroll_AllLoadDate
/// </summary>
public class AllLoadDate_Payroll
{
    public AllLoadDate_Payroll()
	{
		//
		// TODO: Add constructor logic here
		//
	}
    public static DataTable dtDepartmentPayroll()
    {
        string Department = "select Dept_ID,Dept_Name from Pay_deptartment_master where IsActive=1";
        return StockReports.GetDataTable(Department);
    }
    public static void BindDepartmentPayroll(DropDownList ddlObject)
    {
        DataTable dtData = dtDepartmentPayroll();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Dept_Name";
            ddlObject.DataValueField = "Dept_ID";
            ddlObject.DataBind();
            ddlObject.Items.Insert(0, new ListItem("Select", "0"));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }

    }
    public static void BindChkDepartmentPayroll(CheckBoxList chkObject)
    {
        DataTable dtData = dtDepartmentPayroll();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            chkObject.DataSource = dtData;
            chkObject.DataTextField = "Dept_Name";
            chkObject.DataValueField = "Dept_ID";
            chkObject.DataBind();
           
        }
        else
        {
            chkObject.DataSource = null;
            chkObject.DataBind();
        }

    }
    public static DataTable dtDesignationPayroll()
    {
        string Designation = "select Des_ID,Designation_Name from Pay_designation_master order by Designation_Name";
        return StockReports.GetDataTable(Designation);
    }
    public static void BindDesignationPayroll(DropDownList ddlObject)
    {
        DataTable dtData = dtDesignationPayroll();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Designation_Name";
            ddlObject.DataValueField = "Des_ID";
            ddlObject.DataBind();
            ddlObject.Items.Insert(0, new ListItem("Select", "0"));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }

    }
    public static void BindBloodgroupPayroll(DropDownList ddlObject)
    {
        ddlObject.DataSource = AllGlobalFunction.BloobGroup;
        ddlObject.DataBind();

    }
    public static DataTable dtTitlePayroll()
    {
        string Title = "select Title from pay_Title_master where IsActive=1 ";
        return StockReports.GetDataTable(Title);
    }
    public static void BindTitlePayroll(DropDownList ddlObject)
    {
        DataTable dtData = dtTitlePayroll();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Title";
            ddlObject.DataValueField = "Title";
            ddlObject.DataBind();
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }

    }
    public static DataTable dtRemunerationPayroll()
    {
        string Remuneration = "select ID,Name from pay_remuneration_master where IsActive=1 and IsLoan=0 and CalType='AMT' and RemunerationType='D'";
        return StockReports.GetDataTable(Remuneration);
    }
    public static void BindRemunerationPayroll(DropDownList ddlObject)
    {
        DataTable dtData = dtRemunerationPayroll();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Name";
            ddlObject.DataValueField = "ID";
            ddlObject.DataBind();
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }

    }
    public static DataTable dtAppraisalType()
    {
        string AppraisalType = "SELECT ID,NAME FROM pay_appraisaltype WHERE isActive=1";
        return StockReports.GetDataTable(AppraisalType);
    }
    public static void BindAppraisalType(DropDownList ddlObject)
    {
        DataTable dtData = dtAppraisalType();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Name";
            ddlObject.DataValueField = "ID";
            ddlObject.DataBind();
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }

    }
    public static DataTable dtEmployeePayroll()
    {
        string EmployeePayroll = "SELECT Employee_ID,NAME FROM Employee_master WHERE isActive=1";
        return StockReports.GetDataTable(EmployeePayroll);
    }
    public static void BindEmployeePayroll(DropDownList ddlObject)
    {
        DataTable dtData = dtEmployeePayroll();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Name";
            ddlObject.DataValueField = "Employee_ID";
            ddlObject.DataBind();
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }

    }
    public static DataTable dtGradePayroll()
    {
        string Grade = "SELECT ID,Grade FROM pay_Appraisal_Greading where IsActive=1";
        return StockReports.GetDataTable(Grade);
    }
    public static void BindGradePayroll(DropDownList ddlObject)
    {
        DataTable dtData = dtGradePayroll();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Grade";
            ddlObject.DataValueField = "ID";
            ddlObject.DataBind();

        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }

    }
    public static DataTable dtAppraisalStartDate()
    {
        string Grade = "SELECT ID,Date_Format(AppraisalStartDate,'%d %b %Y')AppraisalStartDate FROM pay_appraisal WHERE AppraisalStartDate IS  NOT NULL";
        return StockReports.GetDataTable(Grade);
    }
    public static void BindAppraisalStartDate(DropDownList ddlObject)
    {
        DataTable dtData = dtAppraisalStartDate();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "AppraisalStartDate";
            ddlObject.DataValueField = "ID";
            ddlObject.DataBind();
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }

    }
    public static DataTable dtBankNamePayroll()
    {
        string Grade = "SELECT Bank_ID,BankName FROM pay_BankMaster order by BankName asc";
        return StockReports.GetDataTable(Grade);
    }
    public static DataTable dtBankNamePayroll1()
    {
        string Grade = "SELECT Bank_ID,BankName FROM pay_BankMaster WHERE IsActive=1 order by BankName asc";
        return StockReports.GetDataTable(Grade);
    }
    public static void BindBankNamePayroll(DropDownList ddlObject)
    {
        DataTable dtData = dtBankNamePayroll();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "BankName";
            ddlObject.DataValueField = "Bank_ID";
            ddlObject.DataBind();
            ddlObject.Items.Insert(0, new ListItem("Select", "0"));

        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
            ddlObject.Items.Insert(0, new ListItem("Select", "0"));
        }

    }
    public static void BindBankNamePayroll1(DropDownList ddlObject)
    {
        DataTable dtData = dtBankNamePayroll1();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "BankName";
            ddlObject.DataValueField = "Bank_ID";
            ddlObject.DataBind();
            ddlObject.Items.Insert(0, new ListItem("Select", "0"));

        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
            ddlObject.Items.Insert(0, new ListItem("Select", "0"));
        }

    }
    public static DataTable dtBranchNamePayroll()
    {
        string Grade = "SELECT Branch_ID,BranchName FROM pay_BranchMaster WHERE IsActive=1 order by BranchName asc";
        return StockReports.GetDataTable(Grade);
    }
    public static void BindBranchNamePayroll(DropDownList ddlObject)
    {
        DataTable dtData = dtBranchNamePayroll();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "BranchName";
            ddlObject.DataValueField = "Branch_ID";
            ddlObject.DataBind();
            ddlObject.Items.Insert(0, new ListItem("Select", "0"));

        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }

    }
    public static void disableSubmitButton(Button objButton)
    {
        objButton.CausesValidation = false;
        string validationGroup = objButton.ValidationGroup;
        if (string.IsNullOrEmpty(validationGroup))
            objButton.Attributes.Add("onclick", "if (Page_ClientValidate()) {this.value=\"Processing...\";this.disabled=true;" + objButton.Page.ClientScript.GetPostBackEventReference(objButton, "").ToString() + "}");
        else
            objButton.Attributes.Add("onclick", "if (Page_ClientValidate(\"" + validationGroup + "\")) {this.value=\"Processing...\";this.disabled=true;" + objButton.Page.ClientScript.GetPostBackEventReference(objButton, "").ToString() + "}");
    }
    public static DataTable BindBranchBankPayroll(string BankID)
    {
        DataTable Branch = StockReports.GetDataTable("SELECT Branch_ID,BranchName FROM pay_BranchMaster WHERE Bank_id='" + BankID + "' And IsActive=1 order by BranchName asc");
        return Branch;
    }

    public static DataTable dtGradePay()
    {
        string Grade = "SELECT ID,Grade FROM pay_GradeMaster WHERE IsActive=1 order by Grade asc";
        return StockReports.GetDataTable(Grade);
    }
    public static void BindGradePay(DropDownList ddlObject)
    {
        DataTable dtData = dtGradePay();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Grade";
            ddlObject.DataValueField = "ID";
            ddlObject.DataBind();
            ddlObject.Items.Insert(0, new ListItem("Select", "0"));

        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }

    }

    public static DataTable dtAppraisal()
    {
        string Appraisal ="SELECT ID,Date_Format(AppraisalStartDate,'%d-%b-%Y')AppraisalStartDate FROM pay_appraisal WHERE AppraisalStartDate IS  NOT NULL  ";
        return StockReports.GetDataTable(Appraisal);
    }
    public static void BindAppraisal(DropDownList ddlObject)
    {
        DataTable dtData = dtAppraisal();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "AppraisalStartDate";
            ddlObject.DataValueField = "ID";
            ddlObject.DataBind();

        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }

    }
     public static DataTable dtLeave()
    {
        string Leave ="SELECT ID,NAME FROM pay_leavemaster WHERE IsActive=1";
        return StockReports.GetDataTable(Leave);
    }
    public static void BindLeaveType(DropDownList ddlObject)
    {
        DataTable dtData = dtLeave();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Name";
            ddlObject.DataValueField = "ID";
            ddlObject.DataBind();
           ddlObject.Items.Insert(0, new ListItem("Select", "0"));

        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }

    }
    public string getDateOfJoining(string EmployeeID)
    {
        string strQuery = "Select date_format(DOJ,'%d-%b-%Y')DOJ from pay_employee_master Where Employee_ID = '" + EmployeeID + "'";
        string DOJ = StockReports.ExecuteScalar(strQuery).ToString();
        return DOJ;
    }
    
     public static void BindJobType(DropDownList ddlObject)
    {
        DataTable dtData = StockReports.GetDataTable("select Name,ID from Pay_JobType where IsActive=1 order by Name ");
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Name";
            ddlObject.DataValueField = "ID";
            ddlObject.DataBind();
            ddlObject.Items.Insert(0, new ListItem("Select", "0"));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }
}