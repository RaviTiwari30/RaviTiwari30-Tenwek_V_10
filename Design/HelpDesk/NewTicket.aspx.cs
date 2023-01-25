using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.IO;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_HelpDesk_NewTicket : System.Web.UI.Page
{
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        bool isTrue = FieldRequirement();
        if (!isTrue)
        {
            return;
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string query = " INSERT INTO ticket_master(EmployeeID,Description,PeopleEffeced,Priority,PriorityID,ProblemStartTime,ErrorType,ErrorTypeID,ErrorDeptID,LastUpdate,RoleID,Department,Floor,PayrollEmployeeID,AssetName,StockID,Location,LocationCode) " +
                           " VALUES ('" + ViewState["UserID"].ToString() + "','" + txtDescription.Text.Replace("'", "''") + "','" + txtNoOfPeopleEffected.Text + "','" + ddlPriority.SelectedItem.Text + "', " +
                           " '" + ddlPriority.SelectedValue + "','" + Util.GetDateTime(txtStartDate.Text).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(txtStartTime.Text).ToString("HH:mm:ss") + "', " +
                           " '" + ddlErrorType.SelectedItem.Text + "','" + ddlErrorType.SelectedValue + "','" + ddlDepartment.SelectedValue + "','" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "', " +
                           " '" + ViewState["RoleID"].ToString() + "','" + ddlDept.SelectedItem.Text + "','','" + txtEmpCode.Text.Trim() + "','','0','"+txtLocation.Text+"','"+txtLocationCode.Text+"') ";

            MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, query);

            string ticketNo = Util.GetString(MySqlHelper.ExecuteScalar(tranx, CommandType.Text, " SELECT MAX(TicketID) FROM ticket_master "));
            string attachment = string.Empty;

            if (fuattachment.HasFile)
            {
                string fileName = fuattachment.PostedFile.FileName;
                string ext = fileName.Substring(fileName.LastIndexOf("."));
                attachment = string.Concat(ticketNo + ext);

                if (All_LoadData.chkDocumentDrive() == 0)
                {
                    tranx.Rollback();
                    lblErrormsg.Text = "Please Create " + Resources.Resource.DocumentDriveName + " Drive";
                    return;
                }

                var directoryPath = All_LoadData.createDocumentFolder("HelpDesk", "SupportAttachment");

                if (directoryPath == null)
                {
                    tranx.Rollback();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblErrormsg.ClientID + "');", true);
                    return;
                }

                string filePath = Path.Combine(directoryPath.ToString(), attachment);

                if (File.Exists(filePath))
                {
                    File.Delete(filePath);
                }

                fuattachment.PostedFile.SaveAs(filePath);
                MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, " UPDATE ticket_master SET Attachment='" + attachment + "',Attachment_Name='" + (txtAttachmentName.Text !=""?txtAttachmentName.Text+ext:"") + "' WHERE TicketID=" + ticketNo + " ");
            }



            Notification_Insert.notificationInsert(32, ticketNo, tranx, "", "", Util.GetInt(ddlDepartment.SelectedItem.Value), DateTime.Now.ToString("yyyy-MM-dd"), Util.GetString(lblEmpID.Text));
            if (Resources.Resource.SMSApplicable == "1" && lblEmpMobile.Text != "")
            {
                var columninfo = smstemplate.getColumnInfo(1, con);
                if (columninfo.Count > 0)
                {
                    //columninfo[0].FromDepartment = ddlDept.SelectedItem.Text.Replace("&","");
                    //columninfo[0].ErrorType = ddlErrorType.SelectedItem.Text.Trim();
                    //columninfo[0].Priority = ddlPriority.SelectedItem.Text.Trim();
                    //columninfo[0].ContactNo = lblEmpMobile.Text.Trim();
                    //columninfo[0].TemplateID = 7;
                    //columninfo[0].PatientID = "";
                    //string sms = smstemplate.getSMSTemplate(7, columninfo, 3, con);
                }
            }
            tranx.Commit();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Ticket No. : " + ticketNo + "');", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "script", "SaveAdditionalname('" + ticketNo + "');", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "location.href='NewTicket.aspx';", true);
        }
        catch (Exception ex)
        {
            tranx.Commit();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblErrormsg.ClientID + "');", true);
        }
        finally
        {
            tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)] // developed by Ankit
    public static string SaveAdditionalInfo(int TicketID, int AdditionalID, string AdditionalName, string Content)
    {
        string Result = "";
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        int max = 0;
        max = GetmaxID();
        max++;

        using (MySqlTransaction tr = con.BeginTransaction())
        {
            try
            {
                string query = "INSERT INTO ass_aditionalinfo_ticketmaster(ID, TicketID, AdditionalInfoID, AdditionalInfoName,Content,IsCancel,IsResolved,CreatedBy,CreateDatetime) VALUES('" + max + "','" + TicketID + "','" + AdditionalID + "','" + AdditionalName + "','" + Content + "','" + 0 + "','" + 0 + "','" + HttpContext.Current.Session["ID"].ToString() + "',CURDATE())";
                using (MySqlCommand cmd = new MySqlCommand(query, con, tr))
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.ExecuteNonQuery();
                    tr.Commit();
                    con.Close();

                    Result = "1";
                }
            }
            catch { tr.Rollback();
            Result = "0";
            }
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(Result);
    }

    private static int GetmaxID()
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        int ID = 0;

        string query = "SELECT IFNULL(MAX(ID),0)AS ID FROM ass_aditionalinfo_ticketmaster";
        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            ID = Convert.ToInt32(cmd.ExecuteScalar());
            con.Close();
        }
        return ID;
    }

    protected void ddldepartment_SelectedIndexChanged1(object sender, EventArgs e)
    {
        int id = Convert.ToInt32(ddlDepartment.SelectedValue);
        string ledger = GetDepartLedgerNoById(id);

        errortype();
        BindEmployeeErrorWise();
      //  BindSubCategory(ddlDept.SelectedValue);
    }

    public string GetDepartLedgerNoById(int id)  // developed by Ankit
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        string ledger = "";

        string query = "SELECT DeptLedgerNo FROM f_rolemaster WHERE ID="+id+"";
        //using (MySqlCommand cmd = new MySqlCommand(query, con))
        //{
        //    cmd.CommandType = CommandType.Text;
        //    cmd.Parameters.Add("@ID", id);
        //    ledger = cmd.ExecuteScalar().ToString();
        //    con.Close();
        //}
        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            ledger = cmd.ExecuteScalar().ToString();
            con.Close();
        }
        return ledger;
    }

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
                ddlFloor.Focus();
                ViewState["UserID"] = Session["ID"].ToString();
                ViewState["RoleID"] = Session["RoleID"].ToString();
                BindLoginType();
                Bindfloor();
                All_LoadData.bindPriority(ddlPriority);
                txtStartDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                txtStartTime.Text = DateTime.Now.ToString("HH:mm tt");
                bindDeptTo();
                ddlDepartment.Items.Insert(0, new ListItem("Select", "0"));
                errortype();
                BindSubCategory(ddlDept.SelectedValue);
            }
            ToDatecal.EndDate = DateTime.Now;
        }

        txtStartDate.Attributes.Add("readOnly", "true");
    }

    private void bindDeptTo()
    {
        // Modify on 16-12-2016
        // DataTable dt = StockReports.GetDataTable("select ID,RoleName from f_rolemaster Where Active=1 AND rm.ID!='" + ViewState["RoleID"] + "' AND et.IsActive=1 order by RoleName ");
        DataTable dt = StockReports.GetDataTable(" SELECT rm.ID,DeptLedgerNo, rm.RoleName FROM f_rolemaster rm INNER JOIN ticket_error_type et ON et.RoleID=rm.ID WHERE rm.Active=1 AND rm.ID!='" + ViewState["RoleID"] + "' GROUP BY rm.ID ORDER BY rm.RoleName ");
        if (dt.Rows.Count > 0)
        {
            ddlDepartment.DataSource = dt;
            ddlDepartment.DataTextField = "RoleName";
            ddlDepartment.DataValueField = "ID";
            ddlDepartment.DataBind();
        }
    }

    public void BindSubCategory(string categoryid)
    {
        DataTable dt = StockReports.GetDataTable("SELECT asm.ID AS ItemId,CONCAT(asm.ItemName,'(Serial No.:',asm.SerialNo,')')TypeName  FROM eq_Asset_stock ast INNER JOIN eq_asset_master asm ON ast.AssetID= asm.id WHERE ast.DeptLedgerNo='" + categoryid + "' AND isPost=1 ORDER BY asm.ItemName");  //BarCodeID
        if (dt.Rows.Count > 0) 
        {
            ddlAssetName.DataSource = dt;
            ddlAssetName.DataTextField = "TypeName";
            ddlAssetName.DataValueField = "ItemId";
            ddlAssetName.DataBind();
            ddlAssetName.Items.Insert(0, new ListItem("Select", "0"));
        }
    }

    private void Bindfloor()
    {
        DataTable dt1 = All_LoadData.LoadFloor();
        if (dt1.Rows.Count > 0)
        {
            ddlFloor.DataSource = dt1;
            ddlFloor.DataTextField = "Name";
            ddlFloor.DataValueField = "Name";
            ddlFloor.DataBind();
            ddlFloor.Items.Insert(0, new ListItem("Select", "0"));
        }
    }

    private void BindLoginType()
    {
        DataTable dt = StockReports.GetDataTable("select ID,RoleName,DeptLedgerNo  from f_rolemaster  Where Active=1 AND ID='" + ViewState["RoleID"] + "' order by RoleName ");
        if (dt.Rows.Count > 0)
        {
            ddlDept.DataSource = dt;
            ddlDept.DataTextField = "RoleName";
            ddlDept.DataValueField = "DeptLedgerNo";
            ddlDept.DataBind();
        }
    }

    private void errortype()
    {
        DataTable dt = StockReports.GetDataTable("SELECT RoleID,error_id,error_type FROM  ticket_error_type WHERE  RoleID='" + ddlDepartment.SelectedItem.Value + "' AND IsActive=1 order by error_type ");
        if (dt.Rows.Count > 0)
        {
            ddlErrorType.DataSource = dt;
            ddlErrorType.DataTextField = "Error_type";
            ddlErrorType.DataValueField = "Error_id";
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

    private Boolean FieldRequirement()
    {
        try
        {
            //if (ddlFloor.SelectedItem.Value == "0")
            //{
            //    lblErrormsg.Visible = true;
            //    lblErrormsg.Text = "Please Select Floor";
            //    ddlFloor.Focus();
            //    return false;
            //}
            if (ddlDepartment.SelectedItem.Value == "0")
            {
                lblErrormsg.Visible = true;
                lblErrormsg.Text = "Please Select Department";
                ddlDepartment.Focus();
                return false;
            }
            if (ddlErrorType.SelectedItem.Value == "0")
            {
                lblErrormsg.Visible = true;
                lblErrormsg.Text = "Please Select Error Type";
                ddlErrorType.Focus();
                return false;
            }
            if (ddlPriority.SelectedItem.Value == "0")
            {
                lblErrormsg.Visible = true;
                lblErrormsg.Text = "Please Select Priority";
                ddlPriority.Focus();
                return false;
            }
            if (fuattachment.HasFile)
            {
                string extendion = System.IO.Path.GetExtension(fuattachment.PostedFile.FileName);
                if (extendion != ".jpg" && extendion != ".jpeg" && extendion != ".gif" && extendion != ".png" && extendion != ".jpg" && extendion != ".pdf" && extendion != ".docx" && extendion != ".doc")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM051','" + lblErrormsg.ClientID + "');", true);
                    return false;
                }
            }

            return true;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return false;
        }
    }
    protected void ddlErrorType_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindEmployeeErrorWise();
    }
    private void BindEmployeeErrorWise()
    {
        string EmployeeDetail = StockReports.ExecuteScalar("SELECT Concat(et.EmployeeID,'#',em.Name,'#',em.Mobile)EmployeeName FROM ticket_error_type et INNER JOIN f_rolemaster rm ON et.RoleID=rm.ID LEFT JOIN employee_master em ON em.EmployeeID=et.EmployeeID WHERE rm.Active=1 And rm.ID='" + ddlDepartment.SelectedValue + "' And et.Error_ID='"+ ddlErrorType.SelectedValue +"' ");
        if (EmployeeDetail.Split('#')[0] != string.Empty)
        {
            lblEmployeeName.Text = EmployeeDetail.Split('#')[1];
            lblEmpID.Text = EmployeeDetail.Split('#')[0];
            lblEmpMobile.Text = EmployeeDetail.Split('#')[2];
        }
        else
        {
            lblEmployeeName.Text = "";
            lblEmpID.Text = "";
            lblEmpMobile.Text = "";
        }
    }

    [WebMethod(EnableSession = true)] // developed by Ankit
    public static string GetEmployeeErrorname(int departID, int typeID) 
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        string name = "";

        string query = "SELECT CONCAT(et.DefaultEmployeeId,'#',em.Name,'#',em.Mobile)EmployeeName FROM ticket_error_type et INNER JOIN f_rolemaster rm ON et.RoleID=rm.ID LEFT JOIN employee_master em ON em.EmployeeID=et.DefaultEmployeeId WHERE rm.Active=1 AND rm.ID='" + departID + "' AND et.Error_ID='" + typeID + "'";
        using (MySqlCommand cmd = new MySqlCommand(query, con)) 
        {
            cmd.CommandType = CommandType.Text;
            name = cmd.ExecuteScalar().ToString();
            con.Close();
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(name);
    }

    [WebMethod(EnableSession = true)] // developed by Ankit
    public static string GetAdditionalIdByErrorType(string type)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        string id = "";

        string query = "SELECT AdditionalInfoID FROM ticket_error_type WHERE Error_type='" + type + "'";
        using (MySqlCommand cmd = new MySqlCommand(query,con))
        {
            cmd.CommandType = CommandType.Text;
            id = cmd.ExecuteScalar().ToString();
            con.Close();
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(id);
    }

    [WebMethod(EnableSession = true)] // developed by Ankit
    public static string GetAdditionalNameByID(int AddID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        string name = "";

        string query = "SELECT NAME FROM ass_additional_info WHERE InfoID='" + AddID + "'";
        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            name = cmd.ExecuteScalar().ToString();
            con.Close();
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(name);
    }

    [WebMethod(EnableSession = true)] // developed by Ankit
    public static string GetAdditionalIDByName(string name)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        string id = "";

        string query = "SELECT InfoID FROM ass_additional_info WHERE Name='" + name + "'";
        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            id = cmd.ExecuteScalar().ToString();
            con.Close();
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(id);
    }
    protected void ddlDept_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindSubCategory(ddlDept.SelectedValue);
    }
}