using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for MailStatus
/// </summary>
public class MailStatus
{
    public MailStatus()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public DataTable Search_Mail(string LabNo, string MRNo,string PName, string CentreID, string FromDate, string ToDate, string Dept, string Status,
                                 string ContactNo, string ReferBy, string Ptype, string FromLabNo, string ToLabNo, string PanelID, string InputType)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select drr.email DoctorEmailId , '' as ReportDate,'OPD' Type,im.Name ObservationName,io.ObservationType_Id, im.Investigation_Id,PM.PatientID, Replace(PM.PatientID,'LSHHI','')PID,PM.pname,CONCAT(pm.age,'/',LEFT(pm.gender,1)) age,pm.gender,");
        sb.Append(" fpm.EmailID AS PanelMailID,fpm.Company_Name as PanelName,pm.Email as PatientMailID,concat(pm.House_No,pm.Street_Name,pm.Locality,pm.City,pm.Pincode)Address, ");
        sb.Append(" pli.TransactionID,pli.Test_ID,pli.LedgerTransactionNo,REPLACE(pli.LedgerTransactionNo,'LOSHHI','1')LTD,im.Name,pmh.CardNo,pmh.PanelID as PanelID");
        sb.Append(" ,if(PLI.Result_Flag = 0,'false','true')IsResult,date_format(pli.date,'%d-%b-%y')InDate,pli.Approved,if(pli.Approved='1','True','False') chkWork,pli.Time, ");
        sb.Append(" if(PLI.IsSampleCollected = 'Y','YES','NO')IsSample,pli.SampleDate,obm.Name as Dept,IM.ReportType,CASE   WHEN pli.Approved='1' And er.isSent is null THEN '#90EE90' WHEN pli.Approved='1' And er.isSent='0' THEN '#FFC0CB' WHEN pli.Approved='1' And er.isSent='1' THEN '#3399FF' when er.isSent='-1' THEN '#E2680A'   ELSE '#FFFFFF' END rowColor  ");
        sb.Append(" FROM patient_labinvestigation_opd pli  ");
        sb.Append(" INNER JOIN f_ledgertransaction lt on lt.LedgerTransactionNo=pli.LedgerTransactionNo  AND lt.IsCancel=0 AND IsSampleCollected='Y' ");
        if (FromDate != string.Empty)
            sb.Append(" AND Date(PLI.ApprovedDate) >='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "'");

        if (ToDate != string.Empty)
            sb.Append(" AND Date(PLI.ApprovedDate) <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'");


        if (FromLabNo != string.Empty)
            sb.Append(" AND PLI.LedgerTransactionNo >= '" + FromLabNo.Trim() + "'");
        if (FromLabNo != string.Empty && ToLabNo != string.Empty)
            sb.Append(" AND PLI.LedgerTransactionNo >= '" + FromLabNo.Trim() + "' AND pLI.LedgerTransactionNo <= '" + ToLabNo.Trim() + "' ");

        if (LabNo != string.Empty)
            sb.Append(" AND PLI.LedgerTransactionNo Like '%" + LabNo.Trim() + "'");
        if (Status == "1")
            sb.Append(" AND pli.Approved=1");
        if (CentreID != "0")
            sb.Append(" AND lt.CentreID=" + CentreID + " ");
        if (Ptype == "1")
            sb.Append(" AND lt.PatientType='Urgent' ");

        sb.Append(" INNER JOIN patient_medical_history pmh on pmh.TransactionID = lt.TransactionID       ");
        if (PanelID != "0")
            sb.Append(" AND pmh.PanelID = " + PanelID + " ");
        sb.Append(" INNER JOIN  patient_master PM on lt.PatientID = PM.PatientID  ");
        if (MRNo != string.Empty)
            sb.Append(" AND PM.PatientID='" + MRNo.Trim() + "'");

        if (PName != string.Empty)
            sb.Append(" AND PM.PName like '" + PName.Trim() + "%'");
        if (ContactNo.Trim() != "")
            sb.Append(" and PM.Mobile like '" + ContactNo.Trim() + "%'");

        if (ReferBy != "0")
            sb.Append(" AND pmh.ReferedBy='" + ReferBy + "' ");

        sb.Append(" INNER JOIN investigation_master im on pli.Investigation_ID = im.Investigation_Id ");
        sb.Append(" INNER JOIN f_panel_master fpm ON fpm.PanelID = pmh.PanelID        ");
        sb.Append(" INNER JOIN doctor_master drr ON drr.DoctorID = pmh.DoctorID        ");
        sb.Append(" INNER JOIN investigation_observationtype io ON im.Investigation_Id = io.Investigation_ID ");
        if (Dept != "0")
            sb.Append(" and io.ObservationType_ID='" + Dept + "'");
        sb.Append(" INNER JOIN observationtype_master obm ON obm.ObservationType_ID=io.ObservationType_Id  ");
        sb.Append(" Left JOIN email_record er on er.Test_ID=pli.Test_ID AND er.`LedgerTransactionNo`=pli.`LedgerTransactionNo`");
        sb.Append(" order by lt.LedgerTransactionNo,obm.Name,im.Print_Sequence ");


        DataTable dtItem = StockReports.GetDataTable(sb.ToString());
        return dtItem;
    }

