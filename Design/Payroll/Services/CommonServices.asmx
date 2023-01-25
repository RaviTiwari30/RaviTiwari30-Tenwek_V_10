<%@ WebService Language="C#" Class="CommonServices" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using MySql.Data.MySqlClient;
using System.Data;
using System.Web.Script.Services;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using System.Text;
using System.Xml.Serialization;
using System.IO.Compression;
using System.IO;


[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
[ScriptService]
public class CommonServices : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }

    [WebMethod]
    public string BindDepartment()
    {
        DataTable dt = AllLoadDate_Payroll.dtDepartmentPayroll();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetIFSCCode(string BranchID)
    {
        string str = "select distinct IFSC_Code  from pay_branchmaster where Branch_ID='" + BranchID + "'  order by IFSC_Code asc";
        DataTable dtBranch = StockReports.GetDataTable(str);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtBranch);

    }


    [WebMethod]
    public string LoadCentre()
    {
        string str = "SELECT CentreID, CentreName FROM center_master WHERE isactive=1 ORDER BY CentreName";
        DataTable dt = StockReports.GetDataTable(str);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }
    [WebMethod]
    public string LoadBloodBankBloodGroup()
    {
        string str = "SELECT ID, BloodGroup Name FROM bb_bloodgroup_master WHERE isactive=1 ORDER BY bloodgroup";
        DataTable dt = StockReports.GetDataTable(str);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }

    [WebMethod]
    public string LoadDrivingLiscenceType()
    {
        string str = "SELECT ID, Name FROM t_drivingLiscenceType_master WHERE isactive=1 ORDER BY Name";
        DataTable dt = StockReports.GetDataTable(str);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }

    [WebMethod]
    public string bindEmployeeDetail(string EmployeeID)
    {
        DataTable dtEmpDetail = StockReports.GetDataTable("select Concat(em.Title,'',em.Name)Name,Fathername,desi_name,Experience,Responsibility,(TotalEarning+TotalDeduction)MonthlyCTC ,IFNULL(ic.OfferedCTC,0)OfferedCTC,IFNULL(ic.Otherbenifits,0)Otherbenifits, IFNULL((ic.OfferedCTC+ic.Otherbenifits),0)totalOffered,RegNo  from Employee_Master em LEFT JOIN pay_interviewcandidate ic ON ic.EmployeeID=em.EmployeeID where em.EmployeeID='" + EmployeeID + "'");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtEmpDetail);
    }

    [WebMethod]
    public string bindEmployeesalary(string EmployeeID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT rem.ID,Remun_ID,RemunerationHead,rem.CalType,rem.RemunerationType,IFNULL(Amount,0)Amount,formula,formula_text  ");
        sb.Append("FROM (SELECT ID,Remun_ID,NAME as RemunerationHead,CalType,IF(RemunerationType='E','Earning','Deduction')RemunerationType,Sequence_No,formula,formula_text   ");
        sb.Append("FROM pay_Remuneration_master  WHERE IsActive=1 AND IsLoan=0 AND isCTC=0 AND IsInitial=0)rem  ");
        sb.Append("LEFT JOIN pay_employeeremuneration emprem ON rem.ID=emprem.TypeID AND EmployeeID='" + EmployeeID + "'  ORDER BY Sequence_No ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public string BindQualification()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("Select ID,Qualification from pay_qualification_master where ISActive=1"));
    }
    [WebMethod]
    public string bindEmployeeQualification(string EmployeeID)
    {
        string str = "SELECT Emp_Qualification as Qualification,Emp_Quli_Year as QualiYear,Emp_Quali_Insit as Institute FROM Pay_Emp_Qulification_Detail WHERE IsActive=1 AND EmployeeID='" + EmployeeID + "'";
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(str));
    }

    [WebMethod]
    public string bindEmployeePrevOrganisation(string EmployeeID)
    {
        string str = "SELECT Employer,DATE_FORMAT(StartDate,'%d-%b-%Y')StartDate,DATE_FORMAT(EndDate,'%d-%b-%Y')EndDate,Designation,JobDescription AS jobProfile FROM pay_emp_PreviousOrganisation WHERE IsActive=1 AND EmployeeID='" + EmployeeID + "' "; ;
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(str));
    }

    [WebMethod]
    public string bindEmployeeProfessionalDtl(string EmployeeID)
    {
        string str = "SELECT Regi_No AS Regno,DATE_FORMAT(DATE,'%d-%b-%Y')FromDate,DATE_FORMAT(ValidDate,'%d-%b-%Y')Validupto FROM pay_emp_professionaldetail WHERE IsActive=1 AND EmployeeID='" + EmployeeID + "' ";
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(str));
    }
    [WebMethod]
    public string BindUserGroup()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(" select Name,ID,if(IsActive=1,'Yes','No')IsActive,NoticeDays,ProbationDays from Employee_Group_master order by Name"));
    }

    [WebMethod]
    public string BindUserType()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(" select Name,ID,if(IsActive=1,'Yes','No')IsActive from Employee_Type_master order by Name"));
    }

    [WebMethod]
    public string BindInterViewRound()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(" select Name,ID,if(IsActive=1,'Yes','No')IsActive from Pay_InterViewRound order by Name"));
    }
    
    [WebMethod]
    public string bindJobType()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(" select Name,ID,if(IsActive=1,'Yes','No')IsActive from Pay_JobType order by Name"));
    }

    [WebMethod]
    public string BindEmployeeList()
    {
        DataTable dt = AllLoadDate_Payroll.dtEmployeePayroll();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public string BindDesignation()
    {
        DataTable dt = AllLoadDate_Payroll.dtDesignationPayroll();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public string bindInterViewInvolvedEmployees()
    {
        string str = "SELECT EmployeeID,CONCAT(Title,'',NAME)NAME FROM employee_master em WHERE IsInvolveinInterViewProcess=1 AND em.isactive=1 ";
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(str));

    }
    [WebMethod(EnableSession = true)]
    public string getUserAuthorisation()
    {
        string RoleId = HttpContext.Current.Session["RoleID"].ToString();
        string EmpId = HttpContext.Current.Session["ID"].ToString();
        DataTable dt = StockReports.GetAuthorization(Util.GetInt(RoleId), Util.GetString(EmpId));

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public string SearchSelectedCandidates(string fromdate, string todate, string desig,string SearchType)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("SELECT ic.ID,DATE_FORMAT(InterviewDate,'%d-%b-%Y')InterviewDate,CONCAT(ic.Title,ic.FirstName,' ',ic.LastName)CName, ic.Mobile, ic.Email,hr.FinalRemarks ,em.Name Finaliseby,ds.Designation_Name,dm.Dept_Name,IsOfferLetterGenerated,DATE_FORMAT(JoiningDate,'%d-%b-%Y')JoiningDate,ifnull(ic.EmployeeID,'')EmployeeID ");
        sb.Append("FROM pay_interviewcandidate ic ");
        sb.Append("Left JOIN pay_interview_hr_acknowledge hr ON ic.id=hr.CandidateID INNER JOIN pay_designation_master ds ON ds.Des_ID=ic.DesigID INNER JOIN pay_deptartment_master dm  ON dm.Dept_ID= ic.DeptID ");
        sb.Append("Left JOIN employee_master em ON em.EmployeeID=ic.EntryBy ");
        sb.Append("WHERE  ic.JoiningDate >='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + "'  AND ic.JoiningDate<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + "'  ");
        if (desig != "0")
            sb.Append("AND ic.DesigID='" + desig + "'");
        if (SearchType == "1")
            sb.Append(" AND ic.IsOfferLetterApprove=1 ");
        sb.Append(" and ic.CentreID =" + Util.GetInt(HttpContext.Current.Session["CentreID"]) + "");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true)]
    public string SearchCandidateDetails(string CandidateID, string isPrint)
    {
        StringBuilder sb = new StringBuilder();
   
        sb.Append("SELECT ic.ID,DeptID,DesigID,Title,FirstName,LastName,Date_format(DOB,'%d-%b-%Y')DOB,Gender,Mobile,ic.Address,Email, ");
        sb.Append("Remarks,InterviewRoundStatus,HRAcknowledgeStatus,Date_format(RelievingDate,'%d-%b-%Y')RelievingDate,CurrentMonthlyCTC,ExpectedMonthlyCTC, ");
        sb.Append("TotalExp,JobprofileExp,OfferedCTC,Date_format(JoiningDate,'%d-%b-%Y')JoiningDate,Date_format(OfferLetterDate,'%d-%b-%Y')OfferLetterDate,Otherbenifits,JoiningCentreID ,ds.Designation_Name,cm.CentreName,ic.OfferValidDate ");
        sb.Append("FROM pay_interviewcandidate ic INNER JOIN pay_designation_master ds ON ic.DesigID=ds.Des_ID INNER JOIN center_master cm ON cm.CentreID= ic.JoiningCentreID WHERE ID='" + CandidateID + "' "); ;
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (isPrint == "0")     
             return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
        {
            if (dt.Rows.Count > 0)
            {
                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());
             //   ds.WriteXmlSchema(@"D:\OfferLetter.xml");
                HttpContext.Current.Session["ds"] = ds;
                HttpContext.Current.Session["ReportName"] = "OfferLetter";
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, responseURL = "../Payroll/Report/Commonreport.aspx" });
            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { response="No Record Found" });
            }
        }
    }

    [WebMethod(EnableSession=true)]
    public string BindAllActiveEmployees(string DeptID, string DesigID)
    {
        string str = "SELECT em.EmployeeID,em.EmployeeID,RegNo FROM employee_master em ";
        str += "inner join centre_access ca on ca.EmployeeID = em.EmployeeId and ca.CentreAccess= " + Util.GetInt(HttpContext.Current.Session["CentreID"]) + "  and ca.IsActive=1 ";
        str += "WHERE em.isactive=1 ";
        if(DeptID!="0")
            str += " AND Dept_ID=" + DeptID;
        if(DesigID!="0")
            str += " AND Desi_ID=" + DesigID;
        str += " Order by em.ID ";
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(str));
    }

    [WebMethod]
    public string getProbationPeriod(string EmpID)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.ExecuteScalar("SELECT eg.ProbationDays FROM employee_master em INNER JOIN employee_group_master eg ON eg.ID= em.Employee_Group_ID WHERE em.EmployeeID='" + EmpID + "' "));
    }

    [WebMethod]
    public string BindDepartmentHead(int DeptID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT emp.`EmployeeID`,EmployeeRequired,IF(pdm.IsActive=1,'Yes','No')IsActive,emp.NAME,pdm.`DeptHeadID` FROM employee_master emp LEFT JOIN pay_deptartment_master pdm ON emp.`Dept_ID`=pdm.`Dept_ID` WHERE pdm.`Dept_ID`=" + DeptID + "");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public string BindGrade()
    {
        DataTable dt = AllLoadDate_Payroll.dtGradePay();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public string BindDesignationIVRoundMap(int DesiID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT map.MapID,iv.ID,if(map.IsActive=1,'Yes','No')IsActive, dm.Designation_Name,iv.`Name`,map.Des_ID FROM pay_designation_IVRound_Mapping map ");
        sb.Append(" INNER JOIN Pay_designation_master dm ON dm.`Des_ID`=map.`Des_ID` INNER JOIN Pay_InterViewRound iv ON iv.`ID`=map.`IVRoundID` ");
        sb.Append(" WHERE map.IsActive=1 ");
        if (DesiID != 0)
        {
            sb.Append(" AND map.Des_ID=" + DesiID + " ");
        }
        sb.Append(" ORDER BY iv.Sequence ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public string GetLastSeqNum()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT IFNULL(MAX(Sequence+1),0)'Sequence' FROM pay_Document_Master");

        string str = Util.GetString(StockReports.ExecuteScalar(sb.ToString()));
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = str });
    }

    [WebMethod]
    public string GetDepratmentHeadID(int DeptID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT IFNULL(DeptHeadID,0)DeptHeadID FROM pay_deptartment_master WHERE Dept_ID=" + DeptID + "");

        string str = Util.GetString(StockReports.ExecuteScalar(sb.ToString()));
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = str });
    }

    [WebMethod]
    public string BindDocumentMaster()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT dm.`DocID`,dm.`Doc_Name`,dm.`Description`,dm.`Sequence`,IF(dm.`IsActive`=1,'Yes','No')'IsActive' FROM pay_Document_Master dm");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public string BindDocumentForMap()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT DocID,Doc_Name FROM pay_Document_Master");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public string BindDesignationDocumentMap(int DesiID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT ddm.`MapDocID`,ddm.`Des_ID`,ddm.`DocID`,dm.`Designation_Name`,pdm.`Doc_Name` FROM pay_designation_Document_Mapping ddm ");
        sb.Append(" INNER JOIN Pay_designation_master dm ON dm.`Des_ID`=ddm.`Des_ID` INNER JOIN `pay_document_master` pdm ON pdm.`DocID`=ddm.`DocID` ");
        sb.Append(" WHERE ddm.`IsActive`=1 ");
        if (DesiID != 0)
        {
            sb.Append(" AND ddm.`Des_ID`=" + DesiID + " ");
        }

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    
    
    [WebMethod]
    public string BindDesignationtableinMaster()
    {
        string Designation = "select Des_ID,Designation_Name,Grade from Pay_designation_master order by Designation_Name";
        DataTable dt = StockReports.GetDataTable(Designation);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    
    [WebMethod]
    public string BindDepartmenttableinMaster()
    {
        string Department = "select Dept_ID,Dept_Name,EmployeeRequired,IF(IsActive=1,'Yes','No')IsActive from Pay_deptartment_master";//where IsActive=1
        DataTable dt = StockReports.GetDataTable(Department);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public string bindEmployeeBasicDetails(string EmpID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("Call Get_Employee_Basicdetails_ByEmpID('" + EmpID + "')");
        
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));

    }
    [WebMethod]
    public string bindEmployeeAdvanceStatus(string EmpID)
    {
        string str = "SELECT IFNULL(SUM(ad.AdvanceAmount),0)AdvanceAmount,IFNULL(SUM(ad.RecievedAmount),0)RecievedAmount,IFNULL(SUM(ad.PendingAmount),0)PendingAmount,IF(ad.IsApproved=0,'Pending',IF(ad.IsApproved=1,'Approved',IF(ad.IsApproved=2,'Rejected','')))AdvanceStatus,ad.IsApproved FROM Pay_EmployeeAdvance ad WHERE EmployeeID='" + EmpID + "' AND ad.IsActive=1";
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(str));
    }
    [WebMethod]
    public string BindRatingMaster()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT rm.`ID`,rm.`RatingDetails`,IF(rm.`IsActive`=1,'Yes','No')'IsActive' FROM pay_employeeratingmaster rm");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
}