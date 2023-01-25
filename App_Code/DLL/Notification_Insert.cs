using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for Notification_Insert
/// </summary>
public class Notification_Insert
{
    public Notification_Insert()
    {
        //
        // TODO: Add constructor logic here
        //
    }
    public static string notificationInsert(int notificationID, string UpdatedID, MySqlTransaction tnx, string DoctorID = "", string IPDCaseType_ID = "", int roleID = 0, string notificationDate = "", string employee_ID = "")
    {
        try
        {
            if (DoctorID != "")
            {
                if (tnx == null)
                    employee_ID = Util.GetString(StockReports.ExecuteScalar("SELECT EmployeeID FROM doctor_employee  WHERE  DoctorID='" + DoctorID + "' "));
                else
                    employee_ID = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT EmployeeID FROM doctor_employee  WHERE  DoctorID='" + DoctorID + "' "));
            }
            int notification = 1;
            if (notificationID == 1) //OPD Appointment 
            {
                notification = All_LoadData.notificationInsert("", 0, 1, "/Design/CPOE/OPDSearch.aspx", "OPD Appointment", "Appointment", "App_ID", "OPD", UpdatedID, DoctorID, notificationDate, tnx, 1);

            }
            else if (notificationID == 2) //Diagnosis Order
            {

            }
            else if (notificationID == 3) //OPD Sample Collection
            {
                notification = All_LoadData.notificationInsert("", 0, 3, "/Design/Lab/SampleCollection.aspx", "Sample Collection", "patient_labinvestigation_opd", "LedgerTransactionNo", "Lab", UpdatedID, "", "", tnx, 0);
            }
            else if (notificationID == 4) //OPD Lab Result Approved
            {
                notification = All_LoadData.notificationInsert(employee_ID, 0, 4, "/Design/Lab/LabHelDesk.aspx", "OPD Lab Result Approved", "", "", "Lab", UpdatedID, "", notificationDate, tnx, 1);
            }
            else if (notificationID == 5) //Blood Issued
            {
                notification = All_LoadData.notificationInsert("", 0, 5, "/Design/BloodBank/BloodRequest.aspx", "Blood Issued", "f_LedgerTransaction", "LedgerTransactionNo", "Blood Bank", UpdatedID, "", notificationDate);
            }
            else if (notificationID == 6) //Blood Request
            {
                notification = All_LoadData.notificationInsert("", 0, 6, "/Design/BloodBank/BloodRequest.aspx", "Blood Request", "f_LedgerTransaction", "LedgerTransactionNo", "Blood Bank", UpdatedID, "", notificationDate);

            }
            else if (notificationID == 7) //Medicine Order
            {

                notification = All_LoadData.notificationInsert(employee_ID, roleID, 8, "/Design/IPD/ViewPatientOrder_Sets.aspx", "Medicine Order Pending", "orderset_medication", "EntryID", "CPOE", UpdatedID, "", notificationDate, tnx, 2);

            }
            else if (notificationID == 8) //Diagnosis Order
            {
                notification = All_LoadData.notificationInsert(employee_ID, roleID, 8, "/Design/IPD/ViewPatientOrder_Sets.aspx", "Diagnosis Order Pending", "OrderSet_Diagnosis", "EntryID", "CPOE", UpdatedID, "", notificationDate, tnx, 2);

            }
            else if (notificationID == 9) //General Order
            {

                notification = All_LoadData.notificationInsert(employee_ID, roleID, 9, "/Design/IPD/ViewPatientOrder_Sets.aspx", "General Order Pending", "orderset_general", "EntryID", "CPOE", UpdatedID, "", notificationDate, tnx, 2);

            }
            else if (notificationID == 10) //Diet Order
            {
                notification = All_LoadData.notificationInsert("", 0, 10, "/Design/Kitchen/patient_diet_approve.aspx", "Diet Order", "diet_patient_diet_request", "ID", "Diet", UpdatedID, "", notificationDate, tnx, 1);
            }
            else if (notificationID == 11) //Diet Issue
            {
                DataTable caseTypeRoleID = AllLoadData_IPD.getRoleIDWithCaseTypeID(IPDCaseType_ID);
                if (caseTypeRoleID.Rows.Count > 0)
                {
                    for (int i = 0; i < caseTypeRoleID.Rows.Count; i++)
                    {
                        notification = All_LoadData.notificationInsert("", Util.GetInt(caseTypeRoleID.Rows[i]["Role_ID"].ToString()), 11, "/Design/Kitchen/patient_diet_approve.aspx", "Diet Order", "diet_patient_diet_request", "ID", "Diet", UpdatedID, "", notificationDate, tnx, 0);
                    }
                }
                //notification = All_LoadData.notificationInsert("", 0, 11, "/Design/Kitchen/patient_diet_approve.aspx", "Diet Order", "diet_patient_diet_request", "ID", "Diet", UpdatedID, "", notificationDate, tnx, 0);

                All_LoadData.updateNotification(Util.GetString(UpdatedID), "", "", 10, tnx, "Diet");

            }
            else if (notificationID == 12) //Diet Receive
            {
                notification = All_LoadData.notificationInsert("", 0, 12, "/Design/Kitchen/patient_diet_approve.aspx", "Diet Order", "diet_patient_diet_request", "ID", "Diet", UpdatedID, "", notificationDate, tnx, 1);

                All_LoadData.updateNotification(Util.GetString(UpdatedID), "", "", 11, tnx, "Diet");

            }
            else if (notificationID == 13) //Consultation Order
            {
                //  notification = All_LoadData.notificationInsert(employee_ID, 52, 13, "/Design/IPD/ViewPatientOrder_Sets.aspx", "IPD Consultation Order Pending", "cpoe_admission_consultation", "EntryID", "IPD", EntryID, ((Label)dr.FindControl("lblSpecialistID")).Text, Util.GetString(DateTime.Now), Tranx);
                notification = All_LoadData.notificationInsert(employee_ID, roleID, 13, "/Design/IPD/ViewPatientOrder_Sets.aspx", "IPD Consultation Order Pending", "cpoe_admission_consultation", "EntryID", "IPD", UpdatedID, "", notificationDate, tnx, 2);
            }
            else if (notificationID == 14) //Circular
            {
                notification = All_LoadData.notificationInsert(employee_ID, 0, 14, "/Design/Circular/ViewCircular.aspx", "New Circular", "circular_inbox", "ID", "Circular", UpdatedID, "", notificationDate, tnx, 2);

            }
            else if (notificationID == 15) //IPD Sample Collection 
            {
                DataTable caseTypeRoleID = AllLoadData_IPD.getRoleIDWithCaseTypeID(IPDCaseType_ID);
                if (caseTypeRoleID.Rows.Count > 0)
                {
                    for (int i = 0; i < caseTypeRoleID.Rows.Count; i++)
                    {
                        notification = All_LoadData.notificationInsert("", Util.GetInt(caseTypeRoleID.Rows[i]["Role_ID"].ToString()), 15, "", "IPD Patient Sample Collection Pending", "patient_labinvestigation_opd", "LedgerTransactionNo", "IPD", UpdatedID, "", "", tnx, 0);
                    }
                }
                //notification = All_LoadData.notificationInsert("", 0, 15, "", "IPD Patient Sample Collection Pending", "patient_labinvestigation_opd", "LedgerTransactionNo", "IPD", UpdatedID, "", "", tnx, 0);
            }

            else if (notificationID == 16) //IPD Lab Result Approved
            {
                if (employee_ID != "")
                    notification = All_LoadData.notificationInsert(employee_ID, roleID, 16, "/Design/Lab/LabHelDesk.aspx", "IPD Lab Result Approved", "", "", "Lab", UpdatedID, "", notificationDate, tnx, 2);
                else
                    notification = All_LoadData.notificationInsert("", roleID, 16, "/Design/Lab/LabHelDesk.aspx", "IPD Lab Result Approved", "", "", "Lab", UpdatedID, "", notificationDate, null, 0);
                //notification = All_LoadData.notificationInsert("", 52, 16, "", "IPD Lab Result Approved", "", "", "IPD", UpdatedID, DoctorID, notificationDate, null, 1);

            }
            else if (notificationID == 17) //IPD Admission Order
            {
                notification = All_LoadData.notificationInsert(employee_ID, roleID, 17, "/Design/IPD/ViewPatientOrder_Sets.aspx", "IPD Admission Order Pending", "OrderSet_Admission", "EntryID", "CPOE", UpdatedID, "", notificationDate, tnx, 2);
            }
            else if (notificationID == 18) //Patient Discharge 
            {
                notification = All_LoadData.notificationInsert("", roleID, 18, "/Design/MRD/PatientSearchMRD.aspx", "IPD Patient Discharged", "mrd_file_master", "TransactionID", "MRD", UpdatedID, "", notificationDate, tnx, 0);
                notification = All_LoadData.notificationInsert("", 0, 18, "/Design/IPD/PatientSearch.aspx", "IPD Patient Discharged", "IPD_Case_history", "TransactionID", "IPD", UpdatedID, "", notificationDate, tnx, 0);
                //notification = All_LoadData.notificationInsert("", 51, 18, "/Design/IPD/Patientsearch.aspx", "Patient Discharge", "emr_ipd_details", "TransactionID", "EMR", UpdatedID, "", "", tnx, 2);
                //string RoleIDConcat = "51,181";
                //notification = All_LoadData.notificationInsert("", 0, 18, "/Design/IPD/Patientsearch.aspx", "Patient Discharge", "emr_ipd_details", "TransactionID", "EMR", UpdatedID, "", "", tnx, 0, RoleIDConcat);
            }
            else if (notificationID == 19) //Patient Intimation Discharge
            {
                notification = All_LoadData.notificationInsert("", 0, 19, "/Design/IPD/PatientSearch.aspx", "IPD Patient Discharge Intimation", "", "TransactionID", "IPD", UpdatedID, "", notificationDate, tnx, 0);
            }
            else if (notificationID == 20) //Reserved Room Notification
            {

            }
            else if (notificationID == 21) //Emergency Patient
            {
                notification = All_LoadData.notificationInsert("", 0, 21, "/Design/CPOE/OPDSearch.aspx", "Emergency Appointment", "Appointment", "App_ID", "OPD", UpdatedID, DoctorID, notificationDate, tnx, 1);
            }
            else if (notificationID == 22) //Requested Room Type Bed Free
            {
                All_LoadData.notificationInsert("", 0, 22, "/Design/MIS/BedDetails.aspx", "Requested Room Type Bed Free", "room_master", "Room_ID", "IPD", UpdatedID, "", "", tnx, 0);
            }
            else if (notificationID == 23) //Items Expired on Stock 
            {
                //Event
            }
            else if (notificationID == 24) //Pending Purchase Request 
            {
                All_LoadData.notificationInsert("", roleID, 24, "/Design/Purchase/PRApproval.aspx", "Purchase Request Pending", "f_purchaserequestmaster", "PurchaseRequestNo", "Store", UpdatedID, "", "", tnx, 0);
            }
            else if (notificationID == 25) //Low Stock Notification 
            {
                //Event
            }
            else if (notificationID == 26) //Item Issue Notification to Department
            {
                All_LoadData.notificationInsert("", roleID, 26, "/Design/Store/IndentSearch.aspx", "Department Indent Item Issue", "f_indent_detail", "IndentNo", "Store", UpdatedID, "", "", tnx, 0);
            }
            else if (notificationID == 27) //Department Indent 
            {
                All_LoadData.notificationInsert("", roleID, 27, "/Design/Store/InternalStockTransfer.aspx", "Department Request Pending", "f_indent_detail", "IndentNo", "Store", UpdatedID, "", "", tnx, 0);
            }
            else if (notificationID == 28) //Patient Indent
            {
                notification = All_LoadData.notificationInsert("", roleID, 28, "/Design/Store/OPDPharmacyIssue.aspx", "Patient Indent", "f_indent_detail_patient", "IndentNo", "Store", UpdatedID, "", "", tnx, 0);
            }
            else if (notificationID == 29) //Admission Notification
            {
                if (DoctorID != "")
                    notification = All_LoadData.notificationInsert(employee_ID, 52, 29, "/Design/IPD/PatientSearch.aspx", "IPD Admission", "f_ipdadjustment", "TransactionID", "IPD", UpdatedID, DoctorID, notificationDate, tnx, 2);
                else
                    notification = All_LoadData.notificationInsert("", roleID, 29, "/Design/IPD/PatientSearch.aspx", "IPD Admission", "f_ipdadjustment", "TransactionID", "IPD", UpdatedID, "", notificationDate, tnx, 0);
            }
            else if (notificationID == 30) //Purchase Request Transfer
            {
                All_LoadData.notificationInsert("", roleID, 30, "/Design/Store/PurchaseRequestReceive.aspx", "Purchase Request Item Transfer", "f_Stock", "IndentNo", "Store", UpdatedID, "", "", tnx, 0);
            }
            else if (notificationID == 31) //Purchase Order Approval
            {
                All_LoadData.notificationInsert(employee_ID, roleID, 31, "/Design/Store/PurchaseOrderApproval.aspx", "Purchase Order Pending", "f_purchaseorder", "PurchaseOrderNo", "Store", UpdatedID, "", "", tnx, 0);
            }
            else if (notificationID == 32) //Diabetic Patient List
            {
                All_LoadData.notificationInsert(employee_ID, roleID, 32, "/Design/CPOE/DiabiaticPatientList.aspx", "Diabiatic Advice Pending", "Diabiatic_chart", "ID", "Diabiatic", UpdatedID, "", "", tnx, 2);
            }
            else if (notificationID == 33) //Medical Clearence
            {
                notification = All_LoadData.notificationInsert("", 0, 33, "/Design/IPD/PatientSearch.aspx", "Patient Medicine Clearence Pending", "", "TransactionID", "IPD", UpdatedID, "", notificationDate, tnx, 0);
            }
            else if (notificationID == 34) //Room Clearence
            {
                notification = All_LoadData.notificationInsert("", 0, 34, "/Design/IPD/PatientSearch.aspx", "Patient Room Clearence Pending", "", "TransactionID", "IPD", UpdatedID, "", notificationDate, tnx, 0);
            }
            if (notification == 0)
                return "1";
            else
                return "1";
        }
        catch (Exception ex)
        {
            ClassLog log = new ClassLog();
            log.errLog(ex);
            return "";
        }
    }

    public static int activeNotification()
    {


        return 1;
    }

}