using System;
using System.Data;
using System.Web.UI;

public partial class Design_Payroll_IncomeTaxReport : System.Web.UI.Page
{
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        if (RadioButtonList2.SelectedItem.Text == "Word")
        {
            Session["PrintType"] = "ExpToWord";
        }
        else if (RadioButtonList2.SelectedItem.Text == "PDF")
        {
            Session["PrintType"] = "ExpToPDF";
        }

        if (rbtnReportType.SelectedIndex == 0)
        {
            IncomeTaxMonthly();
        }
        else if (rbtnReportType.SelectedIndex == 1)
        {
            IncomeTaxDetail();
        }
        else if (rbtnReportType.SelectedIndex == 2)
        {
            IncomeTaxYearly();
        }
        else if (rbtnReportType.SelectedIndex == 3)
        {
            IncomeTaxForm16();
        }
        else if (rbtnReportType.SelectedIndex == 4)
        {
            IncomeTax27A();
        }
        else if (rbtnReportType.SelectedIndex == 5)
        {
            IncomeTax55();
        }
    }

    protected void IncomeTax55()
    {
        System.Text.StringBuilder sb = new System.Text.StringBuilder();
        sb.Append(" SELECT pf.EmployeeID,pf.Name,Basic,em.ESI_No as GRA_TIN_NO,PayableDays No_Of_Days,IFNULL(PF_Amount,'')Employee_SSNIT ");
        sb.Append(" ,IFNULL(det.Amount,'')IncomeTax,IFNULL(det1.Amount,'')OverTime,IFNULL(det2.Amount,'')OverTimeTax,");
        sb.Append(" (Basic-PF_Amount)TaxablePay,(IFNULL(det.Amount,'0')+IFNULL(det2.Amount,'0'))Total");
        sb.Append(" FROM pay_pf_detail pf INNER JOIN pay_empsalary_master mst  ON mst.ID=pf.MasterID inner join pay_employee_master em on mst.EmployeeID=em.Employee_ID");
        sb.Append(" LEFT JOIN pay_empsalary_detail det ON mst.ID=det.MasterID AND det.TypeID=16 AND det.Amount>0 ");
        sb.Append(" LEFT JOIN pay_empsalary_detail det1 ON mst.ID=det1.MasterID AND det1.TypeID=33 AND det1.Amount>0 ");
        sb.Append(" LEFT JOIN pay_empsalary_detail det2 ON mst.ID=det2.MasterID AND det2.TypeID=46 AND det2.Amount>0 ");
        sb.Append(" WHERE     MONTH(mst.SalaryMonth)=MONTH('" + Util.GetDateTime(MonthDate.Text).ToString("yyyy-MM-dd") + "') AND YEAR(mst.SalaryMonth)=YEAR('" + Util.GetDateTime(MonthDate.Text).ToString("yyyy-MM-dd") + "') ORDER BY mst.EmployeeID");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            lblmsg.Text = "";
            DataSet ds = new DataSet();
            DataColumn dc = new DataColumn("Salary Month");
            dc.DefaultValue = Util.GetDateTime(MonthDate.Text).ToString("MMMM yyyy");
            dt.Columns.Add(dc);

            ds.Tables.Add(dt.Copy());
            if (RadioButtonList2.SelectedItem.Text == "Excel")
            {
                Session["ReportName"] = "IncomTaxForm55";
                Session["CustomData"] = dt;
                Session["Period"] = "Salary Month " + Util.GetDateTime(MonthDate.Text).ToString("MMM-yyyy");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('../../Design/Payroll/CustomReportForExport.aspx');", true);
            }
            else
            {
                //ds.WriteXmlSchema("E:/IncomTaxForm55.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "IncomTaxForm55";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Payroll/Report/Commonreport.aspx');", true);
            }
        }
        else
        {
        }
    }

    protected void IncomeTaxDetail()
    {
        string str = "select mst.EmployeeID,mst.Name,SalaryType,SalaryMonth,Amount from pay_empsalary_master mst inner join pay_empsalary_detail det on mst.ID=det.MasterID and det.TypeID=16 and Amount>0 and Date(mst.SalaryMonth)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' and Date(mst.SalaryMonth)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' group by mst.EmployeeID order by mst.EmployeeID,SalaryMonth ";
        DataTable dt2 = StockReports.GetDataTable(str);
        dt2.Columns.Add(new DataColumn("FromDate"));
        dt2.Columns.Add(new DataColumn("ToDate"));
        dt2.Rows[0]["FromDate"] = txtFromDate.Text;
        dt2.Rows[0]["ToDate"] = txtToDate.Text;

        str = "select mst.EmployeeID,mst.Name,SalaryType,SalaryMonth,Amount from pay_empsalary_master mst inner join pay_empsalary_detail det on mst.ID=det.MasterID and det.TypeID=16 and Amount>0 and Date(mst.SalaryMonth)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' and Date(mst.SalaryMonth)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'  order by mst.EmployeeID,SalaryMonth ";
        DataTable dt = StockReports.GetDataTable(str);

        DataSet ds = new DataSet();
        ds.Tables.Add(dt.Copy());
        ds.Tables[0].TableName = "EmpDetail";
        ds.Tables.Add(dt2.Copy());
        //ds.Tables[1].TableName = "EmpDetail";

        if (ds.Tables[0].Rows.Count > 0)
        {
            //  ds.WriteXmlSchema("C:/IncomeTaxDetail.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "IncomeTaxDetail";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Payroll/Report/Commonreport.aspx');", true);
        }
    }

    protected void IncomeTaxMonthly()
    {
        string str = "select mst.ID,mst.EmployeeID,mst.Name,SalaryType,det.Amount,SalaryMonth from pay_empsalary_master mst " +
       " inner join pay_empsalary_detail det on mst.ID=det.MasterID where Month(mst.SalaryMonth)=Month('" + Util.GetDateTime(MonthDate.Text).ToString("yyyy-MM-dd") + "') and  Year(mst.SalaryMonth)=Year('" + Util.GetDateTime(MonthDate.Text).ToString("yyyy-MM-dd") + "') " +
       " and det.TypeID=16 and Amount>0 order by mst.EmployeeID,SalaryMonth ";
        DataTable dt = StockReports.GetDataTable(str);

        DataSet ds = new DataSet();
        ds.Tables.Add(dt.Copy());
        if (ds.Tables[0].Rows.Count > 0)
        {
            if (RadioButtonList2.SelectedItem.Text == "Excel")
            {
                Session["ReportName"] = "IncomeTax Monthly Report";
                Session["CustomData"] = dt;
                Session["Period"] = "Salary Month " + Util.GetDateTime(MonthDate.Text).ToString("MMM-yyyy");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('../../Design/Payroll/CustomReportForExport.aspx');", true);
            }
            else
            {
                //ds.WriteXmlSchema("C:/IncomeTax.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "IncomeTax";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Payroll/Report/Commonreport.aspx');", true);
            }
        }
    }

    protected void IncomeTaxYearly()
    {
        string FromDate = ddlFrom.SelectedItem.Text + "-4-1";
        string ToDate = ddlTo.SelectedItem.Text + "-3-31";

        System.Text.StringBuilder sb = new System.Text.StringBuilder();

        sb.Append(" select 	EmployeeID,Name,Designation,DOJ,PAN,GBasic,GNPA,GHRA,GDA,Allowance,Encashment_Leave,BONUS,2_5th,RentExcess,Taxable_HRA, ");
        sb.Append(" RentAccomodation,Furniture,Rent_Concessions,Electricity,ifnull(Convenyance,0)Convenyance,ifnull(Con_Rebate,0)Con_Rebate,ifnull(TaxableConvenyance,0)TaxableConvenyance,GrossSalary,OtherIncome, ");
        sb.Append(" MedicalClaim,HomeLoanInterst,U_S80U,U_S80E,GrossTotalIncome,PF,PPF,LIC,ULIP,NSC,HouseLoan,GSLI, ");
        sb.Append(" TutionFee,BONDS,LifeInsurance,Rebate,NetIncome,TaxSlab1,TaxSlab2,TaxSlab3,TaxSlab4,");
        sb.Append(" TaxPayable,EduCess,TotalTaxpayable,TaxAlreadyPaid,Balance,DATE_FORMAT(det.FinYearFrom,'%Y'),DATE_FORMAT(det.FinYearTo,'%Y'),slab.Slab1,slab.Slab1Per,slab.Slab2,slab.Slab2Per,slab.Slab3,slab.Slab3Per,slab.Slab4,slab.Slab4Per from pay_emptaxdetail det ");
        sb.Append(" inner join pay_taxslab_master slab on if(IsSenior=1,2,if(Gender='M',1,0))=slab.Description ");
        sb.Append(" where IsPost=1 and IsTaxable=1 and det.FinYearFrom='" + FromDate + "' and det.FinYearTo='" + ToDate + "'");
        if (txtEmployeeID.Text.Trim() != "")
        {
            sb.Append(" and EmployeeID='" + txtEmployeeID.Text.Trim() + "'");
        }
        else
        {
            if (ddlReportType.SelectedIndex == 1)
            {
                sb.Append(" and TotalTaxpayable >0");
            }
            if (ddlReportType.SelectedIndex == 2)
            {
                sb.Append(" and TotalTaxpayable = 0");
            }
        }
        sb.Append(" order by EmployeeID ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        //DataTable dt2 = StockReports.GetDataTable("select * from pay_taxslab_master where FinYearFrom='" + FromDate + "' and FinYearTo='"+ToDate+"'");
        DataSet ds = new DataSet();
        //ds.Tables.Add(dt2.Copy());
        //ds.Tables[0].TableName = "TaxSlab";
        ds.Tables.Add(dt.Copy());
        //ds.Tables[0].TableName = "EmpTax";

        if (ds.Tables[0].Rows.Count > 0)
        {
            //ds.WriteXmlSchema("C:/IncomeTaxYearly.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "IncomeTaxYearly";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Payroll/Report/Commonreport.aspx');", true);
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            MonthDate.Text = DateTime.Now.ToString("MMM-yyyy");
            txtEmployeeID.Attributes.Add("onKeyPress", "doClick('" + btnSearch.ClientID + "',event)");
        }
        txtFromDate.Attributes.Add("readonly", "true");
        txtToDate.Attributes.Add("readonly", "true");
        MonthDate.Attributes.Add("readonly", "true");
    }

    protected void rbtnReportType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rbtnReportType.SelectedIndex == 0)
        {
            MonthDate.Visible = true;
            lblDate.Visible = true;
            ddlFrom.Visible = false;
            ddlTo.Visible = false;

            lblFromDate.Visible = false;
            lblTo.Visible = false;
            txtFromDate.Visible = false;
            txtToDate.Visible = false;
            ddlFrom.Visible = false;
            ddlTo.Visible = false;
            txtEmployeeID.Visible = false;
            lblEmpID.Visible = false;
            labReportType.Visible = false;
            ddlReportType.Visible = false;
        }
        else if (rbtnReportType.SelectedIndex == 1)
        {
            MonthDate.Visible = false;
            lblDate.Visible = false;
            lblFromDate.Visible = true;
            lblTo.Visible = true;
            txtFromDate.Visible = true;
            txtToDate.Visible = true;
            ddlFrom.Visible = false;
            ddlTo.Visible = false;
            txtEmployeeID.Visible = false;
            lblEmpID.Visible = false;
            labReportType.Visible = false;
            ddlReportType.Visible = false;
        }
        else if (rbtnReportType.SelectedIndex == 2)
        {
            MonthDate.Visible = false;
            lblDate.Visible = false;

            lblFromDate.Visible = false;
            lblTo.Visible = false;
            txtFromDate.Visible = false;
            txtToDate.Visible = false;
            txtEmployeeID.Visible = true;
            lblEmpID.Visible = true;
            ddlFrom.Visible = true;
            ddlTo.Visible = true;
            labReportType.Visible = true;
            ddlReportType.Visible = true;
        }
        else if (rbtnReportType.SelectedIndex == 3)
        {
            MonthDate.Visible = false;
            lblDate.Visible = false;
            lblFromDate.Visible = false;
            lblTo.Visible = false;
            txtFromDate.Visible = false;
            txtToDate.Visible = false;
            //txtEmployeeID.Visible = false;
            //lblEmpID.Visible = false;
            txtEmployeeID.Visible = true;
            lblEmpID.Visible = true;
            ddlFrom.Visible = true;
            ddlTo.Visible = true;
            labReportType.Visible = true;
            ddlReportType.Visible = true;
        }
        else if (rbtnReportType.SelectedIndex == 4)
        {
            MonthDate.Visible = false;
            lblDate.Visible = false;
            lblFromDate.Visible = false;
            lblTo.Visible = false;
            txtFromDate.Visible = false;
            txtToDate.Visible = false;
            //txtEmployeeID.Visible = false;
            //lblEmpID.Visible = false;
            txtEmployeeID.Visible = false;
            lblEmpID.Visible = false;
            ddlFrom.Visible = false;
            ddlTo.Visible = false;
            labReportType.Visible = false;
            ddlReportType.Visible = false;
        }
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

    private void IncomeTax27A()
    {
        DataTable dt = StockReports.GetDataTable("select Form_Number,concat(substring(Assessment_Yr,1,4),'-20',substring(Assessment_Yr,5,6)) Assessment_Yr,concat(substring(Financial_Yr,1,4),'-20',substring(Financial_Yr,5,6))Financial_Yr,TAN_of_Deductor,PAN_of_Deductor,Name_of_Employer,Employer_Branch,Employer_Address1,Employer_Address2,Employer_Address3,Employer_Address4,Employer_Address5,Employer_State,Employer_PIN,Employer_Email_ID,Employer_Deductors_STD,Employer_Tel_PhoneNo,Name_of_Person_responsible_for_paying_salary,Designation_of_Person_responsible_for_paying_salary,Responsible_Persons_Address1,Responsible_Persons_Address2,Responsible_Persons_Address3,Responsible_Persons_Address4,Responsible_Persons_Address5,Responsible_Persons_State,Responsible_Persons_PIN,Responsible_Persons_EmailID,Responsible_Persons_STD,Responsible_Persons_Phone, Batch_Total_of_Gross_Total_Income_as_per_Salary_Detail,if(Period='Q1',concat('01-Apr-',substring(Financial_Yr,1,4)),if(Period='Q2',concat('01-Jul-',substring(Financial_Yr,1,4)),if(Period='Q3',concat('01-Oct-',substring(Financial_Yr,1,4)),if(Period='Q4',concat('01-Jan-','20',substring(Financial_Yr,5,6)),''))))FromDate,if(Period='Q1',concat('30-Jun-',substring(Financial_Yr,1,4)),if(Period='Q2',concat('30-Sep-',substring(Financial_Yr,1,4)),if(Period='Q3',concat('31-Dec-',substring(Financial_Yr,1,4)),if(Period='Q4',concat('31-Mar-',20,substring(Financial_Yr,5,6)),''))))ToDate from pay_tds_batch_header_record ");
        if (dt.Rows.Count > 0)
        {
            DataTable dt1 = new DataTable();
            dt1 = StockReports.GetDataTable("select count(*),sum(Amount_of_Payment)TotalAmountPaid,sum(Total_Tax_Deposited)TaxDeducted from pay_tds_employee_deduction_detail");
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            ds.Tables[0].TableName = "Table1";
            ds.Tables.Add(dt1.Copy());
            //ds.WriteXmlSchema("C:/IncomeTax27A.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "IncomeTax27A";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Payroll/Report/Commonreport.aspx');", true);
        }
    }

    private void IncomeTaxForm16()
    {
        string FromDate = ddlFrom.SelectedItem.Text + "-4-1";
        string ToDate = ddlTo.SelectedItem.Text + "-3-31";

        System.Text.StringBuilder sb = new System.Text.StringBuilder();
        sb.Append(" select 	EmployeeID,Name,Designation,DOJ,PAN,(GBasic+GNPA+GHRA+Allowance+Encashment_Leave+TaxableConvenyance+GDA+Bonus)Gross,GBasic,GNPA,GHRA,Allowance,Encashment_Leave,2_5th,RentExcess,Taxable_HRA, ");
        sb.Append(" RentAccomodation,Furniture,Rent_Concessions,Electricity,GrossSalary,((RentAccomodation+Furniture+Rent_Concessions+Electricity))Perquisites,OtherIncome,  ");
        sb.Append(" MedicalClaim,HomeLoanInterst,GrossTotalIncome,PF,PPF,LIC,ULIP,NSC,HouseLoan,GSLI,U_S80U,U_S80E,  ");
        sb.Append(" TutionFee,BONDS,LifeInsurance,Rebate,NetIncome, ");
        sb.Append(" TaxPayable,EduCess,TotalTaxpayable,TaxAlreadyPaid,Balance,DATE_FORMAT(det.FinYearFrom,'%Y'),DATE_FORMAT(det.FinYearTo,'%Y') from pay_emptaxdetail det  ");
        sb.Append(" where IsPost=1 and IsTaxable=1 and det.FinYearFrom='" + FromDate + "' and det.FinYearTo='" + ToDate + "' ");

        if (txtEmployeeID.Text.Trim() != "")
        {
            sb.Append(" and EmployeeID='" + txtEmployeeID.Text.Trim() + "'");
        }
        else
        {
            if (ddlReportType.SelectedIndex == 1)
            {
                sb.Append(" and TotalTaxpayable >0");
            }
            if (ddlReportType.SelectedIndex == 2)
            {
                sb.Append(" and TotalTaxpayable = 0");
            }
        }
        sb.Append(" order by EmployeeID ");
        DataTable dt = StockReports.GetDataTable(sb.ToString()).Copy();
        int from = Util.GetInt(ddlTo.SelectedItem.Text);
        int to = Util.GetInt(ddlTo.SelectedItem.Text) + 1;
        string query = "select EmployeeID,QuarterNo,AcknowledgementNo,FromYr,ToYr,AssessmentYear from pay_emptaxdetail tax inner join pay_tax_acknowledge ack  where AssessmentYear='" + from + "-" + to + "' ";
        if (txtEmployeeID.Text.Trim() != "")
        {
            query += " and EmployeeID='" + txtEmployeeID.Text.Trim() + "'";
        }
        query += " order by EmployeeID,QuarterNo";
        DataTable dt1 = StockReports.GetDataTable(query).Copy();

        sb.Remove(0, sb.Length);

        //sb.Append(" select sal.EmployeeID,Round((ifnull(Amount,0)+ifnull(TaxAmount,0)*100)/(3+100))TDS,ifnull(Amount,0)+ifnull(TaxAmount,0)-Round((ifnull(Amount,0)+ifnull(TaxAmount,0)*100)/(3+100)) EduCess,ifnull(Amount,0)+ifnull(TaxAmount,0) TaxDeposit,DepositDate TaxDepositDate,Cheque_DD_No CheckNo,BankCode BSR_Code_of_Bank, ChallanNo ChalanNo from (  ");
        sb.Append(" select sal.EmployeeID,((ifnull(Amount,0)+ifnull(TaxAmount,0))*100)/103 TDS,ifnull(Amount,0)+ifnull(TaxAmount,0)-((ifnull(Amount,0)+ifnull(TaxAmount,0))*100)/103 EduCess,ifnull(Amount,0)+ifnull(TaxAmount,0) TaxDeposit,DepositDate TaxDepositDate,Cheque_DD_No CheckNo,BankCode BSR_Code_of_Bank, ChallanNo ChalanNo from (   ");
        sb.Append(" select mst.EmployeeID,SalaryMonth,Amount,MasterID from pay_empsalary_master mst inner join pay_empsalary_detail det  ");
        sb.Append(" on mst.ID=det.MasterID and TYpeID=16 and Amount>0 and Date(SalaryMonth)>='" + FromDate + "' and Date(SalaryMonth)<='" + ToDate + "')sal  ");
        sb.Append(" left join (select MasterID,EmployeeID,PaidSalaryMonth,sum(TaxAmount)TaxAmount from pay_incentive_detail where IsPaid=1 group by employeeID,PaidSalaryMonth) inc on inc.MasterID=sal.MasterID  ");
        sb.Append(" left join pay_tax_challan tds on Month(sal.SalaryMOnth)=Month(tds.SalaryMonth) and Year(sal.SalaryMOnth)=Year(tds.SalaryMonth)   ");

        if (txtEmployeeID.Text.Trim() != "")
        {
            sb.Append(" and sal.EmployeeID='" + txtEmployeeID.Text.Trim() + "'");
        }
        DataTable dt2 = StockReports.GetDataTable(sb.ToString()).Copy();

        sb.Remove(0, sb.Length);

        DataSet ds = new DataSet();
        ds.Tables.Add(dt);
        ///employee tax detail (wrong name EmpLoanDetail)
        ds.Tables[0].TableName = "EmpLoanDetail";
        DataColumn dc = new DataColumn("AmountInWord");
        ds.Tables[0].Columns.Add(dc);
        for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
        {
            ds.Tables[0].Rows[i]["AmountInWord"] = changeNumericToWords(Convert.ToInt32(ds.Tables[0].Rows[i]["TotalTaxPayable"]));
        }

        ds.Tables.Add(dt1);
        ds.Tables[1].TableName = "Acknowledgement";

        ds.Tables.Add(dt2);
        ds.Tables[2].TableName = "TdsDetailMonthly";

        if (ds.Tables[0].Rows.Count > 0)
        {
            // ds.WriteXmlSchema("C:/IncomeTaxForm16.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "IncomeTaxForm16";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Payroll/Report/Commonreport.aspx');", true);
        }
    }
}