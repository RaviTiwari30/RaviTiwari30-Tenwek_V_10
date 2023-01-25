using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;

public partial class Design_IPD_PatientRoomShiftReport : System.Web.UI.Page
{
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
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        string Centre = "";
        Centre = All_LoadData.SelectCentre(chkCentre);
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ip.PatientID ,REPLACE(ip.TransactionID,'ISHHI','')TransactionID,DATE_FORMAT(ip.StartDate,'%d-%b-%Y')StartDate, ");
        sb.Append(" DATE_FORMAT(ip.StartTime,'%h:%i %p')StartTime,IF(ip.Status='IN','',DATE_FORMAT(ip.EndDate,'%d-%b-%Y'))EndDate,  ");
        sb.Append(" IF(ip.Status='IN','',DATE_FORMAT(ip.EndTime,'%h:%i %p'))EndTime,rm.Bed_No AS BedNo,CONCAT(rm.Name,'-',rm.Floor)FLOOR, ");
        sb.Append(" ctm.Name AS BedCategory,CONCAT(dm.Title,' ',dm.Name)ConsultantName, CONCAT(pm.Title,' ',pm.PName)PatientName, ");
        sb.Append(" pm.Age,pm.Gender,pm.Phone,pm.Mobile,pnl.Company_Name,(SELECT DISTINCT(Department)  ");
        sb.Append(" FROM doctor_hospital  WHERE DoctorID = ich.Consultant_ID)AS Dept,'' AS DischargeStatus, ");
        sb.Append(" pmh.Source,ip.StartDate FROM patient_ipd_profile ip  ");
        sb.Append(" INNER JOIN patient_medical_history PMH ON IP.TransactionID = PMH.TransactionID  ");
        sb.Append(" INNER JOIN ipd_case_history ich  ON ip.TransactionID = ich.TransactionID  ");
        sb.Append(" INNER JOIN room_master rm ON rm.Room_Id = ip.Room_ID   ");
        sb.Append(" INNER JOIN ipd_case_type_master ctm ON ctm.IPDCaseType_ID = rm.IPDCaseTypeID  ");
        sb.Append(" INNER JOIN doctor_master dm ON dm.DoctorID = ich.Consultant_ID   ");
        sb.Append(" INNER JOIN patient_master pm ON pm.PatientID = ip.PatientID  ");
        sb.Append(" INNER JOIN f_panel_master pnl ON pnl.PanelID = ip.PanelID  WHERE ich.Status <> 'Cancel'  AND pmh.CentreID IN (" + Centre + ") ");
        sb.Append(" AND ich.DateOfAdmit >= '" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' AND ich.DateOfAdmit <= '" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "' ");
        sb.Append(" ORDER BY ich.TransactionID,ip.StartDate,ip.StartTime ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataTable dtUser = new DataTable();
            dtUser = StockReports.GetUserName(Convert.ToString(Session["ID"]));
            ucFromDate.Text = Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yyyy");
            ucToDate.Text = Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yyyy");
            DataColumn dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "Period From " + ucFromDate.Text + " To : " + ucToDate.Text;
            dtUser.Columns.Add(dc);
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            ds.Tables[0].TableName = "Patients";
            ds.Tables.Add(dtUser.Copy());
            ds.Tables[1].TableName = "User";
            DataTable dtImg = All_LoadData.CrystalReportLogo();
            ds.Tables.Add(dtImg.Copy());
            //ds.WriteXmlSchema(@"e:\RoomTransfer.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "Patient Room Transfer";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
        }
        else
            lblMsg.Text = "Record Not Found";
    }
}