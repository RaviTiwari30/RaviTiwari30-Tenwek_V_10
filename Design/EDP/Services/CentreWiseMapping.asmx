<%@ WebService Language="C#" Class="CentreWiseMapping" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using MySql.Data.MySqlClient;
using System.Text;
using System.Collections.Generic;


[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class CentreWiseMapping : System.Web.Services.WebService
{

    [WebMethod(EnableSession=true)]
    public string HelloWorld()
    {
        return "Hello World";
       
    }


    [WebMethod]
    public string GetAllCentre()
    {
        DataTable dt = All_LoadData.dtbind_Center();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }



    [WebMethod]
    public string GetAllMappings(int centreID)
    {
        int templateNameCharCount = 40;
        ExcuteCMD excuteCMD = new ExcuteCMD();
        DataTable dtRoles = excuteCMD.GetDataTable(" SELECT r.RoleName TextField,r.ID ValueField,IFNULL(cr.ID,0) MapID,IFNULL(cr.IsPatientIndent,0) IsPatientIndent,IFNULL(cr.IsDepartmentIndent,0) IsDepartmentIndent,r.IsStore FROM f_rolemaster r LEFT JOIN f_centre_role cr ON cr.RoleID=r.ID AND cr.isActive=1 AND cr.CentreID=@centreID WHERE r.Active=1 ORDER BY r.RoleName", CommandType.Text, new
        {
            centreID = centreID
        });



        DataTable dtEmployees = excuteCMD.GetDataTable(" SELECT CONCAT(LEFT(CONCAT(r.Title,'',r.Name), " + templateNameCharCount + "),IF(LENGTH(CONCAT(r.Title,'',r.Name))>" + templateNameCharCount + ",'...','')) TextField,r.EmployeeID ValueField,IFNULL(cr.ID,0) MapID FROM employee_master r LEFT JOIN centre_access cr ON cr.EmployeeID=r.EmployeeID AND cr.isActive=1 AND cr.CentreAccess=@centreID WHERE r.IsActive=1 ORDER BY CONCAT(r.Title,'',r.Name) ", CommandType.Text, new
       {
           centreID = centreID
       });



        DataTable dtDoctors = excuteCMD.GetDataTable(" SELECT CONCAT(LEFT(CONCAT(r.Title,'',r.Name), " + templateNameCharCount + "),IF(LENGTH(CONCAT(r.Title,'',r.Name))>" + templateNameCharCount + ",'...','')) TextField,r.DoctorID ValueField,IFNULL(cr.ID,0) MapID FROM doctor_master r LEFT JOIN f_center_doctor cr ON cr.DoctorID=r.DoctorID AND cr.isActive=1 AND cr.CentreID=@centreID WHERE r.IsActive=1 ORDER BY CONCAT(r.Title,'',r.Name)", CommandType.Text, new
        {
            centreID = centreID
        });


       // templateNameCharCount = 28;
        DataTable dtPanels = excuteCMD.GetDataTable(" SELECT CONCAT(LEFT(r.Company_Name, " + templateNameCharCount + "),IF(LENGTH(r.Company_Name)>" + templateNameCharCount + ",'...','')) TextField,r.PanelID ValueField,IFNULL(cr.ID,0) MapID FROM f_panel_master r LEFT JOIN f_center_panel cr ON cr.PanelID=r.PanelID AND cr.isActive=1 AND cr.CentreID=@centreID WHERE r.IsActive=1 order by r.Company_Name", CommandType.Text, new
        {
            centreID = centreID
        });




        return Newtonsoft.Json.JsonConvert.SerializeObject(new { dtRoles = dtRoles, dtEmployees = dtEmployees, dtDoctors = dtDoctors, dtPanels = dtPanels });

    }



    public class mappedItem
    {
        public int centreID { get; set; }
        public string valueField { get; set; }
        public string createdBy { get; set; }
        public string Email {get; set;}
         public string ContactPerson {get; set;}
    }

    [WebMethod(EnableSession=true)]
    public string SavesMappingsDetails(int centreID, List<mappedItem> mappedRoles, List<mappedItem> mappedEmployees, List<mappedItem> mappedDoctors, List<mappedItem> mappedPanels, List<mappedItem> patientIndentMapping, List<mappedItem> deptIndentMapping)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var userID = HttpContext.Current.Session["ID"].ToString();


        try
        {

            StringBuilder sqlCMD = new StringBuilder();


            //********for panel ********\\
            sqlCMD.Append("UPDATE  f_center_panel  SET  isActive=0,UpdatedBy=@createdBy,UpdatedDateTime=now()   WHERE CentreID=@centreID AND isActive=1");
            excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
            {
                centreID = centreID,
                createdBy= userID
            });
            
            sqlCMD = new StringBuilder("INSERT INTO f_center_panel (PanelID,CentreID,CreatedBy,Email, ContactPerson ) VALUES (@valueField,@centreID,@createdBy,@Email,@ContactPerson)");
            for (int i = 0; i < mappedPanels.Count; i++)
            {
                mappedPanels[i].createdBy = userID;
                
                DataTable dt = StockReports.GetDataTable(" select Email, ContactPerson from f_center_panel where PanelID=" +  mappedPanels[i].valueField + " and CentreID=" +  mappedPanels[i].centreID + " order by ID DESC LIMIT 1 ");
                if(dt.Rows.Count>0 && dt!= null)
                {
                     mappedPanels[i].Email = dt.Rows[0]["Email"].ToString();
                     mappedPanels[i].ContactPerson = dt.Rows[0]["ContactPerson"].ToString();
                }
                excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, mappedPanels[i]);
            }
            
            //********for panel ********\\


            //********for doctor ********\\
            sqlCMD = new StringBuilder("UPDATE  f_center_doctor  SET  isActive=0,UpdatedBy=@createdBy,UpdatedDateTime=now()  WHERE CentreID=@centreID AND isActive=1");
            excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
            {
                centreID = centreID,
                createdBy= userID
            });


            sqlCMD = new StringBuilder("INSERT INTO f_center_doctor(DoctorID,CentreID,CreatedBy) VALUES (@valueField,@centreID,@createdBy)");
            for (int i = 0; i < mappedDoctors.Count; i++)
            {
                mappedDoctors[i].createdBy = userID;
                excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, mappedDoctors[i]);
            }
            //********for doctor********\\



            //********for Employees ********\\
            sqlCMD = new StringBuilder("UPDATE  centre_access  SET  isActive=0,UpdatedBy=@createdBy,UpdateDate=now()  WHERE CentreAccess=@centreID AND isActive=1");
            excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
            {
                centreID = centreID,
                createdBy= userID
            });


            sqlCMD = new StringBuilder("INSERT INTO centre_access(EmployeeID,CentreAccess,IsActive,CreatedBy,CreatedDate) VALUES (@valueField,@centreID,1,@createdBy,now())");
            for (int i = 0; i < mappedEmployees.Count; i++)
            {
                mappedEmployees[i].createdBy = userID;
                excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, mappedEmployees[i]);
            }
            //********for Employees ********\\



            //********for Role ********\\
            if (HttpContext.Current.Session["ID"].ToString() == "EMP001")
            {
                sqlCMD = new StringBuilder("UPDATE  f_centre_role  SET  isActive=0,UpdatedBy=@createdBy,UpdatedDateTime=now()  WHERE CentreID=@centreID AND isActive=1");
                excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
                {
                    centreID = centreID,
                    createdBy = userID
                });


                sqlCMD = new StringBuilder("INSERT INTO f_centre_role(RoleID,CentreID,CreatedBy) VALUES (@valueField,@centreID,@createdBy)");
                for (int i = 0; i < mappedRoles.Count; i++)
                {
                    mappedRoles[i].createdBy = userID;
                    excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, mappedRoles[i]);
                }

                sqlCMD = new StringBuilder("UPDATE  f_centre_role  SET  IsPatientIndent=1  WHERE CentreID=@centreID AND isActive=1 and RoleID=@valueField ");
                for (int i = 0; i < patientIndentMapping.Count; i++)
                {
                    excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, patientIndentMapping[i]);
                }

                sqlCMD = new StringBuilder("UPDATE  f_centre_role  SET  IsDepartmentIndent=1  WHERE CentreID=@centreID AND isActive=1 and RoleID=@valueField ");
                for (int i = 0; i < deptIndentMapping.Count; i++)
                {
                    excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, deptIndentMapping[i]);
                }
            }
            LoadCacheQuery.dropAllCache();
            
            
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



    [WebMethod]
    public string bindPanelGroup()
    {
        DataTable dtData = StockReports.GetDataTable("Select PanelGroupID,PanelGroup from f_panelgroup where active=1 order by PanelGroupID");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtData);

    }

    public class mappedRolesWisePanelGroup
    {
        public int centreID { get; set; }
        public string roleID { get; set; }
        public string PanelGroupIDs { get; set; }
        public string createdBy { get; set; }
    }
    
    

   [WebMethod]
   public string GetRoleWithPanelGroupMappings(int centreID, string roleName)
   {
       ExcuteCMD excuteCMD = new ExcuteCMD();
       DataTable dtRoles = excuteCMD.GetDataTable(" SELECT r.RoleName,r.ID ,IFNULL(crp.PanelGroupID,'') AS PanelGroupID,GROUP_CONCAT(pg.`PanelGroup`) AS PanelGroup FROM f_rolemaster r INNER JOIN f_centre_role cr ON cr.RoleID=r.ID AND cr.isActive=1  AND cr.CentreID=@centreID LEFT JOIN f_centre_role_panelgroup_mapping crp ON crp.`CentreID`=@centreID AND crp.`RoleID`=cr.`RoleID` AND crp.`isActive`=1 LEFT JOIN f_panelgroup pg ON FIND_IN_SET(pg.`PanelGroupID`,crp.`PanelGroupID`) WHERE r.Active=1 AND if(@role<>'', r.RoleName like @role,1=1)  GROUP BY r.ID ORDER BY r.RoleName", CommandType.Text, new
       {
           centreID = centreID,
           role = roleName == string.Empty ? "" : "%" + roleName + "%",
       });


       return Newtonsoft.Json.JsonConvert.SerializeObject(dtRoles);

   }
    
   [WebMethod(EnableSession = true)]
   public string SaveCentreWiseRoleWisePanelGroup(int centreID, List<mappedRolesWisePanelGroup> MappedRolesWisePanelGroup)
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
       
}