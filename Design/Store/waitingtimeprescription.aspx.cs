using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;
public partial class Design_Store_waitingtimeprescription : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            try
            {

                txtSearchFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                txtSearchToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");

                bindDepartment();

            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
            }
        }
    }

    private void bindDepartment()
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT rm.`DeptLedgerNo` as Deptledgerno,rm.`RoleName` as rolename  FROM f_rolemaster rm WHERE rm.`IsStore`=1 AND rm.`Active`=1 AND rm.`IsIndent`=1 order by rm.rolename ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            ddldepartment.DataSource = dt;
            ddldepartment.DataTextField = "rolename";
            ddldepartment.DataValueField = "Deptledgerno";
            ddldepartment.DataBind();
            ddldepartment.Items.Insert(0, new ListItem("Select", "0"));

            ddldepartment.SelectedValue = Session["DeptLedgerNo"].ToString();
        }


    }
    protected void btnSearch1_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT pm.`PatientID` UHID,CONCAT(pmm.`Title`,' ',pmm.`PName`)PNAME,DATE_FORMAT(pm.date,'%d-%b-%Y')Prescibedate, TIME_FORMAT(pm.`date`,'%H:%i:%s %p')PrescribeTime ");
        sb.Append(" ,DATE_FORMAT(sd.`DATE`,'%d-%b-%Y')Issuedate,TIME_FORMAT(sd.`TIME`,'%H:%i:%s %p')IssueTime,rm.`RoleName`as IssuePharmacyname, ");
        sb.Append(" DATE_FORMAT(sd.`DATE`,'%d-%b-%Y')DispatchDate,TIME_FORMAT(sd.`TIME`,'%H:%i:%s %p')DispatchTime, ");
        sb.Append(" TIMEDIFF(CONCAT(SD.`DATE`,' ',SD.`TIME`),pm.`DATE`)WaitingTime FROM `patient_medicine` pm ");
        sb.Append(" INNER JOIN `f_salesdetails` sd ON pm.`OPDLedgertansactionNO`=sd.`LedgertransactionNo` ");
        sb.Append(" INNER JOIN patient_master pmm ON pmm.`PatientID`=pm.`PatientID` ");
        sb.Append(" INNER JOIN `f_rolemaster` rm ON rm.`DeptLedgerNo`=sd.`DeptLedgerNo` ");
        sb.Append(" WHERE pm.`IsActive`=1 AND pm.`IsIssued`=1 and sd.DeptLedgerNo='"+ddldepartment.SelectedItem.Value+"'");
        
        sb.Append(" and DATE(pm.date)>= '"+Util.GetDateTime(txtSearchFromDate.Text).ToString("yyyy-MM-dd")+"' and DATE(pm.date)>= '"+Util.GetDateTime(txtSearchToDate.Text).ToString("yyyy-MM-dd")+"'   ");
        sb.Append(" GROUP BY pm.`LedgerTransactionNo` ");

        DataTable dt=StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            Session["dtExport2Excel"] = dt;
            Session["ReportName"] = "Average waiting Report";
            //  Session["Period"] = dtSearch.Rows[0]["ReportDate"].ToString();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
        }
        else {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Record Note Found', function(){});", true);
        }
    }
}