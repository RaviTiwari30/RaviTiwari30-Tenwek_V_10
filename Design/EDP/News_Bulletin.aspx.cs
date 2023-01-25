using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_EDP_News_Bulletin : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtNewsDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtExpiryDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            
        } 

        txtNewsDate.Attributes.Add("readOnly", "true");
        txtExpiryDate.Attributes.Add("readOnly", "true");

    }


    [WebMethod(EnableSession = true, Description = "News Bulliten")]
    public static string SaveNewsBulliten(string Subject, string Description, string Date, string Time, string Attachment, string isCapTure, string ExpiryDate, string ExpiryTime,string IsActive)
    {
        StringBuilder sbnew = new StringBuilder();
         
        if (Util.GetDateTime(Date).Date<Util.GetDateTime(DateTime.Now).Date)
        {

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Can't Select Previous Date." });

        }
         



        int CountSave = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {


            StringBuilder sb = new StringBuilder();

            sb.Append(" INSERT INTO  tenwek_news (Subject,Description,EntryBy,NewsDate,NewsTime,Attachment,IsAcpture,ExpiryDate,ExpiryTime ,IsActive)");
            sb.Append(" VALUES  (@Subject,@Description, @EntryBy,@Date,@NewsTime,@Attachment,@IsAcpture,@ExNewsDate,@ExNewsTime,@IsActive )");
            CountSave = excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                Subject = Subject,
                Description = Description,                  
                EntryBy = HttpContext.Current.Session["ID"].ToString(),
                Date=Util.GetDateTime(Date).ToString("yyyy-MM-dd"),
                NewsTime = Util.GetDateTime(Time).ToString("HH:mm:ss"),
                Attachment = Attachment,
                IsAcpture=isCapTure,
                ExNewsDate = Util.GetDateTime(ExpiryDate).ToString("yyyy-MM-dd"),
                ExNewsTime = Util.GetDateTime(ExpiryTime).ToString("HH:mm:ss"),
                IsActive=IsActive
            });



            if (CountSave > 0)
            {
                tnx.Commit();

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Save  Successfully" });

            }
            else
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
            }
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }


    [WebMethod(EnableSession = true, Description = "Update News Bulliten")]
    public static string UpdateNewsBulliten(string Subject, string Description, int Id, string NewsDate, string Time, string Attachment, string isCapTure, string ExpiryDate, string ExpiryTime,string IsActive)
    {

        StringBuilder sbnew = new StringBuilder();

        if (Util.GetDateTime(NewsDate).Date < Util.GetDateTime(DateTime.Now).Date)
        {

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Can't Update Previous Date." });

        }
       
        int CountSave = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {


            StringBuilder sb = new StringBuilder();

            sb.Append(" update tenwek_news set Subject=@Subject,Description=@Description,UpdateBy=@EntryBy,NewsDate=@NewsDate, ");
            sb.Append(" UpdateDate=now(),NewsTime=@NewsTime,Attachment=@Attachment,IsAcpture=@IsAcpture,ExpiryDate=@ExNewsDate,ExpiryTime=@ExNewsTime,IsActive=@IsActive  where Id=@Id ");
            CountSave = excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                Subject = Subject,
                Description = Description,
                EntryBy = HttpContext.Current.Session["ID"].ToString(),
                Id = Id ,
                NewsDate= Util.GetDateTime( NewsDate).ToString("yyyy-MM-dd"),
                NewsTime = Util.GetDateTime(Time).ToString("HH:mm:ss"),
                Attachment = Attachment,
                IsAcpture = isCapTure    ,
                ExNewsDate = Util.GetDateTime(ExpiryDate).ToString("yyyy-MM-dd"),
                ExNewsTime = Util.GetDateTime(ExpiryTime).ToString("HH:mm:ss"),
                IsActive=IsActive
            });



            if (CountSave > 0)
            {
                tnx.Commit();

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Update  Successfully" });

            }
            else
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
            }
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
     


    [WebMethod(EnableSession = true, Description = "News  Deactivate")]
    public static string DeactivateNewsBulliten(int Id)
    {
        int CountSave = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {


            StringBuilder sb = new StringBuilder();

            sb.Append(" update tenwek_news set IsActive=0,UpdateBy=@EntryBy, ");
            sb.Append(" UpdateDate=now() where Id=@Id ");
            CountSave = excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                  
                EntryBy = HttpContext.Current.Session["ID"].ToString(),
                Id = Id
            });



            if (CountSave > 0)
            {
                tnx.Commit();

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Deactivate  Successfully" });

            }
            else
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
            }
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }



    [WebMethod(EnableSession = true)]
    public static string GetDataToFill()
    {

        try
        {
            StringBuilder sbnew = new StringBuilder();

            sbnew.Append("SELECT TIME_FORMAT(tn.ExpiryTime,'%h:%i %p')NewsExTimes,DATE_FORMAT( tn.ExpiryDate,'%d-%b-%Y')NewsExDates, TIME_FORMAT(tn.NewsTime,'%h:%i %p')NewsTimes,DATE_FORMAT( tn.NewsDate,'%d-%b-%Y')NewsDates,DATE_FORMAT(tn.EntryDate,'%d-%b-%Y')EntryDate,tn.* FROM tenwek_news tn   ORDER BY  date(tn.NewsDate) DESC  ");
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
                    status = true,
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



}