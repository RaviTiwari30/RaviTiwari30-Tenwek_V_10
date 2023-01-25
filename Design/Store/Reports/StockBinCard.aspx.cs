using System;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Web.Services;
using System.Collections.Generic;
using System.Text;

public partial class Design_Finance_StockBinCard : System.Web.UI.Page
{
   
    protected void Page_Load(object sender, EventArgs e)
    {
       
    }

    [WebMethod]
    public static string Store_Get_StockBinCard(List<string> data)
    {
        try
        {
            ExcuteCMD excuteCMD = new ExcuteCMD();
            var dt = excuteCMD.GetDataTable("Call Store_Get_StockBinCard(@vCenterID,@vCategoryID,@vSubcategoryID,@vItemID,@vDeptledgerNo, " +
                "@vPeriodFrom,@vPeriodTo)", CommandType.Text, new
                {
                    vCenterID = data[0],
                    vCategoryID = data[2],
                    vSubcategoryID = data[3],
                    vItemID = data[4],
                    vDeptledgerNo = data[1],
                    vPeriodFrom = Util.GetDateTime(data[5]).ToString("yyyy-MM-dd"),
                    vPeriodTo = Util.GetDateTime(data[6]).ToString("yyyy-MM-dd"),
                });
				
            if (dt.Rows.Count > 0)
            {
                decimal OpeningBalance = 0;
                decimal PreviusInHandQty = 0;
                decimal NewInHandQty = 0;
                decimal RecivedQty = 0;
                decimal IssueQty = 0;

                for (int i = 0; i < 1; i++)
                {
                    if (Util.GetInt(dt.Rows[i]["TnType"].ToString()) == 0 && dt.Rows[i]["PartyName"].ToString() == "Opening Balance")
                    {
                        OpeningBalance = Util.GetDecimal(dt.Rows[i]["RecQty"].ToString());
						DataRow dr = dt.Rows[i];
                        dt.Rows.Remove(dr);
                        dt.AcceptChanges();
                    }
                }

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    RecivedQty = Util.GetDecimal(dt.Rows[i]["RecQty"].ToString());

                    IssueQty = Util.GetDecimal(dt.Rows[i]["IssueQty"].ToString());

                    if (i == 0)
                    {
                        NewInHandQty = (RecivedQty +OpeningBalance)-IssueQty;

                        dt.Rows[i]["QOH"] = NewInHandQty;
                    }
                    else
                    {
                        PreviusInHandQty = Util.GetDecimal(dt.Rows[i - 1]["QOH"].ToString());

                        NewInHandQty = (RecivedQty + PreviusInHandQty) - IssueQty;

                        dt.Rows[i]["QOH"] = NewInHandQty;
                    }
                }
            }

            if (dt.Rows.Count > 0)
            {

                string responseURL = string.Empty;
                if (data[7] == "EXCEL")
                {
                    dt.Columns.Remove("GroupName");
                    dt.Columns.Remove("SubGroupName");
                    dt.Columns.Remove("ItemCode");
                    dt.Columns.Remove("BatchNumber");
                    dt.Columns.Remove("StockDateorder");
                    dt.Columns.Remove("IssueAmt");
                    dt.Columns.Remove("ReceiptAmt");
                    dt.Columns.Remove("TnType");
                    dt.Columns.Remove("DeptName");
                    dt.Columns.Remove("CentreName");
                    dt.Columns.Remove("IssueNo");                    

                    //dt = Util.GetDataTableRowSum(dt);
                    //HttpContext.Current.Session["ReportName"] = "Stock BinCard Report";
                    //HttpContext.Current.Session["dtExport2Excel"] = dt;
                    //HttpContext.Current.Session["Period"] = "From Date :" + Util.GetDateTime(data[5]).ToString("yyyy-MM-dd") + " To Date :" + Util.GetDateTime(data[6]).ToString("yyyy-MM-dd");
                    //responseURL = "../../../Design/Common/ExportToExcel.aspx";

                    DataColumn dc = new DataColumn();
                    dc.ColumnName = "Period";
                    dc.DefaultValue = "Period From : " + Util.GetDateTime(data[5]).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(data[6]).ToString("dd-MMM-yyyy");
                    dt.Columns.Add(dc);

                    dt = Util.GetDataTableRowSum(dt);
                    string ReportName = "Stock BinCard Report";
                    string CacheName = HttpContext.Current.Session["ID"].ToString();
                    Common.CreateCachedt(CacheName, dt);
                    responseURL = "../../../Design/commonReports/Commonreport.aspx?ReportName=" + ReportName + "&Type=E";


                }
                else if (data[7] == "PDF")
                {
                    DataColumn dc = new DataColumn();
                    dc.ColumnName = "Period";
                    dc.DefaultValue = "From Date : " + Util.GetDateTime(data[5]).ToString("dd-MMM-yyyy") + " To Date" + Util.GetDateTime(data[6]).ToString("dd-MMM-yyyy");
                    dt.Columns.Add(dc);

                    dc = new DataColumn();
                    dc.ColumnName = "UserName";
                    dc.DefaultValue = StockReports.GetUserName(Convert.ToString(HttpContext.Current.Session["ID"])).Rows[0][0];
                    dt.Columns.Add(dc);

                    DataSet ds = new DataSet();
                    ds.Tables.Add(dt.Copy());
                    //ds.WriteXmlSchema("C:/Ankur/StoreBinCardReport.xml");
                    HttpContext.Current.Session["ds"] = ds;
                    HttpContext.Current.Session["ReportName"] = "StoreBinCardReport";
                    responseURL = "../../../Design/common/Commonreport.aspx";
                }
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, responseURL = responseURL });
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
    public static DataTable GetOpeningStatus(string fromDate, string itemIDs, string DeptLedgerNo, string CentreID)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("select temp1.ItemID,(sum(InitialCount)+sum(RtnQty)-sum(SellQty))OpenQty,(sum(InitAmt)+sum(RtnAmt)-sum(SellAmt))OpenAmt,'' BatchNumber,'0' MRP,'' IndentNo ,PostDate StockDate,");
        sb.Append(" '' PartyName,0.0 AS IssueQty,0.0 AS IssueAmt,0.0 AS ReceiptQty,0.0 AS ReceiptAmt,0 As TnType,'' AS IssueNo,im.typename from(");
        sb.Append(" select StockID,ItemID,InitialCount,(InitialCount*UnitPrice)As InitAmt,0.0 As RtnQty,0.0 As SellQty,0.0 AS RtnAmt,0.0 As SellAmt,date_format(PostDate,'%d-%b-%y') PostDate ");
        sb.Append(" FROM f_stock WHERE Date(PostDate) < '" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' And IsPost = 1 and itemid in (" + itemIDs + ")");
        sb.Append(" AND DeptLedgerNo IN (" + DeptLedgerNo + ") AND CentreID IN (" + CentreID + ") ");

        sb.Append(" Union All SELECT StockID,ItemID,0.0 As InitialCount,0.0 As InitAmt,(Case When TrasactionTypeID in ('2','5','10','12','14','17') Then SoldUnits End)As RtnQty,");
        sb.Append(" (Case When TrasactionTypeID not in ('2','5','10','12','14','17') Then SoldUnits End)As SellQty,(Case When TrasactionTypeID in ('2','5','10','12','14','17') Then SoldUnits*PerUnitBuyPrice End)As RtnAmt,");
        sb.Append(" (Case When TrasactionTypeID not in ('2','5','10','12','14','17') Then SoldUnits*PerUnitBuyPrice End)As SellAmt,date_format(Date,'%d-%b-%y')Date FROM f_salesdetails ");
        sb.Append(" WHERE TrasactionTypeID IN('1','2','3','5','7','8','9','10','11','12','13','14','15','16','17') And Date < '" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' and itemid in (" + itemIDs + ")   ");
        if (DeptLedgerNo != "ALL")
            sb.Append(" AND DeptLedgerNo =" + DeptLedgerNo + " AND CentreID IN (" + CentreID + ") ");
        sb.Append(" )temp1 inner join f_itemmaster im on temp1.Itemid = im.itemid group by temp1.ItemID");

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }


}