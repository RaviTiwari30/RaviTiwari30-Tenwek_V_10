using MySql.Data.MySqlClient;
using System.Security.Cryptography;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;
using SD = System.Drawing;
using System.Drawing.Imaging;
using System.Drawing.Drawing2D;
using System.Linq;
using System.IO;
using System.Globalization;
using System.Threading;
using Resources;
using System.Xml;


public partial class Design_Lab_OnlineRadiologyResultEntry : System.Web.UI.Page
{
    public static string isvalid { get; set; }
    public static string EncryptPassword(string text)
    {
        MD5 md5 = new MD5CryptoServiceProvider();
        md5.ComputeHash(ASCIIEncoding.ASCII.GetBytes(text));
        byte[] result = md5.Hash;
        StringBuilder strBuilder = new StringBuilder();
        for (int i = 0; i < result.Length; i++)
        {
            strBuilder.Append(result[i].ToString("x2"));
        }
        return strBuilder.ToString();
    }
    

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            All_LoadData.bindCenterDropDownList(ddlCenterMaster, "select", "");
            txtUserName.Focus();
            isvalid = "1";
            // isuhid = "1";

            txtUHID.Text = "";
        }
        else
        {
            //isuhid = "0";
            isvalid = "0";
        }


    }
    private static void DLC_Check(List<ResultEntryProperty> data, string ResultStatus)
    {
        float DLC = 0f;
        float Semen = 0f;
        string test = "";
        string test1 = "";
        int atfile = 0;
        int _isBloodGroup = 0;
        int crNo = 0;
        XmlDocument loResource = new XmlDocument();
        loResource.Load(HttpContext.Current.Server.MapPath("App_LocalResources/MachineResultEntry.aspx.resx"));
        foreach (ResultEntryProperty pdeatil in data)
        {
            crNo = crNo + 1;
            string[] DLC_ObervationIDs = loResource.SelectSingleNode("root/data[@name='DLC_ObervationIDs']/value").InnerText.ToString().Split(",".ToCharArray(), StringSplitOptions.RemoveEmptyEntries);
            if (DLC_ObervationIDs.Contains(pdeatil.LabInvestigation_ID))
            {
                DLC = DLC + Util.GetFloat(pdeatil.Value);
                test = test + ", " + pdeatil.LabObservationName;
            }
            string[] Semen_ObservationIDs = loResource.SelectSingleNode("root/data[@name='Semen_ObservationIDs']/value").InnerText.ToString().Split(",".ToCharArray(), StringSplitOptions.RemoveEmptyEntries);
            if (Semen_ObservationIDs.Contains(pdeatil.LabInvestigation_ID))// semen report
            {
                Semen = Semen + Util.GetFloat(pdeatil.Value);
                test1 = test1 + ", " + pdeatil.LabObservationName;
            }
            if (pdeatil.LabObservationName == "Attached Report")
            {
                atfile = 1;
            }
            if ((pdeatil.ResultRequired == "1") && (pdeatil.Value == "") && (ResultStatus == "Approved") && (pdeatil.Method != "1") && (atfile == 0))
                throw (new Exception("All parameter needs to be filled before approval."));
            if (pdeatil.Investigation_ID == "25")
            {
                _isBloodGroup = 1;
            }

            double o;
            if ((pdeatil.Value != string.Empty) && (pdeatil.IsCritical == "1") && (ResultStatus == "Approved" || ResultStatus == "Save"))
            {
                // bool aa = double.TryParse(pdeatil.Value.Trim(), out o);
                if (double.TryParse(pdeatil.Value.Trim(), out o) && Util.GetString(pdeatil.AbnormalValue) == "")
                {
                    if (Util.GetDouble(pdeatil.Value.Trim()) <= Util.GetDouble(pdeatil.MinCritical) || Util.GetDouble(pdeatil.Value.Trim()) >= Util.GetDouble(pdeatil.MaxCritical))
                    {
                        if (Util.GetInt(pdeatil.isrerun) == 0 && Util.GetString(pdeatil.MacReading) != "" && Util.GetString(pdeatil.Reading1) == "")
                            throw (new Exception("Please Rerun " + pdeatil.LabObservationName + " to proceed further"));
                    }
                }
                else if (Util.GetString(pdeatil.AbnormalValue) != "" && Util.GetString(pdeatil.AbnormalValue) == pdeatil.Value.Trim())
                {
                    if (Util.GetInt(pdeatil.isrerun) == 0 && Util.GetString(pdeatil.MacReading) != "" && Util.GetString(pdeatil.Reading1) == "")
                        throw (new Exception("Please Rerun " + pdeatil.LabObservationName + " to proceed further"));
                }
            }
            if ((pdeatil.Value != string.Empty) && Util.GetInt(pdeatil.pliIsReRun) == 1 && (pdeatil.IsCritical == "1") && (pdeatil.MacReading == "") && (pdeatil.Reading1 != "") && (ResultStatus == "Approved" || ResultStatus == "Save"))
            {
                if (double.TryParse(pdeatil.Value.Trim(), out o) && Util.GetString(pdeatil.AbnormalValue) == "")
                {
                    if (Util.GetDouble(pdeatil.Value.Trim()) <= Util.GetDouble(pdeatil.MinCritical) || Util.GetDouble(pdeatil.Value.Trim()) >= Util.GetDouble(pdeatil.MaxCritical))
                    {
                        throw (new Exception("Please Rerun " + pdeatil.LabObservationName + " to machine for proceed further"));
                    }
                }
                else if (Util.GetString(pdeatil.AbnormalValue) != "" && Util.GetString(pdeatil.AbnormalValue) == pdeatil.Value.Trim())
                {
                    throw (new Exception("Please Rerun " + pdeatil.LabObservationName + " to machine for proceed further"));
                }
            }
            if ((pdeatil.Value != string.Empty) && (pdeatil.IsCritical == "1") && (Util.GetString(pdeatil.Value1) == "") && (Util.GetString(pdeatil.MacReading) == "") && (Util.GetString(pdeatil.Reading1) == "") && (ResultStatus == "Approved" || ResultStatus == "Save"))
            {
                if (double.TryParse(pdeatil.Value.Trim(), out o) && Util.GetString(pdeatil.AbnormalValue) == "")
                {
                    if (Util.GetDouble(pdeatil.Value.Trim()) <= Util.GetDouble(pdeatil.MinCritical) || Util.GetDouble(pdeatil.Value.Trim()) >= Util.GetDouble(pdeatil.MaxCritical))
                    {
                        throw (new Exception("ManualCritical|" + pdeatil.LabObservationName + '|' + pdeatil.Value.Trim() + '|' + pdeatil.Test_ID + '|' + pdeatil.LabObservation_ID + '|' + crNo + '|' + pdeatil.ManualValue));
                    }
                }
                else if (Util.GetString(pdeatil.AbnormalValue) != "" && Util.GetString(pdeatil.AbnormalValue) == pdeatil.Value.Trim())
                {
                    throw (new Exception("ManualCritical|" + pdeatil.LabObservationName + '|' + pdeatil.Value.Trim() + '|' + pdeatil.Test_ID + '|' + pdeatil.LabObservation_ID + '|' + crNo + '|' + pdeatil.ManualValue));
                }
            }

        }
        if (_isBloodGroup == 1)
        {
            var bloodGroupCount = data.Count(x => x.Investigation_ID == "25" && Util.GetString(x.Value) == "");
            var Is_BLOODGROUPTYPE_Blank = data.Count(x => x.Investigation_ID == "25" && Util.GetString(x.Value) == "" && Util.GetString(x.MacReading) == "" && x.LabObservation_ID == "933");
            var Is_RhTYPE_Blank = data.Count(x => x.Investigation_ID == "25" && Util.GetString(x.Value) == "" && Util.GetString(x.MacReading) == "" && x.LabObservation_ID == "934");
            if ((bloodGroupCount != 8) && (Is_BLOODGROUPTYPE_Blank == 1 || Is_RhTYPE_Blank == 1))
            {
                throw (new Exception("Please Enter Correct Format For Blood Group"));
            }
        }
        test = test.Trim(',');
        test1 = test1.Trim(',');
        //if (Util.GetFloat(data[0].AgeInDays) > 4745)
        //{
        if ((DLC > 0) && (Convert.ToInt32(DLC) != 100))
            throw (new Exception("Total " + test + " should be equal to 100."));

        if ((Semen > 0) && (Semen != 100))
            throw (new Exception("Total " + test1 + " should be equal to 100."));
        //}
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveLabObservationOpdData(string testid, string reporttype, string description, string findingvalue, string method)
    {


        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            if ((reporttype == "3" || reporttype == "5") && reporttype != null)
            {
                string htmltext = (description == null) ? "" : description;
                string plaintext = System.Text.RegularExpressions.Regex.Replace(htmltext.Trim(), @"<[^>]+>|&nbsp;|\n|\t", "").Trim();
                int AddReportQty = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) FROM patient_labinvestigation_attachment_report WHERE Test_ID =@Test_ID ", new MySqlParameter("@Test_ID", testid)));
                int IsAvailText = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) FROM patient_labobservation_opd_text WHERE Test_ID =@Test_ID ", new MySqlParameter("@Test_ID", testid)));
                if ((reporttype == "3" || reporttype == "5") && reporttype != null && plaintext.Trim() == "" && AddReportQty == 0 && IsAvailText == 0)
                {
                    Exception ex = new Exception(" value can't be blank.....!");
                    throw (ex);
                }
            }
            if (method == "1")
            {
                MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "DELETE FROM patient_labobservation_opd_text WHERE `Test_ID`=@Test_ID",
                new MySqlParameter("@Test_ID", testid));
                StringBuilder myStr = new StringBuilder();
                myStr.Append("INSERT INTO `patient_labobservation_opd_text`(`Test_ID`,`LabInves_Description`,`EntDate`,UserID,FindingText) ");
                myStr.Append(" VALUES(@Test_ID,@LabInves_Description,@EntDate,@UserID,@FindingValue)");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, myStr.ToString(),
                    new MySqlParameter("@Test_ID", testid),
                    new MySqlParameter("@LabInves_Description", description),
                    new MySqlParameter("@EntDate", DateTime.Now),
                    new MySqlParameter("@UserID", HttpContext.Current.Session["ID"].ToString()),
                    new MySqlParameter("@FindingValue", findingvalue));
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET Approved = @Approved, isForward = @isForward, isPrint = @isPrint WHERE Test_ID=@Test_ID AND isSampleCollected=@isSampleCollected",
                                new MySqlParameter("@Approved", "0"), new MySqlParameter("@isForward", "0"), new MySqlParameter("@isPrint", "0"),
                                new MySqlParameter("@Test_ID", testid),
                                new MySqlParameter("@isSampleCollected", 'Y'));
                string str = "update patient_labinvestigation_opd set  ResultEnteredBy=if(Result_Flag=0,'" + HttpContext.Current.Session["ID"].ToString() + "',ResultEnteredBy),ResultEnteredDate=if(Result_Flag=0,NOW(),ResultEnteredDate),ResultEnteredName=if(Result_Flag=0,'" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "',ResultEnteredName),Result_Flag=1 ";
                str += " where test_id='" + testid + "'  and isSampleCollected='Y' and approved=0 ";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

            }

            tnx.Commit();
            tnx.Dispose();
            con.Close();
            con.Dispose();

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);
            throw (ex);
        }
        return "success";
    }


    protected void btnCancel_Click(object sender, EventArgs e)
    {
        txtUserName.Text = string.Empty;
        txtPassword.Text = string.Empty;
        isvalid = "1";
    }
    [WebMethod]
    public static string GetDescription(string testid)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT * FROM patient_labobservation_opd_text where Test_ID='" + testid + "'");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                return dt.Rows[0]["LabInves_Description"].ToString();


            }
            else
            {
                return "0";
            }
        }
        catch (Exception ex)
        {
            return "0";
        }
    }
    protected void grdLabSearch_RowDataBound(object sender, GridViewRowEventArgs e)
    {

        if (e.Row.RowType == DataControlRowType.DataRow)
        {

            string color = ((Label)e.Row.FindControl("lblStatus")).Text;

            e.Row.CssClass = color;
            string color1 = ((Label)e.Row.FindControl("lblStatus1")).Text;

            e.Row.CssClass = color1;
        }
    }

    [WebMethod]
    public static string UserLogin(string center, string username, string password)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string Password = EncryptPassword(password);
            DataTable dt = StockReports.GetDataTable("CALL f_login('" + center + "','" + username + "','" + Password + "')");
            if (dt.Rows.Count > 0)
            {

                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE online_employee set isActive=0 where EmployeeID='" + Util.GetString(dt.Rows[0]["EmployeeID"]) + "' and isActive=1");
                string GlobalId = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT MD5(CONCAT('" + Util.GetString(dt.Rows[0]["EmployeeID"]) + "',NOW(),RAND(25000))) AS GlobalId"));
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "INSERT into online_employee(SessionId,EmployeeID) values('" + GlobalId + "','" + Util.GetString(dt.Rows[0]["EmployeeID"]) + "') ");

                con.Close();
                con.Dispose();
                isvalid = "0";

                return "1";
            }
            else
            {
                isvalid = "1";
                return "0";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            isvalid = "1";
            return "0";
        }
        finally {
            con.Close();
            con.Dispose();
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        Search();
    }
    private void Search()
    {
        lblMsg.Text = "";
        StringBuilder sbQuery = new StringBuilder();
        sbQuery.Append(" select *,IF(tt.Status='Approved','view','Select') Status1,tt.Test_ID  from ( ");
        sbQuery.Append("  SELECT IF(pli.Type=2,'IPD',IF(pli.Type=1,'OPD','EMG'))PatientType, im.ReportType,im.Name InvestigationName,''srno,sum(pli.IsTestRerun) isrerun, '' CombinationSampleDept,'' ReferLab,pli.Approved, ");
        sbQuery.Append("  DATE_FORMAT(IF(im.ReportType = 5,pli.SampleReceiveDate,pli.sampledate), '%d-%b-%y %H:%i') DATE,pli.LedgerTransactionNo,'' SampleLocation,'' CombinationSample,pm.`PName`,CONCAT(pm.`Age`,'/',pm.`Gender`) Age_Gender,pm.`Gender`,lt.PatientID,");
        sbQuery.Append(" CONCAT(dm.Title,'',dm.Name) AS  Doctor,cm.CentreName Centre,pli.`BarcodeNo`, fpm.Company_Name panelname,  GROUP_CONCAT(distinct  im.Name) AS Test, ");

        sbQuery.Append(" if(im.ReportType=1,(select CAST(GROUP_CONCAT(distinct tt.Test_ID)AS CHAR)Test_ID  from   patient_labinvestigation_opd tt where tt.`LedgerTransactionNo`= pli.LedgerTransactionNo AND tt.ReportType=1),pli.Test_ID)Test_ID ");

        sbQuery.Append(" ,IF(pm.DOB = '0001-01-01', (CASE WHEN pli.CurrentAge LIKE '%DAY%' THEN ((TRIM(REPLACE(pli.CurrentAge,'DAY(S)',''))+0)) WHEN pli.CurrentAge ");
        sbQuery.Append(" LIKE '%MONTH%' THEN ((TRIM(REPLACE(pli.CurrentAge,'MONTH(S)',''))+0)*30) ");
        sbQuery.Append(" ELSE ((TRIM(REPLACE(pli.CurrentAge,'YRS',''))+0)*365) END),DATEDIFF(NOW(),pm.DOB)) AGE_in_Days ");
        sbQuery.Append(" ,IFNULL((SELECT Remarks FROM patient_labinvestigation_opd_remarks plor WHERE plor.Test_ID =pli.Test_ID And IsActive=1 ORDER BY ID DESC LIMIT 1 ),'')RemarkStatus");
        sbQuery.Append(" ,(SELECT LedgertransactionNo FROM patient_labinvestigation_attachment WHERE LedgertransactionNo=pli.LedgerTransactionNo LIMIT 1)DocumentStatus ");
        sbQuery.Append(" ,IF(pli.`DeliveryDate`='0001-01-01 00:00:00','0',IF( IF(pli.Approved=0,NOW(),pli.ApprovedDate) > pli.DeliveryDate,'1','0')) TATDelay,TIMESTAMPDIFF(SECOND,pli.DeliveryDate,IF(pli.Approved=0,NOW(),pli.ApprovedDate))TatDelayinSecond,IF(pli.isurgent = 1,'Y','N')Urgent");
        sbQuery.Append(" ,IF(pli.`DeliveryDate`='0001-01-01 00:00:00','0',IF( IF(pli.Approved=0,NOW(),pli.ApprovedDate) > DATE_ADD(pli.DeliveryDate ,INTERVAL 60*-1 MINUTE),'1','0')) TATIntimate");
        sbQuery.Append(" ,CASE ");
        sbQuery.Append(" WHEN COUNT(pli.isPrint)=SUM(pli.isPrint) THEN 'Printed' ");
        sbQuery.Append(" WHEN COUNT(pli.Approved)=SUM(pli.Approved) THEN 'Approved' ");
        sbQuery.Append(" WHEN COUNT(pli.isHold)=SUM(pli.isHold) THEN 'Hold' ");
        sbQuery.Append("   WHEN COUNT(pli.Result_Flag)=SUM(pli.Result_Flag)  and   SUM(pli.isForward*pli.Result_Flag)=0 THEN 'Tested' ");
        sbQuery.Append("   WHEN COUNT(pli.isForward)=SUM(pli.isForward) THEN  'Forwarded' ");
        sbQuery.Append("   WHEN (select count(1) from mac_Data where reading<>'' and Test_ID=pli.Test_ID and `centreid`=pli.sampleTransferCentreID)>0 and pli.Result_Flag=0 THEN 'MacData' ");
        sbQuery.Append("  WHEN COUNT(pli.isSampleCollected)=SUM(IF(pli.isSampleCollected='N',1,0)) THEN  'Not-Collected' ");
        sbQuery.Append("   WHEN COUNT(pli.isSampleCollected)=SUM(IF(pli.isSampleCollected='S',1,0)) THEN 'Collected' ");
        sbQuery.Append("  WHEN COUNT(pli.isSampleCollected)=SUM(IF(pli.isSampleCollected='Y',1,0)) THEN 'Received' ");
        sbQuery.Append("  WHEN COUNT(pli.isSampleCollected)=SUM(IF(pli.isSampleCollected='R',1,0)) THEN 'Rejected' ");
        sbQuery.Append("  ELSE 'NA'  ");
        sbQuery.Append("  END `Status` ");
        sbQuery.Append(" ,'' Comments, ");
        sbQuery.Append(" IF (pli.SCRequestdatetime='0001-01-01 00:00:00','', DATE_FORMAT(pli.SCRequestdatetime,'%d-%b-%y %l:%i %p'))Samplerequestdate, ");
        sbQuery.Append(" IF(pli.IsSampleCollected='N','',DATE_FORMAT(pli.SampleDate,'%d-%b-%y %l:%i %p'))Acutalwithdrawdate, ");
        sbQuery.Append(" IF(pli.SCRequestdatetime='0001-01-01 00:00:00' ,'',IF(pli.IsSampleCollected='N','', ");
        sbQuery.Append(" TIME_FORMAT(TIMEDIFF(pli.SampleDate,pli.SCRequestdatetime),'%H Hr %i M ')))DevationTime ");
        sbQuery.Append(" ,IF(pli.`DeliveryDate`='0000-00-00 00:00:00' OR pli.`DeliveryDate`='0001-01-01 00:00:00','',TIME_FORMAT(TIMEDIFF(pli.`DeliveryDate`,IF(pli.Approved=0,NOW(),pli.ApprovedDate)),'%H Hr %i M '))TimeDiff ,IF(pli.Type=2,pmh.TransNo,'')IPDNo,DATE_FORMAT(ltd.EntryDate, '%d-%b-%y')BillDate");
        sbQuery.Append(" FROM ");
        sbQuery.Append(" `patient_labinvestigation_opd` pli ");

        sbQuery.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.LedgerTransactionNo=pli.LedgerTransactionNo AND lt.`IsCancel`=0   ");
        sbQuery.Append("INNER JOIN f_ledgertnxdetail ltd ON ltd.ID=pli.LedgertnxID AND ltd.IsVerified<>2    ");
        sbQuery.Append(" INNER JOIN patient_master pm ON pm.PatientID=lt.PatientID INNER JOIN doctor_master dm ON dm.DoctorID=pli.DoctorID INNER JOIN f_panel_master fpm ON fpm.PanelID=lt.PanelID ");
        sbQuery.Append(" INNER JOIN `investigation_master` im ON im.investigation_ID=pli.investigation_ID and im.isCulture=0 and im.ReportType<>7    ");
        sbQuery.Append(" INNER JOIN center_master cm ON cm.`CentreID`=lt.`CentreID` ");
        sbQuery.Append("  inner join investigation_observationtype iot on iot.Investigation_ID=pli.Investigation_ID  ");
        sbQuery.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID ");
        sbQuery.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = iot.ObservationType_ID  ");
        sbQuery.Append(" INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID = ltd.SubCategoryID ");
        sbQuery.Append(" and pli.sampleTransferCentreID ='" + HttpContext.Current.Session["CentreID"].ToString() + "' ");
        //sbQuery.Append(" AND IF(im.ReportType = 5,pli.P_IN=1,pli.P_IN=0 ) ");
        sbQuery.Append(" AND IF(im.ReportType = 5,pli.P_IN=1,pli.P_IN=0 ) and pm.PatientID='" + txtUHID.Text + "'");
        sbQuery.Append(" where sm.CategoryID=7 GROUP BY pli.Test_ID ");
        sbQuery.Append(" ");
        sbQuery.Append(" )tt where tt.Status not in('Rejected','Collected','Not-Collected','MacData')");


        DataTable dtInvest = StockReports.GetDataTable(sbQuery.ToString());
        if (dtInvest != null && dtInvest.Rows.Count > 0)
        {
            ViewState["dtInvest"] = dtInvest;

            grdLabSearch.DataSource = dtInvest;
            grdLabSearch.DataBind();
            pnlHide.Visible = true;
        }
        else
        {
            grdLabSearch.DataSource = null;
            grdLabSearch.DataBind();
            pnlHide.Visible = false;
            lblMsg.Text = "Record not found.";

        }
    }

}