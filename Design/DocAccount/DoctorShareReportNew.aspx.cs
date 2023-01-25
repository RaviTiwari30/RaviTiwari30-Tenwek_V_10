using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;

public partial class Design_DocAccount_DoctorShareReportNew : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ViewState["CurrentCentreID"] = Session["CentreID"].ToString();
    }

    [WebMethod(EnableSession = true)]
    public static string bindDoctorShareControls()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(" CALL bindDoctorShareControls(); "));
    }


    [WebMethod(EnableSession = true)]
    public static string GetDoctorShareReport(int centreID, int doctorID, string patientType, int panelID, string fromDate, string toDate, int reportType, string ShareMonth,string printFormat,string doctorType,int isPosted)
    {

        ExcuteCMD excuteCMD = new ExcuteCMD();

        DataTable dtDoctorShare = excuteCMD.GetDataTable("  CALL DoctorShareReport(@CentreID,@DoctorID,@PatientType,@PanelID,@FromDate,@ToDate,@ReportType,@DoctorType,@IsPosted) ", CommandType.Text, new
        {
            CentreID = centreID,
            DoctorID = doctorID,
            PatientType = patientType,
            PanelID = panelID,
            FromDate = fromDate,
            ToDate = toDate,
            ReportType = reportType,
            DoctorType= doctorType,
            IsPosted= isPosted
        });


        if (dtDoctorShare.Rows.Count== 0 || dtDoctorShare == null)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "No record Found Under This Searching Criteria.." });
        }
        if (printFormat == "R")
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "ShareMonth";
            dc.DefaultValue = ShareMonth;
            dtDoctorShare.Columns.Add(dc);
            dtDoctorShare = Util.GetDataTableRowSum(dtDoctorShare);
            string CacheName = HttpContext.Current.Session["ID"].ToString();
            Common.CreateCachedt(CacheName, dtDoctorShare);


            string ReportName = string.Empty;
            if (reportType == 1)
                ReportName = "Doctor Share Report(Detail)";
            else
                ReportName = "Doctor Share Report(Summary)";

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, URL = "../../Design/commonReports/Commonreport.aspx?ReportName=" + ReportName + "&Type=E" });
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Please Select Only Excel Format." });
      
        }
    }

}