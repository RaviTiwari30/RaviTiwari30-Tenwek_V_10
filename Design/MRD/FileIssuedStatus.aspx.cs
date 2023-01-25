using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_MRD_FileIssuedStatus : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            bindPatientType();
        }
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");

    }
    private void bindPatientType()
    {
        DataTable dt = StockReports.GetDataTable("SELECT DISTINCT(pmh.TYPE)PType FROM patient_medical_history pmh ORDER BY TYPE");
        ddlPatientType.DataSource = dt;
        ddlPatientType.DataTextField = "PType";
        ddlPatientType.DataValueField = "PType";
        ddlPatientType.DataBind();
        ddlPatientType.Items.Insert(0, new ListItem("ALL"));
        ddlPatientType.SelectedIndex = 2;
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        search();
    }
    private void search()
        {
        lblMsg.Text = "";
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT mfm.fileid,mfm.PatientID,mfi.Department,mfi.Issue_To_name as issuename,mfm.issuedfrom,DATE_FORMAT(mfi.IssueDate, '%d-%m-%Y') IssueDate,pm.pname,mfm.ptype  FROM mrd_file_master mfm  ");
        sb.Append("  INNER JOIN mrd_file_issue mfi ON mfi.fileid = mfm.fileid ");
        sb.Append(" INNER JOIN patient_master pm ON pm.PatientID=mfm.PatientID");
        sb.Append("  WHERE mfi.IsIssued='1' AND mfi.IsReturn='0'  ");
        if (txtMrno.Text.Trim() != "")
        {
            sb.Append("  And mfm.PatientID='" + txtMrno.Text + "'");
        }
        if (txtpname.Text.Trim() != "")
        {
            sb.Append("  And pm.pname like '%" + txtpname.Text + "%'");
        }
        //if (rdbselectedtype.SelectedItem.Value == "1")
        //{
        //}
        else if (rdbselectedtype.SelectedItem.Value == "2")
        {
            sb.Append("   AND issuedfrom='" + rdbselectedtype.SelectedItem.Text + "'");
        }
        else if (rdbselectedtype.SelectedItem.Value == "3")
        {
            sb.Append("   AND issuedfrom='" + rdbselectedtype.SelectedItem.Text + "'");
        }
        else if (rdbselectedtype.SelectedItem.Value == "4")
        {
            sb.Append("   AND issuedfrom='" + rdbselectedtype.SelectedItem.Text + "'");
        }
        else if (ddlPatientType.SelectedValue != "ALL")
        {
            sb.Append(" and mfm.ptype='" + ddlPatientType.SelectedItem.Value + "' ");
        }
        sb.Append("  AND DATE(mfi.issuedate)>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' and DATE(mfi.issuedate) <= '" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'");
        sb.Append("  GROUP BY PatientID");
        DataTable dtMRD = StockReports.GetDataTable(sb.ToString());
        if (dtMRD.Rows.Count > 0)
            {
            grdMRD.DataSource = dtMRD;
            grdMRD.DataBind();
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('No Record Found',function(){});", true);
            grdMRD.DataSource = null;
            grdMRD.DataBind();
            }
        }
    }