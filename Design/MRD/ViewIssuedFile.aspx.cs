using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.Services;
using MySql.Data.MySqlClient;
using System.IO;

public partial class Design_MRD_ViewIssuedFile : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["LoginType"] == null && Session["UserName"] == null)
            {
                Response.Redirect("~/Default.aspx");
            }
            else
            {
                ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                Fromdatecal.EndDate = DateTime.Now.AddDays(0);
                ToDatecal.EndDate = DateTime.Now.AddDays(0);
            }
        }
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");

    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        search();
    }
    private void search()
    {
        lblMsg.Text = "";
      
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT mfi.File_Issue_ID AS fileid,mfr.patientid AS patient_id,mfi.Department,mfi.Issue_To_name AS issuename, ");
        sb.Append("CONCAT(em.Title,' ',em.Name)issuedfrom,DATE(mfi.IssueDate) IssueDate,mfd.`UploadStatus`, CONCAT(pm.Title,' ',pm.Pname)patientName,");
        sb.Append("mfr.TransactionID AS Transaction_id,mfi.`Avg_ReturnTime`,mfr.`MRDRequisitionID` RequestedID   FROM mrd_filerequisition mfr ");
        sb.Append("INNER JOIN mrd_file_issue mfi ON mfi.RequestedID = mfr.MRDRequisitionID ");
        sb.Append("INNER JOIN mrd_file_detail mfd ON mfd.FileID = mfr.FileID ");
        sb.Append("INNER JOIN employee_Master em ON em.EmployeeID= mfi.Issue_By ");
        sb.Append("INNER JOIN patient_medical_history pmh ON pmh.`TransactionID`=mfr.TransactionID ");
        sb.Append(" INNER JOIN patient_master pm ON pm.patientId=pmh.patientId ");
        sb.Append("WHERE mfi.IsIssued='1' AND mfi.IsReturn='0' AND mfr.RequestedBy='" + Session["ID"].ToString() + "' ");
        if (txtMrno.Text.Trim() != "")
        {
            sb.Append("  And mfm.PatientID='" + txtMrno.Text + "'");
        }
        if (txtpname.Text.Trim() != "")
        {
            sb.Append("  And pm.patientName like '%" + txtpname.Text + "%'");
        }
        if (txtIPDNo.Text.Trim() != "")
        {
            string TransactionId = StockReports.getTransactionIDbyTransNo(txtIPDNo.Text.Trim());
            sb.Append(" And pmh.TransactionID='" + TransactionId + "' ");
        }
        if (txtIPDNo.Text.Trim() == "" && txtMrno.Text.Trim() == "")
            sb.Append("  AND DATE(mfi.issuedate)>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' and DATE(mfi.issuedate) <= '" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'");
        sb.Append("  GROUP BY  mfr.MRDRequisitionID");
        DataTable dtMRD = StockReports.GetDataTable(sb.ToString());
        dtMRD.Columns.Add("Url", typeof(System.String));
        for (int i = 0; i < dtMRD.Rows.Count; i++)
        {
            //if (File.Exists(dtMRD.Rows[0]["FileURL"].ToString()))
            //    dtMRD.Rows[i]["Url"] = AllLoaddate_MRD.PhotoBase64ImgSrc(dtMRD.Rows[0]["FileURL"].ToString());
            //else
            //    dtMRD.Rows[i]["Url"] = "";
        }
        if (dtMRD.Rows.Count > 0)
        {
            grdMRD.DataSource = dtMRD;
            grdMRD.DataBind();
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Patient Record Not Found',function(){});", true);
            grdMRD.DataSource = null;
            grdMRD.DataBind();
        }
    }
    protected void grdMRD_RowDataBound(object sender, System.Web.UI.WebControls.GridViewRowEventArgs e)
    {
        Label Url = new Label();
        Url=(Label)e.Row.FindControl("lblpdfUrl");
        HtmlImage btn = new HtmlImage();
        
        btn = (HtmlImage)e.Row.FindControl("imgShowPdf");
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (Url.Text.Split('#')[0] == "0")
            {
              
                btn.Visible = false;
            }
            HiddenField Day = (HiddenField)e.Row.FindControl("hdReturnTime");
            string lblIssueDate = ((Label)e.Row.FindControl("lblIssueDate")).Text;
            string CurrentTime = DateTime.Now.ToString();
            DateTime IssueDate = Util.GetDateTime(lblIssueDate);
            DateTime CurrentDate = Util.GetDateTime(CurrentTime);
            double hour = Util.GetInt(Day.Value.Split(' ')[0]) * 24 + Util.GetInt(Day.Value.Split(' ')[2]);

            double currentHour = (CurrentDate - IssueDate).TotalHours;
            //if (currentHour > hour)
            //{
            //    e.Row.Attributes.Add("style", "background-color:lightYellow");
            //    btn.Visible = false;
            //}
        }
    }
    [WebMethod(EnableSession = true)]
    public static string UpdateNotification(string RequestID, string FileID)
    {
        try
        {
            All_LoadData.updateNotification(FileID + "#" + RequestID, "", HttpContext.Current.Session["RoleId"].ToString(), 36, null, "MRD");
            return "";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }
}