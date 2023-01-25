using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.Services;



public partial class Design_OPD_OPDAdvanceUtilization : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {


        if (!IsPostBack)
        {
            CalendarExteFromDate.EndDate = System.DateTime.Now;
            CalendarExtenderToDate.EndDate = System.DateTime.Now;

            txtFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        }
        txtToDate.Attributes.Add("readonly", "true");
        txtFromDate.Attributes.Add("readonly", "true");


    }


    [WebMethod]
    public static string GetOpdAdvanceUtilization(string fromDate, string toDate, string patientID, int searchType)
    {

        StringBuilder sqlCMD = new StringBuilder();

        var searchParams = new
         {
             fromDateSearch = Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + " 00:00:00",
             toDateSearch = Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + " 23:59:59",
             patientID = patientID
         };


        if (searchType == 0 || searchType == 1)
        {
            sqlCMD.Append(" select 'Advance' SearchType,pm.PatientID UHIDNo,concat(pm.Title,' ',pm.PName)PatientName,pm.Age,pm.Gender,pm.House_No, ");
            sqlCMD.Append(" IFNULL(pm.mobile,'')ContactNo,pm.Email,'' Against_Advance_ReceiptNo,ReceiptNo,Sum(ROUND(o.AdvanceAmount,4))PaidAmount, ");
            sqlCMD.Append(" group_Concat(concat(o.PaymentMode,' : ',round(o.AdvanceAmount,4),if(o.PaymentModeID<>1,CONCAT('(Bank : ',o.BankName,' RefNo. : ',o.RefNo),'')))PaymentDetail, ");
            sqlCMD.Append(" date_format(o.CreatedDate,'%d-%b-%Y')EntryDate ,concat(em.Title,' ',em.Name)EntryBy,o.CreatedDate ");
            sqlCMD.Append(" from opd_advance o  ");
            sqlCMD.Append(" inner join employee_master em on em.EmployeeID=O.CreatedBy  ");
            sqlCMD.Append(" inner join patient_master pm on pm.PatientID=O.PatientID ");
            sqlCMD.Append(" where IsCancel=0 and o.CreatedDate>=@fromDateSearch  AND o.CreatedDate<= @toDateSearch ");
            if (!string.IsNullOrEmpty(patientID))
                sqlCMD.Append(" and pm.PatientID=@patientID");

            sqlCMD.Append(" group by o.PatientID,o.ReceiptNo ");
        }
        if (searchType == 0)
        {
            sqlCMD.Append(" union all ");
        }
        if (searchType == 0 || searchType == 2)
        {
            sqlCMD.Append(" select 'Advance Utilization ' SearchType,pm.PatientID UHIDNo,concat(pm.Title,' ',pm.PName)PatientName,pm.Age,pm.Gender,pm.House_No, ");
            sqlCMD.Append(" IFNULL(pm.mobile,'')ContactNo,pm.Email,o.ReceiptNoAgainst Against_Advance_ReceiptNo,ReceiptNo,(Sum(ROUND(o.PaidAmount,4))*-1)PaidAmount,concat('OPD-Advance : ',Sum(ROUND(o.PaidAmount,4)))PaymentDetail, ");
            sqlCMD.Append(" date_format(o.CreatedDate,'%d-%b-%Y')EntryDate ,concat(em.Title,' ',em.Name)EntryBy,o.CreatedDate ");
            sqlCMD.Append(" from opd_advance_detail o  ");
            sqlCMD.Append(" inner join employee_master em on em.EmployeeID=O.CreatedBy  ");
            sqlCMD.Append(" inner join patient_master pm on pm.PatientID=O.PatientID ");
            sqlCMD.Append(" where IsCancel=0 and o.CreatedDate>=@fromDateSearch  AND o.CreatedDate<= @toDateSearch ");
            if (!string.IsNullOrEmpty(patientID))
                sqlCMD.Append(" and pm.PatientID=@patientID");
            sqlCMD.Append(" group by o.PatientID,o.ReceiptNo ");
        }

        sqlCMD.Append(" order by Against_Advance_ReceiptNo,CreatedDate ");

        ExcuteCMD excuteCMD = new ExcuteCMD();
        var dataTable = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, searchParams);
        dataTable.Columns.Remove("CreatedDate");
        dataTable.AcceptChanges();
        var s = excuteCMD.GetRowQuery(sqlCMD.ToString(), searchParams);

        if (dataTable.Rows.Count > 0)
        {
            DataRow dr = dataTable.NewRow();
            dr[9] = "Total : ";
            dr["PaidAmount"] = Util.GetFloat(dataTable.Compute("sum([PaidAmount])", "")).ToString("f2");
            dataTable.Rows.InsertAt(dr, dataTable.Rows.Count + 1);

            HttpContext.Current.Session["ReportName"] = "Patient Advance Utilization Report";
            HttpContext.Current.Session["dtExport2Excel"] = dataTable;
            HttpContext.Current.Session["Period"] = "Period From Date : " + fromDate + " To Date : " + toDate;

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = dataTable });
        }
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data = dataTable });

    }


}