using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;
using MySql.Data.MySqlClient;

public partial class Design_IPD_OrderSet_Nursing_OrderSet_Medicine : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            try
            {
                string OrderSetID = Request.QueryString["ID"].ToString();
                ViewState["ID"] = OrderSetID;
                string TID = Request.QueryString["TID"].ToString();
                ViewState["TransID"] = TID;
                string Groupid = Request.QueryString["GroupID"].ToString();
                ViewState["GroupID"] = Groupid;
                ViewState["Relational_ID"] = Request.QueryString["RelationalID"].ToString();
                GetDoctor();
                BindMedicine();
                BindPatientMedicin();
                StringBuilder sb = new StringBuilder();
                sb.Append("select * from patient_measurement  where TransactionID = '" + ViewState["TransID"] + "'");

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
            catch
            {

            }
            BindMedicine();
        }

        
    }
    private void GetDoctor()
    {
        if (Convert.ToString(Session["LoginType"]).ToUpper() == "DOCTOR")
        {
            string str = "select DoctorID from doctor_employee where Employee_id='" + Convert.ToString(Session["ID"]) + "'";
            DataTable dt = StockReports.GetDataTable(str);
            if (dt != null && dt.Rows.Count > 0)
                lblDoctor.Text = Util.GetString(dt.Rows[0][0]);
        }
    }
    private void BindMedicine()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT concat(IfNull(im.ItemCode,''),'#',IfNull(IM.Typename,''))ItemName,IM.ItemID ItemID from f_itemmaster IM inner join f_subcategorymaster SM on IM.SubCategoryID = SM.SubCategoryID inner join f_configrelation CR on SM.CategoryID = CR.CategoryID  LEFT JOIN (SELECT IF(sum(InitialCount-ReleasedCount)>0,sum(InitialCount-ReleasedCount),0)  Qty,ItemID FROM f_stock WHERE ispost=1 and DeptLedgerNo='LSHHI17' GROUP BY ITemID)st ON st.itemID = im.ItemID  WHERE CR.ConfigID = 11 AND im.IsActive=1 AND im.SubCategoryID IN ('LSHHI127','LSHHI128','LSHHI129','LSHHI130','LSHHI131','LSHHI132','LSHHI133','LSHHI134','LSHHI135','LSHHI136','LSHHI137','LSHHI138','LSHHI139','LSHHI140','LSHHI141','LSHHI142','LSHHI143','LSHHI144','LSHHI145','LSHHI146','LSHHI147','LSHHI148','LSHHI149','LSHHI150','LSHHI151','LSHHI152','LSHHI153','LSHHI154','LSHHI155','LSHHI156') order by IM.Typename ");
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
            lblMsg.Text = "No Medicine Found";
            lstInv.Items.Clear();
        }

        ddldose.DataSource = AllGlobalFunction.MedicineTab;
        ddldose.DataBind();

        ddlTime.DataSource = AllGlobalFunction.MedicineTimes;
        ddlTime.DataBind();

        ddlDays.DataSource = AllGlobalFunction.MedicineDays;
        ddlDays.DataBind();

    }
    private void BindPatientMedicin()
    {
        StringBuilder sb = new StringBuilder();
        //sb.Append(" SELECT pm.Outsource,PatientMedicine_ID,phi.ItemName as Medicine,Medicine_ID as MedicineID,Dose,NoOfDays as Days,NoTimesDay as Time,Remarks,pm.Date FROM nursing_orderset_medicine");
        sb.Append(" SELECT pm.Outsource,phi.Typename as Medicine,Medicine_ID as MedicineID,Dose,NoOfDays as Days,NoTimesDay as Time,Remarks FROM nursing_orderset_medicine");
        sb.Append(" pm INNER JOIN f_itemmaster phi ON pm.Medicine_ID=phi.ItemID WHERE TransactionID='" + ViewState["TransID"].ToString() + "' and GroupID='" + ViewState["GroupID"].ToString() + "' and  RelationalID=" + ViewState["Relational_ID"].ToString() + "");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            grdMedicine.DataSource = dt;
            grdMedicine.DataBind();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                string value = dt.Rows[i]["Outsource"].ToString();
                if (Convert.ToInt16(value) == 1)
                {
                    ((CheckBox)grdMedicine.Rows[i].FindControl("chkprint")).Checked = true;


                }

            }
            ViewState["Medicine"] = dt;
            btnSave.Visible = true;
        }
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (lstInv.SelectedItem.Text == "")
        {
            lstInv.Focus();
            lblMsg.Text = "Please Select Medicine";
            return;
        }
        if (ddldose.SelectedItem.Text == "")
        {
            ddldose.Focus();
            lblMsg.Text = "Please Select Dose";
            return;
        }
        if (ddlTime.SelectedItem.Text == "")
        {
            ddlTime.Focus();
            lblMsg.Text = "Please Select Times";
            return;
        }
        if (ddlDays.SelectedItem.Text == "")
        {
            ddlDays.Focus();
            lblMsg.Text = "Please Select Days";
            return;
        }

        foreach (GridViewRow row in grdMedicine.Rows)
        {
            string Medicine = ((Label)row.FindControl("lblMedicine")).Text;
            if (Util.GetString(lstInv.SelectedItem.Text) == Medicine)
            {
                lblMsg.Text = "Medicine Already Selected";
                return;
            }
        }

        if (lstInv.SelectedItem.Text != "")
        {
            //StringBuilder ab = new StringBuilder();
            //ab.Append("select outsource from patient_medicine where PatientID='" + ViewState["PID"].ToString() + "'");
            //DataTable dt = new DataTable(ab.ToString());
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
            dr["Remarks"] = txtRemarks.Text.Trim();

            dt.Rows.Add(dr);

            //dr["Date"] = Util.GetDateTime(DateTime.Now);
            ViewState["Medicine"] = dt;
            grdMedicine.DataSource = dt;
            grdMedicine.DataBind();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                string value = dt.Rows[i]["Outsource"].ToString();
                if (value == "")
                {

                }
                else if (Convert.ToInt16(value) == 1)
                {
                    ((CheckBox)grdMedicine.Rows[i].FindControl("chkprint")).Checked = true;


                }

            }
            btnSave.Visible = true;

            //lblMsg.Text = "Medicine Added Successfully";
            BindMedicine();
        }
        else
        {
            lblMsg.Text = "Please select Medicine";
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

        return dt;
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
          //  lblMsg.Text = "Medicine Removed Successfully";
        }
    }
    private string SaveData()
    {

        DataTable dt = (DataTable)ViewState["Medicine"];
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        if (ViewState["Medicine"] != null)
        {
            try
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "delete from nursing_orderset_medicine where TransactionID = '" + ViewState["TransID"] + "' and GroupID = '" + ViewState["GroupID"] + "'");
                //Patient_Medicine objMed = new Patient_Medicine(tnx);
                //string LnxNo = Request.QueryString["LnxNo"].ToString();
                //string TransactionID = Request.QueryString["TID"].ToString();
                foreach (GridViewRow dr in grdMedicine.Rows)
                {
                    int outsource = 0;

                    string medicineid = ((System.Web.UI.WebControls.Label)dr.FindControl("lblid")).Text;
                    string NoOfDays = ((System.Web.UI.WebControls.Label)dr.FindControl("lblDays")).Text;
                    string NoTimesDay = ((System.Web.UI.WebControls.Label)dr.FindControl("lblTimes")).Text;
                    string Remarks = ((System.Web.UI.WebControls.Label)dr.FindControl("lblRemarks")).Text;
                    string Dose = ((System.Web.UI.WebControls.Label)dr.FindControl("lblDose")).Text;

                    //objMed.LedgerTransactionNo = LnxNo;
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
                        outsource = 1;
                    else
                        outsource = 0;


                    //int med = objMed.Insert();
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO nursing_orderset_medicine (TransactionID,GroupID,Medicine_ID,NoOfDays,NoTimesDay,Dose,Remarks,Outsource,OrdersetID,RelationalID) VALUES('" + ViewState["TransID"].ToString() + "','" + ViewState["GroupID"].ToString() + "','" + medicineid + "','" + NoOfDays + "','" + NoTimesDay + "','" + Dose + "','" + Remarks + "','" + outsource + "','" + ViewState["ID"].ToString() + "'," + ViewState["Relational_ID"].ToString() + ")");
                    //if (outsource == 1)
                    //{

                    //    ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('../../Design/CPOE/Medicine_outsource.aspx?TransactionId=" + ViewState["TransID"] + "&GroupID=" + ViewState["GroupID"] + "')", true);
                    //}
                    //if (med == 0)
                    //{
                    //    tnx.Rollback();
                    //    tnx.Dispose();
                    //    con.Close();
                    //    con.Dispose();
                    //    return string.Empty;
                    //}
                }
                tnx.Commit();
                tnx.Dispose();
                con.Close();
                con.Dispose();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);

                return "1";
            }
            catch (Exception ex)
            {
                tnx.Rollback();
                tnx.Dispose();
                con.Close();
                con.Dispose();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return string.Empty;
            }
        }
        else
        {
            try
            {

                int numberOfRecords = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "delete from nursing_orderset_medicine where TransactionID = '" + ViewState["TransID"] + "' and GroupID = '" + ViewState["GroupID"] + "'");

                tnx.Commit();
                tnx.Dispose();
                con.Close();
                con.Dispose();
                if (numberOfRecords > 1)
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM03','" + lblMsg.ClientID + "');", true);
                else
                    lblMsg.Text = "Please select Medicine";
                return "2";
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
                tnx.Rollback();
                tnx.Dispose();
                con.Close();
                con.Dispose();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return string.Empty;
            }

        }

    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (SaveData() != string.Empty)
        {
            grdMedicine.DataSource = null;
            grdMedicine.DataBind();
            ViewState.Remove("Medicine");
            btnSave.Visible = false;
            txtRemarks.Text = "";
            BindPatientMedicin();
        }
        else
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
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
    protected void btnNew_Click(object sender, EventArgs e)
    {
        if (ddlItems.Items.Count < 1)
            BindNewMedicine();
        mpeItems.Show();
    }
    protected void btnSaveMed_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into doctor_medicine(DoctorID,ItemID) values('" + lblDoctor.Text.Trim() + "','" + ddlItems.SelectedValue + "')");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
            BindMedicine();
            tnx.Commit();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            txtMedicine.Text = "";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            lblMsg.Text = ex.Message;
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
    protected void btnNewMed_Click(object sender, EventArgs e)
    {
        lblMedicine.Text = "";
        mpeNewMed.Show();
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
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
                    tnx.Commit();
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();
                    txtMedicine.Text = "";
                    BindMedicine();
                }
                catch (Exception ex)
                {
                    tnx.Rollback();
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();
                    lblMsg.Text = ex.Message;
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
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
}