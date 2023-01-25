using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.IO;
using System.Reflection;
using ClosedXML.Excel;

public class ConvertDataTableToExcel
{
    public static string GenerateExcel(string StoreProcedureName, string ReportType)
    {
        string FileName = string.Empty;
        DataTable dt = StockReports.GetDataTable("CALL " + StoreProcedureName + "");
        if (dt.Rows.Count > 0)
        {
            dt = Util.GetDataTableRowSum(dt);
        }
        //dt.WriteXml("D:/Test.xls");

        ClassLog lc = new ClassLog();
        if (All_LoadData.chkDocumentDrive() == 0)
        {
            lc.GeneralLog("Please Create " + Resources.Resource.DocumentDriveName + " Drive");
            return "Please Create " + Resources.Resource.DocumentDriveName + " Drive";
        }
        var directoryPath = All_LoadData.createDocumentFolder("EmailFiles", "");
        if (directoryPath == null)
        {
            lc.GeneralLog("Please Create Document Folder");
            return "Please Create Document Folder";
        }

        FileName = Path.Combine(directoryPath.ToString(), "" + Guid.NewGuid() + ".xlsx");
        if (File.Exists(FileName))
        {
            File.Delete(FileName);
        }
        using (var wb = new XLWorkbook())
        {
            wb.Worksheets.Add(dt, "Customers");
            wb.SaveAs(FileName);
        }
        return FileName;
    }

}
