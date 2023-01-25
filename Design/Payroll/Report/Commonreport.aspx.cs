using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using CrystalDecisions.CrystalReports.Engine;

public partial class Design_Payroll_Commonreport : System.Web.UI.Page
{


    protected void Page_Load(object sender, EventArgs e)
    {

        if (Request.QueryString.Count == 0 && Util.GetString(Request.QueryString["access"]) == "")
        {
            Response.Redirect(Request.RawUrl + "?access=" + Util.getHash());
        }
        else if (Request.QueryString.Count > 0 && Util.GetString(Request.QueryString["access"]) == "")
        {
            Response.Redirect(Request.RawUrl + "&access=" + Util.getHash());
        }
        string cmd = Util.GetString(Request.QueryString["cmd"]);


        ReportDocument obj1 = new ReportDocument();
        DataSet ds = new DataSet();

        ds = (DataSet)Session["ds"+cmd];
        string ReportName = "";
        string ReportFormat = "";
        if (Session["ReportName" + cmd] != null)
        {
            ReportName = Session["ReportName" + cmd].ToString();
            if (Session["PrintType"] != null)
            {
                ReportFormat = Session["PrintType"].ToString();
            }
            Session.Remove("ReportName" + cmd);
            Session.Remove("ds" + cmd);
            Session.Remove("PrintType");

            switch (ReportName)
            {

                case "LoanEMI_Report":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/EMI_Report.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }
                case "SalarySlip":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/SalarySlip.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }
                case "ConfirmationLetter":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/Confirmationletter.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    }
                case "RelievingLetter":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/Relievingletter.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    }
                case "IncomeTax27A":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/IncomeTax27A.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }
                case "EmployeeSignList":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/EmployeeSignList.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }


                case "DeptWiseSalary":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/DepartmentWiseSalary.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }
                case "All_Dept_SalaryDetail":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/All_Dept_SalaryDetail.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }
                case "BankLetter":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/BankLetter.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }
                case "ESI_Monthly":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/ESI_Monthly.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }
                case "ESI_DateWise":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/ESI_DateWise.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }
                case "LoanOS":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/LoanOS.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }
                case "LoanEMI":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/LoanEMI.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }
                case "LoanDetail":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/LoanDetail.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }
                case "IncomeTax":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/IncomeTax.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }
                case "Miscellaneous":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/Miscellaneous.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }
                case "PFMonthly":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/PFMonthly.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }
                case "IncomeTaxYearly":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/IncomeTaxYearly.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }
                case "IncomeTaxDetail":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/IncomeTaxDetail.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }
                case "Electricity":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/Electricity.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }
                case "Accomodation":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/Accomodation.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }
                case "Security":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/Security.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }
                case "DeptWiseEmpSalary":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/DepartmentWiseEmp.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }
                case "CashSalaryDetail":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/CashSalary.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }
                case "PF_Form3A":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/PF_3A.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }
                case "SalarySlipDeptWise":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/SalarySlipDeptWise.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }
                case "AdvanceOS":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/AdvanceOS.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }
                case "AdvanceEmi":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/AdvanceEmi.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }
                case "AgeReport":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/AgeReport.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }
                case "UnPayedSalary":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/UnPayedSalary.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }
                case "IncrementReport":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/IncrementReport.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }
                case "Remuneration":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/Remuneration.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }
                case "Attendanc":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/Attendanc.rpt"));

                        obj1.SetDataSource(ds); 
                        break;
                        
                    }
                case "EmployeeReport":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/EmployeeReport.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }
                case "EmployeeReportDesi":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/EmployeeReportDesi.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }
                case "IncomeTaxForm16":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/IncomeTaxForm16.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }
                case "IncentiveDetail":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/IncentiveDetail.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }
                case "PF_Form6A":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/PF_Form6A.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }
                case "IncrementComparsionReport":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/IncrementComparsionReport.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }
                case "SecurityOS":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/SecurityOS.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }
                case "GSLI":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/GSLIReport.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }
                case "BioData":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/BioData.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }
                case "Dependent":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/DependentReport.rpt"));

                        obj1.SetDataSource(ds);
                        break;
                    }
                case "OfferLetter":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/OfferLetter.rpt"));
                        obj1.SetDataSource(ds);
                        break;

                    }
                case "ArrearReport":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/ArrearReport.rpt"));
                        obj1.SetDataSource(ds);
                        break;

                    }
                case "OverTime":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/OverTime.rpt"));
                        obj1.SetDataSource(ds);
                        break;

                    }
                case "OfferletterReport":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/OfferletterReport.rpt"));
                        obj1.SetDataSource(ds);
                        break;

                    }
                case "AppointmentLetter":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/AppointmentLetter.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    }
                case "AppointmentLetter2":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/AppointmentLetter2.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    }
                case "AppointmentLetter3":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/AppointmentLetter3.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    }
                case "AppointmentLetter4":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/AppointmentLetter4.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    }
                case "FnF":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/Fullfinalsetelement.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    }

                case "NoDuesForm":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/NoDuesForm.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    }
                case "LeaveReport":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/LeaveReport.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    }
                case "LeaveReportDetail":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/LeaveReportDetail.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    }
                case "LeaveApplication":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/Leave_Application_form.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    }
                case "LeaveCard":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/LeaveCard.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    }
                case "DeptCensus":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/Department_Census.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    }
                case "DeptVerify":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/Employee_Verify_report.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    }
                case "DeptCensusDetail":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/DeptCensusDetail.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    }
                case "EmployeeSatisfaction":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/EmployeeSatisfaction.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    }
                case "ManPower":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/ManPower.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    }
                case "Appraisal":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/Appraisal.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    }
                case "AppraisalEvaluation":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/AppraisalEvaluation.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    }
                case "AppraisalGraph":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/AppraisalGraph.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    }
                case "Experience_LetterNew":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/Experience_LetterNew.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    }
                case "RenewalLetter":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/RenewalLetter.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    }
                case "SalarySheetNormal":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/SalarySheetNormal.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    }
                case "SSNITEmployee":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/SSNITReport.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    }
                case "AppointmentAcceptanceLetter":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/AppointmentAcceptanceLetter.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    }
                case "ManPowerRequisitionForm":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/EmployeeRequisitionForm.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    }
                case "SSNITEmployer":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/SSNITEmployer.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    }
                case "IncomTaxForm55":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/IncomTaxForm55.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    }
                case "NewSalarySlip":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/NewSalarySlip.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    }
                case "EmpVerificationPrint":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/EmpVerification.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    }
                case "payClassSummary":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/payClassSummary.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    }
                case "AccomodationReport":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/AccomodationReport.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    }
                case "CandidateApplicationForm":
                    {
                        obj1.Load(Server.MapPath(@"~/Design/Payroll/Report/CandidateApplicationForm.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    } 
            }
        }
        if (ReportFormat == "ExpToWord")
        {

            System.IO.MemoryStream m = (System.IO.MemoryStream)obj1.ExportToStream(CrystalDecisions.Shared.ExportFormatType.WordForWindows);
            obj1.Close();
            obj1.Dispose();
            Response.ClearContent();
            Response.ClearHeaders();
            Response.Buffer = true;
            Response.ContentType = "application/msword";
            Response.BinaryWrite(m.ToArray());
            m.Flush();
            m.Close();
            m.Dispose();
        }
        else
        {

            System.IO.MemoryStream m = (System.IO.MemoryStream)obj1.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
            obj1.Close();
            obj1.Dispose();
            Response.ClearContent();
            Response.ClearHeaders();
            Response.Buffer = true;
            Response.ContentType = "application/pdf";
            Response.BinaryWrite(m.ToArray());
            m.Flush();
            m.Close();
            m.Dispose();
        
        }
    }
}
    


    
