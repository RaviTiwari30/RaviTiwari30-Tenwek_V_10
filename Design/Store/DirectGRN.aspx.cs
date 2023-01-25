using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using MySql.Data.MySqlClient;
using System.Web.Services;
using System.IO;
using System.Web;
using System.Globalization;
using System.Collections.Generic;



public partial class Design_Store_DirectGRN : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();

            int CentreID = Util.GetInt(Session["CentreID"].ToString()); if (All_LoadData.checkPageAuthorisation(Session["RoleID"].ToString(), Session["ID"].ToString(), HttpContext.Current.Request.Url.AbsolutePath.Remove(0, VirtualPathUtility.ToAbsolute("~/").Length - 1), CentreID) == 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.location ='../Common/UserAuthorization.aspx?msg=For This Page';", true);
                return;
            }
            else
            {
                if (ChkRights())
                {
                    string Msg = "You do not have rights to generate GRN ";
                    Response.Redirect("MsgPage.aspx?msg=" + Msg);
                }
                ViewState["ID"] = Session["ID"].ToString();
                ViewState["HOSPID"] = Session["HOSPID"].ToString();

                rblStoreType_SelectedIndexChanged(this, new EventArgs());
                calBillDate.EndDate = DateTime.Now;
                CalchallanDate.EndDate = DateTime.Now;
                calWayBillDate.EndDate = DateTime.Now;
                calExdTxtSearchModelFromDate.EndDate = DateTime.Now;
                calExdTxtSearchModelToDate.EndDate = DateTime.Now;
                BindVendor();
                //txtBillNo.Text = "03-Dec-2018";
                //txtBillDate.Text = "03-Dec-2018";
                txtPurchaseOrderFromDate.Text = txtPurchaseOrderToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                if (ViewState["DeptLedgerNo"].ToString() == "LSHHI18")
                {
                    rblStoreType.Items.FindByValue("STO00002").Selected = true;
                }
                else { rblStoreType.Items.FindByValue("STO00001").Selected = true; }
            }

        }
        txtBillDate.Attributes.Add("readOnly", "true");
        txtChallanDate.Attributes.Add("readOnly", "true");
        txtWayBillDate.Attributes.Add("readonly", "true");
        txtPurchaseOrderFromDate.Attributes.Add("readonly", "true");
        txtPurchaseOrderToDate.Attributes.Add("readonly", "true");

    }


    protected bool ChkRights()
    {
        string RoleId = Session["RoleID"].ToString();
        string EmpId = Session["ID"].ToString();
        rblStoreType.Items[0].Enabled = false;
        rblStoreType.Items[1].Enabled = false;
        DataTable dt = StockReports.GetRights(RoleId);
        if (dt != null && dt.Rows.Count > 0)
        {
            if (dt.Rows[0]["IsMedical"].ToString() == "false" && dt.Rows[0]["IsGeneral"].ToString() == "false")
            {
                string Msg = "You do not have rights to generate GRN ";
                Response.Redirect("MsgPage.aspx?msg=" + Msg, false);
                Context.ApplicationInstance.CompleteRequest();
            }
            else
            {
                rblStoreType.Items[0].Enabled = Util.GetBoolean(dt.Rows[0]["IsMedical"]);
                rblStoreType.Items[1].Enabled = Util.GetBoolean(dt.Rows[0]["IsGeneral"]);
                if ((dt.Rows[0]["IsMedical"].ToString() == "true" && dt.Rows[0]["IsGeneral"].ToString() == "true") || (dt.Rows[0]["IsMedical"].ToString() == "true" && dt.Rows[0]["IsGeneral"].ToString() == "false"))
                {
                    rblStoreType.Items[0].Selected = true;
                    rblStoreType.Items[1].Selected = false;
                }
                else if (dt.Rows[0]["IsMedical"].ToString() == "false" && dt.Rows[0]["IsGeneral"].ToString() == "true")
                {
                    rblStoreType.Items[1].Selected = true;
                    rblStoreType.Items[0].Selected = false;
                }

            }
            return false;
        }
        else { return true; }
    }
    protected void rblStoreType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rblStoreType.SelectedIndex < 0)
        {
            lblMsg.Text = "Please select Store Type";
            ddlVendor.SelectedIndex = 0;
            return;
        }
        else
        {
            lblMsg.Text = string.Empty;
            BindVendor();

        }
    }
    public void BindVendor()
    {
        StringBuilder sb = new StringBuilder();
        if (Resources.Resource.StoreWiseVendor == "1")
        {
            sb.Append(" SELECT CONCAT(lm.LedgerNumber,'#',lm.LedgerUserID,'#',vm.StateID,'#',vm.VATType)ID,lm.LedgerName FROM f_ledgermaster  lm  ");
            sb.Append(" INNER JOIN `f_vendormaster` vm ON lm.`LedgerUserID`=vm.`Vendor_ID` ");
            if (Util.GetInt(Session["RoleID"]) == 13 || Util.GetInt(Session["RoleID"]) == 14)
            {
              //  sb.Append("and VendorCategory='GENERAL ITEMS'");
            }
            else if (Util.GetInt(Session["RoleID"]) == 16)
            {
               // sb.Append("and VendorCategory<>'GENERAL ITEMS'");
            }
            sb.Append(" WHERE groupID='VEN' AND IsCurrent=1 AND vm.DepTLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' ORDER BY LedgerName ");
        }
        else
        {
            // sb.Append(" select concat(LedgerNumber,'#',LedgerUserID)ID,LedgerName from f_ledgermaster where groupID='VEN' and IsCurrent=1 order by LedgerName ");
            sb.Append(" SELECT CONCAT(lm.LedgerNumber,'#',lm.LedgerUserID,'#',vm.StateID,'#',vm.VATType)ID,lm.LedgerName FROM f_ledgermaster  lm  ");
            sb.Append(" INNER JOIN `f_vendormaster` vm ON lm.`LedgerUserID`=vm.`Vendor_ID` ");
            if (Util.GetInt( Session["RoleID"])==13 || Util.GetInt( Session["RoleID"])==14)
            {
                //sb.Append("and VendorCategory='GENERAL ITEMS'");  
            }
            else if (Util.GetInt( Session["RoleID"])==16)
            {
               // sb.Append("and VendorCategory<>'GENERAL ITEMS'");  
            }
            sb.Append(" WHERE groupID='VEN' AND IsCurrent=1  ORDER BY LedgerName ");

        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            ddlVendor.DataSource = dt;
            ddlVendor.DataTextField = "LedgerName";
            ddlVendor.DataValueField = "ID";
            ddlVendor.DataBind();

            ddlVendor.Items.Insert(0, new ListItem("Select", "0"));



            ddlVendorSearch.DataSource = dt;
            ddlVendorSearch.DataTextField = "LedgerName";
            ddlVendorSearch.DataValueField = "ID";
            ddlVendorSearch.DataBind();
            ddlVendorSearch.Items.Insert(0, new ListItem("All", "0"));

        }
        else
        {
            ddlVendor.Items.Clear();
            ddlVendor.DataSource = null;
            ddlVendor.DataBind();
            ddlVendorSearch.Items.Clear();
            ddlVendorSearch.DataSource = null;
            ddlVendorSearch.DataBind();
        }

    }


    [WebMethod(EnableSession = true)]
    public static string GetPurchaseOrderItems(string purchaseOrderNumber)
    {

        string departmentLedgerNumber = HttpContext.Current.Session["DeptLedgerNo"].ToString();

        StringBuilder sqlCMD = new StringBuilder();

        //sqlCMD.Append("  SELECT  '' Octori,'' GatePassIn,'true' IsOrginal,if(im.IsExpirable='NO',0,1)IsExpirable,im.Type_ID,im.SaleTaxPer,IF(im.IsUsable='R',1,0)IsUsable, po.PurchaseOrderNo,  ");
        //sqlCMD.Append("  ROUND(po.Freight,2)Freight,po.VendorName,po.ApprovedDate,po.VendorID,po.Subject,CONCAT(em.Title,' ',em.Name) RaisedUserName,pd.PurchaseOrderDetailID,   ");
        //sqlCMD.Append("  pd.ItemID,pd.ItemName,pd.SubCategoryID,SUM(pd.ApprovedQty) OrderedQty,ROUND(po.ExciseOnBill,2)ExciseOnBill, ");
        //sqlCMD.Append("  IF(IFNULL(fid.MajorUnit,'')='',IFNULL(im.MajorUnit,''),fid.MajorUnit)MajorUnit,  IF(IFNULL(fid.MinorUnit,'')='',IFNULL(im.MinorUnit,''),fid.MinorUnit)MinorUnit, ");
        //sqlCMD.Append("  IF(IFNULL(fid.ConversionFactor,'')='',IFNULL(im.ConversionFactor,'1'),fid.ConversionFactor)ConversionFactor, ROUND(SUM(pd.ApprovedQty-pd.RecievedQty),2)RemainQty, ");
        //sqlCMD.Append("  ROUND((pd.Rate/IF(IFNULL(fid.ConversionFactor,'')='',IFNULL(im.ConversionFactor,'1'),fid.ConversionFactor)),4)Rate,(pd.Rate)RateDisplay,pd.Unit,'false' Save,'' BatchNo, ");
        //sqlCMD.Append("  ''SaleTax,'' RecvQty,MRP,'' ExpiryDate,'' NewQty,'' NewUnit,ROUND(pd.Discount_p,2)Discount_p,pd.BuyPrice,pd.isfree,IF(pd.isfree = 1,'Yes','No')FreeStatus, ROUND(po.Roundoff,2)RoundOff, ");
        //sqlCMD.Append("  ROUND(po.Scheme,2)Scheme,pd.VATPer,pd.VATAmt,pd.ExcisePer,pd.ExciseAmt,po.StoreLedgerNo,pd.TaxCalulatedOn,pd.`BuyPrice` ActualRate,pd.`Amount` ActualAmount, ");
        //sqlCMD.Append("  IFNULL(pd.GSTType,'')GSTType,IFNULL(pd.HSNCode,'')HSNCode,pd.IGSTPercent,pd.IGSTAmt,pd.CGSTPercent,pd.CGSTAmt,pd.SGSTPercent,pd.SGSTAmt  ");
        ////Deal Work
        //sqlCMD.Append("  ,IFNULL(pd.IsDeal,'')IsDeal,po.OtherCharges,im.VatType,po.S_CountryID,po.S_Currency,po.C_Factor ");
        ////
        //sqlCMD.Append("  FROM f_purchaseorder po  ");
        //sqlCMD.Append("  INNER JOIN f_purchaseorderdetails pd ON po.PurchaseOrderNo = pd.PurchaseOrderNo INNER JOIN employee_master em ON em.EmployeeID = po.RaisedUserID   ");
        //sqlCMD.Append("  INNER JOIN f_itemmaster im ON pd.ItemID=im.ItemID  LEFT JOIN f_itemmaster_deptWise fid ON fid.itemID=im.itemID AND fid.DeptLedgerNo='" + departmentLedgerNumber + "'  ");
        //sqlCMD.Append("  WHERE pd.Status = 0 AND pd.Approved = 1 AND po.PurchaseOrderNo = '" + purchaseOrderNumber + "' ");
        //sqlCMD.Append("  GROUP BY pd.ItemID,IsFree ");

        sqlCMD.Append("SELECT  '' Octori,'' GatePassIn,'true' IsOrginal,IF(im.IsExpirable='NO',0,1)IsExpirable,im.Type_ID,im.SaleTaxPer,IF(im.IsUsable='R',1,0)IsUsable, ");
        sqlCMD.Append("po.PurchaseOrderNo,    ROUND(po.Freight/IFNULL(po.C_Factor,1),2)Freight,po.VendorName,po.ApprovedDate,po.VendorID,po.Subject,CONCAT(em.Title,' ',em.Name) RaisedUserName, ");
        sqlCMD.Append("pd.PurchaseOrderDetailID,     pd.ItemID,pd.ItemName,pd.SubCategoryID,SUM(pd.ApprovedQty) OrderedQty,ROUND(po.ExciseOnBill/IFNULL(po.C_Factor,1),2)ExciseOnBill,    ");
        sqlCMD.Append("IF(IFNULL(fid.MajorUnit,'')='',IFNULL(im.MajorUnit,''),fid.MajorUnit)MajorUnit,  IF(IFNULL(fid.MinorUnit,'')='',IFNULL(im.MinorUnit,''), ");
        sqlCMD.Append("fid.MinorUnit)MinorUnit,   IF(IFNULL(fid.ConversionFactor,'')='',IFNULL(im.ConversionFactor,'1'),fid.ConversionFactor)ConversionFactor,  ");
        sqlCMD.Append("ROUND(SUM(pd.ApprovedQty-IFNULL(pd.RecievedQty,'0')),0)RemainQty,ROUND(SUM(pd.RecievedQty),2)RecievedQty,   ROUND((pd.Rate/IF(IFNULL(fid.ConversionFactor,'')='',IFNULL(im.ConversionFactor,'1'),fid.ConversionFactor)),4)Rate, ");
        sqlCMD.Append("ROUND(pd.Rate/IFNULL(po.C_Factor,1),4)RateDisplay,pd.Unit,'false' Save,'' BatchNo,   ''SaleTax,'' RecvQty,MRP,'' ExpiryDate,'' NewQty,'' NewUnit,ROUND(pd.Discount_p,2)Discount_p, ");
        sqlCMD.Append("ROUND(pd.BuyPrice/IFNULL(po.C_Factor,1),4)BuyPrice,pd.isfree,IF(pd.isfree = 1,'Yes','No')FreeStatus, ROUND(po.Roundoff/IFNULL(po.C_Factor,1),2)RoundOff,   ROUND(po.Scheme/IFNULL(po.C_Factor,1),2)Scheme,pd.VATPer,ROUND(pd.VATAmt/IFNULL(po.C_Factor,1),2)VATAmt, ");
        sqlCMD.Append("pd.ExcisePer,pd.ExciseAmt/IFNULL(po.C_Factor,1)ExciseAmt,po.StoreLedgerNo,pd.TaxCalulatedOn,pd.`BuyPrice`/IFNULL(po.C_Factor,1) ActualRate,pd.`Amount`/IFNULL(po.C_Factor,1) ActualAmount,   IFNULL(pd.GSTType,'')GSTType,  CONCAT(UPPER(pd.GSTType),'(',ROUND((pd.IGSTPercent+pd.SGSTPercent+pd.CGSTPercent),2),')') AS GSTTypeNew,  ");

        sqlCMD.Append("IFNULL(pd.HSNCode,'aaa')HSNCode,pd.IGSTPercent,pd.IGSTAmt/IFNULL(po.C_Factor,1)IGSTAmt,pd.CGSTPercent,pd.CGSTAmt/IFNULL(po.C_Factor,1)CGSTAmt,pd.SGSTPercent,pd.SGSTAmt/IFNULL(po.C_Factor,1)SGSTAmt    ,IFNULL(pd.IsDeal,'')IsDeal, ");

        // sqlCMD.Append("po.OtherCharges/IFNULL(po.C_Factor,1)OtherCharges,im.VatType,po.S_CountryID,po.S_Currency,po.C_Factor,im.DefaultSaleVatPercentage,IFNULL(pd.Minimum_Tolerance_Qty,0)Minimum_Tolerance_Qty,IFNULL(pd.Maximum_Tolerance_Qty,0)Maximum_Tolerance_Qty,IFNULL(pd.Maximum_Tolerance_Rate,0)Maximum_Tolerance_Rate,IFNULL(pd.Minimum_Tolerance_Rate,0)Minimum_Tolerance_Rate ,po.PaymentModeID   ");
        sqlCMD.Append("po.OtherCharges/IFNULL(po.C_Factor,1)OtherCharges,im.VatType,po.S_CountryID,po.S_Currency,po.C_Factor,im.DefaultSaleVatPercentage,IFNULL(ctl.Minimum_Tolerance_Qty,0)Minimum_Tolerance_Qty,IFNULL(ctl.Maximum_Tolerance_Qty,0)Maximum_Tolerance_Qty,IFNULL(ctl.Maximum_Tolerance_Rate,0)Maximum_Tolerance_Rate,IFNULL(ctl.Minimum_Tolerance_Rate,0)Minimum_Tolerance_Rate ,po.PaymentModeID   ");

        sqlCMD.Append(" ,pd.IGSTAmt,pd.CGSTAmt,pd.SGSTAmt ");
        sqlCMD.Append("FROM f_purchaseorder po INNER JOIN f_purchaseorderdetails pd ON po.PurchaseOrderNo = pd.PurchaseOrderNo INNER JOIN employee_master em ON em.EmployeeID = po.RaisedUserID      ");
        sqlCMD.Append("INNER JOIN f_itemmaster im ON pd.ItemID=im.ItemID  LEFT JOIN f_itemmaster_deptWise fid ON fid.itemID=im.itemID AND fid.DeptLedgerNo='LSHHI57'     ");

        sqlCMD.Append("LEFT JOIN `f_tolerancelevel` ctl ON ctl.`ItemID`=pd.`ItemID` AND ctl.`IsActive`=1 ");

        if (Resources.Resource.IsCentrewiseTolerance == "0")
            sqlCMD.Append(" AND  ctl.`CentreID`=0 ");
        else
            sqlCMD.Append(" AND  ctl.`CentreID`=" + HttpContext.Current.Session["CentreID"].ToString() + " ");


        sqlCMD.Append("WHERE pd.Status = 0 AND pd.Approved = 1 AND po.PurchaseOrderNo = '" + purchaseOrderNumber + "'   GROUP BY pd.ItemID,IsFree Having RemainQty>0  ");



        var dataTable = StockReports.GetDataTable(sqlCMD.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(dataTable);

    }



    [WebMethod(EnableSession = true)]
    public static string GetPurchaseOrders(string StoreType, string purchaseOrderFromDate, string purchaseOrderToDate, string purchaseOrderNumber, string vendorID)
    {
        string DeptLedgerno = string.Empty;
       
        DeptLedgerno = HttpContext.Current.Session["DeptLedgerNo"].ToString();
        StringBuilder sqlCMD = new StringBuilder();
        sqlCMD.Append("  SELECT  ");
        sqlCMD.Append(" DISTINCT po.PurchaseOrderNo, ");
        sqlCMD.Append(" po.VendorName,     ");
        sqlCMD.Append(" CONCAT(po.VendorName,' (',po.PurchaseOrderNo,')')PO, ");
        sqlCMD.Append(" pod.StoreLedgerNo, ");
        sqlCMD.Append(" CONCAT(em.Title,' ',em.Name) EmployeeName, ");
        sqlCMD.Append(" DATE_FORMAT(po.RaisedDate,'%d-%b-%Y')RaisedOn ,ROUND(SUM(pod.ApprovedQty-IFNULL(pod.RecievedQty,'0')),2)RemainQty");
        sqlCMD.Append(" FROM f_purchaseorder po ");
        sqlCMD.Append(" INNER JOIN f_purchaseorderdetails pod ON po.PurchaseOrderNo=pod.PurchaseOrderNo  ");
        sqlCMD.Append(" INNER JOIN employee_master em ON em.EmployeeID=po.RaisedUserID ");
        sqlCMD.Append(" INNER JOIN f_subcategorymaster sb ON sb.SubCategoryID=pod.SubCategoryID  ");
        sqlCMD.Append(" INNER JOIN f_categorymaster cm ON cm.categoryID=sb.CategoryID INNER JOIN f_configrelation cf ON cf.categoryID=  cm.categoryID  ");
        sqlCMD.Append(" INNER JOIN f_ledgermaster lm ON lm.ledgernumber = po.VendorID AND lm.GroupID='VEN'   ");
        //sqlCMD.Append(" INNER JOIN f_purchaseorderpurchaserequest pr ON pr.PONumber=po.PurchaseOrderNo  ");
        //sqlCMD.Append(" INNER JOIN f_purchaserequestmaster prr ON prr.PurchaseRequestNo=pr.PRNumber AND prr.DeptLedgerNo='" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "'   ");
        sqlCMD.Append(" WHERE   po.Approved = 2 AND po.IsService=0 ");//po.status = 2 AND

        if (string.IsNullOrEmpty(purchaseOrderNumber))
            sqlCMD.Append(" and po.RaisedDate>='" + Util.GetDateTime(purchaseOrderFromDate).ToString("yyyy-MM-dd") + "' and po.RaisedDate<='" + Util.GetDateTime(purchaseOrderToDate).ToString("yyyy-MM-dd") + "' ");
        else
            sqlCMD.Append(" and po.PurchaseOrderNo='" + purchaseOrderNumber + "'");

        if (!string.IsNullOrEmpty(vendorID))
            sqlCMD.Append(" and po.VendorID='" + vendorID + "'");

        sqlCMD.Append("  AND po.StoreLedgerNo='" + StoreType + "'  and po.CentreID=" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + " GROUP BY po.PurchaseOrderNo HAVING RemainQty>0  ORDER BY VendorName,po.PurchaseOrderNo  ");

        var dataTable = StockReports.GetDataTable(sqlCMD.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dataTable);
    }

    [WebMethod(EnableSession = true)]
    public static string getCurrencyFactor(string CountryID)
    {
        DataTable dtDetail = All_LoadData.LoadCurrencyFactor("");
        DataRow[] dr;
        if (CountryID == "")
            dr = dtDetail.Select("IsBaseCurrency=1");
        else
            dr = dtDetail.Select("CountryID='" + CountryID + "'");
        var Selling_Specific = dr[0]["Selling_Specific"].ToString();
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { Selling_Specific = Selling_Specific });
    }


    [WebMethod]
    public static string GetGRNEditDetails(string ledgertransactionNo, string centreID)
    {

        StringBuilder sqlCMD = new StringBuilder("SELECT ");

        if (Resources.Resource.IsGSTApplicable == "0")
        {
            sqlCMD.Append("con.ID, ");
            sqlCMD.Append("con.LedgertransactionNo, ");
            sqlCMD.Append("con.VenLedgerNo, ");
            sqlCMD.Append("con.ChalanNo, ");
            sqlCMD.Append("IF( ");
            sqlCMD.Append("con.ChalanNo = '', ");
            sqlCMD.Append("'', ");
            sqlCMD.Append("DATE_FORMAT(con.ChalanDate, '%d-%b-%Y') ");
            sqlCMD.Append(") ChallanDate, ");
            sqlCMD.Append("con.InvoiceNo, ");
            sqlCMD.Append("IF( ");
            sqlCMD.Append("con.InvoiceNo = '', ");
            sqlCMD.Append("'', ");
            sqlCMD.Append("DATE_FORMAT(con.InvoiceDate, '%d-%b-%Y') ");
            sqlCMD.Append(") InvoiceDate, ");
            sqlCMD.Append("con.InvoiceDate, ");
            sqlCMD.Append("con.ItemID, ");
            sqlCMD.Append("con.ItemName, ");
            sqlCMD.Append("con.BatchNumber, ");
            sqlCMD.Append("ROUND((con.Rate/con.CurrencyFactor),4)Rate, ");
            sqlCMD.Append("ROUND((con.UnitPrice/con.CurrencyFactor),4)UnitPrice, ");
            sqlCMD.Append("con.PurTaxPer, ");
            sqlCMD.Append("ROUND((con.PurTaxAmt/con.CurrencyFactor),4)PurTaxAmt, ");
            sqlCMD.Append("ROUND((con.DiscAmt/con.CurrencyFactor),4)DiscAmt, ");
            sqlCMD.Append("con.SaleTaxPer, ");
            sqlCMD.Append("ROUND((con.SaleTaxAmt/con.CurrencyFactor),4)SaleTaxAmt, ");
            sqlCMD.Append("con.TYPE, ");
            sqlCMD.Append("con.Reusable, ");
            sqlCMD.Append("con.IsBilled, ");
            sqlCMD.Append("'' TaxID, ");
            sqlCMD.Append("con.DiscPer, ");
            sqlCMD.Append("ROUND((con.MRP/con.CurrencyFactor),4)MRP, ");
            sqlCMD.Append("'' Unit, ");
            sqlCMD.Append("con.InitialCount, ");
            sqlCMD.Append("con.ReleasedCount, ");
            sqlCMD.Append("con.StockDate, ");
            sqlCMD.Append("con.IsPost, ");
            sqlCMD.Append("con.PostUserID, ");
            sqlCMD.Append("con.PostDate, ");
            sqlCMD.Append("con.IsFree, ");
            sqlCMD.Append("con.Naration, ");
            sqlCMD.Append("con.DeptLedgerNo, ");
            sqlCMD.Append("'' GateEntryNo, ");
            sqlCMD.Append("'' Freight, ");
            sqlCMD.Append("'' Octroi, ");
            sqlCMD.Append("'' RoundOff, ");
            sqlCMD.Append("'' GRNAmount, ");
            sqlCMD.Append("'' EntDate, ");
            sqlCMD.Append("'' UserID, ");
            sqlCMD.Append("'' IsCancel, ");
            sqlCMD.Append("DATE_FORMAT(MedExpiryDate, '%m/%y') MedExpiryDate, ");
            sqlCMD.Append("'' ReturnDate, ");
            sqlCMD.Append("'' ReturnBYUserName, ");
            sqlCMD.Append("'' ReturnUserID, ");
            sqlCMD.Append("'' RejectReason, ");
            sqlCMD.Append("'' RejectedBy, ");
            sqlCMD.Append("'' RejectDateTime, ");
            sqlCMD.Append("'' IGSTPercent, ");
            sqlCMD.Append("'' CGSTPercent, ");
            sqlCMD.Append("'' SGSTPercent, ");
            sqlCMD.Append("'' GSTType, ");
            sqlCMD.Append("'' SpecialDiscPer, ");
            sqlCMD.Append("con.isDeal, ");
            sqlCMD.Append("con.ConversionFactor, ");
            sqlCMD.Append("ROUND((con.OtherCharges/con.CurrencyFactor),4)OtherCharges, ");
            sqlCMD.Append("con.MarkUpPercent, ");
            sqlCMD.Append("con.LandingCost, ");
            sqlCMD.Append("con.CurrencyCountryID, ");
            sqlCMD.Append("con.Currency, ");
            sqlCMD.Append("con.CurrencyFactor, ");
            sqlCMD.Append("con.CentreID, ");
            sqlCMD.Append("im.MajorUnit, ");
            sqlCMD.Append("im.MinorUnit, ");
            sqlCMD.Append("im.SubCategoryID, ");
            sqlCMD.Append("IF(im.IsExpirable = 'YES', 1, 0) IsExpirable, ");
            sqlCMD.Append("LedgerTnxNo ");
            sqlCMD.Append("FROM ");
            sqlCMD.Append("f_stock con ");
            sqlCMD.Append("INNER JOIN f_itemmaster im ");
            sqlCMD.Append("ON im.ItemID = con.ItemID ");
            sqlCMD.Append("WHERE con.ReferenceNo =@ledgertransactionNo ");
            sqlCMD.Append("AND con.IsPost = 0 ");
            sqlCMD.Append("AND con.CentreID =@centreID ");
        }
        else if (Resources.Resource.IsGSTApplicable == "1")
        {
            sqlCMD.Append("con.ID, ");
            sqlCMD.Append("con.ReferenceNo LedgertransactionNo,con.HSNCode, ");
            sqlCMD.Append("con.VenLedgerNo, ");
            sqlCMD.Append("con.ChalanNo, ");
            sqlCMD.Append("IF( ");
            sqlCMD.Append("con.ChalanNo = '', ");
            sqlCMD.Append("'', ");
            sqlCMD.Append("DATE_FORMAT(con.ChalanDate, '%d-%b-%Y') ");
            sqlCMD.Append(") ChallanDate, ");
            sqlCMD.Append("con.InvoiceNo, ");
            sqlCMD.Append("IF( ");
            sqlCMD.Append("con.InvoiceNo = '', ");
            sqlCMD.Append("'', ");
            sqlCMD.Append("DATE_FORMAT(con.InvoiceDate, '%d-%b-%Y') ");
            sqlCMD.Append(") InvoiceDate, ");
            sqlCMD.Append("con.InvoiceDate, ");
            sqlCMD.Append("con.ItemID, ");
            sqlCMD.Append("con.ItemName, ");
            sqlCMD.Append("con.BatchNumber, ");
            sqlCMD.Append("ROUND((con.Rate/con.CurrencyFactor),4)Rate, ");
            sqlCMD.Append("ROUND((con.UnitPrice/con.CurrencyFactor),4)UnitPrice, ");
            sqlCMD.Append("con.PurTaxPer, ");
            sqlCMD.Append("ROUND((con.PurTaxAmt/con.CurrencyFactor),4)PurTaxAmt, ");
            sqlCMD.Append("ROUND((con.DiscAmt/con.CurrencyFactor),4)DiscAmt, ");
            sqlCMD.Append("con.SaleTaxPer, ");
            sqlCMD.Append("ROUND((con.SaleTaxAmt/con.CurrencyFactor),4)SaleTaxAmt, ");
            sqlCMD.Append("con.TYPE, ");
            sqlCMD.Append("con.Reusable, ");
            sqlCMD.Append("con.IsBilled, ");
            sqlCMD.Append("'' TaxID, ");
            sqlCMD.Append(" ROUND(con.DiscPer)DiscPer, ");
            sqlCMD.Append("ROUND((con.Mrp/IFNULL(con.CurrencyFactor,1))*IFNULL(con.conversionFactor,1),4)MRP, ");
            sqlCMD.Append("'' Unit, ");
            sqlCMD.Append("con.InitialCount, ");
            sqlCMD.Append(" ROUND((con.InitialCount/con.conversionFactor),0)Qty, ");
            sqlCMD.Append("con.ReleasedCount, ");
            sqlCMD.Append("con.StockDate, ");
            sqlCMD.Append("con.IsPost, ");
            sqlCMD.Append("con.PostUserID, ");
            sqlCMD.Append("con.PostDate, ");
            sqlCMD.Append("con.IsFree, ");
            sqlCMD.Append("con.Naration, ");
            sqlCMD.Append("con.DeptLedgerNo, ");
            sqlCMD.Append("'' GateEntryNo, ");
            sqlCMD.Append("'' Freight, ");
            sqlCMD.Append("'' Octroi, ");
            sqlCMD.Append("'' RoundOff, ");
            sqlCMD.Append("'' GRNAmount, ");
            sqlCMD.Append("'' EntDate, ");
            sqlCMD.Append("'' UserID, ");
            sqlCMD.Append("'' IsCancel, ");
            sqlCMD.Append("DATE_FORMAT(con.MedExpiryDate, '%m/%y') MedExpiryDate, ");
            sqlCMD.Append("'' ReturnDate, ");
            sqlCMD.Append("'' ReturnBYUserName, ");
            sqlCMD.Append("'' ReturnUserID, ");
            sqlCMD.Append("'' RejectReason, ");
            sqlCMD.Append("'' RejectedBy, ");
            sqlCMD.Append("'' RejectDateTime, ");
            sqlCMD.Append(" con.IGSTPercent, ");
            sqlCMD.Append(" con.CGSTPercent, ");
            sqlCMD.Append(" con.SGSTPercent, ");
            sqlCMD.Append(" con.GSTType, ");
            sqlCMD.Append(" CONCAT(UPPER(con.GSTType),'(',ROUND((con.IGSTPercent+con.SGSTPercent+con.CGSTPercent),2),')') AS GSTTypeNew, ");
            sqlCMD.Append("'' SpecialDiscPer, ");
            sqlCMD.Append("con.isDeal,LEFT(con.isDeal,LOCATE('+',con.isDeal) - 1)D1,SUBSTRING_INDEX(con.isDeal,'+',-1)D2, ");
            sqlCMD.Append("con.ConversionFactor, ");
            sqlCMD.Append("ROUND((con.OtherCharges/con.CurrencyFactor),4)OtherCharges, ");
            sqlCMD.Append("con.MarkUpPercent, ");
            sqlCMD.Append("con.LandingCost, ");
            sqlCMD.Append("con.CurrencyCountryID, ");
            sqlCMD.Append("con.Currency, ");
            sqlCMD.Append("con.CurrencyFactor, ");
            sqlCMD.Append("con.CentreID, ");
            sqlCMD.Append("im.MajorUnit, ");
            sqlCMD.Append("im.MinorUnit, ");
            sqlCMD.Append("im.SubCategoryID, ");
            sqlCMD.Append("IF(im.IsExpirable = 'YES', 1, 0) IsExpirable, ");
            sqlCMD.Append("LedgerTnxNo, ROUND(IFNULL((con.IGSTAmtPerUnit*con.InitialCount),0)+IFNULL((con.SGSTAmtPerUnit*con.InitialCount),0)+IFNULL((con.CGSTAmtPerUnit*con.InitialCount),0),2) VATAmt,  ");
            sqlCMD.Append(" IFNULL((con.IGSTAmtPerUnit*con.InitialCount),0)IGSTAmt,IFNULL((con.SGSTAmtPerUnit*con.InitialCount),0)SGSTAmt,IFNULL((con.CGSTAmtPerUnit*con.InitialCount),0)CGSTAmt, ");
            sqlCMD.Append(" ROUND((con.InitialCount*con.Rate)+(ROUND(IFNULL((con.IGSTAmtPerUnit*con.InitialCount),0)+IFNULL((con.SGSTAmtPerUnit*con.InitialCount),0)+IFNULL((con.CGSTAmtPerUnit*con.InitialCount),0),2)) - con.DiscAmt)NetAmount ");
            sqlCMD.Append(" From f_stock con ");
            //sqlCMD.Append("FROM F_LEDGERTRANSACTION lt ");
            //sqlCMD.Append(" INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNO=ltd.LedgerTransactionNo ");
            //sqlCMD.Append(" INNER JOIN f_stock con ON con.StockID=ltd.StockID  ");
            sqlCMD.Append("INNER JOIN f_itemmaster im ON im.ItemID = con.ItemID ");
            sqlCMD.Append("WHERE con.ReferenceNo =@ledgertransactionNo ");
            sqlCMD.Append("AND con.IsPost = 0 ");
            sqlCMD.Append("AND con.CentreID =@centreID ");
        }


        ExcuteCMD excuteCMD = new ExcuteCMD();



        string _dt = excuteCMD.GetRowQuery(sqlCMD.ToString(), new
        {
            ledgertransactionNo = ledgertransactionNo,
            centreID = centreID
        });

        DataTable dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
        {
            ledgertransactionNo = ledgertransactionNo,
            centreID = centreID
        });


        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);






    }


    [WebMethod(EnableSession = true)]
    public static string RemoveGRNItem(string ledgerTnxNo, string stockNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();



        try
        {


            var userID = HttpContext.Current.Session["ID"].ToString();

            excuteCMD.DML(tnx, "UPDATE f_ledgertnxdetail ltd SET ltd.IsVerified=2,ltd.VarifiedUserID=@verifiedUserID,ltd.VerifiedDate=NOW() WHERE ltd.ID=@ledgerTnxNo", CommandType.Text, new
            {

                verifiedUserID = userID,
                ledgerTnxNo = ledgerTnxNo


            });


            string s = excuteCMD.GetRowQuery("UPDATE f_stock st SET st.IsPost=2 AND st.PostUserID=@verifiedUserID AND st.PostDate=NOW() WHERE st.ID=@id", new
             {

                 verifiedUserID = userID,
                 id = stockNo


             });

            excuteCMD.DML(tnx, "UPDATE f_stock st SET st.IsPost=3 , st.PostUserID=@verifiedUserID , st.PostDate=NOW() WHERE st.ID=@id", CommandType.Text, new
            {

                verifiedUserID = userID,
                id = stockNo


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


}