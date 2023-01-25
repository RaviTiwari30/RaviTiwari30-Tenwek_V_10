using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;

public partial class Design_Finance_DataTransferReportFromHospedia : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        txtFromDate.Attributes.Add("readonly", "readonly");
        txtToDate.Attributes.Add("readonly", "readonly");
        

    }
    
    protected void btnreport_Click(object sender, EventArgs e)
    {
        spnMsg.Text = "";
        try
        {
            StringBuilder sb = new StringBuilder();
            
            string ReportName = string.Empty;
            if (ddlReporttype.SelectedItem.Value == "1")
            {
                sb.Append(" SELECT rd.`PATIENTID` AS UHID,rd.`PATIENTNAME`,rd.`DOCTORNAME`,rd.`DEPARTMENTID`,rd.`BillDate`,rd.`BILLNO`,rd.`Service_Name`,rd.`ItemAmount`,rd.`DISCAMT`,rd.`ItemNetAmount`,rd.`PANELNAME` ");
                sb.Append(" ,rd.`REVENUEACCOUNT`,rd.`MODULE` AS PatientType,rd.`BOOKINGBRNCHID`,rd.`ErrorMessage`,rd.`IsSync`,CONCAT(DATE_FORMAT(rd.`issyncdatetime`,'%d-%b-%Y'),' ',TIME_FORMAT(rd.`issyncdatetime`,'%h:%i:%s %p'))syncdatetime ");
                sb.Append(" FROM finance.`revenue$detail` rd WHERE date(rd.`issyncdatetime`)>= '" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND date(rd.`issyncdatetime`)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ORDER BY rd.id desc");

                ReportName = "Revenue Details";

            }
            if (ddlReporttype.SelectedItem.Value == "2")
            {
                sb.Clear();
                sb.Append(" SELECT pr.`PATIENTID` AS UHID ,pr.`PANELNAME`,pr.`ALLOCATEDAMT`,pr.`ALLOCATEDDATE`,pr.`MODULE` AS PatientType,IFNULL(pr.`ErrorMessage`,'')ErrorMessage ");
                sb.Append(" ,pr.`IsSync`,CONCAT(DATE_FORMAT(pr.`issyncdatetime`,'%d-%b-%Y'),' ',TIME_FORMAT(pr.`issyncdatetime`,'%h:%i:%s %p'))syncatetime  FROM finance.`panel$revenue` pr where date(pr.`issyncdatetime`)>= '" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND date(pr.`issyncdatetime`)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'  ORDER BY id DESC ");

                ReportName = "Panel Allocation";
            }
            if (ddlReporttype.SelectedItem.Value == "3")
            {
                sb.Clear();
                sb.Append(" SELECT pd.`PATIENTID` AS UHID,pd.`PAYMODE` AS PaymentMode,pd.`PAYAMT`,pd.`BANKNAME`,pd.`REF_NO` AS TrnasactonNo,pd.`PAID_BY`,pd.`BillNo`, pd.`RECEIPTNO`,DATE_FORMAT(pd.`RECEIPTDATE`,'%d-%b-%Y')RECEIPTDATE,IFNULL(pd.`ErrorMessage`,'')ErrorMessage,pd.`IsSync`,CONCAT(DATE_FORMAT(pd.`issyncdatetime`,'%d-%b-%Y'),' ',TIME_FORMAT(pd.`issyncdatetime`,'%h:%i:%s %p'))syncdatetime  ");
                sb.Append(" ,pm.`Company_Name` AS PanelName FROM  `finance`.`payment$detail` pd INNER JOIN `tenwek_live`.`f_panel_master` pm ON pd.`PanelID`=pm.`PanelID` where  date(pd.`issyncdatetime`)>= '" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND date(pd.`issyncdatetime`)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ORDER BY pd.`ID` DESC ");

                ReportName = "Payment Collection";
            }
            if (ddlReporttype.SelectedItem.Value == "4")
            {
                sb.Clear();
                sb.Append(" SELECT gd.`PURCHASEORDERNO`,gd.`REFERENCENO`,gd.`INVOICE_NO`,IFNULL(gd.`SUPPLIER_NAME`,'')SUPPLIER_NAME, gd.`TRANS_DATE`,gd.`ITEMNAME`, ");
                sb.Append(" gd.`ITEMID`,gd.`QTY`,gd.`PER_UNIT_PUR_PRICE`,gd.`TOT_PUR_PRICE`,gd.`BRANCHID`,gd.`IsSync`,CONCAT(DATE_FORMAT(gd.`issyncdatetime`,'%d-%b-%Y'),' ',TIME_FORMAT(gd.`issyncdatetime`,'%h:%i:%s %p'))syncdatetime  ,IFNULL(gd.`ErrorMessage`,'')ErrorMessage ");
                sb.Append(" FROM `finance`.grn$detail gd WHERE DATE(gd.`issyncdatetime`)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(gd.`issyncdatetime`)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ORDER BY id DESC ");

                ReportName = "Inventory Details";
            }
            if (ddlReporttype.SelectedItem.Value == "5")
            {
                sb.Clear();
                sb.Append(" SELECT wd.`PATIENTID` AS UHID ,wd.`PATIENTNAME`,wd.`WRITE_OFF_PANEL`,IFNULL(wd.`ErrorMessage`,'')ErrorMessage ,wd.`IsSync`,CONCAT(DATE_FORMAT(wd.`issyncdatetime`,'%d-%b-%Y'),' ',TIME_FORMAT(wd.`issyncdatetime`,'%h:%i:%s %p'))syncdatetime ");
                sb.Append(" ,fpm.`Company_Name` AS PanelName FROM `finance`.`writeoff$detail` wd INNER JOIN `tenwek_live`.`f_panel_master` fpm ON wd.`PANELID`=fpm.`PanelID` WHERE DATE(wd.`issyncdatetime`)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(wd.`issyncdatetime`)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ORDER BY wd.`ID` DESC ");
                ReportName = "Write Off Details";
            }
            if (ddlReporttype.SelectedItem.Value == "6")
            {
                sb.Clear();
                sb.Append(" SELECT pod.`PONUMBER`,DATE(pod.`PODATE`)PODate,pod.`AMOUNT` AS Advance,IFNULL(pod.`REMARKS`,'')REMARKS,IFNULL(pod.`ErrorMessage`,'')ErrorMessage,pod.`IsSync`,pod.`issyncdatetime` FROM `finance`.`po$advance` pod  WHERE DATE(pod.`issyncdatetime`)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(pod.`issyncdatetime`)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'  ORDER BY pod.`ID` DESC ");

                ReportName = "PO Advance";
            }

            if (ddlReporttype.SelectedItem.Value == "7")
            {
                sb.Clear();
                sb.Append(" SELECT sm.`SUPPLIERNAME`,sm.`EOPHONE`,sm.`ADDRESS`,sm.`Pin_NO`,sm.`CATEGORY`,sm.`SUPPLIERCODE`,sm.`VATType` ");
                sb.Append(" FROM `finance`.`supplier$master` sm WHERE DATE(sm.`suppliercreatedatetime`)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND  DATE(sm.`suppliercreatedatetime`)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ORDER BY sm.id DESC ");

                ReportName = "Supplier Master List";
            }

            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                Session["dtExport2Excel"] = dt;
                Session["ReportName"] = ReportName;
                Session["Period"] = "From Data:" + Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + " ToDate:" + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/ExportToExcel.aspx');", true);
            }
            else {
                spnMsg.Text = "No Records Found !!!";
            }
        }
        catch (Exception ex)
        {
            
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            spnMsg.Text = "Error Occured Contact Administrator";
        }
       
    }
}