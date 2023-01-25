<%@ WebService Language="C#" Class="UserPrivilege" %>
using System;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using System.Collections.Generic;
using MySql.Data.MySqlClient;
using System.Web.Script.Serialization;
using System.Security.Cryptography;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]

public class UserPrivilege : System.Web.Services.WebService
{

    [WebMethod]
    public string bindUserType()
    {
        DataTable dt = StockReports.GetDataTable("select Name,ID from Employee_Type_master where IsActive=1  order by Name ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
      
    }
    [WebMethod]
    public string bindEmployeeGroup()
    {
        DataTable dt = StockReports.GetDataTable("select Name,ID from Employee_Group_master where IsActive=1 order by Name");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
       
    }
    [WebMethod]
    public string bindPayrollDepartment()
    {
        DataTable dt = AllLoadDate_Payroll.dtDepartmentPayroll();
     
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
      
    }
    [WebMethod]
    public string bindPayrollDesignation()
    {
        DataTable dt = AllLoadDate_Payroll.dtDesignationPayroll();
       
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
       
    }
    [WebMethod]
    public string BindQualification()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("Select ID,Qualification from pay_qualification_master where ISActive=1"));
    }
    

    [WebMethod(EnableSession = true)]
    public string SaveEmployee(object EmployeeDetail)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            List<MSTEmployee> EmpData = new JavaScriptSerializer().ConvertToType<List<MSTEmployee>>(EmployeeDetail);
            string userID = HttpContext.Current.Session["ID"].ToString();
            string EmployeeID = "";
            MSTEmployee objMSTEmployee = new MSTEmployee(tnx);
            objMSTEmployee.Title = EmpData[0].Title;
            objMSTEmployee.Name = EmpData[0].Name;
            objMSTEmployee.House_No = EmpData[0].House_No;
            objMSTEmployee.Street_Name = EmpData[0].Street_Name;
            objMSTEmployee.Locality = EmpData[0].Locality;
            objMSTEmployee.City = EmpData[0].City;
            objMSTEmployee.PinCode = Util.GetInt(EmpData[0].PinCode);
            objMSTEmployee.PHouse_No = EmpData[0].PHouse_No;
            objMSTEmployee.PStreet_Name = EmpData[0].PStreet_Name;
            objMSTEmployee.PLocality = EmpData[0].PLocality;
            objMSTEmployee.PCity = EmpData[0].PCity;
            objMSTEmployee.PPinCode = Util.GetInt(EmpData[0].PPinCode);
            objMSTEmployee.FatherName = EmpData[0].FatherName;
            objMSTEmployee.MotherName = EmpData[0].MotherName;
            objMSTEmployee.ESI_No = EmpData[0].ESI_No;
            objMSTEmployee.EPF_No = EmpData[0].EPF_No;
            objMSTEmployee.PAN_No = EmpData[0].PAN_No;
            objMSTEmployee.Passport_No = EmpData[0].Passport_No;
            objMSTEmployee.DOB = Util.GetDateTime(EmpData[0].DOB);
            objMSTEmployee.Qualification = EmpData[0].Qualification;
            objMSTEmployee.Email = EmpData[0].Email;
            objMSTEmployee.Phone = Util.GetString(EmpData[0].Phone);
            objMSTEmployee.Mobile = EmpData[0].Mobile;
            objMSTEmployee.Blood_Group = EmpData[0].Blood_Group;
            objMSTEmployee.StartDate = Util.GetDateTime(EmpData[0].StartDate);
            objMSTEmployee.UserType_ID = Util.GetString(EmpData[0].UserType_ID);

            objMSTEmployee.Dept_ID = Util.GetString(EmpData[0].Dept_ID);
            objMSTEmployee.Dept_Name = Util.GetString(EmpData[0].Dept_Name);
            objMSTEmployee.Desi_Name = Util.GetString(EmpData[0].Desi_Name);
            objMSTEmployee.Desi_ID = Util.GetString(EmpData[0].Desi_ID);
            objMSTEmployee.Employee_Group_ID = Util.GetInt(EmpData[0].Employee_Group_ID);
            objMSTEmployee.DiscountPercent = Util.GetDecimal(EmpData[0].DiscountPercent);
            objMSTEmployee.Allowpartialpayment = Util.GetInt(EmpData[0].Allowpartialpayment);
            objMSTEmployee.Cadreid = Util.GetInt(EmpData[0].Cadreid);
            objMSTEmployee.TierID = Util.GetInt(EmpData[0].TierID);
            
            EmployeeID = objMSTEmployee.Insert();

            string sqlQuery = string.Empty;
            ExcuteCMD excuteCMD = new ExcuteCMD();
            sqlQuery = "UPDATE Employee_Master SET TabPosition=2 WHERE EmployeeID=@EmpID";
            excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
            {
                EmpID = EmployeeID
            });

            tnx.Commit();

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = EmployeeID });
        }
        catch (Exception ex)
        {
            ClassLog lg = new ClassLog();
            lg.errLog(ex);
            tnx.Rollback();
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
    public string GetSetCentre(string EmployeeId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT cm.CentreID,UPPER(cm.CentreName)CentreName,IF(ca.CentreAccess IS NULL,'FALSE','TRUE')CentreSet ");
        sb.Append(" FROM center_master cm  ");
        sb.Append(" LEFT JOIN centre_access ca ON ca.CentreAccess=cm.CentreID AND ca.EmployeeID='" + EmployeeId + "' AND  ca.IsActive=1 where cm.IsActive=1");
        sb.Append(" GROUP BY CentreName ORDER BY CentreName ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
       
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
     
    }

    [WebMethod(EnableSession = true)]
    public string UpdateCentre(string EmployeeID, string CentreID, Boolean IsChecked)
    {
        string result = "0";
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction MySqltrans = con.BeginTransaction();
        try
        {
            StringBuilder sb = new StringBuilder();
            if (IsChecked)
            {
                sb.Append("insert into centre_access(EmployeeID,CentreAccess,IsActive,UpdateDate) ");
                sb.Append("values('" + EmployeeID + "','" + CentreID + "','1','" + System.DateTime.Now.ToString("yyyy-MM-dd hh-mm-ss") + "')");
                MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, sb.ToString());

                sb = new StringBuilder();
                sb.Append("insert into employee_hospital(EmployeeID,CentreID,EnteryDatetime)");
                sb.Append("values('" + EmployeeID + "','" + CentreID + "',NOW())");
                MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, sb.ToString());

                result = "1";
            }
            else
            {
                MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, "delete from centre_access where EmployeeID='" + EmployeeID + "' AND CentreAccess='" + CentreID + "'");


                MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, "delete from employee_hospital where EmployeeID='" + EmployeeID + "' AND CentreID='" + CentreID + "'");



                result = "2";
            }
            MySqltrans.Commit();
            return result;
        }
        catch (Exception ex)
        {
            MySqltrans.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            MySqltrans.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public string GetSetRole(string EmployeeId, string CentreID)
    {
        string str = "SELECT RM.ID,UPPER(RM.roleName) RoleName,IF(FL.`RoleID` IS NULL,'FALSE','TRUE')RoleSet  FROM f_rolemaster RM " +
            " LEFT JOIN f_login FL ON FL.`RoleID`=RM.`ID` AND FL.EmployeeID='" + EmployeeId + "' AND FL.`CentreID`=" + CentreID + " " +
            "  WHERE RM.active=1 GROUP BY RoleName ORDER BY RoleName ";
        DataTable dt = StockReports.GetDataTable(str);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public string UpdateRole(string EmployeeID, string RoleID, string CentreID, Boolean IsChecked)
    {
        string result = "0";
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction MySqltrans = con.BeginTransaction();
        try
        {
            StringBuilder sb = new StringBuilder();
            if (IsChecked)
            {
                sb.Append("insert into f_login(RoleID,EmployeeID,UserName,Password,CentreID)");
                sb.Append("values(" + RoleID + ",'" + EmployeeID + "','mgr','itdose','" + CentreID + "')");
                MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, sb.ToString());
                result = "1";
            }
            else
            {
                MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, "delete from f_login where RoleID='" + RoleID + "' AND EmployeeID='" + EmployeeID + "' AND CentreID='" + CentreID + "'");
                result = "2";
            }
            MySqltrans.Commit();
            return result;
        }
        catch (Exception ex)
        {
            MySqltrans.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            MySqltrans.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public string BindRegisterPage(string EmployeeID, int RoleID, int CentreID)
    {
        string rtrn = "";
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT upm.ID,upm.DispName,upm.URLName,IFNULL(upa.ID,'') upa_ID  FROM f_filemaster upm LEFT JOIN user_pageaccess upa ON upa.UrlID=upm.ID AND upa.EmployeeID='" + EmployeeID + "'  AND upa.RoleID='" + RoleID + "' AND upa.CentreID='" + CentreID + "' ");
        sb.Append(" WHERE upm.Active='1' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        dt.Columns.Add("RowColour");
        dt.Columns.Add("Checked");
        if (dt.Rows.Count > 0)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (Util.GetString(dt.Rows[i]["upa_ID"]) == Util.GetString(""))
                {
                    dt.Rows[i]["RowColour"] = "LightBlue";
                    dt.Rows[i]["Checked"] = "false";
                }
                else
                {
                    dt.Rows[i]["RowColour"] = "AntiqueWhite";
                    dt.Rows[i]["Checked"] = "true";
                }
            }

            rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            return rtrn;
        }
        else
        {
            return rtrn;
        }
    }

    [WebMethod]
    public string GetUserAccess(string EmpId)
    {
        int count = 0;
        count = Util.GetInt(StockReports.ExecuteScalar("select count(*) from centre_access WHERE `EmployeeID`='" + EmpId + "'"));
        if (count > 0)
        {
            DataTable dt = StockReports.GetDataTable("CALL sp_useraccess('" + EmpId + "')");
            DataView dvrole = dt.AsDataView();
            if (EmpId != "EMP001")
            {
                dvrole.RowFilter = "RoleID<>'6'"; //for edp           
            }  
            return Newtonsoft.Json.JsonConvert.SerializeObject(dvrole.ToTable());
        }
        else
            return "";
    }

    [WebMethod]
    public string GetUserNames(string EmpId)
    {

        DataTable dt = StockReports.GetDataTable("select * from f_login WHERE `EmployeeID`='" + EmpId + "' AND Active=1 LIMIT 1");

        if (dt.Rows.Count>0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
       
        }
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false });

    }

    [WebMethod]
    public string NextTab(string EmpId)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction MySqltrans = con.BeginTransaction();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("Update Employee_Master set TabPosition=TabPosition+1 where EmployeeID='" + EmpId + "'");
            MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, sb.ToString());
            MySqltrans.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = EmpId });
        }
        catch (Exception ex)
        {
            MySqltrans.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
        finally
        {
            MySqltrans.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public string PreviousTab(string EmpId)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction MySqltrans = con.BeginTransaction();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" Update Employee_Master set TabPosition=TabPosition-1 where EmployeeID='" + EmpId + "'");
            MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, sb.ToString());
            MySqltrans.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = EmpId });
        }
        catch (Exception ex)
        {
            MySqltrans.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
        finally
        {
            MySqltrans.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    //[WebMethod]
    //public string GetRoleWisePages(string EmpId)
    //{
    //    int count = 0;
    //    count = Util.GetInt(StockReports.ExecuteScalar("select count(*) from centre_access WHERE `EmployeeID`='" + EmpId + "'"));
    //    if (count > 0)
    //    {
    //        StringBuilder sb = new StringBuilder();
    //        sb.Append(" SELECT rm.RoleName,mm.MenuName,fm.DispName,fr.UrlID,fr.RoleID,fm.URLName,fm.MenuID,IF(up.`ID` IS NULL,'false','true')Status FROM f_filemaster fm ");
    //        sb.Append(" INNER JOIN f_menumaster mm ON fm.`MenuID`=mm.`ID` ");
    //        sb.Append(" INNER JOIN  f_file_role fr ON fm.ID=fr.UrlID ");
    //        sb.Append(" INNER JOIN `f_rolemaster` rm ON fr.`RoleID`=rm.`ID` ");
    //        sb.Append(" INNER JOIN f_login fl ON fl.`RoleID`=rm.`ID` AND fl.`Active`=1 ");
    //        sb.Append(" LEFT JOIN user_pageaccess up ON up.`EmployeeID`=fl.`EmployeeID` AND up.`RoleID`=rm.`ID` AND up.`MenuID`=mm.`ID`  AND up.`UrlID`=fr.`UrlID` ");
    //        sb.Append(" WHERE fr.Active=1 AND fm.`Active`=1 AND fl.`EmployeeID`='" + EmpId + "' ");
    //        sb.Append(" ORDER BY rm.`RoleName`,mm.`MenuName`,fr.Sno ");
    //        DataTable dt = StockReports.GetDataTable(sb.ToString());
    //        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    //    }
    //    else
    //        return "";
    //}

    [WebMethod]
    public string GetRoleWisePages(string EmpId)
    {
        int count = 0;
        count = Util.GetInt(StockReports.ExecuteScalar("select count(*) from centre_access WHERE `EmployeeID`='" + EmpId + "'"));
        if (count > 0)
        {
            DataTable dt = StockReports.GetDataTable("CALL sp_userpageaccess('" + EmpId + "')");
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { Status = false, message = "" });
    }



    [WebMethod(EnableSession = true)]
    public string saveUserRoles(List<EmployeeAccess> data)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        string OldUserName = "";
        string OldPassword = "";

        try
        {
            ExcuteCMD excuteCMD = new ExcuteCMD();

            if (data[0].IsUpdateLogin == "0")
            {
                DataTable dt = excuteCMD.GetDataTable(tnx, "SELECT UserName,password FROM f_login WHERE  EmployeeID=@EmployeeID ", CommandType.Text, new { EmployeeID = data[0].EmployeeID });

                if (dt.Rows.Count > 0)
                {
                    OldUserName = dt.Rows[0]["UserName"].ToString();
                    OldPassword = dt.Rows[0]["password"].ToString();
                }
            }

            int COUNT = 0;
            excuteCMD.DML(tnx, con, "DELETE FROM f_login WHERE EmployeeID=@EmployeeID ", CommandType.Text, new { EmployeeID = data[0].EmployeeID });
            COUNT = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT count(*) FROM f_login WHERE UserName=@UserName AND EmployeeID<>@EmployeeID ", CommandType.Text, new { UserName = data[0].UserName, EmployeeID = data[0].EmployeeID }));
            if (COUNT == 0)
            {


                if (data[0].IsUpdateLogin == "1")
                {
                    data.ForEach(i =>
                        {
                            if (i.Status)
                            {
                                excuteCMD.DML(tnx, con, "insert into f_login(RoleID,EmployeeID,UserName,Password,CentreID) Values(@RoleID, @EmployeeID, @UserName, @Password, @CentreID)", CommandType.Text, new
                                {
                                    RoleID = i.RoleID,
                                    EmployeeID = i.EmployeeID,
                                    UserName = i.UserName,
                                    Password = EncryptPassword(i.Password),
                                    CentreID = i.CenterID
                                });
                            }
                        });
                }
                else if (data[0].IsUpdateLogin == "0")
                {
                    data.ForEach(i =>
                    {
                        if (i.Status)
                        {
                            excuteCMD.DML(tnx, con, "insert into f_login(RoleID,EmployeeID,UserName,Password,CentreID) Values(@RoleID, @EmployeeID, @UserName, @Password, @CentreID)", CommandType.Text, new
                            {
                                RoleID = i.RoleID,
                                EmployeeID = i.EmployeeID,
                                UserName = OldUserName,
                                Password = OldPassword,
                                CentreID = i.CenterID
                            });
                        }
                    });
                }


            }
            else
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "This User Name is Exist. Please Use Another", errorMessage = "" });
            }
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Roles Saved Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", errorMessage = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public string GetEmployee(string EmployeeID)
    {
        DataTable dt = StockReports.GetDataTable("SELECT emp.`Title`,emp.`Name`,DATE_FORMAT(emp.`DOB`,'%Y-%m-%d')DOB,emp.`BloodGroup`,emp.`Category`,emp.`City`,emp.`Email` "
                                                  + " ,emp.`EmployeeID`,emp.`EPF_No`,emp.`ESI_No`,emp.`FatherName`,emp.`House_No`,emp.`ID`,emp.`IsActive`,emp.`Locality`"
                                                  + " ,emp.`Mobile`,emp.`MotherName`,emp.`PAN_No`,emp.`PassportNo`,emp.`PayrollEmployeeID`,emp.`PCity`,emp.`Phone`,emp.`PHouse_No`"
                                                  + " ,emp.`Pincode`,emp.`PLocality`,emp.`PPincode`,emp.`PStreet_Name`,emp.`Qualification`,DATE_FORMAT(emp.`StartDate`,'%Y-%m-%d')StartDate,emp.UserType_ID,emp.`Street_Name`,round(emp.Eligible_DiscountPercent,2) DiscountPercent,emp.Allowpartialpayment,emp.Dept_ID,emp.Desi_ID,emp.Cadreid,emp.TierID "
                                                  + " FROM `employee_master` emp WHERE `EmployeeID`='" + EmployeeID + "'");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });

    }

    [WebMethod(EnableSession = true)]
    public string UpdateEmployee(object EmployeeDetail)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            List<MSTEmployee> EmpData = new JavaScriptSerializer().ConvertToType<List<MSTEmployee>>(EmployeeDetail);
            string userID = HttpContext.Current.Session["ID"].ToString();
            MSTEmployee objMSTEmployee = new MSTEmployee(tnx);
            objMSTEmployee.Title = EmpData[0].Title;
            objMSTEmployee.Name = EmpData[0].Name;
            objMSTEmployee.House_No = EmpData[0].House_No;
            objMSTEmployee.Street_Name = EmpData[0].Street_Name;
            objMSTEmployee.Locality = EmpData[0].Locality;
            objMSTEmployee.City = EmpData[0].City;
            objMSTEmployee.PinCode = Util.GetInt(EmpData[0].PinCode);
            objMSTEmployee.PHouse_No = EmpData[0].PHouse_No;
            objMSTEmployee.PStreet_Name = EmpData[0].PStreet_Name;
            objMSTEmployee.PLocality = EmpData[0].PLocality;
            objMSTEmployee.PCity = EmpData[0].PCity;
            objMSTEmployee.PPinCode = Util.GetInt(EmpData[0].PPinCode);
            objMSTEmployee.FatherName = EmpData[0].FatherName;
            objMSTEmployee.MotherName = EmpData[0].MotherName;
            objMSTEmployee.ESI_No = EmpData[0].ESI_No;
            objMSTEmployee.EPF_No = EmpData[0].EPF_No;
            objMSTEmployee.PAN_No = EmpData[0].PAN_No;
            objMSTEmployee.Passport_No = EmpData[0].Passport_No;
            objMSTEmployee.DOB = Util.GetDateTime(EmpData[0].DOB);
            objMSTEmployee.Qualification = EmpData[0].Qualification;
            objMSTEmployee.Email = EmpData[0].Email;
            objMSTEmployee.Phone = Util.GetString(EmpData[0].Phone);
            objMSTEmployee.Mobile = EmpData[0].Mobile;
            objMSTEmployee.Blood_Group = EmpData[0].Blood_Group;
            objMSTEmployee.StartDate = Util.GetDateTime(EmpData[0].StartDate);
            objMSTEmployee.UserType_ID = Util.GetString(EmpData[0].UserType_ID);
            objMSTEmployee.EmployeeID = Util.GetString(EmpData[0].EmployeeID);
            objMSTEmployee.Dept_ID = Util.GetString(EmpData[0].Dept_ID);
            objMSTEmployee.Dept_Name = Util.GetString(EmpData[0].Dept_Name);
            objMSTEmployee.Desi_Name = Util.GetString(EmpData[0].Desi_Name);
            objMSTEmployee.Desi_ID = Util.GetString(EmpData[0].Desi_ID);
            objMSTEmployee.DiscountPercent = Util.GetDecimal(EmpData[0].DiscountPercent);
            objMSTEmployee.Allowpartialpayment = Util.GetInt(EmpData[0].Allowpartialpayment);
            objMSTEmployee.Cadreid = Util.GetInt(EmpData[0].Cadreid);
            objMSTEmployee.TierID = Util.GetInt(EmpData[0].TierID);

            int rtnstatus = objMSTEmployee.Update();
            if (rtnstatus > 0)
            {
                //string sqlQuery = string.Empty;
                //ExcuteCMD excuteCMD = new ExcuteCMD();
                //sqlQuery = "UPDATE Employee_Master SET TabPosition=2 WHERE EmployeeID=@EmpID";
                //excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
                //{
                //    EmpID = EmpData[0].EmployeeID
                //});
            }
            tnx.Commit();

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = EmpData[0].EmployeeID });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public string EncryptPassword(string text)
    {
        MD5 md5 = new MD5CryptoServiceProvider();
        md5.ComputeHash(ASCIIEncoding.ASCII.GetBytes(text));
        byte[] result = md5.Hash;
        StringBuilder strBuilder = new StringBuilder();
        for (int i = 0; i < result.Length; i++)
        {
            strBuilder.Append(result[i].ToString("x2").ToLower());
        }
        return strBuilder.ToString();
    }

    [WebMethod(EnableSession = true)]
    public string SavePageAccess(List<User_PageAccess> data)
    {
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            ExcuteCMD excuteCMD = new ExcuteCMD();
            sb.Append("DELETE FROM user_pageaccess WHERE EmployeeID=@EmployeeID");
            excuteCMD.DML(tnx, con, sb.ToString(), CommandType.Text, new { EmployeeID = data[0].EmployeeID });

            var t_data = data.Where(x => x.Status == true && x.MenuID != "").ToList();
            
            //data.ForEach(i =>
            //{
            //    if (i.MenuID != "")
            //    {
            //        if (i.Status)
            //        {

            //            sb = new StringBuilder();
            //            sb.Append("insert into user_pageaccess(CentreID,RoleID,MenuID,UrlID,EmployeeID,CreatedBy,IsActive) SELECT @CentreID,@RoleID, @MenuID, @UrlID, @EmployeeID, @CreatedBy,@IsActive");
            //            excuteCMD.DML(tnx, con, sb.ToString(), CommandType.Text, new
            //            {
            //                CentreID = i.CentreID,
            //                RoleID = i.RoleID,
            //                MenuID = i.MenuID,
            //                UrlID = i.UrlID,
            //                EmployeeID = i.EmployeeID,
            //                IsActive = i.Status,
            //                CreatedBy = HttpContext.Current.Session["ID"].ToString()
            //            });
            //        }
            //    }
            //});

            for (int i = 0; i < t_data.Count; i++) {
                sb = new StringBuilder();
                sb.Append("insert into user_pageaccess(CentreID,RoleID,MenuID,UrlID,EmployeeID,CreatedBy,IsActive) SELECT @CentreID,@RoleID, @MenuID, @UrlID, @EmployeeID, @CreatedBy,@IsActive");
                excuteCMD.DML(tnx, con, sb.ToString(), CommandType.Text, new
                {
                    CentreID = t_data[i].CentreID,
                    RoleID = t_data[i].RoleID,
                    MenuID = t_data[i].MenuID,
                    UrlID = t_data[i].UrlID,
                    EmployeeID = t_data[i].EmployeeID,
                    IsActive = t_data[i].Status,
                    CreatedBy = HttpContext.Current.Session["ID"].ToString()
                });
            }

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", errorMessage = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public class User_PageAccess
    {
        private int _RoleID;
        private string _RoleName;
        private string _MenuID;
        private string _UrlID;
        private string _EmployeeID;
        private string _Url;
        private int _CentreID;
        private bool _Status;

        public virtual int RoleID
        {
            get
            {
                return _RoleID;
            }
            set
            {
                _RoleID = value;
            }
        }
        public virtual string RoleName
        {
            get
            {
                return _RoleName;
            }
            set
            {
                _RoleName = value;
            }
        }
        public virtual string MenuID
        {
            get
            {
                return _MenuID;
            }
            set
            {
                _MenuID = value;
            }
        }
        public virtual string UrlID
        {
            get
            {
                return _UrlID;
            }
            set
            {
                _UrlID = value;
            }
        }
        public virtual string EmployeeID
        {
            get
            {
                return _EmployeeID;
            }
            set
            {
                _EmployeeID = value;
            }
        }
        public virtual string Url
        {
            get
            {
                return _Url;
            }
            set
            {
                _Url = value;
            }
        }

        public virtual int CentreID
        {
            get
            {
                return _CentreID;
            }
            set
            {
                _CentreID = value;
            }
        }
        public virtual bool Status
        {
            get
            {
                return _Status;
            }
            set
            {
                _Status = value;
            }
        }
    }

    [WebMethod(EnableSession = true)]
    public string GetCenter(string EmpId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CentreID,CentreName,IsDefault FROM center_master cm ");
        sb.Append(" INNER JOIN `centre_access` ca ON cm.CentreID=ca.CentreAccess ");
        sb.Append(" WHERE ca.EmployeeID='" + EmpId + "' AND ca.IsActive=1 ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
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
    public string ddlGetEmolyee()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT em.EmployeeID,em.Name FROM employee_master em");
        sb.Append(" INNER JOIN f_login fl ON fl.`EmployeeID`=em.`EmployeeID` GROUP BY em.`EmployeeID`");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
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
    public static string GetRoles()
    {
        DataTable dt = All_LoadData.LoadRole();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }







     [WebMethod(EnableSession = true)]
    public string GetUserAuth(string EmployeeID, string CentreID)
    {
        int count = 0;
        DataTable dt = new DataTable();
        count = Util.GetInt(StockReports.ExecuteScalar("select count(*) from centre_access WHERE `EmployeeID`='" + EmployeeID + "'"));
        if (count > 0)
        {
            dt = StockReports.GetDataTable("CALL sp_userauthorization('" + EmployeeID + "','" + CentreID + "')");
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

     [WebMethod(EnableSession = true)]
    public string GetDeptWiseAuth(string EmployeeID, string CentreID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT um.DeptBelongID,um.DeptBelong,GROUP_CONCAT(DISTINCT uad.`RoleID` ORDER BY uad.`RoleID` ASC)RoleID,GROUP_CONCAT(DISTINCT rm.RoleName ORDER BY uad.`RoleID` ASC)Role, uam.UAID,uam.ColName,uam.ColDescription,IFNULL(ua.`ColValue`,0)IsRights   FROM userauthorizationmaster uam");
        sb.Append(" INNER JOIN `userauthorisationdeptmaster` um ON uam.`DeptBelongID`=um.DeptBelongID  ");
        sb.Append(" INNER JOIN userauthorisationdeptroles uad ON uam.`DeptBelongID`=uad.`DebtBelongID` AND uad.`IsActive`=1 ");
        sb.Append("  INNER JOIN f_rolemaster RM ON uad.RoleID=RM.ID AND RM.active=1 ");
        sb.Append("  INNER JOIN f_login lg ON lg.`RoleID` = uad.`RoleID` AND lg.`Active`=1 ");
         sb.Append(" LEFT OUTER JOIN userauthorization ua ON ua.`EmployeeID`=lg.`EmployeeID` AND ua.`CentreID` = lg.`CentreID` AND ua.`RoleId` = lg.`RoleID` AND ua.`ColName`= uam.`ColName` ");
        
        sb.Append("  WHERE lg.employeeid='"+ EmployeeID +"' AND lg.centreid=" + CentreID + "  GROUP BY um.DeptBelongID,uam.`UAID` ORDER BY uad.`DebtBelongID`,uad.`RoleID`,uam.`SlNo`");
        
        
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0 && dt != null)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public string SaveUserAuth(List<UserAuth> data)
    {
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            ExcuteCMD excuteCMD = new ExcuteCMD();
            sb.Append("DELETE FROM userauthorization WHERE EmployeeID=@EmployeeID And CentreID=@CentreID");
            excuteCMD.DML(tnx, con, sb.ToString(), CommandType.Text, new { EmployeeID = data[0].EmployeeID, CentreID = data[0].CentreID });

            
            data.ForEach(i =>
            {
                if (i.Status)
                {

                    for (int j = 0; j < i.RoleID.Split(',').Length; j++)
                    {
                        int RolID = Util.GetInt(i.RoleID.Split(',')[j].ToString());

                        sb = new StringBuilder();
                        sb.Append("insert into userauthorization(RoleId,EmployeeID,CentreID,ColName,ColValue,Creator_id) SELECT @RoleId,@EmployeeID, @CentreID,@ColName,@ColValue, @Creator_id");
                        excuteCMD.DML(tnx, con, sb.ToString(), CommandType.Text, new
                        {
                            RoleID = RolID,
                            EmployeeID = i.EmployeeID,
                            ColName=i.ColName,
                            ColValue=i.Status,
                            CentreID = i.CentreID,
                            Creator_id = HttpContext.Current.Session["ID"].ToString()
                        });
                        
                    }
                }
            });

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", errorMessage = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public class UserAuth
    {
        private string _RoleID;
        private string _RoleName;
        private int _UAID;
        private int _DeptBelongID;
        private string _DeptBelong;
        private string _EmployeeID;
        private int _CentreID;
        private bool _Status;
        private string _ColName;
        private string _ColValue; 
   
        public virtual string RoleID
        {
            get
            {
                return _RoleID;
            }
            set
            {
                _RoleID = value;
            }
        }
        public virtual string RoleName
        {
            get
            {
                return _RoleName;
            }
            set
            {
                _RoleName = value;
            }
        }
        public virtual int UAID
        {
            get
            {
                return _UAID;
            }
            set
            {
                _UAID = value;
            }
        }
        public virtual int DeptBelongID
        {
            get
            {
                return _DeptBelongID;
            }
            set
            {
                _DeptBelongID = value;
            }
        }
        public virtual string DeptBelong
        {
            get
            {
                return _DeptBelong;
            }
            set
            {
                _DeptBelong = value;
            }
        }
        public virtual string EmployeeID
        {
            get
            {
                return _EmployeeID;
            }
            set
            {
                _EmployeeID = value;
            }
        }

        public virtual int CentreID
        {
            get
            {
                return _CentreID;
            }
            set
            {
                _CentreID = value;
            }
        }
        public virtual bool Status
        {
            get
            {
                return _Status;
            }
            set
            {
                _Status = value;
            }
        }

        public virtual string ColName
        {
            get
            {
                return _ColName;
            }
            set
            {
                _ColName = value;
            }
        }

        public virtual string ColValue
        {
            get
            {
                return _ColValue;
            }
            set
            {
                _ColValue = value;
            }
        }
    }


     [WebMethod(EnableSession = true)]
    public string CopyRoleRight(string EmployeeID, string CopyEmployeeID, string Password, string UserName)
    {
        string CreatedBy = HttpContext.Current.Session["ID"].ToString();
        using (MySqlConnection con = Util.GetMySqlCon())
        {
            using (MySqlCommand cmd = new MySqlCommand("sp_copy_emp_rolerights", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@_fromEmpid", CopyEmployeeID);
                cmd.Parameters.AddWithValue("@_toempid", EmployeeID);

                cmd.Parameters.AddWithValue("@uid", UserName);
                cmd.Parameters.AddWithValue("@_pwd", Password);

                cmd.Parameters.AddWithValue("@_createdBy", CreatedBy);

                con.Open();

                int a = cmd.ExecuteNonQuery();
                if (a > 0)
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = 1 });
                else
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Some Erroe Occured" });

            }
        }


    }
    [WebMethod(EnableSession = true)]
    public string BulkCopyRoleRight(List<string> EmployeeID, string CopyEmployeeID)
    {
        string CreatedBy = HttpContext.Current.Session["ID"].ToString();
        int a = 0;
        foreach (string ToEmpId in EmployeeID)
        {
            using (MySqlConnection con = Util.GetMySqlCon())
            {

                using (MySqlCommand cmd = new MySqlCommand("sp_copy_emp_rolerights", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@_fromEmpid", CopyEmployeeID);
                    cmd.Parameters.AddWithValue("@_toempid", ToEmpId);

                    cmd.Parameters.AddWithValue("@uid", ToEmpId);
                    cmd.Parameters.AddWithValue("@_pwd", "123456");

                    cmd.Parameters.AddWithValue("@_createdBy", CreatedBy);

                    con.Open();

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
    public string GetUserName(string EmployeeID, int CentreID)
    {
        DataTable dt = StockReports.GetDataTable("SELECT UserName FROM f_login WHERE EmployeeID='" + EmployeeID + "' AND CentreID='" + CentreID + "' AND Active=1 LIMIT 1");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });

    }



    
    
    
    [WebMethod(EnableSession = true)]
    public string ResetPassword(string EmployeeID, string NewPassword, string ConfirmPassword, int CentreID)
    {
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            ExcuteCMD excuteCMD = new ExcuteCMD();
            sb.Append("update f_login set Password='" + EncryptPassword(NewPassword) + "',Updatedate=now(),LastUpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "'  WHERE EmployeeID=@EmpID AND CentreID=@CID");
            excuteCMD.DML(tnx, con, sb.ToString(), CommandType.Text, new { EmpID = EmployeeID, CID = CentreID });

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", errorMessage = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }

    [WebMethod]
    public string bindCadreType()
    {
        DataTable dt = StockReports.GetDataTable("select ID,CadreName from Employee_Cadre_Master where Active=1 ; ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }
    [WebMethod]
    public string bindTierType()
    {
        DataTable dt = StockReports.GetDataTable("select ID,TierName from Employee_Tier_Master where Active=1  ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }
}