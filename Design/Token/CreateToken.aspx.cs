using System;
using System.Data;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_Token_CreateToken : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblAppointmentDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
    }
    [WebMethod]
    public static string searchOPDToken(string PatientName, string DoctorName, string TokenNumber)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT * FROM ( ");
        sb.Append("  SELECT TransactionID,PatientID,App_ID,AppNo,CONCAT(title,' ',PName)NAME,(SELECT CONCAT(Title,' ',NAME) FROM Doctor_master WHERE DoctorID=app.DoctorID)DoctorName,DoctorID,VisitType,");
        sb.Append("  TIME_FORMAT(TIME,'%l: %i %p')AppTime,DATE_FORMAT(DATE,'%d-%b-%Y')AppDate,IsConform,IsReschedule,IsCancel,CancelReason,");
        sb.Append(" DATE_FORMAT(ConformDate,'%d-%b-%Y %l:%i %p')ConformDate, IFNULL(LedgerTnxNo,'')LedgerTnxNo, CONCAT(DATE,' ',TIME)AppDateTime,ContactNo, ");
        sb.Append("  IF(ISNULL(tokenNo),0,1)tokenNoExit,IF(IsCancelToken=3,'',tokenNo)tokenNo,IsCancelToken,UpdateToken,DATE  FROM appointment app  ");
        sb.Append("  WHERE DATE=CURDATE() AND app.PatientID<>'' AND LedgerTnxNo<>'' AND app.IsConform=1  AND app.IsCancel=0  UNION ALL ");
        sb.Append(" SELECT TransactionID,PatientID,App_ID,AppNo,NAME,DoctorName,DoctorID,VisitType, AppTime,AppDate,IsConform,IsReschedule,IsCancel,CancelReason, ");
        sb.Append(" ConformDate, LedgerTnxNo,AppDateTime,ContactNo, ");
        sb.Append("  IF(ISNULL(tokenNo),0,1)tokenNoExit,tokenNo,IsCancelToken,UpdateToken,DATE FROM CancelOPDToken app  ");
        sb.Append(" WHERE DATE=CURDATE() AND app.PatientID<>'' AND LedgerTnxNo<>'' AND app.IsConform=1  AND app.IsCancel=0  ");
        sb.Append(" )t  ");
        sb.Append(" where t.date=CURDATE() ");

        if (PatientName != null && PatientName != "")
            sb.Append(" and  t.NAME like ('%" + PatientName + "%') ");
        if (DoctorName != null && DoctorName != "0")
            sb.Append(" and t.DoctorName like ('%" + DoctorName + "%') ");
        if (TokenNumber != null && TokenNumber != "")
            sb.Append(" and t.tokenNo='" + TokenNumber + "'");

        sb.Append(" ORDER BY DoctorName,tokenNo; ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            return "";
        }
    }
}