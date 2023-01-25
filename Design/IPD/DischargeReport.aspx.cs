using System;
using System.Data;
using System.IO;
using System.Text;
using System.Web.UI;

public partial class Design_IPD_DischargeReport : System.Web.UI.Page
{
    public static DataTable GetPatientDischargeList(string ReportType, string ItemIDs, string fromDate, string toDate,string Centre)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT cm.`CentreID`,cm.`CentreName`, ip.PatientID 'UHID',pmh.TransNo 'IPD No.',");
        sb.Append(" CONCAT(pm.Title,' ',pm.PName)'Patient Name',pm.Age,pm.Gender as Sex,pm.Mobile as 'Contact No.',CONCAT(pm.`House_No`,',',pm.`Street_Name`,',',pm.`City`,',',pm.`District`,',',pm.`State`)Addres,");
        sb.Append(" Date_Format(pmh.DateOfAdmit,'%d-%b-%Y')'Date Of Admit',DATE_FORMAT(pmh.TimeOfAdmit,'%h:%i %p')'Time Of Admit',");
        sb.Append(" Date_Format(pmh.DateOfDischarge,'%d-%b-%Y')'Date Of Discharge',DATE_FORMAT(pmh.TimeOfDischarge,'%h:%i %p')'Time Of Discharge',");
        sb.Append(" pmh.DischargeType As 'Discharge Status',IF(pmh.DateOfDischarge='0001-01-01',DATEDIFF(CURDATE(),pmh.DateOfAdmit)+1,DATEDIFF(pmh.DateOfDischarge,pmh.DateOfAdmit)+1)DatewiseStay, ");
        sb.Append(" TIMESTAMPDIFF(HOUR,CONCAT(pmh.DateOfAdmit,' ',pmh.TimeOfAdmit),IF(pmh.DateOfDischarge='0001-01-01',NOW(),CONCAT(pmh.DateOfDischarge,' ',pmh.TimeOfDischarge)))HourlyStay, ");
        sb.Append(" ROUND((TIMESTAMPDIFF(HOUR,CONCAT(pmh.DateOfAdmit,' ',pmh.TimeOfAdmit),IF(pmh.DateOfDischarge='0001-01-01',NOW(),CONCAT(pmh.DateOfDischarge,' ',pmh.TimeOfDischarge)))/24),1)ActualDayStay, ");
        sb.Append(" ctm.Name AS 'Bed Category',rm.Bed_No AS 'Bed No.',rm.Floor,CONCAT(dm.Title,' ',dm.Name)'Doctor Name',");
        sb.Append(" (select distinct(Department) from doctor_hospital ");
        sb.Append(" where DoctorID = pmh.DoctorID LIMIT 1)AS 'Dept.',pnl.Company_Name Panel,pmh.Admission_Type,");
        sb.Append(" (select Diagnosis from Diagnosis_master where  ID=pmh.DiagnosisID)Diagnosis1  ,(SELECT NAME FROM employee_master WHERE employeeid=pmh.`DischargedBy`)DischargedBy,erd.`Detail` ");
        sb.Append(" FROM patient_ipd_profile ip ");//INNER JOIN ipd_case_history ich ON ip.TransactionID = ich.TransactionID
        sb.Append(" INNER JOIN patient_medical_history pmh on ip.TransactionID = pmh.TransactionID ");
        sb.Append("  INNER JOIN room_master rm ON rm.RoomId = ip.RoomID ");
        sb.Append(" INNER JOIN ipd_case_type_master ctm ON ctm.IPDCaseTypeID = rm.IPDCaseTypeID INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID  ");
        sb.Append(" INNER JOIN patient_master pm ON pm.PatientID = ip.PatientID  INNER JOIN f_panel_master pnl ON pnl.PanelID = ip.PanelID ");
        sb.Append("  INNER JOIN center_master cm ON cm.`CentreID`=pmh.`CentreID` left join emr_DRDetail erd on erd.`TransactionID`=pmh.`TransactionID` and erd.`Header_Id`=1");
        sb.Append(" WHERE pmh.Status = 'OUT' AND pmh.DateOfDischarge >= '" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND pmh.DateOfDischarge <= '" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' and pmh.CentreID in (" + Centre + ")");
        sb.Append(" Group by pmh.TransactionID Having max(EndDate) Order by pmh.TransactionID ");

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());
        DataColumn dc = new DataColumn();
       
