using System;
using System.Data;
using System.Web.UI;
using System.Text;

public partial class Design_OPD_DoctorWiseBusiness : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnSearch);
            txtFromDate_CalendarExtender.EndDate = DateTime.Now;
            txtToDate_CalendarExtender.EndDate = DateTime.Now;
        }
        txtFromDate.Attributes.Add("readOnly", "readOnly");
        txtToDate.Attributes.Add("readOnly", "readOnly");
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
        string Typeoftnx = StockReports.ExecuteScalar("SELECT GetTypeoftnx('OPD')");
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT t.DoctorID,t.doctor ,t.TypeOfTnx,CentreID,CentreName, ");
        if (rblType.SelectedValue == "1")
            sb.Append(" SUM(t.GrossAmount1)GrossAmount ");
        else
            sb.Append("sum(t.netamt) GrossAmount ");
        sb.Append(" FROM (SELECT pmh.DoctorID,CONCAT(dm.title,' ',dm.Name)Doctor,REPLACE(IF(lt.TypeOfTnx='OPD-LAB','DIAGNOSIS',lt.TypeOfTnx),'OPD-','')TypeOfTnx1, ");
        sb.Append("  ltd.rate*ltd.Quantity GrossAmount1, ltd.rate,ltd.Quantity ,lt.GrossAmount,cm.ConfigID,cm.Name,lt.LedgerTransactionNo, ");
        sb.Append("  IF(cm.`ConfigID`=5,'APPOINTMENT',IF(cm.`ConfigID`=3,'DIAGNOSIS',IF(cm.`ConfigID`=25,'PROCEDURE','OTHERS')))TypeOfTnx, ");
        sb.Append("  ltd.Amount netamt,lt.CentreID,cem.CentreName ");
        sb.Append("  FROM f_ledgertransaction lt  ");
        sb.Append("  INNER JOIN  f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=lt.LedgerTransactionNo ");
        sb.Append("  INNER JOIN  f_subcategorymaster sm ON sm.SubCategoryID=ltd.SubCategoryID ");
        sb.Append("  INNER JOIN f_configrelation cm ON sm.CategoryID=cm.CategoryID ");
        sb.Append("  INNER JOIN patient_medical_history pmh ON pmh.transactionID=lt.transactionID    ");
        sb.Append("  INNER JOIN doctor_master dm ON dm.DoctorID=pmh.DoctorID   ");
        sb.Append("  INNER JOIN Center_master cem ON cem.CentreID = lt.CentreID   ");
        sb.Append("  WHERE lt.TypeOFtnx IN (" + Typeoftnx + ") AND lt.CentreID IN (" + Centre + ") ");
        sb.Append("  AND lt.IsCancel=0 and lt.date>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND lt.date<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' )  t  GROUP BY t.CentreID,t.DoctorID,t.TypeOfTnx  ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "ReportDate";
            if ((txtFromDate.Text != "") && (txtToDate.Text != ""))
                dc.DefaultValue = "From : " + Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");
            dt.Columns.Add(dc);
            dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = Convert.ToString(Session["LoginName"]);
            dt.Columns.Add(dc);
            dc = new DataColumn();
            dc.ColumnName = "ReportName";
            dc.DefaultValue = "Doctor Wise OPD Business " + "(" + rblType.SelectedItem.Text + ")";
            dt.Columns.Add(dc);
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            // ds.WriteXmlSchema(@"E:\DoctorWiseBusiness.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "DoctorWiseBusiness";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../common/Commonreport.aspx');", true);
        }
        else
            lblMsg.Text = "Record Not Found";
    }
}