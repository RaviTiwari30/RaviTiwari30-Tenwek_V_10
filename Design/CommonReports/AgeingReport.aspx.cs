using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_CommonReports_AgeingReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ceFromDate.EndDate = ceToDate.EndDate = DateTime.Now;
        }
        txtFromDate.Attributes.Add("readonly", "true");
        txtToDate.Attributes.Add("readonly", "true");
    }

    [WebMethod]
    public static string BindCentre()
    {
        DataTable dt = All_LoadData.dtbind_Center();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindPanelCentrewise(int centreID)
    {
        DataTable dt = StockReports.GetDataTable("SELECT TRIM(Company_Name) AS Company_Name,pm.PanelID FROM f_panel_master pm INNER JOIN f_center_panel fcp ON pm.PanelID=fcp.panelID WHERE pm.Isactive=1 AND fcp.CentreID='" + centreID + "' AND fcp.isActive=1 AND pm.DateTo>NOW() ORDER BY Company_Name");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchAgingPanel(string centreID, string doctorID, string panelID, string fromDate, string toDate, string bucketFor, string bucketType, string patienttype, string ReportType, string isBasecurrency)
    {
        string ReportName = "";
        if (bucketType == "0" && (ReportType == "PA" || ReportType == "INCOA" || ReportType == "PUAD" || ReportType == "PUAS"))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Plase Select The Bucket For." });
        }

        if (bucketType != "Panel" && (ReportType == "PUAD" || ReportType == "PUAS"))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Plase Select The Bucket For Panel Only" });
        }

        try
        {
            //(ClaimAmount-(ReceivedAmount+PatientPaidAmount))
            DataTable dt = new DataTable();
            string ageingcriteria = string.Empty;
            if (bucketType != "0" && (ReportType == "INCOA" || ReportType == "SOAS"))
            {
                ageingcriteria = Common.CreateAgeingColumn("AgeingDays", "PanelPayableAmount", "PanelPaidAmount+", bucketFor, bucketType, false);
            }

            if (ReportType == "P")
            {
                ReportName = "Panel Outstanding Report";
                if (bucketType.ToUpper() == "PANEL")
                {
                    ageingcriteria = Common.CreateAgeingColumn("AgeingDays", "PanelPayableAmount", "(PanelPaidAmount+WriteOffAmount)", bucketFor, bucketType, false);
                }
                else if (bucketType.ToUpper() == "DOCTOR")
                {
                    ageingcriteria = Common.CreateAgeingColumn("AgeingDays", "DoctorFees", "DoctorAllocatedAmt", bucketFor, bucketType, false);
                }
                else if (bucketType.ToUpper() == "HOSPITAL")
                {
                    ageingcriteria = Common.CreateAgeingColumn("AgeingDays", "(t.PanelPayableAmount-(t.PanelPaidAmount+t.WriteOffAmount))", "(DoctorFees-DoctorAllocatedAmt)", bucketFor, bucketType, false);
                }
                dt = StockReports.GetDataTable("CALL Bill_Outstanding('" + centreID + "','" + panelID + "','" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "','" + ageingcriteria.Replace("'", "\"") + "','" + patienttype + "','" + bucketFor.ToUpper() + "');");
            }
        //    if (ReportType == "INCOA")
        //    {
        //        ReportName = "Panel Ageing with Due Days";
        //        ageingcriteria = Common.CreateAgeingColumn("AgeingDays", "PanelPayableAmount", "(PanelPaidAmount+WriteOffAmount)", bucketFor, bucketType, false);
        //        dt = StockReports.GetDataTable("CALL sp_individual_soa('" + isBasecurrency + "','" + centreID + "','" + panelID + "','" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "','" + ageingcriteria.Replace("'", "\"") + "','" + patienttype + "','" + bucketFor.ToUpper() + "','" + ReportType + "');");
        //    }
        //    if (ReportType == "INCOAF")
        //    {
        //        ReportName = "Individual COA On Entry Date";
        //        dt = StockReports.GetDataTable("CALL sp_individual_soa('" + isBasecurrency + "','" + centreID + "','" + panelID + "','" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "','" + ageingcriteria.Replace("'", "\"") + "','" + patienttype + "','" + bucketFor.ToUpper() + "','" + ReportType + "');");
        //    }
        //    if (ReportType == "INCOAW")
        //    {
        //        ReportName = "Individual COA On Entry Date(Walkin)";
        //        dt = StockReports.GetDataTable("CALL sp_individual_soa('" + isBasecurrency + "','" + centreID + "','" + panelID + "','" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "','" + ageingcriteria.Replace("'", "\"") + "','" + patienttype + "','" + bucketFor.ToUpper() + "','" + ReportType + "');");
        //    }
			
        //      if (ReportType == "INCOANEW")
        //    {
        //        ReportName = "Individual COA (NEW)";
        //        dt = StockReports.GetDataTable("CALL sp_individual_coa('" + centreID + "','" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "');");

        //    }
			
			
			
            //if (ReportType == "SOAS")
            //{
            //    ReportName = "SOA Summary";
            //    dt = StockReports.GetDataTable("CALL sp_Bill_SOA('" + centreID + "','" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "','" + ageingcriteria.Replace("'", "\"") + "','" + patienttype + "','" + bucketFor.ToUpper() + "');");
            //}
            //if (ReportType == "SOAD")
            //{
            //    ReportName = "SOA Detail";
            //    dt = StockReports.GetDataTable("CALL sp_BillDetail_SOA('" + centreID + "','" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "','" + ageingcriteria.Replace("'", "\"") + "','" + patienttype + "','" + bucketFor.ToUpper() + "');");
            //}
            //if (ReportType == "INDCOA")
            //{
            //    ReportName = "Individual COA";
            //    if (bucketType != "0")
            //    {
            //        ageingcriteria = Common.CreateAgeingColumn("AgeingDays", "PatientPayableAmount", "(PatientPaidAmount+WriteOffAmount)", bucketFor, bucketType, false);
            //    }
            //    dt = StockReports.GetDataTable("CALL Bill_Outstanding_Individual('" + centreID + "','" + panelID + "','" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "','" + ageingcriteria.Replace("'", "\"") + "','" + patienttype + "','" + bucketFor.ToUpper() + "');");
            //}

            if (ReportType == "POS")
            {
                ReportName = "Panel Outstanding Summarized(By Allocation Date)";
                if (bucketType.ToUpper() == "PANEL")
                {
                    ageingcriteria = Common.CreateAgeingColumn("AgeingDays", "PanelPayableAmount", "(PanelPaidAmount+WriteOffAmount)", bucketFor, bucketType, true);
                }
                else if (bucketType.ToUpper() == "DOCTOR")
                {
                    ageingcriteria = Common.CreateAgeingColumn("AgeingDays", "DoctorFees", "DoctorAllocatedAmt", bucketFor, bucketType, true);
                }
                else if (bucketType.ToUpper() == "HOSPITAL")
                {
                    ageingcriteria = Common.CreateAgeingColumn("AgeingDays", "(t.PanelPayableAmount-(t.PanelPaidAmount+t.WriteOffAmount))", "(DoctorFees-DoctorAllocatedAmt)", bucketFor, bucketType, true);
                }

                dt = StockReports.GetDataTable("CALL Bill_Outstanding_summary('" + centreID + "','" + panelID + "','" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "','" + ageingcriteria.Replace("'", "\"") + "','" + patienttype + "','" + bucketFor.ToUpper() + "');");
            }

            if (ReportType == "POD")
            {
                ReportName = "Panel Outstanding Detail(By Allocation Date)";
                if (bucketType.ToUpper() == "PANEL")
                {
                    ageingcriteria = Common.CreateAgeingColumn("AgeingDays", "PanelPayableAmount", "(PanelPaidAmount+WriteOffAmount)", bucketFor, bucketType, true);
                }
                else if (bucketType.ToUpper() == "DOCTOR")
                {
                    ageingcriteria = Common.CreateAgeingColumn("AgeingDays", "DoctorFees", "DoctorAllocatedAmt", bucketFor, bucketType, true);
                }
                else if (bucketType.ToUpper() == "HOSPITAL")
                {
                    ageingcriteria = Common.CreateAgeingColumn("AgeingDays", "(t.PanelPayableAmount-(t.PanelPaidAmount+t.WriteOffAmount))", "(DoctorFees-DoctorAllocatedAmt)", bucketFor, bucketType, true);
                }

                dt = StockReports.GetDataTable("CALL Bill_Outstanding_Details('" + centreID + "','" + panelID + "','" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "','" + ageingcriteria.Replace("'", "\"") + "','" + patienttype + "','" + bucketFor.ToUpper() + "');");
            }

            if (ReportType == "WOSR")
            {
                ReportName = "Writeoff Summary";
                dt = StockReports.GetDataTable("CALL sp_WriteOffSummary('" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "'," + centreID + ");");
            }

            //if (ReportType == "WODR")
            //{
            //    ReportName = "Writeoff Detail(Doctorwise)";
            //    dt = StockReports.GetDataTable("CALL sp_WriteOffDetail('" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "'," + centreID + ");");
            //}

            // if (ReportType == "PUAS")
            // {
            //     ReportName = "Panel Un-Allocated Summary Report";
            //     dt = StockReports.GetDataTable("CALL sp_PanelUnAllocatedReportNew('" + centreID + "','" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "'," + panelID + ",'" + ageingcriteria.Replace("'", "\"") + "','" + bucketFor + "','" + ageingcriteria + "',1);");
            // }

            // if (ReportType == "PUAD")
            // {
            //     ageingcriteria = Common.CreateAgeingColumn("AgeingDays", "0", "OutstandingAmount_AsOnTODate", bucketFor, bucketType, false);
            //     ReportName = "Panel Un-Allocated Outstanding";
            //     dt = StockReports.GetDataTable("CALL sp_PanelUnAllocatedReportNew('" + centreID + "','" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "'," + panelID + ",'" + ageingcriteria.Replace("'", "\"") + "','" + bucketFor + "','',0);");
            // }

            // if (ReportType == "PSOAS")
            // {

            //     ageingcriteria = Common.CreateAgeingColumn("AgeingDays", "NetAmount", "(PanelPaidAmount+PatientPaidAmount)", bucketFor, bucketType, false);
            //     ReportName = "Panel SOA Summary(By Bill Date) Report";
            //     dt = StockReports.GetDataTable(" CALL sp_Bill_SOA('" + centreID + "','" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "','" + ageingcriteria.Replace("'", "\"") + "','" + patienttype + "','" + bucketFor + "' );");
            // }
            // if (ReportType == "PSOAD")
            // {

            //     ageingcriteria = Common.CreateAgeingColumn("AgeingDays", "NetAmount", "AllocatedAmt", bucketFor, bucketType, false);
            //     ReportName = "Panel SOA Detail(By Bill Date) Report";
            //    dt = StockReports.GetDataTable(" CALL sp_BillDetail_SOA('" + centreID + "','" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "','" + ageingcriteria.Replace("'", "\"") + "','" + patienttype + "','" + bucketFor + "' );");
            // }
            // if (ReportType == "DA")
            // {

            //     ageingcriteria = Common.CreateAgeingColumn("AgeingDays", "DoctorFees", "AllocatedAmt", bucketFor, bucketType, true);
            //     ReportName = "Doctor Ageing (By Bill Date) Report";
            //     dt = StockReports.GetDataTable(" CALL sp_DoctorAging('" + centreID + "','" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "','" + ageingcriteria.Replace("'", "\"") + "','" + patienttype + "','" + bucketFor + "','" + doctorID + "' );");
            // }


            if (dt.Rows.Count > 0)
            {
                if (dt.Columns.Contains("TransactionID"))
                    dt.Columns.Remove("TransactionID");
                if (dt.Columns.Contains("PanelID"))
                    dt.Columns.Remove("PanelID");
                if (dt.Columns.Contains("PatientID"))
                    dt.Columns.Remove("PatientID");
                DataColumn dc = new DataColumn();
                dc.ColumnName = "Period";
                dc.DefaultValue = "Period From : " + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy");

                dt.Columns.Add(dc);
                dt = Util.GetDataTableRowSum(dt);

                string CacheName = HttpContext.Current.Session["ID"].ToString();
                Common.CreateCachedt(CacheName, dt);
              //  string ReportName = "Panel Outstanding Report";
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, URL = "../../Design/commonReports/Commonreport.aspx?ReportName=" + ReportName + "&Type=E" });
            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "No Record Found" });
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = ex.Message });
        }
    }
}