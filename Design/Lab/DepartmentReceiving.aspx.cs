

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;
using MySql.Data.MySqlClient;
using System.Web.Services;

public partial class Design_Lab_DepartmentReceiving : System.Web.UI.Page
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
    public static string BindDepartment()
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT DISTINCT ot.Name,ot.ObservationType_ID FROM investigation_master im INNER JOIN investigation_observationtype io  ");
            sb.Append(" ON im.Investigation_Id = io.Investigation_ID INNER JOIN observationtype_master ot ON ot.ObservationType_ID = io.ObservationType_Id ");
            sb.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = ot.ObservationType_ID and cr.RoleID='" + HttpContext.Current.Session["RoleID"].ToString() + "' ");
            sb.Append(" order by ot.Name");
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
    public static string SaveDeptReceive(List<string> data)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT  cm.CentreName BookingCenter,(CASE WHEN plo.Type=1 THEN 'OPD' WHEN plo.Type=2 THEN 'IPD' ELSE 'Emergency' END) AS PatientType,plo.Result_Flag,plo.Test_ID,plo.BarcodeNo,CONCAT(pm.Title,'',pm.PName)PatientName,pm.PatientID,CONCAT(plo.CurrentAge,'/',pm.Gender)Age, ");
            sb.Append("case when plo.IsSampleCollected='S' then  'lightyellow' when plo.IsSampleCollected='Y' then 'lightgreen'  when plo.IsSampleCollected='R' then 'pink' else 'white' end rowcolor, ");
            sb.Append("ot.Name DeptName,im.Name TestName,plo.IsSampleCollected,im.Reporttype AS Reporttype,plo.reportnumber,ot.Description  ");
            sb.Append(" ,IF (plo.SCRequestdatetime='0001-01-01 00:00:00','', DATE_FORMAT(plo.SCRequestdatetime,'%d-%b-%y %l:%i %p'))Samplerequestdate, ");
            sb.Append(" IF(plo.IsSampleCollected='N','',DATE_FORMAT(plo.SampleDate,'%d-%b-%y %l:%i %p'))Acutalwithdrawdate, ");
            sb.Append(" IF(plo.SCRequestdatetime='0001-01-01 00:00:00' ,'',IF(plo.IsSampleCollected='N','', ");
            sb.Append(" TIME_FORMAT(TIMEDIFF(plo.SampleDate,plo.SCRequestdatetime),'%H Hr %i M ')))DevationTime ");
            sb.Append("FROM patient_labinvestigation_opd plo ");
            sb.Append("INNER JOIN patient_master pm ON pm.PatientID =plo.PatientID ");
            sb.Append("INNER JOIN investigation_master im ON im.Investigation_Id=plo.Investigation_ID AND im.ReportType<>5 ");
            sb.Append("INNER JOIN f_ledgertransaction lt ON lt.LedgertransactionNo =plo.LedgerTransactionNo ");
            sb.Append("INNER JOIN f_ledgertnxdetail ltd ON ltd.ID=plo.LedgertnxID AND ltd.IsVerified<>2 ");
            sb.Append("INNER JOIN investigation_observationtype io ON io.Investigation_ID=plo.Investigation_ID ");
            sb.Append("INNER JOIN observationtype_master ot ON ot.ObservationType_ID=io.ObservationType_Id ");
            sb.Append("INNER JOIN center_master cm ON cm.CentreID=plo.CentreID ");
            sb.Append("LEFT JOIN sample_logistic sl ON sl.Test_ID=plo.Test_ID  AND sl.isActive=1 ");
            if(data[0] == "0")
            sb.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = ot.ObservationType_ID and cr.RoleID='" + HttpContext.Current.Session["RoleID"].ToString() + "' ");
            sb.Append("WHERE IF(plo.isTransfer=1,(sl.Status='LogisticReceive' OR sl.status='Receive'),plo.CentreID=plo.sampleTransferCentreID) ");
            sb.Append("AND plo.sampleTransferCentreID=" + HttpContext.Current.Session["CentreID"].ToString() + "  ");
            if (data[5] != "S") 
                sb.Append(" And plo.IsSampleCollected= '" + data[5] + "' "); 
            if (data[5] != "Y") 
                sb.Append(" And plo.IsSampleCollected= '" + data[5] + "' "); 
            if (data[5] != "R") 
                sb.Append(" And plo.IsSampleCollected= '" + data[5] + "' "); 
            if(data[1] != "")
            sb.Append("AND plo.BarcodeNo='"+ data[1]+"' ");
            if (data[2] != "")
                sb.Append("AND pm.PatientID ='" + Util.GetFullPatientID(data[2]) + "' ");
            if (data[0] != "0")
                sb.Append("AND ot.ObservationType_ID='"+ data[0] +"' ");
            if (data[0] == "0" && data[1] == "" && data[2] == "")
            {
                sb.Append("AND IF(plo.isTransfer=1, ");
                sb.Append(" (sl.LogisticReceiveDate >='" + Util.GetDateTime(data[3]).ToString("yyyy-MM-dd") + " 00:00:00' ");
                sb.Append(" AND sl.LogisticReceiveDate <='" + Util.GetDateTime(data[4]).ToString("yyyy-MM-dd") + " 23:59:59'), ");
                sb.Append(" (plo.SampleCollectionDate>='" + Util.GetDateTime(data[3]).ToString("yyyy-MM-dd") + " 00:00:00' ");
                sb.Append(" AND plo.SampleCollectionDate<='" + Util.GetDateTime(data[4]).ToString("yyyy-MM-dd") + " 23:59:59')) ");
            }
           
                    
            sb.Append("  GROUP BY plo.Test_ID ");
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
    public static string SaveSampleReceive(List<string> data)
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
                sb.Append("UPDATE sample_logistic sl SET sl.Status='Receive' ");
                sb.Append("WHERE sl.isActive=1 AND sl.Test_ID=@Test_ID ");
                int cnt = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@Test_ID", s.Split('#')[0]));
                string Biopsy_No = string.Empty;
                
                if (s.Split('#')[2] == "7")
                {
                    Biopsy_No = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT Get_BiopsyNo('Biospy No.'," + HttpContext.Current.Session["CentreID"].ToString() + ") "));
                    if (Biopsy_No == "")
                    {
                        tnx.Rollback();
                        return "0";
                    }
                }
                //if (s.Split('#')[3] == "LSHHI302")
                //{
                //    Biopsy_No = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT Get_BiopsyNo('Cyto Biopsy No.'," + HttpContext.Current.Session["CentreID"].ToString() + ") "));
                //    if (Biopsy_No == "")
                //    {
                //        tnx.Rollback();
                //        return "0";
                //    }
                //}
                sb = new StringBuilder();
                sb.Append("UPDATE patient_labinvestigation_opd plo SET plo.IsSampleCollected='Y',plo.SampleReceiveDate=NOW(),plo.SampleReceivedBy=@SampleReceivedBy, ");
                sb.Append("plo.SampleReceiver=@SampleReceiver,plo.isTransferReceive=1,plo.MacStatus=1,plo.slidenumber=@slidenumber,plo.Reporttype=@Reporttype WHERE plo.Test_ID=@Test_ID ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@SampleReceivedBy", HttpContext.Current.Session["ID"].ToString()),
                new MySqlParameter("@SampleReceiver", HttpContext.Current.Session["LoginName"].ToString()),
                new MySqlParameter("@Test_ID", s.Split('#')[0]),
                new MySqlParameter("@slidenumber", Biopsy_No),
                new MySqlParameter("@Reporttype", s.Split('#')[2])
                );
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Call insert_mac_master('" + HttpContext.Current.Session["CentreID"].ToString() + "','" + s.Split('#')[0] + "','Receive')");
                string Status = LabOPD.UpdateSampleStatus(tnx, s, HttpContext.Current.Session["ID"].ToString(), HttpContext.Current.Session["LoginName"].ToString(), Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()), Util.GetInt(HttpContext.Current.Session["RoleID"].ToString()), "Sample Receive", "");
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
    [WebMethod]
    public static string savetranferdata(List<string> data)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        // string sql = "";
        try
        {
            foreach (string s in data)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("update patient_labinvestigation_opd set IsSampleCollected='S',SampleDate=NOW(),UpdateID=@UpdateID,UpdateName=@UpdateName,UpdateDate=NOW() where Test_ID=@Test_ID ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@UpdateID", HttpContext.Current.Session["ID"].ToString()),
                    new MySqlParameter("@UpdateName", HttpContext.Current.Session["LoginName"].ToString()),
                    new MySqlParameter("@Test_ID",s));

                sb = new StringBuilder();
                sb.Append("update sample_logistic set Status='SDR Transfered',isActive=0 where isActive=1 AND Test_ID ='" + s + "' and Status='Receive' and `ToCentreID`='" + HttpContext.Current.Session["CentreID"].ToString() + "';");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                sb = new StringBuilder();

                string Status = LabOPD.UpdateSampleStatus(tnx, s, HttpContext.Current.Session["ID"].ToString(), HttpContext.Current.Session["LoginName"].ToString(), Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()), Util.GetInt(HttpContext.Current.Session["RoleID"].ToString()), "Sample Department Receive Transfered", "");
                if (Status == "0")
                {
                    tnx.Rollback();
                    return "Record Not Saved !";
                }
            }
            tnx.Commit();

            return "1";
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            tnx.Rollback();
            return "Record Not Saved !";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
}