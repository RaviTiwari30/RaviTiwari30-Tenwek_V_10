using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

public partial class Design_Lab_InvestigationSequence : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindlabOutSource();
        }

    }
    private void BindlabOutSource()
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID,Name FROM OutSourceLabMaster WHERE Active='1'");
        if (dt.Rows.Count > 0)
        {
            ddlLabOutSource.DataSource = dt;
            ddlLabOutSource.DataTextField = "Name";
            ddlLabOutSource.DataValueField = "ID";
            ddlLabOutSource.DataBind();
            ddlLabOutSource.Items.Insert(0, new ListItem(" "));
            ddlOutSourceHeader.DataSource = dt;
            ddlOutSourceHeader.DataTextField = "Name";
            ddlOutSourceHeader.DataValueField = "ID";
            ddlOutSourceHeader.DataBind();
            ddlOutSourceHeader.Items.Insert(0, new ListItem(" "));
        }
    }
    [WebMethod(EnableSession=true)]
    public static string BindInvestigation(string ObservationType_ID)
    {
        var sb = new StringBuilder();
        sb.Append(" select inv.Name ,inv.Investigation_id,inv.Print_Sequence,inv.PrintSeperate,inv.IsOutSource,inv.OutSourceLabID,inv.ReportType from f_itemmaster im   ");
        sb.Append(" inner join f_subcategorymaster sc on sc.SubCategoryID=im.SubCategoryID  ");
        sb.Append(" inner join f_configrelation c on c.CategoryID=sc.CategoryID ");
        sb.Append(" inner join investigation_master inv on inv.Investigation_id=im.Type_id   ");
        sb.Append(" INNER JOIN investigation_observationtype io ON inv.Investigation_Id = io.Investigation_ID ");
        sb.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = io.ObservationType_ID ");
        sb.Append(" and c.configID='3' and im.IsActive=1 AND cr.RoleID='" + HttpContext.Current.Session["RoleID"].ToString() + "' and io.ObservationType_Id='" + ObservationType_ID + "' order by inv.Print_Sequence ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession=true)]
    public static string BindDepartment()
    {
        DataTable dt = AllLoadData_OPD.BindLabRadioDepartment(HttpContext.Current.Session["RoleID"].ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public static string SaveInvestigation(List<InvesMaster> Data)
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
                    string str = "UPDATE investigation_master SET PrintSeperate='" + Data[i].PrintSeparate.ToString() + "', "+
                                 "Print_Sequence='" + (Util.GetInt(i) + 1) + "',IsOutSource='"+ Data[i].OutSource.ToString() +"',ReportType='"+ Data[i].ReportType.ToString() +"' "+
                                 " WHERE investigation_ID='" + Data[i].InvestigationID.ToString() + "' ";
                        MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str);
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
    public class InvesMaster
    {
        public string InvestigationID { get; set; }
        public string SequenceNo { get; set; }
        public string PrintSeparate { get; set; }
        public string OutSource { get; set; }
        public string ReportType { get; set; }
        public string OutSourceLabID { get; set; }
    }
}