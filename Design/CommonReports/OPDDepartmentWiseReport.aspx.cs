using CrystalDecisions.CrystalReports.Engine;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OPD_OPDDepartmentWiseReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            BindGroups();
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnPDFReport);
            ddlGroups_SelectedIndexChanged(sender, e);
            chkSubGroups_CheckedChanged(sender, e);
            cl1.EndDate = DateTime.Now;
            CalendarExtender1.EndDate = DateTime.Now;
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }
    private void BindGroups()
    {
        string str = "select CategoryID,Name from f_categorymaster where CategoryID IN (Select CategoryID  from f_ConfigRelation where ConfigID in  (3,5,20,25)  AND categoryid NOT IN ('LSHHI35')) order by Name ";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            ddlGroups.DataSource = dt;
            ddlGroups.DataTextField = "Name";
            ddlGroups.DataValueField = "CategoryID";
            ddlGroups.DataBind();
            ListItem li = new ListItem("ALL", "ALL");
            ddlGroups.Items.Add(li);
            ddlGroups.SelectedIndex = ddlGroups.Items.IndexOf(ddlGroups.Items.FindByText("ALL"));
            lblMsg.Text = "";
        }
        else
        {
            ddlGroups.Items.Clear();
            lblMsg.Text = "No Groups Found";
        }
    }
    protected void ddlGroups_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindSubGroups();
        chkSubGroups_CheckedChanged(sender, e);

    }
    private void BindSubGroups()
    {
        string str = "select SubCategoryID,Name from f_subcategorymaster where CategoryID ";
        if (ddlGroups.SelectedItem.Text == "ALL")
            str = str + " in (Select CategoryID  from f_ConfigRelation where ConfigID IN  (3,5,6,7,20,23,25))";
        else
            str = str + "  ='" + ddlGroups.SelectedValue + "' ";
        str += " order by name ";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            chlSubGroups.DataSource = dt;
            chlSubGroups.DataTextField = "Name";
            chlSubGroups.DataValueField = "SubCategoryID";
            chlSubGroups.DataBind();
            lblMsg.Text = "";
        }
        else
        {
            chlSubGroups.Items.Clear();
            lblMsg.Text = "No Sub-Groups Found";
        }

    }
    protected void chkSubGroups_CheckedChanged(object sender, EventArgs e)
    {
        for (int i = 0; i < chlSubGroups.Items.Count; i++)
            chlSubGroups.Items[i].Selected = chkSubGroups.Checked;
    }
    protected void btnPDFReport_Click(object sender, EventArgs e)
    {
        Button myButton = (Button)sender;

        lblMsg.Text = "";


        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        string DeptList = StockReports.GetSelection(chlSubGroups);
        if (DeptList == "")
        {
            lblMsg.Text = "Please Select Department";
            return;
        }
        StringBuilder sb = new StringBuilder();
        if (rdoReportType.SelectedValue == "1")
        {
            //Detail
            sb.Append(" SELECT DATE_FORMAT(lt.Date,'%d-%b-%Y')DATE , REPLACE(REPLACE(lt.LedgerTransactionNo,'LOSHHI','1'),'LSHHI',2) LabNo,CONCAT(pm.Title,' ',pm.PName)PName,");
            sb.Append(" ItemName, sc.name DepartmentName,(ltd.Quantity*ltd.Rate) GrossAmount,((ltd.Quantity*ltd.Rate)- ltd.Amount)  DiscountAmount,ltd.Amount NetAmount, ");
            sb.Append(" lt.PatientID PatientID FROM f_ledgertransaction lt ");
            sb.Append(" INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo AND lt.IsCancel=0 ");
            sb.Append("  AND  lt.Date>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND lt.Date<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ");
            sb.Append(" AND lt.CentreID IN (" + Centre + ") ");
            sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=ltd.SubCategoryID and ltd.SubCategoryID in  (" + DeptList + ")  AND ltd.Type='O'  ");
            sb.Append(" INNER JOIN patient_master pm ON pm.PatientID=lt.PatientID  ");
            sb.Append(" ORDER BY lt.Date,lt.LedgerTransactionNo  ");

            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                DataColumn dc = new DataColumn();
                dc.ColumnName = "Period";
                dc.DefaultValue = "From : " + Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");
                dt.Columns.Add(dc);
                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());
                ds.Tables[0].TableName = "ItemDetail";
                //  ds.WriteXmlSchema("E:\\DepartmentWiseDetailReport.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "DepartmentWiseDetailReport";
                if (myButton.CommandName == "PDF")
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
                else
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/CommonCrystalReportViewer.aspx');", true);

            }
            else
                lblMsg.Text = "No Record found";
        }
        else
        {
            //Summary
            

            sb.Append(" SELECT ");
            sb.Append(" SubCategoryName, SubCategoryID,SUM(Quantity)Quantity,SUM(GrossAmount)GrossAmount,   SUM(Discount)Discount,SUM(NetAmount)NetAmt,SUM(AmtCash)AmtCash, ");
            sb.Append(" SUM(AmtCheque)AmtCheque,   SUM(AmtCreditCard)AmtCreditCard,SUM(AmtCredit)AmtCredit ,");
            sb.Append(" SUM(NetAmount-(AmtCash+AmtCheque+AmtCreditCard))PendingAmt ");
            sb.Append(" FROM (        ");
            sb.Append("	    SELECT lt.LedgerTransactionNo,lt.Date,sc.Name SubCategoryName,sc.SubCategoryID,(ltd.Quantity)Quantity,        ");
            sb.Append("    	((ltd.Quantity*ltd.Rate)- ltd.Amount) Discount,(ltd.Quantity*ltd.Rate)GrossAmount,ltd.Amount NetAmount,    ");
            sb.Append("	    0 AmtCash,0 AmtCheque,0 AmtCreditCard,IF(lt.PaymentModeID=4,lt.NetAmount,0)AmtCredit         ");
            sb.Append("	    FROM  f_subcategorymaster sc  INNER JOIN f_ledgertnxdetail ltd ON ltd.SubCategoryID = sc.SubCategoryID          ");
            sb.Append(" 	INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo= ltd.LedgerTransactionNo         	 ");
            sb.Append("	    WHERE  lt.IsCancel=0  AND ltd.SubCategoryID IN   (" + DeptList + ") ");
            sb.Append("     AND lt.Date>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND lt.Date<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'  ");
            sb.Append("	    AND lt.CentreID IN ('1') AND ltd.Type='O'   	");
            sb.Append("  UNION ALL 	 ");
            sb.Append("	    SELECT rec.AsainstLedgerTnxNo LedgerTransactionNo,rec.Date,sc.Name SubCategoryName,sc.SubCategoryID,0 Quantity,0 Discount,0 GrossAmount,0 NetAmount, ");
            sb.Append("	    IF(rec_pay.PaymentModeID=1 AND ltd.Amount <> 0,((rec_pay.S_Amount*ltd.Amount)/lt.NetAmount),0)AmtCash,        ");
            sb.Append("	    IF(rec_pay.PaymentModeID=2 AND ltd.Amount <> 0,((rec_pay.S_Amount*ltd.Amount)/lt.NetAmount),0)AmtCheque,        ");
            sb.Append("	    IF(rec_pay.PaymentModeID=3 AND ltd.Amount <> 0,((rec_pay.S_Amount*ltd.Amount)/lt.NetAmount),0)AmtCreditCard,  ");
            sb.Append("	    0 AmtCredit      		");
            sb.Append("     FROM f_reciept rec    ");
            sb.Append("	    INNER JOIN f_receipt_paymentdetail rec_pay ON rec.receiptno=rec_pay.ReceiptNo AND rec_pay.CentreID IN ('1')  AND rec.IsCancel=0  	");
            sb.Append("	    AND rec.Date>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND rec.Date<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' AND rec.LedgerNoDr<>'HOSP0005' ");
            sb.Append("	    INNER JOIN f_ledgertransaction lt ON rec.AsainstLedgerTnxNo=lt.LedgerTransactionNo ");
            sb.Append("	    INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo= ltd.LedgerTransactionNo	 ");
            sb.Append("	    INNER JOIN f_subcategorymaster sc  ON ltd.SubCategoryID = sc.SubCategoryID          ");
            sb.Append("	    WHERE ltd.SubCategoryID IN   (" + DeptList + ")  AND ltd.Type='O'");
            sb.Append("	       ");
            sb.Append("   ) aa  GROUP BY SubCategoryID    ");

            sb.Append("   ORDER BY SubCategoryName ");



            DataTable dt = StockReports.GetDataTable(sb.ToString());

            StringBuilder sb2 = new StringBuilder();
            sb2.Append(" SELECT ");
            sb2.Append(" IFNULL(SUM(IF(rec_pay.PaymentModeID=1 AND ltd.Amount <> 0,((rec_pay.S_Amount*ltd.Amount)/lt.NetAmount),0)),0)AmtCash,");
            sb2.Append(" IFNULL(SUM(IF(rec_pay.PaymentModeID=2 AND ltd.Amount <> 0,((rec_pay.S_Amount*ltd.Amount)/lt.NetAmount),0)),0)AmtCheque,");
            sb2.Append(" IFNULL(SUM(IF(rec_pay.PaymentModeID=3 AND ltd.Amount <> 0,((rec_pay.S_Amount*ltd.Amount)/lt.NetAmount),0)),0)AmtCreditCard,");
            sb2.Append(" 0 AmtCredit, ");
            sb2.Append(" IFNULL(SUM(IF( DATE(lt.Date)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(lt.Date) <=  '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ,((-1)*((rec_pay.S_Amount*ltd.Amount)/lt.NetAmount)),0)),0) PendingAmt ,");
            sb2.Append(" IFNULL(SUM(IF( DATE(lt.Date)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(lt.Date) <=  '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' AND lt.PaymentModeID<>4, ((-1)*((rec_pay.S_Amount*ltd.Amount)/lt.NetAmount)),0)),0) PendingAmtNonCredit ,");
            sb2.Append(" IFNULL(SUM(IF( DATE(lt.Date)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(lt.Date) <=  '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' AND lt.PaymentModeID=4 ,((-1)*((rec_pay.S_Amount*ltd.Amount)/lt.NetAmount)),0)),0) PendingAmtCredit ,");

            sb2.Append(" IFNULL(SUM(IF( DATE(lt.Date)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(lt.Date) <=  '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' AND rec_pay.PaymentModeID=1 ,((rec_pay.S_Amount*ltd.Amount)/lt.NetAmount),0)),0) AmtCashSameDay,");
            sb2.Append(" IFNULL(SUM(IF( DATE(lt.Date)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(lt.Date) <=  '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' AND rec_pay.PaymentModeID=2 ,((rec_pay.S_Amount*ltd.Amount)/lt.NetAmount),0)),0) AmtChequeDay,");
            sb2.Append(" IFNULL(SUM(IF( DATE(lt.Date)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(lt.Date) <=  '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' AND rec_pay.PaymentModeID=3 ,((rec_pay.S_Amount*ltd.Amount)/lt.NetAmount),0)),0) AmtCreditCardSameDay, ");
            sb2.Append(" IFNULL(SUM(r.AmountPaid*ltd.Amount/lt.NetAmount),0)Amount ");
            sb2.Append(" FROM f_reciept r  ");
            sb2.Append(" INNER JOIN f_receipt_paymentdetail rec_pay ON   rec_pay.ReceiptNo=r.ReceiptNo ");
            sb2.Append(" INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo = r.AsainstLedgerTnxNo ");
            sb2.Append(" INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=lt.LedgerTransactionNo ");
            sb2.Append(" WHERE DATE(r.Date)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(r.Date) <=  '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ");
            sb2.Append(" AND r.CentreID IN  (" + Centre + ") AND lt.IsCancel=0  AND r.IsCancel=0 AND ltd.SubCategoryID IN  (" + DeptList + ") AND ltd.Type='O' AND r.LedgerNoDr='HOSP0005' ");

            DataTable dtSettlemant = StockReports.GetDataTable(sb2.ToString());

            DataTable dtExpence = new DataTable("dtExpence");
            StringBuilder sbExpence = new StringBuilder();
            sbExpence.Append(" SELECT ifnull(SUM(fre.AmountPaid*-1),0) ExpenceAmt ");
            sbExpence.Append(" FROM  ");
            sbExpence.Append(" f_reciept_expence fre WHERE fre.isCancel=0 ");
            sbExpence.Append(" AND Date(fre.Date) >= '" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "'  ");
            sbExpence.Append(" AND date(fre.Date) <= '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'  ");
            sbExpence.Append(" AND fre.CentreID IN (" + Centre + ") ");
            dtExpence = StockReports.GetDataTable(sbExpence.ToString());

            DataTable dtBillNo = new DataTable("dtBillNo");
            StringBuilder sbBillNo = new StringBuilder();
            sbBillNo.Append(" SELECT DATE_FORMAT(lt.date, '%d-%b-%Y') DATE ,MinBillNo,MaxBillNo,CntTotal ");
            sbBillNo.Append(" from ( ");
            sbBillNo.Append(" SELECT MIN(BillNo) MinBillNo,MAX(BillNo) MaxBillNo,COUNT(`LedgerTransactionNo`)CntTotal, DATE  FROM  f_ledgertransaction  ");
            sbBillNo.Append(" where TypeOfTnx in ('OPD-LAB','OPD-Package','OPD-APPOINTMENT','OPD-BILLING','OPD-OTHERS')  ");
            sbBillNo.Append(" and date(Date)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "'  ");
            sbBillNo.Append(" and date(Date) <=  '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'  ");
            sbBillNo.Append(" and CentreID in (" + Centre + ") and iscancel=1=0 group by centreID ,date(date) ) lt ");
            sbBillNo.Append(" order by date(lt.date) ");

            dtBillNo = StockReports.GetDataTable(sbBillNo.ToString());


            if (dt.Rows.Count > 0)
            {
                lblMsg.Text = "Total " + dt.Rows.Count + " Record(s) Found";
                DataColumn dc = new DataColumn();
                dc.ColumnName = "Period";
                dc.DefaultValue = "From : " + Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");
                dt.Columns.Add(dc);



                dc = new DataColumn();
                dc.ColumnName = "PrintBy";
                dc.DefaultValue = Session["LoginName"].ToString();
                dt.Columns.Add(dc);

                dc = new DataColumn();
                dc.ColumnName = "ReportHeadName";
                dc.DefaultValue = "Department Wise Collection Summary";
                dt.Columns.Add(dc);

                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());
                ds.Tables[0].TableName = "Main";


                ds.Tables.Add(dtExpence.Copy());
                ds.Tables[1].TableName = "Expence";

                ds.Tables.Add(dtBillNo.Copy());
                ds.Tables[2].TableName = "BillNo";

                ds.Tables.Add(dtSettlemant.Copy());
                ds.Tables[3].TableName = "Settlement";

                Session["ds"] = ds;
              //   ds.WriteXmlSchema(@"E:\DepartmentWiseSummaryReport.xml");
                Session["ReportName"] = "DepartmentWiseSummaryReport";
                if (myButton.CommandName == "PDF")
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
                else
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/CommonCrystalReportViewer.aspx');", true);



            }
            else
                lblMsg.Text = "No Record found";
        }

    }


    protected void btnExcelReport_Click(object sender, EventArgs e)
    {
        
    }
}