using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;
using System.Web.Services;

public partial class Design_Lab_SampleTransfer : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            FrmDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
        FrmDate.Attributes.Add("readonly", "readonly");
        ToDate.Attributes.Add("readonly", "readonly");
    }
    [WebMethod]
    public static string bindCenter()
    {
        try {
            return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT cm.CentreID,cm.CentreName FROM center_master cm  WHERE cm.IsActive=1 AND cm.CentreID<>" + HttpContext.Current.Session["CentreID"].ToString() + ""));
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
    }
    [WebMethod]
    public static string SearchInvestigation(string BarcodeNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT Date_Format(plo.SampleCollectionDate,'%d-%b-%y %l:%i %p') AS CollDate,plo.BarcodeNo,CONCAT(pm.Title,' ',pm.PName)PatientName,plo.PatientID PatientID,im.Name AS TestName,plo.Test_ID FROM patient_labinvestigation_opd plo ");
        sb.Append("INNER JOIN patient_master pm ON pm.PatientID=plo.PatientID ");
        sb.Append("INNER JOIN investigation_master im ON im.Investigation_Id=plo.Investigation_ID ");
        sb.Append("WHERE plo.IsSampleCollected='S' AND plo.sampleTransferCentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' ");
        sb.Append("AND plo.BarcodeNo='"+ BarcodeNo.Trim() +"' AND im.ReportType<>5 ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public static string SaveSampleTransfer(List<string> data)
    {

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        try
        {
            foreach (string s in data)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("UPDATE patient_labinvestigation_opd plo SET plo.isTransfer=1,plo.sampleTransferCentreID=@sampleTransferCentreID, ");
                sb.Append("plo.sampleTransferUserID=@sampleTransferUserID, plo.sampleTransferDate=NOW() WHERE plo.Test_ID=@Test_ID ");
                int cnt = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                           new MySqlParameter("@sampleTransferCentreID", s.Split('#')[1]),
                   new MySqlParameter("@sampleTransferUserID", HttpContext.Current.Session["ID"].ToString()),
                   new MySqlParameter("@Test_ID", s.Split('#')[0]));
                if (cnt > 0)
                {
                    //int DispatchCode =  Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select get_barcode(" + Util.GetInt(HttpContext.Current.Session["CentreID"]) + ")").ToString());
                    sb = new StringBuilder();
                    sb.Append("INSERT INTO sample_logistic (Test_ID,BarcodeNo,FromCentreID,ToCentreID,EntryBy,Status) ");
                    sb.Append("VALUES (@Test_ID,@BarcodeNo,@FromCentreID,@ToCentreID,@EntryBy,'Transfered') ");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                       new MySqlParameter("@Test_ID", s.Split('#')[0]),
                       new MySqlParameter("@BarcodeNo", s.Split('#')[2]),
                       new MySqlParameter("@FromCentreID", HttpContext.Current.Session["CentreID"].ToString()),
                       new MySqlParameter("@ToCentreID", s.Split('#')[1]),
                       new MySqlParameter("@EntryBy", HttpContext.Current.Session["ID"].ToString())
                       );
                }
                string Status = LabOPD.UpdateSampleStatus(tnx, s.Split('#')[0], HttpContext.Current.Session["ID"].ToString(), HttpContext.Current.Session["LoginName"].ToString(), Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()), Util.GetInt(HttpContext.Current.Session["RoleID"].ToString()), "Sample Transfered", "");
                if (Status == "0")
                {
                    tnx.Rollback();
                    return "0";
                }
            }
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string SampleDispatchSearch(string dispatchcenter, string fromdate, string todate)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT cm.CentreName FromCentre,cm1.CentreName ToCenter,pm.PName,pm.PatientID,sl.BarcodeNo,im.Name TestName, ");
            sb.Append("DATE_FORMAT(sl.EntryDate,'%d-%b-%y %l:%i %p')TransferDate,CONCAT(em.Title,'',em.Name)TransferedBy,sl.ID,plo.Test_ID ");
            sb.Append("FROM patient_labinvestigation_opd plo ");
            sb.Append("INNER JOIN investigation_master im ON im.Investigation_Id=plo.Investigation_ID ");
            sb.Append("INNER JOIN sample_logistic sl ON sl.Test_ID=plo.Test_ID And sl.isActive=1 ");
            sb.Append("INNER JOIN patient_master pm ON pm.PatientID=plo.PatientID ");
            sb.Append("INNER JOIN center_master cm ON cm.CentreID=sl.FromCentreID ");
            sb.Append("INNER JOIN center_master cm1 ON cm1.CentreID = sl.ToCentreID ");
            sb.Append("INNER JOIN employee_master em ON em.EmployeeID=sl.EntryBy ");
            sb.Append("Where im.ReportType<>5 AND sl.IsDispatch=0  AND plo.sampleTransferCentreID =" + dispatchcenter + "  AND sl.Status ='Transfered' ");
            sb.Append("AND sl.EntryDate>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' AND sl.EntryDate<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            else
                return "";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
    }
    [WebMethod]
    public static string SaveSampleDispatch(List<string> data)
    {
         MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        try
        {
            string DispatchCode = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select get_batchno_centre(" + Util.GetInt(HttpContext.Current.Session["CentreID"]) + ")").ToString();
            foreach (string s in data)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("UPDATE sample_logistic sl SET sl.IsDispatch=1,sl.DipatchCode=@DipatchCode,sl.DispatchBy=@DispatchBy, ");
                sb.Append("sl.DispatchDate=NOW(),sl.CourierBoy=@CourierBoy,sl.Status='Dispatch' WHERE isActive=1 AND sl.ID=@ID ");
                int cnt = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@DipatchCode", DispatchCode),
                new MySqlParameter("@DispatchBy", HttpContext.Current.Session["ID"].ToString()),
                new MySqlParameter("@CourierBoy", s.Split('#')[1]),
                new MySqlParameter("@ID", s.Split('#')[0]));
                string Status = LabOPD.UpdateSampleStatus(tnx, s.Split('#')[2], HttpContext.Current.Session["ID"].ToString(), HttpContext.Current.Session["LoginName"].ToString(), Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()), Util.GetInt(HttpContext.Current.Session["RoleID"].ToString()), "Sample Dispatch", DispatchCode);
                if (Status == "0")
                {
                    tnx.Rollback();
                    return "0";
                }
            }
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally 
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}