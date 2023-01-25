using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_IPD_IPDPatientBillDetails : System.Web.UI.Page
{
    #region Event Handling

    private string LedgerTnxID = string.Empty;

    private string[] str = null;
    private int isFirstLoad = 0;
    Boolean CanViewRate = false;
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
        lblMsg.Text = "";
        isFirstLoad++;
        if (!IsPostBack)
        {

            string TransID = string.Empty;
            if (Request.QueryString["TransactionID"] != null)
            {
                TransID = Request.QueryString["TransactionID"].ToString();
            }
            else if (Request.QueryString["TID"] != null)
            {
                TransID = Request.QueryString["TID"].ToString();
            }
            if (Resources.Resource.AllowFiananceIntegration == "1")//
            {
                if (AllLoadData_IPD.CheckDataPostToFinance(TransID) > 0)
                {
                    string Msga = "Patient's Final Bill Already Posted To Finance...";
                    Response.Redirect("PatientBillMsg.aspx?msg=" + Msga);
                }
            }
            string patientID = Util.GetString(Request.QueryString["PatientId"]);

            AllQuery AQ = new AllQuery();
            ViewState["TransID"] = TransID;
            lblTransactionID.Text = TransID;
            var estimationBillAmount = Util.GetDecimal(StockReports.ExecuteScalar(" SELECT r.TotalEstimate  FROM  f_costestimationbilling r WHERE r.PatientID='" + patientID + "' ORDER BY ID DESC LIMIT 1 "));
            lblEstimatedBillAmount.Text = estimationBillAmount.ToString();


          //  ScriptManager.RegisterStartupScript(this, this.GetType(), "ak21", "$bindBillDetails('" + TransID + "');", true);
            DataTable dt = AQ.GetPatientAdjustmentDetails(TransID);
            DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(Session["RoleID"]), Util.GetString(Session["ID"]));
            ViewState["Authority"] = dtAuthority;
            ViewState["dtBill"] = dt;
            ViewState["CanViewRate"] = "false";
            if (dt != null && dt.Rows.Count > 0)
            {
                if (dtAuthority.Rows.Count > 0)
                {
                    if (dtAuthority.Rows[0]["CanViewRate"].ToString() == "1")
                    {
                        CanViewRate = true;
                        tr_billdetail1.Visible = true; tr_billdetail2.Visible = true;
                        ViewState["CanViewRate"] = "true";
                    }
                }

                ViewState["BillNo"] = dt.Rows[0]["BillNo"].ToString();

                if (dt.Rows[0]["BillNo"].ToString().Trim() != "")
                {
                    DataTable dtAuthoritys = (DataTable)ViewState["Authority"];
                    if (dt.Rows[0]["BillNo"].ToString().Trim() != "" && (dtAuthoritys != null && dtAuthoritys.Rows.Count > 0))
                    {
                         string Msg = "";

                        if (dtAuthoritys.Rows[0]["BillChange"].ToString() == "0")
                        {
                            Msg = "You Are Not Authorised To AMEND IPD Bills...";
                            Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
                        }
                        else if (dtAuthoritys.Rows[0]["BillChange"].ToString() == "1" && dt.Rows[0]["IsBilledClosed"].ToString().Trim() == "1")
                        {
                            Msg = "Patient's Final Bill has been Closed for Further Updating...";
                            Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
                        }
                    }
                    else if (dt.Rows[0]["BillNo"].ToString().Trim() != "" && (dtAuthoritys != null && dtAuthoritys.Rows.Count == 0))
                    {
                        string Msg = "";
                        Msg = "You Are Not Authorised To AMEND This IPD Bills...";
                        Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
                    }

                }
            }
            lblTaxPer.Text = Util.GetDecimal(All_LoadData.GovTaxPer()).ToString();

            ViewState["UserID"] = Session["ID"].ToString();
            DateTime AdmDate = Util.GetDateTime(StockReports.ExecuteScalar("Select DateOfAdmit from patient_medical_history where TransactionID='" + TransID + "'"));//Ipd_case_history
            ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucFromDate.Text = AdmDate.ToString("dd-MMM-yyyy");
            calFromDate.StartDate = Util.GetDateTime(AdmDate.ToString("dd-MMM-yyyy"));
            calToDate.StartDate = Util.GetDateTime(AdmDate.ToString("dd-MMM-yyyy"));
            calFromDate.EndDate = DateTime.Now;
            //  calToDate.EndDate = DateTime.Now;
            GetBillDetails();
            BindDepartment();
            BindPackage();
            BindDiscountReason();
            DisableJobs();

            string ToAlert = StockReports.GetExpireApprovalAmountAlert(TransID);
            if (ToAlert != "" && Util.GetInt(ToAlert) >= 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "ak1", "alert('Maximum Allowed Panel Approval Amount Date Is Expiring In " + ToAlert + " Days Please Renew');", true);
            }
            else if (ToAlert != "" && Util.GetInt(ToAlert) < 0)
            {
                string Status = StockReports.ExecuteScalar("Select Status from patient_medical_history where TransactionID='" + TransID + "'");//ipd_case_history

                if (Status == "IN")
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "ak2", "alert('Maximum Allowed Panel Approval Amount Date Is Already Expired " + Util.GetInt(ToAlert) * -1 + " Days Ago Please Renew');", true);
            }
        }
        ucToDate.Attributes.Add("readOnly", "true");
        ucFromDate.Attributes.Add("readOnly", "true");
        CanViewRate = Util.GetBoolean(ViewState["CanViewRate"]);
    }

    private void BindDiscountReason()
    {
        string strDiscReason = "select ID,DiscountReason from discount_reason where Active=1 AND Type='IPD' order by DiscountReason ";
        DataTable DiscountReason = StockReports.GetDataTable(strDiscReason);
        if (DiscountReason.Rows.Count > 0)
        {
            ddlControlDiscountReason.DataTextField = "DiscountReason";
            ddlControlDiscountReason.DataValueField = "DiscountReason";
            ddlControlDiscountReason.DataSource = DiscountReason;
            ddlControlDiscountReason.DataBind();
            ddlControlDiscountReason.Items.Insert(0, "--Please Select Reason--");

            DisReason.DataTextField = "DiscountReason";
            DisReason.DataValueField = "DiscountReason";
            DisReason.DataSource = DiscountReason;
            DisReason.DataBind();
            DisReason.Items.Insert(0, "--Please Select Reason--");

            ddlDisReason.DataTextField = "DiscountReason";
            ddlDisReason.DataValueField = "DiscountReason";
            ddlDisReason.DataSource = DiscountReason;
            ddlDisReason.DataBind();
            ddlDisReason.Items.Insert(0, "--Please Select Reason--");


        }
        else
        {
            ddlControlDiscountReason.Items.Insert(0, "--Please Select Reason--");
            DisReason.Items.Insert(0, "--Please Select Reason--");
            ddlDisReason.Items.Insert(0, "--Please Select Reason--");
        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblFilterAmount.Text = "";
        GetBillDetails();
        BindDepartment();
        //BindDepartmentBySearch();
    }

    protected void gvDeptBill_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            if (e.CommandName == "imbView")
            {
                //Removing earlier color that is set in selected row
                foreach (GridViewRow gv in gvDeptBill.Rows)
                {
                    if (ViewState["OldColor"] != null && gv.BackColor.Name == "LightGreen")
                        gv.BackColor = System.Drawing.Color.FromName(ViewState["OldColor"].ToString());
                }

                string Category = Util.GetString(e.CommandArgument);
                ViewState["DispName"] = Category.Split('#')[0].ToString();
                ViewState["ConfigID"] = Category.Split('#')[1].ToString();
                int Rowindex = Util.GetInt(Category.Split('#')[2].ToString());
                ViewState["DisplayName"] = Category.Split('#')[3].ToString();
                //ViewState["IsFilter"] = false;

                if (gvDeptBill.Rows[Rowindex].BackColor.Name != "LightGreen")
                    ViewState["OldColor"] = gvDeptBill.Rows[Rowindex].BackColor.Name;

                gvDeptBill.Rows[Rowindex].BackColor = System.Drawing.Color.LightGreen;

                lblDept.Text = ((Label)gvDeptBill.Rows[Rowindex].FindControl("lblDisplayName")).Text;
                ShowItemDetails();
            }
            if (e.CommandName == "imbModify")
            {

                DataTable dt = GetPackage();
                if (dt != null && dt.Rows.Count > 0)
                {
                    gvPackage.DataSource = dt;
                    gvPackage.DataBind();
                    mpPackage.Show();

                    DisReason.SelectedIndex = DisReason.Items.IndexOf(DisReason.Items.FindByText(dt.Rows[0]["DiscReason"].ToString()));

                }
            }

            if (e.CommandName == "ImgLog")
            {
                foreach (GridViewRow gv in gvDeptBill.Rows)
                {
                    if (ViewState["OldColor"] != null && gv.BackColor.Name == "LightGreen")
                        gv.BackColor = System.Drawing.Color.FromName(ViewState["OldColor"].ToString());
                }

                string Category = Util.GetString(e.CommandArgument);
                ViewState["DispName"] = Category.Split('#')[0].ToString();
                ViewState["ConfigID"] = Category.Split('#')[1].ToString();
                int Rowindex = Util.GetInt(Category.Split('#')[2].ToString());
                ViewState["IsFilter"] = false;

                if (gvDeptBill.Rows[Rowindex].BackColor.Name != "LightGreen")
                    ViewState["OldColor"] = gvDeptBill.Rows[Rowindex].BackColor.Name;

                gvDeptBill.Rows[Rowindex].BackColor = System.Drawing.Color.LightGreen;
                lblDept.Text = ((Label)gvDeptBill.Rows[Rowindex].FindControl("lblDisplayName")).Text;
                BindLogDetail();
            }
        }
        catch(Exception ex)
        {
            var c1 = new ClassLog();
            c1.errLog(ex);
            lblMsg.Text = ex.Message.ToString();
        }
    }

    private void BindLogDetail()
    {
        if ((ViewState["TransID"] != null) && (ViewState["DispName"] != null))
        {
            string TransID = Convert.ToString(ViewState["TransID"]);
            string DispName = Convert.ToString(ViewState["DispName"]).ToUpper();
            string ConfigID = Convert.ToString(ViewState["ConfigID"]);

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT t.* FROM ");
            sb.Append(" (SELECT LedgerTnxID,tg_ID,'' DATETIME,ltd.tg_DateTime,ltd.TransactionID,ltd.itemname,ltd.ItemID,ltd.Rate,");
            sb.Append(" (select name from f_subcategorymaster where SubcategoryID=ltd.subcategoryid)subcategoryname,");
            sb.Append(" ltd.Amount,ltd.Quantity,ltd.DiscountPercentage,ltd.SubCategoryID, ");
            sb.Append(" Date_Format(ltd.EntryDate,'%d-%b-%y %h :%i%p')VerifiedDate,( SELECT CONCAT(Title,' ',NAME) FROM Employee_master");
            sb.Append(" WHERE Employee_ID=ltd.UserID)User_ID,ltd.DiscountReason,ltd.CancelReason,");
            sb.Append(" (SELECT CONCAT(Title,' ',NAME) FROM Employee_master ");
            sb.Append(" WHERE Employee_ID=ltd.CancelUserId)CancelUserId,Date_Format(ltd.CancelDateTime,'%d-%b-%y %h:%i %p')CancelDateTime,Date_Format(IF(ltd.Updateddate='0001-01-01','',ltd.Updateddate),'%d-%b-%y %h :%i%p')Updateddate,((ltd.Rate*ltd.Quantity)-ltd.Amount)DiscAmt,");
            sb.Append(" ( SELECT CONCAT(Title,' ',NAME) FROM Employee_master WHERE Employee_ID=ltd.LastUpdatedBy)");
            sb.Append(" LastUpdatedBy,( SELECT CONCAT(Title,' ',NAME) FROM Employee_master WHERE ");
            sb.Append(" Employee_ID=ltd.DiscUserID)DiscUserID FROM hospedia_log.f_ledgertnxdetail_before_update ltd INNER JOIN ");
            sb.Append(" f_ledgertransaction LT ON ltd.LedgerTransactionNo = LT.LedgerTransactionNo  ");
            sb.Append(" INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID = ltd.SubCategoryID ");
            sb.Append(" INNER JOIN f_configrelation cf ON sm.CategoryID = cf.CategoryID ");
            sb.Append(" WHERE lt.TransactionID='" + ViewState["TransID"].ToString() + "'  AND sm.CategoryID = '" + DispName.Replace("'", "''") + "' ");

            sb.Append(" union all");
            sb.Append(" SELECT LedgerTnxID,'0' tg_ID,IF(ltd1.Isverified=1,IF(ltd1.Updateddate='0001-01-01','',ltd1.Updateddate),   ");
            sb.Append(" IF(ltd1.CancelDateTime='0001-01-01','',ltd1.CancelDateTime))DATETIME,NOW() tg_DateTime,ltd1.TransactionID,ltd1.itemname,ltd1.ItemID,ltd1.Rate,");
            sb.Append(" (SELECT NAME FROM f_subcategorymaster    WHERE  SubcategoryID=ltd1.subcategoryid)subcategoryname, ");
            sb.Append(" ltd1.Amount,ltd1.Quantity, ltd1.DiscountPercentage,ltd1.SubCategoryID,");
            sb.Append(" DATE_FORMAT(ltd1.EntryDate,'%d-%b-%y %h :%i%p')  VerifiedDate,( SELECT CONCAT(Title,' ',NAME) FROM ");
            sb.Append(" Employee_master  WHERE EmployeeID= ltd1.UserID)User_ID,ltd1.DiscountReason,ltd1.CancelReason,");
            sb.Append(" (SELECT CONCAT(Title,' ',NAME)  FROM Employee_master    WHERE EmployeeID=ltd1.CancelUserId)CancelUserId,");
            sb.Append(" DATE_FORMAT( ltd1.CancelDateTime,'%d-%b-%y %h:%i %p')CancelDateTime,");
            sb.Append(" 	DATE_FORMAT(IF(ltd1.Updateddate='0001-01-01','',ltd1.Updateddate),'%d-%b-%y %h :%i%p')Updateddate ,");
            sb.Append(" ((ltd1.Rate*ltd1.Quantity)-ltd1.Amount)DiscAmt,( SELECT CONCAT(Title,' ',NAME) FROM Employee_master ");
            sb.Append(" WHERE EmployeeID=ltd1.LastUpdatedBy)LastUpdatedBy,( SELECT CONCAT(Title,' ',NAME) FROM Employee_master  ");
            sb.Append(" WHERE    EmployeeID=ltd1.DiscUserID) DiscUserID FROM f_ledgertnxdetail ltd1 INNER JOIN    ");
            sb.Append(" f_ledgertransaction LT1 ON  ltd1.LedgerTransactionNo = LT1.LedgerTransactionNo     INNER JOIN ");
            sb.Append(" f_subcategorymaster sm1 ON  sm1.SubCategoryID = ltd1.SubCategoryID    INNER JOIN ");
            sb.Append(" f_configrelation cf1 ON sm1.CategoryID = cf1.CategoryID WHERE lt1.TransactionID='" + ViewState["TransID"].ToString() + "'  AND sm1.CategoryID = '" + DispName.Replace("'", "''") + "' and ltd1.IsVerified IN(1,2) )t");
            sb.Append(" ORDER BY t.ItemID,LedgerTnxID,t.tg_DateTime,tg_id DESC ");
            //sb.Append(" ORDER BY t.ItemID,tg_id desc ");

            DataTable dtLog = new DataTable();
            dtLog = StockReports.GetDataTable(sb.ToString());
            if (dtLog.Rows.Count > 0)
            {
                dtLog.Columns.Add("Status");
                string LedTnxID = "";
                foreach (DataRow row in dtLog.Rows)
                {
                    if (row["LedgerTnxID"].ToString() != LedTnxID)
                    {
                        LedTnxID = row["LedgerTnxID"].ToString();

                        DataRow[] drExist = dtLog.Select("LedgerTnxID='" + row["LedgerTnxID"].ToString() + "'");

                        if (drExist.Length > 0)
                        {
                            int iCtr = 0;
                            foreach (DataRow dr1 in drExist)
                            {
                                iCtr += 1;
                                if (iCtr < drExist.Length)
                                    dr1["Status"] = iCtr.ToString() + " - P";
                                else
                                    dr1["Status"] = iCtr.ToString() + " - C";
                            }
                        }
                    }
                }
                dtLog.AcceptChanges();

                grdLog.DataSource = dtLog;
                grdLog.DataBind();
                MDPLog.Show();
            }
            else
            {
                lblMsg.Text = "Record Not Found";
            }
        }
    }

    protected void grdLog_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.Header)
        {
            str = new string[e.Row.Cells.Count];
        }

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblLedgerTnxID")).Text.Trim() == LedgerTnxID)
            {
                //if (Amount != Util.GetDecimal(((Label)e.Row.FindControl("lblAmount")).Text))
                //{
                //    e.Row.Cells[8].BackColor = System.Drawing.Color.Red;
                //}

                for (int i = 1; i < e.Row.Cells.Count; i++)
                {
                    if (str[i].ToString() != e.Row.Cells[i].Text)
                    {
                        e.Row.Cells[i].BackColor = System.Drawing.Color.Red;
                    }
                }

                for (int i = 0; i < e.Row.Cells.Count; i++)
                {
                    str[i] = e.Row.Cells[i].Text;
                }
            }
            else
            {
                LedgerTnxID = ((Label)e.Row.FindControl("lblLedgerTnxID")).Text;
                // Amount = Util.GetDecimal(((Label)e.Row.FindControl("lblAmount")).Text);
                for (int i = 0; i < e.Row.Cells.Count; i++)
                {
                    //if (e.Row.Cells[i].Text != null)
                    //{
                    str[i] = e.Row.Cells[i].Text;
                    // }
                }
            }

            if (((Label)e.Row.FindControl("lblUpdate")).Text != "")
            {
                //e.Row.CssClass = "GridViewResultItemStyle";
                e.Row.BackColor = System.Drawing.Color.Pink;
            }

            int flag = 0;

            if (((Label)e.Row.FindControl("lblReject")).Text != "")
            {
                e.Row.BackColor = System.Drawing.Color.LightYellow;
                flag = 1;
            }
            if (((Label)e.Row.FindControl("lblDiscount")).Text != "")
            {
                if (flag != 1)
                {
                    e.Row.BackColor = System.Drawing.Color.LightGreen;
                }
            }
        }
    }

    protected void gvDeptBill_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        DataTable dtAuthoritys = (DataTable)ViewState["Authority"];
        DataTable dt = (DataTable)ViewState["dtBill"];

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (dt.Rows[0]["IsBillFreezed"].ToString() == "1" && (dtAuthoritys != null && dtAuthoritys.Rows.Count > 0))
            {
                if (dtAuthoritys.Rows[0]["BillChange"].ToString() == "0")
                {
                    ((ImageButton)e.Row.FindControl("imbView")).Visible = false;
                    ((ImageButton)e.Row.FindControl("imbModify")).Visible = false;
                }
                else if (dtAuthoritys.Rows[0]["BillChange"].ToString() == "1" && dt.Rows[0]["IsBilledClosed"].ToString().Trim() == "1")
                {
                    ((ImageButton)e.Row.FindControl("imbView")).Visible = false;
                    ((ImageButton)e.Row.FindControl("imbModify")).Visible = false;
                }
            }
            else if (dt.Rows[0]["IsBillFreezed"].ToString().Trim() == "1" && (dtAuthoritys != null && dtAuthoritys.Rows.Count == 0))
            {
                ((ImageButton)e.Row.FindControl("imbView")).Visible = false;
                ((ImageButton)e.Row.FindControl("imbModify")).Visible = false;
            }
        }
    }

    protected void gvItemDetail_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Reject")
        {
            string strLtNo = Util.GetString(e.CommandArgument);
            string IsSurgery = strLtNo.Split('#')[1].ToUpper();

            lblIsSurgery.Text = IsSurgery;
            lblLedTnxNo.Text = strLtNo.Split('#')[2].ToUpper();
            lblLedTnxID.Text = strLtNo.Split('#')[0].ToUpper();

            mpeRejection.Show();
        }
        if (e.CommandName == "AEdit")
        {
            int Index = Util.GetInt(e.CommandArgument);
            GridViewRow row = gvItemDetail.Rows[Index];

            if (row != null)
            {

                lblLTNo.Text = ((Label)row.FindControl("lblLedgerTransactionNo")).Text;
                lblLtdNo.Text = ((Label)row.FindControl("lblLedTnxNo")).Text;
                lblEItem.Text = ((Label)row.FindControl("lblItem")).Text;
                txtERate.Text = ((Label)row.FindControl("lblRate")).Text;
                txtEQty.Text = ((Label)row.FindControl("lblQty")).Text;
                txtEDiscPer.Text = ((Label)row.FindControl("lblDiscPer")).Text;
                txtEDiscAmt.Text = ((Label)row.FindControl("lblDiscAmt")).Text;
                string configID = ((Label)row.FindControl("lblconfigid")).Text;
                if (configID == "3")
                    txtEQty.Enabled = false;
                else
                    txtEQty.Enabled = true;
                int payable = Util.GetInt(((Label)row.FindControl("lblisPayable")).Text);
                if (payable == 1)
                    chkNonPayable.Checked = true;
                else
                    chkNonPayable.Checked = false;
                string strDiscReason = "SELECT DiscountReason FROM f_LedgertnxDetail WHERE LedgerTnxID='" + lblLtdNo.Text + "' ";
                DataTable DiscountReason = StockReports.GetDataTable(strDiscReason);
                if (DiscountReason.Rows.Count > 0)
                {
                    ddlControlDiscountReason.SelectedIndex = ddlControlDiscountReason.Items.IndexOf(ddlControlDiscountReason.Items.FindByText(DiscountReason.Rows[0]["DiscountReason"].ToString()));
                }

                txtERate.ReadOnly = true;
                txtEQty.ReadOnly = true;
                txtEDiscPer.ReadOnly = true;
                txtEDiscAmt.ReadOnly = true;
                if (lblPanelID.Text == "1")
                {
                    chkNonPayable.Enabled = false;
                }
                if (txtERate.Text == "0.0")
                {
                    string str = "select * from f_itemmaster im inner join f_subcategorymaster sc on im.subcategoryid=sc.subcategoryid inner join f_configrelation con on con.categoryid=sc.categoryid where im.itemid='" + ((Label)row.FindControl("lblItemID")).Text + "' and sc.displayname='Medicine & Consumables' and con.ConfigID <> 11 ";
                    DataTable dt = StockReports.GetDataTable(str);

                    txtERate.ReadOnly = false;
                    if (dt.Rows.Count <= 0)
                    {
                        ViewState["RateChange"] = "true";
                        StringBuilder sb = new StringBuilder();
                        sb.Append(" SELECT lt.LedgerTnxID,lt.TransactionID,lt.ItemID,lt.ItemName,lt.Rate,lt.Quantity,lt.amount,(SELECT NAME FROM ipd_case_type_master WHERE ipdcasetypeid=pip.IPDCaseTypeID)IPDCaseTypeID,pip.Room_ID,lt.PanelID,lt.ScheduleChargeID ");
                        sb.Append(" FROM  ( ");
                        sb.Append(" SELECT lt.Date,lt.Time,ltd.EntryDate,lt.TransactionID,ltd.ItemID,ltd.ItemName,ltd.Rate,ltd.Quantity ");
                        sb.Append(" ,ltd.Amount,ltd.LedgerTnxID,pmh.PanelID,pmh.ScheduleChargeID FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ON  ");
                        sb.Append(" lt.LedgerTransactionNo = ltd.LedgerTransactionNo LEFT JOIN patient_medical_history pmh ON ltd.TransactionID = pmh.TransactionID ");
                        sb.Append(" WHERE ltd.LedgerTnxID='" + lblLtdNo.Text.Trim() + "')lt  LEFT JOIN patient_ipd_profile pip ");
                        sb.Append(" ON lt.TransactionID = pip.TransactionID  ");
                        sb.Append(" AND lt.date >  CONCAT(pip.StartDate,' ',pip.StartTime) ");
                        sb.Append(" AND lt.date <=  IF(CONCAT(pip.EndDate,' ',pip.EndTime)='0001-01-01 00:00:00',NOW(),CONCAT(pip.EndDate,' ',pip.EndTime)) ");

                        DataTable dtnew = StockReports.GetDataTable(sb.ToString());
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "alert('The Rate You Are Setting Here Will Also Update The Rate For Item :" + ((Label)row.FindControl("lblItem")).Text + " For RoomType :" + dtnew.Rows[0]["IPDCaseTypeID"].ToString() + " ')", true);
                        chkSetRate.Visible = true;
                    }

                }
                else
                {

                    ViewState["RateChange"] = "false";
                    chkSetRate.Visible = false;
                }

                DataTable Authority = (DataTable)ViewState["Authority"];

                if (Authority.Rows.Count > 0)
                {
                    if (Authority.Rows[0]["IsEdit"].ToString() == "1")
                    {
                        txtERate.ReadOnly = false;
                        txtEQty.ReadOnly = false;
                    }

                    if (Authority.Rows[0]["IsDiscount"].ToString() == "1")
                    {
                        txtEDiscPer.ReadOnly = false;
                        txtEDiscAmt.ReadOnly = false;
                    }
                }
                if ((((Label)row.FindControl("lblTypeOfTnx")).Text) == "Sales")
                {
                    txtEDiscAmt.Enabled = false;
                    ddlControlDiscountReason.Enabled = false;
                    txtEDiscPer.Enabled = false;
                }
                mpEdit.Show();
            }
        }
    }

    protected void chkItem_CheckedChanged(object sender, EventArgs e)
    {
        for (int i = 0; i < gvItemDetail.Rows.Count; i++)
            ((CheckBox)gvItemDetail.Rows[i].FindControl("ChkSelect")).Checked = chkItem.Checked;
    }

    protected void gvPackage_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Reject")
        {
            if (RejectItems(string.Empty, "'" + Util.GetString(e.CommandArgument) + "'", ""))
            {
                // Removing all the Items that are already in this Rejected Package
                DataTable dt = StockReports.GetDataTable("SELECT ltd.ItemID,ltd.TransactionID,ltd.SubCategoryID FROM f_ledgertnxdetail ltd INNER JOIN  f_itemmaster im ON " +
                "ltd.ItemID = im.ItemID INNER JOIN f_subcategorymaster sc ON im.SubCategoryID = sc.SubCategoryID " +
                "INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID WHERE ltd.LedgerTnxID in ('" + Util.GetString(e.CommandArgument) + "') " +
                "AND cf.ConfigID=14 ");

                if (dt != null && dt.Rows.Count > 0)
                {
                    DataTable dtType = StockReports.GetDataTable("Select Patient_Type,PanelID from patient_medical_history where TransactionID= '" + dt.Rows[0]["TransactionID"].ToString() + "'");

                    MySqlConnection con = Util.GetMySqlCon();
                    con.Open();
                    MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

                    try
                    {
                        foreach (DataRow row in dt.Rows)
                        {
                            GetDiscount ds = new GetDiscount();
                            decimal DiscPerc = ds.GetDefaultDiscount(row["SubCategoryID"].ToString(), Util.GetInt(dtType.Rows[0]["PanelID"].ToString()), Util.GetDateTime(DateTime.Now.ToString()), dtType.Rows[0]["Patient_Type"].ToString(), "IPD");

                            string str = "Update f_ledgertnxdetail ";
                            str += " Set Amount=(GrossAmount)-(((GrossAmount)*" + DiscPerc + ")/100),";
                            str += " NetItemAmt =(GrossAmount)-(((GrossAmount)*" + DiscPerc + ")/100),";
                            str += " DiscountPercentage=" + DiscPerc + ",";
                            str += " DiscAmt=(((GrossAmount) * " + DiscPerc + ") / 100), IsPackage=0,PackageID='', ";
                            str += " TotalDiscAmt=(((GrossAmount) * " + DiscPerc + ") / 100),";
                            str += " LastUpdatedBy = '" + ViewState["UserID"] + "' ";
                            str += " ,Updateddate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "' ";
                            str += " ,IpAddress = '" + Util.GetString(All_LoadData.IpAddress()) + "' ";
                            str += " Where TransactionID='" + row["TransactionID"].ToString() + "' ";
                            str += " and PackageID='" + row["ItemID"].ToString() + "'";
                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
                            string ltdid = Util.GetString(StockReports.ExecuteScalar("SELECT GROUP_CONCAT(CONCAT('''',ltd.LedgerTnxID,'''')) FROM f_ledgertnxdetail ltd  WHERE ltd.TransactionID='"+  row["TransactionID"].ToString() +"'  AND ltd.PackageID='"+ row["ItemID"].ToString() +"' "));
                            if (ltdid != string.Empty)
                                CalcaluteDoctorShare(ltdid, Tranx, con);
                        }
                        Tranx.Commit();
                        Tranx.Dispose();
                        con.Close();
                        con.Dispose();
                    }
                    catch (Exception ex)
                    {
                        var c1 = new ClassLog();
                        c1.errLog(ex);
                        Tranx.Rollback();
                        Tranx.Dispose();
                        con.Close();
                        con.Dispose();
                    }
                }

                dt = new DataTable();
                dt = GetPackage();
                if (dt != null && dt.Rows.Count > 0)
                {
                    gvPackage.DataSource = dt;
                    gvPackage.DataBind();
                    ddlPackage.DataSource = dt;
                    ddlPackage.DataTextField = "TypeName";
                    ddlPackage.DataValueField = "ItemID";
                    ddlPackage.DataBind();
                    ddlPackage.Items.Insert(0, new ListItem("No Package", "0"));
                    btnPackage.Enabled = true;
                    BindDepartment();
                    mpPackage.Show();
                }
                else
                {
                    lblMsg.Text = "No Package Found";
                    ddlPackage.Items.Clear();
                    btnPackage.Enabled = false;
                }
            }
            else
                lblMsg.Text = "Error";
        }
    }

    protected void btnPackageSave_Click(object sender, EventArgs e)
    {
        bool status = true;
        foreach (GridViewRow row in gvPackage.Rows)
            if (((CheckBox)row.FindControl("chkPackage")).Checked)
            {
                status = false;
                if (Util.GetDecimal(((TextBox)row.FindControl("txtAmount")).Text) <= 0)
                {
                    lblMsg.Text = "Please Specify Amount";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('" + lblMsg.Text + "', function () { });", true);
                    return;
                }
            }
        if (status)
        {
            lblMsg.Text = "Please Select Package";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('" + lblMsg.Text + "', function () { });", true);
            return;
        }

        //  bool Result = false;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            foreach (GridViewRow Prow in gvPackage.Rows)
                if (((CheckBox)Prow.FindControl("chkPackage")).Checked)
                {

                    //   decimal Amount = Util.GetDecimal(((TextBox)Prow.FindControl("txtamount")).Text) - (Util.GetDecimal(((TextBox)Prow.FindControl("txtAmount")).Text) * (Util.GetDecimal(((TextBox)Prow.FindControl("txtdiscount")).Text))) / 100;
                    decimal Quantity = 1; //Util.GetDecimal(((Label)Prow.FindControl("lblQuantity")).Text);
                    decimal Rate = Util.GetDecimal(((TextBox)Prow.FindControl("txtAmount")).Text);
                    decimal discount = Util.GetDecimal(((TextBox)Prow.FindControl("txtdiscount")).Text);
                    decimal Amount = Util.GetDecimal(Rate * Quantity) - Util.GetDecimal((Rate * Quantity * discount) / 100);
                    decimal DiscAmt = 0;
                    if (Rate > 0 && (Util.GetDecimal(discount) > 0))
                        DiscAmt = Util.GetDecimal(Util.GetDecimal(Rate * Quantity) * Util.GetDecimal(discount) / 100);

                    string sql = "update f_ledgertnxdetail set GrossAmount="+ Rate +",Rate = " + Rate + " "
                    + " ,Amount = " + Amount + ""
                    + " ,NetItemAmt=" + Amount + ""
                    + " ,LastUpdatedBy = '" + ViewState["UserID"] + "' "
                    + " ,Updateddate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "' "
                    + " ,IpAddress = '" + Util.GetString(All_LoadData.IpAddress()) + "' "
                    + " ,DiscountPercentage='" + discount + "' "
                    + " ,DiscAmt=" + DiscAmt + " "
                    + " ,TotalDiscAmt=" + DiscAmt + " "
                    + " ,DiscountReason='" + DisReason.SelectedValue + "' "

                    + " where LedgerTnxID = '" + ((ImageButton)Prow.FindControl("imbReject")).CommandArgument + "' ";

                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sql);
                    CalcaluteDoctorShare(((ImageButton)Prow.FindControl("imbReject")).CommandArgument, Tranx, con);
                }
            Tranx.Commit();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            BindDepartment();
            GetBillDetails();
            lblMsg.Text = "Package Updated.";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('" + lblMsg.Text + "', function () { });", true);

        }
        catch (Exception ex)
        {
            var c1 = new ClassLog();
            c1.errLog(ex);
            Tranx.Rollback();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            lblMsg.Text = "Error...";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('" + lblMsg.Text + "', function () { });", true);
        }

    }

    protected void btnEditSave_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = new MySqlConnection(Util.GetConString());
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        string str = string.Empty;
        decimal amount = 0; decimal DiscAmt = 0;
        string Ratechange = "false";



        //max Discount Validation
        decimal discountPercent = Util.GetDecimal(txtEDiscPer.Text);

        if (discountPercent<=0)
               discountPercent= Util.GetDecimal((Util.GetDecimal(txtEDiscAmt.Text.Trim()) * 100) / (Util.GetDecimal(txtERate.Text.Trim()) * Util.GetDecimal(txtEQty.Text.Trim())));


        string userID = HttpContext.Current.Session["ID"].ToString();
        var maxEligibleDiscountPercent = Util.round(All_LoadData.GetEligiableDiscountPercent(userID));

        var message = AllGlobalFunction.maxDiscountValidationErrorMessage + maxEligibleDiscountPercent + "</b>";



        if (discountPercent > maxEligibleDiscountPercent) {
            Page.ClientScript.RegisterStartupScript(this.GetType(), "AuthorizationScript56", "$(function () { modelAlert('" + message + "')  });", true);
            return ;
        }
        
        //max Discount Validation



        if (txtEditReason.Text.Trim() == "")
        {
            lblMsg.Text = "Please Enter Edit Reason.";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('" + lblMsg.Text + "', function () { });", true);
            return;
        }
        if (Util.GetDecimal(txtEDiscAmt.Text) > 0 && ddlControlDiscountReason.SelectedIndex == 0)
        {
            lblMsg.Text = "Please Select Discount Reason.";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('" + lblMsg.Text + "', function () { });", true);
            return;
        }
        else if (Util.GetDecimal(txtEDiscPer.Text) > 0 && ddlControlDiscountReason.SelectedIndex == 0)
        {
            lblMsg.Text = "Please Select Discount Reason.";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('" + lblMsg.Text + "', function () { });", true);
            return;
        }

        if (ViewState["RateChange"] != null)
        {
            Ratechange = "false";// ViewState["RateChange"].ToString();
        }
        try
        {
            if (Ratechange == "true")
            {
                sb.Append(" SELECT lt.LedgerTnxID,lt.TransactionID,lt.ItemID,lt.ItemName,lt.Rate,lt.Quantity,lt.amount,pip.IPDCaseTypeID,pip.Room_ID,lt.PanelID,lt.ScheduleChargeID,ReferenceCode ");
                sb.Append(" FROM  ( ");
                sb.Append(" SELECT lt.Date,lt.Time,ltd.EntryDate,lt.TransactionID,ltd.ItemID,ltd.ItemName,ltd.Rate,ltd.Quantity ");
                sb.Append(" ,ltd.Amount,ltd.LedgerTnxID,pmh.PanelID,pmh.ScheduleChargeID ");
                sb.Append(" ,(Select ReferenceCode from f_panel_master where PanelID=pmh.PanelID)ReferenceCode ");
                sb.Append(" FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ON  ");
                sb.Append(" lt.LedgerTransactionNo = ltd.LedgerTransactionNo LEFT JOIN patient_medical_history pmh ON ltd.TransactionID = pmh.TransactionID ");
                sb.Append(" WHERE ltd.LedgerTnxID='" + lblLtdNo.Text.Trim() + "')lt  LEFT JOIN patient_ipd_profile pip ");
                sb.Append(" ON lt.TransactionID = pip.TransactionID  ");
                sb.Append(" AND CONCAT(lt.Date,' ',lt.time) >=  CONCAT(pip.StartDate,' ',pip.StartTime) ");
                sb.Append(" AND CONCAT(lt.Date,' ',lt.time) <=  IF(CONCAT(pip.EndDate,' ',pip.EndTime)='0001-01-01 00:00:00',NOW(),CONCAT(pip.EndDate,' ',pip.EndTime)) ");
                //"+
                DataTable dt = StockReports.GetDataTable(sb.ToString());

                StringBuilder sb1 = new StringBuilder();
                sb1.Append("select * from  f_ratelist_ipd Where ItemID = '" + dt.Rows[0]["ItemID"].ToString() + "' ");
                sb1.Append("and PanelID = " + dt.Rows[0]["ReferenceCode"].ToString() + " and IPDCaseTypeID='" + dt.Rows[0]["IPDCaseTypeID"].ToString() + "' and IsCurrent=1");
                DataTable dt1 = StockReports.GetDataTable(sb1.ToString());

                if (dt1.Rows.Count > 0 && Util.GetDecimal(dt1.Rows[0]["Rate"]) == 0) // Deleting OLD rates for updating/inserting rates
                {
                    StringBuilder sb2 = new StringBuilder();
                    sb2.Append("Update f_ratelist_ipd Set IsCurrent=0,LastUpdatedBy='" + ViewState["UserID"].ToString() + "',");
                    sb2.Append("UpdatedDate=Now(),IpAddress='" + All_LoadData.IpAddress().ToString() + "' Where ItemID = '" + dt.Rows[0]["ItemID"].ToString() + "' ");
                    sb2.Append("and PanelID = " + dt.Rows[0]["ReferenceCode"].ToString() + " and ScheduleChargeID=" + Util.GetInt(dt.Rows[0]["ScheduleChargeID"].ToString()) + " ");

                    if (chkSetRate.Checked == false)
                        sb2.Append(" and IPDCaseTypeID='" + dt.Rows[0]["IPDCaseTypeID"].ToString() + "' ");

                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb2.ToString());
                }

                if (chkSetRate.Checked)
                {
                    DataTable dtAlloomType = StockReports.GetDataTable("Select IPDCaseTypeID from ipd_case_type_master where IsActive=1");

                    if (dtAlloomType != null && dtAlloomType.Rows.Count > 0)
                    {
                        foreach (DataRow drTooms in dtAlloomType.Rows)
                        {
                            RateListIPD objRateList = new RateListIPD(Tnx);
                            objRateList.PanelID = dt.Rows[0]["ReferenceCode"].ToString();
                            objRateList.ItemID = dt.Rows[0]["ItemID"].ToString();
                            objRateList.Rate = Util.GetDecimal(txtERate.Text.Trim());
                            objRateList.IsTaxable = Util.GetInt("0");
                            objRateList.FromDate = DateTime.Now;
                            objRateList.ToDate = DateTime.Now;
                            objRateList.IsCurrent = 1;
                            objRateList.IsService = "YES";
                            objRateList.ItemDisplayName = "";
                            objRateList.ItemCode = "";
                            objRateList.IPDCaseTypeID = drTooms["IPDCaseTypeID"].ToString();
                            objRateList.ScheduleChargeID = Util.GetInt(dt.Rows[0]["ScheduleChargeID"].ToString());
                            objRateList.UserID = ViewState["UserID"].ToString();
                            objRateList.IPAddress = All_LoadData.IpAddress();
                            objRateList.Insert();
                        }
                    }
                }
                else
                {
                    RateListIPD objRateList = new RateListIPD(Tnx);
                    objRateList.PanelID = dt.Rows[0]["ReferenceCode"].ToString();
                    objRateList.ItemID = dt.Rows[0]["ItemID"].ToString();
                    objRateList.Rate = Util.GetDecimal(txtERate.Text.Trim());
                    objRateList.IsTaxable = Util.GetInt("0");
                    objRateList.FromDate = DateTime.Now;
                    objRateList.ToDate = DateTime.Now;
                    objRateList.IsCurrent = 1;
                    objRateList.IsService = "YES";
                    objRateList.ItemDisplayName = "";
                    objRateList.ItemCode = "";
                    objRateList.IPDCaseTypeID = dt.Rows[0]["IPDCaseTypeID"].ToString();
                    objRateList.ScheduleChargeID = Util.GetInt(dt.Rows[0]["ScheduleChargeID"].ToString());
                    objRateList.UserID = ViewState["UserID"].ToString();
                    objRateList.IPAddress = All_LoadData.IpAddress();
                    objRateList.Insert();
                }
            }

            if (Util.GetDecimal(txtEDiscPer.Text.Trim()) > 0)
            {
                amount = (Util.GetDecimal(txtERate.Text.Trim()) * Util.GetDecimal(txtEQty.Text.Trim())) - (((Util.GetDecimal(txtERate.Text.Trim()) * Util.GetDecimal(txtEQty.Text.Trim())) * Util.GetDecimal(txtEDiscPer.Text.Trim())) / 100);
                if (Util.GetDecimal(txtERate.Text.Trim()) > 0 && Util.GetDecimal(txtEDiscPer.Text.Trim()) > 0)
                    DiscAmt = Util.GetDecimal(Util.GetDecimal(txtERate.Text.Trim()) * Util.GetDecimal(txtEQty.Text.Trim()) * Util.GetDecimal(txtEDiscPer.Text.Trim()) / 100);
                str = "update f_ledgertnxdetail set GrossAmount=" + (Util.GetDecimal(txtERate.Text.Trim()) * Util.GetDecimal(txtEQty.Text.Trim())) + ", rate=" + Util.GetDecimal(txtERate.Text.Trim()) + ","
                + " Quantity=" + Util.GetDecimal(txtEQty.Text.Trim()) + ",amount=" + amount + ","
                + " DiscountPercentage=" + Util.GetDecimal(txtEDiscPer.Text.Trim()) + ","
                + " NetItemAmt='" + amount + "', "
                + " DiscAmt=" + DiscAmt + ", "
                + " TotalDiscAmt=" + DiscAmt + ", "
                + " DiscountReason='" + ddlControlDiscountReason.SelectedValue + "', "
                + " DiscUserID='" + ViewState["UserID"] + "', "
                + " LastUpdatedBy = '" + ViewState["UserID"] + "', "
                + " UpdatedDate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',CancelReason='" + txtEditReason.Text.Trim().Replace("'", "") + "' , "
                + " IpAddress = '" + Util.GetString(All_LoadData.IpAddress()) + "', "
                + " IsPayable = '" + Util.getbooleanInt(chkNonPayable.Checked) + "' "
                + " where LedgerTnxID='" + lblLtdNo.Text.Trim() + "'";
            }
            else if (Util.GetDecimal(txtEDiscAmt.Text.Trim()) > 0)
            {
                amount = (Util.GetDecimal(txtERate.Text.Trim()) * Util.GetDecimal(txtEQty.Text.Trim())) - Util.GetDecimal(txtEDiscAmt.Text.Trim());

                str = "update f_ledgertnxdetail set GrossAmount=" + (Util.GetDecimal(txtERate.Text.Trim()) * Util.GetDecimal(txtEQty.Text.Trim())) + ", rate=" + Util.GetDecimal(txtERate.Text.Trim()) + ","
                + " Quantity=" + Util.GetDecimal(txtEQty.Text.Trim()) + ","
                + " amount=" + amount + ","
                + " NetItemAmt='" + amount + "', "
                + " DiscountPercentage=" + (Util.GetDecimal(txtEDiscAmt.Text.Trim()) * 100) / (Util.GetDecimal(txtERate.Text.Trim()) * Util.GetDecimal(txtEQty.Text.Trim())) + ","
                + " DiscAmt=" + Util.GetDecimal(txtEDiscAmt.Text.Trim()) + ","
                + " TotalDiscAmt=" + Util.GetDecimal(txtEDiscAmt.Text.Trim()) + ","
                + " DiscountReason='" + ddlControlDiscountReason.SelectedValue + "', "
                + " DiscUserID='" + ViewState["UserID"] + "', "
                + " LastUpdatedBy = '" + ViewState["UserID"] + "', "
                + " UpdatedDate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',CancelReason='" + txtEditReason.Text.Trim().Replace("'", "") + "', "
                + " IpAddress = '" + Util.GetString(All_LoadData.IpAddress()) + "', "
                + " IsPayable = '" + Util.getbooleanInt(chkNonPayable.Checked) + "' "
                + " where LedgerTnxID='" + lblLtdNo.Text.Trim() + "'";
            }
            else
            {
                amount = (Util.GetDecimal(txtERate.Text.Trim()) * Util.GetDecimal(txtEQty.Text.Trim())) - Util.GetDecimal(txtEDiscAmt.Text.Trim());
                str = "update f_ledgertnxdetail set GrossAmount=" + (Util.GetDecimal(txtERate.Text.Trim()) * Util.GetDecimal(txtEQty.Text.Trim())) + ", rate=" + Util.GetDecimal(txtERate.Text.Trim()) + ","
                + " Quantity=" + Util.GetDecimal(txtEQty.Text.Trim()) + ","
                + " amount=" + amount + ","
                + " NetItemAmt='" + amount + "', "
                    // + " DiscountPercentage=" + (Util.GetDecimal(txtEDiscAmt.Text.Trim()) * 100) / (Util.GetDecimal(txtERate.Text.Trim()) * Util.GetDecimal(txtEQty.Text.Trim())) + ","
                + " DiscAmt=" + Util.GetDecimal(txtEDiscAmt.Text.Trim()) + ","
                + " TotalDiscAmt=" + Util.GetDecimal(txtEDiscAmt.Text.Trim()) + ","
                + " DiscountReason='" + ddlControlDiscountReason.SelectedValue + "', "
                + " LastUpdatedBy = '" + ViewState["UserID"] + "', "
                + " UpdatedDate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',CancelReason='" + txtEditReason.Text.Trim().Replace("'", "") + "', "
                + " IpAddress = '" + Util.GetString(All_LoadData.IpAddress()) + "' ,"
                + " IsPayable = '" + Util.getbooleanInt(chkNonPayable.Checked) + "' "
                + " where LedgerTnxID='" + lblLtdNo.Text.Trim() + "'";
            }
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);
            CalcaluteDoctorShare("'" + lblLtdNo.Text.Trim() + "'", Tnx, con);
            Tnx.Commit();

            BindDepartment();
            ShowItemDetails();
            GetBillDetails();
            lblMsg.Text = "Item Updated Successfully";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('" + lblMsg.Text + "', function () { });", true);
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnRSave_Click(object sender, EventArgs e)
    {
        if (txtEditReasonRate.Text == "")
        {
            lblMsg.Text = "Please Enter The Rate Edit Reason.";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('" + lblMsg.Text + "', function () { });", true);
            return;
        }
        if (Util.GetDecimal(txtRate.Text) <= 0)
        {
            lblMsg.Text = "Please Enter The Rate.";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('" + lblMsg.Text + "', function () { });", true);
            return;
        }
        GetSelection();

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            if (lblLtdNo.Text.Trim() != string.Empty)
            {
                string str = "update f_ledgertnxdetail set GrossAmount=(" + txtRate.Text.Trim() + "*Quantity),rate = " + txtRate.Text.Trim() + ","
                + " amount = ((" + txtRate.Text.Trim() + "*Quantity)-TotalDiscAmt), "
                + " LastUpdatedBy = '" + ViewState["UserID"] + "', "
                + " UpdatedDate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "', CancelReason='" + txtEditReasonRate.Text.Trim().Replace("'","") + "' , "
                + " IpAddress = '" + Util.GetString(All_LoadData.IpAddress()) + "',NetItemAmt=((" + txtRate.Text.Trim() + "*Quantity)-TotalDiscAmt) "
                + " where LedgerTnxID in (" + lblLtdNo.Text.Trim() + ")";

                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
                CalcaluteDoctorShare(lblLtdNo.Text.Trim(), Tranx, con);
            }
            else
            {
                lblMsg.Text = "Select Item";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('" + lblMsg.Text + "', function () { });", true);
            }

            Tranx.Commit();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            BindDepartment();
            ShowItemDetails();
            GetBillDetails();
            lblMsg.Text = "Rate Updated Successfully";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('" + lblMsg.Text + "', function () { });", true);
            txtRate.Text = "";
        }
        catch (Exception ex)
        {
            var c1 = new ClassLog();
            c1.errLog(ex);
            Tranx.Rollback();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            lblMsg.Text = "Error";
        }
    }


    protected void btnQSave_Click(object sender, EventArgs e)
    {
        if (Util.GetDecimal(txtQty.Text) <= 0)
        {
            lblMsg.Text = "Please Enter The Quantity.";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('" + lblMsg.Text + "', function () { });", true);
            return;
        }
        if (txtEditReasonQty.Text == "")
        {
            lblMsg.Text = "Please Enter The Quantity Edit Reason.";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('" + lblMsg.Text + "', function () { });", true);
            return;
        }
        
        GetSelection();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            if (lblLtdNo.Text.Trim() != string.Empty)
            {
                string str = "update f_ledgertnxdetail set GrossAmount=(" + txtQty.Text.Trim() + "*Rate),Quantity = " + txtQty.Text.Trim() + ","
                + " amount = ((" + txtQty.Text.Trim() + "*Rate)-TotalDiscAmt), "
                + " LastUpdatedBy = '" + ViewState["UserID"] + "', "
                + " UpdatedDate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "', "
                + " IpAddress = '" + Util.GetString(All_LoadData.IpAddress()) + "',NetItemAmt=((" + txtQty.Text.Trim() + "*Rate)-TotalDiscAmt),CancelReason='" + txtEditReasonQty.Text.Trim().Replace("'", "") + "' "
                + " where LedgerTnxID in (" + lblLtdNo.Text.Trim() + ")";
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
                CalcaluteDoctorShare(lblLtdNo.Text.Trim(), Tranx, con);
            }
            else
            {
                lblMsg.Text = "Select Item";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('" + lblMsg.Text + "', function () { });", true);
            }
            Tranx.Commit();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            BindDepartment();
            ShowItemDetails();
            GetBillDetails();
            lblMsg.Text = "Quantity Updated Successfully";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('" + lblMsg.Text + "', function () { });", true);
            txtQty.Text = "";
        }
        catch (Exception ex)
        {
            var c1 = new ClassLog();
            c1.errLog(ex);
            Tranx.Rollback();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            lblMsg.Text = "Error";
        }
    }
    protected void btnDiscSave_Click(object sender, EventArgs e)
    {


       

        //max Discount Validation
        decimal discountPercent = Util.GetDecimal(txtItemDiscPer.Text);

        string userID = HttpContext.Current.Session["ID"].ToString();
        var maxEligibleDiscountPercent = Util.round(All_LoadData.GetEligiableDiscountPercent(userID));

        var message = AllGlobalFunction.maxDiscountValidationErrorMessage + maxEligibleDiscountPercent + "</b>";

        if (discountPercent > maxEligibleDiscountPercent)
        {
            Page.ClientScript.RegisterStartupScript(this.GetType(), "AuthorizationScript56", "$(function () { modelAlert('" + message + "')  });", true);
            return;
        }

        //max Discount Validation






        if (Util.GetDecimal(txtItemDiscPer.Text) < 0)
        {
            lblMsg.Text = "Please Enter Discount Percentage.";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('" + lblMsg.Text + "', function () { });", true);
            return;
        }
        if (ddlDisReason.SelectedIndex == 0)
        {
            lblMsg.Text = "Please Select Discount Reason.";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('" + lblMsg.Text + "', function () { });", true);
            return;
        }
        GetSelection();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            if (lblLtdNo.Text.Trim() != string.Empty)
            {
                string str;
                if (Util.GetDecimal(txtItemDiscPer.Text.Trim()) > 0)
                    str = "update f_ledgertnxdetail set amount = (GrossAmount)-(((GrossAmount)*" + Util.GetDecimal(txtItemDiscPer.Text.Trim()) + ")/100),NetItemAmt = (GrossAmount)-(((GrossAmount)*" + Util.GetDecimal(txtItemDiscPer.Text.Trim()) + ")/100),DiscountPercentage=" + Util.GetDecimal(txtItemDiscPer.Text.Trim()) + ",DiscAmt=((GrossAmount)*" + Util.GetDecimal(txtItemDiscPer.Text.Trim()) + "/100),TotalDiscAmt=((GrossAmount)*" + Util.GetDecimal(txtItemDiscPer.Text.Trim()) + "/100),DiscountReason='" + ddlDisReason.SelectedValue + "',LastUpdatedBy = '" + ViewState["UserID"] + "',UpdatedDate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',IpAddress = '" + Util.GetString(All_LoadData.IpAddress()) + "' where LedgerTnxID in (" + lblLtdNo.Text.Trim() + ")";
                else
                    str = "update f_ledgertnxdetail set amount = (GrossAmount)-" + Util.GetDecimal(txtItemDiscAmt.Text.Trim()) + ",NetItemAmt = (GrossAmount)-" + Util.GetDecimal(txtItemDiscAmt.Text.Trim()) + ",DiscountPercentage=(" + Util.GetDecimal(txtItemDiscAmt.Text.Trim()) + "*100)/(GrossAmount),DiscAmt=" + Util.GetDecimal(txtItemDiscAmt.Text.Trim()) + ",TotalDiscAmt=" + Util.GetDecimal(txtItemDiscAmt.Text.Trim()) + ",LastUpdatedBy = '" + ViewState["UserID"] + "',DiscountReason='" + ddlDisReason.SelectedValue + "',UpdatedDate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',IpAddress = '" + Util.GetString(All_LoadData.IpAddress()) + "' where LedgerTnxID in (" + lblLtdNo.Text.Trim() + ")";

                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
                CalcaluteDoctorShare(lblLtdNo.Text.Trim(), Tranx, con);
            }
            else
            {
                lblMsg.Text = "Select Item";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('" + lblMsg.Text + "', function () { });", true);
            }
            Tranx.Commit();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            BindDepartment();
            ShowItemDetails();
            GetBillDetails();
            lblMsg.Text = "Discount Updated Successfully";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('" + lblMsg.Text + "', function () { });", true);
            txtItemDiscPer.Text = "";
        }
        catch (Exception ex)
        {
            var c1 = new ClassLog();
            c1.errLog(ex);
            Tranx.Rollback();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            lblMsg.Text = "Error";
        }
    }
    protected void btnReject_Click(object sender, EventArgs e)
    {
        mpeRejection.Show();
    }

    protected void btnItemPkgSave_Click(object sender, EventArgs e)
    {
        GetSelection();
        if ((lblLtdNo.Text.Trim() != string.Empty) || (lblLTNo.Text.Trim() != string.Empty))
        {
            string strLtNo = string.Empty, strLtdNo = string.Empty;
            int result1 = 0, result2 = 0;
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

            try
            {
                if (lblLtdNo.Text.Trim() != string.Empty)
                {
                    if (ddlPackage.SelectedValue != "0")
                    {
                        strLtdNo = "update f_ledgertnxdetail set PackageID='" + ddlPackage.SelectedValue + "',IsPackage=1,Amount=0,NetItemAmt=0,LastUpdatedBy = '" + ViewState["UserID"] + "',UpdatedDate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',IpAddress = '" + Util.GetString(All_LoadData.IpAddress()) + "' where LedgerTnxID in(" + lblLtdNo.Text.Trim() + ")";
                    }
                    else
                    {
                        strLtdNo = "update f_ledgertnxdetail set PackageID='',IsPackage=0,NetItemAmt=(GrossAmount-TotalDiscAmt),Amount=(GrossAmount-TotalDiscAmt),LastUpdatedBy = '" + ViewState["UserID"] + "',UpdatedDate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',IpAddress = '" + Util.GetString(All_LoadData.IpAddress()) + "' where LedgerTnxID in(" + lblLtdNo.Text.Trim() + ")";
                    }
                    result1 = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strLtdNo);
                    CalcaluteDoctorShare(lblLtdNo.Text.Trim(), tnx, con);
                }
              //  else
             //   {
              //      lblMsg.Text = "Select Item";
              //      ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('" + lblMsg.Text + "', function () { });", true);
             //   }
                else if (lblLTNo.Text.Trim() != string.Empty)
                {
                    if (ddlPackage.SelectedValue != "0")
                       strLtNo = "update f_ledgertnxdetail set PackageID='" + ddlPackage.SelectedValue + "',IsPackage=1,Amount=0,NetItemAmt=0,LastUpdatedBy = '" + ViewState["UserID"] + "',UpdatedDate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',IpAddress = '" + Util.GetString(All_LoadData.IpAddress()) + "' where LedgerTransactionNo in(" + lblLTNo.Text.Trim() + ")";
                   else
                        strLtNo = "update f_ledgertnxdetail set PackageID='',IsPackage=0,Amount=(GrossAmount-TotalDiscAmt),NetItemAmt=(GrossAmount-TotalDiscAmt),LastUpdatedBy = '" + ViewState["UserID"] + "',UpdatedDate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',IpAddress = '" + Util.GetString(All_LoadData.IpAddress()) + "' where LedgerTransactionNo in(" + lblLTNo.Text.Trim() + ")";

                   result2 = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strLtNo);
                }

                if ((result1 >= 0) && (result2 >= 0))
                {
                    tnx.Commit();
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();
                    BindDepartment();
                    ShowItemDetails();
                    GetBillDetails();
                    lblMsg.Text = "Package Updated Successfully";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('" + lblMsg.Text + "', function () { });", true);
                }
                else
                {
                    tnx.Rollback();
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();
                    lblMsg.Text = "Error";
                }
            }
            catch (Exception ex)
            {
                tnx.Rollback();
                tnx.Dispose();
                con.Close();
                con.Dispose();
                lblMsg.Text = "Error";
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
            }
        }
        else
        {
            lblMsg.Text = "Select Items...";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('" + lblMsg.Text + "', function () { });", true);
        }
    }

    protected void chkFilter_CheckedChanged(object sender, EventArgs e)
    {
        for (int i = 0; i < chkFilterItem.Items.Count; i++)
            chkFilterItem.Items[i].Selected = chkFilter.Checked;
    }

    protected void btnApplyFilter_Click(object sender, EventArgs e)
    {
        ViewState["IsFilter"] = true;
        ShowItemDetails();
    }

    protected void ddlSubCategory_SelectedIndexChanged(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        string TransID = Convert.ToString(ViewState["TransID"]);
        string DispName = Convert.ToString(ViewState["DispName"]).ToUpper();
        string ConfigID = Convert.ToString(ViewState["ConfigID"]).ToUpper();

        sb.Append("select distinct(LTD.ItemID),LTD.ItemName from f_ledgertnxdetail LTD inner join f_ledgertransaction LT");
        sb.Append(" on LT.LedgerTransactionNo=LTD.LedgerTransactionNo inner join f_subcategorymaster sub on LTD.SubCategoryID = sub.SubCategoryID where LTD.TransactionID='" + TransID + "' and ");
        sb.Append(" LT.IsCancel=0 and LTD.IsFree = 0 and LTD.IsVerified = 1 and IsPackage = 0");
        if (ddlSubCategory.SelectedValue != "0")
            sb.Append(" and LTD.SubCategoryID='" + ddlSubCategory.SelectedValue + "'");
        else
            sb.Append(" and sub.CategoryID ='" + DispName + "'");

        sb.Append(" and (ltd.EntryDate)>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' and (ltd.EntryDate)<='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            chkFilterItem.DataSource = dt;
            chkFilterItem.DataTextField = "ItemName";
            chkFilterItem.DataValueField = "ItemID";
            chkFilterItem.DataBind();
        }
        else
            chkFilterItem.Items.Clear();
    }

    protected void btnRefresh_Click(object sender, EventArgs e)
    {
        GetBillDetails();
    }

    protected void btnReport_Click(object sender, EventArgs e)
    {
       
    }

    #endregion Event Handling

    #region Data Binding

    private void GetBillDetails()// Gaurav 17.06.2018
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
            sbBill.Append("AND ltd.EntryDate>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' AND  ltd.EntryDate<='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' GROUP BY lt.TransactionID     ");
            sbBill.Append(")t    ");
            sbBill.Append(")T2   ");
            sbBill.Append("LEFT JOIN (  ");
            sbBill.Append("SELECT TransactionID,ROUND(SUM(AmountPaid),2)RecAmt FROM f_reciept WHERE IsCancel = 0   ");
            sbBill.Append("AND TransactionID = '" + ViewState["TransID"].ToString() + "' AND DATE>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "'  AND DATE<='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "' GROUP BY TransactionID   ");
            sbBill.Append(")T3 ON T2.TransactionID = T3.TransactionID ");
            DataTable dtBill = StockReports.GetDataTable(sbBill.ToString());

            if (dtBill.Rows.Count > 0)
            {

                decimal PaidAmount = 0;

                PaidAmount = Util.GetDecimal(StockReports.ExecuteScalar(" SELECT ROUND(SUM(AmountPaid),2)RecAmt FROM f_reciept WHERE IsCancel = 0  AND TransactionID = '" + ViewState["TransID"].ToString() + "' AND DATE>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "'  AND DATE<='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "' "));
                if (PaidAmount > 0)
                {
                    dtBill.Rows[0]["RecAmt"] = PaidAmount.ToString();
                    dtBill.AcceptChanges();
                }

                lblGrossBillAmt.Text = Util.GetString(dtBill.Rows[0]["GrossAmt"]);
                lblBillDiscount.Text = Util.GetString(dtBill.Rows[0]["TDiscount"]);
                lblNetAmount.Text = Util.GetString(dtBill.Rows[0]["NetAmt"]);
                lblAdvanceAmt.Text = Util.GetString(Util.GetDecimal(dtBill.Rows[0]["RecAmt"]));
                lblBalanceAmt.Text = Util.GetString(Util.GetDecimal(dtBill.Rows[0]["NetAmt"]) - Util.GetDecimal(dtBill.Rows[0]["RecAmt"]));
                lblApprovalAmt.Text = Util.GetString(dtBill.Rows[0]["PanelApprovedAmt"]);
                lblDeduction.Text = Util.GetString(Util.GetDecimal(dtBill.Rows[0]["TotalDeduction"]));
                // lblTaxAppliedOn.Text = Util.GetString(dtBill.Rows[0]["NetAmt"]);
                lblTotalTax.Text = Util.GetDecimal(Math.Round(Util.GetDecimal((Util.GetDecimal(lblNetAmount.Text) * Util.GetDecimal(lblTaxPer.Text)) / 100), 2, System.MidpointRounding.AwayFromZero)).ToString();
                decimal TotalAmt = Util.GetDecimal(lblNetAmount.Text) + Util.GetDecimal(lblTotalTax.Text);
                lblNetBillAmt.Text = Util.GetDecimal(Math.Round(TotalAmt, 0, MidpointRounding.AwayFromZero)).ToString();
                decimal RoundOff = Math.Round((Util.GetDecimal(lblNetBillAmt.Text) - Util.GetDecimal(lblNetAmount.Text)), 2, MidpointRounding.AwayFromZero);
                lblRoundOff.Text = Util.GetDecimal(Math.Round((RoundOff), 2, MidpointRounding.AwayFromZero)).ToString();
                decimal BalanceAmt = Util.GetDecimal(lblNetBillAmt.Text) - (Util.GetDecimal(lblAdvanceAmt.Text) + Util.GetDecimal(lblDeduction.Text) + RoundOff);
                lblBalanceAmt.Text = Util.GetDecimal(BalanceAmt).ToString();
                lblPanelID.Text = Util.GetString(dtBill.Rows[0]["PanelID"]);

                if (dtBill.Rows[0]["PanelID"].ToString() != "1")
                {
                    lblPatientPayble.Visible = true;
                    lblPatientPaybleCap.Visible = true;
                    lblPatientPayble.Text = "";
                    DataTable PatientPayable = IPDBilling.GetCopayAmount(TransID, 0, 0);
                    if (PatientPayable.Rows.Count > 0 && PatientPayable != null)
                    {
                        lblPatientPayble.Text = Util.GetString(Util.GetDecimal(PatientPayable.Rows[0]["TotalPatientCopayPayble"]) + Util.GetDecimal(PatientPayable.Rows[0]["TotalNonPayableAmt"]));
                        lblPatientPayble.ToolTip = "Non Payable : " + PatientPayable.Rows[0]["TotalNonPayableAmt"] + ", Co-Payment : " + PatientPayable.Rows[0]["TotalPatientCopayPayble"];
                        lblPatientPaybleCap.ToolTip = "Non Payable : " + PatientPayable.Rows[0]["TotalNonPayableAmt"] + ", Co-Payment : " + PatientPayable.Rows[0]["TotalPatientCopayPayble"];

                    }
                }
                else
                {
                    lblPatientPayble.Visible = false;
                    lblPatientPaybleCap.Visible = false;
                }
            }
            else
            {
                lblMsg.Text = "No Billing Information Found";
                DataTable dtAD = StockReports.GetDataTable(" select TransactionID,Round(sum(AmountPaid,2))RecAmt from f_reciept where IsCancel = 0 AND TransactionID = '" + TransID + "'  ");
                lblAdvanceAmt.Text = Util.GetString(Util.GetDecimal(dtAD.Rows[0]["RecAmt"]));
            }
        }
    }

    private void BindDepartment()
    {
        if (ViewState["TransID"] != null)
        {
            string TransID = Convert.ToString(ViewState["TransID"]);
            StringBuilder sbDept = new StringBuilder();

            //change 29.10.16
            sbDept.Append(" SELECT DisplayName,IF(t1.ConfigID='14','true','false')IsPackage, ");

            if (CanViewRate == true)
                sbDept.Append(" SUM(t1.Amount) NetAmt, ");
            else
                sbDept.Append(" '' NetAmt, ");

            sbDept.Append(" SUM(t1.Quantity) Qty,CONCAT(t1.CategoryID,'#',t1.ConfigID)Category FROM (  ");
            sbDept.Append("   SELECT lt.LedgerTransactionNo,ltd.NetItemAmt AS Amount,ltd.Quantity,ltd.subcategoryID ,ltd.ConfigID,cm.CategoryID, ");
            sbDept.Append("   IF(ltd.isAttendentRoom=1,'ATTENDENT ROOM',cm.Name)DisplayName ");
            sbDept.Append("   FROM f_ledgertnxdetail ltd INNER JOIN f_ledgertransaction LT  ON ltd.LedgerTransactionNo = LT.LedgerTransactionNo  ");
            sbDept.Append("   INNER JOIN f_subcategorymaster SM ON ltd.SubCategoryID = SM.SubCategoryID  INNER JOIN f_categorymaster cm ON sm.CategoryID = cm.CategoryID");
            sbDept.Append("   WHERE Lt.IsCancel = 0 AND  ltd.IsVerified = 1 AND ltd.IsPackage = 0 AND ltd.IsSurgery = 0  ");
            sbDept.Append("   AND lt.TransactionID = '" + TransID + "' ");
            sbDept.Append("   AND ltd.EntryDate>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' AND  ltd.EntryDate<='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
            sbDept.Append("   UNION ALL");
            sbDept.Append("   SELECT DISTINCT(lt.LedgerTransactionNo),lt.NetAmount,1 Quantity,ltd.SubcategoryID ,ltd.ConfigID,cm.CategoryID,");
            sbDept.Append("   IF(ltd.isAttendentRoom=1,'AttendentRoom Room',cm.Name)DisplayName  ");
            sbDept.Append("   FROM f_ledgertnxdetail ltd INNER JOIN f_ledgertransaction LT ON ltd.LedgerTransactionNo = LT.LedgerTransactionNo  ");
            sbDept.Append("   INNER JOIN f_subcategorymaster SM ON ltd.SubCategoryID = SM.SubCategoryID  ");
            sbDept.Append("   INNER JOIN f_categorymaster cm ON sm.CategoryID = cm.CategoryID ");
            sbDept.Append("   WHERE Lt.IsCancel = 0 AND ltd.IsVerified = 1 AND ltd.IsPackage = 0 AND ltd.IsSurgery = 1 AND lt.TransactionID = '" + TransID + "' ");
            sbDept.Append("   AND  ltd.EntryDate>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' AND  ltd.EntryDate<='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
            sbDept.Append("   )t1 GROUP BY t1.ConfigID,t1.DisplayName  ");
            DataTable dt = StockReports.GetDataTable(sbDept.ToString());

            if (dt.Rows.Count > 0)
            {
                gvDeptBill.DataSource = dt;
                gvDeptBill.DataBind();
                lblMsg.Text = string.Empty;
            }
            else
            {
                gvDeptBill.DataSource = null;
                gvDeptBill.DataBind();
                lblMsg.Text = "No Items Found";
            }
            gvItemDetail.DataSource = null;
            gvItemDetail.DataBind();
        }
    }
    private DataTable GetItemDataTable()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("LtNo");
        dt.Columns.Add("TransactionID");
        dt.Columns.Add("IssueDate");
        dt.Columns.Add("ItemID");
        dt.Columns.Add("ItemName");
        dt.Columns.Add("Rate", typeof(decimal));
        dt.Columns.Add("Quantity", typeof(decimal));
        dt.Columns.Add("DiscPer", typeof(decimal));
        dt.Columns.Add("DiscAmt", typeof(decimal));
        dt.Columns.Add("Amount", typeof(decimal));
        dt.Columns.Add("Package");
        dt.Columns.Add("Name");
        dt.Columns.Add("IsNPSurgery");
        dt.Columns.Add("IsEdit");
        dt.Columns.Add("IsReject");
        dt.Columns.Add("IsSurgery");
        dt.Columns.Add("subcategoryname");
        //  dt.Columns.Add("NotSurgery");

        return dt;
    }

    private void ShowItemDetails()
    {
        if ((ViewState["TransID"] != null) && (ViewState["DispName"] != null))
        {
            bool IsFilter = false;

            if (ViewState["IsFilter"] != null)
            {
                IsFilter = Convert.ToBoolean(ViewState["IsFilter"]);
                ViewState["IsFilter"] = false;
            }

            string TransID = Convert.ToString(ViewState["TransID"]);
            string DispName = Convert.ToString(ViewState["DispName"]).ToUpper();
            string ConfigID = Convert.ToString(ViewState["ConfigID"]);
            string IsEdit = "false";
            string IsReject = "false";
            string IsNPSurgery = "false";
            DataTable Authority = (DataTable)ViewState["Authority"];
            if (Authority.Rows.Count > 0)
            {
                if (Authority.Rows[0]["CanViewRate"].ToString() == "1")
                    CanViewRate = true;
            }

            StringBuilder sb = new StringBuilder();

            //--------------------------------------------------------------
            //--------------------------------------------------------------
            switch (ConfigID)
            {
                case "22": // Surgery Case
                    sb.Append("select '' Doctorname,ltd.configid,lt.LedgerTransactionNo,lt.LedgerTransactionNo LtNo,lt.TransactionID,date_format(ltd.EntryDate,'%d-%b-%Y %l:%i %p')IssueDate,ltd.itemid,ltd.SurgeryName ItemName,ltd.IsPayable,if(ltd.IsPayable=0,'Payable','Non-Payable')Payable,");
                    sb.Append("(select name from f_subcategorymaster where SubcategoryID=ltd.subcategoryid)subCategoryname,");
                    sb.Append("Round(lt.GrossAmount,2) Rate,1 Quantity,");
                    sb.Append(" lt.DiscountOnTotal DiscPer,ROUND((lt.GrossAmount*lt.DiscountOnTotal)/100,2) DiscAmt,Round(lt.NetAmount,1) Amount,'---' Package,em.Name,");
                    if (Authority.Rows.Count > 0)
                    {
                        if (Authority.Rows[0]["IsEdit"].ToString() == "1")
                        {
                            IsEdit = "false";
                            IsNPSurgery = "true";
                        }
                        if (Authority.Rows[0]["IsReject"].ToString() == "1")
                        {
                            IsReject = "true";
                        }
                    }
                    sb.Append(" '" + IsNPSurgery + "' IsNPSurgery,IF(ltd.rate=0,'true',");
                    sb.Append(" '" + IsEdit + "' )IsEdit,'" + IsReject + "' IsReject,'" + CanViewRate + "' CanViewRate,");

                    sb.Append("'true' IsSurgery,ltd.DiscountReason,(SELECT (NAME)DiscGivenBy FROM employee_master WHERE EmployeeID=ltd.DiscUserID LIMIT 1)DiscGivenBy,lt.TypeOfTnx,'' LabSampleCollected  ");
                    sb.Append(" From f_ledgertnxdetail ltd inner join f_ledgertransaction LT on ltd.LedgerTransactionNo = LT.LedgerTransactionNo ");
                    sb.Append(" inner join employee_master em on ltd.UserID = em.EmployeeID WHERE Lt.IsCancel = 0 and ltd.IsVerified = 1 and ltd.IsPackage = 0 and ");
                    sb.Append(" ltd.IsSurgery = 1 and lt.TransactionID = '" + TransID + "' and lt.Date >= '" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' and lt.Date <= '" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "' group by lt.LedgerTransactionNo order by lt.Date Desc");
                    break;

                case "14"://IPD Package
                    sb.Append("select T1.*,im.typename Package,em.name from (select (SELECT CONCAT(dm.Title,'',dm.Name) FROM doctor_master dm WHERE dm.DoctorID=ltd.DoctorID LIMIT 1)Doctorname,ltd.configid,ltd.LedgerTransactionNo,ltd.LedgerTnxID LtNo,lt.TransactionID,date_format(ltd.EntryDate,'%d-%b-%Y %l:%i %p')IssueDate,");
                    sb.Append(" ltd.ItemID,ltd.ItemName,");
                    sb.Append("(select name from f_subcategorymaster where SubcategoryID=ltd.subcategoryid)subCategoryname,");
                    sb.Append("round(ltd.Rate,1) Rate,ltd.Quantity,ltd.DiscountPercentage DiscPer,ROUND((((ltd.Quantity*ltd.Rate)*ltd.DiscountPercentage)/100),2) DiscAmt,ltd.IsPayable,if(ltd.IsPayable=0,'Payable','Non-Payable')Payable,");
                    sb.Append(" ltd.Amount,ltd.UserID,ltd.PackageID,'false' IsNPSurgery,IF(ltd.rate=0,'true',");

                    if (Authority.Rows.Count > 0)
                    {
                        if (Authority.Rows[0]["IsEdit"].ToString() == "1")
                        {
                            IsEdit = "true";
                        }
                        if (Authority.Rows[0]["IsReject"].ToString() == "1")
                        {
                            IsReject = "true";
                        }
                    }
                    sb.Append(" if(ltd.configID=11 OR ltd.configID=7 ,'false','" + IsEdit + "') )IsEdit,if(ltd.configID=11 OR ltd.configID=7,'false','" + IsReject + "') IsReject,'" + CanViewRate + "' CanViewRate,");
                    sb.Append(" 'false' IsSurgery,ltd.DiscountReason,(SELECT (NAME)DiscGivenBy FROM employee_master WHERE EmployeeID=ltd.DiscUserID  LIMIT 1)DiscGivenBy,lt.TypeOfTnx,'' LabSampleCollected  From f_ledgertnxdetail ltd inner join f_ledgertransaction LT ");
                    sb.Append(" on ltd.LedgerTransactionNo = LT.LedgerTransactionNo WHERE Lt.IsCancel = 0 and ltd.IsVerified = 1 and ltd.IsPackage = 1 and  ltd.IsSurgery = 0 and lt.TransactionID = '" + TransID + "' ");
                    sb.Append(" and lt.Date >= '" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' and lt.Date <= '" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "' union all select ''Doctorname,ltd.configid,ltd.LedgerTransactionNo,lt.LedgerTransactionNo LtNo,lt.TransactionID,date_format(lt.Date,'%d-%b-%y')IssueDate,ltd.ItemID,ltd.SurgeryName ItemName,");
                    sb.Append("(select name from f_subcategorymaster where SubcategoryID=ltd.subcategoryid)subCategoryname,");
                    sb.Append("round(lt.GrossAmount,1) Rate,1 Quantity,");
                    sb.Append(" lt.DiscountOnTotal DiscPer,(lt.GrossAmount*lt.DiscountOnTotal)/100 DiscAmt,ltd.IsPayable,if(ltd.IsPayable=0,'Payable','Non-Payable')Payable,0 Amount,ltd.UserID,ltd.PackageID,'true' IsNPSurgery,IF(ltd.rate=0,'true',");

                    if (Authority.Rows.Count > 0)
                    {
                        if (Authority.Rows[0]["IsEdit"].ToString() == "1")
                        {
                            IsEdit = "false";
                            IsNPSurgery = "true";
                        }
                        if (Authority.Rows[0]["IsReject"].ToString() == "1")
                        {
                            IsReject = "true";
                        }
                    }
                    sb.Append(" '" + IsEdit + "' )IsEdit,'" + IsReject + "' IsReject,'" + CanViewRate + "' CanViewRate,");

                    sb.Append(" 'true' IsSurgery,ltd.DiscountReason,(SELECT (NAME)DiscGivenBy FROM employee_master WHERE EmployeeID=ltd.DiscUserID)DiscGivenBy,lt.TypeOfTnx,'' LabSampleCollected ");
                    sb.Append(" From f_ledgertnxdetail ltd inner join f_ledgertransaction LT on ltd.LedgerTransactionNo = LT.LedgerTransactionNo WHERE Lt.IsCancel = 0 and ltd.IsVerified = 1 and ltd.IsPackage = 1 and ltd.IsSurgery = 1 and lt.TransactionID = '" + TransID + "' ");
                    sb.Append(" and lt.Date >= '" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' and lt.Date <= '" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "' GROUP BY lt.LedgertransactionNo)T1 inner join employee_master em on T1.UserID = em.EmployeeID inner join f_itemmaster im on im.ItemID = t1.packageid order by IssueDate Desc");
                    break;

                case "11": // Medicine & Cosnumables
                    sb.Append("select (SELECT CONCAT(dm.Title,'',dm.Name) FROM doctor_master dm WHERE dm.DoctorID=ltd.DoctorID LIMIT 1)Doctorname,ltd.configid,ltd.LedgerTransactionNo,ltd.LedgerTnxID LtNo,lt.TransactionID,date_format(ltd.EntryDate,'%d-%b-%Y %l:%i %p')IssueDate,ltd.ItemName,ltd.Rate,ltd.Quantity,ltd.DiscountPercentage DiscPer,ltd.IsPayable,if(ltd.IsPayable=0,'Payable','Non-Payable')Payable,");
                    sb.Append(" ROUND((((ltd.Rate*ltd.Quantity)*ltd.DiscountPercentage)/100),2) DiscAmt,ltd.Amount,'---' Package,em.Name,'false' IsNPSurgery,");
                    sb.Append("(select name from f_subcategorymaster where SubcategoryID=ltd.subcategoryid)subCategoryname,IF(ltd.rate=0,'true',");
                    if (Authority.Rows.Count > 0)
                    {
                        if (Authority.Rows[0]["IsEdit"].ToString() == "1")
                        {
                            IsEdit = "false";
                        }
                        if (Authority.Rows[0]["IsReject"].ToString() == "1")
                        {
                            IsReject = "false";
                        }
                    }
                    sb.Append(" '" + IsEdit + "' )IsEdit,'" + IsReject + "' IsReject,'" + CanViewRate + "' CanViewRate,");

                    sb.Append("'false' IsSurgery,ltd.DiscountReason,sm.Name SubCat,sm.SubCategoryID,ltd.UserID,ltd.ItemID,(SELECT (NAME)DiscGivenBy FROM employee_master WHERE EmployeeID=ltd.DiscUserID Limit 1)DiscGivenBy,lt.TypeOfTnx,'' LabSampleCollected  ");
                    sb.Append(" From f_ledgertnxdetail ltd inner join f_ledgertransaction LT on ltd.LedgerTransactionNo = LT.LedgerTransactionNo inner join employee_master em on ltd.UserID = em.EmployeeID ");
                    sb.Append(" inner join f_subcategorymaster sm on sm.SubCategoryID = ltd.SubCategoryID inner join f_configrelation cf on sm.CategoryID = cf.CategoryID WHERE Lt.IsCancel = 0 and ltd.IsVerified = 1 and ltd.IsPackage = 0 and cf.ConfigID=11 and lt.TransactionID = '" + TransID + "' ");
                    sb.Append(" and lt.Date >= '" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' and lt.Date <= '" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "' ");
                    if (IsFilter)
                    {
                        string strItems = StockReports.GetSelection(chkFilterItem);
                        if (strItems != string.Empty)
                            sb.Append(" and ltd.itemid in (" + strItems + ")");
                        if (ddlUser.SelectedIndex > 0)
                            sb.Append(" and ltd.UserID = '" + ddlUser.SelectedValue + "'");
                    }
                    sb.Append(" order by ltd.EntryDate Desc");
                    break;

                //shatrughan blood bank--------------------------------------------------------------
                case "7"://BloodBank
                    sb.Append("select (SELECT CONCAT(dm.Title,'',dm.Name) FROM doctor_master dm WHERE dm.DoctorID=ltd.DoctorID LIMIT 1)Doctorname,ltd.configid,ltd.LedgerTransactionNo,ltd.LedgerTnxID LtNo,lt.TransactionID,date_format(ltd.EntryDate,'%d-%b-%Y %l:%i %p')IssueDate,ltd.ItemName,ltd.Rate,ltd.Quantity,ltd.DiscountPercentage DiscPer,ltd.IsPayable,if(ltd.IsPayable=0,'Payable','Non-Payable')Payable,");
                    sb.Append(" ROUND((((ltd.Rate*ltd.Quantity)*ltd.DiscountPercentage)/100),2) DiscAmt,ltd.Amount,'---' Package,em.Name,'false' IsNPSurgery,");
                    sb.Append("(select name from f_subcategorymaster where SubcategoryID=ltd.subcategoryid)subCategoryname,IF(ltd.rate=0,'false',");

                    sb.Append(" 'false')IsEdit,'false' IsReject,'" + CanViewRate + "' CanViewRate,");
                    sb.Append(" 'false' IsSurgery,ltd.DiscountReason,sm.Name SubCat,sm.SubCategoryID,ltd.UserID,ltd.ItemID,ltd.DiscountReason,(SELECT (NAME)DiscGivenBy FROM employee_master WHERE EmployeeID=ltd.DiscUserID LIMIT 1)DiscGivenBy,lt.TypeOfTnx,'' LabSampleCollected  ");
                    sb.Append(" From f_ledgertnxdetail ltd inner join f_ledgertransaction LT on ltd.LedgerTransactionNo = LT.LedgerTransactionNo inner join employee_master em on ltd.UserID = em.EmployeeID ");
                    sb.Append(" inner join f_subcategorymaster sm on sm.SubCategoryID = ltd.SubCategoryID WHERE Lt.IsCancel = 0 and ltd.IsVerified = 1 and ltd.IsPackage = 0 and sm.CategoryID = '" + DispName.Replace("'", "''") + "' and lt.TransactionID = '" + TransID + "'");
                    sb.Append(" and lt.Date >= '" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' and lt.Date <= '" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "' ");
                    if (IsFilter)
                    {
                        string strItems = StockReports.GetSelection(chkFilterItem);
                        if (strItems != string.Empty)
                            sb.Append(" and ltd.itemid in (" + strItems + ")");
                        if (ddlUser.SelectedIndex > 0)
                            sb.Append(" and ltd.UserID = '" + ddlUser.SelectedValue + "'");
                    }
                    sb.Append(" order by ltd.EntryDate Desc");

                    break;
                //shatrughan blood bank--------------------------------------------------------------


                case "2"://RoomCharges
                    sb.Append("select (SELECT CONCAT(dm.Title,'',dm.Name) FROM doctor_master dm WHERE dm.DoctorID=ltd.DoctorID LIMIT 1)Doctorname,ltd.configid,ltd.LedgerTransactionNo,ltd.LedgerTnxID LtNo,lt.TransactionID,date_format(ltd.EntryDate,'%d-%b-%Y %l:%i %p')IssueDate,ltd.ItemName,ltd.Rate,ltd.Quantity,ltd.DiscountPercentage DiscPer,ltd.IsPayable,if(ltd.IsPayable=0,'Payable','Non-Payable')Payable,");
                    sb.Append(" ROUND((((ltd.Rate*ltd.Quantity)*ltd.DiscountPercentage)/100),2) DiscAmt,ltd.Amount,'---' Package,em.Name,'false' IsNPSurgery,");
                    sb.Append("(select name from f_subcategorymaster where SubcategoryID=ltd.subcategoryid)subCategoryname,IF(ltd.rate=0,'true',");
                    if (Authority.Rows.Count > 0)
                    {
                        if (Authority.Rows[0]["IsEdit"].ToString() == "1")
                        {
                            IsEdit = "true";
                        }
                        if (Authority.Rows[0]["IsReject"].ToString() == "1")
                        {
                            IsReject = "true";
                        }
                    }
                    sb.Append(" '" + IsEdit + "')IsEdit,'" + IsReject + "' IsReject,'" + CanViewRate + "' CanViewRate,");
                    sb.Append(" 'false' IsSurgery,ltd.DiscountReason,sm.Name SubCat,sm.SubCategoryID,ltd.UserID,ltd.ItemID,ltd.DiscountReason,(SELECT (NAME)DiscGivenBy FROM employee_master WHERE EmployeeID=ltd.DiscUserID LIMIT 1)DiscGivenBy,lt.TypeOfTnx,'' LabSampleCollected  ");
                    sb.Append(" From f_ledgertnxdetail ltd inner join f_ledgertransaction LT on ltd.LedgerTransactionNo = LT.LedgerTransactionNo inner join employee_master em on ltd.UserID = em.EmployeeID ");
                    sb.Append(" inner join f_subcategorymaster sm on sm.SubCategoryID = ltd.SubCategoryID WHERE Lt.IsCancel = 0 and ltd.IsVerified = 1 and ltd.IsPackage = 0 and sm.CategoryID = '" + DispName.Replace("'", "''") + "' and lt.TransactionID = '" + TransID + "'");
                    sb.Append(" and lt.Date >= '" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' and lt.Date <= '" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "' ");
                    if (ViewState["DisplayName"].ToString() == "ATTENDENT ROOM")
                        sb.Append(" AND ltd.isAttendentRoom=1 ");
                    else
                        sb.Append(" AND ltd.isAttendentRoom=0 ");
                    if (IsFilter)
                    {
                        string strItems = StockReports.GetSelection(chkFilterItem);
                        if (strItems != string.Empty)
                            sb.Append(" and ltd.itemid in (" + strItems + ")");
                        if (ddlUser.SelectedIndex > 0)
                            sb.Append(" and ltd.UserID = '" + ddlUser.SelectedValue + "'");
                    }
                    sb.Append(" order by ltd.EntryDate,ltd.ItemID Desc");
                    break;
                default:
                    sb.Append("select (SELECT CONCAT(dm.Title,'',dm.Name) FROM doctor_master dm WHERE dm.DoctorID=ltd.DoctorID LIMIT 1)Doctorname,ltd.configid,ltd.LedgerTransactionNo,ltd.LedgerTnxID LtNo,lt.TransactionID,date_format(ltd.EntryDate,'%d-%b-%Y %l:%i %p')IssueDate,ltd.ItemName,ltd.Rate,ltd.Quantity,ltd.DiscountPercentage DiscPer,ltd.IsPayable,if(ltd.IsPayable=0,'Payable','Non-Payable')Payable,");
                    sb.Append(" ROUND((((ltd.Rate*ltd.Quantity)*ltd.DiscountPercentage)/100),2) DiscAmt,ltd.Amount,'---' Package,em.Name,'false' IsNPSurgery,");
                    sb.Append("(select name from f_subcategorymaster where SubcategoryID=ltd.subcategoryid)subCategoryname,IF(ltd.rate=0,'true',");
                    if (Authority.Rows.Count > 0)
                    {
                        if (Authority.Rows[0]["IsEdit"].ToString() == "1")
                        {
                            IsEdit = "true";
                        }
                        if (Authority.Rows[0]["IsReject"].ToString() == "1")
                        {
                            IsReject = "true";
                        }
                    }
                    sb.Append(" '" + IsEdit + "')IsEdit,'" + IsReject + "' IsReject,'" + CanViewRate + "' CanViewRate,");
                    sb.Append(" 'false' IsSurgery,ltd.DiscountReason,sm.Name SubCat,sm.SubCategoryID,ltd.UserID,ltd.ItemID,ltd.DiscountReason,(SELECT (NAME)DiscGivenBy FROM employee_master WHERE EmployeeID=ltd.DiscUserID LIMIT 1)DiscGivenBy,lt.TypeOfTnx,ltd.LabSampleCollected ");
                    sb.Append(" From f_ledgertnxdetail ltd inner join f_ledgertransaction LT on ltd.LedgerTransactionNo = LT.LedgerTransactionNo inner join employee_master em on ltd.UserID = em.EmployeeID ");
                    sb.Append(" inner join f_subcategorymaster sm on sm.SubCategoryID = ltd.SubCategoryID WHERE Lt.IsCancel = 0 and ltd.IsVerified = 1 and ltd.IsPackage = 0 and sm.CategoryID = '" + DispName.Replace("'", "''") + "' and lt.TransactionID = '" + TransID + "'");
                    sb.Append(" and lt.Date >= '" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' and lt.Date <= '" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "' ");
                    if (IsFilter)
                    {
                        string strItems = StockReports.GetSelection(chkFilterItem);
                        if (strItems != string.Empty)
                            sb.Append(" and ltd.itemid in (" + strItems + ")");
                        if (ddlUser.SelectedIndex > 0)
                            sb.Append(" and ltd.UserID = '" + ddlUser.SelectedValue + "'");
                    }
                    sb.Append(" order by ltd.EntryDate,ltd.ItemID Desc");
                    break;
            }

            //---------------------------------------------------------------------
            //---------------------------------------------------------------------

            DataTable dt = GetItemDataTable();
            dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                gvItemDetail.DataSource = dt;
                gvItemDetail.DataBind();
                // MarcTooltips.add(".customTooltip", "", { position: "up", align: "left", mouseover: true });
               // ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "MarcTooltips.add('#lblItem', '', { position: 'up', align: 'left', mouseover: true })", true);
                if (chkItem.Checked)
                    for (int iStatus = 0; iStatus < gvItemDetail.Rows.Count; iStatus++)
                        ((CheckBox)gvItemDetail.Rows[iStatus].FindControl("ChkSelect")).Checked = true;

                lblMsg.Text = string.Empty;
                lblFilterAmount.Text = string.Empty;

                if (ConfigID != "22" && ConfigID != "14") // Not Equal to Surgery-22 and Package-14
                    if (CanViewRate == true)
                        lblFilterAmount.Text = Util.GetString(dt.Compute("sum(Amount)", ""));
                    else
                        lblFilterAmount.Text = "";

                double total = 0;
                if (ConfigID == "14")  // for Package-14
                    foreach (DataRow dr in dt.Rows)
                    {
                        total += (Convert.ToDouble(dr["Rate"]) * Convert.ToDouble(dr["Quantity"])) - Convert.ToDouble(dr["DiscAmt"]);
                    }

                if (ConfigID == "14")
                    if (CanViewRate == true)
                        lblFilterAmount.Text = total.ToString("N"); //Util.GetString(dt.Compute("sum((Rate * Quantity)-DiscAmt)", ""));

                if (!IsFilter)
                    if (ConfigID != "22" && ConfigID != "14") // Not Equal to Surgery-22 and Package-14
                    {
                        DataView dvSubcat = dt.DefaultView.ToTable(true, new string[] { "SubCat", "SubCategoryID" }).DefaultView;
                        dvSubcat.Sort = "SubCat";
                        ddlSubCategory.DataSource = dvSubcat;
                        ddlSubCategory.DataTextField = "SubCat";
                        ddlSubCategory.DataValueField = "SubCategoryID";
                        ddlSubCategory.DataBind();
                        ddlSubCategory.Items.Insert(0, new ListItem("All", "0"));

                        DataView dvUser = dt.DefaultView.ToTable(true, new string[] { "Name", "UserID" }).DefaultView;
                        dvUser.Sort = "Name";
                        ddlUser.DataSource = dvUser;
                        ddlUser.DataTextField = "Name";
                        ddlUser.DataValueField = "UserID";
                        ddlUser.DataBind();
                        ddlUser.Items.Insert(0, new ListItem("All", "0"));

                        DataView dvItem = dt.DefaultView.ToTable(true, new string[] { "ItemName", "ItemID" }).DefaultView;
                        dvItem.Sort = "ItemName";
                        chkFilterItem.DataSource = dvItem;
                        chkFilterItem.DataTextField = "ItemName";
                        chkFilterItem.DataValueField = "ItemID";
                        chkFilterItem.DataBind();
                    }
            }
            else
            {
                gvItemDetail.DataSource = null;
                gvItemDetail.DataBind();
                lblMsg.Text = "No Details Found";
                lblFilterAmount.Text = string.Empty;
            }
            SetShowHide();
        }
    }

    private void BindPackage()
    {
        DataTable dt = GetPackage();
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlPackage.DataSource = dt;
            ddlPackage.DataTextField = "TypeName";
            ddlPackage.DataValueField = "ItemID";
            ddlPackage.DataBind();
            ddlPackage.Items.Insert(0, new ListItem("No Package", "0"));
            btnItemPkgSave.Enabled = true;
        }
        else
        {
            ddlPackage.Items.Clear();
            btnItemPkgSave.Enabled = false;
        }
    }

    private DataTable GetPackage()
    {
        if (ViewState["TransID"] != null)
        {
            string IsEdit = "true";
            string IsReject = "false";
            DataTable Authority = (DataTable)ViewState["Authority"];
            string TID = Convert.ToString(ViewState["TransID"]);

            StringBuilder sb = new StringBuilder();
            sb.Append(" select LedgerTnxID,Amount,TypeName,Discount,DiscReason,PDate,ItemID,Quantity,Rate, ");

            if (Authority.Rows.Count > 0)
            {
                if (Authority.Rows[0]["IsEdit"].ToString() == "1")
                {
                    IsEdit = "true";
                }
                if (Authority.Rows[0]["IsReject"].ToString() == "1")
                {
                    IsReject = "true";
                }
            }
            sb.Append(" '" + IsEdit + "' IsEdit,'" + IsReject + "' IsReject,");
            sb.Append(" if(Items is null,'true','false')IsRejectItems");
            sb.Append(" from (select T1.LedgerTnxID,T1.Amount,t1.ItemID,T1.TypeName,t1.PDate,t1.Discount,t2.Items,t1.DiscReason,t1.Quantity,t1.Rate from");
            sb.Append(" (select ltd.LedgerTnxID,ltd.ItemID,ltd.Amount,ltd.`Rate`, ltd.`DiscountReason` AS DiscReason,ltd.`DiscountPercentage` AS Discount,im.TypeName,date_format(ltd.EntryDate,'%d-%b-%y') PDate,ltd.Quantity ");
            sb.Append(" from f_ledgertnxdetail ltd inner join f_itemmaster im on ltd.ItemID = im.ItemID inner join f_subcategorymaster sm");
            sb.Append(" on sm.SubCategoryID = im.SubCategoryID inner join f_configrelation cf on sm.CategoryID=cf.CategoryID ");
            sb.Append(" where ltd.IsPackage = 0 and ltd.IsVerified = 1 and ltd.IsFree = 0 ");
            sb.Append(" and ltd.TransactionID = '" + TID + "' and cf.configID=14 )T1 left join ");
            sb.Append(" (select PackageID,count(*) Items from f_ledgertnxdetail ltd where ltd.IsPackage = 0 and ltd.IsVerified = 1 ");
            sb.Append(" and IsFree = 0 and ltd.TransactionID = '" + TID + "' group by ltd.PackageID)T2 on t1.itemid = t2.PackageID )T3");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            return dt;
        }
        else
            return null;
    }

    private void GetSelection()
    {
        string strLtNo = string.Empty, strLtdNo = string.Empty;

        foreach (GridViewRow row in gvItemDetail.Rows)
            if (((CheckBox)row.FindControl("ChkSelect")).Checked)
            {
                string ltno = ((Label)row.FindControl("lblLedTnxNo")).Text;
                string LedgerTransactionNo = ((Label)row.FindControl("lblLedgerTransactionNo")).Text;
                if (((Label)row.FindControl("lblIsSurgery")).Text.ToUpper() != "TRUE")
                {
                    if (strLtdNo != string.Empty)
                    {
                        strLtdNo += ",'" + ltno + "'";
                    }
                    else
                    {
                        strLtdNo += "'" + ltno + "'";
                    }
                }
                else
                {
                    if (strLtNo != string.Empty)
                        strLtNo += ",'" + ltno + "'";
                    else
                        strLtNo += "'" + ltno + "'";
                }
            }

        lblLtdNo.Text = strLtdNo;
        lblLTNo.Text = strLtNo;
    }

    private void SetShowHide()
    {
        string DispName = Convert.ToString(ViewState["DispName"]).ToUpper();
        string ConfigID = Convert.ToString(ViewState["ConfigID"]);
        DataTable Authority = (DataTable)ViewState["Authority"];
        if (Authority.Rows.Count > 0)
        {
            if (Authority.Rows[0]["IsEdit"].ToString() == "1")
            {
                btnRate.Enabled = true;
                //btnPackage.Enabled = true;
            }
            if (Authority.Rows[0]["IsDiscount"].ToString() == "1")
            {
                btnDiscount.Enabled = true;
            }
            if (Authority.Rows[0]["IsReject"].ToString() == "1")
            {
                if (ConfigID != "11")
                    btnReject.Enabled = false;
                else
                    btnReject.Enabled = false;
                if (ConfigID == "7")
                    btnReject.Enabled = false;
            }
        }
        switch (ConfigID)
        {
            case "22": // Surgery
                btnFilter.Enabled = false;
                btnDiscount.Enabled = false;
                btnRate.Enabled = false;
                btnReject.Enabled = true;
                btnQty.Enabled = false;
                break;

            case "14": // Package
                btnFilter.Enabled = true;
                btnRate.Enabled = false;
                btnDiscount.Enabled = false;
                btnReject.Enabled = false;
                btnPackage.Enabled = true;
                break;

            case "11": // Medicine & Consumables
                btnFilter.Enabled = true;
                btnDiscount.Enabled = false;
                btnRate.Enabled = false;
                btnReject.Enabled = false;
                btnPackage.Enabled = true;
                btnQty.Enabled = false;
                break;
            case "3": // Medicine & Consumables
                btnFilter.Enabled = true;
                btnDiscount.Enabled = true;
                btnRate.Enabled = true;
                btnReject.Enabled = true;
                btnPackage.Enabled = true;
                btnQty.Enabled = false;
                break;
            default:
                btnFilter.Enabled = true;
                btnRate.Enabled = true;
                btnDiscount.Enabled = true;
                btnReject.Enabled = true;
                btnPackage.Enabled = true;
                btnQty.Enabled = true;
                break;
        }
        if (Authority.Rows.Count > 0)
        {
            if (Authority.Rows[0]["IsReject"].ToString() != "1")
            {
                btnReject.Enabled = false;
            }
            if (Authority.Rows[0]["IsEdit"].ToString() != "1")
            {
                btnRate.Enabled = false;
                //btnPackage.Enabled = true;
            }
            if (Authority.Rows[0]["IsDiscount"].ToString() != "1")
            {
                btnDiscount.Enabled = false;
            }
        }
        else {
            btnReject.Enabled = false;
            btnRate.Enabled = false;
            btnDiscount.Enabled = false;
        }
    }

    private void DisableJobs()
    {
        btnFilter.Enabled = false;
        btnRate.Enabled = false;
        btnDiscount.Enabled = false;
        btnReject.Enabled = false;
        btnQty.Enabled = false;
        btnPackage.Enabled = false;
        if (lblPanelID.Text == "1")
        {
            btnNonPayable.Enabled = false;

        }
    }

    #endregion Data Binding

    #region DML Operations

    /// <summary>
    /// For Rejecting Items
    /// </summary>
    /// <param name="LtNo">LedgerTransactionNo</param>
    /// <param name="LtdNo">LedgerTnxID</param>
    /// <returns>True if Successfully</returns>
    private bool RejectItems(string LtNo, string LtdNo, string Reason)
    {
        //if (!ValidateRefundItem(LtNo, LtdNo))
        //{ // after Report Approval INVESTIGATION IS NOT Reject thats Why comment return false;
        //    return false;
        //}
        string str = string.Empty;
        bool iResult = false;

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {

            if (LtNo != string.Empty)
            {
                str = "Select * from f_ledgertnxdetail where LedgerTransactionNo in (" + LtNo + ") and IsVerified=1 and IsMedService=1";
                str = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, str));

                if (str == string.Empty)
                {
                    str = "update f_ledgertnxdetail set IsVerified = 2,CancelUserId='" + Session["ID"].ToString() + "',CancelDatetime=now(),CancelReason='" + txtCancelReason.Text.Trim() + "',LastUpdatedBy = '" + ViewState["UserID"] + "',Updateddate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',IpAddress = '" + Util.GetString(All_LoadData.IpAddress()) + "' where LedgerTransactionNo in (" + LtNo + ")";
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
                    str = "DELETE ds.* FROM f_docshare_transactiondetail ds WHERE ds.LedgerTransactionNo IN (" + LtNo + ")";
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
                }
                else
                {
                    lblMsg.Text = "Items Cannot be rejected since it is med service items and issued from med store or nursing station.";
                }
            }
            if (LtdNo != string.Empty)
            {
                str = "";
                if (str == string.Empty)
                {
                    str = "update f_ledgertnxdetail set IsVerified = 2,CancelUserId='" + Session["ID"].ToString() + "',CancelDatetime=now(),CancelReason='" + txtCancelReason.Text.Trim() + "',LastUpdatedBy = '" + ViewState["UserID"] + "',Updateddate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',IpAddress = '" + Util.GetString(All_LoadData.IpAddress()) + "' where LedgerTnxID in (" + LtdNo + ")";
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);

                    var ledgertnxIDs = LtdNo.Split(',');
                    foreach (string s in ledgertnxIDs)
                    {
                        string _categoryid = StockReports.ExecuteScalar("SELECT sc.CategoryID FROM f_ledgertnxdetail ltd INNER JOIN f_subcategorymaster sc ON sc.subcategoryid = ltd.subcategoryid WHERE ltd.LedgertnxID ="+ s +" ");
                        //if (_categoryid == "3")
                        //{
                        //    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "CALL lis_interface_delete(" + s + ",0)");
                        //}
                    }
                    CalcaluteDoctorShare(LtdNo, Tranx, con);
                }
                else
                {
                    lblMsg.Text = "Med";
                }
            }
            Tranx.Commit();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            iResult = true;
        }
        catch (Exception ex)
        {
            var c1 = new ClassLog();
            c1.errLog(ex);
            Tranx.Rollback();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            iResult = false;
        }
        return iResult;
    }

    #endregion DML Operations

    protected void gvItemDetail_RowDataBound(object sender, GridViewRowEventArgs e)
    {

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            string ItemID = ((Label)e.Row.FindControl("lblItemID")).Text;
            string IssueDate = ((Label)e.Row.FindControl("lblDate")).Text;
            string LedgerTnxID = ((Label)e.Row.FindControl("lblLedTnxNo")).Text;

            // string DiscReason =  StockReports.ExecuteScalar("Select DiscountReason from f_LedgertnxDetail where LedgerTnxID='" + LedgerTnxID + "'");
            string DiscReason = ((Label)e.Row.FindControl("lblDiscountReason")).Text;
            //if (DiscReason != "")
            //    DiscReason = "<b>Disc. Reason : " + DiscReason + "</b>";



            GridView gv = ((GridView)e.Row.Parent.Parent);

            if (((Label)e.Row.FindControl("lblLabSampleCollected")).Text == "R")
            {
                e.Row.Attributes.Add("style", "background-color:#FF99CC");
                e.Row.Attributes.Add("title", "Sample Rejected");
            }
            if (((Label)e.Row.FindControl("lblTypeOfTnx")).Text.ToUpper() == "CR" || ((Label)e.Row.FindControl("lblTypeOfTnx")).Text.ToUpper() == "DR")
            {
                ((CheckBox)e.Row.FindControl("ChkSelect")).Visible = false;
                ((ImageButton)e.Row.FindControl("imbEdit")).Visible = false;
                ((ImageButton)e.Row.FindControl("imbReject")).Visible = false;
            }
            foreach (GridViewRow grow in gv.Rows)
            {
                string NxtItemID = ((Label)grow.FindControl("lblItemID")).Text;
                string Date = ((Label)grow.FindControl("lblDate")).Text;

                if (NxtItemID == ItemID && IssueDate == Date)
                {
                    e.Row.BackColor = System.Drawing.Color.Orchid;
                    e.Row.Attributes.Add("title", "Item Already Prescribed on Same Day");
                }
                if (Session["RoleID"].ToString() == "213")
                {
                    ((ImageButton)e.Row.FindControl("imbEdit")).Visible = false;
                    ((ImageButton)e.Row.FindControl("imbReject")).Visible = false;
                }
            }
            if (DiscReason != "")
                e.Row.Attributes.Add("title", DiscReason);
        }
    }
    protected void btnOKRejection_Click(object sender, EventArgs e)
    {
        bool Result = false;
    
        lblMsg.Text = "";

        GetSelection();
        //lblLedTnxNo
        if (lblIsSurgery.Text != "TRUE")
        {
            
            if (lblLedTnxID.Text.Trim() != "")
            {
                int ResultFlag = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_ledgertnxdetail ltd INNER JOIN patient_labinvestigation_opd plo ON plo.LedgertnxID=ltd.ID INNER JOIN investigation_master im ON im.Investigation_Id=plo.Investigation_ID WHERE ltd.LedgerTnxID='" + lblLedTnxID.Text.Trim() + "' AND IFNULL(plo.Result_Flag,0)=1 AND im.ReportType<>5"));
                if (ResultFlag > 0)
                {
                   // lblMsg.Text = "Result Already Done, Can Not Reject this Test.";
                  //  return;
                }
                ResultFlag = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_ledgertnxdetail ltd INNER JOIN patient_labinvestigation_opd plo ON plo.LedgertnxID=ltd.ID INNER JOIN investigation_master im ON im.Investigation_Id=plo.Investigation_ID WHERE ltd.LedgerTnxID='" + lblLedTnxID.Text.Trim() + "' AND IFNULL(plo.P_IN,0)=1 AND im.ReportType = 5 "));
                if (ResultFlag > 0)
                {
                 //   lblMsg.Text = "Patient Already Done the Scan, Can Not Reject this Test.";
                  //  return;
                }
                Result = RejectItems(string.Empty, "'" + lblLedTnxID.Text.Trim() + "'", txtCancelReason.Text.Trim());
                lblLedTnxID.Text = "";
            }
            else
            {
                int ResultFlag = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_ledgertnxdetail ltd INNER JOIN patient_labinvestigation_opd plo ON plo.LedgertnxID=ltd.ID INNER JOIN investigation_master im ON im.Investigation_Id=plo.Investigation_ID WHERE ltd.LedgerTnxID IN (" + lblLtdNo.Text.Trim() + ") AND IFNULL(plo.Result_Flag,0)=1 AND im.ReportType<>5"));
                if (ResultFlag > 0)
                {
                    lblMsg.Text = "Result Already Done, Can Not Reject this Test.";
                    return;
                }
                ResultFlag = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_ledgertnxdetail ltd INNER JOIN patient_labinvestigation_opd plo ON plo.LedgertnxID=ltd.ID INNER JOIN investigation_master im ON im.Investigation_Id=plo.Investigation_ID WHERE ltd.LedgerTnxID IN (" + lblLtdNo.Text.Trim() + ") AND IFNULL(plo.P_IN,0)=1 AND im.ReportType = 5 "));
                if (ResultFlag > 0)
                {
                    lblMsg.Text = "Patient Already Done the Scan, Can Not Reject this Test.";
                    return;
                }
                Result = RejectItems(string.Empty, lblLtdNo.Text.Trim(), txtCancelReason.Text.Trim());
                lblLtdNo.Text = "";
            }
        }
        else
        {
            if (lblLedTnxNo.Text.Trim() != "")
            {
                Result = RejectItems("'" + lblLedTnxNo.Text.Trim() + "'", string.Empty, txtCancelReason.Text.Trim());
                lblLedTnxNo.Text = "";
            }
            else
            {
                Result = RejectItems(lblLTNo.Text.Trim(), string.Empty, txtCancelReason.Text.Trim());
                lblLTNo.Text = "";
            }
        }

        if (Result)
        {
            BindDepartment();
            ShowItemDetails();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM052','" + lblMsg.ClientID + "');", true);

            lblIsSurgery.Text = "";
            lblLedTnxID.Text = "";
            lblLedTnxNo.Text = "";
            txtCancelReason.Text = "";
        }
        else
        {
            if (lblMsg.Text != "Med")
            {
                //lblMsg.Text = "Error...";
            }
            else
                lblMsg.Text = "Items Cannot be rejected since it is med. service items and issued from med. store or nursing station.It can be rejected from respective issued dept.";
        }
    }

    private bool ValidateRefundItem(string LtNo, string LtdNo)
    {
        string Rejected = string.Empty;
        //string LtNo = string.Empty;
        //string LtdNo = lblLtdNo.Text.Trim();
        int IsLabItem = 0;
        if (LtNo != string.Empty)
            IsLabItem = Util.GetInt(StockReports.ExecuteScalar("select count(*) from f_configrelation cr inner join f_subcategorymaster sc on cr.CategoryID = sc.CategoryID and cr.ConfigID=3 inner join f_ledgertnxdetail ltd on ltd.SubCategoryID = sc.SubCategoryID and ltd.LedgerTransactionNo in (" + LtNo + ")"));
        if (LtdNo != string.Empty)
            IsLabItem = Util.GetInt(StockReports.ExecuteScalar("select count(*) from f_configrelation cr inner join f_subcategorymaster sc on cr.CategoryID = sc.CategoryID and cr.ConfigID=3 inner join f_ledgertnxdetail ltd on ltd.SubCategoryID = sc.SubCategoryID and LedgerTnxID in (" + LtdNo + ")"));

        if (IsLabItem > 0)
        {
            DataTable dt = new DataTable();

            if (LtNo != string.Empty)
                dt = StockReports.GetDataTable("select pl.ID,pl.Investigation_ID  from f_itemmaster im inner join f_ledgertnxdetail ltd on im.ItemID=ltd.ItemID  and ltd.LedgerTransactionNo in (" + LtNo + ") inner join patient_labinvestigation_opd pl on pl.Investigation_ID = im.Type_ID  and ltd.LedgerTransactionNo = pl.LedgerTransactionNo and IsSampleCollected='Y' ;");

            if (LtdNo != string.Empty)
                dt = StockReports.GetDataTable("select pl.ID,pl.Investigation_ID  from f_itemmaster im inner join f_ledgertnxdetail ltd on im.ItemID=ltd.ItemID  and LedgerTnxID in (" + LtdNo + ") inner join patient_labinvestigation_opd pl on pl.Investigation_ID = im.Type_ID  and ltd.LedgerTransactionNo = pl.LedgerTransactionNo and IsSampleCollected='Y';");

            DataTable dtauth = (DataTable)ViewState["Authority"];
            if (dtauth.Rows.Count > 0)
            {
                Rejected = dtauth.Rows[0]["IsLabReject"].ToString();
            }

            if (Rejected != "1" && Rejected != string.Empty)
            {
                //if (dtauth.Rows[0]["IsLabReject"].ToString() != "1")
                //{
                if (dt.Rows.Count > 0)
                {
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        string ID = dt.Rows[i]["Investigation_ID"].ToString();
                        if (ID != "")
                        {
                            string SampleType = StockReports.ExecuteScalar("Select Type from investigation_master where investigation_ID='" + ID + "'");

                            if (SampleType != "" && SampleType == "N")
                            {
                                DataTable dtradio = new DataTable();
                                dtradio = StockReports.GetDataTable("select pl.ID,pl.Investigation_ID  from f_itemmaster im inner join f_ledgertnxdetail ltd on im.ItemID=ltd.ItemID  and ltd.SubCategoryID = im.SubCategoryID and LedgerTnxID in (" + LtdNo + ") inner join patient_labinvestigation_opd pl on pl.Investigation_ID = im.Type_ID  and ltd.LedgerTransactionNo = pl.LedgerTransactionNo and Result_Flag>0;");
                                if (dtradio.Rows.Count > 0)
                                {
                                    lblMsg.Text = "You Can't Delete the Item(s) because Result is Made.";
                                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('" + lblMsg.ClientID + "', function () { });", true);
                                    return false;
                                }
                                else
                                {
                                    DataTable dt3 = new DataTable();

                                    if (LtNo != string.Empty)
                                        dt3 = StockReports.GetDataTable("select pl.ID  from f_itemmaster im inner join f_ledgertnxdetail ltd on im.ItemID=ltd.ItemID  and ltd.SubCategoryID = im.SubCategoryID and ltd.LedgerTransactionNo in (" + LtNo + ") inner join patient_labinvestigation_opd pl on pl.Investigation_ID = im.Type_ID  and ltd.LedgerTransactionNo = pl.LedgerTransactionNo ;");
                                    if (LtdNo != string.Empty)
                                        dt3 = StockReports.GetDataTable("select pl.ID  from f_itemmaster im inner join f_ledgertnxdetail ltd on im.ItemID=ltd.ItemID  and ltd.SubCategoryID = im.SubCategoryID and LedgerTnxID in (" + LtdNo + ") inner join patient_labinvestigation_opd pl on pl.Investigation_ID = im.Type_ID  and ltd.LedgerTransactionNo = pl.LedgerTransactionNo ;");

                                    if (dt3.Rows.Count > 0)
                                    {
                                        for (int j = 0; j < dt3.Rows.Count; j++)
                                        {
                                            string LedgerNo = StockReports.ExecuteScalar("Select LedgerTransactionNO from patient_labinvestigation_opd where ID='" + dt3.Rows[i]["ID"].ToString() + "'");
                                            StockReports.ExecuteDML("update patient_labinvestigation_opd set LedgerTransactionNoOLD='" + LedgerNo + "' where ID='" + dt3.Rows[i]["ID"].ToString() + "'");
                                            StockReports.ExecuteDML("update patient_labinvestigation_opd set LedgerTransactionNO='' where ID='" + dt3.Rows[i]["ID"].ToString() + "'");
                                            //StockReports.ExecuteDML("delete from patient_labinvestigation_opd where ID='" + dt3.Rows[j]["ID"].ToString() + "'");

                                            StockReports.ExecuteDML("CALL lis_interface_delete('" + LtdNo + "',0); ");

                                        }
                                        return true;
                                    }
                                    else
                                        return false;
                                }
                            }
                            else
                            {
                                lblMsg.Text = "You Can't Reject the Item(s) because Sample Is Received";
                                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('" + lblMsg.Text + "', function () { });", true);
                                return false;
                            }
                        }
                    }
                }
                else
                {
                    DataTable dt2 = new DataTable();

                    if (LtNo != string.Empty)
                        dt2 = StockReports.GetDataTable("select pl.ID  from f_itemmaster im inner join f_ledgertnxdetail ltd on im.ItemID=ltd.ItemID  and ltd.SubCategoryID = im.SubCategoryID and ltd.LedgerTransactionNo in (" + LtNo + ") inner join patient_labinvestigation_opd pl on pl.Investigation_ID = im.Type_ID  and ltd.LedgerTransactionNo = pl.LedgerTransactionNo and Result_Flag= 0 ;");
                    if (LtdNo != string.Empty)
                        dt2 = StockReports.GetDataTable("select pl.ID  from f_itemmaster im inner join f_ledgertnxdetail ltd on im.ItemID=ltd.ItemID  and ltd.SubCategoryID = im.SubCategoryID and LedgerTnxID in (" + LtdNo + ") inner join patient_labinvestigation_opd pl on pl.Investigation_ID = im.Type_ID  and ltd.LedgerTransactionNo = pl.LedgerTransactionNo and Result_Flag= 0 ;");

                    if (dt2.Rows.Count > 0)
                    {
                        for (int i = 0; i < dt2.Rows.Count; i++)
                        {
                            string LedgerNo = StockReports.ExecuteScalar("Select LedgerTransactionNO from patient_labinvestigation_opd where ID='" + dt2.Rows[i]["ID"].ToString() + "'");
                            StockReports.ExecuteDML("update patient_labinvestigation_opd set LedgerTransactionNoOLD='" + LedgerNo + "' where ID='" + dt2.Rows[i]["ID"].ToString() + "'");
                            StockReports.ExecuteDML("update patient_labinvestigation_opd set LedgerTransactionNO='' where ID='" + dt2.Rows[i]["ID"].ToString() + "'");
                            //StockReports.ExecuteDML("delete from patient_labinvestigation_opd where ID='" + dt2.Rows[i]["ID"].ToString() + "'");
                        }
                        return true;
                    }
                    else
                        return false;
                }
            }
            else
            {
                DataTable dt2 = new DataTable();

                if (LtNo != string.Empty)
                    dt2 = StockReports.GetDataTable("select pl.ID  from f_itemmaster im inner join f_ledgertnxdetail ltd on im.ItemID=ltd.ItemID  and ltd.SubCategoryID = im.SubCategoryID and ltd.LedgerTransactionNo in (" + LtNo + ") inner join patient_labinvestigation_opd pl on pl.Investigation_ID = im.Type_ID  and ltd.LedgerTransactionNo = pl.LedgerTransactionNo and Result_Flag= 0 ;");
                if (LtdNo != string.Empty)
                    dt2 = StockReports.GetDataTable("select pl.ID  from f_itemmaster im inner join f_ledgertnxdetail ltd on im.ItemID=ltd.ItemID  and ltd.SubCategoryID = im.SubCategoryID and LedgerTnxID in (" + LtdNo + ") inner join patient_labinvestigation_opd pl on pl.Investigation_ID = im.Type_ID  and ltd.LedgerTransactionNo = pl.LedgerTransactionNo and Result_Flag= 0 ;");

                if (dt2.Rows.Count > 0)
                {
                    for (int i = 0; i < dt2.Rows.Count; i++)
                    {
                        string LedgerNo = StockReports.ExecuteScalar("Select LedgerTransactionNO from patient_labinvestigation_opd where ID='" + dt2.Rows[i]["ID"].ToString() + "'");
                        StockReports.ExecuteDML("update patient_labinvestigation_opd set LedgerTransactionNoOLD='" + LedgerNo + "' where ID='" + dt2.Rows[i]["ID"].ToString() + "'");
                        StockReports.ExecuteDML("update patient_labinvestigation_opd set LedgerTransactionNO='0' where ID='" + dt2.Rows[i]["ID"].ToString() + "'");

                        //StockReports.ExecuteDML("delete from patient_labinvestigation_opd where ID='" + dt2.Rows[i]["ID"].ToString() + "'");
                    }
                    return true;
                }
                else
                    return false;
            }
        }
        return true;
    }


    protected void btnNonPayable_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            foreach (GridViewRow row in gvItemDetail.Rows)
            {
                if (((CheckBox)row.FindControl("ChkSelect")).Checked)
                {
                    if (((Label)row.FindControl("lblIsSurgery")).Text == "false")
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_ledgertnxdetail SET IsPayable=1,LastUpdatedBy = '" + ViewState["UserID"] + "',UpdatedDate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',IpAddress = '" + Util.GetString(All_LoadData.IpAddress()) + "' WHERE LedgerTnxID ='" + ((Label)row.FindControl("lblLedTnxNo")).Text + "'  ");
                    }
                    else
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_ledgertnxdetail SET IsPayable=1,LastUpdatedBy = '" + ViewState["UserID"] + "',UpdatedDate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',IpAddress = '" + Util.GetString(All_LoadData.IpAddress()) + "' WHERE LedgerTransactionNo ='" + ((Label)row.FindControl("lblLedTnxNo")).Text + "'  ");

                    }
                }
            }
            tnx.Commit();

            ShowItemDetails();
            GetBillDetails();
            lblMsg.Text = "Item Updated Successfully";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('" + lblMsg.Text + "', function () { });", true);
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
    protected void btnPayable_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            foreach (GridViewRow row in gvItemDetail.Rows)
            {
                if (((CheckBox)row.FindControl("ChkSelect")).Checked)
                {
                    if (((Label)row.FindControl("lblIsSurgery")).Text == "false")
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_ledgertnxdetail SET IsPayable=0,LastUpdatedBy = '" + ViewState["UserID"] + "',UpdatedDate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',IpAddress = '" + Util.GetString(All_LoadData.IpAddress()) + "' WHERE LedgerTnxID ='" + ((Label)row.FindControl("lblLedTnxNo")).Text + "'  ");
                    }
                    else
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_ledgertnxdetail SET IsPayable=0,LastUpdatedBy = '" + ViewState["UserID"] + "',UpdatedDate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',IpAddress = '" + Util.GetString(All_LoadData.IpAddress()) + "' WHERE LedgerTransactionNo ='" + ((Label)row.FindControl("lblLedTnxNo")).Text + "'  ");
                    }
                }
            }
            tnx.Commit();

            ShowItemDetails();
            GetBillDetails();
            lblMsg.Text = "Item Updated Successfully";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('" + lblMsg.Text + "', function () { });", true);
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void lnkOutStanding_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key3", " window.open('../OPD/OPDAdvance_OutStanding.aspx?PatientID=" + lblPatientID.Text + "');", true);
    }
    //Devendra Singh 2018-10-09
    [WebMethod(EnableSession = true)]
    public static string BindBillDetails(string TransactionID)
    {
        string str = "";
        str = "SELECT pmh.PanelID,pm.PatientID,IFNULL((SELECT PatientOutstanding(pm.PatientID)),0)Outstanding, " +
        "pm.EmergencyPhoneNo,UPPER(pm.EmergencyRelationShip)EmergencyRelationShip , pmh.KinPhone, " +
        "UPPER(pmh.KinName)KinName,IFNULL((SELECT IFNULL(adj.DiscountOnBill,0)+SUM(ltd.TotalDiscAmt) " +
        "FROM f_ledgertnxdetail ltd INNER JOIN patient_medical_history adj ON ltd.TransactionID = adj.TransactionID " +//f_ipdadjustment
        "WHERE adj.TransactionID='" + TransactionID + "' AND ltd.isverified=1 AND ltd.ispackage=0),0)TotalDisc, " +
        "(SELECT IFNULL(ROUND(SUM(AmountPaid),2),0)  FROM ( " +
        "    SELECT AmountPaid FROM f_reciept WHERE TransactionID='" + TransactionID + "' AND IsCancel = 0 AND Paidby='PAT' AND IsEdit=0  " +
        "    UNION ALL  " +
        "    SELECT AmountPaid FROM f_reciept_log WHERE TransactionID='" + TransactionID + "' AND IsCancel = 0 AND Paidby='PAT'  " +
        ")t)PaidAmount, " +
        "(SELECT ROUND(IFNULL(SUM(a.PanelApprovedAmt),0),2) FROM f_IpdPanelApproval a WHERE a.isActive=1 AND a.TransactionID='" + TransactionID + "')PanelApprovedAmt, " +
        "(IFNULL(pmh.Deduction_Acceptable,0)+IFNULL(pmh.Deduction_NonAcceptable,0)+IFNULL(pmh.TDS,0)+IFNULL(pmh.WriteOff,0))TotalDeduction " +
        "FROM patient_medical_history pmh  " +
        "INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID  " +
        "WHERE pmh.TransactionID='" + TransactionID + "' ";

        DataTable patientDetaill = StockReports.GetDataTable(str);

        string checkPanelApproval = string.Empty;
        AllQuery AQ = new AllQuery();
        decimal GrossBillAmt = Math.Round(Util.GetDecimal(AQ.GetBillAmount(TransactionID, null)), 4, MidpointRounding.AwayFromZero);
        decimal NetBillAmount = Math.Round(Util.GetDecimal(GrossBillAmt) - Util.GetDecimal(patientDetaill.Rows[0]["TotalDisc"]), 4, MidpointRounding.AwayFromZero);
        decimal RoundOff = Math.Round((Util.GetDecimal(NetBillAmount) - GrossBillAmt), 4, MidpointRounding.AwayFromZero);
        decimal TotalDeduction = Math.Round(Util.GetDecimal(patientDetaill.Rows[0]["TotalDeduction"]), 4, MidpointRounding.AwayFromZero);
        decimal Advance = Math.Round(Util.GetDecimal(patientDetaill.Rows[0]["PaidAmount"]), 4, MidpointRounding.AwayFromZero);
        decimal TotalPanelApprovalAmt = Math.Round(Util.GetDecimal(patientDetaill.Rows[0]["PanelApprovedAmt"]), 4, MidpointRounding.AwayFromZero);
        decimal BalanceAmt = Math.Round(Util.GetDecimal(NetBillAmount) - (Util.GetDecimal(Advance) + TotalDeduction), 4, MidpointRounding.AwayFromZero);
        string TotalOutStanding = patientDetaill.Rows[0]["Outstanding"].ToString();

        if (TotalOutStanding == "0")
        {
            TotalOutStanding = "OPD:0.0000 IPD:0.0000";
        }
        string EmergencyPhoneNo = patientDetaill.Rows[0]["EmergencyPhoneNo"].ToString();
        string EmergencyRelationShip = patientDetaill.Rows[0]["EmergencyRelationShip"].ToString();
        string KinPhone = patientDetaill.Rows[0]["KinPhone"].ToString();
        string KinName = patientDetaill.Rows[0]["KinName"].ToString();
        if (patientDetaill.Rows[0]["PanelID"].ToString() != Resources.Resource.DefaultPanelID && TotalPanelApprovalAmt < NetBillAmount)
        {
            checkPanelApproval = "Bill Amount have exceeded from Approval Amount";
        }
        //  string BillDetail = TotalDisc + "#" + AmountBilled + "#" + TaxPer + "#" + TaxAmount + "#" + TotalAmt + "#" + NetBillAmount + "#" + RoundOff + "#" + TotalDeduction + "#" + Advance + "#" + BalanceAmt + "#" + OutStanding;
        return Newtonsoft.Json.JsonConvert.SerializeObject(new
        {
            totalDiscount = Util.GetDecimal(patientDetaill.Rows[0]["TotalDisc"]),
            amountBilled = GrossBillAmt,
            netBillAmount = NetBillAmount,
            roundOff = RoundOff,
            totalDeduction = TotalDeduction,
            advance = Advance,
            balanceAmt = BalanceAmt,
            panelApprovalAmt = TotalPanelApprovalAmt,
            panelApprovalAlert = checkPanelApproval,
            totalOutstanding = TotalOutStanding,
            kinName = KinName,
            kinPhone = KinPhone,
            emergencyPhoneNo = EmergencyPhoneNo,
            emergencyRelationShip = EmergencyRelationShip

        });
    }
    private void CalcaluteDoctorShare(string LedgerTnxID, MySqlTransaction Tranx = null, MySqlConnection con = null)
    {
        string[] ltd = LedgerTnxID.Split(',');
        for (int i = 0; i < ltd.Length; i++)
        {
            if (Tranx == null)
            {
                int ltdID = Util.GetInt(StockReports.ExecuteScalar("SELECT ID FROM f_ledgertnxdetail ltd WHERE ltd.LedgerTnxID=" + ltd[i] + " "));
                StockReports.ExecuteDML("DELETE ds.* FROM f_docshare_transactiondetail ds WHERE ds.LedgerTnxID=" + ltdID + "");
                StockReports.ExecuteDML("CALL `Insert_DoctorShare_At_ServiceBookingTime`(" + ltdID + ",2,'HOSP');");
            }
            else
            {
                string str = "SELECT ID FROM f_ledgertnxdetail ltd WHERE ltd.LedgerTnxID=" + ltd[i] + " ";
                int Result = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, str));
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "DELETE ds.* FROM f_docshare_transactiondetail ds WHERE ds.LedgerTnxID=" + Result + " ");
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "CALL `Insert_DoctorShare_At_ServiceBookingTime`(" + Result + ",2,'HOSP');");
            }
        }
    }
}