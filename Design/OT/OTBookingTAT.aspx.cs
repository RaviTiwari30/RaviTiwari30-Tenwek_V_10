using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;

public partial class Design_OT_OTBookingTAT : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack) {
            ViewState["OTBookingID"] = Request.QueryString["OTBookingID"].ToString();
        }

    }



    [WebMethod]
    public static string GetBookingTAT(string bookingID)
    {

        ExcuteCMD excuteCMD = new ExcuteCMD();

        StringBuilder sqlCMD = new StringBuilder();        

        sqlCMD.Append("SELECT CONCAT(dm.Title,' ',dm.Name)DoctorName,  sc.TypeName SurgeryName,DATE_FORMAT(ot.SurgeryDate,'%d-%b-%Y')SurgeryDate, IFNULL(TIME_FORMAT(t.StartTime,'%I:%i %p'),'')DisplayStartTime,IFNULL(t.StartTime,'')StartTime,m.TATTypeName,m.Abbreviation,ot.OTNumber,IF(t.StartTime IS NULL,0,1)completeStatus ");
        sqlCMD.Append("FROM  ot_tat_type_master m  ");
        sqlCMD.Append("INNER JOIN ot_booking ot  ON ot.ID=@bookingID ");
        sqlCMD.Append("LEFT OUTER  JOIN ot_patienttat t ON t.TATTypeID=m.ID AND t.OTBookingID=@bookingID  AND t.IsActive=1  ");
        //  sqlCMD.Append("INNER JOIN f_surgery_master sc ON sc.Surgery_ID=ot.SurgeryID ");
        sqlCMD.Append(" INNER JOIN f_itemmaster sc ON sc.itemid=ot.SurgeryID  ");
        sqlCMD.Append("INNER JOIN doctor_master dm ON dm.DoctorID=ot.DoctorID ");
        sqlCMD.Append("WHERE m.IsActive=1 AND m.ID<>3   ORDER BY m.DisplayPriority  ");


        DataTable dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
        {
            bookingID = bookingID
        });

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
}