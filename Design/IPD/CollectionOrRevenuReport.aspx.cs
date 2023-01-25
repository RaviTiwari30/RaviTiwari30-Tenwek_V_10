using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;
using MySql.Data.MySqlClient;

public partial class Design_IPD_CollectionOrRevenuReport : System.Web.UI.Page
{


    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // FillDateTime();
            ucFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            BindPanel();
        }
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");
    }

    private void BindPanel()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("Select Company_name,PanelID from f_panel_Master order by Company_name");

        DataTable dtPanel = StockReports.GetDataTable(sb.ToString());

        ddlPanel.DataSource = dtPanel;
        ddlPanel.DataTextField = "Company_name";
        ddlPanel.DataValueField = "PanelID";
        ddlPanel.DataBind();

        ddlPanel.Items.Insert(0, new ListItem("ALL", "0"));

    }
    protected void chkOPD_CheckedChanged(object sender, EventArgs e)
    {
        if (chkOPD.Checked)
        {
            chkOPDDtl.Visible = true;
            foreach (ListItem li in chkOPDDtl.Items)
            {
                li.Selected = true;
            }
        }
        else
        {
            chkOPDDtl.Visible = false;
            foreach (ListItem li in chkOPDDtl.Items)
            {
                li.Selected = false;
            }
        }
    }
    protected void chkIPD_CheckedChanged(object sender, EventArgs e)
    {
        if (chkIPD.Checked)
        {
            chkIPDDtl.Visible = true;
            foreach (ListItem li in chkIPDDtl.Items)
            {
                li.Selected = true;
            }
        }
        else
        {
            chkIPDDtl.Visible = false;
            foreach (ListItem li in chkIPDDtl.Items)
            {
                li.Selected = false;
            }
        }
    }
    protected void btnPreview_Click(object sender, EventArgs e)
    {
        string startDate = string.Empty, toDate = string.Empty, user, colType;

        if (Util.GetDateTime(ucFromDate.Text).ToString() != "")
            if (ucFromDate.Text.Trim() != string.Empty)
                startDate = Util.GetDateTime(Util.GetDateTime(ucFromDate.Text)).ToString("yyyy-MM-dd");
            else
                startDate = Util.GetDateTime(Util.GetDateTime(ucFromDate.Text)).ToString("yyyy-MM-dd");
        if (Util.GetDateTime(ucToDate.Text).ToString() != string.Empty)
            if (ucToDate.Text.Trim() != string.Empty)
                toDate = Util.GetDateTime(Util.GetDateTime(ucToDate.Text)).ToString("yyyy-MM-dd");
            else
                toDate = Util.GetDateTime(Util.GetDateTime(ucToDate.Text)).ToString("yyyy-MM-dd");
        string OPDTypes = "", IPDTypes = "";

        if (chkOPD.Checked == true)
        {
            foreach (ListItem li in chkOPDDtl.Items)
            {
                if (li.Selected)
                {
                    if (OPDTypes == "")
                        OPDTypes = "'" + li.Text + "'";
                    else
                        OPDTypes += ",'" + li.Text + "'";
                }
            }
        }

        if (chkIPD.Checked == true)
        {
            foreach (ListItem li in chkIPDDtl.Items)
            {
                if (li.Selected)
                {
                    if (IPDTypes == "")
                        IPDTypes = "'" + li.Text + "'";
                    else
                        IPDTypes += ",'" + li.Text + "'";
                }
            }
        }

        ExcuteCMD excuteCMD = new ExcuteCMD();

        StringBuilder sb = new StringBuilder();


        if (chkIPD.Checked == true && chkOPD.Checked == false)
        {
            sb.Append("call rpt_RevenueCollectionReportIPD(@fromDate,@todate,@panelIDs,@transactionTypesIPD,@transactionTypesOPD);");
        }

        if (chkIPD.Checked == false && chkOPD.Checked == true)
        {
            sb.Append("call rpt_RevenueCollectionReportOPD(@fromDate,@todate,@panelIDs,@transactionTypesIPD,@transactionTypesOPD);");
        }
        if (chkOPD.Checked == true && chkIPD.Checked == true) 
        {
            sb.Append("call rpt_RevenueCollectionReportOPDIPD(@fromDate,@todate,@panelIDs,@transactionTypesIPD,@transactionTypesOPD);");
        }

        if (sb.ToString() == string.Empty)
            return;

    //    DataTable dt = StockReports.GetDataTable(sb.ToString());
        var dt = excuteCMD.GetDataTable(sb.ToString(), CommandType.Text, new
        {
            fromdate = startDate,
            todate = toDate,
            panelIDs = ddlPanel.SelectedValue,
            transactionTypesIPD = IPDTypes,
            transactionTypesOPD = OPDTypes,
        });

        if (dt != null && dt.Rows.Count > 0)
        {
            lblMsg.Text = "Total " + dt.Rows.Count + " Record(s) Found";
            DataColumn dc = new DataColumn("Period", Type.GetType("System.String"));
            dc.DefaultValue = "Period From : " + startDate + " To : " + toDate;
            dt.Columns.Add(dc);

            dc = new DataColumn("Filter", Type.GetType("System.String"));
            dc.DefaultValue = rbtReportType.SelectedItem.Text;
            dt.Columns.Add(dc);

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            Session["ds"] = ds;

            if (rbtReportType.SelectedItem.Value == "0")
                Session["ReportName"] = "CollectionRevenueSummary";
            else
                Session["ReportName"] = "CollectionRevenueDetail";
            //C:\inetpub\wwwroot\amrapali\Design\Finanace\CommonCrystalReport.aspx
            //ds.WriteXmlSchema("c:/anandCollectionRevenue.xml");
          //  ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Comman/CommonCrystalReport.aspx');", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);

        }
        else
            lblMsg.Text = "No Record Found";

    }
}