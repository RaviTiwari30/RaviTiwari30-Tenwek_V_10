using System;
using System.Data;
using System.Web;
using System.Web.Services;
using System.Text;

public partial class Design_EDP_SampleCollectionRoomMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod(EnableSession=true)]
    public static string saveRoom(string roomName, string RoleID, string CentreID)
    {
        try
        {
            int isExist = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM sampleCollectionRoomMaster  WHERE roomName='" + roomName.Trim() + "' "));
            if(isExist>0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Room Name Already Exist." });

            string sqlCommand = " INSERT INTO sampleCollectionRoomMaster(roomName,createdBy,ipAddress,RoleID,CentreID)VALUE(@roomName,@createdBy,@ipAddress,@RoleID,@CentreID) ";
            ExcuteCMD cmd = new ExcuteCMD();
            cmd.DML(sqlCommand, CommandType.Text, new
            {
                roomName = roomName,
                createdBy = HttpContext.Current.Session["ID"].ToString(),
                ipAddress = All_LoadData.IpAddress(),
                RoleID = RoleID,
                CentreID = CentreID,
            });
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully" });
        }

        catch (Exception ex) {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new {status=false,response="Error Occured Please Contact Adminitrator" });
        
        }
    }
    [WebMethod]
    public static string getRoomList(string CentreID)
    {
        DataTable dt = StockReports.GetDataTable(" SELECT id,roomName FROM sampleCollectionRoomMaster WHERE isActive=1 and CentreID=" + CentreID + " ORDER BY roomName  ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    
    }

    [WebMethod]
    public static string bindRole()
    {
        DataTable dt = StockReports.GetDataTable(" SELECT ID,RoleName FROM  f_rolemaster WHERE isInvestigation=1 order by RoleName  ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public static string getGroupNameList(string CentreID)
    {
        DataTable dt = StockReports.GetDataTable(" SELECT CONCAT(imt.GroupName,'(Prefix : ',imd.`Sequence`,') ',IFNULL(mm.name,''))'GroupName',imd.`GroupID` FROM Id_Master_token imt INNER JOIN token_master_detail imd ON imd.GroupID=imt.GroupId AND imt.IsActive=1 LEFT JOIN modality_master mm ON mm.id=imd.modalityid WHERE imt.CentreID=" + CentreID + " ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }
    [WebMethod(EnableSession = true)]
    public static string saveMapping(string roomId, string groupId,string CentreID)
    {
        try
        {
            ExcuteCMD cmd = new ExcuteCMD();
            int isExist = Util.GetInt(cmd.ExecuteScalar(" SELECT COUNT(*) FROM sampleRoomGroupNameMapping WHERE roomId=@roomId AND groupId=@groupId and CentreID=@CentreID ", new
            {
                roomId = Util.GetInt(roomId),
                groupId = Util.GetInt(groupId),
                CentreID = CentreID,
            }));

            if (isExist > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Mapping Already Exists." });

            string sqlCommand = "INSERT INTO sampleRoomGroupNameMapping(roomId,groupId,createdBy,ipAddress,CentreID)VALUES(@roomId,@groupId,@createdBy,@ipAddress,@CentreID)";
            
            cmd.DML(sqlCommand, CommandType.Text, new {
                roomId=Util.GetInt(roomId),
                groupId=Util.GetInt(groupId),
                createdBy=HttpContext.Current.Session["ID"].ToString(),
                ipAddress=All_LoadData.IpAddress(),
                CentreID = CentreID,
            });
        return Newtonsoft.Json.JsonConvert.SerializeObject(new {status=true,response="Room Mapped Successfully." });       
        }
        catch (Exception ex) {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new {status=false,response="Error Occured Please Contact Administrator" });       
        
        }
        
    }
    [WebMethod]
    public static string loadMapping(string CentreID) 
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT cm.CentreName,srm.CentreID, srm.`roomName` 'roomName',sgm.`roomId` 'roomId',CONCAT(imt.GroupName,'(Prefix : ',imd.`Sequence`,') ',IFNULL(mm.name,''))groupName,imt.`GroupID` 'groupId',rolename ");
        sb.Append(" FROM sampleRoomGroupNameMapping sgm INNER JOIN Id_Master_token imt ON imt.`GroupID`=sgm.`groupId` ");
        sb.Append(" INNER JOIN token_master_detail imd ON imd.GroupID=imt.GroupId INNER JOIN sampleCollectionRoomMaster srm  ON srm.`id`=sgm.`roomId` INNER JOIN f_rolemaster rm  ON rm.id=srm.roleid ");
        sb.Append(" INNER JOIN Center_Master cm ON cm.CentreID= srm.CentreID ");
        sb.Append(" LEFT JOIN modality_master mm ON mm.id=imd.modalityid ");
        sb.Append(" where srm.CentreID="+CentreID+"");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    
    
    }
    [WebMethod]
    public static string removeMapping(string roomId, string groupId, string CentreID)
    {
        try
        {
            ExcuteCMD cmd = new ExcuteCMD();
            string sqlCommand = "DELETE FROM sampleRoomGroupNameMapping WHERE roomId=@roomId AND groupId=@groupId and CentreID=@CentreID";
            cmd.DML(sqlCommand, CommandType.Text, new {
                roomId = roomId,
                groupId = groupId,
                CentreID=CentreID
            });
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Mapping Removed Successfully." });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error Occured Please Contact Adminitrator" });
        }

    }
}