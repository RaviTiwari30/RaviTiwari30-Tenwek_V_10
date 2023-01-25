<%@ WebService Language="C#" Class="PagePrivilage" %>
using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Text;
using System.Data;
using System.Linq;
using System.Collections.Generic;
using MySql.Data.MySqlClient;
using System.Web.Script.Serialization;
using System.IO;

/// <summary>
/// Summary description for PagePrivilage
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
 [System.Web.Script.Services.ScriptService]
public class PagePrivilage : System.Web.Services.WebService
{
    [WebMethod(EnableSession = true)]
    public string SaveMenuMaster(string MenuID, string MenuName, string MenuUpload)
    {
        MySqlConnection objCon = Util.GetMySqlCon();
        objCon.Open();
        MySqlTransaction objTrans = objCon.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        string str = "";
        string msg = "";
        try
        {
            if (MenuID == string.Empty)
            {
                str = "insert into  f_menumaster(MenuName,image,LastUpdatedBy,UpdateDate,IPAddress) values('" + MenuName + "','" + string.Format(MenuUpload) + "','" + Util.GetString(System.Web.HttpContext.Current.Session["ID"].ToString()) + "',NOW(),'" + All_LoadData.IpAddress() + "')";
                msg = "Menu Created Successfully.";
            }
            else if (MenuID != string.Empty)
            {
                str = "UPDATE f_menumaster SET MenuName = '" + MenuName + "' ";
                if (MenuUpload != string.Empty)
                {
                    str += " ,image='" + string.Format(MenuUpload) + "' ";
                }
                str += ",LastUpdatedBy='" + Util.GetString(System.Web.HttpContext.Current.Session["ID"].ToString()) + "',UpdateDate=NOW(),IPAddress='" + All_LoadData.IpAddress() + "' ";
                str += "WHERE ID='" + MenuID + "' ";
                msg = "Menu Updated Successfully.";
            }
            int i = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, str);
            objTrans.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = msg });
        }
        catch (Exception ex)
        {
            objTrans.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            objTrans.Dispose();
            objCon.Close();
            objCon.Dispose();
        }
    }
    [WebMethod]
    public string BindMenuDropDown()
    {
        try
        {
            DataTable dt = All_LoadData.LoadHISMenu();
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {

        }
    }
    [WebMethod]
    public string BindMenuDetail(string MenuID)
    {
        try
        {
            StringBuilder sqlCMD = new StringBuilder();
            sqlCMD.Append(" SELECT m.ID,m.MenuName,(CASE WHEN m.Active=1 THEN 'Active' ELSE 'Deactive' END)STATUS,m.image,IFNULL(DATE_FORMAT(m.Updatedate,'%d-%b-%Y'),'')EntryDate, ");
            sqlCMD.Append(" IFNULL((SELECT CONCAT(em.Title,'',em.Name) FROM employee_master em WHERE  em.EmployeeID=m.LastUpdatedBy LIMIT 1),'') EntryBy FROM f_menumaster m WHERE m.ID=@MenuID ");
            sqlCMD.Append(" ORDER BY m.MenuName ");

            ExcuteCMD excuteCMD = new ExcuteCMD();
            var dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
            {
                MenuID = MenuID
            });

            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {

        }
    }
    [WebMethod(EnableSession = true)]
    public string SavFileMenuMaster(string FileID, string MenuID, string FrameID, string FrameName, string FileName, string URL, string FDesc, int Active)
    {
        MySqlConnection objCon = Util.GetMySqlCon();
        objCon.Open();
        MySqlTransaction objTrans = objCon.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        string str = "";
        string msg = "";
        try
        {
            if (MenuID != "" && FrameID == "")
            {
                if (FileID == string.Empty)
                {
                    str = "insert into f_filemaster(URLName,DispName,MenuID,Description,Active) values('" + URL + "','" + FileName + "'," + MenuID + ",'" + FDesc + "'," + Active + ")";
                    msg = "File Added Successfully.";
                }
                else if (FileID != string.Empty)
                {
                    str = "update f_filemaster set URLName='" + URL + "',Description='" + FDesc + "',MenuID=" + MenuID + ",Active=" + Active + " where ID=" + FileID + "";
                    msg = "File Updated Successfully.";
                }
                int i = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, str);
                objTrans.Commit();
            }
            if (FrameID != "" && MenuID == "")
            {
                int Count = Util.GetInt(StockReports.ExecuteScalar("Select Count(*) from f_framemenumaster where FileName='" + FileName + "' and FrameID=" + FrameID + " AND URL='" + URL + "' And IsActive=" + Active + " "));
                if (Count == 0)
                {
                    if (FileID == string.Empty)
                    {
                        str = "insert into f_framemenumaster(URL,FileName,FrameID,FrameName,Description,IsActive,CreatedBy) values('" + URL + "','" + FileName + "','" + FrameID + "','" + FrameName + "','" + FDesc + "'," + Active + ",'" + Util.GetString(System.Web.HttpContext.Current.Session["ID"].ToString()) + "')";
                        msg = "File Added Successfully.";
                    }
                    else if (FileID != string.Empty)
                    {
                        str = "update f_framemenumaster set URL='" + URL + "',Description='" + FDesc + "',FrameName='" + FrameName + "',FrameID=" + FrameID + ",IsActive=" + Active + " where ID=" + FileID + "";
                        msg = "File Updated Successfully.";
                    }
                    int i = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, str);
                    objTrans.Commit();
                }
                else
                {
                    msg = "File Already Exit.";
                }

            }

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = msg });
        }
        catch (Exception ex)
        {
            objTrans.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            objTrans.Dispose();
            objCon.Close();
            objCon.Dispose();
        }
    }
    [WebMethod]
    public string BindFileDetail(string ID, string FileName, int type)
    {
        try
        {
            StringBuilder sqlCMD = new StringBuilder();
            if (type == 1)
            {
                sqlCMD.Append(" select FM.ID,MM.frameid MenuOrFrameID,FM.FileName DispName,FM.Description,MM.FrameName Name,FM.URl URLName,(CASE WHEN FM.IsActive=1 THEN 'Active' ELSE 'Deactive' END)STATUS from f_framemenumaster  FM ");
                sqlCMD.Append(" left join f_framemaster MM on FM.frameid=MM.frameid where FM.ID>0 ");
                if (ID != "0")
                    sqlCMD.Append(" and MM.frameid =@ID ");
                if (FileName != "")
                    sqlCMD.Append(" and FM.FileName like '%" + FileName + "%' ");
                sqlCMD.Append(" ORDER BY FM.FileName ");

            }
            else if (type == 2)
            {
                sqlCMD.Append(" SELECT cmm.ID,cmm.RoleID MenuOrFrameID,cmm.MenuName NAME,cmm.Description,rm.RoleName DispName ,cmm.URL URLName,(CASE WHEN cmm.IsActive=1 THEN 'Active' ELSE 'Deactive' END)STATUS FROM cpoe_menumaster cmm ");
                sqlCMD.Append(" INNER JOIN f_rolemaster rm ON cmm.RoleID = rm.ID WHERE cmm.ID>0 ");
                sqlCMD.Append(" and cmm.RoleID =@ID ");
                if (FileName != "")
                    sqlCMD.Append(" and cmm.MenuName like '%" + FileName + "%' ");
                sqlCMD.Append(" ORDER BY cmm.MenuName ");

            }
            else
            {
                sqlCMD.Append(" select FM.ID,MM.ID MenuOrFrameID,FM.DispName,FM.Description,MM.MenuName Name,FM.URLName,(CASE WHEN FM.Active=1 THEN 'Active' ELSE 'Deactive' END)STATUS from f_filemaster  FM ");
                sqlCMD.Append(" left join f_menumaster MM on FM.MenuID=MM.ID where FM.ID>0 ");
                if (ID != "0")
                    sqlCMD.Append(" and FM.menuid =@ID ");
                if (FileName != "")
                    sqlCMD.Append(" and FM.DispName like '%" + FileName + "%' ");
                sqlCMD.Append(" ORDER BY FM.DispName ");
            }
            ExcuteCMD excuteCMD = new ExcuteCMD();
            var dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
            {
                ID = ID,
                FileName = FileName
            });

            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {

        }
    }
    [WebMethod]
    public string BindFrameDropDown()
    {
        try
        {
            DataTable dt = StockReports.GetDataTable("Select FrameID,FrameName From f_framemaster  Order by FrameName");
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {

        }
    }
    [WebMethod]
    public string BindFrameDetail(string FrameID)
    {
        try
        {
            StringBuilder sqlCMD = new StringBuilder();
            sqlCMD.Append(" SELECT m.FrameID,m.FrameName,(CASE WHEN m.IsActive=1 THEN 'Active' ELSE 'Deactive' END)STATUS,IFNULL(DATE_FORMAT(m.CreatedDate,'%d-%b-%Y'),'')EntryDate, ");
            sqlCMD.Append(" IFNULL((SELECT CONCAT(em.Title,'',em.Name) FROM employee_master em WHERE  em.EmployeeID=m.CreatedBy LIMIT 1),'') EntryBy FROM f_framemaster m WHERE m.FrameID=@FrameID ");
            sqlCMD.Append(" ORDER BY m.FrameName ");

            ExcuteCMD excuteCMD = new ExcuteCMD();
            var dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
            {
                FrameID = FrameID
            });

            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {

        }
    }
    [WebMethod(EnableSession = true)]
    public string SaveFrameMaster(string FrameID, string FrameName, int Active)
    {
        MySqlConnection objCon = Util.GetMySqlCon();
        objCon.Open();
        MySqlTransaction objTrans = objCon.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        string str = "";
        string msg = "";
        int Count = 0;
        var Status = false;
        try
        {
            if (FrameID == string.Empty)
                Count = Util.GetInt(StockReports.ExecuteScalar("Select Count(*) from f_framemaster where FrameName='" + FrameName + "'"));
            else
                Count = Util.GetInt(StockReports.ExecuteScalar("Select Count(*) from f_framemaster where FrameName='" + FrameName + "' and FrameID!=" + FrameID + " "));
            if (Count == 0)
            {
                if (FrameID == string.Empty)
                {
                    str = "insert into f_framemaster(FrameName,createdBy,CreatedDate,IsActive) values('" + FrameName + "','" + Util.GetString(System.Web.HttpContext.Current.Session["ID"].ToString()) + "',NOW()," + Active + ")";
                    msg = "File Added Successfully.";
                }
                else if (FrameID != string.Empty)
                {
                    str = "update f_framemaster set FrameName='" + FrameName + "',IsActive=" + Active + " where FrameID=" + FrameID + "";
                    msg = "File Updated Successfully.";
                }
                int i = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, str);
                objTrans.Commit();
                Status = true;
            }
            else
            {
                msg = "Frame Name is already exist.";
            }
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = Status, message = msg });
        }
        catch (Exception ex)
        {
            objTrans.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            objTrans.Dispose();
            objCon.Close();
            objCon.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public string bindDoctorDropDown()
    {
        try
        {
            DataTable dt = All_LoadData.bindDoctor();
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {

        }
    }
    [WebMethod(EnableSession = true)]
    public string bindRightFrame(string LoginType, string ID, string doctorDeptID, int type)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            if (type == 0)
            {
                sb.Append("select t1.FileName DisplayName,t1.Id from ( select CONCAT(fm.DispName,'(',fm.Description,')')FileName,fm.id from f_filemaster fm inner join f_MenuMaster mm on fm.menuid=mm.id");
                sb.Append(" where fm.Active = 1 and mm.Active = 1  and FM.MenuId=" + ID);
                sb.Append(" )t1 left join ( select fm.DispName,fm.id from f_filemaster fm inner join f_file_role fr on fm.ID = fr.UrlID");
                sb.Append("  inner join f_rolemaster rm on fr.RoleID = rm.ID where fm.Active = 1 and fr.Active = 1 ");
                sb.Append(" and rm.ID = " + LoginType + " and FM.MenuId=" + ID + ")t2 on t1.id = t2.id where t2.id is null order by T1.FileName");
            }
            else if (type == 1)
            {
                sb.Append("  SELECT t1.FrameName DisplayName,t1.Id FROM ( SELECT CONCAT(fmm.FileName,'(',fmm.Description,')')FrameName,fmm.id ");
                sb.Append(" FROM f_framemenumaster fmm INNER JOIN f_framemaster fm ON fmm.frameid=fm.frameid WHERE fm.IsActive = 1 AND fmm.IsActive = 1 ");
                sb.Append("  AND fm.frameid=" + ID + " )t1 LEFT JOIN ( SELECT fmm.FileName,fmm.id FROM f_framemenumaster fmm  ");
                sb.Append(" INNER JOIN f_frame_role fr ON fmm.ID = fr.URLID  INNER JOIN f_rolemaster rm ON fr.RoleID = rm.ID ");
                sb.Append("  WHERE fmm.IsActive = 1 AND fr.IsActive = 1  AND rm.ID = " + LoginType + " ");
                sb.Append("AND fmm.frameid=" + ID + ")t2 ON t1.Id = t2.Id WHERE t2.Id IS NULL ORDER BY T1.FrameName ");
            }
            else if (type == 2)
            {
                sb.Append(" SELECT t1.MenuName DisplayName,t1.Id FROM ");
                sb.Append(" ( SELECT CONCAT(cmm.MenuName,'(',IFNULL(cmm.Description,''),')')MenuName,cmm.Id  ");
                sb.Append("   FROM cpoe_menumaster cmm WHERE cmm.IsActive = 1 AND cmm.RoleID='" + LoginType + "' )t1");
                sb.Append("  LEFT JOIN ( ");
                sb.Append("   SELECT cmm.MenuName,cmm.id FROM cpoe_menumaster cmm  INNER JOIN  ");
                sb.Append("   cpoe_menu cm ON cmm.id=cm.menuid   ");
                sb.Append("   WHERE cmm.IsActive = 1 AND cm.IsActive = 1 AND cm.RoleID='" + LoginType + "' ");
                if (ID != "0")
                    sb.Append(" AND cm.doctorID='" + ID + "' ");
                else
                    sb.Append(" AND cm.DocDepartmentID='" + doctorDeptID + "' GROUP BY cm.DocDepartmentID,cm.MenuID");
                sb.Append(" )t2 ON t1.Id = t2.Id WHERE t2.Id IS NULL ORDER BY t1.MenuName  ");
            }
            else
            {

                sb.Append(" SELECT t1.MenuName DisplayName,t1.Id FROM  (   ");
                sb.Append("     SELECT CONCAT(cp.`AccordianName`,'(',IFNULL(cp.`ViewUrl`,''),')')MenuName,cp.id      ");
                sb.Append("     FROM  cpoe_prescription_master cp   ");
                sb.Append("     INNER JOIN cpoe_prescription_master_Setting cpms ON cp.`ID`=cpms.`CPOE_Prescription_Master_ID`   ");
                sb.Append("     WHERE cpms.`RoleID`='" + LoginType + "' AND cp.IsActive=1 AND cpms.`IsActive`=1 AND cpms.`IsDefault`=1   ");
                sb.Append("     AND IFNULL(cpms.`DoctorID`,'')='' GROUP BY cp.`ID`  ");
                sb.Append(" )t1    ");
                sb.Append(" LEFT JOIN (      ");
                sb.Append(" 	SELECT cp.`AccordianName` AS MenuName,cp.id      ");
                sb.Append(" 	FROM  cpoe_prescription_master cp   ");
                sb.Append(" 	INNER JOIN cpoe_prescription_master_Setting cpms ON cp.`ID`=cpms.`CPOE_Prescription_Master_ID`   ");
                sb.Append(" 	WHERE cpms.`RoleID`='" + LoginType + "' AND cp.IsActive=1 AND cpms.`IsActive`=1 AND cpms.`IsDefault`=0   ");
                sb.Append(" 	AND cpms.`DoctorID`='" + ID + "' GROUP BY cp.`ID`  ");
                sb.Append(" )t2 ON t1.Id = t2.Id WHERE t2.Id IS NULL ORDER BY t1.MenuName   ");
            }
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            else
                return "";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
    }
    [WebMethod(EnableSession = true)]
    public string bindAvailableType(string ID, string RoleID, string doctorDeptID, int type)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            if (type == 0)
            {
                sb.Append(" select CONCAT(fm.DispName,'(',fm.Description,')') DisplayName,FM.Id from f_filemaster FM inner join f_file_Role Fr on FM.Id=Fr.urlid and Fr.RoleID=" + RoleID + " and fm.menuid=" + ID + " and Fr.Active=1 order by Fr.SNo ");
            }
            else if (type == 1)
            {
                sb.Append("   SELECT CONCAT(fmm.FileName,'(',fmm.Description,')') DisplayName,fmm.Id ");
                sb.Append(" FROM f_framemenumaster fmm INNER JOIN f_frame_role Fr ON ");
                sb.Append(" fmm.Id=Fr.URLId AND Fr.RoleID=" + RoleID + " AND fmm.frameid=" + ID + " AND Fr.IsActive=1 ORDER BY fr.SequenceNo    ");
            }
            else if (type == 2)
            {
                sb.Append("   SELECT CONCAT(cmm.MenuName,'(',IFNULL(cmm.Description,''),')') DisplayName,cmm.Id ");
                sb.Append(" FROM cpoe_menumaster cmm INNER JOIN cpoe_menu cm ON ");
                sb.Append(" cmm.Id=cm.MenuId AND cm.RoleID='" + RoleID + "' AND cmm.IsActive=1 AND cm.IsActive=1 ");
                if (ID != "0")
                    sb.Append(" AND cm.doctorID='" + ID + "' ");
                else
                    sb.Append(" AND cm.DocDepartmentID='" + doctorDeptID + "' GROUP BY cm.DocDepartmentID,cm.MenuID");
                sb.Append(" ORDER BY cm.SequenceNo    ");
            }
            else
            {
                sb.Append("  SELECT CONCAT(cp.`AccordianName`,'(',IFNULL(cp.`ViewUrl`,''),')') DisplayName,cp.Id   ");
                sb.Append("  FROM  cpoe_prescription_master cp  ");
                sb.Append("  INNER JOIN cpoe_prescription_master_Setting cpms ON cp.`ID`=cpms.`CPOE_Prescription_Master_ID`  ");
                sb.Append("  WHERE cpms.`RoleID`='" + RoleID + "' AND cp.IsActive=1 AND cpms.`IsActive`=1 AND cpms.`IsDefault`=0  ");
                sb.Append("  AND cpms.`DoctorID`='" + ID + "' GROUP BY cp.`ID` ");
                sb.Append("  ORDER BY cpms.order+0 ");
            }
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            else
                return "";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
    }
    [WebMethod(EnableSession = true)]
    public string RoleInsert(List<RoleData> Data)
    {
        int len = Data.Count;
        if (len > 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction();
            try
            {
                for (int i = 0; i < Data.Count; i++)
                {
                    if (Util.GetInt(Data[i].Type) == 0)
                    {
                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "call InsertRight(" + Util.GetString(Data[i].URLId) + "," + Data[i].RoleID + ")");
                    }
                    else if (Util.GetInt(Data[i].Type) == 1)
                    {
                        int SequenceNo = (Data[i].SequenceNo) + 1;
                        int Count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_frame_role where URLID=" + Data[i].URLId + " AND RoleID=" + Data[i].RoleID + ""));
                        if (Count == 0)
                        {
                            string str = "Insert into f_frame_role(URLID,RoleID,SequenceNo,CreatedBy) " +
                      " values(" + Data[i].URLId + ",'" + Data[0].RoleID + "'," + SequenceNo + ",'" + HttpContext.Current.Session["ID"].ToString() + "')";
                            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str);
                        }
                        else
                        {
                            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE f_frame_role SET IsActive=1,SequenceNo=" + SequenceNo + " WHERE URLID=" + Data[i].URLId + " AND RoleID=" + Data[i].RoleID + "");
                        }
                    }
                    else if (Util.GetInt(Data[i].Type) == 2)
                    {
                        int DocDepartmentID = Util.GetInt(StockReports.ExecuteScalar("SELECT DocDepartmentID FROM doctor_master WHERE doctorID='" + Data[0].doctorID + "' "));
                        int SequenceNo = (Data[i].SequenceNo) + 1;
                        int Count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM cpoe_menu where MenuID=" + Data[i].URLId + " AND RoleID=" + Data[i].RoleID + " AND doctorID='" + Data[0].doctorID + "'"));
                        if (Count == 0)
                        {
                            string str = "Insert into cpoe_menu(MenuID,RoleID,SequenceNo,CreatedBy,doctorID,DocDepartmentID) " +
                      " values(" + Data[i].URLId + ",'" + Data[0].RoleID + "'," + SequenceNo + ",'" + HttpContext.Current.Session["ID"].ToString() + "','" + Data[0].doctorID + "','" + DocDepartmentID + "')";
                            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str);
                        }
                        else
                        {
                            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE cpoe_menu SET IsActive=1,SequenceNo=" + SequenceNo + " WHERE MenuID=" + Data[i].URLId + " AND RoleID=" + Data[i].RoleID + " AND doctorID='" + Data[0].doctorID + "' ");
                        }
                    }
                    else if (Util.GetInt(Data[i].Type) == 3)
                    {
                        int SequenceNo = (Data[i].SequenceNo) + 1;
                        if (i == 0)
                            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE cpoe_prescription_master_setting SET IsActive=0,UpdatedDateTime=NOW(),UpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "' WHERE RoleID='" + Data[i].RoleID + "' and DoctorID='" + Data[0].doctorID + "' AND IsActive=1  ");
                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO cpoe_prescription_master_setting(RoleID,CPOE_Prescription_Master_ID,`Order`,CreatedBy,CreatedDateTime,DoctorID) VALUES('" + Data[i].RoleID + "','" + Data[i].URLId + "','" + SequenceNo + "','" + HttpContext.Current.Session["ID"].ToString() + "',now(),'" + Data[0].doctorID + "') ");
                    }
                }
                tranX.Commit();
                return "1";
            }
            catch (Exception ex)
            {
                tranX.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return "0";
            }
            finally
            {
                tranX.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        else
        {
            return "0";
        }
    }
    [WebMethod(EnableSession = true)]
    public string RoleUpdate(List<RoleData> Data)
    {
        int len = Data.Count;
        if (len > 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction();
            try
            {
                for (int i = 0; i < Data.Count; i++)
                {
                    if (Util.GetInt(Data[i].Type) == 0)
                    {
                        MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE f_file_Role SET Active=0 WHERE UrlID=" + Data[i].URLId + " AND RoleID=" + Data[i].RoleID + "");
                    }
                    else if (Util.GetInt(Data[i].Type) == 1)
                    {
                        MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE f_frame_role SET IsActive=0 WHERE URLID=" + Data[i].URLId + " AND RoleID=" + Data[i].RoleID + "");
                    }
                    else if (Util.GetInt(Data[i].Type) == 2)
                    {
                        MySqlHelper.ExecuteNonQuery(con, CommandType.Text, " UPDATE cpoe_menu SET IsActive=0 WHERE MenuID=" + Data[i].URLId + " AND RoleID=" + Data[i].RoleID + " And doctorID='" + Data[0].doctorID + "'; ");
                    }
                    else if (Util.GetInt(Data[i].Type) == 3)
                    {
                        MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE cpoe_prescription_master_setting SET IsActive=0,UpdatedDateTime=NOW(),UpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "' WHERE RoleID='" + Data[i].RoleID + "' and DoctorID='" + Data[0].doctorID + "' and CPOE_Prescription_Master_ID='" + Data[i].URLId + "' AND IsActive=1 ; ");
                    }
                }
                tranX.Commit();
                return "1";
            }
            catch (Exception ex)
            {
                tranX.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return "0";
            }
            finally
            {
                tranX.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        else
        {
            return "0";
        }
    }
    [WebMethod(EnableSession = true)]
    public string SequenceUpdate(List<RoleData> Data)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            for (int i = 0; i < Data.Count; i++)
            {
                if (Util.GetInt(Data[i].Type) == 1)
                {
                    int seq = (Data[i].SequenceNo) + 1;
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "Update f_frame_role Set SequenceNo=" + seq + " where RoleID=" + Data[i].RoleID + " and URLId=" + Data[i].URLId + "  ");
                }
                else if (Util.GetInt(Data[i].Type) == 2)
                {
                    int seq = (Data[i].SequenceNo) + 1;
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, " Update cpoe_menu Set SequenceNo=" + seq + " where RoleID=" + Data[i].RoleID + " and MenuId=" + Data[i].URLId + " And doctorID='" + Data[0].doctorID + "' ");
                }
                else if (Util.GetInt(Data[i].Type) == 3)
                {
                    int seq = (Data[i].SequenceNo) + 1;
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, " UPDATE cpoe_prescription_master_setting SET `Order`=" + seq + ",UpdatedDateTime=NOW(),UpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "' WHERE RoleID='" + Data[i].RoleID + "' and DoctorID='" + Data[0].doctorID + "' and CPOE_Prescription_Master_ID='" + Data[i].URLId + "' AND IsActive=1; ");
                }
            }
            tranX.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public string UpdateMenuSNo(string RoleID, string RoleName, List<FileRole> fileRoleList)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            for (int i = 0; i < fileRoleList.Count; i++)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " UPDATE f_file_Role SET  SNo=" + fileRoleList[i].SNo + " WHERE UrlID=" + fileRoleList[i].UrlID + " AND RoleID=" + RoleID + " ");
            }
            tnx.Commit();
            //generate Menu
            StockReports.GenerateMenuData(RoleName);
            return "1";
        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Dispose();
            con.Close();
        }
    }
    [WebMethod]
    public string bindSequenceMenu(int Type, string RoleID)
    {
        try
        {
            StringBuilder sqlCMD = new StringBuilder();
            ExcuteCMD excuteCMD = new ExcuteCMD();
            DataTable dt = new DataTable();
            if (Type == 0)
            {
                dt = StockReports.GetDataTable(" select distinct(mm.MenuName)MenuName,mm.Id,IFNULL(rsm.SNo,'0')SNo from f_file_role fr inner join f_filemaster fm on fr.UrlID = fm.ID inner join f_menumaster mm on fm.MenuID = mm.ID  LEFT JOIN f_role_menu_Sno rsm ON rsm.MenuID=fm.MenuID AND rsm.RoleID=fr.RoleID  where fr.Active = 1  and fm.Active=1 and fr.RoleID ='" + RoleID + "' order by rsm.SNo,mm.menuname ");
            }
          
            else if (Type == 2)
            {
                dt = StockReports.GetDataTable(" SELECT Id,MenuName,IFNULL(SequenceNo,'0')SNo,IsActive,'Active' Active,'DeActive' DeActive FROM  cpoe_menumaster WHERE RoleID='" + RoleID + "' order by SequenceNo+0 ");
            }
            else if (Type == 3)
            {
                dt = StockReports.GetDataTable("SELECT cp.`ID` AS Id,cp.`AccordianName` AS MenuName,IFNULL(cpms.Order,'0')SNo,cpms.IsActive,'Active' Active,'DeActive' DeActive FROM  cpoe_prescription_master cp INNER JOIN cpoe_prescription_master_Setting cpms ON cp.`ID`=cpms.`CPOE_Prescription_Master_ID` WHERE cpms.`RoleID`='" + RoleID + "' AND cp.IsActive=1 AND cpms.`IsDefault`=1 AND IFNULL(cpms.`DoctorID`,'')='' group by cp.ID ORDER BY cpms.`Order`+0 ");
                if (dt.Rows.Count == 0)
                {
                    dt = StockReports.GetDataTable("SELECT cp.`ID` AS Id,cp.`AccordianName` AS MenuName,IFNULL(cp.Order,'0')SNo,IsActive,'Active' Active,'DeActive' DeActive FROM cpoe_prescription_master cp WHERE cp.IsActive=1  ORDER BY cp.`Order`+0 ");
                }
            }
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {

        }
    }
    [WebMethod(EnableSession = true)]
    public string saveTable(object Data, string RoleID, int type, string RoleName)
    {
        List<RoleData> Menu = new JavaScriptSerializer().ConvertToType<List<RoleData>>(Data);
        if (Menu.Count > 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction();
            try
            {
                if (type == 0)
                {
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, " DELETE FROM f_role_menu_Sno WHERE RoleID=" + RoleID + " ");
                }
                for (int i = 0; i < Menu.Count; i++)
                {
                    if (type == 0)
                    {
                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "Insert INTO f_role_menu_Sno(RoleID,MenuID,SNo,UserID) VALUES(" + RoleID + "," + Menu[i].ID + "," + (Util.GetInt(i) + 1) + ",'" + HttpContext.Current.Session["ID"].ToString() + "' )");
                    }
                    else if (type == 2)
                    {
                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE cpoe_menumaster cmm LEFT JOIN cpoe_menu cm ON cmm.id=cm.MenuID  SET cmm.SequenceNo='" + (Util.GetInt(i) + 1) + "'  WHERE cmm.RoleID='" + RoleID + "' AND cmm.ID='" + Menu[i].ID + "' ");
                    }
                    else
                    {
                        if (i == 0)
                        {
                            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE cpoe_prescription_master_setting SET IsDefault=2,IsActive=0,UpdatedDateTime=NOW(),UpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "' WHERE RoleID='" + RoleID + "' and IsDefault=1 AND IsActive=1 ");
                          //  MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE cpoe_prescription_master_setting cm SET cm.Order='" + (Util.GetInt(i) + 1) + "',cm.UpdatedDateTime=NOW(),cm.UpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "' WHERE cm.RoleID='" + RoleID + "' and cm.IsDefault=0 AND cm.IsActive=1 AND cm.CPOE_Prescription_Master_ID='" + Menu[i].ID + "' and IFNULL(cm.DoctorID,'')!='' ");

                        }

                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO cpoe_prescription_master_setting(RoleID,CPOE_Prescription_Master_ID,`Order`,IsDefault,CreatedBy,CreatedDateTime,IsActive) VALUES('" + RoleID + "','" + Menu[i].ID + "','" + (Util.GetInt(i) + 1) + "',1,'" + HttpContext.Current.Session["ID"].ToString() + "',now(),'1') ");



                    }
                }
                tranX.Commit();
                if (type == 0)
                {
                    //generate Menu
                    StockReports.GenerateMenuData(RoleName);
                }
                return "1";
            }
            catch (Exception ex)
            {

                tranX.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return "0";
            }
            finally
            {
                tranX.Dispose();
                con.Close();
                con.Dispose();
            }
        }

        else
        {
            return "";
        }
    }
    [WebMethod(EnableSession = true)]
    public string saveCpoeMenu(string MenuName, string URL, string Description, string RoleID, int Status, string ID)
    {

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        string str = "";
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            int Count = Util.GetInt(StockReports.ExecuteScalar("Select Count(*) from cpoe_menumaster where URL='" + URL + "' and MenuName='" + MenuName + "' AND RoleID='" + RoleID + "'"));
            if (Count == 0)
            {
                int seqNo = Util.GetInt(StockReports.ExecuteScalar("Select max(SequenceNo)+1 from cpoe_menumaster where MenuName='" + MenuName + "' AND RoleID='" + RoleID + "'"));
                if (ID != "")
                {
                    str = " Update cpoe_menumaster Set MenuName='" + MenuName.Trim() + "',URL='" + URL.Trim() + "',Description='" + Description.Trim() + "',RoleID='" + RoleID + "',IsActive=" + Status + " where ID='" + ID + "' ";
                }
                else
                {

                    str = "Insert into cpoe_menumaster(MenuName,URL,Description,CreatedBy,RoleID,SequenceNo) " +
                       " values('" + MenuName.Trim() + "','" + URL.Trim() + "','" + Description.Trim() + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + RoleID + "','" + seqNo + "')";
                }
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str);
                tranX.Commit();
                return "1";
            }

            else
            {
                return "2";
            }
        }
        catch (Exception ex)
        {
            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public string bindDoctorTabs(string doctorId, string RoleID)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("  SELECT cp.`AccordianName`,cp.Id,cpms.IsDefaultCheck   ");
        sb.Append("  FROM  cpoe_prescription_master cp  ");
        sb.Append("  INNER JOIN cpoe_prescription_master_Setting cpms ON cp.`ID`=cpms.`CPOE_Prescription_Master_ID`  ");
        sb.Append("  WHERE cpms.`RoleID`='" + RoleID + "' AND cp.IsActive=1 AND cpms.`IsActive`=1 AND cpms.`IsDefault`=0  ");
        sb.Append("  AND cpms.`DoctorID`='" + doctorId + "' GROUP BY cp.`ID` ");
        sb.Append("  ORDER BY cpms.order+0 ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }
    [WebMethod(EnableSession = true)]
    public string saveDefaultTabSeletionRights(List<RoleData> Data)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            StringBuilder sb = new StringBuilder();

            sb = new StringBuilder();
            sb.Append(" UPDATE cpoe_prescription_master_setting s SET s.`IsDefaultCheck`=0,s.`UpdatedBy`=@updatedBy,s.`UpdatedDateTime`=now() ");
            sb.Append(" WHERE s.`DoctorID`=@doctorID AND s.`RoleID`=@RoleID AND s.`IsActive`=1 and s.IsDefault=0 ");

            excuteCMD.ExecuteScalar(tnx, sb.ToString(), CommandType.Text, new
            {
                updatedBy = HttpContext.Current.Session["ID"].ToString(),
                doctorID = Data[0].doctorID,
                RoleID = Data[0].RoleID
            });

            for (int i = 0; i < Data.Count; i++)
            {
                sb = new StringBuilder();
                sb.Append(" UPDATE cpoe_prescription_master_setting s SET s.`IsDefaultCheck`=1,s.`UpdatedBy`=@updatedBy,s.`UpdatedDateTime`=now() ");
                sb.Append(" WHERE s.`CPOE_Prescription_Master_ID`=@cpoe_Prescription_Master_ID AND s.`DoctorID`=@doctorID AND s.`RoleID`=@RoleID AND s.`IsActive`=1 and s.IsDefault=0  ");

                excuteCMD.ExecuteScalar(tnx, sb.ToString(), CommandType.Text, new
                {
                    updatedBy = HttpContext.Current.Session["ID"].ToString(),
                    doctorID = Data[i].doctorID,
                    RoleID = Data[i].RoleID,
                    cpoe_Prescription_Master_ID = Data[i].tabId
                });


            }

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage, message = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

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
    public  string loadMenuView()
    {
        StringBuilder sb = new StringBuilder();
        try
        {
            sb.Append(" SELECT up.ID,up.AccordianName,up.ViewUrl FROM page_privilege_master up  ");
            sb.Append(" WHERE up.IsActive=1 ORDER BY up.Order ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
    }

    [WebMethod]
    public string bindLoginType()
    {
        DataTable dt = StockReports.GetDataTable("select ID,RoleName from f_rolemaster where active=1 order by RoleName");

        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";

    }
    
    public class RoleData
    {
        public string URLId { get; set; }
        public int RoleID { get; set; }
        public int Type { get; set; }
        public int SequenceNo { get; set; }
        public string doctorID { get; set; }
        public string SNo { get; set; }
        public string ID { get; set; }
        public string MenuName { get; set; }
        public string tabId { get; set; }
    }
}

