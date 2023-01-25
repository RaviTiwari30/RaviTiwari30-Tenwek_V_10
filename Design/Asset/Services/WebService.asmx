<%@ WebService Language="C#" Class="WebService" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using MySql.Data.MySqlClient;
using System.Text;
using System.Web.Script.Services;
using System.Web.Script.Serialization;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.ComponentModel;
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.ComponentModel.ToolboxItem(false)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class WebService : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }
    [WebMethod]
    public string BindMedicine(string PatientId, string FromDate, string ToDate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT fi.Typename,if(pm.outsource=1,'Yes','No')outsource  FROM f_itemmaster fi INNER JOIN patient_medicine pm ON SUBSTRING_INDEX(pm.Medicine_ID,'#',1)=fi.itemid where pm.patient_id ='" + PatientId + "' ");
        if (FromDate != "" && ToDate != "")
        {
            sb.Append(" AND DATE(pm.Date)>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND DATE(pm.Date)<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'");
        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);


    }
    [WebMethod]
    public string ShowStock(string ItemId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT st.InitialCount Qty,st.BatchNumber,st.UnitPrice,st.MRP,st.PurTaxPer,st.DiscPer,st.SaleTaxPer,  ");
        sb.Append("  DATE_FORMAT(st.MedExpiryDate,'%d-%b-%Y')MedExpiryDate,St.ItemName  FROM f_stock st INNER JOIN f_ledgertransaction lt     ");
        sb.Append(" ON st.LedgerTransactionNo=lt.LedgerTransactionNo  WHERE  st.ItemID='" + ItemId.Split('#')[0].ToString() + "' AND lt.TypeOfTnx='StockUpdate'");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);


    }
    [WebMethod]
    public string bindItem()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CONCAT(ItemID,'#',LowStock)ItemID,CONCAT(TypeName,' # (',NAME,')',' # ',AvailableQty)ItemName ");
        sb.Append(" FROM ( ");
        sb.Append(" SELECT im.ItemID,im.typename,sm.name,AvailableQty,IF(AvailableQty<ls.MinLevel,1,0) LowStock  ");
        sb.Append(" FROM (  ");
        sb.Append(" SELECT ItemID,(SUM(InitialCount) - SUM(ReleasedCount))AvailableQty ");
        sb.Append(" FROM f_stock  ");
        sb.Append(" WHERE (InitialCount - ReleasedCount) > 0  AND IsPost = 1 AND  DeptLedgerNo='LSHHI57'   ");
        sb.Append(" AND MedExpiryDate>CURDATE()  GROUP BY ItemID  )t1 INNER JOIN f_itemmaster im ON t1.itemid = im.ItemID   ");
        sb.Append(" INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID = im.SubCategoryID");
        sb.Append(" LEFT JOIN f_LowStock ls ON ls.itemid=im.itemid AND ls.DeptLedgerNo='LSHHI57' ");

        sb.Append(" ORDER BY im.typename ");
        sb.Append(" )t2  ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public string bindGenericItem()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" select im.ItemID, CONCAT(fsm.Name,' # ',im.typename,' # (',sm.name,')',' # ',AvailableQty)ItemName from ( ");
        sb.Append(" select ItemID,(SUM(InitialCount) - SUM(ReleasedCount))AvailableQty from f_stock where (InitialCount - ReleasedCount) > 0 ");
        sb.Append(" and IsPost = 1 and  DeptLedgerNo='" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "'  and MedExpiryDate>CURDATE() ");
        sb.Append(" group by ItemID ");
        sb.Append(" ) t1 inner join f_itemmaster im on t1.itemid = im.ItemID ");
        sb.Append(" inner join f_subcategorymaster sm on sm.SubCategoryID = im.SubCategoryID ");
        sb.Append(" INNER JOIN f_item_salt fis ON fis.ItemID=im.ItemID LEFT JOIN f_salt_master fsm ON fis.saltID = fsm.SaltID WHERE fsm.IsActive=1 ");



        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public string addItem(string ItemID, decimal tranferQty, string StockID, string patientMedicine, string DeptLedgerNo)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append("Select ST.stockid,IM.TypeName ItemName,ST.ItemID,ST.BatchNumber,ST.MRP,ST.UnitPrice,");
        sb.Append("(ST.InitialCount - ST.ReleasedCount)AvlQty,IM.SubCategoryID,im.isexpirable,");
        sb.Append("date_format(ST.MedExpiryDate,'%d-%b-%Y')MedExpiryDate,ST.UnitType,im.ToBeBilled,");
        sb.Append("im.Type_ID,im.IsUsable,im.ServiceItemID,'" + patientMedicine + "' MedID,0 isItemWiseDisc,");
        // Add new on 29-06-2017 - For GST
        sb.Append(" st.HSNCode,st.IGSTPercent,st.IGSTAmtPerUnit,st.SGSTPercent,st.SGSTAmtPerUnit,st.CGSTPercent,st.CGSTAmtPerUnit,st.GSTType, ");
        //
        sb.Append(" st.PurTaxPer FROM f_stock ST ");
        sb.Append(" INNER JOIN f_itemmaster IM on ST.ItemID=IM.ItemID INNER JOIN f_subcategorymaster sub ON sub.SubcategoryID=IM.SubcategoryID ");
        sb.Append(" INNER JOIN f_configrelation CR on sub.CategoryID = CR.CategoryID WHERE (ST.InitialCount - ST.ReleasedCount) > 0 and ST.IsPost = 1 ");
        sb.Append(" AND CR.ConfigID = 11 AND IM.ItemID ='" + ItemID + "' ");
        sb.Append(" AND st.DeptLedgerNo='" + DeptLedgerNo + "'   AND st.StockID=" + StockID);
        sb.Append(" AND (IF(im.IsExpirable = 'NO','2050-01-01',st.MedExpiryDate) >= CURDATE())  order by st.MedExpiryDate");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if ((tranferQty < Util.GetDecimal(dt.Rows[0]["AvlQty"])) && (StockID != "0"))
        {
            dt = dt.AsEnumerable().Where(r => r.Field<string>("StockID") == StockID).AsDataView().ToTable();

        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }


   


    [WebMethod]
    public string BindMedicineDetail(string ItemID, string DeptLedgerNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT ST.stockid,ST.ItemID,DATE_FORMAT(st.MedExpiryDate,'%d-%b-%y')Expiry,ST.BatchNumber, ");
        sb.Append(" ST.MRP,round((ST.MRP*IM.ConversionFactor),2)MajorMRP,ST.UnitPrice,IM.ConversionFactor, ");
        sb.Append("(ST.InitialCount - ST.ReleasedCount)AvlQty ");
        sb.Append("  ");
        sb.Append("  FROM f_stock ST ");
        sb.Append(" INNER JOIN f_itemmaster IM ON ST.ItemID=IM.ItemID ");
        sb.Append(" WHERE (ST.InitialCount - ST.ReleasedCount) > 0 AND ST.IsPost = 1  ");
        sb.Append("  AND IM.ItemID ='" + ItemID + "'  AND st.DeptLedgerNo='" + DeptLedgerNo + "'  ");
        sb.Append(" AND (IF(im.IsExpirable = 'NO','2050-01-01',st.MedExpiryDate) > CURDATE()) ORDER BY st.MedExpiryDate ");
        DataTable oDT = StockReports.GetDataTable(sb.ToString());
        if (oDT.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(oDT);
        else
            return "";
    }
  

    [WebMethod(EnableSession = true, Description = "Get Tax Amount")]
    public string GetTaxAmount(object Data)
    {

        return AllLoadData_Store.taxCalulation(Data);

    }
  

    //Chalan Work Starts
    [WebMethod(EnableSession = true, Description = "Get GRN List")]
    public string EditGRN(string VendorId, string GRNNo)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT t.LedgerTransactionNo,REPLACE(t.LedgerTransactionNo,'/','_')LedTnxNo,t.LedgerNoCr,IFNULL(im.`InvoiceNo`,'')InvoiceNo,IF(im.`InvoiceNo`='','',DATE_FORMAT(im.`InvoiceDate`,'%d-%b-%Y'))InvoiceDate,IFNULL(im.`ChalanNo`,'')ChalanNo,IF(im.`ChalanNo`='','',DATE_FORMAT(im.`ChalanDate`,'%d-%b-%Y'))ChalanDate,IF(SUM(isPost)='0','false','true')IsPost FROM ( ");
        sb.Append(" SELECT lt.`LedgerTransactionNo`,lt.`LedgerNoCr`,IF(st.`IsPost`='1','1','0')isPost FROM f_ledgertransaction lt ");
        sb.Append(" INNER JOIN f_stock st ON lt.`LedgerTransactionNo`=st.`LedgerTransactionNo` ");
        sb.Append(" WHERE  lt.LedgerNoCr='" + VendorId + "' AND lt.`InvoiceNo`='' AND lt.`IsCancel`='0' ");
        sb.Append(" UNION ALL ");
        sb.Append(" SELECT lt.`LedgerTransactionNo`,lt.`LedgerNoCr`,IF(st.`IsPost`='1','1','0')isPost FROM f_ledgertransaction lt ");
        sb.Append(" INNER JOIN f_stock st ON lt.`LedgerTransactionNo`=st.`LedgerTransactionNo` ");
        sb.Append(" WHERE  lt.`LedgerTransactionNo`='" + GRNNo + "' AND lt.`IsCancel`='0' ");
        sb.Append(" )t INNER JOIN f_invoicemaster im ON im.`LedgerTnxNo`=t.LedgerTransactionNo ");
        sb.Append(" GROUP BY t.LedgerTransactionNo ORDER BY t.LedgerTransactionNo ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";

    }
    [WebMethod(EnableSession = true, Description = "Load GRN Items")]
    public string LoadGRNItems(string GRNNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT st.`StockID`,st.`ItemID`,st.`ItemName`,st.`ConversionFactor`,st.`MinorUnit`,st.`MajorUnit`,st.`HSNCode`,st.`BatchNumber`,st.`Rate`,st.`MajorMRP` MRP,(st.`InitialCount`/st.`ConversionFactor`)QTY,  ");
        sb.Append(" DATE_FORMAT(st.`MedExpiryDate`,'%d-%b-%Y')ExpDate,st.`DiscPer`,st.`SpecialDiscPer`,st.`GSTType`,st.`CGSTPercent`,st.`SGSTPercent`,st.`IGSTPercent`,IF(st.`IsPost`=1,'True','false')Post,st.`LedgerTransactionNo` GRNNO,IF(st.`IsFree`=1,'True','False')IsFree,IF(st.`InvoiceNo`='',IF(st.`ChalanNo`='','False','True'),'False')IsOnChalan,IF(st.`IsExpirable`='1','YES','NO')IsExpirable,IFNULL(st.`isDeal`,'')isDeal,st.`SubCategoryID`  ");
        sb.Append(" FROM f_stock st WHERE st.`LedgerTransactionNo`='" + GRNNo + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";

    }

    [WebMethod(EnableSession = true, Description = "Bind GST Types")]
    public string bindGSTType()
    {

        DataTable dt = StockReports.GetDataTable("select TaxName,TaxID from f_taxmaster where TaxID IN('T4','T6','T7') order by TaxName");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true, Description = "Update GRN")]
    public string UpdateGRNInfo(object InvMaster, object StockDetails)
    {
        List<InvoiceMaster> dataInvoice = new JavaScriptSerializer().ConvertToType<List<InvoiceMaster>>(InvMaster);
        List<Stock> dataStock = new JavaScriptSerializer().ConvertToType<List<Stock>>(StockDetails);

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
            string str = string.Empty;
            string chalanNo, chalanDate, invoiceNo, InvoiceDate, VenLedgerNo, LedgerTnxNo;

            for (int i = 0; i < dataStock.Count; i++)
            {
                DateTime ExpiryDate; decimal DealRate = 0; decimal perUnitPrice = 0; decimal NetAmount = 0; decimal Amount = 0; decimal Deal1 = 0; decimal Deal2 = 0;
                int isFree = 0; decimal totalTaxAmt = 0; decimal discAmt = 0; decimal LTDigstTaxAmt = 0; decimal LTDcgstTaxAmt = 0; decimal LTDsgstTaxAmt = 0;
                decimal STigstTaxAmt = 0; decimal STcgstTaxAmt = 0; decimal STsgstTaxAmt = 0; decimal SpecialDiscAmt = 0; decimal rate1 = 0;

                string Deal = Util.GetString(dataStock[i].isDeal);
                decimal totalTaxper = Math.Round(Util.GetDecimal(dataStock[i].IGSTPercent) + Util.GetDecimal(dataStock[i].CGSTPercent) + Util.GetDecimal(dataStock[i].SGSTPercent), 2);
                isFree = Util.GetInt(dataStock[i].IsFree);
                decimal ConversionFactor = Util.GetDecimal(dataStock[i].ConversionFactor);
                string ItemID = Util.GetString(dataStock[i].ItemID);
                string Itemname = Util.GetString(dataStock[i].ItemName);
                string SubcategoryID = Util.GetString(dataStock[i].SubCategoryID);
                int isExpirable = Util.GetInt(dataStock[i].IsExpirable);
                if (isExpirable == 1)
                    ExpiryDate = Util.GetDateTime(dataStock[i].MedExpiryDate);
                else
                    ExpiryDate = DateTime.Now.AddYears(5);
                string SaleUnit = Util.GetString(dataStock[i].MinorUnit);
                string MajorUnit = Util.GetString(dataStock[i].MajorUnit);
                string Batchnumber = Util.GetString(dataStock[i].BatchNumber);
                decimal excise1 = Util.GetDecimal(0);
                decimal Discper = Util.GetDecimal(dataStock[i].DiscPer);
                decimal MajorMRP = Util.GetDecimal(dataStock[i].MRP);
                decimal MRP = Util.GetDecimal(MajorMRP / ConversionFactor);
                decimal RecvQty = Util.GetDecimal(dataStock[i].InitialCount) * Util.GetDecimal(ConversionFactor);
                decimal igstPer = Util.GetDecimal(dataStock[i].IGSTPercent);
                decimal cgstPer = Util.GetDecimal(dataStock[i].CGSTPercent);
                decimal sgstPer = Util.GetDecimal(dataStock[i].SGSTPercent);
                string GSTType = Util.GetString(dataStock[i].GSTType);
                decimal SpecialDiscPer = Util.GetDecimal(dataStock[i].SpecialDiscPer);
                string stockId = Util.GetString(dataStock[i].StockID);
                string GRNNo = Util.GetString(dataStock[i].LedgerTransactionNo);
                string HSNCode = Util.GetString(dataStock[i].HSNCode);
                decimal QTY = Util.GetDecimal(dataStock[i].InitialCount);
                if (isFree != 1)
                {
                    string Amt = "";
                    List<TaxCalculation_DirectGRN> taxCalculate = new List<TaxCalculation_DirectGRN>()
					{
						new TaxCalculation_DirectGRN 
						{
							DiscAmt=Util.GetDecimal(0),
							DiscPer=Util.GetDecimal(dataStock[i].DiscPer), 
							MRP=Util.GetDecimal(dataStock[i].MRP),
							Quantity = QTY,
							Rate=DealRate,
							TaxPer=totalTaxper,
							Type =  Util.GetString("RateAD"),						
							ActualRate=Util.GetDecimal(dataStock[i].Rate),
							IGSTPrecent=Util.GetDecimal(dataStock[i].IGSTPercent),
							CGSTPercent=Util.GetDecimal(dataStock[i].CGSTPercent),
							SGSTPercent=Util.GetDecimal(dataStock[i].SGSTPercent),
							SpecialDiscPer=Util.GetDecimal(dataStock[i].SpecialDiscPer)
						 }
				   };
                    Amt = AllLoadData_Store.taxCalulation(taxCalculate);
                    rate1 = Util.GetDecimal(dataStock[i].Rate);
                    perUnitPrice = Util.GetDecimal(Amt.Split('#')[4].ToString()) / ConversionFactor;
                    NetAmount = Util.GetDecimal(Amt.Split('#')[0].ToString());
                    Amount = Util.GetDecimal(Amt.Split('#')[3].ToString());
                    totalTaxAmt = Util.GetDecimal(Amt.Split('#')[1].ToString());
                    discAmt = Util.GetDecimal(Amt.Split('#')[2].ToString());
                    LTDigstTaxAmt = Util.GetDecimal(Amt.Split('#')[8].ToString());
                    LTDcgstTaxAmt = Util.GetDecimal(Amt.Split('#')[9].ToString());
                    LTDsgstTaxAmt = Util.GetDecimal(Amt.Split('#')[10].ToString());
                    STigstTaxAmt = Math.Round(LTDigstTaxAmt / (Util.GetDecimal(RecvQty)), 4, MidpointRounding.AwayFromZero);
                    STcgstTaxAmt = Math.Round(LTDcgstTaxAmt / (Util.GetDecimal(RecvQty)), 4, MidpointRounding.AwayFromZero);
                    STsgstTaxAmt = Math.Round(LTDsgstTaxAmt / (Util.GetDecimal(RecvQty)), 4, MidpointRounding.AwayFromZero);
                    SpecialDiscAmt = Util.GetDecimal(Amt.Split('#')[11].ToString());

                }
                if (stockId != "")
                {
                    str = "UPDATE f_stock SET ItemID='" + ItemID + "',Itemname='" + Itemname + "',BatchNumber = '" + Batchnumber.ToString() + "',UnitPrice='" + perUnitPrice + "',MRP = '" + MRP + "', majorMRP='" + MajorMRP + "',InitialCount = '" + RecvQty + "',MedExpiryDate='" + ExpiryDate.ToString("yyyy-MM-dd") + "',SubcategoryID='" + SubcategoryID + "',UnitType='" + MajorUnit + "',Rate='" + rate1 + "',DiscAmt='" + discAmt + "',DiscPer='" + Discper + "',PurTaxAmt='" + totalTaxAmt + "',PurTaxPer='" + totalTaxper + "',ConversionFactor='" + ConversionFactor + "',MajorUnit='" + MajorUnit + "',MinorUnit='" + SaleUnit + "',MajorMRP='" + MajorMRP + "',IsExpirable='" + isExpirable + "',isDeal='" + Deal + "',ExciseAmt='" + excise1 + "',IGSTPercent='" + igstPer + "',IGSTAmtPerUnit='" + STigstTaxAmt + "',CGSTPercent='" + cgstPer + "',CGSTAmtPerUnit='" + STcgstTaxAmt + "',SGSTPercent='" + sgstPer + "',SGSTAmtPerUnit='" + STsgstTaxAmt + "',GSTType='" + GSTType + "',SpecialDiscPer='" + SpecialDiscPer + "',specialDiscAmt='" + SpecialDiscAmt + "',HSNCode='" + HSNCode + "',IsFree='" + isFree + "',LastUpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "',Updatedate=NOW() WHERE stockid = '" + stockId + "' AND  LedgerTransactionNo='" + GRNNo + "'";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

                    str = " UPDATE f_ledgertnxdetail SET ItemID='" + ItemID + "',Itemname='" + Itemname + "',BatchNumber = '" + Batchnumber.ToString() + "', Quantity = '" + QTY + "',Rate='" + rate1 + "',Amount = '" + Amount + "',DiscAmt='" + discAmt + "',DiscountPercentage='" + Discper + "',medExpiryDate='" + ExpiryDate.ToString("yyyy-MM-dd") + "',IsExpirable='" + isExpirable + "',NetItemAmt='" + Amount + "',TotalDiscAmt='" + discAmt + "',PurTaxPer='" + totalTaxper + "',PurTaxAmt='" + totalTaxAmt + "',unitPrice='" + perUnitPrice + "',IGSTPercent='" + igstPer + "',IGSTAmt='" + LTDigstTaxAmt + "',CGSTPercent='" + cgstPer + "',CGSTAmt='" + LTDcgstTaxAmt + "',SGSTPercent='" + sgstPer + "',SGSTAmt='" + LTDsgstTaxAmt + "',SpecialDiscPer='" + SpecialDiscPer + "',specialDiscAmt='" + SpecialDiscAmt + "',HSNCode='" + HSNCode + "',IsFree='" + isFree + "',LastUpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdatedDate=NOW() WHERE stockid = '" + stockId + "' AND LedgerTransactionNo='" + GRNNo + "'";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
                    UpdateItem(tnx, igstPer, cgstPer, sgstPer, GSTType, stockId, perUnitPrice, STigstTaxAmt, STcgstTaxAmt, STsgstTaxAmt, HSNCode);
                }
                else
                {
                    LedgerTnxDetail objLTDetail = new LedgerTnxDetail(tnx);
                    objLTDetail.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
                    objLTDetail.LedgerTransactionNo = GRNNo;
                    objLTDetail.ItemID = ItemID;
                    objLTDetail.SubCategoryID = SubcategoryID;
                    objLTDetail.Rate = rate1;
                    objLTDetail.Quantity = QTY;
                    objLTDetail.StockID = stockId;
                    objLTDetail.ItemName = Itemname;
                    objLTDetail.EntryDate = DateTime.Now;
                    objLTDetail.UserID = HttpContext.Current.Session["ID"].ToString();
                    objLTDetail.UpdatedDate = DateTime.Now;
                    if (Util.GetString(totalTaxper) != string.Empty && Util.GetDecimal(totalTaxper) > 0)
                        objLTDetail.IsTaxable = "YES";
                    else
                        objLTDetail.IsTaxable = "NO";

                    objLTDetail.DiscountPercentage = Discper;
                    objLTDetail.DiscAmt = discAmt;
                    objLTDetail.Amount = Amount;
                    objLTDetail.IsFree = isFree;
                    objLTDetail.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    objLTDetail.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                    objLTDetail.medExpiryDate = ExpiryDate;
                    objLTDetail.IsExpirable = isExpirable;
                    objLTDetail.pageURL = All_LoadData.getCurrentPageName();
                    objLTDetail.NetItemAmt = Util.GetDecimal(objLTDetail.Amount);
                    objLTDetail.TotalDiscAmt = Util.GetDecimal(objLTDetail.DiscAmt);
                    objLTDetail.IpAddress = HttpContext.Current.Request.UserHostAddress;
                    objLTDetail.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(SubcategoryID), conn));
                    objLTDetail.Type = "S";
                    objLTDetail.BatchNumber = Batchnumber;
                    objLTDetail.StoreLedgerNo = Util.GetString(StockReports.ExecuteScalar("SELECT StoreLedgerNo FROM f_stock st WHERE st.`LedgerTransactionNo`='" + GRNNo + "' LIMIT 1"));
                    objLTDetail.DeptLedgerNo = HttpContext.Current.Session["DeptLedgerNo"].ToString();
                    objLTDetail.PurTaxAmt = totalTaxAmt;
                    objLTDetail.PurTaxPer = totalTaxper;
                    objLTDetail.HSNCode = HSNCode;
                    objLTDetail.IGSTPercent = igstPer;
                    objLTDetail.IGSTAmt = LTDigstTaxAmt;
                    objLTDetail.CGSTPercent = cgstPer;
                    objLTDetail.CGSTAmt = LTDcgstTaxAmt;
                    objLTDetail.SGSTPercent = sgstPer;
                    objLTDetail.SGSTAmt = LTDsgstTaxAmt;
                    objLTDetail.SpecialDiscPer = SpecialDiscPer;
                    objLTDetail.SpecialDiscAmt = SpecialDiscAmt;
                    objLTDetail.unitPrice = perUnitPrice;
                    string LdgTrnxDtlID = objLTDetail.Insert().ToString();

                    if (LdgTrnxDtlID == string.Empty)
                    {
                        tnx.Rollback();
                        tnx.Dispose();
                        conn.Close();
                        conn.Dispose();
                        return string.Empty;
                    }
                    Stock objStock = new Stock(tnx);
                    objStock.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                    objStock.ItemID = ItemID;
                    objStock.ItemName = Itemname;
                    objStock.LedgerTransactionNo = GRNNo;
                    objStock.LedgerTnxNo = LdgTrnxDtlID;
                    objStock.BatchNumber = Batchnumber;
                    objStock.UnitPrice = Util.GetDecimal(perUnitPrice);
                    objStock.MRP = Util.GetDecimal(MRP);
                    objStock.MajorMRP = MajorMRP;
                    objStock.IsCountable = 1;
                    objStock.InitialCount = Util.GetDecimal(RecvQty);
                    objStock.ReleasedCount = 0;
                    objStock.IsReturn = 0;
                    objStock.LedgerNo = string.Empty;
                    objStock.MedExpiryDate = ExpiryDate;
                    objStock.StockDate = DateTime.Now;
                    if (Util.GetString(objLTDetail.StoreLedgerNo) == "STO00001")
                    {
                        objStock.TypeOfTnx = "Purchase";
                        objStock.StoreLedgerNo = "STO00001";
                    }
                    else if (Util.GetString(objLTDetail.StoreLedgerNo) == "STO00002")
                    {
                        objStock.TypeOfTnx = "NMPURCHASE";
                        objStock.StoreLedgerNo = "STO00002";
                    }
                    objStock.IsPost = 0;
                    objStock.Naration = "";
                    objStock.IsFree = isFree;
                    objStock.SubCategoryID = SubcategoryID;
                    objStock.Unit = SaleUnit;
                    objStock.DeptLedgerNo = HttpContext.Current.Session["DeptLedgerNo"].ToString();
                    objStock.UserID = HttpContext.Current.Session["ID"].ToString();
                    objStock.IsBilled = 1;
                    objStock.Rate = Util.GetDecimal(rate1);
                    objStock.DiscPer = Util.GetDecimal(Discper);
                    objStock.VenLedgerNo = Util.GetString(dataStock[i].VenLedgerNo);
                    objStock.DiscAmt = Util.GetDecimal(discAmt);
                    objStock.TYPE = Util.GetString(StockReports.ExecuteScalar("SELECT im.`Type_ID` FROM f_itemmaster im WHERE im.`ItemID`='" + ItemID + "'"));
                    //objStock.Reusable = Util.GetInt(rowItem["IsUsable"]);
                    objStock.ConversionFactor = ConversionFactor;
                    objStock.MajorUnit = MajorUnit;
                    objStock.MinorUnit = SaleUnit;
                    objStock.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    objStock.IpAddress = All_LoadData.IpAddress();
                    objStock.IsExpirable = isExpirable;
                    objStock.PurTaxPer = Util.GetDecimal(totalTaxper);
                    objStock.PurTaxAmt = Util.GetDecimal(totalTaxAmt);
                    objStock.ExciseAmt = Util.GetDecimal(0);
                    objStock.ExcisePer = Util.GetDecimal(0);
                    objStock.taxCalculateOn = Util.GetString("RateAD");
                    objStock.isDeal = Deal;
                    objStock.HSNCode = HSNCode;
                    objStock.GSTType = GSTType;
                    objStock.IGSTPercent = igstPer;
                    objStock.IGSTAmtPerUnit = STigstTaxAmt;
                    objStock.CGSTPercent = cgstPer;
                    objStock.CGSTAmtPerUnit = STcgstTaxAmt;
                    objStock.SGSTPercent = sgstPer;
                    objStock.SGSTAmtPerUnit = STsgstTaxAmt;
                    objStock.SpecialDiscPer = SpecialDiscPer;
                    objStock.SpecialDiscAmt = SpecialDiscAmt;

                    string StockIDNew = objStock.Insert().ToString();

                    if (StockIDNew == string.Empty)
                    {

                        tnx.Rollback();
                        tnx.Dispose();
                        conn.Close();
                        conn.Dispose();
                        return string.Empty;
                    }
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_ledgertnxdetail SET StockID='" + StockIDNew + "' WHERE ID=" + LdgTrnxDtlID + "");

                }


            }

            for (int i = 0; i < dataInvoice.Count; i++)
            {
                if (dataInvoice[i].ChalanNo == "")
                {
                    chalanNo = "";
                    chalanDate = "01-01-0001";
                }
                else
                {
                    chalanNo = Util.GetString(dataInvoice[i].ChalanNo);
                    chalanDate = Util.GetDateTime(dataInvoice[i].ChalanDate).ToString("yyyy-MM-dd");
                }
                if (dataInvoice[i].InvoiceNo == "")
                {
                    invoiceNo = "";
                    InvoiceDate = "01-01-0001";
                }
                else
                {
                    invoiceNo = Util.GetString(dataInvoice[i].InvoiceNo);
                    InvoiceDate = Util.GetDateTime(dataInvoice[i].InvoiceDate).ToString("yyyy-MM-dd");
                }
                VenLedgerNo = Util.GetString(dataInvoice[i].VenLedgerNo);
                LedgerTnxNo = Util.GetString(dataInvoice[i].LedgerTnxNo);
                StringBuilder sb = new StringBuilder();
                sb.Append(" UPDATE f_stock st INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionNo`=st.`LedgerTransactionNo` INNER JOIN f_invoicemaster im ON im.`LedgerTnxNo`=lt.`LedgerTransactionNo`  ");
                sb.Append(" SET st.`ChalanNo`='" + chalanNo + "',lt.`ChalanNo`='" + chalanNo + "',im.`ChalanNo`='" + chalanNo + "',st.`ChalanDate`='" + chalanDate + "',im.`ChalanDate`='" + chalanDate + "',  ");
                sb.Append(" st.`InvoiceNo`='" + invoiceNo + "',lt.`InvoiceNo`='" + invoiceNo + "',im.`InvoiceNo`='" + invoiceNo + "',st.`InvoiceDate`='" + InvoiceDate + "',im.`InvoiceDate`='" + InvoiceDate + "',  ");
                sb.Append(" st.`VenLedgerNo`='" + VenLedgerNo + "',lt.`LedgerNoCr`='" + VenLedgerNo + "',im.`VenLedgerNo`='" + VenLedgerNo + "'  ");
                sb.Append(" WHERE st.`LedgerTransactionNo`='" + LedgerTnxNo + "' ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                DataSet dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "SELECT SUM(ltd.amount)netamt,SUM(purtaxamt)purtaxamt,SUM(ltd.DiscAmt)DisAmt,sum(ltd.amount) grossAmt,Freight,Octori,lt.RoundOff,SUM(ltd.specialDiscAmt)SpecialDiscAmt FROM f_ledgertnxdetail  ltd INNER JOIN f_ledgertransaction lt ON ltd.`LedgerTransactionNo`=lt.`LedgerTransactionNo` WHERE lt.LedgerTransactionNo='" + LedgerTnxNo + "'");

                Decimal TotalAmt = Util.GetDecimal(dt.Tables[0].Rows[0]["netamt"].ToString()) + Util.GetDecimal(dt.Tables[0].Rows[0]["purtaxamt"].ToString()) - Util.GetDecimal(dt.Tables[0].Rows[0]["DisAmt"].ToString()) + Util.GetDecimal(dt.Tables[0].Rows[0]["Octori"].ToString()) + Util.GetDecimal(dt.Tables[0].Rows[0]["Freight"].ToString()) - Util.GetDecimal(dt.Tables[0].Rows[0]["SpecialDiscAmt"].ToString());
                decimal tmpAmt = Math.Round(TotalAmt, 0);
                decimal roundOff = tmpAmt - TotalAmt;
                decimal totaldiscount = Util.GetDecimal(dt.Tables[0].Rows[0]["DisAmt"].ToString()) + Util.GetDecimal(dt.Tables[0].Rows[0]["SpecialDiscAmt"].ToString());
                str = "UPDATE f_ledgertransaction lt SET lt.netamount='" + tmpAmt + "' ,lt.grossamount='" + TotalAmt + "',DiscountOnTotal='" + totaldiscount + "',RoundOff='" + roundOff + "'   WHERE lt.LedgerTransactionNo='" + LedgerTnxNo + "' ";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
                str = " UPDATE f_stock im SET InvoiceAmount='" + tmpAmt + "' WHERE im.LedgerTransactionNO='" + LedgerTnxNo + "' ";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
                str = " UPDATE f_invoicemaster  SET InvoiceAmount='" + tmpAmt + "' WHERE LedgerTnxNo='" + LedgerTnxNo + "' ";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
            }
            tnx.Commit();
            tnx.Dispose();
            conn.Close();
            conn.Dispose();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            tnx.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            conn.Close();
            conn.Dispose();
            return string.Empty;
        }


    }

    protected void UpdateItem(MySqlTransaction tnx, decimal igstPer, decimal cgstPer, decimal sgstPer, string GSTType, string stockId, decimal perUnitPrice, decimal igstAmtPerUnit, decimal cgstAmtPerUnit, decimal sgstAmtPerUnit, string HSNCode)
    {
        string str = string.Empty;
        decimal totalTaxper = Math.Round((igstPer + cgstPer + sgstPer), 4);
        DataTable dtSales = StockReports.GetDataTable("SELECT sd.`SalesID`,sd.`SoldUnits`,sd.`LedgerTnxNo`,sd.`PerUnitSellingPrice`,sd.`DiscAmt` FROM f_salesdetails sd WHERE sd.`StockID`='" + stockId + "'");
        foreach (DataRow dr in dtSales.Rows)
        {
            decimal perUnitMRP = Util.GetDecimal(dr["PerUnitSellingPrice"]);
            decimal soldQty = Util.GetDecimal(dr["SoldUnits"]);
            decimal discAmt = Util.GetDecimal(dr["DiscAmt"]);
            string salesId = Util.GetString(dr["SalesID"]);
            string LedgerTnxNo = Util.GetString(dr["LedgerTnxNo"]);

            decimal taxableAmt = ((perUnitMRP - discAmt) * 100 * soldQty) / (100 + igstPer + cgstPer + sgstPer);
            decimal IGSTTaxAmount = Math.Round(taxableAmt * igstPer / 100, 4, MidpointRounding.AwayFromZero);
            decimal CGSTTaxAmount = Math.Round(taxableAmt * cgstPer / 100, 4, MidpointRounding.AwayFromZero);
            decimal SGSTTaxAmount = Math.Round(taxableAmt * sgstPer / 100, 4, MidpointRounding.AwayFromZero);
            decimal purTaxAmt = Math.Round(((perUnitMRP * soldQty) * totalTaxper / 100), 4);

            str = "UPDATE f_salesdetails sd SET sd.`PerUnitBuyPrice`='" + perUnitPrice + "',sd.`TaxAmt`='" + purTaxAmt + "',sd.`TaxPercent`='" + totalTaxper + "',sd.`IGSTAmt`='" + IGSTTaxAmount + "',sd.`IGSTPercent`='" + igstPer + "',sd.`CGSTAmt`='" + CGSTTaxAmount + "',sd.`CGSTPercent`='" + cgstPer + "',sd.`SGSTAmt`='" + SGSTTaxAmount + "',sd.`SGSTPercent`='" + sgstPer + "',sd.`HSNCode`='" + HSNCode + "',sd.`GSTType`='" + GSTType + "' WHERE sd.`SalesID`='" + salesId + "'";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
            str = "UPDATE f_ledgertnxdetail ltd SET ltd.`unitPrice`='" + perUnitPrice + "',ltd.`PurTaxAmt`='" + purTaxAmt + "',ltd.`PurTaxPer`='" + totalTaxper + "',ltd.`HSNCode`='" + HSNCode + "',ltd.`IGSTPercent`='" + igstPer + "',ltd.`IGSTAmt`='" + IGSTTaxAmount + "',ltd.`CGSTPercent`='" + cgstPer + "',ltd.`CGSTAmt`='" + CGSTTaxAmount + "',ltd.`SGSTPercent`='" + sgstPer + "',ltd.`SGSTAmt`='" + SGSTTaxAmount + "' WHERE ltd.`StockID`='" + stockId + "' AND ltd.`ID`='" + LedgerTnxNo + "'";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

        }

        DataTable dtStock = StockReports.GetDataTable("SELECT st.`StockID` FROM f_stock st  WHERE st.`FromStockID`='" + stockId + "'");
        foreach (DataRow dr in dtStock.Rows)
        {
            string stockIDNew = Util.GetString(dr["StockID"]);
            str = "UPDATE f_stock st SET st.`unitPrice`='" + perUnitPrice + "',st.`PurTaxPer`='" + totalTaxper + "',st.`HSNCode`='" + HSNCode + "',st.`IGSTPercent`='" + igstPer + "',st.`IGSTAmtPerUnit`='" + igstAmtPerUnit + "',st.`CGSTPercent`='" + cgstPer + "',st.`CGSTAmtPerUnit`='" + cgstAmtPerUnit + "',st.`SGSTPercent`='" + sgstPer + "',st.`SGSTAmtPerUnit`='" + sgstAmtPerUnit + "',st.`GSTType`='" + GSTType + "' WHERE st.`StockID`='" + stockIDNew + "'";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
            UpdateItem(tnx, igstPer, cgstPer, sgstPer, GSTType, stockIDNew, perUnitPrice, igstAmtPerUnit, cgstAmtPerUnit, sgstAmtPerUnit, HSNCode);
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
        sb.Append(" WHERE IM.IsActive=1 AND IM.IsAsset=1 ");
        //if(StoreLedgerNo=="STO00001")
        //sb.Append(" AND c.ConfigID ='11' ");
        //else
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
    [WebMethod(EnableSession = true, Description = "Remove GRN Item")]
    public string RemoveItem(string StockID, string GRNNo)
    {
        try
        {
            StockReports.ExecuteDML("CALL Cancel_DirectGRNItem_Med('" + StockID.Trim() + "','" + GRNNo.Trim() + "','','" + HttpContext.Current.Session["ID"].ToString() + "')");
            return "1";
        }
        catch (Exception ex)
        {
            return string.Empty;

        }
    }
    [WebMethod(EnableSession = true, Description = "Check Authority")]
    public string checkAuthority(string GRNNo)
    {
        string canEdit = "1";
        string isPost = Util.GetString(StockReports.ExecuteScalar("SELECT IF(st.`IsPost`=1,IF(st.`InvoiceNo`='',IF(st.`ChalanNo`='','1','0'),'1'),'0') FROM f_stock st WHERE st.`LedgerTransactionNo`='" + GRNNo + "' LIMIT 1"));
        if (isPost == "1")
        {
            canEdit = "0";
            DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(HttpContext.Current.Session["RoleID"]), Util.GetString(HttpContext.Current.Session["ID"]));
            if (dtAuthority.Rows.Count > 0)
            {
                if (Util.GetInt(dtAuthority.Rows[0]["IsEditAfterPost"]) == 1)
                {
                    canEdit = "1";
                }

            }

        }

        return canEdit;

    }
    // Chalan Work Ends
    //New Direct GRN Work
    [WebMethod(EnableSession = true, Description = "Check Authority")]
    public string TaxCalculation(string BillDiscPer, string BillDiscAmt, string BillGrossAmt, string DiscPer, string DiscAmt, string Rate, string MRP, string QTY, string spclDiscPer, string spclDiscAmt, string CGSTPer, string SGSTPer, string IGSTPer, string Type)
    {
        decimal DealRate = Util.GetDecimal(Rate);
        decimal TotalTax = Math.Round(Util.GetDecimal(CGSTPer) + Util.GetDecimal(SGSTPer) + Util.GetDecimal(IGSTPer), 4);
        decimal discountPer = 0; decimal discountAmt = 0;
        decimal SpecialDiscPer = 0; decimal SpecialDiscAmt = 0;
        if (Util.GetDecimal(BillDiscPer) > 0 || Util.GetDecimal(BillDiscAmt) > 0)
        {
            if (Util.GetDecimal(BillDiscAmt) > 0)
            {
                discountPer = (Util.GetDecimal(BillDiscAmt) * 100) / Util.GetDecimal(BillGrossAmt);
            }
            else
            {
                discountPer = Util.GetDecimal(BillDiscPer);
            }
        }
        else if (Util.GetDecimal(DiscAmt) > 0)
        {

            discountAmt = Util.GetDecimal(DiscAmt);
        }
        else
        {
            discountPer = Util.GetDecimal(DiscPer);
        }
        if (Util.GetDecimal(spclDiscPer) > 0)
        {
            SpecialDiscPer = Math.Round(Util.GetDecimal(spclDiscPer), 2);
        }
        else if (Util.GetDecimal(spclDiscAmt) > 0)
        {
            SpecialDiscAmt = Util.GetDecimal(spclDiscAmt);

        }

        List<TaxCalculation_DirectGRN> taxCalculate = new List<TaxCalculation_DirectGRN>()
		{
		 new TaxCalculation_DirectGRN 
		 {
			 DiscAmt=discountAmt, 
			 DiscPer=discountPer, 
			 MRP=Util.GetDecimal(MRP),
			 Quantity = Util.GetDecimal(QTY),
			 Rate=DealRate,
			 TaxPer = TotalTax,
			 Type = Type,
			 ExcisePer= Util.GetDecimal(0),
			 ActualRate=Util.GetDecimal(Rate), 
			//GST Changes
			 IGSTPrecent=Util.GetDecimal(IGSTPer),
			 CGSTPercent=Util.GetDecimal(CGSTPer),
			 SGSTPercent=Util.GetDecimal(SGSTPer),
			// To pass Special Discount
			 SpecialDiscPer=Util.GetDecimal(SpecialDiscPer),
			 SpecialDiscAmt=Util.GetDecimal(SpecialDiscAmt)
		 }
		 };
        if (Util.GetDecimal(DiscAmt) > 0 && Util.GetDecimal(Rate) > 0)
        {
            discountPer = Math.Round((Util.GetDecimal(DiscAmt) * 100) / (Util.GetDecimal(Rate) * Util.GetDecimal(QTY)), 2);
        }
        if (Util.GetDecimal(spclDiscAmt) > 0 && Util.GetDecimal(Rate) > 0)
        {
            SpecialDiscPer = Math.Round(((SpecialDiscAmt * 100) / ((Util.GetDecimal(Rate) * Util.GetDecimal(QTY)) - ((Util.GetDecimal(Rate) * Util.GetDecimal(QTY)) * Util.GetDecimal(discountPer) / 100))), 2);
        }
        string taxCalculation = AllLoadData_Store.taxCalulation(taxCalculate);
        return taxCalculation + "#" + discountPer + "#" + SpecialDiscPer;
    }
    [WebMethod(EnableSession = true, Description = "Check Authority")]
    public string getReturnItems(string StoreType, string VendorLedgerNo, string DeptLedgerNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ST.`StockID`,CONCAT(ST.ItemName,'(Batch :',st.`BatchNumber`,' Exp :',DATE_FORMAT(st.`MedExpiryDate`,'%d-%b-%Y'),' AvlQty:',(ST.InitialCount-st.ReleasedCount ),')')Item FROM f_stock  ST INNER JOIN f_ledgertransaction LT");
        sb.Append(" on LT.LedgerTransactionNo=ST.LedgerTransactionNo WHERE ST.DeptLedgerNo = '" + DeptLedgerNo + "' AND  ");
        if (StoreType == "STO00001") // Medical Store
            sb.Append(" LT.TypeOfTnx='PURCHASE' AND  ");
        else if (StoreType == "STO00002")  // General Store
            sb.Append(" LT.TypeOfTnx='NMPURCHASE' AND  ");
        sb.Append(" (ST.InitialCount-st.ReleasedCount )>0 and ST.IsPost=1 and LT.LedgerNoCr='" + VendorLedgerNo + "' AND st.StoreLedgerNo='" + StoreType + "'");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true, Description = "Check Authority")]
    public string bindGRNReturnItem(string StockId, string ReturnQTY)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT st.`StockID`,st.`ItemID`,st.`ItemName`,st.`BatchNumber`,st.`ConversionFactor` 'CF',st.`SubCategoryID` ,st.`unitPrice`,st.`MinorUnit` 'SalesUnit',st.`MinorUnit` 'PurUnit', ");
        sb.Append(" ROUND((st.`Rate`/st.`ConversionFactor`),2)'PurRate', st.`MRP`,IF(st.`IsExpirable`=0,'',DATE_FORMAT(st.`MedExpiryDate`,'%c/%y'))ExpDate, ");
        sb.Append(" st.`IsExpirable`,st.`IGSTPercent`,st.`IGSTAmtPerUnit`,st.`CGSTPercent`,st.`CGSTAmtPerUnit`,st.`SGSTPercent`,st.`SGSTAmtPerUnit`,st.`GSTType`, ");
        sb.Append(" st.`HSNCode`,st.`InvoiceNo`,st.`LedgerTransactionNo` FROM f_stock st  WHERE st.`StockID`='" + StockId + "' AND (st.`InitialCount`-st.`ReleasedCount`)>='" + ReturnQTY + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true, Description = "Validate Invoice or Challan")]
    public string checkDuplicateInvoice(string VendorLedgerNo, string InvoiceNo, string ChallanNo, string Type)
    {
        string InvNo = string.Empty;
        if (Type.Trim() == "Invoice" || Type.Trim() == "Challan with Invoice")
        {
            InvNo = StockReports.ExecuteScalar("SELECT count(*) FROM f_ledgermaster lm INNER JOIN f_invoicemaster im ON lm.LedgerNumber = im.VenLedgerNo inner join f_ledgertransaction lt on lt.LedgerTransactionNo=im.LedgerTnxNo WHERE im.VenLedgerNo='" + VendorLedgerNo.Trim() + "' AND im.InvoiceNo='" + InvoiceNo.Trim() + "' and lt.IsCancel=0 ");
            if (Util.GetInt(InvNo) > 0)
                return "1";
        }
        if (Type.Trim() == "Challan" || Type.Trim() == "Challan with Invoice")
        {
            InvNo = StockReports.ExecuteScalar("SELECT count(*) FROM f_ledgermaster lm INNER JOIN f_invoicemaster im ON lm.LedgerNumber = im.VenLedgerNo inner join f_ledgertransaction lt on lt.LedgerTransactionNo=im.LedgerTnxNo WHERE im.VenLedgerNo='" + VendorLedgerNo + "' AND im.ChalanNo='" + ChallanNo.Trim() + "' and lt.IsCancel=0 ");
            if (Util.GetInt(InvNo) > 0)
                return "2";
        }
        return "0";
    }

    [WebMethod(EnableSession = true)]
    public string SaveGRN(object InvoiceData, object ItemDetails)
    {
        List<DirectGRNInvoiceDetails> dataInvoice = new JavaScriptSerializer().ConvertToType<List<DirectGRNInvoiceDetails>>(InvoiceData);
        List<DirectGRNItemDetails> dataItemDetails = new JavaScriptSerializer().ConvertToType<List<DirectGRNItemDetails>>(ItemDetails);

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction objTran = con.BeginTransaction(IsolationLevel.ReadCommitted);

        try
        {
            string LedgerTnxNo = string.Empty;
            string GRNNo = string.Empty;
            string TransactionType = "NMPURCHASE";
            GRNNo = Util.GetString(MySqlHelper.ExecuteScalar(objTran, CommandType.Text, "SELECT get_Tran_idPh('" + TransactionType + "','" + Util.GetString(dataItemDetails[0].DeptLedgerNo) + "'," + Util.GetInt(Session["CentreID"].ToString()) + ")"));

            if (GRNNo == string.Empty)
            {
                objTran.Rollback();
                objTran.Dispose();
                con.Close();
                con.Dispose();
                return "";
            }
            
            
            Ledger_Transaction objLedTran = new Ledger_Transaction(objTran);
            objLedTran.LedgerNoCr = Util.GetString(dataInvoice[0].VenLedgerNo);
            objLedTran.Hospital_ID = Session["HOSPID"].ToString();
            if (Util.GetString(dataInvoice[0].StoreLedgerNo) == "STO00001")
            {
                objLedTran.LedgerNoDr = "STO00001";
                objLedTran.TypeOfTnx = "PURCHASE";
            }
            else if (Util.GetString(dataInvoice[0].StoreLedgerNo) == "STO00002")
            {
                objLedTran.LedgerNoDr = "STO00002";
                objLedTran.TypeOfTnx = "NMPURCHASE";
            }
            objLedTran.Date = DateTime.Now;
            objLedTran.AgainstPONo = string.Empty;
            objLedTran.BillNo = GRNNo;
            objLedTran.GrossAmount = Util.GetDecimal(dataInvoice[0].NetAmount);   // + RoundOff already added in net amount calculation    Gaurav 14.12.2017
            objLedTran.NetAmount = Util.GetDecimal(dataInvoice[0].NetAmount);
            objLedTran.DiscountOnTotal = Util.GetDecimal(dataInvoice[0].DiscAmount);
            objLedTran.IsCancel = 0;
            objLedTran.CancelReason = string.Empty;
            objLedTran.CancelAgainstLedgerNo = string.Empty;
            objLedTran.CancelDate = Util.GetDateTime(string.Empty);
            objLedTran.InvoiceNo = Util.GetString(dataInvoice[0].InvoiceNo);
            objLedTran.ChalanNo = Util.GetString(dataInvoice[0].ChalanNo);
            objLedTran.Time = DateTime.Now;
//objLedTran.Freight = Util.GetDecimal(dataInvoice[0].FrieghtCharges);
            objLedTran.Octori = 0;
            objLedTran.GatePassInWard = Util.GetString(dataInvoice[0].GatePassIn);
            objLedTran.RoundOff = Util.GetDecimal(dataInvoice[0].RoundOff);
            objLedTran.PaymentModeID = Util.GetInt(dataInvoice[0].PaymentModeID);
            objLedTran.UserID = Session["ID"].ToString();
            objLedTran.CentreID = Util.GetInt(Session["CentreID"].ToString());
            objLedTran.IpAddress = All_LoadData.IpAddress();
            objLedTran.DeptLedgerNo = Util.GetString(dataItemDetails[0].DeptLedgerNo);
            objLedTran.WayBillNo = Util.GetString(dataInvoice[0].WayBillNo);
            objLedTran.WayBillDate = Util.GetDateTime(dataInvoice[0].WayBillDate);
            LedgerTnxNo = objLedTran.Insert().ToString();

            if (LedgerTnxNo == string.Empty)
            {
                objTran.Rollback();
                objTran.Dispose();
                con.Close();
                con.Dispose();
                return "";
            }

            InvoiceMaster objInvMas = new InvoiceMaster(objTran);

            objInvMas.Hospital_ID = Session["HOSPID"].ToString();
            objInvMas.InvoiceNo = Util.GetString(dataInvoice[0].InvoiceNo);
            objInvMas.InvoiceDate = Util.GetDateTime(dataInvoice[0].InvoiceDate);
            objInvMas.ChalanNo = Util.GetString(dataInvoice[0].ChalanNo);
            objInvMas.ChalanDate = Util.GetDateTime(dataInvoice[0].ChalanDate);

            if (Util.GetString(dataInvoice[0].InvoiceNo) != string.Empty)
                objInvMas.IsCompleteInvoice = "YES";
            else
                objInvMas.IsCompleteInvoice = "NO";
            objInvMas.PONumber = string.Empty;
            objInvMas.VenLedgerNo = Util.GetString(dataInvoice[0].VenLedgerNo);
            objInvMas.LedgerTnxNo = LedgerTnxNo;
            objInvMas.InvoiceAmount = Util.GetDecimal(dataInvoice[0].NetAmount);
            objInvMas.DiffBillAmt = 0;
            objInvMas.WayBillNo = Util.GetString(dataInvoice[0].WayBillNo);
            objInvMas.WayBillDate = Util.GetDateTime(dataInvoice[0].WayBillDate);
            string InvMID = objInvMas.Insert().ToString();

            if (InvMID == string.Empty)
            {
                objTran.Rollback();
                objTran.Dispose();
                con.Close();
                con.Dispose();
                return "";
            }

            for (int i = 0; i < dataItemDetails.Count; i++)
            {
                DateTime ExpityDate = Util.GetDateTime(StockReports.ExecuteScalar("SELECT LAST_DAY( DATE_ADD('" + Util.GetDateTime(dataItemDetails[i].MedExpiryDate).ToString("yyyy-MM-dd") + "', INTERVAL 0 MONTH)) "));
                LedgerTnxDetail objLTDetail = new LedgerTnxDetail(objTran);
                objLTDetail.Hospital_Id = Session["HOSPID"].ToString();
                objLTDetail.LedgerTransactionNo = LedgerTnxNo;
                objLTDetail.ItemID = Util.GetString(dataItemDetails[i].ItemID);
                objLTDetail.SubCategoryID = Util.GetString(dataItemDetails[i].SubCategoryID);
                objLTDetail.Rate = Util.GetDecimal(dataItemDetails[i].Rate);
                objLTDetail.Quantity = Util.GetDecimal(dataItemDetails[i].Quantity);
                objLTDetail.StockID = string.Empty;
                objLTDetail.ItemName = Util.GetString(dataItemDetails[i].ItemName);
                objLTDetail.EntryDate = DateTime.Now;
                objLTDetail.UserID = Session["ID"].ToString();
                objLTDetail.UpdatedDate = DateTime.Now;
                if (Util.GetString(dataItemDetails[i].PurTaxPer) != string.Empty && Util.GetDecimal(dataItemDetails[i].PurTaxPer) > 0)
                    objLTDetail.IsTaxable = "YES";
                else
                    objLTDetail.IsTaxable = "NO";
                objLTDetail.DiscountPercentage = Util.GetDecimal(dataItemDetails[i].DiscPer);
                objLTDetail.DiscAmt = Util.GetDecimal(dataItemDetails[i].DiscAmt);
                objLTDetail.Amount = Util.GetDecimal(dataItemDetails[i].ItemGrossAmount);
                objLTDetail.IsFree = Util.GetInt(dataItemDetails[i].IsFree);
                objLTDetail.CentreID = Util.GetInt(Session["CentreID"].ToString());
                objLTDetail.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                objLTDetail.medExpiryDate = Util.GetDateTime(ExpityDate);
                objLTDetail.IsExpirable = Util.GetInt(dataItemDetails[i].IsExpirable);
                objLTDetail.pageURL = All_LoadData.getCurrentPageName();
                objLTDetail.NetItemAmt = Util.GetDecimal(objLTDetail.Amount);
                objLTDetail.TotalDiscAmt = Util.GetDecimal(objLTDetail.DiscAmt);
                objLTDetail.IpAddress = HttpContext.Current.Request.UserHostAddress;
                objLTDetail.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(dataItemDetails[i].SubCategoryID), con));
                objLTDetail.Type = "S";
                objLTDetail.BatchNumber = Util.GetString(dataItemDetails[i].BatchNumber);
                objLTDetail.StoreLedgerNo = Util.GetString(dataInvoice[0].StoreLedgerNo);
                objLTDetail.DeptLedgerNo = Util.GetString(dataItemDetails[i].DeptLedgerNo);
                objLTDetail.PurTaxAmt = Util.GetDecimal(dataItemDetails[i].PurTaxAmt);
                objLTDetail.PurTaxPer = Util.GetDecimal(dataItemDetails[i].PurTaxPer);
                objLTDetail.HSNCode = Util.GetString(dataItemDetails[i].HSNCode);
                objLTDetail.IGSTPercent = Util.GetDecimal(dataItemDetails[i].IGSTPercent);
                objLTDetail.IGSTAmt = Util.GetDecimal(dataItemDetails[i].IGSTAmt);
                objLTDetail.CGSTPercent = Util.GetDecimal(dataItemDetails[i].CGSTPercent);
                objLTDetail.CGSTAmt = Util.GetDecimal(dataItemDetails[i].CGSTAmt);
                objLTDetail.SGSTPercent = Util.GetDecimal(dataItemDetails[i].SGSTPercent);
                objLTDetail.SGSTAmt = Util.GetDecimal(dataItemDetails[i].SGSTAmt);
                objLTDetail.SpecialDiscPer = Util.GetDecimal(dataItemDetails[i].SpecialDiscPer);
                objLTDetail.SpecialDiscAmt = Util.GetDecimal(dataItemDetails[i].SpecialDiscAmt);
                if (Util.GetDecimal(dataItemDetails[i].ConversionFactor) > 0)
                    objLTDetail.unitPrice = Util.GetDecimal(Util.GetDecimal(dataItemDetails[i].UnitPrice)) / Util.GetDecimal(dataItemDetails[i].ConversionFactor);
                else
                    objLTDetail.unitPrice = Util.GetDecimal(dataItemDetails[i].UnitPrice);
                string LdgTrnxDtlID = objLTDetail.Insert().ToString();

                if (LdgTrnxDtlID == string.Empty)
                {
                    objTran.Rollback();
                    objTran.Dispose();
                    con.Close();
                    con.Dispose();
                    return string.Empty;
                }
                Stock objStock = new Stock(objTran);
                decimal MRP = Util.GetDecimal(dataItemDetails[i].MRP);
                objStock.Hospital_ID = Session["HOSPID"].ToString();
                objStock.ItemID = Util.GetString(dataItemDetails[i].ItemID);
                objStock.ItemName = Util.GetString(dataItemDetails[i].ItemName);
                objStock.LedgerTransactionNo = LedgerTnxNo;
                objStock.LedgerTnxNo = LdgTrnxDtlID;
                objStock.BatchNumber = Util.GetString(dataItemDetails[i].BatchNumber);
                dataItemDetails[i].ConversionFactor = 1;
                if (Util.GetDecimal(dataItemDetails[i].ConversionFactor) > 0)
                    objStock.UnitPrice = Util.GetDecimal(Util.GetDecimal(dataItemDetails[i].UnitPrice)) / Util.GetDecimal(dataItemDetails[i].ConversionFactor);
                else
                    objStock.UnitPrice = Util.GetDecimal(Util.GetDecimal(dataItemDetails[i].UnitPrice));
                objStock.MRP = Util.GetDecimal(Util.GetDecimal(MRP)) / Util.GetDecimal(dataItemDetails[i].ConversionFactor);
                objStock.MajorMRP = Util.GetDecimal(Util.GetDecimal(MRP));
                objStock.IsCountable = 1;
                objStock.InitialCount = Util.GetDecimal(dataItemDetails[i].Quantity) * Util.GetDecimal(dataItemDetails[i].ConversionFactor);
                objStock.ReleasedCount = 0;
                objStock.IsReturn = 0;
                objStock.LedgerNo = string.Empty;
                if (dataItemDetails[i].MedExpiryDate.ToString().Length > 0)
                {
                    objStock.MedExpiryDate = Util.GetDateTime(ExpityDate);
                }
                else
                {
                    objStock.MedExpiryDate = DateTime.Now.AddYears(5);
                }
                objStock.StockDate = DateTime.Now;
                if (Util.GetString(dataInvoice[0].StoreLedgerNo) == "STO00001")
                {
                    objStock.TypeOfTnx = "Purchase";
                    objStock.StoreLedgerNo = "STO00001";
                }
                else if (Util.GetString(dataInvoice[0].StoreLedgerNo) == "STO00002")
                {
                    objStock.TypeOfTnx = "NMPURCHASE";
                    objStock.StoreLedgerNo = "STO00002";
                }
                objStock.IsPost = 0;
                objStock.Naration = Util.GetString(dataItemDetails[i].Naration);
                objStock.IsFree = Util.GetInt(dataItemDetails[i].IsFree);
                objStock.SubCategoryID = Util.GetString(dataItemDetails[i].SubCategoryID);
                objStock.Unit = Util.GetString(dataItemDetails[i].MinorUnit);
                objStock.DeptLedgerNo = Util.GetString(dataItemDetails[i].DeptLedgerNo);
                objStock.UserID = Session["ID"].ToString();
                objStock.IsBilled = 1;
                objStock.Rate = Util.GetDecimal(dataItemDetails[i].Rate);
                objStock.DiscPer = Util.GetDecimal(dataItemDetails[i].DiscPer);
                objStock.VenLedgerNo = Util.GetString(dataItemDetails[i].VenLedgerNo);
                objStock.DiscAmt = Util.GetDecimal(dataItemDetails[i].DiscAmt);
                objStock.TYPE = Util.GetString(StockReports.ExecuteScalar("SELECT im.Type_ID FROM f_itemmaster im WHERE im.ItemID='" + Util.GetString(dataItemDetails[i].ItemID) + "'"));
                string Reusable = Util.GetString(StockReports.ExecuteScalar("SELECT im.IsUsable FROM f_itemmaster im WHERE im.ItemID='" + Util.GetString(dataItemDetails[i].ItemID) + "'"));
                if (Reusable == "R")
                    objStock.Reusable = Util.GetInt("1");
                else
                    objStock.Reusable = Util.GetInt("0");
                objStock.ConversionFactor = Util.GetDecimal(dataItemDetails[i].ConversionFactor);
                objStock.MajorUnit = Util.GetString(dataItemDetails[i].MajorUnit);
                objStock.MinorUnit = Util.GetString(dataItemDetails[i].MinorUnit);
                objStock.InvoiceNo = Util.GetString(dataItemDetails[i].InvoiceNo);
                objStock.InvoiceDate = Util.GetDateTime(dataItemDetails[i].InvoiceDate);
                objStock.CentreID = Util.GetInt(Session["CentreID"].ToString());
                objStock.IpAddress = All_LoadData.IpAddress();
                objStock.IsExpirable = Util.GetInt(dataItemDetails[i].IsExpirable);
                objStock.PurTaxPer = Util.GetDecimal(dataItemDetails[i].PurTaxPer);
                objStock.PurTaxAmt = Util.GetDecimal(dataItemDetails[i].PurTaxAmt);
                objStock.ExciseAmt = Util.GetDecimal("0");
                objStock.ExcisePer = Util.GetDecimal("0");
                objStock.taxCalculateOn = "RateAD";
                objStock.HSNCode = Util.GetString(dataItemDetails[i].HSNCode);
                objStock.GSTType = Util.GetString(dataItemDetails[i].GSTType);
                objStock.IGSTPercent = Util.GetDecimal(dataItemDetails[i].IGSTPercent);
                objStock.IGSTAmtPerUnit = Math.Round(objLTDetail.IGSTAmt / (Util.GetDecimal(objStock.InitialCount)), 4, MidpointRounding.AwayFromZero);
                objStock.CGSTPercent = Util.GetDecimal(dataItemDetails[i].CGSTPercent);
                objStock.CGSTAmtPerUnit = Math.Round(objLTDetail.CGSTAmt / (Util.GetDecimal(objStock.InitialCount)), 4, MidpointRounding.AwayFromZero);
                objStock.SGSTPercent = Util.GetDecimal(dataItemDetails[i].SGSTPercent);
                objStock.SGSTAmtPerUnit = Math.Round(objLTDetail.SGSTAmt / (Util.GetDecimal(objStock.InitialCount)), 4, MidpointRounding.AwayFromZero);
                objStock.SpecialDiscPer = Util.GetDecimal(dataItemDetails[i].SpecialDiscPer);
                objStock.SpecialDiscAmt = Util.GetDecimal(dataItemDetails[i].SpecialDiscAmt);
                objStock.ChalanNo = Util.GetString(dataItemDetails[i].ChalanNo);
                objStock.ChalanDate = Util.GetDateTime(dataItemDetails[i].ChalanDate);
                objStock.IsAsset = 1;
                string StockID = objStock.Insert().ToString();

                if (StockID == string.Empty)
                {
                    objTran.Rollback();
                    objTran.Dispose();
                    con.Close();
                    con.Dispose();
                    return "";
                }
                ExcuteCMD excuteCMD = new ExcuteCMD();
                string CentreCode = excuteCMD.ExecuteScalar("SELECT CentreCode FROM center_master WHERE CentreID=@CentreID", new
                {
                    CentreID = HttpContext.Current.Session["CentreID"].ToString(),
                });
                for (int j = 0; j < Util.GetInt(dataItemDetails[i].Quantity); j++)
                {
                    var sqlcmd = "INSERT INTO eq_asset_master (ItemID,ItemName,StockID,SupplierID,PurchaseDate,BatchNumber,CreatedBy,LedgerTransactionNo)VALUES(@ItemID,@ItemName,@StockID,@SupplierID,@PurchaseDate,@BatchNumber,@CreatedBy,@LedgerTransactionNo);SELECT @@identity;";
                    var AssetID = Util.GetInt(excuteCMD.ExecuteScalar(objTran, sqlcmd, CommandType.Text, new
                    {
                        StockID = StockID,
                        ItemID = dataItemDetails[i].ItemID,
                        ItemName = dataItemDetails[i].ItemName,
                        LedgerTransactionNo = LedgerTnxNo,
                        BatchNumber = dataItemDetails[i].BatchNumber,
                        PurchaseDate = dataItemDetails[i].AssetPurDate,
                        CreatedBy = HttpContext.Current.Session["ID"].ToString(),
                        SupplierID = dataItemDetails[i].VenLedgerNo,
                    }));

                      //--------To generate Automatic Asset No----------
                 string PurchaseYear = Util.GetDateTime(dataItemDetails[i].AssetPurDate).ToString("yy");
                    string AssetNo = CentreCode + "-" + PurchaseYear + "-" + AssetID;
                    
                    var sqlAset = "Update eq_asset_master Set AssetNo = @AssetNo where ID=@AssetID ";
                    excuteCMD.DML(objTran, sqlAset, CommandType.Text, new
                    {
                       AssetNo =AssetNo,
                       AssetID = AssetID,
                    });
                    //--------To generate Automatic Asset No----------
                    var sql = "  INSERT INTO eq_asset_stock (AssetID,StockID,ItemID,ItemName,LedgerTransactionNo,BatchNumber,unitPrice,MRP,InitialCount,ReleasedCount,PurchaseDate,IsPost,IsFree,SubCategoryID,DeptLedgerNo,CreatedBy,IpAddress,InvoiceNo,InvoiceDate,VenLedgerNo,InvoiceAmount)";
                    sql += "  VALUES(@AssetID,@StockID, @ItemID, @ItemName, @LedgerTransactionNo, @BatchNumber, @unitPrice, @MRP, @InitialCount, @ReleasedCount, @PurchaseDate, @IsPost, @IsFree, @SubCategoryID, @DeptLedgerNo, @CreatedBy, @IpAddress, @InvoiceNo, @InvoiceDate, @VenLedgerNo, @InvoiceAmount); ";
                    excuteCMD.DML(objTran, sql, CommandType.Text, new
                    {
                        AssetID= AssetID,
                        StockID = StockID,
                        ItemID = dataItemDetails[i].ItemID,
                        ItemName = dataItemDetails[i].ItemName,
                        LedgerTransactionNo = LedgerTnxNo,
                        BatchNumber = dataItemDetails[i].BatchNumber,
                        unitPrice = dataItemDetails[i].UnitPrice,
                        MRP = dataItemDetails[i].MRP,
                        InitialCount = 1,
                        ReleasedCount = 0,
                        PurchaseDate = dataItemDetails[i].AssetPurDate,
                        IsPost = 0,
                        IsFree = dataItemDetails[i].IsFree,
                        SubCategoryID = dataItemDetails[i].SubCategoryID,
                        DeptLedgerNo = dataItemDetails[i].DeptLedgerNo,
                        CreatedBy = HttpContext.Current.Session["ID"].ToString(),
                        IpAddress = All_LoadData.IpAddress(),
                        InvoiceNo = dataItemDetails[i].InvoiceNo,
                        InvoiceDate = dataItemDetails[i].InvoiceDate,
                        VenLedgerNo = dataItemDetails[i].VenLedgerNo,
                        InvoiceAmount = dataItemDetails[i].InvoiceAmount,
                    });

                    
                }
                MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, "UPDATE f_ledgertnxdetail SET StockID='" + StockID + "' WHERE ID=" + LdgTrnxDtlID + "");
                if (Util.GetInt(dataItemDetails[i].IsUpdateCF) == 1)
                {
                    MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, "UPDATE f_itemmaster im SET im.ConversionFactor='" + Util.GetDouble(dataItemDetails[i].ConversionFactor) + "' WHERE im.ItemID='" + Util.GetString(dataItemDetails[i].ItemID) + "' ");
                }
                if (Util.GetInt(dataItemDetails[i].IsUpdateHSNCode) == 1)
                {
                    MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, "UPDATE f_itemmaster im SET im.HSNCode='" + Util.GetString(dataItemDetails[i].HSNCode) + "' WHERE im.ItemID='" + Util.GetString(dataItemDetails[i].ItemID) + "'");
                }
                if (Util.GetInt(dataItemDetails[i].IsUpdateGST) == 1)
                {
                    MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, "UPDATE f_itemmaster im SET im.CGSTPercent='" + Util.GetDecimal(dataItemDetails[i].CGSTPercent) + "',im.SGSTPercent='" + Util.GetDecimal(dataItemDetails[i].SGSTPercent) + "',im.IGSTPercent='" + Util.GetDecimal(dataItemDetails[i].IGSTPercent) + "',im.GSTType='" + Util.GetString(dataItemDetails[i].GSTType) + "' WHERE im.ItemID='" + Util.GetString(dataItemDetails[i].ItemID) + "'");
                }
                if (Util.GetInt(dataItemDetails[i].IsUpdateExpirable) == 1)
                {
                    string Expirable = "YES";
                    if (Util.GetInt(dataItemDetails[i].IsExpirable) == 0)
                        Expirable = "NO";
                    MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, "UPDATE f_itemmaster im SET im.IsExpirable='" + Expirable + "' WHERE im.ItemID='" + Util.GetString(dataItemDetails[i].ItemID) + "'");

                }

            }
            objTran.Commit();
            objTran.Dispose();
            con.Close();
            con.Dispose();
            return LedgerTnxNo + "#" + GRNNo;
        }
        catch (Exception ex)
        {
            objTran.Rollback();
            objTran.Dispose();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
    }

    [WebMethod(EnableSession = true)]
    public string SavePOGRN(object InvoiceData, object ItemDetails)
    {
        List<DirectGRNInvoiceDetails> dataInvoice = new JavaScriptSerializer().ConvertToType<List<DirectGRNInvoiceDetails>>(InvoiceData);
        List<DirectGRNItemDetails> dataItemDetails = new JavaScriptSerializer().ConvertToType<List<DirectGRNItemDetails>>(ItemDetails);

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction objTran = con.BeginTransaction(IsolationLevel.ReadCommitted);
        decimal IGSTAmtPerUnit = 0, CGSTAmtPerUnit = 0, SGSTAmtPerUnit = 0;
        string Amt = "";
        decimal perUnitPrice = 0;
        try
        {
            string LedgerTnxNo = string.Empty;
            Ledger_Transaction objLedTran = new Ledger_Transaction(objTran);
            objLedTran.LedgerNoCr = Util.GetString(dataInvoice[0].VenLedgerNo);
            objLedTran.Hospital_ID = Session["HOSPID"].ToString();
            if (Util.GetString(dataInvoice[0].StoreLedgerNo) == "STO00001")
            {
                objLedTran.LedgerNoDr = "STO00001";
                objLedTran.TypeOfTnx = "PURCHASE";
            }
            else if (Util.GetString(dataInvoice[0].StoreLedgerNo) == "STO00002")
            {
                objLedTran.LedgerNoDr = "STO00002";
                objLedTran.TypeOfTnx = "NMPURCHASE";
            }
            objLedTran.Date = DateTime.Now;
            objLedTran.AgainstPONo = Util.GetString(dataInvoice[0].PONumber);
            objLedTran.BillNo = string.Empty;
            objLedTran.GrossAmount = Util.GetDecimal(dataInvoice[0].NetAmount);
            objLedTran.NetAmount = Util.GetDecimal(dataInvoice[0].NetAmount);
            objLedTran.DiscountOnTotal = Util.GetDecimal(dataInvoice[0].DiscAmount);
            objLedTran.IsCancel = 0;
            objLedTran.CancelReason = string.Empty;
            objLedTran.CancelAgainstLedgerNo = string.Empty;
            objLedTran.CancelDate = Util.GetDateTime(string.Empty);
            objLedTran.InvoiceNo = Util.GetString(dataInvoice[0].InvoiceNo);
            objLedTran.ChalanNo = Util.GetString(dataInvoice[0].ChalanNo);
            objLedTran.Time = DateTime.Now;
            objLedTran.Freight = 0;
            objLedTran.Octori = 0;
            objLedTran.GatePassInWard = Util.GetString(dataInvoice[0].GatePassIn);
            objLedTran.RoundOff = Util.GetDecimal(dataInvoice[0].RoundOff);
            objLedTran.PaymentModeID = Util.GetInt(dataInvoice[0].PaymentModeID);
            objLedTran.UserID = Session["ID"].ToString();
            objLedTran.CentreID = Util.GetInt(Session["CentreID"].ToString());
            objLedTran.IpAddress = All_LoadData.IpAddress();
            objLedTran.DeptLedgerNo = Util.GetString(dataItemDetails[0].DeptLedgerNo);
            LedgerTnxNo = objLedTran.Insert().ToString();

            if (LedgerTnxNo == string.Empty)
            {
                objTran.Rollback();
                objTran.Dispose();
                con.Close();
                con.Dispose();
                return "";
            }

            InvoiceMaster objInvMas = new InvoiceMaster(objTran);
            objInvMas.Hospital_ID = Session["HOSPID"].ToString();
            objInvMas.InvoiceNo = Util.GetString(dataInvoice[0].InvoiceNo);
            objInvMas.InvoiceDate = Util.GetDateTime(dataInvoice[0].InvoiceDate);
            objInvMas.ChalanNo = Util.GetString(dataInvoice[0].ChalanNo);
            objInvMas.ChalanDate = Util.GetDateTime(dataInvoice[0].ChalanDate);

            if (Util.GetString(dataInvoice[0].InvoiceNo) != string.Empty)
                objInvMas.IsCompleteInvoice = "YES";
            else
                objInvMas.IsCompleteInvoice = "NO";
            objInvMas.PONumber = Util.GetString(dataInvoice[0].PONumber);
            objInvMas.VenLedgerNo = Util.GetString(dataInvoice[0].VenLedgerNo);
            objInvMas.LedgerTnxNo = LedgerTnxNo;
            objInvMas.InvoiceAmount = Util.GetDecimal(dataInvoice[0].NetAmount);
            objInvMas.DiffBillAmt = 0;
            string InvMID = objInvMas.Insert().ToString();

            if (InvMID == string.Empty)
            {
                objTran.Rollback();
                objTran.Dispose();
                con.Close();
                con.Dispose();
                return "";
            }

            for (int i = 0; i < dataItemDetails.Count; i++)
            {
                List<TaxCalculation_DirectGRN> taxCalculate = new List<TaxCalculation_DirectGRN>()
                {
                    new TaxCalculation_DirectGRN {DiscAmt=0, DiscPer=Util.GetDecimal(dataItemDetails[i].DiscPer), MRP=Util.GetDecimal(dataItemDetails[i].MRP),Quantity = Util.GetDecimal(dataItemDetails[i].Quantity),Rate=dataItemDetails[i].Rate,TaxPer = Util.GetDecimal(dataItemDetails[i].IGSTPercent+dataItemDetails[i].CGSTPercent+dataItemDetails[i].SGSTPercent),Type = Util.GetString(dataItemDetails[i].taxCalculateOn),IGSTPrecent=dataItemDetails[i].IGSTPercent,CGSTPercent=dataItemDetails[i].CGSTPercent,SGSTPercent=dataItemDetails[i].SGSTPercent,ActualRate=Util.GetDecimal(dataItemDetails[i].Rate)}
                };
                Amt = AllLoadData_Store.taxCalulation(taxCalculate);
                decimal GSTPer = Util.GetDecimal(dataItemDetails[i].IGSTPercent + dataItemDetails[i].CGSTPercent + dataItemDetails[i].SGSTPercent);
                // GST Changes
                IGSTAmtPerUnit = Util.GetDecimal(Amt.Split('#')[8].ToString());
                CGSTAmtPerUnit = Util.GetDecimal(Amt.Split('#')[9].ToString());
                SGSTAmtPerUnit = Util.GetDecimal(Amt.Split('#')[10].ToString());
                //-------------------

                LedgerTnxDetail objLTDetail = new LedgerTnxDetail(objTran);
                objLTDetail.Hospital_Id = Session["HOSPID"].ToString();
                objLTDetail.LedgerTransactionNo = LedgerTnxNo;
                objLTDetail.ItemID = Util.GetString(dataItemDetails[i].ItemID);
                objLTDetail.SubCategoryID = Util.GetString(dataItemDetails[i].SubCategoryID);
                objLTDetail.Rate = Util.GetDecimal(dataItemDetails[i].Rate);
                objLTDetail.Quantity = Util.GetDecimal(dataItemDetails[i].Quantity);
                objLTDetail.StockID = string.Empty;
                objLTDetail.ItemName = Util.GetString(dataItemDetails[i].ItemName);
                objLTDetail.EntryDate = DateTime.Now;
                objLTDetail.UserID = Session["ID"].ToString();
                objLTDetail.UpdatedDate = DateTime.Now;
                if (Util.GetString(GSTPer) != string.Empty && Util.GetDecimal(GSTPer) > 0)
                    objLTDetail.IsTaxable = "YES";
                else
                    objLTDetail.IsTaxable = "NO";
                objLTDetail.DiscountPercentage = Util.GetDecimal(dataItemDetails[i].DiscPer);
                objLTDetail.DiscAmt = (Util.GetDecimal(Amt.Split('#')[2].ToString()));
                objLTDetail.Amount = Util.GetDecimal(Amt.Split('#')[3].ToString());
                objLTDetail.IsFree = Util.GetInt(dataItemDetails[i].IsFree);
                objLTDetail.CentreID = Util.GetInt(Session["CentreID"].ToString());
                objLTDetail.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                objLTDetail.IsExpirable = Util.GetInt(dataItemDetails[i].IsExpirable);
                objLTDetail.pageURL = All_LoadData.getCurrentPageName();
                objLTDetail.NetItemAmt = Util.GetDecimal(Amt.Split('#')[0].ToString());
                objLTDetail.TotalDiscAmt = (Util.GetDecimal(Amt.Split('#')[2].ToString()));
                objLTDetail.IpAddress = HttpContext.Current.Request.UserHostAddress;
                objLTDetail.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(dataItemDetails[i].SubCategoryID), con));
                objLTDetail.Type = "S";
                objLTDetail.BatchNumber = Util.GetString(dataItemDetails[i].BatchNumber);
                objLTDetail.StoreLedgerNo = Util.GetString(dataInvoice[0].StoreLedgerNo);
                objLTDetail.DeptLedgerNo = Util.GetString(dataItemDetails[i].DeptLedgerNo);
                objLTDetail.PurTaxAmt = (Util.GetDecimal(Amt.Split('#')[1].ToString()));
                objLTDetail.PurTaxPer = GSTPer;
                objLTDetail.HSNCode = Util.GetString(dataItemDetails[i].HSNCode);
                objLTDetail.IGSTPercent = Util.GetDecimal(dataItemDetails[i].IGSTPercent);
                objLTDetail.IGSTAmt = IGSTAmtPerUnit;
                objLTDetail.CGSTPercent = Util.GetDecimal(dataItemDetails[i].CGSTPercent);
                objLTDetail.CGSTAmt = CGSTAmtPerUnit;
                objLTDetail.SGSTPercent = Util.GetDecimal(dataItemDetails[i].SGSTPercent);
                objLTDetail.SGSTAmt = SGSTAmtPerUnit;
                objLTDetail.SpecialDiscPer = Util.GetDecimal(dataItemDetails[i].SpecialDiscPer);
                objLTDetail.SpecialDiscAmt = Util.GetDecimal(dataItemDetails[i].SpecialDiscAmt);
                if (Util.GetDecimal(dataItemDetails[i].ConversionFactor) > 0)
                    objLTDetail.unitPrice = Util.GetDecimal(Util.GetDecimal(dataItemDetails[i].UnitPrice)) / Util.GetDecimal(dataItemDetails[i].ConversionFactor);
                else
                    objLTDetail.unitPrice = Util.GetDecimal(dataItemDetails[i].UnitPrice);
                string LdgTrnxDtlID = objLTDetail.Insert().ToString();

                if (LdgTrnxDtlID == string.Empty)
                {
                    objTran.Rollback();
                    objTran.Dispose();
                    con.Close();
                    con.Dispose();
                    return string.Empty;
                }
                Stock objStock = new Stock(objTran);
                decimal MRP = Util.GetDecimal(dataItemDetails[i].MRP);
                objStock.Hospital_ID = Util.GetString(HttpContext.Current.Session["HOSPID"].ToString());
                objStock.ItemID = Util.GetString(dataItemDetails[i].ItemID);
                objStock.ItemName = Util.GetString(dataItemDetails[i].ItemName);
                objStock.LedgerTransactionNo = LedgerTnxNo;
                objStock.LedgerTnxNo = LdgTrnxDtlID;
                objStock.BatchNumber = Util.GetString(dataItemDetails[i].BatchNumber);
                if (Util.GetDecimal(dataItemDetails[i].ConversionFactor) > 0)
                    objStock.UnitPrice = Util.GetDecimal(Util.GetDecimal(dataItemDetails[i].UnitPrice)) / Util.GetDecimal(dataItemDetails[i].ConversionFactor);
                else
                    objStock.UnitPrice = Util.GetDecimal(Util.GetDecimal(dataItemDetails[i].UnitPrice));
                objStock.MRP = Util.GetDecimal(Util.GetDecimal(MRP)) / Util.GetDecimal(dataItemDetails[i].ConversionFactor);
                objStock.MajorMRP = Util.GetDecimal(Util.GetDecimal(MRP));
                objStock.IsCountable = 1;
                objStock.InitialCount = Util.GetDecimal(dataItemDetails[i].Quantity) * Util.GetDecimal(dataItemDetails[i].ConversionFactor);
                objStock.ReleasedCount = 0;
                objStock.IsReturn = 0;
                objStock.LedgerNo = string.Empty;
                objStock.StockDate = DateTime.Now;
                if (Util.GetString(dataInvoice[0].StoreLedgerNo) == "STO00001")
                {
                    objStock.TypeOfTnx = "Purchase";
                    objStock.StoreLedgerNo = "STO00001";
                }
                else if (Util.GetString(dataInvoice[0].StoreLedgerNo) == "STO00002")
                {
                    objStock.TypeOfTnx = "NMPURCHASE";
                    objStock.StoreLedgerNo = "STO00002";
                }
                objStock.IsPost = 0;
                objStock.Naration = Util.GetString(dataItemDetails[i].Naration);
                objStock.IsFree = Util.GetInt(dataItemDetails[i].IsFree);
                objStock.SubCategoryID = Util.GetString(dataItemDetails[i].SubCategoryID);
                objStock.Unit = Util.GetString(dataItemDetails[i].MinorUnit);
                objStock.DeptLedgerNo = Util.GetString(dataItemDetails[i].DeptLedgerNo);
                objStock.UserID = Util.GetString(HttpContext.Current.Session["ID"].ToString());
                objStock.IsBilled = 1;
                objStock.Rate = Util.GetDecimal(dataItemDetails[i].Rate);
                objStock.DiscPer = Util.GetDecimal(dataItemDetails[i].DiscPer);
                objStock.VenLedgerNo = Util.GetString(dataItemDetails[i].VenLedgerNo);
                objStock.DiscAmt = Util.GetDecimal(dataItemDetails[i].DiscAmt);
                objStock.TYPE = Util.GetString(StockReports.ExecuteScalar("SELECT im.Type_ID FROM f_itemmaster im WHERE im.ItemID='" + Util.GetString(dataItemDetails[i].ItemID) + "'"));
                string Reusable = Util.GetString(StockReports.ExecuteScalar("SELECT im.IsUsable FROM f_itemmaster im WHERE im.ItemID='" + Util.GetString(dataItemDetails[i].ItemID) + "'"));
                if (Reusable == "R")
                    objStock.Reusable = Util.GetInt("1");
                else
                    objStock.Reusable = Util.GetInt("0");
                objStock.ConversionFactor = Util.GetDecimal(dataItemDetails[i].ConversionFactor);
                objStock.MajorUnit = Util.GetString(dataItemDetails[i].MajorUnit);
                objStock.MinorUnit = Util.GetString(dataItemDetails[i].MinorUnit);
                objStock.InvoiceNo = Util.GetString(dataItemDetails[i].InvoiceNo);
                objStock.InvoiceDate = Util.GetDateTime(dataItemDetails[i].InvoiceDate);
                objStock.CentreID = Util.GetInt(Session["CentreID"].ToString());
                objStock.IpAddress = All_LoadData.IpAddress();
                objStock.IsExpirable = Util.GetInt(dataItemDetails[i].IsExpirable);
                objStock.PurTaxPer = Util.GetDecimal(GSTPer);
                objStock.PurTaxAmt = Util.GetDecimal(Amt.Split('#')[1].ToString());
                objStock.ExciseAmt = Util.GetDecimal("0");
                objStock.ExcisePer = Util.GetDecimal("0");
                objStock.taxCalculateOn = "RateAD";
                objStock.HSNCode = Util.GetString(dataItemDetails[i].HSNCode);
                objStock.GSTType = Util.GetString(dataItemDetails[i].GSTType);
                objStock.IGSTPercent = Util.GetDecimal(dataItemDetails[i].IGSTPercent);
                objStock.IGSTAmtPerUnit = Math.Round(objLTDetail.IGSTAmt / (Util.GetDecimal(objStock.InitialCount)), 4, MidpointRounding.AwayFromZero);
                objStock.CGSTPercent = Util.GetDecimal(dataItemDetails[i].CGSTPercent);
                objStock.CGSTAmtPerUnit = Math.Round(objLTDetail.CGSTAmt / (Util.GetDecimal(objStock.InitialCount)), 4, MidpointRounding.AwayFromZero);
                objStock.SGSTPercent = Util.GetDecimal(dataItemDetails[i].SGSTPercent);
                objStock.SGSTAmtPerUnit = Math.Round(objLTDetail.SGSTAmt / (Util.GetDecimal(objStock.InitialCount)), 4, MidpointRounding.AwayFromZero);
                objStock.SpecialDiscPer = Util.GetDecimal(dataItemDetails[i].SpecialDiscPer);
                objStock.SpecialDiscAmt = Util.GetDecimal(dataItemDetails[i].SpecialDiscAmt);
                objStock.ChalanNo = Util.GetString(dataItemDetails[i].ChalanNo);
                objStock.ChalanDate = Util.GetDateTime(dataItemDetails[i].ChalanDate);
                objStock.IsAsset = 1;
                objStock.PONumber = Util.GetString(dataInvoice[0].PONumber);
                objStock.InvoiceAmount = Util.GetDecimal(dataInvoice[0].NetAmount);
                string StockID = objStock.Insert().ToString();

                if (StockID == string.Empty)
                {
                    objTran.Rollback();
                    objTran.Dispose();
                    con.Close();
                    con.Dispose();
                    return "";
                }

                for (int j = 0; j < Util.GetInt(dataItemDetails[i].Quantity); j++)
                {


                    string str = "";
                    str += "INSERT INTO eq_asset_master(AssetName,AssetCode,AssetTypeID,";
                    str += "SerialNo,ModelNo,TagNo,SupplierID,SupplierTypeID,";
                    str += "PurchaseDate,InstallationDate,WarrantyFrom,WarrantyTo,";
                    str += "FreeServiceFrom,FreeServiceTo,AmcTypeID,Isactive,insertby)";
                    str += "VALUES ('" + Util.GetString(dataItemDetails[i].ItemName) + "','" + Util.GetString(dataItemDetails[i].ItemID) + "','0','" + Util.GetString(dataItemDetails[i].SerialNo) + "','" + Util.GetString(dataItemDetails[i].ModelNo) + "','" + Util.GetString(dataItemDetails[i].AssetTagNo) + "','" + Util.GetString(dataInvoice[0].VenLedgerNo) + "','0',";
                    str += "'" + Util.GetDateTime(dataItemDetails[i].AssetPurDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(dataItemDetails[i].InstDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(dataItemDetails[i].WarrantyFrom).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(dataItemDetails[i].WarrantyTo).ToString("yyyy-MM-dd") + "',";
                    str += "'" + Util.GetDateTime(dataItemDetails[i].ServiceFrom).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(dataItemDetails[i].ServiceTo).ToString("yyyy-MM-dd") + "','0',1,'" + Session["ID"].ToString() + "')";
                    MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, str);

                    int assetID = Util.GetInt(Util.GetString(MySqlHelper.ExecuteScalar(objTran, CommandType.Text, "Select MAX(AssetID) from eq_asset_master")));
                    AssetStock ast = new AssetStock(objTran);
                    ast.AssetID = assetID;
                    ast.AssetName = Util.GetString(dataItemDetails[i].ItemName);
                    ast.AMCStartDate = Util.GetDateTime("0001-01-01").ToString("yyyy-MM-dd");
                    ast.AMCEndDate = Util.GetDateTime("0001-01-01").ToString("yyyy-MM-dd");
                    ast.LeaseDate = Util.GetDateTime("0001-01-01").ToString("yyyy-MM-dd");
                    ast.DisposalDate = Util.GetDateTime("0001-01-01").ToString("yyyy-MM-dd");
                    ast.DepreciationLife = Util.GetDateTime("0001-01-01").ToString("yyyy-MM-dd");
                    ast.Batch_Serial_Con = "Yes"; //Yes OR No
                    ast.BatchNo = Util.GetString(dataItemDetails[i].BatchNumber);
                    ast.SerialNo = dataItemDetails[i].SerialNo;
                    ast.Quantity = Util.GetDecimal(1);
                    ast.Asset_Con = "Amount"; // Amount OR Free
                    ast.AssetValue = Util.GetDecimal(Amt.Split('#')[0].ToString());
                    ast.GRNNo = LedgerTnxNo;
                    ast.GRNDate = Util.GetDateTime(dataItemDetails[0].AssetPurDate).ToString("yyyy-MM-dd");
                    ast.InvoiceNo = dataItemDetails[i].InvoiceNo;
                    ast.InvoiceDate = Util.GetDateTime(dataItemDetails[i].InvoiceDate).ToString("yyyy-MM-dd");
                    ast.CreatedBy = HttpContext.Current.Session["ID"].ToString();
                    ast.DeptLedgerNo = HttpContext.Current.Session["DeptLedgerNo"].ToString();
                    ast.AssetPurchaseDate = Util.GetDateTime(dataItemDetails[0].AssetPurDate).ToString("yyyy-MM-dd");
                    ast.ModelNo = Util.GetString(dataItemDetails[i].ModelNo);
                    ast.AssetTagNo = Util.GetString(dataItemDetails[i].ModelNo);
                    ast.InstDate = Util.GetDateTime((dataItemDetails[i].InstDate).ToString("yyyy-MM-dd"));
                    ast.ServiceFrom = Util.GetDateTime((dataItemDetails[i].ServiceFrom).ToString("yyyy-MM-dd"));
                    ast.ServiceTo = Util.GetDateTime((dataItemDetails[i].ServiceTo).ToString("yyyy-MM-dd"));
                    ast.WarrantyNo = Util.GetString(dataItemDetails[i].WarrantyNo);
                    ast.WarrantyDate = Util.GetDateTime(dataItemDetails[i].WarrantyFrom).ToString("yyyy-MM-dd");
                    ast.GRNStockID = Util.GetInt(StockID);
                    ast.Insert();
                    // Asset End


                    MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, "UPDATE f_ledgertnxdetail SET StockID='" + StockID + "' WHERE ID=" + LdgTrnxDtlID + "");
                    MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, "UPDATE f_stock SET LedgerTnxNo ='" + LdgTrnxDtlID + "',BarcodeID='" + StockID + "' WHERE StockID=" + StockID + "");
                    string strPOUpdate = "";
                    decimal RecvQty = Util.GetDecimal(dataItemDetails[i].Quantity);
                    if (RecvQty > 0)
                    {
                        MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, "UPDATE f_purchaseorderdetails SET RecievedQty=RecievedQty+" + Util.GetDecimal(RecvQty) + "  WHERE PurchaseOrderDetailID='" + Util.GetString(dataItemDetails[i].PODID) + "' ");
                    }
                    strPOUpdate = "CALL PO_StoreRecieve('" + Util.GetString(dataInvoice[0].PONumber) + "'," + Util.GetString(dataItemDetails[i].PODID) + "," + Util.GetDecimal(RecvQty) + ",'" + LedgerTnxNo + "','" + LdgTrnxDtlID + "','" + StockID + "','" + Util.GetInt(Session["CentreID"].ToString()) + "','" + Util.GetString(HttpContext.Current.Session["HOSPID"].ToString()) + "','" + Util.GetString(dataItemDetails[i].ItemID) + "');";
                    MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, strPOUpdate);
                }
            }
            MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, "UPDATE f_ledgertransaction SET DiscountOnTotal=(SELECT SUM(DiscAmt)TDisc FROM f_ledgertnxdetail WHERE LedgerTransactionNo='" + LedgerTnxNo + "') WHERE LedgerTransactionNo='" + LedgerTnxNo + "'");
            decimal isPendigQty = Util.GetDecimal(MySqlHelper.ExecuteScalar(objTran, CommandType.Text, "SELECT SUM(pod.`ApprovedQty`-pod.`RecievedQty`) FROM f_purchaseorderdetails pod WHERE pod.`PurchaseOrderNo`='" + Util.GetString(dataInvoice[0].PONumber) + "'"));
            if (isPendigQty < 1)
            {
                MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, "UPDATE `f_purchaseorder` po SET po.`Status`='3' WHERE po.`PurchaseOrderNo`='" + Util.GetString(dataInvoice[0].PONumber) + "'");

            }
            objTran.Commit();
            objTran.Dispose();
            con.Close();
            con.Dispose();
            return LedgerTnxNo;
        }
        catch (Exception ex)
        {
            objTran.Rollback();
            objTran.Dispose();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
    }
    //

    [WebMethod]
    public string loadGroup()
    {
        string strQuery = "Select sc.Name as SubCategoryName,sc.SubCategoryID " +
               "from f_subcategorymaster sc inner join f_configrelation cf on " +
               "sc.CategoryID = cf.CategoryID inner join f_categorymaster cm on cm.CategoryID = cf.CategoryID " +
               "where cf.ConfigID=28  AND sc.Active=1 AND sc.IsAsset='1' order by sc.Name ";
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(strQuery));
    }
    [WebMethod]
    public string loadUnit()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("select UnitName from f_purchase_unit_master ORDER BY unitname"));
    }
    [WebMethod(EnableSession = true)]
    public string SaveAccessoriesMaster(string SubCategoryID, string Name, string Unit, string Code, string Remarks, string Savetype, string AccessoriesID, string IsActive)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var UserID = HttpContext.Current.Session["ID"].ToString();
            var IpAddress = HttpContext.Current.Request.UserHostAddress;
            var message = "";

            string str = "SELECT COUNT(*) FROM eq_accessories_master WHERE AccessoriesName = '" + Name + "' ";
            if (AccessoriesID != "")
                str += " and ID<>'" + AccessoriesID + "' ";

            var IsExist = Util.GetInt(StockReports.ExecuteScalar(str));
            if (IsExist > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Accessories Already Exists" });
            }

            if (Savetype == "Save")
            {
                string sqlCMD = "INSERT INTO eq_accessories_master (AccessoriesName,SubcategoryID,Unit,AccessoriesCode,Remarks,CreatedBy,IPAddress,IsActive) VALUES(@AccessoriesName,@SubcategoryID,@Unit,@AccessoriesCode,@Remarks,@CreatedBy,@IPAddress,@IsActive);";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    AccessoriesName = Name,
                    SubcategoryID = SubCategoryID,
                    Unit = Unit,
                    AccessoriesCode = Code,
                    Remarks = Remarks,
                    CreatedBy = UserID,
                    IPAddress = IpAddress,
                    IsActive = IsActive,
                });
                message = "Record Save Successfully";
            }
            else
            {
                string sqlCMD = "UPDATE eq_accessories_master SET AccessoriesName = @AccessoriesName,SubcategoryID = @SubcategoryID,Unit=@Unit,AccessoriesCode = @AccessoriesCode,Remarks = @Remarks,UpdatedBy = @UpdatedBy,UpdatedDateTime = Now(),IPAddress = @IPAddress,IsActive = @IsActive WHERE ID = @ID;";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    AccessoriesName = Name,
                    SubcategoryID = SubCategoryID,
                    Unit = Unit,
                    AccessoriesCode = Code,
                    Remarks = Remarks,
                    UpdatedBy = UserID,
                    IPAddress = IpAddress,
                    IsActive = IsActive,
                    ID = AccessoriesID,
                });
                message = "Record Updated Successfully";
            }
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public string bindAccessoriesMasterDetails(string groupid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT eacm.ID,AccessoriesName,SubcategoryID,AccessoriesCode,Remarks,IF(eacm.IsActive=1,'Yes','No')Active,IF(eacm.IsActive=1,'1','0')IsActive,eacm.Unit, ");
        sb.Append("CONCAT(CONCAT(em.Title,em.Name),' ',DATE_FORMAT(eacm.CreatedDateTime,'%d-%b-%Y'))CreatedBy , ");
        sb.Append("CONCAT(IFNULL((SELECT CONCAT(title,'',NAME) FROM employee_master WHERE EmployeeID=eacm.UpdatedBy),''),' ',IFNULL(DATE_FORMAT(eacm.UpdatedDateTime,'%d-%b-%Y'),''))LastUpdateBy ");
        sb.Append("FROM eq_accessories_master eacm ");
        sb.Append("INNER JOIN employee_master em ON em.EmployeeID= eacm.CreatedBy ");
        sb.Append("WHERE 1=1 ");
        if (groupid != "0")
            sb.Append(" and SubcategoryID = 0 ");
        sb.Append(" Order By AccessoriesName ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod]
    public string bindItemsinGRNwithSerial(string GRNNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT ast.ItemID,CONCAT(ast.ItemName,' (Serial No: ',ast.SerialNo,')')ItemName,ast.SerialNo,ast.StockID,ast.ID AssetID  ");
        sb.Append("from eq_asset_master ast ");
        sb.Append("WHERE ast.LedgerTransactionNO='" + GRNNo + "' ");
        sb.Append("GROUP BY ast.ItemID, ast.SerialNo ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString())); ;
    }
    [WebMethod]
    public string bindAccessoriesMaster()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT ID,AccessoriesName FROM eq_accessories_master WHERE IsActive=1"));
    }
    [WebMethod(EnableSession = true)]
    public string SaveAssetDocumentMaster(string DocumentName, string Description, string Savetype, string IsActive, string DocumentID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var UserID = HttpContext.Current.Session["ID"].ToString();
            var IpAddress = HttpContext.Current.Request.UserHostAddress;
            var message = "";

            string str = "SELECT COUNT(*) FROM eq_Asset_DocumentMaster WHERE DocumentName = '" + DocumentName + "' ";
            if (DocumentID != "")
                str += " and ID<>'" + DocumentID + "' ";

            var IsExist = Util.GetInt(StockReports.ExecuteScalar(str));
            if (IsExist > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Document Already Exists" });
            }

            if (Savetype == "Save")
            {
                string sqlCMD = "INSERT INTO eq_Asset_DocumentMaster (DocumentName,Description,CreatedBy,CreatedDateTime,IsActive) VALUES(@DocumentName,@Description,@CreatedBy,Now(),@IsActive);";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    DocumentName = DocumentName,
                    Description = Description,
                    CreatedBy = UserID,

                    IsActive = IsActive,
                });
                message = "Record Save Successfully";
            }
            else
            {
                string sqlCMD = "UPDATE eq_Asset_DocumentMaster SET DocumentName = @DocumentName,Description = @Description,UpdatedBy = @UpdatedBy,UpdatedDateTime = Now(),IsActive = @IsActive WHERE ID = @ID;";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    DocumentName = DocumentName,
                    Description = Description,
                    IsActive = IsActive,
                    UpdatedBy = UserID,


                    ID = DocumentID,
                });
                message = "Record Updated Successfully";
            }
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    
    [WebMethod]
    public string bindtaggesAccessories(string GRNNo, string ItemID,string AssetID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT CONCAT(im.TypeName,' (Serial No: ',st.SerialNo,')') ItemName,eat.SerialNo,ifnull(eat.ModelNo,'')ModelNo,eat.BatchNo,eat.Quantity ,eam.AccessoriesName,im.ItemID,eam.ID AccessoriesID,eat.StockID,eam.AccessoriesCode ,st.SerialNo ItemSerialNo,st.ID as AssetID,eat.ManufacturerID,eat.LicenceNo,eat.ID as TaggedID ");
        sb.Append("FROM eq_Item_Accessories_tagdetails eat ");
        sb.Append("INNER JOIN f_itemmaster im ON im.ItemID= eat.ItemID ");
        sb.Append("INNER JOIN eq_asset_master st ON st.ID=eat.AssetID  ");
        sb.Append("INNER JOIN eq_accessories_master eam ON eam.ID=eat.AccessoriesID WHERE eat.IsActive=1 ");
        if (AssetID == "0")
        {
            sb.Append(" AND eat.LedgerTransactionNo='" + GRNNo + "' ");
            if (ItemID != "0")
                sb.Append(" and eat.itemID='" + ItemID + "'");
        }
        else
        {
            sb.Append(" and eat.AssetID='" + AssetID + "'");
        }
        sb.Append(" order by im.TypeName");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));

    }
    [WebMethod(EnableSession = true)]
    public string SaveAccessoriesTagging(List<taggingaccessories> taggingAccessories, string GRNNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var message = "";
            DataTable dtExistId = StockReports.GetDataTable("Select * from eq_item_accessories_tagdetails where  LedgerTransactionNo ='" + GRNNo + "' and IsActive=1 ");
            if (dtExistId.Rows.Count > 0)
            {
                foreach (DataRow dr in dtExistId.Rows)
                {
                    string sqlCMD = "Update eq_item_accessories_tagdetails set IsActive=0 where ID =@ID";
                    excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                   {
                       ID = dr["ID"],
                   });
                }
            }
            taggingAccessories.ForEach(i =>
            {
                string sqlCMD = "INSERT INTO eq_item_accessories_tagdetails (LedgerTransactionNo,ItemID,StockID,AccessoriesID,CreatedBy,SerialNo,BatchNo,Quantity,ModelNo,AssetID,ManufacturerID,LicenceNo)VALUES(@LedgerTransactionNo, @ItemID, @StockID, @AccessoriesID, @CreatedBy,@SerialNo,@BatchNo,@Quantity,@ModelNo,@AssetID,@ManufacturerID,@LicenceNo);";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    LedgerTransactionNo = GRNNo,
                    ItemID = i.ItemID,
                    StockID = i.StockID,
                    AccessoriesID = i.AccessoriesID,
                    CreatedBy = HttpContext.Current.Session["ID"].ToString(),
                    SerialNo = i.SerialNo,
                    BatchNo = i.BatchNo,
                    Quantity = Util.GetDecimal(i.Quantity),
                    ModelNo = i.ModelNo,
                    AssetID = i.AssetID,
                    ManufacturerID = i.ManufacturerID,
                    LicenceNo = i.LicenceNo,
                });
            });
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Save Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public class taggingaccessories
    {
        public string ItemID { get; set; }
        public string StockID { get; set; }
        public string AccessoriesID { get; set; }
        public string BatchNo { get; set; }
        public string SerialNo { get; set; }
        public string Quantity { get; set; }
        public string ItemSerialNo { get; set; }
        public string ModelNo { get; set; }
        public string AssetID { get; set; }
        public string ManufacturerID { get; set; }
        public string LicenceNo { get; set; }
    }

    [WebMethod]
    public string loadItemswithDepriation(string GroupID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT sc.SubCategoryID,sc.Name AS SubCategoryName,im.ItemID,im.TypeName AS ItemName , ");
        sb.Append("IFNULL(edm.First_Per,'')First_Per,IFNULL(edm.Second_Per,'')Second_Per,IFNULL(edm.Third_Per,'')Third_Per, ");
        sb.Append("IFNULL(edm.Fourth_Per,'')Fourth_Per,IFNULL(edm.Fifth_Per,'')Fifth_Per,IFNULL(edm.Six_Per,'')Six_Per, ");
        sb.Append("IFNULL(edm.Seventh_Per,'')Seventh_Per,IFNULL(edm.Eigth_Per,'')Eigth_Per,IFNULL(edm.Nine_Per,'')Nine_Per, ");
        sb.Append("IFNULL(edm.Ten_Per,'')Ten_Per, ");
        sb.Append("CONCAT((SELECT CONCAT(title,NAME) FROM employee_master WHERE EmployeeID = edm.CreatedBy),DATE_FORMAT(edm.CreatedDateTime,'%d-%b-%Y'))CreateDetail, ");
        sb.Append("CONCAT((SELECT CONCAT(title,NAME) FROM employee_master WHERE EmployeeID = edm.UpdatedBy),DATE_FORMAT(edm.UpdatedDateTime,'%d-%b-%Y'))UpdateDetail ");
        sb.Append("FROM f_itemmaster im  ");
        sb.Append("INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID= im.SubCategoryID ");
        sb.Append("INNER JOIN f_configrelation cr ON cr.CategoryID= sc.CategoryID ");
        sb.Append("LEFT JOIN eq_depreciationmaster edm ON edm.ItemID= im.ItemID AND edm.IsActive=1 ");
        sb.Append("WHERE sc.Active=1 AND sc.IsAsset=1 AND im.IsActive=1 AND im.IsAsset=1 ");
        if (GroupID != "0")
            sb.Append(" and sc.SubCategoryID = '" + GroupID + "' ");
        sb.Append("ORDER BY im.TypeName ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));

    }
    [WebMethod(EnableSession = true)]
    public string SaveItemDepreciationDetail(List<Depreciation> depreciatian)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            depreciatian.ForEach(i =>
            {
                var IsExist = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(*) FROM eq_DepreciationMaster WHERE itemid =@itemid AND IsActive=1", CommandType.Text, new
                {
                    itemid = i.ItemID,
                }));

                if (IsExist > 0)
                {
                    string sql = "UPDATE eq_depreciationmaster SET Isactive=0 WHERE ItemID=@ItemID";
                    excuteCMD.DML(tnx, sql, CommandType.Text, new
                    {
                        ItemID = i.ItemID,
                    });
                }
                string sqlCMD = "INSERT INTO eq_depreciationmaster (SubCategoryID,ItemID,First_Per,Second_Per,Third_Per,Fourth_Per,Fifth_Per,Six_Per,Seventh_Per,Eigth_Per,Nine_Per,Ten_Per,CreatedBy,CentreID)";
                sqlCMD += "VALUES(@SubCategoryID, @ItemID, @First_Per, @Second_Per, @Third_Per, @Fourth_Per, @Fifth_Per, @Six_Per, @Seventh_Per, @Eigth_Per, @Nine_Per, @Ten_Per, @CreatedBy, @CentreID);";

                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    SubCategoryID = i.SubcategoryID,
                    ItemID = i.ItemID,
                    First_Per = i.First,
                    Second_Per = i.Second,
                    Third_Per = i.Third,
                    Fourth_Per = i.Four,
                    Fifth_Per = i.Five,
                    Six_Per = i.Six,
                    Seventh_Per = i.Seven,
                    Eigth_Per = i.Eigth,
                    Nine_Per = i.Nine,
                    Ten_Per = i.Ten,
                    CreatedBy = HttpContext.Current.Session["ID"].ToString(),
                    CentreID = Util.GetInt(Session["CentreID"]),
                });
            });
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Save Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public class Depreciation
    {
        public string SubcategoryID { get; set; }
        public string ItemID { get; set; }
        public decimal First { get; set; }
        public decimal Second { get; set; }
        public decimal Third { get; set; }
        public decimal Four { get; set; }
        public decimal Five { get; set; }
        public decimal Six { get; set; }
        public decimal Seven { get; set; }
        public decimal Eigth { get; set; }
        public decimal Nine { get; set; }
        public decimal Ten { get; set; }
    }

    [WebMethod]
    public string loadAllAssetItems(string GroupID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT im.ItemID,im.TypeName AS ItemName  ");
        sb.Append("FROM f_itemmaster im  ");
        sb.Append("INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID= im.SubCategoryID ");
        sb.Append("INNER JOIN f_configrelation cr ON cr.CategoryID= sc.CategoryID ");
        sb.Append("WHERE sc.Active=1 AND sc.IsAsset=1 AND im.IsActive=1 AND im.IsAsset=1 ");
        if (GroupID != "0")
        {
            sb.Append(" and sc.SubCategoryID='" + GroupID + "'");
        }
        sb.Append("ORDER BY im.TypeName ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod]
    public string LoadManufacturer()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("select NAME,ManufactureID from f_manufacture_master where IsActive = 1 AND IsAsset='1' order by Name"));
    }

    [WebMethod]
    public string loadAssetSerialModelDetail(string GRNNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT ast.ID AssetID,StockID,ast.ItemID,im.TypeName AS ItemName,ast.BatchNumber,IFNULL(ast.ModelNo,'')ModelNo,IFNULL(ast.SerialNo,'')SerialNo,IFNULL(ast.AssetNo,'')AssetNo,IFNULL(ast.LicenceNo,'')LicenceNo  ");
        sb.Append("FROM eq_asset_master ast  ");
        sb.Append("INNER JOIN f_itemmaster im ON ast.ItemID= im.ItemID ");
        sb.Append("WHERE ast.LedgerTransactionNo= '" + GRNNo + "' order by im.TypeName ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    public string bindItemsinGRN(string GRNNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT ast.ItemID,im.TypeName AS ItemName ");
        sb.Append("FROM eq_asset_master ast  ");
        sb.Append("INNER JOIN f_itemmaster im ON ast.ItemID= im.ItemID ");
        sb.Append("WHERE ast.LedgerTransactionNo= '"+GRNNo+"'  ");
        sb.Append("GROUP BY ast.ItemID order by im.TypeName ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod(EnableSession = true)]
    public string SaveAssetModelSerialNo(List<modelserial> modelSerial)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            modelSerial.ForEach(i =>
            {
                string sqmCMD = "UPDATE eq_asset_master set ModelNo = @ModelNo,SerialNo = @SerialNo,AssetNo = @AssetNo,LicenceNo=@LicenceNo WHERE ID = @ID;";
                excuteCMD.DML(tnx, sqmCMD, CommandType.Text, new
                {
                    ModelNo=i.ModelNo,
                    SerialNo=i.SerialNo,
                    AssetNo=i.AssetNo,
                    ID = i.AssetID,
                    LicenceNo = i.LicenceNo,
                    
                });
            });
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Save Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public class modelserial
    {
        public string ItemID { get; set; }
        public string StockID { get; set; }
        public string AssetID { get; set; }
        public string AssetNo { get; set; }
        public string SerialNo { get; set; }
        public string ModelNo { get; set; }
        public string LicenceNo { get; set; }
    }

    [WebMethod]
    public string ValidateDuplicateAssetNo(string AssetNo)
    {
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            string str = "SELECT ItemName,SerialNo,ModelNo,LedgerTransactionNo AS GRNNo FROM eq_asset_master WHERE AssetNo=@AssetNo";
            var IsExist = excuteCMD.GetDataTable(str, CommandType.Text, new
            {
                AssetNo = AssetNo,
            });
            if (IsExist == null || IsExist.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Asset No. is Exists...<br/>ItemName : " + IsExist.Rows[0]["ItemName"] + "<br/> Serial No. :  " + IsExist.Rows[0]["SerialNo"].ToString() + "<br/> Model No. : " + IsExist.Rows[0]["ModelNo"] + "<br/> GRN No. : " + IsExist.Rows[0]["GRNNo"].ToString() });
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true });
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
    }

    [WebMethod]
    public string loadSupplier()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT lm.LedgerNumber as ID,lm.LedgerName,vm.ContactPerson,CONCAT(vm.Address1,vm.City)Address,vm.Mobile FROM f_ledgermaster  lm  ");
        sb.Append(" INNER JOIN `f_vendormaster` vm ON lm.`LedgerUserID`=vm.`Vendor_ID` ");
        sb.Append(" WHERE groupID='VEN' AND IsCurrent=1 AND vm.IsAsset=1  ORDER BY LedgerName ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod]
    public string loadInsuranceSupplier()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT lm.LedgerNumber as ID,lm.LedgerName FROM f_ledgermaster  lm  ");
        sb.Append(" INNER JOIN `f_vendormaster` vm ON lm.`LedgerUserID`=vm.`Vendor_ID` ");
        sb.Append(" WHERE groupID='VEN' AND IsCurrent=1 AND vm.IsAsset=1 and vm.IsInsurance=1  ORDER BY LedgerName ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod]
    public string bindAssetDocumentMasterDetails()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT eadm.ID,eadm.DocumentName,eadm.Description,IF(eadm.IsActive=1,'Yes','No')Active,IF(eadm.IsActive=1,'1','0')IsActive,");
        sb.Append("CONCAT(CONCAT(em.Title,em.Name))CreatedBy , ");
        sb.Append("DATE_FORMAT(eadm.CreatedDateTime,'%d-%b-%Y')DateTime , ");
        sb.Append("CONCAT(IFNULL((SELECT CONCAT(title,'',NAME) FROM employee_master WHERE EmployeeID=eadm.UpdatedBy),''),' ',IFNULL(DATE_FORMAT(eadm.UpdatedDateTime,'%d-%b-%Y'),''))LastUpdateBy ");
        sb.Append("FROM eq_Asset_DocumentMaster eadm ");
        sb.Append("INNER JOIN employee_master em ON em.EmployeeID= eadm.CreatedBy ");
        sb.Append("WHERE 1=1 ");

        sb.Append(" Order By DocumentName ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    public string SearchItemstoBarcode(string fromdate, string todate, string supplierID, string manufacturerID, string searchnoID, string searchnoValue, string searchbyID, string searchbyValue)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT DATE_FORMAT(st.PurchaseDate,'%d-%b-%Y')PurchaseDate,st.LedgerTransactionNo AS GRNNo,st.InvoiceNo,lm.LedgerName AS SupplierName,st.ItemName, ");
        sb.Append("mm.Name AS ManufacturerName,st.BatchNumber,am.ModelNo,am.SerialNo,am.AssetNo, ");
        sb.Append("am.ID AS AssetID,st.ItemID,st.ID AS StockID ");
        sb.Append("FROM eq_Asset_stock st  ");
        sb.Append("INNER JOIN eq_asset_master am ON am.ID=st.AssetID ");
        sb.Append("INNER JOIN f_ledgermaster lm ON lm.LedgerNumber= st.VenLedgerNo AND lm.groupid='VEN' ");
        sb.Append("INNER JOIN f_itemmaster im ON im.itemID= st.ItemID ");
        sb.Append("INNER JOIN f_manufacture_master mm ON mm.ManufactureID= im.ManufactureID ");
        sb.Append("WHERE st.PurchaseDate>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + "' AND st.PurchaseDate<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + "' AND IFNULL(st.fromStockID,'')='' and st.IsPost=1 ");
        if (supplierID != "0")
            sb.Append("AND st.VenLedgerNo='" + supplierID + "' ");
        if(manufacturerID!="0")
            sb.Append("AND im.ManufactureID='" + manufacturerID + "' ");
        if (searchbyID == "1" && !string.IsNullOrEmpty(searchbyValue))
            sb.Append("AND st.ItemName like '" + searchbyValue + "%' ");
        if (searchbyID == "2" && !string.IsNullOrEmpty(searchbyValue))
            sb.Append("AND st.BatchNumber='" + searchbyValue + "' ");
        if (searchbyID == "3" && !string.IsNullOrEmpty(searchbyValue))
            sb.Append("AND am.ModelNo='" + searchbyValue + "' ");
        if (searchbyID == "4" && !string.IsNullOrEmpty(searchbyValue))
            sb.Append("AND am.SerialNo='" + searchbyValue + "' ");
        if (searchbyID == "5" && !string.IsNullOrEmpty(searchbyValue))
            sb.Append("AND am.AssetNo='" + searchbyValue + "' ");
        if (searchnoID == "1" && !string.IsNullOrEmpty(searchnoValue))
            sb.Append("AND st.LedgerTransactionNo='" + searchnoValue + "' ");
        if (searchnoID == "2" && !string.IsNullOrEmpty(searchnoValue))
            sb.Append("AND st.InvoiceNo='" + searchnoValue + "' ");
        sb.Append("ORDER BY st.LedgerTransactionNo,st.ItemName,am.AssetNo ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
}
