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

public partial class Design_IPD_EditPatientLabInvestigation : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (All_LoadData.checkPageAuthorisation(Session["RoleID"].ToString(), Session["ID"].ToString(), HttpContext.Current.Request.Url.AbsolutePath.Remove(0, VirtualPathUtility.ToAbsolute("~/").Length - 1)) == 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.location ='../Common/UserAuthorization.aspx?msg=For This Page';", true);
            return;
        }
        {
            if (!IsPostBack)
            {
                txtfromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
                txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");



            }
            txtfromDate.Attributes.Add("readOnly", "readOnly");
            txtToDate.Attributes.Add("readOnly", "readOnly");
        }
    }
    [WebMethod]
    public static string SearchTest(string from, string to, string LabNo, string dept, string IPDNO)
    {
      //  string labno = string.Empty;
      //  if (LabNo.StartsWith("1"))
       // {
           // labno = LabNo.Replace("1", "LOSHHI");
       // }
      //  else
      //  {
      //      labno = LabNo.Replace("2", "LSHHI");
      //  }
        StringBuilder sb = new StringBuilder();
        if (dept == "0")

        {
            sb.Append(" SELECT pm.PatientID,pm.Pname,im.Name,REPLACE(REPLACE(REPLACE(plo.LedgertransactionNo,'LOSHHI','1'),'LSHHI',2),'LISHHI',3)AS LedgertransactionNo, ");
            sb.Append(" plo.LedgertransactionNo as LabNo,im.Investigation_Id,date_format(plo.Date ,'%d-%b-%Y')as SampleDate, ");
            sb.Append(" TIME_FORMAT(plo.Time,'%I:%i %p') AS SampleTime,date_format(plo.SampleReceiveDate,'%d-%b-%Y')as ResultEnteredDate,TIME_FORMAT(plo.SampleReceiveDate,'%I:%i %p')AS ResultEnteredTime, ");
            sb.Append(" date_format(plo.ApprovedDate,'%d-%b-%Y')as ApprovedDate,TIME_FORMAT(plo.ApprovedDate,'%I:%i %p')AS ApprovedTime,'' DateOfAdmit,'' DateOfDischarge,'' DateOfAdmit,'' TimeOfDischarge,'' LedgertnxID FROM patient_labinvestigation_opd plo ");
            sb.Append(" INNER JOIN Patient_Master pm ON pm.PatientID = plo.PatientID  ");
            sb.Append(" inner join f_ledgertransaction lt on lt.ledgertransactionno=plo.ledgertransactionno ");
            sb.Append(" INNER JOIN investigation_master im ON im.Investigation_Id = plo.Investigation_ID ");
            sb.Append(" Where DATE(plo.Date) >= '" + Util.GetDateTime(from).ToString("yyyy-MM-dd") + "' AND DATE(plo.Date) <= '" + Util.GetDateTime(to).ToString("yyyy-MM-dd") + "' and lt.iscancel=0 ");

            if (LabNo != "")
            {
                sb.Append("  AND plo.LedgerTransactionNo = CONCAT(REPLACE(SUBSTRING('" + LabNo + "', 1, 1),'1','LOSHHI'),SUBSTRING('" + LabNo + "' FROM 2) ) ");
            }
            sb.Append(" GROUP BY im.Name ");
        }
        else
        {
            sb.Append(" SELECT pm.PatientID,pm.Pname,im.Name,REPLACE(REPLACE(REPLACE(pli.LedgertransactionNo,'LOSHHI','1'),'LSHHI',2),'LISHHI',3)AS LedgertransactionNo, ");
            sb.Append(" pli.LedgertransactionNo as LabNo,im.Investigation_Id,DATE_FORMAT(pli.Date ,'%d-%b-%Y')as SampleDate,TIME_FORMAT(pli.Time ,'%I:%i %p') AS SampleTime, ");
            sb.Append(" DATE_FORMAT(pli.SampleReceiveDate,'%d-%b-%Y')as ResultEnteredDate,TIME_FORMAT(pli.SampleReceiveDate,'%I:%i %p')AS ResultEnteredTime, ");
            sb.Append(" DATE_FORMAT(pli.ApprovedDate,'%d-%b-%Y')as ApprovedDate,TIME_FORMAT(pli.ApprovedDate,'%I:%i %p')AS ApprovedTime, ");
            sb.Append(" DATE_FORMAT(ich.DateOfAdmit,'%d-%b-%Y')DateOfAdmit,TIME_FORMAT(ich.TimeOfAdmit,'%I:%i %p')TimeOfAdmit,");
            sb.Append(" IF(ich.Status='IN','',DATE_FORMAT(ich.DateOfDischarge,'%d-%b-%Y'))DateOfDischarge,IF(ich.Status='IN','',TIME_FORMAT(ich.TimeOfDischarge,'%I:%i %p'))TimeOfDischarge,pli.LedgertnxID ");
            sb.Append(" FROM patient_labinvestigation_Opd pli ");
            sb.Append(" INNER JOIN Patient_Master pm ON pm.PatientID = pli.PatientID  ");
            sb.Append(" INNER JOIN f_ledgertnxdetail ltd on ltd.LedgerTransactionNo=pli.LedgertransactionNo ");
            sb.Append(" INNER JOIN investigation_master im ON im.Investigation_Id = pli.Investigation_ID ");
            sb.Append(" INNER JOIN ipd_case_history ich ON ich.TransactionID=ltd.TransactionID ");
            sb.Append(" Where DATE(pli.Date) = '" + Util.GetDateTime(from).ToString("yyyy-MM-dd") + "' ");
            sb.Append(" AND DATE(pli.Date) <= '" + Util.GetDateTime(to).ToString("yyyy-MM-dd") + "' and ltd.IsVerified=1 ");

            if (LabNo != "")
            {
                sb.Append("  AND pli.LedgerTransactionNo = '" + LabNo + "'");
            }
            if (IPDNO != "")
            {
                sb.Append(" AND pli.TransactionID='ISHHI" + IPDNO + "'");
            }
            sb.Append(" GROUP BY im.Name ");
            
        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            
            return "1";
    }

    [WebMethod(EnableSession = true)]
    public static string UpdateTiming(object dataMed, string dept)
    {
        int check = 0;
        int count = 0; int chkCon = 0;
        string MedicineID = string.Empty;
        string Query = string.Empty;
        List<OutSourceMed> list = new System.Web.Script.Serialization.JavaScriptSerializer().ConvertToType<List<OutSourceMed>>(dataMed);
        count = list.Count;
        DataTable dt = new DataTable();
        DataColumn dc = new DataColumn("sNo", typeof(String));
        dt.Columns.Add(dc);
        DataColumn dc1 = new DataColumn("Title", typeof(String));
        dt.Columns.Add(dc1);
        for (int i = 0; i < list.Count; i++)
        {
            string admitDateTime = list[i].dateOfAdmit + " " + list[i].timeOfAdmit;
            string reqDateTime = list[i].SampleDate + " " + list[i].SampleTime;
            string sampleDateTime = list[i].ResultEnteredDate + " " + list[i].ResultEnteredTime;
            string approvedDateTime = list[i].ApprovedDate + " " + list[i].ApprovedTime;
            string dischargeDateTime = list[i].dateOfDischarge + " " + list[i].timeOfDischarge;

            DateTime dtAdmitDateTime = Util.GetDateTime(admitDateTime);
            DateTime dtreqDateTime = Util.GetDateTime(reqDateTime);
            DateTime dtSampleDateTime = Util.GetDateTime(sampleDateTime);
            DateTime dtApprovedDateTime = Util.GetDateTime(approvedDateTime);
            DateTime dtDischargeDateTime = Util.GetDateTime(dischargeDateTime);

            if ((dept == "1") && (dtreqDateTime < dtAdmitDateTime || dtSampleDateTime < dtAdmitDateTime || dtApprovedDateTime < dtAdmitDateTime))
            {
                chkCon++;              
                DataRow dr = dt.NewRow();
                dr[0] = list[i].sNo;
                dr[1] = "Patient Admission Date Time" + Util.GetDateTime(dtAdmitDateTime).ToString("dd-MMM-yyyy hh:mm tt");
                dt.Rows.Add(dr);
            }
          //  else if ((dept == "1") && (dtDischargeDateTime < dtreqDateTime || dtDischargeDateTime < dtSampleDateTime || dtDischargeDateTime < dtApprovedDateTime))
         //   {
          //      chkCon++;
          //      DataRow dr = dt.NewRow();
         //       dr[0] = list[i].sNo;
         //       dr[1] = "Patient Discharge Date Time " + Util.GetDateTime(dtDischargeDateTime).ToString("dd-MMM-yyyy hh:mm tt");

        //        dt.Rows.Add(dr);
        //    }
            else if (dtSampleDateTime < dtreqDateTime || dtApprovedDateTime < dtSampleDateTime || dtreqDateTime > dtApprovedDateTime)
            {
                chkCon++;
                DataRow dr = dt.NewRow();
                dr[0] = list[i].sNo;
                dr[1] = "Req. Date Time OR Sample Date Time OR Reporting Date Problem";

                dt.Rows.Add(dr);
            }
        }

        if(chkCon>0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
       
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (dept == "0")
            {
                for (int i = 0; i < list.Count; i++)
                {

                 //   Query = "UPDATE patient_labinvestigation_opd SET SampleReceiveDate ='" + Util.GetDateTime(list[i].ResultEnteredDate + " " + list[i].ResultEnteredTime).ToString("yyyy-MM-dd HH:mm:ss") + "',Date='" + Util.GetDateTime(list[i].SampleDate).ToString("yyyy-MM-dd") + "',Time='" + Util.GetDateTime(list[i].SampleTime).ToString("HH:mm:ss") + "',ApprovedDate='" + Util.GetDateTime(list[i].ApprovedDate + " " + list[i].ApprovedTime).ToString("yyyy-MM-dd HH:mm:ss") + "' WHERE LedgertransactionNo='" + list[i].LedgertransactionNo + "' and Investigation_Id = '" + list[i].Investigation_Id + "'";
                    Query = "UPDATE patient_labinvestigation_opd SET SampleReceiveDate ='" + Util.GetDateTime(list[i].SampleDate + " " + list[i].SampleTime).ToString("yyyy-MM-dd HH:mm:ss") + "',Date='" + Util.GetDateTime(list[i].SampleDate).ToString("yyyy-MM-dd") + "',Time='" + Util.GetDateTime(list[i].SampleTime).ToString("HH:mm:ss") + "',ResultEnteredDate='" + Util.GetDateTime(list[i].ResultEnteredDate + " " + list[i].ResultEnteredTime).ToString("yyyy-MM-dd HH:mm:ss")+"',ApprovedDate='" + Util.GetDateTime(list[i].ApprovedDate + " " + list[i].ApprovedTime).ToString("yyyy-MM-dd HH:mm:ss") + "' WHERE LedgertransactionNo='" + list[i].LedgertransactionNo + "' and Investigation_Id = '" + list[i].Investigation_Id + "'";
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, Query);
                    check++;

                }
            }
            else
            {
                for (int i = 0; i < list.Count; i++)
                {
                    Query = "UPDATE patient_labinvestigation_opd SET SampleReceiveDate ='" + Util.GetDateTime(list[i].SampleDate + " " + list[i].SampleTime).ToString("yyyy-MM-dd HH:mm:ss") + "',Date='" + Util.GetDateTime(list[i].SampleDate).ToString("yyyy-MM-dd") + "',Time='" + Util.GetDateTime(list[i].SampleTime).ToString("HH:mm:ss") + "',ResultEnteredDate='" + Util.GetDateTime(list[i].ResultEnteredDate + " " + list[i].ResultEnteredTime).ToString("yyyy-MM-dd HH:mm:ss") + "',ApprovedDate='" + Util.GetDateTime(list[i].ApprovedDate + " " + list[i].ApprovedTime).ToString("yyyy-MM-dd HH:mm:ss") + "' WHERE LedgertransactionNo='" + list[i].LedgertransactionNo + "' and Investigation_Id = '" + list[i].Investigation_Id + "'";
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, Query);
                    string sammpleDateTime = Util.GetDateTime(list[i].SampleDate).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(list[i].SampleTime).ToString("HH:mm:ss");
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE f_ledgertnxdetail SET EntryDate='" + sammpleDateTime + "' WHERE ID='" + list[i].LedgertnxID + "' ");
                    check++;

                }
            }


            Tranx.Commit();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            if (count > 0)
            {
                if (check == count)
                {
                    return "1";
                }
                return "1";
            }
            else
            {
                return "2";
            }

        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }

    }

}


