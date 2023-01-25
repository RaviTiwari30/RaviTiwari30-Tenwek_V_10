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


public partial class Design_CPOE_PatientAllergy : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod(EnableSession = true)]
    public static string BindAllergyList()
    {
        DataTable dt = StockReports.GetDataTable(" SELECT ID,AllergyName FROM Allergymaster WHERE Active=1  ORDER BY AllergyName ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true)]
    public static string SaveNewAllergy(string Name, string Type,string ID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var message = "";
            string str = "SELECT COUNT(*) FROM Allergymaster WHERE AllergyName='" + Name + "'";
            var IsExist = Util.GetInt(StockReports.ExecuteScalar(str));
            if (IsExist > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Allergy Name Already Exit Kindly Type New Allergy" });
            }
            else
            {
                if (Type == "Save")
                {
                    var sqlCMD = "INSERT INTO Allergymaster (AllergyName,Active,IPAddress,CreateDate,CreateBy,CentreID)VALUES(@AllergyName,1,@IPAddress,NOW(),@CreateBy,@CentreID)";
                    excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                    {
                        AllergyName = Name,
                        IPAddress = HttpContext.Current.Request.UserHostAddress,
                        CreateBy = HttpContext.Current.Session["ID"].ToString(),
                        CentreID = HttpContext.Current.Session["CentreID"]

                    });
                       message = "Allergy Save Successfully";
                }
                else 
                {
                    var sqlCMD = "UPDATE Allergymaster SET AllergyName=@AllergyName,IPAddress=@IPAddress,UpdateDate=NOW(),UpdateBy=@UpdateBy WHERE ID=@ID;";
                    excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                    {
                        AllergyName = Name,
                        IPAddress = HttpContext.Current.Request.UserHostAddress,
                        UpdateBy = HttpContext.Current.Session["ID"].ToString(),
                        ID = Util.GetInt(ID)

                    });
                    message = "AllergyName Update Successfully";
                }
                
            }

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message, Type = Type });
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

    public static string savePatientAllergy(string PAllergy, string TID, string PID, string APPID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var message = "";
        try
        {

            int isExit = Util.GetInt(StockReports.ExecuteScalar(" select count(*) from cpoe_hpexam where app_id='" + APPID + "' "));

            // int isExit = Util.GetInt(StockReports.ExecuteScalar(" select count(*) from cpoe_hpexam where app_id='" + APPID + "' and Allergies='" + PAllergy.Replace("'", "@") + "'  "));

            if (isExit ==0)
            {
                string sqlCmd = "INSERT INTO cpoe_hpexam (TransactionID,PatientID,Allergies,App_ID,EntryBy,EntryDate) VALUES(@TransactionID,@PatientID,@Allergies,@App_ID,@EntryBy,NOW())";

                excuteCMD.DML(tnx, sqlCmd, CommandType.Text, new
                {
                    TransactionID = TID,
                    PatientID = PID,
                    Allergies = PAllergy.Replace("'", "@"),
                    App_ID = Util.GetInt(APPID),
                    EntryBy = HttpContext.Current.Session["ID"].ToString()

                });
                message = "Patient Allergy Save Successfully";
                tnx.Commit();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message });
            }
            else
            {
                int isContain = Util.GetInt(StockReports.ExecuteScalar(" select count(*) from cpoe_hpexam where app_id='" + APPID + "' and Allergies like '%" + PAllergy.Replace("'", "@") + "%'  "));

                if (isContain == 0)
                {
                    string sqlCMD = "Update cpoe_hpexam set Allergies=concat(Allergies,',',@Allergies),UpdateBy=@UpdateBy,UpdateDate=NOW() where App_ID=@AppID";

                    excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                    {
                        Allergies = PAllergy.Replace("'", "@"),
                        UpdateBy = HttpContext.Current.Session["ID"].ToString(),
                        AppID = Util.GetInt(APPID),
                    });
                    tnx.Commit();

                    message = "Patient Allergy Save Successfully";
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message });

                }
                else
                {
                    message = "Patient Allergy Already added";
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message });

                }


            }

          

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

    [WebMethod(EnableSession=true)]
        public  static string BindPatientAllergy(string Appid)
    {
        var  dt = Util.GetString(StockReports.ExecuteScalar("SELECT  IFNULL(Allergies,'')Allergies FROM cpoe_hpexam WHERE app_id='" + Appid + "' order by id desc limit 1 "));

            if(dt!="")
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new {status=true,response=dt});
            }
            else{return Newtonsoft.Json.JsonConvert.SerializeObject(new {status=false,response=""});}

    }

    [WebMethod(EnableSession = true)]
    public static string GetDataDetails(string Appid, string TID)
    {

        try
        {
            StringBuilder sbnew = new StringBuilder();

            sbnew.Append(" SELECT * from cpoe_hpexam WHERE TransactionID='" + TID + "'");
           
            DataTable dt = StockReports.GetDataTable(sbnew.ToString());
            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new
                {
                    status = true,
                    data = dt
                });

            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new
                {
                    status = false,
                    data = "No data found."
                });
            }

        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data = ex.ToString() });

        }
    }

    [WebMethod(EnableSession = true)]

    public static string DeleteData(int Id, string AllergyName)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var message = "";
        try
        {


            string sqlCmd = "INSERT INTO cpoe_hpexam_afterdelete SELECT * FROM cpoe_hpexam WHERE id=@Id";

                excuteCMD.DML(tnx, sqlCmd, CommandType.Text, new
                {
                    
                    Id =Id

            });

            string Allergies = Util.GetString(StockReports.ExecuteScalar(" select Allergies from cpoe_hpexam where id='" + Id + "' "));

            string[] NewAll = Allergies.Split(',');

            List<string> values = Allergies.Split(',').ToList();
            values.Remove(AllergyName);
            string NewAllewrgyString = "";
            int count = 0;
            foreach (string item in values)
            {

                if (count == 0)
                {
                    NewAllewrgyString = item;
                }
                else
                {
                    NewAllewrgyString = NewAllewrgyString + "," + item;
                }
                count = count + 1;
            }


            string sqlCMD = "Update cpoe_hpexam set Allergies=@Allergies,UpdateBy=@UpdateBy,UpdateDate=NOW() where id=@AppID";

            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                Allergies = NewAllewrgyString,
                UpdateBy = HttpContext.Current.Session["ID"].ToString(),
                AppID = Util.GetInt(Id),
            });


            if (NewAllewrgyString == "")
            {
                string SqlDelete = "DELETE FROM cpoe_hpexam WHERE Id=@Id";
                excuteCMD.DML(tnx, SqlDelete, CommandType.Text, new
                {
                    Id = Id
                });
            }


            tnx.Commit();
            message = "Patient Allergy Delete Successfully";

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