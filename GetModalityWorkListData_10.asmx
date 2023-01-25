<%@ WebService Language="C#" Class="GetModalityWorkListData" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using System.Collections.Generic;
using System.Web.Script;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Text;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
public class GetModalityWorkListData : System.Web.Services.WebService
{

    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public List<TestList> GetModalityWorkList(string modalityName, DateTime FromDate, DateTime ToDate)
    {

        StydyInsctanceUID styUID = new StydyInsctanceUID();
        List<TestList> PatientList = new List<TestList>();

        DataTable dt = new DataTable("dtData");

        dt.Columns.Add("PatientName", typeof(string));
        dt.Columns.Add("PatientID", typeof(string));
        dt.Columns.Add("Age", typeof(string));
        dt.Columns.Add("DOB", typeof(DateTime));
        dt.Columns.Add("SEX", typeof(string));
        dt.Columns.Add("ReferDoctor", typeof(string));
        dt.Columns.Add("AccessionNumber", typeof(string));
        dt.Columns.Add("ModalityName", typeof(string));
        dt.Columns.Add("ReqProcedureDescription", typeof(string));
        dt.Columns.Add("RegDate", typeof(string));

        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT pm.`PName` PatientName, pm.`PatientID` PatientID,CONCAT(plo.`Date`,' ',plo.`Time`) datetimeplo, ");
        sb.Append("  pm.`Age`,pm.`Gender` SEX, ");
        sb.Append(" DATE_ADD(CURRENT_DATE(),INTERVAL - ( IF(pm.DOB = '0001-01-01',   ");
        sb.Append(" (CASE WHEN pm.AGE LIKE '%DAY%' THEN ((TRIM(REPLACE(pm.AGE,'DAY(S)',''))+0))  ");
        sb.Append(" WHEN pm.AGE LIKE '%MONTH%' THEN ((TRIM(REPLACE(pm.AGE,'MONTH(S)',''))+0)*30)  ");
        sb.Append(" ELSE ((TRIM(REPLACE(pm.AGE,'YRS',''))+0)*365) END),    ");
        sb.Append(" DATEDIFF(NOW(),pm.DOB))) DAY) DOB,  ");
        sb.Append(" (SELECT  CONCAT(dm.`Title`,' ',dm.`Name`) FROM `doctor_master` dm WHERE dm.DoctorID=pmh.DoctorID )ReferDoctor,  ");
        sb.Append(" REPLACE(plo.`Test_ID`,'LSHHI','') AccessionNumber,  ");
        sb.Append(" sc.ModalityName,  ");
        sb.Append(" im.`TypeName` ReqProcedureDescription,  ");
        sb.Append(" CONCAT(DATE_FORMAT(lt.date,'%d-%b-%Y'),' ',lt.`Time`) RegDate ");
        sb.Append(" FROM `patient_labinvestigation_opd` plo   ");
        sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionNo`=plo.`LedgerTransactionNo` AND lt.`IsCancel`=0 AND lt.CentreID=1  ");
        sb.Append(" AND plo.Date>='" + FromDate.ToString("yyyy-MM-dd") + "' AND plo.Date<='" + ToDate.ToString("yyyy-MM-dd") + "'   ");
        sb.Append(" INNER JOIN `patient_medical_history` pmh ON pmh.`TransactionID`=lt.`TransactionID`   ");
        sb.Append(" INNER JOIN patient_master pm ON pm.`PatientID`=pmh.`PatientID`   ");
        sb.Append(" INNER JOIN f_itemmaster im ON im.`Type_ID`=plo.Investigation_ID   ");
        sb.Append(" INNER JOIN `f_subcategorymaster` sc ON sc.`SubCategoryID` = im.`SubCategoryID` AND sc.`CategoryID`=7  ");
        sb.Append(" AND sc.ModalityName='" + modalityName + "' ORDER BY pm.PName   ");




        // File.WriteAllText(@"D:\ing.txt", sb.ToString());

        dt = StockReports.GetDataTable(sb.ToString());

        for (int i = 0; i < dt.Rows.Count; i++)
        {
            TestList tl = new TestList();
            tl.PatientID = dt.Rows[i]["PatientID"].ToString();
            tl.PatientName = dt.Rows[i]["PatientName"].ToString();
            tl.Age = dt.Rows[i]["Age"].ToString();
            tl.DOB = Util.GetDateTime(dt.Rows[i]["DOB"]);
            tl.SEX = dt.Rows[i]["SEX"].ToString();
            tl.ReferingPhysicianName = dt.Rows[i]["ReferDoctor"].ToString();
            tl.AccessionNumber = dt.Rows[i]["AccessionNumber"].ToString();
            tl.ModalityName = dt.Rows[i]["ModalityName"].ToString();
            tl.ReqProcedureDescription = dt.Rows[i]["ReqProcedureDescription"].ToString();
            tl.SchProcStepStartDate = Util.GetDateTime(dt.Rows[i]["RegDate"]);
            tl.StudyInstanceUId = styUID.GenerateStudyInstanceUid(dt.Rows[i]["AccessionNumber"].ToString(), Convert.ToDateTime(dt.Rows[i]["datetimeplo"].ToString()), dt.Rows[i]["AccessionNumber"].ToString());

            PatientList.Add(tl);

        }


        return PatientList;

    }


}