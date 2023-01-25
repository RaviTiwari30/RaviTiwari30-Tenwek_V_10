using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Equipment_Masters_SetAssetLocation : System.Web.UI.Page
{
    public enum makejson
    {
        e_without_square_brackets,
        e_with_square_brackets
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            lblDeptLedgerNo.Text = Session["DeptLedgerNo"].ToString();
            ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
           
            BindDepartment();
            BindRooms();
           
        }
        lblMsg.Text = "";

    }

    private void BindRooms()
    {
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(" SELECT  CONCAT(rm.RoomName,'(Location: ',l.LocationName,')')RoomName,rm.RoomID FROM eq_Room_master rm INNER JOIN eq_location_master l ON l.LocationID=rm.LocationID WHERE rm.ISActive=1 AND rm.`DepartmentID`='" + Session["DeptLedgerNo"].ToString() + "' ORDER BY RoomName ");
        if (dt.Rows.Count > 0)
        {
            ddlRooms.DataSource = dt;
            ddlRooms.DataTextField = "RoomName";
            ddlRooms.DataValueField = "RoomID";
            ddlRooms.DataBind();

            ddlEditRoom.DataSource = dt;
            ddlEditRoom.DataTextField = "RoomName";
            ddlEditRoom.DataValueField = "RoomID";
            ddlEditRoom.DataBind();

        }
        ddlEditRoom.Items.Insert(0, new ListItem("Select", "0"));
        ddlRooms.Items.Insert(0, new ListItem("Select", "0"));

      
    }

    private void BindDepartment()
    {
        DataTable dt = new DataTable();
      dt=  LoadCacheQuery.bindStoreDepartment();
      if (dt.Rows.Count > 0)
      {
          ddlDepartment.DataSource=dt;
          ddlDepartment.DataTextField = "LedgerName";
          ddlDepartment.DataValueField = "LedgerNumber";
          ddlDepartment.DataBind();

          ddlEditDept.DataSource = dt;
          ddlEditDept.DataTextField = "LedgerName";
          ddlEditDept.DataValueField = "LedgerNumber";
          ddlEditDept.DataBind();
          ddlDepartment.SelectedValue = HttpContext.Current.Session["DeptLedgerNo"].ToString();
          ddlEditDept.SelectedValue = HttpContext.Current.Session["DeptLedgerNo"].ToString(); 
      }
    
        
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string CheckDuplicate(string StockID)
    {

       int IsExist=Util.GetInt (StockReports.ExecuteScalar("select count(*) from eq_asset_Location where StockId='" + StockID + "'"));
       if (IsExist>0)
        return "1";
       else
           return "0";
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetAssetDetails(string FromDate, string ToDate, string EditDeptID, string QueryType)
    {
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT 1 qty, eal.`AssetName`,eal.`AssetID`,eal.`RoomID`,eal.`RoomName`,(SELECT NAME FROM employee_master WHERE Employee_ID=eal.`insertby` )SubmitBy,eal.`insertby`,DATE_FORMAT(eal.`insertdate`,'%d %b %y %h:%i %p')insertdate,eal.`DepartmentID`,eal.`Department`,eal.`ItemId`,eal.`StockId` FROM eq_asset_Location eal ");
        if (QueryType != "1")
        {
            sb.Append(" where eal.insertdate>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' and eal.insertdate<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
            if (EditDeptID != "0")
                sb.Append(" and eal.`DepartmentID`='" + EditDeptID + "' order by ID desc ");
        }
        else
         sb.Append(" where eal.`DepartmentID`='" + EditDeptID + "' order by ID desc limit 10 ");
        
        //if (EditRoomID != "" )
        //    sb.Append(" and eal.`RoomID`='" + EditRoomID.Trim() + "' ");
       dt= StockReports.GetDataTable(sb.ToString());
       return makejsonoftable(dt, makejson.e_without_square_brackets);
    }
    
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string LoadRooms(string DeptID)
    {
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT  CONCAT(rm.RoomName,'(Location: ',l.LocationName,')')RoomName,rm.RoomID FROM eq_Room_master rm INNER JOIN eq_location_master l ON l.LocationID=rm.LocationID WHERE rm.ISActive=1  ");
            if(DeptID.Trim()!="" && DeptID!="0")
                sb.Append(" AND rm.`DepartmentID`='" + DeptID + "' ");
        sb.Append(" ORDER BY rm.`RoomName` ");
        dt = StockReports.GetDataTable(sb.ToString());
        return makejsonoftable(dt, makejson.e_without_square_brackets);
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveAssetLocation(List<string[]> AssetTableData, string Update_stockID)
    {

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction objTran = con.BeginTransaction(IsolationLevel.ReadCommitted);
        try
        {
            if (Update_stockID == "")
            {
                foreach (string[] asset in AssetTableData)
                {
                    int IsNotValid = Util.GetInt(StockReports.ExecuteScalar(" select count(*) from eq_asset_Location where StockId='" + asset[10] + "' "));
                    if (IsNotValid > 0)
                        return "-2";


                }
                foreach (string[] ass in AssetTableData)
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append(" INSERT INTO eq_asset_Location(AssetID,AssetName,ItemId,StockId,RoomID,RoomName,DepartmentID,Department,insertby,insertdate,ipnumber) VALUES");
                    sb.Append(" ('" + ass[13] + "','" + ass[0] + "','" + ass[11] + "','" + ass[10] + "','" + ass[9] + "','" + ass[8] + "','" + ass[12] + "','" + ass[7] + "','" + Util.GetString(HttpContext.Current.Session["ID"]) + "',now(),'" + All_LoadData.IpAddress() + "')");

                    MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, sb.ToString());
                }
            }
            else
            {
                foreach (string[] ass in AssetTableData)
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append(" UPDATE eq_asset_Location SET RoomID='" + ass[9] + "',RoomName='" + ass[8] + "',DepartmentID='" + ass[12] + "',Department='" + ass[7] + "',ipnumber='" + All_LoadData.IpAddress() + "',updatedate=now(),updateby='" + Util.GetString(HttpContext.Current.Session["ID"]) + "' where StockId='" + Update_stockID + "' ");
                    MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, sb.ToString());
                }
            }

           



            objTran.Commit();
            objTran.Dispose();
            con.Close();
            con.Dispose();

            return "1";
        }
        catch (Exception ex)
        {
            ClassLog log = new ClassLog();
            log.errLog(ex);
            objTran.Rollback();
            objTran.Dispose();
            con.Close();
            con.Dispose();

            return "-1";
        }

    }


    public static string makejsonoftable(DataTable table, makejson e)
    {
        StringBuilder sb = new StringBuilder();
        foreach (DataRow dr in table.Rows)
        {
            if (sb.Length != 0)
                sb.Append(",");
            sb.Append("{");
            StringBuilder sb2 = new StringBuilder();
            foreach (DataColumn col in table.Columns)
            {
                string fieldname = col.ColumnName;
                string fieldvalue = dr[fieldname].ToString();
                if (sb2.Length != 0)
                    sb2.Append(",");
                sb2.Append(string.Format("{0}:\"{1}\"", fieldname, fieldvalue));


            }
            sb.Append(sb2.ToString());
            sb.Append("}");


        }
        if (e == makejson.e_with_square_brackets)
        {
            sb.Insert(0, "[");
            sb.Append("]");
        }
        return sb.ToString();


    }
    

 



    
}