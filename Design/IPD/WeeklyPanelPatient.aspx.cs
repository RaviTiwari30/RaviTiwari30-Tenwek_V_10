using System;
using System.Data;
using System.Web.UI;
using System.Text;
using MySql.Data.MySqlClient;

public partial class Reports_IPD_WeeklyPanelPatient : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucFromDate.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
            ucToDate.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");            
            fillData();
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnSearch);

        }
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");
    }

    #region GetDataTable
    private DataTable GetDataTable(string strQuery)
    {
        MySqlConnection conn;
        conn = Util.GetMySqlCon();
        if (conn.State == ConnectionState.Closed)
            conn.Open();
        DataTable dt = new DataTable();
        dt = MySqlHelper.ExecuteDataset(conn, CommandType.Text, strQuery).Tables[0];
        if (conn.State == ConnectionState.Open)
            conn.Close();
        if (conn != null)
        {
            conn.Dispose();
            conn = null;
        }
        return dt;

    }
    #endregion

    private void fillData()
    {
        ddlFromMonth.Text = DateTime.Now.Month.ToString();
        ddlToMonth.Text = DateTime.Now.Month.ToString();       
    }
    private DataTable GetDetailPanelPatient(string startDate, string toDate, string Centre)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select pmh.PatientID AS Patient_ID,pmh.TransactionID AS Transaction_ID,(select concat(Title,' ',PName) from patient_master ");
        sb.Append(" where PatientID= pmh.PatientID) As PatientName,date_format(DateOfVisit,'%d-%b-%y')AS AdmitDate,pmh.Source,cm.CentreID,cm.CentreName,");
        sb.Append(" (select distinct(Department) from doctor_hospital where DoctorID = pmh.DoctorID) AS Dept,");
        sb.Append(" (select Company_Name from f_panel_master where PanelID = pmh.PanelID)AS PanelName  from patient_medical_history pmh ");
        sb.Append("  inner join Center_master cm ON cm.CentreID=pmh.CentreID  where pmh.Status <> 'Cancel'");//inner join ipd_case_history ich on pmh.TransactionID = ich.TransactionID
        sb.Append(" and pmh.Type = 'IPD' and pmh.CentreID IN (" + Centre + ") ");

        if(startDate != string.Empty)
            sb.Append(" and pmh.DateOfVisit >= '"+startDate+"'");
        if(toDate !=string.Empty)
            sb.Append(" and pmh.DateOfVisit <= '"+toDate+"'");

        sb.Append(" order by pmh.DateOfVisit,pmh.DoctorID,pmh.Source");

        DataTable dt = new DataTable();
        dt = GetDataTable(sb.ToString());
        return dt;
    }

    private DataTable GetDeptWisePatient(string startDate, string toDate, string Centre)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select (select distinct(Department) from doctor_hospital where DoctorID = pmh.DoctorID) AS Name ,");
        sb.Append(" count(pmh.TransactionID) AS TotalPatient,'Dept' As RType,cm.`CentreID`,cm.`CentreName` from patient_medical_history pmh INNER JOIN center_master cm ON cm.`CentreID`=pmh.`CentreID`  ");
        sb.Append("  where pmh.Type = 'IPD' and pmh.Status <> 'Cancel' and pmh.CentreID IN (" + Centre + ") ");//inner join ipd_case_history ich on pmh.TransactionID = ich.TransactionID
          
        if(startDate != string.Empty)
            sb.Append(" and pmh.DateOfVisit >= '" + startDate + "'");
        if(toDate !=string.Empty)
            sb.Append(" and pmh.DateOfVisit <= '" + toDate + "'");

        sb.Append(" group by Name order by Name ");

        DataTable dt = new DataTable();
        dt = GetDataTable(sb.ToString());
        return dt;
    }

    private DataTable GetPanelWisePatient(string startDate, string toDate, string Centre)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select pm.Company_Name AS Name,count(pmh.TransactionID) AS TotalPatient,'Panel' As RType,cm.`CentreID`,cm.`CentreName`");
        sb.Append(" from patient_medical_history pmh INNER JOIN center_master cm ON cm.`CentreID`=pmh.`CentreID` inner join f_panel_master pm on pm.PanelID = pmh.PanelID");
       // sb.Append(" inner join ipd_case_history ich on pmh.TransactionID = ich.TransactionID");
        sb.Append(" where pmh.Type = 'IPD' and  pmh.Status <> 'Cancel' and pmh.CentreID IN (" + Centre + ") ");

          if(startDate != string.Empty)
            sb.Append(" and pmh.DateOfVisit >= '" + startDate + "'");
        if(toDate !=string.Empty)
            sb.Append(" and pmh.DateOfVisit <= '" + toDate + "'");

        sb.Append(" group by pm.Company_Name order by pm.Company_Name ");

        DataTable dt = new DataTable();
        dt = GetDataTable(sb.ToString());
        return dt;
    }
    private DataTable GetMonthlyReport()
    {
        StringBuilder sb = new StringBuilder();
       sb.Append("Select  name,sum(PJAN)AS PJAN,sum(PFEB) AS PFEB,sum(PMAR) AS PMAR,sum(PAPR)AS PAPR,sum(PMAY) AS PMAY,sum(PJUN) AS PJUN,");
        sb.Append(" sum(PJUL)AS PJUL,sum(PAUG) AS PAUG,sum(PSEP) AS PSEP,sum(POCT)AS POCT,sum(PNOV) AS PNOV,sum(PDEC) AS PDEC");
        sb.Append(" FROM (Select  Name,(CASE WHEN VisitMonth = 1 THEN TotalPatient END) AS PJAN,(CASE WHEN VisitMonth = 2 THEN TotalPatient END) AS PFEB,");
        sb.Append(" (CASE WHEN VisitMonth = 3 THEN TotalPatient END) AS PMAR,(CASE WHEN VisitMonth = 4 THEN TotalPatient END) AS PAPR,");
        sb.Append(" (CASE WHEN VisitMonth = 5 THEN TotalPatient END) AS PMAY,(CASE WHEN VisitMonth = 6 THEN TotalPatient END) AS PJUN,");
        sb.Append(" (CASE WHEN VisitMonth = 7 THEN TotalPatient END) AS PJUL,(CASE WHEN VisitMonth = 8 THEN TotalPatient END) AS PAUG,");
        sb.Append(" (CASE WHEN VisitMonth = 9 THEN TotalPatient END) AS PSEP,(CASE WHEN VisitMonth = 10 THEN TotalPatient END) AS POCT,");
        sb.Append(" (CASE WHEN VisitMonth = 11 THEN TotalPatient END) AS PNOV,(CASE WHEN VisitMonth = 12 THEN TotalPatient END) AS PDEC");
        sb.Append(" FROM (select pm.Company_Name AS Name,pmh.PanelID as PanelID,count(pmh.TransactionID) AS TotalPatient,");
        sb.Append(" month(DateOfVisit) As VisitMonth from patient_medical_history pmh inner join f_panel_master pm on pm.PanelID = pmh.PanelID ");
        sb.Append(" inner join ipd_case_history ich on pmh.TransactionID = ich.TransactionID ");
        sb.Append(" where pmh.Type = 'IPD'  and ich.Status <> 'Cancel' ");
        sb.Append(" and (concat(month(DateOfVisit),' ',year(DateOfVisit)) >= '"+ddlFromMonth.SelectedValue+" "+DateTime.Now.Year.ToString()+"')"); 
        sb.Append(" and (concat(month(DateOfVisit),' ',year(DateOfVisit)) <= '"+ddlToMonth.SelectedValue+" "+DateTime.Now.Year.ToString()+"')");
        sb.Append(" group by pm.Company_Name,VisitMonth order by visitMonth,pm.Company_Name )temp1 group by Name,visitMonth)temp2 group by Name");
            
        DataTable dt = new DataTable();
        dt = GetDataTable(sb.ToString());
        return dt;
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        string Selection = rdoReportType.Text;
        string startDate,toDate ;

        DataTable dt = new DataTable();

        if (ucFromDate.Text != string.Empty)
            startDate = Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd");
        else
            startDate = string.Empty;

        if (ucToDate.Text != string.Empty)
            toDate = Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd");
        else
            toDate = string.Empty;

        switch (Selection)
        { 
            case "1" :
                dt = GetDetailPanelPatient(startDate, toDate, Centre);
                Session["ReportName"] = "DetailPanelReport";
                break;
            case "2" :
                dt = GetPanelWisePatient(startDate, toDate, Centre);
                Session["ReportName"] = "WeeklyPanelReport";
                break;
            case "3" :
                dt = GetDeptWisePatient(startDate, toDate, Centre);
                Session["ReportName"] = "WeeklyPanelReport";
                break;
        }

        if (dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn("Period", Type.GetType("System.String"));
            dc.DefaultValue = "Period From : " + ucFromDate.Text + " To : " + ucToDate.Text;
            dt.Columns.Add(dc);
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            DataTable dtImg = All_LoadData.CrystalReportLogo();
            ds.Tables.Add(dtImg.Copy());
          // ds.WriteXmlSchema(@"e:\anandOccupancy.xml");
            Session["ds"] = ds;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);


        }
    }

    protected void btnMonthReport_Click(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();
        if (ddlFromMonth.SelectedIndex > ddlToMonth.SelectedIndex)
        {
            lblMsg.Text = "To Month can not be less than from month! ";
            return ;
           
        }

        dt = GetMonthlyReport();

        if (dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn("Period", Type.GetType("System.String"));
            dc.DefaultValue = "From : " + ddlFromMonth.SelectedItem.Text + " " + DateTime.Now.Year.ToString() + " To : " + ddlToMonth.SelectedItem.Text + " " + DateTime.Now.Year.ToString();
            dt.Columns.Add(dc);

            StringBuilder sb = new StringBuilder();
            sb.Append("select sum(TJAN)AS TJAN,sum(TFEB) AS TFEB,sum(TMAR) AS TMAR,sum(TAPR)AS TAPR,sum(TMAY) AS TMAY,sum(TJUN) AS TJUN,");
            sb.Append(" sum(TJUL)AS TJUL,sum(TAUG) AS TAUG,sum(TSEP) AS TSEP,sum(TOCT)AS TOCT,sum(TNOV) AS TNOV,sum(TDEC) AS TDEC");
            sb.Append(" from (Select TName, (CASE WHEN VisitMonth = 1 THEN TotalPatient END) AS TJAN,(CASE WHEN VisitMonth = 2 THEN TotalPatient END) AS TFEB,");
            sb.Append(" (CASE WHEN VisitMonth = 3 THEN TotalPatient END) AS TMAR,(CASE WHEN VisitMonth = 4 THEN TotalPatient END) AS TAPR,");
            sb.Append(" (CASE WHEN VisitMonth = 5 THEN TotalPatient END) AS TMAY,(CASE WHEN VisitMonth = 6 THEN TotalPatient END) AS TJUN,");
            sb.Append(" (CASE WHEN VisitMonth = 7 THEN TotalPatient END) AS TJUL,(CASE WHEN VisitMonth = 8 THEN TotalPatient END) AS TAUG,");
            sb.Append(" (CASE WHEN VisitMonth = 9 THEN TotalPatient END) AS TSEP,(CASE WHEN VisitMonth = 10 THEN TotalPatient END) AS TOCT,");
            sb.Append(" (CASE WHEN VisitMonth = 11 THEN TotalPatient END) AS TNOV,(CASE WHEN VisitMonth = 12 THEN TotalPatient END) AS TDEC");
            sb.Append(" from (select count(pmh.TransactionID) AS TotalPatient,month(DateOfVisit) As VisitMonth,'IPD' AS TName from patient_medical_history pmh ");
            sb.Append(" inner join ipd_case_history ich on pmh.TransactionID = ich.TransactionID where pmh.Type = 'IPD' and ich.Status <> 'Cancel' ");

            sb.Append(" and (concat(month(DateOfVisit),' ',year(DateOfVisit)) >= '" + ddlFromMonth.SelectedValue + " " + DateTime.Now.Year.ToString() + "')");
            sb.Append(" and (concat(month(DateOfVisit),' ',year(DateOfVisit)) <= '" + ddlToMonth.SelectedValue + " " + DateTime.Now.Year.ToString() + "')");
            sb.Append(" group by VisitMonth order by visitMonth)temp1 )temp2 group by TName");

            DataTable dtTotalPatient = new DataTable();
            dtTotalPatient = GetDataTable(sb.ToString());
            DataSet ds = new DataSet();

            ds.Tables.Add(dt.Copy());
            ds.Tables[0].TableName = "PanelPatient";

            ds.Tables.Add(dtTotalPatient.Copy());
            ds.Tables[1].TableName = "TotalPatient";
            //ds.WriteXmlSchema(Server.MapPath("~/AkPanelMonth.xml"));
            Session["ds"] = ds;
            Session["ReportName"] = "MonthlyPanelReport";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);

        }
    }
}
