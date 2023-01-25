using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;

public partial class Design_Lab_LabApprovalReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            lblMsg.Text = "";
            if (!IsPostBack)
            {
                txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
                txtfromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
                BindDoctor();
                BindUser();
                All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnSearch);
            }
            txtfromDate.Attributes.Add("readOnly", "true");
            txtToDate.Attributes.Add("readOnly", "true");
            calFromDate.EndDate = System.DateTime.Now;
            calToDate.EndDate = System.DateTime.Now;
        }
        catch (Exception ex)
        {
            ClassLog log = new ClassLog();
            log.errLog(ex);
        }
    }
   
    private void BindDoctor()
    {
        DataTable dt = StockReports.GetDataTable("SELECT Ap.EmployeeID,em.NAME as empName " +
               " FROM f_approval_labemployee Ap  INNER JOIN employee_master em ON em.Employeeid=Ap.EmployeeId " +
               " GROUP BY EmployeeId order by em.NAME");
        if ((dt != null) && (dt.Rows.Count > 0))
        {
            chkDoctorList.DataSource = dt;
            chkDoctorList.DataTextField = "empName";
            chkDoctorList.DataValueField = "EmployeeID";
            chkDoctorList.DataBind();
        }
        else
        {
            chkDoctorList.DataSource = null;
            chkDoctorList.DataTextField = "";
            chkDoctorList.DataValueField = "";
            chkDoctorList.DataBind();
            chkDoctorList.Enabled = false;

        }
    }
    private void BindUser()
    {
        string str = @"SELECT em.employeeId,em.Name FROM employee_MAster em
INNER JOIN f_login fl ON fl.EmployeeID= em.employeeid
WHERE em.isactive=1 AND fl.centreid=1 AND fl.RoleID IN (11,104) GROUP BY em.employeeID;";
        DataTable dt = StockReports.GetDataTable(str);
        if ((dt != null) && (dt.Rows.Count > 0))
        {

            chkUserList.DataSource = dt;
            chkUserList.DataTextField = "Name";
            chkUserList.DataValueField = "employeeId";
            chkUserList.DataBind();
        }
        else
        {
            chkUserList.DataSource = null;
            chkUserList.DataTextField = "";
            chkUserList.DataValueField = "";
            chkUserList.DataBind();
            chkUserList.Enabled = false;

        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        string DoctorID = "";
        if (rdbSearchType.SelectedValue == "D")
        {
            DoctorID = StockReports.GetSelection(chkDoctorList);
            if (DoctorID == "")
            {
                lblMsg.Text = "Select At Least One Doctor";
                return;
            }
        }
        else
        {
            DoctorID = StockReports.GetSelection(chkUserList);
            if (DoctorID == "")
            {
                lblMsg.Text = "Select At Least One User";
                return;
            }
        }
        string Centre = "";
        Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Select Centre";
            return;
        }
        StringBuilder sb = new StringBuilder();
        if (rdbSearchType.SelectedValue == "D")
        {
            sb.Append("SELECT cm.CentreName,cm.CentreID, CASE WHEN pli.Type=1 THEN 'OPD' WHEN pli.Type=2 THEN 'IPD' ELSE 'Emergency' END Type,PM.PatientID MRNo,IF(ltd.Type='I',REPLACE(pli.TransactionID,'ISHHI',''),lt.BillNo)IPDNo, ");
            sb.Append("CONCAT(pm.Title,'',pm.pname)PatientName,pm.Age, ltd.itemname AS TestName,pli.PDoctorID, ");
            sb.Append("ApprovedName, (SELECT CONCAT(em.Title,' ',em.Name) FROM employee_master em INNER JOIN doctor_employee dl ON em.employeeID=dl.employeeID WHERE em.employeeID=pli.PDoctorID LIMIT 1) AS 'DoctorName',   ");
            sb.Append(" DATE_FORMAT(lt.Date,'%d-%b-%y') As Date, ");
            sb.Append(" ltd.Quantity,sum(ltd.Rate)Rate,(sum(ltd.rate)*ltd.Quantity)GrossAmt,ROUND(ltd.discamt)Discount,ltd.Amount,IF(ltd.IsPackage=1,'Package Test','')IsPackage ");
            sb.Append(" FROM patient_labinvestigation_opd pli ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo = pli.LedgerTransactionNo ");
            // sb.Append(" INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ");
            sb.Append(" INNER JOIN f_ledgertnxdetail ltd ON ltd.ID=pli.LedgerTnxID  ");
            sb.Append(" INNER JOIN patient_master PM ON pli.PatientID = PM.PatientID INNER JOIN center_master cm ON cm.CentreID=pli.CentreID ");
            sb.Append(" WHERE lt.IsCancel=0 AND IsSampleCollected='Y' AND pli.Approved=1 ");
            if (rdbitem.SelectedValue != "0")
                sb.Append(" AND pli.Type=" + rdbitem.SelectedValue + " ");
            sb.Append(" AND lt.Date >= '" + Util.GetDateTime(txtfromDate.Text).ToString("yyyy-MM-dd") + "' ");
            sb.Append(" AND lt.Date <= '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ");
            sb.Append(" AND pli.CentreID IN (" + Centre + ") AND pli.PDoctorID IN (" + DoctorID + ")  GROUP BY ltd.LedgerTransactionNo,ltd.ItemID");
            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if ((dt.Rows.Count > 0) && (rblReportFormat.SelectedValue == "1"))
            {
                dt.Columns.Remove("PDoctorID");
                dt.Columns.Remove("CentreName");
                dt.Columns.Remove("CentreID");
                Session["dtExport2Excel"] = dt;
                Session["ReportName"] = "Approved By Report";
                Session["Period"] = "Period From : " + Util.GetDateTime(txtfromDate.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy") + " ";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../../Design/common/ExportToExcel.aspx');", true);
            }
            else if ((dt.Rows.Count > 0) && (rblReportFormat.SelectedValue == "2"))
            {
                DataColumn dc = new DataColumn();
                dc.ColumnName = "ReportDate";
                dc.DefaultValue = "From : " + Util.GetDateTime(txtfromDate.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");
                dt.Columns.Add(dc);

                dc = new DataColumn();
                dc.ColumnName = "UserName";
                dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
                dt.Columns.Add(dc);

                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());

                //ds.WriteXmlSchema("D:\\ApprovedByReport.xml");

                Session["ds"] = ds;
                Session["ReportName"] = "ApprovedByReport";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../../Design/common/Commonreport.aspx');", true);
            }
            else
            {
                lblMsg.Text = "No Record Found";
                return;
            }
        }
        else
        {
            sb.Append(" SELECT Category,subcategory,TestName,PerformBy,SUM(TestCount)TestCount FROM (SELECT cm.NAME AS Category,sc.name AS subcategory,im.TypeName AS TestName,em.NAME AS PerformBy,1 TestCount FROM patient_labinvestigation_opd plo  ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.LedgertransactionNo= plo.LedgerTransactionNo ");
            sb.Append(" INNER JOIN f_itemmaster im ON im.Type_ID= plo.Investigation_ID ");
            sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = im.SubcategoryID ");
            sb.Append(" INNER JOIN f_categorymaster cm ON cm.CategoryID = sc.CategoryID ");
            sb.Append(" INNER JOIN employee_master em ON em.EmployeeID= plo.ResultEnteredBy ");
            sb.Append(" INNER JOIN `f_configrelation` cf ON cf.`CategoryID`=sc.`CategoryID` AND cf.`ConfigID`=3");
            sb.Append(" WHERE plo.Date>='" + Util.GetDateTime(txtfromDate.Text).ToString("yyyy-MM-dd") + "' AND plo.Date<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' AND plo.Result_Flag=1 AND plo.CentreID IN (" + Centre + ") ");
            sb.Append(" AND plo.ResultEnteredBy IN (" + DoctorID + ") ");
            sb.Append(" )t GROUP BY TestName,PerformBy Order by TestName");
            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if ((dt.Rows.Count > 0) && (rblReportFormat.SelectedValue == "1"))
            {
              //  int totaltestcount = dt.AsEnumerable().Sum(row => row.Field<int>("TestCount"));
                DataRow dr = dt.NewRow();
                dr[3] = "Total Test";
                dr["TestCount"] = Util.GetInt(dt.Compute("sum([TestCount])", "")).ToString("f2"); ;
                dt.Rows.InsertAt(dr, dt.Rows.Count + 1);
                

                Session["dtExport2Excel"] = dt;
                Session["ReportName"] = "Test Perform User Wise Report";
                Session["Period"] = "Period From : " + Util.GetDateTime(txtfromDate.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy") + " ";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../../Design/common/ExportToExcel.aspx');", true);
            }
            else if ((dt.Rows.Count > 0) && (rblReportFormat.SelectedValue == "2"))
            {
                DataColumn dc = new DataColumn();
                dc.ColumnName = "ReportDate";
                dc.DefaultValue = "From : " + Util.GetDateTime(txtfromDate.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");
                dt.Columns.Add(dc);

                dc = new DataColumn();
                dc.ColumnName = "UserName";
                dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
                dt.Columns.Add(dc);

                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());
              //  ds.WriteXmlSchema("F:\\UserTestPerformReport.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "UserTestPerformReport";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../../Design/common/Commonreport.aspx');", true);

            }
            else
            {
                lblMsg.Text = "No Record Found";
                return;
            }
        }
    }
    protected void rdbSearchType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rdbSearchType.SelectedItem.Value == "D")
        {
            divDoc.Visible = true;
            divUser.Visible = false;
        }
        else
        {
            divDoc.Visible = false;
            divUser.Visible = true;
        }
    }
}