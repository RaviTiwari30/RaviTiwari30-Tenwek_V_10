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

public partial class Design_Equipment_Masters_AssetWoGRN : System.Web.UI.Page
{
    string upld = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["ID"] = Session["ID"].ToString();
            ViewState["IPAddress"] = All_LoadData.IpAddress().ToString();
            BindAssetType();
            BindSupplierType();
            //BindLocation();
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
        //    if (flServiceAgreement.HasFile)
        // ViewState["FileName"] = flServiceAgreement.PostedFile;

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

    private void BindAssetType()
    {
        string str = "Select AssetTypeName,AssetTypeID from eq_assettype_master where isActive=1 ";
        if (Session["roleid"].ToString() != "180")
        {
            str += " And roleid='" + Session["roleid"].ToString() + "' order by AssetTypeName";

        }
        else
        {
            str += " order by AssetTypeName ";
        }
        DataTable dt = StockReports.GetDataTable(str);
        ddlAssetType.DataSource = dt;
        ddlAssetType.DataTextField = "AssetTypeName";
        ddlAssetType.DataValueField = "AssetTypeID";
        ddlAssetType.DataBind();

        ddlAssetType.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        ddlAssetType.SelectedIndex = 0;

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

        //ddlSupplier.DataSource = dt;
        //ddlSupplier.DataTextField = "SupplierTypeName";
        //ddlSupplier.DataValueField = "SupplierTypeID";
        //ddlSupplier.DataBind();
        //BindSupplierList();

        //ddlSupplierService.DataSource = dt;
        //ddlSupplierService.DataTextField = "SupplierTypeName";
        //ddlSupplierService.DataValueField = "SupplierTypeID";
        //ddlSupplierService.DataBind();
        //BindSupplierList();
    }
    private void BindSupplierList()
    {
        // string str = "Select SupplierName,SupplierID from eq_Supplier_master where isActive=1";
        //string str = "SELECT VendorName,SupplierTypeID FROM f_servicetypemaster WHERE isActive=1 ";
        string str = "SELECT VendorName,Vendor_ID FROM f_vendormaster WHERE isActive=1 ";
        if (ddlSupplierType.SelectedValue != "SELECT")
            str += " AND SupplierTypeID = '" + ddlSupplierType.SelectedValue + "' ";

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
                BindRoom(ddlLocation.SelectedValue, ddlFloor.SelectedValue);
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
    //private void BindFloor(string location)
    //{
    //    //DataTable dt = StockReports.GetDataTable("SELECT LocationName,LocationID FROM eq_location_master WHERE ISACTIVE=1 AND Floorid='" + LocationID + "' ORDER BY LocationName ASC");
    //    DataTable dt = StockReports.GetDataTable("SELECT floorid,floorname FROM eq_floor_master WHERE isactive=1 AND locationid='" + loction + "' ORDER BY floorname ASC");
    //    ddlFloor.DataSource = dt;
    //    ddlFloor.DataTextField = "LocationName";
    //    ddlFloor.DataValueField = "LocationID";
    //    ddlFloor.DataBind();
    //    ddlFloor.Items.Insert(0, new ListItem("SELECT", "SELECT"));
    //    ddlFloor.SelectedIndex = 0;
    //    BindRoom(ddlFloor.SelectedValue, ddlLocation.SelectedValue);
    //}
    private void BindRoom(string LocationID, string FloorID)
    {
        DataTable dt = StockReports.GetDataTable("SELECT roomid,roomname FROM eq_room_master WHERE floorid='" + FloorID + "' AND locationid='" + LocationID + "' AND isactive=1 ORDER BY roomname ASC ");
        ddlRoom.DataSource = dt;
        ddlRoom.DataTextField = "roomname";
        ddlRoom.DataValueField = "roomid";
        ddlRoom.DataBind();

        ddlRoom.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        ddlRoom.SelectedIndex = 0;
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


            if (ddlFloor.SelectedValue.ToUpper() == "SELECT")
            {
                lblMsg.Text = "Select Floor..";
                ddlFloor.Focus();
                return false;
            }

            if (ddlLocation.SelectedValue.ToUpper() == "SELECT")
            {
                lblMsg.Text = "Select Location..";
                ddlLocation.Focus();
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

            //if (fileUpload1.PostedFile.ContentLength == 0)
            //{
            //    lblMsg.Visible = true;
            //    lblMsg.Text = "Please Browse File ..";
            //    return false;
            //}

            //if (ucAssignedOn.GetDateForDataBase() == string.Empty)
            //{
            //    lblMsg.Text = "Provide the Date when asset is assigned on...";
            //    ucAssignedOn.Focus();
            //    return false;
            //}

            string IsExist = "", str = "";
            str = "Select AssetID from eq_asset_master where AssetTypeID=" + ddlAssetType.SelectedValue + " and AssetName ='" + txtAssetName.Text.Trim() + "'";
            IsExist = StockReports.ExecuteScalar(str);

            if (IsExist != "")
            {
                lblMsg.Text = "Asset Name already exists in this Asset Type...";
                return false;
            }

            IsExist = "";
            str = "Select AssetID from eq_asset_master where AssetCode ='" + txtAssetCode.Text.Trim() + "'";
            IsExist = StockReports.ExecuteScalar(str);

            if (IsExist != "")
            {
                lblMsg.Text = "Asset Code already exists...";
                return false;
            }

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
        BindSupplierList();
    }

    protected void ddlLocation_SelectedIndexChanged(object sender, EventArgs e)
    {
        ////BindFloor(ddlLocation.SelectedValue);
        BindRoom(ddlLocation.SelectedValue, ddlFloor.SelectedValue);
    }
    protected void ddlFloor_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindLocation(ddlFloor.SelectedValue);
        //BindRoom(ddlFloor.SelectedValue, ddlLocation.SelectedValue);
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

        //string strr =Util.GetDateTime( ucPurDate.Text).ToString("yyyy-MM-dd");
        //string date1 =Util.GetDateTime( ucInstallationDate.Text).ToString("yyyy-MM-dd");
        //string date2 = Util.GetDateTime(ucWarrantyFrom.Text).ToString("yyyy-MM-dd");
        //string date3 =Util.GetDateTime( ucWarrantyTo.Text).ToString("yyyy-MM-dd");

        //  string date= Util.GetDateTime( ucFreeServiceFrom.Text).ToString("yyyy-MM-dd");
        //string data5 = Util.GetDateTime(ucFreeServiceTo.Text).ToString("yyyy-MM-dd");
        //string data6 = Util.GetDateTime(ucServiceFrom.Text).ToString("yyyy-MM-dd");
        //string data7 = Util.GetDateTime(ucServiceTo.Text).ToString("yyyy-MM-dd");
        if (btnsave.Text == "Save")
        {

            try
            {
                str = "";
                str += "INSERT INTO eq_asset_master(AssetName,AssetCode,AssetTypeID,";
                str += "SerialNo,ModelNo,TagNo,SupplierID,SupplierTypeID,TechnicalDtl,";
                str += "PurchaseDate,InstallationDate,WarrantyFrom,WarrantyTo,";
                str += "FreeServiceFrom,FreeServiceTo,WarrantyTerms,AmcTypeID,";
                str += "ServiceSupplierID,ServiceDateFrom,ServiceDateTo,";
                str += "LastServiceDate,NextServiceDate,LocationID,";
                str += "FloorID,RoomID,AssignedTo,STATUS,Isactive,";
                str += "insertby,updateby,updatedate,Ipnumber,AssigneDate)";
                str += "VALUES (";
                str += "'" + txtAssetName.Text.Trim() + "','" + txtAssetCode.Text.Trim() + "','" + ddlAssetType.SelectedValue + "',";
                str += "'" + txtSerialNo.Text.Trim() + "','" + txtModelNo.Text.Trim() + "','" + txtTagNo.Text.Trim() + "','" + ddlSupplier.SelectedValue + "','" + ddlSupplierType.SelectedValue + "','" + txtTechnical.Text.Trim() + "',";
                str += "'" + Util.GetDateTime(ucPurDate.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ucInstallationDate.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ucWarrantyFrom.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ucWarrantyTo.Text).ToString("yyyy-MM-dd") + "',";
                str += "'" + Util.GetDateTime(ucFreeServiceFrom.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ucFreeServiceTo.Text).ToString("yyyy-MM-dd") + "','" + txtWarrantyCondition.Text.Trim() + "','" + ddlAmcType.SelectedValue + "',";
                str += "'" + ddlSupplierService.SelectedValue + "','" + Util.GetDateTime(ucServiceFrom.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ucServiceTo.Text).ToString("yyyy-MM-dd") + "',";
                str += "'" + Util.GetDateTime(ucLastServiceDate.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ucNextServiceDate.Text).ToString("yyyy-MM-dd") + "','" + ddlLocation.SelectedValue + "',";
                str += "'" + ddlFloor.SelectedValue + "','" + ddlRoom.SelectedValue + "','" + txtAssignedTo.Text.Trim() + "','" + ddlStatus.SelectedValue + "','" + 1 + "',";
                str += "'" + ViewState["ID"].ToString() + "','',now(),'" + ViewState["IPAddress"].ToString() + "','" + Util.GetDateTime(ucAssignedOn.Text).ToString("yyyy-MM-dd") + "')";

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);



                tnx.Commit();

                string assetID = "Select AssetID from eq_asset_master where AssetTypeID=" + ddlAssetType.SelectedValue + " and AssetName ='" + txtAssetName.Text.Trim() + "' and AssetCode='" + txtAssetCode.Text.Trim() + "'";
                assetID = StockReports.ExecuteScalar(assetID);
                ViewState["AssetID"] = assetID;
                if (fileUpload1.PostedFile.ContentLength != 0)
                {
                    fileupload();
                }
                str = "";
                str = "INSERT INTO eq_asset_transfer (AssetID,AssetName,Assetcode,AssignedTo,LocationID,floorID,RoomID,Iscurrent,STATUS,remark,AssigneDate,insertby,insertdate,Ipnumber)VALUES ";
                str += "('" + Util.GetInt(assetID) + "','" + txtAssetName.Text.Trim() + "','" + txtAssetCode.Text.Trim() + "','" + txtAssignedTo.Text.Trim() + "','" + ddlLocation.SelectedValue + "','" + ddlFloor.SelectedValue + "',";
                str += "'" + ddlRoom.SelectedValue + "',1,1,'','" + Util.GetDateTime(ucAssignedOn.Text).ToString("yyyy-MM-dd") + "',";
                str += "'" + ViewState["ID"].ToString() + "',now(),'" + ViewState["IPAddress"].ToString() + "')";
                StockReports.ExecuteDML(str);

                str = "";

                upld = upld.Replace("\\", "''");
                upld = upld.Replace("'", "\\");
                if (fileUpload1.PostedFile.ContentLength != 0)
                str = "  UPDATE  eq_asset_master SET  AgreementFileName='" + fileUpload1.FileName + "',fileUrl='" + upld + "' WHERE assetID='" + assetID + "' ";

                StockReports.ExecuteDML(str);



                conn.Close();
                conn.Dispose();

                lblMsg.Text = "Record Saved";
                btnsave.Text = "Save";
                Clear();


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

    private void Clear()
    {
        txtAssetName.Text = "";
        txtAssetCode.Text = "";
        txtAssetCode.Text = "";
        txtSerialNo.Text = "";
        txtModelNo.Text = "";
        txtTagNo.Text = "";
        txtMake.Text = "";
        txtTechnical.Text = "";
        txtWarrantyCondition.Text = "";
        txtAssignedTo.Text = "";
        ucAssignedOn.Text = "";  

        ddlSupplierType.SelectedIndex = 0;
        ddlAmcType.SelectedIndex = 0;
        ddlFloor.SelectedIndex = 0;
        ddlStatus.SelectedIndex = 0;
        ddlSupplier.SelectedItem.Text = "";
        ddlSupplierService.SelectedItem.Text = "";
        ddlRoom.SelectedItem.Text = "";
        ddlLocation.SelectedItem.Text = "";


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

    protected void btnclear_Click(object sender, EventArgs e)
    {
        Clear();
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

}