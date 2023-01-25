using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;

/// <summary>
/// Summary description for Dummy
/// </summary>
public class Dummy
{
    public Dummy()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public static DataTable GetIPD_Packages_Prescribed(string TransactionID)
    {
        string str = "SELECT ltd.ItemID PackageID FROM f_configrelation cf INNER JOIN f_subcategorymaster sc ON " +
                     "cf.CategoryID = sc.CategoryID INNER JOIN d_f_ledgertnxdetail ltd ON " +
                     "ltd.SubCategoryID = sc.SubCategoryID WHERE cf.ConfigID=14 " +
                     "AND  TransactionID='" + TransactionID + "' AND IsVerified=1 AND IsPackage=0";

        DataTable dt = StockReports.GetDataTable(str);

        return dt;
    }

    public static DataTable ShouldSendToIPDPackage(string TransactionID, string PackageID, string ItemID, decimal Amount, int Qty)
    {
        string str = "";

        str = "Select CategoryID from f_subCategorymaster where SubCategoryID=(" +
              "     Select SubCategoryID from F_itemmaster where ItemID='" + ItemID + "')";

        string CategoryID = StockReports.ExecuteScalar(str);

        str = "SELECT IF(IsAmount=0," +
        "IF((IFNULL(ltd.Qty,0)+ " + Qty + ") <= IFNULL(pkd.Quantity,0),'true','false')," +
        "IF((IFNULL(ltd.Amount,0)+ " + Amount + ") <= IFNULL(pkd.Amount,0),'true','false'))iStatus, " +
        "ltd.PackageID,ltd.ItemID,(IFNULL(ltd.Qty,0)+ 1)LtdCount,IFNULL(pkd.Quantity,0)PkdCount," +
        "(IFNULL(ltd.Amount,0)+ 100)LtdAmt,IFNULL(pkd.Amount,0)PkdAmt FROM ( " +
        "       Select * from packagemasteripd_details where ItemID='" + PackageID + "' " +
        "       AND CategoryID='" + CategoryID + "' and IsActive=1) pkd LEFT JOIN (" +
        "       SELECT PackageID,ItemID,COUNT(ItemID)Qty,SUM(Rate*Quantity)Amount, " +
        "       sc.CategoryID FROM d_f_ledgertnxdetail ltd INNER JOIN " +
        "       f_subcategorymaster sc ON sc.SubCategoryID = ltd.SubCategoryID " +
        "       WHERE TransactionID='" + TransactionID + "' AND IsVerified=1 AND IsPackage=1 " +
        "       AND sc.CategoryID='" + CategoryID + "' AND PackageID='" + PackageID + "' GROUP BY sc.CategoryID " +
        ")ltd  ON pkd.ItemID = ltd.PackageID AND ltd.CategoryID = pkd.CategoryID ";

        DataTable dt = StockReports.GetDataTable(str);

        if (dt != null && dt.Rows.Count > 0)
        { return dt; }
        else { return null; }
    }

    public static DataTable ShouldSendToIPDPackage(string TransactionID, string PackageID, string ItemID, decimal Amount, int Qty, MySqlTransaction tnx)
    {
        string str = "";

        str = "Select CategoryID from f_subCategorymaster where SubCategoryID=(" +
              "     Select SubCategoryID from F_itemmaster where ItemID='" + ItemID + "')";

        string CategoryID = StockReports.ExecuteScalar(str);

        str = "SELECT IF(IsAmount=0," +
        "IF((IFNULL(ltd.Qty,0)+ " + Qty + ") <= IFNULL(pkd.Quantity,0),'true','false')," +
        "IF((IFNULL(ltd.Amount,0)+ " + Amount + ") <= IFNULL(pkd.Amount,0),'true','false'))iStatus, " +
        "ltd.PackageID,ltd.ItemID,(IFNULL(ltd.Qty,0)+ 1)LtdCount,IFNULL(pkd.Quantity,0)PkdCount," +
        "(IFNULL(ltd.Amount,0)+ 100)LtdAmt,IFNULL(pkd.Amount,0)PkdAmt FROM ( " +
        "       Select * from packagemasteripd_details where ItemID='" + PackageID + "' " +
        "       AND CategoryID='" + CategoryID + "' and IsActive=1) pkd LEFT JOIN (" +
        "       SELECT PackageID,ItemID,COUNT(ItemID)Qty,SUM(Rate*Quantity)Amount, " +
        "       sc.CategoryID FROM d_f_ledgertnxdetail ltd INNER JOIN " +
        "       f_subcategorymaster sc ON sc.SubCategoryID = ltd.SubCategoryID " +
        "       WHERE TransactionID='" + TransactionID + "' AND IsVerified=1 AND IsPackage=1 " +
        "       AND sc.CategoryID='" + CategoryID + "' AND PackageID='" + PackageID + "' GROUP BY sc.CategoryID " +
        ")ltd  ON pkd.ItemID = ltd.PackageID AND ltd.CategoryID = pkd.CategoryID ";

        DataTable dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, str).Tables[0];

