using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
public partial class Design_OT_EquipmentStockMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
        }
    }

    [WebMethod]
    public static string BindEquipment()
    {
        string sql = "SELECT e.`ID`,e.`EquipmentName` FROM `ot_equipment_master` e WHERE e.`IsActive`=1 ORDER BY e.`EquipmentName` ";
        DataTable dt = StockReports.GetDataTable(sql);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string bindEquipmentStock()
    {
        StringBuilder sqlCmd = new StringBuilder(" SELECT s.`EquipmentStockID`,s.`EquipmentName`,s.`StockQuantity`,s.`ActiveQuantity`,DATE_FORMAT(s.`EntryDate`,'%d-%b-%y') AS StockDate,s.`LogReason`,em.`Name` AS EntryBy FROM `ot_equipment_stock` s INNER JOIN employee_master em ON em.`EmployeeID`=s.`EntryBy` WHERE s.`ActiveQuantity`>0 AND s.CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " ");

        DataTable dt = StockReports.GetDataTable(sqlCmd.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string SaveEquipment(int type, string equipmentId, string equipmentName)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string sqlQuery = string.Empty;

            ExcuteCMD excuteCMD = new ExcuteCMD();
            int IsExist = 0;
            if (type == 1)
                IsExist = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) FROM ot_equipment_master s WHERE s.`EquipmentName`='" + equipmentName + "' AND s.`IsActive`=1 "));

            if (IsExist > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Equipment Name already Exist." });
            }

            if (type == 1)
            {
                sqlQuery = "INSERT INTO ot_equipment_master(EquipmentName,EntryBy,EntryDate) VALUES(@EquipmentName,@EntryBy,now())";
                excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
                {
                    EquipmentName = equipmentName,
                    EntryBy = HttpContext.Current.Session["ID"].ToString()
                });
            }
            if (type == 2)
            {
                sqlQuery = "UPDATE ot_equipment_master SET IsActive=0,UpdatedBy=@UpdatedBy,UpdatedDate=now() WHERE ID=@EqupmentId";
                excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
                {
                    EqupmentId = equipmentId,
                    UpdatedBy = HttpContext.Current.Session["ID"].ToString()
                });
            }
            tnx.Commit();
            if (type == 1)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Equipment Created Successfully" });
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Equipment De-Activated Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }



    [WebMethod(EnableSession = true)]
    public static string saveStock(int equipmentId, string equipmentName, int stockQty)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string sqlQuery = string.Empty;

            ExcuteCMD excuteCMD = new ExcuteCMD();
            sqlQuery = "INSERT INTO ot_equipment_stock(EquipmentID,EquipmentName,StockQuantity,ActiveQuantity,EntryBy,EntryDate,CentreID) VALUES(@EquipmentID,@EquipmentName,@StockQuantity,@ActiveQuantity,@EntryBy,now(),@CentreID)";
            excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
            {
                EquipmentID = equipmentId,
                EquipmentName = equipmentName,
                StockQuantity = stockQty,
                ActiveQuantity = stockQty,
                EntryBy = HttpContext.Current.Session["ID"].ToString(),
                CentreID = HttpContext.Current.Session["CentreID"].ToString()
            });
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }


    

    [WebMethod(EnableSession = true)]
    public static string updateActiveQty(int equipmentStockID, int activeQty, string reason)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string sqlQuery = string.Empty;

            ExcuteCMD excuteCMD = new ExcuteCMD();
            sqlQuery = "UPDATE ot_equipment_stock s SET s.`ActiveQuantity`=@ActiveQuantity,s.`LastUpdatedBy`=@LastUpdatedBy,s.`LastUpdatedDate`=NOW(),LogReason=concat(IFNULL(LogReason,''),'</br> Updated Date : ',date_format(now(),'%d-%b-%Y %I:%i:%p'),', Updated By : ',@UserName,', Active Quantity : ',@ActiveQuantity,', Reason : ',@LogReason) WHERE s.`EquipmentStockID`=@EquipmentStockID";
            excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
            {
                ActiveQuantity = activeQty,
                LastUpdatedBy = HttpContext.Current.Session["ID"].ToString(),
                LogReason= reason,
                UserName = HttpContext.Current.Session["LoginName"].ToString(),
                EquipmentStockID = equipmentStockID
            });
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Updated Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}