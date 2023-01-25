using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_MRD_FileIssue : System.Web.UI.Page
    {
    private int total = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            if (Session["LoginType"] == null && Session["UserName"] == null)
            {
                Response.Redirect("~/Default.aspx");
            }
            else
            {
                string requestID = Request.QueryString["RequestID"].ToString();
       

                string Count = StockReports.ExecuteScalar("Select IsIssue from mrd_filerequisition where MRDRequisitionID='" + Request.QueryString["RequestID"].ToString() + "'");
                if (Count == "0")
                {
                    EntryDate1.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                    EntryTime1.Text = System.DateTime.Now.ToString("hh:mm tt");

                    bindDays();
                    bindHours();
                    string type = Request.QueryString["Type"].ToString();
                    ViewState["Type"] = type.ToString();
                    ViewState["ID"] = Session["ID"];
                    string RequestedID = "";

                    {
                        string PatientID = Request.QueryString["PatientID"];
                        ViewState["PatientID"] = PatientID.ToString();
                        string TransactionID = "";
                        //if (ViewState["Type"].ToString() == "IPD")
                        //{
                        //    if (Request.QueryString["TID"] == null)
                        {
                            //btnSave.Enabled = false;
                            //return;
                        }
                        TransactionID = Request.QueryString["TID"];
                        RequestedID = Request.QueryString["RequestID"];
                        ViewState["TID"] = TransactionID.ToString();
                        BindFileDetail(TransactionID, PatientID);
                        BindPatientDetail(TransactionID, PatientID);
                        btnSave.Enabled = true;
                        if (ddlFileID.SelectedItem == null)
                        {
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('No Files To Issue',function(){});", true);
                            return;
                        }
                        else
                        {
                            BindFileDoc(ddlFileID.SelectedItem.Value.ToString(), TransactionID, PatientID);
                            BIndPersonToIssue(ddlFileID.SelectedItem.Value.ToString(), PatientID);
                        }

                        //}
                        //else
                        //{
                        //    BindFileDetail(TransactionID, PatientID);
                        //    BindPatientDetail(TransactionID, PatientID);
                        //    btnSave.Enabled = true;
                        //    if (ddlfile.SelectedItem == null)
                        //    {
                        //        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM117','" + lblMsg.ClientID + "');", true);
                        //        return;
                        //    }
                        //    else
                        //    {
                        //        BindFileDoc(ddlfile.SelectedItem.Value.ToString(), TransactionID, PatientID);
                        //    }
                        //}
                        BindIssueTo(ddlIssueType.SelectedItem.Text);

                        lblV3.Visible = false;
                        lblV4.Visible = false;
                    }
                    EntryDate1.Attributes.Add("readonly", "readonly");
                    calucDate.EndDate = DateTime.Now;
                    
                    BindRequisitionDetail(RequestedID);
                }
                else
                {
                    Response.Redirect("FileReceive.aspx?TID=" + Request.QueryString["TID"] + " &PatientId=" + Request.QueryString["PatientID"] + "&RequestID=" + Request.QueryString["RequestID"] + "&Type=IPD");
                    lblMsg.Text = "File Already Issued";
                    btnSave.Visible = false;
                }
            }
        }
    }
    public void bindDays()
    {
        for (int index = 1; index <= 31; index++)
        {
            ddldays.Items.Add(index.ToString());

        }
        ddldays.SelectedIndex = 1;
    }
    public void bindHours()
    {
        for (int index = 1; index <= 24; index++)
        {
            ddlHours.Items.Add(index.ToString("00"));

        }
        ddlHours.Items.Insert(0, "00");
    }
    public void BindFileDoc(string FileID, string TransactionID, string PatientID)
    {


        StringBuilder sb = new StringBuilder();
        //if (ViewState["Type"].ToString() == "IPD")
        //{
            pnlIPD.Visible = true;

            sb.Append("     SELECT mfd.FileDetID,mdm.Name,mfd.FileID,mfd.DocumentID,mfi.IssueType,mfi.Issue_ToType,mfi.Issue_To,Issue_To_Name,IF(mfi.department='SELECT','',IFNULL(mfi.Department,''))department, ");
            sb.Append("     (SELECT NAME FROM employee_master WHERE employeeid=mfi.Issue_By)EmpName,IF(mfi.IsIssued=1,'Issued','Not Issued')STATUS,IF(IFNULL(mfi.IsIssued,0)=0,'false','true')IsIssued,DATE_FORMAT(mfi.IssueDate,'%d-%b-%Y %h:%i %p')IssueDate  FROM mrd_file_master mfm  ");
            sb.Append("     INNER JOIN mrd_file_detail mfd ON mfm.FileID=mfd.FileID  ");
            sb.Append("     INNER JOIN mrd_document_master mdm ON mfd.DocumentID=mdm.DocumentID ");
            sb.Append("     left JOIN mrd_file_issue mfi ON mfd.filedetid=mfi.filedetid  AND mfi.IsReturn=0   ");
            sb.Append("     WHERE mfm.TransactionID='" + TransactionID + "' AND mfd.FileID=" + FileID + " and mfd.status='A' AND mdm.IsActive=1 order by mdm.Name ");
      //  }
        //else
        //{
        //    pnlOpd.Visible = true;
        //    sb.Append("     SELECT mfd.FileDetID,mdm.Name,mfd.FileID,mfd.DocID,mfi.IssueType,mfi.Issue_ToType,mfi.Issue_To,Issue_To_Name,IF(mfi.department='SELECT','',IFNULL(mfi.Department,''))department, ");
        //    sb.Append("     (SELECT NAME FROM employee_master WHERE employee_id=mfi.Issue_By)EmpName,IF(mfi.IsIssued=1,'Issued','Not Issued')STATUS,IF(IFNULL(mfi.IsIssued,0)=0,'false','true')IsIssued,DATE_FORMAT(mfi.IssueDate,'%d-%b-%Y %h:%i %p')IssueDate  FROM mrd_file_master mfm  ");
        //    sb.Append("     INNER JOIN mrd_file_detail mfd ON mfm.FileID=mfd.FileID  ");
        //    sb.Append("     INNER JOIN mrd_document_master mdm ON mfd.DocID=mdm.DocID ");
        //    sb.Append("     left JOIN mrd_file_issue mfi ON mfd.filedetid=mfi.filedetid  AND mfi.IsReturn=0   ");
        //    sb.Append("     WHERE PatientID='" + PatientID + "' AND mfd.FileID=" + FileID + " and mfd.status='A' AND mdm.IsActive=1 order by mdm.Name ");
        //}

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt != null && dt.Rows.Count > 0)
        {
            grdDocs.DataSource = dt;
            grdDocs.DataBind();



        }
        else
        {
            btnSave.Enabled = false;

        }
    }
    public void BindFileDetail(string TransactionID, string PatientID)
    {
        string sql = "";

        //if (ViewState["Type"].ToString() == "IPD")
        //{
            sql = " select am.Name AlmName, FileID, PatientID, TransactionID, BillNo, date_format(BillDate,'%d-%b-%Y')BillDate,  date_format(DischargeDateTime,'%d-%b-%Y')DischargeDateTime, fm.RmID, am.AlmID, ShelfNo, CurPos, Narration, fm.UserID, IsIssued,  " +
              " date_format(fm.EntDate,'%d-%b-%Y')EntDate from mrd_file_master fm inner join mrd_almirah_master am on fm.AlmID = am.AlmID where fm.TransactionID='" + TransactionID+ "' ";
       // }
        //else
        //{
        //    sql = " select am.Name AlmName, FileID, PatientID, fm.RmID, am.AlmID, ShelfNo, CurPos, Narration, fm.UserID, IsIssued,  " +
        //                 " date_format(fm.EntDate,'%d-%b-%Y')EntDate from mrd_file_master fm inner join mrd_almirah_master am on fm.AlmID = am.AlmID where fm.PatientID='" + PatientID + "' ";
        //}
        DataTable dt = StockReports.GetDataTable(sql);

        if (dt != null && dt.Rows.Count > 0)
        {
            //if (ViewState["Type"].ToString() == "IPD")
            //{
                ddlFileID.DataSource = dt;
                ddlFileID.DataTextField = "FileID";
                ddlFileID.DataValueField = "FileID";
                ddlFileID.DataBind();


               
                string isissued = Util.GetString(dt.Rows[0]["Isissued"]);
                if (isissued == "1")
                {
                    lblPosition.Text = "";
                }
                else
                {
                    lblPosition.Text = Util.GetString(dt.Rows[0]["CurPos"]);
                }
                lblAlmirah.Text = Util.GetString(dt.Rows[0]["AlmName"]);

                lblShelf.Text = Util.GetString(dt.Rows[0]["ShelfNo"]);

                lblFileRegisterDate.Text = Util.GetString(dt.Rows[0]["EntDate"]);
                lblroomid.Text = Util.GetString(dt.Rows[0]["RmID"]);
                lblAlmid.Text = Util.GetString(dt.Rows[0]["AlmID"]);
           // }
            //else
            //{
            //    ddlfile.DataSource = dt;
            //    ddlfile.DataTextField = "FileID";
            //    ddlfile.DataValueField = "FileID";
            //    ddlfile.DataBind();


               
            //    string isissued = Util.GetString(dt.Rows[0]["Isissued"]);
            //    if (isissued == "1")
            //    {
            //        lblpositionno.Text = "";
            //    }
            //    else
            //    {
            //        lblpositionno.Text = Util.GetString(dt.Rows[0]["CurPos"]);
            //    }
            //    lblrack.Text = Util.GetString(dt.Rows[0]["AlmName"]);

            //    lblshelfid.Text = Util.GetString(dt.Rows[0]["ShelfNo"]);

            //    lblFileRegisterDate0.Text = Util.GetString(dt.Rows[0]["EntDate"]);
            //    lblroom.Text = Util.GetString(dt.Rows[0]["RmID"]);
            //    lblalm.Text = Util.GetString(dt.Rows[0]["AlmID"]);
            //}
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM117','" + lblMsg.ClientID + "');", true);
            return;

        }
    }
    public void BindPatientDetail(string TransactionID, string PatientID)
    {
        string sql = "";
        //if (ViewState["Type"].ToString() == "IPD")
        //{
            pnlIPD.Visible = true;
            sql = " select pmh.PatientID,pm.PName,pmh.TransactionID,pmh.BillNo, " +
                                  " if(pm.DOB='0001-01-01',pm.Age,date_format(pm.DOB,'%d-%b-%Y')) AGE,pmh.MLC_NO, " +
                                  " date_format(pmh.DateOfAdmit,'%d-%b-%Y')DateOfAdmit ,  " +
                                  " if(pmh.DateOfDischarge='0001-01-01','', date_format(pmh.DateOfDischarge,'%d-%b-%Y'))DateOfDischarge " +
                                   " from patient_master pm  " +
                                 " inner join patient_medical_history pmh on pm.PatientID = pmh.PatientID  " +
                                  " where pmh.TransactionID='" + TransactionID + "'";

       // }
        //if (ViewState["Type"].ToString() == "OPD" || ViewState["Type"].ToString() == "General")
        //{
        //    pnlOpd.Visible = true;
        //    sql = " SELECT  pm.PatientID,pm.PName,pm.Age,mfm.* FROM patient_master pm INNER JOIN mrd_file_master mfm ON mfm.PatientID = pm.PatientID   WHERE pm.PatientID='" + PatientID + "'";
        //}
        DataTable dt = StockReports.GetDataTable(sql);

        if (dt != null && dt.Rows.Count > 0)
        {
            //if (ViewState["Type"].ToString() == "IPD")
            //{
                lblBillNo.Text = Util.GetString(dt.Rows[0]["BillNo"]);
                lblCRNumber.Text = TransactionID.Replace("ISHHI", "");
                lblDischargeDate.Text = Util.GetString(dt.Rows[0]["DateOfDischarge"]);
                lblMLCNo.Text = Util.GetString(dt.Rows[0]["MLC_NO"]);
                lblPatientName.Text = Util.GetString(dt.Rows[0]["PName"]);
            //}
            //else
            //{
            //    lblMrno.Text = Util.GetString(dt.Rows[0]["PatientID"]);
            //    lblpName.Text = Util.GetString(dt.Rows[0]["Pname"]);
            //    lblshelfid.Text = Util.GetString(dt.Rows[0]["Shelfno"]);

            //}


        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);

        }


    }

    public bool ChechFileStatus(int FileID)
    {

        string sql = "select IsIssued from mrd_file_master where FileID='" + FileID + "'";
        int IsIssued = Util.GetInt(StockReports.ExecuteScalar(sql));
        if (IsIssued == 1)
            return false;
        return true;

    }

    private void FileIssue()
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        string TID = "";
        string patientid = ViewState["PatientID"].ToString();
        try
        {
            string AvgrtnTime = ddldays.SelectedItem.Text.ToString() + " " + "Days" + " " + ddlHours.SelectedItem.Text.ToString() + " " + "Hours";
            foreach (GridViewRow gr in grdDocs.Rows)
            {

                string totalgridrows = grdDocs.Rows.Count.ToString(); int HardCopyChecked = 0, SoftCopyChecked = 0;
                if (chkHardCopy.Checked)
                {
                    HardCopyChecked = 1;
                }
                if (chkSoftCopy.Checked)
                {
                    SoftCopyChecked = 1;
                }

                if (((CheckBox)gr.FindControl("chkIssueStatus")).Checked == true)
                {

                    string sql = "";
                    string abc = rdbIssueType.SelectedValue;
                   
                    //if (ViewState["Type"].ToString() == "IPD")
                    //{
                        if (rdbIssueType.SelectedItem.Text.ToString().ToUpper() == "INTERNAL")
                        {
                            if (ddlIssueTo.SelectedItem.Value.ToString() == "SELECT")
                            {
                                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM014','" + lblMsg.ClientID + "');", true);
                                return;
                            }
                            sql = "insert into mrd_file_issue (FileID,FileDetID, Issue_To,Department, Issue_ToType, Issue_By, IssueDate, Avg_ReturnTime, Remarks, UserID,DocID,IsIssued,Issue_To_Name,IssueType,CentreID,RequestedID,HardCopy,SoftCopy) values " +
                           "('" + ((Label)gr.FindControl("lblFileID")).Text.ToString() + "','" + ((Label)gr.FindControl("lblFileDetID")).Text.ToString() + "', '" + ddlIssueTo.SelectedItem.Value + "','" + cmbDept.SelectedItem.Text.ToString() + "', '" + ddlIssueType.SelectedItem.Text + "', '" + Util.GetString(ViewState["ID"]) + "', '" + Util.GetDateTime(EntryDate1.Text).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(EntryTime1.Text).ToString("HH:mm:ss") + "', '" + AvgrtnTime + "', '" + txtRemarks.Text.Trim() + "', '" + Util.GetString(ViewState["ID"]) + "','" + ((Label)gr.FindControl("lblDocID")).Text.ToString() + "',1,'" + ddlIssueTo.SelectedItem.Text + "','" + rdbIssueType.SelectedItem.Text.ToString() + "'," + Session["CentreID"] + ",'" + Request.QueryString["RequestID"].ToString() + "','" + HardCopyChecked + "','" + SoftCopyChecked + "') ";

                        }
                        else
                        {
                            sql = "insert into mrd_file_issue (FileID,FileDetID,department, Issue_To, Issue_ToType, Issue_By, IssueDate, Avg_ReturnTime, Remarks, UserID,DocID,IsIssued,Issue_To_Name,IssueType,CentreID,RequestedID,HardCopy,SoftCopy) values " +
                           "('" + ((Label)gr.FindControl("lblFileID")).Text.ToString() + "','" + ((Label)gr.FindControl("lblFileDetID")).Text.ToString() + "', '" + txtIssueDeptExt.Text.ToString() + "', '" + txtissueTo.Text.ToString() + "', '', '" + Util.GetString(ViewState["ID"]) + "', '" + Util.GetDateTime(EntryDate1.Text).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(EntryTime1.Text).ToString("HH:mm:ss") + "', '" + AvgrtnTime + "', '" + txtRemarks.Text.Trim() + "', '" + Util.GetString(ViewState["ID"]) + "','" + ((Label)gr.FindControl("lblDocID")).Text.ToString() + "',1,'" + txtissueTo.Text.ToString() + "','" + rdbIssueType.SelectedItem.Text.ToString() + "'," + Session["CentreID"] + ",'" + Request.QueryString["RequestID"].ToString() + "','" + HardCopyChecked + "','" + SoftCopyChecked + "') ";

                        }
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
                    //}
                    //else
                    //{
                    //    if (RadioButtonList1.SelectedItem.Text.ToString().ToUpper() == "INTERNAL")
                    //    {
                    //        if (ddlIssueTo.SelectedItem.Value.ToString() == "SELECT")
                    //        {
                    //            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM014','" + lblMsg.ClientID + "');", true);
                    //            return;
                    //        }
                    //        sql = "insert into mrd_file_issue (FileID,FileDetID, Issue_To,Department, Issue_ToType, Issue_By, IssueDate, Avg_ReturnTime, Remarks, UserID,DocID,IsIssued,Issue_To_Name,IssueType) values " +
                    //       "('" + ((Label)gr.FindControl("lblFileID")).Text.ToString() + "','" + ((Label)gr.FindControl("lblFileDetID")).Text.ToString() + "', '" + ddlIssueTo.SelectedItem.Value + "','" + cmbDept.SelectedItem.Text.ToString() + "', '" + ddlIssueType.SelectedItem.Text + "', '" + Util.GetString(ViewState["ID"]) + "', '" + Util.GetDateTime(EntryDate1.Text).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(EntryTime1.Text).ToString("HH:mm:ss") + "', '" + AvgrtnTime + "', '" + txtRemarks.Text.Trim() + "', '" + Util.GetString(ViewState["ID"]) + "','" + ((Label)gr.FindControl("lblDocID")).Text.ToString() + "',1,'" + ddlIssueTo.SelectedItem.Text + "','" + RadioButtonList1.SelectedItem.Text.ToString() + "') ";
                    //    }
                    //    else
                    //    {
                    //        sql = "insert into mrd_file_issue (FileID,FileDetID,department, Issue_To, Issue_ToType, Issue_By, IssueDate, Avg_ReturnTime, Remarks, UserID,DocID,IsIssued,Issue_To_Name,IssueType) values " +
                    //       "('" + ((Label)gr.FindControl("lblFileID")).Text.ToString() + "','" + ((Label)gr.FindControl("lblFileDetID")).Text.ToString() + "', '" + txtIssueDeptExt.Text.ToString() + "', '" + txtissueTo.Text.ToString() + "', '', '" + Util.GetString(ViewState["ID"]) + "', '" + Util.GetDateTime(EntryDate1.Text).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(EntryTime1.Text).ToString("HH:mm:ss") + "', '" + AvgrtnTime + "', '" + txtRemarks.Text.Trim() + "', '" + Util.GetString(ViewState["ID"]) + "','" + ((Label)gr.FindControl("lblDocID")).Text.ToString() + "',1,'" + txtissueTo.Text.ToString() + "','" + RadioButtonList1.SelectedItem.Text.ToString() + "') ";

                    //    }
                    //    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);

                    //}
                    sql = "select file_issue_id from mrd_file_issue where FileID='" + ((Label)gr.FindControl("lblFileID")).Text.ToString() + "' and IsReturn =0 order by file_issue_id desc";
                    int file_issue_id = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sql));

                    sql = "update mrd_file_detail set file_issue_id=" + file_issue_id + " , IsIssued = 1 where  CentreID="+Session["CentreID"]+" AND  FileDetID = " + ((Label)gr.FindControl("lblFileDetID")).Text.ToString();
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
                    sql = "UPDATE mrd_filerequisition SET IsIssue=1, IssueBy='" + Session["ID"].ToString() + "',IssueDate=NOW(),IssueIPAddress='" + All_LoadData.IpAddress() + "' WHERE MRDRequisitionID='" + Request.QueryString["RequestID"].ToString() + "'";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
                }

                if(chkHardCopy.Checked==true)
                {
                    if (((CheckBox)gr.FindControl("chkIssueStatus")).Checked == true)
                    {
                        string sql = "";
                        total = total + 1;
                        string totals = total.ToString();
                        if (totals == totalgridrows)
                        {
                            if (ViewState["Type"].ToString() == "IPD")
                            {
                                sql = " update mrd_location_master set CurPos=CurPos -1 where RmID='" + lblroomid.Text + "' and AlmID='" + lblAlmid.Text + "' and ShelfNo='" + lblShelf.Text.Split('$')[0] + "' ";
                            }
                            else
                            {
                                sql = " update mrd_location_master set CurPos=CurPos -1 where RmID='" + lblroom.Text + "' and AlmID='" + lblalm.Text + "' and ShelfNo='" + lblshelfid.Text.Split('$')[0] + "' ";
                            }
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);

                        }
                    }
                }
            }


            StringBuilder sb = new StringBuilder();
            //if (ViewState["Type"].ToString() == "IPD")
            //{
                TID = ViewState["TID"].ToString();
                sb.Append("   SELECT COUNT(*) FROM mrd_file_master mfm INNER JOIN mrd_file_detail mfd  ");
                sb.Append("   ON mfm.FileID=mfd.FileID INNER JOIN mrd_document_master mdm ON mdm.DocumentID=mfd.DocumentID WHERE mfm.TransactionID='" + TID + "' AND mfd.FileID=" + ddlFileID.SelectedItem.Value + " ");
                sb.Append("  AND mfd.IsIssued=0  AND mfd.STATUS='A' AND mdm.IsActive=1");
            //}
            //else
            //{
            //    sb.Append("   SELECT COUNT(*) FROM mrd_file_master mfm INNER JOIN mrd_file_detail mfd  ");
            //    sb.Append("   ON mfm.FileID=mfd.FileID  INNER JOIN mrd_document_master mdm ON mdm.DocID=mfd.DocID WHERE PatientID='" + patientid + "' AND mfd.FileID=" + ddlfile.SelectedItem.Value + " ");
            //    sb.Append("  AND mfd.IsIssued=0  AND mfd.STATUS='A'  AND mdm.IsActive=1");
            //}
            int Count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sb.ToString()));

            if (Count == 0)
            {
                string sql = "";

                int hardcopy = 0;
                if (chkHardCopy.Checked)
                {
                    hardcopy = 1;
                }
                //if (ViewState["Type"].ToString() == "IPD")
                //{
                sql = "update mrd_file_master set  IsIssued = 1, HardCopyIssue='" + hardcopy + "', issuedfrom='" + Session["LoginType"].ToString() + "' where FileID = " + ddlFileID.SelectedItem.Value + " ";
                
               // }
                //else if (ViewState["Type"].ToString() == "OPD")
                //{
                //    sql = "update mrd_file_master set  IsIssued = 1, issuedfrom='OPD' where FileID = " + ddlfile.SelectedItem.Value + " ";
                //}
                //else if (ViewState["Type"].ToString() == "General")
                //{
                //    sql = "update mrd_file_master set  IsIssued = 1, issuedfrom='General' where FileID = " + ddlfile.SelectedItem.Value + " ";
                //}
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
            }
            tnx.Commit();
        }
        catch (Exception Ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(Ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('File Not Issued',function(){});", true);
            return;
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
        string patientid = ViewState["PatientID"].ToString();
        string RequestID = Request.QueryString["RequestID"];
        string TID = "";
        string sql2 = "";
   
        //if (ViewState["Type"].ToString() == "IPD")
        //{
            TID = ViewState["TID"].ToString();
            sql2 = "select * from mrd_file_master where TransactionID='" + TID + "'";
        //}
        //else
        //{
        //    sql2 = "select * from mrd_file_master where PatientID='" + patientid + "'";
        //}
        DataTable dt = StockReports.GetDataTable(sql2);
        int FileID = 0;
        if (dt != null && dt.Rows.Count > 0)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                FileID = Util.GetInt(dt.Rows[i]["FileId"]);
            }
        }
      
        if (!ChechFileStatus(FileID))
        {
            
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('File Already Issued',function(){});", true);
            return;
        }
        FileIssue();
        //if (ViewState["Type"].ToString() == "IPD")
        //{
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('File Issued Successfully',function(){});location.href='FileIssue.aspx?PatientID=" + patientid + "&TID=" + ViewState["TID"].ToString() + " &Type=" + ViewState["Type"].ToString() + " &RequestID=" + RequestID + " '", true);
            TID = ViewState["TID"].ToString();           
       // }
        //else
        //{
        //    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Record Saved Sucessfully');location.href='FileIssue.aspx?PatientID=" + patientid +  " &Type=" + ViewState["Type"].ToString() + "'", true);
        //} 

    }
    protected void ddlIssueType_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindIssueTo(ddlIssueType.SelectedItem.Text);
    }

    private void BindIssueTo(string IssueType)
    {

        if (IssueType == "Doctor")
        {
            cmbDept.Enabled = true;
            BindDept();
            BindDoctor(cmbDept.SelectedItem.Value.ToString());
        }
        else
        {
           
            All_LoadData.bindRole(cmbDept,"Select");
            BindEmployee(cmbDept.SelectedItem.Value.ToString());

        }

    }
    protected void BindDoctor(string DeptID)
    {
        if (DeptID == "0")
        {
            DataView DoctorView = All_LoadData.bindDoctor().DefaultView;
            ddlIssueTo.DataSource = DoctorView;
            ddlIssueTo.DataTextField = "";
            ddlIssueTo.DataValueField = "";
            ddlIssueTo.DataBind();
            ddlIssueTo.Items.Insert(0, new ListItem("Select", "0"));
        }
        else
        {
            DataView DoctorView = All_LoadData.bindDoctor().DefaultView;
            DoctorView.RowFilter = "DocDepartmentID='" + DeptID + "'";
            ddlIssueTo.DataSource = DoctorView;
            ddlIssueTo.DataTextField = "Name";
            ddlIssueTo.DataValueField = "DoctorID";
            ddlIssueTo.DataBind();
            ddlIssueTo.Items.Insert(0, new ListItem("Select", "0"));
        }
    }
    protected void BindEmployee(string RoleID)
    {
        if (RoleID == "0")
        {
            DataTable dt = All_LoadData.LoadEmployee();
            ddlIssueTo.DataSource = dt;
            ddlIssueTo.DataTextField = "NAME";
            ddlIssueTo.DataValueField = "EmployeeID";
            ddlIssueTo.DataBind();
            ddlIssueTo.Items.Insert(0, new ListItem("Select", "0"));
        }
        else
        {
            string sql = "select concat(em.Title,' ',trim(em.Name))Name,em.EmployeeID from employee_master em  inner join f_login fl on em.employee_id=fl.employeeid  where fl.active=1 and fl.roleid='" + RoleID + "' and em.IsActive=1 and em.Title !='----' order by trim(em.Name)";
            DataTable dt = StockReports.GetDataTable(sql);
            ddlIssueTo.DataSource = dt;
            ddlIssueTo.DataTextField = "NAME";
            ddlIssueTo.DataValueField = "EmployeeID";
            ddlIssueTo.DataBind();
            ddlIssueTo.Items.Insert(0, new ListItem("Select", "0"));
        }
    }
    
    public void BindDept()
    {
        try
        {
            DataTable dt = All_LoadData.getDocTypeList(5);
            cmbDept.DataSource = dt;
            cmbDept.DataTextField = "Name";
            cmbDept.DataValueField = "ID";
            cmbDept.DataBind();
            cmbDept.Items.Insert(0, new ListItem("Select", "0"));
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
    }
    protected void btnBack_Click(object sender, EventArgs e)
    {
        Response.Redirect("FileRegisterReport.aspx");
    }

    protected void rdbIssueType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rdbIssueType.SelectedItem.Text.ToUpper() == "INTERNAL")
        {
            lblIssueInt.Visible = true;
            ddlIssueType.Visible = true;
            ddlIssueTo.Visible = true;
            cmbDept.Visible = true;
            lblDepartment.Visible = true;
            lblUser.Visible = true;

            lblIssueExt.Visible = false;
            txtissueTo.Visible = false;
            lblIssueDeptExt.Visible = false;
            txtIssueDeptExt.Visible = false;
            lblDepartmentExt.Visible = false;
            lblV1.Visible = true;
            lblV2.Visible = true;
            lblV3.Visible = false;
            lblV4.Visible = false;
        }
        else
        {
            lblIssueExt.Visible = true;
            txtissueTo.Visible = true;
            lblIssueDeptExt.Visible = true;
            txtIssueDeptExt.Visible = true;
            lblDepartmentExt.Visible = false;

            lblIssueInt.Visible = false;
            ddlIssueType.Visible = false;
            ddlIssueTo.Visible = false;
            cmbDept.Visible = false;
            lblDepartment.Visible = false;
            lblUser.Visible = false;
            lblV1.Visible = false;
            lblV2.Visible = false;
            lblV3.Visible = true;
            lblV4.Visible = true;
        }
    }
    protected void ddlFileID_SelectedIndexChanged(object sender, EventArgs e)
    {
        string TransactionID = "";
        string PatientID = ViewState["PatientID"].ToString();
        if (ViewState["Type"].ToString() == "IPD")
        {

            TransactionID = ViewState["TID"].ToString();
            BindFileDoc(ddlFileID.SelectedItem.Value.ToString(), TransactionID, PatientID);
        }
        else
        {
            BindFileDoc(ddlFileID.SelectedItem.Value.ToString(), TransactionID, PatientID);
        }
    }


    protected void grdDocs_RowDataBound(object sender, GridViewRowEventArgs e)
    {

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblIssueStatus")).Text.ToUpper() == "TRUE")
            {
                e.Row.Attributes.Add("style", "background-color:lightpink");
                btnSave.Enabled = false;
            }
            else
            {
                e.Row.Attributes.Add("style", "background-color:lightgreen");
                btnSave.Enabled = true;
            }

        }

    }

    protected void cmbDept_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlIssueType.SelectedItem.Text == "Doctor")
        {
            BindDoctor(cmbDept.SelectedItem.Value.ToString());
        }
        else
        {
            BindEmployee(cmbDept.SelectedItem.Value.ToString());
        }
    }
    public void BIndPersonToIssue(string File, string PatientId)
    {
        string Str = " SELECT (SELECT CONCAT(Title,' ',NAME) FROM employee_master WHERE employeeID=Issue_To)Issue_To," +
                     " DATE(IssueDate)'Issue Date',IF(HardCopy=1,'Yes','No')HardCopy,IF(softcopy=1,'Yes','NO')softcopy FROM mrd_file_issue " +
                     " WHERE fileId='" + File + "' GROUP BY fileId;";
        DataTable dt = StockReports.GetDataTable(Str);
        // gvPersonToIssue.DataSource = dt;
        //  gvPersonToIssue.DataBind();

    }
    private void BindRequisitionDetail(string RequestedID)
    {
        ddlIssueType.SelectedIndex = 2; //ddlIssueType.Items.IndexOf(ddlIssueType.Items.FindByValue("2".ToString()));
        StringBuilder sb = new StringBuilder();
        DataTable dt = StockReports.GetDataTable("SELECT RequestedBy,RequestedRoleID,AveragereturnDay,AveragereturnHour,HardCopy,SoftCopy,remarks  FROM mrd_filerequisition where MRDRequisitionID='" + RequestedID + "' ");
        if (dt.Rows.Count > 0)
        {
            cmbDept.SelectedIndex = cmbDept.Items.IndexOf(cmbDept.Items.FindByValue(dt.Rows[0]["RequestedRoleID"].ToString()));
            cmbDept.Enabled = false;
            ddlIssueTo.SelectedIndex = ddlIssueTo.Items.IndexOf(ddlIssueTo.Items.FindByValue(dt.Rows[0]["RequestedBy"].ToString()));
            ddlIssueTo.Enabled = false;
            ddldays.SelectedIndex = ddldays.Items.IndexOf(ddldays.Items.FindByValue(dt.Rows[0]["AveragereturnDay"].ToString()));
            ddlHours.SelectedIndex = ddlHours.Items.IndexOf(ddlHours.Items.FindByValue(dt.Rows[0]["AveragereturnHour"].ToString()));
            ddldays.Enabled = false;
            ddlHours.Enabled = false;
            ddlIssueType.Enabled = false;
            chkHardCopy.Checked = Convert.ToBoolean(dt.Rows[0]["HardCopy"]);
            chkSoftCopy.Checked = Convert.ToBoolean(dt.Rows[0]["SoftCopy"]);
            lblHardCopyRemarks.Text = Util.GetString(dt.Rows[0]["remarks"]);
        }
    }


}
