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
using System.Text;


public partial class Design_Lab_MailStatus : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtLabNo.Focus();
            BindDepartment();
            All_LoadData.bindPanel(ddlPanel, "All");
            bindRefer();
            bindAccessCentre();

        }

    }


    private void bindRefer()
    {
       
        DataTable dtDoc = StockReports.GetDataTable("select DoctorID,Name from doctor_master where IsActive = 1 order by name ");
        if (dtDoc != null && dtDoc.Rows.Count > 0)
        {
            ddlReferDoctor.DataSource = dtDoc;
            ddlReferDoctor.DataTextField = "Name";
            ddlReferDoctor.DataValueField = "DoctorID";
            ddlReferDoctor.DataBind();
        }
        ddlReferDoctor.Items.Insert(0, new ListItem("Select", "0"));
    }
    private void bindAccessCentre()
    {
        DataTable dt = StockReports.GetDataTable("SELECT cm.CentreID,cm.CentreName FROM centre_access ca INNER JOIN center_master cm ON ca.CentreAccess=cm.CentreID where cm.CentreID=" + Session["CentreID"].ToString() + " AND ca.Employee_ID='" + Session["ID"].ToString() + "' order by cm.Centrename ");
        if (dt.Rows.Count > 0)
        {
            ddlCentreAccess.DataSource = dt;
            ddlCentreAccess.DataTextField = "CentreName";
            ddlCentreAccess.DataValueField = "CentreID";
            ddlCentreAccess.DataBind();
            ddlCentreAccess.Items.Insert(0, new ListItem("Select", "0"));
        }
        else
        {
            
        }
    }
    protected void BindDepartment()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT DISTINCT ot.Name,ot.ObservationType_ID FROM investigation_master im INNER JOIN investigation_observationtype io  ");
        sb.Append(" ON im.Investigation_Id = io.Investigation_ID INNER JOIN observationtype_master ot ON ot.ObservationType_ID = io.ObservationType_Id ");
        if (Convert.ToString(Session["LoginType"]).ToUpper() == "RADIOLOGY")
            sb.Append("  WHERE im.ReportType=5  and ot.isActive=1 ORDER BY ot.Name");
        else
            sb.Append("  WHERE im.ReportType<>5  and ot.isActive=1 ORDER BY ot.Name ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            ddlDepartment.DataSource = dt;
            ddlDepartment.DataValueField = "ObservationType_ID";
            ddlDepartment.DataTextField = "Name";

            ddlDepartment.DataBind();
            ddlDepartment.Items.Insert(0, new ListItem("All", "0"));
        }
    }
}
