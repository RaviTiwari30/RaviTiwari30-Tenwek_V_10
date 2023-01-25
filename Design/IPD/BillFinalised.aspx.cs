using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web.UI;

public partial class Design_dup_d_IPDItemDiscount : System.Web.UI.Page
    {
    //private DataSet ds;
   // private string SubCategoryID, DisplayName;

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
            string TransactionID = "";
            if (Session["ID"] == null)
                Response.Redirect("~/Design/Default.aspx");
            else
                ViewState.Add("USERID", Session["ID"].ToString());

            if (Request.QueryString["TransactionID"] != null)
                TransactionID = Request.QueryString["TransactionID"].ToString();
            else if (Request.QueryString["TID"] != null)
                TransactionID = Request.QueryString["TID"].ToString();



            AllQuery AQ = new AllQuery();


            DataTable dt = AllLoadData_IPD.getIPDBillDetail(TransactionID);


            DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(Session["RoleID"]), Util.GetString(Session["ID"]));
            ViewState["Authority"] = dtAuthority;

            if (dt != null && dt.Rows.Count > 0)
            {
                if (dt.Rows[0]["BillNo"].ToString().Trim() != "")
                {
                    ViewState["BillNo"] = dt.Rows[0]["BillNo"].ToString();
                   

                    DataTable dtAuthoritys = (DataTable)ViewState["Authority"];
                    if (dt.Rows[0]["BillNo"].ToString().Trim() != "" && (dtAuthoritys != null && dtAuthoritys.Rows.Count > 0))
                    {
                        string Msg = "";

                        if (dtAuthoritys.Rows[0]["IsFinalise"].ToString() == "0")
                        {
                            Msg = "You Are Not Authorised To AMEND IPD Bills...";
                            //   Response.Redirect("../IPD/PatientFinalMsg.aspx?msg=" + Msg + "&TID=" + TransactionID);
                        }
                        else if (dtAuthoritys.Rows[0]["IsFinalise"].ToString() == "1" && dt.Rows[0]["IsBilledClosed"].ToString().Trim() == "1")
                        {
                            Msg = "Patient's Final Bill has been Closed for Further Updating...";
                            Response.Redirect("../IPD/PatientFinalMsg.aspx?msg=" + Msg + "&TID=" + TransactionID);
                        }
                    }
                    else if (dt.Rows[0]["BillNo"].ToString().Trim() != "" && (dtAuthoritys != null && dtAuthoritys.Rows.Count == 0))
                    {
                        string Msg = "";
                        Msg = "You Are Not Authorised To AMEND This IPD Bills...";
                        Response.Redirect("../IPD/PatientFinalMsg.aspx?msg=" + Msg + "&TID=" + TransactionID);
                    }
                }
            }
        //    decimal AmountBilled = Util.GetDecimal(AQ.d_GetBillAmount(Request.QueryString["TransactionID"].ToString()));
       //     decimal TotalDisc = Util.GetDecimal(StockReports.ExecuteScalar("Select (IFNULL(sum((Rate*Quantity)-Amount),0) + (Select IFNULL(DiscountOnBill,0) from d_f_ipdadjustment where TransactionID='" + TransactionID + "')) TotalDisc from d_f_ledgertnxdetail where TransactionID='" + TransactionID + "' and DiscountPercentage > 0  and isVerified=1 and isPackage=0"));

            decimal AmountBilled = Util.GetDecimal(AQ.GetBillAmount(Request.QueryString["TransactionID"].ToString()));
            decimal TotalDisc = Util.GetDecimal(StockReports.ExecuteScalar("Select (IFNULL(sum((Rate*Quantity)-Amount),0) + (Select IFNULL(DiscountOnBill,0) from patient_medical_history where TransactionID='" + TransactionID + "')) TotalDisc from f_ledgertnxdetail where TransactionID='" + TransactionID + "' and DiscountPercentage > 0  and isVerified=1 and isPackage=0"));//f_ipdadjustment

            AmountBilled = AmountBilled - TotalDisc;
            decimal AmountReceived = Util.GetDecimal(AQ.GetPaidAmount(Request.QueryString["TransactionID"].ToString()));
            lblBillAmount.Text = AmountBilled.ToString("f2");
            lblPaidAmount.Text = AmountReceived.ToString("f2");
            lblPID.Text = dt.Rows[0]["PatientID"].ToString();
            lblTID.Text = StockReports.getTransNobyTransactionID(dt.Rows[0]["TransactionID"].ToString());

            if (dt.Rows[0]["BillNo"].ToString().Trim() == "")
            {
                lblMsg.Text = "Please First Generate Bill No. ";
                btnGenerateBill.Enabled = false;
            }
            if (AllLoadData_IPD.getIPDBilledClosed(TransactionID) == 1)
            {
                lblMsg.Text = "Bill Already Finalised";
                btnGenerateBill.Enabled = false;
                return;
            }
        }
    }

    protected void btnGenerateBill_Click(object sender, EventArgs e)
        {
        string TID = Request.QueryString["TransactionID"].ToString();
        try
            {
            if (TID != "")
                {
                lblMsg.Text = "";
                AllQuery AQ = new AllQuery();
                decimal AmountBilled = Util.GetDecimal(AQ.d_GetBillAmount(Request.QueryString["TransactionID"].ToString()));
                if (UpdateBillingInfo( AmountBilled, TID, ViewState["USERID"].ToString()) != "")
                    {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "ak1", "alert('IPD No. : " + lblTID.Text+ " is Closed for further editing');", true);
                    // ScriptManager.RegisterStartupScript(this, this.GetType(), "ak2", "location.href='BillFinalised.aspx?TransactionID=" + TID + "';", true);
                    lblMsg.Text = "Bill has been Finalized";
                    btnGenerateBill.Enabled = false;
                }
                else
                {
                    lblMsg.Text = "Error occurred, Please contact administrator";
                }
            }
            else
            {
                lblMsg.Text = "Bill has not been Generated";
            }
        }
        catch (Exception ex)
        {
            ClassLog objErr = new ClassLog();
            objErr.errLog(ex);
        }
    }

    private string UpdateBillingInfo( decimal BillAmount, string PTransID, string UserID)
        {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
            {

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update patient_medical_history adj SET adj.IsBilledClosed=1,adj.TotalBilledAmt=" + BillAmount + ",adj.BillClosedUserId='" + UserID + "',adj.BillCloseddate=NOW()  where adj.TransactionID = '" + PTransID + "' ");//f_ipdadjustment
            //objSQL = "";
            //objSQL += "update f_Ledgertransaction SET BillNo = '" + BillNo + "',BillDate ='" + BillDate + "' ";
            //objSQL += "where TransactionID = '" + PTransID + "' and IFNULL(BillNo,'')=''";
            //MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, objSQL);
            tnx.Commit();

            return "1";
            }
        catch (Exception ex)
            {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
            }
        finally
            {
            tnx.Dispose();
            con.Close();
            con.Dispose();
            }
        }
    }