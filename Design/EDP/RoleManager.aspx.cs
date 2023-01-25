using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_EDP_RoleManager : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod(EnableSession = true)]
    public static string RoleView()
    {
        StringBuilder sb = new StringBuilder();
        try
        {
            sb.Append(" SELECT RLM.ID,RLM.AccordianName,RLM.ViewUrl FROM RoleLinkMaster RLM  ");
            sb.Append(" WHERE RLM.IsActive=1 ORDER BY RLM.Order ");
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


    [WebMethod(EnableSession = true)]
    public static string GetRole()
    {
        DataTable dt = All_LoadData.LoadRole();
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            return "";
        }
    }


    [WebMethod(EnableSession = true)]
    public static string BindDdlType()
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID,TypeName FROM master_IdFormat WHERE IsActive=1 AND IsMultiple=1");

        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
    }


    [WebMethod]
    public static string bindUniversalFormats()
    {
        DataTable dt = StockReports.GetDataTable("SELECT imf.TypeID,imf.TypeName,imf.InitialChar,imf.Separator1,if(imf.FinancialYearStart='0001-01-01','',DATE_FORMAT(imf.FinancialYearStart,'%d-%b-%Y'))FinancialYearStart,imf.Separator2,CAST(LPAD('1',imf.TypeLength,0) AS CHAR)TypeLength,imf.FormatPreview FROM id_master_format imf INNER JOIN master_IdFormat mif ON imf.formatID=mif.ID WHERE imf.IsActive=1 AND mif.isMultiple=1 AND imf.isUniversal=1 AND imf.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "'");

        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }



    [WebMethod(EnableSession = true)]
    public static string saveRoles(List<roles> roleDetail, List<roles> FormatDetail)
    {
        int roleid = 0;
        int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_rolemaster WHERE UPPER(RoleName)='" + roleDetail[0].RoleName.Trim().ToUpper() + "' and Active=1 "));
        if (count > 0)
        {
            return "2";
        }
        else
        {
            if (roleDetail[0].IsUniversal == 0)
            {
                DataTable dt = new DataTable();
                dt.Columns.AddRange(new DataColumn[2] { new DataColumn("Id", typeof(int)), new DataColumn("InitialCharacter", typeof(string)) });

                for (int i = 0; i < FormatDetail.Count; i++)
                {
                    int chkInitialCha = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM id_master_format WHERE InitialChar='" + FormatDetail[i].InitialCharacter.Trim() + "'  "));
                    if (chkInitialCha > 0)
                    {
                        DataRow dtrow = dt.NewRow();
                        dtrow["Id"] = Util.GetInt(i + 1);
                        dtrow["InitialCharacter"] = FormatDetail[i].InitialCharacter.Trim();
                        dt.Rows.Add(dtrow);
                    }
                }
                if (dt.Rows.Count > 0)
                    return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                string LedgerNo = "";
                if (roleDetail[0].IsDepartment == 1)
                {
                    Ledger_Master objLedMas = new Ledger_Master(Tranx);
                    objLedMas.LegderName = roleDetail[0].RoleName.Trim();
                    objLedMas.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                    objLedMas.GroupID = "DPT";
                    LedgerNo = objLedMas.Insert();
                }
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "INSERT INTO f_rolemaster(RoleName,Active,IsStore,IsGeneral,IsMedical,DeptLedgerNo) VALUES('" + roleDetail[0].RoleName.Trim() + "',1," + roleDetail[0].IsStore + "," + roleDetail[0].IsGeneral + "," + roleDetail[0].IsMedical + ",'" + LedgerNo + "')");
                if (roleDetail[0].menuFor.Split('#')[0] != "0")
                {
                    roleid = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT MAX(ID)roleID from f_rolemaster"));
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "INSERT INTO f_file_role(urlID,roleID,EmployeeID,Active,Sno) SELECT urlID," + roleid + ",EmployeeID,Active,Sno FROM f_file_role WHERE roleID=" + roleDetail[0].menuFor.Split('#')[0] + "  ");
                }
                if (roleDetail[0].IsUniversal == 0)
                {
                    for (int i = 0; i < FormatDetail.Count; i++)
                    {
                        string deptLedgerNo = "";
                        if (FormatDetail[i].IsUniversalType == 1)
                        {
                            deptLedgerNo = StockReports.ExecuteScalar("SELECT DeptLedgerNo FROM id_master_format WHERE isUniversal=1 AND formatID=" + FormatDetail[i].formatID + " AND IsActive=1 ");
                            if (deptLedgerNo == "")
                            {
                                return "3";
                            }
                        }

                        string formatPreview = "";
                        if (FormatDetail[i].chkFinancialYear == 1)
                            formatPreview = string.Concat(FormatDetail[i].InitialCharacter.Trim(), FormatDetail[i].Separator1.Trim(), All_LoadData.GetFinYear(FormatDetail[i].FinYear.Trim()), FormatDetail[i].Separator2.Trim(), FormatDetail[i].TextLength.Trim());
                        else
                            formatPreview = string.Concat(FormatDetail[i].InitialCharacter.Trim(), FormatDetail[i].Separator1.Trim(), FormatDetail[i].Separator2.Trim(), FormatDetail[i].TextLength.Trim());
                        StringBuilder sb = new StringBuilder();
                        sb.Append(" INSERT INTO id_master_format(TypeName,InitialChar,Separator1,FinancialYearStart,Separator2,TypeLength,UserID,FormatPreview, ");
                        sb.Append(" formatID,DeptLedgerNo,followDeptLedgerNo,chkFinancialYear,isUniversal,CentreID)VALUES( ");
                        sb.Append(" '" + FormatDetail[i].TypeName.Trim() + "','" + FormatDetail[i].InitialCharacter.Trim() + "','" + FormatDetail[i].Separator1 + "', ");
                        if (FormatDetail[i].chkFinancialYear == 1)
                            sb.Append(" '" + Convert.ToDateTime(FormatDetail[i].FinYear.Trim()).ToString("yyyy-MM-dd") + "', ");
                        else
                            sb.Append(" '" + FormatDetail[i].FinYear.Trim() + "', ");
                        sb.Append("'" + FormatDetail[i].Separator2 + "','" + FormatDetail[i].Length + "','" + HttpContext.Current.Session["ID"].ToString() + "',");
                        sb.Append(" '" + formatPreview + "','" + FormatDetail[i].formatID + "','" + LedgerNo + "', ");
                        if (FormatDetail[i].IsUniversalType == 0)
                            sb.Append(" '" + LedgerNo + "',");
                        else
                            sb.Append(" '" + deptLedgerNo + "' ,");
                        sb.Append(" '" + FormatDetail[i].chkFinancialYear + "','" + FormatDetail[i].IsUniversalType + "','" + HttpContext.Current.Session["CentreID"].ToString() + "') ");
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());
                    }
                }
                if ((Directory.Exists(HttpContext.Current.Server.MapPath("~/Design/MenuData"))) && (roleDetail[0].menuFor.Split('#')[0] != "0"))
                {
                    System.IO.File.Copy(HttpContext.Current.Server.MapPath("~/Design/MenuData/" + roleDetail[0].menuForText + ".xml"), HttpContext.Current.Server.MapPath("~/Design/MenuData/" + roleDetail[0].RoleName + ".xml"));
                }

                Tranx.Commit();
                LoadCacheQuery.dropCache("DepartmentStore");
                return "1";
            }
            catch (Exception ex)
            {
                Tranx.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return "0";
            }
            finally
            {
                Tranx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
    }




    [WebMethod(EnableSession = true)]
    public static string EditRoleById(List<roles> roleDetail, List<roles> FormatDetail)
    {


        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string LedgerNo = "";
            if (roleDetail[0].IsDepartment == 1)
            {
                if (roleDetail[0].DepartmentLedgerNumber != null)
                {

                    LedgerNo = roleDetail[0].DepartmentLedgerNumber;

                }
                else
                {
                    Ledger_Master objLedMas = new Ledger_Master(Tranx);
                    objLedMas.LegderName = roleDetail[0].RoleName.Trim();
                    objLedMas.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                    objLedMas.GroupID = "DPT";
                    LedgerNo = objLedMas.Insert();
                }

            }
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Update  f_rolemaster set RoleName='" + roleDetail[0].RoleName.Trim() + "',Active=1,IsStore=" + roleDetail[0].IsStore + " ,IsGeneral=" + roleDetail[0].IsGeneral + ", IsMedical=" + roleDetail[0].IsMedical + ",IsUniversal=" + roleDetail[0].IsUniversal + " ,DeptLedgerNo='" + LedgerNo + "'  where ID=" + roleDetail[0].RoleID + "");
            if (roleDetail[0].menuFor.Split('#')[0] != "0")
            {
                int roleid = Util.GetInt(roleDetail[0].RoleID);
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Delete from f_file_role where roleID=" + roleid + "");

                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "INSERT INTO f_file_role(urlID,roleID,EmployeeID,Active,Sno) SELECT urlID," + roleid + ",EmployeeID,Active,Sno FROM f_file_role WHERE roleID=" + roleDetail[0].menuFor.Split('#')[0] + "  ");
            }
            if (roleDetail[0].IsUniversal == 0)
            {
                for (int i = 0; i < FormatDetail.Count; i++)
                {
                    string deptLedgerNo = "";
                    if (FormatDetail[i].IsUniversalType == 1)
                    {
                        deptLedgerNo = StockReports.ExecuteScalar("SELECT DeptLedgerNo FROM id_master_format WHERE  =1 AND formatID=" + FormatDetail[i].formatID + " AND IsActive=1 ");
                        if (deptLedgerNo == "")
                        {
                            return "3";
                        }
                    }

                    string formatPreview = "";
                    if (FormatDetail[i].chkFinancialYear == 1)
                        // formatPreview = FormatDetail[i].FormatPreview.Trim();
                        string.Concat(FormatDetail[i].InitialCharacter.Trim(), FormatDetail[i].Separator1.Trim(), All_LoadData.GetFinYear(FormatDetail[i].FinYear.Trim()), FormatDetail[i].Separator2.Trim(), FormatDetail[i].TextLength.Trim());
                    else
                        //  formatPreview = formatPreview = FormatDetail[i].FormatPreview.Trim();
                        string.Concat(FormatDetail[i].InitialCharacter.Trim(), FormatDetail[i].Separator1.Trim(), FormatDetail[i].Separator2.Trim(), FormatDetail[i].TextLength.Trim());
                    StringBuilder sb = new StringBuilder();
                    sb.Append(" INSERT INTO id_master_format(TypeName,InitialChar,Separator1,FinancialYearStart,Separator2,TypeLength,UserID,FormatPreview, ");
                    sb.Append(" formatID,DeptLedgerNo,followDeptLedgerNo,chkFinancialYear,isUniversal,CentreID)VALUES( ");
                    sb.Append(" '" + FormatDetail[i].TypeName.Trim() + "','" + FormatDetail[i].InitialCharacter.Trim() + "','" + FormatDetail[i].Separator1 + "', ");
                    if (FormatDetail[i].chkFinancialYear == 1)
                        sb.Append(" '" + Convert.ToDateTime(FormatDetail[i].FinYear.Trim()).ToString("yyyy-MM-dd") + "', ");
                    else
                        sb.Append(" '" + FormatDetail[i].FinYear.Trim() + "', ");
                    sb.Append("'" + FormatDetail[i].Separator2 + "','" + FormatDetail[i].Length + "','" + HttpContext.Current.Session["ID"].ToString() + "',");
                    sb.Append(" '" + formatPreview + "','" + FormatDetail[i].formatID + "','" + LedgerNo + "', ");
                    if (FormatDetail[i].IsUniversalType == 0)
                        sb.Append(" '" + LedgerNo + "',");
                    else
                        sb.Append(" '" + deptLedgerNo + "' ,");
                    sb.Append(" '" + FormatDetail[i].chkFinancialYear + "','" + FormatDetail[i].IsUniversalType + "','" + HttpContext.Current.Session["CentreID"].ToString() + "') ");

                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Delete from id_master_format where DeptLedgerNo='" + LedgerNo + "'");

                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());
                }
            }
            if ((Directory.Exists(HttpContext.Current.Server.MapPath("~/Design/MenuData"))) && (roleDetail[0].menuFor.Split('#')[0] != "0"))
            {
                if (System.IO.File.Exists(HttpContext.Current.Server.MapPath("~/Design/MenuData/" + roleDetail[0].RoleName + ".xml")))
                {
                    System.IO.File.Delete(HttpContext.Current.Server.MapPath("~/Design/MenuData/" + roleDetail[0].RoleName + ".xml"));
                    System.IO.File.Copy(HttpContext.Current.Server.MapPath("~/Design/MenuData/" + roleDetail[0].menuForText + ".xml"), HttpContext.Current.Server.MapPath("~/Design/MenuData/" + roleDetail[0].RoleName + ".xml"));

                }
                else
                {
                    System.IO.File.Copy(HttpContext.Current.Server.MapPath("~/Design/MenuData/" + roleDetail[0].menuForText + ".xml"), HttpContext.Current.Server.MapPath("~/Design/MenuData/" + roleDetail[0].RoleName + ".xml"));

                }




            }

            Tranx.Commit();
            LoadCacheQuery.dropCache("DepartmentStore");
            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }

    }

    [WebMethod]
    public static string GetRoleToEdit(int RoleID)
    {

        DataTable dt = StockReports.GetDataTable("SELECT frm.`ID` AS RoleId,frm.`RoleName`,frm.`IsStore`,frm.`IsGeneral`,frm.`IsMedical`,frm.`IsUniversal`,  IF(frm.`DeptLedgerNo`,0,1)  AS IsDepartment ,IF(frm.`IsGeneral` OR frm.`IsMedical`,1,0) AS cangenrateprandgrn,frm.`DeptLedgerNo` FROM f_rolemaster frm WHERE id=" + RoleID + "");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });

    }
    [WebMethod]
    public static int GetLatestRoleID()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        int roleid=0;
        try
        {
            roleid = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT MAX(ID)roleID from f_rolemaster"));

            return roleid;
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            return roleid;
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }

    }

    [WebMethod]
    public static string GetNotUniversalFormate(string DeptLedgerNo)
    {

        DataTable dt = StockReports.GetDataTable("SELECT imf.`formatID` AS TypeID,imf.`TypeName`,imf.`InitialChar`,imf.`Separator1`,imf.`FinancialYearStart`,imf.`Separator2`, imf.`TypeLength`,imf.`FormatPreview`,imf.`isUniversal`,imf.`CentreID` FROM id_master_format imf WHERE imf.`DeptLedgerNo`='" + DeptLedgerNo + "'");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });

    }



    [WebMethod]
    public static string BindCentreTable(int RoleID)
    {
        string Query = "SELECT cm.`CentreID`,cm.`CentreName`,IF(fcr.`RoleID`,1,0) IsMaped  FROM center_master cm LEFT OUTER  JOIN  f_centre_role fcr ON fcr.`CentreID`=cm.`CentreID` AND fcr.`isActive`=1 AND fcr.`RoleID`='" + RoleID + "' WHERE  cm.`IsActive`=1";

        DataTable dt = StockReports.GetDataTable(Query);
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });
        }
    }

    [WebMethod(EnableSession = true)]
    public static string MapRoleToCentre(List<string> CentreID, string RoleID)
    {

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "Delete from f_centre_role where RoleID='" + RoleID + "' ");


            tranX.Commit();
        }
        catch (Exception ex)
        {
            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }



        string CreatedBy = HttpContext.Current.Session["ID"].ToString();
        int a = 0;
        foreach (string CId in CentreID)
        {
            using (MySqlConnection conn = Util.GetMySqlCon())
            {

                using (MySqlCommand cmd = new MySqlCommand("MapRoleToCentre", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@_CentreID", CId);
                    cmd.Parameters.AddWithValue("@_RoleID", RoleID);


                    cmd.Parameters.AddWithValue("@_createdBy", CreatedBy);

                    conn.Open();

                    int b = cmd.ExecuteNonQuery();
                    a += b;

                }
            }

        }
        if (a > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = 1 });
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Some Erroe Occured" });


    }




    [WebMethod(EnableSession = true)]
    public static string DdlBindCentre(string RoleID)
    {
        DataTable dt = StockReports.GetDataTable("SELECT cm.`CentreID`,cm.`CentreName` FROM center_master cm INNER JOIN f_centre_role cr ON cr.`CentreID` = cm.`CentreID` AND cr.isActive=1  AND cr.`RoleID`='" + RoleID + "' WHERE cm.`IsActive`=1");

        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt); ;
        }
    }

    [WebMethod(EnableSession = true)]
    public static string BindDepartmentBelong(string RoleID)
    {
        DataTable dt = StockReports.GetDataTable("SELECT uadm.`DeptBelongID`,uadm.`DeptBelong`,IF(uadr.`RoleID`,1,0) AS IsMaped FROM userauthorisationdeptmaster uadm LEFT JOIN userauthorisationdeptroles uadr ON uadr.`DebtBelongID`=uadm.`DeptBelongID` AND uadr.`RoleID`=" + RoleID + "  AND uadr.`IsActive`=1 WHERE uadm.`Active`=1");

        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = dt });
        }
    }



    [WebMethod(EnableSession = true)]
    public static string MapRoleToDeptBelong(int DeptBelong, int RoleID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {

            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "Delete from userauthorisationdeptroles where RoleID='" + RoleID + "' ");


            tranX.Commit();
        }
        catch (Exception ex)
        {
            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tranX.Dispose();
            con.Close();
            con.Dispose();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, Msg = "Some Erroe Occured" });
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();

        }


        string CreatedBy = HttpContext.Current.Session["ID"].ToString();


        int a = 0;

        using (MySqlConnection conn = Util.GetMySqlCon())
        {

            using (MySqlCommand cmd = new MySqlCommand("sp_map_role_to_deptbelong", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@_RoleID", RoleID);

                cmd.Parameters.AddWithValue("@_DeptBelongId", DeptBelong);


                cmd.Parameters.AddWithValue("@_createdBy", CreatedBy);

                conn.Open();

                a = cmd.ExecuteNonQuery();

            }
        }

        if (a > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, Msg = "Save SuccessFully" });
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, Msg = "Some Erroe Occured" });


    }





    [WebMethod(EnableSession = true)]
    public static string BindFloor(string Cid)
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID,NAME FROM floor_master WHERE CentreID=" + Cid + " ORDER BY SequenceNo");

        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            return "";
        }
    }


    [WebMethod(EnableSession = true)]
    public static string GetRoomByFloor(string RoleID, string FloorId, string Floor)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT ipd.IPDCaseTypeID,ipd.Name,IF(Rr.Role_ID IS NULL AND Rr.FloorID IS NULL,0,1)isExist FROM");
        sb.Append(" (SELECT ict.IPDCaseTypeID,ict.Name FROM ipd_case_type_master ict Inner Join room_master rm on rm.IPDCaseTypeID=ict.IPDCaseTypeID WHERE ict.isActive=1 AND rm.Floor='" + Floor + "' group by ict.IPDCaseTypeID) ipd");
        sb.Append(" LEFT JOIN ");
        sb.Append(" (SELECT Role_ID,IPDCaseTypeID,FloorID FROM f_RoomType_role WHERE Role_ID=" + RoleID + " AND FloorID=" + FloorId + " ) Rr");
        sb.Append(" ON Rr.IPDCaseTypeID=ipd.IPDCaseTypeID");
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });
        }
    }



    [WebMethod(EnableSession = true)]
    public static string GetFloorByCentre(string Cid)
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID,NAME FROM floor_master WHERE CentreID=" + Cid + " ORDER BY SequenceNo");

        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });
        }
    }


    [WebMethod(EnableSession = true)]
    public static string MapRoleToRoom(List<string> IpdCaseTypeID, string RoleID)
    {

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {

            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "Delete from f_RoomType_role where Role_ID='" + RoleID + "' ");


            tranX.Commit();
        }
        catch (Exception ex)
        {
            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }


        string CreatedBy = HttpContext.Current.Session["ID"].ToString();
        string IpAddress = HttpContext.Current.Request.UserHostAddress;
        int a = 0;
        foreach (string ICTD in IpdCaseTypeID)
        {
            string[] values = ICTD.Split(',');
            string Id = values[0].ToString();
            string FloorID = values[1].ToString();

            using (MySqlConnection conn = Util.GetMySqlCon())
            {

                using (MySqlCommand cmd = new MySqlCommand("MapRoleToRoom", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@_IPDCaseTypeID", Id);
                    cmd.Parameters.AddWithValue("@_RoleID", RoleID);


                    cmd.Parameters.AddWithValue("@_createdBy", CreatedBy);
                    cmd.Parameters.AddWithValue("@_IPAddress", IpAddress);

                    cmd.Parameters.AddWithValue("@_FloorID", FloorID);

                    conn.Open();

                    int b = cmd.ExecuteNonQuery();
                    a += b;

                }
            }

        }
        if (a > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = 1 });
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Some Erroe Occured" });


    }

    /// <summary>
    /// Map Role With lab department
    /// </summary>
    /// 

    [WebMethod]
    public static string BindLabDept(int RoleID)
    {

        string str = "SELECT om.Name,om.ObservationType_ID,IF(cr.ObservationType_ID IS NULL,'0','1')isExist FROM (SELECT * FROM observationtype_master )om LEFT JOIN (SELECT * FROM f_categoryrole WHERE roleID=" + RoleID + ") cr ON om.ObservationType_ID = cr.ObservationType_ID order by Name";

        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });
        }
    }




    [WebMethod(EnableSession = true)]
    public static string SaveRoleToLab(List<string> LabIdName, string RoleID, string RoleName)
    {

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {

            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "Delete from f_categoryrole where RoleID='" + RoleID + "'");

            foreach (string li in LabIdName)
            {
                string[] values = li.Split(',');
                string Id = values[0].ToString();
                string Name = values[1].ToString();
                String sb = "";
                sb = "Insert into f_categoryrole (ObservationType_ID,RoleID,ObservationTypeName,RoleName,CreatedBy,IPAddress)";
                sb += "values('" + Id + "'," + RoleID + ",";
                sb += "'" + Name + "','" + RoleName + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + All_LoadData.IpAddress() + "')";
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb);

            }

            tranX.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = 1 });
        }
        catch (Exception ex)
        {
            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Some Erroe Occured" });
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }



    }


    /// <summary>
    /// panel Group
    /// </summary>
    /// 

    [WebMethod]
    public static string GetCentreWithPanelGroupMappings(string RoleID)
    {

        string str = "SELECT cm.`CentreName` ,cm.`CentreID`,IFNULL(crp.PanelGroupID,0) AS PanelGroupID,GROUP_CONCAT(pg.`PanelGroup`) AS PanelGroup  FROM center_master cm  INNER JOIN f_centre_role cr ON cr.`CentreID` = cm.`CentreID` AND cr.isActive=1  LEFT JOIN f_centre_role_panelgroup_mapping crp ON crp.`CentreID`=cr.`CentreID` AND crp.`RoleID`=cr.`RoleID` AND crp.`isActive`=1  LEFT JOIN f_panelgroup pg ON FIND_IN_SET(pg.`PanelGroupID`,crp.`PanelGroupID`)   WHERE cm.`IsActive`=1  AND cr.`RoleID`='" + RoleID + "'   GROUP BY cr.`CentreID` ORDER BY cm.`CentreName`";
        DataTable dt = StockReports.GetDataTable(str);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }


    [WebMethod(EnableSession = true)]
    public static string SaveRoleWiseCentrePanelGroup(string RoleID, List<mappedRolesWisePanelGroups> MappedRolesWisePanelGroup)
    {


        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var userID = HttpContext.Current.Session["ID"].ToString();


        try
        {

            StringBuilder sqlCMD = new StringBuilder();


            for (int i = 0; i < MappedRolesWisePanelGroup.Count; i++)
            {

                MappedRolesWisePanelGroup[i].createdBy = userID;

                sqlCMD = new StringBuilder("UPDATE  f_centre_role_panelgroup_mapping  SET  isActive=0,UpdatedBy=@createdBy,UpdatedDateTime=now()  WHERE CentreID=@centreID AND isActive=1 AND RoleID=@roleID ");
                excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, MappedRolesWisePanelGroup[i]);

                if (MappedRolesWisePanelGroup[i].PanelGroupIDs != string.Empty)
                {
                    sqlCMD = new StringBuilder("INSERT INTO f_centre_role_panelgroup_mapping(RoleID,CentreID,PanelGroupID,CreatedBy) VALUES (@roleID,@centreID,@PanelGroupIDs,@createdBy)");
                    excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, MappedRolesWisePanelGroup[i]);
                }
            }



            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });

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

    public class roles
    {
        public int RoleID { get; set; }
        public string RoleName { get; set; }
        public string DepartmentLedgerNumber { get; set; }
        public int IsDepartment { get; set; }
        public int IsUniversal { get; set; }
        public int IsUniversalType { get; set; }
        public string menuFor { get; set; }
        public int IsStore { get; set; }
        public int IsGeneral { get; set; }
        public int IsMedical { get; set; }
        public string TypeName { get; set; }
        public int formatID { get; set; }
        public string InitialCharacter { get; set; }
        public string FinYear { get; set; }
        public int chkFinancialYear { get; set; }
        public string Separator1 { get; set; }
        public string Separator2 { get; set; }
        public string Length { get; set; }
        public string FormatPreview { get; set; }
        public string menuForText { get; set; }
        public string TextLength { get; set; }
    }
    public class mappedRolesWisePanelGroups
    {
        public int centreID { get; set; }
        public string roleID { get; set; }
        public string PanelGroupIDs { get; set; }
        public string createdBy { get; set; }
    }

}