using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Web.Services;
using System.Text;

public partial class Design_Transport_TravelingDetail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtDepartureDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtDepartureTime.Text = DateTime.Now.ToString("hh:mm tt");
            txtTravelDateUpdate.Text = DateTime.Now.ToString("dd-MMM-yyyy"); 
           
            calArrDate.StartDate = DateTime.Now;
            calDepDate.StartDate = DateTime.Now;
            calTravelDate.StartDate = DateTime.Now;

            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }

        txtDepartureDate.Attributes.Add("readOnly", "readOnly");
        txtArrivalDate.Attributes.Add("readOnly", "readOnly");
        txtTravelDateUpdate.Attributes.Add("readOnly", "readOnly");
        txtFromDate.Attributes.Add("readonly", "readonly");
        txtToDate.Attributes.Add("readonly", "readonly");
    }

    [WebMethod(EnableSession = true)]
    public static string SearchDepartmentRqst(string FromDept, string RequestNo, string FromDate, string ToDate)
    {
        StringBuilder Query = new StringBuilder();
        Query.Append("SELECT ID,VehicleRequestID,(SELECT LedgerName FROM f_ledgermaster WHERE LedgerNumber=DeptFrom)DeptFrom,VehicleType,DATE_FORMAT(TravelDate,'%d-%b-%Y')TravelDate,TIME_FORMAT(TravelTime,'%h:%i %p')TravelTime, ");
        Query.Append("DATE_FORMAT(EntryDate,'%d-%b-%Y')RaisedDate,(SELECT CONCAT(Title,' ',NAME) FROM employee_master WHERE Employee_ID=EntryBy)RaisedBy,Purpose PurposeID,(select Purpose from t_purpose_master where ID=DV.Purpose)Purpose,IsApproved,IsCancel FROM t_department_vehicle DV ");
        Query.Append("WHERE IsRequest=1 AND IsApproved=1 AND IsCancel=0 AND IsComplete=0 ");

        if (FromDept != "All")
        {
            Query.Append("AND DeptFrom='" + FromDept + "'  ");
        }

        if (RequestNo != "")
        {
            Query.Append("AND VehicleRequestID='" + RequestNo + "' ");
        }

        if (FromDept == "All" && RequestNo == "")
        {
            Query.Append("AND DATE(TravelDate)>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND DATE(TravelDate)<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'  ");
        }

        Query.Append("order by VehicleRequestID ");

        DataTable dt = StockReports.GetDataTable(Query.ToString());

        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        return "0";
    }

    [WebMethod(EnableSession = true)]
    public static string SearchPatientRqst(string MRNo, string IPDNo, string Name,string FromDate, string ToDate)
    {
        StringBuilder Query = new StringBuilder();
        Query.Append("SELECT ID,PatientID,REPLACE(TransactionID,'ISHHI','')IPDNo,PName,DATE_FORMAT(EntryDate,'%d-%b-%Y')RequestDate,DATE_FORMAT(TravelDate,'%d-%b-%Y')TravelDate,  ");
        Query.Append("TIME_FORMAT(TravelTime,'%h:%i %p')TravelTime,VehicleType,Purpose PurposeID,(SELECT Purpose FROM t_purpose_master WHERE ID=PV.Purpose)Purpose ");
        Query.Append("FROM t_patient_vehicle PV WHERE IsRequest=1 AND IsComplete=0 AND IsCancel=0 ");

        if (MRNo != "")
        {
            Query.Append("AND PatientID='" + MRNo + "' ");
        }

        if (IPDNo != "")
        {
            Query.Append("AND TransactionID=CONCAT('ISHHI'," + IPDNo + ")  ");
        }

        if (Name != "")
        {
            Query.Append("AND PName LIKE '%" + Name + "%'  ");
        }

        if (MRNo == "" && Name == "" && IPDNo == "")
        {
            Query.Append("AND DATE(TravelDate)>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND DATE(TravelDate)<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'  ");
        }

        Query.Append("order by ID ");

        DataTable dt = StockReports.GetDataTable(Query.ToString());

        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        return "0";
    }
}