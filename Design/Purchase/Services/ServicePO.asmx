<%@ WebService Language="C#" Class="ServicePO" %>
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;


[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class ServicePO : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }

    [WebMethod]
    public string BindCentre()
    {
        DataTable dt = All_LoadData.dtbind_Center();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public string BindRequestType()
    {
        DataTable dt = AllLoadData_Store.dtTypeMaster();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public string BindSupplier()
    {
        DataTable dt = AllLoadData_Store.dtStore("VEN");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public string BindStoreType()
    {
        string str = "SELECT LedgerName,LedgerNumber from f_ledgermaster Where GroupID='STO' ";
        DataTable dt = StockReports.GetDataTable(str);

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    
    [WebMethod(EnableSession = true)]
    public string BindItem()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT IM.Typename,IM.ItemID  FROM f_itemmaster im  ");
        sb.Append(" INNER JOIN `f_itemmaster_centerwise` itc ON itc.`ItemID`=im.`ItemID` ");
        sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=im.SubCategoryID ");
        sb.Append(" INNER JOIN f_configrelation cf ON cf.CategoryID=sc.CategoryID ");
        sb.Append(" WHERE cf.ConfigID IN (11,28) AND im.IsStockable=0 AND im.Isactive=1 AND itc.`IsActive`=1 AND itc.`CentreID`= '" + HttpContext.Current.Session["CentreID"].ToString() + "'  order by IM.Typename  ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public string bindPoDetails(string poNumber)
    {
        string SQL = "select p.PurchaseOrderDetailID,p.ItemID,p.ItemName,p.OrderedQty,p.ApprovedQty,p.RecievedQty,p.RejectQty,round((p.ApprovedQty-p.RecievedQty-p.RejectQty),2) PendingQty,(p.Amount/p.OrderedQty)Amount from f_purchaseorderdetails p inner join f_purchaseorder pd on pd.PurchaseOrderNo=p.PurchaseOrderNo where p.PurchaseOrderNo='" + poNumber + "' order by p.ItemName ";
        DataTable dt = StockReports.GetDataTable(SQL);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public string bindPoClosedDetails(string poNumber)
    {
        string SQL = "SELECT s.POCloseNumber, s.PONumber,CONCAT(em.Title,' ',em.Name)EmployeeName,DATE_FORMAT(s.EntryDateTime,'%d-%b-%Y %I:%i %p')EntryDateTime,s.Remarks,SUM(s.Amount)Amount,s.InvoiceNumber,DATE_FORMAT(s.InvoiceDate,'%d-%b-%Y')InvoiceDate FROM f_ServicePoClosed s INNER JOIN employee_master em ON em.EmployeeID=s.EntryBy WHERE s.PONumber='" + poNumber + "' group by s.POCloseNumber order by s.Id ";
        DataTable dt = StockReports.GetDataTable(SQL);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


    [WebMethod(EnableSession = true)]
    public string bindServicePO(int centreId, string poNumber, string requestType, string itemId, string vendorId, string status, string storeType, string fromDate, string toDate, string filterType)
    {
        string SQL = "select distinct(PO.PurchaseOrderNo),PO.NetTotal,PO.GrossTotal,(po.GrossTotal-po.NetTotal)Discount,PO.Subject,PO.VendorName,date_format(PO.RaisedDate,'%d-%b-%Y')RaisedDate,PO.Type,(case when Po.Status = 0 then 'Pending' when Po.Status = 1 then 'Rejected' when Po.Status = 2 then 'Approved' when Po.Status = 3 then 'Close' end )Status,(CASE WHEN Po.Status = 0 THEN 'lightblue' WHEN Po.Status = 1 THEN 'LightPink' WHEN Po.Status = 2 THEN 'yellow' WHEN Po.Status = 3 THEN 'yellowgreen' END )StatusColor FROM f_purchaseorder PO INNER JOIN f_purchaseorderdetails POD on PO.PurchaseOrderNo=POD.PurchaseOrderNo WHERE PO.Approved=2 and PO.IsService=1 AND PO.DeptLedgerNo='" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "'  AND PO.RaisedDate >='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND PO.RaisedDate <='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + " 23:59:59' ";

        if (storeType != "0")
            SQL += " and po.StoreLedgerNo='" + storeType + "' ";
        if (poNumber != string.Empty)
            SQL += " and po.PurchaseOrderNo='" + poNumber + "' ";

        if (status != "5")
        {
            SQL += " and po.Status='" + status + "' ";

            if (requestType == "1")
                SQL += " and po.Status='2' ";
            else
                SQL += " and po.Status='0' ";
        }


        if (requestType != "0")
            SQL += " and Type ='" + requestType + "' ";
        if (vendorId != "0")
            SQL += " and  PO.VendorID ='" + vendorId + "' ";
        if (itemId != "0" && itemId != null)
            SQL += " and POD.ItemID ='" + itemId + "' ";

        if (filterType != "All")
            SQL += " having Status='" + filterType + "' ";

        DataTable dt = StockReports.GetDataTable(SQL);

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }



    [WebMethod]
    public string serviceOrderMapStatus(object servicePONumber)
    {

        string AgainstPurchaseOrder = Util.GetString(StockReports.ExecuteScalar("SELECT P.AgainstPurchaseOrder FROM poagainstpomapping p WHERE p.PurchaseOrder='" + servicePONumber + "' AND p.IsActive=1 LIMIT 1 "));

        if (AgainstPurchaseOrder != string.Empty)
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AgainstPurchaseOrder, message = "This Service PO is map with Purchase Order : " + AgainstPurchaseOrder + "." });
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "", message = "PO is not map with any Purchase Order. " });

    }
    
    [WebMethod(EnableSession = true)]
    public string serviceOrderClose(object servicePODetails, string againstPO)
    {
        int statusNew = 0;
        List<servicePO> SPO = new JavaScriptSerializer().ConvertToType<List<servicePO>>(servicePODetails);
        
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            string ServicePOCloseNumber = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select get_ServicePoClose_No('Service PO Close No.'," + HttpContext.Current.Session["CentreID"].ToString() + ") "));
            string VenderLedgerNo = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT po.VendorID FROM f_purchaseorder po WHERE po.PurchaseOrderNo='" + SPO[0].PONumber + "' "));
            
            for (int i = 0; i < SPO.Count; i++)
            {
                decimal PendingQty = Util.GetDecimal(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select round((p.ApprovedQty-p.RecievedQty-p.RejectQty),2) PendingQty from f_purchaseorderdetails p where p.PurchaseOrderDetailID=" + Util.GetInt(SPO[i].PODetailId) + " "));
                if (PendingQty >= (Util.GetDecimal(SPO[i].ClosedQty) + Util.GetDecimal(SPO[i].RejectedQty)))
                {
                    if (PendingQty == (Util.GetDecimal(SPO[i].ClosedQty) + Util.GetDecimal(SPO[i].RejectedQty)))
                        statusNew = 1;
                    var opo = new
                    {
                        PONumber = SPO[i].PONumber,
                        PODetailId = Util.GetInt(SPO[i].PODetailId),
                        ItemId = Util.GetString(SPO[i].ItemId),
                        Amount = Util.GetDecimal(SPO[i].Amount),
                        ClosedQty = Util.GetDecimal(SPO[i].ClosedQty),
                        RejectedQty = Util.GetDecimal(SPO[i].RejectedQty),
                        DeptLedgerNo = HttpContext.Current.Session["DeptLedgerNo"].ToString(),
                        CentreId = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()),
                        EntryBy = HttpContext.Current.Session["ID"].ToString(),
                        IPAddress = All_LoadData.IpAddress(),
                        InvoiceNumber = SPO[i].InvoiceNumber,
                        InvoiceDate = SPO[i].InvoiceDate,
                        Remarks = SPO[i].Remarks,
                        POCloseNumber = ServicePOCloseNumber,
                        VenLedgerNo = VenderLedgerNo
                    };
                    excuteCMD.DML(tnx, "INSERT INTO f_ServicePoClosed(PONumber,PODetailId,ItemId,Amount,ClosedQty,RejectedQty,CentreId,DeptLedgerNo,EntryBy,EntryDateTime,IPAddress,Remarks,POCloseNumber,InvoiceNumber,InvoiceDate,VenLedgerNo) VALUES(@PONumber,@PODetailId,@ItemId,@Amount,@ClosedQty,@RejectedQty,@CentreId,@DeptLedgerNo,@EntryBy,now(),@IPAddress,@Remarks,@POCloseNumber,@InvoiceNumber,@InvoiceDate,@VenLedgerNo) ", CommandType.Text, opo);

                    MySqlHelperNEw.ExecuteNonQuery(tnx, CommandType.Text, "update f_purchaseorderdetails P set p.RecievedQty=p.RecievedQty+" + Util.GetDecimal(SPO[i].ClosedQty) + ",p.RejectQty=p.RejectQty+" + Util.GetDecimal(SPO[i].RejectedQty) + " ,p.Status=" + statusNew + " WHERE p.PurchaseOrderDetailID=" + Util.GetInt(SPO[i].PODetailId) + " ");
                }
                else
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "This PO Already Closed Previously. Kindly Re-search Again", message = "This PO Already Closed Previously. Kindly Re-search Again" });
                }

            }

            int IsPendingClose = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) FROM f_purchaseorderdetails WHERE PurchaseOrderNo ='" + SPO[0].PONumber + "' AND STATUS = 0  "));
            if (IsPendingClose == 0)
                MySqlHelperNEw.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_purchaseorder SET STATUS = 3 WHERE PurchaseOrderNo ='" + SPO[0].PONumber + "' ");


            //  Devendra Singh 2019-01-15 Insert Finance Integarion 
            if (Resources.Resource.AllowFiananceIntegration == "1")
            {
                string IsIntegrated = Util.GetString(EbizFrame.InsertServicePOClose(ServicePOCloseNumber, againstPO, 20, tnx));
                if (IsIntegrated == "0")
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Finance Integration Details" });
                }
            }

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "PO Close Successfully.</br> PO Close No. : " + ServicePOCloseNumber, message = ServicePOCloseNumber });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In service PO Closing" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
    public class servicePO
    {
        public string PONumber { get; set; }
        public int PODetailId { get; set; }
        public string ItemId { get; set; }
        public decimal Amount { get; set; }
        public decimal ClosedQty { get; set; }
        public decimal RejectedQty { get; set; }
        public string InvoiceNumber { get; set; }
        public DateTime InvoiceDate { get; set; }
        public string Remarks { get; set; }
    }
}