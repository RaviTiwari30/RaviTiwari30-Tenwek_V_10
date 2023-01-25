using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Web.Services;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using System.Linq;
using System.Web;

public partial class Design_Purchase_POByReOrder : System.Web.UI.Page
{
   
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            int CentreID = Util.GetInt(Session["CentreID"].ToString());

            if (All_LoadData.checkPageAuthorisation(Session["RoleID"].ToString(), Session["ID"].ToString(), HttpContext.Current.Request.Url.AbsolutePath.Remove(0, VirtualPathUtility.ToAbsolute("~/").Length - 1), CentreID) == 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.location ='../Common/UserAuthorization.aspx?msg=For This Page';", true);
                return;
            }
           
              
        }
    }
    [WebMethod(EnableSession = true)]
    public static string bindVendor(string StoreID)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            if (Resources.Resource.StoreWiseVendor == "1")
            {
                sb.Append(" SELECT lm.LedgerNumber ID,lm.LedgerName FROM f_ledgermaster  lm  ");
                sb.Append(" INNER JOIN `f_vendormaster` vm ON lm.`LedgerUserID`=vm.`Vendor_ID` ");
                sb.Append(" WHERE groupID='VEN' AND IsCurrent=1 AND vm.StoreID='" + StoreID + "' ORDER BY LedgerName ");
            }
            else
            {
                sb.Append(" SELECT lm.LedgerNumber ID,lm.LedgerName FROM f_ledgermaster  lm  ");
                sb.Append(" INNER JOIN `f_vendormaster` vm ON lm.`LedgerUserID`=vm.`Vendor_ID` ");
                sb.Append(" WHERE groupID='VEN' AND IsCurrent=1  ORDER BY LedgerName ");

            }
            DataTable dt = StockReports.GetDataTable(sb.ToString());           
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindItem(string StoreID)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            if (StoreID == "STO00001")      // Medical Store
            {
                sb.Append(" SELECT *,(IGSTPercent+CGSTPercent+SGSTPercent)GSTPer,(ReorderQty*NetAmt)TotalAmount  FROM (  ");
                sb.Append("     SELECT IFNULL(SUM(st.`InitialCount`-st.`ReleasedCount`),0)AvailStock ,im.ItemID,im.`TypeName` ItemName,im.`SubCategoryID`,im.`UnitType`,im.`MaxLevel`,im.`MinLevel`,  ");
                sb.Append("     im.`ReorderLevel`,im.`ReorderQty`,im.`MaxReorderQty`, im.`MinReorderQty`,im.`MinorUnit`,im.`MajorUnit`,im.`ConversionFactor`,im.ManufactureID,  ");
                sb.Append("     IFNULL(sir.`GrossAmt`,0)GrossAmt,IFNULL(sir.`NetAmt`,0)NetAmt,IFNULL(sir.`MRP`,0)MRP,IFNULL(ROUND((sir.DiscAmt*100)/sir.GrossAmt,4),0)DiscPer,IFNULL(sir.DiscAmt,0)DiscAmt,IFNULL(sir.TaxAmt,0)GSTAmt,IFNULL((SELECT LedgerNumber FROM f_ledgermaster WHERE LedgerNumber=sir.`Vendor_ID`),'')Vendor_ID,IFNULL(lm.ledgername,'') Vendor,IFNULL(sir.`IGSTPercent`,0)IGSTPercent,IFNULL(sir.`CGSTPercent`,0)CGSTPercent,IFNULL(sir.`SGSTPercent`,0)SGSTPercent,IFNULL(sir.`GSTType`,'')GSTType,IFNULL(sir.`HSNCode`,'')HSNCode,IFNULL(sir.TaxCalulatedOn,'')TaxCalulatedOn, ");
                sb.Append("     IFNULL(sirt.TaxID,'')TaxID,IF(sir.ID IS NULL,0,1)IsRateSet");
                sb.Append("     FROM f_itemmaster im   ");
                sb.Append("     INNER JOIN `f_subcategorymaster` sm ON  im.`SubCategoryID`= sm.`SubCategoryID`   ");
                sb.Append("     INNER JOIN `f_configrelation` cr ON cr.`CategoryID`= sm.`CategoryID`  ");
                sb.Append("     LEFT JOIN f_stock st ON st.ItemID=im.ItemID AND st.`IsPost`=1 AND (st.InitialCount-st.ReleasedCount)>0 AND st.MedExpiryDate>CURDATE()  ");
                sb.Append("     LEFT JOIN f_storeitem_rate sir ON im.ItemID=sir.ItemID AND sir.IsActive=1 ");
                sb.Append("     LEFT JOIN f_storeitem_tax sirt ON sir.ID=sirt.StoreRateID ");
                sb.Append("     LEFT JOIN f_ledgermaster lm ON sir.`Vendor_ID`=lm.`LedgerNumber` AND lm.`GroupID`='VEN' ");
                sb.Append("     WHERE cr.`ConfigID`= 11 ");
                sb.Append("     GROUP BY im.ItemID  ");
                sb.Append(" )t WHERE AvailStock<t.ReorderLevel ORDER BY ItemName,Vendor_ID ");

            }
            else if (StoreID == "STO00002") // General Store
            {
                sb.Append(" SELECT *,(IGSTPercent+CGSTPercent+SGSTPercent)GSTPer,(ReorderQty*NetAmt)TotalAmount FROM (  ");
                sb.Append("     SELECT IFNULL(SUM(st.`InitialCount`-st.`ReleasedCount`),0)AvailStock ,im.ItemID,im.`TypeName` ItemName,im.`SubCategoryID`,im.`UnitType`,im.`MaxLevel`,im.`MinLevel`,  ");
                sb.Append("     im.`ReorderLevel`,im.`ReorderQty`,im.`MaxReorderQty`, im.`MinReorderQty`,im.`MinorUnit`,im.`MajorUnit`,im.`ConversionFactor`,im.ManufactureID,  ");
                sb.Append("     IFNULL(sir.`GrossAmt`,0)GrossAmt,IFNULL(sir.`NetAmt`,0)NetAmt,IFNULL(sir.`MRP`,0)MRP,IFNULL(ROUND((sir.DiscAmt*100)/sir.GrossAmt,4),0)DiscPer,IFNULL(sir.DiscAmt,0)DiscAmt,IFNULL(sir.TaxAmt,0)GSTAmt,IFNULL((SELECT LedgerNumber FROM f_ledgermaster WHERE LedgerNumber=sir.`Vendor_ID`),'')Vendor_ID,IFNULL(lm.ledgername,'') Vendor,IFNULL(sir.`IGSTPercent`,0)IGSTPercent,IFNULL(sir.`CGSTPercent`,0)CGSTPercent,IFNULL(sir.`SGSTPercent`,0)SGSTPercent,IFNULL(sir.`GSTType`,'')GSTType,IFNULL(sir.`HSNCode`,'')HSNCode,IFNULL(sir.TaxCalulatedOn,'')TaxCalulatedOn, ");
                sb.Append("     IFNULL(sirt.TaxID,'')TaxID,IF(sir.ID IS NULL,0,1)IsRateSet");
                sb.Append("     FROM f_itemmaster im   ");
                sb.Append("     INNER JOIN `f_subcategorymaster` sm ON  im.`SubCategoryID`= sm.`SubCategoryID`   ");
                sb.Append("     INNER JOIN `f_configrelation` cr ON cr.`CategoryID`= sm.`CategoryID`  ");
                sb.Append("     LEFT JOIN f_stock st ON st.ItemID=im.ItemID AND st.`IsPost`=1 AND (st.InitialCount-st.ReleasedCount)>0 ");
                sb.Append("     LEFT JOIN f_storeitem_rate sir ON im.ItemID=sir.ItemID AND sir.IsActive=1 ");
                sb.Append("     LEFT JOIN f_storeitem_tax sirt ON sir.ID=sirt.StoreRateID ");
                sb.Append("     LEFT JOIN f_ledgermaster lm ON sir.`Vendor_ID`=lm.`LedgerNumber` AND lm.`GroupID`='VEN' ");
                sb.Append("     WHERE cr.`ConfigID`= 12 ");
                sb.Append("     GROUP BY im.ItemID  ");
                sb.Append(" )t WHERE AvailStock<t.ReorderLevel  ORDER BY ItemName,Vendor_ID ");
            }
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            dt.Columns.Add("RowColour");
            dt.Columns.Add("disabled");
            if (dt.Rows.Count > 0)
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    if (Util.GetString(dt.Rows[i]["Vendor"]) == Util.GetString(""))
                    {
                        dt.Rows[i]["RowColour"] = "LightBlue";
                        dt.Rows[i]["disabled"] = "true";
                    }
                    else
                    {
                        dt.Rows[i]["RowColour"] = "AntiqueWhite";
                        dt.Rows[i]["disabled"] = "false";
                    }
                }
            }


            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindStock(string ItemID,string StoreID)
    {
        try
        {
            StringBuilder sb = new StringBuilder();           
            sb.Append("  SELECT st.ItemName,st.StockID,DATE_FORMAT(st.StockDate,'%d-%b-%Y')StockDate,(st.InitialCount-st.ReleasedCount)AvailQty,st.DeptLedgerNo, ");
            sb.Append("  IFNULL((SELECT LedgerName FROM f_ledgermaster WHERE LedgerNumber=st.DeptLedgerNo),'')DeptName,  ");
            sb.Append("  IFNULL((SELECT LedgerName FROM f_ledgermaster WHERE LedgerNumber=st.FromDept),'---')FromDept  FROM f_stock st    ");
            sb.Append("  WHERE (st.InitialCount-st.ReleasedCount)>0 AND st.IsPost=1 AND st.`StoreLedgerNo`='" + StoreID + "' AND st.ItemID='" + ItemID + "' ");
            if (StoreID == "STO00001") // Medical Store
                sb.Append("  AND st.MedExpiryDate>CURDATE() ");

            DataTable dt = StockReports.GetDataTable(sb.ToString());
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindGSTType()
    {
            DataTable dt = StockReports.GetDataTable("SELECT TaxID,TaxName FROM f_taxmaster WHERE TaxID IN ('T4','T6','T7')");
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);        
    }

    [WebMethod(EnableSession = true)]
    public static string savePOByROL(object itemDetail)
    {
        List<PurchaseOrder> dataPO = new JavaScriptSerializer().ConvertToType<List<PurchaseOrder>>(itemDetail);
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.ReadCommitted);
        try
        {      
            StringBuilder sb = new StringBuilder();
            var groupedVendor_ID = dataPO.GroupBy(u => u.Vendor_ID)
                                    .Select(grp => new { Vendor_ID = grp.Key, dataPO = grp.ToList() })
                                    .ToList();

            foreach (var item in groupedVendor_ID)
            {
                 

                var A = item.dataPO;
                
                //------------------ Start PO --------------------------
                    string type_id = "HS"; decimal NetAmount = 0;  
                    foreach (var P in A)
                    {                                  
                        NetAmount = NetAmount + Util.GetDecimal(P.TotalAmount);
                    }

                    string  HSPoNumber =  Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text,"Select get_po_number('" + type_id + "','" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "','" + HttpContext.Current.Session["CentreID"].ToString() + "')"));
                    DateTime ByDate = Util.GetDateTime("01-Jan-0001");

                    PurchaseOrderMaster iMst = new PurchaseOrderMaster(tnx);
                    iMst.Subject = "";
                    iMst.Remarks = "";
                    iMst.VendorID = A[0].Vendor_ID;
                    iMst.VendorName = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT LedgerName FROM f_ledgermaster WHERE LedgerNumber='" + A[0].Vendor_ID + "' AND GroupID='VEN'"));
                    iMst.RaisedDate = DateTime.Now;
                    iMst.RaisedUserID = Util.GetString(HttpContext.Current.Session["ID"].ToString());
                    iMst.RaisedUserName = Util.GetString(HttpContext.Current.Session["UserName"].ToString());
                    iMst.ValidDate = Util.GetDateTime(DateTime.Now.Date.AddMonths(3).ToString("yyyy-MM-dd"));
                    iMst.DeliveryDate = Util.GetDateTime(DateTime.Now.Date.AddMonths(3).ToString("yyyy-MM-dd"));
                    iMst.NetTotal = Util.GetDecimal(NetAmount);
                    iMst.GrossTotal = Util.GetDecimal(NetAmount);
                    iMst.Freight = 0;
                    iMst.RoundOff = 0;
                    iMst.Scheme = 0;
                    iMst.Type = "Normal";
                    iMst.ByDate = ByDate;
                    iMst.ExciseOnBill = 0;
                    iMst.S_Amount = Util.GetDecimal(iMst.NetTotal);
                    iMst.StoreLedgerNo = A[0].StoreType;
                    iMst.DeptLedgerNo = Util.GetString(HttpContext.Current.Session["DeptLedgerNo"].ToString());            
                    iMst.S_CountryID = Util.GetInt(Resources.Resource.BaseCurrencyID);
                    iMst.S_Currency = Util.GetString(Resources.Resource.BaseCurrencyNotation);
                    AllSelectQuery ASQ = new AllSelectQuery();
                    iMst.C_Factor = ASQ.GetConversionFactor(Util.GetInt(Resources.Resource.BaseCurrencyID));
                    iMst.PoNumber = HSPoNumber;
                    iMst.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    iMst.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                    HSPoNumber = iMst.Insert();
                    if (HSPoNumber == string.Empty)
                    {
                        tnx.Rollback();
                        con.Close();
                        con.Dispose();
                        return string.Empty;
                    }

                        
                    //------------------ End PO ----------------------------

                   foreach (var P in A)
                   {

                       //---------- Start POD ------------------

                       string Amt = "";

                       List<TaxCalculation_DirectGRN> taxCalculate = new List<TaxCalculation_DirectGRN>()
                         {
                           new TaxCalculation_DirectGRN {DiscAmt=0, DiscPer= P.DiscPer, MRP=P.MRP,Quantity = P.Quantity,Rate=P.Rate,TaxPer =P.GSTPer,Type =P.TaxCalOn,IGSTPrecent=P.IGSTPercent,CGSTPercent=P.CGSTPercent,SGSTPercent=P.SGSTPercent}
                         };

                       Amt = AllLoadData_Store.taxCalulation(taxCalculate);

                       int PODDetail = 0;
                       PurchaseOrderDetail POD = new PurchaseOrderDetail(tnx);
                       POD.ItemID = P.ItemID;
                       POD.ItemName = "";
                       POD.PurchaseOrderNo = HSPoNumber;
                       POD.OrderedQty = P.Quantity;
                       POD.Rate = P.Rate;
                       POD.MRP = P.MRP;
                       POD.QoutationNo = string.Empty;
                       POD.SubCategoryID = P.SubCategoryID;
                       POD.Status = 0;
                       POD.ApprovedQty = P.Quantity;
                       POD.BuyPrice = P.UnitPrice;
                       POD.Amount = POD.ApprovedQty * P.UnitPrice;
                       POD.Discount_p = P.DiscPer;
                       POD.RecievedQty = 0;
                       POD.Status = 0;
                       POD.Specification = "";
                       POD.Unit = P.PurchaseUnit;
                       POD.IsFree = 0;
                       POD.DeptLedgerNo = Util.GetString(HttpContext.Current.Session["DeptLedgerNo"].ToString());
                       POD.ExcisePercent = Util.GetDecimal(0);
                       POD.ExciseAmt = Util.GetDecimal(0);
                       POD.VATPercent = P.GSTPer;
                       POD.VATAmt = Util.GetDecimal(Amt.Split('#')[1].ToString());
                       POD.StoreLedgerNo = P.StoreType;
                       POD.TaxCalulatedOn = P.TaxCalOn;
                       POD.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                       POD.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                       POD.GSTType = P.GSTType;
                       POD.HSNCode = P.HSNCode;


                       POD.IGSTPercent = P.IGSTPercent;
                       POD.IGSTAmt = Util.GetDecimal(Amt.Split('#')[8].ToString());
                       POD.CGSTPercent = P.CGSTPercent;
                       POD.CGSTAmt = Util.GetDecimal(Amt.Split('#')[9].ToString());
                       POD.SGSTPercent = P.SGSTPercent;
                       POD.SGSTAmt = Util.GetDecimal(Amt.Split('#')[10].ToString());

                       PODDetail = POD.Insert();
                       int roleID = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT ID FROM f_rolemaster WHERE DeptLedgerNo='" + Util.GetString(HttpContext.Current.Session["DeptLedgerNo"].ToString()) + "'"));
                       string notification = Notification_Insert.notificationInsert(31, PODDetail.ToString(), tnx, "", "", roleID);
                       if (PODDetail == 0)
                       {
                           tnx.Rollback();
                           con.Close();
                           con.Dispose();
                           return string.Empty;
                       }

                       //-------- End POD -----------------------------------

                      if (P.IsRateSet == 0)
                      {
                        // -----------------Start Set Quotation Rate-----------------
                      
                        string strquery = " INSERT INTO `f_storeitem_rate`(ItemID,Vendor_ID,GrossAmt,DiscAmt,TaxAmt,NetAmt,`FromDate`,`ToDate`,`Remarks`,`EntryDate`,`UserID`,`UserName`,IsActive,StoreType,TaxCalulatedOn,DeptLedgerNo," +
                            "CentreID,Hospital_ID,Manufacturer_ID,MRP,GSTType,HSNCode,IGSTPercent,CGSTPercent,SGSTPercent)" +
                           " VALUES('" + P.ItemID + "','" + P.Vendor_ID + "','" + P.Rate + "','" + P.DiscAmt + "','" + P.GSTAmt + "','" + P.UnitPrice + "','" + DateTime.Now.ToString("yyyy-MM-dd") + "'," +
                           "'" + DateTime.Now.Date.AddMonths(3).ToString("yyyy-MM-dd") + "','Auto PO',Now(),'" + HttpContext.Current.Session["ID"].ToString() + "','',1,'" + P.StoreType + "','" + P.TaxCalOn + "','" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "'," +
                           "'" + HttpContext.Current.Session["CentreID"].ToString() + "','" + HttpContext.Current.Session["HOSPID"].ToString() + "','" + P.ManufactureID + "','" + P.MRP + "','" + P.GSTType + "','" + P.HSNCode + "'," +
                           "'" + P.IGSTPercent + "','" + P.CGSTPercent + "','" + P.SGSTPercent + "')";
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strquery);

                        string query = " SELECT MAX(id) FROM f_storeitem_rate ";
                        string StoreId = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, query).ToString();

                        strquery = " INSERT INTO f_storeitem_Tax(`StoreRateID`,`ITemID`,`TaxID`,`TaxPer`,`TaxAmt`,DeptLedgerNo,CentreID,Hospital_ID,GSTType,IGSTPercent,CGSTPercent,SGSTPercent)" +
                               " VALUES('" + StoreId + "','" + P.ItemID + "','" + P.TaxID + "','" + P.GSTPer + "','" + P.GSTAmt + "','" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "'," +
                            "'" + HttpContext.Current.Session["CentreID"].ToString() + "','" + HttpContext.Current.Session["HOSPID"].ToString() + "'," +
                            "'" + P.GSTType + "','" + P.IGSTPercent + "','" + P.CGSTPercent + "','" + P.SGSTPercent + "')";
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strquery);

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " UPDATE  f_storeitem_rate SET IsActive=0 WHERE ItemID='" + P.ItemID + "' AND isActive =1 and ID<>'" + StoreId + "' " +
                                "AND DeptLedgerNo ='" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "' ");
                        // ------------------End Set Quotation Rate------------------


                      
                      }
                }
            }      
            tnx.Commit();
            return "1";
        }
        catch (Exception es)
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

}