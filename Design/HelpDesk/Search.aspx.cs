using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
public partial class Search : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Resources.Resource.Ticketing == "0")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.location ='../Common/UserAuthorization.aspx?msg=For This Page';", true);
                return;
            }
            else
            {
                ToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                FrmDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                All_LoadData.bindRole(ddlDepartment, "ALL");
                errortype();
                if (Session["RoleID"].ToString() != "6" && Session["RoleID"].ToString() != "167")
                {
                    ddlDepartment.Enabled = false;
                    ddlDepartment.SelectedIndex = ddlDepartment.Items.IndexOf(ddlDepartment.Items.FindByValue(Session["RoleID"].ToString()));
                }
                else
                {
                    ddlDepartment.Enabled = true;
                }
            }
            Fromdatecal.EndDate = DateTime.Now;
            ToDatecal.EndDate = DateTime.Now;
        }
        ToDate.Attributes.Add("readOnly", "true");
        FrmDate.Attributes.Add("readOnly", "true");
    }
    private void errortype()
    {
        DataTable dt = StockReports.GetDataTable("SELECT RoleID,error_id,error_type FROM  ticket_error_type WHERE IsActive=1 order by error_type ");
        if (dt.Rows.Count > 0)
        {
            ddlErrorType.DataSource = dt;
            ddlErrorType.DataTextField = "Error_type";
            ddlErrorType.DataValueField = "Error_type";
            ddlErrorType.DataBind();
            ddlErrorType.Items.Insert(0, new ListItem("Select", "0"));
        }
        else
        {
            ddlErrorType.DataSource = dt;
            ddlErrorType.DataBind();
            ddlErrorType.Items.Insert(0, new ListItem("Select", "0"));
        }
    }
    [WebMethod(EnableSession = true)] // 
    public static string UpdateViewStatus(string TicketNo)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            int isviewd = Util.GetInt(excuteCMD.ExecuteScalar("SELECT IsView FROM ticket_master WHERE TicketID=@ticketID", new
            {
                ticketID = TicketNo,
            }));
            if (isviewd == 0)
            {
                string sqmCMD = "UPDATE ticket_master SET IsView=1 WHERE ticketID=@ticketID";
                excuteCMD.DML(tnx, sqmCMD, CommandType.Text, new
                {
                    ticketID = TicketNo,
                });
                string VMDD = "UPDATE ass_breakdown SET lastStatus='Viewed' WHERE TicketID=@ticketID";
                excuteCMD.DML(tnx, VMDD, CommandType.Text, new
                {
                    ticketID = TicketNo,
                });
            }
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Save Successfully" });
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