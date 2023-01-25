using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;

/// <summary>
/// Summary description for BatchTransactionDetail
/// </summary>
public class BatchTransactionDetail
{
    public BatchTransactionDetail()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public DataTable LoadBatch()
    {
        AllSelectQuery Aq = new AllSelectQuery();
        return Aq.LoadCssdBatch();
    }

    public DataTable LoadBatchReturn()
    {
        AllSelectQuery Aq = new AllSelectQuery();
        return Aq.LoadCssdBatchReturn();
    }

    public DataTable LoadBatchDetail(string BatchNo)
    {
        AllSelectQuery Aq = new AllSelectQuery();
        return Aq.LoadCssdBatchDetail(BatchNo);
    }

    public DataTable LoadBatchDetailReturn(string BatchNo)
    {
        AllSelectQuery Aq = new AllSelectQuery();
        return Aq.LoadCssdBatchDetailReturn(BatchNo);
    }

    public string UpdateBatchDetail(string ItemData)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            ItemData = ItemData.TrimEnd('#');

            string str = "";
            int len = Util.GetInt(ItemData.Split('#').Length);
            string[] Item = new string[len];
            Item = ItemData.Split('#');
            int result = 0;

            for (int i = 0; i < len; i++)
            {
                
                StringBuilder sb = new StringBuilder();
                sb.Append("      SELECT SetID,SetStockId FROM  ");
                sb.Append("  cssd_f_batch_tnxdetails where BatchNo='" + Item[i].Split('|')[0].ToString() + "' and IsProcess=1   ");
                DataTable dt = StockReports.GetDataTable(sb.ToString());

                str = "update cssd_f_batch_tnxdetails set AstartDate ='" + Util.GetDateTime(Item[i].Split('|')[1].ToString()).ToString("yyyy-MM-dd HH:mm:ss") + "',AEndDate ='" + Util.GetDateTime(Item[i].Split('|')[2].ToString()).ToString("yyyy-MM-dd HH:mm:ss") + "',RemarkSec='" + Item[i].Split('|')[3].ToString() + "',IsProcess=2 WHERE BatchNo ='" + Item[i].Split('|')[0].ToString() + "' and IsProcess=1 ";
                result = MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);
                for (int j = 0; j < dt.Rows.Count; j++)
                {
                    string setid = dt.Rows[j]["SetID"].ToString();
                    string SetstockId = dt.Rows[j]["SetStockId"].ToString();
                    if (setid != "")
                    {
                        str = "UPDATE cssd_f_set_master set IsSet=0 WHERE set_ID='" + setid + "'";
                        result = MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);
                        str = "UPDATE cssd_recieve_set_stock set IsUpdateBatch=1 WHERE setID='" + setid + "' and IsProcessBatch=1 and IsSetMaster=1 and setstockid='" + SetstockId + "'";
                        result = MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);
                    }
                }
                //
            }
            if (result > 0)
            {
                Tnx.Commit();
                con.Close();
                con.Dispose();
                return "1";
            }
            else
            {
                Tnx.Rollback();
                con.Close();
                con.Dispose();
                return "0";
            }
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            con.Close();
            con.Dispose();
            throw (ex);
        }
    }

    public string ReturnBatchData(string ItemData)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            ItemData = ItemData.TrimEnd('#');

            int len = Util.GetInt(ItemData.Split('#').Length);
            string[] Item = new string[len];
            Item = ItemData.Split('#');
            //str = "update cssd_set_itemdetail set Isactive=0 WHERE SetID ='" + Item[0].Split('|')[1].ToString() + "' ";

            int IsSet = 0;
            for (int j = 0; j < len; j++)
            {
                IsSet = Util.GetInt(Item[j].Split('|')[6].ToString());
                if (IsSet == 0)
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append("  SELECT st.itemid,st.fromStockID,st.FromDept,st.DeptLedgerNo,StockID,(st.InitialCount-st.ReleasedCount-st.PendingQty)AvailQty,ST.ItemName, ");
                    sb.Append("  ST.BatchNumber,ST.UnitPrice,ST.MRP,DATE_FORMAT(st.PostDate,'%d-%b-%y') AS DATE FROM f_stock st WHERE ");
                    sb.Append("  stockid='" + Item[j].Split('|')[3].ToString() + "'  AND (st.InitialCount-st.ReleasedCount-st.PendingQty)>0 ");
                    DataTable dtItem = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, sb.ToString()).Tables[0];

                    string strCssdTnx = "update cssd_f_batch_tnxdetails set IsProcess=3,Isreturn=1,ReturnDateTime='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',ReturnBy='" + HttpContext.Current.Session["ID"].ToString() + "' WHERE ID ='" + Item[j].Split('|')[0].ToString() + "' ";
                    int CssdTnx = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strCssdTnx);

                    int SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select Get_SalesNo('2','" + AllGlobalFunction.MedicalStoreID + "','" + HttpContext.Current.Session["CentreID"].ToString() + "') "));
                    int SubStoreSalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select Get_SalesNo('15','" + AllGlobalFunction.MedicalStoreID + "','" + HttpContext.Current.Session["CentreID"].ToString() + "') "));

                    for (int i = 0; i < dtItem.Rows.Count; i++)
                    {
                        //---------------- Insert into Sales Details Table For Main Store-----------

                        Sales_Details ObjSales = new Sales_Details(Tranx);
                        ObjSales.LedgerNumber = Util.GetString(dtItem.Rows[i]["DeptLedgerNo"]);
                        ObjSales.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                        ObjSales.DepartmentID = "STO00001";
                        ObjSales.StockID = Util.GetString(dtItem.Rows[i]["fromStockID"]);
                        ObjSales.SoldUnits = Util.GetDecimal(Item[j].Split('|')[5].ToString());
                        ObjSales.PerUnitBuyPrice = Util.GetDecimal(dtItem.Rows[i]["UnitPrice"]);
                        ObjSales.PerUnitSellingPrice = Util.GetDecimal(dtItem.Rows[i]["MRP"]);
                        ObjSales.TrasactionTypeID = 2;
                        ObjSales.ItemID = Util.GetString(dtItem.Rows[i]["ItemID"]);
                        ObjSales.Naration = "Return From Cssd";
                        ObjSales.Date = DateTime.Now;
                        ObjSales.Time = DateTime.Now;
                        ObjSales.SalesNo = SalesNo;
                        ObjSales.UserID = HttpContext.Current.Session["ID"].ToString();
                        ObjSales.IsReturn = 1;
                        ObjSales.DeptLedgerNo = Util.GetString(dtItem.Rows[i]["FromDept"]);
                        string SalesID = ObjSales.Insert();
                        if (SalesID == string.Empty)
                        {
                            Tranx.Rollback();
                            Tranx.Dispose();
                            con.Close();
                            con.Dispose();
                            return string.Empty;
                        }

                        //---------------- Insert into Sales Details Table For Sub Store-----------
                        ObjSales.StockID = Util.GetString(dtItem.Rows[i]["StockID"]);
                        ObjSales.SalesNo = SubStoreSalesNo;
                        ObjSales.LedgerNumber = Util.GetString(dtItem.Rows[i]["FromDept"]);
                        ObjSales.DeptLedgerNo = Util.GetString(dtItem.Rows[i]["DeptLedgerNo"]);
                        ObjSales.TrasactionTypeID = 15;
                        string SubStoreSalesID = ObjSales.Insert();
                        if (SubStoreSalesID == string.Empty)
                        {
                            Tranx.Rollback();
                            Tranx.Dispose();
                            con.Close();
                            con.Dispose();
                            return string.Empty;
                        }

                        //----Check Release Count in Stock Table---------------------
                        string str = "select if(InitialCount < (ReleasedCount+" + Util.GetFloat(Item[j].Split('|')[5].ToString()) +
                            "),0,1)CHK from f_stock where stockID='" + Util.GetString(dtItem.Rows[i]["StockID"]) + "'";
                        if (Util.GetInt(MySqlHelperNEw.ExecuteScalar(Tranx, CommandType.Text, str)) <= 0)
                        {
                            Tranx.Rollback();
                            con.Close();
                            con.Dispose();
                            return string.Empty;
                        }

                        //----Check Release Count in Stock Table---------------------
                        str = "select if(0 > (ReleasedCount-" + Util.GetFloat(Item[j].Split('|')[5].ToString()) +
                            "),0,1)CHK from f_stock where stockID='" + Util.GetString(dtItem.Rows[i]["fromStockID"]) + "'";
                        if (Util.GetInt(MySqlHelperNEw.ExecuteScalar(Tranx, CommandType.Text, str)) <= 0)
                        {
                            Tranx.Rollback();
                            con.Close();
                            con.Dispose();
                            return string.Empty;
                        }

                        //---- Update Release Count in Stock Table and DepartmentwiseStock---------------------

                        string strStock = "update f_stock set ReleasedCount=ReleasedCount - '" + Util.GetFloat(Item[j].Split('|')[5].ToString()) + "' where Stockid = '" + Util.GetString(dtItem.Rows[i]["fromStockID"]) + "'";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strStock);

                        string strStock1 = "update f_stock set ReleasedCount=ReleasedCount + '" + Util.GetFloat(Item[j].Split('|')[5].ToString()) + "' where Stockid = '" + Util.GetString(dtItem.Rows[i]["StockID"]) + "'  ";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strStock1);
                    }
                }
                else
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append("  SELECT st.itemid,st.fromStockID,st.FromDept,st.DeptLedgerNo,StockID,(st.InitialCount-st.ReleasedCount-st.PendingQty)AvailQty,ST.ItemName, ");
                    sb.Append("  ST.BatchNumber,ST.UnitPrice,ST.MRP,DATE_FORMAT(st.PostDate,'%d-%b-%y') AS DATE FROM f_stock st WHERE ");
                    sb.Append("  stockid='" + Item[j].Split('|')[3].ToString() + "'  AND (st.InitialCount-st.ReleasedCount-st.PendingQty)>0 ");
                    DataTable dtItem = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, sb.ToString()).Tables[0];

                    string strCssdTnx = "update cssd_f_batch_tnxdetails set IsProcess=3,Isreturn=1,ReturnDateTime='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',ReturnBy='" + HttpContext.Current.Session["ID"].ToString() + "' WHERE ID ='" + Item[j].Split('|')[0].ToString() + "' ";
                    int CssdTnx = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strCssdTnx);

                    string strSetStock = " UPDATE cssd_recieve_set_stock SET ReturnedQty='" + Util.GetFloat(Item[j].Split('|')[5].ToString()) + "',IsReturned=1 WHERE SetStockID='" + Item[j].Split('|')[2].ToString() + "' ";
                    int SetStock = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strSetStock);

                    int SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select Get_SalesNo('2','" + AllGlobalFunction.MedicalStoreID + "','" + HttpContext.Current.Session["CentreID"].ToString() + "')"));

                    int SubStoreSalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select Get_SalesNo('15','" + AllGlobalFunction.MedicalStoreID + "','" + HttpContext.Current.Session["CentreID"].ToString() + "')"));

                    for (int i = 0; i < dtItem.Rows.Count; i++)
                    {
                        Sales_Details ObjSales = new Sales_Details(Tranx);
                        ObjSales.LedgerNumber = Util.GetString(dtItem.Rows[i]["DeptLedgerNo"]);
                        ObjSales.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                        ObjSales.DepartmentID = "STO00001";
                        ObjSales.StockID = Util.GetString(dtItem.Rows[i]["fromStockID"]);
                        ObjSales.SoldUnits = Util.GetDecimal(Item[j].Split('|')[5].ToString());
                        ObjSales.PerUnitBuyPrice = Util.GetDecimal(dtItem.Rows[i]["UnitPrice"]);
                        ObjSales.PerUnitSellingPrice = Util.GetDecimal(dtItem.Rows[i]["MRP"]);
                        ObjSales.TrasactionTypeID = 2;
                        ObjSales.ItemID = Util.GetString(dtItem.Rows[i]["ItemID"]);
                        ObjSales.Naration = "Return From Cssd";
                        ObjSales.Date = DateTime.Now;
                        ObjSales.Time = DateTime.Now;
                        ObjSales.SalesNo = SalesNo;
                        ObjSales.UserID = HttpContext.Current.Session["ID"].ToString();
                        ObjSales.IsReturn = 1;
                        ObjSales.DeptLedgerNo = Util.GetString(dtItem.Rows[i]["FromDept"]);
                        string SalesID = ObjSales.Insert();
                        if (SalesID == string.Empty)
                        {
                            Tranx.Rollback();
                            Tranx.Dispose();
                            con.Close();
                            con.Dispose();
                            return string.Empty;
                        }

                        //---------------- Insert into Sales Details Table For Sub Store-----------
                        ObjSales.StockID = Util.GetString(dtItem.Rows[i]["StockID"]);
                        ObjSales.SalesNo = SubStoreSalesNo;
                        ObjSales.LedgerNumber = Util.GetString(dtItem.Rows[i]["FromDept"]);
                        ObjSales.DeptLedgerNo = Util.GetString(dtItem.Rows[i]["DeptLedgerNo"]);
                        ObjSales.TrasactionTypeID = 15;
                        string SubStoreSalesID = ObjSales.Insert();
                        if (SubStoreSalesID == string.Empty)
                        {
                            Tranx.Rollback();
                            Tranx.Dispose();
                            con.Close();
                            con.Dispose();
                            return string.Empty;
                        }

                        //----Check Release Count in Stock Table---------------------
                        string str = "select if(InitialCount < (ReleasedCount+" + Util.GetFloat(Item[j].Split('|')[5].ToString()) +
                            "),0,1)CHK from f_stock where stockID='" + Util.GetString(dtItem.Rows[i]["StockID"]) + "'";
                        if (Util.GetInt(MySqlHelperNEw.ExecuteScalar(Tranx, CommandType.Text, str)) <= 0)
                        {
                            Tranx.Rollback();
                            con.Close();
                            con.Dispose();
                            return string.Empty;
                        }

                        //----Check Release Count in Stock Table---------------------
                        str = "select if(0 > (ReleasedCount-" + Util.GetFloat(Item[j].Split('|')[5].ToString()) +
                            "),0,1)CHK from f_stock where stockID='" + Util.GetString(dtItem.Rows[i]["fromStockID"]) + "'";
                        if (Util.GetInt(MySqlHelperNEw.ExecuteScalar(Tranx, CommandType.Text, str)) <= 0)
                        {
                            Tranx.Rollback();
                            con.Close();
                            con.Dispose();
                            return string.Empty;
                        }

                        //---- Update Release Count in Stock Table and DepartmentwiseStock---------------------

                        string strStock = "update f_stock set ReleasedCount=ReleasedCount - '" + Util.GetFloat(Item[j].Split('|')[5].ToString()) + "' where Stockid = '" + Util.GetString(dtItem.Rows[i]["fromStockID"]) + "'";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strStock);

                        string strStock1 = "update f_stock set ReleasedCount=ReleasedCount + '" + Util.GetFloat(Item[j].Split('|')[5].ToString()) + "' where Stockid = '" + Util.GetString(dtItem.Rows[i]["StockID"]) + "'  ";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strStock1);
                    }
                }
            }

            Tranx.Commit();
            con.Close();
            con.Dispose();
            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            con.Close();
            con.Dispose();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
    }

    public DataTable BtchProcessDateTime(string BatchNo)
    {
        AllSelectQuery Aq = new AllSelectQuery();
        return Aq.BtchProcessDateTime(BatchNo);

    }
}