using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;

public partial class Design_IPD_NeedleInjuryReport : System.Web.UI.Page
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
        sb.Append("SELECT Replace(TransactionID,'ISHHI','')TransactionID,PatientID,ID,EmployeeID,EmployeeName,NeedleStickDate,NeedleStickTime,Age,Sex,Ward,Address,Designation,DateofIncident,TimeofIncident, ");
        sb.Append("DateofReporting,TimeofReporting,Procedures,Activities,NatureOfInjury,Contamination,FirstAid,GlovesWorn,HEPB,Tetanus,SourceOfPatient,AntiHCV,HbsAg ");
        sb.Append("FROM nursing_needleStick_Injury  WHERE  IsActive=1 ");
        if (txtPID.Text != "")
            sb.Append(" AND PatientID='" + txtPID.Text + "' ");
        if (txtBookingID.Text != "")
            sb.Append("AND Tansaction_ID='ISHHI'+'" + txtBookingID.Text + "' ");
        sb.Append("AND NeedleStickDate>='" + Util.GetDateTime(txtPreSurgeryDateFrom.Text).ToString("yyyy-MM-dd") + "' AND NeedleStickDate<='" + Util.GetDateTime(txtPreSurgeryDateTo.Text).ToString("yyyy-MM-dd") + "' ");
        DataTable dtIncident = StockReports.GetDataTable(sb.ToString());
        if (dtIncident.Rows.Count > 0)
        {
            grdSurgery.DataSource = dtIncident;
            grdSurgery.DataBind();
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
                PrintIncidentReport(ID, TID);
            }
        }
    }
    private void PrintIncidentReport(string ID, string TID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ID,EmployeeID,EmployeeName,Date_Format(NeedleStickDate,'%d-%b-%Y')NeedleStickDate,Date_format(NeedleStickTime,'%l:m% %p')NeedleStickTime,Age,Sex,Ward,Address,Designation,Date_format(DateofIncident,'%d-%b-%Y')DateofIncident,Date_format(TimeofIncident,'%l:%m %p')TimeofIncident,");
        sb.Append(" Date_Format(DateofReporting,'%d-%b-%Y')DateofReporting,Date_Format(TimeofReporting,'%l:%m %p')TimeofReporting,Procedures,Activities,NatureOfInjury,Contamination,FirstAid,GlovesWorn,Date_format(HEPB,'%d-%b-%Y')HEPB,Date_format(Tetanus,'%d-%b-%Y')Tetanus,SourceOfPatient,AntiHCV,HbsAg ");
        sb.Append(" FROM nursing_needleStick_Injury  ");
        sb.Append("WHERE IsActive=1 AND ID='" + ID + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            ds.Tables[0].TableName = "NeedleInjury";
            AllQuery AQ = new AllQuery();
            DataTable dtStatus = AQ.GetPatientDischargeStatus("ISHHI" + TID);
            string Status = dtStatus.Rows[0]["Status"].ToString();
            DataTable dtInfo = AQ.GetPatientIPDInformation("", "ISHHI" + TID, Status);
            ds.Tables.Add(dtInfo.Copy());
            ds.Tables[1].TableName = "PatientInfo";
            DataTable dtImg = All_LoadData.CrystalReportLogo();
            ds.Tables.Add(dtImg.Copy());
            ds.Tables[2].TableName = "logo";
            Session["ReportName"] = "NeedleInjuryReport";
            Session["ds"] = ds;
            //ds.WriteXmlSchema(@"E:\NeedleInjuryReport.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
        }
        else
        {
            lblMsg.Text = "Record Not Found";
        }
    }
}