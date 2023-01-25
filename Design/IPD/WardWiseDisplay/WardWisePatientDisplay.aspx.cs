using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_IPD_WardWiseDisplay_WardWisePatientDisplay : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }



    [WebMethod(EnableSession = true)]
    public static string BindFloor()
    {
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable("SELECT FloorID AS ID,Role_ID,fm.Name AS NAME FROM f_roomtype_role  rm INNER JOIN Floor_master fm ON fm.ID=rm.FloorID WHERE Role_ID='214' AND fm.CentreID='1' GROUP BY FloorID,Role_ID ORDER BY fm.SequenceNo+0 ");
        if (dt.Rows.Count < 1)
        {

            string str = " SELECT ID,NAME,SequenceNo FROM floor_master Where CentreID=" + 1 + " ORDER BY SequenceNo+0";
            dt = StockReports.GetDataTable(str);
        }

        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    public static string BindRoomType(string FloorID, int isAttenderRoom)
    {
        DataTable dtData = new DataTable();
        if (FloorID == "0")
        {
            if ((isAttenderRoom == 0) || (isAttenderRoom == 1))
                dtData = StockReports.GetDataTable("Select Name,IPDCaseTypeID,isAttenderRoom,IsEmergency from ipd_case_type_master where isActive=1  and CentreID=" + 1 + "  order by name").AsEnumerable().Where(r => r.Field<int>("isAttenderRoom") == isAttenderRoom).AsDataView().ToTable();
            else
                dtData = StockReports.GetDataTable("Select Name,IPDCaseTypeID,isAttenderRoom,IsEmergency from ipd_case_type_master where isActive=1  and CentreID=" + 1 + "  order by name");

        }
        else
        {
            dtData = StockReports.GetDataTable("SELECT DISTINCT(ich.IPDCaseTypeID)IPDCaseTypeID,ich.Name,Role_ID FROM f_roomtype_role rt INNER JOIN ipd_case_type_master ich ON ich.IPDCaseTypeID=rt.IPDCaseTypeID  where Role_ID='214' And FloorID='" + FloorID + "'");
            if (dtData.Rows.Count < 1)
            {

                dtData = StockReports.GetDataTable("Select Name,IPDCaseTypeID,isAttenderRoom,IsEmergency from ipd_case_type_master where isActive=1  and CentreID=" + 1 + "  order by name");

            }

        }
        if (dtData.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtData);
        else
            return "";
    }



    [WebMethod(EnableSession = true)]
    public static string GetPatientData(int Floor, int Room)
    {
        DataTable dt = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT pm.PatientID ,CONCAT(pm.Title,' ',pm.PName) PatientName,pm.Mobile,pm.CentreID,pm.PanelID, ");
            sb.Append(" CONCAT(pm.City ,' ',pm.District,' ',pm.Locality) Address,pm.Gender,rm.FLOOR,ipcm.NAME Ward , IF(pp.STATUS='IN','Admitted',IF(pp.STATUS='OUT','Discharged','') )STATUS   ");

            sb.Append(" ,pm.Age, pp.TransactionID IpNo ");
            sb.Append("  ,(SELECT COUNT(*) Counts FROM crm_notification crlab WHERE crlab.IsView=0 AND crlab.RemainderTypeId=1 AND crlab.TransactionID=pp.TransactionID)  AS LabCount  ");


            sb.Append(" ,(SELECT COUNT(*) Counts FROM crm_notification crlab WHERE crlab.IsView=0 AND crlab.RemainderTypeId=2 AND crlab.TransactionID=pp.TransactionID)  AS RadCount   ");


            sb.Append(" ,(SELECT COUNT(*) Counts FROM crm_notification crlab WHERE crlab.IsView=0 AND crlab.RemainderTypeId=4 AND crlab.TransactionID=pp.TransactionID)  AS MedCount   ");


            sb.Append("  ,(SELECT COUNT(*) Counts FROM crm_notification crlab WHERE crlab.IsView=0 AND crlab.RemainderTypeId in (3,5) AND crlab.TransactionID=pp.TransactionID)  AS ProCount   ");


            sb.Append(" FROM  patient_master pm   ");
            sb.Append("INNER JOIN patient_ipd_profile pp ON pp.PatientID=pm.PatientID   AND pp.STATUS='IN'   ");
            sb.Append("INNER JOIN room_master rm ON rm.RoomID=pp.RoomID    ");
            sb.Append("INNER JOIN floor_master fm ON fm.NAME=rm.FLOOR    ");
            sb.Append("INNER JOIN ipd_case_type_master ipcm  ON ipcm.IPDCaseTypeID=pp.IPDCaseTypeID   ");
            sb.Append("WHERE pp.IPDCaseTypeID=" + Room + " AND fm.ID=" + Floor + " and pp.IsPatientReceived='1'");


            dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = dt });
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = dt, resMes = "No data found" });
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, resMes = "Error Occured " });
        }
    }












}