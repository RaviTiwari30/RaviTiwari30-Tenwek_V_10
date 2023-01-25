<%@ WebService Language="C#" Class="BioMedicalwaste" %>

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
using System.IO;
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class BioMedicalwaste : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }
    [WebMethod]
    public string bindBagTypeMasterDetails()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT BM.ID,BM.BagName,BM.BagColour,BM.Description,IF(BM.IsActive=1,'Yes','No')Active, IF(BM.IsActive=1,'1','0')IsActive,BM.Image, ");

        sb.Append("CONCAT(CONCAT(em.Title,em.Name))CreatedBy , ");
        sb.Append("DATE_FORMAT(BM.CreatedDateTime,'%d-%b-%Y')DateTime , ");
        sb.Append("CONCAT(IFNULL((SELECT CONCAT(title,'',NAME) FROM employee_master WHERE EmployeeID=BM.UpdatedBy),''),' ',IFNULL(DATE_FORMAT(BM.UpdatedDateTime,'%d-%b-%Y'),''))LastUpdateBy ");
        sb.Append("FROM bio_InsertBagMaster BM  ");
        sb.Append("INNER JOIN employee_master em ON em.EmployeeID= BM.CreatedBy ");


        sb.Append(" Order By BagName ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod(EnableSession = true)]
    public string BindRoleMaster()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT rm.ID,RoleName ");
        sb.Append("FROM f_rolemaster rm inner JOIN  f_centre_role cr ON cr.roleid=rm.id  ");
        sb.Append("WHERE Active=1  AND cr.isActive=1 and centreId= '" + Util.GetString(HttpContext.Current.Session["CentreID"].ToString() + "' "));
        sb.Append(" Order By RoleName ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    public string BindImage()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT ID,BagName,Image,BagColour ");
        sb.Append("FROM bio_InsertBagMaster bm   ");
        //sb.Append("LEFT JOIN bio_medicaldepartmentdispatch bmd ON bim.ID=bmd.`BagId`  ");
        sb.Append("WHERE IsActive=1 ");
        sb.Append(" Order By BagName ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod(EnableSession = true)]
    public string SaveBagidWithDepartment(string DepartMent, List<BagType> BagType)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var UserID = HttpContext.Current.Session["ID"].ToString();
            var IpAddress = HttpContext.Current.Request.UserHostAddress;
            var CentreId = HttpContext.Current.Session["CentreID"].ToString();
            var message = "";


            string str1 = "SELECT COUNT(*) FROM bio_mapbagmasterwithdepartment WHERE IsActive=1 and CentreId='" + CentreId + "'  and DepartmentId = '" + DepartMent + "'";
            var IsExist1 = Util.GetInt(StockReports.ExecuteScalar(str1));
            if (IsExist1 > 0)
            {
                string sqlCMD1 = "Update bio_mapbagmasterwithdepartment set IsActive=0,UpdatedBy = @UpdatedBy,UpdatedDateTime = Now() WHERE DepartmentId=@DepartMent AND ISActive=1 ";
                excuteCMD.DML(tnx, sqlCMD1, CommandType.Text, new
                {
                    DepartMent = DepartMent,
                    UpdatedBy = UserID,
                });
            }


            for (int i = 0; i < BagType.Count; i++)
            {

                string sqlCMD = "INSERT INTO bio_mapbagmasterwithdepartment (DepartmentId,BegId,IsActive,CreatedBy,CreatedDateTime,CentreId) values(@DepartMent,@BegId,@IsActive,@CreatedBy,Now(),@CentreId)";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                                   {
                                       DepartMent = DepartMent,
                                       BegId = BagType[i].BagId,

                                       CreatedBy = UserID,
                                       IsActive = 1,
                                       CentreId = CentreId
                                   });
                message = "Record Save Successfully";
            }


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
    public class BagType
    {

        public string BagId { get; set; }

    }

    [WebMethod(EnableSession = true)]
    public string GetDataDepartmentWise(string DepartmentId)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT  bg.ID,BagName,Image,BagColour,IF(IFNULL(bd.`BegId`,'0')='0','0','1')IsMapped  FROM bio_InsertBagMaster bg ");
        sb.Append("LEFT JOIN bio_mapbagmasterwithdepartment bd ON bg.`ID`= bd.`BegId` AND bd.`IsActive`=1 AND bd.`DepartmentId`='" + DepartmentId + "' and bd.CentreId='" + Util.GetString(HttpContext.Current.Session["CentreID"].ToString() + "' "));
        sb.Append("WHERE bg.IsActive=1  ORDER BY BagName ; ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        //  string pathname = System.IO.Path.Combine(Resources.Resource.DocumentDriveIPAddress + Resources.Resource.DocumentDriveName + "\\" + Resources.Resource.DocumentFolderName + "\\BagImage\\" + dt.Rows[0]["BagName"].ToString() + "\\" + dt.Rows[0]["BagName"].ToString() + ".jpg");
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            if (Util.GetString(dt.Rows[i]["Image"]) != "")
            {
                byte[] byteArray = File.ReadAllBytes(dt.Rows[i]["Image"].ToString());
                string base64 = Convert.ToBase64String(byteArray);
                dt.Rows[i]["Image"] = string.Format("data:image/jpg;base64,{0}", base64);
            }




        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        //return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod(EnableSession = true)]
    public string BindEmployee(string RoleID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT  em.EmployeeID,em.Name from employee_master em ");

        sb.Append("INNER JOIN f_login fl ON fl.EmployeeID=em.EmployeeID ");
        sb.Append("WHERE em.IsActive=1  ");
        if (RoleID != "0")
            sb.Append("and  RoleID='" + RoleID + "' ");

        sb.Append("GROUP BY em.EmployeeID ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod(EnableSession = true)]
    public string SaveMedicalDepartmentDispatch(string Id, string Date, string Time, string dispatch, string collectedby, string Remark, string RoleId, List<Bag> Bag)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var ID = 0;
            var UserID = HttpContext.Current.Session["ID"].ToString();
            var IpAddress = HttpContext.Current.Request.UserHostAddress;
            var CentreId = HttpContext.Current.Session["CentreID"].ToString();
            var message = "";


            string str1 = "SELECT COUNT(*) FROM bio_MedicalDepartmentDispatch WHERE IsActive=1  and CentreId='" + CentreId + "'  AND  Id = '" + Id + "'";
            var IsExist1 = Util.GetInt(StockReports.ExecuteScalar(str1));
            if (IsExist1 > 0)
            {
                string sqlCMD1 = "Update bio_MedicalDepartmentDispatch set IsActive=0,UpdatedBy = @UpdatedBy,UpdatedDateTime = Now() WHERE Id=@Id AND ISActive=1 ";
                excuteCMD.DML(tnx, sqlCMD1, CommandType.Text, new
                {
                    Id = Util.GetInt(Id),
                    UpdatedBy = UserID,
                    
                });
            }


            for (int i = 0; i < Bag.Count; i++)
            {
                //Util.getbooleanInt

                string sqlCMD = "INSERT INTO bio_MedicalDepartmentDispatch (Date,Time,BagId,Quantity,Weight,Unit,DispatchedBy,CollectedBy,Remark,RoleId,IsActive,CreatedBy,CreatedDateTime,CentreId) values(@Date,@Time,@BagId,@Quantity,@Weight,@Unit,@DispatchedBy,@CollectedBy,@Remark,@RoleId,@IsActive,@CreatedBy,Now(),@CentreId)";
                ID = Util.GetInt(excuteCMD.ExecuteScalar(tnx, sqlCMD, CommandType.Text, new
               {
                   //excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new

                   Date = Util.GetDateTime(Date),
                   Time = Util.GetDateTime(Time).ToString("HH:mm:ss"),
                   Quantity = Util.GetDecimal(Bag[i].Quantity),
                   Weight = Util.GetDecimal(Bag[i].Weight),
                   BagId = Bag[i].BagId,
                   Unit = Bag[i].Unit,
                   DispatchedBy = dispatch,
                   CollectedBy = collectedby,
                   Remark = Remark,
                   CreatedBy = UserID,
                   IsActive = 1,
                   RoleId = RoleId,
                   CentreId = CentreId
                   //});
               }));
                message = "Record Dispatch Successfully";
            }


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
    public class Bag
    {

        public string BagId { get; set; }
        public string Quantity { get; set; }
        public string Weight { get; set; }
        public string Unit { get; set; }

    }

    [WebMethod(EnableSession = true)]
    public string bindBagDetails(string FromDate, string ToDate, string RoleId, string status)
    {
        StringBuilder sb = new StringBuilder();
        //sb.Append("DATE_FORMAT(TIME,'%d-%b-%Y %I:%i %p')TIME , ");
        sb.Append("SELECT bmd.Id,DATE_FORMAT(DATE,'%d-%b-%Y')DATE,TIME_FORMAT(TIME,'%I:%i %p')TIME,Quantity,CONCAT(CONCAT(Weight , '  ' ,Unit))Weight,IF(bmd.IsActive=1,'Yes','No')Active, IF(bmd.IsActive=1,'1','0')IsActive,IF(bmd.IsRecived=1,'#90ee90','#FF99CC')RowColor, ");
        sb.Append("Remark,bim.BagName,CONCAT(CONCAT(em.Title,em.Name))DispatchedBy,CollectedBy,DispatchedBy AS dispatchedById,Weight as wt,Unit as ut,BagId,IsRecived ");
        sb.Append("FROM bio_medicaldepartmentdispatch bmd ");
        sb.Append("INNER JOIN bio_InsertBagMaster bim ON bim.ID=bmd.`BagId` ");
        sb.Append(" INNER JOIN employee_master em ON em.EmployeeID= bmd.DispatchedBy ");

        sb.Append("WHERE bmd.IsActive=1  ");
        if (RoleId != "0")
            sb.Append("and bmd. RoleID='" + RoleId + "' AND  bmd.CentreId='" + Util.GetString(HttpContext.Current.Session["CentreID"].ToString() + "'"));
        if (FromDate != "" || ToDate != "")
            sb.Append("AND bmd.Date>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND bmd.Date<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' ");
        if (status == "1")
            sb.Append("and bmd.IsRecived='0' and  bmd.IsDispatchFromHospital='0'");
        else if (status == "2")
            sb.Append(" and bmd.IsRecived='1' ");
        sb.Append("ORDER BY  DATE,TIME ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod(EnableSession = true)]
    public string BindIsNotRecivedBagDetails(string FromDate, string ToDate, string DepartMent, string status)
    {
        StringBuilder sb = new StringBuilder();
        //sb.Append("DATE_FORMAT(TIME,'%d-%b-%Y %I:%i %p')TIME , ");
        sb.Append("SELECT bmd.Id,DATE_FORMAT(DATE,'%d-%b-%Y')DATE,TIME_FORMAT(TIME,'%I:%i %p')TIME,Quantity,CONCAT(CONCAT(Weight , '  ' ,Unit))Weight,IF(bmd.IsActive=1,'Yes','No')Active, IF(bmd.IsActive=1,'1','0')IsActive, ");
        sb.Append("Remark,bim.BagName,CONCAT(CONCAT(em.Title,em.Name))DispatchedBy,CollectedBy,DispatchedBy AS dispatchedById,Weight as wt,Unit as ut,BagId,rm.RoleName,bmd.IsRecived,bmd.IsReject,bmd.IsDispatchFromHospital ");
        sb.Append("FROM bio_medicaldepartmentdispatch bmd ");
        sb.Append("INNER JOIN bio_InsertBagMaster bim ON bim.ID=bmd.`BagId` ");
        sb.Append(" INNER JOIN employee_master em ON em.EmployeeID= bmd.DispatchedBy ");
        sb.Append(" INNER JOIN f_rolemaster rm ON rm.Id= bmd.RoleId ");
        sb.Append("WHERE bmd.IsActive=1 AND bmd.CentreId='" + Util.GetString(HttpContext.Current.Session["CentreID"].ToString() + "' "));

        if (status == "0" || status == "1")
            sb.Append("and bmd.IsRecived='" + status + "' and bmd.IsReject='0' ");
        else if (status == "2")
            sb.Append(" and bmd.IsReject='1' ");

        if (FromDate != "" || ToDate != "")
            sb.Append("AND bmd.Date>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND bmd.Date<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' ");
        if (DepartMent != "0")
            sb.Append("AND bmd.RoleId ='" + DepartMent + "' ");
        sb.Append("ORDER BY  DATE,TIME ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod(EnableSession = true)]
    public string SaveRecivedDepartmentDispatchDetails(string type, List<CheckedDetail> CheckedDetail)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var ID = 0;
            var UserID = HttpContext.Current.Session["ID"].ToString();
            var IpAddress = HttpContext.Current.Request.UserHostAddress;

            var message = "";

            if (type == "Received")
            {
                for (int i = 0; i < CheckedDetail.Count; i++)
                {
                    string sqlCMD1 = "Update bio_medicaldepartmentdispatch set IsRecived=1,IsReject=0,RecievedBy = @RecievedBy,RecievedDateTime = Now() WHERE Id=@Id AND ISActive=1 ";
                    excuteCMD.DML(tnx, sqlCMD1, CommandType.Text, new
                    {
                        Id = CheckedDetail[i].Id,
                        RecievedBy = UserID,
                    });
                    message = "Recieved Successfully";
                }


            }
            else
            {
                for (int i = 0; i < CheckedDetail.Count; i++)
                {
                    string sqlCMD1 = "Update bio_medicaldepartmentdispatch set IsReject=1,IsRecived=0,RejectedBy = @RejectedBy,RejectedDateTime = Now() WHERE Id=@Id AND ISActive=1 ";
                    excuteCMD.DML(tnx, sqlCMD1, CommandType.Text, new
                    {
                        Id = CheckedDetail[i].Id,
                        RejectedBy = UserID,
                    });
                    message = "Reject Successfully";
                }


            }
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

    public class CheckedDetail
    {

        public string Id { get; set; }


    }
    [WebMethod(EnableSession = true)]
    public string GetRecivedOrRejectDetails(string Id)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("SELECT bmd.Id,DATE_FORMAT(RecievedDateTime,'%d-%b-%Y %I:%i %p')RecievedDateTime,DATE_FORMAT(RejectedDateTime,'%d-%b-%Y %I:%i %p')RejectedDateTime,");
        sb.Append("IF(bmd.IsRecived=1,CONCAT(em1.Title,em1.Name),'')RecievedBy,IF(BMD.IsReject=1,CONCAT(em.Title,em.Name),'')RejectedBy  ");
        sb.Append("FROM bio_medicaldepartmentdispatch bmd ");
        sb.Append("LEFT JOIN employee_master em1 ON em1.EmployeeID= bmd.RecievedBy ");
        sb.Append("LEFT JOIN employee_master em ON em.EmployeeID= bmd.RejectedBy ");
        sb.Append("WHERE bmd.IsActive=1  and bmd.Id='" + Id + "' ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod(EnableSession = true)]
    public string DispatchInsert(string DispatchName)
    {
        try
        {
            int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM bio_dispatchorganization where Name='" + DispatchName + "'"));
            if (count > 0)
                return "0";
            else
            {

                string s = "INSERT INTO bio_dispatchorganization(Name,IsActive,CreatedBy,CreatedDateTime) values('" + DispatchName + "',1,'" + HttpContext.Current.Session["ID"].ToString() + "',Now())";
                StockReports.ExecuteDML(s);
                return Util.GetString(StockReports.ExecuteScalar("SELECT MAX(ID) FROM bio_dispatchorganization"));

            }
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "";
        }
    }
    [WebMethod(EnableSession = true)]
    public string GetDispatch()
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("SELECT Id,Name ");

        sb.Append("FROM bio_dispatchorganization ");

        sb.Append("WHERE IsActive=1  ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));


    }

    [WebMethod(EnableSession = true)]
    public string BindDispatchFromDepartmentDetails()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT bim.id AS BagID,bim.`BagName`,bim.`BagColour`,bim.Image,bmd.Id,  ");
        sb.Append("SUM(IFNULL(Quantity,0)) AS Quantity,SUM(IFNULL(Weight,0)) AS Weight ");
        sb.Append("FROM bio_InsertBagMaster bim ");
        sb.Append("LEFT JOIN bio_medicaldepartmentdispatch bmd ON bim.ID=bmd.`BagId` AND  bmd.IsActive=1  AND IsRecived=1 AND IsDispatchFromHospital=0 and bmd.CentreId='" + Util.GetString(HttpContext.Current.Session["CentreID"].ToString() + "' "));

        sb.Append("WHERE bim.IsActive=1  ");
        sb.Append("GROUP BY bim.`ID`  ");
        sb.Append("ORDER BY bagName  ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                //  string pathname = System.IO.Path.Combine(Resources.Resource.DocumentDriveIPAddress + Resources.Resource.DocumentDriveName + "\\" + Resources.Resource.DocumentFolderName + "\\BagImage\\" + dt.Rows[0]["BagName"].ToString() + "\\" + dt.Rows[0]["BagName"].ToString() + ".jpg");
                if (Util.GetString(dt.Rows[i]["Image"]) != "")
                {
                    byte[] byteArray = File.ReadAllBytes(dt.Rows[i]["Image"].ToString());
                    string base64 = Convert.ToBase64String(byteArray);
                    dt.Rows[i]["Image"] = string.Format("data:image/jpg;base64,{0}", base64);
                }
            }
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);


        //return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));


    }
    [WebMethod(EnableSession = true)]
    public string BindBagDepartmentWise(string DepartmentId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT  bg.ID,BagName,Image,BagColour,IF(IFNULL(bd.`BegId`,'0')='0','0','1')IsMapped  FROM bio_InsertBagMaster bg ");
        sb.Append("inner JOIN bio_mapbagmasterwithdepartment bd ON bg.`ID`= bd.`BegId` AND bd.`IsActive`=1 AND bd.`DepartmentId`='" + DepartmentId + "' and bd.CentreId='" + Util.GetString(HttpContext.Current.Session["CentreID"].ToString() + "' "));
        sb.Append("WHERE bg.IsActive=1 ORDER BY BagName ; ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        //  string pathname = System.IO.Path.Combine(Resources.Resource.DocumentDriveIPAddress + Resources.Resource.DocumentDriveName + "\\" + Resources.Resource.DocumentFolderName + "\\BagImage\\" + dt.Rows[0]["BagName"].ToString() + "\\" + dt.Rows[0]["BagName"].ToString() + ".jpg");
        if (dt.Rows.Count > 0)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (Util.GetString(dt.Rows[i]["Image"]) != "")
                {
                    byte[] byteArray = File.ReadAllBytes(dt.Rows[i]["Image"].ToString());
                    string base64 = Convert.ToBase64String(byteArray);
                    dt.Rows[i]["Image"] = string.Format("data:image/jpg;base64,{0}", base64);
                }
            }
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        //return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod(EnableSession = true)]
    public string GetBagImageForPopUp(string BagId)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("SELECT ID,BagName,Image,BagColour ");
        sb.Append("FROM bio_InsertBagMaster bm   ");
        sb.Append("WHERE IsActive=1 and Id='" + BagId + "'");
        sb.Append(" Order By BagName ");
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
    public string UpdateBagMasterType(string BagId, string Bagname, string BagColor, string Description, string IsActive)
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

            string str = "SELECT COUNT(*) FROM bio_InsertBagMaster WHERE isactive=1 and BagName = '" + Bagname + "' ";
            if (BagId != "")
            {
                str += " and Id <> '" + BagId + "' ";
            }
            var IsExist = Util.GetInt(StockReports.ExecuteScalar(str));
            if (IsExist > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Bag Already Exists" });
            }

            string sqlCMD = "UPDATE bio_InsertBagMaster  SET BagName = @BagName,BagColour=@BagColour,Description=@Description,UpdatedBy = @UpdatedBy,UpdatedDateTime = Now(),IsActive = @IsActive WHERE Id = @ID;";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                BagName = Bagname,
                BagColour = BagColor,
                Description = Description,
                IsActive = IsActive,
                UpdatedBy = UserID,
                ID = BagId,
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



    [WebMethod(EnableSession = true)]
    public string SaveMedicalDispatchFromHospital(string Date, string Time, string dispatch, string collectedby, string Remark, string vehicalNo, string DispatchTo, List<BagDetails> BagDetails)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var ID = 0;
            var UserID = HttpContext.Current.Session["ID"].ToString();
            var IpAddress = HttpContext.Current.Request.UserHostAddress;
            var CentreId = HttpContext.Current.Session["CentreID"].ToString();
            var message = "";


            for (int i = 0; i < BagDetails.Count; i++)
            {
                string sqlCMD1 = "Update bio_medicaldepartmentdispatch set IsDispatchFromHospital=1,HospitalDispatchBy = @RecievedBy,HospitalDispatchDateTime = Now() WHERE BagId=@BagId and Id=@Id  AND ISActive=1 ";
                excuteCMD.DML(tnx, sqlCMD1, CommandType.Text, new
                {
                    BagId = BagDetails[i].BagId,
                    Id = BagDetails[i].Id,
                    RecievedBy = UserID,
                });
                string sqlCMD = "INSERT INTO bio_hospitaldispatch (DispatchId,Date,Time,BagId,Quantity,Weight,Unit,DispatchedBy,CollectedBy,Remark,VehicleNo,DispatchedTo,IsActive,CreatedBy,CreatedDateTime,CentreId) values(@DispatchId,@Date,@Time,@BagId,@Quantity,@Weight,@Unit,@DispatchedBy,@CollectedBy,@Remark,@VehicleNo,@DispatchedTo,@IsActive,@CreatedBy,Now(),@CentreId)";
                ID = Util.GetInt(excuteCMD.ExecuteScalar(tnx, sqlCMD, CommandType.Text, new
                {
                    Date = Util.GetDateTime(Date),
                    Time = Util.GetDateTime(Time).ToString("HH:mm:ss"),
                    Quantity = Util.GetDecimal(BagDetails[i].Quantity),
                    Weight = Util.GetDecimal(BagDetails[i].Weight),
                    BagId = BagDetails[i].BagId,
                    Unit = BagDetails[i].Unit,
                    DispatchedBy = dispatch,
                    CollectedBy = collectedby,
                    Remark = Remark,
                    CreatedBy = UserID,
                    IsActive = 1,
                    DispatchId = BagDetails[i].Id,
                    VehicleNo = vehicalNo,
                    DispatchedTo = DispatchTo,
                    CentreId = CentreId,
                    //});
                }));
                message = "Dispatched Successfully";
            }



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


    public class BagDetails
    {
        public string Id { get; set; }
        public string BagId { get; set; }
        public string Quantity { get; set; }
        public string Weight { get; set; }
        public string Unit { get; set; }
    }

    [WebMethod(EnableSession = true)]
    public string bindMedicalDispatchFromHospitalDetails()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select bm.`BagName`,DATE_FORMAT(DATE,'%d-%b-%Y')DATE,TIME_FORMAT(TIME,'%I:%i %p')TIME,Quantity,Weight,CollectedBy,Remark,VehicleNo,bdo.`Name`,CONCAT(em.Title,em.Name)CreatedBy,CONCAT(em1.Title,em1.Name)DispatchedBy  ");
        sb.Append("FROM bio_insertbagmaster bm   ");
        sb.Append("LEFT JOIN bio_hospitaldispatch bhd ON bhd.BagId= bm.id  ");
        sb.Append("LEFT JOIN employee_master em ON em.EmployeeID= bhd.CreatedBy ");
        sb.Append("LEFT JOIN bio_dispatchorganization bdo ON bdo.`Id`=bhd.`DispatchedTo`  ");
        sb.Append("LEFT JOIN employee_master em1 ON em1.EmployeeID= bhd.DispatchedBy ");
        sb.Append("WHERE bhd.IsActive=1  and bhd.CentreId='" + Util.GetString(HttpContext.Current.Session["CentreID"].ToString() + "' "));
        sb.Append("ORDER BY  DATE,TIME ");
        //sb.Append("WHERE bmd.IsActive=1  and bmd.Id='" + Id + "' ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }


    [WebMethod]

    public string BindBagHospitalorDeptWise(string FromDate, string ToDate)
    {

        DataTable dt = StockReports.GetDataTable("CALL  get_Biomedical_Dashboard ('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "')");

        //return Newtonsoft.Json.JsonConvert.SerializeObject();
        //HttpContext.Current.Response.ContentType = "application/json; charset=utf-8";
        DataTable dt1 = dt;
        //  string pathname = System.IO.Path.Combine(Resources.Resource.DocumentDriveIPAddress + Resources.Resource.DocumentDriveName + "\\" + Resources.Resource.DocumentFolderName + "\\BagImage\\" + dt.Rows[0]["BagName"].ToString() + "\\" + dt.Rows[0]["BagName"].ToString() + ".jpg");
        if (dt1.Rows.Count > 0)
        {
            for (int i = 0; i < dt1.Rows.Count; i++)
            {
                if (Util.GetString(dt1.Rows[i]["Image"]) != "")
                {
                    byte[] byteArray = File.ReadAllBytes(dt1.Rows[i]["Image"].ToString());
                    string base64 = Convert.ToBase64String(byteArray);
                    dt1.Rows[i]["Image"] = string.Format("data:image/jpg;base64,{0}", base64);
                }
            }
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt1);
        //HttpContext.Current.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(dt));
    }

    [WebMethod(EnableSession = true)]
    public string BindBioMedicalWasteReport1(string FromDate, string ToDate, string Type, string dispatchedto, string deptstatus, string hospstatus, string DepartmentId, string centreIDs)
    {
        
        string status = "0";
        if (Type == "1")
        {
            if (deptstatus != "0")
                status = deptstatus;
        }
        if (Type == "2")
        {
            if (hospstatus != "0")
                status = hospstatus;
        }
        if (Type == "1")
            Type = "Department";

        if (Type == "2")
            Type = "Hospital";
        //var str = "CALL get_Biomedical_Report ('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + Type + "','" + dispatchedto + "','" + status + "','" + DepartmentId + "')";
       // var str = "CALL get_Biomedical_Report1 ('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + Type + "','" + dispatchedto + "','" + status + "','" + DepartmentId + "','" + centreIDs + "')";

        //var sre = "CALL get_Biomedical_Report1 (@fromdate,@todate,@type,@dispatchTo,@status,@departmentID,@centreID);";
        //DataTable dt = excuteCMD.GetDataTable(sre, CommandType.Text, new {
        //    fromdate=Util.GetDateTime(FromDate).ToString("yyyy-MM-dd"),
        //    todate=Util.GetDateTime(ToDate).ToString("yyyy-MM-dd"),
        //    type=Type,
        //    dispatchTo=dispatchedto,
        //    status=status,
        //    departmentID=DepartmentId,
        //    centreID=centreIDs,
        //});

        //var dtt = excuteCMD.GetRowQuery(sre,  new
        //{
        //    fromdate = Util.GetDateTime(FromDate).ToString("yyyy-MM-dd"),
        //    todate = Util.GetDateTime(ToDate).ToString("yyyy-MM-dd"),
        //    type = Type,
        //    dispatchTo = dispatchedto,
        //    status = status,
        //    departmentID = DepartmentId,
        //    centreID = centreIDs,
        //});
        StringBuilder sb = new StringBuilder();
     
        if (Type == "Hospital" && status == "0")
        {
            sb.Append("SELECT BM.Id,BM.BagName,BM.BagColour,BM.Image,DispatchedTo,BHD.Quantity,BHD.Weight,DATE_FORMAT(BHD.Date,'%d-%b-%Y') AS `DATE`, ");
            sb.Append("TIME_FORMAT(BHD.TIME,'%I:%i %p')TIME,cm.CentreName,cm.CentreID FROM bio_insertbagmaster BM INNER JOIN bio_hospitaldispatch BHD ON BHD.bagId=BM.Id AND BHD.IsActive=1 INNER JOIN  bio_dispatchorganization BDO ON BDO.Id=BHD.`DispatchedTo` INNER JOIN  Center_master cm ON cm.CentreID=BHD.CentreId ");


            sb.Append("AND DATE(bhd.`Date`)>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND DATE(bhd.`Date`)<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' ");
            sb.Append("AND DATE(bhd.`Date`)>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND DATE(bhd.`Date`)<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' ");
            sb.Append("AND dispatchedto='" + dispatchedto + "' AND Type='" + Type + "' ");
            sb.Append("AND DepartmentId='" + DepartmentId + "' ");
            sb.Append("AND bmd.CentreID   in (" + centreIDs + ") ");
        }

       // string strQuery = string.Empty;
        //strQuery = "  centreIDs in (" + MCDOId + ")";
        //strQuery = +"";
        
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        
        if (dt.Rows.Count > 0)
        {
            DataSet set = new DataSet();
            DataColumn dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "From : " + FromDate.Trim() + "  To : " + ToDate.Trim();
            dt.Columns.Add(dc);
            set.Tables.Add(dt.Copy());
            if (Type == "Department")
            {
                set.Tables[0].TableName = "BioMedicalWasteReport";

                //set.WriteXmlSchema(@"E:\BioMedicalWasteReport.xml");
                HttpContext.Current.Session["ds"] = set;
                HttpContext.Current.Session["Reportname"] = "BioMedicalWasteReport";
            }
            if (Type == "Hospital")
            {
                set.Tables[0].TableName = "BioMedicalWasteHospitalReport";
                //set.WriteXmlSchema(@"E:\BioMedicalWasteHospitalReport.xml");
                HttpContext.Current.Session["ds"] = set;
                HttpContext.Current.Session["Reportname"] = "BioMedicalWasteHospitalReport";
            }

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, responseURL = "../../Design/common/Commonreport.aspx" });
        }
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });
        //HttpContext.Current.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(dt));
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
            sb.Append("SELECT AssetName,AssetNo,lm.LocationName,IFNULL(cm.CubicalName,'')AS CubicalName  ");
            if (flag == "0")
                sb.Append(" ,rm.`RoomName`   ");
            sb.Append("FROM eq_asset_location al   ");
            sb.Append("INNER JOIN eq_location_master lm ON al.LocationID=lm.ID   ");

            sb.Append(" LEFT JOIN eq_roommaster rm ON rm.id=al.RoomID    ");

            sb.Append("LEFT JOIN eq_cubicalmaster cm ON cm.`ID`=al.`CubicalID`   ");

            if (flag == "0")
                sb.Append("WHERE al.IsActive=1 and al.RoomId='" + Id + "'");
            else if (flag == "1")
                sb.Append("WHERE al.IsActive=1 and al.CubicalId='" + Id + "'");
        }
        else
        {
            sb.Append("SELECT T.AssetName,t.AssetNo,t.LocationName,IFNULL(cm.CubicalName,'')AS CubicalName,rm.RoomName FROM ( ");
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
    [WebMethod(EnableSession = true)]
    public string LoadData(string fromDate, string toDate, string SelectedValue)
    {
        StringBuilder sb = new StringBuilder();
        //sb.Append("DATE_FORMAT(TIME,'%d-%b-%Y %I:%i %p')TIME , ");
        if (SelectedValue == "BagQuantity")
        {
            sb.Append("SELECT BM.ID,SUM(QUANTITY) AS Sum,BM.BagName as Name,CONCAT(BM.BAGNAME ,':',SUM(QUANTITY))Label FROM bio_MedicalDepartmentDispatch MDD ");
            sb.Append("INNER JOIN bio_InsertBagMaster BM ON BM.ID=MDD.BagId ");
            //sb.Append("WHERE IsRecived=0 AND IsReject=0 AND IsDispatchFromHospital=0 ");

            sb.Append("where  MDD.Date>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND MDD.Date<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ");
            sb.Append("GROUP BY BagId ");

            
        }
        else if (SelectedValue == "BagWeight")
        {
            sb.Append("SELECT BM.ID,SUM(Weight) AS Sum,BM.BAGNAME as Name,CONCAT(BM.BAGNAME ,':',SUM(Weight))Label FROM bio_MedicalDepartmentDispatch MDD ");
            sb.Append("INNER JOIN bio_InsertBagMaster BM ON BM.ID=MDD.BagId ");
            //sb.Append("WHERE IsRecived=0 AND IsReject=0 AND IsDispatchFromHospital=0 ");
            sb.Append("where MDD.Date>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND MDD.Date<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ");
            sb.Append("GROUP BY BagId ");
        }
        else if (SelectedValue == "DeptQuantity")
        {
            sb.Append("SELECT RoleId AS ID,SUM(Quantity) Sum,rm.`RoleName` as Name,CONCAT(rm.`RoleName` ,':',SUM(Quantity))Label  ");
            sb.Append("FROM bio_MedicalDepartmentDispatch mdd ");
            sb.Append(" INNER JOIN f_rolemaster  rm ON rm.id=mdd.`RoleId` ");
            //sb.Append("WHERE IsRecived=0 AND IsReject=0 AND IsDispatchFromHospital=0 ");
            sb.Append("Where MDD.Date>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND MDD.Date<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ");
            sb.Append("GROUP BY mdd.`RoleId` ");
        }
        else if (SelectedValue == "DeptWeight")
        {
            sb.Append("SELECT RoleId AS ID,SUM(Weight) Sum,rm.`RoleName` as Name,CONCAT(rm.`RoleName` ,':',SUM(Weight))Label  ");
            sb.Append("FROM bio_MedicalDepartmentDispatch mdd ");
            sb.Append(" INNER JOIN f_rolemaster  rm ON rm.id=mdd.`RoleId` ");
            //sb.Append("WHERE IsRecived=0 AND IsReject=0 AND IsDispatchFromHospital=0 ");
            sb.Append("where MDD.Date>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND MDD.Date<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ");
            sb.Append("GROUP BY mdd.`RoleId` ");
        }
        else if (SelectedValue == "HosptQuantity")
        {
            sb.Append("SELECT bdo.ID,SUM(Quantity) AS Sum,CONCAT(bdo.Name ,':',SUM(QUANTITY))Label,bdo.Name   ");
            sb.Append("FROM bio_hospitaldispatch bhd ");
            sb.Append(" LEFT JOIN bio_dispatchorganization bdo ON bdo.`Id`=bhd.`DispatchedTo` ");
            sb.Append("WHERE bhd.IsActive=1 ");
            sb.Append("AND bhd.Date>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND bhd.Date<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ");
            sb.Append("GROUP BY bdo.`Id`  ");
        }
        else if (SelectedValue == "HosptWeight")
        {
            sb.Append("SELECT bhd.ID,SUM(Weight) AS Sum,CONCAT(bdo.Name ,':',SUM(QUANTITY))Label,bdo.Name   ");
            sb.Append("FROM bio_hospitaldispatch bhd ");
            sb.Append(" LEFT JOIN bio_dispatchorganization bdo ON bdo.`Id`=bhd.`DispatchedTo` ");
            sb.Append("WHERE bhd.IsActive=1 ");
            sb.Append("AND bhd.Date>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND bhd.Date<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ");
            sb.Append("GROUP BY bdo.`Id`  ");
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod(EnableSession = true)]
    public string getDepartmentListByBag(string fromDate, string toDate, string selection, string SelectedValue, string category)
    {
        StringBuilder sb = new StringBuilder();
        if (SelectedValue == "BagQuantity")
        {


            if (category == "Dept")
            {
                sb.Append("SELECT RoleId AS Id,SUM(Quantity) SUM,rm.`RoleName` as Label,BagId As BId FROM bio_MedicalDepartmentDispatch mdd   ");
                sb.Append("INNER JOIN f_rolemaster  rm ON rm.id=mdd.`RoleId`  ");
                sb.Append("WHERE bagid='" + selection + "'   ");

                sb.Append("and IsRecived=0   ");
                //else
                //    sb.Append("and IsRecived=1 AND IsReject=0 AND IsDispatchFromHospital=1  ");
                sb.Append("And MDD.Date>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND MDD.Date<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ");
                sb.Append("GROUP BY mdd.`RoleId` ");
            }
            else if (category == "DeptRecieve")
            {
                sb.Append("SELECT RoleId AS Id,SUM(Quantity) SUM,rm.`RoleName` as Label,BagId As BId FROM bio_MedicalDepartmentDispatch mdd   ");
                sb.Append("INNER JOIN f_rolemaster  rm ON rm.id=mdd.`RoleId`  ");
                sb.Append("WHERE bagid='" + selection + "'   ");

                sb.Append("and IsRecived=1   ");
                //else
                //    sb.Append("and IsRecived=1 AND IsReject=0 AND IsDispatchFromHospital=1  ");
                sb.Append("And MDD.Date>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND MDD.Date<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ");
                sb.Append("GROUP BY mdd.`RoleId` ");
            }
            else
            {
                sb.Append("SELECT bdo.Id,SUM(Quantity) AS SUM,CONCAT(bdo.Name ,':',SUM(QUANTITY))Label,BagId As BId   ");
                sb.Append("FROM bio_hospitaldispatch bhd ");
                sb.Append(" LEFT JOIN bio_dispatchorganization bdo ON bdo.`Id`=bhd.`DispatchedTo` ");
                sb.Append(" WHERE bhd.IsActive=1  and bagid='" + selection + "' ");
                sb.Append("AND bhd.Date>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND bhd.Date<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ");
                sb.Append("GROUP BY bhd.`BagId` ");
            }

        }
        else if (SelectedValue == "BagWeight")
        {
            if (category == "Dept")
            {
                sb.Append("SELECT RoleId AS Id,SUM(Weight) SUM,rm.`RoleName` as Label,BagId As BId FROM bio_MedicalDepartmentDispatch mdd   ");
                sb.Append("INNER JOIN f_rolemaster  rm ON rm.id=mdd.`RoleId`  ");
                sb.Append("WHERE bagid='" + selection + "'   ");

                //sb.Append("and IsRecived=0 AND IsReject=0 AND IsDispatchFromHospital=0  ");
                //else
                //    sb.Append("and IsRecived=1 AND IsReject=0 AND IsDispatchFromHospital=1  ");
                sb.Append("AND MDD.Date>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND MDD.Date<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ");
                sb.Append("GROUP BY mdd.`RoleId` ");
            }
            else
            {
                sb.Append("SELECT bhd.Id,SUM(Weight) AS SUM,bdo.Name as Label,BagId As BId   ");
                sb.Append("FROM bio_hospitaldispatch bhd ");
                sb.Append(" LEFT JOIN bio_dispatchorganization bdo ON bdo.`Id`=bhd.`DispatchedTo` ");
                sb.Append("WHERE bhd.IsActive=1  and bagid='" + selection + "' ");
                sb.Append("AND bhd.Date>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND bhd.Date<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ");
                sb.Append("GROUP BY bhd.`BagId` ");
            }
        }
        else if ((SelectedValue == "DeptQuantity"))
        {
            sb.Append("SELECT RoleId AS Id,SUM(Quantity) SUM,BM.`BagName` as Label,BagId As BId FROM bio_MedicalDepartmentDispatch mdd  ");
            sb.Append("INNER  JOIN bio_InsertBagMaster BM ON BM.ID=mdd.BagId  ");
            sb.Append("WHERE mdd.`RoleId`='" + selection + "'   ");
            sb.Append("AND mdd.Date>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND mdd.Date<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ");
            sb.Append("GROUP BY BagId ");
        }
        else if ((SelectedValue == "DeptQuantity") || (SelectedValue == "DeptWeight"))
        {
            sb.Append("SELECT RoleId AS Id,SUM(Weight) SUM,BM.`BagName` as Label,BagId As BId FROM bio_MedicalDepartmentDispatch mdd  ");
            sb.Append("INNER  JOIN bio_InsertBagMaster BM ON BM.ID=mdd.BagId  ");
            sb.Append("WHERE mdd.`RoleId`='" + selection + "'  ");
            sb.Append("AND mdd.Date>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND mdd.Date<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ");
            sb.Append("GROUP BY BagId ");
        }

        else if ((SelectedValue == "HosptQuantity" && category == "BagQty") || (SelectedValue == "HosptWeight" && category == "BagQty"))
        {
            sb.Append("SELECT bhd.Id As Id,BM.`BagName`AS Label,SUM(qUANTITY) AS SUM,BagId As BId FROM bio_hospitaldispatch bhd ");
            sb.Append("LEFT JOIN bio_dispatchorganization bdo ON bdo.`Id`=bhd.`DispatchedTo` ");
            sb.Append("LEFT  JOIN bio_InsertBagMaster BM ON BM.ID=bhd.BagId  ");

            sb.Append("WHERE bdo.ID='" + selection + "' ");
            sb.Append("AND bhd.Date>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND bhd.Date<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ");
            sb.Append("GROUP BY BagId ");
        }
        else if ((SelectedValue == "HosptQuantity" && category == "BagWty") || (SelectedValue == "HosptWeight" && category == "BagWty"))
        {
            sb.Append("SELECT bhd.Id As Id,BM.`BagName`AS Label,SUM(Weight) AS SUM,BagId As BId FROM bio_hospitaldispatch bhd ");
            sb.Append("LEFT JOIN bio_dispatchorganization bdo ON bdo.`Id`=bhd.`DispatchedTo` ");
            sb.Append("LEFT  JOIN bio_InsertBagMaster BM ON BM.ID=bhd.BagId  ");

            sb.Append("WHERE bdo.ID='" + selection + "' ");
            sb.Append("AND bhd.Date>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND bhd.Date<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ");
            sb.Append("GROUP BY BagId ");
        }
        //sb.Append("WHERE bmd.IsActive=1  and bmd.Id='" + Id + "' ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod(EnableSession = true)]
    public string GetBagandDeptSummaryDetails(string selection, string SelectedValue, string BagId, string category)
    {
        StringBuilder sb = new StringBuilder();
        if ((SelectedValue == "BagQuantity" && category == "Dept") || (SelectedValue == "BagWeight" && category == "Dept"))
        {
            sb.Append("SELECT bmd.Id,DATE_FORMAT(DATE,'%d-%b-%Y')DATE,TIME_FORMAT(TIME,'%I:%i %p')TIME,Remark,bim.BagName,CONCAT(CONCAT(em.Title,em.Name))DispatchedBy,CollectedBy,   ");
            if (SelectedValue == "BagQuantity")
                sb.Append("Quantity,    ");
            if (SelectedValue == "BagWeight")
                sb.Append("Weight,    ");
            sb.Append("DispatchedBy AS dispatchedById FROM bio_medicaldepartmentdispatch bmd INNER JOIN bio_InsertBagMaster    ");
            sb.Append("bim ON bim.ID=bmd.`BagId`  INNER JOIN employee_master em ON em.EmployeeID= bmd.DispatchedBy    ");
            sb.Append("where bmd.IsActive=1  AND bmd. RoleID='" + selection + "' AND bmd.`BagId`='" + BagId + "'   ");
            sb.Append("ORDER BY  DATE,TIME  ");

        }
        if ((SelectedValue == "BagQuantity" && category == "DeptRecieve") || (SelectedValue == "BagWeight" && category == "DeptRecieve"))
        {
            sb.Append("SELECT bmd.Id,DATE_FORMAT(DATE,'%d-%b-%Y')DATE,TIME_FORMAT(TIME,'%I:%i %p')TIME,Remark,bim.BagName,CONCAT(CONCAT(em.Title,em.Name))DispatchedBy,CollectedBy,   ");
            if (SelectedValue == "BagQuantity")
                sb.Append("Quantity,    ");
            if (SelectedValue == "BagWeight")
                sb.Append("Weight,    ");
            sb.Append("DispatchedBy AS dispatchedById FROM bio_medicaldepartmentdispatch bmd INNER JOIN bio_InsertBagMaster    ");
            sb.Append("bim ON bim.ID=bmd.`BagId`  INNER JOIN employee_master em ON em.EmployeeID= bmd.DispatchedBy    ");
            sb.Append("where bmd.IsActive=1 AND IsRecived=1    AND bmd. RoleID='" + selection + "' AND bmd.`BagId`='" + BagId + "'   ");
            sb.Append("ORDER BY  DATE,TIME  ");

        }
        if ((SelectedValue == "BagQuantity" && category == "Hospt") || (SelectedValue == "BagWeight" && category == "Hospt"))
        {
            sb.Append("SELECT bm.`BagName`,DATE_FORMAT(DATE,'%d-%b-%Y')DATE,TIME_FORMAT(TIME,'%I:%i %p')TIME,   ");
            if (SelectedValue == "BagQuantity")
                sb.Append("Quantity,    ");
            if (SelectedValue == "BagWeight")
                sb.Append("Weight,    ");
            sb.Append("CollectedBy,Remark,VehicleNo,bdo.`Name`,CONCAT(em.Title,em.Name)CreatedBy,CONCAT(em1.Title,em1.Name)DispatchedBy FROM bio_insertbagmaster bm     ");
            sb.Append("INNER JOIN bio_hospitaldispatch bhd ON bhd.BagId= bm.id     ");
            sb.Append("INNER JOIN employee_master em ON em.EmployeeID= bhd.CreatedBy     ");
            sb.Append("INNER JOIN bio_dispatchorganization bdo ON bdo.`Id`=bhd.`DispatchedTo`      ");
            sb.Append("INNER JOIN employee_master em1 ON em1.EmployeeID= bhd.DispatchedBy    ");
            sb.Append("where bhd.IsActive=1  AND BagId='" + BagId + "'   ");
            sb.Append("ORDER BY  DATE,TIME  ");

        }
        else if (SelectedValue == "DeptQuantity" || SelectedValue == "DeptWeight")
        {
            sb.Append("SELECT bmd.Id,DATE_FORMAT(DATE,'%d-%b-%Y')DATE,TIME_FORMAT(TIME,'%I:%i %p')TIME,Remark,bim.BagName,CONCAT(CONCAT(em.Title,em.Name))DispatchedBy,CollectedBy,   ");
            if (category == "BagQty")
                sb.Append("Quantity,    ");
            if (category == "BagWty")
                sb.Append("Weight,    ");
            sb.Append("DispatchedBy AS dispatchedById FROM bio_medicaldepartmentdispatch bmd INNER JOIN bio_InsertBagMaster    ");
            sb.Append("bim ON bim.ID=bmd.`BagId`  INNER JOIN employee_master em ON em.EmployeeID= bmd.DispatchedBy    ");
            sb.Append("where bmd.IsActive=1   AND bmd. RoleID='" + selection + "' AND bmd.`BagId`='" + BagId + "'   ");
            sb.Append("ORDER BY  DATE,TIME  ");

        }
        else if (SelectedValue == "HosptQuantity" || SelectedValue == "HosptWeight")
        {


            sb.Append("SELECT bm.`BagName`,DATE_FORMAT(DATE,'%d-%b-%Y')DATE,TIME_FORMAT(TIME,'%I:%i %p')TIME,   ");
            if (category == "BagQty")
                sb.Append("Quantity,    ");
            if (category == "BagWty")
                sb.Append("Weight,    ");
            sb.Append("CollectedBy,Remark,VehicleNo,bdo.`Name`,CONCAT(em.Title,em.Name)CreatedBy,CONCAT(em1.Title,em1.Name)DispatchedBy FROM bio_insertbagmaster bm     ");
            sb.Append("INNER JOIN bio_hospitaldispatch bhd ON bhd.BagId= bm.id     ");
            sb.Append("INNER JOIN employee_master em ON em.EmployeeID= bhd.CreatedBy     ");
            sb.Append("INNER JOIN bio_dispatchorganization bdo ON bdo.`Id`=bhd.`DispatchedTo`      ");
            sb.Append("INNER JOIN employee_master em1 ON em1.EmployeeID= bhd.DispatchedBy    ");
            sb.Append("where bhd.IsActive=1  AND bhd. id='" + selection + "' AND bhd.`BagId`='" + BagId + "'   ");
            sb.Append("ORDER BY  DATE,TIME  ");

        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod(EnableSession = true)]
    public string BindBioMedicalWasteReport(string FromDate, string ToDate, string Type, string dispatchedto, string deptstatus, string hospstatus, string DepartmentId, string centreIDs)
    {
        string status = string.Empty;
        if (Type == "1")
        {
            if (deptstatus != "0")
                status = deptstatus;
        }
        if (Type == "2")
        {
            if (hospstatus != "0")
                status = hospstatus;
        }
        if (Type == "1")
            Type = "Department";

        if (Type == "2")
            Type = "Hospital";
        StringBuilder sb = new StringBuilder();
        //var str1 = "CALL get_Biomedical_Report ('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + Type + "','" + dispatchedto + "','" + status + "','" + DepartmentId + "')";
        //DataTable dt = StockReports.GetDataTable(str1);
        if (Type == "Department" && status == "1")
        {
            sb.Append("SELECT bmd.Id,DATE_FORMAT(DATE,'%d-%b-%Y')DATE,TIME_FORMAT(TIME,'%I:%i %p')TIME,Quantity,Weight,Unit,bim.`BagName`,rm.RoleName AS Department,bmd.IsRecived, bmd.IsReject,bmd.IsDispatchFromHospital,CONCAT(em.Title,em.Name)DispatchedBy,bmd.Remark,cm.CentreName,cm.CentreID   ");
            sb.Append("FROM bio_medicaldepartmentdispatch bmd INNER JOIN bio_InsertBagMaster bim ON bim.ID=bmd.`BagId` INNER JOIN employee_master em ON em.EmployeeID= bmd.DispatchedBy  INNER JOIN f_rolemaster rm ON rm.Id= bmd.RoleId  INNER JOIN  Center_master cm ON cm.CentreID=bmd.CentreId WHERE bmd.IsActive=1   ");
            sb.Append(" AND bmd.IsRecived='0' AND bmd.IsReject='0' and bmd.Date>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND bmd.Date<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' and bmd.CentreId in (" + centreIDs + ") ");
            if (DepartmentId!="0")
            {

                sb.Append("and  bmd.RoleId='" + DepartmentId + "'  ");
            }
         
        }
        if (Type == "Department" && status == "2")
        {
            sb.Append("SELECT bmd.Id,DATE_FORMAT(DATE,'%d-%b-%Y')DATE,TIME_FORMAT(TIME,'%I:%i %p')TIME,Quantity,Weight,Unit,bim.`BagName`,rm.RoleName AS Department,bmd.IsRecived, bmd.IsReject,bmd.IsDispatchFromHospital,CONCAT(em.Title,em.Name)DispatchedBy,bmd.Remark,cm.CentreName,cm.CentreID   ");
            sb.Append("FROM  bio_medicaldepartmentdispatch  bmd INNER JOIN bio_InsertBagMaster bim ON bim.ID=bmd.`BagId` INNER JOIN employee_master em ON em.EmployeeID= bmd.DispatchedBy  INNER JOIN f_rolemaster rm ON rm.Id= bmd.RoleId  INNER JOIN  Center_master cm ON cm.CentreID=bmd.CentreId WHERE bmd.IsActive=1   ");
            sb.Append(" AND bmd.IsRecived='1' AND bmd.IsReject='0' and bmd.Date>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND bmd.Date<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' and bmd.CentreId in (" + centreIDs + ") ");
            if (DepartmentId != "0")
            {

                sb.Append("and  bmd.RoleId='" + DepartmentId + "'  ");
            }

        }
        if (Type == "Department" && status == "3")
        {
            sb.Append("SELECT bmd.Id,DATE_FORMAT(DATE,'%d-%b-%Y')DATE,TIME_FORMAT(TIME,'%I:%i %p')TIME,Quantity,Weight,Unit,bim.`BagName`,rm.RoleName AS Department,bmd.IsRecived, bmd.IsReject,bmd.IsDispatchFromHospital,CONCAT(em.Title,em.Name)DispatchedBy,bmd.Remark,cm.CentreName,cm.CentreID   ");
            sb.Append("FROM  bio_medicaldepartmentdispatch  bmd INNER JOIN bio_InsertBagMaster bim ON bim.ID=bmd.`BagId` INNER JOIN employee_master em ON em.EmployeeID= bmd.DispatchedBy  INNER JOIN f_rolemaster rm ON rm.Id= bmd.RoleId  INNER JOIN  Center_master cm ON cm.CentreID=bmd.CentreId WHERE bmd.IsActive=1   ");
            sb.Append(" AND bmd.IsRecived='0' AND bmd.IsReject='1' and bmd.Date>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND bmd.Date<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' and bmd.CentreId in (" + centreIDs + ") ");
            if (DepartmentId != "0")
            {

                sb.Append("and  bmd.RoleId='" + DepartmentId + "'  ");
            }

        }
        if (Type == "Hospital" && status == "1")
        {
            sb.Append("SELECT BM.Id,BM.BagName,BM.BagColour,BM.Image,DispatchedTo,BHD.Quantity,BHD.Weight,DATE_FORMAT(BHD.Date,'%d-%b-%Y') AS `DATE`,TIME_FORMAT(BHD.TIME,'%I:%i %p')TIME,CONCAT(em.Title,em.Name)DispatchedBy,BHD.Remark,BDO.name,cm.CentreName,cm.CentreID   ");
            sb.Append("FROM   bio_insertbagmaster BM INNER JOIN bio_hospitaldispatch BHD ON BHD.bagId=BM.Id AND BHD.IsActive=1 INNER JOIN  bio_dispatchorganization BDO ON BDO.Id=BHD.`DispatchedTo` INNER JOIN employee_master em ON em.EmployeeID= BHD.DispatchedBy  INNER JOIN  Center_master cm ON cm.CentreID=BHD.CentreId  ");
            sb.Append(" and BHD.Date>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND BHD.Date<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' and BHD.CentreId in (" + centreIDs + ") ");
            if (dispatchedto != "0")
            {

                sb.Append("and  BHD.DispatchedTo='" + dispatchedto + "'  ");
            }

        }
        if (Type == "Hospital" && status == "2")
        {
            sb.Append("SELECT BM.Id,BM.BagName,BM.BagColour,BM.Image,'' as DispatchedTo, BdD.Quantity,BdD.Weight,DATE_FORMAT(BdD.DATE,'%d-%b-%Y')DATE,TIME_FORMAT(BdD.TIME,'%I:%i %p')TIME,CONCAT(em.Title,em.Name)DispatchedBy,BdD.Remark,'' as name,cm.CentreName,cm.CentreID    ");
            sb.Append("FROM bio_insertbagmaster BM INNER JOIN bio_medicaldepartmentdispatch BdD ON BdD.bagId=BM.Id INNER JOIN employee_master em ON em.EmployeeID= BdD.DispatchedBy INNER JOIN  Center_master cm ON cm.CentreID=BdD.CentreId   ");
            sb.Append("  AND BdD.`IsRecived`=0 AND BdD.`IsReject`=1 AND BdD.`IsActive`=1 AND BdD.`IsDispatchFromHospital`=0 and BdD.Date>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND BdD.Date<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' and BdD.CentreId in (" + centreIDs + ") ");
            //if (dispatchedto != "0")
            //{

            //    sb.Append("and  BHD.DispatchedTo='" + dispatchedto + "'  ");
            //}

        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataSet set = new DataSet();
            DataColumn dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "From : " + FromDate.Trim() + "  To : " + ToDate.Trim();
            dt.Columns.Add(dc);
            set.Tables.Add(dt.Copy());
            if (Type == "Department")
            {
                set.Tables[0].TableName = "BioMedicalWasteReport";

               set.WriteXmlSchema(@"E:\BioMedicalWasteReport.xml");
                HttpContext.Current.Session["ds"] = set;
                HttpContext.Current.Session["Reportname"] = "BioMedicalWasteReport";
            }
            if (Type == "Hospital")
            {
               set.Tables[0].TableName = "BioMedicalWasteHospitalReport";
               set.WriteXmlSchema(@"E:\BioMedicalWasteHospitalReport.xml");
                HttpContext.Current.Session["ds"] = set;
                HttpContext.Current.Session["Reportname"] = "BioMedicalWasteHospitalReport";
            }

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, responseURL = "../../Design/common/Commonreport.aspx" });
        }
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });
        //HttpContext.Current.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(dt));
    }

}