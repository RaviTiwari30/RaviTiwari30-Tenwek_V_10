using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Text;
using System.Web.Services;
using System.Web;
using System.Collections.Generic;

public partial class Design_BloodBank_BarcodeReprint : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtdatefrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtdateTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ViewState["ID"] = Session["ID"].ToString();
            
        }
        txtdatefrom.Attributes.Add("readOnly", "true");
        txtdateTo.Attributes.Add("readOnly", "true");
    }

    [WebMethod(EnableSession = true)]
    public static string SearchBarcodeType( string BagType, string FromDate,string ToDate)
    {

        try { 
            StringBuilder sb =new StringBuilder();
           
          
                sb.Clear();

                sb.Append(" SELECT CONCAT(DATE_FORMAT(bcd.CollectedDate,'%d-%b-%Y'),TIME_FORMAT(bcd.CollectedDate,' %H:%i:%s'))CollectionDate,bv.dtBirth,bv.Gender,bcd.Visitor_Id AS DonorID,bv.Name,bv.MobileNo,bcd.Visit_ID AS VisitId,'' ComponentName,bcd.BagType,bcd.BBTubeNo,BloodCollection_Id,'' BleedingDate ,'' ExpiryDate ");
                sb.Append(" FROM  bb_collection_details bcd  INNER JOIN bb_visitors bv ON bcd.Visitor_Id=bv.Visitor_ID  ");
                sb.Append(" WHERE bcd.CollectedDate>=CONCAT('"+Util.GetDateTime(FromDate).ToString("yyyy-MM-dd")+"',' ','00:00:00') AND bcd.CollectedDate<=CONCAT('"+Util.GetDateTime(ToDate).ToString("yyyy-MM-dd")+"',' ','23:59:59')   ");

                if (BagType != "")
                {
                    sb.Append(" and bcd.BloodCollection_Id='" + BagType + "' ");
                }
                DataTable dt = StockReports.GetDataTable(sb.ToString());
                if (dt.Rows.Count > 0)
                { return Newtonsoft.Json.JsonConvert.SerializeObject(dt); }
                else { return "0"; }

     

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }

    }

    [WebMethod(EnableSession = true)]
    public static string SearchBarcodePatientType(string UHID, string FromDate, string ToDate, string BarcodeCategory)
    {
        StringBuilder sb = new StringBuilder();
        try
        {
            
                sb.Append(" SELECT pm.Patient_ID,pm.HospitalName,CONCAT(pm.Title,'',pm.PName)Pname, ");
                sb.Append(" CONCAT(DATE_FORMAT(lt.Date,'%d-%b-%Y'),' ',TIME_FORMAT(lt.Time,'%h:%i'))DATE,pm.Mobile,pm.Age,pm.Gender,lt.LedgerTransactionNo,pmh.ID PmhID,IF(bbc.`ComponentID`='2' OR bbc.`ComponentID`='1',bbc.`ComponentID`,'')ComponentID ");
                sb.Append(" FROM f_ledgertransaction lt ");
                sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.Transaction_id=lt.Transaction_id ");
                sb.Append(" LEFT JOIN bb_blood_crossmatch bbc ON bbc.`LedgerTnxNo`=lt.`LedgerTransactionNo` ");
                sb.Append(" INNER JOIN patient_master pm ON pmh.`Patient_ID`=pm.Patient_ID WHERE ");
                
                sb.Append(" lt.Date>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND lt.Date<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'");
              
                if (UHID != "")
                { sb.Append("and pm.Patient_ID='" + UHID + "'"); }

                sb.Append(" GROUP BY lt.`LedgerTransactionNo`");

                DataTable dt = StockReports.GetDataTable(sb.ToString());
                if (dt.Rows.Count > 0)
                { return Newtonsoft.Json.JsonConvert.SerializeObject(dt); }
                else { return "0"; }
            
         
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }

    //[WebMethod(EnableSession = true)]
    //public static string DonorBarcodeWithCompnent(string BagTypeID)
    //{
    //    DataTable dt = StockReports.GetDataTable(" SELECT bcm.ComponentName,bcm.dtExpiry FROM bb_BagType_Component_Mapping bcmm INNER JOIN bb_component_master bcm ON bcmm.ComponentID=bcm.Id WHERE bcmm.BagTypeID='" + BagTypeID + "' ");
    //}
    
}