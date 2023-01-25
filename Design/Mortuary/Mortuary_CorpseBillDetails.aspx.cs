using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using MySql.Data.MySqlClient;

public partial class Design_Mortuary_Mortuary_CorpseBillDetails : System.Web.UI.Page
{
    #region Event Handling
    string LedgerTnxID = string.Empty;

    string[] str = null;
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

        if (!IsPostBack)
        {
            string TransID = string.Empty;
            if (Request.QueryString["TransactionID"] != null)
            {
                TransID = Request.QueryString["TransactionID"].ToString();
            }

            DataTable dt = StockReports.GetDataTable("SELECT TransactionID Transaction_ID,CorpseID,DoctorID,PanelID Panel_ID,BillNo,BillDate,TotalBilledAmt,TDS,ServiceTaxAmt,ServiceTaxPer,ServiceTaxSurChgAmt,SerTaxSurChgPer,SerTaxBillAmount,S_CountryID,S_Amount,S_Notation,C_Factor,RoundOff,DiscountOnBill,IsReleased,IsBillClosed,FileClose_flag FROM mortuary_corpse_deposite WHERE IsCancel=0 AND TransactionID='" + TransID + "'");
            DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(Session["RoleID"]), Util.GetString(Session["ID"]));
            ViewState["Authority"] = dtAuthority;
            ViewState["dtBill"] = dt;

            if (dt != null && dt.Rows.Count > 0)
            {
                ViewState["BillNo"] = dt.Rows[0]["BillNo"].ToString();

                if (dt.Rows[0]["BillNo"].ToString().Trim() != "")
                {

                    DataTable dtAuthoritys = (DataTable)ViewState["Authority"];
                    if (dt.Rows[0]["BillNo"].ToString().Trim() != "" && (dtAuthoritys != null && dtAuthoritys.Rows.Count > 0))
                    {
                        //// string Msg = "";

                        //if (dtAuthoritys.Rows[0]["BillChange"].ToString() == "0")
                        //{
                        //    Msg = "You Are Not Authorised To AMEND IPD Bills...";
                        //    Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
                        //}
                        //else if (dtAuthoritys.Rows[0]["BillChange"].ToString() == "1" && dt.Rows[0]["IsBilledClosed"].ToString().Trim() == "1")
                        //{
                        //    Msg = "Patient's Final Bill has been Closed for Further Updating...";
                        //    Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
                        //}
                    }
                    else if (dt.Rows[0]["BillNo"].ToString().Trim() != "" && (dtAuthoritys != null && dtAuthoritys.Rows.Count == 0))
                    {
                        //string Msg = "";
                        //Msg = "You Are Not Authorised To AMEND This IPD Bills...";
                        //Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);

                    }
                }
            }

            AllQuery AQ = new AllQuery();

            lblTaxPer.Text = Util.GetDecimal(All_LoadData.GovTaxPer()).ToString();
            ViewState["TransID"] = TransID;
            ViewState["UserID"] = Session["ID"].ToString();
            DateTime DepositeDate = Util.GetDateTime(AQ.GetCorpseDepositeDate(TransID));
            ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucFromDate.Text = DepositeDate.ToString("dd-MMM-yyyy");
            calFromDate.StartDate = DepositeDate;
            calToDate.StartDate = DepositeDate;
            calFromDate.EndDate = DateTime.Now;
            calToDate.EndDate = DateTime.Now;

