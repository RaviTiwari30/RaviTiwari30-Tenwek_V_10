using System;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.UI.HtmlControls;

public partial class Design_IPD_IPDAdmissionNew : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //((HtmlGenericControl)PatientInfo.FindControl("divApp")).Attributes.Add("style", "display:none");
       // ((HtmlTableRow)PatientInfo.FindControl("divAppointment")).Attributes.Add("style", "display:none");
    }
    [WebMethod (EnableSession=true)]
    public static string BindAdmissionDetails(string PatientID, string TransactionID)
    {
        DataTable dt = AllLoadData_IPD.bindAdmissionDetails(PatientID, TransactionID);
        if (dt != null && dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public static string BindAllRoomDetail(string caseType)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT DISTINCT CONCAT(RM.Name,'-',RM.Room_No,' /','Bed:',RM.Bed_No,' /',' Floor:',RM.Floor) Name,RM.Room_Id  ");
        sb.Append(" FROM  room_master rm WHERE  IPDCaseTypeID='" + caseType + "' ");
       


        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
}