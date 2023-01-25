using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using MySql.Data.MySqlClient;
using System.Web.Services;
using System.Text;

public partial class Design_Transport_SearchVehicleRequest : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(Session["RoleID"]), Util.GetString(Session["ID"]));
            //if (dtAuthority.Rows.Count > 0)
            //    lblAuthority.Text = dtAuthority.Rows[0]["IsVehicleRequest"].ToString();
            //else
            //    lblAuthority.Text = "0";

            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
        txtFromDate.Attributes.Add("readonly", "readonly");
        txtToDate.Attributes.Add("readonly", "readonly");
    }

    [WebMethod(EnableSession = true)]
    public static string SearchDeptRequest(string FromDept, string Status, string FromDate, string ToDate)
    {
        StringBuilder Query = new StringBuilder();
        Query.Append("SELECT vr.ID,TokenNo AS VehicleRequestID,IFNULL((SELECT LedgerName FROM f_ledgermaster WHERE LedgerNumber=DeptLedgerNo),'')DeptFrom,IFNULL(tvm.VehicleType,'')VehicleType,DATE_FORMAT(vr.BookingDate,'%d-%b-%Y')TravelDate,TIME_FORMAT(vr.BookingDate,'%h:%i %p')TravelTime, ");
        Query.Append("DATE_FORMAT(vr.`CreatedDate`,'%d-%b-%Y')RaisedDate,(SELECT CONCAT(Title,' ',NAME) FROM employee_master WHERE EmployeeID=vr.`CreatedBy`)RaisedBy,vr.`PurposeName` as Purpose,'' IsApproved,'' IsCancel ,vr.`STATUS`,vr.`IsAck` FROM t_transport_request VR ");
        Query.Append(" LEFT JOIN `t_vehicle_master` tvm ON tvm.`ID`=vr.`VehicleID` WHERE  DATE(vr.`CreatedDate`)>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND DATE(vr.`CreatedDate`)<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'  ");

        if (FromDept != "All")
        {
            Query.Append("AND DeptLedgerNo='" + FromDept + "'  ");
        }

        if (Status != "0")
        {
            if (Status == "1")
            {
                Query.Append("AND vr.STATUS=0 AND vr.IsAck=0 ");
            }
            else if (Status == "2")
            {
                Query.Append(" AND vr.STATUS=1 AND vr.IsAck=0 ");
            }
            else if (Status == "3")
            {
                Query.Append(" AND vr.STATUS=1 AND vr.IsAck=1 ");
            }
        }

        Query.Append("order by vr.TokenNo ");

        DataTable dt = StockReports.GetDataTable(Query.ToString());

        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

        return "0";
    }

    [WebMethod(EnableSession = true)]
    public static string AddRequest(string ID)
    {
        StringBuilder Query = new StringBuilder();
        Query.Append("SELECT ID,VehicleRequestID,(SELECT LedgerName FROM f_ledgermaster WHERE LedgerNumber=DeptFrom)DeptFrom,VehicleType,DATE_FORMAT(TravelDate,'%d-%b-%Y')TravelDate,TIME_FORMAT(TravelTime,'%h:%i %p')TravelTime, ");
        Query.Append("DATE_FORMAT(EntryDate,'%d-%b-%Y')RaisedDate,(SELECT CONCAT(Title,' ',NAME) FROM employee_master WHERE EmployeeID=EntryBy)RaisedBy,Purpose,IsApproved,IsCancel, ");
        Query.Append("DATE_FORMAT(ApprovedDate,'%d-%b-%Y')ApprovedDate,(SELECT CONCAT(Title,' ',NAME) FROM employee_master WHERE EmployeeID=ApprovedBy)ApprovedBy, ");
        Query.Append("DATE_FORMAT(CancelDate,'%d-%b-%Y')CancelDate,(SELECT CONCAT(Title,' ',NAME) FROM employee_master WHERE EmployeeID=CancelBy)CancelBy,CancelReason ");
        Query.Append("FROM t_department_vehicle where  ID='" + ID + "'");

        DataTable dt = StockReports.GetDataTable(Query.ToString());

        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

        return "0";
    }

    [WebMethod(EnableSession = true)]
    public static string ApproveRqst(string ID)
    {
        string result = "0";
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string str = "Update t_department_vehicle set IsApproved=1,ApprovedDate=now(),ApprovedBy='" + HttpContext.Current.Session["ID"].ToString() + "' where ID=" + ID + "";
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str);

            tranx.Commit();
            tranx.Dispose();
            con.Close();
            con.Dispose();
            result = "1";
        }
        catch (Exception ex)
        {
            tranx.Rollback();
            tranx.Dispose();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }

        return result;
    }

    [WebMethod(EnableSession = true)]
    public static string CancelRqst(string ID, string Reason)
    {
        string result = "0";
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string str = "Update t_department_vehicle set IsCancel=1,CancelDate=now(),CancelBy='" + HttpContext.Current.Session["ID"].ToString() + "', CancelReason='" + Reason + "' where ID=" + ID + "";
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str);

            tranx.Commit();
            tranx.Dispose();
            con.Close();
            con.Dispose();
            result = "1";
        }
        catch (Exception ex)
        {
            tranx.Rollback();
            tranx.Dispose();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }

        return result;
    }
}