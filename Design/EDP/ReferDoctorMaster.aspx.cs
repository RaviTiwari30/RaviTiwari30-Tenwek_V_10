using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;

public partial class Design_EDP_ReferDoctorMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static string LoadRefDoc(string Title, string RefDocName, string Type)
    {
        string result = "0";
        string strQ = "";
        strQ += " Select Name,DoctorID,Mobile,House_No,IsActive from doctor_referal Where ID >0 ";

        if (RefDocName != "")
            strQ += " AND Title='" + Title + "'  AND Name LIKE '" + RefDocName + "%' ";
        if (Type != "2")
            strQ += "  AND IsActive ='" + Type + "' ";
        strQ += " order by Name ";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(strQ);

        if (dt.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        return result;

    }

    [WebMethod(EnableSession = true)]
    public static string SaveRefDoc(string Title, string DocName, string Mobile, string Address)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            int IsExist = Util.GetInt(StockReports.ExecuteScalar(" Select count(*) from doctor_referal where Name='" + DocName + "' AND IsActive=1"));
            if (IsExist > 0)
                return "2";

            LoadCacheQuery.dropCache("ReferDoctor");
            doctor_referal ObjDr = new doctor_referal(tranX);
            ObjDr.Title = Util.GetString(Title);
            ObjDr.Name = Util.GetString(DocName);
            ObjDr.House_No = Util.GetString(Address);
            ObjDr.Mobile = Util.GetString(Mobile);
            ObjDr.CreatedBy = HttpContext.Current.Session["ID"].ToString();
            string Result = ObjDr.Insert();       
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
    public static string UpdateRefDoc(object Data)
    {
        List<doctor_referal> dataItem = new JavaScriptSerializer().ConvertToType<List<doctor_referal>>(Data);
        int len = dataItem.Count;

        if (len > 0)
        {
            string str = "";
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                for (int i = 0; i < len; i++)
                {

                    str = "UPDATE doctor_referal set Name='" + HttpUtility.UrlDecode(dataItem[i].Name) + "',Mobile='" + HttpUtility.UrlDecode(dataItem[i].Mobile) + "',House_No='" + HttpUtility.UrlDecode(dataItem[i].House_No) + "',IsActive='" + dataItem[i].IsActive + "', " +
                        " UpdatedDate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',UpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "' Where DoctorID = '" + dataItem[i].DoctorID + "'";

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
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
            return "";
    }

    //ALTER TABLE doctor_referal ADD COLUMN CreatedBy VARCHAR(20) DEFAULT NULL;
    //ALTER TABLE doctor_referal ADD COLUMN CreatedDate TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP;
    //ALTER TABLE doctor_referal ADD COLUMN UpdatedBy VARCHAR(20) DEFAULT NULL;
    //ALTER TABLE doctor_referal ADD COLUMN UpdatedDate DATETIME DEFAULT NULL;

    //DELIMITER $$

    //USE `sarvodaya`$$

    //DROP PROCEDURE IF EXISTS `doctor_referal_insert`$$

    //CREATE DEFINER=`root`@`localhost` PROCEDURE `doctor_referal_insert`( 
    //IN vLocation VARCHAR(10),IN vHospCode VARCHAR(20),IN vDoctorID VARCHAR(50),IN vTitle VARCHAR(10),IN vName VARCHAR(100),IN vIMARegistartionNo VARCHAR(50),IN vRegistrationOf VARCHAR(20),IN vRegistrationYear VARCHAR(10),IN vProfesionalSummary VARCHAR(500),IN vDesignation VARCHAR(500),IN vPhone1 VARCHAR(20),IN vPhone2 VARCHAR(20),IN vPhone3 VARCHAR(50),IN vMobile VARCHAR(100),IN vHouse_No VARCHAR(100),IN vStreet_Name VARCHAR(100),IN vLocality VARCHAR(50),IN vState VARCHAR(50),IN vCity VARCHAR(50),IN vStateRegion VARCHAR(50),IN vCountryRegion VARCHAR(50),IN vPincode VARCHAR(10),IN vGender VARCHAR(10),IN vEmail VARCHAR(50),IN vPorfilePageID VARCHAR(50),IN vDegree VARCHAR(100),IN vSpecialization VARCHAR(200),IN vUserName VARCHAR(50),IN vPassword VARCHAR(50),IN vDocDateTime VARCHAR(100),IN vIsVisible INT(4),IN vIsActive INT(1),IN vDocType INT(2),IN vCreatedBy VARCHAR(20) 
    // )
    //BEGIN 
    // DECLARE DocID INT;
    //SELECT get_Tran_id('doctor_referal') INTO DocID;
    //  IF(DocID IS NULL)
    // THEN
    // SET DocID = 0;  
    //   END IF;  
    // INSERT INTO doctor_referal( 
    //`Location`,`HospCode`,`DoctorID`,`Title`,`Name`,`IMARegistartionNo`,`RegistrationOf`,`RegistrationYear`,`ProfesionalSummary`,`Designation`,`Phone1`,`Phone2`,`Phone3`,`Mobile`,`House_No`,`Street_Name`,`Locality`,`State`,`City`,`StateRegion`,`CountryRegion`,`Pincode`,`Gender`,`Email`,`PorfilePageID`,`Degree`,`Specialization`,`UserName`,`Password`,`DocDateTime`,`IsVisible`,`IsActive`,`DocType`,CreatedBy
    // ) VALUES( 
    //vLocation,vHospCode,CONCAT('LSHHI','',DocID),vTitle,vName,vIMARegistartionNo,vRegistrationOf,vRegistrationYear,vProfesionalSummary,vDesignation,vPhone1,vPhone2,vPhone3,vMobile,vHouse_No,vStreet_Name,vLocality,vState,vCity,vStateRegion,vCountryRegion,vPincode,vGender,vEmail,vPorfilePageID,vDegree,vSpecialization,vUserName,vPassword,vDocDateTime,vIsVisible,vIsActive,vDocType,vCreatedBy
    // ); 
    // SELECT CONCAT('LSHHI','',DocID); 
    //END$$

    //DELIMITER ;

}