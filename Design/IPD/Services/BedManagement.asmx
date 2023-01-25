<%@ WebService Language="C#" Class="IPD" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Script;
using System.Collections.Generic;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to <a href="IPD.asmx">IPD.asmx</a>be called from script, using ASP.NET AJAX, uncomment the following line. 
 [System.Web.Script.Services.ScriptService]
public class IPD  : System.Web.Services.WebService {

    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }
    
    [WebMethod(EnableSession = true)]
    public string BedManagementSummary()
    {
        DataTable BedManagementSummary = StockReports.GetDataTable(" CALL BedManagementSummary("+ HttpContext.Current.Session["CentreID"].ToString() +") ");
        if (BedManagementSummary.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(BedManagementSummary);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public string BedDetailsPatient(string SearchType)
    {
        DataTable BedManagementPatient = StockReports.GetDataTable(" CALL BedManagementPatient('" + SearchType + "') ");
        if (BedManagementPatient.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(BedManagementPatient);
        else
            return "";
    }
    
}