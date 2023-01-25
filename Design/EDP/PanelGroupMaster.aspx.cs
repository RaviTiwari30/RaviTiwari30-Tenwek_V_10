using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_EDP_PanelGroupMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }


    [WebMethod(EnableSession = true)]
    public static string BindPanelGroup()
    {

        DataTable dt = StockReports.GetDataTable(" SELECT PanelGroupID,PanelGroup FROM f_panelgroup ORDER BY PanelGroup ");
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
        }

        else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "No Record Found" }); } 
    }

    [WebMethod(EnableSession = true)]
    public static string SavePanelGroup(string GroupName, string GroupID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            string message = "";
            string str = "Select Count(*) From f_panelgroup where lower(PanelGroup)=@GroupName ";
            if (GroupID != "")
                str += " and PanelGroupID<>@PanelGroupID";
            var isExists = Util.GetInt(excuteCMD.ExecuteScalar(str, new
            {
                GroupName = GroupName.ToLower(),
                PanelGroupID = GroupID,
            }));
            if (isExists > 0)
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Panel Group Already Exists" });
            }
            if (GroupID != "")
            {
                var sqlCMD = "Update f_panelgroup set PanelGroup=@PanelGroup , EditUserID=@UpdatedBy,EditDate=NOW() where PanelGroupID = @PanelGroupID";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    PanelGroup = GroupName,
                    UpdatedBy = HttpContext.Current.Session["ID"].ToString(),
                    PanelGroupID = GroupID,
                });
                message = "Record Updated Successfully";
            }
            else
            {
                var sqlCMD = "Insert into f_panelgroup(PanelGroup,UserID,EntryDate) values(@PanelGroup,@UserID,NOW())";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    PanelGroup = GroupName,
                    UserID = HttpContext.Current.Session["ID"].ToString(),
                });
                message = "Record Save Successfully";
            }

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}