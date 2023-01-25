using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using MySql.Data.MySqlClient;
using System.Web.Services;
using System.Text;
using System.Collections.Generic;
using System.Web.Script.Serialization;

public partial class Design_Lab_OutsourceLabMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
           

        }
    }
   

    

    [WebMethod]
    public static string bindOutSourceLab(string OutSourceLabName, string Type, string ContactPerson, string Address, string ContactNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT ID,Name,Active,Address,ContactPerson,MobileNo FROM outsourceLabMaster where Name<>'' ");
        if (OutSourceLabName != "")
            sb.Append(" AND Name LIKE '" + OutSourceLabName + "%'");
        if (OutSourceLabName != "")
            sb.Append(" AND ContactPerson LIKE '" + ContactPerson + "%'");
        if (Address != "")
            sb.Append(" AND Name LIKE '" + Address + "%'");
        if (ContactNo != "")
            sb.Append(" AND MobileNo LIKE '" + ContactNo + "%'");
        if (Type != "2")
            sb.Append(" AND Active =" + Type + " ");
        DataTable OutSource = StockReports.GetDataTable(sb.ToString());
        if (OutSource.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(OutSource);
        else
            return "";

    }
    [WebMethod(EnableSession = true)]
    public static string SaveOutSourceLab(string Name, string ContactPerson, string ContactNo, string Address)
    {
        int count = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM outsourceLabMaster WHERE Name='" + Name.Trim() + "' "));
        if (count > 0)
            return "2";

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string str = "INSERT INTO outsourceLabMaster(Name,Address,ContactPerson,MobileNo,CreatedBy,IPAddress,Active) VALUES('" + Name + "','" + Address + "','" + ContactPerson + "'," + ContactNo + ",'" + HttpContext.Current.Session["ID"].ToString() + "','" + All_LoadData.IpAddress() + "',1)";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
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
    [WebMethod(EnableSession = true)]
    public static string UpdateOutSourceLab(object Data)
    {
        List<OutSourceLab> dataItem = new JavaScriptSerializer().ConvertToType<List<OutSourceLab>>(Data);
        int len = dataItem.Count;
        if (len > 0)
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                for (int i = 0; i < len; i++)
                {

                    int count = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, " SELECT COUNT(*) FROM outsourceLabMaster WHERE Name='" + dataItem[i].Name + "' AND ID != '" + Util.GetInt(dataItem[i].OutsourceLabID) + "' "));
                    if (count > 0)
                        return "2";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE outsourceLabMaster set Name='" + dataItem[i].Name + "',Address='" + dataItem[i].Address + "',ContactPerson='" + dataItem[i].ContactPerson + "',MobileNo='" + dataItem[i].MobileNo + "',Active='" + Util.GetInt(dataItem[i].Active) + "' Where ID = '" + Util.GetInt(dataItem[i].OutsourceLabID) + "' ");

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
        {
            return "";
        }

    }
}
