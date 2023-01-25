using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Diagnostics;
using System.IO;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Text;

public partial class Design_Equipment_Masters_EditAssetWoGRN : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["ID"] = Session["ID"].ToString();
            ViewState["IPAddress"] = All_LoadData.IpAddress().ToString();
            BindAssetType();
            BindSupplierType();
            ////BindLocation();
            BindAMCType();
            BindFloor();


            ucPurDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucInstallationDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucWarrantyFrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucWarrantyTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucFreeServiceFrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucFreeServiceTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucServiceFrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucServiceTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucLastServiceDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucNextServiceDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucAssignedOn.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");

        }



        Session["fileUpload1"] = null;
        lblMsg.Text = "";
        // if (flServiceAgreement.HasFile)
        //     ViewState["FileName"] = flServiceAgreement.PostedFile;

        //flServiceAgreement. = ViewState["FileName"].ToString(); 


        ucPurDate.Attributes.Add("readonly", "readonly");
        ucInstallationDate.Attributes.Add("readonly", "readonly");
        ucWarrantyFrom.Attributes.Add("readonly", "readonly");
        ucWarrantyTo.Attributes.Add("readonly", "readonly");
        ucFreeServiceFrom.Attributes.Add("readonly", "readonly");
        ucFreeServiceTo.Attributes.Add("readonly", "readonly");
        ucServiceFrom.Attributes.Add("readonly", "readonly");
        ucServiceTo.Attributes.Add("readonly", "readonly");
        ucLastServiceDate.Attributes.Add("readonly", "readonly");
        ucNextServiceDate.Attributes.Add("readonly", "readonly");
        ucAssignedOn.Attributes.Add("readonly", "readonly");
    }



    private void BindFloor()
    {
        DataTable dt = StockReports.GetDataTable("select FloorName,FloorID FROM eq_floor_master where isActive=1 order by FloorName");
        ddlFloor.DataSource = dt;
        ddlFloor.DataTextField = "FloorName";
        ddlFloor.DataValueField = "FloorID";
        ddlFloor.DataBind();
        ddlFloor.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        ddlFloor.SelectedIndex = 0;
    }
    string upld = "";
    public void LoadData()
    {
        string str = "SELECT AssetID,AssetName,AssetCode,AssetTypeID,SerialNo,ModelNo,TagNo,SupplierID,SupplierTypeID,TechnicalDtl, DATE_FORMAT(PurchaseDate, '%d-%b-%y ')PurchaseDate,DATE_FORMAT(InstallationDate, '%d-%b-%y ')InstallationDate,DATE_FORMAT(WarrantyFrom, '%d-%b-%y ')WarrantyFrom,DATE_FORMAT(WarrantyTo, '%d-%b-%y ')WarrantyTo,";
        str += "DATE_FORMAT(FreeServiceFrom, '%d-%b-%y ') FreeServiceFrom,DATE_FORMAT(FreeServiceTo, '%d-%b-%y ')FreeServiceTo,WarrantyTerms,AmcTypeID,ServiceSupplierID,DATE_FORMAT(ServiceDateFrom, '%d-%b-%y ')ServiceDateFrom,DATE_FORMAT(ServiceDateTo, '%d-%b-%y ')ServiceDateTo, DATE_FORMAT(LastServiceDate, '%d-%b-%y ')LastServiceDate,DATE_FORMAT(NextServiceDate, '%d-%b-%y ')NextServiceDate,LocationID,";
        str += "  FloorID,RoomID,AssignedTo,STATUS,IF(Isactive=1,'Yes','No') IsActive,insertby,updateby,DATE_FORMAT(updatedate, '%d-%b-%y ')updatedate,Ipnumber,AgreementFileName FROM eq_asset_master where  AssetID<>'' ";

        if (ddlserchassettype.SelectedIndex != 0)
        {
            str += "  And  AssetTypeID='" + ddlserchassettype.SelectedValue + "' ";
        }
        if (txtsearchassetname.Text != "")
        {
            str += " And AssetName LIKE '" + txtsearchassetname.Text.Trim() + "%'";
        }
        if (txtseatchAssetcode.Text != "")
        {
            str += " And AssetCode LIKE '" + txtseatchAssetcode.Text.Trim() + "%'";
        }
        if (txtsearchsuppliername.Text != "")
        {
            str += " And   SupplierTypeID=(SELECT SupplierTypeID FROM f_vendormaster WHERE VendorName LIKE '" + txtsearchsuppliername.Text.Trim() + "%' AND  isActive=1 Limit 1)";
        }
        DataTable dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {
            grdasset.DataSource = dt;
            grdasset.DataBind();
            Panel1.Visible = false;
            Panel2.Visible = true;
            //divtop.Attributes.Add("style", "height: 250px;");
        }
        else
        {
            lblMsg.Text = "Record Not Found";
        }
    }
    protected void grdasset_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string AssetID = Util.GetString(e.CommandArgument);
        ViewState["AssetID"] = AssetID;
        if (e.CommandName == "EditAT")
        {
            grdasset.DataSource = null;
            grdasset.DataBind();
            Panel2.Visible = false;

            // divtop.Attributes.Add("style", "height: 0px;");
            Panel1.Visible = true;

            DataTable dt = StockReports.GetDataTable("SELECT * FROM eq_asset_master WHERE AssetID='" + AssetID + "' ");
            if (dt != null && dt.Rows.Count > 0)
            {
                txtAssetName.Text = dt.Rows[0]["AssetName"].ToString();
                txtAssetCode.Text = dt.Rows[0]["AssetCode"].ToString();
                txtSerialNo.Text = dt.Rows[0]["SerialNo"].ToString();
                txtModelNo.Text = dt.Rows[0]["ModelNo"].ToString();
                txtTagNo.Text = dt.Rows[0]["TagNo"].ToString();
                lblMachineid.Text = dt.Rows[0]["AssetID"].ToString();

                ddlAssetType.SelectedIndex = ddlAssetType.Items.IndexOf(ddlAssetType.Items.FindByValue(dt.Rows[0]["AssetTypeID"].ToString()));
                ddlAmcType.SelectedIndex = ddlAmcType.Items.IndexOf(ddlAmcType.Items.FindByValue(dt.Rows[0]["AMCtypeID"].ToString()));
                // ravi do below for tyhe same

                ddlSupplierType.SelectedIndex = ddlSupplierType.Items.IndexOf(ddlSupplierType.Items.FindByValue(dt.Rows[0]["SupplierTypeID"].ToString()));
                BindSupplierList(dt.Rows[0]["SupplierTypeID"].ToString());
                ddlSupplier.SelectedIndex = ddlSupplier.Items.IndexOf(ddlSupplier.Items.FindByValue(dt.Rows[0]["SupplierID"].ToString()));
                ddlSupplierService.SelectedIndex = ddlSupplierService.Items.IndexOf(ddlSupplierService.Items.FindByValue(dt.Rows[0]["SupplierID"].ToString()));
                txtTechnical.Text = dt.Rows[0]["TechnicalDtl"].ToString();
                txtWarrantyCondition.Text = dt.Rows[0]["WarrantyTerms"].ToString();
                ucPurDate.Text = Util.GetDateTime(dt.Rows[0]["PurchaseDate"]).ToString("dd-MMM-yyyy");
                ucInstallationDate.Text = Util.GetDateTime(dt.Rows[0]["InstallationDate"]).ToString("dd-MMM-yyyy");
                ucWarrantyFrom.Text = Util.GetDateTime(dt.Rows[0]["WarrantyFrom"]).ToString("dd-MMM-yyyy");
                ucWarrantyTo.Text = Util.GetDateTime(dt.Rows[0]["WarrantyTo"]).ToString("dd-MMM-yyyy");
                ucFreeServiceFrom.Text = Util.GetDateTime(dt.Rows[0]["FreeServiceFrom"]).ToString("dd-MMM-yyyy");
                ucFreeServiceTo.Text = Util.GetDateTime(dt.Rows[0]["FreeServiceTo"]).ToString("dd-MMM-yyyy");
                ucServiceFrom.Text = Util.GetDateTime(dt.Rows[0]["ServiceDateFrom"]).ToString("dd-MMM-yyyy");
                ucServiceTo.Text = Util.GetDateTime(dt.Rows[0]["ServiceDateTo"]).ToString("dd-MMM-yyyy");
                ucLastServiceDate.Text = Util.GetDateTime(dt.Rows[0]["LastServiceDate"]).ToString("dd-MMM-yyyy");
                ucNextServiceDate.Text = Util.GetDateTime(dt.Rows[0]["NextServiceDate"]).ToString("dd-MMM-yyyy");
                
                ddlFloor.SelectedIndex = ddlFloor.Items.IndexOf(ddlFloor.Items.FindByValue(dt.Rows[0]["FloorID"].ToString()));
                //BindFloor(dt.Rows[0]["LocationID"].ToString());

                BindLocation(dt.Rows[0]["FloorID"].ToString());
                // do theb below line in all codes  gaurav to ravi 26092014)                
                ddlLocation.SelectedIndex = Util.GetInt(ddlLocation.Items.IndexOf(ddlLocation.Items.FindByValue(dt.Rows[0]["LocationID"].ToString())));
                BindRoom(dt.Rows[0]["FloorID"].ToString(), dt.Rows[0]["LocationID"].ToString());
                ddlRoom.SelectedIndex = ddlRoom.Items.IndexOf(ddlRoom.Items.FindByValue(dt.Rows[0]["RoomID"].ToString()));
                txtAssignedTo.Text = dt.Rows[0]["AssignedTo"].ToString();
                ucAssignedOn.Text = Util.GetDateTime(dt.Rows[0]["AssigneDate"]).ToString("dd-MMM-yyyy");
                ddlStatus.SelectedIndex=ddlStatus.Items.IndexOf(ddlStatus.Items.FindByValue(dt.Rows[0]["Isactive"].ToString()));
            }
        }

        if (e.CommandName == "AView")
        {
            string TId = e.CommandArgument.ToString().Split('$')[0];
            ViewState["AssetID"] = TId;
            string FileAppName = e.CommandArgument.ToString().Split('$')[1];
            //   string lblFName = ((Label)grdasset.FindControl("lblFileName")).Text;
            string url = "SELECT fileUrl FROM eq_asset_master WHERE AssetID='" + ViewState["AssetID"] + "'";
            url = StockReports.ExecuteScalar(url);
            filesearch(url);
        }
    }


    private void BindAssetType()
    {
        string str = "Select AssetTypeName,AssetTypeID from eq_assettype_master where isActive=1 ";
        if (Session["roleid"].ToString() != "180")
        {
            str += " And roleid='" + Session["roleid"].ToString() + "' order by AssetTypeName";

        }
        else { str += " order by AssetTypeName "; }

        DataTable dt = StockReports.GetDataTable(str);
        ddlAssetType.DataSource = dt;
        ddlAssetType.DataTextField = "AssetTypeName";
        ddlAssetType.DataValueField = "AssetTypeID";
        ddlAssetType.DataBind();

        ddlAssetType.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        ddlAssetType.SelectedIndex = 0;

        ddlserchassettype.DataSource = dt;
        ddlserchassettype.DataTextField = "AssetTypeName";
        ddlserchassettype.DataValueField = "AssetTypeID";
        ddlserchassettype.DataBind();

        ddlserchassettype.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        ddlserchassettype.SelectedIndex = 0;

    }
    private void BindAMCType()
    {
        DataTable dt = StockReports.GetDataTable("Select AMCtypeName,AMCtypeID from eq_amctype_master where isActive=1 order by AMCtypeName");
        ddlAmcType.DataSource = dt;
        ddlAmcType.DataTextField = "AMCtypeName";
        ddlAmcType.DataValueField = "AMCtypeID";
        ddlAmcType.DataBind();

        ddlAmcType.Items.Insert(0, new ListItem("ALL", "ALL"));
        ddlAmcType.SelectedIndex = 0;

    }

    private void BindSupplierType()
    {
        DataTable dt = StockReports.GetDataTable("Select SupplierTypeName,SupplierTypeID from eq_SupplierType_master where isActive=1 order by SupplierTypeName");
        ddlSupplierType.DataSource = dt;

        ddlSupplierType.DataTextField = "SupplierTypeName";
        ddlSupplierType.DataValueField = "SupplierTypeID";
        ddlSupplierType.DataBind();

        ddlSupplierType.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        ddlSupplierType.SelectedIndex = 0;


        ddlSupplierService.DataSource = dt;
        ddlSupplierService.DataTextField = "SupplierTypeName";
        ddlSupplierService.DataValueField = "SupplierTypeID";
        ddlSupplierService.DataBind();
        //BindSupplierList();
    }
    private void BindSupplierList(string SupplierTypeID)
    {


        // string str = "Select SupplierName,SupplierID from eq_Supplier_master where isActive=1";
        string str = "SELECT VendorName,Vendor_ID FROM f_vendormaster WHERE isActive=1";
        //if (ddlSupplierType.SelectedValue != "SELECT")
        str += " AND SupplierTypeID = '" + SupplierTypeID + "' ";

        // str += " order by SupplierName";
        str += "ORDER BY VendorName";

        DataTable dt = StockReports.GetDataTable(str);
        ddlSupplier.DataSource = dt;
        ddlSupplier.DataTextField = "VendorName";
        ddlSupplier.DataValueField = "Vendor_ID";
        ddlSupplier.DataBind();

        ddlSupplier.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        ddlSupplier.SelectedIndex = 0;
        ddlSupplierService.DataSource = dt;
        ddlSupplierService.DataTextField = "VendorName";
        ddlSupplierService.DataValueField = "Vendor_ID";
        ddlSupplierService.DataBind();
    }
    //private void BindLocation()
    //{
    //    DataTable dt = StockReports.GetDataTable("SELECT locationid,locationname FROM eq_location_master WHERE isactive=1 ORDER BY locationname ASC");
    //    ddlLocation.DataSource = dt;
    //    ddlLocation.DataTextField = "locationname";
    //    ddlLocation.DataValueField = "locationid";
    //    ddlLocation.DataBind();
    //    ddlLocation.Items.Insert(0, new ListItem("SELECT", "SELECT"));
    //    ddlLocation.SelectedIndex = 0;
    //    BindFloor(ddlLocation.SelectedValue);

    //}    

    private void BindFloor(string loction)
    {
        try
        {

            DataTable dt = StockReports.GetDataTable("SELECT floorid,floorname FROM eq_floor_master WHERE isactive=1 AND locationid='" + loction + "' ORDER BY floorname ASC");
            if (dt.Rows.Count > 0)
            {
                ddlFloor.DataSource = dt;
                ddlFloor.DataTextField = "floorname";
                ddlFloor.DataValueField = "floorid";
                ddlFloor.DataBind();
                ddlFloor.Items.Insert(0, new ListItem("SELECT", "SELECT"));
                ddlFloor.SelectedIndex = 0;
                BindRoom(ddlFloor.SelectedValue, ddlLocation.SelectedValue);
            }
            else
            {
                lblMsg.Text = "Floor Not Found ";

            }
        }
        catch (Exception e)
        {
            lblMsg.Text = e.Message;
        }
    }
    private void BindLocation(string FlooID)
    {
        try
        {
            DataTable dt = StockReports.GetDataTable("Select LocationName,LocationId from eq_location_master where IsActive=1 AND FloorID='" + FlooID + "' Order BY LocationName ASC");
            if (dt.Rows.Count > 0)
            {
                ddlLocation.DataSource = dt;
                ddlLocation.DataTextField = "LocationName";
                ddlLocation.DataValueField = "LocationID";
                ddlLocation.DataBind();
                ddlLocation.SelectedIndex = 0;
                //  BindRoom( ddlFloor.SelectedValue,ddlLocation.SelectedValue);
            }
            else
            {
                lblMsg.Text = "Location Not Found on this floor";

            }
        }
        catch (Exception e)
        {
            lblMsg.Text = e.Message;
        }
    }
    private void BindRoom(string floor, string location)
    {
        try
        {
            DataTable dt = StockReports.GetDataTable("SELECT roomid,roomname FROM eq_room_master WHERE floorid='" + floor + "' AND locationid='" + location + "' AND isactive=1 ORDER BY roomname ASC ");

            if (dt.Rows.Count > 0)
            {
                ddlRoom.DataSource = dt;
                ddlRoom.DataTextField = "roomname";
                ddlRoom.DataValueField = "roomid";
                ddlRoom.DataBind();
                ddlRoom.Items.Insert(0, new ListItem("SELECT", "SELECT"));
                ddlRoom.SelectedIndex = 0;
            }
            else
            {
                lblMsg.Text = "Room Not Found on this floor";
                ddlRoom.Items.Clear();
                ddlRoom.Items.Insert(0, new ListItem("SELECT", "SELECT"));
            }
        }
        catch (Exception e)
        {
            lblMsg.Text = e.Message;
        }

    }
    private bool CheckValidation()
    {
        try
        {

            if (ddlAssetType.SelectedValue.ToUpper() == "SELECT")
            {
                lblMsg.Text = "Select Asset Type..";
                ddlAssetType.Focus();
                return false;
            }


            if (txtAssetName.Text.Trim() == string.Empty)
            {
                lblMsg.Text = "Select Asset Name..";
                txtAssetName.Focus();
                return false;
            }


            if (txtAssetCode.Text.Trim() == string.Empty)
            {
                lblMsg.Text = "Select Asset Code..";
                txtAssetCode.Focus();
                return false;
            }

            if (txtSerialNo.Text.Trim() == string.Empty)
            {
                lblMsg.Text = "Select Serial Number..";
                txtSerialNo.Focus();
                return false;
            }

            if (ddlSupplierType.SelectedValue.ToUpper() == "SELECT")
            {
                lblMsg.Text = "Select Supplier Type..";
                ddlSupplierType.Focus();
                return false;
            }

            if (ddlSupplier.SelectedValue.ToUpper() == "SELECT")
            {
                lblMsg.Text = "Select Supplier...";
                ddlSupplier.Focus();
                return false;
            }

            //if (ucFreeServiceFrom.IsLessThanDate(Util.GetDateTime(ucPurDate.GetDateForDataBase())))
            //{
            //    lblMsg.Text = "Start of Free Service Date cannot be less then Purchase Date...";
            //    ucFreeServiceFrom.Focus();
            //    return false;
            //}

            //if (ucWarrantyFrom.IsLessThanDate(Util.GetDateTime(ucPurDate.GetDateForDataBase())))
            //{
            //    lblMsg.Text = "Start of Warranty Date cannot be less then Purchase Date...";
            //    ucWarrantyFrom.Focus();
            //    return false;
            //}

            if (ddlAmcType.SelectedValue.ToUpper() == "SELECT")
            {
                lblMsg.Text = "Select AMC Type..";
                ddlAmcType.Focus();
                return false;
            }

            if (ddlSupplierService.SelectedValue.ToUpper() == "SELECT")
            {
                lblMsg.Text = "Select Service Supplier Name..";
                ddlSupplierService.Focus();
                return false;
            }

            if (ddlLocation.SelectedValue.ToUpper() == "SELECT")
            {
                lblMsg.Text = "Select Location..";
                ddlLocation.Focus();
                return false;
            }

            if (ddlFloor.SelectedValue.ToUpper() == "SELECT")
            {
                lblMsg.Text = "Select Floor..";
                ddlFloor.Focus();
                return false;
            }

            if (ddlRoom.SelectedValue.ToUpper() == "SELECT")
            {
                lblMsg.Text = "Select Room..";
                ddlRoom.Focus();
                return false;
            }

            if (txtAssignedTo.Text.Trim() == string.Empty)
            {
                lblMsg.Text = "Provide Name of the person whom Asset is assigned to..";
                txtAssignedTo.Focus();
                return false;
            }

            if (fileUpload1.PostedFile.ContentLength == 0)
            {
                lblMsg.Visible = true;
                lblMsg.Text = "Please Browse File ..";
                return false;
            }

            //if (ucAssignedOn.GetDateForDataBase() == string.Empty)
            //{
            //    lblMsg.Text = "Provide the Date when asset is assigned on...";
            //    ucAssignedOn.Focus();
            //    return false;
            //}

            //string IsExist = "", str="";
            //str = "Select AssetID from eq_asset_master where AssetTypeID=" + ddlAssetType.SelectedValue + " and AssetName ='" + txtAssetName.Text.Trim() + "'";
            //IsExist = StockReports.ExecuteScalar(str);

            //if (IsExist != "")
            //{
            //    lblMsg.Text = "Asset Name already exists in this Asset Type...";
            //    return false;
            //}

            //IsExist = "";
            //str = "Select AssetID from eq_asset_master where AssetCode ='" + txtAssetCode.Text.Trim() + "'";
            //IsExist = StockReports.ExecuteScalar(str);

            //if (IsExist != "")
            //{
            //    lblMsg.Text = "Asset Code already exists...";
            //    return false;
            //}


            return true;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return false;
        }
    }

    protected void ddlSupplierType_SelectedIndexChanged(object sender, EventArgs e)
    {
        //BindSupplierList();
    }
    protected void ddlLocation_SelectedIndexChanged(object sender, EventArgs e)
    {
        //BindFloor(ddlLocation.SelectedValue);
        BindRoom(ddlFloor.SelectedValue, ddlLocation.SelectedValue);
    }
    protected void ddlFloor_SelectedIndexChanged(object sender, EventArgs e)
    {
        //BindRoom(ddlFloor.SelectedValue, ddlLocation.SelectedValue);
        BindLocation(ddlFloor.SelectedValue);
    }
    protected void btnsave_Click(object sender, EventArgs e)
    {
        // string strrrr = Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd");
        bool IsValid = CheckValidation();
        if (!IsValid)
            return;

        MySqlConnection conn = Util.GetMySqlCon();
        conn.Open();
        MySqlTransaction tnx = conn.BeginTransaction();

        string str = "";


        if (btnsave.Text == "UPDATE")
        {

            try
            {
                fileupload();
                str = "";
                str += "UPDATE  eq_asset_master set AssetName ='" + txtAssetName.Text.Trim() + "',AssetCode='" + txtAssetCode.Text.Trim() + "',AssetTypeID='" + ddlAssetType.SelectedValue + "',";
                str += "SerialNo='" + txtSerialNo.Text.Trim() + "',ModelNo='" + txtModelNo.Text.Trim() + "',TagNo='" + txtTagNo.Text.Trim() + "',SupplierID='" + ddlSupplier.SelectedValue + "',SupplierTypeID='" + ddlSupplierType.SelectedValue + "',TechnicalDtl='" + txtTechnical.Text.Trim() + "',";
                str += "PurchaseDate='" + Util.GetDateTime(ucPurDate.Text).ToString("yyyy-MM-dd") + "',InstallationDate='" + Util.GetDateTime(ucInstallationDate.Text).ToString("yyyy-MM-dd") + "',WarrantyFrom='" + Util.GetDateTime(ucWarrantyFrom.Text).ToString("yyyy-MM-dd") + "',WarrantyTo='" + Util.GetDateTime(ucWarrantyTo.Text).ToString("yyyy-MM-dd") + "',";
                str += "FreeServiceFrom='" + Util.GetDateTime(ucFreeServiceFrom.Text).ToString("yyyy-MM-dd") + "',FreeServiceTo='" + Util.GetDateTime(ucFreeServiceTo.Text).ToString("yyyy-MM-dd") + "',WarrantyTerms='" + txtWarrantyCondition.Text.Trim() + "',AmcTypeID='" + ddlAmcType.SelectedValue + "',";
                str += "ServiceSupplierID='" + ddlSupplierService.SelectedValue + "',ServiceDateFrom='" + Util.GetDateTime(ucServiceFrom.Text).ToString("yyyy-MM-dd") + "',ServiceDateTo='" + Util.GetDateTime(ucServiceTo.Text).ToString("yyyy-MM-dd") + "',";
                str += "LastServiceDate='" + Util.GetDateTime(ucLastServiceDate.Text).ToString("yyyy-MM-dd") + "',NextServiceDate='" + Util.GetDateTime(ucNextServiceDate.Text).ToString("yyyy-MM-dd") + "',LocationID='" + ddlLocation.SelectedValue + "',";
                str += "FloorID='" + ddlFloor.SelectedValue + "',RoomID='" + ddlRoom.SelectedValue + "',AssignedTo='" + txtAssignedTo.Text.Trim() + "',STATUS='" + ddlStatus.SelectedValue + "',Isactive='" + ddlStatus.SelectedValue + "',";
                str += "updateby='" + ViewState["ID"].ToString() + "',updatedate='" + Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd") + "',Ipnumber='" + ViewState["IPAddress"].ToString() + "'";
                if (fileUpload1.PostedFile.ContentLength != 0)
                {
                    upld = upld.Replace("\\", "''");
                    upld = upld.Replace("'", "\\");

                    str += ",AgreementFileName= '" + fileUpload1.FileName + "',FileUrl='" + upld + "'";
                }
                str += " where AssetID='" + lblMachineid.Text + "' ";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);



                tnx.Commit();
                conn.Close();
                conn.Dispose();

                lblMsg.Text = "Record Saved";
                btnsave.Text = "UPDATE";
                LoadData();

            }
            catch (Exception ex)
            {
                tnx.Rollback();
                conn.Close();
                conn.Dispose();

                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                lblMsg.Text = ex.Message;
            }
        }
    }
    protected void btnclear_Click(object sender, EventArgs e)
    {
        btnsave.Text = "UPDATE";
        LoadData();
    }
    protected void btnsearch_Click(object sender, EventArgs e)
    {
        LoadData();
    }

    public void fileupload()
    {

        try
        {
           
            string upld = "";

            string Ext = fileUpload1.PostedFile.FileName.ToString().Split('.')[1];
            DirectoryInfo folder = new DirectoryInfo(@"C:\MachineServiceAgreement");

            if (folder.Exists)
            {
                DirectoryInfo[] SubFolder = folder.GetDirectories(ViewState["AssetID"].ToString());

                if (SubFolder.Length > 0)
                {
                    foreach (DirectoryInfo Sub in SubFolder)
                    {
                        if (Sub.Name == ViewState["AssetID"].ToString())
                        {
                            FileInfo[] files = Sub.GetFiles();
                            foreach (FileInfo fl in files)
                            {
                                string fil = fl.Name;
                                if (fil == fileUpload1.PostedFile.FileName.ToString())
                                {
                                    lblMsg.Visible = true;
                                    lblMsg.Text = "File Already Exist..";
                                    return;
                                }

                            }
                            string doc = fileUpload1.FileName;
                            string IpFolder = Sub.Name;
                            string Ip = Path.Combine(@"C:\MachineServiceAgreement", IpFolder);
                            upld = Path.Combine(Ip, doc);
                            fileUpload1.PostedFile.SaveAs(upld);
                            lblMsg.Visible = true;
                            lblMsg.Text = "File Uploaded Sucessfully..";

                            break;
                        }
                    }
                }
                else
                {
                    DirectoryInfo subFold = folder.CreateSubdirectory(ViewState["AssetID"].ToString());
                    string IpFolder = subFold.Name;
                    string doc = fileUpload1.FileName;
                    string Ip = Path.Combine(@"C:\MachineServiceAgreement", IpFolder);
                    upld = Path.Combine(Ip, doc);
                    fileUpload1.PostedFile.SaveAs(upld);
                    lblMsg.Visible = true;
                    lblMsg.Text = "File Uploaded Sucessfully..";

                }

            }
            else
            {
                DirectoryInfo subfolder = folder.CreateSubdirectory(ViewState["AssetID"].ToString());
                DirectoryInfo[] sub = subfolder.GetDirectories();

                string IpFolder = subfolder.Name;
                string doc = fileUpload1.FileName;
                string Ip = Path.Combine(@"C:\MachineServiceAgreement", IpFolder);
                upld = Path.Combine(Ip, doc);
                fileUpload1.PostedFile.SaveAs(upld);
                lblMsg.Visible = true;
                lblMsg.Text = "File Uploaded Sucessfully..";




            }

        }
        catch (Exception ex)
        {
            ClassLog objErr = new ClassLog();
            objErr.errLog(ex);
        }


    }

    public void filesearch(string URL)
    {
        try
        {
            DirectoryInfo MyDir = new DirectoryInfo(@"C:\MachineServiceAgreement");
            DirectoryInfo[] f1 = MyDir.GetDirectories(ViewState["AssetID"].ToString());
            if (f1.Length > 0)
            {
                foreach (DirectoryInfo di in f1)
                {
                    FileInfo[] files = di.GetFiles();
                    if (files.Length > 0)
                    {
                        foreach (FileInfo fi in files)
                        {
                            string FileName = fi.Name;
                            string path1 = Path.Combine(@"C:\MachineServiceAgreement", di.Name);
                            string path2 = Path.Combine(path1, FileName);

                            if (URL == path2)
                            {

                                if (fi.Extension == ".pdf" || fi.Extension == ".PDF")
                                {
                                    Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                                    // Add the file size into the response header
                                    Response.AddHeader("Content-Length", fi.Length.ToString());

                                    // Set the ContentType
                                    Response.ContentType = "application/pdf";

                                    // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                                    Response.TransmitFile(fi.FullName);

                                    // End the response
                                    Response.Flush();
                                }

                                if (fi.Extension == ".xls")
                                {
                                    Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                                    // Add the file size into the response header
                                    Response.AddHeader("Content-Length", fi.Length.ToString());

                                    // Set the ContentType
                                    Response.ContentType = "application/vnd.ms-excel";

                                    // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                                    Response.TransmitFile(fi.FullName);

                                    // End the response
                                    Response.Flush();
                                }

                                if (fi.Extension == ".xlsx")
                                {
                                    Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                                    // Add the file size into the response header
                                    Response.AddHeader("Content-Length", fi.Length.ToString());

                                    // Set the ContentType
                                    Response.ContentType = "application/vnd.ms-excel";

                                    // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                                    Response.TransmitFile(fi.FullName);

                                    // End the response
                                    Response.Flush();
                                }

                                if (fi.Extension == ".jpg")
                                {
                                    Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                                    // Add the file size into the response header
                                    Response.AddHeader("Content-Length", fi.Length.ToString());

                                    // Set the ContentType
                                    Response.ContentType = "image / jpeg";

                                    // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                                    Response.TransmitFile(fi.FullName);

                                    // End the response
                                    Response.Flush();
                                }
                                if (fi.Extension == ".txt")
                                {
                                    Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                                    // Add the file size into the response header
                                    Response.AddHeader("Content-Length", fi.Length.ToString());

                                    // Set the ContentType
                                    Response.ContentType = "text/plain";

                                    // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                                    Response.TransmitFile(fi.FullName);

                                    // End the response
                                    Response.Flush();
                                }
                                if (fi.Extension == ".doc")
                                {
                                    Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                                    // Add the file size into the response header
                                    Response.AddHeader("Content-Length", fi.Length.ToString());

                                    // Set the ContentType
                                    Response.ContentType = "application/ms-word";

                                    // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                                    Response.TransmitFile(fi.FullName);

                                    // End the response
                                    Response.Flush();
                                }
                                if (fi.Extension == ".docx")
                                {
                                    Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                                    // Add the file size into the response header
                                    Response.AddHeader("Content-Length", fi.Length.ToString());

                                    // Set the ContentType
                                    Response.ContentType = "application/ms-word";

                                    // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                                    Response.TransmitFile(fi.FullName);

                                    // End the response
                                    Response.Flush();
                                }
                                if (fi.Extension == ".csv")
                                {
                                    Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                                    // Add the file size into the response header
                                    Response.AddHeader("Content-Length", fi.Length.ToString());

                                    // Set the ContentType
                                    Response.ContentType = "application/vnd.ms-excel";

                                    // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                                    Response.TransmitFile(fi.FullName);

                                    // End the response
                                    Response.Flush();
                                }
                                if (fi.Extension == ".gif")
                                {
                                    Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                                    // Add the file size into the response header
                                    Response.AddHeader("Content-Length", fi.Length.ToString());

                                    // Set the ContentType
                                    Response.ContentType = "image/gif";

                                    // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                                    Response.TransmitFile(fi.FullName);

                                    // End the response
                                    Response.Flush();
                                }

                                if (fi.Extension == ".html")
                                {
                                    Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                                    // Add the file size into the response header
                                    Response.AddHeader("Content-Length", fi.Length.ToString());

                                    // Set the ContentType
                                    Response.ContentType = "text/HTML";

                                    // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                                    Response.TransmitFile(fi.FullName);

                                    // End the response
                                    Response.Flush();
                                }

                                if (fi.Extension == ".htm")
                                {
                                    Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                                    // Add the file size into the response header
                                    Response.AddHeader("Content-Length", fi.Length.ToString());

                                    // Set the ContentType
                                    Response.ContentType = "text/HTML";

                                    // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                                    Response.TransmitFile(fi.FullName);

                                    // End the response
                                    Response.Flush();
                                }

                                if (fi.Extension.ToUpper() == ".TIF")
                                {
                                    Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                                    // Add the file size into the response header
                                    Response.AddHeader("Content-Length", fi.Length.ToString());

                                    // Set the ContentType
                                    Response.ContentType = "image/tiff";

                                    // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                                    Response.TransmitFile(fi.FullName);

                                    // End the response
                                    Response.Flush();
                                }

                            }

                        }
                        lblMsg.Text = "File Not Found..";
                        lblMsg.Visible = true;
                        return;
                    }
                }
            }
            else
            {
                lblMsg.Text = "File Not Found..";
                lblMsg.Visible = true;
                return;
            }
        }



        catch (Exception ex)
        {
            ClassLog objErr = new ClassLog();
            objErr.errLog(ex);
        }


    }

}