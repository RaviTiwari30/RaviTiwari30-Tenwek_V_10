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


public partial class Design_CPOE_MedicalHistoryAgewise : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod(EnableSession = true)]

    public static string ReviewSystemMaster()
    {
        DataTable dt = StockReports.GetDataTable("SELECT * FROM cpoe_bodysystem_master WHERE Isactive=1");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true)]

    public static string bindMedicalHistoryAgeAndGenderWise(string sid, string Gender)
    {

        if (Gender == "B") { Gender = "M"; }
        DataTable dt = StockReports.GetDataTable(" SELECT * FROM cpoe_ReveiwSystemAgewise  WHERE BodysystemID="+sid+" and Gender='" + Gender + "' ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]

    public static string saveMedicalhistoryageandgender(List<getMedicalHistoryAgeAndGender> data)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        string message = "", Genderval = "";

        string[] subs = new string[0];

        try
        {


            excuteCMD.DML(tnx, "Delete From cpoe_ReveiwSystemAgewise where BodySystemID=@BodySystemID", CommandType.Text, new
            {
                BodySystemID = Util.GetInt(data[0].bodysystemID),
            });

            if (data[0].genderType == "B")
            {
                Genderval = "M,F";
                subs = Genderval.Split(',');


                for (int j = 0; j < subs.Length; j++)
                {
                    for (int i = 0; i < data.Count; i++)
                    {
                        string sqlCMD = "INSERT INTO cpoe_ReveiwSystemAgewise (BodySystemID,ToAgeYears,FromAge,ToAge,Gender,Active,CreatedDate,CreatedBy,CenterID,IPAddress) ";
                        sqlCMD += " VALUES(@BodySystemID,@ToAgeYears,@FromAge,@ToAge,@Gender,@Active,Now(),@CreatedBy,@CenterID,@IPAddress)";

                        excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                        {

                            BodySystemID = data[i].bodysystemID,
                            ToAgeYears = data[i].ageToYear,
                            FromAge = data[i].ageFrom,
                            ToAge = data[i].ageTo,
                            Gender = subs[j],
                            Active = "1",
                            CreatedBy = HttpContext.Current.Session["ID"].ToString(),
                            CenterID = HttpContext.Current.Session["CentreID"].ToString(),
                            IPAddress = HttpContext.Current.Request.UserHostAddress.ToString()

                        });
                    }
                }
            }
            else {
                for (int i = 0; i < data.Count; i++)
                {
                    string sqlCMD = "INSERT INTO cpoe_ReveiwSystemAgewise (BodySystemID,ToAgeYears,FromAge,ToAge,Gender,Active,CreatedDate,CreatedBy,CenterID,IPAddress) ";
                    sqlCMD += " VALUES(@BodySystemID,@ToAgeYears,@FromAge,@ToAge,@Gender,@Active,Now(),@CreatedBy,@CenterID,@IPAddress)";

                    excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                    {

                        BodySystemID = data[i].bodysystemID,
                        ToAgeYears = data[i].ageToYear,
                        FromAge = data[i].ageFrom,
                        ToAge = data[i].ageTo,
                        Gender = data[i].genderType,
                        Active = "1",
                        CreatedBy = HttpContext.Current.Session["ID"].ToString(),
                        CenterID = HttpContext.Current.Session["CentreID"].ToString(),
                        IPAddress = HttpContext.Current.Request.UserHostAddress.ToString()

                    });
                }
            }
            message = "Record save Scussessfully";
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error Occured Please Contact Administrator" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }



    }


    public class getMedicalHistoryAgeAndGender
    {
        public string genderType { get; set; }
        public decimal ageFrom { get; set; }
        public decimal ageTo { get; set; }
        public decimal ageToYear { get; set; }
        public int bodysystemID { get; set; }

    }
}