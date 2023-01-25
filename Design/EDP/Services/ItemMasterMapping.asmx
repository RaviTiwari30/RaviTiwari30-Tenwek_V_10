<%@ WebService Language="C#" Class="ItemMasterMapping" %>

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
using Oracle.ManagedDataAccess.Client;
using System.Collections.Generic;
using System.Linq;


[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class ItemMasterMapping : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }

    [WebMethod]
    public string BindCentre()
    {
        DataTable dt = All_LoadData.dtbind_Center();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public string BindGridItems(string centreID, string CategoryID, string SubCategoryID, string ItemName,int type)
    {
        StringBuilder sb = new StringBuilder();
        string str = "CALL ess_ItemMasterMatrix('" + centreID + "','" + CategoryID + "','" + SubCategoryID + "','" + ItemName + "'," + type + ")";
        DataTable dt = StockReports.GetDataTable(str);

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public string LoadCOA()
    {
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT COA_ID , COA_NM FROM ess.ItemMaster_FinanceCOA_Mapping ");
        dt = StockReports.GetDataTable(sb.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public string SaveFinancematrix(List<string> centreIDs, List<SaveFinanceMapping> ItemList)
    {

        var unMappedItems = ItemList.Where(i => i.RevenueID < 1).ToList();


        if (unMappedItems.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Please Map with finance first.</br><p class='patientInfo'>" + unMappedItems[0].ItemName + "</p>", message = unMappedItems });




        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            foreach (var col in ItemList)
            {
               // var CAPITAL_ITEM = Util.GetString(StockReports.ExecuteScalar("SELECT i.COA_ID FROM ess.ItemMaster_FinanceCOA_Mapping i WHERE i.COA_NM ='" + col.CAPITAL_ITEM + "' "));
               // col.CAPITAL_ITEM = CAPITAL_ITEM == "" ? "0" : CAPITAL_ITEM;
                var PURCHASE = Util.GetString(StockReports.ExecuteScalar("SELECT i.COA_ID FROM ess.ItemMaster_FinanceCOA_Mapping i WHERE i.COA_NM ='" + col.PURCHASE + "' "));
                col.PURCHASE = PURCHASE == "" ? "0" : PURCHASE;
                var CONSUMPTION = Util.GetString(StockReports.ExecuteScalar("SELECT i.COA_ID FROM ess.ItemMaster_FinanceCOA_Mapping i WHERE i.COA_NM ='" + col.CONSUMPTION + "' "));
                col.CONSUMPTION = CONSUMPTION == "" ? "0" : CONSUMPTION;
                var STOCK = Util.GetString(StockReports.ExecuteScalar("SELECT i.COA_ID FROM ess.ItemMaster_FinanceCOA_Mapping i WHERE i.COA_NM ='" + col.STOCK + "' "));
                col.STOCK = STOCK == "" ? "0" : STOCK;
                var DEPRECIATION = Util.GetString(StockReports.ExecuteScalar("SELECT i.COA_ID FROM ess.ItemMaster_FinanceCOA_Mapping i WHERE i.COA_NM ='" + col.DEPRECIATION + "' "));
                col.DEPRECIATION = DEPRECIATION == "" ? "0" : DEPRECIATION;
                var PUR_DISC = Util.GetString(StockReports.ExecuteScalar("SELECT i.COA_ID FROM ess.ItemMaster_FinanceCOA_Mapping i WHERE i.COA_NM ='" + col.PUR_DISC + "' "));
                col.PUR_DISC = PUR_DISC == "" ? "0" : PUR_DISC;
                var ASSET_REVAL = Util.GetString(StockReports.ExecuteScalar("SELECT i.COA_ID FROM ess.ItemMaster_FinanceCOA_Mapping i WHERE i.COA_NM ='" + col.ASSET_REVAL + "' "));
                col.ASSET_REVAL = ASSET_REVAL == "" ? "0" : ASSET_REVAL;
                var FIXED_ASSET = Util.GetString(StockReports.ExecuteScalar("SELECT i.COA_ID FROM ess.ItemMaster_FinanceCOA_Mapping i WHERE i.COA_NM ='" + col.FIXED_ASSET + "' "));
                col.FIXED_ASSET = FIXED_ASSET == "" ? "0" : FIXED_ASSET;
              //  var BUDGET_ITM_FLG = Util.GetString(StockReports.ExecuteScalar("SELECT i.COA_ID FROM ess.ItemMaster_FinanceCOA_Mapping i WHERE i.COA_NM ='" + col.BUDGET_ITM_FLG + "' "));
               // col.BUDGET_ITM_FLG = BUDGET_ITM_FLG == "" ? "0" : BUDGET_ITM_FLG;
                var STOCK_TRF = Util.GetString(StockReports.ExecuteScalar("SELECT i.COA_ID FROM ess.ItemMaster_FinanceCOA_Mapping i WHERE i.COA_NM ='" + col.STOCK_TRF + "' "));
                col.STOCK_TRF = STOCK_TRF == "" ? "0" : STOCK_TRF;
                var STOCK_ADJUSTMENT = Util.GetString(StockReports.ExecuteScalar("SELECT i.COA_ID FROM ess.ItemMaster_FinanceCOA_Mapping i WHERE i.COA_NM ='" + col.STOCK_ADJUSTMENT + "' "));
                col.STOCK_ADJUSTMENT = STOCK_ADJUSTMENT == "" ? "0" : STOCK_ADJUSTMENT;
                var PROVISIONAL_LIABILITY = Util.GetString(StockReports.ExecuteScalar("SELECT i.COA_ID FROM ess.ItemMaster_FinanceCOA_Mapping i WHERE i.COA_NM ='" + col.PROVISIONAL_LIABILITY + "' "));
                col.PROVISIONAL_LIABILITY = PROVISIONAL_LIABILITY == "" ? "0" : PROVISIONAL_LIABILITY;
            }


            for (int i = 0; i < centreIDs.Count; i++)
            {
                InsertMapping(centreIDs[i], ItemList, tnx, excuteCMD);
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

    private static void InsertMapping(string centreID, List<SaveFinanceMapping> ItemList, MySqlTransaction tnx, ExcuteCMD excuteCMD)
    {
        for (int i = 0; i < ItemList.Count; i++)
        {
            var item = ItemList[i];
            item.CentreID = Util.GetInt(centreID);
            excuteCMD.DML(tnx, "DELETE from ess_itemmastermapping WHERE ItemID=@ItemID AND  CentreID=@CentreID", CommandType.Text, item);
            var sqlCmd = new StringBuilder("INSERT INTO ess_itemmastermapping (CentreID,ItemID,ItemName,CAPITAL_ITEM,PURCHASE,CONSUMPTION,STOCK,DEPRECIATION,PUR_DISC,ASSET_REVAL,FIXED_ASSET,BUDGET_ITM_FLG,STOCK_TRF,STOCK_ADJUSTMENT,PROVISIONAL_LIABILITY)");
            sqlCmd.Append("VALUES (@CentreID,@ItemID,@ItemName,@CAPITAL_ITEM,@PURCHASE,@CONSUMPTION,@STOCK,@DEPRECIATION,@PUR_DISC,@ASSET_REVAL,@FIXED_ASSET,@BUDGET_ITM_FLG,@STOCK_TRF,@STOCK_ADJUSTMENT,@PROVISIONAL_LIABILITY)");
            excuteCMD.DML(tnx, sqlCmd.ToString(), CommandType.Text, item);
            int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM demo_his_mapping_master d WHERE d.HIS_ItemID='"+ item.ItemID +"' AND d.IsActive=1"));
            if (count > 0)
                excuteCMD.DML(tnx, "UPDATE f_itemmaster im SET im.IsActive=1 WHERE im.IsActive=3 AND im.ItemID=@ItemID", CommandType.Text, new { ItemID = item.ItemID });
        }
    }
    public class SaveFinanceMapping
    {
        public string ItemID { get; set; }
        public string ItemName { get; set; }
        public string CAPITAL_ITEM { get; set; }
        public string CAPITAL_ITEM_ID { get; set; }
        public string PURCHASE { get; set; }
        public string PURCHASE_ID { get; set; }
        public string CONSUMPTION { get; set; }
        public string CONSUMPTION_ID { get; set; }
        public string STOCK { get; set; }
        public string STOCK_ID { get; set; }
        public string DEPRECIATION { get; set; }
        public string DEPRECIATION_ID { get; set; }
        public string PUR_DISC { get; set; }
        public string PUR_DISC_ID { get; set; }
        public string ASSET_REVAL { get; set; }
        public string ASSET_REVAL_ID { get; set; }
        public string FIXED_ASSET { get; set; }
        public string FIXED_ASSET_ID { get; set; }
        public string BUDGET_ITM_FLG { get; set; }
        public string BUDGET_ITM_FLG_ID { get; set; }
        public string STOCK_TRF { get; set; }
        public string STOCK_TRF_ID { get; set; }
        public string STOCK_ADJUSTMENT { get; set; }
        public string STOCK_ADJUSTMENT_ID { get; set; }
        public string PROVISIONAL_LIABILITY { get; set; }
        public string PROVISIONAL_LIABILITY_ID { get; set; }
        public int CentreID { get; set; }
        public int RevenueID { get; set; }
    }
    //#region OracleGetDataTable
    //public static DataTable GetDataTable(string strQuery)
    //{
    //    OracleConnection conn = new OracleConnection(System.Configuration.ConfigurationManager.AppSettings["OracleConnectionFinance"]);

    //    if (conn.State == ConnectionState.Closed)
    //        conn.Open();

    //    DataTable dt = new DataTable();

    //    OracleCommand cmd = new OracleCommand(strQuery, conn);
    //    cmd.CommandTimeout = 180;
    //    DataSet ds = new DataSet();
    //    OracleDataAdapter da = new OracleDataAdapter();

    //    da.SelectCommand = cmd;
    //    da.Fill(ds);
    //    dt = ds.Tables[0];
    //    if (conn.State == ConnectionState.Open)
    //        conn.Close();
    //    if (conn != null)
    //    {
    //        conn.Dispose();
    //        conn = null;
    //    }
    //    return dt;
    //}
    //#endregion
}