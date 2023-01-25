using AjaxControlToolkit;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI.WebControls;

/// <summary>
/// Summary description for AllLoadData_IPD
/// </summary>
public class AllLoadData_IPD
{
    public AllLoadData_IPD()
    {
        //
        // TODO: Add constructor logic here
        //
    }
    public static DataTable BillingCategory()
    {
        return StockReports.GetDataTable("select Name,IPDCaseTypeID,isAttenderRoom from ipd_case_type_master where IsActive=1 and IFNULL(BillingCategoryID,'')<>'' AND CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + "  GROUP BY BillingCategoryID ORDER BY Name");
    }
    public static void bindBillingCategory(DropDownList ddlObject, string type = "", int isAttenderRoom = 0)
    {
        DataTable dtData = new DataTable();
        if ((isAttenderRoom == 0) || (isAttenderRoom == 1))
            dtData = LoadCaseType().AsEnumerable().Where(r => r.Field<int>("isAttenderRoom") == isAttenderRoom).AsDataView().ToTable();
        else
            dtData = BillingCategory();

        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Name";
            ddlObject.DataValueField = "IPDCaseTypeID";
            ddlObject.DataBind();
            if (type != "")
                ddlObject.Items.Insert(0, new ListItem(type, "0"));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
            ddlObject.Items.Clear();
        }

    }
    public static DataTable LoadCaseType(int CentreID=0)
    {
        int centreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
        if (CentreID > 0)
            centreID = CentreID;


        return StockReports.GetDataTable("Select Name,IPDCaseTypeID,isAttenderRoom,IsEmergency from ipd_case_type_master where isActive=1  and CentreID=" + centreID + "  order by name");
    }
    public static void bindCaseType(DropDownList ddlObject, string type = "", int isAttenderRoom = 0, int CentreID = 0)
    {
        DataTable dtData = new DataTable();
        if ((isAttenderRoom == 0) || (isAttenderRoom == 1))
            dtData = LoadCaseType(CentreID).AsEnumerable().Where(r => r.Field<int>("isAttenderRoom") == isAttenderRoom).AsDataView().ToTable();
        else
            dtData = LoadCaseType(CentreID);
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Name";
            ddlObject.DataValueField = "IPDCaseTypeID";
            ddlObject.DataBind();
            if (type != "")
                ddlObject.Items.Insert(0, new ListItem(type, "0"));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
            ddlObject.Items.Clear();
        }
    }
    public static void bindDischargeType(DropDownList ddlObject)
    {
        ddlObject.DataSource = AllGlobalFunction.DischargeType;
        ddlObject.DataBind();

    }
    public static DataTable typeOfDeath()
    {
        return StockReports.GetDataTable("SELECT id,TypeOfDeath FROM typeofDeath where isActive=1");

    }
    public static void bindTypeOfDeath(DropDownList ddlObject, string type = "")
    {
        DataTable dtData = typeOfDeath();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "TypeOfDeath";
            ddlObject.DataValueField = "ID";
            ddlObject.DataBind();
            ddlObject.Items.Insert(0, new ListItem("Select", "0"));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }

    }
    public static DataTable loadBed()
    {
        string str = " SELECT rm.bed_no, CONCAT(rm.bed_no,' ',ictm.name)BedNO FROM room_master rm INNER JOIN ipd_case_type_master ictm ON rm.ipdcasetypeid=ictm.ipdcasetypeid WHERE rm.isactive=1 AND ictm.isactive=1 AND rm.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' ";
        return StockReports.GetDataTable(str);
    }
    public static void bindBed(DropDownList ddlObject, string type = "")
    {
        DataTable dtData = loadBed();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "BedNO";
            ddlObject.DataValueField = "bed_no";
            ddlObject.DataBind();
            if (type != "")
                ddlObject.Items.Insert(0, new ListItem(type, "0"));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }

    }
    public static DataTable loadFloor(int CentreID=0)
    {

        int centreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
        if (CentreID > 0)
            centreID = CentreID;

        string str = " SELECT ID,NAME,SequenceNo FROM floor_master Where CentreID=" + centreID + " ORDER BY SequenceNo+0";
        return StockReports.GetDataTable(str);
    }
    public static void bindFloor(DropDownList ddlObject, string type = "",int centreID=0)
    {
        DataTable dtData = loadFloor(centreID);
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "NAME";
            ddlObject.DataValueField = "ID";
            ddlObject.DataBind();
            if (type != "")
                ddlObject.Items.Insert(0, new ListItem(type, "0"));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }

    }
    public static string getCentreID(string TID)
    {
        return StockReports.ExecuteScalar("SELECT CentreID FROM patient_medical_history WHERE TransactionID='" + TID + "'");
    }
    public static string getActiveCentreID(string TID)
    {
        return StockReports.ExecuteScalar("SELECT ActiveCentreID FROM patient_medical_history WHERE TransactionID='" + TID + "'");//f_ipdadjustment
    }
    public static DataTable loadRoom(string caseType, int IsDisIntimated, string type, string bookingDate)
    {
        // 0 for Admission and 1 for Advance Room Booking
        StringBuilder sb = new StringBuilder();
        if (type == "0")
        {
            //if ( Util.GetInt( caseType) == 43)
            //{
            //    sb.Append(" select distinct CONCAT(RM.Name,'-',RM.Room_No,' /','Bed:',RM.Bed_No,' /',' Floor:',RM.Floor) Name, ");
            //    sb.Append(" RM.RoomId,IF(pip.IsDisIntimated=1,IntimationTime,'')IntimationTime,IF(pip.RoomID IS NULL,'OUT','IN')STATUS ");
            //    sb.Append(" FROM (SELECT RoomID,Name,Room_No,Bed_No,Floor FROM room_master  WHERE IsActive=1 ");
            //    sb.Append(" AND IPDCaseTypeID='" + caseType + "' AND isAttendent=0 AND IsRoomClean=1 AND CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "')rm LEFT JOIN  ");
            //    sb.Append(" (SELECT RoomID,'' IsDisIntimated,'' IntimationTime FROM Emergency_Patient_Details WHERE Isreleased=0 AND IPDCaseTypeID='" + caseType + "' ");

            //    if (IsDisIntimated == 1)
            //        sb.Append("  AND IsDisIntimated=0 ");
            //    sb.Append(" )pip ON pip.RoomID = rm.RoomID Where pip.roomID ");
            //    if (IsDisIntimated == 1)
            //        sb.Append(" IS NOT NULL ");
            //    else
            //        sb.Append(" IS NULL "); 
            //}
            //else
            //{
            sb.Append(" select distinct CONCAT(RM.Name,'-',RM.Room_No,' /','Bed:',RM.Bed_No,' /',' Floor:',RM.Floor) Name, ");
            sb.Append(" RM.RoomId,IF(pip.IsDisIntimated=1,IntimationTime,'')IntimationTime,IF(pip.RoomID IS NULL,'OUT','IN')STATUS ");
            sb.Append(" FROM (SELECT RoomID,Name,Room_No,Bed_No,Floor FROM room_master  WHERE IsActive=1 ");
            sb.Append(" AND IPDCaseTypeID='" + caseType + "' AND isAttendent=0 AND IsRoomClean=1 AND CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "')rm LEFT JOIN  ");
            sb.Append(" ( ");

            sb.Append(" SELECT RoomID,IsDisIntimated,IntimationTime FROM patient_ipd_profile WHERE STATUS='IN' AND IPDCaseTypeID='" + caseType + "' ");
            if (IsDisIntimated == 1)
                sb.Append("  AND IsDisIntimated=0 ");

            sb.Append(" UNION ALL ");
            sb.Append(" SELECT e.`RoomID`,0 AS IsDisIntimated,NULL IntimationTime FROM `emergency_patient_details` e WHERE e.`IsReleased`=0 AND e.`IPDCaseTypeID`='" + caseType + "' ");


            sb.Append(" )pip ON pip.RoomID = rm.RoomID Where pip.roomID ");
            if (IsDisIntimated == 1)
                sb.Append(" IS NOT NULL ");
            else
                sb.Append(" IS NULL ");
            // }

        }
        else
        {
            sb.Append(" SELECT t1.RoomId,t1.Name FROM ( SELECT RoomID,CONCAT(NAME,'-',Room_No,' /','Bed:',Bed_No,' /',' Floor:',FLOOR) `Name` FROM room_master WHERE IsActive=1 AND IPDCaseTypeID='" + caseType + "' AND isAttendent=0 )t1 LEFT JOIN ");
            sb.Append(" ( SELECT RoomID,ID FROM advance_room_booking WHERE IsCancel=0 AND IPDCaseTypeID='" + caseType + "' AND DATE(BookingDate)='" + Util.GetDateTime(bookingDate).ToString("yyyy-MM-dd") + "') t2 ON t1.RoomID=t2.RoomID WHERE t2.ID IS NULL ");
        }

        return StockReports.GetDataTable(sb.ToString());
    }

    public static void bindRoom(DropDownList ddlObject, string caseType, int IsDisIntimated = 0, string type = "")
    {
        DataTable dtData = loadRoom(caseType, IsDisIntimated, "0", "");
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Name";
            ddlObject.DataValueField = "RoomId";
            ddlObject.DataBind();
            if (type != "")
                ddlObject.Items.Insert(0, new ListItem(type, "0"));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }

    }
    public static DataTable bindAdmissionDetails(string PatientID, string TransactionID)
    {
        var roleID = HttpContext.Current.Session["RoleID"].ToString();

        StringBuilder sb = new StringBuilder();//
        sb.Append("select ipd.CreditLimitPanel,IFNULL(ipd.CreditLimitType,'A')CreditLimitType,T.*,PM.*  from (");
        sb.Append("     Select CONCAT(dm.Title,' ',dm.Name )FirstDoc,CONCAT(dm1.Title,' ',dm1.Name ) SecDoc ,dm.DoctorID FirstDocID,dm1.DoctorID SecDocID, ");
        sb.Append("     icm.Name RoomType,icm.IPDCaseTypeID RoomTypeID,icmb.name RoomType_Bill, ");
        sb.Append("     icmb.IPDCaseTypeID RommType_BillID,rm.RoomId,Date_format(pmh.DateOfAdmit,'%d-%b-%Y')DateOfAdmit,Date_format(pmh.TimeOfAdmit,'%l:%i %p')TimeOfAdmit,");
        sb.Append("     DATE_FORMAT(pmh.TimeOfAdmit,'%h')Admithour,DATE_FORMAT(pmh.TimeOfAdmit,'%i')AdmitMin,DATE_FORMAT(pmh.TimeOfAdmit,'%p')AdmitAMPM, ");
        sb.Append("     pmh.AdmissionReason,pmh.Allergies,pmh.Weight,pmh.Height, ");
        sb.Append("     PMH.Visa_No,date_format(PMH.Visa_ExpiryDate,'%d-%b-%Y')Visa_ExpiryDate,PMH.PolicyNo,pmh.CardHolderName,pmh.RelationWith_holder,pmh.MotherTID,");
        sb.Append("     PMH.CardNo,PMH.PanelID,PMH.KinRelation,PMH.KinName,PMH.KinPhone,PMH.ParentID, ");
        sb.Append("     PMH.Source,PMH.ReferedBy,pmh.DiagnosisID,pnl.ReferenceCode,pnl.applyCreditLimit,pmh.ScheduleChargeID, ");
        sb.Append("     PMH.KinAddress,pnl.Company_Name,PMH.TransactionID,pip.PatientIPDProfile_ID,pmh.PatientID, ");
        sb.Append("     PMH.typeofdelivery,PMH.DeliveryWeeks,PMH.PanelIgnoreReason,PMH.MLC_NO,PMH.MLC_Type,PMH.IssuedVisitorCardNo,PMH.Admission_Type,pmh.ProblemType,pmh.Remarks,PMH.IsRoomRequest,PMH.RequestedRoomType,IFNULL(pmh.ProID,0)ProID,IFNULL((SELECT CONCAT(Id,'#',IsMainDoctor,'#',IsDisable) FROM referraltype_master WHERE Id=IF(pmh.ReferralTypeID=0,1,pmh.ReferralTypeID) ),'1#0#1') AS ReferralTypeID   ");
        sb.Append("     From patient_ipd_profile pip   ");//inner join ipd_case_history ich on pip.TransactionID = ich.TransactionID
        sb.Append("      inner join patient_medical_history pmh on pmh.TransactionID = pip.TransactionID ");
        sb.Append("     inner join doctor_master dm on pmh.DoctorID = dm.DoctorID ");//ich.Consultant_ID = dm.DoctorID 
        sb.Append("     left join doctor_master dm1 on pmh.DoctorID1 = dm1.DoctorID ");//ich.Consultant_ID1 = dm1.DoctorID
        sb.Append("     left join ipd_case_type_master icm on icm.IPDCaseTypeID = pip.IPDCaseTypeID ");
        sb.Append("     left join ipd_case_type_master icmB on icmB.IPDCaseTypeID = pip.IPDCaseTypeID_Bill ");
        sb.Append("     inner join room_master rm on rm.RoomId = pip.RoomID ");
       // sb.Append("     inner join patient_medical_history pmh on pmh.TransactionID = ich.TransactionID ");
        sb.Append("     inner join f_panel_master pnl on pnl.PanelID = pmh.PanelID ");
        sb.Append("     Where pip.TransactionID = '" + TransactionID + "' ");
        if (roleID == "181")
        {
            sb.Append("     order by pip.PatientIPDProfile_ID DESC LIMIT 1");
        }
        else
        {
            sb.Append("     and pip.Status='IN' order by pip.PatientIPDProfile_ID DESC LIMIT 1");
        }
        sb.Append(") T inner join (");
        sb.Append("     Select Title , PatientID  AS PatientID1,if(DOB<>'0001-01-01',DOB,'')DOB,PName,PFirstName,PLastName,Passport_No,DATE_FORMAT(Passport_IssueDate,'%d-%b-%Y')Passport_IssueDate,TimeOfBirth,Gender,MaritalStatus,Relation,RelationName,Phone,Mobile,");
        sb.Append("     CONCAT(House_No,Street_Name)Address,Locality,age,City,Country,bloodGroup,Weight,IFNULL(email,'')email,Patient_Category from patient_master ");
        sb.Append("     where PatientID='" + PatientID + "' ");
        sb.Append(")pm on pm.PatientID1 = T.PatientID  INNER JOIN patient_medical_history ipd  ON t.PatientID=ipd.PatientID  ");//left join patient_referredby prb on prb.TransactionID = T.TransactionID");  // INNER JOIN f_ipdadjustment ipd  ON t.PatientID=ipd.PatientID
        return StockReports.GetDataTable(sb.ToString());
    }
    public static DataTable bindAdmittedDoctor(string TID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT pmh1.DoctorID AS DocID,dm1.name AS DocName FROM patient_medical_history pmh1 INNER JOIN ");
        sb.Append(" doctor_master dm1 ON dm1.DoctorID=pmh1.DoctorID WHERE TransactionID='" + TID + "' ");
        sb.Append(" UNION ALL ");
        sb.Append(" SELECT  pmh2.DoctorID1 AS DocID,dm2.name AS DocName FROM patient_medical_history pmh2 INNER JOIN  ");
        sb.Append(" doctor_master dm2 ON dm2.DoctorID=pmh2.DoctorID1  WHERE TransactionID='" + TID + "' ");
        sb.Append(" UNION ALL ");
        sb.Append(" SELECT  mpi.DoctorID AS DocID,dm3.name AS DocName FROM  f_multipledoctor_ipd mpi INNER JOIN  ");
        sb.Append(" doctor_master dm3 ON dm3.DoctorID=mpi.DoctorID WHERE TransactionID='" + TID + "' and mpi.IsActive=1 ");
        return StockReports.GetDataTable(sb.ToString());
    }
    public static string GetScheduleChargeID(int PanelID)
    {
        return StockReports.ExecuteScalar("SELECT ScheduleChargeID FROM f_rate_schedulecharges sc INNER JOIN f_panel_master pm ON pm.ReferenceCode=sc.PanelID WHERE sc.IsDefault=1 AND pm.PanelID='" + PanelID + "'");
    }
    public static DataTable dtAdmissionType()
    {
        return StockReports.GetDataTable("select distinct ADMISSIONTYPE,ID from patient_admission_type where active=1");
    }
    public static void bindAdmissionType(DropDownList ddlObject)
    {
        DataTable dtData = dtAdmissionType();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "ADMISSIONTYPE";
            ddlObject.DataValueField = "ADMISSIONTYPE";
            ddlObject.DataBind();
            ddlObject.Items.Insert(0, new ListItem("Select", "Select"));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }

    }
    public static DataTable patientIPDDetail(string transactionID, DataTable table, string billNo)
    {
        DataTable dtNetAmtWord = new DataTable();
        dtNetAmtWord.TableName = "dtNetAmtWord";
        dtNetAmtWord.Columns.Add("BilledAmt");
        dtNetAmtWord.Columns.Add("ReceivedAmt");
        dtNetAmtWord.Columns.Add("ReceivedAmtBeforeBill");
        dtNetAmtWord.Columns.Add("ReceivedAmtAfterBill");
        dtNetAmtWord.Columns.Add("NetAmount");
        dtNetAmtWord.Columns.Add("NetAmountWord");
        dtNetAmtWord.Columns.Add("DiscountReason");
        dtNetAmtWord.Columns.Add("ShowReceipt");
        dtNetAmtWord.Columns.Add("Narration");
        dtNetAmtWord.Columns.Add("ServiceTaxAmt");
        dtNetAmtWord.Columns.Add("ServiceTaxPer");
        dtNetAmtWord.Columns.Add("ServiceTaxSurChgAmt");
        dtNetAmtWord.Columns.Add("SerTaxSurChgPer");
        dtNetAmtWord.Columns.Add("SerTaxBillAmt");
        dtNetAmtWord.Columns.Add("IsBilledClosed");
        dtNetAmtWord.Columns.Add("Dedutions");
        dtNetAmtWord.Columns.Add("TDS");
        dtNetAmtWord.Columns.Add("WriteOff");
        dtNetAmtWord.Columns.Add("S_Amount");
        dtNetAmtWord.Columns.Add("S_Notation");
        dtNetAmtWord.Columns.Add("C_Factor");
        dtNetAmtWord.Columns.Add("RoundOff");
        dtNetAmtWord.Columns.Add("CreditLimit");
        dtNetAmtWord.Columns.Add("CreditLimitType");
        AllQuery AQ = new AllQuery();
        decimal AmountReceived = Util.GetDecimal(AQ.GetPaidAmount(transactionID));
        decimal AmountBilled = Util.GetDecimal(AQ.GetBillAmount(transactionID, null));
        decimal Dedutions = Util.GetDecimal(AQ.GetTotalDedutions(transactionID));
        decimal TDS = Util.GetDecimal(AQ.GetTDS(transactionID));
        decimal WriteOff = Util.GetDecimal(StockReports.ExecuteScalar("Select WriteOff from Patient_Medical_History where TransactionID='" + transactionID + "'"));

        decimal DiscountOnItem = 0;
        string NetAmount = "";

        DataRow[] DisRow = table.Select("DiscountPercentage > 0 and IsVerified = 1 and IsPackage = 0");

        if (DisRow.Length > 0)
        {
            foreach (DataRow drDis in DisRow)
            {
                DiscountOnItem = DiscountOnItem + (Util.GetDecimal(drDis["Rate"].ToString()) * Util.GetDecimal(drDis["Quantity"].ToString())) - Util.GetDecimal(drDis["Amount"].ToString());
            }
        }

        //if (chkSuppressReceipt.Checked == false)
        //{
        //    NetAmount = Util.GetString(AmountBilled);
        //}
        //else
        //{
        NetAmount = Util.GetString(AmountBilled - AmountReceived);
        // }

        string DiscountReason = "", Narration = "";
        string ServiceTaxPer = "", ServiceTaxAmt = "", ServiceTaxSurChgAmt = "", SerTaxSurChgPer = "", SerTaxBillAmt = "";
        string SAmount = "", SNotation = "", CFactor = "";
        decimal RoundOff = 0; decimal CreditLimit = 0; string CreditLimitType = "";
        //Checking if final discount is allowed



        DataTable dt = AQ.GetPatientAdjustmentDetails(transactionID);


        if (dt != null && dt.Rows.Count > 0)
        {
            NetAmount = Util.GetString((Util.GetDecimal(NetAmount)) - (Util.GetDecimal(dt.Rows[0]["DiscountOnBill"].ToString()) + (Util.GetDecimal(DiscountOnItem))));
            DiscountReason = Util.GetString(dt.Rows[0]["DiscountOnBillReason"].ToString());
            Narration = Util.GetString(dt.Rows[0]["Narration"].ToString());
            SAmount = Util.GetString(dt.Rows[0]["S_Amount"].ToString());
            SNotation = Util.GetString(dt.Rows[0]["S_Notation"].ToString());
            CFactor = Util.GetString(dt.Rows[0]["C_Factor"].ToString());
            CreditLimit = Util.GetDecimal(dt.Rows[0]["CreditLimitPanel"].ToString());
            CreditLimitType = Util.GetString(dt.Rows[0]["CreditLimitType"].ToString());

            if (billNo == string.Empty)
            {

                ServiceTaxPer = Util.GetString(All_LoadData.GovTaxPer()).ToString();
                SerTaxSurChgPer = "0";

                ServiceTaxAmt = "";
                ServiceTaxSurChgAmt = "";

                AmountBilled = Util.GetDecimal((Util.GetDecimal(AmountBilled)) - (Util.GetDecimal(dt.Rows[0]["DiscountOnBill"].ToString()) + (Util.GetDecimal(DiscountOnItem))));
                ServiceTaxAmt = Util.GetString(Util.round((Util.GetDecimal((Util.GetDecimal(AmountBilled)) * Util.GetDecimal(ServiceTaxPer)) / 100)));
                decimal SurchargeTaxAmt = Util.GetDecimal(Util.round((Util.GetDecimal((Util.GetDecimal(ServiceTaxAmt) * Util.GetDecimal(SerTaxSurChgPer)) / 100))));
                NetAmount = Util.GetString(Util.GetDecimal(NetAmount) + Util.GetDecimal(ServiceTaxAmt) + SurchargeTaxAmt);
                ServiceTaxSurChgAmt = SurchargeTaxAmt.ToString();
                SerTaxBillAmt = AmountBilled.ToString();
                decimal Round = Util.round((Util.GetDecimal(AmountBilled)) + (Util.GetDecimal(ServiceTaxAmt)));
                RoundOff = Util.GetDecimal(Round) - (Util.GetDecimal(AmountBilled)) - (Util.GetDecimal(ServiceTaxAmt));
            }
            else
            {
                ServiceTaxAmt = Util.GetString(dt.Rows[0]["ServiceTaxAmt"]);
                ServiceTaxPer = Util.GetString(dt.Rows[0]["ServiceTaxPer"]);
                ServiceTaxSurChgAmt = Util.GetString(dt.Rows[0]["ServiceTaxSurChgAmt"]);
                SerTaxSurChgPer = Util.GetString(dt.Rows[0]["SerTaxSurChgPer"]);
                SerTaxBillAmt = Util.GetString(dt.Rows[0]["SerTaxBillAmount"]);

                NetAmount = Util.GetString(Util.GetDecimal(NetAmount) + Util.GetDecimal(dt.Rows[0]["ServiceTaxAmt"]) + Util.GetDecimal(dt.Rows[0]["ServiceTaxSurChgAmt"]));
                RoundOff = Util.GetDecimal(dt.Rows[0]["RoundOff"]);
            }

        }
        decimal ReceivedAmtBeforeBill = 0, ReceivedAmtAfterBill = 0;

        if (Util.GetDateTime(dt.Rows[0]["BillDate"]).ToString("yyyy-MM-dd") != "0001-01-01")
        {
            string st = "SELECT SUM(AmountPaid) FROM f_reciept WHERE TransactionID ='" + transactionID + "' AND IsCancel = 0 and Date(Date) <='" + Util.GetDateTime(dt.Rows[0]["BillDate"]).ToString("yyyy-MM-dd") + "' GROUP BY TransactionID ";
            ReceivedAmtBeforeBill = Util.GetDecimal(StockReports.ExecuteScalar("SELECT SUM(AmountPaid) FROM f_reciept WHERE TransactionID ='" + transactionID + "' AND IsCancel = 0 and Date(Date) <='" + Util.GetDateTime(dt.Rows[0]["BillDate"]).ToString("yyyy-MM-dd") + "' GROUP BY TransactionID "));
        }
        else
        {
            ReceivedAmtBeforeBill = Util.GetDecimal(StockReports.ExecuteScalar("SELECT SUM(AmountPaid) FROM f_reciept WHERE TransactionID ='" + transactionID + "' AND IsCancel = 0 GROUP BY TransactionID "));

        }
        ReceivedAmtAfterBill = Util.GetDecimal(StockReports.ExecuteScalar("SELECT SUM(AmountPaid) FROM f_reciept WHERE TransactionID ='" + transactionID + "' AND IsCancel = 0 and Date(Date) >'" + Util.GetDateTime(dt.Rows[0]["BillDate"]).ToString("yyyy-MM-dd") + "' GROUP BY TransactionID "));


        DataRow row = dtNetAmtWord.NewRow();
        row["BilledAmt"] = AmountBilled.ToString();
        row["ReceivedAmt"] = AmountReceived.ToString();
        row["NetAmount"] = NetAmount;
        row["DiscountReason"] = DiscountReason;
        row["Narration"] = Narration;
        row["ServiceTaxAmt"] = ServiceTaxAmt;
        row["ServiceTaxPer"] = ServiceTaxPer;
        row["ServiceTaxSurChgAmt"] = ServiceTaxSurChgAmt;
        row["SerTaxSurChgPer"] = SerTaxSurChgPer;
        row["SerTaxBillAmt"] = SerTaxBillAmt;
        row["Dedutions"] = Dedutions;
        row["TDS"] = TDS;
        row["WriteOff"] = WriteOff;
        row["S_Amount"] = SAmount;
        row["S_Notation"] = SNotation;
        row["C_Factor"] = CFactor;
        row["RoundOff"] = RoundOff;
        row["CreditLimit"] = CreditLimit;
        row["CreditLimitType"] = CreditLimitType;

        row["ShowReceipt"] = "0";


        row["IsBilledClosed"] = Util.GetString(dt.Rows[0]["IsBilledClosed"]);


        row["ReceivedAmtBeforeBill"] = Util.GetString("0");
        row["ReceivedAmtAfterBill"] = Util.GetString("0");

        dtNetAmtWord.Rows.Add(row);

        if (dtNetAmtWord.Rows.Count > 0)
        {

            if (dtNetAmtWord.Columns.Contains("PanelAppRemarks") == false) dtNetAmtWord.Columns.Add("PanelAppRemarks");
            dtNetAmtWord.Rows[0]["PanelAppRemarks"] = StockReports.ExecuteScalar("Select PanelAppRemarks from patient_medical_history where TransactionID='" + transactionID + "'");//f_ipdAdjustment
            if (dtNetAmtWord.Columns.Contains("PanelApprovedAmt") == false) dtNetAmtWord.Columns.Add("PanelApprovedAmt");
            dtNetAmtWord.Rows[0]["PanelApprovedAmt"] = StockReports.ExecuteScalar("Select IFNULL(PanelApprovedAmt,0)PanelApprovedAmt from patient_medical_history where TransactionID='" + transactionID + "'");//f_ipdAdjustment
            string NetAmount1 = dtNetAmtWord.Rows[0]["NetAmount"].ToString();
            if (NetAmount1 == "") NetAmount1 = "0";
            if (Util.GetFloat(NetAmount1) < 0)
            {
                NetAmount1 = NetAmount1.Remove(0, 1);
            }
            NetAmount1 = Util.GetString((Util.GetDecimal(NetAmount1)));
            dtNetAmtWord.Rows[0]["NetAmountWord"] = StockReports.ChangeNumericToWords(Util.GetString((Util.GetDecimal(dtNetAmtWord.Rows[0]["NetAmount"].ToString()))));
            dtNetAmtWord.Rows[0]["IsBilledClosed"] = StockReports.ExecuteScalar("Select IsBilledClosed from patient_medical_history where TransactionID='" + transactionID + "'");//f_ipdadjustment

        }


        return dtNetAmtWord;
    }
    public static DataTable IPDDebitNote(string TransactionID)
    {
        DataTable dtdebit = new DataTable();

        System.Text.StringBuilder sb = new System.Text.StringBuilder();
        sb.Append(" SELECT sum(Amount)NetAmount,TransactionID,CONVERT(GROUP_CONCAT(CrDrNo),CHAR)CrDrNo FROM f_drcrnote  ");
        sb.Append(" WHERE CRDR='DR01' AND TransactionID='" + TransactionID + "' group by TransactionID");
        dtdebit = StockReports.GetDataTable(sb.ToString());


        if (dtdebit != null && dtdebit.Rows.Count == 0)
        {
            DataRow dr = dtdebit.NewRow();
            dr["NetAmount"] = "0";
            dr["TransactionID"] = TransactionID;
            dr["CrDrNo"] = "";
            dtdebit.Rows.Add(dr);
            dtdebit.AcceptChanges();
        }
        return dtdebit;
    }

    public static DataTable IPDReceipt(string TransactionID)
    {
        DataTable dtReceipt = new DataTable();
        AllQuery AQ = new AllQuery();
        dtReceipt = AQ.GetPatientReceipt(TransactionID);
        if (dtReceipt != null && dtReceipt.Rows.Count == 0)
        {
            DataRow dr = dtReceipt.NewRow();
            dr["ReceiptNo"] = "";
            dr["AmountPaid"] = "0";
            dr["Date"] = "";
            dr["Type"] = "";
            dr["TransactionID"] = TransactionID;
            dtReceipt.Rows.Add(dr);
        }

        return dtReceipt;
    }

    public static DataTable patientIPDHeader(string PatientID, string transactionID)
    {
        DataTable dtHeader = IPDBilling.getPatientHeaderForReport1(PatientID, transactionID);
        if (dtHeader.Rows.Count > 0)
        {
            if (dtHeader.Columns.Contains("DiscountOnBill") == false) dtHeader.Columns.Add("DiscountOnBill");
            if (dtHeader.Columns.Contains("UserName") == false) dtHeader.Columns.Add("UserName");
            if (dtHeader.Columns.Contains("LoginName") == false) dtHeader.Columns.Add("LoginName");

            AllQuery AQ = new AllQuery();

            DataTable dt1 = AQ.GetPatientAdjustmentDetails(transactionID);

            if (dt1 != null && dt1.Rows.Count > 0)
            {
                DataTable dtuser = AQ.GetUserinformation(dt1.Rows[0]["UserID"].ToString().Trim());
                string Username = "", LoginName = "";
                if (dtuser != null && dtuser.Rows.Count > 0)
                {
                    Username = dtuser.Rows[0]["UserName"].ToString();
                    LoginName = dtuser.Rows[0]["LoginName"].ToString();
                }
                else
                {
                    Username = HttpContext.Current.Session["LoginName"].ToString();
                    LoginName = HttpContext.Current.Session["UserName"].ToString();
                }
                if (dt1.Rows[0]["DiscountOnBill"].ToString().Trim() != "")
                {
                    dtHeader.Rows[0]["DiscountOnBill"] = dt1.Rows[0]["DiscountOnBill"].ToString().Trim();
                    dtHeader.Rows[0]["UserName"] = Username;
                    dtHeader.Rows[0]["LoginName"] = LoginName;
                }
                else
                {
                    dtHeader.Rows[0]["DiscountOnBill"] = "0";
                    dtHeader.Rows[0]["UserName"] = Username;
                    dtHeader.Rows[0]["LoginName"] = LoginName;
                }
            }
            if (dtHeader.Columns.Contains("ParentComp") == false) dtHeader.Columns.Add("ParentComp");
            if (dtHeader.Columns.Contains("IsServiceTax") == false) dtHeader.Columns.Add("IsServiceTax");
            if (dtHeader.Columns.Contains("PanelID") == false) dtHeader.Columns.Add("PanelID");

            DataTable dtPnl = StockReports.GetDataTable("Select pm.Company_Name,Pm.ParentID,pnl.IsServiceTax," +
                " pnl.PanelID from (Select PanelID,ParentID from patient_medical_history pmh where " +
                " TransactionID='" + transactionID + "')Pmh inner join " +
                " f_panel_master pm on pm.PanelID = pmh.ParentID inner join f_panel_master pnl on pmh.PanelID = pnl.PanelID");

            if (dtPnl != null && dtPnl.Rows.Count > 0)
            {
                dtHeader.Rows[0]["ParentComp"] = dtPnl.Rows[0]["Company_Name"].ToString();
                if (dtPnl.Rows[0]["IsServiceTax"].ToString().ToUpper() == "TRUE")
                    dtHeader.Rows[0]["IsServiceTax"] = "1";
                else if (dtPnl.Rows[0]["IsServiceTax"].ToString().ToUpper() == "FALSE")
                    dtHeader.Rows[0]["IsServiceTax"] = "0";
                else
                    dtHeader.Rows[0]["IsServiceTax"] = dtPnl.Rows[0]["IsServiceTax"].ToString();

                if (dtPnl.Rows[0]["PanelID"].ToString().ToUpper() == "TRUE")
                    dtHeader.Rows[0]["PanelID"] = "1";
                else if (dtPnl.Rows[0]["PanelID"].ToString().ToUpper() == "FALSE")
                    dtHeader.Rows[0]["PanelID"] = "0";
                else
                    dtHeader.Rows[0]["PanelID"] = dtPnl.Rows[0]["PanelID"].ToString();
            }

            dtHeader.Rows[0]["ClaimNo"] = StockReports.ExecuteScalar("Select ClaimNo from patient_medical_history where TransactionID='" + transactionID + "'");//f_ipdAdjustment
        }

        return dtHeader;
    }

    public static DataTable IPDCreditNote(string TransactionID)
    {
        DataTable dtCredit = new DataTable();
        System.Text.StringBuilder sb1 = new System.Text.StringBuilder();
        sb1.Append(" SELECT sum(Amount)NetAmount,TransactionID,CONVERT(GROUP_CONCAT(CrDrNo),CHAR)CrDrNo FROM f_drcrnote ");
        sb1.Append(" WHERE CRDR='CR01' AND TransactionID='" + TransactionID + "' group by TransactionID");


        dtCredit = StockReports.GetDataTable(sb1.ToString());


        if (dtCredit != null && dtCredit.Rows.Count == 0)
        {
            DataRow dr = dtCredit.NewRow();
            dr["NetAmount"] = "0";
            dr["TransactionID"] = TransactionID;
            dr["CrDrNo"] = "";
            dtCredit.Rows.Add(dr);
            dtCredit.AcceptChanges();
        }

        return dtCredit;
    }

    public static DataTable getIPDThreshold(string PatientID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT th.ThresholdLimit,IFNULL(ROUND((t2.GrossAmt-t2.TDiscount),2),0)NetAmt,ROUND(IFNULL(t3.RecAmt,0.00),2)RecAmt ");
        sb.Append("  FROM  IPD_Threshold  th INNER JOIN patient_medical_history ich  ON ich.TransactionID=th.TransactionID LEFT JOIN (  ");//ipd_case_history
        sb.Append("      SELECT ltd.TransactionID,SUM(ltd.Rate*ltd.Quantity)GrossAmt, ");
        sb.Append("      IFNULL(ROUND(SUM(((ltd.Rate*ltd.Quantity)*ltd.DiscountPercentage)/100) +IFNULL(PMH.DiscountOnBill,0),2),0)TDiscount FROM f_ledgertnxdetail ltd    ");
       // sb.Append("      INNER JOIN f_ipdadjustment ipd ON ipd.TransactionID=ltd.TransactionID  INNER JOIN ipd_case_history ich  ON ipd.TransactionID=ich.TransactionID ");
        sb.Append(" INNER JOIN patient_medical_history PMH ON PMH.TransactionID=ltd.TransactionID   ");
        sb.Append("      WHERE  ltd.IsFree = 0 AND ltd.IsVerified = 1  AND ltd.IsPackage = 0 AND PMH.PatientID='" + PatientID + "' AND PMH.Status='IN'  GROUP BY PMH.TransactionID  ");
        sb.Append("      )T2  ON t2.TransactionID=th.TransactionID  LEFT JOIN ( ");
        sb.Append("      SELECT TransactionID,SUM(AmountPaid)RecAmt FROM f_reciept WHERE IsCancel = 0   AND depositor = '" + PatientID + "'   ");
        sb.Append("      GROUP BY TransactionID   )T3 ON T2.TransactionID = T3.TransactionID");
        sb.Append("      WHERE th.PatientID='" + PatientID + "'  AND th.IsActive=1 AND ich.Status='IN'  ");
        return StockReports.GetDataTable(sb.ToString());
    }

    public static DataTable IpdServices(string Typename)
    {
        string CategoryID = "2,6,7,8,9,10,20,14,26,27";
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT CONCAT(IFNULL(im.ItemCode,''),' # ',IM.TypeName)TypeName,CONCAT(IFNULL(IM.ItemID,''),'#',IFNULL(IM.SubCategoryID,''),'#', IFNULL(SC.Name,''),'#',IFNULL(Type_ID,''))ItemID,IM.SubCategoryID,SC.CategoryID FROM f_itemmaster im INNER JOIN f_subcategorymaster sc ON im.SubCategoryID = sc.SubCategoryID INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID LEFT JOIN f_item_outsource io ON im.ItemID = io.ItemID AND io.IsActive=1 WHERE im.IsActive=1 AND cf.ConfigID IN (" + CategoryID + ") AND io.ItemID IS NULL ");
        sb.Append(" AND im.TypeName LIKE '%" + Typename + "%' ");
        sb.Append(" ORDER BY TypeName");
        return StockReports.GetDataTable(sb.ToString());
    }
    public static DataTable bindIPDInvestigation(string Typename, string IPDCaseTypeID, string ReferenceCode)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT TypeName,CONCAT(ItemId,'#',IF(Rate IS NULL,0,Rate),'#',IF(ItemDisplayName IS NULL,'',ItemDisplayName),'#',IF(ItemCode IS NULL,'',ItemCode))ItemId FROM ( ");
        sb.Append("    SELECT CONCAT(IFNULL(im.ItemCode,''),' # ',im.TypeName)TypeName,CONCAT(IM.ItemID,'#',IM.Type_ID,'#',IM.SubCategoryID)ItemId,RL.Rate,RL.ItemDisplayName,RL.ItemCode ");
        sb.Append("    FROM f_itemmaster IM INNER JOIN f_subcategorymaster sub ON  IM.SubCategoryID=sub.SubCategoryID ");
        sb.Append("    INNER JOIN f_configrelation cf ON cf.CategoryID = sub.CategoryID ");
        sb.Append("    LEFT JOIN ( ");
        sb.Append("        SELECT ItemID,Rate,ItemDisplayName,ItemCode FROM f_ratelist_ipd WHERE  IPDCaseTypeID='" + IPDCaseTypeID + "' ");
        sb.Append("        AND ScheduleChargeID='14' AND PanelID= " + ReferenceCode + " and IsCurrent=1 ");
        sb.Append("    ) RL ON RL.ItemID=IM.ItemID WHERE cf.ConfigID=3 AND im.Isactive=1  ");
        sb.Append("    and im.TypeName like '%" + Typename + "%' ");
        sb.Append("    ORDER BY TypeName ");
        sb.Append(")t1 ");
        return StockReports.GetDataTable(sb.ToString());

    }

    public static int IPDBillAuthorization(string Employee_ID, int RoleID)
    {
        return Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM UserAuthorization_IPDBill WHERE IsActive=1 AND EmployeeID='" + Employee_ID + "' AND RoleID='" + RoleID + "'"));

    }

    public static DataTable getAttendendAvailRoom(string IPDCaseTypeID)
    {
        try
        {
            string sql = "SELECT DISTINCT CONCAT(RM.Name,' /',RM.Room_No,' /','Bed:',RM.Bed_No,' /',' Floor:',RM.Floor) Name,RM.RoomId from room_master RM Where RM.IPDCaseTypeID = '" + IPDCaseTypeID + "' and RM.RoomID NOT IN (SELECT DISTINCT RoomID from patient_attender_profile WHERE Status='IN') AND RM.ISActive=1";

            return StockReports.GetDataTable(sql);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public static DataTable getPatientIPDInformation(string TranactionID)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT PMH.PatientID,PMH.DoctorID,PMH.ScheduleChargeID,CONCAT(RM.Floor,'/',RM.Name)RoomNo,PMH.TransactionID, PMH.PanelID,PIP.IPDCaseTypeID,PIP.RoomID,PMH.Patient_Type PatientType,PMH.PatientTypeID PatientTypeID ");
        sb.Append(" FROM ( ");
        sb.Append("       SELECT TransactionID,RoomID,IPDCaseTypeID_Bill IPDCaseTypeID FROM patient_ipd_profile WHERE TransactionID = '" + TranactionID + "' ORDER BY PatientIPDProfile_ID DESC LIMIT 1) PIP, ");
        sb.Append("      (  ");
        sb.Append("       SELECT PatientID,TransactionID,PanelID,DoctorID,ScheduleChargeID,Patient_Type,PatientTypeID FROM patient_medical_history WHERE  TransactionID = '" + TranactionID + "' and Type='IPD' )PMH, ");
        sb.Append("  ");
        sb.Append(" room_master RM WHERE PMH.TransactionID = PIP.TransactionID AND PIP.RoomID = RM.RoomID  ");


        return StockReports.GetDataTable(sb.ToString());

    }
    public static string getPatientPanelID(string TranactionID, MySqlConnection con)
    {
        if (con != null)
            return Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, " Select PanelID FROM patient_medical_history WHERE  TransactionID = '" + TranactionID + "' and Type='IPD' "));
        else
            return Util.GetString(StockReports.ExecuteScalar(" Select PanelID FROM patient_medical_history WHERE  TransactionID = '" + TranactionID + "' and Type='IPD' "));


    }
    public static DataTable getRoleIDWithCaseTypeID(string IPDCaseType_ID)
    {
        return StockReports.GetDataTable(" SELECT Role_ID FROM f_RoomType_role WHERE IPDCaseTypeID='" + IPDCaseType_ID + "' group by Role_ID ");
    }
    public static DataTable getAdmitDischargeData(string TID)
    {
        return StockReports.GetDataTable("SELECT DateofAdmit,TimeofAdmit,DateofDischarge,TimeofDischarge,DoctorID,DoctorID1,TransactionID, STATUS FROM patient_medical_history Where TransactionID='" + TID + "'");//ipd_case_history
    }
    public static void bindDeliveryDetails(DropDownList deliveryWeeks, DropDownList deliveryDays, DropDownList deliveryType)
    {
        deliveryWeeks.DataSource = AllGlobalFunction.DeliveryWeeks;
        deliveryWeeks.DataBind();

        deliveryDays.DataSource = AllGlobalFunction.DeliveryDays;
        deliveryDays.DataBind();

        deliveryType.DataSource = AllGlobalFunction.DeliveryType;
        deliveryType.DataBind();
    }

    public static int getIPDBilledClosed(string TransactionID)
    {
        return Util.GetInt(StockReports.ExecuteScalar("SELECT IsBilledClosed from patient_medical_history Where TransactionID = '" + TransactionID + "'"));//f_ipdadjustment
    }

    public static DataTable getIPDBillDetail(string TransactionID)
    {
        return StockReports.GetDataTable("SELECT IFNULL(Billno,'')Billno,PatientID,IsBilledClosed,TransactionID from patient_medical_history  Where TransactionID = '" + TransactionID + "'");//f_ipdadjustment
    }

    public static void fromDatetoDate(string TID, TextBox ucDate, TextBox toDate, CalendarExtender calucDate, CalendarExtender caltoDate)
    {
        AllQuery aq = new AllQuery();
        DateTime AdmitDate = Util.GetDateTime(aq.getAdmitDate(TID));
        DateTime dischargeDate = Util.GetDateTime(AllQuery.getDischargeDate(TID));
        string disDate = Util.GetString(dischargeDate.ToString("dd-MM-yyyy"));
        if (Util.GetString(dischargeDate.ToString("dd-MM-yyyy")) == "01-01-0001")
        {
            ucDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            toDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            caltoDate.EndDate = DateTime.Now;
            calucDate.EndDate = DateTime.Now;
        }
        else
        {
            ucDate.Text = dischargeDate.ToString("dd-MMM-yyyy");
            toDate.Text = dischargeDate.ToString("dd-MMM-yyyy");
            caltoDate.EndDate = Util.GetDateTime(dischargeDate.ToString("dd-MMM-yyyy"));
            calucDate.EndDate = Util.GetDateTime(dischargeDate.ToString("dd-MMM-yyyy"));
        }
        calucDate.StartDate = Util.GetDateTime(AdmitDate.ToString("dd-MMM-yyyy"));
        caltoDate.StartDate = Util.GetDateTime(AdmitDate.ToString("dd-MMM-yyyy"));
    }
    public static int findSurgery(string TransactionID)
    {
        return Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*)  FROM  f_ledgertnxdetail ltd WHERE  ltd.IsSurgery=1  AND ltd.TransactionID='" + TransactionID + "'  AND ltd.IsVerified=1"));
    }
    public static DataTable dtBindRoom()
    {
        return StockReports.GetDataTable("select Name,IPDCaseTypeID from ipd_case_type_master where IsActive=1 AND CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "'");
    }
    public static void BindRoom(DropDownList ddlObject, string Type = "")
    {
        DataTable dtData = dtBindRoom();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Name";
            ddlObject.DataValueField = "IPDCaseTypeID";
            ddlObject.DataBind();
            if (Type != "")
                ddlObject.Items.Insert(0, new ListItem(Type, "0"));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }
    public static DataTable getIPDTotalDiscount(string TransactionID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT (IFNULL(DiscountOnBill,0)+IFNULL(ItemDisc,0))TotalDisc,IFNULL(ItemDisc,0)ItemDisc,IFNULL(DiscountOnBill,0)DiscountOnBill,BillNo,PanelApprovedAmt,RoundOff FROM (");
        sb.Append("     SELECT DiscountOnBill,IFNULL(BillNo,'')BillNo,TransactionID,ifnull(PanelApprovedAmt,0)PanelApprovedAmt,IFNULL(RoundOff,0)RoundOff,FileClose_flag ");
        sb.Append("     FROM patient_medical_history  WHERE TransactionID='" + TransactionID + "'");//f_ipdAdjustment
        sb.Append(" )adj INNER JOIN (");
        sb.Append("     SELECT SUM(TotalDiscAmt)ItemDisc,TransactionID FROM f_ledgertnxdetail");
        sb.Append("     WHERE TransactionID='" + TransactionID + "' AND IsVerified=1 AND IsPackage=0 GROUP BY TransactionID");
        sb.Append(" ) ltd ON adj.TransactionID = ltd.TransactionID");

        return StockReports.GetDataTable(sb.ToString()).Copy();

    }

    public static decimal getIPDNonPayableAmt(string TransactionID)
    {
        return Util.GetDecimal(StockReports.ExecuteScalar("SELECT SUM(Amount)Amount FROM f_ledgertnxdetail WHERE ispayable=1 AND IsVerified=1 AND TransactionID='" + TransactionID + "' "));
    }

    public static decimal getPatientPaidAmount(string TransactionID)
    {
        return Util.GetDecimal(StockReports.ExecuteScalar("SELECT IFNULL(Round(sum(AmountPaid),2),0) PaidAmount from f_reciept WHERE TransactionID='" + TransactionID + "' AND IsCancel = 0 AND PaidBy='PAT'"));
    }
    public static decimal GetAllocationAmount(string TransactionID)
    {
        return Util.GetDecimal(StockReports.ExecuteScalar("SELECT SUM(Amount) FROM panel_amountallocation WHERE TransactionID='" + TransactionID + "'"));
    }
    public static decimal getPatientWrieoffAmount(string TransactionID)
    {
        return Util.GetDecimal(StockReports.ExecuteScalar(" Select IFNULL(Round(sum(WriteOffAmount),2),0)Writeoff from f_writeoff where TransactionID='" + TransactionID + "'"));
    }
    public static DataTable dtbindDoctor()
    {
        return StockReports.GetDataTable("SELECT dm.DoctorID,UPPER(CONCAT(dm.Title,' ',dm.Name))Name,dm.Designation Department,dm.DocDepartmentID,dm.Specialization,dm.docGroupID FROM doctor_master dm INNER JOIN f_center_doctor fcp ON dm.DoctorID=fcp.DoctorID WHERE dm.IsActive = 1 AND fcp.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' AND fcp.isActive=1 ORDER BY dm.Name");
    }
    public static void BindDoctorIPD(DropDownList ddlObject, string Type = "")
    {
        DataTable dtData = dtbindDoctor();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Name";
            ddlObject.DataValueField = "DoctorID";
            ddlObject.DataBind();
            if (Type != "")
                ddlObject.Items.Insert(0, new ListItem(Type, "0"));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }
    public static DataTable bindProMaster()
    {
        return StockReports.GetDataTable("select ProName,pro_id from f_pro_master where isActive=1");
    }

    public static DataTable getIPDPanelDiscPer(int PanelID, string ItemID, int patientTypeID)
    {
        return StockReports.GetDataTable("CALL  GetPanelItemDisc_Copay_Payble ('" + ItemID + "'," + PanelID + "," + patientTypeID + ")");


        // return Util.GetDecimal(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT Percentage discPer from f_panelDisc where isActive=1 AND PanelID='" + PanelID + "' AND ItemID='" + ItemID + "' AND Type='" + Type + "' "));
        //        else { 

        //}
        //            return Util.GetDecimal(StockReports.ExecuteScalar("SELECT Percentage discPer from f_panelDisc where isActive=1 AND PanelID='" + PanelID + "' AND ItemID='" + ItemID + "' AND Type='" + Type + "' "));
    }
    public static DataTable getIPDItemRate(string ItemID, string PanelID, string IPDCaseTypeID, string ScheduleChargeID)
    {
        return StockReports.GetDataTable("SELECT ID,Rate,RateListID,ItemID,PanelID,ItemDisplayName,ItemCode,ScheduleChargeID FROM f_ratelist_ipd rl WHERE IsCurrent = 1 AND ItemID='" + ItemID + "' AND PanelID = " + PanelID + " AND IPDCaseTypeID='" + IPDCaseTypeID + "' AND ScheduleChargeID=" + ScheduleChargeID + " ");
    }
    public static DataTable LoadIPDPatientDetail(string PID, string TID)
    {
        AllQuery AQ = new AllQuery();
        DataTable dt = AQ.GetPatientIPDInformation(PID, TID);
        return dt;
    }

    public static DataTable LoadEMGPatientDetail(string PID, string TID)
    {
        AllQuery AQ = new AllQuery();
        DataTable dt = AQ.GetPatientEMGInformation(PID, TID);
        return dt;
    }
    public static DataTable SearchPatient(string PatientId, string PatientName, string TransactionId, string RoomID, string DoctorID, string Company, string FromAdmitDate, string ToAdmitDate, string DischargeDateFrom, string DischargeDateTo, string VisitDateFrom, string VisitDateTo, string status, string LabNo, string Department, string AgeFrom, string AgeTo, string ParentPanel, string Floor, string FromIntimationDate, string ToIntimationDate, string AdmitDischarge, string Type, int IsPatientReceived, string UserType, string UserID, int onlyOutStandingPatient, string CombineDrId = "")
    {

        try
        {


            string PanelGroupIDs = Util.GetString(StockReports.ExecuteScalar(" SELECT IFNULL(r.`PanelGroupID`,'0') FROM f_centre_role_panelgroup_mapping r WHERE r.`RoleID`=" + HttpContext.Current.Session["RoleID"].ToString() + " AND r.`CentreID`=" + HttpContext.Current.Session["CentreID"].ToString() + " AND r.`isActive`=1 ORDER BY r.`ID` DESC  LIMIT 1 "));
            if (PanelGroupIDs == string.Empty)
                PanelGroupIDs = "0";

            if (AgeFrom.Contains("YR") == true)
                AgeFrom = Util.GetString(Math.Round(Util.GetDecimal(Util.GetFloat(AgeFrom.Replace("YRS", "").Trim()) * 365)));
            else if (AgeFrom.Contains("DAY") == true)
                AgeFrom = Util.GetString(Math.Round(Util.GetDecimal(Util.GetFloat(AgeFrom.Replace("DAY(S)", "").Trim()) * 1)));
            else if (AgeFrom.Contains("MON") == true)
                AgeFrom = Util.GetString(Math.Round(Util.GetDecimal(Util.GetFloat(AgeFrom.Replace("MONTH(S)", "").Trim()) * 30)));

            if (AgeTo.Contains("YR") == true)
                AgeTo = Util.GetString(Math.Round(Util.GetDecimal(Util.GetFloat(AgeTo.Replace("YRS", "").Trim()) * 365)));
            else if (AgeFrom.Contains("DAY") == true)
                AgeTo = Util.GetString(Math.Round(Util.GetDecimal(Util.GetFloat(AgeTo.Replace("DAY(S)", "").Trim()) * 1)));
            else if (AgeFrom.Contains("MON") == true)
                AgeTo = Util.GetString(Math.Round(Util.GetDecimal(Util.GetFloat(AgeTo.Replace("MONTH(S)", "").Trim()) * 30)));


            int iCheck = 0;
            //if (TransactionId != "" || PatientId != "" || PatientName != "")
            if (TransactionId != "" || PatientId != "")
                iCheck = 1;

            StringBuilder sb = new StringBuilder();
            sb.Append("");

            sb.Append(" Select  (SELECT GROUP_CONCAT(CONCAT(pp.IDProofName,' : ',pp.IDProofNumber)) FROM PatientID_proofs pp WHERE pp.PatientID=t2.PatientID)PatientIDProofNumber ,   IFNULL((select ifnull(CodeType,'')CodeType from codemaster cm where cm.id=t2.PatientCodeType),'')PatientCode,Ifnull((SELECT dm1.name FROM f_multipledoctor_ipd fip inner join doctor_master dm1   WHERE fip.DoctorID=dm1.doctorid AND fip.TransactionID=t2.TransactionID AND dm1.isunit=1 and fip.IsActive=1 LIMIT 1),'')TeamName,IFNULL((select CONCAT('Temp: ',ipo.Temp,' Pulse: ',ipo.Pulse,' BP: ',ipo.Bp,' Resp: ',ipo.Resp,' SPO2: ',ipo.Oxygen)Vitial from IPD_Patient_ObservationChart ipo where TransactionID=t2.TransactionID ORDER BY ID DESC LIMIT 1),'')Vital, ");
            sb.Append(" IFNULL((SELECT CONCAT(Title,' ',NAME)DoctorName FROM employee_master dm WHERE dm.EmployeeID=ds.FirstcallDoctorID),'')FirstCall, ");
            sb.Append(" IFNULL((SELECT CONCAT(Title,' ',NAME)DoctorName FROM employee_master dm WHERE dm.EmployeeID=pna.NurseID),'')PrimaeryNurse, t2.DoctorID, t2.PatientType,CONCAT(t2.Title, ' ',t2.PName)PName,t2.PatientID,t2.Gender,");
            sb.Append(" ifnull((SELECT pv.ID FROM ipd_prescriptionvisit pv WHERE pv.TransactionID=t2.TransactionID and DATE(pv.CreatedOn)=CURDATE() AND pv.DoctorID=(SELECT DoctorID FROM doctor_employee WHERE Employeeid='" + HttpContext.Current.Session["ID"].ToString() + "' LIMIT 1)),'')App_ID, ");

            sb.Append(" (SELECT  COUNT(tdmo.Id) FROM tenwek_docotor_medicine_order tdmo WHERE tdmo.PatientId=t2.PatientID AND tdmo.TransactionId=t2.TransactionID AND tdmo.IsView=0 AND tdmo.IsDisContinue=0  AND tdmo.IsIndentDone=0 AND tdmo.IsActive=1) MedsCount, ");
            sb.Append(" (SELECT  COUNT(tdmo.Id)  FROM notecreationpatient_detail tdmo WHERE tdmo.PatientID=t2.PatientID AND tdmo.TransactionID=t2.TransactionID AND tdmo.IsView=0) NotesCount, ");

            sb.Append(" (SELECT  COUNT(tdmo.Id)  FROM patient_labinvestigation_opd tdmo INNER JOIN investigation_master im ON im.Investigation_ID=tdmo.Investigation_Id INNER JOIN f_ledgertnxdetail ltd ON ltd.ID=tdmo.LedgertnxID AND ltd.IsVerified<>2 WHERE tdmo.IsView=0 AND   tdmo.PatientID=t2.PatientID AND tdmo.TransactionID=t2.TransactionID) LabsCount, ");
             
            if (onlyOutStandingPatient == 1)
            {
                sb.Append("IPDPatientOutstanding(t2.TransactionID) IPDOutstanding, ");
                sb.Append("( SELECT DATE_FORMAT(ion.SendOn,'%d-%b-%Y %I:%i %p')   FROM   ipd_outstanding_notify ion WHERE ion.NotifyThrough='Email' AND ion.TransactionID=t2.TransactionID ORDER BY ion.SendOn DESC  LIMIT 1)LastEmail ,");
                sb.Append("( SELECT DATE_FORMAT(ion.SendOn,'%d-%b-%Y %I:%i %p')   FROM   ipd_outstanding_notify ion WHERE ion.NotifyThrough='SMS' AND ion.TransactionID=t2.TransactionID ORDER BY ion.SendOn DESC  LIMIT 1)LastSMS ,");


            }

            sb.Append("CONCAT(t2.House_No,'',t2.Street_Name,'',t2.City)Address,t2.Mobile, t2.email,");
            sb.Append("t2.Age,t2.TransactionID, t2.TransNo IPDNO,dm.Name as DName,rm.Name as RName,fpm.Company_Name,t2.Name as BillingCategory,");
            sb.Append("CONCAT(t2.DateOfAdmit,' ',t2.TimeOfAdmit)AdmitDate,CONCAT(t2.DateOfDischarge,' ',t2.TimeOfDischarge)DischargeDate,t2.Status,");
            sb.Append("CONCAT(t2.Age,' / ',t2.Gender)AgeSex,CONCAT(rm.Room_No,'/',rm.Bed_No,'/',rm.Name)RoomName,t2.IPDCaseTypeID,fpm.ReferenceCode,t2.PanelID,t2.ScheduleChargeID,t2.kinPhone, ");
            sb.Append(" IF(IFNULL((SELECT SUM(AmountPaid) FROM f_reciept WHERE TransactionID=t2.TransactionID AND IsCancel=0),0)=0,'0',IF(IFNULL((SELECT SUM(amount) ");
            sb.Append(" FROM f_ledgertnxdetail WHERE TransactionID=t2.TransactionID AND IsVerified=1 AND IsPackage=0),0) - IFNULL((SELECT SUM(AmountPaid) ");
            sb.Append("  FROM f_reciept WHERE TransactionID=t2.TransactionID AND IsCancel=0),0) > IFNULL((SELECT amount FROM f_thresholdlimit ");
            sb.Append("  WHERE IsActive=1 AND PanelID=fpm.ReferenceCode AND Room_Type=t2.IPDCaseTypeID LIMIT 1),0),'1','2')) amtpaid, dm.Designation Department,  ");
            sb.Append("t2.BillNo,t2.Relation,(Select Name from employee_master where employeeID=t2.UserID)AdmittedBy, ");
            sb.Append("(case when t2.IsBilledClosed=1 then 'Bill Finalised' when t2.IsBilledClosed=0 and IFNULL(t2.BillNo,'')!='' then 'Bill Not-Finalised'  when t2.Status='IN' then 'Admitted' else 'Discharged' end)BillStatus,");
            sb.Append("t2.IsBilledClosed,IF(emr.header IS NULL,'0','1') AS DischargeSummary,IsPatientReceived ,");
            sb.Append(" (SELECT IF(newua.ColValue IS NULL,'0','1') CanReceivePatient FROM userauthorization newua WHERE newua.EmployeeId='" + UserID + "' AND newua.roleid='" + HttpContext.Current.Session["RoleID"].ToString() + "' AND newua.CentreID='" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + "' AND newua.ColName='CanReceivePatient' limit 1) userauthorization ");
            sb.Append(",IF(rn.ID IS NULL,0,1)RadiologyNotification, IFNULL((SELECT CONCAT(em.`Title`,' ',em.`NAME`)NAME FROM `patient_ipd_profile` d ");
            sb.Append(" INNER JOIN employee_master em ON em.`EmployeeID`=d.`PatReceivedBy` WHERE d.`TransactionID`=t2.TransactionID AND d.`IsPatientReceived`<>0 ORDER BY PatientIPDProfile_ID DESC LIMIT 1),'')IsReceivedBy ");
            sb.Append("from (");
            sb.Append("     Select t1.*,IF(t1.KinRelation='',CONCAT(pm.Relation,'(',pm.RelationName,')'),t1.KinRelation) AS Relation,pm.ID,pm.Title,PName,Gender,House_No,Street_Name,Locality,City,PinCode,Age,pm.Mobile,pm.email ");//pm.PatientID
            sb.Append("     from (Select pip.PatientID,pip.IPDCaseTypeID,pip.IPDCaseTypeID_Bill,pip.RoomID,");
            sb.Append("      UPPER(pmh.`patient_type`) AS PatientType ,pmh.TransNo, ");

            sb.Append("     pip.TransactionID,pip.Status,pip.IsDisIntimated,Date_Format(pmh.DateOfAdmit,'%d-%b-%Y')DateOfAdmit,");
            sb.Append("     Time_format(pmh.TimeOfAdmit,'%l:%i %p')TimeOfAdmit,pmh.DoctorID,pmh.PanelID,pmh.ScheduleChargeID,");
            sb.Append("     if(pmh.DateOfDischarge='0001-01-01','-',Date_Format(pmh.DateOfDischarge,'%d-%b-%Y'))DateOfDischarge,");
            sb.Append("     if(pmh.TimeOfDischarge='00:00:00','',Time_format(pmh.TimeOfDischarge,'%l: %i %p'))TimeOfDischarge,pmh.PatientCodeType, ");
            sb.Append("     if(pmh.KinName <>'',CONCAT(pmh.KinName,'(',pmh.KinRelation,')'),'')KinRelation,pmh.kinPhone,pmh.UserID,ictm2.Name,pip.IsPatientReceived,pmh.BillNo,pmh.IsBilledClosed,pmh.IsMedCleared from (");
            sb.Append("         Select pip1.PatientIPDProfile_ID,pip1.PatientID,pip1.IPDCaseTypeID,pip1.IntimationTime,");
            sb.Append("         pip1.IPDCaseTypeID_Bill,pip1.RoomID,pip1.TransactionID,pip1.Status,pip1.IsDisIntimated,pip1.IsPatientReceived ");
            sb.Append("         from patient_ipd_profile pip1 inner join (");
            sb.Append("             Select max(PatientIPDProfile_ID)PatientIPDProfile_ID ");
            sb.Append("             from patient_ipd_profile ");
            if (TransactionId != "")
                sb.Append("         Where TransactionID='" + TransactionId + "'  and ucase(status) <> 'CANCEL' ");
            else
                sb.Append("         Where status = '" + status + "' ");
            if (PatientId != "")
                sb.Append("         and PatientID='" + PatientId + "'");
            if (RoomID != "")
                sb.Append("         and IPDCaseTypeID in (" + RoomID + ")");

            sb.Append("             group by TransactionID ");
            sb.Append("        )pip2 on pip1.PatientIPDProfile_ID = pip2.PatientIPDProfile_ID ");

            //// Only in case of Nurse this nurse wise (nurse assignment) patient  will be search else all patient will be search ignoring nurse assignement
            //if (UserType.ToUpper() == "NURSE")
               //sb.Append(" INNER JOIN patient_nurse_assignment pna on pna.TransactionID = pip1.TransactionID and pna.NurseID='" + UserID + "' AND IFNULL(AssignmentDateOUT,'') ='' ");


            // In Case of IsPatientReceived =2 means search ALL data i.e whethere patient received or not received fetch all
            if (IsPatientReceived == 0)
                sb.Append(" Where IsPatientReceived=0");

            if (IsPatientReceived == 1)
                sb.Append(" Where IsPatientReceived=1");

            sb.Append("     )pip  inner join patient_medical_history pmh on pmh.TransactionID = pip.TransactionID and pmh.Type='IPD' ");//inner join ipd_case_history ich on pip.TransactionID = ich.TransactionID


            if (onlyOutStandingPatient == 1)
                sb.Append("  and pmh.status = 'OUT' ");//ich.status



            sb.Append("inner join ipd_case_type_master ictm2 on ictm2.IPDCaseTypeID = pip.IPDCaseTypeID_Bill ");
            //sb.Append("     inner join patient_medical_history pmh on pmh.TransactionID = ich.TransactionID and pmh.Type='IPD' ");

            if (DoctorID != "0" || !string.IsNullOrEmpty(CombineDrId))
                sb.Append(" LEFT JOIN f_multipledoctor_ipd mdoc ON mdoc.transactionID= pmh.TransactionID  ");
            sb.Append(" WHERE pmh.CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " ");
            if (TransactionId != "")
                sb.Append("         AND pmh.TransactionID='" + TransactionId + "' ");//ich
            else
                sb.Append("         AND pmh.status = '" + status + "' ");//ich
            if (FromAdmitDate != "" && ToAdmitDate != "")
                sb.Append(" and pmh.DateOfAdmit >= '" + FromAdmitDate + "' and pmh.DateOfAdmit <= '" + ToAdmitDate + "'");//ich
            else if (FromAdmitDate != "" && ToAdmitDate == "")
                sb.Append(" and pmh.DateOfAdmit >= '" + FromAdmitDate + "'");//ich
            else if (FromIntimationDate != "" && ToIntimationDate != "")
                sb.Append(" and Date(pip.IntimationTime) >= '" + FromIntimationDate + "' AND Date(pip.IntimationTime) <= '" + ToIntimationDate + "'");
            if (ParentPanel != "0")
                sb.Append(" and pmh.ParentID ='" + ParentPanel + "'");
            if (iCheck == 0)
            {
                if (DischargeDateFrom != "" && DischargeDateTo != "")
                    sb.Append(" and pmh.DateOfDischarge >= '" + DischargeDateFrom + "' and pmh.DateOfDischarge <= '" + DischargeDateTo + "'");//ich
                else if (DischargeDateFrom != "" && DischargeDateTo == "")
                    sb.Append(" and pmh.DateOfDischarge >= '" + DischargeDateFrom + "'");//ich
            }
            if (Company != "0" && Type == "0")
                sb.Append(" and PanelID=" + Company + " ");
            else if (Type == "1")
                sb.Append(" and PanelID<>1 ");
            if (DoctorID != "0")
                sb.Append(" and pmh.DoctorID = '" + DoctorID + "'  OR pmh.DoctorID1='" + DoctorID + "' OR mdoc.DoctorID='" + DoctorID + "'  ");

            if (!string.IsNullOrEmpty(CombineDrId))
            {
                sb.Append(" And pmh.DoctorID in  (" + CombineDrId + ") OR pmh.DoctorID1 in  (" + CombineDrId + ") OR mdoc.DoctorID in  (" + CombineDrId + ") ");
            }
            
            
            sb.Append(") t1 inner join  patient_master pm  ");
            sb.Append("on t1.PatientID = pm.PatientID ");
            sb.Append("Where pm.PatientID <>'' ");
            if (PatientId != "")
                sb.Append(" and pm.PatientID='" + PatientId + "'");
            if (PatientName != "" && PatientId == "")
                sb.Append(" and pname like '%" + PatientName + "%'");
            if (AgeFrom != "")
            {
                sb.Append(" and (Case when Age like '%Yr%' then trim(Replace(Age,'YRS',''))*365 ");
                sb.Append(" when Age like '%DAY%' then trim(Replace(Age,'DAY(S)',''))*1  ");
                sb.Append(" when Age like '%MON%' then trim(Replace(Age,'MON',''))*30 end) >= '" + AgeFrom + "'");
            }

            if (AgeTo != "")
            {
                sb.Append(" and (Case when Age like '%Yr%' then trim(Replace(Age,'YRS',''))*365 ");
                sb.Append(" when Age like '%DAY%' then trim(Replace(Age,'DAY(S)',''))*1  ");
                sb.Append(" when Age like '%MON%' then trim(Replace(Age,'MON',''))*30 end) <= '" + AgeTo + "'");
            }
            sb.Append(" ) t2 ");
            //sb.Append("inner join f_ipdadjustment adj on adj.TransactionID = T2.TransactionID ");
            sb.Append("Left JOIN emr_ipd_details emr ON emr.TransactionID = T2.TransactionID ");
            sb.Append("LEFT JOIN radiology_accepatance_notification rn ON rn.TransactionID=t2.TransactionID AND rn.IsActive=1 ");
            sb.Append(" LEFT JOIN f_doctotreatingteam ds ON ds.TransactionID=t2.TransactionID  AND ds.STATUS='IN' ");
            sb.Append(" LEFT JOIN patient_nurse_assignment pna ON pna.TransactionID = t2.TransactionID AND pna.STATUS=0 ");

            sb.Append(" inner join doctor_master dm on t2.doctorID = dm.DoctorID ");
            if (Department != "ALL")
                sb.Append(" AND dm.Designation= '" + Department + "' ");
            sb.Append("inner join room_master rm on rm.RoomId = t2.roomid ");
            sb.Append(" Inner join Floor_master flm on flm.name=rm.Floor ");
            sb.Append(" inner join f_panel_master fpm on fpm.PanelID = t2.PanelID ");
            if (PanelGroupIDs != "0")
                sb.Append(" and fpm.PanelGroupID IN(" + PanelGroupIDs + ") ");

            if (AdmitDischarge.ToUpper() == "BNF" && TransactionId == "")
                sb.Append(" Where t2.IsBilledClosed=0 and IFNULL(BillNo,'')<>'' ");
            if (AdmitDischarge.ToUpper() == "BF" && TransactionId == "")
                sb.Append(" Where t2.IsBilledClosed=1 and IFNULL(BillNo,'')<>'' ");
            if (AdmitDischarge.ToUpper() == "ID" && TransactionId == "")
                sb.Append(" Where t2.IsDisIntimated=1 AND t2.STATUS = 'IN' ");
            if (AdmitDischarge.ToUpper() == "PC" && TransactionId == "")
                sb.Append(" Where t2.IsMedCleared=0 AND t2.IsDisIntimated=1 AND t2.STATUS = 'IN' ");
            if (Floor != "")
                sb.Append(" And flm.ID in (" + Floor + ")");

            // sb.Append(" order by Replace(T2.TransactionID,'ISHHI','')+000000 desc,t2.ID , t2.PName, t2.PatientID");
            //if (!string.IsNullOrEmpty(CombineDrId))
            //{
            //    sb.Append(" And t2.DoctorID in  (" + CombineDrId + ")");
            //}


            sb.Append(" GROUP BY T2.TransactionID ");

            if (onlyOutStandingPatient == 1)
                sb.Append(" HAVING IPDOutstanding>0 ");


           // sb.Append("  order by Replace(T2.TransactionID,'ISHHI','')+000000 desc,t2.ID , t2.PName, t2.PatientID");
            sb.Append("  order by rm.Name,rm.Bed_No+0  ASC,t2.ID , t2.PName, t2.PatientID");

		//System.IO.File.WriteAllText (@"D:\Hospedia\aa.txt", sb.ToString());
            DataTable Items = StockReports.GetDataTable(sb.ToString());
            return Items;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }

    public static string CheckProvisionalDiagnosis(string TransactionID)
    {
        return Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM cpoe_PatientDiagnosis WHERE TransactionID='" + TransactionID + "' ")).ToString();
    }
    public static int CheckDataPostToFinance(string TransactionID)
    {
        return Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM `finance`.revenue$detail l WHERE l.TRANSNO='" + TransactionID + "'  ")); //AND l.TRANTYPE='R'

        return 0;
    }
    public static int CheckCollectionPostToFinance(string ReceiptNo)
    {
        return Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM finance.`payment$detail` l WHERE l.RECEIPTNO='" + ReceiptNo + "'  "));
    }
    public static int CheckAllocationPostToFinance(string TransactionID)
    {
        return Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM finance.`panel$revenue` l WHERE l.TRANSNO='" + TransactionID + "'  "));
    }
    public static int CheckWriteoffPostToFinance(string TransactionID)
    {
        return Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM finance.`writeoff$detail` l WHERE l.TRANSNO='" + TransactionID + "'  "));
    }
    public static int CheckBillGenerate(string TransactionID,string Type)
    {
        if (Type == "IPD")
            return Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM patient_medical_history adj WHERE adj.TransactionID='" + TransactionID + "' AND IFNULL(adj.BillNo,'')<>''"));//f_ipdadjustment
        else
            return Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_ledgertransaction lt WHERE lt.TransactionID='" + TransactionID + "' AND IFNULL(lt.BillNo,'')<>'' "));
    }

    public static string GetAllTeamId(string DID)
    {

        string NewId = "";
        string s = StockReports.ExecuteScalar(" SELECT GROUP_CONCAT(ud.UnitDoctorID)UnitDoctorID FROM unit_doctorlist ud WHERE  ud.DoctorListId IN (" + DID + ")");



        if (!string.IsNullOrEmpty(s))
        {
            string[] IDs = s.Split(',');

            foreach (string item in IDs)
            {
                NewId+="'"+item+"'";
            }

            NewId += "," + DID;
        }
        else
        {
            NewId = DID;
        }

        return NewId;
    }

}