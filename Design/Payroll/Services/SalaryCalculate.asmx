<%@ WebService Language="C#" Class="SalaryCalculate" %>

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
using System.Linq;


[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
[ScriptService]
public class SalaryCalculate : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }
    [WebMethod(EnableSession=true)]
    public string SearchEmployeetoSalary(string salaryMonth, string salaryYear, string departmentID, string designationID, string empID, string salaryStatus)
    {
        string str = "SELECT em.EmployeeID,em.RegNo,CONCAT(em.Title,'',em.Name)EmpName,(em.TotalEarning+em.TotalDeduction)MonthlyCTC,IF(IFNULL(lt.ID,0)=0,'0','1')SalaryGenerate  FROM employee_master em ";
        str += " inner join centre_access ca on ca.EmployeeID = em.EmployeeId and ca.CentreAccess= " + Util.GetInt(HttpContext.Current.Session["CentreID"]) + "  and ca.IsActive=1 ";
        str += " LEFT JOIN pay_empsalary_transaction lt ON lt.EmployeeID=em.EmployeeID AND lt.IsActive=1 AND MONTH(SalaryMonth)='" + salaryMonth + "' and YEAR(SalaryMonth)='" + salaryYear + "'";
        str += " WHERE em.IsActive=1 ";
        if (empID != "0")
            str += " AND em.EmployeeID='" + empID + "' ";
        if (departmentID != "0")
            str += " AND em.Dept_ID='" + departmentID + "' ";
        if (designationID != "0")
            str += " AND em.Desi_ID='" + designationID + "' ";
        str += " having MonthlyCTC>0";
        if (salaryStatus != "2")
            str += " AND SalaryGenerate=" + salaryStatus;
        str += " order by em.EmployeeID";
        string strRemun = "SELECT NAME,RemunerationType,Sequence_No,ID,IsLoan FROM pay_remuneration_master WHERE isActive=1 AND ID<>52 ORDER BY Sequence_No";

        string strEmpRemun = "SELECT EmployeeID,TypeID,TypeName,Amount,RemunerationType FROM pay_employeeremuneration";

        string strAdvnace = "SELECT adv.EmployeeID,SUM(adv.InstallmentAmount)AdvanceAmount FROM pay_employeeadvance adv ";
        strAdvnace += " INNER JOIN pay_employeeadvancedetail advd ON adv.Advance_ID=advd.Advance_ID ";
        strAdvnace += " WHERE advd.IsActive=1 AND adv.IsActive=1 AND MONTH(advd.InstallmentDate)=" + salaryMonth + " AND YEAR(advd.InstallmentDate)=" + salaryYear;
        strAdvnace += " GROUP BY adv.EmployeeID";

        DataTable dtEmp = StockReports.GetDataTable(str);
        DataTable dtRemun = StockReports.GetDataTable(strRemun);
        DataTable dtEmpRemun = StockReports.GetDataTable(strEmpRemun);
        DataTable dtAdvance = StockReports.GetDataTable(strAdvnace);

        DataTable CrossTab = new DataTable();

        CrossTab.Columns.Add(new DataColumn("EmployeeID"));
        CrossTab.Columns.Add(new DataColumn("RegNo"));
        CrossTab.Columns.Add(new DataColumn("EmpName"));
        CrossTab.Columns.Add(new DataColumn("TotalEarning"));
        CrossTab.Columns.Add(new DataColumn("TotalDeduction"));
        CrossTab.Columns.Add(new DataColumn("NetSalary"));
        CrossTab.Columns.Add(new DataColumn("MonthlyCTC"));
        CrossTab.Columns.Add(new DataColumn("SalaryGenerate"));
        foreach (DataRow row in dtRemun.Rows)
        {
            var CoName = row["NAME"].ToString() + "_Head_" + row["RemunerationType"].ToString() + "_" + row["ID"].ToString();
            CrossTab.Columns.Add(new DataColumn(CoName));
        }
        for (int i = 0; i < dtEmp.Rows.Count; i++)
        {
            decimal totalEarning = 0; decimal totalDeduction = 0; decimal totalSalary = 0;

            DataRow newrow = CrossTab.NewRow();
            newrow["EmployeeID"] = dtEmp.Rows[i]["EmployeeID"].ToString();
            newrow["EmpName"] = dtEmp.Rows[i]["EmpName"].ToString();
            newrow["RegNo"] = dtEmp.Rows[i]["RegNo"].ToString();
            newrow["MonthlyCTC"] = dtEmp.Rows[i]["MonthlyCTC"].ToString();
            newrow["SalaryGenerate"] = dtEmp.Rows[i]["SalaryGenerate"].ToString();
            DataRow[] row = dtEmpRemun.Select("EmployeeID='" + dtEmp.Rows[i]["EmployeeID"].ToString() + "'");
            for (int j = 0; j < row.Length; j++)
            {

                string ColumnName = row[j]["TypeName"].ToString() + "_Head_" + row[j]["RemunerationType"].ToString() + "_" + row[j]["TypeID"].ToString();
                newrow[ColumnName] = row[j]["Amount"].ToString();
                if (row[j]["RemunerationType"].ToString() == "E")
                {
                    totalEarning = totalEarning + Util.GetDecimal(row[j]["Amount"]);
                }
                else if (row[j]["RemunerationType"].ToString() == "D")
                {
                    totalDeduction = totalDeduction + Util.GetDecimal(row[j]["Amount"]);
                }
                totalSalary = totalSalary + Util.GetDecimal(row[j]["Amount"]);

            }
            DataRow[] rowItem = dtAdvance.Select("EmployeeID='" + dtEmp.Rows[i]["EmployeeID"].ToString() + "'");
            for (int j = 0; j < rowItem.Length; j++)
            {
                newrow["Advance_Head_D_5"] = rowItem[j]["AdvanceAmount"].ToString();
                totalDeduction = totalDeduction + Util.GetDecimal(rowItem[j]["AdvanceAmount"]);
            }
            newrow["TotalEarning"] = totalEarning;
            newrow["TotalDeduction"] = totalDeduction;
            newrow["NetSalary"] = totalSalary - totalDeduction;

            CrossTab.Rows.Add(newrow);
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(CrossTab);
    }

    [WebMethod(EnableSession = true)]
    public string SaveSalary(List<SalaryDetails> salaryDetails, List<SalaryHeads> salaryHeads)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            ExcuteCMD excuteCMD = new ExcuteCMD();
            var userID = HttpContext.Current.Session["ID"].ToString();
            //  var TransactionID = 0;



            var AdvanceRemunerationID = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT ID FROM pay_remuneration_master WHERE isActive=1 AND IsLoan=1", CommandType.Text, new { }));
            salaryDetails.ForEach(Emp =>
            {
                var strExst = "Select ID From pay_empsalary_transaction where EmployeeID=@EmployeeID and IsActive=1 and UPPER(DATE_FORMAT(SalaryMonth,'%b-%Y'))=@SalaryMonth";
                var IsExistsID = Util.GetInt(excuteCMD.ExecuteScalar(tnx, strExst, CommandType.Text, new
                {
                    EmployeeID = Emp.empID,
                    SalaryMonth = Emp.salaryMonth.ToUpper(),
                }));
                if (IsExistsID > 0)
                {
                    var sqlCMDd = "Update pay_empsalary_transaction set IsActive=0,UpdatedBy=@UpdatedBy,UpdatedDateTime=NOW() where ID=@IsExistsID";
                    excuteCMD.DML(tnx, sqlCMDd, CommandType.Text, new
                    {
                        IsExistsID = IsExistsID,
                        UpdatedBy = userID,
                    });
                    sqlCMDd = "Update pay_empsalary_tnxdetails set IsActive=0,UpdatedBy=@UpdatedBy,UpdatedDateTime=NOW() where TransactionID=@IsExistsID";
                    excuteCMD.DML(tnx, sqlCMDd, CommandType.Text, new
                    {
                        IsExistsID = IsExistsID,
                        UpdatedBy = userID,
                    });
                }
                var maxSlipNo = excuteCMD.ExecuteScalar(tnx, "SELECT get_Employee_Reg_No('SalarySlipNo',1)", CommandType.Text, new { });
                var slipNo = Emp.salaryMonth + "/" + maxSlipNo;
                var sqlCMD = @"INSERT INTO pay_empsalary_transaction (SlipNo,EmployeeID,SalaryMonth,MonthlyCTC,TotalEarning,TotalDeduction,NetPayable,TotalLeave,CreatedBy)
                          VALUES(@SlipNo, @EmployeeID, @SalaryMonth, @MonthlyCTC, @TotalEarning, @TotalDeduction, @NetPayable, @TotalLeave, @CreatedBy);SELECT @@identity;";
                var TransactionID = Util.GetInt(excuteCMD.ExecuteScalar(tnx, sqlCMD, CommandType.Text, new
                {
                    SlipNo = slipNo,
                    EmployeeID = Emp.empID,
                    SalaryMonth = Util.GetDateTime(Emp.salaryMonth).ToString("yyyy-MM-dd"),
                    MonthlyCTC = Util.GetDecimal(Emp.monthlyCTC),
                    TotalEarning = Util.GetDecimal(Emp.totalEarning),
                    TotalDeduction = Util.GetDecimal(Emp.totalDeduction),
                    NetPayable = Util.GetDecimal(Emp.netPayableSalary),
                    TotalLeave = Util.GetDecimal(Emp.noofleave),
                    CreatedBy = userID
                }));

                var AdvanceEmpID = "";
                decimal AdvanceAmt = 0;
                salaryHeads.ForEach(h =>
                {
                    if (Emp.empID == h.empID)
                    {
                        sqlCMD = @"INSERT INTO pay_empsalary_tnxdetails (TransactionID,EmployeeID,SlipNo,RemunarationID,RemunarationName,Amount,RemunarationType,CreatedBy)
                             VALUES(@TransactionID,@EmployeeID, @SlipNo, @RemunarationID, @RemunarationName, @Amount, @RemunarationType, @CreatedBy);";
                        excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                        {
                            TransactionID = TransactionID,
                            EmployeeID = h.empID,
                            SlipNo = slipNo,
                            RemunarationID = h.headName.Split('_')[3],
                            RemunarationName = h.headName.Split('_')[0],
                            Amount = Util.GetDecimal(h.amount),
                            RemunarationType = h.headName.Split('_')[2],
                            CreatedBy = userID
                        });
                        if (AdvanceRemunerationID == Util.GetInt(h.headName.Split('_')[3]) && Util.GetInt(h.headName.Split('_')[3]) > 0)
                        {
                            AdvanceEmpID = h.empID;
                            AdvanceAmt = Util.GetDecimal(h.amount);
                        }
                    }
                });

                if (!string.IsNullOrEmpty(AdvanceEmpID))
                {
                    var sql = "SELECT ad.Advance_ID FROM pay_employeeadvance ad INNER JOIN pay_employeeadvancedetail adf ON ad.Advance_ID=adf.Advance_ID WHERE ad.EmployeeID=@EmployeeID AND ad.isActive=1 AND CONCAT(YEAR(adf.InstallmentDate),'-',MONTH(adf.InstallmentDate))=CONCAT(YEAR(@salaryMonth),'-',MONTH(@salaryMonth))";
                    var AdvanceID = Util.GetInt(excuteCMD.ExecuteScalar(tnx, sql, CommandType.Text, new
                    {
                        EmployeeID = AdvanceEmpID,
                        salaryMonth = Util.GetDateTime(Emp.salaryMonth).ToString("yyyy-MM-dd"),
                    }));
                    if (AdvanceID != 0)
                    {
                        var st = "UPDATE pay_employeeadvance ad SET ad.RecievedAmount=ad.RecievedAmount+@advanceAmt, ad.PendingAmount=ad.PendingAmount-@advanceAmt WHERE ad.EmployeeID=@EmployeeID";
                        excuteCMD.DML(tnx, st, CommandType.Text, new
                        {
                            advanceAmt = AdvanceAmt,
                            EmployeeID = AdvanceEmpID,

                        });
                        var str = "UPDATE pay_employeeadvancedetail SET RecievedAmount=@advanceAmt,RecievedDateTime=NOW(),RecievedBy=@rcvby WHERE Advance_ID=@AdvanceID;";
                        excuteCMD.DML(tnx, str, CommandType.Text, new
                        {
                            advanceAmt = AdvanceAmt,
                            AdvanceID = AdvanceID,
                            rcvby = userID,
                        });
                    }
                }
            });



            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", errorMessage = ex.Message });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

    }



    public class SalaryDetails
    {
        public string empID { get; set; }
        public string salaryMonth { get; set; }
        public string monthlyCTC { get; set; }
        public string totalEarning { get; set; }
        public string totalDeduction { get; set; }
        public string netPayableSalary { get; set; }
        public string noofleave { get; set; }

    }


    public class SalaryHeads
    {
        public string empID { get; set; }
        public string headName { get; set; }
        public string amount { get; set; }
    }

    [WebMethod(EnableSession = true)]
    public string SearchSalaryReport(string salaryMonth, string salaryYear, string departmentID, string designationID, string empID, string salaryStatus) 
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT em.EmployeeID,em.RegNo,CONCAT(em.Title,'',em.Name)EmpName, ");
        sb.Append("(em.TotalEarning+em.TotalDeduction)MonthlyCTC  ,IF(IFNULL(lt.ID,0)=0,'0','1')SalaryGenerate, ");
        sb.Append("UPPER(DATE_FORMAT(SalaryMonth,'%b-%Y'))SalaryMonth,lt.MonthlyCTC,lt.TotalDeduction,lt.TotalEarning,lt.NetPayable,lt.TotalLeave,lt.SlipNo, ");
        sb.Append("ltd.RemunarationName,IF(ltd.RemunarationType='D','Deduction','Earning')RemunarationType,ltd.Amount ");
        sb.Append("FROM employee_master em  ");
        sb.Append("INNER JOIN pay_empsalary_transaction lt ON lt.EmployeeID=em.EmployeeID  ");
        sb.Append("INNER JOIN pay_empsalary_tnxdetails ltd ON lt.ID=ltd.TransactionID ");
        sb.Append("WHERE em.IsActive=1 AND lt.IsActive=1 AND ltd.IsActive=1  ");
        if(departmentID!="0")
            sb.Append("AND em.Dept_ID='" + departmentID + "' ");
        if (designationID != "0")
            sb.Append("AND em.Desi_ID='" + designationID + "' ");
        if (empID != "0")
            sb.Append("AND em.EmployeeID='" + empID + "' ");
        sb.Append("AND MONTH(SalaryMonth)='" + salaryMonth + "' and YEAR(SalaryMonth)='" + salaryYear + "' ");
        sb.Append("HAVING MonthlyCTC>0 ; ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
        //    ds.WriteXmlSchema(@"D:\SalaryReport.xml");
            HttpContext.Current.Session["ds"] = ds;
            HttpContext.Current.Session["ReportName"] = "SalaryReport";
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, responseURL = "../Payroll/Report/Commonreport.aspx" });
        }
        else 
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });
        }
    }

}