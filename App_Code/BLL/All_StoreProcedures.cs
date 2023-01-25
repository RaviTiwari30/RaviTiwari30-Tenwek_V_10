using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI.WebControls;
/// <summary>
/// Summary description for All_StoreProcedures
/// </summary>
public class All_StoreProcedures
{
    public All_StoreProcedures()
    {
        //
        // TODO: Add constructor logic here
        //
    }
    public static DataTable GetApppointmentDetails(string DocID, DateTime FromDate, DateTime ToDate, string AppNo, string IsConform, string VisitType, string Status, string doctorDepartmentID, string Pname, string mobileOrUHID, string mobileOrUHIDNo, string Centre = "")
    {
        DataTable dt = MySqlHelper.ExecuteDataset(Util.GetMySqlCon(), CommandType.StoredProcedure, "SearchConfirmedAppointment",
            new MySql.Data.MySqlClient.MySqlParameter("@vName", Pname),
           new MySql.Data.MySqlClient.MySqlParameter("@vDocID", DocID),
           new MySql.Data.MySqlClient.MySqlParameter("@vFromDate", Util.GetDateTime(FromDate).ToString("yyyy-MM-dd")),
           new MySql.Data.MySqlClient.MySqlParameter("@vToDate", Util.GetDateTime(ToDate).ToString("yyyy-MM-dd")),
           new MySql.Data.MySqlClient.MySqlParameter("@vAppNo", AppNo),
           new MySql.Data.MySqlClient.MySqlParameter("@vIsConform", IsConform),
           new MySql.Data.MySqlClient.MySqlParameter("@vVisitType", VisitType),
           new MySql.Data.MySqlClient.MySqlParameter("@vStatus", Status),
           new MySql.Data.MySqlClient.MySqlParameter("@vDoctorDepartmentID", doctorDepartmentID),
           
           new MySql.Data.MySqlClient.MySqlParameter("@vmobileOrUHID", mobileOrUHID),
           new MySql.Data.MySqlClient.MySqlParameter("@vmobileOrUHIDNo", mobileOrUHIDNo),
           new MySql.Data.MySqlClient.MySqlParameter("@vCentre", Centre)).Tables[0];
        return dt;
    }

    public static DataTable GetApppointmentRadiologyDetails(DateTime FromDate, DateTime ToDate, string UHID, string PName, string Mobile, string SubCategoryID, string LabNo, string TokenNo, string IsConform, string Status, string Centre = "")
    {
        DataTable dt = MySqlHelper.ExecuteDataset(Util.GetMySqlCon(), CommandType.StoredProcedure, "SearchRadiologyAppointment",
           new MySql.Data.MySqlClient.MySqlParameter("@vFromDate", Util.GetDateTime(FromDate).ToString("yyyy-MM-dd")),
           new MySql.Data.MySqlClient.MySqlParameter("@vToDate", Util.GetDateTime(ToDate).ToString("yyyy-MM-dd")),
           new MySql.Data.MySqlClient.MySqlParameter("@vUHID", UHID),
           new MySql.Data.MySqlClient.MySqlParameter("@vPName", PName),
           new MySql.Data.MySqlClient.MySqlParameter("@vMobile", Mobile),
           new MySql.Data.MySqlClient.MySqlParameter("@vSubCategoryID", SubCategoryID),
           new MySql.Data.MySqlClient.MySqlParameter("@vLabNo", LabNo),
           new MySql.Data.MySqlClient.MySqlParameter("@vTokenNo", TokenNo),
           new MySql.Data.MySqlClient.MySqlParameter("@vIsConform", IsConform),
           new MySql.Data.MySqlClient.MySqlParameter("@vStatus", Status),
           new MySql.Data.MySqlClient.MySqlParameter("@vCentre", Centre)).Tables[0];
        return dt;
    }

}