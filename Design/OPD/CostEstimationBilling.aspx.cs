using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;

public partial class Design_OPD_CostEstimationBilling : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            CalendarExteFromDate.EndDate = CalendarExtenderToDate.EndDate = cdDateProcedure.StartDate = System.DateTime.Now;
            txtFromDate.Text = txtToDate.Text = txtDateProcedure.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        }
        txtToDate.Attributes.Add("readonly", "true");
        txtFromDate.Attributes.Add("readonly", "true");
        txtDateProcedure.Attributes.Add("readonly", "true");
    }

    [WebMethod]
    public static string BindRoomType()
    {
        string sql = "select Name,IPDCaseTypeID from ipd_case_type_master where IsActive=1 and ifnull(BillingCategoryID,'')<>'' group by BillingCategoryID ";
        DataTable dt = StockReports.GetDataTable(sql);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public static string BindSurgery()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT sm.Name,sm.Surgery_ID FROM f_surgery_master sm WHERE sm.IsActive=1 order by Name ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod]
    public static string BindIPDPackage()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT im.TypeName PackageName,im.ItemID FROM f_itemmaster im INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=im.SubCategoryID INNER JOIN f_configrelation c ON sc.CategoryID=c.CategoryID WHERE im.IsActive=1 AND c.ConfigID=14 ORDER BY im.TypeName ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public static string BindICDDetail(string icdCode)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT concat(A.ICD10_Code,'#',A.WHO_Full_Desc) ICDCodeName,A.ICD10_Code FROM icd_10_new A WHERE A.IsActive=1 AND A.WHO_Full_Desc like '" + icdCode + "%' or A.ICD10_Code like '" + icdCode + "%' ORDER BY A.WHO_Full_Desc ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod]
    public static string BindEstimationByDefault()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT 1 SNo,cm.Name,cm.CategoryID,ConfigID  FROM f_categorymaster cm INNER JOIN f_configrelation cf ON cm.categoryid = cf.categoryid  WHERE Active=1 AND cf.ConfigID IN(3,6,7,8,9,10,11,20,24,14,26,27,29,22) ");
        sb.Append(" UNION ALL  ");
        sb.Append(" SELECT 2 SNo, cm.Name,cm.CategoryID,ConfigID  FROM f_categorymaster cm INNER JOIN f_configrelation cf ON cm.categoryid = cf.categoryid  WHERE Active=1 AND cf.ConfigID=2  ");
        sb.Append(" ORDER BY SNo,NAME ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public static string bindPreEstimateCost(string tID)
    {
        DataTable dt = StockReports.GetDataTable("CALL getDepartmentwiseIPDBillDetails('" + tID + "')");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string BindPredefinedEstimation(string packageID, string surgeryID, int panelID, string doctorID, string iCDCode, string roomType, int limit, string fromDate, string toDate)
    {
        //  string Sql = "CALL getEstimationBilling('" + packageID + "','" + surgeryID + "'," + panelID + ",'" + doctorID + "','" + iCDCode + "','" + roomType + "'," + limit + ")";
        string Sql = "CALL getEstimationBilling('" + packageID + "','" + surgeryID + "'," + panelID + ",'" + doctorID + "','" + iCDCode.Split('#')[0] + "','" + roomType + "'," + limit + ",'" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "'," + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + ")";

        DataTable dt = StockReports.GetDataTable(Sql);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string ShowItemDetails(string TransID, string CategoryId, string ConfigID)
    {
        StringBuilder sb = new StringBuilder();
        switch (ConfigID)
        {
            case "22": // Surgery Case
                sb.Append("select ltd.SurgeryName ItemName,1 Quantity,Round(lt.NetAmount,3) Amount From f_ledgertnxdetail ltd inner join f_ledgertransaction LT on ltd.LedgerTransactionNo = LT.LedgerTransactionNo ");
                sb.Append(" inner join employee_master em on ltd.UserID = em.Employee_ID WHERE Lt.IsCancel = 0 and ltd.IsVerified = 1 and ltd.IsPackage = 0 and ");
                sb.Append(" ltd.IsSurgery = 1 and lt.TransactionID = '" + TransID + "' group by lt.LedgerTransactionNo order by ItemName ");
                break;

            case "14"://IPD Package
                sb.Append(" select TypeName ItemName,Quantity,Amount ");
                sb.Append(" from (select T1.LedgerTnxID,T1.Amount,t1.ItemID,T1.TypeName,t1.PDate,t1.Discount,t2.Items,t1.DiscReason,t1.Quantity,t1.Rate from");
                sb.Append(" (select ltd.LedgerTnxID,ltd.ItemID,ltd.Amount,ltd.`Rate`, ltd.`DiscountReason` AS DiscReason,ltd.`DiscountPercentage` AS Discount,im.TypeName,date_format(ltd.EntryDate,'%d-%b-%y') PDate,ltd.Quantity ");
                sb.Append(" from f_ledgertnxdetail ltd inner join f_itemmaster im on ltd.ItemID = im.ItemID inner join f_subcategorymaster sm");
                sb.Append(" on sm.SubCategoryID = im.SubCategoryID inner join f_configrelation cf on sm.CategoryID=cf.CategoryID ");
                sb.Append(" where ltd.IsPackage = 0 and ltd.IsVerified = 1 and ltd.IsFree = 0 ");
                sb.Append(" and ltd.TransactionID = '" + TransID + "' and cf.ConfigID=14 )T1 left join ");
                sb.Append(" (select PackageID,count(*) Items from f_ledgertnxdetail ltd where ltd.IsPackage = 0 and ltd.IsVerified = 1 ");
                sb.Append(" and IsFree = 0 and ltd.TransactionID = '" + TransID + "' group by ltd.PackageID)T2 on t1.itemid = t2.PackageID )T3 ");

                break;

            case "11": // Medicine & Cosnumables
                sb.Append("select ltd.ItemName,ltd.Quantity,Round(ltd.Amount,3) Amount From f_ledgertnxdetail ltd inner join f_ledgertransaction LT on ltd.LedgerTransactionNo = LT.LedgerTransactionNo inner join employee_master em on ltd.UserID = em.Employee_ID ");
                sb.Append(" inner join f_subcategorymaster sm on sm.SubCategoryID = ltd.SubCategoryID inner join f_configrelation cf on sm.CategoryID = cf.CategoryID WHERE Lt.IsCancel = 0 and ltd.IsVerified = 1 and ltd.IsPackage = 0 and cf.ConfigID=11 and lt.TransactionID = '" + TransID + "' ");
                sb.Append(" order by ItemName ");
                break;

            case "7"://BloodBank
                sb.Append("select ltd.ItemName,ltd.Quantity,Round(ltd.Amount,3) Amount From f_ledgertnxdetail ltd inner join f_ledgertransaction LT on ltd.LedgerTransactionNo = LT.LedgerTransactionNo inner join employee_master em on ltd.UserID = em.Employee_ID ");
                sb.Append(" inner join f_subcategorymaster sm on sm.SubCategoryID = ltd.SubCategoryID WHERE Lt.IsCancel = 0 and ltd.IsVerified = 1 and ltd.IsPackage = 0 and sm.CategoryID = '" + CategoryId.Replace("'", "''") + "' and lt.TransactionID = '" + TransID + "'");
                sb.Append(" order by ltd.ItemName ");

                break;

            case "2"://RoomCharges
                sb.Append("select ltd.ItemName,ltd.Quantity,Round(ltd.Amount,3) Amount From f_ledgertnxdetail ltd inner join f_ledgertransaction LT on ltd.LedgerTransactionNo = LT.LedgerTransactionNo inner join employee_master em on ltd.UserID = em.Employee_ID ");
                sb.Append(" inner join f_subcategorymaster sm on sm.SubCategoryID = ltd.SubCategoryID WHERE Lt.IsCancel = 0 and ltd.IsVerified = 1 and ltd.IsPackage = 0 and sm.CategoryID = '" + CategoryId.Replace("'", "''") + "' and lt.TransactionID = '" + TransID + "'");
                sb.Append(" order by ltd.ItemName ");
                break;

            default:
                sb.Append("select ltd.ItemName,ltd.Quantity,Round(ltd.Amount,3) Amount From f_ledgertnxdetail ltd inner join f_ledgertransaction LT on ltd.LedgerTransactionNo = LT.LedgerTransactionNo inner join employee_master em on ltd.UserID = em.Employee_ID ");
                sb.Append(" inner join f_subcategorymaster sm on sm.SubCategoryID = ltd.SubCategoryID WHERE Lt.IsCancel = 0 and ltd.IsVerified = 1 and ltd.IsPackage = 0 and sm.CategoryID = '" + CategoryId.Replace("'", "''") + "' and lt.TransactionID = '" + TransID + "'");
                sb.Append(" order by ltd.ItemName ");
                break;
        }

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string SaveCostEstimation(object PatientDetails, object Estimation)
    {
        List<CEPatientDetails> dataPatientDetails = new JavaScriptSerializer().ConvertToType<List<CEPatientDetails>>(PatientDetails);
        List<Estimation> dataEstimation = new JavaScriptSerializer().ConvertToType<List<Estimation>>(Estimation);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            string EstimationNo = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT Get_ID_YearWise('Cost Estimation No.',1)"));
            if (EstimationNo == "0")
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please Create The Cost Estimation No.", message = "Error In Cost Estimation No." });
            }

            for (int i = 0; i < dataEstimation.Count; i++)
            {
                excuteCMD.DML(tnx, "INSERT INTO f_costestimationBilling(EstimationNumber,PatientId,PreEstimateAmount,PreEstimateBillNo,PreEstimateTransactionID,AdditionalAmount,TotalEstimate,PatientName,Age,Gender,ContactNo,Address,DepartmentName,Quantity,Amount,AddRemarks,IsPreDefined,CentreID,EntryBy,EntryDateTime,IPAddress ,DateProcedure,Diagnosis,LengthOfStay,Remarks,CategoryId) values(@EstimationNumber,@PatientId,@PreEstimateAmount,@PreEstimateBillNo,@PreEstimateTransactionID,@AdditionalAmount,@TotalEstimate,@PatientName,@Age,@Gender,@ContactNo,@Address,@DepartmentName,@Quantity,@Amount,@AddRemarks,@IsPreDefined,@CentreID,@EntryBy,now(),@IPAddress,@DateProcedure,@Diagnosis,@LengthOfStay,@Remarks,@CategoryId) ", CommandType.Text, new
                {
                    EstimationNumber = EstimationNo,
                    PatientId = dataPatientDetails[0].PatientId,
                    PreEstimateAmount = Util.GetDecimal(dataPatientDetails[0].PreEstimateAmount),
                    PreEstimateBillNo = dataPatientDetails[0].PreEstimateBillNo,
                    PreEstimateTransactionID = dataPatientDetails[0].PreEstimateTransactionID,
                    AdditionalAmount = Util.GetDecimal(dataPatientDetails[0].AdditionalAmount),
                    TotalEstimate = Util.GetDecimal(dataPatientDetails[0].TotalEstimate),
                    PatientName = dataPatientDetails[0].PatientName,
                    Age = dataPatientDetails[0].Age,
                    Gender = dataPatientDetails[0].Gender,
                    ContactNo = dataPatientDetails[0].ContactNo,
                    Address = dataPatientDetails[0].Address,
                    DepartmentName = dataEstimation[i].DepartmentName,
                    Quantity = Util.GetDecimal(dataEstimation[i].Quantity),
                    Amount = Util.GetDecimal(dataEstimation[i].Amount),
                    AddRemarks = dataEstimation[i].Remarks,
                    IsPreDefined = Util.GetInt(dataEstimation[i].IsPreDefined),
                    CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()),
                    EntryBy = HttpContext.Current.Session["ID"].ToString(),
                    IPAddress = All_LoadData.IpAddress(),
                    DateProcedure = Util.GetDateTime(dataPatientDetails[0].DateProcedure).ToString("yyy-MM-dd"),
                    Diagnosis = dataPatientDetails[0].Diagnosis,
                    LengthOfStay = Util.GetDecimal(dataPatientDetails[0].LengthOfStay),
                    Remarks = dataPatientDetails[0].Remarks,
                    CategoryId = dataEstimation[i].CategoryId,
                });
            }

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage + " <br/>Cost Estimation No. : " + EstimationNo, message = "Record Saved Successfully", EstimationNumber = EstimationNo });

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Cost estimation Billing" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }

    public class CEPatientDetails
    {
        public string PatientId { get; set; }
        public decimal PreEstimateAmount { get; set; }
        public string PreEstimateBillNo { get; set; }
        public string PreEstimateTransactionID { get; set; }
        public decimal AdditionalAmount { get; set; }
        public decimal TotalEstimate { get; set; }
        public string PatientName { get; set; }
        public string Age { get; set; }
        public string Gender { get; set; }
        public string ContactNo { get; set; }
        public string Address { get; set; }
        public string DateProcedure { get; set; }
        public string Diagnosis { get; set; }
        public decimal LengthOfStay { get; set; }
        public string Remarks { get; set; }

    }
    public class Estimation
    {
        public string DepartmentName { get; set; }
        public decimal Quantity { get; set; }
        public decimal Amount { get; set; }
        public string Remarks { get; set; }
        public int IsPreDefined { get; set; }
        public string CategoryId { get; set; }
    }
}