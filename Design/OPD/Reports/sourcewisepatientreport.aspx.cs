using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;

public partial class Design_OPD_sourcewisepatientreport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
           // All_LoadData.bindReferDoctor(ddlReferDoctor, "All");
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnSearch);
            source();
            calFromDate.EndDate = DateTime.Now;
            calToDate.EndDate = DateTime.Now;
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }
    private void source()
    {
        ddlsource.DataSource = StockReports.GetDataTable(" SELECT DISTINCT(HospPatientType) source FROM patient_master ORDER BY HospPatientType ");        
        ddlsource.DataTextField = "source";
        ddlsource.DataBind();
        ddlsource.Items.Insert(0, new ListItem("ALL", "0"));
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == string.Empty)
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT cm.CentreName,cm.CentreID,pm.PatientID,pmh.Type,CONCAT(pm.Title,' ',pm.PName)PName,IF(pm.Gender='Male','M','F')Gender,pm.Age,CONCAT(pm.House_No,IF(pm.House_No!='',',',''),pm.City,',',pm.Country )Address, ");
        sb.Append(" pm.HospPatientType Name,IF(pmh.Type='IPD',REPLACE(pmh.TransactionID,'ISHHI',''),'')IPDNo,DATE_FORMAT(pmh.dateofVisit,'%d-%b-%Y')DateOfVisit,pnl.Company_Name  ");
        sb.Append(" FROM patient_master pm  INNER JOIN patient_medical_history pmh ON pmh.PatientID=pm.PatientID  INNER JOIN center_master cm ON cm.CentreID=pmh.CentreID   ");
        sb.Append(" INNER JOIN f_panel_master pnl ON pmh.`PanelID`=pnl.`PanelID`  WHERE pmh.PatientID<>'' AND cm.CentreID IN (" + Centre + ") ");
        sb.Append(" AND date(pmh.DateofVisit)>='" + (Convert.ToDateTime(txtFromDate.Text)).ToString("yyyy-MM-dd") + "'  AND date(pmh.DateofVisit)<='" + (Convert.ToDateTime(txtToDate.Text)).ToString("yyyy-MM-dd") + "'");
        if (ddlsource.SelectedItem.Text == "ALL")
        {
            sb.Append(" group by pm.PatientID ORDER BY date(pmh.DateofVisit)");
        }
        else
        {
            sb.Append(" AND pm.HospPatientType= '" + ddlsource.SelectedItem.Text.Trim() + "' group by pm.PatientID ORDER BY date(pmh.DateofVisit)");
        }

        DataTable dt = StockReports.GetDataTable(sb.ToString()); 
        if (dt.Rows.Count > 0)
        {
            lblMsg.Text = "";
            txtFromDate.Text = Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy");
            txtToDate.Text = Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");

            DataColumn dc = new DataColumn();
            dc.ColumnName = "ReportDate";
            dc.DefaultValue = "From : " + Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + "  To : " + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
            dt.Columns.Add(dc);
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
          //  ds.WriteXmlSchema("F:\\ptntsourcereport.xml");
            if (rdoReportType.SelectedItem.Value == "0")
            {
                Session["ds"] = ds;
                Session["ReportName"] = "PtntSourcewiseReport";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../common/Commonreport.aspx');", true);
            }
            else
            {
                dt.Columns.Remove("CentreID");
                Session["dtExport2Excel"] = dt;
                Session["ReportName"] = "PtntSourcewiseReport";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../common/ExportToExcel.aspx');", true);
            }
        }
        else
            lblMsg.Text = "Record Not Found";
    }
}