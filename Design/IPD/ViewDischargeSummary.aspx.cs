using System;
using System.Data;
using System.Web.UI;
using System.Text;


public partial class Design_IPD_ViewDischargeSummary : System.Web.UI.Page
{
    string TransactionID = "";
    string Status = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            string TransactionID = string.Empty;

            if (Request.QueryString["TransactionID"] == null)
                TransactionID = Request.QueryString["TID"].ToString();
            else
                TransactionID = Request.QueryString["TransactionID"].ToString();


           
            ViewState["TransactionID"] = TransactionID;
            //ViewState["PatientID"] = Request.QueryString["PatientID"].ToString();

            ViewState["PatientID"] = string.Empty;

            if (Request.QueryString["PatientID"] == null)
                ViewState["PatientID"] = Request.QueryString["PID"].ToString();
            else
                ViewState["PatientID"] = Request.QueryString["PatientID"].ToString();

            bind();
            if (Request.QueryString["Status"] == null)
                Status = StockReports.ExecuteScalar("Select Status from patient_medical_history where TransactionID='" + TransactionID + "'");//ipd_case_History
            else
                Status = Request.QueryString["Status"].ToString();
            Session.Add("TransactionID", TransactionID);
            Session.Add("Status", Status);




            ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtTime.Text = DateTime.Now.ToString("hh:mm tt"); ;
            

        }

    }
    public void bind()
    {
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        //sb.Append("SELECT det.HeaderName DS_FIELD,det.Detail DS_SUMMARY,hed.SeqNo SNO FROM d_discharge_header hed INNER JOIN emr_DRDetail det ");
        //sb.Append(" ON hed.Header_Id=det.Header_Id WHERE  TransactionID='" + ViewState["TransactionID"] + "' ORDER BY hed.SeqNo ");
        //dt = StockReports.GetDataTable(sb.ToString());
        //if (dt.Rows.Count > 0)
        //{
        //    btnDischarge.Visible = true;
        //}
        //else
        //{
            //Find All the Discharge Summary with PatientID for OPD Doctor module
            sb.Append(" SELECT emr.TransactionID,Status,pmh.TransNo IPDNo,DATE_FORMAT(emr.EntryDate,'%d-%b-%Y')DATE,(SELECT CONCAT(title,' ',NAME) ");
            sb.Append(" FROM Employee_master WHERE EmployeeID=emr.UserID)EntryBy,pmh.Status,IF(pmh.Status='OUT','Discharged','Admitted')DStatus,DATE_FORMAT(pmh.DateOfDischarge,'%d-%b-%Y')DateOfDischarge FROM emr_DRDetail emr  ");//INNER JOIN ipd_case_history ich ON ich.TransactionID=emr.TransactionID
            sb.Append(" INNER JOIN patient_medical_history pmh");
            sb.Append(" ON pmh.TransactionID=emr.TransactionID WHERE pmh.PatientID='" + ViewState["PatientID"].ToString() + "' GROUP BY emr.TransactionID");

            dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0)
            {
                grdDischargeSummary.DataSource = dt;
                grdDischargeSummary.DataBind();

                if (dt.Rows[0]["DStatus"].ToString() == "Discharged")
                {
                    chkid.Visible = false;

                }
                else
                {
                    chkid.Visible = true;

                }
            }
            else
            {
                lblMsg.Text = "No Discharge Report Is Prepared";
                btnDischarge.Visible = false;
            }
       // }
    }
    protected void btnDischarge_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/EMR/DischargeReportNew.aspx?TID=" + ViewState["TransactionID"] + " &Status=" + Session["Status"].ToString() + "&ReportType=PDF');", true);
    }
    protected void grdDischargeSummary_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
    {
        if (e.CommandName.ToString() == "aView")
        {
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/EMR/printDischargeReport_pdf.aspx?TID=" + e.CommandArgument.ToString().Split('#')[0] + " &Status=" + e.CommandArgument.ToString().Split('#')[1] + "&ReportType=PDF');", true);

            if (chkid.Checked == true)
            {

                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/EMR/printDischargeReport_pdf.aspx?TID=" + e.CommandArgument.ToString().Split('#')[0] + " &Status=" + e.CommandArgument.ToString().Split('#')[1] + "&ReportType=PDF&dtd=" + getDischargeDateTime() + "');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/EMR/printDischargeReport_pdf.aspx?TID=" + e.CommandArgument.ToString().Split('#')[0] + " &Status=" + e.CommandArgument.ToString().Split('#')[1] + "&ReportType=PDF');", true);


            }
        
        
        }
    }

    public string getDischargeDateTime()
    {

        string DischargeDateTime = ucFromDate.Text.ToString() + " " + txtTime.Text.ToString();

        return DischargeDateTime;

    }






}