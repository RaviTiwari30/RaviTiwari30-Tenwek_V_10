<%@ WebService Language="C#" Class="centrewise_markup" %>
using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using Newtonsoft.Json;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Linq;

// <summary>
/// Summary description for centrewise_markup
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class centrewise_markup : System.Web.Services.WebService
{

    [WebMethod]
    public string BindCentre()
    {
        DataTable dt = All_LoadData.dtbind_Center();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public string BindGridItems(string CategoryID, string SubCategoryID, string ItemName, string IsSet, string CentreID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT " + CentreID + " as CentreID, im.ItemID,sc.SubCategoryID,sc.CategoryID,im.TypeName,sc.Name AS SubCategoryName,cm.Name AS CategoryName,ROUND(IFNULL(cwm.FromRate,0),4)FromRate,ROUND(IFNULL(cwm.ToRate,0),4)ToRate,ROUND(IFNULL(cwm.MarkUpPercentage,0),4)MarkUpPercentage FROM f_itemmaster im INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=im.SubCategoryID INNER JOIN f_categorymaster cm ON sc.CategoryID=cm.CategoryID LEFT JOIN f_centrewise_markup cwm ON IM.ItemID=cwm.ItemID AND cwm.IsActive=1 AND cwm.CentreID=" + CentreID + "  WHERE im.IsActive=1  ");
    
        if (SubCategoryID != "0")
            sb.Append(" and im.SubCategoryID='" + SubCategoryID + "' ");
        if (CategoryID != "0")
            sb.Append(" and sc.CategoryID='" + CategoryID + "' ");
        if (ItemName != "")
            sb.Append(" and im.TypeName like '" + ItemName + "%' ");

        if (IsSet == "1")
            sb.Append(" AND cwm.ID IS NOT NULL ");
        else if (IsSet == "0")
            sb.Append(" AND cwm.ID IS NULL ");

        sb.Append(" ORDER BY cm.Name,sc.Name,im.TypeName ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public string saveMarkup(System.Collections.Generic.List<centrewise_markups> ItemList , int IsSet)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            if (ItemList.Count <= 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Please Select Atleast One Item" });
            
            if (Util.GetString(ItemList[0].SubCategoryID) == "0")
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Please Select Sub Category" });


            if (IsSet > 0)
            {
                excuteCMD.DML(tnx, " Update f_centrewise_markup set IsActive=0,UpdatedBy=@EntryBy,UpdatedDateTime=NOW() WHERE SubCategoryID=@subCategoryID AND IFNULL(ItemID,'')<>'' AND IsActive=1 and CentreID=@centerID  ", CommandType.Text, new
                {
                    EntryBy = HttpContext.Current.Session["ID"].ToString(),
                    subCategoryID = Util.GetString(ItemList[0].SubCategoryID),
                    centerID = Util.GetInt(ItemList[0].CentreID)
                });
            }

            ItemList = ItemList.Where(i => Util.GetInt(i.MarkUpPercentage) > 0).ToList();
            for (int i = 0; i < ItemList.Count; i++)
            {
                StringBuilder sb = new StringBuilder();
                var item = ItemList[i];
                item.EntryBy = HttpContext.Current.Session["ID"].ToString();

                var sqlCmd = new StringBuilder(" INSERT INTO f_centrewise_markup(CategoryID,SubCategoryID,ItemID,FromRate,ToRate,MarkUpPercentage,IsActive,CreatedBy,CreatedDatetme,CentreID ) ");
                sqlCmd.Append(" VALUES (@CategoryID,@SubCategoryID,@ItemID,0,0,@MarkUpPercentage,1,@EntryBy,NOW(),@CentreID ) ");
                excuteCMD.DML(tnx, sqlCmd.ToString(), CommandType.Text, item);
            }
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Save Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error Occured. Please contact to Administrator", message = ex.Message });

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public class centrewise_markups
    {
        public string ItemID { get; set; }
        public string SubCategoryID { get; set; }
        public string CategoryID { get; set; }
        public string TypeName { get; set; }
        public string SubCategoryName { get; set; }
        public string CategoryName { get; set; }
        public string FromRate { get; set; }
        public string ToRate { get; set; }
        public string MarkUpPercentage { get; set; }
        public string EntryBy { get; set; }
        public string CentreID { get; set; }
    }

}
