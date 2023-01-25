using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;

public partial class Design_CommonReports_PatientStatementReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void btnreport_Click(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();

        if (txtUHIDNo.Text == "")
        {
            spnMsg.Text = "Please Enter UHID No.";
            return;
        }
        else
        {
            spnMsg.Text = "";
            dt = StockReports.GetDataTable("CALL PatientStatementReport('" + txtUHIDNo.Text + "')");

            if (dt.Rows.Count > 0 && dt != null)
            {
                if (rdoReportType.SelectedItem.Value == "0")
                {
                     dt.Columns.Remove("a");
                     dt.Columns.Remove("TotalBilledAmt");
                     dt.Columns.Remove("TransactionID");	

                    Session["dtExport2Excel"] = dt;
                    Session["ReportName"] = " Patient Statement Report Against this UHID:" + txtUHIDNo.Text;
                    //   Session["Period"] = "From Data:" + Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + " ToDate:" + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/ExportToExcel.aspx');", true);
                }
                else {

                    DataColumn dc = new DataColumn();

                    dc = new DataColumn();
                    dc.ColumnName = "UserName";
                    dc.DefaultValue = Convert.ToString(Session["LoginName"]);
                    dt.Columns.Add(dc);
                    DataSet ds = new DataSet();
                    ds.Tables.Add(dt.Copy());
                    Session["ds"] = ds;
                    Session["ReportName"] = "PatientStatementReport";

                    //ds.WriteXmlSchema("E:/PatientStatementReport.xml");

                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/common/Commonreport.aspx');", true);
                }
            }

            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert(' No Record Found against this UHID:'" + txtUHIDNo.Text + "'', function(){});", true);

                spnMsg.Text = "No Records Found...";

            }
        }

    }
}