using System;
using System.Data;
using System.Text;
using System.Web;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for AllUpdate
/// </summary>
public class AllUpdate
{

	public AllUpdate()
	{
		objCon = Util.GetMySqlCon();
		IsLocalConn = true;
	}

	public AllUpdate(MySqlTransaction objTrans)
	{
		this.objTrans = objTrans;
		this.IsLocalConn = false;
	}

	#region All Global Variables    
	 MySqlConnection objCon;
	 MySqlTransaction objTrans;
	 bool IsLocalConn;

	#endregion

	 public string UpdateItemMaster(string Items, string Subcategory, int validity)
	 {
		 try
		 {
	   
			 string RowUpdated = "";

			 string strQuery = "update f_itemmaster set ValidityPeriod=" + validity + " where ItemID in(" + Items + ")";
			 if (this.objCon != null && this.objTrans == null)
				 RowUpdated = MySqlHelper.ExecuteNonQuery(objCon, CommandType.Text, strQuery).ToString();
			 else if (this.objTrans != null && this.objCon == null)
				 RowUpdated = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, strQuery).ToString();
			 if (IsLocalConn)
				 this.objCon.Close();
			 if (RowUpdated != "")
				 return "1";
			 else
				 return "0";
		 }
		 catch (Exception ex)
		 {
			 if (IsLocalConn)
				 this.objCon.Close();
			 ClassLog cl = new ClassLog();
			 cl.errLog(ex);
			 return "0";
		 }
	 }
	 public string UpdateIPDCase(string PatientID, string TransactionID, string Status, string PatientIPdProfile, string Type, MySqlTransaction Tranx, string UserID, string DischargeReason)
	 {
		 try
		 {
			 string RowUpdated = "", RowUpdated1 = "", strQuery = "", strQuery1 = "";
			 if (Type == "IN")
			 {
				 strQuery = "update ipd_case_history set AdmissionCancelledBy  ='" + UserID + "',AdmissionCancelReason  ='" + DischargeReason + "',AdmissionCancelDate  =NOW(), Status='" + Status + "' where  TransactionID='" + TransactionID + "'";
				 strQuery1 = "update patient_ipd_profile set Status='" + Status + "',TobeBill=2  where TransactionID='" + TransactionID + "' and Status='IN'";
			 }
			 else if (Type == "Held")
			 {
				 strQuery = "update ipd_case_history set Status='" + Status + "' where  TransactionID='" + TransactionID + "'";
				 strQuery1 = "update patient_ipd_profile set Status='" + Status + "',TobeBill=3  where TransactionID='" + TransactionID + "' and Status='IN'";
			 }
			 else if (Type == "OpenHeld")
			 {
				 strQuery = "update ipd_case_history set Status='" + Status + "' where  TransactionID='" + TransactionID + "'";
				 strQuery1 = "update patient_ipd_profile set Status='" + Status + "',TobeBill=1  where TransactionID='" + TransactionID + "' and Status='held'";
			 }
			 else if (Type == "OUT")
			 {
				 strQuery = "update ipd_case_history set DischargedCancelledBy ='" + UserID + "',DischargeCancelReason ='" + DischargeReason + "',DischargeCancelDate =NOW(), Status='" + Status + "' where  TransactionID='" + TransactionID + "'";
				 strQuery1 = "update patient_ipd_profile set Status='" + Status + "'  where TransactionID='" + TransactionID + "' and PatientIPDProfile_ID='" + PatientIPdProfile + "'";
			 }
			 RowUpdated = Util.GetString(MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery));
			 RowUpdated1 = Util.GetString(MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery1));
			 if (RowUpdated != "" && RowUpdated1 != "")
				 return "1";
			 else
				 return "0";
		 }
		 catch (Exception ex)
		 {
			 ClassLog cl = new ClassLog();
			 cl.errLog(ex);
			 return "0";
		 }
	 }
	 public int UpdateQtyInHandByItemID(string ItemID, string Qty, string TranType)
	 {
		 int RowUpdated = 0;
		 try
		 {
			 string strQuery = "";
			 if (TranType == "StoreToDept")
			 {
				 strQuery = "Update f_itemmaster  Set QtyInHand = QtyInHand - " + Util.GetFloat(Qty) + " Where ItemID = '" + ItemID + "'";
			 }
			 if (TranType == "DeptToStore")
			 {
				 strQuery = "Update f_itemmaster  Set QtyInHand = QtyInHand + " + Util.GetFloat(Qty) + " Where ItemID = '" + ItemID + "'";
			 }
			 if (TranType == "StoreToPatient")
			 {
				 strQuery = "Update f_itemmaster  Set QtyInHand = QtyInHand - " + Util.GetFloat(Qty) + " Where ItemID = '" + ItemID + "'";
			 }
			 if (TranType == "StoreToVendor")
			 {
				 strQuery = "Update f_itemmaster  Set QtyInHand = QtyInHand - " + Util.GetFloat(Qty) + " Where ItemID = '" + ItemID + "'";
			 }
			 if (TranType == "StockAdjustment")
			 {
				 strQuery = "Update f_itemmaster  Set QtyInHand = QtyInHand - " + Util.GetFloat(Qty) + " Where ItemID = '" + ItemID + "'";
			 }
			 if (TranType == "StockUpdate")
			 {
				 strQuery = "Update f_itemmaster  Set QtyInHand = QtyInHand + " + Util.GetFloat(Qty) + " Where ItemID = '" + ItemID + "'";
			 }

			 if (this.objTrans != null && this.objCon == null)
			 {
				 RowUpdated = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, strQuery);

			 }
			 return RowUpdated;
		 }
		 catch (Exception ex)
		 {
			 ClassLog cl = new ClassLog();
			 cl.errLog(ex);
			 if (IsLocalConn)
				 if (objCon.State == ConnectionState.Open) objCon.Close();
			 return RowUpdated;
		 }
	 }
	 public int UpdateLdgTrnx(decimal TotalAmt, decimal NetAmt, string LdgTnxNo)
	 {
		 int RowUpdated = 0;
		 try
		 {
			 string strQuery = "update f_ledgertransaction set GrossAmount=" + TotalAmt + ",NetAmount=" + NetAmt + " where LedgerTransactionNo='" + LdgTnxNo + "'";
			 if (this.objTrans != null && this.objCon == null)
				 RowUpdated = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, strQuery);
			 return RowUpdated;
		 }
		 catch (Exception ex)
		 {
			 ClassLog cl = new ClassLog();
			 cl.errLog(ex);
			 if (IsLocalConn)
				 if (objCon.State == ConnectionState.Open) objCon.Close();
			 return 2;
		 }
	 }
	 public string CancelBillNo(string BillNo, string CRNo, string IPDProfile, MySqlTransaction Tranx)
	 {
		 try
		 {
			 string RowUpdated = "";

			 //------------Updating f_ipdadjustment with BillNo set to tempBill and  BillNo set to Blank ------------------

             string strQuery = "update patient_medical_history set BillNo='' , TempBillNo='" + BillNo + "',BillclosedUserID='',BillClosedDate='0001-01-01 00:00:00'  where BillNo='" + BillNo + "' and TransactionID='" + CRNo + "'";
			 RowUpdated = Util.GetString(MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery));
			 strQuery = "update patient_ipd_profile set TobeBill=1  where PatientIPDProfile_ID=" + IPDProfile + "";
			 RowUpdated = Util.GetString(MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery));

             strQuery = " CALL UnPostBillWiseDoctorShare(" + CRNo + ",'" + HttpContext.Current.Session["ID"].ToString() + "') ";
             RowUpdated = Util.GetString(MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery));


			 return "1";

		 }

		 catch (Exception ex)
		 {
			 ClassLog cl = new ClassLog();
			 cl.errLog(ex);
			 return "0";
		 }
	 }
	 public string UpdatePanelMaster(string PanelID, string Company, string Address1, string Address2,
		 string PanelCode, string IsTPa, string Email, string Phone, string Mobile, string Contact,
        string Fax, string RefCodeOPD, string RefCodeIPD, string IsServiceTax, string agreement,
        string DateFrom, string DateTo, string CreditLimit, string PaymentMode, string PanelGroup, MySqlTransaction tnx, int PanelGroupID,
         int HideRate, int ShowPrintOut, int coPaymentOn, double coPaymentPercent, int rateCurrencyCountryID, int BillCurrencyCountryID, string BillCurrencyCountryName, decimal BillCurrencyConversion, int IsCash, int coverNote, decimal PanelAmountLimit, int IsPrivateDiet, int IsSmartCard)
    {

        try
        {

            string sql = "update f_panel_master set Company_Name = '" + Company + "',Add1='" + Address1 + "',Add2='" + Address2 + "',Panel_Code='" + PanelCode + "',IsTPA='" + IsTPa + "',EmailID='" + Email + "',Phone='" + Phone + "',Mobile='" + Mobile + "',Contact_Person='" + Contact + "',Fax_No='" + Fax + "',ReferenceCode ='" + RefCodeIPD + "',ReferenceCodeOPD ='" + RefCodeOPD + "',IsServiceTax = " + IsServiceTax + ",agreement='" + agreement + "',DateFrom='" + DateFrom + "',DateTo='" + DateTo + "',CreditLimit='" + CreditLimit + "',PaymentMode='" + PaymentMode + "',PanelGroup='" + PanelGroup + "',PanelGroupID='" + PanelGroupID + "',LastUpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "',Updatedate=NOW(),HideRate='" + HideRate + "',ShowPrintOut='" + ShowPrintOut + "',Co_PaymentOn=" + coPaymentOn + ",Co_PaymentPercent=" + coPaymentPercent + ",RateCurrencyCountryID=" + rateCurrencyCountryID + " , BillCurrencyCountryID=" + BillCurrencyCountryID + ",BillCurrencyNotation='" + BillCurrencyCountryName + "', BillCurrencyConversion=" + BillCurrencyConversion + ",IsCash =" + IsCash + ",CoverNote =" + coverNote + ",PanelAmountLimit=" + PanelAmountLimit + ", IsPrivateDiet=" + IsPrivateDiet + ", IsSmartCard=" + IsSmartCard + " where PanelID=" + PanelID + " ";
            return MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql).ToString();

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public string UpdateItemMaster(string ItemId, int ShowFlag)
    {
        try
        {
            string RowUpdated = "";

			 string strQuery = "update f_itemmaster set ShowFlag=" + ShowFlag + " where ItemID ='" + ItemId + "'";
			 if (this.objCon != null && this.objTrans == null)
			 {
				 RowUpdated = MySqlHelper.ExecuteNonQuery(objCon, CommandType.Text, strQuery).ToString();
			 }
			 else if (this.objTrans != null && this.objCon == null)
			 {
				 RowUpdated = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, strQuery).ToString();
			 }
			 if (IsLocalConn)
			 {
				 this.objCon.Close();

			 }
			 if (RowUpdated != "")
			 {
				 return "1";
			 }
			 else
			 {
				 return "0";
			 }

		 }
		 catch (Exception ex)
		 {
			 if (IsLocalConn)
			 {
				 this.objCon.Close();

			 }
			 ClassLog cl = new ClassLog();
			 cl.errLog(ex);
			 return "0";
		 }
	 }
	 public string UpdateLedgertnx(string LedgerTranNo)
	 {
		 try
		 {
			 int RowUpdated = 0;

			 string strQuery = "update  f_ledgertransaction set IsPaid = '1' where LedgerTransactionNo = '" + LedgerTranNo + "' ";
			 if (this.objCon != null && this.objTrans == null)
			 {
				 RowUpdated = MySqlHelper.ExecuteNonQuery(objCon, CommandType.Text, strQuery);

			 }
			 else if (this.objTrans != null && this.objCon == null)
			 {
				 RowUpdated = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, strQuery);
			 }
			 return RowUpdated.ToString();
		 }
		 catch (Exception ex)
		 {
			 ClassLog cl = new ClassLog();
			 cl.errLog(ex);
			 
			 return null;
			 throw (ex);
		 }

	 }
	 public int UpdateLedgerMasterWithCurrentBalance(string LedgerNo, float CurBal, int BalanaceType)
	 {
		 try
		 {
			 int RowUpdated = 0;

			 //------------Updating Ledger Master with New Current Balance------------------

			 string strQuery = "Update f_ledgermaster  Set CurrentBalance = CurrentBalance + " + CurBal + " ,BalanaceType=" + BalanaceType + " Where LedgerNumber = '" + LedgerNo + "'";

			 if (this.objTrans != null && this.objCon == null)
			 {
				 RowUpdated = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, strQuery);
				 return RowUpdated;
			 }
			 else if (this.objCon != null && this.objTrans == null)
			 {
				 RowUpdated = MySqlHelper.ExecuteNonQuery(objCon, CommandType.Text, strQuery);
				 return RowUpdated;
			 }

			 if (IsLocalConn)
			 {
				 this.objCon.Close();
				 return RowUpdated;
			 }
			 return RowUpdated;
		 }
		 catch (Exception ex)
		 {
			 if (IsLocalConn)
			 {
				 if (objCon.State == ConnectionState.Open) objCon.Close();
			 }
			 ClassLog cl = new ClassLog();
			 cl.errLog(ex);
			 return 0;
		 }
	 }
	 public int UpdatePatient_Details(string PatientID, string Title, string PatientName, string Age, string Gender, string DoctorID, string PanelID, string Type, string ItemID, string LedTranNo)
	 {
		 try
		 {
			 int RowUpdated = 0;

			 // Updating Patient Master
			 string strQuery = "update patient_master set Title = '" + Title + "',PName = '" + PatientName + "',Age = '" + Age + "',Gender = '" + Gender + "' Where PatientID = '" + PatientID + "'";

			 if (this.objCon != null && this.objTrans == null)
			 {
				 RowUpdated = Util.GetInt(MySqlHelper.ExecuteNonQuery(objCon, CommandType.Text, strQuery));
			 }
			 else if (this.objTrans != null && this.objCon == null)
			 {
				 RowUpdated = Util.GetInt(MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, strQuery));
			 }

			 // Updating Appointment
			 strQuery = "update appointment set Title = '" + Title + "',PName = '" + PatientName + "',Age = '" + Age + "',DoctorID = '" + DoctorID + "' Where PatientID = '" + PatientID + "'";

			 if (this.objCon != null && this.objTrans == null)
			 {
				 RowUpdated = Util.GetInt(MySqlHelper.ExecuteNonQuery(objCon, CommandType.Text, strQuery));
			 }
			 else if (this.objTrans != null && this.objCon == null)
			 {
				 RowUpdated = Util.GetInt(MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, strQuery));
			 }

			// Updating Ledger Transaction 
			strQuery = "update f_ledgertransaction set PanelID = " + PanelID + " Where LedgerTransactionNo = '" + LedTranNo + "'";

			if (this.objCon != null && this.objTrans == null)
			{
				RowUpdated = Util.GetInt(MySqlHelper.ExecuteNonQuery(objCon, CommandType.Text, strQuery));
			}
			else if (this.objTrans != null && this.objCon == null)
			{
				RowUpdated = Util.GetInt(MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, strQuery));
			}

			if (Type.ToUpper() == "OPD-APPOINTMENT")
			{
				// Updating Ledger Transaction Detail
				strQuery = "update f_ledgertnxdetail set ItemID = '" + ItemID + "' Where Ledgertransactionno =  '" + LedTranNo + "'";

				if (this.objCon != null && this.objTrans == null)
				{
					RowUpdated = Util.GetInt(MySqlHelper.ExecuteNonQuery(objCon, CommandType.Text, strQuery));
				}
				else if (this.objTrans != null && this.objCon == null)
				{
					RowUpdated = Util.GetInt(MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, strQuery));
				}
			}

			// Updating Patient_Medical_Hostory
			strQuery = "update patient_medical_history set DoctorID = '" + DoctorID + "',PanelID = " + PanelID + " Where PatientID = '" + PatientID + "'";

			if (this.objCon != null && this.objTrans == null)
			{
				RowUpdated = Util.GetInt(MySqlHelper.ExecuteNonQuery(objCon, CommandType.Text, strQuery));
			}
			else if (this.objTrans != null && this.objCon == null)
			{
				RowUpdated = Util.GetInt(MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, strQuery));
			}

			// Updating f_reciept

			strQuery = "Select Depositor from f_reciept Where Depositor = '" + PatientID + "'";

			if (this.objCon != null && this.objTrans == null)
			{
				PatientID = Util.GetString(MySqlHelper.ExecuteScalar(objCon, CommandType.Text, strQuery));
			}
			else if (this.objTrans != null && this.objCon == null)
			{
				PatientID = Util.GetString(MySqlHelper.ExecuteScalar(objTrans, CommandType.Text, strQuery));
			}

			if (PatientID != "")
			{
				strQuery = "update f_reciept set PanelID = " + PanelID + " Where Depositor = '" + PatientID + "'";

				if (this.objCon != null && this.objTrans == null)
				{
					RowUpdated = Util.GetInt(MySqlHelper.ExecuteNonQuery(objCon, CommandType.Text, strQuery));
				}
				else if (this.objTrans != null && this.objCon == null)
				{
					RowUpdated = Util.GetInt(MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, strQuery));
				}
			}


			if (IsLocalConn)
			{
				this.objCon.Close();

			}
			if (RowUpdated > 0)
			{
				return 1;
			}
			else
			{
				return 0;
			}

		}
		catch (Exception ex)
		{
			if (IsLocalConn)
			{
				this.objCon.Close();

			}
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return 0;
		}
	}
	public string UpdateAppointmentStatus(string AppID, string IsConfirm, string IsCancel, string IsReschedule, string CancelReason, MySqlTransaction tnx)
	{
		string result = "";
		string  Qupdate = "";
		string Qupdate1 = "";
		try
		{
			if (IsConfirm != "")
			{

                ExcuteCMD excuteCMD = new ExcuteCMD();

                string str = "SELECT MAX(ap.OPDVisitNo)+1 FROM    appointment ap WHERE ap.`IsConform`=1 ";

                int OPDVisitNo = Util.GetInt(excuteCMD.ExecuteScalar(tnx, str, CommandType.Text, new { }));

                Qupdate = "Update Appointment set IsConform=" + Util.GetInt(IsConfirm) + ",ConformDate='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',ConformBy='" + HttpContext.Current.Session["ID"].ToString() + "',OPDVisitNo='"+OPDVisitNo+"' WHERE App_ID=" + Util.GetInt(AppID) + "";
			}
			if (IsCancel != "")
			{
				Qupdate = "Update Appointment set IsCancel=" + Util.GetInt(IsCancel) + ",CancelReason='" + CancelReason + "',CancelDate='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',Cancel_UserID='" + HttpContext.Current.Session["ID"].ToString() + "' WHERE App_ID=" + Util.GetInt(AppID) + " and IsCancel=0";
				Qupdate1 = "Update appointment_detail set IsCancel=" + Util.GetInt(IsCancel) + " where App_ID=" + Util.GetInt(AppID) + "  and IsCancel=0";
			}
			if (IsReschedule != "")
			{
				Qupdate = "Update Appointment set IsReschedule=" + Util.GetInt(IsReschedule) + ",ReScheduleDate='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',RescheduleBy='" + HttpContext.Current.Session["ID"].ToString() + "' WHERE App_ID=" + Util.GetInt(AppID) + "";
			}

			result = Util.GetString(MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, Qupdate));
			if (Qupdate1 != "")
			{
				string result1 = Util.GetString(MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, Qupdate1));
			}
			return result;
		}
		catch (Exception ex)
		{
			if (IsLocalConn)
			{
				if (objCon.State == ConnectionState.Open) objCon.Close();
			}
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return "0";
		}
	}
	public int UpdateToBeBilled(string TransactionID, string RoomID)
	{
		try
		{
			int RowUpdated = 0;

			string strQuery = "update patient_ipd_profile set TOBEBILL=0 where TransactionID='" + TransactionID + "' and Room_ID='" + RoomID + "'";

			if (this.objTrans != null && this.objCon == null)
			{
				RowUpdated = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, strQuery);
			}

			if (IsLocalConn)
			{
				this.objCon.Close();
			}
			return RowUpdated;
		}
		catch (Exception ex)
		{
			if (IsLocalConn)
			{
				if (objCon.State == ConnectionState.Open) objCon.Close();
			}
			ClassLog ClLog = new ClassLog();
			ClLog.errLog(ex);
			return 0;
		}
	}
	public int UpdatePIP_Panel(string PanelID, string TransactionID)
	{
		try
		{
			int RowUpdated = 0;

			string strQuery = "Update patient_ipd_profile Set PanelID = " + PanelID + " Where TransactionID ='" + TransactionID + "'";

			if (this.objTrans != null && this.objCon == null)
			{
				RowUpdated = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, strQuery);
			}
			else if (this.objCon != null && this.objTrans == null)
			{
				RowUpdated = MySqlHelper.ExecuteNonQuery(objCon, CommandType.Text, strQuery);
			}

			if (IsLocalConn)
			{
				this.objCon.Close();
			}
			return RowUpdated;
		}
		catch (Exception ex)
		{
			if (IsLocalConn)
			{
				if (objCon.State == ConnectionState.Open) objCon.Close();
			}
			throw (ex);
		}
	}
	public int UpdateRoomStatus(string OldRoomID, string NewRoomID, string TransactionID)
	{
		try
		{
			int RowUpdated = 0;

			string strQueryOld = "update room_master set IsVacated = 1 where Room_Id = '" + OldRoomID + "'";
			string strQueryNew = "update room_master set IsVacated = 0 where Room_Id = '" + NewRoomID + "'";
			string UpdatePIP = "update patient_ipd_profile set Status = 'OUT' where Room_Id = '" + OldRoomID + "' and TransactionID = '" + TransactionID + "'";

			if (this.objTrans != null && this.objCon == null)
			{
				RowUpdated = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, strQueryOld);
				if (RowUpdated == 1)
				{
					RowUpdated = 0;
					RowUpdated = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, strQueryNew);
				}

				if (RowUpdated == 1)
				{
					RowUpdated = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, UpdatePIP);
				}
			}

			if (IsLocalConn)
			{
				this.objCon.Close();
			}
			return RowUpdated;
		}
		catch (Exception ex)
		{
			if (IsLocalConn)
			{
				if (objCon.State == ConnectionState.Open) objCon.Close();
			}
			ClassLog ClLog = new ClassLog();
			ClLog.errLog(ex);
			return 0;
		}
	}
	public string UpdateLedgerMsWithLedgerNumber(decimal Amount, string PatientLedger, string HospitalLedger, MySqlTransaction Trans)
	{
		//CalaculationType =Plus or Minus depending on the situation
		try
		{
			string strQuery, strQuery1;
			string RowUpdated = "", RowUpdated1 = "";
			strQuery = "Update f_ledgermaster Set CurrentBalance =CurrentBalance + '" + Amount + "' Where LedgerNumber ='" + HospitalLedger + "'";
			strQuery1 = "Update f_ledgermaster Set CurrentBalance =CurrentBalance - '" + Amount + "' Where LedgerNumber ='" + PatientLedger + "'";
			RowUpdated = Util.GetString(MySqlHelper.ExecuteNonQuery(Trans, CommandType.Text, strQuery));
			RowUpdated1 = Util.GetString(MySqlHelper.ExecuteNonQuery(Trans, CommandType.Text, strQuery1));

			return RowUpdated;
	   

		}
		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);

			return null;
			throw (ex);

		}
	}
	public string UpdateIPDAdjustment(string Type, string TID, string ApprovedBy, string Narration, string DiscountReason)
	{
		try
		{
			string RowUpdated = "";
			string strQuery = "";
			if (Type == "IPD")
			{
				strQuery = "update f_ipdadjustment set DiscountOnBillReason='" + DiscountReason + "',ApprovalBy='" + ApprovedBy + "',Narration='" + Narration + "'  where TransactionID='" + TID + "'";
			}
			else
			{
				strQuery = "update f_ledgertransaction set DiscountReason='" + DiscountReason + "',ApprovedBy='" + ApprovedBy + "',Remarks='" + Narration + "'  where TransactionID='" + TID + "'";
			}

			RowUpdated = MySqlHelper.ExecuteNonQuery(objCon, CommandType.Text, strQuery).ToString();
			if (RowUpdated != "0")
			{
				return "1";
			}
			else
			{
				return "0";
			}
		}

		catch (Exception ex)
		{
			ClassLog ClLog = new ClassLog();
			ClLog.errLog(ex);
			return "0";
		}
	}
	public string UpdateIPDAdjustment(decimal TDS, string TransactionID, MySqlTransaction Trans)
	{
		//CalaculationType =Plus or Minus depending on the situation
		try
		{
			string strQuery;
			string RowUpdated = "";
			string strTDSUpdate = "";
			string strTDS = "";
			//strQuery = "Update f_ipdadjustment Set TDS = " + TDS + " Where TransactionID ='" + TransactionID + "'";
			strTDSUpdate = "Update patient_medical_history Set TDS =IFNULL(TDS,0)+" + TDS + " Where TransactionID ='" + TransactionID + "'";
			if (this.objCon != null && this.objTrans == null)
			{
				strTDS = Util.GetString(MySqlHelper.ExecuteNonQuery(objCon, CommandType.Text, strTDSUpdate));
			}
			else if (this.objTrans != null && this.objCon == null)
			{
				strTDS = Util.GetString(MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, strTDSUpdate));
			}

            //if (this.objCon != null && this.objTrans == null)
            //{
            //    RowUpdated = Util.GetString(MySqlHelper.ExecuteNonQuery(Trans, CommandType.Text, strQuery));
            //}
            //else if (this.objTrans != null && this.objCon == null)
            //{
            //    RowUpdated = Util.GetString(MySqlHelper.ExecuteNonQuery(Trans, CommandType.Text, strQuery));
            //}            
			//return RowUpdated;
            return strTDS;//
		}
		catch (Exception ex)
		{
			return "0";
			throw (ex);
		}
	}

	public Boolean CancelReceipt(string LedgerTransactionNo, string CancelReason, string UserID, string TransactionID)
	{

		try
		{
			string RowsUpdated = "";
			string sql = "Update f_ledgertransaction Set IsCancel = 1,IsPaid = 0, Cancel_UserID = '" + UserID + "',CancelDate = '" + DateTime.Now.ToString("yyyy-MM-dd") + "',CancelReason = '" + CancelReason + "' Where LedgerTransactionNo = '" + LedgerTransactionNo + "'";
			RowsUpdated = MySqlHelper.ExecuteNonQuery(objCon, CommandType.Text, sql).ToString();

			sql = "Update f_reciept Set IsCancel = 1, Cancel_UserID = '" + UserID + "',CancelDate = '" + DateTime.Now.ToString("yyyy-MM-dd") + "',CancelReason = '" + CancelReason + "' Where AsainstLedgerTnxNo = '" + LedgerTransactionNo + "'";
			RowsUpdated = MySqlHelper.ExecuteNonQuery(objCon, CommandType.Text, sql).ToString();

			sql = "Update appointment Set Flag = 2 Where TransactionID = '" + TransactionID + "'";
			RowsUpdated = MySqlHelper.ExecuteNonQuery(objCon, CommandType.Text, sql).ToString();

			if (RowsUpdated == "1")
				return true;
			else
				return false;
		}
		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return false;
		}
	}

	public Boolean CancelBill(string LedgerTransactionNo, string CancelReason, string UserID)
	{

		try
		{
			string RowsUpdated = "";
			string sql = "Update f_ledgertransaction Set IsCancel = 1,IsPaid = 0, Cancel_UserID = '" + UserID + "',CancelDate = '" + DateTime.Now.ToString("yyyy-MM-dd") + "',CancelReason = '" + CancelReason + "' Where LedgerTransactionNo = '" + LedgerTransactionNo + "'";
			RowsUpdated = MySqlHelper.ExecuteNonQuery(objCon, CommandType.Text, sql).ToString();

			if (RowsUpdated == "1")
				return true;
			else
				return false;
		}
		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return false;
		}
	}
	public string UpdateLedgerMaster(string PatientUserID, decimal Amount)
	{

		try
		{
			string RowsUpdated = "";
			string sql = "Update f_ledgermaster Set CurrentBalance =CurrentBalance - '" + Amount + "' Where LedgerNumber = '" + PatientUserID + "'";
			RowsUpdated = Util.GetString(MySqlHelper.ExecuteNonQuery(objCon, CommandType.Text, sql));

			if (RowsUpdated != "")
				return "1";
			else
				return "0";
		}
		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return "0";
		}
	}
	public string CancelIPDReceipt(string TransactionID, string UserID, string CancelReason, string ReceiptNo)
	{

		try
		{
			string RowsUpdated = "";
			string sql = "Update f_reciept Set FinanceTransfer=0,IsCancel = 1, Cancel_UserID = '" + UserID + "',CancelDate = '" + DateTime.Now.ToString("yyyy-MM-dd") + "',CancelReason = '" + CancelReason + "' Where ReceiptNo = '" + ReceiptNo + "' and TransactionID='" + TransactionID + "'";
			RowsUpdated = MySqlHelper.ExecuteNonQuery(objCon, CommandType.Text, sql).ToString();

			if (RowsUpdated == "1")
			{
				if (TransactionID.Contains("ISHHI"))
				{
					string Deductions = StockReports.ExecuteScalar("SELECT Deductions FROM f_reciept WHERE ReceiptNo= '" + ReceiptNo + "' and Deductions >0 ");

					if (Deductions != "")
					{
						sql = "UPDATE Patient_Medical_History SET TDS=0,Deduction_Acceptable=0,Deduction_NonAcceptable=0,WriteOff=0 WHERE TransactionID= '" + TransactionID + "'";
						RowsUpdated = Util.GetString(MySqlHelper.ExecuteNonQuery(objCon, CommandType.Text, sql));
					}
				}
				return "1";
			}
			else
			{
				return "0";
			}
		}
		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return "0";
		}
	}
	public DataTable LoadAllStoreItems()
	{
		try
		{
			StringBuilder sb = new StringBuilder();
			sb.Append("SELECT CONCAT(IM.Typename,' # ','(',SM.name,')','#',IFNULL(IM.UnitType,''))ItemName,CONCAT(IM.ItemID,'#',IM.SubCategoryID,'#',IM.Type_ID)ItemID");
			sb.Append(" from f_itemmaster IM inner join f_subcategorymaster SM on IM.SubCategoryID = SM.SubCategoryID");
			sb.Append(" inner join f_configrelation CR on SM.CategoryID = CR.CategoryID WHERE CR.ConfigID = 11 and im.IsActive=1 order by IM.Typename ");
			DataTable dtItems = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, sb.ToString()).Tables[0];
			if (IsLocalConn)
				if (objCon.State == ConnectionState.Open) objCon.Close();
			return dtItems;
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
	public int UpdateLedgerTransactionBillNoByTranID(string TransactionID, string BillNo, string BillDate)
	{
		try
		{
			int RowUpdated = 0;

			string strQuery = "Update f_ledgertransaction Set BillNo='" + BillNo + "',BillDate='" + BillDate + "',BillType='IPD' Where TransactionID ='" + TransactionID + "' AND IFNULL(BillNo,'')=''";

			if (this.objTrans != null && this.objCon == null)
				RowUpdated = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, strQuery);
			else if (this.objCon != null && this.objTrans == null)
				RowUpdated = MySqlHelper.ExecuteNonQuery(objCon, CommandType.Text, strQuery);

			if (IsLocalConn)
				this.objCon.Close();
			return RowUpdated;
		}
		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			if (IsLocalConn)
				if (objCon.State == ConnectionState.Open) objCon.Close();
			throw (ex);
		}
	}
	public int UpdateLedgerTranDetailWithDiscountAmount(string LTDetailID, decimal DiscountPercent, decimal NetAmount, string DiscountReason, string UserID, string ApprovalBy, Decimal DisAmount)
	{
		try
		{
			int RowUpdated = 0;
			string strQuery = "Update f_ledgertnxdetail Set Amount=" + NetAmount + ",NetItemAmt='" + NetAmount + "',DiscountPercentage =" + DiscountPercent + ", DiscountReason = '" + DiscountReason + "',DiscUserID='" + UserID + "',ApprovalBy='" + ApprovalBy + "',DiscAmt='" + DisAmount + "',TotalDiscAmt='" + DisAmount + "' Where LedgerTnxID ='" + LTDetailID + "'";

			if (this.objTrans != null && this.objCon == null)
				RowUpdated = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, strQuery);
			else if (this.objCon != null && this.objTrans == null)
				RowUpdated = MySqlHelper.ExecuteNonQuery(objCon, CommandType.Text, strQuery);
			if (IsLocalConn)
				this.objCon.Close();
			return RowUpdated;
		}
		catch (Exception ex)
		{
			if (IsLocalConn)
				if (objCon.State == ConnectionState.Open) objCon.Close();
			throw (ex);
		}
	}
	public int UpdateDischargeStatusTobeBill(string TransactionID,MySqlConnection con)
	{
		try
		{
			int RowUpdated = Util.GetInt(MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "update patient_ipd_profile set Status='OUT',TobeBill=0  where TransactionID='" + TransactionID + "'"));
			if (RowUpdated > 0)
				return 1;
			else
				return 0;
		}

		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return 0;
		}
	}
	public string UpdateNarration(string Narration, string TransactionID)
	{
		try
		{
			string RowUpdated = "";

			string strQuery = "update f_ipdadjustment set Narration='" + Narration + "' where TransactionID='" + TransactionID + "'";
			if (this.objCon != null && this.objTrans == null)
				RowUpdated = MySqlHelper.ExecuteNonQuery(objCon, CommandType.Text, strQuery).ToString();
			else if (this.objTrans != null && this.objCon == null)
				RowUpdated = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, strQuery).ToString();
			if (IsLocalConn)
				this.objCon.Close();
			if (RowUpdated != "")
				return "1";
			else
				return "0";
		}
		catch (Exception ex)
		{
			if (IsLocalConn)
				this.objCon.Close();
			ClassLog c1 = new ClassLog();
			c1.errLog(ex);
			return "0";
		}
	}
	public int UpdateIPDCaseTypeHistoryOnDischarge(int IPDCaseHistory_ID, DateTime DateOfDischarge, DateTime TimeOfDischarge, String UserID)
	{
		try
		{
			int RowUpdated = 0;
            string strQuery = "Update patient_medical_history Set DischargedBy='" + UserID + "',DateOfDischarge ='" + DateOfDischarge.ToString("yyyy-MM-dd") + "', TimeOfDischarge ='" + Util.GetDateTime(TimeOfDischarge).ToString("HH:mm:ss") + "', Status = 'OUT' Where TransactionID ='" + IPDCaseHistory_ID + "'";//ipd_case_history  //IPDCaseHistory_ID
			if (this.objTrans != null && this.objCon == null)
				RowUpdated = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, strQuery);
			else if (this.objCon != null && this.objTrans == null)
				RowUpdated = MySqlHelper.ExecuteNonQuery(objCon, CommandType.Text, strQuery);
			if (IsLocalConn)
				this.objCon.Close();
			return RowUpdated;
		}
		catch (Exception ex)
		{
			if (IsLocalConn)
				if (objCon.State == ConnectionState.Open) objCon.Close();
			ClassLog c1 = new ClassLog();
			c1.errLog(ex);
			throw (ex);
		}
	}
	public int UpdatePIPOnDischarge(int PatientIPDProfile_ID, DateTime Enddate, DateTime EndTime)
	{
		try
		{
			int RowUpdated = 0;
			string strQuery = "Update patient_ipd_profile Set EndDate ='" + Enddate.ToString("yyyy-MM-dd") + "', EndTime ='" + EndTime.ToString("HH:mm:ss") + "', Status = 'OUT',IsTempAllocated = 0 Where PatientIPDProfile_ID ='" + PatientIPDProfile_ID + "'";
			if (this.objTrans != null && this.objCon == null)
				RowUpdated = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, strQuery);
			else if (this.objCon != null && this.objTrans == null)
				RowUpdated = MySqlHelper.ExecuteNonQuery(objCon, CommandType.Text, strQuery);
			if (IsLocalConn)
				this.objCon.Close();
			return RowUpdated;
		}
		catch (Exception ex)
		{
			if (IsLocalConn)
				if (objCon.State == ConnectionState.Open) objCon.Close();
			ClassLog c1 = new ClassLog();
			c1.errLog(ex);
			throw (ex);
		}
	}
	public int UpdatePatientMedicalHistory(string Transaction_No, string DischargeType)
	{
		try
		{
			int RowUpdated = 0;

			string strQuery = "Update patient_medical_history Set DischargeType ='" + DischargeType + "' Where TransactionID ='" + Transaction_No + "'";
			if (this.objTrans != null && this.objCon == null)
				RowUpdated = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, strQuery);
			else if (this.objCon != null && this.objTrans == null)
				RowUpdated = MySqlHelper.ExecuteNonQuery(objCon, CommandType.Text, strQuery);
			if (IsLocalConn)
				this.objCon.Close();
			return RowUpdated;
		}
		catch (Exception ex)
		{
			if (IsLocalConn)
				if (objCon.State == ConnectionState.Open) objCon.Close();
			ClassLog c1 = new ClassLog();
			c1.errLog(ex);
			throw (ex);
		}
	}
	public int UpdatePatientMedicalHistoryDeath(string Transaction_No, string DischargeType, string TimeOfDeath, int TypeOfDeath, string CauseOfDeath, int Deathover48hrs, string Remarks)
	{
		try
		{
			int RowUpdated = 0;

			string strQuery = "Update patient_medical_history Set DischargeType ='" + DischargeType + "',TimeOfDeath='" + TimeOfDeath + "',TypeOfDeathID=" + TypeOfDeath + ",IsDeathOver48HRS=" + Deathover48hrs + ",CauseOfDeath='" + CauseOfDeath + "',Remarks='" + Remarks + "' Where TransactionID ='" + Transaction_No + "'";
			if (this.objTrans != null && this.objCon == null)
				RowUpdated = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, strQuery);
			else if (this.objCon != null && this.objTrans == null)
				RowUpdated = MySqlHelper.ExecuteNonQuery(objCon, CommandType.Text, strQuery);
			if (IsLocalConn)
				this.objCon.Close();
			return RowUpdated;
		}
		catch (Exception ex)
		{
			if (IsLocalConn)
			{
				if (objCon.State == ConnectionState.Open) objCon.Close();
			}
			ClassLog c1 = new ClassLog();
			c1.errLog(ex);
			throw (ex);
		}
	}

	public bool UpdateDischargeType(string CRNO, string DischargeType)
	{
		try
		{
			int RowUpdated = 0;
			string strQuery = "update patient_medical_history set DischargeType ='" + DischargeType + "' where TransactionID = '" + CRNO + "'";
			if (this.objTrans != null && this.objCon == null)
				RowUpdated = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, strQuery);
			else if (this.objTrans == null && this.objCon != null)
				RowUpdated = MySqlHelper.ExecuteNonQuery(objCon, CommandType.Text, strQuery);
			if (IsLocalConn)
				this.objCon.Close();

			if (RowUpdated == 0)
				return false;
			return true;
		}
		catch (Exception ex)
		{
			if (IsLocalConn)
				if (objCon.State == ConnectionState.Open) objCon.Close();
			ClassLog c1 = new ClassLog();
			c1.errLog(ex);
			return false;
		}
	}

	public bool UpdateDischargeProcessStep(string TransactionID, string user_ID, string step_ID)
	{
		try
		{
			string strQuery = string.Empty;

			DataTable dtProcessStep = StockReports.GetDataTable(" SELECT ID,IsActive,IsMandatory FROM discharge_process_master WHERE ID IN (" + step_ID + ") ORDER BY ID ");

			for (int i = 0; i < dtProcessStep.Rows.Count; i++)
			{
				int stepID = Util.GetInt(dtProcessStep.Rows[i]["ID"]);
				int isActive = Util.GetInt(dtProcessStep.Rows[i]["IsActive"]);
				int IsMandatory = Util.GetInt(dtProcessStep.Rows[i]["IsMandatory"]);
				if (IsMandatory == 0)
				{
					if (stepID == (int)AllGlobalFunction.DischargeProcessStep.MedicalClearance)
					{
						strQuery = " UPDATE patient_medical_history SET IsMedCleared='1',MedClearedBy='" + user_ID + "',MedClearedDate=NOW() WHERE TransactionID='" + TransactionID + "' ";
					}
					else if (stepID == (int)AllGlobalFunction.DischargeProcessStep.NursingClearance)
					{
                        strQuery = " UPDATE patient_medical_history SET IsNurseClean='1',NurseCleanUserID='" + user_ID + "',NurseCleanTimeStamp=NOW() WHERE TransactionID='" + TransactionID + "' ";
					}
					else if (stepID == (int)AllGlobalFunction.DischargeProcessStep.PatientClearance)
					{
                        strQuery = " UPDATE patient_medical_history SET IsClearance='1',ClearanceUserID='" + user_ID + "',ClearanceTimeStamp=NOW(),ClearanceRemark='Auto Clearance' WHERE TransactionID='" + TransactionID + "' ";
					}
					else if (stepID == (int)AllGlobalFunction.DischargeProcessStep.RoomClearance)
					{
                        strQuery = " UPDATE patient_medical_history SET IsRoomClean='1',RoomCleanUserID='" + user_ID + "',RoomCleanTimeStamp=NOW() WHERE TransactionID='" + TransactionID + "' ";
					}
                    else if (stepID == (int)AllGlobalFunction.DischargeProcessStep.BillFreeze)
                    {
                        strQuery = " UPDATE patient_medical_history SET IsBillFreezed=1,BillFreezedTimeStamp='" + Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd HH:mm:ss") + "',BillFreezedUser='" + user_ID + "' WHERE TransactionID='" + TransactionID + "' ";
                        
                    }
					if (strQuery != string.Empty)
					{
						if (this.objTrans != null && this.objCon == null)
						{
							MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, strQuery);
							
							if (stepID == (int)AllGlobalFunction.DischargeProcessStep.RoomClearance)
							{
								strQuery = " SELECT RoomID FROM patient_ipd_profile WHERE PatientIPDProfile_ID=(SELECT MAX(PatientIPDProfile_ID) FROM patient_ipd_profile WHERE TransactionID='" + TransactionID + "' AND STATUS='OUT') ";
								string room_ID = Util.GetString(StockReports.ExecuteScalar(strQuery));
								MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, " UPDATE room_master SET IsRoomClean=1 WHERE RoomID='" + room_ID + "' ");
							}
						}
						else if (this.objTrans == null && this.objCon != null)
						{
							MySqlHelper.ExecuteNonQuery(objCon, CommandType.Text, strQuery);
							
							if (stepID == (int)AllGlobalFunction.DischargeProcessStep.RoomClearance)
							{
								strQuery = " SELECT RoomID FROM patient_ipd_profile WHERE PatientIPDProfile_ID=(SELECT MAX(PatientIPDProfile_ID) FROM patient_ipd_profile WHERE TransactionID='" + TransactionID + "' AND STATUS='OUT') ";
								string room_ID = Util.GetString(StockReports.ExecuteScalar(strQuery));
								MySqlHelper.ExecuteNonQuery(objCon, CommandType.Text, " UPDATE room_master SET IsRoomClean=1 WHERE RoomID='" + room_ID + "' ");
							}
						}
					}
				}
				else
				{
					break;
				}
			}

			if (IsLocalConn)
			{
				this.objCon.Close();
			}

			return true;
		}
		catch (Exception ex)
		{
			if (IsLocalConn)
			{
				if (objCon.State == ConnectionState.Open) objCon.Close();
			}
			ClassLog c1 = new ClassLog();
			c1.errLog(ex);
			return false;
		}
	}
	public void UpdateLoginDetails(string EmployeeID, string RoleID, string CentreID)
	{
		try
		{
			string str = "Update f_login Set LastLoginTime='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "' where EmployeeID='" + EmployeeID + "' and RoleID='" + RoleID + "' AND CentreID='" + CentreID + "'";
			StockReports.ExecuteDML(str);
		}
		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
		}

	}

	public string SavePanelAdjustmentAdvance(string HospitalID, int CentreID, string UserID, string UserName, string PatientReceiptNo, string PanelID, string paymentRemarks, decimal Amount, string PaymentMode, int PaymentModeID, decimal S_Amount, int S_CountryID, string S_Currency, string S_Notation, decimal C_factor, decimal Currency_RoundOff, MySqlTransaction tnx)
	{
		decimal AvailAdvanceAmount = Util.GetDecimal(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT SUM((pla.`LedgerReceivedAmt`-pla.`AdjustmentAmount`))AdvanceAmt FROM panel_ledgeraccount pla WHERE pla.`IsCancel`=0 AND pla.`LedgerReceivedAmt`>pla.`AdjustmentAmount` AND IF(pla.`PaymentModeID`=2,pla.`IsClear`=1,pla.`IsClear` IN(0,1)) AND pla.`PanelID`=" + PanelID + " "));
		if (Amount > AvailAdvanceAmount)
			return "0";

		try
		{
			DataTable dtAvail = StockReports.GetDataTable("SELECT (pla.`LedgerReceivedAmt`-pla.`AdjustmentAmount`)AdvanceAmt,LedgerReceiptNo,ID FROM panel_ledgeraccount pla WHERE pla.`IsCancel`=0 AND pla.`LedgerReceivedAmt`>pla.`AdjustmentAmount` AND IF(pla.`PaymentModeID`<>1,pla.`IsClear`=1,pla.`IsClear` IN(0,1)) AND pla.`PanelID`=" + PanelID + " ");
			PanelLedgerAccount PLA = new PanelLedgerAccount(tnx);
			if (dtAvail.Rows.Count > 0 && dtAvail != null)
			{
				foreach (DataRow payment in dtAvail.Rows)
				{
                    if (Amount > 0)
                    {
                        if ((Util.GetDecimal(payment["AdvanceAmt"]) >= Amount))
                        {
                            PLA.LedgerReceivedAmt = -1 * Amount;
                            PLA.LedgerNoCr = Resources.Resource.PanelLedgerNoCr;
                            PLA.Hospital_ID = HospitalID;
                            PLA.PanelID = PanelID;
                            PLA.TYPE = "DEBIT";
                            PLA.PaymentMode = PaymentMode;
                            PLA.PaymentModeID = PaymentModeID;
                            PLA.Remarks = paymentRemarks;
                            PLA.TnxType = "Panel-Adjustment";
                            PLA.CentreID = CentreID;
                            PLA.EntryBy = UserID;
                            PLA.EntryUserName = UserName;
                            PLA.S_Amount = (-1 * Amount) / C_factor;
                            PLA.S_Currency = S_Currency;
                            PLA.S_CountryID = S_CountryID;
                            PLA.C_factor = C_factor;
                            PLA.S_Notation = S_Notation;
                            PLA.Currency_RoundOff = Currency_RoundOff;
                            PLA.ReferenceDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                            PLA.AdjustLedgerReceiptNo = Util.GetString(payment["LedgerReceiptNo"]);
                            PLA.AdjustPatientReceiptNo = PatientReceiptNo;
                            PLA.AdjustmentAmount = -1 * Amount;
                            string ID = PLA.Insert().ToString();
                            if (ID == "")
                                return "0";

                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " UPDATE panel_ledgeraccount SET AdjustmentAmount=AdjustmentAmount+ " + Amount + " WHERE ID =" + payment["ID"]);

                            Amount = 0;
                        }
                        else
                        {
                            PLA.LedgerReceivedAmt = -1 * Util.GetDecimal(payment["AdvanceAmt"]);
                            PLA.LedgerNoCr = Resources.Resource.PanelLedgerNoCr;
                            PLA.Hospital_ID = HospitalID;
                            PLA.PanelID = PanelID;
                            PLA.TYPE = "DEBIT";
                            PLA.PaymentMode = PaymentMode;
                            PLA.PaymentModeID = PaymentModeID;
                            PLA.Remarks = paymentRemarks;
                            PLA.TnxType = "Panel-Adjustment";
                            PLA.CentreID = CentreID;
                            PLA.EntryBy = UserID;
                            PLA.EntryUserName = UserName;
                            PLA.S_Amount = (-1 * Util.GetDecimal(payment["AdvanceAmt"])) / C_factor;
                            PLA.S_Currency = S_Currency;
                            PLA.S_CountryID = S_CountryID;
                            PLA.C_factor = C_factor;
                            PLA.S_Notation = S_Notation;
                            PLA.Currency_RoundOff = Currency_RoundOff;
                            PLA.ReferenceDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                            PLA.AdjustLedgerReceiptNo = Util.GetString(payment["LedgerReceiptNo"]);
                            PLA.AdjustPatientReceiptNo = PatientReceiptNo;
                            PLA.AdjustmentAmount = -1 * Util.GetDecimal(payment["AdvanceAmt"]);
                            string ID = PLA.Insert().ToString();
                            if (ID == "")
                                return "0";
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " UPDATE panel_ledgeraccount SET AdjustmentAmount=AdjustmentAmount+ " + Util.GetDecimal(payment["AdvanceAmt"]) + " WHERE ID =" + payment["ID"]);
                            Amount = Amount - Util.GetDecimal(payment["AdvanceAmt"]);
                        }
                    }
                    else
                    {
                        return "1";
                    }

				}
				return "1";
			}
			return "0";
		 
		}
		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return "0";

		}
	}

  public bool UpdateMedicalCertificate(string Diagnosis, string Remarks, string FDate, string TDate, string DSignature, string docdept, string Id)
	{
		try
		{
			int RowUpdated = 0;
			string str = "update medicalcertificate set Diagnosis='" + Diagnosis + "',Remarks='" + Remarks + "',FDate='" + FDate + "',TDate='" + TDate + "',DSignature='" + DSignature + "',docdept='" + docdept + "' where ID='" + Id + "' ";
			if (this.objTrans != null && this.objCon == null)
				RowUpdated = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, str);
			else if (this.objTrans == null && this.objCon != null)
				RowUpdated = MySqlHelper.ExecuteNonQuery(objCon, CommandType.Text, str);
			if (IsLocalConn)
				this.objCon.Close();

			if (RowUpdated == 0)
				return false;
			return true;
		}
		catch (Exception ex)
		{
			if (IsLocalConn)
				if (objCon.State == ConnectionState.Open) objCon.Close();
			ClassLog c1 = new ClassLog();
			c1.errLog(ex);
			return false;
		}
	}
  public bool UpdateDeathCertificate(string NAME, string RelationName, string Gender, string Age, string Address, string PronounceDate, string PronounceTime, string DeathDate, string DeathTime, string DeathNature, string DeathCause, string DoctorId, string DoctorName, string CertifiedDoctorId, string CertifiedDoctorName, string BodyHandOveredTo, string CertificateNo)
  {
	  try
	  {
		  int RowUpdated = 0;
		  String str = "UPDATE DeathCertificate dc SET NAME='" + NAME + "',RelationName='" + RelationName + "',Gender='" + Gender + "',Age='" + Age + "',Address='" + Address + "',PronounceDate='" + PronounceDate + "',PronounceTime='" + PronounceTime + "',";
		  str += " DeathDate='" + DeathDate + "',DeathTime='" + DeathTime + "',DeathNature='" + DeathNature + "',DeathCause='" + DeathCause + "',DoctorId='" + DoctorId + "',DoctorName='" + DoctorName + "',CertifiedDoctorId='" + CertifiedDoctorId + "',";
		  str += " CertifiedDoctorName='" + CertifiedDoctorName + "',BodyHandOveredTo='" + BodyHandOveredTo + "',UpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdatedDate='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',IpAddress='" + All_LoadData.IpAddress() + "'";
		  str += " WHERE CertificateNo='" + CertificateNo + "'";
		  if (this.objTrans != null && this.objCon == null)
			  RowUpdated = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, str);
		  else if (this.objTrans == null && this.objCon != null)
			  RowUpdated = MySqlHelper.ExecuteNonQuery(objCon, CommandType.Text, str);
		  if (IsLocalConn)
			  this.objCon.Close();

		  if (RowUpdated == 0)
			  return false;
		  return true;
	  }
	  catch (Exception ex)
	  {
		  if (IsLocalConn)
			  if (objCon.State == ConnectionState.Open) objCon.Close();
		  ClassLog cl = new ClassLog();
		  cl.errLog(ex);
		  return false;
	  }
  }
}
