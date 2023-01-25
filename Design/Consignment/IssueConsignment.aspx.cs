using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;
using System.Web.Services;
using MySql.Data.MySqlClient;
using System.Linq;
using System.Web.Script.Serialization;

public partial class Design_Consignment_IssueConsignment : System.Web.UI.Page
{
    static string vendorledgerno = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblDeptLedgerNo.Text = Session["DeptLedgerNo"].ToString();
            txtSearchModelFromDate.Text = txtSerachModelToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            calExdTxtSerachModelToDate.EndDate = calExdTxtSearchModelFromDate.EndDate = calExdTxtSerachModelToDate.EndDate = System.DateTime.Now;
        }
        txtSearchModelFromDate.Attributes.Add("readOnly", "readOnly");
        txtSerachModelToDate.Attributes.Add("readOnly", "readOnly");


        string cmd = Util.GetString(Request.QueryString["cmd"]);
        string rtrn = "[]";

        if (cmd == "item")
        {
            rtrn = makejsonoftable(medicineItemSearch(), makejson.e_with_square_brackets);
            Response.Clear();
            Response.ContentType = "application/json; charset=utf-8";
            Response.Write(rtrn);
            Response.End();
            return;
        }
    }

    public enum makejson
    {
        e_without_square_brackets,
        e_with_square_brackets
    }

    public string makejsonoftable(DataTable table, makejson e)
    {
        StringBuilder sb = new StringBuilder();
        foreach (DataRow dr in table.Rows)
        {
            if (sb.Length != 0)
                sb.Append(",");
            sb.Append("{");
            StringBuilder sb2 = new StringBuilder();
            foreach (DataColumn col in table.Columns)
            {
                string fieldname = col.ColumnName;
                string fieldvalue = dr[fieldname].ToString();
                if (sb2.Length != 0)
                    sb2.Append(",");
                sb2.Append(string.Format("\"{0}\":\"{1}\"", fieldname, fieldvalue.Replace("\n", "<br/>").Replace("\r", "<br/>")));
            }
            sb.Append(sb2.ToString());
            sb.Append("}");
        }
        if (e == makejson.e_with_square_brackets)
        {
            sb.Insert(0, "[");
            sb.Append("]");
        }
        return sb.ToString();
    }

    [WebMethod]
    public static string bindData(string patientID, string IPDNo)
    {
        string TID = string.Empty;
        if (string.IsNullOrEmpty(patientID) && string.IsNullOrEmpty(IPDNo))
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Please Enter Search Criteria" });

        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT IFNULL(pmh.IsMedCleared,0)IsMedCleared,CONCAT(pm.Title,' ',pm.PName)PName,pm.Mobile,pm.PatientID, ");
        sb.Append("pm.Age,pm.Gender,CONCAT(pm.House_No, ' ,', pm.City) Address, ");
        sb.Append("pmh.Status,pmh.TransactionID,dm.DoctorID,pmh.PatientLedgerNo,pip.RoomID,pip.IPDCaseTypeID,pmh.PanelID,pmh.Patient_Type Patient_Type,pmh.TransNo,pm.`Mobile`   ");
        sb.Append("FROM patient_medical_history pmh  "); //ipd_case_history ich
       // sb.Append("INNER JOIN f_ipdadjustment adj ON adj.Transaction_ID=ich.Transaction_ID INNER JOIN patient_medical_history pmh ON pmh.Transaction_ID=adj.Transaction_ID ");
        sb.Append("INNER JOIN patient_ipd_profile pip ON pip.TransactionID=pmh.TransactionID AND pip.Status='IN' AND pip.TobeBill=1 ");
        sb.Append("INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID ");
        sb.Append("INNER JOIN doctor_master dm ON dm.DoctorID=pmh.DoctorID ");
        sb.Append("WHERE pmh.Status='IN' ");
        if (!string.IsNullOrEmpty(IPDNo))
            sb.Append(" AND pmh.`TransNo`=" + IPDNo.Trim() + " "); //AND adj.TransactionID='ISHHI" + IPDNo.Trim() + "'
        if (!string.IsNullOrEmpty(patientID))
            sb.Append(" AND pmh.PatientID ='" + Util.GetFullPatientID(patientID.Trim()) + "' ");

        sb.Append(" AND pmh.`TYPE`='IPD' ");//

        DataTable dataTable = StockReports.GetDataTable(sb.ToString());

        if (dataTable.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = dataTable });
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "No Record Found, May be patient already discharged." });
    }

    [WebMethod(EnableSession = true)]
    public DataTable medicineItemSearch()
    {
        //string cmd, string type, string deptLedgerNo, string q, string page, string rows, string sort, string order, bool isWithAlternate, bool isBarCodeScan

        string deptLedgerNo = Util.GetString(Request.QueryString["deptLedgerNo"]);
        string type = Util.GetString(Request.QueryString["type"]);
        string q = Util.GetString(Request.QueryString["q"]);
        string order = Util.GetString(Request.QueryString["order"]);
        string sort = Util.GetString(Request.QueryString["sort"]);
        string rows = Util.GetString(Request.QueryString["rows"]);
        string CentreID = Util.GetString(Session["CentreID"]);
        DataTable dt = new DataTable();//
        StringBuilder sb = new StringBuilder();
        try
        {
            if (q != "")
            {

                if (type == "1")
                {
                    sb.Append("SELECT CONCAT(c.ItemID,'#',c.ID,'#',c.VendorLedgerNo,'#',c.TaxPer,'#',c.PurTaxAmt,'#',c.SaleTaxPer,'#',c.SaleTaxAmt,'#',c.Unit,'#',c.UnitPrice)ItemID,lm.LedgerName,c.ItemName,ROUND((c.InititalCount-c.ReleasedCount),2)AvlQty,DATE_FORMAT(c.MedExpiryDate,'%d-%b-%Y') Expiry,ROUND(c.MRP,2)MRP,c.BatchNumber,c.`IGSTPercent`,c.`CGSTPercent`,c.`SGSTPercent`,c.`GSTType` from consignmentdetail c ");
                    sb.Append("INNER JOIN f_ledgermaster lm ON lm.LedgerNumber=c.VendorLedgerNo ");
                    sb.Append("WHERE c.DeptLedgerNo = '" + deptLedgerNo.Trim() + "' AND c.CentreID=" + CentreID + "  ");
                    sb.Append("AND c.Ispost=1 and (c.InititalCount-c.ReleasedCount)>0 and if(ifnull(c.MedExpiryDate,'0001-01-01') <> '0001-01-01',MedExpiryDate>=curdate(),'1=1') ");
                    sb.Append("AND c.ItemName like '%" + q + "%'  ");
                    sb.Append("ORDER BY " + sort + " " + order + " LIMIT " + rows + " ");
                }
                if (type == "2")
                {

                }
               // return StockReports.GetDataTable(sb.ToString());
                dt = StockReports.GetDataTable(sb.ToString());//
            }

            return dt;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            throw;
        }
    }

    public class consignmentmedicine
    {
        public string consignmentdetails { get; set; }
        public decimal quantity { get; set; }
        public string supplierID { get; set; }
        public string transactionid { get; set; }
        public string deptledgerno { get; set; }
    }
    public class objectconsignmentgrnsummary
    {
        public string vendorid { get; set; }
        public string LedgerNoDr { get; set; }
        public string TypeOfTnx { get; set; }
        public decimal GrossAmount { get; set; }
        public decimal NetAmount { get; set; }
        public string InvoiceNo { get; set; }
        public string ChalanNo { get; set; }
        public decimal Freight { get; set; }
        public decimal Octori { get; set; }
        public decimal RoundOff { get; set; }
        public decimal OtherCharges { get; set; }
        public string Transaction_ID { get; set; }
        public int Panel_ID { get; set; }
        public string Patient_ID { get; set; }
        public int TransactionType_ID { get; set; }
        public string PatientType { get; set; }
        public int ConversionFactor { get; set; }
        public string DeptLedgerNo { get; set; }
    }
    public class responseresult
    {
        public bool status { get; set; }
        public string response { get; set; }
        public string message { get; set; }
        public object stockdetailsupplier { get; set; }
    }
    public class stockissueid
    {
        public string stockids { get; set; }
    }
    public class _GRNDetail
    {
        public string grnno { get; set; }
    }
    public class _stockissuedetail
    {
        public int stockid { get; set; }
        public int consignmentid { get; set; }
        public decimal issuequantity { get; set; }
    }
    public class objectconsignmentPatientIssue
    {
        public string patientid { get; set; }
        public string transactionid { get; set; }
        public int panelid { get; set; }
        public string patienttype { get; set; }
        public decimal totalamount { get; set; }
        public string deptledgerno { get; set; }
        public string IPDCaseTypeID { get; set; }
        public string RoomID { get; set; }
        public string patientledgerno { get; set; }
        public string doctorid { get; set; }
    }

    [WebMethod(EnableSession = true)]
    public static string IssueConsignmentdetail(object medicine, object patientissue)
    {
        List<consignmentmedicine> medicines = new JavaScriptSerializer().ConvertToType<List<consignmentmedicine>>(medicine);
        List<objectconsignmentPatientIssue> consignmentpatientissue = new JavaScriptSerializer().ConvertToType<List<objectconsignmentPatientIssue>>(patientissue);

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        List<_GRNDetail> grnDetailList = new List<_GRNDetail>();
        List<_stockissuedetail> stockdetailsupplier = new List<_stockissuedetail>();
        var responseobjListtest = new List<string>();
        bool patientvalidate = false;
        try
        {
            //ConsignmentGrn
            List<string> distinctVendors = medicines.Select(p => p.supplierID).Distinct().ToList();
            for (int j = 0; j < distinctVendors.Count; j++)
            {
                var vendorItems = medicines.Where(i => i.supplierID == distinctVendors[j]).ToList();
                List<string> testconid = vendorItems.Select(z => z.consignmentdetails.Split('#')[1]).Distinct().ToList();
                string consignmentids = string.Join(",", testconid);
                DataTable dtStockDetails = StockReports.GetDataTable("SELECT c.*,im.SubCategoryID,cr.ConfigID FROM consignmentdetail c INNER JOIN f_itemmaster im ON im.ItemID=c.ItemID INNER JOIN f_subcategorymaster scm ON scm.SubCategoryID=im.SubCategoryID INNER JOIN f_configrelation cr ON cr.CategoryID=scm.CategoryID WHERE c.ID IN (" + consignmentids + ") ");
                if (dtStockDetails.Rows.Count > 0)
                {
                    string LedTxnID = string.Empty, LedgerTnxNo = string.Empty, TranType = string.Empty, InvoiceNo = string.Empty, ChallanNo = string.Empty, ConID = string.Empty;
                    string HSNCode = string.Empty; string GSTType = string.Empty; string isDeal = string.Empty;

                    decimal grossamount = 0;
                    decimal netamount = 0, NAmt = 0;
                    for (int k = 0; k < dtStockDetails.Rows.Count; k++)
                    {
                        if (Util.GetInt(dtStockDetails.Rows[k]["IsFree"]) == 0)
                        {
                            decimal issuequantity = Util.GetDecimal(medicines.FirstOrDefault(x => x.consignmentdetails.Split('#')[1] == dtStockDetails.Rows[k]["ID"].ToString()).quantity);
                            
                            decimal itemamount = (Util.GetDecimal(dtStockDetails.Rows[k]["Rate"].ToString()) * issuequantity);//UnitPrice
                            decimal discamt = Util.GetDecimal(itemamount * Util.GetDecimal(dtStockDetails.Rows[k]["DiscountPer"]))/100;
                            grossamount += itemamount;
                            netamount = netamount + (itemamount + (issuequantity * Util.GetDecimal(dtStockDetails.Rows[k]["PurTaxAmt"].ToString())));
                            decimal taxper = Util.GetDecimal(dtStockDetails.Rows[k]["IGSTPercent"]) + Util.GetDecimal(dtStockDetails.Rows[k]["CGSTPercent"]) + Util.GetDecimal(dtStockDetails.Rows[k]["SGSTPercent"]);
                            decimal taxamt = ((itemamount - discamt) * taxper) / 100;
                            NAmt = NAmt + ((itemamount - discamt) + taxamt);
                        }
                    }

                    objectconsignmentgrnsummary consignmentsummary = new objectconsignmentgrnsummary
                    {
                        //18
                        vendorid = dtStockDetails.Rows[0]["VendorLedgerNo"].ToString(),
                        LedgerNoDr = "STO00001",
                        TypeOfTnx = "PURCHASE",
                        GrossAmount = grossamount,
                        NetAmount = Util.GetDecimal(Math.Round(NAmt, 0, MidpointRounding.AwayFromZero)),
                        InvoiceNo = dtStockDetails.Rows[0]["BillNo"].ToString(),
                        ChalanNo = dtStockDetails.Rows[0]["ChallanNo"].ToString(),
                        Freight = 0,
                        Octori = 0,
                        RoundOff = Util.GetDecimal(Math.Round(netamount, 0, MidpointRounding.AwayFromZero)) - grossamount,
                        OtherCharges = Util.GetDecimal(dtStockDetails.Rows[0]["OtherCharges"].ToString()),
                        ConversionFactor = 1,
                        TransactionType_ID = 18,
                        DeptLedgerNo = medicines[0].deptledgerno,
                    };

                    string result = SaveConsignmentGRN(Tranx, con, consignmentsummary, medicines, dtStockDetails, stockdetailsupplier);
                    var responseobjList = Newtonsoft.Json.JsonConvert.DeserializeObject<responseresult>(result);
                    if (!responseobjList.status)
                    {
                        Tranx.Rollback();
                        patientvalidate = false;
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = responseobjList.response, message = responseobjList.message });
                    }
                    else
                    {
                        grnDetailList.Add(new _GRNDetail
                        {
                            grnno = responseobjList.response
                        });
                        patientvalidate = true;
                    }
                }
                else
                {
                    Tranx.Rollback();
                    patientvalidate = false;
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = AllGlobalFunction.errorMessage });
                }
            }

            //ConsignmentPatientIssue
            string patientresult = SaveConsignmentPatientIssue(Tranx, con, consignmentpatientissue, stockdetailsupplier);
            var presponseobjList = Newtonsoft.Json.JsonConvert.DeserializeObject<responseresult>(patientresult);
            if (presponseobjList.status && patientvalidate)
            {
                Tranx.Commit();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage, message = presponseobjList.message, grnlist = grnDetailList });
            }
            else
            {
                Tranx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = AllGlobalFunction.errorMessage });
            }

        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = AllGlobalFunction.errorMessage });
        }
        finally
        {
            Tranx.Dispose();
            if (con.State == ConnectionState.Open)
            {
                con.Close();
                con.Dispose();
            }
        }
    }

    private static string SaveConsignmentGRN(MySqlTransaction tnx, MySqlConnection con, objectconsignmentgrnsummary consignmentsummary, List<consignmentmedicine> medicines, DataTable dtStockDetails, List<_stockissuedetail> stockdetailsupplier)
    {
        string GRNNo = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT get_Tran_idPh('" + consignmentsummary.TransactionType_ID + "','" + consignmentsummary.DeptLedgerNo + "'," + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + ")"));
        if (string.IsNullOrEmpty(GRNNo))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Kindly generate the GRN No." });
        }
        Ledger_Transaction objLedTran = new Ledger_Transaction(tnx);
        objLedTran.LedgerNoCr = consignmentsummary.vendorid;
        objLedTran.Hospital_ID = "HOS/070920/00001";
        objLedTran.LedgerNoDr = "STO00001";
        objLedTran.TypeOfTnx = "PURCHASE";
        objLedTran.Date = DateTime.Now;
        objLedTran.AgainstPONo = "";
        objLedTran.BillNo = GRNNo;
        objLedTran.GrossAmount = consignmentsummary.GrossAmount;
        objLedTran.NetAmount = consignmentsummary.NetAmount;
        objLedTran.IsCancel = 0;
        objLedTran.CancelReason = "";
        objLedTran.CancelAgainstLedgerNo = "";
        objLedTran.CancelDate = Util.GetDateTime(string.Empty);
        objLedTran.InvoiceNo = consignmentsummary.InvoiceNo;
        objLedTran.ChalanNo = consignmentsummary.ChalanNo;
        objLedTran.Time = DateTime.Now;
        objLedTran.Freight = consignmentsummary.Freight;
        objLedTran.Octori = consignmentsummary.Octori;
        objLedTran.RoundOff = consignmentsummary.RoundOff;
        objLedTran.DeptLedgerNo = consignmentsummary.DeptLedgerNo;
        objLedTran.UserID = HttpContext.Current.Session["ID"].ToString();
        objLedTran.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
        objLedTran.IpAddress = All_LoadData.IpAddress();
        objLedTran.OtherCharges = consignmentsummary.OtherCharges;
        objLedTran.TransactionType_ID = consignmentsummary.TransactionType_ID;
        objLedTran.PaymentModeID = 4;
        string LedgerTransactionNo = objLedTran.Insert().ToString();
        if (LedgerTransactionNo == string.Empty)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = AllGlobalFunction.errorMessage });
        }

        InvoiceMaster objInvMas = new InvoiceMaster(tnx);
        objInvMas.Hospital_ID = "HOS/070920/00001";
        objInvMas.InvoiceNo = consignmentsummary.InvoiceNo;
        objInvMas.InvoiceDate = Util.GetDateTime(dtStockDetails.Rows[0]["BillDate"]);
        objInvMas.ChalanNo = consignmentsummary.ChalanNo;
        objInvMas.ChalanDate = Util.GetDateTime(dtStockDetails.Rows[0]["ChallanDate"]);
        if (consignmentsummary.InvoiceNo != string.Empty)
            objInvMas.IsCompleteInvoice = "YES";
        else
            objInvMas.IsCompleteInvoice = "NO";
        objInvMas.PONumber = "";
        objInvMas.VenLedgerNo = consignmentsummary.vendorid;
        objInvMas.LedgerTnxNo = LedgerTransactionNo;
        objInvMas.InvoiceAmount = Util.GetDecimal(objLedTran.GrossAmount);
        string InvMID = objInvMas.Insert().ToString();
        if (InvMID == string.Empty)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = AllGlobalFunction.errorMessage });
        }

        for (int i = 0; i < dtStockDetails.Rows.Count; i++)
        {
            {
                try
                {
                    vendorledgerno = Util.GetString(dtStockDetails.Rows[i]["VendorLedgerNo"].ToString());
                    Stock objStock = new Stock(tnx);
                    decimal MRP = Util.GetDecimal(dtStockDetails.Rows[i]["MRP"].ToString());
                    decimal issuequantity = Util.GetDecimal(medicines.FirstOrDefault(x => x.consignmentdetails.Split('#')[1] == dtStockDetails.Rows[i]["ID"].ToString()).quantity);
                    decimal SpecialDiscPer = 0;
                    decimal SpecialDiscAmt = 0;
                    decimal Disc = 0, igstamtperunit = 0, cgstamtperunit = 0, sgstamtperunit = 0;
                    //decimal issuequantity2 = Util.GetDecimal(medicines.FirstOrDefault(x => x.consignmentdetails.Split('#')[1] == dtStockDetails.Rows[k]["ID"].ToString()).quantity);
                    
                    objStock.Hospital_ID = "HOS/070920/00001";
                    objStock.ItemID = dtStockDetails.Rows[i]["ItemID"].ToString();
                    objStock.ItemName = dtStockDetails.Rows[i]["ItemName"].ToString();
                    objStock.LedgerTransactionNo = LedgerTransactionNo;
                    objStock.BatchNumber = dtStockDetails.Rows[i]["BatchNumber"].ToString();
                    objStock.UnitPrice = Util.GetDecimal(dtStockDetails.Rows[i]["UnitPrice"].ToString());
                    objStock.MRP = MRP;
                    objStock.MajorMRP = MRP;
                    objStock.IsCountable = 1;
                    objStock.InitialCount = Util.GetDecimal(issuequantity);
                    objStock.ReleasedCount = 0;
                    objStock.IsReturn = 0;
                    objStock.LedgerNo = "";
                    objStock.MedExpiryDate = Util.GetDateTime(dtStockDetails.Rows[i]["MedExpiryDate"].ToString());
                    objStock.PostDate = DateTime.Now;
                    objStock.StockDate = DateTime.Now;
                    objStock.TypeOfTnx = "Purchase";
                    objStock.StoreLedgerNo = "STO00001";
                    objStock.IsPost = 1;
                    objStock.PostUserID = HttpContext.Current.Session["ID"].ToString();
                    objStock.Naration = "Consignment Issue";
                    objStock.IsFree = Util.GetInt(dtStockDetails.Rows[i]["IsFree"]);//
                    objStock.UserID = HttpContext.Current.Session["ID"].ToString();
                    objStock.IsBilled = 1;
                    objStock.Reusable = 0;
                    objStock.VenLedgerNo = Util.GetString(dtStockDetails.Rows[i]["VendorLedgerNo"]);
                    objStock.DiscPer = Util.GetDecimal(dtStockDetails.Rows[i]["DiscountPer"]);
                    objStock.Rate = Util.GetDecimal(dtStockDetails.Rows[i]["Rate"]) / consignmentsummary.ConversionFactor;
                    if (Util.GetDecimal(dtStockDetails.Rows[i]["DiscAmt"]) > 0)
                    {
                        Disc = (Util.GetDecimal(dtStockDetails.Rows[i]["Rate"]) * Util.GetDecimal(issuequantity)) * Util.GetDecimal(dtStockDetails.Rows[i]["DiscountPer"]) * Util.GetDecimal(0.01);
                        Disc = Disc / consignmentsummary.ConversionFactor;
                    }
                    if (SpecialDiscPer > 0)
                    {
                        SpecialDiscAmt = Util.GetDecimal((Util.GetDecimal(objStock.Rate*Util.GetDecimal(issuequantity)) - Util.GetDecimal(Disc)) * SpecialDiscPer / 100);
                    }
                    objStock.DiscAmt = Util.GetDecimal(Disc);
                    decimal taxableAmout = Util.GetDecimal(Util.GetDecimal(objStock.Rate * Util.GetDecimal(issuequantity)) - Util.GetDecimal(Disc) - Util.GetDecimal(SpecialDiscAmt));
                    objStock.TYPE = Util.GetString(dtStockDetails.Rows[i]["Type"]);
                    objStock.IGSTPercent = Util.GetDecimal(dtStockDetails.Rows[i]["IGSTPercent"]);
                    objStock.CGSTPercent = Util.GetDecimal(dtStockDetails.Rows[i]["CGSTPercent"]);
                    objStock.SGSTPercent = Util.GetDecimal(dtStockDetails.Rows[i]["SGSTPercent"]);
                    if (Util.GetInt(objStock.IsFree) == 0)
                    {
                        igstamtperunit = Math.Round(((taxableAmout * objStock.IGSTPercent) / 100) / (Util.GetDecimal(objStock.InitialCount)), 4, MidpointRounding.AwayFromZero);
                        cgstamtperunit = Math.Round(((taxableAmout * objStock.CGSTPercent) / 100) / (Util.GetDecimal(objStock.InitialCount)), 4, MidpointRounding.AwayFromZero);
                        sgstamtperunit = Math.Round(((taxableAmout * objStock.SGSTPercent) / 100) / (Util.GetDecimal(objStock.InitialCount)), 4, MidpointRounding.AwayFromZero);
                    }
                   
                    objStock.ConsignmentID = Util.GetInt(dtStockDetails.Rows[i]["ID"]);
                    objStock.taxCalculateOn = "RateAD";
                    objStock.isDeal = Util.GetString(dtStockDetails.Rows[i]["isDeal"]);
                    objStock.HSNCode = Util.GetString(dtStockDetails.Rows[i]["HSNCode"]);
                    objStock.GSTType = Util.GetString(dtStockDetails.Rows[i]["GSTType"]);
                    objStock.ConversionFactor = consignmentsummary.ConversionFactor;
                   
                    objStock.IGSTAmtPerUnit = igstamtperunit;//Math.Round(((taxableAmout * objStock.IGSTPercent) / 100) / (Util.GetDecimal(objStock.InitialCount)), 4, MidpointRounding.AwayFromZero);
                   
                    objStock.CGSTAmtPerUnit = cgstamtperunit;//Math.Round(((taxableAmout * objStock.CGSTPercent) / 100) / (Util.GetDecimal(objStock.InitialCount)), 4, MidpointRounding.AwayFromZero);
                   
                    objStock.SGSTAmtPerUnit = sgstamtperunit;// Math.Round(((taxableAmout * objStock.SGSTPercent) / 100) / (Util.GetDecimal(objStock.InitialCount)), 4, MidpointRounding.AwayFromZero);
                    objStock.SpecialDiscPer = SpecialDiscPer;
                    objStock.SpecialDiscAmt = SpecialDiscAmt;
                    objStock.Unit = Util.GetString(dtStockDetails.Rows[i]["Unit"]);
                    objStock.DeptLedgerNo = consignmentsummary.DeptLedgerNo;
                    objStock.MajorUnit = Util.GetString(dtStockDetails.Rows[i]["Unit"]);
                    objStock.MinorUnit = Util.GetString(dtStockDetails.Rows[i]["Unit"]);
                    objStock.InvoiceNo = consignmentsummary.InvoiceNo;
                    objStock.InvoiceDate = Util.GetDateTime(dtStockDetails.Rows[i]["BillDate"]);
                    objStock.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    objStock.IpAddress = All_LoadData.IpAddress();
                    objStock.IsExpirable = 1;
                    objStock.ExciseAmt = Util.GetDecimal("0");
                    objStock.ExcisePer = Util.GetDecimal("0");
                    objStock.taxCalculateOn = "RateAD";
                    objStock.ChalanNo = Util.GetString(consignmentsummary.ChalanNo);
                    objStock.ChalanDate = Util.GetDateTime(dtStockDetails.Rows[i]["ChallanDate"]);
                    objStock.InvoiceAmount = objLedTran.NetAmount;
                    objStock.OtherCharges = Util.GetDecimal(dtStockDetails.Rows[i]["OtherCharges"]) / issuequantity;
                    objStock.MarkUpPercent = Util.GetDecimal(dtStockDetails.Rows[i]["MarkUpPercent"]);
                    objStock.LandingCost = Util.GetDecimal(dtStockDetails.Rows[i]["UnitPrice"]);
                    objStock.CurrencyCountryID = Util.GetInt(dtStockDetails.Rows[i]["CurrencyCountryID"]);
                    objStock.Currency = Util.GetString(dtStockDetails.Rows[i]["Currency"]);
                    objStock.CurrencyFactor = Util.GetDecimal(dtStockDetails.Rows[i]["CurrencyFactor"]);
                    objStock.SubCategoryID = Util.GetString(dtStockDetails.Rows[i]["SubCategoryID"]);// StockReports.ExecuteScalar("Select SubCategoryID from f_itemmaster where itemid='" + dtStockDetails.Rows[i]["ItemID"] + "'");


                    objStock.PurTaxPer = objStock.IGSTPercent + objStock.CGSTPercent + objStock.SGSTPercent;//Util.GetDecimal(dtStockDetails.Rows[i]["TaxPer"]);
                    objStock.PurTaxAmt = (Util.GetDecimal((Util.GetDecimal(dtStockDetails.Rows[i]["UnitPrice"])) * Util.GetDecimal(dtStockDetails.Rows[i]["TaxPer"]) * Util.GetDecimal(0.01)) * objStock.InitialCount);
                    objStock.SaleTaxPer = Util.GetDecimal(dtStockDetails.Rows[i]["SaleTaxPer"]);
                    if (objStock.SaleTaxPer > 0)
                        objStock.SaleTaxAmt = ((Util.GetDecimal(objStock.MRP) * Util.GetDecimal(objStock.SaleTaxPer)) / 100); //Math.Round((Util.GetDecimal((objStock.MRP * 100) / (100 + objStock.SaleTaxPer)) * objStock.SaleTaxPer / 100) * Util.GetDecimal(objStock.InitialCount), 4);
                    else
                        objStock.SaleTaxAmt = 0;

                    //objStock.PurVatLine = Util.GetString(dtStockDetails.Rows[i]["PurVatLine"]);
                    //objStock.PurVatType = Util.GetString(dtStockDetails.Rows[i]["PurVatType"]);
                    //objStock.SaleVatLine = Util.GetString(dtStockDetails.Rows[i]["SaleVatLine"]);
                    //objStock.SaleVatType = Util.GetString(dtStockDetails.Rows[i]["SaleVatType"]);

                    objStock.LedgerTnxNo = "0";
                    string StockID = objStock.Insert().ToString();
                    if (StockID == string.Empty)
                    {
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = AllGlobalFunction.errorMessage });
                    }
                    else
                    {
                        stockdetailsupplier.Add(new _stockissuedetail
                        {
                            stockid = Util.GetInt(StockID),
                            consignmentid= objStock.ConsignmentID,
                            issuequantity = objStock.InitialCount
                        });
                    }
                    LedgerTnxDetail objLTDetail = new LedgerTnxDetail(tnx);

                    objLTDetail.CGSTPercent = objStock.CGSTPercent;
                    objLTDetail.IGSTPercent = objStock.IGSTPercent;
                    objLTDetail.SGSTPercent = objStock.SGSTPercent;
                    decimal igstamt = 0, cgstamt = 0, sgstamt = 0;
                    if (Util.GetInt(objStock.IsFree) == 0)
                    {
                        igstamt = Math.Round(((taxableAmout * objLTDetail.IGSTPercent) / 100), 4, MidpointRounding.AwayFromZero);
                        cgstamt = Math.Round(((taxableAmout * objLTDetail.CGSTPercent) / 100), 4, MidpointRounding.AwayFromZero);
                        sgstamt = Math.Round(((taxableAmout * objLTDetail.SGSTPercent) / 100), 4, MidpointRounding.AwayFromZero);
                    }
                    objLTDetail.Hospital_Id = "HOS/070920/00001";
                    objLTDetail.LedgerTransactionNo = LedgerTransactionNo;
                    objLTDetail.ItemID = objStock.ItemID;
                    objLTDetail.SubCategoryID = objStock.SubCategoryID;
                    objLTDetail.Rate = objStock.Rate;
                    objLTDetail.Quantity = objStock.InitialCount;
                    objLTDetail.StockID = StockID;
                    objLTDetail.ItemName = objStock.ItemName;
                    objLTDetail.EntryDate = DateTime.Now;
                    objLTDetail.UserID = HttpContext.Current.Session["ID"].ToString();
                    objLTDetail.Type_ID = objStock.TYPE;
                    objLTDetail.ToBeBilled = 1;
                    if (objStock.PurTaxPer > 0)
                        objLTDetail.IsTaxable = "YES";
                    else
                        objLTDetail.IsTaxable = "NO";

                    objLTDetail.DiscountPercentage = objStock.DiscPer;
                    objLTDetail.Amount = objStock.Rate * objStock.InitialCount;
                    objLTDetail.IsFree = objStock.IsFree;
                    objLTDetail.HSNCode = objStock.HSNCode;
                    
                    objLTDetail.IGSTAmt = igstamt;
                    
                    objLTDetail.CGSTAmt = cgstamt;
                    
                    objLTDetail.SGSTAmt = sgstamt;
                    objLTDetail.SpecialDiscPer = SpecialDiscPer;
                    objLTDetail.SpecialDiscAmt = SpecialDiscAmt;
                    objLTDetail.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    objLTDetail.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                    objLTDetail.medExpiryDate = objStock.MedExpiryDate;
                    objLTDetail.pageURL = All_LoadData.getCurrentPageName();
                    objLTDetail.NetItemAmt = objLTDetail.Amount;
                    objLTDetail.TotalDiscAmt = Util.GetDecimal(Disc);
                    objLTDetail.DiscAmt = Util.GetDecimal(Disc);
                    objLTDetail.IpAddress = All_LoadData.IpAddress();
                    objLTDetail.ConfigID = Util.GetInt(dtStockDetails.Rows[i]["ConfigID"]);
                    objLTDetail.Type = "S";
                    objLTDetail.BatchNumber = objStock.BatchNumber;
                    objLTDetail.StoreLedgerNo = "STO00001";
                    objLTDetail.DeptLedgerNo = consignmentsummary.DeptLedgerNo;
                    objLTDetail.PurTaxPer = objStock.IGSTPercent + objStock.CGSTPercent + objStock.SGSTPercent;
                    objLTDetail.PurTaxAmt = objStock.PurTaxAmt * objLTDetail.Quantity;
                    objLTDetail.unitPrice = objStock.UnitPrice;
                    objLTDetail.OtherCharges = objStock.OtherCharges;
                    objLTDetail.MarkUpPercent = objStock.MarkUpPercent;
                    objLTDetail.GSTType = Util.GetString(dtStockDetails.Rows[i]["GSTType"]);

                    string LdgTrnxDtlID = objLTDetail.Insert().ToString();
                    if (LdgTrnxDtlID == string.Empty)
                    {
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = AllGlobalFunction.errorMessage });
                    }
                    ExcuteCMD excuteCMD = new ExcuteCMD();
                    if (excuteCMD.DML(tnx, "UPDATE  f_stock s SET s.LedgerTnxNo=@ledgerTnxNo,BarcodeID=@BarcodeId WHERE s.StockID=@stockID", CommandType.Text, new
                    {
                        ledgerTnxNo = LdgTrnxDtlID,
                        stockID = StockID,
                        BarcodeId = StockID
                    }) == 0)
                    {
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = AllGlobalFunction.errorMessage });
                    };

                    string Query = "UPDATE consignmentdetail SET ReleasedCount=ReleasedCount+@initialcount WHERE ID=@ConsignmentID and ReleasedCount+@initialcount<=InititalCount ";
                    if (MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, Query,
                        new MySqlParameter("@initialcount", objStock.InitialCount),
                        new MySqlParameter("@ConsignmentID", objStock.ConsignmentID)) == 0)
                    {
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = AllGlobalFunction.errorMessage });
                    }
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = AllGlobalFunction.errorMessage });
                }
            }
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = LedgerTransactionNo, message = "Record Saved." });
    }
    private static string SaveConsignmentPatientIssue(MySqlTransaction tnx, MySqlConnection con, List<objectconsignmentPatientIssue> consignmentpatientissue, List<_stockissuedetail> stockdetailsupplier)
    {
        try
        {
            int SalesNoP = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select Get_SalesNo('1','" + AllGlobalFunction.MedicalStoreID + "','" + HttpContext.Current.Session["CentreID"].ToString() + "')"));
            if (SalesNoP == 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = AllGlobalFunction.errorMessage });
            }
            string BillNo = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "Select get_billno_store('" + consignmentpatientissue[0].deptledgerno + "','" + HttpContext.Current.Session["CentreID"].ToString() + "')").ToString();
            if (BillNo == string.Empty)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = AllGlobalFunction.errorMessage });
            }

            Ledger_Transaction objLedTranP = new Ledger_Transaction(tnx);
            objLedTranP.LedgerNoCr = consignmentpatientissue[0].patientledgerno;
            objLedTranP.LedgerNoDr = "STO00001";
            objLedTranP.Hospital_ID = "HOS/070920/00001";
            objLedTranP.GrossAmount = consignmentpatientissue[0].totalamount;
            objLedTranP.NetAmount = consignmentpatientissue[0].totalamount;
            objLedTranP.TransactionID = consignmentpatientissue[0].transactionid;
            objLedTranP.TypeOfTnx = "Sales";
            objLedTranP.PanelID = consignmentpatientissue[0].panelid;
            objLedTranP.PatientID = consignmentpatientissue[0].patientid;
            objLedTranP.Date = Util.GetDateTime(DateTime.Now.ToShortDateString());
            objLedTranP.Time = Util.GetDateTime(DateTime.Now.ToShortTimeString());
            objLedTranP.TransactionType_ID = 3;
            objLedTranP.DeptLedgerNo = consignmentpatientissue[0].deptledgerno;
            objLedTranP.UserID = Util.GetString(HttpContext.Current.Session["ID"]);
            objLedTranP.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"]);
            objLedTranP.BillNo = BillNo;
            objLedTranP.BillDate = Util.GetDateTime(DateTime.Now.ToShortDateString());
            objLedTranP.IpAddress = All_LoadData.IpAddress();
            objLedTranP.PatientType = consignmentpatientissue[0].patienttype;
            objLedTranP.OtherCharges = 0;
            string LedgertransactionNo = objLedTranP.Insert();

            if (LedgertransactionNo == string.Empty)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = AllGlobalFunction.errorMessage });
            }
            for (int p = 0; p < stockdetailsupplier.Count; p++)
            {
                DataTable dtpatientstock = StockReports.GetDataTable("SELECT c.*,im.SubCategoryID FROM consignmentdetail c INNER JOIN f_itemmaster im ON im.ItemID=c.ItemID WHERE c.ID=" + stockdetailsupplier[p].consignmentid + " AND c.ispost=1 AND (c.InititalCount-c.ReleasedCount)>0 ");
                if (dtpatientstock.Rows.Count > 0)
                {
                    LedgerTnxDetail objLTDetailP = new LedgerTnxDetail(tnx);
                    objLTDetailP.Hospital_Id = "HOS/070920/00001";
                    objLTDetailP.LedgerTransactionNo = LedgertransactionNo;
                    objLTDetailP.ItemID = dtpatientstock.Rows[0]["ItemID"].ToString();
                    objLTDetailP.SubCategoryID = dtpatientstock.Rows[0]["SubCategoryID"].ToString();
                    objLTDetailP.TransactionID = consignmentpatientissue[0].transactionid;
                    objLTDetailP.Rate = Util.GetDecimal(dtpatientstock.Rows[0]["MRP"]);
                    objLTDetailP.Quantity = Util.GetDecimal(stockdetailsupplier[p].issuequantity);
                    objLTDetailP.StockID = Util.GetString(stockdetailsupplier[p].stockid);
                    objLTDetailP.DeptLedgerNo = consignmentpatientissue[0].deptledgerno;
                    objLTDetailP.ConfigID = 11;
                    objLTDetailP.IsVerified = 1;
                    objLTDetailP.Amount = Util.GetDecimal(dtpatientstock.Rows[0]["MRP"]) * Util.GetDecimal(stockdetailsupplier[p].issuequantity);
                    objLTDetailP.ItemName = dtpatientstock.Rows[0]["ItemName"].ToString();
                    objLTDetailP.UserID = Util.GetString(HttpContext.Current.Session["ID"]);
                    objLTDetailP.EntryDate = DateTime.Now;
                    objLTDetailP.Type_ID = dtpatientstock.Rows[0]["TYPE"].ToString();
                    objLTDetailP.ToBeBilled = 1;
                    objLTDetailP.HSNCode = dtpatientstock.Rows[0]["HSNCode"].ToString();
                    objLTDetailP.GSTType = dtpatientstock.Rows[0]["GSTType"].ToString();
                    objLTDetailP.IGSTPercent = Util.GetDecimal(dtpatientstock.Rows[0]["IGSTPercent"]);
                    objLTDetailP.CGSTPercent = Util.GetDecimal(dtpatientstock.Rows[0]["CGSTPercent"]);
                    objLTDetailP.SGSTPercent = Util.GetDecimal(dtpatientstock.Rows[0]["SGSTPercent"]);
                    objLTDetailP.pageURL = All_LoadData.getCurrentPageName();
                    objLTDetailP.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                    objLTDetailP.IpAddress = All_LoadData.IpAddress();
                    objLTDetailP.Type = "I";
                    objLTDetailP.IPDCaseTypeID = consignmentpatientissue[0].IPDCaseTypeID;
                    objLTDetailP.RoomID = consignmentpatientissue[0].RoomID;
                    decimal taxableAmtP = (Util.GetDecimal(objLTDetailP.Rate) * 100 * Util.GetDecimal(Util.GetDecimal(stockdetailsupplier[p].issuequantity)) / (100 + Util.GetDecimal(dtpatientstock.Rows[0]["IGSTPercent"]) + Util.GetDecimal(dtpatientstock.Rows[0]["CGSTPercent"]) + Util.GetDecimal(dtpatientstock.Rows[0]["SGSTPercent"])));
                    decimal IGSTTaxAmountP = Math.Round(taxableAmtP * Util.GetDecimal(dtpatientstock.Rows[0]["IGSTPercent"]) / 100, 4, MidpointRounding.AwayFromZero);
                    decimal CGSTTaxAmountP = Math.Round(taxableAmtP * Util.GetDecimal(dtpatientstock.Rows[0]["CGSTPercent"]) / 100, 4, MidpointRounding.AwayFromZero);
                    decimal SGSTTaxAmountP = Math.Round(taxableAmtP * Util.GetDecimal(dtpatientstock.Rows[0]["SGSTPercent"]) / 100, 4, MidpointRounding.AwayFromZero);
                    objLTDetailP.IGSTAmt = IGSTTaxAmountP;
                    objLTDetailP.CGSTAmt = CGSTTaxAmountP;
                    objLTDetailP.SGSTAmt = SGSTTaxAmountP;
                    objLTDetailP.SpecialDiscPer = 0;
                    objLTDetailP.SpecialDiscAmt = 0;
                    objLTDetailP.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"]);
                    objLTDetailP.medExpiryDate = Util.GetDateTime(dtpatientstock.Rows[0]["MedExpiryDate"]);
                    objLTDetailP.NetItemAmt = Util.GetDecimal(dtpatientstock.Rows[0]["MRP"]) * Util.GetDecimal(stockdetailsupplier[p].issuequantity);
                    objLTDetailP.TotalDiscAmt = 0;
                    objLTDetailP.BatchNumber = dtpatientstock.Rows[0]["BatchNumber"].ToString();
                    objLTDetailP.StoreLedgerNo = "STO00001";
                    objLTDetailP.DeptLedgerNo = consignmentpatientissue[0].deptledgerno;
                    objLTDetailP.PurTaxPer = Util.GetDecimal(dtpatientstock.Rows[0]["TaxPer"]);
                    objLTDetailP.PurTaxAmt = (Util.GetDecimal(dtpatientstock.Rows[0]["PurTaxAmt"])* Util.GetDecimal(stockdetailsupplier[p].issuequantity));
                    objLTDetailP.unitPrice = Util.GetDecimal(dtpatientstock.Rows[0]["unitPrice"]);
                    objLTDetailP.OtherCharges = Util.GetDecimal(dtpatientstock.Rows[0]["OtherCharges"]);
                    objLTDetailP.MarkUpPercent = Util.GetDecimal(dtpatientstock.Rows[0]["MarkUpPercent"]);
                    if (objLTDetailP.PurTaxPer > 0)
                        objLTDetailP.IsTaxable = "YES";
                    else
                        objLTDetailP.IsTaxable = "NO";

                    //objLTDetailP.SaleVatLine = "";
                    //objLTDetailP.SaleVatType = "";
                    //objLTDetailP.SaleVatPer = 0;
                    //objLTDetailP.SaleVatAmt = 0;

                    int ID = objLTDetailP.Insert();
                    if (ID == 0)
                    {
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = AllGlobalFunction.errorMessage });
                    }

                    Sales_Details ObjSalesP = new Sales_Details(tnx);
                    ObjSalesP.Hospital_ID = "HOS/070920/00001";
                    ObjSalesP.LedgerNumber = consignmentpatientissue[0].patientledgerno;
                    ObjSalesP.DepartmentID = "STO00001";
                    ObjSalesP.ItemID = Util.GetString(dtpatientstock.Rows[0]["ItemID"]);
                    ObjSalesP.StockID = objLTDetailP.StockID;
                    ObjSalesP.SoldUnits = Util.GetDecimal(objLTDetailP.Quantity);
                    ObjSalesP.PerUnitBuyPrice = Util.GetDecimal(dtpatientstock.Rows[0]["UnitPrice"]);
                    ObjSalesP.PerUnitSellingPrice = Util.GetDecimal(dtpatientstock.Rows[0]["MRP"]);
                    ObjSalesP.Date = DateTime.Now;
                    ObjSalesP.Time = DateTime.Now;
                    ObjSalesP.IsReturn = 0;
                    ObjSalesP.LedgerTransactionNo = LedgertransactionNo;
                    ObjSalesP.UserID = HttpContext.Current.Session["ID"].ToString();
                    ObjSalesP.TrasactionTypeID = 3;
                    ObjSalesP.IsService = "NO";
                    ObjSalesP.Naration = "Consignment Stock";
                    ObjSalesP.SalesNo = SalesNoP;
                    ObjSalesP.DeptLedgerNo = consignmentpatientissue[0].deptledgerno;
                    ObjSalesP.BillNoforGP = BillNo;
                    ObjSalesP.PatientID = consignmentpatientissue[0].patientid;
                    ObjSalesP.IpAddress = All_LoadData.IpAddress();
                    ObjSalesP.LedgerTnxNo = ID;
                    ObjSalesP.Type_ID = objLTDetailP.Type_ID;
                    ObjSalesP.TransactionID = consignmentpatientissue[0].transactionid;
                    ObjSalesP.HSNCode = objLTDetailP.HSNCode;
                    ObjSalesP.GSTType = objLTDetailP.GSTType;
                    ObjSalesP.IGSTPercent = Util.GetDecimal(dtpatientstock.Rows[0]["IGSTPercent"]);
                    ObjSalesP.IGSTAmt = IGSTTaxAmountP;
                    ObjSalesP.CGSTPercent = Util.GetDecimal(dtpatientstock.Rows[0]["CGSTPercent"]);
                    ObjSalesP.CGSTAmt = CGSTTaxAmountP;
                    ObjSalesP.SGSTPercent = Util.GetDecimal(dtpatientstock.Rows[0]["SGSTPercent"]);
                    ObjSalesP.SGSTAmt = SGSTTaxAmountP;
                    ObjSalesP.LedgerTransactionNo = LedgertransactionNo;
                    ObjSalesP.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    ObjSalesP.PurTaxAmt = Util.GetDecimal(dtpatientstock.Rows[0]["PurTaxAmt"]) * Util.GetDecimal(objLTDetailP.Quantity);
                    ObjSalesP.PurTaxPer = Util.GetDecimal(dtpatientstock.Rows[0]["TaxPer"]);
                    ObjSalesP.TaxAmt = Util.GetDecimal(dtpatientstock.Rows[0]["SaleTaxAmt"]) * Util.GetDecimal(objLTDetailP.Quantity);
                    ObjSalesP.TaxPercent = Util.GetDecimal(dtpatientstock.Rows[0]["SaleTaxPer"]);
                    
                    //ObjSalesP.SaleVatPer = Util.GetDecimal(dtpatientstock.Rows[0]["SaleTaxPer"]);
                    //ObjSalesP.SaleVatAmt = Util.GetDecimal(dtpatientstock.Rows[0]["SaleTaxAmt"]) * Util.GetDecimal(objLTDetailP.Quantity);
                    //ObjSalesP.SaleVatLine = Util.GetString(dtpatientstock.Rows[0]["SaleVatLine"]);
                    //ObjSalesP.SaleVatType = Util.GetString(dtpatientstock.Rows[0]["SaleVatType"]);
                    //ObjSalesP.PurVatLine = Util.GetString(dtpatientstock.Rows[0]["PurVatLine"]);
                    //ObjSalesP.PurVatType = Util.GetString(dtpatientstock.Rows[0]["PurVatType"]);

                    string SalesIDP = ObjSalesP.Insert();
                    if (SalesIDP == string.Empty)
                    {
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = AllGlobalFunction.errorMessage });
                    }

                    string strStock = "UPDATE f_stock s SET ReleasedCount = @Soldunits WHERE StockID = @StockID";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strStock,new MySqlParameter("@Soldunits", ObjSalesP.SoldUnits),new MySqlParameter("@StockID", ObjSalesP.StockID)); 
                    
                }
            }
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage, message = LedgertransactionNo });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = AllGlobalFunction.errorMessage });
        }
    }
}