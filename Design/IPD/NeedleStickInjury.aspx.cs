using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_IPD_NeedleStickInjury : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string TID = Request.QueryString["TransactionID"].ToString();
            string PID = Request.QueryString["PatientID"].ToString();
            ViewState["TID"] = TID;
            ViewState["PID"] = PID;
            txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtIncidentDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtReportingDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtHEPDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtTetanusDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtTime.Text = DateTime.Now.ToString("hh:mm tt");
            txtIncidentTime.Text = DateTime.Now.ToString("hh:mm tt");
            txtReportingTime.Text = DateTime.Now.ToString("hh:mm tt");
            ViewState["ID"] = Session["ID"].ToString();
            bindEmployee();
            bindInjury();
            DataTable dt = AllLoadData_IPD.getAdmitDischargeData(TID);
            calDate.StartDate = Util.GetDateTime(dt.Rows[0]["DateofAdmit"]);
            if (dt.Rows[0]["Status"].ToString() == "OUT")
                calDate.EndDate = Util.GetDateTime(dt.Rows[0]["DateofDischarge"]);
            else
                calDate.EndDate = DateTime.Now;
            calIncidentDate.EndDate = DateTime.Now;
            calReportingDate.EndDate = DateTime.Now;
            calHEPDate.EndDate = DateTime.Now;
            calTetanusDate.EndDate = DateTime.Now;
        }
        txtDate.Attributes.Add("readOnly", "readOnly");
        txtIncidentDate.Attributes.Add("readOnly", "readOnly");
        txtReportingDate.Attributes.Add("readOnly", "readOnly");
        txtHEPDate.Attributes.Add("readOnly", "readOnly");
        txtTetanusDate.Attributes.Add("readOnly", "readOnly");
    }

    private void bindEmployee()
    {
        DataTable dt = All_LoadData.LoadEmployee();
        if (dt.Rows.Count > 0)
        {
            ddlName.DataSource = dt;
            ddlName.DataTextField = "NAME";
            ddlName.DataValueField = "EmployeeID";
            ddlName.DataBind();
            ddlName.Items.Insert(0, new ListItem("Select", "0"));
        }
    }

    private void bindInjury()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ID,EmployeeID,EmployeeName,NeedleStickDate,NeedleStickTime,Age,Sex,Ward,Address,Designation,DateofIncident,TimeofIncident,");
        sb.Append(" DateofReporting,TimeofReporting,Procedures,Activities,NatureOfInjury,Contamination,FirstAid,GlovesWorn,HEPB,Tetanus,SourceOfPatient,AntiHCV,HbsAg ");
        sb.Append(" FROM nursing_needleStick_Injury  WHERE TransactionID='" + ViewState["TID"].ToString() + "' AND IsActive=1 ");
        if (txtDate.Text != "")
            sb.Append(" AND NeedleStickDate='" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "' ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            lblInjuryID.Text = dt.Rows[0]["ID"].ToString();
            ddlName.SelectedIndex = ddlName.Items.IndexOf(ddlName.Items.FindByValue(dt.Rows[0]["EmployeeID"].ToString()));
            txtDate.Text = Util.GetDateTime(dt.Rows[0]["NeedleStickDate"].ToString()).ToString("dd-MMM-yyyy");
            txtTime.Text = Util.GetDateTime(dt.Rows[0]["NeedleStickTime"].ToString()).ToString("hh:mm tt");
            txtAge.Text = dt.Rows[0]["Age"].ToString().Split(' ')[0];
            ddlAge.SelectedIndex = ddlName.Items.IndexOf(ddlName.Items.FindByValue(dt.Rows[0]["Age"].ToString()));
            lblWard.Text = dt.Rows[0]["Ward"].ToString();
            rblSex.SelectedIndex = rblSex.Items.IndexOf(rblSex.Items.FindByValue(dt.Rows[0]["Sex"].ToString()));
            txtAddress.Text = dt.Rows[0]["Address"].ToString();
            txtDesignation.Text = dt.Rows[0]["Designation"].ToString();
            txtIncidentDate.Text = Util.GetDateTime(dt.Rows[0]["DateofIncident"].ToString()).ToString("dd-MMM-yyyy");
            txtIncidentTime.Text = Util.GetDateTime(dt.Rows[0]["TimeofIncident"].ToString()).ToString("hh:mm tt");
            txtReportingDate.Text = Util.GetDateTime(dt.Rows[0]["DateofReporting"].ToString()).ToString("dd-MMM-yyyy");
            txtReportingTime.Text = Util.GetDateTime(dt.Rows[0]["TimeofReporting"].ToString()).ToString("hh:mm tt");
            txtProcedure.Text = dt.Rows[0]["Procedures"].ToString();
            txtActivities.Text = dt.Rows[0]["Activities"].ToString();
            if (dt.Rows[0]["NatureOfInjury"].ToString() != "")
            {
                int len = Util.GetInt(dt.Rows[0]["NatureOfInjury"].ToString().Split('$').Length);
                string[] Item = new string[len];
                Item = dt.Rows[0]["NatureOfInjury"].ToString().Split('$');
                for (int i = 0; i < len; i++)
                {
                    for (int k = 0; k <= chkInjury.Items.Count - 1; k++)
                    {
                        if (Item[i] == chkInjury.Items[k].Text)
                        {
                            chkInjury.Items[k].Selected = true;
                        }
                    }
                }
            }

            rblContamination.SelectedIndex = rblContamination.Items.IndexOf(rblContamination.Items.FindByText(dt.Rows[0]["Contamination"].ToString()));
            rblFirstAid.SelectedIndex = rblFirstAid.Items.IndexOf(rblFirstAid.Items.FindByText(dt.Rows[0]["FirstAid"].ToString()));
            rblGlovesWorn.SelectedIndex = rblGlovesWorn.Items.IndexOf(rblGlovesWorn.Items.FindByText(dt.Rows[0]["GlovesWorn"].ToString()));
            txtHEPDate.Text = Util.GetDateTime(dt.Rows[0]["HEPB"].ToString()).ToString("dd-MMM-yyyy");
            txtTetanusDate.Text = Util.GetDateTime(dt.Rows[0]["Tetanus"].ToString()).ToString("dd-MMM-yyyy");
            rblSourceofPatient.SelectedIndex = rblSourceofPatient.Items.IndexOf(rblSourceofPatient.Items.FindByText(dt.Rows[0]["SourceOfPatient"].ToString()));
            rblAntiHCV.SelectedIndex = rblAntiHCV.Items.IndexOf(rblAntiHCV.Items.FindByText(dt.Rows[0]["AntiHCV"].ToString()));
            rblHbsAg.SelectedIndex = rblHbsAg.Items.IndexOf(rblHbsAg.Items.FindByText(dt.Rows[0]["HbsAg"].ToString()));
            btnSave.Text = "Update";
            btnPrint.Visible = true;
        }
        else
        {
            Clear();
            btnSave.Text = "Save";
            btnPrint.Visible = false;
        }
        AllQuery AQ = new AllQuery();
        DataTable dt1 = AQ.GetPatientIPDInformation("", ViewState["TID"].ToString(), "IN");
        if (dt1 != null && dt1.Rows.Count > 0)
        {
            lblWard.Text = dt1.Rows[0]["RoomNo"].ToString();
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        int a = rblSex.SelectedIndex;

        MySqlConnection con = new MySqlConnection(Util.GetConString());
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string Injury = "";
            if (chkInjury.SelectedIndex >= 0)
            {

                foreach (ListItem li in chkInjury.Items)
                {
                    if (li.Selected == true)
                    {
                        if (Injury != string.Empty)
                        {
                            Injury += "$" + li.Text + "";
                        }
                        else
                        {

                            Injury = "" + li.Text + "";
                        }

                    }


                }

            }
            StringBuilder sb = new StringBuilder();
            if (btnSave.Text == "Update")
            {
                sb.Append(" UPDATE nursing_needleStick_Injury SET IsActive=0,UpdatedDate=NOW(),UpdatedBy='" + ViewState["ID"].ToString() + "' Where ID='" + lblInjuryID.Text + "'");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            }
            sb.Clear();
            sb.Append(" INSERT INTO nursing_needleStick_Injury(PatientID,TransactionID,EmployeeID,EmployeeName,NeedleStickDate,NeedleStickTime,Age,Sex,Ward,Address,Designation,DateofIncident,TimeofIncident,");
            sb.Append(" DateofReporting,TimeofReporting,Procedures,Activities,NatureOfInjury,Contamination,FirstAid,GlovesWorn,HEPB,Tetanus,SourceOfPatient,AntiHCV,HbsAg,CreatedBy ");
            sb.Append(" )");
            sb.Append(" VALUES('" + ViewState["PID"].ToString() + "','" + ViewState["TID"].ToString() + "','" + ddlName.SelectedValue + "','" + ddlName.SelectedItem.Text + "','" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(txtTime.Text).ToString("HH:mm:ss") + "', ");
            sb.Append(" '" + txtAge.Text + " " + ddlAge.SelectedItem.Text + "', ");
            if (rblSex.SelectedIndex != -1)
                sb.Append(" '" + rblSex.SelectedValue + "', ");
            else
                sb.Append(" ' ' ,");
            sb.Append(" '" + lblWard.Text + "','" + txtAddress.Text + "','" + txtDesignation.Text + "', ");
            sb.Append(" '" + Util.GetDateTime(txtIncidentDate.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(txtIncidentTime.Text).ToString("HH:mm:ss") + "','" + Util.GetDateTime(txtReportingDate.Text).ToString("yyyy-MM-dd") + "',");
            sb.Append(" '" + Util.GetDateTime(txtReportingTime.Text).ToString("HH:mm:ss") + "','" + txtProcedure.Text + "','" + txtActivities.Text + "','" + Injury + "','" + rblContamination.SelectedItem.Text + "',");
            sb.Append(" '" + rblFirstAid.SelectedItem.Text + "','" + rblGlovesWorn.SelectedItem.Text + "','" + Util.GetDateTime(txtHEPDate.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(txtTetanusDate.Text).ToString("yyyy-MM-dd") + "',");
            sb.Append(" '" + rblSourceofPatient.SelectedItem.Text + "','" + rblAntiHCV.SelectedItem.Text + "','" + rblHbsAg.SelectedItem.Text + "','" + ViewState["ID"].ToString() + "' ");
            sb.Append(" )");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            tnx.Commit();
            lblMsg.Text = "Record Saved Successfully";
            Clear();
            bindInjury();
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = "Error occurred, Please contact administrator";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
    protected void ddlName_SelectedIndexChanged(object sender, EventArgs e)
    {
        DataTable dt = StockReports.GetDataTable("SELECT House_No FROM employee_master WHERE EmployeeID='" + ddlName.SelectedValue + "'");
    }
    protected void btnPrint_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ID,EmployeeID,EmployeeName,Date_Format(NeedleStickDate,'%d-%b-%Y')NeedleStickDate,Date_format(NeedleStickTime,'%l:m% %p')NeedleStickTime,Age,Sex,Ward,Address,Designation,Date_format(DateofIncident,'%d-%b-%Y')DateofIncident,Date_format(TimeofIncident,'%l:%m %p')TimeofIncident,");
        sb.Append(" Date_Format(DateofReporting,'%d-%b-%Y')DateofReporting,Date_Format(TimeofReporting,'%l:%m %p')TimeofReporting,Procedures,Activities,NatureOfInjury,Contamination,FirstAid,GlovesWorn,Date_format(HEPB,'%d-%b-%Y')HEPB,Date_format(Tetanus,'%d-%b-%Y')Tetanus,SourceOfPatient,AntiHCV,HbsAg ");
        sb.Append(" FROM nursing_needleStick_Injury  WHERE TransactionID='" + ViewState["TID"].ToString() + "' AND IsActive=1 ");
        if (txtDate.Text != "")
            sb.Append(" AND NeedleStickDate='" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "' ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            ds.Tables[0].TableName = "NeedleInjury";
            AllQuery AQ = new AllQuery();
            DataTable dtStatus = AQ.GetPatientDischargeStatus(ViewState["TID"].ToString());
            string Status = dtStatus.Rows[0]["Status"].ToString();
            DataTable dtInfo = AQ.GetPatientIPDInformation("", ViewState["TID"].ToString(), Status);
            ds.Tables.Add(dtInfo.Copy());
            ds.Tables[1].TableName = "PatientInfo";
            DataTable dtImg = All_LoadData.CrystalReportLogo();
            ds.Tables.Add(dtImg.Copy());
            ds.Tables[2].TableName = "logo";
            Session["ReportName"] = "NeedleInjuryReport";
            Session["ds"] = ds;
            // ds.WriteXmlSchema(@"E:\Needle.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
        }
        else
        {
            lblMsg.Text = "Record Not Found";
        }

    }
    protected void txtDate_TextChanged(object sender, EventArgs e)
    {
        bindInjury();
    }
    private void Clear()
    {
        lblInjuryID.Text = "";
        ddlName.SelectedIndex = -1;
        txtTime.Text = "";
        txtAge.Text = "";
        ddlAge.SelectedIndex = -1;
        lblWard.Text = "";
        rblSex.SelectedIndex = -1;
        txtAddress.Text = "";
        txtDesignation.Text = "";
        txtIncidentDate.Text = "";
        txtIncidentTime.Text = "";
        txtReportingDate.Text = "";
        txtReportingTime.Text = "";
        txtProcedure.Text = "";
        txtActivities.Text = "";
        rblContamination.SelectedIndex = 3;
        rblFirstAid.SelectedIndex = 1;
        rblGlovesWorn.SelectedIndex = 1;
        txtHEPDate.Text = "";
        txtTetanusDate.Text = "";
        rblSourceofPatient.SelectedIndex = 1;
        rblAntiHCV.SelectedIndex = 2;
        rblHbsAg.SelectedIndex = 2;
        chkInjury.ClearSelection();
    }
}