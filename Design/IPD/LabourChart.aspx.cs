using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;


public partial class Design_IPD_LabourChart : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["UserID"] = Session["ID"].ToString();
            ViewState["TransactionID"] = Request.QueryString["TransactionID"].ToString();
            ViewState["PatientID"] = Request.QueryString["PatientID"].ToString();

            txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtTime.Text = DateTime.Now.ToShortTimeString();

            string IsFemale = StockReports.ExecuteScalar("Select Gender from Patient_master where PatientID='" + Request.QueryString["PatientID"].ToString() + "'");
            if (!string.IsNullOrEmpty(IsFemale) && IsFemale.ToUpper()!="FEMALE")
            {
                string Msg = "The Chart is only for Female Patients..";
                Response.Redirect("../IPD/PatientFinalMsg.aspx?msg=" + Msg + "&TID=" + Request.QueryString["TransactionID"].ToString());
            }

            BindLabourChartDetails();
        }

        lblMsg.Text = "";
        txtDate.Attributes.Add("readOnly", "readOnly");
        txtLMP.Attributes.Add("readonly", "readOnly");
    }

    private void BindLabourChartDetails()
    {
        DataTable dt = Search();

        grdNursing.DataSource = dt;
        grdNursing.DataBind();
    }

    private DataTable Search()
    {
        StringBuilder query = new StringBuilder();
        query.Append("SELECT lw.ID,DATE_FORMAT(lw.DATE,'%d-%b-%Y')AS DATE,TIME_FORMAT(lw.Time,'%h:%i %p')AS TIME,IF(lw.LMP <> '0001-01-01',DATE_FORMAT(lw.LMP,'%d-%b-%Y'),'') AS LMP,lw.KindOfFluid,lw.AmtOfFluid,TIME_FORMAT(lw.UrineTime,'%h:%i %p') AS UrineTime,lw.AmtOfUrine,TIME_FORMAT(lw.intervalTime,'%h:%i %p') AS intervalTime,TIME_FORMAT(lw.Contraction,'%h:%i %p') AS Contraction,");
        query.Append("Time_Format(lw.ContractionTime,'%h:%i %p') AS ContractionTime,TIME_FORMAT(lw.Duration,'%h:%i %p') AS Duration,lw.FH,lw.Pulse,lw.BP,lw.Remarks,CONCAT(pm.Title,'',pm.PName) AS PatientName,pm.Age,pm.Gender,CONCAT(dm.Title,' ',dm.Name)AS DoctorName,lw.CreatedBy,CONCAT(emp.title,' ',emp.name)AS CreatedNameBy ");
        query.Append("FROM ipd_Labourward lw INNER JOIN employee_master emp ON emp.EmployeeID = lw.CreatedBy INNER JOIN patient_master pm ON pm.PatientID = lw.PatientID ");
        query.Append("LEFT JOIN patient_medical_history pmh ON pmh.PatientID = lw.PatientID LEFT JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID ");
        query.Append("WHERE lw.IsActive = 1 AND lw.TransactionID = '" + ViewState["TransactionID"].ToString() + "' ");

        DataTable dt = StockReports.GetDataTable(query.ToString());

        return dt;
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            StringBuilder query = new StringBuilder();
            query.Append(" INSERT INTO ipd_Labourward (LMP,DATE,TIME,KindOfFluid,AmtOfFluid,UrineTime,AmtOfUrine,Contraction,ContractionTime,Duration,IntervalTime, ");
            query.Append(" FH,Pulse,BP,Remarks,TransactionID,PatientID,CreatedDate,CreatedBy) VALUES ");
            query.Append(" ('" + Util.GetDateTime(txtLMP.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "', ");
            query.Append(" '" + Util.GetDateTime(txtTime.Text).ToString("HH:mm:ss") + "','" + ddlTypeOfFluid.SelectedItem.Text + "','" + txtAmount.Text.Trim() + "', ");
            query.Append(" '" + Util.GetDateTime(txtUrineTime.Text).ToString("HH:mm:ss") + "','" + txtUrineAmount.Text.Trim() + "', ");
            query.Append(" '" + Util.GetDateTime(txtContractionTime.Text).ToString("HH:mm:ss") + "', ");
            query.Append(" '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "', ");
            query.Append(" '" + Util.GetDateTime(txtDurationtime.Text).ToString("HH:mm:ss") + "','" + Util.GetDateTime(txtIntervalTime.Text).ToString("HH:mm:ss") + "', ");
            query.Append(" '" + txtFH.Text.Trim() + "','" + txtResp.Text.Trim() + "','" + txtBP.Text.Trim() + "','" + txtComment.Text.Trim() + "','" + ViewState["TransactionID"] + "', ");
            query.Append(" '" + ViewState["PatientID"] + "','" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "','" + ViewState["UserID"] + "')");

            MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, query.ToString());

            tranx.Commit();

            Clear();

            BindLabourChartDetails();

            lblMsg.Text = "Record Saved Successfully";
        }
        catch (Exception ex)
        {
            tranx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            lblMsg.Text = "Error occurred, Please contact administrator";
        }
        finally
        {
            tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Clear();        
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            StringBuilder query = new StringBuilder();
            query.Append(" UPDATE ipd_Labourward SET LMP='" + Util.GetDateTime(txtLMP.Text).ToString("yyyy-MM-dd") + "', ");
            query.Append(" DATE='" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "',TIME='" + Util.GetDateTime(txtTime.Text).ToString("HH:mm:ss") + "',");
            query.Append(" KindOfFluid='" + ddlTypeOfFluid.SelectedItem.Text + "',AmtOfFluid='" + txtAmount.Text.Trim() + "',UrineTime='" + txtUrineTime.Text.Trim() + "',");
            query.Append(" AmtOfUrine='" + txtUrineAmount.Text.Trim() + "',Contraction='" + Util.GetDateTime(txtContractionTime.Text).ToString("HH:mm:ss") + "', ");
            query.Append(" ContractionTime='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',Duration='" + Util.GetDateTime(txtDurationtime.Text).ToString("HH:mm:ss") + "',");
            query.Append(" IntervalTime='" + Util.GetDateTime(txtIntervalTime.Text).ToString("HH:mm:ss") + "',FH='" + txtFH.Text.Trim() + "',");
            query.Append(" Pulse='" + txtResp.Text.Trim() + "',BP='" + txtBP.Text.Trim() + "',Remarks='" + txtComment.Text.Trim() + "',");
            query.Append(" Updatedby='" + Util.GetString(ViewState["UserID"]) + "',UpdatedDate='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "' WHERE ID='" + lblID.Text + "'  ");

            MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, query.ToString());

            tranx.Commit();

            Clear();

            BindLabourChartDetails();

            lblMsg.Text = "Record Update Successfully";
        }
        catch (Exception ex)
        {
            tranx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            lblMsg.Text = "Error occurred, Please contact administrator";
        }
        finally
        {
            tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void grdNursing_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Change")
        {
            int id = Convert.ToInt16(e.CommandArgument.ToString());

            lblID.Text = ((Label)grdNursing.Rows[id].FindControl("lblID")).Text;
            txtDate.Text = ((Label)grdNursing.Rows[id].FindControl("lblDate")).Text;
            txtTime.Text = ((Label)grdNursing.Rows[id].FindControl("lblTime")).Text;
            ddlTypeOfFluid.SelectedIndex = ddlTypeOfFluid.Items.IndexOf(ddlTypeOfFluid.Items.FindByText(((Label)grdNursing.Rows[id].FindControl("lblKindOfFluid")).Text));
            txtAmount.Text = ((Label)grdNursing.Rows[id].FindControl("lblAmtOfFluid")).Text;
            txtUrineTime.Text = ((Label)grdNursing.Rows[id].FindControl("lblUrineTime")).Text;
            txtUrineAmount.Text = ((Label)grdNursing.Rows[id].FindControl("lblAmtOfUrine")).Text;
            txtContractionTime.Text = ((Label)grdNursing.Rows[id].FindControl("lblContraction")).Text;
            txtDurationtime.Text = ((Label)grdNursing.Rows[id].FindControl("lblDuration")).Text;
            txtIntervalTime.Text = ((Label)grdNursing.Rows[id].FindControl("lblInterval")).Text;
            txtFH.Text = ((Label)grdNursing.Rows[id].FindControl("lblFH")).Text;
            txtResp.Text = ((Label)grdNursing.Rows[id].FindControl("lblPulse")).Text;
            txtBP.Text = ((Label)grdNursing.Rows[id].FindControl("lblBP")).Text;
            txtLMP.Text = ((Label)grdNursing.Rows[id].FindControl("lblLMP")).Text;
            txtComment.Text = ((Label)grdNursing.Rows[id].FindControl("lblRemarks")).Text;

            btnSave.Visible = false;
            btnUpdate.Visible = true;
            btnCancel.Visible = true;
        }
    }

    protected void grdNursing_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblUserID")).Text != ViewState["UserID"].ToString())
            {
                ((ImageButton)e.Row.FindControl("imgbtnEdit")).Enabled = false;
            }
        }
    }

    protected void OnPageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        grdNursing.PageIndex = e.NewPageIndex;
        grdNursing.DataBind();
    }

    protected void btnPrint_Click1(object sender, EventArgs e)
    {
        DataTable dt = Search();

        DataSet ds = new DataSet();
        ds.Tables.Add(dt.Copy());

        Session["ReportName"] = "LabourWard";
        Session["ds"] = ds;
        // ds.WriteXmlSchema(@"E:\LabourWard.xml");
        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
    }

    private void Clear()
    {
        txtDate.Text = txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        txtTime.Text = DateTime.Now.ToShortTimeString();
        ddlTypeOfFluid.SelectedIndex = 0;
        txtAmount.Text = "";
        txtUrineTime.Text = "";
        txtUrineAmount.Text = "";
        txtContractionTime.Text = "";
        txtDurationtime.Text = "";
        txtFH.Text = "";
        txtIntervalTime.Text = "";
        txtResp.Text = "";
        txtBP.Text = "";
        txtLMP.Text = "";
        txtComment.Text = "";

        btnSave.Visible = true;
        btnCancel.Visible = false;
        btnUpdate.Visible = false;
    }
}