<%@ WebService Language="C#" Class="mis" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script;
using System.Data;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Text;
using MySql.Data.MySqlClient;
using System.Collections.Generic;

/// <summary>
/// Summary description for mis
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
[ScriptService]
public class mis : System.Web.Services.WebService {

    public mis () {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }

    [WebMethod]
    public string OPD_VisitWise(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_opd_statics_visitwise('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);

        if (dt.Rows.Count > 0)
        {//New Row for Total
            DataRow row = dt.NewRow();
            row["Name"] = "Total";
            row["Male"] = dt.Compute("sum(Male)", "").ToString();
            row["female"] = dt.Compute("sum(female)", "").ToString();
            row["Total"] = dt.Compute("sum(Total)", "").ToString();
            dt.Rows.Add(row);
        }
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }

    [WebMethod]
    public string Doctor_appointment(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_opd_Doctor_wise_appointment('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        if (dt.Rows.Count > 0)
        {
            //New Row for Total
            DataRow row = dt.NewRow();
            row["Doctor"] = "Total";
            row["PCount"] = dt.Compute("sum(PCount)", "").ToString();
            dt.Rows.Add(row);
        }
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }

    [WebMethod]
    public string BillingDetail(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_BillingDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "', '" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }

    [WebMethod]
    public string OPD_Procedure(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_opd_procedure('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        if (dt.Rows.Count > 0)
        {
            //New Row for Total
            DataRow row = dt.NewRow();
            row["Doctor"] = "Total";
            row["OPDProcedure"] = dt.Compute("sum(OPDProcedure)", "").ToString();
            row["Amount"] = dt.Compute("sum(Amount)", "").ToString();
            dt.Rows.Add(row);
        }
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }

    [WebMethod]
    public string CategoryAndSubCategoryWiseRevenue(string FromDate, string ToDate, int CentreID, int type)
    {
        string sql = " CALL mis_CategoryAndSubCategoryWiseRevenue('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'," + CentreID + ","+ type +") ";
        DataTable dt = StockReports.GetDataTable(sql);
        if (dt.Rows.Count > 0)
        {
            //New Row for Total
            DataRow row = dt.NewRow();
            row["DetailValue"] = "Total";
            row["OPDGrossAmount"] = dt.Compute("sum(OPDGrossAmount)", "").ToString();
            row["EMGGrossAmount"] = dt.Compute("sum(EMGGrossAmount)", "").ToString();
            row["IPDGrossAmount"] = dt.Compute("sum(IPDGrossAmount)", "").ToString();
            row["TotalGrossAmount"] = dt.Compute("sum(TotalGrossAmount)", "").ToString();
            row["OPDTotalDiscAmt"] = dt.Compute("sum(OPDTotalDiscAmt)", "").ToString();
            row["EMGTotalDiscAmt"] = dt.Compute("sum(EMGTotalDiscAmt)", "").ToString();
            row["IPDTotalDiscAmt"] = dt.Compute("sum(IPDTotalDiscAmt)", "").ToString();
            row["TotalDiscAmt"] = dt.Compute("sum(TotalDiscAmt)", "").ToString();
            row["OPDNetItemAmt"] = dt.Compute("sum(OPDNetItemAmt)", "").ToString();
            row["EMGNetItemAmt"] = dt.Compute("sum(EMGNetItemAmt)", "").ToString();
            row["IPDNetItemAmt"] = dt.Compute("sum(IPDNetItemAmt)", "").ToString();
            row["TotalNetItemAmt"] = dt.Compute("sum(TotalNetItemAmt)", "").ToString();
            dt.Rows.Add(row);
        }
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    
    
    [WebMethod]
    public string EmergencyRevenue(string FromDate, string ToDate, int CentreID)
    {
        string sql = " CALL mis_EmergencyRevenue('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'," + CentreID + ") ";
        DataTable dt = StockReports.GetDataTable(sql);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    
    

    [WebMethod]
    public string Admission(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_Admission('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        if (dt.Rows.Count > 0)
        {
            //New Row for Total
            DataRow row = dt.NewRow();
            row["RoomType"] = "Total";
            row["Admission"] = dt.Compute("sum(Admission)", "").ToString();
            dt.Rows.Add(row);
        }
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    [WebMethod]
    public string Advance_Bill_Detail(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_Advance_Bill_Detail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    [WebMethod]
    public string IPDAdvance_Bill_Detail(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_IPD_AdvanceBillDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        dt = Util.GetDataTableRowSum(dt);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    
    [WebMethod]
    public string UserWiseCollection(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_user_Collection('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        if (dt.Rows.Count > 0)
        {
            //New Row for Total
            DataRow row = dt.NewRow();
            row["Name"] = "Total";
            row["Amount"] = dt.Compute("sum(Amount)", "").ToString();
            dt.Rows.Add(row);
        }
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    [WebMethod]
    public string Discount(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_Discount('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        if (dt.Rows.Count > 0)
        {
            //New Row for Total
            DataRow row = dt.NewRow();
            row["TypeOfTnx"] = "Total";
            row["Discount"] = dt.Compute("sum(Discount)", "");
            dt.Rows.Add(row);
        }
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    
    [WebMethod]
    public string OPD_Business_CategoryWise(string FromDate, string ToDate,string CentreID)
    {
        string sql = " CALL mis_OPD_Business_CategoryWise('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }

    [WebMethod]
    public string OPD_Business_SubCategoryWise(string FromDate, string ToDate, string CategoryID, string CentreID)
    {
        string sql = " CALL mis_OPD_Business_SubCategoryWise('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CategoryID + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    [WebMethod]
    public string OPD_Business_ItemWise(string FromDate, string ToDate, string SubCategoryID)
    {
        string sql = " CALL mis_OPD_Business_ItemWise('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + SubCategoryID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        dt = Util.GetDataTableRowSum(dt);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }

    [WebMethod]
    public string IPD_Business_CategoryWise(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_IPD_Business_CategoryWise('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string IPD_Business_SubCategoryWise(string FromDate, string ToDate, string CategoryID, string CentreID)
    {
        string sql = " CALL mis_IPD_Business_SubCategoryWise('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CategoryID + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    [WebMethod]
    public string IPD_Business_ItemWise(string FromDate, string ToDate, string SubCategoryID, string CentreID)
    {
        string sql = " CALL mis_IPD_Business_ItemWise('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + SubCategoryID + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    [WebMethod]
    public string BedDetail(string CentreID)
    {
        string sql = " CALL mis_BedDetail('" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    [WebMethod]
    public string HR_Detail(string FromDate, string ToDate)
    {
        string sql = " CALL mis_HR('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    [WebMethod]
    public string Purchase_Detail(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_purchase('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    [WebMethod]
    public string Store_Detail(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_store('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    [WebMethod]
    public string OPD(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_OPD('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }

    [WebMethod]
    public string Collection_TnxWise(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_Collection_TnxWise('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "', '" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    [WebMethod]
    public string OPD_Collection(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_Collection('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    [WebMethod]
    public string OPDCollectionDetail(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_OPDCollectionDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "', '" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        dt = Util.GetDataTableRowSum(dt);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }

    //[WebMethod]
    //public string BedOccupancy_Graph(string FromDate, string ToDate, string CentreID)
    //{
    //    string sql = " CALL mis_BedOccupancy_Graph('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
    //    DataTable dt = StockReports.GetDataTable(sql);
    //    string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    //    return rtrn;
    //}
    [WebMethod]
    public string BedOccupied(string CentreID)
    {
        string sql = " CALL mis_BedOccupied('" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    [WebMethod]
    public string BedAvailable(string CentreID)
    {
        string sql = " CALL mis_BedAvailable('" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    
    [WebMethod]
    public string BedOccupancy_GraphDetails(string FromDate, string ToDate, string CentreID, string Room)
    {
        string sql = " CALL mis_BedOccupancy_GraphDetails('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + Room + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }

    [WebMethod]
    public string Admission_monthwise_graph(string FromDate, string ToDate,string CentreID)
    {
       
        string sql = " CALL mis_Admission_monthwise_graph('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
    var  rtrn= Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;       
    }
    [WebMethod]
    public string Admission_monthwise_graphDetail(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_MonthWise_AdmissionDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    [WebMethod]
    public string Discharge_monthwise_graphDetail(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_MonthWise_DischargeDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }

    
    
    [WebMethod]
    public string Discharge_monthwise_graph(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_Discharge_monthwise_graph('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    [WebMethod]
    public string IPDCollection_graph(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_IPD_Advance('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    [WebMethod]
    public string IPDCollection_graphDetail(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_IPD_AdvanceSettlementDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }

    [WebMethod]
    public string PurchaseOrder(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_PO('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID +"') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    [WebMethod]
    public string PurchaseOrderDetails(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_PODetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    
    
    [WebMethod]
    public string PurchaseOrderItemStoreWise(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_PO_Items('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    [WebMethod]
    public string PurchaseOrderItemStoreWiseDetail(string FromDate, string ToDate, string CentreID, string CategoryID)
    {
        string sql = " CALL mis_POItemWiseDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + CategoryID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    [WebMethod]
    public string PurchaseRequestStatus(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_PurchaseRequestStatus('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    [WebMethod]
    public string PurchaseOrderStatus(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_PurchaseOrderStatus('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
 

    [WebMethod]
    public string PurchaseRequestTypeWise(string FromDate, string ToDate, string CentreID, string LedgerNumber)
    {
        string sql = " CALL mis_PurchaseRequestTypeWise('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + LedgerNumber + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    [WebMethod]
    public string PurchaseOrderTypeWise(string FromDate, string ToDate, string CentreID, string VendorID)
    {
        string sql = " CALL mis_PurchaseOrderTypeWise('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + VendorID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }

    [WebMethod]
    public string PurchaseRequestTypeWiseDetails(string FromDate, string ToDate, string CentreID, string Status, string LedgerNumber)
    {
        string sql = " CALL mis_PurchaseRequestTypeWiseDetails('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + LedgerNumber + "','" + Status + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        //dt = Util.GetDataTableRowSum(dt);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }


    [WebMethod]
    public string PurchaseOrderTypeWiseDetails(string FromDate, string ToDate, string CentreID, string Status, string VendorID)
    {
        string sql = " CALL mis_PurchaseOrderTypeWiseDetails('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + VendorID + "','" + Status + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        //dt = Util.GetDataTableRowSum(dt);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }

    //Surgery_Doctor
    [WebMethod]
    public string Surgery_DoctorWise(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_Surgery_DoctorWise('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    [WebMethod]
    public string Surgery_DoctorWiseDetails(string FromDate, string ToDate, string CentreID,string DoctorId)
    {
        string sql = " CALL mis_Surgery_DoctorWiseDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + DoctorId + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        dt = Util.GetDataTableRowSum(dt);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    
    //Surgery_Department
    [WebMethod]
    public string Surgery_DeptWise(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_Surgery_DeptWise('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "', '" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }

    [WebMethod]
    public string Surgery_DeptWiseDetail(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_Surgery_DeptWiseDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "', '" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        dt = Util.GetDataTableRowSum(dt);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    //Revenue IPD
    
    [WebMethod]
    public string Revenue_DoctorWise(string FromDate, string ToDate, string CentreID,string RevenueType)
    {
        string sql = " CALL mis_Doctor_Revenue('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + RevenueType + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }

    [WebMethod]
    public string Revenue_IPD_DoctorWiseDetail(string FromDate, string ToDate, string CentreID, string RevenueType, string vid)
    {
        string sql = " CALL mis_IPDRevenueDocDetails('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + RevenueType + "','" + vid + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        dt = Util.GetDataTableRowSum(dt);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    //Revenue OPD
    
    [WebMethod]
    public string Revenue_OPD_DoctorWise(string FromDate, string ToDate, string CentreID, string RevenueType)
    {
        string sql = " CALL mis_Doctor_Revenue_OPD('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + RevenueType + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
       // string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = dt });

        return rtrn;
    }

    [WebMethod]
    public string Revenue_OPD_DoctorWiseDetail(string FromDate, string ToDate, string CentreID, string RevenueType,string vid)
    {
        string sql = " CALL mis_RevenueDocDetails('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + RevenueType + "','" + vid + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        dt = Util.GetDataTableRowSum(dt);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    //GRN
    [WebMethod]
    public string Medical_Purchase(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_Medical_purchase_qty('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    [WebMethod]
    public string GRNDetail(string FromDate, string ToDate,  string CentreID,string ItemID)
    {
        string sql = " CALL mis_GRN_Detail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + ItemID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    //GRNStaus
    [WebMethod]
    public string GRN_Status(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_GRNStatus('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }

    [WebMethod]
    public string GRN_StatusDetails(string FromDate, string ToDate, string CentreID, string Status)
    {
        string sql = " CALL mis_GRNStatusDetails('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + Status + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    
    
    [WebMethod]
    public string LeaveDetail(string FromDate, string ToDate)
    {
        string sql = " CALL mis_LeaveMonthWise('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    
    [WebMethod]
    public string General_Purchase(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_General_Purchase_qty('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    [WebMethod]
    public string Surgery_Detail(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_ipd_surgery('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    
    [WebMethod]
    public string Store_Req_Issue(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_Store_req_issue('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    [WebMethod]
    public string ConsumptionByDept(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_Consumption_Dept('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    
    [WebMethod]
    public string InvestigationDetail(string FromDate, string ToDate,string CategoryID, string CentreID)
    {
        string sql = " CALL mis_investigation_Detail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CategoryID + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    [WebMethod]
    public string PathalogyInvestigationDetail(string FromDate, string ToDate, string CategoryID, string CentreID, String Department)
    {
        string sql = " CALL mis_Pathologyinvestigation_Detail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CategoryID + "','" + CentreID + "','" + Department + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        dt = Util.GetDataTableRowSum(dt);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    [WebMethod]
    public string PathalogyDeptWiseStatus(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_PathDeptWiseStatus('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        //dt = Util.GetDataTableRowSum(dt);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    [WebMethod]
    public string PathalogyDepartmentWiseCollected(string FromDate, string ToDate, string CentreID, string ObservationType_ID)
    {
        string sql = " CALL mis_PathDepartmentCollecteddAnalysis('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + ObservationType_ID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        //dt = Util.GetDataTableRowSum(dt);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }

    [WebMethod]
    public string PathalogyDepartmentType(string FromDate, string ToDate, string CentreID, string ObservationType_ID)
    {
        string sql = " CALL mis_PathDepartmentAnalysis('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + ObservationType_ID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        //dt = Util.GetDataTableRowSum(dt);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    [WebMethod]
    public string PathDeptWisecollectedDetail(string FromDate, string ToDate, string CentreID,  string vSampleCollected,string ObservationType_ID)
    {
        string sql = " CALL mis_PathDeptWisecollectedDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + ObservationType_ID + "','" + vSampleCollected + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        //dt = Util.GetDataTableRowSum(dt);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    [WebMethod]
    public string PathalogyDepartmentTypeDetail(string FromDate, string ToDate, string CentreID, string vSampleCollected, string ObservationType_ID, string type)
    {
        string sql = " CALL mis_PathDeptWiseApprovedDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + ObservationType_ID + "','" + vSampleCollected + "','"+ type +"') ";
        DataTable dt = StockReports.GetDataTable(sql);
        //dt = Util.GetDataTableRowSum(dt);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    

    [WebMethod]
    public string Radiologyinvestigation(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_Radiologyinvestigation('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }

    [WebMethod]
    public string RadiologyDeptWiseStatus(string FromDate, string ToDate,  string CentreID)
    {
        string sql = " CALL mis_RadioDeptWiseStatus('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        //dt = Util.GetDataTableRowSum(dt);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }

    [WebMethod]
    public string RadiologyDepartmentWiseCollected(string FromDate, string ToDate, string CentreID, string ObservationType_ID)
    {
        string sql = " CALL mis_RadioDepartmentCollecteddAnalysis('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + ObservationType_ID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }

    [WebMethod]
    public string RadiologyDepartmentType(string FromDate, string ToDate, string CentreID, string ObservationType_ID)
    {
        string sql = " CALL mis_RadioDepartmentAnalysis('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + ObservationType_ID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }

    [WebMethod]
    public string RadioDeptWisecollectedDetail(string FromDate, string ToDate, string CentreID, string vSampleCollected, string ObservationType_ID, string type)
    {
        string sql = " CALL mis_RadioDeptWiseCollectedDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + ObservationType_ID + "','" + vSampleCollected + "','" + type + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    [WebMethod]
    public string RadiologyDepartmentTypeDetail(string FromDate, string ToDate, string CentreID, string vSampleCollected, string ObservationType_ID)
    {
        string sql = " CALL mis_RadioDeptWiseApprovedDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + ObservationType_ID + "','" + vSampleCollected + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
        
    [WebMethod]
    public string RadiologyinvestigationDetail(string FromDate, string ToDate, string CentreID, String Department)
    {
        string sql = " CALL mis_RadiologyinvestigationDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + Department + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        dt = Util.GetDataTableRowSum(dt);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    
    [WebMethod]
    public string OPD_Graph(string CentreID)
    {
        string sql = " CALL mis_OPD_Graph('" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }

    [WebMethod]
    public string OPD_Graph_Month(string CentreID)
    {
        string sql = " CALL mis_OPD_Graph_Month('" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }

    [WebMethod]
    public string OPD_Graph_Year(string CentreID)
    {
        string sql = " CALL mis_OPD_Graph_Year('" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    [WebMethod]
    public string Employee_Gradewise()
    {
        string sql = " CALL mis_Employee_Gradewise() ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    [WebMethod]
    public string Department_wise_Employee()
    {
        string sql = " CALL mis_Department_wise_Employee() ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    [WebMethod]
    public string Employee_Detail(string Grade,string Type)
    {
        string sql = string.Empty;
        if (Type == "Department")
        {
            sql = " CALL mis_Employee_Department('" + Grade + "') ";
        }
        else
        {
            sql = " CALL mis_Employee_Grade('" + Grade + "') ";
        }
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    
    [WebMethod]
    public string Sale_DateWise(string CentreID)
    {
        string sql = " CALL mis_Sale_Date('" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }

    [WebMethod]
    public string Sale_MonthWise(string CentreID)
    {
        string sql = " CALL mis_Sale_month('" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }

    [WebMethod]
    public string Sale_PatientWise(string CentreID)
    {
        string sql = " CALL mis_Sale_Patient('" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    [WebMethod]
    public string Salary_DeptWise(string SalaryMonth)
    {
        string sql = " CALL mis_DeptWiseSalary('" + Util.GetDateTime(SalaryMonth).ToString("yyyy-MM-dd") + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    [WebMethod]
    public string MonthLeaveDetail(string SelectedMonth)
    {
        string sql = " CALL mis_LeaveDetail('" + Util.GetDateTime(SelectedMonth).ToString("yyyy-MM-dd") + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    
    
    [WebMethod(EnableSession=true)]    
    public string Load_mis_tab(int UserSettingAvail)
    {
        string sql = string.Empty;
        if (UserSettingAvail == 0)
        {
            sql = "SELECT *,1 IsVisible FROM mis_setting ORDER BY RowNo,ColumnNo ";
        }
        else
        {
            sql = " SELECT m.ID,Title,Div_ID,u.RowNo,u.ColumnNo,IsVisible FROM mis_setting m INNER JOIN mis_user_setting u ON m.ID=u.MasterID WHERE UserID='" + Session["ID"].ToString() + "' ORDER BY u.RowNo,u.ColumnNo ";
        }
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    [WebMethod]
    public string InsertUserSetting(int RowNo, int ColumnNo, int MasterID, string UserID, int IsVisible)
    {
        string sql = " INSERT INTO mis_user_setting(MasterID,RowNo,ColumnNo,UserID,IsVisible)VALUES(" + MasterID + "," + RowNo + "," + ColumnNo + ",'" + UserID + "'," + IsVisible + ") ";
        bool flag= StockReports.ExecuteDML(sql);

        return flag.ToString();
    }

    [WebMethod]
    public string DeleteUserSetting(string UserID)
    {
        string sql = " DELETE FROM mis_user_setting WHERE userID='" + UserID + "'";
        bool flag = StockReports.ExecuteDML(sql);

        return flag.ToString();
    }
    [WebMethod]
    public string BindMISCenter(string UserID)
    {
        DataTable dtCenter = All_LoadData.dtbind_Centre(UserID);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtCenter);
        
    }
    [WebMethod]
    public string IPDAdmissionType(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_IPDAdmissionType('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        return  Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sql));
       
    }
    [WebMethod]
    public string IPDAdmissionTypeDetail(string FromDate, string ToDate, string CentreID,string AdmissionType)
    {
        string sql = " CALL mis_IPDAdmissionTypeDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + AdmissionType + "') ";
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sql));

    }
    [WebMethod]
    public string StateAnalysis(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_StateAnalysis('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sql));

    }
    [WebMethod]
    public string DistrictAnalysis(string FromDate, string ToDate, string CentreID,string State)
    {
        string sql = " CALL mis_DistrictAnalysis('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + State + "') ";
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sql));

    }
    [WebMethod]
    public string CityTableDetails(string FromDate, string ToDate, string CentreID, string districtID)
    {
        string sql = " CALL mis_RefDocWiseCollectionDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + districtID + "') ";
        //return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sql));
        DataTable dt = StockReports.GetDataTable(sql);
        dt = Util.GetDataTableRowSum(dt);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);

        return rtrn;

    }
    [WebMethod]
    public string CityWiseRefDoc(string FromDate, string ToDate, string CentreID, string District)
    {
        string sql = " CALL mis_CityWiseRefDoc('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + District + "') ";
       // return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sql));
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;

    }
    [WebMethod]
    public string CityWiseCollection(string FromDate, string ToDate, string CentreID, string District)
    {
        string sql = " CALL mis_CityWiseCollection('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + District + "') ";
       // return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sql));
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;

    }  
    [WebMethod]
    public string TAT_Appointment(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_TAT_Appointment('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    
     [WebMethod]
    public string TAT_Investigation(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_TAT_Investigation('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }

[WebMethod]
    public string Conversion(string FromDate, string ToDate, string CentreID)
    {
        string sql = " CALL mis_Conversion('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
[WebMethod]
public string TopSaleDetail(string FromDate, string ToDate, string CentreID,string ItemID)
{
    string sql = " CALL `mis_TopSaleDetail`('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + ItemID + "') ";
    DataTable dt = StockReports.GetDataTable(sql);
    string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    return rtrn;
}
[WebMethod]
public string TopPurchaseDetail(string FromDate, string ToDate, string CentreID, string ItemID)
{
    string sql = " CALL `mis_TopPurchase`('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + ItemID + "') ";
    DataTable dt = StockReports.GetDataTable(sql);
    dt = Util.GetDataTableRowSum(dt);
    string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    return rtrn;
}
[WebMethod]
public string DoctorStatisticsDetail(string FromDate, string ToDate, string CentreID, string Doctor)
{
    string sql = " CALL `mis_DoctorStatistics`('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + Doctor + "') ";
    DataTable dt = StockReports.GetDataTable(sql);
    string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    return rtrn;
}
[WebMethod]
public string TopVendorDetail(string FromDate, string ToDate, string CentreID, string Vendor)
{
    string sql = " CALL `mis_topVendor`('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + Vendor + "') ";
    DataTable dt = StockReports.GetDataTable(sql);
    dt = Util.GetDataTableRowSum(dt);
    string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    return rtrn;
}
    
    
[WebMethod]
public string UserWiseDetail(string FromDate, string ToDate, string CentreID, string Employee)
{
    string sql = " CALL `mis_UserWiseSaleDetail`('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + Employee + "') ";
    DataTable dt = StockReports.GetDataTable(sql);
    dt = Util.GetDataTableRowSum(dt);
    string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    return rtrn;
}
[WebMethod]
public string SalesTrendDetail(string Year,string CentreID)
{
    string sql = " CALL `mis_SalesTradeDetail`('" + Year + "','" + CentreID + "') ";
    DataTable dt = StockReports.GetDataTable(sql);
      dt = Util.GetDataTableRowSum(dt);
    string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    return rtrn;
}
    //Emergency
[WebMethod]
public string EMGBedOccupied(string FromDate, string ToDate, string CentreID)
{
    string sql = " CALL mis_EMGBedOccupied('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
    DataTable dt = StockReports.GetDataTable(sql);
    string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    return rtrn;
}
[WebMethod]
public string EMGBedOccupiedDetails(string FromDate, string ToDate, string CentreID)
{
    string sql = " CALL mis_EMGBedOccupiedDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
    DataTable dt = StockReports.GetDataTable(sql);
    string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    return rtrn;

}
    
    
[WebMethod]
public string EMGAdmissionType(string FromDate, string ToDate, string CentreID)
{
    string sql = " CALL mis_EMGAdmissionType('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
    return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sql));

}
[WebMethod]
public string EMGAdmissionTypeDetail(string FromDate, string ToDate, string CentreID, string AdmissionType)
{
    string sql = " CALL mis_EMGAdmissionTypeDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + AdmissionType + "') ";
    return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sql));

}
[WebMethod]
public string EMGAdmissionTypeWsie(string FromDate, string ToDate, string CentreID)
{
    string sql = " CALL mis_EMGPatientTypeStatus('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
    DataTable dt = StockReports.GetDataTable(sql);
    string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    return rtrn;

}
[WebMethod]
public string EMGBillNotGenTypeWsie(string FromDate, string ToDate, string CentreID)
{
    string sql = " CALL mis_EMGReleasedTypeStatus('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
    DataTable dt = StockReports.GetDataTable(sql);
    string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    return rtrn;

}
[WebMethod]
public string EMGAdmitDischargeTypeDetail(string FromDate, string ToDate, string CentreID, string Type)
{
    string sql = " CALL mis_EMGadmitDischargeTypeDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + Type + "') ";
    DataTable dt = StockReports.GetDataTable(sql);
    string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    return rtrn;
}

[WebMethod]
public string EMGBillNotGenTypeWsieDetails(string FromDate, string ToDate, string CentreID)
{
    string sql = " CALL mis_EMGReleasedTypeStatusDetails('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
    DataTable dt = StockReports.GetDataTable(sql);
    string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    return rtrn;

}

[WebMethod]
public string EMGCollection_graph(string FromDate, string ToDate, string CentreID)
{
    string sql = " CALL mis_EMG_Collection('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
    DataTable dt = StockReports.GetDataTable(sql);
    string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    return rtrn;
}

[WebMethod]
public string EMGCollection_graphDetails(string FromDate, string ToDate, string CentreID)
{
    string sql = " CALL mis_EMGCollectionDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
    DataTable dt = StockReports.GetDataTable(sql);
    string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    return rtrn;
}
//EMGRevenue
[WebMethod]
public string EMGRevenue(string FromDate, string ToDate, string CentreID, string RevenueType)
{
   
    string sql = " CALL mis_EMG_Revenue('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + RevenueType + "') ";
    DataTable dt = StockReports.GetDataTable(sql);
    string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    return rtrn;
}

[WebMethod]
public string EMGRevenueDetails(string FromDate, string ToDate, string CentreID, string RevenueType, string vid)
{
    string sql = " CALL mis_EMGRevenueDetails('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + RevenueType + "','" + vid + "') ";
    DataTable dt = StockReports.GetDataTable(sql);
    dt = Util.GetDataTableRowSum(dt);
    string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    return rtrn;
}
  
[WebMethod(EnableSession=true)]
public string exportToExcel(string Type, string FromDate, string ToDate, string CentreID, string RevenueType, string selectedValue, string emgScreen, string CategoryID, string selectedID, string Pathtype, string Year,int formateType)
{
    
    string Sql = ""; string reportName = "";
    if (Type == "Analysis")
    {
        reportName = "Analysis";
        Sql = " CALL mis_RefDocWiseCollectionDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + selectedValue + "') ";

    }
    else if (Type == "OPDCollection")
    {
        reportName = "OPDCollection";
        Sql = " CALL mis_OPDCollectionDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";

    }
    else if (Type == "OPDBusiness")
    {
        reportName = "OPD_Business_ItemWise";
        Sql = " CALL mis_OPD_Business_ItemWise('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + selectedValue + "') ";

    }
    else if (Type == "OPDRevenue")
    {
        reportName = RevenueType + " OPD Revenue";
        Sql = " CALL mis_RevenueDocDetails('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + RevenueType + "','" + selectedValue + "') ";

    }
else if (Type == "BedOccupancy")
    {
        reportName = "BedOccupancy";
        Sql = " CALL mis_BedOccupancy_GraphDetails('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + selectedValue + "') ";

    }
    else if (Type == "AdmitDischarge" )
    {
        if (selectedValue == "AdmittedMonthWiseDetail")
        {
            reportName = "AdmittedMonthWise";
            Sql = " CALL mis_MonthWise_AdmissionDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        }
        else if (selectedValue == "DischargeMonthWiseDetail")
        {
            reportName = "DischargeMonthWise";
            Sql = " CALL mis_MonthWise_DischargeDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        }
    }
    else if (Type == "IPDCollection")
    {
        reportName = "IPDCollection";
        Sql = " CALL mis_IPD_AdvanceSettlementDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";

    }
    else if (Type == "IPDSurgeryDoc")
    {
        reportName = "IPDSurgeryDoctorWise";
        Sql = " CALL mis_Surgery_DoctorWiseDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + selectedValue + "') ";

    }

    else if (Type == "IPDSurgeryDpt")
    {
        reportName = "IPDSurgeryDepartmentWise";
        Sql = " CALL mis_Surgery_DeptWiseDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";

    }
    else if (Type == "IPDRevenue")
    {
        reportName = RevenueType + " IPD Revenue";
        Sql = " CALL mis_IPDRevenueDocDetails('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + RevenueType + "','" + selectedValue + "') ";

    }
    else if (Type == "IPDbusiness")
    {
        reportName = "IPDBusinessItemWise";
        Sql = " CALL mis_IPD_Business_ItemWise('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + selectedValue + "','" + CentreID + "') ";

    }
    else if (Type == "IPDAdvanceBill")
    {
        reportName = "IPDAdvanceBill";
        Sql = " CALL mis_IPD_AdvanceBillDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";

    }
    else if (Type == "IPDAdmissionType")
    {
        reportName = "IPDAdmissionTypeWise";
        Sql = " CALL mis_IPDAdmissionTypeDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + selectedValue + "') ";

    }
    else if (Type == "EMGBedOccupancy")
    {
        if (emgScreen == "EMGBedOccupied")
        {
        reportName = "EMGBedOccupied";
        Sql = " CALL mis_EMGBedOccupiedDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        }
        else if (emgScreen == "EMGAdmission")
        {
            reportName = "EMGAdmission";
            Sql = " CALL mis_EMGAdmissionTypeDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + selectedValue + "') ";
        }
        else if (emgScreen == "EMGAdmitted")
        {
            reportName = "EMGAdmitDischarge";
            Sql = " CALL mis_EMGadmitDischargeTypeDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + selectedValue + "') ";
        }
        else if (emgScreen == "emgBillNotGen")
        {
            reportName = "EMGBillNotGenerated";
            Sql = " CALL mis_EMGReleasedTypeStatusDetails('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        }
    }
    else if (Type == "EMGCollection")
    {
        reportName = "EMGCollection";
        Sql = " CALL mis_EMGCollectionDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
    }
    else if (Type == "EMGRevenue")
    {
        reportName = RevenueType + " EMG Revenue";
        Sql = " CALL mis_EMGRevenueDetails('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + RevenueType + "','" + selectedValue + "') ";

    }
    
       else if (Type == "PathInvestigation")
    {
        reportName = "PathInvestigation";
        Sql = " CALL mis_Pathologyinvestigation_Detail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CategoryID + "','" + CentreID + "','" + selectedValue + "') ";

    }
    else if (Type == "PathDepartmentWiseStatus")
    {
        if (emgScreen == "DeptType")
        {
            reportName = "PathDepartmentTypeWiseStatus";
            Sql = " CALL mis_PathDeptWiseApprovedDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + selectedID + "','" + selectedValue + "','" + Pathtype + "') ";
        }
        else if (emgScreen == "DeptCollection")
        {
            reportName = "PathDepartmentWiseStatus";
            Sql = " CALL mis_PathDeptWisecollectedDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + selectedID + "','" + selectedValue + "') ";
        }
    }
    else if (Type == "RadioInvestigation")
    {
        reportName = "RadioInvestigation";
        Sql = " CALL mis_RadiologyinvestigationDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + selectedValue + "') ";

    }
    else if (Type == "RadioDepartmentWiseStatus")
    {
        if (emgScreen == "DeptType")
        {
            reportName = "RadioDepartmentTypeWiseStatus";
            Sql = " CALL mis_RadioDeptWiseApprovedDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + selectedID + "','" + selectedValue + "') ";
        }
        else if (emgScreen == "DeptCollection")
        {
            reportName = "RadioDepartmentWiseStatus";
            Sql = " CALL mis_RadioDeptWiseCollectedDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + selectedID + "','" + selectedValue + "','" + Pathtype + "') ";
        }
    }
    else if (Type == "GRNStatus")
    {
        reportName = "GRNStatus";
        Sql = " CALL mis_GRNStatusDetails('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + selectedValue + "') ";

    }  

    else if (Type == "PurchageOrder")
    {
        if (emgScreen == "PurchaseOrder")
        {
            reportName = "PurchageOrder";
            Sql = " CALL mis_PODetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";
        }
        else if (emgScreen == "POItemwise")
        {
            reportName = "POItemwise";
            Sql = " CALL mis_POItemWiseDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + selectedValue + "') ";

        }
    }
    else if (Type == "PurchageOrderStatus")
    {
        if (emgScreen == "PRType")
        {
            reportName = "PurchageRequestStatus";
            Sql = " CALL mis_PurchaseRequestTypeWiseDetails('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + selectedID + "','" + selectedValue + "') ";
        }
        else if (emgScreen == "POType")
        {
            reportName = "PurchageOrderStatus";
            Sql = " CALL mis_PurchaseOrderTypeWiseDetails('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + selectedID + "','" + selectedValue + "') ";

        }
        
    }  
              
    else if (Type == "GRN")
    {
        reportName = "GRN";
        Sql = " CALL mis_GRN_Detail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + selectedValue + "') ";

    }

    else if (Type == "Consumption")
    {
        reportName = "Consumption";
        Sql = " CALL mis_Consumption_Dept('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "') ";

    }

    else if (Type == "TopSale")
    {
        reportName = "TopSaleProduct";
        Sql = " CALL mis_TopSaleDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + selectedValue + "') ";

    }

    else if (Type == "TopBuy")
    {
        reportName = "TopBuyProduct";
        Sql = " CALL mis_TopPurchase('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + selectedValue + "') ";

    }
    else if (Type == "DoctorStatistics")
    {
        reportName = "DoctorStatistics";
        Sql = " CALL mis_DoctorStatistics('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + selectedValue + "') ";

    }
    else if (Type == "TopVendors")
    {
        reportName = "TopVendors";
        Sql = " CALL mis_topVendor('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + selectedValue + "') ";

    }
    else if (Type == "UserWiseSale")
    {
        reportName = "UserWiseSale";
        Sql = " CALL mis_UserWiseSaleDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + selectedValue + "') ";

    }
    else if (Type == "UserWiseSale")
    {
        reportName = "UserWiseSale";
        Sql = " CALL mis_UserWiseSaleDetail('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "','" + CentreID + "','" + selectedValue + "') ";

    }
    else if (Type == "SalesTrend")
    {
        reportName = "SalesTrend";
        Sql = " CALL mis_SalesTradeDetail('" + Year + "','" + CentreID + "') ";

    }
           
    DataTable dt = StockReports.GetDataTable(Sql);

    if (dt.Rows.Count > 0)
    {

        DataColumn dc = new DataColumn();
        dc.ColumnName = "Period";
        dc.DefaultValue = "From Date : " + Util.GetDateTime(FromDate).ToString("dd-MMM-yyyy") + ""+ " " +"To Date : " + Util.GetDateTime(ToDate).ToString("dd-MMM-yyyy") + "";

        dt.Columns.Add(dc);
        dt = Util.GetDataTableRowSum(dt);
       
        string CacheName = HttpContext.Current.Session["ID"].ToString();
      Common.CreateCachedt(CacheName, dt);
        string ReportName = reportName + " Detail`s";
        if (formateType == 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, URL = "../../Design/commonReports/Commonreport.aspx?ReportName=" + ReportName + "&Type=E" });
        }
        else if (formateType == 1)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, URL = "../../Design/CommonReports/ConvertHTMLToPDF.aspx?ReportName=" + ReportName + "&Type=P" });
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Please Select FormateType" });
    }
    else
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "No Record Found" });
    }
}
    
}
