using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using System.Linq;


public partial class Design_OPD_OPD_Refund : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtRecipt.Focus();
            DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(Session["RoleID"]), Util.GetString(Session["ID"]));
            ViewState["Authority"] = dtAuthority;

            txtHash.Text = Util.getHash();
            txtHash.Attributes.Add("style", "display:none");
            txtBarcode.Attributes.Add("onkeyup", "doClick('" + btnSearch.ClientID + "',event)");
            if (Request.QueryString["ReceiptNo"] != null)
            {
                txtRecipt.Text = Request.QueryString["ReceiptNo"].ToString();
                object obj = new object();
                EventArgs eArg = new EventArgs();
                btnSearch_Click(obj, eArg);


            }
        }
    }

    private bool checkAdjustment(string ReceiptNo)
    {
        int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_ledgertransaction lt INNER JOIN f_reciept rec ON lt.ledgertransactionno=rec.AsainstLedgerTnxNo WHERE rec.receiptno='" + ReceiptNo + "' AND ROUND(lt.NetAmount)<>ROUND(lt.adjustment)"));
        if (count > 0)
            return true;
        else
            return false;
    }

    #region btnSearch_Click Event
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        string ReceiptNo = "";
        DataTable dt;
        string sql = "";
        lblMsg.Text = "";

        if (checkAdjustment(txtRecipt.Text))
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM255','" + lblMsg.ClientID + "');", true);
            return;
        }
        ReceiptNo = txtRecipt.Text.Trim();
        var billNo = txtBillNo.Text.Trim();
        if (string.IsNullOrEmpty(ReceiptNo) && string.IsNullOrEmpty(billNo))
        {
            lblMsg.Text = "Please Enter Search Creteria";
            return;
        }
        sql = "SELECT dm.Name Doctor, pmh.PanelID, dm.DoctorID Doctor_ID, IFNULL(r.AmountPaid,0)AmountPaid, pm.PName, Get_Current_Age (pm.PatientID) Age, pm.PatientID, pmh.ScheduleChargeID, lt.BillNo, pmh.TransactionID, IFNULL(lt.LedgerTransactionNo,'')AsainstLedgerTnxNo, IFNULL(lt.IpNo, '') IpNo, lt.PatientType, lt.PaymentModeID FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo=ltd.LedgerTransactionNo INNER JOIN patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID LEFT JOIN   f_reciept r ON r.AsainstLedgerTnxNo=lt.LedgerTransactionNo WHERE ltd.TypeOfTnx IN ( 'OPD-LAB', 'OPD-PROCEDURE', 'OPD-OTHERS', 'OPD-BILLING', 'OPD-APPOINTMENT','OPD-Package' )  ";

        if (!string.IsNullOrEmpty(ReceiptNo))
            sql += "and R.ReceiptNo = '" + ReceiptNo + "' ";
        else
            sql += "and lt.BillNo = '" + billNo + "' ";



        dt = StockReports.GetDataTable(sql);

        if (dt != null && dt.Rows.Count > 0)
        {

            lblAmount.Text = Util.GetString(dt.Rows[0]["AmountPaid"]);
            lblCRNumber.Text = Util.GetString(dt.Rows[0]["PatientID"]);
            lblCRNumber.Attributes["Transaction_ID"] = Util.GetString(dt.Rows[0]["TransactionID"]);
            lblPatientType.Text = Util.GetString(dt.Rows[0]["PatientType"]);

            lblDOB.Text = Util.GetString(dt.Rows[0]["Age"]);
            lblName.Text = Util.GetString(dt.Rows[0]["PName"]);
            lblDoctor.Text = Util.GetString(dt.Rows[0]["Doctor"]);
            lblDoctor.Attributes["Doctor_ID"] = Util.GetString(dt.Rows[0]["Doctor_ID"]);
            lblDoctor.Attributes["Panel_ID"] = Util.GetString(dt.Rows[0]["PanelID"]);
            lblDoctor.Attributes["PaymentModeID"] = Util.GetString(dt.Rows[0]["PaymentModeID"]);
            // ViewState["ScheduleChargeID"] = Util.GetString(dt.Rows[0]["ScheduleChargeID"]);

            lblCRNumber.Attributes["ScheduleChargeID"] = Util.GetString(dt.Rows[0]["ScheduleChargeID"]);
            lblCRNumber.Attributes["ReceiptNo"] = ReceiptNo;
            lblCRNumber.Attributes["LedgerTransactionNo"] = Util.GetString(dt.Rows[0]["AsainstLedgerTnxNo"]);
            lblRefundAgainstBill.Text = Util.GetString(dt.Rows[0]["BillNo"]);
            if (dt.Rows[0]["IPNo"].ToString() != "")
            {
                lblIPDNo.Visible = true;
                // lblIPD.Visible = true;
                lblIPDNo.Text = dt.Rows[0]["IPNo"].ToString().Replace("ISHHI", "");
            }
            else
            {
                lblIPDNo.Visible = false;
                //  lblIPD.Visible = false;
                lblIPDNo.Text = "";
            }
            DataTable dtauth = (DataTable)ViewState["Authority"];
            if (dtauth.Rows.Count > 0)
            {
                if (dtauth.Rows[0]["IsLabReject"].ToString() == "1")
                {
                    sql = "SELECT r.ReceiptNo, DATE_FORMAT(lt.Date, '%d-%b-%Y') DATE, ltd.ItemName, ltd.ItemID, ltd.SubCategoryID, ltd.TnxTypeID, ltd.ConfigID, ltd.TypeOfTnx, SUBSTRING_INDEX(ltd.Quantity, '.', '1') Quantity, ltd.Amount, ltd.Rate, lt.NetAmount, lt.GrossAmount, lt.DiscountApproveBy, lt.DiscountReason, ltd.DiscountPercentage, ltd.DiscAmt, lt.GovTaxPer, (lt.GovTaxPer / 100) * Amount * ltd.Quantity AS GovTax, lt.LedgerTransactionNo, IF(ltd.IsRefund = 0, 'true', 'false') IsRefund, ltd.LedgerTnxID, lt.TransactionTypeID,IF((SELECT COUNT(*) FROM f_LedgerTnxDetail cr WHERE cr.LedgerTnxRefID=ltd.ID AND cr.IsVerified=1)>0,1,0) IsRemoveEntry FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo  INNER JOIN f_itemmaster im ON im.ItemID = ltd.ItemID LEFT JOIN patient_labinvestigation_opd plo ON im.Type_ID = plo.Investigation_ID and plo.ledgertnxid=ltd.id LEFT JOIN investigation_master inm ON plo.Investigation_ID = inm.Investigation_Id LEFT JOIN f_reciept r ON r.AsainstLedgerTnxNo = lt.LedgerTransactionNo WHERE ";


                    if (!string.IsNullOrEmpty(ReceiptNo))
                        sql += "ReceiptNo = '" + ReceiptNo + "' ";
                    else
                        sql += "lt.BillNo = '" + billNo + "' ";

                    sql += "AND ltd.IsRefund=0  AND IsPackage=0  AND ltd.IsVerified=1 AND ltd.TypeOfTnx NOT IN ('CR','DR') HAVING IsRemoveEntry=0 ";
                    dt = StockReports.GetDataTable(sql);

                }
                else
                {
                    sql = "SELECT r.ReceiptNo, DATE_FORMAT(lt.Date, '%d-%b-%Y') DATE, ltd.ItemName, ltd.ItemID, ltd.SubCategoryID, ltd.TnxTypeID, ltd.ConfigID, ltd.TypeOfTnx, SUBSTRING_INDEX(ltd.Quantity, '.', '1') Quantity, ltd.Amount, ltd.Rate, lt.NetAmount, lt.GrossAmount, lt.DiscountApproveBy, lt.DiscountReason, ltd.DiscountPercentage, ltd.DiscAmt, lt.GovTaxPer, (lt.GovTaxPer / 100) * Amount * ltd.Quantity AS GovTax, lt.LedgerTransactionNo, IF(ltd.IsRefund = 0, 'true', 'false') IsRefund, ltd.LedgerTnxID, lt.TransactionTypeID,IF((SELECT COUNT(*) FROM f_LedgerTnxDetail cr WHERE cr.LedgerTnxRefID=ltd.ID AND cr.IsVerified=1)>0,1,0) IsRemoveEntry FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo  INNER JOIN f_itemmaster im ON im.ItemID = ltd.ItemID LEFT JOIN patient_labinvestigation_opd plo ON im.Type_ID = plo.Investigation_ID AND plo.ledgertnxid = ltd.id LEFT JOIN investigation_master inm ON plo.Investigation_ID = inm.Investigation_Id  AND (plo.IsSampleCollected in ('N','R') OR inm.Type='N') LEFT JOIN f_reciept r ON r.AsainstLedgerTnxNo = lt.LedgerTransactionNo WHERE ";


                    if (!string.IsNullOrEmpty(ReceiptNo))
                        sql += "ReceiptNo = '" + ReceiptNo + "' ";
                    else
                        sql += "lt.BillNo = '" + billNo + "' ";
                    sql += "AND ltd.IsRefund=0  AND IsPackage=0 AND ltd.IsVerified=1 AND ltd.TypeOfTnx NOT IN ('CR','DR') HAVING IsRemoveEntry=0    ";
                    dt = StockReports.GetDataTable(sql);
                }
            }
            else
            {
                sql = "SELECT r.ReceiptNo, DATE_FORMAT(lt.Date, '%d-%b-%Y') DATE, ltd.ItemName, ltd.ItemID, ltd.SubCategoryID, ltd.TnxTypeID, ltd.ConfigID, ltd.TypeOfTnx, SUBSTRING_INDEX(ltd.Quantity, '.', '1') Quantity, ltd.Amount, ltd.Rate, lt.NetAmount, lt.GrossAmount, lt.DiscountApproveBy, lt.DiscountReason, ltd.DiscountPercentage, ltd.DiscAmt, lt.GovTaxPer, (lt.GovTaxPer / 100) * Amount * ltd.Quantity AS GovTax, lt.LedgerTransactionNo, IF(ltd.IsRefund = 0, 'true', 'false') IsRefund, ltd.LedgerTnxID, lt.TransactionTypeID,IF((SELECT COUNT(*) FROM f_LedgerTnxDetail cr WHERE cr.LedgerTnxRefID=ltd.ID AND cr.IsVerified=1)>0,1,0) IsRemoveEntry FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo  INNER JOIN f_itemmaster im ON im.ItemID = ltd.ItemID LEFT JOIN patient_labinvestigation_opd plo ON im.Type_ID = plo.Investigation_ID  AND plo.Ledgertnxid = ltd.id LEFT JOIN investigation_master inm ON plo.Investigation_ID = inm.Investigation_Id  AND (plo.IsSampleCollected IN ('N', 'R') OR inm.Type = 'N')  LEFT JOIN f_reciept r ON r.AsainstLedgerTnxNo = lt.LedgerTransactionNo WHERE ";


                if (!string.IsNullOrEmpty(ReceiptNo))
                    sql += "ReceiptNo = '" + ReceiptNo + "' ";
                else
                    sql += "lt.BillNo = '" + billNo + "' ";

                sql += "AND ltd.IsRefund=0  AND IsPackage=0 AND ltd.IsVerified=1 AND ltd.TypeOfTnx NOT IN ('CR','DR') HAVING IsRemoveEntry=0   ";
                dt = StockReports.GetDataTable(sql);
            }
            if (dt.Rows.Count == 0)
            {
                lblMsg.Text = "Wrong Receipt or Already Refunded";
                divToggle.Visible = false;
                return;
            }

            grdItemRate.DataSource = dt;
            grdItemRate.DataBind();
            divToggle.Visible = true;
            UserControl uc = (UserControl)Page.LoadControl("~/design/Controls/UCPayment.ascx");
            divPaymentUserControl.Controls.Add(uc);
            Page.ClientScript.RegisterStartupScript(this.GetType(), "PaymentControlInit", "$(function () { $paymentControlInit(function(){});});", true);
            Page.ClientScript.RegisterStartupScript(this.GetType(), "validateReg", "$(function () { validateRegistrationItem()});", true);

        }
        else
        {
            lblAmount.Text = "";
            lblCRNumber.Text = "";
            lblDOB.Text = "";
            lblName.Text = "";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            grdItemRate.DataSource = null;
            grdItemRate.DataBind();
            divToggle.Visible = false;
        }
    }
    #endregion

    #region grdItemRate_RowDataBound Event
    protected void grdItemRate_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            ((TextBox)e.Row.FindControl("txtRate")).Enabled = false;
            ((TextBox)e.Row.FindControl("txtDisc")).Enabled = false;

            var typeOfTnx = ((Label)e.Row.FindControl("lblTypeOfTnx")).Text.Trim();
            if (typeOfTnx == "OPD-LAB")
                ((TextBox)e.Row.FindControl("txtQuantity")).Enabled = false;
        }
    }
    #endregion

    #region ValidateRefundItem Function
    private static bool ValidateRefundItem(string ItemID, decimal Qty, string LdtNo, MySqlTransaction tnx)
    {
        DataTable dtValidate = StockReports.GetAuthorization(Util.GetInt(HttpContext.Current.Session["RoleID"].ToString()), HttpContext.Current.Session["ID"].ToString());

        int CanRefund = Util.GetInt(dtValidate.Rows[0]["CanRefundAfterResult"].ToString());
        if (CanRefund == 1)
            return true;

        int IsLabItem = 0;
        IsLabItem = Util.GetInt(StockReports.ExecuteScalar("select count(*) from f_configrelation cr inner join f_subcategorymaster sc on cr.CategoryID = sc.CategoryID and cr.ConfigID=3 inner join f_ledgertnxdetail ltd on ltd.SubCategoryID = sc.SubCategoryID and ltd.ItemID='" + ItemID + "' and ltd.LedgerTransactionNo ='" + LdtNo + "'"));
        if (IsLabItem > 0)
        {
            DataTable dt = new DataTable();

            dt = StockReports.GetDataTable("select pl.ID,pl.investigation_id from f_itemmaster im inner join f_ledgertnxdetail ltd on im.ItemID=ltd.ItemID  and ltd.SubCategoryID = im.SubCategoryID and ltd.ItemID='" + ItemID + "' and ltd.LedgerTransactionNo ='" + LdtNo + "' inner join patient_labinvestigation_opd pl on pl.Investigation_ID = im.Type_ID  and ltd.LedgerTransactionNo = pl.LedgerTransactionNo and Result_Flag=0 ;");

            if (dt.Rows.Count < Qty)
            {
                return false;
            }
            else
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update patient_labinvestigation_opd Set Investigation_ID='' ,investigation_old='" + dt.Rows[i]["investigation_id"] + "', LedgerTransactionNoOLD='" + LdtNo + "' where ID='" + dt.Rows[i]["ID"].ToString() + "' and LedgerTransactionNo ='" + LdtNo + "'");
                }
                return true;
            }
        }
        return true;
    }
    #endregion

    protected void txtBarCode_TextChanged(object sender, EventArgs e)
    {


    }

    public bool CheckSelectedItem()
    {
        foreach (GridViewRow gr in grdItemRate.Rows)
        {
            if (((CheckBox)gr.FindControl("chkItem")).Checked)
            {
                return true;
            }
        }
        return false;
    }

    protected void chkItem_CheckedChanged(object sender, EventArgs e)
    {
        bool flag = false;

        double totalAmt = 0, totalDis = 0;
        foreach (GridViewRow gr in grdItemRate.Rows)
        {
            if (((CheckBox)gr.FindControl("chkItem")).Checked)
            {
                if (Util.GetDouble(((TextBox)gr.FindControl("txtQuantity")).Text) == 0 || Util.GetDouble(((TextBox)gr.FindControl("txtQuantity")).Text) > Util.GetDouble(((Label)gr.FindControl("lblQuantity")).Text))
                {
                    ((CheckBox)gr.FindControl("chkItem")).Checked = false;
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM033','" + lblMsg.ClientID + "');", true);
                    return;
                }
                if (IsSampleCollected(Util.GetString(((Label)gr.FindControl("lblItemID")).Text), Util.GetString(lblCRNumber.Attributes["LedgerTransactionNo"])))
                {
                    ((CheckBox)gr.FindControl("chkItem")).Checked = false;
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM258','" + lblMsg.ClientID + "');", true);
                    return;
                }
                ((TextBox)gr.FindControl("txtQuantity")).Enabled = false;
                totalAmt += Convert.ToInt32(((TextBox)gr.FindControl("txtQuantity")).Text) * Convert.ToDouble(((TextBox)gr.FindControl("txtRate")).Text);
                totalDis += ((Convert.ToInt32(((TextBox)gr.FindControl("txtQuantity")).Text) * Convert.ToDouble(((TextBox)gr.FindControl("txtRate")).Text)) * Convert.ToDouble(((Label)gr.FindControl("lblDisPer")).Text)) / 100;
                flag = true;
            }
            else
            {
                ((TextBox)gr.FindControl("txtQuantity")).Enabled = true;
            }
        }
       
        if (flag)
            btnSearch.Enabled = false;
        else
            btnSearch.Enabled = true;
    }





    [WebMethod(EnableSession = true)]
    public static bool IsSampleCollected(string itemID, string ledgerTransactionNo)
    {
        DataTable dtValidate = StockReports.GetAuthorization(Util.GetInt(HttpContext.Current.Session["RoleID"].ToString()), HttpContext.Current.Session["ID"].ToString());

        int CanRefund = Util.GetInt(dtValidate.Rows[0]["CanRefundAfterResult"].ToString());
      
         if (CanRefund == 1)
            return false;

        string str = "SELECT count(*) FROM f_itemmaster im INNER JOIN f_ledgertnxdetail ltd ON im.ItemID = ltd.ItemID AND ltd.SubCategoryID = im.SubCategoryID AND ltd.ItemID = '" + itemID + "' AND ltd.LedgerTransactionNo = '" + ledgerTransactionNo + "' INNER JOIN patient_labinvestigation_opd pl ON pl.Investigation_ID = im.Type_ID AND ltd.LedgerTransactionNo = pl.LedgerTransactionNo INNER JOIN investigation_master imm ON imm.Investigation_ID=pl.Investigation_ID WHERE   IF(imm.Type='R',IsSampleCollected,'N') in ('Y','S') ";
        int flag = Util.GetInt(StockReports.ExecuteScalar(str));
        if (flag > 0)
            return true;
        else
            return false;
    }

    [WebMethod]
    public static bool IsConsulted(string ledgerTnxID)
    {

        string str = "SELECT ap.TemperatureRoom,ap.`P_IN` FROM f_ledgertnxdetail ltd INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=ltd.LedgerTransactionNo INNER JOIN appointment ap ON ap.LedgerTnxNo=lt.LedgerTransactionNo WHERE ltd.LedgerTnxID='" + ledgerTnxID + "'";
        DataTable dtAppStatus = StockReports.GetDataTable(str);
        int flag = Util.GetInt(dtAppStatus.Rows[0]["TemperatureRoom"]);
        if (flag > 0)
        {

            DataTable dtValidate = StockReports.GetAuthorization(Util.GetInt(HttpContext.Current.Session["RoleID"].ToString()), HttpContext.Current.Session["ID"].ToString());

            int CanRefund = Util.GetInt(dtValidate.Rows[0]["CanRefundAfterResult"].ToString());
      
             if (Util.GetInt(dtAppStatus.Rows[0]["P_IN"]) == 0 && CanRefund == 1)
                return false;
            else
                return true;
        }
        else
            return false;
    }




    [WebMethod(EnableSession = true)]
    public static string SaveRefund(object PMH, object LT, object LTD, object PaymentDetail, string oldLedgerTransactionNo, string oldReceiptNo, string refundReason)
    {
        try
        {
            GetEncounterNo Encounter = new GetEncounterNo();
            int EncounterNo = 0;

            List<Patient_Medical_History> dataPMH = new JavaScriptSerializer().ConvertToType<List<Patient_Medical_History>>(PMH);
            List<Ledger_Transaction> dataLT = new JavaScriptSerializer().ConvertToType<List<Ledger_Transaction>>(LT);
            List<LedgerTnxDetail> dataLTD = new JavaScriptSerializer().ConvertToType<List<LedgerTnxDetail>>(LTD);
            List<Ledger_Transaction_PaymentDetail> dataPaymentDetail = new JavaScriptSerializer().ConvertToType<List<Ledger_Transaction_PaymentDetail>>(PaymentDetail);
            if (HttpContext.Current.Session["ID"] != null)
            {
                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
                try
                {
                    string PatientID = string.Empty, TransactionId = string.Empty, BillNO = string.Empty, LedTxnID = string.Empty, ReceiptNo = string.Empty;

                    foreach (var item in dataLTD)
                    {
                        bool flag = ValidateRefundItem(Util.GetString(item.ItemID), Util.GetDecimal(item.Quantity), Util.GetString(oldLedgerTransactionNo), tnx);
                        if (!flag)
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "You Can't Delete the " + Util.GetString(item.ItemName) + " because Result is Generated" });
                        var str = "Select * from f_ledgertnxdetail where LedgerTnxID in (" + item.LedgerTnxID + ") and IsVerified=2";
                    }


                    BillNO = SalesEntry.genBillNo(tnx, Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()), con);

                    if (BillNO == string.Empty)
                    {
                        tnx.Rollback();
                        tnx.Dispose();
                        con.Close();
                        con.Dispose();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Bill No" });

                    }

                    PatientID = dataPMH[0].PatientID;
                    DataTable dataTableKinDetails = StockReports.GetDataTable("SELECT pmh.KinName,pmh.KinRelation,pmh.KinPhone,if(pmh.ReferralTypeID=0,1,pmh.ReferralTypeID) as ReferralTypeID FROM patient_medical_history pmh WHERE pmh.PatientID='" + dataPMH[0].PatientID + "'  ORDER BY pmh.TransactionID DESC LIMIT 1");


                    Patient_Medical_History objPmh = new Patient_Medical_History(tnx);
                    objPmh.PatientID = dataPMH[0].PatientID;
                    objPmh.DoctorID = Util.GetString(dataPMH[0].DoctorID);
                    objPmh.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                    objPmh.Time = Util.GetDateTime(DateTime.Now);
                    objPmh.DateOfVisit = Util.GetDateTime(DateTime.Now);
                    objPmh.Type = "OPD";
                    objPmh.PanelID = Util.GetInt(dataPMH[0].PanelID);
                    objPmh.ScheduleChargeID = Util.GetInt(dataPMH[0].ScheduleChargeID);
                    objPmh.HashCode = dataPMH[0].HashCode;
                    objPmh.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    objPmh.UserID = HttpContext.Current.Session["ID"].ToString();
                    objPmh.EntryDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                    objPmh.KinRelation = Util.GetString(dataTableKinDetails.Rows[0]["KinRelation"]);
                    objPmh.KinName = Util.GetString(dataTableKinDetails.Rows[0]["KinName"]);
                    objPmh.KinPhone = Util.GetString(dataTableKinDetails.Rows[0]["KinPhone"]);
                    objPmh.ReferralTypeID = Util.GetInt(dataTableKinDetails.Rows[0]["ReferralTypeID"]);
                    objPmh.BillNo = BillNO;
                    objPmh.BillDate = Util.GetDateTime(DateTime.Now);
                    objPmh.BillGeneratedBy = HttpContext.Current.Session["ID"].ToString();
                    objPmh.TotalBilledAmt = Util.GetDecimal(dataLT[0].GrossAmount) * -1;
                    objPmh.ItemDiscount = Util.GetDecimal(dataLT[0].DiscountOnTotal) * -1;
                    objPmh.NetBillAmount = Util.GetDecimal(dataLT[0].NetAmount) * -1;
                    TransactionId = objPmh.Insert();

                    if (TransactionId == string.Empty)
                    {
                        tnx.Rollback();
                        tnx.Dispose();
                        con.Close();
                        con.Dispose();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Patient Medical History" });

                    }


                    EncounterNo = Encounter.FindEncounterNo(dataPMH[0].PatientID);

                    if (EncounterNo == 0)
                    {
                        tnx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Encounter No." });

                    }
                    //Insert into LedgerTransaction single row effect;
                    Ledger_Transaction objLedTran = new Ledger_Transaction(tnx);
                    objLedTran.LedgerNoCr = "OPD003";
                    objLedTran.LedgerNoDr = "HOSP0001";
                    objLedTran.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                    objLedTran.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    objLedTran.UniqueHash = dataLT[0].UniqueHash;
                    objLedTran.TypeOfTnx = dataLT[0].TypeOfTnx;

                    objLedTran.Date = Util.GetDateTime(DateTime.Now);
                    objLedTran.Time = Util.GetDateTime(DateTime.Now);
                    objLedTran.BillNo = BillNO;
                    objLedTran.BillDate = Util.GetDateTime(DateTime.Now);
                    objLedTran.DiscountOnTotal = Util.GetDecimal(dataLT[0].DiscountOnTotal) * -1;
                    objLedTran.Adjustment = Util.GetDecimal(dataLT[0].Adjustment) * -1;
                    objLedTran.GrossAmount = Util.GetDecimal(dataLT[0].GrossAmount) * -1;
                    objLedTran.NetAmount = Util.GetDecimal(dataLT[0].NetAmount) * -1;
                    objLedTran.IsCancel = 0;
                    objLedTran.PaymentModeID = 1;
                    objLedTran.GovTaxAmount = Util.GetDecimal(dataLT[0].GovTaxAmount) * -1;
                    objLedTran.GovTaxPer = Util.GetDecimal(dataLT[0].GovTaxPer);



                    objLedTran.DiscountReason = dataLT[0].DiscountReason + (string.IsNullOrEmpty(oldReceiptNo) ? ". Old Bill No. : " + dataLT[0].Refund_Against_BillNo : ". Old Receipt No. : " + oldReceiptNo);
                    objLedTran.DiscountApproveBy = dataLT[0].DiscountApproveBy;
                    objLedTran.PanelID = Util.GetInt(dataLT[0].PanelID);
                    objLedTran.TransactionID = TransactionId;
                    objLedTran.UserID = HttpContext.Current.Session["ID"].ToString();
                    objLedTran.PatientID = dataLT[0].PatientID;

                    objLedTran.TransactionType_ID = Util.GetInt(dataLT[0].TransactionType_ID);
                    objLedTran.RoundOff = Util.GetDecimal(dataLT[0].RoundOff);
                    objLedTran.Refund_Against_BillNo = dataLT[0].Refund_Against_BillNo;
                    objLedTran.IPNo = dataLT[0].IPNo;
                    objLedTran.PatientType = dataLT[0].PatientType;
                    objLedTran.CurrentAge = dataLT[0].CurrentAge;
                    objLedTran.IpAddress = All_LoadData.IpAddress();
                    objLedTran.EncounterNo = EncounterNo;
                    LedTxnID = objLedTran.Insert();
                    if (LedTxnID == string.Empty)
                    {
                        tnx.Rollback();
                        tnx.Dispose();
                        con.Close();
                        con.Dispose();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Ledger Transaction" });

                    }




                    var packages= dataLTD.Where(i => i.ConfigID == 23).ToList();
                    packages.ForEach(p=> {
                        var TYPE_ID =StockReports.ExecuteScalar(" SELECT type_id FROM f_itemmaster WHERE itemid='" + p.ItemID + "'");
                        var str = "SELECT ltd.ItemID,ltd.SubCategoryID,ltd.ItemName,ltd.Rate,ltd.Quantity,ltd.DiscountPercentage, ltd.DiscAmt,ltd.TotalDiscAmt,ltd.Amount,ltd.NetItemAmt,ltd.ConfigID,ltd.TnxTypeID, ltd.TypeOfTnx,ltd.TransactionType_ID,ltd.LedgerTnxID,ltd.DoctorID,ltd.IsPackage FROM f_ledgertnxdetail ltd WHERE ltd.IsRefund=0 AND ltd.TypeOfTnx IN('OPD-Package') AND ltd.LedgerTransactionNo='" + p.LedgerTransactionNo + "' AND ltd.itemid='" + p.ItemID + "'";
                        str += " UNION ALL SELECT ltd.ItemID,ltd.SubCategoryID,ltd.ItemName,ltd.Rate,ltd.Quantity,ltd.DiscountPercentage, ltd.DiscAmt,ltd.TotalDiscAmt,ltd.Amount,ltd.NetItemAmt,ltd.ConfigID,ltd.TnxTypeID, ltd.TypeOfTnx,ltd.TransactionType_ID,ltd.LedgerTnxID,ltd.DoctorID,ltd.IsPackage FROM f_ledgertnxdetail ltd  WHERE ltd.IsRefund=0 AND ltd.TypeOfTnx IN('OPD-Package') AND ltd.LedgerTransactionNo='218' AND ispackage=1 AND ltd.packageid='" + TYPE_ID + "'";
                           var items = StockReports.GetDataTable(str).AsEnumerable().ToList();
                           dataLTD.Remove(p);
                           items.ForEach(i => {
                               dataLTD.Add(new LedgerTnxDetail {
                                   ItemID = i.Field<int>("ItemID").ToString(),
                                   SubCategoryID = i.Field<int>("SubCategoryID").ToString(),
                                  ItemName = i.Field<string>("ItemName").ToString(),
                                   Rate = Util.GetDecimal(i.Field<decimal>("Rate")),
                                   Quantity = Util.GetDecimal(i.Field<decimal>("Quantity")),
                                   DiscountPercentage = Util.GetDecimal(i.Field<decimal>("DiscountPercentage")),
                                   DiscAmt = Util.GetDecimal(i.Field<decimal>("DiscAmt")),
                                   TotalDiscAmt = Util.GetDecimal(i.Field<decimal>("TotalDiscAmt")),
                                   Amount = Util.GetDecimal(i.Field<decimal>("Amount")),
                                   NetItemAmt = Util.GetDecimal(i.Field<decimal>("NetItemAmt")),
                                   ConfigID = Util.GetInt(i.Field<int>("ConfigID")),
                                   TnxTypeID = Util.GetInt(i.Field<int>("TnxTypeID")),
                                   typeOfTnx = i.Field<string>("TypeOfTnx").ToString(),
                                   TransactionType_ID = Util.GetInt(i.Field<int>("TransactionType_ID")),
                                   LedgerTnxID = i.Field<string>("LedgerTnxID").ToString(),
                                   DoctorID = i.Field<int>("DoctorID").ToString(),
                                   IsPackage = Util.GetInt(i.Field<int>("IsPackage")),
                               });
                              
                           });
                    });

                 //   return "";
                    //insert into Ledger transaction details multiple row effect

                    LedgerTnxDetail objLTDetail = new LedgerTnxDetail(tnx);

                    foreach (var item in dataLTD)
                    {


                        objLTDetail.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
                        objLTDetail.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                        objLTDetail.LedgerTransactionNo = LedTxnID;
                        objLTDetail.ItemID = Util.GetString(item.ItemID);
                        objLTDetail.SubCategoryID = Util.GetString(item.SubCategoryID);
                        objLTDetail.ItemName = Util.GetString(item.ItemName);
                        objLTDetail.Rate = Util.GetDecimal(item.Rate);
                        objLTDetail.Quantity = Util.GetDecimal(item.Quantity) * -1;
                        objLTDetail.DiscountPercentage = Util.GetDecimal(item.DiscountPercentage);
                        objLTDetail.DiscAmt = Util.GetDecimal(item.DiscAmt) * -1;
                        objLTDetail.TotalDiscAmt = Util.GetDecimal(item.TotalDiscAmt) * -1;
                        objLTDetail.TransactionID = TransactionId;
                        objLTDetail.Amount = Util.GetDecimal(item.Amount) * -1;
                        objLTDetail.NetItemAmt = Util.GetDecimal(item.NetItemAmt) * -1;
                        // objLTDetail.TotalDiscAmt = Util.GetDecimal(item.TotalDiscAmt) * -1;//dlb
                        objLTDetail.UserID = HttpContext.Current.Session["ID"].ToString();
                        objLTDetail.DiscountReason = refundReason + (string.IsNullOrEmpty(oldReceiptNo) ? ". Old Bill No. : " + dataLT[0].Refund_Against_BillNo : ". Old Receipt No. : " + oldReceiptNo);
                        objLTDetail.DoctorID = Util.GetString(item.DoctorID);
                        objLTDetail.ConfigID = Util.GetInt(item.ConfigID);
                        objLTDetail.TnxTypeID = Util.GetInt(item.TransactionType_ID);
                        objLTDetail.IsPackage = Util.GetInt(item.IsPackage);
                        objLTDetail.pageURL = All_LoadData.getCurrentPageName();
                        objLTDetail.Type = "O";
                        objLTDetail.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                        objLTDetail.IpAddress = All_LoadData.IpAddress();
                        objLTDetail.typeOfTnx = dataLT[0].TypeOfTnx;
                        objLTDetail.roundOff = Util.GetDecimal(dataLT[0].RoundOff / dataLTD.Count);
                        objLTDetail.ServiceItemID = "0";
                        objLTDetail.IPDCaseTypeID = "0";
                        objLTDetail.RoomID = "0";
                        objLTDetail.IsVerified = 1;
                        int ID = objLTDetail.Insert();
                        if (ID == 0)
                        {
                            tnx.Rollback();
                            tnx.Dispose();
                            con.Close();
                            con.Dispose();
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Ledger Transaction" });
                        }
                        string sql = "update f_ledgertnxdetail set IsRefund = 1 where LedgerTnxID = '" + Util.GetString(item.LedgerTnxID) + "'";
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
                        if (Util.GetString(item.ItemID).Trim() == Util.GetString(Resources.Resource.RegistrationItemID).Trim())
                        {
                            sql = "UPDATE `patient_master` pm SET pm.`FeesPaid`=0 WHERE pm.`PatientID`='" + Util.GetString(dataLT[0].PatientID) + "'";
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
                        }

                        if (item.ConfigID == 3)
                        {
                            sql = " UPDATE `patient_labinvestigation_opd` plo SET  plo.`LedgerTransactionNo_Old`=plo.`LedgerTransactionNo` WHERE plo.`LedgertnxID`=(SELECT id FROM `f_ledgertnxdetail` ltd WHERE ltd.LedgerTnxID='" + Util.GetString(item.LedgerTnxID) + "')  ";
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
                        }

                      //   to delete the time slot alloted to this test
                        if (Resources.Resource.IsInvestigationAppointment == "1")
                        {
                            string ltdID = StockReports.ExecuteScalar("Select ID from f_ledgertnxdetail where LedgerTnxID = '" + Util.GetString(item.LedgerTnxID) + "' ");

                            sql = "DELETE FROM investigation_timeslot WHERE bookingid = '" + ltdID + "'";
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
                        }
                    }

                    AllUpdate objallupdate = new AllUpdate(tnx);
                    string UpdateFlag = objallupdate.UpdateLedgertnx(LedTxnID);
                    if (UpdateFlag != "0" && !string.IsNullOrEmpty(oldReceiptNo))
                    {
                        Receipt objReceipt = new Receipt(tnx);
                        objReceipt.Date = DateTime.Now;
                        objReceipt.Time = DateTime.Now;
                        objReceipt.AsainstLedgerTnxNo = LedTxnID;
                        objReceipt.LedgerNoCr = "OPD003";
                        objReceipt.AmountPaid = Util.GetDecimal(dataLT[0].Adjustment) * -1;

                        objReceipt.Reciever = HttpContext.Current.Session["ID"].ToString();
                        objReceipt.Depositor = dataPMH[0].PatientID;
                        objReceipt.TransactionID = TransactionId;
                        objReceipt.PanelID = Util.GetInt(dataPMH[0].PanelID);
                        objReceipt.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                        objReceipt.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                        objReceipt.UniqueHash = dataPMH[0].HashCode;
                        objReceipt.RoundOff = Util.GetDecimal(dataLT[0].RoundOff);
                        objReceipt.IpAddress = All_LoadData.IpAddress();
                        objReceipt.PaidBy = "PAT";
                        ReceiptNo = objReceipt.Insert().ToString();
                        if (ReceiptNo == string.Empty)
                        {
                            tnx.Rollback();
                            tnx.Dispose();
                            con.Close();
                            con.Dispose();
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Receipt" });
                        }


                        Receipt_PaymentDetail ObjReceiptPayment = new Receipt_PaymentDetail(tnx);
                        for (int i = 0; i < dataPaymentDetail.Count; i++)
                        {
                            ObjReceiptPayment.PaymentModeID = Util.GetInt(dataPaymentDetail[i].PaymentModeID);
                            ObjReceiptPayment.PaymentMode = Util.GetString(dataPaymentDetail[i].PaymentMode);
                            ObjReceiptPayment.Amount = Util.GetDecimal(dataPaymentDetail[i].Amount) * -1;
                            ObjReceiptPayment.ReceiptNo = ReceiptNo;
                            ObjReceiptPayment.PaymentRemarks = Util.GetString(dataPaymentDetail[i].PaymentRemarks);
                            ObjReceiptPayment.RefDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                            ObjReceiptPayment.RefNo = Util.GetString(dataPaymentDetail[i].RefNo);
                            ObjReceiptPayment.BankName = Util.GetString(dataPaymentDetail[i].BankName);
                            ObjReceiptPayment.C_Factor = Util.GetDecimal(dataPaymentDetail[i].C_Factor);
                            ObjReceiptPayment.S_Amount = Util.GetDecimal(dataPaymentDetail[i].S_Amount) * -1;
                            ObjReceiptPayment.S_CountryID = Util.GetInt(dataPaymentDetail[i].S_CountryID);
                            ObjReceiptPayment.S_Currency = Util.GetString(dataPaymentDetail[i].S_Currency);
                            ObjReceiptPayment.S_Notation = Util.GetString(dataPaymentDetail[i].S_Notation);
                            ObjReceiptPayment.currencyRoundOff = Util.GetDecimal(dataPaymentDetail[i].currencyRoundOff);
                            ObjReceiptPayment.swipeMachine = Util.GetString(dataPaymentDetail[i].swipeMachine);
                            ObjReceiptPayment.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                            ObjReceiptPayment.Hospital_ID = Util.GetString(HttpContext.Current.Session["HOSPID"].ToString());

                            string PaymentID = ObjReceiptPayment.Insert().ToString();
                            if (PaymentID == "")
                            {
                                tnx.Rollback();
                                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Receipt Payment Details" });
                            }
                        }
                    }

                    string sqlCmd = "insert into opd_refund (old_LedgerTransactionNo, new_LedgerTransactionNo, old_ReceiptNo, " +
                                    " New_ReceiptNo, PatientID, Refund_Amt, UserID,IsActive,Hospital_ID,centreID)	values " +
                                    " ('" + Util.GetString(oldLedgerTransactionNo) + "', '" + LedTxnID + "', '" + oldReceiptNo.Trim() + "', '" + ReceiptNo + "',  " +
                                    " '" + dataPMH[0].PatientID + "', '" + dataLT[0].Adjustment + "', '" + HttpContext.Current.Session["ID"].ToString() + "',1,'" + HttpContext.Current.Session["HOSPID"].ToString() + "', " +
                                    " '" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + "') ";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sqlCmd);
                    string sql1 = "update appointment set IsCancel=1,CancelDate=NOW(),CancelReason='" + refundReason.Trim() + "' where TransactionID = '" + Util.GetString(dataLT[0].TransactionID) + "'";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql1);


                   ExcuteCMD excuteCMD = new ExcuteCMD();
                    excuteCMD.DML(tnx, " CALL PostBillWiseDoctorShare(@TransactionID,@UserID,0) ", CommandType.Text, new
                    {
                        TransactionID = TransactionId,
                        UserID = HttpContext.Current.Session["ID"].ToString()

                    });

                    tnx.Commit();

                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully", LedgerTransactionNo = LedTxnID, isReceipt = string.IsNullOrEmpty(oldReceiptNo) ? false : true });
                }

                catch (Exception ex)
                {
                    tnx.Rollback();
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
                }
                finally
                {
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();
                }
            }
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Patient Medical History" });


        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
    }





}
