using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Web;

public partial class Design_Mortuary_Mortuary_ItemDiscount : System.Web.UI.Page
{
    DataSet ds;
    string SubCategoryID, DisplayName;

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
            if (Session["ID"] == null)
            {
                Response.Redirect("~/Default.aspx");
            }
            // false
         //   string IsReceipptCaneleation = StockReports.ExecuteScalar(" SELECT IF(IsDiscount=0,'No','Yes')AS IsDicount FROM userauthorization WHERE EmployeeID ='" + Session["ID"].ToString() + "' and RoleID='" + Session["RoleID"].ToString() + "' ");
         //   if (IsReceipptCaneleation == "No")
         //   {
         //       lblMsg.Text = "You are not Authorized to Refund The Amount";
         //       //btnFinalDiscount.Visible = false;
         //   }
            string IsReceipptCaneleation = StockReports.ExecuteScalar(" SELECT IF(ColValue='IsMedClear','Yes','No')AS IsDicount FROM userauthorization WHERE EmployeeID ='" + Session["ID"].ToString() + "' and RoleID='" + Session["RoleID"].ToString() + "' AND CentreID= " + Session["CentreID"] + "  ");//and ColName='IsMedClear'
            if (IsReceipptCaneleation == "No")
            {
                lblMsg.Text = "You are not Authorized to Refund The Amount";
                //btnFinalDiscount.Visible = false;
            }


            ViewState["ID"] = Session["ID"].ToString();
            ViewState["LoginName"] = Session["LoginName"].ToString();
            ViewState["CorpseID"] = Request.QueryString["CorpseID"].ToString();
            ViewState["TransactionID"] = Request.QueryString["TransactionID"].ToString();
            ViewState["LoginType"] = Session["LoginType"].ToString();


