using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;

public partial class Design_OT_PRE_Op_Flow_Sheet : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["UserID"] = Session["ID"].ToString();
            ViewState["PID"] = Request.QueryString["PID"];
            ViewState["TID"] = Request.QueryString["TID"];
            ViewState["Patient_surgery_ID"] = Request.QueryString["OTBookingID"].ToString();
            //ViewState["IsViewable"] = Request.QueryString["IsViewable"];
            BindPrep();
            BindBelong();
            BindRoom();
            BindMedicine();
           // BindMedicineGrid();
            BindCancelled();
            BindLastUpdateddetail();
            BindGrid();
        }
    }
    public void BindLastUpdateddetail()
    {
        DataTable dtBy = StockReports.GetDataTable("Select (select concat(title,' ',name) from employee_master where employeeID=EntryBy)UdateBy,DATE_FORMAT(EntryDate,'%d-%b-%y %h:%i %p')CreatedDate from Ot_Preparation_Detail where Patient_surgery_ID='" + ViewState["Patient_surgery_ID"].ToString() + "'");
        if (dtBy.Rows.Count > 0)
        {
            lblUserName.Text = "Last Updated By :" + dtBy.Rows[0]["UdateBy"].ToString() + " At " + dtBy.Rows[0]["CreatedDate"].ToString();
        }
    }
    private void IsDoctor()
    {
        /*
        string str = "SELECT COUNT(*) FROM doctor_employee WHERE Employeeid='" + Session["ID"] + "'";
        string res = StockReports.ExecuteScalar(str);
        if (Convert.ToInt32(res) > 0)
            btnApprove.Visible = true;
        else
            btnApprove.Visible = false;
         */
    }

    private void BindCancelled()
    {
        string str = "SELECT ocm.ID,ocm.Title,ocd.TitleDetail,IF(DATE_FORMAT(ocd.Date, '%d-%b-%Y') = '01-Jan-0001','',DATE_FORMAT(ocd.Date, '%d-%b-%Y')) AS 'Date',IF(DATE_FORMAT(ocd.Date, '%d-%b-%Y') = '01-Jan-0001','',TIME_FORMAT(ocd.Time, '%h:%m %p')) AS 'Time' FROM ot_cancelled_master ocm LEFT JOIN ot_cancelled_detail ocd ON ocm.ID=ocd.TitleID AND ocd.Patient_surgery_ID='" + ViewState["Patient_surgery_ID"].ToString() + "'";
        DataTable oDT = StockReports.GetDataTable(str);
        grdCancelled.DataSource = oDT;
        grdCancelled.DataBind();
        if (oDT.Rows.Count > 0)
        {
            for (int i = 0; i < oDT.Rows.Count; i++)
            {
                ((TextBox)grdCancelled.Rows[i].FindControl("ucDate")).Attributes.Add("readOnly", "true");
            }
            IsDoctor();
            btnPrint.Visible = true;
        }
    }
    private void BindMedicineGrid()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT itm.Typename Medicine,opm.NoOfDays Days,opm.NoTimesDay Time,opm.Dose,itm.ItemID MedicineID FROM ot_patient_medicine opm ");
        sb.Append("  LEFT JOIN f_itemmaster itm ON itm.ItemID=opm.Medicine_ID WHERE Patient_surgery_ID='" + ViewState["Patient_surgery_ID"] + "' and opm.Type='PreOP'");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        grdMedicine.DataSource = dt;
        grdMedicine.DataBind();
        ViewState["Medicine"] = dt;
        if (dt.Rows.Count > 0)
        {
            IsDoctor();
            btnPrint.Visible = true;
        }
    }
    private void BindMedicine()
    {
        StringBuilder sb = new StringBuilder();
        //sb.Append(" SELECT concat(IfNull(im.ItemCode,''),'#',IfNull(IM.Typename,''))ItemName,IM.ItemID ItemID from f_itemmaster IM inner join f_subcategorymaster SM on IM.SubCategoryID = SM.SubCategoryID inner join f_configrelation CR on SM.CategoryID = CR.CategoryID  LEFT JOIN (SELECT IF(sum(InitialCount-ReleasedCount)>0,sum(InitialCount-ReleasedCount),0)  Qty,ItemID FROM f_stock WHERE ispost=1 and DeptLedgerNo='LSHHI17' GROUP BY ITemID)st ON st.itemID = im.ItemID  WHERE CR.ConfigID = 11 AND im.IsActive=1 AND im.SubCategoryID IN ('LSHHI127','LSHHI128','LSHHI129','LSHHI130','LSHHI131','LSHHI132','LSHHI133','LSHHI134','LSHHI135','LSHHI136','LSHHI137','LSHHI138','LSHHI139','LSHHI140','LSHHI141','LSHHI142','LSHHI143','LSHHI144','LSHHI145','LSHHI146','LSHHI147','LSHHI148','LSHHI149','LSHHI150','LSHHI151','LSHHI152','LSHHI153','LSHHI154','LSHHI155','LSHHI156') order by IM.Typename ");
        sb.Append(" SELECT concat(IfNull(im.ItemCode,''),'#',IfNull(IM.Typename,''))ItemName,IM.ItemID ItemID from f_itemmaster IM inner join f_subcategorymaster SM on IM.SubCategoryID = SM.SubCategoryID inner join f_configrelation CR on SM.CategoryID = CR.CategoryID  LEFT JOIN (SELECT IF(sum(InitialCount-ReleasedCount)>0,sum(InitialCount-ReleasedCount),0)  Qty,ItemID FROM f_stock WHERE ispost=1 GROUP BY ITemID)st ON st.itemID = im.ItemID  WHERE CR.ConfigID = 11 AND im.IsActive=1  order by IM.Typename ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            lstInv.DataSource = dt;
            lstInv.DataTextField = "ItemName";
            lstInv.DataValueField = "ItemID";
            lstInv.DataBind();

        }
        else
        {
            lblmsg.Text = "No Medicine Found";
            lstInv.Items.Clear();
        }

        ddldose.DataSource = AllGlobalFunction.MedicineTab;
        ddldose.DataBind();

        ddlTime.DataSource = AllGlobalFunction.MedicineTimes;
        ddlTime.DataBind();

        ddlDays.DataSource = AllGlobalFunction.MedicineDays;
        ddlDays.DataBind();

    }

    private void BindPrep()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT otm.id,otm.Name,if(otm.IsWard=1,true,false)IsWard,if(otm.IsPac=1,true,false)IsPac,if(otm.IsOT=1,true,false)IsOT,");
        sb.Append(" otd.Ward,otd.PAC,otd.OT,otd.WardComment,otd.PacComment,otd.OTComment FROM Ot_Preparation_Master otm  LEFT JOIN  Ot_Preparation_Detail otd ON otd.ItemID=otm.ID AND otd.Patient_surgery_ID='" + ViewState["Patient_surgery_ID"].ToString() + "' ORDER BY otm.ID");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            if (dt.Rows.Count > 0)
                IsDoctor();
            btnPrint.Visible = true;
            gridPrep.DataSource = dt;
            gridPrep.DataBind();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                int chkWard = 0;
                chkWard = Util.GetInt(dt.Rows[i]["Ward"].ToString());
                int chkPac = 0;
                chkPac = Util.GetInt(dt.Rows[i]["PAC"].ToString());
                int chkOt = 0;
                chkOt = Util.GetInt(dt.Rows[i]["OT"].ToString());
                if (chkWard != 0)
                {
                    (((CheckBox)gridPrep.Rows[i].FindControl("chkWardPrep")).Checked) = true;
                }
                if (chkPac != 0)
                {
                    (((CheckBox)gridPrep.Rows[i].FindControl("chkPACPrep")).Checked) = true;
                }
                if (chkOt != 0)
                {
                    (((CheckBox)gridPrep.Rows[i].FindControl("chkOTPrep")).Checked) = true;
                }

            }
        }
    }

    private void BindBelong()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT obm.id,obm.Name,if(obm.IsWard=1,true,false)IsWard,if(obm.IsPac=1,true,false)IsPac,if(obm.IsOT=1,true,false)IsOT ");
        sb.Append(" ,obd.Ward,obd.PAC,obd.OT,obd.WardComment,obd.PacComment,obd.OTComment FROM Ot_Belongings_Master obm left join ot_belongings_detail obd ON obd.ItemID=obm.ID AND obd.Patient_surgery_ID='" + ViewState["Patient_surgery_ID"].ToString() + "' ORDER BY obm.ID");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            gridBelong.DataSource = dt;
            gridBelong.DataBind();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                int chkWard = 0;
                chkWard = Util.GetInt(dt.Rows[i]["Ward"].ToString());
                int chkPac = 0;
                chkPac = Util.GetInt(dt.Rows[i]["PAC"].ToString());
                int chkOt = 0;
                chkOt = Util.GetInt(dt.Rows[i]["OT"].ToString());
                if (chkWard != 0)
                {
                    (((CheckBox)gridBelong.Rows[i].FindControl("chkWardBelong")).Checked) = true;
                }
                if (chkPac != 0)
                {
                    (((CheckBox)gridBelong.Rows[i].FindControl("chkPACBelong")).Checked) = true;
                }
                if (chkOt != 0)
                {
                    (((CheckBox)gridBelong.Rows[i].FindControl("chkOTBelong")).Checked) = true;
                }

            }
            btnPrint.Visible = true;
            IsDoctor();
        }

    }

    private void BindRoom()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT orpm.id,orpm.Name,if(orpm.IsWard=1,true,false)IsWard,if(orpm.IsPac=1,true,false)IsPac,if(orpm.IsOT=1,true,false)IsOT, ");
        sb.Append(" orpd.Ward,orpd.PAC,orpd.OT,orpd.WardComment,orpd.PacComment,orpd.OTComment FROM Ot_Room_Prep_Master orpm left join ot_room_prep_detail orpd ON orpd.ItemID=orpm.ID  AND orpd.Patient_surgery_ID='" + ViewState["Patient_surgery_ID"].ToString() + "' ORDER BY orpm.ID");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            grdRoom.DataSource = dt;
            grdRoom.DataBind();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                int chkWard = 0;
                chkWard = Util.GetInt(dt.Rows[i]["Ward"].ToString());
                int chkPac = 0;
                chkPac = Util.GetInt(dt.Rows[i]["PAC"].ToString());
                int chkOt = 0;
                chkOt = Util.GetInt(dt.Rows[i]["OT"].ToString());
                if (chkWard != 0)
                {
                    (((CheckBox)grdRoom.Rows[i].FindControl("chkWardRoom")).Checked) = true;
                }
                if (chkPac != 0)
                {
                    (((CheckBox)grdRoom.Rows[i].FindControl("chkPACRoom")).Checked) = true;
                }
                if (chkOt != 0)
                {
                    (((CheckBox)grdRoom.Rows[i].FindControl("chkOTRoom")).Checked) = true;
                }
            }
            IsDoctor();
            btnPrint.Visible = true;
        }
    }

    private DataTable GetMedicine()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("Medicine");
        dt.Columns.Add("MedicineID");
        dt.Columns.Add("Days");
        dt.Columns.Add("Time");
        dt.Columns.Add("Dose");
        dt.Columns.Add("Date");
        dt.Columns.Add("Outsource");

        return dt;
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        if (lstInv.SelectedIndex < 0)
        {
            lstInv.Focus();
            lblmsg.Text = "Please Select Medicine";
            return;
        }
        if (ddldose.SelectedItem.Text == "")
        {
            ddldose.Focus();
            lblmsg.Text = "Please Select Dose";
            return;
        }
        if (ddlTime.SelectedItem.Text == "")
        {
            ddlTime.Focus();
            lblmsg.Text = "Please Select Times";
            return;
        }
        if (ddlDays.SelectedItem.Text == "")
        {
            ddlDays.Focus();
            lblmsg.Text = "Please Select Days";
            return;
        }

        foreach (GridViewRow row in grdMedicine.Rows)
        {
            string Medicine = ((Label)row.FindControl("lblMedicine")).Text;
            if (Util.GetString(lstInv.SelectedItem.Text) == Medicine)
            {
                lblmsg.Text = "Medicine Already Selected";
                return;
            }
        }

        if (lstInv.SelectedItem.Text != "")
        {

            DataTable dt = new DataTable();
            if (ViewState["Medicine"] != null)
            {
                dt = (DataTable)ViewState["Medicine"];
            }
            else
                dt = GetMedicine();
            DataRow dr = dt.NewRow();
            dr["Medicine"] = lstInv.SelectedItem.Text;
            dr["MedicineID"] = lstInv.SelectedValue;
            dr["Days"] = ddlDays.SelectedItem.Text;
            dr["Time"] = ddlTime.SelectedItem.Text;
            dr["Dose"] = ddldose.SelectedItem.Text;
            dt.Rows.Add(dr);
            ViewState["Medicine"] = dt;
            grdMedicine.DataSource = dt;
            grdMedicine.DataBind();
            btnSave.Visible = true;

            //lblMsg.Text = "Medicine Added Successfully";
            BindMedicine();
        }
        else
        {
            lblmsg.Text = "select Medicine";
        }

    }

    protected void grdMedicine_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "imbRemove")
        {
            int index = Util.GetInt(e.CommandArgument);
            DataTable dt = (DataTable)ViewState["Medicine"];
            dt.Rows.RemoveAt(index);
            dt.AcceptChanges();
            ViewState["Medicine"] = dt;
            grdMedicine.DataSource = dt;
            grdMedicine.DataBind();
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Delete from ot_preparation_detail  where Patient_surgery_ID='" + ViewState["Patient_surgery_ID"].ToString() + "'");

            for (int i = 0; i < gridPrep.Rows.Count; i++)
            {

                int chkWard = 0, chkPAC = 0, chkOT = 0;
                string Items = ((Label)gridPrep.Rows[i].FindControl("lblItemsPrep")).Text;
                int ID = Util.GetInt(((Label)gridPrep.Rows[i].FindControl("lblIDPrep")).Text);
                if (((CheckBox)gridPrep.Rows[i].FindControl("chkWardPrep")).Checked)
                {
                    chkWard = 1;
                }
                if (((CheckBox)gridPrep.Rows[i].FindControl("chkPACPrep")).Checked)
                {
                    chkPAC = 1;
                }
                if (((CheckBox)gridPrep.Rows[i].FindControl("chkOTPrep")).Checked)
                {
                    chkOT = 1;
                }
                int chk = chkWard + chkPAC + chkOT;

                string WardComment = ((TextBox)gridPrep.Rows[i].FindControl("txtWardCommentPrep")).Text;
                string PacComment = ((TextBox)gridPrep.Rows[i].FindControl("txtPacCommentPrep")).Text;
                string OtComment = ((TextBox)gridPrep.Rows[i].FindControl("txtOtCommentPrep")).Text;
                if (chk > 0 || WardComment != "" || PacComment != "" || OtComment != "")
                {

                    string strPrep = "insert into ot_preparation_detail(TransactionID,ItemID,Ward,PAC,OT,EntryBy,WardComment,PacComment,OTComment,Patient_surgery_ID) " +
                        " values('" + ViewState["TID"] + "','" + ID + "','" + chkWard + "','" + chkPAC + "','" + chkOT + "','" + ViewState["UserID"] + "', " +
                    " '" + WardComment + "','" + PacComment + "','" + OtComment + "','" + Util.GetInt(ViewState["Patient_surgery_ID"]) + "')";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strPrep);


                }
            }
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Delete from ot_belongings_detail  where Patient_surgery_ID='" + ViewState["Patient_surgery_ID"].ToString() + "'");

            for (int i = 0; i < gridBelong.Rows.Count; i++)
            {
                int chkWard = 0, chkPAC = 0, chkOT = 0;
                string Items = ((Label)gridBelong.Rows[i].FindControl("lblItemsBelong")).Text;
                int ID = Util.GetInt(((Label)gridBelong.Rows[i].FindControl("lblIDBelong")).Text);
                if (((CheckBox)gridBelong.Rows[i].FindControl("chkWardBelong")).Checked)
                {
                    chkWard = 1;
                }
                if (((CheckBox)gridBelong.Rows[i].FindControl("chkPACBelong")).Checked)
                {
                    chkPAC = 1;
                }
                if (((CheckBox)gridBelong.Rows[i].FindControl("chkOTBelong")).Checked)
                {
                    chkOT = 1;
                }
                int chk = chkWard + chkPAC + chkOT;

                string WardComment = ((TextBox)gridBelong.Rows[i].FindControl("txtWardCommentBelong")).Text;
                string PacComment = ((TextBox)gridBelong.Rows[i].FindControl("txtPacCommentBelong")).Text;
                string OtComment = ((TextBox)gridBelong.Rows[i].FindControl("txtOtCommentBelong")).Text;
                if (chk > 0 || WardComment != "" || PacComment != "" || OtComment != "")
                {


                    string strBelong = "insert into ot_belongings_detail(TransactionID,ItemID,Ward,PAC,OT,EntryBy,WardComment,PacComment,OTComment,Patient_surgery_ID)" +
                        " values('" + ViewState["TID"] + "','" + ID + "','" + chkWard + "','" + chkPAC + "','" + chkOT + "','" + ViewState["UserID"] + "', " +
                     " '" + WardComment + "','" + PacComment + "','" + OtComment + "','" + Util.GetInt(ViewState["Patient_surgery_ID"]) + "')";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strBelong);


                }
            }
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Delete from  ot_room_prep_detail  where Patient_surgery_ID='" + ViewState["Patient_surgery_ID"].ToString() + "'");

            for (int i = 0; i < grdRoom.Rows.Count; i++)
            {
                int chkWard = 0, chkPAC = 0, chkOT = 0;
                string Items = ((Label)grdRoom.Rows[i].FindControl("lblItemsRoom")).Text;
                int ID = Util.GetInt(((Label)grdRoom.Rows[i].FindControl("lblIDRoom")).Text);
                if (((CheckBox)grdRoom.Rows[i].FindControl("chkWardRoom")).Checked)
                {
                    chkWard = 1;
                }
                if (((CheckBox)grdRoom.Rows[i].FindControl("chkPACRoom")).Checked)
                {
                    chkPAC = 1;
                }
                if (((CheckBox)grdRoom.Rows[i].FindControl("chkOTRoom")).Checked)
                {
                    chkOT = 1;
                }
                int chk = chkWard + chkPAC + chkOT;
                string WardComment = ((TextBox)grdRoom.Rows[i].FindControl("txtWardCommentRoom")).Text;
                string PacComment = ((TextBox)grdRoom.Rows[i].FindControl("txtPacCommentRoom")).Text;
                string OtComment = ((TextBox)grdRoom.Rows[i].FindControl("txtOtCommentRoom")).Text;
                if (chk > 0 || WardComment != "" || PacComment != "" || OtComment != "")
                {


                    string strRoom = "insert into ot_room_prep_detail(TransactionID,ItemID,Ward,PAC,OT,EntryBy,WardComment,PacComment,OTComment,Patient_surgery_ID)" +
                        " values('" + ViewState["TID"] + "','" + ID + "','" + chkWard + "','" + chkPAC + "','" + chkOT + "','" + ViewState["UserID"] + "', " +
                      " '" + WardComment + "','" + PacComment + "','" + OtComment + "','" + Util.GetInt(ViewState["Patient_surgery_ID"]) + "')";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strRoom);


                }

            }
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Delete from ot_patient_medicine  where Patient_surgery_ID='" + ViewState["Patient_surgery_ID"].ToString() + "' and Type='PreOP'");

            for (int i = 0; i < grdMedicine.Rows.Count; i++)
            {
                string Medicine_ID = ((Label)grdMedicine.Rows[i].FindControl("lblid")).Text;
                string NoOfDays = ((Label)grdMedicine.Rows[i].FindControl("lblDays")).Text;
                string NoTimesDay = ((Label)grdMedicine.Rows[i].FindControl("lblTimes")).Text;
                string Dose = ((Label)grdMedicine.Rows[i].FindControl("lblDose")).Text;


                string strMedicine = "INSERT INTO ot_patient_medicine(TransactionID,Medicine_ID,NoOfDays,NoTimesDay,Dose,EntryBy,Type,Patient_surgery_ID) values('" + ViewState["TID"] + "','" + Medicine_ID + "','" + NoOfDays + "','" + NoTimesDay + "','" + Dose + "','" + ViewState["UserID"] + "','PreOP','" + Util.GetInt(ViewState["Patient_surgery_ID"]) + "')";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strMedicine);

            }

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Delete from ot_cancelled_detail  where Patient_surgery_ID='" + ViewState["Patient_surgery_ID"].ToString() + "'");
            for (int i = 0; i < grdCancelled.Rows.Count; i++)
            {
                string TitleID = ((Label)grdCancelled.Rows[i].FindControl("lblID")).Text;
                string TitleDetail = ((TextBox)grdCancelled.Rows[i].FindControl("txtTitleDetail")).Text;
                string Date = ((TextBox)grdCancelled.Rows[i].FindControl("ucDate")).Text;
                string Time = ((TextBox)grdCancelled.Rows[i].FindControl("txtTime")).Text;

                string qry = "INSERT INTO ot_cancelled_detail(TransactionID,TitleID,TitleDetail,Date,Time,EnterBy,Patient_surgery_ID) values('" + ViewState["TID"] + "'," + TitleID + ",'" + TitleDetail + "','" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(Time).ToString("HH:mm") + "','" + Session["ID"] + "','" + Util.GetInt(ViewState["Patient_surgery_ID"]) + "')";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, qry);
            }

            tnx.Commit();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmsg.ClientID + "');", true);
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

    protected void gridPrep_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (Session["LoginType"].ToString() == "OR")
            {
                ((TextBox)e.Row.FindControl("txtWardCommentPrep")).Enabled = false;
                ((CheckBox)e.Row.FindControl("chkWardPrep")).Enabled = false;
                ((TextBox)e.Row.FindControl("txtPacCommentPrep")).Enabled = false;
                ((CheckBox)e.Row.FindControl("chkPACPrep")).Enabled = false;

            }
            else if (Session["LoginType"].ToString() == "ICU")
            {
                ((TextBox)e.Row.FindControl("txtWardCommentPrep")).Enabled = false;
                ((CheckBox)e.Row.FindControl("chkWardPrep")).Enabled = false;
                ((TextBox)e.Row.FindControl("txtOtCommentPrep")).Enabled = false;
                ((CheckBox)e.Row.FindControl("chkOTPrep")).Enabled = false;
            }
            else if (Session["LoginType"].ToString() == "2 BED WARD")
            {
                ((TextBox)e.Row.FindControl("txtPacCommentPrep")).Enabled = false;
                ((CheckBox)e.Row.FindControl("chkPACPrep")).Enabled = false;
                ((TextBox)e.Row.FindControl("txtOtCommentPrep")).Enabled = false;
                ((CheckBox)e.Row.FindControl("chkOTPrep")).Enabled = false;

            }
            else if (Session["LoginType"].ToString() == "4 BED WARD")
            {
                ((TextBox)e.Row.FindControl("txtPacCommentPrep")).Enabled = false;
                ((CheckBox)e.Row.FindControl("chkPACPrep")).Enabled = false;
                ((TextBox)e.Row.FindControl("txtOtCommentPrep")).Enabled = false;
                ((CheckBox)e.Row.FindControl("chkOTPrep")).Enabled = false;

            }
            else if (Session["LoginType"].ToString() == "EXT. STAY")
            {
                ((TextBox)e.Row.FindControl("txtPacCommentPrep")).Enabled = false;
                ((CheckBox)e.Row.FindControl("chkPACPrep")).Enabled = false;
                ((TextBox)e.Row.FindControl("txtOtCommentPrep")).Enabled = false;
                ((CheckBox)e.Row.FindControl("chkOTPrep")).Enabled = false;

            }
            
        }
    }

    protected void gridBelong_RowDataBound(object sender, GridViewRowEventArgs e)
    {

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (Session["LoginType"].ToString() == "OR")
            {
                ((TextBox)e.Row.FindControl("txtWardCommentBelong")).Enabled = false;
                ((CheckBox)e.Row.FindControl("chkWardBelong")).Enabled = false;
                ((TextBox)e.Row.FindControl("txtPacCommentBelong")).Enabled = false;
                ((CheckBox)e.Row.FindControl("chkPACBelong")).Enabled = false;

            }
            else if (Session["LoginType"].ToString() == "ICU")
            {
                ((TextBox)e.Row.FindControl("txtWardCommentBelong")).Enabled = false;
                ((CheckBox)e.Row.FindControl("chkWardBelong")).Enabled = false;
                ((TextBox)e.Row.FindControl("txtOtCommentBelong")).Enabled = false;
                ((CheckBox)e.Row.FindControl("chkOTBelong")).Enabled = false;
            }
            else if (Session["LoginType"].ToString() == "2 BED WARD")
            {
                ((TextBox)e.Row.FindControl("txtPacCommentBelong")).Enabled = false;
                ((CheckBox)e.Row.FindControl("chkPACBelong")).Enabled = false;
                ((TextBox)e.Row.FindControl("txtOtCommentBelong")).Enabled = false;
                ((CheckBox)e.Row.FindControl("chkOTBelong")).Enabled = false;
            }
            else if (Session["LoginType"].ToString() == "4 BED WARD")
            {
                ((TextBox)e.Row.FindControl("txtPacCommentBelong")).Enabled = false;
                ((CheckBox)e.Row.FindControl("chkPACBelong")).Enabled = false;
                ((TextBox)e.Row.FindControl("txtOtCommentBelong")).Enabled = false;
                ((CheckBox)e.Row.FindControl("chkOTBelong")).Enabled = false;

            }
            else if (Session["LoginType"].ToString() == "EXT. STAY")
            {
                ((TextBox)e.Row.FindControl("txtPacCommentBelong")).Enabled = false;
                ((CheckBox)e.Row.FindControl("chkPACBelong")).Enabled = false;
                ((TextBox)e.Row.FindControl("txtOtCommentBelong")).Enabled = false;
                ((CheckBox)e.Row.FindControl("chkOTBelong")).Enabled = false;

            }
        }
    }

    protected void grdRoom_RowDataBound(object sender, GridViewRowEventArgs e)
    {

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (Session["LoginType"].ToString() == "OR")
            {
                ((TextBox)e.Row.FindControl("txtWardCommentRoom")).Enabled = false;
                ((CheckBox)e.Row.FindControl("chkWardRoom")).Enabled = false;
                ((TextBox)e.Row.FindControl("txtPacCommentRoom")).Enabled = false;
                ((CheckBox)e.Row.FindControl("chkPACRoom")).Enabled = false;

            }
            else if (Session["LoginType"].ToString() == "ICU")
            {
                ((TextBox)e.Row.FindControl("txtWardCommentRoom")).Enabled = false;
                ((CheckBox)e.Row.FindControl("chkWardRoom")).Enabled = false;
                ((TextBox)e.Row.FindControl("txtOtCommentRoom")).Enabled = false;
                ((CheckBox)e.Row.FindControl("chkOTRoom")).Enabled = false;
            }
            else if (Session["LoginType"].ToString() == "2 BED WARD")
            {
                ((TextBox)e.Row.FindControl("txtPacCommentRoom")).Enabled = false;
                ((CheckBox)e.Row.FindControl("chkPACRoom")).Enabled = false;
                ((TextBox)e.Row.FindControl("txtOtCommentRoom")).Enabled = false;
                ((CheckBox)e.Row.FindControl("chkOTRoom")).Enabled = false;
            }
            else if (Session["LoginType"].ToString() == "4 BED WARD")
            {
                ((TextBox)e.Row.FindControl("txtPacCommentRoom")).Enabled = false;
                ((CheckBox)e.Row.FindControl("chkPACRoom")).Enabled = false;
                ((TextBox)e.Row.FindControl("txtOtCommentRoom")).Enabled = false;
                ((CheckBox)e.Row.FindControl("chkOTRoom")).Enabled = false;
            }
            else if (Session["LoginType"].ToString() == "EXT. STAY")
            {
                ((TextBox)e.Row.FindControl("txtPacCommentRoom")).Enabled = false;
                ((CheckBox)e.Row.FindControl("chkPACRoom")).Enabled = false;
                ((TextBox)e.Row.FindControl("txtOtCommentRoom")).Enabled = false;
                ((CheckBox)e.Row.FindControl("chkOTRoom")).Enabled = false;
            }
        }
    }

    private void bindCondition()
    {


    }

    protected void btnPrint_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "window.open('../OT/PRE/Op_Flow_Sheet_Report.aspx?TID=" + ViewState["TID"] + "');", true);
    }
    protected void grisearch_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName.ToString() == "btnPrint")
        {
            string Patient_surgery_id = e.CommandArgument.ToString().Split('#')[1];
            ViewState["Patient_surgery_ID"] = Patient_surgery_id;
            BindPrep();
            BindBelong();
            BindRoom();
            
           // BindMedicineGrid();
            BindCancelled();
            BindLastUpdateddetail();
            
            btnSave.Enabled = false;
        }
    }
    private void BindGrid()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT IsClosed,cse.Patient_surgery_ID,cps.TransactionID,CAST(GROUP_CONCAT(cps.itemName) AS CHAR) Surgery,CAST(GROUP_CONCAT(cps.ItemID) AS CHAR) CPTCode,CONCAT(em.Title,em.Name) AS 'Name',cse.IsApprove,cse.IsClosed,DATE_FORMAT(cse.EntryDate,'%d-%M-%Y') AS EnterDate ");
        sb.Append(" FROM cpoe_surgery_estimate cse ");
        sb.Append(" INNER JOIN cpoe_procedure_surgery cps ON cps.Patient_surgery_ID = cse.Patient_surgery_ID ");
        sb.Append(" INNER JOIN patient_master pm ON pm.PatientID = cse.PatientID ");
        sb.Append(" INNER JOIN employee_master em ON cse.UserID=em.EmployeeID ");
        sb.Append(" WHERE cse.IPDNo='" + ViewState["TID"].ToString() + "' ");
        sb.Append(" GROUP BY  cse.Patient_surgery_ID   ORDER BY cse.EntryDate DESC");
        DataTable oDT = StockReports.GetDataTable(sb.ToString());
        grisearch.DataSource = oDT;
        grisearch.DataBind();
        for (int i = 0; i < oDT.Rows.Count; i++)
        {
            if (oDT.Rows[i]["IsClosed"].ToString() == "1")
            {
                grisearch.Rows[i].BackColor = System.Drawing.Color.LightBlue;
            }
        }
    }
}