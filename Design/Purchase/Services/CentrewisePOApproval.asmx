<%@ WebService Language="C#" Class="CentrewisePOApproval" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using Newtonsoft.Json;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;
using System.Collections.Generic;
using System.Text.RegularExpressions;


[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class CentrewisePOApproval : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }
    
    [WebMethod]
    public string BindCentre()
    {
        DataTable dt = All_LoadData.dtbind_Center();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    
    [WebMethod]
    public string bindEmployee(int centreId)
    {
        DataTable dt = All_LoadData.bindEmployeeCentrewise(Util.GetInt(centreId));
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    
    
    [WebMethod]
    public string BindApprovalMaster()
    {
        string SQL = "SELECT pm.Id,pm.FromAmount,pm.ToAmount,CONCAT(em.Title,' ',em.Name)EmployeeName,pm.EmployeeId,pm.CategoryId,pm.CentreId ,cm.CentreName,DATE_FORMAT(pm.EntryDate,'%d-%b-%Y')EntryDate,CONCAT(em1.Title,' ',em1.Name)EntryBy,(SELECT GROUP_CONCAT(cm.Name) FROM f_categorymaster cm WHERE FIND_IN_SET(cm.CategoryID,pm.CategoryId) )CategoryName FROM f_POApproval_master pm INNER JOIN center_master cm ON cm.CentreID=pm.CentreId INNER JOIN employee_master em ON pm.EmployeeId=em.EmployeeID INNER JOIN employee_master em1 ON pm.EntryBy=em1.EmployeeID WHERE pm.IsActive=1 ORDER BY em.Name ";
        DataTable dt = StockReports.GetDataTable(SQL);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    
    [WebMethod(EnableSession = true)]
    public string saveApprovalMaster(System.Collections.Generic.List<CentrewisePoApproval> PoApproval)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            for (int i = 0; i < PoApproval.Count; i++)
            {
                var item = PoApproval[i];
                
              int IsExist = Util.GetInt(MySqlHelper.ExecuteScalar(tnx,CommandType.Text,"select count(*) from f_POApproval_master pm where pm.IsActive=1 and  pm.CentreId=" + Util.GetInt(item.CentreId) + " and pm.EmployeeId='" + Util.GetString(item.EmployeeId) + "' "));
              if (IsExist == 0)
              {
                  item.EntryBy = HttpContext.Current.Session["ID"].ToString();
                  item.EntryDate = System.DateTime.Now;

                  var sqlCmd = new StringBuilder("INSERT INTO f_POApproval_master(EmployeeId,FromAmount,ToAmount,CategoryId,CentreId,EntryDate,EntryBy) VALUES(@EmployeeId,@FromAmount,@ToAmount,@CategoryId,@CentreId,now(),@EntryBy) ");
                  excuteCMD.DML(tnx, sqlCmd.ToString(), CommandType.Text, item);
              }
              else
              {
                  return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Approval Already Set for Selected Centre and Employee." }); 
              }
            }
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Save Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error Occured. Please contact to Administrator", message = ex.Message });

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public string deleteApprovalMaster(int Id)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
           MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update f_POApproval_master set IsActive=0,UpdatedDate=now(),UpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "' where Id=" + Util.GetInt(Id) + " ");
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Deleted Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error Occured. Please contact to Administrator", message = ex.Message });

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    

    public class CentrewisePoApproval
    {
        public string EmployeeId { get; set; }
        public decimal FromAmount { get; set; }
        public decimal ToAmount { get; set; }
        public string CategoryId { get; set; }
        public int CentreId { get; set; }
        public DateTime EntryDate { get; set; }
        public string EntryBy { get; set; }

    }
}