using System.Data;
using System.Text;

/// <summary>
/// Summary description for EDPReports
/// </summary>
public class EDPReports
{
    public EDPReports()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public static DataTable GetPanels()
    {
       return StockReports.GetDataTable("select PanelID value,Company_Name text From f_panel_master pm Where IsActive=1 order by Company_Name");
       
    }

    public static DataTable GetPanels(string PanelGroup)
    {
      return StockReports.GetDataTable("select PanelID value,Company_Name text From f_panel_master where IsActive=1 and PanelGroup='" + PanelGroup + "' order by Company_Name");
       
    }

    public static DataTable GetDepartments()
    {
       return StockReports.GetDataTable("select Distinct(Department) value,Department text from doctor_hospital where Department <> '' order by Department");
        
    }

    public static DataTable GetFloors()
    {
       return StockReports.GetDataTable("select distinct(Floor) value,Floor text from room_master order by Floor");
       
    }

    public static DataTable GetConsultants()
    {
       return StockReports.GetDataTable("select DoctorID value,CONCAT(Title,' ',Name) text from doctor_master order by Name");
       
    }
    public static DataTable GetConsultantsWithoutTitle()
    {
        return StockReports.GetDataTable("select DoctorID value,Name text from doctor_master where IsActive = 1 order by Name");

    }
    public static DataTable GetBedCategory()
    {
       return StockReports.GetDataTable("select IPDCaseTypeID value,Name text from ipd_case_type_master  WHERE IsActive=1 order by Name");
       
    }

    public static DataTable GetAdmittedPatients(string ReportType, string ItemIDs)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("SELECT ip.PatientID,ip.TransactionID,ich.DateOfAdmit,ich.TimeOfAdmit,ich.DateOfDischarge,");
        sb.Append(" ich.TimeOfDischarge,rm.Name AS BedNo,rm.Floor,ctm.Name AS BedCategory,concat(dm.Title,' ',dm.Name)ConsultantName,");
        sb.Append(" concat(pm.Title,' ',pm.PName)PatientName,pm.Age,pm.Gender,pm.Phone,pm.Mobile,pnl.Company_Name,PMH.Source,");
        sb.Append(" (select distinct(Department) from doctor_hospital where DoctorID = ich.Consultant_ID)AS Dept,'' As DischargeStatus");
        sb.Append(" FROM patient_ipd_profile ip INNER JOIN patient_medical_history PMH ON IP.TransactionID = PMH.TransactionID INNER JOIN ipd_case_history ich ON ip.TransactionID = ich.TransactionID");
        sb.Append(" INNER JOIN room_master rm ON rm.Room_Id = ip.Room_ID INNER JOIN ipd_case_type_master ctm ON ctm.IPDCaseTypeID = rm.IPDCaseTypeID ");
        sb.Append(" INNER JOIN doctor_master dm ON dm.DoctorID = ich.Consultant_ID INNER JOIN patient_master pm ON pm.PatientID = ip.PatientID");
        sb.Append(" INNER JOIN f_panel_master pnl ON pnl.PanelID = ip.PanelID WHERE ip.Status = 'IN' ");

        string str = string.Empty;

        switch (ReportType)
        {
            case "1":
                str = sb.ToString();
                break;
            case "2":
                if (ItemIDs != string.Empty)
                    str = sb.ToString() + " AND rm.IPDCaseTypeID IN (" + ItemIDs + ")";
                else
                    str = sb.ToString();
                break;
            case "3":
                if (ItemIDs != string.Empty)
                    str = sb.ToString() + " AND ich.Consultant_ID IN (" + ItemIDs + ")";
                else
                    str = sb.ToString();
                break;
            case "4":
                str = sb.ToString();
                break;
            case "5":
                if (ItemIDs != string.Empty)
                    str = " SELECT * FROM ( " + sb.ToString() + " )temp1 WHERE Dept IN (" + ItemIDs + ")";
                else
                    str = sb.ToString();
                break;
            case "6":
                if (ItemIDs != string.Empty)
                    str = sb.ToString() + " AND rm.Floor IN (" + ItemIDs + ")";
                else
                    str = sb.ToString();
                break;
            case "7":
                if (ItemIDs != string.Empty)
                    str = sb.ToString() + " AND ip.PanelID IN (" + ItemIDs + ")";
                else
                    str = sb.ToString();
                break;
        }

