<%@ WebService Language="C#" Class="EditPO" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;
using System.Web.Services.Protocols;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Text;
using System.Web.Script.Services;
using MySql.Data.MySqlClient;
using System.Web.Script.Serialization;

[WebService(Namespace = "")]

[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]

public class EditPO : System.Web.Services.WebService
{

    [WebMethod(EnableSession = true, Description = "Get PO Detail")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string PODetail(string PurchaseOrderNo, string DeptLedgerNo, string StoreLedgerNo)
    {
        string result = "0";
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT DISTINCT(PO.PurchaseOrderNo),(SELECT NAME FROM employee_master WHERE employee_id=PO.RaisedUserID)UserName, ");
        sb.Append(" PO.Subject,DATE_FORMAT(PO.RaisedDate,'%d-%b-%y')RaisedDate,PO.VendorName,lm.ledgeruserid,PO.GrossTotal, ");
        sb.Append(" IFNULL(PO.Narration,'')Narration,ROUND(PO.Freight,2)Freight,ROUND(PO.Roundoff,2)Roundoff,ROUND(PO.Scheme,2)Scheme,ROUND(PO.ExciseOnBill,2)ExciseOnBill, ");
        sb.Append(" PO.DeptLedgerNo,po.VendorID FROM f_purchaseorder PO INNER JOIN f_ledgermaster lm ON lm.`LedgerNumber`= po.VendorID ");
        sb.Append(" INNER JOIN f_purchaseorderapproval POA ON PO.PurchaseOrderNo=POA.PONumber ");
        sb.Append(" WHERE poa.Approved=1 AND PO.Status=2 AND PO.StoreLedgerNo IN ('" + StoreLedgerNo + "') ");
        if (DeptLedgerNo != "")
            sb.Append(" AND PO.DeptLedgerNo='" + DeptLedgerNo + "' ");
        if (PurchaseOrderNo != "")
            sb.Append(" AND PO.PurchaseOrderNo='" + PurchaseOrderNo + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        return result;
    }

    [WebMethod(Description = "Get PO Items")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetPOItems(string PurchaseOrderNo, string StoreLedgerNo)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT po.VendorID,po.VendorName,pod.PurchaseOrderDetailID,pod.`ItemID`,pod.`ItemName`,pod.`Unit`,pod.`OrderedQty`,pod.`ApprovedQty`,pod.`Rate`,pod.MRP,pod.Discount_p DiscPer,0 DiscAmt,0 GSTAmt,pod.`BuyPrice`,IF(IsFree = 1,'true','false')IsFree,pod.Amount, ");
            sb.Append(" pod.`TaxCalulatedOn`,pod.`GSTType`,(pod.IGSTPercent+pod.CGSTPercent+pod.SGSTPercent)GSTPer,pod.`HSNCode`,pod.`IGSTPercent`,pod.`CGSTPercent`,pod.`SGSTPercent` ");
            sb.Append(" FROM f_purchaseorderdetails pod ");
            sb.Append(" INNER JOIN f_purchaseorder po on pod.PurchaseOrderNo=po.PurchaseOrderNo");
            sb.Append(" where pod.PurchaseOrderNo='" + PurchaseOrderNo + "' ");
            if (StoreLedgerNo != "")
                sb.Append(" AND pod.StoreLedgerNo='" + StoreLedgerNo + "' ");
            sb.Append(" order by pod.ItemName");
            DataTable dtPOItems = StockReports.GetDataTable(sb.ToString());
            if (dtPOItems.Rows.Count > 0)
            {
                dtPOItems.Columns.Add("RowColour");
                for (int i = 0; i < dtPOItems.Rows.Count; i++)
                {
                    if (Util.GetString(dtPOItems.Rows[i]["ItemName"]) == Util.GetString(""))
                        dtPOItems.Rows[i]["RowColour"] = "LightBlue";
                    else
                        dtPOItems.Rows[i]["RowColour"] = "AntiqueWhite";
                }
            }                                 
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtPOItems);
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
    }

    [WebMethod]
    public List<object> GetItemList(string ItemName, string StoreLedgerNo)
    {
        List<object> Emp = new List<object>();
        StringBuilder sb = new StringBuilder();
        sb.Append(" select IM.Typename ItemName,CONCAT(IM.ItemID,'#',IFNULL(UPPER(im.IsExpirable),''),'#',IF(IFNULL(IM.minorUnit,'')='',IFNULL(im.minorUnit,''),IM.minorUnit),'#',IF(IFNULL(IM.ConversionFactor,'')='',IFNULL(im.ConversionFactor,''),IM.ConversionFactor),'#',IF(IFNULL(IM.MajorUnit,'')='',IFNULL(im.MajorUnit,''),IM.MajorUnit),'#',IFNULL(TRIM(REPLACE(im.GSTType,'\r',' ')),''),'#',IFNULL(im.HSNCode,''),'#',im.`CGSTPercent`,'#',im.`SGSTPercent`,'#',im.`IGSTPercent`,'#',im.`SubCategoryID`)ItemID ");
        sb.Append(" FROM f_itemmaster IM INNER JOIN f_subcategorymaster SM ON IM.SubCategoryID = SM.SubCategoryID ");
        sb.Append(" INNER JOIN f_configrelation c ON c.CategoryID =SM.CategoryID  ");
        sb.Append(" WHERE IM.IsActive=1 ");
        if (StoreLedgerNo == "STO00001")
            sb.Append(" AND c.ConfigID ='11' ");
        else
            sb.Append(" AND c.ConfigID ='28' ");
        sb.Append(" AND TypeName LIKE '%" + ItemName + "%' AND  IM.TypeName<>''");
        sb.Append(" ORDER BY IM.Typename ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        foreach (DataRow row in dt.Rows)
        {
            Emp.Add(new
            {
                itemName = row["ItemName"].ToString(),
                itemID = row["ItemID"].ToString()
            });
        }
        return Emp;
    }

    [WebMethod(EnableSession = true)]
    public string bindTaxCalOn()
    {
        IList<TaxCal> TaxCalList = new List<TaxCal>() { 
            new TaxCal(){ label="Rate", value="Rate"},
            new TaxCal(){ label="RateAD", value="RateAD"},
            new TaxCal(){ label="RateRev", value="Rate Rev."},
            new TaxCal(){ label="RateExcl", value="Rate Excl."},
            new TaxCal(){ label="MRPExcl", value="MRP Excl."},
            new TaxCal(){ label="ExciseAmt", value="Excise Amt."}
        };
        return Newtonsoft.Json.JsonConvert.SerializeObject(TaxCalList);
    }
    
    public class TaxCal{
        public string label { get; set; }
        public string value { get; set; }
    }

    [WebMethod(EnableSession = true)]
    public string bindGSTType()
    {
        DataTable dt = StockReports.GetDataTable("SELECT TaxID,TaxName FROM f_taxmaster WHERE TaxID IN ('T4','T6','T7')");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public string UpdatePO(object itemDetail, string PONumber, string VendorID)
    {
        List<POItems> dataPO = new JavaScriptSerializer().ConvertToType<List<POItems>>(itemDetail);
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.ReadCommitted);
        try
        {
            StringBuilder sb = new StringBuilder();
            decimal NetAmount = 0;
            foreach (var P in dataPO)
            {
                NetAmount = NetAmount + P.Amount;
                string Amt = "";
                List<TaxCalculation_DirectGRN> taxCalculate = new List<TaxCalculation_DirectGRN>()
                         {
                           new TaxCalculation_DirectGRN {DiscAmt=0, DiscPer= P.DiscPer, MRP=P.MRP,Quantity = Util.GetDecimal(P.ApprovedQty),Rate=P.Rate,TaxPer =P.GSTPer,Type =P.TaxCalOn,IGSTPrecent=P.IGSTPercent,CGSTPercent=P.CGSTPercent,SGSTPercent=P.SGSTPercent}
                         };

                Amt = AllLoadData_Store.taxCalulation(taxCalculate);                                
                if (P.PODID == "")
                {
                    var aa = P.Amount;var bb = P.UnitPrice;var cc = P.GSTAmt;
                    sb.Clear();
                    sb.Append(" insert into f_purchaseorderdetails(PurchaseOrderNo,ItemID,ItemName,OrderedQty,ApprovedQty,Rate, ");
                    sb.Append(" Discount_p,BuyPrice,Amount,MRP,VATPer,VATAmt,TaxCalulatedOn,GSTType,IGSTPercent,IGSTAmt,CGSTPercent,CGSTAmt,SGSTPercent,SGSTAmt)");
                    sb.Append(" values('" + P.PurchaseOrderNo + "','" + P.ItemID + "','" + P.ItemName + "','" + P.OrderedQty + "','" + P.ApprovedQty + "','" + P.Rate + "','" + P.DiscPer + "', ");
                    sb.Append(" values('" + Util.GetDecimal(Amt.Split('#')[4].ToString()) + "','" + Util.GetDecimal(Amt.Split('#')[0].ToString()) + "','" + P.MRP + "','" + P.GSTPer + "','" + Util.GetDecimal(Amt.Split('#')[1].ToString()) + "','" + P.TaxCalOn + "','" + P.GSTType + "', ");
                    sb.Append(" values('" + P.IGSTPercent + "','" + Util.GetDecimal(Amt.Split('#')[8].ToString()) + "','" + P.CGSTPercent + "','" + Util.GetDecimal(Amt.Split('#')[9].ToString()) + "','" + P.SGSTPercent + "','" + Util.GetDecimal(Amt.Split('#')[10].ToString()) + "')");                    
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text,sb.ToString());                    
                }
                else
                {
                    sb.Clear();
                    sb.Append(" update f_purchaseorderdetails  set OrderedQty='" + P.OrderedQty + "',ApprovedQty='" + P.ApprovedQty + "',Rate='" + P.Rate + "', ");
                    sb.Append(" Discount_p='" + P.DiscPer + "',BuyPrice='" + Util.GetDecimal(Amt.Split('#')[4].ToString()) + "',Amount='" + Util.GetDecimal(Amt.Split('#')[0].ToString()) + "',MRP='" + P.MRP + "',VATPer='" + P.GSTPer + "',VATAmt='" + Util.GetDecimal(Amt.Split('#')[1].ToString()) + "', ");
                    sb.Append(" TaxCalulatedOn='" + P.TaxCalOn + "',GSTType='" + P.GSTType + "',IGSTPercent='" + P.IGSTPercent + "',IGSTAmt='" + Util.GetDecimal(Amt.Split('#')[8].ToString()) + "',CGSTPercent='" + P.CGSTPercent + "',CGSTAmt='" + Util.GetDecimal(Amt.Split('#')[9].ToString()) + "',SGSTPercent='" + P.SGSTPercent + "',SGSTAmt='" + Util.GetDecimal(Amt.Split('#')[10].ToString()) + "'");
                    sb.Append(" WHERE PurchaseOrderDetailID='"+P.PODID+"' ");
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString()); 
                }
              
            }

            sb.Clear();
            sb.Append(" update f_purchaseorder set GrossTotal =Freight-Scheme+ExciseOnBill+Roundoff+'" + NetAmount + "',NetTotal='" + NetAmount + "',S_Amount='" + NetAmount + "'");
            sb.Append(" WHERE PurchaseOrderNo = '" + PONumber + "' ");
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString()); 
                
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            return "";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public class POItems
    {
        public string PurchaseOrderNo { get; set; }
        public string VendorID { get; set; }
        public string ItemID { get; set; }
        public string ItemName { get; set; }
        public string OrderedQty { get; set; }
        public string ApprovedQty { get; set; }
        public string TaxCalOn { get; set; }
        public string PODID { get; set; }
        public decimal Rate { get; set; }
        public decimal MRP { get; set; }
        public decimal DiscPer { get; set; }
        public decimal DiscAmt { get; set; }        
        public string GSTType { get; set; }
        public decimal GSTPer { get; set; }
        public decimal GSTAmt { get; set; }
        public decimal IGSTPercent { get; set; }
        public decimal CGSTPercent { get; set; }
        public decimal SGSTPercent { get; set; }   
        public decimal Amount { get; set; }
        public decimal UnitPrice { get; set; }                                                                              
    }
    
}