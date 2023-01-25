using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using System.Web.Services;

public partial class Design_IPD_VantilatorPatientReport : System.Web.UI.Page
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
    public static string Ventilator(string FromDate, string ToDate, string IPDNo, string IsInfected)
    {
        if (IPDNo != "")
            IPDNo = StockReports.getTransactionIDbyTransNo(IPDNo.Trim());//"" +
        
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT vs.ID,REPLACE(TID,'ISHHI','')TID,PID,DATE_FORMAT(DateofInsertion,'%d-%b-%y %h:%m %p')DateofInsertion, ");
        sb.Append("DATE_FORMAT(DateofRemoval,'%d-%b-%y %h:%m %p')DateofRemoval, DATE_FORMAT(vs.StartDate,'%d-%b-%y %h:%m %p')StartDate, ");
        sb.Append("DATE_FORMAT(RemovalDate,'%d-%b-%y %h:%m %p')RemovalDate,IF(InfControlNurse='Select','',InfControlNurse)InfControlNurse,Infection,  ");
        sb.Append("DATEDIFF(RemovalDate,DateofInsertion)Days,pm.PName,CONCAT(pm.Age,'/',pm.Gender)Age,icm.Name WardName FROM vapstart vs ");
        sb.Append("INNER JOIN patient_ipd_profile pip ON pip.TransactionID=vs.TID ");
        sb.Append("INNER JOIN ipd_case_type_master  icm ON icm.IPDCaseTypeID=pip.IPDCaseTypeID ");
        sb.Append("INNER JOIN patient_master pm ON pm.PatientID=pip.PatientID WHERE ");
            if(IPDNo == "")
        sb.Append("DATE(vs.StartDate)>='"+ Util.GetDateTime(FromDate).ToString("yyyy-MM-dd")+"' AND DATE(vs.StartDate)<='"+ Util.GetDateTime(ToDate).ToString("yyyy-MM-dd")+"' ");
            else
        sb.Append(" vs.TID='"+ IPDNo +"' ");
            if (IsInfected == "1")
                sb.Append(" vs.InfControlNurse<>'' ");
            sb.Append(" Group By vs.ID ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            else
                return "";
    }
}