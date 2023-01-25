using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

public partial class Design_Lab_SampleCollectionReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            FrmDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtFromTime.Text = "00:00AM";
            txtToTime.Text = "11:59PM";
            bindUser();
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnSearch);
           
        }
        FrmDate.Attributes.Add("readOnly", "true");
        ToDate.Attributes.Add("readOnly", "true");
    }
    private void bindUser()
    {
        DataTable dt = new DataTable();
        string str = "SELECT CONCAT(em.Title,' ',NAME)AS NAME,em.EmployeeID FROM employee_master em INNER JOIN f_login fl ON fl.employeeID=em.EmployeeID WHERE roleID IN ('11','61','196') GROUP BY em.employeeID ORDER BY em.name";

        dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {
            ddlUsers.DataSource = dt;
            ddlUsers.DataTextField = "Name";
            ddlUsers.DataValueField = "EmployeeID";
            ddlUsers.DataBind();
            ddlUsers.Items.Insert(0, "ALL");
        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        string Centre = "";
        lblMsg.Text = "";
        Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT plo.BarcodeNo AS LabNO,CONCAT(pm.title,'',pm.Pname)AS PatientName,plo.PatientID AS MRNo,im.Name AS TestName, ");
        sb.Append(" '' SampleReceiveDate,'' SampleReceiverName, ");
        sb.Append(" '' ResultenteredDate,'' ResultEnteredName,cm.CentreName ");
        sb.Append(" FROM Patient_labinvestigation_OPD plo  INNER JOIN Center_master cm on cm.CentreID = plo.CentreID and plo.CentreID IN (" + Centre + ")");
        sb.Append(" INNER JOIN Investigation_master im ON im.investigation_ID = plo.investigation_ID ");
        sb.Append(" INNER JOIN patient_master pm ON pm.PatientID=plo.PatientID ");
        sb.Append(" INNER JOIN employee_master em ON em.EmployeeID= plo.SampleCollectionBy  ");
        sb.Append(" WHERE plo.isSampleCollected <>'R' AND im.reporttype<>5 ");
        if (txtLabNo.Text != "")
        {
            sb.Append(" and plo.PatientID= '" + Util.GetFullPatientID(txtLabNo.Text.Trim()) + "' ");
        }
        if (ddlUsers.SelectedValue != "ALL")
        {
            sb.Append(" and plo.samplereceiver = '" + ddlUsers.SelectedValue + "' ");
        }
        if(rdbReportType.SelectedValue != "0")
            sb.Append(" and plo.Type = '" + rdbReportType.SelectedValue + "' ");

        sb.Append(" and CONCAT(plo.Date,' ',plo.Time) >='" + (Util.GetDateTime(FrmDate.Text).ToString("yyyy-MM-dd") + ' ' + Util.GetDateTime(txtFromTime.Text).ToString("H:mm:ss")) + "'");
        sb.Append(" and CONCAT(plo.Date,' ',plo.Time) <='" + (Util.GetDateTime(ToDate.Text).ToString("yyyy-MM-dd") + ' ' + Util.GetDateTime(txtToTime.Text).ToString("H:mm:ss")) + "'");
        sb.Append(" ORDER BY plo.SampleReceiveDate ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataColumn DC = new DataColumn("Period");
            DC.DefaultValue = "From : " + FrmDate.Text + ' ' + txtFromTime.Text + "   To : " + ToDate.Text + ' ' + txtToTime.Text;
            dt.Columns.Add(DC);

            DataColumn DC3 = new DataColumn("USER");
            DC3.DefaultValue = Session["LoginName"].ToString();
            dt.Columns.Add(DC3);

            DataColumn DC4 = new DataColumn("HEADER");
            if (rdbReportType.SelectedValue == "1")
                DC4.DefaultValue = "Sample Collection Report OPD";
            else if (rdbReportType.SelectedValue == "2")
                DC4.DefaultValue = "Sample Collection Report IPD";
            else if (rdbReportType.SelectedValue == "3")
                DC4.DefaultValue = "Sample Collection Report Emergency";
            else
                DC4.DefaultValue = "Sample Collection Report";

            dt.Columns.Add(DC4);

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            Session["ReportName"] = "SampleCollectionReport";
            Session["ds"] = ds;
            //ds.WriteXmlSchema(@"d:\SampleCollectionReport.xml");            
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../../Design/Common/Commonreport.aspx');", true);
        }
        else
        {
           // ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            lblMsg.Text = "No Record Found";
        }

    }
}
