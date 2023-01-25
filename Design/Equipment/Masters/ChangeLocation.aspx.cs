using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

using System.Data;


public partial class Design_Equipment_Masters_ChangeLocation : System.Web.UI.Page
{
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
            
            ViewState["ID"] = Session["ID"].ToString();
            ViewState["IPAddress"] = All_LoadData.IpAddress().ToString();
            location();
            BindAssetType();
            Bindfloor();
            BindChangeFloor();
            Bindchangeroom();
            BindLocationType();

            if (Request.QueryString.Count > 1)
            {
                if (Request.QueryString["BTN"].ToString() != null || Request.QueryString["BTN"].ToString() != "")
                    ViewState["BTN"] = "1";
            }
            else
                ViewState["BTN"] = "0";
            ucchangeAssignedOn.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }

        ucchangeAssignedOn.Attributes.Add("readonly", "readonly");
    }

    private void BindLocationType()
    {
        //DataTable dt = StockReports.GetDataTable("SELECT RoleId,Locationname FROM eq_location_master WHERE isactive=1 and RoleId='"+Session["RoleID"].ToString()+"' order by Locationname");
        DataTable dt = StockReports.GetDataTable("SELECT locationID,Locationname FROM eq_location_master WHERE isactive=1  order by Locationname");
        ddlLocationType.DataSource = dt;
        ddlLocationType.DataTextField = "Locationname";
        ddlLocationType.DataValueField = "locationID";
        ddlLocationType.DataBind();
        ddlLocationType.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        ddlLocationType.SelectedIndex = 0;
    }

    private void Bindchangeroom()
    {
        DataTable dt = StockReports.GetDataTable("SELECT RoomName,RoomID FROM eq_room_master WHERE IsActive='1' ORDER BY RoomName");
        ddlchangeroom.DataSource = dt;
        ddlchangeroom.DataTextField = "RoomName";
        ddlchangeroom.DataValueField = "RoomID";
        ddlchangeroom.DataBind();
        ddlchangeroom.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        ddlchangeroom.SelectedIndex = 0;
    }

    private void BindChangeFloor()
    {
        DataTable dt = StockReports.GetDataTable("select FloorName,FloorID FROM eq_floor_master where isActive=1 order by FloorName");
        ddlchangefloor.DataSource = dt;
        ddlchangefloor.DataTextField = "FloorName";
        ddlchangefloor.DataValueField = "FloorID";
        ddlchangefloor.DataBind();
        ddlchangefloor.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        ddlchangefloor.SelectedIndex = 0;
    }

    private void Bindfloor()
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
        DataTable dt = StockReports.GetDataTable("Select AssetTypeName,AssetTypeID from eq_assettype_master where isActive=1 order by AssetTypeName");
        ddlserchassettype.DataSource = dt;
        ddlserchassettype.DataTextField = "AssetTypeName";
        ddlserchassettype.DataValueField = "AssetTypeID";
        ddlserchassettype.DataBind();

        ddlserchassettype.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        ddlserchassettype.SelectedIndex = 0;

    }
    public void location()
    {
        DataTable dt = BindLocation();
        if (dt.Rows.Count > 0)
        {
            ddlLocation.DataSource = dt;
            ddlLocation.DataTextField = "locationname";
            ddlLocation.DataValueField = "locationid";
            ddlLocation.DataBind();
            ddlLocation.Items.Insert(0, new ListItem("SELECT", "SELECT"));
            ddlLocation.SelectedIndex = 0;
            BindFloor(ddlLocation.SelectedValue);
            ddlchangelocation.DataSource = dt;
            ddlchangelocation.DataTextField = "locationname";
            ddlchangelocation.DataValueField = "locationid";
            ddlchangelocation.DataBind();
            ddlchangelocation.Items.Insert(0, new ListItem("SELECT", "SELECT"));
            ddlchangelocation.SelectedIndex = 0;
            BindFloor(ddlchangelocation.SelectedValue);
        }
    }
    private DataTable BindLocation()
    {
        DataTable dt = StockReports.GetDataTable("SELECT locationid,locationname FROM eq_location_master WHERE isactive=1 ORDER BY locationname ASC");
        return dt;
    }

    private DataTable BindFloor(string loction)
    {
        DataTable dt = StockReports.GetDataTable("SELECT fm.floorid,fm.floorname FROM eq_floor_master fm INNER JOIN eq_location_master lm ON  fm.FloorID=lm.FloorID WHERE fm.isactive=1 AND lm.locationid='" + loction + "' ORDER BY fm.floorname ASC");
        return dt;
    }
    private DataTable BindRoom(string floor, string location)
    {

        DataTable dt = StockReports.GetDataTable("SELECT roomid,roomname FROM eq_room_master WHERE floorid='" + floor + "' AND locationid='" + location + "' AND isactive=1 ORDER BY roomname ASC ");
        return dt;
    }


    protected void ddlLocation_SelectedIndexChanged(object sender, EventArgs e)
    {
        DataTable dt = BindFloor(ddlLocation.SelectedValue);
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
    }

    protected void ddlFloor_SelectedIndexChanged(object sender, EventArgs e)
    {
        DataTable dt = BindRoom(ddlFloor.SelectedValue, ddlLocation.SelectedValue);
        if (dt.Rows.Count > 0)
        {
            ddlRoom.DataSource = dt;
            ddlRoom.DataTextField = "roomname";
            ddlRoom.DataValueField = "roomid";
            ddlRoom.DataBind();
            ddlRoom.Items.Insert(0, new ListItem("SELECT", "SELECT"));
            ddlRoom.SelectedIndex = 0;
        }
    }

    protected void ddlchangelocation_SelectedIndexChanged(object sender, EventArgs e)
    {
        DataTable dt = BindFloor(ddlchangelocation.SelectedValue);
        if (dt.Rows.Count > 0)
        {
            ddlchangefloor.DataSource = dt;
            ddlchangefloor.DataTextField = "floorname";
            ddlchangefloor.DataValueField = "floorid";
            ddlchangefloor.DataBind();
            ddlchangefloor.Items.Insert(0, new ListItem("SELECT", "SELECT"));
            ddlchangefloor.SelectedIndex = 0;
            DataTable dtt = BindRoom(ddlchangefloor.SelectedValue, ddlchangelocation.SelectedValue);
            if (dtt.Rows.Count > 0)
            {
                ddlchangeroom.DataSource = dtt;
                ddlchangeroom.DataTextField = "roomname";
                ddlchangeroom.DataValueField = "roomid";
                ddlchangeroom.DataBind();

                ddlchangeroom.Items.Insert(0, new ListItem("SELECT", "SELECT"));
                ddlchangeroom.SelectedIndex = 0;
            }

        }
    }
    protected void ddlchangefloor_SelectedIndexChanged(object sender, EventArgs e)
    {
        DataTable dt = BindRoom(ddlchangefloor.SelectedValue, ddlchangelocation.SelectedValue);
        if (dt.Rows.Count > 0)
        {

            ddlchangeroom.DataSource = dt;
            ddlchangeroom.DataTextField = "roomname";
            ddlchangeroom.DataValueField = "roomid";
            ddlchangeroom.DataBind();

            ddlchangeroom.Items.Insert(0, new ListItem("SELECT", "SELECT"));
            ddlchangeroom.SelectedIndex = 0;
        }
    }

    protected void btnsave_Click(object sender, EventArgs e)
    {

        bool IsValid = CheckValidation();
        if (!IsValid)
            return;

        DataTable dt = (DataTable)ViewState["Asset"];
        if (dt.Rows.Count > 0)
        {
            string str = "INSERT INTO eq_asset_transfer (AssetID,AssetName,Assetcode,AssignedTo,LocationID,floorID,RoomID,Iscurrent,STATUS,remark,AssigneDate,insertby,insertdate,Ipnumber)VALUES ";
            str += "('" + dt.Rows[0]["AssetID"].ToString() + "','" + dt.Rows[0]["AssetName"].ToString() + "','" + dt.Rows[0]["assetCode"].ToString() + "','" + txtassingedto.Text.Trim() + "','" + ddlchangelocation.SelectedValue + "','" + ddlchangefloor.SelectedValue + "',";
            str += "'" + ddlchangeroom.SelectedValue + "',1,1,'','" + Util.GetDateTime(ucchangeAssignedOn.Text).ToString("yyyy-MM-dd") + "', ";
            str += "'" + ViewState["ID"].ToString() + "',now(),'" + ViewState["IPAddress"].ToString() + "')";
            StockReports.ExecuteDML(str);

            str = "";
            str = "UPDATE eq_asset_transfer SET iscurrent=0,updateby='" + ViewState["ID"].ToString() + "',updatedate= now() WHERE id='" + dt.Rows[0]["ID"].ToString() + "' AND AssetID='" + dt.Rows[0]["AssetID"].ToString() + "'";
            StockReports.ExecuteDML(str);
            lblMsg.Text = "Assest Transfer Successfully";
            Clear();
        }
    }

    private void Clear()
    {
        ddlchangefloor.SelectedIndex = 0;
        ddlchangeroom.SelectedIndex = 0;
        ddlchangelocation.SelectedIndex = 0;
        ucchangeAssignedOn.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        txtassingedto.Text = "";

    }
    protected void btnsearch_Click(object sender, EventArgs e)
    {
        LoadData();
        if (ViewState["BTN"].ToString() == "1")
        {
            grdasset.Columns[0].Visible = false;
            grdasset.Columns[1].Visible = false;
            grdasset.Columns[2].Visible = false;
            grdasset.Columns[3].Visible = true;
        }
        else
        {
            grdasset.Columns[0].Visible = true;
            grdasset.Columns[1].Visible = true;
            grdasset.Columns[2].Visible = true;
            grdasset.Columns[3].Visible = false;
        }

    }
    protected void grdasset_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        lblMsg.Text = "";

        string AssetID = Util.GetString(e.CommandArgument);
        if (e.CommandName == "EditAT")
        {
            //    grdasset.DataSource = null;
            //    grdasset.DataBind();
            Panel2.Visible = false;
            Panel1.Visible = true;

            DataTable dt = StockReports.GetDataTable("SELECT * FROM eq_asset_transfer WHERE AssetID='" + AssetID + "' and iscurrent=1 ");
            ViewState["Asset"] = dt;
            ddlLocation.SelectedIndex = ddlLocation.Items.IndexOf(ddlLocation.Items.FindByValue(dt.Rows[0]["LocationID"].ToString()));
            // ddlLocation.SelectedValue = dt.Rows[0]["LocationID"].ToString();
            DataTable dtt = BindFloor(dt.Rows[0]["LocationID"].ToString());
            if (dtt.Rows.Count > 0)
            {
                ddlFloor.DataSource = dtt;
                ddlFloor.DataTextField = "floorname";
                ddlFloor.DataValueField = "floorid";
                ddlFloor.DataBind();
                ddlFloor.Items.Insert(0, new ListItem("SELECT", "SELECT"));
                ddlFloor.SelectedIndex = 0;

            }


            ddlFloor.SelectedValue = dt.Rows[0]["FloorID"].ToString();
            BindRoom(dt.Rows[0]["FloorID"].ToString(), dt.Rows[0]["LocationID"].ToString());

            dtt = BindRoom(ddlFloor.SelectedValue, ddlLocation.SelectedValue);

            if (dtt.Rows.Count > 0)
            {
                ddlRoom.DataSource = dtt;
                ddlRoom.DataTextField = "roomname";
                ddlRoom.DataValueField = "roomid";
                ddlRoom.DataBind();

                ddlRoom.Items.Insert(0, new ListItem("SELECT", "SELECT"));
                ddlRoom.SelectedIndex = 0;
            }
            ddlRoom.SelectedValue = dt.Rows[0]["RoomID"].ToString();
            txtAssignedTo.Text = dt.Rows[0]["AssignedTo"].ToString();
            ucAssignedOn.Text = Util.GetDateTime(dt.Rows[0]["AssigneDate"]).ToString("dd-MMM-yyyy");
        }

        if (e.CommandName == "ShowHistory")
        {
            Panel1.Visible = false;
            Panel2.Visible = false;
            Panel3.Visible = true;
            string str = "SELECT trans.AssetID,trans.AssetName,trans.AssetCode,trans.AssignedTo,trans.Assignedate, ";
            str += " (SELECT locationname FROM eq_location_master WHERE locationid =trans.LocationID )locationname , ";
            str += " (SELECT floorname FROM eq_floor_master WHERE floorid =trans.FloorID )floorname, ";
            str += " (SELECT roomname FROM eq_room_master WHERE roomid =trans.RoomID )roomname, ";
            str += " (SELECT NAME FROM employee_master  WHERE employee_id=trans.insertby LIMIT 1)insertby,trans.insertdate,  ";
            str += " (SELECT NAME FROM employee_master  WHERE  employee_id=trans.updateby LIMIT 1)updateby,trans.updatedate,trans.iscurrent  FROM  eq_asset_transfer trans ";
            str += " WHERE trans.AssetID='" + AssetID + "' ";
            DataTable dt = StockReports.GetDataTable(str);
            grdassethistory.DataSource = dt;
            grdassethistory.DataBind();
            //mdlPatient.Show();
        }
    }



    public void LoadData()
    {
        lblMsg.Text = "";
        grdasset.DataSource = null;
        grdasset.DataBind();

        try
        {
            string str = "SELECT AssetID,AssetName,AssetCode,AssetTypeID,SerialNo,ModelNo,TagNo,SupplierID,SupplierTypeID,TechnicalDtl, DATE_FORMAT(PurchaseDate, '%d-%b-%y ')PurchaseDate,DATE_FORMAT(InstallationDate, '%d-%b-%y ')InstallationDate,DATE_FORMAT(WarrantyFrom, '%d-%b-%y ')WarrantyFrom,DATE_FORMAT(WarrantyTo, '%d-%b-%y ')WarrantyTo,";
            str += "DATE_FORMAT(FreeServiceFrom, '%d-%b-%y ') FreeServiceFrom,DATE_FORMAT(FreeServiceTo, '%d-%b-%y ')FreeServiceTo,WarrantyTerms,AmcTypeID,ServiceSupplierID,DATE_FORMAT(ServiceDateFrom, '%d-%b-%y ')ServiceDateFrom,DATE_FORMAT(ServiceDateTo, '%d-%b-%y ')ServiceDateTo, DATE_FORMAT(LastServiceDate, '%d-%b-%y ')LastServiceDate,DATE_FORMAT(NextServiceDate, '%d-%b-%y ')NextServiceDate,LocationID,";
            str += "  FloorID,RoomID,AssignedTo,STATUS,IF(Isactive=1,'Yes','No') IsActive,insertby,updateby,DATE_FORMAT(updatedate, '%d-%b-%y ')updatedate,Ipnumber,(SELECT LocationName FROM  eq_location_master WHERE locationid=asm.locationid)LocationType FROM eq_asset_master asm where Isactive=1 ";

            if (ddlLocationType.SelectedIndex != 0)
            {
                str += " AND locationID = '" + ddlLocationType.SelectedValue + "' ";
            }
            if (txtsearchassetname.Text != "")
            {
                str += " AND Assetname LIKE '" + txtsearchassetname.Text.Trim() + "%'";
            }
            if (txtseatchAssetcode.Text != "")
            {
                str += " AND AssetCode LIKE '" + txtseatchAssetcode.Text.Trim() + "%'";
            }

            if (txtsearchsuppliername.Text != "")
            {
                str += " AND   SupplierTypeID=(SELECT SupplierTypeID FROM f_vendormaster WHERE VendorName LIKE '" + txtsearchsuppliername.Text.Trim() + "%' AND  isActive=1 )";
            }
            if (ddlserchassettype.SelectedIndex != 0)
            {
                str += "  AND  AssetTypeID='" + ddlserchassettype.SelectedValue + "' ";
            }

            DataTable dt = StockReports.GetDataTable(str);

            if (dt.Rows.Count > 0)
            {
                grdasset.DataSource = dt;
                grdasset.DataBind();
                Panel1.Visible = false;
                Panel2.Visible = true;
            }
            else
            {
                lblMsg.Text = "Record Not Found";
            }

        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.Message;
        }

    }

    protected void btnclear_Click(object sender, EventArgs e)
    {
        Panel2.Visible = true;
        Panel1.Visible = false;

    }
    protected void btnInfoCancel_Click(object sender, EventArgs e)
    {
        Panel3.Visible = false;
        Panel2.Visible = true;
    }
    protected void grdasset_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        //if (e.Row.RowType == DataControlRowType.DataRow)
        //{
        //    DataControlFieldCell imbEdit = ((ImageButton)e.Row.FindControl("imbEdit")).Parent as DataControlFieldCell;
        //    DataControlFieldCell imbHistory = ((ImageButton)e.Row.FindControl("imbHistory")).Parent as DataControlFieldCell;
        //    DataControlFieldCell imbView = ((ImageButton)e.Row.FindControl("imbView")).Parent as DataControlFieldCell;  

        //    if (ViewState["BTN"].ToString() == "1")
        //    {
        //        imbEdit.Visible = false;
        //        imbHistory.Visible = false;
        //        imbView.Visible = false;                
        //        //e.Row.Cells[0].Visible = false;
        //        //e.Row.Cells[1].Visible = false;
        //        //e.Row.Cells[2].Visible = false;
        //    }
        //    else
        //    {
        //        imbEdit.Visible = true;
        //        imbHistory.Visible = true;
        //        imbView.Visible = true;
        //        //e.Row.Cells[0].Visible = true;
        //        //e.Row.Cells[1].Visible = true;
        //        //e.Row.Cells[2].Visible = true;
        //    }
        //}
    }
    protected void grdasset_SelectedIndexChanged(object sender, EventArgs e)
    {
        string LoctaionType = ((Label)(grdasset.SelectedRow.FindControl("lblLocationType"))).Text;
        string LoctaionID = ((Label)(grdasset.SelectedRow.FindControl("lblLocationId"))).Text;
        string AssetID = ((Label)(grdasset.SelectedRow.FindControl("lblAssetID"))).Text;
        string AssetName = ((Label)(grdasset.SelectedRow.FindControl("lblAssetName"))).Text;
        string AssetCode = ((Label)(grdasset.SelectedRow.FindControl("lblAssetCode"))).Text;

        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "clickBTNADD('" + LoctaionID + "','" + LoctaionType + "','" + AssetID + "','" + AssetName + "','" + AssetCode + "');", true);
    }

    private bool CheckValidation()
    {

        if (ddlchangefloor.SelectedValue.ToUpper() == "SELECT")
        {
            lblMsg.Text = "Select Floor..";
            ddlchangefloor.Focus();
            return false;
        }

        if (ddlchangelocation.SelectedValue.ToUpper() == "SELECT")
        {
            lblMsg.Text = "Select Location..";
            ddlchangelocation.Focus();
            return false;
        }

        if (ddlchangeroom.SelectedValue.ToUpper() == "SELECT")
        {
            lblMsg.Text = "Select Room..";
            ddlchangeroom.Focus();
            return false;
        }

        if (txtassingedto.Text.Trim() == string.Empty)
        {
            lblMsg.Text = "Provide Name of the person whom Asset is assigned to..";
            txtassingedto.Focus();
            return false;
        }

        if (ucchangeAssignedOn.Text.Trim() == string.Empty)
        {
            lblMsg.Text = "Provide the Date when asset is assigned on...";
            ucchangeAssignedOn.Focus();
            return false;
        }

        return true;

    }

}