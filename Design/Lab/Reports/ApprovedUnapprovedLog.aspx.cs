using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;

public partial class Design_Lab_Reports_ApprovedUnapprovedLog : System.Web.UI.Page
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
        string str = "SELECT CONCAT(em.Title,' ',NAME)AS NAME,em.EmployeeID FROM employee_master em INNER JOIN f_login fl ON fl.employeeID=em.EmployeeID WHERE roleID IN ('11','61','196') GROUP BY employeeID ORDER BY em.name";

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
         //   lblMsg.Text = "Please Select Centre";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please Select Centre');", true);
            return;
        }
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT plo.LedgertransactionNo Visit_No,plo.BarcodeNo,pm.PatientID UHID,pm.Pname PatientName, IF(al.IsApproved = 1, 'Approved','UpApproved')STATUS,IFNULL(em.Name,'') ApprovedDoctor,em1.Name UpdatedBy, ");
        sb.Append("DATE_FORMAT(al.EntryDate,'%d-%b-%y %h:%m:%s %p')UpdatedDate,im.Name 'Test Name' FROM LabApprovalLog al INNER JOIN patient_labinvestigation_opd plo ON plo.Test_ID=al.Test_ID ");
        sb.Append("INNER JOIN patient_master pm ON pm.PatientID = plo.PatientID "); 
        sb.Append("INNER JOIN investigation_master im ON im.Investigation_Id=plo.Investigation_ID ");
        sb.Append("LEFT JOIN employee_master em ON em.EmployeeID=al.DoctorID ");
        sb.Append("INNER JOIN employee_master em1 ON em1.EmployeeID=al.EntryBy  ");
        sb.Append("WHERE plo.CentreID IN ("+ Centre +") ");
        if (ddlUsers.SelectedValue != "ALL")
            sb.Append("AND al.EntryBy='" + ddlUsers.SelectedValue + "' ");
        sb.Append("AND al.EntryDate>='" + Util.GetDateTime(FrmDate.Text).ToString("yyyy-MM-dd") + "' AND al.EntryDate<='" + Util.GetDateTime(ToDate.Text).ToString("yyyy-MM-dd") + "' ");
        sb.Append("ORDER BY al.EntryDate ASC ");
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
                DC4.DefaultValue = "Sample Approved Unapproved Report";

            dt.Columns.Add(DC4);
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
           // Session["ReportName"] = "Sample Approved Unapproved Report";
           // Session["ds"] = ds;           
           // ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../../Design/Common/Commonreport.aspx');", true);

            Session["dtExport2Excel"] = dt;
            Session["ReportName"] = "Sample Approved Unapproved Report";
            Session["Period"] = "From " + Util.GetDateTime(txtFromTime.Text).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(ToDate.Text).ToString("dd-MMM-yyyy");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../common/ExportToExcel.aspx');", true);

        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('No Record Found');", true);
        }
    }
}