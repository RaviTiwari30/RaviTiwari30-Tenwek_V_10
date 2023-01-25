using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_CommonReports_StatesReports : System.Web.UI.Page
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
    public static string GetExcelReports(int centreID, string fromDate, string toDate, int reporttype, string reportName)
    {
        DataTable dt_ = new DataTable();
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {



            if (reporttype == 1)
            {
                //2019-04-27
                dt_ = excuteCMD.GetDataTable("CALL OPD_Statistics (@fromDate,@toDate,@centreID)", CommandType.Text, new
                {
                    fromDate = Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"),
                    toDate = Util.GetDateTime(toDate).ToString("yyyy-MM-dd"),
                    centreID = centreID

                });
            }
            else if (reporttype == 2)
            {
                dt_ = excuteCMD.GetDataTable("CALL IPD_Statistics (@fromDate,@toDate,@centreID)", CommandType.Text, new
                {
                    fromDate = Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"),
                    toDate = Util.GetDateTime(toDate).ToString("yyyy-MM-dd"),
                    centreID = centreID

                });
            
            }

            else if (reporttype == 3)
            {
                dt_ = excuteCMD.GetDataTable("CALL EMG_Statistics (@fromDate,@toDate,@centreID)", CommandType.Text, new
                {
                    fromDate = Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"),
                    toDate = Util.GetDateTime(toDate).ToString("yyyy-MM-dd"),
                    centreID = centreID

                });

            }
            else if (reporttype == 4)
            {
                dt_ = excuteCMD.GetDataTable("CALL Surgery_Statistics (@fromDate,@toDate,@centreID)", CommandType.Text, new
                {
                    fromDate = Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"),
                    toDate = Util.GetDateTime(toDate).ToString("yyyy-MM-dd"),
                    centreID = centreID

                });

            }
            if (dt_.Rows.Count > 0)
            {
                dt_ = Util.GetDataTableRowSum(dt_);
                dt_ = Util.GetDataTableRowSumOnColumn(dt_);
                HttpContext.Current.Session["dtExport2Excel"] = dt_;
                HttpContext.Current.Session["ReportName"] = "STATS REPORT";
                HttpContext.Current.Session["Period"] = "From " + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy");
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, URL = "../common/ExportToExcel.aspx" });
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
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = ex.Message, message = AllGlobalFunction.errorMessage });

        }
        finally
        {

        }
    }



}