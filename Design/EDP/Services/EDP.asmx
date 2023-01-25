<%@ WebService Language="C#" Class="EDP" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Script;
using System.Collections.Generic;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;
using System.IO;
using System.Linq;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
 [System.Web.Script.Services.ScriptService]
public class EDP  : System.Web.Services.WebService {
    
    [WebMethod(EnableSession = true)]
    public string GetFinYear(string date)
    {
        
        if (Convert.ToDateTime(date).ToString("dd-MMM").ToUpper() == "01-JAN")
        {
            return Convert.ToDateTime(date).Year.ToString().Substring(2, 2);
        }
        else
        {
            if (DateTime.Now > Convert.ToDateTime(date))
            {
                return Convert.ToDateTime(date).Year.ToString().Substring(2, 2) + "-" + Convert.ToDateTime(date).AddYears(1).Year.ToString().Substring(2, 2);
            }
            else
            {
                return Convert.ToDateTime(date).AddYears(-1).Year.ToString().Substring(2, 2) + "-" + Convert.ToDateTime(date).Year.ToString().Substring(2, 2); 
            }
            
        }
    }
    [WebMethod]
    public string bindSurgeryGroup()
    {
        DataTable dt = StockReports.GetDataTable("SELECT GroupID,GroupName FROM f_surgery_groupMaster WHERE IsActive=1");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return "";

    }
    [WebMethod(EnableSession = true)]
    public string thresholdLimitSave(string panelID, string thresholdAmount, string Active, string type, string RoomType, string oldRoomID, string oldPanelID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            int Count = 0;
            if (type == "Save")
                Count = Util.GetInt(MySqlHelper.ExecuteScalar(con,CommandType.Text, "Select Count(*) from f_thresholdlimit where PanelID=" + panelID + " and Room_Type = '" + RoomType + "'"));
            if (Count == 0)
            {
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "Delete FROM f_thresholdlimit where PanelID=" + oldPanelID + " and Room_Type = '" + oldRoomID + "' ");
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "Insert into f_thresholdlimit(PanelID,Amount,IsActive,UserID,Room_Type,IPAddress)values(" + panelID + ",'" + thresholdAmount + "','" + Active + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + RoomType + "','"+All_LoadData.IpAddress()+"')");
                tranX.Commit();
                return "1";
            }
            else
                return "2";
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
    public string thresholdLimitSearch()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT pm.Company_Name PanelName,ict.Name RoomName,tl.Room_Type,tl.Amount,IF(tl.IsActive=1,'Active','DeActive') ");
        sb.Append(" STATUS,tl.ID,pm.PanelID PanelID FROM f_thresholdlimit tl ");
        sb.Append(" INNER JOIN f_panel_Master pm ON pm.PanelID = tl.PanelID ");
        sb.Append(" INNER JOIN ipd_case_type_master ict ON ict.IPDCaseType_ID = tl.Room_Type ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    public string BindPackage()
    {

        DataTable dt = StockReports.GetDataTable("SELECT PackageID,pm.Name FROM package_master pm ORDER BY Name");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";

    }
    [WebMethod(EnableSession = true)]
    public string Bind_id_master_format()
    {

        DataTable dt = StockReports.GetDataTable("SELECT id.TypeID,id.TypeName,id.InitialChar,id.Separator1,IF(id.FinancialYearStart='0001-01-01','', "+
                      " DATE_FORMAT(id.FinancialYearStart,'%d-%b-%Y'))FinancialYearStart,id.Separator2,CAST(LPAD('1',id.TypeLength,0) AS CHAR)TypeLength,id.FormatPreview, "+
                      " cm.CentreName FROM id_master_format id INNER JOIN center_master cm ON cm.CentreID=id.CentreID WHERE id.IsActive=1");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";

    }
    
    
    [WebMethod(EnableSession = true)]
    public string SaveFormat(List<FormatDetail> FormatDetail)
    {
        
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            StringBuilder sb = new StringBuilder();

            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE id_master_format SET IsActive=0 WHERE TypeName='" + FormatDetail[0].Typename + "' AND CentreID=" + FormatDetail[0].CentreID + " ");
            sb.Append(" INSERT INTO id_master_format(TypeName,InitialChar,Separator1,FinancialYearStart,Separator2,TypeLength,UserID, ");
            sb.Append(" FormatPreview,chkFinancialYear,formatID,IsUniversal,DeptLedgerNo,CentreID)VALUES( ");
            sb.Append(" '" + FormatDetail[0].Typename + "','" + FormatDetail[0].InitialChar + "',");
            sb.Append(" '" + FormatDetail[0].Separator1 + "','" + Convert.ToDateTime(FormatDetail[0].FinYear).ToString("yyyy-MM-dd") + "', ");
            sb.Append(" '" + FormatDetail[0].Separator2 + "','" + FormatDetail[0].Length + "',");
            sb.Append(" '" + Session["ID"].ToString() + "','" + FormatDetail[0].FormatPreview + "', ");
            sb.Append(" '" + FormatDetail[0].chkFinancialYear + "','" + FormatDetail[0].formatID + "','1', ");
            if (FormatDetail[0].formatID == 4 || FormatDetail[0].formatID == 5 || FormatDetail[0].formatID == 11 || FormatDetail[0].formatID == 15)
                sb.Append(" 'LSHHI57' )");
            else if (FormatDetail[0].formatID == 6 || FormatDetail[0].formatID == 14)
                sb.Append(" 'LSHHI18' )");
            else if (FormatDetail[0].formatID == 7 || FormatDetail[0].formatID == 13)
                sb.Append(" 'LSHHI17' )");
            else if (FormatDetail[0].formatID == 8 )
                sb.Append(" 'LSHHI142' )");
            else               
            sb.Append(" ''");
            sb.Append(" ," + FormatDetail[0].CentreID + ")");
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());
            
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
    public string SavePackage(object Packageinfo, List<PackageItemDetail> ItemDetail, List<PackageDoctorVisti> DoctorVisitDetail, int IsConsumablesAllow, int IsVaccinationAllow)
    {
        List<Package> packageinfo = new JavaScriptSerializer().ConvertToType<List<Package>>(Packageinfo);

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            string SubcategoryID = "select SubCategoryID from f_subcategorymaster where CategoryID = (select CategoryID from f_configrelation where ConfigID = 23 ) and active=1";
            SubcategoryID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, SubcategoryID));
            if (SubcategoryID.ToString() == "")
            {
                tranX.Rollback();
                return "2";

            }



            string PackageID = packageinfo[0].PackageID.Trim();
            if (PackageID == "")
            {
                int packageAlreadyExits = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM  package_master p WHERE TRIM(p.Name)='" + Util.GetString(packageinfo[0].PackageName) + "'"));

                if (packageAlreadyExits > 0)
                {
                    tranX.Rollback();
                    return "5";

                }
                Package_Master objPM = new Package_Master(tranX);
                objPM.Name = packageinfo[0].PackageName;
                objPM.Description = "";
                objPM.CreaterID = Util.GetString(HttpContext.Current.Session["ID"]);
                objPM.Creator_Date = DateTime.Now;
                objPM.IsActive = 1;
                objPM.FromDate = Util.GetDateTime(packageinfo[0].FromDate);
                objPM.ToDate = Util.GetDateTime(packageinfo[0].ToDate);
                objPM.IsVaccinationAllow = IsVaccinationAllow;
                objPM.IsConsumablesAllow = IsConsumablesAllow;
                PackageID = objPM.Insert();


                ItemMaster objIMaster = new ItemMaster(tranX);
                objIMaster.Hospital_ID = "";
                objIMaster.TypeName = packageinfo[0].PackageName;
                objIMaster.Type_ID = Util.GetInt(PackageID);  //0;// PackageID;
                objIMaster.Description = "";
                objIMaster.SubCategoryID = SubcategoryID;
                objIMaster.IsEffectingInventory = "NO";
                objIMaster.IsExpirable = "No";
                objIMaster.BillingUnit = "";
                objIMaster.Pulse = "";
                objIMaster.IsTrigger = "YES";
                objIMaster.StartTime = Util.GetDateTime(packageinfo[0].FromDate);
                objIMaster.EndTime = Util.GetDateTime(packageinfo[0].ToDate);
                objIMaster.BufferTime = "0";
                objIMaster.IsActive = 1;
                objIMaster.QtyInHand = Util.GetDecimal(0);
                objIMaster.IsAuthorised = 1;
                objIMaster.ItemCode = packageinfo[0].ItemCode;
                objIMaster.IPAddress = All_LoadData.IpAddress();
                objIMaster.CreaterID = HttpContext.Current.Session["ID"].ToString();
                string ItemID = objIMaster.Insert().ToString();

            }
            else
            {
                int packageAlreadyExits = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM  package_master p WHERE p.PackageID<>'"+ PackageID +"' AND TRIM(p.Name)='" + Util.GetString(packageinfo[0].PackageName) + "'"));

                if (packageAlreadyExits > 0)
                {
                    tranX.Rollback();
                    return "5";

                }
                Package_Master objPM = new Package_Master(tranX);
                objPM.Name = packageinfo[0].PackageName;
                objPM.UpdateDate = DateTime.Now;
                objPM.LastUpdatedBy = Util.GetString(HttpContext.Current.Session["ID"]);
                objPM.IsActive = 1;
                objPM.FromDate = Util.GetDateTime(packageinfo[0].FromDate);
                objPM.ToDate = Util.GetDateTime(packageinfo[0].ToDate);
                objPM.PackageID = Util.GetString(PackageID);
                objPM.IsVaccinationAllow = IsVaccinationAllow;
                objPM.IsConsumablesAllow = IsConsumablesAllow;
                objPM.Update();

                //delete package Items & Doctor Visit Detail
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "DELETE FROM package_detail WHERE PackageID='" + PackageID + "'");

                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "DELETE FROM package_doctorvistidetail WHERE PackageID='" + PackageID + "'");

                string ItemID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT ItemID FROM package_master pm INNER JOIN f_itemmaster im ON pm.PackageID=im.Type_ID INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID=im.SubCategoryID INNER JOIN f_configrelation cf ON cf.CategoryID=sm.CategoryID WHERE cf.ConfigID=23 AND pm.PackageID='" + PackageID + "'"));

                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "update f_itemmaster set TypeName='" + packageinfo[0].PackageName + "', ItemCode='" + packageinfo[0].ItemCode + "',IsActive='" + packageinfo[0].Active + "' WHERE ItemID='" + ItemID + "'");
            }




            //insert package item (lab,pro & other)
            Package_Detail objDetail = new Package_Detail(tranX);
            for (int i = 0; i < ItemDetail.Count; i++)
            {
                objDetail.PackageID = PackageID;
                objDetail.ItemID = ItemDetail[i].ItemID;
                objDetail.InvestigationID = ItemDetail[i].InvestigationID;
                objDetail.Quantity = ItemDetail[i].Quantity;
                objDetail.Insert();
            }
            //insert DoctorVisitDetail
            Package_DoctorVistiDetail objVistiDetail = new Package_DoctorVistiDetail(tranX);
            for (int i = 0; i < DoctorVisitDetail.Count; i++)
            {
                objVistiDetail.PackageID = PackageID;
                objVistiDetail.SubCategoryID = DoctorVisitDetail[i].SubCategoryID;
                objVistiDetail.DocDepartmentID = DoctorVisitDetail[i].DocDepartmentID;
                objVistiDetail.DoctorID = DoctorVisitDetail[i].DoctorID;
                objVistiDetail.Insert();
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
    public string truncateTransaction()
    {
        
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

        DataTable transactionTable = MySqlHelper.ExecuteDataset(con,CommandType.Text, "SELECT table_name  FROM table_master WHERE Table_Type ='Transaction'").Tables[0];
            if (transactionTable.Rows.Count > 0)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "SET FOREIGN_KEY_CHECKS=0");
                for (int i = 0; i < transactionTable.Rows.Count; i++)
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "truncate table " + transactionTable.Rows[i]["table_name"].ToString() + " ");

                }
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM f_ledgermaster WHERE GroupID  in ('PTNT') ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "SET FOREIGN_KEY_CHECKS=1");
            }

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE id_master SET MaxID=0 WHERE Table_Type='Transaction' ");
           
            tnx.Commit();
            deleteFolder();
            LoadCacheQuery.dropAllCache();
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
            StockReports.ExecuteDML("SET FOREIGN_KEY_CHECKS=1");
            tnx.Dispose();
            con.Dispose();
            con.Close();
        }
    }
    
    
    
    [WebMethod]
    public string truncateClientTransaction()
    {
        
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
        DataTable transactionTable = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT table_name  FROM table_master WHERE Table_Type ='Master' AND TypeOfMaster ='Client' ").Tables[0];
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "SET FOREIGN_KEY_CHECKS=0");
            for (int i = 0; i < transactionTable.Rows.Count; i++)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "truncate table " + transactionTable.Rows[i]["table_name"].ToString() + " ");

            }
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "SET FOREIGN_KEY_CHECKS=1");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM employee_hospital WHERE EmployeeID <>'EMP001'");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM employee_master WHERE EmployeeID <>'EMP001'");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM f_login WHERE EmployeeID <>'EMP001'");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM f_panel_master WHERE PanelID <>1");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM f_ledgermaster WHERE GroupID ='DOC' ");

            tnx.Commit();
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
            //SET FOREIGN_KEY_CHECKS=0
            StockReports.ExecuteDML("SET FOREIGN_KEY_CHECKS=1");
            tnx.Dispose();
            con.Dispose();
            con.Close();
        }
    }
    public static void deleteFolder()
    {
        if (Directory.Exists(HttpContext.Current.Server.MapPath("~/Design/Doctor/DoctorSignature")))
            Directory.Delete(HttpContext.Current.Server.MapPath("~/Design/Doctor/DoctorSignature"), true);
        if (Directory.Exists(HttpContext.Current.Server.MapPath("~/HISDocuments")))
            Directory.Delete(HttpContext.Current.Server.MapPath("~/HISDocuments"),true);       
        if (Directory.Exists(HttpContext.Current.Server.MapPath("~/PatientPhoto")))
            Directory.Delete(HttpContext.Current.Server.MapPath("~/PatientPhoto"), true);
        if (Directory.Exists(HttpContext.Current.Server.MapPath("~/DepartmentLogo")))
            Directory.Delete(HttpContext.Current.Server.MapPath("~/DepartmentLogo"),true);
        if (Directory.Exists(HttpContext.Current.Server.MapPath("~/Design/Lab/Signature")))
            Directory.Delete(HttpContext.Current.Server.MapPath("~/Design/Lab/Signature"), true);
        if (Directory.Exists(HttpContext.Current.Server.MapPath("~/QuotationDocument")))
            Directory.Delete(HttpContext.Current.Server.MapPath("~/QuotationDocument"), true);
        if (Directory.Exists(HttpContext.Current.Server.MapPath("~/Design/CPOE/DocDepartmentLogo")))
            Directory.Delete(HttpContext.Current.Server.MapPath("~/Design/CPOE/DocDepartmentLogo"), true);
        if (Directory.Exists(HttpContext.Current.Server.MapPath("~/Design/HelpDesk/SupportAttachment")))
            Directory.Delete(HttpContext.Current.Server.MapPath("~/Design/HelpDesk/SupportAttachment"), true);
        if (Directory.Exists(HttpContext.Current.Server.MapPath("~/Design/OPD/Signature")))
            Directory.Delete(HttpContext.Current.Server.MapPath("~/Design/OPD/Signature"), true);
        if (Directory.Exists(HttpContext.Current.Server.MapPath("~/Design/Payroll/Documents")))
            Directory.Delete(HttpContext.Current.Server.MapPath("~/Design/Payroll/Documents"), true);
        if (Directory.Exists(HttpContext.Current.Server.MapPath("~/Design/Payroll/Resume")))
            Directory.Delete(HttpContext.Current.Server.MapPath("~/Design/Payroll/Resume"), true);
        if (Directory.Exists(HttpContext.Current.Server.MapPath("~/Design/Store/Signature")))
            Directory.Delete(HttpContext.Current.Server.MapPath("~/Design/Store/Signature"), true);
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
    public string bindMenu(string RoleID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select distinct(mm.MenuName)MenuName,mm.ID MenuID from f_file_role fr inner join f_filemaster fm");
        sb.Append(" on fr.UrlID = fm.ID inner join f_menumaster mm on fm.MenuID = mm.ID ");
        sb.Append(" LEFT JOIN f_role_menu_Sno rsm ON rsm.MenuID=fm.MenuID AND rsm.RoleID=fr.RoleID  where fr.Active = 1  and fm.Active=1 and fr.RoleID =" + RoleID + " order by rsm.SNo,mm.menuname");

       
      DataTable  dt = StockReports.GetDataTable(sb.ToString());

      if (dt.Rows.Count > 0)
          return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
      else
          return "";
    }

    [WebMethod(EnableSession=true)]
    public string UpdateMenu(List<MenuData> menu)
    {
       
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " DELETE FROM f_role_menu_Sno WHERE RoleID=" + menu[0].RoleID + " ");

            for (int i = 0; i < menu.Count; i++)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Insert INTO f_role_menu_Sno(RoleID,MenuID,SNo,UserID) VALUES(" + menu[i].RoleID + "," + menu[i].MenuID + "," + menu[i].SNo + ",'"+HttpContext.Current.Session["ID"].ToString()+"' )");

            }
            tnx.Commit();
            return "1";

        }
        
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
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
    [WebMethod]
    public string bindLoadMenu()
    {
        DataTable dt = StockReports.GetDataTable("select ID,MenuName from f_menumaster where active = 1 order by MenuName");
       
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod]
    public string LoadAvailMenu(string RoleID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select distinct(mm.MenuName) from f_file_role fr inner join f_filemaster fm");
        sb.Append(" on fr.UrlID = fm.ID inner join f_menumaster mm on fm.MenuID = mm.ID ");
        sb.Append("LEFT JOIN f_role_menu_Sno rsm ON rsm.MenuID=fm.MenuID AND rsm.RoleID=fr.RoleID  ");
        sb.Append(" where fr.Active = 1 and fr.RoleID =" + RoleID + " ORDER BY rsm.SNo,mm.menuname");

       
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        string str = string.Empty;

        foreach (DataRow dr in dt.Rows)
            if (str != string.Empty)
                str += " , " + Util.GetString(dr[0]);
            else
                str = Util.GetString(dr[0]);

        return str;
    }

    [WebMethod]
    public string BindAvailRight(string RoleID, string MenuId)
    {
         StringBuilder sb = new StringBuilder();
         sb.Append(" select CONCAT(fm.DispName,'(',fm.Description,')')FileName,FM.Id from f_filemaster FM inner join f_file_Role Fr on FM.Id=Fr.urlid and Fr.RoleID=" + RoleID + " and fm.menuid=" + MenuId + " and Fr.Active=1 order by Fr.SNo ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
        
    }

    [WebMethod]
    public string BindPage(string LoginType, string MenuId)
    {
         StringBuilder sb = new StringBuilder();
        sb.Append("select t1.FileName,t1.id from ( select CONCAT(fm.DispName,'(',fm.Description,')')FileName,fm.id from f_filemaster fm inner join f_MenuMaster mm on fm.menuid=mm.id");
        sb.Append(" where fm.Active = 1 and mm.Active = 1  and FM.MenuId=" + MenuId);
        sb.Append(" )t1 left join ( select fm.DispName,fm.id from f_filemaster fm inner join f_file_role fr on fm.ID = fr.UrlID");
        sb.Append("  inner join f_rolemaster rm on fr.RoleID = rm.ID where fm.Active = 1 and fr.Active = 1 ");
        sb.Append(" and rm.ID = " + LoginType + " and FM.MenuId=" + MenuId + ")t2 on t1.id = t2.id where t2.id is null order by T1.FileName");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";

    }
    [WebMethod(EnableSession = true)]
    public string RoleUpdate(List<Role> Data)
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
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE f_file_Role SET Active=0 WHERE UrlID=" + Data[i].URLId + " AND RoleID=" + Data[i].RoleID + "");


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
    public string RoleInsert(List<Role> Data)
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


                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "call InsertRight(" + Util.GetString(Data[i].URLId) + "," + Data[i].RoleID + ")");

                    
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
    
    [WebMethod]
    public string bindBank(string BankName,string Type)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT Bank_ID,BankName,BankCutPercentage, IsActive FROM f_bank_master where Bank_ID<>'' ");
        if (BankName != "")
            sb.Append(" AND BankName LIKE '"+BankName+"%'");
        if (Type != "2")
            sb.Append(" AND IsActive =" + Type + " ");
        DataTable bank = StockReports.GetDataTable(sb.ToString());
        if (bank.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(bank);
        else
            return "";
  
    }
    [WebMethod(EnableSession = true, Description = "Save Bank Name")]
    public string SaveBank(string BankName, string BankcutPer)
    {
        int count = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM f_bank_master WHERE BankName='" + BankName.Trim() + "' "));
        if (count > 0)
            return "2";
        
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO f_bank_master(BankName,CreatedBy,IPAddress,BankCutPercentage) VALUES('" + BankName + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + All_LoadData.IpAddress() + "'," + Util.GetDecimal(BankcutPer) + ")");
                tnx.Commit();
                LoadCacheQuery.dropCache("Bank");
                LoadCacheQuery.DropCentreWiseCache();//
                return "1";
            }

            catch (Exception ex)
            {
                tnx.Rollback();
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
                return "0";

            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }
    }
    [WebMethod(EnableSession = true, Description = "Update Bank Name")]
    public string UpdateBank(object Data)
    {
        List<bankMaster> dataItem = new JavaScriptSerializer().ConvertToType<List<bankMaster>>(Data);
        int len = dataItem.Count;

        if (len > 0)
        {
            
            
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                for (int i = 0; i < len; i++)
                {

                int count = Util.GetInt(MySqlHelper.ExecuteScalar(con,CommandType.Text, " SELECT COUNT(*) FROM f_bank_master WHERE BankName='" + dataItem[i].BankName + "' AND Bank_ID != '" + Util.GetInt(dataItem[i].BankID) + "' "));
                    if (count > 0)
                    {
                        return "2";

                    }

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_bank_master set BankName='" + dataItem[i].BankName + "',IsActive='" + Util.GetInt(dataItem[i].IsActive) + "',BankCutPercentage=" + Util.GetDecimal(dataItem[i].BankCutPer) + " Where Bank_ID = '" + Util.GetInt(dataItem[i].BankID) + "' ");
                        
                }



                tnx.Commit();
                LoadCacheQuery.dropCache("Bank");
                LoadCacheQuery.DropCentreWiseCache();//
                return "1";
            }

            catch (Exception ex)
            {
                tnx.Rollback();
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
                return "";

            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }

        }
        else
        {
            return "";
        }

    }
    
    [WebMethod(EnableSession = true, Description = "Update Patient Registration")]
    public string UpdateRegistration(object Data)
    {
        List<Patient_Master> dataReg = new JavaScriptSerializer().ConvertToType<List<Patient_Master>>(Data);
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" UPDATE Patient_master SET title='" + dataReg[0].Title.Trim() + "',PfirstName='" + dataReg[0].PFirstName.Trim() + "',PLastName='" + dataReg[0].PLastName.Trim() + "',PName='" + dataReg[0].PFirstName.Trim() + " " + dataReg[0].PLastName.Trim() + "', ");
            sb.Append(" City='" + dataReg[0].City.Trim() + "',Mobile='" + dataReg[0].Mobile.Trim() + "',Email='" + dataReg[0].Email.Trim() + "',House_No='" + dataReg[0].House_No.Trim() + "' , ");
            sb.Append(" Employer='" + dataReg[0].Employer.Trim() + "' ,Gender ='" + dataReg[0].Gender.Trim() + "',");
            if (dataReg[0].Age != "")
            {
                sb.Append(" Age='" + dataReg[0].Age.Trim() + "',");
            }
            else
            {
                sb.Append(" DOB= '" + dataReg[0].DOB.ToString("yyyy-MM-dd") + "' , ");
                sb.Append(" Age='" + StockReports.ExecuteScalar("Select Get_Age('" + dataReg[0].DOB.ToString("yyyy-MM-dd") + "')") + "' ,");

            }
            sb.Append(" occupation='" + dataReg[0].Occupation.Trim() + "',Country='" + dataReg[0].Country.Trim() + "',  ");
            if (dataReg[0].Ethnicity.Trim() != "")
                sb.Append(" Ethnicity='" + dataReg[0].Ethnicity.Trim() + "' ,");
            if (dataReg[0].LanguageSpoken.Trim() != "")
                sb.Append(" LanguageSpoken='" + dataReg[0].LanguageSpoken.Trim() + "', ");
            if (dataReg[0].ReligiousAffiliation.Trim() != "")
                sb.Append(" ReligiousAffiliation='" + dataReg[0].ReligiousAffiliation.Trim() + "',");
            if (dataReg[0].PlaceOfBirth.Trim() != "")
                sb.Append(" PlaceOfBirth='" + dataReg[0].PlaceOfBirth.Trim() + "',");
            
                sb.Append(" Relation='" + dataReg[0].Relation.Trim() + "',RelationName='" + dataReg[0].RelationName.Trim() + "', ");
                sb.Append(" LastUpdatedBy = '" + Session["ID"].ToString() + "',UpdateDate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',IpAddress = '" + Util.GetString(All_LoadData.IpAddress()) + "' WHERE PatientID='" + dataReg[0].PatientID.Trim() + "'");

            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());

            tranX.Commit();
            return "1";
        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tranX.Rollback();
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
    public string LoadObservationTypes(string RoleID)
    {
        string str = "SELECT om.Name,om.ObservationType_ID,IF(cr.ObservationType_ID IS NULL,'false','true')isExist FROM (SELECT * FROM observationtype_master )om LEFT JOIN (SELECT * FROM f_categoryrole WHERE roleID=" + RoleID + ") cr ON om.ObservationType_ID = cr.ObservationType_ID order by Name";

        DataTable dt = StockReports.GetDataTable(str.ToString());
        if(dt.Rows.Count>0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod]
    public string SaveObservationTypes(string[] Items, string[] Values, string RoleID, string RoleName)
    {
        string sb = "";
        if (Items.Length > 0)
        {

            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "Delete from f_categoryrole where RoleID='" + RoleID + "'");
                for (int i = 0; i < Items.Length; i++)
                {
                    sb = "Insert into f_categoryrole (ObservationType_ID,RoleID,ObservationTypeName,RoleName)";
                    sb += " values('" + Values[i].ToString() + "'," + RoleID + ",";
                    sb += "'" + Items[i].ToString() + "','" + RoleName + "')";
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb);
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

   
    [WebMethod]
    public string bindDisAppoval(string ApprovalType, string Type)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT ID,ApprovalType,IsActive FROM f_discountapproval where 1=1 ");
        if (ApprovalType != "")
            sb.Append(" AND ApprovalType LIKE '" + ApprovalType + "%' ");
        if (Type != "2")
            sb.Append(" AND IsActive =" + Type + " ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";

    }
    [WebMethod(EnableSession = true, Description = "Save Discount Approval Name")]
    public string saveDiscountApproval(string ApprovalType)
    {
        int count = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM f_discountapproval WHERE ApprovalType='" + ApprovalType.Trim() + "' "));
        if (count > 0)
            return "2";

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO f_discountapproval(ApprovalType) VALUES('" + ApprovalType.Trim() + "')");
            tnx.Commit();

            return "1";
        }

        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    
    [WebMethod(EnableSession = true, Description = "Update Discount Approval Name")]
    public string UpdateApprovalType(object Data)
    {
        List<ApprovalTypeMaster> dataItem = new JavaScriptSerializer().ConvertToType<List<ApprovalTypeMaster>>(Data);
        int len = dataItem.Count;

        if (len > 0)
        {


            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                for (int i = 0; i < len; i++)
                {

                    int count = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM f_discountapproval WHERE ApprovalType='" + dataItem[i].ApprovalType + "' AND ID != '" + Util.GetInt(dataItem[i].ID) + "' "));
                    if (count > 0)
                    {
                        return "2";

                    }

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_discountapproval set ApprovalType='" + dataItem[i].ApprovalType + "',IsActive='" + Util.GetInt(dataItem[i].IsActive) + "' Where ID = '" + Util.GetInt(dataItem[i].ID) + "' ");

                }



                tnx.Commit();

                return "1";
            }

            catch (Exception ex)
            {
                tnx.Rollback();
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
                return "";

            }
            finally
            {
                tnx.Dispose();
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
    public string SaveAuthorizePage(List<FrameData> Data)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            int Count = Util.GetInt(StockReports.ExecuteScalar("Select Count(*) from user_pageauthorisation_master where URL='" + Data[0].URL + "'"));
            if (Count == 0)
            {
                string str = "Insert into user_pageauthorisation_master(PageName,URL,CreatedBy) " +
                    " values('" + Data[0].FileName + "', '" + Data[0].URL + "','" + HttpContext.Current.Session["ID"].ToString() + "')";
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
    public string BindNonRegisterPage(string Employee_ID , int RoleID)
    {
        string rtrn = "";
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT upm.ID,CONCAT(PageName,'(',upm.URL,')')PageName  FROM user_pageauthorisation_master upm LEFT JOIN user_pageauthorisation upa ON upa.MasterID=upm.ID AND upa.EmployeeID='" + Employee_ID + "'  AND upa.RoleID='" + RoleID + "' ");
        sb.Append(" WHERE if(upa.ID IS NULL,upa.ID IS NULL,upa.isactive='0') AND upm.IsActive='1' ORDER BY upm.PageName ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            return rtrn;
        }
        else
        {
            return rtrn;
        }
    }
    [WebMethod(EnableSession = true)]
    public string BindRegisterPage(string Employee_ID, int RoleID)
    {
        string rtrn = "";
        StringBuilder sb = new StringBuilder();
      sb.Append(" SELECT upa.MasterID,CONCAT(PageName,'(',URL,')')PageName FROM user_pageauthorisation upa INNER JOIN user_pageauthorisation_master upm ON upa.MasterID = upm.ID ");
      sb.Append(" WHERE upa.RoleID='" + RoleID  + "' AND upa.EmployeeID='" + Employee_ID + "' AND upa.IsActive='1' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            return rtrn;
        }
        else
        {
            return rtrn;
        }
    }
    [WebMethod(EnableSession = true)]
    public string InsertRegisterPage(List<InsertRole> Data)
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

                    int Count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM user_pageauthorisation where MasterID='" + Data[i].MasterId + "' AND RoleID='" + Data[i].RoleID + "' AND EmployeeID='" + Data[i].Employee_ID + "' "));
                    if (Count == 0)
                    {

                        string str = "Insert into user_pageauthorisation(MasterID,RoleID,EmployeeID,CreatedBy) " +
                  " values('" + Data[i].MasterId + "','" + Data[0].RoleID + "','" + Data[0].Employee_ID + "','" + HttpContext.Current.Session["ID"].ToString() + "')";
                        MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str);

                    }
                    else
                    {
                        MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE user_pageauthorisation SET IsActive=1,UpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdatedDate=now() WHERE MasterID='" + Data[i].MasterId + "' AND RoleID='" + Data[i].RoleID + "' and EmployeeID='" + Data[i].Employee_ID + "' ");
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
    public string NewRightUpdate(List<RightUpdate> Data)
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
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE user_pageauthorisation SET IsActive=0 WHERE MasterID='" + Data[i].MasterId + "' AND RoleID='" + Data[i].RoleID + "' and EmployeeID='" + Data[i].Employee_ID + "' ");
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
    [WebMethod(EnableSession = true, Description = "Save Pro Name")]

    public string SavePro(string ProName)
    {
        int count = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM f_pro_master WHERE ProName='" + ProName.Trim() + "' "));
        if (count > 0)
            return "E";

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            LoadCacheQuery.DropCentreWiseCache();//
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO f_pro_master(ProName,CreatedBy,IPAddress) VALUES('" + ProName + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + All_LoadData.IpAddress() + "')");
            tnx.Commit();
            return Util.GetString(StockReports.ExecuteScalar("SELECT MAX(Pro_ID) FROM f_pro_master"));
            
        }

        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true, Description = "Update PRO DOctor Active Status")]
    public string UpdateMappedPRODoctor(object Data)
    {
        List<MapPRODoctor> dataItem = new JavaScriptSerializer().ConvertToType<List<MapPRODoctor>>(Data);
        int len = dataItem.Count;

        if (len > 0)
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                for (int i = 0; i < len; i++)
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE MappedProToReferDoctor set IsActive='" + Util.GetInt(dataItem[i].IsActive) + "',UpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdateDate=NOW() Where Pro_ID = '" + Util.GetInt(dataItem[i].ProID) + "' and ReferDoctorID='" + dataItem[i].RefDocID + "' ");

                }
                tnx.Commit();
                return "1";
            }

            catch (Exception ex)
            {
                tnx.Rollback();
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
                return "";

            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }

        }
        else
        {
            return "";
        }

    }
    [WebMethod]
    public string bindPro(string Type)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT Pro_ID,ProName,IsActive FROM f_Pro_master where Pro_ID<>'' ");     
        if (Type != "2")
            sb.Append(" AND IsActive =" + Type + " ");
        DataTable bank = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(bank);
    }
    [WebMethod]
    public string bindMappedProDoctor(string ProID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT mpr.PRO_ID,pm.ProName,mpr.ReferDoctorID,CONCAT(dr.title,'',dr.name)name,mpr.IsActive FROM MappedProToReferDoctor mpr INNER JOIN f_Pro_master pm ON mpr.PRO_ID=pm.Pro_ID INNER JOIN doctor_referal dr ON dr.DoctorID=mpr.ReferDoctorID ");
        sb.Append(" WHERE mpr.PRO_ID =" + ProID + " ");
        DataTable MappedPro = StockReports.GetDataTable(sb.ToString());
        if (MappedPro.Rows.Count > 0 && MappedPro != null)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(MappedPro);
        }
        else
            return "";
    }
    [WebMethod(EnableSession = true, Description = "Map PRO to Doctor")]
    public string SaveMapPRoToDoctor(List<MapPRODoctor> Data)
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
                    int Count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM MappedProToReferDoctor where PRO_ID='" + Data[i].ProID + "' and ReferDoctorID='" + Data[i].RefDocID + "' "));
                    if (Count == 0)
                    {
                        string str = "Insert into MappedProToReferDoctor(PRO_ID,ReferDoctorID,EnteredBy,EnteredDate) " +
                                 " values('" + Data[i].ProID + "','" + Data[i].RefDocID + "','" + HttpContext.Current.Session["ID"].ToString() + "',NOW())";
                        MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str);
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

    public class MapPRODoctor
    {
        public string ProID { get; set; }
        public string RefDocID { get; set; }
        public string IsActive { get; set; }
    }

    [WebMethod(EnableSession = true)]
    public string UpdatePRODetail(string EditPROID, string Name, string Active, string DeActive)
    {

        int ActiveStatus = 0;
        if (Active == "0")
            ActiveStatus = 0;
        else
            ActiveStatus = 1;
        
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {

                int count = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, " SELECT COUNT(*) FROM f_Pro_master WHERE proName='" + Name + "' AND Pro_ID != '" + Util.GetInt(EditPROID) + "' "));
                    if (count > 0)
                    {
                        return "0";

                    }

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_pro_master set proName='" + Name + "',IsActive='" + Util.GetInt(ActiveStatus) + "' Where Pro_ID = '" + Util.GetInt(EditPROID) + "' ");
                    tnx.Commit();
                   return "1";
            }

            catch (Exception ex)
            {
                tnx.Rollback();
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
                return "";

            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }  
    }
    
    
    
    
    
    
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string getPanel(string PanelGroup)
    {
        DataTable dtPanel = new DataTable();
        if (PanelGroup == "" || PanelGroup == "ALL")
            dtPanel = StockReports.GetDataTable("SELECT PanelID,Company_Name FROM f_panel_master");
        else
            dtPanel = StockReports.GetDataTable("Select Company_Name,PanelID from f_Panel_master where IsActive=1 and PanelGroup='" + PanelGroup + "' ORDER BY Company_Name");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtPanel);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string getPanelGroup()
    {
        DataTable dtPanelGroup = StockReports.GetDataTable("Select * from f_panelgroup where active=1 order by PanelGroup");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtPanelGroup);
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SearchPanelDiscount(string PanelID, string DateFrom, string ToDate, string PatientType)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT pnl.`PanelID`,pnl.`Company_Name` Panel,ps.`SubCatagoryID`,sm.Name SubGroup, ");
        sb.Append(" IFNULL(pd.Percentage,'0') OPDDiscount,IFNULL(pd.PercentageIPD,'0') IPDDiscount,(select CONCAT(Title,' ',Name) from Employee_Master where EmployeeID=pd.CreatedBy)CreatedBy, ");
        sb.Append(" DATE_FORMAT(pd.CreatedDate,'%d-%b-%Y')CreatedDate FROM `f_panel_master` pnl  ");
        sb.Append(" INNER JOIN `f_panel_services` ps ON pnl.`PanelID`=ps.`PanelID` ");
        sb.Append(" INNER JOIN `f_subcategorymaster` sm ON ps.`SubCatagoryID`=sm.SubCategoryID ");
        sb.Append(" LEFT JOIN `f_paneldisc` pd ON ps.`PanelID`=pd.`PanelID` AND ps.`SubCatagoryID`=pd.SubCategoryID AND pd.`IsActive`=1 ");
        sb.Append(" WHERE ps.`Active`=1 AND sm.Active=1 AND pnl.`PanelID`=" + PanelID + " GROUP BY ps.`SubCatagoryID` ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = "Panel Discount OPD/IPD";
            HttpContext.Current.Session["Period"] = "As on Date" ;
            return "1";
        }
        else
        {
            return "";
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SavePanelDiscount(object ExcelData)
    {
        List<PanelDiscount> dataPD = new JavaScriptSerializer().ConvertToType<List<PanelDiscount>>(ExcelData);
        
         MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {        
            StringBuilder sb = new StringBuilder();           
            for (int i = 0; i < dataPD.Count; i++)
            {
                if (Util.GetString(dataPD[i].OPDDiscount) != "" && Util.GetString(dataPD[i].IPDDiscount) != "" || Util.GetInt(dataPD[i].OPDDiscount) != 0 && Util.GetInt(dataPD[i].IPDDiscount) != 0)
                {
                    sb.Clear();
                    sb.Append(" Insert into f_panelDisc_backup(ItemID,CategoryID,SubCategoryID,PanelID,Percentage,CreatedBy,CreatedDate,DeactivatedBy) ");
                    sb.Append(" SELECT ItemID,CategoryID,SubCategoryID,PanelID,Percentage,CreatedBy,CreatedDate,'" + HttpContext.Current.Session["ID"].ToString() + "' ");
                    sb.Append(" from f_panelDisc WHERE SubCategoryID='" + Util.GetString(dataPD[i].SubCategoryID) + "' AND PanelID=" + Util.GetString(dataPD[i].PanelID) + " And IsActive=1 ");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                    sb.Clear();
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM  f_panelDisc where SubCategoryID='" + Util.GetString(dataPD[i].SubCategoryID) + "' AND PanelID=" + Util.GetInt(dataPD[i].PanelID) + " AND IsActive=1 ");
                    sb.Clear();
                    sb.Append(" Insert into f_panelDisc(ItemID,CategoryID,SubCategoryID,PanelID,Percentage,PercentageIPD,CreatedBy) ");
                    sb.Append(" SELECT im.`ItemID`,cm.`CategoryID`,sm.`SubCategoryID`," + Util.GetInt(dataPD[i].PanelID) + "," + Util.GetDecimal(dataPD[i].OPDDiscount) + "," + Util.GetDecimal(dataPD[i].IPDDiscount) + ",'" + HttpContext.Current.Session["ID"].ToString() + "' FROM `f_itemmaster` im ");
                    sb.Append(" INNER JOIN `f_subcategorymaster` sm ON im.`SubCategoryID`=sm.`SubCategoryID` ");
                    sb.Append(" INNER JOIN `f_categorymaster` cm ON sm.`CategoryID`=cm.`CategoryID` ");
                    sb.Append(" WHERE sm.SubCategoryID ='" + Util.GetString(dataPD[i].SubCategoryID) + "'     ");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                }
                           
            }
            tnx.Commit();
            return "1";
        }

        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public class DefaultPageMaster
    {
        public string UserID { get; set; }
        public int roleID { get; set; }
        public string pageURL { get; set; }
    }

    //public class DefaultPageMaster
    //{
        
    //    public List<DefaultPage> defaultPageList { get; set; }

    //}
    
    

    [WebMethod]
    public string SetRoleDefaultPage(string href,int roleID, string empID)
    {
        try
        {

            string pageURL = href; //StockReports.ExecuteScalar("SELECT upm.URL FROM user_pageauthorisation upa INNER JOIN user_pageauthorisation_master upm ON upa.MasterID = upm.ID WHERE upa.RoleID = " + roleID + " AND upa.Employee_ID = '" + empID + "' AND upa.IsActive = '1' AND upa.MasterID="+id);
            if (!string.IsNullOrEmpty(pageURL))
            {
                DefaultPageMaster defaultPageMaster = new DefaultPageMaster();
                defaultPageMaster.roleID=roleID;
                defaultPageMaster.UserID = empID;
                defaultPageMaster.pageURL = pageURL;
                    
                System.Xml.Serialization.XmlSerializer reader = new System.Xml.Serialization.XmlSerializer(typeof(List<DefaultPageMaster>));
                System.IO.StreamReader file = new System.IO.StreamReader(HttpContext.Current.Server.MapPath("~/Design/MenuData/Default/DefaultPageMaster.xml"));
                List<DefaultPageMaster> defaultPageMasterList = (List<DefaultPageMaster>)reader.Deserialize(file);
                file.Close();

                var isAlreadyExits= defaultPageMasterList.Where(i => (i.UserID == empID && i.roleID == roleID)).FirstOrDefault();
                if(isAlreadyExits==null)
                    defaultPageMasterList.Add(defaultPageMaster);
                else
                    defaultPageMasterList.Where(i => (i.UserID == empID && i.roleID == roleID)).FirstOrDefault().pageURL = pageURL;                
                
                System.Xml.Serialization.XmlSerializer serializer = new System.Xml.Serialization.XmlSerializer(typeof(List<DefaultPageMaster>));
                using (TextWriter writer = new StreamWriter(HttpContext.Current.Server.MapPath("~/Design/MenuData/Default/DefaultPageMaster.xml")))
                {
                    serializer.Serialize(writer, defaultPageMasterList);
                }

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully" });

            }
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Page Not Found"});
        }
        catch (Exception ex)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Error occurred, Please contact administrator", message = ex.Message });
            
        }
    }
      [WebMethod(EnableSession = true)]
    public string bindNewsTypeMasterDetails(string DateFrom, string DateTo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT DATE_FORMAT(nm.ValidFrom,'%d-%b-%Y')ValidFrom,DATE_FORMAT(nm.VaildTo,'%d-%b-%Y')VaildTo,nm.Sub as Subject,nm.Message, IF(nm.isImp=1,'Yes','No')Active, IF(nm.isImp=1,'1','0')IsActive, ");
    
        sb.Append("CONCAT(CONCAT(em.Title,em.Name))CreatedBy , ");
        sb.Append("DATE_FORMAT(nm.dtEntry,'%d-%b-%Y')DateTime , ");
        sb.Append("CONCAT(IFNULL((SELECT CONCAT(title,'',NAME) FROM employee_master WHERE employeeid=nm.EntryBy),''),' ',IFNULL(DATE_FORMAT(nm.dtEntry,'%d-%b-%Y'),''))LastUpdateBy,nm.NewsId,nm.imageurl_his As Image  ");
        sb.Append("FROM news_master nm  ");
        sb.Append("INNER JOIN employee_master em ON em.EmployeeID= nm.EntryBy ");
        if (DateFrom != "" || DateTo != "")
            sb.Append("AND nm.ValidFrom>='" + Util.GetDateTime(DateFrom).ToString("yyyy-MM-dd") + "' AND nm.VaildTo<='" + Util.GetDateTime(DateTo).ToString("yyyy-MM-dd") + "' ");
        //sb.Append(" Order By BagName ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod(EnableSession = true)]
    public string GetNewsMasterImageForPopUp(string NewsId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT NewsId,imageurl_his as Image ");
        sb.Append("FROM news_master nm   ");
        sb.Append("WHERE NewsId='" + NewsId + "'");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        //  string pathname = System.IO.Path.Combine(Resources.Resource.DocumentDriveIPAddress + Resources.Resource.DocumentDriveName + "\\" + Resources.Resource.DocumentFolderName + "\\BagImage\\" + dt.Rows[0]["BagName"].ToString() + "\\" + dt.Rows[0]["BagName"].ToString() + ".jpg");
        if (Util.GetString(dt.Rows[0]["Image"]) != "")
        {
            byte[] byteArray = File.ReadAllBytes(dt.Rows[0]["Image"].ToString());
            string base64 = Convert.ToBase64String(byteArray);
            dt.Rows[0]["Image"] = string.Format("data:image/jpg;base64,{0}", base64);
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true)]
    public string UpdateNewsMaster(string NewsId, string DateFrom, string DateTo, string Subject, string Details, string IsImportant)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var UserID = HttpContext.Current.Session["ID"].ToString();
            var IpAddress = HttpContext.Current.Request.UserHostAddress;
            var message = "";
            string str = "";
            string sqlCMD = "UPDATE news_master  SET ValidFrom = @DateFrom,VaildTo=@DateTo,Sub=@Subject,Message=@Details,dtEntry = Now(),isImp = @IsImportant WHERE NewsId = @ID;";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                DateFrom = Util.GetDateTime(DateFrom).ToString("yyyy-MM-dd"),
                DateTo = Util.GetDateTime(DateTo).ToString("yyyy-MM-dd"),
                Subject = Subject,
                Details = Details,
                IsImportant = IsImportant,
                ID = NewsId,
            });
            message = "Record Updated Successfully";
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}