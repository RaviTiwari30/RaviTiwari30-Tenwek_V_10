using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;

public partial class Design_IPD_IncidentReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtPreSurgeryDateFrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtPreSurgeryDateTo.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
    }


    protected void btnSearch_Click(object sender, EventArgs e)
    {
        Search();
    }
    private void Search()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT ID,IncidentReportID,PatientID,REPLACE(TransactionID,'ISHHI','')TransactionID, ");
        sb.Append("DATE_FORMAT(IncidentDate,'%d-%b-%Y')IncidentReportDate FROM nursing_IncidentReportForm ");
        sb.Append("WHERE isActive=1 ");
        if(txtPID.Text !="")
        sb.Append(" AND PatientID='"+ txtPID.Text +"' ");
        if(txtPname.Text !="")
        sb.Append("AND Tansaction_ID='ISHHI'+'"+ txtPname.Text +"' ");
        sb.Append("AND IncidentDate>='"+ Util.GetDateTime(txtPreSurgeryDateFrom.Text).ToString("yyyy-MM-dd") +"' AND IncidentDate<='"+ Util.GetDateTime(txtPreSurgeryDateTo.Text).ToString("yyyy-MM-dd") +"' ");
        DataTable dtIncident = StockReports.GetDataTable(sb.ToString());
        if (dtIncident.Rows.Count > 0)
        {
            grdSurgery.DataSource = dtIncident;
            grdSurgery.DataBind();
        }
    }
    private void PrintIncidentReport(string ID,string TID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT IncidentDate,PersonName,Designation,Department,DateOfOccurrence, ");
        sb.Append("Date_Format(TimeOfOccurrence,'%l:%m %p')TimeOfOccurrence,ExactLocation,TypeOfIncident,OtherIncident,IncidentDetail,FactsBehind,Describes,Corrective,IncidentReportID,em.name AS EmployeeName ");
        sb.Append("FROM nursing_IncidentReportForm inc  ");
        sb.Append("INNER JOIN employee_master em ON em.Employee_ID=inc.CreatedBy  ");
        sb.Append("WHERE inc.IsActive=1 AND inc.ID='"+ ID +"' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            ds.Tables[0].TableName = "IncidentReport";
            AllQuery AQ = new AllQuery();
            DataTable dtStatus = AQ.GetPatientDischargeStatus("ISHHI"+TID);
            string Status = dtStatus.Rows[0]["Status"].ToString();
            DataTable dtInfo = AQ.GetPatientIPDInformation("","ISHHI"+TID, Status);
            ds.Tables.Add(dtInfo.Copy());
            ds.Tables[1].TableName = "PatientInfo";
            DataTable dtImg = All_LoadData.CrystalReportLogo();
            ds.Tables.Add(dtImg.Copy());
            ds.Tables[2].TableName = "logo";
            Session["ReportName"] = "IncidentReportForm";
            Session["ds"] = ds;
            //ds.WriteXmlSchema(@"E:\Incident.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
        }
        else
        {
            lblMsg.Text = "Record Not Found";
        }
    }

    protected void grdSurgery_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName.ToString() == "APrint")
        {
            if (e.CommandArgument.ToString() != "")
            {
                string ID = e.CommandArgument.ToString().Split('#')[0];
                string TID = e.CommandArgument.ToString().Split('#')[1];
                PrintIncidentReport(ID,TID);
            }
        }
    }
}