using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_IPD_Respiratory : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();
        if (!IsPostBack)
        {
            txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtTime.Text = DateTime.Now.ToString("hh:mm tt");
            //txtTime.Text = "11:59 PM";
            ViewState["UserID"] = Session["ID"].ToString();
            string TID = Request.QueryString["TransactionID"].ToString();
            ViewState["TransactionID"] = TID;
            ViewState["PatientID"] = Request.QueryString["PatientID"].ToString();
            grdNursingbind();

            dt = AllLoadData_IPD.getAdmitDischargeData(ViewState["TransactionID"].ToString());
            clcAppDate.StartDate = Util.GetDateTime(dt.Rows[0]["DateofAdmit"]);
            if (dt.Rows[0]["Status"].ToString() == "OUT")
            {
                clcAppDate.EndDate = Util.GetDateTime(dt.Rows[0]["DateofDischarge"]);
                Btnsave.Visible = false;
                btnUpdate.Visible = false;
                btnCancel.Visible = false;
            }
            else
            {
                clcAppDate.EndDate = DateTime.Now;
            }
        }
        txtDate.Attributes.Add("readOnly", "readOnly");
    }

    private void Clear()
    {
        txtMode.Text = string.Empty;
        txtFio2.Text = string.Empty;
        txtPeep.Text = string.Empty;
        txtRate.Text = string.Empty;
        txtTidal.Text = string.Empty;
        txtPressure.Text = string.Empty;
        txtsupport.Text = string.Empty;
        txtInsp.Text = string.Empty;
        txtSpO2.Text = string.Empty;
        txtPRate.Text = string.Empty;
        txtMandatory.Text = string.Empty;
        txtSpont.Text = string.Empty;
        txtMinuteVol.Text = string.Empty;
        txtPeak.Text = string.Empty;
        txtPlatea.Text = string.Empty;
        txtSuction.Text = string.Empty;
        ddlABG.SelectedIndex = 0;
        txtpH.Text = string.Empty;
        txtPCO2.Text = string.Empty;
        txtHCO3.Text = string.Empty;
        txtBE.Text = string.Empty;
        txtPO2.Text = string.Empty;
        txtComments.Text = string.Empty;
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection(Util.GetConString());
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" INSERT INTO ipd_Respiratory (DATE,TIME,TransactionID,PatientID,Mode,FiO2,Peep,Rate,Tidal,Pressure,Support,Insp,SpO2,PRate,Mandatory,Spont,MinuteVol,Peak,Platea,Suction,ABG,pH,PCO2,HCO3,BE,PO2,Comments,CreatedBy,CreatedDate ) ");
            sb.Append(" VALUES('" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(txtTime.Text).ToString("HH:mm") + "', ");
            sb.Append(" '" + Util.GetString(ViewState["TransactionID"]).Trim() + "','" + Util.GetString(ViewState["PatientID"]).Trim() + "', ");
            sb.Append(" '" + txtMode.Text.Trim() + "', ");
            sb.Append(" '" + txtFio2.Text.Trim() + "', ");
            sb.Append(" '" + txtPeep.Text.Trim() + "', ");
            sb.Append(" '" + txtRate.Text.Trim() + "', ");
            sb.Append(" '" + txtTidal.Text.Trim() + "', ");
            sb.Append(" '" + txtPressure.Text.Trim() + "', ");
            sb.Append(" '" + txtsupport.Text.Trim() + "', ");
            sb.Append(" '" + txtInsp.Text.Trim() + "', ");
            sb.Append(" '" + txtSpO2.Text.Trim() + "', ");
            sb.Append(" '" + txtPRate.Text.Trim() + "', ");
            sb.Append(" '" + txtMandatory.Text.Trim() + "', ");
            sb.Append(" '" + txtSpont.Text.Trim() + "', ");
            sb.Append(" '" + txtMinuteVol.Text.Trim() + "', ");
            sb.Append(" '" + txtPeak.Text.Trim() + "', ");
            sb.Append(" '" + txtPlatea.Text.Trim() + "', ");
            sb.Append(" '" + txtSuction.Text.Trim() + "', ");
            sb.Append(" '" + ddlABG.SelectedValue + "', ");
            sb.Append(" '" + txtpH.Text.Trim() + "', ");
            sb.Append(" '" + txtPCO2.Text.Trim() + "', ");
            sb.Append(" '" + txtHCO3.Text.Trim() + "', ");
            sb.Append(" '" + txtBE.Text.Trim() + "', ");
            sb.Append(" '" + txtPO2.Text.Trim() + "', ");
            sb.Append(" '" + txtComments.Text.Trim() + "', ");
            sb.Append(" '" + ViewState["UserID"] + "',NOW() )");
            int result = Util.GetInt(MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString()));
            if (result == 1)
            {
                tnx.Commit();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "keySave", "modelAlert('Record Saved Successfully');", true);
                grdNursingbind();
                Clear();
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = "Some Problems Occurred";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    private DataTable Search()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ibg.ID, DATE_FORMAT(ibg.DATE,'%d-%b-%Y') AS DATE,DATE_FORMAT(ibg.Time, '%l:%i %p') AS TIME, ibg.Mode,ibg.FiO2,ibg.Peep,ibg.Rate,ibg.Tidal,ibg.Pressure,ibg.Support,ibg.Insp,ibg.SpO2,ibg.PRate,ibg.Mandatory,ibg.Spont,ibg.MinuteVol,ibg.Peak,ibg.Platea,ibg.Suction,IF(ibg.ABG='0','',ibg.ABG)ABG,ibg.pH,ibg.PCO2,ibg.HCO3,ibg.BE,ibg.PO2,ibg.Comments,ibg.TransactionID,ibg.PatientID,ibg.CreatedBy,CONCAT(dm.title,'',dm.name) AS DoctorName, ");
        sb.Append(" CONCAT(pm.Title,'',pm.PName) AS PatientName,pmh.DateOfVisit,CONCAT(em.title,'',em.name) AS Username,TIMESTAMPDIFF(MINUTE,ibg.CreatedDate,NOW())createdDateDiff,ibg.CreatedDate,pmh.TransNo FROM ipd_Respiratory ibg  ");
        sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.PatientID = ibg.PatientID INNER JOIN Doctor_master dm ON dm.DoctorID = pmh.DoctorID INNER JOIN patient_master pm ON pm.PatientID = pmh.PatientID  ");
        sb.Append(" LEFT JOIN employee_master em ON em.employeeID = ibg.CreatedBy WHERE ibg.transactionID = '" + Util.GetString(ViewState["TransactionID"]) + "' and ibg.IsActive=1 GROUP BY ibg.ID ORDER BY ibg.Date DESC,ibg.time DESC  ; ");

        DataTable dtInvest = StockReports.GetDataTable(sb.ToString());

        return dtInvest;
    }
    public void grdNursingbind()
    {
        DataTable dt = Search();
        grdNursing.DataSource = dt;
        grdNursing.DataBind();


    }
    protected void OnPageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        grdNursing.PageIndex = e.NewPageIndex;
        DataTable dt = Search();
        grdNursing.DataSource = dt;
        grdNursing.DataBind();
    }
    protected void grdNursing_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {           
            decimal createdDateDiff = Util.GetDecimal(((Label)e.Row.FindControl("lblTimeDiff")).Text);
            if (((Label)e.Row.FindControl("lblCreatedID")).Text != Session["ID"].ToString())
            {
                ((ImageButton)e.Row.FindControl("imgbtnEdit")).Enabled = false;
                ((ImageButton)e.Row.FindControl("imgbtnEdit")).ToolTip = "Edit Time Period Expired";
            }
            else
            {
                if (createdDateDiff >= Util.GetDecimal(Resources.Resource.EditTimePeriod.ToString()))
                {
                    ((ImageButton)e.Row.FindControl("imgbtnEdit")).Enabled = false;
                    ((ImageButton)e.Row.FindControl("imgbtnEdit")).ToolTip = "Edit Time Period Expired";
                }
                else
                {
                    ((ImageButton)e.Row.FindControl("imgbtnEdit")).Enabled = true;
                }
            }
        }       
    }
    protected void grdNursing_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Change")
        {
            lblMsg.Text = "";
            int id = Convert.ToInt16(e.CommandArgument.ToString());
            lblID.Text = ((Label)grdNursing.Rows[id].FindControl("lblID")).Text;
            lblCreatedDate.Text = ((Label)grdNursing.Rows[id].FindControl("lblCreatedDate")).Text;
            txtMode.Text  = ((Label)grdNursing.Rows[id].FindControl("lblMode")).Text;
            txtFio2.Text  = ((Label)grdNursing.Rows[id].FindControl("lblFiO2")).Text;
            txtPeep.Text = ((Label)grdNursing.Rows[id].FindControl("lblPeep")).Text;
            txtRate.Text  = ((Label)grdNursing.Rows[id].FindControl("lblRate")).Text;
            txtTidal.Text  = ((Label)grdNursing.Rows[id].FindControl("lblTidal")).Text;
            txtPressure.Text = ((Label)grdNursing.Rows[id].FindControl("lblPressure")).Text;
            txtsupport.Text = ((Label)grdNursing.Rows[id].FindControl("lblsupport")).Text;
            txtInsp.Text = ((Label)grdNursing.Rows[id].FindControl("lblInsp")).Text;
            txtSpO2.Text = ((Label)grdNursing.Rows[id].FindControl("lblSpO2")).Text;
            txtPRate.Text = ((Label)grdNursing.Rows[id].FindControl("lblPRate")).Text;
            txtMandatory.Text = ((Label)grdNursing.Rows[id].FindControl("lblMandatory")).Text;
            txtSpont.Text = ((Label)grdNursing.Rows[id].FindControl("lblSpont")).Text;
            txtMinuteVol.Text = ((Label)grdNursing.Rows[id].FindControl("lblMinuteVol")).Text;
            txtPeak.Text = ((Label)grdNursing.Rows[id].FindControl("lblPeak")).Text;
            txtPlatea.Text = ((Label)grdNursing.Rows[id].FindControl("lblPlatea")).Text;
            txtSuction.Text = ((Label)grdNursing.Rows[id].FindControl("lblSuction")).Text;
            ddlABG.SelectedIndex = ddlABG.Items.IndexOf(ddlABG.Items.FindByValue(((Label)grdNursing.Rows[id].FindControl("lblABG")).Text));
            txtpH.Text  = ((Label)grdNursing.Rows[id].FindControl("lblpH")).Text;
            txtPCO2.Text  = ((Label)grdNursing.Rows[id].FindControl("lblPCO2")).Text;
            txtHCO3.Text  = ((Label)grdNursing.Rows[id].FindControl("lblHCO3")).Text;
            txtBE.Text  = ((Label)grdNursing.Rows[id].FindControl("lblBE")).Text;
            txtPO2.Text  = ((Label)grdNursing.Rows[id].FindControl("lblPO2")).Text;
            txtComments.Text = ((Label)grdNursing.Rows[id].FindControl("lblComments")).Text;
            btnUpdate.Visible = true;
            Btnsave.Visible = false;
            btnCancel.Visible = true;
        }
    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection(Util.GetConString());
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" UPDATE ipd_Respiratory SET isActive =0,UpdateBy='" + ViewState["UserID"].ToString() + "',UpdateDate=Now() WHERE ID = '" + lblID.Text + "'; ");

            int result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            if (result == 1)
            {
                StringBuilder sb1 = new StringBuilder();

                sb1.Append(" INSERT INTO ipd_Respiratory (DATE,TIME,TransactionID,PatientID,Mode,FiO2,Peep,Rate,Tidal,Pressure,Support,Insp,SpO2,PRate,Mandatory,Spont,MinuteVol,Peak,Platea,Suction,ABG,pH,PCO2,HCO3,BE,PO2,Comments,CreatedBy,CreatedDate) ");
                sb1.Append(" VALUES('" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(txtTime.Text).ToString("HH:mm") + "', ");
                sb1.Append(" '" + Util.GetString(ViewState["TransactionID"]).Trim() + "','" + Util.GetString(ViewState["PatientID"]).Trim() + "', ");
                sb1.Append(" '" + txtMode.Text.Trim() + "', ");
                sb1.Append(" '" + txtFio2.Text.Trim() + "', ");
                sb1.Append(" '" + txtPeep.Text.Trim() + "', ");
                sb1.Append(" '" + txtRate.Text.Trim() + "', ");
                sb1.Append(" '" + txtTidal.Text.Trim() + "', ");
                sb1.Append(" '" + txtPressure.Text.Trim() + "', ");
                sb1.Append(" '" + txtsupport.Text.Trim() + "', ");
                sb1.Append(" '" + txtInsp.Text.Trim() + "', ");
                sb1.Append(" '" + txtSpO2.Text.Trim() + "', ");
                sb1.Append(" '" + txtPRate.Text.Trim() + "', ");
                sb1.Append(" '" + txtMandatory.Text.Trim() + "', ");
                sb1.Append(" '" + txtSpont.Text.Trim() + "', ");
                sb1.Append(" '" + txtMinuteVol.Text.Trim() + "', ");
                sb1.Append(" '" + txtPeak.Text.Trim() + "', ");
                sb1.Append(" '" + txtPlatea.Text.Trim() + "', ");
                sb1.Append(" '" + txtSuction.Text.Trim() + "', ");
                sb1.Append(" '" + ddlABG.SelectedValue + "', ");
                sb1.Append(" '" + txtpH.Text.Trim() + "', ");
                sb1.Append(" '" + txtPCO2.Text.Trim() + "', ");
                sb1.Append(" '" + txtHCO3.Text.Trim() + "', ");
                sb1.Append(" '" + txtBE.Text.Trim() + "', ");
                sb1.Append(" '" + txtPO2.Text.Trim() + "', ");
                sb1.Append(" '" + txtComments.Text.Trim() + "', ");
                sb1.Append(" '" + ViewState["UserID"] + "', ");
                sb1.Append(" '" + Util.GetDateTime(lblCreatedDate.Text).ToString("yyyy-MM-dd HH:mm:ss") + "' ) ");
                int result1 = Util.GetInt(MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb1.ToString()));
                if (result1 == 1)
                {
                    tnx.Commit();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "keySave1", "modelAlert('Record Update Successfully');", true);
                    grdNursingbind();
                    Clear();
                }
            }
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
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Clear();
        btnCancel.Visible = false;
        btnUpdate.Visible = false;
        Btnsave.Visible = true;
    }

    protected void btnPrint_Click(object sender, EventArgs e)
    {
        DataTable dt = Search();
        DataSet ds = new DataSet();
        ds.Tables.Add(dt.Copy());
        ds.Tables[0].TableName = "Respiratory";
        DataTable dtImg = All_LoadData.CrystalReportLogo();
        ds.Tables.Add(dtImg.Copy());
        ds.Tables[1].TableName = "logo";
        Session["ReportName"] = "Respiratory";
        Session["ds"] = ds;
        // ds.WriteXmlSchema(@"E:\Respiratory.xml");
        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
    }
}