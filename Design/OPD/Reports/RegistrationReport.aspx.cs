using System;
using System.Data;
using System.Web.UI;
using System.Text;

public partial class Design_OPD_RegistrationReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtfromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ViewState["UserID"] = Session["ID"].ToString();
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnReport);
        }
        txtfromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }
    
    protected void btnReport_Click(object sender, EventArgs e)
    {
        Search();
    }
    public static DataTable SearchRegisteredPatientWithAddress(string uhid,DateTime FromDate, DateTime ToDate, string CentreID, int countryId, int stateid, int districtID, int cityid, string village)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT cm.CentreName,pm.CentreID,pm.PatientID,pm.PatientID MRNo,CONCAT(pm.House_No,', ',IF(pm.PinCode=0,'',CONCAT(pm.PinCode,', ')),pm.City,', ',pm.Country)Address,");
        sb.Append(" pm.mobile,pm.Age,pm.Gender,pm.Email,DATE_FORMAT(pm.DateEnrolled,'%d-%b-%Y')DateEnrolled,CONCAT(pm.title,' ',PName)PName,DATE_FORMAT(pm.DOB,'%d-%b-%Y')DOB ");
        sb.Append(" ,(Select CONCAT(title,' ',Name)RegisterBy from Employee_master WHERE EmployeeID=RegisterBy)RegisterBy,IF(pm.IsInternational=1,'YES','NO')IsInternational,pm.InternationalCountry,pm.InternationalNumber,pm.patientType PatientType ");
        sb.Append(" FROM Patient_master pm INNER JOIN center_master cm ON pm.CentreID=cm.CentreID");
        sb.Append(" WHERE DATE(pm.DateEnrolled)>='" + FromDate.ToString("yyyy-MM-dd") + "'");
        sb.Append(" AND DATE(pm.DateEnrolled)<='" + ToDate.ToString("yyyy-MM-dd") + "' AND cm.CentreID IN (" + CentreID + ")");
        if (countryId != 0)
        {
            sb.Append(" AND pm.countryID='" + countryId + "'");
        }
        if (stateid != 0)
        {
            sb.Append(" AND pm.StateID='" + stateid + "'");
        }
        if (districtID != 0)
        {
            sb.Append(" AND pm.districtID='" + districtID + "'");
        }
        if (cityid != 0)
        {
            sb.Append(" AND pm.cityID='" + cityid + "'");
        }
        if (village != "")
        {
            sb.Append(" OR Locality='" + village + "'");
        }
        if (uhid != "")
        {
            sb.Append(" AND pm.PatientID='" + uhid + "'");
        }

        sb.Append(" order by pm.DateEnrolled");
        return StockReports.GetDataTable(sb.ToString());

    }
    protected void Search()
    {

        string Centre = "";

        lblMsg.Text = "";
        int countryid = 0;
        countryid = Util.GetInt(lblCountryID.Value);
        int stateid = Util.GetInt(lblStateID.Value);
        int districtId = Util.GetInt(lblDistrictID.Value);
        int cityid = Util.GetInt(lblCityID.Value);
        string village = Util.GetString(hfVillage.Value);

        Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }

        DataTable dtSearch = SearchRegisteredPatientWithAddress(txtUHID.Text,Util.GetDateTime(txtfromDate.Text), Util.GetDateTime(txtToDate.Text), Centre, countryid, stateid, districtId, cityid, village);
        if (dtSearch != null && dtSearch.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "ReportDate";
            dc.DefaultValue = "From : " + Util.GetDateTime(txtfromDate.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");
            dtSearch.Columns.Add(dc);
            dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
            dtSearch.Columns.Add(dc);

            DataTable dtImg = All_LoadData.CrystalReportLogo();

            DataSet ds = new DataSet();
            ds.Tables.Add(dtImg.Copy());
            ds.Tables[0].TableName = "Logo";
            ds.Tables.Add(dtSearch.Copy());
            ds.Tables[1].TableName = "table";
            if (rdoReportType.SelectedItem.Value == "0")
            {
               // ds.WriteXmlSchema(@"D:\RegistrationReport.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "RegistrationReport";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../../Design/common/Commonreport.aspx');", true);
            }
            else
            {
                dtSearch.Columns.Remove("PatientID");
                dtSearch.Columns.Remove("CentreID");
                dtSearch.Columns["Mobile"].ColumnName = "Contact No.";
                dtSearch.Columns["PName"].ColumnName = "Patient Name";
                Session["dtExport2Excel"] = dtSearch;
                Session["ReportName"] = "RegistrationReport";
                Session["Period"] = dtSearch.Rows[0]["ReportDate"].ToString();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../../Design/common/ExportToExcel.aspx');", true);
            }
        }
        else
        {
            lblMsg.Text = "Record Not Found";
        }
    }
}