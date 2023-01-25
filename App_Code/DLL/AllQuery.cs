using System;
using System.Data;
using System.IO;
using System.Text;
using System.Web;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for AllQuery
/// </summary>
public class AllQuery
{
    public AllQuery()
    {
        objCon = Util.GetMySqlCon();
        IsLocalConn = true;
    }
    public AllQuery(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #region All Global Variables
    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;
    #endregion
    public DataSet GoodsReceiptNoteReport(string LTNo, string storeledgerno)
    {
        try
        {
            string sql = "";
            sql += " select a.*,b.rem,b.iscancel,b.isDeal  from (";
            sql += " select T.*,em.Name from (select  LTD. NetAmount,ltd.ItemStatus,IsExpirable,ltd.CancelReason,ltd.IsVerified, if(IsFree=1,'Yes','No')IsFree ,LTD.Rate RateBuy,LTD.UserID UserID,St.GRNo as LedgerTransactionNo, IM.ItemID,IM.BillingUnit as Unit,ST.UNITTYPE, St.StockID,St.Naration,St.IsPost,St.GRNDate , St.GRNo ,IM.ItemName, St.BatchNumber,Date_Format(St.MedExpiryDate,'%d-%b-%y')MedExpiryDate, St.RecQnty ,St.Type, St.Rate, St.MRP , ltd.DiscountPercentage,ltd.DiscAmt, ";
            // GST Changes
            sql += "ltd.HSNCode,ltd.IGSTPercent,ltd.IGSTAmt,ltd.CGSTPercent,ltd.CGSTAmt,ltd.SGSTPercent,ltd.SGSTAmt  ";
            //--
            sql += " FROM (select ItemID,(Typename)AS ItemName,isexpirable,BillingUnit,UnitType from f_itemmaster where ItemID in (select ItemID from f_stock where  LedgerTransactionNo = '" + LTNo + "' and storeledgerNo='" + storeledgerno + "'))IM, ((select StockID,Naration,IsPost,StockDate as GRNDate , LedgerTransactionNo as GRNo ,ItemID,BatchNumber, MedExpiryDate, (InitialCount /IFNULL(ConversionFactor,0)) as RecQnty ,Rate, MRP,if(MajorUnit is null,UNITTYPE,MajorUnit)UNITTYPE,Type   from f_stock where LedgerTransactionNo = '" + LTNo + "' and storeledgerNo='" + storeledgerno + "'))St, (select IF(IsVerified=3,'Rejected','NotRejected')ItemStatus,CancelReason,IsVerified,IsFree ,ItemID,StockID,DiscountPercentage,Rate, Amount as NetAmount,UserID,DiscAmt , ";
            // GST Changes
            sql += "IFNULL(HSNCode,'')HSNCode,IGSTPercent,IGSTAmt,CGSTPercent,CGSTAmt,SGSTPercent,SGSTAmt ";

            sql += " from f_ledgertnxdetail where LedgerTransactionNo = '" + LTNo + "')LTD where LTD.StockID = st.StockID and  LTd.ItemID = st.ItemID  and  IM.ItemID = st.ItemID)T inner join  employee_master em on em.EmployeeID=T.UserID";
            sql += " )a LEFT join ( select sum((pod.approvedqty-pod.recievedqty))rem, pod.itemid,t.iscancel,t.isDeal from (select againstpono,ltd.ItemID,iscancel,ConversionFactor,nms.isDeal from f_ledgertransaction lt inner join f_ledgertnxdetail ltd on lt.LedgerTransactionNo=ltd.LedgerTransactionNo and ltd.LedgerTransactionNo = '" + LTNo + "' INNER JOIN f_stock nms ON nms.StockID=ltd.StockID  AND nms.storeledgerNo='" + storeledgerno + "')t inner join f_purchaseorderdetails pod on t.againstpono=pod.purchaseorderno and t.itemid=pod.itemid group by pod.itemid)b on a.ItemID=b.itemid ";
            DataSet ds = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, sql);
            return ds;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public DataTable GetSubCategoryByCategory(string Category)
    {
        try
        {
            DataView SubCategoryView = LoadCacheQuery.loadSubCategory().DefaultView;
            SubCategoryView.RowFilter = "CategoryID in ('" + Category + "')";
            return SubCategoryView.ToTable();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public DataTable GetSubCategoryByConfigID(string ConfigID)
    {
        try
        {
            DataView SubCategoryView = LoadCacheQuery.loadSubCategory().DefaultView;
            SubCategoryView.RowFilter = "ConfigID in ('" + ConfigID + ")";
            return SubCategoryView.ToTable();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public DataTable GetDoctorDetails(string TnxID)
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "select DoctorID,Name,Specialization from doctor_referal where DoctorID =(select DoctorID from patient_medical_history where TransactionID ='" + TnxID + "')";
            if (this.objTrans != null && this.objCon == null)
                Items = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, strQuery).Tables[0];
            else if (this.objCon != null && this.objTrans == null)
                Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public DataTable LoadSubCategoryType()
    {
        try
        {
            DataView SubCategoryView = LoadCacheQuery.loadSubCategory().DefaultView;
            SubCategoryView.RowFilter = "ConfigID=1";
            return SubCategoryView.ToTable();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public string UpdateRatelist(string Type, decimal Rate, string RateID, string ItemID, string PanelID, string ScheduleChargeID, string CentreID)
    {
        try
        {
            string Items = "";
            string sql = "";
            if (Type.ToUpper() == "INSERT")
            {
                RateList objRate = new RateList();
                objRate.Rate = Util.GetDecimal(Rate);
                objRate.ItemID = Util.GetString(ItemID);
                objRate.IsCurrent = Util.GetInt(1);
                objRate.PanelID = PanelID;
                objRate.ScheduleChargeID = Util.GetInt(ScheduleChargeID);
                objRate.CentreID = Util.GetInt(CentreID);
                string RT = objRate.Insert();
                if (RT != "")
                    return "1";
            }
            else if (Type.ToUpper() == "UPDATE")
                sql = "update f_ratelist set Rate=" + Rate + " where RateListID='" + RateID + "'";
            else if (Type.ToUpper() == "DELETE")
                sql = "Delete from f_ratelist where RateListID='" + RateID + "'";
            if (IsLocalConn)
            {
                this.objCon.Open();
                Items = Util.GetString(MySqlHelper.ExecuteScalar(objCon, CommandType.Text, sql));
                this.objCon.Close();
                return "1";
            }
            else
                return "";
        }
        catch (Exception ex)
        {
            if (this.objCon.State == ConnectionState.Open) this.objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
    }
    public DataTable PatientDetail(string PatientID, string CRNo, string PName, string Type)
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "";
            if (Type == "OUT")
            {
                strQuery = "select ICH.TransactionID,PIP.PatientID,PM.PName,concat(PM.House_No,' ',PM.Street_Name,PM.City)as Address,FPM.Company_Name,ICTM.Name as CaseType ,RM.Room_No,PIP.RoomID from patient_medical_history ICH inner join patient_ipd_profile PIP on ICH.TransactionID=PIP.TransactionID inner join ipd_case_type_master ICTM on PIP.IPDCaseTypeID=ICTM.IPDCaseTypeID inner join room_master RM on  PIP.RoomId=RM.RoomId inner join f_panel_master FPM on PIP.PanelID=FPM.PanelID inner join patient_master PM on PIP.PatientID=PM.PatientID where ICH.Status='OUT' and PIP.status='OUT'";
                if (PatientID != "")
                    strQuery = strQuery + " and PIP.PatientID='" + PatientID + "'";
                if (PName != "")
                    strQuery = strQuery + " and PM.PName like '" + PName + "%'";
                if (CRNo != "")
                    strQuery = strQuery + " and ICH.TransactionID='" + CRNo + "'";
                strQuery = strQuery + " group by pip.TransactionID having max(startdate) and max(starttime)";
            }
            else if (Type == "Held")
            {
                strQuery = "select ICH.TransactionID,PIP.PatientID,PM.PName,concat(PM.House_No,'',PM.Street_Name,PM.City)as Address,FPM.Company_Name,ICTM.Name as CaseType ,RM.Room_No,PIP.RoomID from patient_medical_history ICH inner join patient_ipd_profile PIP on ICH.TransactionID=PIP.TransactionID inner join ipd_case_type_master ICTM on PIP.IPDCaseTypeID=ICTM.IPDCaseTypeID inner join room_master RM on  PIP.RoomId=RM.RoomId inner join f_panel_master FPM on PIP.PanelID=FPM.PanelID inner join patient_master PM on PIP.PatientID=PM.PatientID where ICH.Status='" + Type + "' and PIP.status='" + Type + "'";
                if (PatientID != "")
                    strQuery = strQuery + " and PIP.PatientID='" + PatientID + "'";
                if (PName != "")
                    strQuery = strQuery + " and PM.PName like '" + PName + "%'";
                if (CRNo != "")
                    strQuery = strQuery + " and ICH.TransactionID='" + CRNo + "'";
            }
            else if (Type == "OpenHeld")
            {
                strQuery = "select ICH.TransactionID,PIP.PatientID,PM.PName,concat(PM.House_No,'',PM.Street_Name,PM.City)as Address,FPM.Company_Name,ICTM.Name as CaseType ,RM.Room_No,PIP.RoomID from patient_medical_history ICH inner join patient_ipd_profile PIP on ICH.TransactionID=PIP.TransactionID inner join ipd_case_type_master ICTM on PIP.IPDCaseTypeID=ICTM.IPDCaseTypeID inner join room_master RM on  PIP.RoomId=RM.RoomId inner join f_panel_master FPM on PIP.PanelID=FPM.PanelID inner join patient_master PM on PIP.PatientID=PM.PatientID where ICH.Status='" + Type + "' and PIP.status='" + Type + "'";
                if (PatientID != "")
                    strQuery = strQuery + " and PIP.PatientID='" + PatientID + "'";
                if (PName != "")
                    strQuery = strQuery + " and PM.PName like '" + PName + "%'";
                if (CRNo != "")
                    strQuery = strQuery + " and ICH.TransactionID='" + CRNo + "'";
            }
            else
            {
                strQuery = "select ICH.TransactionID,PIP.PatientID,PM.PName,concat(PM.House_No,'',PM.Street_Name,PM.City)as Address,FPM.Company_Name,ICTM.Name as CaseType ,RM.Room_No,PIP.RoomID from patient_medical_history ICH inner join patient_ipd_profile PIP on ICH.TransactionID=PIP.TransactionID inner join ipd_case_type_master ICTM on PIP.IPDCaseTypeID=ICTM.IPDCaseTypeID inner join room_master RM on  PIP.RoomId=RM.RoomId inner join f_panel_master FPM on PIP.PanelID=FPM.PanelID inner join patient_master PM on PIP.PatientID=PM.PatientID where ICH.Status='IN' and PIP.status='" + Type + "'";
                if (PatientID != "")
                    strQuery = strQuery + " and PIP.PatientID='" + PatientID + "'";
                if (PName != "")
                    strQuery = strQuery + " and PM.PName like '" + PName + "%'";
                if (CRNo != "")
                    strQuery = strQuery + " and ICH.TransactionID='" + CRNo + "'";
            }
            Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];
            if (Items != null)
            {
                if (IsLocalConn)
                    this.objCon.Close();
                return Items;
            }
            else
            {
                if (IsLocalConn)
                    if (objCon.State == ConnectionState.Open) objCon.Close();
                return null;
            }
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public static string GetPatientIPDProfilel(string TransactionID, MySqlConnection con)
    {
        return Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT max(PatientIPDProfile_ID)as PatientIPDProfile_ID from patient_ipd_profile where TransactionID ='ISHHI" + TransactionID + "' "));
    }
    public DataTable GetBillDetail(string PatientID, string PatientName, string CRNO)
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "";
            strQuery = "select distinct(IP.BillNo),IP.TotalBilledAmt,LT.TransactionID,LT.PatientID from f_ipdadjustment IP inner join f_ledgertransaction LT on IP.BillNo=LT.BillNo inner join patient_master PM on LT.PatientID=PM.PatientID";
            if (PatientID != "")
                strQuery = strQuery + " and LT.PatientID='" + PatientID + "'";
            if (PatientName != "")
                strQuery = strQuery + " and PM.PName like '" + PatientName + "%'";
            if (CRNO != "")
                strQuery = strQuery + " and LT.TransactionID='" + CRNO + "'";
            Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];
            if (Items != null)
            {
                if (IsLocalConn)
                    this.objCon.Close();
                return Items;
            }
            else
            {
                if (IsLocalConn)
                    if (objCon.State == ConnectionState.Open) objCon.Close();
                return null;
            }
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public DataTable GetPanelCompanyRefOPDDoc()
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "SELECT RTRIM( LTRIM(Company_Name)) as Company_Name,PanelID,ReferenceCode,ReferenceCodeOPD from f_panel_master Where PanelID in (Select distinct(ReferenceCodeOPD) from f_panel_master) order by Company_Name";
            Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public DataTable GetPanelCompanyRef()
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "SELECT  RTRIM(LTRIM(Company_Name)) as Company_Name,PanelID,ReferenceCode,ReferenceCodeOPD from f_panel_master Where PanelID in (Select distinct(ReferenceCode) from f_panel_master) order by Company_Name";
            Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public decimal GetBillAmount(string TID, MySqlConnection con) // Gaurav 17.06.2018
    {
        StringBuilder sb = new StringBuilder();
        //  sb.Append("SELECT SUM(PaidAmount)PaidAmount FROM ( ");
       // sb.Append(" SELECT CONVERT(SUM(GrossAmount),DECIMAL(10,4)) PaidAmount FROM f_ledgertnxdetail WHERE TransactionID='" + TID + "' AND IsVerified = 1 AND IsPAckage=0 ");
	sb.Append(" SELECT CONVERT(SUM(GrossAmount),DECIMAL(14,4)) PaidAmount FROM f_ledgertnxdetail WHERE TransactionID='" + TID + "' AND IsVerified = 1 AND IsPAckage=0 ");
        // sb.Append(" UNION ALL ");


        // sb.Append(" SELECT CONVERT(SUM(Rate * Quantity),DECIMAL(10,2)) PaidAmount FROM f_ledgertransaction lt ");
        // sb.Append(" INNER JOIN f_ledgertnxdetail ltd ON lt.TransactionID=ltd.TransactionID WHERE lt.IPNo='" + TID + "' AND ltd.IsVerified = 1 AND ltd.IsPAckage=0 ");
        //sb.Append(")t ");

        try
        {
            decimal Amoumt = 0;
            if (con == null)
                Amoumt = Util.GetDecimal(StockReports.ExecuteScalar(sb.ToString()));
            else
                Amoumt = Util.GetDecimal(MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString()));
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            return Amoumt;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return 0;
        }
    }
    public decimal GetPaidAmount(string TID)
    {
        return Util.GetDecimal(MySqlHelper.ExecuteScalar(objCon, CommandType.Text, "SELECT IFNULL(ROUND(SUM(AmountPaid),2),0) PaidAmount FROM (SELECT AmountPaid FROM f_reciept WHERE TransactionID='" + TID + "' AND IsCancel = 0 AND Paidby='PAT' AND IsEdit=0 UNION ALL SELECT AmountPaid FROM f_reciept_log WHERE TransactionID='" + TID + "' AND IsCancel = 0 AND Paidby='PAT' )t "));
    }
    public decimal GetPanelApprovalAmount(string TID)
    {
        return Util.GetDecimal(MySqlHelper.ExecuteScalar(objCon, CommandType.Text, " SELECT ROUND(IFNULL(SUM(a.PanelApprovedAmt),0),4)PanelApprovedAmt FROM f_IpdPanelApproval a WHERE a.isActive=1 AND a.TransactionID='" + TID + "' "));
    }
    public decimal GetPaidAmountAfterBill(string TID)
    {
        return Util.GetDecimal(MySqlHelper.ExecuteScalar(objCon, CommandType.Text, "SELECT IFNULL(Round(sum(AmountPaid),2),0) PaidAmount from f_reciept where TransactionID='" + TID + "' and IsCancel = 0 AND Paidby='PAT' "));
    }
    public DataTable GetPMHByTransactionID(string TransactionID)
    {
        DataTable Items = new DataTable();
        try
        {
            Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, "SELECT PatientID,DoctorID,Hospital_ID,PanelID from patient_medical_history Where TransactionID='" + TransactionID + "'").Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return null;
        }
    }
    public DataTable GetPatientAdjustmentDetails(string TransactionID)
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "";
            strQuery = "Select PatientID,TransactionID,PatientLedgerNo,IFNULL(BillNo,'')BillNo,DateofAdjustment,TotalBilledAmt,DiscountOnBill,DiscountOnBillReason,AdjustmentAmt,AdjustmentReason,UserID,FileClose_flag,ApprovalBy,TempBillNo,Narration,TDS, " +
                " ServiceTaxAmt,ServiceTaxPer ,ServiceTaxSurChgAmt ,SerTaxSurChgPer ,SerTaxBillAmount ,TotalBillDiscPer ,CreditLimitPanel ,PatientCashAmt , " +
                " PanelApprovedAmt ,PanelApprovalDate ,PanelAppRemarks ,PanelAppUserID ,IsBilledClosed ,PanelAppRemarksHistory ,ClaimNo ,BillingRemarks ,LastUpdatedBy ,Updatedate , " +
                " IpAddress ,DiscUserID ,BillingType ,BillClosedUserId ,BillCloseddate ,BillDate ,DoctorID ,PanelID ,IsMedCleared ,MedClearedBy ,MedClearedDate ,S_CountryID ,IFNULL( S_Amount,0)S_Amount ,S_Notation ,C_Factor , " +
                " RoundOff ,CreditLimitType ,Hospital_ID ,CentreID ,Patient_Type ,CurrentAge ,panelInvoiceNo,IsBillFreezed from patient_medical_history Where TransactionID = '" + TransactionID + "'";//f_ipdadjustment

            Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return null;
        }
    }
    public DataTable GetPatientIPDInformation(string PatientID, string TranactionID)
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "";
            strQuery = "Select pmh.DischargeType,ifnull(DATE_FORMAT(pm.MemberShipDate,'%d-%b-%y'),'')MemberShipDate, IF(DATE(pm.MemberShipDate)<CURDATE() AND IFNULL(pm.MemberShip,'')<>'','Membership Card is Expired !','')IsMemberShipExpire,IF(DATE(pm.MemberShipDate)>=CURDATE(),IFNULL(pm.MemberShip,''),'')MemberShipCardNo,pm.Gender,pm.bloodgroup,PM.Title,PM.PName,PM.Age,PMH.PatientID,PMH.DoctorID,PMH.ScheduleChargeID,CONCAT(RM.Floor,'/',RM.Name)RoomNo,FPM.Company_Name,PMH.TransactionID,FPM.ReferenceCode,PIP.IPDCaseTypeID,FPM.PanelID,PIP.RoomID,PMH.Employeeid,PMH.PolicyNo,PMH.CardNo,PMH.Patient_Type PatientType,pmh.PatientTypeID from (Select TransactionID,RoomID,IPDCaseTypeID_Bill IPDCaseTypeID from patient_ipd_profile Where TransactionID = '" + TranactionID + "' ORDER BY PatientIPDProfile_ID DESC LIMIT 1) PIP,(Select PatientID,TransactionID,PanelID,DoctorID,ScheduleChargeID,Employeeid,PolicyNo,CardNo,Patient_Type,PatientTypeID,IFNULL(DischargeType,'')DischargeType FROM patient_medical_history Where ";
            if (PatientID != "" && TranactionID == "")
                strQuery = strQuery + "PatientID = '" + PatientID + "' and ";
            else if (PatientID == "" && TranactionID != "")
                strQuery = strQuery + "TransactionID = '" + TranactionID + "' and ";
            strQuery = strQuery + "Type='IPD' )PMH,(Select bloodgroup,Title,PName,PatientID,Gender,MemberShipDate,MemberShip,Age from patient_master ";

            if (PatientID != "")
                strQuery = strQuery + "Where PatientID ='" + PatientID + "'";
            strQuery = strQuery + ") PM ,room_master RM,f_panel_master FPM Where PM.PatientID = PMH.PatientID and PMH.TransactionID = PIP.TransactionID and PIP.RoomID = RM.RoomID and PMH.PanelID = FPM.PanelID order by PM.PName";
            Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return null;
        }
    }