        if (dt != null && dt.Rows.Count > 0)
        { return dt; }
        else { return null; }
    }

    public static Boolean SentToIPDPackage(string TransactionID, string ItemID)
    {
        try
        {
            //Checking if same package is prescribed again
            DataTable dtPkg = GetIPD_Packages_Prescribed(TransactionID);

            if (dtPkg != null && dtPkg.Rows.Count > 0)
            {
                foreach (DataRow dr in dtPkg.Rows)
                {
                    if (dr["ItemID"].ToString() == ItemID)
                        return false;
                }
            }

            //Getting all already prescribed not packaged items to be if required sifted to given package
            DataTable dtLed = StockReports.GetDataTable("Select ItemID,Rate,Quantity,LedgerTnxID from d_LedgerTnxDetail where TransactionID='" + TransactionID + "' and Isverified=1 and IsPackage=0");

            if (dtLed != null && dtLed.Rows.Count > 0)
            {
                foreach (DataRow row in dtLed.Rows)
                {
                    decimal Rate = Util.GetDecimal(row["Rate"]);
                    int Qty = Util.GetInt(row["Quantity"]);
                   decimal Amount = Rate * Qty;

                    DataTable dt = ShouldSendToIPDPackage(TransactionID, ItemID, row["ItemID"].ToString(), Amount, Qty);

                    if (dt != null && dt.Rows.Count > 0)
                    {
                        if (Util.GetBoolean(dt.Rows[0]["iStatus"]))
                        {
                            string strQuery = "Update d_f_LedgerTnxDetail Set IsPackage=1,Amount=Rate*Quantity,";
                            strQuery += "Amount=0, PackageID='" + ItemID + "' Where LedgerTnxID='" + row["LedgerTnxID"].ToString() + "'";
                            StockReports.ExecuteDML(strQuery);
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

    public static DataTable GetBilledPatientDetail(string TrnxID)// Gaurav 17.06.2018
    {
        try
        {
            
            StringBuilder sb = new StringBuilder();

            //sb.Append("  SELECT LedgerTransactionNo,NetAmount,GrossAmount,DiscountOnTotal,EntryDate,Discount,BillNo,DiscountReason,PatientID,TransactionID,PanelID,TransactionTypeID,DATE ");
            //sb.Append("  FROM ( ");
            //sb.Append("      SELECT lt.LedgerTransactionNo,lt.NetAmount,lt.GrossAmount,IFNULL(lt.DiscountOnTotal,0)DiscountOnTotal,DATE_FORMAT(lt.Date,'%d-%b-%Y')EntryDate, ");
            //sb.Append("      IFNULL(((lt.DiscountOnTotal/lt.GrossAmount) * 100),0) AS Discount,IFNULL(adj.BillNo,'')BillNo,lt.DiscountReason,lt.PatientID,lt.TransactionID,lt.PanelID, ");
            //sb.Append("      lt.TransactionTypeID,DATE_FORMAT(lt.Date,'%d-%b-%Y')DATE FROM d_f_ledgertransaction lt  ");
            //sb.Append("      INNER JOIN d_f_ipdadjustment adj ON lt.TransactionID = adj.TransactionID  ");
            //sb.Append("      WHERE lt.TransactionID ='"+TrnxID+"' ");
            //sb.Append("      UNION ALL ");
            //sb.Append("      SELECT lt.LedgerTransactionNo,lt.NetAmount,lt.GrossAmount,IFNULL(lt.DiscountOnTotal,0)DiscountOnTotal,DATE_FORMAT(lt.Date,'%d-%b-%Y')EntryDate, ");
            //sb.Append("      IFNULL(((lt.DiscountOnTotal/lt.GrossAmount) * 100),0) AS Discount,lt.BillNo,lt.DiscountReason,lt.PatientID,lt.IPNo,lt.PanelID, ");
            //sb.Append("      lt.TransactionTypeID,DATE_FORMAT(lt.Date,'%d-%b-%Y')DATE FROM d_f_ledgertransaction lt  ");
            //sb.Append("      INNER JOIN d_f_ledgertnxdetail ltd ON lt.TransactionID = ltd.TransactionID  ");
            //sb.Append("      WHERE lt.IPNo ='"+TrnxID+"' ");
            //sb.Append("  )t ORDER BY LedgerTransactionNo ");

            sb.Append(" call GetBilledPatientDetail('" + TrnxID + "',1 ");

            return StockReports.GetDataTable(sb.ToString());
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }

    public static DataTable GetBilledPatientItemDetail(string TrnxID)// Gaurav 17.06.2018
    {
        try
        {
 //           string sql = "SELECT LedgerTransactionNo,Amount,T1.ItemID,Rate,Quantity,StockID,DiscountPercentage,"
 //           + "IsPackage,PackageID,IsVerified,t1.SubCategoryID,VarifiedUserID,"
 //           + " /*ItemName,*/"

 //              + "  (CASE WHEN im.type_ID='S' THEN CONCAT(ItemName,'(Dr. ', (SELECT dm.`Name` FROM f_surgery_discription sdr "
 //   + " INNER JOIN `f_itemmaster` itm ON sdr.ItemID=itm.ItemID AND itm.Type_ID IN ('S')  "
 // + "INNER JOIN f_surgery_DOctor sd ON sd.SurgeryTransactionID=sdr.SurgeryTransactionID   "
 //+ "INNER JOIN `doctor_master` dm ON dm.`DoctorID`=sd.`DoctorID`  "
 //  + "WHERE sdr.LedgerTransactionNo=t1.LedgerTransactionNo AND sdr.`ItemID`=t1.itemid), ')')  "

 //+ "WHEN im.type_ID='D' THEN CONCAT(ItemName,'(Dr. ', (SELECT dm.`Name` FROM f_surgery_discription sdr  "
 //   + " INNER JOIN `f_itemmaster` itm ON sdr.ItemID=itm.ItemID AND itm.Type_ID IN ('D') "
 // + "INNER JOIN f_surgery_DOctor sd ON sd.SurgeryTransactionID=sdr.SurgeryTransactionID   "
 //+ "INNER JOIN `doctor_master` dm ON dm.`DoctorID`=sd.`DoctorID`  "
 //  + "WHERE sdr.LedgerTransactionNo=t1.LedgerTransactionNo AND sdr.`ItemID`=t1.itemid), ')')  "
 //+ "ELSE itemname "
 // + "END )itemname, "

 //           + "TransactionID,VerifiedDate,UserID,EntryDate,DiscountAmount,LTDetailID,SubCategory,"
 //           + "if(t1.IsDischargeMedicine=1,'DISCHARGE MEDICINE & CONSUMABLES',IF(t1.DeptLedgerNo IN(" + Resources.Resource.OTDeptLedgerNo + "),(SELECT IFNULL(sc.DisplayName,sc.Name) FROM f_subcategorymaster sc INNER JOIN f_configrelation c ON c.CategoryID=SC.CategoryID WHERE sc.Active=1 AND c.ConfigID=22 LIMIT 1),DisplayName))DisplayName,if(t1.IsDischargeMedicine=1,2000,if(t1.DeptLedgerNo IN(" + Resources.Resource.OTDeptLedgerNo + "),(SELECT sc.DisplayPriority FROM f_subcategorymaster sc INNER JOIN f_configrelation c ON c.CategoryID=SC.CategoryID WHERE sc.Active=1 AND c.ConfigID=22 LIMIT 1),DisplayPriority))DisplayPriority,t1.IsSurgery,t1.Surgery_ID,t1.SurgeryName,"
 //           + "t1.DiscountReason,t1.UserName,IF(t1.Type_ID='',im.Type_ID,t1.Type_ID)Type_ID,im.ServiceItemID,(Rate*Quantity)GrossAmt,"
 //           + "IFNULL(dm.Specialization,'')Specialization,t1.IsPayable,t1.DeptLedgerNo FROM ("
 //           + "        SELECT LTD.IsDischargeMedicine,ltd.DeptLedgerNo,LTD.LedgerTransactionNo,LTD.Amount,LTD.ItemID,LTD.Rate,LTD.Quantity,LTD.StockID,"
 //           + "        LTD.DiscountPercentage,LTD.IsPackage,LTD.PackageID,LTD.IsVerified,LTD.SubCategoryID,"
 //           + "        LTD.VarifiedUserID,LTD.ItemName,LTD.TransactionID,DATE_FORMAT(LTD.EntryDate,'%d-%b-%Y')EntryDate,"
 //           + "        DATE_FORMAT(LTD.VerifiedDate,'%d-%b-%Y')VerifiedDate,LTD.UserID,"
 //           + "        (((Rate * Quantity)*DiscountPercentage)/100) DiscountAmount,IFNULL(ltd.Type_ID,'')Type_ID,"
 //           + "        LTD.LedgerTnxID AS LTDetailID,SC.Name AS SubCategory,SC.DisplayName,LTD.IsSurgery,"
 //           + "        SC.DisplayPriority,LTD.Surgery_ID,LTD.SurgeryName,LTD.DiscountReason,EM.Name AS UserName,LTD.IsPayable "
 //           + "        FROM d_f_ledgertnxdetail LTD INNER JOIN d_f_ledgertransaction LT "
 //           + "        ON LT.LedgerTransactionNo = LTD.LedgerTransactionNo INNER JOIN f_subcategorymaster SC "
 //           + "        ON SC.SubcategoryID = LTD.SubcategoryID INNER JOIN employee_master EM "
 //           + "        ON EM.Employee_ID = LTD.UserID WHERE LT.TransactionID = '" + TrnxID + "'  "
 //           + "        AND LTD.Isverified =1 "
 //           //+ "          UNION ALL "
 //           //+ "          SELECT ltd.DeptLedgerNo,LTD.LedgerTransactionNo,LTD.Amount,LTD.ItemID,LTD.Rate,LTD.Quantity,LTD.StockID,LTD.DiscountPercentage,LTD.IsPackage,LTD.PackageID,LTD.IsVerified, "
 //           //+ "          LTD.SubCategoryID,LTD.VarifiedUserID,LTD.ItemName,LTD.TransactionID,DATE_FORMAT(LTD.EntryDate,'%d-%b-%Y')EntryDate, "
 //           //+ "          DATE_FORMAT(LTD.VerifiedDate,'%d-%b-%Y')VerifiedDate,LTD.UserID,(((Rate * Quantity)*DiscountPercentage)/100) DiscountAmount, "
 //           //+ "          IFNULL(ltd.Type_ID,'')Type_ID,LTD.LedgerTnxID AS LTDetailID,SC.Name AS SubCategory,'OPD' DisplayName,LTD.IsSurgery, "
 //           //+ "          SC.DisplayPriority,LTD.Surgery_ID,LTD.SurgeryName,LTD.DiscountReason,EM.Name AS UserName,LTD.IsPayable   FROM d_f_ledgertransaction lt "
 //           //+ "          INNER JOIN d_f_ledgertnxdetail ltd ON LT.LedgerTransactionNo = LTD.LedgerTransactionNo "
 //           //+ "          INNER JOIN f_subcategorymaster SC ON SC.SubcategoryID = LTD.SubcategoryID INNER JOIN employee_master EM ON EM.Employee_ID = LTD.UserID "
 //           //+ "          WHERE lt.IsCancel=0 AND lt.`IsIPDMerged`=1   AND IPNo='" + TrnxID + "'  "

 //           + ")t1 LEFT JOIN f_itemmaster im ON im.itemid = t1.ItemID LEFT JOIN doctor_master dm "
 //           + "ON dm.DoctorID=im.Type_ID ORDER BY t1.DisplayName, t1.SubCategoryID,t1.ItemID,DATE(t1.EntryDate) ";


            string sql = " CALL GetBillPatientItemdetail('" + TrnxID + "'," + Resources.Resource.OTDeptLedgerNo + ",1)";
            return StockReports.GetDataTable(sql);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }

    public static DataTable GetPatientPackageDetail(string TrnxID)
    {
        try
        {
           // string sql = "Select ItemName,ItemID,sum(amount)SurTotal,LedgerTransactionNo from d_f_ledgertnxdetail Where TransactionID='" + TrnxID + "' and SubCategoryID in (Select Subcategoryid from f_subcategorymaster Where Categoryid in (Select CategoryID from f_configrelation Where ConfigID=14)) and IsVerified=1  group by itemID";
            string sql = "call GetPatientPackageDetail('" + TrnxID + "',1)";
            return StockReports.GetDataTable(sql);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }

    public static bool PostBillForDummy(string TID, MySqlTransaction trnx)
    {
        try
        {
            MySqlHelper.ExecuteNonQuery(trnx, CommandType.Text, "CALL PostBillForFinalised('" + TID + "','" + HttpContext.Current.Session["ID"].ToString() + "')");
            return true;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return false;
        }
    }
}
