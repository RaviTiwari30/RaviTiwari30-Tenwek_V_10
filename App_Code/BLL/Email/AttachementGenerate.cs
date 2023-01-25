using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CrystalDecisions.Shared;
using CrystalDecisions.CrystalReports.Engine;
using System.Data;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.IO;
public class AttachementGenerate
{
    public static string GeneratePDF(string StoreProcedureName, string ReportPath, string ExportType, int includecentrelogo)
    {
        ReportDocument obj1 = new ReportDocument();
        try
        {
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
            string FileName = Path.Combine(directoryPath.ToString(), "" + Guid.NewGuid() + ".pdf");
            //var directoryPath = All_LoadData.createDocumentFolder("EmailFiles", "");
            //string filePath = Path.Combine(directoryPath.ToString(), Guid.NewGuid() + ".pdf");

            DataTable dt = StockReports.GetDataTable("CALL " + StoreProcedureName + "");
            if (dt.Rows.Count > 0)
            {
                DataSet ds = new DataSet();
                if (includecentrelogo == 1)
                {
                    DataTable dtImg = new DataTable();// All_LoadData.CrystalReportLogoEmail();
                    ds.Tables.Add(dtImg.Copy());
                }
                ds.Tables.Add(dt.Copy());

                obj1.Load(ReportPath);
                obj1.SetDataSource(ds);

                if (ExportType == "P")
                {
                    CrystalReportPdfConvertable(obj1, FileName);
                }
                else if (ExportType == "E")
                {
                    CrystalReportExcelConvertable(obj1, FileName);
                }
                return FileName;
            }
            else
                return "";
        }
        catch
        {
            return "";
        }
        finally
        {
            obj1.Close();
            obj1.Dispose();
        }
    }
   
    public static string CrystalReportPdfConvertable(ReportDocument obj1, string pdfFile)
    {
        try
        {
            ExportOptions CrExportOptions;
            DiskFileDestinationOptions CrDiskFileDestinationOptions = new DiskFileDestinationOptions();
            PdfRtfWordFormatOptions CrFormatTypeOptions = new PdfRtfWordFormatOptions();
            CrDiskFileDestinationOptions.DiskFileName = pdfFile; //"C:\\SampleReport.pdf";
            CrExportOptions = obj1.ExportOptions;
            {
                CrExportOptions.ExportDestinationType = ExportDestinationType.DiskFile;
                CrExportOptions.ExportFormatType = ExportFormatType.PortableDocFormat;
                CrExportOptions.DestinationOptions = CrDiskFileDestinationOptions;
                CrExportOptions.FormatOptions = CrFormatTypeOptions;
            }
            obj1.Export();
            return pdfFile; //"C:\\SampleReport.pdf";
        }
        catch (Exception ex)
        {
            return ex.Message;
        }
    }
    public static string CrystalReportExcelConvertable(ReportDocument obj, string ExcelFile)
    {
        try
        {
            ExportOptions CrExportOptions;

            DiskFileDestinationOptions CrDiskFileDestinationOptions = new DiskFileDestinationOptions();
            ExcelFormatOptions CrFormatTypeOptions = new ExcelFormatOptions();
            CrDiskFileDestinationOptions.DiskFileName = ExcelFile;
            CrExportOptions = obj.ExportOptions;  //"c:\\csharp.net-informations.xls";
            CrExportOptions.ExportDestinationType = ExportDestinationType.DiskFile;
            CrExportOptions.ExportFormatType = ExportFormatType.Excel;
            CrExportOptions.DestinationOptions = CrDiskFileDestinationOptions;
            CrExportOptions.FormatOptions = CrFormatTypeOptions;
            obj.Export();
            return ExcelFile;
        }
        catch (Exception ex)
        {
            return ex.Message;
        }
    }
}