        if ((ReportType == "5") && (ItemIDs != string.Empty))
            str += " Order by TransactionID";
        else
            str += " Order by ich.TransactionID";

        
        return StockReports.GetDataTable(str);
        
    }

    public static DataTable GetPatientAdmissionList(string ReportType, string ItemIDs, string fromDate, string toDate, string Centre)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT ip.PatientID,pmh.TransNo AS Transaction_ID,cm.CentreID,cm.CentreName,Date_FORMAT(pmh.DateOfAdmit,'%d-%b-%Y')DateOfAdmit,DATE_FORMAT(pmh.TimeOfAdmit,'%h:%i %p')TimeOfAdmit,Date_FORMAT(pmh.DateOfDischarge,'%d-%b-%Y')DateOfDischarge,");
        sb.Append(" DATE_FORMAT(pmh.TimeOfDischarge,'%h:%i %p')TimeOfDischarge,rm.Bed_No AS BedNo,CONCAT(rm.Name,'-',rm.Floor)FLOOR,ctm.Name AS BedCategory,concat(dm.Title,' ',dm.Name)ConsultantName,");
        sb.Append(" concat(pm.Title,' ',pm.PName)PatientName,pm.Age,pm.Gender,pm.Phone,pm.Mobile,pnl.Company_Name, ");
        sb.Append(" dm.Designation AS Dept,'' As DischargeStatus,pmh.Source,ip.StartDate,(SELECT CONCAT(em.Title,' ',em.name) FROM employee_master em WHERE em.Employeeid=pmh.`UserID`)AdmitBy FROM patient_ipd_profile ip inner join patient_medical_history PMH ON IP.TransactionID = PMH.TransactionID  ");//INNER JOIN ipd_case_history ich ON ip.TransactionID = ich.TransactionID
        sb.Append(" INNER JOIN room_master rm ON rm.RoomId = ip.RoomID  ");//INNER JOIN f_ipdadjustment adj on adj.TransactionID=ich.TransactionID
        sb.Append(" INNER JOIN ipd_case_type_master ctm ON ctm.IPDCaseTypeID = rm.IPDCaseTypeID INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID ");//ich.Consultant_ID
        sb.Append(" INNER JOIN patient_master pm ON pm.PatientID = ip.PatientID INNER JOIN Center_master cm ON cm.CentreID=pmh.CentreID INNER JOIN f_panel_master pnl ON pnl.PanelID = PMH.PanelID ");
        sb.Append(" WHERE pmh.Status <> 'Cancel' and pmh.CentreID IN (" + Centre + ")  AND pmh.isopeningBalance=0 and pmh.DateOfAdmit >= '" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND pmh.DateOfAdmit <= '" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "'");

        string str = string.Empty;

        switch (ReportType)
        {
            case "1":
                str = sb.ToString();
                break;
            case "2":
                if (ItemIDs != string.Empty)
                    str = sb.ToString() + " AND rm.IPDCaseTypeID IN (" + ItemIDs + ")";
                else
                    str = sb.ToString();
                break;
            case "3":
                if (ItemIDs != string.Empty)
                    str = sb.ToString() + " AND pmh.DoctorID  IN (" + ItemIDs + ")";
                else
                    str = sb.ToString();
                break;
            case "4":
                str = sb.ToString();
                break;
            case "5":
                if (ItemIDs != string.Empty)
                    str = " SELECT * FROM ( " + sb.ToString() + " )temp1 WHERE Dept IN (" + ItemIDs + ")";
                else
                    str = sb.ToString();
                break;
            case "6":
                if (ItemIDs != string.Empty)
                    str = sb.ToString() + " AND rm.Floor IN (" + ItemIDs + ")";
                else
                    str = sb.ToString();
                break;
            case "7":
                if (ItemIDs != string.Empty)
                    str = sb.ToString() + " AND PMH.PanelID IN (" + ItemIDs + ")";
                else
                    str = sb.ToString();
                break;
        }

        if ((ReportType == "5") && (ItemIDs != string.Empty))
            str += " Group by TransactionID Having min(StartDate) Order by TransactionID";
        else
            str += " Group by ip.TransactionID Having min(ip.StartDate) Order by pmh.TransactionID";
        
        return StockReports.GetDataTable(str);        
    }

    public static DataTable GetPatientDischargeList(string ReportType, string ItemIDs, string fromDate, string toDate, string Centre)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ip.PatientID,pmh.TransNo AS TransactionID,cm.CentreID,cm.CentreName,Date_FORMAT(pmh.DateOfAdmit,'%d-%b-%Y')DateOfAdmit,DATE_FORMAT(pmh.TimeOfAdmit,'%h:%i %p')TimeOfAdmit,Date_FORMAT(pmh.DateOfDischarge,'%d-%b-%Y')DateOfDischarge,");
        sb.Append(" DATE_FORMAT(pmh.TimeOfDischarge,'%h:%i %p')TimeOfDischarge,rm.Bed_No AS BedNo,CONCAT(rm.Name,'-',rm.Floor)FLOOR,ctm.Name AS BedCategory,concat(dm.Title,' ',dm.Name)ConsultantName,");
        sb.Append(" concat(pm.Title,' ',pm.PName)PatientName,pm.Age,pm.Gender,pm.Phone,pm.Mobile,pnl.Company_Name, ");
        sb.Append(" dm.Designation AS Dept,pmh.Source,pmh.DischargeType As DischargeStatus,ip.EndDate,(SELECT CONCAT(em.Title,' ',em.name) FROM employee_master em WHERE em.Employeeid=pmh.`DischargedBy`)DischargeBy FROM patient_ipd_profile ip ");//INNER JOIN ipd_case_history ich ON ip.TransactionID = ich.TransactionID
        sb.Append(" INNER JOIN patient_medical_history pmh on ip.TransactionID = pmh.TransactionID  INNER JOIN room_master rm ON rm.RoomId = ip.RoomID ");
        sb.Append(" INNER JOIN ipd_case_type_master ctm ON ctm.IPDCaseTypeID = rm.IPDCaseTypeID INNER JOIN doctor_master dm ON dm.DoctorID = pmh.DoctorID  ");//ich.Consultant_ID
        sb.Append(" INNER JOIN patient_master pm ON pm.PatientID = ip.PatientID   ");
        sb.Append("  INNER JOIN f_panel_master pnl ON pnl.PanelID = pmh.PanelID INNER JOIN Center_master cm ON cm.CentreID=pmh.CentreID  ");//INNER JOIN f_ipdadjustment adj on adj.TransactionID=ich.TransactionID
        sb.Append(" WHERE pmh.Status = 'OUT'  AND pmh.isopeningBalance=0 and pmh.CentreID IN (" + Centre + ") AND pmh.DateOfDischarge >= '" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND pmh.DateOfDischarge <= '" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "'");

        string str = string.Empty;

        switch (ReportType)
        {
            case "1":
                str = sb.ToString();
                break;
            case "2":
                if (ItemIDs != string.Empty)
                    str = sb.ToString() + " AND rm.IPDCaseTypeID IN (" + ItemIDs + ")";
                else
                    str = sb.ToString();
                break;
            case "3":
                if (ItemIDs != string.Empty)
                    str = sb.ToString() + " AND pmh.DoctorID IN (" + ItemIDs + ")";
                else
                    str = sb.ToString();
                break;
            case "4":
                str = sb.ToString();
                break;
            case "5":
                if (ItemIDs != string.Empty)
                    str = " SELECT * FROM ( " + sb.ToString() + " )temp1 WHERE Dept IN (" + ItemIDs + ")";
                else
                    str = sb.ToString();
                break;
            case "6":
                if (ItemIDs != string.Empty)
                    str = sb.ToString() + " AND rm.Floor IN (" + ItemIDs + ")";
                else
                    str = sb.ToString();
                break;
            case "7":
                if (ItemIDs != string.Empty)
                    str = sb.ToString() + " AND pmh.PanelID IN (" + ItemIDs + ")";
                else
                    str = sb.ToString();
                break;
        }

        if ((ReportType == "5") && (ItemIDs != string.Empty))
            str += " Group by TransactionID Having max(temp1.EndDate) Order by TransactionID";
        else
            str += " Group by ip.TransactionID Having max(EndDate) Order by pmh.TransactionID";        
        return  StockReports.GetDataTable(str);
         
    }
}
