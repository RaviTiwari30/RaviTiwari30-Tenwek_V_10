using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using AjaxControlToolkit;
using System.Web.Services;

public partial class Design_IPD_IPDPackageBilling : System.Web.UI.Page
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
            string TID = Request.QueryString["TransactionID"].ToString();
            AllQuery AQ = new AllQuery();
            DataTable dt = AQ.GetPatientAdjustmentDetails(TID);
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
                    else if (dt.Rows[0]["IsBillFreezed"].ToString().Trim() == "1" && (dtAuthoritys != null && dtAuthoritys.Rows.Count == 0))
                    {
                        string Msg = "";
                        Msg = "You Are Not Authorised To AMEND This IPD Bills...";
                        Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);

                    }
                }
            }

            //===================================================

            ToolkitScriptManager1.SetFocus(ddlCategory);
            All_LoadData.bindDoctor(cmbRefferedBy);
            BindPatientDetails(TID);
            LoadCategory();
            LoadItems();
            BindItems();
            CreateTable();
            ViewState.Add("dtItem", dtItem);
            ViewState["IsSelected"] = 0;
            getPrescribedPackage(lblTransactionNo.Text.Trim());

            fromDatetoDate(lblTransactionNo.Text.Trim(), ucDate, toDate, calucDate, caltoDate);
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
        toDate.Attributes.Add("readOnly", "true");
    }

    public void fromDatetoDate(string TID, TextBox ucDate, TextBox toDate, CalendarExtender calucDate, CalendarExtender caltoDate)
    {
        AllQuery aq = new AllQuery();
        DateTime AdmitDate = Util.GetDateTime(aq.getAdmitDate(TID));
        DateTime dischargeDate = Util.GetDateTime(AllQuery.getDischargeDate(TID));
        string disDate = Util.GetString(dischargeDate.ToString("dd-MM-yyyy"));
        if (Util.GetString(dischargeDate.ToString("dd-MM-yyyy")) == "01-01-0001")
        {
            ucDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            toDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            // caltoDate.EndDate = DateTime.Now;


            calucDate.EndDate = DateTime.Now;
        }
        else
        {
            ucDate.Text = dischargeDate.ToString("dd-MMM-yyyy");
            toDate.Text = dischargeDate.ToString("dd-MMM-yyyy");
            //    caltoDate.EndDate = Util.GetDateTime(dischargeDate.ToString("dd-MMM-yyyy"));
            calucDate.EndDate = Util.GetDateTime(dischargeDate.ToString("dd-MMM-yyyy"));
        }
        calucDate.StartDate = Util.GetDateTime(AdmitDate.ToString("dd-MMM-yyyy"));
        caltoDate.StartDate = Util.GetDateTime(AdmitDate.ToString("dd-MMM-yyyy"));
    }

    private void LoadCategory()
    {
        string ConfigIDs = "14";
        ddlCategory.Items.AddRange(LoadItems(CreateStockMaster.LoadCategoryByCategoryID(CreateStockMaster.LoadCategoryByConfigID(ConfigIDs))));
        ddlCategory.DataBind();
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
          //  string ConfigIDs = "2,6,8,9,10,20,24,14,26,27,29";
            string str ="SELECT  CONCAT(IFNULL(im.ItemCode,''),' # ', IM.TypeName)    TypeName," +
            " CONCAT(IFNULL(IM.ItemID,''),'#',IFNULL(IM.SubCategoryID,''),'#', IFNULL(SC.Name,''),'#',IFNULL(Type_ID,''),'#',im.RateEditable,'#',pid.PanelID)ItemID,IM.SubCategoryID,SC.CategoryID,IM.TypeName ProName,IM.ItemID NewItemID,SC.Name,im.RateEditable,im.Type_ID  " +
            " FROM f_itemmaster im  "+
            " INNER JOIN packagemasteripd pid ON pid.ItemID = im.itemid"+
            " INNER JOIN f_subcategorymaster sc ON im.SubCategoryID = sc.SubCategoryID AND sc.Active=1"+
            " INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID " +
            " WHERE im.IsActive=1 AND cf.ConfigID IN (14) AND FIND_IN_SET('" + lblPanelID.Text + "',panelID) ORDER BY TypeName";
           // dtMain = CreateStockMaster.LoadItemSubCategoryByCategoryConfigID(ConfigIDs);
            dtMain = StockReports.GetDataTable(str);
            ViewState.Add("dtMain", dtMain);
        }
        catch (Exception ex)
        {
            ClassLog objCL = new ClassLog();
            objCL.errLog(ex);
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
            dtItem.Columns.Add("DoctorID");
            dtItem.Columns.Add("Name");
            dtItem.Columns.Add("DocCharges");
            dtItem.Columns.Add("TnxTypeID");
            dtItem.Columns.Add("ConfigID");
            dtItem.Columns.Add("NonPayable", typeof(int));
            dtItem.Columns.Add("RateListID");
            dtItem.Columns.Add("isPayable");
            dtItem.Columns.Add("PanelWiseDisc");
            dtItem.Columns.Add("FromDate");
            dtItem.Columns.Add("ToDate");
            dtItem.Columns.Add("CoPayment");
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
                string Ref_Code, PanelID, IPDCaseType_ID, TID, PID;
                PanelID = lblPanelID.Text.Trim();
                IPDCaseType_ID = lblCaseTypeID.Text.Trim();
                TID = lblTransactionNo.Text.Trim();
                PID = lblPatientID.Text.Trim();
                Ref_Code = lblReferenceCode.Text.Trim();

                //Create Table to store rate of Items
                UpdateItem();
                DataTable dtTemp = new DataTable();
                StringBuilder sbPkg = new StringBuilder();
                for (int i = 0; i < dtItem.Rows.Count; i++)
                {
                    dtTemp = IPDBilling.LoadItemsHavingRateFixed("'" + dtItem.Rows[i]["ItemID"].ToString() + "'", Ref_Code, IPDCaseType_ID, ViewState["ScheduleChargeID"].ToString(),Session["CentreID"].ToString());
                    if (dtTemp != null && dtTemp.Rows.Count > 0)
                    {
                        // dtItem.Rows[i]["Rate"] = dtTemp.Rows[0]["Rate"].ToString();
                        if (Util.GetString(dtTemp.Rows[0]["ItemDisplayName"]) != "")
                            dtItem.Rows[i]["ItemDisplayName"] = dtTemp.Rows[0]["ItemDisplayName"].ToString();
                        else
                            dtItem.Rows[i]["ItemDisplayName"] = dtItem.Rows[i]["Item"].ToString();

                        dtItem.Rows[i]["ItemCode"] = dtTemp.Rows[0]["ItemCode"].ToString();
                        dtItem.Rows[i]["ConfigID"] = dtTemp.Rows[0]["ConfigID"].ToString();
                        dtItem.Rows[i]["RateListID"] = dtTemp.Rows[0]["ID"].ToString();
                    }
                    else
                    {
                        //dtItem.Rows[i]["Rate"] = "0";
                        dtItem.Rows[i]["ItemDisplayName"] = dtItem.Rows[i]["Item"].ToString();
                        dtItem.Rows[i]["ItemCode"] = string.Empty;
                        dtItem.Rows[i]["RateListID"] = "0";
                        dtItem.Rows[i]["ConfigID"] = "14";
                    }

                    int Count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select COUNT(*) from f_ipd_package_detail where TransactionID='" + TID + "' AND PackageID='" + Util.GetString(dtItem.Rows[i]["ItemID"]) + "' and isactive =1 "));
                    if (Count > 0)
                    {
                        lblMsg.Text = "Package Already Precribed!";
                        return;
                    }



                }
                string IsVerified = "1";

                dtItem = IPDBilling.UpdateLedgerForIPDBilling(dtItem, PID, "IPD-Billing", Util.GetInt(PanelID), ViewState["ID"].ToString(), TID, Util.GetString(Session["HOSPID"].ToString()), "Yes", IsVerified, tnx, lblCaseTypeID.Text, lblPatientType.Text.Trim(), con, lblRoomID.Text.Trim());
                try
                {
                    int Is_OldItems_Shifted_To_Pkg = 0;
                    if (dtItem != null)
                    {
                        for (int i = 0; i < dtItem.Rows.Count; i++)
                        {
                            sbPkg.Clear();
                            sbPkg.Append(" INSERT INTO f_ipd_package_detail(TransactionID,PanelID,FromDate,ToDate,PackageID,LedgerTnxNo,PrescribedDate,PrescribedBy)");
                            sbPkg.Append(" VALUES('" + TID + "'," + PanelID + ",'" + Util.GetDateTime(dtItem.Rows[i]["FromDate"]).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(dtItem.Rows[i]["ToDate"]).ToString("yyyy-MM-dd") + "',");
                            sbPkg.Append(" '" + Util.GetString(dtItem.Rows[i]["ItemID"]) + "','" + Util.GetString(dtItem.Rows[i]["LedgerTransactionNo"]) + "',Now(),'" + Util.GetString(ViewState["ID"]) + "')");
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbPkg.ToString());


                            if (Util.GetString(dtItem.Rows[i]["ConfigID"]) == "14")//ipd-package
                            {
                                if (Is_OldItems_Shifted_To_Pkg == 0)
                                {
                                    string str = "Select ItemID from packagemasteripd_details where ItemID='" + Util.GetString(dtItem.Rows[i]["ItemID"]) + "' and IsActive=1";
                                    string PackageID = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, str));

                                    if (PackageID != "")
                                    {
                                        //Getting all already prescribed not packaged items to be if required sifted to given package
                                        DataTable dtLed = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "Select ItemID,Rate,Quantity,LedgerTnxID,EntryDate from f_ledgertnxdetail where TransactionID='" + TID + "' and Isverified=1 and IsPackage=0 and Date(EntryDate)>='" + Util.GetDateTime(ucDate.Text).ToString("yyyy-MM-dd") + "' and Date(EntryDate)<='" + Util.GetDateTime(toDate.Text).ToString("yyyy-MM-dd") + "'").Tables[0];

                                        if (dtLed != null && dtLed.Rows.Count > 0)
                                        {
                                            foreach (DataRow row in dtLed.Rows)
                                            {
                                                decimal Rate = Util.GetDecimal(row["Rate"]);
                                                decimal Qty = Util.GetDecimal(row["Quantity"]);
                                                decimal Amount = Rate * Qty;

                                                DataTable dt = new DataTable();

                                                dt = StockReports.ShouldSendToIPDPackage(TID, Util.GetString(dtItem.Rows[i]["ItemID"]), row["ItemID"].ToString(), Amount, Util.GetDecimal(Qty), Util.GetInt(lblCaseTypeID.Text), con);
                                            
                                                if (dt != null && dt.Rows.Count > 0)
                                                {
                                                    if (Util.GetBoolean(dt.Rows[0]["iStatus"]))
                                                    {
                                                        string strQuery = "Update f_ledgertnxdetail Set IsPackage=1,";
                                                        strQuery += "Amount=0, PackageID='" + Util.GetString(dtItem.Rows[i]["ItemID"]) + "' Where LedgerTnxID='" + row["LedgerTnxID"].ToString() + "'";
                                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strQuery).ToString();
                                                    }

                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        tnx.Commit();
                        tnx.Dispose();
                        con.Close();
                        con.Dispose();
                       // ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
                        lblMsg.Text = "Record Save Successfully";
                        grdItemRate.DataSource = "";
                        grdItemRate.DataBind();
                        dtItem.Rows.Clear();
                        ViewState.Add("dtItem", dtItem);
                        pnlhide.Visible = false;

                    }

                    else
                    {
                        tnx.Rollback();
                        tnx.Dispose();
                        con.Close();
                        con.Dispose();
                        lblMsg.Text = "Error Occurred. Please Concat to Administrator";

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
                    lblMsg.Text = "Error Occurred. Please Concat to Administrator";
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
        txtQty.Text = string.Empty;
        ddlCategory.SelectedIndex = 0;
        ListBox1.Items.Clear();
        txtCPTCodeSearch.Text = "";
        txtFirstNameSearch.Text = "";
        txtInBetweenSearch.Text = "";
        //if (ddlCategory.SelectedItem.Value.ToUpper() != "ALL")
        //{
        //    ListBox1.Items.AddRange(LoadItems(CreateStockMaster.LoadItemsSubCategoryByCategoryID(ddlCategory.SelectedItem.Value)));
        //    ListBox1.DataBind();
        //}
        //else
        //{
            DataTable dt = (DataTable)ViewState["dtMain"];
            ListBox1.DataSource = dt;
            ListBox1.DataTextField = "TypeName";
            ListBox1.DataValueField = "ItemID";
            ListBox1.DataBind();
       // }
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
    }

    protected void btnSelect_Click(object sender, EventArgs e)
    {
        try
        {

            lblMsg.Text = string.Empty;
            AllQuery AQ = new AllQuery();
            string AdmitDate = AQ.getAdmitDate(lblTransactionNo.Text.Trim());

            string PrescribeDate = Util.GetDateTime(toDate.Text).ToString("yyyy-MM-dd");
            //int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_ledgertnxdetail WHERE itemID='" + Resources.Resource.OTItemID + "' AND IsVerified=1 AND TransactionID='" + lblTransactionNo.Text.Trim() + "' "));
            //if (count > 0)
            //{
            //    ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('This Item Already Prescribed By Another User');", true);
            //}
            if (Util.GetDateTime(PrescribeDate) < Util.GetDateTime(AdmitDate))
            {
                lblMsg.Text = "Given Date is less then Admit Date";
                return;
            }

            if (cmbRefferedBy.SelectedItem.Text != "-" && txtDocCharges.Text.Trim() == string.Empty)
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
            string PanelID = lblPanelID.Text.Trim();
            string IPDCaseType_ID = lblCaseTypeID.Text.Trim();
            string TID = lblTransactionNo.Text.Trim();
            string PID = lblPatientID.Text.Trim();
            string Ref_Code = lblReferenceCode.Text.Trim();
            string ItemID = ListBox1.Items[ListBox1.SelectedIndex].Value.Split('#')[0].ToString();


            //int ValidityDays = Util.GetInt(StockReports.ExecuteScalar("SELECT ifnull(DaysInvolved,0)DaysInvolved FROM packagemasteripd where ItemID='" + ItemID + "'"));
            //DateTime FromDate = Util.GetDateTime(ucDate.Text);
            //DateTime ToDate = Util.GetDateTime(toDate.Text);
            //TimeSpan diff = ToDate - FromDate;
            //if (diff.TotalDays > ValidityDays)
            //{
            //    lblMsg.Text = "Package Validity is "+ValidityDays+" Days . Please Select Correct Date...!!!";
            //    return;
            //}

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
                string PanelID = lblPanelID.Text.Trim();
                string IPDCaseType_ID = lblCaseTypeID.Text.Trim();
                string Ref_Code = lblReferenceCode.Text.Trim();
                string ItemID = ListBox1.Items[ListBox1.SelectedIndex].Value;// ListBox1.SelectedItem.Value.Split('#')[2];
                string ItemName = ListBox1.Items[ListBox1.SelectedIndex].Text.Split('#')[1];
                string startDate = Util.GetDateTime(Util.GetDateTime(ucDate.Text)).ToString("yyyy-MM-dd");
                string EndDate = Util.GetDateTime(Util.GetDateTime(toDate.Text)).ToString("yyyy-MM-dd");
                DateTime start = DateTime.Parse(startDate);
                DateTime end = DateTime.Parse(EndDate);
                int patientTypeId = Util.GetInt(lblPatientType_ID.Text);
                //Calculate difference between start and end date.
                TimeSpan difference = end.Subtract(start);
                //for (DateTime counter = start; counter <= end; counter = counter.AddDays(1))
                //{
                DataRow dr = dtItem.NewRow();
                dr["Category"] = ddlCategory.SelectedItem.Text;
                dr["SubCategory"] = ItemID.Split('#')[2].ToString(); //ListBox1.SelectedItem.Value.Split('#')[2];
                dr["ItemID"] = ItemID.Split('#')[0].ToString(); //ListBox1.SelectedItem.Value.Split('#')[0];
                dr["Item"] = ItemName;// ListBox1.SelectedItem.Text;
                dr["Quantity"] = txtQty.Text.Trim();
                var dataTableCoPayDiscont = AllLoadData_IPD.getIPDPanelDiscPer(Util.GetInt(PanelID), Util.GetString(ItemID.Split('#')[0].ToString()), patientTypeId);

                //Getting Rates
                DataTable dtTemp = IPDBilling.LoadItemsHavingRateFixed("'" + dr["ItemID"].ToString() + "'", Ref_Code, IPDCaseType_ID, ViewState["ScheduleChargeID"].ToString(),Session["CentreID"].ToString());

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

                // dr["Date"] = Util.GetDateTime(ucDate.Text).ToString("dd-MMM-yyyy") + " " + DateTime.Now.ToShortTimeString();
                dr["Date"] = Util.GetDateTime(startDate).ToString("dd-MMM-yyyy");
                //dr["Date"] = Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd h:mmtt"));
                dr["SubCategoryID"] = ItemID.Split('#')[1].ToString(); //ListBox1.SelectedItem.Value.Split('#')[1];

                dr["FromDate"] = Util.GetDateTime(startDate).ToString("dd-MMM-yyyy");
                dr["ToDate"] = Util.GetDateTime(EndDate).ToString("dd-MMM-yyyy");


                if (lblDoctorID.Text.Trim() != cmbRefferedBy.SelectedItem.Value.Trim())
                {
                    dr["DoctorID"] = cmbRefferedBy.SelectedItem.Value;
                    dr["Name"] = cmbRefferedBy.SelectedItem.Text;
                    dr["DocCharges"] = txtDocCharges.Text.Trim();
                }
                else
                {
                    dr["DoctorID"] = lblDoctorID.Text;
                    dr["Name"] = StockReports.GetDoctorNameByDoctorID(lblDoctorID.Text);
                    dr["DocCharges"] = "0.00";
                }

                dr["TnxTypeID"] = "7";
                if (lblPanelID.Text == "1")
                    dr["isPayable"] = "false";
                else
                    dr["isPayable"] = "true";

                //  decimal DiscPerc = Util.GetDecimal(AllLoadData_IPD.getIPDPanelDiscPer(Util.GetInt(PanelID), Util.GetString(dr["ItemID"]), "I", null));
                decimal DiscPerc = 0;


                if (Resources.Resource.IsmembershipInIPD == "1")
                {
                    if (PanelID == "1")
                    {
                        if (lblMembership.Text != "")
                        {
                            GetDiscount ds = new GetDiscount();
                            DiscPerc = Util.GetDecimal(ds.GetDefaultDiscount_Membership(Util.GetString(dr["ItemID"]), lblMembership.Text, "IPD").Split('#')[0].ToString());
                        }
                        else
                            DiscPerc = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);

                    }
                    else
                        DiscPerc = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);

                }
                else
                    DiscPerc = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);





                if (DiscPerc > 0)
                    dr["PanelWiseDisc"] = DiscPerc;
                else
                    dr["PanelWiseDisc"] = 0;


                dr["isPayable"] = Util.GetInt(dataTableCoPayDiscont.Rows[0]["IsPayble"]);
                dr["CoPayment"] = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDCoPayPercent"]);


                dtItem.Rows.Add(dr);
                ViewState.Add("dtItem", dtItem);
                //}
            }
            if (dtItem != null && dtItem.Rows.Count > 0)
            {
                grdItemRate.DataSource = dtItem;
                grdItemRate.DataBind();
                pnlhide.Visible = true;
            }
            txtQty.Text = "1";
            ViewState["IsSelected"] = 0;

        }
        catch (Exception ex)
        {
            ClassLog objClass = new ClassLog();
            objClass.errLog(ex);
        }
    }
    private void BindPatientDetails(string TransactionID)
    {
        try
        {
            AllQuery AQ = new AllQuery();
            DataTable dt = AQ.GetPatientIPDInformation("", TransactionID);
            if (dt != null && dt.Rows.Count > 0)
            {
                if (Resources.Resource.IsmembershipInIPD == "1")
                {
                    lblMsg.Text = dt.Rows[0]["IsMemberShipExpire"].ToString();
                    lblMembership.Text = dt.Rows[0]["MemberShipCardNo"].ToString();
                }
                else
                {
                    lblMsg.Text = "";
                    lblMembership.Text = "";
                }
                lblPatientID.Text = dt.Rows[0]["PatientID"].ToString();
                lblTransactionNo.Text = dt.Rows[0]["TransactionID"].ToString();
                lblCaseTypeID.Text = dt.Rows[0]["IPDCaseTypeID"].ToString();
                lblReferenceCode.Text = dt.Rows[0]["ReferenceCode"].ToString();
                lblPanelID.Text = dt.Rows[0]["PanelID"].ToString();
                lblDoctorID.Text = dt.Rows[0]["DoctorID"].ToString();
                ViewState["ScheduleChargeID"] = dt.Rows[0]["ScheduleChargeID"].ToString();
                cmbRefferedBy.SelectedIndex = cmbRefferedBy.Items.IndexOf(cmbRefferedBy.Items.FindByValue(dt.Rows[0]["DoctorID"].ToString()));
                lblPatientType.Text = dt.Rows[0]["PatientType"].ToString();
                lblRoomID.Text = dt.Rows[0]["RoomID"].ToString();
                lblPatientType_ID.Text = dt.Rows[0]["PatientTypeID"].ToString();
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
        grdItemRate.DataSource = dtitemforChk;
        grdItemRate.DataBind();
        ViewState["IsSelected"] = 0;
        pnlhide.Visible = true;
    }
    protected void Button2_Click(object sender, EventArgs e)
    {
        DataTable dtChkCancel = (DataTable)ViewState["dtItemForChk"];
        int count = dtChkCancel.Rows.Count;
        dtChkCancel.Rows[count - 1].Delete();
        ViewState["dtItems"] = dtChkCancel;
    }
    private void UpdateItem()
    {
        if (ViewState["dtItem"] != null)
        {
            DataTable dtItem = (DataTable)ViewState["dtItem"];
            for (int j = 0; j < grdItemRate.Rows.Count; j++)
            {
                decimal Qty = Util.GetDecimal(((TextBox)grdItemRate.Rows[j].FindControl("txtQuantity")).Text);
                if (Qty != 0)
                    dtItem.Rows[j]["Quantity"] = Qty;
                else
                    dtItem.Rows[j]["Quantity"] = 1;
                decimal Rate = Util.GetDecimal(((TextBox)grdItemRate.Rows[j].FindControl("txtRate")).Text);
                dtItem.Rows[j]["Rate"] = Rate;
                dtItem.Rows[j]["TotalAmt"] = Rate * Qty;
                dtItem.Rows[j]["NonPayable"] = Util.GetInt(((CheckBox)grdItemRate.Rows[j].FindControl("chkNonPayable")).Checked ? 1 : 0);
            }
            dtItem.AcceptChanges();
            ViewState["dtItem"] = dtItem;
        }
    }


    [WebMethod]
    public static string getPackageDetail(string ItemID)
    {
        StringBuilder str = new StringBuilder();
        str.Append(" SELECT ifnull(pmi.DaysInvolved,0) ValidityDays FROM packagemasteripd pmi WHERE pmi.ItemID='" + ItemID + "'");
        DataTable dt = StockReports.GetDataTable(str.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    
    private void getPrescribedPackage(string IPDNo)
    {
        DataTable dt = StockReports.GetDataTable("SELECT ItemID ID ,itemname NAME FROM f_ledgertnxdetail ltd WHERE TransactionID='"+IPDNo+"' AND isverified<>2 AND ispackage=0 AND ConfigID=14 ");
       ddlPrescribedPackages.DataSource = dt;
       ddlPrescribedPackages.DataTextField = "NAME";
       ddlPrescribedPackages.DataValueField = "ID";
       ddlPrescribedPackages.DataBind();
       ddlPrescribedPackages.Items.Insert(0, new ListItem("Select", "0"));
    }

    [WebMethod]
    public static string bindPackageDetail(string IPDNo,string PackageID)
    {
        DataTable dt = StockReports.GetDataTable("CALL get_IPDPackageServiceStatus('" + IPDNo + "','" + PackageID.Trim() + "')");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


}
