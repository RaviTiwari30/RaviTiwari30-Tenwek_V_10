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

public partial class Design_Lab_SampleSendOutsouceLab : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            FrmDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            BindlabOutSource();
        }
        FrmDate.Attributes.Add("readonly", "readonly");
        ToDate.Attributes.Add("readonly", "readonly");
    }
    private void BindlabOutSource()
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID,Name FROM OutSourceLabMaster WHERE Active='1'");
        if (dt.Rows.Count > 0)
        {
            ddloutsourcelab.DataSource = dt;
            ddloutsourcelab.DataTextField = "Name";
            ddloutsourcelab.DataValueField = "ID";
            ddloutsourcelab.DataBind();
            ddloutsourcelab.Items.Insert(0, new ListItem(" "));
            ddlOutSourceHeader.DataSource = dt;
            ddlOutSourceHeader.DataTextField = "Name";
            ddlOutSourceHeader.DataValueField = "ID";
            ddlOutSourceHeader.DataBind();
            ddlOutSourceHeader.Items.Insert(0, new ListItem(" "));
        }
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
            sb.Append("SELECT plo.IsOutSource,plo.OutSourceID,plo.Result_Flag,plo.Test_ID,plo.BarcodeNo,CONCAT(pm.Title,'',pm.PName)PatientName,pm.PatientID,CONCAT(plo.CurrentAge,'/',pm.Gender)Age, ");
            sb.Append("case when plo.IsOutSource='1' then  'Aqua' else 'lightyellow' end rowcolor, ");
            sb.Append("ot.Name DeptName,im.Name TestName,plo.IsSampleCollected  ");
            sb.Append("FROM patient_labinvestigation_opd plo ");
            sb.Append("INNER JOIN patient_master pm ON pm.PatientID =plo.PatientID ");
            sb.Append("INNER JOIN investigation_master im ON im.Investigation_Id=plo.Investigation_ID ");
            sb.Append("INNER JOIN f_ledgertransaction lt ON lt.LedgertransactionNo =plo.LedgerTransactionNo ");
            sb.Append("INNER JOIN investigation_observationtype io ON io.Investigation_ID=plo.Investigation_ID ");
            sb.Append("INNER JOIN observationtype_master ot ON ot.ObservationType_ID=io.ObservationType_Id ");
            sb.Append("LEFT JOIN sample_logistic sl ON sl.Test_ID=plo.Test_ID  AND sl.isActive=1 ");
            if (data[0] == "0")
                sb.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = ot.ObservationType_ID and cr.RoleID='" + HttpContext.Current.Session["RoleID"].ToString() + "' ");
            sb.Append("WHERE plo.Result_Flag=0 AND plo.IsSampleCollected='S' AND  IF(plo.isTransfer=1,(sl.Status='LogisticReceive' OR sl.status='Receive'),plo.CentreID=plo.sampleTransferCentreID) ");
            sb.Append("AND plo.sampleTransferCentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " ");
            if (data[1] != "")
                sb.Append("AND plo.BarcodeNo='" + data[1] + "' ");
            if (data[2] != "")
                sb.Append("AND pm.PatientID ='" + data[2] + "' ");
            if (data[0] != "0")
                sb.Append("AND ot.ObservationType_ID='" + data[0] + "' ");
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
    public static string SaveOutsourceSample(List<string> data)
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
                sb.Append("UPDATE patient_labinvestigation_opd plo SET plo.IsOutSource='1',plo.OutSourceID=@OutSourceID,plo.OutSourceLab=@OutSourceLab, ");
                sb.Append("plo.OutSourceBy=@OutSourceBy,plo.OutsourceDate=NOW() WHERE plo.Test_ID=@Test_ID ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@OutSourceID", s.Split('#')[1]),
                new MySqlParameter("@OutSourceLab", s.Split('#')[2]),
                new MySqlParameter("@OutSourceBy", HttpContext.Current.Session["ID"].ToString()),
                new MySqlParameter("@Test_ID", s.Split('#')[0]));
            }
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}