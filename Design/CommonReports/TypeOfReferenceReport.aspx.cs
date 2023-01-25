using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.Services;



public partial class Design_OPD_TypeOfReferenceReport : System.Web.UI.Page
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
    public static string GetTypeOfReferenceReport(string fromDate, string toDate, string patientID, string TypeOfReference)
    {

        StringBuilder sqlCMD = new StringBuilder();

        var searchParams = new
         {
             fromDateSearch = Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"),
             toDateSearch = Util.GetDateTime(toDate).ToString("yyyy-MM-dd"),
             patientID = patientID,
             typeOfReference = TypeOfReference
         };

        sqlCMD.Append(" SELECT IF(pmh.TypeOfReference='Select','',pmh.TypeOfReference)TypeOfReference,date_format(pmh.DateOfVisit,'%d-%b-%Y')DateOfVisit, concat(pm.Title,' ',pm.PName)PatientName, ");
        sqlCMD.Append(" pm.Age,pm.Gender,pm.House_No,IFNULL(pm.mobile,'')ContactNo,pm.Email,pm.Country,pm.City,pmh.KinRelation As Relation,pmh.KinName As RelationName, ");
        sqlCMD.Append(" pmh.KinPhone As RelationPhoneNo, placeofBirth,EmergencyPhoneNo,parmanentAddress,EmergencyRelationOf,EmergencyRelationShip ");
        sqlCMD.Append(" FROM patient_master pm  ");
        sqlCMD.Append(" INNER JOIN `patient_medical_history` pmh ON pmh.PatientID=pm.PatientID  ");
        sqlCMD.Append(" WHERE ifnull(IF(pmh.Purpose='TypeOfReference','',pmh.TypeOfReference),'')<>'' ");
        sqlCMD.Append(" and pmh.DateOfVisit>=@fromDateSearch  AND pmh.DateOfVisit<= @toDateSearch ");


        if (!string.IsNullOrEmpty(patientID))
            sqlCMD.Append(" and pm.PatientID=@patientID");

        if (TypeOfReference != "All")
            sqlCMD.Append(" and pmh.TypeOfReference=@typeOfReference");

        sqlCMD.Append("  order by pmh.DateOfVisit,pmh.TypeOfReference,pm.PName ");

        ExcuteCMD excuteCMD = new ExcuteCMD();
        var dataTable = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, searchParams);

        var s = excuteCMD.GetRowQuery(sqlCMD.ToString(), searchParams);

        if (dataTable.Rows.Count > 0)
        {
            HttpContext.Current.Session["ReportName"] = "Reference Type Report";
            HttpContext.Current.Session["dtExport2Excel"] = dataTable;
            HttpContext.Current.Session["Period"] = "Period From Date : " + fromDate + " To Date : " + toDate;

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = dataTable });
        }
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data = dataTable });

    }


}