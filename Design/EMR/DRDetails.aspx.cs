using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_EMR_DRDetails : System.Web.UI.Page
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
                hdntransactionId.Value = Request.QueryString["TransactionID"].ToString();
            }
            else {

                ViewState["TID"] = Request.QueryString["TID"].ToString();
                ViewState["Status"] = "IN";
                hdntransactionId.Value = Request.QueryString["TID"].ToString();
            }

            

            string department = StockReports.ExecuteScalar("select (SELECT DocDepartmentID FROM DOCTOR_MASTER WHERE DoctorID=pmh.DoctorID GROUP BY DoctorID) from patient_medical_history pmh where TransactionID='" + ViewState["TID"].ToString() + "'");
            string DoctorID = StockReports.ExecuteScalar("select DoctorID from patient_medical_history pmh where TransactionID='" + ViewState["TID"].ToString() + "'");

            string isApp=StockReports.ExecuteScalar("select Approved from emr_ipd_details WHERE TransactionID='" + ViewState["TID"] + "'");
            if (isApp == "1")
            {
                btnApprove.Text = "Not Approve";
                btnAddItem.Visible = false;
            }
            else
            {
                btnApprove.Text = "Approve";
                btnAddItem.Visible = true;
            }
            //if (Session["ID"].ToString() == "LSHHI123" || Session["ID"].ToString() == "EMP001")
            //{
                rdbTemplate.Enabled = true;
                btnDelete.Visible = true;
            //}
            //else
            //{
            //    rdbTemplate.Enabled = false;
            //    btnDelete.Visible = false;
            //}
         //   DataTable dtchk = StockReports.GetDataTable("SELECT isapprove FROM  d_ApprovalAuthorization WHERE employeeid='" + Session["Id"].ToString() + "'  AND DoctorID='" + DoctorID + "'");
            DataTable dtchk = StockReports.GetDataTable("SELECT isapprove FROM  d_ApprovalAuthorization WHERE employeeid='" + Session["Id"].ToString() + "' and Isactive=1 ");
          
            if (dtchk != null && dtchk.Rows.Count > 0)
            {
                if (dtchk.Rows[0]["isapprove"].ToString() == "1" && isApp!="1")
                    btnApprove.Visible = true;
            }
            //else
            //{
            //    string Msg = "You Are Not Authorised To Generate Discharge Report...";
            //    Response.Redirect("../IPD/PatientBillMsg.aspx?msg=" + Msg);
            //}
            DischargePrepared();
            CreateTable();
           
            //LoadTemplates(ddlHeader.SelectedItem.Value);
            BindDetails(ViewState["TID"].ToString());
            BindApprovalDoctor();
            BindDischargeType();
            bindUser();
            BindDepartment();

        }

       
    }

    private void BindDepartment()
    {
        DataTable dt = StockReports.GetDataTable("SELECT Distinct tm.NAME as Department,tm.ID FROM type_master tm inner join Doctor_master Dm on Dm.DocDepartmentID=tm.ID  WHERE TypeID =5 ORDER BY tm.NAME");

        ddlDepartment.DataSource = dt;
        ddlDepartment.DataTextField = "Department";
        ddlDepartment.DataValueField = "ID";
        ddlDepartment.DataBind();
        ddlDepartment.Items.Insert(0, "Select");
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
            ddlHeader.Attributes.Add("disabled", "disabled");
            lblMsg.Text = "Please Add First Discharge Type and Discharge Diagnosis";
            //    btnPrint.Visible = false;
        }
    }
    private void DischargePrepared()
    {
        string Header = StockReports.ExecuteScalar("select Header FROM emr_ipd_details ed  where ed.TransactionID ='" + ViewState["TID"].ToString() + "'");
        if (Header != "")
            btnPrint.Visible = true;
        else
            btnPrint.Visible = false;
    }
    protected void btnAddItem_Click(object sender, EventArgs e)
    {
        if (ddlHeader.SelectedIndex == 0)
        {
            lblMsg.Text = "Please Select Header";
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
            int count = Util.GetInt(StockReports.ExecuteScalar("Select Count(*) from d_discharge_template Where  Temp_Name='" + txtTempHeader.Text.Trim() + "' AND HeaderID='" + ddlHeader.SelectedValue + "' and IF(IsShared=0,EmpId='"+ddlEmployee.SelectedValue.ToString()+"',IsShared=1)"));
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
                    rdbTemplate.SelectedIndex = 2;
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
                rdbTemplate.SelectedIndex = 2;
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
                string strQuery = "delete from emr_DRDetail where TransactionID='" + ViewState["TID"].ToString() + "' and Header_Id=" + ReportTypeHeaderID;
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
                    if (ddlTemplates.SelectedIndex > 0)
                    {
                        int count = Util.GetInt(StockReports.ExecuteScalar("Select Count(*) from d_discharge_template Where    ID = '" + ddlTemplates.SelectedItem.Value + "' AND HeaderID='" + ddlHeader.SelectedValue + "' and EmpId='" + ddlEmployee.SelectedValue.ToString() + "' "));
                        if (count==0)
                        {
                            lblMsg.Text = "You can Update only Your Templates";
                            return ;
                        }
                        else
                        {
                            strQuery = "delete from d_discharge_template where Headerid='" + row["Header_Id"].ToString() + "' And ID = '" + ddlTemplates.SelectedItem.Value + "' ";
                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);
                            strQuery = "Insert into d_discharge_template(Headerid,Template_Value,Temp_Name,CreatedBy,EmpId,IsShared) values(" + row["Header_Id"].ToString() + ",'" + row["Value"].ToString().Replace("'", "''") + "','" + row["TempHeadName"].ToString().Trim() + "','" + Session["ID"].ToString() + "','" + ddlEmployee.SelectedValue.ToString() + "'," + chkIsSahred.Checked + ")";
                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);
                        }

                       
                    }
                }
                if (row["TempFlag"].ToString() == "2" && row["TempHeadName"].ToString().Trim() != "")
                {
                    strQuery = "Insert into d_discharge_template(Headerid,Template_Value,Temp_Name,CreatedBy,EmpId,IsShared) values(" + row["Header_Id"].ToString() + ",'" + row["Value"].ToString().Replace("'", "''") + "','" + row["TempHeadName"].ToString().Trim() + "','" + Session["ID"].ToString() + "','" + ddlEmployee.SelectedValue.ToString() + "'," + chkIsSahred.Checked + ")";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);
                }
                if (row["TempFlag"].ToString() == "0")
                {
                    strQuery = "delete from emr_DRDetail where TransactionID='" + ViewState["TID"].ToString() + "' and Header_Id='" + row["Header_Id"].ToString() + "' ";
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);
                    //Insert DR Detail
                    strQuery = "insert into emr_DRDetail(TransactionID,Header_Id,HeaderName,Detail,UserID)values('" + ViewState["TID"].ToString() + "'," + row["Header_Id"].ToString() + ",'" + row["HeaderName"].ToString() + "','" + row["Value"].ToString().Replace("'", "''") + "','" + Util.GetString(Session["ID"]) + "')";
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);
                    
                }
            }
            lblMsg.Text = "Record Saved Successfully";
            Tranx.Commit();
            LoadTemplates(ddlHeader.SelectedItem.Value);
            BindDetails(ViewState["TID"].ToString());
            if (dtHeader.Rows.Count > 0)
            {
                btnPrint.Visible = true;
            }
            else
            {
                btnPrint.Visible = false;
            }
            txtDetail.Text = "";
            rdbTemplate.SelectedIndex = 2;
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
    protected void ddlHeader_SelectedIndexChanged(object sender, EventArgs e)
    {

        LoadTemplates(ddlHeader.SelectedItem.Value);
    }
    protected void ddlTemplates_SelectedIndexChanged(object sender, EventArgs e)
    {
        //if (txtDetail.Text.Trim() != "")
        //{
        //    txtDetail.Text = StockReports.ExecuteScalar("Select Template_Value from d_discharge_template Where ID='" + ddlTemplates.SelectedItem.Value + "' AND Temp_Name<>'' order by Temp_Name");
        //    //txtDetail.Text = txtDetail.Text + Environment.NewLine + ddlTemplates.SelectedItem.Value.Split('#')[0];
        //    //ddlTemplates.txtDetail.Text = ddlTemplates.SelectedItem.Value;
        //}
        //else
        if (ddlTemplates.SelectedItem.Value != "0")
        {
            txtDetail.Text = "";
            txtDetail.Text = StockReports.ExecuteScalar("Select Template_Value from d_discharge_template Where ID='" + ddlTemplates.SelectedItem.Value + "' AND Temp_Name<>'' order by Temp_Name");

           string f = StockReports.ExecuteScalar("Select IsShared from d_discharge_template Where ID='" + ddlTemplates.SelectedItem.Value + "' AND Temp_Name<>'' order by Temp_Name");
           
            
            chkIsSahred.Checked = Util.GetBoolean(f);
        }
    }

    protected void btnPrint_Click(object sender, EventArgs e)
    {
      //  ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/EMR/DischargeReportNew.aspx?TID=" + ViewState["TID"].ToString() + "&Status=" + ViewState["Status"].ToString() + "&ReportType=" + rbtnFormat.SelectedItem.Text + "');", true);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/EMR/printDischargeReport_pdf.aspx?TID=" + ViewState["TID"].ToString() + "&Status=" + ViewState["Status"].ToString() + "&ReportType=" + rbtnFormat.SelectedItem.Text + "');", true);
    }

    private void LoadHeaders(string Department)
    {
        string str = "";
        StringBuilder sb =new StringBuilder();
        //string Dept = StockReports.ExecuteScalar("select count(*) from d_Header_DeptWise where Department ='" + Department + "'");
        //if (Dept == "0")
        //{
        //    str = "select HeaderName,Header_Id from d_discharge_header WHERE IsActive=1 order by SeqNo";
        //}
        //else
        //{
        //    str = "SELECT HeaderName,Header_Id FROM d_Header_DeptWise WHERE department='" + Department + "' and IsActive=1 order by SeqNo+0";
        //}
         //str = "select HeaderName,Header_Id from d_discharge_header WHERE IsActive=1 order by SeqNo";
      //  string str = "SELECT HeaderName,Header_Id FROM d_Header_DeptWise WHERE department='" + Department + "' and IsActive=1 order by SeqNo";
         sb.Append(" SELECT ddh.HeaderName,ddh.Header_Id FROM d_setheader_Mandatory shm ");
         sb.Append(" INNER JOIN employee_master em ON em.EmployeeID= shm.CreatedBy ");
         sb.Append(" INNER JOIN d_discharge_header ddh ON ddh.Header_Id= shm.HeaderId ");
         sb.Append(" WHERE shm.DepartmentID='" + Department + "' AND shm.DischargeName='" + lbldischargeType.Text.Trim() + "' AND shm.Isactive=1 ");
         DataTable dt = StockReports.GetDataTable(sb.ToString()).Copy();
        ddlHeader.DataSource = dt;
        ddlHeader.DataTextField = "HeaderName";
        ddlHeader.DataValueField = "Header_Id";
        ddlHeader.DataBind();
        ddlHeader.Items.Insert(0, "Select");
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

        
        lblMsg.Text = "";
        StringBuilder sb = new StringBuilder();

        //sb.Append("Select TRIM(Temp_Name)Temp_Name,ID AS Template_Value from d_discharge_template Where Headerid='" + TempHeaderID + "'  order by Temp_Name ");

        //sb.Append("Select TRIM(Temp_Name)Temp_Name,ID AS Template_Value from d_discharge_template Where Headerid='" + TempHeaderID + "' AND Temp_Name<>'' order by Temp_Name ");

      //  sb.Append("Select TRIM(Temp_Name)Temp_Name,ID AS Template_Value from d_discharge_template Where Headerid='" + TempHeaderID + "' order by Temp_Name ");
        sb.Append("Select TRIM(Temp_Name)Temp_Name,ID AS Template_Value from d_discharge_template Where Headerid='" + TempHeaderID + "' and  IF(IsShared=0,EmpId='"+ddlEmployee.SelectedValue.ToString()+"',IsShared=1) order by Temp_Name ");

       
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlTemplates.DataSource = dt;
            ddlTemplates.DataTextField = "Temp_Name";
            ddlTemplates.DataValueField = "Template_Value"; 
            ddlTemplates.DataBind();
            ddlTemplates.Items.Insert(0, new ListItem("Select", "0"));
            //txtDetail.Text = ddlTemplates.SelectedItem.Value.Split('#')[0];
            // txtFreeText.Text = ddlTemplates.SelectedItem.Value;
        }
        else
        {
            ddlTemplates.Items.Clear();
            //lblMsg.Text = "No Templates Available under " + ddlHeader.SelectedItem.Text;
            ddlTemplates.DataSource = null;
            ddlTemplates.DataBind();
            txtDetail.Text = "";
        }
    }


    private void BindDetails(string TransactionID)
    {
        string str = "SELECT Header_ID Header_ID,HeaderName,Detail Value,''TempHeadName,0 TempFlag,Approved FROM emr_DRDetail edr INNER JOIN emr_ipd_details eid ON eid.TransactionID=edr.TransactionID WHERE edr.TransactionID='" + TransactionID + "'";
        DataTable dtHeader = StockReports.GetDataTable(str);
        if (dtHeader.Rows.Count > 0)
        { ViewState["dtHeader"] = dtHeader; }
        grdHeader.DataSource = dtHeader;
        grdHeader.DataBind();
    }


    public void DeleteData(string ReportTypeHeaderID)
    {
        dtHeader = (DataTable)ViewState["dtHeader"];

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            string strQuery = "";

            //Checking if Patient's discharge report already exist
            strQuery = "delete from  Discharge_Report where Header='" + ReportTypeHeaderID + "' and TransactionID='" + ViewState["TID"].ToString() + "'";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);

            lblMsg.Text = "Record Deleted Successfully";
            Tranx.Commit();

            if (dtHeader.Rows.Count > 0)
            {
                btnPrint.Visible = true;
            }
            else
            {
                btnPrint.Visible = false;
            }

            txtDetail.Text = "";
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


    

   

    protected void btnSave_Click(object sender, EventArgs e)
    {
        saveData();
    }

    protected void btnApprove_Click(object sender, EventArgs e)
    {


        string ApprovedDoctorID = StockReports.ExecuteScalar(" SELECT de.`DoctorID` FROM `doctor_employee` de WHERE de.`Employeeid`='" + Session["ID"].ToString() + "' LIMIT 1  ");
            if (btnApprove.Text == "Approve")
            {
                if (ddlApproved.SelectedValue != "Select")
                {
                    if (StockReports.ExecuteDML("UPDATE emr_ipd_details SET Approved=1,AppDoctorID='" + ApprovedDoctorID + "' WHERE TransactionID='" + ViewState["TID"] + "'"))
                    {
                        lblMsg.Text = "Approved";
                        btnApprove.Text = "Not Approve";
                        btnApprove.Visible = false;
                        BindDetails(ViewState["TID"].ToString());
                        btnAddItem.Visible = false;
                    }
                }
                else {
                    lblMsg.Text = "Please Select Approved By";
                }
            }
        
        else
        {
            if (StockReports.ExecuteDML("UPDATE emr_ipd_details SET Approved=0,AppDoctorID='' WHERE TransactionID='" + ViewState["TID"] + "'"))
            {
                lblMsg.Text = "Not Approved";
                btnApprove.Text = "Approve";
                BindDetails(ViewState["TID"].ToString());
                btnAddItem.Visible = true;
            }
        }
        
    }
    protected void grdHeader_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblApproved")).Text != "0")
            {
                ((ImageButton)e.Row.FindControl("imbDelete")).Enabled = false;
                ((ImageButton)e.Row.FindControl("imbModify")).Enabled = false;
                ((ImageButton)e.Row.FindControl("imbModify")).ToolTip = "Report Approved";
                ((ImageButton)e.Row.FindControl("imbDelete")).ToolTip = "Report Approved";
            }
        }
    }
    private void BindApprovalDoctor()
    {
        DataTable dt = StockReports.GetDataTable(" SELECT CONCAT(dm.Title,' ',dm.Name)Name,dm.DoctorID FROM d_ApprovalAuthorization dapp INNER JOIN doctor_master dm ON dm.DoctorID=dapp.DoctorID WHERE dapp.EmployeeId='" + Session["ID"].ToString() + "'  AND dapp.IsActive=1");
        if (dt.Rows.Count > 0)
        {
            ddlApproved.DataSource = dt;
            ddlApproved.DataTextField = "Name";
            ddlApproved.DataValueField = "DoctorID";
            ddlApproved.DataBind();
            ddlApproved.Items.Insert(0, "Select");
        }
        else
        {
            ddlApproved.Items.Insert(0, "Select");
        }
    }
    protected void btnDelete_Click(object sender, EventArgs e)
    {
        if (ddlTemplates.SelectedValue != "")
        {
            StockReports.ExecuteScalar(" DELETE FROM d_discharge_template WHERE id='" + ddlTemplates.SelectedItem.Value + "' ");
            LoadTemplates(ddlHeader.SelectedItem.Value);
        }
        else
        {
            lblMsg.Text = "Please Select The Header And Template";
        }
    }

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

    protected void ddlDepartment_SelectedIndexChanged(object sender, EventArgs e)
    {
       
        LoadHeaders(ddlDepartment.SelectedItem.Value);  
    }
}