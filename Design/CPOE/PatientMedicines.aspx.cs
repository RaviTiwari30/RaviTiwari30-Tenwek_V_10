using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_CPOE_PatientMedicines : System.Web.UI.Page
{
    private int count;
    private string DoctorID = string.Empty;

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (lstInv.SelectedItem.Text == "")
        {
            lstInv.Focus();
            lblMsg.Text = "Please Select Medicine";
            return;
        }
        //if (txtDose.Text == "")
        //{
        //    txtDose.Focus();
        //    lblMsg.Text = "Please Select Dose";
        //    return;
        //}
        //if (ddlTime.SelectedItem.Text == "")
        //{
        //    ddlTime.Focus();
        //    lblMsg.Text = "Please Select Times";
        //    return;
        //}
        //if (ddlDays.SelectedItem.Text == "")
        //{
        //    ddlDays.Focus();
        //    lblMsg.Text = "Please Select Days";
        //    return;
        //}

        foreach (GridViewRow row in grdMedicine.Rows)
        {
            string Medicine = ((Label)row.FindControl("lblMedicine")).Text;
            if ((Util.GetString(lstInv.SelectedItem.Text) == Medicine) && (Medicine != "Other"))
            {
                lblMsg.Text = "Medicine Already Selected";
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
            if (lstInv.SelectedItem.Text != "Other")
                dr["Medicine"] = lstInv.SelectedItem.Text.Split('#')[1];
            else
                dr["Medicine"] = "";
            dr["MedicineID"] = lstInv.SelectedValue.Split('#')[0];
            dr["Days"] = ddlDays.SelectedItem.Text;
            dr["Time"] = ddlTime.SelectedItem.Text;
            dr["Dose"] = txtDose.Text.Trim();
            dr["Remarks"] = txtRemarks.Text.Trim();
            dr["Meal"] = ddlMeal.SelectedItem.Text;
            dr["Quantity"] = txtquantity.Text.Trim();
            dt.Rows.Add(dr);

            for (int i = 0; i < grdMedicine.Rows.Count; i++)
            {
                dt.Rows[i]["Medicine"] = ((TextBox)grdMedicine.Rows[i].FindControl("txtMedicine")).Text.Trim();
                dt.Rows[i]["MedicineID"] = ((Label)grdMedicine.Rows[i].FindControl("lblid")).Text.Trim();
                dt.Rows[i]["Days"] = ((Label)grdMedicine.Rows[i].FindControl("lblDays")).Text.Trim();
                dt.Rows[i]["Time"] = ((Label)grdMedicine.Rows[i].FindControl("lblTimes")).Text;
                dt.Rows[i]["Dose"] = ((Label)grdMedicine.Rows[i].FindControl("lblDose")).Text;
                dt.Rows[i]["Remarks"] = ((Label)grdMedicine.Rows[i].FindControl("lblRemarks")).Text;
                dt.Rows[i]["Meal"] = ((Label)grdMedicine.Rows[i].FindControl("lblMeal")).Text;
                dt.Rows[i]["Quantity"] = ((Label)grdMedicine.Rows[i].FindControl("lblQuantity")).Text;
            }
            if (dt != null && dt.Rows.Count > 0)
            {
                dt.AcceptChanges();
            }

            ViewState["Medicine"] = dt;
            grdMedicine.DataSource = dt;
            grdMedicine.DataBind();

            btnSave.Visible = true;
            txtDose.Text = "";
            txtRemarks.Text = "";
            txtquantity.Text = "1";
            ddlDays.SelectedIndex = -1;
            ddlTime.SelectedIndex = -1;
            if (rdoType.SelectedValue == "0")
                BindMedicine();
            else
                BindGeneric();
            txtSearch.Text = "";
        }
        else
        {
            lblMsg.Text = "Please Select Medicine";
        }
        txtSearch.Focus();
    }

    protected void btnNew_Click(object sender, EventArgs e)
    {
        if (ddlItems.Items.Count < 1)
            BindNewMedicine();
        mpeItems.Show();
    }

    protected void btnNewMed_Click(object sender, EventArgs e)
    {
        lblMedicine.Text = "";
        mpeNewMed.Show();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (SaveData() == "1")
        {
            bindPreMedicine();
            grdMedicine.DataSource = null;
            grdMedicine.DataBind();
            btnSave.Visible = false;
            txtRemarks.Text = "";
            lblMsg.Text = "Record Saved Successfully";
            int abcd2 = count;
        }
        else if (count > 0)
        {
            lblMsg.Text = "Medicine Already Prescribed";
        }
        else
            lblMsg.Text = "Please Enter Medicine Name";
    }

    protected void btnSaveMed_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into doctor_medicine(DoctorID,ItemID) values('" + lblDoctor.Text.Trim() + "','" + ddlItems.SelectedValue + "')");
            lblMsg.Text = "Record Saved Successfully";
            BindMedicine();
            tnx.Commit();

            txtMedicine.Text = "";
        }
        catch (Exception ex)
        {
            tnx.Rollback();

            lblMsg.Text = ex.Message;
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

    protected void btnSaveNM_Click(object sender, EventArgs e)
    {
        if (txtMedicine.Text.Trim() != "")
        {
            lblMedicine.Text = "";
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

            DataTable dt = StockReports.GetDataTable("SELECT * FROM f_pharmacyitemmaster WHERE ItemName='" + txtMedicine.Text.Trim() + "' AND Active=1 ");
            if (dt.Rows.Count == 0)
            {
                try
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into f_pharmacyitemmaster(ItemName,CategoryID,Active) values('" + txtMedicine.Text.Trim() + "',1,1)");
                    lblMsg.Text = "Record Saved Successfully";
                    tnx.Commit();

                    txtMedicine.Text = "";
                    BindMedicine();
                }
                catch (Exception ex)
                {
                    tnx.Rollback();

                    lblMsg.Text = ex.Message;
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
            else
            {
                lblMedicine.Text = "Medicine Already Available";
                mpeNewMed.Show();
                txtMedicine.Text = "";
            }
        }
        else
        {
            lblMedicine.Text = "Enter Medicine Name";
            mpeNewMed.Show();
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
            //for (int i = 0; i < dt.Rows.Count; i++)
            //{
            //    string value = dt.Rows[i]["Outsource"].ToString();
            //    if (Convert.ToInt16(value) == 1)
            //    {
            //        ((CheckBox)grdMedicine.Rows[i].FindControl("chkprint")).Checked = true;

            //    }

            //}
            lblMsg.Text = "Medicine Removed Successfully";
            if (dt.Rows.Count == 0)
                btnSave.Visible = false;
            else
                btnSave.Visible = true;
        }
    }

    protected void grdMedicine_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            int a = e.Row.RowIndex;
            DataTable dt = (DataTable)ViewState["Medicine"];
            string medicine = ((Label)e.Row.FindControl("lblMedicine")).Text;

            if (medicine == "")
            {
                ((TextBox)e.Row.FindControl("txtMedicine")).Visible = true;
                // ((TextBox)e.Row.FindControl("txtMedicine")).Text = "";
                ((Label)e.Row.FindControl("lblMedicine")).Visible = false;
            }
            else
            {
                // ((TextBox)e.Row.FindControl("txtMedicine")).Text = medicine;
                ((Label)e.Row.FindControl("lblMedicine")).Visible = false;
                ((Label)e.Row.FindControl("lblMedicine")).Visible = true;
            }
        }
    }

    protected void grdPreMedicine_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "imbRemove")
        {
            string PatientMedicine_ID = Util.GetString(e.CommandArgument).ToString();
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "delete from patient_medicine where PatientMedicine_ID = '" + PatientMedicine_ID + "' ");
                tnx.Commit();
                lblMsg.Text = "Record Deleted Successfully";
                bindPreMedicine();
            }
            catch (Exception ex)
            {
                lblMsg.Text = "Error occurred, Please contact administrator";
                tnx.Rollback();
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
                lblMsg.Text = ex.Message;
            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["UserID"] = Session["ID"].ToString();
            if (Request.QueryString["TransactionID"] == null)
            {
                ViewState["TID"] = Request.QueryString["TID"].ToString();
                ViewState["PID"] = Request.QueryString["PID"].ToString();
            }
            else
            {
                ViewState["TID"] = Request.QueryString["TransactionID"].ToString();
                ViewState["PID"] = Request.QueryString["PatientID"].ToString();
            }
            string Allergies = StockReports.ExecuteScalar("SELECT Replace(Allergies,'\r\n',' ')Allergies FROM cpoe_hpexam WHERE Allergies<>'' AND PatientID='" + Util.GetString(ViewState["PID"]).ToString() + "' ORDER BY DATE(PastHistoryEntryDate)");
            if (Allergies != "")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Allergies:" + Allergies + "');", true);
            }
            //bool IsDone = Util.GetBoolean(Request.QueryString["IsEdit"]);
            string IsDone = StockReports.ExecuteScalar(" select flag from Appointment where App_ID='" + Util.GetInt(Request.QueryString["App_ID"]) + "' ");
            string msg = "File Has Been Closed...";
            if (IsDone == "1")
            {
                Response.Redirect("NotAuthorized.aspx?msg=" + msg);
            }

            GetDoctor();
            BindMedicine();
            bindPreMedicine();
            BindTimeDuration();
            StringBuilder sb = new StringBuilder();
            sb.Append("select * from patient_measurement  where LedgerTransactionNo = '" + Convert.ToString(Request.QueryString["LnxNo"]) + "'");

            DataTable dtGen = new DataTable();
            dtGen = StockReports.GetDataTable(sb.ToString()).Copy();

            if (dtGen != null && dtGen.Rows.Count > 0)
            {
                string str = "";
                foreach (DataRow dr in dtGen.Rows)
                {
                    if (str == "")
                        str = dr["MeasurementName"].ToString() + " - " + dr["MeasurementUnit"].ToString();
                    else
                        str = str + "     " + dr["MeasurementName"].ToString() + " - " + dr["MeasurementUnit"].ToString();
                }
            }
        }
    }

    protected void rdoType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rdoType.SelectedValue == "0")
        {
            BindMedicine();
        }
        else
        {
            BindGeneric();
        }
    }

    private void BindGeneric()
    {
        string str = " select Concat(im.ItemID,'#',IM.MedicineType,'#',IM.Dose)ItemID, CONCAT(fsm.Name,' # ',im.typename,' # (',sm.name,')',' # ',AvailableQty)ItemName from ("
                     + "     select ItemID,(SUM(InitialCount) - SUM(ReleasedCount))AvailableQty from f_stock where (InitialCount - ReleasedCount) > 0 "
                     + "     and IsPost = 1 and  DeptLedgerNo='LSHHI57'  and MedExpiryDate>CURDATE() "
                     + "     group by ItemID "
                     + ")t1 inner join f_itemmaster im on t1.itemid = im.ItemID "
                     + "inner join f_subcategorymaster sm on sm.SubCategoryID = im.SubCategoryID "
                     + "INNER JOIN f_item_salt fis ON fis.ItemID=im.ItemID LEFT JOIN f_salt_master fsm ON fis.saltID = fsm.SaltID WHERE fsm.IsActive=1 ";

        DataTable dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {
            lstInv.DataSource = dt;
            lstInv.DataTextField = "ItemName";
            lstInv.DataValueField = "ItemID";
            lstInv.DataBind();
        }
        else
        {
            lstInv.Items.Clear();
        }
    }

    private void BindMedicine()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CONCAT(IFNULL(im.ItemCode, ''),'#',IFNULL(IM.Typename, '')) ItemName,IF(IFNULL(qty,0)<'1',CONCAT(IM.ItemID,'#','1','#',IM.MedicineType,'#',IM.Dose),CONCAT(IM.ItemID,'#','0','#',IM.MedicineType,'#',IM.Dose))ItemID  from f_itemmaster IM inner join f_subcategorymaster SM on IM.SubCategoryID = SM.SubCategoryID inner join f_configrelation CR on SM.CategoryID = CR.CategoryID  LEFT JOIN (SELECT IF(sum(InitialCount-ReleasedCount)>0,sum(InitialCount-ReleasedCount),0)  Qty,ItemID FROM f_stock WHERE ispost=1  AND MedExpiryDate > CURDATE() GROUP BY ITemID)st ON st.itemID = im.ItemID  WHERE CR.ConfigID = 11 AND im.IsActive=1  order by IM.Typename ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            lstInv.DataSource = dt;
            lstInv.DataTextField = "ItemName";
            lstInv.DataValueField = "ItemID";
            lstInv.DataBind();
            lstInv.Items.Insert(0, new ListItem("Other", "0"));
        }
        else
        {
            lblMsg.Text = "No Medicine Found";
            lstInv.Items.Clear();
        }
    }

    private void BindNewMedicine()
    {
        string str = "select ItemID,ItemName from f_pharmacyitemmaster order by itemname";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlItems.DataSource = dt;
            ddlItems.DataTextField = "ItemName";
            ddlItems.DataValueField = "ItemID";
            ddlItems.DataBind();
        }
        else
        {
            ddlItems.Items.Clear();
            lblMsg.Text = "No Medicine Found";
        }
    }

    private void bindPreMedicine()
    {
        DataTable med = StockReports.GetDataTable("Select PatientMedicine_ID,Medicine_ID,NoOfDays,Meal,NoTimesDay,Dose,Remarks,DATE_FORMAT(date,'%d-%b-%Y')date,MedicineName Item,OrderQuantity From patient_medicine   " +
            "  where  TransactionID='" + ViewState["TID"] + "' ");
        if (med.Rows.Count > 0)
        {
            grdPreMedicine.DataSource = med;
            grdPreMedicine.DataBind();
        }
        else
        {
            grdPreMedicine.DataSource = null;
            grdPreMedicine.DataBind();
        }
    }

    private void GetDoctor()
    {
        if (Convert.ToString(Session["RoleID"]).ToUpper() == "52")
        {
            lblDoctor.Text = StockReports.ExecuteScalar("select DoctorID from doctor_employee where Employee_id='" + Convert.ToString(Session["ID"]) + "'");
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
        dt.Columns.Add("Remarks");
        dt.Columns.Add("Date");
        dt.Columns.Add("Outsource");
        dt.Columns.Add("Meal");
        dt.Columns.Add("Quantity");

        return dt;
    }

    private string SaveData()
    {
        if (ViewState["Medicine"] != null)
        {
            DataTable dt = (DataTable)ViewState["Medicine"];
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                //MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "delete from patient_medicine where TransactionID = '" + Request.QueryString["TID"].ToString() + "' and LedgertransactionNo = '" + Request.QueryString["LnxNo"].ToString() + "'");
                Patient_Medicine objMed = new Patient_Medicine(tnx);
                string LnxNo = Request.QueryString["LnxNo"].ToString();
                string TransactionID = Util.GetString(ViewState["TID"].ToString());
                foreach (GridViewRow dr in grdMedicine.Rows)
                {
                    if ((((System.Web.UI.WebControls.TextBox)dr.FindControl("txtMedicine")).Text == ""))
                    {
                        return "0";
                    }
                    objMed.PatientID = Util.GetString(ViewState["PID"].ToString());
                    objMed.TransactionID = TransactionID;

                    if ((((System.Web.UI.WebControls.TextBox)dr.FindControl("txtMedicine")).Visible == true))
                    {
                        objMed.Medicine_ID = "0";
                        objMed.MedicineName = ((System.Web.UI.WebControls.TextBox)dr.FindControl("txtMedicine")).Text;
                        count = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM Patient_Medicine WHERE MedicineName='" + ((System.Web.UI.WebControls.TextBox)dr.FindControl("txtMedicine")).Text + "' AND  TransactionID = '" + Util.GetString(ViewState["TID"]).ToString() + "' and date='" + System.DateTime.Now.ToString("yyyy-MM-dd") + "'"));
                        if (count > 0)
                        {
                            return "2";
                        }
                    }
                    else
                    {
                        objMed.Medicine_ID = ((System.Web.UI.WebControls.Label)dr.FindControl("lblid")).Text;
                        objMed.MedicineName = ((System.Web.UI.WebControls.Label)dr.FindControl("lblMedicine")).Text;
                        count = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM Patient_Medicine WHERE Medicine_ID='" + ((System.Web.UI.WebControls.Label)dr.FindControl("lblid")).Text + "' AND  TransactionID = '" + Util.GetString(ViewState["TID"]).ToString() + "' and date='" + System.DateTime.Now.ToString("yyyy-MM-dd") + "'"));
                        if (count > 0)
                        {
                            return "2";
                        }
                    }

                    objMed.NoOfDays = ((System.Web.UI.WebControls.Label)dr.FindControl("lblDays")).Text;

                    objMed.NoTimesDay = ((System.Web.UI.WebControls.Label)dr.FindControl("lblTimes")).Text;
                    objMed.Remarks = ((System.Web.UI.WebControls.Label)dr.FindControl("lblRemarks")).Text;
                    objMed.Quantity = Util.GetInt(((System.Web.UI.WebControls.Label)dr.FindControl("lblQuantity")).Text);
                    //objMed.Date = Util.GetDateTime(dt.Rows[i]["Date"]);
                    objMed.Dose = ((System.Web.UI.WebControls.Label)dr.FindControl("lblDose")).Text;
                    objMed.EnteryBy = Session["ID"].ToString();
                    objMed.Meal = ((System.Web.UI.WebControls.Label)dr.FindControl("lblMeal")).Text;
                    objMed.Route = "";
                    objMed.LedgerTransactionNo = LnxNo;
                    int flag = 0;
                    for (int i = 0; i < grdMedicine.Rows.Count; i++)
                    {
                        string GrditemID = ((Label)grdMedicine.Rows[i].FindControl("lblid")).Text;
                        if (GrditemID == ((System.Web.UI.WebControls.Label)dr.FindControl("lblid")).Text)
                        {
                            if (((CheckBox)grdMedicine.Rows[i].FindControl("chkPrint")).Checked == true)
                            {
                                flag = 1;
                                break;
                            }
                        }
                    }
                    if (flag == 1)
                        objMed.Outsource = 1;
                    else
                        objMed.Outsource = 0;
                    int Emergency = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(SubcategoryID) FROM appointment WHERE TransactionID='" + TransactionID + "' AND SubcategoryID='" + Resources.Resource.EmergencySubcategoryID + "' "));
                    //if (Session["RoleID"].ToString() == "64")
                    if (Emergency > 0)
                        objMed.isEmergency = 1;
                    objMed.centreID = Util.GetInt(Session["centreID"].ToString());
                    objMed.Hospital_ID = Session["HOSPID"].ToString();
                    objMed.DoctorID = lblDoctor.Text;
                    int med = objMed.Insert();
                    if (objMed.Outsource == 1)
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('../../Design/CPOE/Medicine_outsource.aspx?TransactionId=" + TransactionID + "&LedgerTransactionNo=" + LnxNo + "')", true);
                    }
                    if (med == 0)
                    {
                        tnx.Rollback();
                        tnx.Dispose();
                        con.Close();
                        con.Dispose();
                        return string.Empty;
                    }
                }
                tnx.Commit();

                lblMsg.Text = "";
                return "1";
            }
            catch (Exception ex)
            {
                tnx.Rollback();

                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return string.Empty;
            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        else
            return string.Empty;
    }

    protected void btnPrint_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('OPDPrescriptionPrintOut.aspx?TID=" + Util.GetString(ViewState["TID"]).ToString() + "&PID=" + Util.GetString(ViewState["PID"]).ToString() + "');", true);
    }

    private void BindTimeDuration()
    {
        DataTable dtSetDuration = LoadCacheQuery.LoadMedicineQuantity("Duration");
        dtSetDuration.Columns.Add("Value");
        for (int i = 0; i < dtSetDuration.Rows.Count; i++)
        {
            dtSetDuration.Rows[i]["Value"] = dtSetDuration.Rows[i]["Quantity"] + "#" + dtSetDuration.Rows[i]["Name"];
        }
        ddlSetDuration.DataSource = dtSetDuration;
        ddlSetDuration.DataTextField = "Name";
        ddlSetDuration.DataValueField = "Value";
        ddlSetDuration.DataBind();
        ddlSetDuration.Items.Insert(0, "");

        ddlLDuration.DataSource = dtSetDuration;
        ddlLDuration.DataTextField = "Name";
        ddlLDuration.DataValueField = "Value";
        ddlLDuration.DataBind();
        ddlLDuration.Items.Insert(0, "");

        All_LoadData.bindMedicineQuan(ddlTime, "Time");
        All_LoadData.bindMedicineQuan(ddlDays, "Duration");

        DataTable dtsettime = LoadCacheQuery.LoadMedicineQuantity("Time");
        dtsettime.Columns.Add("Value");
        for (int i = 0; i < dtsettime.Rows.Count; i++)
        {
            dtsettime.Rows[i]["Value"] = dtsettime.Rows[i]["Quantity"] + "#" + dtsettime.Rows[i]["Name"];
        }
        ddlsetTime.DataSource = dtsettime;
        ddlsetTime.DataTextField = "Name";
        ddlsetTime.DataValueField = "Value";
        ddlsetTime.DataBind();
        ddlsetTime.Items.Insert(0, "");

        ddlLTime.DataSource = dtsettime;
        ddlLTime.DataTextField = "Name";
        ddlLTime.DataValueField = "Value";
        ddlLTime.DataBind();
        ddlLTime.Items.Insert(0, "");
    }
}