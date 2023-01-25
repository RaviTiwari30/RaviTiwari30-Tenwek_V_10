using System;
using System.Data;
using System.Text;
using System.Web.UI;

public partial class Design_IPD_DiagnisticsDuesReport : System.Web.UI.Page
    {
    protected void Page_Load(object sender, EventArgs e)
        {
        if (!IsPostBack)
            {
            txtFromDate.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
            txtTodate.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnSearch);
            }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtTodate.Attributes.Add("readOnly", "true");
        }

    protected void btnSearch_Click(object sender, EventArgs e)
        {
            string Centre = All_LoadData.SelectCentre(chkCentre);
            if (Centre == "")
            {
                lblMsg.Text = "Please Select Centre";
                return;
            }
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT centreID,centreName,PatientID,PName,Panel,sum(Amount-Collected)DueAmt,LedgerTransactionNo  FROM ( ");
        sb.Append("     SELECT centreID,centreName,LedgerTransactionNo,PatientID,PName,Panel, Rate,Amount,ROUND( (IFNULL(((Net * ((Collected/BillAmt)*100))/100),0)),2)Collected ");
        sb.Append("     FROM ( ");
        sb.Append("     	SELECT cm.centreID,cm.centreName,pmh.PatientID,ltd.Rate, ltd.Amount,CONCAT(pm.Title,' ',pm.PName)PName,fpm.Company_Name Panel, ");
        sb.Append("     	IFNULL(( ");
        sb.Append("	    	SELECT SUM(AmountPaid) FROM f_reciept WHERE AsainstLedgerTnxNo = lt.LedgerTransactionNo AND IsCancel=0 ");
        sb.Append("	        ),0)Collected, ");
        sb.Append("     	((ltd.Rate*ltd.Quantity)-ROUND(ltd.DiscAmt,2))Net,lt.LedgerTransactionNo, ");
        sb.Append("     	( ");
        sb.Append("	        	SELECT SUM(NetItemAmt)  FROM f_ledgertnxdetail ");
        sb.Append("		        WHERE LedgerTransactionNO=ltd.LedgerTransactionNo ");
        sb.Append("     	)BillAmt,");
        sb.Append("	        lt.TypeOfTnx ");
        sb.Append("     	FROM f_ledgertransaction lt ");
        sb.Append("	        INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo ");
        sb.Append("	        INNER JOIN patient_medical_history pmh ON pmh.TransactionID= lt.TransactionID ");
        sb.Append("	        INNER JOIN f_panel_master fpm ON fpm.PanelID=pmh.PanelID ");
        sb.Append("	        INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID INNER JOIN center_master cm ON cm.centreID=pmh.`CentreID`");
        sb.Append("         AND DATE(lt.Billdate)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "'   AND DATE(lt.Billdate)<='" + Util.GetDateTime(txtTodate.Text).ToString("yyyy-MM-dd") + "'    ");
        sb.Append("     	WHERE lt.IsCancel = 0 AND ltd.ConfigID=3 AND ispackage=0 AND pmh.Type='OPD' and pmh.`CentreID` in ("+Centre+") ");
        sb.Append("     )t  ");
        sb.Append(" )t1 WHERE (t1.Amount-t1.Collected)<>0 GROUP BY t1.LedgerTransactionNo");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "From  Date " + Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + " To  Date " + Util.GetDateTime(txtTodate.Text).ToString("dd-MMM-yyyy");
            dt.Columns.Add(dc);
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            Session["ReportName"] = "DiagnisticsReport";
            Session["ds"] = ds;
             //ds.WriteXmlSchema("E:\\DiagnisticsReport.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
            }
        else

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }
    }