<%@ WebService Language="C#" Class="InfrastructureMaster" %>

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
[System.ComponentModel.ToolboxItem(false)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class InfrastructureMaster : System.Web.Services.WebService
{
    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }
    [WebMethod(EnableSession = true)]
    public string SaveBlocks(string BlockName, string IsActive, string BlockID, string CentreID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            string message = "";
            string str = "Select Count(*) From eq_BlockMaster where lower(BlockName)=@BlockName and CentreID=@CentreID ";
            if (BlockID != "")
                str += " and ID<>@BlockID";
            var isExists = Util.GetInt(excuteCMD.ExecuteScalar(str, new
                {
                    BlockName = BlockName.ToLower(),
                    CentreID = CentreID,
                    BlockID = BlockID,
                }));
            if (isExists > 0)
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Block Already Exists" });
            }
            if (BlockID != "")
            {
                var sqlCMD = "Update eq_BlockMaster set BlockName=@BlockName ,IsActive=@IsActive ,CentreID = @CentreID ,UpdatedBy=@UpdatedBy,UpdatedDateTime=NOW() where ID = @BlockID";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    BlockName = BlockName,
                    IsActive = IsActive,
                    CentreID = CentreID,
                    BlockID = BlockID,
                    UpdatedBy = HttpContext.Current.Session["ID"].ToString(),
                });
                message = "Record Updated Successfully";
            }
            else
            {
                var sqlCMD = "Insert into eq_BlockMaster(BlockName,IsActive,CentreID,CreatedBy) values(@BlockName,@IsActive,@CentreID,@CreatedBy)";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    BlockName = BlockName,
                    IsActive = IsActive,
                    CentreID = CentreID,
                    CreatedBy = HttpContext.Current.Session["ID"].ToString(),
                });
                message = "Record Save Successfully";
            }

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message });
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
    public string loadBlockDetails(string CentreID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT bm.ID AS BlockID ,cm.CentreID,bm.BlockName, cm.CentreName,IF(bm.IsActive=1,'Active','De-Active')ActiveStatus,bm.IsActive, ");
        sb.Append("CONCAT(em.Title,em.Name,' ',DATE_FORMAT(bm.CreatedDateTime,'%d-%b-%Y %I:%i %p'))CreatedDetail, ");
        sb.Append("IFNULL(CONCAT(em1.Title,em1.Name,' ',DATE_FORMAT(bm.UpdatedDateTime,'%d-%b-%Y %I:%i %p')),'')UpdatedDetail ");
        sb.Append("FROM eq_BlockMaster bm ");
        sb.Append("INNER JOIN center_master cm ON bm.CentreID=cm.CentreID ");
        sb.Append("INNER JOIN employee_master em ON em.EmployeeID=bm.CreatedBy ");
        sb.Append("LEFT JOIN employee_master em1 ON em1.EmployeeID=bm.UpdatedBy ");
        //    if (CentreID != "0")
        //         sb.Append(" bm.CentreID=" + CentreID + " ");
        sb.Append("ORDER BY cm.CentreID,bm.BlockName ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod(EnableSession = true)]
    public string SaveBuilding(string CentreID, string BlockID, string BuildingName, string IsActive, string BuildingID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            string message = "";
            string str = "Select Count(*) From eq_buildingmaster where lower(BuildingName)=@BuildingName and CentreID=@CentreID and BlockID=@BlockID";
            if (BuildingID != "")
                str += " and ID<>@BuildingID";
            var isExists = Util.GetInt(excuteCMD.ExecuteScalar(str, new
                {
                    BuildingName = BuildingName.ToLower(),
                    CentreID = CentreID,
                    BlockID = BlockID,
                    BuildingID = BuildingID,
                }));
            if (isExists > 0)
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Building Already Exists in this Block" });
            }
            if (BuildingID != "")
            {
                var sqlCMD = "Update eq_buildingmaster set BuildingName=@BuildingName ,IsActive=@IsActive ,CentreID = @CentreID ,BlockID=@BlockID, UpdatedBy=@UpdatedBy,UpdatedDateTime=NOW() where ID = @BuildingID";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    BuildingName = BuildingName,
                    IsActive = IsActive,
                    CentreID = CentreID,
                    BlockID = BlockID,
                    BuildingID = BuildingID,
                    UpdatedBy = HttpContext.Current.Session["ID"].ToString(),
                });
                message = "Record Updated Successfully";
            }
            else
            {
                var sqlCMD = "Insert into eq_buildingmaster(BuildingName,IsActive,CentreID,BlockID,CreatedBy) values(@BuildingName,@IsActive,@CentreID,@BlockID,@CreatedBy)";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    BuildingName = BuildingName,
                    IsActive = IsActive,
                    CentreID = CentreID,
                    BlockID = BlockID,
                    CreatedBy = HttpContext.Current.Session["ID"].ToString(),
                });
                message = "Record Save Successfully";
            }

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message });
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
    public string loadBuildingDetail(string CentreID, string BlockID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT bdm.ID AS BuildingID ,bdm.BlockID,cm.CentreID,bdm.BuildingName,bm.BlockName, cm.CentreName,IF(bdm.IsActive=1,'Active','De-Active')ActiveStatus,bdm.IsActive, ");
        sb.Append("CONCAT(em.Title,em.Name,' ',DATE_FORMAT(bdm.CreatedDateTime,'%d-%b-%Y %I:%i %p'))CreatedDetail, ");
        sb.Append("IFNULL(CONCAT(em1.Title,em1.Name,' ',DATE_FORMAT(bdm.UpdatedDateTime,'%d-%b-%Y %I:%i %p')),'')UpdatedDetail ");
        sb.Append("FROM eq_buildingmaster bdm  ");
        sb.Append("INNER JOIN eq_BlockMaster bm ON bm.ID= bdm.BlockID ");
        sb.Append("INNER JOIN center_master cm ON bdm.CentreID=cm.CentreID ");
        sb.Append("INNER JOIN employee_master em ON em.EmployeeID=bdm.CreatedBy ");
        sb.Append("LEFT JOIN employee_master em1 ON em1.EmployeeID=bdm.UpdatedBy ");
        if (BlockID != "0")
            sb.Append("WHERE bdm.BlockID=" + BlockID + " ");
        //    if (CentreID != "0")
        //         sb.Append(" and bm.CentreID=" + CentreID + " ");
        sb.Append(" ORDER BY cm.CentreID,bm.BlockName,bdm.BuildingName; ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod(EnableSession = true)]
    public string SaveFloorBuildingMapping(string CentreID, string BlockID, string BuildingID, string FloorID, string FloorName)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            string message = "";
            string str = "Select Count(*) From eq_FloorMapping where BuildingID=@BuildingID and FloorID=@FloorID and IsActive=1 ";

            var isExists = Util.GetInt(excuteCMD.ExecuteScalar(str, new
            {
                FloorID = FloorID,
                BuildingID = BuildingID,
            }));
            if (isExists > 0)
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Floor Already Mapped in this Building" });
            }

            var sqlCMD = "Insert into eq_FloorMapping(FloorID,FloorName,BlockID,BuildingID,CentreID,CreatedBy) values(@FloorID,@FloorName,@BlockID,@BuildingID,@CentreID,@CreatedBy)";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                FloorName = FloorName,
                CentreID = CentreID,
                BlockID = BlockID,
                BuildingID = BuildingID,
                FloorID = FloorID,
                CreatedBy = HttpContext.Current.Session["ID"].ToString(),
            });
            message = "Record Save Successfully";


            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message });
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


    [WebMethod(EnableSession = true)]
    public string UpdateFloorMapping(string MappingID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var sqlCMD = "Update eq_FloorMapping Set IsActive=0,UpdatedBy=@UpdatedBy,UpdatedDateTime=NOW() where ID=@ID";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                UpdatedBy = HttpContext.Current.Session["ID"].ToString(),
                ID = MappingID,
            });
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Mapping Removed Successfully" });
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
    public string loadFloorMappingDetail(string CentreID, string BlockID, string BuildingID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT fm.id AS MappingID,fm.FloorID, fm.BuildingID ,fm.BlockID,cm.CentreID,fm.FloorName,bdm.BuildingName,bm.BlockName, cm.CentreName, ");
        sb.Append("CONCAT(em.Title,em.Name,' ',DATE_FORMAT(fm.CreatedDateTime,'%d-%b-%Y %I:%i %p'))CreatedDetail ");
        sb.Append("FROM eq_FloorMapping fm  ");
        sb.Append("INNER JOIN eq_buildingmaster bdm ON fm.BuildingID=bdm.ID ");
        sb.Append("INNER JOIN eq_BlockMaster bm ON bm.ID= fm.BlockID ");
        sb.Append("INNER JOIN center_master cm ON fm.CentreID=cm.CentreID ");
        sb.Append("INNER JOIN employee_master em ON em.EmployeeID=fm.CreatedBy ");
        sb.Append("LEFT JOIN employee_master em1 ON em1.EmployeeID=fm.UpdatedBy ");
        sb.Append("where fm.IsActive=1");
        if (CentreID != "0")
            sb.Append(" and fm.CentreID =" + CentreID + " ");
        if (BlockID != "0")
            sb.Append(" and fm.BlockID =" + BlockID + " ");
        if (BuildingID != "0")
            sb.Append(" and  fm.BuildingID=" + BuildingID + " ");
        sb.Append("ORDER BY cm.CentreID,bm.BlockName,bdm.BuildingName,fm.FloorName; ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }


    [WebMethod(EnableSession = true)]
    public string SaveRoom(string CentreID, string BlockID, string BuildingID, string FloorID, string RoomName, string IsActive, string RoomID, string RoomTypeID, string DeptLedgerNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            string message = "";
            string str = "Select Count(*) From eq_roommaster where lower(RoomName)=@RoomName and CentreID=@CentreID and BlockID=@BlockID and BuildingID=@BuildingID and FloorID=@FloorID";
            if (BuildingID != "")
                str += " and ID<>@RoomID";
            var isExists = Util.GetInt(excuteCMD.ExecuteScalar(str, new
            {
                RoomName = RoomName.ToLower(),
                CentreID = CentreID,
                BlockID = BlockID,
                BuildingID = BuildingID,
                FloorID = FloorID,
                RoomID = RoomID
            }));
            if (isExists > 0)
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Room Already Exists" });
            }
            if (RoomID != "")
            {
                var sqlCMD = "Update eq_roommaster set RoomName=@RoomName ,IsActive=@IsActive ,CentreID = @CentreID ,BlockID=@BlockID,BuildingID=@BuildingID,FloorID=@FloorID,RoomTypeID=@RoomTypeID, UpdatedBy=@UpdatedBy,UpdatedDateTime=NOW(),DeptLedgerNo=@DeptLedgerNo where ID = @RoomID";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    RoomName = RoomName,
                    IsActive = IsActive,
                    CentreID = CentreID,
                    BlockID = BlockID,
                    BuildingID = BuildingID,
                    FloorID = FloorID,
                    UpdatedBy = HttpContext.Current.Session["ID"].ToString(),
                    RoomID = RoomID,
                    RoomTypeID = RoomTypeID,
                    DeptLedgerNo = DeptLedgerNo
                });
                message = "Record Updated Successfully";
            }
            else
            {
                var sqlCMD = "Insert into eq_roommaster(RoomName,IsActive,CentreID,BlockID,BuildingID,FloorID,CreatedBy,RoomTypeID,DeptLedgerNo) values(@RoomName,@IsActive,@CentreID,@BlockID,@BuildingID,@FloorID,@CreatedBy,@RoomTypeID,@DeptLedgerNo)";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    RoomName = RoomName,
                    IsActive = IsActive,
                    CentreID = CentreID,
                    BlockID = BlockID,
                    BuildingID = BuildingID,
                    FloorID = FloorID,
                    CreatedBy = HttpContext.Current.Session["ID"].ToString(),
                    RoomTypeID = RoomTypeID,
                    DeptLedgerNo = DeptLedgerNo
                });
                message = "Record Save Successfully";
            }

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message });
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
    public string loadRoomDetail(string CentreID, string BlockID, string BuildingID, string FloorID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT rm.id AS RoomID,rm.FloorID, rm.BuildingID ,rm.BlockID,cm.CentreID,rm.RoomName,fm.NAME AS FloorName,bdm.BuildingName,bm.BlockName, cm.CentreName,IF(rm.IsActive=1,'Active','De-Active')ActiveStatus,rm.IsActive, ");
        sb.Append("CONCAT(em.Title,em.Name,' ',DATE_FORMAT(rm.CreatedDateTime,'%d-%b-%Y %I:%i %p'))CreatedDetail, ");
        sb.Append("IFNULL(CONCAT(em1.Title,em1.Name,' ',DATE_FORMAT(rm.UpdatedDateTime,'%d-%b-%Y %I:%i %p')),'')UpdatedDetail ");
        sb.Append("FROM eq_roommaster rm   ");
        sb.Append("INNER JOIN floor_master fm ON fm.ID= rm.FloorID ");
        sb.Append("INNER JOIN eq_buildingmaster bdm ON rm.BuildingID=bdm.ID ");
        sb.Append("INNER JOIN eq_BlockMaster bm ON bm.ID= rm.BlockID ");
        sb.Append("INNER JOIN center_master cm ON rm.CentreID=cm.CentreID ");
        sb.Append("INNER JOIN employee_master em ON em.EmployeeID=rm.CreatedBy ");
        sb.Append("LEFT JOIN employee_master em1 ON em1.EmployeeID=rm.UpdatedBy ");
        sb.Append("WHERE  1=1 ");
        if (CentreID != "0")
            sb.Append(" and rm.CentreID =" + CentreID + " ");
        if (BlockID != "0")
            sb.Append(" and rm.BlockID =" + BlockID + " ");
        if (BuildingID != "0")
            sb.Append(" and  rm.BuildingID=" + BuildingID + " ");
        if (FloorID != "0")
            sb.Append(" and  rm.FloorID=" + FloorID + " ");
        sb.Append("ORDER BY cm.CentreID,bm.BlockName,bdm.BuildingName,fm.Name,rm.RoomName; ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod(EnableSession = true)]
    public string SaveCubical(string CentreID, string BlockID, string BuildingID, string FloorID, string RoomID, string CubicalName, string IsActive, string CubicalID, string RoomTypeID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            string message = "";
            string str = "Select Count(*) From eq_CubicalMaster where lower(CubicalName)=@CubicalName and CentreID=@CentreID and BlockID=@BlockID and BuildingID=@BuildingID and FloorID=@FloorID ";
            if (CubicalID != "")
                str += " and ID<>@CubicalID";
            var isExists = Util.GetInt(excuteCMD.ExecuteScalar(str, new
            {
                CubicalName = CubicalName.ToLower(),
                CentreID = CentreID,
                BlockID = BlockID,
                BuildingID = BuildingID,
                FloorID = FloorID,
                CubicalID = CubicalID,
                RoomTypeID = RoomTypeID
            }));
            if (isExists > 0)
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Cubical Already Exists on this Floor" });
            }
            if (CubicalID != "")
            {
                var sqlCMD = "Update eq_CubicalMaster set CubicalName=@CubicalName ,IsActive=@IsActive ,CentreID = @CentreID ,BlockID=@BlockID,BuildingID=@BuildingID,FloorID=@FloorID,RoomID=@RoomID, RoomTypeID=@RoomTypeID, UpdatedBy=@UpdatedBy,UpdatedDateTime=NOW() where ID = @CubicalID";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    CubicalName = CubicalName,
                    IsActive = IsActive,
                    CentreID = CentreID,
                    BlockID = BlockID,
                    BuildingID = BuildingID,
                    FloorID = FloorID,
                    RoomID = RoomID,
                    UpdatedBy = HttpContext.Current.Session["ID"].ToString(),
                    CubicalID = CubicalID,
                    RoomTypeID = RoomTypeID
                });
                message = "Record Updated Successfully";
            }
            else
            {
                var sqlCMD = "Insert into eq_CubicalMaster(CubicalName,IsActive,CentreID,BlockID,BuildingID,FloorID,RoomID,CreatedBy,RoomTypeID) values(@CubicalName,@IsActive,@CentreID,@BlockID,@BuildingID,@FloorID,@RoomID,@CreatedBy,@RoomTypeID)";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    CubicalName = CubicalName,
                    IsActive = IsActive,
                    CentreID = CentreID,
                    BlockID = BlockID,
                    BuildingID = BuildingID,
                    FloorID = FloorID,
                    RoomID = RoomID,
                    CreatedBy = HttpContext.Current.Session["ID"].ToString(),
                    RoomTypeID = RoomTypeID
                });
                message = "Record Save Successfully";
            }

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message });
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
    public string loadCubicalDetail(string CentreID, string BlockID, string BuildingID, string FloorID, string RoomID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT cbm.id AS CubicalID,cbm.RoomID,cbm.FloorID, cbm.BuildingID ,cbm.BlockID,cm.CentreID,cbm.CubicalName,rm.RoomName,fm.NAME AS FloorName,bdm.BuildingName,bm.BlockName, cm.CentreName, ");
        sb.Append("IF(cbm.IsActive=1,'Active','De-Active')ActiveStatus,cbm.IsActive, ");
        sb.Append("CONCAT(em.Title,em.Name,' ',DATE_FORMAT(cbm.CreatedDateTime,'%d-%b-%Y %I:%i %p'))CreatedDetail, ");
        sb.Append("IFNULL(CONCAT(em1.Title,em1.Name,' ',DATE_FORMAT(cbm.UpdatedDateTime,'%d-%b-%Y %I:%i %p')),'')UpdatedDetail ");
        sb.Append("FROM eq_CubicalMaster cbm  ");
        sb.Append("INNER JOIN eq_roommaster rm ON cbm.RoomID=rm.ID ");
        sb.Append("INNER JOIN floor_master fm ON fm.ID= cbm.FloorID ");
        sb.Append("INNER JOIN eq_buildingmaster bdm ON cbm.BuildingID=bdm.ID ");
        sb.Append("INNER JOIN eq_BlockMaster bm ON bm.ID= cbm.BlockID ");
        sb.Append("INNER JOIN center_master cm ON cbm.CentreID=cm.CentreID ");
        sb.Append("INNER JOIN employee_master em ON em.EmployeeID=cbm.CreatedBy ");
        sb.Append("LEFT JOIN employee_master em1 ON em1.EmployeeID=cbm.UpdatedBy ");
        sb.Append("WHERE  1=1 ");
        if (CentreID != "0")
            sb.Append(" and cbm.CentreID =" + CentreID + " ");
        if (BlockID != "0")
            sb.Append(" and cbm.BlockID =" + BlockID + " ");
        if (BuildingID != "0")
            sb.Append(" and  cbm.BuildingID=" + BuildingID + " ");
        if (FloorID != "0")
            sb.Append(" and  cbm.FloorID=" + FloorID + " ");
        if (RoomID != "0")
            sb.Append("and cbm.RoomID=" + RoomID + " ");
        sb.Append("ORDER BY cm.CentreID,bm.BlockName,bdm.BuildingName,fm.Name,rm.RoomName,cbm.CubicalName; ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    public string SaveRoomType(string RoomTypeName)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var sql = "Select Count(*) From eq_RoomTypeMaster where lower(RoomTypeName)=@RoomTypeName";
            var isExist = Util.GetInt(excuteCMD.ExecuteScalar(sql, new
            {
                RoomTypeName = RoomTypeName.ToLower()
            }));
            if (isExist > 0)
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "RoomType Already Exists" });
            }
            var sqlCMD = "Insert into eq_RoomTypeMaster (RoomTypeName) values(@RoomTypeName);select @@identity";
            var RoomTypeID = Util.GetInt(excuteCMD.ExecuteScalar(tnx, sqlCMD, CommandType.Text, new
            {
                RoomTypeName = RoomTypeName,
            }));
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "RoomType Add Successfully", RoomTypeID = RoomTypeID });
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
    public string bindRoomType()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("Select ID,RoomTypeName from eq_RoomTypeMaster where isActive=1"));
    }


    [WebMethod(EnableSession = true)]
    public string SaveLocation(string LocationName, string Description, string IsActive, string LocationID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            string message = "";
            string str = "Select Count(*) From eq_location_master where lower(LocationName)=@LocationName ";
            if (LocationID != "")
                str += " and ID<>@LocationID";
            var isExists = Util.GetInt(excuteCMD.ExecuteScalar(str, new
            {
                LocationName = LocationName.ToLower(),
                LocationID = LocationID,
            }));
            if (isExists > 0)
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Location Already Exists" });
            }
            if (LocationID != "")
            {
                var sqlCMD = "Update eq_location_master set LocationName=@LocationName ,Description=@Description,IsActive=@IsActive , UpdatedBy=@UpdatedBy,UpdatedDateTime=NOW() where ID = @LocationID";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    LocationName = LocationName,
                    Description = Description,
                    IsActive = IsActive,
                    UpdatedBy = HttpContext.Current.Session["ID"].ToString(),
                    LocationID = LocationID,
                });
                message = "Record Updated Successfully";
            }
            else
            {
                var sqlCMD = "Insert into eq_location_master(LocationName,Description,IsActive,CreatedBy) values(@LocationName,@Description,@IsActive,@CreatedBy)";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    LocationName = LocationName,
                    Description = Description,
                    IsActive = IsActive,
                    LocationID = LocationID,
                    CreatedBy = HttpContext.Current.Session["ID"].ToString(),
                });
                message = "Record Save Successfully";
            }

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message });
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
    public string loadLocationDetail()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT lm.ID AS LocationID,lm.LocationName,lm.Description,lm.IsActive, ");
        sb.Append("IF(lm.IsActive=1,'Active','De-Active')ActiveStatus , ");
        sb.Append("CONCAT(em.Title,em.Name,' ',DATE_FORMAT(lm.CreatedDateTime,'%d-%b-%Y %I:%i %p'))CreatedDetail, ");
        sb.Append("IFNULL(CONCAT(em1.Title,em1.Name,' ',DATE_FORMAT(lm.UpdatedDateTime,'%d-%b-%Y %I:%i %p')),'')UpdatedDetail ");
        sb.Append("FROM eq_location_master lm ");
        sb.Append("INNER JOIN employee_master em ON em.EmployeeID=lm.CreatedBy ");
        sb.Append("LEFT JOIN employee_master em1 ON em1.EmployeeID=lm.UpdatedBy ");
        sb.Append("ORDER BY lm.LocationName ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    public string bindCubical(string CentreID, string BlockID, string BuildingID, string FloorID, string RoomID, string RoomTypeID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT ID,CubicalName FROM eq_cubicalmaster c ");
        sb.Append("WHERE IsActive=1 ");
        if (CentreID != "0")
            sb.Append("AND c.CentreID=" + CentreID + " ");
        if (BlockID != "0")
            sb.Append("AND c.BlockID=" + BlockID + " ");
        if (BuildingID != "0")
            sb.Append("AND c.BuildingID=" + BuildingID + " ");
        if (FloorID != "0")
            sb.Append("AND c.FloorID=" + FloorID + " ");
        if (RoomID != "0")
            sb.Append("AND c.RoomID=" + RoomID + " ");
        if (RoomTypeID != "0")
            sb.Append("AND c.RoomTypeID=" + RoomTypeID + " ");
        sb.Append("ORDER BY CubicalName ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod]
    public string bindRoom(string CentreID, string BlockID, string BuildingID, string FloorID, string RoomTypeID, string DeptLedgerNo)
    {
        string str = "select ID,RoomName from eq_roommaster where IsACtive=1 ";
        if (FloorID!="0")
        str += "and FloorID=" + FloorID + " ";
        if (BuildingID != "0")
            str += " and BuildingID=" + BuildingID + "";
        if (DeptLedgerNo != "0")
            str += " and DeptLedgerNo='" + DeptLedgerNo + "' ";
        str += " Order By RoomName";
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(str));
    }
    [WebMethod]
    public string bindBlock(string CentreID)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT ID,BlockName FROM eq_BlockMaster WHERE isActive=1 and CentreID=" + CentreID + " ORDER BY ID"));
    }

    [WebMethod]
    public string bindFloor()
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID,NAME FROM floor_master ORDER BY SequenceNo");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public string bindBuilding(string CentreID, string BlockID)
    {
        string str = " SELECT ID,BuildingName FROM eq_buildingmaster WHERE isActive=1 ";
        if (BlockID != "0")
            str += " and BlockID=" + BlockID + " ";
        //  if(CentreID!="0")
        //      str += " and CentreID=" + CentreID + "";
        str += "ORDER BY BuildingName ";
        DataTable dt = StockReports.GetDataTable(str);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public string bindFloorMappedWithBuilding(string BuildingID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT fm.FloorID,fm.FloorName ");
        sb.Append("FROM eq_FloorMapping fm  ");
        sb.Append("INNER JOIN eq_buildingmaster bdm ON fm.BuildingID=bdm.ID ");
        sb.Append("where fm.IsActive=1 and fm.BuildingID=" + BuildingID + "");
        sb.Append(" ORDER BY fm.FloorName; ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    public string bindMappedLocation(string RoomID, string CubicalID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT lm.ID AS LocationID,lm.LocationName, lm.Description,IF(IFNULL(lmp.LocationID,0)=0,'0','1')IsMapped  ");
        sb.Append("FROM eq_location_master lm ");
        sb.Append("LEFT JOIN eq_LocationMapWithRoom lmp ON lmp.LocationID = lm.ID AND lmp.IsActive=1 AND lmp.RoomID=" + RoomID + " AND lmp.CubicalID=" + CubicalID + " ");
        sb.Append("WHERE lm.IsActive=1 ");
        sb.Append("ORDER BY lm.LocationName ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod]
    public string bindMappedLocationMaster(string RoomID, string CubicalID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT lm.ID AS LocationID,lm.LocationName, lm.Description,IF(IFNULL(lmp.LocationID,0)=0,'0','1')IsMapped  ");
        sb.Append("FROM eq_location_master lm ");
        sb.Append("inner JOIN eq_LocationMapWithRoom lmp ON lmp.LocationID = lm.ID AND lmp.IsActive=1 AND lmp.RoomID=" + RoomID + " AND lmp.CubicalID=" + CubicalID + " ");
        sb.Append("WHERE lm.IsActive=1 ");
        sb.Append("ORDER BY lm.LocationName ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod(EnableSession = true)]
    public string SaveLocationMapping(List<locationdetails> locationDetails, string RoomID, string CubicalID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var sql = "Select Count(*) from eq_locationmapwithroom where IsActive=1 and RoomID=" + RoomID;
            if (CubicalID != "0")
                sql += " and CubicalID =" + CubicalID;
            var isExist = Util.GetInt(StockReports.ExecuteScalar(sql));
            if (isExist > 0) 
            {
                var sqll = "UPdate eq_locationmapwithroom set IsActive=0,UpdatedBy=@UpdatedBy, UpdatedDateTime=NOW() where RoomID=@RoomID";
                if (CubicalID != "0")
                    sqll += " and CubicalID=@CubicalID";
                excuteCMD.DML(tnx, sqll, CommandType.Text, new
                {
                    RoomID = RoomID,
                    CubicalID = CubicalID,
                    UpdatedBy = HttpContext.Current.Session["ID"].ToString(),
                });
            }
            locationDetails.ForEach(i =>
            {
                var sqlCMD = "INSERT INTO eq_locationmapwithroom (RoomID,CubicalID,LocationID,CreatedBy)VALUES(@RoomID,@CubicalID,@LocationID,@CreatedBy);";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                    {
                        RoomID = RoomID,
                        CubicalID = CubicalID,
                        LocationID = i.locationID,
                        CreatedBy = HttpContext.Current.Session["ID"].ToString(),
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
    public class locationdetails
    {
        public string locationID { get; set; }
    }

    [WebMethod(EnableSession = true)]
    public string Get_OrganigationChart()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT CentreID AS Id,CentreName AS Name FROM center_master  WHERE IsActive=1;");
        DataTable dtcentre = StockReports.GetDataTable(sb.ToString());
        sb.Clear();
        sb.Append("SELECT ID AS Id,BlockName AS Name,CentreID FROM eq_blockmaster  WHERE IsActive=1; ");
        DataTable dtBlock = StockReports.GetDataTable(sb.ToString());

        sb.Clear();
        sb.Append("SELECT ID AS Id,BuildingName AS Name,BlockID,CentreID FROM eq_buildingmaster  WHERE IsActive=1;");
        DataTable dtBuilding = StockReports.GetDataTable(sb.ToString());

        sb.Clear();
        sb.Append("SELECT FloorID AS Id,FloorName AS Name,BuildingID FROM eq_floormapping  WHERE IsActive=1;");
        DataTable dtFloor = StockReports.GetDataTable(sb.ToString());

        sb.Clear();
        sb.Append("SELECT ID AS Id,RoomName AS Name,FloorID,BuildingID FROM eq_roommaster  WHERE IsActive=1;");
        DataTable dtRoom = StockReports.GetDataTable(sb.ToString());


        sb.Clear();
        sb.Append("SELECT ID AS Id,CubicalName AS Name,RoomId FROM eq_cubicalmaster  WHERE IsActive=1;");
        DataTable dtCubic = StockReports.GetDataTable(sb.ToString());

        //return Newtonsoft.Json.JsonConvert.SerializeObject(new { dtbatch = dtbatch, dtAsset = dtAsset, dtAccessories = dtAccessories });
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { dtcentre = dtcentre, dtBlock = dtBlock, dtBuilding = dtBuilding, dtFloor = dtFloor, dtRoom = dtRoom, dtCubic = dtCubic });
    }

    [WebMethod(EnableSession = true)]
    public string GetRoomCubicalDetailsById(string Id, string flag, string Buildingid)
    {
        StringBuilder sb = new StringBuilder();
        if (flag == "0" || flag == "1")
        {
            sb.Append("SELECT AssetName,AssetNo,lm.LocationName,cm.`CubicalName` ");
            if (flag == "0")
                sb.Append(" ,rm.`RoomName`   ");
            sb.Append("FROM eq_asset_location al   ");
            sb.Append("INNER JOIN eq_location_master lm ON al.LocationID=lm.ID   ");

            sb.Append(" INNER JOIN eq_roommaster rm ON rm.id=al.RoomID    ");

            sb.Append("INNER JOIN eq_cubicalmaster cm ON cm.`ID`=al.`CubicalID`   ");

            if (flag == "0")
                sb.Append("WHERE al.IsActive=1 and al.RoomId='" + Id + "'");
            else if (flag == "1")
                sb.Append("WHERE al.IsActive=1 and al.CubicalId='" + Id + "'");
        }
        else
        {
            sb.Append("SELECT * FROM ( ");
            sb.Append("SELECT al.`AssetID`,al.`AssetName`,al.`AssetNo`,al.`RoomID`,al.`CubicalID`,lm.LocationName FROM eq_asset_location al ");
            sb.Append("INNER JOIN eq_location_master lm ON lm.`ID`=al.`LocationID` WHERE al.`IsActive`=1)t   ");
            sb.Append("INNER JOIN `eq_roommaster` rm ON rm.id=t.roomID AND rm.`FloorID`='" + Id + "' AND rm.`BuildingID`='" + Buildingid + "'   ");
            sb.Append("LEFT JOIN `eq_cubicalmaster` cm ON t.cubicalID= cm.`ID` AND cm.`FloorID`='" + Id + "' AND cm.`BuildingID`='" + Buildingid + "'   ");
            //sb.Append("INNER JOIN eq_cubicalmaster cm ON cm.`BuildingID`=fm.`BuildingID`    ");
            //sb.Append("INNER JOIN eq_asset_location al ON al.`RoomID`=rm.`ID` ");
            //sb.Append("INNER JOIN eq_location_master lm ON lm.`ID`=al.`LocationID` ");
            //sb.Append("WHERE al.IsActive=1 and fm.FloorID='" + Id + "' and  fm.BuildingID='" + Buildingid + "' ");
            //sb.Append("GROUP BY rm.`ID` ");

        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);


    }
    
}