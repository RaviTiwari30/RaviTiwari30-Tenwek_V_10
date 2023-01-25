using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;

public partial class Design_Transport_PatientVehicleRequest : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblUserID.Text = Session["ID"].ToString();
            lblMRNo.Text = Request.QueryString["PatientID"].ToString();
            lblIPDNo.Text = Request.QueryString["TransactionID"].ToString();

            AllQuery AQ = new AllQuery();
            DataTable dtDischarge = AQ.GetPatientDischargeStatus(lblIPDNo.Text);

            if (dtDischarge != null && dtDischarge.Rows.Count > 0)
            {
                if (dtDischarge.Rows[0]["Status"].ToString().Trim().ToUpper() == "OUT")
                {
                    string Msg = "Patient is Already Discharged on " + Util.GetDateTime(dtDischarge.Rows[0]["DischargeDate"].ToString().Trim()).ToString("dd-MMM-yyyy") + " . No Vehicle Request can be possible...";
                    Response.Redirect("../IPD/PatientBillMsg.aspx?msg=" + Msg);
                }
            }

            txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            calDate.StartDate = DateTime.Now;
        }

        txtDate.Attributes.Add("readonly", "readonly");
    }

    [WebMethod(EnableSession = true, Description = "Generate Vehicle Request From IPD Patient")]
    public static string SaveRequest(string MRNo, string IPDNo, string Type, string Date, string Time, string Purpose, string userID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.ReadCommitted);

        try
        {
            DataTable dt = StockReports.GetDataTable("SELECT PName,Mobile FROM patient_master WHERE PatientID='" + MRNo + "'");

            string Query = "INSERT INTO t_patient_vehicle(PatientID,TransactionID,PName,ContactNo,TravelDate,TravelTime,VehicleType,IsRequest,Purpose,EntryDate,EntryBy) VALUES('" + MRNo + "','" + IPDNo + "','" + Util.GetString(dt.Rows[0]["PName"]) + "','" + Util.GetString(dt.Rows[0]["Mobile"]) + "','" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(Time).ToString("HH:mm:ss") + "','" + Type + "',1,'" + Purpose + "',NOW(),'" + Util.GetString(HttpContext.Current.Session["ID"]) + "')";
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, Query);

            DataTable dtItem = new DataTable();
            dtItem.Columns.Add("Category");
            dtItem.Columns.Add("SubCategory");
            dtItem.Columns.Add("ItemID");
            dtItem.Columns.Add("Item");
            dtItem.Columns.Add("Quantity");
            dtItem.Columns.Add("Rate");
            dtItem.Columns.Add("TotalAmt");
            dtItem.Columns.Add("SubCategoryID");
            dtItem.Columns.Add("Date");
            dtItem.Columns.Add("ItemDisplayName");
            dtItem.Columns.Add("ItemCode");
            dtItem.Columns.Add("DoctorID");
            dtItem.Columns.Add("Name");
            dtItem.Columns.Add("DocCharges");
            dtItem.Columns.Add("TnxTypeID");
            dtItem.Columns.Add("ConfigRelationID");

            DataTable ItemDetail = StockReports.GetDataTable("SELECT  TypeName,IM.ItemID,IM.SubCategoryID,SC.CategoryID,cf.ConfigID AS ConfigRelationID FROM f_itemmaster im INNER JOIN f_subcategorymaster sc ON im.SubCategoryID = sc.SubCategoryID AND sc.Active=1 INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID WHERE im.IsActive=1 AND im.ItemID='" + Resources.Resource.TransportItemID + "'");

            DataRow dr = dtItem.NewRow();
            dr["Category"] = ItemDetail.Rows[0]["CategoryID"].ToString();
            dr["SubCategoryID"] = ItemDetail.Rows[0]["SubCategoryID"].ToString();
            dr["ItemID"] = ItemDetail.Rows[0]["ItemID"].ToString();
            dr["Item"] = ItemDetail.Rows[0]["TypeName"].ToString();
            dr["Quantity"] = "1";

            AllQuery AQ = new AllQuery();
            DataTable dtIPDInfo = AQ.GetPatientIPDInformation("", IPDNo);

            DataTable dtTemp = IPDBilling.LoadItemsHavingRateFixed("'" + ItemDetail.Rows[0]["ItemID"].ToString() + "'", dtIPDInfo.Rows[0]["ReferenceCode"].ToString(), dtIPDInfo.Rows[0]["IPDCaseTypeID"].ToString(), dtIPDInfo.Rows[0]["ScheduleChargeID"].ToString(), "1");

            if (dtTemp != null && dtTemp.Rows.Count > 0)
            {
                dr["Rate"] = dtTemp.Rows[0]["Rate"].ToString();
                if (Util.GetString(dtTemp.Rows[0]["ItemDisplayName"]) != "")
                    dr["ItemDisplayName"] = dtTemp.Rows[0]["ItemDisplayName"].ToString();
                else
                    dr["ItemDisplayName"] = dtTemp.Rows[0]["Item"].ToString();

                dr["ItemCode"] = dtTemp.Rows[0]["ItemCode"].ToString();
                dr["ConfigRelationID"] = dtTemp.Rows[0]["ConfigRelationID"].ToString();
            }
            else
            {
                dr["Rate"] = "0";
                dr["ItemDisplayName"] = dr["Item"].ToString();
                dr["ItemCode"] = "";
            }

            dr["Date"] = DateTime.Now;
            dr["DoctorID"] = dtIPDInfo.Rows[0]["DoctorID"].ToString();
            dr["Name"] = StockReports.GetDoctorNameByDoctorID(dtIPDInfo.Rows[0]["DoctorID"].ToString());
            dr["DocCharges"] = "0.00";
            dr["TnxTypeID"] = "7";
            dtItem.Rows.Add(dr);

            dtItem = IPDBilling.UpdateLedgerForIPDBilling(dtItem, MRNo, "IPD-Billing", Util.GetInt(dtIPDInfo.Rows[0]["PanelID"]), Util.GetString(HttpContext.Current.Session["ID"]), IPDNo, Util.GetString(HttpContext.Current.Session["HOSPID"].ToString()), "Yes", "1", tranx, dtIPDInfo.Rows[0]["IPDCaseTypeID"].ToString(), "", con, "");

            tranx.Commit();

            return "1";
        }
        catch (Exception ex)
        {
            tranx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            return "0";
        }
        finally
        {
            tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true, Description = "Generate Vehicle Request From IPD Patient")]
    public static string bindRequests(string MRNo, string IPDNo)
    {
        StringBuilder Query = new StringBuilder();
        Query.Append("SELECT PV.ID,PV.PatientID,(SELECT TransNo FROM patient_medical_history WHERE TransactionID = PV.TransactionID) AS IPDNo,PV.TransactionID,PV.PName,Date_Format(PV.EntryDate,'%d-%b-%Y')RequestDate,DATE_FORMAT(PV.TravelDate,'%d-%b-%Y')TravelDate,TIME_FORMAT(PV.TravelTime,'%h:%i %p')TravelTime,PV.VehicleType,PV.IsComplete,(select Purpose from t_purpose_master where ID=PV.Purpose)Purpose,PV.Purpose PurposeID,");
        Query.Append("VM.VehicleNo,VM.Status,TD.`DriverName`,DATE_FORMAT(TD.DepartureDate,'%d-%b-%Y')DepartureDate,TIME_FORMAT(TD.DepartureTime,'%h:%i %p')DepartureTime,");
        Query.Append("DATE_FORMAT(TD.`ArrivalDate`,'%d-%b-%Y')ArrivalDate,TIME_FORMAT(TD.ArrivalTime,'%h:%i %p')ArrivalTime,TD.PlaceVisited,DATE_FORMAT(PV.CancelDate,'%d-%b-%Y')CancelDate,(SELECT CONCAT(Title,' ',NAME) FROM employee_master WHERE EmployeeID=PV.CancelBy)CancelBy,PV.CancelReason,PV.IsCancel ");
        Query.Append("FROM t_patient_vehicle PV LEFT JOIN t_travel_detail TD ON PV.TravelID=TD.ID LEFT JOIN t_vehicle_master VM ON PV.VehicleID=VM.ID WHERE PV.IsRequest=1 AND PV.TransactionID='" + IPDNo + "' ");
        Query.Append("ORDER BY DATE(PV.EntryDate) DESC ");

        DataTable dt = StockReports.GetDataTable(Query.ToString());

        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            return "0";
        }
    }
}