using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;

public class DatatableToHTML
{
    public static string HTMLBody(string StoreProcedureName)
    {
        bool IsLandscape = false;
        int PageWidth = 550;
        int PageNoPosition = 500;
        int dataTableWidth = 800;
        DataTable dtData = StockReports.GetDataTable("CALL " + StoreProcedureName + "");
        if (dtData.Rows.Count > 0)
        {
            dtData = Util.GetDataTableRowSum(dtData);
        }
        if (dtData.Columns.Count > 5)
        {
            IsLandscape = true;
        }
        if (IsLandscape)
        {
            PageWidth = 800;
            PageNoPosition = 780;
            dataTableWidth = 1100;
        }
        StringBuilder sb = new StringBuilder();
        sb.Append("<br/>");
        sb.Append(" <table style='border:1px solid; width:" + dataTableWidth + "px;font-family:verdana,geneva,sans-serif' rules='all'><tbody> ");
        DataRow drHeader = dtData.Rows[0];
        sb.Append("<tr style='background-color:#cccccc;font-size:16px;font-weight:bold;'> ");
        for (int i = 0; i < dtData.Columns.Count; i++)
        {
            sb.Append("<td style='text-align:center;border:1px solid;'>" + dtData.Columns[i].ColumnName.ToString().ToUpper() + "</td>");

        }
        sb.Append(" </tr> ");

        foreach (DataRow dr in dtData.Rows)
        {
            sb.Append("<tr style='font-size:14px;'> ");
            foreach (DataColumn dc in dtData.Columns)
            {
                sb.Append("<td style='text-align:center;border:1px solid;'>" + dtData.Rows[dtData.Rows.IndexOf(dr)][dtData.Columns.IndexOf(dc)].ToString() + "</td>");
            }
            sb.Append(" </tr> ");
        }
        sb.Append(" </tbody></table> ");
        return sb.ToString();
    }
}

