using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web;
using System.Text;

public partial class Reports_NewReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod(EnableSession = true)]
    public static string GetReport(string transactionNumber)
    {

        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT lt.LedgertransactionNo,pm.PatientID,pm.Title,pm.PFirstName,pm.PLastName,DATE_FORMAT(pm.DOB,'%d-%b-%Y')DOB,pm.Gender,pm.Age,lt.Date,lt.Time,pm.Relation,pm.RelationName,pm.RelationPhoneNo,CONCAT(IFNULL(pm.Relation,''),' ,',IFNULL(pm.RelationName,''),' ,',IFNULL(pm.RelationPhoneNo,''))RelationDetails,pm.Mobile,CONCAT(IFNULL(Phone_STDCODE,''),'-',IFNULL(pm.Phone,''))Phone,CONCAT(IFNULL(pm.ResidentialNumber_STDCODE,''),'-',IFNULL(pm.ResidentialNumber,''))ResidentialNumber,CONCAT(pm.House_No,' ',pm.Street_Name,' ', pm.Locality,' ',pm.City,' ',pm.Country)Address,(CASE WHEN plo.ReportDispatchModeID=1 THEN 'Hand-Over' WHEN plo.ReportDispatchModeID=2 THEN 'Courier' ELSE 'E-Mail' END)ReportDispatchModeID,lt.PaymentModeID FROM f_ledgertransaction lt INNER JOIN patient_master pm ON pm.PatientID = lt.PatientID INNER JOIN patient_labinvestigation_opd plo ON plo.TransactionID = lt.TransactionID ");
            sb.Append("WHERE lt.`LedgertransactionNo`=" + transactionNumber.Trim() + "");

            DataTable dtReport = StockReports.GetDataTable(sb.ToString());

            if (dtReport != null && dtReport.Rows.Count > 0)
            {
                    DataColumn dc = new DataColumn();               
                    //dtReport.Columns.Remove("TransactionID");                  
                    //dtReport.Columns[20].ColumnName = "CancelledBy";
                    dtReport.AcceptChanges();
                    HttpContext.Current.Session["dtExport2Excel"] = dtReport;
                    HttpContext.Current.Session["ReportName"] = "LaboratoryOutPatientRecordForm";
                 HttpContext.Current.Session["Period"] ="";
                 DataSet ds = new DataSet();
                 ds.Tables.Add(dtReport.Copy());
                // ds.WriteXmlSchema(@"D:\NewReport.xml");
                 HttpContext.Current.Session["ds"] = ds;
           
                // HttpContext.Current.Session["ReportName"] = "NewReport";
                 return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, responseURL = "../Design/common/Commonreport.aspx" });
                  
               
            }
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "No Data Found" });
        }
        catch (Exception ex)
        {

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });

        }



    }
}