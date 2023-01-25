using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_MRD_FileRegistered : System.Web.UI.Page
{
    
    protected void Page_Load(object sender, EventArgs e)
    {
        lblmainmsg.Text = "";
        if (!IsPostBack)
        {
            string type = Request.QueryString["Type"].ToString();
            ViewState["Type"] = type.ToString();
            string PID = Request.QueryString["PatientID"].ToString();
           ViewState["PatientID"] = PID.ToString();
            string TID = Request.QueryString["TID"].ToString();
            //if (TID.Contains("SHHI") == false)
            //    TID = "ISHHI" + TID;
            ViewState["TID"] = TID.ToString();
            ViewState["ID"] = Session["ID"].ToString();

            AllLoaddate_MRD.BindRoomCMB(cmbRoom);
            ddlDocument.Visible = false;
            BindGrid();
            BindDocuments();
            DataTable dt = StockReports.GetDataTable("SELECT * FROM  mrd_file_master where PatientID='" +ViewState["PatientID"].ToString()+ "'");
            if (dt.Rows.Count > 0)
            {
                cmbRoom.Enabled = false;
                cmbAlmirah.Enabled = false;
                cmbShelf.Enabled = false;
            }
            else
            {
                cmbRoom.Enabled = true;
                cmbAlmirah.Enabled = true;
                cmbShelf.Enabled = true;
            }
        }
    }
    protected void BindDoc()
    {
        DataTable dtDoc = StockReports.GetDataTable("SELECT NAME,DocumentID FROM mrd_document_master where IsActive=1");
        if (dtDoc.Rows.Count > 0)
        {
            ddlDocument.DataSource = dtDoc;
            ddlDocument.DataTextField = "Name";
            ddlDocument.DataValueField = "DocID";
            ddlDocument.DataBind();
            ddlDocument.Visible = true;
            ddlDocument.Items.Insert(0, "Select");
        }
        else
        {
            ddlDocument.Visible = false;
        }
    }

  
    public void BindFileDetail(string TransactionID)
    {
        string sql = " select  FileID  from mrd_file_master fm inner join mrd_almirah_master am on fm.AlmID = am.AlmID where fm.TransactionID='" + TransactionID + "'  ";

        DataTable dt = StockReports.GetDataTable(sql);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlFileNo.DataSource = dt;
            ddlFileNo.DataTextField = "FileID";
            ddlFileNo.DataValueField = "FileID";
            ddlFileNo.DataBind();
        }
        else
        {
            ddlFileNo.Visible = false;
            lblFileId.Visible = false;
        }
    }
    private void BindGrid()
    {
        string sql = getSearchQuery();
        DataTable dt = StockReports.GetDataTable(sql);
        string TransactionID = ViewState["TID"].ToString();
        ViewState["dt"] = dt;
    }

    public void BindDocuments()
    {
        StringBuilder sql = new StringBuilder();
        string PatientID = ViewState["PatientID"].ToString();
        sql.Append(" SELECT IfNull(t.Doc_Qty,1)Doc_Qty,mdm.DocumentID,mdm.Name,IFNULL(t.Status,'')STATUS,IFNULL(t.FileDetID,'')FileDetID,SequenceNo ");
        sql.Append(" FROM mrd_document_master mdm LEFT JOIN ( ");
        sql.Append(" SELECT mfd.Doc_Qty,IFNULL(mfd.Status,'')STATUS,mfd.FileDetID,mfd.FileID, mfd.documentID  FROM mrd_file_master mfm INNER JOIN  ");
        sql.Append(" mrd_file_detail mfd ON mfm.FileID=mfd.FileID WHERE  mfm.TransactionID='" + ViewState["TID"].ToString() + "'  )t  ");
        sql.Append(" ON t.documentID=mdm.DocumentID  WHERE mdm.IsActive=1 ORDER BY SequenceNo  ");
        DataTable dt = StockReports.GetDataTable(sql.ToString());

        string sqlfileno = " select fileid,RmID,AlmID,ShelfNo,CurPos,Narration from mrd_file_master where TransactionID='" + ViewState["TID"].ToString() + "' and CentreID="+Session["CentreID"]+" ";
        DataTable dtfileno = StockReports.GetDataTable(sqlfileno);
        if (dtfileno.Rows.Count > 0)
        {
            lblFileNo.Text = Util.GetString(dtfileno.Rows[0]["fileid"].ToString());
            //cmbRoom.SelectedIndex = cmbRoom.Items.IndexOf(cmbRoom.Items.FindByValue(dtfileno.Rows[0]["RmID"].ToString()));
            //BindAlmirah(Util.GetString(cmbRoom.SelectedItem.Value));
            //cmbAlmirah.SelectedIndex = cmbAlmirah.Items.IndexOf(cmbAlmirah.Items.FindByValue(dtfileno.Rows[0]["AlmID"].ToString()));
            //BindallShelf(Util.GetString(cmbAlmirah.SelectedItem.Value));
            //cmbShelf.SelectedIndex = cmbShelf.Items.IndexOf(cmbShelf.Items.FindByText(dtfileno.Rows[0]["ShelfNo"].ToString()));
            //txtRemarks.Text = dtfileno.Rows[0]["Narration"].ToString();
        }
        string str = " SELECT FileStatus,Description FROM mrd_file_status WHERE IsActive=1 ";
        DataTable dtStatus = StockReports.GetDataTable(str);

        foreach (DataRow dr in dtStatus.Rows)
        {
            dt.Columns.Add(dr["FileStatus"].ToString(), typeof(string));
        }
        dt.Columns.Add("FileStatus", typeof(string));
        foreach (DataRow dr in dt.Rows)
        {
            if (dr["Status"].ToString() == "")
            {
                dr["A"] = "false";
                dr["B"] = "false";
                dr["C"] = "false";
                dr["D"] = "false";
                dr["FileStatus"] = "false";
            }
            else if (dr["Status"].ToString() == "A")
            {
                dr["A"] = "true";
                dr["B"] = "false";
                dr["C"] = "false";
                dr["D"] = "false";
                dr["FileStatus"] = "true";

            }
            else if (dr["Status"].ToString() == "B")
            {
                dr["A"] = "false";
                dr["B"] = "true";
                dr["C"] = "false";
                dr["D"] = "false";
                dr["FileStatus"] = "true";
            }
            else if (dr["Status"].ToString() == "C")
            {
                dr["A"] = "false";
                dr["B"] = "false";
                dr["C"] = "true";
                dr["D"] = "false";
                dr["FileStatus"] = "true";
            }
            else if (dr["Status"].ToString() == "D")
            {
                dr["A"] = "false";
                dr["B"] = "false";
                dr["C"] = "false";
                dr["D"] = "true";
                dr["FileStatus"] = "true";
            }
        }
        if (dt != null && dt.Rows.Count > 0)
        {
            grdDocsg.DataSource = dt;
            grdDocsg.DataBind();
        }
        else
        {
            grdDocsg.DataSource = null;
            grdDocsg.DataBind();
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
            cmbAlmirah.Items.Insert(0, "No Rack Available");
          
        }
    }

    public void BindShelf(string AlmID)
    {
        if (AlmID.ToString() != "Select")
        {
         
             string sql = " select distinct ShelfNo,concat(ShelfNo,'$',ifnull(CurPos,0))ID from mrd_location_master  where AlmID = '" + AlmID + "' and  MaxPos > (CurPos+AdditionalNo) and isactive=1 order by ShelfNo ";
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

    public void BindallShelf(string AlmID)
    {
        if (AlmID.ToString() != "Select")
        {

            string sql = " select distinct ShelfNo,concat(ShelfNo,'$',ifnull(CurPos,0))ID from mrd_location_master  where AlmID = '" + AlmID + "' and  MaxPos >= (CurPos+AdditionalNo) and isactive=1 order by ShelfNo ";
            DataTable dt = StockReports.GetDataTable(sql);

            if (dt != null && dt.Rows.Count > 0)
            {
                cmbShelf.DataSource = dt;
                cmbShelf.DataTextField = "ShelfNo";
                cmbShelf.DataValueField = "ID";
                cmbShelf.DataBind();
                cmbShelf.Items.Insert(0, "Select");
            }
            else
            {
                cmbShelf.DataSource = null;
                cmbShelf.DataBind();
                cmbShelf.SelectedIndex = -1;
                cmbShelf.Controls.Clear();
                lblCounter.Text = "";
                cmbShelf.Items.Insert(0, "Select");
            }
        }
    }


    private string getSearchQuery()
    {

        StringBuilder sb = new StringBuilder();

        string PatientID = ViewState["PatientID"].ToString();
        string TID = Request.QueryString["TID"].ToString();
        //sb.ToString("  ");
        //sb.Append("  SELECT pm.PatientID,pm.PName,lt.TransactionID,lt.BillNo,  IF(pm.DOB='0001-01-01',pm.Age, ");
        //sb.Append("  DATE_FORMAT(pm.DOB,'%d-%b-%Y')) AGE,pmh.MLC_NO,  DATE_FORMAT(ich.DateOfAdmit,'%d-%b-%Y')DateOfAdmit ,    ");
        //sb.Append("  IF(ich.DateOfDischarge='0001-01-01','', DATE_FORMAT(ich.DateOfDischarge,'%d-%b-%Y'))DateOfDischarge   ");
        //sb.Append("  FROM f_ipdadjustment lt   INNER JOIN  patient_master pm  ON pm.PatientID = lt.PatientID  ");
        //sb.Append("  INNER JOIN patient_medical_history pmh ON lt.TransactionID=pmh.TransactionID  INNER JOIN ipd_case_history ich  ");
        //sb.Append("  ON ich.TransactionID = pmh.TransactionID  WHERE  pmh.PatientID ='" + PatientID + "' ");

        sb.Append("  SELECT pm.PatientID,pm.PName,pmh.TransactionID,pmh.BillNo,  IF(pm.DOB='0001-01-01',pm.Age,   DATE_FORMAT(pm.DOB,'%d-%b-%Y')) AGE,pmh.MLC_NO, ");
        sb.Append(" DATE_FORMAT(pmh.DateOfAdmit,'%d-%b-%Y')DateOfAdmit,IF(pmh.DateOfDischarge='0001-01-01','', DATE_FORMAT(pmh.DateOfDischarge,'%d-%b-%Y'))DateOfDischarge,pmh.Type    ");
        sb.Append(" FROM  patient_medical_history pmh INNER JOIN  patient_master pm  ON pm.PatientID = pmh.PatientID ");
        sb.Append(" WHERE  pmh.TransactionID='"+TID+"' AND pmh.CentreID="+Util.GetInt(Session["CentreID"])+" ");

        return sb.ToString();

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
    protected Boolean validatecontrol()
    {
        string Status = "";
        //if (cmbRoom.SelectedItem.Text == "Select")
        //{
        //    lblmainmsg.Text = "Please Select Room";
        //    cmbRoom.Focus();
        //    return false;
        //}

        //if (cmbAlmirah.SelectedItem.Text == "Select" )
        //{
        //    lblmainmsg.Text = "Please Select Rack";
        //    cmbAlmirah.Focus();
        //    return false;
        //}
        //if (cmbAlmirah.SelectedItem.Text == "No Rack Available")
        //{
        //    lblmainmsg.Text = "No Rack Available under This Room";
        //    cmbAlmirah.Focus();
        //    return false;
        //}
        //if (cmbShelf.SelectedItem.Text == "No Shelf Available")
        //{
        //    lblmainmsg.Text = "No Shelf Available under This Rack";
        //    cmbShelf.Focus();
        //    return false;
        //}
        //if (cmbShelf.SelectedItem.Text == "Select")
        //{
        //    lblmainmsg.Text = "Please Select Shelf";
        //    cmbShelf.Focus();
        //    return false;
        //}
        for (int i = 0; i < grdDocsg.Rows.Count; i++)
        {

            if (((RadioButton)grdDocsg.Rows[i].FindControl("rdbstatus1")).Checked == true)
            {
                Status = Status + 1;
                return true;
            }
            else if (((RadioButton)grdDocsg.Rows[i].FindControl("rdbstatus2")).Checked == true)
            {
                Status = Status + 1;
                return true;
            }
            else if (((RadioButton)grdDocsg.Rows[i].FindControl("rdbstatus3")).Checked == true)
            {
                Status = Status + 1;
                return true;
            }
            else if (((RadioButton)grdDocsg.Rows[i].FindControl("rdbstatus4")).Checked == true)
            {
                Status = Status + 1;
                return true;
            }
        }
        lblmainmsg.Text = "";
        if (Status == "")
        {
            lblmainmsg.Text = "Please Select Document";
            return false;
        }
        return true;
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        
        bool isTrue = validatecontrol();
        if (!isTrue) return;

        btnSave.Enabled = false;
        DataTable dt = (DataTable)ViewState["dt"];
        string PID =ViewState["PatientID"].ToString();
        string type = ViewState["Type"].ToString();
       int lbl= Util.GetInt(lblCounter.Text);
       if (lbl == 0)
       {
           lbl = lbl + 1;
       }
       else
       {
           lbl = lbl + 1;
       }
       
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        try
        {
            string TID = "";
            TID = ViewState["TID"].ToString();
            string issued = "select isissued,PatientID from mrd_file_master where PatientID='" + PID + "' AND TransactionID='"+TID+"' and  "+Session["CentreID"]+"";
           string isissued = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, issued));
           if (isissued == "1")
           {
               
               ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Return The File Before Changing Document Status',function(){});", true);
               return;

           }
        

           
            int Qty = 0;
            
            if (lblFileNo.Text.Trim().ToString() == "")
            {
                string BillDate = "";
                string sql="";
                string sql1 = "";
                //if (type == "IPD")
                //{
                    
                     BillDate = Util.GetDateTime(StockReports.ExecuteScalar(" Select BillDate from patient_medical_history where TransactionID = '" + TID + "' limit 1" )).ToString("yyyy-MM-dd");
                     sql = "   insert into mrd_file_master(PatientID, TransactionID, BillNo,BillDate, UserID ,CentreID,PType)" +
                              " values('" + PID + "', '" + TID + "', '" + Util.GetString(dt.Rows[0]["BillNo"]) + "','" + BillDate + "', " +
                              "  '" + ViewState["ID"].ToString() + "'," + Session["CentreID"] + ",'" + Util.GetString(dt.Rows[0]["Type"]) + "') ";
               // }
                //else
                //{
                //    BillDate = "0001-01-01 00:00:00";
                //    string billno = "";
                //    string admissiondatetime = "0001-01-01 00:00:00";
                //    string dateofdischarge = "0001-01-01 00:00:00";
                //     TID = "";
                //    if (type == "General")
                //    {
                //         TID = "";
                //    }
                //    else
                //    {
                //         TID = ViewState["TID"].ToString();
                //    }
                //   sql  = "insert into mrd_file_master(PatientID, TransactionID, BillNo,BillDate, AdmissionDateTime,  DischargeDateTime, " +
                //             "  RmID, AlmID, ShelfNo, CurPos, Narration, UserID ) " +
                //             " values('" + PID + "', '" + TID + "', '" + billno + "','" + BillDate + "', '" + admissiondatetime + "', '" + dateofdischarge + "', " +
                //             "  '" + cmbRoom.SelectedItem.Value + "', '" + cmbAlmirah.SelectedItem.Value + "', '" + cmbShelf.SelectedItem.Value.Split('$')[0] + "', '" + lbl + "', '" + txtRemarks.Text.Trim() + "', '" + ViewState["ID"].ToString() + "') ";
                //   if (type == "OPD")
                //   {
                //       sql1 = "insert into mrd_opd_filestatus(PatientID ) " +
                //            " values('" + PID + "') ";
                //       MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql1);
                      
                //   }
                //}
                
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
               
                string FileID = "";
                if (ddlFileNo.Visible != true)
                {
                    sql = "select FileID from mrd_file_master where TransactionID='" + ViewState["TID"].ToString() + "' AND " + Session["CentreID"] + " order by fileid desc";
                    FileID = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sql));
                }
                else
                {
                    FileID = ddlFileNo.SelectedItem.Value.ToString();
                }


                if (FileID == null || FileID == "")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmainmsg.ClientID + "');", true);
                    tnx.Rollback();
                    con.Close();
                    con.Dispose();
                    return;
                }

                //sql = "select count(*) from  mrd_location_master where RmID='" + cmbRoom.SelectedItem.Value + "' and AlmID='" + cmbAlmirah.SelectedItem.Value + "' and ShelfNo='" + cmbShelf.SelectedItem.Value.Split('$')[0] + "' and MaxPos>CurPos+AdditionalNo";
                //int count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sql));

                //if (count == 0)
                //{
                //    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM125','" + lblmainmsg.ClientID + "');", true);
                //    tnx.Rollback();
                //    con.Close();
                //    con.Dispose();
                //    return;
                //}
                //if (cmbAlmirah.Enabled == false)
                //{
                  
                //}
                //else
                //{
                //    sql = " update mrd_location_master set CurPos=CurPos +1, AdditionalNo=AdditionalNo+'" + Util.GetInt(txtAdditional.Text.Trim()) + "' where RmID='" + cmbRoom.SelectedItem.Value + "' and AlmID='" + cmbAlmirah.SelectedItem.Value + "' and ShelfNo='" + cmbShelf.SelectedItem.Value.Split('$')[0] + "' ";
                //    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
                //}

                for (int i = 0; i < grdDocsg.Rows.Count; i++)
                {
                    string Status = "";
                    if (((RadioButton)grdDocsg.Rows[i].FindControl("rdbstatus1")).Checked == true)
                    {
                        Status = "A";
                    }
                    else if (((RadioButton)grdDocsg.Rows[i].FindControl("rdbstatus2")).Checked == true)
                    {
                        Status = "B";
                    }
                    else if (((RadioButton)grdDocsg.Rows[i].FindControl("rdbstatus3")).Checked == true)
                    {
                        Status = "C";
                    }
                    else if (((RadioButton)grdDocsg.Rows[i].FindControl("rdbstatus4")).Checked == true)
                    {
                        Status = "D";
                    }
                    if (Status != "")
                    {
                        if (((TextBox)grdDocsg.Rows[i].FindControl("txtQty")).Text == "")
                            Qty = 0;
                        else
                            Qty = Util.GetInt(((TextBox)grdDocsg.Rows[i].FindControl("txtQty")).Text);


                        sql = "insert into mrd_file_detail ( FileID, DocumentID, Remarks, UserID,STATUS,Doc_Qty,CentreID) " +
                              " values ('" + FileID + "', '" + ((Label)grdDocsg.Rows[i].FindControl("lblDocID")).Text + "', '', '" + ViewState["ID"] + "','" + Status + "'," + Qty + ","+Session["CentreID"]+") ";

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
                        Status = "";
                    }

                }

            }

            else
            {
                 TID = ViewState["TID"].ToString();
                string BillDate = "";
                string sql1 = "";
                //if (type == "IPD")
                //{
                   TID = ViewState["TID"].ToString();
                   BillDate = Util.GetDateTime(StockReports.ExecuteScalar("Select BillDate from patient_medical_history where TransactionID = '" + TID + "' limit 1")).ToString("yyyy-MM-dd");
                //}
                DataTable dt1 = StockReports.GetDataTable("SELECT * FROM  mrd_file_master where TransactionID='" + ViewState["TID"].ToString() + "' and CentreID="+Session["CentreID"]+"");
                if (dt1.Rows.Count > 0)
                {
                    lblroomid.Text = dt1.Rows[0]["RmID"].ToString();
                    lblrackid.Text = dt1.Rows[0]["AlmID"].ToString();
                    lblshelno.Text = dt1.Rows[0]["Shelfno"].ToString();
                 
                }
                string sql="";
                                TID = ViewState["TID"].ToString();
                                sql = " update mrd_file_master set PatientID='" + PID + "', TransactionID= '" + TID + "', BillNo= '" + Util.GetString(dt.Rows[0]["BillNo"]) + "',BillDate='" + BillDate + "',   " +
                                    "   Narration='" + txtRemarks.Text.Trim() + "', UserID='" + ViewState["ID"] + "' where   FileID='" + lblFileNo.Text.Trim().ToString() + "' AND CentreID="+Session["CentreID"]+" ";

                
                //else
                //{
                //    BillDate = "0001-01-01 00:00:00";
                //    string billno = "";
                //    string dateofdischarge = "0001-01-01 00:00:00";
                //    TID = "";
                //     sql = "update mrd_file_master set PatientID='" + PID + "', TransactionID= '" + TID + "', BillNo= '" + billno + "',BillDate='" + BillDate + "',  DischargeDateTime='" + dateofdischarge + "', " +
                //              "  RmID= '" + lblroomid.Text + "', AlmID='" + lblrackid.Text + "', ShelfNo='" + lblshelno.Text + "', Narration='" + txtRemarks.Text.Trim() + "', UserID='" + ViewState["ID"] + "' where   FileID='" + lblFileNo.Text.Trim().ToString() + "' ";

                //     if (type == "OPD")
                //     {
                //         sql1 = "insert into mrd_opd_filestatus(PatientID ) " +
                //              " values('" + PID + "') ";
                //         MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql1);
                //     }
                //}
                
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
               

               
                if (cmbAlmirah.Enabled == false)
                {

                }
                else
                {
                    sql = " update mrd_location_master set CurPos=CurPos +1, AdditionalNo=AdditionalNo+" + Util.GetInt(txtAdditional.Text.Trim()) + " " +
                            "where RmID='" + cmbRoom.SelectedItem.Value + "' and AlmID='" + cmbAlmirah.SelectedItem.Value + "' and ShelfNo='" + cmbShelf.SelectedItem.Value.Split('$')[0] + "' ";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
                }

                for (int i = 0; i < grdDocsg.Rows.Count; i++)
                {
                    string Status = "";
                    if (((RadioButton)grdDocsg.Rows[i].FindControl("rdbstatus1")).Checked == true)
                    {
                        Status = "A";
                    }
                    else if (((RadioButton)grdDocsg.Rows[i].FindControl("rdbstatus2")).Checked == true)
                    {
                        Status = "B";
                    }
                    else if (((RadioButton)grdDocsg.Rows[i].FindControl("rdbstatus3")).Checked == true)
                    {
                        Status = "C";
                    }
                    else if (((RadioButton)grdDocsg.Rows[i].FindControl("rdbstatus4")).Checked == true)
                    {
                        Status = "D";
                    }
                    if (Status != "")
                    {
                        if (((Label)grdDocsg.Rows[i].FindControl("lblFileDetID")).Text.Trim().ToString() == "")
                        {
                            if (((TextBox)grdDocsg.Rows[i].FindControl("txtQty")).Text == "")
                                Qty = 0;
                            else
                                Qty = Util.GetInt(((TextBox)grdDocsg.Rows[i].FindControl("txtQty")).Text);
                            sql = "insert into mrd_file_detail ( FileID, DocumentID, Remarks, UserID,STATUS,Doc_Qty,CentreID) " +
                                      " values ('" + lblFileNo.Text.Trim().ToString() + "', '" + ((Label)grdDocsg.Rows[i].FindControl("lblDocID")).Text + "', '', '" + ViewState["ID"] + "','" + Status + "'," + Qty + "," + Session["CentreID"] + ") ";

                        }
                        else
                        {
                            if (((TextBox)grdDocsg.Rows[i].FindControl("txtQty")).Text == "")
                                Qty = 0;
                            else
                                Qty = Util.GetInt(((TextBox)grdDocsg.Rows[i].FindControl("txtQty")).Text);
                            sql = "update mrd_file_detail  set  Doc_Qty=" + Qty + ",Remarks='', UserID='" + ViewState["ID"] + "',STATUS='" + Status + "' where  FileDetID='" + ((Label)grdDocsg.Rows[i].FindControl("lblFileDetID")).Text.Trim().ToString() + "' AND CentreID="+Session["CentreID"]+" ";

                        }
                        Status = "";
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
                    }

                }
            }

            tnx.Commit();
            con.Close();
            lblmainmsg.Text = "";
   
            string patientid = ViewState["PatientID"].ToString();
           
            //if (ViewState["Type"].ToString() == "IPD")
            //{
                TID = ViewState["TID"].ToString();
                Response.Redirect("ScanFiles.aspx?PatientID=" + patientid + "&TID=" + ViewState["TID"].ToString() + " &Type=" + ViewState["Type"].ToString(), false);
            //}
            //else
            //{
            //    Response.Redirect("ScanFiles.aspx?PatientID=" + patientid + " &Type=" + ViewState["Type"].ToString(), false);
            //}
         

        }
        catch (Exception ex)
        {
            btnSave.Enabled = true;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM144','" + lblmainmsg.ClientID + "');", true);
            tnx.Rollback();
            con.Close();
            con.Dispose();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }

    }


    public bool chkTnx_Exist(string TransactionID)
    {
        string sql = "select count(*) from mrd_file_master where TransactionID ='" + TransactionID + "'";
        int count = Util.GetInt(StockReports.ExecuteScalar(sql));
        if (count > 0)
            return true;
        return false;
    }


    private void BindRoomCMB()
    {
        string sql = "select * from mrd_room_master where IsActive=1 order by Name";
        DataTable dt = StockReports.GetDataTable(sql);

        if (dt != null && dt.Rows.Count > 0)
        {
            cmbRoom.DataSource = dt;
            cmbRoom.DataTextField = "Name";
            cmbRoom.DataValueField = "RmID";
            cmbRoom.DataBind();
            cmbRoom.Items.Insert(0, "Select");
        }
        else
        {
            cmbRoom.Items.Clear();
            cmbRoom.Controls.Clear();
        }

    }

    protected void rdbfileStatus_SelectedIndexChanged(object sender, EventArgs e)
    {
        string TID = ViewState["TID"].ToString();
       
    }

    protected void btnCreateRoom_Click(object sender, EventArgs e)
    {
        lblMSGRoom.Text = "";
        lblMSGAlmirah.Text = "";
        lblMSGRoom.Text = "";
        txtAlmirah.Text = "";
        txtNoOfShelf.Text = "";
        txtMaxNoRecord.Text = "";
        if (cmbRoomPopUp.SelectedIndex > 0)
        {
            cmbRoomPopUp.SelectedIndex = 0;
        }
        txtRoom.Text = "";
        grdRoom.EditIndex = -1;
        BindRoomGrid();
        mpe1.Show();

    }



    #region Room
    protected void grdRoom_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        grdRoom.EditIndex = -1;
        BindRoomGrid();

    }
    protected void grdRoom_RowEditing(object sender, GridViewEditEventArgs e)
    {
        grdRoom.EditIndex = e.NewEditIndex;
        BindRoomGrid();
    }
    protected void grdRoom_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        string myTextBox = ((TextBox)(grdRoom.Rows[grdRoom.EditIndex]).Cells[0].Controls[0]).Text;
        if (myTextBox == "")
        {
            lblMSGRoom.Text = "Please Enter Room Name";
            ((TextBox)(grdRoom.Rows[grdRoom.EditIndex]).Cells[0].Controls[0]).Focus();
           
            return;
        }

        foreach (GridViewRow gr in grdRoom.Rows)
        {
            if (gr.Cells[0].Text == ((TextBox)grdRoom.Rows[e.RowIndex].Cells[0].Controls[0]).Text)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM123','" + lblMSGRoom.ClientID + "');", true);
               
                return;
            }

        }

        string sql = "update mrd_room_master  set Name = '" + Util.GetString(((TextBox)grdRoom.Rows[e.RowIndex].Cells[0].Controls[0]).Text) +
            "',UserID='" + ViewState["ID"].ToString() + "' where RmID='" + ((Label)grdRoom.Rows[e.RowIndex].FindControl("lblRoom_ID")).Text + "'";
        if (StockReports.ExecuteDML(sql))
        {
            lblMSGRoom.Visible = true;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM02','" + lblmainmsg.ClientID + "');", true);
            BindRoomCMBPopUp();
        }
        else
        {
            lblMSGRoom.Visible = true;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM124','" + lblmainmsg.ClientID + "');", true);

        }
        grdRoom.EditIndex = -1;
        BindRoomGrid();
        mpe1.Hide();

    }
   

    protected void btnRoom_Click(object sender, EventArgs e)
    {
        SaveRoom();
        
    }
    protected void btnCreateRack_Click(object sender, EventArgs e)
    {
        ddlrackname.Visible = false;
        rbtnAlmirah.SelectedValue = "0";
        BindRoomCMBPopUp();
        mpopRack.Show();
        txtAlmirah.Text = "";
        lblMSGAlmirah.Text = "";
        txtNoOfShelf.Text = "";
        txtMaxNoRecord.Text = "";
        txtAlmirah.Focus();
        btnAlmirah.Text = "Save";
    }
    private void SaveRoom()
    {
        if (txtRoom.Text.Trim() == "")
        {
            lblMSGRoom.Text = "Please Enter Room Name ";
            txtRoom.Focus();
            return;
        }


        string str = " select * from mrd_room_master where  Replace(Name,' ','') = '" + (txtRoom.Text.Trim()).Replace(" ", "") + "'";
        DataTable dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {
            lblMSGRoom.Visible = true;
            lblMSGRoom.Text = "Room Already Exist";
            grdRoom.Visible = true;

            grdRoom.DataSource = dt;
            grdRoom.DataBind();
            return;
        }
        grdRoom.Visible = false;
        str = " insert into mrd_room_master(Name,UserID) values('" + Util.GetString(txtRoom.Text.Trim()) + "','" + ViewState["ID"].ToString() + "')";
        if (StockReports.ExecuteDML(str))
        {
            lblMSGRoom.Visible = true;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmainmsg.ClientID + "');", true);
            txtRoom.Text = "";
            AllLoaddate_MRD.BindRoomCMB(cmbRoom);
            BindRoomCMBPopUp();
            mpe1.Hide();
        }
        else
        {
            lblMSGRoom.Visible = true;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMSGRoom.ClientID + "');", true);

        }
    }

    private void BindRoomGrid()
    {
        string str = " select * from mrd_room_master where  Replace(Name,' ','') like '" + (txtRoom.Text.Trim()).Replace(" ", "") + "%'";
        DataTable dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {
            grdRoom.Visible = true;
            grdRoom.DataSource = dt;
            grdRoom.DataBind();
            lblMSGRoom.Text = "";
            return;
        }
        else
        {
            lblMSGRoom.Text = "Record Not Found";
        }
    }

    #endregion

    #region Almirah

    protected void btnAlmirah_Click(object sender, EventArgs e)
    {
        if (btnAlmirah.Text == "Save")
        {
            SaveAlmirah();
        }
        else
        {
            EditPreAlmirah();           
        }
    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        mpe1.Hide();
        lblmainmsg.Text = "";
    }
    protected void btnCancel1_Click(object sender, EventArgs e)
    {
        txtDocument.Text = "";
        txtSequence.Text = "";
        chkEdit.Checked = false;
        if (ddlDocument.Visible == true)
        {
            ddlDocument.SelectedIndex = 0;
        }
        ddlDocument.Visible = false;
        txtDocument.Visible = true;
        btnSave2.Text = "Save";
        lblDocument.Text = "";
        lblmainmsg.Text = "";
        BindDocuments();
        
    }

    private void BindRoomCMBPopUp()
    {
        string sql = "select * from mrd_room_master where IsActive=1 order by Name ";
        DataTable dt = StockReports.GetDataTable(sql);

        if (dt != null && dt.Rows.Count > 0)
        {
            cmbRoomPopUp.DataSource = dt;
            cmbRoomPopUp.DataTextField = "Name";
            cmbRoomPopUp.DataValueField = "RmID";
            cmbRoomPopUp.DataBind();
            cmbRoomPopUp.Items.Insert(0, new ListItem("Select", "0"));

        }
        else
        {
            cmbRoomPopUp.Items.Clear();
            cmbRoomPopUp.Controls.Clear();
        }

    }

    private void SaveAlmirah()
    {

        if (txtAlmirah.Text.Trim() == "")
        {
            lblMSGRoom.Text = "Please Enter Rack Name ";
            mpopRack.Show();
            txtAlmirah.Focus();
            return;
        }
       
        if (txtNoOfShelf.Text.Trim() == "")
        {
            lblMSGAlmirah.Text = "Please Enter No. Of Shelf ";
            mpopRack.Show();
            txtNoOfShelf.Focus();
            return;
        }

        if (txtMaxNoRecord.Text.Trim() == "")
        {
            lblMSGAlmirah.Text = "Please Enter Max. No. Record per Shelf ";
            mpopRack.Show();
            txtMaxNoRecord.Focus();
            return;
        }
        string str = " select * from mrd_almirah_master inner join mrd_room_master on mrd_room_master.Rmid=mrd_almirah_master.Rmid where  Replace(mrd_almirah_master.Name,' ','') = '" + (txtAlmirah.Text.Trim()).Replace(" ", "") + "' and Replace(mrd_room_master.Name,' ','') = '" + (cmbRoomPopUp.SelectedItem.Text).Replace(" ", "") + "'";
        DataTable dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {
            lblMSGAlmirah.Visible = true;
            lblMSGAlmirah.Text = "Rack Already Exist";
            return;
        }

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        try
        {
            str = " insert into mrd_almirah_master(Name,NoOfShelf,RmID,UserID) values('" + Util.GetString(txtAlmirah.Text.Trim()) + "','" + Util.GetString(txtNoOfShelf.Text.Trim()) + "','" + cmbRoomPopUp.SelectedItem.Value + "','" + ViewState["ID"].ToString() + "')";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

            str = "select AlmID from mrd_almirah_master where Name='" + Util.GetString(txtAlmirah.Text.Trim()) + "'";
            string AlmID = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, str));

            for (int i = 0; i < Util.GetInt(txtNoOfShelf.Text.Trim()); i++)
            {
                str = "insert into mrd_location_master (RmID, AlmID, ShelfNo, CurPos, MaxPos, AdditionalNo, IsActive, UserID ) " +
                    " values  ('" + cmbRoomPopUp.SelectedItem.Value + "', '" + AlmID + "', '" + Util.GetInt(i + 1) + "', '0', '" + txtMaxNoRecord.Text.Trim() + "', '0', 1, '" + ViewState["ID"].ToString() + "' )";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
            }
            lblMSGAlmirah.Visible = true;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmainmsg.ClientID + "');", true);

            tnx.Commit();
          
            txtAlmirah.Text = "";
            txtNoOfShelf.Text = "";
            txtMaxNoRecord.Text = "";
            cmbRoomPopUp.SelectedIndex = -1;
            mpopRack.Hide();

        }
        catch (Exception ex)
        {
            lblMSGAlmirah.Visible = true;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmainmsg.ClientID + "');", true);
            tnx.Rollback();
           
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }


    }

    private void EditPreAlmirah()
    {
        if (txtAlmirah.Text.Trim() == "")
        {
            lblMSGRoom.Text = "Please Enter Rack Name ";
            mpopRack.Show();
            txtAlmirah.Focus();
            return;
        }
       
        if (txtNoOfShelf.Text.Trim() == "")
        {
            lblMSGAlmirah.Text = "Please Enter No. Of Shelf ";
            mpopRack.Show();
            txtNoOfShelf.Focus();
            return;
        }

        if (txtMaxNoRecord.Text.Trim() == "")
        {
            lblMSGAlmirah.Text = "Please Enter Max. No. Record per Shelf ";
            mpopRack.Show();
            txtMaxNoRecord.Focus();
            return;
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        string sql = "";

        sql = "UPDATE mrd_almirah_master mlm,mrd_room_master mrm  SET mlm.`Name`='" + txtAlmirah.Text.Trim() + "',mlm.`NoOfShelf`='" + txtNoOfShelf.Text.Trim() + "',mrm.`Name`='" + cmbRoomPopUp.SelectedItem.Text + "' WHERE mlm.RmID= mrm.`RmID` AND mlm.`Name`='" + ddlrackname.SelectedItem.Text + "'";
             int result = MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sql);
             string strAlmID = "select AlmID from mrd_almirah_master where Name='" + Util.GetString(ddlrackname.SelectedItem.Text) + "'";
             string AlmID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, strAlmID));
             sql = "UPDATE mrd_location_master  SET IsActive=0 WHERE RmID='"+ cmbRoomPopUp.SelectedItem.Value +"' ";
             int Upresult = MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sql);
              for (int i = 0; i < Util.GetInt(txtNoOfShelf.Text.Trim()); i++)
              {
                string  str = "insert into mrd_location_master (RmID, AlmID, ShelfNo, CurPos, MaxPos, AdditionalNo, IsActive, UserID ) " +
                      " values  ('" + cmbRoomPopUp.SelectedItem.Value + "', '" + AlmID + "', '" + Util.GetInt(i + 1) + "', '0', '" + txtMaxNoRecord.Text.Trim() + "', '0', 1, '" + ViewState["ID"].ToString() + "' )";
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str);
              }
        lblMSGAlmirah.Text = "Previous Record Change Sucessfully ";
        con.Close();
    }
    private void EditAlmirah()
    {
        if (txtAlmirah.Text.Trim() == "")
        {
            lblMSGRoom.Text = "Please Enter Rack Name ";
            mpopRack.Show();
            txtAlmirah.Focus();
            return;
        }
        if (txtNoOfShelf.Text.Trim() == "")
        {
            lblMSGAlmirah.Text = "Please Enter No. Of Shelf ";
            mpopRack.Show();
            txtNoOfShelf.Focus();
            return;
        }
        if (txtMaxNoRecord.Text.Trim() == "")
        {
            lblMSGAlmirah.Text = "Please Enter Max. No. Record per Shelf ";
            mpopRack.Show();
            txtMaxNoRecord.Focus();
            return;
        }
        MySqlConnection con = Util.GetMySqlCon();
        MySqlConnection con1 = Util.GetMySqlCon();
        con.Open();
        string sql = "";
        string sql1 = "";
        sql = " UPDATE mrd_almirah_master  SET ISACTIVE='0' WHERE  `name`='" + cmbRoomPopUp.SelectedItem.Text + "'";
        int result = MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sql);
        sql1 = "insert into mrd_almirah_master(Name,NoOfShelf,RmID,IsActive,UserID) values('" + Util.GetString(txtAlmirah.Text.Trim()) + "','" + Util.GetString(txtNoOfShelf.Text.Trim()) + "','" + cmbRoomPopUp.SelectedItem.Value + "',1,'" + ViewState["ID"].ToString() + "')";
        int result1 = MySqlHelper.ExecuteNonQuery(con1, CommandType.Text, sql1);
        lblMSGAlmirah.Text = "Edit Record Sucessfully";
        con.Close();
    }

    #endregion
   
    protected void chkEdit_CheckedChanged(object sender, EventArgs e)
    {
        if (chkEdit.Checked == true)
        {
            AllLoaddate_MRD.BindDocMRD(ddlDocument);
            ddlDocument.Visible = true;

            btnSave2.Text = "Update";
            txtDocument.Visible = false;
            lblDocument.Text = "";
        }
        else
        {
            btnSave2.Text = "Save";
            ddlDocument.Visible = false;
            txtDocument.Visible = true;
            txtDocument.Text = "";
            txtSequence.Text = "";
            lblDocument.Text = "";
        }
        
    }
    protected void ddlDocument_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlDocument.SelectedItem.Value != "0")
        {
            DataTable dtNew = StockReports.GetDataTable("SELECT NAME,Isactive,SequenceNo FROM mrd_document_master where DocID=" + ddlDocument.SelectedItem.Value + "");
            if (dtNew.Rows.Count > 0)
            {
                txtDocument.Visible = true;
                txtDocument.Text = dtNew.Rows[0]["NAME"].ToString();
                txtSequence.Text = dtNew.Rows[0]["SequenceNo"].ToString();
                ddlActive.SelectedIndex = ddlActive.Items.IndexOf(ddlActive.Items.FindByValue(dtNew.Rows[0]["Isactive"].ToString()));
            }
        }
        else
        {
            txtDocument.Visible = false;
            txtSequence.Text = "";
        }
       
    }
    protected void btnSave2_Click(object sender, EventArgs e)
    {
        if (txtDocument.Text.Trim() == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM143','" + lblDocument.ClientID + "');", true);
           
            return;
        }
        if (txtSequence.Text.Trim() == "")
        {
            lblDocument.Text = "Enter Sequence No.";
           
            return;
        }
        string strCount = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        if (chkEdit.Checked != true)
            strCount = "SELECT * FROM mrd_document_master WHERE NAME='" + txtDocument.Text.Trim() + "'";
        else
            strCount = "SELECT * FROM mrd_document_master WHERE NAME='" + txtDocument.Text.Trim() + "' and '" + txtDocument.Text.Trim() + "'!='" + ddlDocument.SelectedItem.Text + "' ";
        int count = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, strCount));
        if (count > 0)
        {
            con.Close();
            con.Dispose();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM122','" + lblDocument.ClientID + "');", true);
           
            return;
        }
        
        if (chkEdit.Checked != true)
        {
            int Seq = Util.GetInt(StockReports.ExecuteScalar(" SELECT count(*) FROM mrd_document_master where SequenceNo='" + txtSequence.Text.Trim() + "'"));
            if (Seq > 0)
            {
                lblDocument.Text = "Sequence No. Already Exist";
                return;
            }
        }
        else
        {
            int Sequence = Util.GetInt(StockReports.ExecuteScalar("Select SequenceNo from mrd_document_master where Name='" + ddlDocument.SelectedItem.Text + "'"));
            int Seq = Util.GetInt(StockReports.ExecuteScalar(" SELECT count(*) FROM mrd_document_master where SequenceNo='" + txtSequence.Text.Trim() + "' and SequenceNo!='" + Sequence + "' "));
            if (Seq > 0)
            {
                lblDocument.Text = "Sequence No. Already Exist";
                return;
            }

        }
        try
        {
            string sql = "";
            if (btnSave2.Text != "Update")
            {
                sql = "insert into mrd_document_master(NAME,EntDate,UserID,SequenceNo,IsActive) values ('" + txtDocument.Text.ToString() + "','" + DateTime.Now.ToString("yyyy-MM-dd H:mm:ss") + "','" + Session["ID"].ToString() + "','" + Util.GetInt(txtSequence.Text.Trim()) + "',1)";
            }
            else
            {
                sql = "Update mrd_document_master Set Name='" + txtDocument.Text + "',IsActive=" + ddlActive.SelectedItem.Value + ",SequenceNo=" + Util.GetInt(txtSequence.Text.Trim()) + " where DocID='" + ddlDocument.SelectedItem.Value + "'";
            }
            int result = MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sql);
            if (result > 0)
            {
                if (btnSave2.Text != "Update")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmainmsg.ClientID + "');", true);
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM02','" + lblmainmsg.ClientID + "');", true);
                }
                
                txtDocument.Text = "";
                txtSequence.Text = "";
                chkEdit.Checked = false;
                ddlDocument.Visible = false;
                ddlDocument.SelectedIndex = 0;
                btnSave2.Text = "Save";
                BindDocuments();
            }
            con.Close();
            con.Dispose();
        }
        catch (Exception ex)
        {

            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void rbtnAlmirah_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rbtnAlmirah.SelectedValue == "0")
        {
            ddlrackname.Visible = false;
            lblMSGAlmirah.Text = "";
            txtAlmirah.Text = "";
            txtNoOfShelf.Text = "";
            txtMaxNoRecord.Text = "";
            btnAlmirah.Text = "Save";
           cmbRoomPopUp.SelectedValue = "0";
        }
        else
        {
            ddlrackname.Visible = true;
            txtAlmirah.Text = "";
            txtNoOfShelf.Text = "";
            txtMaxNoRecord.Text = "";
            btnAlmirah.Text = "Update";
        }
        mpopRack.Show();        
    }
    protected void ddlrackname_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rbtnAlmirah.SelectedItem.Value == "1")
        {
            DataTable dtNew = StockReports.GetDataTable("SELECT  mam.`Name`,mam.`NoOfShelf`,mlm.`MaxPos`,mrm.`Name`as room  FROM mrd_almirah_master mam INNER JOIN mrd_location_master mlm  ON mam.AlmID=mlm.AlmID and mlm.AlmID=" + ddlrackname.SelectedItem.Value + " INNER JOIN `mrd_room_master`mrm ON mam.`RmID`=mrm.`RmID`");
            if (dtNew.Rows.Count > 0)
            {
                txtAlmirah.Visible = true;
                txtAlmirah.Text = dtNew.Rows[0]["NAME"].ToString();
                txtNoOfShelf.Text = dtNew.Rows[0]["NoOfShelf"].ToString();
                txtMaxNoRecord.Text = dtNew.Rows[0]["MaxPos"].ToString();
                foreach (ListItem li in cmbRoomPopUp.Items)
                {
                    if (li.Text == dtNew.Rows[0]["room"].ToString())
                    {
                        cmbRoomPopUp.SelectedValue = li.Value;
                            cmbRoomPopUp.SelectedItem.Text = dtNew.Rows[0]["room"].ToString();
                    }
                }                              
            }
            else
            {
                txtAlmirah.Visible = false;
                txtNoOfShelf.Text = "";
            }
            mpopRack.Show();
            rbtnAlmirah.SelectedItem.Value = "1";
        }
    }
    protected void btnCancelRack_Click(object sender, EventArgs e)
    {
        mpopRack.Hide();
    }

    protected void cmbRoomPopUp_SelectedIndexChanged(object sender, EventArgs e)
    {
        string sql = " select distinct lm.AlmID, am.Name from mrd_location_master lm inner join  mrd_almirah_master am on am.AlmID=lm.AlmID where lm.MaxPos >= (CurPos+AdditionalNo) and am.RmID='" + cmbRoomPopUp.SelectedValue + "' order by am.Name ";
        DataTable dt = StockReports.GetDataTable(sql);
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlrackname.DataSource = dt;
            ddlrackname.DataTextField = "Name";
            ddlrackname.DataValueField = "AlmID";
            ddlrackname.DataBind();
            ddlrackname.Items.Insert(0, "Select");
        }
    }
}
