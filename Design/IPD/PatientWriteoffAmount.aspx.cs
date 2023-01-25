using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
public partial class Design_IPD_PatientWriteoffAmount : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string TransID = string.Empty;
            TransID = Request.QueryString["TransactionID"].ToString();
            ViewState["TransID"] = TransID;

            if (Resources.Resource.AllowFiananceIntegration == "2")//
            {
                string TransNo = StockReports.ExecuteScalar(" Select TransNo FROM patient_medical_history WHERE  TransactionID = '" + TransID + "'");
                if (TransNo == "")
                { TransNo = Request.QueryString["TransactionID"].ToString(); }

                if (AllLoadData_IPD.CheckWriteoffPostToFinance(TransNo) > 0)
                {
                    string Msga = "Patient's Final Bill Already Posted To Finance...";

                    Response.Redirect("PatientBillMsg.aspx?msg=" + Msga);

                }
            }
            string panelID = Util.GetString(StockReports.ExecuteScalar("SELECT PanelID FROM patient_medical_history pmh WHERE pmh.TYPE='IPD' AND  pmh.TransactionID='" + TransID + "';"));
            if (Resources.Resource.DefaultPanelID == panelID)
            {
                string Msg = "This paitent is not a insurance patient";

                Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
            }

            string BillNo = Util.GetString(StockReports.ExecuteScalar("SELECT PMH.BillNo FROM patient_medical_history pmh WHERE pmh.BillNo <>'' AND pmh.TYPE='IPD' AND  pmh.TransactionID='" + TransID + "'"));
            if (BillNo != "")
            {
                string Msg = "Bill has generated, you can not enter writeoff amount";
                Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
            }

            GetBillDetails();
            fillGrid();
        }
    }
    private void GetBillDetails()
    {
        if (ViewState["TransID"] != null)
        {
            string TransID = Convert.ToString(ViewState["TransID"]);
            StringBuilder sbBill = new StringBuilder();
            sbBill.Append("SELECT ROUND(t2.GrossAmt,2)GrossAmt,ROUND(t2.NetAmount,2)NetAmt,  ");
            sbBill.Append("ROUND(t2.TDiscount,2)TDiscount,ROUND(IFNULL(t3.RecAmt,0.00),2)RecAmt,PanelApprovedAmt,TotalDeduction,PanelID  ");
            sbBill.Append("FROM (  ");
            sbBill.Append("SELECT TransactionID,SUM(GrossAmt)GrossAmt,SUM(TDiscount)TDiscount,SUM(GrossAmt-TDiscount)NetAmount,Type_ID,ServiceItemID, ");
            sbBill.Append("SUM(PanelApprovedAmt)PanelApprovedAmt,SUM(TotalDeduction)TotalDeduction, PanelID FROM  ");
            sbBill.Append("(       ");
            sbBill.Append("SELECT ltd.TransactionID,SUM(ltd.GrossAmount)GrossAmt,  ");
            sbBill.Append("IFNULL(ROUND((SUM(ltd.TotalDiscAmt)+IFNULL(pmh.DiscountOnBill,0)),2),0)TDiscount,SUM(ltd.NetItemAmt)NetAmount,      ");
            sbBill.Append("im.Type_ID,im.ServiceItemID,      IFNULL(pmh.PanelApprovedAmt,0)PanelApprovedAmt, ");
            sbBill.Append("(IFNULL(pmh.Deduction_Acceptable,'0')+IFNULL(pmh.TDS,'0')+IFNULL(pmh.WriteOff,'0'))TotalDeduction,pmh.PanelID       ");
            sbBill.Append("FROM f_ledgertnxdetail ltd       ");
            sbBill.Append("INNER JOIN f_ledgertransaction LT ON ltd.LedgerTransactionNo = LT.LedgerTransactionNo       ");
            //sbBill.Append("INNER JOIN f_ipdadjustment ipd ON ipd.TransactionID=lt.TransactionID       ");
            sbBill.Append("INNER JOIN f_itemmaster im ON ltd.ItemID = im.ItemID       ");
            sbBill.Append("INNER JOIN Patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID       ");
            sbBill.Append("WHERE Lt.IsCancel = 0 AND ltd.IsFree = 0 AND ltd.IsVerified = 1       ");
            sbBill.Append("AND ltd.IsPackage = 0      AND lt.TransactionID = '" + ViewState["TransID"].ToString() + "'       ");
            sbBill.Append("  GROUP BY lt.TransactionID     ");
            sbBill.Append(")t    ");
            sbBill.Append(")T2   ");
            sbBill.Append("LEFT JOIN (  ");
            sbBill.Append("SELECT TransactionID,ROUND(SUM(AmountPaid),2)RecAmt FROM f_reciept WHERE IsCancel = 0   ");
            sbBill.Append("AND TransactionID = '" + ViewState["TransID"].ToString() + "' GROUP BY TransactionID   ");
            sbBill.Append(")T3 ON T2.TransactionID = T3.TransactionID ");
            DataTable dtBill = StockReports.GetDataTable(sbBill.ToString());

            if (dtBill.Rows.Count > 0)
            {

                decimal PaidAmount = 0;
                decimal AllocationAmount = 0;

                AllocationAmount = Util.GetDecimal(StockReports.ExecuteScalar("SELECT SUM(Amount) FROM panel_amountallocation WHERE transactionID='" + ViewState["TransID"].ToString() + "'"));

                PaidAmount = Util.GetDecimal(StockReports.ExecuteScalar(" SELECT ROUND(SUM(AmountPaid),2)RecAmt FROM f_reciept WHERE IsCancel = 0  AND TransactionID = '" + ViewState["TransID"].ToString() + "'  "));
                if (PaidAmount > 0)
                {
                    dtBill.Rows[0]["RecAmt"] = PaidAmount.ToString();
                    dtBill.AcceptChanges();
                }

                lblTotalBillAmount.Text = Util.GetString(dtBill.Rows[0]["GrossAmt"]);
                lblDiscountAmount.Text = Util.GetString(dtBill.Rows[0]["TDiscount"]);
                lblNetAmount.Text = Util.GetString(dtBill.Rows[0]["NetAmt"]);
                lblAdvanceAmount.Text = Util.GetString(Util.GetDecimal(dtBill.Rows[0]["RecAmt"]));
                lblAlreadyOff.Text = Util.GetString(StockReports.ExecuteScalar(" Select IFNULL(Round(sum(WriteOffAmount),2),0)from f_writeoff where TransactionID='" + ViewState["TransID"] + "' and  IsActive=1"));
                // lblTaxAppliedOn.Text = Util.GetString(dtBill.Rows[0]["NetAmt"]);
                lblAllocationAmount.Text = Util.GetString(AllocationAmount);
                decimal RoundOff = Math.Round((Util.GetDecimal(lblTotalBillAmount.Text) - Util.GetDecimal(lblNetAmount.Text)), 2, MidpointRounding.AwayFromZero);
                decimal BalanceAmt = Util.GetDecimal(lblNetAmount.Text) - (Util.GetDecimal(lblAdvanceAmount.Text) + Util.GetDecimal(lblAlreadyOff.Text) + RoundOff +Util.GetDecimal( lblAllocationAmount.Text));
                lblBalance.Text=Util.GetDecimal(BalanceAmt).ToString();
                lblPanelID.Text = Util.GetString(dtBill.Rows[0]["PanelID"]);

                decimal TotalAmt = Util.GetDecimal(lblNetAmount.Text);
                
             
            }
            else
            {
                lblMsg.Text = "No Billing Information Found";
              
            }
        }
    }

    protected void grdWriteOffDetail_RowDataBound(object sender, GridViewRowEventArgs e)
    {


        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            decimal createdDateDiff = Util.GetDecimal(((Label)e.Row.FindControl("lblTimeDiff")).Text);
            if (createdDateDiff < 3120)//Util.GetDecimal(Resources.Resource.EditTimePeriod))
            {
                ((ImageButton)e.Row.FindControl("imgbtnEdit")).Enabled = true;
            }
            else
            {
                ((ImageButton)e.Row.FindControl("imgbtnEdit")).Enabled = false;
            }
            
        }

        int CanEditPatientWriteOff = 0;
        DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(Session["RoleID"]), Util.GetString(Session["ID"]));
        if (dtAuthority.Rows.Count > 0)
        {
            if (Util.GetInt(dtAuthority.Rows[0]["CanEditPatientWriteOff"]) == 1)
            {
                CanEditPatientWriteOff = 1;//"You Are Not Authorised for it";
            }
        }
        if (e.Row.RowType == DataControlRowType.DataRow)
        {

            if (CanEditPatientWriteOff == 0)
            {
                ((ImageButton)e.Row.FindControl("imgbtnEdit")).Visible = false;
            }
            else if (CanEditPatientWriteOff == 1)
            {
                ((ImageButton)e.Row.FindControl("imgbtnEdit")).Visible = true;
            }
        }
    }
    protected void grdWriteOffDetail_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        int id = Convert.ToInt16(e.CommandArgument.ToString());
        ViewState["ID"] = ((Label)grdWriteOffDetail.Rows[id].FindControl("lblID")).Text;
        txtWriteOff.Text= ((Label)grdWriteOffDetail.Rows[id].FindControl("lblWriteOffAmount")).Text;
        txtReason.Text = ((Label)grdWriteOffDetail.Rows[id].FindControl("lblWriteOffReason")).Text;
        btnSave.Visible = false;
        btnUpdate.Visible = true;
    }
    private void fillGrid()
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("Select ID,ROUND(WriteOffAmount,2)WriteOffAmount, WriteOffReason,TIMESTAMPDIFF(MINUTE,EntryDateTime,NOW())createdDateDiff,DATE_FORMAT(EntryDateTime, '%d %b %Y %r') as EntryDateTime1,(SELECT concat(em.Title,' ',em.NAME)  Name 	FROM 	employee_master  em WHERE  em.EmployeeId=fwo.EntryBy LIMIT 0, 1) AS EntryBy1,DATE_FORMAT(VerifiedOn, '%d %b %Y %r') as VerifiedOn1,(SELECT concat(em.Title,' ',em.NAME)  Name 	FROM 	employee_master  em WHERE  em.EmployeeId=fwo.VerifiedBy LIMIT 0, 1) AS VerifiedBy1 from f_writeoff fwo where TransactionID='" + ViewState["TransID"].ToString() + "'");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                grdWriteOffDetail.DataSource = dt;
                grdWriteOffDetail.DataBind();
             }
            else
            {

                lblMsg.Text = "No Rows Found.";

            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {

    
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();

        try
        {
            if (txtWriteOff.Text != "" && txtReason.Text != "" && Util.GetDecimal(txtWriteOff.Text) != 0)
            {
                

                decimal NetBillAmt = Util.GetDecimal(lblNetAmount.Text);
                decimal ReceiveAmt = Util.GetDecimal(lblAdvanceAmount.Text);
                decimal writeoff = Util.GetDecimal(txtWriteOff.Text);
                decimal PreviousWriteOffAmt = Util.GetDecimal(lblAlreadyOff.Text);
                decimal AllocationAmount = Util.GetDecimal(lblAllocationAmount.Text);
                decimal Balance = Util.GetDecimal(NetBillAmt - (ReceiveAmt + AllocationAmount + PreviousWriteOffAmt));

                if (Balance >= writeoff )
                {
                    var sqlCMD = "INSERT INTO f_writeoff (TransactionID,PanelID,WriteOffAmount,WriteOffReason,EntryDateTime,EntryBy,IsActive,IsVerified,VerifiedBy,VerifiedOn)VALUES(@TransactionID,@PanelID,@WriteOffAmount,@WriteOffReason,NOW(),@EntryBy,1,1,@VerifiedBy,NOW())";
                    excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new {

                        TransactionID = ViewState["TransID"],
                        PanelID = lblPanelID.Text.Trim(),
                        WriteOffAmount=Util.GetString(txtWriteOff.Text.Trim()),
                        WriteOffReason=Util.GetString(txtReason.Text.Trim()),
                        EntryBy=Session["ID"].ToString(),
                        VerifiedBy = Session["ID"].ToString(),
                    });
                }
                else
                {
                    lblMsg.Text = "WriteOff Amount Is Not Greater then Total Amoumt";
                    return;
                }
                writeoff = Util.GetDecimal(StockReports.ExecuteScalar(" Select sum(WriteOffAmount) from f_writeoff where TransactionID='" + ViewState["TransID"] + "'"));

                var SqlCmdUpdate = "UPDATE patient_medical_history pmh SET pmh.WriteOff = pmh.WriteOff+@WriteOff,pmh.WriteOffRemarks=@WriteOffRemarks,pmh.Deduction_NonAcceptable=(IF(Deduction_NonAcceptable=0,0,Deduction_NonAcceptable-@WriteOff)) WHERE TransactionID=@TransactionID";

                excuteCMD.DML(tnx, SqlCmdUpdate, CommandType.Text, new
                {
                    WriteOff=Util.GetString(txtWriteOff.Text.Trim()),
                    WriteOffRemarks = Util.GetString(txtReason.Text.Trim()),
                    TransactionID = ViewState["TransID"]
                
                });


                lblMsg.Text = "Record Saved Sucessfully";

                tnx.Commit();

                clear();
                GetBillDetails();
                fillGrid();
            }
            else
            {
                if (txtWriteOff.Text == "" || Util.GetDecimal(txtWriteOff.Text)!=0)
                {

                    lblMsg.Text = "Please provide writeOff amount or you Entered zero amount";
                }
                else
                    lblMsg.Text = "Please provide reason or you entered zero amount";
                return;
            }
        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.Message;
            tnx.Rollback();
            con.Close();
            con.Dispose();


        }
    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {


        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();

        try
        {
            if (txtWriteOff.Text != "" && txtReason.Text != "" )
            {


                decimal oldwriteoff = Util.GetDecimal(StockReports.ExecuteScalar(" Select WriteOffAmount from f_writeoff where ID='" + ViewState["ID"] + "'"));

                    var sqlCMD = "Update  f_writeoff set WriteOffAmount=@WriteOffAmount,WriteOffReason=@WriteOffReason,UpdateBy=@UpdateBy,UpdateOn=NOW()  where ID=@ID";
                    excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                    {
                        UpdateBy=Session["ID"].ToString(),
                        ID = ViewState["ID"],
                        WriteOffAmount = Util.GetString(txtWriteOff.Text.Trim()),
                        WriteOffReason = Util.GetString(txtReason.Text.Trim()),
                        });

                  decimal  writeoff = Util.GetDecimal(StockReports.ExecuteScalar(" Select sum(WriteOffAmount) from f_writeoff where TransactionID='" + ViewState["TransID"] + "'"));
                 
                    var SqlCmdUpdate = "UPDATE patient_medical_history pmh SET pmh.WriteOff = pmh.WriteOff+@WriteOff-@OldWriteOff,pmh.Deduction_NonAcceptable=(IF(Deduction_NonAcceptable=0,0,Deduction_NonAcceptable-@WriteOff)) WHERE TransactionID=@TransactionID";
                    excuteCMD.DML(tnx, SqlCmdUpdate, CommandType.Text, new
                    {
                        OldWriteOff=oldwriteoff,
                        WriteOff = Util.GetString(txtWriteOff.Text.Trim()),
                        TransactionID = ViewState["TransID"]

                    });

                lblMsg.Text = "Record Updated Sucessfully";

                tnx.Commit();

                clear();
                GetBillDetails();
                fillGrid();
            }
            else
            {
                if (txtWriteOff.Text == "" || Util.GetDecimal(txtWriteOff.Text) != 0)
                {

                    lblMsg.Text = "Please provide writeOff amount or you Entered zero amount";
                }
                else
                    lblMsg.Text = "Please provide reason or you entered zero amount";
                return;
            }
        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.Message;
            tnx.Rollback();
            con.Close();
            con.Dispose();


        }
    }
    
    public void clear()
    {
        txtReason.Text = "";
        txtWriteOff.Text = "";
   
   
    }
}