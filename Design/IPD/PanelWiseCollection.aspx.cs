using System;
using System.Data;
using System.Text;
using System.Web.UI;

public partial class PanelWiseCollection : System.Web.UI.Page
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
        sb.Append(" SELECT * FROM (   ");
        sb.Append("    SELECT t.centreID,t.centreName,IsCash,BillingStatus,REPLACE(t.TransactionID,'ISHHI','')IPDNo,t.PName PatientName,Panel,DateOfAdmit,DateOfDischarge, ");
        sb.Append("           IFNULL(BillNo,'')BillNo,IFNULL(DATE_FORMAT(BillDate,'%d-%b-%Y'),'')BillDate,ROUND(IFNULL(ServiceTaxAmt,0),2)ServiceTaxAmt, ");
        sb.Append("           ROUND(IFNULL(TotalBilledAmt,2))TotalBillAmt, ");
        sb.Append("           ROUND((Disc+DiscountOnBill),2)TotalDiscount,  ");
        sb.Append("           ROUND(IFNULL((TotalBilledAmt-(Disc+DiscountOnBill)),0))NetAmount,  ");
        sb.Append("           ROUND(IFNULL(Deposit,0))Deposit,ROUND(IFNULL(Refund,0))Refund,(Deduction+Writeoff+TDS)TotalDeduction,TDS,Writeoff,Deduction,  ");
        sb.Append("           IFNULL(ROUND((TotalBilledAmt)-(Disc+Deposit+Deduction+Writeoff+TDS+RoundOff+DiscountOnBill)+ IFNULL(ServiceTaxAmt,0) +IFNULL(Refund,0)),0) AS OutStanding    ");
        sb.Append("           FROM ( ");
        sb.Append("                SELECT cmt.centreID,cmt.CentreName,pm.PatientID MRNo,pm.Title,pm.PName,pmh.TransactionID, ");
        sb.Append("                (SELECT MIN(PatientIPDProfile_ID) FROM patient_ipd_profile WHERE TransactionID=pmh.TransactionID)AdPatientIPDProfile_ID, ");
        sb.Append("                (SELECT MAX(PatientIPDProfile_ID) FROM patient_ipd_profile WHERE TransactionID=pmh.TransactionID)DisPatientIPDProfile_ID, ");
        sb.Append("                (SELECT Company_Name FROM f_panel_master WHERE PanelID= pmh.PanelID)Panel, ");
        sb.Append("                (SELECT IF(IsCash='1','Cash','Credit')IsCash FROM f_panel_master WHERE PanelID= pmh.PanelID)IsCash,  ");
        sb.Append("                UCASE(pmh.Status)CurrentStatus,pmh.BillNo, ");
        sb.Append("                IF(DATE(pmh.BillDate)='0001-01-01','',pmh.BillDate)BillDate, ");
        sb.Append("                IFNULL(pmh.Deduction_Acceptable,'0')Deduction,IFNULL(pmh.TDS,'0')TDS,IFNULL(pmh.WriteOff,'0')Writeoff,       ");
        sb.Append("                DATE_FORMAT(pmh.DateOfAdmit,'%d-%b-%Y')DateOfAdmit, ");
        sb.Append("                DATE_FORMAT(pmh.DateOfDischarge,'%d-%b-%Y')DateOfDischarge, ");
        sb.Append("                IF(UCASE(pmh.Status)<>'CANCEL', ");
        sb.Append("                (SELECT SUM(Rate*Quantity) FROM f_ledgertnxdetail  ");
        sb.Append("                WHERE TransactionID = pmh.TransactionID AND IsVerified = 1 AND IsPackage = 0  ");
        sb.Append("                GROUP BY TransactionID),0)TotalBilledAmt,IFNULL(pmh.DiscountOnBill,0)DiscountOnBill, IFNULL(pmh.RoundOff,0)RoundOff, ");
        sb.Append("                CAST(IFNULL((SELECT SUM(AmountPaid) FROM f_reciept WHERE TransactionID =pmh.TransactionID AND IsCancel = 0 AND AmountPaid >0  GROUP BY pmh.TransactionID),0) AS DECIMAL(15,2))Deposit,     ");
        sb.Append("                CAST(IFNULL((SELECT REPLACE(SUM(AmountPaid),'-','') FROM f_reciept WHERE TransactionID =pmh.TransactionID AND IsCancel = 0 AND AmountPaid <0  GROUP BY pmh.TransactionID),0) AS DECIMAL(15,2))Refund,       ");
        sb.Append("                IF(UCASE(pmh.Status)<>'CANCEL',IFNULL((SELECT Round(SUM(((Rate*Quantity)*DiscountPercentage)/100),2)TotalDiscAmt FROM f_ledgertnxdetail  ");
        sb.Append("                WHERE TransactionID = pmh.TransactionID AND IsVerified = 1 AND IsPackage = 0  ");
        sb.Append("                GROUP BY TransactionID),0),0)Disc,pmh.ServiceTaxAmt,  ");
        sb.Append("                IF(IsBilledClosed=1,'BILL FINALISED','BILL NOT FINALISED')BillingStatus   ");
        sb.Append("                FROM patient_medical_history pmh INNER JOIN patient_master pm ON pm.PatientID = pmh.PatientID ");
        sb.Append("                INNER JOIN center_master cmt ON cmt.centreID = pmh.CentreID ");
        sb.Append("                WHERE pmh.Type = 'IPD' AND pmh.TransactionID <> '' AND DATE(pmh.Billdate)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(pmh.Billdate)<='" + Util.GetDateTime(txtTodate.Text).ToString("yyyy-MM-dd") + "' ");
        sb.Append("                AND IFNULL(pmh.BillNo,'') <> '' AND pmh.CentreID in (" + Centre + ")");
        sb.Append("             )t INNER JOIN patient_ipd_profile adpip ON adpip.PatientIPDProfile_ID = t.AdPatientIPDProfile_ID  ");
        sb.Append("                INNER JOIN patient_ipd_profile dipip ON dipip.PatientIPDProfile_ID = t.DisPatientIPDProfile_ID ORDER BY DATE(BillDate) ");
        sb.Append("            )t2   ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "From  Date " + Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + " To  Date " + Util.GetDateTime(txtTodate.Text).ToString("dd-MMM-yyyy");
            dt.Columns.Add(dc);

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());

            Session["ReportName"] = "PanelWiseCollection";
            Session["ds"] = ds;

            // ds.WriteXmlSchema("D:\\PanelWiseCollection.xml");

            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }
    }
}