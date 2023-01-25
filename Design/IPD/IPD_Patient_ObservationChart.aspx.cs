using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_IPD_IPD_Patient_ObservationChart : System.Web.UI.Page
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

            if (TID.Contains("ISHHI"))
            {
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
        }
        txtDate.Enabled = false;
       // txtTime.Enabled = false;
       
    }
    private void Clear()
    {
        txtComment.Text = "";
        txtDate.Text = txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        txtTime.Text = DateTime.Now.Hour + ":" + DateTime.Now.Minute;
        txtTemp.Text = "";
        txtPulse.Text = "";
        txtResp.Text = "";
        txtBP.Text = "";
        txtwounds.Text = "";
        txtDrains.Text = "";
        lblMsg.Text = "";
        txtPOD.Text = "";
        txtOxygenFlow.Text = "";
        txtE.Text = "";
        txtM.Text = "";
        txtV.Text = "";
        txtGCS.Text = "";
        lblGCS.Text = "";
        txtHeadCircumference.Text = "";
        rdbtempunit.SelectedIndex = 0;
        chkIncubation.Checked = false;
        lblincubation.Text = "";
        txtIncubation.Text = "0";
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

            if (txtIncubation.Text == "")
                txtIncubation.Text = "0";

            string str = "insert into IPD_Patient_ObservationChart (Date,Time,Temp,Pulse,Resp,Bp,Wound,Drains,Comments,TransactionID,PatientID,CreatedBy,CreatedDate,Isactive,BloodSugar,Weight,weightUnit,Oxygen,POD,Height,BMI,BSA,InvasiveNonInvasive,E,M,V,GCS,Headcircumference,OxygenFlow,Incubation) Values ('" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(txtTime.Text).ToString("HH:mm") + "','" + TempConvert + "','" + txtPulse.Text.Trim() + "','" + txtResp.Text.Trim() + "','" + txtBP.Text.Trim() + "','" + txtwounds.Text.Trim() + "','" + txtDrains.Text.Trim() + "','" + txtComment.Text.Trim() + "','" + Util.GetString(ViewState["TransactionID"]).Trim() + "','" + Util.GetString(ViewState["PatientID"]).Trim() + "','" + ViewState["UserID"] + "','" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "','1','" + txtBloodSugar.Text.Trim() + "','" + txtWeight.Text.Trim() + "','"+ddlWeightUnit.SelectedValue+"','" + txtOxygen.Text.Trim() + "','" + txtPOD.Text.Trim() + "','" + txtHeight.Text.Trim() + "','" + txtBMI.Text.Trim() + "','" + txtBSA.Text.Trim() + "','" + ddlInvasiveNonInvasive.SelectedValue + "','" + txtE.Text.Trim() + "','" + txtM.Text.Trim() + "','" + txtV.Text.Trim() + "','" + txtGCS.Text.Trim() + "','" + txtHeadCircumference.Text.Trim() + "','" + txtOxygenFlow.Text.Trim() + "','"+txtIncubation.Text.Trim()+"')";
            StockReports.ExecuteDML(str);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "modelAlert('Record Saved Successfully');", true);
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

        sb.Append(" SELECT ipo.WeightUnit,ipo.Height,ipo.BMI,ipo.BSA,ipo.ID,DATE_FORMAT(ipo.DATE,'%d-%b-%Y') AS DATE,Date_Format(ipo.Time, '%l:%i %p') Time,ipo.Temp,ipo.POD,ipo.pulse,ipo.resp,ipo.BP,ipo.wound,ipo.drains,ipo.BloodSugar,ipo.Weight,ipo.Oxygen,ipo.comments,Replace(ipo.TransactionID,'ISHHI','')IPDNo,ipo.PatientID,ipo.CreatedBy, ");
        sb.Append(" (Select concat(title,' ',name) from Employee_master where EmployeeID=ipo.CreatedBy)EmpName,CONCAT(dm.title,'',dm.name) AS DoctorName,CONCAT(pm.Title,'',pm.PName) AS PatientName,pmh.DateOfVisit,CONCAT(em.title,'',em.name) AS Username,TIMESTAMPDIFF(MINUTE,ipo.CreatedDate,NOW())createdDateDiff,ipo.InvasiveNonInvasive,if(ipo.BP='','',ipo.InvasiveNonInvasive)InvasiveNonInvasivebind,IFNULL(ipo.E,'')E,IFNULL(ipo.M,'')M,IFNULL(ipo.V,'')V,ifnull(GCS,'')GCS,IFNUll(Headcircumference,'')Headcircumference,IFNULL(OxygenFlow,'')OxygenFlow,IF(IFNULL(ipo.Incubation,'0')='0','False','True')Incubation,IF(IFNULL(ipo.Incubation,'0')='0','No','Yes')Incubation1 FROM IPD_Patient_ObservationChart ipo ");
        sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.PatientID = ipo.PatientID ");
        sb.Append(" INNER JOIN Doctor_master dm ON dm.DoctorID = pmh.DoctorID ");
        sb.Append(" INNER JOIN patient_master pm ON pm.PatientID = pmh.PatientID ");
        sb.Append(" LEFT JOIN employee_master em ON em.employeeID = ipo.CreatedBy ");
        sb.Append(" WHERE ipo.transactionID = '" + ViewState["TransactionID"] + "' GROUP BY ipo.ID order by ipo.Date Desc,ipo.time desc  ");
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
            decimal createdDateDiff = Util.GetDecimal(((Label)grdNursing.Rows[id].FindControl("lblTimeDiff")).Text);
            if (((Label)grdNursing.Rows[id].FindControl("lblUserID")).Text == Session["ID"].ToString() && createdDateDiff < Util.GetDecimal(Resources.Resource.EditTimePeriod))
            {
            lblID.Text = ((Label)grdNursing.Rows[id].FindControl("lblID")).Text;
            //txtDate.Text = ((Label)grdNursing.Rows[id].FindControl("lblDate")).Text;
            //txtTime.Text = ((Label)grdNursing.Rows[id].FindControl("lblTime")).Text;
            txtTemp.Text = ((Label)grdNursing.Rows[id].FindControl("lblTemp")).Text;
            txtPulse.Text = ((Label)grdNursing.Rows[id].FindControl("lblPulse")).Text;
            txtResp.Text = ((Label)grdNursing.Rows[id].FindControl("lblResp")).Text;
            txtBP.Text = ((Label)grdNursing.Rows[id].FindControl("lblBP")).Text;
            txtwounds.Text = ((Label)grdNursing.Rows[id].FindControl("lblwounds")).Text;
            txtDrains.Text = ((Label)grdNursing.Rows[id].FindControl("lbldrains")).Text;
            txtComment.Text = ((Label)grdNursing.Rows[id].FindControl("lblComments")).Text;
            txtBloodSugar.Text = ((Label)grdNursing.Rows[id].FindControl("lblBoodSugar")).Text;
            txtWeight.Text = ((Label)grdNursing.Rows[id].FindControl("lblWeight")).Text;
            if (((Label)grdNursing.Rows[id].FindControl("lblWeightUnit")).Text!="")
                 {
            ddlWeightUnit.Text = ((Label)grdNursing.Rows[id].FindControl("lblWeightUnit")).Text;
                }
            txtOxygen.Text = ((Label)grdNursing.Rows[id].FindControl("lblOxygen")).Text;
            txtPOD.Text = ((Label)grdNursing.Rows[id].FindControl("lblPOD")).Text;
            txtHeight.Text = ((Label)grdNursing.Rows[id].FindControl("lblHeight")).Text;
            lblBMI.Text = ((Label)grdNursing.Rows[id].FindControl("lblBMI")).Text;
            lblBSA.Text = ((Label)grdNursing.Rows[id].FindControl("lblBSA")).Text;
            txtBMI.Text = ((Label)grdNursing.Rows[id].FindControl("lblBMI")).Text;
            txtBSA.Text = ((Label)grdNursing.Rows[id].FindControl("lblBSA")).Text;
            txtE.Text = ((Label)grdNursing.Rows[id].FindControl("lblE")).Text;
            txtM.Text = ((Label)grdNursing.Rows[id].FindControl("lblM")).Text;
            txtV.Text = ((Label)grdNursing.Rows[id].FindControl("lblV")).Text;
            txtGCS.Text = ((Label)grdNursing.Rows[id].FindControl("lblGCS")).Text;
            lblGCS.Text = ((Label)grdNursing.Rows[id].FindControl("lblGCS")).Text;
            txtHeadCircumference.Text = ((Label)grdNursing.Rows[id].FindControl("lblHead")).Text;
            txtOxygenFlow.Text = ((Label)grdNursing.Rows[id].FindControl("lblOxygenFlow")).Text;
            chkIncubation.Checked = Util.GetBoolean(((Label)grdNursing.Rows[id].FindControl("lblIncubation")).Text);
            if (chkIncubation.Checked)
            {
                txtIncubation.Text = "1";
                lblincubation.Text="T";
            }
            else{txtIncubation.Text = "0";
            lblincubation.Text = "";
            }
            string invnoninv = ((Label)grdNursing.Rows[id].FindControl("lblInvasiveNonInvasive")).Text;
            if (invnoninv == "Invasive")
            {
                ddlInvasiveNonInvasive.SelectedIndex = 0;
            }
            else
            {
                if (invnoninv == "NonInvasive")
                {
                    ddlInvasiveNonInvasive.SelectedIndex = 1;
                }
                

            }
      
            btnUpdate.Visible = true;
            Btnsave.Visible = false;
            btnCancel.Visible = true;
            }
            else
            {
                ((ImageButton)grdNursing.Rows[id].FindControl("imgbtnEdit")).Enabled = false;
                lblMsg.Text = "You are not able to Edit this vital after 12 hrs";
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
            string str = "UPDATE IPD_Patient_ObservationChart SET DATE='" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "',TIME='" + Util.GetDateTime(txtTime.Text).ToString("HH:mm") + "',Temp='" + TempConvert + "',Pulse='" + txtPulse.Text + "',Resp='" + txtResp.Text + "',Bp='" + txtBP.Text + "',Wound='" + txtwounds.Text + "',Drains='" + txtDrains.Text + "',Comments='" + txtComment.Text + "',CreatedDate='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm::ss") + "',BloodSugar='" + txtBloodSugar.Text.Trim() + "',Weight='" + txtWeight.Text.Trim() + "',WeightUnit='"+ddlWeightUnit.SelectedValue+"',Oxygen='" + txtOxygen.Text.Trim() + "',POD='" + txtPOD.Text.Trim() + "',BSA='" + txtBSA.Text.Trim() + "',Height='" + txtHeight.Text.Trim() + "',BMI='" + txtBMI.Text.Trim() + "',InvasiveNonInvasive='" + ddlInvasiveNonInvasive.SelectedValue + "',E='" + txtE.Text.Trim() + "',M='" + txtM.Text.Trim() + "',V='" + txtV.Text.Trim() + "',GCS='" + txtGCS.Text.Trim() + "',Headcircumference='" + txtHeadCircumference.Text.Trim() + "',OxygenFlow='" + txtOxygenFlow.Text.Trim() + "',Incubation='"+txtIncubation.Text.Trim()+"' WHERE ID='" + lblID.Text + "'";
            int result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
            if (result == 1)
                // lblMsg.Text = "Record Updated Successfully";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "modelAlert('Record Update Successfully');", true);
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
        DataSet ds = new DataSet();
        ds.Tables.Add(dt.Copy());
        ds.Tables[0].TableName = "Observation";
        DataTable dtImg = All_LoadData.CrystalReportLogo();
        ds.Tables.Add(dtImg.Copy());
        ds.Tables[1].TableName = "logo";
        Session["ReportName"] = "ObservationChart";
        Session["ds"] = ds;
       // ds.WriteXmlSchema(@"E:\obervationAnkur.xml");

        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);


    }

}