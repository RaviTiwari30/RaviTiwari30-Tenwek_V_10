using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Text;
/// <summary>
/// Summary description for LaundryProcess
/// </summary>
public class Laundry
{
    public Laundry()
    {
        //
        // TODO: Add constructor logic here
        //
    }
    public static DataTable LoadDirtyItem(string fromDept, int type)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT lrs.itemID,lrs.StockID,lrs.ItemName,CONCAT(lrs.ID,'#',DATE_FORMAT(lrs.ReturnDate,'%d-%b-%Y'),'#', ");
        if (type == 1)
            sb.Append(" (lrs.ReturnQty-IFNULL(lrs.WashingQty,0)),'#',lrs.Remark,'#',flm.LedgerName)ID ");
        else if (type == 2)
            sb.Append(" (lrs.WashingQty-IFNULL(lrs.DryerQty,0)),'#',lrs.Remark,'#',flm.LedgerName)ID ");
        else if (type == 3)
            sb.Append(" (lrs.DryerQty-IFNULL(lrs.IroningQty,0)),'#',lrs.Remark,'#',flm.LedgerName)ID ");
        sb.Append(" FROM laundry_recieve_stock lrs INNER JOIN f_ledgermaster flm ON lrs.fromDept=flm.LedgerNumber  LEFT JOIN laundry_recieve_stock_detail lrsd ON lrs.ID=lrsd.ProcessID  AND  lrsd.isprocess=" + type + " AND lrsd.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' ");
        sb.Append(" WHERE  lrs.IsComplete=0 AND lrs.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' AND ");
        if (type == 1)
            sb.Append("  (lrs.ReturnQty-IFNULL(lrs.WashingQty,0))>0 ");
        else if (type == 2)
            sb.Append("  (lrs.WashingQty-IFNULL(lrs.DryerQty,0))>0 ");
        else if (type == 3)
            sb.Append("  (lrs.DryerQty-IFNULL(lrs.IroningQty,0))>0 ");
        sb.Append(" AND lrs.DeptLedgerNo='" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "' ");
        if (fromDept != "0")
            sb.Append(" AND lrs.fromDept='" + fromDept + "'");
        sb.Append(" GROUP BY  lrs.ID  Order By lrs.ItemName");
        return StockReports.GetDataTable(sb.ToString());
    }
    public static DataTable addDirtyItem(int ID, int type)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT  lrs.Remark, lrs.ID,lrs.itemID,lrs.StockID,lrs.ItemName,LedgerName,lrs.FromDept,lrs.ReturnQty actualReturnQty ");
        sb.Append("  FROM laundry_recieve_stock lrs INNER JOIN f_ledgermaster flm ON lrs.fromDept=flm.LedgerNumber LEFT JOIN ");
        sb.Append(" laundry_recieve_stock_detail lrsd ON lrs.ID=lrsd.ProcessID   AND  lrsd.isprocess=" + type + " ");
        sb.Append(" WHERE  lrs.ID=" + ID + " AND lrs.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' ");
        sb.Append(" GROUP BY  lrs.ID  Order By lrs.ItemName");
        return StockReports.GetDataTable(sb.ToString());
    }
    public static DataTable loadMachine(int type)
    {
        return StockReports.GetDataTable("SELECT ID,MachineName FROM laundry_machinemaster WHERE IsActive=1 AND MachineTypeID=" + type + " AND CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "'");
    }

}