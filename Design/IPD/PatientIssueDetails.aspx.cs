using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;

public partial class Design_IPD_PatientIssueDetails : System.Web.UI.Page
{
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString.Count == 0 && Util.GetString(Request.QueryString["access"]) == "")
        {
            Response.Redirect(Request.RawUrl + "?access=" + Util.getHash());
        }
        else if (Request.QueryString.Count > 0 && Util.GetString(Request.QueryString["access"]) == "")
        {
            Response.Redirect(Request.RawUrl + "&access=" + Util.getHash());
        }
        if (!IsPostBack)
        {
            string TID = Request.QueryString["TransactionID"].ToString();
           ViewState["TID"] = TID;
        }
    }
    private void GetIssueDetails(string TransID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT tnxID,salesno,PerUnitSellingPrice,SUM(SoldUnits)SoldUnits,IssueDate,ItemName,BatchNumber,SUM(Amount)Amount,DiscountPercentage,IndentNo,TypeOfTnx,IFNULL(DiscountOnTotal,0)DiscountOnTotal,RoundOff,NetAmt,MedExpiryDate,PurTaxPer FROM ( ");
        if (chkissue.Checked)
        {            
            sb.Append("select '' tnxID,lt.Billno salesno,sd.PerUnitSellingPrice,sd.SoldUnits,date_format(sd.Date,'%d-%b-%y')IssueDate,st.ItemName,st.BatchNumber,(ltd.Amount) Amount,ltd.DiscountPercentage ,sd.IndentNo,");
            sb.Append(" 'ISSUE DETAILS ::' AS TypeOfTnx,ltd.itemid,lt.DiscountOnTotal,lt.RoundOff,lt.NetAmount NetAmt,IF(st.MedExpiryDate='0001-01-01','',DATE_FORMAT(st.MedExpiryDate,'%d-%b-%y'))MedExpiryDate,st.PurTaxPer from f_salesdetails sd inner join f_stock st on sd.StockID = st.StockID inner join f_ledgertransaction LT on sd.LedgerTransactionNo = LT.LedgerTransactionNo ");
            sb.Append(" inner join f_ledgertnxdetail ltd on Ltd.LedgerTransactionNo = LT.LedgerTransactionNo and ltd.StockID = sd.StockID where sd.TrasactionTypeID = 3 and LT.TransactionID = '" + TransID + "' and LT.IsCancel = 0 AND LT.TypeOfTnx = 'Sales' ");
        }
        if ((chkissue.Checked) && (chkreturn.Checked))
        {
            sb.Append(" UNION ALL ");
        }
        if (chkreturn.Checked)
        {
            sb.Append("  select ltd.ID tnxID,lt.Billno salesno,st.MRP PerUnitSellingPrice,ltd.Quantity SoldUnits,date_format(lt.Date,'%d-%b-%y')IssueDate,st.ItemName,st.BatchNumber,ltd.Amount,ltd.DiscountPercentage , '--'IndentNo,'RETURN DETAILS ::' AS TypeOfTnx,ltd.itemid,lt.DiscountOnTotal,lt.RoundOff,lt.NetAmount NetAmt,IF(st.MedExpiryDate='0001-01-01','',DATE_FORMAT(st.MedExpiryDate,'%d-%b-%y'))MedExpiryDate,st.PurTaxPer ");
            sb.Append(" FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd on ltd.LedgerTransactionNo = lt.LedgerTransactionNo inner join f_stock st on st.STOCKID = LTD.STOCKID where LT.TypeOfTnx = 'Return' and LT.IsCancel = 0 ");
            sb.Append(" and LT.TransactionID = '" + TransID + "'");
        }
        sb.Append(" )t  GROUP BY t.typeoftnx,IssueDate,t.salesno, t.itemid ");
       
        
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            decimal IssueAmount = Util.GetDecimal(dt.Compute(" SUM(Amount)", "TypeOfTnx = 'ISSUE DETAILS ::'"));
            decimal ReturnAmount = Util.GetDecimal(dt.Compute(" SUM(Amount)", "TypeOfTnx = 'RETURN DETAILS ::'"));

            DataColumn dc = new DataColumn();
            dc.ColumnName = "NetAmount";
            dc.DefaultValue = IssueAmount + ReturnAmount;

            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "User";
            dc.DefaultValue = Convert.ToString(Session["LoginName"]);
            dt.Columns.Add(dc);

            //else
            //{

            //    DataColumn dc = new DataColumn();
            //    dc.ColumnName = "NetAmount";
            //    dt.Columns.Add(dc);

            //    dc = new DataColumn();
            //    dc.ColumnName = "User";
            //    dt.Columns.Add(dc);

            //    DataRow dr = dt.NewRow();
            //    dr["User"] = Convert.ToString(Session["LoginName"]);
            //    dr["NetAmount"] = 0;
            //    dt.Rows.Add(dr);
            //}

            StringBuilder psb = new StringBuilder();

            psb.Append("select ich.TransactionID,date_format(if(ich.DateOfAdmit = '0001-01-01',curdate(),ich.DateOfAdmit),'%d-%b-%Y')DateOfAdmit,date_format(if(ich.DateOfDischarge = '0001-01-01',curdate(),ich.DateOfDischarge),'%d-%b-%Y')DateOfDischarge,concat(pm.Title,' ',pm.PName)Name,pnl.Company_Name,");
            psb.Append(" concat(dm.Title,' ',dm.Name)Consultant from ipd_case_history ich inner join patient_medical_history pmh");
            psb.Append(" on ich.TransactionID = pmh.TransactionID inner join patient_master pm on pmh.PatientID = pm.PatientID");
            psb.Append(" inner join f_panel_master pnl on pmh.PanelID = pnl.PanelID inner join doctor_master dm on pmh.DoctorID = dm.DoctorID");
            psb.Append(" where ich.TransactionID = '" + TransID + "'");

            DataTable dtPatient = StockReports.GetDataTable(psb.ToString());

            DataSet ds = new DataSet();
            dtPatient.TableName = "PatientDetail";
            ds.Tables.Add(dtPatient.Copy());

            dt.TableName = "IssueDetails";
            ds.Tables.Add(dt.Copy());

            Session["ds"] = ds;
            //ds.WriteXml(@"D://creditmemo.xml");
            //  ds.WriteXmlSchema(@"D://creditmemo.xml");
            Session["ReportName"] = "CreditIssueDetail";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('Commonreport.aspx');", true);
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('CommonCrystalreport.aspx');", true);
        }

        else
        {
            lblMsg.Text = "No Record Found";
            return;
        }
        
    }
    protected void btnView_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        GetIssueDetails(ViewState["TID"].ToString());
    }
}
