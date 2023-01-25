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

        sqlCMD.Append(" SELECT pm.PatientID, CONCAT(pm.title, ' ', pm.pname) pname,REPLACE(pip.TransactionID, 'ISHHI', '') TransactionID,pnl.company_name,IFNULL(ipd.BillNo, '') BillNo,CONCAT(pm.House_No,' ',pm.Locality,' ',pm.City) Address,pip.TransactionID transactionID,pmh.Type,IFNULL((GETIPDBillAmount(pip.TransactionID)),0)  BillAmount ");
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

        sqlCMD.Append(" Where IFNULL(ipd.BillNo,'')<>'' ");


        if (!string.IsNullOrEmpty(patientID))
            sqlCMD.Append(" AND PatientID=@patientID ");


        if (!string.IsNullOrEmpty(patientName))
            sqlCMD.Append(" AND pm.PName like @patientName ");


        if (!string.IsNullOrEmpty(billNo))
            sqlCMD.Append(" AND ipd.BillNo=@billNo");

        if (panelID != "0")
            sqlCMD.Append(" AND pmh.PanelID =@panelID ");

        if (string.IsNullOrEmpty(transactionID))
        {

            sqlCMD.Append(" Union All ");

            sqlCMD.Append(" SELECT pm.PatientID, CONCAT(pm.Title,' ',pm.PName) pname,'' TransactionID,p.company_name,lt.BillNo,CONCAT(pm.House_No,' ',pm.Locality,' ',pm.City) Address,lt.TransactionID transactionID,pmh.Type,lt.NetAmount BillAmount ");
            sqlCMD.Append(" FROM f_ledgertransaction lt  ");
            sqlCMD.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID ");
            sqlCMD.Append(" INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID ");
            sqlCMD.Append(" INNER JOIN f_panel_master p ON p.PanelID=pmh.PanelID ");
            sqlCMD.Append(" WHERE pmh.Type='OPD' and IFNULL(lt.BillNo,'')<>'' and pm.PatientID<>'CASH002' ");

            if (!string.IsNullOrEmpty(patientID))
                sqlCMD.Append(" AND pm.PatientID=@patientID ");


            if (!string.IsNullOrEmpty(patientName))
                sqlCMD.Append(" AND pm.PName like @patientName ");


            if (!string.IsNullOrEmpty(billNo))
                sqlCMD.Append(" AND lt.BillNo=@billNo");

            if (panelID != "0")
                sqlCMD.Append(" AND pmh.PanelID =@panelID ");

            sqlCMD.Append(" Union All ");

            sqlCMD.Append(" SELECT pm.PatientID, CONCAT(pm.Title,' ',pm.PName) pname,'' TransactionID,p.company_name,lt.BillNo,CONCAT(pm.House_No,' ',pm.Locality,' ',pm.City) Address,lt.TransactionID transactionID,pmh.Type,lt.NetAmount BillAmount ");
            sqlCMD.Append(" FROM f_ledgertransaction lt  ");
            sqlCMD.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID ");
            sqlCMD.Append(" INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID ");
            sqlCMD.Append(" INNER JOIN f_panel_master p ON p.PanelID=pmh.PanelID ");
            sqlCMD.Append(" WHERE pmh.Type='EMG' and IFNULL(lt.BillNo,'')<>''   and pm.PatientID<>'CASH002'  ");

            if (!string.IsNullOrEmpty(patientID))
                sqlCMD.Append(" AND pm.PatientID=@patientID ");


            if (!string.IsNullOrEmpty(patientName))
                sqlCMD.Append(" AND pm.PName like @patientName ");


            if (!string.IsNullOrEmpty(billNo))
                sqlCMD.Append(" AND lt.BillNo=@billNo ");

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

        //  StringBuilder sqlCMD = new StringBuilder(" select t.*,round(AmountPaid-PreAllocatedAmount,4)MaxAllocation from  (select r.TransactionID,R.ReceiptNo,r.TDS,r.WriteOff,DATE_FORMAT(R.Date,'%d-%b-%Y')ReceiptDate,ROUND(R.AmountPaid+r.TDS+r.WriteOff,4)AmountPaid,round(ifnull((select sum(pa.AllocatedAmt+pa.Hosp_AllocatedAmt+pa.WriteOff+pa.Hosp_WriteOff) from f_paymentallocation pa where pa.AgainstReceiptNo=R.ReceiptNo and pa.IsActive=1 AND pa.IsVerified=1),0),4)PreAllocatedAmount,ROUND(IFNULL((SELECT SUM(pa.AllocatedAmt+pa.Hosp_AllocatedAmt+pa.WriteOff+pa.Hosp_WriteOff)FROM f_paymentallocation pa WHERE pa.AgainstReceiptNo = R.ReceiptNo AND pa.IsActive = 1 AND pa.IsVerified=0),0),4) UnApprovedPreAllocatedAmount,( SELECT  IFNULL(COUNT(*),0) FROM  f_receipt_paymentdetail re WHERE re.PaymentModeID=3 AND re.ReceiptNo=r.ReceiptNo) isCreditCardIssue,(SELECT GROUP_CONCAT(rp.BankCutPercentage) FROM  f_receipt_paymentdetail rp WHERE rp.ReceiptNo=r.ReceiptNo AND rp.BankCutPercentage>0)BankCutPercentage from f_reciept r where r.TransactionID=@transactionID AND R.IsCancel=0 and R.AmountPaid>0 order by date )t ");
        StringBuilder sqlCMD = new StringBuilder(" SELECT t.*,ROUND(AmountPaid+WriteOff-PreAllocatedAmount,4)MaxAllocation FROM  (SELECT rp.PaymentModeID,rp.PaymentMode,r.TransactionID,R.ReceiptNo,rp.TDS,rp.WriteOff,DATE_FORMAT(R.Date,'%d-%b-%Y')ReceiptDate,ROUND(rp.Amount,4)AmountPaid,	ROUND(IFNULL((SELECT SUM(pa.AllocatedAmt+pa.Hosp_AllocatedAmt+pa.WriteOff+pa.Hosp_WriteOff) 	FROM f_paymentallocation pa 	WHERE pa.AgainstReceiptNo=R.ReceiptNo AND pa.IsActive=1 AND pa.IsVerified=1 AND pa.PaymentModeID=rp.PaymentModeID ),0),4)PreAllocatedAmount,	ROUND(IFNULL((SELECT SUM(pa.AllocatedAmt+pa.Hosp_AllocatedAmt+pa.WriteOff+pa.Hosp_WriteOff) FROM f_paymentallocation pa WHERE pa.AgainstReceiptNo = R.ReceiptNo AND pa.IsActive = 1 AND pa.IsVerified=0 AND pa.PaymentModeID=rp.PaymentModeID ),0),4) UnApprovedPreAllocatedAmount,IF(rp.PaymentModeID=3,1,0)isCreditCardIssue,IF(rp.PaymentModeID=3,rp.BankCutPercentage,0)BankCutPercentage FROM f_reciept r INNER JOIN f_receipt_paymentdetail rp ON rp.ReceiptNo=r.ReceiptNo WHERE r.TransactionID=@transactionID AND R.IsCancel=0 AND R.AmountPaid>0 ORDER BY DATE )t ");


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
    public string GetDepartmentWiseDetails(string transactionID, decimal pendingForAllocation, string receiptNo, int paymentModeID)
    {

        StringBuilder sqlCMD = new StringBuilder(" CALL da_DoctorAmountAllocationCategoryWise(@transactionID,@pendingForAllocation,@receiptNo,@paymentModeID) ");

        ExcuteCMD excuteCMD = new ExcuteCMD();
        var dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
        {
            transactionID = transactionID,
            pendingForAllocation = pendingForAllocation,
            receiptNo = receiptNo,
            paymentModeID = paymentModeID
        });


        for (int i = 0; i < dt.Rows.Count; i++)
        {
            var configID = Util.GetInt(dt.Rows[i]["ConfigID"]);
            if (configID == 23 || configID == 14)
            {
                var dtt = GetDepartmentItemDetails(
                          dt.Rows[i]["TransactionID"].ToString(),
                          dt.Rows[i]["CategoryID"].ToString(),
                          Util.GetInt(dt.Rows[i]["ConfigID"].ToString()),
                          Util.GetInt(dt.Rows[i]["ServiceTypeId"].ToString()), 0, 0, 0, 0,
                          receiptNo,
                          paymentModeID
                      );

                PackageShareAmount packageShareAmount = ProcessPackage(dtt, true);
                dt.Rows[i]["ShareAmount"] = packageShareAmount.doctorShare;
                dt.Rows[i]["HospShareAmount"] = packageShareAmount.hospitalShare;
                dt.Rows[i]["MaxAllocatedAmount"] = packageShareAmount.doctorShare;
                dt.Rows[i]["MaxHAllocatedAmount"] = packageShareAmount.hospitalShare;


                dt.Rows[i]["HPreAllocatedAmt"] = packageShareAmount.HPreAllocatedAmt;//-packageShareAmount.HospitalwriteOffAmount;
                dt.Rows[i]["PreAllocatedAmt"] = packageShareAmount.PreAllocatedAmt; //- packageShareAmount.WriteOffAmount;

                dt.Rows[i]["WriteOffAmt"] = packageShareAmount.WriteOffAmount;
                dt.Rows[i]["Hosp_WriteOffAmt"] = packageShareAmount.HospitalwriteOffAmount;

                dt.Rows[i]["PendingDoctorAmount"] = packageShareAmount.doctorShare - packageShareAmount.PreAllocatedAmt;
                dt.Rows[i]["PendingHospitalAmount"] = packageShareAmount.hospitalShare - packageShareAmount.HPreAllocatedAmt;
                dt.Rows[i]["BankCutPercent"] = packageShareAmount.BankCut;
                dt.Rows[i]["Hosp_BankCutPercent"] = packageShareAmount.HospBankCut;
                dt.Rows[i]["WriteOff_Reason"] = packageShareAmount.WriteOffReason;
                dt.Rows[i]["Hosp_WriteOff_Reason"] = packageShareAmount.HospitalwriteOffReason;

            }

        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }

    [WebMethod]
    public string GetDepartmentWiseItemDetails(string transactionID, string categoryId, int configId, int serviceTypeId, decimal pendingCollectionForAllocationPer, decimal pendingWriteOffForAllocationPer, decimal pendingHCollectionForAllocationPer, decimal pendingHWriteOffForAllocationPer, string receiptNo, int paymentModeID)
    {

        var dt = GetDepartmentItemDetails(transactionID, categoryId, configId, serviceTypeId, pendingCollectionForAllocationPer, pendingWriteOffForAllocationPer, pendingHCollectionForAllocationPer, pendingHWriteOffForAllocationPer, receiptNo, paymentModeID);


        if (configId == 23 || configId == 14)
            ProcessPackage(dt, false);

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }

    private static DataTable GetDepartmentItemDetails(string transactionID, string categoryId, int configId, int serviceTypeId, decimal pendingCollectionForAllocationPer, decimal pendingWriteOffForAllocationPer, decimal pendingHCollectionForAllocationPer, decimal pendingHWriteOffForAllocationPer, string receiptNo, int paymentModeID)
    {
        StringBuilder sqlCMD = new StringBuilder(" CALL da_DoctorAmountAllocationItemWise(@transactionID,@CategoryId,@ConfigId,@ServiceTypeId,@pendingCollectionForAllocationPer,@pendingWriteOffForAllocationPer,@pendingHCollectionForAllocationPer,@pendingHWriteOffForAllocationPer,@receiptNo,@paymentModeID) ");

        ExcuteCMD excuteCMD = new ExcuteCMD();
        var dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
        {
            transactionID = transactionID,
            CategoryId = categoryId,
            ConfigId = configId,
            ServiceTypeId = serviceTypeId,
            pendingCollectionForAllocationPer = pendingCollectionForAllocationPer,
            pendingWriteOffForAllocationPer = pendingWriteOffForAllocationPer,
            pendingHCollectionForAllocationPer = pendingHCollectionForAllocationPer,
            pendingHWriteOffForAllocationPer = pendingHWriteOffForAllocationPer,
            receiptNo = receiptNo,
            paymentModeID = paymentModeID
        });
        return dt;
    }

    public class PackageShareAmount
    {
        public decimal doctorShare { get; set; }
        public decimal hospitalShare { get; set; }
        public decimal PreAllocatedAmt { get; set; }
        public decimal HPreAllocatedAmt { get; set; }
        public decimal WriteOffAmount { get; set; }
        public decimal HospitalwriteOffAmount { get; set; }
        public decimal BankCut { get; set; }
        public decimal HospBankCut { get; set; }
        public string WriteOffReason { get; set; }
        public string HospitalwriteOffReason { get; set; }
    }


    private static PackageShareAmount ProcessPackage(DataTable dt, bool isParent)
    {
        decimal totalBillAmount = 0;
        decimal totalDoctorShare = 0;
        decimal totalDoctorShareAmount = 0;
        decimal totalHospitalShareAmount = 0;
        decimal totalPreAllocatedAmt = 0;
        decimal totalHPreAllocatedAmt = 0;
        decimal PreAllocatedAmt = 0;
        decimal HPreAllocatedAmt = 0;
        decimal totalWriteOffAmount = 0;
        decimal totalHospitalwriteOffAmount = 0;
        decimal WriteOffAmount = 0;
        decimal HospitalwriteOffAmount = 0;
        decimal BankCut = 0;
        decimal HospBankCut = 0;
        string WriteOffReason = "0";
        string HospitalwriteOffReason = "0";

        for (int i = 0; i < dt.Rows.Count; i++)
        {

            totalBillAmount = Util.GetDecimal(dt.Rows[i]["BillAmount"]);
            var doctorShare = Util.GetDecimal(dt.Rows[i]["ShareAmount"]);
            var hospitalShare = Util.GetDecimal(dt.Rows[i]["HospShareAmount"]);
            var amount = Util.GetDecimal(dt.Rows[i]["Amount"]);

            if (doctorShare > 0)
            {
                totalDoctorShare += doctorShare;
                totalDoctorShareAmount += amount;
            }
            else
                totalHospitalShareAmount += amount;

        }

        decimal pendingAmount = (totalBillAmount - totalDoctorShareAmount);

        for (int i = 0; i < dt.Rows.Count; i++)
        {
            var doctorShare = Util.GetDecimal(dt.Rows[i]["ShareAmount"]);
            var hospitalShare = Util.GetDecimal(dt.Rows[i]["HospShareAmount"]);
            var amount = Util.GetDecimal(dt.Rows[i]["Amount"]);


            //            var percent = (amount * 100 / totalHospitalShareAmount);
            decimal percent = 0;
            if (totalHospitalShareAmount > 0)
                percent = (amount * 100 / totalHospitalShareAmount);

            decimal tempAmount = (pendingAmount * percent / 100);



            //if (isParent)
            //{
            //    PreAllocatedAmt = Util.GetDecimal(dt.Rows[i]["TotalDoctorAllocated"]);
            //    HPreAllocatedAmt = Util.GetDecimal(dt.Rows[i]["TotalHospitalAllocated"]);
            //    WriteOffAmount = Util.GetDecimal(dt.Rows[i]["TotalDoctorAllocatedWriteOff"]);
            //    HospitalwriteOffAmount = Util.GetDecimal(dt.Rows[i]["TotalHospitalAllocatedWriteOff"]);
            //    //BankCut = Util.GetDecimal(dt.Rows[i]["TotalHospitalAllocatedWriteOff"]);
            //    //HospBankCut = Util.GetDecimal(dt.Rows[i]["TotalHospitalAllocatedWriteOff"]);
            //}
            //else
            //{
            PreAllocatedAmt = Util.GetDecimal(dt.Rows[i]["PreAllocatedAmt"]);
            HPreAllocatedAmt = Util.GetDecimal(dt.Rows[i]["HPreAllocatedAmt"]);
            WriteOffAmount = Util.GetDecimal(dt.Rows[i]["WriteOffAmt"]);
            HospitalwriteOffAmount = Util.GetDecimal(dt.Rows[i]["Hosp_WriteOffAmt"]);
            BankCut = Util.GetDecimal(dt.Rows[i]["BankCutPercent"]);
            HospBankCut = Util.GetDecimal(dt.Rows[i]["Hosp_BankCutPercent"]);
            WriteOffReason = Util.GetString(dt.Rows[i]["WriteOff_Reason"]);
            HospitalwriteOffReason = Util.GetString(dt.Rows[i]["Hosp_WriteOff_Reason"]);
            //   }





            totalWriteOffAmount += WriteOffAmount;
            totalHospitalwriteOffAmount += HospitalwriteOffAmount;
            totalPreAllocatedAmt += PreAllocatedAmt;
            totalHPreAllocatedAmt += HPreAllocatedAmt;

            if (doctorShare == 0)
            {
                dt.Rows[i]["Amount"] = Math.Round(tempAmount, 6);
                dt.Rows[i]["HospShareAmount"] = Math.Round(tempAmount, 6);
                dt.Rows[i]["PendingHospitalAmount"] = Math.Round(tempAmount - (HPreAllocatedAmt + HospitalwriteOffAmount), 6);

            }
            dt.Rows[i]["MaxAllocatedAmount"] = Math.Round(doctorShare, 6);
            dt.Rows[i]["MaxHAllocatedAmount"] = Util.GetDecimal(dt.Rows[i]["HospShareAmount"]).ToString();
            dt.Rows[i]["PendingDoctorAmount"] = doctorShare - (PreAllocatedAmt + WriteOffAmount);


        }
        return new PackageShareAmount
        {
            doctorShare = totalDoctorShare,
            hospitalShare = (totalBillAmount - totalDoctorShare),
            HPreAllocatedAmt = totalHPreAllocatedAmt,
            PreAllocatedAmt = totalPreAllocatedAmt,
            WriteOffAmount = totalWriteOffAmount,
            HospitalwriteOffAmount = totalHospitalwriteOffAmount,
            BankCut = BankCut,
            HospBankCut = HospBankCut,
            WriteOffReason = WriteOffReason,
            HospitalwriteOffReason = HospitalwriteOffReason

        };
    }
















    public class CategoryWiseAllocationDetail
    {
        public string TransactionID { get; set; }
        public string ServiceType { get; set; }
        public int ServiceTypeId { get; set; }
        public string CategoryID { get; set; }
        public int ConfigID { get; set; }
        public string DisplayName { get; set; }
        public decimal Amount { get; set; }
        public decimal ShareAmount { get; set; }
        public decimal HospShareAmount { get; set; }
        public decimal PreAllocatedAmt { get; set; }
        public decimal MaxAllocation { get; set; }
        public decimal NewAllocation { get; set; }
        public decimal NewWriteOff { get; set; }
        public string WriteOffReason { get; set; }
        public decimal BankCut { get; set; }
        public decimal NewHospCollectionAllocation { get; set; }
        public decimal NewHospWriteOffAllocation { get; set; }
        public decimal MaxAllocatedAmount { get; set; }
        public decimal MaxHAllocatedAmount { get; set; }
        public string HospWriteOffReason { get; set; }

        public decimal HospBankCut { get; set; }
        public List<ItemWiseAllocationDetail> ItemWiseAllocationDetails { get; set; }

    }



    public class ItemWiseAllocationDetail
    {
        public string LedgerTnxID { get; set; }
        public string TransactionID { get; set; }
        public string ServiceType { get; set; }
        public string CategoryID { get; set; }
        public string ItemName { get; set; }
        public string ItemID { get; set; }
        public string DisplayName { get; set; }
        public decimal Amount { get; set; }
        public decimal ShareAmount { get; set; }
        public decimal HospShareAmount { get; set; }
        public decimal PreAllocatedAmt { get; set; }
        public decimal MaxAllocation { get; set; }
        public decimal NewCollectionAllocation { get; set; }
        public decimal NewWriteOffAllocation { get; set; }
        public string WriteOffReason { get; set; }
        public decimal BankCut { get; set; }
        public decimal NewHospCollectionAllocation { get; set; }
        public decimal NewHospWriteOffAllocation { get; set; }
        public decimal MaxAllocatedAmount { get; set; }
        public decimal MaxHAllocatedAmount { get; set; }
        public string HospWriteOffReason { get; set; }
        public decimal HospBankCut { get; set; }
        public decimal BillAmount { get; set; }




        //exdened
        public decimal BankCutPercent { get; set; }
        public decimal Hosp_BankCutPercent { get; set; }
        public string Hosp_WriteOff_Reason { get; set; }
        public decimal Hosp_WriteOffAmt { get; set; }
        public decimal HPreAllocatedAmt { get; set; }
        public decimal PendingDoctorAmount { get; set; }
        public decimal TotalDoctorAllocated { get; set; }
        public decimal TotalHospitalAllocated { get; set; }
        public string WriteOff_Reason { get; set; }
        public decimal WriteOffAmt { get; set; }
    }

    public class ReceiptDetail
    {
        public string receiptNo { get; set; }
        public decimal amount { get; set; }
        public decimal totalAmount { get; set; }
        public decimal WriteOff { get; set; }
        public decimal TDS { get; set; }
        public string TransactionID { get; set; }
        public int PaymentModeID { get; set; }
    }



    public class panelWriteOff
    {
        public int panelID { get; set; }
        public string TransactionID { get; set; }
        public decimal writeOffAmount { get; set; }
        public decimal writeOffReason { get; set; }
        public string entryBy { get; set; }
        
    }


    public static List<ReceiptDetail> GetAgainstReceipts(ref List<ReceiptDetail> receiptDetails, decimal amount)
    {
        var allocateAmount = amount;
        List<ReceiptDetail> receiptDetail = new List<ReceiptDetail>();
        for (int i = 0; i < receiptDetails.Count; i++)
        {

            var a = new ReceiptDetail
             {
                 receiptNo = receiptDetails[i].receiptNo,
                 amount = receiptDetails[i].amount >= allocateAmount ? allocateAmount : (allocateAmount - receiptDetails[i].amount),
                 PaymentModeID = receiptDetails[i].PaymentModeID
             };

            receiptDetail.Add(a);
            allocateAmount = allocateAmount - a.amount;

            receiptDetails[i].amount = receiptDetails[i].amount - a.amount;

            if (allocateAmount <= 0)
                break;

        }

        return receiptDetail;
    }


    [WebMethod(EnableSession = true)]
    public string ValidateAmountAllocation(decimal billAmount, string transactionID, string receiptNo, decimal allocatedAmount, decimal receiptAmount, int paymentModeID)
    {

        ExcuteCMD excuteCMD = new ExcuteCMD();

        decimal totalAllocatedAmount = excuteCMD.ExecuteScalar("SELECT IFNULL(SUM(p.AllocatedAmt+p.Hosp_AllocatedAmt+p.WriteOff+p.Hosp_WriteOff),0) FROM f_paymentallocation  p WHERE p.IsActive=1 AND p.TransactionID=@transactionID AND (p.AgainstReceiptNo <>@receiptNO OR p.PaymentModeID<>@paymentModeID)", new
        {

            transactionID = transactionID,
            receiptNO = receiptNo,
            paymentModeID = paymentModeID
        });


        if (allocatedAmount != receiptAmount)
        {
            decimal _totalAllocatedAmount = totalAllocatedAmount + allocatedAmount;
            if (Math.Round(_totalAllocatedAmount,2) ==Math.Round(billAmount,2))
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true });
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Please Allocate Pending Amount.", totalAllocatedAmount = totalAllocatedAmount });

        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true });
        }


    }










    [WebMethod(EnableSession = true)]
    public string SaveAmountAllocation(List<CategoryWiseAllocationDetail> categoryWiseAllocationDetails, List<ReceiptDetail> receiptDetails, List<panelWriteOff> panelWriteOffDetails)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {


            var totalAmount = categoryWiseAllocationDetails.Sum(i => i.NewAllocation + i.NewHospCollectionAllocation);


            if (receiptDetails.Count < 1 && totalAmount <= 0)
                receiptDetails.Add(new ReceiptDetail { receiptNo = string.Empty, PaymentModeID = 0, amount = 0 });

            //var sqlCMD = "INSERT INTO f_paymentallocation (TransactionID, LedgerTnxId, ServiceType, ItemId, SubCategoryId, AllocatedAmt, AgainstReceiptNo, EntryBy,WriteOff, TYPE,BankCut,Hosp_AllocatedAmt,Hosp_WriteOff,Hosp_BankCut,WriteOff_Reason,Hosp_WriteOff_Reason)VALUES (@TransactionID,@ledgerTnxId,@serviceType,@itemId,@subCategoryId,@allocatedAmt,@againstReceiptNo,@entryBy,@doc_writeOff,@type,@bankCut,@hosp_AllocatedAmt,@hosp_WriteOff,@hosp_BankCut,@writeOffReason,@hospWriteOffReason)";
            excuteCMD.DML(tnx, "UPDATE f_paymentallocation s SET s.IsActive=0 ,s.UpdateBy=@userID,s.UpdateOn=NOW() WHERE  s.TransactionID=@transactionID AND s.IsVerified=0 AND s.IsActive=1 and s.AgainstReceiptNo=@receiptNo  and s.PaymentModeID=@paymentModeID ", CommandType.Text, new
            {
                userID = HttpContext.Current.Session["ID"].ToString(),
                transactionID = categoryWiseAllocationDetails[0].TransactionID,
                receiptNo = receiptDetails[0].receiptNo,
                paymentModeID = receiptDetails[0].PaymentModeID
            });



            for (int i = 0; i < panelWriteOffDetails.Count; i++)
            {

                panelWriteOffDetails[i].entryBy=HttpContext.Current.Session["ID"].ToString();

                excuteCMD.DML(tnx, "UPDATE f_writeoff SET IsActive=0,UpdateBy=@userID,UpdateOn=NOW()  WHERE  TransactionID=@transactionID AND PanelID=@panelID AND IsVerified=0 AND IsActive=1", CommandType.Text, new
                {
                    userID = HttpContext.Current.Session["ID"].ToString(),
                    transactionID = panelWriteOffDetails[i].TransactionID,
                    panelID = panelWriteOffDetails[i].panelID,
                });

                string s= excuteCMD.GetRowQuery("INSERT INTO f_writeoff(TransactionID,PanelID, WriteOffAmount,EntryBy,WriteOffReason) VALUES (@TransactionID,@panelID,@writeOffAmount,@entryBy,@writeOffReason)", panelWriteOffDetails[i]);                
                
                excuteCMD.DML(tnx, "INSERT INTO f_writeoff(TransactionID,PanelID, WriteOffAmount,EntryBy,WriteOffReason) VALUES (@TransactionID,@panelID,@writeOffAmount,@entryBy,@writeOffReason)", CommandType.Text, panelWriteOffDetails[i]);                
               
            }
            
           
            
            
            
            
            for (int i = 0; i < categoryWiseAllocationDetails.Count; i++)
            {

                decimal total = categoryWiseAllocationDetails[i].NewAllocation;
                total += categoryWiseAllocationDetails[i].NewHospCollectionAllocation;
                total += categoryWiseAllocationDetails[i].NewWriteOff;
                total += categoryWiseAllocationDetails[i].NewHospWriteOffAllocation;
                if (total == 0)
                    continue;

                if (categoryWiseAllocationDetails[i].ItemWiseAllocationDetails.Count > 0)
                {
                    for (int j = 0; j < categoryWiseAllocationDetails[i].ItemWiseAllocationDetails.Count; j++)
                    {
                        var ledgerTransactionIDs = categoryWiseAllocationDetails[i].ItemWiseAllocationDetails[j].LedgerTnxID.Split(',');
                        for (int l = 0; l < ledgerTransactionIDs.Length; l++)
                        {
                            receiptDetails = InsertAllocation(categoryWiseAllocationDetails, ref receiptDetails, tnx, excuteCMD, i, j, ledgerTransactionIDs, l);
                        }
                    }
                }
                else
                {
                    StringBuilder s = new StringBuilder(" CALL da_DoctorAmountAllocationItemWise(@transactionID,@CategoryId,@ConfigId,@ServiceTypeId,@pendingCollectionForAllocationPer,@pendingWriteOffForAllocationPer,@pendingHCollectionForAllocationPer,@pendingHWriteOffForAllocationPer,@receiptNo,@paymentModeID)");

                    var _params = new
                    {
                        transactionID = categoryWiseAllocationDetails[i].TransactionID,
                        CategoryId = categoryWiseAllocationDetails[i].CategoryID,
                        ConfigId = categoryWiseAllocationDetails[i].ConfigID,
                        ServiceTypeId = categoryWiseAllocationDetails[i].ServiceTypeId,
                        pendingCollectionForAllocationPer = 0,
                        pendingWriteOffForAllocationPer = 0,
                        pendingHCollectionForAllocationPer = 0,
                        pendingHWriteOffForAllocationPer = 0,
                        receiptNo = receiptDetails[0].receiptNo,
                        paymentModeID = receiptDetails[0].PaymentModeID
                    };

                    var dt = excuteCMD.GetDataTable(s.ToString(), CommandType.Text, _params);


                    if (_params.ConfigId == 23 || _params.ConfigId == 14)
                        ProcessPackage(dt, false);


                    List<ItemWiseAllocationDetail> itemWiseAllocationDetails = new List<ItemWiseAllocationDetail>();
                    itemWiseAllocationDetails = Util.GetListFromDataTable<ItemWiseAllocationDetail>(dt);
                    categoryWiseAllocationDetails[i].ItemWiseAllocationDetails = itemWiseAllocationDetails;

                    for (int j = 0; j < categoryWiseAllocationDetails[i].ItemWiseAllocationDetails.Count; j++)
                    {


                        categoryWiseAllocationDetails[i]
                               .ItemWiseAllocationDetails[j]
                               .NewCollectionAllocation = calculateProportionally(
                               categoryWiseAllocationDetails[i].NewAllocation,
                               categoryWiseAllocationDetails[i].MaxAllocatedAmount,
                               categoryWiseAllocationDetails[i].ItemWiseAllocationDetails[j].MaxAllocatedAmount);


                        categoryWiseAllocationDetails[i]
                            .ItemWiseAllocationDetails[j]
                            .NewHospCollectionAllocation = calculateProportionally(
                            categoryWiseAllocationDetails[i].NewHospCollectionAllocation,
                            categoryWiseAllocationDetails[i].MaxHAllocatedAmount,
                            categoryWiseAllocationDetails[i].ItemWiseAllocationDetails[j].MaxHAllocatedAmount);



                        categoryWiseAllocationDetails[i]
                             .ItemWiseAllocationDetails[j]
                             .NewWriteOffAllocation = calculateProportionally(
                             categoryWiseAllocationDetails[i].NewWriteOff,
                             categoryWiseAllocationDetails[i].MaxAllocatedAmount,
                             categoryWiseAllocationDetails[i].ItemWiseAllocationDetails[j].MaxAllocatedAmount);


                        categoryWiseAllocationDetails[i]
                           .ItemWiseAllocationDetails[j]
                           .NewHospWriteOffAllocation = calculateProportionally(
                           categoryWiseAllocationDetails[i].NewHospWriteOffAllocation,
                           categoryWiseAllocationDetails[i].MaxHAllocatedAmount,
                           categoryWiseAllocationDetails[i].ItemWiseAllocationDetails[j].MaxHAllocatedAmount);


                        categoryWiseAllocationDetails[i].ItemWiseAllocationDetails[j].BankCut = categoryWiseAllocationDetails[i].BankCut;
                        categoryWiseAllocationDetails[i].ItemWiseAllocationDetails[j].HospBankCut = categoryWiseAllocationDetails[i].HospBankCut;

                        categoryWiseAllocationDetails[i].ItemWiseAllocationDetails[j].WriteOffReason = categoryWiseAllocationDetails[i].WriteOffReason;
                        categoryWiseAllocationDetails[i].ItemWiseAllocationDetails[j].HospWriteOffReason = categoryWiseAllocationDetails[i].HospWriteOffReason;


                        var ledgerTransactionIDs = categoryWiseAllocationDetails[i].ItemWiseAllocationDetails[j].LedgerTnxID.Split(',');

                        for (int l = 0; l < ledgerTransactionIDs.Length; l++)
                        {
                            receiptDetails = InsertAllocation(categoryWiseAllocationDetails, ref receiptDetails, tnx, excuteCMD, i, j, ledgerTransactionIDs, l);
                        }
                    }
                }
            }

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });
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

    private static string UpdateWriteOff(MySqlTransaction tnx, ExcuteCMD excuteCMD, string transactionID, string receiptNo, int paymentModeID)
    {
        var sqlCMD = "SELECT SUM(s.WriteOff+s.Hosp_WriteOff)WriteOffAmount FROM f_paymentallocation s WHERE s.TransactionID=@transactionID AND s.IsActive=1 AND s.IsVerified=0 AND s.AgainstReceiptNo=@receiptNo and s.PaymentModeID=@paymentModeID";

        decimal WriteOffAmount = Util.GetDecimal(excuteCMD.ExecuteScalar(tnx, sqlCMD, CommandType.Text, new
        {
            transactionID = transactionID,
            receiptNo = receiptNo,
            paymentModeID = paymentModeID

        }));

        sqlCMD = "UPDATE f_receipt_paymentdetail r SET r.WriteOff=@writeOffAmount,r.Updatedate=NOW()  WHERE r.ReceiptNo=@receiptNo and r.PaymentModeID=@paymentModeID";
        excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
        {
            writeOffAmount = WriteOffAmount,
            receiptNo = receiptNo,
            paymentModeID = paymentModeID
        });

        sqlCMD = "UPDATE f_reciept r SET r.WriteOff=(SELECT SUM(rp.WriteOff) FROM f_receipt_paymentdetail rp WHERE rp.ReceiptNo=r.ReceiptNo)  ,r.EditUserID=@userID,r.EditDateTime=NOW()  WHERE r.ReceiptNo=@receiptNo";
        excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
        {
            receiptNo = receiptNo,
            userID = HttpContext.Current.Session["ID"].ToString()
        });

        sqlCMD = "UPDATE patient_medical_history pmh SET pmh.WriteOff=(SELECT SUM(r.WriteOff) FROM f_reciept r WHERE r.TransactionID=pmh.TransactionID and r.IsCancel=0 ) ,pmh.LastUpdatedBy=@userID,pmh.Updatedate=NOW()  WHERE pmh.TransactionID=@transactionID";
        excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
        {
            transactionID = transactionID,
            userID = HttpContext.Current.Session["ID"].ToString()
        });

        return "1";
    }
    private static List<ReceiptDetail> InsertAllocation(List<CategoryWiseAllocationDetail> categoryWiseAllocationDetails, ref List<ReceiptDetail> receiptDetails, MySqlTransaction tnx, ExcuteCMD excuteCMD, int i, int j, string[] ledgerTransactionIDs, int l)
    {
        var sqlCMD = "INSERT INTO f_paymentallocation (TransactionID, LedgerTnxId, ServiceType, ItemId, SubCategoryId, AllocatedAmt, AgainstReceiptNo, EntryBy,WriteOff, TYPE,BankCut,Hosp_AllocatedAmt,Hosp_WriteOff,Hosp_BankCut,WriteOff_Reason,Hosp_WriteOff_Reason,PaymentModeID)VALUES (@TransactionID,@ledgerTnxId,@serviceType,@itemId,@subCategoryId,@allocatedAmt,@againstReceiptNo,@entryBy,@doc_writeOff,@type,@bankCut,@hosp_AllocatedAmt,@hosp_WriteOff,@hosp_BankCut,@writeOffReason,@hospWriteOffReason,@paymentModeID)";

        var s = new StringBuilder(" CALL da_DoctorAmountAllocationLTDIDWise(@transactionID,@CategoryId,@ConfigId,@ServiceTypeId,@pendingCollectionForAllocationPer,@pendingWriteOffForAllocationPer,@ledgerTnxID,@pendingHCollectionForAllocationPer,@pendingHWriteOffForAllocationPer,@receiptNo,@paymentModeID)");
        var _params = new
        {
            transactionID = categoryWiseAllocationDetails[i].TransactionID,
            CategoryId = categoryWiseAllocationDetails[i].CategoryID,
            ConfigId = categoryWiseAllocationDetails[i].ConfigID,
            ServiceTypeId = categoryWiseAllocationDetails[i].ServiceTypeId,
            pendingCollectionForAllocationPer = 0,
            pendingWriteOffForAllocationPer = 0,
            pendingHCollectionForAllocationPer = 0,
            pendingHWriteOffForAllocationPer = 0,
            receiptNo = receiptDetails[0].receiptNo,
            ledgerTnxID = ledgerTransactionIDs[l],
            paymentModeID = receiptDetails[0].PaymentModeID,
        };


        var dt = excuteCMD.GetDataTable(s.ToString(), CommandType.Text, _params);

        List<ItemWiseAllocationDetail> LTDWiseAllocationDetails = new List<ItemWiseAllocationDetail>();
        LTDWiseAllocationDetails = Util.GetListFromDataTable<ItemWiseAllocationDetail>(dt);

        bool isPackage = false;

        if (categoryWiseAllocationDetails[i].ConfigID == 23 || categoryWiseAllocationDetails[i].ConfigID == 14)
            isPackage = true;


        LTDWiseAllocationDetails[0]
           .NewCollectionAllocation = calculateProportionally(
           categoryWiseAllocationDetails[i].ItemWiseAllocationDetails[j].NewCollectionAllocation,
           categoryWiseAllocationDetails[i].ItemWiseAllocationDetails[j].MaxAllocatedAmount,
           isPackage ? categoryWiseAllocationDetails[i].ItemWiseAllocationDetails[j].MaxAllocatedAmount : LTDWiseAllocationDetails[0].MaxAllocatedAmount);


        LTDWiseAllocationDetails[0]
            .NewHospCollectionAllocation = calculateProportionally(
            categoryWiseAllocationDetails[i].ItemWiseAllocationDetails[j].NewHospCollectionAllocation,
            categoryWiseAllocationDetails[i].ItemWiseAllocationDetails[j].MaxHAllocatedAmount,
            isPackage ? categoryWiseAllocationDetails[i].ItemWiseAllocationDetails[j].MaxHAllocatedAmount : LTDWiseAllocationDetails[0].MaxHAllocatedAmount);


        LTDWiseAllocationDetails[0]
             .NewWriteOffAllocation = calculateProportionally(
             categoryWiseAllocationDetails[i].ItemWiseAllocationDetails[j].NewWriteOffAllocation,
             categoryWiseAllocationDetails[i].ItemWiseAllocationDetails[j].MaxAllocatedAmount,
             isPackage ? categoryWiseAllocationDetails[i].ItemWiseAllocationDetails[j].MaxAllocatedAmount : LTDWiseAllocationDetails[0].MaxAllocatedAmount);


        LTDWiseAllocationDetails[0]
           .NewHospWriteOffAllocation = calculateProportionally(
           categoryWiseAllocationDetails[i].ItemWiseAllocationDetails[j].NewHospWriteOffAllocation,
           categoryWiseAllocationDetails[i].ItemWiseAllocationDetails[j].MaxHAllocatedAmount,
           isPackage ? categoryWiseAllocationDetails[i].ItemWiseAllocationDetails[j].MaxHAllocatedAmount : LTDWiseAllocationDetails[0].MaxHAllocatedAmount);


        LTDWiseAllocationDetails[0]
           .BankCut = categoryWiseAllocationDetails[i].ItemWiseAllocationDetails[j].BankCut;

        LTDWiseAllocationDetails[0]
           .HospBankCut = categoryWiseAllocationDetails[i].ItemWiseAllocationDetails[j].HospBankCut;

        LTDWiseAllocationDetails[0]
           .WriteOffReason = categoryWiseAllocationDetails[i].ItemWiseAllocationDetails[j].WriteOffReason;


        LTDWiseAllocationDetails[0]
           .HospWriteOffReason = categoryWiseAllocationDetails[i].ItemWiseAllocationDetails[j].HospWriteOffReason;

        decimal totalAllocationAmount = 0;
        decimal newCollectionAllocation = LTDWiseAllocationDetails[0].NewCollectionAllocation;
        newCollectionAllocation += LTDWiseAllocationDetails[0].NewWriteOffAllocation;

        decimal newHospCollectionAllocation = LTDWiseAllocationDetails[0].NewHospCollectionAllocation;
        newCollectionAllocation += LTDWiseAllocationDetails[0].NewHospWriteOffAllocation;

        totalAllocationAmount = newCollectionAllocation + newHospCollectionAllocation;

        string SqlPType = "SELECT IF(l.TransactionID LIKE 'ISHHI%',2,IF(l.TypeOfTnx='Emergency',3,1)) FROM f_ledgerTransaction l WHERE l.TransactionID='" + categoryWiseAllocationDetails[0].TransactionID + "' LIMIT 1";
        int PatientType = Util.GetInt(StockReports.ExecuteScalar(SqlPType));
        List<ReceiptDetail> againstReceipts = GetAgainstReceipts(ref receiptDetails, totalAllocationAmount);
        for (int m = 0; m < againstReceipts.Count; m++)
        {
            excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
            {
                TransactionID = categoryWiseAllocationDetails[i].ItemWiseAllocationDetails[j].TransactionID,
                ledgerTnxId = ledgerTransactionIDs[l],
                serviceType = categoryWiseAllocationDetails[i].ServiceTypeId,
                itemId = LTDWiseAllocationDetails[0].ItemID,
                subCategoryId = string.Empty,
                allocatedAmt = LTDWiseAllocationDetails[0].NewCollectionAllocation,
                againstReceiptNo = againstReceipts[m].receiptNo,
                entryBy = HttpContext.Current.Session["ID"].ToString(),
                doc_writeOff = LTDWiseAllocationDetails[0].NewWriteOffAllocation,
                type = PatientType,
                bankCut = LTDWiseAllocationDetails[0].BankCut,
                hosp_AllocatedAmt = LTDWiseAllocationDetails[0].NewHospCollectionAllocation,
                hosp_WriteOff = LTDWiseAllocationDetails[0].NewHospWriteOffAllocation,
                hosp_BankCut = LTDWiseAllocationDetails[0].HospBankCut,
                writeOffReason = LTDWiseAllocationDetails[0].WriteOffReason,
                hospWriteOffReason = LTDWiseAllocationDetails[0].HospWriteOffReason,
                paymentModeID = againstReceipts[m].PaymentModeID,
            });
        }
        return receiptDetails;
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


            // Insert Finance Integarion 
            //if (Resources.Resource.AllowFiananceIntegration == "1")
            //{
            //    string IsIntegrated = Util.GetString(EbizFrame.InsertPaymentAllocation(transactionID, receiptNo, paymentModeID, tnx));
            //    if (IsIntegrated == "0")
            //    {
            //        tnx.Rollback();
            //        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Finance Integration Details" });
            //    }
            //}


            var sqlCMD = "";// "SELECT s.AgainstReceiptNo,SUM(s.WriteOff+s.Hosp_WriteOff)WriteOffAmount FROM f_paymentallocation s WHERE s.TransactionID=@transactionID AND s.IsActive=1 AND s.IsVerified=0 GROUP BY s.AgainstReceiptNo";
            // var sqlCMD = "SELECT s.AgainstReceiptNo,SUM(s.WriteOff+s.Hosp_WriteOff)WriteOffAmount FROM f_paymentallocation s WHERE s.TransactionID=@transactionID AND s.IsActive=1 AND s.IsVerified=0 GROUP BY s.AgainstReceiptNo";

            // var dt = excuteCMD.GetDataTable(sqlCMD, CommandType.Text, new
            // {
            //     transactionID = transactionID
            // });


            // sqlCMD = "UPDATE f_reciept r SET r.WriteOff=@writeOffAmount,r.EditUserID=@userID,r.EditDateTime=NOW()  WHERE r.ReceiptNo=@receiptNo";
            // for (int i = 0; i < dt.Rows.Count; i++)
            // {
            //     excuteCMD.DML(tnx,sqlCMD, CommandType.Text, new {
            //         writeOffAmount = Util.GetDecimal(dt.Rows[i]["WriteOffAmount"]),
            //         receiptNo = Util.GetString(dt.Rows[i]["AgainstReceiptNo"]),
            //         userID = HttpContext.Current.Session["ID"].ToString(),
            //     });
            // }

            string IsSave = UpdateWriteOff(tnx, excuteCMD, transactionID, receiptNo, paymentModeID);

            sqlCMD = "UPDATE f_paymentallocation s SET s.IsVerified=1 , s.VerifiedBy=@verifiedBy , s.VerifiedOn=NOW() WHERE s.TransactionID=@transactionID AND s.AgainstReceiptNo=@receiptNo AND s.PaymentModeID=@PaymentModeID AND s.IsActive=1 AND s.IsVerified=0";
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
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });

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


    public static decimal calculateProportionally(decimal amount, decimal parentMaxAmount, decimal childMaxAmount)
    {

        decimal percent = 0;
        if (parentMaxAmount > 0)
            percent = (amount * 100 / parentMaxAmount);

        return Math.Round((childMaxAmount * percent / 100), 4);
    }



    [WebMethod(EnableSession = true)]
    public string AutoAllocation(List<string> transactionIDs)
    {
        string IsSave = "";
        decimal BankCut = 0;
        // List<string> transactionIDs = new List<string> { transID };
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            for (int n = 0; n < transactionIDs.Count; n++)
            {

                string transactionID = transactionIDs[n];

                // var dt = excuteCMD.GetDataTable("SELECT Sum(r.AmountPaid+r.WriteOff+r.TDS) amount,Sum(r.AmountPaid+r.WriteOff+r.TDS) totalAmount,r.WriteOff,r.TDS,r.ReceiptNo receiptNo,r.TransactionID FROM f_reciept r WHERE r.TransactionID=@transactionID  group by r.ReceiptNo having amount>0", CommandType.Text, new


                var dt = excuteCMD.GetDataTable(" SELECT if(rp.PaymentModeID=3,ifnull(rp.BankCutPercentage,0),0)BankCutPercentage,rp.PaymentModeID,rp.PaymentMode, rp.Amount amount,rp.Amount totalAmount,r.WriteOff,r.TDS,r.ReceiptNo receiptNo,r.TransactionID FROM f_reciept r INNER JOIN f_receipt_paymentdetail rp ON rp.ReceiptNo=r.ReceiptNo WHERE r.TransactionID=@transactionID HAVING amount>0  ", CommandType.Text, new
                 {
                     transactionID = transactionID
                 });

                BankCut = Util.GetDecimal(dt.Rows[0]["BankCutPercentage"].ToString());
                List<ReceiptDetail> paymentDetails = Util.GetListFromDataTable<ReceiptDetail>(dt);



                decimal totalPaidAmount = paymentDetails.Sum(r => r.amount);

                for (int r = 0; r < paymentDetails.Count; r++)
                {

                    List<ReceiptDetail> receiptDetails = new List<ReceiptDetail> { paymentDetails[r] };

                    StringBuilder sqlCMD = new StringBuilder(" CALL da_DoctorAmountAllocationCategoryWise(@transactionID,@pendingForAllocation,@receiptNo,@paymentModeID) ");
                    dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
                    {
                        transactionID = receiptDetails[0].TransactionID,
                        pendingForAllocation = receiptDetails[0].amount,
                        receiptNo = receiptDetails[0].receiptNo,
                        paymentModeID = receiptDetails[0].PaymentModeID,
                    });



                    for (int x = 0; x < dt.Rows.Count; x++)
                    {

                        var configID = Util.GetInt(dt.Rows[x]["ConfigID"]);
                        if (configID == 23 || configID == 14)
                        {
                            var dtt = GetDepartmentItemDetails(
                                      dt.Rows[x]["TransactionID"].ToString(),
                                      dt.Rows[x]["CategoryID"].ToString(),
                                      Util.GetInt(dt.Rows[x]["ConfigID"].ToString()),
                                      Util.GetInt(dt.Rows[x]["ServiceTypeId"].ToString()), 0, 0, 0, 0,
                                      dt.Rows[x]["ConfigID"].ToString(),
                                      Util.GetInt(dt.Rows[x]["PaymentModeID"].ToString())
                                  );

                            PackageShareAmount packageShareAmount = ProcessPackage(dtt, true);
                            dt.Rows[x]["ShareAmount"] = packageShareAmount.doctorShare;
                            dt.Rows[x]["HospShareAmount"] = packageShareAmount.hospitalShare;
                            dt.Rows[x]["MaxAllocatedAmount"] = packageShareAmount.doctorShare;
                            dt.Rows[x]["MaxHAllocatedAmount"] = packageShareAmount.hospitalShare;
                            dt.Rows[x]["HPreAllocatedAmt"] = packageShareAmount.HPreAllocatedAmt - packageShareAmount.WriteOffAmount;
                            dt.Rows[x]["PreAllocatedAmt"] = packageShareAmount.PreAllocatedAmt - packageShareAmount.HospitalwriteOffAmount;

                            dt.Rows[x]["WriteOffAmt"] = packageShareAmount.WriteOffAmount;
                            dt.Rows[x]["Hosp_WriteOffAmt"] = packageShareAmount.HospitalwriteOffAmount;

                            dt.Rows[x]["PendingDoctorAmount"] = packageShareAmount.doctorShare - packageShareAmount.PreAllocatedAmt;
                            dt.Rows[x]["PendingHospitalAmount"] = packageShareAmount.hospitalShare - packageShareAmount.HPreAllocatedAmt;
                        }

                    }








                    List<CategoryWiseAllocationDetail> categoryWiseAllocationDetails = Util.GetListFromDataTable<CategoryWiseAllocationDetail>(dt);

                    for (int i = 0; i < categoryWiseAllocationDetails.Count; i++)
                    {




                        categoryWiseAllocationDetails[i].NewAllocation = (((categoryWiseAllocationDetails[i].ShareAmount * 100 / totalPaidAmount) * paymentDetails[r].totalAmount) / 100);
                        categoryWiseAllocationDetails[i].NewHospCollectionAllocation = (((categoryWiseAllocationDetails[i].HospShareAmount * 100 / totalPaidAmount) * paymentDetails[r].totalAmount) / 100);
                        categoryWiseAllocationDetails[i].NewWriteOff = 0;
                        categoryWiseAllocationDetails[i].NewHospWriteOffAllocation = 0;

                        categoryWiseAllocationDetails[i].BankCut = BankCut;








                        StringBuilder s = new StringBuilder(" CALL da_DoctorAmountAllocationItemWise(@transactionID,@CategoryId,@ConfigId,@ServiceTypeId,@pendingCollectionForAllocationPer,@pendingWriteOffForAllocationPer,@pendingHCollectionForAllocationPer,@pendingHWriteOffForAllocationPer,@receiptNo,@paymentModeID)");

                        var _params = new
                        {
                            transactionID = categoryWiseAllocationDetails[i].TransactionID,
                            CategoryId = categoryWiseAllocationDetails[i].CategoryID,
                            ConfigId = categoryWiseAllocationDetails[i].ConfigID,
                            ServiceTypeId = categoryWiseAllocationDetails[i].ServiceTypeId,
                            pendingCollectionForAllocationPer = 0,
                            pendingWriteOffForAllocationPer = 0,
                            pendingHCollectionForAllocationPer = 0,
                            pendingHWriteOffForAllocationPer = 0,
                            receiptNo = receiptDetails[0].receiptNo,
                            paymentModeID = receiptDetails[0].PaymentModeID
                        };

                        dt = excuteCMD.GetDataTable(s.ToString(), CommandType.Text, _params);



                        if (_params.ConfigId == 23 || _params.ConfigId == 14)
                            ProcessPackage(dt, false);


                        List<ItemWiseAllocationDetail> itemWiseAllocationDetails = new List<ItemWiseAllocationDetail>();
                        itemWiseAllocationDetails = Util.GetListFromDataTable<ItemWiseAllocationDetail>(dt);
                        categoryWiseAllocationDetails[i].ItemWiseAllocationDetails = itemWiseAllocationDetails;

                        for (int j = 0; j < categoryWiseAllocationDetails[i].ItemWiseAllocationDetails.Count; j++)
                        {


                            categoryWiseAllocationDetails[i]
                                   .ItemWiseAllocationDetails[j]
                                   .NewCollectionAllocation = calculateProportionally(
                                   categoryWiseAllocationDetails[i].NewAllocation,
                                   categoryWiseAllocationDetails[i].MaxAllocatedAmount,
                                   categoryWiseAllocationDetails[i].ItemWiseAllocationDetails[j].MaxAllocatedAmount);


                            categoryWiseAllocationDetails[i]
                                .ItemWiseAllocationDetails[j]
                                .NewHospCollectionAllocation = calculateProportionally(
                                categoryWiseAllocationDetails[i].NewHospCollectionAllocation,
                                categoryWiseAllocationDetails[i].MaxHAllocatedAmount,
                                categoryWiseAllocationDetails[i].ItemWiseAllocationDetails[j].MaxHAllocatedAmount);



                            categoryWiseAllocationDetails[i]
                                 .ItemWiseAllocationDetails[j]
                                 .NewWriteOffAllocation = calculateProportionally(
                                 categoryWiseAllocationDetails[i].NewWriteOff,
                                 categoryWiseAllocationDetails[i].MaxAllocatedAmount,
                                 categoryWiseAllocationDetails[i].ItemWiseAllocationDetails[j].MaxAllocatedAmount);


                            categoryWiseAllocationDetails[i]
                               .ItemWiseAllocationDetails[j]
                               .NewHospWriteOffAllocation = calculateProportionally(
                               categoryWiseAllocationDetails[i].NewHospWriteOffAllocation,
                               categoryWiseAllocationDetails[i].MaxHAllocatedAmount,
                               categoryWiseAllocationDetails[i].ItemWiseAllocationDetails[j].MaxHAllocatedAmount);


                            categoryWiseAllocationDetails[i].ItemWiseAllocationDetails[j].BankCut = categoryWiseAllocationDetails[i].BankCut;
                            categoryWiseAllocationDetails[i].ItemWiseAllocationDetails[j].HospBankCut = categoryWiseAllocationDetails[i].HospBankCut;

                            categoryWiseAllocationDetails[i].ItemWiseAllocationDetails[j].WriteOffReason = categoryWiseAllocationDetails[i].WriteOffReason;
                            categoryWiseAllocationDetails[i].ItemWiseAllocationDetails[j].HospWriteOffReason = categoryWiseAllocationDetails[i].HospWriteOffReason;

                            var ledgerTransactionIDs = categoryWiseAllocationDetails[i].ItemWiseAllocationDetails[j].LedgerTnxID.Split(',');

                            for (int l = 0; l < ledgerTransactionIDs.Length; l++)
                            {
                                receiptDetails = InsertAllocation(categoryWiseAllocationDetails, ref receiptDetails, tnx, excuteCMD, i, j, ledgerTransactionIDs, l);



                            }
                        }
                    }



                    // Insert Finance Integarion 
                    //if (Resources.Resource.AllowFiananceIntegration == "1")
                    //{
                    //    string IsIntegrated = Util.GetString(EbizFrame.InsertPaymentAllocation(transactionID, receiptDetails[0].receiptNo, receiptDetails[0].PaymentModeID, tnx));
                    //    if (IsIntegrated == "0")
                    //    {
                    //        tnx.Rollback();
                    //        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Finance Integration Details" });
                    //    }
                    //}

                    var sqlQuery = "";
                    IsSave = UpdateWriteOff(tnx, excuteCMD, transactionID, receiptDetails[0].receiptNo, receiptDetails[0].PaymentModeID);

                    //var sqlQuery = "SELECT s.AgainstReceiptNo,SUM(s.WriteOff+s.Hosp_WriteOff)WriteOffAmount FROM f_paymentallocation s WHERE s.TransactionID=@transactionID AND s.IsActive=1 AND s.IsVerified=0 GROUP BY s.AgainstReceiptNo";

                    //var dtAutoApproval = excuteCMD.GetDataTable(sqlQuery, CommandType.Text, new
                    //{
                    //    transactionID = transactionID
                    //});


                    //sqlQuery = "UPDATE f_reciept r SET r.WriteOff=@writeOffAmount,r.EditUserID=@userID,r.EditDateTime=NOW()  WHERE r.ReceiptNo=@receiptNo";
                    //for (int i = 0; i < dtAutoApproval.Rows.Count; i++)
                    //{
                    //    excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
                    //    {
                    //        writeOffAmount = Util.GetDecimal(dtAutoApproval.Rows[i]["WriteOffAmount"]),
                    //        receiptNo = Util.GetString(dtAutoApproval.Rows[i]["AgainstReceiptNo"]),
                    //        userID = HttpContext.Current.Session["ID"].ToString(),
                    //    });
                    //}

                    sqlQuery = "UPDATE f_paymentallocation s SET s.IsVerified=1 , s.VerifiedBy=@verifiedBy , s.VerifiedOn=NOW() WHERE s.TransactionID=@transactionID AND s.AgainstReceiptNo=@receiptNo AND s.PaymentModeID=@PaymentModeID AND s.IsActive=1 AND s.IsVerified=0";
                    excuteCMD.DML(tnx, sqlQuery, CommandType.Text, new
                    {
                        verifiedBy = HttpContext.Current.Session["ID"].ToString(),
                        transactionID = transactionID,
                        receiptNo = receiptDetails[0].receiptNo,
                        paymentModeID = receiptDetails[0].PaymentModeID
                    });

                }
            }

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });
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




    [WebMethod(EnableSession=true)]
    public string RevertAllocation(string transactionID)
    {

        try
        {


            ExcuteCMD excuteCMD = new ExcuteCMD();

            excuteCMD.DML("UPDATE  f_paymentallocation  f  SET f.IsActive=0 AND f.UpdateOn=NOW(),f.UpdateBy=@userID,f.IsRevert=1 WHERE f.TransactionID=@transactionID AND f.IsVerified=0", CommandType.Text, new
            {

                userID = HttpContext.Current.Session["ID"].ToString(),
                transactionID = transactionID

            });
            
            
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });
            
        }
        catch (Exception ex)
        {
            
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });

        }
       
        
        
    }




}