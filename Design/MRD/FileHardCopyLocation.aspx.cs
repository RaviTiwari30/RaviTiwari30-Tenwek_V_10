using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_MRD_FileHardCopyLocation : System.Web.UI.Page
{
    
    protected void Page_Load(object sender, EventArgs e)
    {
        lblmainmsg.Text = "";
        if (!IsPostBack)
        {
            if (Session["LoginType"] == null && Session["UserName"] == null)
            {
                Response.Redirect("~/Default.aspx");
            }
            else
            {
                ViewState["RoleId"] =Util.GetString(Session["LoginType"]);
                string type = Request.QueryString["Type"].ToString();
                ViewState["Type"] = type.ToString();
                string PID = Request.QueryString["PatientID"].ToString();
                ViewState["Patient_ID"] = PID.ToString();
                string TID = Request.QueryString["TID"].ToString();
                ViewState["TID"] =  TID.ToString();
                ViewState["ID"] = Session["ID"].ToString();
                AllLoaddate_MRD.BindRoomCMB(cmbRoom);
                ddlDocument.Visible = false;
                BindGrid();
                BindLocation();
               
            }
        }
    }
    protected void BindDoc()
    {
        DataTable dtDoc = StockReports.GetDataTable("SELECT NAME,DocID FROM mrd_document_master where IsActive=1");
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
        string sql = " select  FileID  from mrd_file_master fm inner join mrd_almirah_master am on fm.AlmID = am.AlmID where fm.Patient_ID='" + ViewState["Patient_ID"].ToString() + "' AND fm.Transaction_ID='" + ViewState["TID"].ToString() + "'  ";

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
        
        if (cmbRoom.SelectedItem.Text == "Select")
        {
            lblmainmsg.Text = "Please Select Room";
            cmbRoom.Focus();
            return false;
        }

        if (cmbAlmirah.SelectedItem.Text == "Select" )
        {
            lblmainmsg.Text = "Please Select Rack";
            cmbAlmirah.Focus();
            return false;
        }
        if (cmbAlmirah.SelectedItem.Text == "No Rack Available")
        {
            lblmainmsg.Text = "No Rack Available under This Room";
            cmbAlmirah.Focus();
            return false;
        }
        if (cmbShelf.SelectedItem.Text == "No Shelf Available")
        {
            lblmainmsg.Text = "No Shelf Available under This Rack";
            cmbShelf.Focus();
            return false;
        }
        if (cmbShelf.SelectedItem.Text == "Select")
        {
            lblmainmsg.Text = "Please Select Shelf";
            cmbShelf.Focus();
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
        string PID =ViewState["Patient_ID"].ToString();
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
            int countNoofmaxiumFile = 0;
            countNoofmaxiumFile = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM mrd_almirah_master WHERE (SELECT IFNULL(SUM(CuRPOS),0)dd  FROM mrd_file_master WHERE IFNULL(Almid,0)=" + cmbAlmirah.SelectedItem.Value + ")<maximumNoOfFiles AND almid=" + cmbAlmirah.SelectedItem.Value + "  "));
            if(countNoofmaxiumFile>0)
            {
            string FileID = "";
          
            string issued = "select isissued,patientid from mrd_file_master where   TransactionID='" + ViewState["TID"].ToString() + "' ";
           string isissued = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, issued));
           if (isissued == "1")
           {
              
               ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Return The File Before Changing Document Status',function(){});", true);
               return;

           }
            
            string TID = "";
            if (lblFileNo.Text.Trim().ToString() == "")
            {
             
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('File No Is missing..',function(){});", true);
                return;
            }

            else
            {
               
                 TID = ViewState["TID"].ToString();
                if (type == "IPD")
                {
                   TID = ViewState["TID"].ToString();
                }
                DataTable dt1 = StockReports.GetDataTable("SELECT * FROM  mrd_file_master where  TransactionID='" + ViewState["TID"].ToString() + "' ");
                if (dt1.Rows.Count > 0)
                {
                    lblroomid.Text = dt1.Rows[0]["RmID"].ToString();
                    lblrackid.Text = dt1.Rows[0]["AlmID"].ToString();
                    lblshelno.Text = dt1.Rows[0]["Shelfno"].ToString();
                    //if (lblroomid.Text != string.Empty)
                    //{

                    //    string sqlu = " INSERT INTO `mrd_lastfilelocation`(`MRDNO`,`TransactionId`,`PatientName`, `FileId`,`RmId`,`AlmID`,`ShelfNo`,`CurPos`,`UpdatedDate`,`UpdatedBy`,New_RoomId,New_AmId,New_Shelf,New_Possition)" +
                    //                       "VALUES ('" + PID + "', '" + TID + "','','" + lblFileNo.Text.Trim().ToString() + "','" + dt1.Rows[0]["RmID"].ToString() + "','" + dt1.Rows[0]["AlmID"].ToString() + "','" + dt1.Rows[0]["Shelfno"].ToString() + "','" + dt1.Rows[0]["CurPos"].ToString() + "',Now(),'" + Util.GetString(ViewState["ID"]) + "'," +
                    //    " '" + cmbRoom.SelectedItem.Value + "','" + cmbAlmirah.SelectedItem.Value + "','" + cmbShelf.SelectedItem.Value.Split('$')[0] + "','" + lbl + "' );";
                    //    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sqlu);
                    //}
                }
                string sql="";
                //if (type == "IPD")
                //{
                    
                    TID = ViewState["TID"].ToString();
                    sql = "update mrd_file_master set PatientID='" + PID + "', TransactionID= '" + TID + "',AdmissionDateTime='" + Util.GetDateTime(Util.GetString(dt.Rows[0]["DateOfAdmit"])).ToString("yyyy-MM-dd") + "',DischargeDatetime='" + Util.GetDateTime(Util.GetString(dt.Rows[0]["DateOfDischarge"])).ToString("yyyy-MM-dd") + "', " +
                              "  RmID= '" + cmbRoom.SelectedItem.Value + "', AlmID='" + cmbAlmirah.SelectedItem.Value + "', ShelfNo='" + cmbShelf.SelectedItem.Value.Split('$')[0] + "', Narration='" + txtRemarks.Text.Trim() + "', UserID='" + ViewState["ID"].ToString() + "',Curpos='"+lbl+"' where   FileID='" + lblFileNo.Text.Trim().ToString() + "' and CentreID="+Session["CentreID"]+" ";

               // } 
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
                if (cmbAlmirah.Enabled == false)
                {

                }
                //else
                //{
                //    sql = " update mrd_location_master set CurPos=CurPos +1, AdditionalNo=AdditionalNo+" + Util.GetInt(txtAdditional.Text.Trim()) + " " +
                //            "where RmID='" + cmbRoom.SelectedItem.Value + "' and AlmID='" + cmbAlmirah.SelectedItem.Value + "' and ShelfNo='" + cmbShelf.SelectedItem.Value.Split('$')[0] + "' ";
                //    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
                //}

                        sql = "UPDATE mrd_file_detail  SET Remarks='"+txtRemarks.Text.Trim()+"' WHERE FileID='"+lblFileId.Text.Trim()+"' ";
                      
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
                    
                }
     
            tnx.Commit();
            con.Close();
            lblmainmsg.Text = "";
            btnSave.Enabled = true;
       

                TID = ViewState["TID"].ToString();

                if (lblroomid.Text != string.Empty)
                {
                    
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Location has been Updated',function(){});", true);
                }
                else
                {
                    
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Location has been Set',function(){});", true);
                }
            
            //else
            //{
            //    Response.Redirect("ScanFiles.aspx?Patient_ID=" + ViewState["Patient_ID"].ToString() + " &Type=" + ViewState["Type"].ToString(), false);
            //}
        }

            else{
                btnSave.Enabled = true;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Selected shelf has been full kindly select another rack or shelf',function(){});", true);
                return;
            }
        }
        catch (Exception ex)
        {
            btnSave.Enabled = true;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Enter File Information',function(){});", true);
            tnx.Rollback();
            con.Close();
            con.Dispose();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }

    }
    private string getSearchQuery()
    {

        StringBuilder sb = new StringBuilder();

        string patient_id = ViewState["Patient_ID"].ToString();
        //sb.ToString("  ");
        sb.Append("  SELECT pm.PatientID,pm.PName,pmh.TransactionID,pmh.BillNo,  IF(pm.DOB='0001-01-01',pm.Age, ");
        sb.Append("  DATE_FORMAT(pm.DOB,'%d-%b-%Y')) AGE,pmh.MLC_NO,  DATE_FORMAT(pmh.DateOfAdmit,'%d-%b-%Y')DateOfAdmit ,    ");
        sb.Append("  IF(pmh.DateOfDischarge='0001-01-01','', DATE_FORMAT(pmh.DateOfDischarge,'%d-%b-%Y'))DateOfDischarge   ");
        sb.Append("  FROM patient_medical_history pmh     INNER JOIN  patient_master pm  ON pm.PatientID = pmh.PatientID  ");
        sb.Append("    WHERE  pmh.TransactionID='" + ViewState["TID"].ToString() + "' ");

        return sb.ToString();

    }
    private void BindGrid()
    {
        string sql = getSearchQuery();
        DataTable dt = StockReports.GetDataTable(sql);
        string Transaction_ID = ViewState["TID"].ToString();
        ViewState["dt"] = dt;
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
                mpe2.Show();
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
       
        mpe2.Hide();
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
        mpe2.Show();
    }
    protected void ddlDocument_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlDocument.SelectedItem.Value != "0")
        {
            DataTable dtNew = StockReports.GetDataTable("SELECT NAME,Isactive,SequenceNo,IsMandatory FROM mrd_document_master where DocID=" + ddlDocument.SelectedItem.Value + "");
            if (dtNew.Rows.Count > 0)
            {
                txtDocument.Visible = true;
                txtDocument.Text = dtNew.Rows[0]["NAME"].ToString();
                txtSequence.Text = dtNew.Rows[0]["SequenceNo"].ToString();
                ddlActive.SelectedIndex = ddlActive.Items.IndexOf(ddlActive.Items.FindByValue(dtNew.Rows[0]["Isactive"].ToString()));
                if (dtNew.Rows[0]["IsMandatory"].ToString() == "2")
                    chkMandatory.Checked = true;
                else
                    chkMandatory.Checked = false;
            }
        }
        else
        {
            txtDocument.Visible = false;
            txtSequence.Text = "";
        }
        mpe2.Show();
    }
    protected void btnSave2_Click(object sender, EventArgs e)
    {
        if (txtDocument.Text.Trim() == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM143','" + lblDocument.ClientID + "');", true);
            mpe2.Show();
            return;
        }
        if (txtSequence.Text.Trim() == "")
        {
            lblDocument.Text = "Enter Sequence No.";
            mpe2.Show();
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
            mpe2.Show();
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
            string Mandatory = "0";
            if(chkMandatory.Checked)
                Mandatory = "1";
            if (btnSave2.Text != "Update")
            {
                sql = "insert into mrd_document_master(NAME,EntDate,UserID,SequenceNo,IsActive,IsMandatory) values ('" + txtDocument.Text.ToString() + "','" + DateTime.Now.ToString("yyyy-MM-dd H:mm:ss") + "','" + Session["ID"].ToString() + "','" + Util.GetInt(txtSequence.Text.Trim()) + "',1,'" + Mandatory + "')";
            }
            else
            {
                sql = "Update mrd_document_master Set Name='" + txtDocument.Text + "',IsActive=" + ddlActive.SelectedItem.Value + ",SequenceNo=" + Util.GetInt(txtSequence.Text.Trim()) + ",IsMandatory="+ Mandatory +" where DocID='" + ddlDocument.SelectedItem.Value + "'";
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
                mpe2.Hide();
                txtDocument.Text = "";
                txtSequence.Text = "";
                chkEdit.Checked = false;
                ddlDocument.Visible = false;
                ddlDocument.SelectedIndex = 0;
                btnSave2.Text = "Save";
               
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
    public void BindLocation() {
        string sqlfileno = " select fileid,RmID,AlmID,ShelfNo,CurPos,Narration from mrd_file_master where TransactionID='" + ViewState["TID"].ToString() + "' ";
        DataTable dtfileno = StockReports.GetDataTable(sqlfileno);
        if (dtfileno.Rows.Count > 0)
        {
            lblFileNo.Text = Util.GetString(dtfileno.Rows[0]["fileid"].ToString());
            cmbRoom.SelectedIndex = cmbRoom.Items.IndexOf(cmbRoom.Items.FindByValue(dtfileno.Rows[0]["RmID"].ToString()));
            BindAlmirah(Util.GetString(cmbRoom.SelectedItem.Value));
            cmbAlmirah.SelectedIndex = cmbAlmirah.Items.IndexOf(cmbAlmirah.Items.FindByValue(dtfileno.Rows[0]["AlmID"].ToString()));
            BindallShelf(Util.GetString(cmbAlmirah.SelectedItem.Value));
            cmbShelf.SelectedIndex = cmbShelf.Items.IndexOf(cmbShelf.Items.FindByText(dtfileno.Rows[0]["ShelfNo"].ToString()));
            txtRemarks.Text = dtfileno.Rows[0]["Narration"].ToString();
        }
    }
    protected void btnLog_Click(object sender, EventArgs e)
    {
        //DataTable dt = AllLoaddate_MRD.RoomLogRcord("", ViewState["TID"].ToString(), lblFileNo.Text.Trim().ToString());
        //if (dt.Rows.Count > 0)
        //{
        //    grdfileLog.DataSource = dt;
        //    grdfileLog.DataBind();
        //    mpopLog.Show();
        //}
        //else
        //    lblmainmsg.Text = "Room Log Not found";
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        grdfileLog.DataSource = null;
        grdfileLog.DataBind();
        mpopLog.Hide();

    }
}
