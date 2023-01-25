using System;
using System.Collections.Generic;
using System;
using System.Web;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_MRD_MRDFileIssue : System.Web.UI.Page
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
                txtFromDate.Text = System.DateTime.Now.AddDays(0).ToString("dd-MMM-yyyy");
                txtToDate.Text = System.DateTime.Now.AddDays(0).ToString("dd-MMM-yyyy");
                fc1.EndDate = DateTime.Now.AddDays(0);
                calExeto.EndDate = DateTime.Now.AddDays(0);
            }
            bindPatientType();
        }
        txtFromDate.Attributes.Add("readonly", "readonly");
        txtToDate.Attributes.Add("readonly", "readonly");
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
    [WebMethod(EnableSession = true)]
    public static string SearchRequisition(string MRNo, string PName, string IPDNo, string fromDate, string toDate, string MRDFileNo, string pType)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT pmh.type,mfr.MRDRequisitionID,mfr.PatientID,mfr.TransactionID,IF(pmh.TYPE='IPD', pmh.TransNo,'')TransNo,CONCAT(pm.`Title`,' ',pm.`PName`)PatientName,mfr.FileID,isApproved,RequestedBy, ");
        sb.Append("CONCAT(em.Title,'',em.Name)RequestedName,CONCAT(em1.Title,'',em1.Name)ApprovedBy,  ");
        sb.Append("DATE_FORMAT(mfr.RequestedDate,  '%d-%b-%Y')RejectedDate,DATE_FORMAT(mfr.ApprovedDate,'%d-%b-%Y')ApprovedDate,'" + HttpContext.Current.Session["LoginType"].ToString() + "' AS LoginType,'IPD' As Type,mfr.`IsIssue`,pmh.`BillNo`  ");
        sb.Append(" FROM mrd_fileRequisition mfr INNER JOIN patient_medical_history pmh ON pmh.`TransactionID`=mfr.TransactionID ");
        sb.Append(" INNER JOIN patient_master pm ON pm.`PatientID`=pmh.`PatientID`  ");
        sb.Append("INNER JOIN employee_master em ON em.EmployeeID=mfr.RequestedBy ");
        sb.Append("INNER JOIN employee_master em1 ON em1.EmployeeID = mfr.ApprovedBy ");
        sb.Append("WHERE  mfr.isApproved=1 ");
        if (pType != "ALL")
        {
            sb.Append(" and pmh.Type='" + pType + "' ");
        }
        if (MRNo.Trim() != string.Empty)
            sb.Append("And mfr.PatientID ='" + MRNo.Trim() + "' ");
        if (PName.Trim() != string.Empty)
            sb.Append("And pm.PName like '%" + PName.Trim() + "%' ");
        if (IPDNo.Trim() != string.Empty)
        {
            IPDNo = Util.GetString(StockReports.getTransactionIDbyTransNo(IPDNo.Trim()));
            sb.Append("And pmh.TransactionID='" + IPDNo.Trim() + "' ");
        }
        if (MRDFileNo.Trim() != string.Empty)
            sb.Append("And mfr.FileID = '" + MRDFileNo.Trim() + "' ");
        if (MRDFileNo.Trim() == string.Empty && IPDNo.Trim() == string.Empty)
        {
            if (fromDate.Trim() != string.Empty && toDate.Trim() != string.Empty)
            {
                sb.Append("AND Date(mfr.RequestedDate) >= '" + Util.GetDateTime(fromDate.Trim()).ToString("yyyy-MM-dd") + "' AND Date(mfr.RequestedDate)<='" + Util.GetDateTime(toDate.Trim()).ToString("yyyy-MM-dd") + "' ");
            }
        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
}