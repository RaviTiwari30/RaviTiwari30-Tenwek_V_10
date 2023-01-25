<%@ WebService Language="C#" Class="EmployeeProcessing" %>

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
public class EmployeeProcessing : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }

    [WebMethod]
    public string bindEmployeeAdvanceStatus(string EmpID)
    {
        string str = "SELECT IFNULL(SUM(ad.RequestAdvanceAmount),0)RequestAdvanceAmount,IFNULL(SUM(ad.RecievedAmount),0)RecievedAmount,IFNULL(SUM(ad.PendingAmount),0)PendingAmount,IF(ad.IsApproved=0,'Pending',IF(ad.IsApproved=1,'Approved',IF(ad.IsApproved=2,'Rejected','')))AdvanceStatus,ad.IsApproved FROM Pay_EmployeeAdvance ad WHERE EmployeeID='" + EmpID + "' AND ad.IsActive=1 and ad.IsApproved<>2";
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(str));
    }
    [WebMethod(EnableSession = true)]
    public string SaveAdvanceRequest(string EmpID, string AdvanceRequestAmt, string InstallmentMonth, string Remarks, string SaveType, string AdvanceRequestID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var message = "";
            var InstallmentAmount = Util.GetDecimal(AdvanceRequestAmt) / Util.GetDecimal(InstallmentMonth);
            DateTime InstallmentDate = DateTime.Now;
            if (SaveType == "Save")
            {
                int Advance_ID = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT get_Payroll_ID('Advance_ID'," + Util.GetInt(HttpContext.Current.Session["CentreID"]) + ")", CommandType.Text, new { }));

                string sqlCMD = "INSERT INTO pay_employeeadvance (EmployeeID,Advance_ID, RequestAdvanceAmount, InstallmentMonth, InstallmentAmount,PendingAmount, Remarks,CentreID) VALUES (@EmployeeID,@Advance_ID, @RequestAdvanceAmount, @InstallmentMonth, @InstallmentAmount,@PendingAmount,@Remarks,@CentreID);";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    Advance_ID = Advance_ID,
                    EmployeeID = EmpID,
                    RequestAdvanceAmount = Util.GetDecimal(AdvanceRequestAmt),
                    InstallmentMonth = Util.GetInt(InstallmentMonth),
                    InstallmentAmount = Util.GetDecimal(InstallmentAmount),
                    PendingAmount = Util.GetDecimal(AdvanceRequestAmt),
                    Remarks = Remarks,
                    CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"])
                });

                for (int i = 0; i < Util.GetInt(InstallmentMonth); i++)
                {

                    string str = "INSERT INTO pay_employeeadvancedetail (Advance_ID,InstallmentDate,InstallmentAmount) VALUES(@Advance_ID,@InstallmentDate,@InstallmentAmount);";
                    excuteCMD.DML(tnx, str, CommandType.Text, new
                    {
                        InstallmentDate = Util.GetDateTime(InstallmentDate).AddMonths(i).ToString("yyyy-MM-dd"),
                        InstallmentAmount = Util.GetDecimal(InstallmentAmount),
                        Advance_ID = Advance_ID,
                    });
                }

                message = "Record Save Successfully";
            }
            else if (SaveType == "Update" && !string.IsNullOrEmpty(AdvanceRequestID))
            {
                string sqlCMD = " Update pay_employeeadvance set  RequestAdvanceAmount=@RequestAdvanceAmount, InstallmentMonth=@InstallmentMonth, InstallmentAmount=@InstallmentAmount,PendingAmount=@PendingAmount, Remarks =@Remarks,UpdatedDateTime=NOW()  where Advance_ID =@Advance_ID";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    RequestAdvanceAmount = Util.GetDecimal(AdvanceRequestAmt),
                    InstallmentMonth = Util.GetInt(InstallmentMonth),
                    InstallmentAmount = Util.GetDecimal(InstallmentAmount),
                    PendingAmount = Util.GetDecimal(AdvanceRequestAmt),
                    Remarks = Remarks,
                    Advance_ID = AdvanceRequestID,
                });

                string strd = "Delete From pay_employeeadvancedetail where Advance_ID =@Advance_ID";
                excuteCMD.DML(tnx, strd, CommandType.Text, new
                {
                    Advance_ID = AdvanceRequestID,
                });

                for (int i = 0; i < Util.GetInt(InstallmentMonth); i++)
                {

                    string str = "INSERT INTO pay_employeeadvancedetail (Advance_ID,InstallmentDate,InstallmentAmount) VALUES(@Advance_ID,@InstallmentDate,@InstallmentAmount);";
                    excuteCMD.DML(tnx, str, CommandType.Text, new
                    {
                        InstallmentDate = Util.GetDateTime(InstallmentDate).AddMonths(i).ToString("yyyy-MM-dd"),
                        InstallmentAmount = Util.GetDecimal(InstallmentAmount),
                        Advance_ID = AdvanceRequestID,
                    });
                }

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


    // common method - page1->Advance request , page2->Advance request approval , page 3 -> Advance transfer
    [WebMethod(EnableSession=true)]
    public string SearchAdvanceRequest(string fromdate, string todate, string AdvanceReqID, string departmentID, string designationID, string EmployeeID, string status, string EmpName)
    {
        //string str = "SELECT Advance_ID as ID,DATE_FORMAT(CreatedDateTime,'%d-%b-%Y')RequestDate,RequestAdvanceAmount,ApprovedAmount,CONCAT(ROUND(InstallmentAmount,0),' * ',Installmentmonth)Installmentdtl,Installmentmonth,Remarks,Installmentmonth,RecievedAmount,PendingAmount ,IsApproved,IsTransfered,IsActive FROM pay_employeeadvance WHERE 1=1";
        //if (!string.IsNullOrEmpty(AdvanceReqID))
        //{
        //    str += " AND ID=" + AdvanceReqID + " ";
        //}
        //else
        //{
        //    str += " AND CreatedDateTime>= '" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' AND CreatedDateTime<= '" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ";
        //}

        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT Advance_ID AS ID,DATE_FORMAT(CreatedDateTime,'%d-%b-%Y')RequestDate,RequestAdvanceAmount,ApprovedAmount, ");
        sb.Append("CONCAT(ROUND(InstallmentAmount,0),' * ',Installmentmonth)Installmentdtl,Installmentmonth,Remarks,Installmentmonth,RecievedAmount,PendingAmount , ");
        sb.Append("IsApproved,IsTransfered,ad.IsActive ,em.EmployeeID,CONCAT(em.Title,'',em.Name)EmpName,dm.Dept_Name,ds.Designation_Name,RegNo ");
        sb.Append("FROM pay_employeeadvance ad ");
        sb.Append("INNER JOIN employee_master em ON ad.EmployeeID=em.EmployeeID ");
        sb.Append("INNER JOIN pay_deptartment_master dm ON dm.Dept_ID=em.Dept_ID ");
        sb.Append("INNER JOIN pay_designation_master ds ON ds.Des_ID= em.Desi_ID ");
        sb.Append("WHERE ad.CentreId= "+Util.GetInt(HttpContext.Current.Session["CentreID"]) +" ");
        if (!string.IsNullOrEmpty(AdvanceReqID))
            sb.Append(" AND ad.Advance_ID=" + AdvanceReqID + " ");
        else
            sb.Append("AND CreatedDateTime>= '" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' AND CreatedDateTime<= '" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        if (departmentID != "0")
            sb.Append(" AND em.Dept_ID ='" + departmentID + "'");
        if (designationID != "0")
            sb.Append(" AND em.Desi_ID = '" + designationID + "' ");
        if (EmployeeID != "0")
            sb.Append(" AND ad.EmployeeID ='" + EmployeeID + "' ");
        if (!string.IsNullOrEmpty(EmpName))
            sb.Append(" AND em.Name like '" + EmpName + "%'");
        if (status != "-1")
        {
            if (status == "0") // Pending
            {
                sb.Append(" AND ad.IsApproved =0 ");
            }
            else if (status == "1") // Approved
            {
                sb.Append(" AND ad.IsApproved =1 AND ad.IsTransfered =0 and ad.IsActive =1 ");
            }
            else if (status == "2") // Rejected
            {
                sb.Append(" AND ad.IsApproved =2 ");
            }
            else if (status == "3") // Cancelled by user
            {
                sb.Append(" AND ad.IsActive =0 and ad.EmployeeCancelRemarks<>'' ");
            }
            else if (status == "4") // Fund Transferred
            {
                sb.Append(" AND ad.IsTransfered =1 ");
            }
            else if (status == "5") // Fully Paid
            {
                sb.Append(" AND ad.IsTransfered =1 and ad.PendingAmount=0");
            }
            else if (status == "6") // Partial Paid
            {
                sb.Append(" AND ad.IsTransfered =1 AND ad.ApprovedAmount>ad.RecievedAmount AND ad.RecievedAmount<>0 ");
            }
        }
        sb.Append(" GROUP BY ad.Advance_ID ORDER BY ad.Advance_ID");


        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    public string CancelAdvanceRequest(string AdvreqID, string Remarks)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            string sqlCMD = " Update pay_employeeadvance set IsActive=@IsActive,EmployeeCancelRemarks =@EmployeeCancelRemarks,EmployeeCancelDateTime=NOW() where Advance_ID =@Advance_ID";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                IsActive = 0,
                EmployeeCancelRemarks = Remarks,
                Advance_ID = AdvreqID,
            });
            // 0 for PAid , 1 for pending , 2 for cancelled/reject
            string strd = "Update pay_employeeadvancedetail set IsActive=@IsActive where Advance_ID =@Advance_ID";
            excuteCMD.DML(tnx, strd, CommandType.Text, new
            {
                IsActive = 2,
                Advance_ID = AdvreqID,
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
    public string SearchAdvanceDetails(string ReqID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT  ad.RequestAdvanceAmount,ad.ApprovedAmount,ad.RecievedAmount,ad.PendingAmount,ad.Installmentmonth, ");
        sb.Append("CONCAT(IF(ad.IsApproved=0,'Pending',IF(ad.IsApproved=1,'Approved',IF(ad.IsApproved=2,'Rejected',''))),' ', ");
        sb.Append("IF(ad.IsTransfered=1,' -Fund Transferred',''),' ', ");
        sb.Append("IF(ad.IsActive=0 AND IFNULL(ad.EmployeeCancelRemarks,'')<>'',' -Cancelled by User',IF(ad.PendingAmount=0,'-Complete','')))AdvanceStatus, ");
        sb.Append("DATE_FORMAT(adm.InstallmentDate,'%d-%b-%Y')InstallmentDate,adm.InstallmentAmount ,adm.RecievedAmount  , ");
        sb.Append("Ifnull(DATE_FORMAT(RecievedDateTime,'%d-%b-%Y'),'')RecievedDateTime ,IF(adm.IsActive=1 and adm.InstallmentAmount<>adm.RecievedAmount,'Due',if(adm.IsActive=2,'Cancelled/Reject','Paid'))PaidStatus ");
        sb.Append(",ad.IsTransfered,ad.IsActive,ad.IsApproved ");
        sb.Append(",(get_EmployeeTotalDue(ad.EmployeeID))TotalDue,em.advancelimit AdvanceLimit,IFNULL(em.BankAccountNo,'')BankAccountNo ");
        sb.Append("FROM pay_employeeadvance ad ");
        sb.Append("INNER JOIN pay_employeeadvancedetail adm ON ad.Advance_ID = adm.Advance_ID ");
        sb.Append("INNER JOIN employee_master em ON em.EmployeeID = ad.EmployeeID ");
        sb.Append("WHERE ad.Advance_ID=" + ReqID + " ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod(EnableSession = true)]
    public string SaveAdvanceApprovalStatus(string reqID, string Status, string Forwardedto, string ForwardRemarks, string ApprovedAmt, string ApprovedMonth, string RejectRemarks)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();

        try
        {
            if (Status == "0") // inn case of forward
            {
                int isForwarded = Util.GetInt(StockReports.ExecuteScalar("Select count(*) from pay_Advanceforwarddtl where Advance_ID='" + reqID + "' and ForwardedTo= '" + Forwardedto + "'"));
                if (isForwarded > 0)
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Request already forwarded to this Employee", });
                }

                DataTable dtForID = StockReports.GetDataTable("SELECT ID FROM pay_Advanceforwarddtl WHERE Advance_ID=" + reqID + " AND STATUS='0' AND isCancel=0");
                if (dtForID.Rows.Count > 0)
                {
                    foreach (DataRow dr in dtForID.Rows)
                    {
                        string st = "Update pay_Advanceforwarddtl set isCancel=@isCancel where ID =@ID";
                        excuteCMD.DML(tnx, st, CommandType.Text, new
                        {
                            isCancel = "1",
                            ID = dr["ID"].ToString(),
                        });
                    }
                }

                string sqlCMD = "insert into pay_Advanceforwarddtl(Advance_ID,ForwardedBy,ForwardedTo,ForwardRemarks,Status) values(@Advance_ID,@ForwardedBy,@ForwardedTo,@ForwardRemarks,@Status)";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    Status = Status,
                    ForwardedTo = Forwardedto,
                    ForwardedBy = HttpContext.Current.Session["ID"].ToString(),
                    ForwardRemarks = ForwardRemarks,
                    Advance_ID = reqID
                });
            }
            else if (Status == "1" || Status == "2") // inn case of Approve or reject
            {
                DateTime InstallmentDate = DateTime.Now;

                string sqlCMD = "Update pay_employeeadvance set IsApproved=@status,ApprovedAmount=@ApprovedAmount,  InstallmentMonth=@InstallmentMonth ,InstallmentAmount=@InstallmentAmount,PendingAmount=@PendingAmount where Advance_ID =@Advance_ID";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    status = Status,
                    ApprovedAmount = Util.GetDecimal(ApprovedAmt),
                    InstallmentMonth = Util.GetInt(ApprovedMonth),
                    InstallmentAmount = Util.GetDecimal(ApprovedAmt) / Util.GetDecimal(ApprovedMonth),
                    PendingAmount = Util.GetDecimal(ApprovedAmt),
                    Advance_ID = reqID,
                });


                if (Status == "1")  // in case of approved
                {
                    string strd = "Delete From pay_employeeadvancedetail where Advance_ID =@Advance_ID";
                    excuteCMD.DML(tnx, strd, CommandType.Text, new
                    {
                        Advance_ID = reqID,
                    });

                    for (int i = 0; i < Util.GetInt(ApprovedMonth); i++)
                    {
                        string str = "INSERT INTO pay_employeeadvancedetail (Advance_ID,InstallmentDate,InstallmentAmount) VALUES(@Advance_ID,@InstallmentDate,@InstallmentAmount);";
                        excuteCMD.DML(tnx, str, CommandType.Text, new
                        {
                            InstallmentDate = Util.GetDateTime(InstallmentDate).AddMonths(i).ToString("yyyy-MM-dd"),
                            InstallmentAmount = Util.GetDecimal(ApprovedAmt) / Util.GetDecimal(ApprovedMonth),
                            Advance_ID = reqID,
                        });
                    }
                }

                else if (Status == "2") // in case of Reject
                {
                    // 0 - paid, 1 - due , 2- cancelled/reject
                    string strd = "Update pay_employeeadvancedetail set IsActive=@IsActive where Advance_ID =@Advance_ID";
                    excuteCMD.DML(tnx, strd, CommandType.Text, new
                    {
                        IsActive = 2,
                        Advance_ID = reqID,
                    });
                }


                sqlCMD = "insert into pay_Advanceforwarddtl(Advance_ID,ForwardedBy,ForwardedTo,ForwardRemarks,Status) values(@Advance_ID,@ForwardedBy,@ForwardedTo,@ForwardRemarks,@Status)";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    Status = Status,
                    ForwardedTo = "",
                    ForwardedBy = HttpContext.Current.Session["ID"].ToString(),
                    ForwardRemarks = "",
                    Advance_ID = reqID
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
    public string ViewAdvanceApprovalForwardDetail(string AdvanceReqID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT IF(adf.status=0,'Forwarded',IF(adf.Status=1,'Apprroved','Rejected')) AS 'Status',  ");
        sb.Append("CONCAT(title,'',em.name)ForwardedBy,  ");
        sb.Append("(SELECT CONCAT(title,'',NAME)NAME FROM Employee_master WHERE EmployeeID = forwardedto)ForwardedTo,  ");
        sb.Append("DATE_FORMAT(adf.ForwardedDateTime,'%d-%b-%Y %h:%i:%p')`DateTIme`,CONCAT(ForwardRemarks,'',IF(iscancel=1,'-Cancelled',''))ForwardRemarks ");
        sb.Append("FROM  pay_Advanceforwarddtl adf  ");
        sb.Append("INNER JOIN pay_employeeadvance ad ON adf.Advance_ID=ad.Advance_ID ");
        sb.Append("INNER JOIN employee_master em ON adf.ForwardedBy=em.EmployeeID  ");
        sb.Append("WHERE adf.Advance_ID='" + AdvanceReqID + "'   ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


    [WebMethod(EnableSession = true)]
    public string SaveAdvanceTransfer(string reqID, string PaymentMode, string Remarks)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            string sqlCMD = " Update pay_employeeadvance set IsTransfered=@IsTransfered,TransferedBy=@TransferedBy,TransferedDateTime=NOW() where Advance_ID =@Advance_ID";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                IsTransfered = 1,
                TransferedBy = HttpContext.Current.Session["ID"].ToString(),
                Advance_ID = reqID,
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
    public string SearchEmployeeWeeklyOff(string usergroupid, string deptid, string desigid, string empid, string empname)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT em.EmployeeID,CONCAT(em.Title,' ',em.Name)EmpName,eg.Name AS EmployeeGroup, dm.Dept_Name,ds.Designation_Name , ");
        sb.Append("em.Dept_ID,em.Desi_ID,em.Employee_Group_ID,IFNULL(wo.Monday,0)Monday,IFNULL(wo.Tuesday,0)Tuesday,IFNULL(wo.Wednesday,0)Wednesday, ");
        sb.Append("IFNULL(wo.Thursday,0)Thursday,IFNULL(wo.Friday,0)Friday,IFNULL(wo.Saturday,0)Saturday,IFNULL(wo.Sunday,0)Sunday,ifnull(wo.ID,0)WeekID ");
        sb.Append("FROM employee_master em  ");
        sb.Append("INNER JOIN pay_deptartment_master dm ON dm.Dept_ID = em.Dept_ID ");
        sb.Append("INNER JOIN pay_designation_master ds ON ds.Des_ID= em.Desi_ID ");
        sb.Append("INNER JOIN employee_group_master eg ON eg.ID = em.Employee_Group_ID ");
        sb.Append("LEFT JOIN pay_weeklyoff wo ON wo.EmployeeID= em.EmployeeID AND wo.IsActive=1 ");
        sb.Append("WHERE em.IsActive=1  ");
        if (usergroupid != "0")
            sb.Append(" AND em.Employee_Group_ID='" + usergroupid + "' ");
        if (deptid != "0")
            sb.Append(" AND em.Dept_ID = '" + deptid + "' ");
        if (desigid != "0")
            sb.Append(" AND em.Desi_ID = '" + desigid + "' ");
        if (empid != "0")
            sb.Append(" AND em.EmployeeID = '" + empid + "' ");
        if (!string.IsNullOrEmpty(empname))
            sb.Append(" AND em.Name like '" + empname + "%' ");
        sb.Append("ORDER BY em.EmployeeID  ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true)]
    public string SaveEmployeeWeekOff(List<empDetails> empdetails)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            empdetails.ForEach(i =>
            {
                if (i.WeekID != "0")
                {
                    string sqlcmd = "Update pay_weeklyoff set IsActive=0 where EmployeeID = @EmployeeID";
                    excuteCMD.DML(tnx, sqlcmd, CommandType.Text, new
                    {
                        EmployeeID = i.EmpID,
                    });
                }
                string sql = @" INSERT INTO pay_weeklyoff (EmployeeID,EmployeeGroupID,DeptID,DesigID,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday,CreatedBy)
                                VALUES(@EmployeeID,@EmployeeGroupID,@DeptID,@DesigID,@Monday,@Tuesday,@Wednesday,@Thursday,@Friday,@Saturday,@Sunday,@CreatedBy);";
                excuteCMD.DML(tnx, sql, CommandType.Text, new
                {
                    EmployeeID = i.EmpID,
                    EmployeeGroupID = i.EmpGroupID,
                    DeptID = i.DeptID,
                    DesigID = i.DesigID,
                    Monday = i.Monday,
                    Tuesday = i.Tuesday,
                    Wednesday = i.Wednesday,
                    Thursday = i.Thursday,
                    Friday = i.Friday,
                    Saturday = i.Saturday,
                    Sunday = i.Sunday,
                    CreatedBy = HttpContext.Current.Session["ID"].ToString(),
                });
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
    public class empDetails
    {
        public string EmpID { get; set; }
        public string DeptID { get; set; }
        public string DesigID { get; set; }
        public string EmpGroupID { get; set; }
        public string Monday { get; set; }
        public string Tuesday { get; set; }
        public string Wednesday { get; set; }
        public string Thursday { get; set; }
        public string Friday { get; set; }
        public string Saturday { get; set; }
        public string Sunday { get; set; }
        public string WeekID { get; set; }
    }
    [WebMethod(EnableSession=true)]
    public string BindEmployeeRatingDetails(string EmpID, string RatingDate)
    {
        string str = " SELECT erm.ID RatingID,RatingDetails,IFNULL(erd.RatingValue,0)RatingValue,IFNULL(erd.RatingRemarks,'')RatingRemarks,ifnull(get_Pay_EmployeeOverAllRating('" + EmpID + "'," + Util.GetInt(HttpContext.Current.Session["CentreID"]) + "),0)OverAllRating ";
                  str +=  "    FROM pay_employeeratingmaster erm  ";
                  str += "      LEFT JOIN employeeratingdetails erd ON erd.RatingID= erm.ID AND erd.EmployeeID='" + EmpID + "' and erd.CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"]) + " ";
                  str += "      AND CONCAT(YEAR(erd.RatingDate),'-',MONTH(erd.RatingDate)) = CONCAT(YEAR('" + Util.GetDateTime(RatingDate).ToString("yyyy-MM-dd") + "'),'-',MONTH('" + Util.GetDateTime(RatingDate).ToString("yyyy-MM-dd") + "')) WHERE erm.IsActive=1 ";
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(str)); 
    }
    [WebMethod(EnableSession = true)]
    public string SaveEmployeeRating(List<ratingdetails> ratingDetails, string EmpID, string RatingDate)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            string str = "Select count(*) from employeeratingdetails where EmployeeID =@EmployeeID and CONCAT(YEAR(RatingDate),'-',MONTH(RatingDate))=CONCAT(YEAR(@RatingDate),'-',MONTH(@RatingDate)) and CentreID=@CentreID";
            var isExist = Util.GetInt(excuteCMD.ExecuteScalar(tnx, str, CommandType.Text, new
            {
                EmployeeID=EmpID,
                RatingDate = Util.GetDateTime(RatingDate).ToString("yyyy-MM-dd"),
                CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"])
            }));
            if (isExist > 0)
            {
                string strDel = "Delete From EmployeeRatingDetails where EmployeeID =@EmployeeID and CONCAT(YEAR(RatingDate),'-',MONTH(RatingDate))=CONCAT(YEAR(@RatingDate),'-',MONTH(@RatingDate)) and CentreID=@CentreID";
                excuteCMD.DML(tnx, strDel, CommandType.Text, new
                {
                    EmployeeID = EmpID,
                    RatingDate = Util.GetDateTime(RatingDate).ToString("yyyy-MM-dd"),
                    CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"])
                });
                var a = excuteCMD.GetRowQuery(strDel, new
                {
                    EmployeeID = EmpID,
                    RatingDate = Util.GetDateTime(RatingDate).ToString("yyyy-MM-dd"),
                });
            }
            ratingDetails.ForEach(i =>
            {
                string sqlCMD = "INSERT INTO employeeratingdetails (EmployeeID,RatingID,RatingValue,RatingDate,RatingRemarks,CreatedBy,CentreID) VALUES(@EmployeeID,@RatingID,@RatingValue,@RatingDate,@RatingRemarks,@CreatedBy,@CentreID);";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    EmployeeID = EmpID,
                    RatingID = i.ratingID,
                    RatingValue = i.RatingValue,
                    RatingRemarks = i.RatingRemarks,
                    RatingDate = Util.GetDateTime(RatingDate).ToString("yyyy-MM-dd"),
                    CreatedBy = HttpContext.Current.Session["ID"].ToString(),
                    CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"])
                });
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
    public class ratingdetails
    {
        public string ratingID { get; set; }
        public string RatingValue { get; set; }
        public string RatingRemarks { get; set; }
    }
    [WebMethod(EnableSession=true)]
    public string SearchEmployeesForRating(string EmpID, string DeptID, string DesigID, string UserGroup, string EmpName)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT em.EmployeeID,RegNo,CONCAT(em.Title,'',em.Name)EmpName ,em.Mobile,em.DOJ,em.BloodGroup, ");
        sb.Append("IF(em.ProbationPeriodComplete='1','Complete',IF(em.ProbationPeriodComplete='0','In-Complete','Extended'))ProbationPeriodComplete, ");
        sb.Append("dm.Dept_Name,ds.Designation_Name,egm.Name AS GroupName, ");
        sb.Append("(SELECT CONCAT(Title,'',Name) FROM employee_master WHERE EmployeeID =dm.DeptHeadID)DeptHead,em.AdvanceLimit,(TotalEarning+TotalDeduction)MonthlyCTC ");
        sb.Append("FROM employee_master em  ");
        sb.Append("inner join centre_access ca on ca.EmployeeID = em.EmployeeId and ca.CentreAccess= " + Util.GetInt(HttpContext.Current.Session["CentreID"]) + "  and ca.IsActive=1 ");
        sb.Append("INNER JOIN pay_deptartment_master dm ON dm.Dept_ID= em.Dept_ID ");
        sb.Append("INNER JOIN pay_designation_master ds ON ds.Des_ID=em.Desi_ID ");
        sb.Append("INNER JOIN employee_group_master egm ON egm.ID= em.Employee_Group_ID ");
        sb.Append("WHERE em.IsActive=1");
        if (EmpID != "0") {
            sb.Append(" and em.EmployeeID='" + EmpID + "' ");
        }
        if (DeptID != "0")
        {
            sb.Append(" and em.Dept_ID='" + DeptID + "' ");
        }
        if (DesigID != "0")
        {
            sb.Append(" and em.Desi_ID='" + DesigID + "' ");
        }
        if (UserGroup != "0")
        {
            sb.Append(" and em.Employee_Group_ID='" + UserGroup + "' ");
        }
        if (EmpName != "")
        {
            sb.Append(" and em.Name like '" + EmpName + "%' ");
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod(EnableSession=true)]
    public string SearchPreviousRatingSummary(string EmpID)
    {
        DataTable dt = StockReports.GetDataTable("SELECT DATE_FORMAT(ratingDate,'%b-%Y')RatingMonth,DATE_FORMAT(ratingDate,'%d-%b-%Y')RatingDate,EmployeeID, ROUND(SUM(RatingValue)/COUNT(ID),0)RatingValue FROM EmployeeRatingDetails WHERE EmployeeID='" + EmpID + "' and CentreId = " + Util.GetInt(HttpContext.Current.Session["CentreID"]) + "  GROUP BY ratingDate;"); ;
       return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true)]
    public string SaveLogin(string EmpID, string LoginType)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"]);
            var message = "";
            if (LoginType == "login") {
                var sqlcmd ="Insert into pay_Emp_AttendanceDetails (EmployeeID,LoginTime,CentreID) values (@EmployeeID,Now(),@CentreID);";
                excuteCMD.DML(tnx, sqlcmd, CommandType.Text, new
                {
                    EmployeeID=EmpID,
                    CentreID = CentreID,
                });
                message = "You are Punched-In Successfully";
            }
            else
            {
                var sqlcmd = "Update pay_Emp_AttendanceDetails set LogoutTime= Now() where EmployeeID= @EmployeeID and CentreID = @CentreID;";
                excuteCMD.DML(tnx, sqlcmd, CommandType.Text, new
                {
                    EmployeeID = EmpID,
                    CentreID = CentreID,
                });
                message = "You are Punched-Out Successfully";
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
    [WebMethod(EnableSession=true)]
    public string SearchEmployeeLoginDetails(string EmpID, string LoginDate)
    {
        string str = "SELECT IFNULL(DATE_FORMAT(LoginTime,'%d-%b-%Y %I:%i %p'),'')LoginTime,IFNULL(DATE_FORMAT(LogoutTime,'%d-%b-%Y %I:%i %p'),'')LogoutTime FROM pay_Emp_AttendanceDetails WHERE EmployeeID='" + EmpID + "' AND CentreID='" + Util.GetInt(HttpContext.Current.Session["CentreID"]) + "' AND DATE(LoginTime)='" + Util.GetDateTime(LoginDate).ToString("yyyy-MM-dd") + "'";
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(str));
    }
    [WebMethod]
    public string bindLeaveAndHolidays(string EmpID)
    {
        string str = "SELECT NAME HolidayName,DATE,DAY(DATE)D,MONTH(DATE)M,YEAR(DATE)Y,IsOptionalHoliday FROM pay_publicholidays WHERE IsActive=1";
        DataTable dtHoliday = StockReports.GetDataTable(str);
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { holiday = dtHoliday });
    }
    [WebMethod]
    public string SearchEmployeeLeave(string EmpID, string GroupID, string DOJ, string Experience)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("Select * from pay_leavenamemaster where IsActive=1"));
    }
}

