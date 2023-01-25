
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
public partial class Design_OPD_Room_Doctor_Assign : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            try
            {

                All_LoadData.bindDocTypeList(ddlDept, 5, "--Select--");

                //BindDetails("0");

            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
            }
        }
    }
    public void BindDetails(string deptid)
    {
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT *,rd.Id RId FROM Department_Room dr left join Room_Doctor rd  on dr.ID=rd.Room_Id and rd.CenterID='" + Session["CentreID"].ToString() + "' where dr.CenterID='" + Session["CentreID"].ToString() + "'");
            if (deptid != "0")
            {

                sb.Append(" and  dr.DepartmentId='" + deptid + "' and dr.IsActive='1'");
            }
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                rpRoomDoctor.DataSource = dt;
                rpRoomDoctor.DataBind();
            
            }
            else
            {
                rpRoomDoctor.DataSource = null;
                rpRoomDoctor.DataBind();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
    protected void ddlDept_SelectedIndexChanged(object sender, EventArgs e)
    {
        //if (ddlDept.SelectedIndex != 0)
        {
            BindDetails(ddlDept.SelectedValue);
        }
    }

    protected void ddlDoctor_SelectedIndexChanged(object sender, EventArgs e)
    {
        
    }
    [WebMethod(EnableSession = true, Description = "Save Room Doctor")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string saveRoomDoctor(object RoomDoctor)
    {
        List<RoomDoctor> roomdoctor = new JavaScriptSerializer().ConvertToType<List<RoomDoctor>>(RoomDoctor);
        if (roomdoctor.Count > 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                string rs = "";
                for (int i = 0; i < roomdoctor.Count; i++)
                {
                    if (roomdoctor[i].DoctorId == "--Select Doctor--")
                    {
                        StockReports.ExecuteScalar("delete FROM Room_Doctor WHERE Id=" + roomdoctor[i].Id + " and CenterID='" + HttpContext.Current.Session["CentreID"].ToString() + "' ");
                        continue;
                    }

                    string countrepeat = StockReports.ExecuteScalar("SELECT count(*) FROM Room_Doctor WHERE Doctor_Id=" + roomdoctor[i].DoctorId + " and Room_Id='" + roomdoctor[i].RoomId + "' and CenterID='" + HttpContext.Current.Session["CentreID"].ToString() + "' ");
                    if (countrepeat != "0")
                    {
                        continue;
                    }

                    string countrepeat1 = StockReports.ExecuteScalar("SELECT count(*) FROM Room_Doctor WHERE Doctor_Id=" + roomdoctor[i].DoctorId + "  and CenterID='" + HttpContext.Current.Session["CentreID"].ToString() + "' ");
                    
                    if (countrepeat1 == "0")
                    {
                        //string count = StockReports.ExecuteScalar("SELECT count(*) FROM Room_Doctor WHERE Id=" + roomdoctor[i].Id + " ");
                        if (roomdoctor[i].Id.Trim()=="")
                        {
                            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO room_doctor ( `Doctor_Id`, `Room_Id`,CenterID) VALUES  ( '" + roomdoctor[i].DoctorId + "', '" + roomdoctor[i].RoomId + "','" + HttpContext.Current.Session["CentreID"].ToString() + "');");
                        }
                        else
                        {
                            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE  room_doctor SET Doctor_Id = '" + roomdoctor[i].DoctorId + "',  Room_Id = '" + roomdoctor[i].RoomId + "'  WHERE Id='" + roomdoctor[i].Id + "' and CenterID='" + HttpContext.Current.Session["CentreID"].ToString() + "' ");
                        }
                    }
                    else
                    {

                        tranX.Rollback();
                        return "2";
 
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
            return "";
        }
    }


    [WebMethod(EnableSession = true, Description = "Save Room Doctor")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string CheckPatients(string RoomDoctorID)
    {
            try
            {


                string countrepeat = StockReports.ExecuteScalar("SELECT COUNT(*) FROM `appointment` WHERE DoctorId=(SELECT Doctor_Id FROM Room_Doctor WHERE Id='"+RoomDoctorID+"') AND DATE ='" + Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd") + "' AND P_Out='0' ");
                   
                    
                
                return countrepeat;
            }
            catch (Exception ex)
            {
                
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return "0";
            }
            
        
    }

    public class RoomDoctor
    {
        public string Id { get; set; }
        public string RoomId { get; set; }
        public string DoctorId { get; set; }
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

        
        try
        {

            StringBuilder sb = new StringBuilder();
            //sb.Append("INSERT INTO `department_room` ( `DepartmentId`, `RoomNo`) VALUES  ( '" + ddlDept.SelectedValue + "', '" + txtRoomNo.Text + "');");

            int result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            BindDetails("0");

            lblMsg.Text = "Saved Successfully";
            tnx.Commit();

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
    private void GetDoctorList(DropDownList ddlObject, string deptid)
    {


        StringBuilder sb = new StringBuilder();

        sb.Append("SELECT dm.DoctorID,UPPER(CONCAT(dm.Title,' ',dm.Name))NAME FROM doctor_master dm INNER JOIN f_center_doctor cd ON dm.DoctorID=cd.DoctorID  WHERE `DocDepartmentID`='" + deptid + "' AND cd.isActive=1 AND cd.CentreID='" + Session["CentreID"].ToString() + "';");

        DataTable dtData = StockReports.GetDataTable(sb.ToString());
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Name";
            ddlObject.DataValueField = "DoctorID";
            ddlObject.DataBind();

        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }

    }
    
    protected void rpRoomDoctor_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            DropDownList ddlDoc = (DropDownList)e.Item.FindControl("ddlDoctor");
            GetDoctorList(ddlDoc, ddlDept.SelectedValue);
            ddlDoc.Items.Insert(0, new ListItem("--Select Doctor--"));
            HtmlGenericControl roomid = (HtmlGenericControl)e.Item.FindControl("spanRoomId");
            string ri=roomid.InnerHtml;
        
            string doctorid = StockReports.ExecuteScalar("SELECT Doctor_Id FROM Room_Doctor WHERE Room_Id=" + ri + " ");
            ddlDoc.SelectedValue = doctorid;

            //ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "key1", "alert();", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1" + ddlDoc.ClientID ," $('#" + ddlDoc.ClientID + "').chosen();", true);
            
        }



    }
    
  
}