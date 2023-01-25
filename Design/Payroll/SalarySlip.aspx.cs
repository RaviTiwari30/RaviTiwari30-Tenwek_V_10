using System;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Payroll_SalarySlip : System.Web.UI.Page
{
    protected void AllDeptSummary()
    {
        string query = " select TYpeName ,Sum(Amount)Debit from pay_empsalary_detail det inner join (select SalaryMonth,ID,EmployeeID from pay_empsalary_master where IsPost=1 and Month(SalaryMonth)=Month('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') and Year(SalaryMonth)=Year('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "')) smst on smst.ID=det.MasterID where RemunerationType='E' group by TypeID ";

        DataTable dt1 = StockReports.GetDataTable(query);
        // dt1.Rows.Clear();

        query = "select TYpeName ,Sum(Amount)Credit from pay_empsalary_detail det inner join (select SalaryMonth,ID,EmployeeID from pay_empsalary_master where  IsPost=1 and Month(SalaryMonth)=Month('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') and Year(SalaryMonth)=Year('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "')) smst on smst.ID=det.MasterID inner join pay_remuneration_master rem on rem.ID=det.TypeID where det.RemunerationType='D' group by det.TypeID";
        DataTable dt2 = StockReports.GetDataTable(query);
        //dt2.Rows.Clear();
        query = "select  count(distinct(EmployeeID))Emp,Sum(ERound)ERound,SalaryMonth,sum(TotalEarning)TotalEarning,sum(TotalDeduction)TotalDeduction,sum(NetPayable)NetPayable,(select Name from employee_master where Employee_ID=UserID)User from pay_empsalary_master where  IsPost=1 and Month(SalaryMonth)=Month('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') and Year(SalaryMonth)=Year('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') group by Month(SalaryMonth),Year(SalaryMonth)";
        DataTable dt3 = StockReports.GetDataTable(query);
        dt3.Columns.Add(new DataColumn("UserID"));
        //dt3.Rows[0]["UserID"] = Session["ID"].ToString();

        DataSet ds = new DataSet();
        ds.Tables.Add(dt1.Copy());
        ds.Tables[0].TableName = "Earning";
        ds.Tables.Add(dt2.Copy());
        ds.Tables[1].TableName = "Deduction";
        ds.Tables.Add(dt3.Copy());
        ds.Tables[2].TableName = "Total";

        //lblmsg.Text = ds.Tables[0].Rows.Count + " Record Found";
        if (ds.Tables[0].Rows.Count > 0 && ds.Tables[1].Rows.Count > 0 && ds.Tables[2].Rows.Count > 0)
        {
            //ds.WriteXmlSchema("C:/AllDepartmentSalary.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "All_Dept_SalaryDetail";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Payroll/Report/Commonreport.aspx');", true);
        }
    }

    protected void BankLetterFORExcel()
    {
        //string query = " select smst.EmployeeID,smst.Name,emp.BankID,smst.BankAccountNo,smst.NetPayable from (  " +
        //" select Employee_ID,Name,BankAccountNo,FatherName,LetterNo,BankID from pay_employee_master )emp " +
        //" inner join (select * from pay_empsalary_master where IsPost=1 and Month(SalaryMonth)=Month('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') and Year(SalaryMonth)=Year('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') and BankAccountNo<>'') smst on emp.Employee_ID=smst.EmployeeID";

        //if (txtLetterNo.Text.Trim() != "")
        //{
        //    query += " where LetterNo='" + txtLetterNo.Text.Trim() + "'";
        //}
        //query += " Order by smst.EmployeeID";
        //DataTable dt1 = StockReports.GetDataTable(query);
        string query = " select concat(bra.BankName,'-',bra.BranchName)Branch,bra.BranchCode,bra.BankName,bra.BankCode,smst.Name,smst.BankAccountNo as AccountNumber,'" + Util.GetDateTime(SalaryMonth.Text).ToString("MMMM-yyyy") + "' Description,smst.NetPayable as Amount from (  " +
        " select Employee_ID,Name,BankAccountNo,FatherName,LetterNo,BankID,BranchID from pay_employee_master )emp " +
        " inner join (select * from pay_empsalary_master where IsPost=1 and Month(SalaryMonth)=Month('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') and Year(SalaryMonth)=Year('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') and BankAccountNo<>'') smst on emp.Employee_ID=smst.EmployeeID" +
        " INNER JOIN pay_branchmaster bra ON bra.Branch_ID=emp.branchid ";
        if (ddlBankName.SelectedIndex > 0)
        {
            query += " and emp.BankID='" + ddlBankName.SelectedItem.Value + "' ";
        }
        query += " Order by bra.BankName";
        DataTable dt1 = StockReports.GetDataTable(query);
        if (dt1.Rows.Count > 0)
        {
            dt1.Columns["Amount"].DataType = typeof(decimal);
            DataRow TotalRow = dt1.NewRow();
            for (int i = 5; i < dt1.Columns.Count; i++)
            {
                if (dt1.Columns[i].DataType == typeof(decimal))
                {
                    TotalRow[dt1.Columns[i].ColumnName] = dt1.Compute("sum([" + dt1.Columns[i].ColumnName + "])", "");
                }
            }
            dt1.Rows.Add(TotalRow);
        }

        DataSet ds = new DataSet();

        ds.Tables.Add(dt1.Copy());
        ds.Tables[0].TableName = "BankLetter";

        //lblmsg.Text = ds.Tables[0].Rows.Count + " Record Found";
        if (ds.Tables[0].Rows.Count == 0)
        {
            return;
        }
        ////ds.Tables[0].Columns.Add(new DataColumn("AmountWord"));
        //DataColumn dc = new DataColumn("AmountToWord");
        //dc.DefaultValue = changeNumericToWords(Convert.ToInt32(ds.Tables[0].Compute("sum(NetPayable)", "")));
        //ds.Tables[0].Columns.Add(dc);

        Session["CustomData"] = ds.Tables[0];
        if (ds.Tables[0].Rows.Count > 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('../../Design/Payroll/CustomReportForExport.aspx');", true);
        }
        //ds.Tables[0].Rows[0]["AmountWord"] = changeNumericToWords(Convert.ToInt32(ds.Tables[0].Compute("sum(NetPayable)", "")));

        //ds.WriteXmlSchema(@"C:\BankLetter.xml");
        // Session["ds"] = ds;
        //Session["ReportName"] = "BankLetter";
        //ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Payroll/Report/Commonreport.aspx');", true);
    }

    protected void BankLetterNo()
    {
        string query = " select smst.EmployeeID,smst.Name,smst.BankAccountNo,smst.SalaryMonth,emp.FatherName,smst.NetPayable,emp.LetterNo,emp.BankID,emp.BankID,emp.BranchID,bra.BankName,bra.BranchName,bra.BankCode,bra.BranchCode from (  " +
        " select Employee_ID,Name,BankAccountNo,FatherName,LetterNo,BankID,BranchID from pay_employee_master )emp " +
        " inner join (select * from pay_empsalary_master where IsPost=1 and Month(SalaryMonth)=Month('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') and Year(SalaryMonth)=Year('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') and BankAccountNo<>'') smst on emp.Employee_ID=smst.EmployeeID" +
        " INNER JOIN pay_branchmaster bra ON bra.Branch_ID=emp.branchid ";
        if (ddlBankName.SelectedIndex > 0)
        {
            query += " and emp.BankID='" + ddlBankName.SelectedItem.Value + "' ";
        }
        query += " Order by smst.EmployeeID";
        DataTable dt1 = StockReports.GetDataTable(query);

        DataSet ds = new DataSet();

        ds.Tables.Add(dt1.Copy());
        ds.Tables[0].TableName = "BankLetter";

        //lblmsg.Text = ds.Tables[0].Rows.Count + " Record Found";
        if (ds.Tables[0].Rows.Count == 0)
        {
            return;
        }
        ds.Tables[0].Columns.Add(new DataColumn("AmountWord"));
        DataColumn dc = new DataColumn("AmountToWord");
        dc.DefaultValue = changeNumericToWords(Convert.ToInt32(ds.Tables[0].Compute("sum(NetPayable)", "")));
        ds.Tables[0].Columns.Add(dc);
        //ds.Tables[0].Rows[0]["AmountWord"] = changeNumericToWords(Convert.ToInt32(ds.Tables[0].Compute("sum(NetPayable)", "")));

        // ds.WriteXmlSchema(@"C:\BankLetter.xml");
        Session["ds"] = ds;
        Session["ReportName"] = "BankLetter";
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Payroll/Report/Commonreport.aspx');", true);
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        if (RadioButtonList1.SelectedItem.Text == "Word")
        {
            Session["PrintType"] = "ExpToWord";
        }
        else
        {
            Session["PrintType"] = "ExpToPDF";
        }

        if (rbtnReportType.SelectedIndex == 0)
        {
            EmployeeWise();
        }
        else if (rbtnReportType.SelectedIndex == 1)
        {
            DepartmentWiseEmp();
        }
        else if (rbtnReportType.SelectedIndex == 2)
        {
            DepartmentWise();
        }
        else if (rbtnReportType.SelectedIndex == 3)
        {
            AllDeptSummary();
        }
        else if (rbtnReportType.SelectedIndex == 4)
        {
            BankLetterNo();
        }
        else if (rbtnReportType.SelectedIndex == 5)
        {
            BankLetterFORExcel();
        }
        else if (rbtnReportType.SelectedIndex == 6)
        {
            CashSalaryDetail();
        }
        else if (rbtnReportType.SelectedIndex == 7)
        {
            SalarySheetExcel();
        }
        else if (rbtnReportType.SelectedIndex == 8)
        {
            SalarySheet();
        }
        else if (rbtnReportType.SelectedIndex == 9)
        {
            pay_ClassSummary();
        }
        else if (rbtnReportType.SelectedIndex == 10)
        {
            pay_ClassSummaryExcel();
        }
        HttpCookie cookies = new HttpCookie("Format");
        cookies["Format"] = RadioButtonList1.SelectedItem.Value;
        Response.Cookies.Add(cookies);

        //Request.QueryString["a"] = "";
        //Request.QueryString.Add("Format", "Word");
    }

    protected void CashSalaryDetail()
    {
        string query = "  select smst.EmployeeID,smst.Name,smst.BankAccountNo,smst.SalaryMonth,emp.FatherName,smst.NetPayable,emp.LetterNo from ( " +
       " select Employee_ID,Name,BankAccountNo,FatherName,LetterNo from pay_employee_master )emp " +
       " inner join (select * from pay_empsalary_master where IsPost=1 and Month(SalaryMonth)=Month('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') and Year(SalaryMonth)=Year('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "')  and BankAccountNo='') smst on emp.Employee_ID=smst.EmployeeID left join pay_unpayedsalary up  on up.MasterID=smst.ID where MasterID is null  order by Employee_ID";

        DataTable dt1 = StockReports.GetDataTable(query);

        DataSet ds = new DataSet();

        ds.Tables.Add(dt1.Copy());
        ds.Tables[0].TableName = "CashSalaryDetail";
        //ds.WriteXmlSchema("C:/CashSalaryDetail.xml");
        //lblmsg.Text = ds.Tables[0].Rows.Count + " Record Found";
        if (ds.Tables[0].Rows.Count == 0)
        {
            return;
        }
        Session["ds"] = ds;
        Session["ReportName"] = "CashSalaryDetail";
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Payroll/Report/Commonreport.aspx');", true);
    }

    protected void DepartmentWise()
    {
        string query = " select TypeID,TypeName,Round(sum(Amount),2)Amount,smst.Dept_Name,smst.Dept_ID from  pay_empsalary_detail det inner join pay_employee_master mst " +
        " on mst.Employee_ID=det.EmployeeID inner join (select SalaryMonth,ID,EmployeeID,Dept_Name,Dept_ID from pay_empsalary_master where Month(SalaryMonth)=Month('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') and Year(SalaryMonth)=Year('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') and IsPost=1 )  smst on smst.ID=det.MasterID where RemunerationType='E' group by TypeID,Dept_ID order by Dept_ID,TypeID ";
        DataTable dt1 = StockReports.GetDataTable(query);

        query = "select TypeID,TypeName,Round(sum(Amount),2)Amount,smst.Dept_Name,smst.Dept_ID from  pay_empsalary_detail det inner join pay_employee_master mst " +
        " on mst.Employee_ID=det.EmployeeID inner join (select SalaryMonth,ID,EmployeeID,Dept_Name,Dept_ID from pay_empsalary_master where Month(SalaryMonth)=Month('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "')  and Year(SalaryMonth)=Year('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') and IsPost=1)  smst on smst.ID=det.MasterID where RemunerationType='D'  group by TypeID,Dept_ID order by Dept_ID,TypeID ";
        DataTable dt2 = StockReports.GetDataTable(query);

        query = "select mst.SalaryMonth,Count(distinct(EmployeeID))Emp,mst.Dept_Name,mst.Dept_ID from  pay_empsalary_master mst inner join pay_employee_master emp on emp.Employee_ID=mst.EmployeeID where  IsPost=1  and Month(mst.SalaryMonth)=Month('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "')  and Year(SalaryMonth)=Year('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') ";
        if (ddlDepartment.SelectedIndex > 0)
        {
            query += " and mst.Dept_ID=" + ddlDepartment.SelectedItem.Value + " ";
        }
        query += " group by mst.Dept_ID order by mst.Dept_ID";

        DataTable dt3 = StockReports.GetDataTable(query);

        System.Text.StringBuilder sb = new System.Text.StringBuilder();
        sb.Append(" select * from (select sum(Deduction)Deduction,Dept_ID from ( ");
        sb.Append(" select sum(Amount)Deduction,mst.EmployeeID,mst.Dept_ID,mst.ERound from pay_empsalary_detail det inner join pay_empsalary_master mst on mst.ID=det.MasterID and  Month(mst.SalaryMonth)=Month('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "')  and Year(mst.SalaryMonth)=Year('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') and IsPost=1 ");
        sb.Append(" and det.RemunerationType='D' inner join pay_employee_master emp on emp.Employee_ID=mst.EmployeeID where  mst.TotalEarning>0 ");
        sb.Append(" group by  mst.ID)aa group by Dept_ID)Ded ");
        sb.Append(" inner join  ");
        sb.Append(" (select Round(sum(Earning),2)Earning,Dept_ID,sum(ERound),count(distinct(EmployeeID))Emp from ( ");
        sb.Append(" select sum(Amount)Earning,mst.EmployeeID,mst.Dept_ID,mst.ERound from pay_empsalary_detail det inner join pay_empsalary_master mst on mst.ID=det.MasterID and  Month(mst.SalaryMonth)=Month('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "')  and Year(mst.SalaryMonth)=Year('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') and IsPost=1 ");
        sb.Append(" and det.RemunerationType='E' inner join pay_employee_master emp on emp.Employee_ID=mst.EmployeeID where  mst.TotalEarning>0  ");
        sb.Append(" group by  mst.ID)aa group by Dept_ID)Earn ");
        sb.Append(" on Earn.Dept_ID=Ded.Dept_ID ");
        sb.Append("LEFT JOIN ");
        sb.Append("(SELECT Dept_ID,SUM(ROUND(Emp_PF,2))Emp_PF,SUM(ROUND(Basic,2)+ROUND(Emp_PF,2))EmpCost FROM pay_pf_detail pf INNER JOIN pay_empsalary_master mst ON mst.id=pf.MasterID");
        sb.Append(" WHERE    Month(mst.SalaryMonth)=Month('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "')  and Year(mst.SalaryMonth)=Year('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') ");
        sb.Append("  AND IsPost=1  AND  mst.TotalEarning>0 ");
        sb.Append(" GROUP BY  Dept_ID)pf ON pf.Dept_ID= Ded.Dept_ID ");
        DataTable dt4 = StockReports.GetDataTable(sb.ToString());

        DataSet ds = new DataSet();
        ds.Tables.Add(dt1.Copy());
        ds.Tables[0].TableName = "Earning";
        ds.Tables.Add(dt2.Copy());
        ds.Tables[1].TableName = "Deduction";
        ds.Tables.Add(dt3.Copy());
        ds.Tables[2].TableName = "Department";
        ds.Tables.Add(dt4.Copy());
        ds.Tables[3].TableName = "TotalEarn_Deduct";
        // ds.WriteXmlSchema("D:/DeptWiseSalary.xml");
        //lblmsg.Text = ds.Tables[0].Rows.Count + " Record Found";
        if (ds.Tables[0].Rows.Count > 0 && ds.Tables[1].Rows.Count > 0 && ds.Tables[2].Rows.Count > 0 && ds.Tables[3].Rows.Count > 0)
        {
            Session["ds"] = ds;
            Session["ReportName"] = "DeptWiseSalary";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Payroll/Report/Commonreport.aspx');", true);
        }
    }

    protected void DepartmentWiseEmp()
    {
        string query = "select EmployeeID,mst.name,mst.Dept_ID,mst.Dept_name,mst.Desi_ID,mst.Desi_Name,SalaryType,SalaryMonth,mst.TotalEarning,mst.TotalDeduction,mst.NetPayable,SlipNo,PayableDays from pay_empsalary_master mst  " +
        "inner join pay_employee_master emp on emp.Employee_ID=mst.EmployeeID where IsPost=1 and Month(SalaryMonth)=Month('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') and Year(SalaryMonth)=Year('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "')";
        DataTable dt = StockReports.GetDataTable(query);
        DataSet ds = new DataSet();
        ds.Tables.Add(dt.Copy());
        ds.Tables[0].TableName = "EmpDetail";
        if (dt.Rows.Count > 0)
        {
            //ds.WriteXmlSchema("C:/DeptWiseEmpSalary.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "DeptWiseEmpSalary";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Payroll/Report/Commonreport.aspx');", true);
        }
    }

    protected void DepartmentWiseSalarySlip()
    {
        string Query = "select mst.ID,emp.Employee_ID,emp.Name,House_No Address,DATE_FORMAT(DOB,'%d %b %Y')DOB,DATE_FORMAT(DOJ,'%d %b %Y')DOJ,FatherName,ESI_No,EPF_No,PAN_No,Email,Mobile,mst.Dept_Name,mst.Desi_Name,mst.Dept_ID,GR_ID_NO,LIC_No,EDLI_NO_Reg_No,if(PF_No='','',PF_No)PF_No,if(mst.BankAccountNo='','Cash',mst.BankAccountNo)BankAccountNo,  " +
        " LetterNO,Category,Round(Amount*if(SalaryType='S',day(Last_day(dATE(SalaryMonth))),day(Last_day(DATE(ArrearMonth))))/mst.PayableDays) Amount from pay_employee_master emp inner join (select ID,EmployeeID,PayableDays,Dept_Name,Dept_ID,Desi_ID,Desi_Name,BankAccountNo,SalaryMonth,ArrearMonth,SalaryType from pay_empsalary_master where Month(SalaryMonth)=Month('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "' ) and Year(SalaryMonth)=Year('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "')  and TotalEarning>0) mst on emp.Employee_ID=mst.EmployeeID inner join pay_empsalary_detail det on mst.ID=det.MasterID and TypeID=1 " +
            //" LetterNO,Category,Round(Amount*WorkDays/mst.PayableDays) Amount from pay_employee_master emp inner join (select ID,EmployeeID,PayableDays,Dept_Name,Dept_ID,Desi_ID,Desi_Name,BankAccountNo from pay_empsalary_master where Month(SalaryMonth)=Month('" +Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") +"' ) and Year(SalaryMonth)=Year('" +Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") +"')  and TotalEarning>0) mst on emp.Employee_ID=mst.EmployeeID inner join pay_empsalary_detail det on mst.ID=det.MasterID and TypeID=1 " +
        " inner join pay_attendance att on att.EmployeeID=emp.Employee_ID and Month(Attendance_To)=Month('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "' ) and Year(Attendance_To)=Year('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "')";

        //string Query = " select mst.ID,emp.Employee_ID,Name,House_No Address,DATE_FORMAT(DOB,'%d %b %Y')DOB,DATE_FORMAT(DOJ,'%d %b %Y')DOJ,FatherName,ESI_No,EPF_No,PAN_No,Email,Mobile,Dept_Name,Dept_ID,Desi_Name,GR_ID_NO,LIC_No,EDLI_NO_Reg_No,PF_No,BankAccountNo, " +
        //    " LetterNO,Category,Amount from pay_employee_master emp inner join (select ID,EmployeeID from pay_empsalary_master where Month(SalaryMonth)=Month('" +Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") +"' ) and Year(SalaryMonth)=Year('" +Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") +"')  and TotalEarning>0) mst on emp.Employee_ID=mst.EmployeeID inner join pay_employeeremuneration rem on mst.EmployeeID=rem.Employee_ID and rem.TypeID=1  ";

        if (ddlDepartment.SelectedIndex > 0)
        {
            Query += " and mst.Dept_ID=" + ddlDepartment.SelectedItem.Value + " ";
        }
        Query += "order by mst.Dept_ID,emp.Employee_ID,mst.ID";
        DataTable dt = StockReports.GetDataTable(Query);
        DataSet ds = new DataSet();
        //ds.Tables.Add(dt.Copy());
        Query = "select MasterID,det.EmployeeID,TypeID,TypeName,sum(Amount)Amount,RemunerationType,TransactionType from pay_empsalary_detail det inner join pay_empsalary_master mst on mst.ID=det.MasterID where RemunerationType='E' and Month(mst.SalaryMonth)=Month('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') and Year(mst.SalaryMonth)=Year('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') and IsPost=1  ";
        if (ddlDepartment.SelectedIndex > 0)
        {
            Query += " and mst.Dept_ID=" + ddlDepartment.SelectedItem.Value + " ";
        }
        Query += " group by TypeID,EmployeeID,SalaryType,mst.ID  order by EmployeeID,TypeID";

        DataTable dt1 = StockReports.GetDataTable(Query);
        Query = "select MasterID,det.EmployeeID,TypeID,TypeName,sum(Amount)Amount,RemunerationType,TransactionType from pay_empsalary_detail det inner join pay_empsalary_master mst on mst.ID=det.MasterID where RemunerationType='D' and Month(mst.SalaryMonth)=Month('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') and Year(mst.SalaryMonth)=Year('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') and IsPost=1  ";
        if (ddlDepartment.SelectedIndex > 0)
        {
            Query += " and mst.Dept_ID=" + ddlDepartment.SelectedItem.Value + " ";
        }
        Query += "group by TypeID,EmployeeID,SalaryType,mst.ID  order by EmployeeID,TypeID";

        DataTable dt2 = StockReports.GetDataTable(Query);
        Query = "select  ERound,ID,mst.EmployeeID,SalaryMonth,Date_format(ArrearMonth,'%b %Y')ArrearMonth,SalaryType,TotalEarning,TotalDeduction,NetPayable,SlipNo,PayableDays from pay_empsalary_master mst  where IsPost=1 and Month(SalaryMonth)=Month('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') and Year(SalaryMonth)=Year('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "')";
        if (ddlDepartment.SelectedIndex > 0)
        {
            Query += " and mst.Dept_ID=" + ddlDepartment.SelectedItem.Value + " ";
        }
        Query += " order by EmployeeID,mst.ID";
        DataTable dt3 = StockReports.GetDataTable(Query);
        ds.Tables.Add(dt.Copy());
        ds.Tables[0].TableName = "Employee";
        ds.Tables.Add(dt1.Copy());
        ds.Tables[1].TableName = "Earning";
        ds.Tables.Add(dt2.Copy());
        ds.Tables[2].TableName = "Deduction";
        ds.Tables.Add(dt3.Copy());
        ds.Tables[3].TableName = "SalaryDetail";

        //lblmsg.Text = ds.Tables[0].Rows.Count + " Record Found";

        if (ds.Tables[0].Rows.Count > 0 && ds.Tables[1].Rows.Count > 0 && ds.Tables[2].Rows.Count > 0 && ds.Tables[3].Rows.Count > 0)
        {
            // ds.WriteXmlSchema("C:/SalarySlip.xml");

            Session["ds"] = ds;
            Session["ReportName"] = "SalarySlipDeptWise";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Payroll/Report/Commonreport.aspx');", true);
        }
    }

    protected void EmployeeWise()
    {
        if (txtEmpID.Text.Trim() == "")
        {
            lblmsg.Text = "Enter EmployeeID";
            return;
        }
        string Query = "select mst.ID,emp.Employee_ID,emp.Name,House_No Address,DATE_FORMAT(DOB,'%d %b %Y')DOB,DATE_FORMAT(DOJ,'%d-%b-%Y')DOJ,FatherName,ESI_No,EPF_No,if(PF_No='','',PF_No)PF_No,Email,Mobile,mst.Dept_Name,mst.Desi_Name,GR_ID_NO,LIC_No,EDLI_NO_Reg_No,PF_No,if(mst.BankAccountNo='','Cash',mst.BankAccountNo)BankAccountNo,bm.BankName,bm.BranchName,  " +
        " LetterNO,Category,(SELECT SUM(ActualAmount) FROM pay_empsalary_detail det WHERE RemunerationType='E' AND det.MasterID=mst.ID GROUP BY MasterID)GrossSalary from pay_employee_master emp inner join (select ID,EmployeeID,PayableDays,Dept_Name,Dept_ID,Desi_ID,Desi_Name,BankAccountNo,SalaryMonth,ArrearMonth,SalaryType,BankID,branchID from pay_empsalary_master where Month(SalaryMonth)=Month('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "' ) and Year(SalaryMonth)=Year('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "')  and TotalEarning>0) mst on emp.Employee_ID=mst.EmployeeID inner join pay_empsalary_detail det on mst.ID=det.MasterID and TypeID=1 " +
        " inner join pay_attendance att on att.EmployeeID=emp.Employee_ID and Month(Attendance_To)=Month('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "' ) and Year(Attendance_To)=Year('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') LEFT OUTER JOIN pay_branchmaster bm ON mst.branchID=bm.Branch_ID ";
        if (txtEmpID.Text != "")
        {
            Query += "where emp.Employee_ID='" + txtEmpID.Text + "'";
        }
        Query += "order by emp.Employee_ID ";

        DataTable dt = StockReports.GetDataTable(Query);
        if (dt.Rows.Count > 0)
        {
            DataTable dtEmployeerPF = StockReports.GetDataTable(" SELECT Emp_PF FROM pay_pf_detail WHERE EmployeeID='" + txtEmpID.Text + "' AND MONTH(SalaryMonth)=MONTH('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') AND YEAR(SalaryMonth)=YEAR('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "')");
            if (dtEmployeerPF == null && dtEmployeerPF.Rows.Count == 0)
            {
                dtEmployeerPF.Rows[0]["Emp_PF"] = "0";
            }
            dt.Columns.Add(new DataColumn("EMP_PF"));
            dt.Rows[0]["EMP_PF"] = dtEmployeerPF.Rows[0]["Emp_PF"].ToString();
        }
        DataSet ds = new DataSet();
        //ds.Tables.Add(dt.Copy());
        Query = "select MasterID,det.EmployeeID,TypeID,TypeName,sum(Amount)Amount,RemunerationType,TransactionType from pay_empsalary_detail det inner join pay_empsalary_master mst on mst.ID=det.MasterID where  Month(mst.SalaryMonth)=Month('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') and year(mst.SalaryMonth)=Year('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') ";
        if (txtEmpID.Text != "")
        {
            Query += " and det.EmployeeID='" + txtEmpID.Text + "'";
        }
        Query += " and IsPost=1 and det.Amount<>0.00 group by TypeID,EmployeeID,SalaryType,mst.ID order by EmployeeID,TypeID";
        DataTable dt1 = StockReports.GetDataTable(Query);

        Query = "select ERound,ID,mst.EmployeeID,SalaryMonth,Date_format(ArrearMonth,'%b %Y')ArrearMonth,SalaryType,TotalEarning,TotalDeduction,NetPayable,SlipNo,PayableDays from pay_empsalary_master mst  where IsPost=1 and Month(SalaryMonth)=Month('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') and Year(SalaryMonth)=Year('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') ";
        if (txtEmpID.Text != "")
        {
            Query += "and mst.EmployeeID='" + txtEmpID.Text + "'";
        }

        DataTable dt3 = StockReports.GetDataTable(Query);
        //For OverTime shatrughan 15.10.13
        Query = "SELECT MasterID,mst.EmployeeID,GrossSalary,WorkingHrs,OverTimeDays,OverTimeHours,OverTimeAmount,OverTimeTax,OverTimeNetPay,ActualOverTimeHours FROM pay_overtime pao INNER JOIN pay_empsalary_master mst ON mst.ID=pao.MasterID  WHERE IsPost=1 and MONTH(mst.SalaryMonth)=MONTH('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') AND YEAR(mst.SalaryMonth)=YEAR('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') ";
        if (txtEmpID.Text != "")
        {
            Query += "and mst.EmployeeID='" + txtEmpID.Text + "'";
        }
        DataTable dt4 = StockReports.GetDataTable(Query);

        //For Staff Loan
        Query = "";
        //Query = "SELECT Emp.Employee_ID,emp.Name,Adv_ID,Amount,ReceiveAmount,(Amount-ReceiveAmount)Balance,adv.EntDate FROM pay_advancemaster adv INNER JOIN pay_employee_master emp ON adv.Employee_ID=emp.Employee_ID  WHERE Amount>ReceiveAmount  AND STATUS<>2 ";
        Query = "SELECT t.Employee_ID,t.Name,t.Adv_ID,t.Amount,t.ReceiveAmt ReceiveAmount,(t.Amount-t.ReceiveAmt)Balance FROM (";
        Query += "SELECT Emp.Employee_ID,emp.Name,Adv_ID,Amount,ReceiveAmount,(Amount-ReceiveAmount)Balance,(SELECT SUM(amount) FROM pay_advancedetail ";
        Query += "WHERE employee_ID='" + txtEmpID.Text + "'";
        Query += "AND adv_id=adv.adv_id and DATE(EMIMonth)<='" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM") + "-" + DateTime.DaysInMonth(Util.GetInt(Util.GetDateTime(SalaryMonth.Text).ToString("yyyy")), Util.GetInt(Util.GetDateTime(SalaryMonth.Text).ToString("MM"))) + "')ReceiveAmt,adv.EntDate FROM pay_advancemaster adv ";
        Query += "INNER JOIN pay_employee_master emp ON adv.Employee_ID=emp.Employee_ID  WHERE Amount>ReceiveAmount  ";
        Query += "AND STATUS<>2 and ReceiveAmount<>0";
        if (txtEmpID.Text != "")
        {
            Query += " AND Emp.Employee_ID='" + txtEmpID.Text + "')t";
        }
        DataTable dt5 = StockReports.GetDataTable(Query);

        ds.Tables.Add(dt.Copy());
        ds.Tables[0].TableName = "Employee";
        ds.Tables.Add(dt1.Copy());
        ds.Tables[1].TableName = "Remuneration";
        //ds.Tables.Add(dt2.Copy());
        //ds.Tables[2].TableName = "Deduction";
        ds.Tables.Add(dt3.Copy());
        ds.Tables[2].TableName = "SalaryDetail";
        ds.Tables.Add(dt4.Copy());
        ds.Tables[3].TableName = "OverTimeDetail";
        ds.Tables.Add(dt5.Copy());
        ds.Tables[4].TableName = "StaffLoan";

        //lblmsg.Text = ds.Tables[0].Rows.Count + " Record Found";
        if (ds.Tables[0].Rows.Count > 0 && ds.Tables[1].Rows.Count > 0)
        {
            DataColumn dc = new DataColumn("OverTimeExist");
            DataColumn dc1 = new DataColumn("StaffLoanExit");
            //dc.DefaultValue = ds.Tables[3].Rows.Count.ToString();
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
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindDepartment();
            SalaryMonth.Text = DateTime.Now.ToString("MMM-yyyy");
            AllLoadDate_Payroll.BindBankNamePayroll(ddlBankName);
            ddlBankName.Items.RemoveAt(0);
            ddlBankName.Items.Insert(0, new ListItem("ALL", "0"));
        }
        SalaryMonth.Attributes.Add("readonly", "true");
    }

    protected void rbtnReportType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rbtnReportType.SelectedIndex == 0)
        {
            lblempid.Visible = true;
            txtEmpID.Visible = true;
            ddlDepartment.Visible = false;
            lblDept.Visible = false;
            txtLetterNo.Visible = false;
            lblLetterNo.Visible = false;
            lblBankName.Visible = false;
            ddlBankName.Visible = false;
        }
        else if (rbtnReportType.SelectedIndex == 1)
        {
            lblempid.Visible = false;
            txtEmpID.Visible = false;
            ddlDepartment.Visible = false;
            lblDept.Visible = false;
            txtLetterNo.Visible = false;
            lblLetterNo.Visible = false;
            lblBankName.Visible = false;
            ddlBankName.Visible = false;
        }
        else if (rbtnReportType.SelectedIndex == 2)
        {
            lblempid.Visible = false;
            txtEmpID.Visible = false;
            ddlDepartment.Visible = true;
            lblDept.Visible = true;
            txtLetterNo.Visible = false;
            lblLetterNo.Visible = false;
            lblBankName.Visible = false;
            ddlBankName.Visible = false;
        }
        else if (rbtnReportType.SelectedIndex == 3)
        {
            lblempid.Visible = false;
            txtEmpID.Visible = false;
            ddlDepartment.Visible = false;
            lblDept.Visible = false;
            txtLetterNo.Visible = false;
            lblLetterNo.Visible = false;
            lblBankName.Visible = false;
            ddlBankName.Visible = false;
        }
        else if (rbtnReportType.SelectedIndex == 4)
        {
            lblempid.Visible = false;
            txtEmpID.Visible = false;
            ddlDepartment.Visible = false;
            lblDept.Visible = false;
            txtLetterNo.Visible = false;
            lblLetterNo.Visible = false;
            lblBankName.Visible = true;
            ddlBankName.Visible = true;
        }
        else if (rbtnReportType.SelectedIndex == 5)
        {
            lblempid.Visible = false;
            txtEmpID.Visible = false;
            ddlDepartment.Visible = false;
            lblDept.Visible = false;
            txtLetterNo.Visible = false;
            lblLetterNo.Visible = false;
            lblBankName.Visible = false;
            ddlBankName.Visible = false;
        }
        else if (rbtnReportType.SelectedIndex == 6)
        {
            lblempid.Visible = false;
            txtEmpID.Visible = false;
            ddlDepartment.Visible = false;
            lblDept.Visible = false;
            txtLetterNo.Visible = false;
            lblLetterNo.Visible = false;
            lblBankName.Visible = false;
            ddlBankName.Visible = false;
        }
        else if (rbtnReportType.SelectedIndex == 7)
        {
            lblempid.Visible = false;
            txtEmpID.Visible = false;
            ddlDepartment.Visible = false;
            lblDept.Visible = false;
            txtLetterNo.Visible = false;
            lblLetterNo.Visible = false;
            lblBankName.Visible = false;
            ddlBankName.Visible = false;
        }
        else if (rbtnReportType.SelectedIndex == 8)
        {
            lblempid.Visible = false;
            txtEmpID.Visible = false;
            ddlDepartment.Visible = false;
            lblDept.Visible = false;
            txtLetterNo.Visible = false;
            lblLetterNo.Visible = false;
            lblBankName.Visible = false;
            ddlBankName.Visible = false;
        }
    }

    protected void SalarySheet()
    {
        lblmsg.Text = "";
        DataTable DtItems = StockReports.GetDataTable("select det.MasterID,det.EmployeeID,TypeID,TypeName,sum(Amount)Amount,SalaryType,Month(mst.SalaryMonth) As Month from pay_empsalary_detail det inner join pay_empsalary_master mst on mst.ID=det.MasterID inner join pay_remuneration_master rmst on rmst.ID=det.TypeID and rmst.IsActive=1 where Month(mst.SalaryMonth)=Month('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') and Year(mst.SalaryMonth)=Year('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "')  group by TypeID,EmployeeID,SalaryType,MasterID  order by  det.EmployeeID,det.RemunerationType desc,det.TypeID");
        DataTable DtNetPayable = StockReports.GetDataTable(" SELECT mst.EmployeeID,mst.Name ,emp.PF_NO,IF(HusbandName='',FatherName,HusbandName)FatherName,Date_Format(DOJ,'%d %b %Y')DOJ,Date_Format(DOL,'%d %b %Y')DOL,CONCAT('',mst.BankAccountNo)BankAccountNo,mst.TotalEarning,mst.TotalDeduction,mst.NetPayable,SalaryType,mst.ID,IsPost,att.workingDays WorkDays,att.CL,att.EL,att.MedicalLeave Other,mst.PayableDays,ERound  FROM pay_empsalary_master mst INNER JOIN pay_employee_master emp ON mst.EmployeeID=emp.Employee_ID  INNER JOIN pay_attendance att ON mst.EmployeeID=att.EmployeeID AND MONTH(Attendance_To)=MONTH('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') AND YEAR(Attendance_To)=YEAR('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "')  WHERE MONTH(SalaryMonth)=MONTH('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') AND YEAR(SalaryMonth)=YEAR('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "')  ORDER BY EmployeeID ");
        DataTable Employee = StockReports.GetDataTable("select distinct mst.EmployeeID,Date_Format(mst.SalaryMonth,'%d %b %Y') SalaryMonth,mst.ID,SalaryType from pay_empsalary_detail det inner join pay_empsalary_master mst on mst.ID=det.MasterID where Month(mst.SalaryMonth)=Month('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') and Year(mst.SalaryMonth)=Year('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') order by EmployeeID,TypeID");
        DataTable dt = StockReports.GetDataTable("select Name from pay_remuneration_master where IsActive=1 order by RemunerationType desc,ID");
        System.Text.StringBuilder sb = new System.Text.StringBuilder();

        sb.Append(" select EmployeeID,ABasic,(ER_P+EA)Actual_Earning,(DR_P+DA)+(ceiling(((ER_P+EA)*ESI)/100))Actual_Deduction,(ER_P+EA)-((DR_P+DA)+(ceiling(((ER_P+EA)*ESI)/100)))Actual_Net from ( ");
        sb.Append("  select emp.Employee_ID EmployeeID,rem.Amount ABasic  from pay_employeeremuneration rem  ");
        sb.Append("  inner join pay_employee_master emp on rem.Employee_ID=emp.Employee_ID ");
        sb.Append("  and emp.IsActive=1 and TypeID=1)bas ");
        sb.Append(" left join  (");
        sb.Append(" select ba.Employee_ID ,Round((ba.Amount*ifnull(pf.Amount,0))/100,2)ER_P from ( ");
        sb.Append(" select emp.Employee_ID,Name,rem.Amount  from pay_employeeremuneration rem  ");
        sb.Append(" inner join pay_employee_master emp on rem.Employee_ID=emp.Employee_ID ");
        sb.Append(" and emp.IsActive=1 and TypeID=1)ba ");
        sb.Append(" left join (select sum(Amount)Amount,Employee_ID,TypeID from pay_employeeremuneration where CalType='PER' and RemunerationType='E' group by Employee_ID) pf on pf.Employee_ID=ba.Employee_ID ");
        sb.Append(" )EP on bas.EmployeeID=EP.Employee_ID ");
        sb.Append(" left join (");
        sb.Append(" select ba.Employee_ID ,Round((ba.Amount*ifnull(pf.Amount,0))/100,2)DR_P from ( ");
        sb.Append(" select emp.Employee_ID,Name,rem.Amount  from pay_employeeremuneration rem ");
        sb.Append(" inner join pay_employee_master emp on rem.Employee_ID=emp.Employee_ID ");
        sb.Append(" and emp.IsActive=1 and TypeID=1)ba ");
        sb.Append(" inner join (select sum(Amount)Amount,Employee_ID,TypeID from pay_employeeremuneration where CalType='PER' and RemunerationType='D' and TypeID<>15 group by Employee_ID) pf on pf.Employee_ID=ba.Employee_ID");
        sb.Append(" )DP");
        sb.Append(" on bas.EmployeeID=DP.Employee_ID ");
        sb.Append(" left join ( ");
        sb.Append(" select emp.Employee_ID,Name,ifnull(rem.Amount,0) ESI  from pay_employeeremuneration rem  ");
        sb.Append(" inner join pay_employee_master emp on rem.Employee_ID=emp.Employee_ID ");
        sb.Append(" and emp.IsActive=1 and TypeID=15");
        sb.Append(" )ESI");
        sb.Append(" on bas.EmployeeID=ESI.Employee_ID ");
        sb.Append(" left join ( ");
        sb.Append(" select emp.Employee_ID,sum(rem.Amount)EA  from pay_employeeremuneration rem  ");
        sb.Append(" inner join pay_employee_master emp on rem.Employee_ID=emp.Employee_ID ");
        sb.Append(" and emp.IsActive=1 and CalType='AMT' and RemunerationType='E' group by Employee_ID");
        sb.Append(" )EA");
        sb.Append(" on bas.EmployeeID=EA.Employee_ID ");
        sb.Append(" left join ( ");
        sb.Append(" select emp.Employee_ID,sum(rem.Amount)DA  from pay_employeeremuneration rem  ");
        sb.Append(" inner join pay_employee_master emp on rem.Employee_ID=emp.Employee_ID ");
        sb.Append(" and emp.IsActive=1 and CalType='AMT' and RemunerationType='D' group by Employee_ID");
        sb.Append(" )DA ");
        sb.Append(" on bas.EmployeeID=DA.Employee_ID order by EmployeeID ");



        DataTable CrossTab = new DataTable();
        if (dt.Rows.Count == 0 || DtItems.Rows.Count == 0 || Employee.Rows.Count == 0)
        {
            
            return;
        }
        CrossTab.Columns.Add(new DataColumn("ID"));
        CrossTab.Columns.Add(new DataColumn("EmployeeID"));
        CrossTab.Columns.Add(new DataColumn("SalaryType"));

        foreach (DataRow row in dt.Rows)
        {
            CrossTab.Columns.Add(new DataColumn(row["Name"].ToString()));
        }

        for (int a = 3; a < CrossTab.Columns.Count; a++)
        {
            CrossTab.Columns[a].DataType = typeof(decimal);
        }
        CrossTab.Columns.Add(new DataColumn("SalaryMonth"));

        CrossTab.Columns.Add(new DataColumn("TotalEarning"));
        CrossTab.Columns["TotalEarning"].DataType = typeof(decimal);
        CrossTab.Columns.Add(new DataColumn("ERound"));
        CrossTab.Columns["ERound"].DataType = typeof(decimal);
        CrossTab.Columns.Add(new DataColumn("TotalDeduction"));
        CrossTab.Columns["TotalDeduction"].DataType = typeof(decimal);
        CrossTab.Columns.Add(new DataColumn("NetPayable"));
        CrossTab.Columns["NetPayable"].DataType = typeof(decimal);
        CrossTab.Columns.Add(new DataColumn("IsPost"));
        CrossTab.Columns.Add(new DataColumn("Name"));
        CrossTab.Columns.Add(new DataColumn("BankAccountNo"));
        CrossTab.Columns.Add(new DataColumn("FatherName"));
        CrossTab.Columns.Add(new DataColumn("WorkDays"));
        CrossTab.Columns.Add(new DataColumn("CL"));
        CrossTab.Columns.Add(new DataColumn("EL"));
        CrossTab.Columns.Add(new DataColumn("Other"));
        CrossTab.Columns.Add(new DataColumn("PF_NO"));
        CrossTab.Columns.Add(new DataColumn("DOJ"));
        CrossTab.Columns.Add(new DataColumn("DOL"));
        for (int i = 0; i < Employee.Rows.Count; i++)
        {
            DataRow newrow = CrossTab.NewRow();
            newrow["EmployeeID"] = Employee.Rows[i]["EmployeeID"].ToString();
            newrow["SalaryMonth"] = Employee.Rows[i]["SalaryMonth"].ToString();
            //

            DataRow[] row = DtItems.Select("EmployeeID='" + Employee.Rows[i]["EmployeeID"].ToString() + "' and MasterID='" + Employee.Rows[i]["ID"].ToString() + "' and SalaryType='" + Employee.Rows[i]["SalaryType"].ToString() + "'");
            for (int j = 0; j < row.Length; j++)
            {
                //string ColumnName = CrossTab.Columns[j+1].ColumnName;
                string ColumnName = row[j]["TypeName"].ToString();
                newrow[ColumnName] = row[j]["Amount"].ToString();
            }
            newrow["SalaryType"] = Employee.Rows[i]["SalaryType"].ToString();
            newrow["ID"] = Employee.Rows[i]["ID"].ToString();

            CrossTab.Rows.Add(newrow);
        }

        //CrossTab.Columns.Add(new DataColumn("ABasic"));
        //CrossTab.Columns.Add(new DataColumn("Actual_Earning"));
        //CrossTab.Columns.Add(new DataColumn("Actual_Deduction"));
        //CrossTab.Columns.Add(new DataColumn("Actual_Net"));
        CrossTab.Columns.Add(new DataColumn("PayableDays"));
        for (int i = 0; i < CrossTab.Rows.Count; i++)
        {
            DataRow[] row = DtNetPayable.Select("EmployeeID='" + CrossTab.Rows[i]["EmployeeID"].ToString() + "' and ID='" + CrossTab.Rows[i]["ID"].ToString() + "' and SalaryType='" + CrossTab.Rows[i]["SalaryType"].ToString() + "'");
            if (row.Length > 0)
            {
                CrossTab.Rows[i]["ERound"] = row[0]["ERound"].ToString();
                CrossTab.Rows[i]["TotalEarning"] = row[0]["TotalEarning"].ToString();
                CrossTab.Rows[i]["TotalDeduction"] = row[0]["TotalDeduction"].ToString();
                CrossTab.Rows[i]["NetPayable"] = row[0]["NetPayable"].ToString();
                CrossTab.Rows[i]["IsPost"] = row[0]["IsPost"].ToString();
                CrossTab.Rows[i]["BankAccountNo"] = row[0]["BankAccountNo"].ToString();
                CrossTab.Rows[i]["Name"] = row[0]["Name"].ToString();
                CrossTab.Rows[i]["PayableDays"] = row[0]["PayableDays"].ToString();

                CrossTab.Rows[i]["CL"] = row[0]["CL"].ToString();
                CrossTab.Rows[i]["EL"] = row[0]["EL"].ToString();
                CrossTab.Rows[i]["Other"] = row[0]["Other"].ToString();
                CrossTab.Rows[i]["WorkDays"] = row[0]["WorkDays"].ToString();
                CrossTab.Rows[i]["FatherName"] = row[0]["FatherName"].ToString();
                CrossTab.Rows[i]["PF_NO"] = row[0]["PF_NO"].ToString();
                CrossTab.Rows[i]["DOJ"] = row[0]["DOJ"].ToString();
                CrossTab.Rows[i]["DOL"] = row[0]["DOL"].ToString();
            }
        }

        ////CrossTab.Columns["PF_NO"].SetOrdinal(2);
        ////CrossTab.Columns["Name"].SetOrdinal(3);
        ////CrossTab.Columns["FatherName"].SetOrdinal(4);
        ////CrossTab.Columns["BankAccountNo"].SetOrdinal(5);
        ////CrossTab.Columns["WorkDays"].SetOrdinal(6);
        ////CrossTab.Columns["CL"].SetOrdinal(7);
        ////CrossTab.Columns["EL"].SetOrdinal(8);
        ////CrossTab.Columns["Other"].SetOrdinal(9);
        ////CrossTab.Columns["PayableDays"].SetOrdinal(10);
        ////CrossTab.Columns["Basic"].SetOrdinal(11);
        ////CrossTab.Columns["DAILY ALLOWANCE"].SetOrdinal(12);
        ////CrossTab.Columns["UNIFORM ALLOWANCE"].SetOrdinal(13);
        ////CrossTab.Columns["TotalEarning"].SetOrdinal(14);
        ////CrossTab.Columns["PF"].SetOrdinal(15);
        //////CrossTab.Columns["ESI"].SetOrdinal(13);
        ////CrossTab.Columns["ESI"].SetOrdinal(16);
        ////CrossTab.Columns["INCOME TAX"].SetOrdinal(17);
        ////CrossTab.Columns["ADVANCE"].SetOrdinal(18);
        ////CrossTab.Columns["SECURITY"].SetOrdinal(19);
        ////CrossTab.Columns["OTHER DEDUCTION"].SetOrdinal(20);
        ////CrossTab.Columns["TotalDeduction"].SetOrdinal(21);
        ////CrossTab.Columns["ERound"].SetOrdinal(22);

        ///for Total
        ///
        //DataRow TotalRow = CrossTab.NewRow();
        //for (int i = 6; i < CrossTab.Columns.Count - 1; i++)
        //{
        //    if (CrossTab.Columns[i].DataType == typeof(decimal))
        //    {
        //        TotalRow[CrossTab.Columns[i].ColumnName] = CrossTab.Compute("sum([" + CrossTab.Columns[i].ColumnName + "])", "");
        //    }
        //}
        //CrossTab.Rows.Add(TotalRow);
        ///ReName Column
        ///
        CrossTab.Columns["EmployeeID"].ColumnName = "EmpID";
        CrossTab.Columns["Name"].ColumnName = "NameOfEmployee";
        CrossTab.Columns["TotalEarning"].ColumnName = "Total Salary";
        CrossTab.Columns["ERound"].ColumnName = "Round";
        DataSet ds = new DataSet();
        if (CrossTab.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.DefaultValue = StockReports.ExecuteScalar("SELECT COUNT(*) FROM pay_employee_master WHERE MONTH(DOL)=Month('" + SalaryMonth.Text + "') AND YEAR(DOL)=Year('" + SalaryMonth.Text + "')");
            CrossTab.Columns.Add(dc);
            CrossTab.Columns.Remove("IsPost");
            CrossTab.Columns.Remove("ID");
            CrossTab.Columns.Remove("SalaryType");

            //ds = ds.Tables.Add(CrossTab.Copy());
            ds.Tables.Add(CrossTab.Copy());

            //Session["CustomData"] = CrossTab;

            //ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('../../Design/Payroll/CustomReportForExport.aspx');", true);
            if (ds.Tables[0].Rows.Count > 0)
            {
                //ds.WriteXmlSchema("C:/SalarySheetNormal.xml");

                Session["ds"] = ds;
                Session["ReportName"] = "SalarySheetNormal";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Payroll/Report/Commonreport.aspx');", true);
            }
        }

        //if (MinusSalaryEmployee.Length > 0)
        //{
        //    lblmsg.Text = "Salary Error of Employee { " + MinusSalaryEmployee + " }";
        //}
    }

    protected void SalarySheetExcel()
    {
        lblmsg.Text = "";
        DataTable DtItems = StockReports.GetDataTable("select det.MasterID,det.EmployeeID,TypeID,TypeName,sum(Amount)Amount,SalaryType from pay_empsalary_detail det inner join pay_empsalary_master mst on mst.ID=det.MasterID inner join pay_remuneration_master rmst on rmst.ID=det.TypeID and rmst.IsActive=1  where Month(mst.SalaryMonth)=Month('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') and Year(mst.SalaryMonth)=Year('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "')  group by TypeID,EmployeeID,SalaryType,MasterID  order by  det.EmployeeID,det.RemunerationType desc,det.TypeID");
        DataTable DtNetPayable = StockReports.GetDataTable(" SELECT mst.EmployeeID,mst.Name ,emp.PF_NO,IF(HusbandName='',FatherName,HusbandName)FatherName,CONCAT('',mst.BankAccountNo)BankAccountNo,mst.TotalEarning,mst.TotalDeduction,mst.NetPayable,SalaryType,mst.ID,IsPost,att.workingDays WorkDays,att.CL,att.EL,att.MedicalLeave Other,mst.PayableDays,ERound,Emp_PF,Basic+Emp_PF EmployeeCost  FROM pay_empsalary_master mst INNER JOIN pay_employee_master emp ON mst.EmployeeID=emp.Employee_ID  INNER JOIN pay_attendance att ON mst.EmployeeID=att.EmployeeID AND MONTH(Attendance_To)=MONTH('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') AND YEAR(Attendance_To)=YEAR('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') LEFT OUTER JOIN pay_pf_detail pf ON pf.MasterID=mst.ID  WHERE MONTH(mst.SalaryMonth)=MONTH('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') AND YEAR(mst.SalaryMonth)=YEAR('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "')  ORDER BY EmployeeID ");
        DataTable Employee = StockReports.GetDataTable("select distinct mst.EmployeeID,mst.ID,SalaryType from pay_empsalary_detail det inner join pay_empsalary_master mst on mst.ID=det.MasterID where Month(mst.SalaryMonth)=Month('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') and Year(mst.SalaryMonth)=Year('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') order by EmployeeID,TypeID");
        DataTable dt = StockReports.GetDataTable("select Name from pay_remuneration_master where IsActive=1 order by RemunerationType desc,ID");
        //DataTable dtOther = StockReports.GetDataTable("select Name from pay_remuneration_master where isloan=1 order by ID");
        System.Text.StringBuilder sb = new System.Text.StringBuilder();

        //sb.Append(" select EmployeeID,ABasic,(ER_P+EA)Actual_Earning,(DR_P+DA)+(ceiling(((ER_P+EA)*ESI)/100))Actual_Deduction,(ER_P+EA)-((DR_P+DA)+(ceiling(((ER_P+EA)*ESI)/100)))Actual_Net from ( ");
        //sb.Append("  select emp.Employee_ID EmployeeID,rem.Amount ABasic  from pay_employeeremuneration rem  ");
        //sb.Append("  inner join pay_employee_master emp on rem.Employee_ID=emp.Employee_ID ");
        //sb.Append("  and emp.IsActive=1 and TypeID=1)bas ");
        //sb.Append(" left join  (");
        //sb.Append(" select ba.Employee_ID ,Round((ba.Amount*ifnull(pf.Amount,0))/100,2)ER_P from ( ");
        //sb.Append(" select emp.Employee_ID,Name,rem.Amount  from pay_employeeremuneration rem  ");
        //sb.Append(" inner join pay_employee_master emp on rem.Employee_ID=emp.Employee_ID ");
        //sb.Append(" and emp.IsActive=1 and TypeID=1)ba ");
        //sb.Append(" left join (select sum(Amount)Amount,Employee_ID,TypeID from pay_employeeremuneration where CalType='PER' and RemunerationType='E' group by Employee_ID) pf on pf.Employee_ID=ba.Employee_ID ");
        //sb.Append(" )EP on bas.EmployeeID=EP.Employee_ID ");
        //sb.Append(" left join (");
        //sb.Append(" select ba.Employee_ID ,Round((ba.Amount*ifnull(pf.Amount,0))/100,2)DR_P from ( ");
        //sb.Append(" select emp.Employee_ID,Name,rem.Amount  from pay_employeeremuneration rem ");
        //sb.Append(" inner join pay_employee_master emp on rem.Employee_ID=emp.Employee_ID ");
        //sb.Append(" and emp.IsActive=1 and TypeID=1)ba ");
        //sb.Append(" inner join (select sum(Amount)Amount,Employee_ID,TypeID from pay_employeeremuneration where CalType='PER' and RemunerationType='D' and TypeID<>15 group by Employee_ID) pf on pf.Employee_ID=ba.Employee_ID");
        //sb.Append(" )DP");
        //sb.Append(" on bas.EmployeeID=DP.Employee_ID ");
        //sb.Append(" left join ( ");
        //sb.Append(" select emp.Employee_ID,Name,ifnull(rem.Amount,0) ESI  from pay_employeeremuneration rem  ");
        //sb.Append(" inner join pay_employee_master emp on rem.Employee_ID=emp.Employee_ID ");
        //sb.Append(" and emp.IsActive=1 and TypeID=15");
        //sb.Append(" )ESI");
        //sb.Append(" on bas.EmployeeID=ESI.Employee_ID ");
        //sb.Append(" left join ( ");
        //sb.Append(" select emp.Employee_ID,sum(rem.Amount)EA  from pay_employeeremuneration rem  ");
        //sb.Append(" inner join pay_employee_master emp on rem.Employee_ID=emp.Employee_ID ");
        //sb.Append(" and emp.IsActive=1 and CalType='AMT' and RemunerationType='E' group by Employee_ID");
        //sb.Append(" )EA");
        //sb.Append(" on bas.EmployeeID=EA.Employee_ID ");
        //sb.Append(" left join ( ");
        //sb.Append(" select emp.Employee_ID,sum(rem.Amount)DA  from pay_employeeremuneration rem  ");
        //sb.Append(" inner join pay_employee_master emp on rem.Employee_ID=emp.Employee_ID ");
        //sb.Append(" and emp.IsActive=1 and CalType='AMT' and RemunerationType='D' group by Employee_ID");
        //sb.Append(" )DA ");
        //sb.Append(" on bas.EmployeeID=DA.Employee_ID order by EmployeeID ");

        //Indo Gulf Not required Actual ....

        //DataTable ActualDt = StockReports.GetDataTable(sb.ToString());

        DataTable CrossTab = new DataTable();
        if (dt.Rows.Count == 0 || DtItems.Rows.Count == 0 || Employee.Rows.Count == 0)
        {
            //lblmsg.Text = "No Record Found";
            //EmpGrid.DataSource = null;
            //EmpGrid.DataBind();
            return;
        }
        CrossTab.Columns.Add(new DataColumn("ID"));
        CrossTab.Columns.Add(new DataColumn("EmployeeID"));
        CrossTab.Columns.Add(new DataColumn("SalaryType"));

        foreach (DataRow row in dt.Rows)
        {
            CrossTab.Columns.Add(new DataColumn(row["Name"].ToString()));
        }

        for (int a = 3; a < CrossTab.Columns.Count; a++)
        {
            CrossTab.Columns[a].DataType = typeof(decimal);
        }

        CrossTab.Columns.Add(new DataColumn("TotalEarning"));
        CrossTab.Columns["TotalEarning"].DataType = typeof(decimal);
        CrossTab.Columns.Add(new DataColumn("ERound"));
        CrossTab.Columns["ERound"].DataType = typeof(decimal);
        CrossTab.Columns.Add(new DataColumn("TotalDeduction"));
        CrossTab.Columns["TotalDeduction"].DataType = typeof(decimal);
        CrossTab.Columns.Add(new DataColumn("NetPayable"));
        CrossTab.Columns["NetPayable"].DataType = typeof(decimal);
        CrossTab.Columns.Add(new DataColumn("IsPost"));
        CrossTab.Columns.Add(new DataColumn("Name"));
        CrossTab.Columns.Add(new DataColumn("BankAccountNo"));

        CrossTab.Columns.Add(new DataColumn("SSNITNo"));
        CrossTab.Columns.Add(new DataColumn("EmployerSSNIT"));
        CrossTab.Columns["EmployerSSNIT"].DataType = typeof(decimal);
        CrossTab.Columns.Add(new DataColumn("EmployeeCost"));
        CrossTab.Columns["EmployeeCost"].DataType = typeof(decimal);
        for (int i = 0; i < Employee.Rows.Count; i++)
        {
            DataRow newrow = CrossTab.NewRow();
            newrow["EmployeeID"] = Employee.Rows[i]["EmployeeID"].ToString();
            DataRow[] row = DtItems.Select("EmployeeID='" + Employee.Rows[i]["EmployeeID"].ToString() + "' and MasterID='" + Employee.Rows[i]["ID"].ToString() + "' and SalaryType='" + Employee.Rows[i]["SalaryType"].ToString() + "'");
            for (int j = 0; j < row.Length; j++)
            {
                //string ColumnName = CrossTab.Columns[j+1].ColumnName;
                string ColumnName = row[j]["TypeName"].ToString();
                newrow[ColumnName] = row[j]["Amount"].ToString();
            }
            newrow["SalaryType"] = Employee.Rows[i]["SalaryType"].ToString();
            newrow["ID"] = Employee.Rows[i]["ID"].ToString();

            CrossTab.Rows.Add(newrow);
        }

        //CrossTab.Columns.Add(new DataColumn("ABasic"));
        //CrossTab.Columns.Add(new DataColumn("Actual_Earning"));
        //CrossTab.Columns.Add(new DataColumn("Actual_Deduction"));
        //CrossTab.Columns.Add(new DataColumn("Actual_Net"));
        CrossTab.Columns.Add(new DataColumn("PayableDays"));
        for (int i = 0; i < CrossTab.Rows.Count; i++)
        {
            DataRow[] row = DtNetPayable.Select("EmployeeID='" + CrossTab.Rows[i]["EmployeeID"].ToString() + "' and ID='" + CrossTab.Rows[i]["ID"].ToString() + "' and SalaryType='" + CrossTab.Rows[i]["SalaryType"].ToString() + "'");
            if (row.Length > 0)
            {
                CrossTab.Rows[i]["ERound"] = row[0]["ERound"].ToString();
                CrossTab.Rows[i]["TotalEarning"] = row[0]["TotalEarning"].ToString();
                CrossTab.Rows[i]["TotalDeduction"] = row[0]["TotalDeduction"].ToString();
                CrossTab.Rows[i]["NetPayable"] = row[0]["NetPayable"].ToString();
                CrossTab.Rows[i]["IsPost"] = row[0]["IsPost"].ToString();
                CrossTab.Rows[i]["BankAccountNo"] = row[0]["BankAccountNo"].ToString();
                CrossTab.Rows[i]["Name"] = row[0]["Name"].ToString();
                CrossTab.Rows[i]["PayableDays"] = row[0]["PayableDays"].ToString();

                CrossTab.Rows[i]["SSNITNo"] = row[0]["PF_NO"].ToString();
                CrossTab.Rows[i]["EmployerSSNIT"] = Util.GetFloat(row[0]["Emp_PF"].ToString());
                CrossTab.Rows[i]["EmployeeCost"] = Util.GetFloat(row[0]["EmployeeCost"].ToString());
            }
        }

        ////CrossTab.Columns["PF_NO"].SetOrdinal(2);
        ////CrossTab.Columns["Name"].SetOrdinal(3);
        ////CrossTab.Columns["FatherName"].SetOrdinal(4);
        ////CrossTab.Columns["BankAccountNo"].SetOrdinal(5);
        ////CrossTab.Columns["WorkDays"].SetOrdinal(6);
        ////CrossTab.Columns["CL"].SetOrdinal(7);
        ////CrossTab.Columns["EL"].SetOrdinal(8);
        ////CrossTab.Columns["Other"].SetOrdinal(9);
        ////CrossTab.Columns["PayableDays"].SetOrdinal(10);
        ////CrossTab.Columns["Basic"].SetOrdinal(11);
        ////////CrossTab.Columns["DAILY ALLOWANCE"].SetOrdinal(12);
        ////CrossTab.Columns["HRA"].SetOrdinal(12);
        ////CrossTab.Columns["CONVEYANCE ALLOWANCE"].SetOrdinal(13);
        ////CrossTab.Columns["UNIFORM ALLOWANCE"].SetOrdinal(14);
        ////CrossTab.Columns["OTHER ALLOWANCE"].SetOrdinal(15);
        ////CrossTab.Columns["OVERTIME"].SetOrdinal(16);
        ////CrossTab.Columns["EXTRA WORK"].SetOrdinal(17);

        ////CrossTab.Columns["ERound"].SetOrdinal(18);
        ////CrossTab.Columns["TotalEarning"].SetOrdinal(19);
        ////CrossTab.Columns["PF"].SetOrdinal(20);
        //////CrossTab.Columns["ESI"].SetOrdinal(13);
        ////CrossTab.Columns["ESI"].SetOrdinal(21);
        ////CrossTab.Columns["INCOME TAX"].SetOrdinal(22);
        ////CrossTab.Columns["ADVANCE"].SetOrdinal(23);
        ////CrossTab.Columns["SECURITY"].SetOrdinal(24);
        ////CrossTab.Columns["OTHER DEDUCTION"].SetOrdinal(25);
        ////CrossTab.Columns["TotalDeduction"].SetOrdinal(26);

        ///for Total
        ///
        DataRow TotalRow = CrossTab.NewRow();
        for (int i = 6; i < CrossTab.Columns.Count - 1; i++)
        {
            if (CrossTab.Columns[i].DataType == typeof(decimal))
            {
                TotalRow[CrossTab.Columns[i].ColumnName] = CrossTab.Compute("sum([" + CrossTab.Columns[i].ColumnName + "])", "");
            }
        }
        CrossTab.Rows.Add(TotalRow);
        ///ReName Column
        ///
        CrossTab.Columns["EmployeeID"].ColumnName = "EmployeeID";
        CrossTab.Columns["Name"].ColumnName = "EmployeeName";
        CrossTab.Columns["TotalEarning"].ColumnName = "TotalEarning";
        CrossTab.Columns["ERound"].ColumnName = "Round";

        CrossTab.Columns["EmployeeID"].SetOrdinal(1);
        CrossTab.Columns["EmployeeName"].SetOrdinal(2);
        CrossTab.Columns["SSNITNo"].SetOrdinal(3);
        CrossTab.Columns["PayableDays"].SetOrdinal(4);
        CrossTab.Columns["Basic"].SetOrdinal(5);
        CrossTab.Columns["TotalEarning"].SetOrdinal(6);
        if (CrossTab.Rows.Count > 0)
        {
            CrossTab.Columns.Remove("IsPost");
            CrossTab.Columns.Remove("ID");
            CrossTab.Columns.Remove("SalaryType");
            CrossTab.Columns.Remove("BankAccountNo");
            Session["CustomData"] = CrossTab;

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('../../Design/Payroll/CustomReportForExport.aspx');", true);
        }

        //if (MinusSalaryEmployee.Length > 0)
        //{
        //    lblmsg.Text = "Salary Error of Employee { " + MinusSalaryEmployee + " }";
        //}
    }

    private void BindDepartment()
    {
        DataTable dt = StockReports.GetDataTable("select Dept_ID,Dept_Name from Pay_deptartment_master  where IsActive=1");
        ddlDepartment.DataSource = dt;
        ddlDepartment.DataValueField = "Dept_ID";
        ddlDepartment.DataTextField = "Dept_Name";
        ddlDepartment.DataBind();
        ddlDepartment.Items.Insert(0, "All");
    }

    private string changeNumericToWords(int number)
    {
        if (number == 0) return "Zero";

        if (number == -2147483648) return "Minus Two Hundred and Fourteen Crore Seventy Four Lakh Eighty Three Thousand Six Hundred and Forty Eight";

        int[] num = new int[4];
        int first = 0;
        int u, h, t;
        System.Text.StringBuilder sb = new System.Text.StringBuilder();

        if (number < 0)
        {
            sb.Append("Minus ");
            number = -number;
        }

        string[] words0 = { "", "One ", "Two ", "Three ", "Four ", "Five ", "Six ", "Seven ", "Eight ", "Nine " };

        string[] words1 = { "Ten ", "Eleven ", "Twelve ", "Thirteen ", "Fourteen ", "Fifteen ", "Sixteen ", "Seventeen ", "Eighteen ", "Nineteen " };

        string[] words2 = { "Twenty ", "Thirty ", "Forty ", "Fifty ", "Sixty ", "Seventy ", "Eighty ", "Ninety " };

        string[] words3 = { "Thousand ", "Lakh ", "Crore " };

        num[0] = number % 1000; // units
        num[1] = number / 1000;
        num[2] = number / 100000;
        num[1] = num[1] - 100 * num[2]; // thousands
        num[3] = number / 10000000; // crores
        num[2] = num[2] - 100 * num[3]; // lakhs

        for (int i = 3; i > 0; i--)
        {
            if (num[i] != 0)
            {
                first = i;
                break;
            }
        }

        for (int i = first; i >= 0; i--)
        {
            if (num[i] == 0) continue;

            u = num[i] % 10; // ones
            t = num[i] / 10;
            h = num[i] / 100; // hundreds
            t = t - 10 * h; // tens

            if (h > 0) sb.Append(words0[h] + "Hundred ");

            if (u > 0 || t > 0)
            {
                if (h > 0 || i == 0) sb.Append("and ");

                if (t == 0)
                    sb.Append(words0[u]);
                else if (t == 1)
                    sb.Append(words1[u]);
                else
                    sb.Append(words2[t - 2] + words0[u]);
            }

            if (i != 0) sb.Append(words3[i - 1]);
        }
        sb.Append(" Only");
        return sb.ToString().TrimEnd();
    }

    private void pay_ClassSummary()
    {
        DataTable dt = StockReports.GetDataTable("call pay_ClassSummary('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "')");
        if (dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();

            ds.Tables.Add(dt.Copy());
            ds.Tables[0].TableName = "payClassSummary";
            // ds.WriteXmlSchema("E:/payClassSummary.xml");

            Session["ds"] = ds;
            Session["ReportName"] = "payClassSummary";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Payroll/Report/Commonreport.aspx');", true);
        }
    }

    private void pay_ClassSummaryExcel()
    {
        DataTable dt = StockReports.GetDataTable("call pay_ClassSummary('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "')");
        if (dt.Rows.Count > 0)
        {
            lblmsg.Text = "";
            DataView Dview = dt.DefaultView;
            Dview.Sort = "RemunerationType DESC,TypeID ASC";
            DataTable dtTypename = Dview.ToTable("DistinctTable", true, "TypeName");

            DataView Dptview = dt.DefaultView;
            DataTable Dept = Dptview.ToTable("DistinctTable", true, "Dept_Name");

            DataTable CrossTab = new DataTable();
            CrossTab.Columns.Add(new DataColumn("TypeName"));
            foreach (DataRow row in Dept.Rows)
            {
                CrossTab.Columns.Add(new DataColumn(row["Dept_Name"].ToString()));
            }
            for (int s = 1; s < CrossTab.Columns.Count; s++)
            {
                CrossTab.Columns[s].DataType = typeof(decimal);
            }
            CrossTab.Columns.Add("Total", typeof(decimal));
            CrossTab.Columns.Add("RemunerationType");

            for (int i = 0; i < dtTypename.Rows.Count; i++)
            {
                DataRow[] row = dt.Select("TypeName='" + dtTypename.Rows[i]["TypeName"].ToString() + "'");
                if (row.Length > 0)
                {
                    DataRow newrow = CrossTab.NewRow();
                    newrow[0] = dtTypename.Rows[i]["TypeName"].ToString();

                    newrow[CrossTab.Columns.Count - 1] = row[0]["RemunerationType"].ToString();
                    decimal Amount = 0;
                    for (int s = 1; s < CrossTab.Columns.Count - 2; s++)
                    {
                        if (row.Length >= s)
                        {
                            newrow[row[s - 1]["Dept_Name"].ToString().Trim()] = row[s - 1]["Amount"].ToString();

                            Amount += Util.GetDecimal(row[s - 1]["Amount"].ToString());
                        }
                    }
                    newrow["Total"] = Amount;
                    CrossTab.Rows.Add(newrow);
                }
            }
            //total Earning
            DataRow NewRowE = CrossTab.NewRow();
            NewRowE[0] = "TOTAL STAFF COST";
            decimal TotalStaff = 0;
            for (int s = 1; s < CrossTab.Columns.Count - 2; s++)
            {
                NewRowE[s] = CrossTab.Compute("sum([" + CrossTab.Columns[s].ColumnName + "])", "RemunerationType='E'");
                //  decimal Amt = (decimal)NewRowE[s];
                TotalStaff += Util.GetDecimal(NewRowE[s].ToString());
            }
            NewRowE["Total"] = TotalStaff;
            //E Count
            DataRow[] Erow = CrossTab.Select("RemunerationType='E'");
            CrossTab.Rows.InsertAt(NewRowE, Erow.Length);

            //total deduction
            DataRow NewRowD = CrossTab.NewRow();
            NewRowD[0] = "TOTAL PAYABLES";
            decimal TotalPayables = 0;
            for (int s = 1; s < CrossTab.Columns.Count - 2; s++)
            {
                NewRowD[s] = CrossTab.Compute("sum([" + CrossTab.Columns[s].ColumnName + "])", "RemunerationType='D'");
                TotalPayables += Util.GetDecimal(NewRowD[s].ToString());
            }

            NewRowD["Total"] = TotalPayables;
            CrossTab.Rows.InsertAt(NewRowD, CrossTab.Rows.Count);
            //Remove Last column
            CrossTab.Columns.RemoveAt(CrossTab.Columns.Count - 1);

            if (CrossTab.Rows.Count > 0)
            {
                Session["ReportName"] = "Class Summary";
                Session["CustomData"] = CrossTab;
                Session["Period"] = "Salary Month " + Util.GetDateTime(SalaryMonth.Text).ToString("MMM-yyyy");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('../../Design/Payroll/CustomReportForExport.aspx');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
            }
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
        }
    }
}