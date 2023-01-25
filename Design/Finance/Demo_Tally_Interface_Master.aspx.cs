using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;
using Oracle.ManagedDataAccess.Client;


public partial class Design_EDP_Demo_Tally_Interface_Master : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
       // BindCOstCenters();

      //  BindRevenueCentre();
    }
    [WebMethod]
    public static string RevenueInsert(string RevenueCentre, string Description, string CostCentreID)
    {
        if (RevenueCentre != "")
        {
            try
            {
                int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM demo_RevenueMaster WHERE Name='" + RevenueCentre + "' "));
                if (count > 0)
                    return "1";
                else
                {
                    string RID = Util.GetString(StockReports.ExecuteScalar("Select ifnull(Max(RID),0)+1 from demo_RevenueMaster"));
                    StockReports.ExecuteDML("INSERT INTO demo_RevenueMaster (ID,Name,Description,CreatedBY,Isactive,CostCentreID) VALUES('" + RID + "','" + RevenueCentre + "','" + Description + "','" + HttpContext.Current.Session["ID"].ToString() + "','1','" + CostCentreID + "')");
                    return "2";
                }
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return "";
            }
        }
        else
            return "3";
    }

    public static void BindRevenueCentre()
    {
      //  string sql = "select coa_nm, coa_id from fin.fin$coa a inner join fin.fin$cog b on (a.coa_ho_org_id = b.cog_org_id and a.coa_cog_id = b.cog_id) where coa_ho_org_id = '01'and b.cog_grp_type = 'I'and b.cog_grp_sub_typ = 'D' ";
        string sql = "SELECT coa_nm, coa_id FROM fin.fin$coa a INNER JOIN fin.fin$cog b ON (a.coa_ho_org_id   = b.cog_org_id AND a.coa_cog_id      = b.cog_id) WHERE coa_ho_org_id   = '01' AND b.cog_grp_type    = 'I' AND b.cog_grp_sub_typ = 'D' union SELECT coa_nm,coa_id FROM fin.fin$coa a INNER JOIN fin.fin$cog b ON (a.coa_ho_org_id   = b.cog_org_id AND a.coa_cog_id      = b.cog_id) WHERE coa_ho_org_id   = '01' AND b.cog_grp_type    = 'L' ";
        
        DataTable dt = EbizFrame.GetDataTable(sql);
        if (dt.Rows.Count > 0)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                RevenueInsert(dt.Rows[i]["coa_nm"].ToString(), "", dt.Rows[i]["coa_id"].ToString());
            }
        }
    }
    public static void BindCOstCenters()
    {
        string sql = "SELECT POS_ID, COL_ID, COL_VALUE from APP.APP$CC;";
        DataTable dt = EbizFrame.GetDataTable(sql);
        if (dt.Rows.Count > 0)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                CostCentreInsert(dt.Rows[i]["COL_VALUE"].ToString(), dt.Rows[i]["COL_ID"].ToString());
            }
        }
    }
    [WebMethod]
    public static string bindRevenueName(string CoseCentre)
    {
        DataTable dtRevenue = StockReports.GetDataTable(" SELECT ID as RevenueID,NAME as RevenueName FROM demo_RevenueMaster where CostCentreID='" + CoseCentre + "' order by Name ");
        if (dtRevenue.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtRevenue);
        }
        else
        {
            return "";
        }
    }
    [WebMethod]
    public static string bindActiveRevenue(string CoseCentre)
    {
        DataTable dtRevenue = StockReports.GetDataTable("SELECT c.COA_ID AS RevenueID,c.COA_Name AS RevenueName FROM finance.coa$MASTER c WHERE c.COA_Type=2");
        if (dtRevenue.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtRevenue);
        }
        else
        {
            return "";
        }
    }
    [WebMethod]
    public static string bindCategory()
    {
        DataTable dtCategory = StockReports.GetDataTable("SELECT CategoryID,NAME FROM f_categorymaster ORDER BY NAME ");
        if (dtCategory.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtCategory);
        }
        else
        {
            return "";
        }
    }
    [WebMethod]
    public static string bindSubCategory(string CategoryID)
    {
        DataTable dtSubCategory = StockReports.GetDataTable("SELECT SubCategoryID,NAME  FROM f_subcategorymaster WHERE  CategoryID='" + CategoryID + "' AND active=1 ORDER BY NAME ");
        if (dtSubCategory.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtSubCategory);
        }
        else
        {
            return "";
        }
    }
    [WebMethod]
    public static string RevenueUpdate(string RevenueCentre, string Description, string Active, string OldName, string CostCentreID)
    {
        try
        {
            int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM demo_RevenueMaster WHERE Name='" + RevenueCentre + "' "));
            if (count > 0)
                return "1";
            else
                StockReports.ExecuteDML("update demo_RevenueMaster set Name='" + RevenueCentre + "',Description='" + Description + "',UpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdateDate='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',Isactive='" + Active + "' where ID='" + OldName + "' and  CostCentreID='" + CostCentreID + "' ");
            StockReports.ExecuteDML("update demo_His_Mapping_Master set RevenueName='" + RevenueCentre + "',Isactive='" + Active + "' where RevenueID='" + OldName + "' and  CostCentreID='" + CostCentreID + "' ");
            return "2";

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
    }
    [WebMethod]
    public static string BindNonMapItem(string SubCategory)
    {
        if (SubCategory.Trim() != "" )
        {
            DataTable dtItem = StockReports.GetDataTable(" SELECT ItemID,TypeName FROM f_itemmaster im LEFT JOIN  demo_His_Mapping_Master tmm ON im.itemID =tmm.HIS_ItemID WHERE  IF(tmm.HIS_ItemID IS NULL,tmm.HIS_ItemID IS NULL,tmm.IsActive='0')  and im.subCategoryID='" + SubCategory + "' order by TypeName ");
            if (dtItem.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dtItem);
            }
            else
            {
                return "";
            }
        }
        else { return ""; }

    }
    [WebMethod]
    public static string BindMaping(string RevenueName)
    {
        DataTable dtMapItem = StockReports.GetDataTable("SELECT im.TypeName,Concat(im.itemID,'#',tmm.His_SubCategoryID,'#',tmm.HIS_CategoryID)itemID FROM f_itemmaster im INNER JOIN demo_His_Mapping_Master tmm ON tmm.HIS_itemID= im.itemID Where tmm.RevenueID='" + RevenueName + "' and tmm.isActive='1' order by im.TypeName ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtMapItem);
    }
    [WebMethod]
    public static string InserMapping(List<MapItem> Data)
    {
        int len = Data.Count;
        if (len > 0)
        {

            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction();
            try
            {



                DataView CategoryView = LoadCacheQuery.loadCategory().AsDataView();
                CategoryView.RowFilter = "  ConfigID in(7,11,28) ";
                //List<string> storeItemCategories = CategoryView.ToTable().AsEnumerable().Select(r => r.Field<string>("CategoryID")).ToList();

                List<int> storeItemCategories = CategoryView.ToTable().AsEnumerable().Select(r => r.Field<int>("CategoryID")).ToList();






                for (int i = 0; i < Data.Count; i++)
                {
                    int Count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM demo_His_Mapping_Master where HIS_ItemID='" + Data[i].ItemID + "' "));
                    if (Count == 0)
                    {
                        string str = "Insert into demo_His_Mapping_Master(RevenueID,HIS_ItemID,HIS_SubCategoryID,HIS_CategoryID,CreatedBy,RevenueName,CostCentreName,CostCentreID) " +
                               " values('" + Data[i].RevenueID + "','" + Data[i].ItemID + "','" + Data[0].SubCategoryID + "','" + Data[0].CategoryID + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + Data[i].RevenueName + "','" + Data[i].CostCentreName + "','" + Data[i].CostCentreID + "')";
                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str);

                        if (Resources.Resource.IsGSTApplicable == "0")
                        {
                            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE f_itemmaster im SET im.IsActive=1 WHERE im.IsActive=3 AND im.ItemID='" + Data[i].ItemID + "'  ");//
                        }
                        else
                        {
                            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE f_itemmaster im SET im.IsActive=1 WHERE im.ItemID='" + Data[i].ItemID + "'  ");
                        }
                    }
                    else
                    {
                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE demo_His_Mapping_Master SET IsActive=1,RevenueID='" + Data[i].RevenueID + "',HIS_SubCategoryID='" + Data[0].SubCategoryID + "',HIS_CategoryID='" + Data[0].CategoryID + "',RevenueName='" + Data[i].RevenueName + "',CostCentreName='" + Data[i].CostCentreName + "',CostCentreID='" + Data[i].CostCentreID + "' WHERE HIS_ItemID='" + Data[i].ItemID + "'  ");
                    }
                }
                tranX.Commit();
                return "1";
            }
            catch (Exception ex)
            {
                tranX.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return "0";
            }
            finally
            {
                tranX.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        else
        {
            return "0";
        }
    }
    public class MapItem
    {
        public string ItemID { get; set; }
        public string CategoryID { get; set; }
        public string SubCategoryID { get; set; }
        public string RevenueID { get; set; }
        public string RevenueName { get; set; }
        public string CostCentreID { get; set; }
        public string CostCentreName { get; set; }
    }
    [WebMethod]
    public static string MappingUpdate(List<UpdateMapItem> Data)
    {
        int len = Data.Count;
        if (len > 0)
        {

            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction();
            try
            {
                for (int i = 0; i < Data.Count; i++)
                {
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE demo_His_Mapping_Master SET IsActive=0,UpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdateDate=Now() WHERE HIS_ItemID='" + Data[i].ItemID.Split('#')[0] + "' and RevenueID='" + Data[i].RevenueID + "'  ");
                }
                tranX.Commit();
                return "1";
            }


            catch (Exception ex)
            {
                tranX.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return "0";
            }
            finally
            {
                tranX.Dispose();
                con.Close();
                con.Dispose();
            }

        }
        else
        {
            return "0";
        }
    }
    public class UpdateMapItem
    {
        public string ItemID { get; set; }
        public string RevenueID { get; set; }
    }
    [WebMethod]
    public static string bindActiveCostCentre()
    {
        DataTable dtCostCentre = StockReports.GetDataTable("SELECT c.COA_ID ID,c.COA_Name AS NAME FROM finance.coa$MASTER c WHERE c.COA_Type=1");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtCostCentre);
    }
    [WebMethod]
    public static string bindCostCentre()
    {
        DataTable dtCostCentre = StockReports.GetDataTable("SELECT c.COA_ID AS ID,c.COA_Name AS NAME FROM finance.coa$MASTER c WHERE c.COA_Type=1");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtCostCentre);
    }
    [WebMethod]
    public static string CostCentreInsert(string RevenueCentre, string ID)
    {
        if (RevenueCentre != "")
        {
            try
            {
                int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM demo_costCentre WHERE Name='" + RevenueCentre + "' and ID='" + ID + "'"));
                if (count > 0)
                {
                    return "1";
                }
                else
                {
                    // string CCID = Util.GetString(StockReports.ExecuteScalar("Select ifnull(Max(CCID),0)+1 from demo_costCentre"));
                    StockReports.ExecuteDML("INSERT INTO demo_costCentre (ID,Name,Description,CreatedBY,Isactive) VALUES('" + ID + "','" + RevenueCentre + "','','" + HttpContext.Current.Session["ID"].ToString() + "','1')");
                    return "2";
                }
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return "";
            }
        }
        else
            return "3";
    }
    [WebMethod]
    public static string CostCentrerUpdate(string RevenueCentre, string Description, string Active, string CostCentreID)
    {
        try
        {
            int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM demo_costCentre WHERE Name='" + RevenueCentre + "' "));
            if (count > 0)
                return "1";
            else
                StockReports.ExecuteDML("update demo_costCentre set Name='" + RevenueCentre + "',Description='" + Description + "',UpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdatedDate='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',Isactive='" + Active + "' where ID='" + CostCentreID + "'  ");
            StockReports.ExecuteDML("update demo_His_Mapping_Master set CostCentreName='" + RevenueCentre + "',Isactive='" + Active + "' where CostCentreID='" + CostCentreID + "'  ");
            return "2";

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
    }
    [WebMethod]
    public static string SaveWardItems()
    {
        bool Result = StockReports.ExecuteDML("Call demo_mapwards()");
        if (Result)
            return "1";
        else
            return "0";
    }
}