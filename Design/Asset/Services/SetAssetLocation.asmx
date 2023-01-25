<%@ WebService Language="C#" Class="SetAssetLocation" %>

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
[WebServiceBinding(ConformsTo = WsiProfiles.None)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class SetAssetLocation : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }

    [WebMethod(EnableSession = true)]
    public string SaveAssetLocation(List<locationDetails> Setlocation)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            Setlocation.ForEach(i =>
            {
                if (!string.IsNullOrEmpty(i.SetID))
                {
                    var sql = "Update eq_asset_location set IsActive=0,UpdatedBy=@UpdatedBy,UpdatedDateTime=NOW() where ID=@setID";
                    excuteCMD.DML(tnx, sql, CommandType.Text, new
                    {
                        UpdatedBy = HttpContext.Current.Session["ID"].ToString(),
                        setID = i.SetID,
                    });
                }
                var sqlCMD = "INSERT INTO eq_asset_location (AssetID,AssetName,AssetNo,ItemId,StockId,LocationID,RoomID,CreatedBy,DeptLedgerNo,CubicalID) VALUES(@AssetID, @AssetName, @AssetNo, @ItemId, @StockId, @LocationID, @RoomID, @CreatedBy, @DeptLedgerNo, @CubicalID);";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                    {
                        AssetID = i.AssetID,
                        AssetName = i.ItemName,
                        AssetNo = i.AssetNo,
                        ItemId = i.ItemID,
                        StockId = i.StockID,
                        LocationID = i.LocationID,
                        RoomID = i.RoomID,
                        CreatedBy = HttpContext.Current.Session["ID"].ToString(),
                        DeptLedgerNo = i.DeptLedgerNo,
                        CubicalID = i.CubicalID,
                    });
            });
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Save Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    public class locationDetails
    {
        public string AssetID { get; set; }
        public string ItemName { get; set; }
        public string BatchNo { get; set; }
        public string ModelNo { get; set; }
        public string SerialNo { get; set; }
        public string AssetNo { get; set; }
        public string StockID { get; set; }
        public string ItemID { get; set; }
        public string f_StockID { get; set; }
        public string DeptLedgerNo { get; set; }
        public string RoomID { get; set; }
        public string CubicalID { get; set; }
        public string LocationID { get; set; }
        public string SetID { get; set; }
    }

    [WebMethod]
    public string SearchSetLocationDetails(string deptledgerNo, string roomID, string cubicalID, string locationID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT AssetName,am.BatchNumber,am.ModelNo,am.SerialNo,am.AssetNo,rm.RoomName,ifnull(cm.CubicalName,'')CubicalName,lm.LocationName,em.Name AS createdby, ");
        sb.Append("DATE_FORMAT(al.CreatedDateTime,'%d-%b-%Y')CreatedDate,al.ID AS SetID,al.StockID,al.LocationID,al.RoomID,al.CubicalID,am.ItemID,al.AssetID,if(ifnull(am.InstallationDate,'')='','0','1')isInstallationDone,Date_Format(InstallationDate,'%d-%b-%Y')InstallationDate,InstallationBy,InstallationRemarks ");
        sb.Append("FROM eq_asset_location al  ");
        sb.Append("INNER JOIN eq_roommaster rm ON rm.ID = al.RoomID ");
        sb.Append("LEFT JOIN eq_cubicalmaster cm ON cm.ID= al.CubicalID ");
        sb.Append("INNER JOIN eq_location_master lm ON lm.ID= al.LocationID ");
        sb.Append("INNER JOIN eq_asset_master am ON am.ID= al.AssetID ");
        sb.Append("INNER JOIN employee_master em ON em.EmployeeID= al.CreatedBy ");
        sb.Append("WHERE al.IsActive=1 ");
        if (deptledgerNo != "0")
            sb.Append("AND al.DeptLedgerNo='" + deptledgerNo + "' ");
        if (roomID != "0")
            sb.Append("AND al.RoomID='" + roomID + "' ");
        if (cubicalID != "0")
            sb.Append("AND al.CubicalID='" + cubicalID + "' ");
        if (locationID != "0")
            sb.Append("AND al.LocationID='" + locationID + "' ");
        sb.Append(" Order by al.AssetName,al.ID ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod(EnableSession = true)]
    public string DeleteAssetLocation(string setID, string Remarks)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var sqlCMD = "Update eq_asset_location set IsActive=0,UpdatedBy=@UpdatedBy,UpdatedDateTime=NOW(),DeActiveRemarks=@DeActiveRemarks where ID=@setID";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                UpdatedBy = HttpContext.Current.Session["ID"].ToString(),
                setID = setID,
                DeActiveRemarks=Remarks,
            });
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Updated Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public string ValidateDuplicateAssetLocation(string AssetID)
    {
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT rm.RoomName,ifnull(cm.CubicalName,'')CubicalName,lm.LocationName,al.ID as SetID FROM eq_asset_location al ");
            sb.Append("INNER JOIN eq_roommaster rm ON rm.ID = al.RoomID ");
            sb.Append("LEFT JOIN eq_cubicalmaster cm ON cm.ID= al.CubicalID ");
            sb.Append("INNER JOIN eq_location_master lm ON lm.ID= al.LocationID ");
            sb.Append(" WHERE AssetID=@AssetID AND al.IsActive=1 ");

            var dt = excuteCMD.GetDataTable(sb.ToString(), CommandType.Text, new
            {
                AssetID = AssetID,
            });
            if (dt.Rows.Count > 0)
            {
                //if(dt.Rows[0]["RoomName"].ToString())
                var response = "";
                if (dt.Rows[0]["CubicalName"].ToString() != "")
                    response = "Room Name : " + dt.Rows[0]["RoomName"].ToString() + ", Cubical : " + dt.Rows[0]["CubicalName"].ToString() + ", Location : " + dt.Rows[0]["LocationName"].ToString();
                else
                    response = "Room Name : " + dt.Rows[0]["RoomName"].ToString() + ", Location : " + dt.Rows[0]["LocationName"].ToString();

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, SetID = dt.Rows[0]["SetID"].ToString(), response = response });
            }
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, SetID = "" });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
    }

    [WebMethod(EnableSession = true)]
    public string UpdateAssetLocation(string roomID, string cubicalID, string locationID, string setID, string DeptLedgerNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            if (string.IsNullOrEmpty(setID))
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator" });
            }
            var sql = "Update eq_asset_location set IsActive=0,UpdatedBy=@UpdatedBy,UpdatedDateTime=NOW() where ID=@setID";
            excuteCMD.DML(tnx, sql, CommandType.Text, new
            {
                UpdatedBy = HttpContext.Current.Session["ID"].ToString(),
                setID = setID,
            });

            DataTable dt = excuteCMD.GetDataTable("Select * from eq_asset_location where ID=@setID", CommandType.Text, new
            {
                setID = setID,
            });

            var sqlCMD = "INSERT INTO eq_asset_location (AssetID,AssetName,AssetNo,ItemId,StockId,LocationID,RoomID,CreatedBy,DeptLedgerNo,CubicalID) VALUES(@AssetID, @AssetName, @AssetNo, @ItemId, @StockId, @LocationID, @RoomID, @CreatedBy, @DeptLedgerNo, @CubicalID);";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                AssetID = dt.Rows[0]["AssetID"].ToString(),
                AssetName = dt.Rows[0]["AssetName"].ToString(),
                AssetNo = dt.Rows[0]["AssetNo"].ToString(),
                ItemId = dt.Rows[0]["ItemId"].ToString(),
                StockId = dt.Rows[0]["StockId"].ToString(),
                LocationID = locationID,
                RoomID = roomID,
                CreatedBy = HttpContext.Current.Session["ID"].ToString(),
                DeptLedgerNo = DeptLedgerNo,
                CubicalID = cubicalID,
            });

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Updated Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}