using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_IPD_BabyGrowthForm : System.Web.UI.Page
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
        BindGraphWeight(ViewState["TransactionID"].ToString());
        BindGraphLength(ViewState["TransactionID"].ToString());
           
        txtDate.Enabled = false;
        txtTime.Enabled = false;

    }
    private void Clear()
    {
        txtWeight.Text = "";
        txtDate.Text = txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        txtTime.Text = DateTime.Now.Hour + ":" + DateTime.Now.Minute;
        txtLength.Text = "";
        lblMsg.Text = "";
        
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            string str = "insert into BabyGrowth (Date,Time,Weight,Length,TransactionID,PatientID,CreatedBy,CreatedDate) Values ('" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(txtTime.Text).ToString("HH:mm") + "','" + txtWeight.Text.Trim() + "','" + txtLength.Text.Trim() + "','" + Util.GetString(ViewState["TransactionID"]).Trim() + "','" + Util.GetString(ViewState["PatientID"]).Trim() + "','" + ViewState["UserID"] + "','" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "')";
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

        sb.Append(" SELECT ipo.ID,DATE_FORMAT(ipo.DATE,'%d-%b-%Y') AS DATE,Date_Format(ipo.Time, '%l:%i %p') Time,FORMAT(ipo.Weight,1)Weight,FORMAT(ipo.Length,0)Length,Replace(ipo.TransactionID,'ISHHI','')IPDNo,ipo.PatientID,ipo.CreatedBy, ");
        sb.Append(" (Select concat(title,' ',name) from Employee_master where EmployeeID=ipo.CreatedBy)EmpName,CONCAT(dm.title,'',dm.name) AS DoctorName,CONCAT(pm.Title,'',pm.PName) AS PatientName,pmh.DateOfVisit,CONCAT(em.title,'',em.name) AS Username,TIMESTAMPDIFF(MINUTE,ipo.CreatedDate,NOW())createdDateDiff FROM BabyGrowth ipo ");
        sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.PatientID = ipo.PatientID ");
        sb.Append(" INNER JOIN Doctor_master dm ON dm.DoctorID = pmh.DoctorID ");
        sb.Append(" INNER JOIN patient_master pm ON pm.PatientID = pmh.PatientID ");
        sb.Append(" LEFT JOIN employee_master em ON em.employeeID = ipo.CreatedBy ");
        // Below line commented because requirement came that for the patient all the previous details also should show.
       // sb.Append(" WHERE ipo.transactionID = '" + ViewState["TransactionID"] + "' GROUP BY ipo.ID order by ipo.Date Desc,ipo.time desc  ");
        sb.Append(" WHERE ipo.patientid = '" + ViewState["PatientID"] + "' GROUP BY ipo.ID order by ipo.Date Desc,ipo.time desc  ");
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
                txtWeight.Text = ((Label)grdNursing.Rows[id].FindControl("lblWeight")).Text;
                txtLength.Text = ((Label)grdNursing.Rows[id].FindControl("lblLength")).Text;
                
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
    private void BindGraphWeight(string TID)
    {
        try
        {
            DataTable dt = new DataTable();

            dt = StockReports.GetDataTable("SELECT Round(Weight,2) as Weight,CONCAT(DATE_FORMAT(c.CreatedDate,'%d-%b-%Y'),'/',DATE_FORMAT(c.CreatedDate,'%l:%i %p')) AS CreatedTime FROM BabyGrowth c WHERE c.TransactionID='" + TID + "' AND Weight<>''  ORDER BY CreatedDate");
            
            if (dt.Rows.Count > 0)
            {
                double minTemp = Convert.ToDouble(dt.Compute("min(Weight)", string.Empty));
                double maxTemp = Convert.ToDouble(dt.Compute("max(Weight)", string.Empty));
                //if (maxTemp > minTemp)
                {
                    chartWeight.DataSource = dt;
                    chartWeight.Legends.Add("Weight").Title = "Weight Graph";
                    chartWeight.ChartAreas["ChartArea1"].AxisX.Title = "DateTime";
                    if (minTemp < maxTemp)
                    {
                        chartWeight.ChartAreas["ChartArea1"].AxisY.Minimum = minTemp;
                        chartWeight.ChartAreas["ChartArea1"].AxisY.Maximum = maxTemp;
                    }
                    else
                    {
                        chartWeight.ChartAreas["ChartArea1"].AxisY.Minimum = maxTemp;
                        chartWeight.ChartAreas["ChartArea1"].AxisY.Maximum = minTemp;
                    }
                    chartWeight.ChartAreas["ChartArea1"].AxisY.Interval = 0.5;
                    chartWeight.ChartAreas["ChartArea1"].AxisY.Title = "Weight";
                    chartWeight.Series["Weight"].XValueMember = "CreatedTime";
                    chartWeight.Series["Weight"].YValueMembers = "Weight";
                    chartWeight.Series["Weight"].ToolTip = " #VALX | #VALY";
                    chartWeight.DataBind();
                }
               // else
                 //   lblMsg.Text = "Please Enter Correct Weight Data";
            }
            else
            {
                lblMsg.Text = "Weight Record Not Found";
            }
        }
        catch (Exception ex)
        {
            ClassLog log = new ClassLog();
            log.errLog(ex);
        }
    }

    private void BindGraphLength(string TID)
    {
        try
        {
            DataTable dt = new DataTable();

            dt = StockReports.GetDataTable("SELECT Round(Length,2) as Length,CONCAT(DATE_FORMAT(c.CreatedDate,'%d-%b-%Y'),'/',DATE_FORMAT(c.CreatedDate,'%l:%i %p')) AS CreatedTime FROM BabyGrowth c WHERE c.TransactionID='" + TID + "' AND Weight<>''  ORDER BY CreatedDate");

            if (dt.Rows.Count > 0)
            {
                double minTemp = Convert.ToDouble(dt.Compute("min(Length)", string.Empty));
                double maxTemp = Convert.ToDouble(dt.Compute("max(Length)", string.Empty));
                //if (maxTemp > minTemp)
                {
                    chartLength.DataSource = dt;
                    chartLength.Legends.Add("Length").Title = "Length Graph";
                    chartLength.ChartAreas["ChartArea1"].AxisX.Title = "DateTime";
                    if (minTemp < maxTemp)
                    {
                        chartLength.ChartAreas["ChartArea1"].AxisY.Minimum = minTemp;
                        chartLength.ChartAreas["ChartArea1"].AxisY.Maximum = maxTemp;
                    }
                    else
                    {
                        chartLength.ChartAreas["ChartArea1"].AxisY.Minimum = maxTemp;
                        chartLength.ChartAreas["ChartArea1"].AxisY.Maximum = minTemp;
                    }
                    chartLength.ChartAreas["ChartArea1"].AxisY.Interval = 0.5;
                    chartLength.ChartAreas["ChartArea1"].AxisY.Title = "Length";
                    chartLength.Series["Length"].XValueMember = "CreatedTime";
                    chartLength.Series["Length"].YValueMembers = "Length";
                    chartLength.Series["Length"].ToolTip = " #VALX | #VALY";
                    chartLength.DataBind();
                }
                // else
                //   lblMsg.Text = "Please Enter Correct Weight Data";
            }
            else
            {
                lblMsg.Text = "Weight Record Not Found";
            }
        }
        catch (Exception ex)
        {
            ClassLog log = new ClassLog();
            log.errLog(ex);
        }
    }
   
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection(Util.GetConString());
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string str = "UPDATE BabyGrowth SET DATE='" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "',TIME='" + Util.GetDateTime(txtTime.Text).ToString("HH:mm") + "',Weight='" + txtWeight.Text.Trim() + "',Length='" + txtLength.Text.Trim() + "',CreatedDate='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm::ss") + "' WHERE ID='" + lblID.Text + "'";
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