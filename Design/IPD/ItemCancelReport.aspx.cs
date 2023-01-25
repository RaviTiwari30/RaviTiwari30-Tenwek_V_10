using System;
using System.Data;
using System.Web.UI;
using System.Text;

public partial class Design_IPD_ItemCancelReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnSearch);
        }
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");
      
    }


    protected void btnSearch_Click(object sender, EventArgs e)
    {
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        lblMsg.Text = "";
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT (SELECT CONCAT(Title,' ',NAME)DoctorName FROM doctor_master WHERE DoctorID=adj.DoctorID)DoctorName,REPLACE(adj.`TransNo`,'ISHHI','')IPD_No,ltd.Amount,ltd.Quantity, ");
        sb.Append(" ltd.Rate,(SELECT CONCAT(Pm.Title,' ',pm.Pname) NAME FROM patient_master  pm WHERE PatientID=adj.PatientID)PatientName,adj.PatientID,ItemName,CancelReason,cm.`CentreID`,cm.`CentreName`,DATE_FORMAT(CancelDateTime,'%d-%b-%Y')CancelDate, ");
        sb.Append(" (SELECT  CONCAT(em.Title,' ',em.Name) FROM employee_master em WHERE em.EmployeeID=ltd.CancelUserId)CancelBy, ");
        sb.Append(" 'IPD' CaseType,DATE_FORMAT(ltd.EntryDate,'%d-%b-%Y')EntryDate,(SELECT  CONCAT(em.Title,' ',em.Name) FROM employee_master em WHERE em.EmployeeID=ltd.UserId)EntryBy ");
        sb.Append("  FROM f_ledgertnxdetail ltd INNER JOIN Patient_medical_history adj ON adj.TransactionID=ltd.TransactionID INNER JOIN center_master cm ON cm.`CentreID`=adj.`CentreID` ");
        sb.Append("  WHERE  ltd.IsVerified=2 ");
        sb.Append("  AND adj.`TYPE`='IPD' And DATE(CancelDateTime) >='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' and DATE(CancelDateTime) <='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "' and adj.`CentreID` in (" + Centre + ")");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            DataColumn dc = new DataColumn("Period");
            dc.DefaultValue = "From " + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yyyy");
            ds.Tables[0].Columns.Add(dc);
            DataTable dtImg = All_LoadData.CrystalReportLogo();
            ds.Tables.Add(dtImg.Copy());
            Session["ds"] = ds;
            Session["ReportName"] = "CancelIPDReport";
           // ds.WriteXmlSchema("E:/CancelIPDReport.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);

        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }


    }
}