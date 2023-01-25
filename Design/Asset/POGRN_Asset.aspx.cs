using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Web;
using System.Web.UI.HtmlControls;
using System.Web.Services;

public partial class Design_Asset_POGRN_Asset : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //if (All_LoadData.checkPageAuthorisation(Session["RoleID"].ToString(), Session["ID"].ToString(), HttpContext.Current.Request.Url.AbsolutePath.Remove(0, VirtualPathUtility.ToAbsolute("~/").Length - 1)) == 0)
            //{
            //    ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.location ='../Common/UserAuthorization.aspx?msg=For This Page';", true);
            //    return;
            //}
            //else
            //{
                ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();              
                Session.Remove("dtItems");
            //}
        }
       
    }

    
  
    [WebMethod(EnableSession = true)]
    public static string BindVendor(string StoreType, string DeptLedgerNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CONCAT(LedgerNumber,'#',LedgerUserID)ID,LedgerName FROM f_ledgermaster lm  ");
        sb.Append(" INNER JOIN f_vendormaster vm ON vm.Vendor_ID=lm.LedgerUserID  ");
        sb.Append(" WHERE groupID='VEN' AND IsCurrent=1 AND IsAsset=1  ");
        if (StoreType == "STO00001")
            sb.Append(" AND vm.VendorCategory='MEDICAL ITEMS' ");
        else if (StoreType == "STO00002")
            sb.Append(" AND vm.VendorCategory='GENERAL ITEMS' ");

        sb.Append(" AND FIND_IN_SET('" + DeptLedgerNo + "',DeptLedgerNo) ");


        sb.Append(" ORDER BY LedgerName ");
        DataTable dtVendor = StockReports.GetDataTable(sb.ToString());

        if (dtVendor.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtVendor);
        }
        else
            return "";

    }
    [WebMethod(EnableSession = true)]
    public static string BindPO(string VendorID, string StoreType)
    {
        StringBuilder sb=new StringBuilder();
        sb.Append(" SELECT DISTINCT po.PurchaseOrderNo,CONCAT(po.VendorName,' (',po.PurchaseOrderNo,')')PO,pod.StoreLedgerNo FROM f_purchaseorder po  ");
        sb.Append("  INNER JOIN f_purchaseorderdetails pod ON po.PurchaseOrderNo=pod.PurchaseOrderNo   INNER JOIN f_subcategorymaster sb ON sb.SubCategoryID=pod.SubCategoryID "); 
        sb.Append("  INNER JOIN f_categorymaster cm ON cm.categoryID=sb.CategoryID INNER JOIN f_configrelation cf ON cf.categoryID=  cm.categoryID  ");
        sb.Append("  INNER JOIN f_ledgermaster lm ON lm.ledgernumber = po.VendorID AND lm.GroupID='VEN' ");
        sb.Append("  WHERE po.IsAsset=1 AND po.StoreLedgerNo='" + StoreType + "' AND po.status = 2 AND po.Approved = 2 AND cf.ConfigID IN ('28') ");
        if (VendorID != "0")
            sb.Append(" AND LedgerUserID='" + VendorID + "'  ");
        sb.Append("  ORDER BY VendorName ");
        DataTable dtPO = StockReports.GetDataTable(sb.ToString());
        if (dtPO.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtPO);
        }
        else
            return "";

    }

    [WebMethod(EnableSession = true)]
    public static string SearchPO(string PurchaseOrderNo, string DeptLedgerNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT '' Octori,'' GatePassIn,'true' IsOrginal,im.IsExpirable,im.Type_ID,im.SaleTaxPer,IF(im.IsUsable='R',1,0)IsUsable, po.PurchaseOrderNo,  ");
        sb.Append("  ROUND(po.Freight,2)Freight,po.VendorName,po.ApprovedDate,po.VendorID,po.Subject,CONCAT(em.Title,' ',em.Name) RaisedUserName,pd.PurchaseOrderDetailID,   ");
        sb.Append("  pd.ItemID,pd.ItemName,pd.SubCategoryID,SUM(pd.ApprovedQty) OrderedQty,ROUND(po.ExciseOnBill,2)ExciseOnBill, ");
        sb.Append("  IF(IFNULL(fid.MajorUnit,'')='',IFNULL(im.MajorUnit,''),fid.MajorUnit)MajorUnit,  IF(IFNULL(fid.MinorUnit,'')='',IFNULL(im.MinorUnit,''),fid.MinorUnit)MinorUnit, ");
        sb.Append("  IF(IFNULL(fid.ConversionFactor,'')='',IFNULL(im.ConversionFactor,'1'),fid.ConversionFactor)ConversionFactor, ROUND(SUM(pd.ApprovedQty-pd.RecievedQty),2)RemainQty, ");
        sb.Append("  ROUND((pd.Rate/IF(IFNULL(fid.ConversionFactor,'')='',IFNULL(im.ConversionFactor,'1'),fid.ConversionFactor)),4)Rate,(pd.Rate)RateDisplay,pd.Unit,'false' Save,'' BatchNo, ");
        sb.Append("  ''SaleTax,'' RecvQty,MRP,'' ExpiryDate,'' NewQty,'' NewUnit,ROUND(pd.Discount_p,2)Discount_p,pd.BuyPrice,pd.isfree,IF(pd.isfree = 1,'Yes','No')FreeStatus, ROUND(po.Roundoff,2)RoundOff, ");
        sb.Append("  ROUND(po.Scheme,2)Scheme,pd.VATPer,pd.VATAmt,pd.ExcisePer,pd.ExciseAmt,po.StoreLedgerNo,pd.TaxCalulatedOn,pd.`BuyPrice` ActualRate,pd.`Amount` ActualAmount, ");
        sb.Append("  IFNULL(pd.GSTType,'')GSTType,IFNULL(pd.HSNCode,'')HSNCode,pd.IGSTPercent,pd.IGSTAmt,pd.CGSTPercent,pd.CGSTAmt,pd.SGSTPercent,pd.SGSTAmt  ");
        sb.Append("  ,IFNULL(pd.IsDeal,'')IsDeal ");
        sb.Append("  FROM f_purchaseorder po  ");
        sb.Append("  INNER JOIN f_purchaseorderdetails pd ON po.PurchaseOrderNo = pd.PurchaseOrderNo INNER JOIN employee_master em ON em.Employee_ID = po.RaisedUserID   ");
        sb.Append("  INNER JOIN f_itemmaster im ON pd.ItemID=im.ItemID  LEFT JOIN f_itemmaster_deptWise fid ON fid.itemID=im.itemID AND fid.DeptLedgerNo='" + DeptLedgerNo + "'  ");
        sb.Append("  WHERE pd.Status = 0 AND pd.Approved = 1 AND po.PurchaseOrderNo = '" + PurchaseOrderNo + "' ");
        sb.Append("  GROUP BY pd.ItemID,IsFree ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt != null && dt.Rows.Count > 0)
        {          
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
            return "";
    }
}