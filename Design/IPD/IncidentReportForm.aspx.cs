using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_IPD_IncidentReportForm : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string TID = Request.QueryString["TransactionID"].ToString();
            string PID = Request.QueryString["PatientID"].ToString();
            ViewState["TID"] = TID;
            ViewState["PID"] = PID;
            ViewState["ID"] = Session["ID"].ToString();
            txtIncidentDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtDateOfOccurrence.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtTime.Text = DateTime.Now.ToString("hh:mm tt");
            bindIncidetDetail();

            DataTable dt = AllLoadData_IPD.getAdmitDischargeData(TID);
            calDate.StartDate = Util.GetDateTime(dt.Rows[0]["DateofAdmit"]);
            if (dt.Rows[0]["Status"].ToString() == "OUT")
                calDate.EndDate = Util.GetDateTime(dt.Rows[0]["DateofDischarge"]);
            else
                calDate.EndDate = DateTime.Now;
        }
        txtIncidentDate.Attributes.Add("readOnly", "true");
        txtDateOfOccurrence.Attributes.Add("readOnly", "true");
    }

    private void getIncidentID()
    {
        lblIncidentReportID.Text = StockReports.ExecuteScalar("SELECT IFNULL(MAX(IncidentReportID)+1,1)ID FROM nursing_IncidentReportForm");
    }

    private void bindIncidetDetail()
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT ID,IncidentReportID,IncidentDate, PatientID,TransactionID,PersonName,Designation,Department,DateOfOccurrence,TimeOfOccurrence,");
        sb.Append(" ExactLocation,TypeOfIncident,OtherIncident,IncidentDetail,FactsBehind,Describes,Corrective FROM nursing_IncidentReportForm ");
        sb.Append(" WHERE TransactionID='" + ViewState["TID"].ToString() + "' AND IsActive=1");
        if (txtIncidentDate.Text != "")
            sb.Append(" And IncidentDate='" + Util.GetDateTime(txtIncidentDate.Text).ToString("yyyy-MM-dd") + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            lblIncidentReportNo.Text = dt.Rows[0]["ID"].ToString();
            lblIncidentReportID.Text = dt.Rows[0]["IncidentReportID"].ToString();
            txtIncidentDate.Text = Util.GetDateTime(dt.Rows[0]["IncidentDate"].ToString()).ToString("dd-MMM-yyyy");
            txtName.Text = dt.Rows[0]["PersonName"].ToString();
            txtDesignation.Text = dt.Rows[0]["Designation"].ToString();
            txtDepartment.Text = dt.Rows[0]["Department"].ToString();
            txtDateOfOccurrence.Text = Util.GetDateTime(dt.Rows[0]["DateOfOccurrence"].ToString()).ToString("dd-MMM-yyyy");
            txtTime.Text = Util.GetDateTime(dt.Rows[0]["TimeOfOccurrence"].ToString()).ToString("hh:mm tt");
            txtExactLocation.Text = dt.Rows[0]["ExactLocation"].ToString();

            if (dt.Rows[0]["TypeOfIncident"].ToString() != "")
            {
                int len = Util.GetInt(dt.Rows[0]["TypeOfIncident"].ToString().Split('$').Length);
                string[] Item = new string[len];
                Item = dt.Rows[0]["TypeOfIncident"].ToString().Split('$');
                for (int i = 0; i < len; i++)
                {
                    for (int k = 0; k <= chkTypeOfIncident.Items.Count - 1; k++)
                    {
                        if (Item[i] == chkTypeOfIncident.Items[k].Text)
                        {
                            chkTypeOfIncident.Items[k].Selected = true;
                        }
                    }
                }
            }
            txtOtherIncident.Text = dt.Rows[0]["OtherIncident"].ToString();
            txtIncidentDetail.Text = dt.Rows[0]["IncidentDetail"].ToString();
            txtFactsBehind.Text = dt.Rows[0]["FactsBehind"].ToString();
            txtDescribe.Text = dt.Rows[0]["Describes"].ToString();
            txtCorrective.Text = dt.Rows[0]["Corrective"].ToString();
            btnSave.Text = "Update";
            btnPrint.Visible = true;
            lblMsg.Text = "";
        }
        else
        {
            clear();
            btnSave.Text = "Save";
            btnPrint.Visible = false;
            getIncidentID();
            lblMsg.Text = "No Detail Found";
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        MySqlConnection con = new MySqlConnection(Util.GetConString());
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string TypeOfIncident = "";
            if (chkTypeOfIncident.SelectedIndex >= 0)
            {

                foreach (ListItem li in chkTypeOfIncident.Items)
                {
                    if (li.Selected == true)
                    {
                        if (TypeOfIncident != string.Empty)
                        {
                            TypeOfIncident += "$" + li.Text + "";
                        }
                        else
                        {

                            TypeOfIncident = "" + li.Text + "";
                        }

                    }


                }

            }
            StringBuilder sb = new StringBuilder();
            if (btnSave.Text == "Update")
            {
                sb.Append(" UPDATE nursing_IncidentReportForm SET IsActive=0,UpdatedDate=NOW(),UpdatedBy='" + ViewState["ID"].ToString() + "' Where ID='" + lblIncidentReportNo.Text + "'");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            }
            sb.Clear();
            sb.Append(" INSERT INTO nursing_IncidentReportForm(IncidentReportID,IncidentDate, PatientID,TransactionID,PersonName,Designation,Department,DateOfOccurrence,TimeOfOccurrence,");
            sb.Append(" ExactLocation,TypeOfIncident,OtherIncident,IncidentDetail,FactsBehind,Describes,Corrective,CreatedBy");
            sb.Append(" ");
            sb.Append(" ) VALUES( '" + lblIncidentReportID.Text + "',");
            sb.Append(" '" + Util.GetDateTime(txtIncidentDate.Text).ToString("yyyy-MM-dd") + "','" + ViewState["PID"].ToString() + "','" + ViewState["TID"].ToString() + "','" + txtName.Text.Trim() + "','" + txtDesignation.Text.Trim() + "','" + txtDepartment.Text.Trim() + "',");
            sb.Append(" '" + Util.GetDateTime(txtDateOfOccurrence.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(txtTime.Text).ToString("HH:mm:ss") + "','" + txtExactLocation.Text.Trim() + "',");
            sb.Append(" '" + TypeOfIncident.Trim() + "','" + txtOtherIncident.Text.Trim() + "','" + txtIncidentDetail.Text.Trim() + "',");
            sb.Append(" '" + txtFactsBehind.Text.Trim() + "','" + txtDescribe.Text.Trim() + "','" + txtCorrective.Text.Trim() + "','" + ViewState["ID"].ToString() + "' ");
            sb.Append(" )");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            tnx.Commit();
            lblMsg.Text = "Record Saved Successfully";
            clear();
            bindIncidetDetail();
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
    protected void btnPrint_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT IncidentDate,PersonName,Designation,Department,DateOfOccurrence, ");
        sb.Append("Date_Format(TimeOfOccurrence,'%l:%m %p')TimeOfOccurrence,ExactLocation,TypeOfIncident,OtherIncident,IncidentDetail,FactsBehind,Describes,Corrective,IncidentReportID,em.name AS EmployeeName ");
        sb.Append("FROM nursing_IncidentReportForm inc  ");
        sb.Append("INNER JOIN employee_master em ON em.Employee_ID=inc.CreatedBy  ");
        sb.Append("WHERE inc.IsActive=1 AND TransactionID='" + ViewState["TID"].ToString() + "' AND IncidentDate='" + Util.GetDateTime(txtIncidentDate.Text).ToString("yyyy-MM-dd") + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            ds.Tables[0].TableName = "IncidentReport";
            AllQuery AQ = new AllQuery();
            DataTable dtStatus = AQ.GetPatientDischargeStatus(ViewState["TID"].ToString());
            string Status = dtStatus.Rows[0]["Status"].ToString();
            DataTable dtInfo = AQ.GetPatientIPDInformation("", ViewState["TID"].ToString(), Status);
            ds.Tables.Add(dtInfo.Copy());
            ds.Tables[1].TableName = "PatientInfo";
            DataTable dtImg = All_LoadData.CrystalReportLogo();
            ds.Tables.Add(dtImg.Copy());
            ds.Tables[2].TableName = "logo";
            Session["ReportName"] = "IncidentReportForm";
            Session["ds"] = ds;
            //  ds.WriteXmlSchema(@"E:\Incident.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
        }
        else
        {
            lblMsg.Text = "Record Not Found";
        }
    }
    protected void txtIncidentDate_TextChanged(object sender, EventArgs e)
    {
        bindIncidetDetail();
    }
    private void clear()
    {
        lblIncidentReportNo.Text = "";
        lblIncidentReportID.Text = "";
        txtName.Text = "";
        txtDesignation.Text = "";
        txtDepartment.Text = "";
        txtDateOfOccurrence.Text = "";
        txtTime.Text = "";
        txtExactLocation.Text = "";
        chkTypeOfIncident.ClearSelection();
        txtOtherIncident.Text = "";
        txtIncidentDetail.Text = "";
        txtFactsBehind.Text = "";
        txtDescribe.Text = "";
        txtCorrective.Text = "";
        btnSave.Text = "Save";
        btnPrint.Visible = false;
    }
}