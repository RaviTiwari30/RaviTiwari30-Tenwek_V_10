using System;
using System.Web;
using System.Web.UI;
using System.Data;
using System.Text;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
using System.Dynamic;
using MySql.Data.MySqlClient;

[System.Runtime.InteropServices.GuidAttribute("6835F596-713E-4A88-B639-37ED5A45AA48")]
public partial class Design_OPD_PaymentAtDesk : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = txtToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            calendarExtenderFromDate.EndDate = calendarExtenderToDate.EndDate = System.DateTime.Now;
        }
        txtFromDate.Attributes.Add("readOnly", "readOnly");
        txtToDate.Attributes.Add("readOnly", "readOnly");

    }


    [WebMethod]
    public static string GetExpenceHead()
    {
        DataTable dtExpenceHead = StockReports.GetDataTable("SELECT id,ExpenceHead FROM f_expencehead WHERE active=1");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtExpenceHead);
    }


    [WebMethod]
    public static string GetExpenceSubHead(int expenceHeadID)
    {

        var sqlCmd = new StringBuilder("SELECT subhead_ID,subhead_name FROM f_expencesubhead ");

        if (expenceHeadID == 1)
            sqlCmd.Append("WHERE expns_type='Overhead Expenses'");
        else if (expenceHeadID == 2)
            sqlCmd.Append("WHERE expns_type='Direct Expenses'");
        else
            sqlCmd.Append(" WHERE 1=2 ");

        sqlCmd.Append("and isActive=1 ORDER BY subhead_name asc");

        DataTable dtExpenceSubHead = StockReports.GetDataTable(sqlCmd.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtExpenceSubHead);

    }

    [WebMethod]
    public static string GetApprovalBy()
    {
        DataTable dtData = StockReports.GetDataTable("select Distinct(ApprovalType) from f_discountapproval order by id");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtData);
    }


    [WebMethod(EnableSession = true)]
    public static string SaveExpence(object expenceReceipt)
    {
        dynamic expenceReceiptObj = JObject.Parse(JsonConvert.SerializeObject(expenceReceipt));
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {

            ExpenceReceipt objRec = new ExpenceReceipt(tnx);
            objRec.Location = AllGlobalFunction.Location;
            objRec.HospCode = AllGlobalFunction.HospCode;
            objRec.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            objRec.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            objRec.AmountPaid = Util.GetDecimal(expenceReceiptObj.AmountPaid);
            objRec.AmtCash = Util.GetDecimal(expenceReceiptObj.AmtCash);
            objRec.Date = DateTime.Now;
            objRec.Time = DateTime.Now;
            objRec.ExpenceTypeId = expenceReceiptObj.ExpenceTypeId;
            objRec.ExpenceType = expenceReceiptObj.ExpenceType;
            objRec.Depositor = HttpContext.Current.Session["id"].ToString();
            objRec.ExpenceToId = expenceReceiptObj.ExpenceToId;
            objRec.ExpenceTo = expenceReceiptObj.ExpenceTo;
            objRec.RoleID = expenceReceiptObj.RoleID;
            objRec.EmployeeID = expenceReceiptObj.EmployeeID;
            objRec.Naration = expenceReceiptObj.Naration;
            objRec.ApprovedBy = expenceReceiptObj.ApprovedBy;
            objRec.ReceivedAgainstReceiptNo = expenceReceiptObj.ReceivedAgainstReceiptNo;
            objRec.EmployeeName = expenceReceiptObj.EmployeeName;
            objRec.EmployeeType = expenceReceiptObj.EmployeeType;


            if (!string.IsNullOrEmpty(objRec.ReceivedAgainstReceiptNo))
            {
                ExcuteCMD excuteCMD = new ExcuteCMD();
                var sqlCmd = "UPDATE f_reciept_expence ex SET ex.AdjustmentAmount=ex.AdjustmentAmount+@amount WHERE ex.ReceiptNo=@receiptNo";
                excuteCMD.DML(sqlCmd, CommandType.Text, new {
                    amount = expenceReceiptObj.AmtCash,
                    receiptNo = expenceReceiptObj.ReceivedAgainstReceiptNo
                });
            }
           
            string receiptNo = objRec.Insert();
            tnx.Commit();
            if (!string.IsNullOrEmpty(receiptNo))
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully </br><span class='patientInfo'> With Receipt No : " + receiptNo + "</span>", receiptNo = receiptNo });
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Receipt" });

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




    [WebMethod]
    public static string GetExpenceList(string fromDate, string toDate, string receiptNo)
    {
        var sqlCmd = new StringBuilder("SELECT  ex.ReceiptNo,DATE_FORMAT(ex.date,'%d-%b-%Y') `Date`,ex.AmountPaid,IF(ex.AmountPaid>0,' Issue','Received')ExpenceType,ex.EmployeeName `NAME`,ex.Naration,ex.ExpenceTypeId,ex.ExpenceToId,ex.EmployeeID,ex.RoleID,ex.ApprovedBy,(ex.AmtCash-ex.AdjustmentAmount)RemainAmount,ex.ReceivedAgainstReceiptNo,ex.AdjustmentAmount,ex.EmployeeType  FROM  f_reciept_expence ex ");

        if (string.IsNullOrEmpty(receiptNo))
            sqlCmd.Append(" WHERE  ex.date>=@fromDate AND ex.date<=@toDate   ORDER BY ex.date ASC ");
        else
            sqlCmd.Append(" WHERE  ex.ReceiptNo=@receiptNo ORDER BY ex.date ASC ");

        ExcuteCMD excuteCMD = new ExcuteCMD();
        DataTable dt = excuteCMD.GetDataTable(sqlCmd.ToString(), CommandType.Text, new
        {
            fromDate = Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"),
            toDate = Util.GetDateTime(toDate).ToString("yyyy-MM-dd"),
            receiptNo = receiptNo
        });
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


    [WebMethod]
    public static string NewExpenceTo(string subHeadName, string expenceType)
    {
        try
        {
            string str = "insert into f_expencesubhead(subhead_name,expns_type) values(@subHeadName,@expenceType)";
            ExcuteCMD excuteCMD = new ExcuteCMD();
            var response = excuteCMD.DML(str, CommandType.Text, new
            {
                subHeadName = Util.GetString(subHeadName),
                expenceType = Util.GetString(expenceType)
            });
            if (response > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully" });
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator"});

        }
        catch (Exception ex)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }

    }


    [WebMethod]
    public static string GetEmployeeDoctors(int employeeType) {
        var employeeeType = Util.GetInt(employeeType);
        if (employeeeType == 1)
            return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT CONCAT(em.Title,' ',em.Name)`Name`,em.EmployeeID,de.DoctorID  FROM employee_master em LEFT JOIN doctor_employee de ON de.EmployeeID=em.EmployeeID WHERE de.DoctorID IS NULL AND   em.IsActive=1"));
        else if (employeeeType == 2)
            return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT CONCAT(em.Title,' ',em.Name)`Name`,em.EmployeeID  FROM employee_master em INNER JOIN doctor_employee de ON de.EmployeeID=em.EmployeeID WHERE   em.IsActive=1"));
        else
            return "[]";
    }


}