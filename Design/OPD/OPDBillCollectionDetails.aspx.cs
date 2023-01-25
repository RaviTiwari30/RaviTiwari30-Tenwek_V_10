using System;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
public partial class Design_OPD_OPDBillCollectionDetails : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnReport);
            BindPanels();
            lblMsg.Text = "";
        }
        txtFromDate.Attributes.Add("readOnly", "readOnly");
        txtToDate.Attributes.Add("readOnly", "readOnly");
    }
    private void BindPanels()
    {

        DataTable dt = LoadCacheQuery.loadAllPanel();

        if (dt.Rows.Count > 0)
        {
            chkListPanel.DataSource = dt;
            chkListPanel.DataTextField = "Company_Name";
            chkListPanel.DataValueField = "PanelID";
            chkListPanel.DataBind();
        }
        else
            lblMsg.Text = "No Company Found";
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        lblMsg.Text = "";
        string PanelIds = string.Empty;
        PanelIds = StockReports.GetSelection(chkListPanel);
        if (PanelIds == "")
        {
            lblMsg.Text = "Please Select Panel";
            return;
        }
     
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT pm.`PName`,lt.TransactionID, lt.`BillNo`,lt.`NetAmount` S_Amount,lt.`PanelID`, ");
        sb.Append(" CONCAT(DATE_FORMAT(lt.`BillDate`,'%d-%b-%Y'),' ',DATE_FORMAT(lt.Time,'%h:%i %p'))BillDate, ");
        sb.Append(" pm.`PatientID`,rc.`ReceiptNo`, CONCAT(DATE_FORMAT(rc.date,'%d-%b-%Y'),' ',DATE_FORMAT(rc.time,'%h:%i %p'))RecDate, ");
        sb.Append(" IFNULL(rc.`AmountPaid`,0)AmountPaid,(SELECT p.`Company_Name` FROM `f_panel_master` p WHERE lt.`PanelID`=p.`PanelID`)Company_Name, ");
        sb.Append(" (SELECT CentreName FROM `center_master` cm WHERE cm.`CentreID`=lt.`CentreID`)CentreName, ");
        sb.Append(" (SELECT GROUP_CONCAT(rec_pay.PaymentMode) FROM `f_receipt_paymentdetail` rec_pay WHERE rec_pay.`ReceiptNo`=rc.`ReceiptNo`)PaymentMode ");
        sb.Append(" FROM f_ledgertransaction lt  ");
        sb.Append(" LEFT JOIN `f_reciept` rc  ON lt.`TransactionID`=rc.`TransactionID`   ");
        sb.Append(" INNER JOIN `patient_medical_history` pmh ON lt.`TransactionID`=pmh.`TransactionID`   ");
        sb.Append(" INNER JOIN `patient_master`  pm ON pmh.`PatientID`=pm.`PatientID` ");
        sb.Append(" WHERE  lt.`CentreID` IN(" + Centre + ") AND lt.`PanelID` IN (" + PanelIds + ") ");
        sb.Append(" AND lt.`BillNo`<>'' ");
        if (txtUHID.Text != "")
        {
            sb.Append(" AND pm.`PatientID`='" + txtUHID.Text.Trim() + "' ");
        }
        else
        {
            sb.Append(" AND DATE(lt.`BillDate`)>='" + (Convert.ToDateTime(txtFromDate.Text)).ToString("yyyy-MM-dd") + "' AND DATE(lt.`BillDate`)<= '" + (Convert.ToDateTime(txtToDate.Text)).ToString("yyyy-MM-dd") + "' ");
        }

        DataTable dt = new DataTable();

       dt = StockReports.GetDataTable(sb.ToString());
       if (dt.Rows.Count > 0)
       {
           lblMsg.Text = "";
           DataColumn dc = new DataColumn();
           dc.ColumnName = "ReportDate";
           dc.DefaultValue = "From : " + Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");
           dt.Columns.Add(dc);
           DataSet ds = new DataSet();
           ds.Tables.Add(dt.Copy());

           Session["ds"] = ds;
           Session["ReportName"] = "OPDBillCollection";
          // ds.WriteXmlSchema(@"F:\OPDBillCollection.xml");
           ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
       }
       else
       {
           lblMsg.Text = "Record Not Found";
       }
    }

}