    public string SendMail(string PanelID, string TestID, string PHead, string LoginType)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {

            TestID = TestID.TrimEnd('#');
            int len = Util.GetInt(TestID.Split('#').Length);
            string[] Data = new string[len];
            Data = TestID.Split('#');
            string EmailId = "";
            int ispanel;
            int isHeader;
            for (int i = 0; i < len; i++)
            {

                PanelID = Data[i].Split('|')[0].ToString();
                EmailId = Data[i].Split('|')[3].ToString();
                ispanel = Util.GetInt(Data[i].Split('|')[2]);
                isHeader = Util.GetInt(PHead);
               
                string str = "INSERT INTO email_record(LedgerTransactionNo,Test_ID,EmployeeID,EmailAddress,isPanel,isHeader,pname,testname,enterby) values(" + PanelID + ",'" + Data[i].Split('|')[1].ToString() + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + EmailId + "','" + ispanel + "'," + isHeader + ",'" + Data[i].Split('|')[4].ToString() + "','" + Data[i].Split('|')[5].ToString() + "','" + HttpContext.Current.Session["LoginName"].ToString() + "')";
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            }
            Tranx.Commit();
            return "1";
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


    public string SendMailNow(string TestID, string EmailID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            //PanleId/LabNo|TestID|isPanel|EmailID
            string[] Data = TestID.Split(',');
            string MessageID = Util.getHash();
            for (int i = 0; i < Data.Length; i++)
            {
                if (Data[i].Trim() != "")
                {
                    string str = "";
                    DataTable dt = StockReports.GetDataTable(" SELECT DISTINCT pm.PName, im.Name TestName FROM (SELECT * FROM  patient_labinvestigation_opd WHERE `Test_ID`='" + Data[i].ToString() + "') plo       INNER JOIN `patient_master` pm ON plo.PatientID = pm.PatientID       INNER JOIN investigation_master im ON im.investigation_id = plo.investigation_id  ");
                    if (dt.Rows.Count > 0)
                    {
                        str = "insert into email_record(LedgerTransactionNo,Test_ID,EmployeeID,EmailAddress,isPanel,isHeader, PName, TestName)  ";
                        str += " SELECT plo.LedgerTransactionNo,plo.Test_ID, '" + HttpContext.Current.Session["ID"].ToString() + "'EmployeeID,'" + EmailID + "'EmailAddress,0 isPanel,0 isHeader, pm.PName PName , im.Name TestName FROM (SELECT * FROM  patient_labinvestigation_opd WHERE `Test_ID`='" + Data[i].ToString() + "') plo       INNER JOIN `patient_master` pm ON plo.PatientID = pm.PatientID INNER JOIN investigation_master im ON im.investigation_id = plo.investigation_id ";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
                    }
                }
            }

            Tranx.Commit();

            return "1";
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
