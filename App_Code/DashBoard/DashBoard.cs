using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;

/// <summary>
/// Summary description for DashBoard
/// </summary>
public class DashBoard
{
    public DashBoard()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public static DataTable IPDBillingInfo(string IPDNo)
    {
        DataTable dt = new DataTable();
        return dt;
    }
    public static DataTable bindAppDetail(string FromDate, string ToDate)
    {
        DataTable dt = StockReports.GetDataTable(" CALL DashBoard_Appointment('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "') ");
        return dt;
    }
    public static DataTable bindIPDBillingDetail(string FromDate, string ToDate)
    {
        DataTable dt = StockReports.GetDataTable(" CALL dashBoard_IPDBillingDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "') ");
        return dt;
    }
    public static DataTable bindAppDetailPopUp(string FromDate, string ToDate)
    {
        DataTable dt = StockReports.GetDataTable(" CALL DashBoard_AppDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "') ");
        return dt;
    }
    public static DataTable bindDocWiseAppDetailPopUp(string FromDate, string ToDate)
    {
        DataTable dt = StockReports.GetDataTable(" CALL DashBoard_DocWiseApp('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "') ");
        return dt;
    }
    public static DataTable bindBedDetailPopUp(string FromDate, string ToDate)
    {
        DataTable dt = StockReports.GetDataTable(" CALL DashBoard_BedDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "') ");
        return dt;
    }
    public static DataTable bindAddDetailPopUp(string FromDate, string ToDate)
    {
        DataTable dt = StockReports.GetDataTable(" CALL DashBoard_IPDAdmission('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "') ");

        return dt;

    }
    public static DataTable bindDateWiseAppPopUp(string FromDate, string ToDate)
    {
        DataTable dt = StockReports.GetDataTable(" CALL DashBoard_DateWiseAppointment('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "') ");
        return dt;
    }
    public static DataTable bindDateWiseIPDAdvSet(string FromDate, string ToDate)
    {
        DataTable dt = StockReports.GetDataTable(" CALL DashBoard_IPDDateWiseAdvSett('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "') ");

        return dt;

    }
    public static DataTable bindIPDPanelWise(string FromDate, string ToDate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select pm.Company_Name `Panel Name`,count(pmh.TransactionID) AS `TotalPatient` ");
        sb.Append(" from patient_medical_history pmh inner join f_panel_master pm on pm.PanelID = pmh.PanelID");
        sb.Append(" inner join ipd_case_history ich on pmh.TransactionID = ich.TransactionID");
        sb.Append(" where pmh.Type = 'IPD' and  ich.Status <> 'Cancel' ");
        if (FromDate != string.Empty)
            sb.Append(" and pmh.DateOfVisit >= '" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "'");
        if (ToDate != string.Empty)
            sb.Append(" and pmh.DateOfVisit <= '" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'");
        sb.Append(" group by pm.Company_Name order by pm.Company_Name ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }
    public static DataTable bindIPDDepartmentWise(string FromDate, string ToDate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select (select distinct(Department)Department from doctor_hospital where DoctorID = pmh.DoctorID) AS Name ,");
        sb.Append(" count(pmh.TransactionID) AS `TotalPatient` from patient_medical_history pmh inner join ipd_case_history ich on ");
        sb.Append(" pmh.TransactionID = ich.TransactionID where pmh.Type = 'IPD' and ich.Status <> 'Cancel' ");
        if (FromDate != string.Empty)
            sb.Append(" and pmh.DateOfVisit >= '" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "'");
        if (ToDate != string.Empty)
            sb.Append(" and pmh.DateOfVisit <= '" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'");
        sb.Append(" group by Name order by Name ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }
    public static DataTable bindIPDDetail(string FromDate, string ToDate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select pmh.PatientID `UHID`,REPLACE(pmh.TransactionID,'ISHHI','')`IPD No.`,(select CONCAT(Title,' ',PName) from patient_master ");
        sb.Append(" where PatientID= pmh.PatientID) As `Patient Name`,date_format(DateOfVisit,'%d-%b-%y')AS `Admit Date`,pmh.Source,");
        sb.Append(" (select distinct(Department) from doctor_hospital where DoctorID = pmh.DoctorID) AS Department,");
        sb.Append(" (select Company_Name from f_panel_master where PanelID = pmh.PanelID)AS `Panel Name`  from patient_medical_history pmh ");
        sb.Append(" inner join ipd_case_history ich on pmh.TransactionID = ich.TransactionID where ich.Status <> 'Cancel'");
        sb.Append(" and pmh.Type = 'IPD' ");
        if (FromDate != string.Empty)
            sb.Append(" and pmh.DateOfVisit >= '" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "'");
        if (ToDate != string.Empty)
            sb.Append(" and pmh.DateOfVisit <= '" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'");
        sb.Append(" order by pmh.DateOfVisit,pmh.DoctorID,pmh.Source");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }
    public static DataTable bindIPDBedOccupancy(string FromDate, string ToDate)
    {
        DataTable dt = StockReports.GetDataTable(" CALL DashBoard_BedOccupancy('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "') ");
        return dt;
    }
    public static DataTable bindOPDDiscount(string FromDate, string ToDate)
    {
        DataTable dt = StockReports.GetDataTable(" CALL DashBoard_OPDDiscount('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "') ");
        return dt;
    }
    public static DataTable bindLabTestWise(string FromDate, string ToDate)
    {
        DataTable dt = StockReports.GetDataTable(" CALL DashBoard_TestWise('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "') ");
        return dt;
    }
    public static DataTable bindMoneyCollection(string FromDate, string ToDate)
    {
        DataTable dt = StockReports.GetDataTable(" CALL DashBoard_MoneyCollection('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "') ");
        return dt;
    }
    public static DataTable bindTypeOfTnxWise(string FromDate, string ToDate)
    {
        DataTable dt = StockReports.GetDataTable(" CALL DashBoard_TypeOfTnxWise('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "') ");
        return dt;
    }
    public static DataTable bindProcedureDiff(string FromDate, string ToDate)
    {
        DataTable dt = StockReports.GetDataTable(" CALL DashBoard_Procedure('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "') ");
        return dt;
    }

    public static DataTable bindProcedure(string FromDate, string ToDate)
    {
        DataTable dt = StockReports.GetDataTable(" CALL DashBoad_ProceduresCharges('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "') ");
        return dt;
    }
    public static DataTable bindOPDRegistration(string FromDate, string ToDate)
    {
        DataTable dt = StockReports.GetDataTable(" CALL DashBoard_Registration('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "') ");
        return dt;
    }
    public static DataTable bindOPDCancel(string FromDate, string ToDate)
    {
        DataTable dt = StockReports.GetDataTable(" CALL DashBoard_OPDCancel('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "') ");
        return dt;
    }
    public static DataTable bindIPDCancel(string FromDate, string ToDate)
    {
        DataTable dt = StockReports.GetDataTable(" CALL DashBoard_IPDCancel('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "') ");
        return dt;
    }
    public static DataTable bindIPDDiscount(string FromDate, string ToDate)
    {
        DataTable dt = StockReports.GetDataTable(" CALL DashBoard_IPDDiscount('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "') ");
        return dt;
    }
    public static DataTable bindIPDItemCancel(string FromDate, string ToDate)
    {
        DataTable dt = StockReports.GetDataTable(" CALL DashBoard_IPDItemCancel('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "') ");
        return dt;

    }
    public static DataTable bindIPDAdvanceSettlement(string FromDate, string ToDate)
    {
        DataTable dt = StockReports.GetDataTable(" CALL DashBoard_IPDAdvanceSettlement('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "') ");

        return dt;

    }
    public static DataTable bindIPDRegister(string FromDate, string ToDate)
    {
        DataTable dt = StockReports.GetDataTable(" CALL DashBoard_IPDRegister('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "') ");
        return dt;

    }
    public static DataTable bindTotalRevenue(string FromDate, string ToDate)
    {
        DataTable dt = StockReports.GetDataTable(" CALL DashBoard_TotalRevenue('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "') ");
        return dt;

    }
    public static DataTable bindIPDCollection(string FromDate, string ToDate)
    {
        DataTable dt = StockReports.GetDataTable(" CALL DashBoard_IPDCollection('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "') ");

        return dt;

    }
    public static DataTable bindIPDPanelWiseCollection(string FromDate, string ToDate)
    {
        DataTable dt = StockReports.GetDataTable(" CALL DashBoard_IPDPanelWiseCollection('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "') ");
        return dt;

    }
    public static DataTable bindOPDCollection(string FromDate, string ToDate)
    {
        DataTable dt = StockReports.GetDataTable(" CALL DashBoard_OPDCollection('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "') ");

        return dt;

    }
    public static DataTable bindOPDRefunds(string FromDate, string ToDate)
    {
        DataTable dt = StockReports.GetDataTable(" CALL DashBoard_OPDRefunds('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "') ");

        return dt;

    }
    public static DataTable bindIPDServices(string FromDate, string ToDate)
    {
        DataTable dt = StockReports.GetDataTable(" CALL DashBoard_IPDServices('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "') ");

        return dt;

    }
    public static DataTable bindLabItemAnalysis(string FromDate, string ToDate)
    {
        DataTable dt = StockReports.GetDataTable(" CALL DashBoard_LabItemAnalysis('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "') ");
        return dt;

    }
    public static DataTable bindIPDPharmacy(string FromDate, string ToDate)
    {
        DataTable dt = StockReports.GetDataTable(" CALL DashBoard_IPDPharmacyGross('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "') ");
        return dt;

    }
    public static DataTable bindOPDCollectionDateWise(string FromDate, string ToDate)
    {
        DataTable dt = StockReports.GetDataTable(" CALL DashBoard_OPDCollectionDateWise('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "') ");
        return dt;
    }

    public static DataTable bindOPDPanelCredit(string FromDate, string ToDate)
    {
        DataTable dt = StockReports.GetDataTable(" CALL DashBoard_PanelCollection('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "') ");
        return dt;

    }
    public static DataTable bindOPDCashOutstanding(string FromDate, string ToDate)
    {
        DataTable dt = StockReports.GetDataTable(" CALL DashBoard_OPDCashOutstanding('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "') ");
        return dt;

    }
    public static DataTable bindOPDPanelGroupOutstanding(string FromDate, string ToDate)
    {
        DataTable dt = StockReports.GetDataTable(" CALL DashBoard_OPDPanelGroup('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "') ");
        return dt;

    }

    public static DataTable bindOPDPanelOutstanding(string FromDate, string ToDate)
    {
        DataTable dt = StockReports.GetDataTable(" CALL DashBoard_OPDPanelWise('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "') ");
        return dt;

    }
    public static DataTable bindIPDPackageDeptWise(string FromDate, string ToDate)
    {
        DataTable dt = StockReports.GetDataTable(" CALL dashBoard_IPDPackageDeptWise('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "') ");
        return dt;

    }
    
}