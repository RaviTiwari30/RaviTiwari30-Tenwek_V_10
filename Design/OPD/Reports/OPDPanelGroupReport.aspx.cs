using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OPD_OPDPanelGroupReport : System.Web.UI.Page
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
            calFromDate.EndDate = DateTime.Now;
            calToDate.EndDate = DateTime.Now;
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
                    PanelID += ",'" + li.Value + "'";
                else
                    PanelID = "'" + li.Value + "'";
            }
        }
        if (PanelGroupID == "" && PanelID == "" && txtMRNo.Text.Trim() == "" && txtBillNo.Text.Trim() == "")
        {
            lblMsg.Text = "Please Select Panel Group OR Panel";
            return;
        }
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT cm.CentreName,cm.CentreID,fpm.PanelGroupID,fpm.PanelGroup,pmh.PanelID,fpm.Company_Name,ptn.PatientID,ptn.PName PatientName, ptn.Age,ptn.Gender, ");
        sb.Append(" TRIM(CONCAT(ptn.House_No,' ',ptn.Street_Name,' ',ptn.Locality,' ',ptn.City,' ',ptn.State,' ',ptn.Country))Address,ptn.Mobile ContactNo, ");
        sb.Append(" ROUND(lt.NetAmount,2)NetAmt,ROUND(lt.GrossAmount,2)GrossAmt, ROUND(lt.DiscountOnTotal,2)DiscAmt,sum(IFnull(r.AmountPaid,0))PaidAmt, ");
        sb.Append(" date_FORMAT(pmh.BillDate,'%d-%b-%y')BillDate,pmh.BillNo FROM f_ledgertransaction lt");
        sb.Append(" INNER JOIN patient_medical_history pmh on pmh.TransactionID=lt.TransactionID AND pmh.Type!='IPD' ");
        sb.Append(" INNER JOIN patient_master ptn on ptn.PatientID=pmh.PatientID  INNER JOIN Center_master cm ON cm.CentreID = pmh.CentreID ");
        sb.Append(" INNER JOIN f_panel_master fpm ON fpm.PanelID=pmh.PanelID  ");
        if (txtBillNo.Text.Trim() == "")
        {
            sb.Append("         AND date(pmh.BillDate)>='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' ");
            sb.Append("         AND date(pmh.BillDate)<='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'  ");
        }

        if (txtBillNo.Text.Trim() != "")
            sb.Append(" AND pmh.BillNo='" + txtBillNo.Text.Trim() + "' ");

        if (txtMRNo.Text.Trim() != "")
            sb.Append(" AND pmh.PatientID='" + txtMRNo.Text.Trim() + "' ");
        

        sb.Append("  LEFT OUTER JOIN  f_reciept r ON r.AsainstLedgerTnxNo=lt.LedgerTransactionNo AND r.IsCancel=0 AND  r.CentreID IN (" + Centre + ")");

        if (txtBillNo.Text.Trim() == "")
        {
            sb.Append("         AND date(r.Date)>='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' ");
            sb.Append("         AND date(r.Date)<='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'  ");

        }     
        
        sb.Append("  where pmh.CentreID IN (" + Centre + ") AND lt.IsCancel=0 ");

        if (PanelGroupID != "")
            sb.Append("  AND fpm.PanelGroupID IN(" + PanelGroupID + ")   ");

        if (PanelID != "" && PanelGroupID != "")
            sb.Append(" AND fpm.PanelID IN(" + PanelID + ")   ");
        else if (PanelID != "")
            sb.Append("  AND fpm.PanelID IN(" + PanelID + ")   ");

        sb.Append(" GROUP BY lt.TransactionID ORDER BY pmh.BillNo ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = Convert.ToString(Session["LoginName"]);
            dt.Columns.Add(dc);

            DataColumn dc1 = new DataColumn();
            dc1.ColumnName = "ReportType";
            dc1.DefaultValue = " From " + Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");
            dt.Columns.Add(dc1);

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            Session["ReportName"] = "OPDPanelGroupReport";
            Session["ds"] = ds;
          //  ds.WriteXmlSchema(@"E:\OPDPanelGroupReport.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../../Design/Common/Commonreport.aspx');", true);
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