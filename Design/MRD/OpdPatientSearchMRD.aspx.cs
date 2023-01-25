using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_MRD_OpdPatientSearchMRD : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            AllLoaddate_MRD.BindRoomCMB(cmbRoom);
            ViewState["ID"] = Session["ID"].ToString(); 
        }
       
        ucFromDate.Attributes.Add("readonly", "readonly");
        ucToDate.Attributes.Add("readonly", "readonly");
        txtIssueDate.Attributes.Add("readonly", "readonly");
        txtReturnDate.Attributes.Add("readonly", "readonly");
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        search();
    }
    private void search()
    {
        lblMsg.Text = "";
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT  app.TransactionID,app.PatientID,App_ID,AppNo,CONCAT(title,' ',Pname)NAME,(SELECT CONCAT(Title,' ',NAME)");
        sb.Append(" FROM Doctor_master WHERE DoctorID=app.DoctorID)DoctorName,DoctorID,VisitType,TIME_FORMAT(TIME,'%l: %i %p')AppTime");
        sb.Append(" ,DATE_FORMAT(DATE,'%d-%b-%y')AppDate,IsConform,IsReschedule, IsCancel,CancelReason,DATE_FORMAT(ConformDate,'%d-%b-%y %l:%i %p')ConformDate,ifnull(LedgerTnxNo,'')LedgerTnxNo,CONCAT(DATE,' ',TIME)AppDateTime,ContactNo,'' Status, ");
        sb.Append(" IF(IFNULL(Isissue,0)=0,'TRUE','FALSE')IsIssue,IF(IFNULL(Isreturn,0)=0,'TRUE','FALSE')IsReturn FROM appointment app ");
        sb.Append(" LEFT JOIN mrd_opd_fileStatus mrdf ON mrdf.PatientID=app.PatientID and mrdf.AppointmentID=app.App_ID");
        sb.Append(" where Date>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "'");
        sb.Append(" and Date<='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "' and IsConform=1 AND app.PatientID!='' ");
        sb.Append("  ORDER BY DATE,TIME,AppNo");
        DataTable dtMRD = StockReports.GetDataTable(sb.ToString());
        if (dtMRD.Rows.Count > 0)
        {

            grdMRD.DataSource = dtMRD;
            grdMRD.DataBind();
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            grdMRD.DataSource = null;
            grdMRD.DataBind();
        }
    }
    protected void grdMRD_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName.ToString() == "FileIssue")
        {
            int index = int.Parse(e.CommandArgument.ToString());
            GridViewRow row = grdMRD.Rows[index];
            lblIssuePatientID.Text = ((Label)row.FindControl("lblMRNo")).Text.ToString();
            StringBuilder sb4 = new StringBuilder();
            sb4.Append("SELECT * FROM mrd_file_master where PatientID='" + lblIssuePatientID.Text + "' and IsIssued = 1 ");
            DataTable dt2 = StockReports.GetDataTable(sb4.ToString());
            if (dt2.Rows.Count > 0)
            {
                lblMsg.Text = "File Already Issued In IPD";
                return;
            }
            StringBuilder sb5 = new StringBuilder();
            sb5.Append("SELECT *  FROM mrd_opd_fileStatus where PatientID='" + lblIssuePatientID.Text + "' and isreturn=0");
            DataTable dt3 = StockReports.GetDataTable(sb5.ToString());
            if(dt3.Rows.Count>0)
            {
                lblMsg.Text = "File is Already Issued";
                return;
            }

            StringBuilder sb2 = new StringBuilder();
            sb2.Append("SELECT MAX(entdate)entdate FROM mrd_file_master where PatientID='" + lblIssuePatientID.Text + "'");
            DataTable dt = StockReports.GetDataTable(sb2.ToString());
            if (dt.Rows.Count > 0)
            {
                for (int j = 0; j < dt.Rows.Count; j++)
                {
                    lblDate.Text = Util.GetDateTime(dt.Rows[j]["EntDate"]).ToString("yyyy-MM-dd HH:mm:ss");
                }
            }

            StringBuilder sb3 = new StringBuilder();
            sb3.Append("SELECT * FROM mrd_file_master where PatientID='" + lblIssuePatientID.Text + "'and entdate='" + lblDate.Text + "'");
            DataTable dt1 = StockReports.GetDataTable(sb3.ToString());
            if (dt1.Rows.Count > 0)
            {
                for (int j = 0; j < dt1.Rows.Count; j++)
                {
                    lbltran.Text = Util.GetString(dt1.Rows[j]["TransactionID"].ToString());
                }
            }
            lblIssuePatientName.Text = ((Label)row.FindControl("lblPatientName")).Text.ToString();
            lblAppID.Text = ((Label)row.FindControl("lblAppID")).Text.ToString();
            txtIssueDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            DateTime con = Util.GetDateTime(((Label)row.FindControl("lblConfirmdate")).Text.ToString());
            calIssueDate.StartDate = Util.GetDateTime(con.ToString());
            mpopIssue.Show();

        }
        if (e.CommandName.ToString() == "FileReturn")
        {
            int index = Util.GetInt(e.CommandArgument.ToString());
            GridViewRow row = grdMRD.Rows[index];
            lblReturnPatientID.Text = ((Label)row.FindControl("lblMRNo")).Text.ToString();
             StringBuilder sb2 = new StringBuilder();
             sb2.Append("SELECT MAX(entdate)entdate FROM mrd_file_master where PatientID='" + lblReturnPatientID.Text + "'");
            DataTable dt = StockReports.GetDataTable(sb2.ToString());
            if (dt.Rows.Count > 0)
            {
                for (int j = 0; j < dt.Rows.Count; j++)
                {
                    lblDate.Text = Util.GetDateTime(dt.Rows[j]["EntDate"]).ToString("yyyy-MM-dd HH:mm:ss");
                }
            }

            StringBuilder sb3 = new StringBuilder();
            sb3.Append("SELECT * FROM mrd_file_master where PatientID='" + lblReturnPatientID.Text + "'and entdate='" + lblDate.Text + "'");
            DataTable dt1 = StockReports.GetDataTable(sb3.ToString());
            if (dt1.Rows.Count > 0)
            {
                for (int j = 0; j < dt1.Rows.Count; j++)
                {
                    lbltran.Text = Util.GetString(dt1.Rows[j]["TransactionID"].ToString());
                }
            }
            
            StringBuilder sb4 = new StringBuilder();
            sb4.Append("SELECT mam.Name Rackname,mrm.Name RoomName,mfm.rmid,mfm.almid,shelfno ,mfm.visittype FROM mrd_file_master mfm INNER JOIN mrd_room_master mrm ON mrm.RmID=mfm.RmID INNER JOIN mrd_almirah_master mam ON mfm.AlmID=mam.AlmID  WHERE PatientID='" + lblReturnPatientID.Text + "'and TransactionID='" + lbltran.Text + "'");
            DataTable dt4 = StockReports.GetDataTable(sb4.ToString());
            if (dt4.Rows.Count > 0)
            {
                for (int j = 0; j < dt4.Rows.Count; j++)
                {
                    if (dt4.Rows[j]["visittype"].ToString() == "Old Patient")
                    {
                        cmbRoom.SelectedIndex = cmbRoom.Items.IndexOf(cmbRoom.Items.FindByValue(dt4.Rows[0]["RmID"].ToString()));
                        BindAlmirah(Util.GetString(cmbRoom.SelectedItem.Value));
                        cmbAlmirah.SelectedIndex = cmbAlmirah.Items.IndexOf(cmbAlmirah.Items.FindByValue(dt4.Rows[0]["AlmID"].ToString()));
                        BindShelf(Util.GetString(cmbAlmirah.SelectedItem.Value));
                        cmbShelf.SelectedIndex = cmbShelf.Items.IndexOf(cmbShelf.Items.FindByValue(dt4.Rows[0]["ShelfNo"].ToString()));
                    }
                }
            }
            lblReturnPatientName.Text = ((Label)row.FindControl("lblPatientName")).Text.ToString();
            lbltran.Text = ((Label)row.FindControl("lblTransactionid")).Text.ToString();
            lblvisittype.Text = ((Label)row.FindControl("lblvisit")).Text.ToString();
            lblAppIDReturn.Text = ((Label)row.FindControl("lblAppID")).Text.ToString();
            txtReturnDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            calReturn.StartDate = Issuedate(lblReturnPatientID.Text, lblAppIDReturn.Text);
            mpopReturn.Show();
        }
        if (e.CommandName == "AViewDetail")
        {
            StringBuilder sb1 = new StringBuilder();
            StringBuilder sb2 = new StringBuilder();
            string PatientID = Util.GetString(e.CommandArgument).Split('#')[0];
            string App_ID = Util.GetString(e.CommandArgument).Split('#')[1];
            sb1.Append("SELECT DATE_FORMAT(issuedate,'%d-%b-%y')IssueDate ,issueremarks,DATE_FORMAT(returndate,'%d-%b-%y')Returndate,return_remarks FROM mrd_opd_fileStatus WHERE PatientID='" + PatientID + "' AND appointmentid='" + App_ID + "'");
            DataTable dtnew = StockReports.GetDataTable(sb1.ToString());
            sb2.Append("SELECT mam.Name Rackname,mrm.Name RoomName,mfm.rmid,mfm.almid,shelfno ,mfm.visittype FROM mrd_file_master mfm INNER JOIN mrd_room_master mrm ON mrm.RmID=mfm.RmID INNER JOIN mrd_almirah_master mam ON mfm.AlmID=mam.AlmID  WHERE PatientID='" + PatientID + "'");
            DataTable dt = StockReports.GetDataTable(sb2.ToString());
            if (dt.Rows.Count > 0)
            {
                for (int j = 0; j < dt.Rows.Count; j++)
                {
                    if (dt.Rows[j]["visittype"].ToString() == "Old Patient")
                    {
                        cmbRoom.SelectedIndex = cmbRoom.Items.IndexOf(cmbRoom.Items.FindByValue(dt.Rows[0]["RmID"].ToString()));
                        BindAlmirah(Util.GetString(cmbRoom.SelectedItem.Value));
                        cmbAlmirah.SelectedIndex = cmbAlmirah.Items.IndexOf(cmbAlmirah.Items.FindByValue(dt.Rows[0]["AlmID"].ToString()));
                        BindShelf(Util.GetString(cmbAlmirah.SelectedItem.Value));
                        cmbShelf.SelectedIndex = cmbShelf.Items.IndexOf(cmbShelf.Items.FindByValue(dt.Rows[0]["ShelfNo"].ToString()));
                        lblRoom.Visible = true;
                        lblRack.Visible = true;
                        lblshelf.Visible = true;
                        lblRoomno.Text = Util.GetString(dt.Rows[j]["RoomName"].ToString());
                        lblRackno.Text = Util.GetString(dt.Rows[j]["Rackname"].ToString());
                        lblShelfNo.Text = Util.GetString(dt.Rows[j]["shelfno"].ToString());
                    }
                    else  if (dt.Rows[j]["visittype"].ToString() == "New Patient")
                    {
                        lblRoom.Visible = true;
                        lblRack.Visible = true;
                        lblshelf.Visible = true;
                        lblRoomno.Text = Util.GetString(dt.Rows[j]["RoomName"].ToString());
                        lblRackno.Text = Util.GetString(dt.Rows[j]["Rackname"].ToString());
                        lblShelfNo.Text = Util.GetString(dt.Rows[j]["shelfno"].ToString());
                   }
                }
               
            }
            for (int i = 0; i < dtnew.Rows.Count; i++)
            {
                lblIssueDate.Text = Util.GetString(dtnew.Rows[i]["IssueDate"].ToString());
                lblIssueRemarks.Text = Util.GetString(dtnew.Rows[i]["issueremarks"].ToString());
                lblReturnDate.Text = Util.GetString(dtnew.Rows[i]["Returndate"].ToString());
                lblReturnRemarks.Text = Util.GetString(dtnew.Rows[i]["return_remarks"].ToString());
                
            }

            mpe2.Show();
        }
    }
    public DateTime  Issuedate(string Patientid,string AppID )
    {
        DateTime str = Util.GetDateTime(StockReports.ExecuteScalar("select IssueDate from mrd_opd_filestatus where PatientID='" + Patientid.ToString() + "' AND AppointmentID='" + AppID.ToString() + "' ").ToString());
        return str;
    }


    protected void grdMRD_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex > -1)
        {
            if (((Label)e.Row.FindControl("lblIssueStatus")).Text.ToUpper() == "TRUE")
            {
             
                ((Button)e.Row.FindControl("btnFileReturn")).Enabled = false;
                ((Button)e.Row.FindControl("btnFileIssue")).Enabled = true;
            }
            else
            {
                e.Row.Attributes.Add("style", "background-color:lightpink");
                ((Button)e.Row.FindControl("btnFileReturn")).Enabled = true;
                ((Button)e.Row.FindControl("btnFileIssue")).Enabled = false;
            }
            if (((Label)e.Row.FindControl("lblIssueStatus")).Text.ToUpper() == "FALSE" && ((Label)e.Row.FindControl("lblReturnStatus")).Text.ToUpper() == "FALSE")
            {
                e.Row.Attributes.Add("style", "background-color:lightgreen");
                ((Button)e.Row.FindControl("btnFileReturn")).Enabled = false;
                ((Button)e.Row.FindControl("btnFileIssue")).Enabled = false;
            }
            
        }

    }
    protected void btnIssueSave_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        string TID = lbltran.Text;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        try
        {
            if (TID != "")
            {
                StringBuilder sb3 = new StringBuilder();
                sb3.Append("SELECT * FROM mrd_file_master where TransactionID='" + TID + "'");
                DataTable dt1 = StockReports.GetDataTable(sb3.ToString());
                if (dt1.Rows.Count > 0)
                {
                    for (int j = 0; j < dt1.Rows.Count; j++)
                    {
                        lblissueroomno.Text = Util.GetString(dt1.Rows[j]["Rmid"].ToString());
                        lblissuerackno.Text = Util.GetString(dt1.Rows[j]["Almid"].ToString());
                        lblissueshelno.Text = Util.GetString(dt1.Rows[j]["Shelfno"].ToString());
                    }
                }

                string sql = "";
                sql = " update mrd_location_master set CurPos=CurPos -1 where RmID='" + lblissueroomno.Text + "' and AlmID='" + lblissuerackno.Text + "' and ShelfNo='" + lblissueshelno.Text.Split('$')[0] + "' ";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
            }
            if (txtIssueDate.Text != "" && txtIssueRemarks.Text.Trim() != "")
            {
                string sql = "Insert into  mrd_opd_fileStatus(PatientID,AppointmentID,Issue_By,IssueDate,IsIssue,IssueRemarks)values('" + lblIssuePatientID.Text + "','" + lblAppID.Text + "','" + Session["ID"].ToString() + "','" + Util.GetDateTime(txtIssueDate.Text).ToString("yyyy-MM-dd") + "',1,'" + txtIssueRemarks.Text.Trim() + "') ";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
            }
            else
            {
                lblIssue.Text = "Please Enter Issue Remarks";
                mpopIssue.Show();
                return;
            }
            tnx.Commit();
            search();
            txtIssueRemarks.Text = "";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);

        }
        catch(Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
        }
        finally
        {
            con.Close();
            con.Dispose();
            tnx.Dispose();
          
        }
    }
    public void BindShelf(string AlmID)
    {
        if (AlmID.ToString() != "Select")
        {
            string sql = " select distinct ShelfNo,concat(ShelfNo,'$',ifnull(CurPos,0)+1)ID from mrd_location_master  where AlmID = '" + AlmID + "' and  MaxPos > (CurPos+AdditionalNo) order by ShelfNo ";
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
            //BindShelf(Util.GetString(dt.Rows[0]["AlmID"]));
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
           // cmbAlmirah.Items.Insert(0, "Select");
           // cmbShelf.Items.Insert(0, "Select");
        }
    }
    protected void cmbAlmirah_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindShelf(Util.GetString(cmbAlmirah.SelectedItem.Value));
        lblReturn.Text = "";
    }
    protected void cmbRoom_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindAlmirah(Util.GetString(cmbRoom.SelectedItem.Value));
        lblReturn.Text = "";
    }

    protected void cmbShelf_SelectedIndexChanged(object sender, EventArgs e)
    {
        lblCounter.Text = Util.GetString(cmbShelf.SelectedItem.Value).Split('$')[1];
        lblReturn.Text = "";
    }

 
    protected void btnReturnSave_Click(object sender, EventArgs e)
    {
        
        lblReturn.Text="";
        if (cmbRoom.SelectedItem.Text == "Select")
         {
                lblReturn.Text = "Please Select room";
                mpopReturn.Show();
                return;
         }
        else if(cmbAlmirah.SelectedItem.Text == "Select")
            {
                lblReturn.Text = "Please Select Rack";
                mpopReturn.Show();
                return;
            }
        else if (cmbShelf.SelectedItem.Text=="Select")
        {
            lblReturn.Text = "Please Select Shelf";
            mpopReturn.Show();
            return;
        }
        else if (cmbShelf.SelectedItem.Text == "No Shelf Available")
        {
            lblReturn.Text = "No Shelf Available under This Rack";
            mpopReturn.Show();
            return;
        }


        DataTable dt = (DataTable)ViewState["dt"];
        string TID =lbltran.Text;
        
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        try
        {
           
            if (lblFileNo.Text.Trim().ToString() == "")
            {
                string BillDate = Util.GetDateTime(StockReports.ExecuteScalar("Select BillDate from f_ledgertransaction where TransactionID = '" + TID + "' limit 1")).ToString("yyyy-MM-dd");
               
                string sql = "insert into mrd_file_master(PatientID, TransactionID, " +
                              "  RmID, AlmID, ShelfNo, CurPos, Narration, UserID,VisitType ) " +
                              " values('" + lblReturnPatientID.Text + "', '" + TID + "', " +
                              "  '" + cmbRoom.SelectedItem.Value + "', '" + cmbAlmirah.SelectedItem.Value + "', '" + cmbShelf.SelectedItem.Value.Split('$')[0] + "', '" + lblCounter.Text.Trim() + "', '" + txtReturnRemarks.Text.Trim() + "', '" + ViewState["ID"].ToString() + "','"+lblvisittype.Text+"') ";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
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


                if (FileID == null || FileID == "")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblReturn.ClientID + "');", true);
                    tnx.Rollback();
                    con.Close();
                    con.Dispose();
                    return;
                }

                sql = "select count(*) from  mrd_location_master where RmID='" + cmbRoom.SelectedItem.Value + "' and AlmID='" + cmbAlmirah.SelectedItem.Value + "' and ShelfNo='" + cmbShelf.SelectedItem.Value.Split('$')[0] + "' and MaxPos>CurPos+AdditionalNo";
                int count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sql));

                if (count == 0)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM125','" + lblReturn.ClientID + "');", true);
                    tnx.Rollback();
                    con.Close();
                    con.Dispose();
                    return;
                }
                sql = " update mrd_location_master set CurPos=CurPos +1  where RmID='" + cmbRoom.SelectedItem.Value + "' and AlmID='" + cmbAlmirah.SelectedItem.Value + "' and ShelfNo='" + cmbShelf.SelectedItem.Value.Split('$')[0] + "' ";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
            }

            else
            {

                string BillDate = Util.GetDateTime(StockReports.ExecuteScalar("Select BillDate from f_ledgertransaction where TransactionID = '" + TID + "' limit 1")).ToString("yyyy-MM-dd");

                string sql = "update mrd_file_master set PatientID='" + Util.GetString(dt.Rows[0]["PatientID"]) + "', TransactionID= '" + TID + "', BillNo= '" + Util.GetString(dt.Rows[0]["BillNo"]) + "',BillDate='" + BillDate + "',  DischargeDateTime='" + Util.GetDateTime(Util.GetString(dt.Rows[0]["DateOfDischarge"])).ToString("yyyy-MM-dd") + "', " +
                              "  RmID= '" + cmbRoom.SelectedItem.Value + "', AlmID='" + cmbAlmirah.SelectedItem.Value + "', ShelfNo='" + cmbShelf.SelectedItem.Value.Split('$')[0] + "', CurPos='" + lblCounter.Text.Trim() + "', Narration='" + txtReturnRemarks.Text.Trim() + "', UserID='" + ViewState["ID"] + "' where   FileID='" + lblFileNo.Text.Trim().ToString() + "' ";

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);

                sql = "select count(*) from  mrd_location_master where RmID='" + cmbRoom.SelectedItem.Value + "' and AlmID='" + cmbAlmirah.SelectedItem.Value + "' and ShelfNo='" + cmbShelf.SelectedItem.Value.Split('$')[0] + "' and MaxPos>CurPos+AdditionalNo";
                int count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sql));

                if (count == 0)
                {

                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM125','" + lblReturn.ClientID + "');", true);
                    tnx.Rollback();
                    con.Close();
                    con.Dispose();
                    return;
                }
               

                sql = " update mrd_location_master set CurPos=CurPos +1 where RmID='" + cmbRoom.SelectedItem.Value + "' and AlmID='" + cmbAlmirah.SelectedItem.Value + "' and ShelfNo='" + cmbShelf.SelectedItem.Value.Split('$')[0] + "' ";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
              
            }

            
            lblReturn.Text = "";

            if (txtReturnDate.Text != "" && txtReturnRemarks.Text.Trim() != "")
            {
                string sql = "update  mrd_opd_fileStatus set Return_To='" + Session["ID"].ToString() + "',ReturnDate='" + Util.GetDateTime(txtReturnDate.Text).ToString("yyyy-MM-dd") + "',IsReturn=1,Return_Remarks='" + txtReturnRemarks.Text.Trim() + "' ";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
            }
            else
            {
                lblReturn.Text = "Please Enter Return Remarks";
                mpopReturn.Show();
                return;
            }
            tnx.Commit();
            search();
            txtReturnRemarks.Text = "";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
            

        }
    }
  
}