    public DataTable GetPatientEMGInformation(string PatientID, string TranactionID)
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "";
            strQuery = "Select pmh.DischargeType,ifnull(DATE_FORMAT(pm.MemberShipDate,'%d-%b-%y'),'')MemberShipDate, IF(DATE(pm.MemberShipDate)<CURDATE() AND IFNULL(pm.MemberShip,'')<>'','Membership Card is Expired !','')IsMemberShipExpire,IF(DATE(pm.MemberShipDate)>=CURDATE(),IFNULL(pm.MemberShip,''),'')MemberShipCardNo,pm.Gender,pm.bloodgroup,PM.Title,PM.PName,PM.Age,PMH.PatientID,PMH.DoctorID,PMH.ScheduleChargeID,FPM.Company_Name,PMH.TransactionID,FPM.ReferenceCode,PIP.IPDCaseTypeID,PIP.RoomID,FPM.PanelID,PMH.Employeeid,PMH.PolicyNo,PMH.CardNo,PMH.Patient_Type PatientType,pmh.PatientTypeID from (Select TransactionID,IFNULL(RoomID,0)RoomID,IPDCaseTypeID from Emergency_Patient_Details Where TransactionID = '" + TranactionID + "' ORDER BY ID DESC LIMIT 1) PIP,(Select PatientID,TransactionID,PanelID,DoctorID,ScheduleChargeID,Employeeid,PolicyNo,CardNo,Patient_Type,PatientTypeID,IFNULL(DischargeType,'')DischargeType FROM patient_medical_history Where ";
            if (PatientID != "" && TranactionID == "")
                strQuery = strQuery + "PatientID = '" + PatientID + "' and ";
            else if (PatientID == "" && TranactionID != "")
                strQuery = strQuery + "TransactionID = '" + TranactionID + "' and ";
            strQuery = strQuery + "Type='EMG' )PMH,(Select bloodgroup,Title,PName,PatientID,Gender,MemberShipDate,MemberShip,Age from patient_master ";

