using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_IPD_bbankService : System.Web.UI.Page
{
    private DataTable dtItem;
    private DataTable dtMain;

    //int count = 0;
    public int Flag = 0;

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
            ViewState["CentreID"] = Session["CentreID"].ToString();
            //Checking if patient's bill No is generated or not
            // if generated then nothing to him can be prescribed
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
            ViewState["TransID"] = TID;
            //===================================================

            //string PID=Request.QueryString["PatientID"].ToString();
            ToolkitScriptManager1.SetFocus(ddlCategory);
            // txtQty.Attributes.Add("onKeyPress", "doClick('" + btnSelect.ClientID + "',event)");
            txtSearch.Attributes.Add("onKeyPress", "doClick('" + btnSelect.ClientID + "',event)");
            //Binding Patient Details
            ddlCategory.Focus();
            BindBloodGroup();
            RefferedByBind();
            BindPatientDetails(TID);
            LoadCategory();
            LoadItems();
            BindItems();
            CreateTable();
            BindRequestDetails(TID);
            DateTime AdmitDate = Util.GetDateTime(AQ.getAdmitDate(lblTransactionNo.Text.Trim()));
            ucDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            calucDate.StartDate = Util.GetDateTime(AdmitDate.ToString("dd-MMM-yyyy"));
            calucDate.EndDate = Util.GetDateTime(DateTime.Now).AddDays(3);
            txtReserveTime.Text = Util.GetDateTime(DateTime.Now).ToString("hh:mm tt");

            // calucDate.EndDate = DateTime.Now;
            ViewState.Add("dtItem", dtItem);
            //Validation();
            ViewState["IsSelected"] = 0;
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
        DataTable dt = StockReports.GetDataTable("Select sc.Name,sc.CategoryID from f_configrelation cf inner join f_subcategorymaster sc on cf.CategoryID = sc.CategoryID where sc.Active=1 and cf.ConfigID=7 and Ucase(sc.DisplayName)='BLOOD BANK'");

        ddlCategory.DataSource = dt;
        ddlCategory.DataTextField = "Name";
        ddlCategory.DataValueField = "CategoryID";
        ddlCategory.DataBind();

        ddlCategory.Items.Insert(0, new ListItem("ALL", "ALL"));
    }

    public void RefferedByBind()
    {
        DataTable dt = All_LoadData.bindDoctor();
        if (dt.Rows.Count > 0)
        {
            cmbRefferedBy.DataSource = dt;
            cmbRefferedBy.DataTextField = "Name";
            cmbRefferedBy.DataValueField = "DoctorID";
            cmbRefferedBy.DataBind();
        }
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
            string strQuery = "SELECT IM.TypeName,CONCAT(IFNULL(IM.ItemID,''),'#',IFNULL(IM.SubCategoryID,''),'#', IFNULL(SC.Name,''),'#',IFNULL(Type_ID,''))ItemID,IM.SubCategoryID,SC.CategoryID FROM f_itemmaster im INNER JOIN `f_itemmaster_centerwise` itc ON itc.`ItemID`=im.`ItemID` INNER JOIN f_subcategorymaster sc ON im.SubCategoryID = sc.SubCategoryID INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID LEFT JOIN f_item_outsource io ON im.ItemID = io.ItemID AND io.IsActive=1 WHERE im.IsActive=1 AND itc.`IsActive`=1 AND itc.CentreID='" + Session["CentreID"].ToString() + "' AND cf.ConfigID =7 and ucase(sc.DisplayName)='BLOOD BANK' AND io.ItemID IS NULL ORDER BY TypeName ";

            dtMain = StockReports.GetDataTable(strQuery);

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

            sb.Append("SELECT IM.TypeName,CONCAT(IFNULL(IM.ItemID,''),'#',IFNULL(IM.SubCategoryID,''),'#', IFNULL(SC.Name,''),'#',IFNULL(Type_ID,''))ItemID,IM.SubCategoryID,SC.CategoryID FROM f_itemmaster im INNER JOIN f_subcategorymaster sc ON im.SubCategoryID = sc.SubCategoryID INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID LEFT JOIN f_item_outsource io ON im.ItemID = io.ItemID AND io.IsActive=1 WHERE im.IsActive=1 AND cf.ConfigID =7 and ucase(sc.Displayname)='BLOOD BANK' AND io.ItemID IS NULL ");

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
            dtItem.Columns.Add("SubCategoryID");
            dtItem.Columns.Add("Date");
            dtItem.Columns.Add("ItemDisplayName");
            dtItem.Columns.Add("ItemCode");
            dtItem.Columns.Add("DoctorID");
            dtItem.Columns.Add("Name");
            dtItem.Columns.Add("DocCharges");
            dtItem.Columns.Add("TnxTypeID");
            dtItem.Columns.Add("ConfigID");
            dtItem.Columns.Add("ReserveTime");



            dtItem.Columns.Add(new DataColumn("PID"));
            dtItem.Columns.Add(new DataColumn("TID"));
            dtItem.Columns.Add(new DataColumn("RoomType"));
            dtItem.Columns.Add(new DataColumn("RoomNo"));
            dtItem.Columns.Add(new DataColumn("PName"));
            dtItem.Columns.Add(new DataColumn("CTBNo"));
            dtItem.Columns.Add(new DataColumn("Panel"));

            // dtItem.Columns.Add(new DataColumn("Date"));
            dtItem.Columns.Add(new DataColumn("DocName"));
            dtItem.Columns.Add(new DataColumn("DocDepartment"));
            dtItem.Columns.Add(new DataColumn("username"));
            dtItem.Columns.Add(new DataColumn("header"));
            dtItem.Columns.Add(new DataColumn("RateListID"));
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
                DataTable dtTemp = new DataTable();

                for (int i = 0; i < dtItem.Rows.Count; i++)
                {
                    dtTemp = IPDBilling.LoadItemsHavingRateFixed("'" + dtItem.Rows[i]["ItemID"].ToString() + "'", Ref_Code, IPDCaseType_ID, ViewState["ScheduleChargeID"].ToString(), ViewState["CentreID"].ToString());

                    if (dtTemp != null && dtTemp.Rows.Count > 0)
                    {
                        dtItem.Rows[i]["Rate"] = dtTemp.Rows[0]["Rate"].ToString();
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
                        dtItem.Rows[i]["Rate"] = "0";
                        dtItem.Rows[i]["ItemDisplayName"] = dtItem.Rows[i]["Item"].ToString();
                        dtItem.Rows[i]["ItemCode"] = "";
                        dtItem.Rows[i]["RateListID"] = 0;
                    }
                }
                string IsVerified = "1";
                 dtItem = IPDBilling.UpdateLedgerForIPDBilling(dtItem, PID, "IPD-Billing",Util.GetInt( PanelID), ViewState["ID"].ToString(), TID, Util.GetString(Session["HOSPID"].ToString()), "Yes", IsVerified, tnx, IPDCaseType_ID,lblPatientType.Text.Trim(),con,lblRoomID.Text.Trim());


                //Insert in ipdservices_request

                for (int a = 0; a < dtItem.Rows.Count; a++)
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append(" INSERT INTO ipdservices_request (SubcategoryID,ItemName,ItemID,Rate,Quantity,DiscountAmt,DiscountPer,Amount,ServiceDate,ServiceTime, ");
                    sb.Append(" DoctorID,PanelID,TypeID,TYPE,EntryBy,LedgerTnxNo,ConfigID,PanelCurrencyCountryID,PanelCurrencyFactor,CentreID,TransactionID,PatientID,RoleID,Patient_Type) ");
                    sb.Append(" VALUES('" + dtItem.Rows[a]["SubCategoryID"].ToString() + "','" + dtItem.Rows[a]["Item"].ToString() + "','" + dtItem.Rows[a]["ItemID"].ToString() + "'," + Util.GetDecimal(dtItem.Rows[a]["Rate"].ToString()) + "," + Util.GetDecimal(dtItem.Rows[a]["Quantity"].ToString()) + ",");
                    sb.Append(" 0,0," + Util.GetDecimal(dtItem.Rows[a]["Rate"]) * Util.GetDecimal(dtItem.Rows[a]["Quantity"]) + ",'" + Util.GetDateTime(dtItem.Rows[a]["Date"].ToString()).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(dtItem.Rows[a]["ReserveTime"].ToString()).ToString("HH:mm:ss") + "',");
                    sb.Append(" '" + dtItem.Rows[a]["DoctorID"].ToString() + "', " + Util.GetInt(PanelID) + ", " + dtItem.Rows[a]["TnxTypeID"].ToString() + ",'BB','" + ViewState["ID"].ToString() + "','" +Util.GetInt(dtItem.Rows[a]["LedgerTransactionNo"].ToString()) + "'," + Util.GetInt(dtItem.Rows[a]["ConfigID"]) + ",");
                    sb.Append(" 0,0," + Util.GetInt(ViewState["CentreID"].ToString()) + ",'" + TID + "','" + PID + "'," + Util.GetInt(Session["RoleID"]) + ",'IPD') ");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                }


                // Notification_Insert.notificationInsert(6, dtItem.Rows[0]["LedgerTransactionNO"].ToString(), tnx, "", IPDCaseType_ID, 0, "");

                //DataTable dt = StockReports.GetDataTable("Select (Select concat(Title,' ',Pname) from patient_master where PatientID=pmh.PatientID)PatientName,(Select concat(Title,' ',Name) from doctor_master where DoctorID=pmh.DoctorID)DoctorName,(Select distinct Department from Doctor_hospital where DoctorID = pmh.DoctorID)DoctorDept,(Select concat(Title,' ',Name) from Employee_master where Employee_ID = '" + ViewState["ID"].ToString() + "')EmpName,(Select Name from ipd_case_type_master where IPDCaseType_ID = '" + IPDCaseType_ID + "')RoomType,(SELECT CONCAT(rm.Floor,'/',rm.Name,'/',rm.Room_No)Room FROM room_master rm INNER JOIN patient_ipd_profile pip ON pip.Room_ID = rm.Room_Id WHERE pip.TransactionID='" + TID + "' and pip.status='IN')Room  from (Select PatientID,DoctorID from patient_medical_history where TransactionID = '" + TID + "')pmh");
                //MySqlParameter parm = new MySqlParameter("@CTB_No", "");
                //parm.Direction = ParameterDirection.Output;
                string CTBNo = "";
                // CTBNo = MySqlHelper.ExecuteScalar(con, CommandType.StoredProcedure, "f_Generate_CTB_No", parm).ToString();

                // StockReports.ExecuteDML("INSERT INTO f_ctb(LagerTransactionNo,CTBNo,UserID)VALUES('" + dtItem.Rows[0]["LedgerTransactionNO"].ToString() + "','" + CTBNo + "','" + ViewState["ID"].ToString() + "')");

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
                        BindRequestDetails(TID);
                        //dtItem.Columns["PID"].DefaultValue = PID;
                        //dtItem.Columns["Tid"].DefaultValue = TID;
                        //dtItem.Columns["CTBNo"].DefaultValue = CTBNo;
                        //dtItem.Columns["RoomType"].DefaultValue = dt.Rows[0]["RoomType"].ToString();
                        //dtItem.Columns["PName"].DefaultValue = dt.Rows[0]["PatientName"].ToString();
                        //dtItem.Columns["DocName"].DefaultValue = dt.Rows[0]["DoctorName"].ToString();
                        //dtItem.Columns["DocDepartment"].DefaultValue = dt.Rows[0]["DoctorDept"].ToString();
                        //dtItem.Columns["username"].DefaultValue = dt.Rows[0]["EmpName"].ToString();
                        //dtItem.Columns["header"].DefaultValue = "I.P.D. Blood Bank Charge Slip";

                        //dtItem.Rows[0]["PID"] = PID;
                        //dtItem.Rows[0]["TID"] = TID;
                        //dtItem.Rows[0]["Panel"] = Util.GetString(StockReports.ExecuteScalar("SELECT Company_Name FROM f_panel_master WHERE PanelID='" + PanelID + "'"));
                        //dtItem.Rows[0]["CTBNo"] = CTBNo;
                        //dtItem.Rows[0]["RoomType"] = dt.Rows[0]["RoomType"].ToString();
                        //dtItem.Rows[0]["RoomNo"] = dt.Rows[0]["Room"].ToString();
                        //dtItem.Rows[0]["PName"] = dt.Rows[0]["PatientName"].ToString();
                        //dtItem.Rows[0]["DocName"] = dt.Rows[0]["DoctorName"].ToString();
                        //dtItem.Rows[0]["DocDepartment"] = dt.Rows[0]["DoctorDept"].ToString();
                        //dtItem.Rows[0]["username"] = dt.Rows[0]["EmpName"].ToString();
                        //dtItem.Rows[0]["header"] = "Charge To Bill Slip";

                        //Session["U_detail"] = dtItem;


                    }
                    else
                    {
                        tnx.Rollback();
                        con.Close();
                        con.Dispose();
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
                    }
                }
                catch (Exception ex)
                {
                    ClassLog c1 = new ClassLog();
                    c1.errLog(ex);
                    tnx.Rollback();
                    con.Close();
                    con.Dispose();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
                }

                Clear();
            }
            catch (Exception ex)
            {
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
                tnx.Rollback();
                con.Close();
                con.Dispose();
            }
        }
    }

    protected void btnAddDirect_Click(object sender, EventArgs e)
    {
        DataTable dtitemforChk = (DataTable)ViewState["dtItemForChk"];
        Flag = 1;
        grdItemRate.DataSource = dtitemforChk;
        grdItemRate.DataBind();
        txtSearch.Text = string.Empty;
        ViewState["IsSelected"] = 0;
        txtWord.Text = "";
        pnlhide.Visible = true;
    }

    protected void Button2_Click1(object sender, EventArgs e)
    {
        DataTable dtChkCancel = (DataTable)ViewState["dtItemForChk"];
        int count = dtChkCancel.Rows.Count;
        dtChkCancel.Rows[count - 1].Delete();
        ViewState["dtItems"] = dtChkCancel;
    }

    protected void grdItemRate_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        dtItem.Rows[e.RowIndex].Delete();
        dtItem.AcceptChanges();

        grdItemRate.DataSource = dtItem;
        grdItemRate.DataBind();
        if (dtItem.Rows.Count == 0)
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
        try
        {
            sb.Append("  Select IM.TypeName,concat(IM.ItemID,'#',IM.SubCategoryID,'#',SC.SubCategory)ItemID from (Select TypeName,ItemID,SubCategoryID from f_itemmaster where SubCategoryID in (Select SubCategoryID from f_SubCategoryMaster where  Active=1 and CategoryID ='" + CategoryID + "')  and isactive=1) IM,(Select Name as SubCategory,SubCategoryID from f_SubCategoryMaster where  Active=1 and CategoryID ='" + CategoryID + "')SC Where SC.SubCategoryID = IM.SubCategoryID ");

            if (txtWord.Text.Trim() != string.Empty)
            {
                sb.Append("   AND IM.TypeName LIKE '%" + txtWord.Text.Trim() + "%' order by IM.TypeName ");
                ViewState["IsSelected"] = 1;
            }
            else
                sb.Append("   order by IM.TypeName ");

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
    }

    protected void btnSelect_Click(object sender, EventArgs e)
    {
        try
        {


            AllQuery AQ = new AllQuery();
            string AdmitDate = AQ.getAdmitDate(lblTransactionNo.Text.Trim());
            string PrescribeDate = Util.GetDateTime(ucDate.Text).ToString("yyyy-MM-dd");

            if (Util.GetDateTime(PrescribeDate) < Util.GetDateTime(AdmitDate))
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
                lblMsg.Text = "Please Select Services";
                ListBox1.Focus();
                return;
            }
            string PanelID = lblPanelID.Text.Trim();
            string IPDCaseType_ID = lblCaseTypeID.Text.Trim();
            string TID = lblTransactionNo.Text.Trim();
            string PID = lblPatientID.Text.Trim();
            string Ref_Code = lblReferenceCode.Text.Trim();
            string ItemID = ListBox1.Items[ListBox1.SelectedIndex].Value.Split('#')[0].ToString();
            if (grdItemRate.Rows.Count > 0 && grdItemRate != null)
            {
                foreach (GridViewRow gr in grdItemRate.Rows)
                {
                    if (((Label)gr.FindControl("lblItem")).Text == ItemID)
                    {
                        lblMsg.Text = "Services Already Added";
                        return;
                    }
                }
            }
            // Validation to Check if Item does not belong to medicine & consumables
            // and rate of this item is not fiexed then return error msg.

            string IsExist = StockReports.ExecuteScalar("SElect ItemID from f_configrelation cf inner join f_subcategorymaster sc on cf.CategoryID = sc.CategoryID inner join f_itemmaster im on im.SubCategoryID = sc.SubCategoryID where im.ItemID='" + ItemID + "' and cf.ConfigID<>11 and (sc.DisplayName)='MEDICINE & CONSUMABLES' ");

            if (IsExist == string.Empty)
            {
                DataTable dtTemp = IPDBilling.LoadItemsHavingRateFixed("'" + ItemID + "'", Ref_Code, IPDCaseType_ID, ViewState["ScheduleChargeID"].ToString(), ViewState["CentreID"].ToString());

                if (dtTemp != null && dtTemp.Rows.Count > 0)
                {
                    if (Util.GetDecimal(dtTemp.Rows[0]["Rate"]) == 0)
                    {
                       // lblMsg.Text = "Rate is Not Set Under this Panel & RoomType. Please contact EDP to Set Rate";
                        //return;
                    }
                }
                else
                {
                 //   lblMsg.Text = "Rate is Not Set Under this Panel & RoomType. Please contact EDP to Set Rate";
                   // return;
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
                string ItemID = ListBox1.Items[ListBox1.SelectedIndex].Value;// ListBox1.SelectedItem.Value.Split('#')[2];
                string ItemName = ListBox1.Items[ListBox1.SelectedIndex].Text;

                DataRow dr = dtItem.NewRow();
                dr["Category"] = ddlCategory.SelectedItem.Text;
                dr["SubCategory"] = ItemID.Split('#')[2].ToString(); //ListBox1.SelectedItem.Value.Split('#')[2];
                dr["ItemID"] = ItemID.Split('#')[0].ToString(); //ListBox1.SelectedItem.Value.Split('#')[0];
                dr["Item"] = ItemName;// ListBox1.SelectedItem.Text;
                dr["Quantity"] = txtQty.Text.Trim();
                dr["Rate"] = "0";
                dr["Date"] = Util.GetDateTime(ucDate.Text).ToString("dd-MMM-yyyy");
                dr["ReserveTime"] = txtReserveTime.Text;
                dr["SubCategoryID"] = ItemID.Split('#')[1].ToString(); //ListBox1.SelectedItem.Value.Split('#')[1];

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

                dtItem.Rows.Add(dr);
                ViewState.Add("dtItem", dtItem);
            }

            if (dtItem != null && dtItem.Rows.Count > 0)
            {
                grdItemRate.DataSource = dtItem;
                grdItemRate.DataBind();
                pnlhide.Visible = true;
                txtSearch.Text = "";
                txtWord.Text = "";
                txtQty.Text = " ";
                ViewState["IsSelected"] = 0;
                ToolkitScriptManager1.SetFocus(txtSearch);
            }
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
            lblTransactionNo.Text = Convert.ToString(ViewState["TransID"]);
            AllQuery AQ = new AllQuery();
            DataTable dt = AQ.GetPatientIPDInformation("", TransactionID);
            if (dt != null && dt.Rows.Count > 0)
            {
                lblPatientID.Text = dt.Rows[0]["PatientID"].ToString();
                lblTransactionNo.Text = dt.Rows[0]["TransactionID"].ToString();
                lblCaseTypeID.Text = dt.Rows[0]["IPDCaseTypeID"].ToString();
                lblReferenceCode.Text = dt.Rows[0]["ReferenceCode"].ToString();
                lblPanelID.Text = dt.Rows[0]["PanelID"].ToString();
                lblDoctorID.Text = dt.Rows[0]["DoctorID"].ToString();
                // lblbloodgroup.Text = dt.Rows[0]["BloodGroup"].ToString();
                ddlBloodGroup.SelectedIndex = ddlBloodGroup.Items.IndexOf(ddlBloodGroup.Items.FindByText(dt.Rows[0]["bloodgroup"].ToString()));
                ViewState["ScheduleChargeID"] = dt.Rows[0]["ScheduleChargeID"].ToString();
                cmbRefferedBy.SelectedIndex = cmbRefferedBy.Items.IndexOf(cmbRefferedBy.Items.FindByValue(dt.Rows[0]["DoctorID"].ToString()));
                lblPatientType.Text = dt.Rows[0]["PatientType"].ToString();
                lblRoomID.Text = dt.Rows[0]["RoomID"].ToString();
                if (dt.Rows[0]["bloodgroup"].ToString() != "")
                {
                    btnUpdateBloodgroup.Visible = false;
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            lblMsg.Text = "Patient Record and Room Not Available";
        }
    }

    protected void btnWord_Click(object sender, EventArgs e)
    {
        if (txtWord.Text.Trim() != string.Empty)
        {
            if (Util.GetInt(ViewState["IsSelected"]) == 0)
            {
                ListBox1.Items.Clear();
                if (ddlCategory.SelectedItem.Value.ToUpper() != "ALL")
                {
                    ListBox1.Items.AddRange(LoadItems(GetItemsSubCategoryByCategoryID(ddlCategory.SelectedItem.Value)));
                }
                else
                {
                    try
                    {
                        string ConfigIDs = "";

                        ConfigIDs = "7";

                        DataTable dt = GetItemSubCategoryByCategoryConfigID(ConfigIDs);

                        if (dt != null && dt.Rows.Count > 0)
                        {
                            ListBox1.DataSource = dt;
                            ListBox1.DataTextField = "TypeName";
                            ListBox1.DataValueField = "ItemID";
                            ListBox1.DataBind();
                        }
                        else
                        {
                            if (txtWord.Text.Trim() != string.Empty)
                            {
                                lblMsg.Text = "Match Not Found.";
                                txtWord.Focus();
                            }
                            else
                                ListBox1.Items.Clear();
                        }
                    }
                    catch (Exception ex)
                    {
                        ClassLog objCL = new ClassLog();
                        objCL.errLog(ex);
                    }
                }

                txtWord.Focus();
            }
            else
            {
                getrate();
                ListBox1.Items.Clear();
                if (ddlCategory.SelectedItem.Value.ToUpper() != "ALL")
                {
                    ListBox1.Items.AddRange(LoadItems(GetItemsSubCategoryByCategoryID(ddlCategory.SelectedItem.Value)));
                }
                else
                {
                    try
                    {
                        string ConfigIDs = "";

                        ConfigIDs = "7";
                        DataTable dt = GetItemSubCategoryByCategoryConfigID(ConfigIDs);
                        ListBox1.DataSource = dt;
                        ListBox1.DataTextField = "TypeName";
                        ListBox1.DataValueField = "ItemID";
                        ListBox1.DataBind();
                    }
                    catch (Exception ex)
                    {
                        ClassLog objCL = new ClassLog();
                        objCL.errLog(ex);
                    }
                }

                txtWord.Focus();
            }
        }
    }

    private void BindBloodGroup()
    {
        DataTable dt = StockReports.GetDataTable("SELECT id,BloodGroup FROM bb_bloodgroup_master WHERE isactive=1");
        ddlBloodGroup.DataSource = dt;
        ddlBloodGroup.DataTextField = "BloodGroup";
        ddlBloodGroup.DataValueField = "id";
        ddlBloodGroup.DataBind();
    }
    protected void btnUpdateBloodgroup_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction objtnx = con.BeginTransaction();

        string BloodGroup = "";
        if (ddlBloodGroup.SelectedItem.Text != "NA")
            BloodGroup = ddlBloodGroup.SelectedItem.Text;

        string str = "Update Patient_master set bloodgroup='" + BloodGroup + "' where PatientID='" + lblPatientID.Text + "'";
        MySqlHelper.ExecuteNonQuery(objtnx, CommandType.Text, str);
        objtnx.Commit();

        lblMsg.Text = "Blood Group Updated";
        con.Close();
        con.Dispose();
    }

    private void BindRequestDetails(string TransactionID)
    {
        DataTable dt = StockReports.GetDataTable(" CALL sp_BloodBankServicesRequest('" + TransactionID + "'," + ViewState["CentreID"].ToString() + ") ");
        if (dt != null && dt.Rows.Count > 0)
        {
            grdRequestStatus.DataSource = dt;
            grdRequestStatus.DataBind();
            pnlRequest.Visible = true;
        }
        else
        {
            grdRequestStatus.DataSource = null;
            grdRequestStatus.DataBind();
            pnlRequest.Visible = false;
        }
    }


    protected void grdRequestStatus_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            decimal CrossMatchQty = Util.GetDecimal(((Label)e.Row.FindControl("lblIsCrossMatch")).Text.Trim());
            decimal ReqQuantity = Util.GetDecimal(((Label)e.Row.FindControl("lblQuantity")).Text.Trim());
            decimal IssueQuantity = Util.GetDecimal(((Label)e.Row.FindControl("lblIssueQuantity")).Text.Trim());

            if (CrossMatchQty == ReqQuantity)
            {
                e.Row.Attributes["style"] = "background-color: #f38f78";
            }
            if (CrossMatchQty < ReqQuantity && CrossMatchQty != Util.GetDecimal(0))
            {
                e.Row.Attributes["style"] = "background-color: #f38f78";
            }
            if (IssueQuantity == ReqQuantity)
            {
                e.Row.Attributes["style"] = "background-color: #69e6b0";
            }

        }
    }



    [WebMethod]
    public static string bindItemStockDetail(string ServiceRequestID)
    {
        string sql = "SELECT bcm.ComponentName,bcm.BloodStockID,sm.BBTubeNo,bcm.ServiceRequestID FROM bb_blood_crossmatch bcm INNER JOIN bb_stock_master sm ON bcm.BloodStockID=sm.Stock_Id AND UCASE(bcm.Compatiblity)<>'UNCOMPATIBLE' WHERE bcm.ServiceRequestID='" + ServiceRequestID + "'  GROUP BY sm.stock_id ";
        DataTable dt = StockReports.GetDataTable(sql);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }



    protected void btnStock_Click(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();
        dt = Reports();

        if (dt != null && dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "Period From ";// + txtcollectionfrom.Text + " To : " + txtcollectionTo.Text;
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = Convert.ToString(Session["LoginName"]);
            dt.Columns.Add(dc);

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());

            Session["ds"] = ds;
            Session["ReportName"] = "BloodComponentIssuedReport";//Stockreport

            //ds.WriteXmlSchema("E:/CurrentStockStatusReport.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../Bloodbank/Commenreport.aspx');", true);
        }
    }
    private DataTable Reports()
    {
        StringBuilder sb = new StringBuilder();
        DataTable dt1 = new DataTable();
        sb.Append(" SELECT sm.ComponentName,sm.`ComponentID`, sm.BloodGroup FROM bb_stock_master sm  INNER JOIN center_master cm ON sm.CentreID=cm.CentreID AND STATUS=1 AND IsDiscarded=0 AND IsDispatch=0 AND ExpiryDate >= NOW() AND initialcount-releasecount>0 and  sm.CentreID=" + Session["CentreID"] + "  ORDER BY sm.ComponentName; ");

        dt1 = StockReports.GetDataTable(sb.ToString());

        return dt1;
    }
}