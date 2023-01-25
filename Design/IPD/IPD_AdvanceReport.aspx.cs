using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;


public partial class Design_IPD_IPD_AdvanceReport : System.Web.UI.Page
{
	DataTable dt = new DataTable();

	protected void Page_Load(object sender, EventArgs e)
	{
		if (!IsPostBack)
		{
			ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
			ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnReport);
            All_LoadData.bindPanel(ddlPanel,"ALL");
		}
		ucFromDate.Attributes.Add("readOnly", "true");
		ucToDate.Attributes.Add("readOnly", "true");
        lblMsg.Text = "";
	}
	protected void btnReport_Click(object sender,EventArgs e)
	{
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
		dt = new DataTable();
		StringBuilder sb = new StringBuilder();
		try
		{

			if (rbtType.SelectedItem.Value == "1")
			{
                sb.Append(" SELECT  ");
                sb.Append(" pm.PatientID UHID, ");
                sb.Append(" PMH.TransNo IPDNo,  ");
                sb.Append(" pm.Pname PatientName, PMH.PanelID, (pnl.Company_Name)Panel,");
                sb.Append(" rc.ReceiptNo ReceiptNo,DATE_FORMAT(rc.date,'%d %b %Y') RecieptDate,rc.`AmountPaid` AmountPaid,GROUP_CONCAT(rpd.`PaymentMode`)PaymentMode, rc.Reciever, rc.Naration Narration,(emp.Name)Received_By,IF(rc.LedgerNoCr='LSHHI11','ADVANCE','SETTLEMENT')TypeOfAdvance   ");
				sb.Append(" FROM patient_master pm  ");
				sb.Append(" INNER JOIN f_reciept rc  ON pm.PatientID = rc.Depositor ");
                sb.Append(" INNER JOIN `f_receipt_paymentdetail` rpd ON rc.`ReceiptNo`= rpd.`ReceiptNo`  ");
				//sb.Append(" INNER JOIN f_ipdadjustment adj  ON rc.TransactionID = adj.TransactionID ");
				sb.Append(" INNER JOIN Patient_medical_history PMH  ON PMH.TransactionID = rc.TransactionID ");
                sb.Append(" INNER JOIN center_master cm ON cm.`CentreID`=pmh.`CentreID` INNER JOIN f_panel_master pnl  ON pnl.PanelID = PMH.PanelID ");
				sb.Append(" LEFT JOIN employee_master emp ON emp.employeeID=rc.Reciever  ");
                sb.Append(" WHERE  rc.isCancel=0 and pmh.CentreID IN (" + Centre + ")");
                if (rdbcolType.SelectedValue == "1")
                    sb.Append(" AND LedgerNoCr='LSHHI11'  ");
                if (rdbcolType.SelectedValue == "2")
                    sb.Append(" AND LedgerNoCr='LSHHI12'  ");
                if (rdbcolType.SelectedValue == "0")
                    sb.Append(" AND LedgerNoCr IN ('LSHHI11','LSHHI12') ");
				if (txtIpno.Text.ToString() == "")
				{
					if (Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") != string.Empty)
						sb.Append(" and DATE(rc.Date) >= '" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "'  ");

					if (Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") != string.Empty)
						sb.Append(" AND DATE(rc.Date) <= '" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'  ");

					if (ddlPanel.SelectedValue != "0")
						sb.Append(" AND PMH.PanelID='" + ddlPanel.SelectedValue.ToString() + "' ");

				}
				else if (txtIpno.Text.ToString() != string.Empty)
				{
                    sb.Append(" and PMH.TransactionID='" + txtIpno.Text.ToString() + "' ");//ISHHI
				}

                sb.Append(" GROUP BY rc.ReceiptNo order by cm.`CentreID`,rc.ReceiptNo ");
			}
			else
			{

                sb.Append(" SELECT cm.`CentreID`,cm.`CentreName`,pm.PatientID MRNo,REPLACE(pmh.TransactionID,'ISHHI','')IpNo, ");
                sb.Append(" pm.Pname,(pnl.Company_Name)PanelName,AmountPaid FROM ( ");
				sb.Append("     SELECT  ROUND(SUM(AmountPaid))AmountPaid,rc.TransactionID FROM ( ");
				sb.Append("         SELECT * FROM ipd_case_history ich INNER JOIN ( ");
				sb.Append("             SELECT * FROM temp_for_date WHERE dt>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' AND dt<= '" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "' ");
				sb.Append("         ) tfd WHERE  ich.DateOfAdmit <= tfd.dt "); 
				sb.Append("         AND IF(STATUS='IN',CURDATE(),ich.DateOfDischarge) >= tfd.dt ");

				if (txtIpno.Text.ToString() != string.Empty)
				{
					sb.Append("     AND ich.TransactionID='ISHHI" + txtIpno.Text.ToString() + "' ");
				}

				sb.Append("     )ich INNER JOIN f_reciept rc  ON ich.TransactionID = rc.TransactionID ");
				sb.Append("     WHERE DATE(rc.date) <= '" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' GROUP BY rc.TransactionID ");
				sb.Append(" ) t ");
				sb.Append(" INNER JOIN Patient_medical_history PMH  ON PMH.TransactionID = t.TransactionID "); 
				sb.Append(" INNER JOIN patient_master pm   ON pm.PatientID = pmh.PatientID ");
				sb.Append(" INNER JOIN f_panel_master pnl  ON pnl.PanelID = PMH.PanelID ");
				sb.Append(" order by cm.`CentreID`,t.TransactionID ");
			}


			dt = StockReports.GetDataTable(sb.ToString());

			if (dt.Rows.Count > 0)
			{

				if(dt.Columns.Contains("PanelID")==true) dt.Columns.Remove("PanelID");
				if (dt.Columns.Contains("Reciever") == true) dt.Columns.Remove("Reciever");

				DataRow dr = dt.NewRow();
				dr["AmountPaid"]=dt.Compute("sum(AmountPaid)","");
				dt.Rows.Add(dr);
				string strDate = "";

				if (rbtType.SelectedValue == "1")
					strDate = " - Between  " + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + " To  " + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd");
				else
					strDate = " - As On  " + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd");


				Session["dtExport2Excel"] = dt;
				Session["ReportName"] = "IPD Advance Report " + strDate;
				ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
				lblMsg.Text = "";
			}
			else
			{
				ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);

			}

		}
		catch (Exception ex)
		{
			ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);


		}
	}
	protected void rbtType_SelectedIndexChanged(object sender, EventArgs e)
	{
		if (rbtType.SelectedValue == "1")
		{
			lblDtFrom.Visible = true;
			lblDtFrom.Text = "From Date :&nbsp;";
			lblDtTo.Text = "To Date :&nbsp;";
			ucToDate.Visible = true;
			ucFromDate.Visible = true;
			lblDtFrom.Visible = true;
			lblDtTo.Visible = true;
			
		}
		else
		{
			lblDtFrom.Visible = true;
			lblDtTo.Text = "As On :&nbsp;";
			ucFromDate.Visible = false;
			lblDtFrom.Visible = false;
		}
	}
}
