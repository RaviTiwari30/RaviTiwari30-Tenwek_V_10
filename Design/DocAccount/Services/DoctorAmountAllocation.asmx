<%@ WebService Language="C#" Class="DoctorAmountAllocation" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Text;
using System.Data;
using System.Linq;
using System.Collections.Generic;
using MySql.Data.MySqlClient;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class DoctorAmountAllocation : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }


    [WebMethod]
    public string SearchPatient(string patientID, string transactionID, string patientName, string billNo, string panelID)
    {

        StringBuilder sqlCMD = new StringBuilder();

        sqlCMD.Append(" SELECT pm.PatientID, CONCAT(pm.title, ' ', pm.pname) pname,REPLACE(pip.TransactionID, 'ISHHI', '') TransactionID,pnl.company_name,IFNULL(ipd.BillNo, '') BillNo,CONCAT(pm.House_No,' ',pm.Locality,' ',pm.City) Address,pip.TransactionID transactionID,pmh.Type,Round(IFNULL((GETIPDBillAmount(pip.TransactionID)),0),2)  BillAmount, (SELECT COUNT(*) FROM  f_paymentallocation p WHERE p.TransactionID=pmh.TransactionID  AND p.AgainstReceiptNo='' AND IsActive=1 )IsAutoAllocation ");
        sqlCMD.Append(" FROM patient_ipd_profile pip INNER JOIN patient_medical_history pmh ON pip.TransactionID=pmh.TransactionID ");
        sqlCMD.Append(" INNER JOIN f_ipdadjustment ipd ON pmh.TransactionID=ipd.TransactionID INNER JOIN patient_master pm  ");
        sqlCMD.Append(" ON pm.PatientID = pip.PatientID INNER JOIN room_master rm  ");
        sqlCMD.Append(" ON rm.Room_Id  = pip.Room_ID INNER JOIN f_panel_master pnl   ");
        sqlCMD.Append(" ON pnl.PanelID  = ipd.PanelID INNER JOIN  ");
        sqlCMD.Append(" (SELECT MAX(PatientIPDProfile_ID)PatientIPDProfile_ID  ");
        sqlCMD.Append(" FROM patient_ipd_profile   WHERE STATUS<>'Cancel'  ");

        if (!string.IsNullOrEmpty(patientID))
            sqlCMD.Append(" and PatientID=@patientID ");


        if (!string.IsNullOrEmpty(transactionID))
            sqlCMD.Append(" and TransactionID=@transactionID");


        sqlCMD.Append(" group by TransactionID) pip1 ");
        sqlCMD.Append(" on pip1.PatientIPDProfile_ID = pip.PatientIPDProfile_ID ");

        sqlCMD.Append(" Where IFNULL(ipd.BillNo,'')<>''  ");


        if (!string.IsNullOrEmpty(patientID))
            sqlCMD.Append(" AND PatientID=@patientID ");


        if (!string.IsNullOrEmpty(patientName))
            sqlCMD.Append(" AND pm.PName like @patientName ");


        if (!string.IsNullOrEmpty(billNo))
            sqlCMD.Append(" AND ipd.BillNo=@billNo");

        if (panelID != "0")
            sqlCMD.Append(" AND pmh.PanelID =@panelID ");
			
			
	    sqlCMD.Append(" HAVING IsAutoAllocation=0");		

        if (string.IsNullOrEmpty(transactionID))
        {

            sqlCMD.Append(" Union All ");

            sqlCMD.Append(" SELECT pm.PatientID, CONCAT(pm.Title,' ',pm.PName) pname,'' TransactionID,p.company_name,lt.BillNo,CONCAT(pm.House_No,' ',pm.Locality,' ',pm.City) Address,lt.TransactionID transactionID,pmh.Type,Round(lt.NetAmount,2) BillAmount, (SELECT COUNT(*) FROM  f_paymentallocation p WHERE p.TransactionID=pmh.TransactionID  AND p.AgainstReceiptNo='')IsAutoAllocation ");
            sqlCMD.Append(" FROM f_ledgertransaction lt  ");
            sqlCMD.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID ");
            sqlCMD.Append(" INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID ");
            sqlCMD.Append(" INNER JOIN f_panel_master p ON p.PanelID=pmh.PanelID ");
            sqlCMD.Append(" WHERE pmh.Type='OPD' and IFNULL(lt.BillNo,'')<>'' AND IF((SELECT COUNT(*) FROM  f_paymentallocation p WHERE p.TransactionID=lt.TransactionID  AND p.AgainstReceiptNo<>'')>0,1=1,ROUND(lt.adjustment, 2) <> ROUND(lt.NetAmount, 2)) and pm.PatientID<>'CASH002' ");

            if (!string.IsNullOrEmpty(patientID))
                sqlCMD.Append(" AND pm.PatientID=@patientID ");


            if (!string.IsNullOrEmpty(patientName))
                sqlCMD.Append(" AND pm.PName like @patientName ");


            if (!string.IsNullOrEmpty(billNo))
                sqlCMD.Append(" AND lt.BillNo=@billNo" );

            if (panelID != "0")
                sqlCMD.Append(" AND pmh.PanelID =@panelID ");

            sqlCMD.Append(" Union All ");

            sqlCMD.Append(" SELECT pm.PatientID, CONCAT(pm.Title,' ',pm.PName) pname,'' TransactionID,p.company_name,lt.BillNo,CONCAT(pm.House_No,' ',pm.Locality,' ',pm.City) Address,lt.TransactionID transactionID,pmh.Type,Round(lt.NetAmount,2) BillAmount, (SELECT COUNT(*) FROM  f_paymentallocation p WHERE p.TransactionID=pmh.TransactionID  AND p.AgainstReceiptNo='')IsAutoAllocation ");
            sqlCMD.Append(" FROM f_ledgertransaction lt  ");
            sqlCMD.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID ");
            sqlCMD.Append(" INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID ");
            sqlCMD.Append(" INNER JOIN f_panel_master p ON p.PanelID=pmh.PanelID ");
            sqlCMD.Append(" WHERE pmh.Type='EMG' and IFNULL(lt.BillNo,'')<>''  AND IF((SELECT COUNT(*) FROM  f_paymentallocation p WHERE p.TransactionID=lt.TransactionID  AND p.AgainstReceiptNo<>'')>0,1=1,ROUND(lt.adjustment, 2) <> ROUND(lt.NetAmount, 2)) and pm.PatientID<>'CASH002'  ");

            if (!string.IsNullOrEmpty(patientID))
                sqlCMD.Append(" AND pm.PatientID=@patientID ");


            if (!string.IsNullOrEmpty(patientName))
                sqlCMD.Append(" AND pm.PName like @patientName ");


            if (!string.IsNullOrEmpty(billNo))
                sqlCMD.Append(" AND lt.BillNo=@billNo");

            if (panelID != "0")
                sqlCMD.Append(" AND pmh.PanelID =@panelID ");

        }

        ExcuteCMD excuteCMD = new ExcuteCMD();


        var s = excuteCMD.GetRowQuery(sqlCMD.ToString(), new
        {
            patientID = patientID,
            patientName = "%" + patientName + "%",
            transactionID = "ISHHI" + transactionID,
            billNo = billNo,
            panelID = panelID
        });


		//System.IO.File.WriteAllText (@"F:\niraj.txt", s.ToString());


        var dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
        {
            patientID = patientID,
            patientName = "%" + patientName + "%",
            transactionID = "ISHHI" + transactionID,
            billNo = billNo,
            panelID = panelID
        });

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


    [WebMethod]
    public string getPaymentDetails(string transactionID)
    {

        StringBuilder sqlCMD = new StringBuilder(" SELECT t.*,ROUND(AmountPaid-PreAllocatedAmount,2)MaxAllocation FROM  (SELECT rp.PaymentModeID,rp.PaymentMode,r.TransactionID,R.ReceiptNo,rp.TDS,rp.WriteOff,DATE_FORMAT(R.Date,'%d-%b-%Y')ReceiptDate,ROUND(rp.Amount,2)AmountPaid,	ROUND(IFNULL((SELECT SUM(pa.AllocatedAmt+pa.Hosp_AllocatedAmt+pa.WriteOff+pa.Hosp_WriteOff) 	FROM f_paymentallocation pa 	WHERE pa.AgainstReceiptNo=R.ReceiptNo AND pa.IsActive=1 AND pa.IsVerified=1 AND pa.PaymentModeID=rp.PaymentModeID ),0),2)PreAllocatedAmount,	ROUND(IFNULL((SELECT SUM(pa.AllocatedAmt+pa.Hosp_AllocatedAmt+pa.WriteOff+pa.Hosp_WriteOff) FROM f_paymentallocation pa WHERE pa.AgainstReceiptNo = R.ReceiptNo AND pa.IsActive = 1 AND pa.IsVerified=0 AND pa.PaymentModeID=rp.PaymentModeID ),0),2) UnApprovedPreAllocatedAmount,IF(rp.PaymentModeID=3,1,0)isCreditCardIssue,IF(rp.PaymentModeID=3,rp.BankCutPercentage,0)BankCutPercentage FROM f_reciept r INNER JOIN f_receipt_paymentdetail rp ON rp.ReceiptNo=r.ReceiptNo WHERE r.TransactionID=@transactionID AND R.IsCancel=0 AND R.AmountPaid>0 ORDER BY DATE )t ");
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var s = excuteCMD.GetRowQuery(sqlCMD.ToString(), new
        {
            transactionID = transactionID
        });

        var dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
        {
            transactionID = transactionID
        });

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


    [WebMethod]
    public string GetPanelAllocation(string transactionID)
    {

        ExcuteCMD excuteCMD = new ExcuteCMD();
        var dataTable = excuteCMD.GetDataTable("CALL Get_IPDPanelWriteOffDetails(@transactionID)", CommandType.Text, new
        {
            transactionID = transactionID
        });

        return Newtonsoft.Json.JsonConvert.SerializeObject(dataTable);
    }



    [WebMethod]
    public string GetAllocationDetailsItemWise(string transactionID, string receiptNo, int paymentModeID)
    {

        DataTable dt;
        string aa;
        GetItemWiseDetails(transactionID, receiptNo, paymentModeID, out dt, out aa);

        


        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }

    private static void GetItemWiseDetails(string transactionID, string receiptNo, int paymentModeID, out DataTable dt, out string aa)
    {
        ExcuteCMD excuteCMD = new ExcuteCMD();

        StringBuilder sqlCMD = new StringBuilder();


        /* sqlCMD.Append(" SELECT @receiptNo receiptNo,@paymentModeID paymentModeID, ltd.TransactionID transactionID, GROUP_CONCAT(ltd.ID)ledgerTnxID ,IF((c.ConfigID=1),CONCAT(ltd.ItemName,'(',sc.Name,')'),ltd.ItemName)itemName,ltd.itemID,SUM(ltd.Quantity) quantity,SUM(ltd.Amount)amount, ");
         sqlCMD.Append(" SUM(s.DoctorShareAmt)doctorShareAmount, ");
         sqlCMD.Append(" (SELECT  IFNULL(SUM(p.AllocatedAmt),0)  FROM f_paymentallocation p WHERE p.TransactionID=@transactionID AND p.itemID=ltd.ItemID AND p.IsActive=1 AND p.IsVerified=1 ) approvedAllocatedAmount, ");
         sqlCMD.Append(" (SELECT  IFNULL(SUM(p.AllocatedAmt),0)  FROM f_paymentallocation p WHERE p.TransactionID=@transactionID AND p.itemID=ltd.ItemID AND  p.IsActive=1 AND p.IsVerified=0  AND  p.AgainstReceiptNo <> @receiptNo AND p.PaymentModeID<>@paymentModeID ) unApprovedAllocatedAmount, ");
         sqlCMD.Append(" (SELECT  IFNULL(SUM(p.AllocatedAmt),0)  FROM f_paymentallocation p WHERE p.TransactionID=@transactionID AND p.itemID=ltd.ItemID AND p.IsActive=1 AND p.IsVerified=0  AND  p.AgainstReceiptNo =  @receiptNo AND p.PaymentModeID=@paymentModeID  ) allocatedAmount,");
         sqlCMD.Append(" (SELECT  IFNULL(SUM(p.WriteOff),0)  FROM f_paymentallocation p WHERE p.TransactionID=@transactionID AND p.itemID=ltd.ItemID AND p.IsActive=1 AND p.IsVerified=1 ) approvedwriteOffAmount,");
         sqlCMD.Append(" (SELECT  IFNULL(SUM(p.WriteOff),0)      FROM f_paymentallocation p WHERE p.TransactionID=@transactionID AND p.itemID=ltd.ItemID AND p.IsActive=1 AND p.IsVerified=0  AND  p.AgainstReceiptNo <> @receiptNo AND p.PaymentModeID<>@paymentModeID ) unApprovedwriteOffAmount,");
         sqlCMD.Append(" (SELECT  IFNULL(SUM(p.WriteOff),0)      FROM f_paymentallocation p WHERE p.TransactionID=@transactionID AND p.itemID=ltd.ItemID AND p.IsActive=1 AND p.IsVerified=0  AND  p.AgainstReceiptNo =  @receiptNo AND p.PaymentModeID=@paymentModeID  ) writeOffAmount, ");
         sqlCMD.Append(" IFNULL((SELECT  (p.WriteOff_Reason)  FROM f_paymentallocation p WHERE p.TransactionID=@transactionID AND p.itemID=ltd.ItemID AND p.IsActive=1 AND p.IsVerified=0  AND  p.AgainstReceiptNo =  @receiptNo AND p.PaymentModeID=@paymentModeID limit 1  ),'') writeOffReason, ");
         sqlCMD.Append(" IFNULL((SELECT  (p.BankCut)  FROM f_paymentallocation p WHERE p.TransactionID=@transactionID AND p.itemID=ltd.ItemID AND p.IsActive=1 AND p.IsVerified=0  AND  p.AgainstReceiptNo =  @receiptNo AND p.PaymentModeID=@paymentModeID limit 1  ),0) bankCut ");        
         sqlCMD.Append(" FROM  f_DocShare_TransactionDetail s  ");
         sqlCMD.Append(" INNER JOIN  f_ledgertnxdetail ltd ON ltd.ID=s.LedgerTnxID ");

         sqlCMD.Append(" INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=ltd.SubCategoryID ");
         sqlCMD.Append(" INNER JOIN f_configrelation c ON c.CategoryID=sc.CategoryID ");

         sqlCMD.Append(" WHERE s.TransactionID=@transactionID AND s.IsActive=1 AND s.DoctorShareAmt <> 0 GROUP BY ltd.ItemID  ");*/

        sqlCMD.Append("SELECT @receiptNo receiptNo,@paymentModeID paymentModeID,transactionID,GROUP_CONCAT(ledgerTnxID)ledgerTnxID,itemName,itemID,Round(SUM(quantity),2)quantity,Round(SUM(amount),2)amount,Round(SUM(doctorShareAmount),2)doctorShareAmount, ");
        sqlCMD.Append("Round((SELECT  IFNULL(SUM(p.AllocatedAmt),0)  FROM f_paymentallocation p WHERE p.TransactionID=t.transactionID AND p.itemID=t.ItemID AND  p.LedgerTnxId=t.ledgerTnxID AND p.IsActive=1 AND p.IsVerified=1 ),2) approvedAllocatedAmount,  ");
        sqlCMD.Append("Round((SELECT  IFNULL(SUM(p.AllocatedAmt),0)  FROM f_paymentallocation p WHERE p.TransactionID=t.transactionID AND p.itemID=t.ItemID AND p.LedgerTnxId=t.ledgerTnxID AND   p.IsActive=1 AND p.IsVerified=0  AND ( p.AgainstReceiptNo <>@receiptNo OR p.PaymentModeID<>@paymentModeID) ),2) unApprovedAllocatedAmount,  ");
        sqlCMD.Append("Round((SELECT  IFNULL(SUM(p.AllocatedAmt),0)  FROM f_paymentallocation p WHERE p.TransactionID=t.transactionID AND p.itemID=t.ItemID AND p.LedgerTnxId=t.ledgerTnxID AND p.IsActive=1 AND p.IsVerified=0  AND  p.AgainstReceiptNo =  @receiptNo AND p.PaymentModeID=@paymentModeID  ),2) allocatedAmount, ");
        sqlCMD.Append("Round((SELECT  IFNULL(SUM(p.WriteOff),0)  FROM f_paymentallocation p WHERE p.TransactionID=t.transactionID AND p.itemID=t.ItemID  AND p.LedgerTnxId=t.ledgerTnxID AND p.IsActive=1 AND p.IsVerified=1 ),2) approvedwriteOffAmount, ");
        sqlCMD.Append("Round((SELECT  IFNULL(SUM(p.WriteOff),0)      FROM f_paymentallocation p WHERE p.TransactionID=t.transactionID AND p.itemID=t.ItemID  AND p.LedgerTnxId=t.ledgerTnxID AND p.IsActive=1 AND p.IsVerified=0  AND ( p.AgainstReceiptNo <> @receiptNo OR p.PaymentModeID<>@paymentModeID )),2) unApprovedwriteOffAmount, ");
        sqlCMD.Append("Round((SELECT  IFNULL(SUM(p.WriteOff),0)      FROM f_paymentallocation p WHERE p.TransactionID=t.transactionID AND p.itemID=t.ItemID  AND p.LedgerTnxId=t.ledgerTnxID AND p.IsActive=1 AND p.IsVerified=0  AND  p.AgainstReceiptNo =  @receiptNo AND p.PaymentModeID=@paymentModeID  ),2) writeOffAmount,  ");
        sqlCMD.Append("IFNULL((SELECT  (p.WriteOff_Reason)  FROM f_paymentallocation p WHERE p.TransactionID=t.transactionID AND p.itemID=t.ItemID  AND p.LedgerTnxId=t.ledgerTnxID AND p.IsActive=1 AND p.IsVerified=0  AND  p.AgainstReceiptNo = @receiptNo AND p.PaymentModeID=@paymentModeID LIMIT 1  ),'') writeOffReason,  ");
        sqlCMD.Append("Round(IFNULL((SELECT  (p.BankCut)  FROM f_paymentallocation p WHERE p.TransactionID=t.transactionID AND p.itemID=t.ItemID  AND p.LedgerTnxId=t.ledgerTnxID AND p.IsActive=1 AND p.IsVerified=0  AND  p.AgainstReceiptNo = @receiptNo AND p.PaymentModeID=6 LIMIT 1  ),0),2) bankCut,DoctorName          ");
        sqlCMD.Append("FROM  ");
        sqlCMD.Append("(SELECT ltd.TransactionID transactionID, ltd.ID ledgerTnxID ,IF((c.ConfigID=1),CONCAT(ltd.ItemName,'(',sc.Name,')'),ltd.ItemName)itemName,ltd.ItemID,SUM(ltd.Quantity) quantity,");
        sqlCMD.Append(" SUM(IF(ltd.IsPackage=1,ltd.GrossAmount,ltd.Amount)+IFNULL(((SELECT Sum(ltdt.amount) FROM f_ledgertnxdetail ltdt  WHERE ltdt.TypeOfTnx IN ('CR', 'DR') AND ltdt.IsVerified=1 AND ltdt.LedgerTnxRefID <> - 1 AND ltdt.LedgerTnxRefID = ltd.ID)),0)) amount, ");

        sqlCMD.Append("IFNULL(SUM(s.DoctorShareAmt + ");
        sqlCMD.Append("IFNULL(((SELECT SUM(dst.DoctorShareAmt) FROM f_DocShare_TransactionDetail dst  ");
        sqlCMD.Append("INNER JOIN f_ledgertnxdetail ltdt ON ltdt.ID=dst.LedgerTnxID WHERE ltdt.TypeOfTnx IN ('CR','DR') ");
        sqlCMD.Append("AND dst.DoctorShareAmt<>0 AND ltdt.IsVerified=1 AND ltdt.LedgerTnxRefID<>-1 ");
        sqlCMD.Append("AND ltdt.LedgerTnxRefID=ltd.ID)),0) ");
        sqlCMD.Append("),0)doctorShareAmount,CONCAT(dm.Title,'',dm.Name)DoctorName,s.DoctorID ");
        sqlCMD.Append("FROM  f_DocShare_TransactionDetail s   ");
        sqlCMD.Append("INNER JOIN  f_ledgertnxdetail ltd ON ltd.ID=s.LedgerTnxID  ");
        sqlCMD.Append("INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=ltd.SubCategoryID  ");
        sqlCMD.Append("INNER JOIN f_configrelation c ON c.CategoryID=sc.CategoryID  ");
        sqlCMD.Append("INNER JOIN doctor_master dm ON dm.DoctorID=s.DoctorID ");
        sqlCMD.Append("WHERE s.TransactionID=@transactionID  ");
        sqlCMD.Append("AND ltd.TypeOfTnx NOT IN ('CR','DR')  ");
        sqlCMD.Append("AND s.IsActive=1 AND s.DoctorShareAmt <> 0 AND s.ShareCalculatedOn<>1 GROUP BY ltd.ID ");
        sqlCMD.Append(")t WHERE t.doctorShareAmount>0 GROUP BY t.ledgerTnxID ");

        aa = excuteCMD.GetRowQuery(sqlCMD.ToString(), new
        {
            transactionID = transactionID,
            receiptNo = receiptNo,
            paymentModeID = paymentModeID

        });
	  // System.IO.File.WriteAllText (@"F:\doctorAllocation.txt", aa.ToString());
        
        dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
        {
            transactionID = transactionID,
            receiptNo = receiptNo,
            paymentModeID = paymentModeID

        });

     

      
    }





    private static List<allocationDetail> GetLTDIDWiseDetails(string ledgerTnxID, string writeOffReason, string bankCut, string itemID, string transactionID, string receiptNo, string paymentModeID, out string aa)
    {
        ExcuteCMD excuteCMD = new ExcuteCMD();

        StringBuilder sqlCMD = new StringBuilder();


        //  sqlCMD.Append(" SELECT ltd.TransactionID transactionID, GROUP_CONCAT(ltd.ID)ledgerTnxID, IF((c.ConfigID=1),CONCAT(ltd.ItemName,'(',sc.Name,')'),ltd.ItemName)itemName,ltd.itemID,SUM(ltd.Quantity) quantity,SUM(ltd.Amount)amount, ");
        sqlCMD.Append(" SELECT @writeOffReason writeOffReason, @bankCut bankCut, @receiptNo receiptNo,@paymentModeID paymentModeID, ltd.TransactionID transactionID, GROUP_CONCAT(ltd.ID)ledgerTnxID ,IF((c.ConfigID=1),CONCAT(ltd.ItemName,'(',sc.Name,')'),ltd.ItemName)itemName,ltd.itemID,Round(SUM(ltd.Quantity),2) quantity, "); //SUM(ltd.Amount)amount,
        sqlCMD.Append(" Round(SUM(IF(ltd.IsPackage=1,ltd.GrossAmount,ltd.Amount)+IFNULL(((SELECT ltdt.amount FROM f_ledgertnxdetail ltdt  WHERE ltdt.TypeOfTnx IN ('CR', 'DR') AND ltdt.LedgerTnxRefID <> - 1  AND ltdt.IsVerified=1 AND ltdt.LedgerTnxRefID = ltd.ID)),0)),2) amount, ");
        //sqlCMD.Append(" SUM(s.DoctorShareAmt)doctorShareAmount, ");

        sqlCMD.Append(" Round(IFNULL(SUM(s.DoctorShareAmt + IFNULL(((SELECT SUM(dst.DoctorShareAmt) FROM f_DocShare_TransactionDetail dst INNER JOIN f_ledgertnxdetail ltdt ON ltdt.ID = dst.LedgerTnxID WHERE ltdt.TypeOfTnx IN ('CR', 'DR')AND dst.DoctorShareAmt <> 0 AND ltdt.LedgerTnxRefID <> - 1 AND ltdt.IsVerified=1 AND ltdt.LedgerTnxRefID = ltd.ID)),0)),0),2) doctorShareAmount ,");
        sqlCMD.Append(" Round((SELECT  IFNULL(SUM(p.AllocatedAmt),0)  FROM f_paymentallocation p WHERE p.TransactionID=@transactionID AND p.itemID=ltd.ItemID AND p.IsActive=1 AND p.IsVerified=1 ),2) approvedAllocatedAmount, ");
        sqlCMD.Append(" Round((SELECT  IFNULL(SUM(p.AllocatedAmt),0)  FROM f_paymentallocation p WHERE p.TransactionID=@transactionID AND p.itemID=ltd.ItemID AND p.IsActive=1 AND p.IsVerified=0  AND ( p.AgainstReceiptNo <> @receiptNo OR p.PaymentModeID<>@paymentModeID ) ),2) unApprovedAllocatedAmount, ");
        sqlCMD.Append(" Round((SELECT  IFNULL(SUM(p.AllocatedAmt),0)  FROM f_paymentallocation p WHERE p.TransactionID=@transactionID AND p.itemID=ltd.ItemID AND  p.IsActive=1 AND p.IsVerified=0  AND  p.AgainstReceiptNo =  @receiptNo AND p.PaymentModeID=@paymentModeID  ),2) allocatedAmount,");
        sqlCMD.Append(" Round((SELECT  IFNULL(SUM(p.WriteOff),0)  FROM f_paymentallocation p WHERE p.TransactionID=@transactionID AND p.itemID=ltd.ItemID AND p.IsActive=1 AND p.IsVerified=1 ),2) approvedwriteOffAmount,");
        sqlCMD.Append(" Round((SELECT  IFNULL(SUM(p.WriteOff),0)      FROM f_paymentallocation p WHERE p.TransactionID=@transactionID AND p.itemID=ltd.ItemID AND p.IsActive=1 AND p.IsVerified=0  AND ( p.AgainstReceiptNo <> @receiptNo OR p.PaymentModeID<>@paymentModeID ) ),2) unApprovedwriteOffAmount,");
        sqlCMD.Append(" Round((SELECT  IFNULL(SUM(p.WriteOff),0)      FROM f_paymentallocation p WHERE p.TransactionID=@transactionID AND p.itemID=ltd.ItemID AND p.IsActive=1 AND p.IsVerified=0  AND  p.AgainstReceiptNo =  @receiptNo AND p.PaymentModeID=@paymentModeID  ),2) writeOffAmount ");


        sqlCMD.Append(" FROM  f_DocShare_TransactionDetail s  ");
        sqlCMD.Append(" INNER JOIN  f_ledgertnxdetail ltd ON ltd.ID=s.LedgerTnxID ");

        sqlCMD.Append(" INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=ltd.SubCategoryID ");
        sqlCMD.Append(" INNER JOIN f_configrelation c ON c.CategoryID=sc.CategoryID ");

        sqlCMD.Append(" WHERE s.TransactionID=@transactionID AND s.IsActive=1 AND s.DoctorShareAmt <> 0 AND s.ShareCalculatedOn<>1 and ltd.ID in ( " + ledgerTnxID + " )  and ltd.ItemID=@itemID GROUP BY ltd.ID  ");


        aa = excuteCMD.GetRowQuery(sqlCMD.ToString(), new
        {
            transactionID = transactionID,
            receiptNo = receiptNo,
            paymentModeID = paymentModeID,
            itemID = itemID,
            bankCut = bankCut,
            writeOffReason = writeOffReason,
            ledgerTnxID = ledgerTnxID

        });
        
        DataTable _dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
           {
               transactionID = transactionID,
               receiptNo = receiptNo,
               paymentModeID = paymentModeID,
               itemID = itemID,
               bankCut = bankCut,
               writeOffReason = writeOffReason,
               ledgerTnxID = ledgerTnxID

           });

        

      //  DataTable dt = StockReports.GetDataTable(aa);

        //DataTable dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
        // {
        //     transactionID = transactionID,
        //     receiptNo = receiptNo,
        //     paymentModeID = paymentModeID,
        //     itemID = itemID,
        //     bankCut = bankCut,
        //     writeOffReason = writeOffReason,
        //     ledgerTnxID = ledgerTnxID
        // });
     

        List<allocationDetail> allocationDetailLTDIDWise = Util.GetListFromDataTable<allocationDetail>(_dt);

        return allocationDetailLTDIDWise;
    }








    [WebMethod(EnableSession = true)]
    public string Save(List<allocationDetail> allocationDetails, List<panelWriteOffDetail> panelWriteOffDetails)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();

        int defaultPanelID = 0;
        int writeOffEntryID = 0;
        

        try
        {
            var userID = HttpContext.Current.Session["ID"].ToString();
            if (allocationDetails.Count > 0)
            {
                excuteCMD.DML(tnx, "UPDATE f_paymentallocation s SET s.IsActive=0 ,s.UpdateBy=@userID,s.UpdateOn=NOW() WHERE  s.TransactionID=@transactionID AND s.IsVerified=0 AND s.IsActive=1 and s.AgainstReceiptNo=@receiptNo  and s.PaymentModeID=@paymentModeID ", CommandType.Text, new
                {
                    userID = userID,
                    transactionID = allocationDetails[0].transactionID,
                    receiptNo = allocationDetails[0].receiptNo,
                    paymentModeID = allocationDetails[0].paymentModeID
                });
            }



            for (int i = 0; i < panelWriteOffDetails.Count; i++)
            {

                panelWriteOffDetails[i].entryBy = userID;

                excuteCMD.DML(tnx, "UPDATE f_writeoff SET IsActive=0,UpdateBy=@userID,UpdateOn=NOW()  WHERE  TransactionID=@transactionID AND PanelID=@panelID AND IsVerified=0 AND IsActive=1", CommandType.Text, new
                {
                    userID = HttpContext.Current.Session["ID"].ToString(),
                    transactionID = panelWriteOffDetails[i].transactionID,
                    panelID = panelWriteOffDetails[i].panelID,
                });

                defaultPanelID = panelWriteOffDetails[i].panelID;
                string s = excuteCMD.GetRowQuery("INSERT INTO f_writeoff(TransactionID,PanelID, WriteOffAmount,EntryBy,WriteOffReason) VALUES (@transactionID,@panelID,@writeOffAmount,@entryBy,@writeOffReason)", panelWriteOffDetails[i]);

                writeOffEntryID=Util.GetInt(excuteCMD.ExecuteScalar(tnx, "INSERT INTO f_writeoff(TransactionID,PanelID, WriteOffAmount,EntryBy,WriteOffReason) VALUES (@transactionID,@panelID,@writeOffAmount,@entryBy,@writeOffReason);SELECT @@identity;", CommandType.Text, panelWriteOffDetails[i]));

            }






            for (int i = 0; i < allocationDetails.Count; i++)
            {
                var totalShareAmount = allocationDetails[i].doctorShareAmount;

                var totalAllocationAmount = allocationDetails[i].allocatedAmount;
                var allocationPercentOnShare = (totalAllocationAmount * 100 / totalShareAmount);

                var totalWriteOffAmount = allocationDetails[i].writeOffAmount;
                var writeOffPercentOnShare = (totalWriteOffAmount * 100 / totalShareAmount);

                string aa = string.Empty;

                List<allocationDetail> allocationDetailLTDIDWise = GetLTDIDWiseDetails(allocationDetails[i].ledgerTnxID, Util.GetString(allocationDetails[i].writeOffReason), allocationDetails[i].bankCut,
                    allocationDetails[i].itemID,
                    allocationDetails[i].transactionID,
                    allocationDetails[i].receiptNo,
                   Util.GetString(allocationDetails[i].paymentModeID),
                    out aa);

                for (int j = 0; j < allocationDetailLTDIDWise.Count; j++)
                {

                    var doctorShareAmount = allocationDetailLTDIDWise[j].doctorShareAmount;
                    var allocatedAmount = Util.round(allocationDetailLTDIDWise[j].doctorShareAmount * allocationPercentOnShare / 100);

                    var writeOffAmount = Util.round(allocationDetailLTDIDWise[j].doctorShareAmount * writeOffPercentOnShare / 100);

                    var sqlCMD = "INSERT INTO f_paymentallocation (TransactionID, LedgerTnxId, ServiceType, ItemId, SubCategoryId, AllocatedAmt, AgainstReceiptNo, EntryBy,WriteOff, TYPE,BankCut,Hosp_AllocatedAmt,Hosp_WriteOff,Hosp_BankCut,WriteOff_Reason,Hosp_WriteOff_Reason,PaymentModeID,panelID,writeoffID)VALUES (@TransactionID,@ledgerTnxId,@serviceType,@itemId,@subCategoryId,@allocatedAmt,@againstReceiptNo,@entryBy,@doc_writeOff,@type,@bankCut,@hosp_AllocatedAmt,@hosp_WriteOff,@hosp_BankCut,@writeOffReason,@hospWriteOffReason,@paymentModeID,@panelID,@writeOffID)";

                    var data = new
                    {
                        TransactionID = allocationDetailLTDIDWise[j].transactionID,
                        ledgerTnxId = allocationDetailLTDIDWise[j].ledgerTnxID,
                        serviceType = 0,
                        itemId = allocationDetailLTDIDWise[j].itemID,
                        subCategoryId = string.Empty,
                        allocatedAmt = allocatedAmount,
                        againstReceiptNo = allocationDetailLTDIDWise[j].receiptNo,
                        entryBy = HttpContext.Current.Session["ID"].ToString(),
                        doc_writeOff = writeOffAmount,
                        type = "0",
                        bankCut = allocationDetailLTDIDWise[j].bankCut,
                        hosp_AllocatedAmt = 0,
                        hosp_WriteOff = 0,
                        hosp_BankCut = 0,
                        writeOffReason = allocationDetailLTDIDWise[j].writeOffReason,
                        hospWriteOffReason = 0,
                        paymentModeID = allocationDetailLTDIDWise[j].paymentModeID,
                        panelID=defaultPanelID,
                        writeOffID=writeOffEntryID
                    };


                    aa = excuteCMD.GetRowQuery(sqlCMD.ToString(), data);

                    excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, data);

                }

            }

           tnx.Commit();

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }



    }





    [WebMethod(EnableSession = true)]
    public string Approved(string transactionID, string receiptNo, int paymentModeID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            string IsSave = UpdateWriteOff(tnx, excuteCMD, transactionID, receiptNo, paymentModeID);

            var sqlCMD = "UPDATE f_paymentallocation s SET s.IsVerified=1 , s.VerifiedBy=@verifiedBy , s.VerifiedOn=NOW() WHERE s.TransactionID=@transactionID AND s.AgainstReceiptNo=@receiptNo AND s.PaymentModeID=@PaymentModeID AND s.IsActive=1 AND s.IsVerified=0";
            excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
            {
                verifiedBy = HttpContext.Current.Session["ID"].ToString(),
                transactionID = transactionID,
                receiptNo = receiptNo,
                paymentModeID = paymentModeID
            });


            sqlCMD = "UPDATE f_writeoff SET  IsVerified=1 , VerifiedBy=@verifiedBy ,  VerifiedOn=NOW() WHERE  TransactionID=@transactionID AND IsActive=1 and IsVerified=0";
            excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
            {
                verifiedBy = HttpContext.Current.Session["ID"].ToString(),
                transactionID = transactionID,
            });


            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = AllGlobalFunction.saveMessage });

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = AllGlobalFunction.errorMessage, response = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }



    private static string UpdateWriteOff(MySqlTransaction tnx, ExcuteCMD excuteCMD, string transactionID, string receiptNo, int paymentModeID)
    {
        var sqlCMD = "SELECT SUM(s.writeoffAmount)WriteOffAmount FROM f_writeoff s WHERE s.TransactionID=@transactionID AND s.IsActive=1 AND s.IsVerified=0";

        decimal WriteOffAmount = Util.GetDecimal(excuteCMD.ExecuteScalar(tnx, sqlCMD, CommandType.Text, new
        {
            transactionID = transactionID,
            receiptNo = receiptNo,
            paymentModeID = paymentModeID

        }));

        sqlCMD = "UPDATE f_receipt_paymentdetail r SET r.WriteOff=r.WriteOff+@writeOffAmount,r.Updatedate=NOW()  WHERE r.ReceiptNo=@receiptNo and r.PaymentModeID=@paymentModeID";
        excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
        {
            writeOffAmount = WriteOffAmount,
            receiptNo = receiptNo,
            paymentModeID = paymentModeID
        });

        sqlCMD = "UPDATE f_reciept r SET r.WriteOff=r.WriteOff+@WriteOffAmount ,r.EditUserID=@userID,r.EditDateTime=NOW()  WHERE r.ReceiptNo=@receiptNo";
        excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
        {
            writeOffAmount = WriteOffAmount,
            receiptNo = receiptNo,
            userID = HttpContext.Current.Session["ID"].ToString()
        });

        sqlCMD = "UPDATE patient_medical_history pmh SET pmh.WriteOff=pmh.WriteOff+@WriteOffAmount ,pmh.LastUpdatedBy=@userID,pmh.Updatedate=NOW()  WHERE pmh.TransactionID=@transactionID";
        excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
        {
            writeOffAmount = WriteOffAmount,
            transactionID = transactionID,
            userID = HttpContext.Current.Session["ID"].ToString()
        });

        return "1";
    }



    [WebMethod(EnableSession = true)]
    public string SaveFullyWriteOff(List<allocationDetail> allocationDetails, List<panelWriteOffDetail> panelWriteOffDetails)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();

        int defaultPanelID = 0;
        int writeOffEntryID = 0;


        try
        {
            var userID = HttpContext.Current.Session["ID"].ToString();

            var preWriteOffID = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT p.`ID` FROM `f_writeoff` p WHERE p.`TransactionID`='" + panelWriteOffDetails[0].transactionID + "' AND p.`PanelID`='" + Util.GetInt(panelWriteOffDetails[0].panelID) + "' AND p.`IsActive`=1 AND p.`IsVerified`=0 ORDER BY ID DESC LIMIT 1 "));
            
            if (allocationDetails.Count > 0)
            {
                excuteCMD.DML(tnx, "UPDATE f_paymentallocation s SET s.IsActive=0 ,s.UpdateBy=@userID,s.UpdateOn=NOW() WHERE  s.TransactionID=@transactionID AND s.AgainstReceiptNo='0' AND s.IsVerified=0 AND s.IsActive=1 AND s.`writeOffID`=@writeOffID ", CommandType.Text, new
                {
                    userID = userID,
                    transactionID = allocationDetails[0].transactionID,
                    writeOffID = preWriteOffID
                });
            }



            for (int i = 0; i < panelWriteOffDetails.Count; i++)
            {

                panelWriteOffDetails[i].entryBy = userID;

                excuteCMD.DML(tnx, "UPDATE f_writeoff SET IsActive=0,UpdateBy=@userID,UpdateOn=NOW()  WHERE  TransactionID=@transactionID AND PanelID=@panelID AND IsVerified=0 AND IsActive=1", CommandType.Text, new
                {
                    userID = HttpContext.Current.Session["ID"].ToString(),
                    transactionID = panelWriteOffDetails[i].transactionID,
                    panelID = panelWriteOffDetails[i].panelID,
                });

                defaultPanelID = panelWriteOffDetails[i].panelID;
                string s = excuteCMD.GetRowQuery("INSERT INTO f_writeoff(TransactionID,PanelID, WriteOffAmount,EntryBy,WriteOffReason) VALUES (@transactionID,@panelID,@writeOffAmount,@entryBy,@writeOffReason)", panelWriteOffDetails[i]);

                writeOffEntryID = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "INSERT INTO f_writeoff(TransactionID,PanelID, WriteOffAmount,EntryBy,WriteOffReason) VALUES (@transactionID,@panelID,@writeOffAmount,@entryBy,@writeOffReason);SELECT @@identity;", CommandType.Text, panelWriteOffDetails[i]));

            }






            for (int i = 0; i < allocationDetails.Count; i++)
            {
                var totalShareAmount = allocationDetails[i].doctorShareAmount;

                var totalAllocationAmount = allocationDetails[i].allocatedAmount;
                var allocationPercentOnShare = (totalAllocationAmount * 100 / totalShareAmount);

                var totalWriteOffAmount = allocationDetails[i].writeOffAmount;
                var writeOffPercentOnShare = (totalWriteOffAmount * 100 / totalShareAmount);

                string aa = string.Empty;

                List<allocationDetail> allocationDetailLTDIDWise = GetLTDIDWiseDetails(allocationDetails[i].ledgerTnxID, Util.GetString(allocationDetails[i].writeOffReason), allocationDetails[i].bankCut,
                    allocationDetails[i].itemID,
                    allocationDetails[i].transactionID,
                    allocationDetails[i].receiptNo,
                   Util.GetString(allocationDetails[i].paymentModeID),
                    out aa);

                for (int j = 0; j < allocationDetailLTDIDWise.Count; j++)
                {

                    var doctorShareAmount = allocationDetailLTDIDWise[j].doctorShareAmount;
                    var allocatedAmount = Util.round(allocationDetailLTDIDWise[j].doctorShareAmount * allocationPercentOnShare / 100);

                    var writeOffAmount = Util.round(allocationDetailLTDIDWise[j].doctorShareAmount * writeOffPercentOnShare / 100);

                    var sqlCMD = "INSERT INTO f_paymentallocation (TransactionID, LedgerTnxId, ServiceType, ItemId, SubCategoryId, AllocatedAmt, AgainstReceiptNo, EntryBy,WriteOff, TYPE,BankCut,Hosp_AllocatedAmt,Hosp_WriteOff,Hosp_BankCut,WriteOff_Reason,Hosp_WriteOff_Reason,PaymentModeID,panelID,writeoffID)VALUES (@TransactionID,@ledgerTnxId,@serviceType,@itemId,@subCategoryId,@allocatedAmt,@againstReceiptNo,@entryBy,@doc_writeOff,@type,@bankCut,@hosp_AllocatedAmt,@hosp_WriteOff,@hosp_BankCut,@writeOffReason,@hospWriteOffReason,@paymentModeID,@panelID,@writeOffID)";

                    var data = new
                    {
                        TransactionID = allocationDetailLTDIDWise[j].transactionID,
                        ledgerTnxId = allocationDetailLTDIDWise[j].ledgerTnxID,
                        serviceType = 0,
                        itemId = allocationDetailLTDIDWise[j].itemID,
                        subCategoryId = string.Empty,
                        allocatedAmt = allocatedAmount,
                        againstReceiptNo = allocationDetailLTDIDWise[j].receiptNo,
                        entryBy = HttpContext.Current.Session["ID"].ToString(),
                        doc_writeOff = writeOffAmount,
                        type = "0",
                        bankCut = allocationDetailLTDIDWise[j].bankCut,
                        hosp_AllocatedAmt = 0,
                        hosp_WriteOff = 0,
                        hosp_BankCut = 0,
                        writeOffReason = allocationDetailLTDIDWise[j].writeOffReason,
                        hospWriteOffReason = 0,
                        paymentModeID = allocationDetailLTDIDWise[j].paymentModeID,
                        panelID = defaultPanelID,
                        writeOffID = writeOffEntryID
                    };


                    aa = excuteCMD.GetRowQuery(sqlCMD.ToString(), data);

                    excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, data);

                }

            }

            tnx.Commit();

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }



    }





    [WebMethod(EnableSession = true)]
    public string ApprovedFullyWriteOff(string transactionID, int panelId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            string IsSave = UpdateWriteOff(tnx, excuteCMD, transactionID, "0", 0);
            var preWriteOffID = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT p.`ID` FROM `f_writeoff` p WHERE p.`TransactionID`='" + transactionID + "' AND p.`PanelID`='" + Util.GetInt(panelId) + "' AND p.`IsActive`=1 AND p.`IsVerified`=0  ORDER BY ID DESC LIMIT 1 "));

            var sqlCMD = "UPDATE f_paymentallocation s SET s.IsVerified=1 , s.VerifiedBy=@verifiedBy , s.VerifiedOn=NOW() WHERE s.TransactionID=@transactionID AND s.AgainstReceiptNo='0' AND s.`writeOffID`=@writeOffID  AND s.IsActive=1 AND s.IsVerified=0";
            excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
            {
                verifiedBy = HttpContext.Current.Session["ID"].ToString(),
                transactionID = transactionID,
                writeOffID = preWriteOffID
            });


            sqlCMD = "UPDATE f_writeoff SET  IsVerified=1 , VerifiedBy=@verifiedBy ,  VerifiedOn=NOW() WHERE  TransactionID=@transactionID  and PanelID=@panelID AND IsActive=1 and IsVerified=0";
            excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
            {
                verifiedBy = HttpContext.Current.Session["ID"].ToString(),
                transactionID = transactionID,
                panelID = panelId
            });


            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = AllGlobalFunction.saveMessage });

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = AllGlobalFunction.errorMessage, response = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    
    
    public class allocationDetail
    {
        public string transactionID { get; set; }
        public string ledgerTnxID { get; set; }
        public string itemName { get; set; }
        public string itemID { get; set; }
        public decimal quantity { get; set; }
        public decimal amount { get; set; }
        public decimal doctorShareAmount { get; set; }
        public decimal approvedAllocatedAmount { get; set; }
        public decimal unApprovedAllocatedAmount { get; set; }
        public decimal allocatedAmount { get; set; }
        public decimal approvedwriteOffAmount { get; set; }
        public decimal unApprovedwriteOffAmount { get; set; }
        public decimal writeOffAmount { get; set; }
        public string writeOffReason { get; set; }

        public string receiptNo { get; set; }
        public string paymentModeID { get; set; }
        public string bankCut { get; set; }
    }


    public class panelWriteOffDetail
    {
        public string transactionID { get; set; }
        public int panelID { get; set; }
        public decimal writeOffAmount { get; set; }
        public string writeOffReason { get; set; }
        public string entryBy { get; set; }
    }
    [WebMethod(EnableSession = true)]
    public string getUserRights()
    {
        DataTable dt = StockReports.GetAuthorization(Util.GetInt(HttpContext.Current.Session["RoleID"].ToString()), HttpContext.Current.Session["ID"].ToString());
               
         if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
        {
            dt = StockReports.GetDataTable(" SELECT 0 CanApproveDoctorAllocation ");
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

    }
    [WebMethod]
    public string GetDoctorShareRemarkDetails(string transactionID)
    {
        StringBuilder sqlCMD = new StringBuilder();
        ExcuteCMD excuteCMD = new ExcuteCMD();
        sqlCMD.Append("SELECT rr.Remark, tt.transactionID,tt.DoctorName,tt.DoctorID,SUM(tt.doctorShareAmount)doctorShareAmount,SUM(tt.approvedAllocatedAmount)approvedAllocatedAmount FROM (SELECT ");
        sqlCMD.Append("' ' receiptNo, ");
        sqlCMD.Append("0 paymentModeID, ");
        sqlCMD.Append("transactionID, ");
        sqlCMD.Append("GROUP_CONCAT(ledgerTnxID) ledgerTnxID, ");
        sqlCMD.Append("itemName, ");
        sqlCMD.Append("itemID, ");
        sqlCMD.Append("ROUND(SUM(quantity), 2) quantity, ");
        sqlCMD.Append("ROUND(SUM(amount), 2) amount, ");
        sqlCMD.Append("ROUND(SUM(doctorShareAmount), 2) doctorShareAmount, ");
        sqlCMD.Append("ROUND((SELECT IFNULL(SUM(p.AllocatedAmt), 0)FROM f_paymentallocation p WHERE p.TransactionID = t.transactionID AND p.itemID = t.ItemID AND p.LedgerTnxId = t.ledgerTnxID AND p.IsActive = 1 AND p.IsVerified = 1),2) approvedAllocatedAmount, ");
        sqlCMD.Append("ROUND((SELECT IFNULL(SUM(p.AllocatedAmt), 0)FROM f_paymentallocation p WHERE p.TransactionID = t.transactionID AND p.itemID = t.ItemID AND p.LedgerTnxId = t.ledgerTnxID AND p.IsActive = 1 AND p.IsVerified = 0),2) unApprovedAllocatedAmount, ");
        //sqlCMD.Append("#AND (p.AgainstReceiptNo <> 'FREC/18-19/000001304'OR p.PaymentModeID <> 3) ");
        sqlCMD.Append("ROUND((SELECT IFNULL(SUM(p.AllocatedAmt), 0)FROM f_paymentallocation p WHERE p.TransactionID = t.transactionID AND p.itemID = t.ItemID AND p.LedgerTnxId = t.ledgerTnxID AND p.IsActive = 1 AND p.IsVerified = 0),2) allocatedAmount, ");
        //sqlCMD.Append("#AND p.AgainstReceiptNo = 'FREC/18-19/000001304'  AND p.PaymentModeID = 3 ");
        sqlCMD.Append("ROUND((SELECT IFNULL(SUM(p.WriteOff), 0)FROM f_paymentallocation p WHERE p.TransactionID = t.transactionID AND p.itemID = t.ItemID AND p.LedgerTnxId = t.ledgerTnxID AND p.IsActive = 1 AND p.IsVerified = 1),2) approvedwriteOffAmount, ");
        sqlCMD.Append("ROUND((SELECT IFNULL(SUM(p.WriteOff), 0)FROM f_paymentallocation p WHERE p.TransactionID = t.transactionID AND p.itemID = t.ItemID AND p.LedgerTnxId = t.ledgerTnxID AND p.IsActive = 1 AND p.IsVerified = 0),2) unApprovedwriteOffAmount, ");
        // sqlCMD.Append("#AND (p.AgainstReceiptNo <> 'FREC/18-19/000001304' OR p.PaymentModeID <> 3) ");
        sqlCMD.Append("ROUND((SELECT IFNULL(SUM(p.WriteOff), 0)FROM f_paymentallocation p WHERE p.TransactionID = t.transactionID AND p.itemID = t.ItemID AND p.LedgerTnxId = t.ledgerTnxID AND p.IsActive = 1 AND p.IsVerified = 0),2) writeOffAmount, ");
        // sqlCMD.Append("# AND p.AgainstReceiptNo = 'FREC/18-19/000001304' AND p.PaymentModeID = 3), ");
        sqlCMD.Append("IFNULL((SELECT (p.WriteOff_Reason)FROM f_paymentallocation p WHERE p.TransactionID = t.transactionID AND p.itemID = t.ItemID AND p.LedgerTnxId = t.ledgerTnxID AND p.IsActive = 1 AND p.IsVerified = 0 LIMIT 1),'') writeOffReason, ");
        // sqlCMD.Append("# AND p.AgainstReceiptNo = 'FREC/18-19/000001304' AND p.PaymentModeID = 3 ");
        sqlCMD.Append("ROUND(IFNULL((SELECT (p.BankCut)FROM f_paymentallocation p WHERE p.TransactionID = t.transactionID AND p.itemID = t.ItemID AND p.LedgerTnxId = t.ledgerTnxID AND p.IsActive = 1 AND p.IsVerified = 0 LIMIT 1),0),2) bankCut, ");
        // sqlCMD.Append("#AND p.AgainstReceiptNo = 'FREC/18-19/000001304' AND p.PaymentModeID = 6 ");
        sqlCMD.Append("DoctorName, ");
        sqlCMD.Append("DoctorID ");
        sqlCMD.Append("FROM ");
        sqlCMD.Append("(SELECT  ");
        sqlCMD.Append("ltd.TransactionID transactionID, ");
        sqlCMD.Append("ltd.ID ledgerTnxID, ");
        sqlCMD.Append("IF((c.ConfigID = 1),CONCAT(ltd.ItemName, '(', sc.Name, ')'),ltd.ItemName) itemName, ");
        sqlCMD.Append("ltd.ItemID, ");
        sqlCMD.Append("SUM(ltd.Quantity) quantity, ");
        sqlCMD.Append("SUM(IF(ltd.IsPackage = 1,ltd.GrossAmount,ltd.Amount) + IFNULL(((SELECT ltdt.amount FROM f_ledgertnxdetail ltdt WHERE ltdt.TypeOfTnx IN ('CR', 'DR') AND ltdt.IsVerified = 1 AND ltdt.LedgerTnxRefID <> - 1 AND ltdt.LedgerTnxRefID = ltd.ID)),0)) amount, ");
        sqlCMD.Append("IFNULL(SUM(s.DoctorShareAmt + IFNULL(((SELECT SUM(dst.DoctorShareAmt) FROM f_DocShare_TransactionDetail dst INNER JOIN f_ledgertnxdetail ltdt ON ltdt.ID = dst.LedgerTnxID WHERE ltdt.TypeOfTnx IN ('CR', 'DR') AND dst.DoctorShareAmt <> 0 AND ltdt.IsVerified = 1 AND ltdt.LedgerTnxRefID <> - 1 AND ltdt.LedgerTnxRefID = ltd.ID)),0)),0) doctorShareAmount, ");
        sqlCMD.Append("CONCAT(dm.Title, ' ', dm.Name) DoctorName,s.DoctorID ");
        sqlCMD.Append("FROM ");
        sqlCMD.Append("f_DocShare_TransactionDetail s ");
        sqlCMD.Append("INNER JOIN f_ledgertnxdetail ltd ");
        sqlCMD.Append("ON ltd.ID = s.LedgerTnxID ");
        sqlCMD.Append("INNER JOIN f_subcategorymaster sc ");
        sqlCMD.Append("ON sc.SubCategoryID = ltd.SubCategoryID ");
        sqlCMD.Append("INNER JOIN f_configrelation c ");
        sqlCMD.Append("ON c.CategoryID = sc.CategoryID ");
        sqlCMD.Append("INNER JOIN doctor_master dm ");
        sqlCMD.Append("ON dm.DoctorID = s.DoctorID ");
        sqlCMD.Append("WHERE s.TransactionID =@transactionID ");
        sqlCMD.Append("AND ltd.TypeOfTnx NOT IN ('CR', 'DR') ");
        sqlCMD.Append("AND s.IsActive = 1 ");
        sqlCMD.Append("AND s.DoctorShareAmt <> 0 ");
        sqlCMD.Append("AND s.ShareCalculatedOn <> 1 ");
        sqlCMD.Append("GROUP BY ltd.ID) t ");
        sqlCMD.Append("WHERE t.doctorShareAmount > 0 ");
        sqlCMD.Append("GROUP BY t.ledgerTnxID ) tt     LEFT JOIN f_paymentallocation_remarkdetails rr ON rr.TransactionID = tt.transactionID AND rr.DoctorID=tt.DoctorID AND rr.IsActive = 1 GROUP BY tt.DoctorID HAVING  (doctorShareAmount-approvedAllocatedAmount)>0 ");
        string aa = excuteCMD.GetRowQuery(sqlCMD.ToString(), new
        {
            transactionID = transactionID
        });
        var dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
        {
            transactionID = transactionID
        });
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    public class remark
    {
        public string transactionID { get; set; }
        public string doctorID { get; set; }
        public string shareRemark { get; set; }
    }
    [WebMethod(EnableSession=true)]
    public string SaveDoctorShareRemarkDetails(List<remark> remarkDetails)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var userID = HttpContext.Current.Session["ID"].ToString();
            excuteCMD.DML(tnx, "UPDATE f_paymentallocation_remarkdetails s SET s.IsActive=0,s.DeActiveBy=@deActiveBy,s.DeActiveDateTime=NOW() WHERE s.TransactionID=@transactionID", CommandType.Text, new
            {
                deActiveBy = userID,
                transactionID = remarkDetails[0].transactionID
            });
            for (int i = 0; i < remarkDetails.Count; i++)
            {
                excuteCMD.DML(tnx, "INSERT INTO f_paymentallocation_remarkdetails(TransactionID,DoctorID,Remark,CreatedBy) VALUES (@transactionID,@doctorID,@_remark,@createdBy)", CommandType.Text, new
                {
                    transactionID = remarkDetails[i].transactionID,
                    doctorID = remarkDetails[i].doctorID,
                    _remark = remarkDetails[i].shareRemark,
                    createdBy = userID
                });
            }
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = AllGlobalFunction.errorMessage, response = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}