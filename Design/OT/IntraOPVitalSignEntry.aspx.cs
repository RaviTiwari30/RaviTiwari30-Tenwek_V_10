using System;
using System.Collections.Generic;
using System;
using System.Data;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.IO;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web;
using MySql.Data.MySqlClient;
using System.Linq;

public partial class Design_IPD_IntraOPVitalSignEntry : System.Web.UI.Page
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
            ViewState["Transaction_ID"] = TID;
            ViewState["PatientID"] = Request.QueryString["PatientID"].ToString();
            grdNursingbind();
            if (TID.Contains("ISHHI"))
            {
                dt = AllLoadData_IPD.getAdmitDischargeData(ViewState["Transaction_ID"].ToString());
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
        }
        txtDate.Attributes.Add("readOnly", "readOnly");
    }

    private void Clear()
    {       
        txtDate.Text = txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        txtTime.Text = DateTime.Now.Hour + ":" + DateTime.Now.Minute;
        txtBP.Text = "";       
        txtPulse.Text = "";
        txtwounds.Text = "";
        txtOxygen.Text = "";
        txtDrains.Text = "";
        txtPAW.Text = "";
        txtCVP.Text = "";
        txtTemp.Text = "";
        txtBloodSugar.Text = "";
        txtWeight.Text = "";
        txtPOD.Text = "";
        txtResp.Text = "";
        txtHeight.Text = "";
        txtComment.Text = "";
        lblMsg.Text = "";
        rdbtempunit.SelectedIndex = 0;
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            double Temp;
            string TempConvert = string.Empty;
            if (rdbtempunit.SelectedValue == "C")
            {
                Temp = ((Util.GetDouble(txtTemp.Text.Trim()) * (1.8)) + 32);
                TempConvert = txtTemp.Text.Trim();
            }
            else
            {
                TempConvert = txtTemp.Text.Trim();
            }
            string str = "insert into IPD_IntraOPPatient_ObservationChart (Patient_ID,TransactionID,Date,Time,Bp,Pulse,Wound,Oxygen,Drains,PAW,CVP,Temp,BloodSugar,Weight,POD,Resp,Height,Comments,BMI,BSA,Isactive,CreatedBy,CreatedDate) Values ('" + Util.GetString(ViewState["PatientID"]).Trim() + "','" + Util.GetString(ViewState["Transaction_ID"]).Trim() + "','" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(txtTime.Text).ToString("HH:mm") + "','" + txtBP.Text.Trim() + "','" + txtPulse.Text.Trim() + "','" + txtwounds.Text.Trim() + "','" + txtOxygen.Text.Trim() + "','" + txtDrains.Text.Trim() + "','" + txtPAW.Text.Trim() + "','" + txtCVP.Text.Trim() + "','" + TempConvert + "','" + txtBloodSugar.Text.Trim() + "','" + txtWeight.Text.Trim() + "','" + txtPOD.Text.Trim() + "','" + txtResp.Text.Trim() + "','" + txtHeight.Text.Trim() + "','" + txtComment.Text.Trim() + "','" + txtBMI.Text.Trim() + "','" + txtBSA.Text.Trim() + "','1','" + ViewState["UserID"] + "','" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "')";
            StockReports.ExecuteDML(str);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Record Saved Successfully');", true);
            grdNursingbind();
            Clear();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = "Some Problems Occurred";
        }
    }

    private DataTable Search()
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT DATE_FORMAT(ipo.DATE,'%d-%b-%Y') AS DATE,DATE_FORMAT(ipo.Time, '%l:%i %p') TIME,ipo.BP,FORMAT(ipo.pulse,0)pulse,ipo.wound,ipo.Oxygen,ipo.drains,ipo.PAW,ipo.CVP,FORMAT(ipo.Temp,1)Temp,ipo.BloodSugar,ipo.Weight,ipo.POD,ipo.resp,ipo.Height,ipo.comments,ipo.BMI,ipo.BSA,ipo.ID,REPLACE(ipo.TransactionID,'ISHHI','')IPDNo,ipo.Patient_ID,ipo.CreatedBy,  ");
        sb.Append(" (Select concat(title,' ',name) from Employee_master where EmployeeID=ipo.CreatedBy)EmpName,CONCAT(dm.title,'',dm.name) AS DoctorName,CONCAT(pm.Title,'',pm.PName) AS PatientName,pmh.DateOfVisit,CONCAT(em.title,'',em.name) AS Username,TIMESTAMPDIFF(MINUTE,ipo.CreatedDate,NOW())createdDateDiff FROM IPD_IntraOPPatient_ObservationChart ipo ");
        sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.PatientID = ipo.Patient_ID ");
        sb.Append(" INNER JOIN Doctor_master dm ON dm.doctorID = pmh.DoctorID ");
        sb.Append(" INNER JOIN patient_master pm ON pm.patientID = pmh.PatientID ");
        sb.Append(" LEFT JOIN employee_master em ON em.employeeID = ipo.CreatedBy ");
        sb.Append(" WHERE ipo.transactionID = '" + ViewState["Transaction_ID"] + "' GROUP BY ipo.ID order by ipo.Date Desc,ipo.time desc  ");
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
            if (((Label)e.Row.FindControl("lblCreatedID")).Text != Session["ID"].ToString() )
            {
                ((ImageButton)e.Row.FindControl("imgbtnEdit")).Enabled = false;
               // ((ImageButton)e.Row.FindControl("imgbtnEdit")).ToolTip = "Edit Time Period Expired";
            }
            else
            {
                ((ImageButton)e.Row.FindControl("imgbtnEdit")).Enabled = true;
            }
        }
    }
    protected void grdNursing_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Change")
        {
            lblMsg.Text = "";
            int id = Convert.ToInt16(e.CommandArgument.ToString());
            string UserID = ((Label)grdNursing.Rows[id].FindControl("lblUserID")).Text;

            lblID.Text = ((Label)grdNursing.Rows[id].FindControl("lblID")).Text;

            DateTime dttime = Util.GetDateTime(((Label)grdNursing.Rows[id].FindControl("lbldate")).Text + " " + ((Label)grdNursing.Rows[id].FindControl("lblTime")).Text);
            DateTime current = Util.GetDateTime(DateTime.Now);
            TimeSpan diff = current.Subtract(dttime);

            if (((Label)grdNursing.Rows[id].FindControl("lblUserID")).Text != Session["ID"].ToString())
            {
                ((ImageButton)grdNursing.Rows[id].FindControl("imgbtnEdit")).Enabled = false;
                ((ImageButton)grdNursing.Rows[id].FindControl("imgbtnEdit")).ToolTip = "Edit Time Period Expired";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('You are not right person to edit this Notes');", true);

            }
            else if (((diff.Days * 24) + diff.Hours) > 2)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Edit Time Period Expired You can edit only within two hours From Entry Date Time');", true);
            }
            else
            {
                //txtDate.Text = ((Label)grdNursing.Rows[id].FindControl("lblDate")).Text;
                //txtTime.Text = ((Label)grdNursing.Rows[id].FindControl("lblTime")).Text;
                txtBP.Text = ((Label)grdNursing.Rows[id].FindControl("lblBP")).Text;               
                txtPulse.Text = ((Label)grdNursing.Rows[id].FindControl("lblPulse")).Text;
                txtwounds.Text = ((Label)grdNursing.Rows[id].FindControl("lblwounds")).Text;
                txtOxygen.Text = ((Label)grdNursing.Rows[id].FindControl("lblOxygen")).Text;
                txtDrains.Text = ((Label)grdNursing.Rows[id].FindControl("lbldrains")).Text;
                txtPAW.Text = ((Label)grdNursing.Rows[id].FindControl("lblPAW")).Text;
                txtCVP.Text = ((Label)grdNursing.Rows[id].FindControl("lblCVP")).Text;
                txtTemp.Text = ((Label)grdNursing.Rows[id].FindControl("lblTemp")).Text;
                txtBloodSugar.Text = ((Label)grdNursing.Rows[id].FindControl("lblBoodSugar")).Text;
                txtWeight.Text = ((Label)grdNursing.Rows[id].FindControl("lblWeight")).Text;
                txtPOD.Text = ((Label)grdNursing.Rows[id].FindControl("lblPOD")).Text;
                txtResp.Text = ((Label)grdNursing.Rows[id].FindControl("lblResp")).Text;
                txtHeight.Text = ((Label)grdNursing.Rows[id].FindControl("lblHeight")).Text;
                txtComment.Text = ((Label)grdNursing.Rows[id].FindControl("lblComments")).Text;
                lblBMI.Text = ((Label)grdNursing.Rows[id].FindControl("lblBMI")).Text;
                lblBSA.Text = ((Label)grdNursing.Rows[id].FindControl("lblBSA")).Text;
                txtBMI.Text = ((Label)grdNursing.Rows[id].FindControl("lblBMI")).Text;
                txtBSA.Text = ((Label)grdNursing.Rows[id].FindControl("lblBSA")).Text;

                btnUpdate.Visible = true;
                Btnsave.Visible = false;
                btnCancel.Visible = true;
            }      
        }
    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection(Util.GetConString());
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            double Temp;
            string TempConvert = string.Empty;
            if (rdbtempunit.SelectedValue == "C")
            {
                Temp = ((Util.GetDouble(txtTemp.Text.Trim()) * (1.8)) + 32);
                TempConvert = txtTemp.Text.Trim();
            }
            else
            {
                TempConvert = txtTemp.Text.Trim();
            }
            string str = "UPDATE IPD_IntraOPPatient_ObservationChart SET DATE='" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "',TIME='" + Util.GetDateTime(txtTime.Text).ToString("HH:mm") + "',Bp='" + txtBP.Text + "',Pulse='" + txtPulse.Text + "',Wound='" + txtwounds.Text + "',Oxygen='" + txtOxygen.Text.Trim() + "',Drains='" + txtDrains.Text + "',PAW='" + txtPAW.Text + "',CVP='" + txtCVP.Text + "',Temp='" + TempConvert + "',BloodSugar='" + txtBloodSugar.Text.Trim() + "',Weight='" + txtWeight.Text.Trim() + "',POD='" + txtPOD.Text.Trim() + "',Resp='" + txtResp.Text + "',Height='" + txtHeight.Text.Trim() + "',Comments='" + txtComment.Text + "',CreatedDate='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm::ss") + "',BMI='" + txtBMI.Text.Trim() + "',BSA='" + txtBSA.Text.Trim() + "' WHERE ID='" + lblID.Text + "'";
            int result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
            if (result == 1)
                // lblMsg.Text = "Record Updated Successfully";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Record Update Successfully');", true);
            tnx.Commit();
            grdNursingbind();
            Clear();

        }
        catch (Exception ex)
        {
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
        if (dt.Rows.Count > 0 && dt != null)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            ds.Tables[0].TableName = "Observation";
            DataTable dtImg = All_LoadData.CrystalReportLogo();
            ds.Tables.Add(dtImg.Copy());
            ds.Tables[1].TableName = "logo";
            Session["ReportName"] = "IntraOPObservationChart";
            Session["ds"] = ds;
            // ds.WriteXmlSchema(@"E:\obervationAnkur.xml");

            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
        }
        else
            lblMsg.Text = "Record Not Found";
    } 

    [WebMethod]
    public static string Bindgraph_Pulse(string TID)
    {       
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT(Pulse+0)Pulse, CONCAT(DATE_FORMAT(DATE,'%d-%b-%Y'),' ',TIME_FORMAT(TIME,'%H:%i %p'))CreatedTime ");
        sb.Append(" FROM IPD_IntraOPPatient_ObservationChart  ");
        sb.Append(" WHERE TransactionID='" + TID + "' AND Pulse<>'' ORDER BY DATE(CreatedDate),TIME ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }

    [WebMethod]
    public static string Bindgraph_BP(string TID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT split_str(Bp,'/',1)Systolic ,TRIM(split_str(Bp,'/',2))Diastolic, CONCAT(DATE_FORMAT(DATE,'%d-%b-%Y'),' ',TIME_FORMAT(TIME,'%H:%i %p'))CreatedTime ");       
        sb.Append(" FROM IPD_IntraOPPatient_ObservationChart WHERE TransactionID='" + TID + "' ");
        sb.Append(" ORDER BY DATE(CreatedDate),TIME ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
}
