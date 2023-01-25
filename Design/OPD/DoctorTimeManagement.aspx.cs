using DocumentFormat.OpenXml.Wordprocessing;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;
public partial class Design_OPD_DoctorTimeManagement : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            All_LoadData.bindDocTypeList(ddlDepartment, 5, "All");
            All_LoadData.bindDocTypeList(ddlSpecialization, 3, "All");
            txtFromDate.Text = Util.GetDateTime(System.DateTime.Now).ToString("dd-MMM-yyyy");
            txtToDate.Text = Util.GetDateTime(System.DateTime.Now).ToString("dd-MMM-yyyy");


        }
    }
    


    //protected void btncvs_Click(object sender, ImageClickEventArgs e)
    //{
    //   ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
    //    //string ReportName = Session["ReportName"].ToString();

    //    //Response.Clear();
    //    //Response.AddHeader("content-disposition", "attachment;filename=" + ReportName + ".ods");
    //    //Response.Charset = "";
    //    //Response.ContentType = "application/vnd.ods";

    //    //StringWriter StringWriter = new System.IO.StringWriter();
    //    //HtmlTextWriter HtmlTextWriter = new HtmlTextWriter(StringWriter);
    //    //this.RenderControl(HtmlTextWriter);
    //    ////EmployeeGrid.RenderControl(HtmlTextWriter);
    //    //Response.Write(StringWriter.ToString());
    //    //Response.End();

    //    //Session["dtExport2Excel"] = "";
    //    //Session.Remove("dtExport2Excel");

    //    //Session["ReportName"] = "";
    //    //Session.Remove("ReportName");

   
    //}
    protected void btncvs_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
    }
}