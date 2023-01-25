
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using MySql.Data.MySqlClient;
using System.Web.UI.WebControls;
public partial class Design_OPD_Room_Doctor : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            try
            {
        
                //All_LoadData.bindDocTypeList(ddlDept, 5, "All");
                BindDetails("0", Session["CentreID"].ToString());
                BindCentre();
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
            }
        }
    }

    private void BindCentre()
    {
        DataTable dt = All_LoadData.dtbind_Center();
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlCentre.DataSource = dt;
            ddlCentre.DataValueField = "CentreID";
            ddlCentre.DataTextField = "CentreName";
            ddlCentre.DataBind();
        }
    }

    [WebMethod(EnableSession = true, Description = "details ")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindDetails(string deptid,string CenterID)
    
    {
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT *,(SELECT Name from type_master where ID =DepartmentId) as DepartmentName,CASE WHEN IsActive ='1' THEN 'Yes'    WHEN IsActive='0' THEN 'No'    ELSE 'U' END AS IsActive1  FROM Department_Room WHERE CenterID='" + CenterID + "'  ");
            if (deptid != "0")
            {

                sb.Append(" and DepartmentId='" + deptid + "'");
            }
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            string str = Newtonsoft.Json.JsonConvert.SerializeObject(dt.DefaultView.ToTable());
            return str;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
    }
    protected void ddlDept_SelectedIndexChanged(object sender, EventArgs e)
    {
        //if (ddlDept.SelectedIndex != 0)
        {
            BindDetails(ddlDept.SelectedValue,ddlCentre.SelectedItem.Value);
        }
    }

    public class DepartmentRoom
    {
        public string Id { get; set; }
        public string RoomNo { get; set; }
        public string DepartmentId { get; set; }
    }
    [WebMethod(EnableSession = true, Description = "Save department Room ")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string updateDepartmentRoom(string Id,string RoomNo, string DepartmentId,string IsActive,string CenterID)
    {

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            string count = StockReports.ExecuteScalar("SELECT count(*) FROM department_room  WHERE RoomNo='" + RoomNo + "' and DepartmentId='" + DepartmentId + "' and IsActive='" + IsActive + "' and CenterID='"+CenterID+"'  ");
            if (count == "0")
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("UPDATE  `department_room` set  `DepartmentId`='" + DepartmentId + "', `RoomNo`='" + RoomNo + "' ,IsActive='"+IsActive+"' WHERE Id='" + Id + "' ");

                int result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());


                tnx.Commit();
                return "1";

            }
            else
            {
                return "2";
            }

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {

            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }

    [WebMethod(EnableSession = true, Description = "Save department Room ")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string saveDepartmentRoom(string RoomNo, string DepartmentId, string IsActive, string CenterID)
    {
        
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {

                string count = StockReports.ExecuteScalar("SELECT count(*) FROM department_room WHERE RoomNo='" + RoomNo + "' and DepartmentId='" + DepartmentId+ "' and CenterID='"+CenterID+"' ");
                if (count == "0")
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append("INSERT INTO `department_room` ( `DepartmentId`, `RoomNo`,`IsActive`,CenterID) VALUES  ( '" + DepartmentId + "', '" + RoomNo + "','" + IsActive + "','"+CenterID+"');");

                    int result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                    
                    tnx.Commit();
                    return "1";

                }
                else
                {
                    return "2";
                }

            }
            catch (Exception ex)
            {
                tnx.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return "0";
            }
            finally
            {

                tnx.Dispose();
                con.Close();
                con.Dispose();
            }

    }

   
    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection(Util.GetConString());
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        if (ddlDept.SelectedIndex == 0)
        {
            lblMsg.Text = "Select Dept";
            return;
        }

        if (txtRoomNo.Text=="")
        {
            lblMsg.Text = "Fill Room No";
            return;
        }

        try
        {

            string count = StockReports.ExecuteScalar("SELECT count(*) FROM department_room WHERE RoomNo='" + txtRoomNo.Text + "' and DepartmentId='" + ddlDept.SelectedValue + "' and CenterID='"+ddlCentre.SelectedItem.Value+"'");
            if (count == "0")
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("INSERT INTO `department_room` ( `DepartmentId`, `RoomNo`,CenterID) VALUES  ( '" + ddlDept.SelectedValue + "', '" + txtRoomNo.Text + "','"+ddlCentre.SelectedItem.Value+"');");

                int result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                
                lblMsg.Text = "Saved Successfully";
                tnx.Commit();
                BindDetails(ddlDept.SelectedValue,ddlCentre.SelectedItem.Value);

            }
            else
            {
                lblMsg.Text = "Room Already in department";
            }
            
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
  
}