
using System;
using System.Collections.Generic;
using MySql.Data.MySqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Data;
public partial class Design_IPD_TransfusionReactionWorkUp : System.Web.UI.Page
{
    private void BindEmployee()
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            //sb.Append("SELECT ID,DATE_FORMAT(DATE,'%d-%M-%Y') AS Date1,FirstDegreeTear,SecondDegreeTear,ThirdDegreeTear,FourthDegreeTear,Episiotomy,NewBornResuscitated,PatientID,TransactionID  FROM delivery_master where TransactionID='" + Util.GetString(ViewState["TID"]) + "'");

            sb.Append("SELECT Distinct em.EmployeeID,em.NAME FROM `employee_master`  em  INNER JOIN f_login fl ON fl.EmployeeID=em.EmployeeID where  em.IsActive = 1 AND fl.RoleID='118' AND fl.`CentreID`='" + Session["CentreID"].ToString() + "' ORDER BY NAME ");


            DataTable dt = StockReports.GetDataTable(sb.ToString());
            ddlApprovedBy.DataSource = dt;
            ddlApprovedBy.DataValueField = "EmployeeID";
            ddlApprovedBy.DataTextField = "NAME";
            ddlApprovedBy.DataBind();

            ddlApprovedBy.Items.Insert(0,new ListItem("--Select--","0"));
            ddlApprovedBy1.DataSource = dt;
            
            ddlApprovedBy1.DataValueField = "EmployeeID";
            ddlApprovedBy1.DataTextField = "NAME";
            ddlApprovedBy1.DataBind();

