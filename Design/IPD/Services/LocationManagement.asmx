<%@ WebService Language="C#" Class="LocationManagement" %>


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

using System.Linq;

using System.Configuration;
using System.Collections;

using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to <a href="IPD.asmx">IPD.asmx</a>be called from script, using ASP.NET AJAX, uncomment the following line. 
 [System.Web.Script.Services.ScriptService]
public class LocationManagement  : System.Web.Services.WebService {

    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }
    [WebMethod(EnableSession = true)]
    public string LocationManagementSummary()
    {
        DataTable LocationManagementSummary = StockReports.GetDataTable(" CALL LocationManagementSummary("+ HttpContext.Current.Session["CentreID"].ToString() +") ");
        if (LocationManagementSummary.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(LocationManagementSummary);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public string LocationDetailsPatient(string loc)
    {
        DataTable BedManagementPatient = StockReports.GetDataTable(" CALL BedManagementPatient('" + loc + "') ");
        if (BedManagementPatient.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(BedManagementPatient);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public string UpdateblinkStatus(string pid,string shortcut)
    {
        MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);
            string tablename="";
            string strQuery ="";
            try
            {
                switch (shortcut)
                {
                    case "a":
                        DataTable LocationManagementSummary = StockReports.GetDataTable(" CALL UpdateIsBlinkStatus(" + pid + ") ");
                        break;
                    case "b":
                        tablename = "nursingprogress";
                        strQuery = "Update " + tablename + " Set IsSeen=1 where PatientId=" + pid + "";
                        MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, strQuery);

                        tranx.Commit();

                        break;

                    case "c":
                        tablename = "IsLabsBlink";
                        break;
                    case "d":
                        tablename = "IsReportsBlink";
                        break;

                    case "e":
                        tablename = "IsMedBlink";
                        break;

                    case "f":
                        tablename = "IPD_Patient_ObservationChart";
                        strQuery = "Update " + tablename + " Set IsSeen=1 where PatientId=" + pid + "";
                        MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, strQuery);

                        tranx.Commit();

                        break;

                    case "g":
                        tablename = "IsIOBlink";
                        break;
                    case "h":
                        tablename = "IsFlowSheetsBlink";
                        break;


                    default:
                        // code block
                        break;
                }

                return "";
            }
            catch (Exception ex)
            {
                return "";
            }
            finally {
                tranx.Dispose();
                con.Close();
                con.Dispose();
                    
            }
        
    }
[WebMethod(EnableSession = true)]
    public string GetLocationCount()
    {
        try
            {
                    StringBuilder sb = new StringBuilder();
                    sb.Append("SELECT COUNT(*) AS Total FROM patient_ipd_profile WHERE STATUS='IN' AND centreID="+HttpContext.Current.Session["CentreID"].ToString()+"");

                    DataTable dt = new DataTable();
                    dt = StockReports.GetDataTable(sb.ToString());
                  return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
            catch(Exception exc)
            {
            return "";
            }
    }
}