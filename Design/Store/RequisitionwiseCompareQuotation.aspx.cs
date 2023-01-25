using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;

public partial class Design_Store_RequisitionwiseCompareQuotation : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void btnreport_Click(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();

        if (txtRequisitionNo.Text == "")
        {
            spnMsg.Text = "Please Enter Any Requisition No.";
            return;
        }
        else
        {
            spnMsg.Text = "";
             dt = StockReports.GetDataTable("CALL sp_PR_VendorQuotation_matrix('" + txtRequisitionNo.Text + "')");

             if (dt.Rows.Count > 0 && dt != null && dt.Rows[0]["blank"].ToString() != "0")
             {
                 dt.Columns.Remove("blank");

                 Session["dtExport2Excel"] = dt;
                 Session["ReportName"] = "Compare Quotation Report RequisitionNo="+txtRequisitionNo.Text;
                 //   Session["Period"] = "From Data:" + Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + " ToDate:" + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");
                 ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/ExportToExcel.aspx');", true);
             }

             else
             {
                 ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert(' No Quotation set against this requisitionNo='" + txtRequisitionNo.Text + "'', function(){});", true);

                 spnMsg.Text = "No Quotation set against this requisitionNo=" + txtRequisitionNo.Text;

             }
        }

        


    }
}