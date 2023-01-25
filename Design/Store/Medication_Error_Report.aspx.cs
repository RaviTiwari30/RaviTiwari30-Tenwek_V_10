
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using MySql.Data.MySqlClient;
using System.Web.UI.WebControls;
public partial class Design_Store_Medication_Error_Report : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            try
            {
                
                txtSearchFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                txtSearchToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
            }
        }
    }
    protected void grdPhysical_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {

            int id = Convert.ToInt16(e.CommandArgument.ToString());
            spanPatInfoID.InnerText = ((Label)grdPhysical.Rows[id].FindControl("lblID")).Text;


            if (e.CommandName == "Print")
            {
                //Response.Redirect("/printDrugReactionReport_pdf.aspx?TestID=O23&LabType=&LabreportType=11&PID=" + patientid + "");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", " window.open('../../Design/Store/MEDICATIONERRORREPORTINGFORM_PDF.aspx?TestID=O23&LabType=&LabreportType=11&PID=" + spanPatInfoID.InnerText + "');", true);

            }
            

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
    protected void grdPhysical_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        
    }

    public void BindDetails(string pid, string fromDate, string toDate)
    {
        try
        {

            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT *,DATE_FORMAT(Date,'%d-%b-%Y') AS Date1,DATE_FORMAT(Dateofreport,'%d-%b-%Y') AS Dateofreport1,DATE_FORMAT(DateofSubmission,'%d-%b-%Y') AS DateofSubmission1 FROM medicationerrorreport ");
            if (pid != "")
            {
                sb.Append(" where UHID='" + pid + "' ");
                if (fromDate != "" && toDate != "")
                {
                    sb.Append("  AND  DATE(Date) between '" + Util.GetDateTime(txtSearchFromDate.Text).ToString("yyyy-MM-dd") + "' ");
                    sb.Append("     AND '" + Util.GetDateTime(txtSearchToDate.Text).ToString("yyyy-MM-dd") + "' ");
                }
            }
            else
            {
                if (fromDate != "" && toDate != "")
                {
                    sb.Append("  where    DATE(Date) between '" + Util.GetDateTime(txtSearchFromDate.Text).ToString("yyyy-MM-dd") + "' ");
                    sb.Append("     AND '" + Util.GetDateTime(txtSearchToDate.Text).ToString("yyyy-MM-dd") + "' ");
                }
            }
            sb.Append(" order by ID desc");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                grdPhysical.DataSource = dt;
                grdPhysical.DataBind();
            }
            else
            {
                grdPhysical.DataSource = null;
                grdPhysical.DataBind();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void btnSearch1_Click1(object sender, EventArgs e)
    {
        BindDetails(txtUHID.Text, txtSearchFromDate.Text, txtSearchToDate.Text);

    }
    
    
}