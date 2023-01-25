using System;
using System.Data;
using System.Web.UI;
using System.Text;
using MySql.Data.MySqlClient;
using System.Web.Services;
using System.Web.UI.WebControls;
public partial class Design_Store_PharmacyReferDoctorReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnSearch);
            BindDoctor();
        }
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");
    }

    protected void BindDoctor()
    {
        DataTable dt = All_LoadData.dtReferDoctor();
        ddlRefDoctor.DataSource = dt;
        ddlRefDoctor.DataTextField = "Name";
        ddlRefDoctor.DataValueField = "DoctorID";
        ddlRefDoctor.DataBind();
        ddlRefDoctor.Items.Insert(0, new ListItem("All", "0"));

    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }

        StringBuilder sb = new StringBuilder();


        sb.Append("SELECT cmt.`CentreName`,pmh.`PatientID` AS UHID, ");
        sb.Append("IF(lt.PatientID='CASH002',CONCAT(pgm.Title,' ',pgm.Name),CONCAT(pm.Title,' ',pm.PName))PatientName, ");
        sb.Append("IF(PMH.`Type`='IPD',REPLACE(PMH.`TransactionID`,'ISHHI',''),'') AS IPID, ");
        sb.Append("sd.`BillNo`, DATE_FORMAT(sd.Date,'%d-%b-%y')BillDate,LT.`NetAmount` AS Amount,pmh.`ReferedBy` AS ReferDoctorName, ");
        sb.Append("CONCAT(em.`Title`,' ',em.`Name`) AS IssuedBy ");
        sb.Append("FROM f_salesdetails sd   ");
        sb.Append("INNER JOIN f_LedgerTransaction lt ON lt.`LedgertransactionNo`=sd.`LedgertransactionNo` ");
        sb.Append("INNER JOIN patient_medical_history pmh ON pmh.TransactionID=sd.TransactionID ");
        sb.Append("INNER JOIN center_master cmt ON cmt.centreID = sd.`CentreID`  ");
        sb.Append("INNER JOIN employee_master em ON em.`Employee_ID`=sd.`UserID` ");
        sb.Append("LEFT JOIN patient_general_master pgm ON pgm.CustomerID=sd.PatientID ");
        sb.Append("INNER JOIN patient_master pm ON pm.`PatientID`=pmh.`PatientID` ");
        sb.Append("WHERE sd.Date>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' AND sd.Date<='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "' AND sd.`TrasactionTypeID` IN(16,17) ");
        sb.Append("AND pmh.`ReferedBy`<>'' AND pmh.`ReferedBy`<>'Select' and sd.`CentreID` IN(" + Centre + ")  ");

        if (ddlRefDoctor.SelectedItem.Text.Trim() != "All")
        {
            sb.Append("AND pmh.`ReferedBy`='" + ddlRefDoctor.SelectedItem.Text.Trim() + "' ");
        }

        sb.Append(" GROUP BY lt.LedgertransactionNo ORDER BY cmt.`CentreName`,sd.`BillNo` ");
        

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            string ReportName = "Pharmacy Refer Doctor Report";
            DataColumn dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "Period From : " + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yyyy");

            dt.Columns.Add(dc);
            dt = Util.GetDataTableRowSum(dt);

            string CacheName = Session["ID"].ToString();
            Common.CreateCachedt(CacheName, dt); ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/commonReports/Commonreport.aspx?ReportName=" + ReportName + "&Type=E');", true);
        }
        else
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
    }
}