class OutSourceMed
{
    private string _Investigation_Id;
    private string _LedgertransactionNo;
    private string _SampleDate;
    private string _SampleTime;
    private string _ResultEnteredDate;
    private string _ResultEnteredTime;
    private string _ApprovedDate;
    private string _ApprovedTime;

    private string _dateOfAdmit;
    private string _timeOfAdmit;
    private string _dateOfDischarge;
    private string _timeOfDischarge;
    private int _sNo;
    private string _LedgertnxID;
    public string Investigation_Id
    {
        get { return _Investigation_Id; }
        set { _Investigation_Id = value; }
    }

    public string LedgertransactionNo
    {
        get { return _LedgertransactionNo; }
        set { _LedgertransactionNo = value; }
    }

    public string SampleDate
    {
        get { return _SampleDate; }
        set { _SampleDate = value; }
    }

    public string SampleTime
    {
        get { return _SampleTime; }
        set { _SampleTime = value; }
    }

    public string ResultEnteredDate
    {
        get { return _ResultEnteredDate; }
        set { _ResultEnteredDate = value; }
    }

    public string ResultEnteredTime
    {
        get { return _ResultEnteredTime; }
        set { _ResultEnteredTime = value; }
    }

    public string ApprovedDate
    {
        get { return _ApprovedDate; }
        set { _ApprovedDate = value; }
    }

    public string ApprovedTime
    {
        get { return _ApprovedTime; }
        set { _ApprovedTime = value; }
    }
    public string dateOfAdmit
    {
        get { return _dateOfAdmit; }
        set { _dateOfAdmit = value; }
    }
    public string timeOfAdmit
    {
        get { return _timeOfAdmit; }
        set { _timeOfAdmit = value; }
    }
    public string dateOfDischarge
    {
        get { return _dateOfDischarge; }
        set { _dateOfDischarge = value; }
    }
    public string timeOfDischarge
    {
        get { return _timeOfDischarge; }
        set { _timeOfDischarge = value; }
    }
    public int sNo
    {
        get { return _sNo; }
        set { _sNo = value; }
    }
    public string LedgertnxID
    {
        get { return _LedgertnxID; }
        set { _LedgertnxID = value; }
    }
    
}