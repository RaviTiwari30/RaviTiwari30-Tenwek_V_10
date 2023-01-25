using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI.WebControls;

/// <summary>
/// Summary description for AllLoadData_Store
/// </summary>
public class AllLoadData_Store
{
    public AllLoadData_Store()
    {
        //
        // TODO: Add constructor logic here
        //
    }
    public static DataTable bindVendor()
    {
        return StockReports.GetDataTable("SELECT CONCAT(LedgerNumber,'#',LedgerUserID)ID,LedgerName FROM f_ledgermaster WHERE groupID='VEN' AND IsCurrent=1 ORDER BY LedgerName");
    }

    public static DataTable dtSalesTax()
    {
        return StockReports.GetDataTable("select Tax from f_salestax order by id");

    }
    public static void bindSalesTax(DropDownList ddlObj)
    {
        DataTable dt = dtSalesTax();
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlObj.DataSource = dt;
            ddlObj.DataTextField = "Tax";
            ddlObj.DataValueField = "Tax";
            ddlObj.DataBind();
        }
        else
        {
            ddlObj.DataSource = null;
            ddlObj.DataBind();
        }
    }

    public static void bindTypeMaster(DropDownList ddlObj, string Type = "")
    {
        DataTable dt = dtTypeMaster();
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlObj.DataSource = dt;
            ddlObj.DataTextField = "TypeName";
            ddlObj.DataValueField = "TypeID";
            ddlObj.DataBind();
            if (Type != "")
                ddlObj.Items.Insert(0, new ListItem("Select", "0"));
        }
        else
        {
            ddlObj.DataSource = null;
            ddlObj.DataBind();
        }
    }
    public static DataTable dtTypeMaster()
    {
        return StockReports.GetDataTable("select TypeID,TypeName from f_typemaster ");
    }
    public static void bindStoreDepartments(DropDownList ddlObj, string DeptLedgerNo, string Type = "")
    {
        DataTable dt = LoadCacheQuery.bindStoreDepartment();
        dt = dt.AsEnumerable().Where(r => r.Field<int>("IsStore") == 1).AsDataView().ToTable();
        if (dt.Rows.Count > 0)
        {
            ddlObj.DataSource = dt;
            ddlObj.DataTextField = "LedgerName";
            ddlObj.DataValueField = "LedgerNumber";
            ddlObj.DataBind();
            if ((DeptLedgerNo != null) && (DeptLedgerNo != ""))
                ddlObj.SelectedValue = DeptLedgerNo;
            else
                ddlObj.Items.Insert(0, new ListItem(Type, "0"));
        }
    }

    public static void bindStore(DropDownList ddlObj, string GroupID = "", string Type = "")
    {
        ddlObj.DataSource = dtStore(GroupID);
        ddlObj.DataTextField = "LedgerName";
        ddlObj.DataValueField = "LedgerNumber";
        ddlObj.DataBind();
        if (Type != "")
            ddlObj.Items.Insert(0, new ListItem(Type, "0"));
    }
    public static DataTable dtStore(string GroupID)
    {
        return StockReports.GetDataTable("SELECT LedgerName,LedgerNumber FROM f_ledgermaster Where GroupID='" + GroupID + "' AND IsCurrent=1 ORDER BY LedgerName DESC ");
    }
    public static void bindCategory(DropDownList ddlObj, int ConfigID)
    {
        DataView dv = LoadCacheQuery.loadCategory().DefaultView;
        dv.RowFilter = "  ConfigID='" + ConfigID + "' ";
        DataTable dt = dv.ToTable();
        if (dt.Rows.Count > 0)
        {
            ddlObj.DataTextField = "Name";
            ddlObj.DataValueField = "CategoryID";
            ddlObj.DataSource = dt;
            ddlObj.DataBind();
            ddlObj.Items.Insert(0, new ListItem("All", "ALL"));
            ddlObj.SelectedIndex = 0;
        }
        else
        {
            ddlObj.DataSource = null;
            ddlObj.DataBind();
        }
    }

    public static DataTable dtVendor()
    {
        return StockReports.GetDataTable("Select VendorName,Vendor_ID from f_vendormaster order by VendorName ");

    }
    public static void bindVendor(DropDownList ddlObj, string Type = "")
    {
        ddlObj.DataSource = dtVendor();
        ddlObj.DataTextField = "VendorName";
        ddlObj.DataValueField = "Vendor_ID";
        ddlObj.DataBind();
        if (Type != "")
            ddlObj.Items.Insert(0, new ListItem(Type, "0"));
    }

    public static void bindStoreIndentDepartments(DropDownList ddlObj, int RoleID, string Type = "", int storeType = 0,int Centre=0)
    {
        DataTable dt = dtStoreIndentDepartments(RoleID, storeType);
        DataView dv = dt.DefaultView;
        if (Centre == 0)
            Centre = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
        string CentreID = StockReports.ExecuteScalar("SELECT DISTINCT GROUP_CONCAT(CONCAT('''',rm.DeptLedgerNo,'''')) FROM f_rolemaster rm INNER JOIN f_centre_role cr ON cr.RoleID=rm.id WHERE cr.CentreID='" + Centre + "' AND cr.isActive=1");
        dv.RowFilter = "ledgerNumber in (" + CentreID + ") ";
        dt = dv.ToTable();
        if (dt.Rows.Count > 0)
        {
            ddlObj.DataSource = dt;
            ddlObj.DataTextField = "LedgerName";
            ddlObj.DataValueField = "LedgerNumber";
            ddlObj.DataBind();
            if (Type != "")
                ddlObj.Items.Insert(0, new ListItem(Type, "0"));
        }
    }
    public static DataTable dtManufacture()
    {
        return StockReports.GetDataTable("SELECT fmm.ManufactureID,fmm.Name Name,fmm.Address Address1,fmm.Address2,fmm.Address3,fmm.PinCode,fmm.City,fmm.Country,fmm.Contact_Person ,fmm.Mobile,fmm.Fax,fmm.Email,IF(fmm.IsActive='1','Active','InActive')Status FROM f_manufacture_master fmm WHERE IsActive=1 order by Name ");

    }
    public static void bindManufacture(DropDownList ddlObj, string Type = "")
    {
        ddlObj.DataSource = dtManufacture();
        ddlObj.DataTextField = "Name";
        ddlObj.DataValueField = "ManufactureID";
        ddlObj.DataBind();
        if (Type != "")
            ddlObj.Items.Insert(0, new ListItem(Type, "0"));
    }
    public static DataTable dtStoreIndentDepartments(int RoleID, int storeType)
    {
        DataTable dt = LoadCacheQuery.bindStoreDepartment();
        if (RoleID != 0)
            dt = dt.AsEnumerable().Where(r => r.Field<int>("IsStore") == 1 || r.Field<int>("IsIndent") == 1 && r.Field<int>("RoleID") == RoleID).AsDataView().ToTable();
        else
            dt = dt.AsEnumerable().Where(r => r.Field<int>("IsStore") == 1 || r.Field<int>("IsIndent") == 1).AsDataView().ToTable();
        if (storeType != 0)
        {
            if (storeType == 11)
                dt = dt.AsEnumerable().Where(r => r.Field<int>("IsMedical") == 1).AsDataView().ToTable();
            else
                dt = dt.AsEnumerable().Where(r => r.Field<int>("IsGeneral") == 1).AsDataView().ToTable();
        }
        return dt;
    }

    public static string taxCalulation(Object Data)
    {
        List<TaxCalculation_DirectGRN> dataGUP;
        if (Data is IEnumerable)
            dataGUP = new JavaScriptSerializer().ConvertToType<List<TaxCalculation_DirectGRN>>(Data);
        else
            dataGUP = (List<TaxCalculation_DirectGRN>)Data;

        decimal TaxAmount = 0; decimal NetAmount = 0; decimal Amount = 0; decimal DiscountAmount = 0; decimal UnitPrice = 0; decimal MRPValue = 0; decimal ExciseAmount = 0;
        decimal ExcisePer = 0; decimal Rate = 0;
        //GST Changes
        decimal igstTaxAmt = 0; decimal cgstTaxAmt = 0; decimal sgstTaxAmt = 0;
        //Special Discount Changes
        decimal SpecialDiscAmt = 0;
        if (dataGUP[0].Type == "MRP")
        {

            Amount = (dataGUP[0].Quantity * dataGUP[0].Rate);
            TaxAmount = (dataGUP[0].MRP * dataGUP[0].Quantity) - (((dataGUP[0].MRP * dataGUP[0].Quantity) * 100) / (100 + dataGUP[0].TaxPer));

            //GST Changes
            igstTaxAmt = (dataGUP[0].MRP * dataGUP[0].Quantity) - (((dataGUP[0].MRP * dataGUP[0].Quantity) * 100) / (100 + dataGUP[0].IGSTPrecent));
            cgstTaxAmt = (dataGUP[0].MRP * dataGUP[0].Quantity) - (((dataGUP[0].MRP * dataGUP[0].Quantity) * 100) / (100 + dataGUP[0].CGSTPercent));
            sgstTaxAmt = (dataGUP[0].MRP * dataGUP[0].Quantity) - (((dataGUP[0].MRP * dataGUP[0].Quantity) * 100) / (100 + dataGUP[0].SGSTPercent));
            if (dataGUP[0].DiscPer > 0)
                DiscountAmount = ((Amount * dataGUP[0].DiscPer) / 100);
            else
                DiscountAmount = dataGUP[0].DiscAmt;
            //Special Discount Changes
            if (dataGUP[0].SpecialDiscPer > 0)
                SpecialDiscAmt = (((Amount - DiscountAmount) * dataGUP[0].SpecialDiscPer) / 100);
            else
                SpecialDiscAmt = dataGUP[0].SpecialDiscAmt;

            //NetAmount = (Amount + TaxAmount - DiscountAmount);

            NetAmount = (Amount + TaxAmount - DiscountAmount - SpecialDiscAmt);

            //UnitPrice = (dataGUP[0].Rate - DiscountAmount) + TaxAmount;
            // UnitPrice = dataGUP[0].Rate + (dataGUP[0].MRP - ((dataGUP[0].MRP * 100) / (100 + dataGUP[0].TaxPer))) - ((dataGUP[0].Rate * dataGUP[0].DiscPer) / 100);
            //MRPValue = (((dataGUP[0].MRP * dataGUP[0].Quantity) - dataGUP[0].DiscPer / 100) * 100) / (100 + dataGUP[0].TaxPer);    

            UnitPrice = dataGUP[0].Rate + (dataGUP[0].MRP - ((dataGUP[0].MRP * 100) / (100 + dataGUP[0].TaxPer))) - ((dataGUP[0].Rate * dataGUP[0].DiscPer) / 100) - ((dataGUP[0].Rate - ((dataGUP[0].Rate * dataGUP[0].DiscPer) / 100)) * dataGUP[0].SpecialDiscPer / 100);
            MRPValue = (((dataGUP[0].MRP * dataGUP[0].Quantity) - (dataGUP[0].DiscPer / 100) - (dataGUP[0].SpecialDiscPer / 100)) * 100) / (100 + dataGUP[0].TaxPer);
        }
        else if (dataGUP[0].Type == "Rate")
        {
            if (dataGUP[0].deal == 0 && dataGUP[0].deal2 == 0)
            {
                Amount = (dataGUP[0].Quantity * dataGUP[0].Rate);
                Rate = dataGUP[0].Rate;
            }
            else
            {
                Amount = (dataGUP[0].deal * dataGUP[0].Rate);
                Rate = (dataGUP[0].ActualRate * dataGUP[0].deal) / (dataGUP[0].deal + dataGUP[0].deal2);
            }
            // Amount = (dataGUP[0].Quantity * dataGUP[0].Rate);


            TaxAmount = Amount * (dataGUP[0].TaxPer / 100);
            //GST Changes
            igstTaxAmt = Amount * (dataGUP[0].IGSTPrecent / 100);
            cgstTaxAmt = Amount * (dataGUP[0].CGSTPercent / 100);
            sgstTaxAmt = Amount * (dataGUP[0].SGSTPercent / 100);
            if (dataGUP[0].DiscPer > 0)
                DiscountAmount = ((Amount * dataGUP[0].DiscPer) / 100);
            else
                DiscountAmount = dataGUP[0].DiscAmt;

            //Special Discount Changes
            if (dataGUP[0].SpecialDiscPer > 0)
                SpecialDiscAmt = (((Amount - DiscountAmount) * dataGUP[0].SpecialDiscPer) / 100);
            else
                SpecialDiscAmt = dataGUP[0].SpecialDiscAmt;

            //NetAmount = (Amount + TaxAmount - DiscountAmount);
            NetAmount = (Amount + TaxAmount - DiscountAmount - SpecialDiscAmt);

            //UnitPrice = (dataGUP[0].Rate - DiscountAmount) + TaxAmount;
            //UnitPrice = dataGUP[0].Rate + ((dataGUP[0].Rate * dataGUP[0].TaxPer) / 100) - ((dataGUP[0].Rate * dataGUP[0].DiscPer) / 100);

            UnitPrice = Rate + ((Rate * dataGUP[0].TaxPer) / 100) - ((Rate * dataGUP[0].DiscPer) / 100) - ((Rate - ((Rate * dataGUP[0].DiscPer) / 100)) * dataGUP[0].SpecialDiscPer / 100);
            MRPValue = (dataGUP[0].MRP * dataGUP[0].Quantity);
        }
        else if (dataGUP[0].Type == "RateAD")
        {
            if (dataGUP[0].deal == 0 && dataGUP[0].deal2 == 0)
            {
                Amount = (dataGUP[0].Quantity * dataGUP[0].Rate);
                Rate = dataGUP[0].Rate;
            }
            else
            {
                Amount = (dataGUP[0].deal * dataGUP[0].Rate);
                Rate = (dataGUP[0].ActualRate * dataGUP[0].deal) / (dataGUP[0].deal + dataGUP[0].deal2);
            }
            if (dataGUP[0].DiscPer > 0)
                DiscountAmount = ((Amount * dataGUP[0].DiscPer) / 100);
            else
                DiscountAmount = dataGUP[0].DiscAmt;
            //Special Discount Changes
            if (dataGUP[0].SpecialDiscPer > 0)
                SpecialDiscAmt = (((Amount - DiscountAmount) * dataGUP[0].SpecialDiscPer) / 100);
            else
                SpecialDiscAmt = dataGUP[0].SpecialDiscAmt;


            TaxAmount = ((Amount - DiscountAmount - SpecialDiscAmt) * dataGUP[0].TaxPer) / 100;
            //GST Changes
            igstTaxAmt = ((Amount - DiscountAmount - SpecialDiscAmt) * dataGUP[0].IGSTPrecent) / 100;
            cgstTaxAmt = ((Amount - DiscountAmount - SpecialDiscAmt) * dataGUP[0].CGSTPercent) / 100;
            sgstTaxAmt = ((Amount - DiscountAmount - SpecialDiscAmt) * dataGUP[0].SGSTPercent) / 100;
            NetAmount = (Amount + TaxAmount - DiscountAmount - SpecialDiscAmt);

            //  UnitPrice = (dataGUP[0].Rate - DiscountAmount) + TaxAmount;

            //UnitPrice = (Rate - ((Rate * dataGUP[0].DiscPer) / 100)) + ((Rate - ((Rate * dataGUP[0].DiscPer) / 100)) * dataGUP[0].TaxPer/100);
            UnitPrice = (Rate - ((Rate * dataGUP[0].DiscPer) / 100)) + ((Rate - ((Rate * dataGUP[0].DiscPer) / 100) - ((Rate - ((Rate * dataGUP[0].DiscPer) / 100)) * dataGUP[0].SpecialDiscPer / 100)) * dataGUP[0].TaxPer / 100) - ((Rate - ((Rate * dataGUP[0].DiscPer) / 100)) * dataGUP[0].SpecialDiscPer / 100);
            MRPValue = (dataGUP[0].MRP * dataGUP[0].Quantity);
        }
        else if (dataGUP[0].Type == "RateRev")
        {
            MRPValue = (dataGUP[0].Rate * dataGUP[0].Quantity);
            Amount = ((dataGUP[0].Rate * dataGUP[0].Quantity) * 100) / (100 + dataGUP[0].TaxPer);
            if (dataGUP[0].DiscPer > 0)
                DiscountAmount = (dataGUP[0].Rate * dataGUP[0].DiscPer) / 100;
            else
                DiscountAmount = dataGUP[0].DiscAmt;

            //Special Discount Changes
            if (dataGUP[0].SpecialDiscPer > 0)
                SpecialDiscAmt = (((Amount - DiscountAmount) * dataGUP[0].SpecialDiscPer) / 100);
            else
                SpecialDiscAmt = dataGUP[0].SpecialDiscAmt;


            TaxAmount = (((dataGUP[0].Rate * dataGUP[0].Quantity * dataGUP[0].TaxPer)) - DiscountAmount - SpecialDiscAmt) / (100 + dataGUP[0].TaxPer);
            //GST Changes
            igstTaxAmt = (((dataGUP[0].Rate * dataGUP[0].Quantity * dataGUP[0].IGSTPrecent)) - DiscountAmount - SpecialDiscAmt) / (100 + dataGUP[0].IGSTPrecent);
            cgstTaxAmt = (((dataGUP[0].Rate * dataGUP[0].Quantity * dataGUP[0].CGSTPercent)) - DiscountAmount - SpecialDiscAmt) / (100 + dataGUP[0].CGSTPercent);
            sgstTaxAmt = (((dataGUP[0].Rate * dataGUP[0].Quantity * dataGUP[0].SGSTPercent)) - DiscountAmount - SpecialDiscAmt) / (100 + dataGUP[0].SGSTPercent);
            NetAmount = ((dataGUP[0].Quantity * dataGUP[0].Rate) + TaxAmount - DiscountAmount - SpecialDiscAmt);

            //UnitPrice = (dataGUP[0].Rate - DiscountAmount) + TaxAmount;
            UnitPrice = (dataGUP[0].Rate - DiscountAmount - SpecialDiscAmt) + ((((dataGUP[0].Rate * dataGUP[0].TaxPer))) / (100 + dataGUP[0].TaxPer));
        }
        else if (dataGUP[0].Type == "RateExcl")
        {
            TaxAmount = (dataGUP[0].Rate * dataGUP[0].TaxPer) / 100;
            //GST Changes
            igstTaxAmt = (dataGUP[0].Rate * dataGUP[0].IGSTPrecent) / 100;
            cgstTaxAmt = (dataGUP[0].Rate * dataGUP[0].CGSTPercent) / 100;
            sgstTaxAmt = (dataGUP[0].Rate * dataGUP[0].SGSTPercent) / 100;
            if (dataGUP[0].DiscPer > 0)
                DiscountAmount = (dataGUP[0].Rate * dataGUP[0].DiscPer) / 100;
            else
                DiscountAmount = dataGUP[0].DiscAmt;
            //Special Discount Changes
            if (dataGUP[0].SpecialDiscPer > 0)
                SpecialDiscAmt = (((Amount - DiscountAmount) * dataGUP[0].SpecialDiscPer) / 100);
            else
                SpecialDiscAmt = dataGUP[0].SpecialDiscAmt;

            Amount = (dataGUP[0].Quantity * dataGUP[0].Rate);
            NetAmount = ((dataGUP[0].Rate * dataGUP[0].Quantity) + TaxAmount - DiscountAmount - SpecialDiscAmt);
            UnitPrice = (dataGUP[0].Rate - DiscountAmount - SpecialDiscAmt) + TaxAmount;
            MRPValue = ((dataGUP[0].MRP * dataGUP[0].Quantity) - (dataGUP[0].DiscPer + dataGUP[0].SpecialDiscPer) / 100);
        }
        else if (dataGUP[0].Type == "MRPExcl")
        {
            TaxAmount = dataGUP[0].MRP - ((dataGUP[0].MRP * 100) / (100 + dataGUP[0].TaxPer));
            //GST Changes
            igstTaxAmt = dataGUP[0].MRP - ((dataGUP[0].MRP * 100) / (100 + dataGUP[0].IGSTPrecent));
            cgstTaxAmt = dataGUP[0].MRP - ((dataGUP[0].MRP * 100) / (100 + dataGUP[0].CGSTPercent));
            sgstTaxAmt = dataGUP[0].MRP - ((dataGUP[0].MRP * 100) / (100 + dataGUP[0].SGSTPercent));
            if (dataGUP[0].DiscPer > 0)
                DiscountAmount = (dataGUP[0].Rate * dataGUP[0].DiscPer) / 100;
            else
                DiscountAmount = dataGUP[0].DiscAmt;

            //Special Discount Changes
            if (dataGUP[0].SpecialDiscPer > 0)
                SpecialDiscAmt = (((Amount - DiscountAmount) * dataGUP[0].SpecialDiscPer) / 100);
            else
                SpecialDiscAmt = dataGUP[0].SpecialDiscAmt;

            Amount = (dataGUP[0].Quantity * dataGUP[0].Rate);
            NetAmount = ((dataGUP[0].Rate * dataGUP[0].Quantity) + TaxAmount - DiscountAmount - SpecialDiscAmt);
            UnitPrice = (dataGUP[0].Rate - DiscountAmount - SpecialDiscAmt) + TaxAmount;
            MRPValue = ((dataGUP[0].MRP * dataGUP[0].Quantity) - (dataGUP[0].DiscPer + dataGUP[0].SpecialDiscPer) / 100);
        }
        else if (dataGUP[0].Type == "ExciseAmt")
        {
            ExcisePer = dataGUP[0].ExcisePer;
            decimal ExciseAmt = ((dataGUP[0].Quantity * dataGUP[0].Rate) - ((dataGUP[0].Quantity * dataGUP[0].Rate) * (dataGUP[0].ExcisePer) / 100));
            if (dataGUP[0].DiscPer > 0)
                DiscountAmount = ((ExciseAmt * dataGUP[0].DiscPer) / 100);
            else
                DiscountAmount = dataGUP[0].DiscAmt;

            //Special Discount Changes
            if (dataGUP[0].SpecialDiscPer > 0)
                SpecialDiscAmt = (((Amount - DiscountAmount) * dataGUP[0].SpecialDiscPer) / 100);
            else
                SpecialDiscAmt = dataGUP[0].SpecialDiscAmt;

            TaxAmount = (((dataGUP[0].Quantity * dataGUP[0].Rate) - DiscountAmount - SpecialDiscAmt) * dataGUP[0].TaxPer) / 100;
            //GST Changes
            igstTaxAmt = (((dataGUP[0].Quantity * dataGUP[0].Rate) - DiscountAmount - SpecialDiscAmt) * dataGUP[0].IGSTPrecent) / 100;
            cgstTaxAmt = (((dataGUP[0].Quantity * dataGUP[0].Rate) - DiscountAmount - SpecialDiscAmt) * dataGUP[0].CGSTPercent) / 100;
            sgstTaxAmt = (((dataGUP[0].Quantity * dataGUP[0].Rate) - DiscountAmount - SpecialDiscAmt) * dataGUP[0].SGSTPercent) / 100;

            NetAmount = ((dataGUP[0].Quantity * dataGUP[0].Rate) - DiscountAmount - SpecialDiscAmt) + TaxAmount;
            decimal PerunitExicise = (dataGUP[0].Rate - (dataGUP[0].Rate * (dataGUP[0].ExcisePer) / 100));
            decimal PerUnitDisc = ((PerunitExicise * dataGUP[0].DiscPer) / 100);
            decimal perUnitSpclDisc = ((PerunitExicise * dataGUP[0].SpecialDiscPer) / 100);
            decimal PerunitTax = ((dataGUP[0].Rate * dataGUP[0].TaxPer) / 100);
            UnitPrice = (PerunitExicise - PerUnitDisc - perUnitSpclDisc) + PerunitTax;
            MRPValue = (dataGUP[0].MRP * dataGUP[0].Quantity);
            Amount = ((dataGUP[0].Quantity * dataGUP[0].Rate) - DiscountAmount - SpecialDiscAmt) + TaxAmount;
            ExciseAmount = Util.GetDecimal((dataGUP[0].Quantity * dataGUP[0].Rate * dataGUP[0].ExcisePer) / 100);
        }

        var taxDetailList = new List<decimal>();
        taxDetailList.Add(Math.Round(Util.GetDecimal(NetAmount), 2));
        taxDetailList.Add(Math.Round(Util.GetDecimal(TaxAmount), 2));
        taxDetailList.Add(Math.Round(Util.GetDecimal(DiscountAmount), 2));
        taxDetailList.Add(Math.Round(Util.GetDecimal(Amount), 2));
        taxDetailList.Add(Math.Round(Util.GetDecimal(UnitPrice), 2));
        taxDetailList.Add(Math.Round(Util.GetDecimal(MRPValue), 2));
        taxDetailList.Add(Math.Round(Util.GetDecimal(ExciseAmount), 2));
        taxDetailList.Add(Math.Round(Util.GetDecimal(ExcisePer), 2));
        //GST Changes
        taxDetailList.Add(Math.Round(Util.GetDecimal(igstTaxAmt), 4, MidpointRounding.AwayFromZero));
        taxDetailList.Add(Math.Round(Util.GetDecimal(cgstTaxAmt), 4, MidpointRounding.AwayFromZero));
        taxDetailList.Add(Math.Round(Util.GetDecimal(sgstTaxAmt), 4, MidpointRounding.AwayFromZero));
        //Special Discount Changes
        taxDetailList.Add(Math.Round(Util.GetDecimal(SpecialDiscAmt), 2));
        return string.Join("#", taxDetailList.ToArray());
    }

    public static void checkStoreRight(RadioButtonList StoreType)
    {
        DataTable dt = StockReports.GetRights(HttpContext.Current.Session["RoleId"].ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            StoreType.Items[0].Enabled = Util.GetBoolean(dt.Rows[0]["IsMedical"]);
            StoreType.Items[1].Enabled = Util.GetBoolean(dt.Rows[0]["IsGeneral"]);
            if (Util.GetBoolean(dt.Rows[0]["IsMedical"]))
                StoreType.Items[0].Selected = true;
            else if (Util.GetBoolean(dt.Rows[0]["IsGeneral"]))
                StoreType.Items[1].Selected = true;
        }
        else
        {
            StoreType.Items[0].Enabled = false;
            StoreType.Items[1].Enabled = false;
        }
    }
    public static DataTable GetDocuementNo(string fromDate, string Todate, string Type, string LedTranNo)
    {
        try
        {
            string strSelect = "";
            if (Type == "Adjustment")
                strSelect = "select LedgerTransactionNo,date_format(Date,'%d-%b-%y')date,NetAmount,Remarks DiscountReason from f_ledgertransaction where TypeOfTnx='StockAdjustment' and TransactionTypeID='8'";
            else
                strSelect = "select LedgerTransactionNo,date_format(Date,'%d-%b-%y')date,NetAmount,Remarks DiscountReason from f_ledgertransaction where TypeOfTnx='StockUpdate'";
            if (fromDate != "")
                strSelect = strSelect + " and date(Date) >='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "'";
            if (Todate != "")
                strSelect = strSelect + " and date(Date) <='" + Util.GetDateTime(Todate).ToString("yyyy-MM-dd") + "'";
            if (LedTranNo != "")
                strSelect = strSelect + " and LedgerTransactionNo='" + LedTranNo + "'";
            return StockReports.GetDataTable(strSelect);

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public static DataTable SearchAdjustmentItem(string LedTranNo)
    {
        try
        {
            string strSelect = "select distinct(LT.LedgerTransactionNo),date_format(EntryDate,'%d-%b-%y')as Date,LT.ItemName,Lt.Quantity as Qty,Lt.Rate as UnitPrice,ST.BatchNumber,date_format(ST.MedExpiryDate,'%d-%b-%y')MedExpiryDate,ST.MRP,LtD.Remarks as Naration from f_ledgertnxdetail Lt inner join f_stock ST on Lt.StockID = ST.StockID inner join f_ledgertransaction LTD on Lt.LedgerTransactionNo=LTD.LedgerTransactionNo where Lt.LedgerTransactionNo='" + LedTranNo + "'";

            return StockReports.GetDataTable(strSelect);

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public static DataTable SearchStockUpdate(string LedTranNo)
    {
        try
        {
            string strSelect = "select LedgerTransactionNo,ItemName,BatchNumber,UnitPrice,MRP,InitialCount as Qty,Naration,date_format(StockDate,'%d-%b-%y')Date,date_format(MedExpiryDate,'%d-%b-%y')MedExpiryDate from f_stock where IsReturn=2 and LedgerTransactionNo='" + LedTranNo + "'";
            return StockReports.GetDataTable(strSelect);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }


    public static TaxCalculationDetails CalculateTax(TaxCalculationOn TaxCalculationOn)
    {
        List<TaxCalculationOn> dataGUP = new List<TaxCalculationOn>();
        dataGUP.Add(TaxCalculationOn);


        decimal TaxAmount = 0; decimal NetAmount = 0; decimal Amount = 0; decimal DiscountAmount = 0; decimal UnitPrice = 0; decimal MRPValue = 0; decimal ExciseAmount = 0;
        decimal ExcisePer = 0; decimal Rate = 0;
        //GST Changes
        decimal igstTaxAmt = 0; decimal cgstTaxAmt = 0; decimal sgstTaxAmt = 0;
        //Special Discount Changes
        decimal SpecialDiscAmt = 0;
        if (dataGUP[0].Type == "MRP")
        {

            Amount = (dataGUP[0].Quantity * dataGUP[0].Rate);
            TaxAmount = (dataGUP[0].MRP * dataGUP[0].Quantity) - (((dataGUP[0].MRP * dataGUP[0].Quantity) * 100) / (100 + dataGUP[0].TaxPer));

            //GST Changes
            igstTaxAmt = (dataGUP[0].MRP * dataGUP[0].Quantity) - (((dataGUP[0].MRP * dataGUP[0].Quantity) * 100) / (100 + dataGUP[0].IGSTPrecent));
            cgstTaxAmt = (dataGUP[0].MRP * dataGUP[0].Quantity) - (((dataGUP[0].MRP * dataGUP[0].Quantity) * 100) / (100 + dataGUP[0].CGSTPercent));
            sgstTaxAmt = (dataGUP[0].MRP * dataGUP[0].Quantity) - (((dataGUP[0].MRP * dataGUP[0].Quantity) * 100) / (100 + dataGUP[0].SGSTPercent));


            if (dataGUP[0].DiscPer > 0)
                DiscountAmount = ((Amount * dataGUP[0].DiscPer) / 100);
            else
                DiscountAmount = dataGUP[0].DiscAmt;
            if (String.IsNullOrEmpty(dataGUP[0].SpecialDiscType) || dataGUP[0].SpecialDiscType.ToUpper().Trim() == "AD")
            {
                //Special Discount Changes
                if (dataGUP[0].SpecialDiscPer > 0)
                    SpecialDiscAmt = (((Amount - DiscountAmount) * dataGUP[0].SpecialDiscPer) / 100);
                else
                    SpecialDiscAmt = dataGUP[0].SpecialDiscAmt;

            }
            else
            {
                //Special Discount Changes
                if (dataGUP[0].SpecialDiscPer > 0)
                    SpecialDiscAmt = ((Amount * dataGUP[0].SpecialDiscPer) / 100);
                else
                    SpecialDiscAmt = dataGUP[0].SpecialDiscAmt;
            }

            //NetAmount = (Amount + TaxAmount - DiscountAmount);

            NetAmount = (Amount + TaxAmount - DiscountAmount - SpecialDiscAmt);

            //UnitPrice = (dataGUP[0].Rate - DiscountAmount) + TaxAmount;
            // UnitPrice = dataGUP[0].Rate + (dataGUP[0].MRP - ((dataGUP[0].MRP * 100) / (100 + dataGUP[0].TaxPer))) - ((dataGUP[0].Rate * dataGUP[0].DiscPer) / 100);
            //MRPValue = (((dataGUP[0].MRP * dataGUP[0].Quantity) - dataGUP[0].DiscPer / 100) * 100) / (100 + dataGUP[0].TaxPer);    

            UnitPrice = dataGUP[0].Rate + (dataGUP[0].MRP - ((dataGUP[0].MRP * 100) / (100 + dataGUP[0].TaxPer))) - ((dataGUP[0].Rate * dataGUP[0].DiscPer) / 100) - ((dataGUP[0].Rate - ((dataGUP[0].Rate * dataGUP[0].DiscPer) / 100)) * dataGUP[0].SpecialDiscPer / 100);
            MRPValue = (((dataGUP[0].MRP * dataGUP[0].Quantity) - (dataGUP[0].DiscPer / 100) - (dataGUP[0].SpecialDiscPer / 100)) * 100) / (100 + dataGUP[0].TaxPer);
        }
        else if (dataGUP[0].Type == "Rate")
        {
            if (dataGUP[0].deal == 0 && dataGUP[0].deal2 == 0)
            {
                Amount = (dataGUP[0].Quantity * dataGUP[0].Rate);
                Rate = dataGUP[0].Rate;
            }
            else
            {
                Amount = (dataGUP[0].deal * dataGUP[0].Rate);
                Rate = (dataGUP[0].ActualRate * dataGUP[0].deal) / (dataGUP[0].deal + dataGUP[0].deal2);
            }
            // Amount = (dataGUP[0].Quantity * dataGUP[0].Rate);


            TaxAmount = Amount * (dataGUP[0].TaxPer / 100);
            //GST Changes
            igstTaxAmt = Amount * (dataGUP[0].IGSTPrecent / 100);
            cgstTaxAmt = Amount * (dataGUP[0].CGSTPercent / 100);
            sgstTaxAmt = Amount * (dataGUP[0].SGSTPercent / 100);

            if (dataGUP[0].DiscPer > 0)
                DiscountAmount = ((Amount * dataGUP[0].DiscPer) / 100);
            else
                DiscountAmount = dataGUP[0].DiscAmt;
            if (String.IsNullOrEmpty(dataGUP[0].SpecialDiscType) || dataGUP[0].SpecialDiscType.ToUpper().Trim() == "AD")
            {


                //Special Discount Changes
                if (dataGUP[0].SpecialDiscPer > 0)
                    SpecialDiscAmt = (((Amount - DiscountAmount) * dataGUP[0].SpecialDiscPer) / 100);
                else
                    SpecialDiscAmt = dataGUP[0].SpecialDiscAmt;

            }
            else
            {
                //Special Discount Changes
                if (dataGUP[0].SpecialDiscPer > 0)
                    SpecialDiscAmt = ((Amount * dataGUP[0].SpecialDiscPer) / 100);
                else
                    SpecialDiscAmt = dataGUP[0].SpecialDiscAmt;


            }

            //NetAmount = (Amount + TaxAmount - DiscountAmount);
            NetAmount = (Amount + TaxAmount - DiscountAmount - SpecialDiscAmt);

            //UnitPrice = (dataGUP[0].Rate - DiscountAmount) + TaxAmount;
            //UnitPrice = dataGUP[0].Rate + ((dataGUP[0].Rate * dataGUP[0].TaxPer) / 100) - ((dataGUP[0].Rate * dataGUP[0].DiscPer) / 100);

            UnitPrice = Rate + ((Rate * dataGUP[0].TaxPer) / 100) - ((Rate * dataGUP[0].DiscPer) / 100) - ((Rate - ((Rate * dataGUP[0].DiscPer) / 100)) * dataGUP[0].SpecialDiscPer / 100);
            MRPValue = (dataGUP[0].MRP * dataGUP[0].Quantity);
        }
        else if (dataGUP[0].Type == "RateAD")
        {
            if (dataGUP[0].deal == 0 && dataGUP[0].deal2 == 0)
            {
                Amount = (dataGUP[0].Quantity * dataGUP[0].Rate);
                Rate = dataGUP[0].Rate;
            }
            else
            {
                Amount = (dataGUP[0].deal * dataGUP[0].Rate);
                Rate = (dataGUP[0].ActualRate * dataGUP[0].deal) / (dataGUP[0].deal + dataGUP[0].deal2);
            }
            if (dataGUP[0].DiscPer > 0)
                DiscountAmount = ((Amount * dataGUP[0].DiscPer) / 100);
            else
                DiscountAmount = dataGUP[0].DiscAmt;
            if (String.IsNullOrEmpty(dataGUP[0].SpecialDiscType) || dataGUP[0].SpecialDiscType.ToUpper().Trim() == "AD")
            {


                //Special Discount Changes
                if (dataGUP[0].SpecialDiscPer > 0)
                    SpecialDiscAmt = (((Amount - DiscountAmount) * dataGUP[0].SpecialDiscPer) / 100);
                else
                    SpecialDiscAmt = dataGUP[0].SpecialDiscAmt;

            }
            else
            {
                //Special Discount Changes
                if (dataGUP[0].SpecialDiscPer > 0)
                    SpecialDiscAmt = ((Amount * dataGUP[0].SpecialDiscPer) / 100);
                else
                    SpecialDiscAmt = dataGUP[0].SpecialDiscAmt;


            }


            TaxAmount = ((Amount - DiscountAmount - SpecialDiscAmt) * dataGUP[0].TaxPer) / 100;
            //GST Changes
            igstTaxAmt = ((Amount - DiscountAmount - SpecialDiscAmt) * dataGUP[0].IGSTPrecent) / 100;
            cgstTaxAmt = ((Amount - DiscountAmount - SpecialDiscAmt) * dataGUP[0].CGSTPercent) / 100;
            sgstTaxAmt = ((Amount - DiscountAmount - SpecialDiscAmt) * dataGUP[0].SGSTPercent) / 100;
            NetAmount = (Amount + TaxAmount - DiscountAmount - SpecialDiscAmt);

            //  UnitPrice = (dataGUP[0].Rate - DiscountAmount) + TaxAmount;

            //UnitPrice = (Rate - ((Rate * dataGUP[0].DiscPer) / 100)) + ((Rate - ((Rate * dataGUP[0].DiscPer) / 100)) * dataGUP[0].TaxPer/100);
            UnitPrice = (Rate - ((Rate * dataGUP[0].DiscPer) / 100)) + ((Rate - ((Rate * dataGUP[0].DiscPer) / 100) - ((Rate - ((Rate * dataGUP[0].DiscPer) / 100)) * dataGUP[0].SpecialDiscPer / 100)) * dataGUP[0].TaxPer / 100) - ((Rate - ((Rate * dataGUP[0].DiscPer) / 100)) * dataGUP[0].SpecialDiscPer / 100);
            MRPValue = (dataGUP[0].MRP * dataGUP[0].Quantity);
        }
        else if (dataGUP[0].Type == "RateRev")
        {
            MRPValue = (dataGUP[0].Rate * dataGUP[0].Quantity);
            Amount = ((dataGUP[0].Rate * dataGUP[0].Quantity) * 100) / (100 + dataGUP[0].TaxPer);

            if (dataGUP[0].DiscPer > 0)
                DiscountAmount = ((Amount * dataGUP[0].DiscPer) / 100);
            else
                DiscountAmount = dataGUP[0].DiscAmt;
            if (String.IsNullOrEmpty(dataGUP[0].SpecialDiscType) || dataGUP[0].SpecialDiscType.ToUpper().Trim() == "AD")
            {


                //Special Discount Changes
                if (dataGUP[0].SpecialDiscPer > 0)
                    SpecialDiscAmt = (((Amount - DiscountAmount) * dataGUP[0].SpecialDiscPer) / 100);
                else
                    SpecialDiscAmt = dataGUP[0].SpecialDiscAmt;

            }
            else
            {
                //Special Discount Changes
                if (dataGUP[0].SpecialDiscPer > 0)
                    SpecialDiscAmt = ((Amount * dataGUP[0].SpecialDiscPer) / 100);
                else
                    SpecialDiscAmt = dataGUP[0].SpecialDiscAmt;

            }


            TaxAmount = (((dataGUP[0].Rate * dataGUP[0].Quantity * dataGUP[0].TaxPer)) - DiscountAmount - SpecialDiscAmt) / (100 + dataGUP[0].TaxPer);
            //GST Changes
            igstTaxAmt = (((dataGUP[0].Rate * dataGUP[0].Quantity * dataGUP[0].IGSTPrecent)) - DiscountAmount - SpecialDiscAmt) / (100 + dataGUP[0].IGSTPrecent);
            cgstTaxAmt = (((dataGUP[0].Rate * dataGUP[0].Quantity * dataGUP[0].CGSTPercent)) - DiscountAmount - SpecialDiscAmt) / (100 + dataGUP[0].CGSTPercent);
            sgstTaxAmt = (((dataGUP[0].Rate * dataGUP[0].Quantity * dataGUP[0].SGSTPercent)) - DiscountAmount - SpecialDiscAmt) / (100 + dataGUP[0].SGSTPercent);
            NetAmount = ((dataGUP[0].Quantity * dataGUP[0].Rate) + TaxAmount - DiscountAmount - SpecialDiscAmt);

            //UnitPrice = (dataGUP[0].Rate - DiscountAmount) + TaxAmount;
            UnitPrice = (dataGUP[0].Rate - DiscountAmount - SpecialDiscAmt) + ((((dataGUP[0].Rate * dataGUP[0].TaxPer))) / (100 + dataGUP[0].TaxPer));
        }
        else if (dataGUP[0].Type == "RateExcl")
        {
            TaxAmount = (dataGUP[0].Rate * dataGUP[0].TaxPer) / 100;
            //GST Changes
            igstTaxAmt = (dataGUP[0].Rate * dataGUP[0].IGSTPrecent) / 100;
            cgstTaxAmt = (dataGUP[0].Rate * dataGUP[0].CGSTPercent) / 100;
            sgstTaxAmt = (dataGUP[0].Rate * dataGUP[0].SGSTPercent) / 100;



            if (dataGUP[0].DiscPer > 0)
                DiscountAmount = ((Amount * dataGUP[0].DiscPer) / 100);
            else
                DiscountAmount = dataGUP[0].DiscAmt;
            if (String.IsNullOrEmpty(dataGUP[0].SpecialDiscType) || dataGUP[0].SpecialDiscType.ToUpper().Trim() == "AD")
            {


                //Special Discount Changes
                if (dataGUP[0].SpecialDiscPer > 0)
                    SpecialDiscAmt = (((Amount - DiscountAmount) * dataGUP[0].SpecialDiscPer) / 100);
                else
                    SpecialDiscAmt = dataGUP[0].SpecialDiscAmt;

            }
            else
            {
                //Special Discount Changes
                if (dataGUP[0].SpecialDiscPer > 0)
                    SpecialDiscAmt = ((Amount * dataGUP[0].SpecialDiscPer) / 100);
                else
                    SpecialDiscAmt = dataGUP[0].SpecialDiscAmt;

            }

            Amount = (dataGUP[0].Quantity * dataGUP[0].Rate);
            NetAmount = ((dataGUP[0].Rate * dataGUP[0].Quantity) + TaxAmount - DiscountAmount - SpecialDiscAmt);
            UnitPrice = (dataGUP[0].Rate - DiscountAmount - SpecialDiscAmt) + TaxAmount;
            MRPValue = ((dataGUP[0].MRP * dataGUP[0].Quantity) - (dataGUP[0].DiscPer + dataGUP[0].SpecialDiscPer) / 100);
        }
        else if (dataGUP[0].Type == "MRPExcl")
        {
            TaxAmount = dataGUP[0].MRP - ((dataGUP[0].MRP * 100) / (100 + dataGUP[0].TaxPer));
            //GST Changes
            igstTaxAmt = dataGUP[0].MRP - ((dataGUP[0].MRP * 100) / (100 + dataGUP[0].IGSTPrecent));
            cgstTaxAmt = dataGUP[0].MRP - ((dataGUP[0].MRP * 100) / (100 + dataGUP[0].CGSTPercent));
            sgstTaxAmt = dataGUP[0].MRP - ((dataGUP[0].MRP * 100) / (100 + dataGUP[0].SGSTPercent));

            if (dataGUP[0].DiscPer > 0)
                DiscountAmount = ((Amount * dataGUP[0].DiscPer) / 100);
            else
                DiscountAmount = dataGUP[0].DiscAmt;
            if (String.IsNullOrEmpty(dataGUP[0].SpecialDiscType) || dataGUP[0].SpecialDiscType.ToUpper().Trim() == "AD")
            {


                //Special Discount Changes
                if (dataGUP[0].SpecialDiscPer > 0)
                    SpecialDiscAmt = (((Amount - DiscountAmount) * dataGUP[0].SpecialDiscPer) / 100);
                else
                    SpecialDiscAmt = dataGUP[0].SpecialDiscAmt;

            }
            else
            {
                //Special Discount Changes
                if (dataGUP[0].SpecialDiscPer > 0)
                    SpecialDiscAmt = ((Amount * dataGUP[0].SpecialDiscPer) / 100);
                else
                    SpecialDiscAmt = dataGUP[0].SpecialDiscAmt;


            }

            Amount = (dataGUP[0].Quantity * dataGUP[0].Rate);
            NetAmount = ((dataGUP[0].Rate * dataGUP[0].Quantity) + TaxAmount - DiscountAmount - SpecialDiscAmt);
            UnitPrice = (dataGUP[0].Rate - DiscountAmount - SpecialDiscAmt) + TaxAmount;
            MRPValue = ((dataGUP[0].MRP * dataGUP[0].Quantity) - (dataGUP[0].DiscPer + dataGUP[0].SpecialDiscPer) / 100);
        }
        else if (dataGUP[0].Type == "ExciseAmt")
        {
            ExcisePer = dataGUP[0].ExcisePer;
            decimal ExciseAmt = ((dataGUP[0].Quantity * dataGUP[0].Rate) - ((dataGUP[0].Quantity * dataGUP[0].Rate) * (dataGUP[0].ExcisePer) / 100));




            if (dataGUP[0].DiscPer > 0)
                DiscountAmount = ((Amount * dataGUP[0].DiscPer) / 100);
            else
                DiscountAmount = dataGUP[0].DiscAmt;
            if (String.IsNullOrEmpty(dataGUP[0].SpecialDiscType) || dataGUP[0].SpecialDiscType.ToUpper().Trim() == "AD")
            {


                //Special Discount Changes
                if (dataGUP[0].SpecialDiscPer > 0)
                    SpecialDiscAmt = (((Amount - DiscountAmount) * dataGUP[0].SpecialDiscPer) / 100);
                else
                    SpecialDiscAmt = dataGUP[0].SpecialDiscAmt;

            }
            else
            {
                //Special Discount Changes
                if (dataGUP[0].SpecialDiscPer > 0)
                    SpecialDiscAmt = ((Amount * dataGUP[0].SpecialDiscPer) / 100);
                else
                    SpecialDiscAmt = dataGUP[0].SpecialDiscAmt;


            }

            TaxAmount = (((dataGUP[0].Quantity * dataGUP[0].Rate) - DiscountAmount - SpecialDiscAmt) * dataGUP[0].TaxPer) / 100;
            //GST Changes
            igstTaxAmt = (((dataGUP[0].Quantity * dataGUP[0].Rate) - DiscountAmount - SpecialDiscAmt) * dataGUP[0].IGSTPrecent) / 100;
            cgstTaxAmt = (((dataGUP[0].Quantity * dataGUP[0].Rate) - DiscountAmount - SpecialDiscAmt) * dataGUP[0].CGSTPercent) / 100;
            sgstTaxAmt = (((dataGUP[0].Quantity * dataGUP[0].Rate) - DiscountAmount - SpecialDiscAmt) * dataGUP[0].SGSTPercent) / 100;

            NetAmount = ((dataGUP[0].Quantity * dataGUP[0].Rate) - DiscountAmount - SpecialDiscAmt) + TaxAmount;
            decimal PerunitExicise = (dataGUP[0].Rate - (dataGUP[0].Rate * (dataGUP[0].ExcisePer) / 100));
            decimal PerUnitDisc = ((PerunitExicise * dataGUP[0].DiscPer) / 100);
            decimal perUnitSpclDisc = ((PerunitExicise * dataGUP[0].SpecialDiscPer) / 100);
            decimal PerunitTax = ((dataGUP[0].Rate * dataGUP[0].TaxPer) / 100);
            UnitPrice = (PerunitExicise - PerUnitDisc - perUnitSpclDisc) + PerunitTax;
            MRPValue = (dataGUP[0].MRP * dataGUP[0].Quantity);
            Amount = ((dataGUP[0].Quantity * dataGUP[0].Rate) - DiscountAmount - SpecialDiscAmt) + TaxAmount;
            ExciseAmount = Util.GetDecimal((dataGUP[0].Quantity * dataGUP[0].Rate * dataGUP[0].ExcisePer) / 100);
        }

        var taxDetailList = new List<decimal>();
        TaxCalculationDetails taxCalculationDetails = new TaxCalculationDetails()
        {
            amount = Math.Round(Util.GetDecimal(Amount), 4),
            netAmount = Math.Round(Util.GetDecimal(NetAmount), 4),
            netAmountWithOutTax = Math.Round(Util.GetDecimal((dataGUP[0].Quantity * dataGUP[0].Rate)), 4),
            taxAmount = Math.Round(Util.GetDecimal(TaxAmount), 4),
            discountAmount = Math.Round(Util.GetDecimal(DiscountAmount), 4),
            discountPercent = Math.Round(Util.GetDecimal(TaxCalculationOn.DiscPer), 4),
            unitPrice = Math.Round(Util.GetDecimal(UnitPrice), 4),
            MRP = Math.Round(Util.GetDecimal(MRPValue), 4),
            exciseAmount = Math.Round(Util.GetDecimal(ExciseAmount), 4),
            excisePercent = Math.Round(Util.GetDecimal(ExcisePer), 4),
            igstTaxAmount = Math.Round(Util.GetDecimal(igstTaxAmt), 4, MidpointRounding.AwayFromZero),
            IGSTPrecent = TaxCalculationOn.IGSTPrecent,
            CGSTPercent = TaxCalculationOn.CGSTPercent,
            SGSTPercent = TaxCalculationOn.SGSTPercent,
            cgstTaxAmount = Math.Round(Util.GetDecimal(cgstTaxAmt), 4, MidpointRounding.AwayFromZero),
            sgstTaxAmount = Math.Round(Util.GetDecimal(sgstTaxAmt), 4, MidpointRounding.AwayFromZero),
            specialDiscountPer = Math.Round(Util.GetDecimal(dataGUP[0].SpecialDiscPer), 4),
            specialDiscountAmount = Math.Round(Util.GetDecimal(SpecialDiscAmt), 4)
        };

        return taxCalculationDetails;
    }
}