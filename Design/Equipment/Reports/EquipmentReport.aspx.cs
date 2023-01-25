using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using CrystalDecisions.CrystalReports.Engine;

public partial class Reports_Equipment_Report : System.Web.UI.Page
{
    ReportDocument obj1 = new ReportDocument();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["ReportType"] != null)
        {

            DataSet ds = new DataSet();
            ds = (DataSet)Session["EquipmentReport"];

            string ReportType = string.Empty;
            ReportType = Request.QueryString["ReportType"];

            Session.Remove("EquipmentReport");
            if (ReportType == "AssetReport")
            {
                obj1.Load(Server.MapPath(@"AssetReport.rpt"));
            }
            if (ReportType == "AssetTypeName")
            {

                obj1.Load(Server.MapPath(@"PMS.rpt"));
            }
            if (ReportType == "CalibrationReport")
            {
                obj1.Load(Server.MapPath(@"CalibrationReport.rpt"));
                }

            obj1.SetDataSource(ds);

            System.IO.MemoryStream m = (System.IO.MemoryStream)obj1.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
            obj1.Close();
            obj1.Dispose();
            Response.ClearContent();
            Response.ClearHeaders();
            Response.Buffer = true;
            Response.ContentType = "application/pdf";
            Response.BinaryWrite(m.ToArray());
        }
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
