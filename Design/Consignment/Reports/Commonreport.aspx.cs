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

public partial class Design_Consignment_Commonreport : System.Web.UI.Page
{   
 ReportDocument obj1 = new ReportDocument();
    protected void Page_Load(object sender, EventArgs e)
    {       
        DataSet ds = new DataSet();

        ds = (DataSet)Session["ds"];
        string ReportName = "";

        if (Session["ReportName"] != null)
        {
            ReportName = Session["ReportName"].ToString();
            Session["ReportName"] = "";

            switch (ReportName)
            {
                    
                    case "StockStatus":
                    {
                        obj1.Load(Server.MapPath(@"~\Design\Consignment\Reports\StockStatus.rpt"));
                        obj1.SetDataSource(ds);
                        break;
                    }
                               
            }
        

                   
                   
           
        }
        System.IO.MemoryStream m = (System.IO.MemoryStream)obj1.ExportToStream(CrystalDecisions.Shared.ExportFormatType.Excel);
        obj1.Close();
        obj1.Dispose();
        Response.ClearContent();
        Response.ClearHeaders();
        Response.Buffer = true;
        Response.AddHeader("Content-Disposition", "attachment; filename=Consignment Stock Status.xls");
        Response.ContentType = "application/vnd.ms-excel";
        Response.BinaryWrite(m.ToArray());
        m.Flush();
        m.Close();
        m.Dispose();
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
