using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_IPD_IPDPanelGroupReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            All_LoadData.BindPanelGroup(null, "", chklPanelGroup);
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnReport);
            bindPanel();
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }
    
    protected void btnReport_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        string PanelGroupID = string.Empty;
        string PanelID = string.Empty;
        foreach (ListItem li in chklPanelGroup.Items)
        {
            if (li.Selected)
            {
                if (PanelGroupID != string.Empty)
                    PanelGroupID += ",'" + li.Value + "'";
                else
                    PanelGroupID = "'" + li.Value + "'";
            }
        }
        foreach (ListItem li in chkAllPanel.Items)
        {
            if (li.Selected)
            {
                if (PanelID != string.Empty)
                    PanelID += "," + li.Value + " ";
                else
                    PanelID = "" + li.Value + "";
            }
        }
        if (PanelGroupID == "" && PanelID == "" && txtIPDNo.Text.Trim() == "" && txtBillNo.Text.Trim() == "")
        {
            lblMsg.Text = "Please Select Panel Group OR Panel";
            return;
        }
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT CentreName,centreID,PanelGroupID,PanelGroup,PanelID,Company_Name,IPDNo,TransactionID,Pname,DateOfAdmit, ");
        sb.Append("DateOfDischarge,BillNo,BillDate,  GrossAmt,TotalDisc,ROUND((GrossAmt-TotalDisc),2)NetAmt,DiscountOnBill,PaidAmt, ");
        sb.Append("ROUND((GrossAmt-TotalDisc-PaidAmt-TDS-WriteOff-Deduction),2)PendingAmt,TDS,WriteOff,Deduction,PanelApprovalAmount, ");
        sb.Append("PanelAmountAllocation   ");
        sb.Append("FROM  ");
	    sb.Append("(   ");
		sb.Append("SELECT cm.CentreName,cm.centreID,IF(pmh.PanelID=1,fpm.Panel_Code,fpm1.Panel_Code)Panel_Code, ");
		sb.Append("IF(pmh.PanelID=1,fpm.PanelGroupID,fpm1.PanelGroupID)PanelGroupID, ");
		sb.Append("IF(pmh.PanelID=1,fpm.PanelGroup,fpm1.PanelGroup)PanelGroup, ");
		sb.Append("IF(pmh.PanelID=1,fpm.PanelID,fpm1.PanelID)PanelID,IF(pmh.PanelID=1,fpm.Company_Name,fpm1.Company_Name)Company_Name , ");
		sb.Append("PMH.TransactionID,pmh.TransNo IPDNo,CONCAT(pm.title,' ',pm.Pname)Pname,   ");
		sb.Append("DATE_FORMAT(PMH.DateOfAdmit,'%d-%b-%y')DateOfAdmit,IF(PMH.Status='OUT', ");
		sb.Append("DATE_FORMAT(PMH.DateOfDischarge,'%d-%b-%y'),'')DateOfDischarge, IFNULL(PMH.BillNo,'')BillNo, ");
		sb.Append("IF(IFNULL(PMH.BillNo,'')<>'',DATE_FORMAT(PMH.Billdate,'%d-%b-%y'),'')BillDate,  ");
		sb.Append("IFNULL(PMH.DiscountOnBill,0)DiscountOnBill,    ");
		sb.Append("(SELECT ROUND((SUM(ltda.GrossAmount)),2)  FROM f_ledgertnxdetail   ltda  ");
		sb.Append("WHERE  ltda.TransactionID = PMH.TransactionID AND ltda.IsPackage = 0 AND ltda.IsVerified =1 )AS GrossAmt,    ");
		sb.Append("((SELECT ROUND(SUM(ltd.TotalDiscAmt),2)  FROM f_ledgertnxdetail ltd   ");
		sb.Append("WHERE  TransactionID = PMH.TransactionID AND IsPackage = 0 AND IsVerified = 1)+IFNULL(PMH.DiscountOnBill,0))TotalDisc,   ");
		sb.Append("(SELECT IFNULL(SUM(AmountPaid),0) FROM f_reciept WHERE TransactionID = PMH.TransactionID AND IsCancel = 0)AS PaidAmt  , ");
		sb.Append("IFNULL(pmh.TDS,0)TDS,IFNULL(pmh.WriteOff,0)WriteOff,(IFNULL(pmh.Deduction_Acceptable,0)+  ");
		sb.Append("IFNULL(pmh.Deduction_NonAcceptable,0))Deduction, ");
		sb.Append("IFNULL(SUM(pap.PanelApprovedAmt),0)PanelApprovalAmount, ");
		sb.Append("IFNULL(SUM(aml.Amount),0)PanelAmountAllocation     ");
		sb.Append("FROM patient_medical_history pmh ");
		sb.Append("INNER JOIN patient_master pm ON pm.PatientID=PMH.PatientID  AND pmh.Type='IPD' ");
		sb.Append("INNER JOIN f_panel_master fpm ON fpm.PanelID=pmh.PanelID   ");
		sb.Append("INNER JOIN center_master cm ON cm.centreID=pmh.centreID    ");
		sb.Append("LEFT JOIN f_IpdPanelApproval pap ON pap.TransactionID=PMH.TransactionID ");
		sb.Append("LEFT JOIN panel_amountallocation aml ON aml.TransactionID=PMH.TransactionID ");
		sb.Append("LEFT JOIN f_panel_master fpm1 ON fpm1.PanelID=aml.PanelID ");
		sb.Append("WHERE PMH.TransactionID<>''   		  ");
        if (txtIPDNo.Text.Trim() != "")
            sb.Append(" AND PMH.TransactionID='ISHHI" + txtIPDNo.Text.Trim() + "' ");
        if (txtBillNo.Text.Trim() != "")
            sb.Append(" AND PMH.BillNo='" + txtBillNo.Text.Trim() + "' ");
        if (txtIPDNo.Text.Trim() == "" && txtBillNo.Text.Trim() == "")
        {
            if (rblReportType.SelectedValue == "1")
                sb.Append(" AND PMH.DateOfAdmit>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND PMH.DateOfAdmit<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ");
            else if (rblReportType.SelectedValue == "2")
                sb.Append(" AND PMH.DateOfDischarge>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND PMH.DateOfDischarge<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ");
            else if (rblReportType.SelectedValue == "3")
                sb.Append(" AND PMH.Billdate>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' AND PMH.Billdate<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
        }
        sb.Append("AND PMH.centreID IN (" + Centre + ")  ");
		sb.Append("GROUP BY IF(pmh.PanelID=1,fpm.PanelID,aml.PanelID),PMH.TransactionID ");
	    sb.Append(")t  ");
        sb.Append("WHERE t.TransactionID<>'' ");
        if (txtIPDNo.Text.Trim() == "" && txtBillNo.Text.Trim() == "")
        {
            if (PanelGroupID != "")
                sb.Append(" AND t.PanelGroupID IN (" + PanelGroupID + ")   ");
            if (PanelID != "")
                sb.Append(" AND t.PanelID IN (" + PanelID + ")   ");
        }
        sb.Append("ORDER BY REPLACE(REPLACE(t.TransactionID,'ISHHI',''),'F','')+0 ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = Convert.ToString(Session["LoginName"]);
            dt.Columns.Add(dc);

            DataColumn dc1 = new DataColumn();
            dc1.ColumnName = "ReportType";
            dc1.DefaultValue = rblReportType.SelectedItem.Text + " From " + Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");
            dt.Columns.Add(dc1);

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            Session["ReportName"] = "IPDPanelGroupReport";
            Session["ds"] = ds;
            //ds.WriteXmlSchema(@"F:\IPDPanelGroupReport.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
        }
        else
        {
            lblMsg.Text = "Record Not Found";
        }
    }
    protected void chklPanelGroup_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindPanel();
    }

    private void bindPanel()
    {
        string PanelGroupID = string.Empty;
        foreach (ListItem li in chklPanelGroup.Items)
        {
            if (li.Selected)
            {
                if (PanelGroupID != string.Empty)
                    PanelGroupID += ",'" + li.Value + "'";
                else
                    PanelGroupID = "'" + li.Value + "'";
            }
        }
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT  RTRIM(LTRIM(Company_Name)) AS Company_Name,PanelID,PanelGroupID FROM f_panel_master WHERE  IsActive=1 ");
        if (PanelGroupID != "")
            sb.Append(" AND PanelGroupID IN (" + PanelGroupID + ") ");
        sb.Append(" order by Company_Name");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            chkAllPanel.DataSource = dt;
            chkAllPanel.DataTextField = "Company_Name";
            chkAllPanel.DataValueField = "PanelID";
            chkAllPanel.DataBind();
        }
    }
    protected void chkAllPanelGroup_CheckedChanged(object sender, EventArgs e)
    {
       
            bindPanel();
        

    }
}