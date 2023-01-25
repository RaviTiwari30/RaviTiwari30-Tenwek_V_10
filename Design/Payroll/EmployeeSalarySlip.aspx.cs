using System;
using System.Data;
using System.Web.UI;

public partial class Design_Payroll_EmployeeSalarySlip : System.Web.UI.Page
{
    protected void btnPrint_Click(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        EmployeeWise();
    }

    protected void EmployeeWise()
    {
        string Query = "select mst.ID,emp.EmployeeID,emp.Name,House_No Address,DATE_FORMAT(DOB,'%d %b %Y')DOB,DATE_FORMAT(DOJ,'%d-%b-%Y')DOJ,FatherName,ESI_No,EPF_No,if(PF_No='','',PF_No)PF_No,Email,Mobile,mst.Dept_Name,mst.Desi_Name,GR_ID_NO,LIC_No,EDLI_NO_Reg_No,PF_No,if(mst.BankAccountNo='','Cash',mst.BankAccountNo)BankAccountNo,bm.BankName,bm.BranchName,  " +
            " LetterNO,Category,(SELECT SUM(ActualAmount) FROM pay_empsalary_detail det WHERE RemunerationType='E' AND det.MasterID=mst.ID GROUP BY MasterID)GrossSalary from pay_employee_master emp inner join (select ID,EmployeeID,PayableDays,Dept_Name,Dept_ID,Desi_ID,Desi_Name,BankAccountNo,SalaryMonth,ArrearMonth,SalaryType,BankID,branchID from pay_empsalary_master where Month(SalaryMonth)=Month('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "' ) and Year(SalaryMonth)=Year('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "')  and TotalEarning>0) mst on emp.EmployeeID=mst.EmployeeID inner join pay_empsalary_detail det on mst.ID=det.MasterID and TypeID=1 " +
            " inner join pay_attendance att on att.EmployeeID=emp.EmployeeID and Month(Attendance_To)=Month('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "' ) and Year(Attendance_To)=Year('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') LEFT OUTER JOIN pay_branchmaster bm ON mst.branchID=bm.Branch_ID ";
        if (ViewState["PayrollEmployeeID"].ToString() != null && ViewState["PayrollEmployeeID"].ToString() != "")
        {
            Query += "where emp.EmployeeID='" + ViewState["PayrollEmployeeID"].ToString() + "'";
        }
        Query += "order by emp.EmployeeID ";

        DataTable dt = StockReports.GetDataTable(Query);

        if (dt.Rows.Count > 0)
        {
            DataTable dtEmployeerPF = StockReports.GetDataTable(" SELECT Emp_PF FROM pay_pf_detail WHERE EmployeeID='" + ViewState["PayrollEmployeeID"].ToString() + "' AND MONTH(SalaryMonth)=MONTH('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') AND YEAR(SalaryMonth)=YEAR('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "')");
            if (dtEmployeerPF == null && dtEmployeerPF.Rows.Count == 0)
            {
                dtEmployeerPF.Rows[0]["Emp_PF"] = "0";
            }
            dt.Columns.Add(new DataColumn("EMP_PF"));
            dt.Rows[0]["EMP_PF"] = dtEmployeerPF.Rows[0]["Emp_PF"].ToString();
        }

        DataSet ds = new DataSet();

        Query = "select MasterID,det.EmployeeID,TypeID,TypeName,sum(Amount)Amount,RemunerationType,TransactionType from pay_empsalary_detail det inner join pay_empsalary_master mst on mst.ID=det.MasterID where  Month(mst.SalaryMonth)=Month('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') and year(mst.SalaryMonth)=Year('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') ";
        if (ViewState["PayrollEmployeeID"].ToString() != null && ViewState["PayrollEmployeeID"].ToString() != "")
        {
            Query += " and det.EmployeeID='" + ViewState["PayrollEmployeeID"].ToString() + "'";
        }
        Query += " and IsPost=1  group by TypeID,EmployeeID,SalaryType,mst.ID order by EmployeeID,TypeID";
        DataTable dt1 = StockReports.GetDataTable(Query);

        Query = "select ERound,ID,mst.EmployeeID,SalaryMonth,Date_format(ArrearMonth,'%b %Y')ArrearMonth,SalaryType,TotalEarning,TotalDeduction,NetPayable,SlipNo,PayableDays from pay_empsalary_master mst  where IsPost=1 and Month(SalaryMonth)=Month('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') and Year(SalaryMonth)=Year('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') ";
        if (ViewState["PayrollEmployeeID"].ToString() != null && ViewState["PayrollEmployeeID"].ToString() != "")
        {
            Query += "and mst.EmployeeID='" + ViewState["PayrollEmployeeID"].ToString() + "'";
        }

        DataTable dt3 = StockReports.GetDataTable(Query);

        Query = "SELECT MasterID,mst.EmployeeID,GrossSalary,WorkingHrs,OverTimeDays,OverTimeHours,OverTimeAmount,OverTimeTax,OverTimeNetPay,ActualOverTimeHours FROM pay_overtime pao INNER JOIN pay_empsalary_master mst ON mst.ID=pao.MasterID  WHERE IsPost=1 and MONTH(mst.SalaryMonth)=MONTH('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') AND YEAR(mst.SalaryMonth)=YEAR('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') ";
        if (ViewState["PayrollEmployeeID"].ToString() != null && ViewState["PayrollEmployeeID"].ToString() != "")
        {
            Query += "and mst.EmployeeID='" + ViewState["PayrollEmployeeID"].ToString() + "'";
        }

        DataTable dt4 = StockReports.GetDataTable(Query);

        //For Staff Loan
        Query = "";
        //Query = "SELECT Emp.EmployeeID,emp.Name,Adv_ID,Amount,ReceiveAmount,(Amount-ReceiveAmount)Balance,adv.EntDate FROM pay_advancemaster adv INNER JOIN pay_employee_master emp ON adv.EmployeeID=emp.EmployeeID  WHERE Amount>ReceiveAmount  AND STATUS<>2 ";
        Query = "SELECT t.EmployeeID,t.Name,t.Adv_ID,t.Amount,t.ReceiveAmt ReceiveAmount,(t.Amount-t.ReceiveAmt)Balance FROM (";
        Query += "SELECT Emp.EmployeeID,emp.Name,Adv_ID,Amount,ReceiveAmount,(Amount-ReceiveAmount)Balance,(SELECT SUM(amount) FROM pay_advancedetail ";
        Query += "WHERE EmployeeID='" + ViewState["PayrollEmployeeID"].ToString() + "'";
        Query += "AND adv_id=adv.adv_id and DATE(EMIMonth)<='" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM") + "-" + DateTime.DaysInMonth(Util.GetInt(Util.GetDateTime(SalaryMonth.Text).ToString("yyyy")), Util.GetInt(Util.GetDateTime(SalaryMonth.Text).ToString("MM"))) + "')ReceiveAmt,adv.EntDate FROM pay_advancemaster adv ";
        Query += "INNER JOIN pay_employee_master emp ON adv.EmployeeID=emp.EmployeeID  WHERE Amount>ReceiveAmount  ";
        Query += "AND STATUS<>2 and ReceiveAmount<>0";
        if (ViewState["PayrollEmployeeID"].ToString() != "")
        {
            Query += " AND Emp.EmployeeID='" + ViewState["PayrollEmployeeID"].ToString() + "')t";
        }
        DataTable dt5 = StockReports.GetDataTable(Query);

        ds.Tables.Add(dt.Copy());
        ds.Tables[0].TableName = "Employee";
        ds.Tables.Add(dt1.Copy());
        ds.Tables[1].TableName = "Remuneration";

        ds.Tables.Add(dt3.Copy());
        ds.Tables[2].TableName = "SalaryDetail";
        ds.Tables.Add(dt4.Copy());
        ds.Tables[3].TableName = "OverTimeDetail";
        ds.Tables.Add(dt5.Copy());
        ds.Tables[4].TableName = "StaffLoan";

        if (ds.Tables[0].Rows.Count > 0 && ds.Tables[1].Rows.Count > 0)
        {
            DataColumn dc = new DataColumn("OverTimeExist");
            DataColumn dc1 = new DataColumn("StaffLoanExit");
            ds.Tables[2].Columns.Add(dc);
            ds.Tables[2].Columns.Add(dc1);
            for (int i = 0; i < ds.Tables[2].Rows.Count; i++)
            {
                DataRow[] row = ds.Tables[3].Select("MasterID='" + ds.Tables[2].Rows[i]["ID"].ToString() + "'");
                if (row.Length > 0)
                {
                    ds.Tables[2].Rows[i]["OverTimeExist"] = "1";
                }
                else
                {
                    ds.Tables[2].Rows[i]["OverTimeExist"] = "0";
                }
                if (dt5 != null && dt5.Rows.Count > 0)
                {
                    ds.Tables[2].Rows[i]["StaffLoanExit"] = "1";
                }
                else
                {
                    ds.Tables[2].Rows[i]["StaffLoanExit"] = "0";
                }
            }
            //ds.WriteXmlSchema("E:/SalarySlipNew.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "NewSalarySlip";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Payroll/Report/Commonreport.aspx');", true);
        }
        else
        {
            lblmsg.Text = "Record Not Found";
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            SalaryMonth.Text = DateTime.Now.ToString("MMM-yyyy");
            ViewEmployeeType();
        }
        SalaryMonth.Attributes.Add("readonly", "true");
    }

    protected void ViewEmployeeType()
    {
        string PayrollEmployeeID = StockReports.ExecuteScalar(" SELECT IFNULL(PayrollEmployeeID,'')PayrollEmployeeID FROM Employee_master WHERE EmployeeID='" + Session["ID"].ToString() + "' ");
        ViewState["PayrollEmployeeID"] = PayrollEmployeeID;
        if (PayrollEmployeeID == "")
        {
            lblmsg.Text = "Your ID is not mapped please contact to IT Department";
            btnPrint.Enabled = false;
            return;
        }
    }
}