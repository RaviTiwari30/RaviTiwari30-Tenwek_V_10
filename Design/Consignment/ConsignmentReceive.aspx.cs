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



public partial class Design_Consignment_ConsignmentReceive : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();

                ViewState["ID"] = Session["ID"].ToString();
                ViewState["HOSPID"] = Session["HOSPID"].ToString();

                rblStoreType_SelectedIndexChanged(this, new EventArgs());
                calBillDate.EndDate = DateTime.Now;
                CalchallanDate.EndDate = DateTime.Now;
                calWayBillDate.EndDate = DateTime.Now;
                BindVendor();
                //txtBillNo.Text = "03-Dec-2018";
                //txtBillDate.Text = "03-Dec-2018";
          

        }
        txtBillDate.Attributes.Add("readOnly", "true");
        txtChallanDate.Attributes.Add("readOnly", "true");
        txtWayBillDate.Attributes.Add("readonly", "true");


    }


    protected bool ChkRights()
    {
        string RoleId = Session["RoleID"].ToString();
        string EmpId = Session["ID"].ToString();
        rblStoreType.Items[0].Enabled = false;
     //   rblStoreType.Items[1].Enabled = false;
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
               // rblStoreType.Items[1].Enabled = Util.GetBoolean(dt.Rows[0]["IsGeneral"]);
                //if ((dt.Rows[0]["IsMedical"].ToString() == "true" && dt.Rows[0]["IsGeneral"].ToString() == "true") || (dt.Rows[0]["IsMedical"].ToString() == "true" && dt.Rows[0]["IsGeneral"].ToString() == "false"))
                //{
                //    rblStoreType.Items[0].Selected = true;
                //    rblStoreType.Items[1].Selected = false;
                //}
                //else if (dt.Rows[0]["IsMedical"].ToString() == "false" && dt.Rows[0]["IsGeneral"].ToString() == "true")
                //{
                //    rblStoreType.Items[1].Selected = true;
                //    rblStoreType.Items[0].Selected = false;
                //}

                rblStoreType.Items[0].Selected = true;

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
            sb.Append(" WHERE groupID='VEN' AND IsCurrent=1 AND vm.DepTLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' ORDER BY LedgerName ");
        }
        else
        {
            // sb.Append(" select concat(LedgerNumber,'#',LedgerUserID)ID,LedgerName from f_ledgermaster where groupID='VEN' and IsCurrent=1 order by LedgerName ");
            sb.Append(" SELECT CONCAT(lm.LedgerNumber,'#',lm.LedgerUserID,'#',vm.StateID,'#',vm.VATType)ID,lm.LedgerName FROM f_ledgermaster  lm  ");
            sb.Append(" INNER JOIN `f_vendormaster` vm ON lm.`LedgerUserID`=vm.`Vendor_ID` ");
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
        }
        else
        {
            ddlVendor.Items.Clear();
            ddlVendor.DataSource = null;
            ddlVendor.DataBind();
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
        //sqlCMD.Append("  INNER JOIN f_purchaseorderdetails pd ON po.PurchaseOrderNo = pd.PurchaseOrderNo INNER JOIN employee_master em ON em.Employee_ID = po.RaisedUserID   ");
        //sqlCMD.Append("  INNER JOIN f_itemmaster im ON pd.ItemID=im.ItemID  LEFT JOIN f_itemmaster_deptWise fid ON fid.itemID=im.itemID AND fid.DeptLedgerNo='" + departmentLedgerNumber + "'  ");
        //sqlCMD.Append("  WHERE pd.Status = 0 AND pd.Approved = 1 AND po.PurchaseOrderNo = '" + purchaseOrderNumber + "' ");
        //sqlCMD.Append("  GROUP BY pd.ItemID,IsFree ");

        sqlCMD.Append("SELECT  '' Octori,'' GatePassIn,'true' IsOrginal,IF(im.IsExpirable='NO',0,1)IsExpirable,im.Type_ID,im.SaleTaxPer,IF(im.IsUsable='R',1,0)IsUsable, ");
        sqlCMD.Append("po.PurchaseOrderNo,    ROUND(po.Freight/IFNULL(po.C_Factor,1),2)Freight,po.VendorName,po.ApprovedDate,po.VendorID,po.Subject,CONCAT(em.Title,' ',em.Name) RaisedUserName, ");
        sqlCMD.Append("pd.PurchaseOrderDetailID,     pd.ItemID,pd.ItemName,pd.SubCategoryID,SUM(pd.ApprovedQty) OrderedQty,ROUND(po.ExciseOnBill/IFNULL(po.C_Factor,1),2)ExciseOnBill,    ");
        sqlCMD.Append("IF(IFNULL(fid.MajorUnit,'')='',IFNULL(im.MajorUnit,''),fid.MajorUnit)MajorUnit,  IF(IFNULL(fid.MinorUnit,'')='',IFNULL(im.MinorUnit,''), ");
        sqlCMD.Append("fid.MinorUnit)MinorUnit,   IF(IFNULL(fid.ConversionFactor,'')='',IFNULL(im.ConversionFactor,'1'),fid.ConversionFactor)ConversionFactor,  ");
        sqlCMD.Append("ROUND(SUM(pd.ApprovedQty-pd.RecievedQty),2)RemainQty,   ROUND((pd.Rate/IF(IFNULL(fid.ConversionFactor,'')='',IFNULL(im.ConversionFactor,'1'),fid.ConversionFactor)),4)Rate, ");
        sqlCMD.Append("ROUND(pd.Rate/IFNULL(po.C_Factor,1),4)RateDisplay,pd.Unit,'false' Save,'' BatchNo,   ''SaleTax,'' RecvQty,MRP,'' ExpiryDate,'' NewQty,'' NewUnit,ROUND(pd.Discount_p,2)Discount_p, ");
        sqlCMD.Append("ROUND(pd.BuyPrice/IFNULL(po.C_Factor,1),4)BuyPrice,pd.isfree,IF(pd.isfree = 1,'Yes','No')FreeStatus, ROUND(po.Roundoff/IFNULL(po.C_Factor,1),2)RoundOff,   ROUND(po.Scheme/IFNULL(po.C_Factor,1),2)Scheme,pd.VATPer,ROUND(pd.VATAmt/IFNULL(po.C_Factor,1),2)VATAmt, ");
        sqlCMD.Append("pd.ExcisePer,pd.ExciseAmt/IFNULL(po.C_Factor,1)ExciseAmt,po.StoreLedgerNo,pd.TaxCalulatedOn,pd.`BuyPrice`/IFNULL(po.C_Factor,1) ActualRate,pd.`Amount`/IFNULL(po.C_Factor,1) ActualAmount,   IFNULL(pd.GSTType,'')GSTType, ");
        sqlCMD.Append("IFNULL(pd.HSNCode,'')HSNCode,pd.IGSTPercent,pd.IGSTAmt/IFNULL(po.C_Factor,1)IGSTAmt,pd.CGSTPercent,pd.CGSTAmt/IFNULL(po.C_Factor,1)CGSTAmt,pd.SGSTPercent,pd.SGSTAmt/IFNULL(po.C_Factor,1)SGSTAmt    ,IFNULL(pd.IsDeal,'')IsDeal, ");
        sqlCMD.Append("po.OtherCharges/IFNULL(po.C_Factor,1)OtherCharges,im.VatType,po.S_CountryID,po.S_Currency,po.C_Factor,im.DefaultSaleVatPercentage    ");
        sqlCMD.Append("FROM f_purchaseorder po INNER JOIN f_purchaseorderdetails pd ON po.PurchaseOrderNo = pd.PurchaseOrderNo INNER JOIN employee_master em ON em.Employee_ID = po.RaisedUserID      ");
        sqlCMD.Append("INNER JOIN f_itemmaster im ON pd.ItemID=im.ItemID  LEFT JOIN f_itemmaster_deptWise fid ON fid.itemID=im.itemID AND fid.DeptLedgerNo='LSHHI57'     ");
        sqlCMD.Append("WHERE pd.Status = 0 AND pd.Approved = 1 AND po.PurchaseOrderNo = '" + purchaseOrderNumber + "'   GROUP BY pd.ItemID,IsFree  ");



        var dataTable = StockReports.GetDataTable(sqlCMD.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(dataTable);

    }



    [WebMethod]
    public static string GetPurchaseOrders()
    {

        StringBuilder sqlCMD = new StringBuilder();
        sqlCMD.Append("  SELECT  ");
        sqlCMD.Append(" DISTINCT po.PurchaseOrderNo, ");
        sqlCMD.Append(" po.VendorName,     ");
        sqlCMD.Append(" CONCAT(po.VendorName,' (',po.PurchaseOrderNo,')')PO, ");
        sqlCMD.Append(" pod.StoreLedgerNo, ");
        sqlCMD.Append(" CONCAT(em.Title,' ',em.Name) EmployeeName, ");
        sqlCMD.Append(" DATE_FORMAT(po.RaisedDate,'%d-%b-%Y')RaisedOn ");

        

        sqlCMD.Append(" FROM f_purchaseorder po ");
        sqlCMD.Append(" INNER JOIN f_purchaseorderdetails pod ON po.PurchaseOrderNo=pod.PurchaseOrderNo  ");
        sqlCMD.Append(" INNER JOIN employee_master em ON em.Employee_ID=po.RaisedUserID ");
        sqlCMD.Append(" INNER JOIN f_subcategorymaster sb ON sb.SubCategoryID=pod.SubCategoryID  ");
        sqlCMD.Append(" INNER JOIN f_categorymaster cm ON cm.categoryID=sb.CategoryID INNER JOIN f_configrelation cf ON cf.categoryID=  cm.categoryID  ");
        sqlCMD.Append(" INNER JOIN f_ledgermaster lm ON lm.ledgernumber = po.VendorID AND lm.GroupID='VEN'   ");
        sqlCMD.Append(" WHERE po.status = 2 AND po.Approved = 2 ORDER BY VendorName,po.PurchaseOrderNo  ");

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
    public static string GetConsignmentEditDetails(string consignmentNo, string centreID)
    {



        StringBuilder sqlCMD = new StringBuilder("SELECT con.ID, con.ConsignmentNo, con.VendorLedgerNo, con.ChallanNo, IF(con.ChallanNo='','', DATE_FORMAT(con.ChallanDate,'%d-%b-%Y')) ChallanDate, con.BillNo, IF(con.BillNo='','',DATE_FORMAT(con.BillDate,'%d-%b-%Y')) BillDate, con.ItemID, con.ItemName, con.BatchNumber, ROUND((con.Rate/con.CurrencyFactor),4)Rate, ROUND((con.UnitPrice/con.CurrencyFactor),4)UnitPrice, con.TaxPer, con.PurTaxAmt,ROUND((con.DiscAmt/con.CurrencyFactor),4)DiscAmt, con.SaleTaxPer, con.SaleTaxAmt, con.TYPE, con.Reusable, con.IsBilled, con.TaxID, con.DiscountPer, ROUND((con.Mrp/IFNULL(con.CurrencyFactor,1))*IFNULL(con.conversionFactor,1),4)MRP, con.Unit, con.InititalCount, con.ReleasedCount, con.StockDate, con.IsPost, con.PostUserID, con.PostDate, con.IsFree, con.Naration, con.DeptLedgerNo, con.GateEntryNo, con.Freight, con.Octroi, con.RoundOff, con.GRNAmount, con.EntDate, con.UserID, con.IsCancel, DATE_FORMAT(MedExpiryDate,'%m/%y')MedExpiryDate, con.ReturnDate, con.ReturnBYUserName, con.ReturnUserID, con.RejectReason, con.RejectedBy, con.RejectDateTime, con.IGSTPercent, con.CGSTPercent, con.SGSTPercent, con.GSTType, con.SpecialDiscPer, con.isDeal, con.ConversionFactor, con.OtherCharges, con.MarkUpPercent, con.LandingCost, con.CurrencyCountryID, con.Currency, con.CurrencyFactor, con.CentreID, im.MajorUnit, im.MinorUnit, im.SubCategoryID, IF(im.IsExpirable='YES',1,0) IsExpirable, ROUND((con.CGSTAmt/con.`CurrencyFactor`),4)CGSTAmt,ROUND((con.SGSTAmt/con.`CurrencyFactor`),4)SGSTAmt,ROUND((con.IGSTAmt/con.`CurrencyFactor`),4)IGSTAmt,con.Quantity AS Qty,con.HSNCode,con.SpecialDiscPer,con.ItemNetAmount AS 'NetAmount',CONCAT(UPPER(con.GSTType),'(',ROUND((con.IGSTPercent+con.SGSTPercent+con.CGSTPercent),2),')')GSTTypeNew FROM consignmentdetail con INNER JOIN f_itemmaster im ON im.ItemID=con.ItemID WHERE con.ConsignmentNo = @consignmentNo AND con.CentreID = @centreID");
        ExcuteCMD excuteCMD = new ExcuteCMD();

        DataTable dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
        {
            consignmentNo = consignmentNo,
            centreID = centreID
        });


        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string RemoveConsignmentItem(int ConsignmentNum, string IDD)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();

        try
        {
            excuteCMD.DML(tnx, "DELETE FROM consignmentdetail WHERE consignmentNo=@consignmentNo AND ID=@ID", CommandType.Text, new
            {

                consignmentNo = ConsignmentNum,
                ID = IDD


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