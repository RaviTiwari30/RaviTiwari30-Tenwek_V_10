using System;
using System.Data;
using System.Text;
using System.Web.UI;

public partial class Design_IPD_DoctorReferReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            All_LoadData.bindReferDoctor(ddlReferDoctor, "All");
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnSearch);
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
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
        sb.Append(" SELECT cm.CentreName,cm.CentreID,pm.PatientID,pmh.Type,CONCAT(pm.Title,' ',pm.PName)PName,IF(pm.Gender='Male','M','F')Gender,pm.Age,CONCAT(pm.House_No,IF(pm.House_No!='',',',''),pm.City,',',pm.Country )Address, dr.Name,dr.DoctorID,IF(pmh.Type='IPD',REPLACE(pmh.TransactionID,'ISHHI',''),'')IPDNo,DATE_FORMAT(pmh.dateofVisit,'%d-%b-%Y')DateOfVisit,fpm.ProName ,pnl.Company_Name ");
        sb.Append(" FROM doctor_referal dr INNER JOIN patient_medical_history pmh ON pmh.referedBy=dr.DoctorID INNER JOIN center_master cm ON cm.CentreID=pmh.CentreID ");
        sb.Append(" INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID left join f_pro_master fpm on pmh.ProID=fpm.Pro_ID INNER JOIN f_panel_master pnl ON pmh.`PanelID`=pnl.`PanelID` WHERE pmh.referedBy<>'' AND cm.CentreID IN (" + Centre + ") ");
       
        if (txtIPDNo.Text.Trim() != "")
            sb.Append(" AND pmh.TransactionID='ISHHI" + txtIPDNo.Text.Trim() + "' ");
        if (txtMRNo.Text.Trim() != "")
            sb.Append(" AND pm.PatientID='" + txtMRNo.Text.Trim() + "' ");
        if (ddlReferDoctor.SelectedIndex > 0)
            sb.Append(" AND pmh.referedBy='" + ddlReferDoctor.SelectedValue + "'");
        if (rblReportType.SelectedValue != "3")
            sb.Append(" AND pmh.Type='" + rblReportType.SelectedItem.Text + "' ");
        if (txtMRNo.Text.Trim() == "" && txtIPDNo.Text.Trim() == "" && ddlReferDoctor.SelectedIndex == 0)
            sb.Append(" AND date(pmh.DateofVisit)>='" + (Convert.ToDateTime(txtFromDate.Text)).ToString("yyyy-MM-dd") + "'  AND date(pmh.DateofVisit)<='" + (Convert.ToDateTime(txtToDate.Text)).ToString("yyyy-MM-dd") + "'");
        sb.Append(" group by pm.PatientID ORDER BY date(pmh.DateofVisit)");
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

          //  ds.WriteXmlSchema("F:\\DoctorRefer.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "DoctorRefer";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
        }


        else
            lblMsg.Text = "Record Not Found";
    }
}