            AllQuery AQ = new AllQuery();
            DataTable dt = AQ.GetMortuaryBillDetail(ViewState["TransactionID"].ToString());
            DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(Session["RoleID"]), Util.GetString(Session["ID"]));
            ViewState["Authority"] = dtAuthority;
            if (dt != null && dt.Rows.Count > 0)
            {

                DataTable dtAuthoritys = (DataTable)ViewState["Authority"];
                if (dt.Rows[0]["BillNo"].ToString().Trim() != "")
                {
                    if (dtAuthoritys.Rows.Count > 0)
                    {
                        if (dtAuthoritys.Rows[0]["BillChange"].ToString() == "1")
                        {
                            string Msg = "Corpse's Final Bill has been Generated. No Items can be Prescribed Now..";
                            Response.Redirect("../Mortuary/CorpseBillMsg.aspx?msg=" + Msg);
                        }
                    }
                    else
                    {
                        ViewState["IsBillEdit"] = "YES";
                        ViewState["BillNo"] = dt.Rows[0]["BillNo"].ToString().Trim();
                        ViewState["BillDate"] = dt.Rows[0]["BillDate"].ToString().Trim();
                        DateTime dtBillDate = Util.GetDateTime(dt.Rows[0]["BillDate"].ToString());
                        TimeSpan tSpan = (DateTime.Now - dtBillDate);
                        if ((DateTime.Now.Date != dtBillDate.Date) && (tSpan.TotalHours > 24))
                        {
                            string Msg = "Corpse's Final Bill has been Generated and your 24hrs right has been elasped..";
                            Response.Redirect("../Mortuary/CorpseBillMsg.aspx?msg=" + Msg);
                        }
                    }
                }
            }


            AllSelectQuery ASQ = new AllSelectQuery();
            ds = new DataSet();

            ds.Tables.Add(ASQ.GetBilledCorpseDetail(ViewState["TransactionID"].ToString()).Copy());
            ds.Tables[0].TableName = "dtBilled";

            ds.Tables.Add(ASQ.GetBilledCorpseItemDetailDiscount(ViewState["TransactionID"].ToString()).Copy());
            ds.Tables[1].TableName = "dtBilledDetail";

            ViewState.Add("ds", ds);

            All_LoadData.bindApprovalType(ddlApproveBy);
            All_LoadData.bindApprovalType(ddlApproveBy1);
            All_LoadData.BindRelation(ddlHolder_Relation);
            if (dt.Rows[0]["BillNo"].ToString().Trim() != "" && Session["LoginType"].ToString() != "EDP")
            {
                BindGrids();
                btnGenerateBill.Visible = false;
            }
            else if (dt.Rows[0]["BillNo"].ToString().Trim() == "" && Session["LoginType"].ToString() != "EDP")
            {
                BindGrids();
            }

            if (Session["LoginType"].ToString() == "EDP")
            {
                btnGenerateBill.Visible = false;
            }

            decimal AmountBilled = Util.GetDecimal(AQ.GetMortuaryBillAmount(ViewState["TransactionID"].ToString()));
            decimal TotalDisc = Util.GetDecimal(StockReports.ExecuteScalar("Select (IFNULL(sum((Rate*Quantity)-Amount),0)) TotalDisc from f_ledgertnxdetail where transactionID='" + ViewState["TransactionID"].ToString() + "' and DiscountPercentage > 0  and isverified=1 and ispackage=0"));
            AmountBilled = AmountBilled - TotalDisc;
            txtSerTaxBillAmount.Text = Util.GetDecimal(Math.Round((AmountBilled), 2)).ToString();
            Panel2.Visible = false;
            LoadCurrencyDetail();
            GetBillDetails();
            txtServiceChg.Text = Util.GetDecimal(All_LoadData.GovTaxPer()).ToString();
            decimal ServiceTaxAmt = Util.GetDecimal(Math.Round(Util.GetDecimal((Util.GetDecimal(txtSerTaxBillAmount.Text) * Util.GetDecimal(txtServiceChg.Text)) / 100), 2, System.MidpointRounding.AwayFromZero));
            txtTotalTaxAmt.Text = Util.GetDecimal(Math.Round((ServiceTaxAmt), 2, MidpointRounding.AwayFromZero)).ToString();
            decimal TotalAmt = AmountBilled + ServiceTaxAmt;
            txtNetBillAmt.Text = Util.GetDecimal(Math.Round((TotalAmt), MidpointRounding.AwayFromZero)).ToString();
            decimal RoundOff = Math.Round((TotalAmt), MidpointRounding.AwayFromZero);
            txtRoundOff.Text = Util.GetDecimal(Math.Round((RoundOff - TotalAmt), 2, MidpointRounding.AwayFromZero)).ToString();
            txtSurchg.Attributes.Add("readonly", "readonly");

        }
        lblCurreny_Amount.Text = txtNetBillAmt.Text;
        lblMsg.Text = "";
        txtServiceChg.Attributes.Add("readOnly", "readOnly");
        txtSerTaxBillAmount.Attributes.Add("readOnly", "readOnly");
        txtRoundOff.Attributes.Add("readOnly", "readOnly");

    }

    private void BindRelation()
    {
        string[] Relation = AllGlobalFunction.KinRelation;

        for (int i = 0; i < Relation.Length; i++)
        {
            Relation[i] = Relation[i].ToUpper();
        }

        ddlHolder_Relation.DataSource = Relation;
        ddlHolder_Relation.DataBind();
        ddlHolder_Relation.Items.Insert(0, new ListItem("Select", "0"));
    }
    protected void LoadCurrencyDetail()
    {
        DataTable dtDetail = All_LoadData.LoadCurrencyFactor("");
        ddlCurrency.DataSource = dtDetail;
        ddlCurrency.DataTextField = "Currency";
        ddlCurrency.DataValueField = "CountryID";
        ddlCurrency.DataBind();

        DataRow[] dr = dtDetail.Select("IsBaseCurrency=1");
        ddlCurrency.SelectedIndex = ddlCurrency.Items.IndexOf(ddlCurrency.Items.FindByValue(dr[0]["CountryID"].ToString()));
        lblCurrencyNotation.Text = dr[0]["Notation"].ToString();
    }
    private void BindGrids()
    {
        DataTable dt = ((DataSet)ViewState["ds"]).Tables["dtBilledDetail"];
        string IsVerified = "1";
        DataTable dtTemp = ShowSubCategoryDetails(dt, IsVerified, "0", "0");

        grdBasket.DataSource = dtTemp;
        grdBasket.DataBind();

    }

    private void BindDiscItemGrids(string Displayname)
    {
        string TID = ViewState["TransactionID"].ToString();
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT LedgerTransactionNo,Amount,T1.ItemID,Rate,Quantity,StockID,DiscountPercentage,IsPackage,PackageID, ");
        sb.Append(" IsVerified,t1.SubCategoryID,VarifiedUserID, ItemName,TransactionID,VerifiedDate,UserID,EntryDate,  ");
        sb.Append(" DiscountAmount,LTDetailID,SubCategory, DisplayName,DisplayPriority,DisplayPriority,t1.IsSurgery,t1.Surgery_ID,  ");
        sb.Append(" t1.SurgeryName,t1.DiscountReason,t1.UserName,im.Type_ID,im.ServiceItemID,(Rate*Quantity)GrossAmt,   ");
        sb.Append(" IFNULL(dm.Specialization,'')Specialization FROM (  ");
        sb.Append(" SELECT LTD.LedgerTransactionNo,LTD.Amount,LTD.ItemID,LTD.Rate,LTD.Quantity,LTD.StockID,LTD.DiscountPercentage,  ");
        sb.Append(" LTD.IsPackage,LTD.PackageID,LTD.IsVerified,LTD.SubCategoryID,LTD.VarifiedUserID,LTD.ItemName,  ");
        sb.Append(" LTD.TransactionID,DATE_FORMAT(LTD.VerifiedDate,'%d-%b-%Y')VerifiedDate,LTD.LedgerTnxID AS LTDetailID,  ");
        sb.Append(" LTD.UserID,DATE_FORMAT(LTD.EntryDate,'%d-%b-%Y')EntryDate,(((Rate * Quantity)*DiscountPercentage)/100)  ");
        sb.Append(" DiscountAmount,SC.Name AS SubCategory,SC.DisplayName,SC.DisplayPriority,LTD.IsSurgery,LTD.Surgery_ID,  ");
        sb.Append(" LTD.SurgeryName,LTD.DiscountReason,EM.Name AS UserName FROM mortuary_ledgertnxdetail LTD   ");
        sb.Append(" INNER JOIN mortuary_ledgertransaction LT ON  LT.LedgerTransactionNo = LTD.LedgerTransactionNo   ");
        sb.Append(" INNER JOIN f_subcategorymaster SC ON SC.SubcategoryID = LTD.SubcategoryID       ");
        sb.Append(" LEFT JOIN employee_master EM ON EM.EmployeeID = LTD.DiscUserID    ");
        sb.Append(" WHERE LT.TransactionID = '" + TID + "' AND LTD.Isverified =1    AND DisplayName LIKE '" + Displayname + "'  ");
        sb.Append(" )t1 LEFT JOIN f_itemmaster im ON im.itemid = t1.ItemID    ");
        sb.Append(" LEFT JOIN doctor_master dm ON dm.DoctorID=im.Type_ID   ");
        sb.Append(" ORDER BY t1.DisplayName, t1.SubCategoryID,t1.ItemID,  DATE(t1.EntryDate)   ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        string IsVerified = "1";
        DataTable dtTemp = ShowSubCategoryDetailsDiscItem(dt, IsVerified, "0", "0");

        grdBasketItem.DataSource = dtTemp;
        grdBasketItem.DataBind();

    }

    private DataTable ShowSubCategoryDetailsDiscItem(DataTable dt, string IsVerified, string IsSurgery, string IsPackage)
    {
        DataTable dtReturn = new DataTable();
        dtReturn = dt.Clone();
        if (dtReturn.Columns.Contains("VerifiedFlag") == false) dtReturn.Columns.Add("VerifiedFlag");
        if (dtReturn.Columns.Contains("GrossAmt") == false) dtReturn.Columns.Add("GrossAmt");
        if (dtReturn.Columns.Contains("ItemWiseDisc") == false) dtReturn.Columns.Add("ItemWiseDisc");
        if (dtReturn.Columns.Contains("TotalDeptDisc") == false) dtReturn.Columns.Add("TotalDeptDisc");
        if (dt != null && dt.Rows.Count > 0)
        {
            string SubCategoryID = "", SubCategory = "", DisplayName = "";
            decimal TotalDeptDisc = 0;

            DataRow[] drDisplay = dt.Select("DisplayName <>''  and IsVerified =" + IsVerified + " and IsPackage=" + IsPackage + " and IsSurgery=" + IsSurgery);
            if (drDisplay.Length > 0)
            {
                decimal NetAmount = 0.0m;
                decimal Quantity = 0;
                decimal GrossAmt = 0, ItemWiseDisc = 0;
                foreach (DataRow dr in drDisplay)
                {

                    DisplayName = dr["DisplayName"].ToString();
                    NetAmount = 0;
                    Quantity = 0;
                    SubCategory = "";
                    GrossAmt = 0;
                    ItemWiseDisc = 0;


                    TotalDeptDisc = Util.GetDecimal(Math.Round(Util.GetDecimal(TotalDeptDisc + Util.GetDecimal(Math.Round(Util.GetDecimal(Util.GetDecimal(Util.GetDecimal(dr["Quantity"].ToString()) * Util.GetDecimal(dr["Rate"].ToString())) * Util.GetDecimal(dr["DiscountPercentage"].ToString())) / 100, 2))), 2));
                    NetAmount = Util.GetDecimal(dr["Amount"].ToString());
                    Quantity = Util.GetDecimal(dr["Quantity"].ToString());
                    SubCategory = Util.GetString(dr["DisplayName"].ToString());
                    SubCategoryID = Util.GetString(dr["SubCategoryID"].ToString());
                    GrossAmt = Util.GetDecimal(Util.GetDecimal(dr["Quantity"].ToString()) * Util.GetDecimal(dr["Rate"].ToString()));
                    ItemWiseDisc = Util.GetDecimal(Util.GetDecimal(Util.GetDecimal(Util.GetDecimal(dr["Quantity"].ToString()) * Util.GetDecimal(dr["Rate"].ToString())) * Util.GetDecimal(dr["DiscountPercentage"].ToString())) / 100);

                    DataRow NewRow = dtReturn.NewRow();
                    NewRow["Amount"] = NetAmount.ToString("f2");
                    NewRow["Quantity"] = Quantity;
                    NewRow["SubCategory"] = SubCategory;
                    NewRow["SubCategoryID"] = Util.GetInt( SubCategoryID);
                    NewRow["VerifiedFlag"] = IsVerified;
                    NewRow["TransactionID"] = dr["TransactionID"].ToString();
                    NewRow["DisplayName"] = dr["DisplayName"].ToString();
                    NewRow["GrossAmt"] = Math.Round(GrossAmt, 2);
                    NewRow["ItemWiseDisc"] = Math.Round(ItemWiseDisc, 2);
                    NewRow["DiscountReason"] = dr["DiscountReason"].ToString();
                    NewRow["UserName"] = dr["UserName"].ToString();
                    NewRow["ItemName"] = dr["ItemName"].ToString();
                    NewRow["DiscountPercentage"] = Util.GetDecimal(dr["DiscountPercentage"].ToString());
                    dtReturn.Rows.Add(NewRow);

                }
            }

            DataRow[] drSubCategory = dt.Select("IsNull(DisplayName,'')=''  and IsVerified =" + IsVerified + " and IsPackage=" + IsPackage + " and IsSurgery=" + IsSurgery);

            if (drSubCategory.Length > 0)
            {
                Decimal NetAmount = 0.0m;
                decimal Quantity = 0;
                decimal GrossAmt = 0, ItemWiseDisc = 0;
                foreach (DataRow dr in drSubCategory)
                {

                    SubCategoryID = dr["SubCategoryID"].ToString();
                    NetAmount = 0;
                    Quantity = 0;
                    SubCategory = "";
                    GrossAmt = 0;
                    ItemWiseDisc = 0;

                    TotalDeptDisc = Util.GetDecimal(Math.Round(Util.GetDecimal(TotalDeptDisc + Util.GetDecimal(Math.Round(Util.GetDecimal(Util.GetDecimal(Util.GetDecimal(dr["Quantity"].ToString()) * Util.GetDecimal(dr["Rate"].ToString())) * Util.GetDecimal(dr["DiscountPercentage"].ToString())) / 100, 2))), 2));
                    NetAmount = Util.GetDecimal(dr["Amount"].ToString());
                    Quantity = Util.GetDecimal(dr["Quantity"].ToString());
                    SubCategory = Util.GetString(dr["SubCategory"].ToString());
                    GrossAmt = Util.GetDecimal(Util.GetDecimal(dr["Quantity"].ToString()) * Util.GetDecimal(dr["Rate"].ToString()));
                    ItemWiseDisc = Util.GetDecimal(Util.GetDecimal(Util.GetDecimal(Util.GetDecimal(dr["Quantity"].ToString()) * Util.GetDecimal(dr["Rate"].ToString())) * Util.GetDecimal(dr["DiscountPercentage"].ToString())) / 100);

                    DataRow NewRow = dtReturn.NewRow();
                    NewRow["Amount"] = NetAmount.ToString("f2");
                    NewRow["Quantity"] = Quantity;
                    NewRow["SubCategory"] = SubCategory;
                    NewRow["SubCategoryID"] = SubCategoryID;
                    NewRow["VerifiedFlag"] = IsVerified;
                    NewRow["TransactionID"] = dr["TransactionID"].ToString();
                    NewRow["DisplayName"] = dr["DisplayName"].ToString();
                    NewRow["GrossAmt"] = Math.Round(GrossAmt, 2);
                    NewRow["ItemWiseDisc"] = Math.Round(ItemWiseDisc, 2);
                    NewRow["DiscountReason"] = dr["DiscountReason"].ToString();
                    NewRow["ItemName"] = dr["ItemName"].ToString();
                    NewRow["UserName"] = dr["UserName"].ToString();
                    NewRow["DiscountPercentage"] = Util.GetDecimal(dr["DiscountPercentage"].ToString());
                    dtReturn.Rows.Add(NewRow);
                }

            }
            if (TotalDeptDisc > 0)
            {
                txtDisAmount.Text = Util.GetString(TotalDeptDisc.ToString());
            }
            else
            {
                txtDisAmount.Text = "";
            }
        }

        return dtReturn;
    }


    private DataTable ShowSubCategoryDetails(DataTable dt, string IsVerified, string IsSurgery, string IsPackage)
    {
        DataTable dtReturn = new DataTable();
        dtReturn = dt.Clone();
        if (dtReturn.Columns.Contains("VerifiedFlag") == false) dtReturn.Columns.Add("VerifiedFlag");
        if (dtReturn.Columns.Contains("GrossAmt") == false) dtReturn.Columns.Add("GrossAmt");
        if (dtReturn.Columns.Contains("ItemWiseDisc") == false) dtReturn.Columns.Add("ItemWiseDisc");
        if (dt != null && dt.Rows.Count > 0)
        {
            string SubCategoryID = "", SubCategory = "", DisplayName = "", DiscountReason = "", UserName = "";

            DataRow[] drDisplay = dt.Select("DisplayName <>''  and IsVerified =" + IsVerified + " and IsPackage=" + IsPackage + " and IsSurgery=" + IsSurgery);

            if (drDisplay.Length > 0)
            {
                Decimal NetAmount = 0.0m;
                decimal Quantity = 0;
                decimal GrossAmt = 0, ItemWiseDisc = 0;
                foreach (DataRow dr in drDisplay)
                {
                    if (dr["DisplayName"].ToString() != DisplayName)
                    {
                        DisplayName = dr["DisplayName"].ToString();
                        NetAmount = 0;
                        Quantity = 0;
                        SubCategory = "";
                        GrossAmt = 0;
                        ItemWiseDisc = 0;
                        DiscountReason = "";
                        UserName = "";
                        SubCategoryID = dr["SubCategoryID"].ToString();



                        foreach (DataRow row in drDisplay)
                        {
                            if (row["DisplayName"].ToString() == DisplayName)
                            {
                                NetAmount = NetAmount + Util.GetDecimal(row["Amount"].ToString());
                                Quantity = Quantity + Util.GetDecimal(row["Quantity"].ToString());
                                SubCategory = Util.GetString(row["DisplayName"].ToString());
                                GrossAmt = Util.GetDecimal(GrossAmt + Util.GetDecimal(Util.GetDecimal(row["Quantity"].ToString()) * Util.GetDecimal(row["Rate"].ToString())));
                                ItemWiseDisc = ItemWiseDisc + Util.GetDecimal(Util.GetDecimal(Util.GetDecimal(Util.GetDecimal(row["Quantity"].ToString()) * Util.GetDecimal(row["Rate"].ToString())) * Util.GetDecimal(row["DiscountPercentage"].ToString())) / 100);

                                if (row["UserName"].ToString() != "")
                                {

                                    UserName = row["UserName"].ToString();
                                }
                                if (row["DiscountReason"].ToString() != "")
                                {
                                    DiscountReason = row["DiscountReason"].ToString();
                                }
                            }


                        }

                        DataRow NewRow = dtReturn.NewRow();
                        NewRow["Amount"] = NetAmount.ToString("f2");
                        NewRow["Quantity"] = Quantity;
                        NewRow["SubCategory"] = SubCategory;
                        NewRow["SubCategoryID"] = Util.GetInt( SubCategoryID);
                        NewRow["VerifiedFlag"] = IsVerified;
                        NewRow["TransactionID"] = dr["TransactionID"].ToString();
                        NewRow["DisplayName"] = dr["DisplayName"].ToString();
                        NewRow["GrossAmt"] = Math.Round(GrossAmt, 2);
                        NewRow["ItemWiseDisc"] = Math.Round(ItemWiseDisc, 2);
                        NewRow["IsDiscountable"] = dr["IsDiscountable"].ToString();
                        NewRow["UserName"] = UserName;
                        NewRow["DiscountReason"] = DiscountReason;
                        dtReturn.Rows.Add(NewRow);
                    }
                }
            }

            DataRow[] drSubCategory = dt.Select("IsNull(DisplayName,'')=''  and IsVerified =" + IsVerified + " and IsPackage=" + IsPackage + " and IsSurgery=" + IsSurgery);

            if (drSubCategory.Length > 0)
            {
                Decimal NetAmount = 0.0m;
                decimal Quantity = 0;
                decimal GrossAmt = 0, ItemWiseDisc = 0;

                foreach (DataRow dr in drSubCategory)
                {
                    if (dr["SubCategoryID"].ToString() != SubCategoryID)
                    {
                       // SubCategoryID = dr["SubCategoryID"].ToString();
                        NetAmount = 0;
                        Quantity = 0;
                        SubCategory = "";
                        GrossAmt = 0;
                        ItemWiseDisc = 0;
                        DiscountReason = "";
                        UserName = "";

                        foreach (DataRow row in drSubCategory)
                        {
                            if (row["SubCategoryID"].ToString() == SubCategoryID)
                            {
                                NetAmount = NetAmount + Util.GetDecimal(row["Amount"].ToString());
                                Quantity = Quantity + Util.GetDecimal(row["Quantity"].ToString());
                                SubCategory = Util.GetString(row["SubCategory"].ToString());
                                GrossAmt = Util.GetDecimal(GrossAmt + Util.GetDecimal(Util.GetDecimal(row["Quantity"].ToString()) * Util.GetDecimal(row["Rate"].ToString())));
                                ItemWiseDisc = ItemWiseDisc + Util.GetDecimal(Util.GetDecimal(Util.GetDecimal(Util.GetDecimal(row["Quantity"].ToString()) * Util.GetDecimal(row["Rate"].ToString())) * Util.GetDecimal(row["DiscountPercentage"].ToString())) / 100);
                                if (row["UserName"].ToString() != "")
                                {

                                    UserName = row["UserName"].ToString();
                                }
                                if (row["DiscountReason"].ToString() != "")
                                {
                                    DiscountReason = row["DiscountReason"].ToString();
                                }
                            }

                        }

                        DataRow NewRow = dtReturn.NewRow();
                        NewRow["Amount"] = NetAmount.ToString("f2");
                        NewRow["Quantity"] = Quantity;
                        NewRow["SubCategory"] = SubCategory;
                        NewRow["SubCategoryID"] = SubCategoryID;
                        NewRow["VerifiedFlag"] = IsVerified;
                        NewRow["TransactionID"] = dr["TransactionID"].ToString();
                        NewRow["DisplayName"] = dr["DisplayName"].ToString();
                        NewRow["GrossAmt"] = Math.Round(GrossAmt, 2);
                        NewRow["ItemWiseDisc"] = Math.Round(ItemWiseDisc, 2);
                        NewRow["IsDiscountable"] = dr["IsDiscountable"].ToString();
                        NewRow["UserName"] = UserName;
                        NewRow["DiscountReason"] = DiscountReason;
                        dtReturn.Rows.Add(NewRow);
                    }
                }
            }
        }

        return dtReturn;
    }
    protected void grdBasket_SelectedIndexChanged(object sender, EventArgs e)
    {
        DataTable Authority = (DataTable)ViewState["Authority"];
        if (Authority.Rows.Count > 0)
        {
            if (Authority.Rows[0]["IsDiscount"].ToString() == "1")
            {
                txtDisAmount1.ReadOnly = true;
                txtDisPercent1.ReadOnly = true;

            }

        }
        string IsDiscountable = ((Label)grdBasket.SelectedRow.FindControl("lblIsDiscountable")).Text;
        if (IsDiscountable == "0")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('THIS IS A NON DISCOUNTABLE SERVICE');", true);
            return;
        }

        DataTable dt = ((DataSet)ViewState["ds"]).Tables["dtBilledDetail"];
        DisplayName = ((Label)grdBasket.SelectedRow.FindControl("lblDisplayName")).Text;
        SubCategoryID = ((Label)grdBasket.SelectedRow.FindControl("lblSubCategoryID")).Text;
        lblDept.Text = grdBasket.SelectedRow.Cells[1].Text.ToUpper();
        lblQty.Text = grdBasket.SelectedRow.Cells[2].Text;
        lblAmount.Text = grdBasket.SelectedRow.Cells[3].Text;
        BindDiscItemGrids(DisplayName);
        if (ddlApproveBy.SelectedIndex > 0)
            ddlApproveBy.SelectedIndex = 0;
        mpDisc.Show();

        if (ViewState["DisplayName"] == null)
        {
            ViewState.Add("DisplayName", DisplayName);
        }
        else
        {
            ViewState["DisplayName"] = DisplayName;
        }

        if (ViewState["SubCategoryID"] == null)
        {
            ViewState.Add("SubCategoryID", SubCategoryID);
        }
        else
        {
            ViewState["SubCategoryID"] = SubCategoryID;
        }
    }

    protected void btnSaveItem_Click(object sender, EventArgs e)
    {
        try
        {
            SubCategoryID = ViewState["SubCategoryID"].ToString();
            DisplayName = ViewState["DisplayName"].ToString();

            DataSet ds = (DataSet)ViewState["ds"];
            DataTable dt = ds.Tables[1].Select("SubCategoryID=" + SubCategoryID + "").CopyToDataTable();
            ds.Clear();
            ds.Tables.Add(dt);

            decimal DisAmount = 0, DisPercent = 0;

            if (txtDisAmount.Text.Trim() != "" && txtDisPercent.Text.Trim() == "")
            {
                DisAmount = Util.GetDecimal(txtDisAmount.Text.Trim());
                DisPercent = (DisAmount / Util.GetDecimal(lblAmount.Text.Trim())) * 100;
            }
            else if (txtDisAmount.Text.Trim() == "" && txtDisPercent.Text.Trim() != "")
            {
                DisPercent = Util.GetDecimal(txtDisPercent.Text.Trim());
                DisAmount = Util.GetDecimal(Util.GetDecimal(lblAmount.Text.Trim()) * (Util.GetDecimal(txtDisPercent.Text.Trim()) / 100));
            }
            else
            {
                lblMsg.Text = "Please Specify Discount";
                ToolkitScriptManager1.SetFocus(txtDisAmount);
                return;
            }
            if (ddlApproveBy.SelectedItem.Value == "SELECT")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM08','" + lblMsg.ClientID + "');", true);
                ddlApproveBy1.Focus();
                mpDisc.Show();
                return;
            }
         //   DataTable dtSave = ds.Tables["dtBilledDetail"].Clone();
            DataTable dtSave = ((DataSet)ViewState["ds"]).Tables["Table1"];
            if (SubCategoryID != "" && DisplayName == "")
            {
                for (int i = 0; i < ds.Tables["dtBilledDetail"].Rows.Count; i++)
                {
                    if (ds.Tables["dtBilledDetail"].Rows[i]["SubCategoryID"].ToString() == SubCategoryID)
                    {
                        decimal Rate = 0, TotalAmount = 0;
                        DataRow dr = dtSave.NewRow();
                        dr.ItemArray = ds.Tables["dtBilledDetail"].Rows[i].ItemArray;
                        decimal Quantity = Util.GetDecimal(ds.Tables["dtBilledDetail"].Rows[i]["Quantity"].ToString());
                        Rate = Util.GetDecimal(ds.Tables["dtBilledDetail"].Rows[i]["Rate"].ToString());
                        TotalAmount = Rate * Quantity;
                        DisAmount = ((TotalAmount * DisPercent) / 100);
                        TotalAmount = TotalAmount - DisAmount;
                        ds.Tables["dtBilledDetail"].Rows[i]["DiscountPercentage"] = DisPercent.ToString();
                        ds.Tables["dtBilledDetail"].Rows[i]["DiscountAmount"] = DisAmount.ToString();
                        ds.Tables["dtBilledDetail"].Rows[i]["Amount"] = TotalAmount.ToString();
                        dr["DiscountPercentage"] = DisPercent.ToString();
                        dr["DiscountAmount"] = DisAmount.ToString();
                        dr["Amount"] = TotalAmount.ToString();
                        dtSave.Rows.Add(dr);
                    }
                }
            }
            else if (SubCategoryID == "" && DisplayName != "")
            {
                for (int i = 0; i < ds.Tables["dtBilledDetail"].Rows.Count; i++)
                {
                    if (ds.Tables["dtBilledDetail"].Rows[i]["DisplayName"].ToString() == DisplayName)
                    {
                        decimal Rate = 0, TotalAmount = 0;

                        DataRow dr = dtSave.NewRow();
                        dr.ItemArray = ds.Tables["dtBilledDetail"].Rows[i].ItemArray;
                        decimal Quantity = Util.GetDecimal(ds.Tables["dtBilledDetail"].Rows[i]["Quantity"].ToString());
                        Rate = Util.GetDecimal(ds.Tables["dtBilledDetail"].Rows[i]["Rate"].ToString());
                        TotalAmount = Rate * Quantity;
                        DisAmount = ((TotalAmount * DisPercent) / 100);
                        TotalAmount = TotalAmount - DisAmount;
                        ds.Tables["dtBilledDetail"].Rows[i]["DiscountPercentage"] = DisPercent.ToString();
                        ds.Tables["dtBilledDetail"].Rows[i]["DiscountAmount"] = DisAmount.ToString();
                        ds.Tables["dtBilledDetail"].Rows[i]["Amount"] = TotalAmount.ToString();
                        ds.Tables["dtBilledDetail"].Rows[i]["DiscountReason"] = txtDisReason.Text;
                        ds.Tables["dtBilledDetail"].Rows[i]["UserName"] = ViewState["LoginName"].ToString();
                        dr["DiscountPercentage"] = DisPercent.ToString();
                        dr["DiscountAmount"] = DisAmount.ToString();
                        dr["Amount"] = TotalAmount.ToString();
                        dr["DiscountReason"] = txtDisReason.Text;
                        dr["UserName"] = ViewState["LoginName"].ToString();
                        dtSave.Rows.Add(dr);
                    }
                }
            }

            string UserID = ViewState["ID"].ToString();
            bool IsUpdated = UpdateVerifiedItems(dtSave, txtDisReason.Text.Trim(), UserID, ddlApproveBy.SelectedItem.Value, DisAmount, DisPercent);

            ViewState.Add("ds", ds);

            if (IsUpdated == true)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
                lblItemDis.Text = "";
                Clear();
                BindGrids();
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM07','" + lblMsg.ClientID + "');", true);
            }
            txtDisReason.Text = "";
            txtDisAmount.Text = "";
            txtDisPercent.Text = "";
        }
        catch (Exception ex)
        {
            ClassLog objCL = new ClassLog();
            objCL.errLog(ex);
        }
    }

    public Boolean UpdateVerifiedItems(DataTable Items, string DiscountReason, string UserID, string ApprovalBy,decimal DiscountAmt, decimal DiscPercentage)
    {
        string strQuery = "";
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.ReadCommitted);
        try
        {

            for (int j = 0; j < Items.Rows.Count; j++)
            {
                //strQuery = "Update mortuary_ledgertnxdetail Set Amount=" + Util.GetFloat(Items.Rows[j]["Amount"].ToString()) + ",DiscountPercentage =" + Items.Rows[j]["DiscountPercentage"].ToString() + ", DiscountReason = '" + DiscountReason + "',DiscUserID='" + UserID + "',ApprovalBy='" + ApprovalBy + "',DiscAmt='" + Util.GetDecimal(Items.Rows[j]["DiscountAmount"].ToString()) + "' Where LedgerTnxID ='" + Items.Rows[j]["LTDetailID"].ToString() + "' and " + Items.Rows[j]["SubCategoryID"].ToString() + "";
                strQuery = "Update mortuary_ledgertnxdetail Set Amount=" + Util.GetFloat(Items.Rows[j]["Amount"].ToString()) + ",DiscountPercentage =" + DiscPercentage + ", DiscountReason = '" + DiscountReason + "',DiscUserID='" + UserID + "',ApprovalBy='" + ApprovalBy + "',DiscAmt='" + Util.GetDecimal(DiscountAmt) + "' Where LedgerTnxID ='" + Items.Rows[j]["LTDetailID"].ToString() + "' and SubCategoryID=" + Items.Rows[j]["SubCategoryID"].ToString() + "";
                //strQuery = "Update mortuary_ledgertnxdetail Set Amount=" + Util.GetFloat(Items.Rows[j]["Amount"].ToString()) + ",DiscountPercentage =" + DiscPercentage.ToString() + ", DiscountReason = '" + DiscountReason + "',DiscUserID='" + UserID + "',ApprovalBy='" + ApprovalBy + "',DiscAmt='" + DiscountAmt + "' Where LedgerTnxID ='" + Items.Rows[j]["LTDetailID"].ToString() + "'";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strQuery);
            }

            tnx.Commit();
            con.Close();
            con.Dispose();
            return true;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            con.Close();
            con.Dispose();
            return false;
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnCancelItem_Click(object sender, EventArgs e)
    {
        if (grdBasket.Rows.Count > 0)
        {
            DataTable dtItemDetails = ((DataTable)ViewState["dtItemDetails"]);
            SubCategoryID = ViewState["SubCategoryID"].ToString();
            DisplayName = ViewState["DisplayName"].ToString();
        }
    }

    private void Clear()
    {
        lblAmount.Text = "";
        txtDisAmount.Text = "";
        txtDisPercent.Text = "";
        lblDept.Text = "";
        lblQty.Text = "";
    }
    private void GetBillDetails()
    {
        //string TID = ViewState["TransactionID"].ToString();
        if (ViewState["TransactionID"] != null)
        {
            string TransID = Convert.ToString(ViewState["TransactionID"]);
            StringBuilder sbBill = new StringBuilder();

            //sbBill.Append("Select Round(t2.GrossAmt,2)GrossAmt,Round((t2.GrossAmt-t2.TotalItemWiseDiscount),2)NetAmt,");
            //sbBill.Append("Round(t2.TotalItemWiseDiscount,2)TotalDiscount,t2.TotalItemWiseDiscount FROM ( ");
            //sbBill.Append("     SELECT ltd.TransactionID,SUM(ltd.Rate*ltd.Quantity)GrossAmt,");
            //sbBill.Append("     IFNULL(ROUND(SUM(((ltd.Rate*ltd.Quantity)*ltd.DiscountPercentage)/100),2),0)TotalItemWiseDiscount,im.Type_ID,im.ServiceItemID  ");
            //sbBill.Append("     FROM mortuary_ledgertnxdetail ltd ");
            //sbBill.Append("     INNER JOIN mortuary_ledgertransaction LT ON ltd.LedgerTransactionNo = LT.LedgerTransactionNo ");
            //sbBill.Append("     INNER JOIN f_itemmaster im ON ltd.ItemID = im.ItemID  ");
            //sbBill.Append("     WHERE Lt.IsCancel = 0 AND ltd.IsFree = 0 AND ltd.IsVerified = 1 ");
            //sbBill.Append("     AND ltd.IsPackage = 0 AND lt.TransactionID = '" + ViewState["TransactionID"].ToString() + "' ");
            //sbBill.Append("     group by lt.TransactionID ");
            //sbBill.Append(")T2  ");
            //DataTable dtBill = new DataTable();
            //dtBill = StockReports.GetDataTable(sbBill.ToString());

            //if (dtBill.Rows.Count > 0)
            //{
            //    lblGrossBillAmt.Text = Util.GetDecimal(dtBill.Rows[0]["GrossAmt"]).ToString();
            //    lblBillDiscount.Text = Util.GetDecimal(dtBill.Rows[0]["TotalDiscount"]).ToString();
            //    lblNetAmount.Text = Util.GetDecimal(dtBill.Rows[0]["NetAmt"]).ToString();
            //    lblDiscOnBill.Text = Util.GetDecimal(dtBill.Rows[0]["TotalDiscount"]).ToString();
            //    lblDiscItem.Text = Util.GetDecimal(dtBill.Rows[0]["TotalItemWiseDiscount"]).ToString();
            //    txtCurreny_Amount.Text = lblNetAmount.Text;
            //    lblTaxPer.Text = Util.GetDecimal(All_LoadData.GovTaxPer()).ToString();
            //    lblTotalTax.Text = Util.GetDecimal(Math.Round(Util.GetDecimal((Util.GetDecimal(lblNetAmount.Text) * Util.GetDecimal(lblTaxPer.Text)) / 100), 2, System.MidpointRounding.AwayFromZero)).ToString();
            //    decimal TotalAmt = Util.GetDecimal(lblNetAmount.Text) + Util.GetDecimal(lblTotalTax.Text);
            //    lblNetBillAmt.Text = Util.GetDecimal(Math.Round(TotalAmt, 2, MidpointRounding.AwayFromZero)).ToString();
            //    decimal RoundOff = Math.Round((TotalAmt), 0, MidpointRounding.AwayFromZero);
            //    lblRoundOff.Text = Util.GetDecimal(Math.Round((RoundOff - TotalAmt), 2, MidpointRounding.AwayFromZero)).ToString();
            //    decimal BalanceAmt = Util.GetDecimal(lblNetBillAmt.Text) - Util.GetDecimal(lblAdvanceAmt.Text) + Util.GetDecimal(lblRoundOff.Text);
            //    lblBalanceAmt.Text = Util.GetDecimal(BalanceAmt).ToString();
            //}
            //else
            //    lblMsg.Text = "No Billing Info Found";

            sbBill.Append("Select Round(t2.GrossAmt,2)GrossAmt,Round((t2.GrossAmt-t2.TotalDiscount),2)NetAmt,");
            sbBill.Append("Round(t2.TotalDiscount,2)TotalDiscount,ROUND(IFNULL(t3.RecAmt,0.00),2)RecAmt,t2.TotalItemWiseDiscount FROM ( ");
            sbBill.Append("     select ltd.TransactionID,sum(ltd.Rate*ltd.Quantity)GrossAmt,");
            sbBill.Append("     IFNULL(ROUND(SUM(((ltd.Rate*ltd.Quantity)*ltd.DiscountPercentage)/100)");
            sbBill.Append("     +IFNULL(ipd.DiscountOnBill,0),2),0)TotalDiscount,IFNULL(ROUND(SUM(((ltd.Rate*ltd.Quantity)*ltd.DiscountPercentage)/100),2),0)TotalItemWiseDiscount,im.Type_ID,im.ServiceItemID From mortuary_ledgertnxdetail ltd ");
            sbBill.Append("     inner join mortuary_ledgertransaction LT on ltd.LedgerTransactionNo = LT.LedgerTransactionNo");
            sbBill.Append("     INNER JOIN mortuary_corpse_deposite ipd ON ipd.TransactionID=lt.TransactionID ");
            sbBill.Append("     INNER JOIN f_itemmaster im ON ltd.ItemID = im.ItemID ");
            sbBill.Append("     WHERE Lt.IsCancel = 0 and ltd.IsFree = 0 and ltd.IsVerified = 1 ");
            sbBill.Append("     and ltd.IsPackage = 0");
            sbBill.Append("     and lt.TransactionID = '" + TransID + "' ");
            sbBill.Append("     group by lt.TransactionID ");
            sbBill.Append(")T2  Left join (");
            sbBill.Append("     select TransactionID Transaction_ID,sum(AmountPaid)RecAmt from mortuary_receipt where IsCancel = 0 ");
            sbBill.Append("     and TransactionID = '" + TransID + "' ");
            sbBill.Append("     group by Transaction_ID ");
            sbBill.Append(")T3 on T2.TransactionID = T3.Transaction_ID");
            DataTable dtBill = new DataTable();
            dtBill = StockReports.GetDataTable(sbBill.ToString());

            if (dtBill.Rows.Count > 0)
            {
                lblGrossBillAmt.Text = Util.GetDecimal(dtBill.Rows[0]["GrossAmt"]).ToString();
                lblBillDiscount.Text = Util.GetDecimal(dtBill.Rows[0]["TotalDiscount"]).ToString();
                lblNetAmount.Text = Util.GetDecimal(dtBill.Rows[0]["NetAmt"]).ToString();
                lblAdvanceAmt.Text = Util.GetDecimal(dtBill.Rows[0]["RecAmt"]).ToString();
                //  lblBalanceAmt.Text = Util.GetDecimal(Util.GetDecimal(dtBill.Rows[0]["NetAmt"]) - Util.GetDecimal(dtBill.Rows[0]["RecAmt"])).ToString();
                lblDiscOnBill.Text = Util.GetDecimal(dtBill.Rows[0]["TotalDiscount"]).ToString();
                lblDiscItem.Text = Util.GetDecimal(dtBill.Rows[0]["TotalItemWiseDiscount"]).ToString();
                txtCurreny_Amount.Text = lblNetAmount.Text;
                lblTaxPer.Text = Util.GetDecimal(All_LoadData.GovTaxPer()).ToString();
                lblTotalTax.Text = Util.GetDecimal(Math.Round(Util.GetDecimal((Util.GetDecimal(lblNetAmount.Text) * Util.GetDecimal(lblTaxPer.Text)) / 100), 2, System.MidpointRounding.AwayFromZero)).ToString();
                decimal TotalAmt = Util.GetDecimal(lblNetAmount.Text) + Util.GetDecimal(lblTotalTax.Text);
                lblNetBillAmt.Text = Util.GetDecimal(Math.Round(TotalAmt, 2, MidpointRounding.AwayFromZero)).ToString();
                decimal RoundOff = Math.Round((TotalAmt), 0, MidpointRounding.AwayFromZero);
                lblRoundOff.Text = Util.GetDecimal(Math.Round((RoundOff - TotalAmt), 2, MidpointRounding.AwayFromZero)).ToString();
                decimal BalanceAmt = Util.GetDecimal(lblNetBillAmt.Text) - Util.GetDecimal(lblAdvanceAmt.Text) + Util.GetDecimal(lblRoundOff.Text);
                lblBalanceAmt.Text = Util.GetDecimal(BalanceAmt).ToString();
            }
            else
                lblMsg.Text = "No Billing Info Found";

        }
    }
    private void BindApprovalType()
    {
        string str = "select Distinct(ApprovalType) from f_discountapproval order by ApprovalType";

        DataTable dt = new DataTable(str);

        if (dt.Rows.Count >= 0)
        {
            ddlApproveBy.DataSource = dt;
            ddlApproveBy.DataTextField = "ApprovalType";
            ddlApproveBy.DataValueField = "ApprovalType";
            ddlApproveBy.DataBind();
            ddlApproveBy.Items.Insert(0, new ListItem("SELECT", "SELECT"));

            ddlApproveBy1.DataSource = dt;
            ddlApproveBy1.DataTextField = "ApprovalType";
            ddlApproveBy1.DataValueField = "ApprovalType";
            ddlApproveBy1.DataBind();
            ddlApproveBy1.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        }
    }

    protected void btnFinalDiscount_Click(object sender, EventArgs e)
    {
        try
        {
           // BindApprovalType();
            Panel2.Visible = true;
            FillPatientInfo(ViewState["TransactionID"].ToString());
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
    protected void btnSaveFinalBill_Click(object sender, EventArgs e)
    {


        bool result = false;
        string ApprovalBy = String.Empty;

        ApprovalBy = ddlApproveBy1.Text;

        decimal DisAmount = 0, DisPercent = 0, BillAmount = 0;

        BillAmount = (Util.GetDecimal(lblBillAmount.Text.Trim()) - Util.GetDecimal(lblDisAlreadygiven.Text.Trim()));

        if (txtDisAmount1.Text.Trim() != "" && txtDisPercent1.Text.Trim() == "")
        {
            DisAmount = Util.GetDecimal(txtDisAmount1.Text.Trim());
            DisPercent = (DisAmount / BillAmount) * 100;
        }
        else if (txtDisAmount1.Text.Trim() == "" && txtDisPercent1.Text.Trim() != "")
        {
            DisPercent = Util.GetDecimal(txtDisPercent1.Text.Trim());
            DisAmount = Util.GetDecimal(Math.Round((Util.GetDecimal(BillAmount) * Util.GetDecimal(txtDisPercent1.Text.Trim())) / 100));
        }


        if (DisAmount > BillAmount)
        {
            lblMsg.Text = "Discount Greater than Total Billed Amount";
            return;
        }
        if (DisAmount > 0 && ddlApproveBy1.SelectedItem.Text.ToUpper() == "SELECT")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM08','" + lblMsg.ClientID + "');", true);
            return;
        }
        result = IpdBillAdjustment.updateAdjustmentDisc(DisAmount, txtDisReason1.Text.Trim(), 0, "", ViewState["TransactionID"].ToString(), ApprovalBy, lblBillAmount.Text.Trim(), ViewState["ID"].ToString(), DisPercent);

        if (result)
        {
            Clear();
            lblMsg.Text = "Billing information updated";
            Panel2.Visible = false;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "location.href='Mortuary_ItemDiscount.aspx?TransactionID=" + ViewState["TransactionID"].ToString() + "&CorpseID=" + ViewState["CorpseID"].ToString() + "';", true);

        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
        }
    }

    private void FillPatientInfo(string PTransID)
    {
        AllQuery AQ = new AllQuery();
        decimal AmountReceived = Util.GetDecimal(AQ.GetPaidAmount(PTransID));
        DataTable dt = new DataTable();
        dt = IpdBillAdjustment.GetIPDAdjustment(PTransID);
        if (dt.Rows.Count > 0)
        {
            if (Session["LoginType"].ToString() == "EDP" || dt.Rows[0]["BillNo"].ToString().Trim() == "")
            {
                UpdateBilling();
                GetItemDiscount();
                lblPatientID.Text = Util.GetString(dt.Rows[0]["PatientID"]);
                lblDiscountPercent.Text = Util.GetDecimal((Util.GetDecimal(lblDisAlreadygiven.Text.Trim()) / Util.GetDecimal(lblBillAmount.Text.Trim())) * 100).ToString();
                lblBillAfterDiscount.Text = Util.GetString(Util.GetDecimal(lblBillAmount.Text.Trim()) - Util.GetDecimal(lblDisAlreadygiven.Text.Trim()));
                decimal TotalLedgerAmount = GetTotalLedgerAmount(PTransID);

                if ((Util.GetDecimal(dt.Rows[0]["DiscountOnBill"]) > 0 || Util.GetDecimal(dt.Rows[0]["AdjustmentAmt"]) != 0))
                {
                    decimal DiscountOnBill = Util.GetDecimal(dt.Rows[0]["DiscountOnBill"].ToString());
                    decimal TotalBilled = Util.GetDecimal(dt.Rows[0]["TotalBilledAmt"].ToString());
                    decimal AdjAmount = Util.GetDecimal(dt.Rows[0]["AdjustmentAmt"].ToString());
                    decimal ItemDiscount = Util.GetDecimal(lblDisAlreadygiven.Text.Trim());
                    txtDisAmount1.Text = dt.Rows[0]["DiscountOnBill"].ToString();
                    txtDisReason1.Text = dt.Rows[0]["DiscountOnBillReason"].ToString();
                    lblBillAfterDiscount.Text = Util.GetString(Util.GetDecimal(lblBillAmount.Text.Trim()) - Util.GetDecimal(DiscountOnBill));

                    btnSaveFinalBill.Text = "Update";
                }
                // lblSettAmt.Text = StockReports.ExecuteScalar("SELECT ROUND(1755-((1300*100)/(100+5)),2)");
                lblSettAmt.Text = Util.GetDecimal(Math.Round((Util.GetDecimal(lblBillAfterDiscount.Text) - Util.GetDecimal(((Util.GetDecimal(lblPaidAmount.Text) * Util.GetDecimal(100)) / Util.GetDecimal((Util.GetDecimal(100) + Util.GetDecimal(txtServiceChg.Text)))))), 2, MidpointRounding.AwayFromZero)).ToString();
                if (Session["LoginType"].ToString() == "EDP")
                {
                    txtDisAmount1.ReadOnly = true;
                    txtDisPercent1.ReadOnly = true;
                }
            }
            else
            {
                lblMsg.Text = "Patient Billing has been done";
                Clear();
            }
        }
    }

    private decimal GetTotalLedgerAmount(string TransID)
    {
        string str = "select (if(sum(Quantity*Rate) is null,0,sum(Quantity*Rate)))As TotalAmount from f_ledgertnxdetail"
            + " where TransactionID = '" + TransID + "' and IsPackage = 0 and IsVerified = 1";
        MySqlConnection con = Util.GetMySqlCon();
        if (con.State == ConnectionState.Closed)
            con.Open();

        decimal TotalAmount = Util.GetDecimal(MySqlHelper.ExecuteScalar(con, CommandType.Text, str));
        if (con.State == ConnectionState.Open)
            con.Close();
        con.Dispose();
        return TotalAmount;
    }

    private void GetItemDiscount()
    {
        ds = (DataSet)ViewState["ds"];

        Decimal DiscountAmount = 0m, DiscountPercent = 0m, TotalDisAmount = 0m;

        DataRow[] drDiscount = ds.Tables["dtBilledDetail"].Select("DiscountPercentage > 0  and isverified=1 and ispackage=0 ");

        if (drDiscount.Length > 0)
        {
            foreach (DataRow dr in drDiscount)
            {
                DiscountPercent = Util.GetDecimal(dr["DiscountPercentage"].ToString());
                DiscountAmount = ((Util.GetDecimal(dr["Rate"].ToString()) * Util.GetDecimal(dr["Quantity"].ToString())) * DiscountPercent) / 100;

                TotalDisAmount = TotalDisAmount + DiscountAmount;
            }
            lblDisAlreadygiven.Text = TotalDisAmount.ToString("f2");
        }
        else
        {
            lblDisAlreadygiven.Text = Util.GetDecimal("0").ToString("f2");
        }
    }
    private void UpdateBilling()
    {
        try
        {
            AllQuery AQ = new AllQuery();
            Decimal AmountReceived = Util.GetDecimal(AQ.GetPaidAmount(ViewState["TransactionID"].ToString()));
            Decimal AmountBilled = Util.GetDecimal(AQ.GetBillAmount(ViewState["TransactionID"].ToString()));
            lblBillAmount.Text = AmountBilled.ToString();
            lblPaidAmount.Text = AmountReceived.ToString();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    

    protected void btnGenerateBill_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        string TransactionID = ViewState["TransactionID"].ToString();
        try
        {
            int medClear = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(stockid)  FROM mortuary_ledgertnxdetail WHERE TransactionID='" + TransactionID + "' AND stockid!='' AND IsVerified=1"));
            int IsMedClear = 1;
            //int IsMedClear = Util.GetInt(StockReports.ExecuteScalar("Select IsMedCleared from f_ipdadjustment where TransactionID='" + TransactionID + "'"));
            if (medClear > 0)
            {
                if (IsMedClear != 1)
                {
                    lblMsg.Text = "Please Get Medicine Clearance Before Generating Bill";
                    return;
                }
            }


            //if (rdbBillType.SelectedIndex == -1)
            //{
            //    lblMsg.Text = "Please Select Billing Type";
            //    return;
            //}

            string IsItemsGivenInPkg = Util.GetString(StockReports.ExecuteScalar("SELECT ltd.* FROM mortuary_ledgertnxdetail ltd INNER JOIN f_subcategorymaster sc ON ltd.SubCategoryID = sc.SubCategoryID INNER JOIN f_configrelation cf ON sc.CategoryID = cf.CategoryID WHERE ltd.IsVerified=1 AND cf.ConfigID=14 and ltd.TransactionID='" + TransactionID + "'"));

            if (IsItemsGivenInPkg != string.Empty)
            {
                IsItemsGivenInPkg = "";
                IsItemsGivenInPkg = Util.GetString(StockReports.ExecuteScalar("Select * from mortuary_ledgertnxDetail where TransactionID='" + TransactionID + "' and isverified=1 and IsPackage=1 "));

                if (IsItemsGivenInPkg == string.Empty)
                {
                    lblMsg.Text = "Corpse has some Package Given But there is no Item in the Package...";
                    return;
                }
            }


            //--01-02-2015--//
            //bool Istrue = false;
            //if (rdbBillType.SelectedValue == "1")
            //{
            //    Istrue = Util.GetBoolean(StockReports.ExecuteScalar("Select if(IsPackage=1,'true','false')IsTrue  from f_ledgertnxDetail where TransactionID='" + TransactionID + "' and isverified=1 and IsPackage=1"));

            //    if (Istrue)
            //    {
            //        lblMsg.Text = "Patient has some Package Given. The Billing Type should be either Package Bill or Mixed Bill.";
            //        return;
            //    }
            //}

            //if (rdbBillType.SelectedValue == "2")
            //{
            //    Istrue = Util.GetBoolean(StockReports.ExecuteScalar("Select if(IsPackage=1,'true','false')IsTrue  from f_ledgertnxDetail where TransactionID='" + TransactionID + "' and isverified=1 and IsPackage=1"));

            //    if (Istrue == false)
            //    {
            //        lblMsg.Text = "Patient has some Package Given. The Billing Type should be either Package Bill or Mixed Bill.";
            //        return;

            //    }
            //}

            //if (rdbBillType.SelectedValue == "3")
            //{
            //    Istrue = Util.GetBoolean(StockReports.ExecuteScalar("Select if(IsPackage=1,'true','false')IsTrue  from f_ledgertnxDetail where TransactionID='" + TransactionID + "' and isverified=1 and IsPackage=1"));

            //    if (Istrue == false)
            //    {
            //        lblMsg.Text = "This seems to be Mixed package.Please Check and then Select Proper Billing Type";
            //        return;
            //    }
            //}
            //--01-02-2015--//


            //Checking if Patient has given package but no entry of surgery in the package then bill
            //should not be generated

            ////Istrue = false; //Checking if Package is given            
            ////Istrue = Util.GetBoolean(StockReports.ExecuteScalar("Select if(IsPackage=1,'true','false')IsTrue  from f_ledgertnxDetail where TransactionID='" + TransactionID + "' and isverified=1 and IsPackage=1"));

            ////if (Istrue)
            ////{
            ////    string IsExist = ""; //Checking if Major Surgery is given
            ////    IsExist = Util.GetString(StockReports.ExecuteScalar("Select * from f_ledgertnxDetail where Transaction_ID='" + TransactionID + "' and isverified=1 and IsPackage=1 and IsSurgery=1"));

            ////    if (IsExist==string.Empty)
            ////    {
            ////        //Checking if Minor Procedure is given
            ////        IsExist = Util.GetString(StockReports.ExecuteScalar("SELECT ltd.* FROM f_ledgertnxdetail ltd INNER JOIN f_subcategorymaster sc ON ltd.SubCategoryID = sc.SubCategoryID INNER JOIN f_configrelation cf ON sc.CategoryID = cf.CategoryID WHERE ltd.IsVerified=1 AND ltd.IsPackage=1 AND cf.ConfigID=25 and ltd.Transaction_ID='" + TransactionID + "'"));

            ////        if (IsExist == string.Empty)
            ////        {
            ////            lblMsg.Text = "Patient has some Package Given. There Must be either Major Surgery or Minor Procedure in the Package...";
            ////            return;
            ////        }
            ////    }
            ////}            

            AllQuery AQ = new AllQuery();

            DataTable dtDischarge = AQ.GetCorpseReleasedStatus(TransactionID);

            if (dtDischarge != null && dtDischarge.Rows.Count > 0)
            {
                if (dtDischarge.Rows[0]["IsReleased"].ToString() == "0")
                {
                    string Msg = "Corpse is Not Released yet. Bill cannot be generated right now";
                    lblMsg.Text = Msg;
                    return;
                }
            }

            DataTable dtF_ledgertnxdtl = StockReports.GetDataTable("Select (SELECT DisplayName FROM f_subcategorymaster where subcategoryid=ltd.subcategoryid limit 1)DisplayName,ltd.* from mortuary_ledgertnxdetail ltd WHERE TransactionID='" + TransactionID + "' and rate=0 and isverified=1 and Ispackage=0");
            //Check for PolicyNo, ClaimNo or StaffID if Not Given for Patient then Bill Cannot Be Generated
            if (dtF_ledgertnxdtl.Rows.Count > 0)
            {

                lblMsg.Text = "There are Items having ZERO Rates in Group :" + dtF_ledgertnxdtl.Rows[0]["DisplayName"].ToString() + ".Please Set Rates before Generating Bill";
                return;
            }


            DataTable dtCheck = StockReports.GetDataTable("Select * from patient_medical_history where TransactionID=(SELECT TransactionID FROM mortuary_corpse_master WHERE Corpse_ID='" + ViewState["CorpseID"].ToString() + "' limit 1)");

            if (dtCheck.Rows.Count > 0)
            {

                if (dtCheck.Rows[0]["PanelID"].ToString().Trim() != "1" && dtCheck.Rows[0]["PanelID"].ToString().Trim() != "2" && dtCheck.Rows[0]["PanelID"].ToString().Trim() != "3") // Not Equal To Cash Panel
                {

                    string cardNo = dtCheck.Rows[0]["CardNo"].ToString();
                    string policyNo = dtCheck.Rows[0]["PolicyNo"].ToString();
                    string employeeid = dtCheck.Rows[0]["Employeeid"].ToString();

                    txtPolicyNo.Text = policyNo;
                    txtEmpID.Text = employeeid;
                    txtCardNo.Text = cardNo;

                    //if (cardNo == "" && policyNo == "" && employeeid == "")
                    //{
                    //    //mpePolicy.Show();
                    //    return;
                    //}
                }


                //Panel Document Check
                string Panel_ID = dtCheck.Rows[0]["PanelID"].ToString().Trim();

                StringBuilder sb = new StringBuilder();
                sb.Append("SELECT pdd.PanelDocumentID,pdm.Document,IF(t.PanelDocumentID IS NULL,'false','true')STATUS, ");
                sb.Append("FilePath,FileName,if(IFNULL(FilePath,'')='','false','true')FileStatus FROM f_paneldocumentdetail pdd INNER JOIN ");
                sb.Append("f_paneldocumentMaster pdm ON pdd.DocumentID = pdm.DocumentID ");
                sb.Append("LEFT JOIN ( ");
                sb.Append("       SELECT PanelDocumentID,FilePath,FileName,reasonofIgnore FROM f_paneldocument_patient ");
                sb.Append("       WHERE TransactionID='" + dtCheck.Rows[0]["TransactionID"] + "' AND IsActive=1 AND  reasonofIgnore='' ");
                sb.Append(")t ON pdd.PanelDocumentID = t.PanelDocumentID Where pdd.IsActive=1 ");
                sb.Append("and PanelID='" + Panel_ID + "' and IFNULL(t.FileName,'')='' AND t.reasonofIgnore='' ");

                DataTable dt = StockReports.GetDataTable(sb.ToString());

                //if (dt != null && dt.Rows.Count > 0)
                //{
                //    grdPanelDocs.DataSource = dt;
                //    grdPanelDocs.DataBind();
                //    //mpeDocs.Show();
                //    return;
                //}
            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return;
        }

        try
        {
            //Save to f_ipdAdjustment table;

            string BillNo = "";
            string BillDate = "";

            AllQuery AQ = new AllQuery();

            //--01-02-2016--//
            //AllUpdate AU = new AllUpdate();

            //int rowAffected = AU.UpdateDischargeStatusTobeBill(TransactionID);

            //if (rowAffected == 0)
            //{
            //    lblMsg.Text = "Bill cannot be generated";
            //    return;
            //}
            //--01-02-2016--//

            BillDate = DateTime.Now.ToString("yyyy-MM-dd");

            decimal serTaxBillAmt = 0, serviceTaxAmt = 0, amtAftServiceAmt = 0, surchargeTaxAmt = 0, netBillAmt = 0, serviceTaxPer = 0, surchargePer = 0;
            decimal sAmount = 0, cFactor = 0;
            int sCountryID = 0;
            string sNotation = "";
            decimal amountBilled = Util.GetDecimal(AQ.GetMortuaryBillAmount(ViewState["TransactionID"].ToString()));
            netBillAmt = amountBilled;

            DataTable dt = StockReports.GetDataTable("SELECT cnm.S_CountryID,cnm.S_Currency,cnm.S_Notation,cnm.B_Currency FROM country_master cm INNER JOIN converson_master cnm ON cm.CountryID = cnm.S_CountryID WHERE cm.IsActive=1 AND cm.IsBaseCurrency=1 ");
            AllSelectQuery ASQ = new AllSelectQuery();
            sCountryID = Util.GetInt(ddlCurrency.SelectedValue);
            // S_Amount = Util.GetDecimal(txtCurreny_Amount.Text.Trim());
            // change 05.06.14 
            sAmount = Util.GetDecimal(txtNetBillAmt.Text.Trim());
            //S_Notation = Util.GetString(lblCurrencyNotation.Text.Trim());
            sNotation = Util.GetString(ddlCurrency.SelectedItem.Text);
            //C_Factor = ASQ.GetConversionFactor(Util.GetInt(dt.Rows[0]["S_CountryID"]));
            cFactor = ASQ.GetConversionFactor(Util.GetInt(ddlCurrency.SelectedItem.Value));
            //change 04.06.14
            //if (IsServiceTax == "1")
            //{
            decimal totalDisc = Util.GetDecimal(StockReports.ExecuteScalar("Select IFNULL(sum((Rate*Quantity)-Amount),0) TotalDisc from mortuary_ledgertnxdetail where TransactionID='" + TransactionID + "' and DiscountPercentage > 0  and isverified=1 and ispackage=0"));
            amountBilled = amountBilled - totalDisc;

            if (Util.GetDecimal(txtSerTaxBillAmount.Text.Trim()) != amountBilled)
                serTaxBillAmt = Util.GetDecimal(txtSerTaxBillAmount.Text.Trim());
            else
                serTaxBillAmt = amountBilled;

            serviceTaxPer = Util.GetDecimal(txtServiceChg.Text.Trim());
            surchargePer = Util.GetDecimal(txtSurchg.Text.Trim());

            serviceTaxAmt = Util.GetDecimal(Math.Round(Util.GetDecimal((serTaxBillAmt * serviceTaxPer) / 100), 2, System.MidpointRounding.AwayFromZero));
            amtAftServiceAmt = amountBilled + serviceTaxAmt;
            surchargeTaxAmt = Util.GetDecimal(Math.Round(Util.GetDecimal((serviceTaxAmt * surchargePer) / 100)));
            netBillAmt = amtAftServiceAmt + surchargeTaxAmt;
            //  }



            BillNo = UpdateBillingInfo(BillNo, BillDate, netBillAmt, TransactionID, ViewState["ID"].ToString(), serviceTaxAmt, serviceTaxPer, surchargeTaxAmt, surchargePer, serTaxBillAmt, txtNarration.Text.Trim(), sCountryID, sAmount, sNotation, cFactor, Util.GetDecimal(txtRoundOff.Text));

            if (BillNo != ""&&BillNo!=null)
            {
                //UpdatePanelSchemeAmount(lblPatientID.Text.Trim(), AmountBilled);

                lblMsg.Text = "Final Bill is generated having Bill No. :: " + BillNo;
                btnGenerateBill.Enabled = false;
                btnSaveFinalBill.Enabled = false;
                btnCancelItem.Enabled = false;
                //btnFinalDiscount.Enabled = false;
                btnSaveItem.Enabled = false;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "ak1", "alert('Deposite No. : " + TransactionID.Replace("CRSHHI", "") + " is Closed for further editing.');", true);
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "ak2", "location.href='PatientFinalMsg.aspx?TransactionID=" + TransactionID + "';", true);

            }
            else
            {
                lblMsg.Text = "Bill Has not Been generated";
            }


        }
        catch (Exception ex)
        {
            ClassLog objErr = new ClassLog();
            objErr.errLog(ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    private string UpdateBillingInfo(string BillNo, string BillDate, decimal BillAmount, string PTransID, string UserID, decimal ServiceTaxAmt, decimal ServiceTaxPer, decimal ServiceTaxSurChgAmt, decimal SerTaxSurChgPer, decimal SerTaxBillAmt, string Narration, int S_CountryID, decimal S_Amount, string S_Notation, decimal C_Factor, decimal RoundOff)
    {
        StringBuilder objSQL = new StringBuilder();

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            AllQuery objAllQuery = new AllQuery(tnx);
            BillNo = objAllQuery.GetNewBillNoMortuary(CentreID);
            BillDate = DateTime.Now.ToString("yyyy-MM-dd");

            //ipdadjustment ipd = new ipdadjustment(tnx);
            //int str = ipd.UpdateBillingInfo(BillNo, BillDate, PTransID, UserID, BillAmount, ServiceTaxAmt, ServiceTaxPer, ServiceTaxSurChgAmt, SerTaxSurChgPer, SerTaxBillAmt, BillingType, Narration, S_CountryID, S_Amount, S_Notation, C_Factor, RoundOff);

            objSQL.Append(" update mortuary_corpse_deposite set BillNo = '" + BillNo + "',BillDate='" + BillDate + "',TotalBilledAmt=" + BillAmount + ",");
            objSQL.Append(" ServiceTaxAmt = " + ServiceTaxAmt + ",ServiceTaxPer =" + ServiceTaxPer + ",");
            objSQL.Append(" ServiceTaxSurChgAmt=" + ServiceTaxSurChgAmt + ",SerTaxSurChgPer=" + SerTaxSurChgPer + ",");
            objSQL.Append(" SerTaxBillAmount = " + SerTaxBillAmt + " , ");
            objSQL.Append(" Narration='" + Narration + "',S_Amount='" + S_Amount + "',S_CountryID='" + S_CountryID + "',S_Notation='" + S_Notation + "',C_Factor='" + C_Factor + "' , ");
            objSQL.Append(" BillClosedBy='" + UserID + "',BillClosedDate = NOW(),IsBillClosed = 1,RoundOff='" + RoundOff + "' where TransactionID = '" + PTransID + "'");

            int str = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, objSQL.ToString());

            if (str > 0)
            {
                AllUpdate au = new AllUpdate(tnx);
                objSQL.Clear();
                objSQL.Append("Update mortuary_ledgertransaction Set BillNo='" + BillNo + "',BillDate='" + BillDate + "',BillType='Mortuary' Where TransactionID ='" + PTransID + "'");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, objSQL.ToString());
            }

            //===============Post of Billing==========

            bool isTrue = true;


            if (isTrue)
            {
                tnx.Commit();
                tnx.Dispose();
                con.Close();
                con.Dispose();
                return BillNo;
            }
            else
            {
                tnx.Rollback();
                tnx.Dispose();
                con.Close();
                con.Dispose();
                return "";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            return "";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }


    private void BindNarration()
    {
        //DataTable dt = CreateStockMaster.GetNarration();
        //if (dt != null && dt.Rows.Count > 0)
        //{
        //    cmbNarration.DataSource = dt;
        //    cmbNarration.DataTextField = "NarationName";
        //    cmbNarration.DataValueField = "Description";
        //    cmbNarration.DataBind();
        //}


    }

    protected void cmbNarration_SelectedIndexChanged(object sender, EventArgs e)
    {
        txtNarration.Text = cmbNarration.SelectedItem.Value;
    }
    protected void btnSaveNarration_Click(object sender, EventArgs e)
    {

        string IsSave = CreateStockMaster.UpdateNarration(txtNarration.Text, ViewState["TransactionID"].ToString());
        if (IsSave == "1")
        {
            lblMsg.Text = "Narration Saved Successfully";
            txtNarration.Text = "";
        }
        else
        {
            lblMsg.Text = "Narration  Not Saved";
        }
    }

    private void CheckPanelScheme(string Transaction_ID)
    {
        AllQuery AQ = new AllQuery();

        decimal AmountBilled = Util.GetDecimal(AQ.GetBillAmount(ViewState["TransactionID"].ToString()));

        string str = "Select * from patient_panel_scheme where Patient_ID = (Select Patient_ID from patient_medical_history where TransactionID= '" + Transaction_ID + "')";
        DataTable dtpt = new DataTable();

        dtpt = StockReports.GetDataTable(str);

        if (dtpt != null && dtpt.Rows.Count > 0)
        {
            if (Util.GetDecimal(dtpt.Rows[0]["IPDDoneAmt"]) + AmountBilled >= Util.GetDecimal(dtpt.Rows[0]["IPDInsuredAmt"]))
            {
                lblMsg.Text = "The Patient's Credit Limit Exceeded By Rs. " + ((Util.GetDecimal(dtpt.Rows[0]["IPDDoneAmt"]) + AmountBilled) - Util.GetDecimal(dtpt.Rows[0]["IPDInsuredAmt"])) + "  ";
            }

        }
    }

    private void UpdatePanelSchemeAmount(string PatientID, decimal BillAmount)
    {
        try
        {
            string str = "Update patient_panel_scheme Set pnl.IPDDoneAmt = " + BillAmount + "  where Patient_ID='" + PatientID + "'";
            StockReports.ExecuteDML(str);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    private string UpdateBillingInfo(string BillNo, string BillDate, decimal BillAmount, string PTransID, string UserID, decimal ServiceTaxAmt, decimal ServiceTaxPer, decimal ServiceTaxSurChgAmt, decimal SerTaxSurChgPer, decimal SerTaxBillAmt)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            string objSQL = "";
            objSQL += "update f_ipdadjustment set BillNo = '" + BillNo + "',UserID ='" + UserID + "',TotalBilledAmt=" + BillAmount + ",";
            objSQL += "ServiceTaxAmt = " + ServiceTaxAmt + ",ServiceTaxPer =" + ServiceTaxPer + ",ServiceTaxSurChgAmt=" + ServiceTaxSurChgAmt + ",SerTaxSurChgPer=" + SerTaxSurChgPer + ", SerTaxBillAmount = " + SerTaxBillAmt + " where TransactionID = '" + PTransID + "'";

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, objSQL);

            AllUpdate au = new AllUpdate(tnx);
            au.UpdateLedgerTransactionBillNoByTranID(PTransID, BillNo, BillDate);


            tnx.Commit();

            return BillNo;
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            tnx.Rollback();

            return "";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnUpdateBilling_Click(object sender, EventArgs e)
    {
        if (ViewState["IsBillEdit"] != null && ViewState["IsBillEdit"].ToString() == "YES")
        {
            string BillNo = "";
            string BillDate = "";
            string TransactionID = ViewState["TransactionID"].ToString();


            BillDate = Util.GetDateTime(ViewState["BillDate"]).ToString("yyyy-MM-dd");
            BillNo = ViewState["BillNo"].ToString();

            decimal serTaxBillAmt = 0, serviceTaxAmt = 0, amtAftServiceAmt = 0, surchargeTaxAmt = 0, netBillAmt = 0, serviceTaxPer = 0, surchargePer = 0;
            AllQuery AQ = new AllQuery();
            decimal amountBilled = Util.GetDecimal(AQ.GetBillAmount(ViewState["TransactionID"].ToString()));
            netBillAmt = amountBilled;
            string isServiceTax = StockReports.ExecuteScalar("Select IsServiceTax from f_panel_master where PanelID=(Select PanelID from Patient_Medical_History where TransactionID='" + ViewState["TransactionID"].ToString() + "')").Trim().ToUpper();

            if (isServiceTax == "1")
            {
                decimal totalDisc = Util.GetDecimal(StockReports.ExecuteScalar("Select (IFNULL(sum((Rate*Quantity)-Amount),0) + (Select IFNULL(DiscountOnBill,0) from f_ipdadjustment where transaction_ID='" + TransactionID + "')) TotalDisc from f_ledgertnxdetail where transaction_ID='" + TransactionID + "' and DiscountPercentage > 0  and Isverified=1 and Ispackage=0"));
                amountBilled = amountBilled - totalDisc;

                if (Util.GetDecimal(txtSerTaxBillAmount.Text.Trim()) != amountBilled)
                    serTaxBillAmt = Util.GetDecimal(txtSerTaxBillAmount.Text.Trim());
                else
                    serTaxBillAmt = amountBilled;

                serviceTaxPer = Util.GetDecimal(txtServiceChg.Text.Trim());
                surchargePer = Util.GetDecimal(txtSurchg.Text.Trim());


                serviceTaxAmt = Util.GetDecimal(Math.Round(Util.GetDouble((serTaxBillAmt * serviceTaxPer) / 100)));
                amtAftServiceAmt = amountBilled + serviceTaxAmt;

                surchargeTaxAmt = Util.GetDecimal(Math.Round(Util.GetDouble((serviceTaxAmt * surchargePer) / 100)));

                netBillAmt = amtAftServiceAmt + surchargeTaxAmt;
            }


            BillNo = UpdateBillingInfo(BillNo, BillDate, netBillAmt, TransactionID, ViewState["USERID"].ToString(), serviceTaxAmt, serviceTaxPer, surchargeTaxAmt, surchargePer, serTaxBillAmt);

            if (BillNo != "")
            {
                //UpdatePanelSchemeAmount(lblPatientID.Text.Trim(), AmountBilled);

                lblMsg.Text = "Final Bill is Generated having Bill No :: " + BillNo;
                btnGenerateBill.Enabled = false;
                btnSaveFinalBill.Enabled = false;
                btnCancelItem.Enabled = false;
                //btnFinalDiscount.Enabled = false;
                btnSaveItem.Enabled = false;

                ScriptManager.RegisterStartupScript(this, this.GetType(), "ak1", "alert('Final Bill is generated having Bill No :: " + BillNo + "');", true);
            }
            else
            {
                lblMsg.Text = "Bill Has Not Been Generated";
            }

        }
    }

    protected void btnUpdatePolicy_Click(object sender, EventArgs e)
    {
        if (txtPolicyNo.Text.Trim() == "")
        {
            lblErr.Text = "Please Put Patient Policy No.";
            txtPolicyNo.Focus();
            mpePolicy.Show();
            return;
        }

        if (txtCardNo.Text.Trim() == "")
        {
            lblErr.Text = "Please Enter Patient Card No.";
            txtCardNo.Focus();
            mpePolicy.Show();
            return;
        }
        if (txtEmpID.Text.Trim() == "")
        {
            lblErr.Text = "Please Enter StaffID";
            txtEmpID.Focus();
            mpePolicy.Show();
            return;
        }

        if (txtFileNo.Text == "")
        {
            lblErr.Text = "Please Enter Patient File No.";
            txtFileNo.Focus();
            mpePolicy.Show();
            return;
        }
        if (txtCHName.Text == "")
        {
            lblErr.Text = "Please Enter Patient Card Holder Name";
            txtCHName.Focus();
            mpePolicy.Show();
            return;
        }
        if (ddlHolder_Relation.SelectedIndex == 0)
        {
            lblErr.Text = "Please Select Patient Card Holder Relation";
            ddlHolder_Relation.Focus();
            mpePolicy.Show();
            return;
        }
        lblErr.Text = "";
        string TID = ViewState["TransactionID"].ToString();
        string str = "Update Patient_Medical_History Set PolicyNo='" + txtPolicyNo.Text.Trim() + "',CardNo='" + txtCardNo.Text.Trim() + "',Employee_ID='" + txtEmpID.Text.Trim() + "',FileNo='" + txtFileNo.Text + "',CardHolderName='" + txtCHName.Text + "',RelationWith_holder='" + ddlHolder_Relation.SelectedItem.Text + "' Where TransactionID='" + TID + "'";
        StockReports.ExecuteDML(str);
        lblMsg.Text = "Record Updated. You Can Now Generate Bill";

    }
    protected void grdBasket_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblIsDiscountable")).Text.ToString().Trim() == "0")
            {
                e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#FF99CC");
            }

            else
            {
                e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#99FFCC");
            }
        }
    }
    protected void btnDocUpdate_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        string transactionID = ViewState["TransactionID"].ToString();
        string reasonNotGiven = "0";
        try
        {
            foreach (GridViewRow grv in grdPanelDocs.Rows)
            {
                string reason = ((TextBox)grv.FindControl("txtReason")).Text;
                if (reason == "")
                {
                    tnx.Rollback();
                    con.Close();
                    con.Dispose();

                    lblMsg.Text = "Put Reason of Ignorance";
                    reasonNotGiven = "0";
                    mpeDocs.Show();
                    ToolkitScriptManager1.SetFocus(((TextBox)grv.FindControl("txtReason")));
                    return;
                }
                else
                {
                    string panelDocumentID = ((Label)grv.FindControl("lblPanelDocumentID")).Text;
                    string str = "Update f_paneldocument_patient ";
                    str += "Set ReasonOfIgnore = '" + reason + "', ";
                    str += "IgnoredBy = '" + Util.GetString(Session["ID"]) + "', ";
                    str += "IgnoredDatetime = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "' ";
                    str += "Where TransactionID='" + transactionID + "' and PanelDocumentID = " + panelDocumentID + "";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
                    reasonNotGiven = "1";
                }
            }
            if (reasonNotGiven == "1")
            {
                tnx.Commit();
                con.Close();
                con.Dispose();
                btnGenerateBill_Click(sender, e);
            }
            else
            {
                tnx.Commit();

            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            throw (ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
    protected void LinkButton1_Click(object sender, EventArgs e)
    {
        Response.Redirect("../IPD/PatientPanelDocuments.aspx?TransactionID=" + ViewState["TransactionID"].ToString(), false);
    }
}
