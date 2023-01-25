<%@ WebService Language="C#" Class="AssetDashBoard" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using MySql.Data.MySqlClient;
using System.Text;
using System.Web.Script.Services;
using System.Web.Script.Serialization;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.ComponentModel;
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
 [System.Web.Script.Services.ScriptService]
public class AssetDashBoard  : System.Web.Services.WebService {

    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }

    [WebMethod]
    public string BindRoleMaster()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT DeptLedgerNo As ID,RoleName ");
        sb.Append("FROM f_rolemaster   ");
        sb.Append("WHERE Active=1 ");
        sb.Append(" Order By RoleName ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod]
    public string GetFloorandAssetCount(string DepartmentId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT rm.FloorID,fm.Name AS FloorName,COUNT(al.ID)TotalAsset,CONCAT(fm.Name ,':',COUNT(al.ID))Label FROM eq_asset_location al ");
        sb.Append("INNER JOIN eq_roommaster rm ON rm.ID=al.RoomID   ");
        sb.Append("INNER JOIN floor_master fm ON fm.ID=rm.FloorID   ");
        sb.Append("WHERE al.deptledgerno='" + DepartmentId + "'  and al.isactive=1");

        sb.Append(" GROUP BY rm.FloorID ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod]
    public string GetRoomList(string selection)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT AssetName,AssetNo,rm.Id,rm.RoomName as Label,COUNT(al.ID) TotalAsset from eq_asset_location al  ");
        sb.Append("INNER JOIN eq_roommaster rm ON rm.ID=al.RoomID   ");
        sb.Append("WHERE floorid='" + selection + "'  and al.isactive=1 ");

        sb.Append(" GROUP BY rm.Id ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod]
    public string GetCubicalDetails(string RoomId, string CubicalId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT AssetName,AssetNo,lm.LocationName,cm.`CubicalName` ");
        if (RoomId != "0")
            sb.Append(" ,rm.`RoomName`   ");
        sb.Append("FROM eq_asset_location al   ");
        sb.Append("INNER JOIN eq_location_master lm ON al.LocationID=lm.ID   ");
        sb.Append("LEFT JOIN eq_roommaster rm ON rm.id=al.RoomID    ");
        sb.Append("LEFT JOIN eq_cubicalmaster cm ON cm.`ID`=al.`CubicalID`   ");
        if (RoomId != "0")
            sb.Append("WHERE al.IsActive=1 and al.RoomId='" + RoomId + "'");
        else if (CubicalId != "0")
            sb.Append("WHERE al.IsActive=1 and al.CubicalId='" + CubicalId + "'");
        DataTable dtRoomList = StockReports.GetDataTable(sb.ToString());

        sb.Clear();
        sb.Append("select al.cubicalid As Id,cm.`CubicalName` as Label,COUNT(al.`ID`)TotalAsset FROM eq_asset_location al  ");
        sb.Append("INNER JOIN eq_location_master lm ON al.LocationID=lm.ID ");
        sb.Append("INNER JOIN eq_roommaster rm ON rm.id=al.RoomID   ");
        sb.Append("INNER  JOIN eq_cubicalmaster cm ON cm.`ID`=al.`CubicalID`   ");
        sb.Append("WHERE al.IsActive=1 and al.RoomId='" + RoomId + "' and al.cubicalid<>0 ");
        sb.Append("GROUP BY al.cubicalid   ");
        DataTable dtCubic = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { dtRoomList = dtRoomList, dtCubic = dtCubic });
        //return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    public void LoadItems(string cmd, string q, string SearchBy, string page, string rows)
    {
        var dt = new System.Data.DataTable();
        try
        {
            System.Text.StringBuilder sb = new System.Text.StringBuilder();

            sb.Append("SELECT Concat(im.TypeName,' - ',am.SerialNo, ' - ',am.AssetNo )assetDetails, im.ItemID,im.TypeName ItemName,am.ID AS AssetID,am.AssetNo,am.SerialNo,am.BatchNumber,am.ModelNo,st.ID AS StockID,st.stockID as f_StockID FROM f_itemmaster im  ");
            sb.Append("INNER JOIN eq_asset_master am ON im.ItemID= am.ItemID ");
            sb.Append("INNER JOIN eq_asset_stock st ON st.AssetID=am.ID ");
            sb.Append("WHERE im.IsActive=1 AND st.IsPost=1 ");
            sb.Append("and ifnull(st.FromStockID,'')='' ");
            if (q.Trim() != "")
            {
                if (SearchBy == "1")
                    sb.Append(" and im.TypeName like '" + q.Trim() + "%'");
                else if (SearchBy == "2")
                    sb.Append(" and am.BatchNumber like '" + q.Trim() + "%'");
                else if (SearchBy == "3")
                    sb.Append(" and am.ModelNo like '" + q.Trim() + "%'");
                else if (SearchBy == "4")
                    sb.Append(" and am.SerialNo like '" + q.Trim() + "%'");
                else if (SearchBy == "5")
                    sb.Append(" and am.AssetNo like '" + q.Trim() + "%'");
            }

            sb.Append(" GROUP BY st.AssetID; ");
            dt = StockReports.GetDataTable(sb.ToString());
            HttpContext.Current.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(dt));
        }
        catch (Exception)
        {

            throw;
        }
        
    }
    [WebMethod(EnableSession=true)]
    public string getItemMovementReport(string BatchNo, string ModelNo, string SerialNo, string AssetNo, string ItemName, string AssetID)
    {
        ExcuteCMD cmd = new ExcuteCMD();
        DataTable dt = cmd.GetDataTable("CALL Get_AssetMovementReport(@AssetID);", CommandType.Text, new
        {
            AssetID = AssetID,
        });
        if (dt.Rows.Count > 0)
        {

            string ReportName = "Asset Movement Report(AssetName:"+ItemName+" / Asset No.: " + AssetNo +" )";
            string CacheName = HttpContext.Current.Session["ID"].ToString();
            Common.CreateCachedt(CacheName, dt);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, responseURL = "../../Design/commonReports/CommonReport.aspx?ReportName=" + ReportName + "&Type=E" });
        }
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "No Record Found" });    
    }
        
    
}