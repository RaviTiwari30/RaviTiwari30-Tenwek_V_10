<%@ WebService Language="C#" Class="DocGrouprateMaster" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using System.Collections.Generic;
using System.Web.Script;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Text;
using MySql.Data.MySqlClient;
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]
public class DocGrouprateMaster  : System.Web.Services.WebService {
   
    
    
    [WebMethod(EnableSession = true)]
    public string SearchDocData(string Type, string PanelID)
    {
        Docgrouprate objdoc = new Docgrouprate();
       DataTable dt = objdoc.GetDataTable(Type, PanelID);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
       
        
    }


    [WebMethod(EnableSession = true)]
    public string SaveDocData(string Docdata, string Panelid, string Type)
    {
        Docgrouprate objdoc = new Docgrouprate();
        return objdoc.Save(Docdata, Panelid, Type);
       

    }
     [WebMethod(EnableSession = true)]
    public string SaveDocDataAll(string UserId, string Type)
    {
        Docgrouprate objdoc = new Docgrouprate();
        return objdoc.SaveDocAll(UserId, Type);
         

    }
     [WebMethod]
     public string bindDocPanel(string Type)
     {
         DataTable dt=new DataTable();
        if(Type =="IPD")
            dt=CreateStockMaster.LoadPanelCompanyRefIPDDoc();
        else
            dt = CreateStockMaster.LoadPanelCompanyRefOPDDoc();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

     }

     [WebMethod]
     public string bindDocDepartment()
     {
         DataTable dt=StockReports.GetDataTable("select Name,ID from type_master where TypeID =5 order by Name");
         if(dt.Rows.Count>0)
             return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
         else
             return "";
     }
     [WebMethod(EnableSession = true, Description = "Save Doctor Department")]
     public string SaveDocDepartment(string DocDepartmentName)
     {
         int count = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM type_master WHERE Name='" + DocDepartmentName.Trim() + "' AND TypeID=5"));
         if (count > 0)
             return "2";

         MySqlConnection con = Util.GetMySqlCon();
         con.Open();
         MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
         try
         {

             MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO type_master(Name,TypeID,Type) VALUES('" + DocDepartmentName + "',5,'Doctor-Department')");
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
     [WebMethod(EnableSession = true, Description = "Update Doctor Department")]
     public string UpdateDocDepartment(string DocDepartmentName,string ID)
     {

         int count = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM type_master WHERE Name='" + DocDepartmentName + "' AND ID != '" + ID + "' "));
         if (count > 0)
             return "2";
         MySqlConnection con = Util.GetMySqlCon();
         con.Open();
         MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
         try
         {

             MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update type_master Set Name='" + DocDepartmentName.Trim() + "' where ID ='" + ID + "' AND TypeID=5");
             MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update doctor_master Set Designation='" + DocDepartmentName.Trim() + "' where DocDepartmentID ='" + ID + "' ");
             LoadCacheQuery.dropCache("Doctor_" + Session["CentreID"].ToString());
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
     [WebMethod]
     public string bindDocSpecialization()
     {
         DataTable dt = StockReports.GetDataTable("select Name,ID from type_master where TypeID =3 order by Name");
         if (dt.Rows.Count > 0)
             return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
         else
             return "";
     }
     [WebMethod(EnableSession = true, Description = "Save Doctor Specialization")]
     public string SaveDocSpecialization(string DocSpecialization)
     {
         int count = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM type_master WHERE Name='" + DocSpecialization.Trim() + "' AND TypeID=3"));
         if (count > 0)
             return "2";

         MySqlConnection con = Util.GetMySqlCon();
         con.Open();
         MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
         try
         {

             MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO type_master(Name,TypeID,Type) VALUES('" + DocSpecialization + "',3,'Doctor-Specialization')");
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
     [WebMethod(EnableSession = true, Description = "Update Doctor Specialization")]
     public string UpdateDocSpecialization(string DocSpecializationName, string ID, string Specialization)
     {

         int count = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM type_master WHERE Name='" + DocSpecializationName + "' AND ID != '" + ID + "' AND TypeID=3"));
         if (count > 0)
             return "2";
         MySqlConnection con = Util.GetMySqlCon();
         con.Open();
         MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
         try
         {
             MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update type_master Set Name='" + DocSpecializationName.Trim() + "' where ID ='" + ID + "' AND TypeID=3");
             MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update doctor_master Set Specialization='" + DocSpecializationName.Trim() + "' where Specialization ='" + Specialization.Trim() + "' ");
             tnx.Commit();
             LoadCacheQuery.dropCache("Doctor_" + Session["CentreID"].ToString());
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

    [WebMethod(EnableSession = true)]
     public string SaveDoctorUnit(object ShareDetails, string DoctorID)
     {
         List<DoctorUnit> sharedetails = new JavaScriptSerializer().ConvertToType<List<DoctorUnit>>(ShareDetails);

         MySqlConnection con = new MySqlConnection();
         con = Util.GetMySqlCon();
         con.Open();
         MySqlTransaction objTran = con.BeginTransaction(IsolationLevel.ReadCommitted);
         string val = "";
         try
         {
             for (int i = 0; i < sharedetails.Count; i++)
             {
                 DoctorMaster objDoctorMaster = new DoctorMaster(objTran);
                 objDoctorMaster.DoctorListId = Util.GetString(sharedetails[i].DoctorListId);
                 objDoctorMaster.UnitDoctorID = Util.GetString(DoctorID);
                 objDoctorMaster.CreatedDateTime = DateTime.Now;
                 objDoctorMaster.CreatedBy = Util.GetString(HttpContext.Current.Session["ID"].ToString());
                 objDoctorMaster.IsActive = 1;
                 objDoctorMaster.Position = Util.GetString(sharedetails[i].Position);

                 val = objDoctorMaster.InsertDoctorUnit();
             }

             objTran.Commit();
             objTran.Dispose();
             con.Close();
             con.Dispose();
             
             return val;
         }
         catch (Exception ex)
         {
             objTran.Rollback();
             objTran.Dispose();
             con.Close();
             con.Dispose();
             ClassLog cl = new ClassLog();
             cl.errLog(ex);
             return "";
         }
     }
}

