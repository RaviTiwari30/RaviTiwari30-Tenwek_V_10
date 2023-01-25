using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;

public partial class Design_CPOE_CPOEMenuRight : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!IsPostBack)
            {
                BindDepartment();
                bindLoginType();
                ddlRole.SelectedIndex = ddlRole.Items.IndexOf(ddlRole.Items.FindByValue(Session["RoleID"].ToString()));

                All_LoadData.bindDoctor(ddlDoctor, "Select");
                string DoctorID = StockReports.ExecuteScalar("SELECT de.doctorID FROM doctor_employee de WHERE de.EmployeeID='" + Session["ID"].ToString() + "'");
                //  DoctorID = "LSHHI1";
                if (DoctorID != "")
                {
                    ddlDoctor.SelectedIndex = ddlDoctor.Items.IndexOf(ddlDoctor.Items.FindByValue(DoctorID));
                }
                if (Session["ID"].ToString() != "EMP001")
                {
                    btnCreate.Visible = false;
                    if (Session["RoleID"].ToString() != "6")
                    {
                        ddlRole.Enabled = false;
                        ddlDoctor.Enabled = false;
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
    private void BindDepartment()
    {
        try
        {
            DataTable dt = StockReports.GetDataTable(" SELECT tm.Name,tm.ID FROM type_master tm INNER JOIN doctor_master dm ON dm.DocDepartmentID=tm.ID WHERE TypeID='5' group by dm.DocDepartmentID ");
            if (dt.Rows.Count > 0)
            {
                ddlDoctorDept.DataSource = dt;
                ddlDoctorDept.DataTextField = "Name";
                ddlDoctorDept.DataValueField = "ID";
                ddlDoctorDept.DataBind();
                ddlDoctorDept.Items.Insert(0, "Select");
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
    private void bindLoginType()
    {
        try
        {
            DataTable dt = All_LoadData.LoadRole();
            if (dt != null && dt.Rows.Count > 0)
            {
                ddlRole.DataSource = dt;
                ddlRole.DataTextField = "RoleName";
                ddlRole.DataValueField = "ID";
                ddlRole.DataBind();
                ddlRoleMenu.DataSource = dt;
                ddlRoleMenu.DataTextField = "RoleName";
                ddlRoleMenu.DataValueField = "ID";
                ddlRoleMenu.DataBind();
                MenuHeaderBind();


            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    public void MenuHeaderBind()
    {
        DataTable dtHeader = StockReports.GetDataTable("Select HeaderName From f_frame_Menu_Header Order by id");

        ddlMenuHeader.DataSource = dtHeader;
        ddlMenuHeader.DataValueField = "HeaderName";
        ddlMenuHeader.DataTextField = "HeaderName";

        ddlMenuHeader.DataBind();

        //Add blank item at index 0.
        ddlMenuHeader.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select", ""));
    }




    [WebMethod(EnableSession=true)]
    public static string saveMenu(string MenuName, string URL, string Description, string RoleID,string MenuHeader)
    {

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            int Count = Util.GetInt(StockReports.ExecuteScalar("Select Count(*) from cpoe_menumaster where MenuName='" + MenuName + "' AND RoleID='" + RoleID + "'"));
            if (Count == 0)
            {
                int seqNo = Util.GetInt(StockReports.ExecuteScalar("Select max(SequenceNo)+1 from cpoe_menumaster where MenuName='" + MenuName + "' AND RoleID='" + RoleID + "'"));
                string str = "Insert into cpoe_menumaster(MenuName,URL,Description,CreatedBy,RoleID,SequenceNo,MenuHeader) " +
                    " values('" + MenuName.Trim() + "','" + URL.Trim() + "','" + Description.Trim() + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + RoleID + "','" + seqNo + "','"+MenuHeader+"')";
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
    [WebMethod(EnableSession = true)]
    public static string bindRightFrame(string RoleID, string doctorID, string doctorDeptID, int type)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            if (type == 1)
            {
                sb.Append(" SELECT t1.MenuName,t1.Id FROM ");
                sb.Append(" ( SELECT CONCAT(cmm.MenuName,'(',IFNULL(cmm.Description,''),')')MenuName,cmm.Id  ");
                sb.Append("   FROM cpoe_menumaster cmm WHERE cmm.IsActive = 1 AND cmm.RoleID='" + RoleID + "' )t1");
                sb.Append("  LEFT JOIN ( ");
                sb.Append("   SELECT cmm.MenuName,cmm.id FROM cpoe_menumaster cmm  INNER JOIN  ");
                sb.Append("   cpoe_menu cm ON cmm.id=cm.menuid   ");
                sb.Append("   WHERE cmm.IsActive = 1 AND cm.IsActive = 1 AND cm.RoleID='" + RoleID + "' ");
                if (doctorID != "0")
                    sb.Append(" AND cm.doctorID='" + doctorID + "' ");
                else
                    sb.Append(" AND cm.DocDepartmentID='" + doctorDeptID + "' GROUP BY cm.DocDepartmentID,cm.MenuID");
                sb.Append(" )t2 ON t1.Id = t2.Id WHERE t2.Id IS NULL ORDER BY t1.MenuName  ");
            }
            else
            {

                sb.Append(" SELECT t1.MenuName,t1.Id FROM  (   ");
                sb.Append("     SELECT CONCAT(cp.`AccordianName`,'(',IFNULL(cp.`ViewUrl`,''),')')MenuName,cp.id      ");
                sb.Append("     FROM  cpoe_prescription_master cp   ");
                sb.Append("     INNER JOIN cpoe_prescription_master_Setting cpms ON cp.`ID`=cpms.`CPOE_Prescription_Master_ID`   ");
                sb.Append("     WHERE cpms.`RoleID`='" + RoleID + "' AND cp.IsActive=1 AND cpms.`IsActive`=1 AND cpms.`IsDefault`=1   ");
                sb.Append("     AND IFNULL(cpms.`DoctorID`,'')='' GROUP BY cp.`ID`  ");
                sb.Append(" )t1    ");
                sb.Append(" LEFT JOIN (      ");
                sb.Append(" 	SELECT cp.`AccordianName` AS MenuName,cp.id      ");
                sb.Append(" 	FROM  cpoe_prescription_master cp   ");
                sb.Append(" 	INNER JOIN cpoe_prescription_master_Setting cpms ON cp.`ID`=cpms.`CPOE_Prescription_Master_ID`   ");
                sb.Append(" 	WHERE cpms.`RoleID`='" + RoleID + "' AND cp.IsActive=1 AND cpms.`IsActive`=1 AND cpms.`IsDefault`=0   ");
                sb.Append(" 	AND cpms.`DoctorID`='" + doctorID + "' GROUP BY cp.`ID`  ");
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
    public static string bindAvaType(string doctorId, string RoleID, string doctorDeptID, int type)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            if (type == 1)
            {
                sb.Append("   SELECT CONCAT(cmm.MenuName,'(',IFNULL(cmm.Description,''),')')MenuName,cmm.Id ");
                sb.Append(" FROM cpoe_menumaster cmm INNER JOIN cpoe_menu cm ON ");
                sb.Append(" cmm.Id=cm.MenuId AND cm.RoleID='" + RoleID + "' AND cmm.IsActive=1 AND cm.IsActive=1 ");

                if (doctorId != "0")
                    sb.Append(" AND cm.doctorID='" + doctorId + "' ");
                else
                    sb.Append(" AND cm.DocDepartmentID='" + doctorDeptID + "' GROUP BY cm.DocDepartmentID,cm.MenuID");


                sb.Append(" ORDER BY cm.SequenceNo    ");
            }
            else
            {
                sb.Append("  SELECT CONCAT(cp.`AccordianName`,'(',IFNULL(cp.`ViewUrl`,''),')')MenuName,cp.Id   ");
                sb.Append("  FROM  cpoe_prescription_master cp  ");
                sb.Append("  INNER JOIN cpoe_prescription_master_Setting cpms ON cp.`ID`=cpms.`CPOE_Prescription_Master_ID`  ");
                sb.Append("  WHERE cpms.`RoleID`='" + RoleID + "' AND cp.IsActive=1 AND cpms.`IsActive`=1 AND cpms.`IsDefault`=0  ");
                sb.Append("  AND cpms.`DoctorID`='" + doctorId + "' GROUP BY cp.`ID` ");
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
    
    public class CPOEMenu
    {
       
        public int RoleID { get; set; }
        public int SequenceNo { get; set; }
        public int MenuID { get; set; }
        public string doctorID { get; set; }
        public string doctorDeptID { get; set; }
        public int Type { get; set; }
    }
    [WebMethod(EnableSession = true)]
    public static string menuInsert(List<CPOEMenu> Data, int type)
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
                if (type == 1)
                {
                    if (Data[0].Type == 1)
                    {
                        int DocDepartmentID = Util.GetInt(StockReports.ExecuteScalar("SELECT DocDepartmentID FROM doctor_master WHERE doctorID='" + Data[0].doctorID + "' "));

                        for (int i = 0; i < Data.Count; i++)
                        {
                            int SequenceNo = (Data[i].SequenceNo) + 1;
                            int Count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM cpoe_menu where MenuID=" + Data[i].MenuID + " AND RoleID=" + Data[i].RoleID + " AND doctorID='" + Data[0].doctorID + "'"));
                            if (Count == 0)
                            {
                                string str = "Insert into cpoe_menu(MenuID,RoleID,SequenceNo,CreatedBy,doctorID,DocDepartmentID) " +
                          " values(" + Data[i].MenuID + ",'" + Data[0].RoleID + "'," + SequenceNo + ",'" + HttpContext.Current.Session["ID"].ToString() + "','" + Data[0].doctorID + "','" + DocDepartmentID + "')";
                                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str);
                            }
                            else
                            {
                                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE cpoe_menu SET IsActive=1,SequenceNo=" + SequenceNo + " WHERE MenuID=" + Data[i].MenuID + " AND RoleID=" + Data[i].RoleID + " AND doctorID='" + Data[0].doctorID + "' ");
                            }
                        }
                    }
                    else
                    {
                        DataTable dtDoctor = StockReports.GetDataTable(" SELECT doctorID FROM doctor_master WHERE DocDepartmentID=" + Data[0].doctorDeptID + " AND Isactive=1");
                        if (dtDoctor.Rows.Count > 0)
                        {
                            for (int k = 0; k < dtDoctor.Rows.Count; k++)
                            {
                                for (int i = 0; i < Data.Count; i++)
                                {
                                    int SequenceNo = (Data[i].SequenceNo) + 1;
                                    int Count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM cpoe_menu where MenuID=" + Data[i].MenuID + " AND RoleID=" + Data[i].RoleID + " AND doctorID='" + dtDoctor.Rows[k]["doctorID"].ToString() + "'"));
                                    if (Count == 0)
                                    {
                                        string str = "Insert into cpoe_menu(MenuID,RoleID,SequenceNo,CreatedBy,doctorID,DocDepartmentID) " +
                                  " values(" + Data[i].MenuID + ",'" + Data[0].RoleID + "'," + SequenceNo + ",'" + HttpContext.Current.Session["ID"].ToString() + "','" + dtDoctor.Rows[k]["doctorID"].ToString() + "'," + Data[i].doctorDeptID + ")";
                                        MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str);
                                    }
                                    else
                                    {
                                        MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE cpoe_menu SET IsActive=1,SequenceNo=" + SequenceNo + " WHERE MenuID=" + Data[i].MenuID + " AND RoleID=" + Data[i].RoleID + " AND doctorID='" + dtDoctor.Rows[k]["doctorID"].ToString() + "' ");
                                    }
                                }
                            }
                        }
                    }
                }
                else
                {
                    for (int i = 0; i < Data.Count; i++)
                    {
                        int SequenceNo = (Data[i].SequenceNo) + 1;
                        if (i == 0)
                            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE cpoe_prescription_master_setting SET IsActive=0,UpdatedDateTime=NOW(),UpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "' WHERE RoleID='" + Data[i].RoleID + "' and DoctorID='" + Data[0].doctorID + "' AND IsActive=1  ");

                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO cpoe_prescription_master_setting(RoleID,CPOE_Prescription_Master_ID,`Order`,CreatedBy,CreatedDateTime,DoctorID) VALUES('" + Data[i].RoleID + "','" + Data[i].MenuID + "','" + SequenceNo + "','" + HttpContext.Current.Session["ID"].ToString() + "',now(),'" + Data[0].doctorID + "') ");


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
    public static string menuUpdate(List<CPOEMenu> Data, int type)
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
                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < Data.Count; i++)
                {
                    if (type == 1)
                    {
                        sb.Append(" UPDATE cpoe_menu SET IsActive=0 WHERE MenuID=" + Data[i].MenuID + " AND RoleID=" + Data[i].RoleID + "  ");
                        if (Data[0].Type == 1)
                            sb.Append(" And doctorID='" + Data[0].doctorID + "'; ");
                        else
                            sb.Append(" And DocDepartmentID='" + Data[0].doctorDeptID + "'; ");
                    }
                    else
                    {
                        sb.Append("UPDATE cpoe_prescription_master_setting SET IsActive=0,UpdatedDateTime=NOW(),UpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "' WHERE RoleID='" + Data[i].RoleID + "' and DoctorID='" + Data[0].doctorID + "' and CPOE_Prescription_Master_ID='" + Data[i].MenuID + "' AND IsActive=1 ; ");
                    }

                }
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString());
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
    public static string SequenceUpdate(List<CPOEMenu> Data, int type)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            for (int i = 0; i < Data.Count; i++)
            {
                StringBuilder sb = new StringBuilder();
                int seq = (Data[i].SequenceNo) + 1;
                if (type == 1)
                {
                    sb.Append(" Update cpoe_menu Set SequenceNo=" + seq + " where RoleID=" + Data[i].RoleID + " and MenuId=" + Data[i].MenuID + " ");
                    if (Data[0].Type == 1)
                        sb.Append(" And doctorID='" + Data[0].doctorID + "' ");
                    else
                        sb.Append("  And DocDepartmentID='" + Data[0].doctorDeptID + "' ");
                }
                else
                {
                    sb.Append("  UPDATE cpoe_prescription_master_setting SET `Order`=" + seq + ",UpdatedDateTime=NOW(),UpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "' WHERE RoleID='" + Data[i].RoleID + "' and DoctorID='" + Data[0].doctorID + "' and CPOE_Prescription_Master_ID='" + Data[i].MenuID + "' AND IsActive=1 ");
                }

                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString());
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
    [WebMethod(EnableSession = true)]
    public static string docTypeCon(string Type)
    {
        try
        {
            DataTable dt = StockReports.GetDataTable("SELECT ID,TypeID,Name FROM type_master WHERE typeID=5");
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

    [WebMethod]
    public static string bindDoctorTabs(string doctorId, string RoleID)
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
    public static string saveDefaultTabSeletionRights(List<tabRights> Data)
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
                sb.Append(" WHERE s.`DoctorID`=@doctorID AND s.`RoleID`=@roleID AND s.`IsActive`=1 and s.IsDefault=0 ");

                excuteCMD.ExecuteScalar(tnx, sb.ToString(), CommandType.Text, new
                {
                    updatedBy = HttpContext.Current.Session["ID"].ToString(),
                    doctorID = Data[0].doctorId,
                    roleID = Data[0].roleID
                });

                for (int i = 0; i < Data.Count; i++)
                {
                    sb = new StringBuilder();
                    sb.Append(" UPDATE cpoe_prescription_master_setting s SET s.`IsDefaultCheck`=1,s.`UpdatedBy`=@updatedBy,s.`UpdatedDateTime`=now() ");
                    sb.Append(" WHERE s.`CPOE_Prescription_Master_ID`=@cpoe_Prescription_Master_ID AND s.`DoctorID`=@doctorID AND s.`RoleID`=@roleID AND s.`IsActive`=1 and s.IsDefault=0  ");

                    excuteCMD.ExecuteScalar(tnx, sb.ToString(), CommandType.Text, new
                   {
                       updatedBy = HttpContext.Current.Session["ID"].ToString(),
                       doctorID = Data[i].doctorId,
                       roleID = Data[i].roleID,
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

    public class tabRights
    {
        public string tabId { get; set; }
        public string doctorId { get; set; }
        public string roleID { get; set; }
    }


}