            if (PatientID != "")
                strQuery = strQuery + "Where PatientID ='" + PatientID + "'";
            strQuery = strQuery + ") PM ,f_panel_master FPM Where PM.PatientID = PMH.PatientID and PMH.TransactionID = PIP.TransactionID  and PMH.PanelID = FPM.PanelID order by PM.PName";
            Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return null;
        }
    }
   
    
    
    public DataTable GetPatientIPDInformation(string PatientID, string TranactionID, string Status)
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "";
            strQuery = "Select Ifnull((SELECT dm1.name FROM f_multipledoctor_ipd fip inner join doctor_master dm1   WHERE fip.DoctorID=dm1.doctorid AND fip.TransactionID=pmh.TransactionID AND dm1.isunit=1 LIMIT 1),'')TeamName, CONCAT(dm.Title,' ',dm.NAME)Dname,pmh.DateOfAdmit,pmh.Type,PM.Title,IF(pmh.height=' cm','',pmh.height)height,IF(pmh.weight=' KG','',pmh.weight)weight,pmh.allergies,(Select ReferredBy from patient_referredby where TransactionID='" + TranactionID + "')ReferedBy,";
            strQuery += "PM.PName,CONCAT(PM.Age,'/',IF(pm.DOB<>'0001-01-01',DATE_FORMAT(pm.DOB,'%d-%b-%y'),''))Age,PM.Gender,PMH.PatientID AS Patient_ID,PMH.DoctorID AS Doctor_ID,PMH.ScheduleChargeID,PMH.Admission_Type,";
            strQuery += "CONCAT(RM.Room_No,'/',RM.Name) RoomNo,ifnull(FPM.Company_Name,''),PMH.TransactionID AS Transaction_ID,";
            strQuery += "FPM.ReferenceCode,PIP.IPDCaseTypeID AS IPDCaseType_ID,ifnull(FPM.PanelID,'0') AS Panel_ID,PIP.RoomID AS Room_ID,PMH.Employeeid AS Employee_id,";
            strQuery += "PMH.PolicyNo,PMH.CardNo,PMH.MLC_NO,PMH.TransNo from (";
            strQuery += "       Select TransactionID,RoomID,IPDCaseTypeID_Bill IPDCaseTypeID ";
            strQuery += "       from patient_ipd_profile  Where TransactionID = '" + TranactionID + "' ";
            strQuery += "       and Status='" + Status + "' ";
            strQuery += ") PIP INNER JOIN ( ";
            strQuery += "       Select CONCAT(DATE_FORMAT(DateOfAdmit,'%d-%b-%Y'),' ',TIME_FORMAT(TimeOfAdmit,'%l:%i %p'))DateOfAdmit,Height,Allergies,Weight,PatientID,TransactionID,PanelID,DoctorID,ScheduleChargeID,IFNULL(Admission_Type,'')Admission_Type,";
            strQuery += "       Employeeid,PolicyNo,ReferedBy ReferedBy,CardNo,MLC_NO,TYPE,TransNo from ";
            strQuery += "       patient_medical_history Where ";
            if (PatientID != "" && TranactionID == "")
                strQuery = strQuery + "PatientID = '" + PatientID + "' and ";
            else if (PatientID == "" && TranactionID != "")
                strQuery = strQuery + "TransactionID = '" + TranactionID + "' and ";
            strQuery = strQuery + "Type='IPD' ";
            strQuery += ")PMH ON PIP.TransactionID= PMH.TransactionID ";
            strQuery += "INNER JOIN Patient_Master PM ON PM.PatientID = PMH.PatientID ";
            strQuery += "INNER JOIN room_master RM ON rm.RoomID= PIP.RoomID ";
            strQuery += "left JOIN f_panel_master FPM ON PMH.PanelID = FPM.PanelID ";
            strQuery += "INNER JOIN doctor_master dm ON dm.DoctorID=pmh.DoctorID ";
            if (PatientID != "")
                strQuery = strQuery + " Where pm.PatientID ='" + PatientID + "'";
            strQuery += " order by PM.PName ";
            Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return null;
        }
    }
    public static string GetLedgerNoByLedgerUserID(string LedgerUserID, MySqlConnection con)
    {
        return MySqlHelper.ExecuteScalar(con, CommandType.Text, "Select LedgerNumber as PLedgerNo from f_ledgermaster Where LedgerUserID = '" + LedgerUserID + "'").ToString();
    }
    public static string GetLedgerNoByLedgerUserID(string LedgerUserID, string GroupID, MySqlConnection con)
    {
        return Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "Select LedgerNumber from f_ledgermaster Where LedgerUserID = '" + LedgerUserID + "' and GroupID = '" + GroupID + "'limit 1"));
    }
    public DataTable GetPatientReceipt(string TransactionID)
    {
        try
        {
            string sql = "Select rec.ReceiptNo,rcp.PaymentMode,Round(S_Amount)AmountPaid,Date_Format(Date,'%d-%b-%y')Date,TIME_FORMAT(TIME,'%h:%i %p')Time,(SELECT CONCAT(Title,' ',NAME) FROM employee_master WHERE employeeID=Reciever)Receiver,TransactionID,if(Amountpaid <0,'Refund','Received')Type from f_reciept rec INNER JOIN f_receipt_paymentdetail rcp ON rec.ReceiptNo=rcp.ReceiptNo Where TransactionID ='" + TransactionID + "' and Iscancel=0 AND IsEdit=0 UNION ALL Select rec.ReceiptNo,rcp.PaymentMode,Round(AmountPaid)AmountPaid,Date_Format(Date,'%d-%b-%y')Date,TIME_FORMAT(TIME,'%h:%i %p')Time,(SELECT CONCAT(Title,' ',NAME) FROM employee_master WHERE employeeID=Reciever)Receiver,TransactionID,if(Amountpaid <0,'Refund','Received')Type from f_reciept_log rec INNER JOIN f_receipt_paymentdetail_log rcp ON rec.ReceiptNo=rcp.ReceiptNo Where TransactionID ='" + TransactionID + "' and Iscancel=0 order by ReceiptNo";
            return StockReports.GetDataTable(sql.ToString());
        }
        catch (Exception ex)
        {
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return null;
        }
    }
    public DataTable GetPatientReceiptAfterBill(string TransactionID)
    {
        try
        {
            string sql = "Select rec.ReceiptNo,rcp.PaymentMode,Round(S_Amount)AmountPaid,Date_Format(Date,'%d-%b-%y')Date,TIME_FORMAT(TIME,'%h:%i %p')Time,(SELECT CONCAT(Title,' ',NAME) FROM employee_master WHERE employeeID=Reciever)Receiver,TransactionID,if(Amountpaid <0,'Refund','Received')Type from f_reciept rec INNER JOIN f_receipt_paymentdetail rcp ON rec.ReceiptNo=rcp.ReceiptNo Where TransactionID ='" + TransactionID + "' and Iscancel=0  order by Date";
            return StockReports.GetDataTable(sql.ToString());
        }
        catch (Exception ex)
        {
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return null;
        }
    }
    public DataTable GetPatientReceiptNew(string TransactionID)
    {
        try
        {
           // string sql = "Select rec.ReceiptNo,rcp.PaymentMode,Round(S_Amount)AmountPaid,Date_Format(Date,'%d-%b-%y')Date,TIME_FORMAT(TIME,'%h:%i %p')Time,(SELECT CONCAT(Title,' ',NAME) FROM employee_master WHERE employee_ID=Reciever)Receiver,TransactionID,if(Amountpaid <0,'Refund','Received')Type from f_reciept rec INNER JOIN f_receipt_paymentdetail rcp ON rec.ReceiptNo=rcp.ReceiptNo Where TransactionID ='" + TransactionID + "' and Iscancel=0 AND IsEdit=0 UNION ALL Select rec.ReceiptNo,rcp.PaymentMode,Round(AmountPaid)AmountPaid,Date_Format(Date,'%d-%b-%y')Date,TIME_FORMAT(TIME,'%h:%i %p')Time,(SELECT CONCAT(Title,' ',NAME) FROM employee_master WHERE employee_ID=Reciever)Receiver,TransactionID,if(Amountpaid <0,'Refund','Received')Type from f_reciept_log rec INNER JOIN f_receipt_paymentdetail_log rcp ON rec.ReceiptNo=rcp.ReceiptNo Where TransactionID ='" + TransactionID + "' and Iscancel=0 order by ReceiptNo";
            string sql = "Select IF(IFNULL(rec.panelInvoiceNo,'')='',0,1)IsTPAPayment ,rec.ReceiptNo,rcp.PaymentMode,Round(S_Amount)AmountPaid,S_Notation,Date_Format(Date,'%d-%b-%y')Date,TIME_FORMAT(TIME,'%h:%i %p')Time,(SELECT CONCAT(Title,' ',NAME) FROM employee_master WHERE employeeID=Reciever)Receiver,TransactionID,if(Amountpaid <0,'Refund','Received')Type from f_reciept rec INNER JOIN f_receipt_paymentdetail rcp ON rec.ReceiptNo=rcp.ReceiptNo Where TransactionID ='" + TransactionID + "' and Iscancel=0 AND IsEdit=0 UNION ALL Select IF(IFNULL(rec.panelInvoiceNo,'')='',0,1)IsTPAPayment ,rec.ReceiptNo,rcp.PaymentMode,Round(AmountPaid)AmountPaid,S_Notation,Date_Format(Date,'%d-%b-%y')Date,TIME_FORMAT(TIME,'%h:%i %p')Time,(SELECT CONCAT(Title,' ',NAME) FROM employee_master WHERE employeeID=Reciever)Receiver,TransactionID,if(Amountpaid <0,'Refund','Received')Type from f_reciept_log rec INNER JOIN f_receipt_paymentdetail_log rcp ON rec.ReceiptNo=rcp.ReceiptNo Where TransactionID ='" + TransactionID + "' and Iscancel=0 order by ReceiptNo";

         //   string sql = "CALL GetPatientReceiptNew('" + TransactionID + "')";
           
            return StockReports.GetDataTable(sql.ToString());
        }
        catch (Exception ex)
        {
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return null;
        }
    }
    public DataTable GetPatientReceiptNewAsPerCurrency(string TransactionID,int isBaseCurrency)
    {
        try
        {

     
            string sql = "CALL GetPatientReceiptNew('" + TransactionID + "'," + isBaseCurrency + ")";
           
            return StockReports.GetDataTable(sql.ToString());
        }
        catch (Exception ex)
        {
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return null;
        }
    }
    

   public DataTable GetPatientReceiptAfterBillNew(string TransactionID)
    {
        try
        {

            string sql = "Select IF(IFNULL(rec.panelInvoiceNo,'')='',0,1)IsTPAPayment ,rec.ReceiptNo,rcp.PaymentMode,Round(S_Amount)AmountPaid,Date_Format(Date,'%d-%b-%y')Date,TIME_FORMAT(TIME,'%h:%i %p')Time,(SELECT CONCAT(Title,' ',NAME) FROM employee_master WHERE employeeID=Reciever)Receiver,TransactionID,if(Amountpaid <0,'Refund','Received')Type from f_reciept rec INNER JOIN f_receipt_paymentdetail rcp ON rec.ReceiptNo=rcp.ReceiptNo Where TransactionID ='" + TransactionID + "' and Iscancel=0  order by Date";

            return StockReports.GetDataTable(sql.ToString());
        }
        catch (Exception ex)
        {
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return null;
        }
    }
    public string InsertIntoRateList(string CaseType, string Panel, string ItemId, decimal Rate, string Type, string RateID, string displayname)
    {
        try
        {
            RateListIPD objRateIPD = new RateListIPD();
            string Items = "";
            string sql = "";
            if (Type == "Insert")
            {
                objRateIPD.Rate = Util.GetDecimal(Rate);
                objRateIPD.PanelID = Util.GetString(Panel);
                objRateIPD.IPDCaseTypeID = Util.GetString(CaseType);
                objRateIPD.ItemID = Util.GetString(ItemId);
                objRateIPD.IsCurrent = Util.GetInt(1);
                objRateIPD.ItemDisplayName = Util.GetString(displayname);
                string RateId = objRateIPD.Insert();
                return "1";
            }
            else
                sql = "update f_ratelist_ipd set Rate=" + Rate + " where RateListID='" + RateID + "'";
            if (IsLocalConn)
            {
                this.objCon.Open();
                Items = Util.GetString(MySqlHelper.ExecuteScalar(objCon, CommandType.Text, sql));
                this.objCon.Close();
                return "1";
            }
            else
                return "";
        }
        catch (Exception ex)
        {
            if (this.objCon.State == ConnectionState.Open) this.objCon.Close();

            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return "";
        }
    }
    public string InsertIntoRateList(string CaseType, string Panel, string ItemId, decimal Rate, string Type, string RateID, string displayname, string ItemCode, string ScheduleChargeID, string CentreID)
    {
        try
        {
            RateListIPD objRateIPD = new RateListIPD();
            string Items = "";
            string sql = "";
            if (Type == "Insert")
            {
                objRateIPD.Rate = Util.GetDecimal(Rate);
                objRateIPD.PanelID = Util.GetString(Panel);
                objRateIPD.IPDCaseTypeID = Util.GetString(CaseType);
                objRateIPD.ItemID = Util.GetString(ItemId);
                objRateIPD.IsCurrent = Util.GetInt(1);
                objRateIPD.ItemDisplayName = Util.GetString(displayname);
                objRateIPD.ItemCode = ItemCode;
                objRateIPD.ScheduleChargeID = Util.GetInt(ScheduleChargeID);
                objRateIPD.CentreID = Util.GetInt(CentreID);
                string RateId = objRateIPD.Insert();
                return "1";
            }
            else
                sql = "update f_ratelist_ipd set Rate=" + Rate + ",ItemCode='" + ItemCode + "' where RateListID='" + RateID + "'";
            if (IsLocalConn)
            {
                this.objCon.Open();
                Items = Util.GetString(MySqlHelper.ExecuteScalar(objCon, CommandType.Text, sql));
                this.objCon.Close();
                return "1";
            }
            else
            {
                return "";
            }
        }
        catch (Exception ex)
        {
            if (this.objCon.State == ConnectionState.Open) this.objCon.Close();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return "";
        }
    }
    public DataTable GetRateList(string Type, string DoctorID, string Panel, string SubCategory, string CaseType, string ScheduleChargeID, string CentreID)
    {
        try
        {
            DataTable Items;
            string sql = "";
            if (Type == "OPD")
                sql = "select temp1.ItemID,temp1.name,if(fl.Rate is null,0,fl.Rate) AS Rate,fl.RateListID,temp1.ShowFlag,fl.FromDate,fl.ToDate,ifnull(fl.ScheduleChargeID,0)ScheduleChargeID,'false' IsScheduled,SubCategoryID,DoctorID  from (select im.ItemID,scm.name,im.ShowFlag,scm.SubCategoryID,im.Type_ID DoctorID from f_itemmaster im inner join f_subcategorymaster  scm on scm.SubCategoryID = im.subcategoryid inner join f_configrelation con   on con.CategoryID = scm.CategoryID where im.Type_ID = '" + DoctorID + "'  and con.ConfigID in (4,5) and scm.Active=1 AND im.IsActive=1) temp1 left outer join f_ratelist fl on  temp1.ItemID = fl.ItemID and iscurrent=1 and fl.PanelID='" + Panel + "' and fl.ScheduleChargeID ='" + ScheduleChargeID + "' and fl.CentreID='" + CentreID + "' ";
            else
                sql = "select temp1.ItemID,temp1.name,if(fl.Rate is null,0,fl.Rate) AS Rate,fl.RateListID ,temp1.ShowFlag,fl.ItemCode,fl.FromDate,fl.ToDate,ifnull(fl.ScheduleChargeID,0)ScheduleChargeID,IsScheduled,SubCategoryID,DoctorID from (select im.ItemID,scm.name,im.ShowFlag,if((Select ID from f_scheduledconsultant where DoctorID='" + DoctorID + "' and SubCategoryID=scm.SubCategoryID and IsActive=1) is null,'false','True')IsScheduled,scm.SubCategoryID,im.Type_ID DoctorID from f_itemmaster im inner join f_subcategorymaster scm on scm.SubCategoryID = im.subcategoryid inner join f_configrelation con  on con.CategoryID = scm.CategoryID where im.Type_ID = '" + DoctorID + "' and con.ConfigID=1 and scm.Active=1 and im.IsActive=1) temp1 left outer join f_ratelist_ipd fl on temp1.ItemID = fl.ItemID and fl.IPDCaseTypeID in ('" + CaseType + "') and fl.PanelID='" + Panel + "' and fl.ScheduleChargeID ='" + ScheduleChargeID + "' AND fl.IsCurrent=1 and fl.CentreID='" + CentreID + "' ";
            if (IsLocalConn)
            {
                this.objCon.Open();
                Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, sql).Tables[0];
                this.objCon.Close();
                return Items;
            }
            else
                return null;
        }
        catch (Exception ex)
        {
            if (this.objCon.State == ConnectionState.Open) this.objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public DataTable GetCategoryByConfigID(string ConfigID)
    {
        DataTable Items = new DataTable();
        try
        {
            DataView CategoryView = LoadCacheQuery.loadCategory().DefaultView;
            CategoryView.RowFilter = "ConfigID in (" + ConfigID + ")";
            return CategoryView.ToTable();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public DataTable GetPanelByID(string PanelID)
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "select Company_Name as Name from f_panel_master where PanelID = " + PanelID + " ";
            Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public string GetSubCategoryDisplayNameBySubCategoryID(string SubCategoryID)
    {
        string Items = "";
        try
        {
            string strQuery = "SELECT concat(Name,'#',DisplayName)SubCategory from f_Subcategorymaster where  SubCategoryID='" + SubCategoryID + "'";
            Items = (string)MySqlHelper.ExecuteScalar(objCon, CommandType.Text, strQuery);

            if (Items != "")
            {
                if (IsLocalConn)
                    this.objCon.Close();
                return Items;
            }
            else
            {
                if (IsLocalConn)
                    if (objCon.State == ConnectionState.Open) objCon.Close();
                return null;
            }
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public string GetSubCategoryNameBySubCategoryID(string SubCategoryID)
    {
        string Items = "";
        try
        {
            string strQuery = "SELECT CONCAT(categoryid,'#',Name)SubCategory from f_Subcategorymaster where  SubCategoryID='" + SubCategoryID + "'";
            Items = (string)MySqlHelper.ExecuteScalar(objCon, CommandType.Text, strQuery);
            if (Items != "")
            {
                if (IsLocalConn)
                    this.objCon.Close();
                return Items;
            }
            else
            {
                if (IsLocalConn)
                    if (objCon.State == ConnectionState.Open) objCon.Close();
                return null;
            }
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public string GetCategoryDisplayNameBySubCategoryID(string SubCategoryID)
    {
        string Items = "";
        string Items1 = "";
        try
        {
            string strQuery = "SELECT categoryid from f_Subcategorymaster where  SubCategoryID='" + SubCategoryID + "'";
            Items = (string)MySqlHelper.ExecuteScalar(objCon, CommandType.Text, strQuery);

            string strQuery1 = "SELECT CONCAT(NAME,'#',Description)Category FROM f_categorymaster WHERE CategoryID='" + Items + "'";
            Items1 = (string)MySqlHelper.ExecuteScalar(objCon, CommandType.Text, strQuery1);

            if (Items1 != "")
            {
                if (IsLocalConn)
                    this.objCon.Close();
                return Items1;
            }
            else
            {
                if (IsLocalConn)
                    if (objCon.State == ConnectionState.Open) objCon.Close();
                return null;
            }
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public DataTable GetDoctorInformationByDoctorID(string DoctorID)
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "Select dh.Department,dh.Day,dh.Timings,dm.DoctorName DoctorName,dh.Room_No,dh.DoctorID,dm.DocDateTime,dm.IMARegistartionNo from " +
                                "(Select Department,Day,concat(Time_Format(StartTime,'%l: %i %p'),' - ',Time_Format(EndTime,'%l: %i %p'))Timings,DoctorID,Room_No " +
                                "from doctor_hospital where DoctorID ='" + DoctorID + "')dh," +
                                "(Select Name as DoctorName,DoctorID,Degree,DocDateTime,IMARegistartionNo from doctor_master " +
                                "where DoctorID ='" + DoctorID + "') dm where dm.DoctorID = dh.DoctorID";
            Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public string[,] GetLedgerAccount(string strPattern, string Code)
    {
        string[,] Items;
        try
        {
            string strQuery = "SELECT LedgerName,LedgerNumber from f_ledgermaster Where IsCurrent=1 ";

            if (Code != null && Code != "")
                strQuery = strQuery + " and GroupId = '" + Code.Trim() + "'";
            if (strPattern != null && strPattern != "")
                strQuery = strQuery + " and LedgerName like '" + strPattern.Trim() + "%'";
            DataSet ds = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery);
            if (ds.Tables[0].Rows.Count > 0)
            {
                Items = new string[ds.Tables[0].Rows.Count, 2];
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    Items[i, 0] = ds.Tables[0].Rows[i][0].ToString();
                    Items[i, 1] = ds.Tables[0].Rows[i][1].ToString();
                }

                if (IsLocalConn)
                    this.objCon.Close();
                return Items;
            }
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public DataTable GetPanelCompanyRefOPD()
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "Select rtrim(ltrim(Company_Name)) as Company_Name,PanelID,ReferenceCode,ReferenceCodeOPD from f_panel_master Where PanelID in (Select distinct(ReferenceCodeOPD) from f_panel_master) order by Company_Name";
            Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public DataTable GetPanelCompanyRefIPD()
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "Select rtrim(ltrim(Company_Name)) as Company_Name,PanelID,ReferenceCode,ReferenceCodeOPD from f_panel_master Where PanelID in (Select distinct(ReferenceCode) from f_panel_master) order by Company_Name";

            Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];

            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public string GetLedgerNoByPatientID(string PatientID)
    {
        string Items = "";
        try
        {
            string strQuery = "Select LedgerNumber from f_ledgermaster where LedgerUserID='" + PatientID + "'";
            Items = MySqlHelper.ExecuteScalar(objCon, CommandType.Text, strQuery).ToString();
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items != "")
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return null;
        }
    }
    public DataTable GetAdmittedPatients()
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "select pip.*,(Select ScheduleChargeID from Patient_medical_History where TransactionID=pip.TransactionID)ScheduleChargeID from patient_ipd_profile pip where pip.tobebill=1 and pip.TransactionID in (select TransactionID from patient_medical_history where   Status='IN' and DateOfAdmit!=curdate())";
            Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];

            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return null;
        }
    }
    public DataTable GetRoomItemDetails(string casetypes)
    {
        DataTable Items = new DataTable();
        try
        {
            string strCategory = "select categoryid from f_configrelation where configid=2";
            string category = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strCategory).Tables[0].Rows[0][0].ToString();
            string strQuery = "select * from (select ItemID,Type_ID,TypeName,StartTime,EndTime,BufferTime,SubCategoryID from f_itemmaster where type_Id in (" + casetypes + ") and subcategoryid in (select subcategoryId from f_subcategorymaster where categoryID = '" + category + "'))IM ,(select SubcategoryID,Name from f_subcategorymaster where categoryID = '" + category + "') SM where IM.SubcategoryID=SM.SubcategoryID";

            Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];

            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return null;
        }
    }
    public string GetPanelRefCodeByPanelID(string PanelID)
    {
        try
        {
            string Items = MySqlHelper.ExecuteScalar(objCon, CommandType.Text, "Select ReferenceCode from f_panel_master Where PanelID = " + PanelID + " ").ToString();
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items != "")
                return Items;
            else
                return "";
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return null;
        }
    }
    public DataTable GetItemRate(string ItemID)
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "Select RL.Rate,RL.RateListID,RL.ItemID,RL.FromDate,RL.IsTaxable,IM.Item from (Select Rate,RateListID,ItemID,FromDate,IsTaxable from f_ratelist where ItemID in (" + ItemID + ") and IsCurrent = 1) RL,(select Typename as Item,ItemID from f_itemmaster where itemID in (" + ItemID + "))IM Where IM.ItemID=RL.ItemID";
            Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();

            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return null;
        }
    }
    public DataTable GetItemRate(string ItemID, string PanelID)
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "Select RL.Rate,RL.RateListID,RL.ItemID,RL.FromDate,RL.IsTaxable,IM.Item,RL.PanelID,IM.Type_ID,IM.ValidityPeriod,IM.SubCategoryID from (Select Rate,RateListID,ItemID,FromDate,IsTaxable,PanelID from f_ratelist where ItemID in (" + ItemID + ") and PanelID = " + PanelID + " and IsCurrent = 1) RL,(select Typename as Item,ItemID,Type_ID,ValidityPeriod,SubCategoryID from f_itemmaster where itemID in (" + ItemID + "))IM Where IM.ItemID=RL.ItemID";
            Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return null;
        }
    }

    public DataTable GetItemRate(string ItemID, string PanelID, string CaseTypeID, string ScheduleChargeID, string CentreID)
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "Select RL.ID, Round((IFNULL(RL.Rate,0)*RL.Selling_Specific),0)Rate,RL.Rate BaseRate,RL.RateListID,RL.ItemID,RL.FromDate,RL.IsTaxable,IM.Item,RL.PanelID,IM.Type_ID,IM.ValidityPeriod,IM.SubCategoryID,RL.ItemDisplayName,RL.ItemCode,RL.ScheduleChargeID,RL.Selling_Specific,RL.RateCurrencyCountryID,(SELECT TYPE AS Sample FROM investigation_master WHERE investigation_id =Im.type_ID)Sample,(SELECT GenderInvestigate AS gender FROM investigation_master ims WHERE ims.investigation_id = Im.type_ID)   gender,(Select ConfigID from f_configrelation where CategoryID in (Select CategoryID from f_subcategorymaster where SubCategoryID=IM.SubCategoryID) limit 1)ConfigID from (Select ID,Rate,RateListID,ItemID,FromDate,IsTaxable,ip.PanelID,IPDCaseTypeID,ItemDisplayName,ItemCode,ScheduleChargeID,cm.Selling_Specific,cm.RateCurrencyCountryID from f_ratelist_ipd ip  INNER JOIN (SELECT pm.RateCurrencyCountryID,cm.Selling_Specific,pm.PanelID FROM converson_master cm INNER JOIN  f_panel_master pm ON cm.S_CountryID = pm.RateCurrencyCountryID WHERE pm.PanelID=" + PanelID + " ORDER BY id DESC LIMIT 1) cm ON cm.PanelID=ip.PanelID where ItemID in (" + ItemID + ") and ip.PanelID = '" + PanelID + "' and IPDCaseTypeID='" + CaseTypeID + "' and ScheduleChargeID=" + ScheduleChargeID + " and IsCurrent = 1 and CentreID=" + Util.GetInt(CentreID) + ") RL,(select Typename as Item,ItemID,Type_ID,ValidityPeriod,SubCategoryID from f_itemmaster where itemID in (" + ItemID + "))IM WHERE IM.ItemID=RL.ItemID ";

            Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];

            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return null;
        }
    }
    public string GetLedgerNoByPatientID(string PatientID, string GroupID)
    {
        try
        {

            string Items = Util.GetString(MySqlHelper.ExecuteScalar(objCon, CommandType.Text, "Select LedgerNumber from f_ledgermaster where LedgerUserID='" + PatientID + "' and GroupID='" + GroupID + "'"));
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items != "")
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return null;
        }
    }
    public string GetLedgerNoByPatientID(string PatientID, MySqlTransaction tnx)
    {
        try
        {
            string Items = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "Select LedgerNumber from f_ledgermaster where LedgerUserID='" + PatientID + "'"));
            if (Items != "")
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return null;
        }
    }
    public void UpdateAfterRoomShift(string TransactionID, string IPDCaseTypeID, MySqlConnection con, MySqlTransaction tranx)
    {
        try
        {
            string strQuery = "Update patient_ipd_profile set TOBEBILL=2,status='OUT' ,EndDate='" + DateTime.Now.ToShortDateString() + "', EndTime='" + DateTime.Now.ToShortTimeString() + "' WHERE status='IN' AND TransactionID='" + TransactionID + "' AND IPDCaseTypeID='" + IPDCaseTypeID + "'";
            MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, strQuery);
        }
        catch (Exception ex)
        {
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
        }
    }
    public void UpdateTempAllocatedRoom(string IPDCaseTypeID, string roomID, MySqlConnection con, MySqlTransaction tranx)
    {

        try
        {
            DataTable Items = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT TransactionID,ipdcasetypeID from patient_ipd_profile where IsTempAllocated =1 and RoomID='" + roomID + "'").Tables[0];
            if (Items != null)
            {
                UpdateAfterRoomShift(Items.Rows[0]["TransactionID"].ToString(), IPDCaseTypeID, con, tranx);
                string strQuery = "Update patient_ipd_profile set IsTempAllocated=0 where IsTempAllocated=1 and roomID='" + roomID + "' and IPDCaseTypeID='" + IPDCaseTypeID + "'";
                MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, strQuery);
            }
        }
        catch (Exception ex)
        {
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
        }
    }
    public DataTable GetAdmitDetail(string transactionId, string Type)
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "";
            if (Type == "Admit")

                strQuery = "select pip.RoomID,pip.TransactionID,pip.PatientID, pmh.KinRelation,pmh.KinName,pmh.KinPhone, DateOfAdmit AS AdmitDate,TimeOfAdmit AS TimeOfAdmit, (select CONCAT(Room_No,'-(',NAME,')') from room_master where RoomId=pip.RoomID)as Room,pm.Mobile,pm.Phone,pm.age,pm.Gender,pm.PName,concat(pm.House_No,' ',pm.Street_Name,' ',pm.Locality,' ',pm.City)Address from patient_ipd_profile pip,patient_medical_history pmh inner join patient_master pm on pmh.PatientID = pm.PatientID where pip.Status='IN' and pip.TransactionID='" + transactionId + "' and pmh.TransactionID = pip.TransactionID ";
            else
                strQuery = "select pip.RoomID,pip.TransactionID,pip.PatientID, pmh.KinRelation,pmh.KinName,pmh.KinPhone, DateOfAdmit AS AdmitDate,TimeOfAdmit AS TimeOfAdmit ,(select CONCAT(Room_No,'-(',NAME,')') from room_master where RoomId=pip.RoomID)as Room,pm.Mobile,pm.Phone,pm.age,pm.Gender,pm.PName,concat(pm.House_No,' ',pm.Street_Name,' ',pm.Locality,' ',pm.City)Address ,concat(Date_format(DateOfDischarge,'%d-%b-%y'),' ',Time_format(TimeOfDischarge,'%H:%I:%S')) AS DischargeDate from patient_ipd_profile pip,patient_medical_history pmh inner join patient_master pm on pmh.PatientID = pm.PatientID where pip.Status='OUT' and pip.TransactionID='" + transactionId + "' and pmh.TransactionID = pip.TransactionID ";

            Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];

            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return null;
        }
    }
    public DataTable GetPatientIPDInformation(string TranactionID)
    {
        DataTable Items = new DataTable();
        try
        {
            Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, "Select DM.DoctorName,CONCAT(Date_Format(ICH.DateOfAdmit,'%d-%b-%Y'),' ',Time_format(ICH.TimeOfAdmit,'%h:%i %p'))DateOfAdmit,concat(Date_Format(ICH.DateOfDischarge,'%d-%b-%Y'),' ',Time_format(ICH.TimeOfDischarge,'%H:%i:%s'))DateOfDischarge,DoctorID from (Select DoctorID AS Consultant_ID,DateOfAdmit,TimeOfAdmit,DateOfDischarge,TimeOfDischarge  from patient_medical_history Where TransactionID = '" + TranactionID + "' )ICH,(Select concat(Title,' ',Name)DoctorName,DoctorID from  doctor_master Where DoctorID =(Select DoctorID AS Consultant_ID from patient_medical_history Where TransactionID = '" + TranactionID + "'))DM Where DM.DoctorID = ICH.Consultant_ID").Tables[0];//ipd_case_history
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return null;
        }
    }
    public DataTable GetPatientDischargeStatus(string TransactionID)
    {
        DataTable Items = new DataTable();
        try
        {
            Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, "select date_format(DateOfDischarge,'%d/%b/%y') DischargeDate,TimeOfDischarge,Status from patient_medical_history where TransactionID='" + TransactionID + "'").Tables[0];//ipd_case_history
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return null;
        }
    }

    public DataTable GetPatientDischargetype(string TransactionID)
    {
        DataTable Items = new DataTable();
        try
        {
            Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, "select DischargeType,Status from patient_medical_history pmh where pmh.TransactionID='" + TransactionID + "'").Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return null;
        }
    }
    public decimal GetTotalDedutions(string TID)
    {

        try
        {
            return Util.GetDecimal(MySqlHelper.ExecuteScalar(objCon, CommandType.Text, "Select ROUND((IFNULL(Deduction_Acceptable,0)+IFNULL(Deduction_NonAcceptable,0)),2)Deductions from patient_medical_history where TransactionID='" + TID + "'"));

        }
        catch (Exception ex)
        {
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return 0;
        }
    }
    public decimal GetTDS(string TID)
    {
        try
        {
            return Util.GetDecimal(MySqlHelper.ExecuteScalar(objCon, CommandType.Text, "select TDS from Patient_Medical_History where TransactionID='" + TID + "' "));

        }
        catch (Exception ex)
        {
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return 0;
        }
    }
    public string getAdmitDate(string TransactionID)
    {
        try
        {
            string AdmitDate = MySqlHelper.ExecuteScalar(objCon, CommandType.Text, "Select Date_Format(DateOfAdmit,'%d-%b-%Y')AdmitDate from patient_medical_history Where TransactionID = '" + TransactionID + "'").ToString();
            if (IsLocalConn)
                this.objCon.Close();
            return AdmitDate;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return "";
        }
    }
    public string getissuedate(string fileid)
    {
        try
        {
            string Issuedate = MySqlHelper.ExecuteScalar(objCon, CommandType.Text, "SELECT DATE_FORMAT(issuedate,'%d-%M-%Y') FROM mrd_file_issue WHERE fileid = '" + fileid + "' ORDER BY issuedate ").ToString();
            if (IsLocalConn)
                this.objCon.Close();
            return Issuedate;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return "";
        }
    }
    public DataTable d_GetPatientAdjustmentDetails(string TransactionID)
    {
        DataTable Items = new DataTable();
        try
        {
            Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, "Select * from d_f_ipdadjustment Where TransactionID = '" + TransactionID + "'").Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            return null;
        }
    }
    public DataTable GetItemByBillNo(string BillNo)
    {
        try
        {
            string strSelect = "";
            strSelect = "SELECT LTD.LedgerTransactionNo,LTD.Amount,LTD.Rate,LTD.quantity,LTD.DiscountPercentage,"
            + "LTD.SubCategoryID,LT.DiscountOnTotal,LT.PanelID,LT.PatientID AS PatientID,LT.Remarks,"
            + "LT.DiscountReason,LT.TransactionID,LTD.ItemID,LTD.ItemName AS Item,"
            + "LT.NetAmount,(SELECT pname FROM patient_master WHERE PatientID=LT.PatientID)AS PatientName,"
            + "(SELECT Company_Name FROM f_panel_master WHERE PanelID=LT.PanelID)AS CompanyName,SUB.DisplayName,"
            + "SUB.Name AS SubCategory,lt.TypeOfTnx,ltd.IsVerified "
            + "FROM f_ledgertnxdetail LTD INNER JOIN f_ledgertransaction LT "
            + "ON LT.LedgerTransactionNo=LTD.LedgerTransactionNo "
            + "LEFT OUTER JOIN f_subcategorymaster SUB ON LTD.SubCategoryID=SUB.SubCategoryID "
            + "WHERE LT.BillNo='" + BillNo + "'  ";
            DataTable dt = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strSelect).Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            return dt;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public DataTable GetReceiptCancelDetails(string ReceiptNo, string BillNo)
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "";
            if (ReceiptNo != "")
            {
                strQuery = "Select LD.BillNo,LD.BillAmount,date_format(LD.BillDate,'%d-%b-%y')BillDate,LD.TransactionID,LD.PatientID,LD.LedgerTransactionNo,R.ReceiptAmount,date_format(R.ReceiptDate,'%d-%b-%y')ReceiptDate,R.ReceiptNo,'' as Doctor,0 as Status from  " +
                            "(Select BillNo,NetAmount as BillAmount,Date as BillDate,TransactionID,PatientID,LedgerTransactionNo from f_ledgertransaction " +
                            "Where IsCancel = 0 and TypeOfTnx='GEN-OPD' and LedgerTransactionNo =(Select AsainstLedgerTnxNo from f_reciept Where ReceiptNo ='" + ReceiptNo + "')) LD," +
                            "(Select AsainstLedgerTnxNo,AmountPaid as ReceiptAmount,Date as ReceiptDate,ReceiptNo from f_reciept " +
                            "Where ReceiptNo ='" + ReceiptNo + "') R " +
                            "Where LD.LedgerTransactionNo = R.AsainstLedgerTnxNo";
            }
            else
            {
                strQuery = "Select LD.BillNo,LD.BillAmount,date_format(LD.BillDate,'%d-%b-%y')BillDate,LD.TransactionID,LD.PatientID,LD.LedgerTransactionNo,R.ReceiptAmount,date_format(R.ReceiptDate,'%d-%b-%y')ReceiptDate,R.ReceiptNo,'' as Doctor,0 as Status from " +
                            "(Select BillNo,NetAmount as BillAmount,Date as BillDate,TransactionID," +
                            "PatientID,LedgerTransactionNo from f_ledgertransaction Where BillNo = '" + BillNo + "' and IsCancel = 0 and TypeOfTnx='GEN-OPD' )LD," +
                            "(Select AsainstLedgerTnxNo,AmountPaid as ReceiptAmount,Date as ReceiptDate,ReceiptNo from f_reciept Where " +
                            "AsainstLedgerTnxNo = (Select LedgerTransactionNo from f_ledgertransaction Where BillNo = '" + BillNo + "'))R " +
                            "Where LD.LedgerTransactionNo = R.AsainstLedgerTnxNo";
            }
            Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }

    public DataTable LoadReceipIPDtCancelDetails(string ReceiptNo)
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "select RP.ReceiptNo,RP.AmountPaid,date_format(RP.Date,'%d-%b-%y')as Date,RP.TransactionID,(select pname from patient_master where PatientID in(select PatientID from patient_medical_history where type='IPD' and TransactionID=RP.TransactionID))As Pname,(select PatientID  from patient_medical_history where type='IPD' and TransactionID=RP.TransactionID)As PatientID from (select ReceiptNo,TransactionID,AmountPaid,Date from f_reciept where ReceiptNo='" + ReceiptNo + "' and IsCancel=0)RP";
            Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }

    public DataTable GetBillCancelDetails(string BillNo)
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "Select LD.BillNo,LD.BillAmount,date_format(LD.BillDate,'%d-%b-%y')BillDate,LD.TransactionID,LD.PatientID,LD.LedgerTransactionNo,LD.BillAmount as ReceiptAmount,date_format(LD.BillDate,'%d-%b-%y')ReceiptDate,'-' as ReceiptNo,'' AS Doctor,0 AS STATUS from (Select BillNo,NetAmount as BillAmount,Date as BillDate,TransactionID,PatientID,LedgerTransactionNo from f_ledgertransaction Where BillNo = '" + BillNo + "' and IsCancel = 0 )LD";
            Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }

    public string GetPatientNameByID(string PatientID)
    {
        try
        {
            string Items = MySqlHelper.ExecuteScalar(objCon, CommandType.Text, "Select Pname from patient_master where PatientID='" + PatientID + "'").ToString();
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items != "")
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }

    public string[,] GetStoreName()
    {
        string[,] Items;
        try
        {
            DataSet ds = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, "SELECT LedgerName,LedgerNumber from f_ledgermaster Where GroupID='STO'");
            if (ds.Tables[0].Rows.Count > 0)
            {
                Items = new string[ds.Tables[0].Rows.Count, 2];
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    Items[i, 0] = ds.Tables[0].Rows[i][0].ToString();
                    Items[i, 1] = ds.Tables[0].Rows[i][1].ToString();
                }
                if (IsLocalConn)
                    this.objCon.Close();
                return Items;
            }
            else
            {
                if (IsLocalConn)
                    this.objCon.Close();
                return null;
            }
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }

    public string[,] GetDeptName()
    {
        string[,] Items;
        try
        {
            DataSet ds = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, "SELECT LedgerName,LedgerNumber FROM f_ledgermaster WHERE GroupID='DPT' ORDER BY LedgerName");
            if (ds.Tables[0].Rows.Count > 0)
            {
                Items = new string[ds.Tables[0].Rows.Count, 2];

                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    Items[i, 0] = ds.Tables[0].Rows[i][0].ToString();
                    Items[i, 1] = ds.Tables[0].Rows[i][1].ToString();
                }
                if (IsLocalConn)
                    this.objCon.Close();
                return Items;
            }
            else
            {
                if (IsLocalConn)
                    this.objCon.Close();
                return null;
            }
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }

    public DataTable GetMedExpDate(string StockID)
    {
        try
        {
            DataTable dt = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, "select date_format(MedExpiryDate,'%d-%b-%y')MedExpiryDate,itemid from f_stock where StockID='" + StockID + "'").Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            return dt;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }

    }
    public DataTable LoadAllStoreItems()
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT CONCAT(IM.Typename,' # ','(',SM.name,')','#',IFNULL(IM.UnitType,''))ItemName,concat(IM.ItemID,'#',IM.SubCategoryID,'#',ifnull(IM.Type_ID,''),'#',ifnull(im.MajorUnit,''),'#',ifnull(im.MinorUnit,''),'#',ifnull(im.ConversionFactor,'1'),'#',ifnull(im.IsExpirable,''))ItemID");
            sb.Append(" from f_itemmaster IM inner join f_subcategorymaster SM on IM.SubCategoryID = SM.SubCategoryID");
            sb.Append(" inner join f_configrelation CR on SM.CategoryID = CR.CategoryID WHERE CR.ConfigID = 11 and im.IsActive=1 order by IM.Typename ");
            DataTable dtItems = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, sb.ToString()).Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            return dtItems;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }

    public DataTable GetPatientReturnDetails(string CRNo, string DocumentNo, string IndentNo, string FromDate, string ToDate, string CentreID)
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "";

            strQuery = "Select LedgerTransactionNo,TypeOfTnx,PatientID,Date_Format(Date,'%d-%b-%y')Date,TransactionID,IndentNo from f_ledgertransaction Where TransactionTypeID=5 ";
            if (CRNo != "")
                strQuery = strQuery + " and TransactionID='" + CRNo + "'";
            if (DocumentNo != "")
                strQuery = strQuery + " and LedgerTransactionNo='" + DocumentNo + "'";
            if (IndentNo != "")
                strQuery = strQuery + " and IndentNo='" + IndentNo + "'";
            if (FromDate != "")
                strQuery = strQuery + " and Date>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "'";
            if (ToDate != "")
                strQuery = strQuery + " and Date<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'";
            if (CentreID != "")
                strQuery = strQuery + " and CentreID IN (" + CentreID + ") ";

            Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];

            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }

    public DataTable GetPatientDetail(string PatientID)
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "select 'fr-FR' lang_code, PatientID,concat(Title,' ',PName)PName,Title,Pname PPName,Age,Gender,House_No,Street_Name,City,State,Country,Relation,RelationName,MaritalStatus,Phone,Mobile from patient_master where PatientID ='" + PatientID + "'";
            if (this.objTrans != null && this.objCon == null)
                Items = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, strQuery).Tables[0];
            else if (this.objCon != null && this.objTrans == null)
                Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }

    public DataTable GetDeptReturnDetails(string FromDate, string ToDate, string DocumentNo, string IndentNo, string ItemID, string Dept, string CentreID)
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "";
            strQuery = "Select LedgerNumber,DepartmentID,Date_Format(Date,'%d-%b-%y')Date,IndentNo,salesno from f_salesdetails  Where TrasactionTypeID = 2 ";
            if (DocumentNo != "")
                strQuery = strQuery + " and SalesNo='" + DocumentNo + "'";

            if (IndentNo != "")
                strQuery = strQuery + " and IndentNo='" + IndentNo + "'";

            if (ItemID != "")
                strQuery = strQuery + " and ItemID='" + ItemID + "'";
            if (Dept != "")
                strQuery = strQuery + " and LedgerNumber='" + Dept + "'";
            if (FromDate != "")
                strQuery = strQuery + " and Date>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "'";
            if (ToDate != "")
                strQuery = strQuery + " and Date<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'";
            if (CentreID != "")
                strQuery = strQuery + " and CentreID IN (" + CentreID + ") ";
            Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];

            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }

    public DataTable GetDeptDetails(string DeptID)
    {
        DataTable Items = new DataTable();
        try
        {
            Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, "Select * from f_ledgermaster Where GroupID ='DPT' and LedgerNumber='" + DeptID + "'").Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public DataTable GetItemReturnDetails(string DocumentNo, string Type)
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "";
            if (Type == "Patient")
                strQuery = "select ltd.ItemName,st.BatchNumber,ltd.Quantity as qty,st.UnitPrice as CostPrice,st.MRP,Round((st.MRP*ltd.Quantity),2) as TotalAmt,Date_Format(ltd.EntryDate,'%d-%b-%y')Date from f_ledgertnxdetail ltd inner join f_stock st on ltd.stockid = st.stockid where ltd.LedgerTransactionNo = '" + DocumentNo + "'";
            else
                strQuery = "select ST.ItemName,ST.BatchNumber,Sd.SoldUnits as Qty,Sd.CostPrice,Sd.MRP,Round((Sd.SoldUnits * Sd.CostPrice),2) as TotalAmt,Sd.Date from ((select SoldUnits,StockID,PerUnitBuyPrice as CostPrice,PerUnitSellingPrice as MRP,Date_Format(Date,'%d-%b-%y')Date from f_salesdetails where TrasactionTypeID =2 and salesno = '" + DocumentNo + "')Sd, (select ItemName,ItemID,StockID,BatchNumber from f_stock)ST ) where ST.StockID=Sd.StockID ";

            Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public string GetPatientLedNoByTranID(string TID)
    {
        string sql = "Select LedgerNumber from f_ledgermaster Where GroupID = 'PTNT' and LedgerUserID = (Select PatientID from patient_medical_history Where TransactionID ='" + TID + "')";
        try
        {
            return Util.GetString(MySqlHelper.ExecuteScalar(objCon, CommandType.Text, sql));

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public DataTable GetCategoryByCategoryID(string CategoryID)
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "SELECT Name,CategoryID from f_categorymaster where CategoryID in ('" + CategoryID + "') order by Name";
            Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];
            if (Items != null)
            {
                if (IsLocalConn)
                    this.objCon.Close();
                return Items;
            }
            else
            {
                if (IsLocalConn)
                    if (objCon.State == ConnectionState.Open) objCon.Close();
                return null;
            }
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public DataTable GetItemSubCategoryByCategoryConfigID(string CategoryID,string PanelId="")
    {
        DataTable Items = new DataTable();
        try
        {
            //string strQuery = "SELECT  CONCAT(IFNULL(im.ItemCode,''),' # ',IM.TypeName)    TypeName,CONCAT(IFNULL(IM.ItemID,''),'#',IFNULL(IM.SubCategoryID,''),'#', IFNULL(SC.Name,''),'#',IFNULL(Type_ID,''),'#',im.RateEditable,'#',cf.ConfigID)ItemID,IM.SubCategoryID,SC.CategoryID,IM.TypeName ProName,IM.ItemID NewItemID,SC.Name,im.RateEditable,im.Type_ID FROM f_itemmaster im INNER JOIN f_subcategorymaster sc ON im.SubCategoryID = sc.SubCategoryID and sc.Active=1 INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID LEFT JOIN f_item_outsource io ON im.ItemID = io.ItemID AND io.IsActive=1 WHERE im.IsActive=1 AND cf.ConfigID IN (" + CategoryID + ") AND io.ItemID IS NULL ORDER BY TypeName ";
            //string strQuery = "SELECT  CONCAT(IFNULL(im.ItemCode,''),' # ',IM.TypeName)    TypeName,CONCAT(IFNULL(IM.ItemID,''),'#',IFNULL(IM.SubCategoryID,''),'#', IFNULL(SC.Name,''),'#',IFNULL(Type_ID,''),'#',im.RateEditable,'#',cf.ConfigID)ItemID,IM.SubCategoryID,SC.CategoryID,IM.TypeName ProName,IM.ItemID NewItemID,SC.Name,im.RateEditable,im.Type_ID FROM f_itemmaster im INNER JOIN f_subcategorymaster sc ON im.SubCategoryID = sc.SubCategoryID and sc.Active=1 INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID LEFT JOIN f_item_outsource io ON im.ItemID = io.ItemID AND io.IsActive=1 WHERE im.IsActive=1 AND cf.ConfigID IN (" + CategoryID + ") AND cf.CategoryID NOT IN ('46') AND io.ItemID IS NULL ORDER BY TypeName ";

            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT  CONCAT(IFNULL(im.ItemCode,''),' # ',IM.TypeName)    TypeName,CONCAT(IFNULL(IM.ItemID,''),'#',IFNULL(IM.SubCategoryID,''),'#', IFNULL(SC.Name,''),'#',IFNULL(Type_ID,''),'#',im.RateEditable,'#',cf.ConfigID)ItemID,IM.SubCategoryID,SC.CategoryID,IFNULL( CONCAT( IM.TypeName,' (',round( rl.`Rate`,2) ,' )' ),im.`TypeName`) ProName,IM.ItemID NewItemID,SC.Name,im.RateEditable,im.Type_ID FROM f_itemmaster im INNER JOIN f_subcategorymaster sc ON im.SubCategoryID = sc.SubCategoryID and sc.Active=1 INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID LEFT JOIN f_item_outsource io ON im.ItemID = io.ItemID AND io.IsActive=1 ");
            sb.Append(" LEFT JOIN f_ratelist rl ON im.`ItemID`= rl.`ItemID`  AND rl.PanelID='"+PanelId+"' AND rl.iscurrent=1 AND rl.CentreID='" + HttpContext.Current.Session["CentreID"] + "' ");
            sb.Append(" LEFT JOIN f_rate_schedulecharges rsc ON rsc.PanelID = rl.PanelID AND rsc.IsDefault=1 AND rsc.ScheduleChargeID=rl.ScheduleChargeID ");
            sb.Append(" WHERE im.IsActive=1 AND cf.ConfigID IN (" + CategoryID + ") AND cf.CategoryID NOT IN ('46') AND io.ItemID IS NULL ORDER BY TypeName ");



            Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, sb.ToString()).Tables[0];

            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public DataTable GetItemsSubCategoryByCategoryID(string CategoryID)
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "SELECT CONCAT('#',IFNULL(IM.TypeName,''))TypeName,CONCAT(IFNULL(IM.ItemID,''),'#',IFNULL(IM.SubCategoryID,''),'#',IFNULL(SC.Name,''),'#',IFNULL(Type_ID,''),'#',im.RateEditable,'#',cf.ConfigID)ItemID,IM.SubCategoryID,SC.CategoryID FROM f_itemmaster im INNER JOIN f_subcategorymaster sc ON im.SubCategoryID = sc.SubCategoryID INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID LEFT JOIN f_item_outsource io ON im.ItemID = io.ItemID AND io.IsActive=1   WHERE im.IsActive=1 AND sc.CategoryID='" + CategoryID + "' AND io.ItemID IS NULL ORDER BY TypeName ";
            Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public DataTable GetPatientBedNoByTID(string TransactionID)
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "";

            strQuery = "SELECT NAME FROM ipd_case_type_master ipm INNER JOIN patient_ipd_profile pip ON pip.ipdcasetypeid=ipm.ipdcasetypeid WHERE pip.TransactionID='ishhi" + TransactionID + "'";
            if (this.objTrans != null && this.objCon == null)
                Items = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, strQuery).Tables[0];
            else if (this.objCon != null && this.objTrans == null)
                Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public DataTable GetInvestigationResult(string TestID)
    {
        DataTable Items = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("select lom.labobservation_id,name,value,minimum,maximum,readingformat,child_flag,parentID from ");
            sb.Append(" labobservation_master lom inner join patient_labobservation_opd plo on lom.LabObservation_ID = plo.LabObservation_ID where plo.Test_ID in (" + TestID + ") order by parentID ");
            if (this.objTrans != null && this.objCon == null)
                Items = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sb.ToString()).Tables[0];
            else if (this.objCon != null && this.objTrans == null)
                Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, sb.ToString()).Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }

    public DataTable GetInvestigationRadioResult(string TestID)
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "select test_id,Investigation_ID,Template_Desc from patient_labradiology_opd where test_id in (" + TestID + ")";
            if (this.objTrans != null && this.objCon == null)
                Items = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, strQuery).Tables[0];
            else if (this.objCon != null && this.objTrans == null)
                Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public DataTable GetLabID(string Test_ID, string Labtype)
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "";
            if (Labtype == "OPD")
                strQuery = "Select ledgertransactionNo,Test_ID,if(Approved=1,1,0)Approved,DATE_FORMAT(ApprovedDate,'%d-%b-%Y %I:%i%p')ApprovedDate,ApprovedBy,DATE_FORMAT(ResultEnteredDate,'%d-%b-%Y %I:%i%p')ResultEnteredDate,ResultEnteredName from patient_labinvestigation_opd where Test_id in (" + Test_ID + ")";
            else
                strQuery = "Select ledgertransactionNo,Test_ID,if(Approved=1,1,0)Approved,DATE_FORMAT(ApprovedDate,'%d-%b-%Y %I:%i%p')ApprovedDate,ApprovedBy,DATE_FORMAT(ResultEnteredDate,'%d-%b-%Y %I:%i%p')ResultEnteredDate,ResultEnteredName from patient_labinvestigation_ipd where Test_id in (" + Test_ID + ")";
            if (this.objTrans != null && this.objCon == null)
                Items = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, strQuery).Tables[0];
            else if (this.objCon != null && this.objTrans == null)
                Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public DataTable GetLimitation(string InvestigationId)
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "select LabInves_Description from investigation_master where Investigation_Id='" + InvestigationId + "'";
            if (this.objTrans != null && this.objCon == null)
                Items = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, strQuery).Tables[0];
            else if (this.objCon != null && this.objTrans == null)
                Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];

            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public DataTable GetInvestigationList(string PatientID, string FromDate, string ToDate)
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "select date_format(date,'%d-%b-%y') as Date,SampleDate,Investigation_ID as InvestigationID,TransactionID,Test_ID,LabInves_Description from patient_labinvestigation_opd where result_flag=1 and date>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' and date <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' and PatientID='" + PatientID + "'";
            if (this.objTrans != null && this.objCon == null)
                Items = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, strQuery).Tables[0];
            else if (this.objCon != null && this.objTrans == null)
                Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public DataTable GetInvestigationName(string ListInv)
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "";
            strQuery = "SELECT IM.Investigation_ID,im.Name,im.ReportType,im.FileLimitationName," +
            "OM.Name Department,om.Print_Sequence FROM investigation_master IM " +
            "INNER JOIN investigation_observationtype IO ON " +
            "IM.Investigation_Id = IO.Investigation_ID INNER JOIN observationtype_master OM ON " +
            "OM.ObservationType_ID = IO.ObservationType_Id " +
            "WHERE IO.Investigation_id IN (" + ListInv + ") " +
            "ORDER BY im.Print_Sequence";
            if (this.objTrans != null && this.objCon == null)
                Items = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, strQuery).Tables[0];
            else if (this.objCon != null && this.objTrans == null)
                Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public DataTable GetInvestigationListNew(string LedgerTransactionNo, string LabType, string ReportType)
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "";
            if (LabType == "IPD")
                strQuery = " SELECT TIME_FORMAT(TIME,'%h:%i:%p') AS TIME,DATE_FORMAT(DATE,'%d-%b-%y') AS DATE,SampleDate,plo.Investigation_ID AS InvestigationID,TransactionID,Test_ID,plo.LabInves_Description,plo.ID,IF(Approved=1,'APPROVED','NOT-APPROVED')Approved,IF(Approved=1,'true','false')Print FROM patient_labinvestigation_ipd plo INNER JOIN investigation_master im ON im.Investigation_ID=plo.Investigation_Id WHERE result_flag=1 AND LedgerTransactionNo='" + LedgerTransactionNo + "'  and ReportType" + ReportType + "";
            else
                strQuery = " SELECT TIME_FORMAT(TIME,'%h:%i:%p') AS TIME,DATE_FORMAT(DATE,'%d-%b-%y') AS DATE,SampleDate,plo.Investigation_ID AS InvestigationID,TransactionID,Test_ID,plo.LabInves_Description,plo.ID,IF(Approved=1,'APPROVED','NOT-APPROVED')Approved,IF(Approved=1,'true','false')Print FROM patient_labinvestigation_opd plo INNER JOIN investigation_master im ON im.Investigation_ID=plo.Investigation_Id WHERE result_flag=1 AND LedgerTransactionNo='" + LedgerTransactionNo + "'  and ReportType" + ReportType + "";
            if (this.objTrans != null && this.objCon == null)
                Items = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, strQuery).Tables[0];
            else if (this.objCon != null && this.objTrans == null)
                Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public DataTable GetInvestigationListWard(string LedgerTransactionNo, string LabType, string TransactionID)
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "";
            if (LabType == "IPD")
            {
                strQuery = "select date_format(date,'%d-%b-%y') as Date,SampleDate,Investigation_ID as InvestigationID,TransactionID,Test_ID,ifnull((Select LabInves_Description from patient_labinvestigation_ipd_text where PLI_ID=ID  LIMIT 1),'')LabInves_Description,if(Approved=1,'APPROVED','NOT-APPROVED')Approved,DoctorID,IPDCaseTypeID  from patient_labinvestigation_opd where result_flag=1 ";
                if (LedgerTransactionNo != "")
                    strQuery = strQuery + " and LedgerTransactionNo='" + LedgerTransactionNo + "'";
                if (TransactionID != "")
                    strQuery = strQuery + " and TransactionID='" + TransactionID + "'";
            }
            if (this.objTrans != null && this.objCon == null)
                Items = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, strQuery).Tables[0];
            else if (this.objCon != null && this.objTrans == null)
                Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public DataTable GetInvestigationList(string LedgerTransactionNo, string LabType)
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "";
            //if (LabType == "IPD")
            //    strQuery = "select Time_format(Time,'%h:%i %p') as Time,date_format(date,'%d-%b-%y') as Date,SampleDate,Investigation_ID as InvestigationID,TransactionID,Test_ID,ifnull((Select LabInves_Description from patient_labinvestigation_ipd_text where PLI_ID=pli.ID  LIMIT 1),'')LabInves_Description,ID,if(Approved=1,'APPROVED','NOT-APPROVED')Approved,if(Approved=1,'true','false')Print,DoctorID,IPDCaseTypeID from patient_labinvestigation_ipd pli where result_flag=1 and LedgerTransactionNo='" + LedgerTransactionNo + "'";
            //else if (LabType == "OPD")
            //    strQuery = "select Time_format(Time,'%h:%i %p') as Time,date_format(date,'%d-%b-%y') as Date,SampleDate,Investigation_ID as InvestigationID,TransactionID,Test_ID,ifnull((Select LabInves_Description from patient_labinvestigation_opd_text where PLO_ID=pli.ID  LIMIT 1),'')LabInves_Description,ID,if(Approved=1,'APPROVED','NOT-APPROVED')Approved,if(Approved=1,'true','false')Print,DoctorID,'' IPDCaseTypeID from patient_labinvestigation_opd pli where result_flag=1 and LedgerTransactionNo='" + LedgerTransactionNo + "'";
            //else
            //{
            //    strQuery = "select Time_format(Time,'%h:%i %p') as Time,date_format(date,'%d-%b-%y') as Date,SampleDate,Investigation_ID as InvestigationID,TransactionID,Test_ID,ifnull((Select LabInves_Description from patient_labinvestigation_ipd_text where PLI_ID=pli.ID  LIMIT 1),'')LabInves_Description,ID,if(Approved=1,'APPROVED','NOT-APPROVED')Approved,if(Approved=1,'true','false')Print,DoctorID,IPDCaseTypeID from patient_labinvestigation_ipd pli where result_flag=1 and LedgerTransactionNo='" + LedgerTransactionNo + "'";
            //    strQuery += " Union All ";
            //    strQuery += "select Time_format(Time,'%h:%i:%p') as Time,date_format(date,'%d-%b-%y') as Date,SampleDate,Investigation_ID as InvestigationID,TransactionID,Test_ID,ifnull((Select LabInves_Description from patient_labinvestigation_opd_text where PLO_ID=pli.ID  LIMIT 1),'')LabInves_Description,ID,if(Approved=1,'APPROVED','NOT-APPROVED')Approved,if(Approved=1,'true','false')Print,DoctorID,'' IPDCaseTypeID from patient_labinvestigation_opd pli where result_flag=1 and LedgerTransactionNo='" + LedgerTransactionNo + "'";
            //}
            strQuery ="SELECT TIME_FORMAT(TIME,'%h:%i %p') AS TIME,DATE_FORMAT(DATE,'%d-%b-%y') AS DATE,SampleDate,Investigation_ID AS InvestigationID,TransactionID,Test_ID, ";
            strQuery +=" IFNULL((SELECT LabInves_Description FROM patient_labinvestigation_opd_text WHERE PLO_ID=pli.ID  LIMIT 1),'')LabInves_Description,ID, ";
            strQuery +=" IF(Approved=1,'APPROVED','NOT-APPROVED')Approved,IF(Approved=1,'true','false')Print,DoctorID,'' IPDCaseTypeID ";
            strQuery +=" FROM patient_labinvestigation_opd pli WHERE result_flag=1 AND ";
            strQuery += " LedgerTransactionNo='"+LedgerTransactionNo+"' AND pli.sampleTransferCentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " ";
            if (LabType=="OPD")
            strQuery +=" AND pli.type=1" ;
            else if (LabType == "IPD")
                strQuery += " AND pli.type=2";
            if (this.objTrans != null && this.objCon == null)
                Items = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, strQuery).Tables[0];
            else if (this.objCon != null && this.objTrans == null)
                Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public DataTable GetInvestigationResultIPD(string TestID)
    {
        DataTable Items = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("select lom.labobservation_id,name,value,minimum,maximum,readingformat,child_flag,parentID from labobservation_master lom inner join patient_labobservation_ipd pli");
            sb.Append(" on lom.LabObservation_ID = pli.LabObservation_ID where pli.test_id in (" + TestID + ") order by parentID");
            if (this.objTrans != null && this.objCon == null)
                Items = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sb.ToString()).Tables[0];
            else if (this.objCon != null && this.objTrans == null)
                Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, sb.ToString()).Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            return null;
        }
    }
    public DataTable GetInvestigationRadioResultIPD(string TestID)
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "select test_id,Investigation_ID,Template_Desc from patient_labradiology_ipd where test_id in (" + TestID + ")";
            if (this.objTrans != null && this.objCon == null)
                Items = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, strQuery).Tables[0];
            else if (this.objCon != null && this.objTrans == null)
                Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            return null;
        }
    }
    public DataTable GetPatientInvestigationOPD(string TestID)
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "Select * From patient_labinvestigation_opd Where Test_ID in (" + TestID + ")";
            Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            return Items;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            return null;
        }
    }
    public DataTable PatientInfo(string PatientID, string TranactionID)
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "Select PM.Title,PM.PName,PMH.PatientID, PM.Address, PM.age ,concat(RM.Floor,'/',RM.Name)RoomNo,FPM.Company_Name,PMH.TransactionID,FPM.ReferenceCode,PIP.IPDCaseTypeID,FPM.PanelID,PIP.RoomID,PMH.DischargeType from (Select TransactionID,RoomID,IPDCaseTypeID from patient_ipd_profile ) PIP,(Select PatientID,TransactionID,PanelID,DischargeType from patient_medical_history Where ";
            if (PatientID != "" && TranactionID == "")
                strQuery = strQuery + "PatientID = '" + PatientID + "' and ";
            else if (PatientID == "" && TranactionID != "")
                strQuery = strQuery + "TransactionID = '" + TranactionID + "' and ";
            strQuery = strQuery + "Type='IPD' )PMH,(Select Title,PName,PatientID,concat(House_No , ',' , Street_Name , ',' , Locality , ',' , City ) as Address , Age from patient_master ";

            if (PatientID != "")
                strQuery = strQuery + "Where PatientID ='" + PatientID + "'";
            strQuery = strQuery + ") PM ,room_master RM,f_panel_master FPM Where PM.PatientID = PMH.PatientID and PMH.TransactionID = PIP.TransactionID and PIP.RoomID = RM.RoomID and PMH.PanelID = FPM.PanelID order by PM.PName limit 1";
            Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];

            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public DataTable PanelApp_Detail(string TransactionID)
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "SELECT ID,REPLACE(TransactionID,'ISHHI','')TransactionID,Date_Format(PanelApprovalDate,'%d-%b-%y')PanelApprovalDate,PanelApprovedAmt,(SELECT CONCAT(Title,' ',NAME)USER FROM employee_master WHERE EmployeeID=UserID)UserID,ClaimNo,PanelAppRemarks,ApprovalFileName,fpa.IsActive,(CASE WHEN PanelApprovalType='A' THEN 'Additional' WHEN PanelApprovalType='C' THEN 'Cummulative' WHEN PanelApprovalType='F' THEN 'First Approval' END)PanelApprovalType,(CASE WHEN AmountApprovalType='Open' THEN 'Open Approval' WHEN  AmountApprovalType='Fix' THEN 'Fix By Date' END)AmountApprovalType,DATE_FORMAT(ApprovalExpiryDate,'%d-%b-%Y')AppExpiryDate, fpm.Company_Name from f_IpdPanelApproval fpa INNER JOIN f_panel_master fpm ON fpa.PanelID=fpm.PanelID Where TransactionID = '" + TransactionID + "'  ";
            if (IsLocalConn)
            {
                this.objCon.Open();
                DataSet ds = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery);
                this.objCon.Close();
                return ds.Tables[0];
            }
            else
                return null;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            if (this.objCon.State == ConnectionState.Open) this.objCon.Close();
            return null;
        }

    }
    public DataTable GetDischargeType(string CRNO)
    {
        try
        {
            string strSelect = "select PM.PatientID,PMH.TransactionID,PMH.DischargeType,concat(PM.Title,' ',PM.PName)PName,concat(PM.House_No,' ',Street_Name,' ',City)Address from patient_medical_history PMH inner join patient_master PM on PMH.PatientID=PM.PatientID where PMH.TransactionID='" + CRNO + "'";
            DataTable dt = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strSelect).Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            return dt;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }

    public DataTable getPatientAdmitDischarge(string TransactionID)
    {
        try
        {
            string strQuery = "select * from (select TransNo TransactionID,DoctorID,DoctorID1,date_format(DateOfAdmit,'%d/%b/%y') AdmitDate,TimeOfAdmit,date_format(DateOfDischarge,'%d/%b/%y') DischargeDate,TimeOfDischarge,Status from patient_medical_history where TransactionID='" + TransactionID + "') ad ,(select CONCAT(Title,' ',NAME,IF(IFNULL(IMARegistartionNo,'')='','',CONCAT(' / ',IMARegistartionNo) ) )name,DoctorID from doctor_master ) dm where dm.DoctorID =ad.DoctorID OR dm.DoctorID = ad.DoctorID1 ";//ipd_case_history  //  DoctorID =Consultant_ID or DoctorID = Consultant_ID1
            DataTable dt = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];
            if (IsLocalConn)
                this.objCon.Close();
            return dt;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public DataTable getAdmitPatientBedShiftingDetails(string TransactionID)
    {
        try
        {
            DataTable dt;
            string strQuery = "";
            strQuery = "SELECT  pip.TransactionID,pip.IPDCaseTypeID_Bill,pip.RoomID, DATE_FORMAT(pip.StartDate,'%d/%b/%y') " +
            "StartDate,pip.StartTime,DATE_FORMAT(pip.EndDate,'%d/%b/%y') EndDate,pip.EndTime,pip.PanelID," +
                // "icm.Name BedCategory,CONCAT(rm.Name,'-',rm.Room_No,'-',rm.Bed_No)Room  FROM ( " +
                //   "icm.Name BedCategory,CONCAT(rm.Name,'-',rm.Room_No)Room  FROM ( " +
               "icm.Name BedCategory,CONCAT(rm.Name,IF(IFNULL(rm.Room_No,'')='','',CONCAT('-',rm.Room_No)))Room  FROM (  " +
            "    SELECT * FROM patient_ipd_profile WHERE PatientIPDProfile_ID=(SELECT MIN(PatientIPDProfile_ID)PatientIPDProfile_ID " +
            "    FROM patient_ipd_profile WHERE TransactionID='" + TransactionID + "') " +
            "    UNION ALL " +
            "    SELECT * FROM patient_ipd_profile WHERE PatientIPDProfile_ID=(SELECT MAX(PatientIPDProfile_ID)PatientIPDProfile_ID " +
            "    FROM patient_ipd_profile WHERE TransactionID='" + TransactionID + "') " +
            ")pip INNER JOIN ipd_case_type_master icm ON icm.IPDCaseTypeID = pip.IPDCaseTypeID INNER JOIN room_master rm ON rm.RoomId = pip.roomID  ORDER BY PatientIPDProfile_ID";

            dt = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];

            if (IsLocalConn)
                this.objCon.Close();
            return dt;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public string GetDischargetypeByTransactionID(string TransactionID)
    {
        string Items = "";
        try
        {
            string strQuery = "Select DischargeType from patient_medical_history Where TransactionID = '" + TransactionID + "'";
            Items = MySqlHelper.ExecuteScalar(objCon, CommandType.Text, strQuery).ToString();
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items != "")
                return Items;
            else
                return "";
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public string GetBillDateByTransactionID(string TransactionID)
    {
        string Items = "";
        try
        {
            string strQuery = "SELECT  IF(DATE_FORMAT(BillDate,'%d/%b/%y')='01/Jan/01','',DATE_FORMAT(BillDate,'%d/%b/%y')) FROM patient_medical_history WHERE TransactionID= '" + TransactionID + "'";//f_ipdadjustment
            Items = MySqlHelper.ExecuteScalar(objCon, CommandType.Text, strQuery).ToString();
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items != "")
                return Items;
            else
                return "";
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public DataTable GetDischargetypeKinNameByTransactionID(string TransactionID)
    {
        DataTable Items = new DataTable();
        try
        {
            Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, "Select DischargeType,KinRelation,KinName,Employeeid,EmployeeDependentName,DependentRelation,PolicyNo,CardNo,CardHolderName,RelationWith_holder,FileNo,pmh.PanelID from patient_medical_history pmh Where TransactionID = '" + TransactionID + "'").Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items != null || Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public DataTable GetUserinformation(string UserID)
    {
        DataTable Items = new DataTable();
        try
        {
            Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, "Select em.name as LoginName,l.Username from f_login l,employee_master em Where l.EmployeeID = em.EmployeeID and l.EmployeeID = '" + UserID + "'").Tables[0];
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            if (Items.Rows.Count > 0)
                return Items;
            else
                return null;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public DataTable SearchPatientEMR(string PatientId, string PatientName, string TransactionId, string RoomID, string DoctorID, string Company, string FromAdmitDate, string ToAdmitDate, string DischargeDateFrom, string DischargeDateTo, string VisitDateFrom, string VisitDateTo, string status, int isEmergencyPatient)
    {

        try
        {

            if (isEmergencyPatient == 1)
            {
                StringBuilder sqlCMD = new StringBuilder();
                sqlCMD.Append(" SELECT pmh.TransNo, CONCAT(pm.Title,'',pm.PName) PName, pm.Mobile, pm.PatientID, pm.Gender, pm.Relation, pm.RelationName, '' SurgeryDate, pm.Place `Address`, pm.Age, pmh.TransactionID, CONCAT(dm.Title,' ',dm.Name) DName, dm.Mobile DocMobile, dm.Degree  DocDegree, dm.DocDepartmentID, '' RName, p.Company_Name, '' BillingCategory, DATE_FORMAT(epd.EnteredOn ,'%d-%b-%Y %l:%i %p')AdmitDate, DATE_FORMAT(epd.ReleasedDateTime,'%d-%b-%Y %l:%i %p') DischargeDate, IF(epd.IsReleased=1,'OUT','IN')`Status`, CONCAT(pm.Age,'/',pm.Gender) AgeSex, '' Floorbed, '' RoomName, '' Room_No, epd.IPDCaseTypeID, p.ReferenceCode, pm.PanelID, '' DischargeType, pmh.KinRelation, pmh.KinName  ");
                sqlCMD.Append(" FROM emergency_patient_details epd  ");
                sqlCMD.Append(" INNER JOIN patient_medical_history pmh  ON pmh.TransactionID=epd.TransactionId ");
                sqlCMD.Append(" INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID                                    ");
                sqlCMD.Append(" INNER JOIN doctor_master dm ON dm.DoctorID=pmh.DoctorID              ");
                sqlCMD.Append(" INNER JOIN f_panel_master p ON p.PanelID=pmh.PanelID WHERE pmh.TransactionID='" + TransactionId + "'              ");

                DataTable dt = StockReports.GetDataTable(sqlCMD.ToString());
                return dt;
            }
            else
            {
                int iCheck = 0;
                if (TransactionId != "" || PatientId != "" || PatientName != "")
                    iCheck = 1;

                StringBuilder sb = new StringBuilder();
                sb.Append("");
                sb.Append("Select CONCAT(t2.Title, ' ',t2.PName)PName,t2.Mobile,t2.PatientID,t2.Gender,t2.Relation,t2.RelationName,''SurgeryDate, ");
                sb.Append(" CONCAT(t2.House_No,',',t2.City,',',t2.Country)Address,");
                sb.Append(" t2.Age,t2.TransactionID,CONCAT(dm.Title,' ',dm.Name) as DName,dm.Mobile DocMobile,dm.Degree DocDegree,dm.DocDepartmentID,ictm1.Name as RName,fpm.Company_Name,ictm2.Name as BillingCategory,");
                sb.Append(" CONCAT(t2.DateOfAdmit,' ',t2.TimeOfAdmit)AdmitDate,CONCAT(t2.DateOfDischarge,' ',t2.TimeOfDischarge)DischargeDate,t2.Status,CONCAT(t2.Age,' / ',t2.Gender)AgeSex,CONCAT(rm.Floor,'/',rm.Name,'/',rm.bed_no)Floorbed,CONCAT(rm.Name,'/',rm.Floor)RoomName,CONCAT('/',rm.Room_No,'/',rm.bed_no)Room_No,t2.IPDCaseTypeID,fpm.ReferenceCode,t2.PanelID,t2.DischargeType,t2.KinRelation,t2.KinName ");
                sb.Append(" ,t2.TransNo from ");
                sb.Append("(Select t1.*,pm.ID,pm.Title,PName,pm.Mobile,Gender,LEFT(House_No,50)House_No,Street_Name,Locality,City,Country,Age,pm.Relation,pm.RelationName ");
                sb.Append("    from (Select pip.PatientID,pip.IPDCaseTypeID,pip.IPDCaseTypeID_Bill,pip.RoomID,");
                sb.Append("        pip.TransactionID,pip.Status,Date_Format(pmh.DateOfAdmit,'%d-%b-%Y')DateOfAdmit,");
                sb.Append("        Time_format(pmh.TimeOfAdmit,'%l:%i %p')TimeOfAdmit,pmh.DoctorID,pmh.PanelID,pmh.DischargeType,pmh.KinRelation,pmh.KinName,");
                sb.Append("        if(pmh.DateOfDischarge='0001-01-01','-',Date_Format(pmh.DateOfDischarge,'%d-%b-%Y'))DateOfDischarge,");
                sb.Append("        if(pmh.TimeOfDischarge='00:00:00','',Time_format(pmh.TimeOfDischarge,'%l:%i %p'))TimeOfDischarge,pmh.TransNo ");
                sb.Append("    from ");
                sb.Append("    (Select pip1.PatientIPDProfile_ID,pip1.PatientID,pip1.IPDCaseTypeID,");
                sb.Append("        pip1.IPDCaseTypeID_Bill,pip1.RoomID,pip1.TransactionID,pip1.Status ");
                sb.Append("        from patient_ipd_profile pip1 inner join ");
                sb.Append("        (Select max(PatientIPDProfile_ID)PatientIPDProfile_ID ");
                sb.Append("         from patient_ipd_profile Where status = '" + status + "' ");
                if (TransactionId != "")
                    sb.Append(" and TransactionID='" + TransactionId + "'");
                if (PatientId != "")
                    sb.Append(" and PatientID='" + PatientId + "'");
                if (RoomID != "")
                    sb.Append(" and IPDCaseTypeID = '" + RoomID + "'");
                sb.Append("group by TransactionID ");
                sb.Append("        )pip2 on pip1.PatientIPDProfile_ID = pip2.PatientIPDProfile_ID ");
             //   sb.Append("    )pip inner join ipd_case_history ich on pip.TransactionID = ich.TransactionID ");
                sb.Append("    )pip inner join patient_medical_history pmh on pmh.TransactionID = pip.TransactionID and pmh.Type='IPD' ");
                sb.Append("Where pmh.status='" + status + "'  ");
                if (TransactionId != "")
                    sb.Append(" and pmh.TransactionID='" + TransactionId + "'");
                if (FromAdmitDate != "" && ToAdmitDate != "")
                    sb.Append(" and pmh.DateOfAdmit >= '" + Util.GetDateTime(FromAdmitDate).ToString("yyyy-MM-dd") + "' and pmh.DateOfAdmit <= '" + Util.GetDateTime(ToAdmitDate).ToString("yyyy-MM-dd") + "'");
                else if (FromAdmitDate != "" && ToAdmitDate == "")
                    sb.Append(" and pmh.DateOfAdmit >= '" + Util.GetDateTime(FromAdmitDate).ToString("yyyy-MM-dd") + "'");
                if (iCheck == 0)
                {
                    if (DischargeDateFrom != "" && DischargeDateTo != "")
                        sb.Append(" and pmh.DateOfDischarge >= '" + Util.GetDateTime(DischargeDateFrom).ToString("yyyy-MM-dd") + "' and pmh.DateOfDischarge <= '" + Util.GetDateTime(DischargeDateTo).ToString("yyyy-MM-dd") + "'");
                    else if (DischargeDateFrom != "" && DischargeDateTo == "")
                        sb.Append(" and pmh.DateOfDischarge >= '" + Util.GetDateTime(DischargeDateFrom).ToString("yyyy-MM-dd") + "'");
                }
                if (Company != "")
                    sb.Append(" and PanelID=" + Company + " ");
                if (DoctorID != "")
                    sb.Append(" and DoctorID = '" + DoctorID + "'");
                sb.Append(") t1 inner join  patient_master pm  ");
                sb.Append("on t1.PatientID = pm.PatientID ");

                if (PatientId != "" && PatientName != "")
                    sb.Append(" Where pm.PatientID='" + PatientId + "' and pname like '%" + PatientName + "%'");
                else if (PatientId != "" && PatientName == "")
                    sb.Append(" Where pm.PatientID='" + PatientId + "'");
                else if (PatientName != "" && PatientId == "")
                    sb.Append(" Where pname like '%" + PatientName + "%'");
                sb.Append(" ) t2 ");
                sb.Append("inner join f_panel_master fpm on fpm.PanelID = t2.PanelID ");
                sb.Append("inner join doctor_master dm on t2.DoctorID = dm.DoctorID  inner join ipd_case_type_master ictm1 ");
                sb.Append("on ictm1.IPDCaseTypeID = t2.IPDCaseTypeID inner join ipd_case_type_master ictm2 ");
                sb.Append("on ictm2.IPDCaseTypeID = t2.IPDCaseTypeID_Bill  inner join room_master rm on rm.RoomId = t2.roomid ");
                sb.Append("order by t2.ID desc, t2.PName, t2.PatientID");
                DataTable Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, sb.ToString()).Tables[0];

                if (IsLocalConn)
                    if (objCon.State == ConnectionState.Open) objCon.Close();
                if (Items.Rows.Count > 0)
                    return Items;
                else
                    return null;
            }
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
                if (objCon.State == ConnectionState.Open) objCon.Close();
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            return null;
        }
    }

    public DataSet GoodsReceiptNoteReport(string LTNo)
    {
        try
        {
            string sql = "select LTD. NetAmount, if(IsFree=1,'Yes','No')IsFree ,LTD.Rate RateBuy, St.GRNo as LedgerTransactionNo, IM.ItemID,IM.BillingUnit as Unit,UnitType, St.StockID,St.Naration,St.IsPost,St.GRNDate , St.GRNo ,St.ItemName, St.BatchNumber, St.MedExpiryDate, St.RecQnty , St.Rate, St.MRP , ltd.DiscountPercentage from (select ItemID,BillingUnit,UnitType from f_itemmaster where ItemID in (select ItemID from f_stock where  LedgerTransactionNo = '" + LTNo + "'))IM, ((select StockID,Naration,IsPost,StockDate as GRNDate , LedgerTransactionNo as GRNo ,ItemID,ItemName, BatchNumber, MedExpiryDate, InitialCount as RecQnty , UnitPrice as Rate, MRP   from f_stock where LedgerTransactionNo = '" + LTNo + "'))St, (select IsFree ,ItemID,StockID,DiscountPercentage,Rate , Amount as NetAmount from f_ledgertnxdetail where LedgerTransactionNo = '" + LTNo + "')LTD where LTD.StockID = st.StockID and  LTd.ItemID = st.ItemID  and  IM.ItemID = st.ItemID";
            return MySqlHelper.ExecuteDataset(objCon, CommandType.Text, sql);
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            return null;
        }
    }
    public DataSet GoodsReceiptNoteReport1(string LTNo, string storeledgerno)
    {
        try
        {
            string sql = "";
            string TypeofTnx = "";
            if (storeledgerno == "STO00001")
                TypeofTnx = "Purchase";
            else
                TypeofTnx = "nmPurchase";
            sql = "select distinct(LedgerTransactionNo) ,SupCode, SupName , SupAddress , LedgerNoCr , PONo ,date_format(ApprovedDate,'%d-%b-%Y')ApprovedDate,ChalanNo, ChalanDate, Billno, NetAmount, BillDate, Mobile , Telephone,Freight,Octori,GatePassIn as GatePassInWard,RoundOff,PaymentModeID as GrnPaymentMode,ExciseOnBill,Scheme  from (select po.RaisedDate ApprovedDate,im.ChalanNo,(if(im.chalanno = '','',date_format(im.chalandate,'%d-%b-%y'))) as  ChalanDate, im.InvoiceNo as Billno , (if(im.InvoiceNo = '','',date_format(im.InvoiceDate,'%d-%b-%y')))  as BillDate,  lt.LedgerTransactionNo , lt.LedgerNoCr , lt.AgainstPONo as  PONo, lt.NetAmount,lt.Freight,lt.Octori,lt.ExciseOnBill,lt.Scheme,lt.GatePassIn, REPLACE(vm.Vendor_ID,'LSHHI','') AS SupCode, vm.VendorName as SupName,vm.Address1 as SupAddress ,  vm.Mobile , vm.Telephone ,lt.RoundOff, (SELECT PaymentMode FROM paymentmode_master WHERE PaymentModeId=lt.PaymentModeID)PaymentModeID,im.DiffBillAmt from  f_stock im inner join f_ledgertransaction lt on im.LedgerTransactionNo = lt.LedgerTransactionNo  inner join f_ledgermaster lm on lm.LedgerNumber = lt.LedgerNoCr inner join f_vendormaster vm on vm.Vendor_ID = lm.LedgerUserID inner join f_purchaseorder po on po.PurchaseOrderNo=im.PONumber  where lt.TypeOfTnx = '" + TypeofTnx + "' and lt.LedgerTransactionNo = '" + LTNo + "' and (im.ChalanNo = lt.ChalanNo and im.InvoiceNo = lt.InvoiceNo) and im.StoreLedgerNo='" + storeledgerno + "')temp";
            return MySqlHelper.ExecuteDataset(objCon, CommandType.Text, sql);

        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            return null;
        }
    }
    public DataSet GoodsReceiptNoteReport3(string LTNo, string storeledgerno)
    {
        try
        {
            string sql = " SELECT ltd.ItemID,ltd.LedgerTransactionNO,ltd.StockID, " +
                  "  IFNULL(st.PurTaxPer,0) VATPer,IFNULL(st.PurTaxAmt,0) VATAmt,IFNULL(st.ExcisePer,0)ExcisePer,IFNULL(st.ExciseAmt*st.ConversionFactor,0)ExciseAmt    " +
                  " FROM f_ledgertnxdetail ltd INNER  JOIN f_stock st ON ltd.StockID=st.StockID  AND ltd.LedgerTransactionNO = st.LedgerTransactionNo " +
                  " WHERE ltd.LedgerTransactionNO='" + LTNo + "' AND st.StoreLedgerNo='" + storeledgerno + "' ";
            return MySqlHelper.ExecuteDataset(objCon, CommandType.Text, sql);
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            return null;
        }
    }
    public decimal d_GetBillAmount(string TID)// Gaurav 17.06.2018
    {
        StringBuilder sb = new StringBuilder();
        if (Resources.Resource.IsBilledFinalised == "1")
        {
            sb.Clear();
            sb.Append("   SELECT SUM(PaidAmount)PaidAmount FROM ( ");
            sb.Append("   SELECT CONVERT(SUM(Rate * Quantity),DECIMAL(10,2)) PaidAmount FROM f_ledgertnxdetail WHERE TransactionID='" + TID + "' AND IsVerified = 1 AND IsPAckage=0 ");
            sb.Append("   UNION ALL ");
            sb.Append("   SELECT CONVERT(SUM(Rate * Quantity),DECIMAL(10,2)) PaidAmount FROM f_ledgertransaction lt ");
            sb.Append("   INNER JOIN f_ledgertnxdetail ltd ON lt.TransactionID=ltd.TransactionID WHERE lt.IPNo='" + TID + "' AND ltd.IsVerified = 1 AND ltd.IsPAckage=0 ");
            sb.Append("   )t ");
        }
        else
        {
            sb.Clear();
            sb.Append("   SELECT SUM(PaidAmount)PaidAmount FROM ( ");
            sb.Append("   SELECT CONVERT(SUM(Rate * Quantity),DECIMAL(10,2)) PaidAmount FROM d_f_ledgertnxdetail WHERE TransactionID='ISHHI43' AND IsVerified = 1 AND IsPAckage=0 ");
            sb.Append("   UNION ALL ");
            sb.Append("   SELECT CONVERT(SUM(Rate * Quantity),DECIMAL(10,2)) PaidAmount FROM d_f_ledgertransaction lt ");
            sb.Append("   INNER JOIN d_f_ledgertnxdetail ltd ON lt.TransactionID=ltd.TransactionID WHERE lt.IPNo='ISHHI43' AND ltd.IsVerified = 1 AND ltd.IsPAckage=0 ");
            sb.Append("   )t ");
        }
        try
        {
            return Util.GetDecimal(MySqlHelper.ExecuteScalar(objCon, CommandType.Text, sb.ToString()));
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            return 0;
        }
    }
    public decimal d_GetTDS(string TID)
    {
        try
        {
            return Util.GetDecimal(MySqlHelper.ExecuteScalar(objCon, CommandType.Text, "select IFNULL(TDS,0)TDS from d_f_ipdadjustment where TransactionID='" + TID + "' "));
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            return 0;
        }
    }
    public static string getDischargeDate(string TransactionID)
    {
        try
        {
            return StockReports.ExecuteScalar("Select IF(DateOfDischarge='0001-01-01','',DATE_FORMAT(DateOfDischarge,'%d-%b-%Y'))DateOfDischarge from patient_medical_history Where TransactionID = '" + TransactionID + "'");//ipd_case_history
        }
        catch (Exception ex)
        {
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return "";
        }
    }
    public DataTable GetCategoryByItemID(string ItemID)
    {
        DataView dv = LoadCacheQuery.loadOPDDiagnosisItems("", "0", "0").DefaultView;
        dv.RowFilter = "NewItemID ='" + ItemID + "'";
        return dv.ToTable();
    }
    //To get the full information of corpse //*18-1-2016*//
    public DataTable GetCorpseInformation(string TransactionID)
    {
        StringBuilder Query = new StringBuilder();
        Query.Append("SELECT IFNULL(CM.PatientID,'')PatientID,IFNULL(CM.TransactionID,'') IPDNo,CM.Corpse_ID,CM.CName,CM.Age,CM.Gender,DATE_FORMAT(CM.DeathDate,'%d-%b-%Y')DateofDeath,TIME_FORMAT(CM.DeathTime,'%h:%i %p')TimeofDeath,CM.DeathType,CD.FreezerID,CONCAT(FM.RackName,'-',FM.Rack_No,' /','Shelf:',FM.ShelfNo)FreezerName,REPLACE(CD.TransactionID,'CRSHHI','')DepositeNo,CM.Nationality,CM.PlaceOfDeath,CM.Address,CM.Locality,CM.City,(SELECT `Name` FROM country_master WHERE CountryID=CM.Country)Country,CM.RelativeName,CM.TypeOfRelation,CM.RelativeAddress,CM.RelativeContact,CD.Remarks,CD.BroughtBY,CM.Religion, ");
        Query.Append("CD.TransactionID,DATE_FORMAT(CD.InDate,'%d-%b-%Y %h:%i %p')DepositeDateTime,CD.IsReleased,DATE_FORMAT(CD.OutDate,'%d-%b-%Y %h:%i %p')ReleasedDateTime,CONCAT(EM.Title,' ',EM.Name)AdmittedBy,CD.DoctorID,CONCAT(DM.Title,' ',DM.Name)DName,(SELECT PatientType FROM patient_type WHERE id=CM.Type)`Type`,(SELECT CONCAT(Title,' ',NAME) FROM doctor_master WHERE DoctorID=CD.AuthDoctor)AuthName, ");
        Query.Append("IF(PM.CorpseID IS NOT NULL,1,0)IsPMRequest,PM.IsApproved,PM.IsSend,PM.IsPostmortem FROM mortuary_corpse_master CM INNER JOIN mortuary_corpse_deposite CD ON CM.Corpse_ID=CD.CorpseID ");
        Query.Append("INNER JOIN employee_master DM ON DM.EmployeeID=CD.DoctorID INNER JOIN employee_master EM ON CM.CreatedBy=EM.EmployeeID LEFT JOIN mortuary_postmortem PM ON CM.Corpse_ID=PM.CorpseID INNER JOIN mortuary_freezer_master FM ON FM.RackID=CD.FreezerID WHERE CD.IsCancel=0 AND CD.TransactionID='" + TransactionID + "'");

        DataTable dt = StockReports.GetDataTable(Query.ToString());

        return dt;
    }

    //To get corpse release status
    public DataTable GetCorpseReleasedStatus(string TransactionID)
    {
        string Query = "SELECT DATE_FORMAT(OutDate,'%d-%b-%Y %h:%i %p')ReleasedDateTime,IsReleased FROM mortuary_corpse_deposite WHERE TransactionID='" + TransactionID + "'";
        DataTable dt = StockReports.GetDataTable(Query);
        return dt;
    }

    //To get corpse deposite date
    public string GetCorpseDepositeDate(string TransactionID)
    {
        string Query = "SELECT DATE_FORMAT(InDate,'%d-%b-%Y')DepositeDate FROM mortuary_corpse_deposite WHERE TransactionID='" + TransactionID + "'";
        DataTable dt = StockReports.GetDataTable(Query);
        return dt.Rows[0]["DepositeDate"].ToString();
    }


    //To get total bill amount
    public decimal GetMortuaryBillAmount(string TID)
    {
        string sql = "select CONVERT(SUM(Rate * Quantity),DECIMAL(10,2)) PaidAmount from mortuary_ledgertnxdetail where TransactionID='" + TID + "' and IsVerified = 1 and IsPAckage=0";
        try
        {
            decimal Amoumt = Util.GetDecimal(StockReports.ExecuteScalar(sql));
            return Amoumt;
        }
        catch (Exception ex)
        {
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return 0;
        }
    }

    //To get total received amount
    public decimal GetMortuaryPaidAmount(string TID)
    {
        string sql = "select IFNULL(Round(sum(AmountPaid),2),0) PaidAmount from mortuary_receipt where TransactionID='" + TID + "' and IsCancel = 0";

        try
        {
            decimal Amoumt = Util.GetDecimal(StockReports.ExecuteScalar(sql));
            return Amoumt;
        }
        catch (Exception ex)
        {
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return 0;
        }

    }

    //To get bill number
    public DataTable GetMortuaryBillDetail(string TransactionID)
    {
        string sql = "SELECT ifnull(BillNo,'')BillNo,DATE_FORMAT(BillDate,'%d-%b-%Y')BillDate FROM mortuary_corpse_deposite WHERE TransactionID='" + TransactionID + "' LIMIT 1;";
        DataTable dt = StockReports.GetDataTable(sql);
        if (dt.Rows.Count > 0)
        {
            return dt;
        }
        else
        {
            return null;
        }
    }

    //To Get All Receipts
    public DataTable GetMortuaryReceipt(string TransactionID)
    {
        try
        {

            string sql = "Select ReceiptNo,Round(AmountPaid)AmountPaid,Date_Format(Date,'%d-%b-%y')Date,TIME_FORMAT(TIME,'%h: %i %p')Time,(SELECT CONCAT(Title,' ',NAME) FROM employee_master WHERE employeeID=Reciever)Receiver,TransactionID,if(Amountpaid <0,'Refund','Received')Type from mortuary_receipt Where TransactionID ='" + TransactionID + "' and Iscancel=0 order by Date";
            if (IsLocalConn)
            {
                DataTable dt = StockReports.GetDataTable(sql);
                return dt;
            }
            else
            {
                return null;
            }
        }
        catch (Exception ex)
        {
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return null;
        }
    }

    //Get Corpse LedgerNo
    public string GetCorpseLedgerNo(string TID)
    {
        string Items = "";
        try
        {
            string strQuery = "SELECT LedgerNumber AS PLedgerNo FROM f_ledgermaster WHERE GroupID='PTNT' AND LedgerUserID =(SELECT PatientID FROM mortuary_corpse_master WHERE Corpse_ID=(SELECT CorpseID FROM mortuary_corpse_deposite WHERE TransactionID='" + TID + "'))";

            var result = MySqlHelper.ExecuteScalar(objCon, CommandType.Text, strQuery);

            if (result != null)
            {
                Items = result.ToString();
            }
            else
            {
                Items = "CASH002";
            }

            if (IsLocalConn)
            {
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }

            if (Items != "")
            {
                return Items;
            }
            else
            {
                return null;
            }
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return null;
        }
    }

    //Get Mortuary Bill Number
    public string GetNewBillNoMortuary(int CentreID)
    {
        string Bill_No = "";
        try
        {
            MySqlParameter LedTxnID = new MySqlParameter();
            LedTxnID.ParameterName = "@Bill_No";
            LedTxnID.MySqlDbType = MySqlDbType.VarChar;
            LedTxnID.Size = 50;
            LedTxnID.Direction = ParameterDirection.Output;

            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("f_Generate_Bill_No_Mortuary");

            MySqlCommand cmd;
            if (this.objTrans != null && this.objCon == null)
            {
                cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new MySqlParameter("@vCentreID", CentreID));
                cmd.Parameters.Add(LedTxnID);
                Bill_No = cmd.ExecuteScalar().ToString();
            }
            else if (this.objCon != null && this.objTrans == null)
            {
                cmd = new MySqlCommand(objSQL.ToString(), objCon);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new MySqlParameter("@vCentreID", CentreID));
                cmd.Parameters.Add(LedTxnID);
                Bill_No = cmd.ExecuteScalar().ToString();
            }

            if (IsLocalConn)
            {
                this.objCon.Close();
            }

            return Bill_No;

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            if (IsLocalConn)
            {
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }
            return null;
        }
    }
    public string GetNewBillNoIPD(int CentreID)
    {
        string Bill_No = "";
        try
        {
            MySqlParameter LedTxnID = new MySqlParameter();
            LedTxnID.ParameterName = "@Bill_No";
            LedTxnID.MySqlDbType = MySqlDbType.VarChar;
            LedTxnID.Size = 50;
            LedTxnID.Direction = ParameterDirection.Output;

            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("f_Generate_Bill_No_IPD");

            MySqlCommand cmd;
            if (this.objTrans != null && this.objCon == null)
            {
                cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new MySqlParameter("@vCentreID", Util.GetInt(CentreID)));
                cmd.Parameters.Add(LedTxnID);
                Bill_No = cmd.ExecuteScalar().ToString();
            }
            else if (this.objCon != null && this.objTrans == null)
            {
                cmd = new MySqlCommand(objSQL.ToString(), objCon);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new MySqlParameter("@vCentreID", Util.GetInt(CentreID)));
                cmd.Parameters.Add(LedTxnID);
                Bill_No = cmd.ExecuteScalar().ToString();
            }
            if (IsLocalConn)
            {
                this.objCon.Close();
            }

            return Bill_No;

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            if (IsLocalConn)
            {
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }

            return null;
        }
    }
    public DataTable getItemByConfigID(string ConfigID, string PanelID)
    {
        DataTable Items = new DataTable();
        try
        {
            string strQuery = "SELECT  CONCAT(IFNULL(im.ItemCode,''),' # ',IM.TypeName)TypeName,CONCAT(IFNULL(IM.ItemID,''),'#',IFNULL(IM.SubCategoryID,''),'#', IFNULL(SC.Name,''),'#',IFNULL(Type_ID,''),'#',IF(pay.ItemID IS NULL,'0','1'))ItemID,IM.SubCategoryID,SC.CategoryID FROM f_itemmaster im INNER JOIN f_subcategorymaster sc ON im.SubCategoryID = sc.SubCategoryID and sc.Active=1 INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID LEFT JOIN f_item_outsource io ON im.ItemID = io.ItemID AND io.IsActive=1 LEFT JOIN f_panel_item_payable pay ON Pay.ItemID=im.ItemID AND Pay.PanelID=" + PanelID + " AND  pay.IsActive=1 WHERE im.IsActive=1 AND cf.ConfigID IN (" + ConfigID + ") AND io.ItemID IS NULL ORDER BY TypeName ";
            Items = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strQuery).Tables[0];

            if (IsLocalConn)
            {
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }

            if (Items.Rows.Count > 0)
            {
                return Items;
            }
            else
            {
                return null;
            }
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public decimal GetBillAmount(string TID)
    {
        string sql = "select CONVERT(SUM(Rate * Quantity),DECIMAL(10,2)) PaidAmount from f_ledgertnxdetail where TransactionID='" + TID + "' and IsVerified = 1 and IsPAckage=0";
        try
        {
            decimal Amoumt = Util.GetDecimal(MySqlHelper.ExecuteScalar(objCon, CommandType.Text, sql));
            return Amoumt;
        }
        catch (Exception ex)
        {
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return 0;
        }
    }
    public decimal GetWriteoff(string TID)
    {
        try
        {
            return Util.GetDecimal(MySqlHelper.ExecuteScalar(objCon, CommandType.Text, "Select IFNULL(WriteOff,0)WriteOff from patient_medical_history where TransactionID='" + TID + "'"));
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            return 0;
        }
    }
    public static bool UpdateDoctorTab_Information(string TID, int TabID)
    {
        bool Status = StockReports.ExecuteDML("Update CPOE_Viewed_tab set Status=1,StatusDateTime=NOW() where TransactionID='" + TID + "' and TabID=" + TabID + "");
        return Status;
    }

    public static DataTable GetItemsByCategorySubcategory(string categoryID, string subCategoryID)
    {
        return StockReports.GetDataTable("Call sp_GetItemsByCategorySubcategory('" + categoryID + "','" + subCategoryID + "')");
    }

    public DataTable getTypeMaster()
    {
        try
        {

            string strSelect = "select TypeID,TypeName from f_typemaster ";

            DataTable dt = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, strSelect).Tables[0];

            if (IsLocalConn)
            {
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }
            return dt;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            if (IsLocalConn)
            {
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }
            return null;
        }
    }

}