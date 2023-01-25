using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_OutSourceReport : System.Web.UI.Page
{
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        string OutSourceLab = GetSelection(chkOurSourcelab);
        if (OutSourceLab == "")
        {
            lblMsg.Text = "Select OutSourceLab";
            return;
        }
        string Centre = "";
        Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Select Centre";
            return;
        }
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT CASE WHEN pli.Type=1 THEN 'OPD' WHEN pli.Type=2 THEN 'IPD' ELSE 'Emergency' END Type,PM.PatientID MRNo,IF(pli.type=2,REPLACE(pli.TransactionID,'ISHHI',''),'') IPDNo,olm.Name AS OutSourceLab, ");
            sb.Append("CONCAT(pm.Title,'',pm.pname)PatientName,pm.Age, ltd.itemname AS TestName, ");
            sb.Append("(SELECT CONCAT(Title,' ',NAME) FROM employee_master WHERE EmployeeID=pli.OutSourceBy)OutSourceBy, ");
            sb.Append(" DATE_FORMAT(pli.OutsourceDate,'%d-%b-%y')OutsourceDate, ");
            sb.Append(" ltd.Quantity,SUM(ltd.Rate),(SUM(ltd.rate)*ltd.Quantity)GrossAmt,ROUND(sum(ltd.discamt))Discount,sum(ltd.Amount),pli.OutSourceID ");
            sb.Append(" FROM patient_labinvestigation_opd pli ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo = pli.LedgerTransactionNo ");
            sb.Append(" INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ");
            sb.Append(" INNER JOIN patient_master PM ON pli.PatientID = PM.PatientID ");
            sb.Append(" INNER JOIN  outsourcelabmaster olm ON olm.ID=pli.OutSourceID  ");
            sb.Append(" WHERE lt.IsCancel=0 AND IsSampleCollected IN ('S','Y') AND pli.IsOutSource=1 ");
            if (rdbitem.SelectedValue != "0")
                sb.Append(" AND pli.Type="+ rdbitem.SelectedValue +" ");
            sb.Append(" AND OutsourceDate >= '" + Util.GetDateTime(txtfromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' ");
            sb.Append(" AND OutsourceDate <= '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
            sb.Append(" AND pli.sampleTransferCentreID IN (" + Centre + ") AND pli.OutSourceID IN (" + OutSourceLab + ") GROUP BY ltd.LedgerTransactionNo,ltd.ItemID ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if ((dt.Rows.Count > 0) && (rblReportFormat.SelectedValue == "1"))
        {
            dt.Columns.Remove("OutSourceID");
            Session["dtExport2Excel"] = dt;
            Session["ReportName"] = "Outsource Report";
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
            //ds.WriteXmlSchema("E://OutSourceReport.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "OutSourceReport";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../../Design/common/Commonreport.aspx');", true);
        }
        else
        {
            lblMsg.Text = "No Record Found";
            return;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtfromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            bindLabDetail();
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnSearch);
        }
        txtfromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }

    private void bindLabDetail()
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID,Name FROM outsourcelabmaster Where Active=1");
        if (dt.Rows.Count > 0)
        {
            chkOurSourcelab.DataSource = dt;
            chkOurSourcelab.DataTextField = "Name";
            chkOurSourcelab.DataValueField = "ID";
            chkOurSourcelab.DataBind();
        }
    }
    private string GetSelection(CheckBoxList cbl)
    {
        string str = string.Empty;

        foreach (ListItem li in cbl.Items)
        {
            if (li.Selected)
            {
                if (str != string.Empty)
                    str += ",'" + li.Value + "'";
                else
                    str = "'" + li.Value + "'";
            }
        }

        return str;
    }
}