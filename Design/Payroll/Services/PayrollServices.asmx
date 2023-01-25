<%@ WebService Language="C#" Class="PayrollServices" %>

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
public class PayrollServices : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string getBranch(string BankID)
    {
        string str = "select distinct BranchName,Branch_ID from pay_branchmaster where Bank_ID='" + BankID + "'  order by BranchName asc";
        DataTable dtBranch = StockReports.GetDataTable(str);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtBranch);

    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string CurrentDate()
    {

        return System.DateTime.Now.ToString("dd-MMM-yyyy");
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public decimal getExperience(string Grade, string LeaveName)
    {
        return Util.GetDecimal(StockReports.ExecuteScalar("select IFNULL(MAX((Experience_To)+0.1),0)Experience_To from pay_leavemaster where Grade='" + Grade + "' and Name='" + LeaveName + "'  "));

    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindRemuneration()
    {
        DataTable dt = StockReports.GetDataTable("select ID,Name,IF(RemunerationType='E','Earnings','Deductions')RemunerationType,CalType,if(IsActive=1,'Yes','No')IsActive,AmtPer,Sequence_No from pay_Remuneration_master order by Sequence_No");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);


    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string addRemuneration(string Remuneration, string RemunerationName, string CalType, string calamtper, string SequenceNo)
    {
        int i = Util.GetInt(StockReports.ExecuteScalar("select count(*) from pay_Remuneration_master where Name='" + RemunerationName + "'"));
        if (i > 0)
            return "0";

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            //string str = "insert into pay_Remuneration_master(Name,RemunerationType,CalType,AmtPer)values('" + RemunerationName.Trim().ToUpper().Replace("'", "''") + "','" + Remuneration + "','" + CalType + "','" + Util.GetDecimal(calamtper) + "') ";
            //MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str);
            string str = "insert into pay_Remuneration_master(Name,RemunerationType,Sequence_No)values(@Name,@RemunerationType,@SequenceNo);SELECT @@identity;";
            var ID = excuteCMD.ExecuteScalar(tnx, str, CommandType.Text, new
            {
                Name = RemunerationName.Trim().ToUpper().Replace("'", "''"),
                RemunerationType = Remuneration,
                SequenceNo = Util.GetInt(SequenceNo),
            });

            string sqlCMD = "Update pay_Remuneration_master set Remun_ID=concat('LSHHI',ID) where ID=@ID";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                ID = ID
            });
            tnx.Commit();
            return "1";
        }

        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string updateRemuneration(string RemunerationID, string RemunerationName, string RemunerationType, string CalType, string Active, string calamtper, string SequenceNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int i = Util.GetInt(StockReports.ExecuteScalar("select count(*) from pay_Remuneration_master where Name='" + RemunerationName + "' and ID<>'" + Util.GetInt(RemunerationID) + "'"));
            if (i > 0)
                return "0";

            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "update pay_Remuneration_master set Name='" + RemunerationName.Trim().Replace("'", "''") + "',RemunerationType='" + RemunerationType + "',CalType='" + CalType + "',IsActive='" + Active + "',AmtPer='" + Util.GetDecimal(calamtper) + "',Sequence_No='" + Util.GetInt(SequenceNo) + "' where ID=" + RemunerationID + " ");
            tnx.Commit();
            return "1";
        }

        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string deleteRemuneration(string RemunerationID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "update pay_Remuneration_master set IsActive=0 where ID='" + RemunerationID + "' ");
            tnx.Commit();
            return "1";
        }

        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string CTCCalculation()
    {
        DataTable dt = StockReports.GetDataTable("select rm.ID,rm.Name,IF(rm.RemunerationType='E','Earnings','Deductions')RemunerationType,rm.CalType,IFNULL(psm.isfix,'')isFix,IFNULL(psm.calculateTypeID,'')calculateTypeID," +
        " IFNULL(IF(psm.Percentage>0,Percentage,FixAmount),'')Amount from pay_Remuneration_master rm " +
            " LEFT JOIN pay_salarycalculation_master psm ON psm.RemunerationID=rm.ID  where rm.IsActive=1");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true, Description = "Save CTCCalculation")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string saveCTC(object Remuneration)
    {
        List<Remuneration> remuneration = new JavaScriptSerializer().ConvertToType<List<Remuneration>>(Remuneration);
        if (remuneration.Count > 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "DELETE from pay_salarycalculation_master");


                for (int i = 0; i < remuneration.Count; i++)
                {
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO pay_salarycalculation_master(RemunerationID,calType,Percentage,FixAmount,IsFix,CalculateTypeID  " +
                        " )VALUE('" + remuneration[i].RemunerationID + "','" + remuneration[i].calType + "','" + Util.GetDecimal(remuneration[i].Percentage) + "', " +
                        " '" + Util.GetDecimal(remuneration[i].FixAmount) + "','" + remuneration[i].IsFix + "','" + remuneration[i].CalCulateTypeID + "' )");

                }

                tranX.Commit();
                return "1";

            }



            catch (Exception ex)
            {

                tranX.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return "0";
            }
            finally
            {
                tranX.Dispose();
                con.Close();
                con.Dispose();
            }
        }

        else
        {
            return "";
        }

    }
    public class Remuneration
    {
        public string RemunerationID { get; set; }
        public string calType { get; set; }
        public string Percentage { get; set; }
        public string FixAmount { get; set; }
        public int CalCulateTypeID { get; set; }
        public int IsFix { get; set; }

    }

    [WebMethod(EnableSession = true)]
    public string SaveSalary(salarymaster salary, List<salaryItems> SalaryItems)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            string Query = "delete from pay_employeeremuneration where EmployeeID=@EmployeeID";
            excuteCMD.DML(tnx, Query, CommandType.Text, new
              {
                  EmployeeID = salary.EmployeeID,
              });

            for (int i = 0; i < SalaryItems.Count; i++)
            {
                string sqlCMD = "insert into pay_employeeremuneration (EmployeeID,TypeID,TypeName,Amount,CalType,RemunerationType,UserID) values(@EmployeeID,@HeadID,@HeadName,@Amount,@CalType,@HeadType,@UserID)";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    EmployeeID = salary.EmployeeID,
                    HeadID = Util.GetInt(SalaryItems[i].HeadID),
                    HeadName = SalaryItems[i].HeadName,
                    Amount = Util.GetDecimal(SalaryItems[i].Amount),
                    CalType = "AMT",
                    HeadType = SalaryItems[i].HeadType == "Earning" ? "E" : "D",
                    UserID = HttpContext.Current.Session["ID"].ToString()
                });
            }

            Query = "UPDATE Employee_Master SET TotalEarning=@totalEarning,TotalDeduction=@totalDeduction WHERE EmployeeID=@EmployeeID";
            excuteCMD.DML(tnx, Query, CommandType.Text, new
            {
                EmployeeID = salary.EmployeeID,
                totalEarning = salary.TotalEarning,
                totalDeduction = salary.TotalDeduction.Replace("-", "")
            });
            tnx.Commit();

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
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
    public class salarymaster
    {
        public string EmployeeID { get; set; }
        public string EmpName { get; set; }
        public string MonthlyCTC { get; set; }
        public string AnnualCTC { get; set; }
        public string TotalEarning { get; set; }
        public string TotalDeduction { get; set; }
        public string NetTotal { get; set; }
    }
    public class salaryItems
    {
        public string HeadID { get; set; }
        public string HeadName { get; set; }
        public string HeadType { get; set; }
        public string Amount { get; set; }
    }


    [WebMethod(EnableSession = true)]
    public string NewQualification(string Qualification)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM pay_qualification_master where Qualification='" + Qualification + "' "));
            if (count > 0)
                return "0";
            else
            {

                string s = "INSERT INTO pay_qualification_master(Qualification,CreatedBy) values(@Qualification,@CreatedBy)";
                excuteCMD.DML(tnx, s, CommandType.Text, new
                {
                    Qualification = Qualification,
                    CreatedBy = HttpContext.Current.Session["ID"].ToString(),
                });
                tnx.Commit();
                return Util.GetString(StockReports.ExecuteScalar("SELECT MAX(ID) FROM pay_qualification_master"));

            }
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "";
        }

    }

    public class EmpProfData
    {
        public string EmployeeID { get; set; }
        public string Experience { get; set; }
        public string Responsibility { get; set; }
        public string Resume { get; set; }
    }

    public class EmployeeEducationQualification
    {
        public string Qualification { get; set; }
        public string Year { get; set; }
        public string Institute { get; set; }
    }
    public class EmployeePreviousOrganisation
    {
        public string Employer { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public string Designation { get; set; }
        public string Description { get; set; }
    }
    public class EmployeeProfessionalDetails
    {
        public string RegNo { get; set; }
        public string Date { get; set; }
        public string Validupto { get; set; }
    }

    private object DeSerializeObject(object myObject, Type objectType)
    {
        var xmlSerial = new XmlSerializer(objectType);
        var xmlStream = new StringReader(myObject.ToString());
        return xmlSerial.Deserialize(xmlStream);
    }

    [WebMethod(EnableSession = true)]
    public string SaveEmployeeProfDetails(EmpProfData Empdata, List<EmployeeEducationQualification> EduQual, List<EmployeePreviousOrganisation> PrevOrg, List<EmployeeProfessionalDetails> ProfDtl)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var EmployeeID = Empdata.EmployeeID;
            //Payroll_EmployeeRegistration objEmp = new Payroll_EmployeeRegistration();
            //var DeserializeData = DeSerializeObject(HttpContext.Current.Session["RegistrationObject"], objEmp.GetType());
            //objEmp = (Payroll_EmployeeRegistration)DeserializeData;
            //string name = objEmp.Name.ToString();
            //objEmp.Experience = Util.GetFloat(Empdata.Experience);
            //objEmp.Responsibility = Util.GetString(Empdata.Responsibility);
            //objEmp.Resume = "";
            //String EmployeeID = objEmp.InsertEmployeeMaster();


            if (!String.IsNullOrEmpty(EmployeeID))
            {
                string sqlCMD = "";

                sqlCMD = "Update Employee_Master set Experience=@Experience,Responsibility=@Responsibility,Resume=@Resume where EmployeeID = @EmpID";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    Experience = Empdata.Experience,
                    Responsibility = Empdata.Responsibility,
                    Resume = "",
                    EmpID = Empdata.EmployeeID
                });

                for (int i = 0; i < EduQual.Count; i++)
                {
                    sqlCMD = "Insert into Pay_Emp_Qulification_Detail (EmployeeID,Emp_Qualification,Emp_Quli_Year,Emp_Quali_Insit,CreateBy) values(@EmployeeID,@Qualification,@Year,@Institute,@UserID)";
                    excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                    {
                        Qualification = EduQual[i].Qualification,
                        Year = EduQual[i].Year,
                        Institute = EduQual[i].Institute,
                        UserID = HttpContext.Current.Session["ID"].ToString(),
                        EmployeeID = EmployeeID,

                    });
                }

                for (int i = 0; i < PrevOrg.Count; i++)
                {
                    sqlCMD = "Insert into pay_emp_PreviousOrganisation (EmployeeID,Employer,StartDate,EndDate,Designation,JobDescription,CreatedBy) values(@EmployeeID,@Employer,@StartDate,@EndDate,@Designation,@JobDescription,@UserID)";
                    excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                    {
                        Employer = PrevOrg[i].Employer,
                        StartDate = Util.GetDateTime(PrevOrg[i].StartDate).ToString("yyyy-MM-dd"),
                        EndDate = Util.GetDateTime(PrevOrg[i].EndDate).ToString("yyyy-MM-dd"),
                        Designation = PrevOrg[i].Designation,
                        JobDescription = PrevOrg[i].Description,
                        UserID = HttpContext.Current.Session["ID"].ToString(),
                        EmployeeID = EmployeeID,

                    });
                }

                for (int i = 0; i < ProfDtl.Count; i++)
                {
                    sqlCMD = "Insert into pay_emp_professionaldetail (EmployeeID,Regi_No,Date,ValidDate,CreatedBy) Values (@EmployeeID,@Regi_No,@Date,@ValidDate,@UserID)";
                    excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                    {
                        Regi_No = ProfDtl[i].RegNo,
                        Date = Util.GetDateTime(ProfDtl[i].Date).ToString("yyyy-MM-dd"),
                        ValidDate = Util.GetDateTime(ProfDtl[i].Validupto).ToString("yyyy-MM-dd"),
                        UserID = HttpContext.Current.Session["ID"].ToString(),
                        EmployeeID = EmployeeID,
                    });
                }
            }

            tnx.Commit();

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, employeeid = EmployeeID, response = "Record Saved Successfully<br/>Employee ID: " + EmployeeID }); ;
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public string UpdateEmployeeProfDetails(EmpProfData Empdata, List<EmployeeEducationQualification> EduQual, List<EmployeePreviousOrganisation> PrevOrg, List<EmployeeProfessionalDetails> ProfDtl)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            string sqlCMD = " update Employee_Master set Experience=@Experience,Responsibility=@Responsibility where EmployeeID =@EmployeeID";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                Experience = Empdata.Experience,
                Responsibility = Empdata.Responsibility,
                EmployeeID = Empdata.EmployeeID,
            });

            // Update Employee Education Qualification Details

            sqlCMD = "Update Pay_Emp_Qulification_Detail set IsActive=0 where EmployeeID=@EmployeeID";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                EmployeeID = Empdata.EmployeeID,
            });
            for (int i = 0; i < EduQual.Count; i++)
            {
                sqlCMD = "Insert into Pay_Emp_Qulification_Detail (EmployeeID,Emp_Qualification,Emp_Quli_Year,Emp_Quali_Insit,CreateBy) values(@EmployeeID,@Qualification,@Year,@Institute,@UserID)";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    Qualification = EduQual[i].Qualification,
                    Year = EduQual[i].Year,
                    Institute = EduQual[i].Institute,
                    UserID = HttpContext.Current.Session["ID"].ToString(),
                    EmployeeID = Empdata.EmployeeID,

                });
            }

            // Update Employee Professional Details 
            sqlCMD = "Update pay_emp_PreviousOrganisation set IsActive=0 where EmployeeID=@EmployeeID";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                EmployeeID = Empdata.EmployeeID,
            });
            for (int i = 0; i < PrevOrg.Count; i++)
            {
                sqlCMD = "Insert into pay_emp_PreviousOrganisation (EmployeeID,Employer,StartDate,EndDate,Designation,JobDescription,CreatedBy) values(@EmployeeID,@Employer,@StartDate,@EndDate,@Designation,@JobDescription,@UserID)";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    Employer = PrevOrg[i].Employer,
                    StartDate = Util.GetDateTime(PrevOrg[i].StartDate).ToString("yyyy-MM-dd"),
                    EndDate = Util.GetDateTime(PrevOrg[i].EndDate).ToString("yyyy-MM-dd"),
                    Designation = PrevOrg[i].Designation,
                    JobDescription = PrevOrg[i].Description,
                    UserID = HttpContext.Current.Session["ID"].ToString(),
                    EmployeeID = Empdata.EmployeeID,

                });
            }


            // Update Employee Professional Details
            sqlCMD = "Update pay_emp_professionaldetail set IsActive=0 where EmployeeID=@EmployeeID";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                EmployeeID = Empdata.EmployeeID,
            });
            for (int i = 0; i < ProfDtl.Count; i++)
            {
                sqlCMD = "Insert into pay_emp_professionaldetail (EmployeeID,Regi_No,Date,ValidDate,CreatedBy) Values (@EmployeeID,@Regi_No,@Date,@ValidDate,@UserID)";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    Regi_No = ProfDtl[i].RegNo,
                    Date = Util.GetDateTime(ProfDtl[i].Date).ToString("yyyy-MM-dd"),
                    ValidDate = Util.GetDateTime(ProfDtl[i].Validupto).ToString("yyyy-MM-dd"),
                    UserID = HttpContext.Current.Session["ID"].ToString(),
                    EmployeeID = Empdata.EmployeeID,
                });
            }

            tnx.Commit();

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Update Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }



    [WebMethod(EnableSession = true)]
    public string SaveUserGroup(string UserGroupID, string SaveType, string Name, string ProbationDays, string NoticeDays, string IsActive)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        string message = string.Empty;
        try
        {

            if (SaveType == "Save")
            {
                var isExists = Util.GetInt(StockReports.ExecuteScalar("select count(*) from Employee_Group_master where Name ='" + Name + "'"));
                if (isExists > 0)
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Name Already Exists" });
                }
                string str = "insert into Employee_Group_master(Location,HospCode,Name,Creator_ID,Creator_Date,ProbationDays,NoticeDays,IsActive)values(@Location,@HospCode,@Name,@Creator_ID,@Creator_Date,@ProbationDays,@NoticeDays,@IsActive);SELECT @@identity;";
                var ID = excuteCMD.ExecuteScalar(tnx, str, CommandType.Text, new
                {
                    Location = "L",
                    HospCode = "SHHI",
                    Name = Name,
                    Creator_ID = HttpContext.Current.Session["ID"].ToString(),
                    Creator_Date = System.DateTime.Now,
                    ProbationDays = Util.GetInt(ProbationDays),
                    NoticeDays = Util.GetInt(NoticeDays),
                    IsActive = Util.GetInt(IsActive),
                });
                str = "UPdate Employee_Group_master set User_Type_ID =concat(Location,HospCode,ID) where ID =@ID";
                excuteCMD.DML(tnx, str, CommandType.Text, new
                {
                    ID = ID
                });
                message = "Record Save Successfully";
            }
            else if (SaveType == "Update")
            {
                var isExists = Util.GetInt(StockReports.ExecuteScalar("select count(*) from Employee_Group_master where Name ='" + Name + "' and User_Type_ID<>'" + UserGroupID + "' ")); ;
                if (isExists > 0)
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Name Already Exists" });
                }

                string str = "UPDATE Employee_Group_master SET NAME =@Name,ProbationDays =@ProbationDays,NoticeDays =@NoticeDays,IsActive =@IsActive WHERE User_Type_ID =@USerGroupID;";
                excuteCMD.DML(tnx, str, CommandType.Text, new
                {
                    Name = Name,
                    ProbationDays = Util.GetInt(ProbationDays),
                    NoticeDays = Util.GetInt(NoticeDays),
                    IsActive = Util.GetInt(IsActive),
                    USerGroupID = UserGroupID
                });

                message = "Record Update Successfully";
            }
            tnx.Commit();

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message });


        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }


    [WebMethod(EnableSession = true)]
    public string SaveUserType(string UserTypeID, string SaveType, string Name, string IsActive)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        string message = string.Empty;
        try
        {

            if (SaveType == "Save")
            {
                var isExists = Util.GetInt(StockReports.ExecuteScalar("select count(*) from Employee_Type_master where Name ='" + Name + "'"));
                if (isExists > 0)
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Name Already Exists" });
                }
                string str = "insert into Employee_Type_master(Name,CreatedBy,IsActive)values(@Name,@CreatedBy,@IsActive);";
                excuteCMD.DML(tnx, str, CommandType.Text, new
                {
                    Name = Name,
                    CreatedBy = HttpContext.Current.Session["ID"].ToString(),
                    IsActive = Util.GetInt(IsActive),
                });

                message = "Record Save Successfully";
            }
            else if (SaveType == "Update")
            {
                var isExists = Util.GetInt(StockReports.ExecuteScalar("select count(*) from Employee_Type_master where Name ='" + Name + "' and ID<>'" + UserTypeID + "' ")); ;
                if (isExists > 0)
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Name Already Exists" });
                }

                string str = "UPDATE Employee_Type_master SET NAME =@Name,IsActive =@IsActive WHERE ID =@UserTypeID;";
                excuteCMD.DML(tnx, str, CommandType.Text, new
                {
                    Name = Name,
                    IsActive = Util.GetInt(IsActive),
                    UserTypeID = UserTypeID
                });

                message = "Record Update Successfully";
            }
            tnx.Commit();

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message });


        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }



    [WebMethod(EnableSession = true)]
    public string SaveInterViewRound(string ID, string SaveType, string Name, string IsActive, int Sequence)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        string message = string.Empty;
        try
        {

            if (SaveType == "Save")
            {
                var isExists = Util.GetInt(StockReports.ExecuteScalar("select count(*) from Pay_InterViewRound where Name ='" + Name + "'"));
                if (isExists > 0)
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Name Already Exists" });
                }

                var IsSequenceExists = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM Pay_InterViewRound WHERE Sequence=" + Sequence + ""));
                if (IsSequenceExists > 0)
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Sequence Already Exists" });
                }

                string str = "insert into Pay_InterViewRound(Name,CreatedBy,IsActive,Sequence)values(@Name,@CreatedBy,@IsActive,@Sequence);";
                excuteCMD.DML(tnx, str, CommandType.Text, new
                {
                    Name = Name,
                    CreatedBy = HttpContext.Current.Session["ID"].ToString(),
                    IsActive = Util.GetInt(IsActive),
                    Sequence = Sequence,
                });

                message = "Record Save Successfully";
            }
            else if (SaveType == "Update")
            {
                var isExists = Util.GetInt(StockReports.ExecuteScalar("select count(*) from Pay_InterViewRound where Name ='" + Name + "' and ID<>'" + ID + "' ")); ;
                if (isExists > 0)
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Name Already Exists" });
                }

                var IsSequenceExists = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM Pay_InterViewRound WHERE Sequence=" + Sequence + " AND ID<>" + ID + ""));
                if (IsSequenceExists > 0)
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Sequence Already Exists" });
                }

                string str = "UPDATE Pay_InterViewRound SET NAME =@Name,IsActive =@IsActive,Sequence=@Sequence WHERE ID =@UserTypeID;";
                excuteCMD.DML(tnx, str, CommandType.Text, new
                {
                    Name = Name,
                    IsActive = Util.GetInt(IsActive),
                    UserTypeID = ID,
                    Sequence = Sequence,
                });

                message = "Record Update Successfully";
            }
            tnx.Commit();

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message });


        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }


    [WebMethod(EnableSession = true)]
    public string SaveJobType(string ID, string SaveType, string Name, string IsActive)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        string message = string.Empty;
        try
        {

            if (SaveType == "Save")
            {
                var isExists = Util.GetInt(StockReports.ExecuteScalar("select count(*) from Pay_JobType where Name ='" + Name + "'"));
                if (isExists > 0)
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Name Already Exists" });
                }
                string str = "insert into Pay_JobType(Name,CreatedBy,IsActive)values(@Name,@CreatedBy,@IsActive);";
                excuteCMD.DML(tnx, str, CommandType.Text, new
                {
                    Name = Name,
                    CreatedBy = HttpContext.Current.Session["ID"].ToString(),
                    IsActive = Util.GetInt(IsActive),
                });

                message = "Record Save Successfully";
            }
            else if (SaveType == "Update")
            {
                var isExists = Util.GetInt(StockReports.ExecuteScalar("select count(*) from Pay_JobType where Name ='" + Name + "' and ID<>'" + ID + "' ")); ;
                if (isExists > 0)
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Name Already Exists" });
                }

                string str = "UPDATE Pay_JobType SET NAME =@Name,IsActive =@IsActive WHERE ID =@UserTypeID;";
                excuteCMD.DML(tnx, str, CommandType.Text, new
                {
                    Name = Name,
                    IsActive = Util.GetInt(IsActive),
                    UserTypeID = ID
                });

                message = "Record Update Successfully";
            }
            tnx.Commit();

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message });


        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

        [WebMethod(EnableSession = true)]
    public string SearchPersonnelRequest(string FromDate, string ToDate, string DeptName, string status)
    {
        string str = "SELECT ID,DATE_FORMAT(RequestDate,'%d-%b-%Y')RequestDate,Department AS ReqFrom,Designation AS ReqFor,TYPE AS ReqType,Reason AS ReqReason, VacNo,Status ";

        str += " ";
        str += " FROM pay_manpower WHERE requestDate>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND requestDate<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ";
        str += " and CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"]) + " ";
        if (DeptName != "")
            str += " and Department ='" + DeptName + "'";
        if (status != "0")
        {
            str += " AND IF('" + status + "' = '1',Status='Forward',IF('" + status + "'='2',Status='Finalise', IF('" + status + "'='3', Status='Reject',1=1)) ) ";
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(str));
    }

    [WebMethod(EnableSession = true)]
    public string RejectPersonnelRequest(string reqID, string remarks)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();

        try
        {
            string sqlCMD = "Update pay_ManPower set Status=@IsReject where ID =@reqID";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                IsReject = "Reject",
                reqID = reqID,
            });

            sqlCMD = "insert into pay_ManPowerForwardDtl(RequestID,ForwardedBy,ForwardedTo,ForwardRemarks,Status) values(@RequestID,@ForwardedBy,@ForwardedTo,@ForwardRemarks,@Status)";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                Status = "Reject",
                ForwardedTo = "",
                ForwardedBy = HttpContext.Current.Session["ID"].ToString(),
                ForwardRemarks = remarks,
                RequestID = reqID
            });

            tnx.Commit();

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Request Rejected Successfully" });

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public string SaveFinalise(string reqID, string remarks)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();

        try
        {
            string sqlCMD = "Update pay_ManPower set Status=@IsFinalise where ID =@reqID";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                IsFinalise = "Finalise",
                reqID = reqID,
            });
            sqlCMD = "insert into pay_ManPowerForwardDtl(RequestID,ForwardedBy,ForwardedTo,ForwardRemarks,Status) values(@RequestID,@ForwardedBy,@ForwardedTo,@ForwardRemarks,@Status)";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                Status = "Finalise",
                ForwardedTo = "",
                ForwardedBy = HttpContext.Current.Session["ID"].ToString(),
                ForwardRemarks = remarks,
                RequestID = reqID
            });
            tnx.Commit();

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Request Finalise Successfully" });

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public string SaveApprovalForwardRequestApproval(string reqID, string ForwardtoEmpID, string remarks)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();

        try
        {
            int isForwarded = Util.GetInt(StockReports.ExecuteScalar("Select count(*) from pay_ManPowerForwardDtl where RequestID='" + reqID + "' and ForwardedTo= '" + ForwardtoEmpID + "'"));
            if (isForwarded > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Request alreay forwarded to this Employee", });
            }

            DataTable dtForID = StockReports.GetDataTable("SELECT ID FROM pay_ManPowerForwardDtl WHERE requestID=" + reqID + " AND STATUS='forward' AND isCancel=0");
            if (dtForID.Rows.Count > 0)
            {
                foreach (DataRow dr in dtForID.Rows)
                {
                    string st = "Update pay_ManPowerForwardDtl set isCancel=@isCancel where ID =@ID";
                    excuteCMD.DML(tnx, st, CommandType.Text, new
                    {
                        isCancel = "1",
                        ID = dr["ID"].ToString(),
                    });
                }
            }

            string sqlCMD = "Update pay_ManPower set Status=@IsForwarded where ID =@reqID";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                IsForwarded = "Forward",
                reqID = reqID,
            });

            sqlCMD = "insert into pay_ManPowerForwardDtl(RequestID,ForwardedBy,ForwardedTo,ForwardRemarks,Status) values(@RequestID,@ForwardedBy,@ForwardedTo,@ForwardRemarks,@Status)";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                Status = "Forward",
                ForwardedTo = ForwardtoEmpID,
                ForwardedBy = HttpContext.Current.Session["ID"].ToString(),
                ForwardRemarks = remarks,
                RequestID = reqID
            });
            tnx.Commit();

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Request Approved & Forward Successfully" });

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }



    [WebMethod(EnableSession = true)]
    public string ReprintPersonnelForm(string reqID)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();

        try
        {
            string sqlCMD = "Update pay_manpower set IsRead=@IsRead WHERE id=@reqID";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                IsRead = '1',
                reqID = reqID,
            });
            tnx.Commit();

            string strQry = "";
            string id = "";
            strQry = "SELECT ID,DocNo,DATE_FORMAT(RequestDate,'%d-%b-%y')RequestDate,TYPE,Department,Designation,Reason,VacNo,IF(UrgentDate='0001-01-01 00:00:00','',DATE_FORMAT(UrgentDate,'%d-%b-%y'))UrgentDate, " +
                     " IF(UrgentDate='0001-01-01 00:00:00','No','Yes')IfUrgent ,ExistEmp,ReportingTo,MinEduQual,ResAreas,REPLACE(MinExp,'#',' ')MinExp,REPLACE(MaxExp,'#',' ')MaxExp,Required, " +
                     " RequesterDesignation,EmployementType,PositionBudgeted,PositionInformation,DeptHead,CheafAdmin,CheafExecutive,COMMENT,IF(Livingdate='0001-01-01 00:00:00','',DATE_FORMAT(Livingdate,'%d-%b-%y'))Livingdate FROM pay_manpower WHERE id=" + reqID + "";
            DataTable dt = StockReports.GetDataTable(strQry);
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            //ds.WriteXmlSchema("C:/ManPowerRequisitionForm.xml");
            HttpContext.Current.Session["ds"] = ds;
            HttpContext.Current.Session["ReportName"] = "ManPowerRequisitionForm";
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, responseURL = "../Payroll/Report/Commonreport.aspx" });

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession=true)]
    public string SearchInterView(string FromDate, string ToDate, string DeptName)
    {
        string str = "SELECT ID,DATE_FORMAT(RequestDate,'%d-%b-%Y')RequestDate,Department AS ReqFrom,Designation AS ReqFor,TYPE AS ReqType,Reason AS ReqReason, VacNo ,isInterviewClose,ReqforDeptID,ReqForDesigID ";
        str += " FROM pay_manpower WHERE requestDate>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND requestDate<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' and Status='Finalise' ";
        if (DeptName != "")
            str += " and Department ='" + DeptName + "'";
        str += " and CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"]);
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(str));
    }

    [WebMethod]
    public string SearchInterViewRoundDetails(string reqID, string CandidateID, string desigID)
    {
        string str = "SELECT pir.ID roundID,NAME,IFNULL(pird.ID,0)SavedRoundID,IFNULL(pird.InterviewerID,'')InterviewerID,(SELECT CONCAT(title,NAME) FROM employee_master WHERE EmployeeID=pird.InterviewerID)InterviewerName,IFNULL(IF(pird.RoundStatus=1,'Selected',IF(pird.RoundStatus=2,'Not-Selected',IF(pird.RoundStatus=3,'Hold',''))),'')RoundStatus,IFNULL(pird.Remarks,'')Remarks,ifnull(pird.RoundStatus,0)Status ";
        str += "FROM pay_interviewround pir ";
        str += "INNER JOIN pay_designation_ivround_mapping pirm ON pirm.IVRoundID=pir.ID AND pirm.isActive=1 AND pirm.Des_ID=" + desigID + " ";
        str += "LEFT JOIN pay_interviewrounddetails pird ON pir.ID=pird.InterviewRoundID AND pird.RequestID='" + reqID + "' AND candidateID=" + CandidateID + " WHERE pir.IsActive=1"; ;
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(str));
    }
    [WebMethod]
    public string ViewPersonnelFormProcessDetail(string reqID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT p.status AS 'Status', ");
        sb.Append("CONCAT(title,'',em.name)ForwardedBy, ");
        sb.Append("(SELECT CONCAT(title,'',name)NAME FROM Employee_master WHERE EmployeeID = forwardedto)ForwardedTo, ");
        sb.Append("DATE_FORMAT(p.ForwardedDateTime,'%d-%b-%Y %h:%i:%p')`DateTIme`,CONCAT(ForwardRemarks,'',IF(iscancel=1,'-Cancelled',''))ForwardRemarks, ");
        sb.Append("DATE_FORMAT(pm.RequestDate,'%d-%b-%Y')RequstDate, ");
        sb.Append("(SELECT NAME FROM Employee_master WHERE EmployeeID = pm.userID )RaisedBy, ");
        sb.Append("pm.Department,pm.Designation ");
        sb.Append(" ");
        sb.Append("FROM  pay_ManPowerForwardDtl p ");
        sb.Append("INNER JOIN pay_manpower pm ON p.RequestID=pm.ID ");
        sb.Append("INNER JOIN employee_master em ON p.ForwardedBy=em.EmployeeID ");
        sb.Append("WHERE p.RequestID='" + reqID + "' "); ;

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public string SaveInterViewCandidateEntry(cm Candidatemaster)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();

        try
        {
            var JoiningDate = "";
            var OfferDate = "";
            var OfferValidDate = "";
            int JoiningCentreID = 0;
            int IsOfferLetterGenerated = 0;
            if (Candidatemaster.IsDirectOfferLetter == "1")
            {
                JoiningDate = Util.GetDateTime(Candidatemaster.JoiningDate).ToString("yyyy-MM-dd");
                OfferDate = Util.GetDateTime(Candidatemaster.OfferLetterDate).ToString("yyyy-MM-dd");
                JoiningCentreID = Util.GetInt(Candidatemaster.JoiningCentreID);
                IsOfferLetterGenerated = 1;
                OfferValidDate = Util.GetDateTime(Candidatemaster.OfferValidDate).ToString("yyyy-MM-dd");
            }
            else
            {
                JoiningDate = "0001-01-01";
                OfferDate = "0001-01-01";
                OfferValidDate = "0001-01-01";
                JoiningCentreID = Util.GetInt(HttpContext.Current.Session["CentreID"]);
                IsOfferLetterGenerated = 0;

            }

            string sqlCMD = "INSERT INTO pay_interviewcandidate ( RequestID, Title, FirstName, LastName, DOB, Gender, Mobile, Address, Email, ResumeURL, EntryBy, CentreID, InterviewDate, Remarks,RelievingDate,CurrentMonthlyCTC,ExpectedMonthlyCTC,TotalExp,JobprofileExp,DeptID,DesigID,JoiningCentreID,JoiningDate,OfferLetterDate,OfferedCTC,OtherBenifits,IsDirectOfferLetter,IsOfferLetterGenerated,OfferLetterBy,OffLetEntryDateTime,OfferValidDate)";
            sqlCMD += "VALUES (@RequestID,@Title,@FirstName,@LastName,@DOB,@Gender,@Mobile,@Address,@Email,@ResumeURL,@EntryBy,@CentreID,@InterviewDate,@Remarks,@RelievingDate,@CurrentMonthlyCTC,@ExpectedMonthlyCTC,@TotalExp,@JobprofileExp,@DeptID,@DesigID,@JoiningCentreID,@JoiningDate,@OfferLetterDate,@OfferedCTC,@OtherBenifits,@IsDirectOfferLetter,@IsOfferLetterGenerated,@OfferLetterBy,@OffLetEntryDateTime,@OfferValidDate);SELECT @@identity;";
            var CandidateID = excuteCMD.ExecuteScalar(tnx, sqlCMD, CommandType.Text, new
                {
                    RequestID = Candidatemaster.RequestID,
                    Title = Candidatemaster.Title,
                    FirstName = Candidatemaster.FirstName,
                    LastName = Candidatemaster.LastName,
                    DOB = Util.GetDateTime(Candidatemaster.DOB).ToString("yyyy-MM-dd"),
                    Gender = Candidatemaster.Gender,
                    Mobile = Candidatemaster.Mobile,
                    Address = Candidatemaster.Address,
                    Email = Candidatemaster.Email,
                    ResumeURL = Candidatemaster.ResumePath,
                    EntryBy = HttpContext.Current.Session["ID"].ToString(),
                    CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"]),
                    InterviewDate = Util.GetDateTime(Candidatemaster.InterviewDate).ToString("yyyy-MM-dd"),
                    Remarks = Candidatemaster.Remarks,
                    RelievingDate = Util.GetDateTime(Candidatemaster.RelievingDate).ToString("yyyy-MM-dd"),
                    CurrentMonthlyCTC = Candidatemaster.CurrentMonthlyCTC,
                    ExpectedMonthlyCTC = Candidatemaster.ExpectedMonthlyCTC,
                    TotalExp = Candidatemaster.TotalExp,
                    JobprofileExp = Candidatemaster.JobprofileExp,
                    DeptID = Candidatemaster.DeptID,
                    DesigID = Candidatemaster.DesigID,
                    JoiningCentreID = JoiningCentreID,
                    JoiningDate = Util.GetDateTime(JoiningDate).ToString("yyyy-MM-dd"),
                    OfferLetterDate = Util.GetDateTime(OfferDate).ToString("yyyy-MM-dd"),
                    OfferedCTC = Util.GetInt(Candidatemaster.OfferedCTC),
                    OtherBenifits = Util.GetInt(Candidatemaster.OtherBenifits),
                    IsDirectOfferLetter = Candidatemaster.IsDirectOfferLetter,
                    OfferValidDate = OfferValidDate,
                    IsOfferLetterGenerated = IsOfferLetterGenerated,
                    OfferLetterBy = HttpContext.Current.Session["ID"].ToString(),
                    OffLetEntryDateTime = Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd HH:mm:ss"),
                });

            tnx.Commit();

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Save Successfully", CandidateID = CandidateID });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }



    [WebMethod(EnableSession = true)]
    public string UpdateInterViewCandidateEntry(cm Candidatemaster)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();

        try
        {
            var JoiningDate = "";
            var OfferDate = "";
            int JoiningCentreID = 0;
            int IsOfferLetterGenerated = 0; var OfferValidDate = "";
            if (Candidatemaster.IsDirectOfferLetter == "1")
            {
                JoiningDate = Util.GetDateTime(Candidatemaster.JoiningDate).ToString("yyyy-MM-dd");
                OfferDate = Util.GetDateTime(Candidatemaster.OfferLetterDate).ToString("yyyy-MM-dd");
                JoiningCentreID = Util.GetInt(Candidatemaster.JoiningCentreID);
                IsOfferLetterGenerated = 1;
                OfferValidDate = Util.GetDateTime(Candidatemaster.OfferValidDate).ToString("yyyy-MM-dd");
            }
            else
            {
                JoiningDate = "0001-01-01";
                OfferDate = "0001-01-01";
                OfferValidDate = "0001-01-01";
                JoiningCentreID = Util.GetInt(HttpContext.Current.Session["CentreID"]);
                IsOfferLetterGenerated = 0;
            }

            string sqlCMD = "UPDATE pay_interviewcandidate SET DeptID = @DeptID, DesigID = @DesigID, Title = @Title, FirstName = @FirstName, LastName = @LastName, ";
            sqlCMD += " DOB = @DOB, Gender = @Gender, Mobile = @Mobile, Address = @Address, Email = @Email, EntryBy = @EntryBy, Remarks = @Remarks, ";
            sqlCMD += " RelievingDate = @RelievingDate, CurrentMonthlyCTC = @CurrentMonthlyCTC, ExpectedMonthlyCTC = @ExpectedMonthlyCTC, TotalExp = @TotalExp, JobprofileExp = @JobprofileExp, ";
            sqlCMD += " OfferedCTC = @OfferedCTC, JoiningDate = @JoiningDate, OfferLetterDate = @OfferLetterDate, Otherbenifits = @Otherbenifits, JoiningCentreID = @JoiningCentreID,IsOfferLetterGenerated=@IsOfferLetterGenerated,OfferValidDate=@OfferValidDate WHERE ID = @ID;";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    Title = Candidatemaster.Title,
                    FirstName = Candidatemaster.FirstName,
                    LastName = Candidatemaster.LastName,
                    DOB = Util.GetDateTime(Candidatemaster.DOB).ToString("yyyy-MM-dd"),
                    Gender = Candidatemaster.Gender,
                    Mobile = Candidatemaster.Mobile,
                    Address = Candidatemaster.Address,
                    Email = Candidatemaster.Email,
                    EntryBy = HttpContext.Current.Session["ID"].ToString(),
                    Remarks = Candidatemaster.Remarks,
                    RelievingDate = Util.GetDateTime(Candidatemaster.RelievingDate).ToString("yyyy-MM-dd"),
                    CurrentMonthlyCTC = Candidatemaster.CurrentMonthlyCTC,
                    ExpectedMonthlyCTC = Candidatemaster.ExpectedMonthlyCTC,
                    TotalExp = Candidatemaster.TotalExp,
                    JobprofileExp = Candidatemaster.JobprofileExp,
                    DeptID = Candidatemaster.DeptID,
                    DesigID = Candidatemaster.DesigID,
                    JoiningCentreID = JoiningCentreID,
                    JoiningDate = Util.GetDateTime(JoiningDate).ToString("yyyy-MM-dd"),
                    OfferLetterDate = Util.GetDateTime(OfferDate).ToString("yyyy-MM-dd"),
                    OfferedCTC = Util.GetInt(Candidatemaster.OfferedCTC),
                    OtherBenifits = Util.GetInt(Candidatemaster.OtherBenifits),
                    IsOfferLetterGenerated = IsOfferLetterGenerated,
                    OfferValidDate = OfferValidDate,
                    ID = Candidatemaster.CandidateID,
                });

            tnx.Commit();

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Save Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    public class cm
    {
        public string RequestID { get; set; }
        public string InterviewDate { get; set; }
        public string Title { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Gender { get; set; }
        public string DOB { get; set; }
        public string Mobile { get; set; }
        public string Email { get; set; }
        public string Address { get; set; }
        public string Remarks { get; set; }
        public string ResumePath { get; set; }
        public string RelievingDate { get; set; }
        public string CurrentMonthlyCTC { get; set; }
        public string ExpectedMonthlyCTC { get; set; }
        public string TotalExp { get; set; }
        public string JobprofileExp { get; set; }

        public string DeptID { get; set; }
        public string DesigID { get; set; }
        public string JoiningCentreID { get; set; }
        public string JoiningDate { get; set; }
        public string OfferLetterDate { get; set; }
        public string OfferedCTC { get; set; }
        public string OtherBenifits { get; set; }
        public string IsDirectOfferLetter { get; set; }
        public string CandidateID { get; set; }
        public string OfferValidDate { get; set; }
    }

    [WebMethod(EnableSession = true)]
    public string SearchInterviewCandidate(string ReqID, string fromdate, string todate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT pic.ID,DATE_FORMAT(InterviewDate,'%d-%b-%Y')InterviewDate,CONCAT(pic.Title,pic.FirstName,' ',pic.LastName)CandidateName, ");
        sb.Append("CONCAT(DATE_FORMAT(pic.DOB,'%d-%b-%Y'),'/',pic.Gender)AgeSex,pic.Mobile,pic.Address,pic.Email, ");
        sb.Append("CONCAT(em.Title,'',em.Name)EntryBy,DATE_FORMAT(EntryDateTime,'%d-%b-%Y')EntryDate,Remarks,DesigID ");
        sb.Append("FROM pay_interviewcandidate pic ");
        sb.Append("INNER JOIN employee_master em ON em.EmployeeID= pic.EntryBy ");
        sb.Append("WHERE RequestID='" + ReqID + "' AND InterviewDate>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + "' AND InterviewDate<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + "' and pic.CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"]) + "");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public string SaveInterviewRoundDetails(string RoundID, string CandidateID, string RequestID, string InterViewerID, string Remarks, string Status, string SavedInterviewRoundID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();

        try
        {

            if (Util.GetInt(SavedInterviewRoundID) > 0)
            {
                // Update already saved interview round details 
                string sqlCMD = "UPDATE pay_interviewrounddetails SET InterviewerID =@InterviewerID,InterviewerEntryBy =@InterviewerEntryBy,RoundStatus =@RoundStatus,Remarks =@Remarks,RoundStatusEntryBy =@RoundStatusEntryBy,RoundStatusDateTime =@RoundStatusDateTime WHERE ID =@ID;";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    InterviewerID = InterViewerID,
                    InterviewerEntryBy = HttpContext.Current.Session["ID"].ToString(),
                    RoundStatus = Status,
                    Remarks = Remarks,
                    RoundStatusEntryBy = HttpContext.Current.Session["ID"].ToString(),
                    RoundStatusDateTime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                    ID = SavedInterviewRoundID,
                });
            }
            else
            {
                // save new round details 
                string sqlCMD = "INSERT INTO pay_interviewrounddetails (RequestID,CandidateID,InterviewRoundID,InterviewerID,InterviewerEntryBy,RoundStatus,Remarks,RoundStatusEntryBy,RoundStatusDateTime) ";
                sqlCMD += "VALUES(@RequestID,@CandidateID,@InterviewRoundID,@InterviewerID,@InterviewerEntryBy,@RoundStatus,@Remarks,@RoundStatusEntryBy,@RoundStatusDateTime); ";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    RequestID = RequestID,
                    CandidateID = CandidateID,
                    InterviewRoundID = RoundID,
                    InterviewerID = InterViewerID,
                    InterviewerEntryBy = HttpContext.Current.Session["ID"].ToString(),
                    RoundStatus = Status,
                    Remarks = Remarks,
                    RoundStatusEntryBy = HttpContext.Current.Session["ID"].ToString(),
                    RoundStatusDateTime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                });
            }

            tnx.Commit();

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Save Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public string SearchCandidateAfterInterviewRound(string reqID, string fromdate, string todate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT pic.ID,DATE_FORMAT(InterviewDate,'%d-%b-%Y')InterviewDate,CONCAT(pic.Title,pic.FirstName,' ',pic.LastName)CandidateName, ");
        sb.Append("CONCAT(DATE_FORMAT(pic.DOB,'%d-%b-%Y'),'/',pic.Gender)AgeSex,pic.Mobile,pic.Address,pic.Email, ");
        sb.Append("CONCAT(em.Title,'',em.Name)EntryBy,DATE_FORMAT(pic.EntryDateTime,'%d-%b-%Y')EntryDate,pic.Remarks,IF(pic.HRAcknowledgeStatus=1,'Selected',IF(pic.HRAcknowledgeStatus=2,'Not-Selected','Hold'))Status,pic.HRAcknowledgeStatus ");
        sb.Append("FROM pay_interviewcandidate pic ");
        sb.Append("INNER JOIN employee_master em ON em.EmployeeID= pic.EntryBy ");
        sb.Append("INNER JOIN pay_interviewrounddetails ir ON ir.CandidateID=pic.ID AND pic.RequestID=ir.RequestID ");
        sb.Append("WHERE pic.RequestID='" + reqID + "' AND InterviewDate>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + "' AND InterviewDate<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + "' GROUP BY pic.ID ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public string SaveCandidateAcknowledgeDetails(string reqID, string CandidateID, string FinalStatus, string JoiningDate, string OfferedCTC, string DocUpload, string FinalRemarks)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();

        try
        {
            string sqlCMD = "INSERT INTO pay_interview_hr_acknowledge (RequestID,CandidateID,FinalStatus,FinalRemarks,EntryBy) VALUES(@RequestID,@CandidateID,@FinalStatus,@FinalRemarks,@EntryBy);";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    RequestID = reqID,
                    CandidateID = CandidateID,
                    FinalStatus = FinalStatus,
                    FinalRemarks = FinalRemarks,
                    EntryBy = HttpContext.Current.Session["ID"].ToString(),
                });

            sqlCMD = "UPDATE pay_interviewcandidate SET HRAcknowledgeStatus=@FinalStatus,OfferedCTC = @OfferedCTC,  JoiningDate = @JoiningDate WHERE ID = @ID;";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                FinalStatus = FinalStatus,
                OfferedCTC = OfferedCTC,
                JoiningDate = Util.GetDateTime(JoiningDate).ToString("yyyy-MM-dd"),
                ID = CandidateID,

            });

            tnx.Commit();

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Save Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public string getCandidatePreviousAcknowledgerdetails(string reqID, string CandidateID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT ih.FinalRemarks,ih.FinalStatus,ic.OfferedCTC,DATE_FORMAT(ic.JoiningDate ,'%d-%b-%Y')JoiningDate FROM pay_interview_hr_acknowledge ih INNER JOIN pay_interviewcandidate ic ON ih.CandidateID=ic.ID AND ic.RequestID=ic.RequestID WHERE ih.RequestID='" + reqID + "' AND ih.CandidateID='" + CandidateID + "'"); ;
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true)]
    public string ApplyInterviewerforAllCandidate(string RoundID, string CandidateID, string RequestID, string InterViewerID, string Remarks, string Status, string SavedInterviewRoundID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();

        try
        {
            DataTable dt = StockReports.GetDataTable("SELECT id FROM pay_interviewcandidate WHERE requestid='" + RequestID + "' and ID<>'" + CandidateID + "'");
            if (dt.Rows.Count > 0)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    string str = "SELECT interviewroundid FROM pay_interviewrounddetails WHERE candidateid='" + dr["ID"].ToString() + "' AND requestID = '" + RequestID + "' AND InterviewRoundID = " + RoundID + "";
                    DataTable dtRoundIDs = StockReports.GetDataTable(str);
                    if (dtRoundIDs.Rows.Count > 0)
                    {
                        for (int j = 0; j < dtRoundIDs.Rows.Count; j++)
                        {
                            if (Util.GetString(dtRoundIDs.Rows[j]["interviewroundid"]) == Util.GetString(RoundID))
                            {
                                string sqlCMD = "UPDATE pay_interviewrounddetails SET InterviewerID =@InterviewerID,InterviewerEntryBy =@InterviewerEntryBy WHERE interviewroundid =@InterviewRoundID and RequestID =@RequestID and CandidateID=@CandidateID ";
                                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                                {
                                    InterviewerID = InterViewerID,
                                    InterviewerEntryBy = HttpContext.Current.Session["ID"].ToString(),
                                    RequestID = RequestID,
                                    CandidateID = dr["ID"].ToString(),
                                    InterviewRoundID = RoundID,
                                });
                            }
                        }
                    }
                    else
                    {
                        string sqlCMD = "INSERT INTO pay_interviewrounddetails (RequestID,CandidateID,InterviewRoundID,InterviewerID,InterviewerEntryBy) ";
                        sqlCMD += "VALUES(@RequestID,@CandidateID,@InterviewRoundID,@InterviewerID,@InterviewerEntryBy); ";
                        excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                        {
                            RequestID = RequestID,
                            CandidateID = dr["ID"].ToString(),
                            InterviewRoundID = RoundID,
                            InterviewerID = InterViewerID,
                            InterviewerEntryBy = HttpContext.Current.Session["ID"].ToString(),
                        });
                    }
                }
            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "No More Candidates for this Job" });
            }
            tnx.Commit();

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Interviewer Detail has been applied to all Candidate " });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }



    [WebMethod(EnableSession = true)]
    public string CloseJobRequestInterviewProcess(string reqID, string Remarks)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();

        try
        {
            string sqlCMD = "Update Pay_ManPower set InterviewCloseRemarks=@InterviewCloseRemarks,isInterviewClose=@isInterviewClose,InterviewCloseDateTime=@InterviewCloseDateTime,InterviewCloseBy=@InterviewCloseBy where ID =@ID";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                InterviewCloseRemarks = Remarks,
                isInterviewClose = '1',
                InterviewCloseDateTime = System.DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                InterviewCloseBy = HttpContext.Current.Session["ID"].ToString(),
                ID = reqID,
            });

            tnx.Commit();

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Save Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public string SearchOfferLetter(string SearchType, string fromdate, string todate, string candidatename, string desigid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT ic.ID,dm.Dept_Name,ds.Designation_Name,CONCAT(ic.title,ic.FirstName,' ',ic.LastName)CName,ic.Mobile,DATE_FORMAT(ic.JoiningDate,'%d-%b-%Y')JoiningDate, ");
        sb.Append("(ic.OfferedCTC+ic.Otherbenifits)Salary,DATE_FORMAT(ic.OfferLetterDate,'%d-%b-%Y')OfferLetterDate, CONCAT(em.title,NAME)GenerateBy,ic.IsOfferLetterApprove,ic.IsOfferAcceptance  ");
        sb.Append("FROM pay_interviewcandidate ic  ");
        sb.Append("INNER JOIN pay_deptartment_master dm ON dm.Dept_ID=ic.DeptID ");
        sb.Append("INNER JOIN pay_designation_master ds ON ds.Des_ID=ic.DesigID INNER JOIN employee_master em ON em.EmployeeID=ic.OfferLetterBy ");
        sb.Append("WHERE ic.IsOfferLetterGenerated=1 and ic.CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"]) + " ");
        if (SearchType == "OfferDate")
            sb.Append("AND ic.OfferLetterDate>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + "' AND ic.OfferLetterDate<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + "' ");
        else if (SearchType == "JoinDate")
            sb.Append("AND ic.JoiningDate>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + "' and ic.JoiningDate<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + "'");
        else if (SearchType == "ValidDate")
            sb.Append("AND ic.OfferValidDate>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + "' and ic.OfferValidDate<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + "'");
        if (desigid != "0")
            sb.Append("AND ic.DesigID= " + desigid + " ");
        if (!String.IsNullOrEmpty(candidatename))
            sb.Append("AND ic.FirstName LIKE '%" + candidatename + "%' "); ;
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public string SaveOfferLetterApproval(string ID, string status, string Remarks)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();

        try
        {
            string str = "UPDATE pay_interviewcandidate SET IsOfferLetterApprove =@IsOfferLetterApprove,OfferLetterApprovalDateTime =@OfferLetterApprovalDateTime,OfferLetterApprovedBy =@OfferLetterApprovedBy,OfferLetterAppRemarks =@OfferLetterAppRemarks WHERE ID =@ID;";
            excuteCMD.DML(tnx, str, CommandType.Text, new
            {
                IsOfferLetterApprove = status,
                OfferLetterApprovalDateTime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                OfferLetterApprovedBy = HttpContext.Current.Session["ID"].ToString(),
                OfferLetterAppRemarks = Remarks,
                ID = ID
            });
            tnx.Commit();

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Save Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public string SearchOfferLetterApproval(string CandidateID)
    {
        string str = "SELECT i.IsOfferLetterApprove,i.OfferLetterAppRemarks FROM  pay_interviewcandidate i WHERE ID=" + CandidateID;
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(str));
    }

    [WebMethod(EnableSession=true)]
    public string SearchAppointmentLetter(string fromdate, string todate, string deptid, string desigid, string employeeid, string empname)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT em.EmployeeID,em.RegNo,CONCAT(em.Title,em.Name)EmpName,dm.Dept_Name,ds.Designation_Name,DATE_FORMAT(em.DOJ,'%d-%b-%Y')DOJ,  ");
        sb.Append("em.Mobile,DATE_FORMAT(al.AppointmentDate,'%d-%b-%Y')AppointmentDate, ");
        sb.Append("(SELECT CONCAT(emp.Title,emp.Name) FROM employee_master emp WHERE emp.EmployeeID=al.EntryBy)AppGenerateBy,IFNULL(al.ID,'0')AppID,IsAcceptance ");
        sb.Append("FROM employee_master em ");
        sb.Append("inner join centre_access ca on ca.EmployeeID = em.EmployeeId and ca.CentreAccess= " + Util.GetInt(HttpContext.Current.Session["CentreID"]) + "  and ca.IsActive=1 ");
        sb.Append("INNER JOIN pay_deptartment_master dm ON dm.Dept_ID= em.Dept_ID ");
        sb.Append("INNER JOIN pay_designation_master ds ON ds.Des_ID=em.Desi_ID ");
        sb.Append("LEFT JOIN pay_appointmentletter al ON al.EmployeeID=em.EmployeeID ");
        sb.Append("WHERE em.isactive=1  ");
        sb.Append(" and em.DOJ>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' and em.DOJ<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        if (deptid != "0")
            sb.Append("AND em.Dept_ID=" + deptid);
        if (desigid != "0")
            sb.Append("AND em.Desi_ID=" + desigid);
        if (employeeid != "0")
            sb.Append(" AND em.EmployeeID='" + employeeid + "'");
        if (!String.IsNullOrEmpty(empname))
            sb.Append(" AND em.name like '%" + empname + "%'");
        sb.Append(" order by em.EmployeeID ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public string SaveAppointmentLetter(string AppID, string EmpID, string AppDate, string Workinghrs, string jobtiming, string Probation, string terminate, string Remarks)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();

        try
        {
            string Message = "";
            if (AppID == "0")
            {
                string sqlCMD = "INSERT INTO pay_appointmentletter (EmployeeID,AppointmentDate,AppointmentRemarks,workingHrs,ProbationPeriod,TerminateApp,JobTiming,EntryBy,CentreID) VALUES(@EmployeeID, @AppointmentDate, @AppointmentRemarks, @workingHrs, @ProbationPeriod, @TerminateApp, @JobTiming, @EntryBy,@CentreID);";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    EmployeeID = EmpID,
                    AppointmentDate = Util.GetDateTime(AppDate).ToString("yyyy-MM-dd"),
                    AppointmentRemarks = Remarks,
                    workingHrs = Util.GetInt(Workinghrs),
                    ProbationPeriod = Util.GetInt(Probation),
                    TerminateApp = Util.GetInt(terminate),
                    JobTiming = jobtiming,
                    EntryBy = HttpContext.Current.Session["ID"].ToString(),
                    CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"]),
                });
                Message = "Record Saved Successfully";
            }
            else
            {
                string sqlCMD = "UPDATE pay_appointmentletter SET AppointmentDate = @AppointmentDate, AppointmentRemarks = @AppointmentRemarks, workingHrs = @workingHrs, ProbationPeriod = @ProbationPeriod, TerminateApp = @TerminateApp, JobTiming = @JobTiming, UpdateBy = @UpdateBy  WHERE ID = @ID and EmployeeID=@EmployeeID;";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    AppointmentDate = Util.GetDateTime(AppDate).ToString("yyyy-MM-dd"),
                    AppointmentRemarks = Remarks,
                    workingHrs = Util.GetInt(Workinghrs),
                    ProbationPeriod = Util.GetInt(Probation),
                    TerminateApp = Util.GetInt(terminate),
                    JobTiming = jobtiming,
                    UpdateBy = HttpContext.Current.Session["ID"].ToString(),
                    EmployeeID = EmpID,
                    ID = AppID,
                });
                Message = "Record Update Successfully";
            }
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = Message });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
   

    [WebMethod]
    public string SearchAppointmentLetterDetails(string EmpID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT DATE_FORMAT(AppointmentDate,'%d-%b-%Y')AppointmentDate,AppointmentRemarks,workingHrs,ProbationPeriod,TerminateApp,JobTiming FROM pay_appointmentletter WHERE EmployeeID='" + EmpID + "'"); ;
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public string SaveAppointmentLetterAcceptance(string EmpID, string isRecieve, string RcvDate, string Remarks)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();

        try
        {
            string sqlCMD = "Update pay_appointmentletter set IsAcceptance =@IsAcceptance,AcceptanceDate=@AcceptanceDate,AcceptanceRemarks=@AcceptanceRemarks where EmployeeID=@EmployeeID";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                IsAcceptance = isRecieve,
                AcceptanceDate = Util.GetDateTime(RcvDate).ToString("yyyy-MM-dd"),
                AcceptanceRemarks = Remarks,
                EmployeeID = EmpID,
            });
            string Message = "";
            Message = "Record Save Successfully";

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = Message });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public string SearchAppointmentAcceptanceDetail(string EmpID)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT IsAcceptance,DATE_FORMAT(AcceptanceDate,'%d-%b-%Y')AcceptanceDate,AcceptanceRemarks FROM pay_appointmentletter WHERE EmployeeID='" + EmpID + "' ")); ;
    }
    [WebMethod(EnableSession = true)]
    public string PrintAppointmentAcceptanceLetter(string EmpID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("Select * from pay_appointmentletter WHERE EmployeeID='" + EmpID + "'");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            //   ds.WriteXmlSchema(@"D:\OfferLetter.xml");
            HttpContext.Current.Session["ds"] = ds;
            HttpContext.Current.Session["ReportName"] = "AppointAcceptance";
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, responseURL = "../Payroll/Report/Commonreport.aspx" });
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { response = "No Record Found" });
        }
    }

    [WebMethod(EnableSession = true)]
    public string PrintAppointmentLetter(string EmpID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT app.ID,CONCAT(em.`Title`,'',em.name)NAME,app.EmployeeID,ds.`Designation_Name` Designation,DATE_FORMAT(DOJ,'%d %b %Y') DOJ, ");
        sb.Append(" Branch JoiningLocation,DATE_FORMAT(AppointmentDate,'%d %b %Y')AppointmentDate,(em.`TotalEarning`-em.`TotalDeduction`)TotalRemuneration, ");
        sb.Append(" JobTiming,'' UserID,em.PHouse_No,em.`WorkingHrs`, ");
        sb.Append(" app.`ProbationPeriod`,TerminateApp  ");
        sb.Append(" FROM pay_appointmentletter app  ");
        sb.Append(" INNER JOIN employee_master em ON em.EmployeeID=app.EmployeeID ");
        sb.Append(" INNER JOIN `pay_designation_master` ds ON ds.`Des_ID`=em.`Desi_ID` ");
        sb.Append(" WHERE app.EmployeeID='" + EmpID + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            ds.WriteXmlSchema("E:/AppointmentLetter.xml");
            HttpContext.Current.Session["ds"] = ds;
            HttpContext.Current.Session["ReportName"] = "AppointmentLetter";
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, responseURL = "../Payroll/Report/Commonreport.aspx" });
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { response = "No Record Found" });
        }
    }


    [WebMethod]
    public string SearchOfferLetterAcceptanceDetail(string CandidateID)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT IsOfferAcceptance,DATE_FORMAT(OfferAcceptanceDate,'%d-%b-%Y')OfferAcceptanceDate,OfferAcceptanceRemarks FROM pay_interviewcandidate WHERE ID ='" + CandidateID + "' ")); ;
    }


    [WebMethod(EnableSession = true)]
    public string SaveOfferLetterAcceptance(string CandidateID, string isRecieve, string RcvDate, string Remarks)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();

        try
        {
            string sqlCMD = "Update pay_interviewcandidate set IsOfferAcceptance =@IsAcceptance,OfferAcceptanceDate=@AcceptanceDate,OfferAcceptanceRemarks=@AcceptanceRemarks where ID=@CandidateID";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                IsAcceptance = isRecieve,
                AcceptanceDate = Util.GetDateTime(RcvDate).ToString("yyyy-MM-dd"),
                AcceptanceRemarks = Remarks,
                CandidateID = CandidateID,
            });
            string Message = "";
            Message = "Record Save Successfully";

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = Message });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public string SaveDocumentMaster(string DocName, string Desc, int Seq, int IsActive, int Activity, int DocID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        int res = 0;

        try
        {

            if (Activity == 1) // for save
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("INSERT INTO pay_Document_Master(Doc_Name,Description,Sequence,IsActive,CreatedBy,CreatedDateTime) VALUES('" + DocName + "','" + Desc + "'," + Seq + "," + IsActive + ",'" + Session["ID"].ToString() + "',NOW())");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                tnx.Commit();
                res = 1;
            }
            else if (Activity == 2)// for update
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("UPDATE pay_Document_Master SET Doc_Name=@Doc_Name,Description=@Description,Sequence=@Sequence,IsActive=@IsActive WHERE DocID=@DocID");
                excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
                {
                    Doc_Name = DocName,
                    Description = Desc,
                    Sequence = Seq,
                    IsActive = IsActive,
                    DocID = DocID,
                });
                tnx.Commit();
                res = 2;
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

        if (res == 1)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Document Master Successfully Saved" });
        }
        else if (res == 2)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Document Master Updated Successfully" });
        }
        else if (res == 3)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Sequence Number is already exists." });
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator" });
        }
    }

    [WebMethod(EnableSession = true)]
    public string DeleteDocumentMap(int mapID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        int res = 0;

        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("UPDATE pay_designation_Document_Mapping SET IsActive=0,UpdatedBy='" + Session["ID"].ToString() + "',UpdatedDateTime=NOW() WHERE MapDocID=" + mapID + "");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            tnx.Commit();
            res = 1;
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
        if (res == 1)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Deleted Successfully" });
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator" });
        }

    }

    [WebMethod(EnableSession = true)]
    public string DeleteDesignationMap(int mapID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        int res = 0;

        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("UPDATE pay_designation_IVRound_Mapping SET IsActive=0 WHERE MapID=" + mapID + "");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            tnx.Commit();
            res = 1;
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

        if (res == 1)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Deleted Successfully" });
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator" });
        }
    }

    [WebMethod(EnableSession = true)]
    public string SaveDesignationWithIVRound(int DesiID, int IvRoundID, int IsActive, int Activity, int mapID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        int res = 0;

        try
        {

            if (Activity == 1) // for save
            {
                if (DesiID == 0)
                {
                    StringBuilder sbb = new StringBuilder();
                    sbb.Append("SELECT * FROM Pay_designation_master");
                    DataTable dtt = StockReports.GetDataTable(sbb.ToString());
                    if (dtt.Rows.Count > 0)
                    {
                        foreach (DataRow dr in dtt.Rows)
                        {
                            int Did = Util.GetInt(dr["Des_ID"]);

                            StringBuilder sb4 = new StringBuilder();
                            sb4.Append("SELECT COUNT(*) FROM pay_designation_IVRound_Mapping WHERE Des_ID=" + Did + " AND IVRoundID=" + IvRoundID + "");
                            int CheckIsExists2 = Util.GetInt(StockReports.ExecuteScalar(sb4.ToString()));

                            if (CheckIsExists2 == 0)
                            {
                                StringBuilder sb = new StringBuilder();
                                sb.Append("INSERT INTO pay_designation_IVRound_Mapping(Des_ID,IVRoundID,IsActive,CreatedBy,CreatedDateTime) VALUES(" + Did + "," + IvRoundID + "," + IsActive + ",'" + Session["ID"].ToString() + "',NOW())");
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                                res = 1;
                            }
                        }
                        if (res == 1)
                        {
                            tnx.Commit();
                        }
                        else
                        {
                            tnx.Rollback();
                        }
                    }
                }
                else
                {
                    StringBuilder sb1 = new StringBuilder();
                    sb1.Append("SELECT COUNT(*) FROM pay_designation_IVRound_Mapping WHERE Des_ID=" + DesiID + " AND IVRoundID=" + IvRoundID + "");
                    int CheckIsExists = Util.GetInt(StockReports.ExecuteScalar(sb1.ToString()));

                    if (CheckIsExists == 0)
                    {
                        StringBuilder sb = new StringBuilder();
                        sb.Append("INSERT INTO pay_designation_IVRound_Mapping(Des_ID,IVRoundID,IsActive,CreatedBy,CreatedDateTime) VALUES(" + DesiID + "," + IvRoundID + "," + IsActive + ",'" + Session["ID"].ToString() + "',NOW())");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                        tnx.Commit();
                        res = 1;
                    }
                    else { res = 3; }
                }
            }
            else if (Activity == 2)// for update
            {
                StringBuilder sb1 = new StringBuilder();
                sb1.Append("SELECT COUNT(*) FROM pay_designation_IVRound_Mapping WHERE Des_ID=" + DesiID + " AND IVRoundID=" + IvRoundID + " AND IsActive=" + IsActive + "");
                int CheckIsExists2 = Util.GetInt(StockReports.ExecuteScalar(sb1.ToString()));

                if (CheckIsExists2 == 0)
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append("UPDATE pay_designation_IVRound_Mapping SET Des_ID=" + DesiID + ",IVRoundID=" + IvRoundID + ",IsActive=" + IsActive + ",UpdatedBy='" + Session["ID"].ToString() + "',UpdatedDateTime=NOW() WHERE MapID=" + mapID + "");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                    tnx.Commit();
                    res = 2;
                }
                else { res = 3; }
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

        if (res == 1)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Designation Successfully Mapped" });
        }
        else if (res == 3)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Designation already mapped in this round." });
        }
        else if (res == 2)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Updated Successfully." });
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator" });
        }
    }

    [WebMethod(EnableSession = true)]
    public string SaveDepartment(string DepartmentName, int EmpRequired, int IsActive, int Activity, int DeptID, string DeptHeadID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        int res = 0;

        try
        {
            if (Activity == 1) // for save
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("insert into pay_deptartment_master(Dept_Name,EmployeeRequired,IsActive)values('" + DepartmentName + "','" + EmpRequired + "','" + IsActive + "')");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                tnx.Commit();
                res = 1;
            }
            else if (Activity == 2) // for update
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("UPDATE pay_deptartment_master SET Dept_Name='" + DepartmentName + "',IsActive='" + IsActive + "',EmployeeRequired='" + EmpRequired + "',DeptHeadID='" + DeptHeadID + "' WHERE Dept_ID=" + DeptID + "");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                tnx.Commit();
                res = 2;
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

        if (res == 1)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Department Saved Successfully" });
        }
        else if (res == 2)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Department Updated Successfully" });
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator" });
        }
    }

    [WebMethod(EnableSession = true)]
    public string SaveDesignation(string Designation, string Grade, int Activity, int desID)//
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        int res = 0;
        try
        {
            if (Activity == 1) // for save
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("insert into pay_designation_master(Designation_Name,LetterNo,RefNo,CL,EL,Grade)values('" + Designation + "',0,0,0,0,'" + Grade + "')");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                tnx.Commit();
                res = 1;
            }
            else if (Activity == 2) // for update
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("UPDATE pay_designation_master SET Designation_Name='" + Designation + "',Grade='" + Grade + "' WHERE Des_ID=" + desID + "");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                tnx.Commit();
                res = 2;
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

        if (res == 1)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Designation Saved Successfully" });
        }
        else if (res == 2)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Designation Updated Successfully" });
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator" });
        }
    }

    [WebMethod(EnableSession = true)]
    public string SaveDesigDocMap(int DesigID, int DocID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        int res = 0;

        try
        {
            if (DesigID == 0)
            {
                StringBuilder sbb = new StringBuilder();
                sbb.Append("SELECT * FROM Pay_designation_master");
                DataTable dtt = StockReports.GetDataTable(sbb.ToString());
                if (dtt.Rows.Count > 0)
                {
                    foreach (DataRow dr in dtt.Rows)
                    {
                        int Did = Util.GetInt(dr["Des_ID"]);
                        StringBuilder sb4 = new StringBuilder();
                        sb4.Append("SELECT COUNT(*) FROM pay_designation_Document_Mapping pdm WHERE pdm.`Des_ID`=" + Did + " AND pdm.`DocID`=" + DocID + "");
                        int CheckIsExists2 = Util.GetInt(StockReports.ExecuteScalar(sb4.ToString()));
                        if (CheckIsExists2 == 0)
                        {
                            StringBuilder sb = new StringBuilder();
                            sb.Append("INSERT INTO pay_designation_Document_Mapping(Des_ID,DocID,IsActive,CreatedBy,CreatedDateTime) VALUES(" + Did + "," + DocID + ",1,'" + Session["ID"].ToString() + "',NOW())");
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                            res = 1;
                        }
                    }
                    if (res == 1)
                    {
                        tnx.Commit();
                    }
                    else
                    {
                        tnx.Rollback();
                    }
                }
            }
            else
            {
                string sqlCMD = "INSERT INTO pay_designation_Document_Mapping(Des_ID,DocID,IsActive,CreatedBy,CreatedDateTime) VALUES(@Des_ID,@DocID,@IsActive,@CreatedBy,NOW())";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    Des_ID = DesigID,
                    DocID = DocID,
                    IsActive = '1',
                    CreatedBy = Session["ID"].ToString(),
                });
                tnx.Commit();
            }


            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Designation Successfully Mapped with Document" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession=true)]
    public string SearchEmployeeOnPrabation(string pMonth, string pYear, string status, string deptid, string desigid, string employeeid, string empname)
    {
        StringBuilder sb = new StringBuilder();

        string date = pYear + "-" + pMonth + "-01";


        sb.Append("SELECT em.EmployeeID,em.RegNo,CONCAT(em.title,em.NAME)EmpName, ");
        sb.Append("ds.Designation_Name,dm.Dept_Name, ");
        sb.Append("DATE_FORMAT(DOJ,'%d-%b-%Y')DOJ,ProbationPeriod,ProbationPeriodComplete, ");
        sb.Append("ProbationPeriodCompleteDate,DATE_FORMAT(ADDDATE(DOJ,INTERVAL ProbationPeriod MONTH),'%d-%b-%Y')ConfirmDate  ");
        sb.Append("FROM employee_master em ");
        sb.Append("inner join centre_access ca on ca.EmployeeID = em.EmployeeId and ca.CentreAccess= " + Util.GetInt(HttpContext.Current.Session["CentreID"]) + "  and ca.IsActive=1 ");
        sb.Append("INNER JOIN pay_designation_master ds ON ds.Des_ID=em.Desi_ID ");
        sb.Append("INNER JOIN pay_deptartment_master dm ON dm.Dept_ID= em.Dept_ID ");
        sb.Append("WHERE em.IsActive=1  ");
        sb.Append("AND MONTH(DATE(ADDDATE(DOJ,INTERVAL ProbationPeriod MONTH)))=MONTH(DATE('" + date + "'))  ");
        sb.Append("AND YEAR(DATE(ADDDATE(DOJ,INTERVAL ProbationPeriod MONTH)))=YEAR(DATE('" + date + "')) ");
        if (status != "ALL")
            sb.Append("AND ProbationPeriodComplete= '" + status + "' ");
        if (deptid != "0")
            sb.Append(" and em.dept_id ='" + deptid + "' "); ;
        if (desigid != "0")
            sb.Append(" and em.desi_ID = '" + desigid + "' "); ;
        if (employeeid != "0")
            sb.Append("  and em.EmployeeID ='" + employeeid + "'"); ;
        if (empname != "")
            sb.Append(" and em.name like '%" + empname + "%' "); ;

        sb.Append("ORDER BY DATE(DOJ),em.EmployeeID ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }

    [WebMethod(EnableSession = true)]
    public string SaveEmployeeProbationCompleteDate(string EmpID, string isComplete, string ConfirmDate, string Remarks, string DOJ)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            int Probationperiod = Util.GetInt((Util.GetDateTime(ConfirmDate) - Util.GetDateTime(DOJ)).TotalDays) / 30;

            string query = "UPDATE employee_master SET ProbationPeriodComplete=@isComplete,ProbationPeriodCompleteDate=@ConfirmDate,Probationperiod=@Probationperiod WHERE EmployeeID=@EmpID";
            excuteCMD.DML(tnx, query, CommandType.Text, new
            {
                isComplete = isComplete,
                ConfirmDate = Util.GetDateTime(ConfirmDate).ToString("yyyy-MM-dd"),
                Probationperiod = Probationperiod,
                EmpID = EmpID,
            });
            tnx.Commit();

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Save Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public string SaveProbationPeriodIssueLetter(string EmpID, string IssueDate, string Remarks)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            string sqlCMD = "Update Employee_Master set Prob_Confirm_IssueDate=@Prob_Confirm_IssueDate,Prob_Confirm_IssueRemarks=@Prob_Confirm_IssueRemarks,Prob_Confirm_IssueBy =@Prob_Confirm_IssueBy  where EmployeeID =@EmpID ;";
            excuteCMD.DML(tnx,sqlCMD,CommandType.Text,new{
                Prob_Confirm_IssueDate = Util.GetDateTime(IssueDate).ToString("yyyy-MM-dd"),
                Prob_Confirm_IssueRemarks=Remarks,
                EmpID = EmpID,
                Prob_Confirm_IssueBy = HttpContext.Current.Session["ID"].ToString(),
            });
            tnx.Commit();    
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Save Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession=true)]
    public string PrintProbationConfirmationLetter(string EmpId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT Probationperiod,EmployeeID AS EmployeeID,CONCAT(title,'',NAME)`Name`,ds.`Designation_Name` AS Designation,  ");
        sb.Append(" em.Prob_Confirm_IssueDate AS IssueDate,DATE_FORMAT(ProbationPeriodCompleteDate,'%d-%b-%y') AS Confirmationdate,(em.`TotalEarning`-em.`TotalDeduction`) GrossSalary, ");
        sb.Append(" Branch AS HospitalName FROM employee_master em ");
        sb.Append(" INNER JOIN `pay_designation_master` ds ON ds.`Des_ID`=em.`Desi_ID` ");
        sb.Append(" WHERE EmployeeID='" + EmpId + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            ds.WriteXmlSchema("E:/ConfirmationLetter.xml");
            HttpContext.Current.Session["ds"] = ds;
            HttpContext.Current.Session["ReportName"] = "ConfirmationLetter";
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, responseURL = "../Payroll/Report/Commonreport.aspx" });
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { response = "No Record Found" });
        }
    }
  
 [WebMethod(EnableSession = true)]
    public string SaveRatingMaster(string RatingName, int IsActive, int Activity, int Ratingid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        int res = 0;

        try
        {

            if (Activity == 1) // for save
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("INSERT INTO Pay_EmployeeRatingMaster(RatingDetails,IsActive,CreatedBy) VALUES('" + RatingName + "'," + IsActive + ",'" + Session["ID"].ToString() + "')");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                tnx.Commit();
                res = 1;
            }
            else if (Activity == 2)// for update
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("UPDATE Pay_EmployeeRatingMaster SET RatingDetails=@RatingName,IsActive=@IsActive WHERE ID=@RatingId");
                excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
                {
                    RatingName = RatingName,
                    IsActive = IsActive,
                    RatingId = Ratingid,
                });
                tnx.Commit();
                res = 2;
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

        if (res == 1)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Rating Master Saved Successfully " });
        }
        else if (res == 2)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Rating Master Updated Successfully" });
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator" });
        }
    }
}