<%@ WebService Language="C#" Class="MISServices" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using Newtonsoft.Json;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;
using System.Collections.Generic;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class MISServices : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }

    [WebMethod]
    public string LoadData(string fromDate, string toDate)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            // string cmd = "CREATE TABLE `mis_data_summary` ( `ID` INT(1) NOT NULL AUTO_INCREMENT, `PatientID` VARCHAR(20) DEFAULT NULL, `PName` VARCHAR(162) DEFAULT NULL, `Age` VARCHAR(20) DEFAULT NULL, `Sex` VARCHAR(10) DEFAULT NULL, `ContactNo` VARCHAR(15) DEFAULT NULL, `City` VARCHAR(50) DEFAULT NULL, `DateofApp` DATE DEFAULT NULL, `StartTime` TIME DEFAULT NULL, `EndTime` TIME DEFAULT NULL, `VisitType` VARCHAR(50) DEFAULT NULL, `IsConform` INT(1) DEFAULT '0', `Panel` VARCHAR(150) DEFAULT NULL, `SubGroup` VARCHAR(100) DEFAULT NULL, `DisplayName` VARCHAR(100) DEFAULT NULL, `Department` VARCHAR(50) DEFAULT NULL, `Doctor` VARCHAR(211) DEFAULT NULL, `BookingDate` DATE DEFAULT NULL, `BookingTime` TIME DEFAULT NULL, `GrossAmount` DECIMAL(16,2) DEFAULT NULL, `DiscountOnTotal` DECIMAL(16,2) DEFAULT NULL, `NetAmount` DECIMAL(16,2) DEFAULT NULL, `Adjustment` DECIMAL(16,2) DEFAULT '0.00', `BookingCancel` INT(1) DEFAULT '0', `CallTime` DATETIME DEFAULT NULL, `InTime` DATETIME DEFAULT NULL, `RescheduleBy` VARCHAR(20) DEFAULT NULL, `ReScheduleDate` DATETIME DEFAULT NULL, `P_IN` INT(1) DEFAULT '0', `P_INDateTime` DATETIME DEFAULT NULL, `P_Out` INT(1) DEFAULT '0', `P_OutDateTime` DATETIME DEFAULT NULL, `P_Type` VARCHAR(10) DEFAULT NULL, PRIMARY KEY (`ID`) ) ENGINE=INNODB  DEFAULT CHARSET=utf8 ";            
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "TRUNCATE TABLE mis_data_summary");
            var sqlCmd = new StringBuilder("INSERT INTO mis_data_summary (PatientID, PName, Age, Sex, ContactNo, City, DateofApp, StartTime, EndTime, VisitType, IsConform, Panel, SubGroup, DisplayName, Department, Doctor, BookingDate, BookingTime, GrossAmount, DiscountOnTotal, NetAmount, Adjustment, BookingCancel, CallTime, InTime, RescheduleBy, ReScheduleDate, P_IN, P_INDateTime, P_Out, P_OutDateTime, P_Type,IsExpired,PanelGroup,Diagnosis,Source,Locality) ");
            sqlCmd.Append("SELECT ap.`PatientID`,CONCAT(ap.`Title`,' ',ap.`PfirstName`,' ',ap.`Pname`)PName,ap.`Age`,ap.`Sex`,ap.`ContactNo`,ap.`City`, ");
            sqlCmd.Append("ap.`Date` DateofApp, ap.`Time` AS StartTime,ap.`EndTime` AS EndTime,ap.`VisitType`, ");
            sqlCmd.Append("ap.`IsConform`,pnl.`Company_Name` AS Panel,sm.`Name` 'SubGroup',sm.`DisplayName`,dh.`Department`, ");
            sqlCmd.Append("CONCAT(dm.`Title`,' ',dm.`Name`)Doctor , ");
            sqlCmd.Append("lt.`Date` BookingDate,lt.`Time` BookingTime,lt.`GrossAmount`,lt.`DiscountOnTotal`,lt.`NetAmount`,lt.`Adjustment`,ap.`IsCancel` BookingCancel, ");
            sqlCmd.Append("ap.`CallTime`,ap.`InTime`,ap.`RescheduleBy`,ap.`ReScheduleDate`,ap.`P_IN`,ap.`P_INDateTime`,ap.`P_Out`,ap.`P_OutDateTime`,ap.`P_Type`,  IF(ap.IsCancel=0 AND ap.IsConform=0 AND ap.Date<CURDATE(),1,0) `IsExpired`,pnl.PanelGroup,(SELECT dm.Diagnosis FROM   diagnosis_master dm WHERE dm.ID=pmh.DiagnosisID )Diagnosis,(SELECT AppointmentType FROM Master_AppointmentType WHERE AppointmentTypeID=ap.TypeOfApp)Source,ap.city Locality ");
            sqlCmd.Append("FROM appointment ap ");
            sqlCmd.Append("INNER JOIN `f_subcategorymaster` sm ON ap.`SubCategoryID`=sm.`SubCategoryID` ");
            sqlCmd.Append("INNER JOIN doctor_master dm ON dm.`DoctorID`=ap.`DoctorID` ");
            sqlCmd.Append("INNER JOIN (SELECT * FROM `doctor_hospital` GROUP BY DoctorID)dh ON dh.`DoctorID`=dm.`DoctorID` ");
            sqlCmd.Append("INNER JOIN `f_panel_master` pnl ON ap.`PanelID`=pnl.`PanelID` ");
            sqlCmd.Append("LEFT JOIN patient_medical_history  pmh ON pmh.`TransactionID` = ap.`TransactionID`");
            sqlCmd.Append("LEFT JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=ap.LedgerTnxNo ");
            sqlCmd.Append("WHERE ap.Date>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND ap.Date<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "'");
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sqlCmd.ToString());
            tranX.Commit();
            return JsonConvert.SerializeObject(new { status = true, data = "Load Successfully" });
        }
        catch (Exception ex)
        {
            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, data = "Error While Loading", message = ex.Message });
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }

    }

    [WebMethod]
    public string GetSearchResult(string fromDate, string toDate)
    {
        try
        {
            // var SqlCmd = new StringBuilder("SELECT CONCAT('Total :',COUNT(*))  Label ,COUNT(*) `Value`,'' `Param` FROM mis_data_summary md WHERE md.DateofApp>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND md.DateofApp<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ");
            // SqlCmd.Append(" UNION ALL ");
            var SqlCmd = new StringBuilder(" SELECT CONCAT('Confirmed :',COUNT(*)) Label, COUNT(*) `Value`,'IsConform' `Param` FROM mis_data_summary md WHERE  md.DateofApp>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND md.DateofApp<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' AND md.IsConform='1' ");
            SqlCmd.Append(" UNION ALL ");
            SqlCmd.Append(" SELECT CONCAT('Canceled :',COUNT(*)) Label, COUNT(*) `Value`,'BookingCancel' `Param` FROM mis_data_summary md WHERE  md.DateofApp>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND md.DateofApp<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' AND md.BookingCancel='1' ");
            SqlCmd.Append(" UNION ALL");
            SqlCmd.Append(" SELECT CONCAT('Expired :',COUNT(*)) Label, COUNT(*) `Value`,'IsExpired' `Param` FROM mis_data_summary md WHERE  md.DateofApp>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND md.DateofApp<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' AND md.IsExpired='1' ");
            //SqlCmd.Append(" SELECT CONCAT('New Patient :',COUNT(*)) Label, COUNT(*) `Value`,'New Patient'  `Param` FROM mis_data_summary md WHERE  md.DateofApp>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND md.DateofApp<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' AND VisitType='New Patient' ");
            //SqlCmd.Append(" UNION ALL");
            //SqlCmd.Append(" SELECT CONCAT('Old Patient :',COUNT(*)) Label, COUNT(*) `Value`,'Old Patient' `Param` FROM mis_data_summary md WHERE  md.DateofApp>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND md.DateofApp<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' AND VisitType='Old Patient' ");
            //SqlCmd.Append(" UNION ALL");
            //SqlCmd.Append(" SELECT CONCAT('Male :',COUNT(*)) Label, COUNT(*) `Value`,'Male' `Param` FROM mis_data_summary md WHERE  md.DateofApp>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND md.DateofApp<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' AND Sex='Male' ");
            //SqlCmd.Append(" UNION ALL");
            //SqlCmd.Append(" SELECT CONCAT('Female :',COUNT(*)) Label, COUNT(*) `Value`,'Female' `Param` FROM mis_data_summary md WHERE  md.DateofApp>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND md.DateofApp<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' AND Sex='Female' ");
            var dataTable = StockReports.GetDataTable(SqlCmd.ToString());
            return JsonConvert.SerializeObject(new { status = true, data = dataTable });
        }
        catch (Exception ex)
        {
            return JsonConvert.SerializeObject(new { status = true, data = ex.Message });
        }
    }

    [WebMethod]
    public string GetDoctorsList(string fromDate, string toDate, string selection, string category, string subCategory)
    {
        string labelField="", valueField="",whereCondition="", groupBy = "";
        try
        {

            if (category == "Department's Name")
            {
                labelField = "md.Department `Label`";
                groupBy = "md.Department";
            }
            if (category == "Doctor's Name")
            {
                labelField = "md.Doctor `Label`";
                groupBy = "md.Doctor";
            }
            if (category == "Panel's Name")
            {
                labelField = "md.Panel `Label`";
                groupBy = "md.Panel";
            }

            if (category == "Gender")
            {
                labelField = "md.Sex `Label`";
                groupBy = "md.Sex";
            }

            if (category == "PanelGroup")
            {
                labelField = "md.PanelGroup `Label`";
                groupBy = "md.PanelGroup";
            }

            if (category == "Diagnosis")
            {
                labelField = "md.Diagnosis `Label`";
                groupBy = "md.Diagnosis";
            }

            if (category == "Source")
            {
                labelField = "md.Source `Label`";
                groupBy = "md.Source";
            }

            if (category == "Locality")
            {
                labelField = "md.Locality `Label`";
                groupBy = "md.Locality";
            }
            

            if (subCategory == "Appointment's")
                valueField = "COUNT(*) `Value`";
            
            if (subCategory == "Collection")
                valueField = "SUM(md.Adjustment) `Value`";
            
            if (subCategory == "Revenue")
                valueField = "SUM(md.NetAmount) `Value`";

            if (subCategory == "Discount")
                valueField = "SUM(md.DiscountOnTotal) `Value`";

            if (selection == "IsConform")
                whereCondition = "and md.IsConform=1";

            if (selection == "BookingCancel")
                whereCondition = "and md.BookingCancel=1";

            if (selection == "IsExpired")
                whereCondition = "and md.IsExpired=1";            
            
            if (selection == "New Patient")
                whereCondition = "and md.VisitType='New Patient' ";

            if (selection == "Male")
                whereCondition = "and md.Sex='Male' ";

            if (selection == "Female")
                whereCondition = "and md.Sex='Female' ";

            var SqlCmd = new StringBuilder("SELECT " + labelField + "," + valueField + " FROM mis_data_summary md   WHERE md.DateofApp>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND md.DateofApp<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' " + whereCondition + "  GROUP BY " + groupBy);
            var str = SqlCmd.ToString();
            var dataTable = StockReports.GetDataTable(SqlCmd.ToString());
            return JsonConvert.SerializeObject(new { status = true, data = dataTable });
        }
        catch (Exception ex)
        {
            return JsonConvert.SerializeObject(new { status = false, data = ex.Message });
        }
    
    
    }



    [WebMethod]
    public string GetPatientDetails(string fromDate, string toDate, string selection, string category, string detailSelection, string patientDetailValueField)
    {
        try
        {
            var valueField = "";
            var sqlCmd = new StringBuilder("SELECT * FROM mis_data_summary md WHERE  md.DateofApp>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND md.DateofApp<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ");


            var whereCondition = new StringBuilder();
            if (selection == "IsConform")
                whereCondition.Append("and md.IsConform=1 ");

            if (selection == "BookingCancel")
                whereCondition.Append("and md.BookingCancel=1 ");
            if (selection == "IsExpired")
                whereCondition.Append("and md.IsExpired=1 ");
            
            if (selection == "New Patient")
                whereCondition.Append("and md.VisitType='New Patient' ");

            if (selection == "Old Patient")
                whereCondition.Append("and md.VisitType='Old Patient' ");

            if (selection == "Male")
                whereCondition.Append("and md.Sex='Male' ");

            if (selection == "Female")
                whereCondition.Append("and md.Sex='Female' ");


            if (category == "Department's Name")
                whereCondition.Append("and md.Department= '" + detailSelection + "' ");


            if (category == "Doctor's Name")
                whereCondition.Append("and md.Doctor= '" + detailSelection + "' ");

            if (category == "Gender")
                whereCondition.Append("and md.sex= '" + detailSelection + "' ");
            
            if (category == "Panel")
                whereCondition.Append("and md.Panel= '" + detailSelection + "' ");
            
            if (category == "PanelGroup")
                whereCondition.Append("and md.PanelGroup= '" + detailSelection + "' ");

            if (category == "Diagnosis")
                whereCondition.Append("and md.Diagnosis= '" + detailSelection + "' ");

            if (category == "Source")
                whereCondition.Append("and md.Source= '" + detailSelection + "' ");

            if (category == "Locality")
                whereCondition.Append("and md.Locality= '" + detailSelection + "' ");

            if (patientDetailValueField == "Appointment's")
                valueField = "COUNT(*) `Value`";

            if (patientDetailValueField == "Collection")
                valueField = "SUM(md.Adjustment) `Value`";

            if (patientDetailValueField == "Revenue")
                valueField = "SUM(md.NetAmount) `Value`";

            if (patientDetailValueField == "Discount")
                valueField = "SUM(md.DiscountOnTotal) `Value`";
            

            var sqlCmds = new System.Collections.Generic.List<string>();
            sqlCmds.Add("SELECT md.Department `Label`," + valueField + " FROM mis_data_summary md   WHERE md.DateofApp>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND md.DateofApp<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' " + whereCondition.ToString() + "  GROUP BY md.Department ;");
            sqlCmds.Add("SELECT md.Doctor `Label`," + valueField + " FROM mis_data_summary md   WHERE md.DateofApp>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND md.DateofApp<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' " + whereCondition.ToString() + "  GROUP BY md.Doctor;");
            sqlCmds.Add("SELECT md.Panel `Label`," + valueField + " FROM mis_data_summary md   WHERE md.DateofApp>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND md.DateofApp<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' " + whereCondition.ToString() + "  GROUP BY md.Panel;");
            sqlCmds.Add("SELECT md.Sex `Label`," + valueField + " FROM mis_data_summary md   WHERE md.DateofApp>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND md.DateofApp<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' " + whereCondition.ToString() + "  GROUP BY md.Sex;");
            sqlCmds.Add("SELECT md.PanelGroup `Label`," + valueField + " FROM mis_data_summary md   WHERE md.DateofApp>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND md.DateofApp<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' " + whereCondition.ToString() + "  GROUP BY md.PanelGroup;");
            sqlCmds.Add("SELECT md.Diagnosis `Label`," + valueField + " FROM mis_data_summary md   WHERE md.DateofApp>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND md.DateofApp<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' " + whereCondition.ToString() + "  GROUP BY md.Diagnosis;");
            sqlCmds.Add("SELECT md.Source `Label`," + valueField + " FROM mis_data_summary md  WHERE md.DateofApp>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND md.DateofApp<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' " + whereCondition.ToString() + "  GROUP BY md.Source;");
            sqlCmds.Add("SELECT md.Locality `Label`," + valueField + " FROM mis_data_summary md  WHERE md.DateofApp>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND md.DateofApp<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' " + whereCondition.ToString() + "  GROUP BY md.Locality;");

            var detailDataTable = new List<DataTable>();
            sqlCmds.ForEach(i =>{ 
               var result= StockReports.GetDataTable(i.ToString());
               detailDataTable.Add(result);
            });
            
            var dataTable = StockReports.GetDataTable(sqlCmd.Append(whereCondition.ToString()).ToString());
            return JsonConvert.SerializeObject(new { status = true, data = dataTable, summaryData = detailDataTable });
        }
        catch (Exception ex)
        {
            return JsonConvert.SerializeObject(new { status = false, data="Error While Loading", message = ex.Message });
        }


    }


     [WebMethod]
    public string FilterPatientDetails(string fromDate, string toDate, string selection, string category, string detailSelection, string chartName, string patientSummarySelectedValue)
    {
        try
        {
            
            var sqlCmd = new StringBuilder("SELECT * FROM mis_data_summary md WHERE  md.DateofApp>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND md.DateofApp<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ");


            var whereCondition = new StringBuilder();
            if (selection == "IsConform")
                whereCondition.Append("and md.IsConform=1 ");

            if (selection == "BookingCancel")
                whereCondition.Append("and md.BookingCancel=1 ");
            if (selection == "IsExpired")
                whereCondition.Append("and md.IsExpired=1 ");

            if (category == "Department's Name")
                whereCondition.Append("and md.Department= '" + detailSelection + "' ");


            if (category == "Doctor's Name")
                whereCondition.Append("and md.Doctor= '" + detailSelection + "' ");

            if (category == "Gender")
                whereCondition.Append("and md.sex= '" + detailSelection + "' ");

            if (category == "Panel")
                whereCondition.Append("and md.Panel= '" + detailSelection + "' ");


            if (category == "PanelGroup")
                whereCondition.Append("and md.PanelGroup= '" + detailSelection + "' ");

            if (category == "Diagnosis")
                whereCondition.Append("and md.Diagnosis= '" + detailSelection + "' ");

            if (category == "Source")
                whereCondition.Append("and md.Source= '" + detailSelection + "' ");

            if (category == "Locality")
                whereCondition.Append("and md.Locality= '" + detailSelection + "' ");

            whereCondition.Append("and md." + chartName + "='" + patientSummarySelectedValue + "' ");
             
         
            var dataTable = StockReports.GetDataTable(sqlCmd.Append(whereCondition.ToString()).ToString());
            return JsonConvert.SerializeObject(new { status = true, data = dataTable });
        }
        catch (Exception ex)
        {
            return JsonConvert.SerializeObject(new { status = false, data = "Error While Loading", message = ex.Message });
        }
    
    }

}