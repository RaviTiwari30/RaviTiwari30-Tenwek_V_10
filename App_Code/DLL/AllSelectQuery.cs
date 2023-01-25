using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;
using System.Web;

public class AllSelectQuery
{

	#region All Global Variables

	MySqlConnection objCon;
	MySqlTransaction objTrans;
	bool IsLocalConn;

	#endregion

	public AllSelectQuery()
	{

		objCon = Util.GetMySqlCon();
		this.IsLocalConn = true;

	}
	public AllSelectQuery(MySqlTransaction objTrans)
	{
		this.objTrans = objTrans;
		this.IsLocalConn = false;
	}    
	public DataTable GetAvailRooms(string IPDCaseTypeID)
	{
		try
		{
		string sql = "select distinct CONCAT(RM.Name,' /',RM.Room_No,' /','Bed:',RM.Bed_No,' /',' Floor:',RM.Floor) Name,RM.RoomId from room_master RM Where RM.IPDCaseTypeID = '" + IPDCaseTypeID + "' and RM.RoomID not in (select distinct RoomID from patient_ipd_profile where Status='IN') AND RM.ISActive=1 AND RM.isAttendent=0 AND RM.CentreID='"+ HttpContext.Current.Session["CentreID"].ToString() +"' ";
			if (IsLocalConn)
			{
				this.objCon.Open();
				DataSet ds = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, sql);
				this.objCon.Close();
				return ds.Tables[0];
			}
			else
			{
				return null;
			}
		}
		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return null;
		}
	}
	public DataTable GetAdmittedPatient()
	{
		try
		{
			string sql = "select IPDCaseTypeID,Name from ipd_case_type_master";
			if (IsLocalConn)
			{
				this.objCon.Open();
				DataSet ds = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, sql);
				this.objCon.Close();
				return ds.Tables[0];
			}
			else
			{
				return null;
			}
		}
		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return null;
		}
	}
	public DataTable GetAdmittedPatient(string IPDCaseTypeID)
	{
		try
		{
			string sql = "select IPDCaseTypeID,Name from ipd_case_type_master where  IPDCaseTypeID='" + IPDCaseTypeID + "' ";
			if (IsLocalConn)
			{
				this.objCon.Open();
				DataSet ds = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, sql);
				this.objCon.Close();
				return ds.Tables[0];
			}
			else
			{
				return null;
			}
		}
		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return null;
		}
	}
	public decimal GetConversionFactor(int CountryID)
	{
		decimal ConversionFactor = 0;
		if (IsLocalConn)
		{
			this.objCon.Open();
			ConversionFactor = Util.GetDecimal(MySqlHelper.ExecuteScalar(objCon, CommandType.Text, "select GetConversionFactor(" + CountryID + ")"));
			this.objCon.Close();
			
		}
		return ConversionFactor;
	}
	public string GetItemID(string RoomID)
	{
		try
		{
			string ItemID = "";
			string sql = "select ItemID from f_itemmaster where type_Id = '" + RoomID + "'";
			if (IsLocalConn)
			{
				this.objCon.Open();
				ItemID = Util.GetString(MySqlHelper.ExecuteScalar(objCon, CommandType.Text, sql));
				this.objCon.Close();
				return ItemID;
			}
			return ItemID;
		}
		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return "";
		}
	}
	public string GetItemID(string RoomID, string SubCategoryID)
	{
		try
		{
			string ItemID = "";
			string sql = "select CONCAT(ItemID,'#',TypeName)ItemID from f_itemmaster where type_Id = '" + RoomID + "' and SubCategoryID ='" + SubCategoryID + "'";
			if (IsLocalConn)
			{
				this.objCon.Open();
				ItemID = Util.GetString(MySqlHelper.ExecuteScalar(objCon, CommandType.Text, sql));
				this.objCon.Close();
				return ItemID;
			}
			return ItemID;
		}
		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return "";
		}
	}
	public string GetRoomRate2(string ItemID, int PanelID, string CaseTypeID)
	{
		string Rate = "";
		try
		{
			string strQuery = "select Rate from f_ratelist_ipd where PanelID=" + PanelID + " and ItemID='" + ItemID + "' and IPDCaseTypeID='" + CaseTypeID + "' and IsCurrent = 1";

			if (IsLocalConn)
			{
				this.objCon.Open();
				Rate = Util.GetString(MySqlHelper.ExecuteScalar(objCon, CommandType.Text, strQuery));
				this.objCon.Close();
				return Rate;
			}
			return Rate;
		}
		catch (Exception ex)
		{
			if (IsLocalConn)
			{
				if (objCon.State == ConnectionState.Open) objCon.Close();
			}
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return "";
		}
	}
	public string GetRoomDetails(int PanelID, string IPDCaseTypeID, int ScheduleChargeID)
	{
		string sql = "SELECT CONCAT(t1.ItemID,'#',IF(t1.Rate IS NULL,0,t1.Rate),'#',t1.SubCategoryID,'#',t1.BufferTime,'#',IF(t1.rateListID IS NULL,0,t1.rateListID))DATA " +
				  "FROM (" +
				  "      SELECT CONCAT(im.ItemID,'#',im.TypeName)ItemID,rt.Rate,im.SubCategoryID,im.BufferTime,rt.ID rateListID " +
				  "      FROM f_itemmaster im LEFT JOIN (" +
				  "              SELECT ID,Rate,ItemID FROM f_ratelist_ipd WHERE PanelID=" + PanelID + " " +
				  "              AND IPDCaseTypeID = '" + IPDCaseTypeID + "' AND ScheduleChargeID='" + ScheduleChargeID + "' and IsCurrent=1" +
				  "      )  rt ON rt.ItemID = im.ItemID INNER JOIN f_subcategorymaster sc ON " +
				  "      sc.SubCategoryID = im.SubCategoryID INNER JOIN f_configrelation cf " +
				  "      ON cf.CategoryID = sc.CategoryID WHERE im.Type_ID = '" + IPDCaseTypeID + "' AND cf.ConfigID=2 " +
				  ")t1";


		if (IsLocalConn)
		{
			this.objCon.Open();
			sql = Util.GetString(MySqlHelper.ExecuteScalar(objCon, CommandType.Text, sql));
			this.objCon.Close();
			return sql;
		}
		else
		{
			sql = Util.GetString(MySqlHelper.ExecuteScalar(this.objTrans, CommandType.Text, sql));
			return sql;
		}
	}

	public decimal ConvertCurrency(int CountryID, decimal Amount)
	{
		return Util.GetDecimal(StockReports.ExecuteScalar("select ConvertCurrency(" + CountryID + "," + Amount + ")"));
	}
    public DataTable GetBilledPatientDetail(string TrnxID) // Gaurav 17.06.2018
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT LedgerTransactionNo,NetAmount,GrossAmount,DiscountOnTotal,EntryDate,Discount,BillNo,DiscountReason,PatientID,TransactionID,PanelID,TransactionTypeID,DATE ");
            sb.Append(" FROM ( ");
            sb.Append("     select lt.LedgerTransactionNo,lt.NetAmount,lt.GrossAmount,IFNULL(lt.DiscountOnTotal,0)DiscountOnTotal,Date_Format(lt.Date,'%d-%b-%Y')EntryDate, ");
            sb.Append("     IFNULL(((lt.DiscountOnTotal/lt.GrossAmount) * 100),0) as Discount,IFNULL(adj.BillNo,'')BillNo,lt.DiscountReason,lt.PatientID,lt.TransactionID,lt.PanelID, ");
            sb.Append("     lt.TransactionTypeID,Date_Format(lt.Date,'%d-%b-%Y')Date FROM f_ledgertransaction lt ");
            sb.Append("     INNER JOIN patient_medical_history adj on lt.TransactionID = adj.TransactionID ");//f_ipdadjustment
            sb.Append("     WHERE lt.TransactionID ='" + TrnxID + "' ");
            sb.Append("     UNION ALL ");
            sb.Append("     SELECT lt.LedgerTransactionNo,lt.NetAmount,lt.GrossAmount,IFNULL(lt.DiscountOnTotal,0)DiscountOnTotal,DATE_FORMAT(lt.Date,'%d-%b-%Y')EntryDate, ");
            sb.Append("     IFNULL(((lt.DiscountOnTotal/lt.GrossAmount) * 100),0) AS Discount,lt.BillNo,lt.DiscountReason,lt.PatientID,lt.IPNo,lt.PanelID, ");
            sb.Append("     lt.TransactionTypeID,DATE_FORMAT(lt.Date,'%d-%b-%Y')DATE FROM f_ledgertransaction lt ");
            sb.Append("     INNER JOIN f_ledgertnxdetail ltd ON lt.TransactionID = ltd.TransactionID ");
            sb.Append("     WHERE lt.IPNo ='" + TrnxID + "' GROUP BY lt.LedgerTransactionNo ");
            sb.Append(" )t ORDER BY LedgerTransactionNo ");	
    
            if (IsLocalConn)
            {
                this.objCon.Open();
                DataSet ds = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, sb.ToString());
                this.objCon.Close();
                return ds.Tables[0];
            }
            else
            {
                return null;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public DataTable GetBilledPatientDetailNew(string TrnxID, int IsBaseBill, int IsDummyBill) // Gaurav 17.06.2018
	{
		try
		{
            StringBuilder sb = new StringBuilder();
            //sb.Append(" SELECT LedgerTransactionNo,NetAmount,GrossAmount,DiscountOnTotal,EntryDate,Discount,BillNo,DiscountReason,PatientID,TransactionID,PanelID,TransactionTypeID,DATE ");
            //sb.Append(" FROM ( ");
            //sb.Append("     select lt.LedgerTransactionNo,lt.NetAmount,lt.GrossAmount,IFNULL(lt.DiscountOnTotal,0)DiscountOnTotal,Date_Format(lt.Date,'%d-%b-%Y')EntryDate, ");
            //sb.Append("     IFNULL(((lt.DiscountOnTotal/lt.GrossAmount) * 100),0) as Discount,IFNULL(adj.BillNo,'')BillNo,lt.DiscountReason,lt.PatientID,lt.TransactionID,lt.PanelID, ");
            //sb.Append("     lt.TransactionTypeID,Date_Format(lt.Date,'%d-%b-%Y')Date FROM f_ledgertransaction lt ");
            //sb.Append("     INNER JOIN f_ipdadjustment adj on lt.TransactionID = adj.TransactionID ");
            //sb.Append("     WHERE lt.TransactionID ='" + TrnxID + "' ");
            //sb.Append("     UNION ALL ");
            //sb.Append("     SELECT lt.LedgerTransactionNo,lt.NetAmount,lt.GrossAmount,IFNULL(lt.DiscountOnTotal,0)DiscountOnTotal,DATE_FORMAT(lt.Date,'%d-%b-%Y')EntryDate, ");
            //sb.Append("     IFNULL(((lt.DiscountOnTotal/lt.GrossAmount) * 100),0) AS Discount,lt.BillNo,lt.DiscountReason,lt.PatientID,lt.IPNo,lt.PanelID, ");
            //sb.Append("     lt.TransactionTypeID,DATE_FORMAT(lt.Date,'%d-%b-%Y')DATE FROM f_ledgertransaction lt ");
            //sb.Append("     INNER JOIN f_ledgertnxdetail ltd ON lt.TransactionID = ltd.TransactionID ");
            //sb.Append("     WHERE lt.IPNo ='" + TrnxID + "' GROUP BY lt.LedgerTransactionNo ");	 
            //sb.Append(" )t ORDER BY LedgerTransactionNo ");	
            sb.Append(" call GetBilledPatientDetail('" + TrnxID + "'," + IsDummyBill + "," + IsBaseBill + " )");

			if (IsLocalConn)
			{
				this.objCon.Open();
				DataSet ds = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, sb.ToString());
				this.objCon.Close();
				return ds.Tables[0];
			}
			else
			{
				return null;
			}
		}
		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return null;
		}
	}
    public DataTable GetBilledPatientItemDetail(string TrnxID)// Gaurav 17.06.2018
	{
		try
		{


            string sql = "SELECT "

               + "  (CASE WHEN im.type_ID='S' THEN CONCAT(ItemName,'(', IFNULL((SELECT dm.`Name` FROM f_surgery_discription sdr "
    + " INNER JOIN `f_itemmaster` itm ON sdr.ItemID=itm.ItemID AND itm.Type_ID IN ('S')  "
  + "INNER JOIN f_surgery_DOctor sd ON sd.SurgeryTransactionID=sdr.SurgeryTransactionID   "
 + "INNER JOIN `doctor_master` dm ON dm.`DoctorID`=sd.`DoctorID`  "
   + "WHERE sdr.LedgerTransactionNo=t1.LedgerTransactionNo AND sdr.`ItemID`=t1.itemid),''), ')')  "


 + "WHEN im.type_ID='D' THEN CONCAT(ItemName,'(', IFNULL((SELECT dm.`Name` FROM f_surgery_discription sdr  "
    + " INNER JOIN `f_itemmaster` itm ON sdr.ItemID=itm.ItemID AND itm.Type_ID IN ('D') "
  + "INNER JOIN f_surgery_DOctor sd ON sd.SurgeryTransactionID=sdr.SurgeryTransactionID   "
 + "INNER JOIN `doctor_master` dm ON dm.`DoctorID`=sd.`DoctorID`  "
   + "WHERE sdr.LedgerTransactionNo=t1.LedgerTransactionNo AND sdr.`ItemID`=t1.itemid),''), ')')  "
 + "ELSE CONCAT(itemname,IF(IFNULL(t1.itemcode,'')<>'',CONCAT('(',t1.itemcode,')'),'')) "
  + "END )itemname, "

            + " LedgerTransactionNo,Amount,T1.ItemID,Rate,Quantity,StockID,DiscountPercentage,IsPackage,PackageID,IsVerified,t1.SubCategoryID,VarifiedUserID, "

                        + " /* ItemName,*/ TransactionID,VerifiedDate,UserID,EntryDate,DiscountAmount,LTDetailID,SubCategory, "
                        + "if(t1.IsDischargeMedicine=1,'DISCHARGE MEDICINE & CONSUMABLES',IF(t1.DeptLedgerNo IN(" + Resources.Resource.OTDeptLedgerNo + "),(SELECT IFNULL(sc.DisplayName,sc.Name) FROM f_subcategorymaster sc INNER JOIN f_configrelation c ON c.CategoryID=SC.CategoryID WHERE sc.Active=1 AND c.ConfigID=22 LIMIT 1),DisplayName))DisplayName,if(t1.IsDischargeMedicine=1,2000,if(t1.DeptLedgerNo IN(" + Resources.Resource.OTDeptLedgerNo + "),(SELECT sc.DisplayPriority FROM f_subcategorymaster sc INNER JOIN f_configrelation c ON c.CategoryID=SC.CategoryID WHERE sc.Active=1 AND c.ConfigID=22 LIMIT 1),DisplayPriority))DisplayPriority,t1.IsSurgery,t1.Surgery_ID,t1.SurgeryName,t1.DiscountReason,t1.UserName,IF(t1.Type_ID='',im.Type_ID,t1.Type_ID)Type_ID,im.ServiceItemID,(Rate*Quantity)GrossAmt, "
                        + "IFNULL(dm.Specialization,'')Specialization,t1.IsPayable,t1.ConfigID,t1.Itemcode,t1.DeptLedgerNo "
                        + "FROM ( "
                        + "     SELECT LTD.IsDischargeMedicine,ltd.DeptLedgerNo,LTD.LedgerTransactionNo,LTD.Amount,LTD.ItemID,LTD.Rate,LTD.Quantity,LTD.StockID,LTD.DiscountPercentage,LTD.IsPackage,LTD.PackageID, "
                        + "     LTD.IsVerified,LTD.SubCategoryID,LTD.VarifiedUserID,LTD.ItemName,LTD.TransactionID,DATE_FORMAT(LTD.VerifiedDate,'%d-%b-%Y')VerifiedDate, "
                        + "     LTD.LedgerTnxID AS LTDetailID,LTD.UserID,DATE_FORMAT(LTD.EntryDate,'%d-%b-%Y')EntryDate,"
                        + "     (((Rate * Quantity)*DiscountPercentage)/100) DiscountAmount,IFNULL(ltd.Type_ID,'')Type_ID, "
                        + "     SC.Name AS SubCategory,SC.DisplayName,SC.DisplayPriority,LTD.IsSurgery,"
                        + "     LTD.Surgery_ID,LTD.SurgeryName,LTD.DiscountReason,EM.Name AS UserName,LTD.IsPayable,LTD.`ConfigID`,   "
                        + "     ltd.`rateItemCode` itemcode FROM f_ledgertnxdetail LTD INNER JOIN f_ledgertransaction LT ON "
                        + "     LT.LedgerTransactionNo = LTD.LedgerTransactionNo INNER JOIN "
                        + "     f_subcategorymaster SC ON SC.SubcategoryID = LTD.SubcategoryID "
                        + "     INNER JOIN employee_master EM ON EM.EmployeeID = LTD.UserID "
                        + "     WHERE LT.TransactionID = '" + TrnxID + "' AND LTD.Isverified =1    "
                /*
                + "     UNION ALL "
                + "     SELECT LTD.LedgerTransactionNo,LTD.Amount,LTD.ItemID,LTD.Rate,LTD.Quantity,LTD.StockID,LTD.DiscountPercentage,LTD.IsPackage,LTD.PackageID,LTD.IsVerified, "
                + "     LTD.SubCategoryID,LTD.VarifiedUserID,CONCAT(LTD.ItemName,'(',lt.BillNo,')')ItemName,LTD.TransactionID,DATE_FORMAT(LTD.VerifiedDate,'%d-%b-%Y')VerifiedDate,LTD.LedgerTnxID AS LTDetailID, "
                + "     LTD.UserID,DATE_FORMAT(LTD.EntryDate,'%d-%b-%Y')EntryDate,(((Rate * Quantity)*DiscountPercentage)/100) DiscountAmount,IFNULL(ltd.Type_ID,'')Type_ID, "
                + "     SC.Name AS SubCategory,'OPD' DisplayName,1 DisplayPriority,LTD.IsSurgery,LTD.Surgery_ID,LTD.SurgeryName,LTD.DiscountReason,EM.Name AS UserName,LTD.IsPayable, "
                + "     LTD.`ConfigID`,ltd.`rateItemCode` itemcode  FROM f_ledgertransaction lt "
                + "     INNER JOIN f_ledgertnxdetail ltd ON LT.LedgerTransactionNo = LTD.LedgerTransactionNo "
                + "     INNER JOIN f_subcategorymaster SC ON SC.SubcategoryID = LTD.SubcategoryID INNER JOIN employee_master EM ON EM.Employee_ID = LTD.UserID "
                + "     WHERE lt.IsCancel=0 AND lt.`IsIPDMerged`=1   AND IPNo='" + TrnxID + "' " */

                        + " )t1 LEFT JOIN f_itemmaster im ON im.itemid = t1.ItemID "
                        + " LEFT JOIN doctor_master dm ON dm.DoctorID=im.Type_ID "
                        + " ORDER BY t1.DisplayName, t1.SubCategoryID,t1.ItemID, "
                        + " DATE(t1.EntryDate) ";

			if (IsLocalConn)
			{
				this.objCon.Open();
				DataSet ds = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, sql);
				this.objCon.Close();
				return ds.Tables[0];
			}
			else
			{
				return null;
			}
		}
		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return null;
		}
	}


    public DataTable GetBilledPatientItemDetailNew(string TrnxID, int IsBaseBill, int IsDummyBill)// Gaurav 17.06.2018
    {
        try
        {
            string sql = " CALL GetBillPatientItemdetail('" + TrnxID + "','" + Resources.Resource.OTDeptLedgerNo + "'," +IsDummyBill+ "," + IsBaseBill + ")";

            if (IsLocalConn)
            {
                this.objCon.Open();
                DataSet ds = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, sql);
                this.objCon.Close();
                return ds.Tables[0];
            }
            else
            {
                return null;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }

	public DataTable GetPatientPackageDetail(string TrnxID)
	{
		try
		{
			string sql = "Select ItemName,ItemID,sum(amount)SurTotal,LedgerTransactionNo from f_ledgertnxdetail Where TransactionID='" + TrnxID + "' and SubCategoryID in (Select Subcategoryid from f_subcategorymaster Where Categoryid in (Select Categoryid from f_configrelation Where ConfigID=14)) and IsVerified=1  group by itemid";
         
            if (IsLocalConn)
			{
				this.objCon.Open();
				DataSet ds = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, sql);
				this.objCon.Close();
				return ds.Tables[0];
			}
			else
			{
				return null;
			}
		}
		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return null;
		}
	}

    public DataTable GetPatientPackageDetailNew(string TrnxID, int IsBaseBill, int IsDummyBill)
    {
        try
        {
            //string sql = "Select ItemName,ItemID,sum(amount)SurTotal,LedgerTransactionNo from f_ledgertnxdetail Where TransactionID='" + TrnxID + "' and SubCategoryID in (Select Subcategoryid from f_subcategorymaster Where Categoryid in (Select Categoryid from f_configrelation Where ConfigID=14)) and IsVerified=1  group by itemid";
            string sql = "call GetPatientPackageDetail('" + TrnxID + "'," + IsDummyBill + "," + IsBaseBill + ")";

            if (IsLocalConn)
            {
                this.objCon.Open();
                DataSet ds = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, sql);
                this.objCon.Close();
                return ds.Tables[0];
            }
            else
            {
                return null;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }

	public DataTable GetBilledPatientItemDetailDiscount(string TrnxID)
	{
		try
		{

			string sql = "SELECT LedgerTransactionNo,Amount,T1.ItemID,Rate,Quantity,StockID,DiscountPercentage,IsPackage,PackageID,IsVerified,t1.SubCategoryID,VarifiedUserID, "
						+ "ItemName,TransactionID,VerifiedDate,UserID,EntryDate,DiscountAmount,LTDetailID,SubCategory, "
						+ "DisplayName,t1.IsDiscountable,DisplayPriority,t1.IsSurgery,t1.SurgeryID,t1.SurgeryName,t1.DiscountReason,t1.UserName,im.Type_ID,im.ServiceItemID,(Rate*Quantity)GrossAmt, "
						+ "IFNULL(dm.Specialization,'')Specialization FROM ( "
						+ "     SELECT LTD.LedgerTransactionNo,LTD.Amount,LTD.ItemID,LTD.Rate,LTD.Quantity,LTD.StockID,"
						+ "     LTD.DiscountPercentage,LTD.IsPackage,LTD.PackageID,LTD.IsVerified,LTD.SubCategoryID, "
						+ "     LTD.VarifiedUserID,LTD.ItemName,LTD.TransactionID,"
						+ "     DATE_FORMAT(LTD.VerifiedDate,'%d-%b-%Y')VerifiedDate,LTD.LedgerTnxID AS LTDetailID,"
						+ "     LTD.UserID,DATE_FORMAT(LTD.EntryDate,'%d-%b-%Y')EntryDate,"
						+ "    (((Rate * Quantity)*DiscountPercentage)/100) DiscountAmount, "
						+ "     SC.Name AS SubCategory,SC.DisplayName,SC.DisplayPriority,SC.IsDiscountable,LTD.IsSurgery,"
						+ "     LTD.SurgeryID,LTD.SurgeryName,LTD.DiscountReason,EM.Name AS UserName      "
						+ "     FROM f_ledgertnxdetail LTD INNER JOIN f_ledgertransaction LT ON "
						+ "     LT.LedgerTransactionNo = LTD.LedgerTransactionNo INNER JOIN "
						+ "     f_subcategorymaster SC ON SC.SubcategoryID = LTD.SubcategoryID "
						+ "     LEFT JOIN employee_master EM ON EM.EmployeeID = LTD.DiscUserID  "
						+ "     WHERE LT.TransactionID = '" + TrnxID + "' AND LTD.Isverified =1  "
						+ " )t1 LEFT JOIN f_itemmaster im ON im.itemid = t1.ItemID "
						+ " LEFT JOIN doctor_master dm ON dm.DoctorID=im.Type_ID "
						+ " ORDER BY t1.DisplayName, t1.SubCategoryID,t1.ItemID, "
						+ " DATE(t1.EntryDate) ";

			if (IsLocalConn)
			{
				this.objCon.Open();
				DataSet ds = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, sql);
				this.objCon.Close();
				return ds.Tables[0];
			}
			else
			{
				return null;
			}
		}
		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return null;
		}
	}
	// Get Contry Currency converted on the basis of Balance.
	public decimal ConvertCurrencyBase(int CountryID, decimal Amount)
	{
		return Util.GetDecimal(StockReports.ExecuteScalar("select ConvertCurrency_base(" + CountryID + "," + Amount + ")"));
	}
	public DataSet GetIPDCHIDandPIPPPID1(string TrnxID)
	{
		try
		{
            string sql = "select ICH.TransactionID AS IPDCaseHistory_ID,PatientIPDProfile_ID,roomid from patient_medical_history ICH, patient_ipd_profile PIP where ICH.status='IN' and PIP.status='IN' and ICH.TransactionID='" + TrnxID + "' and PIP.TransactionID='" + TrnxID + "'";//ipd_case_history
			if (IsLocalConn)
			{
				this.objCon.Open();
				DataSet ds = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, sql);
				this.objCon.Close();
				return ds;
			}
			else
			{
				return null;
			}
		}
		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return null;
		}
	}
	public DataSet GetIPDCHIDandPIPPPID(string TrnxID)
	{
		try
		{
			string sql = "select IPDCaseHistory_ID,PatientIPDProfile_ID,roomid from ipd_case_history ICH, patient_ipd_profile PIP where ICH.status='IN' and PIP.status='IN' and ICH.TransactionID='" + TrnxID + "' and PIP.TransactionID='" + TrnxID + "'";
			if (IsLocalConn)
			{
				this.objCon.Open();
				DataSet ds = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, sql);
				this.objCon.Close();
				return ds;
			}
			else
			{
				return null;
			}
		}
		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return null;
		}
	}
	public DataSet GetIPDCHIDandPIPPPID(string TrnxID, string Status)
	{
		try
		{
			string sql = "Select ICH.IPDCaseHistory_ID,PIP.PatientIPDProfile_ID  from (Select IPDCaseHistory_ID,TransactionID from ipd_case_history where TransactionID='" + TrnxID + "' and status='" + Status + "')ICH inner join (select max(PatientIPDProfile_ID)PatientIPDProfile_ID,TransactionID from patient_ipd_profile where TransactionID='" + TrnxID + "' and status='" + Status + "' group by TransactionID)PIP on PIP.TransactionID = ICH.TransactionID";
			if (IsLocalConn)
			{
				this.objCon.Open();
				DataSet ds = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, sql);
				this.objCon.Close();
				return ds;
			}
			else
			{
				return null;
			}
		}
		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return null;
		}
	}
	public DataTable LoadCssdBatch()
	{
		try
		{
			StringBuilder sb = new StringBuilder();

			sb.Append("SELECT BatchNo,BatchName FROM cssd_f_batch_tnxdetails where IsProcess=1 GROUP BY BatchNo ");


			if (IsLocalConn)
			{
				this.objCon.Open();
				DataSet ds = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, sb.ToString());
				this.objCon.Close();
				return ds.Tables[0];
			}
			else
			{
				return null;
			}
		}
		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return null;
		}

	}

	public DataTable LoadCssdBatchDetail(string BatchNo)
	{
		try
		{
			StringBuilder sb = new StringBuilder();
			sb.Append("      SELECT BatchNo,BatchName,BoilerName,DATE_FORMAT(startDate,'%d-%b-%y %h:%i %p')ApproxStartDate, ");
			sb.Append("  DATE_FORMAT(EndDate,'%d-%b-%y %h:%i %p')ApproxEndDate,SetID,setstockid,SetName,ItemID,ItemName,Quantity Qty,stockid FROM  ");
			sb.Append("  cssd_f_batch_tnxdetails where BatchNo='" + BatchNo + "' and IsProcess=1   ");

			if (IsLocalConn)
			{
				this.objCon.Open();
				DataSet ds = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, sb.ToString());
				this.objCon.Close();
				return ds.Tables[0];
			}
			else
			{
				return null;
			}
		}
		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return null;
		}

	}





	public DataTable LoadCssdBatchReturn()
	{
		try
		{
			StringBuilder sb = new StringBuilder();

			sb.Append("SELECT BatchNo,BatchName FROM cssd_f_batch_tnxdetails where IsProcess=2 GROUP BY BatchNo ");


			if (IsLocalConn)
			{
				this.objCon.Open();
				DataSet ds = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, sb.ToString());
				this.objCon.Close();
				return ds.Tables[0];
			}
			else
			{
				return null;
			}
		}
		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return null;
		}

	}


	public DataTable LoadCssdBatchDetailReturn(string BatchNo)
	{
		try
		{
			StringBuilder sb = new StringBuilder();
			sb.Append("  SELECT BatchNo,BatchName,BoilerName,DATE_FORMAT(AstartDate,'%d-%b-%y %h:%i %p')ActualStartDate, ");
			sb.Append("  DATE_FORMAT(AEndDate,'%d-%b-%y %h:%i %p')ActualEndDate,SetID,SetName,ItemID,ItemName,Quantity Qty,ifnull(IsSet,0)IsSet,ifnull(SetStockID,0)SetStockID,ID BatchTnxID,StockID FROM  ");
			sb.Append("  cssd_f_batch_tnxdetails where BatchNo='" + BatchNo + "' and IsProcess=2   ");

			if (IsLocalConn)
			{
				this.objCon.Open();
				DataSet ds = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, sb.ToString());
				this.objCon.Close();
				return ds.Tables[0];
			}
			else
			{
				return null;
			}
		}
		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return null;
		}

	}
	public DataTable LoadItems(string itemname)
	{
		try
		{
			StringBuilder sb = new StringBuilder();
			sb.Append(" SELECT IM.Typename ItemName,IM.ItemID ");
			sb.Append(" FROM f_itemmaster IM INNER JOIN f_subcategorymaster SM ON IM.SubCategoryID = SM.SubCategoryID ");
			sb.Append(" INNER JOIN f_configrelation CR ON SM.CategoryID = CR.CategoryID  ");
			sb.Append(" WHERE CR.ConfigID IN (11) AND im.IsActive=1  ");
			if (itemname != string.Empty)
				sb.Append(" AND im.TypeName LIKE '%" + itemname + "%'  ");

			sb.Append(" ORDER BY im.TypeName ");
			if (IsLocalConn)
			{
				this.objCon.Open();
				DataSet ds = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, sb.ToString());
				this.objCon.Close();
				return ds.Tables[0];
			}
			else
			{
				return null;
			}
		}
		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return null;
		}
	}
	public DataTable LoadSets()
	{
		try
		{
			string str = "SELECT sm.Set_ID SetID,sm.NAME FROM cssd_f_set_master sm LEFT JOIN cssd_set_itemdetail sd ON sm.Set_ID=sd.SetID AND sd.IsActive=1  WHERE sd.SetID IS NULL AND sm.IsActive=1 GROUP BY sm.Set_ID ";
			if (IsLocalConn)
			{
				this.objCon.Open();
				DataSet ds = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, str);
				this.objCon.Close();
				return ds.Tables[0];
			}
			else
			{
				return null;
			}
		}
		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return null;
		}
	}
	public DataTable LoadSetHavingItem()
	{
		try
		{
			string str = "SELECT sm.Set_ID SetID,sm.NAME FROM cssd_f_set_master sm inner JOIN cssd_set_itemdetail sd ON sm.Set_ID=sd.SetID LEFT JOIN cssd_f_batch_tnxdetails cbt ON cbt.setid=sd.setid   WHERE  sm.IsActive=1 AND sd.IsActive=1 AND IFNULL(isprocess,0)<>1 and sm.Isset=0 GROUP BY sm.Set_ID order by sm.NAME";

			if (IsLocalConn)
			{
				this.objCon.Open();
				DataSet ds = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, str);
				this.objCon.Close();
				return ds.Tables[0];
			}
			else
			{
				return null;
			}
		}
		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return null;
		}
	}

	public DataTable loadSetItems(string SetID)
	{
		try
		{
			string str = "SELECT Set_ID SetID,NAME FROM cssd_f_set_master WHERE IsActive=1 ";

			if (IsLocalConn)
			{
				this.objCon.Open();
				DataSet ds = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, str);
				this.objCon.Close();
				return ds.Tables[0];
			}
			else
			{
				return null;
			}
		}
		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return null;
		}
	}
	public DataTable LoadSetItemStock(string LedgerNumber)
	{
		try
		{
			StringBuilder sb = new StringBuilder();
			
			sb.Append("  SELECT ItemName,ItemID FROM ( ");
			sb.Append("  SELECT  ItemName,CONCAT(ItemID,'#',0)ItemID,SUM(qty)qty FROM ( ");
			sb.Append("  SELECT ItemName,ItemID,(StQty-SUM(setStockQty)-(SELECT  IFNULL(SUM(IFNULL(ctnx.Quantity - ctnx.ReleaseQuantity,0)),0) FROM cssd_f_batch_tnxdetails ctnx WHERE ctnx.IsProcess IN (1, 2) AND  stockid=t.stockid ))qty ");
			sb.Append("  ,IsSet,SetTnxID,StockID FROM ( ");
			sb.Append("   SELECT  st.ItemName,st.ItemID,(st.InitialCount-st.ReleasedCount)StQty,IFNULL(cst.ReceivedQty,0) setStockQty ");
			sb.Append("  ,0 IsSet,'' SetTnxID,st.StockID FROM f_stock st   ");
			sb.Append("  LEFT OUTER JOIN cssd_stock_setstock css ON css.StockID=st.StockID ");
			sb.Append("  LEFT OUTER JOIN  cssd_recieve_Set_stock cst  ON css.SetStockID=cst.SetStockID AND css.StockID=cst.StockID ");
			sb.Append("  AND cst.IsReturned=0 AND BatchProcess=0    ");
			sb.Append("  WHERE st.DeptLedgerNo='" + LedgerNumber + "' ");
			sb.Append("  AND DATE(st.MedExpiryDate)>CURDATE() AND st.IsPost=1 )t GROUP BY  StockID)t1  GROUP BY   ItemID )t2 WHERE t2.qty>0  ");
			sb.Append("  UNION ALL  ");
			sb.Append("  SELECT ItemName,ItemID FROM (  ");
			sb.Append("  SELECT ItemName,CONCAT(ItemID,'#',1)ItemID,COUNT(*)Qty FROM (  ");
			sb.Append("  SELECT cst.SetName ItemName,cst.SetID ItemID,(SUM(cst.ReceivedQty)-SUM(IFNULL(ctnx.Quantity,0))) Qty,   ");
			sb.Append("  1 IsSet,cst.SetStockID SetTnxID,'' StockID FROM    cssd_recieve_Set_stock cst LEFT JOIN cssd_f_batch_tnxdetails    ");
			sb.Append("  ctnx ON cst.ID=ctnx.SetTnxID AND ctnx.IsProcess IN (1,2,4) AND ctnx.isset=1 WHERE cst.isactive=1  AND    ");
			sb.Append("   cst.IsReturned=0 GROUP BY  cst.SetStockID)t WHERE Qty>0 GROUP BY ItemID)t1 WHERE Qty>0  ");

			if (IsLocalConn)
			{
				this.objCon.Open();
				DataSet ds = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, sb.ToString());
				this.objCon.Close();
				return ds.Tables[0];
			}
			else
			{
				return null;
			}
		}
		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return null;
		}

	}
	public DataTable LoadSetItemsWithOutStockSet(string SetID, string SetStockID)
	{
		try
		{
			StringBuilder sb = new StringBuilder();
			sb.Append(" SELECT SetName,SetID,ItemID,ItemName,SUM(RECEIVEDQTY)SetQuantity FROM cssd_recieve_set_stock WHERE isactive=1 AND  setid='" + SetID + "' and SetStockID='" + SetStockID + "' GROUP BY SetID,ItemID ");
			if (IsLocalConn)
			{
				this.objCon.Open();
				DataSet ds = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, sb.ToString());
				this.objCon.Close();
				return ds.Tables[0];
			}
			else
			{
				return null;
			}
		}
		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return null;
		}
	}
	public DataTable LoadSetItemStock(string LedgerNumber, string ItemID, string IsSet)
	{
		try
		{
			StringBuilder sb = new StringBuilder();
			if (IsSet == "0")
			{           
				sb.Append("    SELECT  * FROM ( ");
				sb.Append("    SELECT ItemName,ItemID,(StQty-SUM(setStockQty)-(SELECT  IFNULL(SUM(IFNULL(ctnx.Quantity - ctnx.ReleaseQuantity,0)),0) FROM cssd_f_batch_tnxdetails ctnx WHERE ctnx.IsProcess IN (1, 2) AND  stockid=t.stockid ))Qty ");
				sb.Append("    ,IsSet,SetTnxID,StockID,FromDept FROM ( ");
				sb.Append("    SELECT  st.ItemName,st.ItemID,(st.InitialCount-st.ReleasedCount)StQty,IFNULL(cst.ReceivedQty,0) setStockQty ");
				sb.Append("    ,0 IsSet,'' SetTnxID,st.StockID,(SELECT LedgerName FROM f_ledgermaster WHERE LedgerNumber=st.FromDept AND groupid='DPT')FromDept ");
				sb.Append("    FROM f_stock st LEFT OUTER JOIN cssd_stock_setstock css ON css.StockID=st.StockID ");
				sb.Append("    left outer JOIN  cssd_recieve_Set_stock cst  ON css.SetStockID=cst.SetStockID AND css.StockID=cst.StockID AND cst.IsReturned=0 AND BatchProcess=0  ");
				sb.Append("    WHERE st.DeptLedgerNo='" + LedgerNumber + "'  ");
				sb.Append("    AND DATE(st.MedExpiryDate)>CURDATE() AND st.IsPost=1  AND st.itemid='" + ItemID + "')t GROUP BY  StockID)t1 WHERE t1.qty>0  ");

			}
			else
			{
			   

				sb.Append(" SELECT * FROM ( ");
				sb.Append("  SELECT cst.SetName ItemName,cst.SetID ItemID,cst.SetStockID,(SUM(cst.ReceivedQty)-SUM(IFNULL(ctnx.Quantity,0))) Qty,  ");
				sb.Append(" 1 IsSet,cst.SetStockID SetTnxID, s.StockID,CAST(GROUP_CONCAT((SELECT LedgerName FROM f_ledgermaster WHERE LedgerNumber=s.FromDept  ");
				sb.Append(" AND groupid='DPT') SEPARATOR '$') AS CHAR)FromDept   ");
				sb.Append(" FROM  cssd_stock_setstock css left outer join  cssd_recieve_Set_stock cst ON css.SetStockID=cst.SetStockID AND css.StockID=cst.StockID  INNER JOIN f_stock s ON css.StockID=s.StockID ");
				sb.Append(" LEFT JOIN cssd_f_batch_tnxdetails ctnx ON cst.ID=ctnx.SetTnxID AND ctnx.IsProcess in (1,2,4) AND ctnx.isset=1 WHERE cst.isactive=1     ");
				sb.Append("  AND cst.SetID='" + ItemID + "' AND   ");
				sb.Append("  cst.IsReturned=0 GROUP BY  cst.SetStockID)t WHERE Qty>0 ");
			}
			if (IsLocalConn)
			{
				this.objCon.Open();
				DataSet ds = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, sb.ToString());
				this.objCon.Close();
				return ds.Tables[0];
			}
			else
			{
				return null;
			}
		}
		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return null;
		}

	}
	public DataTable LoadSetItemsWithStock(string SetID, string LedgerNumber, string SetStockID)
	{
		try
		{
			StringBuilder sb = new StringBuilder();


			sb.Append("  SELECT SetID,SetName,ItemID,ItemName,SetQuantity,   ");
			sb.Append(" StockID,StockQty,StockQtyNew,SetstockId,ReceivedQty FROM  ");
			sb.Append(" (SELECT  IFNULL(oths.Qty,0)Qty,IFNULL(SUM(cst.ReceivedQty),'0') ReceivedQty,IFNULL(cst.ReturnedQty,'0')ReturnedQty, ");
			sb.Append(" SUM(st.InitialCount)InitialCount,SUM(st.ReleasedCount)ReleasedCount,stdt.SetID,stdt.SetName, ");
			sb.Append(" stdt.IsActive,stdt.ItemID,stdt.ItemName,stdt.Quantity  SetQuantity, ");
			sb.Append(" CAST(GROUP_CONCAT(st.StockID ORDER BY st.StockID SEPARATOR '$') AS CHAR)StockID,  ");
			sb.Append("  CAST(GROUP_CONCAT((st.InitialCount - st.ReleasedCount - IFNULL(cst.ReceivedQty, 0)-IFNULL(oths.Qty,0)-IFNULL(ctnx.Quantity, 0))");
			sb.Append("  ORDER BY st.StockID SEPARATOR '$') AS CHAR)      ");
			sb.Append("  StockQty,SUM(st.InitialCount-st.ReleasedCount-IFNULL(cst.ReceivedQty,0)-IFNULL(oths.Qty,0))-IFNULL(SUM(ctnx.Quantity),0) StockQtyNew, ");
			sb.Append("  cst.setstockid  FROM  cssd_set_itemdetail stdt   LEFT JOIN f_stock st ON stdt.ItemID=st.ItemID ");
			sb.Append("   LEFT JOIN cssd_stock_setstock css ON css.StockID=st.StockID AND css.SetStockID='" + SetStockID + "'    LEFT JOIN");
			sb.Append("	(SELECT setid,itemid,stockid,SetQuantity,SUM(ReceivedQty)ReceivedQty,    ");
			sb.Append("	SUM(ReturnedQty)ReturnedQty,setstockid FROM cssd_recieve_Set_stock ");
			sb.Append("	WHERE IsReturned=0  AND SetID='" + SetID + "' AND Setstockid='" + SetStockID + "' AND BatchProcess=0  GROUP BY stockid)cst ");
			sb.Append(" ON css.StockID=cst.StockID ");
			sb.Append("   AND css.SetStockID=cst.SetStockID ");
			sb.Append(" LEFT JOIN  (SELECT IFNULL(SUM(rec.ReceivedQty),0)Qty,css1.StockID");
			sb.Append(" FROM cssd_stock_setstock css1  INNER JOIN cssd_recieve_Set_stock rec ON css1.StockID=rec.StockID AND css1.SetStockID=rec.SetStockID  WHERE IsReturned = 0   AND BatchProcess = 0 ");
			sb.Append(" AND rec.SetStockID<>'"+SetStockID+"' GROUP BY stockid)oths ON oths.StockID=st.StockID");
			sb.Append(" LEFT OUTER JOIN (SELECT StockID,SUM(Quantity-ReleaseQuantity)Quantity FROM cssd_f_batch_tnxdetails WHERE IsProcess IN (1,2) GROUP BY stockID)ctnx ON st.StockID=ctnx.StockID ");
			sb.Append(" WHERE stdt.SetID='" + SetID + "' AND stdt.IsActive='1'  AND   ");
			sb.Append("        st.DeptLedgerNo='" + LedgerNumber + "'  GROUP BY st.ItemID )st      ");
			sb.Append("     WHERE (st.InitialCount-st.ReleasedCount-   ");
			sb.Append("        IFNULL(st.ReceivedQty,0)-IFNULL(st.ReturnedQty,0)) >0  ");
			if (IsLocalConn)
			{
				this.objCon.Open();
				DataSet ds = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, sb.ToString());
				this.objCon.Close();
				return ds.Tables[0];
			}
			else
			{
				return null;
			}
		}
		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return null;
		}
	}
	public DataTable LoadSetItemsWithOutStock(string SetID)
	{
		try
		{
			StringBuilder sb = new StringBuilder();
			sb.Append("SELECT SetName,SetID,ItemID,ItemName,Quantity FROM cssd_set_itemdetail WHERE isactive=1 AND setID='" + SetID + "' ");
			if (IsLocalConn)
			{
				this.objCon.Open();
				DataSet ds = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, sb.ToString());
				this.objCon.Close();
				return ds.Tables[0];
			}
			else
			{
				return null;
			}
		}
		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return null;
		}
	}
	public DataTable BtchProcessDateTime(string BatchNo)
	{
		try
		{
			StringBuilder sb = new StringBuilder();
			sb.Append("      SELECT DATE_FORMAT(startDate,'%d-%b-%Y')ApproxStartDate,DATE_FORMAT(startDate,'%h:%i %p')ApproxStartTime, ");
			sb.Append("  DATE_FORMAT(EndDate,'%d-%b-%Y')ApproxEndDate,DATE_FORMAT(EndDate,'%h:%i %p')ApproxEndTime,SetID FROM  ");
			sb.Append("  cssd_f_batch_tnxdetails where BatchNo='" + BatchNo + "' and IsProcess=1  limit 1 ");

			if (IsLocalConn)
			{
				this.objCon.Open();
				DataSet ds = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, sb.ToString());
				this.objCon.Close();
				return ds.Tables[0];
			}
			else
			{
				return null;
			}
		}
		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return null;
		}

	}
	//*******  Get Billed Corpse Details *******

	public DataTable GetBilledCorpseDetail(string TransactionID)
	{
		try
		{
			string sql = "SELECT LedgerTransactionNo,NetAmount,GrossAmount,DiscountOnTotal,DATE_FORMAT(DATE,'%d-%b-%Y')EntryDate,((DiscountOnTotal/GrossAmount) * 100) AS Discount,IFNULL(BillNo,'')BillNo,DATE_FORMAT(BillDate,'%d-%b-%Y')BillDate,DiscountReason,CorpseID,TransactionID,PanelID,TransactionTypeID,DATE_FORMAT(DATE,'%d-%b-%Y')`Date`FROM mortuary_ledgertransaction WHERE TransactionID = '" + TransactionID + "'  ORDER BY LedgerTransactionNo";

			if (IsLocalConn)
			{
				this.objCon.Open();
				DataSet ds = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, sql);
				this.objCon.Close();
				return ds.Tables[0];
			}
			else
			{
				return null;
			}
		}
		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return null;
		}
	}


	//*******  Get Billed Patient Item Details *******
	public DataTable GetBilledCorpseItemDetail(string TrnxID)
	{
		try
		{


			string sql = "SELECT LedgerTransactionNo,Amount,T1.ItemID,Rate,Quantity,StockID,DiscountPercentage,IsPackage,PackageID,IsVerified,t1.SubCategoryID,VarifiedUserID, "
						+ "ItemName,TransactionID,VerifiedDate,UserID,EntryDate,DiscountAmount,LTDetailID,SubCategory, "
						+ "DisplayName,DisplayPriority,DisplayPriority,t1.IsSurgery,t1.Surgery_ID,t1.SurgeryName,t1.DiscountReason,t1.UserName,IF(t1.Type_ID='',im.Type_ID,t1.Type_ID)Type_ID,im.ServiceItemID,(Rate*Quantity)GrossAmt, "
						+ "IFNULL(dm.Specialization,'')Specialization,t1.IsPayable FROM ( "
						+ "     SELECT LTD.LedgerTransactionNo,LTD.Amount,LTD.ItemID,LTD.Rate,LTD.Quantity,LTD.StockID,"
						+ "     LTD.DiscountPercentage,LTD.IsPackage,LTD.PackageID,LTD.IsVerified,LTD.SubCategoryID, "
						+ "     LTD.VarifiedUserID,LTD.ItemName,LTD.TransactionID,"
						+ "     DATE_FORMAT(LTD.VerifiedDate,'%d-%b-%Y')VerifiedDate,LTD.LedgerTnxID AS LTDetailID,"
						+ "     LTD.UserID,DATE_FORMAT(LTD.EntryDate,'%d-%b-%Y')EntryDate,"
						+ "    (((Rate * Quantity)*DiscountPercentage)/100) DiscountAmount,IFNULL(ltd.Type_ID,'')Type_ID, "
						+ "     SC.Name AS SubCategory,SC.DisplayName,SC.DisplayPriority,LTD.IsSurgery,"
						+ "     LTD.Surgery_ID,LTD.SurgeryName,LTD.DiscountReason,EM.Name AS UserName,LTD.IsPayable      "
						+ "     FROM mortuary_ledgertnxdetail LTD INNER JOIN mortuary_ledgertransaction LT ON "
						+ "     LT.LedgerTransactionNo = LTD.LedgerTransactionNo INNER JOIN "
						+ "     f_subcategorymaster SC ON SC.SubcategoryID = LTD.SubcategoryID "
						+ "     INNER JOIN employee_master EM ON EM.EmployeeID = LTD.UserID "
						+ "     WHERE LT.TransactionID = '" + TrnxID + "' AND LTD.Isverified =1  "
						+ " )t1 LEFT JOIN f_itemmaster im ON im.itemid = t1.ItemID "
						+ " LEFT JOIN doctor_master dm ON dm.DoctorID=im.Type_ID "
						+ " ORDER BY t1.DisplayName, t1.SubCategoryID,t1.ItemID, "
						+ " DATE(t1.EntryDate) ";

			if (IsLocalConn)
			{
				this.objCon.Open();
				DataSet ds = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, sql);
				this.objCon.Close();
				return ds.Tables[0];
			}
			else
			{
				return null;
			}
		}
		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return null;
		}
	}


	//*******  Get Billed Corpse Item Details discount *******

	public DataTable GetBilledCorpseItemDetailDiscount(string TrnxID)
	{
		try
		{

			string sql = "SELECT LedgerTransactionNo,Amount,T1.ItemID,Rate,Quantity,StockID,DiscountPercentage,IsPackage,PackageID,IsVerified,t1.SubCategoryID,VarifiedUserID, "
				//+ "(case when im.Type_ID='GP' then 'Shree Gopal Medicose' when im.Type_ID='IMP' then 'Implants' else ItemName end)ItemName,TransactionID,VerifiedDate,UserID,EntryDate,DiscountAmount,LTDetailID,SubCategory, "
						+ "ItemName,TransactionID,VerifiedDate,UserID,EntryDate,DiscountAmount,LTDetailID,SubCategory, "
						+ "DisplayName,t1.IsDiscountable,DisplayPriority,DisplayPriority,t1.IsSurgery,t1.Surgery_ID,t1.SurgeryName,t1.DiscountReason,t1.UserName,im.Type_ID,im.ServiceItemID,(Rate*Quantity)GrossAmt, "
						+ "IFNULL(dm.Specialization,'')Specialization FROM ( "
						+ "     SELECT LTD.LedgerTransactionNo,LTD.Amount,LTD.ItemID,LTD.Rate,LTD.Quantity,LTD.StockID,"
						+ "     LTD.DiscountPercentage,LTD.IsPackage,LTD.PackageID,LTD.IsVerified,LTD.SubCategoryID, "
						+ "     LTD.VarifiedUserID,LTD.ItemName,LTD.TransactionID,"
						+ "     DATE_FORMAT(LTD.VerifiedDate,'%d-%b-%Y')VerifiedDate,LTD.LedgerTnxID AS LTDetailID,"
						+ "     LTD.UserID,DATE_FORMAT(LTD.EntryDate,'%d-%b-%Y')EntryDate,"
						+ "    (((Rate * Quantity)*DiscountPercentage)/100) DiscountAmount, "
						+ "     SC.Name AS SubCategory,SC.DisplayName,SC.DisplayPriority,SC.IsDiscountable,LTD.IsSurgery,"
						+ "     LTD.Surgery_ID,LTD.SurgeryName,LTD.DiscountReason,EM.Name AS UserName      "
						+ "     FROM mortuary_ledgertnxdetail LTD INNER JOIN mortuary_ledgertransaction LT ON "
						+ "     LT.LedgerTransactionNo = LTD.LedgerTransactionNo INNER JOIN "
						+ "     f_subcategorymaster SC ON SC.SubcategoryID = LTD.SubcategoryID "
						+ "     LEFT JOIN employee_master EM ON EM.EmployeeID = LTD.DiscUserID  "
						+ "     WHERE LT.TransactionID = '" + TrnxID + "' AND LTD.Isverified =1  "
						+ " )t1 LEFT JOIN f_itemmaster im ON im.itemid = t1.ItemID "
						+ " LEFT JOIN doctor_master dm ON dm.DoctorID=im.Type_ID "
						+ " ORDER BY t1.DisplayName, t1.SubCategoryID,t1.ItemID, "
						+ " DATE(t1.EntryDate) ";

			if (IsLocalConn)
			{
				this.objCon.Open();
				DataSet ds = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, sql);
				this.objCon.Close();
				return ds.Tables[0];
			}
			else
			{
				return null;
			}
		}
		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return null;
		}
	}
	// Search Appointment List For Screening
	public DataTable GetDoctorScreen_Appointment(string DoctorID)
	{
		string str = " SELECT REPLACE(app.PatientID,'LSHHI','')MRNo,app.PatientID,CONCAT(app.Title,' ',app.Pname)Pname,app.Age, ";
		str += " CONCAT(IFNULL(app.P_Type,''),'/',app.AppNo)App_No,if(app.flag=1,'true','false')IsDone,flag,app.TransactionID,DATE_FORMAT(app.date,'%d-%b-%y')A_date, ";
		str += " TIME_FORMAT(app.time,'%l: %i %p')A_Time,lt.LedgerTransactionNo,app.App_ID, ";
		str += " App.IsCall,app.CallNo,app.P_In,app.P_Out FROM appointment app ";
		str += " INNER JOIN f_ledgertransaction lt ON app.LedgerTnxNo=lt.LedgertransactionNo AND lt.TypeOfTnx='OPD-APPOINTMENT' ";
		str += " INNER JOIN doctor_master dm ON dm.DoctorID=app.DoctorID ";
		if (System.Web.HttpContext.Current.Session["ID"].ToString() != "EMP001")
			str += " WHERE lt.IsCancel=0 AND app.DoctorID='" + DoctorID + "' AND app.P_Out=0 AND app.date=CURRENT_DATE() ";
		else
			str += " WHERE lt.IsCancel=0 AND app.P_Out=0 AND app.date=CURRENT_DATE() ";
		//str += " Union All ";
		//str += "SELECT '' MRNo,'' PatientID,Patient Pname,Age,  ";
		//str += "App_ID App_No,'false' IsDone,0 flag,'' TransactionID,DATE_FORMAT(appointment_date,'%d-%b-%y')A_date,  ";
		//str += "TIME_FORMAT(appointment_time,'%l: %i %p')A_Time,'' LedgerTransactionNo, App_ID,  ";
		//str += "0 IsCall,0 CallNo,NULL P_In,NULL P_Out FROM doctor_appointment WHERE DoctorID='" + DoctorID + "' AND iscancel=0 AND appointment_date=CURRENT_DATE()";
		DataTable dt = new DataTable();
		if (IsLocalConn)
		{
			this.objCon.Open();
			dt = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, str).Tables[0];
			this.objCon.Close();
			return dt;
		}
		else
		{
			dt = MySqlHelper.ExecuteDataset(this.objTrans, CommandType.Text, str).Tables[0];
			return dt;
		}
	}
	public DataTable GetDoctorScreen_Appointment_PType(string DoctorID, string P_Type)
	{
		string str = " SELECT REPLACE(app.PatientID,'LSHHI','')MRNo,CONCAT(app.Title,' ',app.Pname)Pname,app.Age, ";
		str += " CONCAT(IFNULL(app.P_Type,''),'/',app.AppNo)App_No,if(app.flag=1,'true','false')IsDone,flag,DATE_FORMAT(app.date,'%d-%b-%y')A_date, ";
		str += " TIME_FORMAT(app.time,'%l: %i %p')A_Time,lt.LedgerTransactionNo,app.App_ID, ";
		str += " App.IsCall,app.CallNo,app.P_In,app.P_Out,(case when P_Type='A' then 'navajowhite' when P_Type='S' then 'Gray' when  P_Type='R' then 'Green' end ) BGColor FROM appointment app ";
		str += " INNER JOIN f_ledgertransaction lt ON app.LedgertransactionNo=lt.LedgertransactionNo AND lt.TypeOfTnx='OPD-APPOINTMENT' ";
		str += " INNER JOIN doctor_master dm ON dm.DoctorID=app.DoctorID ";
		if (System.Web.HttpContext.Current.Session["ID"].ToString() != "EMP001")
			str += " WHERE lt.IsCancel=0 AND app.DoctorID='" + DoctorID + "' and P_Type='" + P_Type + "' AND app.P_Out=0 AND app.date=CURRENT_DATE() ";
		else
			str += " WHERE lt.IsCancel=0 and P_Type='" + P_Type + "' AND app.P_Out=0 AND app.date=CURRENT_DATE() ";

		DataTable dt = new DataTable();
		if (IsLocalConn)
		{
			this.objCon.Open();
			dt = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, str).Tables[0];
			this.objCon.Close();
			return dt;
		}
		else
		{
			dt = MySqlHelper.ExecuteDataset(this.objTrans, CommandType.Text, str).Tables[0];
			return dt;
		}
	}
	public DataTable LoadAll_InOutPatient(string DoctorID)
	{
		string str = " SELECT REPLACE(app.PatientID,'LSHHI','')MRNo,app.PatientID,CONCAT(app.Title,' ',app.Pname)Pname,app.Age, ";
		str += " CONCAT(IFNULL(app.P_Type,''),'/',app.AppNo)App_No,if(app.flag=1,'true','false')IsDone,flag,app.TransactionID,DATE_FORMAT(app.date,'%d-%b-%y')A_date, ";
		str += " TIME_FORMAT(app.time,'%l: %i %p')A_Time,lt.LedgerTransactionNo,app.App_ID, ";
		str += " App.IsCall,app.CallNo,app.P_In,app.P_Out FROM appointment app ";
		str += " INNER JOIN f_ledgertransaction lt ON app.LedgertransactionNo=lt.LedgertransactionNo AND lt.TypeOfTnx='OPD-APPOINTMENT' ";
		str += " INNER JOIN doctor_master dm ON dm.DoctorID=app.DoctorID ";
		str += " WHERE lt.IsCancel=0 AND app.DoctorID='" + DoctorID + "' AND app.date=CURRENT_DATE() ";
		DataTable dt = new DataTable();
		if (IsLocalConn)
		{
			this.objCon.Open();
			dt = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, str).Tables[0];
			this.objCon.Close();
			return dt;
		}
		else
		{
			dt = MySqlHelper.ExecuteDataset(this.objTrans, CommandType.Text, str).Tables[0];
			return dt;
		}
	}

	public DataTable LoadAll_OnlinePatient(string DoctorID)
	{
		string str = @" SELECT '' MRNo,'' PatientID, CONCAT(app.Title,' ',app.PName)Pname,app.Age, 
					CONCAT('A',app.App_ID)App_No,'false' IsDone,'0' flag,'' TransactionID,DATE_FORMAT(app.Date,'%d-%b-%y')A_date, 
					TIME_FORMAT(app.Time,'%l: %i %p')A_Time,'' LedgerTransactionNo,'' App_ID, 0 IsCall,'' CallNo,'' P_In,'' P_Out
					FROM  appointment app 
					INNER JOIN doctor_master dm ON dm.DoctorID=app.DoctorID 
					WHERE  app.DoctorID='" + DoctorID + "' AND app.Date=CURRENT_DATE() AND app.App_ID IS NULL";
		DataTable dt = new DataTable();
		if (IsLocalConn)
		{
			this.objCon.Open();
			dt = MySqlHelper.ExecuteDataset(objCon, CommandType.Text, str).Tables[0];
			this.objCon.Close();
			return dt;
		}
		else
		{
			dt = MySqlHelper.ExecuteDataset(this.objTrans, CommandType.Text, str).Tables[0];
			return dt;
		}
	}
}
