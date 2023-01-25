using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;

public partial class Design_OPD_OPDAdvance_OutStanding : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");

            ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtFromTime.Text = DateTime.Now.Hour + ":" + DateTime.Now.Minute;
            txtFromTime.Text = "11:59 PM";
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnReport);
            if (Request.QueryString["PatientID"] != null) {
                for (int i = 0; i < chkCentre.Items.Count; i++)
                {
                    chkCentre.Items[i].Selected = true;
                }
                txtMrNo.Text = Request.QueryString["PatientID"].ToString();
                Search();
            }
            CalendarExtender1.EndDate = DateTime.Now;
            calToDate.EndDate = DateTime.Now;
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
        calFromDate.EndDate = DateTime.Now;
        ucFromDate.Attributes.Add("readOnly", "true");
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        Search();
    }
    private void Search()
    {
        string FromTime = "00:00:00";
        string ToTime = "23:59:59"; 

        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }

        lblMsg.Text = "";
       StringBuilder sb = new StringBuilder();
      /* if (rdbAdvanceOutStan.SelectedValue == "OPDAdvance" || rdbAdvanceOutStan.SelectedValue == "ALL")
       {
           sb.Append(" SELECT 'Advance'Type,oa.patientID,CONCAT(pm.title,' ',pm.`PName`)PName,Pm.`Age`,pm.`Mobile`,CONCAT(pm.`House_No`,' ',pm.city)Address,CONCAT (DATE_FORMAT(lt.`BillDate`,'%d-%b-%Y'),' ',TIME_FORMAT(lt.`Time`,'%h:%i %p'))BillDate,Sum(AdvanceAmount) OPDNetAmount,'0' OPDRoundOff,lt.BillNo,GROUP_CONCAT(oad.ReceiptNo)ReceiptNo,Sum(BalanceAmt) OPDAmountPaid, ");
           sb.Append(" sum(AdvanceAmount-BalanceAmt) as RemainingAmount ");
           sb.Append(" FROM opd_advance oa  ");
           sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.transactionID=oa.transactionID ");
           sb.Append(" INNER JOIN patient_master pm ON pm.patientID=lt.`patientID` ");
           sb.Append(" LEFT JOIN opd_advance_detail oad ON oad.ReceiptNoAgainst=oa.ReceiptNo WHERE oa.IsCancel=0 AND oa.CentreID IN (" + Centre + ")  ");
           //sb.Append(" AND oa.CreatedDate<='" + Util.GetDateTime(ucFromDate.Text.Trim()).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(txtFromTime.Text.Trim()).ToString("HH:mm:ss") + "' ");
           sb.Append(" AND oa.CreatedDate>='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(FromTime).ToString("HH:mm:ss") + "' AND oa.CreatedDate<='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(ToTime).ToString("HH:mm:ss") + "'");
           if (txtMrNo.Text != "")
               sb.Append("AND oa.patientID='" + txtMrNo.Text.Trim() + "'");
           sb.Append(" GROUP BY oa.patientID ");
       }
       if (rdbAdvanceOutStan.SelectedValue == "ALL")
       {
           sb.Append(" UNION ALL  ");
       }*/
        if (rdbAdvanceOutStan.SelectedValue == "OutStanding" || rdbAdvanceOutStan.SelectedValue == "ALL")
        {
            sb.Append(" SELECT 'OutStanding' Type,lt.patientID,CONCAT(pm.title,' ',pm.`PName`)PName,Pm.`Age`,pm.`Mobile`,CONCAT(pm.`House_No`,' ',pm.city)Address,CONCAT (DATE_FORMAT(lt.`BillDate`,'%d-%b-%Y'),' ',TIME_FORMAT(lt.`Time`,'%h:%i %p'))BillDate,(lt.NetAmount) OPDNetAmount,(lt.RoundOff) OPDRoundOff,lt.billNo,GROUP_CONCAT(rt.ReceiptNo)ReceiptNo, ");
            sb.Append(" SUM((IFNULL(rt.AmountPaid,0)+IFNULL(rt.TDS,0)+IFNULL(rt.Writeoff,0)+IFNULL(rt.Deductions ,0)))OPDAmountPaid, ");
            sb.Append(" (lt.NetAmount-(SUM(IFNULL(rt.AmountPaid,0)+IFNULL(rt.TDS,0)+IFNULL(rt.Writeoff,0)+IFNULL(rt.Deductions ,0))))RemainingAmount ");
            sb.Append(" FROM f_ledgertransaction lt  ");
            sb.Append(" LEFT JOIN f_reciept rt ON lt.LedgerTransactionNo = rt.AsainstLedgerTnxNo  AND rt.AsainstLedgerTnxNo<>'' AND rt.IsCancel=0 ");
            sb.Append(" INNER JOIN patient_master pm ON pm.patientID=lt.`patientID` ");
            sb.Append(" WHERE  lt.TypeOfTnx ");
            sb.Append(" IN ('OPD-LAB','OPD-APPOINTMENT','OPD-PACKAGE','OPD-PROCEDURE','OPD-OTHERS','OPD-Billing','Pharmacy-Issue','Pharmacy-Return','Emergency') ");
            sb.Append(" AND lt.IsCancel=0 AND lt.patientID<>'CASH002' AND lt.CentreID IN (" + Centre + ")  ");
            if (txtMrNo.Text != "")
                sb.Append("AND lt.patientID='" + txtMrNo.Text.Trim() + "'");
            if (rdoPaymentModeType.SelectedValue == "1")
                sb.Append(" AND (lt.PaymentModeID<>4 OR lt.PaymentModeID IS NULL) ");
            if (rdoPaymentModeType.SelectedValue == "2")
                sb.Append(" and lt.PaymentModeID=4");
            //sb.Append(" AND lt.Date<='" + Util.GetDateTime(ucFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' AND lt.Time<='" + Util.GetDateTime(txtFromTime.Text.Trim()).ToString("HH:mm:ss") + "'");
            sb.Append(" AND lt.BillDate>='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(FromTime).ToString("HH:mm:ss") + "' AND lt.BillDate<='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(ToTime).ToString("HH:mm:ss") + "'");
            sb.Append("  GROUP BY lt.BillNo HAVING RemainingAmount>0 Order by BillNo");
        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0 && dt != null)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = Convert.ToString(Session["LoginName"]);
            dt.Columns.Add(dc);
            DataColumn dc1 = new DataColumn();
            dc1.ColumnName = "AsOnDate";
            //dc1.DefaultValue = "As On Date :" + Util.GetDateTime(ucFromDate.Text.Trim()).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(txtFromTime.Text.Trim()).ToString("HH:mm:ss");
            dc1.DefaultValue = "From Date :" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + " To Date: " + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd");
            dt.Columns.Add(dc1);

            DataTable dtImg = All_LoadData.CrystalReportLogo();
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            ds.Tables.Add(dtImg.Copy());
           // ds.WriteXmlSchema(@"D:\OpdOutstanding_new.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "OPDAdvanceOutstandingReport";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Common/Commonreport.aspx');", true);
        }
        else
        {
            lblMsg.Text = "No Record Found";
            return;
        }
    }
}