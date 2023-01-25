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

public partial class Design_OPD_doctorPatientAssign : System.Web.UI.Page
{
    
    protected void Page_Load(object sender, EventArgs e)
    {
        
        if (!IsPostBack)
        {
            try
            {
                Session["dept"] = null;
                ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                fc1.EndDate = DateTime.Now;
                ucFromDate.Attributes.Add("readonly", "readonly");
                All_LoadData.bindDocTypeList(ddlDept, 5, "Select");

                divSelf.Visible = false;
                //BindSelf("0");
                //BindDetails("0");
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
            }
        }
        if (Session["dept"] != null)
        {

            BindDetails(Session["dept"].ToString());
            BindSelf(Session["dept"].ToString(), ucFromDate.Text.ToString());
        }
    }
    private void GetDoctorList(DropDownList ddlObject, string deptid)
    {


        StringBuilder sb = new StringBuilder();

        sb.Append("SELECT dm.DoctorID,UPPER(CONCAT(dm.Title,' ',dm.Name))NAME FROM doctor_master dm WHERE `DocDepartmentID`='" + deptid + "' and dm.DoctorID in(select distinct Doctor_Id from room_doctor  WHERE centerID='" + Session["CentreID"].ToString() + "')");

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
    private void GetDoctorListSelf(DropDownList ddlObject, string deptid)
    {


        StringBuilder sb = new StringBuilder();

        sb.Append("SELECT dm.DoctorID,UPPER(CONCAT(dm.Title,' ',dm.Name))NAME FROM doctor_master dm WHERE `DocDepartmentID`='" + deptid + "' and dm.DoctorID in(select distinct Doctor_Id from room_doctor WHERE centerID='" + Session["CentreID"].ToString() + "')");

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
    protected void rpPatient_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            DropDownList ddlDoc = (DropDownList)e.Item.FindControl("ddlDoctor");
            GetDoctorList(ddlDoc, ddlDept.SelectedValue);
            ddlDoc.Items.Insert(0, new ListItem("--Select Doctor--"));

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1" + ddlDoc.ClientID, " $('#" + ddlDoc.ClientID + "').chosen();", true);
            
        }

    }
    protected void rpSelf_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {

            DropDownList ddlDoc = (DropDownList)e.Item.FindControl("ddlDoctorList");
            GetDoctorList(ddlDoc, ddlDept.SelectedValue);
            ddlDoc.Items.Insert(0, new ListItem("--Select Doctor--"));
            ddlDoc.Width = 200;

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1" + ddlDoc.ClientID, " $('#" + ddlDoc.ClientID + "').chosen();", true);

        }

    }
    [WebMethod(EnableSession = true, Description = "assign doctor patient")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string assignDoctorPatient(string DoctorId, string PatientId, string Date, string Appid)
    {
        if (DoctorId == "")
        {
            return "0";
        }
        if (PatientId == "")
        {
            return "0";
        }
        
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                string count = StockReports.ExecuteScalar("SELECT count(*) FROM appointment app WHERE App_ID='"+Appid+"' ");
                
                    if (count == "0")
                    {
                       // MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO appointment ( `PatientId`, `DoctorId`) VALUES  ( '" + PatientId + "', '" + DoctorId + "');");
                        return "0";
                    }
                    else
                    {
                        string appid = StockReports.ExecuteScalar("SELECT App_ID FROM appointment app WHERE app.PatientId='" + PatientId + "' and  app.date='" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "' ");
                        string ledgertnxno = StockReports.ExecuteScalar("SELECT LedgerTnxNo FROM appointment app WHERE App_ID='" + Appid + "'  ");//app.PatientId='" + PatientId + "' and  app.date='" + Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd") + "'

                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE  appointment SET DoctorId = '" + DoctorId + "',DoctorAssignBy='" + HttpContext.Current.Session["ID"].ToString() + "',DoctorAssignDate=NOW()  WHERE App_ID='" + Appid + "'  ");
                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE patient_medical_history pmh INNER JOIN f_ledgertnxdetail ltd ON pmh.TransactionID=ltd.TransactionID " +
                                "SET ltd.DoctorID='" + DoctorId + "', pmh.doctorID='" + DoctorId + "' WHERE ltd.LedgerTransactionNO='" + ledgertnxno + "'");

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

    public void BindSelf(string deptid,string Date)
    {
        try
        {



            string defaultdoctorname = StockReports.ExecuteScalar(" SELECT dm.Name FROM f_center_doctor cd INNER JOIN doctor_master dm ON cd.DoctorID=dm.DoctorID WHERE cd.CentreID='" + Session["CentreID"].ToString() + "' AND cd.isActive=1 AND dm.DocDepartmentID='" + deptid + "' AND dm.DefaultDepartmentDoctor=1 ");
            lblDoctorName.Text = defaultdoctorname;

            string doctorid = StockReports.ExecuteScalar(" SELECT dm.DoctorID FROM f_center_doctor cd INNER JOIN doctor_master dm ON cd.DoctorID=dm.DoctorID WHERE cd.CentreID='" + Session["CentreID"].ToString() + "' AND cd.isActive=1 AND dm.DocDepartmentID='" + deptid + "' AND dm.DefaultDepartmentDoctor=1 ");
            string roomno = StockReports.ExecuteScalar("  SELECT  *,(SELECT NAME FROM doctor_master WHERE DoctorID=rd.Doctor_Id) AS DoctorName "+
            " FROM Department_Room dr LEFT JOIN Room_Doctor rd ON dr.ID=rd.Room_Id where Doctor_Id='" + doctorid + "'  ORDER BY dr.RoomNo");
           // lblRoomNo.Text = roomno;
            
            
            StringBuilder sb = new StringBuilder();

            // sb.Append(" SELECT patientid,Pname,app.date FROM appointment app WHERE  app.date='" + Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd") + "' and P_Out='0'  AND app.TemperatureRoom=1 and  DoctorId=(SELECT  Doctorid FROM `doctor_master` WHERE DocDepartmentID='" + deptid + "' AND DefaultDepartmentDoctor='1')");
            sb.Append(" SELECT IFNULL(tr.ColorCode,'White')ColorCode,IFNULL(concat('Triaging Status: ', tr.CodeType),'')CodeType,  app.patientid,Pname,app.date,app.App_ID FROM appointment app ");
            sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID = app.TransactionID ");
            sb.Append(" LEFT JOIN emr_triagingcodes tr ON tr.ID=pmh.TriagingCode ");
            sb.Append(" WHERE app.date='" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "' and P_IN='0'  AND app.TemperatureRoom=1 and app.CentreID='" + Session["CentreID"].ToString() + "'");
            sb.Append(" and app.DoctorId='"+doctorid+"'");
            
       
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                rpSelf.DataSource = dt;
                rpSelf.DataBind();

            }
            else
            {
                rpSelf.DataSource = null;
                rpSelf.DataBind();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
    
    public void BindDetails(string deptid)
    {
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT  *,(SELECT NAME FROM doctor_master WHERE DoctorID=rd.Doctor_Id) AS DoctorName  FROM Department_Room dr left join Room_Doctor rd on dr.ID=rd.Room_Id");
            
            if (deptid != "0")
            {

                sb.Append(" where dr.DepartmentId='" + deptid + "'  and dr.IsActive='1' AND dr.CenterID='" + Session["CentreID"].ToString() + "' ");
                sb.Append("  AND rd.Doctor_Id NOT IN (SELECT  Doctorid FROM `doctor_master` WHERE DocDepartmentID='" + deptid + "' AND DefaultDepartmentDoctor=1) ORDER by dr.id ");
           
            }
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {

                divSelf.Visible = true;
                rpRoomDoctor.DataSource = dt;
                rpRoomDoctor.DataBind();

            }
            else
            {
                divSelf.Visible = false;
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
        if (ddlDept.SelectedIndex != 0)
        {

            BindDetails(ddlDept.SelectedValue);
            BindSelf(ddlDept.SelectedValue, ucFromDate.Text.ToString());
            Session["dept"] = ddlDept.SelectedValue;
        }

        else { ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please Select Clinic', function(){});", true);  }
    }
    protected void ddlDoctorList_SelectedIndexChanged(object sender, EventArgs e)
    {
        DropDownList list = (DropDownList)sender;
        string docid = (string)list.SelectedValue;
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
                for (int i = 0; i < roomdoctor.Count; i++)
                {
                    string count = StockReports.ExecuteScalar("SELECT count(*) FROM Room_Doctor WHERE Id=" + roomdoctor[i].Id + " ");

                    if (count == "0")
                    {
                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO room_doctor ( `Doctor_Id`, `Room_Id`) VALUES  ( '" + roomdoctor[i].DoctorId + "', '" + roomdoctor[i].RoomId + "');");
                    }
                    else
                    {
                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE  room_doctor SET Doctor_Id = '" + roomdoctor[i].DoctorId + "',  Room_Id = '" + roomdoctor[i].RoomId + "'  WHERE Id='" + roomdoctor[i].Id + "' ");
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
    protected void rpRoomDoctor_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {

        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            Repeater rpPat = (Repeater)e.Item.FindControl("rpPatient");
            rpPat.DataSource = GetPatients(((Label)e.Item.FindControl("lblDoctorId")).Text);
            rpPat.DataBind();
        }
           }
    private DataTable GetPatients(string doctorid)
    {
        StringBuilder sb = new StringBuilder();
        
        //sb.Append(" SELECT * FROM patient_master pm INNER JOIN doctor_patient_assign dpa ON pm.`PatientID`=dpa.`PatientId` where DoctorId='"+doctorid+"'");
        sb.Append(" SELECT patientid,Pname,app.date,app.App_ID FROM appointment app WHERE app.DoctorId='" + doctorid + "' AND  app.P_OUT = 0 AND app.date='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' and  app.TemperatureRoom=1 ");
       
  
        
        DataTable dt = StockReports.GetDataTable(sb.ToString());
            
        return dt;
    }
    
    
}