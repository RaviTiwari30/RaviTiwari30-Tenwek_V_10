<%@ WebService Language="C#" Class="ConvertXLSToJSON" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using System.IO;
using ClosedXML.Excel;
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 

[System.Web.Script.Services.ScriptService]
public class ConvertXLSToJSON : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }


    [WebMethod]
    public void  Convert()
    {

        try
        {

            var httpPostedFile = HttpContext.Current.Request.Files["excelFile"].InputStream;
            BinaryReader br = new BinaryReader(httpPostedFile);
            byte[] bytes = br.ReadBytes((Int32)httpPostedFile.Length);
            System.IO.Stream stream = new System.IO.MemoryStream();

            stream.Write(bytes, 0, bytes.Length);

            XLWorkbook workBook = new XLWorkbook(httpPostedFile);

            DataTable dt = new DataTable();


            IXLWorksheet workSheet = workBook.Worksheet(1);
            bool firstRow = true;
            foreach (IXLRow row in workSheet.Rows())
            {

                if (firstRow)
                {
                    foreach (IXLCell cell in row.Cells())
                    {
                        dt.Columns.Add(Util.GetString(cell.Value));
                    }
                    firstRow = false;
                }
                else
                {

                    dt.Rows.Add();
                    int i = 0;

                    if (row.FirstCellUsed() != null)
                    {
                        foreach (IXLCell cell in row.Cells(row.FirstCellUsed().Address.ColumnNumber, row.LastCellUsed().Address.ColumnNumber))
                        {
                            dt.Rows[dt.Rows.Count - 1][i] = cell.Value.ToString();
                            i++;
                        }
                    }
                }

            }

          HttpContext.Current.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = dt }));
        }
        catch (Exception ex)
        {
            HttpContext.Current.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false,  message = ex.Message }));
        }

    }

    [WebMethod]
    public string convertToExcel(object obj)
    {

        return "";
    }






}