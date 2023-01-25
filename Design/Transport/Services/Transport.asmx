<%@ WebService Language="C#" Class="Transport" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script;
using System.Data;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Text;
using MySql.Data.MySqlClient;
using System.Collections.Generic;
using System.Linq;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class Transport : System.Web.Services.WebService
{
    GetEncounterNo Encounter = new GetEncounterNo();
    int EncounterNo = 0;


    [WebMethod(Description = "Bind Driver Detail", EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindDriverDetail()
    {
        DataTable driver = StockReports.GetDataTable("select LicenseType,ID,Name,FatherName,Address,Phone,Mobile,LicenceNo,date_format(LicenceExpiryDate,'%d-%b-%Y') as ExpiryDate, Remark,if(IsActive=1,'Active','DeActive')IsActive from t_driver_master where CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"]) + "");
        if (driver.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(driver);
        else
            return "";
    }
    [WebMethod(Description = "Save Driver", EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string saveDriver(string Name, string LicenceNo, string FatherName, string ContactNo, string Address, string LicenceExpiryDate, string Remark, string LicenseType)
    {
        int LicNo = Util.GetInt(StockReports.ExecuteScalar("select count(*) from t_driver_master where LicenceNo='" + LicenceNo + "'"));
        if (LicNo > 0)
            return "2";
        else
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "insert into t_driver_master(Name,FatherName,Address,Mobile,LicenceNo,LicenceExpiryDate,Remark,UserID,CentreID,LicenseType) values('" + Name + "','" + FatherName + "','" + Address + "','" + ContactNo + "','" + LicenceNo + "','" + Util.GetDateTime(LicenceExpiryDate).ToString("yyyy-MM-dd") + "','" + Remark + "','" + HttpContext.Current.Session["ID"].ToString() + "'," + HttpContext.Current.Session["CentreID"].ToString() + ",'" + LicenseType + "')");

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
    }

    [WebMethod(Description = "Update Driver", EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string updateDriver(string Name, string LicenceNo, string FatherName, string ContactNo, string Address, string LicenceExpiryDate, string Remark, string IsActive, string ID, string LicenseType)
    {
        int LicNo = Util.GetInt(StockReports.ExecuteScalar("select count(*) from t_driver_master where LicenceNo='" + LicenceNo.Trim() + "' and ID !='" + ID + "'"));
        if (LicNo > 0)
            return "2";
        else
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "update  t_driver_master set  Name = '" + Name.Trim() + "',LicenseType='" + LicenseType + "',FatherName ='" + FatherName + "',Address = '" + Address + "'  , Mobile = '" + ContactNo + "' , LicenceNo = '" + LicenceNo + "', LicenceExpiryDate = '" + Util.GetDateTime(LicenceExpiryDate).ToString("yyyy-MM-dd") + "' , Remark = '" + Remark + "' , UserID = '" + HttpContext.Current.Session["ID"].ToString() + "' , IsActive =" + IsActive + " where ID = '" + ID + "' ");

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
    }
    [WebMethod(Description = "Bind Vehicle Detail", EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindVehicleDetail()
    {
        DataTable vehicle = StockReports.GetDataTable("select ID,VehicleNo,VehicleName,ModelNo,LastReading,RcNo,date_format(TaxDepositDate,'%d-%b-%Y') as TaxDepositDate,AveragePerLtrs, if(IsActive=1,'Active','DeActive')IsActive,InsuranceNo,DATE_FORMAT(InsuranceExpiryDate,'%d-%b-%Y')InsuranceExpiryDate,Model,VehicleType from t_vehicle_master where CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " ");
        if (vehicle.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(vehicle);
        else
            return "";
    }
    [WebMethod(Description = "Save Vehicle", EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string saveVehicle(string VehicleNo, string VehicleName, string ModelNo, string LastReading, string RcNo, string TaxDepositDate, string AveragePerLtrs, string InsuranceNo, string InsuranceExpiryDate, string Model, string VehicleType)
    {
        int vehicleNo = Util.GetInt(StockReports.ExecuteScalar("select count(*) from t_vehicle_master where VehicleNo='" + VehicleNo + "'"));
        if (vehicleNo > 0)
            return "2";
        else
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "insert into t_vehicle_master(VehicleNo,VehicleName,ModelNo,LastReading,RcNo,TaxDepositDate,AveragePerLtrs, " +
                    " UserID,InsuranceNo,InsuranceExpiryDate,Model,VehicleType,CentreID) values('" + VehicleNo + "','" + VehicleName + "','" + ModelNo + "', " +
                    " '" + LastReading + "','" + RcNo + "','" + Util.GetDateTime(TaxDepositDate).ToString("yyyy-MM-dd") + "','" + AveragePerLtrs + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + InsuranceNo + "','" + Util.GetDateTime(InsuranceExpiryDate).ToString("yyyy-MM-dd") + "','" + Model + "','" + VehicleType + "'," + HttpContext.Current.Session["CentreID"].ToString() + ") ");

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
    }
    [WebMethod(Description = "Update Vehicle", EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string updateVehicle(string VehicleNo, string VehicleName, string ModelNo, string LastReading, string RcNo, string TaxDepositDate, string AveragePerLtrs, string IsActive, string ID, string InsuranceNo, string InsuranceExpiryDate, string Model, string VehicleType)
    {
        int LicNo = Util.GetInt(StockReports.ExecuteScalar("select count(*) from t_vehicle_master where VehicleNo='" + VehicleNo.Trim() + "' and ID !='" + ID + "'"));
        if (LicNo > 0)
            return "2";
        else
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "update  t_vehicle_master set  VehicleNo = '" + VehicleNo.Trim() + "',VehicleName ='" + VehicleName + "',ModelNo = '" + ModelNo + "'  , LastReading = '" + LastReading + "' , RcNo = '" + RcNo + "', " +
                    " TaxDepositDate = '" + Util.GetDateTime(TaxDepositDate).ToString("yyyy-MM-dd") + "' , AveragePerLtrs = '" + AveragePerLtrs + "' , UserID = '" + HttpContext.Current.Session["ID"].ToString() + "' , IsActive =" + IsActive + ",InsuranceNo='" + InsuranceNo + "', " +
                    " InsuranceExpiryDate='" + Util.GetDateTime(InsuranceExpiryDate).ToString("yyyy-MM-dd") + "',Model='" + Model + "',VehicleType='" + VehicleType + "' where ID = '" + ID + "' ");
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
    }
    [WebMethod(Description = "Bind Vehicle")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindVehicle(string Status)
    {
        DataTable vehicle = StockReports.GetDataTable("select CONCAT(VehicleName,' # ',VehicleNo)Name, Id from t_vehicle_master where IsActive=1 AND Status='" + Status + "' order by VehicleName,VehicleNo where CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " ");
        if (vehicle.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(vehicle);
        else
            return "";
    }

    [WebMethod(Description = "Bind Vehicle Without Status", EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindVehicle1()
    {
        DataTable vehicle = StockReports.GetDataTable("select CONCAT(VehicleName,' # ',VehicleNo)Name, Id from t_vehicle_master where IsActive=1  and CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " order by VehicleName,VehicleNo ");
        if (vehicle.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(vehicle);
        else
            return "";
    }

    [WebMethod(Description = "Bind Driver")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindDriver(string Status)
    {
        DataTable driver = StockReports.GetDataTable("select Id,Name from t_driver_master where IsActive=1 and  Status ='" + Status + "' and CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " order by  Name");
        if (driver.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(driver);
        else
            return "";
    }

    [WebMethod(Description = "Bind Driver Without Status", EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindDriver1()
    {
        DataTable driver = StockReports.GetDataTable("select Id,Name from t_driver_master where IsActive=1  and CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " order by  Name");
        if (driver.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(driver);
        else
            return "";
    }

    [WebMethod(Description = "Bind Purpose")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindPurpose()
    {
        DataTable purpose = StockReports.GetDataTable("select Purpose,Id from  t_purpose_master where IsActive=1 order by  Purpose");
        if (purpose.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(purpose);
        else
            return "";
    }
    [WebMethod(Description = "Bind Traveling Approval")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindTravelingApproval()
    {
        DataTable approval = StockReports.GetDataTable("select Name,Id from  t_TravelingApprovaltMaster where IsActive=1 order by  Name");
        if (approval.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(approval);
        else
            return "";
    }
    [WebMethod(Description = "Save MonthClosing", EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string saveMonthClosing(string VehicleID, string Month, string MonthOpening, string MonthClosing)
    {
        int count = Util.GetInt(StockReports.ExecuteScalar(" Select count(*) from t_monthbalance where VehicleID='" + VehicleID + "' AND Month='" + Month + "'"));
        if (count > 0)
            return "2";
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "insert into t_monthbalance(VehicleID,Month,MonthOpening,MonthClosing,UserID,CentreID) values('" + VehicleID + "','" + Month + "','" + MonthOpening + "','" + MonthClosing + "','" + HttpContext.Current.Session["ID"].ToString() + "'," + HttpContext.Current.Session["CentreID"].ToString() + ")");
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
    [WebMethod(Description = "Save OUT Traveling Detail", EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string saveTravelingDetail(string VehicleID, string DriverID, string DriverName, string Purpose, string Opening, string Closing, string Place, string ApprovedBy, string DepartureDate, string DepartureTime, string DepartureRemark, string Type, string VehicleRequest, string PatientRequest)
    {

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "insert into t_travel_detail(VehicleID,DriverID,DriverName,Purpose,Opening,Closing,PlaceVisited,ApprovedBy,DepartureDate,DepartureTime,DepartureRemark,OutUserID,OutStatus,OutEntryDate,CentreID) values('" + VehicleID + "','" + DriverID + "','" + DriverName + "', " +
                " '" + Purpose + "','" + Util.GetDecimal(Opening) + "','" + Util.GetDecimal("0.00") + "','" + Place + "','" + ApprovedBy + "','" + Util.GetDateTime(DepartureDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(DepartureTime).ToString("HH:mm:ss") + "','" + DepartureRemark + "','" + HttpContext.Current.Session["ID"].ToString() + "',1,'" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "'," + HttpContext.Current.Session["CentreID"].ToString() + ")");
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE t_vehicle_master SET Status=1 where ID='" + VehicleID + "'");
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE t_driver_master SET Status=1 where ID='" + DriverID + "'");

            int TravelID = Util.GetInt(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, "SELECT MAX(ID) FROM t_travel_detail"));

            if (Type == "1")
            {
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "insert into t_patient_vehicle(TravelDate,TravelTime,Purpose,VehicleID,DriverID,TravelID,IsDirect,EntryDate,EntryBy,CentreID) values('" + Util.GetDateTime(DepartureDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(DepartureTime).ToString("HH:mm:ss") + "','" + Purpose + "','" + VehicleID + "','" + DriverID + "','" + TravelID + "',1,now(),'" + HttpContext.Current.Session["ID"].ToString() + "'," + Util.GetString(HttpContext.Current.Session["CentreID"]) + ")");
            }
            else if (Type == "2")
            {
                string ID = Util.GetString(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, "Select IFNULL(MAX(ID)+1,1) from t_department_vehicle "));
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "insert into t_department_vehicle(Location,HospCode,ID,TravelDate,TravelTime,Purpose,TravelID,IsDirect,IsComplete,EntryDate,EntryBy,CentreID) values('" + Util.GetString(AllGlobalFunction.Location) + "','" + Util.GetString(AllGlobalFunction.HospCode) + "','" + ID + "','" + Util.GetDateTime(DepartureDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(DepartureTime).ToString("HH:mm:ss") + "','" + Purpose + "','" + TravelID + "',1,1,now(),'" + HttpContext.Current.Session["ID"].ToString() + "','" + Util.GetString(HttpContext.Current.Session["CentreID"]) + "')");
            }
            else if (Type == "3")
            {
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "update t_patient_vehicle set VehicleID='" + VehicleID + "',DriverID='" + DriverID + "',TravelID='" + TravelID + "', IsComplete=1,UpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdatedDate=now() where ID='" + PatientRequest + "' ");
            }
            else if (Type == "4")
            {
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "update t_department_vehicle set  TravelID='" + TravelID + "',IsComplete=1,UpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdatedDate=now() where VehicleRequestID='" + VehicleRequest + "'");
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
    [WebMethod(Description = "Update IN Traveling Detail", EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string updateTravelingDetail(string VehicleID, string DriverID, string Opening, string Closing, string ApprovedBy, string ArrivalDate, string ArrivalTime, string ArrivalRemark)
    {

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "Update t_travel_detail SET OutStatus=0,IsActive=0,InStatus=0, " +
                " InEntryDate='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',InUserID='" + HttpContext.Current.Session["ID"].ToString() + "'," +
                " Closing='" + Util.GetDecimal(Closing) + "',ArrivalDate='" + Util.GetDateTime(ArrivalDate).ToString("yyyy-MM-dd") + "', " +
                " ArrivalTime='" + Util.GetDateTime(ArrivalTime).ToString("HH:mm:ss") + "',ArrivalRemark='" + ArrivalRemark + "',KmsCovered='" + Util.GetDecimal(Util.GetDecimal(Closing) - Util.GetDecimal(Opening)) + "' " +
                " WHERE VehicleID='" + VehicleID + "' AND DriverID='" + DriverID + "' AND Opening='" + Opening + "'");
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE t_vehicle_master SET Status=0 where ID='" + VehicleID + "'");
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE t_driver_master SET Status=0 where ID='" + DriverID + "'");

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
    [WebMethod(Description = "Update IN Traveling Detail", EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindDetail(string VehicleID)
    {
        DataTable dt = StockReports.GetDataTable("Select DriverID,Opening,DATE_FORMAT(DepartureDate,'%d-%b-%Y')DepartureDate,TIME_FORMAT(DepartureTime,'%h:%i %p')DepartureTime,Purpose,PlaceVisited,ApprovedBy,DepartureRemark from t_travel_detail " +
            " Where id =(SELECT MAX(id) FROM t_travel_detail WHERE VehicleID='" + VehicleID + "') ");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(Description = "bind Standing Odometer")]
    public string bindStandingOdometer(string VehicleID)
    {
        string dt = StockReports.ExecuteScalar("Select Closing from t_travel_detail where id =(SELECT MAX(id) FROM t_travel_detail WHERE VehicleID='" + VehicleID + "') ");
        if (dt != "")
            return dt;
        else
            return "";
    }
    [WebMethod]
    public string bindMonthClosingVehicle()
    {
        DataTable vehicle = StockReports.GetDataTable("select CONCAT(VehicleName,' # ',VehicleNo)Name, Id from t_vehicle_master where IsActive=1  order by VehicleName,VehicleNo ");
        if (vehicle.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(vehicle);
        else
            return "";
    }

    [WebMethod]
    public string chkOpening(string VehicleID, string Month)
    {
        string opening = StockReports.ExecuteScalar("Select MonthClosing from t_monthbalance where VehicleID='" + VehicleID + "' And Month='" + Month + "'");
        if (opening != "")
            return opening;
        else
            return "";
    }
    [WebMethod]
    public string vehicle()
    {
        DataTable vehicle = StockReports.GetDataTable("select CONCAT(VehicleName,' # ',VehicleNo)Name, Id from t_vehicle_master where IsActive=1  and CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " order by VehicleName,VehicleNo ");
        if (vehicle.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(vehicle);
        else
            return "";
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string driver()
    {
        DataTable driver = StockReports.GetDataTable("select Id,Name from t_driver_master where IsActive=1  and CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " order by  Name");
        if (driver.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(driver);
        else
            return "";
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string travelingDetail(string DriverID, string VehicleID, string Purpose, string DepartureDate, string ArrivalDate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select tv.ID,tv.VehicleID, date_format(tv.DepartureDate,'%d-%b-%Y') as DepartureDate ,DATE_FORMAT(tv.DepartureTime,'%h:%i %p')DepartureTime,date_format(tv.ArrivalDate,'%d-%b-%Y') as ArrivalDate, ");
        sb.Append(" DATE_FORMAT(tv.ArrivalTime,'%h:%i %p')ArrivalTime,vm.VehicleName,vm.VehicleNo , tv.DriverID, tv.DriverName, tv.Opening, tv.Closing, tv.KmsCovered,");
        sb.Append(" tv.Reading, tv.PetrolRemark,tv.Purpose, tv.PlaceVisited  from t_travel_detail tv inner join t_vehicle_master vm on vm.ID=tv.VehicleID Where tv.IsCancel=0 ");
        if (DriverID != "0")
        {
            sb.Append(" and tv.DriverID=" + DriverID + " ");
        }
        if (VehicleID != "0")
        {
            sb.Append(" and tv.VehicleID=" + VehicleID.Split('#')[0].Trim() + "");
        }
        if (Purpose != "0")
        {
            sb.Append(" and tv.Purpose='" + Purpose + "'");
        }
        sb.Append(" And DepartureDate >= '" + Util.GetDateTime(DepartureDate).ToString("yyyy-MM-dd") + "' And ArrivalDate <='" + Util.GetDateTime(ArrivalDate).ToString("yyyy-MM-dd") + "' And IsCancel=0 order by date(DepartureDate)");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod(EnableSession = true, Description = "Save Purpose of Vehicle")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string savePurpose(string Purpose)
    {
        string result = "0";
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int IsExists = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "Select count(*) from t_purpose_master where Purpose='" + Purpose + "'"));
            if (IsExists > 0)
            {
                result = "2";
            }
            else
            {
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "insert into t_purpose_master (Purpose) values('" + Purpose + "')");
                result = "1";
            }

            tranx.Commit();
            tranx.Dispose();
            con.Close();
            con.Dispose();
        }
        catch (Exception ex)
        {
            tranx.Rollback();
            tranx.Dispose();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }

        return result;
    }

    [WebMethod(EnableSession = true, Description = "Save Vehicle Servicing")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string saveService(string ID, string CurrentDate, string NextDate, string Remarks, string IsService, string DriverID, string MaintenanceDate, string Amount)
    {
        string result = "0";
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string Query = "INSERT INTO t_vehicle_servicing (VehicleID,CurServiceDate,NextServiceDate,Remarks,EntryBy,EntryDate,CentreID,IsService,DriverID , MaintenanceDate,Amount) " +
                "VALUES(" + Util.GetInt(ID) + ",'" + Util.GetDateTime(CurrentDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(NextDate).ToString("yyyy-MM-dd") + "','" + Util.GetString(Remarks) + "', " +
                "'" + HttpContext.Current.Session["ID"].ToString() + "',NOW(),'" + HttpContext.Current.Session["CentreID"].ToString() + "'," +
                "'" + Util.GetInt(IsService) + "','" + Util.GetInt(DriverID) + "','" + Util.GetDateTime(MaintenanceDate).ToString("yyyy-MM-dd") + "','" + Util.GetDecimal(Amount) + "' )";

            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, Query);

            tranx.Commit();
            tranx.Dispose();
            con.Close();
            con.Dispose();
            result = "1";
        }
        catch (Exception ex)
        {
            tranx.Rollback();
            tranx.Dispose();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }

        return result;
    }

    [WebMethod(EnableSession = true, Description = "Bind Servicing Details")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindServicingDetail(string ID, string CurServiceDate, string NextServiceDate, string IsService)
    {
        string result = "0";
        string Query = "SELECT VS.ID,VS.VehicleID,VM.VehicleNo,VM.VehicleName,DATE_FORMAT(VS.CurServiceDate,'%d-%b-%Y')CurServiceDate,DATE_FORMAT(VS.NextServiceDate,'%d-%b-%Y')NextServiceDate,DATE_FORMAT(VS.MaintenanceDate,'%d-%b-%Y')MaintenanceDate, (SELECT dm.Name FROM t_driver_master dm WHERE dm.ID=VS.DriverID)Driver, VS.Amount,VS.Remarks, VS.IsService ,VS.DriverID " +
                     "FROM t_vehicle_servicing VS INNER JOIN t_vehicle_master VM ON VS.VehicleID=VM.ID WHERE VS.VehicleID='" + ID + "' AND VS.EntryDate >= '" + Util.GetDateTime(CurServiceDate).ToString("yyyy-MM-dd") + " 00:00:00' AND VS.EntryDate <= '" + Util.GetDateTime(NextServiceDate).ToString("yyyy-MM-dd") + " 23:59:59' AND vs.IsService='" + IsService + "' ORDER BY VS.NextServiceDate DESC  ";
        DataTable dt = StockReports.GetDataTable(Query);

        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

        return result;
    }



    [WebMethod(EnableSession = true, Description = "Save Fuel Entry")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string saveFuelEntry(string VehicleID, string DriverID, string Amount, string Letter, string Remarks)
    {
        string result = "0";
        try
        {
            Fuel_Entry entry = new Fuel_Entry();
            entry.VehicleID = Util.GetInt(VehicleID);
            entry.DriverID = Util.GetInt(DriverID);
            entry.TotalAmount = Util.GetDecimal(Amount);
            entry.Letter = Util.GetString(Letter);
            entry.Remarks = Util.GetString(Remarks);
            entry.EntryBy = HttpContext.Current.Session["ID"].ToString();
            entry.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            //entry.HospCentreID = Util.GetInt(HttpContext.Current.Session["HospCentreID"].ToString());
            entry.FuelDate = DateTime.Now;
            entry.Insert();

            result = "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }

        return result;
    }

    [WebMethod(EnableSession = true, Description = "Bind Fuel Entry ")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindFuelEntry(string ID, string FromDate, string ToDate)
    {
        string result = "0";
        string Query = "SELECT FE.ID,FE.VehicleID,VM.VehicleNo,VM.VehicleName,(SELECT dm.Name FROM t_driver_master dm WHERE dm.ID=FE.DriverID)Driver, FE.Letter,FE.Remark,FE.TotalAmount,DATE_FORMAT(FE.EntryDate,'%d-%b-%Y')EntryDate ,FE.DriverID,DATE_FORMAT(FE.FuelDate,'%d-%b-%Y')FuelDate " +
                     "FROM t_fuel_entry FE INNER JOIN t_vehicle_master VM ON FE.VehicleID=VM.ID WHERE FE.VehicleID='" + ID + "' AND FE.EntryDate >= '" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND FE.EntryDate <= '" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59'  ";
        DataTable dt = StockReports.GetDataTable(Query);

        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

        return result;
    }

    [WebMethod(EnableSession = true, Description = "Update Fuel Entry ")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string UpdateFuelEntry(string ID, string VehicleID, string DriverID, string Letter, string Remark, string TotalAmount, string FuelDate)
    {


        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "update  t_fuel_entry set VehicleID='" + VehicleID + "',DriverID='" + DriverID + "',Letter='" + Letter + "',Remark='" + Remark + "', TotalAmount='" + TotalAmount + "', UpdateBy = '" + HttpContext.Current.Session["ID"].ToString() + "' , UpdatedDate=NOW(),FuelDate='" + Util.GetDateTime(FuelDate).ToString("yyyy-MM-dd") + "' where ID = '" + ID + "' ");

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


    // Previous Code Changes End

    // New Changes Start  

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string UpdateServiceMaintenance(string ID, string VehicleID, string CurServiceDate, string NextServiceDate, string Remarks, string DriverID, string MaintenanceDate, string Amount)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "update  t_vehicle_servicing set VehicleID='" + VehicleID + "',DriverID='" + DriverID + "', CurServiceDate='" + Util.GetDateTime(CurServiceDate).ToString("yyyy-MM-dd") + "',NextServiceDate='" + Util.GetDateTime(NextServiceDate).ToString("yyyy-MM-dd") + "',Remarks='" + Remarks + "', Amount='" + Amount + "', MaintenanceDate='" + Util.GetDateTime(MaintenanceDate).ToString("yyyy-MM-dd") + "', UpdatedBy = '" + HttpContext.Current.Session["ID"].ToString() + "' , UpdatedDate=NOW() where ID = '" + ID + "' ");

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

    [WebMethod(EnableSession = true, Description = "Fuel Entry Report")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string vehicleFuelEntryReport(string VehicleID, string DriverID, string FromDate, string ToDate)
    {
        StringBuilder Query = new StringBuilder();

        Query.Append("SELECT FE.EntryNo,FE.Letter,FE.Remark,FE.TotalAmount,DATE_FORMAT(FE.EntryDate,'%d-%b-%Y')EntryDate,VM.VehicleNo,VM.VehicleName,VM.VehicleType,DM.Name DriverName,CM.CentreName ");
        Query.Append("FROM t_fuel_entry FE INNER JOIN t_vehicle_master VM ON FE.VehicleID=VM.ID INNER JOIN t_driver_master DM ON FE.DriverID=DM.ID ");
        Query.Append("INNER JOIN center_master CM ON FE.CentreID=CM.CentreID WHERE FE.IsCancel=0 AND  DATE(FE.EntryDate)>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND DATE(FE.EntryDate)<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' ");

        if (VehicleID != "0")
        {
            Query.Append("AND FE.VehicleID='" + VehicleID + "' ");
        }

        if (DriverID != "0")
        {
            Query.Append("AND FE.DriverID='" + DriverID + "' ");
        }

        Query.Append("order by Date(FE.EntryDate) ");

        DataTable dt = StockReports.GetDataTable(Query.ToString());

        if (dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "ReportDate";
            dc.DefaultValue = "From : " + Util.GetDateTime(FromDate).ToString("dd-MMM-yyyy") + "  To : " + Util.GetDateTime(ToDate).ToString("dd-MMM-yyyy");
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"]));
            dt.Columns.Add(dc);

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());

            //ds.WriteXmlSchema("D:\\VehicleFuelEntryReport.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "VehicleFuelEntryReport";

            return "1";
        }

        return "0";
    }

    [WebMethod(EnableSession = true, Description = "Bind Dashboard Details")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindDashBoard()
    {
        string result = "0";
        StringBuilder Query = new StringBuilder();

        Query.Append("SELECT VM.ID,CONCAT(VM.VehicleName,' [',VM.VehicleNo,']')VehicleName,ifnull(IF(VM.Status=0,'IN', ");
        Query.Append("(SELECT CONCAT(DATE_FORMAT(CONCAT(IssueDate),'%d-%b-%Y %h:%i %p'),'#',IFNULL(PurposeName,''))  ");
        Query.Append("FROM t_transport_request WHERE VehicleID=VM.ID ORDER BY DATE(IssueDate) DESC,TIME(IssueDate) DESC LIMIT 1)),'')CurrentStatus, ");
        Query.Append("ifnull(IF(VM.Status=0,(SELECT CONCAT(DATE_FORMAT(CONCAT(AckDateTime),'%d-%b-%Y %h:%i %p'),'#',IFNULL(PurposeName,'')) ");
        Query.Append("FROM t_transport_request WHERE VehicleID=VM.ID AND IsAck=1 ORDER BY DATE(AckDateTime) DESC,TIME(AckDateTime) DESC LIMIT 1), ");
        Query.Append("(SELECT CONCAT(DATE_FORMAT(CONCAT(AckDateTime),'%d-%b-%Y %h:%i %p'),'#',IFNULL(PurposeName,''))  ");
        Query.Append("FROM t_transport_request WHERE VehicleID=VM.ID ORDER BY DATE(AckDateTime) DESC,TIME(AckDateTime) DESC LIMIT 1,1)),'')LastStatus,DATE_FORMAT(VS.NextServiceDate,'%d-%b-%Y')NextServiceDate ");
        Query.Append("FROM t_vehicle_master VM LEFT OUTER JOIN  (SELECT VehicleID,MAX(NextServiceDate)NextServiceDate FROM t_vehicle_servicing GROUP BY VehicleID HAVING DATE(MAX(NextServiceDate))>NOW()) ");
        Query.Append("VS ON VM.ID=VS.VehicleID ORDER BY VehicleName ");

        DataTable dt = StockReports.GetDataTable(Query.ToString());

        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

        return result;
    }

    [WebMethod(Description = "Bind Vehicle Patient")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindVehicleAmbulance()
    {
        DataTable vehicle = StockReports.GetDataTable("SELECT CONCAT(VM.VehicleName,' # ',VM.VehicleNo)Name, CONCAT(VM.Id,'#',PV.TravelID)Id FROM t_vehicle_master VM INNER JOIN t_patient_vehicle PV ON VM.ID=PV.VehicleID WHERE IsDirect=1 AND IsComplete=0 ORDER BY VM.VehicleName,VM.VehicleNo ");
        if (vehicle.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(vehicle);
        else
            return "";
    }


    [WebMethod(EnableSession = true, Description = "Get Status of Patient Vehicle Request")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string patientRequestStatus(string MRNo, string IPDNo, string FirstName, string LastName, string FromDate, string ToDate, string Status)
    {
        string result = "0";
        StringBuilder Query = new StringBuilder();

        Query.Append("SELECT pv.TokenNo ,PV.ID,PV.PatientID,'' IPDNo,'' TransactionID,PV.PName,Date_Format(PV.CreatedDate,'%d-%b-%Y')RequestDate,DATE_FORMAT(PV.BookingDate,'%d-%b-%Y')TravelDate,TIME_FORMAT(PV.BookingDate,'%h:%i %p')TravelTime,IFNULL(vm.VehicleType,'')VehicleType,PV.IsAck as IsComplete,pv.PurposeName Purpose,PV.PurposeID PurposeID, ");
        Query.Append("VM.VehicleNo,pv.Status,(SELECT NAME FROM t_driver_master td WHERE td.`ID`=pv.`DriverID`) `DriverName`,DATE_FORMAT(pv.IssueDate,'%d-%b-%Y')DepartureDate,TIME_FORMAT(pv.IssueDate,'%h:%i %p')DepartureTime,  ");
        Query.Append("DATE_FORMAT(pv.`BookingDate`,'%d-%b-%Y')ArrivalDate,TIME_FORMAT(pv.BookingDate,'%h:%i %p')ArrivalTime,IFNULL(Address,'') PlaceVisited,'' IsCancel,'' CancelDate,(SELECT CONCAT(Title,' ',NAME) FROM employee_master WHERE EmployeeID=PV.RejectionApprovedBy)CancelBy,'' CancelReason,pv.IsAck  ");
        Query.Append(" FROM t_transport_request PV  LEFT JOIN t_vehicle_master VM ON PV.VehicleID=VM.ID WHERE PV.IsDept=0 ");//LEFT JOIN t_travel_detail TD ON PV.TravelID=TD.ID

        if (MRNo != "")
        {
            Query.Append("AND PV.PatientID='" + MRNo + "' ");
        }

        //if (IPDNo != "")
        //{
        //    Query.Append("AND PV.TransactionID='" + string.Concat("ISHHI", IPDNo) + "' ");
        //}

        if (FirstName != "")
        {
            Query.Append("AND PV.PName LIKE '%" + FirstName + "%' ");
        }

        if (LastName != "")
        {
            Query.Append("AND PV.PName LIKE '%" + LastName + "%' ");
        }

        if (MRNo == "" && FirstName == "" && LastName == "")//&& IPDNo == ""
        {
            Query.Append("AND DATE(PV.CreatedDate)>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND DATE(PV.CreatedDate)<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' ");
        }

        if (Status != "0")
        {
            if (Status == "1")
            {
                //Query.Append("AND PV.IsComplete='0' AND PV.IsCancel='0' ");
                Query.Append(" and pv.Status='0' ");
            }
            else if (Status == "2")
            {
                Query.Append("AND PV.IsAck='0' AND pv.Status='1'  ");//AND PV.IsCancel='0'
            }
            else if (Status == "3")
            {
                Query.Append("AND PV.IsAck='1' AND pv.Status='1' ");//AND PV.IsCancel='0' 
            }
            //else if (Status == "4")
            //{
            //    Query.Append("AND PV.IsCancel='1' ");
            //}
        }

        Query.Append("ORDER BY DATE(PV.CreatedDate) ");

        DataTable dt = StockReports.GetDataTable(Query.ToString());

        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

        return result;
    }

    [WebMethod(EnableSession = true, Description = "Get Status of Department Vehicle Request")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string deptRequestStatus(string RequestID, string DepartmentID, string FromDate, string ToDate, string Status)
    {
        string result = "0";
        StringBuilder Query = new StringBuilder();

        Query.Append("SELECT DV.ID,DV.TokenNo as VehicleRequestID,(SELECT LedgerName FROM f_ledgermaster WHERE LedgerNumber=DV.DeptLedgerNo)DeptFrom,IFNULL(vm.VehicleType,'')VehicleType,DATE_FORMAT(DV.CreatedDate,'%d-%b-%Y')RequestDate,DATE_FORMAT(BookingDate,'%d-%b-%Y')TravelDate,  ");
        Query.Append("TIME_FORMAT(BookingDate,'%h:%i %p')TravelTime,DV.PurposeID PurposeID,dv.`PurposeName` Purpose,'0' IsApproved,'' ApprovedDate,  ");
        Query.Append("'' ApprovedBy,DV.IsAck as IsComplete,VM.VehicleNo,(SELECT NAME FROM t_driver_master td WHERE td.`ID`=dv.`DriverID`) `DriverName`,IFNULL(dv.Status,'')STATUS,DATE_FORMAT(dv.`IssueDate`,'%d-%b-%Y')DepartureDate,TIME_FORMAT(dv.IssueDate,'%h:%i %p')DepartureTime,  ");
        Query.Append("DATE_FORMAT(dv.`BookingDate`,'%d-%b-%Y')ArrivalDate,TIME_FORMAT(dv.`BookingDate`,'%h:%i %p')ArrivalTime,'' PlaceVisited,dv.IsAck ");
        Query.Append("FROM t_transport_request DV LEFT JOIN t_vehicle_master VM ON dv.VehicleID=VM.ID  ");// LEFT JOIN t_travel_detail TD ON DV.TravelID=TD.ID
        Query.Append("WHERE DV.TokenNo<>'' and dv.IsDept=1  ");

        if (RequestID != "")
        {
            Query.Append("AND DV.TokenNo='" + RequestID + "' ");
        }

        if (DepartmentID != "0")
        {
            Query.Append("AND DV.DeptLedgerNo='" + DepartmentID + "' ");
        }

        if (RequestID == "")
        {
            Query.Append("AND DATE(DV.CreatedDate)>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND DATE(DV.CreatedDate)<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' ");
        }

        if (Status != "0")
        {
            if (Status == "1")
            {
                Query.Append("AND dv.Status='0' ");
            }
            else if (Status == "2")
            {
                Query.Append("AND DV.IsAck='0' AND dv.Status='1' ");
            }
            else if (Status == "3")
            {
                Query.Append("AND DV.IsAck='1' AND dv.Status='1' ");
            }
        }

        Query.Append("ORDER BY DATE(DV.CreatedDate) ");

        DataTable dt = StockReports.GetDataTable(Query.ToString());

        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

        return result;
    }

    [WebMethod(EnableSession = true, Description = "Get Current Status of Vehicles")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string currentVehicleStatus()
    {
        string result = "0";
        StringBuilder Query = new StringBuilder();
        Query.Append("SELECT VehicleType,SUM(IF(VehicleType='Ambulance',1,0))Total,SUM(IF(VehicleType='Ambulance' AND STATUS=1,1,0))iOut,SUM(IF(VehicleType='Ambulance' AND STATUS=0,1,0))iIN FROM t_vehicle_master WHERE vehicletype='Ambulance'  and CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " GROUP BY VehicleType ");
        Query.Append("UNION ALL SELECT VehicleType,SUM(IF(VehicleType='Normal',1,0))Total,SUM(IF(VehicleType='Normal' AND STATUS=1,1,0))iOut,SUM(IF(VehicleType='Normal' AND STATUS=0,1,0))iIN FROM t_vehicle_master WHERE vehicletype='Normal'  and CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " GROUP BY VehicleType ");

        DataTable dt = StockReports.GetDataTable(Query.ToString());

        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

        return result;
    }

    [WebMethod(EnableSession = true, Description = "Get Current Status of Vehicles")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string currentRequestStatus(string Date, string Time, string VehicleType)
    {
        string IsNewDay = "0";
        DateTime StartDateTime;
        DateTime EndDateTime = Util.GetDateTime(string.Concat(Date, ' ', Time));
        if (EndDateTime.Date == DateTime.Today)
        {
            StartDateTime = DateTime.Now;
        }
        else
        {
            IsNewDay = "1";
            StartDateTime = Util.GetDateTime(string.Concat(Date, ' ', "12:01 AM"));
        }

        string result = "0";
        StringBuilder Query = new StringBuilder();
        Query.Append("SELECT 'Patient' AS 'RequestType',DATE_FORMAT(TravelDate,'%d-%b-%Y')TravelDate,TIME_FORMAT(TravelTime,'%h:%i %p')TravelTime,VehicleType,'" + IsNewDay + "' AS IsNewDay FROM t_patient_vehicle ");
        Query.Append("WHERE IsRequest=1 AND IsComplete=0 AND IsCancel=0 AND TIMESTAMP(CONCAT(TravelDate,' ',TravelTime)) BETWEEN '" + StartDateTime.ToString("yyyy-MM-dd HH:mm:ss") + "' AND '" + EndDateTime.ToString("yyyy-MM-dd HH:mm:ss") + "' ");

        if (VehicleType != "Select")
        {
            Query.Append("AND VehicleType='" + VehicleType + "' ");
        }

        Query.Append("UNION ALL ");
        Query.Append("SELECT 'Department' AS 'RequestType',DATE_FORMAT(TravelDate,'%d-%b-%Y')TravelDate,TIME_FORMAT(TravelTime,'%h:%i %p')TravelTime,VehicleType,'" + IsNewDay + "' AS IsNewDay FROM t_department_vehicle  ");
        Query.Append("WHERE IsRequest=1 AND IsApproved=1 AND IsComplete=0 AND IsCancel=0 AND TIMESTAMP(CONCAT(TravelDate,' ',TravelTime)) BETWEEN '" + StartDateTime.ToString("yyyy-MM-dd HH:mm:ss") + "' AND '" + EndDateTime.ToString("yyyy-MM-dd HH:mm:ss") + "' ");
        if (VehicleType != "Select")
        {
            Query.Append("AND VehicleType='" + VehicleType + "' ");
        }

        DataTable dt = StockReports.GetDataTable(Query.ToString());

        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

        return result;
    }


    [WebMethod(EnableSession = true, Description = "Update Request")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string updateRequest(string ID, string Date, string Time, string Purpose, string Cancel, string Type, string Reason)
    {
        string result = "0";
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string Query = "";

            if (Type == "0")
            {
                if (Cancel == "1")
                {
                    Query = "Update t_patient_vehicle set IsCancel=1,CancelBy='" + Util.GetString(HttpContext.Current.Session["ID"]) + "',CancelDate=NOW(),CancelReason='" + Reason + "' where ID='" + ID + "'";
                }
                else
                {
                    Query = "Update t_patient_vehicle set TravelDate='" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "',TravelTime='" + Util.GetDateTime(Time).ToString("HH:mm:ss") + "',Purpose='" + Purpose + "',UpdatedBy='" + Util.GetString(HttpContext.Current.Session["ID"]) + "',UpdatedDate=NOW() where ID='" + ID + "'";
                }
            }
            else if (Type == "1")
            {
                if (Cancel == "1")
                {
                    Query = "Update t_department_vehicle set IsCancel=1,CancelBy='" + Util.GetString(HttpContext.Current.Session["ID"]) + "',CancelDate=NOW(),CancelReason='" + Reason + "' where ID='" + ID + "'";
                }
                else
                {
                    Query = "Update t_department_vehicle set TravelDate='" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "',TravelTime='" + Util.GetDateTime(Time).ToString("HH:mm:ss") + "',Purpose='" + Purpose + "',UpdatedBy='" + Util.GetString(HttpContext.Current.Session["ID"]) + "',UpdatedDate=NOW() where ID='" + ID + "'";
                }

            }


            if (Query != "")
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, Query);

            tranx.Commit();
            tranx.Dispose();
            con.Close();
            con.Dispose();
            result = "1";
        }
        catch (Exception ex)
        {
            tranx.Rollback();
            tranx.Dispose();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }

        return result;
    }

    [WebMethod(EnableSession = true, Description = "Save Vehicle Reading")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SaveVehicleReading(object KM_basis, object Range_Basis, string VehicleID)
    {
        List<VehicleReading> dataRange = new JavaScriptSerializer().ConvertToType<List<VehicleReading>>(Range_Basis);
        List<VehicleReading> dataKM = new JavaScriptSerializer().ConvertToType<List<VehicleReading>>(KM_basis);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("UPDATE t_VehicleReading_Master SET IsActive=0,UpdatedDate=NOW(),UpdatedBy='" + Util.GetString(HttpContext.Current.Session["ID"]) + "' WHERE VehicleID='" + VehicleID + "'");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            for (int i = 0; i < dataRange.Count; i++)
            {
                sb.Clear();
                sb.Append("  INSERT INTO t_VehicleReading_Master (VehicleID,ReadingTypeID,RatePerKM,RangeFrom,RangeTo,RangeAmount,CreatedBy)    ");
                sb.Append(" VALUES('" + dataRange[i].VehicleID + "','2','" + dataRange[i].RatePerKM + "','" + dataRange[i].RangeFrom + "','" + dataRange[i].RangeTo + "','" + dataRange[i].RangeAmount + "','" + Util.GetString(HttpContext.Current.Session["ID"]) + "')  ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            }

            if (dataKM.Count > 0)
            {
                sb.Clear();
                sb.Append("  INSERT INTO t_VehicleReading_Master (VehicleID,ReadingTypeID,RatePerKM,RangeFrom,RangeTo,RangeAmount,CreatedBy)    ");
                sb.Append(" VALUES('" + dataKM[0].VehicleID + "','1','" + dataKM[0].RatePerKM + "','" + dataKM[0].RangeFrom + "','" + dataKM[0].RangeTo + "','" + dataKM[0].RangeAmount + "','" + Util.GetString(HttpContext.Current.Session["ID"]) + "')  ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
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

    class VehicleReading
    {
        private string _VehicleID;
        private string _ReadingTypeID;
        private decimal _RatePerKM;
        private decimal _RangeFrom;
        private decimal _RangeTo;
        private decimal _RangeAmount;

        public virtual string VehicleID { get { return _VehicleID; } set { _VehicleID = value; } }
        public virtual string ReadingTypeID { get { return _ReadingTypeID; } set { _ReadingTypeID = value; } }
        public virtual decimal RatePerKM { get { return _RatePerKM; } set { _RatePerKM = value; } }
        public virtual decimal RangeFrom { get { return _RangeFrom; } set { _RangeFrom = value; } }
        public virtual decimal RangeTo { get { return _RangeTo; } set { _RangeTo = value; } }
        public virtual decimal RangeAmount { get { return _RangeAmount; } set { _RangeAmount = value; } }
    }

    [WebMethod(Description = "Bind Vehicle Reading")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetVehicleReading(string VehicleID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT VRM.ID As VRM_ID,VRM.VehicleID,VM.VehicleName,VM.VehicleNo, ");
        sb.Append(" (CASE WHEN VRM.ReadingTypeID=1 THEN 'KM Basis' WHEN VRM.ReadingTypeID=2 THEN 'Range Basis' WHEN VRM.ReadingTypeID=3 THEN 'KM & Range Basis' ELSE '' END)ReadingType, ");
        sb.Append(" VRM.ReadingTypeID,IF(VRM.ReadingTypeID=1,VRM.RatePerKM,'-')RatePerKM,IF(VRM.ReadingTypeID=2,VRM.RangeFrom,'-')RangeFrom,IF(VRM.ReadingTypeID=2,VRM.RangeTo,'-')RangeTo,IF(VRM.ReadingTypeID=2,VRM.RangeAmount,'-')RangeAmount FROM  t_VehicleReading_Master VRM ");
        sb.Append(" INNER JOIN t_vehicle_master VM ON VRM.VehicleID=VM.ID ");
        sb.Append(" where VRM.IsActive=1 AND VRM.VehicleID='" + VehicleID + "' ");

        sb.Append(" order by  VRM.ID ");

        DataTable dtRange = StockReports.GetDataTable(sb.ToString());

        if (dtRange.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtRange);
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string OldPatientSearch(string PatientID)
    {
        string str = "SELECT pm.PatientID,CONCAT(pm.Title,' ',pm.PName)PName,CONCAT(pm.House_No,' ',pm.street_name)Address,pm.city,get_current_age(pm.PatientID)Age,pm.Mobile ContactNo,pm.Gender";
        str += " FROM patient_master pm where pm.PatientID='" + PatientID + "'";

        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod(EnableSession = true, Description = "Save Transport Request")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SaveTransportRequest(int Type, string PatientID, string PName, string Age, string Gender, string Mobile, string City, string Address, string BookingDate, string BookingTime)
    {
        string result = "0";
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string BookingDateTime = BookingDate + " " + BookingTime;
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT Get_ID_YearWise('Transport Requisition No','" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + "')");
            string RequisitionNo = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString()));
            sb.Clear();
            sb.Append("INSERT INTO t_transport_request(TokenNo,PatientID,Patient_Type,PName,Age,Gender,Mobile,City,Address,CreatedBy,BookingDate,CentreID) ");
            sb.Append(" VALUES('" + RequisitionNo + "','" + PatientID + "','" + Type + "','" + PName + "','" + Age + "','" + Gender + "','" + Mobile + "','" + City + "',");
            sb.Append(" '" + Address + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + Util.GetDateTime(BookingDateTime).ToString("yyyy-MM-dd HH:mm:ss") + "'," + HttpContext.Current.Session["CentreID"].ToString() + " )");
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString());

            tranx.Commit();
            tranx.Dispose();
            con.Close();
            con.Dispose();
            result = "1";
        }
        catch (Exception ex)
        {
            tranx.Rollback();
            tranx.Dispose();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }

        return result;
    }



    [WebMethod(EnableSession = true, Description = "Save Transport Request")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SaveTransportRequestPopUp(int Type, string PName, string Age, string Gender, string Mobile, string City, string Address, string BookingDate, string BookingTime)
    {
        string result = "0";
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string BookingDateTime = BookingDate + " " + BookingTime;
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT Get_ID_YearWise('Transport Requisition No','" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + "')");
            string RequisitionNo = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString()));
            sb.Clear();

            sb.Append("INSERT INTO t_transport_request(TokenNo,Patient_Type,PName,Age,Gender,Mobile,City,Address,CreatedBy,BookingDate,CentreID) ");
            sb.Append(" VALUES('" + RequisitionNo + "','" + Type + "','" + PName + "','" + Age + "','" + Gender + "','" + Mobile + "','" + City + "','" + Address + "',");
            sb.Append(" '" + HttpContext.Current.Session["ID"].ToString() + "','" + Util.GetDateTime(BookingDateTime).ToString("yyyy-MM-dd HH:mm:ss") + "'," + HttpContext.Current.Session["CentreID"].ToString() + ")");
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString());

            tranx.Commit();
            tranx.Dispose();
            con.Close();
            con.Dispose();
            result = "1";
        }
        catch (Exception ex)
        {
            tranx.Rollback();
            tranx.Dispose();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        return result;
    }

    [WebMethod(EnableSession = true, Description = "Get Current Status of Vehicles")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string AvailableVehicleList()
    {
        string result = "0";
        StringBuilder Query = new StringBuilder();
        Query.Append("SELECT VehicleNo,VehicleName,RcNo,Model,VehicleType FROM t_vehicle_master WHERE IsActive=1  and CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " AND `Status`=0");
        DataTable dt = StockReports.GetDataTable(Query.ToString());
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        return result;
    }

    [WebMethod(EnableSession = true, Description = "Get Token Detail")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string TokenDetail(string TokenNo)
    {
        string result = "0";
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT tr.TokenNo,IFNULL(tr.PatientID,'')MRNo,IF(tr.Patient_Type=0,'New','Old')PType,tr.PName,tr.Age,tr.Gender,tr.Mobile,tr.City,tr.Address, ");
        sb.Append(" tr.BookingDate,DATE_FORMAT(tr.CreatedDate,'%d-%b-%Y')CreatedDate,CONCAT(em1.Title,' ',em1.Name)CreatedBy,DATE_FORMAT(IssueDate,'%d-%b-%Y')IssueDate, ");
        sb.Append(" CONCAT(em2.Title,' ',em2.Name)IssueBy,VehicleID,vm.VehicleName,vm.ModelNo,DriverID,vm.LastReading FROM `t_transport_request` tr ");
        sb.Append(" INNER JOIN Employee_Master em1 ON em1.EmployeeID=tr.CreatedBy ");
        sb.Append(" INNER JOIN Employee_Master em2 ON em2.EmployeeID=tr.IssueBy ");
        sb.Append(" INNER JOIN t_vehicle_master vm ON vm.ID=tr.VehicleID ");
        sb.Append(" WHERE tr.IsDept=0 AND tr.IsPaymentDone=0 AND tr.`Status`=1 and tr.CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " ");

        if (TokenNo != "")
        {
            sb.Append(" and tr.TokenNo='" + TokenNo + "' ");
        }

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        return result;
    }



    [WebMethod(Description = "Bind Vehicle Reading")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetVehicleReadingNew(string VehicleID, string ReadingTypeID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT VRM.ID As VRM_ID,VRM.VehicleID,VM.VehicleName,VM.VehicleNo, ");
        sb.Append(" (CASE WHEN VRM.ReadingTypeID=1 THEN 'KM Basis' WHEN VRM.ReadingTypeID=2 THEN 'Range Basis' WHEN VRM.ReadingTypeID=3 THEN 'KM & Range Basis' ELSE '' END)ReadingType, ");
        sb.Append(" VRM.ReadingTypeID,IF(VRM.ReadingTypeID=1,VRM.RatePerKM,'-')RatePerKM,IF(VRM.ReadingTypeID=2,VRM.RangeFrom,'-')RangeFrom,IF(VRM.ReadingTypeID=2,VRM.RangeTo,'-')RangeTo,IF(VRM.ReadingTypeID=2,VRM.RangeAmount,'-')RangeAmount,VM.LastReading FROM  t_VehicleReading_Master VRM ");
        sb.Append(" INNER JOIN t_vehicle_master VM ON VRM.VehicleID=VM.ID ");
        sb.Append(" where VRM.IsActive=1 AND VRM.VehicleID='" + VehicleID + "' ");
        if (ReadingTypeID != "" && ReadingTypeID != "undefined")
        {
            sb.Append(" AND VRM.ReadingTypeID='" + ReadingTypeID + "' ");
        }
        sb.Append(" order by  VRM.ID ");
        DataTable dtRange = StockReports.GetDataTable(sb.ToString());

        if (dtRange.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtRange);
        else
            return "";
    }

    [WebMethod(Description = "Load Ambulance Charges Detail")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string LoadAmbulanceChargesDetail(string ItemID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT item,CONCAT(ItemID,'#',SubCategoryID,'#',CAST(LabType AS BINARY),'#',IFNULL(Type_ID,''),'#',IF(Sample='R',Sample,'N'),'#',TnxType, ");
        sb.Append(" '#',IFNULL(ItemCode,''),'#',IFNULL(GenderInvestigate,''),'#',isadvance,'#',IFNULL(IsOutSource,0),'#',RateEditable ) ItemID ,TnxType, ");
        sb.Append(" SubCategoryID, categoryid,ItemID NewItemID FROM(SELECT im.isadvance,CONCAT(IFNULL(im.ItemCode,''),' # ',im.TypeName) Item, ");
        sb.Append(" im.RateEditable, ims.GenderInvestigate,im.ItemID,im.SubCategoryID,im.Type_ID,IFNULL(im.ItemCode,'')ItemCode, sm.categoryid , ");
        sb.Append(" (CASE WHEN cr.ConfigID=3 THEN 'LAB' WHEN cr.ConfigID IN (25) THEN 'PRO' WHEN cr.ConfigID IN (7) THEN 'BB' ");
        sb.Append(" WHEN cr.ConfigID IN (20,6)  THEN 'OTH' WHEN cr.ConfigID IN (3,25,20,6)  THEN 'OPD-BILLING' END)LabType, ");
        sb.Append(" (CASE WHEN cr.ConfigID=3 THEN '3' WHEN cr.ConfigID IN (25) THEN '4' WHEN cr.ConfigID IN (7) THEN '6' ");
        sb.Append(" WHEN cr.ConfigID IN(20,6) THEN '5' WHEN cr.ConfigID IN (3,25,20,6) THEN '16' END)TnxType , ");
        sb.Append(" (SELECT TYPE FROM Investigation_master WHERE Investigation_ID=im.Type_ID)Sample,IsOutSource  FROM f_itemmaster im  ");
        sb.Append(" LEFT JOIN investigation_master ims ON ims.Investigation_Id = im.Type_ID  ");
        sb.Append(" INNER JOIN f_subcategorymaster sm ON sm.subcategoryid = im.subcategoryid ");
        sb.Append(" INNER JOIN f_configrelation  cr ON cr.categoryid = sm.categoryid  ");
        sb.Append(" WHERE cr.ConfigID IN (3,25,6,20,7) AND im.ItemID='" + Resources.Resource.TransportItemID + "' ");
        sb.Append(" AND im.IsActive=1 )t1 ORDER BY Item ");

        DataTable dtRange = StockReports.GetDataTable(sb.ToString());

        if (dtRange.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtRange);
        else
            return "";
    }


    [WebMethod(EnableSession = true, Description = "Save Transport")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string saveTransport(object PM, object PMH, object LT, object LTD, object PaymentDetail, string TokenNo, string PatientID, string Patient_Type, string PName, string Age, string Sex, string ContactNo, string City, string Address, string VehicleID, string DriverID, string LastReading, string MeterReading, int ReadingTypeID, int VRM_ID)
    {
        List<Patient_Medical_History> dataPMH = new JavaScriptSerializer().ConvertToType<List<Patient_Medical_History>>(PMH);
        List<Ledger_Transaction> dataLT = new JavaScriptSerializer().ConvertToType<List<Ledger_Transaction>>(LT);
        List<LedgerTnxDetail> dataLTD = new JavaScriptSerializer().ConvertToType<List<LedgerTnxDetail>>(LTD);
        List<Ledger_Transaction_PaymentDetail> dataPaymentDetail = new JavaScriptSerializer().ConvertToType<List<Ledger_Transaction_PaymentDetail>>(PaymentDetail);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            string patientID = string.Empty, TransactionId = string.Empty, BillNO = string.Empty, LedTxnID = string.Empty, ReceiptNo = string.Empty;
            string isBloodBankItem = "0";

            var PatientMasterInfo = Insert_PatientInfo.savePatientMaster(PM, tnx, con);
            if (PatientMasterInfo.Count == 0)
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.errorMessage });
            }
            else
                patientID = PatientMasterInfo[0].PatientID;

            TransactionId = Insert_PatientInfo.savePMH(dataPMH, patientID, 0, "", "OPD", "OPD-Lab", tnx, con);
            if (TransactionId == "")
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
            }


            EncounterNo = Encounter.FindEncounterNo(PatientID);

            if (EncounterNo == 0)
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In Encounter No." });

            }


            Ledger_Transaction ObjLdgTnx = new Ledger_Transaction(tnx);

            ObjLdgTnx.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            ObjLdgTnx.LedgerNoCr = "OPD003";
            ObjLdgTnx.LedgerNoDr = "HOSP0001";

            int iCtr = 0, iNum = 0;
            iNum = Util.GetInt(dataLTD.Count(s => s.Type.Contains("LAB")));
            if (iNum > 0) iCtr += 1;
            iNum = Util.GetInt(dataLTD.Count(s => s.Type.Contains("PRO")));
            if (iNum > 0) iCtr += 1;
            iNum = Util.GetInt(dataLTD.Count(s => s.Type.Contains("OTH")));
            if (iNum > 0) iCtr += 1;


            if (iCtr == 1)
            {
                if (Util.GetString(dataLTD[0].Type) == "LAB")
                    ObjLdgTnx.TypeOfTnx = "OPD-LAB";
                else if (Util.GetString(dataLTD[0].Type) == "PRO")
                    ObjLdgTnx.TypeOfTnx = "OPD-PROCEDURE";
                else
                    ObjLdgTnx.TypeOfTnx = "OPD-OTHERS";
            }
            else
            {
                ObjLdgTnx.TypeOfTnx = "OPD-BILLING";
            }

            ObjLdgTnx.Date = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
            ObjLdgTnx.Time = Util.GetDateTime(DateTime.Now.ToString("HH:mm:ss"));
            ObjLdgTnx.NetAmount = Util.GetDecimal(dataLT[0].NetAmount);
            ObjLdgTnx.GrossAmount = Util.GetDecimal(dataLT[0].GrossAmount);
            ObjLdgTnx.PatientID = patientID;
            ObjLdgTnx.PanelID = dataPMH[0].PanelID;
            ObjLdgTnx.TransactionID = TransactionId;
            ObjLdgTnx.UserID = HttpContext.Current.Session["ID"].ToString();
            ObjLdgTnx.DiscountReason = dataLT[0].DiscountReason.Trim();
            ObjLdgTnx.DiscountApproveBy = dataLT[0].DiscountApproveBy.Trim();
            ObjLdgTnx.DiscountOnTotal = dataLT[0].DiscountOnTotal;

            ObjLdgTnx.BillNo = SalesEntry.genBillNo(tnx, Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()), con);
            isBloodBankItem = "0";
            excuteCMD.DML(tnx, "UPDATE patient_medical_history SET BillNo=@BillNo,BillDate=@BillDate,BillGeneratedBy=@BillGeneratedBy WHERE TransactionID=@TransactionID", CommandType.Text, new
            {
                BillNo = ObjLdgTnx.BillNo,
                BillDate = Util.GetDateTime(DateTime.Now),
                BillGeneratedBy = ObjLdgTnx.UserID,
                TransactionID = TransactionId
            });

            if (ObjLdgTnx.BillNo == "")
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
            }
            ObjLdgTnx.BillDate = Util.GetDateTime(DateTime.Now);
            ObjLdgTnx.RoundOff = dataLT[0].RoundOff;
            ObjLdgTnx.PaymentModeID = Util.GetInt(dataPaymentDetail[0].PaymentModeID);
            ObjLdgTnx.UniqueHash = dataLT[0].UniqueHash;
            ObjLdgTnx.IpAddress = All_LoadData.IpAddress();
            ObjLdgTnx.Adjustment = dataLT[0].Adjustment;
            ObjLdgTnx.GovTaxPer = Util.GetDecimal(dataLT[0].GovTaxPer);
            ObjLdgTnx.GovTaxAmount = Util.GetDecimal(dataLT[0].GovTaxAmount);
            if (dataPaymentDetail[0].PaymentMode.ToString() != "Credit" && (dataLT[0].Adjustment > 0))
                ObjLdgTnx.IsPaid = 1;
            else
                ObjLdgTnx.IsPaid = 0;
            ObjLdgTnx.IsCancel = 0;
            ObjLdgTnx.IPNo = Util.GetString(dataLT[0].IPNo.Trim());
            ObjLdgTnx.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            ObjLdgTnx.PatientType = "";
            ObjLdgTnx.CurrentAge = "";
            ObjLdgTnx.PatientType_ID = 0;

            ObjLdgTnx.EncounterNo = Util.GetInt(EncounterNo);

            string LedgerTransactionNo = ObjLdgTnx.Insert();

            if (LedgerTransactionNo == "")
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
            }
            for (int i = 0; i < dataLTD.Count; i++)
            {
                LedgerTnxDetail ObjLdgTnxDtl = new LedgerTnxDetail(tnx);
                ObjLdgTnxDtl.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
                ObjLdgTnxDtl.LedgerTransactionNo = LedgerTransactionNo;
                ObjLdgTnxDtl.ItemID = Util.GetString(dataLTD[i].ItemID).Trim();
                ObjLdgTnxDtl.Rate = Util.GetDecimal(dataLTD[i].Rate);
                ObjLdgTnxDtl.Quantity = Util.GetDecimal(dataLTD[i].Quantity);
                ObjLdgTnxDtl.StockID = "";
                ObjLdgTnxDtl.IsTaxable = "NO";

                ObjLdgTnxDtl.DiscAmt = Util.GetDecimal(dataLTD[i].DiscAmt);
                if (Util.GetDecimal(dataLTD[i].Rate) == 0)
                    ObjLdgTnxDtl.DiscountPercentage = 0;
                else
                    ObjLdgTnxDtl.DiscountPercentage = (Util.GetDecimal(dataLTD[i].DiscAmt) * 100) / ((Util.GetDecimal(dataLTD[i].Rate)) * (Util.GetDecimal(dataLTD[i].Quantity)));

                ObjLdgTnxDtl.Amount = (Util.GetDecimal(dataLTD[i].Amount)) + (((Util.GetDecimal(dataLTD[i].Amount)) * (Util.GetDecimal(dataLT[0].GovTaxPer))) / 100);

                ObjLdgTnxDtl.IsPackage = 0;
                ObjLdgTnxDtl.PackageID = "";
                ObjLdgTnxDtl.IsVerified = 1;
                ObjLdgTnxDtl.TransactionID = TransactionId;
                ObjLdgTnxDtl.SubCategoryID = Util.GetString(dataLTD[i].SubCategoryID).Trim();
                ObjLdgTnxDtl.ItemName = Util.GetString(dataLTD[i].ItemName).Trim();
                ObjLdgTnxDtl.UserID = HttpContext.Current.Session["ID"].ToString();
                ObjLdgTnxDtl.EntryDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                ObjLdgTnxDtl.DiscountReason = dataLTD[i].DiscountReason.Trim();
                ObjLdgTnxDtl.DoctorID = dataLTD[i].DoctorID.Trim();
                ObjLdgTnxDtl.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(dataLTD[i].SubCategoryID), con));
                ObjLdgTnxDtl.TnxTypeID = Util.GetInt(dataLTD[i].TnxTypeID);
                ObjLdgTnxDtl.NetItemAmt = ObjLdgTnxDtl.Amount;
                ObjLdgTnxDtl.TotalDiscAmt = Util.GetDecimal(dataLTD[i].DiscAmt);
                ObjLdgTnxDtl.pageURL = All_LoadData.getCurrentPageName();
                ObjLdgTnxDtl.RateListID = dataLTD[i].RateListID;
                ObjLdgTnxDtl.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                ObjLdgTnxDtl.Type = "O";
                ObjLdgTnxDtl.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                ObjLdgTnxDtl.IpAddress = All_LoadData.IpAddress();
                ObjLdgTnxDtl.rateItemCode = "";
                ObjLdgTnxDtl.VerifiedDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                ObjLdgTnxDtl.VarifiedUserID = HttpContext.Current.Session["ID"].ToString();
                ObjLdgTnxDtl.DeptLedgerNo = HttpContext.Current.Session["DeptLedgerNo"].ToString();
                ObjLdgTnxDtl.typeOfTnx = ObjLdgTnx.TypeOfTnx;
                string LdgTnxDtlID = ObjLdgTnxDtl.Insert().ToString();
                if (LdgTnxDtlID == "")
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
                }

            }

            ////////////////////////////// Insert in Receipt ///////////////////
            int IsBill = 1;
            if ((dataPaymentDetail[0].PaymentMode.ToString() != "Credit") && (dataLT[0].Adjustment > 0))
            {
                Receipt ObjReceipt = new Receipt(tnx);
                ObjReceipt.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                ObjReceipt.AmountPaid = dataLT[0].Adjustment;
                ObjReceipt.AsainstLedgerTnxNo = LedgerTransactionNo.Trim();
                ObjReceipt.Date = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                ObjReceipt.Time = Util.GetDateTime(DateTime.Now.ToString("HH:mm:ss"));
                ObjReceipt.Depositor = PatientID;
                ObjReceipt.Discount = 0;
                ObjReceipt.PanelID = dataPMH[0].PanelID;
                ObjReceipt.Reciever = HttpContext.Current.Session["ID"].ToString();
                ObjReceipt.Depositor = PatientID;
                ObjReceipt.TransactionID = TransactionId;
                ObjReceipt.RoundOff = dataLT[0].RoundOff;
                ObjReceipt.LedgerNoCr = "OPD003";
                ObjReceipt.LedgerNoDr = "HOSP0001";
                ObjReceipt.PaidBy = "PAT";
                ObjReceipt.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                ObjReceipt.IpAddress = All_LoadData.IpAddress();
                IsBill = 0;
                ObjReceipt.isBloodBankItem = isBloodBankItem;
                ReceiptNo = ObjReceipt.Insert();
                if (ReceiptNo == "")
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
                }
                Receipt_PaymentDetail ObjReceiptPayment = new Receipt_PaymentDetail(tnx);
                for (int i = 0; i < dataPaymentDetail.Count; i++)
                {
                    ObjReceiptPayment.PaymentModeID = Util.GetInt(dataPaymentDetail[i].PaymentModeID);
                    ObjReceiptPayment.PaymentMode = Util.GetString(dataPaymentDetail[i].PaymentMode);
                    ObjReceiptPayment.Amount = Util.GetDecimal(dataPaymentDetail[i].Amount);
                    ObjReceiptPayment.ReceiptNo = ReceiptNo;
                    ObjReceiptPayment.PaymentRemarks = Util.GetString(dataPaymentDetail[i].PaymentRemarks);
                    ObjReceiptPayment.RefDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                    ObjReceiptPayment.RefNo = Util.GetString(dataPaymentDetail[i].RefNo);
                    ObjReceiptPayment.BankName = Util.GetString(dataPaymentDetail[i].BankName);
                    ObjReceiptPayment.C_Factor = Util.GetDecimal(dataPaymentDetail[i].C_Factor);
                    ObjReceiptPayment.S_Amount = Util.GetDecimal(dataPaymentDetail[i].S_Amount);
                    ObjReceiptPayment.S_CountryID = Util.GetInt(dataPaymentDetail[i].S_CountryID);
                    ObjReceiptPayment.S_Currency = Util.GetString(dataPaymentDetail[i].S_Currency);
                    ObjReceiptPayment.S_Notation = Util.GetString(dataPaymentDetail[i].S_Notation);

                    ObjReceiptPayment.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    ObjReceiptPayment.Hospital_ID = Util.GetString(HttpContext.Current.Session["HOSPID"].ToString());
                    string PaymentID = ObjReceiptPayment.Insert().ToString();
                    if (PaymentID == "")
                    {
                        tnx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
                    }
                }

            }
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE t_transport_request SET VRM_ID='" + VRM_ID + "',ReadingTypeID='" + ReadingTypeID + "',LedgerTnxNo='" + LedgerTransactionNo + "',IsPaymentDone=1,MeterReading='" + MeterReading + "',BillingUserID='" + HttpContext.Current.Session["ID"].ToString() + "',BillingDateTime=now(),PatientID='" + PatientID + "'  where TokenNo='" + TokenNo + "'");
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage, LedgerTransactionNo = LedgerTransactionNo, IsBill = IsBill });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.errorMessage });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true, Description = "Acknowledge Vehicle After Payment Done")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string AckVehicle()
    {
        string result = "0";
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT tr.`VehicleID`,vm.VehicleNo,vm.VehicleName,vm.RcNo,vm.Model,vm.VehicleType,vm.LastReading,tr.TokenNo,tr.MeterReading,  ");
        sb.Append(" (CASE WHEN tr.ReadingTypeID=1 THEN 'KM Basis' WHEN tr.ReadingTypeID=2 THEN 'Range Basis' ELSE '' END)ReadingType, ");
        sb.Append(" CONCAT(em1.Title,' ',em1.Name)BillingUser,tr.ReadingTypeID,tr.BilledAmount,tr.KmRun FROM t_vehicle_master vm  ");
        sb.Append(" INNER JOIN t_transport_request tr ON tr.VehicleID=vm.ID ");
        sb.Append(" INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=tr.LedgerTnxNo ");
        sb.Append(" INNER JOIN Employee_Master em1 ON em1.EmployeeID=tr.BillingUserID  ");
        sb.Append(" WHERE vm.IsActive=1 AND vm.Status=1 AND tr.IsPaymentDone=1 AND tr.IsAck=0 AND tr.IsDept=0 and tr.CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + "");
        sb.Append(" UNION ALL ");
        sb.Append(" SELECT tr.`VehicleID`,vm.VehicleNo,vm.VehicleName,vm.RcNo,vm.Model,vm.VehicleType,vm.LastReading,tr.TokenNo,tr.MeterReading,  ");
        sb.Append(" (CASE WHEN tr.ReadingTypeID=1 THEN 'KM Basis' WHEN tr.ReadingTypeID=2 THEN 'Range Basis' ELSE '' END)ReadingType,tr.DeptName BillingUser,tr.ReadingTypeID,tr.BilledAmount,tr.KmRun FROM t_vehicle_master vm  ");
        sb.Append(" INNER JOIN t_transport_request tr ON tr.VehicleID=vm.ID  ");
        sb.Append(" WHERE tr.Status=1 AND  vm.Status=1 AND tr.IsAck=0 AND tr.IsDept=1 and tr.CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " ");


        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        return result;
    }

    [WebMethod(EnableSession = true, Description = "")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string AckToken(string TokenNo, string MeterReading, string LastReading, string KmRun, string BilledAmount, string Rate)
    {
        string result = "0";
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" UPDATE t_transport_request SET KmRun='" + KmRun + "',BilledAmount='" + BilledAmount + "',Rate='" + Rate + "', IsAck=1,AckUserID='" + HttpContext.Current.Session["ID"].ToString() + "',AckDateTime=now(), ");
            sb.Append(" MeterReadingAck='" + Util.GetDecimal(MeterReading) + "',LastReading='" + LastReading + "' where TokenNo='" + TokenNo + "'  ");
            MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, sb.ToString());
            string VehicleID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "select VehicleID from t_transport_request WHERE TokenNo ='" + TokenNo + "'"));
            string DriverID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "select DriverID from t_transport_request WHERE TokenNo ='" + TokenNo + "'"));

            MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, "UPDATE t_vehicle_master SET LastReading='" + Util.GetDecimal(MeterReading) + "',Status=0 where ID='" + VehicleID + "'");
            MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, "UPDATE t_driver_master SET Status=0 where ID='" + DriverID + "'");

            tranx.Commit();
            tranx.Dispose();
            con.Close();
            con.Dispose();

            sb = new StringBuilder();

            sb.Append("  SELECT tr.`TokenNo` TokenNo,  ");
            sb.Append(" IF(tr.`IsDept`=0,CONCAT(IFNULL(tr.`PName`,''),  ");
            sb.Append(" '(',IFNULL(tr.`PatientID`,'New Patient'),')'),CONCAT(IFNULL(tr.`DeptName`,''),' ','Department'))IssuedFor,    ");
            sb.Append(" CONCAT(tr.`Address`,',',tr.`City`)DestinationAddress,DATE_FORMAT(tr.`BookingDate`,'%d-%b-%Y %h:%i %p') BookingDate,  ");
            sb.Append("  (SELECT CONCAT(vm.`VehicleName`,'(',vm.VehicleNo,')') FROM `t_vehicle_master` vm WHERE vm.`ID`=tr.`VehicleID`)Vehicle,  ");
            sb.Append("  (SELECT vm.`VehicleType` FROM `t_vehicle_master` vm WHERE vm.`ID`=tr.`VehicleID`)VehicleType,  ");
            sb.Append("  (SELECT dm.`Name` FROM t_driver_master dm WHERE dm.`ID`=tr.`DriverID`)Driver,  ");
            sb.Append("  (SELECT CONCAT(em.`Title`,' ',em.`Name`) FROM employee_master em WHERE em.`EmployeeID`=tr.`IssueBy`)IssuedBy,  ");
            sb.Append("  tr.`MeterReadingAck`,ROUND(tr.`LastReading`,2)LastReading,tr.`Rate`,tr.`BilledAmount`,tr.`KmRun`   ");

            sb.Append(" FROM t_transport_request tr WHERE tr.`TokenNo`='" + TokenNo.Trim() + "'  ");

            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());
                Session["ds"] = ds;
                Session["ReportName"] = "VehicleAckPrint";
            }
            
            result = "1";
        }
        catch (Exception ex)
        {
            tranx.Rollback();
            tranx.Dispose();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        return result;
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string TransportTransactionDetails(string ReportType, string fromDate, string ToDate, int Category, int VehicalId, string CentreIDs)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT cm.CentreID,cm.CentreName, `Type`,VehicleName,Driver,DriverMobileNo,BillingDateTime,Amount,TotalReading FROM");
        sb.Append("( SELECT  tr.CentreID, 'Patient Request' `Type`,vm.VehicleName,vm.ModelNo, dm.Name 'Driver',dm.Mobile 'DriverMobileNo', ");
        sb.Append("  IFNULL(DATE_FORMAT(tr.BillingDateTime,'%d-%b-%Y'),'')BillingDateTime,ltd.`Amount` `Amount`,tr.BillingDateTime 'Date',CONCAT(ROUND(IF((IFNULL(tr.MeterReadingAck,0)-IFNULL(tr.LastReading,0))<0,0,(IFNULL(tr.MeterReadingAck,0)-IFNULL(tr.LastReading,0))),2),' KM') TotalReading    ");
        sb.Append("  FROM t_transport_request tr ");
        sb.Append("  INNER JOIN t_vehicle_master vm ON tr.VehicleID=vm.ID ");
        sb.Append("  INNER JOIN t_driver_master dm ON tr.DriverID=dm.ID  ");
        sb.Append("  INNER JOIN f_ledgertnxDetail ltd ON ltd.`LedgerTransactionNo`=tr.`LedgerTnxNo` ");
        sb.Append("  LEFT JOIN employee_master em3 ON tr.BillingUserID=em3.EmployeeID ");
        sb.Append("  WHERE IsDept=0 AND tr.`IsPaymentDone`=1 and tr.CentreID in(" + CentreIDs + ") ");
        if (VehicalId != 0)
        {
            sb.Append(" And vm.ID =" + VehicalId);
        }
        sb.Append("  UNION ALL ");
        sb.Append("  SELECT  tr.CentreID, 'Department Request' `Type`,vm.VehicleName,vm.ModelNo, dm.Name 'Driver',dm.Mobile 'Driver Mobile No',");
        sb.Append("  IFNULL(DATE_FORMAT(tr.BillingDateTime,'%d-%b-%Y'),'')BillingDateTime ,'0' `Amount`,tr.AckDateTime 'Date',CONCAT(ROUND(IF((IFNULL(tr.MeterReadingAck,0)-IFNULL(tr.LastReading,0))<0,0,(IFNULL(tr.MeterReadingAck,0)-IFNULL(tr.LastReading,0))),2),' KM') TotalReading    ");
        sb.Append("  FROM t_transport_request tr  ");
        sb.Append("  INNER JOIN t_vehicle_master vm ON tr.VehicleID=vm.ID ");
        sb.Append("  INNER JOIN t_driver_master dm ON tr.DriverID=dm.ID  ");
        sb.Append("  LEFT JOIN employee_master em3 ON tr.BillingUserID=em3.EmployeeID ");
        sb.Append("  WHERE IsDept=1 AND tr.`Status`=1 and tr.CentreID in(" + CentreIDs + ") ");
        if (VehicalId != 0)
        {
            sb.Append(" And vm.ID =" + VehicalId);
        }
        sb.Append("  UNION ALL");
        sb.Append("  SELECT  fe.CentreID, 'Fuel_Entry' `Type`,vm.VehicleName,vm.ModelNo, dm.Name 'Driver',dm.Mobile 'DriverMobileNo', ");
        sb.Append("  IFNULL(DATE_FORMAT(fe.EntryDate,'%d-%b-%Y'),'')BillingDateTime,fe.TotalAmount `Amount` ,  fe.EntryDate 'Date',CONCAT(fe.`Letter`,' L') TotalReading  ");
        sb.Append("  FROM t_fuel_entry fe ");
        sb.Append("  INNER JOIN t_vehicle_master vm ON fe.VehicleID=vm.ID ");
        sb.Append("  INNER JOIN t_driver_master dm ON fe.DriverID=dm.ID and fe.CentreID in(" + CentreIDs + ") ");
        if (VehicalId != 0)
        {
            sb.Append(" Where vm.ID =" + VehicalId);
        }
        sb.Append("  UNION ALL ");
        sb.Append("  SELECT  vs.CentreID, 'Vehicle Servicing' `Type`,vm.VehicleName,vm.ModelNo, dm.Name 'Driver',dm.Mobile 'DriverMobileNo', ");
        sb.Append("  IFNULL(DATE_FORMAT(vs.CurServiceDate,'%d-%b-%Y'),'')BillingDateTime,vs.Amount `Amount` ,vs.CurServiceDate 'Date','' TotalReading ");
        sb.Append("  FROM t_vehicle_servicing vs");
        sb.Append("  INNER JOIN t_vehicle_master vm ON vs.VehicleID=vm.ID ");
        sb.Append("  INNER JOIN t_driver_master dm ON vs.DriverID=dm.ID ");
        sb.Append("  WHERE vs.IsService=0 and vs.CentreID in(" + CentreIDs + ") ");
        if (VehicalId != 0)
        {
            sb.Append(" And vm.ID =" + VehicalId);
        }
        sb.Append("  UNION ALL ");
        sb.Append("  SELECT  vs.CentreID, 'Vehicle Maintenance' `Type`,vm.VehicleName,vm.ModelNo, dm.Name 'Driver',dm.Mobile 'DriverMobileNo',");
        sb.Append("  IFNULL(DATE_FORMAT(vs.MaintenanceDate,'%d-%b-%Y'),'')BillingDateTime,vs.Amount `Amount` ,vs.MaintenanceDate 'Date','' TotalReading ");
        sb.Append("  FROM t_vehicle_servicing vs ");
        sb.Append("  INNER JOIN t_vehicle_master vm ON vs.VehicleID=vm.ID ");
        sb.Append("  INNER JOIN t_driver_master dm ON vs.DriverID=dm.ID ");
        sb.Append("  WHERE vs.IsService=1 and vs.CentreID in(" + CentreIDs + ") ");
        if (VehicalId != 0)
        {
            sb.Append(" And vm.ID =" + VehicalId);
        }
        sb.Append("  )t INNER JOIN center_master cm ON cm.CentreID= t.CentreID ");
        string Type = "";
        if (Category != 0)
        {

            if (Category == 1)
            {
                Type = "Department Request";
            }
            else if (Category == 3)
            {
                Type = "Vehicle Servicing";
            }
            else if (Category == 4)
            {
                Type = "Vehicle Maintenance";
            }
            else if (Category == 5)
            {
                Type = "Fuel_Entry";
            }
            else
            {
                Type = "Patient Request";
            }
            //sb.Append("WHERE t.Type ='" + Type + "'");
        }
        if (fromDate != "" && ToDate != "" && Category == 0)
        {
            sb.Append("WHERE DATE(t.Date)>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND DATE(t.Date)<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'");
        }
        else if (fromDate != "" && ToDate != "" && Category != 0)
        {
            sb.Append("WHERE DATE(t.Date)>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND DATE(t.Date)<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' And t.Type ='" + Type + "'");
        }
        else if (fromDate == "" && ToDate == "" && Category != 0)
        {
            sb.Append("WHERE  t.Type ='" + Type + "'");
        }
        sb.Append(" ORDER BY t.Type ");
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            if (ReportType == "Exl")
            {

                Session["dtExport2Excel"] = dt;
                Session["ReportName"] = "TransportTransactionReport";
                Session["Period"] = "From : " + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(ToDate).ToString("dd-MMM-yyyy");

                return "Exl";
            }
            else if (ReportType == "pdf")
            {
                DataColumn dc = new DataColumn();
                dc.ColumnName = "ReportDate";
                dc.DefaultValue = "From : " + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(ToDate).ToString("dd-MMM-yyyy");
                dt.Columns.Add(dc);
                dc = new DataColumn();
                dc.ColumnName = "UserName";
                dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
                dt.Columns.Add(dc);

                //  DataTable dtImg = All_LoadData.CrystalReportLogo();

                DataSet ds = new DataSet();
                //ds.Tables.Add(dtImg.Copy());
                // ds.Tables[0].TableName = "Logo";
                ds.Tables.Add(dt.Copy());
                ds.Tables[0].TableName = "table";

                //   ds.WriteXmlSchema(@"D:\TransportTransactionReport.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "TransportTransactionReport";
                // ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "", true);
                return "pdf";
            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
        }
        else
        {
            return "";
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string TransportDetailreport(string ReportType, string fromDate, string ToDate, int Category, int VehicalId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT `Type`,TokenNo,MRNo,Patient_Type,PName,Age,Gender,Mobile,City,Address,BookingDate,`Status`,CreatedDate,CreatedBy,IssueDate,IssuedBy,VehicleName,ModelNo,");
        sb.Append(" LastReading,Driver,DriverMobileNo,Payment,MeterReading,BillingUser,BillingDateTime,AckUser,AckDateTime,ReadingType,MeterReadingAck  FROM (");
        sb.Append(" SELECT tr.id,'Patient Request' `Type`,tr.TokenNo,IFNULL(tr.PatientID,'')MRNo,IF(tr.Patient_Type=1,'Old','New')Patient_Type,tr.PName,tr.Age,tr.Gender,tr.Mobile, ");
        sb.Append(" tr.City,tr.Address,DATE_FORMAT(tr.BookingDate,'%d-%b-%Y')BookingDate,(CASE WHEN tr.STATUS=0 THEN 'Pending' WHEN tr.status=1 THEN 'Issue' ");
        sb.Append(" WHEN tr.status=2 THEN 'Reject' ELSE 'Expired' END)`Status`,DATE_FORMAT(tr.CreatedDate,'%d-%b-%Y')CreatedDate,CONCAT(em.Title,' ',em.Name)CreatedBy, ");
        sb.Append(" DATE_FORMAT(tr.IssueDate,'%d-%b-%Y')IssueDate,CONCAT(em2.Title,' ',em2.Name)IssuedBy,vm.VehicleName,vm.ModelNo,IFNULL(tr.LastReading,'')LastReading,");
        sb.Append(" dm.Name 'Driver',dm.Mobile 'DriverMobileNo',IF(tr.IsPaymentDone=0,'Not Done','Done')Payment,IFNULL(tr.MeterReading,'')MeterReading,");
        sb.Append(" IFNULL(CONCAT(em3.Title,' ',em3.Name),'')BillingUser,IFNULL(DATE_FORMAT(tr.BillingDateTime,'%d-%b-%Y'),'')BillingDateTime,");
        sb.Append(" IFNULL(CONCAT(em4.Title,' ',em4.Name),'')AckUser,IFNULL(DATE_FORMAT(tr.AckDateTime,'%d-%b-%Y'),'')AckDateTime,");
        sb.Append(" (CASE WHEN vrm.ReadingTypeID=1 THEN 'KM Basis' WHEN vrm.ReadingTypeID=2 THEN 'Range Basis' ELSE '' END )ReadingType,");
        sb.Append(" IFNULL(tr.MeterReadingAck,'')MeterReadingAck,tr.CreatedDate 'EntryDate' ");
        sb.Append(" FROM t_transport_request tr ");
        sb.Append(" INNER JOIN employee_master em ON tr.CreatedBy=em.EmployeeID INNER JOIN employee_master em2 ON tr.IssueBy=em2.EmployeeID ");
        sb.Append(" INNER JOIN t_vehicle_master vm ON tr.VehicleID=vm.ID INNER JOIN t_driver_master dm ON tr.DriverID=dm.ID ");
        sb.Append(" LEFT JOIN employee_master em3 ON tr.BillingUserID=em3.EmployeeID LEFT JOIN employee_master em4 ON tr.AckUserID=em4.EmployeeID ");
        sb.Append(" LEFT JOIN t_vehiclereading_master vrm ON tr.VRM_ID=vrm.ID ");
        sb.Append(" WHERE IsDept=0 and tr.CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " ");
        if (VehicalId != 0)
        {
            sb.Append(" And vm.ID =" + VehicalId);
        }
        sb.Append(" UNION ALL");
        sb.Append(" SELECT tr.id,'Department Request' `Type`,tr.TokenNo,IFNULL(tr.PatientID,'')MRNo,IF(tr.Patient_Type=1,'Old','New')Patient_Type,tr.PName,tr.Age,tr.Gender,tr.Mobile, ");
        sb.Append(" tr.City,tr.Address,DATE_FORMAT(tr.BookingDate,'%d-%b-%Y')BookingDate,(CASE WHEN tr.STATUS=0 THEN 'Pending' WHEN tr.STATUS=1 THEN 'Issue' ");
        sb.Append(" WHEN tr.STATUS=2 THEN 'Reject' ELSE 'Expired' END)`Status`,DATE_FORMAT(tr.CreatedDate,'%d-%b-%Y')CreatedDate,CONCAT(em.Title,' ',em.Name)CreatedBy, ");
        sb.Append(" DATE_FORMAT(tr.IssueDate,'%d-%b-%Y')IssueDate,CONCAT(em2.Title,' ',em2.Name)IssuedBy,vm.VehicleName,vm.ModelNo,IFNULL(tr.LastReading,'')LastReading,");
        sb.Append(" dm.Name 'Driver',dm.Mobile 'Driver Mobile No',IF(tr.IsPaymentDone=0,'Not Done','Done')Payment,IFNULL(tr.MeterReading,'')MeterReading, ");
        sb.Append(" IFNULL(CONCAT(em3.Title,' ',em3.Name),'')BillingUser,IFNULL(DATE_FORMAT(tr.BillingDateTime,'%d-%b-%Y'),'')BillingDateTime, ");
        sb.Append(" IFNULL(CONCAT(em4.Title,' ',em4.Name),'')AckUser,IFNULL(DATE_FORMAT(tr.AckDateTime,'%d-%b-%Y'),'')AckDateTime, ");
        sb.Append(" (CASE WHEN vrm.ReadingTypeID=1 THEN 'KM Basis' WHEN vrm.ReadingTypeID=2 THEN 'Range Basis' ELSE '' END )ReadingType, ");
        sb.Append(" IFNULL(tr.MeterReadingAck,'')MeterReadingAck,tr.CreatedDate 'EntryDate' ");
        sb.Append(" FROM t_transport_request tr ");
        sb.Append(" INNER JOIN employee_master em ON tr.CreatedBy=em.EmployeeID INNER JOIN employee_master em2 ON tr.IssueBy=em2.EmployeeID ");
        sb.Append(" INNER JOIN t_vehicle_master vm ON tr.VehicleID=vm.ID INNER JOIN t_driver_master dm ON tr.DriverID=dm.ID ");
        sb.Append(" LEFT JOIN employee_master em3 ON tr.BillingUserID=em3.EmployeeID LEFT JOIN employee_master em4 ON tr.AckUserID=em4.EmployeeID ");
        sb.Append(" LEFT JOIN t_vehiclereading_master vrm ON tr.VRM_ID=vrm.ID ");
        sb.Append(" WHERE IsDept=1 and tr.CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + "");
        if (VehicalId != 0)
        {
            sb.Append(" And vm.ID =" + VehicalId);
        }
        sb.Append(" )t   ");
        if (Category != 0)
        {
            string Type = "";
            if (Category == 1)
            {
                Type = "Department Request";
            }
            else
            {
                Type = "Patient Request";
            }
            sb.Append("WHERE t.Type ='" + Type + "'");
        }
        else if (fromDate != "" && ToDate != "")
        {
            sb.Append("WHERE DATE(t.EntryDate)>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND DATE(t.EntryDate)<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'");
        }
        sb.Append(" ORDER BY t.id ");
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            if (ReportType == "Exl")
            {

                Session["dtExport2Excel"] = dt;
                Session["ReportName"] = "TransportdetailReport";
                Session["Period"] = "From : " + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(ToDate).ToString("dd-MMM-yyyy");

                return "Exl";
            }
            else if (ReportType == "pdf")
            {
                DataColumn dc = new DataColumn();
                dc.ColumnName = "ReportDate";
                dc.DefaultValue = "From : " + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(ToDate).ToString("dd-MMM-yyyy");
                dt.Columns.Add(dc);
                dc = new DataColumn();
                dc.ColumnName = "UserName";
                dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
                dt.Columns.Add(dc);

                DataTable dtImg = All_LoadData.CrystalReportLogo();

                DataSet ds = new DataSet();
                ds.Tables.Add(dtImg.Copy());
                ds.Tables[0].TableName = "Logo";
                ds.Tables.Add(dt.Copy());
                ds.Tables[1].TableName = "table";

                // ds.WriteXmlSchema(@"D:\TransportdetailReport.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "TransportdetailReport";
                // ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "", true);
                return "pdf";
            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
        }
        else
        {
            return "";
        }
    }

    [WebMethod(EnableSession = true, Description = "Get Billed Price")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetBilledPrice(string KmRun, string VechicalId, string ReadingTypeId)
   {

        StringBuilder sb = new StringBuilder();
        DataTable dt = new DataTable();

        decimal BillAmount = 0;
        decimal IsDataFound = 0;
        string Message = "";
        if (Util.GetInt(ReadingTypeId) == 1) // For Km Basis 
        {
            sb.Append(" SELECT ifnull(vr.`RatePerKM`,0)RatePerKM FROM t_VehicleReading_Master vr  ");
            sb.Append(" WHERE vr.`ReadingTypeID`=1    ");
            sb.Append(" AND vr.`IsActive`=1 AND vr.`VehicleID`='" + VechicalId + "' ORDER BY id DESC LIMIT 1  ");
            dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0 && dt!=null)
            {
                IsDataFound = 1;

                BillAmount = Util.GetDecimal(KmRun) * Util.GetDecimal(dt.Rows[0]["RatePerKM"].ToString());

            }
            else
            {
                Message = "Please Set Rate of this vechical on KM Basis";
            }
        }
        else if (Util.GetInt(ReadingTypeId) == 2)
        {
           
            sb.Append("  SELECT IFNULL(vr.`RangeAmount`,0)RangeAmount FROM t_VehicleReading_Master vr ");
            sb.Append("  WHERE vr.`ReadingTypeID`=2   ");
            sb.Append(" AND vr.`IsActive`=1 AND vr.`VehicleID`='"+VechicalId+"' AND '"+KmRun+"'  BETWEEN vr.`RangeFrom` AND vr.`RangeTo`  ");
            sb.Append("  ORDER BY id DESC LIMIT 1 ");
            dt = StockReports.GetDataTable(sb.ToString());


            if (dt.Rows.Count > 0 && dt != null)
            {
                IsDataFound = 1;
                BillAmount = Util.GetDecimal(dt.Rows[0]["RangeAmount"].ToString());
                 
            }
            else
            {
                Message = "Please Set Rate of this vechical on Range Basis";
            }
        }
        else
        {
            Message = "Reading Type is not selected during Issuing the vechical. Contact to Administrator";
        }


        if (IsDataFound > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, BilledAmount = BillAmount, Message=Message });

        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, BilledAmount = BillAmount, Message = Message });

        }

    }


}