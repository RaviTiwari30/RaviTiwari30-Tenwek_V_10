<%@ WebService Language="C#" Class="Master" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using System.Text;
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class Master  : System.Web.Services.WebService {

    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }
    [WebMethod(EnableSession = true)]
    public string BindRole()
    {
        if (HttpContext.Current.Session["ID"] != null)
        {
            DataTable dt = All_LoadData.LoadRole(Util.GetString(HttpContext.Current.Session["ID"]), Util.GetString(HttpContext.Current.Session["CentreID"].ToString()));
            if (dt.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            else
                return "0";
        }
        else
        {
            return "0";
        }
    }
    [WebMethod(EnableSession = true)]
    public bool ChangeRole(string RoleID)
    {
        if (HttpContext.Current.Session["ID"] != null)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT fl.RoleID,rm.DeptLedgerNo,rm.IsStore,rm.RoleName FROM f_login fl INNER JOIN f_rolemaster rm ON rm.ID=fl.RoleID");
            sb.Append(" WHERE fl.Active = 1 AND fl.RoleID = " + RoleID + " AND fl.EmployeeId = '" + Util.GetString(HttpContext.Current.Session["ID"].ToString()) + "' AND fl.CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + "");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                HttpContext.Current.Session["LoginType"] = dt.Rows[0]["RoleName"].ToString();
                HttpContext.Current.Session["RoleID"] = Util.GetString(dt.Rows[0]["RoleID"]);
                HttpContext.Current.Session["DeptLedgerNo"] = dt.Rows[0]["DeptLedgerNo"].ToString();
                HttpContext.Current.Session["IsStore"] = dt.Rows[0]["IsStore"].ToString();
                return true;
            }
            else
            {
                AllUpdate update = new AllUpdate();
                update.UpdateLoginDetails(HttpContext.Current.Session["ID"].ToString(), HttpContext.Current.Session["RoleID"].ToString(), HttpContext.Current.Session["CentreID"].ToString());
                HttpContext.Current.Session.RemoveAll();
                HttpContext.Current.Session.Abandon();
                return false;
            }
        }
        else
        {
            HttpContext.Current.Session.RemoveAll();
            HttpContext.Current.Session.Abandon();
            return false;
        }
    }
}