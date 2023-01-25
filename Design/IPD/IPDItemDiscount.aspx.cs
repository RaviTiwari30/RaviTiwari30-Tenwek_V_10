using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Web.Services;

public partial class Design_IPD_IPDItemDiscount : System.Web.UI.Page
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
            string strDiscReason = "select ID,DiscountReason from discount_reason where Active=1 AND Type='IPD'";
            DataTable DiscountReason = StockReports.GetDataTable(strDiscReason);
            ddlControlDiscountReason.DataTextField = "DiscountReason";
            ddlControlDiscountReason.DataValueField = "ID";
            ddlControlDiscountReason.DataSource = DiscountReason;
            ddlControlDiscountReason.DataBind();
            ddlControlDiscountReason.Items.Insert(0, "--Please Select Reason--");

            ViewState["ID"] = Session["ID"].ToString();
            ViewState["LoginName"] = Session["LoginName"].ToString();
            string TransactionID = "";

            txtSurchg.Attributes.Add("readOnly", "readOnly");

            if (Session["ID"] == null)
            {
                Response.Redirect("~/Default.aspx");
            }
            else
            {
                ViewState.Add("USERID", Session["ID"].ToString());
            }

            if (Request.QueryString["TransactionID"] != null)
            {
                TransactionID = Request.QueryString["TransactionID"].ToString();
            }
            else if (Request.QueryString["TID"] != null)
            {
                TransactionID = Request.QueryString["TID"].ToString();
            }
            ViewState["TID"] = TransactionID;
            AllQuery AQ = new AllQuery();
            DataTable dt = AQ.GetPatientAdjustmentDetails(TransactionID);
            DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(Session["RoleID"]), Util.GetString(Session["ID"]));
            ViewState["Authority"] = dtAuthority;
            if (dt != null && dt.Rows.Count > 0)
            {
                if (dt.Rows[0]["IsBillFreezed"].ToString() == "1")
                {
                    DataTable dtAuthoritys = (DataTable)ViewState["Authority"];
                    if ((dt.Rows[0]["IsBillFreezed"].ToString() == "1") && (dtAuthoritys != null && dtAuthoritys.Rows.Count > 0))
                    {
                        string Msg = "";
                        int auth = AllLoadData_IPD.IPDBillAuthorization(Session["ID"].ToString(), Util.GetInt(Session["RoleID"].ToString()));
                        if (dtAuthoritys.Rows[0]["BillChange"].ToString() == "0" && auth == 0)
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
                    else if (dt.Rows[0]["IsBillFreezed"].ToString().Trim() == "1" && (dtAuthoritys != null && dtAuthoritys.Rows.Count == 0))
                    {
                        string Msg = "";
                        Msg = "You Are Not Authorised To AMEND This IPD Bills...";
                        Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
                    }
                }
            }



            lblPanelID.Text = dt.Rows[0]["PanelID"].ToString().Trim();
            ViewState["PanelID"] = dt.Rows[0]["PanelID"].ToString().Trim();
            DataTable panelCurrencyDetails = StockReports.GetDataTable("SELECT pm.RateCurrencyCountryID,cm.Selling_Specific,pm.PanelID,cm.S_Currency FROM converson_master cm INNER JOIN  f_panel_master pm ON cm.S_CountryID = pm.RateCurrencyCountryID WHERE pm.PanelID=" + lblPanelID.Text + " ORDER BY id DESC LIMIT 1");
            if (panelCurrencyDetails.Rows.Count > 0)
            {
                lblPanelRateCurrency.Text = panelCurrencyDetails.Rows[0]["S_Currency"].ToString();
                lblPanelRateCurrencyCountryID.Text = panelCurrencyDetails.Rows[0]["RateCurrencyCountryID"].ToString();
                txtPanelCurrencyFactor.Text = panelCurrencyDetails.Rows[0]["Selling_Specific"].ToString();
            }


            ds = new DataSet();

            ds.Tables.Add(IPDBilling.GetBilledPatientDetail(TransactionID).Copy());
            ds.Tables[0].TableName = "dtBilled";
            DataTable dtBilledDetail = IPDBilling.GetBilledPatientItemDetailDiscount(TransactionID).Copy();

            ds.Tables.Add(dtBilledDetail);
            ds.Tables[1].TableName = "dtBilledDetail";

            ViewState.Add("ds", ds);
            ViewState.Add("TransactionID", TransactionID);
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

            decimal AmountBilled = Util.GetDecimal(AQ.GetBillAmount(TransactionID.ToString(), null));
            decimal TotalDisc = Util.GetDecimal(StockReports.ExecuteScalar("Select IFNULL(SUM(TotalDiscAmt) + (SELECT IFNULL(DiscountOnBill,0) from patient_medical_history where TransactionID='" + TransactionID + "'),0) TotalDisc from f_ledgertnxdetail where TransactionID='" + TransactionID + "'  and isverified=1 and ispackage=0"));//f_ipdadjustment
            AmountBilled = AmountBilled - TotalDisc;
            txtSerTaxBillAmount.Text = Util.GetDecimal(Math.Round((AmountBilled), 2)).ToString();
            Panel2.Visible = false;
            GetBillDetails();
            txtServiceChg.Text = Util.GetDecimal(All_LoadData.GovTaxPer()).ToString();
            decimal ServiceTaxAmt = Util.GetDecimal(Math.Round(Util.GetDecimal((Util.GetDecimal(txtSerTaxBillAmount.Text) * Util.GetDecimal(txtServiceChg.Text)) / 100), 2, System.MidpointRounding.AwayFromZero));
            txtTotalTaxAmt.Text = Util.GetDecimal(Math.Round((ServiceTaxAmt), 2, MidpointRounding.AwayFromZero)).ToString();
            decimal TotalAmt = AmountBilled + ServiceTaxAmt;
            txtNetBillAmt.Text = Util.GetDecimal(Math.Round((TotalAmt), MidpointRounding.AwayFromZero)).ToString();
            decimal RoundOff = Math.Round((Util.GetDecimal(lblNetBillAmt.Text) - Util.GetDecimal(lblNetAmount.Text)), 2, MidpointRounding.AwayFromZero);
            txtRoundOff.Text = Util.GetDecimal(Math.Round((RoundOff), 2, MidpointRounding.AwayFromZero)).ToString();
            int bi = AllLoadData_IPD.IPDBillAuthorization(Session["ID"].ToString(), Util.GetInt(Session["RoleID"].ToString()));
            if (bi == 0)
                btnGenerateBill.Enabled = false;

        }
        lblCurreny_Amount.Text = txtNetBillAmt.Text;


        LoadCurrencyDetail();

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
        DataTable dtPanelBillCurrency = StockReports.GetDataTable("SELECT IF((IFNULL(f.BillCurrencyCountryID,'')='' OR f.BillCurrencyCountryID=0),1,IF((f.BillCurrencyCountryID=(SELECT c.CountryID FROM country_master c WHERE c.IsBaseCurrency=1 LIMIT 1)),1,f.BillCurrencyConversion)) BillCurrencyFactor,IF((IFNULL(f.BillCurrencyCountryID,'')='' OR f.BillCurrencyCountryID=0),(SELECT c.CountryID FROM country_master c WHERE c.IsBaseCurrency=1 LIMIT 1), f.BillCurrencyCountryID)BillCurrencyCountryID,IF((IFNULL(f.BillCurrencyCountryID,'')='' OR f.BillCurrencyCountryID=0),(SELECT c.Notation FROM country_master c WHERE c.IsBaseCurrency=1 LIMIT 1) ,f.BillCurrencyNotation)BillCurrencyNotation FROM f_panel_master f WHERE f.PanelID=" + Util.GetInt(ViewState["PanelID"]) + "");
        // DataTable dtPanelBillCurrency = StockReports.GetDataTable("SELECT IF((f.BillCurrencyCountryID=(SELECT c.CountryID FROM country_master c WHERE c.IsBaseCurrency=1 LIMIT 1)),1,f.BillCurrencyConversion) BillCurrencyFactor,f.BillCurrencyCountryID,f.BillCurrencyNotation FROM f_panel_master f WHERE f.PanelID=" + Util.GetInt("9") + "");

        //  DataRow[] dr = dtDetail.Select("IsBaseCurrency=1");

        DataRow[] dr = dtDetail.Select("CountryID=" + Util.GetInt(dtPanelBillCurrency.Rows[0]["BillCurrencyCountryID"].ToString()) + "");
        dr[0]["Selling_Specific"] = Util.GetDecimal(dtPanelBillCurrency.Rows[0]["BillCurrencyFactor"].ToString());

        ddlCurrency.SelectedIndex = ddlCurrency.Items.IndexOf(ddlCurrency.Items.FindByValue(dr[0]["CountryID"].ToString()));
        lblCurrencyNotation.Text = dr[0]["Notation"].ToString();

        lblBillCurrency.Text = txtBillCurrency.Text = dr[0]["Currency"].ToString();
        lblBillCountryId.Text = txtBillCountryId.Text = dr[0]["CountryID"].ToString();
        lblBillNotation.Text = txtBillNotation.Text = dr[0]["S_Notation"].ToString();
        lblBillConFactor.Text = txtBillConFactor.Text = dr[0]["Selling_Specific"].ToString();
        lblCurreny_Amount.Text = txtCurreny_Amount.Text = Util.GetString(Math.Round((Util.GetDecimal(lblCurreny_Amount.Text) / Util.GetDecimal(dr[0]["Selling_Specific"].ToString())), 6));
        ddlCurrency.Enabled = false;

        // ScriptManager.RegisterStartupScript(this, this.GetType(), "dev1","CurrencyChange();", true);
    }

    [WebMethod]
    public static string BindCurrencyDetails(string countryID)
    {
        DataTable BillCurrencyDetails = StockReports.GetDataTable("SELECT cm.Selling_Specific,cm.S_Currency,cm.S_Notation,cm.S_CountryID FROM converson_master cm where cm.S_CountryID=" + countryID + " ORDER BY id DESC LIMIT 1");
        return Newtonsoft.Json.JsonConvert.SerializeObject(BillCurrencyDetails);
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
        sb.Append(" LTD.SurgeryName,LTD.DiscountReason,EM.Name AS UserName FROM f_ledgertnxdetail LTD   ");
        sb.Append(" INNER JOIN f_ledgertransaction LT ON  LT.LedgerTransactionNo = LTD.LedgerTransactionNo   ");
        sb.Append(" INNER JOIN f_subcategorymaster SC ON SC.SubcategoryID = LTD.SubcategoryID       ");
        sb.Append(" LEFT JOIN employee_master EM ON EM.Employee_ID = LTD.DiscUserID    ");
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
            int SubCategoryIDd = 0;

            //DataRow[] drDisplay = dt.Select("DisplayName <>''  and IsVerified =" + IsVerified + " and IsPackage=" + IsPackage + " and IsSurgery=" + IsSurgery);
            DataRow[] drDisplay = dt.Select("DisplayName <>''  and IsVerified =" + IsVerified);
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
                        NewRow["SubCategoryID"] = SubCategoryIDd;
                        NewRow["VerifiedFlag"] = IsVerified;
                        NewRow["TransactionID"] = dr["TransactionID"].ToString();
                        NewRow["DisplayName"] = dr["DisplayName"].ToString();
                        NewRow["GrossAmt"] = Math.Round(GrossAmt, 2);
                        NewRow["ItemWiseDisc"] = Math.Round(ItemWiseDisc, 2);
                        if (Util.GetString(dr["IsDiscountable"]).ToString() == "")
                            NewRow["IsDiscountable"] = 0;
                        else
                            NewRow["IsDiscountable"] = dr["IsDiscountable"].ToString();
                        NewRow["UserName"] = UserName;
                        NewRow["DiscountReason"] = DiscountReason;
                        dtReturn.Rows.Add(NewRow);
                    }
                }
            }

            //DataRow[] drSubCategory = dt.Select("IsNull(DisplayName,'')=''  and IsVerified =" + IsVerified + " and IsPackage=" + IsPackage + " and IsSurgery=" + IsSurgery);
            DataRow[] drSubCategory = dt.Select("IsNull(DisplayName,'')=''  and IsVerified =" + IsVerified);
            if (drSubCategory.Length > 0)
            {
                Decimal NetAmount = 0.0m;
                decimal Quantity = 0;
                decimal GrossAmt = 0, ItemWiseDisc = 0;

                foreach (DataRow dr in drSubCategory)
                {
                    if (dr["SubCategoryID"].ToString() != SubCategoryID)
                    {
                        SubCategoryID = dr["SubCategoryID"].ToString();
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
                        // NewRow["IsDiscountable"] = dr["IsDiscountable"].ToString();
                        if (Util.GetString(dr["IsDiscountable"]).ToString() == "")
                            NewRow["IsDiscountable"] = 0;
                        else
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
                txtDisAmount.Enabled = true;
                txtDisPercent.Enabled = true;
                btnSaveItem.Enabled = true;
            }
        }
        else
        {
            txtDisAmount.Enabled = false;
            txtDisPercent.Enabled = false;
            btnSaveItem.Enabled = false;
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
            DataTable dtSave = ds.Tables["dtBilledDetail"].Clone();
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
            bool IsUpdated = IPDBilling.UpdateVerifiedItems(dtSave, txtDisReason.Text.Trim(), UserID, ddlApproveBy.SelectedItem.Value);

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
            // shatrughan 18.07.13
            //sbBill.Append(" SELECT ROUND((t2.NetAmt+t2.TDiscount),2)GrossAmt,ROUND(t2.TDiscount,2)TotalDiscount,ROUND(t2.NetAmt,2)NetAmt, ");
            //sbBill.Append(" ROUND(t3.RecAmt,2)RecAmt,t2.DiscountOnBill,t2.TotalItemWiseDiscount FROM (SELECT ltd.TransactionID, ");
            //sbBill.Append(" SUM(Amount)NetAmt,IFNULL(ipd.DiscountOnBill,0)DiscountOnBill, ");
            //sbBill.Append(" IFNULL(ROUND(SUM(((ltd.Rate*ltd.Quantity)*ltd.DiscountPercentage)/100)+ IFNULL(ipd.DiscountOnBill,0),2),0)TDiscount, ");
            //sbBill.Append(" IFNULL(ROUND(SUM(((ltd.Rate*ltd.Quantity)*ltd.DiscountPercentage)/100),2),0)TotalItemWiseDiscount, ");
            //sbBill.Append(" im.Type_ID,im.ServiceItemID FROM f_ledgertnxdetail ltd INNER JOIN f_ledgertransaction LT ON ");
            //sbBill.Append(" ltd.LedgerTransactionNo = LT.LedgerTransactionNo     ");
            //sbBill.Append(" INNER JOIN f_ipdadjustment ipd ON ipd.TransactionID=lt.TransactionID       ");
            //sbBill.Append(" INNER JOIN f_itemmaster im ON ltd.ItemID = im.ItemID  WHERE Lt.IsCancel = 0 AND ltd.IsFree = 0 AND ltd.IsVerified = 1       ");
            //sbBill.Append(" AND ltd.IsPackage = 0     AND lt.TransactionID = '" + TransID + "'           ");
            //sbBill.Append("  GROUP BY lt.TransactionID )T2  LEFT JOIN ( ");
            //sbBill.Append("   SELECT TransactionID,SUM(AmountPaid)RecAmt FROM f_reciept WHERE IsCancel = 0   AND TransactionID = '"+TransID+"'  ");
            //sbBill.Append("   GROUP BY TransactionID ");
            //sbBill.Append("  )T3 ");
            //sbBill.Append("  ON T2.TransactionID = T3.TransactionID ");
            // shatrughan 18.07.13

            sbBill.Append("Select Round(t2.GrossAmt,2)GrossAmt,Round(GrossAmt-TotalDiscount,2)NetAmt,");
            sbBill.Append("Round(t2.TotalDiscount,2)TotalDiscount,ROUND(IFNULL(t3.RecAmt,0.00),2)RecAmt,PanelApprovedAmt,t2.TotalItemWiseDiscount,TotalDeduction FROM ( ");
            sbBill.Append("     select ltd.TransactionID,sum(ltd.GrossAmount)GrossAmt,0 NetAmount, ");
            sbBill.Append("     IFNULL(ROUND(SUM(ltd.TotalDiscAmt)+IFNULL(pmh.DiscountOnBill,0),2),0)TotalDiscount ");
            sbBill.Append("   ,IFNULL(ROUND(SUM(ltd.TotalDiscAmt),2),0)TotalItemWiseDiscount,im.Type_ID,im.ServiceItemID, ");
            sbBill.Append("     IFNULL(pmh.PanelApprovedAmt,0)PanelApprovedAmt,(IFNULL(pmh.Deduction_Acceptable,'0')+IFNULL(pmh.TDS,'0')+IFNULL(pmh.WriteOff,'0'))TotalDeduction  From f_ledgertnxdetail ltd ");
            sbBill.Append("     inner join f_ledgertransaction LT on ltd.LedgerTransactionNo = LT.LedgerTransactionNo");
            //sbBill.Append("     INNER JOIN f_ipdadjustment ipd ON ipd.TransactionID=lt.TransactionID ");
            sbBill.Append("     INNER JOIN f_itemmaster im ON ltd.ItemID = im.ItemID ");
            sbBill.Append("     INNER JOIN Patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID ");
            sbBill.Append("     WHERE Lt.IsCancel = 0 and ltd.IsFree = 0 and ltd.IsVerified = 1 ");
            sbBill.Append("     and ltd.IsPackage = 0");
            sbBill.Append("     and lt.TransactionID = '" + TransID + "' ");
            sbBill.Append("     group by lt.TransactionID ");
            sbBill.Append(")T2  Left join (");
            sbBill.Append("     select TransactionID,Round(sum(AmountPaid))RecAmt from f_reciept where IsCancel = 0 ");
            sbBill.Append("     and TransactionID = '" + TransID + "' ");
            sbBill.Append("      group by TransactionID ");
            sbBill.Append(")T3 on T2.TransactionID = T3.TransactionID");
            DataTable dtBill = new DataTable();
            dtBill = StockReports.GetDataTable(sbBill.ToString());

            if (dtBill.Rows.Count > 0)
            {
                lblGrossBillAmt.Text = Util.GetDecimal(dtBill.Rows[0]["GrossAmt"]).ToString();
                lblBillDiscount.Text = Util.GetDecimal(dtBill.Rows[0]["TotalDiscount"]).ToString();
                lblNetAmount.Text = Util.GetDecimal(dtBill.Rows[0]["NetAmt"]).ToString();
                lblAdvanceAmt.Text = Util.GetDecimal(dtBill.Rows[0]["RecAmt"]).ToString();
                //  lblBalanceAmt.Text = Util.GetDecimal(Util.GetDecimal(dtBill.Rows[0]["NetAmt"]) - Util.GetDecimal(dtBill.Rows[0]["RecAmt"])).ToString();
                //lblDiscOnBill.Text = Util.GetDecimal(dtBill.Rows[0]["TotalDiscount"]).ToString();
                lblDiscOnBill.Text = (Util.GetDecimal(dtBill.Rows[0]["TotalDiscount"]) - Util.GetDecimal(dtBill.Rows[0]["TotalItemWiseDiscount"])).ToString();
                lblDiscItem.Text = Util.GetDecimal(dtBill.Rows[0]["TotalItemWiseDiscount"]).ToString();
                lblDeduction.Text = Util.GetDecimal(dtBill.Rows[0]["TotalDeduction"]).ToString();
                txtCurreny_Amount.Text = lblNetAmount.Text;
                lblTaxPer.Text = Util.GetDecimal(All_LoadData.GovTaxPer()).ToString();
                lblTotalTax.Text = Util.GetDecimal(Math.Round(Util.GetDecimal((Util.GetDecimal(lblNetAmount.Text) * Util.GetDecimal(lblTaxPer.Text)) / 100), 2, System.MidpointRounding.AwayFromZero)).ToString();
                decimal TotalAmt = Util.GetDecimal(lblNetAmount.Text) + Util.GetDecimal(lblTotalTax.Text);
                lblNetBillAmt.Text = Util.GetDecimal(Math.Round(TotalAmt, 0, MidpointRounding.AwayFromZero)).ToString();
                decimal RoundOff = Math.Round((Util.GetDecimal(lblNetBillAmt.Text) - Util.GetDecimal(lblNetAmount.Text)), 2, MidpointRounding.AwayFromZero);
                lblRoundOff.Text = Util.GetDecimal(Math.Round((RoundOff), 2, MidpointRounding.AwayFromZero)).ToString();
                decimal BalanceAmt = Util.GetDecimal(lblNetBillAmt.Text) - (Util.GetDecimal(lblAdvanceAmt.Text) + Util.GetDecimal(lblDeduction.Text) + RoundOff);
                lblBalanceAmt.Text = Util.GetDecimal(BalanceAmt).ToString();
            }
            else
                lblMsg.Text = "No Billing Info Found";
        }
    }
    private void BindApprovalType()
    {
        All_LoadData.bindApprovalType(ddlApproveBy);
        All_LoadData.bindApprovalType(ddlApproveBy1);
    }

    protected void btnFinalDiscount_Click(object sender, EventArgs e)
    {
        try
        {
            //if (AllLoadData_IPD.CheckDataPostToFinance(ViewState["TID"].ToString()) > 0)
            //{
            //    string Msga = "Patient's Final Bill Already Posted To Finance...";
            //    Response.Redirect("PatientBillMsg.aspx?msg=" + Msga);
            //}

            Panel2.Visible = true;
            DataTable Authority = (DataTable)ViewState["Authority"];
            if (Authority.Rows.Count > 0)
            {
                if (Authority.Rows[0]["IsDiscount"].ToString() == "1")
                {
                    txtDisAmount1.Enabled = true;
                    txtDisPercent1.Enabled = true;
                    btnSaveFinalBill.Enabled = true;
                }
            }
            else
            {
                txtDisAmount1.Enabled = false;
                txtDisPercent1.Enabled = false;
                btnSaveFinalBill.Enabled = false;
            }

            FillPatientInfo(ViewState["TID"].ToString());
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
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('" + lblMsg.Text + "');", true);
            return;
        }

        decimal totalAllocatedAmount = Util.GetDecimal(StockReports.ExecuteScalar("SELECT SUM(am.Amount)allocatedAmount FROM panel_amountallocation am INNER JOIN f_panel_master pm  ON pm.PanelID=am.PanelID WHERE am.TransactionID='" + ViewState["TID"].ToString() + "' "));
        if (DisAmount > (BillAmount - totalAllocatedAmount))
        {
            lblMsg.Text = "Discount Can Not Be given untill panel allocation is updated, please check.";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('" + lblMsg.Text + "');", true);
            return;
        }


        if (DisAmount > 0 && ddlApproveBy1.SelectedItem.Text.ToUpper() == "SELECT")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM08','" + lblMsg.ClientID + "');", true);
            return;
        }
        if (DisAmount > 0 && ddlControlDiscountReason.SelectedIndex == 0)
        {
            lblMsg.Text = "Please Select Discount Reason.";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('" + lblMsg.Text + "', function () { });", true);
            return;
        }
        result = IpdBillAdjustment.updateAdjustmentDisc(DisAmount, ddlControlDiscountReason.SelectedItem.Text.Trim(), 0, "", ViewState["TID"].ToString(), ApprovalBy, lblBillAmount.Text.Trim(), ViewState["ID"].ToString(), Util.round(DisPercent));

        if (result)
        {
            Clear();
            lblMsg.Text = "Billing information updated";
            Panel2.Visible = false;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "location.href='IPDItemDiscount.aspx?TID=" + ViewState["TID"].ToString() + "';", true);

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
            // if (Session["LoginType"].ToString() == "EDP" || dt.Rows[0]["BillNo"].ToString().Trim() == "")
            // {
            UpdateBilling();
            GetItemDiscount();
            lblPatientID.Text = Util.GetString(dt.Rows[0]["PatientID"]);
            lblDiscountPercent.Text = Math.Round(Util.GetDecimal((Util.GetDecimal(lblDisAlreadygiven.Text.Trim()) / Util.GetDecimal(lblBillAmount.Text.Trim())) * 100)).ToString();
            lblBillAfterDiscount.Text = Util.GetString(Util.GetDecimal(lblBillAmount.Text.Trim()) - Util.GetDecimal(lblDisAlreadygiven.Text.Trim()));
            decimal TotalLedgerAmount = GetTotalLedgerAmount(PTransID);

            if ((Util.GetDecimal(dt.Rows[0]["DiscountOnBill"]) > 0 || Util.GetDecimal(dt.Rows[0]["AdjustmentAmt"]) != 0))
            {
                decimal DiscountOnBill = Util.GetDecimal(dt.Rows[0]["DiscountOnBill"].ToString());
                decimal TotalBilled = Util.GetDecimal(dt.Rows[0]["TotalBilledAmt"].ToString());
                decimal AdjAmount = Util.GetDecimal(dt.Rows[0]["AdjustmentAmt"].ToString());
                decimal ItemDiscount = Util.GetDecimal(lblDisAlreadygiven.Text.Trim());
                txtDisAmount1.Text = dt.Rows[0]["DiscountOnBill"].ToString();
                ddlControlDiscountReason.SelectedValue = ddlControlDiscountReason.Items.FindByText(dt.Rows[0]["DiscountOnBillReason"].ToString()).Value;
                lblBillAfterDiscount.Text = Util.GetString(Util.GetDecimal(lblBillAmount.Text.Trim()) - Util.GetDecimal(DiscountOnBill));
                btnSaveFinalBill.Text = "Update";
            }

            lblSettAmt.Text = Util.GetDecimal(Math.Round((Util.GetDecimal(lblBillAfterDiscount.Text) - Util.GetDecimal(((Util.GetDecimal(lblPaidAmount.Text) * Util.GetDecimal(100)) / Util.GetDecimal((Util.GetDecimal(100) + Util.GetDecimal(txtServiceChg.Text)))))), 2, MidpointRounding.AwayFromZero)).ToString();
            if (Session["LoginType"].ToString() == "EDP")
            {
                txtDisAmount1.ReadOnly = true;
                txtDisPercent1.ReadOnly = true;
            }
        }
    }

    private decimal GetTotalLedgerAmount(string TransID)
    {
        string str = "select GrossAmount As TotalAmount from f_ledgertnxdetail"
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
        DataTable dt = AllLoadData_IPD.getIPDTotalDiscount(ViewState["TID"].ToString());
        if (dt.Rows.Count > 0)
        {
            lblDisAlreadygiven.Text = Util.round(Util.GetDecimal(dt.Rows[0]["TotalDisc"].ToString())).ToString("f2");
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
            Decimal AmountReceived = Util.GetDecimal(AQ.GetPaidAmount(ViewState["TID"].ToString()));
            Decimal AmountBilled = Util.GetDecimal(AQ.GetBillAmount(ViewState["TID"].ToString(), null));
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
        lblMsg.Text = "";
        string TransactionID = ViewState["TID"].ToString();
        string PanelID = AllLoadData_IPD.getPatientPanelID(TransactionID, con);
        try
        {
            //int medClear = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(stockid)  FROM f_ledgertnxdetail WHERE TransactionID='" + TransactionID + "' AND stockid!='' AND IsVerified=1"));
            //int IsMedClear = 1;
            //int IsMedClear = Util.GetInt(StockReports.ExecuteScalar("Select IsMedCleared from f_ipdadjustment where TransactionID='" + TransactionID + "'"));
            //if (medClear > 0)
            //{
            //    if (IsMedClear != 1)
            //    {
            //        lblMsg.Text = "Please Get Medicine Clearance Before Generating Bill";
            //        return;
            //    }
            //}
            decimal BillAmount = Util.round(Util.GetDecimal(StockReports.ExecuteScalar("SELECT SUM(amount)-(SELECT IFNULL(DiscountOnBill,0) FROM patient_medical_history WHERE TransactionID='" + TransactionID.Trim() + "') FROM f_ledgertnxdetail WHERE TransactionID='" + TransactionID.Trim() + "' AND IsVerified=1 AND IsPackage=0 group by TransactionID")));//f_ipdadjustment
            decimal PanelAmountAllocation = Util.round(AllLoadData_IPD.GetAllocationAmount(TransactionID.Trim()));
            decimal PaidAmt = Util.round(Util.GetDecimal(AllLoadData_IPD.getPatientPaidAmount(TransactionID.Trim())));
            decimal WriteOff = Util.round(Util.GetDecimal(AllLoadData_IPD.getPatientWrieoffAmount(TransactionID.Trim())));
            decimal checkamount = Math.Round(BillAmount - (PanelAmountAllocation + PaidAmt+WriteOff));
            decimal NonPayableAmount = Util.round(Util.GetDecimal(AllLoadData_IPD.getIPDNonPayableAmt(TransactionID.Trim())));
            int IsClearance = Util.GetInt(StockReports.ExecuteScalar(" Select IsClearance FROM patient_medical_history WHERE  TransactionID = '" + TransactionID.Trim() + "' and Type='IPD' "));
            //if (checkamount > 0)
            //{
            //    lblMsg.Text = "Please check payment/allocation amount as there is an outstanding amount :" + checkamount;
            //    return;
            //}
            if (BillAmount != (PanelAmountAllocation + PaidAmt + WriteOff))
            {
                if (Util.GetInt(PanelID)!=1)
                {
                    if (IsClearance == 0)
                    {
                        if (BillAmount > (PanelAmountAllocation + PaidAmt+WriteOff))
                        {
                            lblMsg.Text = "Bill Amount Is Greter Then Allocation amount and Patient Paid amount.";
                            return;
                        }
                        else
                        {
                            if (BillAmount < PanelAmountAllocation+WriteOff)
                            {
                                lblMsg.Text = "Allocation + writeoff amount is greater then Bill Amount.";
                                return;
                            }
                            else if (BillAmount < PanelAmountAllocation + PaidAmt + WriteOff)
                            {
                                lblMsg.Text = "Bill Amount Is Smaller Then Allocated and Patient Paid Amount.";
                                return;

                            }

                        }
                    }
                }
                else
                {
                    if (BillAmount > (PanelAmountAllocation + PaidAmt))
                    {
                        
                        if (IsClearance == 0)
                        {
                            lblMsg.Text = "Bill Amount Is Greater Then Allocated and Patient Paid Amount.";
                            return;
                        }
                    }
                    
                }
               
            }
            

            if (rdbBillType.SelectedIndex == -1)
            {
                lblMsg.Text = "Please Select Billing Type";
                return;
            }

            string IsItemsGivenInPkg = Util.GetString(StockReports.ExecuteScalar("SELECT ltd.* FROM f_ledgertnxdetail ltd INNER JOIN f_subcategorymaster sc ON ltd.SubCategoryID = sc.SubCategoryID INNER JOIN f_configrelation cf ON sc.CategoryID = cf.CategoryID WHERE ltd.IsVerified=1 AND cf.ConfigID=14 and ltd.TransactionID='" + TransactionID + "'"));

            if (IsItemsGivenInPkg != string.Empty)
            {
                IsItemsGivenInPkg = "";
                IsItemsGivenInPkg = Util.GetString(StockReports.ExecuteScalar("Select * from f_ledgertnxDetail where TransactionID='" + TransactionID + "' and isverified=1 and IsPackage=1 "));

                if (IsItemsGivenInPkg == string.Empty)
                {
                    lblMsg.Text = "Patient has some Package Given But there is no Item in the Package...";
                    return;
                }
            }


            bool Istrue = false;
            if (rdbBillType.SelectedValue == "1")
            {
                Istrue = Util.GetBoolean(MySqlHelper.ExecuteScalar(con, CommandType.Text, "Select if(IsPackage=1,'true','false')IsTrue  from f_ledgertnxDetail where TransactionID='" + TransactionID + "' and isverified=1 and IsPackage=1"));

                if (Istrue)
                {
                    lblMsg.Text = "Patient has some Package Given. The Billing Type should be either Package Bill or Mixed Bill.";
                    return;
                }
            }

            if (rdbBillType.SelectedValue == "2")
            {
                Istrue = Util.GetBoolean(MySqlHelper.ExecuteScalar(con, CommandType.Text, "Select if(IsPackage=1,'true','false')IsTrue  from f_ledgertnxDetail where TransactionID='" + TransactionID + "' and isverified=1 and IsPackage=1"));

                if (Istrue == false)
                {
                    lblMsg.Text = "Patient has some Package Given. The Billing Type should be either Package Bill or Mixed Bill.";
                    return;

                }
            }

            if (rdbBillType.SelectedValue == "3")
            {
                Istrue = Util.GetBoolean(MySqlHelper.ExecuteScalar(con, CommandType.Text, "Select if(IsPackage=1,'true','false')IsTrue  from f_ledgertnxDetail where TransactionID='" + TransactionID + "' and isverified=1 and IsPackage=1"));

                if (Istrue == false)
                {
                    lblMsg.Text = "This seems to be Mixed package.Please Check and then Select Proper Billing Type";
                    return;
                }
            }


            //Checking if Patient has given package but no entry of surgery in the package then bill
            //should not be generated

            ////Istrue = false; //Checking if Package is given            
            ////Istrue = Util.GetBoolean(StockReports.ExecuteScalar("Select if(IsPackage=1,'true','false')IsTrue  from f_ledgertnxDetail where TransactionID='" + TransactionID + "' and isverified=1 and IsPackage=1"));

            ////if (Istrue)
            ////{
            ////    string IsExist = ""; //Checking if Major Surgery is given
            ////    IsExist = Util.GetString(StockReports.ExecuteScalar("Select * from f_ledgertnxDetail where TransactionID='" + TransactionID + "' and isverified=1 and IsPackage=1 and IsSurgery=1"));

            ////    if (IsExist==string.Empty)
            ////    {
            ////        //Checking if Minor Procedure is given
            ////        IsExist = Util.GetString(StockReports.ExecuteScalar("SELECT ltd.* FROM f_ledgertnxdetail ltd INNER JOIN f_subcategorymaster sc ON ltd.SubCategoryID = sc.SubCategoryID INNER JOIN f_configrelation cf ON sc.CategoryID = cf.CategoryID WHERE ltd.IsVerified=1 AND ltd.IsPackage=1 AND cf.ConfigID=25 and ltd.TransactionID='" + TransactionID + "'"));

            ////        if (IsExist == string.Empty)
            ////        {
            ////            lblMsg.Text = "Patient has some Package Given. There Must be either Major Surgery or Minor Procedure in the Package...";
            ////            return;
            ////        }
            ////    }
            ////}            

            AllQuery AQ = new AllQuery();

            DataTable dtDischarge = AQ.GetPatientDischargeStatus(TransactionID);

            if (dtDischarge != null && dtDischarge.Rows.Count > 0)
            {
                if (dtDischarge.Rows[0]["Status"].ToString().Trim().ToUpper() == "IN")
                {
                    string Msg = "Patient is Not Discharged yet. Bill cannot be generated right now";
                    lblMsg.Text = Msg;
                    return;
                }
            }

            DataTable dtF_ledgertnxdtl = MySqlHelper.ExecuteDataset(con, CommandType.Text, "Select (SELECT DisplayName FROM f_subcategorymaster where subcategoryID=ltd.subcategoryid)DisplayName,ltd.* from f_ledgertnxdetail ltd WHERE TransactionID='" + TransactionID + "' and rate=0 and isverified=1  and LedgerTnxRefID=-1 and Ispackage=0").Tables[0];
            //Check for PolicyNo, ClaimNo or StaffID if Not Given for Patient then Bill Cannot Be Generated
            if (dtF_ledgertnxdtl.Rows.Count > 0)
            {

                lblMsg.Text = "There are Items having ZERO Rates in Group :" + dtF_ledgertnxdtl.Rows[0]["DisplayName"].ToString() + ".Please Set Rates before Generating Bill";
                return;
            }



            //   DataTable dtCheck = StockReports.GetDataTable("Select * from patient_medical_history where TransactionID='" + TransactionID + "'");

            //    if (dtCheck.Rows[0]["PanelID"].ToString().Trim() != "1" && dtCheck.Rows[0]["PanelID"].ToString().Trim() != "2" && dtCheck.Rows[0]["PanelID"].ToString().Trim() != "3") // Not Equal To Cash Panel
            //    {


            //string cardNo = dtCheck.Rows[0]["CardNo"].ToString();
            //string policyNo = dtCheck.Rows[0]["PolicyNo"].ToString();
            //string employeeid = dtCheck.Rows[0]["Employee_id"].ToString();

            //txtPolicyNo.Text = policyNo;
            //txtEmpID.Text = employeeid;
            //txtCardNo.Text = cardNo;

            //if (cardNo == "" && policyNo == "" && employeeid == "")
            //{                                      
            //  mpePolicy.Show();
            //return;
            // }
            //   }


            //Panel Document Check

            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT pdd.PanelDocumentID,pdm.Document,IF(t.PanelDocumentID IS NULL,'false','true')STATUS, ");
            sb.Append("FilePath,FileName,if(IFNULL(FilePath,'')='','false','true')FileStatus FROM f_paneldocumentdetail pdd INNER JOIN ");
            sb.Append("f_paneldocumentMaster pdm ON pdd.DocumentID = pdm.DocumentID ");
            sb.Append("LEFT JOIN ( ");
            sb.Append("       SELECT PanelDocumentID,FilePath,FileName,reasonofIgnore FROM f_paneldocument_patient ");
            sb.Append("       WHERE TransactionID='" + TransactionID + "' AND IsActive=1 AND  reasonofIgnore='' ");
            sb.Append(")t ON pdd.PanelDocumentID = t.PanelDocumentID Where pdd.IsActive=1 ");
            sb.Append("and PanelID=" + PanelID + " and IFNULL(t.FileName,'')='' AND t.reasonofIgnore='' ");

            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];

            if (dt != null && dt.Rows.Count > 0)
            {
                grdPanelDocs.DataSource = dt;
                grdPanelDocs.DataBind();
                mpeDocs.Show();
                return;
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
            AllUpdate AU = new AllUpdate();

            int rowAffected = AU.UpdateDischargeStatusTobeBill(TransactionID, con);

            if (rowAffected == 0)
            {
                lblMsg.Text = "Bill cannot be generated";
                return;
            }

            BillDate = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");

            decimal serTaxBillAmt = 0, serviceTaxAmt = 0, amtAftServiceAmt = 0, surchargeTaxAmt = 0, netBillAmt = 0, serviceTaxPer = 0, surchargePer = 0;
            decimal sAmount = 0, cFactor = 0;
            int sCountryID = 0;
            string sNotation = "";
            decimal amountBilled = Util.GetDecimal(AQ.GetBillAmount(ViewState["TID"].ToString(), con));
            netBillAmt = amountBilled;

            //  DataTable dt = StockReports.GetDataTable("SELECT cnm.S_CountryID,cnm.S_Currency,cnm.S_Notation,cnm.B_Currency FROM country_master cm INNER JOIN converson_master cnm ON cm.CountryID = cnm.S_CountryID WHERE cm.IsActive=1 AND cm.IsBaseCurrency=1 ");
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
            //  decimal totalDisc = Util.GetDecimal(StockReports.ExecuteScalar("Select (IFNULL(sum((Rate*Quantity)-Amount),0) + (Select IFNULL(DiscountOnBill,0) from f_ipdadjustment where TransactionID='" + TransactionID + "')) TotalDisc from f_ledgertnxdetail where TransactionID='" + TransactionID + "' and DiscountPercentage > 0  and isVerified=1 and isPackage=0"));
            //   amountBilled = amountBilled - totalDisc;

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

            BillNo = IpdBillAdjustment.UpdateBillingInfo(BillNo, BillDate, netBillAmt, TransactionID, ViewState["USERID"].ToString(), serviceTaxAmt, serviceTaxPer, surchargeTaxAmt, surchargePer, serTaxBillAmt, Util.GetInt(rdbBillType.SelectedItem.Value), txtNarration.Text.Trim(), sCountryID, sAmount, sNotation, cFactor, Util.GetDecimal(txtRoundOff.Text), Util.GetInt(Session["CentreID"].ToString()), Util.GetInt(PanelID), con, tnx, Util.GetInt(txtBillCountryId.Text.Trim()), Util.GetString(txtBillNotation.Text.Trim()), Util.GetDecimal(txtBillConFactor.Text.Trim()));

            if (BillNo != "")
            {


               // ExcuteCMD excuteCMD = new ExcuteCMD();

                //doctor Share transaction update

                //excuteCMD.DML(tnx, "UPDATE f_DocShare_TransactionDetail s SET s.Transferdate=CURRENT_DATE() WHERE s.TransactionID=@transactionID", CommandType.Text, new
                //{
                //    transactionID = TransactionID
                //});

		
				
                //doctor Share transaction update

                string IPDNo = StockReports.getTransNobyTransactionID(TransactionID);
                lblMsg.Text = "Final Bill is generated having Bill No. : " + BillNo;
                btnGenerateBill.Enabled = false;
                btnSaveFinalBill.Enabled = false;
                btnCancelItem.Enabled = false;
                btnFinalDiscount.Enabled = false;
                btnSaveItem.Enabled = false;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "ak1", "alert('IPD No. : " + IPDNo + " is Closed for further editing.');", true);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "ak2", "location.href='PatientFinalMsg.aspx?TransactionID=" + TransactionID + "';", true);

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
    protected void cmbNarration_SelectedIndexChanged(object sender, EventArgs e)
    {
        txtNarration.Text = cmbNarration.SelectedItem.Value;
    }
    protected void btnSaveNarration_Click(object sender, EventArgs e)
    {

        string IsSave = CreateStockMaster.UpdateNarration(txtNarration.Text, ViewState["TID"].ToString());
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

    private void CheckPanelScheme(string TransactionID)
    {
        AllQuery AQ = new AllQuery();

        decimal AmountBilled = Util.GetDecimal(AQ.GetBillAmount(ViewState["TID"].ToString(), null));

        string str = "Select * from patient_panel_scheme where PatientID = (Select PatientID from patient_medical_history where TransactionID= '" + TransactionID + "')";
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
            string str = "Update patient_panel_scheme Set pnl.IPDDoneAmt = " + BillAmount + "  where PatientID='" + PatientID + "'";
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
            string TransactionID = ViewState["TID"].ToString();


            BillDate = Util.GetDateTime(ViewState["BillDate"]).ToString("yyyy-MM-dd");
            BillNo = ViewState["BillNo"].ToString();

            decimal serTaxBillAmt = 0, serviceTaxAmt = 0, amtAftServiceAmt = 0, surchargeTaxAmt = 0, netBillAmt = 0, serviceTaxPer = 0, surchargePer = 0;
            AllQuery AQ = new AllQuery();
            decimal amountBilled = Util.GetDecimal(AQ.GetBillAmount(ViewState["TID"].ToString(), null));
            netBillAmt = amountBilled;
            string isServiceTax = StockReports.ExecuteScalar("Select IsServiceTax from f_panel_master where PanelID=(Select PanelID from Patient_Medical_History where TransactionID='" + ViewState["TID"].ToString() + "')").Trim().ToUpper();

            if (isServiceTax == "1")
            {
                decimal totalDisc = Util.GetDecimal(StockReports.ExecuteScalar("Select (IFNULL(sum((Rate*Quantity)-Amount),0) + (Select IFNULL(DiscountOnBill,0) from f_ipdadjustment where TransactionID='" + TransactionID + "')) TotalDisc from f_ledgertnxdetail where TransactionID='" + TransactionID + "' and DiscountPercentage > 0  and Isverified=1 and Ispackage=0"));
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
                btnFinalDiscount.Enabled = false;
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
        string TID = ViewState["TID"].ToString();
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

        string transactionID = ViewState["TID"].ToString();
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
    protected void btnCalculate_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);


        try
        {
            string transactionID = Util.GetString(ViewState["TID"]);
            AllQuery AQ = new AllQuery();
            DataTable dt = AQ.GetPatientIPDInformation("", transactionID);

            int panelCurrencyCountryID = Util.GetInt(lblPanelRateCurrencyCountryID.Text);


            decimal panelCurrencyFactor = Util.GetDecimal(txtPanelCurrencyFactor.Text);


            if (panelCurrencyFactor <= 0)
            {
                lblMsg.Text = "Please Enter Valid Currency Factor.";
                return;
            }
            string panelID = dt.Rows[0]["PanelID"].ToString();
            string scheduleChargeID = dt.Rows[0]["ScheduleChargeID"].ToString();
            string ipdCaseTypeID = dt.Rows[0]["IPDCaseType_ID"].ToString();

            StringBuilder sqlCmd = new StringBuilder(" UPDATE f_ledgertnxdetail ltd INNER JOIN f_subcategorymaster sc ON ltd.subcategoryID = sc.SubcategoryID   ");
            sqlCmd.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID=ltd.TransactionID   ");
            sqlCmd.Append(" INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID    ");
            sqlCmd.Append(" LEFT JOIN f_ratelist_ipd rt ON  ltd.itemid = rt.itemid AND rt.PanelID=" + panelID + " AND rt.scheduleChargeID=" + scheduleChargeID + " AND rt.ipdcasetype_ID='" + ipdCaseTypeID + "'  AND rt.IsCurrent=1  ");
            sqlCmd.Append(" SET ltd.PanelCurrencyCountryID=" + panelCurrencyCountryID + ",ltd.PanelCurrencyFactor=" + panelCurrencyFactor + ",ltd.Rate=(IFNULL(rt.Rate,0)*" + panelCurrencyFactor + "),   ");
            sqlCmd.Append(" ltd.Amount=IF(ltd.IsPackage=0,(((IFNULL(rt.Rate,0)*" + panelCurrencyFactor + ") * ltd.Quantity)-ROUND(((((IFNULL(rt.Rate,0)*" + panelCurrencyFactor + ") * ltd.Quantity)*Get_PanelwiseDiscount_CoPay_NonPayable(" + panelID + ",pmh.PatientTypeID,ltd.ItemID,ltd.SubCategoryID,sc.CategoryID,2))/100),2)),0), ");
            sqlCmd.Append(" ltd.NetItemAmt=IF(ltd.IsPackage=0,(((IFNULL(rt.Rate,0)*" + panelCurrencyFactor + ") * ltd.Quantity)-ROUND((((IFNULL(rt.Rate,0) * ltd.Quantity)*Get_PanelwiseDiscount_CoPay_NonPayable(" + panelID + ",pmh.PatientTypeID,ltd.ItemID,ltd.SubCategoryID,sc.CategoryID,2))/100),2)),0),  ");
            sqlCmd.Append(" ltd.CoPayPercent=Get_PanelwiseDiscount_CoPay_NonPayable(" + panelID + ",pmh.PatientTypeID,ltd.ItemID,ltd.SubCategoryID,sc.CategoryID,3),   ");
            sqlCmd.Append(" ltd.DiscountPercentage=Get_PanelwiseDiscount_CoPay_NonPayable(" + panelID + ",pmh.PatientTypeID,ltd.ItemID,ltd.SubCategoryID,sc.CategoryID,2),       ");
            sqlCmd.Append(" ltd.IsPayable=Get_PanelwiseDiscount_CoPay_NonPayable(" + panelID + ",pmh.PatientTypeID,ltd.ItemID,ltd.SubCategoryID,sc.CategoryID,1), ");
            sqlCmd.Append(" ltd.DiscAmt=ROUND(((((IFNULL(rt.Rate,0)*" + panelCurrencyFactor + ") * ltd.Quantity)*Get_PanelwiseDiscount_CoPay_NonPayable(" + panelID + ",pmh.PatientTypeID,ltd.ItemID,ltd.SubCategoryID,sc.CategoryID,2))/100),2),   ");
            sqlCmd.Append(" DiscUserID='" + Session["ID"].ToString() + "',                                                                                                                                                  ");
            sqlCmd.Append(" ltd.LastUpdatedBy = '" + Session["ID"].ToString() + "', ");
            sqlCmd.Append(" ltd.Updatedate = now(),    ");
            sqlCmd.Append(" ltd.IpAddress = '" + All_LoadData.IpAddress() + "'                   ");
            sqlCmd.Append(" WHERE ltd.TransactionID='" + transactionID + "'         ");
            sqlCmd.Append(" AND ltd.IsVerified=1 AND ltd.IsSurgery=0 AND ltd.isPackage=0 ");
            sqlCmd.Append(" AND cf.ConfigID <>11 AND UCASE(sc.DisplayName)<>'MEDICINE & CONSUMABLES'    ");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sqlCmd.ToString());

            string str = "Select LedgerTransactionNO,ItemID,sc.SubCategoryID,sc.CategoryID,Rate,Amount,DiscountPercentage,LedgerTnxID,Surgery_ID,pmh.PatientTypeID from f_ledgertnxdetail ltd inner join patient_medical_history pmh on pmh.TransactionID=ltd.TransactionID inner join f_subcategorymaster sc on sc.SubCategoryID=ltd.SubCategoryID where LTD.TransactionID='" + ViewState["TransactionID"].ToString() + "' and IsVerified=1 and ISSurgery=1";

            DataSet ds = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, str);

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                decimal TotalSurgeryAmount = Util.GetDecimal(ds.Tables[0].Compute("sum(Rate)", ""));

                DataColumn dc = new DataColumn("Percentage", typeof(float));
                dc.DefaultValue = 0;
                ds.Tables[0].Columns.Add(dc);

                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    dr["Percentage"] = Util.GetDecimal((Util.GetDecimal(dr["Rate"]) / TotalSurgeryAmount) * 100);
                }

                ds.Tables[0].AcceptChanges();

                decimal TotalRate = Util.GetDecimal(StockReports.ExecuteScalar("Select Rate from f_surgery_rate_list where Surgery_ID='" + ds.Tables[0].Rows[0]["Surgery_ID"].ToString() + "' and PanelID=" + panelID + " and IPDCaseType_ID='" + ipdCaseTypeID + "' and ScheduleChargeID=" + scheduleChargeID + " "));

                TotalRate = TotalRate * panelCurrencyFactor;

                if (TotalRate > 0)
                {
                    foreach (DataRow row in ds.Tables[0].Rows)
                    {
                        decimal ItemRate = (TotalRate * Util.GetDecimal(row["Percentage"]) / 100);

                        // float ItemDisc = (ItemRate * Util.GetDecimal(row["DiscountPercentage"]) / 100);

                        //Devendra  Panelwise Discount

                        decimal ItemDiscPercentage = Util.GetDecimal(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select Get_PanelwiseDiscount_CoPay_NonPayable(" + panelID + "," + row["PatientTypeID"].ToString() + ",'" + row["ItemID"].ToString() + "','" + row["SubCategoryID"].ToString() + "','" + row["CategoryID"].ToString() + "',2)"));
                        decimal ItemDisc = (ItemRate * Util.GetDecimal(ItemDiscPercentage) / 100);
                        decimal Copay = Util.GetDecimal(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select Get_PanelwiseDiscount_CoPay_NonPayable(" + panelID + "," + row["PatientTypeID"].ToString() + ",'" + row["ItemID"].ToString() + "','" + row["SubCategoryID"].ToString() + "','" + row["CategoryID"].ToString() + "',3)"));
                        int IsPayable = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select Get_PanelwiseDiscount_CoPay_NonPayable(" + panelID + "," + row["PatientTypeID"].ToString() + ",'" + row["ItemID"].ToString() + "','" + row["SubCategoryID"].ToString() + "','" + row["CategoryID"].ToString() + "',1)"));

                        // str = " Update f_ledgertnxdetail Set Rate =" + ItemRate + ",Amount=" + (ItemRate - ItemDisc) + ",NetItemAmt=" + (ItemRate - ItemDisc) + ",LastUpdatedBy = '" + ViewState["USERID"] + "',Updatedate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',IpAddress = '" + Util.GetString(All_LoadData.IpAddress()) + "'  Where LedgerTnxID ='" + row["LedgerTnxID"].ToString() + "'";                         
                        str = " Update f_ledgertnxdetail Set ltd.PanelCurrencyCountryID=" + panelCurrencyCountryID + ",ltd.PanelCurrencyFactor=" + panelCurrencyFactor + ", DiscUserID='" + Session["ID"].ToString() + "',CoPayPercent=" + Copay + ",IsPayable=" + IsPayable + ",Rate =" + ItemRate + ",DiscountPercentage=" + ItemDiscPercentage + ",DiscAmt=" + ItemDisc + ",Amount=" + (ItemRate - ItemDisc) + ",NetItemAmt=" + (ItemRate - ItemDisc) + ",LastUpdatedBy = '" + ViewState["USERID"] + "',Updatedate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',IpAddress = '" + Util.GetString(All_LoadData.IpAddress()) + "'  Where LedgerTnxID ='" + row["LedgerTnxID"].ToString() + "'";
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

                        str = " Update f_surgery_discription sd left join f_surgery_doctor sDoc on " +
                        "sd.SurgeryTransactionID = sdoc.SurgeryTransactionID " +
                        "Set sd.Rate=" + ItemRate + ",sd.Amount=" + (ItemRate - ItemDisc) + ",sd.Discount=" + ItemDisc + ",sDoc.Discount=" + ItemDisc + ",sDoc.Amount =" + (ItemRate - ItemDisc) + " " +
                        ",sd.LastUpdatedBy = '" + ViewState["USERID"] + "',sd.Updatedate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',sd.IpAddress = '" + Util.GetString(All_LoadData.IpAddress()) + "' " +
                         ",sDoc.LastUpdatedBy = '" + ViewState["USERID"] + "',sDoc.Updatedate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',sDoc.IpAddress = '" + Util.GetString(All_LoadData.IpAddress()) + "' " +
                        "where sd.LedgerTransactionNo='" + row["LedgerTransactionNo"].ToString() + "' and sd.ItemID ='" + row["ItemID"].ToString() + "'";
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
                    }
                }

            }
            tnx.Commit();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Calculated Successfully.');", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "window.location.href=''", true);
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
    protected void btnsave_Click(object sender, EventArgs e)
    {
        string ID = "";
        ID = AllInsert.SaveDiscReason(txtDiscReason.Value.Trim(), "IPD");
        if (ID == "0")
        {
            lblMsg.Text = "Discount Reason Already Exist";
        }
        else if (ID != "" && ID != "0")
        {
            string strDiscReason = "select ID,DiscountReason from discount_reason where Active=1 AND Type='IPD'";
            DataTable DiscountReason = StockReports.GetDataTable(strDiscReason);
            ddlControlDiscountReason.DataTextField = "DiscountReason";
            ddlControlDiscountReason.DataValueField = "ID";
            ddlControlDiscountReason.DataSource = DiscountReason;
            ddlControlDiscountReason.DataBind();
            ddlControlDiscountReason.Items.Insert(0, "--Please Select Reason--");
            txtDisAmount1.Enabled = true;
            txtDisPercent1.Enabled = true;
            btnSaveFinalBill.Enabled = true;
            lblMsg.Text = "Discount Reason Saved Successfully";
        }
        else
        {
            lblMsg.Text = "Discount Reason Saved Successfully";
        }
    }
}
