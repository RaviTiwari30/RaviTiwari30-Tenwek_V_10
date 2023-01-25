using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

public partial class Design_Mortuary_Mortuary_BasketBilling : System.Web.UI.Page
{
    DataTable dtItem;
    DataTable dtMain;

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
            ViewState["ID"] = Session["ID"].ToString();
            ViewState["LoginType"] = Session["LoginType"].ToString().ToUpper();
            lblCorpseID.Text = Request.QueryString["CorpseID"].ToString();
            lblTransactionID.Text = Request.QueryString["TransactionID"].ToString();


            AllQuery AQ = new AllQuery();

            DataTable dtDischarge = AQ.GetCorpseReleasedStatus(lblTransactionID.Text);

            if (dtDischarge != null && dtDischarge.Rows.Count > 0)
            {
                if (dtDischarge.Rows[0]["IsReleased"].ToString() == "1")
                {
                    string Msg = "Corpse is Already Released on " + dtDischarge.Rows[0]["ReleasedDateTime"].ToString() + " . No Services can be possible...";
                    Response.Redirect("../Mortuary/CorpseBillMsg.aspx?msg=" + Msg);
                }
            }

            All_LoadData.bindDoctor(cmbRefferedBy);
            BindCorpseDetails();
            LoadCategory();
            LoadItems();
            BindItems();
            CreateTable();
            ViewState.Add("dtItem", dtItem);
            ViewState["IsSelected"] = 0;

            DateTime AdmitDate = Util.GetDateTime(AQ.GetCorpseDepositeDate(lblTransactionID.Text.Trim()));

            ucDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            calucDate.StartDate = Util.GetDateTime(AdmitDate.ToString("dd-MMM-yyyy"));
            calucDate.EndDate = DateTime.Now;
            ddlCategory.Focus();

        }
        if (ViewState.Count > 0)
        {
            dtItem = ViewState["dtItem"] as DataTable;
        }
        if (dtItem == null)
        {
            CreateTable();
        }

        ucDate.Attributes.Add("readOnly", "true");
    }

    private void LoadCategory()
    {
        string ConfigIDs = "2,6,8,9,10,20,24,14,26,27,29,30";
        ddlCategory.Items.AddRange(LoadItems(CreateStockMaster.LoadCategoryByCategoryID(CreateStockMaster.LoadCategoryByConfigID(ConfigIDs))));
        ddlCategory.DataBind();
        ListItem li = new ListItem();
        li.Text = "All";
        li.Value = "All";
        ddlCategory.Items.Insert(0, li);
    }
    private void BindItems()
    {
        if (ddlCategory.SelectedIndex != -1 && ddlCategory.SelectedItem.Value.ToUpper() != "ALL")
        {

            DataRow[] dr = ((DataTable)ViewState["dtMain"]).Select("CategoryID ='" + ddlCategory.SelectedItem.Value + "'");
            BindList(dr);


        }
        else
        {
            DataTable dt = (DataTable)ViewState["dtMain"];
            ListBox1.Items.Clear();
            ListBox1.DataSource = dt;
            ListBox1.DataTextField = "TypeName";
            ListBox1.DataValueField = "ItemID";
            ListBox1.DataBind();
        }
    }

    private void LoadItems()
    {
        try
        {
            string ConfigIDs = "2,6,8,9,10,20,24,14,26,27,29";
            AllQuery AQ = new AllQuery();
            dtMain = AQ.getItemByConfigID(ConfigIDs, lblPanel_ID.Text);
            ViewState.Add("dtMain", dtMain);
        }
        catch (Exception ex)
        {
            ClassLog objCL = new ClassLog();
            objCL.errLog(ex);
        }
    }
    public DataTable GetItemSubCategoryByCategoryConfigID(string CategoryID)
    {
        DataTable Items = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("SELECT IM.TypeName,CONCAT(IFNULL(IM.ItemID,''),'#',IFNULL(IM.SubCategoryID,''),'#', IFNULL(SC.Name,''),'#',IFNULL(Type_ID,''))ItemID,IM.SubCategoryID,SC.CategoryID FROM f_itemmaster im INNER JOIN f_subcategorymaster sc ON im.SubCategoryID = sc.SubCategoryID INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID LEFT JOIN f_item_outsource io ON im.ItemID = io.ItemID AND io.IsActive=1 WHERE im.IsActive=1 AND cf.ConfigRelationID IN (" + CategoryID + ") AND io.ItemID IS NULL ");

            if (txtWord.Text.Trim() != string.Empty)
            {
                sb.Append(" AND im.TypeName LIKE '%" + txtWord.Text.Trim() + "%' ");
                ViewState["IsSelected"] = 1;
            }

            sb.Append(" ORDER BY TypeName");

            Items = StockReports.GetDataTable(sb.ToString());

            if (Items.Rows.Count > 0)
            {
                return Items;
            }
            else
            {
                return null;
            }
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            return null;
        }
    }

    private void BindList(DataRow[] dr)
    {
        try
        {
            ListBox1.Items.Clear();
            foreach (DataRow row in dr)
            {
                ListBox1.Items.Add(new ListItem(row["TypeName"].ToString(), row["ItemID"].ToString()));
            }
            ListBox1.DataBind();
        }
        catch (Exception ex)
        {
            ClassLog objCL = new ClassLog();
            objCL.errLog(ex);
        }
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

    public ListItem[] LoadItems(DataTable str)
    {
        try
        {
            if (str == null)
            {
                ListItem[] iItems = new ListItem[1];
                iItems[0] = new ListItem("", "");
                return iItems;
            }

            ListItem[] Items = new ListItem[str.Rows.Count];

            for (int i = 0; i < str.Rows.Count; i++)
            {
                Items[i] = new ListItem(str.Rows[i][0].ToString(), str.Rows[i][1].ToString());
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

    private void CreateTable()
    {
        if (dtItem == null)
        {
            dtItem = new DataTable();
            dtItem.Columns.Add("Category");
            dtItem.Columns.Add("SubCategory");
            dtItem.Columns.Add("ItemID");
            dtItem.Columns.Add("Item");
            dtItem.Columns.Add("Quantity");
            dtItem.Columns.Add("Rate");
            dtItem.Columns.Add("TotalAmt");
            dtItem.Columns.Add("SubCategoryID");
            dtItem.Columns.Add("Date");
            dtItem.Columns.Add("ItemDisplayName");
            dtItem.Columns.Add("ItemCode");
            dtItem.Columns.Add("Doctor_ID");
            dtItem.Columns.Add("Name");
            dtItem.Columns.Add("DocCharges");
            dtItem.Columns.Add("TnxTypeID");
            dtItem.Columns.Add("ConfigRelationID");
        }
    }

    protected void btnReceipt_Click(object sender, EventArgs e)
    {
        if (dtItem != null && dtItem.Rows.Count > 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();

            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.ReadCommitted);

            try
            {
                string Ref_Code, Panel_ID, IPDCaseType_ID;

                Panel_ID = lblPanel_ID.Text.Trim();
                IPDCaseType_ID = lblCaseTypeID.Text.Trim();
                Ref_Code = lblReferenceCode.Text.Trim();

                //Create Table to store rate of Items
                DataTable dtTemp = new DataTable();

                for (int i = 0; i < dtItem.Rows.Count; i++)
                {
                    dtTemp = IPDBilling.LoadItemsHavingRateFixed("'" + dtItem.Rows[i]["ItemID"].ToString() + "'", Ref_Code, IPDCaseType_ID, ViewState["ScheduleChargeID"].ToString(), Session["CentreID"].ToString());

                    if (dtTemp != null && dtTemp.Rows.Count > 0)
                    {
                        dtItem.Rows[i]["Rate"] = dtTemp.Rows[0]["Rate"].ToString();
                        if (Util.GetString(dtTemp.Rows[0]["ItemDisplayName"]) != "")
                            dtItem.Rows[i]["ItemDisplayName"] = dtTemp.Rows[0]["ItemDisplayName"].ToString();
                        else
                            dtItem.Rows[i]["ItemDisplayName"] = dtItem.Rows[i]["Item"].ToString();

                        dtItem.Rows[i]["ItemCode"] = dtTemp.Rows[0]["ItemCode"].ToString();
                        dtItem.Rows[i]["ConfigRelationID"] = dtTemp.Rows[0]["ConfigID"].ToString();

                    }
                    else
                    {
                        dtItem.Rows[i]["Rate"] = "0";
                        dtItem.Rows[i]["ItemDisplayName"] = dtItem.Rows[i]["Item"].ToString();
                        dtItem.Rows[i]["ItemCode"] = "";
                    }
                }
                string IsVerified = "1";
                dtItem = SaveLedgerForMortuaryBilling(dtItem, lblCorpseID.Text, "Mortuary-Billing", Panel_ID, ViewState["ID"].ToString(), lblTransactionID.Text, Util.GetString(Session["HOSPID"].ToString()), "Yes", IsVerified, tnx, con);

                try
                {
                    if (dtItem != null)
                    {
                        tnx.Commit();
                        con.Close();
                        con.Dispose();
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
                        grdItemRate.DataSource = "";
                        grdItemRate.DataBind();

                        dtItem.Rows.Clear();
                        ViewState.Add("dtItem", dtItem);
                        pnlhide.Visible = false;

                    }
                    else
                    {
                        tnx.Rollback();
                        con.Close();
                        con.Dispose();
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key21", "modelAlert('Record Saved  Successfully.');", true);

                    }
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    tnx.Rollback();
                    con.Close();
                    con.Dispose();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key42", "modelAlert('Record Saved  Successfully.');", true);
                }

                Clear();
                txtQty.Text = "1";
            }
            catch (Exception ex)
            {

                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
            }
        }
    }

    protected void grdItemRate_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {

        dtItem.Rows[e.RowIndex].Delete();
        dtItem.AcceptChanges();

        grdItemRate.DataSource = dtItem;
        grdItemRate.DataBind();
        if (dtItem.Rows.Count > 0)
        {
            pnlhide.Visible = true;
        }
        else
        {
            pnlhide.Visible = false;
        }

    }

    private void Clear()
    {

        txtQty.Text = "";

        ddlCategory.SelectedIndex = 0;
        ListBox1.Items.Clear();
        ListBox1.Items.Clear();
        if (ddlCategory.SelectedItem.Value.ToUpper() != "ALL")
        {
            ListBox1.Items.AddRange(LoadItems(CreateStockMaster.LoadItemsSubCategoryByCategoryID(ddlCategory.SelectedItem.Value)));
            ListBox1.DataBind();
        }
        else
        {
            DataTable dt = (DataTable)ViewState["dtMain"];
            ListBox1.DataSource = dt;
            ListBox1.DataTextField = "TypeName";
            ListBox1.DataValueField = "ItemID";
            ListBox1.DataBind();
        }
    }

    public DataTable GetItemsSubCategoryByCategoryID(string CategoryID)
    {
        DataTable Items = new DataTable();
        StringBuilder sb = new StringBuilder();
        //MySqlConnection objCon = new MySqlConnection();
        try
        {
            sb.Append("  Select IM.TypeName,concat(IM.ItemID,'#',IM.SubCategoryID,'#',SC.SubCategory)ItemID from (Select TypeName,ItemID,SubCategoryID from f_itemmaster where SubCategoryID in (Select SubCategoryID from f_SubCategoryMaster where  Active=1 and CategoryID ='" + CategoryID + "')  and isactive=1) IM,(Select Name as SubCategory,SubCategoryID from f_SubCategoryMaster where  Active=1 and CategoryID ='" + CategoryID + "')SC Where SC.SubCategoryID = IM.SubCategoryID ");

            if (txtWord.Text.Trim() != string.Empty)
            {
                sb.Append("   AND IM.TypeName LIKE '%" + txtWord.Text.Trim() + "%' order by IM.TypeName ");
                ViewState["IsSelected"] = 1;
            }
            sb.Append("   order by IM.TypeName ");
            Items = StockReports.GetDataTable(sb.ToString());
            //Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];

            //if (IsLocalConn)
            //{
            //    if (objCon.State == ConnectionState.Open) objCon.Close();
            //}

            if (Items.Rows.Count > 0)
            {
                return Items;
            }
            else
            {
                return null;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            //if (objCon.State == ConnectionState.Open) objCon.Close();
        }
        return null;
    }


    protected void ddlCategory_SelectedIndexChanged(object sender, EventArgs e)
    {
        ListBox1.Items.Clear();
        if (ddlCategory.SelectedItem.Value.ToUpper() != "ALL")
        {
            ListBox1.Items.AddRange(LoadItems(CreateStockMaster.LoadItemsSubCategoryByCategoryID(ddlCategory.SelectedItem.Value)));
        }
        else
        {
            DataTable dt = (DataTable)ViewState["dtMain"];
            ListBox1.DataSource = dt;
            ListBox1.DataTextField = "TypeName";
            ListBox1.DataValueField = "ItemID";
            ListBox1.DataBind();
        }
        //GetItemsSubCategoryByCategoryID
    }

    protected void btnSelect_Click(object sender, EventArgs e)
    {
        try
        {
            lblMsg.Text = "";
            AllQuery AQ = new AllQuery();
            string DepositeDate = AQ.GetCorpseDepositeDate(lblTransactionID.Text.Trim());

            string PrescribeDate = Util.GetDateTime(ucDate.Text).ToString("yyyy-MM-dd");

            if (Util.GetDateTime(PrescribeDate) < Util.GetDateTime(DepositeDate))
            {
                lblMsg.Text = "Given Date is less then Admit Date";
                return;
            }

            if (cmbRefferedBy.SelectedItem.Text != "-" && txtDocCharges.Text.Trim() == "")
            {
                lblMsg.Text = "Please Give Rate of Doctor";
                return;
            }

            if (Util.GetInt(txtQty.Text.Trim()) <= 0)
            {
                lblMsg.Text = "Invalid Quantity";
                txtQty.Focus();
                return;
            }
            if (ListBox1.SelectedIndex == -1)
            {
                lblMsg.Text = "Please Select Item";
                ListBox1.Focus();
                return;
            }


            string Panel_ID = lblPanel_ID.Text.Trim();
            string IPDCaseType_ID="";
            if (lblCaseTypeID.Text.Trim() != "")
                IPDCaseType_ID = lblCaseTypeID.Text.Trim();
            else
                IPDCaseType_ID = "LSHHI1";

            string Ref_Code = lblReferenceCode.Text.Trim();
            string ItemID = ListBox1.Items[ListBox1.SelectedIndex].Value.Split('#')[0].ToString();

            if (grdItemRate.Rows.Count > 0 && grdItemRate != null)
            {
                foreach (GridViewRow gr in grdItemRate.Rows)
                {

                    if (((Label)gr.FindControl("lblItem")).Text == ItemID)
                    {
                        lblMsg.Text = "Item Already Added";
                        return;
                    }
                }
            }

            string IsExist = StockReports.ExecuteScalar("SElect ItemID from f_configrelation cf inner join f_subcategorymaster sc on cf.CategoryID = sc.CategoryID inner join f_itemmaster im on im.SubCategoryID = sc.SubCategoryID where im.ItemID='" + ItemID + "' and cf.ConfigID<>11 and (sc.DisplayName)='MEDICINE & CONSUMABLES' ");

            if (IsExist == string.Empty)
            {
                DataTable dtTemp = IPDBilling.LoadItemsHavingRateFixed("'" + ItemID + "'", lblReferenceCode.Text, "76", ViewState["ScheduleChargeID"].ToString(), Session["CentreID"].ToString());

                if (dtTemp != null && dtTemp.Rows.Count > 0)
                {
                    if (Util.GetDecimal(dtTemp.Rows[0]["Rate"]) == 0)
                    {
                        lblMsg.Text = "Rate is Not Set Under this Panel & RoomType. Please contact EDP to Set Rate";
                        return;
                    }
                }
                else
                {
                    lblMsg.Text = "Rate is Not Set Under this Panel & RoomType. Please contact EDP to Set Rate";
                    return;
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        getrate();

    }

    private void getrate()
    {
        try
        {
            if (dtItem != null)
            {
                string Panel_ID = lblPanel_ID.Text.Trim();
                string IPDCaseType_ID="";
                if (lblCaseTypeID.Text.Trim() != "")
                    IPDCaseType_ID = lblCaseTypeID.Text.Trim();
                else
                    IPDCaseType_ID = "LSHHI1";

                string Ref_Code = lblReferenceCode.Text.Trim();

                string ItemID = ListBox1.Items[ListBox1.SelectedIndex].Value;// ListBox1.SelectedItem.Value.Split('#')[2];
                string ItemName = ListBox1.Items[ListBox1.SelectedIndex].Text.Split('#')[1];

                DataRow dr = dtItem.NewRow();
                dr["Category"] = ddlCategory.SelectedItem.Text;
                dr["SubCategory"] = ItemID.Split('#')[2].ToString(); //ListBox1.SelectedItem.Value.Split('#')[2];
                dr["ItemID"] = ItemID.Split('#')[0].ToString(); //ListBox1.SelectedItem.Value.Split('#')[0];
                dr["Item"] = ItemName;// ListBox1.SelectedItem.Text;
                dr["Quantity"] = txtQty.Text.Trim();

                //Getting Rates
                DataTable dtTemp = IPDBilling.LoadItemsHavingRateFixed("'" + dr["ItemID"].ToString() + "'", Ref_Code, IPDCaseType_ID, ViewState["ScheduleChargeID"].ToString(), Session["CentreID"].ToString());

                if (dtTemp != null && dtTemp.Rows.Count > 0)
                {
                    dr["Rate"] = Util.GetDecimal(dtTemp.Rows[0]["Rate"].ToString());
                    dr["TotalAmt"] = Util.GetString(Util.GetDecimal(dtTemp.Rows[0]["Rate"]) * Util.GetDecimal(txtQty.Text.Trim()));
                }
                else
                {
                    dr["Rate"] = "0";
                    dr["TotalAmt"] = "0";
                }

                dr["Date"] = Util.GetDateTime(ucDate.Text).ToString("dd-MMM-yyyy") + " " + DateTime.Now.ToShortTimeString();
                dr["SubCategoryID"] = ItemID.Split('#')[1].ToString(); //ListBox1.SelectedItem.Value.Split('#')[1];

                if (lblDoctor_ID.Text.Trim() != cmbRefferedBy.SelectedItem.Value.Trim())
                {
                    dr["Doctor_ID"] = cmbRefferedBy.SelectedItem.Value;
                    dr["Name"] = cmbRefferedBy.SelectedItem.Text;
                    dr["DocCharges"] = txtDocCharges.Text.Trim();
                }
                else
                {
                    dr["Doctor_ID"] = lblDoctor_ID.Text;
                    dr["Name"] = StockReports.GetDoctorNameByDoctorID(lblDoctor_ID.Text);
                    dr["DocCharges"] = "0.00";
                }

                dr["TnxTypeID"] = "0";


                dtItem.Rows.Add(dr);
                ViewState.Add("dtItem", dtItem);
            }

            if (dtItem != null && dtItem.Rows.Count > 0)
            {
                grdItemRate.DataSource = dtItem;
                grdItemRate.DataBind();
                pnlhide.Visible = true;
            }


            txtWord.Text = "";
            //txtDocCharges.Text = "";
            txtQty.Text = "1";
            ViewState["IsSelected"] = 0;
        }
        catch (Exception ex)
        {
            ClassLog objClass = new ClassLog();
            objClass.errLog(ex);
        }
    }
    private void BindCorpseDetails()
    {
        try
        {
            AllQuery AQ = new AllQuery();
            DataTable dt = AQ.GetCorpseInformation(lblTransactionID.Text);
            //DataTable dt = AQ.GetPatientIPDInformation("", TransactionID);
            if (dt != null && dt.Rows.Count > 0)
            {
                if (dt.Rows[0]["IPDNo"].ToString() != "")
                {
                    DataTable dtPanel = AQ.GetPatientIPDInformation("", dt.Rows[0]["IPDNo"].ToString());
                    if (dtPanel == null )
                    {
                       dtPanel= GetPatientEMGInformation("", dt.Rows[0]["IPDNo"].ToString());
                    }
                        lblPatientIDPMH.Text = dtPanel.Rows[0]["PatientID"].ToString();
                        lblTransactionNoPMH.Text = dtPanel.Rows[0]["TransactionID"].ToString();
                        lblCaseTypeID.Text = dtPanel.Rows[0]["IPDCaseTypeID"].ToString();
                        lblReferenceCode.Text = dtPanel.Rows[0]["ReferenceCode"].ToString();
                        lblPanel_ID.Text = dtPanel.Rows[0]["PanelID"].ToString();
                        lblDoctor_ID.Text = dt.Rows[0]["DoctorID"].ToString();
                        ViewState["ScheduleChargeID"] = dtPanel.Rows[0]["ScheduleChargeID"].ToString();
                        cmbRefferedBy.SelectedIndex = cmbRefferedBy.Items.IndexOf(cmbRefferedBy.Items.FindByValue(dt.Rows[0]["DoctorID"].ToString()));
                   

                    
                    
                    
                }
                else
                {
                    DataTable dtPanel = StockReports.GetDataTable("SELECT pm.PanelID ,ReferenceCode,rs.ScheduleChargeID FROM f_panel_master pm INNER JOIN f_rate_schedulecharges rs ON pm.PanelID=rs.PanelID WHERE pm.IsActive=1 AND rs.IsDefault=1 AND rs.panelid='" + Resources.Resource.DefalutParentPanelID + "' ");
                    
                    lblPatientIDPMH.Text = "";
                    lblTransactionNoPMH.Text = "";
                    lblCaseTypeID.Text = Resources.Resource.Mortuary_IPDCaseType_ID;
                    lblReferenceCode.Text = dtPanel.Rows[0]["ReferenceCode"].ToString();
                    lblPanel_ID.Text = dtPanel.Rows[0]["PanelID"].ToString();
                    lblDoctor_ID.Text = dt.Rows[0]["DoctorID"].ToString();
                    ViewState["ScheduleChargeID"] = dtPanel.Rows[0]["ScheduleChargeID"].ToString();
                    cmbRefferedBy.SelectedIndex = cmbRefferedBy.Items.IndexOf(cmbRefferedBy.Items.FindByValue(dt.Rows[0]["DoctorID"].ToString()));
                }
            }


        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = "Patient Record and Room Not Available";
        }
    }
    protected void btnAddDirect_Click(object sender, EventArgs e)
    {
        DataTable dtitemforChk = (DataTable)ViewState["dtItemForChk"];
        // Flag = 1;
        grdItemRate.DataSource = dtitemforChk;
        grdItemRate.DataBind();

        ViewState["IsSelected"] = 0;
        txtWord.Text = "";
        pnlhide.Visible = true;
    }
    protected void Button2_Click(object sender, EventArgs e)
    {
        DataTable dtChkCancel = (DataTable)ViewState["dtItemForChk"];
        int count = dtChkCancel.Rows.Count;
        dtChkCancel.Rows[count - 1].Delete();
        ViewState["dtItems"] = dtChkCancel;
    }


    private DataTable SaveLedgerForMortuaryBilling(DataTable Items, string CorpseID, string TypeOfTransaction, string PanelId, string UserID, string TransactionID, string HospitalID, string IsService, string IsVerified, MySqlTransaction TranConnection, MySqlConnection con)
    {
        try
        {
            float TotalRate = 0F;
            

            for (int i = 0; i < Items.Rows.Count; i++)
            {
                TotalRate = TotalRate + (Util.GetFloat(Items.Rows[i]["Rate"]) * Util.GetFloat(Items.Rows[i]["Quantity"]));
            }

            string HospitalLedgerNo = AllQuery.GetLedgerNoByLedgerUserID(HospitalID, con);

            //Insert into Mortuary Ledger transaction

            string LedTxnID = "";
            AllQuery aq = new AllQuery();
            Mortuary_Ledger_Transaction objLedTran = new Mortuary_Ledger_Transaction(TranConnection);
            objLedTran.LedgerNoDr = HospitalLedgerNo;
            objLedTran.LedgerNoCr = aq.GetCorpseLedgerNo(Util.GetString(lblTransactionID.Text));
            objLedTran.Hospital_ID = HospitalID;
            objLedTran.TypeOfTnx = TypeOfTransaction;
            objLedTran.Date = Util.GetDateTime(Items.Rows[0]["Date"].ToString());
            objLedTran.Time = Util.GetDateTime(Items.Rows[0]["Date"].ToString());
            objLedTran.AgainstPONo = "";
            objLedTran.BillNo = "";
            objLedTran.DiscountOnTotal = Util.GetDecimal("0.0");
            objLedTran.GrossAmount = Util.GetDecimal(TotalRate);
            objLedTran.NetAmount = Util.GetDecimal(TotalRate);
            objLedTran.IsCancel = 0;
            objLedTran.CancelReason = "";
            objLedTran.CancelAgainstLedgerNo = "";
            objLedTran.CancelDate = Util.GetDateTime("01-Jan-0001");
            objLedTran.UserID = UserID;
            objLedTran.CorpseID = CorpseID;
            objLedTran.TransactionID = TransactionID;
            objLedTran.Panel_ID = PanelId;
            objLedTran.UniqueHash = Util.getHash();
            objLedTran.IpAddress = Request.UserHostAddress;
            objLedTran.PaymentModeID = 1;
            objLedTran.CentreID = Util.GetInt(Session["CentreID"].ToString());
            //objLedTran.HospCentreID = Util.GetInt(Session["HospCentreID"].ToString());
            LedTxnID = objLedTran.Insert().ToString();

            //***************** insert into Mortuary Ledger transaction details *************            

            if (Items.Columns.Contains("LedgerTransactionNo") == false) Items.Columns.Add("LedgerTransactionNo");


            //Checking if Patient is prescribed any IPD Packages
            DataTable dtPkg = StockReports.GetIPD_Packages_Prescribed(TransactionID, con);

            int Is_OldItems_Shifted_To_Pkg = 0;

            for (int j = 0; j < Items.Rows.Count; j++)
            {
                Mortuary_LedgerTnxDetail objLTDetail = new Mortuary_LedgerTnxDetail(TranConnection);

                objLTDetail.Hospital_Id = HospitalID;// LedgerNo.Rows[0]["Hospital_ID"].ToString(); //Hospital ID;
                objLTDetail.LedgerTransactionNo = LedTxnID;
                objLTDetail.ItemID = Items.Rows[j]["ItemID"].ToString();
                objLTDetail.Rate = Util.GetDecimal(Items.Rows[j]["Rate"]);
                objLTDetail.Quantity = Util.GetDecimal(Items.Rows[j]["Quantity"]);
                objLTDetail.TnxTypeID = Util.GetInt(Items.Rows[j]["TnxTypeID"]);
                objLTDetail.ConfigID = Util.GetInt(Items.Rows[j]["ConfigRelationID"]);
                objLTDetail.IsPayable = StockReports.GetIsPayableItems(objLTDetail.ItemID, Util.GetInt(PanelId));

                if (dtPkg != null && dtPkg.Rows.Count > 0)
                {
                    int iCtr = 0;
                    foreach (DataRow drPkg in dtPkg.Rows)
                    {
                        if (iCtr == 0)
                        {
                            DataTable dtPkgDetl = StockReports.ShouldSendToIPDPackage(TransactionID, drPkg["PackageID"].ToString(), Items.Rows[j]["ItemID"].ToString(), (Util.GetDecimal(Items.Rows[j]["Rate"]) * Util.GetDecimal(Items.Rows[j]["Quantity"])), Util.GetDecimal(Items.Rows[j]["Quantity"]), Util.GetInt(lblCaseTypeID.Text), con);

                            if (dtPkgDetl != null && Util.GetString(dtPkgDetl.Rows[0]["iStatus"]) != "")
                            {
                                if (Util.GetBoolean(dtPkgDetl.Rows[0]["iStatus"]))
                                {
                                    objLTDetail.Amount = 0;
                                    objLTDetail.DiscountPercentage = 0;
                                    objLTDetail.DiscAmt = 0;
                                    objLTDetail.IsPackage = 1;
                                    objLTDetail.PackageID = Util.GetString(drPkg["PackageID"]);
                                    iCtr = 1;
                                }
                                else
                                {
                                    GetDiscount ds = new GetDiscount();
                                    decimal DiscPerc = ds.GetDefaultDiscount(Items.Rows[j]["SubCategoryID"].ToString(), Util.GetInt(PanelId), System.DateTime.Now, "IPD", "");

                                    if (DiscPerc > 0)
                                    {
                                        decimal GrossAmt = Util.GetDecimal(Items.Rows[j]["Rate"]) * Util.GetDecimal(Items.Rows[j]["Quantity"]);
                                        decimal NetAmount = GrossAmt - ((GrossAmt * DiscPerc) / 100);

                                        objLTDetail.Amount = Util.GetDecimal(NetAmount);
                                        objLTDetail.DiscountPercentage = Util.GetDecimal(DiscPerc);
                                        objLTDetail.DiscAmt = Util.GetDecimal(GrossAmt - NetAmount);
                                        // iCtr = 1;
                                    }
                                    else
                                    {
                                        objLTDetail.DiscountPercentage = Util.GetDecimal(DiscPerc);
                                        objLTDetail.DiscAmt = 0;
                                        objLTDetail.Amount = Util.GetDecimal(Items.Rows[j]["Rate"]) * Util.GetDecimal(Items.Rows[j]["Quantity"]);
                                        //  iCtr = 1;
                                    }
                                }
                            }
                            else
                            {
                                //Check to see if already added items should be shifted to this item if it is a ipd-package
                                if (Util.GetString(Items.Rows[j]["ConfigRelationID"]) == "14")//ipd-package
                                {
                                    if (Is_OldItems_Shifted_To_Pkg == 0)
                                    {
                                        if (Util.GetBoolean(StockReports.SentToIPDPackage(TransactionID, Util.GetString(Items.Rows[j]["ItemID"]),DateTime.Now,1, con)))
                                            Is_OldItems_Shifted_To_Pkg = 1;
                                    }
                                }

                                GetDiscount ds = new GetDiscount();
                                decimal DiscPerc = ds.GetDefaultDiscount(Items.Rows[j]["SubCategoryID"].ToString(), Util.GetInt(PanelId), System.DateTime.Now, "IPD", "");

                                if (DiscPerc > 0)
                                {
                                    decimal GrossAmt = Util.GetDecimal(Items.Rows[j]["Rate"]) * Util.GetDecimal(Items.Rows[j]["Quantity"]);
                                    decimal NetAmount = GrossAmt - ((GrossAmt * DiscPerc) / 100);

                                    objLTDetail.Amount = Util.GetDecimal(NetAmount);
                                    objLTDetail.DiscountPercentage = Util.GetDecimal(DiscPerc);
                                    objLTDetail.DiscAmt = Util.GetDecimal(GrossAmt - NetAmount);
                                    //iCtr = 1;
                                }
                                else
                                {
                                    objLTDetail.DiscountPercentage = Util.GetDecimal(DiscPerc);
                                    objLTDetail.DiscAmt = 0;
                                    objLTDetail.Amount = Util.GetDecimal(Items.Rows[j]["Rate"]) * Util.GetDecimal(Items.Rows[j]["Quantity"]);
                                    iCtr = 1;
                                }

                                //objLTDetail.Amount = 0;
                                //objLTDetail.DiscountPercentage = 0;
                                //objLTDetail.DiscAmt = 0;
                                //objLTDetail.IsPackage = 1;
                                //objLTDetail.PackageID = Util.GetString(dtPkg.Rows[0]["PackageID"]);
                                //iCtr = 1;
                            }
                        }
                    }
                }
                else
                {
                    //Check to see if already added items should be shifted to this item if it is a ipd-package
                    if (Util.GetString(Items.Rows[j]["ConfigRelationID"]) == "14")//ipd-package
                    {
                        if (Is_OldItems_Shifted_To_Pkg == 0)
                        {
                            string str = "Select ItemID from packagemasteripd_details where ItemID='" + Util.GetString(Items.Rows[j]["ItemID"]) + "' and IsActive=1";
                            string PackageID = StockReports.ExecuteScalar(str);

                            if (PackageID != "")
                            {
                                if (Util.GetBoolean(StockReports.SentToIPDPackage(TransactionID, Util.GetString(Items.Rows[j]["ItemID"]),DateTime.Now,1,con)))
                                    Is_OldItems_Shifted_To_Pkg = 1;
                            }
                        }
                    }


                    GetDiscount ds = new GetDiscount();
                    //decimal DiscPerc = ds.GetDefaultDiscount(Items.Rows[j]["SubCategoryID"].ToString(), PanelId, System.DateTime.Now, "IPD", "");
                    decimal DiscPerc = 0;

                    if (DiscPerc > 0)
                    {
                        decimal GrossAmt = Util.GetDecimal(Items.Rows[j]["Rate"]) * Util.GetDecimal(Items.Rows[j]["Quantity"]);
                        decimal NetAmount = GrossAmt - ((GrossAmt * DiscPerc) / 100);

                        objLTDetail.Amount = Util.GetDecimal(NetAmount);
                        objLTDetail.DiscountPercentage = Util.GetDecimal(DiscPerc);
                        objLTDetail.DiscAmt = Util.GetDecimal(GrossAmt - NetAmount);
                    }
                    else
                    {
                        objLTDetail.DiscountPercentage = Util.GetDecimal(DiscPerc);
                        objLTDetail.DiscAmt = 0;
                        objLTDetail.Amount = Util.GetDecimal(Items.Rows[j]["Rate"]) * Util.GetDecimal(Items.Rows[j]["Quantity"]);
                    }
                }

                objLTDetail.StockID = "";
                objLTDetail.IsTaxable = "NO";
                objLTDetail.EntryDate = Util.GetDateTime(Items.Rows[j]["Date"].ToString());
                objLTDetail.TransactionID = TransactionID;
                objLTDetail.UserID = UserID;
                objLTDetail.IsVerified = Util.GetInt(IsVerified);
                objLTDetail.ItemName = Items.Rows[j]["ItemDisplayName"].ToString() + "   " + Items.Rows[j]["ItemCode"].ToString();
                objLTDetail.SubCategoryID = Items.Rows[j]["SubCategoryID"].ToString();
                objLTDetail.Doctor_Id = Items.Rows[j]["Doctor_ID"].ToString();
                objLTDetail.DoctorCharges = Util.GetDecimal(Items.Rows[j]["DocCharges"].ToString());
                objLTDetail.CentreID = Util.GetInt(Session["CentreID"].ToString());
                //objLTDetail.HospCentreID = Util.GetInt(Session["HospCentreID"].ToString());
                string LedgerTnxID = objLTDetail.Insert().ToString();

                Items.Rows[j]["LedgerTransactionNo"] = LedTxnID;
            }

            return Items;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.Equals(ex);
            return null;
        }
    }
    public DataTable GetPatientEMGInformation(string PatientID, string TranactionID)
    {
        DataTable Items = new DataTable();
        
        try
        {
            
            string strQuery = "";
            strQuery = "Select pmh.DischargeType,ifnull(DATE_FORMAT(pm.MemberShipDate,'%d-%b-%y'),'')MemberShipDate, IF(DATE(pm.MemberShipDate)<CURDATE() AND IFNULL(pm.MemberShip,'')<>'','Membership Card is Expired !','')IsMemberShipExpire,IF(DATE(pm.MemberShipDate)>=CURDATE(),IFNULL(pm.MemberShip,''),'')MemberShipCardNo,pm.Gender,pm.bloodgroup,PM.Title,PM.PName,PM.Age,PMH.PatientID,PMH.DoctorID,PMH.ScheduleChargeID,CONCAT(RM.Floor,'/',RM.Name)RoomNo,FPM.Company_Name,PMH.TransactionID,FPM.ReferenceCode,PIP.IPDCaseTypeID,FPM.PanelID,PIP.RoomID,PMH.Employeeid,PMH.PolicyNo,PMH.CardNo,PMH.Patient_Type PatientType,pmh.PatientTypeID from (Select TransactionID,RoomID,IPDCaseTypeID IPDCaseTypeID from emergency_patient_details Where TransactionID = '" + TranactionID + "' ORDER BY id DESC LIMIT 1) PIP,(Select PatientID,TransactionID,PanelID,DoctorID,ScheduleChargeID,Employeeid,PolicyNo,CardNo,Patient_Type,PatientTypeID,IFNULL(DischargeType,'')DischargeType FROM patient_medical_history Where ";
         
           if (PatientID == "" && TranactionID != "")
                strQuery = strQuery + "TransactionID = '" + TranactionID + "' and ";

            strQuery = strQuery + "Type='EMG' )PMH,(Select bloodgroup,Title,PName,PatientID,Gender,MemberShipDate,MemberShip,Age from patient_master ";

            if (PatientID != "")
                strQuery = strQuery + "Where PatientID ='" + PatientID + "'";
            strQuery = strQuery + ") PM ,room_master RM,f_panel_master FPM Where PM.PatientID = PMH.PatientID and PMH.TransactionID = PIP.TransactionID and PIP.RoomID = RM.RoomID and PMH.PanelID = FPM.PanelID order by PM.PName";
            Items = StockReports.GetDataTable(strQuery.ToString());
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
           
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return null;
        }
    }
}
