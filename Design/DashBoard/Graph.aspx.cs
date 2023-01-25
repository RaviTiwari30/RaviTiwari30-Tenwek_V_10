using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_DashBoard_Graph : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // DateTime dt = DateTime.Now;
            //txtFormDate.Text = dt.ToString("dd-MMM-yyyy");
            //txtToDate.Text = dt.ToString("dd-MMM-yyyy");
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetChartData(string FromDate, string ToDate) //, string LabNo, string SmpleColl, string Department, string sinNo, int Status
    {
        if (FromDate == "" && ToDate == "")
        {
            FromDate = DateTime.Now.ToString("yyyy-MM-dd");
            ToDate = DateTime.Now.ToString("yyyy-MM-dd");
        }
        DataSet ds = new DataSet();
        StringBuilder sb = new StringBuilder();
        try
        {
            //      -- Query for Departmentwise Patient
            sb.Append(" SELECT ot.`Name` AS label,COUNT(1) y  FROM `patient_labinvestigation_opd` pli ");
            sb.Append(" INNER JOIN investigation_observationtype io ON io.Investigation_ID = pli.Investigation_ID ");
            sb.Append(" INNER JOIN observationtype_master ot ON ot.ObservationType_ID = io.ObservationType_Id ");
            sb.Append(" AND pli.date >='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00'  AND pli.date <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
            sb.Append(" GROUP BY io.ObservationType_Id ");

            DataTable dt1 = new DataTable();
            dt1 = StockReports.GetDataTable(sb.ToString());
            sb.Clear();
            // -- Query for status wise patient 
            sb.Append(" SELECT label,COUNT(1) y FROM (  ");
            sb.Append(" SELECT CASE WHEN pli.IsSampleCollected='R' THEN 'Sample Rejected' ");//Sample Rejected
            sb.Append("   WHEN pli.IsDispatch='1' AND pli.isFOReceive='1' THEN 'Dispatched' "); //Dispatched
            sb.Append("  WHEN  pli.Approved='1' AND pli.isPrint='1' THEN 'Printed'  "); //Printed
            sb.Append("  WHEN   pli.Approved='1'  THEN 'Approved' "); //Approved
            sb.Append("  WHEN pli.isHold='1' THEN 'Hold' "); //Hold
            sb.Append("  when pli.IsTransfer='1' AND pli.IsSampleCollected<>'Y' THEN 'Transfered' "); //Transfered
            sb.Append("  WHEN pli.Result_Flag='1' AND pli.isHold='0' AND pli.isForward='0' AND isPartial_Result='0' AND  pli.IsSampleCollected<>'R'  THEN 'Tested'  "); //Tested
            sb.Append("  WHEN pli.Result_Flag='1' AND pli.isHold='0' AND pli.isForward='1' THEN '#3399FF' ");
            sb.Append("  WHEN pli.Result_Flag='0' AND pli.IsTestRerun='1' THEN 'Rerun'   ");
            sb.Append("  WHEN pli.Result_Flag='0' AND (SELECT COUNT(*) FROM mac_data mac WHERE mac.LedgerTransactionNO=pli.LedgerTransactionNO  ");
            sb.Append("  AND mac.Test_ID=pli.Test_ID AND IFNULL(Reading,'')<>'')>0 THEN 'Mac Data' ");
            sb.Append("  WHEN pli.IsSampleCollected='N' or pli.IsSampleCollected='S' THEN 'Pending'  ");//New 
            sb.Append("  WHEN pli.Result_Flag=0 and pli.isSampleCollected='Y' THEN 'Department Receive' "); //Department Receive
            sb.Append("  else 'Other' ");
            sb.Append("    END AS label ");
            sb.Append("  FROM `patient_labinvestigation_opd` pli  ");
            sb.Append("   WHERE   pli.date >='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00'  ");
            sb.Append("  AND pli.date <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' )t GROUP BY label ORDER BY  label ");
            DataTable dt2 = StockReports.GetDataTable(sb.ToString());
            sb.Clear();

            // -- location Wise count patient
            sb.Append(" SELECT (CASE WHEN pli.Type=1 THEN 'OPD' WHEN pli.Type=2 THEN 'IPD' ELSE 'Emergency' END) AS label, COUNT(1) y  FROM patient_labinvestigation_opd pli  ");
            sb.Append("  Where pli.date >='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
            sb.Append(" AND pli.date <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
            sb.Append(" GROUP BY label ");
            DataTable dt3 = StockReports.GetDataTable(sb.ToString());
            sb.Clear();

            // Test wise 
            sb.Clear();
            sb.Append(" SELECT im.`Name` AS label, COUNT(1) y ");
            sb.Append(" FROM `patient_labinvestigation_opd`  pli ");
            sb.Append(" INNER JOIN investigation_master im ON im.investigation_id = pli.investigation_id ");
            sb.Append("  AND pli.date >='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
            sb.Append(" AND pli.date <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
            sb.Append("GROUP BY pli.`Investigation_ID` ORDER BY pli.date DESC ");
 
            DataTable dt4 = StockReports.GetDataTable(sb.ToString());
            sb.Clear();

            dt1.TableName = "Departmentwise";
            dt2.TableName = "Status";
            dt3.TableName = "Location";
            dt4.TableName = "Test";
            
            ds.Tables.Add(dt1.Copy());
            ds.Tables.Add(dt2.Copy());
            ds.Tables.Add(dt3.Copy());
            ds.Tables.Add(dt4.Copy());
            //Newtonsoft.Json.JsonConvert.SerializeObject(dt2);

        }
        catch (Exception)
        {

        }


        return Newtonsoft.Json.JsonConvert.SerializeObject(ds);
    }
}