using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

public partial class Design_Lab_SampleCollectionWard : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["TransactionID"] == null)
                ViewState["TID"] = Request.QueryString["TID"].ToString();
            else
                ViewState["TID"] = Request.QueryString["TransactionID"].ToString();
        }
    }
    [WebMethod]
    public static string SearchSampleCollection(List<string> searchdata)
    {
        try
        {
            StringBuilder str = new StringBuilder();
            str.Append("SELECT (CASE WHEN plo.Type=1 THEN '#CC99FF' WHEN plo.Type=2 THEN 'bisque' ELSE '#FF0000' END) AS rowcolour,plo.LedgerTransactionNo,CONCAT(pm.Title,'',pm.PName)PName,CONCAT(plo.CurrentAge,'/',pm.Gender)Age,DATE_FORMAT(CONCAT(plo.Date,' ',plo.Time),'%d-%b-%y %l:%i %p')BillDate, ");
            str.Append("if(plo.Type=1,if((lt.NetAmount-lt.Adjustment > 0),1,0),0)Pendingcheck,plo.PatientID,IF(plo.SCRequestdatetime<>'0001-01-01 00:00:00' AND SCRequestdatetime>DATE_ADD(NOW(),INTERVAL 15 MINUTE ),'1',IF(plo.SCRequestdatetime<>'0001-01-01 00:00:00' AND SCRequestdatetime<=DATE_ADD(NOW(),INTERVAL 15 MINUTE) AND  SCRequestdatetime>= NOW(),'2',IF(plo.SCRequestdatetime<>'0001-01-01 00:00:00' AND plo.SCRequestdatetime<NOW(),'3','0')))SReColorcode FROM patient_labinvestigation_opd plo ");
            str.Append("INNER JOIN patient_master pm ON pm.PatientID=plo.PatientID ");
            str.Append("INNER JOIN f_ledgertransaction lt ON lt.LedgertransactionNo=plo.LedgerTransactionNo ");
            str.Append("INNER JOIN doctor_master dm ON dm.DoctorID=plo.DoctorID ");
            str.Append("INNER JOIN f_ledgertnxdetail ltd ON ltd.ID=plo.LedgerTnxID ");
            str.Append("WHERE lt.isCancel=0 AND plo.sampleTransferCentreID =" + HttpContext.Current.Session["CentreID"].ToString() + " ");
            str.Append("AND ltd.IsVerified=1 ");
            switch (searchdata[1])
            {
                case "N": str.Append(" AND plo.IsSampleCollected='N' ");
                    break;
                case "Y": str.Append(" AND plo.IsSampleCollected='Y' ");
                    break;
                case "S": str.Append(" AND plo.IsSampleCollected='S' ");
                    break;
                case "R": str.Append(" AND plo.IsSampleCollected='R' ");
                    break;
            }
            str.Append(" AND plo.TransactionID = '" + searchdata[0] + "' ");
            str.Append(" GROUP BY lt.LedgertransactionNo order by plo.BarcodeNo ");
            return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(str.ToString()));
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
    }
}