            ddlApprovedBy1.Items.Insert(0, new ListItem("--Select--", "0"));
            
            
        }
        catch (Exception exc)
        {
            ddlApprovedBy.DataSource = null; 
            ddlApprovedBy1.DataSource = null;
        }

    }
    protected void Page_Load(object sender, EventArgs e)
    {
        caldate.EndDate = DateTime.Now;
       
        if (!IsPostBack)
        {
            BindEmployee();
            txtDate.Text = Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy");
            txtDateR.Text = Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy");
            txtDate1.Text = Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy");
            ViewState["PID"] = Request.QueryString["PID"].ToString();
            ViewState["TID"] = Request.QueryString["TID"].ToString();

            BindDetails(ViewState["PID"].ToString(), ViewState["TID"].ToString());
            txtTime.Text = DateTime.Now.ToString("hh:mm tt");
            txtTimeR.Text = DateTime.Now.ToString("hh:mm tt");
            txtTime1.Text = DateTime.Now.ToString("hh:mm tt");
            txtTime2.Text = DateTime.Now.ToString("hh:mm tt");
            txtTime3.Text = DateTime.Now.ToString("hh:mm tt");
            txtTime8.Text = DateTime.Now.ToString("hh:mm tt");
            txtTime9.Text = DateTime.Now.ToString("hh:mm tt");
            btnSave.Enabled = false;
            string entryby = StockReports.ExecuteScalar("SELECT Name 	FROM 	employee_master  WHERE  EmployeeId='" + Session["ID"].ToString() + "' LIMIT 0, 1");
            txtReportedToLabBy.Text = entryby;
            txtStoppedBy.Text = entryby;
            txtNotifiedBy.Text = entryby;
           // ddlApprovedBy.SelectedValue = Session["ID"].ToString();
           // ddlApprovedBy1.SelectedValue = Session["ID"].ToString();
            txtTechnician.Text = entryby;

        }
        txtTechnician.Attributes.Add("readOnly", "true");
        txtReportedToLabBy.Attributes.Add("readOnly", "true");
       txtStoppedBy.Attributes.Add("readOnly", "true");
       txtNotifiedBy.Attributes.Add("readOnly", "true");
        txtDate.Attributes.Add("readOnly", "true");
        txtDateR.Attributes.Add("readOnly", "true");
    }

    protected void grdSickPatientsDetails_RowDataBound(object sender, GridViewRowEventArgs e)
    {

    }
    protected void grdSickPatientsDetails_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Print")
        {
            lblMsg.Text = "";
            int id = Convert.ToInt16(e.CommandArgument.ToString());
            string ID1 = ((Label)grdGrid.Rows[id].FindControl("lblID1")).Text;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", " window.open('./TransfusionReactionWorkUp_PDF.aspx?TestID=O23&LabType=&LabreportType=11&ID=" + ID1 + "&TID=" + ViewState["TID"].ToString() + "');", true);

        }
        if (e.CommandName == "Change")
        {
            int id = Convert.ToInt16(e.CommandArgument.ToString());
            lblPID.Text = ((Label)grdGrid.Rows[id].FindControl("lblID")).Text;

            DataTable dt = (DataTable)ViewState["dt"];
            DataRow[] rows = dt.Select("Id = '" + lblPID.Text + "'");
            if (rows.Length > 0)
            {
                txtDate.Text = rows[0]["Date11"].ToString();
                txtTime.Text = rows[0]["Time11"].ToString();
                txtSymtomsOfReaction.Text = rows[0]["Symptoms"].ToString();
                txtTime1.Text = rows[0]["TransfusionStartTime1"].ToString();
                txtTime2.Text = rows[0]["BloodStopped1"].ToString();
                txtStoppedBy.Text = rows[0]["StoppedBy1"].ToString();
                txtClinicianNotified.Text = rows[0]["ClinicianNotified"].ToString();
                txtNotifiedBy.Text = rows[0]["NotifiedBy1"].ToString();
                txtReportedToLabBy.Text = rows[0]["ReportedToLabBy"].ToString();
                txtDate1.Text = rows[0]["Date111"].ToString();
                txtTime9.Text = rows[0]["Time111"].ToString();
                txtNurseDrawingBlood.Text = rows[0]["Blood"].ToString();
                txtTime8.Text = rows[0]["Time21"].ToString();
                txtReceived.Text = rows[0]["Urine"].ToString();
                txtTime3.Text = rows[0]["Time31"].ToString();
                txtStoppedBy.Text = rows[0]["StoppedBy1"].ToString();
                if (rows[0]["ReportedToLabBy1"] != null)
                {
                    Button3.Text = "Update";
                }
                txtDateR.Text = rows[0]["DateR1"].ToString();
                txtTimeR.Text = rows[0]["TimeR1"].ToString();
                
                txtclericalErrorsChecked.Text = rows[0]["Clerical"].ToString();
               txtSerum.Text= rows[0]["Serum"].ToString();
               txtclericalErrorsChecked.Text = rows[0]["Clerical"].ToString();
               ddlHeamoglobinUria.SelectedValue = rows[0]["UrineH"].ToString();
               ddlBilirubenuria.SelectedValue = rows[0]["Bili"].ToString();
               ddlUrobilinogen.SelectedValue = rows[0]["Uro"].ToString();
               ddlDirect.SelectedValue = rows[0]["Direct"].ToString();
               ddlABO1.SelectedValue = rows[0]["ABO1"].ToString();
               ddlABO2.SelectedValue = rows[0]["ABO2"].ToString();
               ddlABO3.SelectedValue = rows[0]["ABO3"].ToString();
               ddlRH1.SelectedValue = rows[0]["RH1"].ToString();
               ddlRH2.SelectedValue = rows[0]["RH2"].ToString();
               ddlRH3.SelectedValue = rows[0]["RH3"].ToString();
               ddlMajor1.SelectedValue = rows[0]["Major1"].ToString();
               ddlMajor2.SelectedValue = rows[0]["Major2"].ToString();
               ddlMinor1.SelectedValue = rows[0]["Minor1"].ToString();
               ddlMinor2.SelectedValue = rows[0]["Minor2"].ToString();
                txtCondition.Text = rows[0]["Condition1"].ToString();
                txtclericalErrorsChecked.Text = rows[0]["RH2"].ToString();
                txtclericalErrorsChecked.Text = rows[0]["Clerical"].ToString();
                if (txtDateR.Text == "")
                {

                    txtDateR.Text = Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy");
                }
                if (txtTimeR.Text == "")
                {

                    txtTimeR.Text = DateTime.Now.ToString("hh:mm tt");
                }
                if (rows[0]["ApprovedBy1"] != DBNull.Value)
                {
                    btnSave.Text = "Update";
                   
           
                    //txtApprovedBy.Text = rows[0]["ApprovedBy1"].ToString();
                    ddlApprovedBy.SelectedValue = rows[0]["ApprovedBy"].ToString();
                    ddlApprovedBy1.SelectedValue = rows[0]["ApprovedBy1"].ToString();
                    txtTechnician.Text = rows[0]["Technician1"].ToString();
                    btnSave.Enabled = true;
                    
                }
                else
                {
                    btnSave.Enabled = true;
                   
                }
            }
            //btnUpdate.Visible = true;
            //btnSave.Visible = false;
            //btnCancel.Visible = true;
        }
    }
   
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Clear();
    }
    private DataTable GetSickPatients()
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            //sb.Append("SELECT ID,DATE_FORMAT(DATE,'%d-%M-%Y') AS Date1,FirstDegreeTear,SecondDegreeTear,ThirdDegreeTear,FourthDegreeTear,Episiotomy,NewBornResuscitated,PatientID,TransactionID  FROM delivery_master where TransactionID='" + Util.GetString(ViewState["TID"]) + "'");

            sb.Append("SELECT *,DATE_FORMAT(Date,'%d-%b-%Y') AS Date1,DATE_FORMAT(Time,'%h:%m %r') AS Time1,(SELECT Name 	FROM 	employee_master  WHERE  EmployeeId=EntryBy LIMIT 0, 1) AS EntryBy1 FROM sickpatientmaster ");


            DataTable dt = StockReports.GetDataTable(sb.ToString());


            return dt;
        }
        catch (Exception exc)
        {
            return null;
        }


    }
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var message = "";
            string dateR = Util.GetDateTime(txtDateR.Text).ToString("yyyy-MM-dd");
            string timeR = Util.GetDateTime(txtTimeR.Text).ToString("HH:mm");
                

            var sqlCMD = "UPDATE  transfusionreactionworkup SET  Clerical = @Clerical,  Serum = @Serum,  UrineH = @UrineH,  Bili = @Bili,  Uro = @Uro,  Direct = @Direct,  ABO1 = @ABO1,"+