        //dc = new DataColumn();
        dt.Columns.Add("Diagnosis");
      //  dc.ColumnName = "editdate";
        //DataRow row = new DataRow();
        for (int i = 0; i < dt.Rows.Count; i++)
    //    foreach(DataRow row in dt.Rows)
          
        {
            DataRow row = dt.Rows[i];
           
            //string editdate = dt.Rows[row]["Detail"].ToString();
            System.Text.RegularExpressions.Regex rx = new System.Text.RegularExpressions.Regex("<[^>]+>|&nbsp;");
            string editdate = rx.Replace(dt.Rows[i]["Detail"].ToString(), "");
         //   dc.DefaultValue = editdate;
            row["Diagnosis"] = editdate;
           
        }
       // dt.Columns.Add(dc);
        dt.Columns.Remove("Detail");
        dt.Columns.Remove("Diagnosis1");
        return dt;
    }

    public override void VerifyRenderingInServerForm(Control control)
    {
        return;
    }

    protected void btnExport_Click(object sender, EventArgs e)
    {
        Response.Clear();
        Response.AddHeader("content-disposition", "attachment;filename=IPDDischargeDetail.xls");
        Response.Charset = "";
        Response.ContentType = "application/vnd.xls";

        StringWriter StringWriter = new System.IO.StringWriter();
        HtmlTextWriter HtmlTextWriter = new HtmlTextWriter(StringWriter);
        grdDetail.RenderControl(HtmlTextWriter);
        Response.Write(StringWriter.ToString());
        Response.End();
    }

    protected void btnOpenOffice_Click(object sender, EventArgs e)
    {
        Response.Clear();
        Response.AddHeader("content-disposition", "attachment;filename=DoctorRevenue.ods");
        Response.Charset = "";
        Response.ContentType = "application/vnd.xls";

        StringWriter StringWriter = new System.IO.StringWriter();
        HtmlTextWriter HtmlTextWriter = new HtmlTextWriter(StringWriter);
        grdDetail.RenderControl(HtmlTextWriter);
        Response.Write(StringWriter.ToString());
        Response.End();
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        string ItemIDs = string.Empty;

        if (Session["LoginType"] == null)
        {
            return;
        }
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }


        LoginRestrict LR = new LoginRestrict();
        if (!LR.LoginDateRestrict(Util.GetString(Session["RoleID"]), Util.GetDateTime(ucFromDate.Text), Util.GetString(Session["ID"])))
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('" + LoginRestrict.LoginDateRestrictMSG() + "');", true);
            lblMsg.Text = LoginRestrict.LoginDateRestrictMSG();
            return;
        }

        DataTable dtUser = new DataTable();
        dtUser = StockReports.GetUserName(Convert.ToString(Session["ID"]));

        DataColumn dc = new DataColumn();
        dc.ColumnName = "Period";
        dc.DefaultValue = "Period From " + ucFromDate.Text + " To : " + ucToDate.Text;
        dtUser.Columns.Add(dc);

        DataTable dtPatients = new DataTable();

        dtPatients = GetPatientDischargeList("", ItemIDs, ucFromDate.Text, ucToDate.Text,Centre);

        if (dtPatients.Rows.Count > 0)
        {
            grdDetail.DataSource = dtPatients;
            grdDetail.DataBind();
            btnExport.Visible = true;
            btnOpenOffice.Visible = true;
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            btnExport.Visible = false;
            btnOpenOffice.Visible = false;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnSearch);
        }
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");
    }
}