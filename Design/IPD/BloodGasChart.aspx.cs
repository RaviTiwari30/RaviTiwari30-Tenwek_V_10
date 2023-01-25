using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_IPD_BloodGasChart : System.Web.UI.Page
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
        txtActiontaken.Text = string.Empty;
        txtBasedeficit.Text = string.Empty;
        txtFio2.Text = string.Empty;
        txtLactate.Text = string.Empty;
        txtMode.Text = string.Empty;
        txtpCO2.Text = string.Empty;
        txtPeepCPap.Text = string.Empty;
        txtpH.Text = string.Empty;
        txtPIPMAP.Text = string.Empty;
        txtpO2.Text = string.Empty;
        txtRateorP.Text = string.Empty;
        txtsite.Text = string.Empty;
        txtStdBicarbonate.Text = string.Empty;
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection(Util.GetConString());
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" INSERT INTO ipd_bloodgaschart (DATE,TIME,FiO2,PIPorMAP,PEEPorCPAP,RateorP,Site,MODE,pCO2,pO2,pH,StdBicarbonate,Basedeficit,Lactate, ");
            sb.Append(" ActionTaken,TransactionID,PatientID,CreatedBy,CreatedDate) ");
            sb.Append(" VALUES('" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(txtTime.Text).ToString("HH:mm") + "','" + txtFio2.Text.Trim() + "','" + txtPIPMAP.Text.Trim() + "','" + txtPeepCPap.Text.Trim() + "','" + txtRateorP.Text.Trim() + "', ");
            sb.Append(" '" + txtsite.Text.Trim() + "','" + txtMode.Text.Trim() + "','" + txtpCO2.Text.Trim() + "','" + txtpO2.Text.Trim() + "','" + txtpH.Text.Trim() + "','" + txtStdBicarbonate.Text.Trim() + "','" + txtBasedeficit.Text.Trim() + "','" + txtLactate.Text.Trim() + "', ");
            sb.Append(" '" + txtActiontaken.Text.Trim() + "','" + Util.GetString(ViewState["TransactionID"]).Trim() + "','" + Util.GetString(ViewState["PatientID"]).Trim() + "','" + ViewState["UserID"] + "',NOW() )");
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
        sb.Append(" SELECT ibg.ID, DATE_FORMAT(ibg.DATE,'%d-%b-%Y') AS DATE,DATE_FORMAT(ibg.Time, '%l:%i %p') AS TIME,ibg.FiO2,ibg.PIPorMAP,ibg.PEEPorCPAP,ibg.RateorP,ibg.Site,ibg.MODE, ");
        sb.Append(" ibg.pCO2,ibg.pO2,ibg.pH,ibg.StdBicarbonate,ibg.Basedeficit,ibg.Lactate,  ibg.ActionTaken,ibg.TransactionID,ibg.PatientID,ibg.CreatedBy,CONCAT(dm.title,'',dm.name) AS DoctorName, ");
        sb.Append(" CONCAT(pm.Title,'',pm.PName) AS PatientName,pmh.DateOfVisit,CONCAT(em.title,'',em.name) AS Username,TIMESTAMPDIFF(MINUTE,ibg.CreatedDate,NOW())createdDateDiff,ibg.CreatedDate,pmh.TransNo FROM ipd_BloodGasChart ibg  ");
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
            txtFio2.Text = ((Label)grdNursing.Rows[id].FindControl("lblFiO2")).Text;
            txtPIPMAP.Text = ((Label)grdNursing.Rows[id].FindControl("lblPIPorMAP")).Text;
            txtPeepCPap.Text = ((Label)grdNursing.Rows[id].FindControl("lblPEEPorCPAP")).Text;
            txtRateorP.Text = ((Label)grdNursing.Rows[id].FindControl("lblRateorP")).Text;
            txtsite.Text = ((Label)grdNursing.Rows[id].FindControl("lblSite")).Text;
            txtMode.Text = ((Label)grdNursing.Rows[id].FindControl("lblMODE")).Text;
            txtpCO2.Text = ((Label)grdNursing.Rows[id].FindControl("lblpCO2")).Text;
            txtpO2.Text = ((Label)grdNursing.Rows[id].FindControl("lblpO2")).Text;
            txtpH.Text = ((Label)grdNursing.Rows[id].FindControl("lblpH")).Text;
            txtStdBicarbonate.Text = ((Label)grdNursing.Rows[id].FindControl("lblStdBicarbonate")).Text;
            txtBasedeficit.Text = ((Label)grdNursing.Rows[id].FindControl("lblBasedeficit")).Text;
            txtLactate.Text = ((Label)grdNursing.Rows[id].FindControl("lblLactate")).Text;
            txtActiontaken.Text = ((Label)grdNursing.Rows[id].FindControl("lblActionTaken")).Text;
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
            sb.Append(" UPDATE ipd_bloodgaschart SET isActive =0,UpdateBy='" + ViewState["UserID"].ToString() + "',UpdateDate=Now() WHERE ID = '" + lblID.Text + "'; ");

            int result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            if (result == 1)
            {
                StringBuilder sb1 = new StringBuilder();

                sb1.Append(" INSERT INTO ipd_bloodgaschart (DATE,TIME,FiO2,PIPorMAP,PEEPorCPAP,RateorP,Site,MODE,pCO2,pO2,pH,StdBicarbonate,Basedeficit,Lactate, ");
                sb1.Append(" ActionTaken,TransactionID,PatientID,CreatedBy,CreatedDate) ");
                sb1.Append(" VALUES('" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(txtTime.Text).ToString("HH:mm") + "','" + txtFio2.Text.Trim() + "','" + txtPIPMAP.Text.Trim() + "','" + txtPeepCPap.Text.Trim() + "','" + txtRateorP.Text.Trim() + "', ");
                sb1.Append(" '" + txtsite.Text.Trim() + "','" + txtMode.Text.Trim() + "','" + txtpCO2.Text.Trim() + "','" + txtpO2.Text.Trim() + "','" + txtpH.Text.Trim() + "','" + txtStdBicarbonate.Text.Trim() + "','" + txtBasedeficit.Text.Trim() + "','" + txtLactate.Text.Trim() + "', ");
                sb1.Append(" '" + txtActiontaken.Text.Trim() + "','" + Util.GetString(ViewState["TransactionID"]).Trim() + "','" + Util.GetString(ViewState["PatientID"]).Trim() + "','" + ViewState["UserID"] + "','" + Util.GetDateTime(lblCreatedDate.Text).ToString("yyyy-MM-dd HH:mm:ss") + "')");
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
        ds.Tables[0].TableName = "BloodGasChart";
        DataTable dtImg = All_LoadData.CrystalReportLogo();
        ds.Tables.Add(dtImg.Copy());
        ds.Tables[1].TableName = "logo";
        Session["ReportName"] = "BloodGasChart";
        Session["ds"] = ds;
        // ds.WriteXmlSchema(@"E:\BloodGasChart.xml");
        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
    }
}