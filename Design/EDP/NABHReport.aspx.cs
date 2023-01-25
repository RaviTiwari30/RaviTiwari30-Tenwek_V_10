using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_EDP_NABHReport : System.Web.UI.Page
    {
    protected void Page_Load(object sender, EventArgs e)
        {
        if (!IsPostBack)
            {
            txtFromDate.Text = DateTime.Now.ToString("MMM-yyyy");
            calFromDate.EndDate = DateTime.Now;
            }
        txtFromDate.Attributes.Add("readOnly", "true");
        }
    protected void btnSearch_Click(object sender, EventArgs e)
        {
        lblMsg.Text = "";
        string fromDate = Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd");
        string toDate = Util.GetDateTime(fromDate).AddMonths(1).AddDays(-1).ToString("yyyy-MM-dd");
        StockReports.ExecuteScalar("CALL Nabh_Indicators('" + fromDate + "','" + toDate + "')");
        DataTable dt = StockReports.GetDataTable("SELECT nm.Dept Department,nm.Particulars,nt.Dt,nt.Nos  FROM   nabh_tmp nt INNER JOIN nabh_master nm ON nm.id=nt.ID");



        if (dt.Rows.Count > 0)
            {

            DataColumn dc = new DataColumn();
            dc.ColumnName = "ReportDate";
            dc.DefaultValue = "Month Of : " + Util.GetDateTime(txtFromDate.Text).ToString("MMM-yyyy");
            dt.Columns.Add(dc);


            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            //  ds.WriteXmlSchema("E:\\NABHReport.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "NABHReport";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key2", "window.open('../../Design/common/Commoncrystalreportviewer.aspx');", true);

            //Session["ReportName"] = "NABH Indicators";
            //Session["Period"] = "Month Of : " + Util.GetDateTime(txtFromDate.Text).ToString("MMM-yyyy");
            //Session["dtExport2Excel"] = dt;
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "Key2", "window.open('../../Design/common/ExportToExcel.aspx');", true);

            }

        else
            {
            lblMsg.Text = "Record Not Found";
            }
        }

    }