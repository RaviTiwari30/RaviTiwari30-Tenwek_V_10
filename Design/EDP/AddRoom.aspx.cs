using System;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_EDP_AddRoom : System.Web.UI.Page
{


    public void savedata()
    {
        try
        {
            Room_Master objRoomMaster = new Room_Master();
            objRoomMaster.Location = AllGlobalFunction.Location;
            objRoomMaster.HospCode = AllGlobalFunction.HospCode;
            objRoomMaster.Name = txtName.Text.Trim();
            objRoomMaster.Floor = cmbFloor.SelectedItem.Text.Trim();
            objRoomMaster.Room_No = txtRoomNo.Text.Trim();
            objRoomMaster.IPDCaseType_ID = ddlCaseType.SelectedItem.Value;

            objRoomMaster.Bed_No = txtBedNo.Text.Trim();
            objRoomMaster.Description = txtDescription.Text.Trim();
            objRoomMaster.Creator_Date = Util.GetDateTime(System.DateTime.Now.ToString("dd/MMM/yyyy"));
            objRoomMaster.Creator_ID = Session["ID"].ToString();
            objRoomMaster.IPAddress = All_LoadData.IpAddress();
            objRoomMaster.CentreID = Util.GetInt(ddlcenter.SelectedItem.Value);
            //objRoomMaster.CentreID = Util.GetInt(Session["CentreID"].ToString());
            objRoomMaster.IsActive = 1;
            if (chkIsCount.Checked == true)
                objRoomMaster.IsCountable = 1;
            else
                objRoomMaster.IsCountable = 0;
            objRoomMaster.Insert();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        txtDescription.Text = "";
        txtName.Text = "";
        txtRoomNo.Text = "";
    }
    public void UpdateAndSaveRoomDataLog()
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            ViewState["RoomID"].ToString();

            DataTable dtRoom = StockReports.GetDataTable("Select * from room_master where roomID='" + ViewState["RoomID"].ToString() + "'");
            int IsCountable = 0;
            if (dtRoom != null && dtRoom.Rows.Count > 0)
            {
                if (chkIsCount.Checked == true)
                {
                    IsCountable = 1;
                }
                else
                {
                    IsCountable = 0;
                }
                if ((dtRoom.Rows[0]["NAME"].ToString() != txtName.Text.ToString().Trim()) || (dtRoom.Rows[0]["Room_No"].ToString() != txtName.Text.ToString().Trim()) || (dtRoom.Rows[0]["Bed_No"].ToString() != txtName.Text.ToString().Trim()) || (dtRoom.Rows[0]["FLOOR"].ToString() != txtName.Text.ToString().Trim()) || (dtRoom.Rows[0]["IPDCaseTypeID"].ToString() != txtName.Text.ToString().Trim()) || (dtRoom.Rows[0]["Description"].ToString() != txtName.Text.ToString().Trim()) || (dtRoom.Rows[0]["IsActive"].ToString() != txtName.Text.ToString().Trim()) || (dtRoom.Rows[0]["IsCountable"].ToString() != IsCountable.ToString()))
                {
                    
                    string Update = "Update room_master " +
                                       "Set NAME ='" + txtName.Text + "'," +
                                       "Room_No= '" + txtRoomNo.Text + "'," +
                                       "Bed_No = '" + txtBedNo.Text + "'," +
                                       "FLOOR = '" + cmbFloor.SelectedItem.Text + "'," +
                                       "IPDCaseTypeID = '" + ddlCaseType.SelectedValue + "'," +
                                       "Description = '" + txtDescription.Text + "'," +
                                       "IsActive='" + rbtStatus.SelectedValue + "'," +
                                       "Updater_ID='" + Session["ID"].ToString() + "'," +
                                       "Updater_Date=NOW(),IsCountable=" + IsCountable + " Where RoomID = '" + ViewState["RoomID"].ToString() + "'";
                    bool i = StockReports.ExecuteDML(Update);
                    if (i == true)
                    {
                        Room_Master objRoomMaster = new Room_Master();
                        objRoomMaster.Room_ID = Util.GetString(dtRoom.Rows[0]["RoomID"]);
                        objRoomMaster.Location = Util.GetString(dtRoom.Rows[0]["location"]);
                        objRoomMaster.HospCode = Util.GetString(dtRoom.Rows[0]["hospcode"]);
                        objRoomMaster.Name = Util.GetString(dtRoom.Rows[0]["Name"]);
                        objRoomMaster.Floor = Util.GetString(dtRoom.Rows[0]["Floor"]);
                        objRoomMaster.Room_No = Util.GetString(dtRoom.Rows[0]["Room_No"]);
                        objRoomMaster.IPDCaseType_ID = Util.GetString(dtRoom.Rows[0]["IPDCaseTypeID"]);
                        objRoomMaster.Bed_No = Util.GetString(dtRoom.Rows[0]["Bed_No"]);
                        objRoomMaster.Description = Util.GetString(dtRoom.Rows[0]["Description"]);
                        objRoomMaster.Creator_Date = Util.GetDateTime(dtRoom.Rows[0]["Creator_Date"]);
                        objRoomMaster.Creator_ID = Util.GetString(dtRoom.Rows[0]["Creator_ID"]);
                        objRoomMaster.IPAddress = Util.GetString(dtRoom.Rows[0]["IPAddress"]);
                        objRoomMaster.CentreID = Util.GetInt(dtRoom.Rows[0]["CentreID"]);
                        objRoomMaster.IsActive = Util.GetInt(dtRoom.Rows[0]["IsActive"]);
                        objRoomMaster.IsCountable = Util.GetInt(dtRoom.Rows[0]["IsCountable"]);
                        objRoomMaster.UpdaterID = Util.GetString(Session["ID"].ToString());
                        objRoomMaster.InsertRoomLog();
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM02','" + lblMsg.ClientID + "');", true);

                        btnSubmit.Text = "Save";
                        txtDescription.Text = "";
                        txtName.Text = "";
                        txtRoomNo.Text = "";
                        txtBedNo.Text = "";
                        cmbFloor.SelectedIndex = 0;

                        ViewState.Remove("RoomID");
                    }
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM02','Same Data Can not Be Updated, Please Change Something.');", true);
                }
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM02','Sorry room not found!');", true);
            }
            tranX.Commit();
        }
        catch (Exception ex)
        {
            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    protected void btnClear_Click(object sender, EventArgs e)
    {
        btnClear.Text = "Clear";
        txtDescription.Text = "";
        txtName.Text = "";
        txtRoomNo.Text = "";
        txtBedNo.Text = "";
        btnSubmit.Enabled = true;
        btnSubmit.Text = "Save";
        ddlCaseType.SelectedIndex = 0;
        cmbFloor.SelectedIndex = 0;
        ddlcenter.SelectedIndex = 0;
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {


        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string BillingCategoryID = string.Empty;
            if (!chkBillingCategory.Checked)
            {
                BillingCategoryID = ddlBillingCategory.SelectedValue;
            }
            ipd_case_type_master IPCM = new ipd_case_type_master(tranX);
            IPCM.Name = txtRoomType.Text;
            IPCM.Description = txtDesc.Text;
            IPCM.Ownership = "Public";
            IPCM.Creator_Date = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
            IPCM.No_Of_Round = Util.GetInt("0");
            IPCM.Creator_Id = Session["ID"].ToString();
            IPCM.IsActive = 1;
            IPCM.BillingCategoryID = BillingCategoryID;
            IPCM.IpAddress = All_LoadData.IpAddress();
            IPCM.CentreID = Util.GetInt(ddlcenter.SelectedItem.Value);
            IPCM.RevenueMappingID = Util.GetInt(ddlRevenueMap.SelectedItem.Value);
            IPCM.RevenueCoa_ID = Util.GetString(ddlRevenueMap.SelectedItem.Text).Split('#')[1];

            string ipdCaseTypeID = IPCM.Insert();
            if (chkBillingCategory.Checked)
            {
                MySqlHelper.ExecuteNonQuery(tranX.Connection, CommandType.Text, "UPDATE ipd_case_type_master SET BillingCategoryID='" + ipdCaseTypeID + "' WHERE IPDCaseTypeID='" + ipdCaseTypeID + "' ");
            }
            string CatID = CreateStockMaster.LoadCategoryByConfigID("2").Rows[0]["CategoryID"].ToString();

            SubCategoryMaster objSubCatMas = new SubCategoryMaster(tranX);
            objSubCatMas.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            objSubCatMas.Name = Util.GetString(txtRoomType.Text);
            objSubCatMas.Description = Util.GetString(ipdCaseTypeID);
            objSubCatMas.DisplayName = "Room Charges";
            objSubCatMas.CategoryID = Util.GetString(CatID);
            objSubCatMas.Active = 1;
            objSubCatMas.CreatedBy = Session["ID"].ToString();
            objSubCatMas.IPAddress = All_LoadData.IpAddress();
            string SubCatID = objSubCatMas.Insert().ToString();

            ItemMaster objIMaster = new ItemMaster(tranX);
            objIMaster.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            objIMaster.Type_ID = Util.GetInt(ipdCaseTypeID);
            objIMaster.TypeName = txtRoomType.Text;
            objIMaster.Description = txtDesc.Text;
            objIMaster.SubCategoryID = SubCatID;
            objIMaster.IsEffectingInventory = "No";
            objIMaster.IsExpirable = "";
            objIMaster.BillingUnit = "";
            objIMaster.Pulse = "";
            objIMaster.IsTrigger = Util.GetString("YES");
            objIMaster.StartTime = Util.GetDateTime("00:00:00");
            objIMaster.EndTime = Util.GetDateTime("00:00:00");
            objIMaster.BufferTime = Util.GetString("0");
            objIMaster.IsActive = Util.GetInt(1);
            objIMaster.QtyInHand = Util.GetDecimal("0");
            objIMaster.IsAuthorised = Util.GetInt(1);
            objIMaster.UnitType = "";
            objIMaster.IPAddress = All_LoadData.IpAddress();
            objIMaster.CreaterID = HttpContext.Current.Session["ID"].ToString();
            objIMaster.DepartmentID = Util.GetInt(cmbDept.SelectedValue);
            objIMaster.IsDiscountable = Util.GetInt(rdoIsDiscountable.SelectedValue);
            objIMaster.Insert().ToString();
            //In Case of Nurshing Care Charges
            DataTable dt = CreateStockMaster.LoadSubCategoryByConfigID("24"); //Nurshing Care
            if (dt != null && dt.Rows.Count > 0)
            {
                SubCatID = dt.Rows[0]["SubCategoryID"].ToString();
                CreateStockMaster.SaveItemDetails1(SubCatID, ipdCaseTypeID, txtRoomType.Text.Trim(), "NO", "", "NO", "", "", "YES", "00:00:00", "00:00:00", "0", "1", "0", "", "", Util.GetInt(cmbDept.SelectedValue), Util.GetInt(rdoIsDiscountable.SelectedValue), tranX);
            }
            //In Case of RMO Charges
            dt = CreateStockMaster.LoadSubCategoryByConfigID("27");
            if (dt != null && dt.Rows.Count > 0)
            {
                SubCatID = dt.Rows[0]["SubCategoryID"].ToString();
                CreateStockMaster.SaveItemDetails1(SubCatID, ipdCaseTypeID, txtRoomType.Text.Trim(), "NO", "", "NO", "", "", "YES", "00:00:00", "00:00:00", "0", "1", "0", "", "", Util.GetInt(cmbDept.SelectedValue), Util.GetInt(rdoIsDiscountable.SelectedValue), tranX);
            }
            tranX.Commit();
            //=======================  END  =====================================
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);

            txtRoomType.Text = "";
            txtDesc.Text = "";
            mdpSave.Hide();
            AllLoadData_IPD.bindCaseType(ddlCaseType, "Select", 2);
        }
        catch (Exception ex)
        {
            tranX.Rollback();

            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM07','" + lblMsg.ClientID + "');", true);
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnSaveFloor_Click(object sender, EventArgs e)
    {
        try
        {
            //if (Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM floor_master WHERE NAME='" + txtFloorName.Text.Trim() + "'")) > 0)
				var centreID = Util.GetInt(ddlcenter.SelectedItem.Value);
            if (Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM floor_master s WHERE s.NAME='" + txtFloorName.Text.Trim() + "'  and s.CentreID=" + centreID)) > 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM163','" + lblMsg.ClientID + "');", true);
                return;
            }

           // var centreID = Util.GetInt(ddlcenter.SelectedItem.Value);
            StockReports.ExecuteDML("INSERT INTO floor_master(NAME,SequenceNo,CentreID)VALUES('" + txtFloorName.Text.Trim().Replace("'", "''") + "','" + ddlSequenceNo.SelectedItem.Value + "','" + centreID + "')");
            txtFloorName.Text = "";
            ddlSequenceNo.SelectedIndex = 0;
            BindFloor(centreID);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.Message;
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        if (btnSubmit.Text.ToUpper() != "UPDATE")
        {

            int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM room_master WHERE Bed_No='" + txtBedNo.Text.Trim() + "' AND IPDCaseTypeID = '" + ddlCaseType.SelectedValue + "' AND Room_No= '" + txtRoomNo.Text + "' AND NAME ='" + txtName.Text + "' AND IsActive=1"));

            if (count > 0)
            {
                lblMsg.Text = "Bed No Already Exist";
                txtBedNo.Focus();
                return;
            }
        }

        if (txtName.Text == "" && txtRoomNo.Text == "")
        {
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM162','" + lblMsg.ClientID + "');", true);
            //return;
        }

        if (btnSubmit.Text.ToUpper() == "UPDATE")
        {
            UpdateAndSaveRoomDataLog();         
        }
        else
        {
            savedata();
        }
        Search();
    }

    protected void ddlCaseType_SelectedIndexChanged(object sender, EventArgs e)
    {
        Search();
    }

    protected void grdInv_SelectedIndexChanged(object sender, EventArgs e)
    {
        string RoomID = ((Label)grdInv.SelectedRow.FindControl("lblRoomID")).Text;
        ViewState["RoomID"] = RoomID;

        DataTable dtRoom = StockReports.GetDataTable("Select * from room_master where roomID='" + RoomID + "'");

        if (dtRoom != null && dtRoom.Rows.Count > 0)
        {
            ddlCaseType.SelectedIndex = ddlCaseType.Items.IndexOf(ddlCaseType.Items.FindByValue(dtRoom.Rows[0]["IPDCaseTypeID"].ToString()));

            //cmbBedNo.SelectedIndex = cmbBedNo.Items.IndexOf(cmbBedNo.Items.FindByValue(dtRoom.Rows[0]["Bed_No"].ToString()));
            txtBedNo.Text = dtRoom.Rows[0]["Bed_No"].ToString();
            txtName.Text = dtRoom.Rows[0]["Name"].ToString();
            txtRoomNo.Text = dtRoom.Rows[0]["Room_No"].ToString();
            txtDescription.Text = dtRoom.Rows[0]["Description"].ToString();
            cmbFloor.SelectedIndex = cmbFloor.Items.IndexOf(cmbFloor.Items.FindByValue(dtRoom.Rows[0]["Floor"].ToString()));
            rbtStatus.SelectedValue = dtRoom.Rows[0]["IsActive"].ToString();
            if (dtRoom.Rows[0]["IsCountable"].ToString() == "1")
                chkIsCount.Checked = true;
            else
                chkIsCount.Checked = false;
            btnSubmit.Text = "Update";
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindCenter();

            int centreID = Util.GetInt(ddlcenter.SelectedItem.Value);
            AllLoadData_IPD.bindCaseType(ddlCaseType, "Select", 2, centreID);
            txtName.Focus();
            BindFloor(centreID);
            Search();

            AllLoadData_IPD.bindCaseType(ddlBillingCategory, "", 2, centreID);
            All_LoadData.bindDocTypeList(cmbDept, 5, "Select");
            RevenueMap();
        }
    }

    private void RevenueMap()
    {
        DataTable dtData = StockReports.GetDataTable(" SELECT id,CONCAT(coa_name,'#',COA_ID)coa_name  FROM finance.coa$MASTER d WHERE d.COA_Type=2 order by coa_name");
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlRevenueMap.DataSource = dtData;
            ddlRevenueMap.DataTextField = "coa_name";
            ddlRevenueMap.DataValueField = "id";
            ddlRevenueMap.DataBind();
            ddlRevenueMap.Items.Insert(0, new ListItem("Select", "0"));
        }
        else
        {
            ddlRevenueMap.DataSource = null;
            ddlRevenueMap.DataBind();
        }
    }

    private void BindFloor(int centreID)
    {
        cmbFloor.DataSource = All_LoadData.LoadFloor(centreID);
        cmbFloor.DataValueField = "NAME";
        cmbFloor.DataTextField = "NAME";
        cmbFloor.DataBind();
    }
    public void bindCenter()
    {
        DataTable dtData = StockReports.GetDataTable(" select CentreID,CentreName,IsDefault from center_master Where IsActive=1 order by CentreName");
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlcenter.DataSource = dtData;
            ddlcenter.DataTextField = "CentreName";
            ddlcenter.DataValueField = "CentreID";
            ddlcenter.DataBind();
        }
        else
        {
            ddlcenter.DataSource = null;
            ddlcenter.DataBind();
        }
    }
    private void Search()
    {
        string str = "" +
        "SELECT icm.Name RoomType,icm.Description RoomTypeDesc,icm.IPDCaseTypeID,rm.Name,rm.Room_No,rm.Bed_No," +
        "rm.Floor,rm.RoomId,rm.Description,IF(rm.IsActive =1,'YES','NO')IsActive,IF(rm.IsCountable =1,'YES','NO')IsCountable " +
        "FROM ipd_case_type_master icm INNER JOIN room_master rm ON " +
        "icm.IPDCaseTypeID = rm.IPDCaseTypeID WHERE rm.IsActive=1 ";

        if (ddlCaseType.SelectedIndex != -1)
        {
            str = str + " and icm.IPDCaseTypeID='" + ddlCaseType.SelectedValue + "'";
        }

        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            grdInv.DataSource = dt;
            grdInv.DataBind();
            pnlRoomType.Visible = true;
        }

        else
        {
            grdInv.DataSource = null;
            grdInv.DataBind();
            pnlRoomType.Visible = false;
        }
    }

    private void Validation()
    {
        btnSubmit.Attributes.Add("OnClick", "RequiredAtLeastOneFieldJS2('" + txtName.ClientID + "','" + txtRoomNo.ClientID + "','either Name or Room No');return false;");
    }
    protected void ddlcenter_SelectedIndexChanged(object sender, EventArgs e)
    {                                 
        int centreID = Util.GetInt(ddlcenter.SelectedItem.Value);
        AllLoadData_IPD.bindCaseType(ddlCaseType, "Select", 2, centreID);
        txtName.Focus();
        BindFloor(centreID);
    }
}