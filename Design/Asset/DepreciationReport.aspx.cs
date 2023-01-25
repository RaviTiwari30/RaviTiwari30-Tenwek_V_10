using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Text;
using System.Data;

public partial class Design_Asset_DepreciationReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
    }
    [WebMethod(EnableSession=true)]
    public static string GetDepretiationReport(string SubcategoryID,string ItemID,string FromDate,string ToDate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT st.LedgerTransactionNo,st.ItemName,'' SerialNo,ast.BatchNumber,st.StockDate AS PurchaseDate, st.InvoiceDate , ");
        sb.Append("st.MajorMRP AS PurchaseMRP, ");
        sb.Append("edm.First_Per,ROUND((st.MajorMRP-(st.MajorMRP*edm.First_Per)/100),2)1stYearValue, ");
        sb.Append("edm.Second_Per,ROUND((st.MajorMRP-(st.MajorMRP*edm.Second_Per)/100),2)2ndYearValue, ");
        sb.Append("edm.Third_Per,ROUND((st.MajorMRP-(st.MajorMRP*edm.Third_Per)/100),2)3rdYearValue, ");
        sb.Append("edm.Fourth_Per,ROUND((st.MajorMRP-(st.MajorMRP*edm.Fourth_Per)/100),2)4thYearValue, ");
        sb.Append("edm.Fifth_Per,ROUND((st.MajorMRP-(st.MajorMRP*edm.Fifth_Per)/100),2)5thYearValue, ");
        sb.Append("edm.Six_Per,ROUND((st.MajorMRP-(st.MajorMRP*edm.Six_Per)/100),2)6thYearValue, ");
        sb.Append("edm.Seventh_Per,ROUND((st.MajorMRP-(st.MajorMRP*edm.Seventh_Per)/100),2)7thYearValue, ");
        sb.Append("edm.Eigth_Per,ROUND((st.MajorMRP-(st.MajorMRP*edm.Eigth_Per)/100),2)8thYearValue, ");
        sb.Append("edm.Nine_Per,ROUND((st.MajorMRP-(st.MajorMRP*edm.Nine_Per)/100),2)9thYearValue, ");
        sb.Append("edm.Ten_Per,ROUND((st.MajorMRP-(st.MajorMRP*edm.Ten_Per)/100),2)10thYearValue ");
        sb.Append("FROM f_stock st  ");
        sb.Append("INNER JOIN eq_Asset_stock ast ON st.StockID=ast.StockID ");
        sb.Append("LEFT JOIN eq_DepreciationMaster edm ON edm.ItemID = st.ItemID AND edm.IsActive=1 ");
        sb.Append("WHERE st.IsPost=1 AND st.IsReturn=0 AND st.IsAsset=1  ");
        
        sb.Append("AND st.StockDate >='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND st.StockDate <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' "); ;
        if(SubcategoryID!="0")
            sb.Append(" AND st.SubCategoryID ='" + SubcategoryID + "'"); ;
        if (ItemID != "0")
            sb.Append(" AND st.ItemID ='" + ItemID + "' ");
        sb.Append(" GROUP BY st.stockid order by st.ItemName ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        HttpContext.Current.Session["dtExport2Excel"] = dt;
        HttpContext.Current.Session["ReportName"] = "Depreciation Report";
        HttpContext.Current.Session["Period"] = "From : " + Util.GetDateTime(FromDate).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(ToDate).ToString("dd-MMM-yyyy");
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, responseURL = "../../Design/common/ExportToExcel.aspx" });
    }
}