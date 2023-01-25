using System;
using System.Data;
using System.Web;
using System.Web.UI.HtmlControls;
using System.IO;
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;
using ClosedXML.Excel;

public partial class Design_Store_Reports_CommonReport : System.Web.UI.Page
{
	 ReportDocument obj1 = new ReportDocument();
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            string ReportName = string.Empty;
            string CacheName = string.Empty;
            string ReportType = string.Empty; //P PDF, E For Excel;
            if (Request.QueryString["ReportName"] != null)
            {
                ReportName = Request.QueryString["ReportName"].ToString();
                CacheName = HttpContext.Current.Session["ID"].ToString();
            }
            else
            {
                Response.Write("<center> <span style='text-align:centre;font-weight:bold;color:red;font-size:20px;'> SomeThing Went Wrong. Please Reopen This Report Or Contact To Admin..!<span></center>");
                return;
            }
            if (Request.QueryString["Type"] != null)
            {
                ReportType = Request.QueryString["Type"].ToString();
            }
            if (ReportType.ToUpper() == "E")
            {
                if (HttpContext.Current.Cache[CacheName] != null)
                {

                    try
                    {
                        using (DataTable dt = (DataTable)HttpContext.Current.Cache[CacheName])
                        {
                            dt.TableName = ReportName;
                            using (var wb = new XLWorkbook())
                            {
                                // Add a DataTable as a worksheet
                                if (!string.IsNullOrEmpty(ReportName))
                                {
                                    string Period = string.Empty;
                                    DataColumnCollection columns = dt.Columns;
                                    if (columns.Contains("Period"))
                                    {
                                        Period = dt.Rows[0]["Period"].ToString();
                                        dt.Columns.Remove("Period");
                                    }
                                    var ws = wb.Worksheets.Add(ReportName);

                                    ws.Cell(3, 1).InsertTable(dt);
                                    //var aa = ws.LastColumnUsed().AsRange();
                                    string lastcolumn = Util.GetString(ws.LastColumnUsed()).Split('!')[1].Split(':')[0].ToString();
                                    ws.Cell("A1").Value = ReportName;
                                    ws.Cell("A1").Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                                    ws.Cell("A1").Style.Font.SetBold();
                                    ws.Cell("A1").Style.Font.SetFontSize(16);
                                    ws.Cell("A1").Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;
                                    ws.Range("A1:" + lastcolumn).Merge();
                                    if (!string.IsNullOrEmpty(Period))
                                    {
                                        string secondrow = lastcolumn.Replace("1", "2");
                                        ws.Cell("A2").Value = Period;
                                        ws.Cell("A2").Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                                        ws.Cell("A2").Style.Font.SetBold();
                                        ws.Cell("A2").Style.Font.SetFontSize(16);
                                        ws.Cell("A2").Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;
                                        ws.Range("A2:" + secondrow).Merge();
                                    }
                                   // ws.Protect();
                                   // ws.Range(1, 1, Util.GetInt(ws.LastRowUsed()), Util.GetInt(ws.LastRowUsed())).Style.Protection.SetLocked(true);
                                    ws.Columns().AdjustToContents();
                                }
                                else
                                {
                                    wb.Worksheets.Add(dt);
                                }
                                byte[] package = ((MemoryStream)GetStream(wb)).ToArray();
                                string attachment = "attachment; filename=" + ReportName + ".xlsx";
                                Response.ClearContent();
                                Response.AddHeader("content-disposition", attachment);
                                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                                Response.BinaryWrite(package);
                                Response.End();
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        ClassLog cl = new ClassLog();
                        cl.errLog(ex);
                        Response.Write("<center> <span style='text-align:centre;font-weight:bold;color:red;font-size:20px;'> SomeThing Went Wrong. Please Reopen This Report Or Contact To Admin..!<span></center>");
                        HttpContext.Current.Cache.Remove(CacheName);
                        return;
                    }
                    HttpContext.Current.Cache.Remove(CacheName);
                }
                else
                {
                    Response.Write("<center> <span style='text-align:centre;font-weight:bold;color:red;font-size:20px;'> SomeThing Went Wrong. Please Reopen This Report Or Contact To Admin..!<span></center>");
                    HttpContext.Current.Cache.Remove(CacheName);
                    return;
                }
            }
            else
            {
                DataSet ds = new DataSet();
                if (HttpContext.Current.Cache[CacheName] != null)
                {
                    ds = (DataSet)HttpContext.Current.Cache[CacheName];
                    HttpContext.Current.Cache.Remove(CacheName);
                }
                else
                {
                    Response.Write("<center> <span style='text-align:centre;font-weight:bold;color:red;font-size:20px;'> SomeThing Went Wrong. Please Reopen This Report Or Contact To Admin..!<span></center>");
                    HttpContext.Current.Cache.Remove(CacheName);
                    return;
                }
                if (ReportName != string.Empty)
                {
                    obj1.Load(Server.MapPath(@"~\Reports\Reports\" + ReportName + ".rpt"));
                    obj1.SetDataSource(ds);
                    if (Request.Browser.IsMobileDevice)
                    {
                        if (!Directory.Exists(Server.MapPath(@"~\TempMobileFile")))
                        {
                            Directory.CreateDirectory(Server.MapPath(@"~\TempMobileFile"));
                        }
                        string NewFileName = Guid.NewGuid().ToString() + ".pdf";
                        obj1.ExportToDisk(ExportFormatType.PortableDocFormat, Server.MapPath(@"~\TempMobileFile\" + NewFileName));
                        Response.Redirect("../../TempMobileFile/" + NewFileName);
                    }
                    else
                    {
                        System.IO.MemoryStream m = (System.IO.MemoryStream)obj1.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
                        obj1.Close();
                        obj1.Dispose();
                        Response.ClearContent();
                        Response.ClearHeaders();
                        Response.Buffer = true;
                        Response.ContentType = "application/pdf";
                        Response.BinaryWrite(m.ToArray());
                        m.Flush();
                        m.Close();
                        m.Dispose();
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            Response.Write("<center> <span style='text-align:centre;font-weight:bold;color:red;font-size:20px;'> SomeThing Went Wrong. Please Reopen This Report Or Contact To Admin..!<span></center>");
        }
    }
	public MemoryStream GetStream(XLWorkbook excelWorkbook)
    {
        MemoryStream fs = new MemoryStream();
        excelWorkbook.SaveAs(fs);
        fs.Position = 0;
        return fs;
    }
	
	protected void Page_UnLoad(object sender, EventArgs e)
    {
        if (obj1 != null)
        {
            obj1.Close();
            obj1.Dispose();
        }
    }
}