            GetBillDetails();
            BindDepartment();
            DisableJobs();
            SetShowHide();

        }

    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblFilterAmount.Text = "";
        GetBillDetails();
        BindDepartmentBySearch();
    }
    protected void gvDeptBill_RowCommand(object sender, GridViewCommandEventArgs e)
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
            //ViewState["IsFilter"] = false;


            if (gvDeptBill.Rows[Rowindex].BackColor.Name != "LightGreen")
                ViewState["OldColor"] = gvDeptBill.Rows[Rowindex].BackColor.Name;

            gvDeptBill.Rows[Rowindex].BackColor = System.Drawing.Color.LightGreen;

            lblDept.Text = ((Label)gvDeptBill.Rows[Rowindex].FindControl("lblDisplayName")).Text;
            ShowItemDetails();
        }
        if (e.CommandName == "imbModify")
        {
            DataTable dt = new DataTable();
            dt = GetPackage();
            if (dt != null && dt.Rows.Count > 0)
            {
                gvPackage.DataSource = dt;
                gvPackage.DataBind();
                mpPackage.Show();
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
    private void BindLogDetail()
    {
        if ((ViewState["TransID"] != null) && (ViewState["DispName"] != null))
        {
            string TransID = Convert.ToString(ViewState["TransID"]);
            string DispName = Convert.ToString(ViewState["DispName"]).ToUpper();
            string ConfigID = Convert.ToString(ViewState["ConfigID"]);


            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT t.* FROM ");
            sb.Append(" (SELECT LedgerTnxID,tg_ID,'' DATETIME,ltd.tg_DateTime,ltd.transactionID transaction_ID,ltd.itemname,ltd.ItemID,ltd.Rate,");
            sb.Append(" (select name from f_subcategorymaster where SubcategoryID=ltd.subcategoryid)subcategoryname,");
            sb.Append(" ltd.Amount,ltd.Quantity,ltd.DiscountPercentage,ltd.SubCategoryID, ");
            sb.Append(" Date_Format(ltd.EntryDate,'%d-%b-%y %h :%i%p')VerifiedDate,( SELECT CONCAT(Title,' ',NAME) FROM Employee_master");
            sb.Append(" WHERE EmployeeID=ltd.UserID)User_ID,ltd.DiscountReason,ltd.CancelReason,");
            sb.Append(" (SELECT CONCAT(Title,' ',NAME) FROM Employee_master ");
            sb.Append(" WHERE EmployeeID=ltd.CancelUserId)CancelUserId,Date_Format(ltd.CancelDateTime,'%d-%b-%y %h:%i %p')CancelDateTime,Date_Format(IF(ltd.Updateddate='0001-01-01','',ltd.Updateddate),'%d-%b-%y %h :%i%p')Updateddate,((ltd.Rate*ltd.Quantity)-ltd.Amount)DiscAmt,");
            sb.Append(" ( SELECT CONCAT(Title,' ',NAME) FROM Employee_master WHERE EmployeeID=ltd.LastUpdatedBy)");
            sb.Append(" LastUpdatedBy,( SELECT CONCAT(Title,' ',NAME) FROM Employee_master WHERE ");
            sb.Append(" EmployeeID=ltd.DiscUserID)DiscUserID FROM tg_f_ledgertnxdetail ltd INNER JOIN ");
            sb.Append(" f_ledgertransaction LT ON ltd.LedgerTransactionNo = LT.LedgerTransactionNo  ");
            sb.Append(" INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID = ltd.SubCategoryID ");
            sb.Append(" INNER JOIN f_configrelation cf ON sm.CategoryID = cf.CategoryID ");
            sb.Append(" WHERE lt.TransactionId='" + ViewState["TransID"].ToString() + "'  AND sm.CategoryID = '" + DispName.Replace("'", "''") + "' ");

            sb.Append(" union all");
            sb.Append(" SELECT LedgerTnxID,'0' tg_ID,IF(ltd1.Isverified=1,IF(ltd1.Updateddate='0001-01-01','',ltd1.Updateddate),   ");
            sb.Append(" IF(ltd1.CancelDateTime='0001-01-01','',ltd1.CancelDateTime))DATETIME,NOW() tg_DateTime,ltd1.transaction_ID,ltd1.itemname,ltd1.ItemID,ltd1.Rate,");
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
            sb.Append(" f_configrelation cf1 ON sm1.CategoryID = cf1.CategoryID WHERE lt1.TransactionId='" + ViewState["TransID"].ToString() + "'  AND sm1.CategoryID = '" + DispName.Replace("'", "''") + "' and ltd1.IsVerified IN(1,2) )t");
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



                //foreach (GridViewRow row in grdLog.Rows)
                //{
                //    DataTable dtnew;
                //    dtnew = dtLog.Clone();

                //      string LedTnxID1 = "";
                //      LedTnxID1=((Label)row.Cells[0].FindControl("lblLedgerTnxID")).Text;
                //      if (dtnew.Rows.Count > 0)
                //      {
                //          if (dtnew.Rows[0]["LedgerTnxID"].ToString() == LedTnxID1)
                //          {


                //          }

                //      }
                //    DataRow dr;
                //    for (int i = 0; row.Cells.Count; i++)
                //    {
                //     dr   row.Cells[i].FindControl("")
                //    }
                //    dtnew.Rows.Add(dr);


                //   }

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
                    //if (e.Row.Cells[i].Text != null)
                    //{
                    if (str[i].ToString() != e.Row.Cells[i].Text)
                    {
                        e.Row.Cells[i].BackColor = System.Drawing.Color.Red;
                    }
                    //}
                }

                //LedgerTnxID = ((Label)e.Row.FindControl("lblLedgerTnxID")).Text;
                // Amount = Util.GetDecimal(((Label)e.Row.FindControl("lblAmount")).Text);
                for (int i = 0; i < e.Row.Cells.Count; i++)
                {
                    //if (e.Row.Cells[i].Text != null)
                    //{
                    str[i] = e.Row.Cells[i].Text;
                    // }
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
            //foreach (GridViewRow row in e.Row)
            //{


            //    string LedTnxID = "";
            //    LedTnxID((Label)row.Cells[0].FindControl("lblLedgerTnxID")).Text;



            //if (row["LedgerTnxID"].ToString() != LedTnxID)
            //{
            //    LedTnxID = row["LedgerTnxID"].ToString();

            //    DataRow[] drExist = dtLog.Select("LedgerTnxID='" + row["LedgerTnxID"].ToString() + "'");

            //    if (drExist.Length > 0)
            //    {
            //        int iCtr = 0;
            //        foreach (DataRow dr1 in drExist)
            //        {
            //            iCtr += 1;
            //            if (iCtr < drExist.Length)
            //                dr1["Status"] = iCtr.ToString() + " - P";
            //            else
            //                dr1["Status"] = iCtr.ToString() + " - C";

            //        }
            //    }
            //}
            // }


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

            //else
            //{
            //    e.Row.BackColor = System.Drawing.Color.White;
            //}
        }


    }
    protected void gvDeptBill_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        //if (e.Row.RowType == DataControlRowType.DataRow)
        //{
        //    if (lblDept.Text == ((Label)e.Row.FindControl("lblDisplayName")).Text)
        //        e.Row.BackColor = System.Drawing.Color.LightGreen;
        //}

        DataTable dtAuthoritys = (DataTable)ViewState["Authority"];

        DataTable dt = (DataTable)ViewState["dtBill"];
        if (e.Row.RowType == DataControlRowType.DataRow)
        {

            //DataTable dtAuthoritys = (DataTable)ViewState["Authority"];
            if (dt.Rows[0]["BillNo"].ToString().Trim() != "" && (dtAuthoritys != null && dtAuthoritys.Rows.Count > 0))
            {
                // string Msg = "";

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
            else if (dt.Rows[0]["BillNo"].ToString().Trim() != "" && (dtAuthoritys != null && dtAuthoritys.Rows.Count == 0))
            {
                ((ImageButton)e.Row.FindControl("imbView")).Visible = false;
                ((ImageButton)e.Row.FindControl("imbModify")).Visible = false;

            }


            //if (dtAuthoritys.Rows[0]["BillChange"].ToString() == "0")
            //{
            //    ((ImageButton)e.Row.FindControl("imbView")).Visible = false;
            //    ((ImageButton)e.Row.FindControl("imbModify")).Visible = false;
            //}
            //if (dt.Rows[0]["BillNo"].ToString().Trim() != "" && dt.Rows[0]["IsBilledClosed"].ToString().Trim()=="1")
            //{
            //    ((ImageButton)e.Row.FindControl("imbView")).Visible = false;
            //    ((ImageButton)e.Row.FindControl("imbModify")).Visible = false;
            //}
        }
    }
    protected void gvItemDetail_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Reject")
        {
            string strLtNo = Util.GetString(e.CommandArgument);
            string IsSurgery = strLtNo.Split('#')[1].ToUpper();

            lblIsSurgery.Text = IsSurgery;
            lblLedTnxNo.Text = strLtNo.Split('#')[0].ToUpper();
            lblLedTnxID.Text = strLtNo.Split('#')[0].ToUpper();

            mpeRejection.Show();
        }
        if (e.CommandName == "AEdit")
        {
            int Index = Util.GetInt(e.CommandArgument);
            GridViewRow row = gvItemDetail.Rows[Index];

            if (row != null)
            {

                lblLtdNo.Text = ((Label)row.FindControl("lblLedTnxNo")).Text;
                lblEItem.Text = ((Label)row.FindControl("lblItem")).Text;
                txtERate.Text = ((Label)row.FindControl("lblRate")).Text;

                txtEQty.Text = ((Label)row.FindControl("lblQty")).Text;
                txtEDiscPer.Text = ((Label)row.FindControl("lblDiscPer")).Text;
                txtEDiscAmt.Text = ((Label)row.FindControl("lblDiscAmt")).Text;
                txtDiscReason.Text = StockReports.ExecuteScalar("Select DiscountReason from f_LedgertnxDetail where LedgerTnxID='" + lblLtdNo.Text + "'");
                txtERate.ReadOnly = true;
                txtEQty.ReadOnly = true;
                txtEDiscPer.ReadOnly = true;
                txtEDiscAmt.ReadOnly = true;


                if (txtERate.Text == "0.0")
                {
                    string str = "select * from f_itemmaster im inner join f_subcategorymaster sc on im.subcategoryid=sc.subcategoryid inner join f_configrelation con on con.categoryid=sc.categoryid where im.itemid='" + ((Label)row.FindControl("lblItemID")).Text + "' and sc.displayname='Medicine & Consumables' and con.ConfigID <> 11 ";
                    DataTable dt = StockReports.GetDataTable(str);

                    txtERate.ReadOnly = false;
                    if (dt.Rows.Count <= 0)
                    {
                        ViewState["RateChange"] = "true";
                        StringBuilder sb = new StringBuilder();
                        sb.Append(" SELECT lt.LedgerTnxID,lt.TransactionID Transaction_ID,lt.ItemID,lt.ItemName,lt.Rate,lt.Quantity,lt.amount,(SELECT NAME FROM ipd_case_type_master WHERE ipdcasetype_id=pip.IPDCaseType_ID)IPDCaseType_ID,pip.Room_ID,lt.PanelID Panel_ID,lt.ScheduleChargeID ");
                        sb.Append(" FROM  ( ");
                        sb.Append(" SELECT lt.Date,lt.Time,ltd.EntryDate,lt.TransactionID Transaction_ID,ltd.ItemID,ltd.ItemName,ltd.Rate,ltd.Quantity ");
                        sb.Append(" ,ltd.Amount,ltd.LedgerTnxID,pmh.PanelID Panel_ID,pmh.ScheduleChargeID FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ON  ");
                        sb.Append(" lt.LedgerTransactionNo = ltd.LedgerTransactionNo LEFT JOIN patient_medical_history pmh ON ltd.TransactionID = pmh.TransactionID ");
                        sb.Append(" WHERE ltd.LedgerTnxID='" + lblLtdNo.Text.Trim() + "')lt  LEFT JOIN patient_ipd_profile pip ");
                        sb.Append(" ON lt.TransactionID = pip.TransactionID  ");
                        sb.Append(" AND lt.date >  CONCAT(pip.StartDate,' ',pip.StartTime) ");
                        sb.Append(" AND lt.date <=  IF(CONCAT(pip.EndDate,' ',pip.EndTime)='0001-01-01 00:00:00',NOW(),CONCAT(pip.EndDate,' ',pip.EndTime)) ");
                        //"+
                        DataTable dtnew = StockReports.GetDataTable(sb.ToString());
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "alert('The Rate You Are Setting Here Will Also Update The Rate For Item :" + ((Label)row.FindControl("lblItem")).Text + " For RoomType :" + dtnew.Rows[0]["IPDCaseType_ID"].ToString() + " ')", true);
                        chkSetRate.Visible = true;
                    }
                    //txtEQty.ReadOnly = false;
                }
                else
                {
                    //"+dt.Rows[0]["IPDCaseType_ID"].ToString() +"
                    ViewState["RateChange"] = "false";
                    chkSetRate.Visible = false;
                }


                DataTable Authority = (DataTable)ViewState["Authority"];


                if (Authority.Rows.Count > 0)
                {

                    if (Authority.Rows[0]["IsEdit"].ToString() == "1")
                    {
                        //IsEdit = "true";
                        txtERate.ReadOnly = false;
                        txtEQty.ReadOnly = false;

                    }

                    if (Authority.Rows[0]["IsDiscount"].ToString() == "1")
                    {
                        //IsDiscount = "true";
                        txtEDiscPer.ReadOnly = false;
                        txtEDiscAmt.ReadOnly = false;
                    }

                }
                mpEdit.Show();
                //pnlEdit.FindControl("txtERate")txtEDiscPer  txtEDiscAmt   txtEQty
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
                DataTable dt = StockReports.GetDataTable("SELECT ltd.ItemID,ltd.TransactionID Transaction_ID,ltd.SubCategoryID FROM f_ledgertnxdetail ltd INNER JOIN  f_itemmaster im ON " +
                "ltd.ItemID = im.ItemID INNER JOIN f_subcategorymaster sc ON im.SubCategoryID = sc.SubCategoryID " +
                "INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID WHERE ltd.LedgerTnxID in ('" + Util.GetString(e.CommandArgument) + "') " +
                "AND cf.ConfigID=14 ");

                if (dt != null && dt.Rows.Count > 0)
                {
                    DataTable dtType = StockReports.GetDataTable("Select Patient_Type,PanelID Panel_ID from patient_medical_history where TransactionID= '" + dt.Rows[0]["Transaction_ID"].ToString() + "'");

                    foreach (DataRow row in dt.Rows)
                    {
                        GetDiscount ds = new GetDiscount();
                        decimal DiscPerc = ds.GetDefaultDiscount(row["SubCategoryID"].ToString(), Util.GetInt( dtType.Rows[0]["Panel_ID"].ToString()), System.DateTime.Now, "IPD", "");


                        string str = "Update f_ledgertnxdetail ";
                        str += " Set Amount=(Rate*Quantity)-(((Rate*Quantity)*" + DiscPerc + ")/100),";
                        str += " DiscountPercentage=" + DiscPerc + ",";
                        str += " DiscAmt=(((Rate * Quantity) * " + DiscPerc + ") / 100), IsPackage=0,PackageID='', ";
                        str += " LastUpdatedBy = '" + ViewState["UserID"] + "' ";
                        str += " ,Updateddate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "' ";
                        str += " ,IpAddress = '" + Util.GetString(Session["ClientIP"]) + "' ";
                        str += " Where TransactionID='" + row["Transaction_ID"].ToString() + "' ";
                        str += " and PackageID='" + row["ItemID"].ToString() + "'";
                        StockReports.ExecuteDML(str);
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
                    lblMsg.Text = "Specify Amount";
                    return;
                }
            }
        if (status)
        {
            lblMsg.Text = "Select Package";
            return;
        }

        bool Result = false;

        foreach (GridViewRow Prow in gvPackage.Rows)
            if (((CheckBox)Prow.FindControl("chkPackage")).Checked)
            {
                decimal Rate = Util.GetDecimal(((TextBox)Prow.FindControl("txtAmount")).Text);
                Result = StockReports.ExecuteDML("update f_ledgertnxdetail set Rate = " + Rate + " "
                + " ,Amount = " + Rate + ""
                + " ,LastUpdatedBy = '" + ViewState["UserID"] + "' "
                + " ,Updateddate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "' "
                + " ,IpAddress = '" + Util.GetString(Session["ClientIP"]) + "' "
                + " where LedgerTnxID = '" + ((ImageButton)Prow.FindControl("imbReject")).CommandArgument + "' ");
            }

        if (Result)
        {
            BindDepartment();
            GetBillDetails();
            lblMsg.Text = "Package Updated.";
        }
        else
            lblMsg.Text = "Error...";
    }
    protected void btnEditSave_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = new MySqlConnection(Util.GetConString());
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        string str = string.Empty;
        decimal amount = 0;
        string Ratechange = "";

        if (ViewState["RateChange"] != null)
        {
            Ratechange = ViewState["RateChange"].ToString();
        }
        try
        {
            if (Ratechange == "true")
            {
                sb.Append(" SELECT lt.LedgerTnxID,lt.TransactionID Transaction_ID,lt.ItemID,lt.ItemName,lt.Rate,lt.Quantity,lt.amount,pip.IPDCaseType_ID,pip.Room_ID,lt.PanelID Panel_ID,lt.ScheduleChargeID,ReferenceCode ");
                sb.Append(" FROM  ( ");
                sb.Append(" SELECT lt.Date,lt.Time,ltd.EntryDate,lt.TransactionID Transaction_ID,ltd.ItemID,ltd.ItemName,ltd.Rate,ltd.Quantity ");
                sb.Append(" ,ltd.Amount,ltd.LedgerTnxID,pmh.PanelID Panel_ID,pmh.ScheduleChargeID ");
                sb.Append(" ,(Select ReferenceCode from f_panel_master where PanelID=pmh.PanelID)ReferenceCode ");
                sb.Append(" FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ON  ");
                sb.Append(" lt.LedgerTransactionNo = ltd.LedgerTransactionNo LEFT JOIN patient_medical_history pmh ON ltd.TransactionID = pmh.TransactionID ");
                sb.Append(" WHERE ltd.LedgerTnxID='" + lblLtdNo.Text.Trim() + "')lt  LEFT JOIN patient_ipd_profile pip ");
                sb.Append(" ON lt.TransactionID = pip.TransactionID  ");
                sb.Append(" AND CONCAT(DATE(lt.date),' ',lt.time) >=  CONCAT(pip.StartDate,' ',pip.StartTime) ");
                sb.Append(" AND CONCAT(DATE(lt.date),' ',lt.time) <=  IF(CONCAT(pip.EndDate,' ',pip.EndTime)='0001-01-01 00:00:00',NOW(),CONCAT(pip.EndDate,' ',pip.EndTime)) ");
                //"+
                DataTable dt = StockReports.GetDataTable(sb.ToString());

                StringBuilder sb1 = new StringBuilder();
                sb1.Append("select * from  f_ratelist_ipd Where ItemID = '" + dt.Rows[0]["ItemID"].ToString() + "' ");
                sb1.Append("and PanelID = '" + dt.Rows[0]["ReferenceCode"].ToString() + "' and IPDCaseType_ID='" + dt.Rows[0]["IPDCaseType_ID"].ToString() + "' and IsCurrent=1");
                DataTable dt1 = StockReports.GetDataTable(sb1.ToString());


                if (dt1.Rows.Count > 0 && Util.GetDecimal(dt1.Rows[0]["Rate"]) == 0) // Deleting OLD rates for updating/inserting rates
                {
                    StringBuilder sb2 = new StringBuilder();
                    sb2.Append("Update f_ratelist_ipd Set IsCurrent=0,LastUpdatedBy='" + ViewState["UserID"].ToString() + "',");
                    sb2.Append("Updateddate=Now(),IpAddress='" + Session["ClientIP"].ToString() + "' Where ItemID = '" + dt.Rows[0]["ItemID"].ToString() + "' ");
                    sb2.Append("and PanelID = '" + dt.Rows[0]["ReferenceCode"].ToString() + "' and ScheduleChargeID=" + Util.GetInt(dt.Rows[0]["ScheduleChargeID"].ToString()) + " ");

                    if (chkSetRate.Checked == false)
                        sb2.Append(" and IPDCaseType_ID='" + dt.Rows[0]["IPDCaseType_ID"].ToString() + "' ");

                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb2.ToString());
                }

                if (chkSetRate.Checked)
                {
                    DataTable dtAlloomType = StockReports.GetDataTable("Select IPDCaseType_ID from ipd_case_type_master where IsActive=1");

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
                            objRateList.IPDCaseTypeID = drTooms["IPDCaseType_ID"].ToString();
                            objRateList.ScheduleChargeID = Util.GetInt(dt.Rows[0]["ScheduleChargeID"].ToString());
                            objRateList.UserID = ViewState["UserID"].ToString();
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
                    objRateList.IPDCaseTypeID = dt.Rows[0]["IPDCaseType_ID"].ToString();
                    objRateList.ScheduleChargeID = Util.GetInt(dt.Rows[0]["ScheduleChargeID"].ToString());
                    objRateList.UserID = ViewState["UserID"].ToString();
                    objRateList.Insert();
                }

            }


            if (Util.GetDecimal(txtEDiscPer.Text.Trim()) > 0)
            {
                amount = (Util.GetDecimal(txtERate.Text.Trim()) * Util.GetDecimal(txtEQty.Text.Trim())) - (((Util.GetDecimal(txtERate.Text.Trim()) * Util.GetDecimal(txtEQty.Text.Trim())) * Util.GetDecimal(txtEDiscPer.Text.Trim())) / 100);
                str = "update f_ledgertnxdetail set rate=" + Util.GetDecimal(txtERate.Text.Trim()) + ","
                + " Quantity=" + Util.GetDecimal(txtEQty.Text.Trim()) + ",amount=" + amount + ","
                + " DiscountPercentage=" + Util.GetDecimal(txtEDiscPer.Text.Trim()) + ","
                + " DiscountReason='" + txtDiscReason.Text + "', "
                + " DiscUserID='" + ViewState["UserID"] + "', "
                + " LastUpdatedBy = '" + ViewState["UserID"] + "', "
                + " Updateddate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "', "
                + " IpAddress = '" + Util.GetString(Session["ClientIP"]) + "' "
                + " where LedgerTnxID='" + lblLtdNo.Text.Trim() + "'";
            }
            else if (Util.GetDecimal(txtEDiscAmt.Text.Trim()) > 0)
            {
                amount = (Util.GetDecimal(txtERate.Text.Trim()) * Util.GetDecimal(txtEQty.Text.Trim())) - Util.GetDecimal(txtEDiscAmt.Text.Trim());
                str = "update f_ledgertnxdetail set rate=" + Util.GetDecimal(txtERate.Text.Trim()) + ","
                + " Quantity=" + Util.GetDecimal(txtEQty.Text.Trim()) + ","
                + " amount=" + amount + ","
                + " DiscountPercentage=" + (Util.GetDecimal(txtEDiscAmt.Text.Trim()) * 100) / (Util.GetDecimal(txtERate.Text.Trim()) * Util.GetDecimal(txtEQty.Text.Trim())) + ","
                + " DiscountReason='" + txtDiscReason.Text + "', "
                + " DiscUserID='" + ViewState["UserID"] + "', "
                + " LastUpdatedBy = '" + ViewState["UserID"] + "', "
                + " Updateddate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "', "
                + " IpAddress = '" + Util.GetString(Session["ClientIP"]) + "' "
                + " where LedgerTnxID='" + lblLtdNo.Text.Trim() + "'";
            }

            else
            {
                amount = (Util.GetDecimal(txtERate.Text.Trim()) * Util.GetDecimal(txtEQty.Text.Trim())) - Util.GetDecimal(txtEDiscAmt.Text.Trim());
                str = "update f_ledgertnxdetail set rate=" + Util.GetDecimal(txtERate.Text.Trim()) + ","
                + " Quantity=" + Util.GetDecimal(txtEQty.Text.Trim()) + ","
                + " amount=" + amount + ","
                + " DiscountPercentage=" + (Util.GetDecimal(txtEDiscAmt.Text.Trim()) * 100) / (Util.GetDecimal(txtERate.Text.Trim()) * Util.GetDecimal(txtEQty.Text.Trim())) + ","
                + " DiscountReason='" + txtDiscReason.Text + "', "
                + " LastUpdatedBy = '" + ViewState["UserID"] + "', "
                + " Updateddate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "', "
                + " IpAddress = '" + Util.GetString(Session["ClientIP"]) + "' "
                + " where LedgerTnxID='" + lblLtdNo.Text.Trim() + "'";
            }
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);

            Tnx.Commit();
            Tnx.Dispose();
            con.Close();
            con.Dispose();
            BindDepartment();
            ShowItemDetails();
            GetBillDetails();
            lblMsg.Text = "Item Updated Successfully";


        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            Tnx.Rollback();
            Tnx.Dispose();
            con.Close();
            con.Dispose();

        }
    }
    protected void btnRSave_Click(object sender, EventArgs e)
    {
        GetSelection();
        if (lblLtdNo.Text.Trim() != string.Empty)
        {
            string str = "update f_ledgertnxdetail set rate = " + txtRate.Text.Trim() + ","
            + " amount = (" + txtRate.Text.Trim() + "*Quantity)-(((" + txtRate.Text.Trim() + "*Quantity)*DiscountPercentage)/100), "
            + " LastUpdatedBy = '" + ViewState["UserID"] + "', "
            + " Updateddate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "', "
            + " IpAddress = '" + Util.GetString(Session["ClientIP"]) + "' "
            + " where LedgerTnxID in (" + lblLtdNo.Text.Trim() + ")";
            if (StockReports.ExecuteDML(str))
            {
                BindDepartment();
                ShowItemDetails();
                GetBillDetails();
                lblMsg.Text = "Rate Updated Successfully";
                txtRate.Text = "";
            }
            else
                lblMsg.Text = "Error";
        }
        else
            lblMsg.Text = "Select Items";
    }
    protected void btnDiscSave_Click(object sender, EventArgs e)
    {
        GetSelection();

        if (lblLtdNo.Text.Trim() != string.Empty)
        {
            string str;
            if (Util.GetDecimal(txtItemDiscPer.Text.Trim()) > 0)
                str = "update f_ledgertnxdetail set amount = (rate*Quantity)-(((rate*Quantity)*" + Util.GetDecimal(txtItemDiscPer.Text.Trim()) + ")/100),DiscountPercentage=" + Util.GetDecimal(txtItemDiscPer.Text.Trim()) + ",DiscAmt=((rate*Quantity)*" + Util.GetDecimal(txtItemDiscPer.Text.Trim()) + "/100),LastUpdatedBy = '" + ViewState["UserID"] + "',Updateddate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',IpAddress = '" + Util.GetString(Session["ClientIP"]) + "' where LedgerTnxID in (" + lblLtdNo.Text.Trim() + ")";
            else
                str = "update f_ledgertnxdetail set amount = (rate*Quantity)-" + Util.GetDecimal(txtItemDiscAmt.Text.Trim()) + ",DiscountPercentage=(" + Util.GetDecimal(txtItemDiscAmt.Text.Trim()) + "*100)/(rate*Quantity),LastUpdatedBy = '" + ViewState["UserID"] + "',Updateddate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',IpAddress = '" + Util.GetString(Session["ClientIP"]) + "' where LedgerTnxID in (" + lblLtdNo.Text.Trim() + ")";

            if (StockReports.ExecuteDML(str))
            {
                BindDepartment();
                ShowItemDetails();
                GetBillDetails();
                lblMsg.Text = "Discount Updated Successfully";
            }
            else
                lblMsg.Text = "Error";
        }
        else
            lblMsg.Text = "Select Items";
    }
    protected void btnReject_Click(object sender, EventArgs e)
    {
        mpeRejection.Show();

        //GetSelection();        

        //if (lblLtdNo.Text.Trim() != string.Empty)
        //{
        //    if (RejectItems(string.Empty, lblLtdNo.Text.Trim(),""))
        //    {
        //        BindDepartment();
        //        ShowItemDetails();
        //        GetBillDetails();
        //        lblMsg.Text = "Items Rejected...";
        //    }
        //    else
        //        lblMsg.Text = "Error...";
        //}
        //else
        //    lblMsg.Text = "Select Items...";
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
                        strLtdNo = "update f_ledgertnxdetail set PackageID='" + ddlPackage.SelectedValue + "',IsPackage=1,Amount=0,LastUpdatedBy = '" + ViewState["UserID"] + "',Updateddate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',IpAddress = '" + Util.GetString(Session["ClientIP"]) + "' where LedgerTnxID in(" + lblLtdNo.Text.Trim() + ")";
                    else
                        strLtdNo = "update f_ledgertnxdetail set PackageID='',IsPackage=0,Amount=(rate*Quantity)-(((rate*Quantity)*DiscountPercentage)/100),LastUpdatedBy = '" + ViewState["UserID"] + "',Updateddate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',IpAddress = '" + Util.GetString(Session["ClientIP"]) + "' where LedgerTnxID in(" + lblLtdNo.Text.Trim() + ")";

                    result1 = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strLtdNo);

                }
                if (lblLTNo.Text.Trim() != string.Empty)
                {
                    if (ddlPackage.SelectedValue != "0")
                        strLtNo = "update f_ledgertnxdetail set PackageID='" + ddlPackage.SelectedValue + "',IsPackage=1,Amount=0,LastUpdatedBy = '" + ViewState["UserID"] + "',Updateddate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',IpAddress = '" + Util.GetString(Session["ClientIP"]) + "' where LedgerTransactionNo in(" + lblLTNo.Text.Trim() + ")";
                    else
                        strLtNo = "update f_ledgertnxdetail set PackageID='',IsPackage=0,Amount=(rate*Quantity)-(((rate*Quantity)*DiscountPercentage)/100),LastUpdatedBy = '" + ViewState["UserID"] + "',Updateddate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',IpAddress = '" + Util.GetString(Session["ClientIP"]) + "' where LedgerTransactionNo in(" + lblLTNo.Text.Trim() + ")";

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
            lblMsg.Text = "Select Items...";
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
        if (rdbReport.SelectedValue == "1")
            SummaryBill();
        else
            DetailBill();

    }
    #endregion

    #region Data Binding
    private void GetBillDetails()
    {
        //if (ViewState["TransID"] != null)
        //{
        //    string TransID = Convert.ToString(ViewState["TransID"]);
        //    StringBuilder sbBill = new StringBuilder();
        //    sbBill.Append("Select Round(t2.GrossAmt,2)GrossAmt,Round((t2.GrossAmt-t2.TDiscount),2)NetAmt,");
        //    sbBill.Append("Round(t2.TDiscount,2)TDiscount FROM ( ");
        //    sbBill.Append("     select ltd.TransactionID,sum(ltd.Rate*ltd.Quantity)GrossAmt,");
        //    sbBill.Append("     IFNULL(ROUND(SUM(((ltd.Rate*ltd.Quantity)*ltd.DiscountPercentage)/100)");
        //    sbBill.Append("     ,2),0)TDiscount From mortuary_ledgertnxdetail ltd ");
        //    sbBill.Append("     inner join mortuary_ledgertransaction LT on ltd.LedgerTransactionNo = LT.LedgerTransactionNo");
        //    sbBill.Append("     WHERE Lt.IsCancel = 0 and ltd.IsFree = 0 and ltd.IsVerified = 1 ");
        //    sbBill.Append("     and lt.TransactionID = '" + TransID + "' ");
        //    sbBill.Append("     and date(ltd.EntryDate)>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' ");
        //    sbBill.Append("     and date(ltd.EntryDate)<='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "' ");
        //    sbBill.Append("     group by lt.TransactionID )T2 ");

        //    DataTable dtBill = new DataTable();
        //    dtBill = StockReports.GetDataTable(sbBill.ToString());

        //    if (dtBill.Rows.Count > 0)
        //    {
        //        lblGrossBillAmt.Text = Util.GetString(dtBill.Rows[0]["GrossAmt"]);
        //        lblBillDiscount.Text = Util.GetString(dtBill.Rows[0]["TDiscount"]);
        //        lblNetAmount.Text = Util.GetString(dtBill.Rows[0]["NetAmt"]);
        //        lblTotalTax.Text = Util.GetDecimal(Math.Round(Util.GetDecimal((Util.GetDecimal(lblNetAmount.Text) * Util.GetDecimal(lblTaxPer.Text)) / 100), 2, System.MidpointRounding.AwayFromZero)).ToString();
        //        decimal TotalAmt = Util.GetDecimal(lblNetAmount.Text) + Util.GetDecimal(lblTotalTax.Text);
        //        lblNetBillAmt.Text = Util.GetDecimal(Math.Round(TotalAmt, 2, MidpointRounding.AwayFromZero)).ToString();
        //        decimal RoundOff = Math.Round((TotalAmt), 0, MidpointRounding.AwayFromZero);
        //        lblRoundOff.Text = Util.GetDecimal(Math.Round((RoundOff - TotalAmt), 2, MidpointRounding.AwayFromZero)).ToString();
        //    }
        //    else
        //        lblMsg.Text = "No Billing Information Found";
        //}

        if (ViewState["TransID"] != null)
        {
            string TransID = Convert.ToString(ViewState["TransID"]);
            StringBuilder sbBill = new StringBuilder();
            sbBill.Append("Select Round(t2.GrossAmt,2)GrossAmt,Round((t2.GrossAmt-t2.TDiscount),2)NetAmt,");
            sbBill.Append("Round(t2.TDiscount,2)TDiscount,ROUND(IFNULL(t3.RecAmt,0.00),2)RecAmt FROM ( ");
            sbBill.Append("     select ltd.TransactionID,sum(ltd.Rate*ltd.Quantity)GrossAmt,");
            sbBill.Append("     IFNULL(ROUND(SUM(((ltd.Rate*ltd.Quantity)*ltd.DiscountPercentage)/100)");
            sbBill.Append("     +IFNULL(ipd.DiscountOnBill,0),2),0)TDiscount,im.Type_ID,im.ServiceItemID From mortuary_ledgertnxdetail ltd ");
            sbBill.Append("     inner join mortuary_ledgertransaction LT on ltd.LedgerTransactionNo = LT.LedgerTransactionNo");
            sbBill.Append("     INNER JOIN mortuary_corpse_deposite ipd ON ipd.TransactionID=lt.TransactionID ");
            sbBill.Append("     INNER JOIN f_itemmaster im ON ltd.ItemID = im.ItemID ");
            sbBill.Append("     WHERE Lt.IsCancel = 0 and ltd.IsFree = 0 and ltd.IsVerified = 1 ");
            sbBill.Append("     and ltd.IsPackage = 0");
            sbBill.Append("     and lt.TransactionID = '" + TransID + "' ");
            sbBill.Append("     and date(ltd.EntryDate)>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' ");
            sbBill.Append("     and date(ltd.EntryDate)<='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "' ");
            sbBill.Append("     group by lt.TransactionID ");
            //sbBill.Append("     HAVING IF(IFNULL(im.Type_ID,'')='HS',IFNULL(im.ServiceItemID,'')<>'',IFNULL(im.Type_ID,'')<>'HS')");
            sbBill.Append(")T2  Left join (");
            sbBill.Append("     select TransactionID Transaction_ID,sum(AmountPaid)RecAmt from mortuary_receipt where IsCancel = 0 ");
            sbBill.Append("     and TransactionID = '" + TransID + "' and ");
            sbBill.Append("     date(Date)>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' ");
            sbBill.Append("     and date(Date)<='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "' group by Transaction_ID ");
            sbBill.Append(")T3 on T2.TransactionID = T3.Transaction_ID");

            DataTable dtBill = new DataTable();
            dtBill = StockReports.GetDataTable(sbBill.ToString());

            if (dtBill.Rows.Count > 0)
            {
                lblGrossBillAmt.Text = Util.GetString(dtBill.Rows[0]["GrossAmt"]);
                lblBillDiscount.Text = Util.GetString(dtBill.Rows[0]["TDiscount"]);
                lblNetAmount.Text = Util.GetString(dtBill.Rows[0]["NetAmt"]);
                lblAdvanceAmt.Text = Util.GetString(Util.GetDecimal(dtBill.Rows[0]["RecAmt"]));
                lblBalanceAmt.Text = Util.GetString(Util.GetDecimal(dtBill.Rows[0]["NetAmt"]) - Util.GetDecimal(dtBill.Rows[0]["RecAmt"]));
                //lblApprovalAmt.Text = Util.GetString(dtBill.Rows[0]["PanelApprovedAmt"]);
                // lblTaxAppliedOn.Text = Util.GetString(dtBill.Rows[0]["NetAmt"]);
                lblTotalTax.Text = Util.GetDecimal(Math.Round(Util.GetDecimal((Util.GetDecimal(lblNetAmount.Text) * Util.GetDecimal(lblTaxPer.Text)) / 100), 2, System.MidpointRounding.AwayFromZero)).ToString();
                decimal TotalAmt = Util.GetDecimal(lblNetAmount.Text) + Util.GetDecimal(lblTotalTax.Text);
                lblNetBillAmt.Text = Util.GetDecimal(Math.Round(TotalAmt, 2, MidpointRounding.AwayFromZero)).ToString();
                decimal RoundOff = Math.Round((TotalAmt), 0, MidpointRounding.AwayFromZero);
                lblRoundOff.Text = Util.GetDecimal(Math.Round((RoundOff - TotalAmt), 2, MidpointRounding.AwayFromZero)).ToString();
                decimal BalanceAmt = Util.GetDecimal(lblNetBillAmt.Text) - Util.GetDecimal(lblAdvanceAmt.Text) + Util.GetDecimal(lblRoundOff.Text);
                lblBalanceAmt.Text = Util.GetDecimal(BalanceAmt).ToString();
            }
            else
                lblMsg.Text = "No Billing Information Found";
        }
    }
    private void BindDepartment()
    {
        if (ViewState["TransID"] != null)
        {
            string TransID = Convert.ToString(ViewState["TransID"]);
            StringBuilder sbDept = new StringBuilder();
            //sbDept.Append("select if(SM.DisplayName = '',sm.name,sm.DisplayName)DisplayName,if(SM.DisplayName='package','true','false')IsPackage,sum(T1.Amount) NetAmt,sum(T1.Quantity) Qty from");
            //sbDept.Append(" (select lt.LedgerTransactionNo,ltd.Amount,ltd.Quantity,ltd.subcategoryID From f_ledgertnxdetail ltd inner join f_ledgertransaction LT ");
            //sbDept.Append(" on ltd.LedgerTransactionNo = LT.LedgerTransactionNo WHERE Lt.IsCancel = 0 and  ltd.IsVerified = 1 and ltd.IsPackage = 0 and ltd.IsSurgery = 0 and lt.Transaction_ID = '" + TransID + "' ");
            //sbDept.Append(" and date(lt.Date) <= '" + ucToDate.GetDateForDataBase() + "' union all select distinct(lt.LedgerTransactionNo),lt.NetAmount,1 Quantity,ltd.SubcategoryID From f_ledgertnxdetail ltd inner join f_ledgertransaction LT ");
            //sbDept.Append(" on ltd.LedgerTransactionNo = LT.LedgerTransactionNo WHERE Lt.IsCancel = 0 and ltd.IsVerified = 1 and ltd.IsPackage = 0 and ltd.IsSurgery = 1 and lt.Transaction_ID = '" + TransID + "'");
            //sbDept.Append(" and date(lt.Date) <= '" + ucToDate.GetDateForDataBase() + "')T1 inner join f_subcategorymaster SM on T1.SubCategoryID = SM.SubCategoryID group by SM.DisplayName");

            sbDept.Append("SELECT cm.name DisplayName,IF(cf.ConfigID='14','true','false')IsPackage,");
            sbDept.Append("SUM(T1.Amount) NetAmt,SUM(T1.Quantity) Qty,CONCAT(cm.CategoryID,'#',cf.ConfigID)Category FROM ( ");
            sbDept.Append("    SELECT lt.LedgerTransactionNo,ltd.Amount,ltd.Quantity,ltd.subcategoryID ");
            sbDept.Append("    FROM mortuary_ledgertnxdetail ltd INNER JOIN mortuary_ledgertransaction LT ");
            sbDept.Append("    ON ltd.LedgerTransactionNo = LT.LedgerTransactionNo ");
            sbDept.Append("    WHERE Lt.IsCancel = 0 AND  ltd.IsVerified = 1 AND ltd.IsPackage = 0 AND ltd.IsSurgery = 0 ");
            sbDept.Append("    AND lt.TransactionID = '" + TransID + "' ");
            sbDept.Append("    AND DATE(lt.Date) >= '" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' ");
            sbDept.Append("    AND DATE(lt.Date) <= '" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "' ");
            sbDept.Append("    UNION ALL ");
            sbDept.Append("    SELECT DISTINCT(lt.LedgerTransactionNo),lt.NetAmount,1 Quantity,ltd.SubcategoryID ");
            sbDept.Append("    FROM mortuary_ledgertnxdetail ltd INNER JOIN mortuary_ledgertransaction LT ");
            sbDept.Append("    ON ltd.LedgerTransactionNo = LT.LedgerTransactionNo ");
            sbDept.Append("    WHERE Lt.IsCancel = 0 AND ltd.IsVerified = 1 AND ltd.IsPackage = 0 ");
            sbDept.Append("    AND ltd.IsSurgery = 1 AND lt.TransactionID = '" + TransID + "' ");
            sbDept.Append("    AND DATE(lt.Date) >= '" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' ");
            sbDept.Append("    AND DATE(lt.Date) <= '" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "' ");
            sbDept.Append(")T1 INNER JOIN f_subcategorymaster SM ON T1.SubCategoryID = SM.SubCategoryID ");
            sbDept.Append("INNER JOIN f_configrelation cf ON cf.CategoryID = sm.CategoryID ");
            sbDept.Append("INNER JOIN f_categorymaster cm ON sm.CategoryID = cm.CategoryID ");
            sbDept.Append("GROUP BY cf.ConfigID,cm.name ");

            DataTable dt = new DataTable();
            dt = StockReports.GetDataTable(sbDept.ToString());

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

    private void BindDepartmentBySearch()
    {
        if (ViewState["TransID"] != null)
        {
            string TransID = Convert.ToString(ViewState["TransID"]);
            StringBuilder sbDept = new StringBuilder();
            sbDept.Append("SELECT cm.name DisplayName,IF(cf.ConfigID='14','true','false')IsPackage,");
            sbDept.Append("SUM(T1.Amount) NetAmt,SUM(T1.Quantity) Qty,CONCAT(cm.CategoryID,'#',cf.ConfigID)Category FROM ( ");
            sbDept.Append("    SELECT lt.LedgerTransactionNo,ltd.Amount,ltd.Quantity,ltd.subcategoryID ");
            sbDept.Append("    FROM mortuary_ledgertnxdetail ltd INNER JOIN mortuary_ledgertransaction LT ");
            sbDept.Append("    ON ltd.LedgerTransactionNo = LT.LedgerTransactionNo ");
            sbDept.Append("    WHERE Lt.IsCancel = 0 AND  ltd.IsVerified = 1 AND ltd.IsPackage = 0 AND ltd.IsSurgery = 0 ");
            sbDept.Append("    AND lt.TransactionID = '" + TransID + "' ");
            sbDept.Append("    AND DATE(lt.Date) >= '" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' ");
            sbDept.Append("    AND DATE(lt.Date) <= '" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "' ");
            sbDept.Append("    UNION ALL ");
            sbDept.Append("    SELECT DISTINCT(lt.LedgerTransactionNo),lt.NetAmount,1 Quantity,ltd.SubcategoryID ");
            sbDept.Append("    FROM mortuary_ledgertnxdetail ltd INNER JOIN mortuary_ledgertransaction LT ");
            sbDept.Append("    ON ltd.LedgerTransactionNo = LT.LedgerTransactionNo ");
            sbDept.Append("    WHERE Lt.IsCancel = 0 AND ltd.IsVerified = 1 AND ltd.IsPackage = 0 ");
            sbDept.Append("    AND ltd.IsSurgery = 1 AND lt.TransactionID = '" + TransID + "' ");
            sbDept.Append("    AND DATE(lt.Date) >= '" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' ");
            sbDept.Append("    AND DATE(lt.Date) <= '" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "' ");
            sbDept.Append(")T1 INNER JOIN f_subcategorymaster SM ON T1.SubCategoryID = SM.SubCategoryID ");
            sbDept.Append("INNER JOIN f_configrelation cf ON cf.CategoryID = sm.CategoryID ");
            sbDept.Append("INNER JOIN f_categorymaster cm ON sm.CategoryID = cm.CategoryID ");
            sbDept.Append("GROUP BY cf.ConfigID,cm.name ");

            DataTable dt = new DataTable();
            dt = StockReports.GetDataTable(sbDept.ToString());

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
        dt.Columns.Add("Transaction_ID");
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
                IsFilter = Convert.ToBoolean(ViewState["IsFilter"]);

            string TransID = Convert.ToString(ViewState["TransID"]);
            string DispName = Convert.ToString(ViewState["DispName"]).ToUpper();
            string ConfigID = Convert.ToString(ViewState["ConfigID"]);
            string IsEdit = "false";
            string IsReject = "false";
            DataTable Authority = (DataTable)ViewState["Authority"];
            StringBuilder sb = new StringBuilder();


            //--------------------------------------------------------------
            //--------------------------------------------------------------
            switch (ConfigID)
            {
                case "11": // Medicine & Cosnumables
                    sb.Append("select ltd.LedgerTnxID LtNo,lt.TransactionID,date_format(ltd.EntryDate,'%d-%b-%Y %l:%i %p')IssueDate,ltd.ItemName,ltd.Rate,ltd.Quantity,ltd.DiscountPercentage DiscPer,");
                    //sb.Append(" ((ltd.Rate*ltd.Quantity)*ltd.DiscountPercentage)/100 DiscAmt,ltd.Amount,'---' Package,em.Name,'false' IsNPSurgery,'false' IsEdit,'false' IsReject,'false' IsSurgery,sm.Name SubCat,sm.SubCategoryID,ltd.UserID,ltd.ItemID");
                    sb.Append(" ROUND((((ltd.Rate*ltd.Quantity)*ltd.DiscountPercentage)/100),2) DiscAmt,ltd.Amount,'---' Package,em.Name,'false' IsNPSurgery,");
                    sb.Append("(select name from f_subcategorymaster where SubcategoryID=ltd.subcategoryid)subcategoryname,IF(ltd.rate=0,'true',");
                    //////if (Authority.Rows.Count > 0)
                    //////{
                    //////    if (Authority.Rows[0]["IsEdit"].ToString() == "1")
                    //////    {
                    //////        IsEdit = "true";
                    //////    }
                    //////    if (Authority.Rows[0]["IsReject"].ToString() == "1")
                    //////    {
                    //////        IsReject = "true";
                    //////    }
                    //////}
                    sb.Append(" '" + IsEdit + "' )IsEdit,'" + IsReject + "' IsReject,");
                    // sb.Append(" 'true' IsEdit,'true' IsReject,");
                    sb.Append("'false' IsSurgery,sm.Name SubCat,sm.SubCategoryID,ltd.UserID,ltd.ItemID,(SELECT (NAME)DiscGivenBy FROM employee_master WHERE employeeid=ltd.DiscUserID)DiscGivenBy ");
                    sb.Append(" From mortuary_ledgertnxdetail ltd inner join mortuary_ledgertransaction LT on ltd.LedgerTransactionNo = LT.LedgerTransactionNo inner join employee_master em on ltd.UserID = em.EmployeeID ");
                    sb.Append(" inner join f_subcategorymaster sm on sm.SubCategoryID = ltd.SubCategoryID inner join f_configrelation cf on sm.CategoryID = cf.CategoryID WHERE Lt.IsCancel = 0 and ltd.IsVerified = 1 and ltd.IsPackage = 0 and cf.ConfigID=11 and lt.TransactionID = '" + TransID + "' ");
                    sb.Append(" and date(lt.Date) >= '" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' and date(lt.Date) <= '" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "' ");
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
                default:
                    sb.Append("select ltd.LedgerTnxID LtNo,lt.TransactionID,date_format(ltd.EntryDate,'%d-%b-%Y %l:%i %p')IssueDate,ltd.ItemName,ltd.Rate,ltd.Quantity,ltd.DiscountPercentage DiscPer,");
                    sb.Append(" ROUND((((ltd.Rate*ltd.Quantity)*ltd.DiscountPercentage)/100),2) DiscAmt,ltd.Amount,'---' Package,em.Name,'false' IsNPSurgery,");
                    sb.Append("(select name from f_subcategorymaster where SubcategoryID=ltd.subcategoryid)subcategoryname,IF(ltd.rate=0,'true',");
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
                    sb.Append(" '" + IsEdit + "')IsEdit,'" + IsReject + "' IsReject,");
                    sb.Append(" 'false' IsSurgery,sm.Name SubCat,sm.SubCategoryID,ltd.UserID,ltd.ItemID,ltd.DiscountReason,(SELECT (NAME)DiscGivenBy FROM employee_master WHERE employeeid=ltd.DiscUserID)DiscGivenBy ");
                    sb.Append(" From mortuary_ledgertnxdetail ltd inner join mortuary_ledgertransaction LT on ltd.LedgerTransactionNo = LT.LedgerTransactionNo inner join employee_master em on ltd.UserID = em.EmployeeID ");
                    sb.Append(" inner join f_subcategorymaster sm on sm.SubCategoryID = ltd.SubCategoryID WHERE Lt.IsCancel = 0 and ltd.IsVerified = 1 and ltd.IsPackage = 0 and sm.CategoryID = '" + DispName.Replace("'", "''") + "' and lt.TransactionID = '" + TransID + "'");
                    sb.Append(" and date(lt.Date) >= '" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' and date(lt.Date) <= '" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "' ");
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

                if (chkItem.Checked)
                    for (int iStatus = 0; iStatus < gvItemDetail.Rows.Count; iStatus++)
                        ((CheckBox)gvItemDetail.Rows[iStatus].FindControl("ChkSelect")).Checked = true;

                lblMsg.Text = string.Empty;
                lblFilterAmount.Text = string.Empty;
                if (ConfigID != "22" && ConfigID != "14") // Not Equal to Surgery-22 and Package-14
                    lblFilterAmount.Text = Util.GetString(dt.Compute("sum(Amount)", ""));

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
    private DataTable GetPackage()
    {
        if (ViewState["TransID"] != null)
        {
            string IsEdit = "true";
            string IsReject = "false";
            DataTable Authority = (DataTable)ViewState["Authority"];
            string TID = Convert.ToString(ViewState["TransID"]);

            StringBuilder sb = new StringBuilder();
            sb.Append(" select LedgerTnxID,Amount,TypeName,PDate,ItemID,");

            if (Authority.Rows.Count > 0)
            {
                if (Authority.Rows[0]["IsEdit"].ToString() == "1")
                {
                    IsEdit = "false";
                }
                if (Authority.Rows[0]["IsReject"].ToString() == "1")
                {
                    IsReject = "true";
                }
            }
            sb.Append(" '" + IsEdit + "' IsEdit,'" + IsReject + "' IsReject,");
            sb.Append(" if(Items is null,'true','false')IsRejectItems");
            sb.Append(" from (select T1.LedgerTnxID,T1.Amount,t1.ItemID,T1.TypeName,t1.PDate,t2.Items from");
            sb.Append(" (select ltd.LedgerTnxID,ltd.ItemID,ltd.Amount,im.TypeName,date_format(ltd.EntryDate,'%d-%b-%y') PDate");
            sb.Append(" from f_ledgertnxdetail ltd inner join f_itemmaster im on ltd.ItemID = im.ItemID inner join f_subcategorymaster sm");
            sb.Append(" on sm.SubCategoryID = im.SubCategoryID inner join f_configrelation cf on sm.CategoryID=cf.CategoryID ");
            sb.Append(" where ltd.IsPackage = 0 and ltd.IsVerified = 1 and ltd.IsFree = 0 ");
            sb.Append(" and ltd.TransactionID = '" + TID + "' and cf.ConfigID=14 )T1 left join ");
            sb.Append(" (select PackageID,count(*) Items from f_ledgertnxdetail ltd where ltd.IsPackage = 1 and ltd.IsVerified = 1 ");
            sb.Append(" and IsFree = 0 and ltd.TransactionID = '" + TID + "' group by ltd.PackageID)T2 on t1.itemid = t2.PackageID )T3");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            //if (dt.Rows[0]["IsRejectItems"].ToString() == "true")
            //{
            //    dt.Columns.Remove("IsRejectItems");
            //}

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

                if (((Label)row.FindControl("lblIsSurgery")).Text.ToUpper() != "TRUE")
                {
                    if (strLtdNo != string.Empty)
                        strLtdNo += ",'" + ltno + "'";
                    else
                        strLtdNo += "'" + ltno + "'";
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
                    btnReject.Enabled = true;
                else
                    btnReject.Enabled = false;
                if (ConfigID == "7")
                    btnReject.Enabled = false;
            }

        }
        switch (ConfigID)
        {
            case "11": // Medicine & Consumables
                btnFilter.Enabled = true;
                btnDiscount.Enabled = false;
                btnRate.Enabled = false;
                //btnReject.Enabled = false;
                // btnPackage.Enabled = false;
                break;
            default:
                btnFilter.Enabled = true;
                //btnRate.Enabled = true;
                //btnDiscount.Enabled = true;
                //btnReject.Enabled = true;
                // btnPackage.Enabled = false;
                break;

        }
    }
    private void DisableJobs()
    {
        btnFilter.Enabled = false;
        btnRate.Enabled = false;
        btnDiscount.Enabled = false;
        btnReject.Enabled = false;
    }
    private void SummaryBill()
    {
        //if (ViewState["TransID"] != null)
        //{
        //    StringBuilder sb = new StringBuilder();
        //    string TID = ViewState["TransID"].ToString();
        //    sb.Append("  select T1.*,em.name as username from (select LT.LedgerTransactionNo, ltd.LedgerTnxID LTDetailID,lt.Transaction_ID,");
        //    sb.Append(" date_format(lt.Date,'%d-%b-%y')IssueDate,date_format(ltd.VerifiedDate,'%d-%b-%y')VerifiedDate, ");
        //    sb.Append("  ltd.ItemName,round(ltd.Rate,1) Rate,ltd.Quantity,ltd.DiscountPercentage");
        //    sb.Append("  ,((ltd.Quantity*ltd.Rate)*ltd.DiscountPercentage)/100 DiscountAmount,");
        //    sb.Append("  ltd.Amount,ltd.UserID,ltd.PackageID, LTD.IsSurgery,sub.name as subcategory,sub.DisplayName");
        //    sb.Append(" ,sub.DisplayPriority,ltd.DiscountReason,ltd.SurgeryName,date_format(ltd.EntryDate,'%d-%b-%y')EntryDate,ltd.SubCategoryID,ltd.IsVerified,ltd.IsPackage,ltd.ItemID,ltd.Surgery_ID From f_ledgertnxdetail ltd inner join f_ledgertransaction LT ");
        //    sb.Append("  on ltd.LedgerTransactionNo = LT.LedgerTransactionNo INNER JOIN f_subcategorymaster");
        //    sb.Append("  SUB ON ltd.SubCategoryID=sub.SubCategoryID   WHERE Lt.IsCancel = 0 and ltd.IsVerified = 1 and ltd.IsPackage = 0 and  ltd.IsSurgery = 0");
        //    sb.Append("  and lt.Transaction_ID = '" + TID + "' union all select LT.LedgerTransactionNo,ltd.LedgerTnxID LTDetailID,lt.Transaction_ID");
        //    sb.Append(" ,date_format(lt.Date,'%d-%b-%y')IssueDate,date_format(ltd.VerifiedDate,'%d-%b-%y')VerifiedDate, ");
        //    sb.Append(" ltd.SurgeryName ItemName,round(lt.GrossAmount,1) Rate,1 Quantity, lt.DiscountOnTotal ,(lt.GrossAmount*lt.DiscountOnTotal)/100 DiscountAmount, lt.NetAmount");
        //    sb.Append(" ,ltd.UserID,ltd.PackageID ,LTD.IsSurgery,sub.name as subcategory ,sub.DisplayName,sub.DisplayPriority,ltd.DiscountReason,ltd.SurgeryName,date_format(ltd.EntryDate,'%d-%b-%y')EntryDate,ltd.SubCategoryID,ltd.IsVerified,ltd.IsPackage,ltd.ItemID,ltd.Surgery_ID");
        //    sb.Append("  From f_ledgertnxdetail ltd inner join f_ledgertransaction LT on  ltd.LedgerTransactionNo = LT.LedgerTransactionNo INNER JOIN f_subcategorymaster SUB ON");
        //    sb.Append("  ltd.SubCategoryID=sub.SubCategoryID WHERE Lt.IsCancel = 0 and ltd.IsVerified = 1 and  ltd.IsPackage = 0 and ltd.IsSurgery = 1 and lt.Transaction_ID = '" + TID + "' group by lt.LedgerTransactionNo");
        //    sb.Append("  )T1 inner join employee_master em on T1.UserID = em.Employee_ID order by IssueDate Desc ");

        //    DataTable Table = new DataTable();
        //    Table = StockReports.GetDataTable(sb.ToString());
        //    if (Table != null && Table.Rows.Count > 0)
        //    {
        //        Table.TableName = "Table";
        //        Session["Table"] = Table;
        //    }

        //    DataTable dtBilled = new DataTable();
        //    StringBuilder sb1 = new StringBuilder();
        //    sb1.Append("select LedgerTransactionNo,NetAmount,GrossAmount,DiscountOnTotal,Date_Format(Date,'%d-%b-%Y')EntryDate,((DiscountOnTotal/GrossAmount) * 100) as Discount,BillNo,DiscountReason,Patient_ID,Transaction_ID,Panel_ID,TransactionTypeID,Date from f_ledgertransaction where Transaction_ID = '" + TID + "'  order by LedgerTransactionNo");
        //    dtBilled = StockReports.GetDataTable(sb1.ToString());
        //    if (dtBilled != null && dtBilled.Rows.Count > 0)
        //    {
        //        Table.TableName = "dtBilled";
        //        Session["dtBilled"] = dtBilled;
        //    }

        //    DataTable dtNetAmtWord = new DataTable();
        //    dtNetAmtWord.TableName = "dtNetAmtWord";
        //    dtNetAmtWord.Columns.Add("BilledAmt");
        //    dtNetAmtWord.Columns.Add("ReceivedAmt", typeof(decimal));
        //    dtNetAmtWord.Columns.Add("NetAmount");
        //    dtNetAmtWord.Columns.Add("NetAmountWord");
        //    dtNetAmtWord.Columns.Add("DiscountReason");
        //    dtNetAmtWord.Columns.Add("ShowReceipt");

        //    string DiscountReason = "";

        //    string NetAmount = Util.GetString(Util.GetDecimal(lblGrossBillAmt.Text) - Util.GetDecimal(lblAdvanceAmt.Text));
        //    AllQuery AQ = new AllQuery();
        //    DataTable dt = AQ.GetPatientAdjustmentDetails(ViewState["TransID"].ToString());

        //    if (dt != null && dt.Rows.Count > 0)
        //    {
        //        NetAmount = Util.GetString(Util.GetDecimal(NetAmount) - Util.GetDecimal(dt.Rows[0]["DiscountOnBill"].ToString()));
        //        DiscountReason = Util.GetString(dt.Rows[0]["DiscountOnBillReason"].ToString());
        //    }


        //    DataRow row = dtNetAmtWord.NewRow();
        //    row["BilledAmt"] = lblGrossBillAmt.Text;
        //    row["ReceivedAmt"] = Util.GetDecimal(lblAdvanceAmt.Text);
        //    row["NetAmount"] = NetAmount;
        //    row["ShowReceipt"] = "1";
        //    row["DiscountReason"] = DiscountReason;
        //    dtNetAmtWord.Rows.Add(row);
        //    Session["dtNetAmtWord"] = dtNetAmtWord;

        //    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/IPD/BillReport.aspx?ReportType=1');", true);
        //}

    }
    private void DetailBill()
    {

        //if (ViewState["TransID"] != null)
        //{
        //    StringBuilder sb = new StringBuilder();
        //    string TID = ViewState["TransID"].ToString();
        //    sb.Append("  select T1.*,em.name as username from (select LT.LedgerTransactionNo, ltd.LedgerTnxID LTDetailID,lt.Transaction_ID,");
        //    sb.Append(" date_format(lt.Date,'%d-%b-%y')IssueDate,date_format(ltd.VerifiedDate,'%d-%b-%y')VerifiedDate, ");
        //    sb.Append("  ltd.ItemName,round(ltd.Rate,1) Rate,ltd.Quantity,ltd.DiscountPercentage");
        //    sb.Append("  ,((ltd.Quantity*ltd.Rate)*ltd.DiscountPercentage)/100 DiscountAmount,");
        //    sb.Append("  ltd.Amount,ltd.UserID,ltd.PackageID, LTD.IsSurgery,sub.name as subcategory,sub.DisplayName");
        //    sb.Append(" ,sub.DisplayPriority,ltd.DiscountReason,ltd.SurgeryName,date_format(ltd.EntryDate,'%d-%b-%y')EntryDate,ltd.SubCategoryID,ltd.IsVerified,ltd.IsPackage,ltd.ItemID,ltd.Surgery_ID From f_ledgertnxdetail ltd inner join f_ledgertransaction LT ");
        //    sb.Append("  on ltd.LedgerTransactionNo = LT.LedgerTransactionNo INNER JOIN f_subcategorymaster");
        //    sb.Append("  SUB ON ltd.SubCategoryID=sub.SubCategoryID   WHERE Lt.IsCancel = 0 and ltd.IsVerified = 1 and ltd.IsPackage = 0 and  ltd.IsSurgery = 0");
        //    sb.Append("  and lt.Transaction_ID = '" + TID + "' union all select LT.LedgerTransactionNo,ltd.LedgerTnxID LTDetailID,lt.Transaction_ID");
        //    sb.Append(" ,date_format(lt.Date,'%d-%b-%y')IssueDate,date_format(ltd.VerifiedDate,'%d-%b-%y')VerifiedDate, ");
        //    sb.Append(" ltd.SurgeryName ItemName,round(lt.GrossAmount,1) Rate,1 Quantity, lt.DiscountOnTotal ,(lt.GrossAmount*lt.DiscountOnTotal)/100 DiscountAmount, lt.NetAmount");
        //    sb.Append(" ,ltd.UserID,ltd.PackageID ,LTD.IsSurgery,sub.name as subcategory ,sub.DisplayName,sub.DisplayPriority,ltd.DiscountReason,ltd.SurgeryName,date_format(ltd.EntryDate,'%d-%b-%y')EntryDate,ltd.SubCategoryID,ltd.IsVerified,ltd.IsPackage,ltd.ItemID,ltd.Surgery_ID");
        //    sb.Append("  From f_ledgertnxdetail ltd inner join f_ledgertransaction LT on  ltd.LedgerTransactionNo = LT.LedgerTransactionNo INNER JOIN f_subcategorymaster SUB ON");
        //    sb.Append("  ltd.SubCategoryID=sub.SubCategoryID WHERE Lt.IsCancel = 0 and ltd.IsVerified = 1 and  ltd.IsPackage = 0 and ltd.IsSurgery = 1 and lt.Transaction_ID = '" + TID + "' group by lt.LedgerTransactionNo");
        //    sb.Append("  )T1 inner join employee_master em on T1.UserID = em.Employee_ID order by IssueDate Desc ");

        //    DataTable Table = new DataTable();
        //    Table = StockReports.GetDataTable(sb.ToString());
        //    if (Table != null && Table.Rows.Count > 0)
        //    {
        //        Table.TableName = "Table";
        //        Session["Table"] = Table;
        //    }

        //    DataTable dtBilled = new DataTable();
        //    StringBuilder sb1 = new StringBuilder();
        //    sb1.Append("select LedgerTransactionNo,NetAmount,GrossAmount,DiscountOnTotal,Date_Format(Date,'%d-%b-%Y')EntryDate,((DiscountOnTotal/GrossAmount) * 100) as Discount,BillNo,DiscountReason,Patient_ID,Transaction_ID,Panel_ID,TransactionTypeID,Date from f_ledgertransaction where Transaction_ID = '" + TID + "'  order by LedgerTransactionNo");
        //    dtBilled = StockReports.GetDataTable(sb1.ToString());
        //    if (dtBilled != null && dtBilled.Rows.Count > 0)
        //    {
        //        Table.TableName = "dtBilled";
        //        Session["dtBilled"] = dtBilled;
        //    }

        //    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/IPD/BillReport.aspx?ReportType=2');", true);
        //}
    }

    //private void CheckPanelScheme(string Transaction_ID)
    //{
    //    AllQuery AQ = new AllQuery();

    //    decimal AmountBilled = Util.GetDecimal(AQ.GetBillAmount(Transaction_ID));

    //    string str = "Select * from patient_panel_scheme where Patient_ID = (Select Patient_ID from patient_medical_history where Transaction_ID= '" + Transaction_ID + "')";
    //    DataTable dtpt = new DataTable();

    //    dtpt = StockReports.GetDataTable(str);

    //    if (dtpt != null && dtpt.Rows.Count > 0)
    //    {
    //        if (Util.GetDecimal(dtpt.Rows[0]["IPDDoneAmt"]) + AmountBilled >= Util.GetDecimal(dtpt.Rows[0]["IPDInsuredAmt"]))
    //        {
    //            lblMsg.Text = "The Patient's Credit Limit Exceeded By Rs. " + ((Util.GetDecimal(dtpt.Rows[0]["IPDDoneAmt"]) + AmountBilled) - Util.GetDecimal(dtpt.Rows[0]["IPDInsuredAmt"])) + "  ";
    //        }

    //    }
    //}
    #endregion

    #region DML Operations
    /// <summary>
    /// For Rejecting Items 
    /// </summary>
    /// <param name="LtNo">LedgerTransactionNo</param>
    /// <param name="LtdNo">LedgerTnxID</param>
    /// <returns>True if Successfully</returns>
    private bool RejectItems(string LtNo, string LtdNo, string Reason)
    {

        if (!ValidateRefundItem(LtNo, LtdNo))
        {
            return false;
        }

        string str = string.Empty;
        bool iResult = false;
        if (LtNo != string.Empty)
        {
            str = "Select * from f_ledgertnxdetail where LedgerTransactionNo in (" + LtNo + ") and IsVerified=1 and IsMedService=1";
            str = StockReports.ExecuteScalar(str);

            if (str == string.Empty)
            {
                str = "update f_ledgertnxdetail set IsVerified = 2,CancelUserId='" + Session["ID"].ToString() + "',Canceldatetime=now(),CancelReason='" + txtCancelReason.Text.Trim() + "',LastUpdatedBy = '" + ViewState["UserID"] + "',Updateddate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',IpAddress = '" + Util.GetString(Session["ClientIP"]) + "' where LedgerTransactionNo in (" + LtNo + ")";
                iResult = StockReports.ExecuteDML(str);
            }
            else
            {
                lblMsg.Text = "Items Cannot be rejected since it is med service items and issued from med store or nursing station.";
            }
        }
        if (LtdNo != string.Empty)
        {
            str = "Select * from f_ledgertnxdetail where LedgerTnxID in (" + LtdNo + ") and IsVerified=1 and IsMedService=1";
            str = StockReports.ExecuteScalar(str);

            if (str == string.Empty)
            {
                str = "update f_ledgertnxdetail set IsVerified = 2,CancelUserId='" + Session["ID"].ToString() + "',Canceldatetime=now(),CancelReason='" + txtCancelReason.Text.Trim() + "',LastUpdatedBy = '" + ViewState["UserID"] + "',Updateddate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',IpAddress = '" + Util.GetString(Session["ClientIP"]) + "' where LedgerTnxID in (" + LtdNo + ")";
                iResult = StockReports.ExecuteDML(str);
            }
            else
            {
                lblMsg.Text = "Med";
            }
        }
        return iResult;
    }
    #endregion

    protected void gvItemDetail_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            string ItemID = ((Label)e.Row.FindControl("lblItemID")).Text;
            string IssueDate = ((Label)e.Row.FindControl("lblDate")).Text;
            string LedgerTnxID = ((Label)e.Row.FindControl("lblLedTnxNo")).Text;

            string DiscReason = StockReports.ExecuteScalar("Select DiscountReason from f_LedgertnxDetail where LedgerTnxID='" + LedgerTnxID + "'");

            //if (DiscReason != "")
            //    DiscReason = "<b>Disc. Reason : " + DiscReason + "</b>";

            e.Row.Attributes.Add("title", DiscReason);

            GridView gv = ((GridView)e.Row.Parent.Parent);

            //int iCtr = 0;
            foreach (GridViewRow grow in gv.Rows)
            {
                string NxtItemID = ((Label)grow.FindControl("lblItemID")).Text;
                string Date = ((Label)grow.FindControl("lblDate")).Text;

                if (NxtItemID == ItemID && IssueDate == Date)
                {
                    e.Row.BackColor = System.Drawing.Color.Orchid;
                }
            }
        }
    }

    //protected void gvDeptBill_RowDataBound(object sender, GridViewRowEventArgs e)
    //{
    //    DataRowView row;
    //    if (e.Row.RowType == DataControlRowType.DataRow)
    //    {
    //        row = (DataRowView)e.Row.DataItem;
    //        e.Row.Attributes.Add("onclick", "SetNewColor(this);");
    //    }
    //}

    protected void btnOKRejection_Click(object sender, EventArgs e)
    {
        bool Result = false;
        int ResultFlag = Util.GetInt(StockReports.ExecuteScalar("select COUNT(pl.ID)ID  from f_itemmaster im inner join f_ledgertnxdetail ltd on im.ItemID=ltd.ItemID  and ltd.SubCategoryID = im.SubCategoryID and ltd.LedgerTransactionNo in ('" + lblLedTnxID.Text.Trim() + "') inner join patient_labinvestigation_ipd pl on pl.Investigation_ID = im.Type_ID  and ltd.LedgerTransactionNo = pl.LedgerTransactionNo and Result_Flag= 1 "));
        if (ResultFlag > 0)
        {
            lblMsg.Text = "Result Already Done, Please Contact Administrator";
            return;
        }
        lblMsg.Text = "";
        GetSelection();

        if (lblIsSurgery.Text != "TRUE")
        {
            if (lblLedTnxID.Text.Trim() != "")
            {
                Result = RejectItems(string.Empty, "'" + lblLedTnxID.Text.Trim() + "'", txtCancelReason.Text.Trim());
                lblLedTnxID.Text = "";
            }
            else
            {
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
            // lblMsg.Text = "Item Rejected Successfully";
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
                dt = StockReports.GetDataTable("select pl.ID,pl.Investigation_ID  from f_itemmaster im inner join f_ledgertnxdetail ltd on im.ItemID=ltd.ItemID  and ltd.LedgerTransactionNo in (" + LtNo + ") inner join patient_labinvestigation_ipd pl on pl.Investigation_ID = im.Type_ID  and ltd.LedgerTransactionNo = pl.LedgerTransactionNo and IsSampleCollected='Y' ;");

            if (LtdNo != string.Empty)
                dt = StockReports.GetDataTable("select pl.ID,pl.Investigation_ID  from f_itemmaster im inner join f_ledgertnxdetail ltd on im.ItemID=ltd.ItemID  and LedgerTnxID in (" + LtdNo + ") inner join patient_labinvestigation_ipd pl on pl.Investigation_ID = im.Type_ID  and ltd.LedgerTransactionNo = pl.LedgerTransactionNo and IsSampleCollected='Y';");



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
                                dtradio = StockReports.GetDataTable("select pl.ID,pl.Investigation_ID  from f_itemmaster im inner join f_ledgertnxdetail ltd on im.ItemID=ltd.ItemID  and ltd.SubCategoryID = im.SubCategoryID and LedgerTnxID in (" + LtdNo + ") inner join patient_labinvestigation_ipd pl on pl.Investigation_ID = im.Type_ID  and ltd.LedgerTransactionNo = pl.LedgerTransactionNo and Result_Flag>0;");
                                if (dtradio.Rows.Count > 0)
                                {
                                    lblMsg.Text = "You Can't Delete the Item(s) because Result is Made.";
                                    return false;
                                }
                                else
                                {
                                    DataTable dt3 = new DataTable();

                                    if (LtNo != string.Empty)
                                        dt3 = StockReports.GetDataTable("select pl.ID  from f_itemmaster im inner join f_ledgertnxdetail ltd on im.ItemID=ltd.ItemID  and ltd.SubCategoryID = im.SubCategoryID and ltd.LedgerTransactionNo in (" + LtNo + ") inner join patient_labinvestigation_ipd pl on pl.Investigation_ID = im.Type_ID  and ltd.LedgerTransactionNo = pl.LedgerTransactionNo ;");
                                    if (LtdNo != string.Empty)
                                        dt3 = StockReports.GetDataTable("select pl.ID  from f_itemmaster im inner join f_ledgertnxdetail ltd on im.ItemID=ltd.ItemID  and ltd.SubCategoryID = im.SubCategoryID and LedgerTnxID in (" + LtdNo + ") inner join patient_labinvestigation_ipd pl on pl.Investigation_ID = im.Type_ID  and ltd.LedgerTransactionNo = pl.LedgerTransactionNo ;");

                                    if (dt3.Rows.Count > 0)
                                    {
                                        for (int j = 0; j < dt3.Rows.Count; j++)
                                        {
                                            string LedgerNo = StockReports.ExecuteScalar("Select LedgerTransactionNO from patient_labinvestigation_ipd where ID='" + dt3.Rows[i]["ID"].ToString() + "'");
                                            StockReports.ExecuteDML("update patient_labinvestigation_ipd set LedgerTransactionNoOLD='" + LedgerNo + "' where ID='" + dt3.Rows[i]["ID"].ToString() + "'");
                                            StockReports.ExecuteDML("update patient_labinvestigation_ipd set LedgerTransactionNO='' where ID='" + dt3.Rows[i]["ID"].ToString() + "'");
                                            //StockReports.ExecuteDML("delete from patient_labinvestigation_ipd where ID='" + dt3.Rows[j]["ID"].ToString() + "'");

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
                                return false;
                            }
                        }
                    }
                }
                else
                {

                    DataTable dt2 = new DataTable();

                    if (LtNo != string.Empty)
                        dt2 = StockReports.GetDataTable("select pl.ID  from f_itemmaster im inner join f_ledgertnxdetail ltd on im.ItemID=ltd.ItemID  and ltd.SubCategoryID = im.SubCategoryID and ltd.LedgerTransactionNo in (" + LtNo + ") inner join patient_labinvestigation_ipd pl on pl.Investigation_ID = im.Type_ID  and ltd.LedgerTransactionNo = pl.LedgerTransactionNo and Result_Flag= 0 ;");
                    if (LtdNo != string.Empty)
                        dt2 = StockReports.GetDataTable("select pl.ID  from f_itemmaster im inner join f_ledgertnxdetail ltd on im.ItemID=ltd.ItemID  and ltd.SubCategoryID = im.SubCategoryID and LedgerTnxID in (" + LtdNo + ") inner join patient_labinvestigation_ipd pl on pl.Investigation_ID = im.Type_ID  and ltd.LedgerTransactionNo = pl.LedgerTransactionNo and Result_Flag= 0 ;");

                    if (dt2.Rows.Count > 0)
                    {
                        for (int i = 0; i < dt2.Rows.Count; i++)
                        {
                            string LedgerNo = StockReports.ExecuteScalar("Select LedgerTransactionNO from patient_labinvestigation_ipd where ID='" + dt2.Rows[i]["ID"].ToString() + "'");
                            StockReports.ExecuteDML("update patient_labinvestigation_ipd set LedgerTransactionNoOLD='" + LedgerNo + "' where ID='" + dt2.Rows[i]["ID"].ToString() + "'");
                            StockReports.ExecuteDML("update patient_labinvestigation_ipd set LedgerTransactionNO='' where ID='" + dt2.Rows[i]["ID"].ToString() + "'");
                            //StockReports.ExecuteDML("delete from patient_labinvestigation_ipd where ID='" + dt2.Rows[i]["ID"].ToString() + "'");

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
                    dt2 = StockReports.GetDataTable("select pl.ID  from f_itemmaster im inner join f_ledgertnxdetail ltd on im.ItemID=ltd.ItemID  and ltd.SubCategoryID = im.SubCategoryID and ltd.LedgerTransactionNo in (" + LtNo + ") inner join patient_labinvestigation_ipd pl on pl.Investigation_ID = im.Type_ID  and ltd.LedgerTransactionNo = pl.LedgerTransactionNo and Result_Flag= 0 ;");
                if (LtdNo != string.Empty)
                    dt2 = StockReports.GetDataTable("select pl.ID  from f_itemmaster im inner join f_ledgertnxdetail ltd on im.ItemID=ltd.ItemID  and ltd.SubCategoryID = im.SubCategoryID and LedgerTnxID in (" + LtdNo + ") inner join patient_labinvestigation_ipd pl on pl.Investigation_ID = im.Type_ID  and ltd.LedgerTransactionNo = pl.LedgerTransactionNo and Result_Flag= 0 ;");

                if (dt2.Rows.Count > 0)
                {
                    for (int i = 0; i < dt2.Rows.Count; i++)
                    {
                        string LedgerNo = StockReports.ExecuteScalar("Select LedgerTransactionNO from patient_labinvestigation_ipd where ID='" + dt2.Rows[i]["ID"].ToString() + "'");
                        StockReports.ExecuteDML("update patient_labinvestigation_ipd set LedgerTransactionNoOLD='" + LedgerNo + "' where ID='" + dt2.Rows[i]["ID"].ToString() + "'");
                        StockReports.ExecuteDML("update patient_labinvestigation_ipd set LedgerTransactionNO='' where ID='" + dt2.Rows[i]["ID"].ToString() + "'");

                        //StockReports.ExecuteDML("delete from patient_labinvestigation_ipd where ID='" + dt2.Rows[i]["ID"].ToString() + "'");

                    }
                    return true;
                }
                else
                    return false;

            }
        }
        return true;

    }
}
