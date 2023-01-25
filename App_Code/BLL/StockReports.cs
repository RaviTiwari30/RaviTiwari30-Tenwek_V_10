using System;
using System.Collections;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

/// <summary>
/// Helper Class for Stock Related Data
/// </summary>
public class StockReports
{
	public StockReports()
	{
		//
		// TODO: Add constructor logic here
		//
	}
	/// <summary>
	/// Return Datatable having stock status between given dates
	/// Pass Empty String in Subcategories / ItemIds for All Records
	/// </summary>
	/// <param name="fromDate"></param>
	/// <param name="toDate"></param>
	/// <returns></returns>
	
	
	#region GetDataTable
	public static DataTable GetDataTable(string strQuery)
	{
		MySqlConnection conn;
		conn = Util.GetMySqlCon();
        DataTable dt = new DataTable();
        if (conn.State == ConnectionState.Closed)
            conn.Open();
        try
        {
            dt = MySqlHelper.ExecuteDataset(conn, CommandType.Text, strQuery).Tables[0];
        }
        catch
        {

        }
        finally {
            if (conn.State == ConnectionState.Open)
                conn.Close();
            if (conn != null)
            {
                conn.Dispose();
                conn = null;
            }
        }
		return dt;
	}
	#endregion

	#region ExecuteDML
    public static bool ExecuteDML(string strQuery)
    {
        MySqlConnection conn;
        MySqlTransaction tnx;
        conn = Util.GetMySqlCon();

        if (conn.State == ConnectionState.Closed)
        {
            conn.Open();
        }
        tnx = conn.BeginTransaction();
        try
        {
            int result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strQuery);

            if (result > 0)
            {
                tnx.Commit();
                //tnx.Dispose();

                //if (conn.State == ConnectionState.Open)
                //{
                //    conn.Close();
                //    conn.Dispose();
                //}
                return true;
            }
            else
            {
                tnx.Rollback();
                //tnx.Dispose();

                //if (conn.State == ConnectionState.Open)
                //{
                //    conn.Close();
                //    conn.Dispose();
                //}
                return false;
            }
        }
        catch { return false;}
        finally
        {
            tnx.Dispose();
            if (conn.State == ConnectionState.Open)
            {
                conn.Close();
                conn.Dispose();
            }
        }
    }
	#endregion

	#region ExecuteScalar

	public static string ExecuteScalar(string strQuery)
	{
		MySqlConnection conn;
		conn = Util.GetMySqlCon();
        string Result = string.Empty;
		if (conn.State == ConnectionState.Closed)
			conn.Open();
        try
        {
             Result = Util.GetString(MySqlHelper.ExecuteScalar(conn, CommandType.Text, strQuery));
            
        }
        catch { }
        finally {
            if (conn.State == ConnectionState.Open)
                conn.Close();
            if (conn != null)
            {
                conn.Dispose();
                conn = null;
            }
        }
		return Result;
		
	}

	#endregion


	#region Change Number To Word

	public static string ChangeNumericToWords(string Amount)
	{
		decimal temp = Convert.ToDecimal(Amount);
		int number = Convert.ToInt32(Math.Round(temp));
		if (number == 0) return "Zero";
		if (number == -2147483648) return "Minus Two Hundred and Fourteen Crore Seventy Four Lakh Eighty Three Thousand Six Hundred and Forty Eight";
		int[] num = new int[4];
		int first = 0;
		int u, h, t;
		System.Text.StringBuilder sb = new System.Text.StringBuilder();
		if (number < 0)
		{
			sb.Append("Minus ");
			number = -number;
		}
		string[] words0 = {"" ,"One ", "Two ", "Three ", "Four ",
	"Five " ,"Six ", "Seven ", "Eight ", "Nine "};
		string[] words1 = {"Ten ", "Eleven ", "Twelve ", "Thirteen ", "Fourteen ",
	"Fifteen ","Sixteen ","Seventeen ","Eighteen ", "Nineteen "};
		string[] words2 = {"Twenty ", "Thirty ", "Forty ", "Fifty ", "Sixty ",
	"Seventy ","Eighty ", "Ninety "};
		string[] words3 = { "Thousand ", "Lakh ", "Crore " };
		num[0] = number % 1000; // units
		num[1] = number / 1000;
		num[2] = number / 100000;
		num[1] = num[1] - 100 * num[2]; // thousands
		num[3] = number / 10000000; // crores
		num[2] = num[2] - 100 * num[3]; // lakhs
		for (int i = 3; i > 0; i--)
		{
			if (num[i] != 0)
			{
				first = i;
				break;
			}
		}
		for (int i = first; i >= 0; i--)
		{
			if (num[i] == 0) continue;
			u = num[i] % 10; // ones
			t = num[i] / 10;
			h = num[i] / 100; // hundreds
			t = t - 10 * h; // tens
			if (h > 0) sb.Append(words0[h] + "Hundred ");
			if (u > 0 || t > 0)
			{
				if (h > 0 || i == 0) sb.Append("and ");
				if (t == 0)
					sb.Append(words0[u]);
				else if (t == 1)
					sb.Append(words1[u]);
				else
					sb.Append(words2[t - 2] + words0[u]);
			}
			if (i != 0) sb.Append(words3[i - 1]);
		}
		if (number.ToString().Length < 3)
		{
			sb = sb.Replace("and", "");
		}
		return sb.ToString().TrimEnd();
	}
	#endregion
	/// <summary>
	/// It restricts OPD Billing for Admitted patient.Returns true if patient is admitted else false
	/// </summary>
	/// <param name="PID"></param>
	/// <returns></returns>
	public static bool RestrictOPD_For_AlreadyAddmittedPatient(string PID)
	{
		bool Status = false;
		string TID = ExecuteScalar("Select TransactionID from patient_ipd_profile where status='IN' and PatientID='" + PID + "' ");
		if (TID != string.Empty)
			Status = true;		
		return Status;
	}
	public static void GenerateMenuData(string strLoginType)
	{
		StringBuilder sbMenu = new StringBuilder();
		sbMenu.Append("select distinct(mm.ID),mm.MenuName,mm.image,mm.Description from f_filemaster fm inner join f_file_role fr on fm.ID = fr.UrlID");
		sbMenu.Append(" inner join f_rolemaster rm on fr.RoleID = rm.ID AND rm.Active=1 inner join f_menumaster mm on fm.MenuID = mm.ID ");
		sbMenu.Append(" LEFT JOIN f_role_menu_Sno rsm ON rsm.MenuID=fm.MenuID AND rsm.RoleID=rm.ID ");
		sbMenu.Append(" where fm.Active = 1 and fr.Active = 1 and mm.Active = 1 and rm.RoleName = '" + strLoginType + "' order by rsm.SNo,mm.MenuName ");

		DataSet ds = new DataSet();

		DataTable dtMenu = new DataTable();
		dtMenu = GetDataTable(sbMenu.ToString());

		if (dtMenu.Rows.Count > 0)
		{
			StringBuilder sbItems = new StringBuilder();
			sbItems.Append("select URLName,DispName,MenuID from f_filemaster fm inner join f_file_role fr on fm.ID = fr.UrlID");
			sbItems.Append(" inner join f_rolemaster rm on fr.RoleID = rm.ID AND rm.Active=1 where fm.Active = 1 and fr.Active = 1 and rm.RoleName = '" + strLoginType + "' order by SNo");

			DataTable dtItems = new DataTable();
			dtItems = GetDataTable(sbItems.ToString());

			ds.Tables.Add(dtMenu.Copy());
			ds.Tables[0].TableName = "Menu";

			ds.Tables.Add(dtItems.Copy());
			ds.Tables[1].TableName = "Items";

			DataRelation mi = new DataRelation("Menu_Items", ds.Tables[0].Columns["ID"], ds.Tables[1].Columns["MenuID"]);
			mi.Nested = true;
			ds.Relations.Add(mi);
		}
		ds.WriteXml(HttpContext.Current.Server.MapPath(@"~/Design/MenuData/" + strLoginType + ".xml"));
	}
	public static DataTable GetAuthorization(int RoleId, string EmpId)
	{

        int CentreId = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
        DataTable dt = StockReports.GetDataTable("CALL sp_UserAuth_By_Emp_Cen_Role('" + EmpId + "','" + CentreId + "','" + RoleId + "')");
         return dt;
	}

	public static DataTable GetPurchaseApproval(string ApprovalFor, string EmpId)
	{
		string str = "select * from f_purchase_approval where  ApprovalFor = '" + ApprovalFor.Trim()+ "' and Approval=1 and employeeid = '" + EmpId + "' ";
		return GetDataTable(str);
	}

	public static DataTable GetRights(string RoleId)
	{
		string str = "SELECT if(IsGeneral=1,'true','false')IsGeneral,if(IsMedical=1,'true','false')IsMedical,IsStore FROM f_rolemaster WHERE id='" + RoleId + "' AND active=1 AND (IsStore=1 OR IsIndent=1  OR IsGeneral=1 OR IsMedical=1) ";
		return GetDataTable(str);
	}

	public static string GetCurrentRateScheduleID(int PanelID)
	{
		return ExecuteScalar("SELECT ScheduleChargeID FROM f_rate_schedulecharges WHERE IsDefault=1 AND panelID=" + PanelID + " ");
	}
	public static string GetSelection(CheckBoxList cbl)
	{
		string str = string.Empty;
		foreach (ListItem li in cbl.Items)
		{
			if (li.Selected)
			{
				if (str != string.Empty)
					str += ",'" + li.Value + "'";
				else
					str = "'" + li.Value + "'";
			}
		}
		return str;
	}
	public static ArrayList GetSelection(ListBox cbl)
	{
		ArrayList al = new ArrayList();
		foreach (ListItem li in cbl.Items)
			if (li.Selected)
				al.Add(li.Value);

		return al;
	}
	public static DataTable GetUserName(string userID)
	{
		return GetDataTable("select concat(Title,' ',Name) EmpName from employee_master where EmployeeID = '" + userID + "'");
		
	}
	public static void GenerateMenuData_EmployeeWise(string RoleName, string EmployeeID)
	{
		StringBuilder sbMenu = new StringBuilder();
		sbMenu.Append("select distinct(mm.ID),mm.MenuName,mm.Description from f_filemaster fm inner join f_file_role fr on fm.ID = fr.UrlID");
		sbMenu.Append(" inner join f_rolemaster rm on fr.RoleID = rm.ID AND rm.Active=1 inner join f_menumaster mm on fm.MenuID = mm.ID inner join Employee_master em on em.EmployeeID=fr.EmployeeID");
		sbMenu.Append(" where fm.Active = 1 and fr.Active = 1 and mm.Active = 1 and rm.RoleName = '" + RoleName + "' and em.EmployeeID='" + EmployeeID + "' order by mm.MenuName");

		DataSet ds = new DataSet();

		DataTable dtMenu = new DataTable();
		dtMenu = GetDataTable(sbMenu.ToString());

		if (dtMenu.Rows.Count > 0)
		{
			StringBuilder sbItems = new StringBuilder();
			sbItems.Append("select URLName,DispName,MenuID from f_filemaster fm inner join f_file_role fr on fm.ID = fr.UrlID");
			sbItems.Append(" inner join f_rolemaster rm on fr.RoleID = rm.ID inner join Employee_master em on em.EmployeeID=fr.EmployeeID AND rm.Active=1 where fm.Active = 1 and fr.Active = 1 and rm.RoleName = '" + RoleName + "'  and em.EmployeeID='" + EmployeeID + "' order by DispName");

			DataTable dtItems = new DataTable();
			dtItems = GetDataTable(sbItems.ToString());

			ds.Tables.Add(dtMenu.Copy());
			ds.Tables[0].TableName = "Menu";

			ds.Tables.Add(dtItems.Copy());
			ds.Tables[1].TableName = "Items";

			DataRelation mi = new DataRelation("Menu_Items", ds.Tables[0].Columns["ID"], ds.Tables[1].Columns["MenuID"]);
			mi.Nested = true;
			ds.Relations.Add(mi);
		}
		ds.WriteXml(HttpContext.Current.Server.MapPath(@"~/Design/MenuData/" + EmployeeID + "_" + RoleName + ".xml"));
	}
	public static string GetConfigIDbySubCategoryID(string SubCategoryID,MySqlConnection con)
	{
		return Util.GetString( MySqlHelper.ExecuteScalar(con,CommandType.Text, "SELECT ConfigID FROM f_configrelation WHERE CategoryID=(SELECT CategoryID FROM f_subcategorymaster WHERE SubCategoryID='" + SubCategoryID + "' LIMIT 1)"));	
	}
    //public static DataTable ShouldSendToIPDPackage(string TransactionID, string PackageID, string ItemID, decimal Amount, decimal Qty, MySqlConnection con)
    //{
    //    string str = "";

    //    str = "Select CategoryID from f_subCategorymaster where SubCategoryID=(" +
    //          "     Select SubCategoryID from F_itemmaster where ItemID='" + ItemID + "')";

    //    string CategoryID =Util.GetString( MySqlHelper.ExecuteScalar(con,CommandType.Text, str));

    //    str = "SELECT IF(IsAmount=0," +
    //    "IF((IFNULL(ltd.Qty,0)+ " + Qty + ") <= IFNULL(pkd.Quantity,0),'true','false')," +
    //    "IF((IFNULL(ltd.Amount,0)+ " + Amount + ") <= IFNULL(pkd.Amount,0),'true','false'))iStatus, " +
    //    "ltd.PackageID,ltd.ItemID,(IFNULL(ltd.Qty,0)+ 1)LtdCount,IFNULL(pkd.Quantity,0)PkdCount," +
    //    "(IFNULL(ltd.Amount,0)+ 100)LtdAmt,IFNULL(pkd.Amount,0)PkdAmt FROM ( " +
    //    "       Select * from packagemasteripd_details where ItemID='" + PackageID + "' " +
    //    "       AND CategoryID='" + CategoryID + "' and IsActive=1) pkd LEFT JOIN (" +
    //    "       SELECT PackageID,ItemID,COUNT(ItemID)Qty,SUM(Rate*Quantity)Amount, " +
    //    "       sc.CategoryID FROM f_ledgertnxdetail ltd INNER JOIN " +
    //    "       f_subcategorymaster sc ON sc.SubCategoryID = ltd.SubCategoryID " +
    //    "       WHERE TransactionID='" + TransactionID + "' AND IsVerified=1 AND IsPackage=1 " +
    //    "       AND sc.CategoryID='" + CategoryID + "' AND PackageID='" + PackageID + "' GROUP BY sc.CategoryID " +
    //    ")ltd  ON pkd.ItemID = ltd.PackageID AND ltd.CategoryID = pkd.CategoryID ";


    //    DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, str).Tables[0];

    //    if (dt != null && dt.Rows.Count > 0)
    //    { return dt; }
    //    else { return null; }
    //}

	public static string GetPatient_Type_IPD(string Tranaction_ID)
	{
		return ExecuteScalar("SELECT Patient_Type FROM Patient_Medical_History WHERE TransactionID='" + Tranaction_ID + "'");
	}
	public static DataTable GetIPD_Packages_Prescribed(string TransactionID,MySqlConnection con)
	{
		string str = "SELECT ltd.ItemID PackageID FROM f_configrelation cf INNER JOIN f_subcategorymaster sc ON " +
					 "cf.CategoryID = sc.CategoryID INNER JOIN f_ledgertnxdetail ltd ON " +
					 "ltd.SubCategoryID = sc.SubCategoryID WHERE cf.ConfigID=14 " +
					 "AND  TransactionID='" + TransactionID + "' AND IsVerified=1 AND IsPackage=0";

		return MySqlHelper.ExecuteDataset(con, CommandType.Text, str).Tables[0];
	}

	public static string GetItemRateForMedicalService(string TransactionID, string ItemID)
	{
		string str = "Select pip.*,pmh.*,(SELECT ReferenceCode FROM f_panel_master WHERE PanelID=pmh.PanelID)ReferenceCode from " +
					"(Select Patient_Type,ScheduleChargeID,PanelID from patient_medical_history where TransactionID='" + TransactionID + "')pmh," +
					"(Select IPDCaseType_ID_Bill from patient_ipd_profile where TransactionID='" + TransactionID + "' and status='IN')pip ";

		DataTable dt = GetDataTable(str);

		str = "Select Concat(ifnull(rt.Rate,0),'#',im.TypeName)Rate from f_ratelist_ipd rt inner join f_itemmaster im on rt.ItemID = im.ItemID  where rt.ItemID='" + ItemID + "' and rt.PanelID=" + dt.Rows[0]["ReferenceCode"].ToString() + " " +
				" and rt.ScheduleChargeID='" + dt.Rows[0]["ScheduleChargeID"].ToString() + "' and rt.IPDCaseType_ID='" + dt.Rows[0]["IPDCaseType_ID_Bill"].ToString() + "' and rt.IsCurrent=1";

		return ExecuteScalar(str);

	}
	public static int GetIsPayableItems(string ItemID, int PanelID)
	{
		string IsPayble = "";
		IsPayble = StockReports.ExecuteScalar("SELECT pp.ID FROM f_panel_item_payable pp INNER JOIN f_panel_master pnl " +
		  "ON pp.PanelID = pnl.ReferenceCode WHERE pp.itemid='" + ItemID + "' AND pnl.PanelID=" + PanelID + " " +
		  "AND pp.IsActive=1 ORDER BY pp.ID DESC LIMIT 1");
		if (IsPayble == "")
			return 0;
		else
			return 1;
	}
	public static string GetPatientCurrentRateScheduleID_IPD(string Tranaction_ID)
	{
		string str = "SELECT ScheduleChargeID FROM Patient_Medical_History WHERE TransactionID='" + Tranaction_ID + "'";
		return ExecuteScalar(str);
	}
	public static string GetExpireApprovalAmountAlert(string Tid)
	{
		string ExpiryAppDate = ExecuteScalar("SELECT DATE_FORMAT(ApprovalExpiryDate,'%d-%b-%Y')ApprovalExpiryDate FROM f_ipdpanelapproval WHERE TransactionID='" + Tid + "' AND AmountApprovalType='Fix' ORDER BY ID DESC LIMIT 1");
		DateTime CurDate = Util.GetDateTime(DateTime.Now.ToString("dd-MMM-yyyy"));
		if (ExpiryAppDate != "")
		{
			TimeSpan Diff = Util.GetDateTime(ExpiryAppDate) - CurDate;
			if (Diff.Days <= 3)
			{
				return (Diff.Days.ToString());
			}
			else
				return "";
		}
		else
			return "";
	}
	public static bool ToBeBilled(string ItemID)
	{
		string IsBilled = "";

		IsBilled = ExecuteScalar("SELECT IFNull(ToBeBilled,'0') FROM f_itemmaster WHERE ItemID='" + ItemID + "'");

		if (IsBilled == "1")
			return true;
		else
			return false;
	}
	public static Boolean RejectMedicalServiceItems(string TID, string ItemID, string StockID, decimal RejectedQty, MySqlTransaction Tranx)
	{
		try
		{
			string str = "Select LedgerTnxID,LedgerTransactionNo,Rate,Quantity from f_ledgertnxdetail where TransactionID='" + TID + "' " +
						 " and IsVerified=1 and ItemID='" + ItemID + "' and IsMedService=1 and stockID='" + StockID + "'";

			DataTable dt = GetDataTable(str);

			if (dt != null && dt.Rows.Count > 0)
			{
				decimal BalQty = RejectedQty;
				foreach (DataRow dr in dt.Rows)
				{
					if (BalQty >= Util.GetDecimal(dr["Quantity"]))
					{
						str = "Update f_ledgertnxDetail Set IsVerified=2 where LedgerTnxID='" + Util.GetString(dr["LedgerTnxID"]) + "'";
						MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
						BalQty -= Util.GetDecimal(dr["Quantity"]);
					}
					else if (BalQty > 0 && BalQty < Util.GetDecimal(dr["Quantity"]))
					{
						str = "Update f_ledgertnxDetail Set Amount=(Rate*(Quantity-" + BalQty + "))-((Rate*(Quantity-" + BalQty + "))*DiscountPercentage/100),Quantity=(Quantity-" + BalQty + ") where LedgerTnxID='" + Util.GetString(dr["LedgerTnxID"]) + "'";
						MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
						BalQty -= Util.GetDecimal(dr["Quantity"]);
					}
				}
			}

			return true;
		}
		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return false;
		}
	}
	public static string GetDoctorNameByDoctorID(string DoctorID)
	{
		string str = "SELECT CONCAT(Title,' ',Name)Name FROM doctor_master WHERE DoctorID='" + DoctorID + "'";
		return ExecuteScalar(str);
	}
	public static string GetListSelection(ListBox cbl)
	{
		string str = string.Empty;
		foreach (ListItem li in cbl.Items)
		{
			if (li.Selected)
			{
				if (str != string.Empty)
					str += ",'" + li.Value + "'";
				else
					str = "'" + li.Value + "'";
			}
		}
		return str;
	}
    public static Boolean SentToIPDPackage(string TransactionID, string ItemID, DateTime date, int validitydays, MySqlConnection con)
	{
		try
		{
			//Checking if same package is prescribed again
			DataTable dtPkg = GetIPD_Packages_Prescribed(TransactionID,con);

			if (dtPkg != null && dtPkg.Rows.Count > 0)
			{
				foreach (DataRow dr in dtPkg.Rows)
				{
					if (dr["PackageID"].ToString() == ItemID)
						return false;
				}
			}

			//Getting all already prescribed not packaged items to be if required sifted to given package
            string str=" Select ItemID,Rate,Quantity,LedgerTnxID,IPDCaseTypeID from f_ledgertnxdetail where TransactionID='" + TransactionID + "' and Isverified=1 and IsPackage=0 and entrydate>='"+ Util.GetDateTime(date.ToString()).ToString("yyyy-MM-dd") +" 00:00:00' and entryDate<=DATE_ADD('" + Util.GetDateTime(date.ToString()).ToString("yyyy-MM-dd") + " 23:59:59',INTERVAL " + validitydays + " DAY)  and isSurgery=0";
			DataTable dtLed =MySqlHelper.ExecuteDataset(con,CommandType.Text, str).Tables[0];

			if (dtLed != null && dtLed.Rows.Count > 0)
			{
				foreach (DataRow row in dtLed.Rows)
				{
					decimal Rate = Util.GetDecimal(row["Rate"]);
					decimal Qty = Util.GetDecimal(row["Quantity"]);
					decimal Amount = Rate * Qty;
                    int IPDCaseTypeID = Util.GetInt(row["IPDCaseTypeID"]);

                    DataTable dt = ShouldSendToIPDPackage(TransactionID, ItemID, row["ItemID"].ToString(), Amount, Qty, IPDCaseTypeID, con);

					if (dt != null && dt.Rows.Count > 0)
					{
						if (Util.GetBoolean(dt.Rows[0]["iStatus"]))
						{
							string strQuery = "Update f_ledgertnxdetail Set IsPackage=1,";
							strQuery += "Amount=0, PackageID='" + ItemID + "' Where LedgerTnxID='" + row["LedgerTnxID"].ToString() + "'";
                            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, strQuery);
                            string strd = "SELECT ID FROM f_ledgertnxdetail ltd WHERE ltd.LedgerTnxID=" + row["LedgerTnxID"].ToString() + " ";
                            int Result = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, strd));
                            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "DELETE ds.* FROM f_docshare_transactiondetail ds WHERE ds.LedgerTnxID=" + Result + " ");
                            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "CALL `Insert_DoctorShare_At_ServiceBookingTime`(" + Result + ",2,'HOSP');");
						}

					}
				}
			}
            //Getting all already prescribed not packaged Surgery to be if required sifted to given package
            string stSur = " Select SUM(Rate)Rate,Quantity,LedgerTransactionNO,Surgery_ID,IsSurgery from f_ledgertnxdetail where TransactionID='" + TransactionID + "' and Isverified=1 and IsPackage=0 and entrydate>='" + Util.GetDateTime(date.ToString()).ToString("yyyy-MM-dd") + " 00:00:00' and isSurgery=1 GROUP BY LedgerTransactionNO";
            DataTable dtSur = MySqlHelper.ExecuteDataset(con, CommandType.Text, stSur).Tables[0];
            if (dtSur != null & dtSur.Rows.Count > 0)
            {
                foreach (DataRow row in dtSur.Rows)
                {
                    decimal Rate = Util.GetDecimal(row["Rate"]);
                    decimal Qty = Util.GetDecimal(row["Quantity"]);
                    decimal Amount = Rate * Qty;

                    DataTable dt = ShouldSurgerySendToIPDPackage(TransactionID, ItemID, Util.GetString(row["Surgery_ID"]), Util.GetDecimal(Amount), Util.GetInt("1"),0, con);
                    if (dt != null && dt.Rows.Count > 0)
                    {
                        if (Util.GetBoolean(dt.Rows[0]["iStatus"]))
                        {
                            string strQuery = "Update f_ledgertnxdetail Set IsPackage=1, Amount=0, PackageID='" + ItemID + "' Where LedgerTransactionNO='" + row["LedgerTransactionNO"].ToString() + "'";
                            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, strQuery);
                            string ltdid = Util.GetString(StockReports.ExecuteScalar("SELECT GROUP_CONCAT(CONCAT('''',ltd.LedgerTnxID,'''')) FROM f_ledgertnxdetail ltd  WHERE ltd.LedgerTransactionNO='" + row["LedgerTransactionNO"].ToString() + "' "));
                            if (ltdid != string.Empty)
                            {
                                string[] ltd = ltdid.Split(',');
                                for (int i = 0; i < ltd.Length; i++)
                                {
                                    string strd = "SELECT ID FROM f_ledgertnxdetail ltd WHERE ltd.LedgerTnxID='" + ltd[i] + "' ";
                                    int Result = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, strd));
                                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "DELETE ds.* FROM f_docshare_transactiondetail ds WHERE ds.LedgerTnxID=" + Result + " ");
                                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "CALL `Insert_DoctorShare_At_ServiceBookingTime`(" + Result + ",2,'HOSP');");
                                }
                            }
                        }
                    }
                }
            }
			return true;
		}
		catch (Exception ex)
		{
			ClassLog cl = new ClassLog();
			cl.errLog(ex);
			return false;
		}
	}
	public static DataTable ShouldSendToIPDPackage(string TransactionID, string PackageID, string ItemID, decimal Amount, int Qty,int IPDCaseTypeID,MySqlConnection con)
	{
		string str = "";

		str = "Select CategoryID from f_subCategorymaster where SubCategoryID=(" +
			  "     Select SubCategoryID from F_itemmaster where ItemID='" + ItemID + "')";

		string CategoryID =Util.GetString(MySqlHelper.ExecuteScalar(con,CommandType.Text,str));


        string SubCategoryID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "Select SubCategoryID from F_itemmaster where ItemID='" + ItemID + "' "));

        // to check item date is coming in validity range of this package

        
        // For CategoryWise packageType=1
		str = "SELECT IF(IsAmount=0," +
		"IF((IFNULL(ltd.Qty,0)+ " + Qty + ") <= IFNULL(pkd.Quantity,0),'true','false')," +
		"IF((IFNULL(ltd.Amount,0)+ " + Amount + ") <= IFNULL(pkd.Amount,0),'true','false'))iStatus, " +
		"ltd.PackageID,ltd.ItemID,(IFNULL(ltd.Qty,0)+ 1)LtdCount,IFNULL(pkd.Quantity,0)PkdCount," +
        "(IFNULL(ltd.Amount,0)+ " + Amount + ")LtdAmt,IFNULL(pkd.Amount,0)PkdAmt FROM ( " +
        "       Select * from packagemasteripd_details where ItemID='" + PackageID + "' and RoomTypeID='" + IPDCaseTypeID + "'" +
        "       AND CategoryID='" + CategoryID + "' and IsActive=1 AND packageType=1) pkd LEFT JOIN (" +
		"       SELECT PackageID,ItemID,COUNT(ItemID)Qty,SUM(Rate*Quantity)Amount, " +
		"       sc.CategoryID FROM f_ledgertnxdetail ltd INNER JOIN " +
		"       f_subcategorymaster sc ON sc.SubCategoryID = ltd.SubCategoryID " +
		"       WHERE TransactionID='" + TransactionID + "' AND IsVerified=1 AND IsPackage=1 " +
        "       AND sc.CategoryID='" + CategoryID + "' AND PackageID='" + PackageID + "' and IPDCaseTypeID='" + IPDCaseTypeID + "' GROUP BY sc.CategoryID " +
		")ltd  ON pkd.ItemID = ltd.PackageID AND ltd.CategoryID = pkd.CategoryID "+
        // For ItemWise packageType=2
        "Union All " +
        "SELECT IF(IsAmount=0," +
        "IF((IFNULL(ltd.Qty,0)+ " + Qty + ") <= IFNULL(pkd.Quantity,0),'true','false')," +
        "IF((IFNULL(ltd.Amount,0)+ " + Amount + ") <= IFNULL(pkd.Amount,0),'true','false'))iStatus, " +
        "ltd.PackageID,ltd.ItemID,(IFNULL(ltd.Qty,0)+ 1)LtdCount,IFNULL(pkd.Quantity,0)PkdCount," +
        "(IFNULL(ltd.Amount,0)+ " + Amount + ")LtdAmt,IFNULL(pkd.Amount,0)PkdAmt FROM ( " +
        "       Select * from packagemasteripd_details where ItemID='" + PackageID + "' and RoomTypeID='" + IPDCaseTypeID + "'" +
        "       AND CategoryID='" + CategoryID + "' AND detail_itemid='"+ItemID+"' and IsActive=1 AND packageType=2) pkd LEFT JOIN (" +
        "       SELECT PackageID,ItemID,COUNT(ItemID)Qty,SUM(Rate*Quantity)Amount, " +
        "       sc.CategoryID FROM f_ledgertnxdetail ltd INNER JOIN " +
        "       f_subcategorymaster sc ON sc.SubCategoryID = ltd.SubCategoryID " +
        "       WHERE TransactionID='" + TransactionID + "' AND IsVerified=1 AND IsPackage=1 " +
        "       AND sc.CategoryID='" + CategoryID + "' and ltd.ItemID='" + ItemID + "' AND PackageID='" + PackageID + "' and IPDCaseTypeID='" + IPDCaseTypeID + "' GROUP BY sc.CategoryID " +
        ")ltd  ON pkd.ItemID = ltd.PackageID AND ltd.itemid = pkd.detail_itemid "+
            //For SubCategoryWise Package Type =3
        "Union All " +
       "SELECT IF(IsAmount=0," +
       "IF((IFNULL(ltd.Qty,0)+ " + Qty + ") <= IFNULL(pkd.Quantity,0),'true','false')," +
       "IF((IFNULL(ltd.Amount,0)+ " + Amount + ") <= IFNULL(pkd.Amount,0),'true','false'))iStatus, " +
       "ltd.PackageID,ltd.ItemID,(IFNULL(ltd.Qty,0)+ 1)LtdCount,IFNULL(pkd.Quantity,0)PkdCount," +
       "(IFNULL(ltd.Amount,0)+ " + Amount + ")LtdAmt,IFNULL(pkd.Amount,0)PkdAmt FROM ( " +
       "       Select * from packagemasteripd_details where ItemID='" + PackageID + "' and RoomTypeID='" + IPDCaseTypeID + "'" +
       "       AND CategoryID='" + CategoryID + "' AND SubCategoryid='" + SubCategoryID + "'  and IsActive=1 AND packageType=3) pkd LEFT JOIN (" +
       "       SELECT PackageID,ItemID,COUNT(ItemID)Qty,SUM(Rate*Quantity)Amount, " +
       "       sc.CategoryID,ltd.subcategoryid FROM f_ledgertnxdetail ltd INNER JOIN " +
       "       f_subcategorymaster sc ON sc.SubCategoryID = ltd.SubCategoryID " +
       "       WHERE TransactionID='" + TransactionID + "' AND IsVerified=1 AND IsPackage=1 " +
       "       AND sc.CategoryID='" + CategoryID + "' AND ltd.SubCategoryID='" + SubCategoryID + "'  and ltd.ItemID='" + ItemID + "' AND PackageID='" + PackageID + "' and IPDCaseTypeID='" + IPDCaseTypeID + "' GROUP BY sc.CategoryID " +
       ")ltd  ON pkd.ItemID = ltd.PackageID AND ltd.SubCategoryID = pkd.SubCategoryID ";

		DataTable dt = MySqlHelper.ExecuteDataset(con,CommandType.Text,str).Tables[0];

		if (dt != null && dt.Rows.Count > 0)
		{ return dt; }
		else { return null; }
	}
    public static DataTable ShouldSendToIPDPackage(string TransactionID, string PackageID, string ItemID, decimal Amount, decimal Qty, int IPDCaseTypeID, MySqlConnection con)
	{
		string str = "";

		str = "Select CategoryID from f_subCategorymaster where SubCategoryID=(" +
			  "     Select SubCategoryID from F_itemmaster where ItemID='" + ItemID + "')";

		string CategoryID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, str));

        string SubCategoryID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "Select SubCategoryID from F_itemmaster where ItemID='" + ItemID + "' " ));
        str = "SELECT IF(IsAmount=0," +
        "IF((IFNULL(ltd.Qty,0)+ " + Qty + ") <= IFNULL(pkd.Quantity,0),'true','false')," +
        "IF((IFNULL(ltd.Amount,0)+ " + Amount + ") <= IFNULL(pkd.Amount,0),'true','false'))iStatus, " +
        "ltd.PackageID,ltd.ItemID,(IFNULL(ltd.Qty,0)+ 1)LtdCount,IFNULL(pkd.Quantity,0)PkdCount," +
        "(IFNULL(ltd.Amount,0)+ " + Amount + ")LtdAmt,IFNULL(pkd.Amount,0)PkdAmt FROM ( " +
        "       Select * from packagemasteripd_details where ItemID='" + PackageID + "' and RoomTypeID='"+IPDCaseTypeID+"'" +
        "       AND CategoryID='" + CategoryID + "' and IsActive=1 AND packageType=1) pkd LEFT JOIN (" +
        "       SELECT PackageID,ItemID,COUNT(ItemID)Qty,SUM(Rate*Quantity)Amount, " +
        "       sc.CategoryID FROM f_ledgertnxdetail ltd INNER JOIN " +
        "       f_subcategorymaster sc ON sc.SubCategoryID = ltd.SubCategoryID " +
        "       WHERE TransactionID='" + TransactionID + "' AND IsVerified=1 AND IsPackage=1 " +
        "       AND sc.CategoryID='" + CategoryID + "' AND PackageID='" + PackageID + "' and IPDCaseTypeID='" + IPDCaseTypeID + "' GROUP BY sc.CategoryID " +
        ")ltd  ON pkd.ItemID = ltd.PackageID AND ltd.CategoryID = pkd.CategoryID " +
            // For ItemWise packageType=2
        "Union All " +
        "SELECT IF(IsAmount=0," +
        "IF((IFNULL(ltd.Qty,0)+ " + Qty + ") <= IFNULL(pkd.Quantity,0),'true','false')," +
        "IF((IFNULL(ltd.Amount,0)+ " + Amount + ") <= IFNULL(pkd.Amount,0),'true','false'))iStatus, " +
        "ltd.PackageID,ltd.ItemID,(IFNULL(ltd.Qty,0)+ 1)LtdCount,IFNULL(pkd.Quantity,0)PkdCount," +
        "(IFNULL(ltd.Amount,0)+ " + Amount + ")LtdAmt,IFNULL(pkd.Amount,0)PkdAmt FROM ( " +
        "       Select * from packagemasteripd_details where ItemID='" + PackageID + "' and RoomTypeID='" + IPDCaseTypeID + "' " +
        "       AND CategoryID='" + CategoryID + "' AND Detail_ItemID='" + ItemID + "' and IsActive=1 AND packageType=2) pkd LEFT JOIN (" +
        "       SELECT PackageID,ItemID,COUNT(ItemID)Qty,SUM(Rate*Quantity)Amount, " +
        "       sc.CategoryID FROM f_ledgertnxdetail ltd INNER JOIN " +
        "       f_subcategorymaster sc ON sc.SubCategoryID = ltd.SubCategoryID " +
        "       WHERE TransactionID='" + TransactionID + "' AND IsVerified=1 AND IsPackage=1 " +
        "       AND sc.CategoryID='" + CategoryID + "' and ltd.ItemID='" + ItemID + "' AND PackageID='" + PackageID + "' and IPDCaseTypeID='" + IPDCaseTypeID + "' GROUP BY sc.CategoryID " +
        ")ltd  ON pkd.ItemID = ltd.PackageID AND ltd.itemid = pkd.detail_itemid "+
        //For SubCategoryWise Package Type =3
        "Union All " +
       "SELECT IF(IsAmount=0," +
       "IF((IFNULL(ltd.Qty,0)+ " + Qty + ") <= IFNULL(pkd.Quantity,0),'true','false')," +
       "IF((IFNULL(ltd.Amount,0)+ " + Amount + ") <= IFNULL(pkd.Amount,0),'true','false'))iStatus, " +
       "ltd.PackageID,ltd.ItemID,(IFNULL(ltd.Qty,0)+ 1)LtdCount,IFNULL(pkd.Quantity,0)PkdCount," +
       "(IFNULL(ltd.Amount,0)+ " + Amount + ")LtdAmt,IFNULL(pkd.Amount,0)PkdAmt FROM ( " +
       "       Select * from packagemasteripd_details where ItemID='" + PackageID + "' and RoomTypeID='" + IPDCaseTypeID + "'" +
       "       AND CategoryID='" + CategoryID + "' AND SubCategoryid='"+ SubCategoryID +"'  and IsActive=1 AND packageType=3) pkd LEFT JOIN (" +
       "       SELECT PackageID,ItemID,COUNT(ItemID)Qty,SUM(Rate*Quantity)Amount, " +
       "       sc.CategoryID,ltd.subcategoryid FROM f_ledgertnxdetail ltd INNER JOIN " +
       "       f_subcategorymaster sc ON sc.SubCategoryID = ltd.SubCategoryID " +
       "       WHERE TransactionID='" + TransactionID + "' AND IsVerified=1 AND IsPackage=1 " +
       "       AND sc.CategoryID='" + CategoryID + "' AND ltd.SubCategoryID='" + SubCategoryID + "'  and ltd.ItemID='" + ItemID + "' AND PackageID='" + PackageID + "' and IPDCaseTypeID='" + IPDCaseTypeID + "' GROUP BY sc.CategoryID " +
       ")ltd  ON pkd.ItemID = ltd.PackageID AND ltd.SubCategoryID = pkd.SubCategoryID ";


		DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, str).Tables[0];

		if (dt != null && dt.Rows.Count > 0)
		{ return dt; }
		else { return null; }
	}

    public static DataTable ShouldSurgerySendToIPDPackage(string TransactionID, string PackageID, string SurgeryID, decimal Amount, int Qty,int IPDCaseTypeID, MySqlConnection con)
    {
        string str = "";

        str = "Select Categoryid from f_configRelation where ConfigID=22";

        string CategoryID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, str));
        // For CategoryWise packageType=1
        str = "SELECT IF(IsAmount=0," +
        "IF((IFNULL(ltd.Qty,0)+ " + Qty + ") <= IFNULL(pkd.Quantity,0),'true','false')," +
        "IF((IFNULL(ltd.Amount,0)+ " + Amount + ") <= IFNULL(pkd.Amount,0),'true','false'))iStatus, " +
        "ltd.PackageID,ltd.Surgery_ID,(IFNULL(ltd.Qty,0)+ 1)LtdCount,IFNULL(pkd.Quantity,0)PkdCount," +
        "(IFNULL(ltd.Amount,0)+ " + Amount + ")LtdAmt,IFNULL(pkd.Amount,0)PkdAmt FROM ( " +
        "       Select * from packagemasteripd_details where ItemID='" + PackageID + "' and RoomTypeID='" + IPDCaseTypeID + "'" +
        "       AND CategoryID='" + CategoryID + "' and IsActive=1 AND packageType=1) pkd LEFT JOIN (" +
        "       SELECT PackageID,Surgery_ID,COUNT(DISTINCT ltd.Surgery_ID)Qty,SUM(Rate*Quantity)Amount, " +
        "       sc.CategoryID FROM f_ledgertnxdetail ltd INNER JOIN " +
        "       f_subcategorymaster sc ON sc.SubCategoryID = ltd.SubCategoryID " +
        "       WHERE TransactionID='" + TransactionID + "' AND IsVerified=1 AND IsPackage=1 " +
        "       AND sc.CategoryID='" + CategoryID + "' AND PackageID='" + PackageID + "' and IPDCaseTypeID='" + IPDCaseTypeID + "' GROUP BY sc.CategoryID " +
        ")ltd  ON pkd.ItemID = ltd.PackageID AND ltd.CategoryID = pkd.CategoryID " +
            // For ItemWise packageType=2
        "Union All " +
        "SELECT IF(IsAmount=0," +
        "IF((IFNULL(ltd.Qty,0)+ " + Qty + ") <= IFNULL(pkd.Quantity,0),'true','false')," +
        "IF((IFNULL(ltd.Amount,0)+ " + Amount + ") <= IFNULL(pkd.Amount,0),'true','false'))iStatus, " +
        "ltd.PackageID,ltd.Surgery_ID,(IFNULL(ltd.Qty,0)+ 1)LtdCount,IFNULL(pkd.Quantity,0)PkdCount," +
        "(IFNULL(ltd.Amount,0)+ " + Amount + ")LtdAmt,IFNULL(pkd.Amount,0)PkdAmt FROM ( " +
        "       Select * from packagemasteripd_details where ItemID='" + PackageID + "' and RoomTypeID='" + IPDCaseTypeID + "'" +
        "       AND CategoryID='" + CategoryID + "' and IsActive=1 AND packageType=2 AND Detail_ItemID='" + SurgeryID + "') pkd LEFT JOIN (" +
        "       SELECT PackageID,Surgery_ID,COUNT(DISTINCT ltd.Surgery_ID)Qty,SUM(Rate*Quantity)Amount, " +
        "       sc.CategoryID FROM f_ledgertnxdetail ltd INNER JOIN " +
        "       f_subcategorymaster sc ON sc.SubCategoryID = ltd.SubCategoryID " +
        "       WHERE TransactionID='" + TransactionID + "' AND IsVerified=1 AND IsPackage=1 " +
        "       AND sc.CategoryID='" + CategoryID + "' and ltd.Surgery_ID='" + SurgeryID + "' AND PackageID='" + PackageID + "' and IPDCaseTypeID='" + IPDCaseTypeID + "' GROUP BY sc.CategoryID " +
        ")ltd  ON pkd.ItemID = ltd.PackageID AND ltd.Surgery_ID = pkd.detail_itemid ";

        DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, str).Tables[0];

        if (dt != null && dt.Rows.Count > 0)
        { return dt; }
        else { return null; }
    }
    public static string getTransactionIDbyTransNo(string TransNo)
    {
        string str = "SELECT transactionID FROM patient_medical_history WHERE TransNo ='" + TransNo + "' AND CentreID="+HttpContext.Current.Session["CentreID"]+"";
        return ExecuteScalar(str);
    }
    public static string getTransNobyTransactionID(string TransactionID)
    {
        string str = "SELECT TransNo FROM patient_medical_history WHERE TransactionID ='" + TransactionID + "'";
        return ExecuteScalar(str);
    }

}