"  ABO2 = @ABO2,  ABO3 = @ABO3,  RH1 = @RH1,  RH2 = @RH2,  RH3 = @RH3,  Major1 = @Major1,  Major2 = @Major2,  Minor1 = @Minor1,  Minor2 = @Minor2,  Condition1 = @Condition1,  ApprovedBy = @ApprovedBy,"+
"  UpdatedBy = @UpdatedBy,  UpdateDate = NOW(),  PatientID = @PatientID,  TransactionID = @TransactionID,Technician=@Technician,ApprovedBy1=@ApprovedBy1,DateR=@DateR,TimeR=@TimeR WHERE ID = @ID;";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
                Clerical = txtclericalErrorsChecked.Text,
                Serum = txtSerum.Text,
                UrineH = ddlHeamoglobinUria.SelectedValue,
                Bili = ddlBilirubenuria.SelectedValue,
                Uro = ddlUrobilinogen.SelectedValue,
                Direct = ddlDirect.SelectedValue,
                ABO1 = ddlABO1.SelectedValue,
                ABO2 = ddlABO2.SelectedValue,
                ABO3 = ddlABO3.SelectedValue,
                RH1 = ddlRH1.SelectedValue,
                RH2 = ddlRH2.SelectedValue,
                RH3 = ddlRH3.SelectedValue,
                Major1 = ddlMajor1.SelectedValue,
                Major2 = ddlMajor2.SelectedValue,
                Minor1 = ddlMinor1.SelectedValue,
                Minor2 = ddlMinor2.SelectedValue,
                Condition1 = txtCondition.Text,
                ApprovedBy = ddlApprovedBy.SelectedValue,
                ApprovedBy1 = ddlApprovedBy1.SelectedValue,
                DateR=dateR,
                TimeR=timeR,
                UpdatedBy = HttpContext.Current.Session["ID"].ToString(),
                PatientID = ViewState["PID"].ToString(),
                TransactionID = ViewState["TID"].ToString(),
                Technician = HttpContext.Current.Session["ID"].ToString(),

                ID = Util.GetString(lblPID.Text)
            });
            message = "Record saved Sucessfully";
            

            tnx.Commit();
            Clear1();
            BindDetails(ViewState["PID"].ToString(), ViewState["TID"].ToString());
            lblMsg.Text = message;
            btnSave.Text = "Update";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);

            lblMsg.Text = "Error occurred, Please contact Administrator";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
    protected void btnSubmit_Click1(object sender, EventArgs e)
    {
        if (Button3.Text == "Save")
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            ExcuteCMD excuteCMD = new ExcuteCMD();
            try
            {
                var message = "";
                string date = Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd");
                string date1 = Util.GetDateTime(txtDate1.Text).ToString("yyyy-MM-dd");
                string time = Util.GetDateTime(txtTime.Text).ToString("HH:mm");
                string time1 = Util.GetDateTime(txtTime1.Text).ToString("HH:mm");
                string time2 = Util.GetDateTime(txtTime2.Text).ToString("HH:mm");
                string time9 = Util.GetDateTime(txtTime9.Text).ToString("HH:mm");
                string time8 = Util.GetDateTime(txtTime8.Text).ToString("HH:mm");
                string time3 = Util.GetDateTime(txtTime3.Text).ToString("HH:mm");

                var sqlCMD = "INSERT INTO transfusionreactionworkup (" +

      "Date,  Time,  Symptoms,  TransfusionStartTime,  BloodStopped,  StoppedBy,  ClinicianNotified,  NotifiedBy,  ReportedToLabBy,  Date1,  Time1,  Blood,  Time2,  Urine,  Time3," +
    "  PatientID,  TransactionID)" +
    "VALUES  (        @Date,    @Time,    @Symptoms,    @TransfusionStartTime,    @BloodStopped,    @StoppedBy,    @ClinicianNotified,    @NotifiedBy,    @ReportedToLabBy,    @Date1," +
    "    @Time1,    @Blood,    @Time2,    @Urine,    @Time3,      @PatientID,    @TransactionID  );";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    Date = date,
                    Time = time,
                    Symptoms = txtSymtomsOfReaction.Text,
                    TransfusionStartTime = time1,
                    BloodStopped = time2,
                    StoppedBy = Session["ID"].ToString(),
                    ClinicianNotified = txtClinicianNotified.Text,
                    NotifiedBy = Session["ID"].ToString(),
                    ReportedToLabBy = txtReportedToLabBy.Text,
                    Date1 = date1,
                    Time1 = time9,
                    Blood = txtNurseDrawingBlood.Text,
                    Time2 = time8,
                    Urine = txtReceived.Text,
                    Time3 = time3,
                    PatientID = ViewState["PID"].ToString(),
                    TransactionID = ViewState["TID"].ToString()
                });
                message = "Record Save Sucessfully";
              

                tnx.Commit();
                lblMsg.Text = message;
                btnSave.Enabled = true;
                Button3.Enabled =false ;
                Clear();
                BindDetails(ViewState["PID"].ToString(), ViewState["TID"].ToString());

            }
            catch (Exception ex)
            {
                tnx.Rollback();
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);

                lblMsg.Text = "Error occurred, Please contact Administrator";
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
            if (Button3.Text == "Update")
            {
                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
                ExcuteCMD excuteCMD = new ExcuteCMD();
                try
                {
                    var message = "";
                    string date = Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd");
                    string date1 = Util.GetDateTime(txtDate1.Text).ToString("yyyy-MM-dd");
                    string time = Util.GetDateTime(txtTime.Text).ToString("HH:mm");
                    string time1 = Util.GetDateTime(txtTime1.Text).ToString("HH:mm");
                    string time2 = Util.GetDateTime(txtTime2.Text).ToString("HH:mm");
                    string time9 = Util.GetDateTime(txtTime9.Text).ToString("HH:mm");
                    string time8 = Util.GetDateTime(txtTime8.Text).ToString("HH:mm");
                    string time3 = Util.GetDateTime(txtTime3.Text).ToString("HH:mm");

                    var sqlCMD = "Update  transfusionreactionworkup set " +

          "  Symptoms=@Symptoms,  TransfusionStartTime=@TransfusionStartTime,  BloodStopped=@BloodStopped,  StoppedBy=@StoppedBy,  ClinicianNotified=@ClinicianNotified"+
          ",  NotifiedBy=@NotifiedBy,  ReportedToLabBy=@ReportedToLabBy,  Date1=@Date1,  Time1=@Time1,  Blood=@Blood,  Time2=@Time2,  Urine=@Urine,  Time3=@Time3" +
        "  where ID=@ID";
                    excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                    {
                        Symptoms = txtSymtomsOfReaction.Text,
                        TransfusionStartTime = time1,
                        BloodStopped = time2,
                        StoppedBy = Session["ID"].ToString(),
                        ClinicianNotified = txtClinicianNotified.Text,
                        NotifiedBy = Session["ID"].ToString(),
                        ReportedToLabBy = txtReportedToLabBy.Text,
                        Date1 = date1,
                        Time1 = time9,
                        Blood = txtNurseDrawingBlood.Text,
                        Time2 = time8,
                        Urine = txtReceived.Text,
                        Time3 = time3,
                        ID = Util.GetString(lblPID.Text)
                    });
                    message = "Record Save Sucessfully";
                   

                    tnx.Commit();
                    lblMsg.Text = message;
                    btnSave.Enabled = true;
                    //Button3.Enabled = false;
                    Clear();
                    BindDetails(ViewState["PID"].ToString(), ViewState["TID"].ToString());

                }
                catch (Exception ex)
                {
                    tnx.Rollback();
                    ClassLog objClassLog = new ClassLog();
                    objClassLog.errLog(ex);

                    lblMsg.Text = "Error occurred, Please contact Administrator";
                }
                finally
                {
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();
                }
            }
        }

    }
    public void BindDetails(string PID, string TID)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" Select *,(Select concat(title,' ',name) from Employee_master where EmployeeID=NotifiedBy)NotifiedBy1,(Select concat(title,' ',name) from Employee_master where EmployeeID=StoppedBy)StoppedBy1,(Select concat(title,' ',name) from Employee_master where EmployeeID=ApprovedBy)ApprovedBy111,(Select concat(title,' ',name) from Employee_master where EmployeeID=ApprovedBy1)ApprovedBy11,(Select concat(title,' ',name) from Employee_master where EmployeeID=Technician)Technician1,(Select concat(title,' ',name) from Employee_master where EmployeeID=StoppedBy)StoppedBy1,(Select concat(title,' ',name) from Employee_master where EmployeeID=EntryBy)EmpName,(Select concat(title,' ',name) from Employee_master where EmployeeID=ReportedToLabBy)ReportedToLabBy1,DATE_FORMAT(DateR, '%d %b %Y') as DateR1,DATE_FORMAT(Date, '%d %b %Y') as Date11,DATE_FORMAT(Date1, '%d %b %Y') as Date111,TIME_FORMAT(TimeR, '%h:%i %p') as TimeR1,TIME_FORMAT(Time, '%h:%i %p') as Time11,TIME_FORMAT(TransfusionStartTime, '%h:%i %p') as TransfusionStartTime1,TIME_FORMAT(BloodStopped, '%h:%i %p') as BloodStopped1,TIME_FORMAT(Time1, '%h:%i %p') as Time111,TIME_FORMAT(Time2,'%h:%i %p') as Time21,TIME_FORMAT(Time3, '%h:%i %p') as Time31  from transfusionreactionworkup where PatientID='" + PID + "' and TransactionID='" + TID + "' order by ID desc ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0)
            {
                ViewState["dt"] = dt;
                grdGrid.DataSource = dt;
                grdGrid.DataBind();
            }
            else
            {
                grdGrid.DataSource = null;
                grdGrid.DataBind();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    private void Clear()
    {

        txtDate.Text = Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy");
        //txtTime.Text = Util.GetDateTime(DateTime.Now).ToString("hh:mm tt");
        //txtSupervisingConsultant.Text = "";
        txtDate.Text = Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy");
        txtDate1.Text = Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy");
        ViewState["PID"] = Request.QueryString["PID"].ToString();
        ViewState["TID"] = Request.QueryString["TID"].ToString();

        BindDetails(ViewState["PID"].ToString(), ViewState["TID"].ToString());
        txtTime.Text = DateTime.Now.ToString("hh:mm tt");
        txtTime1.Text = DateTime.Now.ToString("hh:mm tt");
        txtTime2.Text = DateTime.Now.ToString("hh:mm tt");
        txtTime3.Text = DateTime.Now.ToString("hh:mm tt");
        txtTime8.Text = DateTime.Now.ToString("hh:mm tt");
        txtTime9.Text = DateTime.Now.ToString("hh:mm tt");
        btnSave.Enabled = false;
        string entryby = StockReports.ExecuteScalar("SELECT Name 	FROM 	employee_master  WHERE  EmployeeId='" + Session["ID"].ToString() + "' LIMIT 0, 1");
        txtReportedToLabBy.Text = entryby;
        txtStoppedBy.Text = entryby;
        txtNotifiedBy.Text = entryby;
        ddlApprovedBy.SelectedValue = Session["ID"].ToString();
        txtSymtomsOfReaction.Text = "";
        txtClinicianNotified.Text = "";
        txtNurseDrawingBlood.Text = "";
        txtReceived.Text = "";
       
               
        
        
    }
    private void Clear1()
    {
        txtclericalErrorsChecked.Text = "";
        txtSerum.Text = "";
        txtclericalErrorsChecked.Text = "";
        ddlHeamoglobinUria.SelectedIndex = -1;
        ddlBilirubenuria.SelectedIndex = -1;
        ddlUrobilinogen.SelectedIndex = -1;
        ddlDirect.SelectedIndex = -1;
        ddlABO1.SelectedIndex = -1;
        ddlABO2.SelectedIndex = -1;
        ddlABO3.SelectedIndex = -1;
        ddlRH1.SelectedIndex = -1;
        ddlRH2.SelectedIndex = -1;
        ddlRH3.SelectedIndex = -1;
        ddlMajor1.SelectedIndex = -1;
        ddlMajor2.SelectedIndex = -1;
        ddlMinor1.SelectedIndex = -1;
        ddlMinor2.SelectedIndex = -1;
        txtCondition.Text = "";
        txtclericalErrorsChecked.Text = "";
       
    }
    protected void btnUpdate_Click1(object sender, EventArgs e)
    {
    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);
        if (DateTime.Parse(txtDate.Text.Trim()) > (DateTime.Now))
        {

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('only past dates allowed');", true);
            return;
        }
        try
        {
            string query = "";
            MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, query);

            tranx.Commit();
            Clear();

            btnSave.Visible = true;
            btnUpdate.Visible = false;

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('updated successfully');", true);
            
        }
        catch (Exception ex)
        {
            tranx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('not updated');", true);
        }
        finally
        {
            tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    


}