using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class Design_IPD_Notecreationnew : System.Web.UI.Page
{
    private DataTable dtHeader;
    
    private string Status = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["TransactionID"] != null)
            {

                if (Request.QueryString["Status"] == null)
                    Status = StockReports.ExecuteScalar("Select Status from Patient_Medical_history where TransactionID='" + Request.QueryString["TransactionID"].ToString() + "'");
                else
                    Status = Request.QueryString["Status"].ToString();
                ViewState["TID"] = Request.QueryString["TransactionID"].ToString();
                ViewState["Status"] = Status;
                ViewState["PID"] = Request.QueryString["PID"].ToString();
                hdntransactionId.Value = Request.QueryString["TransactionID"].ToString();
            }
            else {

                ViewState["TID"] = Request.QueryString["TID"].ToString();
                ViewState["Status"] = "IN";
                hdntransactionId.Value = Request.QueryString["TID"].ToString();
            }


            //if (Status == "OUT")
            //{
            //    string Msg = "Patient is Already Discharged.You can not enter any note type ";
            //    Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
            //}
            

            string department = StockReports.ExecuteScalar("select (SELECT DocDepartmentID FROM DOCTOR_MASTER WHERE DoctorID=pmh.DoctorID GROUP BY DoctorID) from patient_medical_history pmh where TransactionID='" + ViewState["TID"].ToString() + "'");
            string DoctorID = StockReports.ExecuteScalar("select DoctorID from patient_medical_history pmh where TransactionID='" + ViewState["TID"].ToString() + "'");

                rdbTemplate.Enabled = true;
            
          
            DischargePrepared();
            CreateTable();
            LoadHeaders("0");
         
            //LoadTemplates(ddlHeader.SelectedItem.Value);
            //BindDetails(ViewState["TID"].ToString());
            
            BindDischargeType();
            bindUser();
          

        }

       
    }

    private void BindDischargeType()
    {
        string Header = StockReports.ExecuteScalar("select Header FROM emr_ipd_details ed  where ed.TransactionID ='" + ViewState["TID"].ToString() + "'");
        string FinalDiagnosis = StockReports.ExecuteScalar("SELECT COUNT(*) FROM Cpoe_10cm_patient WHERE TransactionID='" + ViewState["TID"].ToString() + "' AND isactive=1");
        if (Header != "" || FinalDiagnosis!="0")
        {
            lbldischargeType.Text = Header;

        }
        else
        {
            //ddlHeader.Attributes.Add("disabled", "disabled");
           // lblMsg.Text = "Please Add First Discharge Type and Discharge Diagnosis";
            //    btnPrint.Visible = false;
        }
    }
    private void DischargePrepared()
    {
        string Header = StockReports.ExecuteScalar("SELECT COUNT(*) FROM notecreationpatient_detail WHERE TransactionID ='" + ViewState["TID"].ToString() + "'");
        if (Header != "")
            btnPrint.Visible = true;
        else
            btnPrint.Visible = false;
    }
    protected void btnAddItem_Click(object sender, EventArgs e)
    {
        if (ddlHeader.SelectedValue =="0")
        {
            lblMsg.Text = "Please Select Note Type";
            ddlHeader.Focus();
            return;
        }
        if (ddlHeader.SelectedItem.Value == "" && txtDetail.Text.Trim() == "")
        {
            lblMsg.Text = "Please Specify Data";
            ddlHeader.Focus();
            return;
        }

        if (rdbTemplate.SelectedItem.Value == "Update" && txtTempHeader.Text.Trim() == "")
        {
            lblMsg.Text = "Please Specify Template Name";
            txtTempHeader.Focus();
            return;
        }
        if (rdbTemplate.SelectedItem.Value == "New" && txtTempHeader.Text.Trim() == "")
        {
            lblMsg.Text = "Please Specify Template Name";
            txtTempHeader.Focus();
            return;
        }
        if (rdbTemplate.SelectedValue != "Nothing" && rdbTemplate.SelectedValue != "Update")
        {
            int count = Util.GetInt(StockReports.ExecuteScalar("Select Count(*) from NoteTypeHeader_template Where  Temp_Name='" + txtTempHeader.Text.Trim() + "' AND HeaderID='" + ddlHeader.SelectedValue + "' and IF(IsShared=0,EmpId='"+ddlEmployee.SelectedValue.ToString()+"',IsShared=1)"));
            if (count > 0)
            {
                lblMsg.Text = "Template Name Already Exists";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "ShowHide()", true);
                txtTempHeader.Focus();
                return;
            }
        }
       dtHeader = (DataTable)ViewState["dtHeader"];
        txtDetail.Text = txtDetail.Text.Replace("'", " ");
        if (txtDetail.Text == "<br>")
            txtDetail.Text = txtDetail.Text.Replace("<br>", "");
        else if (txtDetail.Text == "<BR>")
            txtDetail.Text = txtDetail.Text.Replace("<BR>", "");
        else if (txtDetail.Text == " <br> ")
            txtDetail.Text = txtDetail.Text.Replace(" <br> ", "");
        else if (txtDetail.Text == " <BR> ")
            txtDetail.Text = txtDetail.Text.Replace(" <BR> ", "");
        else if (txtDetail.Text == "<br /> ")
            txtDetail.Text = txtDetail.Text.Replace("<br/> ", "<br>");
        if(txtDetail.Text.Contains("<br />"))
            txtDetail.Text = txtDetail.Text.Replace("<br />", "<br>");
        if (txtDetail.Text.EndsWith("<BR></P>"))
        {
            int lenght=txtDetail.Text.Length;
            txtDetail.Text = txtDetail.Text.Substring(0, lenght - 8) + "</P>";
        }
        else if (txtDetail.Text.EndsWith("<BR>"))
        {
            int lenght = txtDetail.Text.Length;
            txtDetail.Text = txtDetail.Text.Substring(0, lenght - 4);
        }
        try
        {
            if (dtHeader != null && dtHeader.Rows.Count > 0)
            {
                DataRow[] drReportType = dtHeader.Select("Header_ID = '" + ddlHeader.SelectedItem.Value + "'");

                if (drReportType.Length > 0)
                {
                    drReportType[0]["Header_ID"] = ddlHeader.SelectedItem.Value;
                    drReportType[0]["HeaderName"] = ddlHeader.SelectedItem.Text;
                    
                    string text = txtDetail.Text;
                    text = text.Replace("\'", "\''");
                    text = text.Replace("–", "-");
                    text = text.Replace("'", "'");
                    text = text.Replace("µ", "&micro;");
                    drReportType[0]["Value"] = text;

                    if (rdbTemplate.SelectedItem.Value == "Update" && txtTempHeader.Text.Trim() != string.Empty)
                    {
                      //  txtTempHeader.Text = ddlTemplates.SelectedItem.Text;
                        drReportType[0]["TempHeadName"] = txtTempHeader.Text.Trim();
                        drReportType[0]["TempFlag"] = "1";
                    }
                   else if (rdbTemplate.SelectedItem.Value == "New" && txtTempHeader.Text.Trim() != string.Empty)
                    {
                        //txtTempHeader.Text = ddlTemplates.SelectedItem.Text;
                        drReportType[0]["TempHeadName"] = txtTempHeader.Text.Trim();
                        drReportType[0]["TempFlag"] = "2";
                    }
                    else
                    {
                        drReportType[0]["TempHeadName"] = "";
                        drReportType[0]["TempFlag"] = "0";
                    }
                    drReportType[0]["Approved"] = 0;
                    ViewState["dtHeader"] = dtHeader;
                   txtDetail.Text = string.Empty;
                    rdbTemplate.SelectedIndex = 0;
                    txtTempHeader.Text = "";
                    LoadAddedDetails();
                    
                    
                }
                else
                {
                    DataRow dr = dtHeader.NewRow();
                    dr["Header_ID"] = ddlHeader.SelectedItem.Value;
                    dr["HeaderName"] = ddlHeader.SelectedItem.Text;
                    dr["Value"] = txtDetail.Text;

                    if (rdbTemplate.SelectedItem.Value == "Update" && txtTempHeader.Text.Trim() != string.Empty)
                    {
                        //txtTempHeader.Text = ddlTemplates.SelectedItem.Text;
                        dr["TempHeadName"] = txtTempHeader.Text.Trim();
                        dr["TempFlag"] = "1";
                    }
                    else if (rdbTemplate.SelectedItem.Value == "New" && txtTempHeader.Text.Trim() != string.Empty)
                    {
                        //txtTempHeader.Text = ddlTemplates.SelectedItem.Text;
                        dr["TempHeadName"] = txtTempHeader.Text.Trim();
                        dr["TempFlag"] = "2";
                    }
                    else
                    {
                        dr["TempHeadName"] = "";
                        dr["TempFlag"] = "0";
                    }
                    dr["Approved"] = 0;
                    dtHeader.Rows.Add(dr);

                    ViewState["dtHeader"] = dtHeader;
                    txtDetail.Text = string.Empty;
                    txtTempHeader.Text = "";
                    LoadAddedDetails();
                    
                }
            }
            else
            {
                DataRow dr = dtHeader.NewRow();
                dr["Header_ID"] = ddlHeader.SelectedItem.Value;
                dr["HeaderName"] = ddlHeader.SelectedItem.Text;
                dr["Value"] = txtDetail.Text;

                if (rdbTemplate.SelectedItem.Value=="Update" && txtTempHeader.Text.Trim() != string.Empty)
                {
                    dr["TempHeadName"] = txtTempHeader.Text.Trim();
                    dr["TempFlag"] = "1";
                }
               else if (rdbTemplate.SelectedItem.Value == "New" && txtTempHeader.Text.Trim() != string.Empty)
                {
                    //txtTempHeader.Text = ddlTemplates.SelectedItem.Text;
                    dr["TempHeadName"] = txtTempHeader.Text.Trim();
                    dr["TempFlag"] = "2";
                }
                else
                {
                    dr["TempHeadName"] = "";
                    dr["TempFlag"] = "0";
                }
                dr["Approved"] = 0;
                dtHeader.Rows.Add(dr);
                ViewState["dtHeader"] = dtHeader;
                txtDetail.Text = string.Empty;
                rdbTemplate.SelectedIndex = 0;
                txtTempHeader.Text = "";
                LoadAddedDetails();
                
                /*btnSave.Visible = true;*/

            }
            saveData();

        }
        catch (Exception ex)
        {
        
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
       
    }

    protected void grdHeader_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "ADelete")
        {
            int index = Util.GetInt(e.CommandArgument);

            dtHeader = (DataTable)ViewState["dtHeader"];

            if (dtHeader != null && dtHeader.Rows.Count > 0)
            {
                string ReportTypeHeaderID = ((Label)grdHeader.Rows[index].FindControl("lblReportTypeHeaderID")).Text;
                dtHeader.Rows.RemoveAt(index);
                dtHeader.AcceptChanges();
                ViewState["dtHeader"] = dtHeader;
                //delete query
                string strQuery = "delete from notecreationpatient_detail where TransactionID='" + ViewState["TID"].ToString() + "' and Header_Id=" + ReportTypeHeaderID+ " AND UserID='"+Session["ID"].ToString()+"' " ;
                StockReports.ExecuteDML(strQuery);
                LoadAddedDetails();
            }

        }
        else if (e.CommandName == "AEdit")
        {

            int index = Util.GetInt(e.CommandArgument);
            string ReportTypeHeaderID = ((Label)grdHeader.Rows[index].FindControl("lblReportTypeHeaderID")).Text;

            dtHeader = (DataTable)ViewState["dtHeader"];

            if (dtHeader != null && dtHeader.Rows.Count > 0)
            {
                DataRow[] dr = dtHeader.Select("Header_ID = '" + ReportTypeHeaderID + "'");

                if (dr.Length > 0)
                {
                    ddlHeader.SelectedIndex = ddlHeader.Items.IndexOf(ddlHeader.Items.FindByValue(dr[0]["Header_ID"].ToString()));
                    LoadTemplates(dr[0]["Header_ID"].ToString());
                    txtDetail.Text = HttpUtility.HtmlDecode(dr[0]["Value"].ToString());

                }
            }

        }
    }

    public void saveData()
    {
        dtHeader = (DataTable)ViewState["dtHeader"];

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

       
        try
        {
            string strQuery = "";
            foreach (DataRow row in dtHeader.Rows)
            {

                if (row["TempFlag"].ToString() == "1" && row["TempHeadName"].ToString().Trim() !="")
                {
                    if (ddlTemplates.SelectedValue !="0")
                    {
                        int count = Util.GetInt(StockReports.ExecuteScalar("Select Count(*) from NoteTypeHeader_template Where    ID = '" + ddlTemplates.SelectedItem.Value + "' AND HeaderID='" + ddlHeader.SelectedValue + "' and EmpId='" + ddlEmployee.SelectedValue.ToString() + "' "));
                        if (count==0)
                        {
                            lblMsg.Text = "You can Update only Your Templates";
                            return ;
                        }
                        else
                        {
                            strQuery = "delete from NoteTypeHeader_template where Headerid='" + row["Header_Id"].ToString() + "' And ID = '" + ddlTemplates.SelectedItem.Value + "'and EmpId='" + ddlEmployee.SelectedValue.ToString() + "' ";
                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);
                            strQuery = "Insert into NoteTypeHeader_template(Headerid,Template_Value,Temp_Name,CreatedBy,EmpId,IsShared) values(" + row["Header_Id"].ToString() + ",'" + row["Value"].ToString().Replace("'", "''") + "','" + row["TempHeadName"].ToString().Trim() + "','" + Session["ID"].ToString() + "','" + ddlEmployee.SelectedValue.ToString() + "'," + chkIsSahred.Checked + ")";
                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);
                        }

                       
                    }
                }

                
        var Specialty = "";
        var SpecialtyID = "";
        if (Session["RoleID"].ToString() == "52")
        {
            string DoctorID = StockReports.ExecuteScalar("SELECT DoctorID FROM doctor_employee de WHERE de.EmployeeID='" + Session["ID"] + "'");
            if (DoctorID != "")
            {
                string Specialtydetail = StockReports.ExecuteScalar("SELECT CONCAT(tm.ID,'#',tm.NAME)Specialty FROM doctor_master dm  INNER JOIN type_master tm ON tm.NAME=dm.Specialization  WHERE dm.DoctorID='" + DoctorID + "' AND tm.type='Doctor-Specialization'");
                Specialty = Specialtydetail.Split('#')[1];
                SpecialtyID = Specialtydetail.Split('#')[0];
            }

            else
            {
                Specialty = "Other";
                SpecialtyID = "8";
            }
        }
        else
        {
            Specialty = "Other";
            SpecialtyID = "8";
        }

        string Cadretiertype = StockReports.ExecuteScalar("SELECT CONCAT(ecm.CadreName,'#',etm.tiername,'#',em.cadreID,'#',em.TierID)Cadretier FROM employee_master em INNER JOIN Employee_Cadre_Master ecm ON em.Cadreid=ecm.ID  INNER JOIN Employee_Tier_Master etm ON etm.ID=em.TierID WHERE em.EmployeeID='" + Session["ID"].ToString() + "'");
        
                if (row["TempFlag"].ToString() == "2" && row["TempHeadName"].ToString().Trim() != "")
                {

                    strQuery = "Insert into NoteTypeHeader_template(Headerid,Template_Value,Temp_Name,CreatedBy,EmpId,IsShared) values(" + row["Header_Id"].ToString() + ",'" + row["Value"].ToString().Replace("'", "''") + "','" + row["TempHeadName"].ToString().Trim() + "','" + Session["ID"].ToString() + "','" + ddlEmployee.SelectedValue.ToString() + "'," + chkIsSahred.Checked + ")";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);
                }
                if (row["TempFlag"].ToString() == "0")
                {
                    //strQuery = "delete from notecreationpatient_detail where TransactionID='" + ViewState["TID"].ToString() + "' and Header_Id='" + row["Header_Id"].ToString() + "' and UserID='" + Session["ID"].ToString() + "' ";
                   // MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);
                    //Insert DR Detail
                    strQuery = "insert into notecreationpatient_detail(TransactionID,Header_Id,HeaderName,Detail,UserID,PatientID,Cadre,Tier,CadreID,TierID,Specialty,SpecialtyID,EntryDate,NoteCreateDeptLedgerNo,IsApproved)values('" + ViewState["TID"].ToString() + "'," + row["Header_Id"].ToString() + ",'" + row["HeaderName"].ToString() + "','" + row["Value"].ToString().Replace("'", "''") + "','" + Util.GetString(Session["ID"]) + "','" + ViewState["PID"].ToString() + "','" + Cadretiertype.Split('#')[0] + "','" + Cadretiertype.Split('#')[1] + "','" + Cadretiertype.Split('#')[2] + "','" + Cadretiertype.Split('#')[3] + "','" + Specialty + "','" + SpecialtyID + "',NOW(),'" + Session["DeptLedgerNo"].ToString() + "'," + Util.GetInt(GetApprovalType( Util.GetString(Session["ID"].ToString()))) + ")";
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);
                    
                }
            }
            lblMsg.Text = "Record Saved Successfully";
            Tranx.Commit();
            LoadTemplates(ddlHeader.SelectedItem.Value);
          //  BindDetails(ViewState["TID"].ToString());
           
            //LoadHeaders("0");
            if (dtHeader.Rows.Count > 0)
            {
                btnPrint.Visible = true;
            }
            else
            {
                btnPrint.Visible = false;
            }
            dtHeader.Clear();
            ViewState["dtHeader"] = null;
            CreateTable();
            txtDetail.Text = "";
            rdbTemplate.SelectedIndex = 0;
        }
        catch (Exception ex)
        {
            lblMsg.Text = "Error occurred, Please contact administrator";
            Tranx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
  
  


    protected void btnPrint_Click(object sender, EventArgs e)
    {
        string status = ViewState["Status"].ToString();
       
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/IPD/printNoteCreationReport_pdf.aspx?NoteID=&TID=" + ViewState["TID"].ToString() + "&Status=" + ViewState["Status"].ToString() + "&ReportType=" + rbtnFormat.SelectedItem.Text + "');", true);
    }

    private void LoadHeaders(string NotetypeID)
    {
        string str = "";
        StringBuilder sb =new StringBuilder();


        sb.Append("SELECT Header_Id,ifnull(HeaderName,'')HeaderName FRom NoteTypeMaster ntm where ntm.IsActive=1 order by ntm.SeqNo");
        
        DataTable dt = StockReports.GetDataTable(sb.ToString()).Copy();
        ddlHeader.DataSource = dt;
        ddlHeader.DataTextField = "HeaderName";
        ddlHeader.DataValueField = "Header_Id";
        ddlHeader.DataBind();
        //ddlHeader.Items.Insert(0, "Select");
        if (Session["RoleID"].ToString() == "52")
        {
            ddlHeader.SelectedValue = "19";
            txtDetail.Text = "Progress Note";
            LoadTemplates(ddlHeader.SelectedItem.Value);
        }
        else
        {
            ddlHeader.SelectedValue = "15";
            txtDetail.Text = "Nursing Progress Note";
            LoadTemplates(ddlHeader.SelectedItem.Value);
        }

        
    }
    private void CreateTable()
    {
        dtHeader = new DataTable();
        dtHeader.Columns.Add("Header_ID");
        dtHeader.Columns.Add("HeaderName");
        
        dtHeader.Columns.Add("Value");
        dtHeader.Columns.Add("TempHeadName");
        dtHeader.Columns.Add("TempFlag");
        dtHeader.Columns.Add("Approved");
        ViewState.Add("dtHeader", dtHeader);
    }
    private void LoadAddedDetails()
    {
        dtHeader = (DataTable)ViewState["dtHeader"];
        if (grdHeader.Rows.Count > 0)
        {
            grdHeader.DataSource = null;
            grdHeader.DataBind();
        }
        grdHeader.DataSource = dtHeader;
        grdHeader.DataBind();
    }
    private void LoadTemplates(string TempHeaderID)
    {

        
       // lblMsg.Text = "";
        StringBuilder sb = new StringBuilder();
        sb.Append("Select TRIM(Temp_Name)Temp_Name,ID AS Template_Value from NoteTypeHeader_template Where Headerid='" + TempHeaderID + "' and    CreatedBy='" + Session["ID"].ToString() + "'order by Temp_Name ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlTemplates.DataSource = dt;
            ddlTemplates.DataTextField = "Temp_Name";
            ddlTemplates.DataValueField = "Template_Value"; 
            ddlTemplates.DataBind();
            ddlTemplates.Items.Insert(0, new ListItem("Select", "0"));
          
        }
        else
        {
            ddlTemplates.Items.Clear();
            //lblMsg.Text = "No Templates Available under " + ddlHeader.SelectedItem.Text;
            ddlTemplates.DataSource = null;
            ddlTemplates.DataBind();
            //txtDetail.Text = "";
        }
    }


    private void BindDetails(string TransactionID)
    {
        if (ddlHeader.SelectedItem.Value == "Select")
        {
            lblMsg.Text = "Please Select Note Type";
            return;
        }
        string str = "SELECT Header_ID Header_ID,HeaderName,Detail Value,''TempHeadName,0 TempFlag,'' Approved FROM notecreationpatient_detail edr  WHERE edr.TransactionID='" + TransactionID + "' and Header_ID='" + ddlHeader.SelectedItem.Value + "' AND UserID='" + Session["ID"].ToString() + "'";
        DataTable dtHeader = StockReports.GetDataTable(str);
        if (dtHeader.Rows.Count > 0)
        { ViewState["dtHeader"] = dtHeader; }
        else { ViewState["dtHeader"] = dtHeader; }
        grdHeader.DataSource = dtHeader;
        grdHeader.DataBind();
    }


    

  

    protected void btn_Cancel_Click(object sender, EventArgs e)
    {
        string str = "";

        foreach (ListItem li in chk.Items)
        {
            if (li.Selected)
            {
                if (str != "")
                {
                    str = str + ", " + li.Text;
                }
                else
                {
                    str = li.Text;
                }
            }
        }

        txtDetail.Text = str;
    }


    

   

   

    
    protected void grdHeader_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        
    }
    
    //protected void btnDelete_Click(object sender, EventArgs e)
    //{
    //    if (ddlTemplates.SelectedValue != "")
    //    {
    //        StockReports.ExecuteScalar(" DELETE FROM NoteTypeHeader_template WHERE id='" + ddlTemplates.SelectedItem.Value + "' ");
    //        LoadTemplates(ddlHeader.SelectedItem.Value);
    //    }
    //    else
    //    {
    //        lblMsg.Text = "Please Select The Header And Template";
    //    }
    //}

    public void bindUser()
    {

        string GetEmp = "SELECT DISTINCT(fl.EmployeeID)EmployeeID,CONCAT(emp.Title,'',emp.NAME) Employee FROM f_login fl INNER JOIN employee_master emp ON emp.EmployeeID=fl.EmployeeID AND fl.Active=1";
        DataTable dt = StockReports.GetDataTable(GetEmp);
        if (dt.Rows.Count > 0)
        {
            ddlEmployee.DataSource = dt;
            ddlEmployee.DataTextField = "Employee";
            ddlEmployee.DataValueField = "EmployeeID";
            ddlEmployee.DataBind();
            ddlEmployee.Items.Insert(0, "Select");

            ddlEmployee.SelectedValue = Session["Id"].ToString();
            if (Session["Id"].ToString() == "EMP001")
            {
                ddlEmployee.Enabled = false;
            }
        }
        else
        {
            ddlEmployee.Items.Insert(0, "Select");
        }
    }

    //protected void ddlNoteType_SelectedIndexChanged(object sender, EventArgs e)
    //{
    //    if (ddlNoteType.SelectedItem.Value == "Select")
    //    {
    //        lblMsg.Text = "Please Select Note Type";
    //        return;
    //    }
       
    //    LoadHeaders(ddlNoteType.SelectedItem.Value);
    //    BindDetails(ViewState["TID"].ToString());


    //}

    [WebMethod(EnableSession = true)]
    public static string BindPatientNoteCreation(string NoteTypevalue, string TID)
    {
        StringBuilder sb = new StringBuilder();
        DataTable dt = new DataTable();
        if (NoteTypevalue == "DM")
        {
            dt = StockReports.GetDataTable(" select dm.Medicinename as DrugName,dm.Time_next_Dose as NextDose,dm.Dose as Dose,dm.Days as Duration,if(dm.Meal='0','',dm.Meal)Meal  from discharge_medicine dm where TransactionID='" + TID + "'");
        }

        else  if (NoteTypevalue == "FD")
        {
            dt = StockReports.GetDataTable(" SELECT icd.Group_Desc AS Diagnosis,icd.ICD10_3_Code AS DiagnosisCode FROM cpoe_10cm_patient icdp INNER JOIN icd_10_new icd ON icdp.icd_id=icd.ID WHERE icdp.TransactionID='" + TID + "'");
        }
        else if (NoteTypevalue == "Allergy")
        {
            dt = StockReports.GetDataTable(" select IFNULL(Allergies,'')Allergies from cpoe_hpexam dm  where TransactionID='" + TID + "'");
        }

        else if (NoteTypevalue == "PRGNote")
        {
            dt = StockReports.GetDataTable("SELECT DATE_FORMAT(pc.NoteDate,'%d-%b-%Y')Dates,'Progress Note' AS Notetype,(SELECT CONCAT(title,' ',NAME)Author from employee_master em WHERE em.Employeeid=pc.UserID)Author,IFNULL(pc.ProgressNote,'')ProgressNote,IFNULL(pc.Careplan,'')Careplan,PC.ID FROM nursing_doctorprogressnote pc WHERE TransactionID='" + TID + "' and pc.Isactive=1");
        }
        else if (NoteTypevalue == "Vital")
        {
            dt = StockReports.GetDataTable("SELECT concat('<b>Vitals Last 24Hrs- </b> ','Weight: ',ipo.Weight,' Height ',ipo.Height,' BP: ',ipo.Bp,' Temp: ',ipo.Temp,' RR: ',ipo.Resp,' SPO2: ',ipo.Oxygen)Vitals FROM IPD_Patient_ObservationChart ipo where ipo.TransactionID='"+TID+"' order by id desc limit 1");
        }
        else if (NoteTypevalue == "Lab")
        { 
              sb.Append("   SELECT concat('<b>Lab Last 24Hrs- </b>',IFNULL(CONCAT(( SELECT  (CONCAT('HB',':',ploo.VALUE)) para FROM patient_labobservation_opd ploo INNER JOIN patient_labinvestigation_opd plo ON plo.Test_ID = ploo.Test_ID WHERE plo.TransactionID=pmh.TransactionID ");
	          sb.Append(" AND ploo.LabObservation_ID IN ('LSHHI2') AND ploo.VALUE <>'' GROUP BY ploo.LabObservation_ID ORDER BY ploo.LabObservationName,ploo.ID DESC  ");
              sb.Append("  ),',',( ");
	          sb.Append(" SELECT  (CONCAT('NA',':',ploo.VALUE)) para FROM patient_labobservation_opd ploo  INNER JOIN patient_labinvestigation_opd plo ON plo.Test_ID = ploo.Test_ID WHERE plo.TransactionID=pmh.TransactionID AND ploo.LabObservation_ID IN ('LSHHI267') AND ploo.VALUE <>'' ");
              sb.Append("   GROUP BY ploo.LabObservation_ID ORDER BY ploo.LabObservationName,ploo.ID DESC ");
              sb.Append(" ),',',( ");
	          sb.Append("  SELECT  (CONCAT('PL',':',ploo.VALUE)) para FROM patient_labobservation_opd ploo INNER JOIN patient_labinvestigation_opd plo ON plo.Test_ID = ploo.Test_ID WHERE plo.TransactionID=pmh.TransactionID AND ploo.LabObservation_ID IN ('LSHHI16') AND ploo.VALUE <>'' ");
	          sb.Append("  GROUP BY ploo.LabObservation_ID  ORDER BY ploo.LabObservationName,ploo.ID DESC ");
              sb.Append("  ),',',( ");
	          sb.Append("  SELECT  (CONCAT('CRE',':',ploo.VALUE)) para FROM patient_labobservation_opd ploo INNER JOIN patient_labinvestigation_opd plo ON plo.Test_ID = ploo.Test_ID WHERE plo.TransactionID=pmh.TransactionID AND ploo.LabObservation_ID IN ('LSHHI179') AND ploo.VALUE <>'' ");
	          sb.Append("  GROUP BY ploo.LabObservation_ID ");
	          sb.Append("  ORDER BY ploo.LabObservationName,ploo.ID DESC  ");
              sb.Append("  ),',',( ");
	          sb.Append("  SELECT  (CONCAT('K',':',ploo.VALUE)) para FROM patient_labobservation_opd ploo INNER JOIN patient_labinvestigation_opd plo ON plo.Test_ID = ploo.Test_ID WHERE plo.TransactionID=pmh.TransactionID AND ploo.LabObservation_ID IN ('LSHHI179') AND ploo.VALUE <>'' ");
	          sb.Append("  GROUP BY ploo.LabObservation_ID ORDER BY ploo.LabObservationName,ploo.ID DESC )),''))LAB ");
              sb.Append("  FROM patient_medical_history pmh INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID WHERE  pmh.TransactionID='"+TID+"' ");
              dt = StockReports.GetDataTable(sb.ToString());
            }

        else if (NoteTypevalue == "OT")
        {
            sb.Append(" SELECT t.Surgery FROM ( SELECT  IF(PrimaryProcedureText='select','',PrimaryProcedureText) AS Surgery FROM cpoe_OTNotes_DeptofSurgery ct WHERE ct.TransactionID='" + TID + "' ");
            sb.Append(" UNION ALL ");
            sb.Append(" SELECT IF(SecondaryProcedureText='select','',SecondaryProcedureText) AS Surgery FROM cpoe_OTNotes_DeptofSurgery ct WHERE ct.TransactionID='" + TID + "' ");
            sb.Append(" UNION ALL ");
            sb.Append(" SELECT IF(OtherSurgery='select','',OtherSurgery) AS Surgery FROM cpoe_OTNotes_DeptofSurgery ct WHERE ct.TransactionID='" + TID + "' )t WHERE t.Surgery<>''  ");
            dt = StockReports.GetDataTable(sb.ToString());
        
}
        else { dt = StockReports.GetDataTable(" select id,NoteType,Problem,OnSet,Description,Code,Surgery,ifnull(ifnull(DATE_FORMAT(SurgeryDate,'%d-%b-%Y'),''),'')SurgeryDate,Illness,RelationShip,Issue,DoctorID,PatientID,TransactionID,Createdby,date_format(CreatedDate,'%d-%b-%Y')CreatedDate,(select Concat(Title,' ',Name) from employee_master em where EmployeeID=Createdby)Author from PatientNoteCreation where NoteType='" + NoteTypevalue + "' and TransactionID='" + TID + "' AND Active=1 order by id desc"); }

        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
        }
        else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "" }); }


    }

    [WebMethod(EnableSession = true)]
    public static string bindheadertemplate(string HeaderID, string TID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" Select TRIM(Temp_Name)Temp_Name,ID AS Template_Value from NoteTypeHeader_template Where Headerid='" + HeaderID + "' and CreatedBy='" + HttpContext.Current.Session["ID"].ToString() + "'   order by Temp_Name ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());


        //string str = "SELECT Header_ID Header_ID,HeaderName,Detail Value,''TempHeadName,0 TempFlag,'' Approved FROM notecreationpatient_detail edr  WHERE edr.TransactionID='" + TID + "' and Header_ID='" +HeaderID + "' AND UserID='"+HttpContext.Current.Session["ID"]+"'";
        string str = "Select TRIM(Temp_Name)Temp_Name,ID AS Template_Value,Template_Value AS templateDisc from NoteTypeHeader_template Where Headerid='" + HeaderID + "' and IsDefault=1   order by Temp_Name";
        
        DataTable dtHeaderPatientDetails = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0 || dtHeaderPatientDetails.Rows.Count>0)
        {

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt, PatientData = dtHeaderPatientDetails });
        }
        else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "" }); }
       
    }

    [WebMethod(EnableSession = true)]
    public static string bindtemplatedata(string TemplateID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("Select Template_Value from NoteTypeHeader_template Where ID='" + TemplateID + "' AND Temp_Name<>'' order by Temp_Name");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
        }
        else {  return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "" }); }

    }
    [WebMethod(EnableSession = true)]
    public static string bindAllNoteType(string TID)
    {



        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable("SELECT GROUP_CONCAT(pt.Detail)Detail FROM notecreationpatient_detail pt WHERE pt.TransactionID='" + TID + "'  and pt.UserID='" + HttpContext.Current.Session["ID"].ToString() + "'");


        if (dt.Rows.Count > 0)
        {

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
        }
        else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "" }); }


    }
    [WebMethod(EnableSession = true)]
    public static string deleteTemplate(string TemplateID)
    {
         MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var sqlCMD = string.Empty;
        try{
            sqlCMD = "delete from NoteTypeHeader_template pt where pt.id=@id ";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {

                id = TemplateID
            });
            tnx.Commit();
         return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Template Delete Successfully" });
      
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

    [WebMethod(EnableSession = true)]
    public static string bindtemplateHeaderwise(string HeaderID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("Select TRIM(Temp_Name)Temp_Name,ID AS Template_Value from NoteTypeHeader_template Where Headerid='" + HeaderID + "'  order by Temp_Name ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0 )
        {

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
        }
        else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "" }); }

    }

    [WebMethod(EnableSession = true)]
    public static string Bindnotecreationdetails(string NoteTypeHeaderID, string TID)
    {
        StringBuilder sb = new StringBuilder();
        string str = "SELECT Header_ID Header_ID,HeaderName,Detail Value,''TempHeadName,0 TempFlag,'' Approved FROM notecreationpatient_detail edr  WHERE edr.TransactionID='" + TID + "' and Header_ID='" + NoteTypeHeaderID + "' AND UserID='" + HttpContext.Current.Session["ID"] + "'";

        DataTable dtHeaderPatientDetails = StockReports.GetDataTable(str);
        if (dtHeaderPatientDetails.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dtHeaderPatientDetails });
        }
        else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "" }); }

    }

    [WebMethod(EnableSession = true)]
    public static string bindotherTemplateuserlist()
    {
        DataTable dt = StockReports.GetDataTable("SELECT ntt.CreatedBy,CONCAT(em.Title,em.NAME)UserName FROM NoteTypeHeader_template ntt INNER JOIN employee_master em ON ntt.CreatedBy=em.EmployeeID WHERE ntt.CreatedBy NOT IN('" + HttpContext.Current.Session["ID"].ToString() + "') GROUP BY ntt.CreatedBy");

        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
        }
        else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "" }); }
    }
    [WebMethod(EnableSession = true)]
    public static string BindOtherUserTemplate(string NoteType, string Employee)
    {
        DataTable dt = StockReports.GetDataTable(" select Temp_Name,Id as Headerid  from NoteTypeHeader_template where HeaderId='" + NoteType + "'  and CreatedBy='" + Employee + "'");

        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
        }
        else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "" }); }
    }

    [WebMethod(EnableSession = true)]
    public static string bindTemplateinEditor(string ID)
    {
        DataTable dt = StockReports.GetDataTable("select ifnull(Template_Value,'')Template_Value from NoteTypeHeader_template where id='" + ID + "'");

        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
        }
        else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "" }); }
    }

    public  int GetApprovalType(string EmployeeId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT em.`NAME`,em.`EmployeeID` FROM  employee_master em WHERE em.`TierID`=8 AND em.`EmployeeID`='" + EmployeeId + "' AND em.`IsActive`=1; ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0 && dt != null)
        {
            return 0;

        }
        else
        {
            return 1;

        }

    }




}