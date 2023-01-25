using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.Services;
using System.Linq;
using MySql.Data.MySqlClient;
using System.Text;

public partial class Design_IPD_PatientWardTypeListManagement : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod(EnableSession = true)]
    public static string Bindwardtypepatientlist(string RoomType, string PID, string TID, string Team)
    {

        string DRID = Util.GetString(StockReports.ExecuteScalar("SELECT de.DoctorID FROM doctor_employee de WHERE de.EmployeeID='" + Util.GetString(HttpContext.Current.Session["ID"].ToString()) + "' limit 1 "));
        string IsDrExist = "1";
        if (string.IsNullOrEmpty(DRID))
        {
            IsDrExist = "0"; 
        }
        DataTable dt = new DataTable();
        string strQ = " call WardTypeListManagement('" + RoomType + "','" + PID + "','" + TID + "','" + Team + "','"+DRID+"')";
        dt = StockReports.GetDataTable(strQ);
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = dt, IsDrExist = IsDrExist });
                  
        }
        else {
            
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });
         
        
        }
        
    
    }
    


    [WebMethod(EnableSession = true)]
    public static string Bindwardtypepatientlistreport(string RoomType, string PID, string TID, string Team)
    {
        DataTable dt = new DataTable();
        string strQ = " call WardTypeListManagement('" + RoomType + "','" + PID + "','" + TID + "','" + Team + "','')";
        dt = StockReports.GetDataTable(strQ);
        if (dt.Rows.Count > 0)
        {
            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = "Ward Type Patient List";

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "No Record Found" });
        }
        else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "No Record Found" }); }


    }

    [WebMethod(EnableSession = true)]

    public static string SaveNotes(string DoctorID, string TransactionID, string PatientID, string ProblemNote, string PlanNote, string  SaveType,string ID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var message = "";

            if (SaveType == "Save")
            {
                var sqlCMD = "insert into doctorpatientnoteslist (ProblemNotes,DoctorID,TransactionID,PatientID,Createdby,PlanNotes,Active,CreatedDate)value(@ProblemNotes,@DoctorID,@TransactionID,@PatientID,@Createdby,@PlanNotes,@Active,NOW())";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                      {
                          ProblemNotes = ProblemNote,
                          DoctorID = Util.GetString(DoctorID),
                          TransactionID = TransactionID,
                          PatientID = PatientID,
                          PlanNotes = PlanNote,
                          Createdby = HttpContext.Current.Session["ID"].ToString(),
                          Active = 1

                      });
                message = "Record Save Sucessfully";
            }
            else
            {
                var sqlCMD = "UPDATE doctorpatientnoteslist SET ProblemNotes=@ProblemNotes,PlanNotes=@PlanNotes,UpdateDate=NOW(),UpdateBy=@UpdateBy WHERE ID=@ID;";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    ProblemNotes = ProblemNote,
                    PlanNotes = PlanNote,
                    UpdateBy = HttpContext.Current.Session["ID"].ToString(),
                    ID = Util.GetInt(ID)

                });
                message = "Record Update Successfully";
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


    [WebMethod(EnableSession = true)]

    public static string SaveProblemNotes(string DoctorID, string TransactionID, string PatientID, string ProblemNote, string PlanNote)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var message = "";


            var sqlCMD = "insert into doctorpatientnoteslist (ProblemNotes,DoctorID,TransactionID,PatientID,Createdby,PlanNotes,Active,CreatedDate)value(@ProblemNotes,@DoctorID,@TransactionID,@PatientID,@Createdby,@PlanNotes,@Active,NOW())";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                ProblemNotes = ProblemNote,
                DoctorID = Util.GetString(DoctorID),
                TransactionID = TransactionID,
                PatientID = PatientID,
                PlanNotes = PlanNote,
                Createdby = HttpContext.Current.Session["ID"].ToString(),
                Active = 1

            });
            message = "Record Save Sucessfully";


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
    public static string bindpatientnotes(string TransactionID)
    {
        DataTable dt = StockReports.GetDataTable("select d.ID,Ifnull(ProblemNotes,'')ProblemNotes,Ifnull(PlanNotes,'')PlanNotes,TransactionID,concat(em.Title,' ',em.NAME)CreatedBy,DATE_FORMAT(d.CreatedDate,'%d-%b-%Y')CreatedDate from doctorpatientnoteslist d inner join employee_master em on em.EmployeeID=d.Createdby where TransactionID='" + TransactionID + "'");
     
        if (dt.Rows.Count > 0)
        {
         
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
        }
        else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "" }); }


    }

    [WebMethod(EnableSession = true)]
    public static string bindPMP(string TID)
    {
        DataTable dt = StockReports.GetDataTable("select d.ID,ProblemNotes,PlanNotes,TransactionID from doctorpatientnoteslist d where TransactionID='"+TID+"' ORDER BY D.ID desc limit 1");

        if (dt.Rows.Count > 0)
        {

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
        }
        else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "No Problem,Plan & Medication Found.." }); }


    }

    [WebMethod(EnableSession = true)]
    public static string bindDoctorTeamList()
    {
        DataTable dt = StockReports.GetDataTable("SELECT dm.DoctorID,CONCAT(dm.Title,' ',dm.name)DoctorName FROM doctor_master dm  WHERE  IsUnit=1 AND dm.IsActive=1");
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
        }
        else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "" }); }
    }



    [WebMethod(EnableSession = true)] 
    public static string  RemoveInvolvedDr( string TransactionID )
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var message = "";
          
            DataTable dt = StockReports.GetDataTable("SELECT dm.DoctorID, CONCAT(dm.Title,'',dm.NAME)drName FROM doctor_master dm INNER JOIN  doctor_employee de ON de.DoctorID=dm.DoctorID WHERE de.EmployeeID='" + Util.GetString(HttpContext.Current.Session["ID"].ToString()) + "'");


            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM f_multipledoctor_ipd   WHERE  TransactionID='" + TransactionID + "' AND  DoctorID='" + dt.Rows[0]["DoctorID"].ToString() + "' ");

           
            var sqlCMD = "insert into f_multipledoctor_ipd_removed (DoctorID, TransactionID, DoctorName)value(@DoctorID,@TransactionID,@DoctorName)";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                DoctorID = dt.Rows[0]["DoctorID"].ToString(),
                TransactionID = TransactionID,
                DoctorName = dt.Rows[0]["drName"].ToString(),
            });

             


            message = "Removed Sucessfully";

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
    public static string AddInvolvedDr(string TransactionID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var message = "";
            DataTable dt = StockReports.GetDataTable("SELECT dm.DoctorID, CONCAT(dm.Title,'',dm.NAME)drName FROM doctor_master dm INNER JOIN  doctor_employee de ON de.DoctorID=dm.DoctorID WHERE de.EmployeeID='"+ Util.GetString(HttpContext.Current.Session["ID"].ToString())+"'");


            var sqlCMD = "insert into f_multipledoctor_ipd (DoctorID, TransactionID, DoctorName)value(@DoctorID,@TransactionID,@DoctorName)";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                DoctorID = dt.Rows[0]["DoctorID"].ToString(),
                TransactionID= TransactionID,
                DoctorName = dt.Rows[0]["drName"].ToString(),
            });
            message = "Added Sucessfully";
             
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