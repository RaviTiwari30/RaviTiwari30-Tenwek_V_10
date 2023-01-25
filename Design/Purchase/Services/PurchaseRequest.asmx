<%@ WebService Language="C#" Class="PurchaseRequest" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Text;
[WebService(Namespace = "http://tempuri.org/")]

[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]

public class PurchaseRequest : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }

    [WebMethod]
    public string LoadAllItem(string StoreId, string chkNormItems, string DeptLedgerNo, string PreFix)
   {
        DataTable dtItem = new DataTable();
        string ConfigID1 = "";
        if (StoreId.ToString() == "STO00001")
            ConfigID1 = "11";
        else
            ConfigID1 = "28";
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT CONCAT(IFNULL(ItemCode,''),' # ',ItemName)ItemName,Typename,selectindex,itemID ItemID FROM   ");
        sb.Append(" (  ");
        sb.Append("    SELECT IM.ItemID selectindex,IM.itemcode,IM.Typename ItemName,IM.Typename,  CONCAT(IM.ItemID,'#',IM.SubCategoryID,'#',IFNULL(im.MajorUnit,''),'#',  ");
        sb.Append("    IFNULL(spr.CurrentQuantity,0),'#',IFNULL(spr.Minimum,0),'#',IFNULL(spr.Maximum,0),'#',IFNULL(st.Qty,0) )itemID   FROM f_itemmaster IM  ");
        sb.Append("    INNER JOIN f_subcategorymaster SM ON IM.SubCategoryID = SM.SubCategoryID     ");
        sb.Append("    INNER JOIN f_configrelation CR ON SM.CategoryID = CR.CategoryID  ");
        if (chkNormItems.ToString() == "True")
            sb.Append(" INNER JOIN ");
        else
            sb.Append(" LEFT JOIN ");
        sb.Append("     f_setPurchaseRequestQuantity spr ON spr.ItemID=IM.ItemID AND ");
        sb.Append("    spr.DeptLedgerNo='" + DeptLedgerNo.ToString() + "' AND spr.isActive=1   ");
        sb.Append("    AND StoreType='" + StoreId.ToString() + "'  ");
        sb.Append(" LEFT JOIN (SELECT sum(InitialCount-ReleasedCount) ");
        sb.Append(" Qty,ItemID FROM f_stock WHERE IsPost=1 AND (InitialCount-ReleasedCount)>0 AND DeptLedgerNo='" + DeptLedgerNo.ToString() + "' GROUP BY ITemID)st ON st.itemID = im.ItemID ");
        //sb.Append(" LEFT JOIN  f_stock st ON st.ItemID = IM.ItemID AND st.DeptLedgerNo='" +  + "'");
        sb.Append("    WHERE CR.ConfigID = '" + ConfigID1 + "' AND im.IsActive=1  ");
        sb.Append("  GROUP BY im.ItemID )t ");
        sb.Append(" ORDER BY ItemName ");
        dtItem = StockReports.GetDataTable(sb.ToString());
        if (dtItem.Rows.Count > 0)
        {
            var dt = dtItem;
            DataView DvInvestigation = dt.AsDataView();
            string filter = string.Empty;
            if (!string.IsNullOrEmpty(PreFix))
            {
                filter = "Typename LIKE '%" + PreFix + "%'";
                DvInvestigation.RowFilter = filter;
            }
            return Newtonsoft.Json.JsonConvert.SerializeObject(DvInvestigation.ToTable());
        }
        else
        {
            return "No Item Found";
        }
    }
}