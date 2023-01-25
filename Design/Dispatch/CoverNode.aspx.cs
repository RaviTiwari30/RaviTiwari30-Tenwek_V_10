using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Text;
using MySql.Data.MySqlClient;

public partial class Design_Dispatch_CoverNode : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindPanel();
            ucFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
        ucFromDate.Attributes.Add("readOnly", "readOnly");
        ucToDate.Attributes.Add("readOnly", "readOnly");
    }
    private void bindPanel()
    {
        DataTable dt = All_LoadData.loadPanelRoleWisePanelGroupWise(1);
        if (dt.Rows.Count > 0)
        {
            ddlPanelCompany.DataSource = dt;
            ddlPanelCompany.DataTextField = "Company_Name";
            ddlPanelCompany.DataValueField = "PanelID";
            ddlPanelCompany.DataBind();
        }
        else
        {
            ddlPanelCompany.Items.Insert(0, "--No Panel Found--");
            lblMsg.Text = "Please Map Panel Group with Selected Role or Enable Cover Note Feature from Panel Master.";
        }

    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        //if (txtMRNo.Text == string.Empty)
        //{
        //    lblMsg.Text = "Please Enter UHID";
        //    txtMRNo.Focus();
        //    return;
        //}
        lblMsg.Text = "";
        BindCoverNodeData();
    }

    private void BindCoverNodeData()
    {
        StringBuilder sb = new StringBuilder();

        //if (txtMRNo.Text.Trim() != string.Empty && rblType.SelectedValue=="OPD")
        //{
        //      sb.Clear();
        //      sb.Append(" SELECT pm.PatientID,CONCAT(pm.Title,' ',pm.PName)PatientName,pnl.Company_Name AS Company,pnl.PanelID,pmh.PolicyNo,pmh.CardNo,pmh.`CardHolderName`,pmh.ReferralNo,DATE_FORMAT(pmh.ReferralDate,'%d-%b-%Y')ReferralDate,pmh.ClaimID,DATE_FORMAT(lt.Date,'%d-%b-%Y')BillDate,lt.BillNo,ltd.`ItemName` Description,ltd.`rateItemCode` AS ItemCode,ltd.Amount,lt.LedgerTransactionNo,lt.TransactionID,lt.`NetAmount`,ltd.discAmt,lt.Adjustment AS PaidAmt,lt.GrossAmount,IFNULL(cv.`CoverNoteNo` ,'')CoverNote ");
        //    sb.Append(" FROM f_ledgertransaction lt  ");
        //    sb.Append(" INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo=ltd.LedgerTransactionNo   ");
        //    sb.Append(" INNER JOIN patient_medical_history pmh ON lt.TransactionID=pmh.TransactionID   ");
        //    sb.Append(" INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID    ");
        //    sb.Append(" INNER JOIN f_panel_master pnl ON pmh.PanelID=pnl.PanelID  ");
        //    sb.Append(" LEFT JOIN f_covernote cv ON cv.`TransactionID`=lt.`TransactionID` AND cv.`BillNo`=lt.`BillNo`	AND cv.`IsCancel`=0    ");
        //    sb.Append(" WHERE DATE(lt.Date)>='" + Util.GetDateTime(ucFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' AND DATE(lt.Date) <='" + Util.GetDateTime(ucToDate.Text.Trim()).ToString("yyyy-MM-dd") + "' AND lt.NetAmount > lt.Adjustment  AND lt.IsCancel=0  ");
        //    sb.Append(" AND pmh.PanelID='" + ddlPanelCompany.SelectedItem.Value + "'  ");
        //    sb.Append(" AND  pmh.Type<> 'IPD' AND pmh.CentreID='" + Session["CentreID"].ToString() + "' AND lt.`PatientID`='" + txtMRNo.Text.Trim() + "' AND cv.`BillNo` IS NULL order by lt.BillNo,ltd.ItemName ");



        //    DataTable dt = StockReports.GetDataTable(sb.ToString());
        //    if (dt != null && dt.Rows.Count > 0)
        //    {
        //        ViewState["DateFrom"] = Util.GetDateTime(ucFromDate.Text.Trim()).ToString("yyyy-MM-dd");
        //        ViewState["DateTo"] = Util.GetDateTime(ucToDate.Text.Trim()).ToString("yyyy-MM-dd");
        //        btnSave.Visible = true;
        //        divShow.Visible = true;
        //        divPatientDetail.Visible = false;
        //        grdPatientList.DataSource = null;
        //        grdPatientList.DataBind();
        //        lblMsg.Text = dt.Rows.Count + " Records Found.";
        //        DataRow drNew;
        //        decimal Total = 0;
        //        string NewBillNo = string.Empty, OldBillNo = string.Empty;

        //        DataTable dtItems = GetTable();
        //        OldBillNo = dt.Rows[0]["BillNo"].ToString();
        //        for (int i = 0; i < dt.Rows.Count; i++)
        //        {
        //            drNew = dtItems.NewRow();
        //            NewBillNo = dt.Rows[i]["BillNo"].ToString();

        //            if (i == 0)
        //            {
        //                drNew["PatientID"] = dt.Rows[i]["PatientID"].ToString();
        //                drNew["PatientName"] = dt.Rows[i]["PatientName"].ToString();
        //                drNew["Company"] = dt.Rows[i]["Company"].ToString();
        //                drNew["PanelID"] = Util.GetInt(dt.Rows[i]["PanelID"].ToString());
        //                drNew["PolicyNo"] = dt.Rows[i]["PolicyNo"].ToString();
        //                drNew["CardNo"] = dt.Rows[i]["CardNo"].ToString();
        //                drNew["CardHolderName"] = dt.Rows[i]["CardHolderName"].ToString();
        //                drNew["ReferralNo"] = dt.Rows[i]["ReferralNo"].ToString();
        //                drNew["ReferralDate"] = dt.Rows[i]["ReferralDate"].ToString();
        //                drNew["ClaimID"] = dt.Rows[i]["ClaimID"].ToString();
        //                drNew["BillDate"] = dt.Rows[i]["BillDate"].ToString();
        //                drNew["BillNo"] = dt.Rows[i]["BillNo"].ToString();
        //                drNew["Description"] = dt.Rows[i]["Description"].ToString();
        //                drNew["ItemCode"] = dt.Rows[i]["ItemCode"].ToString();
        //                drNew["Amount"] = Util.GetDecimal(dt.Rows[i]["Amount"].ToString());
        //                drNew["LedgerTransactionNo"] = dt.Rows[i]["LedgerTransactionNo"].ToString();
        //                drNew["TransactionID"] = dt.Rows[i]["TransactionID"].ToString();
        //                drNew["GrossAmount"] = Util.GetDecimal(dt.Rows[i]["GrossAmount"].ToString());
        //                drNew["NetAmount"] = Util.GetDecimal(dt.Rows[i]["NetAmount"].ToString());
        //                drNew["discAmt"] = Util.GetDecimal(dt.Rows[i]["discAmt"].ToString());
        //                drNew["PaidAmt"] = Util.GetDecimal(dt.Rows[i]["PaidAmt"].ToString());
        //                drNew["IsCheck"] = "true";
        //                Total = Total + Util.GetDecimal(dt.Rows[i]["Amount"].ToString());
        //            }
        //            else
        //            {
        //                if (OldBillNo != NewBillNo)
        //                {
        //                    drNew["BillDate"] = dt.Rows[i]["BillDate"].ToString();
        //                    drNew["BillNo"] = dt.Rows[i]["BillNo"].ToString();
        //                    OldBillNo = NewBillNo;
        //                    drNew["IsCheck"] = "true";
        //                }
        //                else
        //                {
        //                    drNew["IsCheck"] = "false";
        //                }

        //                drNew["Description"] = dt.Rows[i]["Description"].ToString();
        //                drNew["ItemCode"] = dt.Rows[i]["ItemCode"].ToString();
        //                drNew["Amount"] = Util.GetDecimal(dt.Rows[i]["Amount"].ToString());
        //                drNew["LedgerTransactionNo"] = dt.Rows[i]["LedgerTransactionNo"].ToString();
        //                drNew["TransactionID"] = dt.Rows[i]["TransactionID"].ToString();
        //                drNew["GrossAmount"] = Util.GetDecimal(dt.Rows[i]["GrossAmount"].ToString());
        //                drNew["NetAmount"] = Util.GetDecimal(dt.Rows[i]["NetAmount"].ToString());
        //                drNew["discAmt"] = Util.GetDecimal(dt.Rows[i]["discAmt"].ToString());
        //                drNew["PaidAmt"] = Util.GetDecimal(dt.Rows[i]["PaidAmt"].ToString());
        //                Total = Total + Util.GetDecimal(dt.Rows[i]["Amount"].ToString());

        //            }
        //            dtItems.Rows.Add(drNew);

        //        }
        //        dtItems.AcceptChanges();
        //        if (dtItems.Rows.Count > 0)
        //        {

        //            lblTotalAmount.Text = "Total Net Amount : Rs. " + Util.GetString(Total);
        //            gvItems.DataSource = dtItems;
        //            gvItems.DataBind();
        //        }
        //    }
        //    else
        //    {
        //        string check = StockReports.ExecuteScalar("SELECT IFNULL(CONCAT('Cover Note Alreadly Generated Up To : ',DATE_FORMAT(MAX(`CoverNoteToDate`),'%d-%b-%y')),'') FROM f_covernote WHERE PatientID='" + txtMRNo.Text.Trim() + "' AND TYPE='opd'");
        //        if (check != "")
        //            lblMsg.Text = check;
        //        else
        //            lblMsg.Text = "No Record Found..";

        //        btnSave.Visible = false;
        //        divShow.Visible = false;
        //        lblTotalAmount.Text = "";

        //        }
        //    }
        //    else
        //    {
        //sb.Clear();

        //if (rblType.SelectedValue == "OPD")
        //{
        //    sb.Append(" SELECT pm.PatientID,CONCAT(pm.Title,' ',pm.PName)PatientName,pnl.Company_Name AS Company,pnl.PanelID, ");
        //    sb.Append(" pmh.PolicyNo,pmh.CardNo,pmh.`CardHolderName`,pmh.ReferralNo,DATE_FORMAT(pmh.ReferralDate,'%d-%b-%Y')ReferralDate,pmh.ClaimID,CONCAT(pm.PatientID,'#',pnl.PanelID,'#',REPLACE(pmh.`TransactionID`,'ISHHI',''))PatientDetail, ");
        //    sb.Append(" '' IPD_NO,IFNULL(cv.`CoverNoteNo` ,'')CoverNote ");
        //    sb.Append(" FROM f_ledgertransaction lt   ");
        //    sb.Append(" INNER JOIN patient_medical_history pmh ON lt.TransactionID=pmh.TransactionID  ");
        //    sb.Append(" INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID     ");
        //    sb.Append(" INNER JOIN f_panel_master pnl ON pmh.PanelID=pnl.PanelID   ");
        //    sb.Append(" LEFT JOIN f_covernote cv ON cv.`TransactionID`=lt.`TransactionID` AND cv.`BillNo`=lt.`BillNo`	AND cv.`IsCancel`=0   ");
        //    sb.Append(" WHERE DATE(lt.Date)>='" + Util.GetDateTime(ucFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' AND DATE(lt.Date) <='" + Util.GetDateTime(ucToDate.Text.Trim()).ToString("yyyy-MM-dd") + "' AND lt.NetAmount > lt.Adjustment  AND lt.IsCancel=0  ");
        //    sb.Append(" AND  pmh.Type<> 'IPD'  AND pmh.PanelID='" + ddlPanelCompany.SelectedItem.Value + "' AND pmh.CentreID='" + Session["CentreID"].ToString() + "' ");

        //    if (txtMRNo.Text.Trim() != string.Empty)
        //        sb.Append("     AND lt.`PatientID`='" + txtMRNo.Text.Trim() + "' ");

        //    sb.Append(" GROUP BY pmh.PatientID,pmh.PanelID ORDER BY pm.PName ");
        //}
        //else if (rblType.SelectedValue == "IPD")
        //{
        //    sb.Append(" SELECT * FROM (   ");
        //    sb.Append("     SELECT IFNULL(adj.`DiscountOnBill`,0)DiscountOnBill,pm.PatientID,CONCAT(pm.Title,' ',pm.PName)PatientName,pnl.Company_Name AS Company,pnl.PanelID, ");
        //    sb.Append("     pmh.PolicyNo,pmh.CardNo,pmh.`CardHolderName`,pmh.ReferralNo,DATE_FORMAT(pmh.ReferralDate,'%d-%b-%Y')ReferralDate,pmh.ClaimID,CONCAT(pm.PatientID,'#',pnl.PanelID,'#',REPLACE(pmh.`TransactionID`,'ISHHI',''))PatientDetail, ");
        //    sb.Append("     REPLACE(pmh.`TransactionID`,'ISHHI','')IPD_NO,IFNULL(cv.`CoverNoteNo` ,'')CoverNote, ");
        //    sb.Append("     IFNULL((SELECT SUM(Rate*Quantity) FROM f_ledgertnxdetail WHERE IsVerified=1 AND TransactionID=adj.TransactionID),0)BillAmt, ");
        //    sb.Append("     (SELECT IFNULL(SUM(AmountPaid),0) FROM f_reciept rec WHERE rec.`TransactionID`=adj.TransactionID)RcvAmt ");
        //    sb.Append("     FROM f_ipdadjustment adj ");
        //    sb.Append("     INNER JOIN patient_medical_history pmh ON adj.TransactionID=pmh.TransactionID ");
        //    sb.Append("     INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID       ");
        //    sb.Append("     INNER JOIN f_panel_master pnl ON pmh.PanelID=pnl.PanelID     ");
        //    sb.Append("     LEFT JOIN f_covernote cv ON cv.`TransactionID`=adj.`TransactionID` AND cv.`BillNo`=adj.`BillNo` AND cv.`IsCancel`=0  AND adj.`BillNo`<>''   ");
        //    sb.Append("     WHERE DATE(adj.`BillDate`)>='" + Util.GetDateTime(ucFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' AND DATE(adj.BillDate) <='" + Util.GetDateTime(ucToDate.Text.Trim()).ToString("yyyy-MM-dd") + "' ");                    
        //    sb.Append("     AND  pmh.Type='IPD'  AND pmh.PanelID='" + ddlPanelCompany.SelectedItem.Value + "' AND pmh.CentreID='" + Session["CentreID"].ToString() + "' ");

        //    if (txtMRNo.Text.Trim() != string.Empty)
        //        sb.Append("     AND adj.`PatientID`='" + txtMRNo.Text.Trim() + "' ");

        //    sb.Append("     GROUP BY pmh.TransactionID,pmh.PanelID ORDER BY pm.PName ");
        //    sb.Append(" )t WHERE  (BillAmt-DiscountOnBill-RcvAmt)>0 ");
        //}


        if (ddlPanelCompany.SelectedItem.Value == "--No Panel Found--")
        {
            lblMsg.Text = "Please Select Panel";
            return;
        }
        sb.Append(" CALL `CoverNotePatientSearch`('" + Util.GetDateTime(ucFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "', '" + Util.GetDateTime(ucToDate.Text.Trim()).ToString("yyyy-MM-dd") + "', '" + rblType.SelectedValue + "', '" + txtMRNo.Text.Trim() + "'," + ddlPanelCompany.SelectedItem.Value + "," + Session["CentreID"].ToString() + ") ");
        DataTable dtPatientList = StockReports.GetDataTable(sb.ToString());
        if (dtPatientList.Rows.Count > 0 && dtPatientList != null)
        {

            divPatientDetail.Visible = true;
            grdPatientList.DataSource = dtPatientList;
            grdPatientList.DataBind();
        }
        else
        {
            divPatientDetail.Visible = false;
            lblMsg.Text = "No Record Found..";
        }
      //  txtMRNo.Text = "";
        btnSave.Visible = false;
        divShow.Visible = false;
        gvItems.DataSource = null;
        gvItems.DataBind();
        lblTotalAmount.Text = "";
        // }

    }

    private void BindCoverNoteDetail(string FromDate, string ToDate, string PanelID, string PatientID, string IPDNO, string Type)
    {

        StringBuilder sb = new StringBuilder();
        //if (Type == "IPD")
        //{
        //    sb.Clear();
        //    sb.Append(" SELECT pm.PatientID,CONCAT(pm.Title,' ',pm.PName)PatientName,pnl.Company_Name AS Company,pnl.PanelID,pmh.PolicyNo,pmh.CardNo,pmh.`CardHolderName`,");
        //    sb.Append("  pmh.ReferralNo,DATE_FORMAT(pmh.ReferralDate,'%d-%b-%Y')ReferralDate,pmh.ClaimID,DATE_FORMAT(adj.BillDate,'%d-%b-%Y')BillDate,adj.BillNo,'' Description,");
        //    sb.Append(" '' LedgerTransactionNo,adj.TransactionID,(SELECT GetBalanceDetail(adj.`TransactionID`))NetAmount,IFNULL(cv.`CoverNoteNo`,'')CoverNoteNo,IFNULL(cv.OtherDetails,'')OtherDetails  ");
        //    sb.Append("  FROM f_ipdadjustment adj ");
        //    sb.Append(" INNER JOIN `patient_medical_history` pmh ON adj.`TransactionID`=pmh.`TransactionID`  ");
        //    sb.Append(" INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID  ");
        //    sb.Append(" INNER JOIN f_panel_master pnl ON pmh.PanelID=pnl.PanelID ");
        //    sb.Append("  LEFT JOIN f_covernote cv ON cv.`TransactionID`=pmh.`TransactionID` AND cv.`BillNo`=adj.`BillNo` AND cv.`IsCancel`=0 ");
        //    sb.Append("WHERE DATE(adj.BillDate)>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND DATE(adj.BillDate) <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'    AND pmh.PanelID='" + PanelID + "'  AND  pmh.Type= 'IPD' AND pmh.CentreID='" + Session["CentreID"].ToString() + "' AND pmh.`PatientID`='" + PatientID + "' AND pmh.TransactionID ='ISHHI" + IPDNO + "' ");
        //    DataTable dt = StockReports.GetDataTable(sb.ToString());
        //    if (dt != null && dt.Rows.Count > 0)
        //    {
        //        ViewState["DateFrom"] = Util.GetDateTime(ucFromDate.Text.Trim()).ToString("yyyy-MM-dd");
        //        ViewState["DateTo"] = Util.GetDateTime(ucToDate.Text.Trim()).ToString("yyyy-MM-dd");
        //        btnSave.Visible = true;
        //        divShow.Visible = true;
        //        lblMsg.Text = dt.Rows.Count + " Records Found.";
        //        lblCoverNote.Text = dt.Rows[0]["CoverNoteNo"].ToString();
        //        DataRow drNew;
        //        decimal Total = 0;
        //        string NewBillNo = string.Empty, OldBillNo = string.Empty;

        //        DataTable dtItems = GetTable();
        //        OldBillNo = dt.Rows[0]["BillNo"].ToString();
        //        for (int i = 0; i < dt.Rows.Count; i++)
        //        {
        //            drNew = dtItems.NewRow();
        //            NewBillNo = dt.Rows[i]["BillNo"].ToString();

        //            if (i == 0)
        //            {
        //                drNew["PatientID"] = dt.Rows[i]["PatientID"].ToString();
        //                drNew["PatientName"] = dt.Rows[i]["PatientName"].ToString();
        //                drNew["Company"] = dt.Rows[i]["Company"].ToString();
        //                drNew["PanelID"] = Util.GetInt(dt.Rows[i]["PanelID"].ToString());
        //                drNew["PolicyNo"] = dt.Rows[i]["PolicyNo"].ToString();
        //                drNew["CardNo"] = dt.Rows[i]["CardNo"].ToString();
        //                drNew["CardHolderName"] = dt.Rows[i]["CardHolderName"].ToString();
        //                drNew["ReferralNo"] = dt.Rows[i]["ReferralNo"].ToString();
        //                drNew["ReferralDate"] = dt.Rows[i]["ReferralDate"].ToString();
        //                drNew["ClaimID"] = dt.Rows[i]["ClaimID"].ToString();
        //                drNew["BillDate"] = dt.Rows[i]["BillDate"].ToString();
        //                drNew["BillNo"] = dt.Rows[i]["BillNo"].ToString();
        //                drNew["Description"] = "";
        //                drNew["ItemCode"] = "";
        //                drNew["Amount"] = Util.GetDecimal(dt.Rows[i]["NetAmount"].ToString().Split('#')[2]);
        //                drNew["LedgerTransactionNo"] = "";
        //                drNew["TransactionID"] = dt.Rows[i]["TransactionID"].ToString();
        //                drNew["GrossAmount"] = Util.GetDecimal(dt.Rows[i]["NetAmount"].ToString().Split('#')[4]);
        //                drNew["NetAmount"] = Util.GetDecimal(Util.GetDecimal(dt.Rows[i]["NetAmount"].ToString().Split('#')[0]) - Util.GetDecimal(dt.Rows[i]["NetAmount"].ToString().Split('#')[1]));
        //                drNew["discAmt"] = Util.GetDecimal(dt.Rows[i]["NetAmount"].ToString().Split('#')[5]);
        //                drNew["PaidAmt"] = Util.GetDecimal(dt.Rows[i]["NetAmount"].ToString().Split('#')[1]);
        //                drNew["IsCheck"] = "true";
        //                drNew["OtherDetails"] = Util.GetString(dt.Rows[i]["OtherDetails"]);
        //                drNew["DiscountOnTotal"] = Util.GetDecimal(dt.Rows[i]["NetAmount"].ToString().Split('#')[5]);
        //                Total = Total + Util.GetDecimal(dt.Rows[i]["NetAmount"].ToString().Split('#')[2]);
        //            }
        //            else
        //            {
        //                if (OldBillNo != NewBillNo)
        //                {
        //                    drNew["BillDate"] = dt.Rows[i]["BillDate"].ToString();
        //                    drNew["BillNo"] = dt.Rows[i]["BillNo"].ToString();
        //                    OldBillNo = NewBillNo;
        //                    drNew["IsCheck"] = "true";
        //                }
        //                else
        //                {
        //                    drNew["IsCheck"] = "false";
        //                }

        //                drNew["Description"] = "";
        //                drNew["ItemCode"] = "";
        //                drNew["Amount"] = Util.GetDecimal(dt.Rows[i]["NetAmount"].ToString().Split('#')[0]);
        //                drNew["LedgerTransactionNo"] = dt.Rows[i]["LedgerTransactionNo"].ToString();
        //                drNew["TransactionID"] = dt.Rows[i]["TransactionID"].ToString();
        //                drNew["GrossAmount"] = Util.GetDecimal(dt.Rows[i]["NetAmount"].ToString().Split('#')[4]);
        //                drNew["NetAmount"] = Util.GetDecimal(Util.GetDecimal(dt.Rows[i]["NetAmount"].ToString().Split('#')[0]) - Util.GetDecimal(dt.Rows[i]["NetAmount"].ToString().Split('#')[1]));
        //                drNew["discAmt"] = Util.GetDecimal(dt.Rows[i]["NetAmount"].ToString().Split('#')[5]);
        //                drNew["PaidAmt"] = Util.GetDecimal(dt.Rows[i]["NetAmount"].ToString().Split('#')[1]);
        //                drNew["DiscountOnTotal"] = Util.GetDecimal(dt.Rows[i]["NetAmount"].ToString().Split('#')[5]);
        //                Total = Total + Util.GetDecimal(dt.Rows[i]["Amount"].ToString());

        //            }
        //            dtItems.Rows.Add(drNew);

        //        }
        //        dtItems.AcceptChanges();
        //        if (dtItems.Rows.Count > 0)
        //        {
        //            lblTotalAmount.Text = "Total Net Amount : Rs. " + Util.GetString(Total);
        //            gvItems.DataSource = dtItems;
        //            gvItems.DataBind();
        //        }
        //    }
        //    else
        //    {
        //        string check = StockReports.ExecuteScalar("SELECT ifnull(CONCAT('Cover Note Alreadly Generated Up To : ',DATE_FORMAT(MAX(`CoverNoteToDate`),'%d-%b-%y')),'') FROM f_covernote WHERE PatientID='" + txtMRNo.Text.Trim() + "' AND TYPE='Ipd'");
        //        if (check != "")
        //            lblMsg.Text = check;
        //        else
        //            lblMsg.Text = "No Record Found..";

        //        btnSave.Visible = false;
        //        divShow.Visible = false;
        //        lblTotalAmount.Text = "";

        //    }
        //}
        //  else
        //  {
        //sb.Append(" SELECT pm.PatientID,CONCAT(pm.Title,' ',pm.PName)PatientName,pnl.Company_Name AS Company,pnl.PanelID,pmh.PolicyNo,pmh.CardNo,pmh.`CardHolderName`,pmh.ReferralNo,DATE_FORMAT(pmh.ReferralDate,'%d-%b-%Y')ReferralDate,pmh.ClaimID,DATE_FORMAT(lt.Date,'%d-%b-%Y')BillDate,lt.BillNo,ltd.`ItemName` Description,ltd.`rateItemCode` AS ItemCode,ltd.Amount,lt.LedgerTransactionNo,lt.TransactionID,lt.`NetAmount`,ltd.discAmt,lt.Adjustment AS PaidAmt,lt.GrossAmount,lt.`DiscountOnTotal`,IFNULL(cv.`CoverNoteNo` ,'')CoverNoteNo ");
        //sb.Append(" FROM f_ledgertransaction lt  ");
        //sb.Append(" INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo=ltd.LedgerTransactionNo   ");
        //sb.Append(" INNER JOIN patient_medical_history pmh ON lt.TransactionID=pmh.TransactionID   ");
        //sb.Append(" INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID    ");
        //sb.Append(" INNER JOIN f_panel_master pnl ON pmh.PanelID=pnl.PanelID  ");
        //sb.Append(" LEFT JOIN f_covernote cv ON cv.`TransactionID`=lt.`TransactionID` AND cv.`BillNo`=lt.`BillNo`	AND cv.`IsCancel`=0    ");
        //sb.Append(" WHERE DATE(lt.Date)>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND DATE(lt.Date) <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' AND lt.NetAmount > lt.Adjustment  AND lt.IsCancel=0  ");
        //sb.Append(" AND pmh.PanelID='" + PanelID + "'  ");
        //sb.Append(" AND  pmh.Type<> 'IPD' AND pmh.CentreID='" + Session["CentreID"].ToString() + "' AND lt.`PatientID`='" + PatientID + "'  order by lt.BillNo,ltd.ItemName ");//AND cv.`BillNo` IS NULL

        sb.Clear();
        sb.Append(" CALL `BindCoverNoteDetail`('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "', '" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "', '" + Type + "', '" + PatientID + "'," + PanelID + "," + Session["CentreID"].ToString() + ",'" + IPDNO + "') ");


        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            ViewState["DateFrom"] = Util.GetDateTime(ucFromDate.Text.Trim()).ToString("yyyy-MM-dd");
            ViewState["DateTo"] = Util.GetDateTime(ucToDate.Text.Trim()).ToString("yyyy-MM-dd");
            lblCoverNote.Text = dt.Rows[0]["CoverNoteNo"].ToString();
            btnSave.Visible = true;
            divShow.Visible = true;
            lblMsg.Text = dt.Rows.Count + " Records Found.";
            DataRow drNew;
            decimal Total = 0;
            decimal TotalPanelPayble = 0;
            string NewBillNo = string.Empty, OldBillNo = string.Empty;

            DataTable dtItems = GetTable();
            OldBillNo = dt.Rows[0]["BillNo"].ToString();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                drNew = dtItems.NewRow();
                NewBillNo = dt.Rows[i]["BillNo"].ToString();

                if (i == 0)
                {
                    drNew["PatientID"] = dt.Rows[i]["PatientID"].ToString();
                    drNew["PatientName"] = dt.Rows[i]["PatientName"].ToString();
                    drNew["Company"] = dt.Rows[i]["Company"].ToString();
                    drNew["PanelID"] = Util.GetInt(dt.Rows[i]["PanelID"].ToString());
                    drNew["PolicyNo"] = dt.Rows[i]["PolicyNo"].ToString();
                    drNew["CardNo"] = dt.Rows[i]["CardNo"].ToString();
                    drNew["CardHolderName"] = dt.Rows[i]["CardHolderName"].ToString();
                    drNew["OtherDetails"] = dt.Rows[i]["OtherDetails"].ToString();
                    drNew["BillDate"] = dt.Rows[i]["BillDate"].ToString();
                    drNew["BillNo"] = dt.Rows[i]["BillNo"].ToString();
                    drNew["Description"] = dt.Rows[i]["Description"].ToString();
                    drNew["ItemCode"] = dt.Rows[i]["ItemCode"].ToString();
                    drNew["Amount"] = Util.GetDecimal(dt.Rows[i]["Amount"].ToString());
                    drNew["LedgerTransactionNo"] = dt.Rows[i]["LedgerTransactionNo"].ToString();
                    drNew["TransactionID"] = dt.Rows[i]["TransactionID"].ToString();
                    drNew["GrossAmount"] = Util.GetDecimal(dt.Rows[i]["GrossAmount"].ToString());
                    drNew["NetAmount"] = Util.GetDecimal(dt.Rows[i]["NetAmount"].ToString());
                    drNew["discAmt"] = Util.GetDecimal(dt.Rows[i]["DiscountOnTotal"].ToString());
                    drNew["PaidAmt"] = Util.GetDecimal(dt.Rows[i]["PaidAmt"].ToString());
                    drNew["DiscountOnTotal"] = Util.GetDecimal(dt.Rows[i]["DiscountOnTotal"].ToString());
                    drNew["PanelPayable"] = Util.GetDecimal(dt.Rows[i]["PanelPayable"].ToString());

                    drNew["IsCheck"] = "true";

                    drNew["CoverNoteNo"] = dt.Rows[i]["CoverNoteNo"].ToString();
                    drNew["PType"] = dt.Rows[i]["PType"].ToString();
                    drNew["CoverNoteID"] = dt.Rows[i]["CoverNoteID"].ToString();
                    

                    Total = Total + Util.GetDecimal(dt.Rows[i]["Amount"].ToString());
                    TotalPanelPayble = TotalPanelPayble + Util.GetDecimal(dt.Rows[i]["PanelPayable"].ToString());

                }
                else
                {
                    if (OldBillNo != NewBillNo)
                    {
                        drNew["BillDate"] = dt.Rows[i]["BillDate"].ToString();
                        drNew["BillNo"] = dt.Rows[i]["BillNo"].ToString();
                        OldBillNo = NewBillNo;
                        drNew["IsCheck"] = "true";

                     //   drNew["PanelPayable"] = Util.GetDecimal(dt.Rows[i]["PanelPayable"].ToString());
                        TotalPanelPayble = TotalPanelPayble + Util.GetDecimal(dt.Rows[i]["PanelPayable"].ToString());
                    }
                    else
                    {
                        drNew["IsCheck"] = "false";
                    }


                    drNew["PanelID"] = Util.GetInt(dt.Rows[i]["PanelID"].ToString());
                    drNew["PolicyNo"] = dt.Rows[i]["PolicyNo"].ToString();
                    drNew["CardNo"] = dt.Rows[i]["CardNo"].ToString();
                    drNew["CardHolderName"] = dt.Rows[i]["CardHolderName"].ToString();
                    drNew["OtherDetails"] = dt.Rows[i]["OtherDetails"].ToString();
                    drNew["Description"] = dt.Rows[i]["Description"].ToString();
                    drNew["ItemCode"] = dt.Rows[i]["ItemCode"].ToString();
                    drNew["Amount"] = Util.GetDecimal(dt.Rows[i]["Amount"].ToString());
                    drNew["LedgerTransactionNo"] = dt.Rows[i]["LedgerTransactionNo"].ToString();
                    drNew["TransactionID"] = dt.Rows[i]["TransactionID"].ToString();
                    drNew["GrossAmount"] = Util.GetDecimal(dt.Rows[i]["GrossAmount"].ToString());
                    drNew["NetAmount"] = Util.GetDecimal(dt.Rows[i]["NetAmount"].ToString());
                    drNew["discAmt"] = Util.GetDecimal(dt.Rows[i]["DiscountOnTotal"].ToString());
                    drNew["PaidAmt"] = Util.GetDecimal(dt.Rows[i]["PaidAmt"].ToString());
                    drNew["DiscountOnTotal"] = Util.GetDecimal(dt.Rows[i]["DiscountOnTotal"].ToString());
                    drNew["PanelPayable"] = Util.GetDecimal(dt.Rows[i]["PanelPayable"].ToString());
                    drNew["CoverNoteNo"] = dt.Rows[i]["CoverNoteNo"].ToString();
                    drNew["PType"] = dt.Rows[i]["PType"].ToString();
                    drNew["CoverNoteID"] = dt.Rows[i]["CoverNoteID"].ToString();
                    Total = Total + Util.GetDecimal(dt.Rows[i]["Amount"].ToString());


                }
                dtItems.Rows.Add(drNew);

            }
            dtItems.AcceptChanges();
            if (dtItems.Rows.Count > 0)
            {
                lblTotalAmount.Text = "Total Net Amount : Rs. " + Util.GetString(Math.Round(Total,4))+ " ,  Total Panel Payable Amount : Rs. "+ Util.GetString(Math.Round(TotalPanelPayble,4));
                gvItems.DataSource = dtItems;
                gvItems.DataBind();
            }
        }
        else
        {
            string check = StockReports.ExecuteScalar("SELECT ifnull(CONCAT('Cover Note Alreadly Generated Up To : ',DATE_FORMAT(MAX(`CoverNoteToDate`),'%d-%b-%y')),'') FROM f_covernote WHERE PatientID='" + txtMRNo.Text.Trim() + "' AND TYPE='opd'");
            if (check != "")
                lblMsg.Text = check;
            else
                lblMsg.Text = "No Record Found..";

            btnSave.Visible = false;
            divShow.Visible = false;
            lblTotalAmount.Text = "";

        }
        // }
    }
    private DataTable GetTable()
    {
        DataTable dtData = new DataTable();
        dtData = new DataTable();
        dtData.Columns.Add("PatientID");
        dtData.Columns.Add("PatientName");
        dtData.Columns.Add("Company");
        dtData.Columns.Add("PanelID", typeof(int));
        dtData.Columns.Add("PolicyNo");
        dtData.Columns.Add("CardNo");
        dtData.Columns.Add("CardHolderName");
        dtData.Columns.Add("BillDate");
        dtData.Columns.Add("BillNo");
        dtData.Columns.Add("Description");
        dtData.Columns.Add("ItemCode");
        dtData.Columns.Add("Amount", typeof(decimal));
        dtData.Columns.Add("LedgerTransactionNo", typeof(int));
        dtData.Columns.Add("TransactionID");
        dtData.Columns.Add("GrossAmount", typeof(decimal));
        dtData.Columns.Add("NetAmount", typeof(decimal));
        dtData.Columns.Add("discAmt", typeof(decimal));
        dtData.Columns.Add("PaidAmt", typeof(decimal));
        dtData.Columns.Add("IsCheck");
        dtData.Columns.Add("OtherDetails");
        dtData.Columns.Add("ReceivedAmt");
        dtData.Columns.Add("DiscountOnTotal", typeof(decimal));
        dtData.Columns.Add("PanelPayable", typeof(decimal));

        dtData.Columns.Add("CoverNoteNo");
        dtData.Columns.Add("PType");
        dtData.Columns.Add("CoverNoteID", typeof(int));
        
        return dtData;
    }


    protected void btnSave_Click(object sender, EventArgs e)
    {

        string CoverNoteNo = string.Empty;
        decimal DueAmount = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            lblMsg.Text = "";

            if (lblCoverNote.Text == "" || lblCoverNote.Text == "Not-Generated")
            {
                CoverNoteNo = getCoverNoteNo(Tranx, Util.GetInt(Session["CentreID"].ToString()), con);
                if (CoverNoteNo == "")
                {
                    Tranx.Dispose();
                    con.Close();
                    con.Dispose();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Error...');", true);
                    lblMsg.Text = "Error...";
                    return;
                }

                for (int a = 0; a < gvItems.Rows.Count; a++)
                {
                    StringBuilder sb = new StringBuilder();
                    if (((CheckBox)gvItems.Rows[a].FindControl("chkSelect")).Checked)
                    {
                        
                        DueAmount = Util.GetDecimal(((Label)gvItems.Rows[a].FindControl("lblPanelPayable")).Text) - Util.GetDecimal(((Label)gvItems.Rows[a].FindControl("lblPaidAmt")).Text);

                        sb.Append(" INSERT INTO f_covernote(LedgerTransactionNo,TransactionID,PatientName,PanelID,PanelName,PatientID,BillDate,BillNo,GrossAmt,DiscAmt, ");
                        sb.Append(" NetAmount,CardNo,CardHolderName,CentreID,CreatedDateTime,CreatedBy,CoverNoteFromDate,CoverNoteToDate,IPAddress,DeptLedgerNo,CoverNoteNo,TYPE,OtherDetails,BalanceAmt,PageURL,PanelPayable,PaidAmount,PolicyNo) ");
                        sb.Append(" VALUES('" + ((Label)gvItems.Rows[a].FindControl("lblLedgerTransactionNo")).Text + "','" + ((Label)gvItems.Rows[a].FindControl("lblTransactionID")).Text + "','" + ((Label)gvItems.Rows[0].FindControl("lblPatientName")).Text + "','" + Util.GetInt(((Label)gvItems.Rows[0].FindControl("lblPanelID")).Text) + "','" + ((Label)gvItems.Rows[0].FindControl("lblCompany")).Text + "','" + ((Label)gvItems.Rows[0].FindControl("lblPatientID")).Text + "','" + Util.GetDateTime(((Label)gvItems.Rows[a].FindControl("lblBillDate")).Text).ToString("yyyy-MM-dd") + "','" + ((Label)gvItems.Rows[a].FindControl("lblBillNo")).Text + "','" + Util.GetDecimal(((Label)gvItems.Rows[a].FindControl("lblGrossAmt")).Text) + "', ");
                        sb.Append("'" + Util.GetDecimal(((Label)gvItems.Rows[a].FindControl("lblDiscOnTotal")).Text) + "','" + Util.GetDecimal(((Label)gvItems.Rows[a].FindControl("lblNetAmount")).Text) + "','" + ((TextBox)gvItems.Rows[0].FindControl("txtCardno")).Text + "','" + ((TextBox)gvItems.Rows[0].FindControl("txtCardHolderName")).Text + "', ");
                        sb.Append(" '" + Session["CentreID"].ToString() + "','" + Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd HH:mm:ss") + "','" + Session["ID"].ToString() + "','" + ViewState["DateFrom"].ToString() + "','" + ViewState["DateTo"].ToString() + "','" + All_LoadData.IpAddress() + "','" + Session["DeptLedgerNo"].ToString() + "','" + CoverNoteNo + "'");
                        sb.Append(",'" + ((Label)gvItems.Rows[a].FindControl("lblBillPType")).Text + "','" + ((TextBox)gvItems.Rows[a].FindControl("txtOtherDetails")).Text.Trim() + "','" + DueAmount + "' ,'" + All_LoadData.getCurrentPageName() + "','" + Util.GetDecimal(((Label)gvItems.Rows[a].FindControl("lblPanelPayable")).Text) + "','" + Util.GetDecimal(((Label)gvItems.Rows[a].FindControl("lblPaidAmt")).Text) + "','" + ((TextBox)gvItems.Rows[a].FindControl("txtPolicy")).Text + "' ) ");

                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());

                    }

                }
            }

            else
            {
                for (int i = 0; i < gvItems.Rows.Count; i++)
                {
                    string CardNO = ((TextBox)gvItems.Rows[i].FindControl("txtCardno")).Text;
                    string CardHolderName = ((TextBox)gvItems.Rows[i].FindControl("txtCardHolderName")).Text;
                    string PolicyNo = ((TextBox)gvItems.Rows[i].FindControl("txtPolicy")).Text;
                    string IPDNo = ((Label)gvItems.Rows[i].FindControl("lblTransactionID")).Text;
                    string OtherDetails = ((TextBox)gvItems.Rows[i].FindControl("txtOtherDetails")).Text;
                    int CoverNoteID = Util.GetInt(((Label)gvItems.Rows[i].FindControl("lblCoverNoteID")).Text);

                    


                    //string BalanceAmt = lblTotalAmount.Text.Replace("Total Net Amount : Rs. ","");//((Label)gvItems.Rows[i].FindControl("lblNetAmount")).Text;
                    //decimal NetAmount = Util.GetDecimal(((Label)gvItems.Rows[i].FindControl("lblNetAmount")).Text);
                  
                     DueAmount = Util.GetDecimal(((Label)gvItems.Rows[i].FindControl("lblPanelPayable")).Text) - Util.GetDecimal(((Label)gvItems.Rows[i].FindControl("lblPaidAmt")).Text);

                    CoverNoteNo = lblCoverNote.Text.Trim();

                    string CoverNoteBillWise = ((Label)gvItems.Rows[i].FindControl("lblCoverNoteBillWise")).Text;

                    if (((CheckBox)gvItems.Rows[i].FindControl("chkSelect")).Checked)
                    {
                       

                        //string PanelPatient = " UPDATE patient_medical_history SET PolicyNo='" + PolicyNo + "',CardHolderName='" + CardHolderName + "',CardNo='" + CardNO + "' where TransactionID='" + IPDNo + "'";
                        //int Result = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, PanelPatient);
                        //if (Result == 0)
                        //{
                        //    Tranx.Rollback();
                        //    Tranx.Dispose();
                        //    con.Close();
                        //    con.Dispose();
                        //}

                        if (CoverNoteBillWise != "Not-Generated")
                        {
                            string CoverNoteResult = " UPDATE f_covernote SET  CardNo='" + CardNO + "', CardHolderName='" + CardHolderName + "' , OtherDetails='" + OtherDetails + "',BalanceAmt='" + DueAmount + "',NetAmount='" + Util.GetDecimal(((Label)gvItems.Rows[i].FindControl("lblNetAmount")).Text) + "',PanelPayable='" + Util.GetDecimal(((Label)gvItems.Rows[i].FindControl("lblPanelPayable")).Text) + "',PaidAmount='" + Util.GetDecimal(((Label)gvItems.Rows[i].FindControl("lblPaidAmt")).Text) + "', PolicyNo= '"+ PolicyNo +"' WHERE CoverNoteID= '" + CoverNoteID + "'";
                            int CovResult = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, CoverNoteResult);
                            if (CovResult == 0)
                            {
                                Tranx.Rollback();
                                Tranx.Dispose();
                                con.Close();
                                con.Dispose();
                            }
                        }
                        else
                        {

                            StringBuilder sb = new StringBuilder();
                            sb.Append(" INSERT INTO f_covernote(LedgerTransactionNo,TransactionID,PatientName,PanelID,PanelName,PatientID,BillDate,BillNo,GrossAmt,DiscAmt, ");
                            sb.Append(" NetAmount,CardNo,CardHolderName,CentreID,CreatedDateTime,CreatedBy,CoverNoteFromDate,CoverNoteToDate,IPAddress,DeptLedgerNo,CoverNoteNo,TYPE,OtherDetails,BalanceAmt,PageURL,PanelPayable,PaidAmount,PolicyNo) ");
                            sb.Append(" VALUES('" + ((Label)gvItems.Rows[i].FindControl("lblLedgerTransactionNo")).Text + "','" + ((Label)gvItems.Rows[i].FindControl("lblTransactionID")).Text + "','" + ((Label)gvItems.Rows[0].FindControl("lblPatientName")).Text + "','" + Util.GetInt(((Label)gvItems.Rows[0].FindControl("lblPanelID")).Text) + "','" + ((Label)gvItems.Rows[0].FindControl("lblCompany")).Text + "','" + ((Label)gvItems.Rows[0].FindControl("lblPatientID")).Text + "','" + Util.GetDateTime(((Label)gvItems.Rows[i].FindControl("lblBillDate")).Text).ToString("yyyy-MM-dd") + "','" + ((Label)gvItems.Rows[i].FindControl("lblBillNo")).Text + "','" + Util.GetDecimal(((Label)gvItems.Rows[i].FindControl("lblGrossAmt")).Text) + "', ");
                            sb.Append("'" + Util.GetDecimal(((Label)gvItems.Rows[i].FindControl("lblDiscOnTotal")).Text) + "','" + Util.GetDecimal(((Label)gvItems.Rows[i].FindControl("lblNetAmount")).Text) + "','" + ((TextBox)gvItems.Rows[0].FindControl("txtCardno")).Text + "','" + ((TextBox)gvItems.Rows[0].FindControl("txtCardHolderName")).Text + "', ");
                            sb.Append(" '" + Session["CentreID"].ToString() + "','" + Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd HH:mm:ss") + "','" + Session["ID"].ToString() + "','" + ViewState["DateFrom"].ToString() + "','" + ViewState["DateTo"].ToString() + "','" + All_LoadData.IpAddress() + "','" + Session["DeptLedgerNo"].ToString() + "','" + CoverNoteNo + "'");
                            sb.Append(",'" + ((Label)gvItems.Rows[i].FindControl("lblBillPType")).Text + "','" + ((TextBox)gvItems.Rows[i].FindControl("txtOtherDetails")).Text.Trim() + "','" + DueAmount + "' ,'" + All_LoadData.getCurrentPageName() + "','" + Util.GetDecimal(((Label)gvItems.Rows[i].FindControl("lblPanelPayable")).Text) + "','" + Util.GetDecimal(((Label)gvItems.Rows[i].FindControl("lblPaidAmt")).Text) + "','"+ PolicyNo +"') ");

                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());
                        }

                    }


                }
            }



            Tranx.Commit();
            txtMRNo.Text = "";
            divShow.Visible = false;
            lblTotalAmount.Text = "";

            if (lblCoverNote.Text == "" || lblCoverNote.Text == "Not-Generated")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Cover Note Generated Successfully.</br> Cover Not No. : <span class=patientInfo >" + CoverNoteNo + "</span>');", true);
                lblMsg.Text = "Cover Note Generated Successfully.</br> Cover Not No. : <span class='patientInfo' >" + CoverNoteNo + "</span>";
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Cover Note Details Updated Successfully..');", true);
                lblMsg.Text = "Cover Note Details Updated Successfully..";
            }
            if (chkIsPrint.Checked)
                PrintData(CoverNoteNo);

            BindCoverNodeData();

        }
        catch (Exception ex)
        {

            Tranx.Rollback();
            lblMsg.Text = ex.Message;
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected string getCoverNoteNo(MySqlTransaction tranx, int CentreID, MySqlConnection con)
    {



        for (int i = 0; i < gvItems.Rows.Count; i++)
        {
            string CardNO = ((TextBox)gvItems.Rows[i].FindControl("txtCardno")).Text;
            string CardHolderName = ((TextBox)gvItems.Rows[i].FindControl("txtCardHolderName")).Text;
            string PolicyNo = ((TextBox)gvItems.Rows[i].FindControl("txtPolicy")).Text;
            string IPDNo = ((Label)gvItems.Rows[i].FindControl("lblTransactionID")).Text;

            string PanelPatient = " UPDATE patient_medical_history SET PolicyNo='" + PolicyNo + "',CardHolderName='" + CardHolderName + "',CardNo='" + CardNO + "' where TransactionID='" + IPDNo + "'";
            int Result = MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, PanelPatient);
            if (Result == 0)
            {
                tranx.Rollback();
                tranx.Dispose();
                con.Close();
                con.Dispose();
                return string.Empty;
            }

        }


        MySqlParameter LedTxnID = new MySqlParameter();
        LedTxnID.ParameterName = "@Bill_No";
        LedTxnID.MySqlDbType = MySqlDbType.VarChar;
        LedTxnID.Size = 50;
        LedTxnID.Direction = ParameterDirection.Output;
        StringBuilder objSQL = new StringBuilder();
        objSQL.Append("f_Generate_Bill_No_CoverNote");
        MySqlCommand cmd;
        cmd = new MySqlCommand(objSQL.ToString(), con, tranx);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.Add(new MySqlParameter("@vCentreID", Util.GetInt(CentreID)));
        cmd.Parameters.Add(LedTxnID);
        return cmd.ExecuteScalar().ToString();


    }

    protected void PrintData(string CoverNoteNo)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT cv.TransactionID,cv.PatientName,cv.PanelID,cv.PanelName,cv.PatientID,date_format(cv.BillDate,'%d-%b-%y')BillDate,cv.BillNo,cv.GrossAmt,cv.DiscAmt, ");
        sb.Append("  cv.NetAmount,cv.CardNo,cv.CardHolderName,cv.CentreID,date_format(cv.CreatedDateTime,'%d-%b-%y')CoverDate,cv.CreatedBy,cv.CoverNoteFromDate,cv.CoverNoteToDate,cv.CoverNoteNo,cv.TYPE,");
        sb.Append("  ltd.`ItemName` Description,ltd.`rateItemCode`,ltd.Amount,ltd.`DiscAmt` DiscAmtItem,(ltd.`Rate`*ltd.`Quantity`)GrossAmtItem,pm.`Relation`,pm.`RelationName`  ");
        sb.Append("  FROM f_covernote cv INNER JOIN patient_master pm ON pm.`PatientID`=cv.`PatientID` INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=cv.LedgerTransactionNo  ");
        sb.Append("  WHERE  cv.`CoverNoteNo`='" + CoverNoteNo + "' AND cv.`IsCancel`=0  ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = StockReports.GetUserName(Convert.ToString(HttpContext.Current.Session["ID"])).Rows[0][0];
            dt.Columns.Add(dc);
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            DataTable dtImg = All_LoadData.CrystalReportLogo();
            ds.Tables.Add(dtImg.Copy());
            ds.Tables[1].TableName = "logo";
            //  ds.WriteXmlSchema("C:\\CoverNoteOPD.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "CoverNoteOPD";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/CommonCrystalReportViewer.aspx');", true);
        }
    }
    protected void grdPatientList_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "AView")
        {
            string PatientDetail = Util.GetString(e.CommandArgument);

            BindCoverNoteDetail(ucFromDate.Text.Trim(), ucToDate.Text.Trim(), PatientDetail.Split('#')[1].ToString(), PatientDetail.Split('#')[0].ToString(), PatientDetail.Split('#')[2].ToString(), PatientDetail.Split('#')[3].ToString());
        }
    }
}