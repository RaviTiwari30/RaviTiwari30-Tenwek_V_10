using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.Script.Services;
using System.Web.Script.Serialization;
using MySql.Data.MySqlClient;

public partial class Design_IPD_SetWardScreen : System.Web.UI.Page
{
    public class wardDetail
    {
        public string WardID { get; set; }
        public string WardName { get; set; }
        public string ScreenNo { get; set; }
        public string buttonType { get; set; }

    }
    public class DataDetail
    {
        public string DataItemID { get; set; }
        public string DataItemName { get; set; }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindDataitem();
            BindWard();
        }
    }

    private void BindWard()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT IPdCaseType_Id,NAME FROM ipd_case_type_master ORDER BY NAME ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {

            chkward.DataSource = dt;
            chkward.DataTextField = "NAME";
            chkward.DataValueField = "IPdCaseType_Id";
            chkward.DataBind();
        }
        else
        {
            chkward.DataSource = null;
            chkward.DataBind();
        }
    }
    private void BindDataitem()
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID,DataColumnName  FROM IPD_Ward_Data_Item_master ORDER BY DataColumnName");
        if (dt.Rows.Count > 0)
        {
            chkDataitem.DataSource = dt;
            chkDataitem.DataTextField = "DataColumnName";
            chkDataitem.DataValueField = "ID";
            chkDataitem.DataBind();
        }
        else
        {
            chkDataitem.DataSource = null;
            chkDataitem.DataBind();
        }

    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string saveWardSreen(object Dept, object Detail)
    {
        List<wardDetail> Data = new JavaScriptSerializer().ConvertToType<List<wardDetail>>(Dept);
        List<DataDetail> Ward = new JavaScriptSerializer().ConvertToType<List<DataDetail>>(Detail);
        int count = 0;
        if (HttpUtility.UrlDecode(Data[0].buttonType.ToString()) == "Save")
        {
            count = Util.GetInt(StockReports.ExecuteScalar("Select count(*) from IPD_WardScreen where ScreenNo='" + HttpUtility.UrlDecode(Data[0].ScreenNo.ToString()) + "'"));
        }
        if (count == 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction();
            try
            {
                string WardId = "";
                string WardName = "";
                string DataId = "";
                string Dataname = "";
                for (int i = 0; i < Data.Count; i++)
                {
                    // MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO cpoe_tokenScreen(DocDepartmentID,DocDepartmentName,ScreenNo,CreatedBy)values('" + Data[i].DocDepartmentID + "','" + Data[i].DocDepartmentName + "','" + Data[i].ScreenNo + "','" + HttpContext.Current.Session["ID"].ToString() + "') ");
                    if (WardId != "")
                    {
                        WardId += "," + HttpUtility.UrlDecode(Data[i].WardID) + "";
                        WardName += "," + HttpUtility.UrlDecode(Data[i].WardName) + "";
                    }
                    else
                    {
                        WardId = "" + HttpUtility.UrlDecode(Data[i].WardID) + "";
                        WardName = "" + HttpUtility.UrlDecode(Data[i].WardName) + "";
                    }
                }
                for (int j = 0; j < Ward.Count; j++)
                {
                    if (DataId != "")
                    {
                        DataId += "," + HttpUtility.UrlDecode(Ward[j].DataItemID) + "";
                        Dataname += "," + HttpUtility.UrlDecode(Ward[j].DataItemName) + "";
                    }
                    else
                    {
                        DataId = "" + HttpUtility.UrlDecode(Ward[j].DataItemID) + "";
                        Dataname = "" + HttpUtility.UrlDecode(Ward[j].DataItemName) + "";
                    }
                }
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "DELETE from IPD_WardScreen where ScreenNo='" + HttpUtility.UrlDecode(Data[0].ScreenNo) + "'");
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO IPD_WardScreen(WardID,WardName,DataItemID,DataItemName,ScreenNo,CreatedBy)values('" + WardId + "','" + WardName + "','" + DataId + "','" + Dataname + "','" + HttpUtility.UrlDecode(Data[0].ScreenNo) + "','" + HttpContext.Current.Session["ID"].ToString() + "') ");
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
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindWardSreen()
    {
        DataTable dt = StockReports.GetDataTable("Select * from  IPD_WardScreen where IsActive=1 ORDER BY ScreenNo");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
}