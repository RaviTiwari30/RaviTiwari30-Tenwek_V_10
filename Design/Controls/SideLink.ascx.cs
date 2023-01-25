using System;
using System.IO;
using System.Web.UI;

public partial class Design_Controls_SideLink : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void imgICDCode10_Click(object sender, ImageClickEventArgs e)
    {
        string FileName = "ICD10";

        string url = Server.MapPath("~/Documents/" + FileName + ".xls");
        if (File.Exists(url))
        {

            Response.AddHeader("content-disposition", @"attachment; filename=" + FileName + ".xls");
            Response.ContentType = "application/Excel";
            Response.WriteFile(url);
            Response.End();

        }
    }
    protected void imgCPTCode_Click(object sender, ImageClickEventArgs e)
    {
        string FileName = "CPT_CODES";

        string url = Server.MapPath("~/Documents/" + FileName + ".xls");
        if (File.Exists(url))
        {

            Response.AddHeader("content-disposition", @"attachment; filename=" + FileName + ".xls");
            Response.ContentType = "application/Excel";
            Response.WriteFile(url);
            Response.End();

        }
    }
}