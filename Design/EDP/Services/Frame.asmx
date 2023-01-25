<%@ WebService Language="C#" Class="Frame" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Script;
using System.Collections.Generic;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class Frame : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }
    [WebMethod(EnableSession = true)]
    public string SaveFrame(List<FrameData> Data)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            int Count = Util.GetInt(StockReports.ExecuteScalar("Select Count(*) from f_framemenumaster where FrameID=" + Data[0].FrameID + " AND URL='" + Data[0].URL + "'"));
            if (Count == 0)
            {
                string str = "Insert into f_framemenumaster(FrameID,FrameName,FileName,URL,Description,CreatedBy,MenuHeader) " +
                    " values(" + Data[0].FrameID + ",'" + Data[0].FrameName + "','" + HttpUtility.UrlDecode(Data[0].FileName) + "','" + Data[0].URL + "','" + Data[0].Description + "','" + HttpContext.Current.Session["ID"].ToString() + "','"+Data[0].MenuHeader+"')";
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str);
                tranX.Commit();
                return "1";
            }

            else
            {
                return "2";
            }
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
    public string FrameRoleInsert(List<FrameRole> Data)
    {
        int len = Data.Count;
        if (len > 0)
        {
            
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction();
            try
            {
                for (int i = 0; i < Data.Count; i++)
                {
                    int SequenceNo = (Data[i].SequenceNo) + 1;
                    int Count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_frame_role where URLID=" + Data[i].URLId + " AND RoleID=" + Data[i].RoleID + ""));
                    if (Count == 0)
                    {
                       
                        string str = "Insert into f_frame_role(URLID,RoleID,SequenceNo,CreatedBy) " +
                  " values(" + Data[i].URLId + ",'" + Data[0].RoleID + "'," + SequenceNo + ",'" + HttpContext.Current.Session["ID"].ToString() + "')";
                        MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str);

                    }
                    else
                    {
                        MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE f_frame_role SET IsActive=1,SequenceNo=" + SequenceNo + " WHERE URLID=" + Data[i].URLId + " AND RoleID=" + Data[i].RoleID + "");
                    }
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
        else
        {
            return "0";
        }

    }
    [WebMethod(EnableSession = true)]
    public string FrameRoleUpdate(List<FrameRole> Data)
    {
        int len = Data.Count;
        if (len > 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction();
            try
            {
                for (int i = 0; i < Data.Count; i++)
                {
                    
                        MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE f_frame_role SET IsActive=0 WHERE URLID=" + Data[i].URLId + " AND RoleID=" + Data[i].RoleID + "");
                 

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
        else
        {
            return "0";
        }

    }
   
    [WebMethod(EnableSession = true)]
    public string BindFrame(int FrameId, int RoleID)
    {
        string rtrn = "";
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT t1.FrameName,t1.Id FROM ( SELECT CONCAT(fmm.FileName,'(',fmm.Description,')')FrameName,fmm.id ");
        sb.Append(" FROM f_framemenumaster fmm INNER JOIN f_framemaster fm ON fmm.frameid=fm.frameid WHERE fm.IsActive = 1 AND fmm.IsActive = 1 ");
        sb.Append("  AND fm.frameid=" + FrameId + " )t1 LEFT JOIN ( SELECT fmm.FileName,fmm.id FROM f_framemenumaster fmm  ");
        sb.Append(" INNER JOIN f_frame_role fr ON fmm.ID = fr.URLID  INNER JOIN f_rolemaster rm ON fr.RoleID = rm.ID ");
        sb.Append("  WHERE fmm.IsActive = 1 AND fr.IsActive = 1  AND rm.ID = " + RoleID + " ");
        sb.Append("AND fmm.frameid=" + FrameId + ")t2 ON t1.Id = t2.Id WHERE t2.Id IS NULL ORDER BY T1.FrameName ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            return rtrn;
        }
        else
        {
            return rtrn;
        }
    }
    [WebMethod(EnableSession = true)]
    public string BindLoginType(int FrameId, int RoleID)
    {
        string rtrn = "";
        StringBuilder sb = new StringBuilder();
        sb.Append("   SELECT CONCAT(fmm.FileName,'(',fmm.Description,')')FrameName,fmm.Id ");
        sb.Append(" FROM f_framemenumaster fmm INNER JOIN f_frame_role Fr ON ");
        sb.Append(" fmm.Id=Fr.URLId AND Fr.RoleID=" + RoleID + " AND fmm.frameid=" + FrameId + " AND Fr.IsActive=1 ORDER BY fr.SequenceNo    ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            return rtrn;
        }
        else
        {
            return rtrn;
        }
    }
    [WebMethod(EnableSession = true)]
    public string SaveFrameMaster(string FrameName)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            int Count = Util.GetInt(StockReports.ExecuteScalar("Select Count(*) from f_framemaster where FrameName='" + FrameName + "'"));
            if (Count == 0)
            {
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "Insert into f_framemaster(FrameName,createdBy) values('" + FrameName + "','" + HttpContext.Current.Session["ID"].ToString() + "')");
                tranX.Commit();
                return "1";
            }

            else
            {
                return "2";
            }
            
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
    public string BindFrameMaster()
    {
        string rtrn = "";
        
        DataTable Frame = StockReports.GetDataTable("Select FrameID,FrameName From f_framemaster where IsActive=1 Order by FrameID");
        if (Frame.Rows.Count > 0)
        {
            rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(Frame);
            return rtrn;
        }
        else
        {
            return rtrn;
        }


    }
    [WebMethod(EnableSession = true)]
    public string BindMenuHeader()
    {
        string rtrn = "";

        DataTable Frame = StockReports.GetDataTable("Select HeaderName From f_frame_Menu_Header Order by id");
        if (Frame.Rows.Count > 0)
        {
            rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(Frame);
            return rtrn;
        }
        else
        {
            return rtrn;
        }


    }
    
    
    [WebMethod(EnableSession = true)]
    public string SequenceUpdate(List<Sequence> Data)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            for (int i = 0; i < Data.Count; i++)
            {
                int seq = (Data[i].SequenceNo) + 1;
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "Update f_frame_role Set SequenceNo=" + seq + " where RoleID=" + Data[i].RoleID + " and URLId=" + Data[i].URLId + "  ");
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
    [WebMethod(EnableSession = true)]
    public string SaveFrameMasterMenuHeader(string HName)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            int Count = Util.GetInt(StockReports.ExecuteScalar("Select Count(*) from f_frame_Menu_Header where HeaderName='" + HName + "'"));
            if (Count == 0)
            {
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "Insert into f_frame_Menu_Header(HeaderName,EntryBy) values('" + HName + "','" + HttpContext.Current.Session["ID"].ToString() + "')");
                tranX.Commit();
                return "1";
            }

            else
            {
                return "2";
            }

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