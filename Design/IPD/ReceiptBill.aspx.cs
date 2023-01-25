using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.Script.Serialization;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
public partial class Design_IPD_ReceiptBill : System.Web.UI.Page
{

    #region Events

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Panel1.Visible = false;
            txtTransactionId.Focus();
          //  btnSave.Enabled = false;
            ViewState["LoginType"] = Session["LoginType"].ToString();
            BindHospLedgerAccount();
            txtHash.Text = Util.getHash();
            chkHospLedger.Items.RemoveAt(2);
            chkHospLedger.SelectedIndex = 0;
            
            var IPDNO = Util.GetString(Request.QueryString["TransactionID"]).Trim();
            if (!string.IsNullOrEmpty(IPDNO)) {
                txtTransactionId.Text = StockReports.ExecuteScalar("SELECT TransNo FROM patient_medical_history WHERE transactionID='" + IPDNO + "' ");
                btnView_Click(sender, e);
                GridView1.SelectedIndex = 0;
                GridView1_SelectedIndexChanged(GridView1, e);
            }
            Session["CanRefundAllAmount"] = All_LoadData.GetAuthorization(Util.GetInt(Session["RoleID"].ToString()), Session["ID"].ToString(), "CanRefundAllAmount");
        }
        lblMsg.Text = "";
    }

    protected void btnView_Click(object sender, EventArgs e)
    {
        Panel1.Visible = false;
        GridView1.DataSource = null;
        GridView1.DataBind();
        grdReceipt.DataSource = null;
        grdReceipt.DataBind();
        pnlDetails.Visible = false;
        if (txtPatientID.Text == "" && txtTransactionId.Text == "" && txtPatientName.Text == "")
        {
            lblMsg.Text = "Please Enter any one Search Criteria..";
            return;
        }

        if (txtPatientName.Text.Trim() != "" && txtPatientName.Text.Trim().Length < 3)
        {
            lblMsg.Text = "Please enter atleast three characters to search";
            txtPatientName.Focus();
            return;
        }

        string PatientType = "";

        if (rdbAdmitted.Checked)
        {
            PatientType = "IN";
        }
        else
        {
            PatientType = "OUT";
        }

        string PatientID = "", TransactionID = "" ;

        if (txtPatientID.Text != "")
        {
            PatientID = txtPatientID.Text.Trim();
        }

        if (txtTransactionId.Text != "")
        {
            string IPDNo = StockReports.ExecuteScalar(" SELECT transactionID  FROM patient_medical_history WHERE TransNo = '"+txtTransactionId.Text.Trim()+"' ");
            if (IPDNo == "")
            { lblMsg.Text = "Record Not Found"; return; }
            else
            {
                TransactionID = IPDNo;//"ISHHI" + 
            }
        }

        BindPatientDetails(Util.GetFullPatientID(PatientID), TransactionID, txtPatientName.Text.Trim(), PatientType);

        if (GridView1.Rows.Count > 0)
        {
            GridView1.Focus();
            
        }
        else
        {
            lblMsg.Text = "Record Not Found";
        }
    }

    private void parentClear()
    {
        ViewState["dtPaymentDetail"] = string.Empty;
        //((GridView)PaymentControl.FindControl("grdPaymentMode")).DataSource = null;
        //((GridView)PaymentControl.FindControl("grdPaymentMode")).DataBind();
        //((Label)PaymentControl.FindControl("lblTotalPaidAmount")).Text = "0";
        //((Label)PaymentControl.FindControl("lblBalanceAmount")).Text = "0";
        //((Label)PaymentControl.FindControl("lblRoundVal")).Text = "0";
    }

    protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
    {
        chkHospLedger.SelectedIndex = 0;
        chkHospLedger.Enabled = true;
        chkRefund.Enabled = true;
        // btnSave.Attributes.Add("disabled", "true");
        //  ((Button)PaymentControl.FindControl("btnAdd")).Attributes.Add("disabled", "true");
        //niraj/((TextBox)PaymentControl.FindControl("txtPaidAmount")).Text = "";
        parentClear();
       // btnSave.Enabled = true;
        lblPatientID.Text = GridView1.SelectedRow.Cells[0].Text;
        lblTransactionNo.Text = ((Label)GridView1.SelectedRow.FindControl("lblTransactionID")).Text;//"ISHHI" + 
        lblTransactionNo1.Text = GridView1.SelectedRow.Cells[1].Text;
        lblPatientName.Text = GridView1.SelectedRow.Cells[2].Text;
        lblRoomNo.Text = GridView1.SelectedRow.Cells[4].Text;
        lblPanelComp.Text = GridView1.SelectedRow.Cells[3].Text;
        lblPaddress.Text = ((Label)GridView1.SelectedRow.FindControl("lblAddress")).Text;
        lblPRelation.Text = ((Label)GridView1.SelectedRow.FindControl("lblRelation")).Text;
        lblPRelationName.Text = ((Label)GridView1.SelectedRow.FindControl("lblRelationName")).Text;

        string PatientAdvance = Util.GetString(StockReports.ExecuteScalar("SELECT  round(SUM(oa.AdvanceAmount-oa.BalanceAmt),4) FROM opd_advance oa WHERE oa.IsCancel = 0  AND   oa.PatientID = '" + lblPatientID.Text + "' "));
        lblPatientAdvance.Text = PatientAdvance;
        
        string admitStatus = ((Label)GridView1.SelectedRow.FindControl("lblStatus")).Text.Trim();
        if (admitStatus == "IN")
        {
            rdbAdmitted.Checked = true; rdbDischarged.Checked = false;
            lblPatientAdmissionStatus.Text = "Admitted";
            lblPatientAdmissionStatus.ForeColor = System.Drawing.ColorTranslator.FromHtml("#3CB371");
        }
        if (admitStatus == "OUT")
        {
            rdbDischarged.Checked = true;rdbAdmitted.Checked = false;
            lblPatientAdmissionStatus.Text = "Discharged";
            lblPatientAdmissionStatus.ForeColor = System.Drawing.ColorTranslator.FromHtml("#f89406");
        }

        //shatrughan 07.06.14
        AllQuery AQ = new AllQuery();

        decimal ServiceTaxPer = 0, ServiceTaxAmt = 0, ServiceTaxSurChgAmt = 0, SerTaxSurChgPer = 0, SerTaxBillAmt = 0;
        //lbl
        decimal RoundOff = 0, TotalPaidAmt = 0;
        DataTable dtAdjust = AQ.GetPatientAdjustmentDetails(lblTransactionNo.Text);
        //decimal AmountBilled = Util.GetDecimal(AQ.GetBillAmount(lblTransactionNo.Text, null));
		
		
		     StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CONVERT(SUM(GrossAmount),DECIMAL(16,6)) PaidAmount FROM f_ledgertnxdetail WHERE TransactionID='" + lblTransactionNo.Text + "' AND IsVerified = 1 AND IsPAckage=0 ");

        decimal AmountBilled = Util.GetDecimal(StockReports.ExecuteScalar(sb.ToString()));
		
		
        decimal AmountReceived = Util.GetDecimal(AQ.GetPaidAmount(lblTransactionNo.Text));

        // decimal TotalDisc = Util.GetDecimal(StockReports.ExecuteScalar("Select IFNULL(SUM(TotalDiscAmt) + (SELECT IFNULL(DiscountOnBill,0) from f_ipdadjustment where TransactionID='" + lblTransactionNo.Text.Trim() + "'),0) TotalDisc from f_ledgertnxdetail where TransactionID='" + lblTransactionNo.Text.Trim() + "' and DiscountPercentage > 0  and isverified=1 and ispackage=0"));

        decimal TotalDisc = Util.GetDecimal(StockReports.ExecuteScalar("Select IFNULL(SUM(TotalDiscAmt) + (SELECT IFNULL(DiscountOnBill,0) from patient_medical_history where TransactionID='" + lblTransactionNo.Text.Trim() + "'),0) TotalDisc from f_ledgertnxdetail where TransactionID='" + lblTransactionNo.Text.Trim() + "'  and isverified=1 and ispackage=0"));

        decimal NetAmount = Util.GetDecimal(StockReports.ExecuteScalar("Select SUM(NetItemAmt) from f_ledgertnxdetail where TransactionID='" + lblTransactionNo.Text.Trim() + "'  and isverified=1 and ispackage=0")); //Util.GetDecimal(AmountBilled) - Util.GetDecimal(TotalDisc);
        NetAmount = AmountBilled - TotalDisc;
        //decimal NetAmount = Util.GetDecimal(AmountBilled - AmountReceived);
        decimal DiscountOnItem = 0;
        DiscountOnItem = Util.GetDecimal(StockReports.ExecuteScalar("SELECT Sum(TotalDiscAmt) FROM f_ledgertnxdetail WHERE TransactionID='" + lblTransactionNo.Text + "' AND IsVerified = 1 and IsPackage = 0 "));
        

        decimal TotalBillAmount = TotalPaidAmt;
       //   decimal Total_PanelApprovalAmt = Util.GetDecimal(StockReports.ExecuteScalar("Select round(PanelApprovedAmt,2) from Patient_medical_history where TransactionID='" + lblTransactionNo.Text.Trim() + "'"));
        decimal Total_PanelApprovalAmt = Util.GetDecimal(dtAdjust.Rows[0]["PanelApprovedAmt"]);
        lblPanelApp_Amt.Text = Total_PanelApprovalAmt.ToString();
        lblTotalPaidAmt.Text = Util.GetString(AmountReceived); 
        decimal PanelAmountAllocation = AllLoadData_IPD.GetAllocationAmount(lblTransactionNo.Text.Trim());
        decimal WriteOff = Util.round(Util.GetDecimal(AllLoadData_IPD.getPatientWrieoffAmount(lblTransactionNo.Text.Trim())));
        if (PanelAmountAllocation > 0)
        {
            lblNonPayableAmt.Text = Util.GetString(Util.round(Util.GetDecimal(Util.GetDecimal(NetAmount - (PanelAmountAllocation + WriteOff)) - AmountReceived)));
        }
        else
            lblNonPayableAmt.Text = Util.GetString(Util.round(Util.GetDecimal(NetAmount - (AmountReceived + WriteOff))));

        decimal PaidAmt = Util.GetDecimal(AllLoadData_IPD.getPatientPaidAmount(lblTransactionNo.Text));

        lblPanelPayableAmount.Text = Util.GetString(PanelAmountAllocation);
        lblPanelPaidAmount.Text = Util.GetString(AmountReceived - PaidAmt);
        if (dtAdjust.Rows[0]["BillNo"].ToString().Trim() == string.Empty)
        {
            ServiceTaxAmt = Util.GetDecimal(dtAdjust.Rows[0]["ServiceTaxAmt"]);
            ServiceTaxPer = Util.GetDecimal(dtAdjust.Rows[0]["ServiceTaxPer"]);
            ServiceTaxSurChgAmt = Util.GetDecimal(dtAdjust.Rows[0]["ServiceTaxSurChgAmt"]);
            SerTaxSurChgPer = Util.GetDecimal(dtAdjust.Rows[0]["SerTaxSurChgPer"]);
            SerTaxBillAmt = Util.GetDecimal(dtAdjust.Rows[0]["SerTaxBillAmount"]);
            AmountBilled = Util.GetDecimal((Util.GetDecimal(AmountBilled)) - (Util.GetDecimal(dtAdjust.Rows[0]["DiscountOnBill"].ToString()) + (Util.GetDecimal(DiscountOnItem))));
            NetAmount = Util.GetDecimal(Util.GetDecimal(NetAmount) + Util.GetDecimal(dtAdjust.Rows[0]["ServiceTaxAmt"]) + Util.GetDecimal(dtAdjust.Rows[0]["ServiceTaxSurChgAmt"]));
            lblRoundOff.Text = "0";
            lblTotalBill_Amt.Text = (Util.GetDecimal(Math.Round(AmountBilled, 2, MidpointRounding.AwayFromZero)) + Util.GetDecimal(lblRoundOff.Text)).ToString();

        }
        else
        {

            ServiceTaxPer = Util.GetDecimal(All_LoadData.GovTaxPer());
            SerTaxSurChgPer = 0;
            ServiceTaxAmt = 0;
            ServiceTaxSurChgAmt = 0;

            AmountBilled = Util.GetDecimal((Util.GetDecimal(AmountBilled)) - (Util.GetDecimal(dtAdjust.Rows[0]["DiscountOnBill"].ToString()) + (Util.GetDecimal(DiscountOnItem))));
            ServiceTaxAmt = Util.GetDecimal(Math.Round((Util.GetDecimal((Util.GetDecimal(AmountBilled)) * Util.GetDecimal(ServiceTaxPer)) / 100), 2, MidpointRounding.AwayFromZero));
            decimal SurchargeTaxAmt = Util.GetDecimal((Util.GetDecimal((Util.GetDecimal(ServiceTaxAmt) * Util.GetDecimal(SerTaxSurChgPer)) / 100)));
            NetAmount = Util.GetDecimal(Util.GetDecimal(NetAmount) + Util.GetDecimal(ServiceTaxAmt) + SurchargeTaxAmt);
            ServiceTaxSurChgAmt = Util.GetDecimal(SurchargeTaxAmt);
            SerTaxBillAmt = Util.GetDecimal(AmountBilled);
            decimal Round = Math.Round((Util.GetDecimal(AmountBilled)) + (Util.GetDecimal(ServiceTaxAmt)), MidpointRounding.AwayFromZero);
            RoundOff = Util.GetDecimal(Round) - (Util.GetDecimal(AmountBilled)) - (Util.GetDecimal(ServiceTaxAmt));
            TotalPaidAmt = Util.GetDecimal(Math.Round(Round, 2, MidpointRounding.AwayFromZero));
            lblRoundOff.Text = Util.GetDecimal(Math.Round(RoundOff, 2, MidpointRounding.AwayFromZero)).ToString();
            lblRoundOff.Text = Util.GetDecimal(dtAdjust.Rows[0]["RoundOff"].ToString()).ToString();
            lblTotalBill_Amt.Text = Util.GetDecimal(dtAdjust.Rows[0]["S_amount"].ToString()).ToString();
        }

        lblTotalBill_Amt.Text = Util.GetString(Math.Round(NetAmount, 4, MidpointRounding.AwayFromZero));

        pnlDetails.Visible = true;
        Panel1.Visible = true;
        // pnlSave.Visible = true;
        if (ViewState["PanelID"] != null)
            ViewState["PanelID"] = ((Label)GridView1.SelectedRow.FindControl("lblPanelID")).Text;
        else
            ViewState.Add("PanelID", ((Label)GridView1.SelectedRow.FindControl("lblPanelID")).Text);


       

        if (PaidAmt != 0)
            lblPaidAmt.Text = PaidAmt.ToString();
        else
            lblPaidAmt.Text = "0.00";


        decimal CrDrAmount = Util.GetDecimal(StockReports.ExecuteScalar("SELECT IFNULL(SUM(IF(C.CRDR='CR01',-1*C.Amount,C.Amount)),0) FROM f_drcrnote c WHERE c.TransactionID='" + lblTransactionNo.Text + "'"));

        decimal chkIsRefund = 0;string CanRefundBeforeBillGenerate="0";
        if (dtAdjust.Rows[0]["BillNo"].ToString().Trim() != "")
        {


 	//if (Util.GetDecimal(lblNonPayableAmt.Text) > 0)
            //    chkIsRefund = Util.GetDecimal(lblNonPayableAmt.Text) - Util.GetDecimal(lblPaidAmt.Text) + CrDrAmount;
            //else
            //    chkIsRefund = Util.GetDecimal(lblTotalBill_Amt.Text) - Util.GetDecimal(lblPaidAmt.Text) + CrDrAmount;

            chkIsRefund = Util.GetDecimal(lblNonPayableAmt.Text);
        }
        else
        {
            //-----------------------------------------------------
            CanRefundBeforeBillGenerate = Util.GetString(All_LoadData.GetAuthorization(Util.GetInt(Session["RoleID"].ToString()), Session["ID"].ToString(), "CanRefundAllAmount"));
            //------------------------------------------------------
        }
        if (chkIsRefund < 0)
        {
            chkRefund.Checked = true;lblIsRefund.Text = "1";
        }
        else
        {
            lblIsRefund.Text = "0";chkRefund.Checked = false;
        }
        var isRefund = All_LoadData.GetAuthorization(Util.GetInt(Session["RoleID"].ToString()), Session["ID"].ToString(), "IsRefund");

            //if ((isRefund == "0" || isRefund == "") && chkRefund.Checked)
            //{
            //    pnlDetails.Visible = false;
            //    Panel1.Visible = false;
            //    Page.ClientScript.RegisterStartupScript(this.GetType(), "AuthorizationScript", "$(function () {modelAlert('Sorry you do not have sufficient rights to refund.');});", true);
            //    return;
            //}
        
        DataTable dt = AQ.GetPatientIPDInformation(lblTransactionNo.Text.Trim());
        if (dt != null && dt.Rows.Count > 0)
        {
            lblDoctorName.Text = dt.Rows[0]["DoctorName"].ToString();
            lblAdmissionDate.Text = Util.GetDateTime(dt.Rows[0]["DateOfAdmit"].ToString()).ToString("dd-MMM-yyyy");
        }
       
        DataTable dtAdvance_Detail = new DataTable();
        dtAdvance_Detail = AQ.GetPatientReceipt(lblTransactionNo.Text);
        if (dtAdvance_Detail != null && dtAdvance_Detail.Rows.Count > 0)
        {
            grdReceipt.DataSource = dtAdvance_Detail;
            grdReceipt.DataBind();
        }
        else if (dtAdvance_Detail != null && dtAdvance_Detail.Rows.Count == 0)
        {
            DataRow dr = dtAdvance_Detail.NewRow();
            dr[0] = "";
            dr[1] = "";
            dr[2] = "0";
            dr[3] = "";
            dr[4] = "";
            dr[5] = "";
            dr[6] = "0"; // for transactionID 
            dr[7] = "";
            dtAdvance_Detail.Rows.Add(dr);
            grdReceipt.DataSource = dtAdvance_Detail;
            grdReceipt.DataBind();
        }
        string BillNo = Util.GetString(StockReports.ExecuteScalar("select IFNULL(BillNo,'') from patient_medical_history where TransactionID='" + lblTransactionNo.Text + "'"));//f_ipdadjustment

      //  txtReceiveAmount.Attributes.Add("max-value", "10000000000");
        if (rdbAdmitted.Checked)
        {
            chkHospLedger.SelectedIndex = 0;
            Page.ClientScript.RegisterStartupScript(this.GetType(), "Confirm", "$(function () {chkHospLedgerType();});", true);
        }
        else if (rdbDischarged.Checked && BillNo == string.Empty)
        {
            Page.ClientScript.RegisterStartupScript(this.GetType(), "Confirm", "$(function () {chkHospLedgerType();});", true);
           // txtReceiveAmount.Attributes.Add("max-value", lblNonPayableAmt.Text);
        }
        else if (rdbDischarged.Checked && BillNo != string.Empty)
        {
            chkHospLedger.SelectedIndex = 1;
            chkHospLedger.Enabled = false;
            //value="0.00" onlynumber="5" decimalplace="2" ="100"
            //lblNonPayableAmt.Text = (Util.GetDouble(lblTotalBill_Amt.Text) - Util.GetDouble(lblPaidAmt.Text) + Util.GetDouble(CrDrAmount)).ToString();
           // txtReceiveAmount.Attributes.Add("max-value", lblNonPayableAmt.Text);
        }
       
         txtReceiveAmount.Text = "";
         UserControl uc = (UserControl)Page.LoadControl("~/design/Controls/UCPayment.ascx");
         divPaymentUserControl.Controls.Add(uc);

         if (chkIsRefund < 0)
         {
             txtReceiveAmount.Text = chkIsRefund.ToString().Replace("-", "");
             txtReceiveAmount.Enabled = false;
             Page.ClientScript.RegisterStartupScript(this.GetType(), "PaymentControlInit", "$(function () { $paymentControlInit(function(){onAmountChange(" + txtReceiveAmount.Text + ");}); });", true);
         }
         else
         {
             txtReceiveAmount.Enabled = true;
             Page.ClientScript.RegisterStartupScript(this.GetType(), "PaymentControlInit", "$(function () { $paymentControlInit(function(){});});", true);
         }
         pnlRecord.Visible = false;
    }

    #endregion

    #region DataLoad

    private void BindHospLedgerAccount()
    {
        try
        {
            chkHospLedger.Items.AddRange(LoadItems(CreateStockMaster.LoadLedgerAccount("HOSP")));
            chkHospLedger.DataBind();
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }

    }

    private void Clear()
    {
        lblMsg.Text = "";
        lblAdmissionDate.Text = "";
        lblDoctorName.Text = "";
        lblPaidAmt.Text = "";
        lblPanelComp.Text = "";
        lblPanelComp.Text = "";
        lblPatientID.Text = "";
        lblPatientName.Text = "";
        lblRoomNo.Text = "";
        lblTransactionNo.Text = "";

        //txtAmount.Text = "";
        txtPatientName.Text = "";
        txtTransactionId.Text = "";
        // txtcreditcardNo.Text = "";
        txtPatientID.Text = "";

       // btnSave.Enabled = false;
        Panel1.Visible = false;
        GridView1.DataSource = null;
        GridView1.DataBind();

        grdReceipt.DataSource = null;
        grdReceipt.DataBind();

        txtPatientName.Focus();
    }

    public ListItem[] LoadItems(string[,] str)
    {
        try
        {
            ListItem[] Items = new ListItem[str.Length / 2];

            for (int i = 0; i < str.Length / 2; i++)
            {
              Items[i] = new ListItem(str[i, 0].ToString(), str[i, 1].ToString());
            }
            return Items;
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return null;
        }
    }

    private void BindPatientDetails(string PatientId, string TransactionID, string PatientName, string PatientStatus)
    {
        try
        {
            StringBuilder str = new StringBuilder();
            str.Append("Select " );
                  if(Util.GetString(Session["CanRefundAllAmount"])=="1")
            str.Append(" 'true' CanRefundBeforeDischarge, ");            
                  else
            str.Append(" 'false' CanRefundBeforeDischarge, ");

            str.Append(" REPLACE(pip.TransactionID,'ISHHI','')TransactionID,pmh.transNo as IPDNo,pip.roomid,pip.ipdCaseTypeid,pip.status,pip.startDate,");
            str.Append(" pip.IsTempAllocated,CONCAT(pm.title,' ',pm.pname)pname,pm.PatientID,CONCAT(rm.Room_No,' / ',rm.Floor)roomno,");
            str.Append(" rtrim(ltrim(pnl.Company_Name))company_name,pnl.ReferenceCode,pip.Panelid PanelID,");
            str.Append(" CONCAT(pm.House_No,' ',pm.Street_Name,' ',pm.Locality,' ',pm.City)Address,pm.Relation,pm.RelationName ");
            str.Append(" From patient_ipd_profile pip inner join patient_medical_history pmh on pmh.transactionID= pip.transactionID  inner join patient_master pm ");
            str.Append(" on pm.PatientID = pip.PatientID inner join room_master rm ");
            str.Append(" on rm.RoomId  = pip.RoomID inner join f_panel_master pnl ");
            str.Append(" on pnl.PanelID  = pip.PanelID inner join ");
            str.Append(" (Select max(PatientIPDProfile_ID)PatientIPDProfile_ID ");
            str.Append(" from patient_ipd_profile where 1=1 ");
           // str.Append("where status='" + PatientStatus + "' ");
            if (PatientId != "")
                str.Append("and PatientID='" + PatientId + "' ");
            if (TransactionID != "")
                str.Append("and TransactionID='" + TransactionID + "' ");
            str.Append("group by TransactionID) pip1 ");
            str.Append("on pip1.PatientIPDProfile_ID = pip.PatientIPDProfile_ID ");
            str.Append("WHERE pip.CentreID=" + Session["CentreID"].ToString() + " ");
            if (PatientId != "" && PatientName == "")
            {
                str.Append("AND pm.PatientID='" + PatientId + "' ");
            }
            else if (PatientId == "" && PatientName != "")
            {
                str.Append("AND pm.PName like '%" + PatientName + "%' ");
            }
            else if (PatientId != "" && PatientName != "")
            {
                str.Append("AND pm.PatientID='" + PatientId + "' and pm.PName like '%" + PatientName + "%' ");
            }

            DataTable dt = StockReports.GetDataTable(str.ToString()).Copy();
            if (dt.Rows.Count > 0 && dt != null)
            {
                GridView1.DataSource = dt;
                GridView1.DataBind();
                pnlRecord.Visible = true;

            }
            else
            {
                GridView1.DataSource = null;
                GridView1.DataBind();
                lblMsg.Text = "Record Not Found ";
                pnlRecord.Visible = false;
            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }

    }

    public static DataTable Receipt(string ReceiptNo, decimal Amount,string patientID,string transactionNo,string roomNo,string doctorName,string patientName,string panelName)
    {
        DataTable dt = null;
        if (dt == null)
        {
            dt = new DataTable();
            dt.Columns.Add("PatientID");
            dt.Columns.Add("Patient_Name");
            dt.Columns.Add("TransactionID");
            dt.Columns.Add("Room_No");
            dt.Columns.Add("Consultant Name");
            dt.Columns.Add("ReceiptNo");
            dt.Columns.Add("Amount");
            dt.Columns.Add("CompanyName");
            // dt.Columns.Add("PaymentMode");
            dt.Columns.Add("PreparedBy");
            dt.Columns.Add("PanelCompany");
        }

        DataRow dr = dt.NewRow();
        dr["PreparedBy"] =HttpContext.Current.Session["LoginName"].ToString();
        dr["PatientID"] = patientID;
        dr["Patient_Name"] = patientName;
        dr["TransactionID"] = transactionNo;
        dr["Room_No"] = roomNo;
        dr["Consultant Name"] = doctorName;
        dr["ReceiptNo"] = ReceiptNo;
        dr["Amount"] = Amount;
        //if (cmbPaid.SelectedItem.Text == "COMPANY")
        //{
        //    dr["CompanyName"] = lblPanelComp.Text;
        //}
        //else
        //{
        //    dr["CompanyName"] = "";
        //}
        //dr["PaymentMode"] = ddlPaymentMode.SelectedItem.Value;

        if (panelName != AllGlobalFunction.Panel.ToString())
        {
            dr["PanelCompany"] = panelName.Trim();
        }
        dt.Rows.Add(dr);

        return dt;
    }

    public static void UpdateFileClose(string TransactionID)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" Update Patient_Medical_History adj inner join (Select TransactionID,TotalBilledAmt,");
            sb.Append(" (ItemDisc + DiscountOnBill) TotalDisc,");
            sb.Append(" (TotalBilledAmt - (ItemDisc + DiscountOnBill))NetAmount,AmountPaid from");
            sb.Append(" (select ltd.TransactionID,Round(sum(((ltd.Rate * ltd.Quantity)*ltd.DiscountPercentage)/100))ItemDisc,");
            sb.Append(" IFNULL(adj.DiscountOnBill,0)DiscountOnBill,adj.TotalBilledAmt,");
            sb.Append(" (Select sum(AmountPaid) from f_reciept where IsCancel=0 and TransactionID=adj.TransactionID)AmountPaid");
            sb.Append(" from f_ledgertnxdetail ltd inner join");
            sb.Append(" Patient_Medical_History adj on adj.TransactionID = ltd.TransactionID");
            sb.Append(" where (BillNo <>'' or BillNo <>null) and FileClose_flag=0 and IsVerified = 1");
            sb.Append(" and IsPAckage=0 and adj.TransactionID ='" + TransactionID + "' group by ltd.TransactionID)t");
            sb.Append(" Where Round((TotalBilledAmt - (ItemDisc + DiscountOnBill))) = Round(AmountPaid)) t1 on");
            sb.Append(" adj.TransactionID = t1.TransactionID set FileClose_flag=1 ");

            StockReports.ExecuteDML(sb.ToString());

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    public static DataTable  GetPaymentDetailsDataTable()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add(new DataColumn("PaymentMode"));
        dt.Columns.Add(new DataColumn("PaymentModeID"));
        dt.Columns.Add(new DataColumn("PaidAmount"));
        dt.Columns.Add(new DataColumn("Currency"));
        dt.Columns.Add(new DataColumn("CountryID"));
        dt.Columns.Add(new DataColumn("BankName"));
        dt.Columns.Add(new DataColumn("RefNo"));
        dt.Columns.Add(new DataColumn("BaceCurrency"));
        dt.Columns.Add(new DataColumn("C_Factor"));
        dt.Columns.Add(new DataColumn("BaseCurrency"));
        dt.Columns.Add(new DataColumn("Notation"));
        dt.Columns.Add(new DataColumn("PaymentRemarks"));
        dt.Columns.Add(new DataColumn("CurrencyRoundOff"));
        dt.Columns.Add(new DataColumn("RefDate"));
        dt.Columns.Add(new DataColumn("swipeMachine"));
        
        return dt;
       // ViewState["dtPaymentDetail"] = dt;
    }

    #endregion

    [WebMethod(EnableSession=true)]
    public static string Save(string amount, string hashCode, string IsRefund, string transactionNo, bool isAdmitted, decimal totalPaidAmount, string hospLedger, string patientID, string roomNo, string doctorName, string patientName, string panelName, string paymentRemarks, string paymentReceivedFrom, string panelID, object paymentDetail)
    {

        //niraj  if (IsRefund == "1" && ((TextBox)PaymentControl.FindControl("txtPaidAmount")).Text == "0")
       //niraj  {
           //niraj ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Please Enter Amount');", true);
            //niraj((TextBox)PaymentControl.FindControl("txtPaidAmount")).Focus();
            //niraj return;
        //niraj   }
        DataTable PaidAmounttabel = StockReports.GetDataTable("SELECT IFNULL(ROUND(SUM(frp.`Amount`),2),0) PaidAmount FROM f_reciept fr INNER JOIN f_receipt_paymentdetail frp ON fr.receiptno=frp.receiptno  WHERE fr.TransactionID='" + transactionNo.Trim() + "' AND fr.IsCancel = 0 AND fr.PaidBy='PAT' AND frp.paymentmodeid=1");

        List<Receipt_PaymentDetail> dataPaymentDetail = new JavaScriptSerializer().ConvertToType<List<Receipt_PaymentDetail>>(paymentDetail);
        if (IsRefund == "0")
        {
            if (dataPaymentDetail.Count > 0 && dataPaymentDetail != null)
            {
                int paymentid = 0;
                foreach (var payment in dataPaymentDetail)
                {
                    paymentid = payment.PaymentModeID;
                }
                if (PaidAmounttabel.Rows.Count > 0 && paymentid == 1)
                {
                    decimal net = Convert.ToDecimal(PaidAmounttabel.Rows[0]["PaidAmount"]) + Convert.ToDecimal(amount);
                    if (net > 200000)
                    {
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "You pay in cash '" + PaidAmounttabel.Rows[0]["PaidAmount"] + "',Can't pay more then 2 lakh's in cash" });
                    }
                }
            }
        }
        AllQuery AQ = new AllQuery();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            decimal AmountReceived = AQ.GetPaidAmount(transactionNo.Trim());
            decimal BillAmt=AQ.GetBillAmount(transactionNo.Trim(),con);
           
            decimal TotalDisc = Util.GetDecimal(StockReports.ExecuteScalar("Select IFNULL(SUM(TotalDiscAmt) + (SELECT IFNULL(DiscountOnBill,0) from patient_medical_history where TransactionID='" + transactionNo.Trim() + "'),0) TotalDisc from f_ledgertnxdetail where TransactionID='" + transactionNo.Trim() + "'  and isverified=1 and ispackage=0"));//f_ipdadjustment


            if (IsRefund == "1" && Util.GetString(HttpContext.Current.Session["CanRefundAllAmount"]) =="0")
            {
				
				 decimal NetAmount = Util.GetDecimal(StockReports.ExecuteScalar("Select SUM(NetItemAmt) from f_ledgertnxdetail where TransactionID='" + transactionNo.Trim() + "'  and isverified=1 and ispackage=0")); //Util.GetDecimal(AmountBilled) - Util.GetDecimal(TotalDisc);
                decimal PanelAmountAllocation = AllLoadData_IPD.GetAllocationAmount(transactionNo.Trim());
				
               /// if (Math.Round(totalPaidAmount + (NetAmount-PanelAmountAllocation),2) > AmountReceived) 
                   // return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, totalPaidAmount=totalPaidAmount,BillAmt= Math.Round(BillAmt, 2),AmountReceived=AmountReceived, response = "Paid Amount less then the Bill Amount.Please Re-Check the amount." });
            }

            else if (IsRefund == "1" && Util.GetString(HttpContext.Current.Session["CanRefundAllAmount"]) == "1")
            {
                    if (totalPaidAmount > AmountReceived)
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "The Refunding Amount is greater then the Amount collected from patient till date.Please Re-Check the amount." });
            }

            DataTable dtcon = StockReports.GetDataTable("Select BillNo,if(CURDATE()>Date(ADDDATE(BillDate,1)),'true','false')IsRefundAllowed from patient_medical_history where TransactionID='" + transactionNo.Trim() + "' and (BillNo is not null or BillNo <>'') Limit 1");//f_ipdadjustment
            if (dtcon.Rows.Count > 0)
            {
                if (IsRefund == "1")
                {
                    if (Util.GetBoolean(dtcon.Rows[0]["IsRefundAllowed"].ToString()) == true)
                    {
                        if (totalPaidAmount == AmountReceived && IsRefund == "1")
                        {
                            if ((Util.GetString(HttpContext.Current.Session["CanRefundAllAmount"]) == "0"))
                            {
                                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "You are not authorized to refund all money" });
                            }
                        }
                    }
                }

                //if (IsRefund == "1" && dtcon.Rows[0]["BillNo"].ToString() == "")
                //    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "The Bill is Not Generated. Refund cannot be Possible" });




                //if (dtcon.Rows[0]["BillNo"].ToString() != "")
                //{
                decimal BillAmount = Util.GetDecimal(StockReports.ExecuteScalar("SELECT SUM(amount)-(SELECT IFNULL(DiscountOnBill,0) FROM patient_medical_history WHERE TransactionID='" + transactionNo.Trim() + "') FROM f_ledgertnxdetail WHERE TransactionID='" + transactionNo.Trim() + "' AND IsVerified=1 AND IsPackage=0 group by TransactionID"));//f_ipdadjustment

                    decimal PanelApprovalAmt = AllLoadData_IPD.GetAllocationAmount(transactionNo.Trim()); //Util.GetDecimal(StockReports.ExecuteScalar("Select PanelApprovedAmt from f_ipdAdjustment where TransactionID='" + transactionNo.Trim() + "'"));


                    decimal CrDrAmount = Util.GetDecimal(StockReports.ExecuteScalar("SELECT SUM(ltd.NetItemAmt) FROM f_ledgertnxdetail ltd WHERE ltd.TypeofTnx IN ('CR','DR') AND ltd.TransactionID='" + transactionNo.Trim() + "' AND ltd.Isverified=1 AND ltd.IsPackage=0"));


                    //if (chkHospLedger.SelectedItem.Text.ToUpper() == "REFUND")
                    //{
                    if (IsRefund == "1")
                    {
                        decimal ActualRefundAmt = Math.Round(((BillAmount - PanelApprovalAmt) - totalPaidAmount), 2);// + CrDrAmount;

                        if (ActualRefundAmt.ToString().Contains("-"))
                            ActualRefundAmt = Util.GetDecimal(ActualRefundAmt.ToString().Replace("-", ""));

                      //  if (Util.round(Util.GetDecimal(ActualRefundAmt)) < Util.GetDecimal(totalPaidAmount))
                        //    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Your Refunding Amount is going below Total Collected Amount then Net Bill Amount.Refund Can Be Possible Upto : " + ActualRefundAmt });


                        if (Util.GetDecimal(totalPaidAmount) > AmountReceived)
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "The Refunding Amount is greater then the Amount collected from patient till date.Please Re-Check the amount." });

                    }

                    //if (AmountReceived + PanelApprovalAmt < BillAmount && chkRefund.Checked == true)
                    //{
                    //    lblMsg.Visible = true;
                    //    lblMsg.Text = "Patient's Bill has been Generated.Collected Amount is Already less then Net Bill Amount.Refund Cannot Be Possible....";
                    //    //chkRefund.Checked = false;
                    //    chkRefund.Focus();
                    //    return;
                    //}

                    //if (AmountReceived + PanelApprovalAmt < BillAmount + Util.GetDecimal("-" + txtAmount.Text.Trim()) && chkRefund.Checked == true)
                    //{
                    //    lblMsg.Visible = true;
                    //    lblMsg.Text = "Your Refunding Amount is going below Total Collected Amount then Net Bill Amount.Refund Cannot Be Possible....";
                    //    //chkRefund.Checked = false;
                    //    chkRefund.Focus();
                    //    return;
                    //}
                }

            //}

            string Panel = "", PatientLedgerNo = "", HospitalLedgerNo = "";
            Panel = panelID;
            DataTable LedgerNo = AQ.GetPMHByTransactionID(transactionNo.Trim());
            if (LedgerNo.Rows.Count > 0)
            {
                PatientLedgerNo = AllQuery.GetLedgerNoByLedgerUserID(LedgerNo.Rows[0][0].ToString(), con);
                HospitalLedgerNo = hospLedger;
            }

            string Hospital_ID =HttpContext.Current.Session["HOSPID"].ToString();
            //if (cmbPaid.SelectedItem.Text == "COMPANY")
            //{
            //    Panel = ViewState["PanelID"].ToString();
            //}
            DateTime Paiddate = Util.GetDateTime(System.DateTime.Now.ToString("dd-MMM-yyyy"));
            DateTime PaidTime = Util.GetDateTime(System.DateTime.Now.ToString("HH:mm:ss"));
            string Depositor = patientID.Trim();
            string Receiver = HttpContext.Current.Session["ID"].ToString();
            decimal Amount = 0;
            string refund = "";
            //if (chkHospLedger.SelectedItem.Text.ToUpper() == "REFUND")
            //{
            if (IsRefund == "1")
            {
                Amount = Util.GetDecimal(totalPaidAmount);
                Amount = -Amount;
                refund = "1";
            }
            else
            {
                Amount = Util.GetDecimal(totalPaidAmount);
                refund = "0";
            }
            DataTable dtPaymentDetail = GetPaymentDetailsDataTable(); //ViewState["dtPaymentDetail"] as DataTable;
           //niraj if (dtPaymentDetail == null)
           //niraj {
            //niraj    ViewState["dtPaymentDetail"] = string.Empty;
             //niraj   dtPaymentDetails();
             //niraj   dtPaymentDetail = ViewState["dtPaymentDetail"] as DataTable;
            //niraj }

            if (dataPaymentDetail.Count > 0 && dataPaymentDetail != null)
            {

                foreach (var payment in dataPaymentDetail)     
                {
                    DataRow dr = dtPaymentDetail.NewRow();
                    dr["PaymentMode"] = payment.PaymentMode; 
                    dr["PaymentModeID"] = payment.PaymentModeID;
                    if (IsRefund == "1")
                    {
                        dr["PaidAmount"] = "-" + payment.S_Amount;
                        dr["BaseCurrency"] = "-" + payment.Amount;
                    }
                    else
                    {
                        dr["PaidAmount"] = payment.S_Amount;
                        dr["BaseCurrency"] = payment.Amount;
                    }
                    dr["Currency"] = payment.S_Currency;
                    dr["CountryID"] = payment.S_CountryID;
                    dr["BankName"] = payment.BankName;
                    dr["RefNo"] = payment.RefNo;
                    dr["C_Factor"] = payment.C_Factor;
                    dr["BaceCurrency"] = "";
                    dr["Notation"] = payment.S_Notation;
                    dr["CurrencyRoundOff"] = payment.currencyRoundOff;
                    dr["RefDate"] = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                    dr["swipeMachine"] = payment.swipeMachine;
                    
                    dtPaymentDetail.Rows.Add(dr);
                    //dtPaymentDetail.AcceptChanges();
                }
                DataTable dt1 = dtPaymentDetail;
                // decimal AmountPaid = Util.GetDecimal(((Label)PaymentControl.FindControl("lblTotalPaidAmount")).Text);
                decimal AmountPaid = Amount;
                CreateStockMaster Csm = new CreateStockMaster();
                string ReceiptNo = Csm.SaveReceiptBillNew(dt1, PatientLedgerNo, HospitalLedgerNo, HttpContext.Current.Session["HOSPID"].ToString(), Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd")), Util.GetDateTime(DateTime.Now.ToString("HH:mm:ss")), Receiver, Depositor, Util.GetInt(Panel), transactionNo.Trim(), "0", hashCode, AmountPaid, tnx, paymentRemarks.Trim(), paymentReceivedFrom.Trim());
                if (ReceiptNo != null && ReceiptNo != "")
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE ipd_threshold  SET thresholdLimit =thresholdLimit-" + Util.GetDecimal(AmountPaid) + " WHERE TransactionID='" + transactionNo.Trim() + "' AND isactive=1");

                    //Devendra Singh 2018-11-12 Insert Finance Integarion 
                    if (Resources.Resource.AllowFiananceIntegration == "1")
                    {
                        string IsIntegrated = Util.GetString(EbizFrame.InsertIPDTransaction(0, ReceiptNo, "A", tnx));
                        if (IsIntegrated == "0")
                        {
                            tnx.Rollback();
                            tnx.Dispose();
                             return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Intregation Error." });
                        }
                    }
					
					
					
					  //for Patient Advance 
                    var patientAdvancePaymentMode = dataPaymentDetail.Where(p => p.PaymentModeID == 7).ToList();
                    for (int i = 0; i < patientAdvancePaymentMode.Count; i++)
                    {
                        DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,(AdvanceAmount-IFNULL(BalanceAmt,0))RemAmt,ReceiptNo FROM OPD_Advance WHERE PatientID ='" + patientID + "'  AND IsCancel=0 AND (AdvanceAmount-IFNULL(BalanceAmt,0))>0 ORDER BY ID+0").Tables[0];
                        if (dt.Rows.Count > 0)
                        {
                            decimal advanceAmount = patientAdvancePaymentMode[i].Amount;
                            for (int s = 0; s < dt.Rows.Count; s++)
                            {
                                decimal paidAmt = 0;

                                if (Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString()) >= Util.GetDecimal(advanceAmount))
                                {
                                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update OPD_Advance SET BalanceAmt =BalanceAmt+" + Util.GetDecimal(advanceAmount) + " WHERE ID ='" + dt.Rows[s]["ID"].ToString() + "' ");
                                    paidAmt = advanceAmount;

                                    advanceAmount = 0;
                                }
                                else if (Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString()) < Util.GetDecimal(advanceAmount))
                                {
                                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update OPD_Advance SET BalanceAmt =BalanceAmt+" + Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString()) + " WHERE ID ='" + dt.Rows[s]["ID"].ToString() + "' ");

                                    advanceAmount = advanceAmount - Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString());
                                    paidAmt = Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString());
                                }

                                OPD_Advance_Detail advd = new OPD_Advance_Detail(tnx);
                                advd.PaidAmount = Util.GetDecimal(paidAmt);
                                advd.PatientID = patientID;
                                advd.TransactionID = transactionNo;
                                advd.LedgerTransactionNo = string.Empty;
                                advd.ReceiptNo = ReceiptNo;

                                advd.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                                advd.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                                advd.CreatedBy = HttpContext.Current.Session["ID"].ToString();
                                advd.AdvanceID = Util.GetInt(dt.Rows[s]["ID"].ToString());
                                advd.ReceiptNoAgainst = dt.Rows[s]["ReceiptNo"].ToString();
                                advd.Insert();

                                if (advanceAmount == 0)
                                    break;
                            }
                            if (advanceAmount > 0)
                            {
                                tnx.Rollback();
                                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Un-Sufficient OPD Advance Balance", message = "Error In OPD Advance" });
                            }
                        }
                        else
                        {
                            tnx.Rollback();
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Un-Sufficient OPD Advance Balance", message = "Error In OPD Advance" });
                        }

                    }

                    tnx.Commit();


                    UpdateFileClose(transactionNo.Trim());

                    //HttpContext.Current.Session["DataTableReceipt"] = Receipt(ReceiptNo, Amount,patientID,transactionNo,roomNo,doctorName,patientName,panelName);

                    //niraj    Clear();
                    //niraj   Panel1.Visible = false;
                    //niraj  ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Receipt Saved Successfully');window.open('../../Design/IPD/ReceiptIPD.aspx?PID=" + Depositor + "&Refund=" + refund + "');", true);
                    //niraj  ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "location.href='ReceiptBill.aspx';", true);
                    if (Resources.Resource.ReceiptPrintFormat == "0")
                    {
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Receipt Save Successfully", responseURL = "../../Design/IPD/ReceiptIPD.aspx?PID=" + Depositor + "&Refund=" + refund });
                    }
                    else
                    {
                        //return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Receipt Save Successfully", responseURL = "../../Design/Common/CommonReceipt_pdf.aspx?ReceiptNo=" + ReceiptNo + "&Type=IPD&Refund=" + refund });
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Receipt Save Successfully", responseURL = "../../Design/Common/CommonPrinterOPDThermal.aspx?ReceiptNo=" + ReceiptNo + "&Type=IPD&Refund=" + refund });
                    }

                }
                else
                {
                    //niraj  ViewState["dtPaymentDetail"] = null;
                    //niraj lblMsg.Text = "Record Not Saved";
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Record Not Saved" });

                }

            }
            else
            {
                DataTable dt = StockReports.GetDataTable("SELECT cnm.S_CountryID,cnm.S_Currency,cnm.S_Notation,cnm.B_Currency FROM country_master cm INNER JOIN converson_master cnm ON cm.CountryID = cnm.S_CountryID WHERE cm.IsActive=1 AND cm.IsBaseCurrency=1 ");
                if (dt.Rows.Count > 0)
                {
                    AllSelectQuery ASQ = new AllSelectQuery();
                    DataRow drRow = dtPaymentDetail.NewRow();
                    drRow["PaymentMode"] = "Cash";
                    drRow["PaymentModeID"] = "1";
                    drRow["PaidAmount"] = Util.GetDecimal(totalPaidAmount);
                    drRow["Currency"] = dt.Rows[0]["S_Currency"].ToString();
                    drRow["CountryID"] = dt.Rows[0]["S_CountryID"].ToString();
                    drRow["BankName"] = "";
                    drRow["RefNo"] = "";
                    drRow["BaceCurrency"] = dt.Rows[0]["B_Currency"].ToString();
                    drRow["C_Factor"] = ASQ.GetConversionFactor(Util.GetInt(dt.Rows[0]["S_CountryID"])).ToString();
                    drRow["BaseCurrency"] = "0";
                    drRow["Notation"] = dt.Rows[0]["S_Notation"].ToString();
                    drRow["RefDate"] = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                    dtPaymentDetail.Rows.Add(drRow);
                }
                DataTable dt1 = dtPaymentDetail;
                CreateStockMaster Csm = new CreateStockMaster();
                string RefundBiilNo = Csm.SaveReceiptBillNewRefund(dt1, PatientLedgerNo, HospitalLedgerNo, HttpContext.Current.Session["HOSPID"].ToString(), Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd")), Util.GetDateTime(DateTime.Now.ToString("hh:mm:ss")), Receiver, Depositor, Util.GetInt(Panel), transactionNo.Trim(), "0", hashCode, Amount, tnx, paymentRemarks.Trim(), paymentReceivedFrom.Trim());
                if (RefundBiilNo != null && RefundBiilNo != "")
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE ipd_threshold  SET thresholdLimit =thresholdLimit-" + Util.GetDecimal(Amount) + " WHERE TransactionID='" + transactionNo.Trim() + "' AND isactive=1");

                    //Devendra Singh 2018-11-12 Insert Finance Integarion 
                    if (Resources.Resource.AllowFiananceIntegration == "1")
                    {
                        string IsIntegrated = Util.GetString(EbizFrame.InsertOPDTransaction(0, RefundBiilNo, "A", tnx));
                        if (IsIntegrated == "0")
                        {
                            tnx.Rollback();
                            tnx.Dispose();
                        }
                    }
                    tnx.Commit();
                    UpdateFileClose(transactionNo.Trim());
                    HttpContext.Current.Session["DataTableReceipt"] = Receipt(RefundBiilNo, Amount, patientID, transactionNo, roomNo, doctorName, patientName, panelName);
                    if (Resources.Resource.ReceiptPrintFormat == "0")
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Receipt Save Successfully", responseURL = "../../Design/IPD/ReceiptIPD.aspx?PID=" + Depositor + "&Refund=" + refund });
                    else
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Receipt Save Successfully", responseURL = "../../Design/Common/CommonReceipt_pdf.aspx?ReceiptNo=" + RefundBiilNo + "&Type=IPD&Refund=" + refund });
                }
                else
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Record Not Saved" });
                
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Record Not Saved", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }    
    }

    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow) {
            var patientAdmitStatus = ((Label)e.Row.FindControl("lblStatus")).Text.Trim();
            if (patientAdmitStatus == "IN")
                e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#3CB371");
            if (patientAdmitStatus == "OUT")
                e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#f89406");
        }
    }
}
