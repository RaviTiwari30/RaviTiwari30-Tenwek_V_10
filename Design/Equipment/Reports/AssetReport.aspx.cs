using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public partial class Design_IPD_AssetReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            chkItems.Visible = false;

            ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            BindAssetType();
        }

        ucFromDate.Attributes.Add("readonly", "readonly");
        ucToDate.Attributes.Add("readonly", "readonly");
    }

    private void BindAssetType()
    {
        DataTable dt = StockReports.GetDataTable("Select AssetTypeName,AssetTypeID from eq_assettype_master where isActive=1 order by AssetTypeName");
        ddlReportType.DataSource = dt;
        ddlReportType.DataTextField = "AssetTypeName";
        ddlReportType.DataValueField = "AssetTypeID";
        ddlReportType.DataBind();

        ddlReportType.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        ddlReportType.SelectedIndex = 0;

    }





    public DataTable LoadData(string status, string AssetTypeID)
    {


        string str = "SELECT ast.AssetID,ast.AssetName,ast.AssetCode,(SELECT AssetTypeName FROM eq_assettype_master WHERE  AssetTypeID=ast.AssetTypeID)AssetTypeName, ";
        str += "ast.SerialNo,ast.ModelNo,ast.TagNo, ";
        str += "(SELECT VendorName FROM f_vendormaster WHERE Vendor_ID =ast.SupplierID LIMIT 1)VendorName, ";

        str += "(SELECT SupplierTypeName FROM eq_SupplierType_master WHERE SupplierTypeID=ast.SupplierTypeID)SupplierTypeName, ";
        str += "ast.TechnicalDtl,  ";
        str += "DATE_FORMAT(ast.PurchaseDate, '%d-%b-%y ')PurchaseDate,DATE_FORMAT(ast.InstallationDate, '%d-%b-%y ')InstallationDate, ";
        str += "DATE_FORMAT(ast.WarrantyFrom, '%d-%b-%y ')WarrantyFrom, ";
        str += "DATE_FORMAT(ast.WarrantyTo, '%d-%b-%y ')WarrantyTo,DATE_FORMAT(ast.FreeServiceFrom, '%d-%b-%y ') FreeServiceFrom, ";
        str += " DATE_FORMAT(ast.FreeServiceTo, '%d-%b-%y ')FreeServiceTo, ";
        str += "WarrantyTerms, (SELECT AMCtypeName FROM eq_amctype_master WHERE  AMCtypeID=ast.AmcTypeID)AMCtypeName ";
        str += ",ServiceSupplierID,DATE_FORMAT(ast.ServiceDateFrom, '%d-%b-%y ')ServiceDateFrom, ";
        str += " DATE_FORMAT(ast.ServiceDateTo, '%d-%b-%y ')ServiceDateTo, ";
        str += "DATE_FORMAT(ast.LastServiceDate, '%d-%b-%y ')LastServiceDate,DATE_FORMAT(ast.NextServiceDate, '%d-%b-%y ')NextServiceDate, ";
        str += "(SELECT locationname FROM eq_location_master WHERE  locationid=ast.LocationID)locationname,  ";
        str += "(SELECT floorname FROM eq_floor_master WHERE floorid=ast.FloorID)floorname, ";
        str += "(SELECT roomname FROM eq_room_master WHERE roomid=ast.RoomID)roomname,AssignedTo, ";
        str += "IF(STATUS=1,'Active','DeActive')STATUS,IF(Isactive=1,'Active','DeActive')Isactive, (SELECT NAME FROM employee_master WHERE employee_id=ast.insertby)InsertedBy,(SELECT NAME FROM employee_master WHERE employee_id=ast.updateby)updateby,DATE_FORMAT(ast.updatedate, '%d-%b-%y ')updatedate,ast.Ipnumber  ";

        str += "FROM eq_asset_master ast   WHERE ast.isactive='" + status + "'  AND  (DATE(ast.insertdate)>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "'  AND  DATE(ast.insertdate)<='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "')   ";
        if (AssetTypeID.ToString() != "SELECT")
        {

            str += " AND ast.AssetTypeID='" + AssetTypeID + "'";
        }


        DataTable dt = StockReports.GetDataTable(str);

        return dt;
    }


    protected void ddlReportType_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {


        if (Session["LoginType"] == null)
        {
            return;
        }



        DataTable dtUser = new DataTable();
        dtUser = StockReports.GetUserName(Convert.ToString(Session["ID"]));
        DataColumn dc = new DataColumn();
        dc.ColumnName = "Period";
        dc.DefaultValue = "Period From '" + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yyyy") + "' To : '" + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yyyy") + "'";
        dtUser.Columns.Add(dc);

        dc = new DataColumn();
        dc.ColumnName = "ReportType";
        dc.DefaultValue = "2";
        dtUser.Columns.Add(dc);

        DataTable dtreport = new DataTable();

        if (rdoListType.Text == "1")
            dtreport = LoadData("1", ddlReportType.SelectedValue.ToString());
        else
            dtreport = LoadData("0", ddlReportType.SelectedValue.ToString());

        if (dtreport.Rows.Count > 0)
        {
            lblMsg.Text = "Total " + dtreport.Rows.Count + " Record Found";

            DataSet ds = new DataSet();
            ds.Tables.Add(dtreport.Copy());
            ds.Tables[0].TableName = "AssetReport";
            ds.Tables.Add(dtUser.Copy());
            ds.Tables[1].TableName = "User";
            //ds.WriteXmlSchema(@"D:\EquipmentReport.xml");

            Session["EquipmentReport"] = ds;
            string ReportType = "AssetReport";

            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('EquipmentReport.aspx?ReportType=" + ReportType + "');", true);
        }
        else
            lblMsg.Text = "No Record Found";
    }
    protected void rdoListType_SelectedIndexChanged(object sender, EventArgs e)
    {

    }

}

