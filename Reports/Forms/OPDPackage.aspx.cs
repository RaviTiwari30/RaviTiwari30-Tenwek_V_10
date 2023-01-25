using System;
using System.Data;
using CrystalDecisions.CrystalReports.Engine;

public partial class Reports_Forms_OPDPackage : System.Web.UI.Page
{
    private ReportDocument rpt = new ReportDocument();

    protected void Page_Init(object sender, EventArgs e)
    {
        if (Session["PackageData"] != null)
        {
            DataSet ds = (DataSet)Session["PackageData"];
            DataColumn dc = new DataColumn();
            dc.ColumnName = "lang_code";
            dc.DefaultValue = GetGlobalResourceObject("Resource", "Lang_Code").ToString();
            ds.Tables[0].Columns.Add(dc);

            DataTable dtImg = All_LoadData.CrystalReportLogo();
            ds.Tables.Add(dtImg.Copy());
            //DataTable dt= (DataTable)Session["ImageData"];
            //ds.Tables.Add(dt);
            // ds.WriteXmlSchema(@"E:\packagedata.xml");
            rpt.Load(Server.MapPath("~/Reports/Reports/OpdPackage.rpt"));
            rpt.SetDataSource(ds);
            System.IO.MemoryStream m = (System.IO.MemoryStream)rpt.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
            rpt.Close();
            rpt.Dispose();
            Response.ClearContent();
            Response.ClearHeaders();
            Response.Buffer = true;
            Response.ContentType = "application/pdf";
            Response.BinaryWrite(m.ToArray());
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
    }

    protected void Page_UnLoad(object sender, EventArgs e)
    {
        if (rpt != null)
        {
            rpt.Close();
            rpt.Dispose();
        }
    }
}
