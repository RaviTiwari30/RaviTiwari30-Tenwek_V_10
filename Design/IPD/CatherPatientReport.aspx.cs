using System;
using System.Web.Services;
using System.Text;
using System.Data;

public partial class Design_IPD_CatherPatientReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        }
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");
    }
    [WebMethod]
    public static string Cather(string FromDate, string ToDate, string IPDNo, string IsInfected)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT vs.ID,REPLACE(TID,'ISHHI','')TID,PID,DATE_FORMAT(InsertedDate,'%d-%b-%Y %h:%m %p')DateofInsertion,Infection,(SELECT Name from employee_master where employee_ID=InfectionUser)InfectionUser, ");
        sb.Append("DATE_FORMAT(Removedate,'%d-%b-%Y %h:%m %p')DateofRemoval,(Select Name from employee_Master where Employee_ID=InsertedBy)InsertedBy ,(Select Name from employee_Master where Employee_ID=RemovedBy)RemovedBy,");
        sb.Append("DATEDIFF(Removedate,InsertedDate)Days,pm.PName,CONCAT(pm.Age,'/',pm.Gender)Age,icm.Name WardName FROM catherinsert vs ");
        sb.Append("INNER JOIN patient_ipd_profile pip ON pip.TransactionID=vs.TID ");
        sb.Append("INNER JOIN ipd_case_type_master  icm ON icm.IPDCaseType_ID=pip.IPDCaseType_ID ");
        sb.Append("INNER JOIN patient_master pm ON pm.PatientID=pip.PatientID WHERE ");
        if (IPDNo == "")
            sb.Append("DATE(vs.EntryDate)>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND DATE(vs.EntryDate)<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' ");
        else
            sb.Append(" vs.TID='ISHHI" + IPDNo + "' ");
        if(IsInfected == "1")
            sb.Append(" AND vs.InfectionUser<>'' ");
        sb.Append(" Group By vs.ID ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
}