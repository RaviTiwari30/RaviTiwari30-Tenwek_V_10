using System;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Web.Services;
using System.Collections.Generic;
using System.Text;

public partial class Design_Store_IssueReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["Dept"] = Session["DeptLedgerNo"].ToString();
        }   
    }
    [WebMethod]
    public static string Store_Get_IssueDetail(List<string> data)
    {
        try
        {
            //vCenterID INT,vCategoryID VARCHAR(500),vSubcategoryID VARCHAR(1000),
            //vItemID VARCHAR(2500),vStoreLedgerNo VARCHAR(50),vPeriodFrom DATE, vPeriodTo DATE,vDeptFromLedgerNo VARCHAR(20),
            //vDeptToLedgerNo VARCHAR(500),vPatientID VARCHAR(20),
            //vFilterType VARCHAR(1),vReportType VARCHAR(1),vIssueType VARCHAR(1),vPatientType VARCHAR(1)
            ExcuteCMD excuteCMD = new ExcuteCMD();
            var dt = excuteCMD.GetDataTable("Call Store_Get_IssueDetail(@vCenterID,@vCategoryID,@vSubcategoryID,@vItemID,@vStoreLedgerNo, " +
                "@vPeriodFrom,@vPeriodTo,@vDeptFromLedgerNo,@vDeptToLedgerNo,@vPatientID,@vFilterType,@vReportType,@vIssueType,@vPatientType)", CommandType.Text, new
            {
                vCenterID = data[0],
                vCategoryID = data[2],
                vSubcategoryID = data[3],
                vItemID = data[4],
                vStoreLedgerNo = "",
                vPeriodFrom = Util.GetDateTime(data[11]).ToString("yyyy-MM-dd"),
                vPeriodTo = Util.GetDateTime(data[12]).ToString("yyyy-MM-dd"),
                vDeptFromLedgerNo = data[1],
                vDeptToLedgerNo = data[5],
                vPatientID = data[10],
                vFilterType = data[7],
                vReportType = data[6],
                vIssueType = data[8],
                vPatientType = data[9]
            });
            if (dt.Rows.Count > 0)
            {
                dt.Columns.Remove("InHandQty");

				string ReportName = "";
                if (data[6] == "D")
                {
                    DataRow dr = dt.NewRow();
                    dr[13] = "Total : ";
                    dr["PurchasePrice"] = Util.GetFloat(dt.Compute("sum([PurchasePrice])", "")).ToString("f2");
                    dr["SellingPrice"] = Util.GetFloat(dt.Compute("sum([SellingPrice])", "")).ToString("f2");
                    dr["Quantity"] = Util.GetFloat(dt.Compute("sum([Quantity])", "")).ToString("f2");
                    dr["TotalPurchaseValue"] = Util.GetFloat(dt.Compute("sum([TotalPurchaseValue])", "")).ToString("f2");
                    dr["TotalSaleValue"] = Util.GetFloat(dt.Compute("sum([TotalSaleValue])", "")).ToString("f2");
                    dt.Rows.InsertAt(dr, dt.Rows.Count + 1);
                    ReportName = "Issue Status Report (Detailed)";
                }
                else if (data[6] == "S")
                {
                    DataRow dr = dt.NewRow();
                    dr[6] = "Total : ";
                    dr["IssueQty"] = Util.GetFloat(dt.Compute("sum([IssueQty])", "")).ToString("f2");
                    dr["ReturnQty"] = Util.GetFloat(dt.Compute("sum([ReturnQty])", "")).ToString("f2");
                    dr["SellingPrice"] = Util.GetFloat(dt.Compute("sum([SellingPrice])", "")).ToString("f2");
                    dr["PurchasePrice"] = Util.GetFloat(dt.Compute("sum([PurchasePrice])", "")).ToString("f2");
                    dr["TotalSaleValue"] = Util.GetFloat(dt.Compute("sum([TotalSaleValue])", "")).ToString("f2");
                    dr["TotalPurchaseValue"] = Util.GetFloat(dt.Compute("sum([TotalPurchaseValue])", "")).ToString("f2");
                    dt.Rows.InsertAt(dr, dt.Rows.Count + 1);
                    ReportName = "Issue Status Report (Summary)";
                }
				DataColumn dc = new DataColumn();
                dc.ColumnName = "Period";
                dc.DefaultValue = "Period From : " + Util.GetDateTime(data[11]).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(data[12]).ToString("dd-MMM-yyyy");
                dt.Columns.Add(dc);
                string CacheName = HttpContext.Current.Session["ID"].ToString();
                Common.CreateCachedt(CacheName, dt);
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, responseURL = "../../../Design/commonReports/Commonreport.aspx?ReportName=" + ReportName + "&Type=E" });
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
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = AllGlobalFunction.errorMessage });
        }
    }
    [WebMethod]
    public static string BindDepartment()
    {
        DataTable dtdept = LoadCacheQuery.bindStoreDepartment();
        DataView dv = dtdept.DefaultView;
        string CentreID = HttpContext.Current.Session["CentreID"].ToString();
        var ledgerNumber = StockReports.ExecuteScalar("SELECT DISTINCT GROUP_CONCAT(CONCAT('''',rm.DeptLedgerNo,'''')) FROM f_rolemaster rm INNER JOIN f_centre_role cr ON cr.RoleID=rm.id WHERE cr.CentreID IN (" + CentreID + ") AND cr.isActive=1 AND  rm.DeptLedgerNo<>'' ");
        dv.RowFilter = "ledgerNumber in (" + ledgerNumber + ") ";
        dtdept = dv.ToTable();
        dtdept = dtdept.AsEnumerable().Where(r => r.Field<int>("IsStore") == 1 || r.Field<int>("IsMedical") == 1 || r.Field<int>("IsGeneral") == 1).AsDataView().ToTable();
        if (dtdept.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtdept);
        }
        else
            return "";
    }
}