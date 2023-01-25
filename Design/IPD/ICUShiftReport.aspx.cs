

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
public partial class Design_IPD_ICUShiftReport : System.Web.UI.Page
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
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", " window.open('./ICUShiftFormPDF.aspx?TestID=O23&LabType=&LabreportType=11&ID=" + spanPatInfoID.InnerText + "');", true);

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

    public void BindDetails(string pid,string ipdno, string fromDate, string toDate)
    {
        try
        {

            StringBuilder sb = new StringBuilder();
            sb.Append("Select *,IFNULL(pmh.TransNo,'') as IPDNo,(Select concat(title,' ',name) from Employee_master where EmployeeID=CreatedBy limit 1)CreatedBy1,DATE_FORMAT(Date,'%d-%b-%Y') AS Date1,(Select pm.PName from Patient_master pm where pm.PatientID=pdf.PatientID order by pm.ID desc LIMIT 1) as Name from  icushiftform pdf inner join patient_medical_history pmh on pmh.PatientID=pdf.PatientId  ");
            if (pid != "")
            {
                sb.Append(" where PatientId='" + pid + "' ");
                if (ipdno != "")
                {
                    sb.Append("  AND  IF(pmh.TransNo,'')= '" + ipdno + "' ");
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
                        sb.Append("  AND  DATE(Date) between '" + Util.GetDateTime(txtSearchFromDate.Text).ToString("yyyy-MM-dd") + "' ");
                        sb.Append("     AND '" + Util.GetDateTime(txtSearchToDate.Text).ToString("yyyy-MM-dd") + "' ");
                    }
                }
            }
            else
            {
                if (ipdno != "")
                {
                    sb.Append("  where  IFNULL(pmh.TransNo,'')='" + ipdno + "' ");
                    if (fromDate != "" && toDate != "")
                    {
                        sb.Append("  and    DATE(Date) between '" + Util.GetDateTime(txtSearchFromDate.Text).ToString("yyyy-MM-dd") + "' ");
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
        BindDetails(txtUHID.Text,txtIPDNo.Text, txtSearchFromDate.Text, txtSearchToDate.Text);

    }
    
    
}