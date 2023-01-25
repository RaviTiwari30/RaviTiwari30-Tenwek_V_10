using System;
using System.Data;
using System.Text;
using System.Web.UI;

public partial class Design_IPD_BillWiseCollection : System.Web.UI.Page
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
        sb.Append("  SELECT t.centreID,t.centreName,IsCash,BillingStatus,REPLACE(t.TransactionID,'ISHHI','')IPDNo,t.PName PatientName,Panel,");
        sb.Append("  IFNULL(BillNo,'')BillNo,IFNULL(DATE_FORMAT(BillDate,'%d-%b-%Y'),'')BillDate,ROUND(IFNULL(ServiceTaxAmt,0),2)ServiceTaxAmt, ");
        sb.Append("  ROUND(IFNULL(TotalBilledAmt,2))TotalBillAmt, ");
        sb.Append("  ROUND((Disc+DiscountOnBill),2)TotalDiscount, ");
        sb.Append("  ROUND(IFNULL((TotalBilledAmt-(Disc+DiscountOnBill)),0))NetAmount, ");
        sb.Append("  ROUND(IFNULL(Deposit,0))Deposit,ROUND(IFNULL(Refund,0))Refund,(Deduction+Writeoff+TDS)TotalDeduction,TDS,Writeoff,Deduction,    ");
        sb.Append("  IFNULL(ROUND((TotalBilledAmt+RoundOff)-(Disc+Deposit+Deduction+Writeoff+TDS+DiscountOnBill)+ IFNULL(ServiceTaxAmt,0) +IFNULL(Refund,0)),0) AS OutStanding, (SELECT Room_No FROM room_master WHERE Room_id=adpip.Room_id)RoomNo   ");
        sb.Append("  FROM (");
        sb.Append("       SELECT cmt.centreID,cmt.centreName,pm.PatientID MRNo,pm.Title,pm.PName,pmh.TransactionID,");
        sb.Append("       (SELECT MIN(PatientIPDProfile_ID) FROM patient_ipd_profile WHERE TransactionID=adj.TransactionID)AdPatientIPDProfile_ID,");
        sb.Append("       (SELECT MAX(PatientIPDProfile_ID) FROM patient_ipd_profile WHERE TransactionID=adj.TransactionID)DisPatientIPDProfile_ID,");
        sb.Append("       (SELECT Company_Name FROM f_panel_master WHERE PanelID= pmh.PanelID)Panel,");
        sb.Append("       (SELECT IF(IsCash='1','Cash','Credit')IsCash FROM f_panel_master WHERE PanelID= pmh.PanelID)IsCash, ");
        sb.Append("       UCASE(ich.Status)CurrentStatus,adj.BillNo,");
        sb.Append("       IF(DATE(adj.BillDate)='0001-01-01','',adj.BillDate)BillDate,");
        sb.Append("       IFNULL(pmh.Deduction_Acceptable,'0')Deduction,IFNULL(pmh.TDS,'0')TDS,IFNULL(pmh.WriteOff,'0')Writeoff,       ");    
        sb.Append("       IF(UCASE(ich.Status)<>'CANCEL',");
        sb.Append("       (SELECT SUM(Rate*Quantity) FROM f_ledgertnxdetail ");
        sb.Append("       WHERE TransactionID = adj.TransactionID AND IsVerified = 1 AND IsPackage = 0 ");
        sb.Append("       GROUP BY TransactionID),0)TotalBilledAmt,IFNULL(adj.DiscountOnBill,0)DiscountOnBill, IFNULL(adj.RoundOff,0)RoundOff,");
        sb.Append("       CAST(IFNULL((SELECT SUM(AmountPaid) FROM f_reciept WHERE TransactionID =adj.TransactionID AND IsCancel = 0 AND AmountPaid >0  GROUP BY adj.TransactionID),0) AS DECIMAL(15,2))Deposit,      ");
        sb.Append("       CAST(IFNULL((SELECT REPLACE(SUM(AmountPaid),'-','') FROM f_reciept WHERE TransactionID =adj.TransactionID AND IsCancel = 0 AND AmountPaid <0  GROUP BY adj.TransactionID),0) AS DECIMAL(15,2))Refund,      ");
        sb.Append("       IF(UCASE(ich.Status)<>'CANCEL',IFNULL((SELECT Round(SUM(((Rate*Quantity)*DiscountPercentage)/100),2)TotalDiscAmt FROM f_ledgertnxdetail ");
        sb.Append("       WHERE TransactionID = adj.TransactionID AND IsVerified = 1 AND IsPackage = 0 ");
        sb.Append("       GROUP BY TransactionID),0),0)Disc,Adj.ServiceTaxAmt,           ");
        sb.Append("       IF(IsBilledClosed=1,'BILL FINALISED','BILL NOT FINALISED')BillingStatus  ");
        sb.Append("       FROM f_ipdadjustment adj INNER JOIN ipd_case_history ich ON adj.TransactionID = ich.TransactionID  ");
        sb.Append("       INNER JOIN patient_medical_history pmh ON pmh.TransactionID = adj.TransactionID ");
        sb.Append("       INNER JOIN patient_master pm ON pm.PatientID = pmh.PatientID INNER JOIN center_master cmt ON cmt.centreID = pmh.`CentreID` WHERE adj.TransactionID <>''   ");
        sb.Append("       AND DATE(adj.Billdate)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "'   AND DATE(adj.Billdate)<='" + Util.GetDateTime(txtTodate.Text).ToString("yyyy-MM-dd") + "'    ");
        sb.Append("       AND IFNULL(BillNo,'')<>'' and pmh.`CentreID` in ("+Centre+")");
        sb.Append("    )t INNER JOIN patient_ipd_profile adpip ON adpip.PatientIPDProfile_ID = t.AdPatientIPDProfile_ID ");
        sb.Append("   INNER JOIN patient_ipd_profile dipip ON dipip.PatientIPDProfile_ID = t.DisPatientIPDProfile_ID ORDER BY DATE(BillDate)");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "From  Date " + Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + " To  Date " + Util.GetDateTime(txtTodate.Text).ToString("dd-MMM-yyyy");
            dt.Columns.Add(dc);
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            Session["ReportName"] = "BillWiseCollection";
            Session["ds"] = ds;
            // ds.WriteXmlSchema("E:\\BillWiseCollection.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
        }
        else

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }
    }