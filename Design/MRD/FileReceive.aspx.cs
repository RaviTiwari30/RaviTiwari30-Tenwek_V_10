using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_MRD_FileReceive : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            EntryDate1.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            EntryTime1.Text = System.DateTime.Now.ToString("hh:mm tt");
            string type = Request.QueryString["Type"].ToString();
            ViewState["Type"] = type.ToString();
            ViewState["ID"] = Session["ID"].ToString();
            string PatientID = Request.QueryString["PatientID"];
            ViewState["PatientID"] = PatientID.ToString();
            string TransactionID = "";
            string RequestedID = "";
            //if (ViewState["Type"].ToString() == "IPD")
            //{
            //    if (Request.QueryString["TID"] == null)
            //    {
            //        btnSave.Enabled = false;
            //    }
            ViewState["RequestID"] = Request.QueryString["RequestID"];
                TransactionID = Request.QueryString["TID"];
                ViewState["TID"] = TransactionID.ToString();
                btnSave.Enabled = true;
                BindPatientDetail(PatientID, TransactionID);
                Bindgrid(PatientID,TransactionID);
                BindDocuments(PatientID,TransactionID);

           // }
            //else
            //{
            //    btnSave.Enabled = true;
            //    BindPatientDetail(PatientID);
            //    Bindgrid(PatientID);
            //    BindDocuments(PatientID);
            //}


            issuedate(TransactionID);
            string fileid = ViewState["fileid"].ToString();
            AllQuery AQ = new AllQuery();
            DateTime Issuedate = Convert.ToDateTime(Util.GetDateTime(AQ.getissuedate(fileid.ToString())));
            calucDate.StartDate = Util.GetDateTime(Issuedate.ToString("dd-MMM-yyyy"));
            AllLoaddate_MRD.BindRoomCMB(cmbRoom);
            EntryDate1.Attributes.Add("readonly", "readonly");
        }

    }
    private void issuedate(string TransactionID)
    {
       string PatientID= ViewState["PatientID"].ToString();           
        string FileID = StockReports.ExecuteScalar( "select FileID from mrd_file_master where TransactionID ='" + TransactionID + "' order by fileid desc");       
        ViewState["fileid"] = FileID.ToString();
    }
    protected void cmbAlmirah_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindShelf(Util.GetString(cmbAlmirah.SelectedItem.Value));
    }
    protected void cmbRoom_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindAlmirah(Util.GetString(cmbRoom.SelectedItem.Value));
    }

    protected void cmbShelf_SelectedIndexChanged(object sender, EventArgs e)
    {
        lblCounter.Text = Util.GetString(cmbShelf.SelectedItem.Value).Split('$')[1];
    }

    public void BindShelf(string AlmID)
    {
        if (AlmID.ToString() != "Select")
        {
            string rackname = cmbAlmirah.SelectedItem.Text;
            string sql = " select distinct ShelfNo,concat(ShelfNo,'$',ifnull(CurPos,0))ID from mrd_location_master  where AlmID = '" + AlmID + "' and  MaxPos > (CurPos+AdditionalNo) order by ShelfNo ";
            DataTable dt = StockReports.GetDataTable(sql);

            if (dt != null && dt.Rows.Count > 0)
            {
                cmbShelf.DataSource = dt;
                cmbShelf.DataTextField = "ShelfNo";
                cmbShelf.DataValueField = "ID";
                cmbShelf.DataBind();
                cmbShelf.Items.Insert(0, "Select");
                lblCounter.Text = Util.GetString(dt.Rows[0]["ID"]).Split('$')[1];

            }
            else
            {
                cmbShelf.DataSource = null;
                cmbShelf.DataBind();
                cmbShelf.SelectedIndex = -1;
                cmbShelf.Items.Clear();
                lblCounter.Text = "";
                cmbShelf.Items.Insert(0, "No Shelf Available");

            }
        }
    }
    public void BindAlmirah(string RmID)
    {
        string sql = " select distinct lm.AlmID, am.Name from mrd_location_master lm inner join  mrd_almirah_master am on am.AlmID=lm.AlmID where lm.MaxPos >= (CurPos+AdditionalNo) and am.RmID='" + RmID + "' order by am.Name ";
        DataTable dt = StockReports.GetDataTable(sql);

        if (dt != null && dt.Rows.Count > 0)
        {
            cmbAlmirah.DataSource = dt;
            cmbAlmirah.DataTextField = "Name";
            cmbAlmirah.DataValueField = "AlmID";
            cmbAlmirah.DataBind();
            cmbAlmirah.Items.Insert(0, "Select");
        }
        else
        {
            cmbAlmirah.DataSource = null;
            cmbAlmirah.DataBind();
            cmbShelf.SelectedIndex = -1;
            cmbAlmirah.SelectedIndex = -1;
            cmbAlmirah.Controls.Clear();
            cmbAlmirah.Items.Clear();
            cmbShelf.Items.Clear();
            cmbShelf.Controls.Clear();
            cmbShelf.DataSource = null;
            cmbShelf.DataBind();
            lblCounter.Text = "";
            cmbAlmirah.Items.Insert(0, "Select");
            cmbShelf.Items.Insert(0, "Select");
        }
    }

    public void Bindgrid(string PatientID,string TransactionID)
    {
        StringBuilder sb = new StringBuilder();
        //if (ViewState["Type"].ToString() == "IPD")
        //{

        sb.Append("     SELECT  mfi.file_issue_id,mfd.FileDetID,mdm.Name,mfd.FileID,mfd.DocumentID,mfi.IssueType,DATE_FORMAT(mfi.IssueDate,'%Y-%m-%d')IssueDate,DATE_FORMAT(mfi.IssueDate,'%d-%b-%Y')IssueDateGrid,mfi.Issue_ToType,mfi.Issue_To,Issue_To_Name,");
            sb.Append("     (SELECT NAME FROM employee_master WHERE employeeid=mfi.Issue_By)EmpName,IF(mfi.IsIssued=1,'Issued','NotIssued')STATUS,IF(IFNULL(mfi.IsIssued,0)=0,'false','true')IsIssued, ");
            sb.Append("     IF(mfi.Isreturn=1,'Returned','NotReturned')RtnSTATUS,IF(IFNULL(mfi.Isreturn,0)=0,'false','true')IsReturn,mfi.Remarks ,mfi.`HardCopy`,mfi.`SoftCopy`,mfi.`Avg_ReturnTime` ,");
            sb.Append("     (SELECT NAME FROM employee_master WHERE employeeid=mfr.`ReturnRequestedBy`)ReturnEmpName , (SELECT  RoleName FROM f_rolemaster WHERE id=mfr.`ReturnRequestedRoleID`)ReturnDepartment,IFNULL(mfr.`ReturnRemarks`,'')ReturnRemarks,mfr.`MRDReturnID` ");
            sb.Append("     FROM mrd_file_master mfm  ");
            sb.Append("     INNER JOIN mrd_file_detail mfd ON mfm.FileID=mfd.FileID  ");
            sb.Append("     INNER JOIN mrd_filereturn mfr ON mfr.`FileID`=mfd.`FileID`   AND mfr.ReturnIsApproved=1 ");
            sb.Append("     INNER JOIN mrd_document_master mdm ON mfd.DocumentID=mdm.DocumentID ");
            sb.Append("     left JOIN mrd_file_issue mfi ON mfd.filedetid=mfi.filedetid  ");
            sb.Append("     WHERE mfm.TransactionID='" + TransactionID + "'  and mfi.`RequestedID`='" + Util.GetString(ViewState["RequestID"]) + "'  AND mfi.IsIssued=1; ");
        //}
        //else
        //{
        //    sb.Append("     SELECT  mfi.file_issue_id,mfd.FileDetID,mdm.Name,mfd.FileID,mfd.DocID,mfi.IssueType,DATE_FORMAT(mfi.IssueDate,'%Y-%m-%d')IssueDate,DATE_FORMAT(mfi.IssueDate,'%d-%b-%Y')IssueDateGrid,mfi.Issue_ToType,mfi.Issue_To,Issue_To_Name,");
        //    sb.Append("     (SELECT NAME FROM employee_master WHERE employee_id=mfi.Issue_By)EmpName,IF(mfi.IsIssued=1,'Issued','NotIssued')STATUS,IF(IFNULL(mfi.IsIssued,0)=0,'false','true')IsIssued, ");
        //    sb.Append("     IF(mfi.Isreturn=1,'Returned','NotReturned')RtnSTATUS,IF(IFNULL(mfi.Isreturn,0)=0,'false','true')IsReturn,mfi.Remarks ");
        //    sb.Append("     FROM mrd_file_master mfm  ");
        //    sb.Append("     INNER JOIN mrd_file_detail mfd ON mfm.FileID=mfd.FileID  ");
        //    sb.Append("     INNER JOIN mrd_document_master mdm ON mfd.DocID=mdm.DocID ");
        //    sb.Append("     left JOIN mrd_file_issue mfi ON mfd.filedetid=mfi.filedetid  ");
        //    sb.Append("     WHERE PatientID='" + PatientID + "'  AND mfi.IsIssued=1; ");
        //}
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt != null && dt.Rows.Count > 0)
        {
            if (dt.Columns.Contains("Remarks"))
                lblIssueRemarks.Text = Util.GetString(dt.Rows[0]["Remarks"]);
             if (dt.Columns.Contains("HardCopy"))
                chkHardCpoy.Checked =Convert.ToBoolean(dt.Rows[0]["HardCopy"]);
            if (dt.Columns.Contains("SoftCopy"))
                chkSoftCopy.Checked = Convert.ToBoolean(dt.Rows[0]["SoftCopy"]);
            lblReturnUserName.Text = Util.GetString(dt.Rows[0]["ReturnEmpName"]);
            lblReturnDept.Text = Util.GetString(dt.Rows[0]["ReturnDepartment"]);
            lblReturnRemarks.Text = Util.GetString(dt.Rows[0]["ReturnRemarks"]);

            grdDocs.DataSource = dt;
            grdDocs.DataBind();
            btnSave.Enabled = true;
            cmbRoom.Enabled = true;
            cmbAlmirah.Enabled = true;
            cmbShelf.Enabled = true;


        }
        else
        {
            btnSave.Enabled = false;
            cmbRoom.Enabled = false;
            cmbAlmirah.Enabled = false;
            cmbShelf.Enabled = false;

        }
    }
    public void BindDocuments(string PatientID,string TransactionID)
    {


        string sqlfileno = " SELECT  mfm.RmID,mrm.Name RoomName, mfm.AlmID ,  ShelfNo, mam.Name RackName FROM mrd_file_master mfm INNER JOIN mrd_almirah_master mam ON mam.AlmID=mfm.AlmID INNER JOIN mrd_room_master mrm ON mfm.RmID=mrm.RmID where mfm.TransactionID='" + TransactionID + "' ";
        DataTable dtfileno = StockReports.GetDataTable(sqlfileno);
        if (dtfileno.Rows.Count > 0)
        {
            hide.Visible = true;
            lblroom.Text = dtfileno.Rows[0]["RoomName"].ToString();
            lblrack.Text = dtfileno.Rows[0]["RackName"].ToString();
            lblShelf.Text = dtfileno.Rows[0]["ShelfNo"].ToString();
        }
        else
        {
            hide.Visible = false;
        }
    }
    public void BindPatientDetail(string PatientID, string TransactionID)
    {
        string sql = "";
        //if (ViewState["Type"].ToString() == "IPD")
        //{
            sql = " select pm.PatientID,pm.PName,pmh.TransactionID,pmh.BillNo, " +
                                " if(pm.DOB='0001-01-01',pm.Age,date_format(pm.DOB,'%d-%b-%Y')) AGE,pmh.MLC_NO, " +
                                " date_format(pmh.DateOfAdmit,'%d-%b-%Y')DateOfAdmit ,  " +
                                " if(pmh.DateOfDischarge='0001-01-01','', date_format(pmh.DateOfDischarge,'%d-%b-%Y'))DateOfDischarge " +
                                " from patient_master pm " +
                                " inner join patient_medical_history pmh on pm.PatientID = pmh.PatientID  " +
                                " where pmh.TransactionID ='" + TransactionID + "'";

       // }
        //else
        //{
        //    sql = " SELECT  pm.PatientID,pm.PName,pm.Age,mfm.* FROM patient_master pm INNER JOIN mrd_file_master mfm ON mfm.PatientID = pm.PatientID   WHERE pm.PatientID='" + PatientID + "'";
        //}
        DataTable dt = StockReports.GetDataTable(sql);

        if (dt != null && dt.Rows.Count > 0)
        {
            //if (ViewState["Type"].ToString() == "IPD")
            //{
                pnlIpd.Visible = true;
                
                ViewState["TID"] = TransactionID.ToString();
                lblBillNo.Text = Util.GetString(dt.Rows[0]["BillNo"]);
                lblCRNumber.Text = TransactionID;
                lblDischargeDate.Text = Util.GetString(dt.Rows[0]["DateOfDischarge"]);
                lblMLCNo.Text = Util.GetString(dt.Rows[0]["MLC_NO"]);
                lblPatientName.Text = Util.GetString(dt.Rows[0]["PName"]);

            //}
            //else
            //{
            //    pnlOpd.Visible = true;
            //    lblPnatientnameOpd.Text = Util.GetString(dt.Rows[0]["PName"]);
            //    lblMRno.Text = Util.GetString(dt.Rows[0]["PatientID"]);
            //}
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('No Files To Return',function(){});", true);
            return;
        }
    }
  
    public bool ChechFileStatus(int FileID)
    {
        int IsIssued = Util.GetInt(StockReports.ExecuteScalar("select IsIssued from mrd_file_master where FileID='" + FileID + "'"));
       
        if (IsIssued == 0)
            return false;
        return true;

    }
    private void Bind()
    {
        string sql = getSearchQuery();
        DataTable dt = StockReports.GetDataTable(sql);
        string TransactionID = ViewState["TID"].ToString();
        ViewState["dt"] = dt;
    }
    private string getSearchQuery()
    {

        StringBuilder sb = new StringBuilder();

        string PatientID = ViewState["PatientID"].ToString();
        sb.Append("  SELECT pm.PatientID,pm.PName,lt.TransactionID,lt.BillNo,  IF(pm.DOB='0001-01-01',pm.Age, ");
        sb.Append("  DATE_FORMAT(pm.DOB,'%d-%b-%Y')) AGE,pmh.MLC_NO,  DATE_FORMAT(ich.DateOfAdmit,'%d-%b-%Y')DateOfAdmit ,    ");
        sb.Append("  IF(ich.DateOfDischarge='0001-01-01','', DATE_FORMAT(ich.DateOfDischarge,'%d-%b-%Y'))DateOfDischarge   ");
        sb.Append("  FROM f_ipdadjustment lt   INNER JOIN  patient_master pm  ON pm.PatientID = lt.PatientID  ");
        sb.Append("  INNER JOIN patient_medical_history pmh ON lt.TransactionID=pmh.TransactionID  INNER JOIN ipd_case_history ich  ");
        sb.Append("  ON ich.TransactionID = pmh.TransactionID  WHERE  pmh.PatientID ='" + PatientID + "' ");

        return sb.ToString();

    }
    private void FileReturn()
    {
        string PatientID = ViewState["PatientID"].ToString();
        string TID = "";
        DataTable dt = (DataTable)ViewState["dt"];
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        try
        {
           
            if (lblFileNo.Text.Trim().ToString() == "")
            {
                string sql = "select count(*) from  mrd_location_master where RmID='" + cmbRoom.SelectedItem.Value + "' and AlmID='" + cmbAlmirah.SelectedItem.Value + "' and ShelfNo='" + cmbShelf.SelectedItem.Value.Split('$')[0] + "' and MaxPos>CurPos+AdditionalNo and CentreID="+ Session["CentreID"] +"";
                int count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sql));

                if (count == 0)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM125','" + lblMsg.ClientID + "');", true);
                    tnx.Rollback();
                    con.Close();
                    con.Dispose();
                    return;
                }

                sql = " update mrd_location_master set CurPos=CurPos +1, AdditionalNo=AdditionalNo+'" + Util.GetInt(txtAdditional.Text.Trim()) + "' where RmID='" + cmbRoom.SelectedItem.Value + "' and AlmID='" + cmbAlmirah.SelectedItem.Value + "' and ShelfNo='" + cmbShelf.SelectedItem.Value.Split('$')[0] + "' and CentreID=" + Session["CentreID"] + " ";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
                string curpos = "select curpos from mrd_location_master where RmID='" + cmbRoom.SelectedItem.Value + "' and AlmID='" + cmbAlmirah.SelectedItem.Value + "' and ShelfNo='" + cmbShelf.SelectedItem.Value.Split('$')[0] + "' and CentreID=" + Session["CentreID"] + " ";
                string cur = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, curpos));
                //if (ViewState["Type"].ToString() == "IPD")
                //{
                     TID = ViewState["TID"].ToString();
                    string BillDate = Util.GetDateTime(StockReports.ExecuteScalar("Select BillDate from patient_medical_history where TransactionID = '" + TID + "' limit 1")).ToString("yyyy-MM-dd");

               // }
                //else
                //{
                //}
                string FileID = "";
                if (ddlFileNo.Visible != true)
                {
                    sql = "select FileID from mrd_file_master where TransactionID ='" + TID + "' order by fileid desc";
                    FileID = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sql));
                }
                else
                {
                    FileID = ddlFileNo.SelectedItem.Value.ToString();
                }
                if (chkHardCpoy.Checked)
                {
                    sql = "UPDATE mrd_file_master SET rmid='" + cmbRoom.SelectedItem.Value + "' , almid='" + cmbAlmirah.SelectedItem.Value + "',shelfno='" + cmbShelf.SelectedItem.Value.Split('$')[0] + "', curpos='" + cur + "',HardCopyIssue=0 WHERE TransactionID='" + TID + "'";
                }
                else
                {
                    sql = "UPDATE mrd_file_master SET rmid='" + cmbRoom.SelectedItem.Value + "' , almid='" + cmbAlmirah.SelectedItem.Value + "',shelfno='" + cmbShelf.SelectedItem.Value.Split('$')[0] + "', curpos='" + cur + "' WHERE TransactionID='" + TID + "'";
                }
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPdate mrd_filereturn set ReturnToMrd=1 WHERE FileID='" + FileID + "' And ReturnToMrd=0 AND CentreID="+Session["CentreID"]+"");

                if (FileID == null || FileID == "")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Error occurred, Please contact administrator',function(){});", true);
                    tnx.Rollback();
                    con.Close();
                    con.Dispose();
                    return;
                }




            }

            else
            {

                string BillDate = Util.GetDateTime(StockReports.ExecuteScalar("Select BillDate from patient_medical_history where TransactionID = '" + TID + "' limit 1")).ToString("yyyy-MM-dd");

                string sql = "update mrd_file_master set PatientID='" + PatientID + "', TransactionID= '" + TID + "', BillNo= '" + Util.GetString(dt.Rows[0]["BillNo"]) + "',BillDate='" + BillDate + "',  DischargeDateTime='" + Util.GetDateTime(Util.GetString(dt.Rows[0]["DateOfDischarge"])).ToString("yyyy-MM-dd") + "', " +
                              "  RmID= '" + cmbRoom.SelectedItem.Value + "', AlmID='" + cmbAlmirah.SelectedItem.Value + "', ShelfNo='" + cmbShelf.SelectedItem.Value.Split('$')[0] + "', CurPos='" + lblCounter.Text.Trim() + "', Narration='" + txtRemarks.Text.Trim() + "', UserID='" + ViewState["ID"] + "' where   FileID='" + lblFileNo.Text.Trim().ToString() + "' and CentreID="+ Session["CentreID"] +"";

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);


                sql = "select count(*) from  mrd_location_master where RmID='" + cmbRoom.SelectedItem.Value + "' and AlmID='" + cmbAlmirah.SelectedItem.Value + "' and ShelfNo='" + cmbShelf.SelectedItem.Value.Split('$')[0] + "' and MaxPos>CurPos+AdditionalNo AND CentreID="+ Session["CentreID"]+"";
                int count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sql));

                if (count == 0)
                {

                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Shelf Is Full',function(){});", true);
                    tnx.Rollback();
                    con.Close();
                    con.Dispose();
                    return;
                }


                sql = " update mrd_location_master set CurPos=CurPos +1, AdditionalNo=AdditionalNo+" + Util.GetInt(txtAdditional.Text.Trim()) + " " +
                        "where RmID='" + cmbRoom.SelectedItem.Value + "' and AlmID='" + cmbAlmirah.SelectedItem.Value + "' and ShelfNo='" + cmbShelf.SelectedItem.Value.Split('$')[0] + "' AND CentreID="+Session["CentreID"]+"";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);

            }



            foreach (GridViewRow gr in grdDocs.Rows)
            {
                if (((CheckBox)gr.FindControl("chkReturnStatus")).Checked == true)
                {

                    string sql = "update mrd_file_issue set IsIssued = 0,Return_By = '" + Util.GetString(ViewState["ID"]) + "' , ReturnDate='" + Util.GetDateTime(EntryDate1.Text).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(EntryTime1.Text).ToString("HH:mm:ss") + "' , Return_Remarks= '" + txtRemarks.Text.Trim() + "', IsReturn=1 where  CentreID="+Session["CentreID"]+" AND file_issue_id=" + ((Label)gr.FindControl("lblfileissueid")).Text.ToString();
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);

                }

            }


            StringBuilder sb = new StringBuilder();
            sb.Append("   SELECT COUNT(*) FROM mrd_file_issue mfi inner join mrd_file_detail mfd on mfi.file_issue_id=mfd.file_issue_id inner join mrd_file_master mfm on mfm.fileid=mfi.fileid  ");
            sb.Append("   WHERE mfm.TransactionID='" + TID + "'  ");
            sb.Append("  AND mfi.Isreturn=0   ");
            int Count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sb.ToString()));
            if (Count == 0)
            {
                string sql = "update mrd_file_master set  IsIssued =0 where TransactionID='" + TID + "'";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
            }
            tnx.Commit();
            con.Close();

        }
        catch (Exception Ex)
        {
            tnx.Rollback();
            con.Close();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('File Not Issued',function(){});", true);
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(Ex);
            return;

        }
      
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        string patientid = ViewState["PatientID"].ToString();
        string RequestID = Request.QueryString["RequestID"];
        bool isTrue = validatecontrol();
        if (!isTrue) return;
        foreach (GridViewRow gr in grdDocs.Rows)
        {
            if (Util.GetDateTime(((Label)gr.FindControl("lblIssueDate")).Text) > Util.GetDateTime(EntryDate1.Text))
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Return Date can not be less of issue date',function(){});", true);
                return;
            }
        }

        FileReturn();
        //if (ViewState["Type"].ToString() == "IPD")
        //{
            string TID = ViewState["TID"].ToString();
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Record Saved Sucessfully');;location.href='FileIssue.aspx?PatientID=" + patientid + "&TID=" + TID + " &Type=" + ViewState["Type"].ToString()+"'" , true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('File Issued Successfully',function(){});location.href='FileIssue.aspx?PatientID=" + patientid + "&TID=" + ViewState["TID"].ToString() + " &Type=" + ViewState["Type"].ToString() + " &RequestID=" + RequestID + " '", true);
                //}
        //else
        //{
        //    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Record Saved Sucessfully');;location.href='FileIssue.aspx?PatientID=" + patientid + " &Type=" + ViewState["Type"].ToString() + "'", true);
        //}
      
    }
    protected Boolean validatecontrol()
    {

        if (cmbRoom.SelectedItem.Text == "Select")
        {
            lblMsg.Text = "Please Select Room";
            cmbRoom.Focus();
            return false;
        }
        if (cmbAlmirah.SelectedItem.Text == "Select")
        {
            lblMsg.Text = "Please Select Rack";
            cmbAlmirah.Focus();
            return false;
        }
        if (cmbShelf.SelectedItem.Text == "Select")
        {
            lblMsg.Text = "Please Select Shelf";
            cmbShelf.Focus();
            return false;
        }
        if (cmbShelf.SelectedItem.Text == "No Shelf Available")
        {
            lblMsg.Text = "Shelf Is Not Available";
            return false;
        }
        return true;
    }



    protected void grdDocs_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblrtnStatus")).Text.ToUpper() == "TRUE")
                e.Row.Attributes.Add("style", "background-color:lightpink");
            else
                e.Row.Attributes.Add("style", "background-color:lightgreen");
        }
    }
}
