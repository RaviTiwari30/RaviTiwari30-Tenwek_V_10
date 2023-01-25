using System;
using System.Data;
using System.Text;
using System.Web;

/// <summary>
/// Summary description for StockStatusReport
/// </summary>
public class StockStatusReport
{
    public StockStatusReport()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public DataTable Bind_DDlManufacture(string ItemID, string MacID, string IsAllItems)
    {
        string str = "";
        ItemID = ItemID.TrimEnd('#').Replace("#", ",");
        if (IsAllItems == "0")
        {
            str = "select DISTINCT(mm.Name),im.ManufactureID from f_itemmaster im inner join f_manufacture_master mm on im.ManufactureID=mm.ManufactureID and im.ItemGroupId In(" + ItemID + ") ";
            if (MacID.ToUpper() != "ALL")
                str += " and im.MacID='" + MacID + "'";
            str += "order by mm.Name";
        }
        else
        {
            str = "select DISTINCT(Name),ManufactureID from f_manufacture_master order by Name";
        }
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);
        return dt;
    }

    public DataTable Bind_DDLMachine(string ItemID, string IsAllItems)
    {
        string str = "";
        ItemID = ItemID.TrimEnd('#').Replace("#", ",");
        if (IsAllItems == "0")
        {
            str = "select DISTINCT(mac.Name),im.MacID from f_itemmaster im inner join macmaster mac on im.MacID=mac.ID and im.ItemGroupId In(" + ItemID + ")  order by mac.Name";
        }
        else
        {
            str = "select  DISTINCT(Name),ID as MacID from macmaster order by Name";
        }
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);
        return dt;
    }

    public DataTable Bind_DDLPacking(string ItemID, string ManufactureID, string IsAllItems)
    {
        string str = "";
        ItemID = ItemID.TrimEnd('#').Replace("#", ",");
        if (IsAllItems == "0")
        {
            str = "select DISTINCT(im.MinorPack) from f_itemmaster im where im.ItemGroupId In(" + ItemID + ")";
            if (ManufactureID.ToUpper() != "ALL")
                str += " and im.ManufactureID='" + ManufactureID + "'";

            str += " order by im.MinorPack";
        }
        else
        {
            str = "select DISTINCT(Packing) from f_itemmaster order by Packing";
        }
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);
        return dt;
    }

    public string GetReport(string StarStore, string OrganStore, string JantaStore, string ItemID,
    string Centers, string Department, string MacID, string ManufactureID,
    string Packing, string IsAllItems, string SubCategoryID)
    {
        if (ItemID != "ALL#")
        {
            ItemID = ItemID.TrimEnd('#').Replace("#", "','");
            ItemID = "'" + ItemID + "'";
        }
        if (Department != "ALL")
        {
            Department = Department.TrimEnd('#').Replace("#", "','");
            Department = "'" + Department + "'";
        }

        Centers = Centers.TrimEnd('#').Replace("#", ",");

        StringBuilder sb = new StringBuilder();
        StringBuilder sb2 = new StringBuilder();
        sb2.Append(" SELECT  REPLACE(im.itemID,'LSHHI','')ItemID,im.TypeName ItemName,sc.Name Subcategory,im.MinorPack,im.MinorUnit,mnu.Name Manufacture, mm.NAME Machine, ");
        sb2.Append(" SUM(s.InitialCount-s.ReleasedCount)Quantity,s.UnitPrice,s.MedExpiryDate,SUM(s.UnitPrice*(s.InitialCount-s.ReleasedCount)) Amount, s.`BatchNumber`, ");
        sb2.Append(" IFNULL((SELECT IFNULL(sd.SoldUnits,0) AS LastIssueQty FROM f_salesdetails sd  WHERE sd.TrasactionTypeID=1 AND itemid=s.itemid ORDER BY CONCAT(sd.date,' ',sd.time) DESC LIMIT 1 ),0)LastIssueQty, ");
        sb2.Append(" IFNULL((SELECT IFNULL(DATE_FORMAT(sd.Date,'%d-%b-%y'),'')LastIssueDate FROM f_salesdetails sd  WHERE sd.TrasactionTypeID=1 AND itemid=s.itemid ORDER BY CONCAT(sd.date,' ',sd.time) DESC LIMIT 1 ),0)LastIssueDate ");
        sb2.Append(" FROM f_stock s  ");
        sb2.Append(" INNER JOIN f_itemmaster im ON s.ItemID=im.ItemID  ");
        sb2.Append(" AND (s.InitialCount-s.ReleasedCount)>0 AND im.IsActive=1 AND s.IsPost=1 ");

        if (ItemID != "ALL#")
            sb2.Append(" AND im.ItemGroupID IN (" + ItemID + ") ");
        if (MacID != "ALL")
            sb2.Append(" AND im.MacID='" + MacID + "' ");
        if (ManufactureID != "ALL")
            sb2.Append(" AND im.ManufactureID='" + ManufactureID + "' ");
        if (Packing != "ALL")
            sb2.Append(" AND im.Packing='" + Packing + "' ");
        if (ItemID == "ALL#" && SubCategoryID.ToUpper() != "ALL")
        {
            sb2.Append(" AND im.SubCategoryID='" + SubCategoryID + "' ");
        }
        if (Department != "ALL")
            sb2.Append(" AND s.DeptLedgerNo IN (" + Department + ") ");

        sb2.Append("  INNER JOIN f_manufacture_master mnu ON mnu.ManufactureID=im.ManufactureID   ");
        sb2.Append("  INNER JOIN macmaster mm ON mm.ID=im.MacID  ");
        sb2.Append("  INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=im.SubCategoryID ");
        sb2.Append("  GROUP BY im.ItemID,s.BatchNumber,s.MedExpiryDate ");

        sb2.Append(" UNION ALL  ");

        sb2.Append(" SELECT  REPLACE(im.itemID,'LSHHI','')ItemID,im.TypeName ItemName,sc.Name Subcategory,im.MinorPack,im.MinorUnit,mnu.Name Manufacture,mm.NAME Machine, ");
        sb2.Append(" SUM(s.InitialCount-s.ReleasedCount)Quantity,s.UnitPrice,s.MedExpiryDate,SUM(s.UnitPrice*(s.InitialCount-s.ReleasedCount)) Amount, s.`BatchNumber`, ");

        sb2.Append(" IFNULL((SELECT IFNULL(sd.SoldUnits,0) AS LastIssueQty FROM f_salesdetails sd  WHERE sd.TrasactionTypeID=1 AND itemid=s.itemid ORDER BY CONCAT(sd.date,' ',sd.time) DESC LIMIT 1 ),0)LastIssueQty, ");
        sb2.Append(" IFNULL((SELECT IFNULL(DATE_FORMAT(sd.Date,'%d-%b-%y'),'')LastIssueDate FROM f_salesdetails sd  WHERE sd.TrasactionTypeID=1 AND itemid=s.itemid ORDER BY CONCAT(sd.date,' ',sd.time) DESC LIMIT 1 ),0)LastIssueDate ");

        sb2.Append(" FROM f_stock s  ");
        sb2.Append(" INNER JOIN f_itemmaster im ON s.ItemID=im.ItemID  ");
        sb2.Append(" AND im.IsActive=1 AND s.IsPost=1 ");

        if (ItemID != "ALL#")
            sb2.Append(" AND im.ItemGroupID IN (" + ItemID + ") ");
        if (MacID != "ALL")
            sb2.Append(" AND im.MacID='" + MacID + "' ");
        if (ManufactureID != "ALL")
            sb2.Append(" AND im.ManufactureID='" + ManufactureID + "' ");
        if (Packing != "ALL")
            sb2.Append(" AND im.Packing='" + Packing + "' ");
        if (ItemID == "ALL#" && SubCategoryID.ToUpper() != "ALL")
        {
            sb2.Append(" AND im.SubCategoryID='" + SubCategoryID + "' ");
        }
        if (Department != "ALL")
            sb2.Append(" AND s.DeptLedgerNo IN (" + Department + ") ");

        sb2.Append("  INNER JOIN f_manufacture_master mnu ON mnu.ManufactureID=im.ManufactureID   ");
        sb2.Append("  INNER JOIN macmaster mm ON mm.ID=im.MacID  ");
        sb2.Append("  INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=im.SubCategoryID ");
        sb2.Append("  GROUP BY im.ItemID HAVING SUM(s.InitialCount-s.ReleasedCount)<=0 ");

        sb2.Append("  ORDER BY ItemName  ");

        try
        {
            if (sb2.ToString() != "")
            {
                DataTable dt = StockReports.GetDataTable(sb2.ToString());
                DataColumn dc = new DataColumn();
                dc.ColumnName = "RoleID";
                dc.DefaultValue = HttpContext.Current.Session["RoleID"].ToString();
                dt.Columns.Add(dc);

                HttpContext.Current.Session["CURRENT_STOCK"] = dt;
                return "1";
            }
            return "0";
        }
        catch (Exception Ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(Ex);
            return "0";
        }
    }

    public DataTable Bind_ListBox(string SubCategoryID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ig.ItemGroupID,ig.ItemGroupName FROM f_itemgroup ig  ");
        sb.Append(" INNER JOIN f_itemmaster im ON im.ItemGroupId=ig.ItemGroupID ");
        sb.Append(" WHERE ig.IsActive='1' ");
        if (SubCategoryID.ToUpper() != "ALL")
        {
            sb.Append(" AND im.SubCategoryID='" + SubCategoryID + "'  ");
        }
        sb.Append(" GROUP BY ig.ItemGroupID ORDER BY ItemGroupName ");

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }

    public DataTable Bind_ListAmtInfo(string ItemID, string VendorID, string DeptLedgerNo)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT sir.ItemID,sir.GrossAmt Rate,sir.DiscAmt,sir.TaxAmt,IFNULL(ROUND((sir.DiscAmt*100)/sir.GrossAmt,4),'')DiscPer,sir.NetAmt,lm.LedgerName VendorName, ");
        sb.Append(" IFNULL(im.ManuFacturer,'')ManuFacturer,IFNULL(im.ManufactureID,'')ManufactureID,sir.IsActive, ");
        sb.Append(" (SELECT SUM(sit.Taxper) FROM f_storeitem_tax sit WHERE sit.ItemID = sir.ItemID AND sit.StoreRateID = sir.ID) TaxPer, ");
        sb.Append(" (SELECT GROUP_CONCAT(CONCAT(CAST(sit.TaxID AS CHAR), '|', CAST(sit.Taxper AS CHAR)) SEPARATOR '#') FROM f_storeitem_tax sit WHERE sit.ItemID = sir.ItemID AND sit.StoreRateID = sir.ID ) TaxID, ");
        sb.Append(" IF(IFNULL(fid.ConversionFactor,'')='',IFNULL(im.ConversionFactor,1),fid.ConversionFactor)ConFactor,IF(IFNULL(fid.MajorUnit,'')='',im.MajorUnit,fid.MajorUnit)MajorUnit,IF(IFNULL(fid.MinorUnit,'')='',im.MinorUnit,fid.MinorUnit)MinorUnit, ");
        //sb.Append(" IFNULL((SELECT ROUND(TaxPer,2) FROM f_storeitem_tax sit WHERE sit.ItemID = sir.ItemID ");
        //sb.Append(" AND sit.StoreRateID = sir.ID AND sit.TaxID='T2'),0) ExcisePer, ");
        //sb.Append(" IFNULL((SELECT ROUND(TaxAmt,2) FROM f_storeitem_tax sit WHERE sit.ItemID = sir.ItemID  ");
        //sb.Append(" AND sit.StoreRateID = sir.ID AND sit.TaxID='T2'),0) ExciseAmt,  ");
        //sb.Append(" IFNULL((SELECT ROUND(TaxPer,2) FROM f_storeitem_tax sit WHERE sit.ItemID = sir.ItemID  ");
        //sb.Append(" AND sit.StoreRateID = sir.ID AND sit.TaxID='T3'),0) VATPer,  ");
        //sb.Append(" IFNULL((SELECT ROUND(TaxAmt,2) FROM f_storeitem_tax sit WHERE sit.ItemID = sir.ItemID  ");
        //sb.Append(" AND sit.StoreRateID = sir.ID AND sit.TaxID='T3'),0) VATAmt,sir.TaxCalulatedOn ");

        // GST Changes
        sb.Append(" IFNULL((SELECT ROUND(TaxPer,2) FROM f_storeitem_tax sit WHERE sit.ItemID = sir.ItemID   ");
        sb.Append(" AND sit.StoreRateID = sir.ID),0) GSTPer,   ");
        sb.Append(" IFNULL((SELECT ROUND(TaxAmt,2) FROM f_storeitem_tax sit WHERE sit.ItemID = sir.ItemID   ");
        sb.Append(" AND sit.StoreRateID = sir.ID),0) GSTAmt,sir.TaxCalulatedOn,IFNULL(sir.GSTType,'')GSTType,IFNULL(sir.HSNCode,'')HSNCode,sir.IGSTPercent,sir.CGSTPercent,sir.SGSTPercent,IFNULL(sir.`IsDeal`,'') 'Deal' ");
        //---

        sb.Append(" FROM f_storeitem_rate sir  ");
        sb.Append(" INNER JOIN f_itemmaster im ON im.ItemID=sir.ItemID ");
        sb.Append(" INNER JOIN f_ledgermaster lm ON lm.LedgerNumber=sir.Vendor_ID  ");
        sb.Append(" LEFT JOIN f_itemmaster_deptWise fid ON fid.itemID=im.itemID AND fid.DeptLedgerNo='" + DeptLedgerNo + "' ");

        sb.Append(" WHERE sir.ItemID='" + ItemID + "' AND sir.Vendor_ID='" + VendorID + "' AND sir.DeptLedgerNo='" + DeptLedgerNo + "' AND sir.IsActive=1 AND im.IsActive GROUP BY sir.ID ");

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }

    public DataTable Bind_ListAmtInfo_ItemWise(string ItemID, string DeptLedgerNo)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT sir.ItemID,sir.Vendor_ID,sir.GrossAmt Rate,sir.DiscAmt,sir.TaxAmt,IFNULL(ROUND((sir.DiscAmt*100)/sir.GrossAmt,4),'')DiscPer,sir.NetAmt,lm.LedgerName VendorName, ");
        sb.Append(" IFNULL(im.ManuFacturer,'')ManuFacturer,IFNULL(im.ManufactureID,'')ManufactureID, sir.IsActive, ");
        sb.Append(" IF(IFNULL(fid.ConversionFactor,'')='',IFNULL(im.ConversionFactor,1),fid.ConversionFactor)ConFactor,IF(IFNULL(fid.MajorUnit,'')='',im.MajorUnit,fid.MajorUnit)MajorUnit,IF(IFNULL(fid.MinorUnit,'')='',im.MinorUnit,fid.MinorUnit)MinorUnit, ");
        sb.Append(" (SELECT SUM(sit.Taxper) FROM f_storeitem_tax sit WHERE sit.ItemID = sir.ItemID AND sit.StoreRateID = sir.ID) TaxPer, ");
        sb.Append(" (SELECT GROUP_CONCAT(CONCAT(CAST(sit.TaxID AS CHAR), '|', CAST(sit.Taxper AS CHAR)) SEPARATOR '#') FROM f_storeitem_tax sit WHERE sit.ItemID = sir.ItemID AND sit.StoreRateID = sir.ID) TaxID , ");
        //sb.Append(" IFNULL((SELECT ROUND(TaxPer,2) FROM f_storeitem_tax sit WHERE sit.ItemID = sir.ItemID ");
        //sb.Append(" AND sit.StoreRateID = sir.ID AND sit.TaxID='T2'),0) ExcisePer, ");
        //sb.Append(" IFNULL((SELECT ROUND(TaxAmt,2) FROM f_storeitem_tax sit WHERE sit.ItemID = sir.ItemID  ");
        //sb.Append(" AND sit.StoreRateID = sir.ID AND sit.TaxID='T2'),0) ExciseAmt,  ");
        //sb.Append(" IFNULL((SELECT ROUND(TaxPer,2) FROM f_storeitem_tax sit WHERE sit.ItemID = sir.ItemID  ");
        //sb.Append(" AND sit.StoreRateID = sir.ID AND sit.TaxID='T3'),0) VATPer,  ");
        //sb.Append(" IFNULL((SELECT ROUND(TaxAmt,2) FROM f_storeitem_tax sit WHERE sit.ItemID = sir.ItemID  ");
        //sb.Append(" AND sit.StoreRateID = sir.ID AND sit.TaxID='T3'),0) VATAmt,sir.TaxCalulatedOn ");

        // GST Changes
        sb.Append(" IFNULL((SELECT ROUND(TaxPer,2) FROM f_storeitem_tax sit WHERE sit.ItemID = sir.ItemID   ");
        sb.Append(" AND sit.StoreRateID = sir.ID),0) GSTPer,   ");
        sb.Append(" IFNULL((SELECT ROUND(TaxAmt,2) FROM f_storeitem_tax sit WHERE sit.ItemID = sir.ItemID   ");
        sb.Append(" AND sit.StoreRateID = sir.ID),0) GSTAmt,sir.TaxCalulatedOn,IFNULL(sir.GSTType,'')GSTType,IFNULL(sir.HSNCode,'')HSNCode,sir.IGSTPercent,sir.CGSTPercent,sir.SGSTPercent,IFNULL(sir.`IsDeal`,'') 'Deal' ");
        //---

        sb.Append(" FROM f_storeitem_rate sir  ");
        sb.Append(" INNER JOIN f_itemmaster im ON im.ItemID=sir.ItemID ");
        sb.Append(" INNER JOIN f_ledgermaster lm ON lm.LedgerNumber=sir.Vendor_ID  ");
        sb.Append(" LEFT JOIN f_itemmaster_deptWise fid ON fid.itemID=im.itemID AND fid.DeptLedgerNo='" + DeptLedgerNo + "' ");
        sb.Append(" WHERE sir.ItemID='" + ItemID + "' AND sir.DeptLedgerNo='" + DeptLedgerNo + "' AND sir.IsActive=1 AND im.IsActive GROUP BY sir.ID ");

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }

    public DataTable Bind_LastPurchaseInfo(string ItemID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT IFNULL(st.Rate,0)LastPurchaseRate,IFNULL(DATE_FORMAT(st.PostDate,'%d-%b-%y'),'Not Avail')LastPurchaseDate,IFNULL(DATE_FORMAT(st.MedExpiryDate,'%d-%b-%y'),'')LastPurchaseExpiry,IFNULL(im.MajorUnit,st.MajorUnit)MajorUnit  FROM f_stock st INNER JOIN f_itemmaster im  ON im.ItemID= st.ItemID WHERE st.ItemID='" + ItemID + "' AND st.LedgerTransactionNo<>''  ORDER BY st.ID DESC  LIMIT 1  ");

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }
}